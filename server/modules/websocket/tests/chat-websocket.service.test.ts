import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { handleChatConnection } from '@/modules/websocket/services/chat-websocket.service.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import { connectedClients } from '@/modules/websocket/services/websocket-state.service.js';
import type { LLMProvider, ProviderRuntimeWriter, AnyRecord } from '@/shared/index.js';

/** Minimal websocket stand-in: an event emitter that records outbound frames. */
class FakeSocket extends EventEmitter {
  readyState = 1; // WS_OPEN_STATE
  frames: Array<Record<string, unknown>> = [];

  send(data: string): void {
    this.frames.push(JSON.parse(data) as Record<string, unknown>);
  }
}

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'chat-websocket-'));
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

async function waitFor(predicate: () => boolean, timeoutMs = 2000): Promise<void> {
  const startedAt = Date.now();
  while (!predicate()) {
    if (Date.now() - startedAt > timeoutMs) {
      throw new Error('Timed out waiting for the expected websocket frame');
    }
    await new Promise((resolve) => setTimeout(resolve, 10));
  }
}

const memberRequest = { user: { id: 1, username: 'tester', role: 'owner' } };

for (const provider of ['claude', 'codex', 'cursor', 'opencode', 'commandcode', 'antigravity', 'devin'] satisfies LLMProvider[]) {
  for (const abortSucceeds of [true, false]) {
    test(`chat.abort: delayed ${provider} cancellation (${abortSucceeds}) leaves the resumed turn untouched`, async () => {
      await withIsolatedDatabase(async () => {
        const sessionId = `abort-race-${provider}`;
        sessionsDb.createAppSession(sessionId, provider, '/workspace/demo');
        const socket = new FakeSocket();
        const input = { appSessionId: sessionId, provider, providerSessionId: null, connection: socket as never, userId: null };
        const previousRun = chatRunRegistry.startRun(input);
        assert.ok(previousRun);
        let settleAbort!: (success: boolean) => void;
        let abortStarted = false;
        const runtime = {
          abort: () => {
            abortStarted = true;
            return new Promise<boolean>((resolve) => { settleAbort = resolve; });
          },
        };
        handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
        socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.abort', sessionId, runId: previousRun.id })));
        await waitFor(() => abortStarted);
        chatRunRegistry.completeRunIfCurrent(previousRun, { exitCode: 0 });
        const resumedRun = chatRunRegistry.startRun(input);
        assert.ok(resumedRun);
        settleAbort(abortSucceeds);
        // Drain the cancellation continuation before inspecting the new run.
        await new Promise((resolve) => setImmediate(resolve));
        assert.equal(chatRunRegistry.getRun(sessionId), resumedRun);
        assert.equal(resumedRun.status, 'running');
        assert.equal(resumedRun.aborted, undefined);
        assert.equal(socket.frames.filter((frame) => frame.kind === 'complete').length, 1);
        assert.equal(socket.frames.some((frame) => frame.kind === 'protocol_error'), false);
      });
    });
  }
}

test('chat.abort: a refused provider abort keeps the run alive and reports ABORT_FAILED', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-ws-abort-1', 'claude', '/workspace/demo');

    const socket = new FakeSocket();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-ws-abort-1',
      provider: 'claude',
      providerSessionId: null,
      connection: socket as never,
      userId: null,
    });
    assert.ok(run);

    // Claude's interrupt() threw — the runtime keeps streaming the run.
    let attempts = 0;
    const runtime = { abort: async () => { attempts += 1; return false; } };

    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.abort', sessionId: 'app-ws-abort-1', runId: run.id })));

    // The abort is retried for a few seconds before it is reported as failed.
    await waitFor(() => socket.frames.some((frame) => frame.kind === 'protocol_error'), 6000);

    const errors = socket.frames.filter((frame) => frame.kind === 'protocol_error');
    assert.equal(errors.length, 1);
    assert.equal(errors[0]?.code, 'ABORT_FAILED');
    assert.equal(errors[0]?.runActive, true);
    assert.ok(attempts > 1);
    // No terminal complete for a run that keeps streaming, and the aborted
    // flag is rolled back so the run's own end is not mislabeled.
    assert.equal(socket.frames.some((frame) => frame.kind === 'complete'), false);
    assert.equal(chatRunRegistry.isProcessing('app-ws-abort-1'), true);
    assert.notEqual(run.aborted, true);
  });
});

