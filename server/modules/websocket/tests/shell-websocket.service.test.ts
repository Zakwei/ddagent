import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { WebSocket } from 'ws';

import { connectPtyHost, runPtyHostDaemon } from '@/modules/pty-host/index.js';
import {
  handleShellConnection,
  startShellPtyHost,
  sweepOrphanedShellSessions,
} from '@/modules/websocket/services/shell-websocket.service.js';

function createFakeSocket() {
  const socket = new EventEmitter() as EventEmitter & {
    readyState: number;
    frames: string[];
    send: (data: string) => void;
  };
  socket.readyState = WebSocket.OPEN;
  socket.frames = [];
  socket.send = (data: string) => socket.frames.push(data);
  return socket;
}

function createFakePty() {
  let dataListener: ((data: string) => void) | null = null;
  let exitListener: ((event: { exitCode: number; signal?: number }) => void) | null = null;

  return {
    killed: false,
    resizes: [] as Array<[number, number]>,
    onData(listener: (data: string) => void) {
      dataListener = listener;
      return { dispose: () => undefined };
    },
    onExit(listener: (event: { exitCode: number; signal?: number }) => void) {
      exitListener = listener;
      return { dispose: () => undefined };
    },
    emitData(data: string) {
      dataListener?.(data);
    },
    emitExit() {
      exitListener?.({ exitCode: 0 });
    },
    write() {},
    resize(cols: number, rows: number) {
      this.resizes.push([cols, rows]);
    },
    kill() {
      this.killed = true;
    },
  };
}

test('a stale socket close cannot detach the socket that replaced it', () => {
  const pty = createFakePty();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };
  const initMessage = JSON.stringify({
    type: 'init',
    projectPath: process.cwd(),
    sessionId: `stale-close-${Date.now()}`,
    hasSession: false,
    provider: 'plain-shell',
    isPlainShell: true,
    initialCommand: 'test-command',
  });

  const firstSocket = createFakeSocket();
  handleShellConnection(firstSocket as never, dependencies);
  firstSocket.emit('message', initMessage);

  const replacementSocket = createFakeSocket();
  handleShellConnection(replacementSocket as never, dependencies);
  replacementSocket.emit('message', initMessage);
  replacementSocket.frames.length = 0;

  // This ordering reproduces a delayed close from a backgrounded mobile tab.
  firstSocket.emit('close');
  pty.emitData('output-after-stale-close');

  assert.equal(pty.killed, false);
  assert.equal(replacementSocket.frames.length, 1);
  assert.match(replacementSocket.frames[0], /output-after-stale-close/);

  pty.emitExit();
});

test('a reattached socket gets the buffered output marked as replay', () => {
  const pty = createFakePty();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };
  const initMessage = JSON.stringify({
    type: 'init',
    projectPath: process.cwd(),
    sessionId: `replay-${Date.now()}`,
    hasSession: false,
    provider: 'plain-shell',
    isPlainShell: true,
    initialCommand: 'test-command',
  });

  const firstSocket = createFakeSocket();
  handleShellConnection(firstSocket as never, dependencies);
  firstSocket.emit('message', initMessage);
  // Claude Code's device-attributes query — answering it again on replay
  // typed "1;2c" into the shell.
  pty.emitData('\x1b[c');

  const replacementSocket = createFakeSocket();
  handleShellConnection(replacementSocket as never, dependencies);
  replacementSocket.emit('message', initMessage);
  const replayed = replacementSocket.frames
    .map((frame) => JSON.parse(frame) as { data?: string; replay?: boolean })
    .find((frame) => frame.data === '\x1b[c');
  assert.equal(replayed?.replay, true);

  pty.emitData('live');
  const live = JSON.parse(replacementSocket.frames.at(-1)!) as { replay?: boolean };
  assert.equal(live.replay, undefined);

  pty.emitExit();
});

test('a reattach replays a bounded window in a few frames, after a clear', () => {
  const pty = createFakePty();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };
  const initMessage = JSON.stringify({
    type: 'init',
    projectPath: process.cwd(),
    sessionId: `replay-window-${Date.now()}`,
    hasSession: false,
    provider: 'plain-shell',
    isPlainShell: true,
  });

  const firstSocket = createFakeSocket();
  handleShellConnection(firstSocket as never, dependencies);
  firstSocket.emit('message', initMessage);
  // ~2 MB of 4 KB TUI redraws — four times the replay window.
  const chunk = (i: number) => `frame-${String(i).padStart(5, '0')}`.padEnd(4096, '.');
  for (let i = 0; i < 512; i++) {
    pty.emitData(chunk(i));
  }

  const replacementSocket = createFakeSocket();
  handleShellConnection(replacementSocket as never, dependencies);
  replacementSocket.emit('message', initMessage);
  const frames = replacementSocket.frames
    .map((frame) => JSON.parse(frame) as { type: string; data: string; replay?: boolean })
    .filter((frame) => frame.type === 'output');

  // The client's copy of history is cleared, not doubled.
  assert.deepEqual(frames[0], { type: 'output', data: '\x1b[2J\x1b[3J\x1b[H', replay: true });
  assert.match(frames[1].data, /Reconnected to existing session/);
  const replayed = frames.slice(2);
  assert.ok(replayed.every((frame) => frame.replay === true));
  assert.ok(replayed.every((frame) => frame.data.length <= 64 * 1024));
  assert.equal(replayed.length, 8);
  const text = replayed.map((frame) => frame.data).join('');
  assert.equal(text.length, 512 * 1024);
  // The newest output is kept; the oldest is dropped.
  assert.ok(text.endsWith(chunk(511)));
  assert.ok(!text.includes('frame-00000'));

  pty.emitExit();
});

