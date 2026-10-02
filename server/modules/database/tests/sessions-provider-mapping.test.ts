import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, getConnection } from '@/modules/database/connection.js';
import { initializeDatabase } from '@/modules/database/init-db.js';
import { runMigrations } from '@/modules/database/migrations.js';
import { sessionsDb } from '@/modules/database/repositories/sessions.db.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'sessions-mapping-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

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
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

test('disk-discovered sessions are keyed by the provider id for both columns', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createSession('provider-abc', 'claude', '/workspace/demo', 'From Disk');

    const row = sessionsDb.getSessionById('provider-abc');
    assert.equal(row?.session_id, 'provider-abc');
    assert.equal(row?.provider_session_id, 'provider-abc');

    const byProviderId = sessionsDb.getSessionByProviderSessionId('provider-abc');
    assert.equal(byProviderId?.session_id, 'provider-abc');
  });
});

test('app sessions get the provider id assigned without creating a duplicate row', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-id-1', 'claude', '/workspace/demo', 'Initial ddagent message');
    sessionsDb.assignProviderSessionId('app-id-1', 'provider-xyz');

    // A later synchronizer pass that discovers the transcript on disk must
    // update the app row in place instead of inserting a provider-keyed row.
    const returnedId = sessionsDb.createSession(
      'provider-xyz',
      'claude',
      '/workspace/demo',
      'Synced Name',
      undefined,
      undefined,
      '/fake/path/provider-xyz.jsonl',
    );

    assert.equal(returnedId, 'app-id-1');
    assert.equal(sessionsDb.getAllSessions().length, 1);

    const row = sessionsDb.getSessionById('app-id-1');
    assert.equal(row?.provider_session_id, 'provider-xyz');
    assert.equal(row?.jsonl_path, '/fake/path/provider-xyz.jsonl');
    assert.equal(row?.custom_name, 'Initial ddagent message');
  });
});

test('assignProviderSessionId merges a watcher-created duplicate into the app row', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-id-2', 'codex', '/workspace/demo');

    // Simulate the race: the filesystem watcher indexed the provider
    // transcript before the runtime announced its session id to the gateway.
    sessionsDb.createSession(
      'provider-race',
      'codex',
      '/workspace/demo',
      'Watcher Name',
      undefined,
      undefined,
      '/fake/provider-race.jsonl',
    );
    assert.equal(sessionsDb.getAllSessions().length, 2);

    sessionsDb.assignProviderSessionId('app-id-2', 'provider-race');

    const rows = sessionsDb.getAllSessions();
    assert.equal(rows.length, 1);
    assert.equal(rows[0]?.session_id, 'app-id-2');
    assert.equal(rows[0]?.provider_session_id, 'provider-race');
    // Transcript path and name from the duplicate are adopted.
    assert.equal(rows[0]?.jsonl_path, '/fake/provider-race.jsonl');
    assert.equal(rows[0]?.custom_name, 'Watcher Name');
  });
});

test('legacy provider-keyed rows stay resolvable through both lookups', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createSession('legacy-1', 'opencode', '/workspace/demo');

    assert.equal(sessionsDb.getSessionById('legacy-1')?.provider, 'opencode');
    assert.equal(sessionsDb.getSessionByProviderSessionId('legacy-1')?.session_id, 'legacy-1');
  });
});

test('re-running migrations never stamps the app id onto a pending session', async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('pending-app-id', 'claude', '/workspace/demo');
    assert.equal(sessionsDb.getSessionById('pending-app-id')?.provider_session_id, null);

    // Simulate the next server boot: migrations run again while the session
    // still has no provider-native id.
    runMigrations(getConnection());

    assert.equal(sessionsDb.getSessionById('pending-app-id')?.provider_session_id, null);
  });
});

test('migrations repair an app session whose provider id was stamped by the old backfill', async () => {
  await withIsolatedDatabase(() => {
    const appId = '5a6b7c8d-9e0f-4a1b-8c2d-3e4f5a6b7c8d';
    sessionsDb.createAppSession(appId, 'claude', '/workspace/demo');
    getConnection()
      .prepare('UPDATE sessions SET provider_session_id = session_id WHERE session_id = ?')
      .run(appId);

    runMigrations(getConnection());

    assert.equal(sessionsDb.getSessionById(appId)?.provider_session_id, null);
  });
});

test('repair keeps disk-discovered and antigravity rows resumable', async () => {
  await withIsolatedDatabase(() => {
    // File-backed disk row: provider id equals the session id and a transcript
    // path exists, so the repair must leave it untouched.
    sessionsDb.createSession(
      'disk-native-id',
      'claude',
      '/workspace/demo',
      undefined,
      undefined,
      undefined,
      '/fake/disk-native-id.jsonl',
    );
    // Antigravity disk rows legitimately have no mirrored transcript path, so
    // the repair must not treat them as corrupted app rows.
    sessionsDb.createSession('9f1c2b3a-4d5e-4f60-8a71-2b3c4d5e6f70', 'antigravity', '/workspace/demo');

    runMigrations(getConnection());

    assert.equal(sessionsDb.getSessionById('disk-native-id')?.provider_session_id, 'disk-native-id');
    assert.equal(
      sessionsDb.getSessionById('9f1c2b3a-4d5e-4f60-8a71-2b3c4d5e6f70')?.provider_session_id,
      '9f1c2b3a-4d5e-4f60-8a71-2b3c4d5e6f70',
    );
  });
});
