import { getConnection } from '@/modules/database/connection.js';
import type {
  KanbanCard,
  KanbanCardStatus,
  KanbanCardsRepository,
  UpdateKanbanCardInput,
} from '@/shared/types.js';

type KanbanCardRow = {
  card_id: string;
  project_id: string;
  title: string;
  description: string;
  status: string;
  position: number;
  session_id: string | null;
  provider: string | null;
  model: string | null;
  effort: string | null;
  worktree_path: string | null;
  branch: string | null;
  pr_url: string | null;
  status_message: string | null;
  // Added by the Collab module migration (addCardAssigneeColumn); NULL when the
  // card is unassigned.
  assignee_user_id: number | null;
  is_archived: number;
  created_at: string;
  updated_at: string;
};

const KANBAN_CARD_COLUMNS = [
  'card_id',
  'project_id',
  'title',
  'description',
  'status',
  'position',
  'session_id',
  'provider',
  'model',
  'effort',
  'worktree_path',
  'branch',
  'pr_url',
  'status_message',
  'assignee_user_id',
  'is_archived',
  'created_at',
  'updated_at',
].join(', ');

const SQLITE_UTC_TIMESTAMP_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;

function normalizeTimestamp(value: string): string {
  // SQLite CURRENT_TIMESTAMP is UTC without a timezone suffix; normalize it so
  // every card reader returns canonical ISO strings.
  const normalizedValue = SQLITE_UTC_TIMESTAMP_REGEX.test(value)
    ? `${value.replace(' ', 'T')}Z`
    : value;

  const parsed = new Date(normalizedValue);
  return Number.isNaN(parsed.getTime()) ? value : parsed.toISOString();
}

function mapRow(row: KanbanCardRow): KanbanCard {
  return {
    cardId: row.card_id,
    projectId: row.project_id,
    title: row.title,
    description: row.description,
    status: row.status as KanbanCardStatus,
    position: row.position,
    sessionId: row.session_id,
    provider: (row.provider as KanbanCard['provider']) ?? null,
    model: row.model,
    effort: row.effort,
    worktreePath: row.worktree_path,
    branch: row.branch,
    prUrl: row.pr_url,
    statusMessage: row.status_message,
    assigneeUserId: row.assignee_user_id ?? null,
    isArchived: row.is_archived === 1,
    createdAt: normalizeTimestamp(row.created_at),
    updatedAt: normalizeTimestamp(row.updated_at),
  };
}

function readCardRow(cardId: string): KanbanCardRow | undefined {
  const db = getConnection();
  return db
    .prepare(`SELECT ${KANBAN_CARD_COLUMNS} FROM kanban_cards WHERE card_id = ?`)
    .get(cardId) as KanbanCardRow | undefined;
}

/**
 * SQLite persistence for kanban cards.
 *
 * This repository owns queries only; workflow rules (which statuses a user may
 * set, when an agent run is dispatched) live in the Kanban services so they can
 * be unit-tested against the shared `KanbanCardsRepository` contract.
 */
export const kanbanCardsDb: KanbanCardsRepository = {
  list(projectId, options = {}) {
    const db = getConnection();
    const includeArchived = options.includeArchived === true;
    const archivedClause = includeArchived ? '' : 'AND is_archived = 0';
    const rows = db
      .prepare(
        `SELECT ${KANBAN_CARD_COLUMNS} FROM kanban_cards
         WHERE project_id = ? ${archivedClause}
         ORDER BY position ASC, created_at ASC`,
      )
      .all(projectId) as KanbanCardRow[];

    return rows.map(mapRow);
  },

  listAll() {
    const db = getConnection();
    const rows = db
      .prepare(
        `SELECT ${KANBAN_CARD_COLUMNS} FROM kanban_cards
         WHERE is_archived = 0
         ORDER BY position ASC, created_at ASC`,
      )
      .all() as KanbanCardRow[];

    return rows.map(mapRow);
  },

  getById(cardId) {
    const row = readCardRow(cardId);
    return row ? mapRow(row) : null;
  },

  create(input) {
    const db = getConnection();
    const nextPosition = (
      db
        .prepare('SELECT COALESCE(MAX(position), -1) + 1 AS next FROM kanban_cards WHERE project_id = ?')
        .get(input.projectId) as { next: number }
    ).next;

    db.prepare(
      `INSERT INTO kanban_cards
        (card_id, project_id, title, description, status, position, provider, model, effort)
       VALUES (?, ?, ?, ?, 'backlog', ?, ?, ?, ?)`,
    ).run(
      input.cardId,
      input.projectId,
      input.title,
      input.description ?? '',
      nextPosition,
      input.provider ?? null,
      input.model ?? null,
      input.effort ?? null,
    );

    return mapRow(readCardRow(input.cardId) as KanbanCardRow);
  },

  update(cardId, input: UpdateKanbanCardInput) {
    const db = getConnection();
    const assignments: string[] = [];
    const values: Array<string | number | null> = [];

    const push = (column: string, value: string | number | null | undefined) => {
      if (value === undefined) {
        return;
      }
      assignments.push(`${column} = ?`);
      values.push(value);
    };

    push('title', input.title);
    push('description', input.description);
    push('provider', input.provider);
    push('model', input.model);
    push('effort', input.effort);
    push('position', input.position);
    push('assignee_user_id', input.assigneeUserId);

    if (assignments.length === 0) {
      return this.getById(cardId);
    }

    assignments.push('updated_at = CURRENT_TIMESTAMP');
    values.push(cardId);

    db.prepare(`UPDATE kanban_cards SET ${assignments.join(', ')} WHERE card_id = ?`).run(...values);
    return this.getById(cardId);
  },

  move(cardId, status, position) {
    const db = getConnection();
    db.prepare(
      `UPDATE kanban_cards
       SET status = ?, position = ?, is_archived = ?, updated_at = CURRENT_TIMESTAMP
       WHERE card_id = ?`,
    ).run(status, position, status === 'archived' ? 1 : 0, cardId);

    return this.getById(cardId);
  },

  setRuntime(cardId, input) {
    const db = getConnection();
    const assignments: string[] = [];
    const values: Array<string | null> = [];

    const push = (column: string, value: string | null | undefined) => {
      if (value === undefined) {
        return;
      }
      assignments.push(`${column} = ?`);
      values.push(value);
    };

    push('session_id', input.sessionId);
    push('worktree_path', input.worktreePath);
    push('branch', input.branch);
    push('status_message', input.statusMessage);
    push('pr_url', input.prUrl);
    push('report_token', input.reportToken);

    if (assignments.length === 0) {
      return this.getById(cardId);
    }

    assignments.push('updated_at = CURRENT_TIMESTAMP');
    values.push(cardId);

    db.prepare(`UPDATE kanban_cards SET ${assignments.join(', ')} WHERE card_id = ?`).run(...values);
    return this.getById(cardId);
  },

  getReportToken(cardId) {
    const db = getConnection();
    const row = db
      .prepare('SELECT report_token FROM kanban_cards WHERE card_id = ?')
      .get(cardId) as { report_token: string | null } | undefined;
    return row?.report_token ?? null;
  },

  delete(cardId) {
    const db = getConnection();
    const result = db.prepare('DELETE FROM kanban_cards WHERE card_id = ?').run(cardId);
    return result.changes > 0;
  },
};
