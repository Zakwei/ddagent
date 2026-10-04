import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, initializeDatabase } from '@/modules/database/index.js';
import {
  buildKnowledgeContextPreview,
  buildKnowledgePrefix,
  knowledgeService,
} from '@/modules/knowledge/index.js';

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

test('prefix includes personal info and 1-hop relations of critical memories', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-related-'));
    registerProject('p4', root);

    knowledgeService.createPersonal({ key: 'timezone', title: 'Timezone', content: 'Europe/Warsaw' });
    const memory = knowledgeService.createMemory({ title: 'Critical fact', content: 'body', priority: 'critical' });
    const related = knowledgeService.createMemory({ title: 'Related note', content: 'neighbour' });
    knowledgeService.createConnection({
      sourceId: memory.id,
      sourceType: 'memory',
      targetId: related.id,
      targetType: 'memory',
    });

    const prefix = await buildKnowledgePrefix(root);
    assert.ok(prefix);
    assert.ok(prefix.includes('Timezone: Europe/Warsaw'));
    assert.ok(prefix.includes('Related note (memory)'));
  });
});

test('context preview reports the injected size and budget for a project', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-preview-'));
    registerProject('p5', root);
    knowledgeService.createRule({ title: 'Binding rule', content: 'do it', priority: 'critical' });

    const preview = await buildKnowledgeContextPreview('p5');
    assert.equal(preview.projectId, 'p5');
    assert.ok(preview.markdown);
    assert.equal(preview.chars, preview.markdown!.length);
    assert.equal(preview.estimatedTokens, Math.ceil(preview.chars / 4));
    assert.equal(preview.tokenBudget, 4000);

    // No project / unknown project -> empty preview, still reporting the budget.
    assert.equal((await buildKnowledgeContextPreview(null)).markdown, null);
    const unknown = await buildKnowledgeContextPreview('nope');
    assert.equal(unknown.markdown, null);
    assert.equal(unknown.tokenBudget, 4000);
  });
});
