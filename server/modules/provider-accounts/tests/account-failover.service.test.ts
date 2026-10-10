import assert from 'node:assert/strict';
import test from 'node:test';

import type { ProviderAccount } from '@/modules/database/index.js';
import { createAccountFailoverService } from '@/modules/provider-accounts/account-failover.service.js';
import type { LLMProvider, QuotaAccount, QuotaWindow } from '@/shared/types.js';

const NOW = Date.parse('2026-10-08T12:00:00Z');

function window(label: string, percent: number): QuotaWindow {
  return {
    label,
    kind: 'session',
    percent,
    remainingPercent: 100 - percent,
    resetsAt: null,
    status: percent >= 100 ? 'exceeded' : 'ok',
    projectedExhaustionAt: null,
    etaSeconds: null,
    burnRatePerHour: null,
  };
}

function quotaEntry(provider: string, accountId: string | null, windows: QuotaWindow[]): QuotaAccount {
  return {
    id: accountId ?? provider,
    accountId,
    provider,
    providerLabel: provider,
    plan: 'max',
    accountLabel: accountId ?? 'ambient',
    accountEmail: '',
    status: 'active',
    quality: 'live',
    lastSyncedAt: null,
    syncError: null,
    windows,
    assignedAgents: [],
  };
}

function account(id: string, provider: LLMProvider, isDefault = false): ProviderAccount {
  return {
    id,
    provider,
    label: `Label ${id}`,
    envOverrides: { CLAUDE_CONFIG_DIR: `/accounts/${id}` },
    isDefault,
    createdAt: '2026-10-01T00:00:00Z',
  } as ProviderAccount;
}

function setup(options: {
  enabled?: boolean;
  accounts?: ProviderAccount[];
  quota?: QuotaAccount[] | null;
  carryOver?: boolean;
  queueAccepts?: boolean;
}) {
  const store = new Map<string, string>();
  const moves: Array<{ sessionId: string; accountId: string | null }> = [];
  const carried: Array<{ fromEnv: Record<string, string>; toEnv: Record<string, string> }> = [];
  const queued: Array<{ sessionId: string; content: string; options: Record<string, unknown> }> = [];
  let refreshes = 0;
  let now = NOW;
  const service = createAccountFailoverService({
    store: { get: (key) => store.get(key) ?? null, set: (key, value) => void store.set(key, value) },
    listAccounts: (provider) => (options.accounts ?? []).filter((row) => row.provider === provider),
    setSessionAccount: (sessionId, accountId) => void moves.push({ sessionId, accountId }),
    readQuotaAccounts: async () => options.quota ?? null,
    refreshQuota: () => void (refreshes += 1),
    carryOverConversation: (input) => {
      carried.push({ fromEnv: input.fromEnv, toEnv: input.toEnv });
      return options.carryOver ?? true;
    },
    queueContinuation: async (input) => {
      if (options.queueAccepts === false) return false;
      queued.push({ sessionId: input.sessionId, content: input.content, options: input.options });
      return true;
    },
    now: () => now,
  });
  if (options.enabled) service.updateSettings('claude', { autoSwitchOnLimit: true });
  return {
    service,
    moves,
    carried,
    queued,
    refreshes: () => refreshes,
    advance: (ms: number) => void (now += ms),
  };
}

const SWITCH = { fromAccountId: 'a', fromLabel: 'Label a', toAccountId: 'b', toLabel: 'Label b' };

const turn = (accountId: string | null, providerSessionId: string | null = null, model = 'opus') => ({
  sessionId: 's1',
  provider: 'claude' as LLMProvider,
  accountId,
  providerSessionId,
  model,
});

test('auto-switch is off by default and is stored per agent', () => {
  const { service } = setup({});
  assert.deepEqual(service.getSettings('claude'), { autoSwitchOnLimit: false });
  service.updateSettings('claude', { autoSwitchOnLimit: true });
  service.updateSettings('codex', { autoSwitchOnLimit: false });
  assert.deepEqual(service.getSettings('claude'), { autoSwitchOnLimit: true });
  assert.deepEqual(service.getSettings('codex'), { autoSwitchOnLimit: false });
  assert.deepEqual(service.getSettings('devin'), { autoSwitchOnLimit: false });
});

