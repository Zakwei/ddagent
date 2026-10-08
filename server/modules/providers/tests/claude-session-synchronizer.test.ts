import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { ClaudeSessionSynchronizer } from '@/modules/providers/list/claude/claude-session-synchronizer.provider.js';

test('claude sync: subagent transcripts in either layout are never indexed as sessions', async () => {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const root = await mkdtemp(path.join(tmpdir(), 'claude-sync-'));
  const projectDir = path.join(root, 'projects', '-workspace-demo');
  await mkdir(path.join(projectDir, 'sess-1', 'subagents'), { recursive: true });
  // A subagent transcript repeats the parent's sessionId — indexing it would
  // repoint the parent row's jsonl_path at the subagent file.
  const row = JSON.stringify({
    sessionId: 'sess-1', cwd: '/workspace/demo', type: 'user', timestamp: '2026-10-07T10:00:00Z',
    message: { role: 'user', content: 'subagent prompt' },
  });
  const legacy = path.join(projectDir, 'agent-a1b2c3.jsonl');
  const current = path.join(projectDir, 'sess-1', 'subagents', 'agent-a1.jsonl');
  await writeFile(legacy, `${row}\n`);
  await writeFile(current, `${row}\n`);

  closeConnection();
  process.env.DATABASE_PATH = path.join(root, 'auth.db');
  await initializeDatabase();
  try {
    const synchronizer = new ClaudeSessionSynchronizer();
    assert.equal(await synchronizer.synchronizeFile(legacy), null);
    assert.equal(await synchronizer.synchronizeFile(current), null);
    assert.equal(sessionsDb.getSessionById('sess-1'), null);
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(root, { recursive: true, force: true });
  }
});
