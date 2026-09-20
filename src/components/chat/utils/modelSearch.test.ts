import assert from 'node:assert/strict';
import test from 'node:test';

import { matchesModelSearch } from './modelSearch';

test('matchesModelSearch matches every whitespace-separated token as a literal substring', () => {
  assert.equal(matchesModelSearch('Anthropic Claude Haiku 4.5', 'claude 4.5'), true);
  assert.equal(matchesModelSearch('Anthropic Claude Haiku 4.5', 'claude 6'), false);
  assert.equal(matchesModelSearch('Anthropic Claude Haiku 4.5', 'chatgpt'), false);
  assert.equal(matchesModelSearch('DeepSeek V4.1 Flash Max', 'flash max'), true);
  assert.equal(matchesModelSearch('DeepSeek V4.1 Flash Max', 'max flash'), true);
});

test('matchesModelSearch is case-insensitive and treats an empty query as match-all', () => {
  assert.equal(matchesModelSearch('GPT-5.6', 'gpt'), true);
  assert.equal(matchesModelSearch('DeepSeek V4.1 Flash Max', ''), true);
  assert.equal(matchesModelSearch('DeepSeek V4.1 Flash Max', '   '), true);
});
