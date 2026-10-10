import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionEventsDb, sessionsDb } from '@/modules/database/index.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import { connectedClients } from '@/modules/websocket/services/websocket-state.service.js';

/**
 * Minimal stand-in for a websocket connection: collects every JSON frame the
 * gateway writer forwards so assertions can inspect the outbound protocol.
 */
class FakeConnection {
  readyState = 1; // WS_OPEN_STATE
  frames: Array<Record<string, unknown>> = [];

  send(data: string): void {
    this.frames.push(JSON.parse(data) as Record<string, unknown>);
  }
}

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'chat-run-registry-'));
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

test('live events are remapped to the app session id and sequenced', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-1', 'claude', '/workspace/demo');
    const connection = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-1',
      provider: 'claude',
      providerSessionId: null,
      connection,
      userId: 'user-1',
    });
    assert.ok(run);

    run.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'provider-id-9', content: 'hello' });
    run.writer.send({ kind: 'text', provider: 'claude', sessionId: 'provider-id-9', content: 'hello world' });

    assert.equal(connection.frames.length, 2);
    assert.equal(connection.frames[0]?.sessionId, 'app-run-1');
    assert.equal(connection.frames[0]?.seq, 1);
    assert.equal(connection.frames[1]?.sessionId, 'app-run-1');
    assert.equal(connection.frames[1]?.seq, 2);
  });
});

test('session_created is swallowed and persisted as the provider-id mapping', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-2', 'cursor', '/workspace/demo');
    const connection = new FakeConnection();
    connectedClients.add(connection as never);
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-2',
      provider: 'cursor',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(run);

    run.writer.send({
      kind: 'session_created',
      provider: 'cursor',
      sessionId: 'cursor-native-7',
      newSessionId: 'cursor-native-7',
    });

    // The provider-native event itself is never forwarded...
    const sessionUpserts = connection.frames.filter((frame) => frame.kind === 'session_upserted');
    assert.equal(sessionUpserts.length, 1);
    assert.equal(sessionUpserts[0]?.sessionId, 'app-run-2');
    assert.equal(sessionUpserts[0]?.providerSessionId, 'cursor-native-7');
    // ...but the canonical mapping is recorded and persisted in the database.
    assert.equal(run.providerSessionId, 'cursor-native-7');
    assert.equal(sessionsDb.getSessionById('app-run-2')?.provider_session_id, 'cursor-native-7');
  });
});

test('turn_finished_at is stamped on complete and cleared when the next run starts', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-turn', 'claude', '/workspace/demo');
    const startRun = () => chatRunRegistry.startRun({
      appSessionId: 'app-run-turn',
      provider: 'claude',
      providerSessionId: null,
      connection: new FakeConnection(),
      userId: null,
    });
    const turnFinishedAt = () => sessionsDb.getSessionById('app-run-turn')?.turn_finished_at ?? null;

    const first = startRun();
    assert.ok(first);
    assert.equal(turnFinishedAt(), null);

    first.writer.send({ kind: 'complete', provider: 'claude', sessionId: 'app-run-turn', exitCode: 0 });
    assert.ok(turnFinishedAt());

    assert.ok(startRun());
    assert.equal(turnFinishedAt(), null);
  });
});

test('complete marks the run finished and duplicate completes are dropped', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-3', 'codex', '/workspace/demo');
    const connection = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-3',
      provider: 'codex',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(run);

    run.writer.send({ kind: 'complete', provider: 'codex', sessionId: 'native-3', exitCode: 0 });
    // Late duplicate from a killed runtime's exit handler.
    run.writer.send({ kind: 'complete', provider: 'codex', sessionId: 'native-3', exitCode: 1 });

    const completes = connection.frames.filter((frame) => frame.kind === 'complete');
    assert.equal(completes.length, 1);
    assert.equal(completes[0]?.actualSessionId, 'app-run-3');
    assert.equal(chatRunRegistry.isProcessing('app-run-3'), false);

    // completeRun is also a no-op once the run already completed.
    chatRunRegistry.completeRun('app-run-3', { exitCode: 1 });
    assert.equal(connection.frames.filter((frame) => frame.kind === 'complete').length, 1);
  });
});

