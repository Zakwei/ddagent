import { getConnection } from '@/modules/database/connection.js';

export const COLLAB_INVITES_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS collab_invites (
  id TEXT PRIMARY KEY,
  token TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL DEFAULT 'member',
  created_by INTEGER,
  used_by INTEGER,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)`;

export type CollabInvite = {
  id: string;
  token: string;
  role: 'member' | 'viewer';
  createdBy: number | null;
  usedBy: number | null;
  expiresAt: string;
  createdAt: string;
};

type InviteRow = {
  id: string;
  token: string;
  role: string;
  created_by: number | null;
  used_by: number | null;
  expires_at: string;
  created_at: string;
};

function mapRow(row: InviteRow): CollabInvite {
  return {
    id: row.id,
    token: row.token,
    role: row.role === 'viewer' ? 'viewer' : 'member',
    createdBy: row.created_by,
    usedBy: row.used_by,
    expiresAt: row.expires_at,
    createdAt: row.created_at,
  };
}

/**
 * Persistence for single-use invite tokens. Invites are how non-owner
 * accounts come into existence: the owner mints a link, the invitee registers
 * with it, and the token is burned on use.
 */
export const collabInvitesDb = {
  create(input: {
    id: string;
    token: string;
    role: 'member' | 'viewer';
    createdBy: number | null;
    expiresAt: string;
  }): CollabInvite {
    const db = getConnection();
    db.prepare(
      `INSERT INTO collab_invites (id, token, role, created_by, expires_at)
       VALUES (?, ?, ?, ?, ?)`,
    ).run(input.id, input.token, input.role, input.createdBy, input.expiresAt);
    return mapRow(
      db.prepare('SELECT * FROM collab_invites WHERE id = ?').get(input.id) as InviteRow,
    );
  },

  /** Peeks at a live (unused, unexpired) invite without consuming it. */
  findValid(token: string): CollabInvite | null {
    const db = getConnection();
    const row = db
      .prepare(
        `SELECT * FROM collab_invites
         WHERE token = ? AND used_by IS NULL AND datetime(expires_at) > datetime('now')`,
      )
      .get(token) as InviteRow | undefined;
    return row ? mapRow(row) : null;
  },

  /**
   * Atomically burns a valid invite for `userId` and returns it, or null when
   * the token is unknown, expired, or already used. Conditional UPDATE keeps
   * the burn race-free.
   */
  consume(token: string, userId: number): CollabInvite | null {
    const db = getConnection();
    const claimed = db
      .prepare(
        `UPDATE collab_invites SET used_by = ?
         WHERE token = ? AND used_by IS NULL AND datetime(expires_at) > datetime('now')`,
      )
      .run(userId, token);
    if (claimed.changes === 0) {
      return null;
    }
    const row = db.prepare('SELECT * FROM collab_invites WHERE token = ?').get(token) as InviteRow;
    return mapRow(row);
  },
};
