import assert from 'node:assert/strict';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { listExternalClaudeRuns } from '@/modules/providers/services/sessions.service.js';

test('external claude runs: busy/waiting CLI sessions (tmux) count as running', async () => {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(os.tmpdir(), 'external-claude-runs-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(tempDirectory, 'auth.db');
  await initializeDatabase();

  try {
    const busyId = sessionsDb.createSession('cli-busy', 'claude', '/tmp/proj', 'busy');
    const waitingId = sessionsDb.createSession('cli-waiting', 'claude', '/tmp/proj', 'waiting');
    sessionsDb.createSession('cli-idle', 'claude', '/tmp/proj', 'idle');
    sessionsDb.createSession('sdk-busy', 'claude', '/tmp/proj', 'sdk');
    sessionsDb.createSession('cli-dead', 'claude', '/tmp/proj', 'dead');

    const write = (name: string, entry: Record<string, unknown>) =>
      writeFile(path.join(tempDirectory, name), JSON.stringify(entry));
    const alive = process.pid;
    await write('1.json', { pid: alive, sessionId: 'cli-busy', entrypoint: 'cli', status: 'busy', statusUpdatedAt: 42 });
    await write('2.json', { pid: alive, sessionId: 'cli-waiting', entrypoint: 'cli', status: 'waiting' });
    await write('3.json', { pid: alive, sessionId: 'cli-idle', entrypoint: 'cli', status: 'idle' });
    // The app's own SDK runs are tracked by the run registry, not here.
    await write('4.json', { pid: alive, sessionId: 'sdk-busy', entrypoint: 'sdk-ts', status: 'busy' });
    await write('5.json', { pid: 2 ** 22 + 1, sessionId: 'cli-dead', entrypoint: 'cli', status: 'busy' });
    await write('6.json', { pid: alive, sessionId: 'unknown', entrypoint: 'cli', status: 'busy' });
    await writeFile(path.join(tempDirectory, '7.json'), '{"pid":');

    const runs = listExternalClaudeRuns(tempDirectory);
    assert.deepEqual(
      runs.map((run) => run.sessionId).sort(),
      [busyId, waitingId].sort(),
    );
    assert.equal(runs.find((run) => run.sessionId === busyId)?.startedAt, 42);
    assert.ok(runs.every((run) => run.external && run.provider === 'claude'));
    assert.deepEqual(listExternalClaudeRuns(path.join(tempDirectory, 'missing')), []);
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
});
