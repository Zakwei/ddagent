import assert from 'node:assert/strict';
import test from 'node:test';

import { getModelTier, isAntigravityModel } from './useFavoriteModels';
import type { ProviderModelOption } from '../../../types/app';

test('isAntigravityModel identifies Antigravity models by value, label, or description', () => {
  assert.equal(
    isAntigravityModel({ value: 'google/antigravity-gemini-3.8-flash' }),
    true,
  );
  assert.equal(
    isAntigravityModel({ value: 'google/gemini-2.5-flash', label: 'Gemini 2.5 Flash (Antigravity)' }),
    true,
  );
  assert.equal(
    isAntigravityModel({ value: 'google/custom', description: 'Antigravity provider account' }),
    true,
  );
  assert.equal(
    isAntigravityModel({ value: 'opencode/big-pickle', label: 'Big Pickle' }),
    false,
  );
  assert.equal(isAntigravityModel(null), false);
  assert.equal(isAntigravityModel(undefined), false);
});

test('getModelTier categorizes Antigravity models as paid even if tier is free or cost is 0', () => {
  const antigravityModel: ProviderModelOption = {
    value: 'google/antigravity-gemini-3.8-flash',
    label: 'Gemini 3.8 Flash (Antigravity)',
    tier: 'free',
  };

  assert.equal(getModelTier(antigravityModel), 'paid');

  const antigravityClaude: ProviderModelOption = {
    value: 'google/antigravity-claude-sonnet-4-6-thinking',
    label: 'Claude Sonnet 4.6 Thinking (Antigravity)',
    description: 'Free tier trial',
  };

  assert.equal(getModelTier(antigravityClaude), 'paid');
});

test('getModelTier respects free and paid tiers for non-antigravity models', () => {
  const freeModel: ProviderModelOption = {
    value: 'opencode/big-pickle',
    label: 'Big Pickle',
    tier: 'free',
  };
  assert.equal(getModelTier(freeModel), 'free');

  const freeDescModel: ProviderModelOption = {
    value: 'opencode/custom-free',
    label: 'Custom Free',
    description: 'OpenCode Zen · Free',
  };
  assert.equal(getModelTier(freeDescModel), 'free');

  const paidModel: ProviderModelOption = {
    value: 'openai/gpt-5.6',
    label: 'GPT-5.6',
    tier: 'paid',
  };
  assert.equal(getModelTier(paidModel), 'paid');
});
