import assert from 'node:assert/strict';
import test from 'node:test';

import {
  applyModelToDevinSession,
  createUserTurnMessage,
  readModelConfigValue,
} from './devin-runtime.provider.js';

const configPayload = (currentValue) => ({
  configOptions: [
    { id: 'mode', name: 'Session Mode', category: 'mode', currentValue: 'accept-edits' },
    { id: 'model', name: 'Model', category: 'model', currentValue },
  ],
});

test('createUserTurnMessage keeps the turn attachments for the transcript and echo', () => {
  const turn = createUserTurnMessage('popraw quota w opencode go', {
    attachments: [
      { path: '/home/test/.ddagent/assets/shot.png', name: 'shot.png', mimeType: 'image/png' },
      { path: '/home/test/.ddagent/assets/notes.txt', name: 'notes.txt' },
    ],
  }, 'horse-cesium');

  assert.equal(turn.kind, 'text');
  assert.equal(turn.role, 'user');
  assert.equal(turn.content, 'popraw quota w opencode go');
  assert.deepEqual(turn.images, [
    { path: '/home/test/.ddagent/assets/shot.png', name: 'shot.png', mimeType: 'image/png' },
  ]);
  assert.deepEqual(turn.files, [
    { path: '/home/test/.ddagent/assets/notes.txt', name: 'notes.txt' },
  ]);
});

test('createUserTurnMessage omits empty attachment fields', () => {
  const turn = createUserTurnMessage('plain turn', {}, 'horse-cesium');

  assert.equal(turn.images, undefined);
  assert.equal(turn.files, undefined);
});

test('readModelConfigValue reads the model option from a config payload', () => {
  assert.equal(readModelConfigValue(configPayload('swe-2-max')), 'swe-2-max');
  assert.equal(readModelConfigValue({ configOptions: [{ id: 'mode', currentValue: 'accept-edits' }] }), undefined);
  assert.equal(readModelConfigValue(undefined), undefined);
});

test('applyModelToDevinSession switches a resumed session to the chosen model', async () => {
  const calls = [];
  const state = {
    model: 'swe-2-max',
    devinSessionId: 'devin-session-1',
    async sendRequest(method, params) {
      calls.push({ method, params });
      return configPayload(params.value);
    },
  };

  await applyModelToDevinSession(state, 'deepseek-v4-1-flash-max');

  assert.deepEqual(calls, [{
    method: 'session/set_config_option',
    params: { sessionId: 'devin-session-1', configId: 'model', value: 'deepseek-v4-1-flash-max' },
  }]);
  assert.equal(state.model, 'deepseek-v4-1-flash-max');

  // The model is already active — a later turn must not re-send it.
  await applyModelToDevinSession(state, 'deepseek-v4-1-flash-max');
  assert.equal(calls.length, 1);
});

test('applyModelToDevinSession keeps the turn alive when the switch fails', async () => {
  const state = {
    model: 'swe-2-max',
    devinSessionId: 'devin-session-2',
    async sendRequest() {
      throw new Error('ACP error');
    },
  };

  await applyModelToDevinSession(state, 'deepseek-v4-1-flash-max');
  assert.equal(state.model, 'swe-2-max');
});

test('applyModelToDevinSession ignores an empty model', async () => {
  let called = false;
  const state = {
    model: null,
    devinSessionId: 'devin-session-3',
    async sendRequest() {
      called = true;
    },
  };

  await applyModelToDevinSession(state, null);
  await applyModelToDevinSession(state, '');
  assert.equal(called, false);
});
