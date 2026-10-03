import assert from 'node:assert/strict';
import test from 'node:test';

import {
  createQuotaProviders,
  type QuotaHttpResponse,
} from '@/modules/quota/services/quota-providers.service.js';

function httpResponse(status: number, body: string): QuotaHttpResponse {
  return { status, buffer: Buffer.from(body, 'utf8'), text: body };
}

/** Builds a provider set reading from an in-memory file map with a stub HTTP. */
function buildProviders(
  files: Record<string, string>,
  respond: (url: string) => QuotaHttpResponse,
) {
  return createQuotaProviders({
    homeDirectory: '/home/test',
    env: { ...process.env, HOME: '/home/test' },
    readTextFile: (filePath) => files[filePath] ?? null,
    request: async (url) => respond(url),
  });
}

test('a missing credential file yields an error account without throwing', async () => {
  const providers = buildProviders({}, () => httpResponse(200, '{}'));

  const accounts = await providers.loadAll();

  assert.equal(accounts.length, 7);
  assert.ok(accounts.filter((a) => a.provider !== 'claude').every((a) => a.status === 'error'));
  const claude = accounts.find((a) => a.provider === 'claude')!;
  assert.equal(claude.status, process.env.ANTHROPIC_API_KEY ? 'inactive' : 'error');
});

test('OpenCode maps rolling/weekly/monthly usage into windows', async () => {
  const providers = buildProviders(
    {
      '/home/test/.local/share/opencode/auth.json': JSON.stringify({ 'opencode-go': { key: 'k' } }),
    },
    () =>
      httpResponse(
        200,
        JSON.stringify({
          usage: {
            rolling: { status: 'ok', percent: 25, resetsAt: '2026-01-01T01:00:00.000Z' },
            weekly: { percent: 70 },
            monthly: { percent: 10 },
          },
        }),
      ),
  );

  const accounts = await providers.loadAll();
  const opencode = accounts.find((account) => account.provider === 'opencode')!;

  assert.equal(opencode.status, 'active');
  assert.deepEqual(
    opencode.windows.map((window) => [window.kind, window.percent]),
    [['rolling', 25], ['weekly', 70], ['monthly', 10]],
  );
});

test('a non-2xx provider response becomes a sync error', async () => {
  const providers = buildProviders(
    {
      '/home/test/.local/share/opencode/auth.json': JSON.stringify({ 'opencode-go': { key: 'k' } }),
    },
    () => httpResponse(401, 'unauthorized'),
  );

  const accounts = await providers.loadAll();
  const opencode = accounts.find((account) => account.provider === 'opencode')!;

  assert.equal(opencode.status, 'error');
  assert.match(opencode.syncError ?? '', /401/);
});

test('a 403 entitlement error means the account has no subscription', async () => {
  const providers = buildProviders(
    {
      '/home/test/.local/share/opencode/auth.json': JSON.stringify({ 'opencode-go': { key: 'k' } }),
    },
    () =>
      httpResponse(
        403,
        JSON.stringify({
          type: 'error',
          error: { type: 'EntitlementError', message: 'OpenCode Go subscription required' },
        }),
      ),
  );

  const accounts = await providers.loadAll();
  const opencode = accounts.find((account) => account.provider === 'opencode')!;

  assert.equal(opencode.status, 'inactive');
  assert.equal(opencode.quality, 'unknown');
  assert.equal(opencode.syncError, null);
  assert.deepEqual(opencode.windows, []);
});

// Minimal proto3 encoders mirroring the service's wire format: field/tag =
// (number << 3) | wireType, varint = wire type 0, length-delimited = type 2.
function encVarint(value: number): Buffer {
  const bytes: number[] = [];
  let remaining = BigInt(value);
  for (;;) {
    const byte = Number(remaining & 0x7fn);
    remaining >>= 7n;
    if (remaining) bytes.push(byte | 0x80);
    else {
      bytes.push(byte);
      return Buffer.from(bytes);
    }
  }
}
const encVarintField = (field: number, value: number) =>
  Buffer.concat([encVarint((field << 3) | 0), encVarint(value)]);
const encLenField = (field: number, body: Buffer) =>
  Buffer.concat([encVarint((field << 3) | 2), encVarint(body.length), body]);

