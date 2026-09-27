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
  extractPriorSessionContext,
  hasIssuesVerdict,
  normalizeEditableSteps,
  parsePlanJson,
} from '@/modules/orchestrator/services/orchestrator-executor.service.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import type {
  AnyRecord,
  OrchestratorConfig,
  OrchestratorPlanStep,
  QuotaAccount,
} from '@/shared/types.js';

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
    // Antigravity subscription leads every lane; devin + commandcode follow.
    assert.equal(config.rules.code[0], 'oc-agy-sonnet');
    assert.equal(config.rules.review[0], 'oc-agy-opus');
    assert.equal(config.planner.candidateId, 'oc-gem38f');

    const stored = service.put(config);
    assert.equal(stored.rules.review[0], 'oc-agy-opus');
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

test('executor: failed step auto-retries once, then ends failed with a resumable summary', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    let calls = 0;
    const delegation = {
      async run() {
        calls += 1;
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

    // Exactly one automatic retry — no parking, the run ends.
    assert.equal(calls, 2);
    assert.equal(result.ok, false);

    const rows = orchestratorMessagesDb.list('sess-4');
    const aRow = rows.find((r) => r.kind === 'delegation' && r.payload.stepId === 'a');
    assert.equal(aRow?.payload.status, 'failed');
    assert.equal(aRow?.payload.attempt, 2);
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
    assert.match(calls[0].command, /Result of earlier step 1:/);
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
    assert.match(calls[1].command, /Result of earlier step 1:/);
    assert.match(calls[1].command, /API is ready at \/api\/v1/);

    const planRow = orchestratorMessagesDb.list(sessionId).find((r) => r.kind === 'plan');
    const steps = planRow?.payload.steps as OrchestratorPlanStep[];
    assert.equal(steps.length, 2);
    assert.equal(steps[1].id, 'step-2');
    assert.deepEqual(steps[1].dependsOn, ['step-1']);
  });
});
