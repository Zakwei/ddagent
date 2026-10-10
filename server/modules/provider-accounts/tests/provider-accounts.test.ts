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
import { accountFailoverService } from '@/modules/provider-accounts/index.js';
import { quotaService } from '@/modules/quota/index.js';
import { providerAccountsService } from '@/modules/provider-accounts/provider-accounts.service.js';
import type { AnyRecord } from '@/shared/types.js';
import { createCompleteMessage, createNormalizedMessage } from '@/shared/utils.js';

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

test('account presets redirect Windows home/config vars on win32', async () => {
  const real = Object.getOwnPropertyDescriptor(process, 'platform');
  Object.defineProperty(process, 'platform', { value: 'win32' });
  try {
    await withIsolatedDatabase(() => {
      // HOME-redirect providers must cover USERPROFILE + HOMEDRIVE/HOMEPATH —
      // Windows CLIs read USERPROFILE, not HOME.
      const cmd = providerAccountsService.create({ provider: 'commandcode', label: 'cc' });
      assert.ok(cmd.envOverrides.USERPROFILE?.includes(cmd.id));
      assert.ok(cmd.envOverrides.HOME?.includes(cmd.id));
      assert.ok('HOMEDRIVE' in cmd.envOverrides);
      assert.ok('HOMEPATH' in cmd.envOverrides);

      // XDG-based providers must redirect APPDATA/LOCALAPPDATA instead.
      const opencode = providerAccountsService.create({ provider: 'opencode', label: 'oc' });
      assert.ok(opencode.envOverrides.APPDATA);
      assert.ok(opencode.envOverrides.LOCALAPPDATA);
      assert.ok(opencode.envOverrides.XDG_CONFIG_HOME?.includes(opencode.id));

      // Dedicated config-dir vars work cross-platform unchanged.
      const claude = providerAccountsService.create({ provider: 'claude', label: 'cl' });
      assert.ok(claude.envOverrides.CLAUDE_CONFIG_DIR);
      assert.equal(claude.envOverrides.USERPROFILE, undefined);
    });
  } finally {
    if (real) Object.defineProperty(process, 'platform', real);
  }
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

// ---------------------------------------------------------------------------
// Runtime dispatch: limit hits reach the failover service
// ---------------------------------------------------------------------------

test('a limit hit in a turn the CLI started on its own (follow-up run) is reported', async () => {
  await withIsolatedDatabase(async () => {
    providerAccountsDb.create({
      id: 'acc-1',
      provider: 'claude',
      label: 'A',
      envOverrides: { CLAUDE_CONFIG_DIR: '/tmp/a' },
    });
    sessionsDb.createAppSession('s-follow', 'claude', '/tmp/p', 'hi', 'acc-1');

    const reported: Array<{ accountId: string | null; resetAt: number | null }> = [];
    const originalReport = accountFailoverService.reportLimitHit;
    accountFailoverService.reportLimitHit = async (input, hit) => {
      reported.push({ accountId: input.accountId, resetAt: hit.resetAt });
      return null;
    };
    try {
      const fakeRuntime = {
        hasRuntime: () => true,
        run: async (_p: string, _c: string, options: AnyRecord, writer: AnyRecord) => {
          const message = (fields: AnyRecord) =>
            createNormalizedMessage({ sessionId: 's-follow', provider: 'claude', ...fields } as never);
          writer.send(message({ kind: 'text', content: 'Started two subagents.' }));
          writer.send(createCompleteMessage({ provider: 'claude', sessionId: 's-follow', exitCode: 0 }));
          // A background task reports back: the CLI runs a turn on its own,
          // and that turn runs into the account's limit.
          const followUp = options.openFollowUpRun();
          assert.ok(followUp, 'the finished turn leaves room for a follow-up run');
          followUp.send(message({
            kind: 'text',
            content: "You've hit your session limit · resets 9:30am (Europe/Warsaw)",
          }));
          followUp.send(createCompleteMessage({ provider: 'claude', sessionId: 's-follow', exitCode: 0 }));
        },
        abort: async () => true,
        resolveToolApproval: () => undefined,
        getPendingApprovalsForSession: () => [],
      } as unknown as ProviderRuntimeGateway;

      const result = await dispatchChatCommand(fakeRuntime, {
        sessionId: 's-follow',
        content: 'run the subagents',
        options: {},
        userId: 'u',
        connection: new FakeConnection() as never,
      });
      assert.equal(result.ok, true);
      assert.deepEqual(reported, [{ accountId: 'acc-1', resetAt: null }]);
    } finally {
      accountFailoverService.reportLimitHit = originalReport;
    }
  });
});

test('a limit hit in the dispatched turn is reported once', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('s-direct', 'claude', '/tmp/p', 'hi');

    let reports = 0;
    const originalReport = accountFailoverService.reportLimitHit;
    accountFailoverService.reportLimitHit = async () => {
      reports += 1;
      return null;
    };
    try {
      const fakeRuntime = {
        hasRuntime: () => true,
        run: async (_p: string, _c: string, _options: AnyRecord, writer: AnyRecord) => {
          writer.send(createNormalizedMessage({
            sessionId: 's-direct',
            provider: 'claude',
            kind: 'text',
            content: "You've hit your weekly limit · resets Mon 9am",
          } as never));
          writer.send(createCompleteMessage({ provider: 'claude', sessionId: 's-direct', exitCode: 0 }));
        },
        abort: async () => true,
        resolveToolApproval: () => undefined,
        getPendingApprovalsForSession: () => [],
      } as unknown as ProviderRuntimeGateway;

      await dispatchChatCommand(fakeRuntime, {
        sessionId: 's-direct',
        content: 'go',
        options: {},
        userId: 'u',
        connection: new FakeConnection() as never,
      });
      assert.equal(reports, 1, 'settled by `complete`, not again by the dispatch safety net');
    } finally {
      accountFailoverService.reportLimitHit = originalReport;
    }
  });
});

