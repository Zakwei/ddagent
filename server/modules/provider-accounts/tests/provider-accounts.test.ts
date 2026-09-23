import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  initializeDatabase,
  providerAccountsDb,
  sessionsDb,
} from '@/modules/database/index.js';
import { sessionsService } from '@/modules/providers/index.js';
import {
  chatRunRegistry,
  connectedClients,
  dispatchChatCommand,
  type ProviderRuntimeGateway,
} from '@/modules/websocket/index.js';
import { providerAccountsService } from '@/modules/provider-accounts/provider-accounts.service.js';
import type { AnyRecord } from '@/shared/types.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-accounts-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    connectedClients.clear();
    chatRunRegistry.clearAll();
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

class FakeConnection {
  readyState = 1;
  send(_data: string): void {}
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

test('providerAccountsDb: CRUD and per-provider default exclusivity', async () => {
  await withIsolatedDatabase(() => {
    providerAccountsDb.create({
      id: 'acc-a',
      provider: 'claude',
      label: 'Personal',
      envOverrides: { CLAUDE_CONFIG_DIR: '/tmp/a' },
      isDefault: true,
    });
    providerAccountsDb.create({
      id: 'acc-b',
      provider: 'claude',
      label: 'Work',
      envOverrides: { CLAUDE_CONFIG_DIR: '/tmp/b' },
      isDefault: true,
    });

    assert.equal(providerAccountsDb.get('acc-a')?.isDefault, false, 'second default clears the first');
    assert.equal(providerAccountsDb.getDefault('claude')?.id, 'acc-b');

    const renamed = providerAccountsDb.update('acc-b', { label: 'Work 2' });
    assert.equal(renamed?.label, 'Work 2');

    assert.equal(providerAccountsDb.remove('acc-a'), true);
    assert.equal(providerAccountsDb.list('claude').length, 1);
  });
});

// ---------------------------------------------------------------------------
// Service validation
// ---------------------------------------------------------------------------

test('providerAccountsService.create rejects invalid env keys and applies presets', async () => {
  await withIsolatedDatabase(() => {
    assert.throws(
      () =>
        providerAccountsService.create({
          provider: 'claude',
          label: 'bad',
          envOverrides: { 'BAD KEY!': 'x' },
        }),
      /Invalid env var name/,
    );

    const account = providerAccountsService.create({ provider: 'claude', label: 'Home' });
    assert.ok(
      account.envOverrides.CLAUDE_CONFIG_DIR?.includes(account.id),
      'claude preset isolates CLAUDE_CONFIG_DIR under ~/.ddagent/accounts/<id>',
    );

    const codex = providerAccountsService.create({ provider: 'codex', label: 'OSS' });
    assert.ok(codex.envOverrides.CODEX_HOME?.includes(codex.id));
  });
});

// ---------------------------------------------------------------------------
// Session binding + fallback
// ---------------------------------------------------------------------------

test('session create: explicit account wins, default fills in, none stays ambient', async () => {
  await withIsolatedDatabase(async () => {
    providerAccountsDb.create({
      id: 'acc-def',
      provider: 'claude',
      label: 'Default',
      envOverrides: { CLAUDE_CONFIG_DIR: '/tmp/def' },
      isDefault: true,
    });

    sessionsDb.createAppSession('s-explicit', 'claude', '/tmp/p1', 'hi', 'acc-def');
    assert.equal(sessionsDb.getSessionById('s-explicit')?.account_id, 'acc-def');

    // No explicit id → the provider's default account row.
    const created = sessionsService.createAppSession('claude', '/tmp/p2', 'hi');
    assert.equal(sessionsDb.getSessionById(created.sessionId)?.account_id, 'acc-def');

    // A provider with no default row → ambient env (NULL).
    const codex = sessionsService.createAppSession('codex', '/tmp/p3', 'hi');
    assert.equal(sessionsDb.getSessionById(codex.sessionId)?.account_id ?? null, null);

    // Unknown account id is a hard 400, not a silent fallback.
    assert.throws(
      () => sessionsService.createAppSession('claude', '/tmp/p4', 'hi', 'nope'),
      /accountId does not belong/,
    );
  });
});

// ---------------------------------------------------------------------------
// Runtime dispatch: env overrides reach the provider
// ---------------------------------------------------------------------------

test('dispatchChatCommand passes account envOverrides as options.env; deleted account falls back', async () => {
  await withIsolatedDatabase(async () => {
    providerAccountsDb.create({
      id: 'acc-1',
      provider: 'claude',
      label: 'A',
      envOverrides: { CLAUDE_CONFIG_DIR: '/tmp/a' },
    });
    sessionsDb.createAppSession('s1', 'claude', '/tmp/p', 'hi', 'acc-1');

    const seen: AnyRecord[] = [];
    const fakeRuntime = {
      hasRuntime: () => true,
      run: async (_p: string, _c: string, options: AnyRecord) => {
        seen.push(options);
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    } as unknown as ProviderRuntimeGateway;
    const connection = new FakeConnection() as never;

    const result = await dispatchChatCommand(fakeRuntime, {
      sessionId: 's1',
      content: 'hello',
      options: {},
      userId: 'u',
      connection,
    });
    assert.equal(result.ok, true);
    assert.deepEqual(seen[0]?.env, { CLAUDE_CONFIG_DIR: '/tmp/a' });

    // Removing the account: the session keeps running on ambient env.
    providerAccountsDb.remove('acc-1');
    const result2 = await dispatchChatCommand(fakeRuntime, {
      sessionId: 's1',
      content: 'hello again',
      options: {},
      userId: 'u',
      connection,
    });
    assert.equal(result2.ok, true);
    assert.equal(seen[1]?.env, undefined);
  });
});

// The per-provider spawn-env matrix lives in
// server/modules/providers/tests/multi-account-env.test.ts (same-module imports
// let it reach the runtime files directly).
