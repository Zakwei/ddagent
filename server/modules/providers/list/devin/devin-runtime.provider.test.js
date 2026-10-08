import assert from 'node:assert/strict';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  applyModelToDevinSession,
  createUserTurnMessage,
  resolveDevinAcpModel,
  sendFinalAssistantMessage,
} from './devin-runtime.provider.js';
import { DevinSessionsProvider, hasAssistantInJsonl } from './devin-sessions.provider.js';

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

const ACP_MODELS = ['swe-2-high', 'glm-5-2', 'glm-5-2-1m', 'glm-5-3-flash-max', 'deepseek-v4-1-flash-high', 'swe-1-7-medium'];
const ACP_LEVELS = {
  'swe-2-high': ['medium', 'high', 'max'],
  'glm-5-3-flash-max': ['low', 'high', 'max'],
  'deepseek-v4-1-flash-high': ['high', 'max'],
};

// Shaped like a real `session/set_config_option` result from `devin acp`.
const acpConfig = (model, thoughtLevel) => ({
  configOptions: [
    { id: 'mode', category: 'mode', currentValue: 'accept-edits' },
    { id: 'model', category: 'model', currentValue: model, options: ACP_MODELS.map((value) => ({ value })) },
    ...(ACP_LEVELS[model] ? [{
      id: 'thought_level',
      category: 'thought_level',
      currentValue: thoughtLevel ?? ACP_LEVELS[model].at(-1),
      options: ACP_LEVELS[model].map((value) => ({ value })),
    }] : []),
  ],
});

const fakeDevinState = (overrides = {}) => {
  const calls = [];
  const state = {
    model: 'swe-2-high',
    thoughtLevel: 'max',
    modelOptions: ACP_MODELS,
    devinSessionId: 'devin-session',
    async sendRequest(method, params) {
      calls.push({ method, params });
      return params.configId === 'model' ? acpConfig(params.value) : acpConfig(state.model, params.value);
    },
    ...overrides,
  };
  return { state, calls };
};

test('resolveDevinAcpModel maps catalog variant ids onto the ACP family model + thought_level', () => {
  assert.deepEqual(resolveDevinAcpModel('glm-5-3-flash-low', ACP_MODELS), { model: 'glm-5-3-flash-max', thoughtLevel: 'low' });
  assert.deepEqual(resolveDevinAcpModel('deepseek-v4-1-flash-max', ACP_MODELS), { model: 'deepseek-v4-1-flash-high', thoughtLevel: 'max' });
  assert.deepEqual(resolveDevinAcpModel('swe-2-medium', ACP_MODELS), { model: 'swe-2-high', thoughtLevel: 'medium' });
  assert.deepEqual(resolveDevinAcpModel('swe-2-high', ACP_MODELS), { model: 'swe-2-high', thoughtLevel: 'high' });
  assert.deepEqual(resolveDevinAcpModel('glm-5-2-max-1m', ACP_MODELS), { model: 'glm-5-2-1m', thoughtLevel: 'max' });
  assert.deepEqual(resolveDevinAcpModel('glm-5-2-none', ACP_MODELS), { model: 'glm-5-2', thoughtLevel: 'none' });
  assert.deepEqual(resolveDevinAcpModel('glm-5-2', ACP_MODELS), { model: 'glm-5-2', thoughtLevel: null });
  assert.deepEqual(resolveDevinAcpModel('swe-1-7', ACP_MODELS), { model: 'swe-1-7-medium', thoughtLevel: null });
  // Unknown family or unknown ACP list: passed through untouched.
  assert.deepEqual(resolveDevinAcpModel('mystery-model-high', ACP_MODELS), { model: 'mystery-model-high', thoughtLevel: null });
  assert.deepEqual(resolveDevinAcpModel('glm-5-3-flash-low', []), { model: 'glm-5-3-flash-low', thoughtLevel: null });
});

