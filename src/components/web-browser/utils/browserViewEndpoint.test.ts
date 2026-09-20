import assert from 'node:assert/strict';
import test from 'node:test';

import { buildBrowserViewEndpoint } from './browserViewEndpoint';

test('builds an unauthenticated wss endpoint for https pages', () => {
  assert.equal(
    buildBrowserViewEndpoint({ protocol: 'https:', host: 'ddagent.test', token: null }),
    'wss://ddagent.test/browser-view',
  );
});

test('appends an encoded token for oss mode', () => {
  assert.equal(
    buildBrowserViewEndpoint({ protocol: 'http:', host: 'localhost:10087', token: 'a b/c' }),
    'ws://localhost:10087/browser-view?token=a%20b%2Fc',
  );
});
