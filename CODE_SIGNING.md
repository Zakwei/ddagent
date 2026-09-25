# Code signing policy

ddagent release artifacts are built from this repository by GitHub Actions and published on
[GitHub Releases](https://github.com/Zakwei/ddagent/releases). The signing method differs by
platform.

## Windows — SignPath Foundation (pending)

We are applying to the SignPath Foundation open source program.

Planned statement (required by the program, once approved):

> Free code signing provided by [SignPath.io](https://signpath.io), certificate by
> [SignPath Foundation](https://signpath.org)

Status: pending approval. Until then, Windows installers are distributed unsigned.

### What will be signed

- Windows installer packages (`.exe`, NSIS) published on GitHub Releases.

### Build and signing process

- Artifacts are built from this repository by the public
  [`desktop-release.yml`](.github/workflows/desktop-release.yml) GitHub Actions workflow,
  triggered only by version tags.
- Only CI-built artifacts will be submitted to SignPath for signing, with origin verification
  back to this repository.
- The private key is held by SignPath (HSM-backed). This project does not store the private key.
- Each signing request requires manual approval by a maintainer.

### Team roles (single-maintainer project)

- Authors (commit access, can modify the repository without additional reviews):
  - [@Zakwei](https://github.com/Zakwei) (Dawid Wasiczek)
- Reviewers (review required for changes proposed by non-committers, e.g. pull requests):
  - [@Zakwei](https://github.com/Zakwei)
  - Policy: all external pull requests are reviewed by the maintainer before merge.
- Approvers (approve each signing request):
  - [@Zakwei](https://github.com/Zakwei)
  - Policy: each signing request requires explicit approval by the maintainer.

## macOS

Status: unsigned. macOS builds (`.dmg`) are distributed unsigned for now; signing requires an
Apple Developer ID, which is a separate pending decision.

## Linux

Status: unsigned. Linux artifacts (AppImage, `.deb`) are distributed unsigned. Artifact signing
(e.g. Sigstore/cosign or GPG) may be added in a future release.

## Mobile (Android)

The Android APK is signed with an EAS-managed keystore (Google Play / Expo application signing),
not with a SignPath certificate.

## Distribution locations

- <https://github.com/Zakwei/ddagent/releases> — the only official download page.

## Privacy policy

- ddagent is a self-hosted orchestrator for coding agents. Network traffic goes only to the
  systems the user configures: the user's own server instance and the AI provider endpoints the
  user selects (e.g. Anthropic, OpenAI) using the user's own credentials.
- The desktop app checks GitHub Releases for application updates (electron-updater). No usage
  data is sent with update checks.
- The project collects no telemetry and no analytics.
- This program will not transfer any information to other networked systems unless specifically
  requested by the user or the person installing or operating it.
