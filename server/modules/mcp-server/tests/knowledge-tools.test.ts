import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, initializeDatabase } from '@/modules/database/index.js';
import { AppError } from '@/shared/utils.js';

import { callMcpTool, listMcpTools } from '../mcp-tools.service.js';

type MemoryShape = { id: string; title: string; priority: string };

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'mcp-knowledge-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

test('tools/list advertises the knowledge read and write tools', () => {
  const names = listMcpTools().map((tool) => tool.name);
  assert.ok(names.includes('knowledge_search'));
  assert.ok(names.includes('knowledge_add_memory'));
  assert.ok(names.includes('knowledge_unlink'));
  assert.equal(names.filter((name) => name.startsWith('knowledge_')).length, 22);
});

test('write knowledge tools reject a read-scoped token', async () => {
  await withIsolatedDatabase(async () => {
    await assert.rejects(
      () => callMcpTool('knowledge_add_memory', { title: 'x' }, 'read'),
      (error: unknown) => error instanceof AppError && error.code === 'MCP_SCOPE_FORBIDDEN',
    );
  });
});

test('knowledge tools round-trip a memory through search, update and delete', async () => {
  await withIsolatedDatabase(async () => {
    const created = (await callMcpTool(
      'knowledge_add_memory',
      { title: 'Auth uses JWT', content: 'rotating refresh tokens', priority: 'critical', tags: ['auth'] },
      'write',
    )) as MemoryShape;
    assert.equal(created.title, 'Auth uses JWT');
    assert.equal(created.priority, 'critical');

    const search = (await callMcpTool('knowledge_search', { query: 'tokens' }, 'read')) as {
      results: Array<{ entityId: string }>;
    };
    assert.equal(search.results[0]?.entityId, created.id);

    const updated = (await callMcpTool(
      'knowledge_update_memory',
      { id: created.id, title: 'Auth uses rotating refresh tokens' },
      'write',
    )) as MemoryShape;
    assert.equal(updated.title, 'Auth uses rotating refresh tokens');

    const listed = (await callMcpTool('knowledge_get_memories', { priority: 'critical' }, 'read')) as {
      items: MemoryShape[];
    };
    assert.equal(listed.items.length, 1);

    const deleted = (await callMcpTool('knowledge_delete_memory', { id: created.id }, 'write')) as {
      deleted: boolean;
    };
    assert.equal(deleted.deleted, true);
    assert.equal((await callMcpTool('knowledge_search', { query: 'tokens' }, 'read') as { results: unknown[] }).results.length, 0);
  });
});

test('knowledge_get_context resolves a projectPath to its critical scope', async () => {
  await withIsolatedDatabase(async () => {
    getConnection()
      .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
      .run('p-ctx', '/workspace/demo');
    await callMcpTool(
      'knowledge_add_rule',
      { title: 'Binding rule', content: 'do it', priority: 'critical', projectPath: '/workspace/demo' },
      'write',
    );
    const context = (await callMcpTool('knowledge_get_context', { projectPath: '/workspace/demo' }, 'read')) as {
      projectId: string | null;
      rules: Array<{ title: string }>;
    };
    assert.equal(context.projectId, 'p-ctx');
    assert.equal(context.rules[0]?.title, 'Binding rule');
  });
});

test('an unknown tool name is a params error', async () => {
  await withIsolatedDatabase(async () => {
    await assert.rejects(
      () => callMcpTool('knowledge_nope', {}, 'read'),
      (error: unknown) => error instanceof AppError && error.code === 'MCP_UNKNOWN_TOOL',
    );
  });
});
