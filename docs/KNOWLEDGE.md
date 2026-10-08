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

DDAgent ships a **local-first knowledge base** for your agents: memories, rules,
skills and personal information, plus tags and relations. It lives in the same
SQLite database as the rest of DDAgent (`auth.db`) behind an FTS5 full-text
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
  the model's choice — DDAgent does not turn it off.
- **DDAgent's first-turn prefix** — on a session's first message DDAgent
  prepends the project's `.ddagent/shared-context.md` and a `<unified-rules>`
  block (the workspace `AGENTS.md`, `~/.agents/AGENTS.md` and a short hygiene
  note; set `DDAGENT_UNIFIED_RULES=0` to drop it). This is file-based and
  separate from the knowledge base.
- **MCP retrieval (on demand)** — once you install DDAgent's MCP server into an
  agent, its tool list includes `knowledge_get_context`, `knowledge_search` and
  friends. Following Contexta, nothing is injected automatically: the agent
  calls the context builder with a query and gets back the critical rules plus
  whatever matches. The model decides when to call it, guided by the tool
  descriptions and by any instruction rules you keep in the knowledge base.

So "one place" means **one place to curate the knowledge** — it does not (and
cannot) stop a CLI from reading its own native files. DDAgent does not
auto-inject the knowledge base into sessions at all.

## Entities

| Entity | Scope | Notes |
|---|---|---|
| Memory | project or global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, tags |
| Rule | project or global | `enabled` toggle; `critical` rules are always returned first by the context builder |
| Skill | global | unique name, category, optional icon (base64 data URL) |
| Personal info | global | unique `key` |
| Tag / Connection | — | tags on memories; connections link any two entities |
| History | — | every write snapshots the entity so it can be reviewed and restored |

Priorities: `critical > high > normal > low`. An entity can be scoped to one
project or be global (applies everywhere). `project_id` is a plain column (no
foreign key) because the projects table is rebuilt during migrations.

## Retrieving context (on demand)

