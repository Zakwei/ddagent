import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { createPortDiscoveryService } from '../preview.service.js';

const SS_FIXTURE = `State    Recv-Q   Send-Q     Local Address:Port      Peer Address:Port   Process
LISTEN   0        4096       127.0.0.1:10087          0.0.0.0:*           users:(("node",pid=1000,fd=24))
LISTEN   0        511        [::]:5173                [::]:*              users:(("node",pid=1001,fd=32))
LISTEN   0        100        0.0.0.0:3000             0.0.0.0:*           users:(("node",pid=1002,fd=19))
LISTEN   0        5          192.168.1.10:8080        0.0.0.0:*           users:(("node",pid=1003,fd=7))
LISTEN   0        100        127.0.0.1:22             0.0.0.0:*
`;

function makeProc(procRoot: string, pid: number, cwd: string, comm = 'node') {
  fs.mkdirSync(path.join(procRoot, String(pid)), { recursive: true });
  fs.writeFileSync(path.join(procRoot, String(pid), 'comm'), `${comm}\n`);
  fs.symlinkSync(cwd, path.join(procRoot, String(pid), 'cwd'));
}

test('returns no ports without a projectPath', async () => {
  const service = createPortDiscoveryService({ runSs: async () => SS_FIXTURE });
  assert.deepEqual(await service.listListeningPorts(), []);
});

