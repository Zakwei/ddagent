import assert from 'node:assert/strict';
import test from 'node:test';

import type { UsageResponse } from './subscriptionAvailability';
import { isModelAvailableIn, isProviderAvailableIn, sectionForModel, sectionPeriodWindows, timeRemainingPercent, timeToneFor } from './subscriptionAvailability';

// Mirrors this machine: devin + commandcode + gemini subscribed, opencode 403.
const snapshot: UsageResponse = {
  devin: { plan: 'Devin Pro', windows: { Dziennie: { status: 'ok', percent: 0, resetsAt: null, kind: 'daily' }, Tygodniowo: { status: 'ok', percent: 12, resetsAt: null, kind: 'weekly' } } },
  commandcode: { plan: 'CommandCode GOAT', windows: { '5h': { status: 'ok', percent: 3, resetsAt: null, kind: 'session' }, 'Weekly': { status: 'ok', percent: 40, resetsAt: null, kind: 'weekly' } } },
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
  // Free-tier models stay visible even when their subscription section is inactive.
  assert.equal(isModelAvailableIn(snapshot, 'opencode', 'opencode/big-pickle', 'free'), true);
  assert.equal(isModelAvailableIn(snapshot, 'devin', 'swe-1-7'), true);
});

test('sectionPeriodWindows returns present session/daily/weekly/monthly with their percent, in order', () => {
  assert.deepEqual(sectionPeriodWindows(snapshot.devin?.windows), [
    { kind: 'daily', percent: 0, resetsAt: null },
    { kind: 'weekly', percent: 12, resetsAt: null },
  ]);
  assert.deepEqual(sectionPeriodWindows(snapshot.commandcode?.windows), [
    { kind: 'session', percent: 3, resetsAt: null },
    { kind: 'weekly', percent: 40, resetsAt: null },
  ]);
  assert.deepEqual(sectionPeriodWindows(undefined), []);
});

test('timeRemainingPercent measures the window clock until reset', () => {
  const now = Date.parse('2026-09-30T00:00:00Z');
  // Weekly (7 d): reset za 3.5 d → zostało 50% czasu okna.
  assert.equal(timeRemainingPercent('weekly', '2026-10-03T12:00:00Z', now), 50);
  // Tuż przed resetem → 0%.
  assert.equal(timeRemainingPercent('daily', '2026-09-30T00:00:00Z', now), 0);
  // Świeżo po resecie (reset za pełne 24 h) → 100%.
  assert.equal(timeRemainingPercent('daily', '2026-10-01T00:00:00Z', now), 100);
  // Brak daty / nieznany kind → null (pigułka zostaje neutralna).
  assert.equal(timeRemainingPercent('weekly', null, now), null);
  assert.equal(timeRemainingPercent('weekly', 'not-a-date', now), null);
});

test('timeToneFor flags the end of a window: ≤25% warn, ≤10% critical', () => {
  assert.equal(timeToneFor(null), 'ok');
  assert.equal(timeToneFor(26), 'ok');
  assert.equal(timeToneFor(25), 'warn');
  assert.equal(timeToneFor(11), 'warn');
  assert.equal(timeToneFor(10), 'critical');
  assert.equal(timeToneFor(0), 'critical');
});
