# ddagent as an MCP server

External MCP clients (Claude Desktop, OpenClaw, any JSON-RPC MCP tool) can drive
ddagent: list sessions, create kanban tasks, enqueue messages, open worktrees.

## Endpoint

```
POST <ddagent>/mcp          JSON-RPC 2.0 (initialize / ping / tools/list / tools/call)
GET  <ddagent>/mcp          server info (capability probe)
Authorization: Bearer mcp_…
```

## Tokens

Create under **Settings → Agents → MCP → ddagent MCP server tokens**. The
plaintext token is shown exactly once — store it in the client config. Scopes:

- `read` — `list_sessions`, `get_status`
- `write` — additionally `create_task`, `send_message`, `create_worktree`

## Tools

| Tool | Scope | Args |
|---|---|---|
| `list_sessions` | read | `limit?` |
| `get_status` | read | — |
| `create_task` | write | `prompt`, `projectId` or `projectPath`, `title?`, `provider?`, `model?`, `effort?` |
| `send_message` | write | `sessionId`, `message` |
| `create_worktree` | write | `projectPath`, `branch`, `baseBranch?` |

## Install into your agents

Rather than writing each provider's config by hand, install the server from
**Settings → MCP → Install ddagent MCP server** (pick agents, or install for
all). It calls:

```
POST /api/mcp/install
{ "providers": ["claude", "codex"], "scope": "write" }   // providers omitted = every agent
```

The install writes a `ddagent` HTTP MCP entry (user scope) pointing at
`<server>/mcp` with a reusable `ddagent-mcp` bearer token — reinstalling revokes
the previous token, so exactly one install token stays active. Once installed,
that agent's tools include `knowledge_search`, `knowledge_get_*`, `create_task`,
`send_message`, `create_worktree` and the rest of the catalog.

## Claude Desktop config

```json
{
  "mcpServers": {
    "ddagent": {
      "type": "streamable-http",
      "url": "http://localhost:3001/mcp",
      "headers": { "Authorization": "Bearer mcp_…" }
    }
  }
}
```

## OpenClaw / generic JSON-RPC client

```json
{
  "url": "http://localhost:3001/mcp",
  "headers": { "Authorization": "Bearer mcp_…" }
}
```

Notes: JSON-RPC notifications return HTTP 202 with no body. `create_task` cards
land in the board's `ready` column; `send_message` goes through the queued-
messages inbox (`inboxSource: 'mcp'`).
