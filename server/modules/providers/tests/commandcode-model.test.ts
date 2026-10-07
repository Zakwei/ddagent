import assert from 'node:assert/strict';
import test from 'node:test';

import { applyModelToCommandCodeSession } from '../list/commandcode/commandcode-runtime.provider.js';

const fakeCommandCodeState = (overrides: Record<string, unknown> = {}) => {
  const calls: Array<{ method: string; params: any }> = [];
  const state: any = {
    model: 'deepseek/deepseek-v4-flash',
    modelOptions: ['deepseek/deepseek-v4-flash', 'zai-org/GLM-5.3', 'moonshotai/Kimi-K3'],
    commandCodeSessionId: 'cc-session',
    async sendRequest(method: string, params: any) {
      calls.push({ method, params });
      return { configOptions: [{ id: 'model', currentValue: params.value }] };
    },
    ...overrides,
  };
  return { state, calls };
};

test('applyModelToCommandCodeSession sends the canonical ACP spelling of a lowercased catalog id', async () => {
  const { state, calls } = fakeCommandCodeState();

  await applyModelToCommandCodeSession(state, 'zai-org/glm-5.3');

  assert.deepEqual(calls.map((call) => call.params.value), ['zai-org/GLM-5.3']);
  assert.equal(state.model, 'zai-org/GLM-5.3');

  // Already running — a later turn with the lowercased id must not re-send.
  await applyModelToCommandCodeSession(state, 'zai-org/glm-5.3');
  assert.equal(calls.length, 1);
});

test('applyModelToCommandCodeSession passes ids through when the ACP list is unknown', async () => {
  const { state, calls } = fakeCommandCodeState({ modelOptions: [] });

  await applyModelToCommandCodeSession(state, 'moonshotai/kimi-k3');

  assert.deepEqual(calls.map((call) => call.params.value), ['moonshotai/kimi-k3']);
});
