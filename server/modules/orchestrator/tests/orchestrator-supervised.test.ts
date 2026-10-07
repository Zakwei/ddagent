import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, orchestratorMessagesDb } from '@/modules/database/index.js';
import { createOrchestratorConfigService } from '@/modules/orchestrator/services/orchestrator-config.service.js';
import { createOrchestratorRouterService } from '@/modules/orchestrator/services/orchestrator-router.service.js';
import { createOrchestratorExecutor } from '@/modules/orchestrator/services/orchestrator-executor.service.js';
import type {
  AnyRecord,
  OrchestratorConfig,
  QuotaAccount,
} from '@/shared/types.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'orchestrator-sup-'));
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
  accountEmail: '',
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

const orchestrateInput = (sessionId: string, content: string, options: AnyRecord = {}) => ({
  sessionId,
  content,
  options,
  connection: { readyState: 0, send: () => undefined } as never,
});

type LaneCall = {
  command: string;
  cwd: string;
  provider?: string;
  model?: string | null;
  hidden?: boolean;
};

/**
 * Delegation stand-in for supervised runs. Goals calls embed the JSON shape
 * `"goals": "one paragraph`, decision calls embed `LEDGER`, the report call
 * embeds `final report`, everything else is a real step. `script` supplies
 * the decision replies per call index (or a function of the ledger state).
 */
function scriptedDelegation(
  calls: LaneCall[],
  script: {
    goals?: string;
    decide: (ledger: { first: boolean; iteration: number }) => string;
    stepReply?: string | ((command: string) => string);
    report?: string;
  },
) {
  let decisionCalls = 0;
  return {
    async run(input: { command: string; cwd: string; provider?: string; model?: string | null; hidden?: boolean }) {
      calls.push({ command: input.command, cwd: input.cwd, provider: input.provider, model: input.model, hidden: input.hidden });
      let finalText = typeof script.stepReply === 'function' ? script.stepReply(input.command) : script.stepReply ?? 'done';
      if (input.command.includes('final report')) {
        finalText = script.report ?? 'report body';
      } else if (input.command.includes('not a valid JSON goal contract')) {
        finalText = script.goals ?? JSON.stringify({ goals: 'g', doneWhen: ['d'], requiresTests: false });
      } else if (input.command.includes('"goals": "one paragraph')) {
        finalText = script.goals ?? JSON.stringify({ goals: 'g', doneWhen: ['d'], requiresTests: false });
      } else if (input.command.includes('not a valid JSON decision')) {
        finalText = script.decide({ first: false, iteration: ++decisionCalls });
      } else if (input.command.includes('LEDGER')) {
        finalText = script.decide({ first: input.command.includes('(no steps yet)'), iteration: ++decisionCalls });
      }
      return {
        childSessionId: `child-${calls.length}`,
        completed: Promise.resolve({ ok: true, error: null, finalText, aborted: false }),
        abort: async () => undefined,
      };
    },
  };
}

const continueWith = (steps: Array<Record<string, unknown>>, reason = 'next') =>
  JSON.stringify({ action: 'continue', reason, steps });
const doneDecision = (reason = 'finished', outcome = 'success') =>
  JSON.stringify({ action: 'done', reason, outcome, steps: [] });

const rowsOf = (sessionId: string, kind: string) =>
  orchestratorMessagesDb.list(sessionId).filter((r) => r.kind === kind);

test('supervised: happy path — goals, one decision batch, done, report', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ first }) =>
          first
            ? continueWith([{ type: 'quick', title: 'Answer', prompt: 'answer the question' }])
            : doneDecision('answered'),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-1', 'answer a question', { cwd: '/repo' }));
    assert.equal(result.ok, true);

    // goals → decision(continue) → step → decision(done) → report
    assert.equal(calls.length, 5);
    // Only the real delegated step may surface as a sidebar session; every
    // internal lane call (goals, decisions, report) must be hidden.
    assert.deepEqual(
      calls.map((call) => call.hidden === true),
      [true, true, false, true, true],
    );
    const plan = rowsOf('sup-1', 'plan')[0];
    assert.equal(plan.payload.source, 'supervised');
    assert.equal(plan.payload.goals, 'g');
    assert.deepEqual(plan.payload.doneWhen, ['d']);
    assert.equal((plan.payload.steps as unknown[]).length, 1);

    const decisions = rowsOf('sup-1', 'decision');
    assert.equal(decisions.length, 2);
    assert.equal(decisions[0].payload.action, 'continue');
    assert.equal(decisions[0].payload.reason, 'next');
    assert.equal(decisions[1].payload.action, 'done');
    assert.equal(decisions[1].payload.reason, 'answered');

    const summary = rowsOf('sup-1', 'summary')[0];
    assert.equal(summary.payload.report, 'report body');
    assert.match(String(summary.payload.text), /1\/1 steps completed/);
  });
});

