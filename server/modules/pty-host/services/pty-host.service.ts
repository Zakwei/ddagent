/**
 * PTY host: keeps terminal processes alive across ddagent server restarts.
 *
 * The daemon half runs as its own process (its own systemd unit, outside the
 * server's cgroup) and owns every PTY: it spawns them, keeps a replay window
 * of their output and an offset into it, and outlives the server. The client
 * half runs inside the server: the `/shell` gateway spawns through it and, on
 * startup, adopts the PTYs the daemon still holds — so a restart neither
 * kills the shells nor loses their scrollback.
 *
 * Wire protocol: newline-delimited JSON over a unix socket.
 * - client → daemon: `spawn {id, file, args, options, meta}`, `write {id,
 *   data}`, `resize {id, cols, rows}`, `kill {id}`, `list {}`.
 * - daemon → client: `spawned {id, pid}`, `data {id, data}`, `exit {id,
 *   exitCode, signal}`, `list {ptys}`, `error {id?, message}`.
 *
 * A `list` reply is a snapshot taken when the request is handled; every event
 * after it on the same socket is newer, so the client ignores events for ids
 * it has not adopted yet (they are already in the snapshot).
 */

import fs from 'node:fs';
import net from 'node:net';
import os from 'node:os';
import path from 'node:path';

import pty, { type IPty } from 'node-pty';

import { killProcessGroup } from '@/shared/utils.js';

type PtyHostSpawnOptions = {
  name: string;
  cols: number;
  rows: number;
  cwd: string;
  env: Record<string, string | undefined>;
};

type PtyHostRequest =
  | {
      op: 'spawn';
      id: string;
      file: string;
      args: string[];
      options: PtyHostSpawnOptions;
      meta: Record<string, unknown>;
    }
  | { op: 'write'; id: string; data: string }
  | { op: 'resize'; id: string; cols: number; rows: number }
  | { op: 'kill'; id: string }
  | { op: 'list' };

type PtyHostEvent =
  | { ev: 'spawned'; id: string; pid: number }
  | { ev: 'data'; id: string; data: string }
  | { ev: 'exit'; id: string; exitCode: number; signal?: number }
  | { ev: 'list'; ptys: PtyHostSnapshot[] }
  | { ev: 'error'; id?: string; message: string };

/**
 * One PTY the daemon holds, as handed to a client adopting it: the id it was
 * spawned with, its process, size, the caller's `meta`, and its replay window
 * (`buffer`) ending at stream offset `outputEnd`. Used by the shell gateway
 * to rebuild its session table after a server restart.
 */
export type PtyHostSnapshot = {
  id: string;
  pid: number;
  cols: number;
  rows: number;
  meta: Record<string, unknown>;
  buffer: string;
  outputEnd: number;
};

/**
 * The slice of node-pty's IPty the shell gateway drives — implemented by a
 * local node-pty process and by a PTY held in the daemon alike. Used by the
 * WebSocket shell service.
 */
export type HostedPty = Pick<IPty, 'pid' | 'onData' | 'onExit' | 'write' | 'resize' | 'kill'>;

/** Same window as the gateway's, so an adopted buffer covers what clients may resume from. */
const DAEMON_BUFFER_MAX_CHARS = 512 * 1024;

/**
 * Where the daemon listens and the server connects: `DDAGENT_PTY_HOST_SOCKET`,
 * or `~/.ddagent/pty-host.sock`. Used by the daemon entrypoint and the shell
 * service's startup.
 */
export function resolvePtyHostSocketPath(env: NodeJS.ProcessEnv = process.env): string {
  return env.DDAGENT_PTY_HOST_SOCKET || path.join(os.homedir(), '.ddagent', 'pty-host.sock');
}

/** Splits a socket's byte stream into JSON messages, one per line. */
function onJsonLines(socket: net.Socket, handle: (message: unknown) => void): void {
  let pending = '';
  socket.setEncoding('utf8');
  socket.on('data', (chunk: string) => {
    pending += chunk;
    let newline = pending.indexOf('\n');
    while (newline !== -1) {
      const line = pending.slice(0, newline);
      pending = pending.slice(newline + 1);
      if (line) {
        try {
          handle(JSON.parse(line));
        } catch {
          // A malformed line is skipped; the next one still parses.
        }
      }
      newline = pending.indexOf('\n');
    }
  });
}

function writeJsonLine(socket: net.Socket, message: PtyHostRequest | PtyHostEvent): void {
  if (!socket.destroyed) {
    socket.write(`${JSON.stringify(message)}\n`);
  }
}

