import assert from 'node:assert/strict';
import test from 'node:test';

import {
  buildSessionTitlePrompt,
  cleanSessionTitle,
} from '@/modules/orchestrator/services/orchestrator-title.service.js';

test('buildSessionTitlePrompt embeds the trimmed user message', () => {
  const prompt = buildSessionTitlePrompt({ content: '  Fix the login redirect  ' });

  assert.ok(prompt.includes('Fix the login redirect'));
});

test('buildSessionTitlePrompt asks for the configured language', () => {
  const prompt = buildSessionTitlePrompt({ content: 'Fix the login redirect', languageName: 'Polish' });

  assert.ok(prompt.includes('Write the title in Polish.'));
});

test('buildSessionTitlePrompt omits the language line when none is configured', () => {
  assert.equal(
    buildSessionTitlePrompt({ content: 'Fix the login redirect' }).includes('Write the title in'),
    false,
  );
  assert.equal(
    buildSessionTitlePrompt({ content: 'Fix the login redirect', languageName: null }).includes('Write the title in'),
    false,
  );
});

test('cleanSessionTitle returns null when nothing usable remains', () => {
  assert.equal(cleanSessionTitle(''), null);
  assert.equal(cleanSessionTitle('   '), null);
  assert.equal(cleanSessionTitle('```\nfix the login redirect\n```'), null);
});

test('cleanSessionTitle strips fences, labels, quotes, and markdown emphasis', () => {
  assert.equal(cleanSessionTitle('```ts\nconst x = 1;\n```\nfix the login redirect'), 'Fix the login redirect');
  assert.equal(cleanSessionTitle('Title: fix the login redirect'), 'Fix the login redirect');
  assert.equal(cleanSessionTitle('"fix the login redirect"'), 'Fix the login redirect');
  assert.equal(cleanSessionTitle('**fix the login redirect**'), 'Fix the login redirect');
});

test('cleanSessionTitle keeps only the first non-empty line', () => {
  assert.equal(cleanSessionTitle('fix the login redirect\nIgnore this trailing line'), 'Fix the login redirect');
});

test('cleanSessionTitle caps the word count at six', () => {
  assert.equal(cleanSessionTitle('one two three four five six seven eight nine'), 'One two three four five six');
});

test('cleanSessionTitle caps the length at sixty characters', () => {
  const title = cleanSessionTitle('a'.repeat(70));

  assert.ok(title);
  assert.equal(title.length, 60);
});

test('cleanSessionTitle applies sentence case', () => {
  assert.equal(cleanSessionTitle('fix the login redirect'), 'Fix the login redirect');
});
