// Runnable check for the WS-over-IPC router's connection semantics:
//   node --test electron/transport/wsRouter.test.js
// createWsRouter is transport-only (no electron imports) — webContents is a
// fake with send()/isDestroyed()/'destroyed', handlers are injected.

import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import test from 'node:test';

import { createWsRouter } from './wsRouter.js';

const tick = () => new Promise((resolve) => setTimeout(resolve, 20));

function fakeWebContents() {
  const wc = new EventEmitter();
  wc.sent = [];
  wc.destroyed = false;
  wc.send = (_channel, event) => {
    wc.sent.push(event);
  };
  wc.isDestroyed = () => wc.destroyed;
  return wc;
}

const types = (wc) => wc.sent.map((event) => event.type);

function echoRouter() {
  return createWsRouter({
    getWsDeps: () => ({ verifyClient: {}, chat: {} }),
    loadHandlers: async () => ({
      verifyWebSocketClient: ({ req }) => {
        req.user = { id: 1 };
        return true;
      },
      routes: [
        {
          pathname: '/ws',
          withRequest: true,
          depsKey: 'chat',
          handle: (ws) => {
            ws.on('message', (data) => ws.send(`echo:${data}`));
          },
        },
      ],
    }),
  });
}

test('connect resolves to open; echo + renderer close round-trip', async () => {
  const router = echoRouter();
  const wc = fakeWebContents();
  const connId = router.connect(wc, 'ws://local/ws?token=x');
  await tick();
  assert.deepEqual(types(wc), ['open']);

  router.send(connId, 'hi');
  await tick();
  assert.deepEqual(types(wc), ['open', 'message']);
  assert.equal(wc.sent[1].data, 'echo:hi');

  const socket = [...router.clients][0];
  let serverSawClose = false;
  socket.on('close', () => {
    serverSawClose = true;
  });
  router.close(connId, 1000, 'bye');
  await tick();
  assert.equal(serverSawClose, true);
  assert.deepEqual(wc.sent.at(-1), { type: 'close', code: 1000, reason: 'bye', wasClean: true });
});

test("'open' is emitted before dispatch so frames sent inside it are not dropped", async () => {
  // A handler may send-then-close during dispatch (terminal rejections like a
  // concurrency cap). On a real socket the client saw open first; without the
  // ordering fix the message arrives while CONNECTING and is dropped, so a
  // fatal error can never reach the client and the pane retries forever.
  const router = createWsRouter({
    getWsDeps: () => ({}),
    loadHandlers: async () => ({
      verifyWebSocketClient: () => true,
      routes: [
        {
          pathname: '/ws',
          handle: (ws) => {
            ws.send('fatal: cap reached');
            ws.close(1008, 'cap');
          },
        },
      ],
    }),
  });
  const wc = fakeWebContents();
  router.connect(wc, 'ws://local/ws');
  await tick();
  assert.deepEqual(types(wc), ['open', 'message', 'close']);
  assert.equal(wc.sent[1].data, 'fatal: cap reached');
  assert.deepEqual(wc.sent[2], { type: 'close', code: 1008, reason: 'cap', wasClean: true });
});

test('ping() answers with an async pong; a finalized socket never pongs', async () => {
  const router = echoRouter();
  const wc = fakeWebContents();
  router.connect(wc, 'ws://local/ws');
  await tick();
  const socket = [...router.clients][0];

  let pongs = 0;
  socket.on('pong', () => {
    pongs += 1;
  });
  socket.ping();
  await tick();
  assert.equal(pongs, 1);

  socket.terminate();
  socket.ping();
  await tick();
  assert.equal(pongs, 1);
});

test('close() reports wasClean for any code; terminate() reports abnormal', async () => {
  const router = echoRouter();
  const wc = fakeWebContents();
  router.connect(wc, 'ws://local/ws');
  await tick();
  const socket = [...router.clients][0];
  socket.close(4000, 'Device reconnected');
  await tick();
  assert.deepEqual(wc.sent.at(-1), { type: 'close', code: 4000, reason: 'Device reconnected', wasClean: true });

  const wc2 = fakeWebContents();
  router.connect(wc2, 'ws://local/ws');
  await tick();
  [...router.clients][0].terminate();
  await tick();
  assert.deepEqual(wc2.sent.at(-1), { type: 'close', code: 1006, reason: '', wasClean: false });
});

test('backend not started -> close 1011 without open; auth failure -> 1008', async () => {
  const bootless = createWsRouter({ getWsDeps: () => null, loadHandlers: async () => ({ routes: [] }) });
  const wc = fakeWebContents();
  bootless.connect(wc, 'ws://local/ws');
  await tick();
  assert.deepEqual(types(wc), ['close']);
  assert.equal(wc.sent[0].code, 1011);

  const denied = createWsRouter({
    getWsDeps: () => ({}),
    loadHandlers: async () => ({ verifyWebSocketClient: () => false, routes: [] }),
  });
  const wc2 = fakeWebContents();
  denied.connect(wc2, 'ws://local/ws');
  await tick();
  assert.deepEqual(types(wc2), ['close']);
  assert.equal(wc2.sent[0].code, 1008);
});

test('webContents destroy terminates its connections and empties clients', async () => {
  const router = echoRouter();
  const wc = fakeWebContents();
  router.connect(wc, 'ws://local/ws');
  await tick();
  assert.equal(router.clients.size, 1);

  wc.destroyed = true;
  wc.emit('destroyed');
  await tick();
  assert.equal(router.clients.size, 0);
  // The renderer is gone — nothing more may be sent to it.
  assert.equal(types(wc).at(-1), 'open');
});

test('unknown path closes cleanly after open (matches ws gateway order)', async () => {
  const router = echoRouter();
  const wc = fakeWebContents();
  router.connect(wc, 'ws://local/nope');
  await tick();
  assert.deepEqual(types(wc), ['open', 'close']);
  assert.equal(wc.sent[1].code, 1000);
});
