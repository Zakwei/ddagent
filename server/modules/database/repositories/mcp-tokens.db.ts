import { getConnection } from '@/modules/database/connection.js';

/**
 * CREATE TABLE statement for `mcp_client_tokens`.
 *
 * Exported so the MCP-server test suite can create the table on an isolated
 * DATABASE_PATH even before schema.ts/migrations.ts wire it into the standard
 * bootstrap, and so migrations can replay it idempotently on upgraded installs.
 */
export const MCP_TOKENS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS mcp_client_tokens (
    id TEXT PRIMARY KEY,
    label TEXT NOT NULL,
    -- Only the sha256 hex digest of the bearer token is stored. The plaintext
    -- token is returned exactly once at creation and never persisted.
    token_hash TEXT NOT NULL UNIQUE,
    scope TEXT NOT NULL CHECK (scope IN ('read', 'write')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_used_at DATETIME,
    revoked BOOLEAN NOT NULL DEFAULT 0
);
`;

/** Minimum capability one MCP bearer token grants: `read` tools only, or all tools. */
export type McpTokenScope = 'read' | 'write';

/**
 * Public view of one `mcp_client_tokens` row.
 *
 * `tokenHash` is deliberately absent: no reader outside this repository ever
 * needs the digest, and omitting it keeps list endpoints from leaking the
 * value a verifier is compared against.
 */
export type McpClientToken = {
  id: string;
  label: string;
  scope: McpTokenScope;
  createdAt: string;
  lastUsedAt: string | null;
  revoked: boolean;
};

type McpClientTokenRow = {
  id: string;
  label: string;
  token_hash: string;
  scope: string;
  created_at: string;
  last_used_at: string | null;
  revoked: number;
};

const SQLITE_UTC_TIMESTAMP_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

function normalizeTimestamp(value?: string | null): string | null {
  if (!value) return null;
  const normalized = SQLITE_UTC_TIMESTAMP_REGEX.test(value)
    ? `${value.replace(' ', 'T')}Z`
    : value;
  const parsed = new Date(normalized);
  return Number.isNaN(parsed.getTime()) ? null : parsed.toISOString();
}

function toToken(row: McpClientTokenRow): McpClientToken {
  return {
    id: row.id,
    label: row.label,
    scope: row.scope === 'write' ? 'write' : 'read',
    createdAt: normalizeTimestamp(row.created_at) ?? row.created_at,
    lastUsedAt: normalizeTimestamp(row.last_used_at),
    revoked: row.revoked === 1,
  };
}

/**
 * `mcp_client_tokens` persistence: bearer tokens that authenticate external
 * MCP clients (Claude Desktop, OpenClaw) against the `/mcp` endpoint.
 *
 * The repository never sees plaintext at rest: callers hash the token and
 * pass the digest in (`create`) or pass the plaintext plus a hash function so
 * the lookup can compare digests (`findByToken`).
 */
export const mcpTokensDb = {
  /** Lists every token row (including revoked) in creation order. */
  list(): McpClientToken[] {
    const db = getConnection();
    const rows = db
      .prepare('SELECT * FROM mcp_client_tokens ORDER BY created_at, id')
      .all() as McpClientTokenRow[];
    return rows.map(toToken);
  },

  /** Inserts one token row keyed by the already-computed token digest. */
  create(input: {
    id: string;
    label: string;
    tokenHash: string;
    scope: McpTokenScope;
  }): McpClientToken {
    const db = getConnection();
    db.prepare(
      `INSERT INTO mcp_client_tokens (id, label, token_hash, scope, created_at)
       VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)`,
    ).run(input.id, input.label, input.tokenHash, input.scope);
    const row = db
      .prepare('SELECT * FROM mcp_client_tokens WHERE id = ?')
      .get(input.id) as McpClientTokenRow;
    return toToken(row);
  },

  /**
   * Resolves a plaintext bearer token to its row.
   *
   * `hashFn` is injected so the repository stays free of crypto details and
   * tests can substitute a deterministic digest. Revoked rows never match.
   * A successful lookup stamps `last_used_at` for the audit view.
   */
  findByToken(
    plainToken: string,
    hashFn: (value: string) => string,
  ): McpClientToken | null {
    const db = getConnection();
    const row = db
      .prepare('SELECT * FROM mcp_client_tokens WHERE token_hash = ? AND revoked = 0')
      .get(hashFn(plainToken)) as McpClientTokenRow | undefined;
    if (!row) return null;

    db.prepare('UPDATE mcp_client_tokens SET last_used_at = CURRENT_TIMESTAMP WHERE id = ?').run(row.id);
    return toToken({ ...row, last_used_at: new Date().toISOString() });
  },

  /** Soft-revokes one token so future bearer lookups fail. False when the id is unknown. */
  revoke(id: string): boolean {
    const db = getConnection();
    return db
      .prepare('UPDATE mcp_client_tokens SET revoked = 1 WHERE id = ?')
      .run(id).changes > 0;
  },
};
