import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  initializeDatabase,
  projectsDb,
  schedulesDb,
} from '@/modules/database/index.js';
import { matchesCron, nextCronTime, parseCron } from '@/modules/scheduler/cron.js';
import { createSchedulerService } from '@/modules/scheduler/scheduler.service.js';
import { executeSchedule } from '@/modules/scheduler/scheduler-executor.service.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'scheduler-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

test('cron parser accepts the standard field shapes and rejects junk', () => {
  assert.ok(parseCron('*/5 * * * *'));
  assert.ok(parseCron('0 9 * * 1-5'));
  assert.ok(parseCron('30 14 1,15 * *'));
  assert.ok(parseCron('0 0 29 2 *'));

  assert.equal(parseCron(''), null);
  assert.equal(parseCron('* * * *'), null);
  assert.equal(parseCron('61 * * * *'), null);
  assert.equal(parseCron('a b c d e'), null);
  assert.equal(parseCron('*/0 * * * *'), null);
});

test('matchesCron honours the dom/dow OR rule', () => {
  const both = parseCron('0 9 15 * 1');
  assert.ok(both);
  // Monday the 10th: dom misses (15), dow hits (Mon) → OR fires.
  assert.ok(matchesCron(both, new Date(2025, 2, 10, 9, 0)));
  // Neither dom=15 nor Monday → no match.
  assert.equal(matchesCron(both, new Date(2025, 2, 11, 9, 0)), false);
});

test('nextCronTime finds the next minute boundary', () => {
  const from = new Date(2025, 2, 10, 8, 59, 30); // Mon 08:59:30
  const next = nextCronTime('0 9 * * *', from);
  assert.equal(next?.getHours(), 9);
  assert.equal(next?.getMinutes(), 0);
  // Skips to next day when today's slot already passed.
  const later = nextCronTime('0 8 * * *', from);
  assert.equal(later?.getDate(), 11);
});

test('tick fires a due schedule, advances next_run_at and records the run', async () => {
  await withIsolatedDatabase(async () => {
    const fired: string[] = [];
    const service = createSchedulerService({
      store: schedulesDb,
      execute: async (schedule) => {
        fired.push(schedule.id);
        return { sessionId: 'sess-1' };
      },
      now: () => new Date('2025-03-10T09:00:30Z'),
    });

    const schedule = schedulesDb.create({
      id: 's1',
      projectId: 'p1',
      provider: 'claude',
      cron: '0 9 * * *',
      prompt: 'run tests',
      nextRunAt: '2025-03-10T09:00:00.000Z',
    });

    await service.tick();
    assert.deepEqual(fired, ['s1']);

    const updated = schedulesDb.get(schedule.id);
    assert.equal(updated?.failCount, 0);
    assert.ok(updated?.nextRunAt && updated.nextRunAt > '2025-03-10T09:00');

    const runs = schedulesDb.listRuns(schedule.id);
    assert.equal(runs.length, 1);
    assert.equal(runs[0].status, 'fired');
    assert.equal(runs[0].sessionId, 'sess-1');
  });
});

test('a run missed by more than five minutes is skipped unless catch-up is set', async () => {
  await withIsolatedDatabase(async () => {
    const fired: string[] = [];
    const service = createSchedulerService({
      store: schedulesDb,
      execute: async (schedule) => {
        fired.push(schedule.id);
        return { sessionId: 'sess-x' };
      },
      now: () => new Date('2025-03-10T09:10:00Z'), // 10 min late
    });

    const skipped = schedulesDb.create({
      id: 's-skip',
      projectId: 'p1',
      provider: 'claude',
      cron: '0 9 * * *',
      prompt: 'x',
      nextRunAt: '2025-03-10T09:00:00.000Z',
    });
    const catchUp = schedulesDb.create({
      id: 's-catch',
      projectId: 'p1',
      provider: 'claude',
      cron: '0 9 * * *',
      prompt: 'x',
      catchUp: true,
      nextRunAt: '2025-03-10T09:00:00.000Z',
    });

    await service.tick();
    assert.deepEqual(fired, ['s-catch']);

    const skipRuns = schedulesDb.listRuns(skipped.id);
    assert.equal(skipRuns[0].status, 'skipped');
    const catchRuns = schedulesDb.listRuns(catchUp.id);
    assert.equal(catchRuns[0].status, 'fired');
  });
});

