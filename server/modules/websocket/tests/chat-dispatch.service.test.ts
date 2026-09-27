import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  initializeDatabase,
  orchestratorMessagesDb,
  sessionsDb,
} from '@/modules/database/index.js';
import { dispatchChatCommand } from '@/modules/websocket/services/chat-dispatch.service.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import { connectedClients } from '@/modules/websocket/services/websocket-state.service.js';
import type { ProviderRuntimeGateway } from '@/modules/websocket/services/chat-dispatch.service.js';

class FakeConnection {
  readyState = 1; // WS_OPEN_STATE
  frames: Array<Record<string, unknown>> = [];

  send(data: string): void {
    this.frames.push(JSON.parse(data) as Record<string, unknown>);
  }
}

/** Runtime gateway that accepts every run and does nothing. */
const noopRuntime = {
  hasRuntime: () => true,
  run: async () => undefined,
  abort: async () => true,
  resolveToolApproval: () => undefined,
  getPendingApprovalsForSession: () => [],
} as unknown as ProviderRuntimeGateway;

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'chat-dispatch-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    connectedClients.clear();
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

test('a later turn never overwrites the model recorded for the session', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-dispatch-1', 'devin', '/workspace/demo');
    sessionsDb.setSessionModel('app-dispatch-1', 'deepseek-v4-1-flash-max');

    // The composer's model can lag behind the session (it resolves over HTTP
    // after a switch), so the send carries the per-provider default.
    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'app-dispatch-1',
      content: 'hello',
      options: { model: 'swe-2-max' },
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    assert.equal(sessionsDb.getSessionById('app-dispatch-1')?.model, 'deepseek-v4-1-flash-max');
  });
});

test('the first turn records the model and effort on a fresh session', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-dispatch-2', 'devin', '/workspace/demo');

    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'app-dispatch-2',
      content: 'hello',
      options: { model: 'deepseek-v4-1-flash-max', effort: 'high' },
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    const session = sessionsDb.getSessionById('app-dispatch-2');
    assert.equal(session?.model, 'deepseek-v4-1-flash-max');
    assert.equal(session?.effort, 'high');
  });
});

test('a replayed queue message cannot rewrite the session effort', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-dispatch-3', 'claude', '/workspace/demo');
    sessionsDb.setSessionModel('app-dispatch-3', 'opus');
    sessionsDb.setSessionEffort('app-dispatch-3', 'high');

    await dispatchChatCommand(noopRuntime, {
      sessionId: 'app-dispatch-3',
      content: 'queued while offline',
      options: { model: 'opus', effort: 'default' },
      userId: null,
      connection: new FakeConnection() as never,
    });

    const session = sessionsDb.getSessionById('app-dispatch-3');
    assert.equal(session?.model, 'opus');
    assert.equal(session?.effort, 'high');
  });
});

test('a send with no content and no attachments is refused without a run', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-dispatch-5', 'opencode', '/workspace/demo');

    let runtimeRuns = 0;
    const runtime = {
      ...noopRuntime,
      run: async () => {
        runtimeRuns++;
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'app-dispatch-5',
      content: '   ',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, {
      ok: false,
      code: 'EMPTY_MESSAGE',
      error: 'chat.send requires message content or at least one attachment.',
      sessionId: 'app-dispatch-5',
    });
    assert.equal(runtimeRuns, 0);
    assert.equal(chatRunRegistry.isProcessing('app-dispatch-5'), false);

    // Attachment-only sends stay valid — the prompt may be empty.
    const withFile = await dispatchChatCommand(runtime, {
      sessionId: 'app-dispatch-5',
      content: '',
      options: { files: [{ path: 'note.png' }] },
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(withFile, { ok: true });
    assert.equal(runtimeRuns, 1);
  });
});

test('a send to an archived session is refused instead of running invisibly', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-dispatch-4', 'devin', '/workspace/demo');
    sessionsDb.updateSessionIsArchived('app-dispatch-4', true);

    let runtimeRuns = 0;
    const runtime = {
      ...noopRuntime,
      run: async () => {
        runtimeRuns++;
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'app-dispatch-4',
      content: 'queued before archiving',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, {
      ok: false,
      code: 'SESSION_ARCHIVED',
      error: 'Session "app-dispatch-4" is archived. Restore it before sending.',
      sessionId: 'app-dispatch-4',
    });
    assert.equal(runtimeRuns, 0);
    assert.equal(chatRunRegistry.isProcessing('app-dispatch-4'), false);

    // Restored sessions accept sends again.
    sessionsDb.updateSessionIsArchived('app-dispatch-4', false);
    const restored = await dispatchChatCommand(runtime, {
      sessionId: 'app-dispatch-4',
      content: 'after restore',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(restored, { ok: true });
    assert.equal(runtimeRuns, 1);
  });
});

