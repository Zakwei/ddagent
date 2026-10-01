/**
 * Workspace state repository.
 *
 * One row per user holding the client's split-workspace descriptor (open
 * session panes, active pane, last used project) as opaque JSON. The server
 * never inspects the payload — it only stamps a monotonically increasing
 * `revision` so clients can apply last-write-wins across devices.
 */

import { getConnection } from '@/modules/database/connection.js';

export type WorkspaceStateRow = {
  /** Parsed workspace payload, or null when the stored JSON was unreadable. */
  state: unknown;
  revision: number;
};

export const workspaceStateDb = {
  /** Returns the stored workspace for a user, or null when none was saved. */
  get(userId: number): WorkspaceStateRow | null {
    const db = getConnection();
    const row = db
      .prepare('SELECT state_json, revision FROM user_workspace_state WHERE user_id = ?')
      .get(userId) as { state_json: string; revision: number } | undefined;

    if (!row) {
      return null;
    }

    let state: unknown = null;
    try {
      state = JSON.parse(row.state_json);
    } catch {
      // A corrupted row still reports its revision so clients don't loop on it.
    }
    return { state, revision: row.revision };
  },

  /** Upserts the workspace payload and returns the new revision. */
  put(userId: number, stateJson: string): number {
    const db = getConnection();
    db.prepare(
      `INSERT INTO user_workspace_state (user_id, state_json, revision, updated_at)
       VALUES (?, ?, 1, CURRENT_TIMESTAMP)
       ON CONFLICT(user_id) DO UPDATE SET
         state_json = excluded.state_json,
         revision = revision + 1,
         updated_at = CURRENT_TIMESTAMP`
    ).run(userId, stateJson);

    const row = db
      .prepare('SELECT revision FROM user_workspace_state WHERE user_id = ?')
      .get(userId) as { revision: number };
    return row.revision;
  },
};