test('a full replay restores the title and modes set before its window', () => {
  const pty = createFakePty();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };
  const initMessage = JSON.stringify({
    type: 'init',
    projectPath: process.cwd(),
    sessionId: `replay-state-${Date.now()}`,
    hasSession: false,
    provider: 'plain-shell',
    isPlainShell: true,
  });

  const firstSocket = createFakeSocket();
  handleShellConnection(firstSocket as never, dependencies);
  firstSocket.emit('message', initMessage);
  // Claude Code at startup: session title, mouse tracking, bracketed paste —
  // the mode list split across two chunks.
  pty.emitData('\x1b]0;My session\x07\x1b[?1000;10');
  pty.emitData('06h\x1b[?2004h\x1b[?2004l');
  for (let i = 0; i < 256; i++) {
    pty.emitData('.'.repeat(4096));
  }

  const replacementSocket = createFakeSocket();
  handleShellConnection(replacementSocket as never, dependencies);
  replacementSocket.emit('message', initMessage);
  const first = replacementSocket.frames
    .map((frame) => JSON.parse(frame) as { type: string; data: string; replay?: boolean })
    .find((frame) => frame.type === 'output');

  assert.deepEqual(first, {
    type: 'output',
    data: '\x1b[2J\x1b[3J\x1b[H\x1b]2;My session\x07\x1b[?1000h\x1b[?1006h\x1b[?2004l',
    replay: true,
  });

  pty.emitExit();
});

/** One plain-shell PTY with a first viewer attached; `attach` adds another socket. */
function startStream(name: string) {
  const pty = createFakePty();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };
  const sessionId = `${name}-${Date.now()}`;
  const init = (extra: Record<string, unknown> = {}) =>
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      ...extra,
    });
  const attach = (extra?: Record<string, unknown>) => {
    const socket = createFakeSocket();
    handleShellConnection(socket as never, dependencies);
    socket.emit('message', init(extra));
    return socket;
  };
  const parsed = (socket: ReturnType<typeof createFakeSocket>) =>
    socket.frames.map(
      (frame) => JSON.parse(frame) as { type: string; id?: string; data?: string; end?: number; replay?: boolean }
    );
  const first = attach();
  const streamId = parsed(first).find((frame) => frame.type === 'stream')!.id!;
  return { pty, attach, parsed, first, streamId, sessionId };
}

test('a reattach with the stream offset gets only the missed output, without a clear', () => {
  const { pty, attach, parsed, first, streamId } = startStream('resume');
  pty.emitData('seen-');
  const seen = parsed(first).at(-1)!.end!;
  first.emit('close');
  pty.emitData('missed-1 ');
  pty.emitData('missed-2');

  const back = attach({ stream: streamId, seen });
  const output = parsed(back).filter((frame) => frame.type === 'output');

  assert.equal(output.map((frame) => frame.data).join(''), 'missed-1 missed-2');
  assert.ok(output.every((frame) => frame.replay === true));
  assert.equal(output.at(-1)!.end, 'seen-missed-1 missed-2'.length);
  assert.ok(!back.frames.some((frame) => frame.includes('[3J') || frame.includes('Reconnected')));

  pty.emitExit();
});

test('a reattach from another stream or a gap past the window repaints in full', () => {
  const { pty, attach, parsed } = startStream('resume-stale');
  pty.emitData('output');

  for (const resume of [{ stream: 'an-older-run', seen: 0 }, {}]) {
    const socket = attach(resume);
    const output = parsed(socket).filter((frame) => frame.type === 'output');
    assert.equal(output[0].data, '\x1b[2J\x1b[3J\x1b[H');
    assert.ok(output.some((frame) => frame.data === 'output'));
  }

  pty.emitExit();
});

test('a backed-up viewer gets no live frames and later catches up from its offset', (t) => {
  t.mock.timers.enable({ apis: ['setTimeout'] });
  const { pty, parsed, first } = startStream('backpressure');
  pty.emitData('a');
  const backedUp = first as typeof first & { bufferedAmount: number };
  backedUp.bufferedAmount = 2 * 1024 * 1024;
  const sentBefore = first.frames.length;

  pty.emitData('b');
  pty.emitData('c');
  t.mock.timers.tick(250);
  assert.equal(first.frames.length, sentBefore);

  backedUp.bufferedAmount = 0;
  t.mock.timers.tick(250);
  const caughtUp = parsed(first).slice(sentBefore);
  assert.deepEqual(caughtUp, [{ type: 'output', data: 'bc', end: 3, replay: true }]);

  pty.emitData('d');
  assert.deepEqual(parsed(first).at(-1), { type: 'output', data: 'd', end: 4 });

  pty.emitExit();
});

