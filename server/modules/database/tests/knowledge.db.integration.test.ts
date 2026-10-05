import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, knowledgeDb } from '@/modules/database/index.js';
import { initializeDatabase } from '@/modules/database/init-db.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'knowledge-db-'));
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

test('knowledge schema creates every table, the FTS index and its triggers', async () => {
  await withIsolatedDatabase(() => {
    const db = getConnection();
    const names = (
      db
        .prepare("SELECT name FROM sqlite_master WHERE type = 'table'")
        .all() as Array<{ name: string }>
    ).map((row) => row.name);
    for (const table of [
      'kb_memories',
      'kb_rules',
      'kb_skills',
      'kb_personal_information',
      'kb_tags',
      'kb_memory_tags',
      'kb_connections',
      'kb_entity_history',
      'kb_embeddings',
      'kb_scan_state',
    ]) {
      assert.ok(names.includes(table), `missing ${table}`);
    }
    const triggers = (
      db
        .prepare("SELECT name FROM sqlite_master WHERE type = 'trigger' AND name LIKE 'kb_%'")
        .all() as Array<{ name: string }>
    ).map((row) => row.name);
    assert.equal(triggers.length, 12);
  });
});

test('memories CRUD keeps tags and the FTS index in sync', async () => {
  await withIsolatedDatabase(() => {
    const memory = knowledgeDb.createMemory({
      projectId: 'project-1',
      title: 'Auth uses JWT',
      content: 'Short-lived access tokens with rotating refresh tokens.',
      memoryType: 'decision',
      priority: 'critical',
      tags: ['auth', 'architecture', 'auth'],
    });
    assert.equal(memory.priority, 'critical');
    assert.deepEqual(memory.tags, ['architecture', 'auth']);

    const scoped = knowledgeDb.listMemories({ projectId: 'project-1' });
    assert.equal(scoped.total, 1);
    assert.equal(knowledgeDb.listMemories({ projectId: 'project-2' }).total, 0);

    const tagged = knowledgeDb.listMemories({ tag: 'auth' });
    assert.equal(tagged.total, 1);
    assert.equal(knowledgeDb.listMemories({ tag: 'nope' }).total, 0);

    // FTS search matches the indexed title/content.
    assert.equal(knowledgeDb.search('tokens')[0]?.entityId, memory.id);

    knowledgeDb.updateMemory(memory.id, {
      title: 'Auth uses rotating refresh tokens',
      content: 'Changed body',
      tags: ['auth'],
    });
    const updated = knowledgeDb.getMemory(memory.id);
    assert.deepEqual(updated?.tags, ['auth']);
    assert.equal(knowledgeDb.search('Changed')[0]?.entityId, memory.id);
    // Old content is gone from the index after the update trigger fired.
    assert.equal(knowledgeDb.search('Short-lived').length, 0);

    assert.equal(knowledgeDb.deleteMemory(memory.id), true);
    assert.equal(knowledgeDb.search('Changed').length, 0);
    assert.equal(knowledgeDb.getMemory(memory.id), null);
  });
});

test('rules support enable toggling and priority filtering', async () => {
  await withIsolatedDatabase(() => {
    const rule = knowledgeDb.createRule({
      projectId: null,
      title: 'Always use TypeScript strict mode',
      content: 'No implicit any.',
      priority: 'critical',
    });
    assert.equal(rule.enabled, true);
    assert.equal(knowledgeDb.listRules({ projectId: null }).total, 1);
    assert.equal(knowledgeDb.listRules({ enabledOnly: true }).total, 1);

    knowledgeDb.updateRule(rule.id, { enabled: false });
    assert.equal(knowledgeDb.getRule(rule.id)?.enabled, false);
    assert.equal(knowledgeDb.listRules({ enabledOnly: true }).total, 0);
    assert.equal(knowledgeDb.listRules({ priority: 'critical' }).total, 1);

    assert.equal(knowledgeDb.search('implicit', { entityType: 'rule' })[0]?.entityId, rule.id);
  });
});

test('partial updates keep project scope when projectId is omitted', async () => {
  await withIsolatedDatabase(() => {
    // The service layer always passes the key (undefined when absent), so an
    // explicit undefined must behave like "not provided" — only null clears scope.
    const rule = knowledgeDb.createRule({
      projectId: 'proj-x',
      title: 'Scoped rule',
      content: 'x',
      priority: 'normal',
    });
    knowledgeDb.updateRule(rule.id, { projectId: undefined, priority: 'high' });
    assert.equal(knowledgeDb.getRule(rule.id)?.projectId, 'proj-x');
    knowledgeDb.updateRule(rule.id, { projectId: null });
    assert.equal(knowledgeDb.getRule(rule.id)?.projectId, null);

    const memory = knowledgeDb.createMemory({
      projectId: 'proj-x',
      title: 'Scoped memory',
      content: 'x',
      memoryType: 'note',
      priority: 'normal',
      tags: [],
    });
    knowledgeDb.updateMemory(memory.id, { projectId: undefined, title: 'Renamed' });
    assert.equal(knowledgeDb.getMemory(memory.id)?.projectId, 'proj-x');
    knowledgeDb.updateMemory(memory.id, { projectId: null });
    assert.equal(knowledgeDb.getMemory(memory.id)?.projectId, null);
  });
});

