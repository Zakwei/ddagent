import { getConnection } from '@/modules/database/connection.js';
import type { QuotaHistoryPoint, QuotaSnapshotsRepository } from '@/shared/types.js';

type QuotaSnapshotRow = {
  window_label: string;
  percent: number;
  resets_at: string | null;
  captured_at: string;
};

const SQLITE_UTC_TIMESTAMP_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

function normalizeTimestamp(value: string): string {
  const normalized = SQLITE_UTC_TIMESTAMP_REGEX.test(value)
    ? `${value.replace(' ', 'T')}Z`
    : value;
  const parsed = new Date(normalized);
  return Number.isNaN(parsed.getTime()) ? value : parsed.toISOString();
}

/**
 * SQLite persistence for quota snapshot history.
 *
 * One row is appended per (account, window) on every provider sweep; the
 * Quota service prunes the table so it stays a rolling window rather than
 * growing without bound.
 */
export const quotaSnapshotsDb: QuotaSnapshotsRepository = {
  record(entries) {
    if (entries.length === 0) {
      return;
    }

    const db = getConnection();
    const insert = db.prepare(
      `INSERT INTO quota_snapshots
        (account_id, provider, window_label, window_kind, percent, resets_at, captured_at)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
    );

    // One transaction so a sweep is all-or-nothing and fast on SQLite.
    db.transaction(() => {
      for (const entry of entries) {
        insert.run(
          entry.accountId,
          entry.provider,
          entry.windowLabel,
          entry.windowKind,
          entry.percent,
          entry.resetsAt,
          entry.capturedAt,
        );
      }
    })();
  },

  listByAccount(accountId, limit) {
    if (!Number.isFinite(limit) || limit <= 0) {
      return [];
    }

    const db = getConnection();
    // Pick the newest N rows first, then reverse so the caller gets
    // oldest-first points ready for a left-to-right sparkline.
    const rows = db
      .prepare(
        `SELECT window_label, percent, resets_at, captured_at
         FROM quota_snapshots
         WHERE account_id = ?
         ORDER BY captured_at DESC, id DESC
         LIMIT ?`,
      )
      .all(accountId, limit) as QuotaSnapshotRow[];

    return rows
      .map<QuotaHistoryPoint>((row) => ({
        label: row.window_label,
        percent: row.percent,
        at: normalizeTimestamp(row.captured_at),
        resetsAt: row.resets_at,
      }))
      .reverse();
  },

  pruneBefore(cutoffIso) {
    const db = getConnection();
    const result = db
      .prepare('DELETE FROM quota_snapshots WHERE captured_at < ?')
      .run(cutoffIso);
    return result.changes;
  },
};
