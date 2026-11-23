#!/bin/sh
# Installs the cesar command-line tool, or upgrades it:
#
#   curl -fsSL https://raw.githubusercontent.com/cesar-tool/cesar/main/install.sh | sh
#
# It downloads the latest release for this machine, checks it against the
# release's checksums, and puts the binary in ~/.local/bin. No sudo.
#
#   CESAR_VERSION=v0.2.0-beta.1   a version other than the latest
#   CESAR_INSTALL_DIR=/some/dir   another folder than ~/.local/bin
#
# Using cesar means accepting its licence:
# https://github.com/cesar-tool/cesar/blob/main/LICENSE
set -eu

# Everything is in a function called on the last line, so that a download
# of this script cut short runs nothing.
main() {
	repo="https://github.com/cesar-tool/cesar"
	dir="${CESAR_INSTALL_DIR:-$HOME/.local/bin}"

	case "$(uname -s)" in
	Darwin) os=darwin ;;
	Linux) os=linux ;;
	*) fail "cesar is built for macOS and Linux, not for $(uname -s)." ;;
	esac
	case "$(uname -m)" in
	x86_64 | amd64) arch=amd64 ;;
	arm64 | aarch64) arch=arm64 ;;
	*) fail "cesar is built for 64-bit Intel/AMD and ARM, not for $(uname -m)." ;;
	esac

	if [ -n "${CESAR_VERSION:-}" ]; then
		base="$repo/releases/download/$CESAR_VERSION"
	else
		base="$repo/releases/latest/download"
	fi
	# For trying the script against files that are not on GitHub.
	base="${CESAR_DOWNLOAD_BASE:-$base}"

	archive="cesar_${os}_${arch}.tar.gz"
	tmp="$(mktemp -d)"
	trap 'rm -rf "$tmp"' EXIT

	echo "Downloading $archive..."
	curl -fsSL -o "$tmp/$archive" "$base/$archive" || fail "Could not download $base/$archive"
	curl -fsSL -o "$tmp/checksums.txt" "$base/checksums.txt" || fail "Could not download $base/checksums.txt"

	want="$(grep " $archive\$" "$tmp/checksums.txt" | cut -d' ' -f1)"
	if command -v sha256sum >/dev/null 2>&1; then
		got="$(sha256sum "$tmp/$archive" | cut -d' ' -f1)"
	else
		got="$(shasum -a 256 "$tmp/$archive" | cut -d' ' -f1)"
	fi
	if [ -z "$want" ] || [ "$want" != "$got" ]; then
		fail "The download does not match its checksum. Nothing was installed."
	fi

	tar -xzf "$tmp/$archive" -C "$tmp"
	mkdir -p "$dir"
	mv "$tmp/cesar" "$dir/cesar"
	chmod 755 "$dir/cesar"

	echo "Installed cesar $("$dir/cesar" version) in $dir"
	case ":$PATH:" in
	*":$dir:"*) ;;
	*)
		echo "$dir is not in your PATH. Add this line to your shell's profile:"
		echo "  export PATH=\"$dir:\$PATH\""
		;;
	esac
	echo "Next: cesar login"
}

fail() {
	echo "$1" >&2
	exit 1
}

main
