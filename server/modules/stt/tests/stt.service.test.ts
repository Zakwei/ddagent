import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase } from '@/modules/database/index.js';
import {
  getSttConfig,
  isSttConfigured,
  setSttConfig,
  transcribeAudio,
} from '@/modules/stt/stt.service.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const previousEnv = { ...process.env };
  delete process.env.STT_ENDPOINT_URL;
  delete process.env.STT_API_KEY;
  delete process.env.STT_MODEL;

  const temporaryDirectory = await mkdtemp(path.join(tmpdir(), 'stt-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(temporaryDirectory, 'auth.db');
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) delete process.env.DATABASE_PATH;
    else process.env.DATABASE_PATH = previousDatabasePath;
    for (const key of ['STT_ENDPOINT_URL', 'STT_API_KEY', 'STT_MODEL']) {
      if (previousEnv[key] === undefined) delete process.env[key];
      else process.env[key] = previousEnv[key];
    }
    await rm(temporaryDirectory, { recursive: true, force: true });
  }
}

test('stt config resolves env fallback and app_config override', async () => {
  await withIsolatedDatabase(() => {
    assert.equal(isSttConfigured(), false);

    process.env.STT_API_KEY = 'sk-test';
    assert.equal(isSttConfigured(), true);
    assert.equal(getSttConfig().endpointUrl, 'https://api.openai.com/v1');

    setSttConfig({ endpointUrl: 'http://localhost:8080/v1', apiKey: 'local' });
    assert.equal(getSttConfig().endpointUrl, 'http://localhost:8080/v1');

    // cleared value falls back to env, not the stale stored empty string
    setSttConfig({ endpointUrl: '' });
    assert.equal(getSttConfig().endpointUrl, 'https://api.openai.com/v1');
  });
});

test('transcribeAudio forwards audio as whisper multipart', async () => {
  await withIsolatedDatabase(async () => {
    setSttConfig({ endpointUrl: 'http://stt.local/v1', apiKey: 'k', model: 'whisper-1' });

    const calls: { url: string; auth: string | null; hasFile: boolean }[] = [];
    const original = globalThis.fetch;
    globalThis.fetch = (async (_url: unknown, init?: RequestInit) => {
      const form = init?.body as FormData;
      calls.push({
        url: String(_url),
        auth: (init?.headers as Record<string, string>)?.Authorization ?? null,
        hasFile: form?.get('file') instanceof Blob && form.get('model') === 'whisper-1',
      });
      return new Response(JSON.stringify({ text: 'hello world' }), { status: 200 });
    }) as typeof fetch;

    try {
      const result = await transcribeAudio({
        audio: Buffer.from('fake-audio'),
        mimeType: 'audio/webm',
        language: 'pl',
      });
      assert.equal(result.text, 'hello world');
      assert.equal(calls[0].url, 'http://stt.local/v1/audio/transcriptions');
      assert.equal(calls[0].auth, 'Bearer k');
      assert.equal(calls[0].hasFile, true);
    } finally {
      globalThis.fetch = original;
    }
  });
});

test('transcribeAudio rejects when not configured', async () => {
  await withIsolatedDatabase(async () => {
    await assert.rejects(
      () => transcribeAudio({ audio: Buffer.from('x'), mimeType: 'audio/webm' }),
      /not configured/
    );
  });
});