test('supervised: decision batches are capped at maxParallel steps', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.execution.maxParallel = 2;
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ first }) =>
          first
            ? continueWith([
                { type: 'quick', title: 'q1', prompt: 'a' },
                { type: 'quick', title: 'q2', prompt: 'b' },
                { type: 'quick', title: 'q3', prompt: 'c' },
                { type: 'quick', title: 'q4', prompt: 'd' },
              ])
            : doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-2', 'four things', { cwd: '/repo' }));
    assert.equal(result.ok, true);

    const decision = rowsOf('sup-2', 'decision')[0];
    assert.equal((decision.payload.steps as unknown[]).length, 2);
    // goals + decision + 2 steps + done-decision + report = 6 calls
    assert.equal(calls.length, 6);
    const summary = rowsOf('sup-2', 'summary')[0];
    assert.match(String(summary.payload.text), /2\/2 steps completed/);
  });
});

test('supervised: done-gate forces a review when code ran without one', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ first }) =>
          first
            ? continueWith([{ type: 'code', title: 'Change code', prompt: 'edit files' }], 'implement')
            : doneDecision('looks done to me'),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-3', 'change code', { cwd: '/repo' }));
    assert.equal(result.ok, true);

    const decisions = rowsOf('sup-3', 'decision');
    // The first done was rejected by the review gate; the forced review ran,
    // then the second done was accepted.
    assert.equal(decisions.length, 3);
    assert.equal(decisions[1].payload.action, 'done');
    assert.equal(decisions[1].payload.gateOverride, 'review');
    const plan = rowsOf('sup-3', 'plan')[0];
    const stepTypes = (plan.payload.steps as Array<{ type: string }>).map((s) => s.type);
    assert.deepEqual(stepTypes, ['code', 'review']);
  });
});

test('supervised: done-gate forces a test step when the contract requires tests', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        goals: JSON.stringify({ goals: 'g', doneWhen: ['d'], requiresTests: true }),
        decide: ({ first }) =>
          first
            ? continueWith([
                { type: 'code', title: 'Change', prompt: 'edit' },
                { type: 'review', title: 'Review', prompt: 'check', dependsOn: ['step-1'] },
              ])
            : doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-4', 'change code with tests', { cwd: '/repo' }));
    assert.equal(result.ok, true);

    const decisions = rowsOf('sup-4', 'decision');
    assert.equal(decisions.length, 3);
    assert.equal(decisions[1].payload.gateOverride, 'test');
    const plan = rowsOf('sup-4', 'plan')[0];
    const stepTypes = (plan.payload.steps as Array<{ type: string }>).map((s) => s.type);
    assert.deepEqual(stepTypes, ['code', 'review', 'test']);
  });
});

test('supervised: two unproductive decisions end the run as partial', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: () => 'this is not json at all',
      }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-5', 'do work', { cwd: '/repo' }));
    assert.equal(result.ok, true);

    // goals + 2×(decision + repair) + report = 6 calls, no steps ran.
    assert.equal(calls.length, 6);
    const decisions = rowsOf('sup-5', 'decision');
    assert.equal(decisions.length, 2);
    assert.equal(decisions[0].payload.action, 'invalid');
    const summary = rowsOf('sup-5', 'summary')[0];
    assert.equal(summary.payload.outcome, 'partial');
  });
});

test('supervised: the iteration cap ends the run', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.execution.maxSupervisorIterations = 3;
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: () => continueWith([{ type: 'quick', title: 'bit', prompt: 'one small thing' }]),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-6', 'never ends', { cwd: '/repo' }));
    assert.equal(result.ok, true);

    const decisions = rowsOf('sup-6', 'decision');
    assert.equal(decisions.length, 3);
    const summary = rowsOf('sup-6', 'summary')[0];
    assert.equal(summary.payload.capped, true);
    assert.equal(summary.payload.iterations, 3);
  });
});