test('Devin keeps a fully used window whose remaining field proto3 omits', async () => {
  // GetPlanStatus: status sub-message at field 1; daily = remaining 14 / reset
  // 17, weekly = remaining 15 / reset 18. A 100%-used weekly sends no field 15.
  const dailyReset = 1_790_928_000; // 2026-10-02T08:00:00Z
  const weeklyReset = 1_791_100_800; // 2026-10-04T08:00:00Z
  const status = Buffer.concat([
    encVarintField(14, 100),
    encVarintField(17, dailyReset),
    encVarintField(18, weeklyReset),
  ]);
  const protoBody = encLenField(1, status);

  const providers = buildProviders(
    {
      '/home/test/.local/share/devin/credentials.toml': 'windsurf_api_key = "k"',
    },
    () => ({ status: 200, buffer: protoBody, text: '' }),
  );

  const accounts = await providers.loadAll();
  const devin = accounts.find((account) => account.provider === 'devin')!;

  assert.equal(devin.status, 'active');
  assert.deepEqual(
    devin.windows.map((w) => [w.kind, w.percent, w.resetsAt]),
    [
      ['daily', 0, new Date(dailyReset * 1000).toISOString()],
      ['weekly', 100, new Date(weeklyReset * 1000).toISOString()],
    ],
  );
});

test('Devin drops a window only when both remaining and reset are absent', async () => {
  const status = Buffer.concat([encVarintField(14, 60), encVarintField(17, 1_790_928_000)]);
  const providers = buildProviders(
    {
      '/home/test/.local/share/devin/credentials.toml': 'windsurf_api_key = "k"',
    },
    () => ({ status: 200, buffer: encLenField(1, status), text: '' }),
  );

  const devin = (await providers.loadAll()).find((account) => account.provider === 'devin')!;
  assert.deepEqual(
    devin.windows.map((w) => [w.kind, w.percent]),
    [['daily', 40]],
  );
});

test('CommandCode derives the monthly window from the plan cap', async () => {
  const providers = buildProviders(
    {
      '/home/test/.commandcode/auth.json': JSON.stringify({ apiKey: 'k' }),
    },
    (url) => {
      if (url.includes('subscriptions')) {
        return httpResponse(200, JSON.stringify({ data: { planId: 'individual-pro' } }));
      }
      return httpResponse(
        200,
        JSON.stringify({
          windowLimits: { fiveHour: { used: 4, cap: 10 } },
          credits: { monthlyCredits: 20 },
        }),
      );
    },
  );

  const accounts = await providers.loadAll();
  const commandcode = accounts.find((account) => account.provider === 'commandcode')!;

  assert.equal(commandcode.plan, 'CommandCode Pro');
  const monthly = commandcode.windows.find((window) => window.kind === 'monthly')!;
  assert.equal(monthly.percent, 75);
  const session = commandcode.windows.find((window) => window.kind === 'session')!;
  assert.equal(session.percent, 40);
});

test('standalone agents ignore credentials belonging to OpenCode and other CLIs', async () => {
  const previousKeys = [process.env.COMMAND_CODE_API_KEY, process.env.COMMANDCODE_API_KEY];
  delete process.env.COMMAND_CODE_API_KEY;
  delete process.env.COMMANDCODE_API_KEY;
  try {
    const providers = buildProviders({
      '/home/test/.config/opencode/antigravity-accounts.json': JSON.stringify({
        accounts: [{ refreshToken: 'foreign-token', projectId: 'foreign-project' }],
      }),
      '/home/test/.local/share/opencode/auth.json': JSON.stringify({ commandcode: { key: 'foreign-key' } }),
      '/home/test/.omp/auth.json': JSON.stringify({ commandcode: { key: 'foreign-key' } }),
      '/home/test/.pi/auth.json': JSON.stringify({ commandcode: { key: 'foreign-key' } }),
    }, () => assert.fail('Foreign credentials must not trigger quota requests'));
    const accounts = await providers.loadAll();
    for (const provider of ['gemini', 'commandcode']) {
      assert.equal(accounts.find((entry) => entry.provider === provider)?.status, 'error');
    }
  } finally {
    for (const [index, name] of ['COMMAND_CODE_API_KEY', 'COMMANDCODE_API_KEY'].entries()) {
      if (previousKeys[index] === undefined) delete process.env[name];
      else process.env[name] = previousKeys[index];
    }
  }
});

