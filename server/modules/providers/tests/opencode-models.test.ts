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

const createExecFile = (output: string, shouldFail = false) => async () => {
  if (shouldFail) {
    throw new Error('opencode not available');
  }
  return { stdout: output, stderr: '' };
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
