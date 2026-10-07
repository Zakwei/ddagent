import assert from 'node:assert/strict';
import test from 'node:test';

import type { ModelInfo } from '@anthropic-ai/claude-agent-sdk';

import { buildClaudeModelsDefinition } from '@/modules/providers/list/claude/claude-models.provider.js';

const liveModels = [
  {
    value: 'default',
    displayName: 'Default (recommended)',
    description: 'Opus 5 with 1M context · Best for everyday, complex tasks',
    supportsEffort: true,
    supportedEffortLevels: ['low', 'medium', 'high', 'xhigh', 'max'],
  },
  {
    value: 'claude-fable-5-1[1m]',
    displayName: 'Fable',
    description: 'Fable 5.1 · Most capable for your hardest and longest-running tasks',
    supportsEffort: true,
    supportedEffortLevels: ['low', 'medium', 'high', 'xhigh', 'max'],
  },
  {
    value: 'haiku',
    displayName: 'Haiku',
    description: 'Haiku 4.5 · Fastest for quick answers',
  },
] as ModelInfo[];

test('buildClaudeModelsDefinition maps the live CLI catalog onto picker options', () => {
  const definition = buildClaudeModelsDefinition(liveModels);

  assert.ok(definition);
  assert.deepEqual(definition.OPTIONS.map((option) => option.value), [
    'default',
    'claude-fable-5-1[1m]',
    'haiku',
  ]);
  assert.equal(definition.OPTIONS[1].label, 'Fable');
  assert.equal(
    definition.OPTIONS[1].description,
    'Fable 5.1 · Most capable for your hardest and longest-running tasks',
  );
});

test('buildClaudeModelsDefinition exposes effort only for models that support it', () => {
  const definition = buildClaudeModelsDefinition(liveModels);

  assert.equal(definition?.OPTIONS[0].effort?.default, 'high');
  assert.deepEqual(
    definition?.OPTIONS[0].effort?.values.map((level) => level.value),
    ['low', 'medium', 'high', 'xhigh', 'max'],
  );
  assert.equal(definition?.OPTIONS[2].effort, undefined);
});

test('buildClaudeModelsDefinition falls back to the first option when the CLI omits "default"', () => {
  const definition = buildClaudeModelsDefinition([
    { value: 'sonnet', displayName: 'Sonnet', description: 'Sonnet 5' },
  ] as ModelInfo[]);

  assert.equal(definition?.DEFAULT, 'sonnet');
});

test('buildClaudeModelsDefinition prefers the CLI "default" alias as the catalog default', () => {
  assert.equal(buildClaudeModelsDefinition(liveModels)?.DEFAULT, 'default');
});

test('buildClaudeModelsDefinition returns null for an empty or unusable catalog', () => {
  assert.equal(buildClaudeModelsDefinition([]), null);
  assert.equal(buildClaudeModelsDefinition([{ value: '  ' }] as ModelInfo[]), null);
});