test('parse ss -tlnp output keeps only loopback/wildcard listeners inside the project', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    makeProc(procRoot, 1001, projectDir, 'vite');
    makeProc(procRoot, 1002, projectDir);

    const service = createPortDiscoveryService({
      runSs: async () => SS_FIXTURE,
      procRoot,
    });

    const ports = await service.listListeningPorts(projectDir);
    const byPort = new Map(ports.map((entry) => [entry.port, entry]));

    assert.ok(byPort.has(5173));
    assert.ok(byPort.has(3000));
    // Bound to a LAN address only — not reachable through 127.0.0.1.
    assert.ok(!byPort.has(8080));
    // No process column → cwd unknown → not attributable to the project.
    assert.ok(!byPort.has(22));
    // pid 1000 has no cwd entry → dropped by the project filter.
    assert.ok(!byPort.has(10087));

    assert.equal(byPort.get(5173)?.pid, 1001);
    assert.equal(byPort.get(5173)?.processName, 'node'); // ss name wins over comm
    assert.equal(byPort.get(5173)?.cwd, projectDir);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test("ddagent's own pid and port are excluded even inside the project", async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    makeProc(procRoot, 1000, projectDir);
    makeProc(procRoot, 1001, projectDir, 'vite');
    makeProc(procRoot, 1002, projectDir);

    const service = createPortDiscoveryService({
      runSs: async () => SS_FIXTURE,
      procRoot,
      selfPid: 1000,
      selfPort: 10087,
    });

    const ports = await service.listListeningPorts(projectDir);
    assert.deepEqual(ports.map((entry) => entry.port), [3000, 5173]);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('selfPid excludes listening ports owned by the host process even on non-standard ports', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    makeProc(procRoot, 1001, projectDir, 'vite');
    makeProc(procRoot, 1002, projectDir);

    const service = createPortDiscoveryService({
      runSs: async () => SS_FIXTURE,
      procRoot,
      selfPid: 1001,
      selfPort: 99999,
    });

    const ports = await service.listListeningPorts(projectDir);
    assert.deepEqual(ports.map((entry) => entry.port), [3000]);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('selfPort excludes the port even when owned by a different process', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    makeProc(procRoot, 1001, projectDir, 'vite');
    makeProc(procRoot, 1002, projectDir);

    const service = createPortDiscoveryService({
      runSs: async () => SS_FIXTURE,
      procRoot,
      selfPid: 99999,
      selfPort: 3000,
    });

    const ports = await service.listListeningPorts(projectDir);
    assert.deepEqual(ports.map((entry) => entry.port), [5173]);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('defaults selfPid to process.pid and selfPort to process.env.SERVER_PORT', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  const originalServerPort = process.env.SERVER_PORT;
  try {
    process.env.SERVER_PORT = '3000';
    makeProc(procRoot, process.pid, projectDir, 'ddagent');
    makeProc(procRoot, 1001, projectDir, 'vite');
    makeProc(procRoot, 1002, projectDir);

    const ssWithCurrentPid = `State    Recv-Q   Send-Q     Local Address:Port      Peer Address:Port   Process
LISTEN   0        511        127.0.0.1:4000           0.0.0.0:*           users:(("node",pid=${process.pid},fd=10))
LISTEN   0        511        [::]:5173                [::]:*              users:(("node",pid=1001,fd=32))
LISTEN   0        100        0.0.0.0:3000             0.0.0.0:*           users:(("node",pid=1002,fd=19))
`;

    const service = createPortDiscoveryService({
      runSs: async () => ssWithCurrentPid,
      procRoot,
    });

    const ports = await service.listListeningPorts(projectDir);
    assert.deepEqual(ports.map((entry) => entry.port), [5173]);
  } finally {
    if (originalServerPort === undefined) {
      delete process.env.SERVER_PORT;
    } else {
      process.env.SERVER_PORT = originalServerPort;
    }
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('projectPath filter keeps only processes whose cwd is inside it', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  fs.mkdirSync(path.join(projectDir, 'subdir'), { recursive: true });
  try {
    fs.mkdirSync(path.join(procRoot, '1001'), { recursive: true });
    fs.mkdirSync(path.join(procRoot, '1002'), { recursive: true });
    // pid 1001 lives inside the project's subdir; pid 1002 sits outside.
    fs.symlinkSync(path.join(projectDir, 'subdir'), path.join(procRoot, '1001', 'cwd'));
    fs.symlinkSync(procRoot, path.join(procRoot, '1002', 'cwd'));

    const service = createPortDiscoveryService({
      runSs: async () => SS_FIXTURE,
      procRoot,
    });

    const ports = await service.listListeningPorts(projectDir);
    assert.deepEqual(ports.map((entry) => entry.port), [5173]);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('results are cached within the ttl window', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    let calls = 0;
    let clock = 1000;
    const service = createPortDiscoveryService({
      runSs: async () => {
        calls += 1;
        return SS_FIXTURE;
      },
      procRoot,
      now: () => clock,
    });

    await service.listListeningPorts(projectDir);
    await service.listListeningPorts(projectDir);
    assert.equal(calls, 1);

    clock += 3000;
    await service.listListeningPorts(projectDir);
    assert.equal(calls, 2);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('/proc fallback maps socket inodes to pids and cwd', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    // Fake /proc/net/tcp: one listener on 127.0.0.1:5173 (0x1435) with inode 4242.
    fs.mkdirSync(path.join(procRoot, 'net'), { recursive: true });
    fs.writeFileSync(
      path.join(procRoot, 'net', 'tcp'),
      [
        '  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode',
        '   0: 0100007F:1435 00000000:0000 0A 00000000:00000000 00:00000000 00000000  1000        0 4242 1 0000000000000000 100 0 0 10 0',
        '   1: 0A0101C0:0050 00000000:0000 0A 00000000:00000000 00:00000000 00000000  1000        0 5555 1 0000000000000000 100 0 0 10 0',
      ].join('\n'),
    );
    fs.writeFileSync(path.join(procRoot, 'net', 'tcp6'), '');

    // pid 4321's fd 3 is socket:[4242]; cwd -> projectDir.
    fs.mkdirSync(path.join(procRoot, '4321', 'fd'), { recursive: true });
    fs.writeFileSync(path.join(procRoot, '4321', 'comm'), 'node\n');
    fs.symlinkSync(projectDir, path.join(procRoot, '4321', 'cwd'));
    fs.symlinkSync('socket:[4242]', path.join(procRoot, '4321', 'fd', '3'));

    const service = createPortDiscoveryService({
      runSs: async () => null, // ss unavailable -> fallback
      procRoot,
    });

    const filtered = await service.listListeningPorts(projectDir);
    assert.deepEqual(filtered.map((entry) => entry.port), [5173]);
    assert.equal(filtered[0]?.pid, 4321);
    assert.equal(filtered[0]?.processName, 'node');
    assert.equal(filtered[0]?.cwd, projectDir);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});

test('/proc fallback excludes selfPid and selfPort', async () => {
  const procRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proc-'));
  const projectDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-proj-'));
  try {
    fs.mkdirSync(path.join(procRoot, 'net'), { recursive: true });
    fs.writeFileSync(
      path.join(procRoot, 'net', 'tcp'),
      [
        '  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode',
        '   0: 0100007F:1435 00000000:0000 0A 00000000:00000000 00:00000000 00000000  1000        0 4242 1 0000000000000000 100 0 0 10 0',
        '   1: 0100007F:0BB8 00000000:0000 0A 00000000:00000000 00:00000000 00000000  1000        0 4243 1 0000000000000000 100 0 0 10 0',
      ].join('\n'),
    );
    fs.writeFileSync(path.join(procRoot, 'net', 'tcp6'), '');

    // pid 4321 listens on port 5173 (0x1435)
    fs.mkdirSync(path.join(procRoot, '4321', 'fd'), { recursive: true });
    fs.writeFileSync(path.join(procRoot, '4321', 'comm'), 'node\n');
    fs.symlinkSync(projectDir, path.join(procRoot, '4321', 'cwd'));
    fs.symlinkSync('socket:[4242]', path.join(procRoot, '4321', 'fd', '3'));

    // pid 4322 listens on port 3000 (0x0BB8)
    fs.mkdirSync(path.join(procRoot, '4322', 'fd'), { recursive: true });
    fs.writeFileSync(path.join(procRoot, '4322', 'comm'), 'node\n');
    fs.symlinkSync(projectDir, path.join(procRoot, '4322', 'cwd'));
    fs.symlinkSync('socket:[4243]', path.join(procRoot, '4322', 'fd', '3'));

    // Exclude selfPid: 4321, selfPort: 3000 -> both filtered out
    const service = createPortDiscoveryService({
      runSs: async () => null,
      procRoot,
      selfPid: 4321,
      selfPort: 3000,
    });

    const filtered = await service.listListeningPorts(projectDir);
    assert.deepEqual(filtered, []);
  } finally {
    fs.rmSync(procRoot, { recursive: true, force: true });
    fs.rmSync(projectDir, { recursive: true, force: true });
  }
});
