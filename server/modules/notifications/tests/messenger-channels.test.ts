import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  appConfigDb,
  closeConnection,
  initializeDatabase,
  notificationChannelEndpointsDb,
  userDb,
} from '@/modules/database/index.js';
import {
  discordChannel,
  isValidDiscordWebhookUrl,
  telegramChannel,
} from '@/modules/notifications/services/messenger-channels.service.js';
import {
  registerApprovalContext,
  resolveRemoteApproval,
} from '@/modules/notifications/services/remote-approval.service.js';

type FetchCall = { url: string; body: Record<string, unknown> };

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const temporaryDirectory = await mkdtemp(path.join(tmpdir(), 'messenger-channels-'));
  const databasePath = path.join(temporaryDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(temporaryDirectory, { recursive: true, force: true });
  }
}

function withMockFetch(runTest: (calls: FetchCall[]) => void | Promise<void>): Promise<void> {
  const calls: FetchCall[] = [];
  const original = globalThis.fetch;
  globalThis.fetch = (async (input: unknown, init?: { body?: string }) => {
    calls.push({ url: String(input), body: init?.body ? JSON.parse(init.body) : {} });
    return new Response(JSON.stringify({ ok: true, result: [] }), { status: 200 });
  }) as typeof fetch;
  return Promise.resolve()
    .then(() => runTest(calls))
    .finally(() => {
      globalThis.fetch = original;
    });
}

test('isValidDiscordWebhookUrl accepts only discord webhook URLs', () => {
  assert.equal(isValidDiscordWebhookUrl('https://discord.com/api/webhooks/123/abc'), true);
  assert.equal(isValidDiscordWebhookUrl('https://discordapp.com/api/webhooks/123/abc'), true);
  assert.equal(isValidDiscordWebhookUrl('https://evil.com/api/webhooks/123/abc'), false);
  assert.equal(isValidDiscordWebhookUrl('http://discord.com/api/webhooks/123/abc'), false);
  assert.equal(isValidDiscordWebhookUrl('not-a-url'), false);
});

test('telegram channel sends approval buttons only to enabled endpoints', async () => {
  await withIsolatedDatabase(async () => {
    const user = userDb.createUser('alice', 'hash');
    const userId = Number(user.id);
    appConfigDb.set('messenger.telegram.botToken', '123456:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    notificationChannelEndpointsDb.upsertEndpoint({ userId, channel: 'telegram', endpointId: '555' });
    notificationChannelEndpointsDb.upsertEndpoint({ userId, channel: 'telegram', endpointId: '777', enabled: false });

    await withMockFetch(async (calls) => {
      await telegramChannel.send({
        userId,
        event: {
          code: 'permission.required',
          meta: { requestId: 'req-1', toolName: 'Bash', inputPreview: 'npm test' },
        },
        payload: { title: 'demo', body: 'Claude: Action Required: Tool "Bash" needs approval' },
      });

      assert.equal(calls.length, 1);
      assert.match(calls[0].url, /bot123456:AAAA.*\/sendMessage/);
      assert.equal(calls[0].body.chat_id, '555');
      const keyboard = (calls[0].body.reply_markup as { inline_keyboard: Array<Array<{ callback_data: string }>> }).inline_keyboard;
      assert.equal(keyboard[0].length, 3);
      assert.deepEqual(keyboard[0].map((b) => b.callback_data), ['ap:req-1:a', 'ap:req-1:d', 'ap:req-1:w']);
    });
  });
});

test('telegram channel stays silent without token or endpoints', async () => {
  await withIsolatedDatabase(async () => {
    const user = userDb.createUser('bob', 'hash');
    await withMockFetch(async (calls) => {
      await telegramChannel.send({
        userId: Number(user.id),
        event: { code: 'permission.required', meta: { requestId: 'r' } },
        payload: { title: 't', body: 'b' },
      });
      assert.equal(calls.length, 0);
    });
  });
});

test('discord channel posts plain text to configured webhook', async () => {
  await withIsolatedDatabase(async () => {
    const user = userDb.createUser('carol', 'hash');
    appConfigDb.set('messenger.discord.webhookUrl', 'https://discord.com/api/webhooks/9/xx');
    await withMockFetch(async (calls) => {
      await discordChannel.send({
        userId: Number(user.id),
        event: { code: 'run.stopped', meta: {} },
        payload: { title: 'sess', body: 'Claude: Run Stopped' },
      });
      assert.equal(calls.length, 1);
      assert.equal(calls[0].url, 'https://discord.com/api/webhooks/9/xx');
      assert.match(String(calls[0].body.content), /Run Stopped/);
    });
  });
});

test('resolveRemoteApproval resolves, rejects replays and bad input', async () => {
  registerApprovalContext('req-abc', { toolName: 'Bash', sessionId: 's1' });

  const first = await resolveRemoteApproval('req-abc', 'allow');
  assert.deepEqual(first, { ok: true, tracked: true });

  const replay = await resolveRemoteApproval('req-abc', 'deny');
  assert.deepEqual(replay, { ok: false, reason: 'expired' });

  assert.deepEqual(await resolveRemoteApproval('', 'allow'), { ok: false, reason: 'invalid' });
  // @ts-expect-error runtime guard against malformed actions
  assert.deepEqual(await resolveRemoteApproval('req-x', 'nuke'), { ok: false, reason: 'invalid' });

  const untracked = await resolveRemoteApproval('req-unknown', 'deny');
  assert.deepEqual(untracked, { ok: true, tracked: false });
});

test('isEndpointEnabledForAnyUser honours the enabled flag', async () => {
  await withIsolatedDatabase(() => {
    const user = userDb.createUser('dave', 'hash');
    const userId = Number(user.id);
    notificationChannelEndpointsDb.upsertEndpoint({ userId, channel: 'telegram', endpointId: '42' });
    assert.equal(notificationChannelEndpointsDb.isEndpointEnabledForAnyUser('telegram', '42'), true);
    assert.equal(notificationChannelEndpointsDb.isEndpointEnabledForAnyUser('telegram', '43'), false);
    notificationChannelEndpointsDb.setEndpointEnabled(userId, 'telegram', '42', false);
    assert.equal(notificationChannelEndpointsDb.isEndpointEnabledForAnyUser('telegram', '42'), false);
  });
});
