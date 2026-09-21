import assert from 'node:assert/strict';
import test from 'node:test';

import Database from 'better-sqlite3';

import {
  collectDevinDbChangedFiles,
  collectOpenCodeChangedFiles,
} from '@/modules/providers/services/changed-files.service.js';

/**
 * Builds an in-memory OpenCode database holding one `session` table (with the
 * `parent_id` column current schemas carry) and one `part` table.
 */
function createOpenCodeDb(): Database.Database {
  const db = new Database(':memory:');
  db.exec(`
    CREATE TABLE session (id TEXT PRIMARY KEY, parent_id TEXT);
    CREATE TABLE part (id TEXT PRIMARY KEY, message_id TEXT, session_id TEXT, time_created INTEGER, data TEXT);
  `);
  return db;
}

function insertOpenCodeSession(db: Database.Database, id: string, parentId: string | null = null): void {
  db.prepare('INSERT INTO session (id, parent_id) VALUES (?, ?)').run(id, parentId);
}

function insertOpenCodePart(db: Database.Database, id: string, sessionId: string, data: Record<string, unknown>): void {
  db.prepare('INSERT INTO part (id, message_id, session_id, time_created, data) VALUES (?, ?, ?, 0, ?)')
    .run(id, `${id}_msg`, sessionId, JSON.stringify(data));
}

/**
 * Builds an in-memory Devin database with the `sessions` and `message_nodes`
 * tables the collector reads.
 */
function createDevinDb(): Database.Database {
  const db = new Database(':memory:');
  db.exec(`
    CREATE TABLE sessions (id TEXT PRIMARY KEY, main_chain_id INTEGER);
    CREATE TABLE message_nodes (row_id INTEGER PRIMARY KEY, session_id TEXT, node_id INTEGER, parent_node_id INTEGER, chat_message TEXT, created_at INTEGER);
  `);
  return db;
}

function insertDevinNode(
  db: Database.Database,
  sessionId: string,
  nodeId: number,
  parentNodeId: number | null,
  chatMessage: Record<string, unknown>,
): void {
  db.prepare('INSERT INTO message_nodes (session_id, node_id, parent_node_id, chat_message, created_at) VALUES (?, ?, ?, ?, ?)')
    .run(sessionId, nodeId, parentNodeId, JSON.stringify(chatMessage), nodeId);
}

test('collectOpenCodeChangedFiles merges root and descendant session edits with subagent flags', () => {
  const db = createOpenCodeDb();
  try {
    insertOpenCodeSession(db, 'root');
    insertOpenCodeSession(db, 'child', 'root');
    insertOpenCodeSession(db, 'grandchild', 'child');
    insertOpenCodeSession(db, 'unrelated');

    // VCS-level patch on the root session lists two files — one edit each.
    insertOpenCodePart(db, 'p1', 'root', {
      type: 'patch',
      hash: 'abc',
      files: ['/repo/src/a.ts', '/repo/src/b.ts'],
    });
    // An edit tool call on the root session touches a.ts a second time.
    insertOpenCodePart(db, 'p2', 'root', {
      type: 'tool',
      tool: 'edit',
      state: { input: { filePath: '/repo/src/a.ts', oldString: 'x', newString: 'y' } },
    });
    // A write tool call inside the child (subagent) session.
    insertOpenCodePart(db, 'p3', 'child', {
      type: 'tool',
      tool: 'write',
      state: { input: { file_path: '/repo/src/c.ts', content: 'hi' } },
    });
    // A patch part in the grandchild session also counts as subagent work.
    insertOpenCodePart(db, 'p4', 'grandchild', {
      type: 'patch',
      files: ['/repo/src/a.ts'],
    });
    // Non-edit parts and unrelated sessions contribute nothing.
    insertOpenCodePart(db, 'p5', 'root', { type: 'text', text: 'hello' });
    insertOpenCodePart(db, 'p6', 'root', {
      type: 'tool',
      tool: 'bash',
      state: { input: { command: 'ls' } },
    });
    insertOpenCodePart(db, 'p7', 'unrelated', {
      type: 'tool',
      tool: 'edit',
      state: { input: { filePath: '/repo/src/other.ts' } },
    });

    assert.deepEqual(collectOpenCodeChangedFiles(db, 'root'), [
      { path: '/repo/src/a.ts', edits: 3, subagent: true },
      { path: '/repo/src/b.ts', edits: 1, subagent: false },
      { path: '/repo/src/c.ts', edits: 1, subagent: true },
    ]);
  } finally {
    db.close();
  }
});

test('collectOpenCodeChangedFiles falls back to the root session when parent_id is missing', () => {
  const db = new Database(':memory:');
  try {
    db.exec(`
      CREATE TABLE session (id TEXT PRIMARY KEY);
      CREATE TABLE part (id TEXT PRIMARY KEY, message_id TEXT, session_id TEXT, time_created INTEGER, data TEXT);
    `);
    db.prepare('INSERT INTO session (id) VALUES (?)').run('root');
    insertOpenCodePart(db, 'p1', 'root', { type: 'patch', files: ['/repo/only.ts'] });
    // A stray part belonging to a session that would be a "child" if the column
    // existed must not be picked up without the parent_id link.
    insertOpenCodePart(db, 'p2', 'ghost-child', { type: 'patch', files: ['/repo/ghost.ts'] });

    assert.deepEqual(collectOpenCodeChangedFiles(db, 'root'), [
      { path: '/repo/only.ts', edits: 1, subagent: false },
    ]);
  } finally {
    db.close();
  }
});

