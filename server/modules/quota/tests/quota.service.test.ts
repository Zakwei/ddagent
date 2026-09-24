import assert from 'node:assert/strict';
import test from 'node:test';

import { createQuotaService } from '@/modules/quota/services/quota.service.js';
import type { QuotaProviders } from '@/modules/quota/services/quota-providers.service.js';
import type { KanbanCard, QuotaAccount, QuotaWindow } from '@/shared/types.js';

function makeWindow(patch: Partial<QuotaWindow> = {}): QuotaWindow {
  return {
    label: 'Weekly',
    kind: 'weekly',
    percent: 40,
    remainingPercent: 60,
    resetsAt: null,
    status: 'ok',
    projectedExhaustionAt: null,
    etaSeconds: null,
    burnRatePerHour: null,
    ...patch,
  };
}

function makeAccount(patch: Partial<QuotaAccount> = {}): QuotaAccount {
  return {
    id: 'opencode',
    provider: 'opencode',
    providerLabel: 'OpenCode',
    plan: 'OpenCode Go',
    accountLabel: '',
    status: 'active',
    quality: 'live',
    lastSyncedAt: null,
    syncError: null,
    windows: [makeWindow()],
    assignedAgents: [],
    ...patch,
  };
}

/** Provider fake whose returned windows are swapped between reads. */
function createProviders(sweeps: QuotaAccount[][]): { providers: QuotaProviders; loads: () => number } {
  let index = 0;
  return {
    providers: {
      async loadAll() {
        const sweep = sweeps[Math.min(index, sweeps.length - 1)];
        index += 1;
        return sweep;
      },
    },
    loads: () => index,
  };
}

function makeCard(patch: Partial<KanbanCard> = {}): KanbanCard {
  return {
    cardId: 'c1',
    projectId: 'p1',
    title: 'task',
    description: '',
    status: 'working',
    position: 0,
    sessionId: null,
    provider: 'opencode',
    model: null,
    effort: null,
    worktreePath: null,
    branch: null,
    prUrl: null,
    statusMessage: null,
    assigneeUserId: null,
    isArchived: false,
    createdAt: '',
    updatedAt: '',
    ...patch,
  };
}

test('a second read inside the cache window does not hit the providers again', async () => {
  const { providers, loads } = createProviders([[makeAccount()]]);
  const service = createQuotaService({ providers, now: () => 1_000 });

  const first = await service.getSnapshot();
  const second = await service.getSnapshot();

  assert.equal(loads(), 1);
  assert.equal(first.accounts[0].quality, 'live');
  assert.equal(second.accounts[0].quality, 'cached');
});

test('a forced refresh bypasses the cache and reports live quality', async () => {
  const { providers, loads } = createProviders([[makeAccount()]]);
  const service = createQuotaService({ providers, now: () => 1_000 });

  await service.getSnapshot();
  const refreshed = await service.getSnapshot(true);

  assert.equal(loads(), 2);
  assert.equal(refreshed.accounts[0].quality, 'live');
});

test('a rising window projects exhaustion from the observed burn rate', async () => {
  let now = 0;
  const { providers } = createProviders([
    [makeAccount({ windows: [makeWindow({ percent: 40 })] })],
    [makeAccount({ windows: [makeWindow({ percent: 60 })] })],
  ]);
  const service = createQuotaService({ providers, now: () => now });

  await service.getSnapshot();
  now = 3_600_000;
  const { accounts, overview } = await service.getSnapshot(true);
  const [window] = accounts[0].windows;

  assert.equal(window.burnRatePerHour, 20);
  assert.equal(window.etaSeconds, 2 * 3_600);
  assert.equal(window.projectedExhaustionAt, new Date(3 * 3_600_000).toISOString());
  assert.equal(overview.windowsAtRisk, 1);
});

