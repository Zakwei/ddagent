import assert from 'node:assert/strict';
import test from 'node:test';

import {
  applyModelToDevinSession,
  createUserTurnMessage,
  readModelConfigValue,
  sendFinalAssistantMessage,
} from './devin-runtime.provider.js';
import { DevinSessionsProvider, hasAssistantInJsonl } from './devin-sessions.provider.js';

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

test('hasAssistantInJsonl treats a persisted error as terminal content', () => {
  // A rate-limit turn persists only user + error rows; it must not be treated
  // as an empty transcript or history falls back to the Devin DB and drops it.
  assert.equal(hasAssistantInJsonl([
    { kind: 'text', role: 'user', content: 'run it' },
    { kind: 'error', content: 'Reached free model rate limit.' },
  ]), true);
  // A trailing user turn with no answer/error is still an unfinished turn.
  assert.equal(hasAssistantInJsonl([
    { kind: 'text', role: 'assistant', content: 'old' },
    { kind: 'text', role: 'user', content: 'run it' },
  ]), false);
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

test('applyModelToDevinSession maps compound SWE-2 ids to model + thought_level', async () => {
  const calls = [];
  const state = {
    model: null,
    devinSessionId: 'devin-session-4',
    async sendRequest(method, params) {
      calls.push({ method, params });
      return configPayload(params.value);
    },
  };

  await applyModelToDevinSession(state, 'swe-2-max');

  assert.deepEqual(calls, [
    {
      method: 'session/set_config_option',
      params: { sessionId: 'devin-session-4', configId: 'model', value: 'swe-2-high' },
    },
    {
      method: 'session/set_config_option',
      params: { sessionId: 'devin-session-4', configId: 'thought_level', value: 'max' },
    },
  ]);
  assert.equal(state.model, 'swe-2-max');

  // Already applied — later turns must not re-send it.
  await applyModelToDevinSession(state, 'swe-2-max');
  assert.equal(calls.length, 2);
});

test('applyModelToDevinSession pushes thought_level when the base model already matches', async () => {
  // Resumed session reports the base model — state.model is 'swe-2-high' but
  // the persisted thought_level is unknown (null). Requesting the compound
  // 'swe-2-high' must still push the level, or a session previously at
  // swe-2-max keeps running 'max'.
  const calls = [];
  const state = {
    model: 'swe-2-high',
    thoughtLevel: null,
    devinSessionId: 'devin-session-5',
    async sendRequest(method, params) {
      calls.push({ method, params });
      return configPayload(params.value);
    },
  };

  await applyModelToDevinSession(state, 'swe-2-high');

  assert.equal(calls.length, 2);
  assert.equal(calls[1].params.configId, 'thought_level');
  assert.equal(calls[1].params.value, 'high');
  assert.equal(state.thoughtLevel, 'high');
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

const stubHistory = (t, messages) => {
  const original = DevinSessionsProvider.prototype.fetchHistory;
  DevinSessionsProvider.prototype.fetchHistory = async () => ({ messages });
  t.after(() => { DevinSessionsProvider.prototype.fetchHistory = original; });
};

const emptyTurnState = (overrides = {}) => ({
  appSessionId: 'app-1',
  devinSessionId: 'dev-1',
  terminated: false,
  promptStartedAt: Date.now(),
  lastFinalAssistantId: null,
  assistantBuffer: '',
  persistedAssistantContents: new Set(),
  liveStreamOpen: false,
  jsonlPath: null,
  ...overrides,
});

test('sendFinalAssistantMessage returns false when the only final is the previous turn\'s', async (t) => {
  stubHistory(t, [
    { id: 'u1', kind: 'text', role: 'user', content: 'run it' },
    { id: 'a1', kind: 'text', role: 'assistant', content: 'old final', timestamp: new Date().toISOString() },
  ]);
  const sent = [];
  const state = emptyTurnState({ lastFinalAssistantId: 'a1' });

  const ok = await sendFinalAssistantMessage({ send: (m) => sent.push(m) }, state, { maxRetries: 0, retryDelayMs: 1 });

  assert.equal(ok, false);
  assert.equal(sent.length, 0);
});

test('sendFinalAssistantMessage does not replay a pre-anchor stale final via the timestamp fallback', async (t) => {
  // The stale assistant message predates the user anchor but has a fresh
  // timestamp — the fallback must stay gated on the missing-anchor case.
  stubHistory(t, [
    { id: 'a0', kind: 'text', role: 'assistant', content: 'stale final', timestamp: new Date().toISOString() },
    { id: 'u1', kind: 'text', role: 'user', content: 'go' },
  ]);
  const sent = [];
  const state = emptyTurnState();

  const ok = await sendFinalAssistantMessage({ send: (m) => sent.push(m) }, state, { maxRetries: 0, retryDelayMs: 1 });

  assert.equal(ok, false);
  assert.equal(sent.length, 0);
});