test('executor failures increment fail_count and disable after five', async () => {
  await withIsolatedDatabase(async () => {
    const service = createSchedulerService({
      store: schedulesDb,
      execute: async () => {
        throw new Error('boom');
      },
      now: () => new Date('2025-03-10T09:00:30Z'),
    });

    const schedule = schedulesDb.create({
      id: 's-fail',
      projectId: 'p1',
      provider: 'claude',
      cron: '* * * * *',
      prompt: 'x',
      nextRunAt: '2025-03-10T09:00:00.000Z',
    });

    for (let i = 0; i < 5; i += 1) {
      // Rewind next_run_at so the row stays due on every tick.
      schedulesDb.update(schedule.id, { nextRunAt: '2025-03-10T09:00:00.000Z' });
      await service.tick();
    }

    const updated = schedulesDb.get(schedule.id);
    assert.equal(updated?.failCount, 5);
    assert.equal(updated?.enabled, false);

    const runs = schedulesDb.listRuns(schedule.id);
    assert.equal(runs.length, 5);
    assert.equal(runs[0].status, 'failed');
    assert.match(runs[0].error ?? '', /boom/);
  });
});

test('run-now path fires regardless of the timetable', async () => {
  await withIsolatedDatabase(async () => {
    const fired: string[] = [];
    const service = createSchedulerService({
      store: schedulesDb,
      execute: async (schedule) => {
        fired.push(schedule.id);
        return { sessionId: 'sess-now' };
      },
    });

    const schedule = schedulesDb.create({
      id: 's-now',
      projectId: 'p1',
      provider: 'codex',
      cron: '0 0 29 2 *', // effectively never
      prompt: 'x',
      nextRunAt: null,
      enabled: false,
    });

    await service.fire(schedule);
    assert.deepEqual(fired, ['s-now']);
  });
});

test('executeSchedule resolves the project, creates the session and starts the run', async () => {
  await withIsolatedDatabase(async () => {
    projectsDb.ensureProjectPath('/tmp/sched-project');

    const projectId = projectsDb.getProjectPath('/tmp/sched-project')?.project_id ?? '';
    const calls: string[] = [];
    const result = await executeSchedule(
      {
        id: 's1',
        projectId,
        provider: 'claude',
        cron: '0 9 * * *',
        prompt: 'do the thing',
        useWorktree: false,
        catchUp: false,
        enabled: true,
        failCount: 0,
        lastRunAt: null,
        nextRunAt: null,
        createdAt: '',
      },
      {
        createAppSession: (provider, projectPath, prompt) => {
          calls.push(`session:${provider}:${projectPath}:${prompt}`);
          return { sessionId: 'sess-42' };
        },
        startRun: async ({ sessionId, provider, cwd, prompt }) => {
          calls.push(`run:${sessionId}:${provider}:${cwd}:${prompt}`);
        },
        createWorktree: async () => {
          throw new Error('should not create a worktree');
        },
      },
    );

    assert.equal(result.sessionId, 'sess-42');
    assert.equal(calls.length, 2);
    assert.match(calls[0], /session:claude:\/tmp\/sched-project:do the thing/);
    assert.match(calls[1], /run:sess-42:claude/);
  });
});

test('executeSchedule carves out a worktree when the schedule asks for one', async () => {
  await withIsolatedDatabase(async () => {
    projectsDb.ensureProjectPath('/tmp/sched-wt');
    const projectId = projectsDb.getProjectPath('/tmp/sched-wt')?.project_id ?? '';

    const calls: string[] = [];
    await executeSchedule(
      {
        id: 's1', projectId, provider: 'claude', cron: '0 9 * * *',
        prompt: 'x', useWorktree: true, catchUp: false, enabled: true,
        failCount: 0, lastRunAt: null, nextRunAt: null, createdAt: '',
      },
      {
        createAppSession: () => ({ sessionId: 'sess-wt' }),
        startRun: async ({ cwd }) => {
          calls.push(`run-cwd:${cwd}`);
        },
        createWorktree: async ({ projectPath, branch }) => {
          calls.push(`wt:${projectPath}:${branch}`);
          return { worktreePath: '/tmp/sched-wt-worktrees/sched-s1' };
        },
      },
    );

    assert.match(calls[0], /wt:\/tmp\/sched-wt:sched-s1-/);
    assert.match(calls[1], /run-cwd:\/tmp\/sched-wt-worktrees\/sched-s1/);
  });
});
