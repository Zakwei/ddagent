import fsSync from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import type { Database as DatabaseType } from 'better-sqlite3';

import { sessionsDb } from '@/modules/database/index.js';
import { hasPendingAntigravityLaunch } from '@/modules/providers/list/antigravity/antigravity-runtime.provider.js';
import type { IProviderSessionSynchronizer } from '@/shared/interfaces.js';
import {
  antigravityConversationsDir,
  antigravitySummariesDbPath,
  antigravityTranscriptDir,
  isSubagentSessionTitle,
  normalizeSessionName,
  openSqliteReadonlyDatabase,
  readOptionalString,
} from '@/shared/utils.js';

type AntigravitySummaryRow = {
  conversation_id: string;
  title: string;
  preview: string;
  last_modified_time: string;
  last_user_input_time: string;
  workspace_uris: string;
  source: string;
  agent_name: string;
  killed: number;
};

const FALLBACK_TITLE = 'Untitled Antigravity Session';

/** Best-effort datetime parse; Antigravity stamps RFC3339 with nanoseconds. */
function parseSummaryTime(value: string | null | undefined): string | null {
  if (!value || typeof value !== 'string') {
    return null;
  }
  const trimmed = value.trim();
  // SQLite stores the zero time '0001-01-01 00:00:00+00:00' for conversations
  // that never produced a turn — treat it as "no timestamp".
  if (!trimmed || trimmed.startsWith('0001-01-01')) {
    return null;
  }
  const parsed = new Date(trimmed.replace(' ', 'T'));
  return Number.isNaN(parsed.getTime()) ? null : parsed.toISOString();
}

/** First `file://` workspace URI → filesystem path; anything else is skipped. */
function projectPathFromWorkspaceUris(workspaceUris: string | null | undefined): string | null {
  if (!workspaceUris || typeof workspaceUris !== 'string') {
    return null;
  }
  try {
    const uris = JSON.parse(workspaceUris) as unknown;
    if (!Array.isArray(uris)) {
      return null;
    }
    for (const uri of uris) {
      if (typeof uri !== 'string' || !uri.startsWith('file://')) {
        continue;
      }
      try {
        return fileURLToPath(uri);
      } catch {
        // Malformed URI — keep scanning the remaining entries.
      }
    }
  } catch {
    // workspace_uris is not a JSON array — no project mapping.
  }
  return null;
}

/**
 * Session indexer for Antigravity conversations.
 *
 * The CLI keeps a `conversation_summaries` SQLite index at
 * `~/.gemini/antigravity-cli/conversation_summaries.db` (one row per
 * conversation: id, title, preview, `workspace_uris` JSON array, timestamps)
 * alongside opaque protobuf `conversations/<id>.db` stores. The summaries
 * table is the only readable source of titles/workspaces, so indexing is a
 * DB scan rather than a directory walk; `synchronizeFile` resolves the row
 * matching a watched `<id>.db`.
 */
export class AntigravitySessionSynchronizer implements IProviderSessionSynchronizer {
  private readonly provider = 'antigravity' as const;

  private openSummaries(): DatabaseType | null {
    try {
      return openSqliteReadonlyDatabase(antigravitySummariesDbPath());
    } catch {
      // Missing ~/.gemini/antigravity-cli is the normal not-installed state.
      return null;
    }
  }

