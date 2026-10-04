import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, knowledgeDb } from '@/modules/database/index.js';
import { knowledgeSkillImportService } from '@/modules/knowledge/index.js';

const patchHomeDir = (nextHomeDir: string) => {
  const original = os.homedir;
  (os as unknown as { homedir: () => string }).homedir = () => nextHomeDir;
  return () => {
    (os as unknown as { homedir: () => string }).homedir = original;
  };
};

async function withIsolatedEnv(runTest: (home: string) => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'knowledge-skills-'));
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

async function seedClaudeSkill(home: string): Promise<void> {
  const dir = path.join(home, '.claude', 'skills', 'demo-skill');
  await fs.mkdir(dir, { recursive: true });
  await fs.writeFile(
    path.join(dir, 'SKILL.md'),
    '---\nname: demo-skill\ndescription: A demo skill\ncategory: testing\n---\nBody',
  );
}

test('dry run finds agent skills without importing them', async () => {
  await withIsolatedEnv(async (home) => {
    await seedClaudeSkill(home);
    const report = await knowledgeSkillImportService.importProviderSkills({
      providers: ['claude'],
      dryRun: true,
    });
    assert.equal(report.dryRun, true);
    assert.ok(report.imported >= 1);
    assert.ok(report.skills.some((skill) => skill.name === 'demo-skill' && skill.imported));
    assert.equal(knowledgeDb.listSkills({}).total, 0);
  });
});

test('importing creates knowledge skills and is idempotent', async () => {
  await withIsolatedEnv(async (home) => {
    await seedClaudeSkill(home);

    const first = await knowledgeSkillImportService.importProviderSkills({
      providers: ['claude'],
      dryRun: false,
    });
    assert.equal(first.dryRun, false);
    assert.ok(first.imported >= 1);

    const skill = knowledgeDb.findSkillByName('demo-skill');
    assert.equal(skill?.description, 'A demo skill');
    assert.equal(skill?.category, 'testing');
    assert.equal(skill?.content.includes('Body'), true);

    // Same provider skill again: skipped because the name already exists.
    const second = await knowledgeSkillImportService.importProviderSkills({
      providers: ['claude'],
      dryRun: false,
    });
    assert.equal(second.imported, 0);
    assert.ok(second.skills.some((entry) => entry.name === 'demo-skill' && !entry.imported));
  });
});