test("another agent's setting does not enable switching", async () => {
  const { service, moves } = setup({
    accounts: [account('a', 'claude'), account('b', 'claude')],
    quota: [quotaEntry('claude', 'a', [window('5h', 100)]), quotaEntry('claude', 'b', [window('5h', 10)])],
  });
  service.updateSettings('codex', { autoSwitchOnLimit: true });
  assert.equal(await service.prepareTurnAccount(turn('a')), null);
  assert.deepEqual(moves, []);
});

test('disabled setting never moves an exhausted session', async () => {
  const { service, moves } = setup({
    accounts: [account('a', 'claude'), account('b', 'claude')],
    quota: [quotaEntry('claude', 'a', [window('5h', 100)]), quotaEntry('claude', 'b', [window('5h', 10)])],
  });
  assert.equal(await service.prepareTurnAccount(turn('a')), null);
  assert.deepEqual(moves, []);
});

test('exhausted manual pick moves to the same-provider account with the most headroom', async () => {
  const { service, moves } = setup({
    enabled: true,
    accounts: [account('a', 'claude'), account('b', 'claude'), account('c', 'claude'), account('x', 'codex')],
    quota: [
      quotaEntry('claude', 'a', [window('5h', 100)]),
      quotaEntry('claude', 'b', [window('5h', 60)]),
      quotaEntry('claude', 'c', [window('5h', 20)]),
      quotaEntry('codex', 'x', [window('5h', 0)]),
    ],
  });
  const change = await service.prepareTurnAccount(turn('a'));
  assert.equal(change?.toAccountId, 'c');
  assert.equal(change?.fromLabel, 'Label a');
  assert.deepEqual(moves, [{ sessionId: 's1', accountId: 'c' }]);
});

test('account with headroom keeps its session', async () => {
  const { service, moves } = setup({
    enabled: true,
    accounts: [account('a', 'claude'), account('b', 'claude')],
    quota: [quotaEntry('claude', 'a', [window('5h', 40)]), quotaEntry('claude', 'b', [window('5h', 0)])],
  });
  assert.equal(await service.prepareTurnAccount(turn('a')), null);
  assert.deepEqual(moves, []);
});

test('a model-scoped window only binds that model', async () => {
  const quota = [
    quotaEntry('claude', 'a', [window('5h', 30), window('Opus · Weekly', 100)]),
    quotaEntry('claude', 'b', [window('5h', 50)]),
  ];
  const accounts = [account('a', 'claude'), account('b', 'claude')];
  const sonnet = setup({ enabled: true, accounts, quota });
  assert.equal(await sonnet.service.prepareTurnAccount(turn('a', null, 'sonnet')), null);
  const opus = setup({ enabled: true, accounts, quota });
  assert.equal((await opus.service.prepareTurnAccount(turn('a', null, 'opus')))?.toAccountId, 'b');
});

test('stays put when no other account has headroom', async () => {
  const { service, moves } = setup({
    enabled: true,
    accounts: [account('a', 'claude'), account('b', 'claude')],
    quota: [quotaEntry('claude', 'a', [window('5h', 100)]), quotaEntry('claude', 'b', [window('Weekly', 100)])],
  });
  assert.equal(await service.prepareTurnAccount(turn('a')), null);
  assert.deepEqual(moves, []);
});

test('ambient login is a valid target and source', async () => {
  const { service, carried } = setup({
    enabled: true,
    accounts: [account('a', 'claude')],
    quota: [quotaEntry('claude', 'a', [window('5h', 100)]), quotaEntry('claude', null, [window('5h', 5)])],
  });
  const change = await service.prepareTurnAccount(turn('a', 'provider-session'));
  assert.equal(change?.toAccountId, null);
  assert.deepEqual(carried, [{ fromEnv: { CLAUDE_CONFIG_DIR: '/accounts/a' }, toEnv: {} }]);
});

