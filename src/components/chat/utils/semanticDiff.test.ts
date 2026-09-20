import assert from 'node:assert/strict';
import test from 'node:test';

import { calculateDiffHunks } from './messageTransforms';
import { groupHunksBySymbol, isFormattingOnlyHunk, summarizeHunks } from './semanticDiff';

test('groupHunksBySymbol finds the enclosing function', () => {
  const oldText = 'export function useChatMessages() {\n  const a = 1;\n  return a;\n}\n';
  const newText = 'export function useChatMessages() {\n  const a = 2;\n  return a;\n}\n';
  const hunks = calculateDiffHunks(oldText, newText, 1);
  const labeled = groupHunksBySymbol(oldText, hunks);

  assert.equal(labeled[0].symbol, 'useChatMessages');
});

test('groupHunksBySymbol finds class, const, def and func declarations', () => {
  const cases: Array<{ oldText: string; newText: string; expected: string }> = [
    {
      oldText: 'export class Widget {\n  a = 1;\n}\n',
      newText: 'export class Widget {\n  a = 2;\n}\n',
      expected: 'Widget',
    },
    {
      oldText: 'export const config = {\n  a: 1,\n};\n',
      newText: 'export const config = {\n  a: 2,\n};\n',
      expected: 'config',
    },
    {
      oldText: 'def greet():\n    a = 1\n    return a\n',
      newText: 'def greet():\n    a = 2\n    return a\n',
      expected: 'greet',
    },
    {
      oldText: 'func (s *Server) Start() {\n\ta := 1\n\t_ = a\n}\n',
      newText: 'func (s *Server) Start() {\n\ta := 2\n\t_ = a\n}\n',
      expected: 'Start',
    },
  ];

  for (const { oldText, newText, expected } of cases) {
    const labeled = groupHunksBySymbol(oldText, calculateDiffHunks(oldText, newText, 1));
    assert.equal(labeled[0].symbol, expected);
  }
});

test('groupHunksBySymbol returns null for a change before any declaration', () => {
  const oldText = '#!/usr/bin/env node\nplain line\nmore text\n';
  const newText = '#!/usr/bin/env node\nchanged line\nmore text\n';
  const labeled = groupHunksBySymbol(oldText, calculateDiffHunks(oldText, newText, 1));

  assert.equal(labeled[0].symbol, null);
});

test('isFormattingOnlyHunk is true for whitespace-only changes', () => {
  const oldText = 'function f() {\n    const a = 1;\n    return a;\n}\n';
  const newText = 'function f() {\n  const a = 1;\n  return a;\n}\n';
  const hunks = calculateDiffHunks(oldText, newText, 1);

  assert.equal(isFormattingOnlyHunk(hunks[0]), true);
});

test('isFormattingOnlyHunk is false for a real code change', () => {
  const oldText = 'function f() {\n  const a = 1;\n  return a;\n}\n';
  const newText = 'function f() {\n  const a = 2;\n  return a;\n}\n';
  const hunks = calculateDiffHunks(oldText, newText, 1);

  assert.equal(isFormattingOnlyHunk(hunks[0]), false);
});

test('isFormattingOnlyHunk detects an import reorder', () => {
  const oldText = "import a from 'a';\nimport b from 'b';\n\nconst x = 1;\n";
  const newText = "import b from 'b';\nimport a from 'a';\n\nconst x = 1;\n";
  const hunks = calculateDiffHunks(oldText, newText, 1);

  assert.equal(isFormattingOnlyHunk(hunks[0]), true);
});

test('isFormattingOnlyHunk is false when an import target actually changes', () => {
  const oldText = "import { a } from './a';\nconst x = 1;\n";
  const newText = "import { a } from './b';\nconst x = 1;\n";
  const hunks = calculateDiffHunks(oldText, newText, 1);

  assert.equal(isFormattingOnlyHunk(hunks[0]), false);
});

test('summarizeHunks counts total and formatting-only hunks', () => {
  const oldText = 'const a = 1;\n\nfunction f() {\n  const b = 1;\n  return b;\n}\n';
  const newText = 'const a = 1;\n\nfunction f() {\n    const b = 1;\n    return b;\n}\n';
  const hunks = calculateDiffHunks(oldText, newText, 1);

  assert.deepEqual(summarizeHunks(hunks), { total: 1, formattingOnly: 1 });
});
