/**
 * Server-side outbound message queue repository.
 *
 * Persists messages a user queued while the target session was busy or while
 * the client was offline. Storing the queue here (instead of browser
 * localStorage) is what makes it survive refreshes and device switches.
 *
 * Timestamps are normalized from SQLite's space-separated UTC form into
 * ISO-8601 so readers get a single canonical format.
 */

import { getConnection } from '@/modules/database/connection.js';
import type { QueuedMessage, QueuedMessageStatus, QueuedMessagesRepository } from '@/shared/types.js';

const SQLITE_UTC_TIMESTAMP_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

function normalizeTimestamp(value: string): string {
  const normalized = SQLITE_UTC_TIMESTAMP_REGEX.test(value) ? `${value.replace(' ', 'T')}Z` : value;
  const parsed = new Date(normalized);
  return Number.isNaN(parsed.getTime()) ? value : parsed.toISOString();
}

type QueuedMessageRow = {
  id: number;
  user_id: string | null;
  session_id: string;
  content: string;
  options_json: string;
  status: string;
  error: string | null;
  position: number;
  created_at: string;
  updated_at: string;
};

function parseOptions(raw: string): Record<string, unknown> {
  try {
    const parsed = JSON.parse(raw) as unknown;
    return parsed && typeof parsed === 'object' && !Array.isArray(parsed)
      ? (parsed as Record<string, unknown>)
      : {};
  } catch {
    return {};
  }
}

function mapRow(row: QueuedMessageRow): QueuedMessage {
  return {
    id: row.id,
    userId: row.user_id,
    sessionId: row.session_id,
    content: row.content,
    options: parseOptions(row.options_json),
    status: row.status as QueuedMessageStatus,
    error: row.error,
    position: row.position,
    createdAt: normalizeTimestamp(row.created_at),
    updatedAt: normalizeTimestamp(row.updated_at),
  };
}

export const queuedMessagesDb: QueuedMessagesRepository = {
  /** Appends one queued message at the end of its session's queue. */
  enqueue(input): QueuedMessage {
    const db = getConnection();
    const next = db
      .prepare('SELECT COALESCE(MAX(position), -1) + 1 AS position FROM queued_messages WHERE session_id = ?')
      .get(input.sessionId) as { position: number };

    const result = db
      .prepare(
        `INSERT INTO queued_messages (user_id, session_id, content, options_json, status, position)
         VALUES (?, ?, ?, ?, 'queued', ?)`,
      )
      .run(
        input.userId ?? null,
        input.sessionId,
        input.content,
        JSON.stringify(input.options ?? {}),
        next.position,
      );

    return mapRow(
      db.prepare('SELECT * FROM queued_messages WHERE id = ?').get(result.lastInsertRowid) as QueuedMessageRow,
    );
  },

  /**
   * Lists one session's queued and failed messages in queue order, including
   * failed ones awaiting retry.
   *
   * `sending` rows are deliberately absent: an in-flight message is already
   * the session's active turn, so it must not keep rendering as a queued card
   * while it is being answered.
   * ponytail: a row orphaned in `sending` by a server crash is therefore
   * invisible until a startup sweep requeues it.
   */
  listBySession(sessionId): QueuedMessage[] {
    const db = getConnection();
    const rows = db
      .prepare(
        `SELECT * FROM queued_messages
         WHERE session_id = ? AND status IN ('queued', 'failed')
         ORDER BY position ASC, id ASC`,
      )
      .all(sessionId) as QueuedMessageRow[];
    return rows.map(mapRow);
  },

  /** Returns the next queued (not yet sending) message for a session. */
  peekNext(sessionId): QueuedMessage | null {
    const db = getConnection();
    const row = db
      .prepare(
        `SELECT * FROM queued_messages
         WHERE session_id = ? AND status = 'queued'
         ORDER BY position ASC, id ASC
         LIMIT 1`,
      )
      .get(sessionId) as QueuedMessageRow | undefined;
    return row ? mapRow(row) : null;
  },

  /** Looks one message up by id, regardless of status. */
  getById(id): QueuedMessage | null {
    const db = getConnection();
    const row = db.prepare('SELECT * FROM queued_messages WHERE id = ?').get(id) as
      | QueuedMessageRow
      | undefined;
    return row ? mapRow(row) : null;
  },

  /** Atomically flips a queued message to `sending`; false if already taken. */
  markSending(id): boolean {
    const db = getConnection();
    const result = db
      .prepare(
        `UPDATE queued_messages
         SET status = 'sending', updated_at = CURRENT_TIMESTAMP
         WHERE id = ? AND status = 'queued'`,
      )
      .run(id);
    return result.changes === 1;
  },

  /** Marks a message `sent` and records its resolved content. */
  markSent(id): void {
    const db = getConnection();
    db.prepare(
      `UPDATE queued_messages
       SET status = 'sent', error = NULL, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?`,
    ).run(id);
  },

  /** Marks a message `failed`, resetting it so a retry can pick it up again. */
  markFailed(id, error): void {
    const db = getConnection();
    db.prepare(
      `UPDATE queued_messages
       SET status = 'failed', error = ?, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?`,
    ).run(error ?? null, id);
  },

  /**
   * Returns every `sending` row to `queued` and reports the affected session
   * ids. A restart mid-dispatch orphans `sending` rows — `listBySession`
   * and `peekNext` both skip them, so without this sweep they stay invisible
   * forever. Called once when the service is created.
   */
  requeueStaleSending(): string[] {
    const db = getConnection();
    const sessions = db
      .prepare(`SELECT DISTINCT session_id FROM queued_messages WHERE status = 'sending'`)
      .all() as { session_id: string }[];
    if (sessions.length === 0) {
      return [];
    }
    db.prepare(
      `UPDATE queued_messages
       SET status = 'queued', updated_at = CURRENT_TIMESTAMP
       WHERE status = 'sending'`,
    ).run();
    return sessions.map((row) => row.session_id);
  },

  /** Returns a sending or failed message to `queued` so a later dispatch can retry it. */
  requeue(id): void {
    const db = getConnection();
    db.prepare(
      `UPDATE queued_messages
       SET status = 'queued', updated_at = CURRENT_TIMESTAMP
       WHERE id = ? AND status IN ('sending', 'failed')`,
    ).run(id);
  },

  /** Deletes one message regardless of status. */
  remove(id): void {
    const db = getConnection();
    db.prepare('DELETE FROM queued_messages WHERE id = ?').run(id);
  },

  /** Moves a message to the front so the next dispatch sends it first. */
  promote(id): void {
    const db = getConnection();
    const row = db
      .prepare('SELECT session_id, position FROM queued_messages WHERE id = ?')
      .get(id) as { session_id: string; position: number } | undefined;
    if (!row) {
      return;
    }
    const min = db
      .prepare(
        `SELECT COALESCE(MIN(position), 0) AS position FROM queued_messages
         WHERE session_id = ? AND status IN ('queued', 'sending')`,
      )
      .get(row.session_id) as { position: number };

    db.prepare('UPDATE queued_messages SET position = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?').run(
      min.position - 1,
      id,
    );
  },
};
