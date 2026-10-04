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
import { dispatchChatCommand, setSessionTitleGenerator } from '@/modules/websocket/services/chat-dispatch.service.js';
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
    // Never spawn a real provider run from the background titler in tests.
    setSessionTitleGenerator(async () => null);
    await runTest();
  } finally {
    setSessionTitleGenerator(null);
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

test('first visible text names a Flutter-created session and notifies the client', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('title-session', 'devin', '/workspace/demo', 'Untitled session');
    const connection = new FakeConnection();
    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'title-session',
      content: 'Napraw nadawanie tytułów sesji',
      options: {},
      userId: null,
      connection: connection as never,
    });
    assert.deepEqual(result, { ok: true });
    assert.equal(sessionsDb.getSessionById('title-session')?.custom_name, 'Napraw nadawanie tytułów sesji');
    const update = connection.frames.find((frame) => frame.kind === 'session_upserted');
    assert.equal((update?.session as Record<string, unknown>)?.summary, 'Napraw nadawanie tytułów sesji');
  });
});

test('background titler upgrades the derived name and broadcasts the result', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('title-session-2', 'devin', '/workspace/demo', 'Untitled session');
    const connection = new FakeConnection();
    const calls: Array<{ sessionId: string; content: string }> = [];
    setSessionTitleGenerator(async (input) => {
      calls.push({ sessionId: input.sessionId, content: input.content });
      return 'Refactor login flow';
    });

    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'title-session-2',
      content: 'please refactor the login flow',
      options: {},
      userId: null,
      connection: connection as never,
    });
    assert.deepEqual(result, { ok: true });

    // The titler is fire-and-forget; let its microtasks settle.
    await new Promise((resolve) => setImmediate(resolve));

    assert.deepEqual(calls, [{ sessionId: 'title-session-2', content: 'please refactor the login flow' }]);
    assert.equal(sessionsDb.getSessionById('title-session-2')?.custom_name, 'Refactor login flow');
    const frames = connection.frames.filter((frame) => frame.kind === 'session_upserted');
    assert.equal((frames.at(-1)?.session as Record<string, unknown>)?.summary, 'Refactor login flow');
  });
});

test('background titler never fires for a user-set name', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('title-session-3', 'devin', '/workspace/demo');
    sessionsDb.updateSessionCustomName('title-session-3', 'My custom title');
    let called = false;
    setSessionTitleGenerator(async () => {
      called = true;
      return 'Should never apply';
    });

    await dispatchChatCommand(noopRuntime, {
      sessionId: 'title-session-3',
      content: 'please refactor the login flow',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    await new Promise((resolve) => setImmediate(resolve));

    assert.equal(called, false);
    assert.equal(sessionsDb.getSessionById('title-session-3')?.custom_name, 'My custom title');
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

test('the first send records the permission mode on a fresh session', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-perm-1', 'opencode', '/workspace/demo');

    const result = await dispatchChatCommand(noopRuntime, {
      sessionId: 'app-perm-1',
      content: 'hello',
      options: { permissionMode: 'acceptEdits' },
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    assert.equal(sessionsDb.getSessionById('app-perm-1')?.permission_mode, 'acceptEdits');
  });
});

test('a pinned permission mode overrides the mode a stale send carries', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-perm-2', 'opencode', '/workspace/demo');
    sessionsDb.setSessionPermissionMode('app-perm-2', 'plan');

    let seenMode: unknown;
    const runtime = {
      ...noopRuntime,
      run: async (_p: unknown, _c: unknown, options: Record<string, unknown>) => {
        seenMode = options.permissionMode;
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'app-perm-2',
      content: 'hello',
      options: { permissionMode: 'default' },
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    assert.equal(seenMode, 'plan');
    assert.equal(sessionsDb.getSessionById('app-perm-2')?.permission_mode, 'plan');
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
    // Every re-publication of the row carries its stable id so the client can
    // update the one rendered card in place instead of stacking snapshots.
    assert.ok(contexts.every((context) => context.orchestratorRowId === row.id));
    assert.equal(contexts[1]?.lastEvent, 'partial one');
    assert.equal(contexts[2]?.lastEvent, 'cumulative answer');
    assert.equal(contexts[3]?.lastEvent, 'the final answer');
    assert.equal(contexts[4]?.status, 'done');
    assert.equal(contexts[4]?.finalText, 'the final answer');
    assert.ok(!contexts.some((context) => context.lastEvent === 'partial two'));

    // 3b) the parent session's own run writer received the same frames
    assert.equal(parentConnection.frames.length, 5);
    assert.equal((parentConnection.frames.at(-1)?.context as Record<string, unknown>)?.status, 'done');

    // 3c) every publication carries a unique non-empty id — the client dedupes
    // live frames by id, so successive patches to one delegation row must not
    // collide (id-less frames collapsed onto the first and hid every update).
    const ids = frames.map((frame) => frame.id);
    assert.ok(ids.every((id) => typeof id === 'string' && id.length > 0));
    assert.equal(new Set(ids).size, frames.length);
    // The writer copy and the broadcast copy of one publication share the id,
    // so client dedupe drops the duplicate delivery, never a real update.
    assert.deepEqual(
      parentConnection.frames.map((frame) => frame.id),
      ids,
    );
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
    assert.equal(watcher.frames.filter((frame) => frame.kind === 'status').length, 0);
  });
});

test('a client-supplied env is stripped before the provider runtime runs', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('env-session', 'claude', '/workspace/demo');

    let seenOptions: Record<string, unknown> | null = null;
    const runtime = {
      ...noopRuntime,
      run: async (_p: unknown, _c: unknown, options: Record<string, unknown>) => {
        seenOptions = options;
      },
    } as unknown as ProviderRuntimeGateway;

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'env-session',
      content: 'hi',
      // A hostile client must not be able to shape the provider child env.
      options: { env: { CLAUDE_CONFIG_DIR: '/tmp/attacker-controlled' }, model: 'sonnet' },
      userId: null,
      connection: new FakeConnection() as never,
    });

    assert.deepEqual(result, { ok: true });
    assert.ok(seenOptions);
    assert.equal((seenOptions as Record<string, unknown>).env, undefined);
  });
});

