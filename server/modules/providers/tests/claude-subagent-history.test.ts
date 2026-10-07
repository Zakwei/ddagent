import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, sessionsDb } from '@/modules/database/index.js';
import { ClaudeSessionsProvider } from '@/modules/providers/list/claude/claude-sessions.provider.js';

const jsonl = (rows: unknown[]) => `${rows.map((row) => JSON.stringify(row)).join('\n')}\n`;

test('claude history: subagent tool calls from <session>/subagents nest under the Agent call', async () => {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const root = await mkdtemp(path.join(tmpdir(), 'claude-subagent-history-'));
  const projectDir = path.join(root, 'project');
  const sessionId = 'sess-1';
  await mkdir(path.join(projectDir, sessionId, 'subagents'), { recursive: true });

  const transcriptPath = path.join(projectDir, `${sessionId}.jsonl`);
  await writeFile(transcriptPath, jsonl([
    { sessionId, type: 'user', timestamp: '2026-10-07T10:00:00Z', message: { role: 'user', content: 'audit it' } },
    {
      sessionId, type: 'assistant', timestamp: '2026-10-07T10:00:01Z',
      message: { role: 'assistant', content: [{ type: 'tool_use', id: 'toolu_agent', name: 'Agent', input: { description: 'Audit' } }] },
    },
    {
      sessionId, type: 'user', timestamp: '2026-10-07T10:00:09Z', toolUseResult: { agentId: 'abc' },
      message: { role: 'user', content: [{ type: 'tool_result', tool_use_id: 'toolu_agent', content: [{ type: 'text', text: 'All good.' }] }] },
    },
  ]));
  await writeFile(path.join(projectDir, sessionId, 'subagents', 'agent-abc.jsonl'), jsonl([
    {
      timestamp: '2026-10-07T10:00:02Z',
      message: { role: 'assistant', content: [{ type: 'tool_use', id: 'toolu_child', name: 'Bash', input: { command: 'ls' } }] },
    },
    {
      timestamp: '2026-10-07T10:00:03Z',
      message: { role: 'user', content: [{ type: 'tool_result', tool_use_id: 'toolu_child', content: 'a.ts' }] },
    },
  ]));

  closeConnection();
  process.env.DATABASE_PATH = path.join(root, 'auth.db');
  await initializeDatabase();
  try {
    sessionsDb.createSession(sessionId, 'claude', projectDir, 'Audit', undefined, undefined, transcriptPath);

    const { messages } = await new ClaudeSessionsProvider().fetchHistory(sessionId);

    const agent = messages.find((message) => message.toolId === 'toolu_agent');
    // Text blocks are joined instead of shown as serialized JSON.
    assert.equal((agent?.toolResult as { content?: string })?.content, 'All good.');
    const child = messages.find((message) => message.toolId === 'toolu_child');
    assert.equal(child?.kind, 'tool_use');
    assert.equal(child?.parentToolUseId, 'toolu_agent');
    assert.equal((child?.toolResult as { content?: string })?.content, 'a.ts');
    // The child row follows its parent so a page never orphans it.
    assert.ok(messages.indexOf(child!) > messages.indexOf(agent!));
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
