# Homebrew tap for Ledgerful

Official [Homebrew](https://brew.sh) tap for the [Ledgerful](https://github.com/Ryan-AI-Studios/Ledgerful) CLI.

| | |
|---|---|
| **Engine repo** | [Ryan-AI-Studios/Ledgerful](https://github.com/Ryan-AI-Studios/Ledgerful) |
| **Install page** | [ledgerful.dev/install](https://ledgerful.dev/install) |
| **License** | PolyForm Noncommercial 1.0.0 + small-entity commercial exception (see below) |

This repository is formula-only (CLI **formula**, not a cask). Release automation in the engine repo rewrites `ledgerful.rb` version + per-arch `sha256` from published `*.sha256` assets on each tag.

## Install

```bash
brew install Ryan-AI-Studios/tap/ledgerful
```

Equivalent two-step form:

```bash
brew tap Ryan-AI-Studios/tap
brew install ledgerful
```

Then:

```bash
ledgerful --version
```

Supported platforms (prebuilt release archives):

| Platform | Archive |
|---|---|
| macOS Apple Silicon | `ledgerful-aarch64-apple-darwin.tar.gz` |
| macOS Intel | `ledgerful-x86_64-apple-darwin.tar.gz` |
| Linux x86_64 | `ledgerful-x86_64-unknown-linux-gnu.tar.gz` |

Hashes are pinned to the published release checksum sidecars (never recomputed locally by the bump scripts).

## Update

```bash
brew update
brew upgrade ledgerful
```

## Uninstall

```bash
brew uninstall ledgerful
# optional: remove the tap
brew untap Ryan-AI-Studios/tap
```

## macOS Gatekeeper / quarantine

Current release binaries are **not** Apple-codesigned or notarized. Homebrew formula installs usually avoid browser-applied quarantine, but if Gatekeeper reports *"developer cannot be verified"* on first run:

```bash
xattr -d com.apple.quarantine "$(which ledgerful)"
```

The proper long-term fix is codesign + notarize in the engine release pipeline (upstream of this tap).

## Layout (load-bearing)

```text
ledgerful.rb              # formula at repo root (NOT Formula/ledgerful.rb)
LICENSE                   # PolyForm Noncommercial 1.0.0
COMMERCIAL-EXCEPTION.md   # small-entity exception
```

**Root path is intentional.** Engine release job `bump-manifests` pushes to `ledgerful.rb` at the tap root. Do not move the formula under `Formula/` without updating that push path in the same change.

## License

Source for Ledgerful is **PolyForm Noncommercial 1.0.0** with a small-entity commercial exception. See:

- [`LICENSE`](./LICENSE)
- [`COMMERCIAL-EXCEPTION.md`](./COMMERCIAL-EXCEPTION.md)

The formula declares `license :cannot_represent` because Homebrew cannot encode PolyForm Noncommercial + the companion exception as a single SPDX identifier. This is packaging metadata only — it is **not** a change to the product license.

## Maintenance

- Formula template lives in-engine at `packaging/homebrew/ledgerful.rb`.
- On each engine release, `scripts/bump-manifests.*` rewrites version + hashes from published `*.sha256` files only.
- When secret `MANIFEST_PUSH_TOKEN` is configured, release CI commits the bumped `ledgerful.rb` here automatically.
- Manual seed / review PRs may still land on this repo for structure changes (README, CI, license).

## Related distribution channels

- Scoop: [Ryan-AI-Studios/scoop-bucket](https://github.com/Ryan-AI-Studios/scoop-bucket)
- winget: `Ledgerful.Ledgerful` (external review on `microsoft/winget-pkgs`)
- `cargo binstall --git https://github.com/Ryan-AI-Studios/Ledgerful`
- One-line installers: see [installation docs](https://github.com/Ryan-AI-Studios/Ledgerful/blob/main/docs/installation.md)
