import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { knowledgeService } from '@/modules/knowledge/index.js';
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
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'knowledge-inject-'));
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

test('critical knowledge prefixes the session\'s first message only', async () => {
  process.env.DDAGENT_UNIFIED_RULES = '0';
  await withIsolatedDatabase(async (dir) => {
    const projectPath = path.join(dir, 'repo');
    await mkdir(projectPath, { recursive: true });
    getConnection()
      .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
      .run('proj-knowledge', projectPath);
    knowledgeService.createRule({ title: 'No direct DB access', content: 'Use services.', priority: 'critical' });
    knowledgeService.createRule({ title: 'Low priority', content: 'optional', priority: 'low' });

    sessionsDb.createAppSession('sess-knowledge', 'devin', projectPath);
    const { runtime, sent } = capturingRuntime();

    const first = await dispatchChatCommand(runtime, {
      sessionId: 'sess-knowledge',
      content: 'hello agent',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(first, { ok: true });
    assert.ok(sent[0].startsWith('<knowledge>'));
    assert.ok(sent[0].includes('No direct DB access'));
    assert.ok(!sent[0].includes('Low priority'));
    assert.ok(sent[0].endsWith('hello agent'));

    const second = await dispatchChatCommand(runtime, {
      sessionId: 'sess-knowledge',
      content: 'second message',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.deepEqual(second, { ok: true });
    assert.equal(sent[1], 'second message');
  });
  delete process.env.DDAGENT_UNIFIED_RULES;
});

test('DDAGENT_KNOWLEDGE=0 leaves the message untouched', async () => {
  process.env.DDAGENT_UNIFIED_RULES = '0';
  process.env.DDAGENT_KNOWLEDGE = '0';
  await withIsolatedDatabase(async (dir) => {
    const projectPath = path.join(dir, 'repo');
    await mkdir(projectPath, { recursive: true });
    knowledgeService.createRule({ title: 'Hidden rule', content: 'x', priority: 'critical' });

    sessionsDb.createAppSession('sess-opt-out', 'devin', projectPath);
    const { runtime, sent } = capturingRuntime();

    await dispatchChatCommand(runtime, {
      sessionId: 'sess-opt-out',
      content: 'plain message',
      options: {},
      userId: null,
      connection: new FakeConnection() as never,
    });
    assert.equal(sent[0], 'plain message');
  });
  delete process.env.DDAGENT_UNIFIED_RULES;
  delete process.env.DDAGENT_KNOWLEDGE;
});
