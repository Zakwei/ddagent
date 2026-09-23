import type {
  GitCommandRunner,
  WorktreeProcessRunner,
  WorktreeRunRuntime,
  WorktreeRuntimeInfo,
  WorktreeScriptProcess,
  WorktreeScriptSpawner,
  WorktreeScriptStatusInput,
  WorktreeScriptStatusResult,
  WorktreeScriptsConfigResult,
  WorktreeSetupRuntime,
} from '@/shared/types.js';
import { AppError, normalizeProjectPath } from '@/shared/utils.js';
import {
  listWorktreePathsOrSelf,
  resolveRepositoryRoot,
} from '@/modules/worktrees/services/worktree-git.service.js';

// ANSI escapes end up in pty output; strip them so the log tail and the port
// parser see plain text. (A copy of the shell module's regex lives in
// websocket internals which this module must not deep-import.)
const ANSI_ESCAPE_SEQUENCE_REGEX = /\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~]|\][^\x07]*(?:\x07|\x1B\\))/g;

/** Retained output per script execution — enough to diagnose failures. */
const LOG_BUFFER_LIMIT = 64 * 1024;
/** Lines surfaced to the UI as `logTail` (the spec asks for ~50). */
const LOG_TAIL_LINES = 50;
/** Setup scripts get ten minutes before they are killed (e.g. `npm install`). */
const DEFAULT_SETUP_TIMEOUT_MS = 10 * 60 * 1000;
/** Grace between SIGTERM and SIGKILL when stopping a run process. */
const DEFAULT_KILL_GRACE_MS = 1500;

