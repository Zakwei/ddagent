import assert from 'node:assert/strict';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection, initializeDatabase, knowledgeDb } from '@/modules/database/index.js';
import { knowledgeMigrationService } from '@/modules/knowledge/index.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'knowledge-migration-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(tempDirectory, 'auth.db');
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

/** Two projects that both carry an identical AGENTS.md -> duplicate rules. */
async function twoProjectsWithSameAgents(): Promise<void> {
  for (const id of ['p-a', 'p-b']) {
    const root = await mkdtemp(path.join(tmpdir(), `knowledge-${id}-`));
    await writeFile(path.join(root, 'AGENTS.md'), '# Shared convention\n\nAlways run tests.');
    getConnection()
      .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
      .run(id, root);
  }
}

test('dry run scans and reports duplicates without changing anything', async () => {
  await withIsolatedDatabase(async () => {
    await twoProjectsWithSameAgents();

    const report = await knowledgeMigrationService.migrate({});
    assert.equal(report.dryRun, true);
    assert.equal(report.scanned.length, 2);
    assert.equal(report.scanned.reduce((sum, s) => sum + s.imported, 0), 2);
    assert.equal(report.duplicates.length, 1);
    assert.equal(report.duplicates[0]?.entityType, 'rule');
    assert.equal(report.duplicates[0]?.count, 2);
    assert.equal(report.rules.total, 2);
    assert.equal(report.removed, 0);
    assert.equal(report.promoted, 0);
  });
});

test('applying dedupe merges cross-project duplicates into one global rule', async () => {
  await withIsolatedDatabase(async () => {
    await twoProjectsWithSameAgents();
    await knowledgeMigrationService.migrate({});

    const report = await knowledgeMigrationService.migrate({ dryRun: false, dedupe: true });
    assert.equal(report.dryRun, false);
    assert.equal(report.removed, 1);

    const rules = knowledgeDb.allRules();
    assert.equal(rules.length, 1);
    assert.equal(rules[0]?.projectId, null);
  });
});

test('promoteRules moves every rule to critical', async () => {
  await withIsolatedDatabase(async () => {
    await twoProjectsWithSameAgents();
    await knowledgeMigrationService.migrate({});

    const report = await knowledgeMigrationService.migrate({ dryRun: false, promoteRules: true });
    assert.equal(report.promoted, 2);
    assert.equal(report.rules.critical, 2);
    assert.equal(report.rules.high, 0);
  });
});
