import { spawn, type ChildProcess } from 'node:child_process';
import path from 'node:path';

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
const KILL_GRACE_MS = 5000;

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

function dropEntry(directory: string, entry: ServerEntry): void {
  if (servers.get(directory) === entry) {
    servers.delete(directory);
  }
  if (entry.handle) {
    killChild(entry.handle.child);
  }
}

/**
 * Returns a live `opencode serve` instance for the project directory,
 * spawning one on first use. Concurrent callers share the spawn. A cached
 * handle that fails a health check is killed and respawned transparently.
 *
 * `OPENCODE_SERVE_BASE_URL` short-circuits spawning entirely — a test seam
 * for pointing the runtime at a stub server.
 */
export async function ensureServer(directory: string): Promise<OpenCodeServerHandle> {
  const resolved = resolveDirectory(directory);
  const override = process.env.OPENCODE_SERVE_BASE_URL;
  if (override) {
    return { baseUrl: override.replace(/\/+$/, ''), directory: resolved, child: null };
  }

  const existing = servers.get(resolved);

  if (existing?.handle) {
    if (await isServerHealthy(existing.handle.baseUrl)) {
      return existing.handle;
    }
    dropEntry(resolved, existing);
  } else if (existing?.pending) {
    return existing.pending;
  }

  const entry: ServerEntry = { handle: null, pending: null };
  servers.set(resolved, entry);

  const pending = (async () => {
    const child = spawn('opencode', ['serve', '--port', '0', '--hostname', '127.0.0.1'], {
      cwd: resolved,
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    try {
      const handle = await waitForListenUrl(child, resolved);
      entry.handle = handle;
      child.once('exit', () => {
        if (entry.handle === handle) {
          entry.handle = null;
        }
        dropEntry(resolved, entry);
      });
      return handle;
    } catch (error) {
      killChild(child);
      dropEntry(resolved, entry);
      throw error;
    } finally {
      entry.pending = null;
    }
  })();

  entry.pending = pending;
  return pending;
}

/**
 * Test seam: the currently tracked handle for a directory, if any.
 */
export function getServer(directory: string): OpenCodeServerHandle | undefined {
  return servers.get(resolveDirectory(directory))?.handle ?? undefined;
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