test('collectDevinDbChangedFiles flags off-chain nodes as subagent edits', () => {
  const db = createDevinDb();
  try {
    db.prepare('INSERT INTO sessions (id, main_chain_id) VALUES (?, ?)').run('devin-session', 3);

    // Main chain: 1 -> 2 -> 3 (main_chain_id = 3).
    insertDevinNode(db, 'devin-session', 1, null, { role: 'user', content: 'hi' });
    insertDevinNode(db, 'devin-session', 2, 1, {
      role: 'assistant',
      tool_calls: [
        { id: 'c1', name: 'write', arguments: { file_path: '/repo/a.ts', content: 'x' } },
      ],
    });
    insertDevinNode(db, 'devin-session', 3, 2, {
      role: 'assistant',
      content: 'done',
      metadata: { finish_reason: 'stop' },
    });
    // Side branch (subagent work): node 4 hangs off node 1 and is not an
    // ancestor of the main-chain leaf.
    insertDevinNode(db, 'devin-session', 4, 1, {
      role: 'assistant',
      tool_calls: [
        { id: 'c2', name: 'Edit', arguments: { filePath: '/repo/b.ts' } },
        { id: 'c3', name: 'str_replace_editor', arguments: JSON.stringify({ file_path: '/repo/a.ts', old_str: 'x' }) },
        { id: 'c4', name: 'read', arguments: { file_path: '/repo/ignored.ts' } },
      ],
    });

    assert.deepEqual(collectDevinDbChangedFiles(db, 'devin-session'), [
      { path: '/repo/a.ts', edits: 2, subagent: true },
      { path: '/repo/b.ts', edits: 1, subagent: true },
    ]);
  } finally {
    db.close();
  }
});

test('collectDevinDbChangedFiles dedupes stream/final twin nodes and still flags true subagent branches', () => {
  const db = createDevinDb();
  try {
    db.prepare('INSERT INTO sessions (id, main_chain_id) VALUES (?, ?)').run('devin-session', 3);

    insertDevinNode(db, 'devin-session', 1, null, { role: 'user', content: 'hi', message_id: 'u1' });
    // Node 2 is the streamed assistant node (off the final chain); node 3 is
    // its final-turn twin on the main chain. Same message_id, same call id.
    insertDevinNode(db, 'devin-session', 2, 1, {
      role: 'assistant',
      message_id: 'a1',
      tool_calls: [{ id: 'call-1', name: 'edit', arguments: { file_path: '/repo/main.ts' } }],
    });
    insertDevinNode(db, 'devin-session', 3, 1, {
      role: 'assistant',
      message_id: 'a1',
      tool_calls: [{ id: 'call-1', name: 'edit', arguments: { file_path: '/repo/main.ts' } }],
    });
    // A real subagent branch: message_id never appears on the main chain.
    insertDevinNode(db, 'devin-session', 4, 1, {
      role: 'assistant',
      message_id: 'sub-1',
      tool_calls: [{ id: 'call-2', name: 'write', arguments: { file_path: '/repo/sub.ts' } }],
    });

    assert.deepEqual(collectDevinDbChangedFiles(db, 'devin-session'), [
      { path: '/repo/main.ts', edits: 1, subagent: false },
      { path: '/repo/sub.ts', edits: 1, subagent: true },
    ]);
  } finally {
    db.close();
  }
});

test('collectDevinDbChangedFiles treats every node as main-session when main_chain_id is null', () => {
  const db = createDevinDb();
  try {
    db.prepare('INSERT INTO sessions (id, main_chain_id) VALUES (?, ?)').run('devin-session', null);

    insertDevinNode(db, 'devin-session', 1, null, { role: 'user', content: 'hi' });
    insertDevinNode(db, 'devin-session', 2, 1, {
      role: 'assistant',
      tool_calls: [{ id: 'c1', name: 'multiedit', arguments: { file_path: '/repo/m.ts' } }],
    });
    insertDevinNode(db, 'devin-session', 3, 1, {
      role: 'assistant',
      tool_calls: [{ id: 'c2', name: 'apply_patch', arguments: { filePath: '/repo/p.ts' } }],
    });

    assert.deepEqual(collectDevinDbChangedFiles(db, 'devin-session'), [
      { path: '/repo/m.ts', edits: 1, subagent: false },
      { path: '/repo/p.ts', edits: 1, subagent: false },
    ]);
  } finally {
    db.close();
  }
});

test('collectDevinDbChangedFiles returns an empty list for unknown sessions', () => {
  const db = createDevinDb();
  try {
    insertDevinNode(db, 'other-session', 1, null, {
      role: 'assistant',
      tool_calls: [{ id: 'c1', name: 'write', arguments: { file_path: '/repo/x.ts' } }],
    });
    assert.deepEqual(collectDevinDbChangedFiles(db, 'devin-session'), []);
  } finally {
    db.close();
  }
});
