import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
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
