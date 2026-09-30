import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, orchestratorMessagesDb, sessionsDb } from '@/modules/database/index.js';
import { createOrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import type { OrchestratorMessage } from '@/shared/types.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'orchestrator-delegation-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
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

test('delegation.run mirrors running status, stream previews, and finalText, notifying publish with each updated row', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-del-1', 'orchestrator', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-del-1', 'delegation', {
      stepId: 'step-1',
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'queued',
      title: 'Step 1',
    });

    const published: Array<{ parentSessionId: string; rowId: number; entry: OrchestratorMessage | null }> = [];
    const payloadAtRunStart: unknown[] = [];
    const runtime = {
      hasRuntime: () => true,
      run: async (_p: unknown, _c: unknown, _o: unknown, writer: { send(data: unknown): void }) => {
        payloadAtRunStart.push(orchestratorMessagesDb.getById(row.id)?.payload);
        writer.send({ kind: 'stream_delta', role: 'assistant', content: 'partial answer' });
        writer.send({ kind: 'stream_replace', role: 'assistant', content: 'cumulative answer' });
        writer.send({ kind: 'text', role: 'assistant', content: 'the final answer' });
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };

    const service = createOrchestratorDelegationService({
      runtime: runtime as never,
      onDelegationUpdate: (parentSessionId, rowId) => {
        published.push({ parentSessionId, rowId, entry: orchestratorMessagesDb.getById(rowId) });
      },
    });

    const handle = await service.run({
      parentSessionId: 'orch-parent-del-1',
      delegationRowId: row.id,
      provider: 'devin',
      model: 'swe-2-medium',
      effort: 'medium',
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });
    const outcome = await handle.completed;

    // 1) running status + child session linked before the provider run started
    const atStart = payloadAtRunStart[0] as Record<string, unknown>;
    assert.equal(atStart.status, 'running');
    assert.equal(atStart.childSessionId, handle.childSessionId);

    // 2) streamed previews + completed answer mirrored into the row
    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'done');
    assert.equal(settled?.payload.lastEvent, 'the final answer');
    assert.equal(settled?.payload.finalText, 'the final answer');
    assert.equal(settled?.payload.childSessionId, handle.childSessionId);
    assert.equal(settled?.payload.stepId, 'step-1');
    assert.deepEqual(outcome, { ok: true, error: null, finalText: 'the final answer', aborted: false });
    assert.equal(sessionsDb.getSessionById(handle.childSessionId)?.provider, 'devin');
    assert.equal(sessionsDb.getSessionById(handle.childSessionId)?.model, 'swe-2-medium');

    // 3) publish hook got every updated row (running, delta, replace, text, done)
    assert.equal(published.length, 5);
    assert.ok(published.every((p) => p.parentSessionId === 'orch-parent-del-1' && p.rowId === row.id));
    assert.equal(published[0]?.entry?.payload.status, 'running');
    assert.equal(published[0]?.entry?.payload.childSessionId, handle.childSessionId);
    assert.ok(published.some((p) => p.entry?.payload.lastEvent === 'partial answer'));
    const finalPublished = published.at(-1);
    assert.equal(finalPublished?.entry?.payload.status, 'done');
    assert.equal(finalPublished?.entry?.payload.finalText, 'the final answer');
  });
});

test('a failing delegated run settles the row as failed and keeps the error', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-del-2', 'orchestrator', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-del-2', 'delegation', {
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'queued',
      stepId: 'step-2',
    });

    const published: Array<{ parentSessionId: string; rowId: number; entry: OrchestratorMessage | null }> = [];
    const runtime = {
      hasRuntime: () => true,
      run: async () => {
        throw new Error('boom');
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };

    const service = createOrchestratorDelegationService({
      runtime: runtime as never,
      onDelegationUpdate: (parentSessionId, rowId) => {
        published.push({ parentSessionId, rowId, entry: orchestratorMessagesDb.getById(rowId) });
      },
    });

    const handle = await service.run({
      parentSessionId: 'orch-parent-del-2',
      delegationRowId: row.id,
      provider: 'devin',
      model: 'swe-2-medium',
      effort: 'medium',
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });
    const outcome = await handle.completed;

    assert.deepEqual(outcome, { ok: false, error: 'boom', finalText: '', aborted: false });

    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'failed');
    assert.equal(settled?.payload.error, 'boom');
    assert.equal(settled?.payload.finalText, '');

    assert.equal(published.length, 2);
    const finalPublished = published.at(-1);
    assert.equal(finalPublished?.entry?.payload.status, 'failed');
    assert.equal(finalPublished?.entry?.payload.error, 'boom');
  });
});