test('chat.abort: an abort that lands before the runtime handle exists is retried until it succeeds', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-ws-abort-early', 'devin', '/workspace/demo');
    const socket = new FakeSocket();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-ws-abort-early', provider: 'devin', providerSessionId: null, connection: socket as never, userId: null,
    });
    assert.ok(run);
    // No process handle on the first attempt; it appears for the second.
    let attempts = 0;
    const runtime = { abort: async () => { attempts += 1; return attempts > 1; } };

    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.abort', sessionId: 'app-ws-abort-early', runId: run.id })));

    await waitFor(() => socket.frames.some((frame) => frame.kind === 'complete'));
    assert.equal(attempts, 2);
    assert.equal(socket.frames.find((frame) => frame.kind === 'complete')?.aborted, true);
    assert.equal(socket.frames.some((frame) => frame.kind === 'protocol_error'), false);
  });
});

test('protocol errors name the frame\'s session (and requestId) so clients can route them', async () => {
  await withIsolatedDatabase(async () => {
    const socket = new FakeSocket();
    const viewerRequest = { user: { id: 2, username: 'viewer', role: 'viewer' } };
    handleChatConnection(socket as never, viewerRequest as never, { runtime: {} } as never);
    socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.nope', sessionId: 's-unknown' })));
    socket.emit('message', Buffer.from(JSON.stringify({
      type: 'chat.permission-response', sessionId: 's-perm', requestId: 'req-1', allow: true, rememberEntry: 'Bash(*)',
    })));
    await waitFor(() => socket.frames.filter((frame) => frame.kind === 'protocol_error').length === 2);
    const [unknown, forbidden] = socket.frames;
    assert.equal(unknown?.code, 'UNKNOWN_MESSAGE_TYPE');
    assert.equal(unknown?.sessionId, 's-unknown');
    assert.equal(unknown?.runActive, false);
    assert.equal(forbidden?.code, 'FORBIDDEN_ROLE');
    assert.equal(forbidden?.sessionId, 's-perm');
    assert.equal(forbidden?.requestId, 'req-1');
  });
});

test('a chat.send that throws reports INTERNAL_ERROR with its sessionId', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-ws-throw', 'claude', '/workspace/demo');
    sessionsDb.markSharedContextInjected('app-ws-throw');
    const socket = new FakeSocket();
    const runtime = { hasRuntime: () => { throw new Error('boom'); } };
    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.send', sessionId: 'app-ws-throw', content: 'hi' })));
    await waitFor(() => socket.frames.some((frame) => frame.kind === 'protocol_error'));
    const error = socket.frames.find((frame) => frame.kind === 'protocol_error');
    assert.equal(error?.code, 'INTERNAL_ERROR');
    assert.equal(error?.sessionId, 'app-ws-throw');
  });
});

test('chat_subscribed reports the latest background task count', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-ws-bg', 'claude', '/workspace/demo');
    const socket = new FakeSocket();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-ws-bg', provider: 'claude', providerSessionId: null, connection: socket as never, userId: null,
    })!;
    run.writer.send({ kind: 'complete', exitCode: 0, provider: 'claude' });
    run.writer.send({ kind: 'background_tasks', count: 2, provider: 'claude' });
    const runtime = { getPendingApprovalsForSession: () => [] };
    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    const subscribe = () => socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.subscribe', sessions: [{ sessionId: 'app-ws-bg' }] })));
    subscribe();
    await waitFor(() => socket.frames.at(-1)?.kind === 'chat_subscribed');
    assert.equal(socket.frames.at(-1)?.backgroundTasks, 2);
    run.writer.send({ kind: 'background_tasks', count: 0, provider: 'claude' });
    subscribe();
    await waitFor(() => socket.frames.at(-1)?.kind === 'chat_subscribed');
    assert.equal(socket.frames.at(-1)?.backgroundTasks, 0);
  });
});

