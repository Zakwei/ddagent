# Knowledge base

Local-first knowledge base for agents — memories, rules, skills and personal
information, plus tags and relations — inspired by
[Contexta](https://github.com/XFABISIEK/Contexta). Everything lives in the same
SQLite database as the rest of ddagent (`auth.db`) behind an FTS5 index, is
managed from the **Knowledge** screen in the client, and is readable/writable by
agents over MCP.

## Entities

| Entity | Scope | Notes |
|---|---|---|
| Memory | project or global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, tags |
| Rule | project or global | `enabled` toggle; `critical` rules are injected into sessions |
| Skill | global | unique name, category, optional icon (base64 data URL) |
| Personal info | global | unique `key` |
| Tag / Connection | — | tags on memories; connections link any two entities |
| History | — | every write snapshots the entity so it can be reviewed and restored |

Priorities: `critical > high > normal > low`. `project_id` is stored as a plain
column (no foreign key): the projects table is rebuilt during migrations, so the
Projects module resolves paths at read time.

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
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
```

`projectId=global` restricts a list to global rows; adding `includeGlobal=true`
to a project id returns the project plus global rows.

## MCP tools

The ddagent MCP server (`POST /mcp`) exposes the knowledge base to external
clients. Read tools work with a `read`-scoped token, write tools require
`write`. Write tools run the same validation as the UI and record history.

Read: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Write: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, and the same trio for `rule`, `skill` and
`personal`; plus `knowledge_link` / `knowledge_unlink`.

Tools accept either `projectId` or a `projectPath` ddagent already knows.

## Auto-injection

On a session's **first** outbound message, `critical` rules (project + global,
enabled only) and `critical` memories are prepended as a `<knowledge>` block,
within a ~4000-token budget. It rides the same first-turn gate as
`.ddagent/shared-context.md` and unified rules, so it costs no per-turn tokens.
Set `DDAGENT_KNOWLEDGE=0` to opt out.

## Project scan

`POST /api/knowledge/scan` imports the project's AI-context files as reference
memories: `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`,
`.cursorrules`, `.muserules`, and every markdown/`.mdc` file under
`.cursor/rules`, `skills` and `.agents/skills`. Each file is tracked by content
hash in `kb_scan_state`, so a rescan only touches changed files and deletes the
memories whose source disappeared.

## Client

The **Knowledge** screen (navigation rail → Knowledge) has Dashboard, Memories,
Rules, Skills, Personal and Graph tabs, a project scope filter, a modal
create/edit form, per-entity version history with restore, skill icon upload and
JSON export/import. The Graph tab is a force-directed relation view with
pan/zoom, node dragging, entity-type filters and neighbour highlighting.
