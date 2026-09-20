import assert from 'node:assert/strict';
import test from 'node:test';

import { createUsageService } from '@/modules/quota/services/usage.service.js';
import type { InsightSession, InsightSource } from '@/modules/quota/services/insights-source.service.js';

const HOUR = 3_600;

function makeSession(patch: Partial<InsightSession> = {}): InsightSession {
  return {
    source: 'opencode',
    sourceId: 's1',
    title: 'task',
    agent: 'builder',
    model: 'claude-sonnet-4-6',
    subscription: 'opencode-go',
    provider: 'opencode',
    tokensInput: 1_000_000,
    tokensOutput: 0,
    tokensReasoning: 0,
    tokensCacheRead: 0,
    tokensCacheWrite: 0,
    apiCalls: 1,
    costUsd: 3,
    startedAt: HOUR * 2,
    endedAt: HOUR * 2 + 60,
    ...patch,
  };
}

function makeSource(sessions: InsightSession[]): InsightSource {
  return {
    available: true,
    path: '/tmp/tokboard.db',
    loadSessions: () => sessions,
    priceFor: (model) =>
      model === 'claude-sonnet-4-6' ? { input: 3, output: 15, cacheRead: 0.3 } : null,
  };
}

test('groups totals by the requested dimension and sorts by tokens', () => {
  const source = makeSource([
    makeSession({ sourceId: 'a', provider: 'opencode', tokensInput: 1_000_000 }),
    makeSession({ sourceId: 'b', provider: 'anthropic', tokensInput: 2_000_000 }),
  ]);
  const service = createUsageService({ source, now: () => HOUR * 3 * 1000 });

  const summary = service.getSummary({ period: '24h', groupBy: 'provider' });

  assert.equal(summary.buckets.length, 2);
  assert.equal(summary.buckets[0].key, 'anthropic');
  assert.equal(summary.buckets[0].tokensTotal, 2_000_000);
  assert.equal(summary.buckets[1].key, 'opencode');
  assert.equal(summary.totals.sessions, 2);
});

test('filters out sessions older than the period', () => {
  const now = 100 * HOUR * 1000;
  const source = makeSource([
    makeSession({ sourceId: 'recent', startedAt: 99 * HOUR, endedAt: 99 * HOUR }),
    makeSession({ sourceId: 'old', startedAt: HOUR, endedAt: HOUR }),
  ]);
  const service = createUsageService({ source, now: () => now });

  const summary = service.getSummary({ period: '24h', groupBy: 'provider' });

  assert.equal(summary.totals.sessions, 1);
});

test('reports cache savings and subscription value from the price table', () => {
  const source = makeSource([
    makeSession({
      sourceId: 'cached',
      tokensInput: 0,
      tokensOutput: 0,
      tokensCacheRead: 1_000_000,
      costUsd: 0.3,
    }),
    makeSession({ sourceId: 'plan', tokensInput: 1_000_000, tokensOutput: 0, costUsd: 0 }),
  ]);
  const service = createUsageService({ source, now: () => HOUR * 3 * 1000 });

  const summary = service.getSummary({ period: '24h', groupBy: 'provider' });

  // Cache reads: 1M at the 0.30 cache rate vs 3.00 input rate → 2.70 saved.
  assert.ok(Math.abs(summary.cacheSavingsUsd - 2.7) < 1e-9);
  // List price = 0.30 (cache reads) + 3.00 (plan input); billed = 0.30.
  assert.ok(Math.abs(summary.effectiveCost.listPriceUsd - 3.3) < 1e-9);
  assert.ok(Math.abs(summary.effectiveCost.subscriptionValueUsd - 3) < 1e-9);
});

test('builds a daily trend and reports an unavailable source', () => {
  const source = makeSource([
    makeSession({ sourceId: 'd1', endedAt: Date.parse('2026-01-01T10:00:00Z') / 1000 }),
    makeSession({ sourceId: 'd2', endedAt: Date.parse('2026-01-02T10:00:00Z') / 1000 }),
  ]);
  const service = createUsageService({ source, now: () => Date.parse('2026-01-03T00:00:00Z') });

  const summary = service.getSummary({ period: 'all', groupBy: 'model' });
  assert.deepEqual(
    summary.trend.map((point) => point.date),
    ['2026-01-01', '2026-01-02'],
  );

  const unavailable = createUsageService({
    source: { ...source, available: false },
    now: () => 0,
  });
  assert.equal(unavailable.getSummary({ period: 'all', groupBy: 'model' }).source, 'unavailable');
});
