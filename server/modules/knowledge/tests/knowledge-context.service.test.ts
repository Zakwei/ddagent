import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, initializeDatabase } from '@/modules/database/index.js';
import {
  buildKnowledgeContextPreview,
  buildProjectContext,
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

test('context includes all enabled rules (critical first); query drives memories/skills/personal', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-project-'));
    registerProject('p1', root);

    knowledgeService.createRule({ title: 'Global critical', content: 'always', priority: 'critical' });
    knowledgeService.createRule({
      projectId: 'p1',
      title: 'Project critical',
      content: 'binding',
      priority: 'critical',
    });
    knowledgeService.createRule({
      title: 'Deploy steps',
      content: 'Run the deploy script',
      priority: 'low',
    });
    knowledgeService.createSkill({ name: 'deploy-helper', description: 'Helps deploy' });
    knowledgeService.createPersonal({ key: 'timezone', title: 'Timezone', content: 'Europe/Warsaw' });

    // No query: ALL enabled rules (not query-filtered), recent skills, no personal.
    const plain = await buildProjectContext({ projectId: 'p1' });
    assert.ok(plain.markdown.includes('Global critical'));
    assert.ok(plain.markdown.includes('Project critical'));
    assert.ok(plain.markdown.includes('Deploy steps'));
    assert.equal(plain.rules[0]?.priority, 'critical');
    assert.ok(plain.skills.some((skill) => skill.name === 'deploy-helper'));
    assert.equal(plain.personal.length, 0);

    // Query: skills matched by FTS.
    const query = await buildProjectContext({ projectId: 'p1', query: 'deploy' });
    assert.ok(query.skills.some((skill) => skill.name === 'deploy-helper'));

    // Personal only when the query matches it.
    const personal = await buildProjectContext({ projectId: 'p1', query: 'timezone Warsaw' });
    assert.ok(personal.personal.some((info) => info.key === 'timezone'));
  });
});

test('context truncates oversized item content within the budget', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-budget-'));
    registerProject('p2', root);
    knowledgeService.createRule({ title: 'Small', content: 'ok', priority: 'critical' });
    knowledgeService.createRule({ title: 'Big', content: 'x'.repeat(30_000), priority: 'critical' });

    const context = await buildProjectContext({ projectId: 'p2' });
    assert.ok(context.markdown.includes('Small'));
    assert.ok(context.markdown.includes('Big'));
    // The 30k-char body is truncated to Contexta's 800-char item cap.
    assert.ok(!context.markdown.includes('x'.repeat(900)));
    assert.equal(context.rules.length, 2);
  });
});

test('a query expands matched memories through 1-hop connections', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-ctx-related-'));
    registerProject('p4', root);
    const memory = knowledgeService.createMemory({
      projectId: 'p4',
      title: 'Auth uses JWT',
      content: 'tokens',
    });
    const related = knowledgeService.createMemory({
      projectId: 'p4',
      title: 'Refresh note',
      content: 'neighbour detail',
    });
    knowledgeService.createConnection({
      sourceId: memory.id,
      sourceType: 'memory',
      targetId: related.id,
      targetType: 'memory',
    });

    const context = await buildProjectContext({ projectId: 'p4', query: 'JWT' });
    const ids = context.memories.map((entry) => entry.id);
    assert.ok(ids.includes(memory.id));
    assert.ok(ids.includes(related.id));
  });
});

test('context preview reports the always-served rules size and budget', async () => {
  await withIsolatedDatabase(async () => {
    const root = await mkdtemp(path.join(tmpdir(), 'knowledge-preview-'));
    registerProject('p5', root);
    knowledgeService.createRule({
      projectId: 'p5',
      title: 'Binding rule',
      content: 'do it',
      priority: 'critical',
    });

    const preview = buildKnowledgeContextPreview('p5');
    assert.equal(preview.projectId, 'p5');
    assert.ok(preview.markdown);
    assert.ok(preview.markdown!.includes('Binding rule'));
    assert.equal(preview.chars, preview.markdown!.length);
    assert.equal(preview.estimatedTokens, Math.ceil(preview.chars / 4));
    assert.equal(preview.tokenBudget, 4000);

    assert.equal(buildKnowledgeContextPreview(null).markdown, null);
    assert.equal(buildKnowledgeContextPreview('nope').markdown, null);
  });
});