test('skills and personal information enforce unique names/keys', async () => {
  await withIsolatedDatabase(() => {
    const skill = knowledgeDb.createSkill({
      name: 'Ponytail',
      description: 'Review buddy',
      content: 'Body',
      category: 'review',
      icon: 'data:image/png;base64,AA==',
    });
    assert.equal(skill.icon, 'data:image/png;base64,AA==');
    assert.throws(() => knowledgeDb.createSkill({ name: 'Ponytail' }));
    assert.equal(knowledgeDb.findSkillByName('Ponytail')?.id, skill.id);

    const personal = knowledgeDb.createPersonal({
      key: 'timezone',
      title: 'Timezone',
      content: 'Europe/Warsaw',
    });
    assert.throws(() => knowledgeDb.createPersonal({ key: 'timezone', title: 'x', content: '' }));
    assert.equal(knowledgeDb.findPersonalByKey('timezone')?.id, personal.id);
    assert.equal(knowledgeDb.search('Warsaw', { entityType: 'personal' }).length, 1);
  });
});

test('connections and history round-trip', async () => {
  await withIsolatedDatabase(() => {
    const a = knowledgeDb.createMemory({ title: 'A', content: '' });
    const b = knowledgeDb.createMemory({ title: 'B', content: '' });
    const connection = knowledgeDb.createConnection({
      sourceId: a.id,
      sourceType: 'memory',
      targetId: b.id,
      targetType: 'memory',
      relationship: 'related',
      weight: 0.8,
    });
    assert.equal(knowledgeDb.listConnections({ entityId: a.id }).length, 1);
    assert.equal(connection.weight, 0.8);
    assert.equal(knowledgeDb.deleteConnection(connection.id), true);

    knowledgeDb.recordHistory({ entityType: 'memory', entityId: a.id, title: 'A', content: '' });
    const history = knowledgeDb.listHistory({ entityId: a.id });
    assert.equal(history.length, 1);
    assert.equal(history[0]?.title, 'A');
  });
});

test('scan state upserts per project path and stats count rows', async () => {
  await withIsolatedDatabase(() => {
    knowledgeDb.createMemory({ title: 'One', content: '' });
    knowledgeDb.createRule({ title: 'Rule', content: '' });
    assert.deepEqual(knowledgeDb.stats(), {
      memories: 1,
      rules: 1,
      skills: 0,
      personal: 0,
      connections: 0,
    });

    knowledgeDb.upsertScanState({
      projectId: 'p1',
      path: 'AGENTS.md',
      contentHash: 'hash-1',
      entityType: 'memory',
      entityId: 'm1',
    });
    knowledgeDb.upsertScanState({
      projectId: 'p1',
      path: 'AGENTS.md',
      contentHash: 'hash-2',
      entityType: 'memory',
      entityId: 'm1',
    });
    const state = knowledgeDb.getScanState('p1');
    assert.equal(state.length, 1);
    assert.equal(state[0]?.contentHash, 'hash-2');

    knowledgeDb.deleteScanState('p1', 'AGENTS.md');
    assert.equal(knowledgeDb.getScanState('p1').length, 0);
  });
});

test('search is prefix-aware, fuzzy and priority-reranked', async () => {
  await withIsolatedDatabase(() => {
    const critical = knowledgeDb.createMemory({
      title: 'Authentication flow',
      content: 'JWT tokens',
      priority: 'critical',
    });
    const low = knowledgeDb.createMemory({ title: 'Auth notes', content: 'misc', priority: 'low' });

    // Prefix matching: "auth" matches both "Authentication…" and "Auth notes".
    const prefix = knowledgeDb.search('auth', {});
    assert.ok(prefix.some((row) => row.entityId === critical.id));
    assert.ok(prefix.some((row) => row.entityId === low.id));
    // Priority rerank puts the critical memory first.
    assert.equal(prefix[0]?.entityId, critical.id);

    // Fuzzy trigram fallback catches a typo that FTS prefix matching misses.
    const fuzzy = knowledgeDb.search('authentcation', {});
    assert.ok(fuzzy.some((row) => row.entityId === critical.id));
  });
});
