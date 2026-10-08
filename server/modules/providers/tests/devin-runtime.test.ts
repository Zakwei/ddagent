import assert from 'node:assert/strict';
import test from 'node:test';

import {
  acpToolContentText,
  applyPermissionModeToDevinSession,
  isEditPermissionRequest,
  questionAnswerOptionId,
  withKnownDevinToolCall,
} from '@/modules/providers/list/devin/devin-runtime.provider.js';

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

test('acceptEdits auto-approves only ACP edit kinds, never shell titles that mention files', () => {
  assert.equal(isEditPermissionRequest({ toolCall: { kind: 'edit', title: 'Edit: a.ts' } }), true);
  assert.equal(isEditPermissionRequest({ toolCall: { kind: 'execute', title: 'Shell: rm -rf ./profile' } }), false);
  assert.equal(isEditPermissionRequest({ toolCall: { kind: 'execute', title: 'kubectl apply -f file.yaml' } }), false);
  assert.equal(isEditPermissionRequest({ toolCall: { title: 'Write file' } }), false);
});

const modeState = (overrides: Record<string, unknown> = {}) => {
  const calls: Array<{ method: string; params: any }> = [];
  const sent: any[] = [];
  const state: any = {
    devinSessionId: 'dev-1',
    currentModeId: 'ask',
    // What `devin acp` (3000.x) offers in session/new.
    availableModeIds: ['accept-edits', 'smart', 'ask', 'plan', 'bypass'],
    currentWriter: { send: (message: any) => sent.push(message) },
    async sendRequest(method: string, params: any) {
      calls.push({ method, params });
      return {};
    },
    ...overrides,
  };
  return { state, calls, sent };
};

test('Devin permission modes map onto the real ACP mode ids', async () => {
  for (const [mode, modeId] of [
    ['bypassPermissions', 'bypass'],
    ['acceptEdits', 'accept-edits'],
    ['default', 'accept-edits'],
    ['auto', 'smart'],
    ['plan', 'plan'],
  ]) {
    const { state, calls } = modeState();
    await applyPermissionModeToDevinSession(state, mode);
    assert.deepEqual(calls, [{ method: 'session/set_mode', params: { sessionId: 'dev-1', modeId } }]);
    assert.equal(state.currentModeId, modeId);
  }
  // A session left in bypass is switched back when the user picks default.
  const { state, calls } = modeState({ currentModeId: 'bypass' });
  await applyPermissionModeToDevinSession(state, 'default');
  assert.equal(calls[0].params.modeId, 'accept-edits');
  // Already in the target mode: nothing is sent.
  await applyPermissionModeToDevinSession(state, 'default');
  assert.equal(calls.length, 1);
});

test('Devin surfaces an unavailable or failed mode switch as a notice', async () => {
  const unavailable = modeState({ availableModeIds: ['accept-edits', 'ask'] });
  await applyPermissionModeToDevinSession(unavailable.state, 'bypassPermissions');
  assert.equal(unavailable.calls.length, 0);
  assert.equal(unavailable.sent[0].notice, true);

  const failing = modeState({ async sendRequest() { throw new Error('bad mode'); } });
  await applyPermissionModeToDevinSession(failing.state, 'acceptEdits');
  assert.equal(failing.state.currentModeId, 'ask');
  assert.match(failing.sent[0].text, /bad mode/);
});

test('ACP tool content renders diffs and falls back to rawOutput', () => {
  assert.equal(
    acpToolContentText({ content: [{ type: 'diff', path: 'a.ts', oldText: 'x', newText: 'y\nz' }] }),
    '--- a.ts\n+++ a.ts\n-x\n+y\n+z',
  );
  assert.equal(
    acpToolContentText({ content: [{ type: 'content', content: { type: 'text', text: 'ok' } }] }),
    'ok',
  );
  assert.equal(acpToolContentText({ content: [{ type: 'terminal', terminalId: 't1' }], rawOutput: { output: 'ls out' } }), 'ls out');
  assert.equal(acpToolContentText({ rawOutput: 'plain' }), 'plain');
  assert.equal(acpToolContentText({}), '');
});

test('Devin asks that carry only a toolCallId borrow title, kind and input from the tool_call', () => {
  const state = { knownToolCalls: new Map([['t1', { title: 'Ran touch', kind: 'execute', rawInput: { command: 'touch x' } }]]) };
  const merged = withKnownDevinToolCall(state, { toolCall: { toolCallId: 't1' }, options: [] });
  assert.equal(merged.toolCall.title, 'Ran touch');
  assert.equal(merged.toolCall.kind, 'execute');
  assert.deepEqual(merged.toolCall.rawInput, { command: 'touch x' });
  assert.equal(isEditPermissionRequest(merged), false);
  const own = withKnownDevinToolCall(state, { toolCall: { toolCallId: 't1', title: 'Own title' } });
  assert.equal(own.toolCall.title, 'Own title');
});
