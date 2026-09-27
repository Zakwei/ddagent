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
