import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, orchestratorMessagesDb } from '@/modules/database/index.js';
import { createOrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import { createOrchestratorMetricsService } from '@/modules/orchestrator/services/orchestrator-metrics.service.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'orchestrator-metrics-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(tempDirectory, 'auth.db');
  await initializeDatabase();
  try {
    await runTest();
  } finally {
    chatRunRegistry.clearAll();
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

test('metrics: aggregates per-candidate telemetry with a provider/model fallback key', async () => {
  await withIsolatedDatabase(() => {
    // cand-a: 2 done + 2 failed (the newer failure owns lastError).
    orchestratorMessagesDb.append('s1', 'delegation', {
      stepId: 'a1', candidateId: 'cand-a', provider: 'devin', model: 'swe-2-medium',
      status: 'done', durationMs: 100, finishedAt: '2026-01-01T00:00:10.000Z',
    });
    orchestratorMessagesDb.append('s1', 'delegation', {
      stepId: 'a2', candidateId: 'cand-a', provider: 'devin', model: 'swe-2-medium',
      status: 'failed', error: 'first failure', errorClass: 'rate_limit',
      durationMs: 300, finishedAt: '2026-01-02T00:00:10.000Z',
    });
    orchestratorMessagesDb.append('s1', 'delegation', {
      stepId: 'a3', candidateId: 'cand-a', provider: 'devin', model: 'swe-2-medium',
      status: 'done', durationMs: 200, finishedAt: '2026-01-03T00:00:10.000Z',
    });
    orchestratorMessagesDb.append('s1', 'delegation', {
      stepId: 'a4', candidateId: 'cand-a', provider: 'devin', model: 'swe-2-medium',
      status: 'failed', error: 'latest failure', errorClass: 'timeout',
      durationMs: 50, finishedAt: '2026-01-04T00:00:10.000Z',
    });
    // Non-terminal row: excluded from runs, still feeds lastUsedAt (createdAt).
    const runningRow = orchestratorMessagesDb.append('s1', 'delegation', {
      stepId: 'a5', candidateId: 'cand-a', provider: 'devin', model: 'swe-2-medium',
      status: 'running', startedAt: '2026-01-05T00:00:00.000Z',
    });
    // cand-b: a single aborted run — no done/failed, so successRate stays null.
    orchestratorMessagesDb.append('s1', 'delegation', {
      stepId: 'b1', candidateId: 'cand-b', provider: 'opencode', model: 'm-x',
      status: 'aborted', durationMs: 40, finishedAt: '2026-01-05T00:00:10.000Z',
    });
    // Legacy row without candidateId groups under `provider/model`.
    orchestratorMessagesDb.append('s2', 'delegation', {
      stepId: 'l1', provider: 'claude', model: 'sonnet-4',
      status: 'failed', error: 'quota exhausted', errorClass: 'quota',
      durationMs: 50, finishedAt: '2026-01-06T00:00:10.000Z',
    });
    // No candidateId and no provider/model — nothing to aggregate under.
    orchestratorMessagesDb.append('s1', 'delegation', { stepId: 'x', status: 'done' });
    // Non-delegation kinds never reach the aggregation.
    orchestratorMessagesDb.append('s1', 'summary', { text: 'done' });

    const metrics = createOrchestratorMetricsService({ messages: orchestratorMessagesDb });
    const snapshot = metrics.snapshot();

    assert.ok(snapshot.generatedAt);
    assert.deepEqual(
      snapshot.candidates.map((c) => c.candidateId),
      ['cand-a', 'cand-b', 'claude/sonnet-4'],
    );

    const byId = new Map(snapshot.candidates.map((c) => [c.candidateId, c]));
    const a = byId.get('cand-a');
    assert.equal(a?.provider, 'devin');
    assert.equal(a?.model, 'swe-2-medium');
    assert.equal(a?.runs, 4);
    assert.equal(a?.done, 2);
    assert.equal(a?.failed, 2);
    assert.equal(a?.aborted, 0);
    assert.equal(a?.successRate, 0.5);
    assert.equal(a?.avgDurationMs, 162.5);
    assert.equal(a?.totalDurationMs, 650);
    assert.equal(a?.lastError, 'latest failure');
    assert.deepEqual(a?.errorClasses, { rate_limit: 1, timeout: 1 });
    // lastUsedAt = max(finishedAt, running row's createdAt) — whichever wins.
    const expectedLastUsed = ['2026-01-04T00:00:10.000Z', runningRow.createdAt].sort().at(-1);
    assert.equal(a?.lastUsedAt, expectedLastUsed);

    const b = byId.get('cand-b');
    assert.equal(b?.runs, 1);
    assert.equal(b?.aborted, 1);
    assert.equal(b?.successRate, null);
    assert.equal(b?.avgDurationMs, 40);
    assert.equal(b?.lastError, null);
    assert.deepEqual(b?.errorClasses, {});
    assert.equal(b?.lastUsedAt, '2026-01-05T00:00:10.000Z');

    const legacy = byId.get('claude/sonnet-4');
    assert.equal(legacy?.provider, 'claude');
    assert.equal(legacy?.model, 'sonnet-4');
    assert.equal(legacy?.runs, 1);
    assert.equal(legacy?.failed, 1);
    assert.equal(legacy?.successRate, 0);
    assert.equal(legacy?.avgDurationMs, 50);
    assert.equal(legacy?.lastError, 'quota exhausted');
    assert.deepEqual(legacy?.errorClasses, { quota: 1 });
  });
});

test('delegation.run stamps startedAt/finishedAt/durationMs on the delegation row', async () => {
  await withIsolatedDatabase(async () => {
    const row = orchestratorMessagesDb.append('s', 'delegation', {
      stepId: 's1',
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'queued',
    });

    const runtime = {
      hasRuntime: () => true,
      run: async () => undefined,
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };
    const service = createOrchestratorDelegationService({ runtime: runtime as never });
    const handle = await service.run({
      parentSessionId: 's',
      delegationRowId: row.id,
      provider: 'devin',
      model: 'swe-2-medium',
      effort: null,
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });
    const outcome = await handle.completed;

    assert.equal(outcome.ok, true);
    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'done');
    assert.equal(typeof settled?.payload.startedAt, 'string');
    assert.equal(typeof settled?.payload.finishedAt, 'string');
    assert.equal(typeof settled?.payload.durationMs, 'number');
    assert.ok((settled?.payload.durationMs as number) >= 0);
  });
});
