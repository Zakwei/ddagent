import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, orchestratorMessagesDb, sessionsDb } from '@/modules/database/index.js';
import {
  createOrchestratorConfigService,
  validateOrchestratorConfig,
} from '@/modules/orchestrator/services/orchestrator-config.service.js';
import {
  classifyTaskType,
  createOrchestratorRouterService,
} from '@/modules/orchestrator/services/orchestrator-router.service.js';
import {
  buildPlannerPrompt,
  classifyStepError,
  createOrchestratorExecutor,
  extractPriorSessionContext,
  hasIssuesVerdict,
  normalizeEditableSteps,
  parsePlanJson,
  resolveLanguageName,
} from '@/modules/orchestrator/services/orchestrator-executor.service.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import type {
  AnyRecord,
  OrchestratorConfig,
  OrchestratorPlanStep,
  QuotaAccount,
} from '@/shared/index.js';

/** Minimal websocket stand-in collecting JSON frames for assertions. */
class FakeConnection {
  readyState = 1; // WS_OPEN_STATE
  frames: Array<Record<string, unknown>> = [];

  send(data: string): void {
    this.frames.push(JSON.parse(data) as Record<string, unknown>);
  }
}

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

function makeRouter(
  accounts: QuotaAccount[] | null,
  runtimes: string[] = ['devin'],
  config: OrchestratorConfig = makeConfig(),
) {
  return createOrchestratorRouterService({
    getConfig: () => config,
    availability: {
      isRuntimeAvailable: (p) => runtimes.includes(p),
      accounts,
    },
  });
}

const quotaAccount = (
  provider: string,
  status: 'active' | 'inactive' | 'error',
  exhausted = false,
): QuotaAccount => ({
  id: provider,
  accountId: null,
  provider,
  providerLabel: provider,
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

const devinAccount = (status: 'active' | 'inactive' | 'error', exhausted = false): QuotaAccount =>
  quotaAccount('devin', status, exhausted);

test('config: seeded default validates and round-trips', async () => {
  await withIsolatedDatabase(() => {
    const service = createOrchestratorConfigService();
    const config = service.get();
    assert.equal(config.enabled, true);
    assert.ok(config.pool.length >= 10);
    // Free devin lanes lead the workhorse rules; codex fronts plan/review.
    assert.equal(config.rules.code[0], 'swe2-med');
    assert.equal(config.rules.review[0], 'cx-astra');
    assert.equal(config.planner.candidateId, 'g38f-high');

    const stored = service.put(config);
    assert.equal(stored.rules.review[0], 'cx-astra');
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
  assert.deepEqual(res.decision.alternatives, ['glm53-low', 'ds41f-max', 'swe2-high']);
});

test('router: exhausted subscription rejects paid lanes but free still routes', () => {
  const router = makeRouter([devinAccount('active', true)]);
  const res = router.route('review');
  // swe2-max is tier 'free' — SWE lanes draw no quota, so an exhausted
  // devin subscription must not take them down (rate limits only).
  assert.ok(res.ok);
  assert.equal(res.candidate.id, 'swe2-max');

  // A rule of only paid candidates on the exhausted provider fails closed.
  const config = makeConfig();
  config.rules.review = ['glm53-max', 'g35f-high'];
  const starved = makeRouter([devinAccount('active', true)], ['devin'], config).route('review');
  assert.equal(starved.ok, false);
  if (!starved.ok) assert.match(starved.reason, /quota exhausted/);
});

test('router: opencode candidates are billed to their own subscription section', () => {
  const config = makeConfig();
  // Candidates for plugin-provided models are gone from the seed, but users
  // can re-add them via settings — the billing logic still has to split them.
  config.pool.push(
    { id: 'oc-gem38f', provider: 'opencode', model: 'google/antigravity-gemini-3.8-flash', effort: null, accountId: null, tier: 'mid', label: 'x' },
    { id: 'oc-cc-ds41f', provider: 'opencode', model: 'commandcode/deepseek/deepseek-v4.1-flash', effort: null, accountId: null, tier: 'mid', label: 'x' },
  );
  config.rules.research = ['oc-gem38f', 'oc-cc-ds41f', 'oc-nv-glm53f'];
  // The label must name a real Antigravity pool — unmatched labels fail open.
  const geminiExhausted: QuotaAccount = {
    ...quotaAccount('gemini', 'active', true),
    windows: quotaAccount('gemini', 'active', true).windows.map((w) => ({
      ...w,
      label: 'Gemini Models · 5h',
    })),
  };
  const router = makeRouter(
    [geminiExhausted, quotaAccount('commandcode', 'active')],
    ['opencode'],
    config,
  );
  const res = router.route('research');
  assert.ok(res.ok);
  // gemini sub exhausted → oc-gem38f skipped; commandcode has headroom.
  assert.equal(res.candidate.id, 'oc-cc-ds41f');

  // Both subscription sections exhausted → only the BYOK/free lanes remain.
  const config2 = makeConfig();
  config2.rules.research = ['oc-gem38f', 'oc-cc-ds41f', 'oc-nv-glm53f'];
  const res2 = makeRouter(
    [geminiExhausted, quotaAccount('commandcode', 'active', true)],
    ['opencode'],
    config2,
  ).route('research');
  assert.ok(res2.ok);
  assert.equal(res2.candidate.id, 'oc-nv-glm53f');
});

test('router: antigravity Claude/GPT check the 3p bucket, not the Gemini one', () => {
  // Gemini Models pool is spent but the 'Claude and GPT models' pool still
  // has headroom — the two Antigravity buckets exhaust independently.
  const geminiMixed: QuotaAccount = {
    ...quotaAccount('gemini', 'active'),
    windows: [
      { label: 'Gemini Models · 5h', kind: 'session', percent: 100, remainingPercent: 0, resetsAt: null, status: 'exceeded', projectedExhaustionAt: null, etaSeconds: null, burnRatePerHour: null },
      { label: 'Gemini Models · weekly', kind: 'weekly', percent: 100, remainingPercent: 0, resetsAt: null, status: 'exceeded', projectedExhaustionAt: null, etaSeconds: null, burnRatePerHour: null },
      { label: 'Claude and GPT models · 5h', kind: 'session', percent: 10, remainingPercent: 90, resetsAt: null, status: 'ok', projectedExhaustionAt: null, etaSeconds: null, burnRatePerHour: null },
      { label: 'Claude and GPT models · weekly', kind: 'weekly', percent: 20, remainingPercent: 80, resetsAt: null, status: 'ok', projectedExhaustionAt: null, etaSeconds: null, burnRatePerHour: null },
    ],
  };
  const config = makeConfig();
  config.pool.push(
    { id: 'oc-gem38f', provider: 'opencode', model: 'google/antigravity-gemini-3.8-flash', effort: null, accountId: null, tier: 'mid', label: 'x' },
    { id: 'oc-agy-opus', provider: 'opencode', model: 'google/antigravity-claude-opus-4-6-thinking', effort: null, accountId: null, tier: 'premium', label: 'x' },
    { id: 'oc-cc-ds41f', provider: 'opencode', model: 'commandcode/deepseek/deepseek-v4.1-flash', effort: null, accountId: null, tier: 'mid', label: 'x' },
  );
  config.rules.review = ['oc-gem38f', 'oc-agy-opus', 'oc-cc-ds41f'];
  const res = makeRouter([geminiMixed, quotaAccount('commandcode', 'active')], ['opencode'], config).route('review');
  assert.ok(res.ok);
  assert.equal(res.candidate.id, 'oc-agy-opus');

  // Flip: the 3p pool spent while Gemini Models has headroom.
  const flipped: QuotaAccount = {
    ...geminiMixed,
    windows: geminiMixed.windows.map((w) => ({
      ...w,
      percent: w.label.startsWith('Claude') ? 100 : 10,
      remainingPercent: w.label.startsWith('Claude') ? 0 : 90,
      status: w.label.startsWith('Claude') ? 'exceeded' : 'ok',
    })),
  };
  const res2 = makeRouter([flipped, quotaAccount('commandcode', 'active')], ['opencode'], config).route('review');
  assert.ok(res2.ok);
  assert.equal(res2.candidate.id, 'oc-gem38f');
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
        completed: Promise.resolve({ ok: true, error: null, finalText: 'done', aborted: false }),
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
            return { ok: true, error: null, finalText: 'ok', aborted: false };
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

test('executor: failed step fails over through every routed alternative, then ends failed', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    let calls = 0;
    const lanes: string[] = [];
    const delegation = {
      async run(input: { provider: string; model: string | null }) {
        calls += 1;
        lanes.push(`${input.provider}/${input.model}`);
        return {
          childSessionId: `child-${calls}`,
          completed: Promise.resolve({ ok: false, error: 'boom', finalText: '', aborted: false }),
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
        { id: 'b', type: 'docs', title: 'B', prompt: 'pb', dependsOn: ['a'] },
      ],
      'fallback',
    );
    const result = await executor.confirm('sess-4', steps, {});

    // Every viable 'code' alternative gets one attempt before the step dies
    // — the devin-only runtime leaves four lanes (opencode candidates are
    // filtered out as unavailable).
    assert.equal(calls, 4);
    assert.deepEqual(lanes, [
      'devin/swe-2-medium',
      'devin/glm-5-3-low',
      'devin/deepseek-v4-1-flash-max',
      'devin/swe-2-high',
    ]);
    assert.equal(result.ok, false);

    const rows = orchestratorMessagesDb.list('sess-4');
    const aRow = rows.find((r) => r.kind === 'delegation' && r.payload.stepId === 'a');
    assert.equal(aRow?.payload.status, 'failed');
    assert.equal(aRow?.payload.attempt, 4);
    // The dependent step was skipped, not parked — the run is terminal.
    const bRow = rows.find((r) => r.kind === 'delegation' && r.payload.stepId === 'b');
    assert.equal(bRow?.payload.status, 'skipped');

    const summary = rows.find((r) => r.kind === 'summary');
    assert.ok(summary, 'a terminal summary must exist for the Continue button');
    assert.deepEqual(summary?.payload.failed, ['a', 'b']);
    assert.match(String(summary?.payload.text), /0\/2 steps completed/);
  });
});

test('executor: a rate-limited free lane retries on the same model', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const lanes: string[] = [];
    let calls = 0;
    const delegation = {
      async run(input: { provider: string; model: string | null }) {
        calls += 1;
        lanes.push(`${input.provider}/${input.model}`);
        return {
          childSessionId: `child-${calls}`,
          completed: Promise.resolve({
            ok: calls >= 2,
            error: calls >= 2 ? null : 'HTTP 429: rate limit exceeded, retry later',
            finalText: calls >= 2 ? 'done' : '',
            aborted: false,
          }),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
      sleep: async () => undefined,
    });

    const steps = normalizeEditableSteps(
      [{ id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] }],
      'fallback',
    );
    const result = await executor.confirm('sess-rl', steps, {});
    assert.ok(result.ok);
    // Attempt 1 hit the SWE-2 rate limit → attempt 2 stayed on swe-2-medium
    // instead of failing over to the paid glm53-low fallback.
    assert.equal(calls, 2);
    assert.deepEqual(lanes, ['devin/swe-2-medium', 'devin/swe-2-medium']);
  });
});

test('executor: a persistent rate limit burns the rate_limit budget, cools the lane, then fails over', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const lanes: string[] = [];
    let calls = 0;
    const delegation = {
      async run(input: { provider: string; model: string | null }) {
        calls += 1;
        lanes.push(`${input.provider}/${input.model}`);
        const limited = input.model === 'swe-2-medium';
        return {
          childSessionId: `child-${calls}`,
          completed: Promise.resolve({
            ok: !limited,
            error: limited ? 'All 2 account(s) rate-limited for claude. Quota resets in 144h 27m.' : null,
            finalText: limited ? '' : 'done',
            aborted: false,
          }),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
      sleep: async () => undefined,
      random: () => 0,
    });

    const steps = normalizeEditableSteps(
      [{ id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] }],
      'fallback',
    );
    const result = await executor.confirm('sess-rl2', steps, {});
    assert.ok(result.ok);
    // swe-2-medium exhausted the default rate_limit budget (2 same-lane
    // retries) and cooled down → the fourth attempt runs on the next
    // routed alternative.
    assert.equal(calls, 4);
    assert.deepEqual(lanes, [
      'devin/swe-2-medium',
      'devin/swe-2-medium',
      'devin/swe-2-medium',
      'devin/glm-5-3-low',
    ]);
  });
});