test('a conversation that cannot be carried over keeps its account', async () => {
  const { service, moves } = setup({
    enabled: true,
    carryOver: false,
    accounts: [account('a', 'claude'), account('b', 'claude')],
    quota: [quotaEntry('claude', 'a', [window('5h', 100)]), quotaEntry('claude', 'b', [window('5h', 0)])],
  });
  assert.equal(await service.prepareTurnAccount(turn('a', 'provider-session')), null);
  assert.deepEqual(moves, []);
});

test('a runtime limit hit benches the account and moves the session', async () => {
  const { service, moves, refreshes } = setup({
    enabled: true,
    accounts: [account('a', 'claude'), account('b', 'claude')],
    // The sweep has not caught up yet: both accounts still look healthy.
    quota: [quotaEntry('claude', 'a', [window('5h', 90)]), quotaEntry('claude', 'b', [window('5h', 30)])],
  });
  const hit = service.detectLimit('text', 'Claude AI usage limit reached|1791460800');
  assert.ok(hit);
  const change = await service.reportLimitHit(turn('a'), hit);
  assert.equal(change?.toAccountId, 'b');
  assert.equal(refreshes(), 1);
  assert.deepEqual(moves, [{ sessionId: 's1', accountId: 'b' }]);
  // Benched account is skipped as a target while the mark lasts.
  const back = await service.prepareTurnAccount(turn('b'));
  assert.equal(back, null);
});

test('limit hits are still recorded with the setting off, without moving', async () => {
  const { service, moves, refreshes } = setup({
    accounts: [account('a', 'claude'), account('b', 'claude')],
    quota: [quotaEntry('claude', 'b', [window('5h', 0)])],
  });
  const change = await service.reportLimitHit(turn('a'), { resetAt: null, transient: false });
  assert.equal(change, null);
  assert.equal(refreshes(), 1);
  assert.deepEqual(moves, []);
});

test('detectLimit matches limit errors and banners, not ordinary replies', () => {
  const { service } = setup({});
  assert.deepEqual(service.detectLimit('text', 'Claude AI usage limit reached|1791460800'), {
    resetAt: 1791460800000,
    transient: false,
  });
  assert.ok(service.detectLimit('text', "You've hit your limit · resets 5pm (Europe/Warsaw)"));
  assert.ok(service.detectLimit('text', '5-hour limit reached ∙ resets 3pm'));
  assert.ok(service.detectLimit('error', "You've hit your usage limit. Upgrade to Pro or try again in 2 hours."));
  assert.equal(service.detectLimit('error', 'Request failed: 429 Too Many Requests')?.transient, true);
  assert.equal(service.detectLimit('text', 'The API rate limit reached its peak, so I added backoff.'), null);
  assert.equal(service.detectLimit('error', 'Prompt is too long: token limit exceeded'), null);
  assert.equal(service.detectLimit('tool_result', 'usage limit reached'), null);
  // Current Claude Code banner names the window ("session", "weekly").
  assert.ok(service.detectLimit('text', "You've hit your session limit · resets 9:30am (Europe/Warsaw)"));
  assert.ok(service.detectLimit('text', 'You’ve hit your weekly limit · resets Oct 12'));
});

test('a switched session gets one continuation turn without turn-only options', async () => {
  const { service, queued } = setup({ enabled: true });
  const ok = await service.continueAfterSwitch({
    sessionId: 's1',
    userId: 7,
    options: { model: 'opus', permissionMode: 'default', attachments: [{ path: 'x' }], accountId: 'a' },
    change: SWITCH,
  });
  assert.equal(ok, true);
  assert.equal(queued.length, 1);
  assert.match(queued[0].content, /Label a.*Label b.*Continue/s);
  assert.deepEqual(queued[0].options, { model: 'opus', permissionMode: 'default', inboxSource: 'auto-continue' });
});

