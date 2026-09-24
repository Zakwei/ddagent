import { getConnection } from '@/modules/database/connection.js';
import type { KanbanCardComment, KanbanCardCommentsRepository } from '@/shared/types.js';

/**
 * Card comments table for the Collab module.
 *
 * Created lazily via `applyCollabSchema` (server/modules/collab/
 * collab-migrations.ts) rather than INIT_SCHEMA_SQL so installs that never
 * enable collaboration never grow the table. `card_id` is intentionally not a
 * hard foreign key: deleting a card must not strand on cascade rules, and the
 * kanban service already guards comment writes with `requireCard`.
 */
export const CARD_COMMENTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS card_comments (
    id TEXT PRIMARY KEY,
    card_id TEXT NOT NULL,
    user_id INTEGER,
    body TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_card_comments_card ON card_comments(card_id, created_at);
`;

type CardCommentRow = {
  id: string;
  card_id: string;
  user_id: number | null;
  body: string;
  created_at: string;
};

const SQLITE_UTC_TIMESTAMP_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

// Same normalization as kanban-cards.db.ts: SQLite CURRENT_TIMESTAMP is UTC
// without a suffix, so readers always get canonical ISO strings.
function normalizeTimestamp(value: string): string {
  const normalizedValue = SQLITE_UTC_TIMESTAMP_REGEX.test(value)
    ? `${value.replace(' ', 'T')}Z`
    : value;
  const parsed = new Date(normalizedValue);
  return Number.isNaN(parsed.getTime()) ? value : parsed.toISOString();
}

function mapRow(row: CardCommentRow): KanbanCardComment {
  return {
    id: row.id,
    cardId: row.card_id,
    userId: row.user_id ?? null,
    body: row.body,
    createdAt: normalizeTimestamp(row.created_at),
  };
}

/**
 * SQLite persistence for kanban card comments.
 *
 * Consumed by the Kanban card service (list/add + broadcast) — wired through
 * the database barrel once the coordinator adds the export.
 */
export const cardCommentsDb: KanbanCardCommentsRepository = {
  listByCard(cardId) {
    const db = getConnection();
    const rows = db
      .prepare(
        `SELECT id, card_id, user_id, body, created_at
         FROM card_comments
         WHERE card_id = ?
         ORDER BY created_at ASC, rowid ASC`,
      )
      .all(cardId) as CardCommentRow[];
    return rows.map(mapRow);
  },

  create(input) {
    const db = getConnection();
    db.prepare(
      `INSERT INTO card_comments (id, card_id, user_id, body)
       VALUES (?, ?, ?, ?)`,
    ).run(input.id, input.cardId, input.userId, input.body);

    const row = db
      .prepare('SELECT id, card_id, user_id, body, created_at FROM card_comments WHERE id = ?')
      .get(input.id) as CardCommentRow;
    return mapRow(row);
  },

  delete(id) {
    const db = getConnection();
    return db.prepare('DELETE FROM card_comments WHERE id = ?').run(id).changes > 0;
  },

  deleteByCard(cardId) {
    const db = getConnection();
    return db.prepare('DELETE FROM card_comments WHERE card_id = ?').run(cardId).changes;
  },
};
