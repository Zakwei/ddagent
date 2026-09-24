import assert from 'node:assert/strict';
import test from 'node:test';

import express from 'express';

import { createQuotaRouter } from '@/modules/quota/quota.routes.js';
import type { QuotaRouterServices } from '@/modules/quota/quota.routes.js';
import type { QuotaConfig, QuotaSnapshot } from '@/shared/types.js';

/** Builds the three services the router needs; only quota behaviour is asserted. */
function makeServices(): { services: QuotaRouterServices; forced: boolean[] } {
  const forced: boolean[] = [];
  const snapshot: QuotaSnapshot = {
    overview: {
      accountsAtRisk: 1,
      accountsErrored: 0,
      windowsAtRisk: 2,
      nextResetAt: null,
      watchThreshold: 75,
      dangerThreshold: 90,
    },
    accounts: [],
    generatedAt: '2026-01-01T00:00:00.000Z',
  };
  const config: QuotaConfig = {
    routingMode: 'manual',
    alertsEnabled: true,
    watchThreshold: 75,
    dangerThreshold: 90,
    accounts: [],
  };

  return {
    forced,
    services: {
      quota: {
        async getSnapshot(force = false) {
          forced.push(force);
          return snapshot;
        },
        getConfig: () => config,
        saveConfig: () => config,
        getHistory: (accountId: string) => ({ accountId, points: [] }),
      },
      usage: { getSummary: () => null },
      agents: { getSnapshot: () => null },
    } as unknown as QuotaRouterServices,
  };
}

async function listen(app: express.Express): Promise<{ url: string; close: () => Promise<void> }> {
  const server = app.listen(0, '127.0.0.1');
  await new Promise<void>((resolve) => server.once('listening', () => resolve()));
  const address = server.address();
  const port = typeof address === 'object' && address ? address.port : 0;
  return {
    url: `http://127.0.0.1:${port}`,
    close: () => new Promise<void>((resolve) => server.close(() => resolve())),
  };
}

test('GET / serves a snapshot without forcing a refresh', async () => {
  const { services, forced } = makeServices();
  const app = express().use('/api/quota', createQuotaRouter(services));
  const { url, close } = await listen(app);

  try {
    const response = await fetch(`${url}/api/quota`);
    const body = (await response.json()) as { success: boolean; data: QuotaSnapshot };
    assert.equal(response.status, 200);
    assert.equal(body.success, true);
    assert.equal(body.data.overview.accountsAtRisk, 1);
    assert.deepEqual(forced, [false]);
  } finally {
    await close();
  }
});

test('POST /refresh forces a live read', async () => {
  const { services, forced } = makeServices();
  const app = express().use('/api/quota', createQuotaRouter(services));
  const { url, close } = await listen(app);

  try {
    const response = await fetch(`${url}/api/quota/refresh`, { method: 'POST' });
    assert.equal(response.status, 200);
    assert.deepEqual(forced, [true]);
  } finally {
    await close();
  }
});
