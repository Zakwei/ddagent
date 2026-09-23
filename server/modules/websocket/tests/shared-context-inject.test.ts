import assert from 'node:assert/strict';
import { mkdtemp, mkdir, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import {
  dispatchChatCommand,
  type ProviderRuntimeGateway,
} from '@/modules/websocket/services/chat-dispatch.service.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import { connectedClients } from '@/modules/websocket/services/websocket-state.service.js';

class FakeConnection {
  readyState = 1;
  frames: Array<Record<string, unknown>> = [];
  send(data: string): void {
    this.frames.push(JSON.parse(data) as Record<string, unknown>);
  }
}

async function withIsolatedDatabase(
  runTest: (tempDir: string) => void | Promise<void>,
): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'shared-inject-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest(tempDirectory);
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

function capturingRuntime(): { runtime: ProviderRuntimeGateway; sent: string[] } {
  const sent: string[] = [];
  return {
    sent,
    runtime: {
      hasRuntime: () => true,
      run: async (_provider: string, command: string) => {
        sent.push(command);
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    } as unknown as ProviderRuntimeGateway,
  };
}

test('the project shared context prefixes the session\'s first message only', async () => {
  await withIsolatedDatabase(async (dir) => {
    const projectPath = path.join(dir, 'repo');
    await mkdir(path.join(projectPath, '.ddagent'), { recursive: true });
    await writeFile(path.join(projectPath, '.ddagent', 'shared-context.md'), 'Use pnpm, not npm.');

    sessionsDb.createAppSession('sess-inject', 'devin', projectPath);
    const { runtime, sent } = capturingRuntime();

    const first = await dispatchChatCommand(runtime, {
      sessionId: 'sess-inject',
      content: 'hello agent',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(first, { ok: true });
    assert.ok(sent[0].includes('Use pnpm, not npm.'));
    assert.ok(sent[0].endsWith('hello agent'));

    const second = await dispatchChatCommand(runtime, {
      sessionId: 'sess-inject',
      content: 'second message',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(second, { ok: true });
    assert.equal(sent[1], 'second message');
  });
});

test('no shared-context file leaves the message untouched', async () => {
  await withIsolatedDatabase(async (dir) => {
    sessionsDb.createAppSession('sess-plain', 'devin', path.join(dir, 'repo'));
    const { runtime, sent } = capturingRuntime();

    const result = await dispatchChatCommand(runtime, {
      sessionId: 'sess-plain',
      content: 'just a message',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(result, { ok: true });
    assert.equal(sent[0], 'just a message');
  });
});
