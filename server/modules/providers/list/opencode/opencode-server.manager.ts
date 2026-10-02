import type { ChildProcess } from 'node:child_process';
import path from 'node:path';

// cross-spawn resolves .cmd shims/PATHEXT on Windows — plain node spawn
// cannot exec npm's `opencode.cmd` and dies with ENOENT.
import crossSpawn from 'cross-spawn';

import { providerChildEnv } from '@/shared/utils.js';

/**
 * Handle for one running `opencode serve` process bound to a project
 * directory. `baseUrl` is the loopback HTTP endpoint the runtime adapter uses
 * for prompts, events and permission replies.
 */
export type OpenCodeServerHandle = {
  baseUrl: string;
  directory: string;
  /** Null when the handle came from the OPENCODE_SERVE_BASE_URL test seam. */
  child: ChildProcess | null;
};

type ServerEntry = {
  handle: OpenCodeServerHandle | null;
  pending: Promise<OpenCodeServerHandle> | null;
};

// Consumed by the OpenCode runtime adapter (opencode-runtime.provider.ts) so
// every run for a project directory shares one long-lived serve process —
// the HTTP API is what makes mid-response permission replies possible.
const servers = new Map<string, ServerEntry>();

const LISTENING_PATTERN = /listening on (https?:\/\/[^\s]+)/i;
const STARTUP_TIMEOUT_MS = 15000;
const HEALTH_TIMEOUT_MS = 2000;
/**
 * One slow `/config` does not mean a dead server — a serve instance busy with
 * several turns can stall its HTTP loop well past HEALTH_TIMEOUT_MS. Dropping
 * it on a single probe SIGTERMs a healthy process and kills every in-flight
 * run, so the check repeats a few times before the server is condemned. A
 * confirmed-dead child (exitCode set) skips the wait entirely.
 */
const HEALTH_CHECK_ATTEMPTS = 4;
const HEALTH_CHECK_DELAY_MS = 2000;
const KILL_GRACE_MS = 5000;
/** Bytes of child stdout/stderr retained for the exit log line. */
const CHILD_LOG_TAIL_BYTES = 8192;

function resolveDirectory(directory: string): string {
  return path.resolve(directory || process.cwd());
}

function waitForListenUrl(child: ChildProcess, directory: string): Promise<OpenCodeServerHandle> {
  return new Promise((resolve, reject) => {
    let buffer = '';
    let settled = false;

    const finish = (error: Error | null, handle?: OpenCodeServerHandle) => {
      if (settled) {
        return;
      }
      settled = true;
      clearTimeout(timer);
      if (error) {
        reject(error);
        return;
      }
      // Startup output is no longer needed — swapping the accumulator for a
      // capped tail keeps the pipes drained (a full pipe would wedge the
      // child) without growing `buffer` forever, and preserves the last bytes
      // for the exit log so a silent serve death stays diagnosable.
      child.stdout?.off('data', onData);
      child.stderr?.off('data', onData);
      let tail = '';
      const keepTail = (chunk: Buffer) => {
        tail = (tail + chunk.toString()).slice(-CHILD_LOG_TAIL_BYTES);
      };
      child.stdout?.on('data', keepTail);
      child.stderr?.on('data', keepTail);
      child.once('exit', (code, signal) => {
        const tailInfo = tail.trim() ? ` — output tail: ${JSON.stringify(tail.slice(-1000))}` : '';
        console.warn(`[OpenCode] serve process exited (code=${code} signal=${signal})${tailInfo}`);
      });
      resolve(handle as OpenCodeServerHandle);
    };

    const timer = setTimeout(() => {
      finish(new Error(`opencode serve did not report a listening address within ${STARTUP_TIMEOUT_MS}ms`));
    }, STARTUP_TIMEOUT_MS);
    // The startup wait must not hold the event loop open on its own.
    timer.unref?.();

    const onData = (chunk: Buffer) => {
      buffer += chunk.toString();
      const match = buffer.match(LISTENING_PATTERN);
      if (match) {
        finish(null, { baseUrl: match[1].replace(/\/+$/, ''), directory, child });
      }
    };

    child.stdout?.on('data', onData);
    child.stderr?.on('data', onData);
    child.once('error', (error) => finish(error));
    child.once('exit', (code) => {
      finish(new Error(`opencode serve exited with code ${code} before listening`));
    });
  });
}

async function isServerHealthy(baseUrl: string): Promise<boolean> {
  try {
    const response = await fetch(`${baseUrl}/config`, {
      signal: AbortSignal.timeout(HEALTH_TIMEOUT_MS),
    });
    return response.ok;
  } catch {
    return false;
  }
}

/**
 * Repeated health check for a cached server. Gives a busy-but-alive process
 * several spaced probes (~14s worst case); a child that has actually exited
 * fails immediately instead of burning the grace window.
 */
async function waitForHealthy(baseUrl: string, child: ChildProcess | null): Promise<boolean> {
  for (let attempt = 0; attempt < HEALTH_CHECK_ATTEMPTS; attempt++) {
    if (await isServerHealthy(baseUrl)) {
      return true;
    }
    if (child !== null && (child.exitCode !== null || child.killed)) {
      return false;
    }
    if (attempt + 1 < HEALTH_CHECK_ATTEMPTS) {
      await new Promise((resolve) => setTimeout(resolve, HEALTH_CHECK_DELAY_MS));
    }
  }
  return false;
}

