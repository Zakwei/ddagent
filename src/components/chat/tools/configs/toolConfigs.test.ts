import assert from 'node:assert/strict';
import test from 'node:test';

import { attachToolTitlePath, resolveToolName } from './toolConfigs';

test('resolveToolName maps Devin ACP file titles onto the file configs', () => {
  assert.equal(resolveToolName('Edit file'), 'Edit');
  assert.equal(resolveToolName('Wrote ./src/a.ts'), 'Write');
  assert.equal(resolveToolName('Edited src/a.ts'), 'Edit');
  assert.equal(resolveToolName('Patched src/a.ts'), 'ApplyPatch');
});

test('resolveToolName leaves titles without a file verb on the default config', () => {
  // Read rows keep the default rendering: their result panel previews the file.
  assert.equal(resolveToolName('Read file'), 'Read file');
  assert.equal(resolveToolName('Ran ls, echo'), 'Ran ls, echo');
  assert.equal(resolveToolName('Read shell'), 'Read shell');
});

test('attachToolTitlePath folds the path from the title into the input', () => {
  assert.deepEqual(
    attachToolTitlePath({ content: 'export const a = 1;' }, 'Wrote ./src/a.ts'),
    { content: 'export const a = 1;', file_path: './src/a.ts' },
  );
});

test('attachToolTitlePath keeps inputs that already carry a path', () => {
  const input = { file_path: '/workspace/src/a.ts', old_string: 'a', new_string: 'b' };
  assert.equal(attachToolTitlePath(input, 'Edit file'), input);
});

test('attachToolTitlePath ignores titles whose path token is not a path', () => {
  const input = { content: 'x' };
  assert.equal(attachToolTitlePath(input, 'Edit file'), input);
  assert.equal(attachToolTitlePath(input, 'Ran node'), input);
  assert.equal(attachToolTitlePath('raw string payload', 'Wrote ./src/a.ts'), 'raw string payload');
});
