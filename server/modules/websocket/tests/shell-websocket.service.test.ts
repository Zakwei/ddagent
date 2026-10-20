import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import os from 'node:os';
import test from 'node:test';

import { WebSocket } from 'ws';

import { handleShellConnection } from '@/modules/websocket/services/shell-websocket.service.js';

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
    resize() {},
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
  return { pty, attach, parsed, first, streamId };
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
  assert.deepEqual(lastFrame(desktop), { type: 'output', data: '\x1b[c', end: 3, replay: true });

  desktop.emit('message', JSON.stringify({ type: 'input', data: 'ls\r' }));
  pty.emitData('live');
  assert.equal(lastFrame(desktop).replay, undefined);
  assert.equal(lastFrame(phone).replay, true);

  pty.emitExit();
});

test('a second device attaching does not resize the shell; typing on a device does', () => {
  const { pty, resizes, writes, desktop, phone } = attachTwoViewers('resize');

  assert.deepEqual(resizes, []);
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