test('executor: a user-aborted child drains the remaining queue', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.execution.maxParallel = 1;
    let calls = 0;
    const delegation = {
      async run() {
        calls += 1;
        return {
          childSessionId: `child-${calls}`,
          completed: Promise.resolve({ ok: false, error: 'cancelled', finalText: '', aborted: true }),
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
      ],
      'fallback',
    );
    const result = await executor.confirm('sess-5', steps, {});
    assert.equal(result.ok, false);

    // An aborted child never retries and drains the queue: step-b never ran
    // and carries an 'aborted' transcript row instead.
    assert.equal(calls, 1);
    const rows = orchestratorMessagesDb.list('sess-5');
    const abortedRow = rows.find((r) => r.kind === 'delegation' && r.payload.status === 'aborted');
    assert.equal(abortedRow?.payload.stepId, 'b');
    const summary = rows.find((r) => r.kind === 'summary');
    assert.match(String(summary?.payload.text), /\(aborted\)/);
    assert.equal(summary?.payload.aborted, true);
  });
});

test('findReusableChildSession: skips running siblings, reuses the newest finished child', async () => {
  const { findReusableChildSession } = await import(
    '@/modules/orchestrator/services/orchestrator-delegation.service.js'
  );
  await withIsolatedDatabase(() => {
    // Reuse requires the referenced child session to still exist and be active.
    sessionsDb.createAppSession('child-old', 'devin', '/workspace/demo');
    sessionsDb.createAppSession('child-running', 'devin', '/workspace/demo');
    orchestratorMessagesDb.append('sess-3', 'delegation', {
      stepId: 'step-1',
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'done',
      childSessionId: 'child-old',
    });
    orchestratorMessagesDb.append('sess-3', 'delegation', {
      stepId: 'step-2',
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'running',
      childSessionId: 'child-running',
    });
    // Parallel sibling still running → must not steal its session.
    assert.equal(findReusableChildSession('sess-3', 'devin', 'swe-2-medium'), 'child-old');
    // Once the sibling settles, its session becomes the newest resumable one.
    const running = orchestratorMessagesDb.list('sess-3').find((r) => r.payload.status === 'running');
    orchestratorMessagesDb.updatePayload(running!.id, { status: 'done' });
    assert.equal(findReusableChildSession('sess-3', 'devin', 'swe-2-medium'), 'child-running');
    // Different model never collides.
    assert.equal(findReusableChildSession('sess-3', 'devin', 'glm-5-3-low'), null);
  });
});

test('delegation.abort: flags the child run before the provider abort settles it', async () => {
  const { createOrchestratorDelegationService } = await import(
    '@/modules/orchestrator/services/orchestrator-delegation.service.js'
  );

  await withIsolatedDatabase(async () => {
    let settleDispatch: (() => void) | null = null;
    const runtime = {
      hasRuntime: () => true,
      run: () => new Promise<void>((resolve) => { settleDispatch = resolve; }),
      // The provider abort settles the dispatch promise while the abort
      // handler is still awaiting it — exactly the window where the safety
      // net used to complete the run without the aborted flag.
      abort: async () => {
        settleDispatch?.();
        return true;
      },
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };

    const service = createOrchestratorDelegationService({ runtime: runtime as never });
    const handle = await service.run({
      parentSessionId: 'sess-abort-1',
      delegationRowId: null,
      provider: 'devin',
      model: null,
      effort: null,
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });

    const connection = new FakeConnection();
    chatRunRegistry.addSessionSubscriber(handle.childSessionId, connection as never);

    await handle.abort();
    await handle.completed;

    const completes = connection.frames.filter((frame) => frame.kind === 'complete');
    assert.equal(completes.length, 1);
    assert.equal(completes[0]?.aborted, true);
    assert.equal(completes[0]?.exitCode, 0);
    assert.equal(chatRunRegistry.isProcessing(handle.childSessionId), false);
    chatRunRegistry.clearAll();
  });
});

