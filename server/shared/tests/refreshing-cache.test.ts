import assert from 'node:assert/strict';
import { setTimeout as delay } from 'node:timers/promises';
import test from 'node:test';

import { createRefreshingCache } from '@/shared/utils.js';

const TTL_MS = 40;

test('createRefreshingCache serves the cached value without re-loading within the TTL', async () => {
  let loads = 0;
  const cache = createRefreshingCache(async () => {
    loads += 1;
    return 'v1';
  }, TTL_MS, 'fallback');

  assert.equal(await cache.get(), 'v1');
  assert.equal(await cache.get(), 'v1');
  assert.equal(loads, 1);
});

test('createRefreshingCache serves a stale value instantly and re-polls in the background', async () => {
  let loads = 0;
  const pendingLoads: Array<(value: string) => void> = [];
  const cache = createRefreshingCache(async () => {
    loads += 1;
    if (loads === 1) {
      return 'v1';
    }
    return new Promise<string>((resolve) => {
      pendingLoads.push(resolve);
    });
  }, TTL_MS, 'fallback');

  assert.equal(await cache.get(), 'v1');
  await delay(TTL_MS * 2);

  // The loader above blocks until released; get() must still resolve immediately.
  assert.equal(await cache.get(), 'v1');
  assert.equal(loads, 2);

  pendingLoads[0]?.('v2');
  await delay(1);
  assert.equal(cache.peek(), 'v2');
  assert.equal(await cache.get(), 'v2');
});

test('createRefreshingCache serves the fallback on failure and backs off until the next window', async () => {
  let loads = 0;
  const cache = createRefreshingCache(async () => {
    loads += 1;
    throw new Error('agent down');
  }, TTL_MS, 'fallback');

  assert.equal(await cache.get(), 'fallback');
  assert.equal(await cache.get(), 'fallback');
  assert.equal(loads, 1);

  await delay(TTL_MS * 2);
  assert.equal(await cache.get(), 'fallback');
  assert.equal(loads, 2);
});

test('createRefreshingCache forceRefresh reloads and deduplicates in-flight loads', async () => {
  let loads = 0;
  const cache = createRefreshingCache(async () => {
    loads += 1;
    return `v${loads}`;
  }, TTL_MS * 100, 'fallback');

  const [a, b] = await Promise.all([cache.get(), cache.get()]);
  assert.equal(a, b);
  assert.equal(loads, 1);

  assert.equal(await cache.get(true), 'v2');
  assert.equal(loads, 2);
});
