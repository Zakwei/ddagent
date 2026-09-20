import assert from 'node:assert/strict';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { loadDdagentJsonlHistory } from '@/modules/providers/list/devin/devin-sessions.provider.js';

/** Writes one ddagent JSONL transcript into a temp directory and removes it afterwards. */
async function withTranscript(
  records: Record<string, unknown>[],
  runTest: (jsonlPath: string) => void | Promise<void>,
): Promise<void> {
  const directory = await mkdtemp(path.join(os.tmpdir(), 'devin-jsonl-'));
  const jsonlPath = path.join(directory, 'session.jsonl');
  await writeFile(jsonlPath, `${records.map((record) => JSON.stringify(record)).join('\n')}\n`, 'utf8');

  try {
    await runTest(jsonlPath);
  } finally {
    await rm(directory, { recursive: true, force: true });
  }
}

/**
 * One ACP `tool_call_update` snapshot. The Devin runtime appends every snapshot
 * as its own `tool_result` row under the shared id `${toolId}__result`.
 */
const toolResultSnapshot = (toolId: string, content: string, timestamp: string, isError = false) => ({
  id: `${toolId}__result`,
  kind: 'tool_result',
  toolId,
  content,
  isError,
  sessionId: 'session-1',
  provider: 'devin',
  timestamp,
});

test('collapses ACP tool-result snapshots into one row holding the last output', async () => {
  await withTranscript([
    {
      id: 'call_1',
      kind: 'tool_use',
      toolId: 'call_1',
      toolName: 'exec',
      toolInput: '{}',
      sessionId: 'session-1',
      provider: 'devin',
      timestamp: '2026-09-20T20:00:00.000Z',
    },
    toolResultSnapshot('call_1', '', '2026-09-20T20:00:01.000Z'),
    toolResultSnapshot('call_1', 'partial output', '2026-09-20T20:00:02.000Z'),
    toolResultSnapshot('call_1', 'full output', '2026-09-20T20:00:03.000Z'),
    toolResultSnapshot('call_1', '', '2026-09-20T20:00:04.000Z'),
  ], (jsonlPath) => {
    const messages = loadDdagentJsonlHistory(jsonlPath) as any[];

    assert.equal(messages.length, 2, 'one tool_use row plus one collapsed tool_result row');
    assert.equal(messages[0].kind, 'tool_use');
    assert.equal(messages[1].content, 'full output');
    assert.equal(messages[1].timestamp, '2026-09-20T20:00:01.000Z', 'the first snapshot keeps its position in the transcript');
  });
});

test('keeps failures and tool calls whose every snapshot is empty', async () => {
  await withTranscript([
    toolResultSnapshot('call_2', 'stdout before the failure', '2026-09-20T20:01:00.000Z'),
    toolResultSnapshot('call_2', '', '2026-09-20T20:01:01.000Z', true),
    toolResultSnapshot('call_3', '', '2026-09-20T20:01:02.000Z'),
  ], (jsonlPath) => {
    const messages = loadDdagentJsonlHistory(jsonlPath) as any[];

    assert.equal(messages.length, 2);
    assert.equal(messages[0].content, 'stdout before the failure');
    assert.equal(messages[0].isError, true, 'a failed snapshot marks the collapsed row as an error');
    assert.equal(messages[1].toolId, 'call_3', 'a tool call with only empty output still gets its own row');
  });
});
