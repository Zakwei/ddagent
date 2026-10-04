import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase } from '@/modules/database/index.js';
import { knowledgeService } from '@/modules/knowledge/index.js';
import { AppError } from '@/shared/utils.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'knowledge-service-'));
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

const expectStatus = (fn: () => unknown, status: number) => {
  assert.throws(
    fn,
    (error: unknown) => error instanceof AppError && error.statusCode === status,
  );
};

test('memories validate input and reject bad priorities or oversized tags', async () => {
  await withIsolatedDatabase(() => {
    expectStatus(() => knowledgeService.createMemory({ title: '   ' }), 400);
    expectStatus(() => knowledgeService.createMemory({ title: 'ok', priority: 'urgent' }), 400);
    expectStatus(
      () =>
        knowledgeService.createMemory({
          title: 'ok',
          tags: Array.from({ length: 26 }, (_, index) => `tag-${index}`),
        }),
      400,
    );

    const memory = knowledgeService.createMemory({
      title: 'Auth uses JWT',
      content: 'body',
      priority: 'critical',
      tags: ['auth'],
    });
    assert.equal(memory.priority, 'critical');
    expectStatus(() => knowledgeService.updateMemory(memory.id, { priority: 'nope' }), 400);
    expectStatus(() => knowledgeService.getMemory('missing'), 404);
    expectStatus(() => knowledgeService.deleteMemory('missing'), 404);
  });
});

test('every mutation is snapshotted into history', async () => {
  await withIsolatedDatabase(() => {
    const memory = knowledgeService.createMemory({ title: 'v1', content: 'one' });
    knowledgeService.updateMemory(memory.id, { title: 'v2', content: 'two' });
    knowledgeService.deleteMemory(memory.id);

    const history = knowledgeService.listHistory({ entityType: 'memory', entityId: memory.id });
    assert.equal(history.length, 3);
    // Newest first (insertion order): delete snapshot, update snapshot, create snapshot.
    assert.deepEqual(history.map((entry) => entry.title), ['v2', 'v2', 'v1']);
  });
});

test('skills enforce unique names and validate the icon data URL', async () => {
  await withIsolatedDatabase(() => {
    const skill = knowledgeService.createSkill({
      name: 'Ponytail',
      description: 'Review buddy',
      content: 'Body',
      icon: 'data:image/png;base64,AA==',
    });
    assert.equal(skill.icon, 'data:image/png;base64,AA==');
    expectStatus(() => knowledgeService.createSkill({ name: 'Ponytail' }), 409);
    expectStatus(() => knowledgeService.createSkill({ name: 'Bad', icon: 'javascript:alert(1)' }), 400);
    expectStatus(
      () =>
        knowledgeService.createSkill({
          name: 'Huge',
          icon: `data:image/png;base64,${'A'.repeat(70 * 1024)}`,
        }),
      400,
    );
  });
});

test('personal information validates keys and enforces uniqueness', async () => {
  await withIsolatedDatabase(() => {
    const info = knowledgeService.createPersonal({ key: 'timezone', title: 'Timezone', content: 'CET' });
    assert.equal(info.key, 'timezone');
    expectStatus(() => knowledgeService.createPersonal({ key: 'timezone', title: 'x' }), 409);
    expectStatus(() => knowledgeService.createPersonal({ key: 'bad key!', title: 'x' }), 400);
  });
});

test('graph assembles nodes and only edges whose endpoints are present', async () => {
  await withIsolatedDatabase(() => {
    const a = knowledgeService.createMemory({ title: 'A' });
    const b = knowledgeService.createMemory({ title: 'B' });
    const rule = knowledgeService.createRule({ title: 'R', content: '', priority: 'high' });
    knowledgeService.createConnection({
      sourceId: a.id,
      sourceType: 'memory',
      targetId: b.id,
      targetType: 'memory',
    });
    knowledgeService.createConnection({
      sourceId: a.id,
      sourceType: 'memory',
      targetId: rule.id,
      targetType: 'rule',
    });

    const memoriesOnly = knowledgeService.graph({ entityTypes: ['memory'] });
    assert.equal(memoriesOnly.nodes.length, 2);
    assert.equal(memoriesOnly.edges.length, 1);

    const all = knowledgeService.graph();
    assert.equal(all.nodes.length, 3);
    assert.equal(all.edges.length, 2);
    assert.equal(all.counts.memory, 2);
    assert.equal(all.counts.rule, 1);
  });
});

test('export then import restores entities without duplicating unique skills/keys', async () => {
  await withIsolatedDatabase(() => {
    knowledgeService.createMemory({ title: 'M1', content: 'body', tags: ['t'] });
    knowledgeService.createRule({ title: 'R1', content: 'r' });
    knowledgeService.createSkill({ name: 'S1', description: 'd' });
    knowledgeService.createPersonal({ key: 'k1', title: 'P1', content: 'p' });

    const exported = knowledgeService.exportAll();
    assert.equal(exported.memories.length, 1);
    assert.equal(exported.rules.length, 1);
    assert.equal(exported.skills.length, 1);
    assert.equal(exported.personal.length, 1);

    const imported = knowledgeService.importAll(exported);
    assert.equal(imported.memories, 1);
    assert.equal(imported.rules, 1);
    // Skill name and personal key are unique, so the second import is skipped.
    assert.equal(imported.skills, 0);
    assert.equal(imported.personal, 0);
    assert.deepEqual(knowledgeService.stats(), {
      memories: 2,
      rules: 2,
      skills: 1,
      personal: 1,
      connections: 0,
    });
  });
});

test('search is project-scoped and type-filtered', async () => {
  await withIsolatedDatabase(() => {
    const globalRule = knowledgeService.createRule({
      title: 'Global convention',
      content: 'always do the thing',
      priority: 'critical',
    });
    knowledgeService.createMemory({ projectId: 'p1', title: 'Project note', content: 'thing' });

    const globalResults = knowledgeService.search('thing', { projectId: null });
    assert.equal(globalResults.length, 1);
    assert.equal(globalResults[0]?.entityId, globalRule.id);
    assert.equal(knowledgeService.search('', {}).length, 0);
    assert.equal(knowledgeService.search('thing', { entityType: 'memory' }).length, 1);
  });
});
