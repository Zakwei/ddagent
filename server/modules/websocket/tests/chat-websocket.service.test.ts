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
import type { LLMProvider } from '@/shared/index.js';

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
    const runtime = { abort: async () => false };

    handleChatConnection(socket as never, memberRequest as never, { runtime } as never);
    socket.emit('message', Buffer.from(JSON.stringify({ type: 'chat.abort', sessionId: 'app-ws-abort-1', runId: run.id })));

    await waitFor(() => socket.frames.some((frame) => frame.kind === 'protocol_error'));

    const errors = socket.frames.filter((frame) => frame.kind === 'protocol_error');
    assert.equal(errors.length, 1);
    assert.equal(errors[0]?.code, 'ABORT_FAILED');
    // No terminal complete for a run that keeps streaming, and the aborted
    // flag is rolled back so the run's own end is not mislabeled.
    assert.equal(socket.frames.some((frame) => frame.kind === 'complete'), false);
    assert.equal(chatRunRegistry.isProcessing('app-ws-abort-1'), true);
    assert.notEqual(run.aborted, true);
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
