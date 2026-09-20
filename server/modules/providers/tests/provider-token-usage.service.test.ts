import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import Database from 'better-sqlite3';

import { createProviderTokenUsageService } from '@/modules/providers/services/provider-token-usage.service.js';
import { AppError } from '@/shared/utils.js';

function createSessionRow(overrides: Record<string, unknown> = {}) {
  return {
    session_id: 'app-session',
    provider: 'claude',
    provider_session_id: 'provider-session',
    project_path: null,
    jsonl_path: null,
    custom_name: null,
    model: null,
    effort: null,
    isArchived: 0,
    created_at: '2026-01-01T00:00:00.000Z',
    updated_at: '2026-01-01T00:00:00.000Z',
    ...overrides,
  };
}

test('token usage lookup requires only the app-facing session id for Claude', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-claude-'));
  const sessionFilePath = path.join(tempDirectory, 'provider-session.jsonl');

  try {
    await writeFile(sessionFilePath, [
      JSON.stringify({
        type: 'assistant',
        message: {
          usage: {
            input_tokens: 100,
            cache_read_input_tokens: 20,
            cache_creation_input_tokens: 5,
            output_tokens: 30,
          },
        },
      }),
      '{incomplete',
    ].join('\n'));

    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({ jsonl_path: sessionFilePath }),
      getClaudeContextWindow: () => '180000',
    });

    assert.deepEqual(await service.getSessionTokenUsage('app-session'), {
      used: 155,
      total: 180_000,
      inputTokens: 100,
      outputTokens: 30,
      cacheReadTokens: 20,
      cacheCreationTokens: 5,
      cacheTokens: 25,
      breakdown: { input: 100, output: 30, cacheRead: 20, cacheCreation: 5 },
    });
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('Codex token usage uses the latest token_count snapshot', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-codex-'));
  const sessionFilePath = path.join(tempDirectory, 'rollout-provider-session.jsonl');

  try {
    await writeFile(sessionFilePath, [
      JSON.stringify({
        type: 'event_msg',
        payload: {
          type: 'token_count',
          info: {
            total_token_usage: { input_tokens: 10, output_tokens: 4, total_tokens: 14 },
            model_context_window: 100_000,
          },
        },
      }),
      JSON.stringify({
        type: 'event_msg',
        payload: {
          type: 'token_count',
          info: {
            total_token_usage: { input_tokens: 40, output_tokens: 9, total_tokens: 49 },
            model_context_window: 250_000,
          },
        },
      }),
    ].join('\n'));

    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({
        provider: 'codex',
        jsonl_path: sessionFilePath,
      }),
    });

    assert.deepEqual(await service.getSessionTokenUsage('app-session'), {
      used: 49,
      total: 250_000,
      inputTokens: 40,
      outputTokens: 9,
      cacheReadTokens: 0,
      breakdown: { input: 40, output: 9, cacheRead: 0 },
    });
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('OpenCode token usage resolves its provider-native id from the session row', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-opencode-'));
  const databasePath = path.join(tempDirectory, 'opencode.db');
  const database = new Database(databasePath);

  try {
    database.exec(`
      CREATE TABLE session (
        id TEXT PRIMARY KEY,
        tokens_input INTEGER,
        tokens_output INTEGER,
        tokens_reasoning INTEGER,
        tokens_cache_read INTEGER,
        tokens_cache_write INTEGER
      )
    `);
    database.prepare(`
      INSERT INTO session (
        id,
        tokens_input,
        tokens_output,
        tokens_reasoning,
        tokens_cache_read,
        tokens_cache_write
      ) VALUES (?, ?, ?, ?, ?, ?)
    `).run('provider-session', 12, 7, 3, 5, 2);
  } finally {
    database.close();
  }

  try {
    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({ provider: 'opencode' }),
      getOpenCodeDatabasePath: () => databasePath,
    });

    assert.deepEqual(await service.getSessionTokenUsage('app-session'), {
      used: 29,
      inputTokens: 12,
      outputTokens: 7,
      cacheReadTokens: 5,
      cacheCreationTokens: 2,
      cacheTokens: 7,
      breakdown: { input: 12, output: 7, cacheRead: 5, cacheCreation: 2 },
    });
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('Devin token usage uses the latest token_budget snapshot from the transcript', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-devin-'));
  const sessionFilePath = path.join(tempDirectory, 'provider-session.jsonl');

  try {
    await writeFile(sessionFilePath, [
      JSON.stringify({
        kind: 'status',
        text: 'token_budget',
        tokenBudget: { used: 400, total: 262_000, inputTokens: 350, outputTokens: 50 },
      }),
      // The newest snapshot wins and only carries the breakdown fields.
      JSON.stringify({
        kind: 'status',
        text: 'token_budget',
        tokenBudget: { used: 1_200, total: 262_000, breakdown: { input: 1_100, output: 100 } },
      }),
      // An all-zero snapshot is skipped, as is a partially written line.
      JSON.stringify({
        kind: 'status',
        text: 'token_budget',
        tokenBudget: { used: 0, total: 262_000, inputTokens: 0, outputTokens: 0 },
      }),
      '{incomplete',
    ].join('\n'));

    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({
        provider: 'devin',
        jsonl_path: sessionFilePath,
      }),
    });

    assert.deepEqual(await service.getSessionTokenUsage('app-session'), {
      used: 1_200,
      total: 262_000,
      inputTokens: 1_100,
      outputTokens: 100,
      breakdown: { input: 1_100, output: 100 },
    });
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('Devin token usage resolves the transcript under the project directory without an indexed path', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-devin-project-'));
  const transcriptDirectory = path.join(tempDirectory, '.ddagent', 'devin');

  try {
    await mkdir(transcriptDirectory, { recursive: true });
    await writeFile(path.join(transcriptDirectory, 'provider-session.jsonl'), JSON.stringify({
      kind: 'status',
      text: 'token_budget',
      tokenBudget: { used: 750, total: 262_000, inputTokens: 700, outputTokens: 50 },
    }));

    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({
        provider: 'devin',
        project_path: tempDirectory,
      }),
    });

    assert.deepEqual(await service.getSessionTokenUsage('app-session'), {
      used: 750,
      total: 262_000,
      inputTokens: 700,
      outputTokens: 50,
      breakdown: { input: 700, output: 50 },
    });
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('Devin token usage reports an unsupported result when the transcript has no snapshot', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-devin-empty-'));
  const sessionFilePath = path.join(tempDirectory, 'provider-session.jsonl');

  try {
    await writeFile(sessionFilePath, [
      JSON.stringify({ kind: 'assistant', text: 'hello' }),
      JSON.stringify({ kind: 'status', text: 'ready' }),
    ].join('\n'));

    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({
        provider: 'devin',
        jsonl_path: sessionFilePath,
      }),
    });

    const result = await service.getSessionTokenUsage('app-session');

    assert.equal(result.used, 0);
    assert.equal(result.total, 0);
    assert.equal(result.unsupported, true);
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('Devin token usage reports DEVIN_TRANSCRIPT_NOT_FOUND for a missing transcript', async () => {
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'provider-token-usage-devin-missing-'));

  try {
    const service = createProviderTokenUsageService({
      getSessionById: () => createSessionRow({
        provider: 'devin',
        jsonl_path: path.join(tempDirectory, 'missing.jsonl'),
      }),
    });

    await assert.rejects(
      () => service.getSessionTokenUsage('app-session'),
      (error: unknown) => (
        error instanceof AppError
        && error.code === 'DEVIN_TRANSCRIPT_NOT_FOUND'
        && error.statusCode === 404
      ),
    );
  } finally {
    await rm(tempDirectory, { recursive: true, force: true });
  }
});

test('Cursor returns an explicit unsupported token usage result', async () => {
  const service = createProviderTokenUsageService({
    getSessionById: () => createSessionRow({ provider: 'cursor' }),
  });

  const result = await service.getSessionTokenUsage('app-session');

  assert.equal(result.unsupported, true);
  assert.equal(result.used, 0);
  assert.equal(result.total, 0);
});

test('token usage reports SESSION_NOT_FOUND for an unknown app session id', async () => {
  const service = createProviderTokenUsageService({ getSessionById: () => null });

  await assert.rejects(
    () => service.getSessionTokenUsage('missing-session'),
    (error: unknown) => (
      error instanceof AppError
      && error.code === 'SESSION_NOT_FOUND'
      && error.statusCode === 404
    ),
  );
});