test('chat.abort: a successful provider abort completes the run as aborted', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-ws-abort-2', 'claude', '/workspace/demo');

    const socket = new FakeSocket();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-ws-abort-2',
      provider: 'claude',
      providerSessionId: null,
      connection: socket as never,
      userId: null,
    });
    assert.ok(run);

    const runtime = { abort: async () => true };

    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.abort', sessionId: 'app-ws-abort-2', runId: run.id })));

    await waitFor(() => socket.frames.some((frame) => frame.kind === 'complete'));

    const completes = socket.frames.filter((frame) => frame.kind === 'complete');
    assert.equal(completes.length, 1);
    assert.equal(completes[0]?.aborted, true);
    assert.equal(completes[0]?.exitCode, 0);
    assert.equal(chatRunRegistry.isProcessing('app-ws-abort-2'), false);
  });
});

test('chat.set-permission-mode pins the mode on the session row and pushes it to the runtime', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-perm-ws-1', 'opencode', '/workspace/demo');

    const socket = new FakeSocket();
    let pushedMode: string | null = null;
    const runtime = {
      setSessionPermissionMode: (_provider: unknown, _sessionId: string, mode: string) => {
        pushedMode = mode;
      },
    };

    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({
      type: 'chat.set-permission-mode',
      sessionId: 'app-perm-ws-1',
      permissionMode: 'bypassPermissions',
    })));
    await new Promise((resolve) => setImmediate(resolve));

    assert.equal(sessionsDb.getSessionById('app-perm-ws-1')?.permission_mode, 'bypassPermissions');
    assert.equal(pushedMode, 'bypassPermissions');
  });
});

test('chat.set-permission-mode rejects viewers without touching the session row', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('app-perm-ws-2', 'opencode', '/workspace/demo');

    const socket = new FakeSocket();
    let pushedMode: string | null = null;
    const runtime = {
      setSessionPermissionMode: (_provider: unknown, _sessionId: string, mode: string) => {
        pushedMode = mode;
      },
    };
    const viewerRequest = { user: { id: 2, username: 'viewer', role: 'viewer' } };

    handleChatConnection(socket as never, viewerRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({
      type: 'chat.set-permission-mode',
      sessionId: 'app-perm-ws-2',
      permissionMode: 'bypassPermissions',
    })));

    await waitFor(() => socket.frames.some((frame) => frame.kind === 'protocol_error'));
    assert.equal(pushedMode, null);
    assert.equal(sessionsDb.getSessionById('app-perm-ws-2')?.permission_mode, null);
  });
});

for (const runId of [undefined, '', 123, 'previous-run']) {
  test(`chat.abort: missing or stale runId (${runId}) cannot cancel the current turn`, async () => {
    await withIsolatedDatabase(async () => {
      const sessionId = 'abort-stale';
      sessionsDb.createAppSession(sessionId, 'claude', '/workspace/demo');
      const socket = new FakeSocket();
      const run = chatRunRegistry.startRun({ appSessionId: sessionId, provider: 'claude', providerSessionId: null, connection: socket as never, userId: null });
      assert.ok(run);
      let called = false;
      const runtime = { abort: async () => { called = true; return true; } };
      handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
      socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.abort', sessionId, runId })));
      await waitFor(() => socket.frames.some((frame) => frame.kind === 'protocol_error'));
      assert.equal(called, false);
      assert.equal(run.status, 'running');
      assert.equal(run.aborted, undefined);
      assert.equal(socket.frames.some((frame) => frame.kind === 'complete'), false);
    });
  });
}

