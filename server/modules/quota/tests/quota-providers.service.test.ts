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