test('a window that resets between samples reports no burn rate', async () => {
  let now = 0;
  const { providers } = createProviders([
    [makeAccount({ windows: [makeWindow({ percent: 40, resetsAt: '2026-01-01T00:00:00.000Z' })] })],
    [makeAccount({ windows: [makeWindow({ percent: 60, resetsAt: '2026-01-08T00:00:00.000Z' })] })],
  ]);
  const service = createQuotaService({ providers, now: () => now });

  await service.getSnapshot();
  now = 3_600_000;
  const { accounts } = await service.getSnapshot(true);

  assert.equal(accounts[0].windows[0].burnRatePerHour, null);
  assert.equal(accounts[0].windows[0].projectedExhaustionAt, null);
});

test('a projection that would land after the reset is not reported as risk', async () => {
  let now = 0;
  const resetsAt = new Date(2 * 3_600_000).toISOString();
  const { providers } = createProviders([
    [makeAccount({ windows: [makeWindow({ percent: 10, resetsAt })] })],
    [makeAccount({ windows: [makeWindow({ percent: 11, resetsAt })] })],
  ]);
  const service = createQuotaService({ providers, now: () => now });

  await service.getSnapshot();
  now = 3_600_000;
  const { accounts } = await service.getSnapshot(true);

  assert.equal(accounts[0].windows[0].projectedExhaustionAt, null);
});

test('the overview counts risky accounts and the earliest upcoming reset', async () => {
  const { providers } = createProviders([
    [
      makeAccount({ id: 'a', windows: [makeWindow({ percent: 80, resetsAt: '2026-01-01T05:00:00.000Z' })] }),
      makeAccount({ id: 'b', windows: [makeWindow({ percent: 20, resetsAt: '2026-01-01T02:00:00.000Z' })] }),
      makeAccount({ id: 'c', status: 'error', quality: 'error', windows: [] }),
    ],
  ]);
  const service = createQuotaService({ providers, now: () => Date.parse('2026-01-01T00:00:00.000Z') });

  const { overview } = await service.getSnapshot();

  assert.equal(overview.accountsAtRisk, 1);
  assert.equal(overview.accountsErrored, 1);
  assert.equal(overview.nextResetAt, '2026-01-01T02:00:00.000Z');
});

test('a failing account keeps error quality even on a cached response', async () => {
  let now = 0;
  const { providers } = createProviders([
    [makeAccount({ id: 'c', status: 'error', quality: 'error', windows: [], syncError: 'HTTP 401' })],
  ]);
  const service = createQuotaService({ providers, now: () => now });

  await service.getSnapshot();
  now = 60_000;
  const { accounts } = await service.getSnapshot();

  assert.equal(accounts[0].quality, 'error');
  assert.equal(accounts[0].syncError, 'HTTP 401');
});

test('an inactive account keeps unknown quality and is not counted as errored', async () => {
  const { providers } = createProviders([
    [makeAccount({ status: 'inactive', quality: 'unknown', windows: [] })],
  ]);
  const service = createQuotaService({ providers, now: () => 1_000 });

  const snapshot = await service.getSnapshot();

  assert.equal(snapshot.accounts[0].quality, 'unknown');
  assert.equal(snapshot.overview.accountsErrored, 0);
});

test('assigned agents skip backlog and done cards', async () => {
  const { providers } = createProviders([[makeAccount()]]);
  const service = createQuotaService({
    providers,
    now: () => 1_000,
    listKanbanCards: () => [
      makeCard({ cardId: 'w', status: 'working', provider: 'opencode' }),
      makeCard({ cardId: 'b', status: 'backlog', provider: 'opencode' }),
      makeCard({ cardId: 'd', status: 'done', provider: 'opencode' }),
    ],
  });

  const snapshot = await service.getSnapshot();

  assert.equal(snapshot.accounts[0].assignedAgents.length, 1);
  assert.equal(snapshot.accounts[0].assignedAgents[0].activeTasks, 1);
});

test('overlapping reads share one provider sweep', async () => {
  const { providers, loads } = createProviders([[makeAccount()]]);
  const service = createQuotaService({ providers, now: () => 1_000 });

  await Promise.all([service.getSnapshot(), service.getSnapshot()]);

  assert.equal(loads(), 1);
});