test("Claude's near-limit warning moves the session's next turn to another account", async () => {
  await withIsolatedDatabase(async () => {
    // No CLAUDE_CONFIG_DIR: both accounts share one store, so carry-over is a no-op.
    providerAccountsDb.create({ id: 'acc-warn-1', provider: 'claude', label: 'W1', envOverrides: { MARK: '1' } });
    providerAccountsDb.create({ id: 'acc-warn-2', provider: 'claude', label: 'W2', envOverrides: { MARK: '2' } });
    sessionsDb.createAppSession('s-warn', 'claude', '/tmp/p', 'hi', 'acc-warn-1');
    accountFailoverService.updateSettings('claude', { autoSwitchOnLimit: true });
    // Pin "before the first quota sweep" (account rows tried in order): the
    // quota module sweeps on load, and a sweep that knows neither test
    // account — fast on a CI box with no agent logins — leaves no target.
    const originalPeek = quotaService.peekAccounts;
    quotaService.peekAccounts = () => null;
    try {

    const envs: unknown[] = [];
    const statuses: string[] = [];
    const fakeRuntime = {
      hasRuntime: () => true,
      run: async (_p: string, _c: string, options: AnyRecord, writer: AnyRecord) => {
        envs.push(options.env);
        if (envs.length === 1) {
          writer.send(createNormalizedMessage({
            sessionId: 's-warn',
            provider: 'claude',
            kind: 'status',
            text: 'Approaching the Claude usage limit (five hour), resets in 1h 38m.',
            notice: true,
            usageLimit: { state: 'warning', resetAt: Date.now() + 98 * 60 * 1000 },
          } as never));
        }
        writer.send(createCompleteMessage({ provider: 'claude', sessionId: 's-warn', exitCode: 0 }));
      },
      abort: async () => true,
      resolveToolApproval: () => undefined,
      getPendingApprovalsForSession: () => [],
    } as unknown as ProviderRuntimeGateway;
    const connection = {
      readyState: 1,
      send: (data: string) => {
        const event = JSON.parse(data) as AnyRecord;
        if (event.kind === 'status' && typeof event.text === 'string') statuses.push(event.text);
      },
    } as never;

    for (const content of ['first', 'second']) {
      const result = await dispatchChatCommand(fakeRuntime, { sessionId: 's-warn', content, options: {}, userId: 'u', connection });
      assert.equal(result.ok, true);
    }
    assert.deepEqual(envs, [{ MARK: '1' }, { MARK: '2' }]);
    assert.equal(sessionsDb.getSessionById('s-warn')?.account_id, 'acc-warn-2');
    assert.ok(statuses.some((text) => /almost reached on "W1".*"W2"/.test(text)), statuses.join(' | '));
    } finally {
      quotaService.peekAccounts = originalPeek;
    }
  });
});

// The per-provider spawn-env matrix lives in
// server/modules/providers/tests/multi-account-env.test.ts (same-module imports
// let it reach the runtime files directly).
