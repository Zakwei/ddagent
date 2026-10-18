import assert from 'node:assert/strict';
import test from 'node:test';

import {
  OpenCodeProviderModels,
  OPENCODE_PREDEFINED_MODELS,
} from '@/modules/providers/list/opencode/opencode-models.provider.js';

const sampleVerboseOutput = `opencode/big-pickle
{
  "id": "big-pickle",
  "providerID": "opencode",
  "name": "Big Pickle",
  "cost": {
    "input": 0,
    "output": 0,
    "cache": { "read": 0, "write": 0 }
  },
  "limit": { "context": 200000, "output": 32000 },
  "variants": {}
}
opencode-go/qwen3.8-flash
{
  "id": "qwen3.8-flash",
  "providerID": "opencode-go",
  "name": "Qwen3.8 Flash",
  "cost": {
    "input": 0.15,
    "output": 0.47,
    "cache": { "read": 0.016, "write": 0.2 }
  },
  "limit": { "context": 1000000, "output": 131072 },
  "variants": {
    "low": { "reasoningEffort": "low" },
    "medium": { "reasoningEffort": "medium" }
  }
}
google/antigravity-gemini-3.8-flash
{
  "id": "antigravity-gemini-3.8-flash",
  "providerID": "google",
  "name": "Gemini 3.8 Flash (Antigravity)",
  "cost": {
    "input": 0,
    "output": 0,
    "cache": { "read": 0, "write": 0 }
  },
  "limit": { "context": 1000000, "output": 65536 },
  "variants": {}
}`;

// `opencode api model.list --standalone` (OpenCode 2) — the JSON catalog.
const sampleModelListJson = JSON.stringify({
  location: { directory: '/repo' },
  data: [
    {
      id: 'big-pickle',
      modelID: 'big-pickle',
      providerID: 'opencode',
      name: 'Big Pickle',
      cost: { input: 0, output: 0, cache: { read: 0, write: 0 } },
      limit: { context: 200000, output: 32000 },
      variants: {},
      enabled: true,
    },
    {
      id: 'nvidia/nemotron-3.5-super',
      modelID: 'nvidia/nemotron-3.5-super',
      providerID: 'nvidia',
      name: 'Nemotron 3.5 Super',
      limit: { context: 131072 },
      variants: { low: { reasoningEffort: 'low' }, medium: { reasoningEffort: 'medium' } },
      enabled: true,
    },
    {
      id: 'disabled-model',
      modelID: 'disabled-model',
      providerID: 'openai',
      name: 'Disabled',
      enabled: false,
    },
  ],
});

/**
 * Fake CLI: OpenCode 2 answers `api model.list` with JSON; a 1.x binary
 * rejects `api` and only knows `models --verbose`.
 */
const createExecFile = (output: string, shouldFail = false, { v1 = true } = {}) => async (
  _file: string,
  args: string[],
) => {
  if (shouldFail) {
    throw new Error('opencode not available');
  }
  if (args[0] === 'api') {
    if (v1) {
      throw new Error('Unknown command: api');
    }
    return { stdout: output, stderr: '' };
  }
  return { stdout: v1 ? output : '', stderr: '' };
};

test('OpenCodeProviderModels discovers dynamic models with context, tier, and effort', async () => {
  const adapter = new OpenCodeProviderModels({
    execFile: createExecFile(sampleVerboseOutput),
  });

  const models = await adapter.getSupportedModels();

  assert.equal(models.OPTIONS.length, 3);

  const bigPickle = models.OPTIONS.find((option) => option.value === 'opencode/big-pickle');
  assert.ok(bigPickle);
  assert.equal(bigPickle.label, 'Big Pickle');
  assert.equal(bigPickle.context, 200000);
  assert.equal(bigPickle.tier, 'free');
  assert.equal(bigPickle.description, 'OpenCode');
  assert.equal(bigPickle.effort, undefined);

  const qwen = models.OPTIONS.find((option) => option.value === 'opencode-go/qwen3.8-flash');
  assert.ok(qwen);
  assert.equal(qwen.context, 1000000);
  assert.equal(qwen.tier, 'paid');
  assert.equal(qwen.description, 'OpenCode Go');
  assert.deepEqual(qwen.effort?.values.map((v) => v.value), ['low', 'medium']);

  const gemini = models.OPTIONS.find((option) => option.value === 'google/antigravity-gemini-3.8-flash');
  assert.ok(gemini);
  assert.equal(gemini.label, 'Gemini 3.8 Flash (Antigravity)');
  assert.equal(gemini.context, 1000000);
  assert.equal(gemini.tier, 'paid');
  assert.equal(gemini.description, 'Google');

  assert.equal(models.DEFAULT, 'opencode/big-pickle');
});

test('OpenCodeProviderModels does not re-run the CLI for repeat catalog reads', async () => {
  let execCalls = 0;
  const adapter = new OpenCodeProviderModels({
    execFile: async () => {
      execCalls += 1;
      return { stdout: sampleModelListJson, stderr: '' };
    },
  });

  await adapter.getSupportedModels();
  await adapter.getSupportedModels();

  assert.equal(execCalls, 1);
});

test('OpenCodeProviderModels reads the OpenCode 2 JSON catalog and skips disabled models', async () => {
  const calls: string[][] = [];
  const adapter = new OpenCodeProviderModels({
    execFile: async (_file, args) => {
      calls.push(args);
      return { stdout: args[0] === 'api' ? sampleModelListJson : '', stderr: '' };
    },
  });

  const models = await adapter.getSupportedModels();

  assert.deepEqual(calls, [['api', 'model.list', '--standalone']]);
  assert.deepEqual(models.OPTIONS.map((option) => option.value), ['opencode/big-pickle', 'nvidia/nvidia/nemotron-3.5-super']);
  const nemotron = models.OPTIONS[1];
  assert.equal(nemotron.label, 'Nemotron 3.5 Super');
  assert.equal(nemotron.context, 131072);
  assert.equal(nemotron.tier, 'free');
  assert.equal(nemotron.effort?.default, 'medium');
  assert.equal(models.DEFAULT, 'opencode/big-pickle');
});

test('OpenCodeProviderModels falls back to the predefined catalog when the CLI fails', async () => {
  const adapter = new OpenCodeProviderModels({
    execFile: createExecFile('', true),
  });

  const models = await adapter.getSupportedModels();

  assert.equal(models.DEFAULT, OPENCODE_PREDEFINED_MODELS.DEFAULT);
  assert.ok(models.OPTIONS.length > 0);
  assert.ok(
    models.OPTIONS.some((option) => option.value === 'opencode/big-pickle'),
  );
});

test('OpenCodeProviderModels returns the default from the dynamic catalog', async () => {
  const adapter = new OpenCodeProviderModels({
    execFile: createExecFile(sampleVerboseOutput),
  });

  const activeModel = await adapter.getCurrentActiveModel();

  assert.equal(activeModel.model, 'opencode/big-pickle');
});
