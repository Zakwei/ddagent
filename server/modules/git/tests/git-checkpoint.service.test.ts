import assert from 'node:assert/strict';
import { execFileSync, spawn } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  createCheckpoint,
  listCheckpoints,
  restoreCheckpoint,
  type GitCommandRunner,
} from '../git-checkpoint.service.js';

/** Real `git` runner against a temporary repository. */
const runCommand: GitCommandRunner = (command, args, options) =>
  new Promise((resolve, reject) => {
    const child = spawn(command, args, { cwd: options.cwd, env: options.env, shell: false });
    let stdout = '';
    let stderr = '';
    child.stdout.on('data', (data) => { stdout += data.toString(); });
    child.stderr.on('data', (data) => { stderr += data.toString(); });
    child.on('error', reject);
    child.on('close', (code) => {
      if (code === 0) {
        resolve({ stdout, stderr });
        return;
      }
      reject(new Error(`Command failed: ${command} ${args.join(' ')}`));
    });
  });

async function createRepo(): Promise<string> {
  const repoPath = await mkdtemp(path.join(tmpdir(), 'ddagent-checkpoint-'));
  execFileSync('git', ['init', '-q'], { cwd: repoPath });
  execFileSync('git', ['config', 'user.email', 'test@test.test'], { cwd: repoPath });
  execFileSync('git', ['config', 'user.name', 'Test'], { cwd: repoPath });
  await writeFile(path.join(repoPath, 'tracked.txt'), 'initial\n');
  execFileSync('git', ['add', '-A'], { cwd: repoPath });
  execFileSync('git', ['commit', '-qm', 'init'], { cwd: repoPath });
  return repoPath;
}

test('createCheckpoint captures tracked, modified, and untracked files without touching the index', async () => {
  const repoPath = await createRepo();
  try {
    await writeFile(path.join(repoPath, 'tracked.txt'), 'modified\n');
    await writeFile(path.join(repoPath, 'untracked.txt'), 'pre-existing\n');

    const checkpoint = await createCheckpoint({ projectPath: repoPath, runCommand, label: 'before AI' });

    assert.match(checkpoint.ref, /^refs\/ddagent\/checkpoints\//);
    assert.ok(checkpoint.commit.length >= 7);
    assert.equal(checkpoint.label, 'before AI');
    assert.deepEqual(checkpoint.files.sort(), ['tracked.txt', 'untracked.txt']);

    // The real index must be untouched: everything still shows as unstaged.
    const status = execFileSync('git', ['status', '--porcelain'], { cwd: repoPath }).toString();
    assert.match(status, / M tracked\.txt/);
    assert.match(status, /\?\? untracked\.txt/);
  } finally {
    await rm(repoPath, { recursive: true, force: true });
  }
});

test('listCheckpoints returns created checkpoints newest first', async () => {
  const repoPath = await createRepo();
  try {
    const first = await createCheckpoint({ projectPath: repoPath, runCommand, label: 'one' });
    await new Promise((resolve) => setTimeout(resolve, 1100));
    const second = await createCheckpoint({ projectPath: repoPath, runCommand, label: 'two' });

    const checkpoints = await listCheckpoints({ projectPath: repoPath, runCommand });

    assert.equal(checkpoints.length, 2);
    assert.equal(checkpoints[0].ref, second.ref);
    assert.equal(checkpoints[0].label, 'two');
    assert.equal(checkpoints[1].ref, first.ref);
    assert.equal(checkpoints[1].label, 'one');
    assert.ok(checkpoints[0].createdAt && checkpoints[0].createdAt.length > 0);
  } finally {
    await rm(repoPath, { recursive: true, force: true });
  }
});

test('restoreCheckpoint reverts tracked changes and deletes AI-created untracked files', async () => {
  const repoPath = await createRepo();
  try {
    await writeFile(path.join(repoPath, 'tracked.txt'), 'snapshot state\n');
    await writeFile(path.join(repoPath, 'pre-existing.txt'), 'keep me\n');
    const checkpoint = await createCheckpoint({ projectPath: repoPath, runCommand });

    // Simulate an AI run: modify a tracked file, delete the untracked file,
    // create brand new files.
    await writeFile(path.join(repoPath, 'tracked.txt'), 'AI rewrote this\n');
    await writeFile(path.join(repoPath, 'ai-new.txt'), 'ai created\n');
    await writeFile(path.join(repoPath, 'ai-new-2.txt'), 'ai created again\n');

    const { removedUntracked } = await restoreCheckpoint({
      projectPath: repoPath,
      runCommand,
      ref: checkpoint.ref,
    });

    assert.equal(await readFile(path.join(repoPath, 'tracked.txt'), 'utf8'), 'snapshot state\n');
    assert.equal(await readFile(path.join(repoPath, 'pre-existing.txt'), 'utf8'), 'keep me\n');
    assert.deepEqual(removedUntracked.sort(), ['ai-new-2.txt', 'ai-new.txt']);
    await assert.rejects(readFile(path.join(repoPath, 'ai-new.txt'), 'utf8'));
    await assert.rejects(readFile(path.join(repoPath, 'ai-new-2.txt'), 'utf8'));

    // The index must remain untouched after restore too.
    const status = execFileSync('git', ['status', '--porcelain'], { cwd: repoPath }).toString();
    assert.match(status, / M tracked\.txt/);
  } finally {
    await rm(repoPath, { recursive: true, force: true });
  }
});

test('restoreCheckpoint rejects references outside the checkpoint namespace', async () => {
  const repoPath = await createRepo();
  try {
    await assert.rejects(
      restoreCheckpoint({ projectPath: repoPath, runCommand, ref: 'main' }),
      /Invalid checkpoint reference/,
    );
    await assert.rejects(
      restoreCheckpoint({ projectPath: repoPath, runCommand, ref: 'HEAD' }),
      /Invalid checkpoint reference/,
    );
  } finally {
    await rm(repoPath, { recursive: true, force: true });
  }
});
