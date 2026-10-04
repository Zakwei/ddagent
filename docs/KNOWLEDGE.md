# Knowledge base

<p>
  <strong>English</strong> ·
  <a href="i18n/KNOWLEDGE.pl.md">Polski</a> ·
  <a href="i18n/KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="i18n/KNOWLEDGE.es.md">Español</a> ·
  <a href="i18n/KNOWLEDGE.fr.md">Français</a> ·
  <a href="i18n/KNOWLEDGE.it.md">Italiano</a> ·
  <a href="i18n/KNOWLEDGE.ja.md">日本語</a> ·
  <a href="i18n/KNOWLEDGE.ko.md">한국어</a> ·
  <a href="i18n/KNOWLEDGE.ru.md">Русский</a> ·
  <a href="i18n/KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="i18n/KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="i18n/KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent ships a **local-first knowledge base** for your agents: memories, rules,
skills and personal information, plus tags and relations. It lives in the same
SQLite database as the rest of ddagent (`auth.db`) behind an FTS5 full-text
index, is managed from the **Knowledge** screen in the client, and is readable
and writable by your agents over MCP. It is loosely inspired by
[Contexta](https://github.com/XFABISIEK/Contexta).

The point is simple: your rules and project knowledge stop being scattered
across per-tool files (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …)
and become one curated, searchable place that every agent can use — the ones
that read files, and the ones that speak MCP.

## How an agent actually sees it

There are three layers, and it helps to know which is which:

- **CLI-native files** — each tool reads its own config on its own: Claude Code
  reads `CLAUDE.md`, Codex/Cursor read `AGENTS.md`, Cursor reads `.cursorrules`,
  and several read `skills/` and `.agents/skills/`. This is the CLI's job, not
  the model's choice — ddagent does not turn it off.
- **ddagent injection** — on a session's first turn ddagent prepends a
  `<knowledge>` block (details below). This works for every provider and needs
  no configuration from the agent.
- **MCP tools** — once you install ddagent's MCP server into an agent, its tool
  list includes `knowledge_search` and friends. The model decides when to call
  them, guided by the tool descriptions and by any instruction rules you keep in
  the knowledge base.

So "one place" means **one place to curate the injected content and one budget**
— it does not (and cannot) stop a CLI from reading its own native files. To avoid
duplicates we keep the workspace `AGENTS.md` at `high` priority so the knowledge
block never repeats what unified-rules already injects.

## Entities

| Entity | Scope | Notes |
|---|---|---|
| Memory | project or global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, tags |
| Rule | project or global | `enabled` toggle; `critical` rules are injected into sessions |
| Skill | global | unique name, category, optional icon (base64 data URL) |
| Personal info | global | unique `key` |
| Tag / Connection | — | tags on memories; connections link any two entities |
| History | — | every write snapshots the entity so it can be reviewed and restored |

Priorities: `critical > high > normal > low`. An entity can be scoped to one
project or be global (applies everywhere). `project_id` is a plain column (no
foreign key) because the projects table is rebuilt during migrations.

## First-turn injection (what every agent gets, automatically)

On a session's **first** outbound message, ddagent prepends a `<knowledge>`
block containing:

- `critical` **rules** (project + global, enabled only),
- `critical` **memories**,
- every **personal-information** entry,
- the **1-hop neighbours** of the included memories (reached through explicit
  connections).

The whole block is capped to ~4000 tokens. It rides the same first-turn gate as
`.ddagent/shared-context.md` and unified rules, so it costs no per-turn tokens.
Set `DDAGENT_KNOWLEDGE=0` to opt out.

The dashboard shows an **injected-context meter** (`~X / 4000 tok`) for the
selected project, so you can see and control what enters the context.

## MCP tools (on demand)

ddagent's MCP server (`POST /mcp`) exposes the knowledge base to any MCP client.
Read tools work with a `read`-scoped token; write tools require `write`. Write
tools run the same validation as the UI and record history.

Read: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Write: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, and the same trio for `rule`, `skill` and `personal`;
plus `knowledge_link` / `knowledge_unlink`.

Tools accept either `projectId` or a `projectPath` ddagent already knows.

### Installing the server into your agents

You do not have to edit provider configs by hand. Use **Settings → MCP →
Install ddagent MCP server** (also offered as a step in onboarding) and pick the
agents — or install for all. It writes a `ddagent` HTTP MCP entry (user scope)
pointing at `<server>/mcp` with a reusable `ddagent-mcp` bearer token
(reinstalling revokes the previous one). Once installed, that agent's tools
include the `knowledge_*` group alongside `create_task`, `send_message`, etc.

How does an agent know *when* to use MCP? It does not guess — tell it. Keep a
`critical` rule such as: *"Before answering questions about this project, call
`knowledge_search`; when you settle a decision, persist it with
`knowledge_add_memory`."* Because that rule is injected on every first turn, all
your agents get the same operating instructions.

## Project scan

`POST /api/knowledge/scan` imports a project's AI-context files, classified by
intent:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` and markdown/`.mdc` under `.cursor/rules` become **rules**
  (critical + enabled, so they reach the agent context; the workspace `AGENTS.md`
  is `high` to avoid double injection with unified-rules),
- `SKILL.md` files under `skills` / `.agents/skills` become **skills**
  (name/description from frontmatter),
- any other scanned markdown becomes a **reference memory**.

Each file is tracked by content hash in `kb_scan_state`, so a rescan only
touches changed files and deletes the entities whose source disappeared.

## Client

The **Knowledge** screen (navigation rail → Knowledge) has Dashboard, Memories,
Rules, Skills, Personal and Graph tabs, a project scope filter, a modal
create/edit form, per-entity version history with restore, skill icon upload and
JSON export/import. The Memories tab has a tag filter bar (with tag management),
the app bar has full-text search, a create-link dialog and a migration action,
and the Graph tab is a force-directed relation view with pan/zoom, node
dragging, entity-type filters and neighbour highlighting. Settings → Knowledge
deep-links to the same screen.

## Curating it well

1. **Scan** each active project once (Knowledge → select project → scan);
   re-scan after big changes to its instruction files.
2. **Promote deliberately**: only truly binding rules should be `critical`
   (they are injected). Use the star on a row, and watch the budget meter.
3. **Keep the rest `high`/`normal`** — still searchable and available over MCP
   without spending context on every turn.
4. **Personal info** for cross-project preferences (timezone, editor, naming).
5. **Link related memories** so 1-hop neighbours ride along.
6. **Install MCP** for the agents that should search the base and persist
   learnings; give `read` scope to most, `write` where you trust the agent.

## Migration

Knowledge → menu → **Migrate existing rules** runs a **dry-run** report: it
scans all projects, finds duplicates that exist across projects (same normalized
title + content), and shows rule counts. From there you can **Merge duplicates**
(collapses them into one global row) and/or **Make all rules critical**. Nothing
is written until you confirm — destructive actions are explicit.

## Good to know

- Everything is **local** to this ddagent instance; no cloud, no sync.
- Injection happens **once per session** (first turn) — new sessions pick up
  changes.
- Scanned skills are **not injected**; they are reachable through MCP search,
  which keeps the always-on context lean.
- A rule or memory can be edited by an agent over MCP; review changes in the
  entity's **History** and restore a previous version if needed.

## REST API

Mounted at `/api/knowledge` behind authentication:

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (injection preview + budget)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
```

`projectId=global` restricts a list to global rows; adding `includeGlobal=true`
to a project id returns the project plus global rows.

## Related

- [ddagent as an MCP server](mcp-server.md) — the tool catalog and token setup
- [Team collaboration](teams.md) · [Remote approvals](remote-approvals.md)
