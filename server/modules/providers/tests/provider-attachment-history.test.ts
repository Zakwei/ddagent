import assert from 'node:assert/strict';
import test from 'node:test';

import { ClaudeSessionsProvider } from '@/modules/providers/list/claude/claude-sessions.provider.js';
import { CodexSessionsProvider, extractCodexUserImages } from '@/modules/providers/list/codex/codex-sessions.provider.js';
import { CursorSessionsProvider } from '@/modules/providers/list/cursor/cursor-sessions.provider.js';
import { normalizeDevinNode } from '@/modules/providers/list/devin/devin-sessions.provider.js';
import { appendFilesInputTag, appendImagesInputTag } from '@/shared/image-attachments.js';

const SESSION_ID = 'session-1';

// ---------------------------------------------------------------- Claude

test('claude history: base64 image blocks surface as user message images', () => {
  const provider = new ClaudeSessionsProvider();
  const entry = {
    uuid: 'u1',
    timestamp: '2026-07-03T10:00:00.000Z',
    message: {
      role: 'user',
      content: [
        { type: 'text', text: 'What is in this screenshot?' },
        { type: 'image', source: { type: 'base64', media_type: 'image/png', data: 'QUJD' } },
        { type: 'image', source: { type: 'base64', media_type: 'image/jpeg', data: 'REVG' } },
      ],
    },
  };

  const messages = provider.normalizeMessage(entry, SESSION_ID);

  assert.equal(messages.length, 1);
  assert.equal(messages[0].kind, 'text');
  assert.equal(messages[0].role, 'user');
  assert.equal(messages[0].content, 'What is in this screenshot?');
  assert.deepEqual(messages[0].images, [
    { data: 'data:image/png;base64,QUJD' },
    { data: 'data:image/jpeg;base64,REVG' },
  ]);
});

test('claude history: image-only user turns still produce a bubble', () => {
  const provider = new ClaudeSessionsProvider();
  const entry = {
    uuid: 'u2',
    timestamp: '2026-07-03T10:00:00.000Z',
    message: {
      role: 'user',
      content: [
        { type: 'image', source: { type: 'base64', media_type: 'image/png', data: 'QUJD' } },
      ],
    },
  };

  const messages = provider.normalizeMessage(entry, SESSION_ID);

  assert.equal(messages.length, 1);
  assert.equal(messages[0].role, 'user');
  assert.equal(messages[0].content, '');
  assert.deepEqual(messages[0].images, [{ data: 'data:image/png;base64,QUJD' }]);
});

test('claude history: plain text user turns carry no images field', () => {
  const provider = new ClaudeSessionsProvider();
  const entry = {
    uuid: 'u3',
    timestamp: '2026-07-03T10:00:00.000Z',
    message: { role: 'user', content: [{ type: 'text', text: 'hello' }] },
  };

  const messages = provider.normalizeMessage(entry, SESSION_ID);
  assert.equal(messages.length, 1);
  assert.equal(messages[0].images, undefined);
});

test('claude history: file reference blocks restore non-image attachments', () => {
  const provider = new ClaudeSessionsProvider();
  const entry = {
    uuid: 'u4',
    timestamp: '2026-07-03T10:00:00.000Z',
    message: {
      role: 'user',
      content: [{
        type: 'text',
        text: appendFilesInputTag('Summarize this', [
          { path: 'C:/Users/x/.ddagent/assets/brief.pdf', name: 'brief.pdf' },
        ]),
      }],
    },
  };

  const messages = provider.normalizeMessage(entry, SESSION_ID);
  assert.equal(messages[0].content, 'Summarize this');
  assert.deepEqual(messages[0].files, [
    { path: 'C:/Users/x/.ddagent/assets/brief.pdf', name: 'brief.pdf' },
  ]);
});

// ---------------------------------------------------------------- Codex

test('codex history: user_message payload images become path attachments', () => {
  // Real rollout shape: local_image input items land in `local_images`,
  // while `images` stays an empty array.
  assert.deepEqual(
    extractCodexUserImages({
      type: 'user_message',
      message: 'can u see attached image?',
      images: [],
      local_images: ['C:\\proj\\.ddagent\\assets\\a.png'],
    }),
    [{ path: 'C:/proj/.ddagent/assets/a.png' }],
  );
  assert.deepEqual(
    extractCodexUserImages({ type: 'user_message', message: 'hi', images: ['/proj/b.jpg'] }),
    [{ path: '/proj/b.jpg' }],
  );
  assert.equal(extractCodexUserImages({ type: 'user_message', message: 'hi' }), undefined);
  assert.equal(extractCodexUserImages({ type: 'user_message', message: 'hi', images: [], local_images: [] }), undefined);
});

test('codex history: base64 data URLs pass through as inline data attachments', () => {
  const dataUrl = 'data:image/png;base64,QUJD';
  assert.deepEqual(
    extractCodexUserImages({
      type: 'user_message',
      message: 'look',
      images: [dataUrl],
      local_images: ['C:\\proj\\a.png'],
    }),
    [{ path: 'C:/proj/a.png' }, { data: dataUrl }],
  );
});

test('codex history: normalized user entries keep their images', () => {
  const provider = new CodexSessionsProvider();
  const messages = provider.normalizeMessage(
    {
      timestamp: '2026-07-03T10:00:00.000Z',
      message: { role: 'user', content: 'Look at this' },
      images: [{ path: '.ddagent/assets/a.png' }],
    },
    SESSION_ID,
  );

  assert.equal(messages.length, 1);
  assert.equal(messages[0].role, 'user');
  assert.equal(messages[0].content, 'Look at this');
  assert.deepEqual(messages[0].images, [{ path: '.ddagent/assets/a.png' }]);
});

