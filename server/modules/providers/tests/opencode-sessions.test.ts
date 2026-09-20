import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import Database from 'better-sqlite3';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { OpenCodeSessionSynchronizer } from '@/modules/providers/list/opencode/opencode-session-synchronizer.provider.js';
import { OpenCodeSessionsProvider } from '@/modules/providers/list/opencode/opencode-sessions.provider.js';
import { appendImagesInputTag } from '@/shared/image-attachments.js';

const patchHomeDir = (nextHomeDir: string) => {
  const original = os.homedir;
  (os as any).homedir = () => nextHomeDir;
  return () => {
    (os as any).homedir = original;
  };
};

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(os.tmpdir(), 'opencode-provider-db-'));
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

const createOpenCodeDatabase = async (homeDir: string, workspacePath: string): Promise<void> => {
  const dataDir = path.join(homeDir, '.local', 'share', 'opencode');
  await mkdir(dataDir, { recursive: true });

  const db = new Database(path.join(dataDir, 'opencode.db'));
  try {
    db.exec(`
      CREATE TABLE project (
        id TEXT PRIMARY KEY,
        worktree TEXT NOT NULL,
        vcs TEXT,
        name TEXT,
        icon_url TEXT,
        icon_color TEXT,
        time_created INTEGER NOT NULL,
        time_updated INTEGER NOT NULL,
        time_initialized INTEGER,
        sandboxes TEXT NOT NULL,
        commands TEXT,
        icon_url_override TEXT
      );

      CREATE TABLE session (
        id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        parent_id TEXT,
        slug TEXT NOT NULL,
        directory TEXT NOT NULL,
        title TEXT NOT NULL,
        version TEXT NOT NULL,
        share_url TEXT,
        summary_additions INTEGER,
        summary_deletions INTEGER,
        summary_files INTEGER,
        summary_diffs TEXT,
        revert TEXT,
        permission TEXT,
        time_created INTEGER NOT NULL,
        time_updated INTEGER NOT NULL,
        time_compacting INTEGER,
        time_archived INTEGER,
        workspace_id TEXT,
        path TEXT,
        agent TEXT,
        model TEXT,
        cost REAL NOT NULL DEFAULT 0,
        tokens_input INTEGER NOT NULL DEFAULT 0,
        tokens_output INTEGER NOT NULL DEFAULT 0,
        tokens_reasoning INTEGER NOT NULL DEFAULT 0,
        tokens_cache_read INTEGER NOT NULL DEFAULT 0,
        tokens_cache_write INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE
      );

      CREATE TABLE message (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        time_created INTEGER NOT NULL,
        time_updated INTEGER NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (session_id) REFERENCES session(id) ON DELETE CASCADE
      );

      CREATE TABLE part (
        id TEXT PRIMARY KEY,
        message_id TEXT NOT NULL,
        session_id TEXT NOT NULL,
        time_created INTEGER NOT NULL,
        time_updated INTEGER NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (message_id) REFERENCES message(id) ON DELETE CASCADE
      );

      CREATE INDEX part_session_idx ON part (session_id);
      CREATE INDEX session_project_idx ON session (project_id);
      CREATE INDEX message_session_time_created_id_idx ON message (session_id, time_created, id);
      CREATE INDEX part_message_id_id_idx ON part (message_id, id);
    `);

    db.prepare(
      'INSERT INTO project (id, worktree, time_created, time_updated, sandboxes) VALUES (?, ?, ?, ?, ?)',
    ).run(
      'project-1',
      workspacePath,
      1_700_000_000_000,
      1_700_000_001_000,
      '[]',
    );
    db.prepare(`
      INSERT INTO session (
        id, project_id, slug, directory, title, version, time_created, time_updated, time_archived,
        tokens_input, tokens_output, tokens_reasoning, tokens_cache_read, tokens_cache_write, cost
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).run(
      'open-session-1',
      'project-1',
      'open-session-1',
      workspacePath,
      'OpenCode indexed title',
      '0.0.0',
      1_700_000_000_000,
      1_700_000_004_000,
      null,
      10,
      20,
      7,
      3,
      2,
      1.25,
    );

    const userMessageData = JSON.stringify({
      role: 'user',
      time: { created: 1_700_000_001_000 },
      agent: 'test',
      model: { providerID: 'anthropic', modelID: 'claude' },
    });
    const assistantMessageData = JSON.stringify({
      role: 'assistant',
      time: { created: 1_700_000_002_000, completed: 1_700_000_003_000 },
      parentID: 'message-user',
      modelID: 'anthropic/claude-sonnet-4-5',
      providerID: 'anthropic',
      mode: 'default',
      agent: 'test',
      path: { cwd: '.', root: '.' },
      cost: 0.01,
      tokens: {
        input: 10,
        output: 20,
        reasoning: 0,
        cache: { read: 3, write: 2 },
      },
    });

    db.prepare(
      'INSERT INTO message (id, session_id, time_created, time_updated, data) VALUES (?, ?, ?, ?, ?)',
    ).run('message-user', 'open-session-1', 1_700_000_001_000, 1_700_000_001_500, userMessageData);
    db.prepare(
      'INSERT INTO message (id, session_id, time_created, time_updated, data) VALUES (?, ?, ?, ?, ?)',
    ).run('message-assistant', 'open-session-1', 1_700_000_002_000, 1_700_000_003_000, assistantMessageData);

    const insertPart = db.prepare(`
      INSERT INTO part (id, message_id, session_id, time_created, time_updated, data)
      VALUES (?, ?, ?, ?, ?, ?)
    `);
    insertPart.run(
      'part-user-text',
      'message-user',
      'open-session-1',
      1_700_000_001_000,
      1_700_000_001_000,
      JSON.stringify({
        type: 'text',
        text: JSON.stringify('Build the OpenCode integration.'),
      }),
    );
    insertPart.run(
      'part-reasoning',
      'message-assistant',
      'open-session-1',
      1_700_000_002_000,
      1_700_000_002_000,
      JSON.stringify({
        type: 'reasoning',
        text: 'I will inspect the provider shape first.',
        time: { start: 0, end: 1 },
      }),
    );
    insertPart.run(
      'part-assistant-text',
      'message-assistant',
      'open-session-1',
      1_700_000_002_500,
      1_700_000_002_500,
      JSON.stringify({
        type: 'text',
        text: 'The provider is wired.',
      }),
    );
    insertPart.run(
      'part-tool',
      'message-assistant',
      'open-session-1',
      1_700_000_003_000,
      1_700_000_003_000,
      JSON.stringify({
        type: 'tool',
        tool: 'bash',
        callID: 'tool-call-1',
        state: {
          status: 'completed',
          input: { command: 'npm test' },
          output: 'ok',
          title: 'bash',
          metadata: {},
          time: { start: 0, end: 1 },
        },
      }),
    );
  } finally {
    db.close();
  }
};

test('OpenCode session synchronizer indexes sqlite sessions without deletable transcript paths', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);
    await withIsolatedDatabase(() => {
      const synchronizer = new OpenCodeSessionSynchronizer();
      const processed = synchronizer.synchronize();

      return Promise.resolve(processed).then((count) => {
        assert.equal(count, 1);
        const indexed = sessionsDb.getSessionById('open-session-1');
        assert.equal(indexed?.provider, 'opencode');
        assert.equal(indexed?.project_path, workspacePath);
        assert.equal(indexed?.custom_name, 'OpenCode indexed title');
        assert.equal(indexed?.jsonl_path, null);
      });
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode session synchronizer returns the app session id once provider mapping exists', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-mapped-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);
    await withIsolatedDatabase(() => {
      sessionsDb.createAppSession('app-session-1', 'opencode', workspacePath);
      sessionsDb.assignProviderSessionId('app-session-1', 'open-session-1');

      const synchronizer = new OpenCodeSessionSynchronizer();
      return synchronizer.synchronizeFile(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db')).then((sessionId) => {
        assert.equal(sessionId, 'app-session-1');
        assert.equal(sessionsDb.getAllSessions().length, 1);
        assert.equal(sessionsDb.getSessionById('app-session-1')?.provider_session_id, 'open-session-1');
      });
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode session synchronizer adopts the pending app session before watcher sync creates a duplicate', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-race-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);
    await withIsolatedDatabase(() => {
      sessionsDb.createAppSession('app-session-race', 'opencode', workspacePath);

      const synchronizer = new OpenCodeSessionSynchronizer();
      return synchronizer.synchronizeFile(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db')).then((sessionId) => {
        assert.equal(sessionId, 'app-session-race');
        assert.equal(sessionsDb.getAllSessions().length, 1);
        assert.equal(sessionsDb.getSessionById('app-session-race')?.provider_session_id, 'open-session-1');
      });
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode session synchronizer skips and purges child (subagent) sessions', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-subagent-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    // Add a child session (OpenCode Task/subagent) alongside the root session.
    const db = new Database(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db'));
    try {
      db.prepare(`
        INSERT INTO session (
          id, project_id, parent_id, slug, directory, title, version, time_created, time_updated, time_archived,
          tokens_input, tokens_output, tokens_reasoning, tokens_cache_read, tokens_cache_write
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 0, 0, 0)
      `).run(
        'open-child-1',
        'project-1',
        'open-session-1',
        'open-child-1',
        workspacePath,
        'Subagent child (@general subagent)',
        '0.0.0',
        1_700_000_005_000,
        1_700_000_006_000,
        null,
      );
    } finally {
      db.close();
    }

    await withIsolatedDatabase(() => {
      const synchronizer = new OpenCodeSessionSynchronizer();
      return Promise.resolve(synchronizer.synchronize()).then((count) => {
        assert.equal(count, 1);
        assert.equal(sessionsDb.getSessionById('open-child-1'), null, 'child row should not be indexed');
        assert.equal(sessionsDb.getSessionById('open-session-1')?.provider, 'opencode');
      });
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode session synchronizer purges a previously indexed child session', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-purge-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    const db = new Database(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db'));
    try {
      db.prepare(`
        INSERT INTO session (
          id, project_id, parent_id, slug, directory, title, version, time_created, time_updated, time_archived,
          tokens_input, tokens_output, tokens_reasoning, tokens_cache_read, tokens_cache_write
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 0, 0, 0)
      `).run(
        'open-child-legacy',
        'project-1',
        'open-session-1',
        'open-child-legacy',
        workspacePath,
        'Legacy indexed subagent',
        '0.0.0',
        1_700_000_005_000,
        1_700_000_006_000,
        null,
      );
    } finally {
      db.close();
    }

    await withIsolatedDatabase(() => {
      // Simulate a row an earlier version indexed for the child session.
      sessionsDb.createSession('open-child-legacy', 'opencode', workspacePath, 'Legacy indexed subagent');

      const synchronizer = new OpenCodeSessionSynchronizer();
      return Promise.resolve(synchronizer.synchronize()).then(() => {
        assert.equal(sessionsDb.getSessionById('open-child-legacy'), null, 'legacy child row should be purged');
        assert.equal(sessionsDb.getSessionById('open-session-1')?.provider, 'opencode');
      });
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider strips <images_input> from user turns and exposes attachments', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-images-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    // Rewrite the user text part with the tagged prompt the runtime sends.
    const taggedPrompt = appendImagesInputTag('Look at this screenshot.', [
      { path: 'C:/Users/x/.ddagent/assets/shot.png' },
    ]);
    const db = new Database(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db'));
    try {
      db.prepare('UPDATE part SET data = ? WHERE id = ?').run(
        JSON.stringify({ type: 'text', text: taggedPrompt }),
        'part-user-text',
      );
    } finally {
      db.close();
    }

    const provider = new OpenCodeSessionsProvider();
    const history = await provider.fetchHistory('open-session-1');
    const userMessage = history.messages.find((message) => message.kind === 'text' && message.role === 'user');

    assert.equal(userMessage?.content, 'Look at this screenshot.');
    assert.deepEqual(userMessage?.images, [{ path: 'C:/Users/x/.ddagent/assets/shot.png' }]);
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider merges multiple text parts of one user message into a single bubble', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-merge-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    // Real opencode.db rows attach injected reminder/context parts to the
    // same user message; they must not render as extra chat bubbles.
    const db = new Database(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db'));
    try {
      db.prepare(`
        INSERT INTO part (id, message_id, session_id, time_created, time_updated, data)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(
        'part-user-reminder',
        'message-user',
        'open-session-1',
        1_700_000_001_100,
        1_700_000_001_100,
        JSON.stringify({ type: 'text', text: 'Injected reminder context.' }),
      );
    } finally {
      db.close();
    }

    const provider = new OpenCodeSessionsProvider();
    const history = await provider.fetchHistory('open-session-1');
    const userMessages = history.messages.filter(
      (message) => message.kind === 'text' && message.role === 'user',
    );

    assert.equal(userMessages.length, 1);
    assert.equal(userMessages[0]?.id, 'message-user_part-user-text');
    assert.equal(userMessages[0]?.content, 'Build the OpenCode integration.\n\nInjected reminder context.');
    assert.equal(history.total, 4);
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider collapses a double-persisted user turn into one bubble', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-duprow-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    // Upstream OpenCode can process one prompt twice server-side and persist
    // it as two message rows (anomalyco/opencode#27928): same text, different
    // message ids, seconds apart. They must render as one bubble.
    const db = new Database(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db'));
    try {
      db.prepare(
        'INSERT INTO message (id, session_id, time_created, time_updated, data) VALUES (?, ?, ?, ?, ?)',
      ).run(
        'message-user-dup',
        'open-session-1',
        1_700_000_001_400,
        1_700_000_001_400,
        JSON.stringify({ role: 'user', time: { created: 1_700_000_001_400 } }),
      );
      db.prepare(`
        INSERT INTO part (id, message_id, session_id, time_created, time_updated, data)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(
        'part-user-text-dup',
        'message-user-dup',
        'open-session-1',
        1_700_000_001_500,
        1_700_000_001_500,
        JSON.stringify({ type: 'text', text: JSON.stringify('Build the OpenCode integration.') }),
      );
    } finally {
      db.close();
    }

    const provider = new OpenCodeSessionsProvider();
    const history = await provider.fetchHistory('open-session-1');
    const userMessages = history.messages.filter(
      (message) => message.kind === 'text' && message.role === 'user',
    );

    assert.equal(userMessages.length, 1);
    assert.equal(userMessages[0]?.content, 'Build the OpenCode integration.');
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider keeps synthetic parts out of persisted user bubbles', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-synthetic-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    // Plugin-injected reminder parts are flagged synthetic in real opencode.db
    // rows; they are model context, not user-authored text.
    const db = new Database(path.join(tempRoot, '.local', 'share', 'opencode', 'opencode.db'));
    try {
      db.prepare(`
        INSERT INTO part (id, message_id, session_id, time_created, time_updated, data)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(
        'part-user-synthetic',
        'message-user',
        'open-session-1',
        1_700_000_001_100,
        1_700_000_001_100,
        JSON.stringify({ type: 'text', text: 'Injected reminder context.', synthetic: true }),
      );
    } finally {
      db.close();
    }

    const provider = new OpenCodeSessionsProvider();
    const history = await provider.fetchHistory('open-session-1');
    const userMessages = history.messages.filter(
      (message) => message.kind === 'text' && message.role === 'user',
    );

    assert.equal(userMessages.length, 1);
    assert.equal(userMessages[0]?.content, 'Build the OpenCode integration.');
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider drops live text echoes of persisted user messages', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-live-echo-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);

    // `message.part.updated` frames carry no role — the parent message's
    // persisted role must be used or the user's own prompt streams back as an
    // assistant bubble next to the optimistic one.
    const provider = new OpenCodeSessionsProvider();
    const userPart = provider.normalizeMessage({
      type: 'text',
      sessionID: 'open-session-1',
      part: {
        id: 'part-user-text',
        messageID: 'message-user',
        sessionID: 'open-session-1',
        type: 'text',
        text: 'Build the OpenCode integration.',
      },
    }, 'open-session-1');
    assert.deepEqual(userPart, []);

    const assistantPart = provider.normalizeMessage({
      type: 'text',
      sessionID: 'open-session-1',
      part: {
        id: 'part-assistant-text',
        messageID: 'message-assistant',
        sessionID: 'open-session-1',
        type: 'text',
        text: 'The provider is wired.',
      },
    }, 'open-session-1');
    assert.equal(assistantPart.length, 1);
    assert.equal(assistantPart[0]?.role, 'assistant');
    assert.equal(assistantPart[0]?.content, 'The provider is wired.');
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider drops synthetic live text parts', () => {
  const provider = new OpenCodeSessionsProvider();
  const normalized = provider.normalizeMessage({
    type: 'text',
    sessionID: 'open-session-live',
    part: {
      id: 'prt-synthetic-1',
      messageID: 'msg-live-1',
      sessionID: 'open-session-live',
      type: 'text',
      text: 'Injected reminder context.',
      synthetic: true,
    },
  }, null);

  assert.deepEqual(normalized, []);
});

test('OpenCode sessions provider normalizes quoted live text and skips user echoes', () => {
  const provider = new OpenCodeSessionsProvider();
  const normalized = provider.normalizeMessage({
    type: 'text',
    sessionID: 'open-session-live',
    text: JSON.stringify('hello bro'),
  }, null);

  assert.equal(normalized.length, 1);
  assert.equal(normalized[0]?.kind, 'stream_delta');
  assert.equal(normalized[0]?.content, 'hello bro');

  const userEcho = provider.normalizeMessage({
    type: 'text',
    sessionID: 'open-session-live',
    role: 'user',
    text: 'hello bro',
  }, null);

  assert.deepEqual(userEcho, []);
});

test('OpenCode sessions provider normalizes real part-wrapped live events', () => {
  const provider = new OpenCodeSessionsProvider();

  const text = provider.normalizeMessage({
    type: 'text',
    timestamp: 1788473634938,
    sessionID: 'ses-live-1',
    part: {
      id: 'prt-text-1',
      messageID: 'msg-1',
      sessionID: 'ses-live-1',
      type: 'text',
      text: 'Hello from part!',
      time: { start: 1788473633479, end: 1788473634872 },
    },
  }, null);

  assert.equal(text.length, 1);
  assert.equal(text[0]?.kind, 'text');
  assert.equal(text[0]?.role, 'assistant');
  assert.equal(text[0]?.content, 'Hello from part!');
  assert.equal(text[0]?.id, 'msg-1_prt-text-1');
  assert.equal(text[0]?.sessionId, 'ses-live-1');

  const stepStart = provider.normalizeMessage({
    type: 'step_start',
    timestamp: 1788473632700,
    sessionID: 'ses-live-1',
    part: {
      id: 'prt-step-1',
      messageID: 'msg-1',
      sessionID: 'ses-live-1',
      type: 'step-start',
    },
  }, null);

  assert.equal(stepStart.length, 1);
  assert.equal(stepStart[0]?.kind, 'status');
  assert.equal(stepStart[0]?.text, 'Thinking');

  const tool = provider.normalizeMessage({
    type: 'tool_use',
    timestamp: 1788473655468,
    sessionID: 'ses-live-1',
    part: {
      id: 'prt-tool-1',
      messageID: 'msg-1',
      sessionID: 'ses-live-1',
      type: 'tool',
      tool: 'task',
      callID: 'chatcmpl-tool-1',
      state: {
        status: 'completed',
        input: { prompt: 'do the thing' },
        output: 'Subagent finished.',
        time: { start: 1788473655440, end: 1788473655460 },
      },
    },
  }, null);

  assert.equal(tool.length, 2);
  assert.equal(tool[0]?.kind, 'tool_use');
  assert.equal(tool[0]?.toolName, 'Task');
  assert.equal(tool[0]?.toolId, 'chatcmpl-tool-1');
  assert.deepEqual(tool[0]?.toolInput, { prompt: 'do the thing' });
  assert.equal(tool[0]?.toolResult?.content, 'Subagent finished.');
  assert.equal(tool[0]?.toolResult?.isError, false);
  assert.equal(tool[1]?.kind, 'tool_result');
  assert.equal(tool[1]?.toolId, 'chatcmpl-tool-1');

  const bashTool = provider.normalizeMessage({
    type: 'tool_use',
    sessionID: 'ses-live-1',
    part: {
      type: 'tool',
      tool: 'bash',
      callID: 'chatcmpl-tool-2',
      state: {
        status: 'error',
        input: { command: 'rm -rf /' },
        error: 'Permission denied',
      },
    },
  }, null);

  assert.equal(bashTool.length, 2);
  assert.equal(bashTool[0]?.toolName, 'bash');
  assert.equal(bashTool[0]?.toolResult?.isError, true);
  assert.ok(String(bashTool[0]?.toolResult?.content).includes('Permission denied'));
});

test('OpenCode sessions provider extracts nested error messages', () => {
  const provider = new OpenCodeSessionsProvider();

  const nestedData = provider.normalizeMessage({
    type: 'error',
    sessionID: 'open-session-live',
    error: {
      name: 'UnknownError',
      data: { message: 'Model not found: opencode/deepseek-v4-flash' },
    },
  }, null);

  assert.equal(nestedData.length, 1);
  assert.equal(nestedData[0]?.kind, 'error');
  assert.equal(nestedData[0]?.content, 'Model not found: opencode/deepseek-v4-flash');

  const nestedMessage = provider.normalizeMessage({
    type: 'error',
    sessionID: 'open-session-live',
    error: { message: 'Plain object message' },
  }, null);

  assert.equal(nestedMessage[0]?.content, 'Plain object message');

  const stringError = provider.normalizeMessage({
    type: 'error',
    sessionID: 'open-session-live',
    error: 'String error message',
  }, null);

  assert.equal(stringError[0]?.content, 'String error message');

  const fallback = provider.normalizeMessage({
    type: 'error',
    sessionID: 'open-session-live',
    message: 'Fallback message',
  }, null);

  assert.equal(fallback[0]?.content, 'Fallback message');
});

test('OpenCode sessions provider reads sqlite history and token usage', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-history-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await createOpenCodeDatabase(tempRoot, workspacePath);
    const provider = new OpenCodeSessionsProvider();
    const history = await provider.fetchHistory('open-session-1');

    assert.equal(history.total, 4);
    assert.equal(history.messages[0]?.kind, 'text');
    assert.equal(history.messages[0]?.role, 'user');
    assert.equal(history.messages[0]?.content, 'Build the OpenCode integration.');
    assert.equal(history.messages[1]?.kind, 'thinking');
    assert.equal(history.messages[2]?.content, 'The provider is wired.');
    assert.equal(history.messages[3]?.kind, 'tool_use');
    assert.deepEqual(history.messages[3]?.toolResult, { content: 'ok', isError: false });
    assert.deepEqual(history.tokenUsage, {
      used: 42,
      inputTokens: 10,
      outputTokens: 20,
      cacheReadTokens: 3,
      cacheCreationTokens: 2,
      costUsd: 1.25,
      breakdown: {
        input: 10,
        output: 20,
        cacheRead: 3,
        cacheCreation: 2,
      },
    });

    const paged = await provider.fetchHistory('open-session-1', { limit: 2, offset: 0 });
    assert.equal(paged.messages.length, 2);
    assert.equal(paged.hasMore, true);
    assert.equal(paged.messages[0]?.content, 'The provider is wired.');
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

/**
 * Seeds a single OpenCode session with a controllable stored title and first
 * user message. Uses a minimal schema (only the columns the synchronizer reads)
 * with a plain-text user part so the derived name is unambiguous.
 */
const seedOpenCodeSession = async (
  homeDir: string,
  workspacePath: string,
  options: { sessionId: string; title: string | null; firstUserText: string },
): Promise<void> => {
  const dataDir = path.join(homeDir, '.local', 'share', 'opencode');
  await mkdir(dataDir, { recursive: true });

  const db = new Database(path.join(dataDir, 'opencode.db'));
  try {
    db.exec(`
      CREATE TABLE project (id TEXT PRIMARY KEY, worktree TEXT);
      CREATE TABLE session (
        id TEXT PRIMARY KEY,
        project_id TEXT,
        directory TEXT,
        title TEXT,
        time_created INTEGER,
        time_updated INTEGER,
        time_archived INTEGER
      );
      CREATE TABLE message (id TEXT PRIMARY KEY, session_id TEXT, time_created INTEGER, data TEXT);
      CREATE TABLE part (id TEXT PRIMARY KEY, message_id TEXT, session_id TEXT, time_created INTEGER, data TEXT);
    `);

    db.prepare('INSERT INTO project (id, worktree) VALUES (?, ?)').run('project-1', workspacePath);
    db.prepare(`
      INSERT INTO session (id, project_id, directory, title, time_created, time_updated, time_archived)
      VALUES (?, ?, ?, ?, ?, ?, NULL)
    `).run(options.sessionId, 'project-1', workspacePath, options.title, 1_700_000_000_000, 1_700_000_001_000);
    db.prepare('INSERT INTO message (id, session_id, time_created, data) VALUES (?, ?, ?, ?)')
      .run('message-user', options.sessionId, 1_700_000_001_000, JSON.stringify({ role: 'user' }));
    db.prepare('INSERT INTO part (id, message_id, session_id, time_created, data) VALUES (?, ?, ?, ?, ?)')
      .run(
        'part-user',
        'message-user',
        options.sessionId,
        1_700_000_001_000,
        // OpenCode persists the prompt as a JSON string literal inside the text
        // field, so double-encode it here to exercise the unwrap on read.
        JSON.stringify({ type: 'text', text: JSON.stringify(options.firstUserText) }),
      );
  } finally {
    db.close();
  }
};

test('OpenCode synchronizer preserves the title assigned when ddagent creates a session', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-app-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    // Both provider-owned values differ from the ddagent title so either one
    // leaking through would change the assertion below.
    await seedOpenCodeSession(tempRoot, workspacePath, {
      sessionId: 'oc-app-1',
      title: 'OpenCode generated title',
      firstUserText: 'OpenCode first user prompt',
    });
    await withIsolatedDatabase(async () => {
      sessionsDb.createAppSession('app-1', 'opencode', workspacePath, 'Fix the checkout crash');
      sessionsDb.assignProviderSessionId('app-1', 'oc-app-1');

      await new OpenCodeSessionSynchronizer().synchronize();

      assert.equal(sessionsDb.getSessionById('app-1')?.custom_name, 'Fix the checkout crash');
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode synchronizer keeps the stored title for indexed sessions', { concurrency: false }, async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-session-sync-indexed-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);

  try {
    await seedOpenCodeSession(tempRoot, workspacePath, {
      sessionId: 'oc-indexed-1',
      title: 'OpenCode generated title',
      firstUserText: 'This prompt should be ignored',
    });
    await withIsolatedDatabase(async () => {
      await new OpenCodeSessionSynchronizer().synchronize();

      assert.equal(sessionsDb.getSessionById('oc-indexed-1')?.custom_name, 'OpenCode generated title');
    });
  } finally {
    restoreHomeDir();
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('OpenCode sessions provider normalizes live patch and agent DCP events', () => {
  const provider = new OpenCodeSessionsProvider();

  const patch = provider.normalizeMessage({
    type: 'patch',
    sessionID: 'open-dcp-1',
    part: {
      id: 'prt-patch-1',
      messageID: 'msg-patch-1',
      type: 'patch',
      files: ['src/index.ts'],
      hash: 'abc123def456',
    },
  }, null);

  assert.equal(patch.length, 1);
  assert.equal(patch[0]?.kind, 'tool_use');
  assert.equal(patch[0]?.toolName, 'Patch');
  assert.equal(patch[0]?.toolResult?.isError, false);
  assert.ok(String(patch[0]?.toolResult?.content).includes('src/index.ts'));

  const agent = provider.normalizeMessage({
    type: 'agent',
    sessionID: 'open-dcp-1',
    part: {
      id: 'prt-agent-1',
      messageID: 'msg-agent-1',
      type: 'agent',
      description: 'Researching dependencies',
    },
  }, null);

  assert.equal(agent.length, 1);
  assert.equal(agent[0]?.kind, 'tool_use');
  assert.equal(agent[0]?.toolName, 'Agent');
  assert.equal(agent[0]?.toolResult, undefined);
});
