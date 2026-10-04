import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, initializeDatabase } from '@/modules/database/index.js';
import { buildKnowledgePrefix, knowledgeService } from '@/modules/knowledge/index.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'knowledge-context-'));
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

const registerProject = (projectId: string, projectPath: string): void => {
  getConnection()
    .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
    .run(projectId, projectPath);
};

test('prefix includes project and global critical rules/memories only', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-project-'));
    registerProject('p1', root);

    knowledgeService.createRule({ title: 'Global critical', content: 'always', priority: 'critical' });
    knowledgeService.createRule({ projectId: 'p1', title: 'Project critical', content: 'binding', priority: 'critical' });
    knowledgeService.createRule({ title: 'Not critical', content: 'later', priority: 'low' });
    knowledgeService.createMemory({ title: 'Critical memory', content: 'durable fact', priority: 'critical' });
    knowledgeService.createMemory({ title: 'Loose memory', content: 'nope', priority: 'normal' });

    const prefix = await buildKnowledgePrefix(root);
    assert.ok(prefix);
    assert.ok(prefix.includes('Global critical'));
    assert.ok(prefix.includes('Project critical'));
    assert.ok(prefix.includes('Critical memory'));
    assert.ok(!prefix.includes('Not critical'));
    assert.ok(!prefix.includes('Loose memory'));
    assert.ok(prefix.startsWith('<knowledge>'));
    assert.ok(prefix.endsWith('</knowledge>\n\n'));
  });
});

test('oversized entries are skipped without starving the rest of the budget', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-budget-'));
    registerProject('p2', root);

    knowledgeService.createMemory({ title: 'Small memory', content: 'short', priority: 'critical' });
    knowledgeService.createMemory({ title: 'Huge memory', content: 'x'.repeat(20_000), priority: 'critical' });

    const prefix = await buildKnowledgePrefix(root);
    assert.ok(prefix);
    assert.ok(prefix.includes('Small memory'));
    assert.ok(!prefix.includes('Huge memory'));
  });
});

test('prefix is null when disabled or when nothing critical is stored', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-empty-'));
    registerProject('p3', root);
    assert.equal(await buildKnowledgePrefix(root), null);

    knowledgeService.createRule({ title: 'Only rule', content: 'x', priority: 'critical' });
    process.env.DDAGENT_KNOWLEDGE = '0';
    try {
      assert.equal(await buildKnowledgePrefix(root), null);
    } finally {
      delete process.env.DDAGENT_KNOWLEDGE;
    }
    assert.ok(await buildKnowledgePrefix(root));
  });
});
