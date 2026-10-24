import assert from 'node:assert/strict';
import test from 'node:test';

import { createDiskUsageService } from '../disk-usage.service.js';

const GB = 1024 ** 3;

test('locations on one filesystem collapse into a single volume', async () => {
  const service = createDiskUsageService({
    locations: [
      { kind: 'app', path: '/srv/app' },
      { kind: 'workspace', path: '/srv/ws' },
      { kind: 'data', path: '/data' },
    ],
    stat: async (p) => ({ dev: p.startsWith('/srv') ? 1 : 2 }),
    statfs: async (p) => (p.startsWith('/srv')
      ? { bsize: 1, blocks: 100 * GB, bavail: 50 * GB }
      : { bsize: 1, blocks: 100 * GB, bavail: 4 * GB }),
  });

  const { volumes } = await service.getDiskUsage();

  assert.equal(volumes.length, 2);
  assert.deepEqual(volumes[0].locations.map((l) => l.kind), ['app', 'workspace']);
  assert.equal(volumes[0].freeBytes, 50 * GB);
  assert.equal(volumes[0].low, false);
  assert.equal(volumes[1].low, true);
});

test('low triggers below 10% free even with more than 5 GB left', async () => {
  const service = createDiskUsageService({
    locations: [{ kind: 'app', path: '/a' }],
    stat: async () => ({ dev: 1 }),
    statfs: async () => ({ bsize: 1, blocks: 1000 * GB, bavail: 90 * GB }),
  });

  assert.equal((await service.getDiskUsage()).volumes[0].low, true);
});

test('missing locations are skipped', async () => {
  const service = createDiskUsageService({
    locations: [{ kind: 'workspace', path: '/missing' }],
    stat: async () => {
      throw new Error('ENOENT');
    },
  });

  assert.deepEqual(await service.getDiskUsage(), { volumes: [] });
});