test('supervised: per-step checkpoint parks each decision for confirm', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.checkpoint = { mode: 'per-step', interval: 5 };
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ first }) =>
          first
            ? continueWith([{ type: 'quick', title: 'Step A', prompt: 'do a' }])
            : doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const first = await executor.run(orchestrateInput('sup-7', 'work', { cwd: '/repo' }));
    assert.equal(first.ok, true);
    // goals + decision parked — the step has NOT run yet.
    assert.equal(calls.length, 2);
    assert.equal(executor.hasPendingPlan('sup-7'), true);
    const parked = rowsOf('sup-7', 'decision')[0];
    assert.equal(parked.payload.awaitingConfirm, true);
    assert.equal((parked.payload.steps as unknown[]).length, 1);

    // Confirm with the proposed steps as-is.
    const second = await executor.confirm('sup-7', parked.payload.steps, { cwd: '/repo' });
    assert.equal(second.ok, true);
    // + step + done-decision + report.
    assert.equal(calls.length, 5);
    assert.equal(rowsOf('sup-7', 'decision')[0].payload.awaitingConfirm, false);
    const summary = rowsOf('sup-7', 'summary')[0];
    assert.equal(summary.payload.report, 'report body');
  });
});

test('supervised: every-n checkpoint parks once the completed count crosses N', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.checkpoint = { mode: 'every-n', interval: 1 };
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ first }) =>
          first
            ? continueWith([{ type: 'quick', title: 'Step A', prompt: 'do a' }])
            : doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    // doneCount starts at 0 → the first batch runs without parking.
    const first = await executor.run(orchestrateInput('sup-8', 'work', { cwd: '/repo' }));
    assert.equal(first.ok, true);
    // goals + decision + step + decision(done) + report — no park: after the
    // first batch the next decision is already done, no batch to gate.
    assert.equal(calls.length, 5);

    const summary = rowsOf('sup-8', 'summary')[0];
    assert.equal(summary.payload.report, 'report body');
  });
});

test('supervised: every-n checkpoint parks when more work follows N done steps', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.checkpoint = { mode: 'every-n', interval: 1 };
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ iteration }) =>
          iteration === 1
            ? continueWith([{ type: 'quick', title: 'Step A', prompt: 'do a' }])
            : iteration === 2
              ? continueWith([{ type: 'quick', title: 'Step B', prompt: 'do b', dependsOn: ['step-1'] }])
              : doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const first = await executor.run(orchestrateInput('sup-9', 'work', { cwd: '/repo' }));
    assert.equal(first.ok, true);
    // goals + dec1 + step1 + dec2 (parked: 1 done ≥ 1) — step B has not run.
    assert.equal(calls.length, 4);
    const decisions = rowsOf('sup-9', 'decision');
    assert.equal(decisions.length, 2);
    assert.equal(decisions[1].payload.awaitingConfirm, true);

    const second = await executor.confirm('sup-9', decisions[1].payload.steps, { cwd: '/repo' });
    assert.equal(second.ok, true);
    // + step B + dec3(done) + report.
    assert.equal(calls.length, 7);
    const plan = rowsOf('sup-9', 'plan')[0];
    assert.equal((plan.payload.steps as unknown[]).length, 2);
  });
});

test('supervised: requireConfirm parks on the goals card, confirm starts the loop', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.requireConfirm = true;
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: () => doneDecision('nothing needed'),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const first = await executor.run(orchestrateInput('sup-10', 'work', { cwd: '/repo' }));
    assert.equal(first.ok, true);
    // Only the goals call ran — the run is parked on the goals card.
    assert.equal(calls.length, 1);
    assert.equal(executor.hasPendingPlan('sup-10'), true);
    const plan = rowsOf('sup-10', 'plan')[0];
    assert.equal(plan.payload.awaitingConfirm, true);
    assert.equal(plan.payload.goals, 'g');

    const second = await executor.confirm('sup-10', [], { cwd: '/repo' });
    assert.equal(second.ok, true);
    // + decision(done) + report.
    assert.equal(calls.length, 3);
    assert.equal(rowsOf('sup-10', 'plan')[0].payload.awaitingConfirm, false);
  });
});

