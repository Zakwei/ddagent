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

test('knowledge is not auto-injected; agents fetch it over MCP', async () => {
  process.env.DDAGENT_UNIFIED_RULES = '0';
  await withIsolatedDatabase(async (dir) => {
    const projectPath = path.join(dir, 'repo');
    await mkdir(projectPath, { recursive: true });
    getConnection()
      .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
      .run('proj-knowledge', projectPath);
    // Even a critical rule must NOT be prepended to the first turn.
    knowledgeService.createRule({
      title: 'No direct DB access',
      content: 'Use services.',
      priority: 'critical',
    });

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
    assert.equal(sent[0], 'hello agent');
    assert.ok(!sent[0].includes('<knowledge>'));
    assert.ok(!sent[0].includes('No direct DB access'));
  });
  delete process.env.DDAGENT_UNIFIED_RULES;
});