test('codex history: normalized user entries restore file reference blocks', () => {
  const provider = new CodexSessionsProvider();
  const messages = provider.normalizeMessage(
    {
      timestamp: '2026-07-03T10:00:00.000Z',
      message: {
        role: 'user',
        content: appendFilesInputTag('Review this', [
          { path: 'C:/Users/x/.ddagent/assets/spec.docx', name: 'spec.docx' },
        ]),
      },
    },
    SESSION_ID,
  );

  assert.equal(messages[0].content, 'Review this');
  assert.deepEqual(messages[0].files, [
    { path: 'C:/Users/x/.ddagent/assets/spec.docx', name: 'spec.docx' },
  ]);
});

// ---------------------------------------------------------------- Devin

test('devin history: pasted screenshots stored outside the content blocks stay attached', () => {
  // Devin writes the prompt text into the ACP content blocks and keeps the
  // pasted image bytes on the raw record. The persisted user turn must carry
  // both, otherwise the attachment is lost once the optimistic bubble is
  // replaced by its history copy.
  const row = { node_id: 2, created_at: 1789913149 };
  const raw = {
    message_id: '35459314-c024-42e6-a793-6f47c7f6a094',
    role: 'user',
    content: '[Image 1: /tmp/devin-pasted-images/1789913149-0-pasted.png]\n\npopraw quota w opencode go',
    images: [{ width: 478, height: 456, base64_data: 'QUJD' }],
    metadata: {
      created_at: '2026-09-20T14:05:49.554893667Z',
      extensions: {
        'chisel/acp-content-blocks': [
          { type: 'text', text: 'popraw quota w opencode go' },
        ],
      },
    },
  };

  const messages = normalizeDevinNode(row, raw, SESSION_ID);

  assert.equal(messages.length, 1);
  assert.equal(messages[0].kind, 'text');
  assert.equal(messages[0].role, 'user');
  assert.equal(messages[0].content, 'popraw quota w opencode go');
  assert.deepEqual(messages[0].images, [{ data: 'data:image/png;base64,QUJD' }]);
});

test('devin history: ACP image blocks win over the raw record copy', () => {
  const row = { node_id: 3, created_at: 1789913149 };
  const raw = {
    message_id: 'user-with-block-image',
    role: 'user',
    content: 'look at this',
    images: [{ base64_data: 'QUJD' }],
    metadata: {
      extensions: {
        'chisel/acp-content-blocks': [
          { type: 'text', text: 'look at this' },
          { type: 'image', mimeType: 'image/jpeg', data: 'REVG' },
        ],
      },
    },
  };

  const messages = normalizeDevinNode(row, raw, SESSION_ID);

  assert.deepEqual(messages[0].images, [{ data: 'data:image/jpeg;base64,REVG' }]);
});

// ---------------------------------------------------------------- Cursor

test('cursor history: <images_input> inside user_query is stripped and attached', () => {
  const provider = new CursorSessionsProvider();
  const taggedPrompt = appendImagesInputTag('Fix the layout bug', [{ path: '.ddagent/assets/shot.png' }]);
  const blobs = [
    {
      id: 'blob1',
      sequence: 1,
      rowid: 1,
      content: {
        role: 'user',
        content: `<timestamp>2026-07-03</timestamp>\n<user_query>${taggedPrompt}</user_query>`,
      },
    },
    {
      id: 'blob2',
      sequence: 2,
      rowid: 2,
      content: {
        role: 'assistant',
        content: [{ type: 'text', text: 'Done — the flex container was wrong.' }],
      },
    },
  ];

  const messages = provider.normalizeCursorBlobs(blobs, SESSION_ID);

  assert.equal(messages.length, 2);
  assert.equal(messages[0].role, 'user');
  assert.equal(messages[0].content, 'Fix the layout bug');
  assert.deepEqual(messages[0].images, [{ path: '.ddagent/assets/shot.png' }]);
  assert.equal(messages[1].role, 'assistant');
  assert.equal(messages[1].images, undefined);
});

test('cursor history: user text without a tag keeps existing behavior', () => {
  const provider = new CursorSessionsProvider();
  const blobs = [
    {
      id: 'blob1',
      sequence: 1,
      rowid: 1,
      content: {
        role: 'user',
        content: '<timestamp>2026-07-03</timestamp>\n<user_query>plain question</user_query>',
      },
    },
  ];

  const messages = provider.normalizeCursorBlobs(blobs, SESSION_ID);
  assert.equal(messages.length, 1);
  assert.equal(messages[0].content, 'plain question');
  assert.equal(messages[0].images, undefined);
});

test('cursor history: file reference blocks are stripped and attached', () => {
  const provider = new CursorSessionsProvider();
  const taggedPrompt = appendFilesInputTag('Check the data', [
    { path: 'C:/Users/x/.ddagent/assets/data.csv', name: 'data.csv' },
  ]);
  const messages = provider.normalizeCursorBlobs([
    {
      id: 'blob-file',
      sequence: 1,
      rowid: 1,
      content: {
        role: 'user',
        content: `<user_query>${taggedPrompt}</user_query>`,
      },
    },
  ], SESSION_ID);

  assert.equal(messages[0].content, 'Check the data');
  assert.deepEqual(messages[0].files, [
    { path: 'C:/Users/x/.ddagent/assets/data.csv', name: 'data.csv' },
  ]);
});