test('supervised: resume re-enters the loop on the rebuilt state', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: ({ first }) =>
          first
            ? continueWith([{ type: 'quick', title: 'Step A', prompt: 'do a' }])
            : doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    const first = await executor.run(orchestrateInput('sup-11', 'work', { cwd: '/repo' }));
    assert.equal(first.ok, true);
    assert.equal(calls.length, 5);

    // Resume on the completed supervised session re-enters the loop — the
    // supervisor sees the finished ledger and can decide done again.
    const resumed = await executor.resume('sup-11', { cwd: '/repo', prompt: 'double-check everything' });
    assert.equal(resumed.ok, true);
    // + decision(done) + report — the ledger is complete, nothing re-ran.
    assert.equal(calls.length, 7);
    const summaries = rowsOf('sup-11', 'summary');
    assert.equal(summaries.length, 2);
  });
});

test('supervised: lane routing — plan lane gets the smart candidate, report the cheap one', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')]),
      delegation: scriptedDelegation(calls, {
        decide: () => doneDecision(),
      }),
      resolveSessionCwd: () => '/repo',
    });

    await executor.run(orchestrateInput('sup-12', 'work', { cwd: '/repo' }));
    // goals + decision + report.
    assert.equal(calls.length, 3);
    // plan lane (default rules): oc-agy-* are opencode — unavailable in this
    // router — so the first viable devin candidate is swe-2-max.
    assert.equal(calls[0].model, 'swe-2-max');
    assert.equal(calls[1].model, 'swe-2-max');
    // report lane: first viable devin candidate is glm-5-3-flash-low.
    assert.equal(calls[2].model, 'glm-5-3-flash-low');
  });
});

test('supervised: parked decision survives an executor restart', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    config.planner.checkpoint = { mode: 'per-step', interval: 5 };
    const calls: LaneCall[] = [];
    const makeExecutor = () =>
      createOrchestratorExecutor({
        getConfig: () => config,
        router: makeRouter([devinAccount('active')]),
        delegation: scriptedDelegation(calls, {
          decide: ({ first }) =>
            first
              ? continueWith([{ type: 'quick', title: 'Step A', prompt: 'do a' }])
              : doneDecision(),
        }),
        resolveSessionCwd: () => '/repo',
      });

    const first = await makeExecutor().run(orchestrateInput('sup-13', 'work', { cwd: '/repo' }));
    assert.equal(first.ok, true);
    assert.equal(calls.length, 2); // goals + parked decision

    // A brand-new executor instance (post-restart) has no in-memory stash —
    // confirm rebuilds the supervised state from the transcript.
    const second = makeExecutor();
    assert.equal(second.hasPendingPlan('sup-13'), true);
    const result = await second.confirm('sup-13', rowsOf('sup-13', 'decision')[0].payload.steps, { cwd: '/repo' });
    assert.equal(result.ok, true);
    assert.equal(calls.length, 5); // + step + done-decision + report
    const summary = rowsOf('sup-13', 'summary')[0];
    assert.equal(summary.payload.report, 'report body');
  });
});

test('supervised: supervisor lane down degrades to the single-step path', async () => {
  await withIsolatedDatabase(async () => {
    const config = makeConfig();
    const calls: LaneCall[] = [];
    // Point the plan lane at an opencode-only candidate — with only the devin
    // runtime registered the supervisor lane cannot route at all.
    config.rules.plan = ['oc-zen-pickle'];
    const executor = createOrchestratorExecutor({
      getConfig: () => config,
      router: makeRouter([devinAccount('active')], ['devin'], config),
      delegation: scriptedDelegation(calls, { decide: () => doneDecision() }),
      resolveSessionCwd: () => '/repo',
    });

    const result = await executor.run(orchestrateInput('sup-14', 'work', { cwd: '/repo' }));
    assert.ok(result.ok === true || result.ok === false);
    const plan = rowsOf('sup-14', 'plan')[0];
    // No supervisor → the fallback plan row carries a single code step.
    assert.equal(plan.payload.source, 'supervisor-unavailable');
    assert.equal((plan.payload.steps as unknown[]).length, 1);
  });
});