//---------- DAEMON ----------

type DaemonPty = {
  pty: IPty;
  cols: number;
  rows: number;
  meta: Record<string, unknown>;
  buffer: string[];
  bufferChars: number;
  outputEnd: number;
};

/**
 * Runs the PTY host daemon on `socketPath` until the process exits: a stale
 * socket file is replaced, every connected client gets every PTY's events,
 * and PTYs keep running and buffering with no client connected. Used by the
 * pty-host entrypoint; `spawnPty` is injectable for tests.
 */
export function runPtyHostDaemon(
  socketPath: string,
  spawnPty: typeof pty.spawn = pty.spawn
): net.Server {
  const ptys = new Map<string, DaemonPty>();
  const clients = new Set<net.Socket>();
  const broadcast = (event: PtyHostEvent) => {
    for (const client of clients) {
      writeJsonLine(client, event);
    }
  };

  const handle = (client: net.Socket, request: PtyHostRequest) => {
    if (request.op === 'list') {
      writeJsonLine(client, {
        ev: 'list',
        ptys: [...ptys.entries()].map(([id, held]) => ({
          id,
          pid: held.pty.pid,
          cols: held.cols,
          rows: held.rows,
          meta: held.meta,
          buffer: held.buffer.join(''),
          outputEnd: held.outputEnd,
        })),
      });
      return;
    }

    if (request.op === 'spawn') {
      let spawned: IPty;
      try {
        spawned = spawnPty(request.file, request.args, request.options);
      } catch (error) {
        writeJsonLine(client, {
          ev: 'error',
          id: request.id,
          message: error instanceof Error ? error.message : String(error),
        });
        return;
      }
      const held: DaemonPty = {
        pty: spawned,
        cols: request.options.cols,
        rows: request.options.rows,
        meta: request.meta,
        buffer: [],
        bufferChars: 0,
        outputEnd: 0,
      };
      ptys.set(request.id, held);
      spawned.onData((data) => {
        held.buffer.push(data);
        held.bufferChars += data.length;
        held.outputEnd += data.length;
        while (held.bufferChars > DAEMON_BUFFER_MAX_CHARS && held.buffer.length > 1) {
          held.bufferChars -= held.buffer.shift()!.length;
        }
        broadcast({ ev: 'data', id: request.id, data });
      });
      spawned.onExit(({ exitCode, signal }) => {
        ptys.delete(request.id);
        broadcast({ ev: 'exit', id: request.id, exitCode, signal });
      });
      writeJsonLine(client, { ev: 'spawned', id: request.id, pid: spawned.pid });
      return;
    }

    const held = ptys.get(request.id);
    if (!held) {
      return;
    }
    if (request.op === 'write') {
      held.pty.write(request.data);
    } else if (request.op === 'resize') {
      held.pty.resize(request.cols, request.rows);
      held.cols = request.cols;
      held.rows = request.rows;
    } else if (request.op === 'kill') {
      killProcessGroup(held.pty.pid, () => held.pty.kill());
    }
  };

  fs.mkdirSync(path.dirname(socketPath), { recursive: true });
  fs.rmSync(socketPath, { force: true });
  const server = net.createServer((client) => {
    clients.add(client);
    client.on('close', () => clients.delete(client));
    client.on('error', () => clients.delete(client));
    onJsonLines(client, (message) => {
      if (message && typeof message === 'object' && 'op' in message) {
        handle(client, message as PtyHostRequest);
      }
    });
  });
  server.listen(socketPath, () => {
    // Only this user may drive the terminals.
    fs.chmodSync(socketPath, 0o600);
  });
  return server;
}

// ----------

//---------- CLIENT ----------

type Listener<T> = (value: T) => void;

/** A PTY held by the daemon, driven over the client's socket. */
class RemotePty implements HostedPty {
  pid = 0;
  readonly dataListeners = new Set<Listener<string>>();
  readonly exitListeners = new Set<Listener<{ exitCode: number; signal?: number }>>();

  constructor(
    private readonly id: string,
    private readonly send: (request: PtyHostRequest) => void
  ) {}

  onData: IPty['onData'] = (listener) => {
    this.dataListeners.add(listener);
    return { dispose: () => this.dataListeners.delete(listener) };
  };

  onExit: IPty['onExit'] = (listener) => {
    this.exitListeners.add(listener);
    return { dispose: () => this.exitListeners.delete(listener) };
  };

  write(data: string): void {
    this.send({ op: 'write', id: this.id, data });
  }

