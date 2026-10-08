# ddagent as an MCP server

External MCP clients (Claude Code, Claude Desktop, OpenClaw, any JSON-RPC MCP
client) can drive ddagent: list sessions, create kanban tasks, enqueue messages,
create worktrees, and read or write the [knowledge base](KNOWLEDGE.md).

## Endpoint

```
POST <ddagent>/mcp          JSON-RPC 2.0 (initialize / ping / tools/list / tools/call / notifications/*)
GET  <ddagent>/mcp          server info (capability probe)
Authorization: Bearer mcp_…
```

Both methods require a bearer token; a missing or unknown token returns `401`
(`MCP_UNAUTHORIZED`). The endpoint is mounted outside the app's JWT auth, so MCP
clients only ever hold `mcp_*` tokens.

## Tokens

Create tokens in the client under **Settings → Agents → (any agent) → MCP →
ddagent MCP server tokens**. The plaintext token is shown exactly once — store it
in the client config. Only its SHA-256 hash is kept on the server. Scopes:

- `read` — read-only tools: `list_sessions`, `get_status`, `knowledge_search`,
  `knowledge_get_*`, `knowledge_history`
- `write` — everything, including `create_task`, `send_message`,
  `create_worktree` and the knowledge write tools

The same list is available over REST (session-authenticated):
`GET /api/mcp/tokens`, `POST /api/mcp/tokens` `{ "label": "…", "scope": "read" | "write" }`,
`DELETE /api/mcp/tokens/:id`.

## Tools

| Tool | Scope | Args |
|---|---|---|
| `list_sessions` | read | `limit?` (default 20, max 100) |
| `get_status` | read | — |
| `create_task` | write | `prompt`, `projectId` or `projectPath`, `title?`, `provider?`, `model?`, `effort?` |
| `send_message` | write | `sessionId`, `message` |
| `create_worktree` | write | `projectPath`, `branch`, `baseBranch?` |
| `knowledge_*` | read / write | see [Knowledge base → MCP tools](KNOWLEDGE.md#mcp-tools-on-demand) |

## Install into your agents

Rather than writing each provider's config by hand, install the server from
**Settings → Agents → (agent) → MCP → Install ddagent MCP server** (pick agents,
or install for all; also offered during onboarding). It calls:

```
POST /api/mcp/install
{ "providers": ["claude", "codex"], "scope": "write" }   // providers omitted = every agent
```

Optional body fields: `scope` (default `write`), `url` (default
`http://127.0.0.1:<SERVER_PORT>/mcp` — pass the address the agents can actually
reach if it differs) and `serverName` (default `ddagent`).

The install writes a `ddagent` HTTP MCP entry (user scope) into each selected
agent's native config, pointing at `<server>/mcp` with a reusable `ddagent-mcp`
bearer token. Reinstalling revokes the previous token, so exactly one install
token stays active. Failures are reported per provider instead of failing the
whole install. Once installed, the agent's tools include the `knowledge_*` group,
`create_task`, `send_message`, `create_worktree` and the rest of the catalog.

## Manual client config

Claude Code and other clients that support HTTP MCP servers directly:

```json
{
  "mcpServers": {
    "ddagent": {
      "type": "http",
      "url": "http://localhost:3001/mcp",
      "headers": { "Authorization": "Bearer mcp_…" }
    }
  }
}
```

Claude Desktop's config file only launches local (stdio) servers; bridge to the
HTTP endpoint with [`mcp-remote`](https://www.npmjs.com/package/mcp-remote):

```json
{
  "mcpServers": {
    "ddagent": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:3001/mcp", "--header", "Authorization: Bearer mcp_…"]
    }
  }
}
```

OpenClaw / generic JSON-RPC client:

```json
{
  "url": "http://localhost:3001/mcp",
  "headers": { "Authorization": "Bearer mcp_…" }
}
```

Replace `3001` if you changed `SERVER_PORT`.

## Notes

- JSON-RPC notifications return HTTP 202 with no body.
- `tools/list` always returns the full catalog. A `read` token calling a write
  tool gets a tool result with `isError: true` (not a JSON-RPC protocol error);
  only an unknown tool name is a JSON-RPC `-32602` error.
- `create_task` cards land in the board's `ready` column.
- `send_message` goes through the queued-messages inbox (`inboxSource: 'mcp'`)
  and is delivered when the session is idle.
