# Contributing to ddagent UI

Thanks for your interest in contributing to ddagent UI! Before you start, please take a moment to read through this guide.

## Before You Start

- **Search first.** Check [existing issues](https://github.com/Zakwei/ddagent/issues) and [pull requests](https://github.com/Zakwei/ddagent/pulls) to avoid duplicating work.
- **Discuss first** for new features. Open an [issue](https://github.com/Zakwei/ddagent/issues/new) to discuss your idea before investing time in implementation. We may already have plans or opinions on how it should work.
- **Bug fixes are always welcome.** If you spot a bug, feel free to open a PR directly.

## Prerequisites

- [Node.js](https://nodejs.org/) 22 or later
- At least one supported agent CLI installed — e.g. [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Codex, Cursor CLI, OpenCode or Devin

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/<your-username>/ddagent.git
   cd ddagent
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Start the development server:
   ```bash
   npm run dev
   ```
5. Create a branch for your changes:
   ```bash
   git checkout -b feat/your-feature-name
   ```

## Project Structure

```
ddagent/
├── src/              # React frontend (Vite + Tailwind)
│   ├── components/   # UI components
│   ├── contexts/     # React context providers
│   ├── hooks/        # Custom React hooks
│   ├── i18n/         # Translations (11 languages)
│   ├── lib/          # Shared frontend libraries
│   ├── types/        # TypeScript type definitions
│   └── utils/        # Frontend utilities
├── server/           # Express backend
│   ├── modules/      # Feature modules (auth, providers, websocket, git, …)
│   └── shared/       # Shared backend interfaces and types
├── electron/         # Desktop companion app
├── docker/           # Docker sandbox templates
├── redirect-package/ # npm redirect package (@ddagent/ddagent)
├── shared/           # Code shared between client and server
└── public/           # Static assets, icons, PWA manifest
```

## Development Workflow

- `npm run dev` — Start backend + frontend (Vite HMR) in development mode
- `npm run server:dev` — Backend only (tsx, watch mode via `server:dev-watch`)
- `npm run client` — Vite dev server only
- `npm run build` — Production build (`build:client` + `build:server`)
- `npm run test:client` / `npm test` — Frontend / backend tests
- `npm run typecheck` — TypeScript check

## Making Changes

### Bug Fixes

- Reference the issue number in your PR if one exists
- Describe how to reproduce the bug in your PR description
- Add a screenshot or recording for visual bugs

### New Features

- Keep the scope focused — one feature per PR
- Include screenshots or recordings for UI changes

### Documentation

- Documentation improvements are always welcome
- Keep language clear and concise

## Commit Convention

We follow [Conventional Commits](https://conventionalcommits.org/) to generate release notes automatically. Every commit message should follow this format:

```
<type>(optional scope): <description>
```

Use imperative, present tense: "add feature" not "added feature" or "adds feature".

### Types

| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `perf` | A performance improvement |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `docs` | Documentation only |
| `style` | CSS, formatting, visual changes |
| `chore` | Maintenance, dependencies, config |
| `ci` | CI/CD pipeline changes |
| `test` | Adding or updating tests |
| `build` | Build system changes |

### Examples

```bash
feat: add conversation search
feat(i18n): add Japanese language support
fix: redirect unauthenticated users to login
fix(editor): syntax highlighting for .env files
perf: lazy load code editor component
refactor(chat): extract message list component
docs: update API configuration guide
```

### Breaking Changes

Add `!` after the type or include `BREAKING CHANGE:` in the commit footer:

```bash
feat!: redesign settings page layout
```

## Pull Requests

- Give your PR a clear, descriptive title following the commit convention above
- Fill in the PR description with what changed and why
- Link any related issues
- Include screenshots for UI changes
- Make sure the build passes (`npm run build`)
- Keep PRs focused — avoid unrelated changes
- By contributing you agree your changes are licensed under the project's license (AGPL-3.0-only, see `LICENSE`)

## Releases

Releases are managed by maintainers using [release-it](https://github.com/release-it/release-it) with the [conventional changelog plugin](https://github.com/release-it/conventional-changelog).

```bash
npm run release           # interactive (prompts for version bump)
npm run release -- patch  # patch release
npm run release -- minor  # minor release
```

This automatically:
- Bumps the version based on commit types (`feat` = minor, `fix` = patch)
- Generates categorized release notes
- Updates `CHANGELOG.md`
- Creates a git tag and GitHub Release
- Publishes to npm

