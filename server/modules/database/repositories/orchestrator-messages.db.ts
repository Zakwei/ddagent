/**
 * Orchestrator messages repository.
 *
 * Owns the transcript of orchestrated parent sessions (`provider =
 * 'orchestrator'`). A parent session has no provider runtime, so unlike
 * provider-backed sessions it cannot rely on a native JSONL transcript —
 * every entry (user message, routing decision, plan, delegation block,
 * summary) is appended here and read back by the sessions history path.
 *
 * `seq` is a per-session monotonically increasing order key, minted as
 * `COALESCE(MAX(seq), 0) + 1` inside the same INSERT so concurrent appends
 * for one session cannot collide on ordering.
 */

import { getConnection } from '@/modules/database/connection.js';
import type { OrchestratorMessage, OrchestratorMessageKind } from '@/shared/types.js';

export const ORCHESTRATOR_MESSAGES_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS orchestrator_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT NOT NULL,
    seq INTEGER NOT NULL,
    kind TEXT NOT NULL,
    payload TEXT NOT NULL DEFAULT '{}',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (session_id, seq)
);
`;

type OrchestratorMessageRow = {
  id: number;
  session_id: string;
  seq: number;
  kind: string;
  payload: string;
  created_at: string;
};

function toMessage(row: OrchestratorMessageRow): OrchestratorMessage {
  let payload: Record<string, unknown> = {};
  try {
    const parsed = JSON.parse(row.payload);
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
      payload = parsed as Record<string, unknown>;
    }
  } catch {
    // A malformed row is surfaced as an empty payload rather than breaking
    // the whole transcript read.
  }
  return {
    id: row.id,
    sessionId: row.session_id,
    seq: row.seq,
    kind: row.kind as OrchestratorMessageKind,
    payload,
    createdAt: row.created_at,
  };
}

export const orchestratorMessagesDb = {
  /** Appends one entry to a parent session transcript; returns the row. */
  append(
    sessionId: string,
    kind: OrchestratorMessageKind,
    payload: Record<string, unknown>,
  ): OrchestratorMessage {
    const db = getConnection();
    const result = db
      .prepare(
        `INSERT INTO orchestrator_messages (session_id, seq, kind, payload)
         VALUES (?, (SELECT COALESCE(MAX(seq), 0) + 1 FROM orchestrator_messages WHERE session_id = ?), ?, ?)`,
      )
      .run(sessionId, sessionId, kind, JSON.stringify(payload ?? {}));
    return this.getById(Number(result.lastInsertRowid)) as OrchestratorMessage;
  },

  /** Returns a single transcript row by primary key, or null. */
  getById(id: number): OrchestratorMessage | null {
    const db = getConnection();
    const row = db
      .prepare('SELECT * FROM orchestrator_messages WHERE id = ?')
      .get(id) as OrchestratorMessageRow | undefined;
    return row ? toMessage(row) : null;
  },

  /** Returns the full transcript of one parent session in write order. */
  list(sessionId: string): OrchestratorMessage[] {
    const db = getConnection();
    const rows = db
      .prepare('SELECT * FROM orchestrator_messages WHERE session_id = ? ORDER BY seq ASC')
      .all(sessionId) as OrchestratorMessageRow[];
    return rows.map(toMessage);
  },

  /**
   * Updates the payload of one transcript row in place. Delegation blocks use
   * this to keep a single row per child run: status and event summary fields
   * are patched as the run progresses instead of spamming new entries.
   */
  updatePayload(id: number, patch: Record<string, unknown>): OrchestratorMessage | null {
    const existing = this.getById(id);
    if (!existing) {
      return null;
    }
    const db = getConnection();
    db.prepare('UPDATE orchestrator_messages SET payload = ? WHERE id = ?').run(
      JSON.stringify({ ...existing.payload, ...patch }),
      id,
    );
    return this.getById(id);
  },

  /** Removes every transcript row of a parent session (used on session delete). */
  deleteForSession(sessionId: string): void {
    const db = getConnection();
    db.prepare('DELETE FROM orchestrator_messages WHERE session_id = ?').run(sessionId);
  },
};
