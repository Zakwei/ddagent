import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
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