test('executor.resume: re-runs only failed steps with rebuilt dep summaries', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-r';
    orchestratorMessagesDb.append(sessionId, 'plan', {
      steps: [
        { id: 'a', type: 'code', title: 'A', prompt: 'do a', dependsOn: [], enabled: true },
        { id: 'b', type: 'code', title: 'B', prompt: 'do b', dependsOn: ['a'], enabled: true },
        { id: 'c', type: 'review', title: 'C', prompt: 'check', dependsOn: ['b'], enabled: true },
      ],
      awaitingConfirm: false,
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 'a',
      status: 'done',
      finalText: 'a finished output',
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 'b',
      status: 'failed',
      error: 'run in progress',
    });
    orchestratorMessagesDb.append(sessionId, 'summary', {
      text: '1/3 steps completed, failed: b, c',
      failed: ['b', 'c'],
      continued: [],
      aborted: false,
    });

    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => makeConfig(),
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.resume(sessionId, {});
    assert.ok(result.ok);
    // Only b and c re-ran; b received finished-dep a's summary as context.
    assert.equal(calls.length, 2);
    assert.match(calls[0].command, /do b/);
    assert.match(calls[0].command, /a finished output/);
    assert.match(calls[1].command, /VERDICT/);

    const delegations = orchestratorMessagesDb
      .list(sessionId)
      .filter((r) => r.kind === 'delegation');
    // b's row was reused in place — its seeded 'failed' status was reset to
    // 'queued' by the rerun and no second row was stacked for stepId 'b'
    // (the delegation service owns the running/done transitions).
    assert.equal(delegations.length, 3);
    assert.equal(delegations.filter((r) => r.payload.stepId === 'b').length, 1);
    assert.equal(delegations.find((r) => r.payload.stepId === 'b')?.payload.status, 'queued');

    const lastSummary = orchestratorMessagesDb
      .list(sessionId)
      .filter((r) => r.kind === 'summary')
      .at(-1);
    assert.match(String(lastSummary?.payload.text), /2\/2/);

    // Nothing left to resume.
    const again = await executor.resume(sessionId, {});
    assert.equal(again.ok, false);
    assert.equal(again.ok ? '' : again.code, 'NOTHING_TO_RESUME');
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

test('hasIssuesVerdict: detects PASS, ISSUES, FAIL across markdown formats and trailing verdicts', () => {
  assert.equal(hasIssuesVerdict('VERDICT: ISSUES'), true);
  assert.equal(hasIssuesVerdict('VERDICT: PASS'), false);
  assert.equal(hasIssuesVerdict('**VERDICT:** ISSUES'), true);
  assert.equal(hasIssuesVerdict('**VERDICT: ISSUES**'), true);
  assert.equal(hasIssuesVerdict('**VERDICT:** **ISSUES**'), true);
  assert.equal(hasIssuesVerdict('### VERDICT: ISSUES'), true);
  assert.equal(hasIssuesVerdict('**VERDICT:** **PASS**'), false);
  assert.equal(hasIssuesVerdict('verdict: issues'), true);
  assert.equal(hasIssuesVerdict('VERDICT: FAIL'), true);
  assert.equal(hasIssuesVerdict('VERDICT: FAILED'), true);
  assert.equal(hasIssuesVerdict('First thought VERDICT: ISSUES but then VERDICT: PASS'), false);
  assert.equal(hasIssuesVerdict('First thought VERDICT: PASS but then VERDICT: ISSUES'), true);
  assert.equal(hasIssuesVerdict('Random review text without verdict'), false);
});

test('resolveLanguageName maps UI language codes and tolerates missing/unknown values', () => {
  assert.equal(resolveLanguageName({ language: 'pl' }), 'Polish');
  assert.equal(resolveLanguageName({ language: 'en' }), 'English');
  assert.equal(resolveLanguageName({ language: 'zh-TW' }), 'Traditional Chinese');
  assert.equal(resolveLanguageName({ language: 'pt-BR' }), null);
  assert.equal(resolveLanguageName({ language: '  ' }), null);
  assert.equal(resolveLanguageName({}), null);
  assert.equal(resolveLanguageName({ language: 7 }), null);
});

test('buildPlannerPrompt adds a language rule only when a language is resolved', () => {
  const withPl = buildPlannerPrompt('implement feature', undefined, 0, 'Polish');
  assert.match(withPl, /Write every step's "title" and "prompt" in Polish\./);
  const withEn = buildPlannerPrompt('implement feature', undefined, 0, 'English');
  assert.match(withEn, /Write every step's "title" and "prompt" in English\./);
  const without = buildPlannerPrompt('implement feature');
  assert.doesNotMatch(without, /Write every step's "title"/);
});

test('executor: supervisor, delegated steps and report carry the UI language constraint', async () => {
  await withIsolatedDatabase(async () => {
    for (const [code, name] of [['pl', 'Polish'], ['en', 'English']] as const) {
      const config = makeConfig();
      config.planner.requireConfirm = false;

      const calls: Array<{ command: string; cwd: string }> = [];
      const delegation = {
        async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
          calls.push({ command: input.command, cwd: input.cwd });
          let finalText = 'done';
          if (input.command.includes('final report')) {
            finalText = 'report body';
          } else if (input.command.includes('"goals": "one paragraph')) {
            finalText = JSON.stringify({ goals: 'g', doneWhen: ['d'], requiresTests: false });
          } else if (input.command.includes('(no steps yet)')) {
            finalText = JSON.stringify({
              action: 'continue',
              reason: 'start work',
              steps: [
                { type: 'code', title: 'Implement', prompt: 'Implement the feature', dependsOn: [] },
                { type: 'review', title: 'Review', prompt: 'Review the changes', dependsOn: ['step-1'] },
              ],
            });
          } else if (input.command.includes('LEDGER')) {
            finalText = JSON.stringify({ action: 'done', reason: 'all done', outcome: 'success', steps: [] });
          }
          return {
            childSessionId: `child-${code}-${calls.length}`,
            completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
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

      const result = await executor.run(
        orchestrateInput(`sess-lang-${code}`, 'implement the feature', { cwd: '/repo', language: code }),
      );
      assert.equal(result.ok, true);
      // goals → decision(continue) → code step → review step → decision(done) → report.
      assert.equal(calls.length, 6);

      // Goals prompt: contract fields must be written in the UI language.
      assert.match(calls[0].command, new RegExp(`Write "goals" and "doneWhen" in ${name}\\.`));
      // Decision prompt: step titles/prompts and the reason follow the UI language.
      assert.match(calls[1].command, new RegExp(`Write "title", "prompt" and "reason" in ${name}\\.`));
      // Delegated step prompt carries the reply-language rule.
      assert.match(calls[2].command, new RegExp(`Write your entire reply in ${name}\\.`));
      // The dependent step's command carries it too, alongside the earlier-step context.
      assert.match(calls[3].command, /Result of earlier step "step-1":/);
      assert.match(calls[3].command, new RegExp(`Write your entire reply in ${name}\\.`));
      // The final report is written in the UI language.
      assert.match(calls[5].command, new RegExp(`Write the entire report in ${name}\\.`));
    }
  });
});

test('executor: review with issues triggers fix step and follow-up review until PASS', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.planner.requireConfirm = false;
    config.execution.maxFixLoops = 2;

    const calls: Array<{ command: string; cwd: string }> = [];
    let reviewCount = 0;
    const delegation = {
      async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
        calls.push({ command: input.command, cwd: input.cwd });
        let finalText = 'Done';
        if (input.command.includes('Review the changes made in fix-1')) {
          finalText = 'Fix looks great! VERDICT: PASS';
        } else if (input.command.includes('End your reply with a line exactly: VERDICT')) {
          reviewCount += 1;
          finalText = 'Found a critical bug in parser. VERDICT: ISSUES';
        }
        return {
          childSessionId: `child-${calls.length}`,
          completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
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

    const input = orchestrateInput('sess-fix-loop', 'implement feature', { cwd: '/repo' });
    const result = await executor.run(input);
    assert.ok(result.ok);

    // Call 1: step-1 (code)
    // Call 2: step-2 (review) -> returns ISSUES
    // Call 3: fix-1 (code) -> addresses ISSUES
    // Call 4: review-fix-1 (review) -> returns PASS
    assert.equal(calls.length, 4);
    assert.match(calls[2].command, /Fix the issues found in \(?review/i);
    assert.match(calls[3].command, /Review the changes made in fix-1/);

    const planRow = orchestratorMessagesDb.list('sess-fix-loop').find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 4);
    assert.equal(steps[2].id, 'fix-1');
    assert.equal(steps[2].type, 'code');
    assert.equal(steps[3].id, 'review-fix-1');
    assert.equal(steps[3].type, 'review');

    const summary = orchestratorMessagesDb.list('sess-fix-loop').find((r) => r.kind === 'summary');
    assert.match(String(summary?.payload.text), /4\/4 steps completed/);
    assert.deepEqual(summary?.payload.failed, []);
  });
});

test('executor: review with issues stops at maxFixLoops and marks the review failed', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.planner.requireConfirm = false;
    config.execution.maxFixLoops = 1;

    const calls: Array<{ command: string; cwd: string }> = [];
    const delegation = {
      async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
        calls.push({ command: input.command, cwd: input.cwd });
        let finalText = 'Done';
        if (input.command.includes('End your reply with a line exactly: VERDICT')) {
          finalText = 'Still broken. VERDICT: ISSUES';
        }
        return {
          childSessionId: `child-${calls.length}`,
          completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
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

    const input = orchestrateInput('sess-fix-max', 'implement feature', { cwd: '/repo' });
    const result = await executor.run(input);
    assert.ok(result.ok);

    // With maxFixLoops = 1:
    // Call 1: step-1 (code)
    // Call 2: step-2 (review) -> returns ISSUES -> triggers fix-1 + review-fix-1
    // Call 3: fix-1 (code)
    // Call 4: review-fix-1 (review) -> returns ISSUES -> fixCount is 1, reaches maxFixLoops (1), fails review-fix-1.
    assert.equal(calls.length, 4);

    const summary = orchestratorMessagesDb.list('sess-fix-max').find((r) => r.kind === 'summary');
    assert.match(String(summary?.payload.text), /failed: review-fix-1/);
    assert.deepEqual(summary?.payload.failed, ['review-fix-1']);

    const delegations = orchestratorMessagesDb.list('sess-fix-max').filter((r) => r.kind === 'delegation');
    const failedDelegation = delegations.find((d) => d.payload.stepId === 'review-fix-1');
    assert.equal(failedDelegation?.payload.status, 'failed');
    assert.match(String(failedDelegation?.payload.error), /reached maximum fix loops/);
  });
});

test('executor: test step with issues triggers fix step and follow-up test', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.planner.requireConfirm = false;
    config.execution.maxFixLoops = 2;

    const calls: Array<{ command: string; cwd: string }> = [];
    const delegation = {
      async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
        calls.push({ command: input.command, cwd: input.cwd });
        let finalText = 'Done';
        if (calls.length === 1) {
          finalText = 'Tests failed. 1 failed, 2 passed.\nVERDICT: ISSUES';
        } else if (calls.length === 2) {
          finalText = 'Fixed test regressions.';
        } else if (calls.length === 3) {
          finalText = 'All tests passed.\nVERDICT: PASS';
        }
        return {
          childSessionId: `child-${calls.length}`,
          completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
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

    const sessionId = 'sess-test-loop';
    // Append a plan with a test step directly to test auto-fix on test step
    orchestratorMessagesDb.append(sessionId, 'plan', {
      steps: [
        { id: 'test-1', type: 'test', title: 'run tests', prompt: 'run npm test', dependsOn: [], enabled: true },
      ],
      awaitingConfirm: false,
    });
    orchestratorMessagesDb.append(sessionId, 'summary', {
      text: '0/1 steps completed',
      failed: ['test-1'],
      continued: [],
      aborted: false,
    });

    const resumeResult = await executor.resume(sessionId, {});
    assert.ok(resumeResult.ok);

    // Call 1: test-1 -> returns ISSUES
    // Call 2: fix-1 (code) -> fixes issues
    // Call 3: test-fix-1 (test) -> returns PASS
    assert.equal(calls.length, 3);
    assert.match(calls[1].command, /Fix the test failures found in/);
    assert.match(calls[2].command, /Run tests to verify that the fixes made in fix-1/);

    const planRow = orchestratorMessagesDb.list(sessionId).find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 3);
    assert.equal(steps[1].id, 'fix-1');
    assert.equal(steps[1].type, 'code');
    assert.equal(steps[2].id, 'test-fix-1');
    assert.equal(steps[2].title, 'test fix 1: verify changes');
    assert.equal(steps[2].type, 'test');
  });
});

test('executor.resume: manual continuation by stepId appends fix and verification steps', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-manual-step';
    orchestratorMessagesDb.append(sessionId, 'plan', {
      steps: [
        { id: 'step-1', type: 'code', title: 'Feature A', prompt: 'code A', dependsOn: [], enabled: true },
        { id: 'step-2', type: 'review', title: 'Review A', prompt: 'review A', dependsOn: ['step-1'], enabled: true },
      ],
      awaitingConfirm: false,
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 'step-1',
      status: 'done',
      finalText: 'Finished implementing Feature A.',
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 'step-2',
      status: 'done',
      finalText: 'Code looks mostly fine. VERDICT: PASS',
    });
    orchestratorMessagesDb.append(sessionId, 'summary', {
      text: '2/2 steps completed',
      failed: [],
      continued: [],
      aborted: false,
    });

    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => makeConfig(),
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    // Manually trigger continuation on step-1 with a custom prompt
    const result = await executor.resume(sessionId, {
      stepId: 'step-1',
      prompt: 'Refactor step-1 to use helper function',
    });
    assert.ok(result.ok);

    // Ran 2 steps: cont-step-1-1 (code) + review-step-1-1 (review)
    assert.equal(calls.length, 2);
    assert.match(calls[0].command, /Refactor step-1 to use helper function/);
    assert.match(calls[0].command, /Finished implementing Feature A/);

    const planRow = orchestratorMessagesDb.list(sessionId).find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 4);
    assert.equal(steps[2].id, 'cont-step-1-1');
    assert.equal(steps[2].type, 'code');
    assert.equal(steps[3].id, 'review-step-1-1');
    assert.equal(steps[3].type, 'review');
  });
});

