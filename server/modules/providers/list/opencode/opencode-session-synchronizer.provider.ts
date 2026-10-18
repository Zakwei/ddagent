import fsSync from 'node:fs';
import path from 'node:path';

import Database from 'better-sqlite3';

import { sessionsDb } from '@/modules/database/index.js';
import type { IProviderSessionSynchronizer } from '@/shared/interfaces.js';
import {
  getOpenCodeDatabasePath,
  isSubagentSessionTitle,
  normalizeProviderTimestamp,
  normalizeSessionName,
  openSqliteReadonlyDatabase,
  readJsonRecord,
  readOptionalString,
  unwrapJsonStringLiteral,
} from '@/shared/utils.js';

type OpenCodeSessionRow = {
  id: string;
  directory: string | null;
  title: string | null;
  time_created: number | null;
  time_updated: number | null;
  worktree: string | null;
  /** `v2` rows come from `session_v2`, `v1` rows from the 1.x `session` table. */
  layout: 'v1' | 'v2';
};

type SynchronizeRowsResult = {
  processed: number;
  firstSessionId: string | null;
};

const tableExists = (db: Database.Database, table: string): boolean =>
  Boolean(db.prepare("SELECT 1 AS present FROM sqlite_master WHERE type = 'table' AND name = ?").get(table));

const tableHasColumn = (db: Database.Database, table: string, column: string): boolean => {
  const columns = db.prepare(`PRAGMA table_info(${table})`).all() as Array<{ name?: unknown }>;
  return columns.some((entry) => entry.name === column);
};

/**
 * Session indexer for OpenCode's SQLite-backed session store.
 *
 * OpenCode 2 writes sessions to `session_v2` (messages to `session_message`);
 * the 1.x tables (`session`/`message`/`part`) stay in the same `opencode.db`
 * until a session is migrated. Both layouts are scanned so transcripts from
 * before the upgrade keep showing up in the sidebar — a session present in
 * both tables is taken from `session_v2`.
 */
export class OpenCodeSessionSynchronizer implements IProviderSessionSynchronizer {
  private readonly provider = 'opencode' as const;

  /**
   * Scans OpenCode's shared opencode.db and upserts active sessions into DB.
   */
  async synchronize(since?: Date): Promise<number> {
    const result = this.synchronizeRows(since);
    return result.processed;
  }

  /**
   * Handles watcher changes for opencode.db.
   */
  async synchronizeFile(filePath: string): Promise<string | null> {
    if (path.basename(filePath) !== 'opencode.db') {
      return null;
    }

    const result = this.synchronizeRows(undefined, 1);
    return result.firstSessionId;
  }

  private synchronizeRows(since?: Date, limit?: number): SynchronizeRowsResult {
    const dbPath = getOpenCodeDatabasePath();
    if (!fsSync.existsSync(dbPath)) {
      return { processed: 0, firstSessionId: null };
    }

    const db = openSqliteReadonlyDatabase(dbPath);
    try {
      this.removeIndexedChildSessions(db);

      const sinceMillis = since?.getTime() ?? null;
      const rows = this.readSessionRows(db, sinceMillis, limit);

      let processed = 0;
      let firstSessionId: string | null = null;
      for (const row of rows) {
        const indexedSessionId = this.upsertSession(db, row);
        if (!indexedSessionId) {
          continue;
        }
        if (!firstSessionId) {
          firstSessionId = indexedSessionId;
        }
        processed += 1;
      }

      return { processed, firstSessionId };
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.warn('[OpenCodeProvider] Failed to synchronize sessions:', message);
      return { processed: 0, firstSessionId: null };
    } finally {
      db.close();
    }
  }

  /**
   * Top-level, non-archived sessions from both layouts, newest first. The
   * `since` cutoff and the optional limit are applied after the union so the
   * watcher's "latest row" pick is correct across layouts.
   */
  private readSessionRows(db: Database.Database, sinceMillis: number | null, limit?: number): OpenCodeSessionRow[] {
    const rows: OpenCodeSessionRow[] = [];
    const seen = new Set<string>();

    const collect = (table: string, layout: 'v1' | 'v2') => {
      if (!tableExists(db, table)) {
        return;
      }
      const hasParentId = tableHasColumn(db, table, 'parent_id');
      const hasArchived = tableHasColumn(db, table, 'time_archived');
      const projectJoin = tableExists(db, 'project') ? 'LEFT JOIN project p ON p.id = s.project_id' : '';
      const worktree = projectJoin ? 'p.worktree' : 'NULL';
      const found = db.prepare(`
        SELECT
          s.id AS id,
          s.directory AS directory,
          s.title AS title,
          s.time_created AS time_created,
          s.time_updated AS time_updated,
          ${worktree} AS worktree
        FROM ${table} s
        ${projectJoin}
        WHERE 1 = 1
          ${hasArchived ? 'AND s.time_archived IS NULL' : ''}
          ${hasParentId ? 'AND s.parent_id IS NULL' : ''}
          AND (? IS NULL OR COALESCE(s.time_updated, s.time_created, 0) >= ?)
        ORDER BY COALESCE(s.time_updated, s.time_created, 0) DESC, s.id DESC
      `).all(sinceMillis, sinceMillis) as Omit<OpenCodeSessionRow, 'layout'>[];
      for (const row of found) {
        if (seen.has(row.id)) {
          continue;
        }
        seen.add(row.id);
        rows.push({ ...row, layout });
      }
    };

    collect('session_v2', 'v2');
    collect('session', 'v1');

    rows.sort((a, b) => {
      const byTime = (b.time_updated ?? b.time_created ?? 0) - (a.time_updated ?? a.time_created ?? 0);
      return byTime !== 0 ? byTime : b.id.localeCompare(a.id);
    });
    return limit ? rows.slice(0, limit) : rows;
  }

