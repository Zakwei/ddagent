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
    readTextFile: (filePath) => files[filePath] ?? null,
    request: async (url) => respond(url),
  });
}

test('a missing credential file yields an error account without throwing', async () => {
  const providers = buildProviders({}, () => httpResponse(200, '{}'));

  const accounts = await providers.loadAll();

  assert.equal(accounts.length, 4);
  assert.ok(accounts.every((account) => account.status === 'error'));
  assert.ok(accounts.every((account) => account.quality === 'error'));
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
