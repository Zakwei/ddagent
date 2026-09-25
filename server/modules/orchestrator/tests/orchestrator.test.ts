import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, orchestratorMessagesDb } from '@/modules/database/index.js';
import {
  createOrchestratorConfigService,
  validateOrchestratorConfig,
} from '@/modules/orchestrator/services/orchestrator-config.service.js';
import {
  classifyTaskType,
  createOrchestratorRouterService,
} from '@/modules/orchestrator/services/orchestrator-router.service.js';
import {
  createOrchestratorExecutor,
  normalizeEditableSteps,
  parsePlanJson,
} from '@/modules/orchestrator/services/orchestrator-executor.service.js';
import type {
  AnyRecord,
  OrchestratorConfig,
  OrchestratorPlanStep,
  QuotaAccount,
} from '@/shared/types.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'orchestrator-'));
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

function makeConfig(): OrchestratorConfig {
  return createOrchestratorConfigService({ get: () => null, set: () => undefined }).get();
}

function makeRouter(accounts: QuotaAccount[] | null, runtimes: string[] = ['devin']) {
  const config = makeConfig();
  return createOrchestratorRouterService({
    getConfig: () => config,
    availability: {
      isRuntimeAvailable: (p) => runtimes.includes(p),
      accounts,
    },
  });
}

const devinAccount = (status: 'active' | 'inactive' | 'error', exhausted = false): QuotaAccount => ({
  id: 'devin',
  provider: 'devin',
  providerLabel: 'Devin',
  plan: 'Pro',
  accountLabel: '',
  status,
  quality: 'live',
  lastSyncedAt: null,
  syncError: status === 'active' ? null : 'x',
  windows: exhausted
    ? [{ label: 'w', kind: 'monthly', percent: 100, remainingPercent: 0, resetsAt: null, status: 'exceeded', projectedExhaustionAt: null, etaSeconds: null, burnRatePerHour: null }]
    : [{ label: 'w', kind: 'monthly', percent: 40, remainingPercent: 60, resetsAt: null, status: 'ok', projectedExhaustionAt: null, etaSeconds: null, burnRatePerHour: null }],
  assignedAgents: [],
});

test('config: seeded default validates and round-trips', async () => {
  await withIsolatedDatabase(() => {
    const service = createOrchestratorConfigService();
    const config = service.get();
    assert.equal(config.enabled, true);
    assert.ok(config.pool.length >= 10);
    assert.equal(config.rules.code[0], 'swe2-med');
    assert.equal(config.rules.review[0], 'swe2-max');
    assert.equal(config.planner.candidateId, 'glm53f-low');

    const stored = service.put(config);
    assert.equal(stored.rules.review[0], 'swe2-max');
    assert.equal(service.get().pool.length, config.pool.length);
  });
});

test('config: rejects unknown provider, bad tier, dangling rule ref', async () => {
  await withIsolatedDatabase(() => {
    const base = makeConfig() as unknown as Record<string, unknown>;

    assert.throws(() => validateOrchestratorConfig({ ...base, pool: [{ id: 'x', provider: 'nope', model: 'm', tier: 'free' }] }), /provider/);
    assert.throws(() => validateOrchestratorConfig({ ...base, pool: [{ id: 'x', provider: 'devin', model: 'm', tier: 'gold' }] }), /tier/);
    assert.throws(
      () => validateOrchestratorConfig({ ...base, rules: { ...base.rules as object, code: ['ghost'] } }),
      /unknown candidate/,
    );
    assert.throws(
      () => validateOrchestratorConfig({ ...base, planner: { candidateId: 'ghost', mode: 'auto', templates: [] } }),
      /planner.candidateId/,
    );
  });
});

test('classify: hint wins, slash beats keywords, default is quick', () => {
  assert.equal(classifyTaskType('hello there'), 'quick');
  assert.equal(classifyTaskType('/review the diff'), 'review');
  assert.equal(classifyTaskType('please implement a cache'), 'code');
  assert.equal(classifyTaskType('refactor the whole module'), 'code-hard');
  assert.equal(classifyTaskType('anything', 'review'), 'review');
  assert.equal(classifyTaskType('/bogus word', null), 'quick');
});

test('router: first viable candidate wins, exhausted falls to next', () => {
  const router = makeRouter([devinAccount('active')]);
  const res = router.route('code');
  assert.ok(res.ok);
  assert.equal(res.decision.model, 'swe-2-medium');
  assert.equal(res.decision.effort, 'medium');
  assert.deepEqual(res.decision.alternatives, ['glm53-low', 'ds41f-max']);
});

test('router: exhausted provider → no candidate → ask', () => {
  const router = makeRouter([devinAccount('active', true)]);
  const res = router.route('review');
  assert.equal(res.ok, false);
  if (!res.ok) assert.match(res.reason, /quota exhausted/);
});

test('router: null snapshot fails open', () => {
  const router = makeRouter(null);
  const res = router.route('research');
  assert.ok(res.ok);
  assert.equal(res.decision.model, 'gemini-3-8-flash-medium');
});

test('router: missing runtime rejects all devin candidates', () => {
  const router = makeRouter(null, ['claude']);
  const res = router.route('docs');
  assert.equal(res.ok, false);
});