function killChild(child: ChildProcess | null): void {
  if (!child || child.killed || child.exitCode !== null) {
    return;
  }
  child.kill('SIGTERM');
  const killer = setTimeout(() => {
    if (child.exitCode === null) {
      child.kill('SIGKILL');
    }
  }, KILL_GRACE_MS);
  killer.unref?.();
}

function dropEntry(serverKey: string, entry: ServerEntry): void {
  if (servers.get(serverKey) === entry) {
    servers.delete(serverKey);
  }
  if (entry.handle) {
    killChild(entry.handle.child);
  }
}

/**
 * Map key for one serve instance: project directory + account environment.
 * Two accounts sharing a project each get their own server process (and their
 * own credentials), while runs on the same account reuse the cached one.
 * Exported for the multi-account provider matrix tests.
 */
export function serverKeyFor(directory: string, envOverrides?: Record<string, string>): string {
  const resolved = resolveDirectory(directory);
  if (!envOverrides || Object.keys(envOverrides).length === 0) {
    return resolved;
  }
  const stable = Object.keys(envOverrides)
    .sort()
    .map((key) => `${key}=${envOverrides[key]}`)
    .join('\n');
  return `${resolved}\n${stable}`;
}

/**
 * Returns a live `opencode serve` instance for the project directory,
 * spawning one on first use. Concurrent callers share the spawn. A cached
 * handle that fails a health check is killed and respawned transparently.
 *
 * `OPENCODE_SERVE_BASE_URL` short-circuits spawning entirely — a test seam
 * for pointing the runtime at a stub server.
 */
export async function ensureServer(
  directory: string,
  envOverrides?: Record<string, string>,
): Promise<OpenCodeServerHandle> {
  const resolved = resolveDirectory(directory);
  const override = process.env.OPENCODE_SERVE_BASE_URL;
  if (override) {
    return { baseUrl: override.replace(/\/+$/, ''), directory: resolved, child: null };
  }

  const serverKey = serverKeyFor(directory, envOverrides);
  const existing = servers.get(serverKey);
  if (existing?.pending) {
    return existing.pending;
  }

  // The health check and the respawn run inside the serialized `pending` —
  // two concurrent callers both reading "unhealthy" must share one verdict
  // and one respawn, otherwise each spawns a child and the loser leaks
  // untracked (disposeAllServers only knows mapped entries).
  const entry: ServerEntry = { handle: existing?.handle ?? null, pending: null };
  servers.set(serverKey, entry);

  const pending = (async () => {
    try {
      if (entry.handle) {
        const oldChild = entry.handle.child;
        const dead = oldChild !== null && (oldChild.exitCode !== null || oldChild.killed);
        if (!dead && await waitForHealthy(entry.handle.baseUrl, oldChild)) {
          return entry.handle;
        }
        // Detach before SIGTERM: the exit handler must not drop this entry
        // out from under the respawn below.
        entry.handle = null;
        killChild(oldChild);
      }

      const child = crossSpawn('opencode', ['serve', '--port', '0', '--hostname', '127.0.0.1'], {
        cwd: resolved,
        stdio: ['ignore', 'pipe', 'pipe'],
        // Multi-account: env overrides (e.g. XDG_CONFIG_HOME/opencode config dir)
        // isolate this server instance's credentials from other accounts.
        env: providerChildEnv(envOverrides ?? {}),
      });
      try {
        const handle = await waitForListenUrl(child, resolved);
        // The old child's exit handler may have dropped the entry while the
        // health check was in flight — make sure the respawn is mapped.
        servers.set(serverKey, entry);
        entry.handle = handle;
        child.once('exit', () => {
          if (entry.handle === handle) {
            entry.handle = null;
            dropEntry(serverKey, entry);
          }
        });
        return handle;
      } catch (error) {
        killChild(child);
        dropEntry(serverKey, entry);
        throw error;
      }
    } finally {
      entry.pending = null;
    }
  })();

  entry.pending = pending;
  return pending;
}

/**
 * Test seam: injects a prepared handle so server-replacement paths
 * (stream failover) can run without spawning a real `opencode`.
 */
export function setServerForTest(directory: string, handle: OpenCodeServerHandle): void {
  servers.set(serverKeyFor(directory), { handle, pending: null });
}

/**
 * Test seam: the currently tracked handle for a directory, if any.
 */
export function getServer(
  directory: string,
  envOverrides?: Record<string, string>,
): OpenCodeServerHandle | undefined {
  return servers.get(serverKeyFor(directory, envOverrides))?.handle ?? undefined;
}

/** Test seam: drops the cached map so each test starts with no servers. */
export function resetServersForTest(): void {
  servers.clear();
}

/**
 * Kills every tracked serve process. Called on app shutdown and by tests.
 */
export function disposeAllServers(): void {
  for (const [directory, entry] of Array.from(servers.entries())) {
    dropEntry(directory, entry);
  }
}

process.once('exit', disposeAllServers);