test('a finished run\'s safety net cannot complete the session\'s next run', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-9', 'codex', '/workspace/demo');
    const connection = new FakeConnection();

    const firstRun = chatRunRegistry.startRun({
      appSessionId: 'app-run-9',
      provider: 'codex',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(firstRun);
    firstRun.writer.send({ kind: 'complete', provider: 'codex', sessionId: 'native-9', exitCode: 0 });

    // A queued message starts the next run before the first run's runtime
    // promise settles (the chat handler's `finally` hasn't executed yet).
    const secondRun = chatRunRegistry.startRun({
      appSessionId: 'app-run-9',
      provider: 'codex',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(secondRun);

    // First run's safety net fires late: it must not touch the new run.
    chatRunRegistry.completeRunIfCurrent(firstRun, { exitCode: 1 });
    assert.equal(chatRunRegistry.isProcessing('app-run-9'), true);
    assert.equal(connection.frames.filter((frame) => frame.kind === 'complete').length, 1);

    // The second run's own safety net still works while it is current.
    chatRunRegistry.completeRunIfCurrent(secondRun, { exitCode: 1 });
    assert.equal(chatRunRegistry.isProcessing('app-run-9'), false);
    assert.equal(connection.frames.filter((frame) => frame.kind === 'complete').length, 2);
  });
});

test('markAborted ensures safety net emits complete with aborted: true and exitCode: 0', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-abort-1', 'opencode', '/workspace/demo');
    const connection = new FakeConnection();

    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-abort-1',
      provider: 'opencode',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(run);

    chatRunRegistry.markAborted('app-run-abort-1');

    // Runtime promise settles early during abort: safety net fires with exitCode: 1.
    chatRunRegistry.completeRunIfCurrent(run, { exitCode: 1 });

    const completes = connection.frames.filter((frame) => frame.kind === 'complete');
    assert.equal(completes.length, 1);
    assert.equal(completes[0]?.aborted, true);
    assert.equal(completes[0]?.exitCode, 0);
    assert.equal(chatRunRegistry.isProcessing('app-run-abort-1'), false);

    // When the provider abort handler later attempts to complete, duplicate is dropped.
    chatRunRegistry.completeRun('app-run-abort-1', { exitCode: 0, aborted: true });
    assert.equal(connection.frames.filter((frame) => frame.kind === 'complete').length, 1);
  });
});

test('completeRun reports exitCode 0 for aborted runs even when the caller passes a failure code', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-abort-2', 'devin', '/workspace/demo');
    const connection = new FakeConnection();

    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-abort-2',
      provider: 'devin',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(run);

    // The queue's send-now path used to emit exitCode 1 on takeover aborts —
    // aborted must normalize to 0 so the terminal frame matches the safety
    // net's shape for the same situation.
    chatRunRegistry.completeRun('app-run-abort-2', { exitCode: 1, aborted: true });

    const completes = connection.frames.filter((frame) => frame.kind === 'complete');
    assert.equal(completes.length, 1);
    assert.equal(completes[0]?.aborted, true);
    assert.equal(completes[0]?.exitCode, 0);
  });
});

test('listRunningRuns returns only currently running app sessions', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-7', 'claude', '/workspace/demo');
    sessionsDb.createAppSession('app-run-8', 'codex', '/workspace/demo');
    const connection = new FakeConnection();

    const completedRun = chatRunRegistry.startRun({
      appSessionId: 'app-run-7',
      provider: 'claude',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(completedRun);

    const runningRun = chatRunRegistry.startRun({
      appSessionId: 'app-run-8',
      provider: 'codex',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(runningRun);

    chatRunRegistry.completeRun('app-run-7', { exitCode: 0 });

    const runningSessions = chatRunRegistry.listRunningRuns();
    assert.deepEqual(runningSessions.map((session) => session.sessionId), ['app-run-8']);
    assert.equal(runningSessions[0]?.provider, 'codex');
  });
});

test('replayEvents returns only events after the requested seq', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-4', 'claude', '/workspace/demo');
    const connection = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-4',
      provider: 'claude',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(run);

    run.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'x', content: 'a' });
    run.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'x', content: 'b' });
    run.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'x', content: 'c' });

    const replayed = chatRunRegistry.replayEvents('app-run-4', { afterSeq: 1 });
    assert.deepEqual(replayed.map((event) => event.content), ['b', 'c']);
    assert.deepEqual(replayed.map((event) => event.seq), [2, 3]);
  });
});

