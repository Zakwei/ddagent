import assert from 'node:assert/strict';
import test from 'node:test';

import type { UsageResponse } from './subscriptionAvailability';
import { isModelAvailableIn, isProviderAvailableIn, sectionForModel } from './subscriptionAvailability';

// Mirrors this machine: devin + commandcode + gemini subscribed, opencode 403.
const snapshot: UsageResponse = {
  devin: { plan: 'Devin Pro', windows: { Dziennie: { status: 'ok', percent: 0, resetsAt: null } } },
  commandcode: { plan: 'CommandCode GOAT', windows: { '5h': { status: 'ok', percent: 3, resetsAt: null } } },
  gemini: { plan: 'Gemini', windows: { 'Gemini Models': { status: 'ok', percent: 0, resetsAt: null } } },
  opencode: { plan: 'OpenCode Go', error: 'EntitlementError: subscription required' },
};

test('sectionForModel maps model ids to usage sections', () => {
  assert.equal(sectionForModel('commandcode/claude-opus-5'), 'commandcode');
  assert.equal(sectionForModel('opencode-go/deepseek-v4-flash'), 'opencode');
  assert.equal(sectionForModel('opencode/big-pickle'), 'opencode');
  assert.equal(sectionForModel('google/antigravity-gemini-3.8-flash'), 'gemini');
  assert.equal(sectionForModel('nvidia/moonshotai/kimi-k3'), 'byok');
  assert.equal(sectionForModel('anthropic/claude-opus-5'), null);
  assert.equal(sectionForModel(undefined), null);
});

test('unknown snapshot filters nothing (fail-open)', () => {
  assert.equal(isModelAvailableIn(null, 'claude', 'default'), true);
  assert.equal(isProviderAvailableIn(null, 'codex'), true);
});

test('subscribed provider stays, unsubscribed disappears', () => {
  assert.equal(isProviderAvailableIn(snapshot, 'devin'), true);
  assert.equal(isProviderAvailableIn(snapshot, 'opencode'), true);
  assert.equal(isProviderAvailableIn(snapshot, 'claude'), false);
  assert.equal(isProviderAvailableIn(snapshot, 'codex'), false);
  assert.equal(isProviderAvailableIn(snapshot, 'cursor'), false);
});

test('model options filter by their subscription prefix', () => {
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'commandcode/claude-opus-5'), true);
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'google/antigravity-gemini-3.8-flash'), true);
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'opencode-go/deepseek-v4-flash'), false);
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'opencode/big-pickle'), false);
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'anthropic/claude-opus-5'), false);
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'nvidia/moonshotai/kimi-k3'), true);
  assert.equal(isModelAvailableIn(snapshot, 'devin', 'swe-1-7'), true);
});