/** Two devices viewing one synced terminal tab. */
function attachTwoViewers(name: string) {
  const writes: string[] = [];
  const resizes: Array<[number, number]> = [];
  const pty = Object.assign(createFakePty(), {
    write(data: string) {
      writes.push(data);
    },
    resize(cols: number, rows: number) {
      resizes.push([cols, rows]);
    },
  });
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };
  const sessionId = `${name}-${Date.now()}`;
  const init = (cols: number, rows: number, forceRestart = false) =>
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      forceRestart,
      cols,
      rows,
    });

  const desktop = createFakeSocket();
  handleShellConnection(desktop as never, dependencies);
  desktop.emit('message', init(200, 50));
  const phone = createFakeSocket();
  handleShellConnection(phone as never, dependencies);
  phone.emit('message', init(80, 24));
  desktop.frames.length = 0;
  phone.frames.length = 0;
  const lastFrame = (socket: ReturnType<typeof createFakeSocket>) =>
    JSON.parse(socket.frames.at(-1)!) as { data?: string; replay?: boolean };
  return { pty, writes, resizes, desktop, phone, init, lastFrame };
}

test('every device viewing a PTY gets its output; only the one in charge answers queries', () => {
  const { pty, desktop, phone, lastFrame } = attachTwoViewers('fan-out');

  pty.emitData('\x1b[c');

  // The phone attached last — it is in charge until the desktop types.
  assert.deepEqual(lastFrame(phone), { type: 'output', data: '\x1b[c', end: 3 });
  assert.deepEqual(lastFrame(desktop), { type: 'output', data: '\x1b[c', end: 3, replay: true, live: true });

  desktop.emit('message', JSON.stringify({ type: 'input', data: 'ls\r' }));
  pty.emitData('live');
  assert.equal(lastFrame(desktop).replay, undefined);
  assert.equal(lastFrame(phone).replay, true);

  pty.emitExit();
});

test('a second device attaching does not resize the shell; typing on a device does', () => {
  const { pty, resizes, writes, desktop, phone } = attachTwoViewers('resize');

  // The phone's full replay only nudges a repaint at the shell's own size.
  assert.deepEqual(resizes, [[200, 49]]);
  resizes.length = 0;
  // A non-owner's layout is only remembered.
  desktop.emit('message', JSON.stringify({ type: 'resize', cols: 190, rows: 48 }));
  assert.deepEqual(resizes, []);

  desktop.emit('message', JSON.stringify({ type: 'input', data: 'x' }));
  assert.deepEqual(resizes, [[190, 48]]);
  assert.deepEqual(writes, ['x']);

  phone.emit('message', JSON.stringify({ type: 'input', data: 'y' }));
  assert.deepEqual(resizes, [[190, 48], [80, 24]]);
  assert.deepEqual(writes, ['x', 'y']);

  pty.emitExit();
});

test('a device the user looks at claims the shell size without typing', () => {
  const { pty, resizes, writes, desktop, phone, init, lastFrame } = attachTwoViewers('claim');
  resizes.length = 0;
  desktop.emit('message', JSON.stringify({ type: 'resize', cols: 190, rows: 48 }));

  desktop.emit('message', JSON.stringify({ type: 'claim' }));
  assert.deepEqual(resizes, [[190, 48]]);
  assert.deepEqual(writes, []);
  pty.emitData('live');
  assert.equal(lastFrame(desktop).replay, undefined);
  assert.equal(lastFrame(phone).replay, true);

  // A repeated claim at the same size does not reflow the shell.
  desktop.emit('message', JSON.stringify({ type: 'claim' }));
  phone.emit('message', JSON.stringify({ type: 'claim' }));
  assert.deepEqual(resizes, [[190, 48], [80, 24]]);

  // A shown tab reattaching sends its claim right behind the init.
  desktop.emit('message', init(150, 40));
  desktop.emit('message', JSON.stringify({ type: 'claim' }));
  assert.deepEqual(resizes.at(-1), [150, 40]);

  pty.emitExit();
});

test('a ping is answered with a pong', () => {
  const { pty, first, parsed } = startStream('ping');
  first.emit('message', JSON.stringify({ type: 'ping' }));
  assert.deepEqual(parsed(first).at(-1), { type: 'pong' });
  pty.emitExit();
});

test('the exit line carries the exit code as a field', () => {
  const { pty, first, parsed } = startStream('exit-code');
  pty.emitExit();
  const exitFrame = parsed(first).at(-1)!;
  assert.equal((exitFrame as { exitCode?: number }).exitCode, 0);
  assert.match(exitFrame.data!, /Process exited with code 0/);
});

