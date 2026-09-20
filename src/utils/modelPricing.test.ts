import assert from 'node:assert/strict';
import test from 'node:test';

import { estimateCostUsd, formatCostUsd, getModelPrice } from './modelPricing';

test('getModelPrice matches known model substrings', () => {
  assert.ok(getModelPrice('claude-opus-4-6'));
  assert.ok(getModelPrice('claude-3-5-sonnet-20241022'));
  assert.equal(getModelPrice('some-unknown-model'), null);
  assert.equal(getModelPrice(undefined), null);
});

test('estimateCostUsd computes input and output cost', () => {
  const price = getModelPrice('claude-3-5-sonnet-20241022');
  assert.ok(price);
  const cost = estimateCostUsd({
    model: 'claude-3-5-sonnet-20241022',
    inputTokens: 1000,
    outputTokens: 1000,
  });
  assert.ok(cost !== null);
  const expected = (1000 / 1_000_000) * price.input + (1000 / 1_000_000) * price.output;
  assert.ok(Math.abs(cost - expected) < 1e-9);
});

test('estimateCostUsd applies discounted cache read rate', () => {
  const price = getModelPrice('claude-3-5-sonnet-20241022');
  assert.ok(price);
  const cost = estimateCostUsd({
    model: 'claude-3-5-sonnet-20241022',
    inputTokens: 0,
    outputTokens: 0,
    cacheReadTokens: 1_000_000,
  });
  assert.ok(cost !== null);
  assert.ok(Math.abs(cost - price.input * 0.1) < 1e-9);
});

test('estimateCostUsd returns null for unknown model or zero tokens', () => {
  assert.equal(estimateCostUsd({ model: 'nope', inputTokens: 10, outputTokens: 10 }), null);
  assert.equal(estimateCostUsd({ model: 'claude-3-5-sonnet-20241022' }), null);
});

test('estimateCostUsd bills cache writes above the base input rate', () => {
  const price = getModelPrice('claude-3-5-sonnet-20241022');
  assert.ok(price);
  const cost = estimateCostUsd({
    model: 'claude-3-5-sonnet-20241022',
    cacheCreationTokens: 1_000_000,
  });
  assert.ok(cost !== null);
  assert.ok(Math.abs(cost - price.input * 1.25) < 1e-9);
});

test('formatCostUsd formats values', () => {
  assert.equal(formatCostUsd(null), '—');
  assert.equal(formatCostUsd(0), '$0.000');
  assert.equal(formatCostUsd(0.0004), '<$0.001');
  assert.equal(formatCostUsd(0.123), '$0.123');
  assert.equal(formatCostUsd(1.05), '$1.05');
  assert.equal(formatCostUsd(100), '$100');
});
