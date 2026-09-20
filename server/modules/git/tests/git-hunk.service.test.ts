import assert from 'node:assert/strict';
import test from 'node:test';

import {
  buildHunkPatch,
  stageHunks,
} from '../git-hunk.service.js';
import type { GitHunkSelection } from '../git-hunk.service.js';

// A three-hunk diff over one file. Each hunk has a distinct body so the tests
// can assert exactly which hunks survived filtering.
const THREE_HUNK_DIFF = [
  'diff --git a/file.txt b/file.txt',
  'index 1111111..2222222 100644',
  '--- a/file.txt',
  '+++ b/file.txt',
  '@@ -1,3 +1,3 @@',
  '-first old',
  '+first new',
  ' context one',
  '@@ -10,3 +10,3 @@',
  '-second old',
  '+second new',
  ' context two',
  '@@ -20,3 +20,3 @@',
  '-third old',
  '+third new',
  ' context three',
  '',
].join('\n');

test('buildHunkPatch keeps only the selected hunk and the file header', () => {
  const patch = buildHunkPatch(THREE_HUNK_DIFF, [1]);

  assert.match(patch, /^diff --git a\/file\.txt b\/file\.txt/);
  assert.match(patch, /^--- a\/file\.txt$/m);
  assert.match(patch, /^\+\+\+ b\/file\.txt$/m);
  assert.match(patch, /@@ -10,3 \+10,3 @@/);
  assert.match(patch, /-second old/);
  assert.doesNotMatch(patch, /-first old/);
  assert.doesNotMatch(patch, /-third old/);
});

test('buildHunkPatch keeps all hunks when every index is selected', () => {
  const patch = buildHunkPatch(THREE_HUNK_DIFF, [0, 1, 2]);

  assert.match(patch, /@@ -1,3 \+1,3 @@/);
  assert.match(patch, /@@ -10,3 \+10,3 @@/);
  assert.match(patch, /@@ -20,3 \+20,3 @@/);
  assert.match(patch, /-first old/);
  assert.match(patch, /-second old/);
  assert.match(patch, /-third old/);
});

test('buildHunkPatch rejects an out-of-range hunk index', () => {
  assert.throws(() => buildHunkPatch(THREE_HUNK_DIFF, [3]), /out of range/);
  assert.throws(() => buildHunkPatch(THREE_HUNK_DIFF, [-1]), /out of range/);
  assert.throws(() => buildHunkPatch(THREE_HUNK_DIFF, [1.5]), /out of range/);
});

test('buildHunkPatch returns an empty string when nothing is selected', () => {
  assert.equal(buildHunkPatch(THREE_HUNK_DIFF, []), '');
  assert.equal(buildHunkPatch('', [0]), '');
});

test('stageHunks invokes the runner with --cached and the selected patch on stdin', async () => {
  const calls: Array<{ args: string[]; input?: string }> = [];
  const runGit = async (_command: string, args: string[], options: { cwd: string; input?: string }) => {
    calls.push({ args, input: options.input });
    return { stdout: '', stderr: '' };
  };

  await stageHunks({
    repositoryRootPath: '/repo',
    filePath: 'file.txt',
    diff: THREE_HUNK_DIFF,
    hunkIndices: [0],
    runGit,
  });

  assert.equal(calls.length, 1);
  assert.deepEqual(calls[0].args, ['apply', '--cached', '--unidiff-zero', '-']);
  assert.match(calls[0].input ?? '', /-first old/);
  assert.doesNotMatch(calls[0].input ?? '', /-second old/);
});

test('stageHunks rejects paths that escape the repository', async () => {
  const runGit = async () => ({ stdout: '', stderr: '' });

  await assert.rejects(
    stageHunks({
      repositoryRootPath: '/repo',
      filePath: '../outside.txt',
      diff: THREE_HUNK_DIFF,
      hunkIndices: [0],
      runGit,
    }),
    /path traversal/,
  );
});

// Referenced type kept exercised so the exported selection shape stays stable.
const selection: GitHunkSelection = { filePath: 'file.txt', hunkIndex: 0 };
assert.equal(selection.hunkIndex, 0);
