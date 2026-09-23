# Changelog

All notable changes to ddagent are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [0.5.8] - 2026-09-23

### Added

- `install.sh` — git-based server installer (`--version`, `--dir`, `--port`, `--systemd`)
- Standalone and local server tarballs published on `v*` tags

### Fixed

- Mobile keyboard covering the composer and content under the system nav bar (Android)

## [0.5.7] - 2026-09-23

### Fixed

- Desktop CI builds (bundle platform flag, native rebuilds, smoke timeouts)
- Duplicate streamed assistant messages in chat transcripts

## [0.5.6] - 2026-09-23

### Fixed

- Desktop CI: unsigned macOS builds when Apple secrets are absent, Windows scoped-package staging

## [0.5.5] - 2026-09-23

### Added

- **Desktop app (preview)** — Electron launcher for local or remote servers, embedded backend, auto-update, dmg/NSIS/AppImage/deb builds
- **Mobile app (preview)** — Expo/React Native companion: sessions, chat with model picker and slash commands, terminal, files, settings WebViews
- Unread indicator on sessions with unseen output; task board ↔ session linking
- KaTeX and Mermaid islands in chat

### Fixed

- Touch targets and layouts across mobile viewports; command palette, kanban, and settings polish

## [0.5.4] - 2026-09-21

### Added

- Restart-server button with full-screen progress overlay (Settings → About)
- Localized GitHub releases changelog in Settings → About
- Running session count in the browser tab title
- Y-axis scale and hover tooltips on the usage trend chart

### Fixed

- Settings auto-save firing on modal open; compact chat layout in multi-row splits

## [0.5.3] - 2026-09-21

### Fixed

- Update-available dialog hidden behind the rail (portal fix)

## [0.5.2] - 2026-09-21

### Fixed

- Update check routed through the server

## [0.5.1] - 2026-09-21

### Added

- Update-available badge with one-click self-update
- Per-session read-aloud voice; voice picker moved to Appearance settings

### Fixed

- Chat banner showing the session's actual provider

## [0.5.0] - 2026-09-21

First standalone release of **ddagent** — a self-hosted web & mobile UI for AI coding agents.

### Highlights

- **Multi-agent sessions** — Claude Code, Codex, Cursor CLI, OpenCode and Devin side by side, with live streaming and resume
- **Workspace layout** — split panes for chat, terminal, browser and files
- **File explorer & editor** — browse and edit the workspace in the UI
- **Git panel** — stage, commit, diff, switch branches, manage worktrees
- **Task board** — kanban powered by TaskMaster; generate executable tasks from PRDs
- **MCP management** — add and sync MCP servers across agents
- **Skills browser** — discover and manage agent skills
- **Quota & usage** — per-agent token usage and subscription limits
- **Browser-use** — agent-driven browser sessions for research and testing
- **Notifications & TTS** — alerts and read-aloud replies
- **Docker sandboxes** — experimental hypervisor-isolated agent runs
- **Desktop companion** — optional Electron app for macOS/Windows
- **i18n** — 11 UI languages, dark and light themes

### CLI

- `ddagent` / `ddagent start` — start the server
- `ddagent status` — show configuration and data locations
- `ddagent version` / `ddagent help`
