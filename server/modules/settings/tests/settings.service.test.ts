import assert from 'node:assert/strict';
import test from 'node:test';

import { createSettingsService } from '../settings.service.js';

type Dependencies = Parameters<typeof createSettingsService>[0];

function dependencies(overrides: Partial<Dependencies> = {}): Dependencies {
  return {
    apiKeys: { list: () => [], create: () => ({}), remove: () => false, toggle: () => false },
    credentials: { list: () => [], create: () => ({}), remove: () => false, toggle: () => false },
    notifications: {
      getPreferences: () => undefined,
      updatePreferences: () => ({}),
      createEnabledEvent: () => ({}),
      notifyUser: () => undefined,
    },
    pushSubscriptions: { save: () => undefined, remove: () => undefined, count: () => 0 },
    getVapidPublicKey: () => null,
    sendTestPush: async () => [],
    isWebPushConfigured: () => false,
    ...overrides,
  };
}

test('listApiKeys redacts secret values through the service boundary', () => {
  const service = createSettingsService(dependencies({
    apiKeys: {
      list: () => [{ id: 1, api_key: '1234567890-secret' }],
      create: () => ({}), remove: () => false, toggle: () => false,
    },
  }));
  assert.equal(service.listApiKeys(1).apiKeys[0]?.api_key, '1234567890...');
});

test('subscribeToPush persists the subscription and enables Web Push', () => {
  const operations: string[] = [];
  const service = createSettingsService(dependencies({
    pushSubscriptions: {
      save: (_id, endpoint) => operations.push(`save:${endpoint}`),
      remove: () => undefined,
      count: () => 1,
    },
    notifications: {
      getPreferences: () => ({ channels: { webPush: false } }),
      updatePreferences: () => { operations.push('preferences'); return {}; },
      createEnabledEvent: () => ({ code: 'push.enabled' }),
      notifyUser: () => { operations.push('notify'); },
    },
  }));

  service.subscribeToPush(1, {
    endpoint: 'https://push.example.test',
    keys: { p256dh: 'key', auth: 'auth' },
  });
  assert.deepEqual(operations, ['save:https://push.example.test', 'preferences', 'notify']);
});

test('testPush reports subscription count, config state and delivery results', async () => {
  let sent = 0;
  const service = createSettingsService(dependencies({
    pushSubscriptions: { save: () => undefined, remove: () => undefined, count: () => 2 },
    sendTestPush: async () => {
      sent += 1;
      return [{ endpointHost: 'fcm.googleapis.com', ok: true, statusCode: 201, error: null }];
    },
    isWebPushConfigured: () => true,
  }));

  const result = await service.testPush(1);
  assert.equal(sent, 1);
  assert.equal(result.subscriptionCount, 2);
  assert.equal(result.webPushConfigured, true);
  assert.equal(result.results[0]?.ok, true);
});

test('testPush skips sending when no subscription is registered', async () => {
  let sent = 0;
  const service = createSettingsService(dependencies({
    pushSubscriptions: { save: () => undefined, remove: () => undefined, count: () => 0 },
    sendTestPush: async () => { sent += 1; return []; },
  }));

  const result = await service.testPush(1);
  assert.equal(sent, 0);
  assert.equal(result.subscriptionCount, 0);
  assert.deepEqual(result.results, []);
});