  /**
   * Upserts one conversation-summary row. Returns the stored row id so
   * watcher-triggered `session_upserted` events stay on the app session once
   * `provider_session_id` is mapped.
   */
  private processSummaryRow(row: AntigravitySummaryRow): string | null {
    if (!row?.conversation_id || row.killed) {
      return null;
    }

    const projectPath = projectPathFromWorkspaceUris(row.workspace_uris);
    if (!projectPath) {
      return null;
    }

    // Hidden technical conversations must never claim a pending app row.
    if (isSubagentSessionTitle(readOptionalString(row.title) ?? readOptionalString(row.preview))) {
      return null;
    }

    let existingSession = sessionsDb.getSessionByProviderSessionId(row.conversation_id)
      ?? sessionsDb.getSessionById(row.conversation_id);
    if (!existingSession && hasPendingAntigravityLaunch(projectPath)) {
      // A DDAgent launch in this project has not reported its conversation id
      // yet. Guessing the newest pending row can bind the wrong chat (two new
      // chats at once) and the runtime would then delete it as a duplicate;
      // skip — the runtime binds on `init` and the next scan indexes the rest.
      return null;
    }
    if (!existingSession) {
      const pendingAppSession = sessionsDb.findLatestPendingAppSession(this.provider, projectPath);
      if (pendingAppSession) {
        // The watcher can index the summary row after the runtime exited
        // without reporting its id; bind it to the fresh app row so the
        // sidebar does not get a duplicate provider-id entry.
        sessionsDb.assignProviderSessionId(pendingAppSession.session_id, row.conversation_id);
        existingSession = sessionsDb.getSessionById(pendingAppSession.session_id);
      }
    }

    const existingName = existingSession?.custom_name;
    const title = existingName && existingName !== FALLBACK_TITLE
      ? existingName
      : (readOptionalString(row.title) ?? readOptionalString(row.preview));

    if (isSubagentSessionTitle(title)) {
      return null;
    }

    const timestamps = parseSummaryTime(row.last_modified_time)
      ?? parseSummaryTime(row.last_user_input_time);

    // The mirror transcript only exists for sessions a DDAgent runtime ran.
    const mirrorPath = path.join(
      antigravityTranscriptDir(projectPath),
      `${row.conversation_id}.jsonl`,
    );
    const jsonlPath = fsSync.existsSync(mirrorPath) ? mirrorPath : null;

    return sessionsDb.createSession(
      row.conversation_id,
      this.provider,
      projectPath,
      normalizeSessionName(title, FALLBACK_TITLE),
      timestamps ?? undefined,
      timestamps ?? undefined,
      jsonlPath ?? undefined,
    );
  }

  /**
   * Scans the conversation-summaries index and upserts discovered sessions
   * into DB. `since` filters on `last_modified_time` — summary rows carry
   * RFC3339-with-nanoseconds strings, so a lexicographic compare on the
   * normalized form is exact enough for a sync watermark.
   */
  async synchronize(since?: Date): Promise<number> {
    const db = this.openSummaries();
    if (!db) {
      return 0;
    }

    try {
      const rows = db.prepare(
        'SELECT conversation_id, title, preview, last_modified_time, last_user_input_time, workspace_uris, source, agent_name, killed FROM conversation_summaries',
      ).all() as AntigravitySummaryRow[];

      const sinceIso = since ? since.toISOString() : null;
      let processed = 0;
      for (const row of rows) {
        if (sinceIso) {
          const modified = parseSummaryTime(row.last_modified_time);
          if (!modified || modified < sinceIso) {
            continue;
          }
        }
        if (this.processSummaryRow(row)) {
          processed += 1;
        }
      }
      return processed;
    } finally {
      db.close();
    }
  }

  /**
   * Upserts the conversation matching a watched artifact. Watched paths are
   * `conversations/<id>.db` (per-conversation store) or the summaries index
   * itself — the summaries row is the only readable source of truth, so a
   * `<id>.db` event is resolved through it.
   */
  async synchronizeFile(filePath: string): Promise<string | null> {
    const basename = path.basename(filePath);
    const isSummaries = basename === 'conversation_summaries.db';
    const match = /^([0-9a-fA-F-]{32,36})\.db$/.exec(basename);
    if (!isSummaries && (!match || path.dirname(filePath) !== antigravityConversationsDir())) {
      return null;
    }

    const db = this.openSummaries();
    if (!db) {
      return null;
    }

    try {
      if (isSummaries) {
        // The index itself changed — sync the newest few rows (bounded) rather
        // than rescanning every conversation.
        const rows = db.prepare(
          'SELECT conversation_id, title, preview, last_modified_time, last_user_input_time, workspace_uris, source, agent_name, killed FROM conversation_summaries ORDER BY last_modified_time DESC LIMIT 25',
        ).all() as AntigravitySummaryRow[];
        let lastId: string | null = null;
        for (const row of rows) {
          lastId = this.processSummaryRow(row) ?? lastId;
        }
        return lastId;
      }

      const row = db.prepare(
        'SELECT conversation_id, title, preview, last_modified_time, last_user_input_time, workspace_uris, source, agent_name, killed FROM conversation_summaries WHERE conversation_id = ?',
      ).get(match![1]) as AntigravitySummaryRow | undefined;
      if (!row) {
        return null;
      }
      return this.processSummaryRow(row);
    } finally {
      db.close();
    }
  }
}
