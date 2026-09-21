import test from 'node:test';
import assert from 'node:assert/strict';

import {
  isAutoReadArmed,
  lastAssistantSpeechText,
  pickDefaultVoice,
  setAutoReadArmed,
  speechText,
} from './voiceAutoRead';

const voice = (name: string, lang = 'en-US', def = false) =>
  ({ name, lang, default: def }) as SpeechSynthesisVoice;

test('pickDefaultVoice prefers quality-flagged voices in the same language', () => {
  const voices = [
    voice('Microsoft Zira', 'en-US'),
    voice('Google US English', 'en-US'),
    voice('Default Robot', 'en-US', true),
  ];
  assert.equal(pickDefaultVoice(voices)?.name, 'Google US English');
});

test('pickDefaultVoice falls back to the default voice when nothing matches', () => {
  const voices = [voice('Alpha'), voice('Beta', 'en-US', true), voice('Gamma')];
  assert.equal(pickDefaultVoice(voices)?.name, 'Beta');
});

test('pickDefaultVoice returns null for an empty list', () => {
  assert.equal(pickDefaultVoice([]), null);
});

test('setAutoReadArmed toggles membership in the armed set', () => {
  setAutoReadArmed('sess-1', true);
  assert.equal(isAutoReadArmed('sess-1'), true);
  setAutoReadArmed('sess-1', false);
  assert.equal(isAutoReadArmed('sess-1'), false);
});

test('speechText strips code fences and caps length', () => {
  assert.equal(speechText('Hello ```const x = 1``` world'), 'Hello world');
  const long = 'a'.repeat(5000);
  assert.equal(speechText(long).length, 4001); // 4000 chars + ellipsis
});

// Regression: raw '<' / '&' (ref_file tags, "<2 min", "R&D") made the Edge TTS
// backend hang, so replies either never played or fell back to the old voice.
test('speechText drops tag-like spans and SSML-breaking characters', () => {
  assert.equal(
    speechText('Krótko. <ref_file file="/tmp/x.ts" /> Dalej <2 min i R&D.'),
    'Krótko. Dalej 2 min i R D.',
  );
});

test('lastAssistantSpeechText returns the last assistant text only', () => {
  const messages = [
    { kind: 'text', role: 'assistant', content: 'first' },
    { kind: 'text', role: 'user', content: 'question' },
    { kind: 'text', role: 'assistant', content: 'final answer' },
  ];
  assert.equal(lastAssistantSpeechText(messages as never), 'final answer');
});