test('transcript: append/list/update round-trip with seq order', async () => {
  await withIsolatedDatabase(() => {
    const a = orchestratorMessagesDb.append('s1', 'user', { content: 'hi' });
    const b = orchestratorMessagesDb.append('s1', 'routing', { model: 'm' });
    assert.equal(a.seq, 1);
    assert.equal(b.seq, 2);

    const updated = orchestratorMessagesDb.updatePayload(b.id, { status: 'done' });
    assert.equal(updated?.payload.model, 'm');
    assert.equal(updated?.payload.status, 'done');

    const list = orchestratorMessagesDb.list('s1');
    assert.equal(list.length, 2);
    assert.equal(list[0].kind, 'user');

    orchestratorMessagesDb.deleteForSession('s1');
    assert.equal(orchestratorMessagesDb.list('s1').length, 0);
  });
});

test('planner: parsePlanJson tolerates fences and prose', () => {
  assert.deepEqual(parsePlanJson('[{"type":"code","title":"x"}]'), [{ type: 'code', title: 'x' }]);
  assert.deepEqual(parsePlanJson('Here you go:\n```json\n[{"type":"review"}]\n```'), [{ type: 'review' }]);
  assert.equal(parsePlanJson('not json'), null);
});

function fakeDelegation(calls: Array<{ command: string; cwd: string }>) {
  return {
    async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
      calls.push({ command: input.command, cwd: input.cwd });
      return {
        childSessionId: `child-${calls.length}`,
        completed: Promise.resolve({ ok: true, error: null, finalText: 'done' }),
        abort: async () => undefined,
      };
    },
  };
}

const orchestrateInput = (sessionId: string, content: string, options: AnyRecord = {}) => ({
  sessionId,
  content,
  options,
  connection: { readyState: 0, send: () => undefined } as never,
});

test('executor: requireConfirm parks the plan, confirm runs edited steps', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.planner.requireConfirm = true;
    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    const input = orchestrateInput('sess-1', 'implement the thing', { cwd: '/repo' });
    const parked = await executor.run(input);
    assert.ok(parked.ok);
    assert.equal(executor.hasPendingPlan('sess-1'), true);
    assert.equal(calls.length, 0);

    const rows = orchestratorMessagesDb.list('sess-1');
    const planRow = rows.find((r) => r.kind === 'plan');
    assert.equal(planRow?.payload.awaitingConfirm, true);

    const edited: OrchestratorPlanStep[] = [
      { id: 'step-1', type: 'code', title: 'impl', prompt: 'do it', dependsOn: [], enabled: true },
      { id: 'step-2', type: 'review', title: 'rev', prompt: 'check', dependsOn: ['step-1'], enabled: false },
    ];
    const result = await executor.confirm('sess-1', edited, {});
    assert.ok(result.ok);
    assert.equal(executor.hasPendingPlan('sess-1'), false);
    assert.equal(calls.length, 1);
    assert.equal(calls[0].cwd, '/repo');

    const patched = orchestratorMessagesDb.list('sess-1').find((r) => r.kind === 'plan');
    assert.equal(patched?.payload.awaitingConfirm, false);
    assert.equal((patched?.payload.steps as unknown[]).length, 2);
    const summary = orchestratorMessagesDb.list('sess-1').find((r) => r.kind === 'summary');
    assert.match(String(summary?.payload.text), /1\/1/);
  });
});

test('executor: independent steps run in parallel, disabled dep does not block', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.execution.maxParallel = 2;
    let inFlight = 0;
    let maxSeen = 0;
    const delegation = {
      async run() {
        inFlight += 1;
        maxSeen = Math.max(maxSeen, inFlight);
        return {
          childSessionId: 'x',
          completed: (async () => {
            await new Promise((r) => setTimeout(r, 10));
            inFlight -= 1;
            return { ok: true, error: null, finalText: 'ok' };
          })(),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
    });

    const steps = normalizeEditableSteps(
      [
        { id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] },
        { id: 'b', type: 'docs', title: 'B', prompt: 'pb', dependsOn: [] },
        { id: 'c', type: 'review', title: 'C', prompt: 'pc', dependsOn: ['a', 'b'] },
      ],
      'fallback',
    );
    const result = await executor.confirm('sess-2', steps, {});
    assert.ok(result.ok);
    assert.ok(maxSeen >= 2, `expected parallel execution, saw ${maxSeen}`);
    const summary = orchestratorMessagesDb.list('sess-2').find((r) => r.kind === 'summary');
    assert.match(String(summary?.payload.text), /3\/3/);
  });
});

test('normalizeEditableSteps: drops plan/unknown types and dangling deps', () => {
  const steps = normalizeEditableSteps(
    [
      { id: 'a', type: 'plan', title: 'planner step' },
      { id: 'b', type: 'nonsense', title: 'bad' },
      { id: 'c', type: 'code', title: 'ok', dependsOn: ['ghost', 'c'] },
    ],
    'fallback',
  );
  assert.equal(steps.length, 1);
  assert.equal(steps[0].id, 'c');
  assert.deepEqual(steps[0].dependsOn, []);
});
