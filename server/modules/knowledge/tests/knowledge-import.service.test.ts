import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  getConnection,
  initializeDatabase,
  knowledgeDb,
} from '@/modules/database/index.js';
import { knowledgeImportService } from '@/modules/knowledge/index.js';

const patchHomeDir = (nextHomeDir: string) => {
  const original = os.homedir;
  (os as unknown as { homedir: () => string }).homedir = () => nextHomeDir;
  return () => {
    (os as unknown as { homedir: () => string }).homedir = original;
  };
};

async function withIsolatedEnv(runTest: (home: string) => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'knowledge-import-all-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(tempRoot, 'auth.db');
  await initializeDatabase();

  const restoreHome = patchHomeDir(tempRoot);
  try {
    await runTest(tempRoot);
  } finally {
    restoreHome();
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
}

async function seed(home: string): Promise<void> {
  const projectRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'knowledge-import-project-'));
  await fs.writeFile(path.join(projectRoot, 'AGENTS.md'), '# Convention\n\nAlways run tests.');
  getConnection()
    .prepare('INSERT INTO projects (project_id, project_path) VALUES (?, ?)')
    .run('p-import', projectRoot);

  const skillDir = path.join(home, '.claude', 'skills', 'imported-skill');
  await fs.mkdir(skillDir, { recursive: true });
  await fs.writeFile(
    path.join(skillDir, 'SKILL.md'),
    '---\nname: imported-skill\ndescription: An imported skill\n---\nBody',
  );
}

test('import-all dry run reports projects and agent skills without writing', async () => {
  await withIsolatedEnv(async (home) => {
    await seed(home);
    const report = await knowledgeImportService.importAll({ dryRun: true });
    assert.equal(report.dryRun, true);
    assert.ok(report.migration.scanned.length >= 1);
    assert.ok(report.skills.found >= 1);
    assert.equal(knowledgeDb.allRules().length, 0);
    assert.equal(knowledgeDb.listSkills({}).total, 0);
  });
});

test('import-all applies project rules and agent skills', async () => {
  await withIsolatedEnv(async (home) => {
    await seed(home);
    const report = await knowledgeImportService.importAll({ dryRun: false });
    assert.equal(report.dryRun, false);

    const rules = knowledgeDb.allRules();
    assert.ok(rules.some((rule) => rule.title === 'Convention'));
    assert.equal(knowledgeDb.findSkillByName('imported-skill')?.description, 'An imported skill');
  });
});
