import { getConnection } from '@/modules/database/connection.js';

/**
 * A recurring agent run. `next_run_at` is materialized at write time (and after
 * each fire) so the ticker only has to compare timestamps.
 */
export type ScheduleRow = {
  id: string;
  project_id: string;
  provider: string;
  cron: string;
  prompt: string;
  use_worktree: number;
  catch_up: number;
  enabled: number;
  fail_count: number;
  last_run_at: string | null;
  next_run_at: string | null;
  created_at: string;
};

export type Schedule = {
  id: string;
  projectId: string;
  provider: string;
  cron: string;
  prompt: string;
  useWorktree: boolean;
  catchUp: boolean;
  enabled: boolean;
  failCount: number;
  lastRunAt: string | null;
  nextRunAt: string | null;
  createdAt: string;
};

export type ScheduleRunRow = {
  id: string;
  schedule_id: string;
  session_id: string | null;
  status: string;
  error: string | null;
  started_at: string;
  finished_at: string | null;
};

export type ScheduleRun = {
  id: string;
  scheduleId: string;
  sessionId: string | null;
  status: 'fired' | 'skipped' | 'failed' | 'completed';
  error: string | null;
  startedAt: string;
  finishedAt: string | null;
};

function toSchedule(row: ScheduleRow): Schedule {
  return {
    id: row.id,
    projectId: row.project_id,
    provider: row.provider,
    cron: row.cron,
    prompt: row.prompt,
    useWorktree: row.use_worktree === 1,
    catchUp: row.catch_up === 1,
    enabled: row.enabled === 1,
    failCount: row.fail_count,
    lastRunAt: row.last_run_at,
    nextRunAt: row.next_run_at,
    createdAt: row.created_at,
  };
}

function toScheduleRun(row: ScheduleRunRow): ScheduleRun {
  return {
    id: row.id,
    scheduleId: row.schedule_id,
    sessionId: row.session_id,
    status: row.status as ScheduleRun['status'],
    error: row.error,
    startedAt: row.started_at,
    finishedAt: row.finished_at,
  };
}

export const schedulesDb = {
  list(): Schedule[] {
    const db = getConnection();
    const rows = db
      .prepare('SELECT * FROM schedules ORDER BY created_at, id')
      .all() as ScheduleRow[];
    return rows.map(toSchedule);
  },

  get(id: string): Schedule | null {
    const db = getConnection();
    const row = db.prepare('SELECT * FROM schedules WHERE id = ?').get(id) as
      | ScheduleRow
      | undefined;
    return row ? toSchedule(row) : null;
  },

  create(input: {
    id: string;
    projectId: string;
    provider: string;
    cron: string;
    prompt: string;
    useWorktree?: boolean;
    catchUp?: boolean;
    enabled?: boolean;
    nextRunAt?: string | null;
  }): Schedule {
    const db = getConnection();
    db.prepare(
      `INSERT INTO schedules
         (id, project_id, provider, cron, prompt, use_worktree, catch_up, enabled, next_run_at, created_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)`,
    ).run(
      input.id,
      input.projectId,
      input.provider,
      input.cron,
      input.prompt,
      input.useWorktree ? 1 : 0,
      input.catchUp ? 1 : 0,
      input.enabled === false ? 0 : 1,
      input.nextRunAt ?? null,
    );
    return this.get(input.id) as Schedule;
  },

  update(
    id: string,
    patch: Partial<{
      projectId: string;
      provider: string;
      cron: string;
      prompt: string;
      useWorktree: boolean;
      catchUp: boolean;
      enabled: boolean;
      nextRunAt: string | null;
      lastRunAt: string | null;
      failCount: number;
    }>,
  ): Schedule | null {
    const db = getConnection();
    const existing = db.prepare('SELECT * FROM schedules WHERE id = ?').get(id) as
      | ScheduleRow
      | undefined;
    if (!existing) return null;

    db.prepare(
      `UPDATE schedules SET
         project_id = ?, provider = ?, cron = ?, prompt = ?,
         use_worktree = ?, catch_up = ?, enabled = ?,
         fail_count = ?, last_run_at = ?, next_run_at = ?
       WHERE id = ?`,
    ).run(
      patch.projectId ?? existing.project_id,
      patch.provider ?? existing.provider,
      patch.cron ?? existing.cron,
      patch.prompt ?? existing.prompt,
      (patch.useWorktree ?? existing.use_worktree === 1) ? 1 : 0,
      (patch.catchUp ?? existing.catch_up === 1) ? 1 : 0,
      (patch.enabled ?? existing.enabled === 1) ? 1 : 0,
      patch.failCount ?? existing.fail_count,
      patch.lastRunAt === undefined ? existing.last_run_at : patch.lastRunAt,
      patch.nextRunAt === undefined ? existing.next_run_at : patch.nextRunAt,
      id,
    );
    return this.get(id);
  },

  remove(id: string): boolean {
    const db = getConnection();
    return db.prepare('DELETE FROM schedules WHERE id = ?').run(id).changes > 0;
  },

  /** Enabled schedules whose materialized next run is at or before `nowIso`. */
  listDue(nowIso: string): Schedule[] {
    const db = getConnection();
    const rows = db
      .prepare(
        `SELECT * FROM schedules
         WHERE enabled = 1 AND next_run_at IS NOT NULL AND next_run_at <= ?
         ORDER BY next_run_at, id`,
      )
      .all(nowIso) as ScheduleRow[];
    return rows.map(toSchedule);
  },

  listRuns(scheduleId: string, limit = 50): ScheduleRun[] {
    const db = getConnection();
    const rows = db
      .prepare(
        `SELECT * FROM schedule_runs
         WHERE schedule_id = ? ORDER BY started_at DESC, id DESC LIMIT ?`,
      )
      .all(scheduleId, limit) as ScheduleRunRow[];
    return rows.map(toScheduleRun);
  },

  recordRun(input: {
    id: string;
    scheduleId: string;
    sessionId?: string | null;
    status: ScheduleRun['status'];
    error?: string | null;
    finishedAt?: string | null;
  }): ScheduleRun {
    const db = getConnection();
    db.prepare(
      `INSERT INTO schedule_runs (id, schedule_id, session_id, status, error, started_at, finished_at)
       VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, ?)`,
    ).run(
      input.id,
      input.scheduleId,
      input.sessionId ?? null,
      input.status,
      input.error ?? null,
      input.finishedAt ?? null,
    );
    const row = db
      .prepare('SELECT * FROM schedule_runs WHERE id = ?')
      .get(input.id) as ScheduleRunRow;
    return toScheduleRun(row);
  },

  markRunFinished(id: string, status: ScheduleRun['status'], error?: string | null): void {
    const db = getConnection();
    db.prepare(
      'UPDATE schedule_runs SET status = ?, error = ?, finished_at = CURRENT_TIMESTAMP WHERE id = ?',
    ).run(status, error ?? null, id);
  },
};