test('Antigravity reads its standalone OAuth store and resolves its own project', async () => {
  const providers = buildProviders({
    '/home/test/.gemini/antigravity-cli/antigravity-oauth-token': JSON.stringify({
      token: { access_token: 'native-token', expiry: '2099-01-01T00:00:00Z' },
    }),
  }, (url) => {
    if (url.endsWith(':loadCodeAssist')) {
      return httpResponse(200, JSON.stringify({ cloudaicompanionProject: { id: 'native-project' } }));
    }
    assert.ok(url.endsWith(':retrieveUserQuotaSummary'));
    return httpResponse(200, JSON.stringify({ groups: [{ buckets: [{
      bucketId: 'gemini-pro', window: '5h', remainingFraction: 0.75,
    }] }] }));
  });
  const account = (await providers.loadAll()).find((entry) => entry.provider === 'gemini')!;
  assert.equal(account.status, 'active');
  assert.equal(account.windows[0].percent, 25);
});

test('Cursor maps plan and on-demand usage into monthly windows', async () => {
  const jwt = `h.${Buffer.from(JSON.stringify({ sub: 'auth0|user_1', exp: 4_102_444_800 })).toString('base64url')}.s`;
  const providers = createQuotaProviders({
    homeDirectory: '/home/test',
    env: { ...process.env, HOME: '/home/test' },
    readTextFile: (filePath) =>
      filePath === '/home/test/.config/cursor/auth.json' ? JSON.stringify({ accessToken: jwt }) : null,
    request: async (url, options) => {
      assert.equal(url, 'https://cursor.com/api/usage-summary');
      assert.match(String(options?.headers?.Cookie), /^WorkosCursorSessionToken=user_1%3A%3Ah\./);
      return httpResponse(200, JSON.stringify({
        membershipType: 'pro',
        billingCycleEnd: '2026-11-01T00:00:00Z',
        individualUsage: {
          plan: { totalPercentUsed: 42 },
          onDemand: { used: 500, limit: 2000 },
        },
        teamUsage: { plan: { totalPercentUsed: 10 } },
      }));
    },
  });

  const cursor = (await providers.loadAll()).find((entry) => entry.provider === 'cursor')!;

  assert.equal(cursor.status, 'active');
  assert.equal(cursor.plan, 'Cursor pro');
  assert.deepEqual(
    cursor.windows.map((w) => [w.label, w.kind, w.percent]),
    [['Monthly', 'monthly', 42], ['On-demand', 'metered', 25], ['Team · Monthly', 'monthly', 10]],
  );
  assert.equal(cursor.windows[0].resetsAt, '2026-11-01T00:00:00Z');
});

test('Cursor reports a login hint when the session JWT is expired', async () => {
  const jwt = `h.${Buffer.from(JSON.stringify({ sub: 'auth0|user_1', exp: 1 })).toString('base64url')}.s`;
  const providers = buildProviders({
    '/home/test/.config/cursor/auth.json': JSON.stringify({ accessToken: jwt }),
  }, () => assert.fail('Expired sessions must not trigger quota requests'));

  const cursor = (await providers.loadAll()).find((entry) => entry.provider === 'cursor')!;

  assert.equal(cursor.status, 'error');
  assert.match(cursor.syncError ?? '', /cursor-agent login/);
});

