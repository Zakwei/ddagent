import assert from 'node:assert/strict';
import test from 'node:test';

import { collectTurnFileEdits, getBlastRadius } from './blastRadius';

const edit = (filePath: string) => ({
  isToolUse: true,
  toolName: 'Edit',
  toolInput: { file_path: filePath },
});

test('groups edits under the user turn that opened them', () => {
  const turns = collectTurnFileEdits([
    { type: 'user', content: 'one' },
    edit('/a.ts'),
    edit('/b.ts'),
    { type: 'user', content: 'two' },
    edit('/c.ts'),
    edit('/a.ts'),
  ]);
  assert.deepEqual(turns, [
    { turnIndex: 0, files: ['/a.ts', '/b.ts'] },
    { turnIndex: 3, files: ['/c.ts', '/a.ts'] },
  ]);
});

test('dedupes repeated edits within a turn', () => {
  const turns = collectTurnFileEdits([{ type: 'user' }, edit('/a.ts'), edit('/a.ts')]);
  assert.deepEqual(turns[0].files, ['/a.ts']);
});

test('drops turns without edits', () => {
  const turns = collectTurnFileEdits([{ type: 'user' }, { type: 'user' }]);
  assert.deepEqual(turns, []);
});

test('getBlastRadius returns sibling files across turns', () => {
  const messages = [
    { type: 'user', content: 'one' },
    edit('/a.ts'),
    edit('/b.ts'),
    { type: 'user', content: 'two' },
    edit('/a.ts'),
    edit('/c.ts'),
  ];
  assert.deepEqual(getBlastRadius(messages, '/a.ts'), ['/b.ts', '/c.ts']);
  assert.deepEqual(getBlastRadius(messages, '/unknown.ts'), []);
});
