import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  connectPtyHost,
  runPtyHostDaemon,
  type PtyHostSnapshot,
} from '@/modules/pty-host/services/pty-host.service.js';

/** A node-pty double the daemon spawns; `emitData`/`emitExit` drive it. */
function createFakePty() {
  const dataListeners: Array<(data: string) => void> = [];
  const exitListeners: Array<(event: { exitCode: number; signal?: number }) => void> = [];
  return {
    pid: 0,
    writes: [] as string[],
    killed: false,
    onData(listener: (data: string) => void) {
      dataListeners.push(listener);
      return { dispose: () => undefined };
    },
    onExit(listener: (event: { exitCode: number; signal?: number }) => void) {
      exitListeners.push(listener);
      return { dispose: () => undefined };
    },
    write(data: string) {
      this.writes.push(data);
    },
    resize() {},
    kill() {
      this.killed = true;
      for (const listener of exitListeners) listener({ exitCode: 0, signal: 1 });
    },
    emitData(data: string) {
      for (const listener of dataListeners) listener(data);
    },
  };
}

const tick = () => new Promise((resolve) => setTimeout(resolve, 30));

test('the daemon keeps a PTY and its output across client reconnects', async (t) => {
  const socketPath = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'pty-host-')), 'host.sock');
  const fakes: Array<ReturnType<typeof createFakePty>> = [];
  const daemon = runPtyHostDaemon(socketPath, (() => {
    const fake = createFakePty();
    fakes.push(fake);
    return fake;
  }) as never);
  t.after(() => daemon.close());
  await tick();

  const first = (await connectPtyHost(socketPath))!;
  const held = first.spawn('stream-1', 'bash', [], { name: 'xterm', cols: 90, rows: 30, cwd: '/', env: {} }, {
    sessionKey: '/p_tab-1',
  });
  const seen: string[] = [];
  held.onData((data) => seen.push(data));
  held.write('ls\r');
  await tick();
  assert.deepEqual(fakes[0].writes, ['ls\r']);
  fakes[0].emitData('hello ');
  await tick();
  assert.deepEqual(seen, ['hello ']);

  // The server goes away (restart); output keeps being buffered.
  first.close();
  await tick();
  fakes[0].emitData('while-away');

  const second = (await connectPtyHost(socketPath))!;
  const adopted: Array<{ snapshot: PtyHostSnapshot; data: string[] }> = [];
  const count = await second.adoptAll((snapshot, pty) => {
    const data: string[] = [];
    pty.onData((chunk) => data.push(chunk));
    adopted.push({ snapshot, data });
  });
  assert.equal(count, 1);
  const [{ snapshot, data }] = adopted;
  assert.equal(snapshot.id, 'stream-1');
  assert.equal(snapshot.buffer, 'hello while-away');
  assert.equal(snapshot.outputEnd, 'hello while-away'.length);
  assert.equal(snapshot.cols, 90);
  assert.deepEqual(snapshot.meta, { sessionKey: '/p_tab-1' });

  fakes[0].emitData('after');
  await tick();
  assert.deepEqual(data, ['after']);
  second.close();
});

test('a client finds no daemon where no socket exists', async () => {
  assert.equal(await connectPtyHost(path.join(os.tmpdir(), `missing-${Date.now()}.sock`)), null);
});
