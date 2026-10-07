import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  initializeDatabase,
  orchestratorMessagesDb,
} from '@/modules/database/index.js';
import {
  createMiniOrchestratorConfigService,
} from '@/modules/mini-orchestrator/services/mini-orchestrator-config.service.js';
import { createMiniOrchestratorExecutor } from '@/modules/mini-orchestrator/services/mini-orchestrator.service.js';
import type { MiniOrchestratorConfig, OrchestratorPlanStep } from '@/shared/types.js';
import type { OrchestratorDelegationService } from '@/modules/orchestrator/index.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'mini-orchestrator-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(tempDirectory, 'auth.db');
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

type Call = { command: string; hidden: boolean; provider: string; model: string };

function makeConfig(): MiniOrchestratorConfig {
  return createMiniOrchestratorConfigService({ get: () => null, set: () => undefined }).get();
}

/** Fake delegation: hidden calls are the planner lane and return `planReply`. */
function makeDelegation(calls: Call[], planReply = ''): OrchestratorDelegationService {
  return {
    async run(input: { command: string; hidden?: boolean; provider: string; model: string }) {
      calls.push({
        command: input.command,
        hidden: Boolean(input.hidden),
        provider: input.provider,
        model: input.model,
      });
      return {
        childSessionId: `child-${calls.length}`,
        completed: Promise.resolve({
          ok: true,
          error: null,
          finalText: input.hidden ? planReply : 'step output',
          aborted: false,
        }),
        abort: async () => undefined,
      };
    },
  } as unknown as OrchestratorDelegationService;
}

test('mini: planner off runs a single step on the task role', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    const calls: Call[] = [];
    const executor = createMiniOrchestratorExecutor({
      getConfig: () => config,
      delegation: makeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run({ sessionId: 's1', content: 'implement a cache', options: { cwd: '/repo' } });
    assert.ok(result.ok);
    assert.equal(calls.length, 1);
    // 'implement' classifies as `code` → worker (flash) model.
    assert.equal(calls[0].model, 'glm-5-3-flash-high');
    assert.equal(calls[0].hidden, false);

    const rows = orchestratorMessagesDb.list('s1');
    assert.equal(rows.find((r) => r.kind === 'user')?.payload.content, 'implement a cache');
    assert.equal(rows.find((r) => r.kind === 'plan')?.payload.source, 'off');
    assert.equal(rows.filter((r) => r.kind === 'delegation').length, 1);
    assert.equal(rows.at(-1)?.kind, 'summary');
    assert.equal(rows.at(-1)?.payload.completed, 1);
  });
});

test('mini: auto planner uses thinker, then routes each step by role', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'auto';
    const planReply = JSON.stringify([
      { type: 'code', title: 'impl', prompt: 'write the code', dependsOn: [] },
      { type: 'review', title: 'rev', prompt: 'review it', dependsOn: ['step-1'] },
    ]);
    const calls: Call[] = [];
    const executor = createMiniOrchestratorExecutor({
      getConfig: () => config,
      delegation: makeDelegation(calls, planReply),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run({ sessionId: 's2', content: 'implement feature', options: { cwd: '/repo' } });
    assert.ok(result.ok);
    assert.equal(calls.length, 3);
    // 0: planner (hidden) on the thinker; 1: code on the worker; 2: review on the thinker.
    assert.equal(calls[0].hidden, true);
    assert.equal(calls[0].model, 'glm-5-3-high');
    assert.equal(calls[1].model, 'glm-5-3-flash-high');
    assert.equal(calls[2].model, 'glm-5-3-high');

    const rows = orchestratorMessagesDb.list('s2');
    const plan = rows.find((r) => r.kind === 'plan');
    assert.equal(plan?.payload.source, 'thinker');
    const steps = plan?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 2);
    assert.deepEqual(steps[1].dependsOn, ['step-1']);
    // Second step received the first step's output as context.
    assert.match(calls[2].command, /step output/);
  });
});

test('mini: per-task role remap sends code to the thinker', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.roles.code = 'thinker';
    const calls: Call[] = [];
    const executor = createMiniOrchestratorExecutor({
      getConfig: () => config,
      delegation: makeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    await executor.run({ sessionId: 's3', content: 'implement a cache', options: { cwd: '/repo' } });
    assert.equal(calls.length, 1);
    assert.equal(calls[0].model, 'glm-5-3-high');
  });
});

test('mini: requireConfirm parks the plan, confirm runs edited steps', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.planner.requireConfirm = true;
    const calls: Call[] = [];
    const executor = createMiniOrchestratorExecutor({
      getConfig: () => config,
      delegation: makeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    const parked = await executor.run({ sessionId: 's4', content: 'implement x', options: { cwd: '/repo' } });
    assert.ok(parked.ok);
    assert.equal(calls.length, 0);
    const parkedPlan = orchestratorMessagesDb.list('s4').find((r) => r.kind === 'plan');
    assert.equal(parkedPlan?.payload.awaitingConfirm, true);

    const edited: OrchestratorPlanStep[] = [
      { id: 'step-1', type: 'code', title: 'impl', prompt: 'do it', dependsOn: [], enabled: true },
    ];
    const result = await executor.confirm('s4', edited, {});
    assert.ok(result.ok);
    assert.equal(calls.length, 1);
    const patched = orchestratorMessagesDb.list('s4').find((r) => r.kind === 'plan');
    assert.equal(patched?.payload.awaitingConfirm, false);
  });
});

test('mini: resume re-runs the last plan', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    const calls: Call[] = [];
    const executor = createMiniOrchestratorExecutor({
      getConfig: () => config,
      delegation: makeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    await executor.run({ sessionId: 's5', content: 'implement x', options: { cwd: '/repo' } });
    assert.equal(calls.length, 1);
    const result = await executor.resume('s5', {});
    assert.ok(result.ok);
    assert.equal(calls.length, 2);

    const nothing = await executor.resume('s-empty', {});
    assert.equal(nothing.ok, false);
    assert.equal(nothing.ok ? '' : nothing.code, 'NOTHING_TO_RESUME');
  });
});
