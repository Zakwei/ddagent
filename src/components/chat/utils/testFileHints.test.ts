import assert from 'node:assert/strict';
import test from 'node:test';

import { findExistingTest, findTestFileCandidates } from './testFileHints';

test('findTestFileCandidates prefers sibling .test.ts then .test.tsx then __tests__', () => {
  assert.deepEqual(findTestFileCandidates('src/components/chat/hooks/useFoo.ts'), [
    'src/components/chat/hooks/useFoo.test.ts',
    'src/components/chat/hooks/useFoo.test.tsx',
    'src/components/chat/hooks/__tests__/useFoo.test.ts',
    'src/components/chat/hooks/__tests__/useFoo.test.tsx',
  ]);
});

test('findTestFileCandidates handles a bare filename without a directory', () => {
  assert.deepEqual(findTestFileCandidates('useFoo.tsx'), [
    'useFoo.test.ts',
    'useFoo.test.tsx',
    '__tests__/useFoo.test.ts',
    '__tests__/useFoo.test.tsx',
  ]);
});

test('findTestFileCandidates uses .js/.jsx for non-TypeScript sources', () => {
  assert.deepEqual(findTestFileCandidates('src/utils/parse.js'), [
    'src/utils/parse.test.js',
    'src/utils/parse.test.jsx',
    'src/utils/__tests__/parse.test.js',
    'src/utils/__tests__/parse.test.jsx',
  ]);
});

test('findTestFileCandidates normalizes Windows separators', () => {
  assert.deepEqual(findTestFileCandidates('src\\components\\chat\\hooks\\useFoo.ts'), [
    'src/components/chat/hooks/useFoo.test.ts',
    'src/components/chat/hooks/useFoo.test.tsx',
    'src/components/chat/hooks/__tests__/useFoo.test.ts',
    'src/components/chat/hooks/__tests__/useFoo.test.tsx',
  ]);
});

test('findTestFileCandidates returns [] for test/spec inputs and unknown extensions', () => {
  assert.deepEqual(findTestFileCandidates('src/foo.test.ts'), []);
  assert.deepEqual(findTestFileCandidates('src/foo.spec.tsx'), []);
  assert.deepEqual(findTestFileCandidates('styles/main.css'), []);
});

test('findExistingTest returns the first existing candidate across relative and absolute paths', () => {
  const files = [
    '/repo/src/components/chat/hooks/useFoo.test.tsx',
    '/repo/src/components/chat/hooks/__tests__/useFoo.test.ts',
  ];

  assert.equal(
    findExistingTest('src/components/chat/hooks/useFoo.ts', files),
    '/repo/src/components/chat/hooks/useFoo.test.tsx',
  );
});

test('findExistingTest matches a sibling test with the same relative path', () => {
  const files = ['src/components/chat/hooks/useFoo.test.ts', 'src/components/chat/hooks/useBar.ts'];

  assert.equal(
    findExistingTest('src/components/chat/hooks/useFoo.ts', files),
    'src/components/chat/hooks/useFoo.test.ts',
  );
});

test('findExistingTest returns null when no candidate exists or the input is a test', () => {
  assert.equal(findExistingTest('src/foo.ts', ['src/bar.test.ts']), null);
  assert.equal(findExistingTest('src/foo.test.ts', ['src/foo.test.ts']), null);
});

test('findExistingTest handles Windows separators in the edited path', () => {
  const files = ['src\\components\\chat\\hooks\\useFoo.test.ts'];

  assert.equal(
    findExistingTest('src\\components\\chat\\hooks\\useFoo.ts', files),
    'src\\components\\chat\\hooks\\useFoo.test.ts',
  );
});
