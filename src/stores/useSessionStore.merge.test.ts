import assert from 'node:assert/strict';
import test from 'node:test';

import type { NormalizedMessage } from './useSessionStore';
import { computeMerged } from './useSessionStore';

const SESSION_ID = 'session-1';

const msg = (
  id: string,
  timestamp: string,
  overrides: Partial<NormalizedMessage> = {},
): NormalizedMessage => ({
  id,
  sessionId: SESSION_ID,
  timestamp,
  provider: 'devin',
  kind: 'text',
  ...overrides,
});

const countByText = (list: NormalizedMessage[], text: string) =>
  list.filter((m) => m.kind === 'text' && (m.content || '').includes(text)).length;

test('drops a streamed assistant copy even when a stale realtime user row shifts the turn ordinal', () => {
  // Regression: a finalized stream row + its persisted twin rendered twice.
  // A realtime user echo that never reconciled (own id, timestamp outside the
  // 3 s window) counted as an extra user turn, pushed the ordinal past the
  // real turn, and the assistant echo check could never match.
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
    msg('thinking_1', '2026-09-23T09:26:25.343Z', { kind: 'thinking', content: 'reasoning' }),
    msg('assistant_1', '2026-09-23T09:26:25.472Z', { role: 'assistant', content: '## Research answer' }),
    msg('user_2', '2026-09-23T09:30:25.029Z', { role: 'user', content: 'follow up' }),
  ];

  const realtime = [
    // Orphaned user echo of the first turn — different id than the persisted row.
    msg('user_echo_orphan', '2026-09-23T09:24:58.500Z', { role: 'user', content: 'first prompt' }),
    msg('text_rt1', '2026-09-23T09:25:52.000Z', { role: 'assistant', content: '## Research answer' }),
    msg('thinking_rt1', '2026-09-23T09:25:52.000Z', { kind: 'thinking', content: 'reasoning' }),
  ];

  const merged = computeMerged(server, realtime);

  assert.equal(countByText(merged, '## Research answer'), 1);
  assert.equal(merged.filter((m) => m.id === 'thinking_rt1').length, 0);
});

test('keeps a streamed assistant row while its text is not yet persisted', () => {
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
  ];
  const realtime = [
    msg('text_rt1', '2026-09-23T09:25:52.000Z', { role: 'assistant', content: 'still streaming…' }),
  ];

  const merged = computeMerged(server, realtime);
  assert.equal(merged.filter((m) => m.id === 'text_rt1').length, 1);
});

test('drops a replayed stream row rebuilt from buffered deltas', () => {
  // chat.subscribe replay rebuilds a __streaming_ row from raw deltas; once the
  // persisted copy is in the window the rebuilt row must not render twice.
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
    msg('assistant_1', '2026-09-23T09:26:25.472Z', { role: 'assistant', content: '## Research answer' }),
  ];
  const realtime = [
    {
      id: `__streaming_${SESSION_ID}`,
      sessionId: SESSION_ID,
      timestamp: '2026-09-23T09:25:52.000Z',
      provider: 'devin',
      kind: 'stream_delta',
      content: '## Research answer',
    } as NormalizedMessage,
  ];

  const merged = computeMerged(server, realtime);
  assert.equal(countByText(merged, '## Research answer'), 1);
});
