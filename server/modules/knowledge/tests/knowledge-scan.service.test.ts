import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  getConnection,
  initializeDatabase,
  knowledgeDb,
} from '@/modules/database/index.js';
import { knowledgeScanService } from '@/modules/knowledge/index.js';
import { AppError } from '@/shared/utils.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'knowledge-scan-'));
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

async function createProjectFixture(): Promise<{ projectId: string; root: string }> {
  const root = await mkdtemp(path.join(tmpdir(), 'knowledge-project-'));
  const projectId = 'project-scan';
  getConnection()
    .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
    .run(projectId, root);
  return { projectId, root };
}

test('scan imports root files and nested markdown, and skips junk', async () => {
  await withIsolatedDatabase(async () => {
    const { projectId, root } = await createProjectFixture();
    await writeFile(path.join(root, 'AGENTS.md'), '# Agent rules\n\nUse strict mode.');
    await writeFile(path.join(root, 'CLAUDE.md'), 'claude notes');
    await writeFile(path.join(root, '.cursorrules'), 'cursor rules');
    await mkdir(path.join(root, '.cursor/rules'), { recursive: true });
    await writeFile(path.join(root, '.cursor/rules/shared.mdc'), '# Shared rules\nbody');
    await mkdir(path.join(root, 'skills/react'), { recursive: true });
    await writeFile(path.join(root, 'skills/react/SKILL.md'), '# React skill\nhow-to');
    await writeFile(path.join(root, 'skills/big.md'), 'x'.repeat(400_000));
    await writeFile(path.join(root, 'skills/binary.md'), 'binary\u0000junk');
    await mkdir(path.join(root, 'skills/node_modules'), { recursive: true });
    await writeFile(path.join(root, 'skills/node_modules/evil.md'), 'junk');

    const first = await knowledgeScanService.scanProject(projectId);
    assert.equal(first.imported, 5);
    assert.equal(first.scanned, 5);
    assert.equal(first.skipped, 0);
    assert.equal(first.deleted, 0);
    assert.equal(knowledgeDb.listMemories({ projectId }).total, 5);

    // Titles come from the first heading or the file name.
    const agents = knowledgeDb
      .listMemories({ projectId })
      .items.find((memory) => memory.source === 'file:AGENTS.md');
    assert.equal(agents?.title, 'Agent rules');
    assert.equal(agents?.memoryType, 'reference');

    // A second scan is a no-op thanks to the content hash.
    const second = await knowledgeScanService.scanProject(projectId);
    assert.deepEqual(
      { imported: second.imported, updated: second.updated, skipped: second.skipped },
      { imported: 0, updated: 0, skipped: 5 },
    );
  });
});

test('rescan updates changed files and deletes memories whose source is gone', async () => {
  await withIsolatedDatabase(async () => {
    const { projectId, root } = await createProjectFixture();
    await writeFile(path.join(root, 'AGENTS.md'), 'v1 rules');
    await writeFile(path.join(root, 'CLAUDE.md'), 'claude notes');

    const first = await knowledgeScanService.scanProject(projectId);
    assert.equal(first.imported, 2);

    await writeFile(path.join(root, 'AGENTS.md'), '# v2 rules\nchanged body');
    const changed = await knowledgeScanService.scanProject(projectId);
    assert.deepEqual(
      { imported: changed.imported, updated: changed.updated, skipped: changed.skipped },
      { imported: 0, updated: 1, skipped: 1 },
    );
    const updated = knowledgeDb
      .listMemories({ projectId })
      .items.find((memory) => memory.source === 'file:AGENTS.md');
    assert.equal(updated?.title, 'v2 rules');
    assert.equal(updated?.content, '# v2 rules\nchanged body');

    await rm(path.join(root, 'CLAUDE.md'));
    const afterDelete = await knowledgeScanService.scanProject(projectId);
    assert.equal(afterDelete.deleted, 1);
    assert.equal(knowledgeDb.listMemories({ projectId }).total, 1);
  });
});

test('scan rejects an unknown project', async () => {
  await withIsolatedDatabase(async () => {
    await assert.rejects(
      () => knowledgeScanService.scanProject('does-not-exist'),
      (error: unknown) => error instanceof AppError && error.statusCode === 404,
    );
  });
});