test('one device closing leaves the PTY running for the other', () => {
  const { pty, desktop, phone, lastFrame } = attachTwoViewers('close');

  phone.emit('close');
  pty.emitData('still-here');

  assert.equal(pty.killed, false);
  assert.deepEqual(lastFrame(desktop), { type: 'output', data: 'still-here', end: 10 });

  pty.emitExit();
});

test('the last device detaching leaves the PTY running for a later reattach', (t) => {
  t.mock.timers.enable({ apis: ['setTimeout'] });
  const { pty, desktop, phone, init, lastFrame } = attachTwoViewers('detach-all');

  desktop.emit('close');
  phone.emit('close');
  t.mock.timers.tick(24 * 60 * 60 * 1000);
  pty.emitData('after-a-day');

  assert.equal(pty.killed, false);
  const returning = createFakeSocket();
  handleShellConnection(returning as never, {
    resolveProviderSessionId: () => null,
    spawnPty: () => assert.fail('a reattach must not spawn a new PTY'),
  });
  returning.emit('message', init(80, 24));
  assert.ok(returning.frames.some((frame) => frame.includes('after-a-day')));
  assert.equal(lastFrame(returning).replay, true);

  pty.emitExit();
});

test('a terminate from a closed tab kills the PTY for every device', () => {
  const { pty, desktop, phone, init } = attachTwoViewers('terminate');

  phone.emit('message', JSON.stringify({ type: 'terminate' }));
  assert.equal(pty.killed, true);
  pty.emitExit();

  const spawned: unknown[] = [];
  const next = createFakeSocket();
  handleShellConnection(next as never, {
    resolveProviderSessionId: () => null,
    spawnPty: () => {
      const fresh = createFakePty();
      spawned.push(fresh);
      return fresh as never;
    },
  });
  next.emit('message', init(80, 24));
  assert.equal(spawned.length, 1);
  assert.equal(desktop.frames.some((frame) => frame.includes('Process exited')), false);

  (spawned[0] as ReturnType<typeof createFakePty>).emitExit();
});

test('a restart keeps the other devices attached to the new run', () => {
  const { pty, desktop, phone, init, lastFrame } = attachTwoViewers('restart');

  desktop.emit('message', init(200, 50, true));
  phone.frames.length = 0;

  pty.emitData('after-restart');
  assert.equal(pty.killed, true);
  assert.match(lastFrame(phone).data ?? '', /after-restart/);

  pty.emitExit();
});

test('shell output detects and normalizes a wrapped authentication URL', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `wrapped-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  pty.emitData("Continue in your browser: https://example.com/authorize?\ncode=abc\x1b[0m");

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  const authenticationFrame = frames.find((frame) => frame.type === 'auth_url');
  assert.deepEqual(authenticationFrame, {
    type: 'auth_url',
    url: 'https://example.com/authorize?code=abc',
    autoOpen: false,
  });

  pty.emitExit();
});

test('shell output ignores URLs in code an agent shows, even below login prose', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `code-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  // A diff: a single-label host, and a real host whose login hint sits
  // further up than the prompt's own lines.
  pty.emitData("+  test('login opens the browser', () => {\r\n");
  pty.emitData("+    final id = n.openPane(url: 'http://a/')!;\r\n");
  pty.emitData('+    // one\r\n+    // two\r\n+    // three\r\n');
  pty.emitData("+    expect(pane.url, 'https://example.com/docs');\r\n");

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  assert.deepEqual(
    frames.filter((frame) => frame.type === 'auth_url'),
    []
  );

  pty.emitExit();
});

test('shell output keeps an auth URL repeated on the next line as a separate link', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `repeated-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  // Ink-based CLIs (e.g. `agy`) re-render the URL line; joining the repeat
  // into the first produces one URL with `scope` twice → Google 400.
  const authUrl = 'https://accounts.google.com/o/oauth2/v2/auth?client_id=x&scope=s';
  pty.emitData(`${authUrl}\n${authUrl}\x1b[0m`);

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  const authenticationFrames = frames.filter((frame) => frame.type === 'auth_url');
  assert.deepEqual(authenticationFrames, [
    { type: 'auth_url', url: authUrl, autoOpen: false },
  ]);

  pty.emitExit();
});

test('shell output suppresses a truncated re-render of an announced auth URL', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `truncated-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  const authUrl = 'https://accounts.google.com/o/oauth2/auth?client_id=x&scope=s';
  pty.emitData(`${authUrl}\n`);
  pty.emitData(`${authUrl.slice(0, 60)}\n`);

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  const authenticationFrames = frames.filter((frame) => frame.type === 'auth_url');
  assert.deepEqual(authenticationFrames, [
    { type: 'auth_url', url: authUrl, autoOpen: false },
  ]);

  pty.emitExit();
});