test('live events carry the run id and fan out to session subscribers', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-10', 'devin', '/workspace/demo');
    const sender = new FakeConnection();
    const viewer = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-10',
      provider: 'devin',
      providerSessionId: null,
      connection: sender,
      userId: null,
    });
    assert.ok(run);

    chatRunRegistry.addSessionSubscriber('app-run-10', viewer);
    run.writer.send({ kind: 'stream_delta', provider: 'devin', sessionId: 'native-10', content: 'chunk' });

    assert.equal(sender.frames.length, 1);
    assert.equal(viewer.frames.length, 1);
    assert.equal(viewer.frames[0]?.sessionId, 'app-run-10');
    assert.equal(viewer.frames[0]?.runId, run.id);

    // A dead socket drops out of the fan-out without affecting the rest.
    viewer.readyState = 3;
    run.writer.send({ kind: 'stream_delta', provider: 'devin', sessionId: 'native-10', content: 'more' });
    assert.equal(viewer.frames.length, 1);
    assert.equal(sender.frames.length, 2);

    chatRunRegistry.removeConnection(viewer);
    viewer.readyState = 1;
    run.writer.send({ kind: 'stream_delta', provider: 'devin', sessionId: 'native-10', content: 'tail' });
    assert.equal(viewer.frames.length, 1);
    assert.equal(sender.frames.length, 3);
  });
});

test('replayEvents replays the whole buffer when the cursor names an older run', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-11', 'claude', '/workspace/demo');
    const connection = new FakeConnection();

    const firstRun = chatRunRegistry.startRun({
      appSessionId: 'app-run-11',
      provider: 'claude',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(firstRun);
    firstRun.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'x', content: 'old' });
    firstRun.writer.send({ kind: 'complete', provider: 'claude', sessionId: 'x', exitCode: 0 });

    const secondRun = chatRunRegistry.startRun({
      appSessionId: 'app-run-11',
      provider: 'claude',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(secondRun);
    secondRun.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'x', content: 'n1' });
    secondRun.writer.send({ kind: 'stream_delta', provider: 'claude', sessionId: 'x', content: 'n2' });

    // The stale cursor points at the finished run — seq 3 there would mean
    // "seen everything", yet the client provably saw nothing of this run.
    const replayed = chatRunRegistry.replayEvents('app-run-11', { runId: firstRun.id, afterSeq: 3 });
    assert.deepEqual(replayed.map((event) => event.content), ['n1', 'n2']);

    // A matching cursor replays only the tail; a legacy seq-only cursor keeps
    // the old comparison for clients that do not send runId yet.
    assert.deepEqual(
      chatRunRegistry.replayEvents('app-run-11', { runId: secondRun.id, afterSeq: 1 }).map((e) => e.content),
      ['n2'],
    );
    assert.deepEqual(
      chatRunRegistry.replayEvents('app-run-11', { afterSeq: 1 }).map((e) => e.content),
      ['n2'],
    );
  });
});

test('attachConnection reroutes the live stream to a new socket', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-5', 'opencode', '/workspace/demo');
    const firstConnection = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'app-run-5',
      provider: 'opencode',
      providerSessionId: null,
      connection: firstConnection,
      userId: null,
    });
    assert.ok(run);

    run.writer.send({ kind: 'stream_delta', provider: 'opencode', sessionId: 'o', content: 'before' });

    const secondConnection = new FakeConnection();
    assert.equal(chatRunRegistry.attachConnection('app-run-5', secondConnection), true);
    run.writer.send({ kind: 'stream_delta', provider: 'opencode', sessionId: 'o', content: 'after' });

    assert.deepEqual(firstConnection.frames.map((frame) => frame.content), ['before']);
    assert.deepEqual(secondConnection.frames.map((frame) => frame.content), ['after']);
  });
});

