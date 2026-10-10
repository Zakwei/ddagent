import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, providerAccountsDb, sessionsDb } from '@/modules/database/index.js';
import { ClaudeSessionsProvider } from '@/modules/providers/list/claude/claude-sessions.provider.js';

const jsonl = (rows: unknown[]) => `${rows.map((row) => JSON.stringify(row)).join('\n')}\n`;

const transcript = (providerSessionId: string, text: string) => jsonl([
  { sessionId: providerSessionId, type: 'user', timestamp: '2026-10-10T10:00:00Z', message: { role: 'user', content: text } },
]);

async function withClaudeDirs(
  runTest: (dirs: { root: string; ambient: string; account: string }) => Promise<void>,
): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const previousConfigDir = process.env.CLAUDE_CONFIG_DIR;
  const root = await mkdtemp(path.join(tmpdir(), 'claude-account-history-'));
  const ambient = path.join(root, 'ambient');
  const account = path.join(root, 'account');
  closeConnection();
  process.env.DATABASE_PATH = path.join(root, 'auth.db');
  process.env.CLAUDE_CONFIG_DIR = ambient;
  await initializeDatabase();
  try {
    await runTest({ root, ambient, account });
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) delete process.env.DATABASE_PATH;
    else process.env.DATABASE_PATH = previousDatabasePath;
    if (previousConfigDir === undefined) delete process.env.CLAUDE_CONFIG_DIR;
    else process.env.CLAUDE_CONFIG_DIR = previousConfigDir;
    await rm(root, { recursive: true, force: true });
  }
}

test('claude history: a session on an isolated account reads the transcript from that account', async () => {
  await withClaudeDirs(async ({ account }) => {
    await mkdir(path.join(account, 'projects', '-p'), { recursive: true });
    await writeFile(path.join(account, 'projects', '-p', 'prov-1.jsonl'), transcript('prov-1', 'on the account'));
    providerAccountsDb.create({ id: 'acc-1', provider: 'claude', label: '1', envOverrides: { CLAUDE_CONFIG_DIR: account } });
    sessionsDb.createAppSession('app-1', 'claude', '/tmp/p', 'hi', 'acc-1');
    sessionsDb.assignProviderSessionId('app-1', 'prov-1');

    const result = await new ClaudeSessionsProvider().fetchHistory('app-1', { providerSessionId: 'prov-1' });
    assert.equal(result.total, 1, 'no jsonl_path is indexed for account sessions — the account dir is searched');
  });
});

test('claude history: after an account switch the current account copy wins over the indexed path', async () => {
  await withClaudeDirs(async ({ ambient, account }) => {
    const ambientFile = path.join(ambient, 'projects', '-p', 'prov-2.jsonl');
    await mkdir(path.dirname(ambientFile), { recursive: true });
    await writeFile(ambientFile, transcript('prov-2', 'stale ambient copy'));
    await mkdir(path.join(account, 'projects', '-p'), { recursive: true });
    await writeFile(path.join(account, 'projects', '-p', 'prov-2.jsonl'), `${transcript('prov-2', 'carried over')}${
      transcript('prov-2', 'continued on the new account')}`);
    providerAccountsDb.create({ id: 'acc-2', provider: 'claude', label: '2', envOverrides: { CLAUDE_CONFIG_DIR: account } });
    sessionsDb.createAppSession('app-2', 'claude', '/tmp/p', 'hi', 'acc-2');
    sessionsDb.assignProviderSessionId('app-2', 'prov-2');
    // The synchronizer indexed the ambient copy before the session moved.
    sessionsDb.createSession('prov-2', 'claude', '/tmp/p', undefined, undefined, undefined, ambientFile);
    assert.equal(sessionsDb.getSessionById('app-2')?.jsonl_path, ambientFile);

    const result = await new ClaudeSessionsProvider().fetchHistory('app-2', { providerSessionId: 'prov-2' });
    assert.equal(result.total, 2);
  });
});

test('claude history: an ambient session still reads the indexed path', async () => {
  await withClaudeDirs(async ({ ambient }) => {
    const ambientFile = path.join(ambient, 'projects', '-p', 'prov-3.jsonl');
    await mkdir(path.dirname(ambientFile), { recursive: true });
    await writeFile(ambientFile, transcript('prov-3', 'ambient'));
    const appSessionId = sessionsDb.createSession('prov-3', 'claude', '/tmp/p', undefined, undefined, undefined, ambientFile);

    const result = await new ClaudeSessionsProvider().fetchHistory(appSessionId, { providerSessionId: 'prov-3' });
    assert.equal(result.total, 1);
  });
});