test('executor.resume: manual continuation with mode continue appends continuation steps', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-manual-cont';
    orchestratorMessagesDb.append(sessionId, 'plan', {
      steps: [
        { id: 's1', type: 'code', title: 'Initial setup', prompt: 'setup', dependsOn: [], enabled: true },
      ],
      awaitingConfirm: false,
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 's1',
      status: 'done',
      finalText: 'Initial setup done.',
    });
    orchestratorMessagesDb.append(sessionId, 'summary', {
      text: '1/1 steps completed',
      failed: [],
      continued: [],
      aborted: false,
    });

    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => makeConfig(),
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    // Manually continue completed work with mode 'continue'
    const result = await executor.resume(sessionId, {
      mode: 'continue',
      prompt: 'Add secondary validation logic',
    });
    assert.ok(result.ok);

    assert.equal(calls.length, 2);
    assert.match(calls[0].command, /Add secondary validation logic/);

    const planRow = orchestratorMessagesDb.list(sessionId).find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 3);
    assert.equal(steps[1].id, 'continue-1');
    assert.equal(steps[1].type, 'code');
    assert.equal(steps[2].id, 'review-continue-1');
    assert.equal(steps[2].type, 'review');
  });
});

test('extractPriorSessionContext: extracts child recommendations, offset and summary', () => {
  const rows = [
    {
      id: 1,
      sessionId: 'sess-ctx',
      seq: 1,
      kind: 'plan' as const,
      payload: {
        steps: [
          { id: 'step-1', type: 'code', title: 'Implement auth', prompt: 'code' },
          { id: 'step-2', type: 'review', title: 'Review auth', prompt: 'review' },
        ],
      },
      createdAt: '2026-01-01',
    },
    {
      id: 2,
      sessionId: 'sess-ctx',
      seq: 2,
      kind: 'delegation' as const,
      payload: {
        stepId: 'step-1',
        taskType: 'code',
        title: 'Implement auth',
        status: 'done',
        finalText: 'Auth implementation completed successfully.',
      },
      createdAt: '2026-01-01',
    },
    {
      id: 3,
      sessionId: 'sess-ctx',
      seq: 3,
      kind: 'delegation' as const,
      payload: {
        stepId: 'step-2',
        taskType: 'review',
        title: 'Review auth',
        status: 'done',
        finalText: 'Code looks clean.\n\nNext steps:\n- Add integration tests for OAuth token refresh\n- Update API docs with new auth headers\n\nVERDICT: PASS',
      },
      createdAt: '2026-01-01',
    },
  ];

  const ctx = extractPriorSessionContext(rows as unknown as import('@/shared/types.js').OrchestratorMessage[]);
  assert.equal(ctx.stepOffset, 2);
  assert.ok(ctx.completedSummaries.has('step-1'));
  assert.ok(ctx.completedSummaries.has('step-2'));
  assert.match(ctx.summaryText, /Auth implementation completed successfully/);
  assert.equal(ctx.suggestions.length, 2);
  assert.match(ctx.suggestions[0], /Add integration tests for OAuth token refresh/);
  assert.match(ctx.suggestions[1], /Update API docs with new auth headers/);
});

