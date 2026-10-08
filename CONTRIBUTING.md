# Contributing to ddagent

Thanks for your interest in contributing to ddagent! Please read this guide before you start.

## Before You Start

- **Search first.** Check [existing issues](https://github.com/Zakwei/ddagent/issues) and [pull requests](https://github.com/Zakwei/ddagent/pulls) to avoid duplicate work.
- **Discuss new features first.** Open an [issue](https://github.com/Zakwei/ddagent/issues/new) before investing time in an implementation — we may already have plans or opinions on how it should work.
- **Bug fixes are always welcome.** If you spot a bug, feel free to open a PR directly.
- **Security issues** go through private reporting — see [SECURITY.md](SECURITY.md).

## Prerequisites

- [Node.js](https://nodejs.org/) 22 or later (CI uses Node 22)
- At least one supported agent CLI installed and signed in — e.g. [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Codex, Cursor CLI, OpenCode, Devin, Command Code or Antigravity
- For client work: [Flutter](https://docs.flutter.dev/get-started/install) 3.47.5 (stable), the version pinned in CI. Linux desktop builds also need `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libsecret-1-dev`; Android builds need Java 17.

## Getting Started

1. Fork the repository.
2. Clone your fork:
   ```bash
   git clone https://github.com/<your-username>/ddagent.git
   cd ddagent
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Start the backend from source (API on `http://localhost:3001`):
   ```bash
   npm run server:dev-watch
   ```
5. In another terminal, run the client against it:
   ```bash
   cd flutter
   flutter pub get
   flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
   ```
6. Create a branch for your changes:
   ```bash
   git checkout -b feat/your-feature-name
   ```

## Project Structure

```
ddagent/
├── server/            # Express + WebSocket backend (TypeScript)
│   ├── modules/       # Feature modules (auth, providers, websocket, git, kanban, …)
│   └── shared/        # Shared backend interfaces, types and utilities
├── flutter/           # Flutter client (web, Linux, Windows, Android)
│   └── packaging/     # Linux .deb and Windows installer scripts
├── shared/            # Small JS helpers used by the server entrypoint
├── scripts/           # Build, release and dev helper scripts
├── docker/            # Docker Sandbox templates
├── docs/              # Feature docs and translated READMEs
├── public/            # Static files served by the server (API docs, icons, screenshots)
└── redirect-package/  # npm redirect package (@ddagent/ddagent → @ddagent-ai/ddagent)
```

## Development Workflow

### Server

- `npm run dev` — start the backend from source with tsx (no reload)
- `npm run server:dev-watch` — same, restarting on file changes
- `npm run build` — compile the server to `dist-server/`
- `npm test` — backend tests
- `npm run typecheck` — TypeScript check
- `npm run lint` — ESLint (`npm run lint:fix` to auto-fix)

Backend code follows the module architecture in `server/modules/`; see `server/modules/providers/README.md` before touching provider code.

### Client (Flutter)

```bash
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after changing freezed/json models
dart format --line-length 100 lib test
flutter analyze
flutter test
```

Always format with `--line-length 100`; CI fails on any formatting diff.

### CI checks

Run the same checks locally before opening a PR:

| Area | Workflow | Checks |
|---|---|---|
| Server | `server-ci.yml` | `npm run typecheck`, `npm run lint`, `npm test`, `npm run build` |
| Client | `flutter-ci.yml` | `dart format --line-length 100 --set-exit-if-changed lib test`, `flutter analyze`, `flutter test` |

On `main`, `flutter-ci.yml` also builds the Android (debug APK), web, Linux and Windows clients.

## Making Changes

### Bug Fixes

- Reference the issue number in your PR if one exists
- Describe how to reproduce the bug
- Add a screenshot or recording for visual bugs

### New Features

- Keep the scope focused — one feature per PR
- Include screenshots or recordings for UI changes
- Add user-facing strings to every locale in `flutter/lib/i18n/` (English is the fallback)

### Documentation

- Documentation improvements are always welcome
- Keep language clear and concise

## Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/) (`@commitlint/config-conventional`, see `commitlint.config.js`); release notes are drafted from the commit log. Every commit message should follow this format:

```
<type>(optional scope): <description>
```

Use the imperative, present tense: "add feature", not "added feature" or "adds feature".

### Types

| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `perf` | A performance improvement |
| `refactor` | A code change that neither fixes a bug nor adds a feature |
| `docs` | Documentation only |
| `style` | Formatting or whitespace only (no behavior change) |
| `test` | Adding or updating tests |
| `build` | Build system or dependency changes |
| `ci` | CI/CD pipeline changes |
| `chore` | Maintenance and other changes that don't touch source or tests |
| `revert` | Reverts a previous commit |

### Examples

```bash
feat: add conversation search
feat(i18n): add Japanese translations
fix: redirect unauthenticated users to login
fix(editor): syntax highlighting for .env files
perf(chat): virtualize long transcripts
refactor(chat): extract message list widget
docs: update configuration guide
```

### Breaking Changes

Add `!` after the type or scope, or include `BREAKING CHANGE:` in the commit footer:

```bash
feat!: redesign settings page layout
```

## Pull Requests

- Give your PR a clear, descriptive title that follows the commit convention above
- Describe what changed and why
- Link any related issues
- Include screenshots for UI changes
- Make sure the CI checks above pass
- Keep PRs focused — avoid unrelated changes
- By contributing, you agree that your changes are licensed under the project's license (AGPL-3.0-only, see `LICENSE`)

## Releases

Releases are tag-driven. Maintainers bump the version with:

```bash
npm run release -- patch   # or minor / major / x.y.z
```

This bumps `package.json`, `package-lock.json` and `flutter/pubspec.yaml`, then creates the release commit and the `vX.Y.Z` tag (never tag by hand — CI requires the tag to match `package.json`). Pushing the tag (`git push origin HEAD vX.Y.Z`) runs two workflows that publish to one draft GitHub Release, pre-seeded with per-locale notes:

- `server-release.yml` — server tarballs (`linux-x64`, `mac-arm64`, `win-x64`) and `install.sh`
- `flutter-release.yml` — web zip, Linux tarball and `.deb`, Windows zip and installer, Android APK and AAB

Fill in the release notes for all 12 locales before publishing. `CHANGELOG.md` is updated by hand.
