import { randomUUID } from 'node:crypto';

import type { Schedule } from '@/modules/database/index.js';

import { nextCronTime, parseCron } from './cron.js';

const TICK_MS = 30_000;
const MISSED_RUN_THRESHOLD_MS = 5 * 60_000;
const MAX_CONSECUTIVE_FAILURES = 5;

export type ScheduleExecutor = (schedule: Schedule) => Promise<{ sessionId: string }>;

type SchedulerStore = {
  listDue(nowIso: string): Schedule[];
  recordRun(input: {
    id: string;
    scheduleId: string;
    sessionId?: string | null;
    status: 'fired' | 'skipped' | 'failed' | 'completed';
    error?: string | null;
  }): unknown;
  update(id: string, patch: Partial<{
    enabled: boolean;
    failCount: number;
    lastRunAt: string | null;
    nextRunAt: string | null;
  }>): unknown;
};

type SchedulerDeps = {
  store: SchedulerStore;
  execute: ScheduleExecutor;
  now?: () => Date;
  intervalMs?: number;
};

/**
 * Periodically fires due schedules. The interval is injected so tests can tick
 * manually; in production it runs every 30s. `next_run_at` is materialized on
 * the row, so a tick is a cheap `WHERE next_run_at <= now` scan.
 */
export function createSchedulerService(deps: SchedulerDeps) {
  const now = deps.now ?? (() => new Date());
  const intervalMs = deps.intervalMs ?? TICK_MS;
  let timer: NodeJS.Timeout | null = null;
  let ticking = false;

  const advance = (schedule: Schedule, from: Date): string | null =>
    nextCronTime(schedule.cron, from)?.toISOString() ?? null;

  const fire = async (schedule: Schedule) => {
    const firedAt = now();
    try {
      const { sessionId } = await deps.execute(schedule);
      deps.store.recordRun({
        id: randomUUID(),
        scheduleId: schedule.id,
        sessionId,
        status: 'fired',
      });
      deps.store.update(schedule.id, {
        failCount: 0,
        lastRunAt: firedAt.toISOString(),
        nextRunAt: advance(schedule, firedAt),
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      const failCount = schedule.failCount + 1;
      deps.store.recordRun({
        id: randomUUID(),
        scheduleId: schedule.id,
        status: 'failed',
        error: message,
      });
      deps.store.update(schedule.id, {
        // Auto-disable after repeated failures so a broken schedule does not
        // spam failing runs forever.
        enabled: failCount < MAX_CONSECUTIVE_FAILURES,
        failCount,
        lastRunAt: firedAt.toISOString(),
        nextRunAt: advance(schedule, firedAt),
      });
      console.error('[Scheduler] Run failed', { scheduleId: schedule.id, failCount, error: message });
    }
  };

  const tick = async () => {
    if (ticking) return; // overlapping ticks would double-fire
    ticking = true;
    try {
      const current = now();
      for (const schedule of deps.store.listDue(current.toISOString())) {
        const dueAt = schedule.nextRunAt ? new Date(schedule.nextRunAt) : null;
        const lateBy = dueAt ? current.getTime() - dueAt.getTime() : 0;
        if (lateBy > MISSED_RUN_THRESHOLD_MS && !schedule.catchUp) {
          // Missed run (server asleep/down): record the skip and move on.
          deps.store.recordRun({
            id: randomUUID(),
            scheduleId: schedule.id,
            status: 'skipped',
            error: `missed by ${Math.round(lateBy / 60_000)}m`,
          });
          deps.store.update(schedule.id, {
            lastRunAt: current.toISOString(),
            nextRunAt: advance(schedule, current),
          });
          continue;
        }
        await fire(schedule);
      }
    } finally {
      ticking = false;
    }
  };

  return {
    start() {
      if (timer) return;
      timer = setInterval(() => {
        void tick();
      }, intervalMs);
      timer.unref?.();
    },
    stop() {
      if (timer) clearInterval(timer);
      timer = null;
    },
    /** Exported for tests and for run-now reuse of the missed-run logic. */
    tick,
    fire,
    /** Recomputes `next_run_at` for one schedule — used by run-now and PATCH. */
    advance,
  };
}

export type SchedulerService = ReturnType<typeof createSchedulerService>;

/** Validates a cron string for the create/update routes. */
export function isValidCronExpression(expr: string): boolean {
  return parseCron(expr) !== null;
}

export { nextCronTime } from './cron.js';