/** Controls provider timing while exercising the real dispatcher, registry and database. */
function controlledRuntime() {
  const turns: Array<{ writer: ProviderRuntimeWriter; resolve: () => void; reject: (error: Error) => void }> = [];
  return {
    turns,
    hasRuntime: () => true,
    getPendingApprovalsForSession: () => [],
    resolveToolApproval: () => {},
    abort: async () => true,
    run: (_provider: LLMProvider, _content: string, _options: AnyRecord, writer: ProviderRuntimeWriter) =>
      new Promise<void>((resolve, reject) => { turns.push({ writer, resolve, reject }); }),
  };
}

for (const provider of ['claude', 'codex', 'cursor', 'opencode', 'commandcode', 'antigravity', 'devin'] satisfies LLMProvider[]) {
  test(`${provider}: five Stop/send cycles isolate late fragments and runtime settlement`, async () => {
    await withIsolatedDatabase(async () => {
      const sessionId = `cycles-${provider}`;
      sessionsDb.createAppSession(sessionId, provider, '/workspace/demo');
      sessionsDb.markSharedContextInjected(sessionId);
      const socket = new FakeSocket();
      const runtime = controlledRuntime();
      handleChatConnection(socket as never, memberRequest as never, { runtime });
      const send = (frame: AnyRecord) => socket.emit('message', Buffer.from(JSON.stringify(frame)));
      send({ type: 'chat.send', sessionId, content: 'first' });
      await waitFor(() => runtime.turns.length === 1);
      for (let cycle = 0; cycle < 5; cycle += 1) {
        const old = chatRunRegistry.getRun(sessionId)!;
        // Obtain runId through the existing subscribe ack even before any delta.
        send({ type: 'chat.subscribe', sessions: [{ sessionId }] });
        assert.equal(socket.frames.at(-1)?.runId, old.id);
        const oldTurn = runtime.turns[cycle]!;
        if (cycle % 2) oldTurn.writer.send({ kind: 'stream_delta', content: 'partial', provider });
        send({ type: 'chat.abort', sessionId, runId: old.id });
        await waitFor(() => old.status === 'completed');
        const terminal = socket.frames.filter((f) => f.runId === old.id && f.kind === 'complete');
        assert.equal(terminal.length, 1);
        assert.equal(terminal[0]?.aborted, true);
        assert.equal(terminal[0]?.exitCode, 0);
        send({ type: 'chat.send', sessionId, content: `next-${cycle}` });
        await waitFor(() => runtime.turns.length === cycle + 2);
        const current = chatRunRegistry.getRun(sessionId)!;
        assert.notEqual(current.id, old.id);
        const countBeforeLate = socket.frames.length;
        oldTurn.writer.send({ kind: 'stream_delta', content: 'LATE', provider });
        oldTurn.writer.send({ kind: 'text', content: 'LATE FINAL', provider });
        oldTurn.writer.send({ kind: 'error', content: 'LATE ERROR', provider });
        oldTurn.writer.send({ kind: 'complete', exitCode: 1, provider });
        if (cycle % 2) oldTurn.resolve();
        else oldTurn.reject(new Error('cancelled runtime settled late'));
        await new Promise((resolve) => setImmediate(resolve));
        assert.equal(socket.frames.length, countBeforeLate);
        assert.equal(current.status, 'running');
        const writer = runtime.turns[cycle + 1]!.writer;
        const chunks = ['Zażółć ', 'gęślą ', `jaźń ${cycle}.`];
        for (const content of chunks) writer.send({ kind: 'stream_delta', content, provider });
        const received = socket.frames.filter((f) => f.runId === current.id && f.kind === 'stream_delta');
        assert.deepEqual(received.map((f) => f.content), chunks);
        assert.equal(received.map((f) => f.content).join(''), chunks.join(''));
        assert.deepEqual(received.map((f) => f.seq), [1, 2, 3]);
      }
      const finalRun = chatRunRegistry.getRun(sessionId)!;
      runtime.turns.at(-1)!.writer.send({ kind: 'stream_end', provider });
      runtime.turns.at(-1)!.writer.send({ kind: 'complete', exitCode: 0, provider });
      runtime.turns.at(-1)!.resolve();
      await new Promise((resolve) => setImmediate(resolve));
      assert.equal(socket.frames.filter((f) => f.kind === 'complete').length, 6);
      assert.equal(socket.frames.some((f) => f.kind === 'protocol_error'), false);
      assert.equal(chatRunRegistry.isProcessing(sessionId), false);
      send({ type: 'chat.subscribe', sessions: [{ sessionId, runId: finalRun.id, lastSeq: finalRun.lastSeq }] });
      assert.equal(socket.frames.at(-1)?.isProcessing, false);
      socket.emit('close');
    });
  });
}