  private removeIndexedChildSessions(db: Database.Database): void {
    try {
      const childIds: string[] = [];
      for (const table of ['session_v2', 'session']) {
        if (!tableExists(db, table)) {
          continue;
        }
        const hasParentId = tableHasColumn(db, table, 'parent_id');
        const query = hasParentId
          ? `SELECT id, title FROM ${table} WHERE parent_id IS NOT NULL OR title LIKE '%(@%subagent)%'`
          : `SELECT id, title FROM ${table} WHERE title LIKE '%(@%subagent)%'`;
        const rows = db.prepare(query).all() as Array<{ id: unknown; title?: unknown }>;
        for (const row of rows) {
          const id = readOptionalString(row.id);
          if (id) {
            childIds.push(id);
          }
        }
      }
      if (childIds.length === 0) {
        return;
      }
      sessionsDb.deleteProviderIndexedSessions(this.provider, childIds);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.warn('[OpenCodeProvider] Failed to purge indexed subagent sessions:', message);
    }
  }

  private upsertSession(db: Database.Database, row: OpenCodeSessionRow): string | null {
    const sessionId = readOptionalString(row.id);
    const projectPath = readOptionalString(row.directory) ?? readOptionalString(row.worktree);
    if (!sessionId || !projectPath) {
      return null;
    }

    const titleCandidate = readOptionalString(row.title);
    if (isSubagentSessionTitle(titleCandidate)) {
      return null;
    }
    const fallbackTitle = 'Untitled OpenCode Session';

    // A chat started from the app has a pending app session waiting for its
    // provider id — adopt it instead of indexing a duplicate.
    const pendingAppSession = sessionsDb.getSessionByProviderSessionId(sessionId)
      ?? sessionsDb.getSessionById(sessionId)
      ?? sessionsDb.findLatestPendingAppSession(this.provider, projectPath);
    if (pendingAppSession && !pendingAppSession.provider_session_id) {
      sessionsDb.assignProviderSessionId(pendingAppSession.session_id, sessionId);
    }

    const existingSession = sessionsDb.getSessionByProviderSessionId(sessionId)
      ?? sessionsDb.getSessionById(sessionId);
    const existingName = existingSession?.custom_name;
    let nextName: string | undefined;
    if (existingName && existingName !== fallbackTitle) {
      nextName = existingName;
    } else {
      nextName = titleCandidate ?? this.readFirstUserText(db, sessionId, row.layout);
    }
    if (isSubagentSessionTitle(nextName)) {
      return null;
    }

    return sessionsDb.createSession(
      sessionId,
      this.provider,
      projectPath,
      normalizeSessionName(nextName, fallbackTitle),
      normalizeProviderTimestamp(row.time_created),
      normalizeProviderTimestamp(row.time_updated ?? row.time_created),
      null,
    );
  }

  /** The first user prompt — the title for a session OpenCode never named. */
  private readFirstUserText(db: Database.Database, sessionId: string, layout: 'v1' | 'v2'): string | undefined {
    try {
      if (layout === 'v2') {
        const row = db.prepare(`
          SELECT data
          FROM session_message
          WHERE session_id = ? AND type = 'user'
          ORDER BY seq
          LIMIT 1
        `).get(sessionId) as { data: string | null } | undefined;
        const text = readOptionalString(readJsonRecord(row?.data)?.text);
        return text === undefined ? undefined : unwrapJsonStringLiteral(text);
      }
      const row = db.prepare(`
        SELECT p.data AS data
        FROM message m
        INNER JOIN part p
          ON p.session_id = m.session_id
         AND p.message_id = m.id
        WHERE m.session_id = ?
          AND json_extract(m.data, '$.role') = 'user'
          AND json_extract(p.data, '$.type') = 'text'
        ORDER BY COALESCE(m.time_created, 0), COALESCE(p.time_created, 0)
        LIMIT 1
      `).get(sessionId) as { data: string | null } | undefined;
      const data = readJsonRecord(row?.data);
      const text = readOptionalString(data?.text);
      return text === undefined ? undefined : unwrapJsonStringLiteral(text);
    } catch {
      return undefined;
    }
  }
}
