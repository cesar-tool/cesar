# cesar

Cesar syncs the conversations you have with your coding agents (Claude Code,
Codex, Cursor) between your machines, lets you share the ones you choose with
your team, and compiles what a team worked out into a shared brain its agents
can consult. Conversations are encrypted on your machine before they leave it.

More at [getcesar.dev](https://getcesar.dev). This repository holds the
releases of the `cesar` command-line tool. Its source code is not public.

## Install

macOS, or Linux with Homebrew:

```sh
brew install cesar-tool/tap/cesar
```

macOS or Linux, without Homebrew:

```sh
curl -fsSL https://raw.githubusercontent.com/cesar-tool/cesar/main/install.sh | sh
```

The script is [in this repository](install.sh), short enough to read first.
It downloads the latest release for your machine, checks its SHA-256 against
the release's `checksums.txt`, and puts `cesar` in `~/.local/bin`. It never
asks for sudo. `CESAR_VERSION=v0.2.0-beta.1` installs a given version and
`CESAR_INSTALL_DIR=/some/dir` chooses another folder.

Then:

```sh
cesar login
cesar help
```

## Upgrade and uninstall

Run the install command again to upgrade (`brew upgrade cesar` with
Homebrew). To uninstall, run `cesar uninstall` if you had run
`cesar install`, then delete the binary (`brew uninstall cesar`, or
`rm ~/.local/bin/cesar`). Your settings are in `~/.cesar`.

## Checking a download by hand

Each release has one archive per system and a `checksums.txt`:

```sh
shasum -a 256 cesar_darwin_arm64.tar.gz    # compare with the line in checksums.txt
```

The binaries are built for macOS and Linux, 64-bit Intel/AMD and ARM. They
are not signed with an Apple certificate yet: installed with Homebrew or the
script they run as they are; downloaded with a browser, macOS will ask you
to allow them.

## Licence

Cesar is in beta. The tool is free to use during the beta, under the terms
in [LICENSE](LICENSE). It includes open-source components under their own
licences, reproduced in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