test('late child events and settlement cannot overwrite the next run in the parent transcript', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('parent-isolation', 'orchestrator', '/workspace/demo');
    sessionsDb.createAppSession('child-isolation', 'devin', '/workspace/demo');
    sessionsDb.markSharedContextInjected('child-isolation');
    const row = orchestratorMessagesDb.append('parent-isolation', 'delegation', {
      stepId: 'step', provider: 'devin', status: 'queued', childSessionId: 'child-isolation', title: 'Child',
    });
    const turns: Array<{ writer: { send(data: unknown): void }; resolve: () => void }> = [];
    const runtime: ProviderRuntimeGateway = {
      ...noopRuntime,
      run: (_p, _c, _o, writer) => new Promise<void>((resolve) => { turns.push({ writer, resolve }); }),
    };
    const input = { sessionId: 'child-isolation', content: 'work', options: {}, userId: null, connection: new FakeConnection() };
    const first = dispatchChatCommand(runtime, input);
    const old = chatRunRegistry.getRun(input.sessionId)!;
    chatRunRegistry.markAborted(input.sessionId);
    chatRunRegistry.completeRunIfCurrent(old, { exitCode: 0, aborted: true });
    const second = dispatchChatCommand(runtime, input);
    turns[1]!.writer.send({ kind: 'text', role: 'assistant', content: 'current answer' });
    const currentPayload = orchestratorMessagesDb.getById(row.id)!.payload;
    turns[0]!.writer.send({ kind: 'text', role: 'assistant', content: 'stale answer' });
    turns[0]!.resolve();
    await first;
    assert.deepEqual(orchestratorMessagesDb.getById(row.id)!.payload, currentPayload);
    assert.equal(currentPayload.status, 'running');
    assert.equal(chatRunRegistry.isProcessing(input.sessionId), true);
    turns[1]!.writer.send({ kind: 'complete', exitCode: 0 });
    turns[1]!.resolve();
    await second;
    assert.equal(orchestratorMessagesDb.getById(row.id)!.payload.status, 'done');
    assert.equal(orchestratorMessagesDb.getById(row.id)!.payload.finalText, 'current answer');
    assert.equal(chatRunRegistry.isProcessing(input.sessionId), false);
  });
});