test('continuations are capped per session within the window', async () => {
  const { service, queued, advance } = setup({ enabled: true });
  const input = { sessionId: 's1', userId: null, options: {}, change: SWITCH };
  for (let i = 0; i < 3; i += 1) assert.equal(await service.continueAfterSwitch(input), true);
  assert.equal(await service.continueAfterSwitch(input), false);
  assert.equal(await service.continueAfterSwitch({ ...input, sessionId: 's2' }), true);
  advance(60 * 60 * 1000);
  assert.equal(await service.continueAfterSwitch(input), true);
  assert.equal(queued.length, 5);
});

test('a refused continuation does not use up the cap', async () => {
  const { service } = setup({ enabled: true, queueAccepts: false });
  const input = { sessionId: 's1', userId: null, options: {}, change: SWITCH };
  for (let i = 0; i < 5; i += 1) assert.equal(await service.continueAfterSwitch(input), false);
});

test('carry-over copies Claude and Codex transcripts into the target account', async () => {
  const { mkdtemp, mkdir, writeFile, readFile, rm } = await import('node:fs/promises');
  const { tmpdir } = await import('node:os');
  const path = await import('node:path');
  const { carryOverConversationOnDisk } = await import('@/modules/provider-accounts/account-failover.service.js');
  const root = await mkdtemp(path.join(tmpdir(), 'account-failover-'));
  try {
    const claudeFrom = path.join(root, 'a', 'claude');
    const claudeTo = path.join(root, 'b', 'claude');
    await mkdir(path.join(claudeFrom, 'projects', '-work-app', 'sess-1', 'subagents'), { recursive: true });
    await writeFile(path.join(claudeFrom, 'projects', '-work-app', 'sess-1.jsonl'), '{"turn":1}\n');
    await writeFile(path.join(claudeFrom, 'projects', '-work-app', 'sess-1', 'subagents', 'x.jsonl'), 'sub\n');
    assert.equal(carryOverConversationOnDisk({
      provider: 'claude',
      providerSessionId: 'sess-1',
      fromEnv: { CLAUDE_CONFIG_DIR: claudeFrom },
      toEnv: { CLAUDE_CONFIG_DIR: claudeTo },
    }), true);
    assert.equal(await readFile(path.join(claudeTo, 'projects', '-work-app', 'sess-1.jsonl'), 'utf8'), '{"turn":1}\n');
    assert.equal(await readFile(path.join(claudeTo, 'projects', '-work-app', 'sess-1', 'subagents', 'x.jsonl'), 'utf8'), 'sub\n');

    const codexFrom = path.join(root, 'a', 'codex');
    const codexTo = path.join(root, 'b', 'codex');
    const day = path.join('sessions', '2026', '10', '08');
    await mkdir(path.join(codexFrom, day), { recursive: true });
    await writeFile(path.join(codexFrom, day, 'rollout-2026-10-08T10-00-00-thread-9.jsonl'), 'codex\n');
    assert.equal(carryOverConversationOnDisk({
      provider: 'codex',
      providerSessionId: 'thread-9',
      fromEnv: { CODEX_HOME: codexFrom },
      toEnv: { CODEX_HOME: codexTo },
    }), true);
    assert.equal(await readFile(path.join(codexTo, day, 'rollout-2026-10-08T10-00-00-thread-9.jsonl'), 'utf8'), 'codex\n');

    // Missing transcript, or a provider with an opaque store, cannot move.
    assert.equal(carryOverConversationOnDisk({
      provider: 'claude',
      providerSessionId: 'missing',
      fromEnv: { CLAUDE_CONFIG_DIR: claudeFrom },
      toEnv: { CLAUDE_CONFIG_DIR: claudeTo },
    }), false);
    assert.equal(carryOverConversationOnDisk({
      provider: 'devin',
      providerSessionId: 'sess-1',
      fromEnv: {},
      toEnv: { XDG_CONFIG_HOME: '/x' },
    }), false);
  } finally {
    await rm(root, { recursive: true, force: true });
  }
});
