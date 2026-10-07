import assert from 'node:assert/strict';
import { once } from 'node:events';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import type { AddressInfo } from 'node:net';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import express, { type NextFunction, type Request, type Response } from 'express';

import { closeConnection, initializeDatabase, userDb } from '@/modules/database/index.js';
import providerRouter from '@/modules/providers/provider.routes.js';
import { AppError } from '@/shared/utils.js';

/** Boots the provider router against a temp DB with an authenticated req.user. */
async function withFavoriteServer(
  run: (baseUrl: string, userId: number) => Promise<void>,
): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(os.tmpdir(), 'favorite-models-routes-'));

  closeConnection();
  process.env.DATABASE_PATH = path.join(tempDirectory, 'auth.db');
  await writeFile(process.env.DATABASE_PATH, '');
  await initializeDatabase();

  const userId = Number(userDb.createUser('favorites-user', 'hash').id);

  const app = express()
    .use(express.json())
    .use((req: Request, _res: Response, next: NextFunction) => {
      (req as Request & { user?: { id: number } }).user = { id: userId };
      next();
    })
    .use('/api/providers', providerRouter);
  app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (error instanceof AppError) {
      res.status(error.statusCode).json({
        success: false,
        error: { code: error.code, message: error.message },
      });
      return;
    }
    res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR' } });
  });

  const server = app.listen(0, '127.0.0.1');
  await once(server, 'listening');

  try {
    const address = server.address() as AddressInfo;
    await run(`http://127.0.0.1:${address.port}`, userId);
  } finally {
    await new Promise<void>((resolve, reject) => {
      server.close((error) => (error ? reject(error) : resolve()));
    });
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

test('favorite models round-trip per user and provider', async () => {
  await withFavoriteServer(async (baseUrl) => {
    const empty = await (await fetch(`${baseUrl}/api/providers/claude/favorite-models`)).json() as {
      data: { provider: string; modelIds: string[] };
    };
    assert.equal(empty.data.provider, 'claude');
    assert.deepEqual(empty.data.modelIds, []);

    const saveResponse = await fetch(`${baseUrl}/api/providers/claude/favorite-models`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ modelIds: ['opus', 'sonnet'] }),
    });
    assert.equal(saveResponse.status, 200);
    const saved = await saveResponse.json() as { data: { modelIds: string[] } };
    assert.deepEqual(saved.data.modelIds, ['opus', 'sonnet']);

    const read = await (await fetch(`${baseUrl}/api/providers/claude/favorite-models`)).json() as {
      data: { modelIds: string[] };
    };
    assert.deepEqual(read.data.modelIds, ['opus', 'sonnet']);

    // Another provider keeps its own set.
    const other = await (await fetch(`${baseUrl}/api/providers/codex/favorite-models`)).json() as {
      data: { modelIds: string[] };
    };
    assert.deepEqual(other.data.modelIds, []);

    // A full replace drops removed ids.
    const replaceResponse = await fetch(`${baseUrl}/api/providers/claude/favorite-models`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ modelIds: ['sonnet'] }),
    });
    const replaced = await replaceResponse.json() as { data: { modelIds: string[] } };
    assert.deepEqual(replaced.data.modelIds, ['sonnet']);
  });
});

test('favorite models rejects malformed payloads and providers', async () => {
  await withFavoriteServer(async (baseUrl) => {
    const notArray = await fetch(`${baseUrl}/api/providers/claude/favorite-models`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ modelIds: 'opus' }),
    });
    assert.equal(notArray.status, 400);

    const whitespaceId = await fetch(`${baseUrl}/api/providers/claude/favorite-models`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ modelIds: ['a b'] }),
    });
    assert.equal(whitespaceId.status, 400);

    const unknownProvider = await fetch(`${baseUrl}/api/providers/nope/favorite-models`);
    assert.equal(unknownProvider.status, 400);
  });
});
