# Changelog

All notable changes to ddagent are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

<p>
  <strong>English</strong> ·
  <a href="docs/i18n/CHANGELOG.pl.md">Polski</a> ·
  <a href="docs/i18n/CHANGELOG.de.md">Deutsch</a> ·
  <a href="docs/i18n/CHANGELOG.es.md">Español</a> ·
  <a href="docs/i18n/CHANGELOG.fr.md">Français</a> ·
  <a href="docs/i18n/CHANGELOG.it.md">Italiano</a> ·
  <a href="docs/i18n/CHANGELOG.ja.md">日本語</a> ·
  <a href="docs/i18n/CHANGELOG.ko.md">한국어</a> ·
  <a href="docs/i18n/CHANGELOG.ru.md">Русский</a> ·
  <a href="docs/i18n/CHANGELOG.tr.md">Türkçe</a> ·
  <a href="docs/i18n/CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="docs/i18n/CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.6.1] - 2026-09-26

### Fixed

- Mobile: model picker was unavailable on new chats, multi-panel workspace not reachable
- Mobile: split-workspace panes now embed real chat views

## [0.6.0] - 2026-09-26

### Added

- **Auto orchestrated provider** — model routing, planner DAG and delegation with routing/plan/delegation/summary cards in chat, plus an orchestration tab in Settings
- **Mobile: full native parity** — every screen is native now: Files (CRUD, search, lightbox), Source Control (hunk staging, split diff, commit graph, worktrees), Tasks (PRD editor, detail editing), Agent Board, Quota & Usage, terminal, editor and all Settings tabs
- **Mobile:** onboarding wizard, project creation wizard (folder browser, GitHub clone, review), command palette with global search, split workspace grid, quick settings panel, browser-use live panel
- **Mobile:** offline message queue, chat export (PDF/md/html/text), transcript search, session compare

### Fixed

- OpenCode: duplicate session rows from streamed text snapshots, question tool prompts not surfacing
- Sticky Review/Search bar clipping the first message

## [0.5.9] - 2026-09-25

First public open-source release — **AGPL-3.0-only**.

### Added

- **Team collaboration** — shared sessions, broadcast messages, agent inbox, per-project shared memory
- **MCP server** — external MCP clients (Claude Desktop, OpenClaw) can create tasks and message sessions via `POST /mcp` ([docs](docs/mcp-server.md))
- **Remote approvals** — approve agent actions from Telegram or Discord ([docs](docs/remote-approvals.md))
- **Scheduler** — cron schedules for agent runs with sleep prevention
- **Named provider accounts** — per-session env/credential overrides
- **Voice input (STT)** — whisper-compatible endpoint in the composer
- **Worktrees** — per-repo setup/run scripts with dev-server runner
- **Preview** — authenticated dev-server preview proxy with WS tunnel
- **Mobile** — session search, actionable approval push notifications (FCM)
- `SECURITY.md` — private vulnerability reporting policy

### Fixed

- Quota tab data and display bugs
- Chat: offline queue and drafts survive reloads; stable scroll position across refetches
- Sessions: deleted sessions no longer leave ghosts on other clients
- Kanban: dispatch races and leaks on the agent board
- Mobile: raw keyboard-height padding, ActionSheet replacing overflow alerts

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
