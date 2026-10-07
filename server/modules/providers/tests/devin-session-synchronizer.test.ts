import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import Database from 'better-sqlite3';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { DevinSessionSynchronizer } from '@/modules/providers/list/devin/devin-session-synchronizer.provider.js';

/** Points both the XDG and Windows home lookups at an isolated temp home. */
const patchHomeDir = (nextHomeDir: string) => {
  const originalHomedir = os.homedir;
  const originalAppData = process.env.APPDATA;
  (os as { homedir: () => string }).homedir = () => nextHomeDir;
  process.env.APPDATA = path.join(nextHomeDir, 'AppData', 'Roaming');
  return () => {
    (os as { homedir: () => string }).homedir = originalHomedir;
    if (originalAppData === undefined) {
      delete process.env.APPDATA;
    } else {
      process.env.APPDATA = originalAppData;
    }
  };
};

const devinCliDir = (homeDir: string): string =>
  process.platform === 'win32'
    ? path.join(process.env.APPDATA ?? path.join(homeDir, 'AppData', 'Roaming'), 'devin', 'cli')
    : path.join(homeDir, '.local', 'share', 'devin', 'cli');

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(os.tmpdir(), 'devin-sync-db-'));
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

type SeedRow = {
  id: string;
  workingDirectory: string;
  title: string | null;
  createdAt?: number;
  lastActivityAt?: number;
  hidden?: number;
};

/** Creates a minimal Devin CLI `cli/sessions.db` with the indexed columns. */
async function seedDevinDatabase(homeDir: string, rows: SeedRow[]): Promise<string> {
  const cliDir = devinCliDir(homeDir);
  await mkdir(cliDir, { recursive: true });
  const dbPath = path.join(cliDir, 'sessions.db');

  const db = new Database(dbPath);
  try {
    db.exec(`
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        working_directory TEXT,
        title TEXT,
        created_at INTEGER,
        last_activity_at INTEGER,
        hidden INTEGER
      );
    `);
    const insert = db.prepare(
      'INSERT INTO sessions (id, working_directory, title, created_at, last_activity_at, hidden) VALUES (?, ?, ?, ?, ?, ?)',
    );
    for (const row of rows) {
      insert.run(
        row.id,
        row.workingDirectory,
        row.title,
        row.createdAt ?? 1_700_000_000,
        row.lastActivityAt ?? 1_700_000_100,
        row.hidden ?? 0,
      );
    }
  } finally {
    db.close();
  }

  return dbPath;
}

test('Devin session synchronizer indexes sessions whose working directory is outside /workspace', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'devin-sync-paths-'));
  const restoreHomeDir = patchHomeDir(tempRoot);
  const repoA = path.join(tempRoot, 'repo-a');
  const repoB = path.join(tempRoot, 'repo-b');

  try {
    await mkdir(repoA, { recursive: true });
    await mkdir(repoB, { recursive: true });
    await seedDevinDatabase(tempRoot, [
      { id: 'dev-a', workingDirectory: repoA, title: 'Fix the Windows sync', lastActivityAt: 1_791_372_488 },
      { id: 'dev-b', workingDirectory: repoB, title: null },
    ]);

    await withIsolatedDatabase(async () => {
      const processed = await new DevinSessionSynchronizer().synchronize();

      assert.equal(processed, 2);
      const a = sessionsDb.getSessionById('dev-a');
      assert.equal(a?.provider, 'devin');
      assert.equal(a?.project_path, repoA);
      assert.equal(a?.custom_name, 'Fix the Windows sync');
      assert.equal(a?.provider_session_id, 'dev-a');

      const b = sessionsDb.getSessionById('dev-b');
      assert.equal(b?.provider, 'devin');
      assert.equal(b?.project_path, repoB);
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('Devin session synchronizer skips hidden and subagent-only sessions', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'devin-sync-skips-'));
  const restoreHomeDir = patchHomeDir(tempRoot);
  const repo = path.join(tempRoot, 'repo');

  try {
    await mkdir(repo, { recursive: true });
    await seedDevinDatabase(tempRoot, [
      { id: 'dev-visible', workingDirectory: repo, title: 'Visible work' },
      { id: 'dev-hidden', workingDirectory: repo, title: 'Hidden work', hidden: 1 },
      { id: 'dev-subagent', workingDirectory: repo, title: 'Delegate (@general subagent)' },
    ]);

    await withIsolatedDatabase(async () => {
      const processed = await new DevinSessionSynchronizer().synchronize();

      assert.equal(processed, 1);
      assert.equal(sessionsDb.getSessionById('dev-visible')?.provider, 'devin');
      assert.equal(sessionsDb.getSessionById('dev-hidden'), null);
      assert.equal(sessionsDb.getSessionById('dev-subagent'), null);
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('Devin session synchronizer adopts the pending app session instead of creating a duplicate', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'devin-sync-adopt-'));
  const restoreHomeDir = patchHomeDir(tempRoot);
  const repo = path.join(tempRoot, 'repo');

  try {
    await mkdir(repo, { recursive: true });
    await seedDevinDatabase(tempRoot, [{ id: 'dev-app', workingDirectory: repo, title: 'App run' }]);

    await withIsolatedDatabase(async () => {
      sessionsDb.createAppSession('app-session-1', 'devin', repo);

      await new DevinSessionSynchronizer().synchronize();

      assert.equal(sessionsDb.getAllSessions().length, 1);
      assert.equal(sessionsDb.getSessionById('app-session-1')?.provider_session_id, 'dev-app');
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('Devin session synchronizer indexes a single transcript file from the native metadata', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'devin-sync-file-'));
  const restoreHomeDir = patchHomeDir(tempRoot);
  const repo = path.join(tempRoot, 'repo');
  const transcriptDir = path.join(repo, '.ddagent', 'devin');

  try {
    await mkdir(transcriptDir, { recursive: true });
    const transcriptPath = path.join(transcriptDir, 'dev-file.jsonl');
    await writeFile(
      transcriptPath,
      `${JSON.stringify({ sessionId: 'dev-file', timestamp: '2026-10-07T10:00:00.000Z' })}\n`,
    );
    await seedDevinDatabase(tempRoot, [
      { id: 'dev-file', workingDirectory: repo, title: 'Single file sync', lastActivityAt: 1_791_372_488 },
    ]);

    await withIsolatedDatabase(async () => {
      const sessionId = await new DevinSessionSynchronizer().synchronizeFile(transcriptPath);

      assert.equal(sessionId, 'dev-file');
      const indexed = sessionsDb.getSessionById('dev-file');
      assert.equal(indexed?.provider, 'devin');
      assert.equal(indexed?.project_path, repo);
      assert.equal(indexed?.custom_name, 'Single file sync');
      assert.equal(indexed?.jsonl_path, transcriptPath);
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});