test('continueSession: appends custom steps with child handoff and executes coherently', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-continue-custom';
    orchestratorMessagesDb.append(sessionId, 'plan', {
      steps: [
        { id: 'step-1', type: 'code', title: 'Build parser', prompt: 'build parser', dependsOn: [], enabled: true },
      ],
      awaitingConfirm: false,
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 'step-1',
      taskType: 'code',
      title: 'Build parser',
      status: 'done',
      finalText: 'Parser implemented. Output format is AST JSON.',
    });
    orchestratorMessagesDb.append(sessionId, 'summary', {
      text: '1/1 steps completed',
      failed: [],
      continued: [],
      aborted: false,
    });

    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => makeConfig(),
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });

    const continueResult = await executor.continueSession(sessionId, undefined, [
      {
        id: 'step-2',
        type: 'test',
        title: 'Test parser AST',
        prompt: 'Run tests against parser AST output',
        dependsOn: ['step-1'],
        enabled: true,
      },
    ]);
    assert.ok(continueResult.ok);
    assert.equal(calls.length, 1);
    // Verifies that child step 2 received the summary output of step 1
    assert.match(calls[0].command, /Result of earlier step "step-1":/);
    assert.match(calls[0].command, /Parser implemented. Output format is AST JSON./);

    const planRow = orchestratorMessagesDb.list(sessionId).find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 2);
    assert.equal(steps[1].id, 'step-2');
  });
});

test('continueSession: continuation with prompt plans next steps building on prior child context', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-continue-prompt';
    orchestratorMessagesDb.append(sessionId, 'plan', {
      steps: [
        { id: 'step-1', type: 'code', title: 'Write core API', prompt: 'api', dependsOn: [], enabled: true },
      ],
      awaitingConfirm: false,
    });
    orchestratorMessagesDb.append(sessionId, 'delegation', {
      stepId: 'step-1',
      taskType: 'code',
      title: 'Write core API',
      status: 'done',
      finalText: 'API is ready at /api/v1.',
    });
    orchestratorMessagesDb.append(sessionId, 'summary', {
      text: '1/1 steps completed',
      failed: [],
      continued: [],
      aborted: false,
    });

    const calls: Array<{ command: string; cwd: string }> = [];
    const fakeDelegationWithPlanner = {
      async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
        calls.push({ command: input.command, cwd: input.cwd });
        let finalText = 'done';
        if (input.command.includes('You are a task planner')) {
          finalText = JSON.stringify([
            {
              type: 'test',
              title: 'Integration tests for /api/v1',
              prompt: 'Write tests for /api/v1 based on existing endpoints',
              dependsOn: ['step-1'],
            },
          ]);
        }
        return {
          childSessionId: `child-${calls.length}`,
          completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => makeConfig(),
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegationWithPlanner,
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.continueSession(sessionId, 'Add integration tests for /api/v1');
    assert.ok(result.ok);

    // Call 0 was the planner candidate prompt:
    assert.match(calls[0].command, /CONTEXT FROM EARLIER COMPLETED STEPS/);
    assert.match(calls[0].command, /API is ready at \/api\/v1/);
    assert.match(calls[0].command, /CRITICAL: The new steps MUST be coherent with and build upon the child agents' responses/);

    // Call 1 was step-2 (test step), which received step-1 output:
    assert.match(calls[1].command, /Result of earlier step "step-1":/);
    assert.match(calls[1].command, /API is ready at \/api\/v1/);

    const planRow = orchestratorMessagesDb.list(sessionId).find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 2);
    assert.equal(steps[1].id, 'step-2');
    assert.deepEqual(steps[1].dependsOn, ['step-1']);
  });
});

test('executor: summary includes findings and conclusions from completed subcontractor tasks', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const stepOutputs: Record<string, string> = {
      'step-arch': 'Architecture decision: Use SQLite with WAL mode for local storage.',
      'step-impl': 'Implementation complete: Database schema created and migrations verified.',
    };

    const delegation = {
      async run(input: { command: string }) {
        // The step prompt opens the command ("<id> prompt"); dependency
        // summaries embedded later must not win the match.
        const stepId = Object.keys(stepOutputs).find((id) => input.command.startsWith(id)) || 'step-arch';
        return {
          childSessionId: `child-${stepId}`,
          completed: Promise.resolve({
            ok: true,
            error: null,
            finalText: stepOutputs[stepId] ?? 'Step completed successfully.',
            aborted: false,
          }),
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
        { id: 'step-arch', type: 'code', title: 'Design Architecture', prompt: 'step-arch prompt', dependsOn: [] },
        { id: 'step-impl', type: 'code', title: 'Implement DB Schema', prompt: 'step-impl prompt', dependsOn: ['step-arch'] },
      ],
      'fallback',
    );

    const result = await executor.confirm('sess-summary-results', steps, {});
    assert.ok(result.ok);

    const summary = orchestratorMessagesDb.list('sess-summary-results').find((r) => r.kind === 'summary');
    assert.ok(summary, 'Summary message must exist');
    assert.match(String(summary.payload.text), /2\/2 steps completed/);

    const results = summary.payload.results as Array<{ title: string; summary: string }>;
    assert.ok(Array.isArray(results), 'summary.payload.results must be an array');
    assert.equal(results.length, 2);
    assert.equal(results[0].title, 'Design Architecture');
    assert.equal(results[0].summary, 'Architecture decision: Use SQLite with WAL mode for local storage.');
    assert.equal(results[1].title, 'Implement DB Schema');
    assert.equal(results[1].summary, 'Implementation complete: Database schema created and migrations verified.');
  });
});