Agents fetch context through the MCP tool `knowledge_get_context` (a faithful
port of Contexta's ContextBuilder). Given a project and a query it returns, in
order:

- **all enabled rules** (project + global), `critical` first (cap 20),
- **memories** ranked by the query (FTS), plus their 1-hop neighbours reached
  through connections (cap 5); with no query, the project's top memories by
  priority,
- **skills** ranked by the query; with no query, the most recent skills,
- **personal information** only when the query matches it (cap 3),

rendered as a Markdown block whose items are truncated per section
(800/1000/600 chars) and capped by `maxTokens` (default ~4000); items that no
longer fit are counted as omitted.

The dashboard shows a **rules-context meter** (`~X / 4000 tok`) for the selected
project — the size of the rules block every `knowledge_get_context` call always
includes. Nothing is auto-injected into sessions.

Search ranking is hybrid, like Contexta's `search.rs`: FTS5 **prefix** matching
(`auth` also matches `authentication`) plus a fuzzy **trigram** pass that catches
typos and near-synonyms, then a rerank by `bm25 + priority + recency`.

## MCP tools (on demand)

DDAgent's MCP server (`POST /mcp`) exposes the knowledge base to any MCP client.
Read tools work with a `read`-scoped token; write tools require `write`. Write
tools run the same validation as the UI and record history.

Read: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Write: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, and the same trio for `rule`, `skill` and `personal`;
plus `knowledge_link` / `knowledge_unlink`.

Tools accept either `projectId` or a `projectPath` DDAgent already knows.

### Installing the server into your agents

You do not have to edit provider configs by hand. Use **Settings → Agents →
(agent) → MCP → Install DDAgent MCP server** (also offered as a step in
onboarding) and pick the agents — or install for all. It writes a `ddagent` HTTP
MCP entry (user scope) pointing at `<server>/mcp` with a reusable, write-scoped
`ddagent-mcp` bearer token (reinstalling revokes the previous one). Once
installed, that agent's tools include the `knowledge_*` group alongside
`create_task`, `send_message`, etc.

How does an agent know *when* to use MCP? It does not guess — tell it. Keep a
`critical` rule such as: *"Before answering questions about this project, call
`knowledge_get_context`; when you settle a decision, persist it with
`knowledge_add_memory`."* Because `critical` rules are always returned by the
context builder, every agent that calls the tool gets the same operating
instructions.

## Project scan

`POST /api/knowledge/scan` imports a project's AI-context files, classified by
intent:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` and markdown/`.mdc` under `.cursor/rules` become **rules**
  (critical + enabled, so `knowledge_get_context` always returns them; the
  workspace `AGENTS.md` is imported as `high` because the first-turn
  `<unified-rules>` prefix already delivers it),
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
dragging, entity-type filters and neighbour highlighting. The graph draws your
explicit links plus implicit hubs — every project-scoped entity connects to its
project, and memories sharing a tag connect to a tag node — so it always shows
structure.

## Curating it well

1. **Scan** each active project once (Knowledge → select project → scan);
   re-scan after big changes to its instruction files.
2. **Promote deliberately**: only truly binding rules should be `critical`
   (they are always served by the context builder). Use the star on a row, and
   watch the rules-context meter.
3. **Keep the rest `high`/`normal`** — still searchable and available over MCP
   only when a query matches, so they cost nothing when irrelevant.
4. **Personal info** for cross-project preferences (timezone, editor, naming).
5. **Link related memories** so 1-hop neighbours ride along.
6. **Install MCP** for the agents that should search the base and persist
   learnings. The one-click install uses a `write` token; for a read-only agent,
   create a `read` token under DDAgent MCP server tokens and configure that agent
   by hand (see [DDAgent as an MCP server](mcp-server.md#manual-client-config)).

## Migration

Knowledge → menu → **Migrate existing rules** runs a **dry-run** report: it
scans all projects, finds duplicates that exist across projects (same normalized
title + content), and shows rule counts. From there you can **Merge duplicates**
(collapses them into one global row) and/or **Make all rules critical**. Nothing
is written until you confirm — destructive actions are explicit.

The **Dashboard** also has a single **Import everything into DDAgent** button:
it runs the project scan and the agent-skill import in one action, with the same
dry-run preview and optional duplicate-merge / promote toggles. It only reads
your agents' files and writes to DDAgent's own database — no CLI file or config
is touched (the only action that writes to an agent's config is the separate
"Install DDAgent MCP server").

The same menu has **Import agent skills**: it lists the global/default skills
your agents already ship or have installed (user / system / plugin scopes) and
imports the missing ones into the knowledge base as skills. It is a dry run
first, and idempotent — a name that already exists is skipped. Project-scoped
skills are imported by the project scan instead.

## Good to know

- Everything is **local** to this DDAgent instance; no cloud, no sync.
- The knowledge base is **not auto-injected** — agents retrieve it over MCP on
  demand (Contexta model). Agents without the MCP server installed get nothing
  from it.
- Scanned skills are reachable through MCP (`knowledge_get_context` /
  `knowledge_search`), not pushed into context.
- A rule or memory can be edited by an agent over MCP; review changes in the
  entity's **History** and restore a previous version if needed.

## REST API

Mounted at `/api/knowledge` behind authentication:

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=&limit=&offset=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=&limit=&offset=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (rules-context preview: size + budget)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
POST   /import-skills       { providers?, scopes?, dryRun? }
POST   /import-all          { dryRun?, dedupe?, promoteRules? }
```

`projectId=global` restricts a list to global rows; adding `includeGlobal=true`
to a project id returns the project plus global rows.

## Related

- [DDAgent as an MCP server](mcp-server.md) — the tool catalog and token setup
- [Team collaboration](teams.md) · [Remote approvals](remote-approvals.md)