test('shell output emits a longer URL that extends an announced fragment', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `extended-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  const authUrl = 'https://accounts.google.com/o/oauth2/auth?client_id=x&scope=s';
  pty.emitData(`${authUrl.slice(0, 60)}\n`);
  pty.emitData(`${authUrl}\n`);

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  const authenticationFrames = frames.filter((frame) => frame.type === 'auth_url');
  assert.deepEqual(authenticationFrames, [
    { type: 'auth_url', url: authUrl.slice(0, 60), autoOpen: false },
    { type: 'auth_url', url: authUrl, autoOpen: false },
  ]);

  pty.emitExit();
});

test('shell output detects the canonical URL inside an OSC-8 hyperlink', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `osc8-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  const authUrl = 'https://accounts.google.com/o/oauth2/auth?client_id=x&scope=s';
  // `\x1b]8;id;x;URI\x07` — the display text may differ from the target URI.
  pty.emitData(`\x1b]8;id=abc;${authUrl}\x07click to sign in\x1b]8;;\x07\n`);

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  const authenticationFrames = frames.filter((frame) => frame.type === 'auth_url');
  assert.deepEqual(authenticationFrames, [
    { type: 'auth_url', url: authUrl, autoOpen: false },
  ]);

  pty.emitExit();
});

test('shell output strips OSC-8 sequences split around a wrapped auth URL', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `osc8-wrap-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  // `agy` wraps the URL at terminal width and closes the hyperlink style at
  // the wrap point; the close sequence may also split across chunks. The
  // mid-render fragment emits first, but no `8;;` escape remnant may glue
  // onto it, and the client's pick (`.last`) must be the complete URL.
  const authUrl = 'https://example.com/auth?client_id=abcdef&code=x';
  pty.emitData('https://example.com/auth?client_id=abc\x1b]8;');
  pty.emitData(';\x07\r\ndef&code=x\x1b]8;;\x07\n');

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  const authenticationFrames = frames.filter((frame) => frame.type === 'auth_url');
  assert.deepEqual(authenticationFrames, [
    { type: 'auth_url', url: 'https://example.com/auth?client_id=abc', autoOpen: false },
    { type: 'auth_url', url: authUrl, autoOpen: false },
  ]);

  pty.emitExit();
});

test('init env reaches the PTY environment, dropping invalid names and non-string values', () => {
  const pty = createFakePty();
  let spawnedEnv: Record<string, string | undefined> = {};
  const socket = createFakeSocket();
  handleShellConnection(socket as never, {
    resolveProviderSessionId: () => null,
    spawnPty: ((_file: string, _args: string[], options: { env: Record<string, string> }) => {
      spawnedEnv = options.env;
      return pty;
    }) as never,
  });

  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `env-${Date.now()}`,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'claude setup-token',
      env: { CLAUDE_CONFIG_DIR: '/tmp/acct', 'BAD;KEY': 'x', NUM: 1 },
    })
  );

  assert.equal(spawnedEnv.CLAUDE_CONFIG_DIR, '/tmp/acct');
  assert.equal(spawnedEnv['BAD;KEY'], undefined);
  assert.equal(spawnedEnv.NUM, undefined);
  assert.equal(spawnedEnv.TERM, 'xterm-256color');
  pty.emitExit();
});

test('a login command reattaches on a re-sent init; only forceRestart respawns it', () => {
  const spawned: Array<ReturnType<typeof createFakePty>> = [];
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => {
      const fresh = createFakePty();
      spawned.push(fresh);
      return fresh as never;
    },
  };
  const sessionId = `login-${Date.now()}`;
  const init = (forceRestart: boolean) =>
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'opencode auth login',
      forceRestart,
    });

  const socket = createFakeSocket();
  handleShellConnection(socket as never, dependencies);
  socket.emit('message', init(true));
  // Back from the browser: the reconnect re-sends init without forceRestart.
  const back = createFakeSocket();
  handleShellConnection(back as never, dependencies);
  back.emit('message', init(false));
  assert.equal(spawned.length, 1);
  assert.equal(spawned[0].killed, false);

  back.emit('message', init(true));
  assert.equal(spawned.length, 2);
  assert.equal(spawned[0].killed, true);

  spawned[1].emitExit();
});

test('a one-shot agent command runs from home when the project path is missing on this server', () => {
  const pty = createFakePty();
  let spawnedCwd: string | undefined;
  const socket = createFakeSocket();
  handleShellConnection(socket as never, {
    resolveProviderSessionId: () => null,
    spawnPty: ((_file: string, _args: string[], options: { cwd: string }) => {
      spawnedCwd = options.cwd;
      return pty;
    }) as never,
  });

  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      // A project registered from another machine (or since deleted).
      projectPath: '/no/such/project-dir',
      sessionId: `missing-${Date.now()}`,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'npm install -g @anthropic-ai/claude-code@latest',
    })
  );

  assert.equal(spawnedCwd, os.homedir());
  assert.ok(!socket.frames.some((frame) => frame.includes('Invalid project path')), socket.frames.join('\n'));
  pty.emitExit();
});

test('an agent session shell still rejects a missing project path', () => {
  const socket = createFakeSocket();
  let spawned = false;
  handleShellConnection(socket as never, {
    resolveProviderSessionId: () => null,
    spawnPty: (() => {
      spawned = true;
      return createFakePty();
    }) as never,
  });

  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: '/no/such/project-dir',
      sessionId: `missing-session-${Date.now()}`,
      provider: 'claude',
      hasSession: true,
    })
  );

  assert.equal(spawned, false);
  assert.ok(socket.frames.some((frame) => frame.includes('Invalid project path')));
});

test('a one-shot agent command with no project path runs from home', () => {
  const pty = createFakePty();
  let spawnedCwd: string | undefined;
  const socket = createFakeSocket();
  handleShellConnection(socket as never, {
    resolveProviderSessionId: () => null,
    spawnPty: ((_file: string, _args: string[], options: { cwd: string }) => {
      spawnedCwd = options.cwd;
      return pty;
    }) as never,
  });

  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: '',
      sessionId: `no-project-${Date.now()}`,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'claude setup-token',
    })
  );

  assert.equal(spawnedCwd, os.homedir());
  pty.emitExit();
});

test('shell output ignores documentation and release URLs that are not sign-in links', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `docs-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  pty.emitData(
    'Auto mode is now the default permission mode.\nhttps://code.claude.com/docs/en/permission-modes\n' +
      'See full release notes:\nhttps://github.com/openai/codex/releases/latest\n'
  );

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  assert.deepEqual(frames.filter((frame) => frame.type === 'auth_url'), []);

  pty.emitExit();
});

