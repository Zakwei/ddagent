import assert from 'node:assert/strict';
import { once } from 'node:events';
import type { AddressInfo } from 'node:net';
import test from 'node:test';

import express, {
  type NextFunction,
  type Request,
  type Response,
} from 'express';

import {
  createInboxRouter,
  createQueuedMessagesRouter,
} from '@/modules/queued-messages/queued-messages.routes.js';
import type { QueuedMessage, QueuedMessagesService } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

type EnqueuedInput = {
  userId: string | number | null;
  sessionId: string;
  content: string;
  options?: Record<string, unknown>;
};

function createFakeService(enqueued: EnqueuedInput[], failingSessions: Set<string> = new Set()) {
  let nextId = 1;
  return {
    list: () => [],
    enqueue(input: EnqueuedInput): QueuedMessage {
      if (failingSessions.has(input.sessionId)) {
        throw new AppError('no such session', { code: 'SESSION_NOT_FOUND', statusCode: 404 });
      }
      enqueued.push(input);
      return {
        id: nextId++,
        userId: input.userId == null ? null : String(input.userId),
        sessionId: input.sessionId,
        content: input.content,
        options: input.options ?? {},
        status: 'queued',
        error: null,
        position: 0,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };
    },
    remove: () => undefined,
    sendNow: async () => {
      throw new Error('not implemented');
    },
  } as unknown as QueuedMessagesService;
}

async function withServer(
  app: express.Express,
  run: (baseUrl: string) => Promise<void>,
): Promise<void> {
  const server = app.listen(0, '127.0.0.1');
  await once(server, 'listening');
  try {
    const { port } = server.address() as AddressInfo;
    await run(`http://127.0.0.1:${port}`);
  } finally {
    server.close();
  }
}

function buildApp(service: QueuedMessagesService): express.Express {
  const app = express();
  app.set('trust proxy', true);
  app.use(express.json());
  app.use('/api/queue', createQueuedMessagesRouter(service));
  app.use('/api/sessions', createInboxRouter(service));
  app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (error instanceof AppError) {
      res.status(error.statusCode).json({ error: error.code, message: error.message });
      return;
    }
    res.status(500).json({ error: 'INTERNAL_ERROR' });
  });
  return app;
}

test('broadcast enqueues one message per session and reports per-session results', async () => {
  const enqueued: EnqueuedInput[] = [];
  const app = buildApp(createFakeService(enqueued, new Set(['bad-session'])));

  await withServer(app, async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/queue/broadcast`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sessionIds: ['a', 'bad-session', 'b'], content: 'ship it' }),
    });
    assert.equal(response.status, 200);
    const body = (await response.json()) as {
      data: { results: Array<{ sessionId: string; ok: boolean }> };
    };
    const results = body.data.results;
    assert.deepEqual(
      results.map((r) => [r.sessionId, r.ok]),
      [['a', true], ['bad-session', false], ['b', true]],
    );
    assert.deepEqual(enqueued.map((e) => e.sessionId), ['a', 'b']);
    assert.equal(enqueued[0].content, 'ship it');
  });
});

test('broadcast rejects empty sessionIds and empty content', async () => {
  const app = buildApp(createFakeService([]));
  await withServer(app, async (baseUrl) => {
    for (const body of [
      { sessionIds: [], content: 'x' },
      { sessionIds: ['a'], content: '  ' },
    ]) {
      const response = await fetch(`${baseUrl}/api/queue/broadcast`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      assert.equal(response.status, 400);
    }
  });
});

test('inbox accepts agent source from loopback and prefixes the content', async () => {
  const enqueued: EnqueuedInput[] = [];
  const app = buildApp(createFakeService(enqueued));

  await withServer(app, async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/sessions/sess-9/inbox`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text: 'build done', source: 'agent' }),
    });
    assert.equal(response.status, 201);
    assert.equal(enqueued[0].sessionId, 'sess-9');
    assert.equal(enqueued[0].content, '[inbox:agent]\nbuild done');
    assert.equal(enqueued[0].options?.inboxSource, 'agent');
  });
});

test('inbox rejects agent source from a non-loopback client', async () => {
  const enqueued: EnqueuedInput[] = [];
  const app = buildApp(createFakeService(enqueued));

  await withServer(app, async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/sessions/sess-9/inbox`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-Forwarded-For': '203.0.113.10' },
      body: JSON.stringify({ text: 'sneaky', source: 'agent' }),
    });
    assert.equal(response.status, 403);
    assert.equal(enqueued.length, 0);
  });
});