test('startRun rejects a second concurrent run for the same session', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-6', 'opencode', '/workspace/demo');
    const connection = new FakeConnection();
    const first = chatRunRegistry.startRun({
      appSessionId: 'app-run-6',
      provider: 'opencode',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(first);

    const second = chatRunRegistry.startRun({
      appSessionId: 'app-run-6',
      provider: 'opencode',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.equal(second, null);

    // After the run finishes a new one is allowed again.
    chatRunRegistry.completeRun('app-run-6', { exitCode: 0 });
    const third = chatRunRegistry.startRun({
      appSessionId: 'app-run-6',
      provider: 'opencode',
      providerSessionId: null,
      connection,
      userId: null,
    });
    assert.ok(third);
  });
});

test('completed writers cannot publish fragments or overwrite the replacement provider mapping', async () => {
  await withIsolatedDatabase(() => {
    const sessionId = 'sealed-run';
    sessionsDb.createAppSession(sessionId, 'devin', '/workspace/demo');
    const connection = new FakeConnection();
    const input = { appSessionId: sessionId, provider: 'devin' as const, providerSessionId: null, connection, userId: null };
    const old = chatRunRegistry.startRun(input)!;
    old.writer.setSessionId('native-original');
    chatRunRegistry.completeRunIfCurrent(old, { exitCode: 0, aborted: true });
    const next = chatRunRegistry.startRun(input)!;
    next.writer.setSessionId('native-current');
    const count = connection.frames.length;
    for (const kind of ['stream_delta', 'stream_replace', 'text', 'tool_use', 'error', 'complete']) {
      old.writer.send({ kind, content: 'late', provider: 'devin' });
    }
    old.writer.send({ kind: 'session_created', newSessionId: 'native-stale', provider: 'devin' });
    old.writer.setSessionId('native-even-later');
    assert.equal(connection.frames.length, count);
    assert.equal(old.lastSeq, 1);
    assert.equal(sessionsDb.getSessionById(sessionId)?.provider_session_id, 'native-current');
    assert.equal(next.status, 'running');
    next.writer.send({ kind: 'stream_delta', content: 'current', provider: 'devin' });
    assert.equal(connection.frames.at(-1)?.content, 'current');
    assert.equal(connection.frames.at(-1)?.seq, 1);
  });
});

test('retention belongs to the completed run, never to its replacement', async (t) => {
  await withIsolatedDatabase(() => {
    t.mock.timers.enable({ apis: ['setTimeout'] });
    const connection = new FakeConnection();
    const input = { appSessionId: 'retention-run', provider: 'devin' as const, providerSessionId: null, connection, userId: null };
    const old = chatRunRegistry.startRun(input)!;
    chatRunRegistry.completeRunIfCurrent(old, { exitCode: 0 });
    t.mock.timers.tick(4 * 60 * 1000);
    const next = chatRunRegistry.startRun(input)!;
    next.writer.send({ kind: 'stream_delta', content: 'new', provider: 'devin' });
    chatRunRegistry.completeRunIfCurrent(next, { exitCode: 0 });
    t.mock.timers.tick(60 * 1000);
    assert.equal(chatRunRegistry.getRun(input.appSessionId), next);
    assert.deepEqual(chatRunRegistry.replayEvents(input.appSessionId).map((e) => e.kind), ['stream_delta', 'complete']);
    t.mock.timers.tick(4 * 60 * 1000);
    assert.equal(chatRunRegistry.getRun(input.appSessionId), undefined);
    t.mock.timers.reset();
  });
});

test('completion is delivered and buffered before listeners start another run', async () => {
  await withIsolatedDatabase(() => {
    const connection = new FakeConnection();
    const input = { appSessionId: 'completion-order', provider: 'devin' as const, providerSessionId: null, connection, userId: null };
    const old = chatRunRegistry.startRun(input)!;
    const unsubscribe = chatRunRegistry.onRunCompleted((sessionId) => {
      if (sessionId !== input.appSessionId) return;
      assert.equal(old.events.at(-1)?.kind, 'complete');
      const next = chatRunRegistry.startRun(input)!;
      next.writer.send({ kind: 'stream_delta', content: 'next', provider: 'devin' });
    });
    try {
      chatRunRegistry.completeRunIfCurrent(old, { exitCode: 0 });
      assert.deepEqual(connection.frames.map((frame) => frame.kind), ['complete', 'stream_delta']);
      assert.notEqual(connection.frames[0]?.runId, connection.frames[1]?.runId);
      assert.equal(chatRunRegistry.isProcessing(input.appSessionId), true);
    } finally {
      unsubscribe();
    }
  });
});

test('a finished run still publishes asks, but nothing else and never over a newer run', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-run-ask', 'claude', '/workspace/demo');
    const connection = new FakeConnection();
    const start = () => chatRunRegistry.startRun({
      appSessionId: 'app-run-ask', provider: 'claude', providerSessionId: null, connection, userId: null,
    });
    const held = start();
    assert.ok(held);
    held.writer.send({ kind: 'complete', provider: 'claude', sessionId: 'native', exitCode: 0 });

    // Claude's background follow-up turn, after the turn reported complete.
    held.writer.send({ kind: 'text', provider: 'claude', sessionId: 'native', content: 'late text' });
    held.writer.send({ kind: 'permission_request', provider: 'claude', sessionId: 'native', requestId: 'r1', toolName: 'Bash' });
    held.writer.send({ kind: 'background_tasks', provider: 'claude', sessionId: 'native', count: 2 });
    assert.deepEqual(connection.frames.map((frame) => frame.kind), ['complete', 'permission_request', 'background_tasks']);
    assert.equal(connection.frames[1]?.sessionId, 'app-run-ask');

    // Once the user starts a new run, the old process's asks are stale.
    const next = start();
    assert.ok(next);
    held.writer.send({ kind: 'permission_request', provider: 'claude', sessionId: 'native', requestId: 'r2', toolName: 'Bash' });
    assert.equal(connection.frames.filter((frame) => frame.kind === 'permission_request').length, 1);
  });
});