test('a provider-synthesized error reply settles the row as failed, not done', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-del-3', 'orchestrator', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-del-3', 'delegation', {
      provider: 'opencode',
      model: 'google/antigravity-claude-sonnet-4-6-thinking',
      status: 'queued',
      stepId: 'step-3',
    });

    // The antigravity-auth plugin answers an exhausted account pool with a
    // fake HTTP-200 SSE body — the runtime reports a clean turn whose whole
    // reply is the error sentence.
    const syntheticText =
      'All 2 account(s) rate-limited for claude. Quota resets in 144h 27m. ' +
      'Add more accounts with `opencode auth login` or wait and retry.';
    const runtime = {
      hasRuntime: () => true,
      run: async (_p: unknown, _c: unknown, _o: unknown, writer: { send(data: unknown): void }) => {
        writer.send({ kind: 'text', role: 'assistant', content: syntheticText });
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };

    const service = createOrchestratorDelegationService({ runtime: runtime as never });
    const handle = await service.run({
      parentSessionId: 'orch-parent-del-3',
      delegationRowId: row.id,
      provider: 'opencode',
      model: 'google/antigravity-claude-sonnet-4-6-thinking',
      effort: null,
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });
    const outcome = await handle.completed;

    assert.equal(outcome.ok, false);
    assert.equal(outcome.error, syntheticText);
    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'failed');
    assert.equal(settled?.payload.error, syntheticText);
  });
});

test('a quota failure reported as an error event (no answer) settles the row as failed, not done', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-del-5', 'orchestrator', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-del-5', 'delegation', {
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'queued',
      stepId: 'step-5',
    });

    // Devin reports an exhausted quota as an `error` event and then resolves
    // its run promise cleanly with no assistant text — the failure lives only
    // in the event, so the delegation row must still settle failed.
    const quotaError =
      'Your weekly usage quota has been exhausted. Visit https://app.devin.ai/settings/usage to purchase on-demand usage or turn on auto-reload. (trace ID: 792031252e5a765ce20806468655ed20)';
    const runtime = {
      hasRuntime: () => true,
      run: async (_p: unknown, _c: unknown, _o: unknown, writer: { send(data: unknown): void }) => {
        writer.send({ kind: 'error', role: 'assistant', content: quotaError });
        writer.send({ kind: 'complete', role: 'assistant', exitCode: 1 });
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };

    const service = createOrchestratorDelegationService({ runtime: runtime as never });
    const handle = await service.run({
      parentSessionId: 'orch-parent-del-5',
      delegationRowId: row.id,
      provider: 'devin',
      model: 'swe-2-medium',
      effort: 'medium',
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });
    const outcome = await handle.completed;

    assert.equal(outcome.ok, false);
    assert.equal(outcome.error, quotaError);
    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'failed');
    assert.equal(settled?.payload.error, quotaError);
  });
});

test('a genuine reply that merely mentions rate limits stays a success', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-del-4', 'orchestrator', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-del-4', 'delegation', {
      provider: 'opencode',
      model: 'google/antigravity-claude-sonnet-4-6-thinking',
      status: 'queued',
      stepId: 'step-4',
    });

    // Starts with the trigger phrase but is a full-length answer — the
    // synthetic check's size cap keeps it classified as real output.
    const longAnswer = `All 2 account(s) rate-limited for claude is the error to reproduce. ${'x'.repeat(900)}`;
    const runtime = {
      hasRuntime: () => true,
      run: async (_p: unknown, _c: unknown, _o: unknown, writer: { send(data: unknown): void }) => {
        writer.send({ kind: 'text', role: 'assistant', content: longAnswer });
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    };

    const service = createOrchestratorDelegationService({ runtime: runtime as never });
    const handle = await service.run({
      parentSessionId: 'orch-parent-del-4',
      delegationRowId: row.id,
      provider: 'opencode',
      model: 'google/antigravity-claude-sonnet-4-6-thinking',
      effort: null,
      accountId: null,
      cwd: '/workspace/demo',
      command: 'do the thing',
      permissionMode: 'default',
    });
    const outcome = await handle.completed;

    assert.equal(outcome.ok, true);
    assert.equal(orchestratorMessagesDb.getById(row.id)?.payload.status, 'done');
  });
});