test('applyModelToDevinSession switches to a catalog variant via model + thought_level', async () => {
  const { state, calls } = fakeDevinState();

  await applyModelToDevinSession(state, 'glm-5-3-flash-low');

  assert.deepEqual(calls.map((call) => [call.params.configId, call.params.value]), [
    ['model', 'glm-5-3-flash-max'],
    ['thought_level', 'low'],
  ]);
  assert.equal(calls[0].params.sessionId, 'devin-session');
  assert.equal(state.model, 'glm-5-3-flash-max');
  assert.equal(state.thoughtLevel, 'low');

  // Already applied — a later turn must not re-send it.
  await applyModelToDevinSession(state, 'glm-5-3-flash-low');
  assert.equal(calls.length, 2);
});

test('applyModelToDevinSession only pushes thought_level when the family model already runs', async () => {
  // A session at swe-2-max reports model swe-2-high + level max; picking
  // swe-2-high must still lower the level.
  const { state, calls } = fakeDevinState();

  await applyModelToDevinSession(state, 'swe-2-high');

  assert.deepEqual(calls.map((call) => [call.params.configId, call.params.value]), [['thought_level', 'high']]);
  assert.equal(state.thoughtLevel, 'high');
});

test('applyModelToDevinSession skips a thought_level the new model does not offer', async () => {
  const { state, calls } = fakeDevinState({
    modelOptions: [...ACP_MODELS, 'claude-opus-5-medium'],
  });

  // `claude-opus-5-low` resolves to claude-opus-5-medium + low, but the
  // fake reports no thought_level option for it, so only the model is set.
  await applyModelToDevinSession(state, 'claude-opus-5-low');
  assert.deepEqual(calls.map((call) => call.params.configId), ['model']);

  const { state: deepseek, calls: deepseekCalls } = fakeDevinState();
  await applyModelToDevinSession(deepseek, 'deepseek-v4-1-flash-low');
  assert.deepEqual(deepseekCalls.map((call) => call.params.configId), ['model']);
  assert.equal(deepseek.model, 'deepseek-v4-1-flash-high');
});

test('applyModelToDevinSession keeps the turn alive when the switch fails', async () => {
  const { state } = fakeDevinState({
    async sendRequest() {
      throw new Error('ACP error');
    },
  });

  await applyModelToDevinSession(state, 'deepseek-v4-1-flash-max');
  assert.equal(state.model, 'swe-2-high');
});

test('applyModelToDevinSession ignores an empty model', async () => {
  const { state, calls } = fakeDevinState();

  await applyModelToDevinSession(state, null);
  await applyModelToDevinSession(state, '');
  assert.equal(calls.length, 0);
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

test('sendFinalAssistantMessage persists the streamed answer when the Devin DB still returns an earlier segment', async (t) => {
  // Narration A streamed and was persisted at a tool boundary; answer B then
  // streamed, but the DB has only written A so far.
  stubHistory(t, [
    { id: 'u1', kind: 'text', role: 'user', content: 'run it' },
    { id: 'a1', kind: 'text', role: 'assistant', content: 'Checking the files.', timestamp: new Date().toISOString() },
  ]);
  const dir = mkdtempSync(path.join(os.tmpdir(), 'devin-final-'));
  t.after(() => rmSync(dir, { recursive: true, force: true }));
  const jsonlPath = path.join(dir, 'turn.jsonl');
  const state = emptyTurnState({
    jsonlPath,
    assistantBuffer: 'All fixed.',
    liveStreamOpen: true,
    persistedAssistantContents: new Set(['Checking the files.']),
  });

  const ok = await sendFinalAssistantMessage({ send() {} }, state, { maxRetries: 0, retryDelayMs: 1 });

  assert.equal(ok, true);
  const rows = readFileSync(jsonlPath, 'utf8').trim().split('\n').map((line) => JSON.parse(line));
  assert.deepEqual(rows.map((row) => [row.kind, row.role, row.content]), [['text', 'assistant', 'All fixed.']]);
});