const LOCAL_URL_REGEX =
  /https?:\/\/(?:localhost|127\.0\.0\.1|0\.0\.0\.0|\[::1\])(?::(\d{1,5}))?(\/[^\s'"<>)\]]*)?/i;
const LOCAL_PORT_REGEX = /(?:localhost|127\.0\.0\.1|0\.0\.0\.0|\[::1\]):(\d{1,5})/i;

type SetupEntry = {
  status: WorktreeSetupRuntime['status'];
  exitCode: number | null;
  startedAt: string | null;
  finishedAt: string | null;
  log: string;
  process: WorktreeScriptProcess | null;
  timeoutId: NodeJS.Timeout | null;
};

type RunEntry = {
  status: WorktreeRunRuntime['status'];
  exitCode: number | null;
  port: number | null;
  url: string | null;
  startedAt: string | null;
  finishedAt: string | null;
  log: string;
  process: WorktreeScriptProcess | null;
  killTimer: NodeJS.Timeout | null;
};

function stripAnsi(value: string): string {
  return value.replace(ANSI_ESCAPE_SEQUENCE_REGEX, '');
}

function appendLog(entry: { log: string }, chunk: string): void {
  entry.log = (entry.log + chunk).slice(-LOG_BUFFER_LIMIT);
}

function logTail(log: string): string[] {
  const lines = stripAnsi(log).split(/\r?\n/).map((line) => line.trimEnd());
  while (lines.length > 0 && lines[lines.length - 1] === '') {
    lines.pop();
  }
  return lines.slice(-LOG_TAIL_LINES);
}

/**
 * Kills a spawned script's whole process tree.
 *
 * The runner requires spawned processes to be session/process-group leaders
 * on POSIX (node-pty children are), so `kill(-pid)` reaches grandchildren like
 * `npm run dev` → `vite`. Windows ptys and fakes fall back to `proc.kill()`.
 */
function terminateProcessTree(proc: WorktreeScriptProcess, signal: 'SIGTERM' | 'SIGKILL'): void {
  if (process.platform !== 'win32' && proc.pid > 0) {
    try {
      process.kill(-proc.pid, signal);
      return;
    } catch {
      // Group kill failed (already dead, or not a group leader) — kill directly.
    }
  }

  try {
    proc.kill(signal);
  } catch {
    // Already exited.
  }
}

function idleSetupRuntime(): WorktreeSetupRuntime {
  return { status: 'idle', exitCode: null, startedAt: null, finishedAt: null, logTail: [] };
}

function idleRunRuntime(): WorktreeRunRuntime {
  return {
    status: 'idle',
    exitCode: null,
    port: null,
    url: null,
    startedAt: null,
    finishedAt: null,
    logTail: [],
  };
}

function snapshotSetup(entry: SetupEntry | undefined): WorktreeSetupRuntime {
  if (!entry) {
    return idleSetupRuntime();
  }
  return {
    status: entry.status,
    exitCode: entry.exitCode,
    startedAt: entry.startedAt,
    finishedAt: entry.finishedAt,
    logTail: logTail(entry.log),
  };
}

function snapshotRun(entry: RunEntry | undefined): WorktreeRunRuntime {
  if (!entry) {
    return idleRunRuntime();
  }
  return {
    status: entry.status,
    exitCode: entry.exitCode,
    port: entry.port,
    url: entry.url,
    startedAt: entry.startedAt,
    finishedAt: entry.finishedAt,
    logTail: logTail(entry.log),
  };
}

/**
 * Best-effort dev-server target detection from script output.
 *
 * Prefers a full `http(s)://localhost:PORT`-style URL (keeps the path too,
 * e.g. Vite's `http://localhost:5173/`); otherwise falls back to a bare
 * `localhost:PORT` pair. Wildcard/loopback hosts are rewritten to `localhost`
 * so the hint is always a browsable URL. Only the first detection sticks —
 * later output may mention unrelated ports.
 */
function detectRunTarget(entry: RunEntry, chunk: string): void {
  if (entry.port != null) {
    return;
  }

  const clean = stripAnsi(chunk);
  const urlMatch = clean.match(LOCAL_URL_REGEX);
  if (urlMatch) {
    const port = urlMatch[1]
      ? Number.parseInt(urlMatch[1], 10)
      : urlMatch[0].startsWith('https')
        ? 443
        : 80;
    entry.port = port;
    entry.url = urlMatch[0].replace(/^(https?:\/\/)(0\.0\.0\.0|127\.0\.0\.1|\[::1\])/, '$1localhost');
    return;
  }

  const portMatch = clean.match(LOCAL_PORT_REGEX);
  if (portMatch) {
    const port = Number.parseInt(portMatch[1], 10);
    entry.port = port;
    entry.url = `http://localhost:${port}`;
  }
}

/**
 * Creates the worktree script process runner.
 *
 * Composition-root factory: the Worktrees module wires the real node-pty
 * spawner and DB/file config sources, while tests inject fakes. Process state
 * is intentionally in-memory — spawned scripts die with the server anyway.
 */
export function createWorktreeProcessRunner(dependencies: {
  spawn: WorktreeScriptSpawner;
  runGit: GitCommandRunner;
  resolveConfig(repositoryRoot: string): Promise<WorktreeScriptsConfigResult>;
  setupTimeoutMs?: number;
  killGraceMs?: number;
}): WorktreeProcessRunner {
  const setupTimeoutMs = dependencies.setupTimeoutMs ?? DEFAULT_SETUP_TIMEOUT_MS;
  const killGraceMs = dependencies.killGraceMs ?? DEFAULT_KILL_GRACE_MS;
  const setupByPath = new Map<string, SetupEntry>();
  const runByPath = new Map<string, RunEntry>();

  return {
    async startSetup({ repositoryRoot, worktreePath }) {
      const key = normalizeProjectPath(worktreePath);
      const existing = setupByPath.get(key);
      // Dedupe: create→open fires the hook twice for the same worktree, and a
      // re-open after a successful setup must not re-run `npm install`.
      // A `failed` run MAY be retried by opening the worktree again.
      if (existing && (existing.status === 'running' || existing.status === 'done')) {
        return;
      }

      // Claim synchronously so a concurrent trigger cannot double-spawn.
      const entry: SetupEntry = {
        status: 'running',
        exitCode: null,
        startedAt: new Date().toISOString(),
        finishedAt: null,
        log: '',
        process: null,
        timeoutId: null,
      };
      setupByPath.set(key, entry);

      const config = await dependencies.resolveConfig(repositoryRoot);
      if (!config.setup) {
        setupByPath.delete(key);
        return;
      }

      let proc: WorktreeScriptProcess;
      try {
        proc = dependencies.spawn(config.setup, key);
      } catch (error) {
        entry.status = 'failed';
        entry.finishedAt = new Date().toISOString();
        appendLog(entry, `Failed to spawn setup script: ${error instanceof Error ? error.message : String(error)}\n`);
        return;
      }
      entry.process = proc;

      entry.timeoutId = setTimeout(() => {
        appendLog(entry, '\n[ddagent] Setup timed out — process killed.\n');
        entry.status = 'failed';
        entry.finishedAt = new Date().toISOString();
        terminateProcessTree(proc, 'SIGKILL');
      }, setupTimeoutMs);
      entry.timeoutId.unref?.();

      proc.onData((chunk) => appendLog(entry, chunk));
      proc.onExit(({ exitCode }) => {
        if (entry.timeoutId) {
          clearTimeout(entry.timeoutId);
          entry.timeoutId = null;
        }
        entry.process = null;
        entry.exitCode = exitCode;
        // A timed-out entry is already marked failed; don't let the exit
        // event resurrect it as done.
        if (entry.status === 'running') {
          entry.status = exitCode === 0 ? 'done' : 'failed';
        }
        entry.finishedAt = entry.finishedAt ?? new Date().toISOString();
      });
    },

    async startRun({ worktreePath }) {
      const key = normalizeProjectPath(worktreePath);
      const existing = runByPath.get(key);
      if (existing && existing.status === 'running') {
        return snapshotRun(existing);
      }

      const repositoryRoot = await resolveRepositoryRoot(key, dependencies.runGit);
      const config = await dependencies.resolveConfig(repositoryRoot);
      if (!config.run) {
        throw new AppError('No run script configured for this repository', {
          code: 'WORKTREE_RUN_NOT_CONFIGURED',
          statusCode: 400,
        });
      }

      const entry: RunEntry = {
        status: 'running',
        exitCode: null,
        // A configured runPort wins over stdout parsing.
        port: config.runPort,
        url: config.runPort != null ? `http://localhost:${config.runPort}` : null,
        startedAt: new Date().toISOString(),
        finishedAt: null,
        log: '',
        process: null,
        killTimer: null,
      };
      runByPath.set(key, entry);

      try {
        entry.process = dependencies.spawn(config.run, key);
      } catch (error) {
        entry.status = 'exited';
        entry.finishedAt = new Date().toISOString();
        appendLog(entry, `Failed to spawn run script: ${error instanceof Error ? error.message : String(error)}\n`);
        return snapshotRun(entry);
      }

      entry.process.onData((chunk) => {
        appendLog(entry, chunk);
        detectRunTarget(entry, chunk);
      });
      entry.process.onExit(({ exitCode }) => {
        if (entry.killTimer) {
          clearTimeout(entry.killTimer);
          entry.killTimer = null;
        }
        entry.process = null;
        entry.status = 'exited';
        entry.exitCode = exitCode;
        entry.finishedAt = new Date().toISOString();
      });

      return snapshotRun(entry);
    },

    stopRun({ worktreePath }) {
      const key = normalizeProjectPath(worktreePath);
      const entry = runByPath.get(key);
      if (entry && entry.status === 'running' && entry.process) {
        const proc = entry.process;
        terminateProcessTree(proc, 'SIGTERM');
        entry.killTimer = setTimeout(() => {
          terminateProcessTree(proc, 'SIGKILL');
        }, killGraceMs);
        entry.killTimer.unref?.();
      }
      return snapshotRun(entry);
    },

    stopAll(worktreePath) {
      const key = normalizeProjectPath(worktreePath);

      const setupEntry = setupByPath.get(key);
      if (setupEntry) {
        if (setupEntry.timeoutId) {
          clearTimeout(setupEntry.timeoutId);
        }
        if (setupEntry.process) {
          terminateProcessTree(setupEntry.process, 'SIGKILL');
        }
        setupByPath.delete(key);
      }

      const runEntry = runByPath.get(key);
      if (runEntry) {
        if (runEntry.killTimer) {
          clearTimeout(runEntry.killTimer);
        }
        if (runEntry.process) {
          terminateProcessTree(runEntry.process, 'SIGKILL');
        }
        runByPath.delete(key);
      }
    },

    getRuntime(worktreePath) {
      const key = normalizeProjectPath(worktreePath);
      return {
        setup: snapshotSetup(setupByPath.get(key)),
        run: snapshotRun(runByPath.get(key)),
      };
    },
  };
}

/**
 * Builds the `GET /api/worktrees/status` payload: the repository's effective
 * script config plus the live setup/run state of every worktree.
 *
 * Works for non-git project paths too — `listWorktreePathsOrSelf` degrades to
 * the project itself, so a plain folder can still report a running script.
 */
export async function getWorktreeScriptStatus(
  input: WorktreeScriptStatusInput,
  dependencies: {
    runGit: GitCommandRunner;
    runner: WorktreeProcessRunner;
    resolveConfig(repositoryRoot: string): Promise<WorktreeScriptsConfigResult>;
  },
): Promise<WorktreeScriptStatusResult> {
  const worktreePaths = await listWorktreePathsOrSelf(input.projectPath, dependencies.runGit);
  const repositoryRoot = worktreePaths[0];
  const scripts = await dependencies.resolveConfig(repositoryRoot);

  const runtimes: Record<string, WorktreeRuntimeInfo> = {};
  for (const worktreePath of worktreePaths) {
    runtimes[worktreePath] = dependencies.runner.getRuntime(worktreePath);
  }

  return { scripts, runtimes };
}
