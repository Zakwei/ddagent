import assert from 'node:assert/strict';
import test from 'node:test';

import { questionAnswerOptionId } from '@/modules/providers/list/devin/devin-runtime.provider.js';

/**
 * Devin answers an AskUserQuestion over the ACP permission protocol, which can
 * only echo a picked optionId — the label must map back positionally.
 */
const params = {
  toolCall: {
    rawInput: {
      question: 'Zakres resetu',
      options: ['Nic nie zmieniam, tylko przegląd', 'Reset konfiguracji'],
    },
  },
  options: [
    { optionId: 'option_0', name: 'Nic nie zmieniam, tylko przegląd: bez zmian' },
    { optionId: 'option_1', name: 'Reset konfiguracji: świeży config' },
  ],
};

test('Devin maps a picked label containing ", " back onto its optionId', () => {
  assert.equal(
    questionAnswerOptionId(params, { answers: { 'Zakres resetu': 'Nic nie zmieniam, tylko przegląd' } }),
    'option_0',
  );
  assert.equal(
    questionAnswerOptionId(params, { answers: { 'Zakres resetu': 'Reset konfiguracji' } }),
    'option_1',
  );
});

test('Devin refuses free text and empty answers', () => {
  assert.equal(questionAnswerOptionId(params, { answers: { 'Zakres resetu': 'custom text' } }), null);
  assert.equal(questionAnswerOptionId(params, { answers: {} }), null);
});