test('executor: summary excludes failed and skipped steps from results', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const delegation = {
      async run(input: { command: string }) {
        if (input.command.includes('step-1')) {
          return {
            childSessionId: 'child-1',
            completed: Promise.resolve({
              ok: true,
              error: null,
              finalText: 'Step 1 completed: Core module exported.',
              aborted: false,
            }),
            abort: async () => undefined,
          };
        }
        return {
          childSessionId: 'child-2',
          completed: Promise.resolve({
            ok: false,
            error: 'Compilation failed',
            finalText: '',
            aborted: false,
          }),
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
        { id: 'step-1', type: 'code', title: 'Core Module', prompt: 'step-1 prompt', dependsOn: [] },
        { id: 'step-2', type: 'code', title: 'Failing Step', prompt: 'step-2 prompt', dependsOn: [] },
        { id: 'step-3', type: 'code', title: 'Skipped Dependent', prompt: 'step-3 prompt', dependsOn: ['step-2'] },
      ],
      'fallback',
    );

    const result = await executor.confirm('sess-summary-failed', steps, {});
    assert.equal(result.ok, true);

    const summary = orchestratorMessagesDb.list('sess-summary-failed').find((r) => r.kind === 'summary');
    assert.ok(summary);
    assert.match(String(summary.payload.text), /1\/3 steps completed/);

    const results = summary.payload.results as Array<{ title: string; summary: string }>;
    assert.ok(Array.isArray(results));
    assert.equal(results.length, 1);
    assert.equal(results[0].title, 'Core Module');
    assert.equal(results[0].summary, 'Step 1 completed: Core module exported.');

    const failed = summary.payload.failed as string[];
    assert.ok(failed.includes('step-2'));
    assert.ok(failed.includes('step-3'));
  });
});

type FakeTaskmasterTask = {
  id: number | string;
  title: string;
  status: string;
  description?: string;
  dependencies?: Array<number | string>;
  subtasks?: Array<Record<string, unknown>>;
};

/** In-memory TaskMaster store stub recording every status transition. */
function makeTaskmasterStore(tasks: FakeTaskmasterTask[]) {
  const statusLog: Array<{ taskId: string; status: string }> = [];
  return {
    statusLog,
    async listTasks() {
      return tasks;
    },
    async setTaskStatus(_projectPath: string, taskId: string, status: string) {
      statusLog.push({ taskId, status });
      const task = tasks.find((t) => String(t.id) === taskId);
      if (task) task.status = status;
      return task ?? null;
    },
  };
}

test('executor.resume mode complete-all-tasks: drains the queue sequentially', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-tm-loop';
    const config = makeConfig();
    config.planner.mode = 'off';

    const tasks: FakeTaskmasterTask[] = [
      { id: 1, title: 'First task', status: 'done' },
      { id: 2, title: 'Second task', status: 'pending' },
      { id: 3, title: 'Third task', status: 'pending', dependencies: [2] },
    ];
    const store = makeTaskmasterStore(tasks);
    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      taskmaster: store,
    });

    const result = await executor.resume(sessionId, { mode: 'complete-all-tasks' });
    assert.equal(result.ok, true);

    // Both unfinished tasks ran: code + appended review step each.
    assert.deepEqual(
      store.statusLog,
      [
        { taskId: '2', status: 'in-progress' },
        { taskId: '2', status: 'done' },
        { taskId: '3', status: 'in-progress' },
        { taskId: '3', status: 'done' },
      ],
    );
    assert.equal(calls.filter((c) => c.command.includes('TaskMaster task #2')).length, 1);
    assert.equal(calls.filter((c) => c.command.includes('TaskMaster task #3')).length, 1);
    assert.ok(calls.every((c) => c.cwd === '/repo'));

    const rows = orchestratorMessagesDb.list(sessionId);
    const tmRows = rows.filter((r) => r.kind === 'taskmaster');
    assert.deepEqual(
      tmRows.map((r) => r.payload.status),
      ['started', 'done', 'started', 'done', 'complete'],
    );
    assert.equal(tmRows[0].payload.taskId, '2');
    assert.equal(tmRows[1].payload.remaining, 1);
    const plans = rows.filter((r) => r.kind === 'plan');
    assert.equal(plans.length, 2);
    assert.equal(plans[0].payload.source, 'taskmaster');
    assert.equal((plans[0].payload.taskmaster as { taskId: string }).taskId, '2');
  });
});

test('executor.resume mode complete-all-tasks: stops on task failure, keeps it in-progress', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-tm-fail';
    const config = makeConfig();
    config.planner.mode = 'off';

    const tasks: FakeTaskmasterTask[] = [
      { id: 1, title: 'Good task', status: 'pending' },
      { id: 2, title: 'Bad task', status: 'pending' },
      { id: 3, title: 'Later task', status: 'pending' },
    ];
    const store = makeTaskmasterStore(tasks);
    const calls: Array<{ command: string; cwd: string }> = [];
    const delegation = {
      async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
        calls.push({ command: input.command, cwd: input.cwd });
        const fails = input.command.includes('task #2');
        return {
          childSessionId: `child-${calls.length}`,
          completed: Promise.resolve({
            ok: !fails,
            error: fails ? 'boom' : null,
            finalText: 'done',
            aborted: false,
          }),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
      taskmaster: store,
    });

    const result = await executor.resume(sessionId, { mode: 'complete-all-tasks' });
    assert.equal(result.ok, false);
    assert.equal(result.ok ? '' : result.code, 'TASK_FAILED');

    // Task 1 finished, task 2 attempted but left in-progress, task 3 untouched.
    assert.equal(tasks[0].status, 'done');
    assert.equal(tasks[1].status, 'in-progress');
    assert.equal(tasks[2].status, 'pending');
    assert.equal(calls.some((c) => c.command.includes('task #3')), false);

    const tmRows = orchestratorMessagesDb
      .list(sessionId)
      .filter((r) => r.kind === 'taskmaster');
    assert.equal(tmRows.at(-1)?.payload.status, 'failed');
    assert.equal(tmRows.at(-1)?.payload.taskId, '2');
  });
});

test('executor.resume mode complete-all-tasks: maxTasks bounds the run', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-tm-max';
    const config = makeConfig();
    config.planner.mode = 'off';

    const tasks: FakeTaskmasterTask[] = [
      { id: 1, title: 'One', status: 'pending' },
      { id: 2, title: 'Two', status: 'pending' },
    ];
    const store = makeTaskmasterStore(tasks);
    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      taskmaster: store,
    });

    const result = await executor.resume(sessionId, { mode: 'complete-all-tasks', maxTasks: 1 });
    assert.equal(result.ok, true);
    assert.equal(tasks[0].status, 'done');
    assert.equal(tasks[1].status, 'pending');
    assert.equal(calls.some((c) => c.command.includes('task #2')), false);

    const tmRows = orchestratorMessagesDb
      .list(sessionId)
      .filter((r) => r.kind === 'taskmaster');
    assert.equal(tmRows.at(-1)?.payload.status, 'paused');
  });
});

test('executor.resume mode complete-all-tasks: empty queue and missing store', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    const calls: Array<{ command: string; cwd: string }> = [];

    const done = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      taskmaster: makeTaskmasterStore([{ id: 1, title: 'Done', status: 'done' }]),
    });
    const result = await done.resume('sess-tm-empty', { mode: 'complete-all-tasks' });
    assert.equal(result.ok, true);
    assert.equal(calls.length, 0);
    const tmRows = orchestratorMessagesDb
      .list('sess-tm-empty')
      .filter((r) => r.kind === 'taskmaster');
    assert.equal(tmRows.at(-1)?.payload.status, 'complete');

    const noFile = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      taskmaster: { async listTasks() { return null; }, async setTaskStatus() { return null; } },
    });
    const missing = await noFile.resume('sess-tm-nofile', { mode: 'complete-all-tasks' });
    assert.equal(missing.ok, false);
    assert.equal(missing.ok ? '' : missing.code, 'NO_TASKMASTER');

    const noStore = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    });
    const unavailable = await noStore.resume('sess-tm-nostore', { mode: 'complete-all-tasks' });
    assert.equal(unavailable.ok, false);
    assert.equal(unavailable.ok ? '' : unavailable.code, 'TASKMASTER_UNAVAILABLE');
  });
});

