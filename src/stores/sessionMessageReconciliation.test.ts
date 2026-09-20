import assert from 'node:assert/strict';
import test from 'node:test';

import type { NormalizedMessage } from './useSessionStore';
import { removeOptimisticUserEchoes } from './sessionMessageReconciliation';

const createUserMessage = (
  id: string,
  timestamp: string,
  overrides: Partial<NormalizedMessage> = {},
): NormalizedMessage => ({
  id,
  sessionId: 'session-1',
  timestamp,
  provider: 'claude',
  kind: 'text',
  role: 'user',
  content: '',
  ...overrides,
});

test('replaces an optimistic image-only turn with its persisted Claude copy', () => {
  const local = createUserMessage('local_image', '2026-07-28T20:30:21.000Z', {
    images: [{ path: 'C:/Users/test/.ddagent/assets/upload.png', name: 'image.png' }],
  });
  const persisted = createUserMessage('claude_image', '2026-07-28T20:30:26.000Z', {
    images: [{ data: 'data:image/png;base64,AAAA' }],
  });

  assert.deepEqual(removeOptimisticUserEchoes([persisted], [local]), []);
});

test('does not collapse an attachment-only turn into a server row without attachments', () => {
  const local = createUserMessage('local_image', '2026-07-28T20:30:21.000Z', {
    images: [{ path: 'C:/Users/test/.ddagent/assets/upload.png' }],
  });
  const persisted = createUserMessage('claude_empty', '2026-07-28T20:30:22.000Z');

  assert.deepEqual(removeOptimisticUserEchoes([persisted], [local]), [local]);
});

test('replaces an optimistic text turn with its persisted copy that dropped the attachment', () => {
  // Devin persists a pasted screenshot outside the normalized user row (the
  // image lives in the ACP image blocks), so the persisted copy carries the
  // text but no attachment descriptors. The optimistic bubble must still be
  // replaced instead of stacking next to it.
  const local = createUserMessage('local_text_image', '2026-09-20T14:05:48.114Z', {
    content: 'popraw quota w opencode go',
    images: [{ path: '/home/test/.ddagent/assets/1789913148114-image.png', name: 'image.png' }],
    provider: 'devin',
  });
  const persisted = createUserMessage('35459314-c024-42e6-a793-6f47c7f6a094', '2026-09-20T14:05:49.554Z', {
    content: 'popraw quota w opencode go',
    provider: 'devin',
  });

  assert.deepEqual(removeOptimisticUserEchoes([persisted], [local]), []);
});

test('matches optimistic attachment turns to persisted turns one-to-one', () => {
  const firstLocal = createUserMessage('local_first', '2026-07-28T20:30:21.000Z', {
    images: [{ path: 'C:/Users/test/.ddagent/assets/first.png' }],
  });
  const secondLocal = createUserMessage('local_second', '2026-07-28T20:30:25.000Z', {
    images: [{ path: 'C:/Users/test/.ddagent/assets/second.png' }],
  });
  const firstPersisted = createUserMessage('claude_first', '2026-07-28T20:30:22.000Z', {
    images: [{ data: 'data:image/png;base64,AAAA' }],
  });

  const remainingRealtime = removeOptimisticUserEchoes(
    [firstPersisted],
    [firstLocal, secondLocal],
  );

  assert.deepEqual(remainingRealtime.map((message) => message.id), ['local_second']);
});

test('drops the optimistic bubble once a provider user echo lands in realtime', () => {
  const local = createUserMessage('local_first', '2026-07-28T20:30:21.000Z', {
    content: 'nadal w ddagent nie da się wybrać workspace',
  });
  // Providers that echo the user turn over the websocket emit a second
  // realtime row with their own id before the transcript refresh arrives.
  const providerEcho = createUserMessage('msg_provider_1_prt_1', '2026-07-28T20:30:23.000Z', {
    content: 'nadal w ddagent nie da się wybrać workspace',
  });

  assert.deepEqual(removeOptimisticUserEchoes([providerEcho], [local]), []);
});

test('keeps the existing optimistic text reconciliation behavior', () => {
  const local = createUserMessage('local_text', '2026-07-28T20:30:21.000Z', {
    content: 'hello',
  });
  const persisted = createUserMessage('claude_text', '2026-07-28T20:30:26.000Z', {
    content: 'hello',
  });

  assert.deepEqual(removeOptimisticUserEchoes([persisted], [local]), []);
});
