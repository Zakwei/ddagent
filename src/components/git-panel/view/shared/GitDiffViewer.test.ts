import assert from 'node:assert/strict';
import test from 'node:test';

import { buildSplitDiffRows, getEffectiveDiffSettings } from './GitDiffViewer';

test('buildSplitDiffRows pairs removed and added lines by index', () => {
  const rows = buildSplitDiffRows([
    '@@ -1,2 +1,2 @@',
    '-old one',
    '-old two',
    '+new one',
    '+new two',
  ]);

  assert.equal(rows.length, 3);
  assert.deepEqual(rows[0], { kind: 'header', text: '@@ -1,2 +1,2 @@' });
  assert.deepEqual(rows[1], {
    kind: 'content',
    left: { content: '-old one', type: 'removed' },
    right: { content: '+new one', type: 'added' },
  });
  assert.deepEqual(rows[2], {
    kind: 'content',
    left: { content: '-old two', type: 'removed' },
    right: { content: '+new two', type: 'added' },
  });
});

test('buildSplitDiffRows mirrors context on both sides and pads unpaired lines', () => {
  const rows = buildSplitDiffRows([
    'unchanged',
    '-removed only',
    '+added one',
    '+added two',
  ]);

  assert.deepEqual(rows[0], {
    kind: 'content',
    left: { content: 'unchanged', type: 'context' },
    right: { content: 'unchanged', type: 'context' },
  });
  assert.deepEqual(rows[1], {
    kind: 'content',
    left: { content: '-removed only', type: 'removed' },
    right: { content: '+added one', type: 'added' },
  });
  assert.deepEqual(rows[2], {
    kind: 'content',
    left: undefined,
    right: { content: '+added two', type: 'added' },
  });
});

test('buildSplitDiffRows keeps file markers as full-width header rows', () => {
  const rows = buildSplitDiffRows(['diff --git a/x b/x', '--- a/x', '+++ b/x']);
  assert.deepEqual(rows.map((row) => row.kind), ['header', 'header', 'header']);
});

test('getEffectiveDiffSettings defaults to unified and wrapText on mobile touch', () => {
  const mobileSplit = getEffectiveDiffSettings(true, 'split', false);
  assert.deepEqual(mobileSplit, {
    effectiveViewMode: 'unified',
    effectiveWrapText: true,
  });

  const mobileUnified = getEffectiveDiffSettings(true, 'unified', false);
  assert.deepEqual(mobileUnified, {
    effectiveViewMode: 'unified',
    effectiveWrapText: true,
  });
});

test('getEffectiveDiffSettings preserves desktop settings', () => {
  const desktopSplit = getEffectiveDiffSettings(false, 'split', false);
  assert.deepEqual(desktopSplit, {
    effectiveViewMode: 'split',
    effectiveWrapText: false,
  });

  const desktopUnifiedWrapped = getEffectiveDiffSettings(false, 'unified', true);
  assert.deepEqual(desktopUnifiedWrapped, {
    effectiveViewMode: 'unified',
    effectiveWrapText: true,
  });
});
