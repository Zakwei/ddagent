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
    // Legacy rows hold SQLite `CURRENT_TIMESTAMP` ("YYYY-MM-DD HH:MM:SS", UTC
    // without a marker) which Date.parse reads as local time — normalizing to
    // an explicit `Z` ISO string keeps optimistic-echo dedupe inside its
    // ±5 min window instead of drifting by the UTC offset.
    createdAt: row.created_at.includes('T')
      ? row.created_at
      : `${row.created_at.replace(' ', 'T')}Z`,
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
        `INSERT INTO orchestrator_messages (session_id, seq, kind, payload, created_at)
         VALUES (?, (SELECT COALESCE(MAX(seq), 0) + 1 FROM orchestrator_messages WHERE session_id = ?), ?, ?, ?)`,
      )
      .run(sessionId, sessionId, kind, JSON.stringify(payload ?? {}), new Date().toISOString());
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

  /**
   * Resolves a delegated child session back to its orchestrated parent, so
   * the UI can offer a "return to orchestration" link. Returns null for
   * sessions that were never a delegation child.
   */
  findParentByChildSessionId(childSessionId: string): string | null {
    const db = getConnection();
    const row = db
      .prepare(
        `SELECT session_id FROM orchestrator_messages
         WHERE kind = 'delegation' AND json_extract(payload, '$.childSessionId') = ?
         ORDER BY seq DESC LIMIT 1`,
      )
      .get(childSessionId) as { session_id: string } | undefined;
    return row?.session_id ?? null;
  },

  /**
   * Finds the delegation transcript row for a given child session id so
   * status-sync can patch and publish it as the child run progresses.
   * Returns the row's primary key and parent session id, or null when the
   * session was never a delegation child.
   *
   * Consumed by: chat-dispatch.service (child→parent status bridge).
   */
  findDelegationByChildSessionId(
    childSessionId: string,
  ): { rowId: number; parentSessionId: string } | null {
    const db = getConnection();
    const row = db
      .prepare(
        `SELECT id, session_id FROM orchestrator_messages
         WHERE kind = 'delegation' AND json_extract(payload, '$.childSessionId') = ?
         ORDER BY seq DESC LIMIT 1`,
      )
      .get(childSessionId) as { id: number; session_id: string } | undefined;
    return row ? { rowId: row.id, parentSessionId: row.session_id } : null;
  },

  /**
   * Lists the distinct delegated child session ids of one parent session —
   * the reverse of `findParentByChildSessionId`. Session archive, restore,
   * and delete use it to cascade the lifecycle action onto every child the
   * orchestration spawned.
   */
  listChildSessionIds(parentSessionId: string): string[] {
    const db = getConnection();
    const rows = db
      .prepare(
        `SELECT DISTINCT json_extract(payload, '$.childSessionId') AS child_session_id
         FROM orchestrator_messages
         WHERE session_id = ? AND kind = 'delegation'`,
      )
      .all(parentSessionId) as Array<{ child_session_id: unknown }>;
    return rows
      .map((row) => row.child_session_id)
      .filter((id): id is string => typeof id === 'string' && id.length > 0 && id !== parentSessionId);
  },

  /** Removes every transcript row of a parent session (used on session delete). */
  deleteForSession(sessionId: string): void {
    const db = getConnection();
    db.prepare('DELETE FROM orchestrator_messages WHERE session_id = ?').run(sessionId);
  },
};
