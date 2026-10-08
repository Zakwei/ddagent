/**
 * Session events repository.
 *
 * Persists the live `error` rows and notice `status` rows (C1 `notice: true`)
 * the chat run registry forwards, keyed by app session id. Many provider
 * transcripts never record these lines, so without this table they vanish on
 * the next history reload. The sessions history path merges them back in.
 *
 * Bounded: each session keeps only its newest MAX_EVENTS_PER_SESSION rows.
 */

import { getConnection } from '@/modules/database/connection.js';
import type { LLMProvider, NormalizedMessage } from '@/shared/types.js';

export const SESSION_EVENTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS session_events (
    id TEXT PRIMARY KEY,
    session_id TEXT NOT NULL,
    provider TEXT NOT NULL,
    kind TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_session_events_session ON session_events(session_id, created_at);
`;

const MAX_EVENTS_PER_SESSION = 200;

type SessionEventRow = {
  id: string;
  session_id: string;
  provider: string;
  kind: string;
  content: string;
  created_at: string;
};

function toMessage(row: SessionEventRow): NormalizedMessage {
  const base = {
    id: row.id,
    sessionId: row.session_id,
    timestamp: row.created_at,
    provider: row.provider as LLMProvider,
  };
  return row.kind === 'error'
    ? { ...base, kind: 'error', content: row.content }
    : { ...base, kind: 'status', text: row.content, notice: true };
}

// Consumed by the WebSocket chat run registry (writes live rows) and the
// Providers sessions service (merges them into REST history).
export const sessionEventsDb = {
  /** Stores one `error` or notice `status` row; duplicate ids are ignored. */
  append(input: {
    id: string;
    sessionId: string;
    provider: string;
    kind: 'error' | 'status';
    content: string;
    timestamp: string;
  }): void {
    const db = getConnection();
    db.prepare(
      `INSERT OR IGNORE INTO session_events (id, session_id, provider, kind, content, created_at)
       VALUES (?, ?, ?, ?, ?, ?)`,
    ).run(input.id, input.sessionId, input.provider, input.kind, input.content, input.timestamp);
    db.prepare(
      `DELETE FROM session_events WHERE session_id = ? AND id NOT IN (
         SELECT id FROM session_events WHERE session_id = ? ORDER BY created_at DESC LIMIT ?
       )`,
    ).run(input.sessionId, input.sessionId, MAX_EVENTS_PER_SESSION);
  },

  /** Lists a session's stored rows, oldest first, as history messages. */
  listBySession(sessionId: string): NormalizedMessage[] {
    const rows = getConnection()
      .prepare('SELECT * FROM session_events WHERE session_id = ? ORDER BY created_at ASC, rowid ASC')
      .all(sessionId) as SessionEventRow[];
    return rows.map(toMessage);
  },

  /** Drops every stored row of a force-deleted session. */
  deleteForSession(sessionId: string): void {
    getConnection().prepare('DELETE FROM session_events WHERE session_id = ?').run(sessionId);
  },
};
