import { execFile } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

/**
 * One TCP listener bound to a loopback/wildcard address owned by a local
 * process — a dev-server candidate for the preview proxy.
 */
export type ListeningPort = {
  port: number;
  /** Local address the socket is bound to (e.g. 127.0.0.1, ::, 0.0.0.0). */
  address: string;
  pid: number | null;
  processName: string | null;
  /** Process working directory — used to attribute ports to a project. */
  cwd: string | null;
};

type SsEntry = {
  address: string;
  port: number;
  pids: number[];
  processName: string | null;
};

/**
 * Injectable seams for the port-discovery service. Tests feed a fixture
 * `runSs` and a synthetic `procRoot`; production defaults hit the real system.
 */
export type PortDiscoveryDependencies = {
  /** Returns `ss -tlnp` stdout, or null when ss is unavailable/failed. */
  runSs?: () => Promise<string | null>;
  /** Root of the proc filesystem — overridden in tests with a fake tree. */
  procRoot?: string;
  now?: () => number;
  cacheTtlMs?: number;
};

const DEFAULT_CACHE_TTL_MS = 2000;

const LOOPBACK_SS_ADDRESSES = new Set([
  '127.0.0.1',
  '::1',
  '0.0.0.0',
  '::',
  '*',
  'localhost',
]);

function runSsCommand(): Promise<string | null> {
  return new Promise((resolve) => {
    execFile('ss', ['-tlnp'], { timeout: 5000 }, (error, stdout) => {
      resolve(error ? null : stdout);
    });
  });
}

/**
 * Parses `ss -tlnp` output into listening-port entries. Only TCP listeners on
 * loopback or wildcard addresses are kept — a dev server bound to a LAN
 * address is still reachable through 127.0.0.1 only when it also binds the
 * wildcard, which shows up as its own row.
 */
function parseSsOutput(output: string): SsEntry[] {
  const entries: SsEntry[] = [];

  for (const line of output.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed.startsWith('LISTEN')) continue;

    // LISTEN <recvq> <sendq> <local-addr:port> <peer> [users:...]
    const fields = trimmed.split(/\s+/);
    const local = fields[3];
    if (!local) continue;

    const separator = local.lastIndexOf(':');
    if (separator === -1) continue;

    const address = local.slice(0, separator).replace(/^\[|\]$/g, '');
    const port = Number.parseInt(local.slice(separator + 1), 10);
    if (!Number.isInteger(port) || !LOOPBACK_SS_ADDRESSES.has(address)) continue;

    const processField = fields.slice(5).join(' ');
    const pids = [...processField.matchAll(/pid=(\d+)/g)].map((match) =>
      Number.parseInt(match[1], 10),
    );
    const nameMatch = /users:\(\("([^"]+)"/.exec(processField);

    entries.push({ address, port, pids, processName: nameMatch?.[1] ?? null });
  }

  return entries;
}

type ProcListener = {
  address: string;
  port: number;
  inode: string;
};

/**
 * Reads one /proc/net/tcp{,6} table and returns the LISTEN rows bound to a
 * loopback or wildcard address, tagged with the owning socket inode.
 */
function readProcNetTable(filePath: string, isIpv6: boolean): ProcListener[] {
  let content: string;
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch {
    return [];
  }

  const listeners: ProcListener[] = [];
  for (const line of content.split('\n').slice(1)) {
    const fields = line.trim().split(/\s+/);
    if (fields.length < 10) continue;

    const [, localAddress, , state] = fields;
    const inode = fields[9];
    // 0A == TCP_LISTEN; socket inode identifies the owning process fd.
    if (state !== '0A' || !inode || inode === '0') continue;

    const [hexAddress, hexPort] = localAddress.split(':');
    if (!hexAddress || !hexPort) continue;

    const port = Number.parseInt(hexPort, 16);
    if (!Number.isInteger(port)) continue;

    const address = isIpv6
      ? parseProcIpv6(hexAddress)
      : parseProcIpv4(hexAddress);
    if (address === null) continue;

    listeners.push({ address, port, inode });
  }

  return listeners;
}

/** /proc/net/tcp stores IPv4 addresses little-endian: 0100007F -> 127.0.0.1. */
function parseProcIpv4(hexAddress: string): string | null {
  if (hexAddress === '00000000') return '0.0.0.0';
  // Any 127/8 address is loopback; the high byte sits last in LE hex.
  if (hexAddress.slice(6) === '7F') {
    return [
      Number.parseInt(hexAddress.slice(6, 8), 16),
      Number.parseInt(hexAddress.slice(4, 6), 16),
      Number.parseInt(hexAddress.slice(2, 4), 16),
      Number.parseInt(hexAddress.slice(0, 2), 16),
    ].join('.');
  }
  return null;
}

/**
 * /proc/net/tcp6 stores IPv6 addresses as four little-endian u32 words.
 * Only the wildcard and ::1 matter for preview discovery.
 */
function parseProcIpv6(hexAddress: string): string | null {
  if (hexAddress === '0'.repeat(32)) return '::';
  // ::1 is the single byte 0x01 in the last u32 -> LE hex suffix "01000000".
  if (hexAddress === '0'.repeat(24) + '01000000') return '::1';
  return null;
}

/**
 * Resolves socket inodes to owning pids by scanning /proc/<pid>/fd symlinks.
 * Stops early once every inode has an owner so large proc scans stay bounded.
 */
