import type { Database } from 'better-sqlite3';

import {
  ACTIVITY_EVENTS_TABLE_SCHEMA_SQL,
  CARD_COMMENTS_TABLE_SCHEMA_SQL,
  COLLAB_INVITES_TABLE_SCHEMA_SQL,
} from '@/modules/database/index.js';

type TableInfoRow = {
  name: string;
};

const tableExists = (db: Database, tableName: string): boolean =>
  Boolean(
    db
      .prepare("SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?")
      .get(tableName),
  );

const columnExists = (db: Database, tableName: string, columnName: string): boolean =>
  (db.prepare(`PRAGMA table_info(${tableName})`).all() as TableInfoRow[]).some(
    (column) => column.name === columnName,
  );

/**
 * Adds the collaboration `role` column to `users`.
 *
 * Existing users are backfilled as 'owner' (the SQLite column default covers
 * the backfill, so no UPDATE sweep is needed). New rows inherit the default
 * too, so every user has a role from creation.
 *
 * Idempotent: safe to call on every boot from runMigrations.
 */
export function addUserRoleColumn(db: Database): void {
  if (!tableExists(db, 'users') || columnExists(db, 'users', 'role')) {
    return;
  }

  console.log('Running migration: Adding role column to users table');
  db.exec("ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'owner'");
}

/**
 * Adds the `assignee_user_id` column to `kanban_cards`.
 *
 * References users.id but deliberately without a FOREIGN KEY clause — SQLite
 * cannot add a FK via ALTER TABLE, and the assignee pickers validate ids
 * against the users list at read time anyway.
 *
 * Idempotent: safe to call on every boot from runMigrations.
 */
export function addCardAssigneeColumn(db: Database): void {
  if (!tableExists(db, 'kanban_cards') || columnExists(db, 'kanban_cards', 'assignee_user_id')) {
    return;
  }

  console.log('Running migration: Adding assignee_user_id column to kanban_cards table');
  db.exec('ALTER TABLE kanban_cards ADD COLUMN assignee_user_id INTEGER');
}

/**
 * Applies the entire collaboration schema: role + assignee columns and the
 * card_comments / activity_events tables.
 *
 * Wired by the coordinator into runMigrations (or initializeDatabase, right
 * after it) so a single call brings any install up to date. Everything inside
 * is idempotent.
 */
export function applyCollabSchema(db: Database): void {
  addUserRoleColumn(db);
  addCardAssigneeColumn(db);
  db.exec(CARD_COMMENTS_TABLE_SCHEMA_SQL);
  db.exec(ACTIVITY_EVENTS_TABLE_SCHEMA_SQL);
  db.exec(COLLAB_INVITES_TABLE_SCHEMA_SQL);
}