  resize(cols: number, rows: number): void {
    this.send({ op: 'resize', id: this.id, cols, rows });
  }

  /** Always ends the whole process group — the daemon decides how. */
  kill(): void {
    this.send({ op: 'kill', id: this.id });
  }
}

/**
 * The server's connection to the PTY host daemon. Used by the WebSocket shell
 * service to spawn PTYs that survive a server restart and to adopt the ones a
 * previous server process left running.
 */
export type PtyHostClient = {
  /** Spawns a PTY in the daemon under `id`, keeping `meta` for a later adoption. */
  spawn(
    id: string,
    file: string,
    args: string[],
    options: PtyHostSpawnOptions,
    meta: Record<string, unknown>
  ): HostedPty;
  /**
   * Hands every PTY the daemon holds to `adopt`, synchronously as the list
   * arrives — output that follows on the socket is only delivered to
   * listeners `adopt` attached — and resolves with how many there were.
   */
  adoptAll(adopt: (snapshot: PtyHostSnapshot, pty: HostedPty) => void): Promise<number>;
  /** Fires once when the daemon connection drops; held PTYs report exit first. */
  onClose(listener: () => void): void;
  /** Disconnects; the daemon keeps every PTY running for the next client. */
  close(): void;
};

/**
 * Connects to the daemon at `socketPath`, or resolves null when none listens
 * there (the server then spawns PTYs itself, as before the host existed).
 */
export function connectPtyHost(socketPath: string): Promise<PtyHostClient | null> {
  return new Promise((resolve) => {
    if (!fs.existsSync(socketPath)) {
      resolve(null);
      return;
    }
    const socket = net.connect(socketPath);
    const remotes = new Map<string, RemotePty>();
    const closeListeners: Array<() => void> = [];
    let pendingList: ((ptys: PtyHostSnapshot[]) => void) | null = null;
    let connected = false;
    let closing = false;

    const send = (request: PtyHostRequest) => writeJsonLine(socket, request);
    const reportExit = (remote: RemotePty, exitCode: number, signal?: number) => {
      for (const listener of remote.exitListeners) {
        listener({ exitCode, signal });
      }
    };

    onJsonLines(socket, (message) => {
      const event = message as PtyHostEvent;
      if (event.ev === 'list') {
        pendingList?.(event.ptys);
        pendingList = null;
        return;
      }
      if (event.ev === 'error') {
        console.error('[PTY host]', event.message);
        const remote = event.id ? remotes.get(event.id) : undefined;
        if (remote && event.id) {
          remotes.delete(event.id);
          reportExit(remote, 1);
        }
        return;
      }
      // Events for ids not adopted yet are already part of the list snapshot.
      const remote = remotes.get(event.id);
      if (!remote) {
        return;
      }
      if (event.ev === 'spawned') {
        remote.pid = event.pid;
      } else if (event.ev === 'data') {
        for (const listener of remote.dataListeners) {
          listener(event.data);
        }
      } else if (event.ev === 'exit') {
        remotes.delete(event.id);
        reportExit(remote, event.exitCode, event.signal);
      }
    });

    socket.on('error', (error) => {
      if (!connected) {
        console.warn('[PTY host] not reachable, terminals run in the server process:', error.message);
        resolve(null);
      }
    });
    socket.on('close', () => {
      if (!connected || closing) {
        return;
      }
      console.error('[PTY host] connection lost — its terminals are gone');
      // The daemon going away takes its PTYs with it.
      for (const remote of remotes.values()) {
        reportExit(remote, 1);
      }
      remotes.clear();
      for (const listener of closeListeners) {
        listener();
      }
    });
    socket.on('connect', () => {
      connected = true;
      resolve({
        spawn(id, file, args, options, meta) {
          const remote = new RemotePty(id, send);
          remotes.set(id, remote);
          send({ op: 'spawn', id, file, args, options, meta });
          return remote;
        },
        adoptAll(adopt) {
          return new Promise((resolveList) => {
            pendingList = (ptys) => {
              for (const snapshot of ptys) {
                const remote = new RemotePty(snapshot.id, send);
                remote.pid = snapshot.pid;
                remotes.set(snapshot.id, remote);
                adopt(snapshot, remote);
              }
              resolveList(ptys.length);
            };
            send({ op: 'list' });
          });
        },
        onClose(listener) {
          closeListeners.push(listener);
        },
        close() {
          closing = true;
          socket.destroy();
        },
      });
    });
  });
}

// ----------
