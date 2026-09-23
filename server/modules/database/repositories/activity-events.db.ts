import { getConnection } from '@/modules/database/connection.js';
import type { ActivityEvent, ActivityEventsRepository } from '@/shared/types.js';

/**
 * Activity feed table for the Collab module.
 *
 * One row per board action (card created/moved/assigned/commented). Created
 * lazily via `applyCollabSchema` (server/modules/collab/collab-migrations.ts).
 * `project_id` is denormalized onto the row so `GET /activity?projectId=`
 * stays a single indexed read and survives deletion of the underlying card.
 */
export const ACTIVITY_EVENTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS activity_events (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    user_id INTEGER,
    kind TEXT NOT NULL,
    entity_id TEXT,
    summary TEXT NOT NULL DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_activity_events_project ON activity_events(project_id, created_at);
`;

const ACTIVITY_LIST_MAX_LIMIT = 200;
const ACTIVITY_LIST_DEFAULT_LIMIT = 50;

type ActivityEventRow = {
  id: string;
  project_id: string | null;
  user_id: number | null;
  kind: string;
  entity_id: string | null;
  summary: string;
  created_at: string;
};

const SQLITE_UTC_TIMESTAMP_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

function normalizeTimestamp(value: string): string {
  const normalizedValue = SQLITE_UTC_TIMESTAMP_REGEX.test(value)
    ? `${value.replace(' ', 'T')}Z`
    : value;
  const parsed = new Date(normalizedValue);
  return Number.isNaN(parsed.getTime()) ? value : parsed.toISOString();
}

function mapRow(row: ActivityEventRow): ActivityEvent {
  return {
    id: row.id,
    projectId: row.project_id,
    userId: row.user_id ?? null,
    kind: row.kind,
    entityId: row.entity_id,
    summary: row.summary,
    createdAt: normalizeTimestamp(row.created_at),
  };
}

/**
 * SQLite persistence for the collaboration activity feed.
 *
 * Written by the Kanban card service (via the injected ActivityRecorder) and
 * read by the Collab routes — wired through the database barrel once the
 * coordinator adds the export.
 */
export const activityEventsDb: ActivityEventsRepository = {
  record(input) {
    const db = getConnection();
    db.prepare(
      `INSERT INTO activity_events (id, project_id, user_id, kind, entity_id, summary)
       VALUES (?, ?, ?, ?, ?, ?)`,
    ).run(input.id, input.projectId, input.userId, input.kind, input.entityId, input.summary);

    const row = db
      .prepare(
        `SELECT id, project_id, user_id, kind, entity_id, summary, created_at
         FROM activity_events WHERE id = ?`,
      )
      .get(input.id) as ActivityEventRow;
    return mapRow(row);
  },

  listByProject(projectId, limit = ACTIVITY_LIST_DEFAULT_LIMIT) {
    const db = getConnection();
    const safeLimit = Number.isInteger(limit) && limit > 0
      ? Math.min(limit, ACTIVITY_LIST_MAX_LIMIT)
      : ACTIVITY_LIST_DEFAULT_LIMIT;
    const rows = db
      .prepare(
        `SELECT id, project_id, user_id, kind, entity_id, summary, created_at
         FROM activity_events
         WHERE project_id = ?
         ORDER BY created_at DESC, rowid DESC
         LIMIT ?`,
      )
      .all(projectId, safeLimit) as ActivityEventRow[];
    return rows.map(mapRow);
  },
};