test('executor.resume mode complete-all-tasks: abort stops loop, leaves remaining tasks pending', async () => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'sess-tm-abort';
    const config = makeConfig();
    config.planner.mode = 'off';

    const tasks: FakeTaskmasterTask[] = [
      { id: 1, title: 'First task', status: 'pending' },
      { id: 2, title: 'Second task', status: 'pending' },
    ];
    const store = makeTaskmasterStore(tasks);
    let abortCalled = false;
    let finishChild: ((value: { ok: boolean; error: string | null; finalText: string; aborted: boolean }) => void) | null = null;
    const calls: Array<{ command: string; cwd: string }> = [];

    const delegation = {
      async run(input: { command: string; cwd: string; delegationRowId: number | null }) {
        calls.push({ command: input.command, cwd: input.cwd });
        return {
          childSessionId: `child-${calls.length}`,
          completed: new Promise<{ ok: boolean; error: string | null; finalText: string; aborted: boolean }>((resolve) => {
            finishChild = resolve;
          }),
          abort: async () => {
            abortCalled = true;
            finishChild?.({ ok: false, error: 'aborted by user', finalText: '', aborted: true });
          },
        };
      },
    };

    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
      taskmaster: store,
    });

    const resumePromise = executor.resume(sessionId, { mode: 'complete-all-tasks' });

    // Wait until child run has started
    await new Promise((resolve) => setTimeout(resolve, 50));
    assert.equal(calls.length, 1);
    assert.equal(tasks[0].status, 'in-progress');

    // Abort the session
    const aborted = await executor.abort(sessionId);
    assert.equal(aborted, true);
    assert.equal(abortCalled, true);

    const result = await resumePromise;
    assert.equal(result.ok, false);
    assert.equal(result.ok ? '' : result.code, 'ABORTED');

    // First task was in-progress, second task was never started and remains pending
    assert.equal(tasks[0].status, 'in-progress');
    assert.equal(tasks[1].status, 'pending');
    assert.equal(calls.length, 1);

    const tmRows = orchestratorMessagesDb
      .list(sessionId)
      .filter((r) => r.kind === 'taskmaster');
    assert.equal(tmRows.at(-1)?.payload.status, 'aborted');
    assert.equal(tmRows.at(-1)?.payload.taskId, '1');
  });
});

test('classifyStepError: rate_limit/auth/quota/timeout/transient precedence', () => {
  assert.equal(classifyStepError('HTTP 429: rate limit exceeded'), 'rate_limit');
  assert.equal(
    classifyStepError('All 2 account(s) rate-limited. Quota resets in 144h'),
    'rate_limit',
  );
  assert.equal(classifyStepError('quota exceeded for plan'), 'quota');
  assert.equal(classifyStepError('401 unauthorized'), 'auth');
  assert.equal(classifyStepError('request timed out'), 'timeout');
  assert.equal(classifyStepError('boom'), 'transient');
  assert.equal(classifyStepError(null), 'transient');
});

test('executor: a gate step runs its command without delegation', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: Array<{ command: string; cwd: string }> = [];
    const gateRuns: Array<{ command: string; cwd: string; timeoutMs: number }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      runGate: async (command, cwd, timeoutMs) => {
        gateRuns.push({ command, cwd, timeoutMs });
        return { code: 0, output: 'ok', timedOut: false };
      },
    });

    const steps = normalizeEditableSteps(
      [
        { id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] },
        { id: 'g', type: 'gate', title: 'G', prompt: 'verify', command: 'npm test', dependsOn: ['a'] },
      ],
      'fallback',
    );
    const result = await executor.confirm('sess-gate', steps, {});
    assert.ok(result.ok);

    // Only the code step delegated — the gate ran its command in the run cwd.
    assert.equal(calls.length, 1);
    assert.equal(gateRuns.length, 1);
    assert.equal(gateRuns[0].command, 'npm test');
    assert.equal(gateRuns[0].cwd, '/repo');

    const gateRow = orchestratorMessagesDb
      .list('sess-gate')
      .find((r) => r.kind === 'gate');
    assert.equal(gateRow?.payload.stepId, 'g');
    assert.equal(gateRow?.payload.status, 'done');
    assert.equal(gateRow?.payload.exitCode, 0);
    assert.equal(gateRow?.payload.command, 'npm test');
  });
});

test('executor: a failing gate step fails the plan when fix loops are off', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.execution.maxFixLoops = 0;
    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      runGate: async () => ({ code: 1, output: 'fail', timedOut: false }),
    });

    const steps = normalizeEditableSteps(
      [
        { id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] },
        { id: 'g', type: 'gate', title: 'G', prompt: 'verify', command: 'npm test', dependsOn: ['a'] },
      ],
      'fallback',
    );
    const result = await executor.confirm('sess-gate-fail', steps, {});
    assert.ok(result.ok);

    const rows = orchestratorMessagesDb.list('sess-gate-fail');
    const gateRow = rows.find((r) => r.kind === 'gate');
    assert.equal(gateRow?.payload.status, 'failed');
    assert.equal(gateRow?.payload.exitCode, 1);
    // No fix pair was appended — the budget was zero.
    assert.equal(rows.some((r) => r.kind === 'delegation' && String(r.payload.stepId ?? '').startsWith('fix-')), false);
    const summary = rows.find((r) => r.kind === 'summary');
    assert.deepEqual(summary?.payload.failed, ['g']);
  });
});

test('executor: a quota failure cools the lane for the rest of the run', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.pool = [
      { id: 'aa', provider: 'devin', model: 'm-aa', effort: null, accountId: null, tier: 'free', label: 'AA' },
      { id: 'bb', provider: 'devin', model: 'm-bb', effort: null, accountId: null, tier: 'free', label: 'BB' },
    ];
    config.rules.code = ['aa', 'bb'];

    const lanes: string[] = [];
    const delegation = {
      async run(input: { provider: string; model: string | null }) {
        lanes.push(input.model ?? '');
        const first = lanes.length === 1;
        return {
          childSessionId: `child-${lanes.length}`,
          completed: Promise.resolve(
            first
              ? { ok: false, error: 'quota exceeded for plan', finalText: '', aborted: false }
              : { ok: true, error: null, finalText: 'done', aborted: false },
          ),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter(null, ['devin'], config),
      delegation,
      resolveSessionCwd: () => '/repo',
      sleep: async () => undefined,
    });

    const steps = normalizeEditableSteps(
      [
        { id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] },
        { id: 'b', type: 'code', title: 'B', prompt: 'pb', dependsOn: ['a'] },
      ],
      'fallback',
    );
    const result = await executor.confirm('sess-cooldown', steps, {});
    assert.ok(result.ok);
    // 'aa' ate one quota error, cooled down for the rest of the run —
    // step b routed straight to 'bb' without touching 'aa' again.
    assert.deepEqual(lanes, ['m-aa', 'm-bb', 'm-bb']);
  });
});

test('executor: supervisor goals get the repo map and one repair shot on garbage', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'auto';
    config.planner.requireConfirm = false;

    const calls: string[] = [];
    const delegation = {
      async run(input: { command: string }) {
        calls.push(input.command);
        let finalText = 'done';
        if (input.command.includes('Previous reply')) {
          finalText = JSON.stringify({ goals: 'answer the question', doneWhen: ['answered'], requiresTests: false });
        } else if (input.command.includes('final report')) {
          finalText = 'report body';
        } else if (input.command.includes('"goals": "one paragraph')) {
          finalText = 'garbage';
        } else if (input.command.includes('(no steps yet)')) {
          finalText = JSON.stringify({
            action: 'continue',
            reason: 'one quick step is enough',
            steps: [{ type: 'quick', title: 'quick answer', prompt: 'answer it', dependsOn: [] }],
          });
        } else if (input.command.includes('LEDGER')) {
          finalText = JSON.stringify({ action: 'done', reason: 'answered', outcome: 'success', steps: [] });
        }
        return {
          childSessionId: `child-${calls.length}`,
          completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
          abort: async () => undefined,
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
      repoMap: async () => 'src/\nserver/',
    });

    const result = await executor.run(
      orchestrateInput('sess-plan-ctx', 'do a quick thing', { cwd: '/repo' }),
    );
    assert.ok(result.ok);
    // goals(garbage) → goals repair(valid) → decision(continue) → quick step →
    // decision(done) → report = 6 calls.
    assert.equal(calls.length, 6);
    // Goals call carries the injected repo map; the repair call carries
    // the previous (garbage) reply.
    assert.match(calls[0], /REPOSITORY MAP/);
    assert.match(calls[0], /src\//);
    assert.match(calls[1], /Previous reply/);
    assert.match(calls[1], /garbage/);

    const planRow = orchestratorMessagesDb.list('sess-plan-ctx').find((r) => r.kind === 'plan');
    assert.equal((planRow?.payload.steps as unknown[]).length, 1);
    // The final report lands on the summary row.
    const summary = [...orchestratorMessagesDb.list('sess-plan-ctx')]
      .reverse()
      .find((r) => r.kind === 'summary');
    assert.equal(summary?.payload.report, 'report body');
  });
});