test('a child-session send mirrors running status, stream previews, and completion into the parent delegation row', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-1', 'orchestrator', '/workspace/demo');
    sessionsDb.createAppSession('orch-child-1', 'devin', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-1', 'delegation', {
      stepId: 'step-1',
      provider: 'devin',
      model: 'swe-2-medium',
      status: 'queued',
      childSessionId: 'orch-child-1',
      title: 'Step 1',
    });

    const broadcastWatcher = new FakeConnection();
    connectedClients.add(broadcastWatcher as never);

    const parentConnection = new FakeConnection();
    assert.ok(
      chatRunRegistry.startRun({
        appSessionId: 'orch-parent-1',
        provider: 'orchestrator' as never,
        providerSessionId: null,
        connection: parentConnection as never,
        userId: null,
      }),
    );

    const statusAtRunStart: unknown[] = [];
    const runtime = {
      ...noopRuntime,
      run: async (_p: unknown, _c: unknown, _o: unknown, writer: { send(data: unknown): void }) => {
        statusAtRunStart.push(orchestratorMessagesDb.getById(row.id)?.payload.status);
        writer.send({ kind: 'stream_delta', role: 'assistant', content: 'partial one' });
        writer.send({ kind: 'stream_delta', role: 'assistant', content: 'partial two' }); // throttled (<500ms after the first)
        writer.send({ kind: 'stream_replace', role: 'assistant', content: 'cumulative answer' });
        writer.send({ kind: 'text', role: 'assistant', content: 'the final answer' });
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'orch-child-1',
      content: 'carry on',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    // 1) status flipped to running before the provider run started
    assert.deepEqual(result, { ok: true });
    assert.deepEqual(statusAtRunStart, ['running']);

    // 2) streamed previews + completed answer landed in the parent row
    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'done');
    assert.equal(settled?.payload.lastEvent, 'the final answer');
    assert.equal(settled?.payload.finalText, 'the final answer');
    assert.equal(settled?.payload.stepId, 'step-1'); // untouched fields survive

    // 3) publishEntry mirror: every patch reached connected clients as a status frame
    const frames = broadcastWatcher.frames.filter((frame) => frame.kind === 'status');
    assert.equal(frames.length, 5); // running, delta, replace, text, done — the throttled delta never published
    assert.equal(frames[0]?.sessionId, 'orch-parent-1');
    const contexts = frames.map((frame) => frame.context as Record<string, unknown>);
    assert.equal(contexts[0]?.status, 'running');
    assert.equal(contexts[0]?.childSessionId, 'orch-child-1');
    assert.equal(contexts[0]?.orchestratorKind, 'delegation');
    assert.equal(contexts[1]?.lastEvent, 'partial one');
    assert.equal(contexts[2]?.lastEvent, 'cumulative answer');
    assert.equal(contexts[3]?.lastEvent, 'the final answer');
    assert.equal(contexts[4]?.status, 'done');
    assert.equal(contexts[4]?.finalText, 'the final answer');
    assert.ok(!contexts.some((context) => context.lastEvent === 'partial two'));

    // 3b) the parent session's own run writer received the same frames
    assert.equal(parentConnection.frames.length, 5);
    assert.equal((parentConnection.frames.at(-1)?.context as Record<string, unknown>)?.status, 'done');
  });
});

test('a failing child run settles the parent delegation row as failed with the error', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-2', 'orchestrator', '/workspace/demo');
    sessionsDb.createAppSession('orch-child-2', 'claude', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-2', 'delegation', {
      stepId: 'step-2',
      provider: 'claude',
      status: 'queued',
      childSessionId: 'orch-child-2',
    });

    const broadcastWatcher = new FakeConnection();
    connectedClients.add(broadcastWatcher as never);

    const runtime = {
      ...noopRuntime,
      run: async () => {
        throw new Error('provider crashed');
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'orch-child-2',
      content: 'go',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, {
      ok: false,
      code: 'RUNTIME_ERROR',
      error: 'provider crashed',
      sessionId: 'orch-child-2',
    });

    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'failed');
    assert.equal(settled?.payload.error, 'provider crashed');
    assert.equal(settled?.payload.finalText, '');

    const frames = broadcastWatcher.frames.filter((frame) => frame.kind === 'status');
    assert.equal(frames.length, 2); // running + failed
    const lastContext = frames.at(-1)?.context as Record<string, unknown>;
    assert.equal(lastContext?.status, 'failed');
    assert.equal(lastContext?.error, 'provider crashed');
    assert.equal(lastContext?.finalText, '');
  });
});

test('an aborted child run settles the parent delegation row as aborted', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-3', 'orchestrator', '/workspace/demo');
    sessionsDb.createAppSession('orch-child-3', 'devin', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-3', 'delegation', {
      stepId: 'step-3',
      provider: 'devin',
      status: 'queued',
      childSessionId: 'orch-child-3',
    });

    const broadcastWatcher = new FakeConnection();
    connectedClients.add(broadcastWatcher as never);

    const runtime = {
      ...noopRuntime,
      run: async () => {
        chatRunRegistry.markAborted('orch-child-3');
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'orch-child-3',
      content: 'stop after this',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });

    const settled = orchestratorMessagesDb.getById(row.id);
    assert.equal(settled?.payload.status, 'aborted');
    assert.equal(settled?.payload.finalText, '');

    const frames = broadcastWatcher.frames.filter((frame) => frame.kind === 'status');
    const lastContext = frames.at(-1)?.context as Record<string, unknown>;
    assert.equal(lastContext?.status, 'aborted');
  });
});

test('an independent reply without a parent run or clients still settles the delegation row cleanly', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('orch-parent-4', 'orchestrator', '/workspace/demo');
    sessionsDb.createAppSession('orch-child-4', 'codex', '/workspace/demo');
    const row = orchestratorMessagesDb.append('orch-parent-4', 'delegation', {
      stepId: 'step-4',
      provider: 'codex',
      status: 'queued',
      childSessionId: 'orch-child-4',
    });

    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'orch-child-4',
      content: 'hello',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    assert.equal(orchestratorMessagesDb.getById(row.id)?.payload.status, 'done');
  });
});

test('a send in a session without a delegation row publishes no status frames', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('plain-session', 'devin', '/workspace/demo');

    const watcher = new FakeConnection();
    connectedClients.add(watcher as never);

    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'plain-session',
      content: 'no delegation here',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    assert.equal(watcher.frames.length, 0);
  });
});
