import assert from 'node:assert/strict';
import test from 'node:test';

import { formatCliToolResult } from '@/shared/utils.js';

const DIFF = 'Index: file.ts\n--- file.ts\n+++ file.ts\n@@\n-\told\n+\tnew';

test('prefers the persisted patch over the terse output', () => {
  const content = formatCliToolResult('Edit applied successfully.', undefined, { diff: DIFF });
  assert.equal(content, DIFF);
});

test('falls back to filediff.patch when metadata.diff is absent', () => {
  const content = formatCliToolResult('Edit applied successfully.', undefined, {
    filediff: { file: 'file.ts', patch: DIFF },
  });
  assert.equal(content, DIFF);
});

test('passes string output through untouched', () => {
  assert.equal(formatCliToolResult('ls -la listing', undefined), 'ls -la listing');
});

test('uses the error text when there is no output', () => {
  assert.equal(formatCliToolResult(undefined, 'Permission denied'), 'Permission denied');
});

test('pretty-prints structured output', () => {
  assert.equal(formatCliToolResult({ a: 1 }, undefined), '{\n  "a": 1\n}');
});

test('returns empty string for a nullish result', () => {
  assert.equal(formatCliToolResult(undefined, undefined), '');
});
