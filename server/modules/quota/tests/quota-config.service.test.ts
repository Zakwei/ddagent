import assert from 'node:assert/strict';
import test from 'node:test';

import { createQuotaConfigService } from '@/modules/quota/services/quota-config.service.js';

function makeStore(initial: string | null = null) {
  const values = new Map<string, string>();
  if (initial !== null) {
    values.set('quota.config', initial);
  }
  return {
    get: (key: string) => values.get(key) ?? null,
    set: (key: string, value: string) => {
      values.set(key, value);
    },
  };
}

test('returns defaults when nothing is stored', () => {
  const service = createQuotaConfigService({ store: makeStore() });
  const config = service.getConfig();

  assert.equal(config.routingMode, 'manual');
  assert.equal(config.watchThreshold, 75);
  assert.equal(config.dangerThreshold, 90);
  assert.deepEqual(config.accounts, []);
});

test('merges a partial update and persists it', () => {
  const store = makeStore();
  const service = createQuotaConfigService({ store });

  const saved = service.saveConfig({ routingMode: 'ask', watchThreshold: 60 });
  assert.equal(saved.routingMode, 'ask');
  assert.equal(saved.watchThreshold, 60);
  assert.equal(service.getConfig().routingMode, 'ask');
});

test('drops malformed account overrides and clamps thresholds', () => {
  const store = makeStore(
    JSON.stringify({
      watchThreshold: 250,
      accounts: [{ accountId: 'opencode', watchThreshold: -5 }, { watchThreshold: 10 }],
    }),
  );
  const config = createQuotaConfigService({ store }).getConfig();

  assert.equal(config.watchThreshold, 100);
  assert.equal(config.accounts.length, 1);
  assert.equal(config.accounts[0].accountId, 'opencode');
  assert.equal(config.accounts[0].watchThreshold, 0);
});

test('recovers from invalid stored JSON', () => {
  const config = createQuotaConfigService({ store: makeStore('{not json') }).getConfig();
  assert.equal(config.routingMode, 'manual');
});
