import assert from 'node:assert/strict';
import test from 'node:test';

import { calculateDiffHunks, revertHunkInContent } from './messageTransforms';

test('calculateDiffHunks groups changes and keeps context', () => {
  const oldText = 'a\nb\nc\nd\ne\nf\ng\nh';
  const newText = 'a\nb\nc\nD\ne\nf\ng\nh';
  const hunks = calculateDiffHunks(oldText, newText, 1);

  assert.equal(hunks.length, 1);
  assert.equal(hunks[0].oldStart, 3);
  assert.equal(hunks[0].oldBlock, 'c\nd\ne');
  assert.equal(hunks[0].newBlock, 'c\nD\ne');
  assert.deepEqual(
    hunks[0].lines.map((line) => line.type),
    ['context', 'removed', 'added', 'context'],
  );
});

test('revertHunkInContent restores the old block for a single change', () => {
  const oldText = 'one\ntwo\nthree';
  const newText = 'one\n2\nthree';
  const hunk = calculateDiffHunks(oldText, newText)[0];

  assert.equal(revertHunkInContent(newText, hunk), oldText);
});

test('revertHunkInContent reverts only the targeted hunk in a multi-hunk edit', () => {
  const oldText = 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk';
  const newText = 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk';
  const hunks = calculateDiffHunks(oldText, newText, 1);
  assert.equal(hunks.length, 2);

  const afterFirstRevert = revertHunkInContent(newText, hunks[0]);
  assert.equal(afterFirstRevert, 'a\nb\nc\nd\ne\nf\ng\nh\nI\nj\nk');
  const afterSecondRevert = revertHunkInContent(afterFirstRevert, hunks[1]);
  assert.equal(afterSecondRevert, oldText);
});

test('revertHunkInContent is a no-op when the block is absent or the occurrence is stale', () => {
  const oldText = 'x\ny\nz';
  const newText = 'x\nY\nz';
  const hunk = calculateDiffHunks(oldText, newText)[0];

  assert.equal(revertHunkInContent('completely different', hunk), 'completely different');
  assert.equal(revertHunkInContent(newText, hunk, 5), newText);
});

test('revertHunkInContent disambiguates identical repeated blocks by occurrence', () => {
  const oldText = 'dup\na\nmid\ndup\nb';
  const newText = 'dup\na\nmid\ndup\nZ';
  const hunks = calculateDiffHunks(oldText, newText, 1);
  assert.equal(hunks.length, 1);
  assert.equal(hunks[0].oldBlock, 'dup\nb');
  assert.equal(hunks[0].newBlock, 'dup\nZ');

  assert.equal(revertHunkInContent(newText, hunks[0]), oldText);
});