test('Antigravity refreshes an expired access token and persists the new one', async () => {
  const written: Record<string, string> = {};
  const providers = createQuotaProviders({
    homeDirectory: '/home/test',
    env: { ...process.env, HOME: '/home/test' },
    readTextFile: (filePath) =>
      filePath === '/home/test/.gemini/antigravity-cli/antigravity-oauth-token'
        ? JSON.stringify({
            token: {
              access_token: 'stale-token',
              refresh_token: 'refresh-1',
              expiry: '2020-01-01T00:00:00Z',
            },
          })
        : null,
    writeTextFile: (filePath, content) => {
      written[filePath] = content;
    },
    request: async (url, options) => {
      if (url === 'https://oauth2.googleapis.com/token') {
        const params = new URLSearchParams(options?.body as string);
        assert.equal(params.get('grant_type'), 'refresh_token');
        assert.equal(params.get('refresh_token'), 'refresh-1');
        return httpResponse(200, JSON.stringify({ access_token: 'fresh-token', expires_in: 3600 }));
      }
      assert.equal(options?.headers?.Authorization, 'Bearer fresh-token');
      if (url.endsWith(':loadCodeAssist')) {
        return httpResponse(200, JSON.stringify({ cloudaicompanionProject: { id: 'native-project' } }));
      }
      assert.ok(url.endsWith(':retrieveUserQuotaSummary'));
      return httpResponse(200, JSON.stringify({ groups: [{ buckets: [{
        bucketId: 'gemini-pro', window: '5h', remainingFraction: 0.5,
      }] }] }));
    },
  });

  const account = (await providers.loadAll()).find((entry) => entry.provider === 'gemini')!;

  assert.equal(account.status, 'active');
  assert.equal(account.windows[0].percent, 50);
  const persisted = JSON.parse(written['/home/test/.gemini/antigravity-cli/antigravity-oauth-token']);
  assert.equal(persisted.token.access_token, 'fresh-token');
  assert.equal(persisted.token.refresh_token, 'refresh-1');
  assert.ok(Date.parse(persisted.token.expiry) > Date.now());
});

test('Antigravity reports an error when Google rejects the token refresh', async () => {
  const providers = buildProviders({
    '/home/test/.gemini/antigravity-cli/antigravity-oauth-token': JSON.stringify({
      token: {
        access_token: 'stale-token',
        refresh_token: 'revoked',
        expiry: '2020-01-01T00:00:00Z',
      },
    }),
  }, (url) => url === 'https://oauth2.googleapis.com/token'
    ? httpResponse(400, JSON.stringify({ error: 'invalid_grant' }))
    : assert.fail('Quota endpoints must not be queried with a stale token'));

  const account = (await providers.loadAll()).find((entry) => entry.provider === 'gemini')!;

  assert.equal(account.status, 'error');
  assert.match(account.syncError ?? '', /expired/);
});

test('a provider_accounts row loads under its own env overrides as a separate account', async () => {
  const providers = createQuotaProviders(
    {
      homeDirectory: '/home/test',
      env: { ...process.env, HOME: '/home/test' },
      readTextFile: (filePath) =>
        filePath === '/acc/home/.gemini/antigravity-cli/antigravity-oauth-token'
          ? JSON.stringify({ token: { access_token: 'acc-token', expiry: '2099-01-01T00:00:00Z' } })
          : null,
      request: async (url) => {
        if (url.endsWith(':loadCodeAssist')) {
          return httpResponse(200, JSON.stringify({ cloudaicompanionProject: { id: 'acc-project' } }));
        }
        assert.ok(url.endsWith(':retrieveUserQuotaSummary'));
        return httpResponse(200, JSON.stringify({ groups: [{ buckets: [{
          bucketId: 'gemini-pro', window: '5h', remainingFraction: 0.5,
        }] }] }));
      },
    },
    {
      listProviderAccounts: () => [
        { id: 'acc-1', provider: 'antigravity', label: 'Work Gmail', envOverrides: { HOME: '/acc/home' } },
      ],
    },
  );

  const accounts = await providers.loadAll();

  assert.equal(accounts.length, 8);
  const named = accounts.find((entry) => entry.id === 'acc-1')!;
  assert.equal(named.accountId, 'acc-1');
  assert.equal(named.accountLabel, 'Work Gmail');
  assert.equal(named.provider, 'gemini');
  assert.equal(named.status, 'active');
  const ambient = accounts.find((entry) => entry.id === 'gemini')!;
  assert.equal(ambient.accountId, null);
  assert.equal(ambient.status, 'error');
});