test('after retention and reconnect, a new turn and missed fragments reach the current socket exactly once', async (t) => {
  await withIsolatedDatabase(async () => {
    const sessionId = 'idle-reconnect';
    sessionsDb.createAppSession(sessionId, 'devin', '/workspace/demo');
    sessionsDb.markSharedContextInjected(sessionId);
    const runtime = controlledRuntime();
    const first = new FakeSocket();
    handleChatConnection(first as never, memberRequest as never, { runtime });
    first.emit('message', Buffer.from(JSON.stringify({ type: 'chat.send', sessionId, content: 'first' })));
    await waitFor(() => runtime.turns.length === 1);
    const old = chatRunRegistry.getRun(sessionId)!;
    t.mock.timers.enable({ apis: ['setTimeout'] });
    runtime.turns[0]!.writer.send({ kind: 'complete', exitCode: 0, provider: 'devin' });
    runtime.turns[0]!.resolve();
    t.mock.timers.tick(5 * 60 * 1000 + 1);
    t.mock.timers.reset();
    assert.equal(chatRunRegistry.getRun(sessionId), undefined);
    first.readyState = 3;
    first.emit('close');
    const firstCount = first.frames.length;
    const second = new FakeSocket();
    handleChatConnection(second as never, memberRequest as never, { runtime });
    second.emit('message', Buffer.from(JSON.stringify({ type: 'chat.subscribe', sessions: [{ sessionId, runId: old.id, lastSeq: old.lastSeq }] })));
    assert.equal(second.frames.at(-1)?.isProcessing, false);
    assert.equal(second.frames.at(-1)?.runId, null);
    assert.equal(second.frames.at(-1)?.lastSeq, 0);
    second.emit('message', Buffer.from(JSON.stringify({ type: 'chat.send', sessionId, content: 'after idle' })));
    await waitFor(() => runtime.turns.length === 2);
    const current = chatRunRegistry.getRun(sessionId)!;
    const writer = runtime.turns[1]!.writer;
    writer.send({ kind: 'stream_delta', content: 'one ', provider: 'devin' });
    const cursor = current.lastSeq;
    second.readyState = 3;
    second.emit('close');
    writer.send({ kind: 'stream_delta', content: 'two ', provider: 'devin' });
    writer.send({ kind: 'stream_delta', content: 'three ', provider: 'devin' });
    const third = new FakeSocket();
    handleChatConnection(third as never, memberRequest as never, { runtime });
    third.emit('message', Buffer.from(JSON.stringify({ type: 'chat.subscribe', sessions: [{ sessionId, runId: current.id, lastSeq: cursor }] })));
    assert.equal(third.frames[0]?.kind, 'chat_subscribed');
    writer.send({ kind: 'stream_delta', content: 'four', provider: 'devin' });
    writer.send({ kind: 'complete', exitCode: 0, provider: 'devin' });
    runtime.turns[1]!.resolve();
    await new Promise((resolve) => setImmediate(resolve));
    const deltas = [...second.frames, ...third.frames].filter((f) => f.kind === 'stream_delta');
    assert.deepEqual(deltas.map((f) => f.content), ['one ', 'two ', 'three ', 'four']);
    assert.deepEqual(deltas.map((f) => f.seq), [1, 2, 3, 4]);
    assert.ok(deltas.every((f) => f.runId === current.id));
    assert.equal(first.frames.length, firstCount);
    assert.equal(third.frames.filter((f) => f.kind === 'complete').length, 1);
    assert.equal(chatRunRegistry.isProcessing(sessionId), false);
    third.emit('close');
  });
});
