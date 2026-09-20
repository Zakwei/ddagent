# Changelog

All notable changes to ddagent are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

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