test('executor: a completed step stores a changed-files artifact on its delegation row', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    let probes = 0;
    const calls: Array<{ command: string; cwd: string }> = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
      probeChangedFiles: async () => {
        probes += 1;
        // Baseline probe (first call) is clean; the after-probe sees the file.
        return probes === 1 ? new Set<string>() : new Set(['src/x.ts']);
      },
    });

    const steps = normalizeEditableSteps(
      [{ id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] }],
      'fallback',
    );
    const result = await executor.confirm('sess-artifact', steps, {});
    assert.ok(result.ok);

    const row = orchestratorMessagesDb
      .list('sess-artifact')
      .find((r) => r.kind === 'delegation' && r.payload.stepId === 'a');
    const artifact = row?.payload.artifact as
      | { summary: string; changedFiles: string[]; keyPaths: string[] }
      | undefined;
    assert.ok(artifact, 'delegation row carries an artifact');
    assert.equal(artifact.summary, 'done');
    assert.deepEqual(artifact.changedFiles, ['src/x.ts']);
    assert.deepEqual(artifact.keyPaths, ['src/x.ts']);
  });
});

test('executor: a parked plan row keeps confirm working across executor instances', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.mode = 'off';
    config.planner.requireConfirm = true;
    const calls: Array<{ command: string; cwd: string }> = [];
    const deps = {
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: fakeDelegation(calls),
      resolveSessionCwd: () => '/repo',
    };

    const first = createOrchestratorExecutor(deps);
    const parked = await first.run(
      orchestrateInput('sess-pending', 'implement the thing', { cwd: '/repo' }),
    );
    assert.ok(parked.ok);
    assert.equal(calls.length, 0);

    // A fresh executor has no in-memory stash — hasPendingPlan and confirm
    // must rebuild from the plan + user transcript rows.
    const second = createOrchestratorExecutor(deps);
    assert.equal(second.hasPendingPlan('sess-pending'), true);
    const result = await second.confirm(
      'sess-pending',
      // The wire format omits the prompt — it is restored from the plan row.
      [{ id: 'step-1', type: 'code', title: 'impl', dependsOn: [] }],
      {},
    );
    assert.ok(result.ok);
    assert.equal(second.hasPendingPlan('sess-pending'), false);
    assert.equal(calls.length, 1);
    assert.match(calls[0].command, /implement the thing/);
  });
});

test('executor: a step timeout aborts the child and fails over to the next lane', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.execution.stepTimeoutMs = 20;
    const lanes: string[] = [];
    let aborts = 0;
    const delegation = {
      async run(input: { provider: string; model: string | null }) {
        lanes.push(`${input.provider}/${input.model}`);
        const first = lanes.length === 1;
        return {
          childSessionId: `child-${lanes.length}`,
          completed: first
            ? new Promise<never>(() => undefined) // never settles → step timer wins
            : Promise.resolve({ ok: true, error: null, finalText: 'done', aborted: false }),
          abort: async () => {
            aborts += 1;
          },
        };
      },
    };
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation,
      resolveSessionCwd: () => '/repo',
      sleep: async () => undefined,
    });

    const steps = normalizeEditableSteps(
      [{ id: 'a', type: 'code', title: 'A', prompt: 'pa', dependsOn: [] }],
      'fallback',
    );
    const result = await executor.confirm('sess-step-timeout', steps, {});
    assert.ok(result.ok);
    // Lane 1 hit the 20ms budget (timeout class, budget 0 → failover);
    // lane 2 succeeded.
    assert.equal(lanes.length, 2);
    assert.equal(aborts, 1);
    const row = orchestratorMessagesDb
      .list('sess-step-timeout')
      .find((r) => r.kind === 'delegation' && r.payload.stepId === 'a');
    assert.equal(row?.payload.attempt, 2);
  });
});




test('router: native Codex quota blocks an exhausted paid lane', () => {
  const config = makeConfig();
  config.pool = [{ id: 'native', provider: 'codex', model: 'gpt-5', tier: 'premium', effort: null, accountId: null, label: 'Codex' }];
  config.rules.code = ['native'];
  assert.equal(makeRouter([quotaAccount('codex', 'active', true)], ['codex'], config).route('code').ok, false);
  assert.equal(makeRouter([quotaAccount('codex', 'active')], ['codex'], config).route('code').ok, true);
});

test('router: Claude scoped quota only blocks the matching model', () => {
  const config = makeConfig();
  config.pool = [{ id: 'native', provider: 'claude', model: 'claude-opus-4', tier: 'premium', effort: null, accountId: null, label: 'Claude' }];
  config.rules.code = ['native'];
  const account = quotaAccount('claude', 'active');
  account.windows = [
    { ...account.windows[0], label: 'Weekly' },
    { ...quotaAccount('claude', 'active', true).windows[0], label: 'Sonnet · Weekly' },
  ];
  assert.equal(makeRouter([account], ['claude'], config).route('code').ok, true);
  config.pool[0].model = 'claude-sonnet-4';
  assert.equal(makeRouter([account], ['claude'], config).route('code').ok, false);
});

test('router: standalone Antigravity checks its Gemini quota pool', () => {
  const config = makeConfig();
  config.pool = [{ id: 'native', provider: 'antigravity', model: 'gemini-pro', tier: 'premium', effort: null, accountId: null, label: 'Antigravity' }];
  config.rules.code = ['native'];
  const account = quotaAccount('gemini', 'active', true);
  account.windows[0].label = 'Gemini Models · weekly';
  assert.equal(makeRouter([account], ['antigravity'], config).route('code').ok, false);
});

test('router: per-account quota only blocks the exhausted provider_accounts row', () => {
  const config = makeConfig();
  config.pool = [
    { id: 'agy-a', provider: 'antigravity', model: 'gemini-pro', tier: 'premium', effort: null, accountId: 'acc-a', label: 'Agy A' },
    { id: 'agy-b', provider: 'antigravity', model: 'gemini-pro', tier: 'premium', effort: null, accountId: 'acc-b', label: 'Agy B' },
  ];
  config.rules.code = ['agy-a', 'agy-b'];
  const accA: QuotaAccount = {
    ...quotaAccount('gemini', 'active', true),
    id: 'acc-a',
    accountId: 'acc-a',
    windows: quotaAccount('gemini', 'active', true).windows.map((w) => ({
      ...w,
      label: 'Gemini Models · weekly',
    })),
  };
  const accB: QuotaAccount = {
    ...quotaAccount('gemini', 'active'),
    id: 'acc-b',
    accountId: 'acc-b',
    windows: quotaAccount('gemini', 'active').windows.map((w) => ({
      ...w,
      label: 'Gemini Models · weekly',
    })),
  };
  const res = makeRouter([accA, accB], ['antigravity'], config).route('code');
  assert.ok(res.ok);
  // acc-a's Gemini pool is spent but acc-b's is not — the pinned
  // candidate must not be dragged down by a sibling account.
  assert.equal(res.candidate.id, 'agy-b');
});
