import fs from 'node:fs';
import path from 'node:path';
import readline from 'node:readline';

import type { Database as DatabaseType } from 'better-sqlite3';

import { sessionsDb } from '@/modules/database/index.js';
import type { IProviderSessionSynchronizer } from '@/shared/interfaces.js';
import {
  devinDataDir,
  isSubagentSessionTitle,
  normalizeSessionName,
  openSqliteReadonlyDatabase,
} from '@/shared/utils.js';

const FALLBACK_TITLE = 'Untitled Devin Session';

/** Row shape read from the Devin CLI's own `cli/sessions.db`. */
type DevinSessionIndexRow = {
  id: string | null;
  working_directory: string | null;
  title: string | null;
  created_at: number | string | null;
  last_activity_at: number | string | null;
};

/** One Devin session normalized for the DDAgent `sessions` table. */
type ImportedDevinSession = {
  id: string;
  workingDirectory: string;
  title: string | null;
  createdAt: string | null;
  updatedAt: string | null;
};

/**
 * Path to the Devin CLI's session index.
 *
 * Resolved per call rather than cached at module load so per-account HOME /
 * APPDATA overrides and tests read the directory the current process actually
 * uses.
 */
function devinSessionsDbPath(): string {
  return path.join(devinDataDir(), 'cli', 'sessions.db');
}

/**
 * Normalizes a Devin timestamp (epoch seconds, epoch millis, or date string)
 * into an ISO string, or null when it cannot be parsed.
 */
function normalizeDevinTimestamp(value: number | string | null | undefined): string | null {
  if (value === null || value === undefined) {
    return null;
  }
  const numeric = typeof value === 'number' ? value : Number(value);
  if (Number.isFinite(numeric)) {
    const millis = numeric < 1_000_000_000_000 ? numeric * 1000 : numeric;
    const date = new Date(millis);
    if (!Number.isNaN(date.getTime())) {
      return date.toISOString();
    }
  }
  if (typeof value === 'string') {
    const date = new Date(value);
    if (!Number.isNaN(date.getTime())) {
      return date.toISOString();
    }
  }
  return null;
}

/** Reports whether an imported timestamp is newer than the scan watermark. */
function isAfterSince(value: string | null, since: Date | undefined): boolean {
  if (!since || !value) {
    return true;
  }
  const valueDate = new Date(value);
  if (Number.isNaN(valueDate.getTime())) {
    return true;
  }
  return valueDate.getTime() > since.getTime();
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}

/**
 * Reads the first JSON object of a transcript file, used to recover the
 * authoritative session id when the file name is a short placeholder.
 */
async function readFirstJsonlObject(filePath: string): Promise<Record<string, unknown> | null> {
  if (!fs.existsSync(filePath)) {
    return null;
  }

  const stream = fs.createReadStream(filePath, { encoding: 'utf8' });
  const lineReader = readline.createInterface({ input: stream, crlfDelay: Infinity });
  try {
    for await (const line of lineReader) {
      const trimmed = line.trim();
      if (!trimmed) {
        continue;
      }
      try {
        const parsed = JSON.parse(trimmed) as unknown;
        return parsed && typeof parsed === 'object' ? (parsed as Record<string, unknown>) : null;
      } catch {
        return null;
      }
    }
  } finally {
    lineReader.close();
    stream.destroy();
  }
  return null;
}

/**
 * Session indexer for the Devin CLI's SQLite session store.
 *
 * Devin keeps every session in one native database and records the absolute
 * `working_directory` each session ran in. Those paths are platform-native
 * (`/workspace/...` on Linux, `C:\...` on Windows), so the indexer must not
 * scope itself to a single hard-coded root: it imports every visible session
 * and registers its working directory as a project. Filtering on the literal
 * `/workspace` (an earlier revision) silently dropped every Windows session.
 *
 * Consumed by the Devin provider's `sessionSynchronizer` facet and invoked on
 * server startup and project-list fetches via the session-synchronizer
 * service.
 */
export class DevinSessionSynchronizer implements IProviderSessionSynchronizer {
  private readonly provider = 'devin' as const;

  /**
   * Reads every visible session from the Devin CLI database, normalized for
   * the DDAgent `sessions` table. Hidden rows and subagent-only sessions are
   * dropped here.
   */
  private queryAllSessions(): ImportedDevinSession[] {
    const dbPath = devinSessionsDbPath();
    if (!fs.existsSync(dbPath)) {
      return [];
    }

    let db: DatabaseType;
    try {
      db = openSqliteReadonlyDatabase(dbPath);
    } catch (error) {
      console.warn('[DevinSessionSynchronizer] Could not open Devin sessions DB:', errorMessage(error));
      return [];
    }

    try {
      const rows = db
        .prepare(
          `SELECT id, working_directory, title, created_at, last_activity_at
           FROM sessions
           WHERE hidden IS NULL OR hidden = 0`,
        )
        .all() as DevinSessionIndexRow[];

      const sessions: ImportedDevinSession[] = [];
      for (const row of rows) {
        const imported = this.toImportedSession(row);
        if (imported) {
          sessions.push(imported);
        }
      }
      return sessions;
    } catch (error) {
      console.warn('[DevinSessionSynchronizer] Failed to query Devin sessions:', errorMessage(error));
      return [];
    } finally {
      try {
        db.close();
      } catch {
        // Ignore close errors.
      }
    }
  }

