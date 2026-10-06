import { execFile } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

import { selfPreviewPort } from './preview-proxy.service.js';

/**
 * One TCP listener bound to a loopback/wildcard address owned by a local
 * process — a dev-server candidate for the preview proxy. Consumed by
 * preview.routes.ts (GET /ports response) and the PreviewPane dropdown.
 */
export type ListeningPort = {
  port: number;
  /** Local address the socket is bound to (e.g. 127.0.0.1, ::, 0.0.0.0). */
  address: string;
  pid: number | null;
  processName: string | null;
  /** Process working directory — used to attribute ports to a project. */
  cwd: string | null;
  /**
   * Full command line (Windows only — there is no userspace API for another
   * process's cwd, so attribution there matches the project path inside the
   * command line instead). Null elsewhere.
   */
  commandLine?: string | null;
};

type SsEntry = {
  address: string;
  port: number;
  pids: number[];
  processName: string | null;
};

/**
 * Injectable seams for the port-discovery service. Consumed by
 * createPortDiscoveryService callers — tests feed a fixture `runSs` and a
 * synthetic `procRoot`; production defaults hit the real system.
 */
export type PortDiscoveryDependencies = {
  /** Returns `ss -tlnp` stdout, or null when ss is unavailable/failed. */
  runSs?: () => Promise<string | null>;
  /** Root of the proc filesystem — overridden in tests with a fake tree. */
  procRoot?: string;
  now?: () => number;
  cacheTtlMs?: number;
  /** PID of the ddagent server itself — its listeners are never preview targets. */
  selfPid?: number;
  /** ddagent's own listen port — excluded even when the owning pid is unreadable. */
  selfPort?: number;
  /** Platform override for tests ('linux' | 'win32' | 'darwin'). */
  platform?: NodeJS.Platform;
  /** Returns `netstat -ano -p tcp` stdout on Windows. */
  runNetstat?: () => Promise<string | null>;
  /** Resolves pid -> {name, commandLine} on Windows (one PowerShell batch). */
  runWinProcessInfo?: (pids: number[]) => Promise<Map<number, WinProcessInfo>>;
  /** Returns `lsof -nP -iTCP -sTCP:LISTEN` stdout on macOS. */
  runLsof?: () => Promise<string | null>;
  /** Resolves pid -> cwd on macOS (`lsof -d cwd`). */
  runLsofCwd?: (pids: number[]) => Promise<Map<number, string>>;
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

function runCommand(file: string, args: string[], timeout = 5000): Promise<string | null> {
  return new Promise((resolve) => {
    execFile(file, args, { timeout }, (error, stdout) => {
      resolve(error ? null : stdout);
    });
  });
}

function runSsCommand(): Promise<string | null> {
  return runCommand('ss', ['-tlnp']);
}

// --------------------------- Windows (netstat + Get-CimInstance) ---------------------------

type WinProcessInfo = {
  name: string | null;
  commandLine: string | null;
};

/** `netstat -ano -p tcp` — LISTENING rows carry the owning PID, no admin needed. */
function runNetstatCommand(): Promise<string | null> {
  return runCommand('netstat', ['-ano', '-p', 'tcp']);
}

/**
 * One PowerShell batch resolving name + command line for every discovered
 * PID. CommandLine is the cwd surrogate on Windows — there is no documented
 * userspace API for another process's working directory, so project
 * attribution matches the project path inside the command line instead.
 */
async function runWinProcessInfoCommand(pids: number[]): Promise<Map<number, WinProcessInfo>> {
  const out = new Map<number, WinProcessInfo>();
  if (pids.length === 0) return out;
  const filter = pids.map((pid) => `ProcessId=${pid}`).join(' OR ');
  const stdout = await runCommand(
    'powershell.exe',
    [
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      `Get-CimInstance Win32_Process -Filter "${filter}" | Select-Object -Property ProcessId,Name,CommandLine | ConvertTo-Json -Compress`,
    ],
    10000,
  );
  if (stdout === null) return out;
  try {
    const parsed: unknown = JSON.parse(stdout);
    const rows = (Array.isArray(parsed) ? parsed : [parsed]) as Array<Record<string, unknown>>;
    for (const row of rows) {
      const pid = typeof row?.ProcessId === 'number' ? row.ProcessId : null;
      if (pid === null) continue;
      out.set(pid, {
        name: typeof row.Name === 'string' ? row.Name : null,
        commandLine: typeof row.CommandLine === 'string' ? row.CommandLine : null,
      });
    }
  } catch {
    // malformed output — leave names/cmdlines null
  }
  return out;
}

/** Parses `netstat -ano -p tcp`: `TCP  <local>  <foreign>  LISTENING  <pid>`. */
function parseNetstatOutput(output: string): Array<{ address: string; port: number; pid: number }> {
  const entries: Array<{ address: string; port: number; pid: number }> = [];
  for (const line of output.split('\n')) {
    const fields = line.trim().split(/\s+/);
    if (fields.length < 5 || fields[0] !== 'TCP' || fields[3] !== 'LISTENING') continue;
    const local = fields[1];
    const separator = local.lastIndexOf(':');
    if (separator === -1) continue;
    const address = local.slice(0, separator).replace(/^\[|\]$/g, '');
    const port = Number.parseInt(local.slice(separator + 1), 10);
    const pid = Number.parseInt(fields[4], 10);
    if (!Number.isInteger(port) || !Number.isInteger(pid)) continue;
    if (!LOOPBACK_SS_ADDRESSES.has(address)) continue;
    entries.push({ address, port, pid });
  }
  return entries;
}

// --------------------------- macOS (lsof) ---------------------------

function runLsofCommand(): Promise<string | null> {
  return runCommand('lsof', ['-nP', '-iTCP', '-sTCP:LISTEN']);
}

/**
 * `lsof -a -d cwd -Fn -p <pids>` — field output gives one `n/path` row per
 * `p<pid>` row, so a single call resolves every cwd at once.
 */
async function runLsofCwdCommand(pids: number[]): Promise<Map<number, string>> {
  const out = new Map<number, string>();
  if (pids.length === 0) return out;
  const stdout = await runCommand('lsof', ['-a', '-d', 'cwd', '-Fn', '-p', pids.join(',')]);
  if (stdout === null) return out;
  let pid: number | null = null;
  for (const line of stdout.split('\n')) {
    if (line.startsWith('p')) {
      pid = Number.parseInt(line.slice(1), 10);
      if (!Number.isInteger(pid)) pid = null;
    } else if (pid !== null && line.startsWith('n')) {
      out.set(pid, line.slice(1));
    }
  }
  return out;
}

/**
 * Parses `lsof -nP -iTCP -sTCP:LISTEN` rows:
 * `node  123 user  20u IPv4 ... TCP 127.0.0.1:3000 (LISTEN)`.
 */
function parseLsofOutput(output: string): Array<{ address: string; port: number; pid: number; name: string | null }> {
  const entries: Array<{ address: string; port: number; pid: number; name: string | null }> = [];
  for (const line of output.split('\n')) {
    const fields = line.trim().split(/\s+/);
    if (fields.length < 9 || !line.includes('(LISTEN)')) continue;
    const pid = Number.parseInt(fields[1], 10);
    const nameField = fields[fields.length - 2]; // last is "(LISTEN)"
    const separator = nameField?.lastIndexOf(':') ?? -1;
    if (!Number.isInteger(pid) || separator === -1) continue;
    const address = nameField!.slice(0, separator);
    const port = Number.parseInt(nameField!.slice(separator + 1), 10);
    if (!Number.isInteger(port) || !LOOPBACK_SS_ADDRESSES.has(address)) continue;
    entries.push({ address, port, pid, name: fields[0] || null });
  }
  return entries;
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
  const platform = dependencies.platform ?? process.platform;
  const runSs = dependencies.runSs ?? runSsCommand;
  const runNetstat = dependencies.runNetstat ?? runNetstatCommand;
  const runWinProcessInfo = dependencies.runWinProcessInfo ?? runWinProcessInfoCommand;
  const runLsof = dependencies.runLsof ?? runLsofCommand;
  const runLsofCwd = dependencies.runLsofCwd ?? runLsofCwdCommand;
  const procRoot = dependencies.procRoot ?? '/proc';
  const now = dependencies.now ?? Date.now;
  const cacheTtlMs = dependencies.cacheTtlMs ?? DEFAULT_CACHE_TTL_MS;
  const selfPid = dependencies.selfPid ?? process.pid;
  const selfPort = dependencies.selfPort ?? selfPreviewPort();

  const cache = new Map<string, { at: number; ports: ListeningPort[] }>();
  const inflight = new Map<string, Promise<ListeningPort[]>>();

  // Windows: netstat -ano carries the pid; a single PowerShell batch adds
  // name + command line (cwd surrogate — see ListeningPort.commandLine).
  const listWindows = async (): Promise<ListeningPort[]> => {
    const output = await runNetstat();
    if (output === null) return [];
    const rows = parseNetstatOutput(output);
    const infos = await runWinProcessInfo([...new Set(rows.map((row) => row.pid))]);
    const byPort = new Map<number, ListeningPort>();
    for (const row of rows) {
      const info = infos.get(row.pid);
      const existing = byPort.get(row.port);
      if (!existing || (existing.pid === null && row.pid !== null)) {
        byPort.set(row.port, {
          port: row.port,
          address: row.address,
          pid: row.pid,
          processName: info?.name ?? null,
          cwd: null,
          commandLine: info?.commandLine ?? null,
        });
      }
    }
    return [...byPort.values()].sort((a, b) => a.port - b.port);
  };

  // macOS: lsof lists listeners with pid+name, a second batched call resolves
  // each pid's cwd (real cwd — needed for project attribution).
  const listDarwin = async (): Promise<ListeningPort[]> => {
    const output = await runLsof();
    if (output === null) return [];
    const rows = parseLsofOutput(output);
    const cwds = await runLsofCwd([...new Set(rows.map((row) => row.pid))]);
    const byPort = new Map<number, ListeningPort>();
    for (const row of rows) {
      const existing = byPort.get(row.port);
      if (!existing || existing.cwd === null) {
        byPort.set(row.port, {
          port: row.port,
          address: row.address,
          pid: row.pid,
          processName: row.name,
          cwd: cwds.get(row.pid) ?? null,
        });
      }
    }
    return [...byPort.values()].sort((a, b) => a.port - b.port);
  };

  // Linux: ss needs root to see other users' processes; when it is missing or
  // returns nothing usable the /proc scan is the equivalent fallback.
  const listLinux = async (): Promise<ListeningPort[]> => {
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

  const listAll = (): Promise<ListeningPort[]> =>
    platform === 'win32' ? listWindows() : platform === 'darwin' ? listDarwin() : listLinux();

  /**
   * Project attribution: on POSIX the process cwd must sit inside the project.
   * On Windows cwd is unreadable for other processes — the command line is the
   * documented surrogate, matched path-insensitively against the project dir.
   */
  const belongsToProject = (port: ListeningPort, projectPath: string): boolean => {
    if (port.cwd !== null) return isInsideDirectory(port.cwd, projectPath);
    if (platform === 'win32' && port.commandLine) {
      const norm = (value: string) => value.replace(/\\/g, '/').toLowerCase();
      const project = norm(path.win32.normalize(projectPath)).replace(/\/+$/, '');
      return norm(port.commandLine).includes(project);
    }
    return false;
  };

  return {
    /**
     * Lists localhost TCP listeners owned by processes whose cwd sits inside
     * `projectPath` — empty without one. ddagent's own pid/port are always
     * excluded. Results are cached for ~2s so a polling
     * pane does not rescan /proc on every tick.
     */
    async listListeningPorts(projectPath?: string): Promise<ListeningPort[]> {
      // No active project → no scan: a system-wide list would surface ddagent's
      // own port (and every other daemon) as a preview target.
      if (!projectPath) return [];
      const cacheKey = projectPath;
      const cached = cache.get(cacheKey);
      if (cached && now() - cached.at < cacheTtlMs) {
        return cached.ports;
      }

      const pending = inflight.get(cacheKey);
      if (pending) return pending;

      const scan = listAll()
        .then((ports) => {
          const filtered = ports.filter(
            (port) =>
              port.pid !== selfPid &&
              port.port !== selfPort &&
              belongsToProject(port, projectPath),
          );
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