test('errors and notices after complete still reach subscribers, keep the run cursor and are persisted', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('late-error', 'codex', '/workspace/demo');
    const connection = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'late-error', provider: 'codex', providerSessionId: null, connection, userId: null,
    })!;
    let completions = 0;
    const unsubscribe = chatRunRegistry.onRunCompleted(() => { completions += 1; });
    try {
      // Codex-style early complete, then the real failure and a second complete.
      run.writer.send({ kind: 'complete', exitCode: 0, provider: 'codex' });
      run.writer.send({ kind: 'error', content: 'turn failed', provider: 'codex' });
      run.writer.send({ kind: 'error', content: 'turn failed', provider: 'codex' });
      run.writer.send({ kind: 'status', text: 'retrying later', notice: true, provider: 'codex' });
      run.writer.send({ kind: 'status', text: 'Thinking', provider: 'codex' });
      run.writer.send({ kind: 'complete', exitCode: 1, provider: 'codex' });
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 1 });
    } finally {
      unsubscribe();
    }

    assert.deepEqual(connection.frames.map((frame) => frame.kind), ['complete', 'error', 'status']);
    assert.deepEqual(connection.frames.map((frame) => frame.seq), [1, 2, 3]);
    assert.ok(connection.frames.every((frame) => frame.runId === run.id && frame.sessionId === 'late-error'));
    assert.equal(completions, 1);

    const stored = sessionEventsDb.listBySession('late-error');
    assert.deepEqual(stored.map((row) => [row.kind, row.content ?? row.text, row.notice]), [
      ['error', 'turn failed', undefined],
      ['status', 'retrying later', true],
    ]);
    assert.equal(stored[0]?.id, connection.frames[1]?.id);
  });
});

test('an aborted run publishes no late errors or notices and persists none', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('late-abort', 'claude', '/workspace/demo');
    const connection = new FakeConnection();
    const run = chatRunRegistry.startRun({
      appSessionId: 'late-abort', provider: 'claude', providerSessionId: null, connection, userId: null,
    })!;
    chatRunRegistry.completeRun('late-abort', { exitCode: 0, aborted: true });
    run.writer.send({ kind: 'error', content: 'interrupted', provider: 'claude' });
    run.writer.send({ kind: 'status', text: 'stopped', notice: true, provider: 'claude' });

    assert.deepEqual(connection.frames.map((frame) => frame.kind), ['complete']);
    assert.deepEqual(sessionEventsDb.listBySession('late-abort'), []);
  });
});