function mapInodesToPids(procRoot: string, inodes: ReadonlySet<string>): Map<string, number> {
  const owners = new Map<string, number>();
  if (inodes.size === 0) return owners;

  let pids: string[];
  try {
    pids = fs.readdirSync(procRoot).filter((name) => /^\d+$/.test(name));
  } catch {
    return owners;
  }

  for (const pid of pids) {
    if (owners.size === inodes.size) break;
    const fdDir = path.join(procRoot, pid, 'fd');
    let fds: string[];
    try {
      fds = fs.readdirSync(fdDir);
    } catch {
      continue; // process exited or is owned by another uid
    }
    for (const fd of fds) {
      let target: string;
      try {
        target = fs.readlinkSync(path.join(fdDir, fd));
      } catch {
        continue;
      }
      const match = /^socket:\[(\d+)\]$/.exec(target);
      if (match && inodes.has(match[1]) && !owners.has(match[1])) {
        owners.set(match[1], Number.parseInt(pid, 10));
      }
    }
    if (owners.size === inodes.size) break;
  }

  return owners;
}

function readProcessInfo(
  procRoot: string,
  pid: number,
): { processName: string | null; cwd: string | null } {
  let processName: string | null = null;
  let cwd: string | null = null;
  try {
    processName = fs.readFileSync(path.join(procRoot, String(pid), 'comm'), 'utf8').trim() || null;
  } catch {
    // process gone or not ours — keep null
  }
  try {
    cwd = fs.readlinkSync(path.join(procRoot, String(pid), 'cwd'));
  } catch {
    // same — unreadable cwd just means we can't attribute the port
  }
  return { processName, cwd };
}

function resolvePath(candidate: string): string {
  try {
    return fs.realpathSync(candidate);
  } catch {
    return path.resolve(candidate);
  }
}

function isInsideDirectory(candidate: string, directory: string): boolean {
  const resolvedCandidate = resolvePath(candidate);
  const resolvedDirectory = resolvePath(directory);
  return (
    resolvedCandidate === resolvedDirectory ||
    resolvedCandidate.startsWith(resolvedDirectory + path.sep)
  );
}

/**
 * Port discovery for the preview proxy.
 *
 * Consumed by the preview router (GET /ports) which serves the detected
 * dev-server candidates to the PreviewPane dropdown.
 */
export function createPortDiscoveryService(dependencies: PortDiscoveryDependencies = {}) {
  const runSs = dependencies.runSs ?? runSsCommand;
  const procRoot = dependencies.procRoot ?? '/proc';
  const now = dependencies.now ?? Date.now;
  const cacheTtlMs = dependencies.cacheTtlMs ?? DEFAULT_CACHE_TTL_MS;

  const cache = new Map<string, { at: number; ports: ListeningPort[] }>();
  const inflight = new Map<string, Promise<ListeningPort[]>>();

  // ss needs root to see other users' processes; when it is missing or returns
  // nothing usable the /proc scan is the equivalent fallback.
  const listAll = async (): Promise<ListeningPort[]> => {
    const byPort = new Map<number, ListeningPort>();

    const ssOutput = await runSs();
    if (ssOutput !== null) {
      for (const entry of parseSsOutput(ssOutput)) {
        const pid = entry.pids[0] ?? null;
        const info = pid === null
          ? { processName: null, cwd: null }
          : readProcessInfo(procRoot, pid);
        const key = entry.port;
        const candidate: ListeningPort = {
          port: entry.port,
          address: entry.address,
          pid,
          processName: entry.processName ?? info.processName,
          cwd: info.cwd,
        };
        const existing = byPort.get(key);
        // Prefer rows that carry process info over bare wildcard rows.
        if (!existing || (existing.pid === null && candidate.pid !== null)) {
          byPort.set(key, candidate);
        }
      }
      if (byPort.size > 0) {
        return [...byPort.values()].sort((a, b) => a.port - b.port);
      }
    }

    // Fallback: parse /proc directly (no ss, or ss lacked permissions).
    const listeners = [
      ...readProcNetTable(path.join(procRoot, 'net', 'tcp'), false),
      ...readProcNetTable(path.join(procRoot, 'net', 'tcp6'), true),
    ];
    const inodes = new Set(listeners.map((listener) => listener.inode));
    const owners = mapInodesToPids(procRoot, inodes);
    for (const listener of listeners) {
      const pid = owners.get(listener.inode) ?? null;
      const info = pid === null ? { processName: null, cwd: null } : readProcessInfo(procRoot, pid);
      const candidate: ListeningPort = {
        port: listener.port,
        address: listener.address,
        pid,
        processName: info.processName,
        cwd: info.cwd,
      };
      const existing = byPort.get(listener.port);
      if (!existing || (existing.pid === null && candidate.pid !== null)) {
        byPort.set(listener.port, candidate);
      }
    }

    return [...byPort.values()].sort((a, b) => a.port - b.port);
  };

  return {
    /**
     * Lists localhost TCP listeners, optionally restricted to processes whose
     * cwd sits inside `projectPath`. Results are cached for ~2s so a polling
     * pane does not rescan /proc on every tick.
     */
    async listListeningPorts(projectPath?: string): Promise<ListeningPort[]> {
      const cacheKey = projectPath ?? '';
      const cached = cache.get(cacheKey);
      if (cached && now() - cached.at < cacheTtlMs) {
        return cached.ports;
      }

      const pending = inflight.get(cacheKey);
      if (pending) return pending;

      const scan = listAll()
        .then((ports) => {
          const filtered = projectPath
            ? ports.filter((port) => port.cwd !== null && isInsideDirectory(port.cwd, projectPath))
            : ports;
          cache.set(cacheKey, { at: now(), ports: filtered });
          return filtered;
        })
        .finally(() => {
          inflight.delete(cacheKey);
        });
      inflight.set(cacheKey, scan);
      return scan;
    },
  };
}