  /**
   * Maps one native row to an importable session, or null when it must be
   * skipped: rows without an id or working directory, and subagent sessions.
   */
  private toImportedSession(row: DevinSessionIndexRow): ImportedDevinSession | null {
    const id = typeof row.id === 'string' ? row.id.trim() : '';
    const workingDirectory = typeof row.working_directory === 'string' ? row.working_directory.trim() : '';
    if (!id || !workingDirectory) {
      return null;
    }
    if (isSubagentSessionTitle(row.title)) {
      return null;
    }

    const title = typeof row.title === 'string' && row.title.trim()
      ? normalizeSessionName(row.title, FALLBACK_TITLE)
      : null;

    return {
      id,
      workingDirectory,
      title,
      createdAt: normalizeDevinTimestamp(row.created_at ?? row.last_activity_at),
      updatedAt: normalizeDevinTimestamp(row.last_activity_at ?? row.created_at),
    };
  }

  /**
   * Scans the Devin CLI database and upserts every visible session into DB.
   *
   * Unlike the JSONL watchers there is no Devin filesystem watch path, so this
   * full scan is the only way externally-created Devin sessions reach the
   * sidebar.
   */
  async synchronize(since?: Date): Promise<number> {
    const sessions = this.queryAllSessions();

    let processed = 0;
    for (const session of sessions) {
      try {
        const existing = sessionsDb.getSessionByProviderSessionId(session.id);
        if (existing && existing.updated_at === session.updatedAt) {
          continue;
        }
        if (!isAfterSince(session.updatedAt, since) && existing) {
          continue;
        }

        // A scheduled rescan can observe a just-created Devin session in the
        // native DB before the runtime maps its provider id onto the pending
        // app row. Claim that row first so the upsert updates it in place
        // instead of leaving a provider-keyed duplicate that only disappears
        // when the run's own mapping lands.
        if (!existing) {
          const pendingAppSession = sessionsDb.getSessionById(session.id)
            ?? sessionsDb.findLatestPendingAppSession(this.provider, session.workingDirectory);
          if (pendingAppSession && !pendingAppSession.provider_session_id) {
            sessionsDb.assignProviderSessionId(pendingAppSession.session_id, session.id);
          }
        }

        const jsonlPath = path.join(session.workingDirectory, '.ddagent', 'devin', `${session.id}.jsonl`);
        sessionsDb.createSession(
          session.id,
          this.provider,
          session.workingDirectory,
          session.title ?? undefined,
          session.createdAt ?? undefined,
          session.updatedAt ?? undefined,
          jsonlPath,
        );
        processed += 1;
      } catch (error) {
        console.warn(`[DevinSessionSynchronizer] Failed to sync ${session.id}:`, errorMessage(error));
      }
    }

    return processed;
  }

  /**
   * Upserts the session matching a watched `<repo>/.ddagent/devin/<id>.jsonl`
   * transcript, resolving the authoritative metadata from the native DB.
   */
  async synchronizeFile(filePath: string): Promise<string | null> {
    const resolvedPath = path.resolve(filePath);
    if (!resolvedPath.endsWith('.jsonl')) {
      return null;
    }

    const devinDir = path.dirname(resolvedPath);
    const ddagentDir = path.dirname(devinDir);
    const repoPath = path.dirname(ddagentDir);

    if (path.basename(ddagentDir) !== '.ddagent' || path.basename(devinDir) !== 'devin') {
      return null;
    }

    let sessionId = path.basename(resolvedPath, '.jsonl');
    if (!sessionId) {
      return null;
    }

    let firstLine: Record<string, unknown> | null = null;
    try {
      firstLine = await readFirstJsonlObject(resolvedPath);
    } catch (error) {
      console.warn(`[DevinSessionSynchronizer] Failed to read first line of ${resolvedPath}:`, errorMessage(error));
    }

    if (firstLine && typeof firstLine.sessionId === 'string' && firstLine.sessionId.trim()) {
      sessionId = firstLine.sessionId.trim();
    }

    const native = this.readNativeSessionMeta(sessionId);
    let title = native?.title ?? null;
    let createdAt = native?.createdAt ?? null;
    let updatedAt = native?.updatedAt ?? null;

    if (isSubagentSessionTitle(title)) {
      return null;
    }

    if (!updatedAt && firstLine && typeof firstLine.timestamp === 'string') {
      const timestamp = normalizeDevinTimestamp(firstLine.timestamp);
      if (timestamp) {
        updatedAt = timestamp;
        createdAt = createdAt ?? timestamp;
      }
    }

    try {
      sessionsDb.createSession(
        sessionId,
        this.provider,
        repoPath,
        title ? normalizeSessionName(title, FALLBACK_TITLE) : undefined,
        createdAt ?? undefined,
        updatedAt ?? undefined,
        resolvedPath,
      );
    } catch (error) {
      console.warn(`[DevinSessionSynchronizer] Failed to sync file ${resolvedPath}:`, errorMessage(error));
      return null;
    }

    return sessionId;
  }

  /**
   * Reads title/timestamps for one native session id from the Devin CLI DB,
   * or null when the database or row is unavailable.
   */
  private readNativeSessionMeta(
    sessionId: string,
  ): { title: string | null; createdAt: string | null; updatedAt: string | null } | null {
    const dbPath = devinSessionsDbPath();
    if (!fs.existsSync(dbPath)) {
      return null;
    }

    let db: DatabaseType | null = null;
    try {
      db = openSqliteReadonlyDatabase(dbPath);
      const row = db
        .prepare('SELECT title, created_at, last_activity_at FROM sessions WHERE id = ?')
        .get(sessionId) as Pick<DevinSessionIndexRow, 'title' | 'created_at' | 'last_activity_at'> | undefined;
      if (!row) {
        return null;
      }
      return {
        title: typeof row.title === 'string' ? row.title : null,
        createdAt: normalizeDevinTimestamp(row.created_at ?? row.last_activity_at),
        updatedAt: normalizeDevinTimestamp(row.last_activity_at ?? row.created_at),
      };
    } catch {
      return null;
    } finally {
      try {
        db?.close();
      } catch {
        // Ignore close errors.
      }
    }
  }
}