test('Codex maps ChatGPT windows and uses the workspace header', async () => {
  const providers = createQuotaProviders({
    homeDirectory: '/home/test',
    env: { ...process.env, HOME: '/home/test' },
    readTextFile: (path) => path.endsWith('/.codex/auth.json')
      ? JSON.stringify({ tokens: { access_token: 'native-token', account_id: 'workspace' } }) : null,
    request: async (url, options) => {
      assert.equal(url, 'https://chatgpt.com/backend-api/wham/usage');
      assert.equal(options?.headers?.Authorization, 'Bearer native-token');
      assert.equal(options?.headers?.['ChatGPT-Account-Id'], 'workspace');
      return httpResponse(200, JSON.stringify({ plan_type: 'plus', rate_limit: {
        primary_window: { used_percent: 25, limit_window_seconds: 18000, reset_at: 1790928000 },
        secondary_window: { used_percent: 100, limit_window_seconds: 604800 },
      } }));
    },
  });
  const codex = (await providers.loadAll()).find((entry) => entry.provider === 'codex')!;
  assert.equal(codex.status, 'active');
  assert.equal(codex.plan, 'ChatGPT plus');
  assert.deepEqual(codex.windows.map((w) => [w.kind, w.percent, w.remainingPercent]),
    [['session', 25, 75], ['weekly', 100, 0]]);
  assert.equal(codex.windows[0].resetsAt, new Date(1790928000 * 1000).toISOString());
  assert.equal(codex.windows[1].status, 'exceeded');
});

test('Codex API-key accounts are inactive and make no subscription request', async () => {
  const providers = buildProviders({
    '/home/test/.codex/auth.json': JSON.stringify({ auth_mode: 'apikey', OPENAI_API_KEY: 'key',
      tokens: { access_token: 'stale-oauth' } }),
  }, () => assert.fail('API billing must not query ChatGPT'));
  const codex = (await providers.loadAll()).find((entry) => entry.provider === 'codex')!;
  assert.equal(codex.status, 'inactive');
  assert.equal(codex.syncError, null);
  assert.deepEqual(codex.windows, []);
});

test('Claude maps session, weekly and model-specific windows without inventing null limits', async () => {
  const providers = createQuotaProviders({
    homeDirectory: '/home/test',
    env: { ...process.env, HOME: '/home/test' },
    readTextFile: (path) => path.endsWith('/.claude/.credentials.json')
      ? JSON.stringify({ claudeAiOauth: { accessToken: 'native-token', subscriptionType: 'max' } }) : null,
    request: async (url, options) => {
      assert.equal(url, 'https://api.anthropic.com/api/oauth/usage');
      assert.equal(options?.headers?.['anthropic-beta'], 'oauth-2025-04-20');
      return httpResponse(200, JSON.stringify({
        five_hour: { utilization: 0, resets_at: '2099-01-01T00:00:00Z' },
        seven_day: { utilization: 75 }, seven_day_sonnet: { utilization: 100 }, seven_day_opus: null,
      }));
    },
  });
  const claude = (await providers.loadAll()).find((entry) => entry.provider === 'claude')!;
  assert.equal(claude.plan, 'Claude max');
  assert.equal(claude.status, 'active');
  assert.deepEqual(claude.windows.map((w) => [w.label, w.percent]),
    [['5h', 0], ['Weekly', 75], ['Sonnet · Weekly', 100]]);
});

test('native subscription errors stay isolated and do not expose response bodies', async () => {
  const providers = buildProviders({
    '/home/test/.codex/auth.json': JSON.stringify({ tokens: { access_token: 'token' } }),
    '/home/test/.claude/.credentials.json': JSON.stringify({ claudeAiOauth: { accessToken: 'token' } }),
  }, () => httpResponse(401, 'sensitive-response'));
  for (const entry of (await providers.loadAll()).filter((a) => ['claude', 'codex'].includes(a.provider))) {
    assert.equal(entry.status, 'error');
    assert.match(entry.syncError ?? '', /HTTP 401/);
    assert.ok(!entry.syncError?.includes('sensitive-response'));
  }
});

test('Claude expired tokens and malformed Codex auth do not trigger network calls', async () => {
  const providers = buildProviders({
    '/home/test/.codex/auth.json': '{invalid',
    '/home/test/.claude/.credentials.json': JSON.stringify({ claudeAiOauth: { accessToken: 'token', expiresAt: 1 } }),
  }, () => assert.fail('Invalid credentials must not trigger HTTP'));
  const accounts = await providers.loadAll();
  assert.equal(accounts.find((a) => a.provider === 'codex')?.status, 'error');
  assert.match(accounts.find((a) => a.provider === 'claude')?.syncError ?? '', /expired/);
});