test('shell output never offers a loopback URL as a sign-in link', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `loopback-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  // A dev server's own routes — `/auth`, `login` and a login prompt around
  // them, even an "open this URL" line, are no CLI sign-in.
  pty.emitData(
    'POST http://localhost:5000/api/auth/login 200\n' +
      'Log in at http://127.0.0.1:8080/login?token=abc\n' +
      'Open this URL in your browser: http://[::1]:3000/oauth/callback\n' +
      'Sign in: http://app.localhost:4000/signin\n'
  );

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  assert.deepEqual(frames.filter((frame) => frame.type === 'auth_url'), []);

  pty.emitExit();
});

test('shell output surfaces a plain URL when the surrounding text is a login prompt', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => pty as never,
  };

  handleShellConnection(socket as never, dependencies);
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `context-url-${Date.now()}`,
      hasSession: false,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'test-command',
    })
  );
  socket.frames.length = 0;

  pty.emitData('Open this URL in your browser to sign in:\nhttps://example.com/abc123\n');

  const frames = socket.frames.map((frame) => JSON.parse(frame) as Record<string, unknown>);
  assert.deepEqual(frames.filter((frame) => frame.type === 'auth_url'), [
    { type: 'auth_url', url: 'https://example.com/abc123', autoOpen: false },
  ]);

  pty.emitExit();
});

/** One synced workspace naming the given terminal tab ids. */
const workspaceWithTabs = (...ids: string[]) => [
  { terminals: { route: { tabs: ids.map((id) => ({ id, ptySessionId: id, projectPath: '/p' })) } } },
];

test('the sweep ends a PTY whose tab no synced workspace shows, after a grace period', () => {
  const { pty, first } = startStream('orphan');
  const key = `${process.cwd()}_${'orphan'}`;
  const now = Date.now();
  first.emit('close');

  // Too young: its tab may not be published yet.
  assert.ok(!sweepOrphanedShellSessions(workspaceWithTabs('other'), now).some((k) => k.startsWith(key)));
  // Missing from the first old-enough sweep on, ended once that lasts.
  assert.ok(!sweepOrphanedShellSessions(workspaceWithTabs('other'), now + 3 * 60_000).some((k) => k.startsWith(key)));
  assert.equal(pty.killed, false);
  const ended = sweepOrphanedShellSessions(workspaceWithTabs('other'), now + 6 * 60_000);
  assert.ok(ended.some((k) => k.startsWith(key)));
  assert.equal(pty.killed, true);
});

test('the sweep keeps a PTY that is viewed, or named by a synced tab, or when nothing is synced', () => {
  const viewed = startStream('kept-viewed');
  const named = startStream('kept-named');
  named.first.emit('close');
  const now = Date.now();

  for (const later of [now + 10 * 60_000, now + 20 * 60_000]) {
    sweepOrphanedShellSessions(workspaceWithTabs(named.sessionId), later);
  }
  assert.equal(viewed.pty.killed, false);
  assert.equal(named.pty.killed, false);

  // No synced workspace at all says nothing about which tabs exist.
  const unknown = startStream('kept-unsynced');
  unknown.first.emit('close');
  for (const later of [now + 10 * 60_000, now + 20 * 60_000]) {
    sweepOrphanedShellSessions([], later);
  }
  assert.equal(unknown.pty.killed, false);

  for (const { pty } of [viewed, named, unknown]) pty.emitExit();
});

test('a one-shot command PTY ends 30 minutes after its last viewer left', () => {
  const pty = createFakePty();
  const socket = createFakeSocket();
  handleShellConnection(socket as never, { resolveProviderSessionId: () => null, spawnPty: () => pty as never });
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `cmd-${Date.now()}`,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'npm install -g something',
    })
  );
  socket.emit('close');
  sweepOrphanedShellSessions([], Date.now() + 29 * 60_000);
  assert.equal(pty.killed, false);
  sweepOrphanedShellSessions([], Date.now() + 31 * 60_000);
  assert.equal(pty.killed, true);
});

test('after a restart the gateway adopts PTYs from the host and resumes their stream', async (t) => {
  const socketPath = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'shell-host-')), 'host.sock');
  const held = createFakePty();
  const daemon = runPtyHostDaemon(socketPath, (() => held) as never);
  t.after(() => daemon.close());
  await new Promise((resolve) => setTimeout(resolve, 30));

  // The previous server process spawned this PTY and saw 'before ' of it.
  const sessionId = `adopt-${Date.now()}`;
  const sessionKey = `${process.cwd()}_${sessionId}`;
  const previous = (await connectPtyHost(socketPath))!;
  previous.spawn('run-7', 'bash', [], { name: 'xterm', cols: 80, rows: 24, cwd: '/', env: {} }, {
    sessionKey,
    projectPath: process.cwd(),
    sessionId,
    isCommand: false,
    createdAt: Date.now(),
  });
  await new Promise((resolve) => setTimeout(resolve, 30));
  held.emitData('before ');
  previous.close();
  held.emitData('during-restart');

  const host = (await startShellPtyHost(socketPath))!;
  t.after(() => host.close());

  const socket = createFakeSocket();
  handleShellConnection(socket as never, { resolveProviderSessionId: () => null });
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId,
      provider: 'plain-shell',
      isPlainShell: true,
      stream: 'run-7',
      seen: 'before '.length,
    })
  );
  const frames = socket.frames.map((frame) => JSON.parse(frame) as { type: string; data?: string; id?: string });
  assert.deepEqual(frames[0], { type: 'stream', id: 'run-7' });
  assert.equal(
    frames
      .filter((frame) => frame.type === 'output')
      .map((frame) => frame.data)
      .join(''),
    'during-restart'
  );

  held.emitExit();
});

test('output after adopting a full daemon window keeps the window for a later resume', async (t) => {
  const socketPath = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'shell-host-')), 'host.sock');
  const held = createFakePty();
  const daemon = runPtyHostDaemon(socketPath, (() => held) as never);
  t.after(() => daemon.close());
  await new Promise((resolve) => setTimeout(resolve, 30));

  const sessionId = `adopt-full-${Date.now()}`;
  const previous = (await connectPtyHost(socketPath))!;
  previous.spawn('run-9', 'bash', [], { name: 'xterm', cols: 80, rows: 24, cwd: '/', env: {} }, {
    sessionKey: `${process.cwd()}_${sessionId}`,
    projectPath: process.cwd(),
    sessionId,
    isCommand: false,
    createdAt: Date.now(),
  });
  await new Promise((resolve) => setTimeout(resolve, 30));
  // Fill the daemon's window to its cap, then the server restarts.
  for (let index = 0; index < 9; index += 1) {
    held.emitData('x'.repeat(64 * 1024));
  }
  previous.close();
  const host = (await startShellPtyHost(socketPath))!;
  t.after(() => host.close());
  held.emitData('spinner');
  await new Promise((resolve) => setTimeout(resolve, 30));

  const seen = 9 * 64 * 1024 - 10;
  const socket = createFakeSocket();
  handleShellConnection(socket as never, { resolveProviderSessionId: () => null });
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId,
      provider: 'plain-shell',
      isPlainShell: true,
      stream: 'run-9',
      seen,
    })
  );
  const output = socket.frames
    .map((frame) => JSON.parse(frame) as { type: string; data?: string })
    .filter((frame) => frame.type === 'output')
    .map((frame) => frame.data)
    .join('');
  assert.equal(output, `${'x'.repeat(10)}spinner`);

  held.emitExit();
});

test('a backed-up viewer still gets the last output before the exit line', () => {
  const pty = createFakePty();
  const socket = Object.assign(createFakeSocket(), { bufferedAmount: 0 });
  handleShellConnection(socket as never, { resolveProviderSessionId: () => null, spawnPty: () => pty as never });
  socket.emit(
    'message',
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: `exit-flush-${Date.now()}`,
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'npm i -g foo',
    })
  );
  socket.bufferedAmount = 2 * 1024 * 1024;
  pty.emitData('FINAL-ERROR');
  socket.bufferedAmount = 0;
  pty.emitExit();

  const outputs = socket.frames
    .map((frame) => JSON.parse(frame) as { data?: string; exitCode?: number })
    .filter((frame) => frame.data !== undefined);
  assert.equal(outputs.at(-2)?.data, 'FINAL-ERROR');
  assert.equal(outputs.at(-1)?.exitCode, 0);
});

test('a device away when its PTY exited sees the exit on reattach instead of a rerun', () => {
  let spawns = 0;
  const pty = createFakePty();
  const dependencies = {
    resolveProviderSessionId: () => null,
    spawnPty: () => {
      spawns += 1;
      return pty as never;
    },
  };
  const init = (stream?: string, forceRestart = false) =>
    JSON.stringify({
      type: 'init',
      projectPath: process.cwd(),
      sessionId: 'exit-away-tab',
      provider: 'plain-shell',
      isPlainShell: true,
      initialCommand: 'npm i -g foo',
      forceRestart,
      stream,
      seen: 0,
    });
  const phone = createFakeSocket();
  handleShellConnection(phone as never, dependencies);
  phone.emit('message', init());
  const streamId = (JSON.parse(phone.frames[0]) as { id: string }).id;
  phone.emit('close');
  pty.emitExit();

  const back = createFakeSocket();
  handleShellConnection(back as never, dependencies);
  back.emit('message', init(streamId));
  assert.equal(spawns, 1);
  const frames = back.frames.map((frame) => JSON.parse(frame) as { type: string; id?: string; exitCode?: number });
  assert.deepEqual(frames[0], { type: 'stream', id: streamId });
  assert.equal(frames[1].exitCode, 0);

  // Restart still runs it again.
  back.emit('message', init(streamId, true));
  assert.equal(spawns, 2);
  pty.emitExit();
});

test('after a restart each carried device keeps its own size for its claim', () => {
  const { pty, resizes, desktop, phone, init } = attachTwoViewers('restart-size');
  phone.emit('message', init(80, 24, true));
  resizes.length = 0;

  desktop.emit('message', JSON.stringify({ type: 'claim' }));
  assert.deepEqual(resizes, [[200, 50]]);

  pty.emitExit();
});

test('an adopted PTY replays the title and modes the daemon saw before its window', async (t) => {
  const socketPath = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'shell-host-')), 'host.sock');
  const held = createFakePty();
  const daemon = runPtyHostDaemon(socketPath, (() => held) as never);
  t.after(() => daemon.close());
  await new Promise((resolve) => setTimeout(resolve, 30));

  const sessionId = `adopt-state-${Date.now()}`;
  const previous = (await connectPtyHost(socketPath))!;
  previous.spawn('run-8', 'bash', [], { name: 'xterm', cols: 80, rows: 24, cwd: '/', env: {} }, {
    sessionKey: `${process.cwd()}_${sessionId}`,
    projectPath: process.cwd(),
    sessionId,
    isCommand: false,
    createdAt: Date.now(),
  });
  await new Promise((resolve) => setTimeout(resolve, 30));
  // Claude Code at startup, then far more redraws than the daemon's window holds.
  held.emitData('\x1b]0;My session\x07\x1b[?1049h\x1b[?1000;1006h');
  for (let i = 0; i < 256; i++) {
    held.emitData('.'.repeat(4096));
  }
  await new Promise((resolve) => setTimeout(resolve, 30));
  previous.close();

  const host = (await startShellPtyHost(socketPath))!;
  t.after(() => host.close());
  const socket = createFakeSocket();
  handleShellConnection(socket as never, { resolveProviderSessionId: () => null });
  socket.emit(
    'message',
    JSON.stringify({ type: 'init', projectPath: process.cwd(), sessionId, provider: 'plain-shell', isPlainShell: true })
  );
  const first = socket.frames
    .map((frame) => JSON.parse(frame) as { type: string; data: string })
    .find((frame) => frame.type === 'output');
  assert.equal(
    first?.data,
    '\x1b[2J\x1b[3J\x1b[H\x1b]2;My session\x07\x1b[?1049h\x1b[?1000h\x1b[?1006h'
  );

  held.emitExit();
});

test('a full replay makes the program repaint its screen', async () => {
  const pty = createFakePty();
  const dependencies = { resolveProviderSessionId: () => null, spawnPty: () => pty as never };
  const initMessage = JSON.stringify({
    type: 'init',
    projectPath: process.cwd(),
    sessionId: `repaint-${Date.now()}`,
    provider: 'plain-shell',
    isPlainShell: true,
    cols: 80,
    rows: 24,
  });
  const firstSocket = createFakeSocket();
  handleShellConnection(firstSocket as never, dependencies);
  firstSocket.emit('message', initMessage);
  pty.emitData('drawn by differences');
  pty.resizes.length = 0;

  // A reload: the replayed tail is not the screen the program believes it drew.
  const reloaded = createFakeSocket();
  handleShellConnection(reloaded as never, dependencies);
  reloaded.emit('message', initMessage);
  await new Promise((resolve) => setTimeout(resolve, 200));
  assert.deepEqual(pty.resizes, [
    [80, 23],
    [80, 24],
  ]);

  pty.emitExit();
});
