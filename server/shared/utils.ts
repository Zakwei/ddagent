import { randomUUID } from 'node:crypto';
import fs from 'node:fs';
import { createRequire } from 'node:module';
import {
  access,
  lstat,
  mkdir,
  open,
  readFile,
  readdir,
  readlink,
  realpath,
  stat,
  writeFile,
} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import readline from 'node:readline';
import { fileURLToPath } from 'node:url';

import type { NextFunction, Request, RequestHandler, Response } from 'express';
import crossSpawn from 'cross-spawn';
import Database from 'better-sqlite3';
import type { Database as DatabaseType } from 'better-sqlite3';

import { parseFrontMatter } from '@/shared/frontmatter.js';
import type {
  AnyRecord,
  ApiSuccessShape,
  AppErrorOptions,
  LLMProvider,
  NormalizedMessage,
  OrchestratorMessage,
  ProviderCurrentActiveModel,
  ProviderModelsDefinition,
  ProviderSkillSource,
  WorkspacePathValidationResult,
} from '@/shared/types.js';

//----------------- ENVIRONMENT UTILITIES ------------
/**
 * Indicates whether the backend is running in hosted Platform mode rather than
 * self-hosted OSS mode. The server bootstrap, Agent, Auth, and Browser Use
 * modules use this shared flag to keep environment-dependent behavior aligned.
 * Environment variables must be loaded before this module is evaluated.
 */
export const IS_PLATFORM = process.env.VITE_IS_PLATFORM === 'true';

/**
 * Pseudo-provider value stored on orchestrated parent sessions. A parent has
 * no provider runtime of its own: its transcript lives in the ddagent-owned
 * `orchestrator_messages` table and every user message is delegated to child
 * sessions running on real providers. Consumed by the websocket dispatch path,
 * the sessions history/delete paths, and the orchestrator module.
 */
export const ORCHESTRATOR_PROVIDER = 'orchestrator';

/**
 * Environment for provider CLI child processes (`devin acp`, Claude Code,
 * cursor-agent) and, transitively, the stdio MCP servers they spawn.
 *
 * Service-launched deployments (systemd, watchdogs) often run with a minimal
 * PATH that lacks `~/.local/bin`, where user-level tools such as
 * `task-master-mcp`, `uv`/`uvx` or `duckduckgo-mcp-server` are installed —
 * their MCP connections then fail with "cannot find binary path". Appending
 * the standard user-local bin dir (never prepending, so system binaries keep
 * precedence) restores those lookups. The Providers module runtimes use this
 * for every child spawn.
 *
 * `TASK_MASTER_TOOLS` defaults to `standard` so task-master-mcp exposes the
 * write tools (`add_task`, `add_subtask`, `remove_task`, `initialize_project`)
 * the agent needs to manage the board; the upstream default `core` profile
 * omits task creation entirely. An explicit `TASK_MASTER_TOOLS` in the parent
 * env always wins, as do caller `overrides`.
 *
 * Windows constraint: environment variables are case-insensitive and
 * `process.env` carries the PATH under its `Path` casing. Writing a fresh
 * `PATH` key would shadow `Path` in the child's environment block, leaving
 * it with only the user-local dir — `spawn devin ENOENT` for every bare
 * command. The existing key's casing must therefore be reused. `baseEnv`
 * exists so tests can exercise that path with a fake Windows-style env.
 */
export function providerChildEnv(
  overrides: Record<string, string> = {},
  baseEnv: NodeJS.ProcessEnv = process.env,
): NodeJS.ProcessEnv {
  const env: NodeJS.ProcessEnv = { ...baseEnv };
  const userLocalBin = path.join(os.homedir(), '.local', 'bin');
  const pathKey = Object.keys(env).find((key) => key.toUpperCase() === 'PATH') ?? 'PATH';
  const pathEntries = (env[pathKey] ?? '').split(path.delimiter).filter(Boolean);
  if (!pathEntries.includes(userLocalBin)) {
    env[pathKey] = [...pathEntries, userLocalBin].join(path.delimiter);
  }
  env.TASK_MASTER_TOOLS ??= 'standard';
  return { ...env, ...overrides };
}

// ---------------------------
//----------------- DEVIN CLI DATA/CONFIG DIRECTORIES ------------

/**
 * Per-platform directory where the Devin CLI keeps its data files
 * (`credentials.toml`, `cli/sessions.db`, `mcp_config.json`, `config.json`).
 * On Linux/macOS it follows the XDG layout (`~/.local/share/devin`); on
 * Windows the CLI stores everything under `%APPDATA%\devin` (Roaming) — the
 * XDG paths never materialize there, so providers that looked them up saw
 * the CLI as unauthenticated. Consumed by the devin provider's auth check,
 * runtime (user MCP config) and session synchronizer.
 */
export function devinDataDir(): string {
  if (process.platform === 'win32') {
    const roaming = process.env.APPDATA ?? path.join(os.homedir(), 'AppData', 'Roaming');
    return path.join(roaming, 'devin');
  }
  return path.join(os.homedir(), '.local', 'share', 'devin');
}

/**
 * Per-platform directory for the Devin CLI's `config.json`. On Linux/macOS
 * this is the XDG config dir (`~/.config/devin`); on Windows the CLI merges
 * config into the same Roaming data dir as everything else.
 * Consumed by the devin provider's auth check and runtime MCP config.
 */
export function devinConfigDir(): string {
  if (process.platform === 'win32') {
    return devinDataDir();
  }
  return path.join(os.homedir(), '.config', 'devin');
}

// ---------------------------
//----------------- COMMAND CODE PATH/EXECUTABLE HELPERS ------------
/**
 * Root of the Command Code CLI's per-user data directory (`~/.commandcode`).
 * The CLI always derives it from HOME/USERPROFILE — no dedicated config-home
 * env var exists — so provider-account isolation presets override HOME itself.
 * Consumed by the commandcode provider's auth, MCP, skills, sessions and
 * session-synchronizer facets.
 */
export function commandCodeDir(): string {
  return path.join(os.homedir(), '.commandcode');
}

/**
 * Directory holding one subfolder per project (`<slug>/<session-id>.jsonl`
 * transcripts plus `.meta.json`/`.checkpoints.jsonl` sidecars).
 * Consumed by the commandcode sessions provider and session synchronizer.
 */
export function commandCodeProjectsDir(): string {
  return path.join(commandCodeDir(), 'projects');
}

/**
 * Reproduces the CLI's project-directory slug (`@sindresorhus/slugify(cwd)`,
 * `'root'` on an empty result). Path separators, dots, underscores and other
 * non-alphanumerics all collapse to `-`, e.g. `/tmp/cc-ws` → `tmp-cc-ws`.
 * Consumed by the commandcode MCP provider (local-scope config path) and by
 * the runtime/sessions readers locating a session's transcript directory.
 */
export function commandCodeProjectSlug(cwd: string): string {
  const slug = String(cwd ?? '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
  return slug || 'root';
}

/**
 * Predicate matching the CLI's own `isSessionTranscriptFileName`: a primary
 * transcript is any `.jsonl` file that is not a `.checkpoints.jsonl`,
 * `.prompts.jsonl` or `.v2.bak` sidecar. Consumed by the commandcode session
 * synchronizer and watcher-driven single-file sync.
 */
export function isCommandCodeTranscriptFileName(fileName: string): boolean {
  return fileName.endsWith('.jsonl')
    && !fileName.includes('.checkpoints.')
    && !fileName.includes('.prompts.')
    && !fileName.includes('.v2.bak');
}

const COMMAND_CODE_EXECUTABLE_CANDIDATES: readonly string[] =
  process.platform === 'win32'
    ? ['command-code', 'cmdc', 'commandcode']
    : ['command-code', 'cmd', 'commandcode'];

/**
 * Global-bin directories probed on Windows when every PATH candidate misses.
 * npm, pnpm, and bun install CLI shims under the *user* profile, which a
 * backend started from a service context, scheduled task, or a launcher with
 * a sanitized environment never inherits — the CLI then answers `--version`
 * in the user's terminal while the backend keeps reporting it as missing.
 */
const windowsShimCandidates = (executableNames: readonly string[]): string[] => {
  const dirs = [
    process.env.APPDATA && path.join(process.env.APPDATA, 'npm'),
    process.env.LOCALAPPDATA && path.join(process.env.LOCALAPPDATA, 'pnpm'),
    path.join(os.homedir(), '.bun', 'bin'),
  ];
  const shims: string[] = [];
  for (const dir of dirs) {
    if (!dir) continue;
    for (const name of executableNames) {
      const shim = path.join(dir, `${name}.cmd`);
      try {
        if (fs.existsSync(shim)) {
          shims.push(shim);
        }
      } catch {
        // Unreadable profile dir — treat like a PATH miss.
      }
    }
  }
  return shims;
};

const commandCodeWindowsShimCandidates = (): string[] =>
  windowsShimCandidates(COMMAND_CODE_EXECUTABLE_CANDIDATES);

let resolvedCommandCodeExecutable: string | null | undefined;

/**
 * Resolves the Command Code CLI executable name in the documented order:
 * `command-code`, then the short alias (`cmdc` on Windows, `cmd` elsewhere —
 * `cmd.exe` is never reachable here because spawn resolves `cmd` to the npm
 * shim only when it exists on PATH ahead of the system shell, and cross-spawn
 * appends the PATHEXT variants), then `commandcode`. `COMMAND_CODE_CLI_PATH`
 * overrides detection entirely (mirrors `CLAUDE_CLI_PATH`); on Windows the
 * well-known global-bin dirs above are probed after the PATH misses. Returns
 * `null` when none answers `--version`. The result is cached for the process
 * lifetime; pass a `spawnSync` override in tests.
 */
export function resolveCommandCodeExecutable(
  spawnSync?: (command: string, args: string[]) => { error?: unknown; status?: number | null },
): string | null {
  const override = readOptionalString(process.env.COMMAND_CODE_CLI_PATH);
  if (override) {
    if (spawnSync === undefined) {
      resolvedCommandCodeExecutable = override;
    }
    return override;
  }

  if (spawnSync === undefined && resolvedCommandCodeExecutable !== undefined) {
    return resolvedCommandCodeExecutable;
  }

  const run = spawnSync ?? ((command: string, args: string[]) =>
    crossSpawn.sync(command, args, { stdio: 'ignore', timeout: 10_000 }));

  const candidates: string[] = [...COMMAND_CODE_EXECUTABLE_CANDIDATES];
  if (process.platform === 'win32') {
    candidates.push(...commandCodeWindowsShimCandidates());
  }

  let resolved: string | null = null;
  for (const candidate of candidates) {
    try {
      const result = run(candidate, ['--version']);
      if (!result.error && result.status === 0) {
        resolved = candidate;
        break;
      }
    } catch {
      // Candidate is not on PATH — try the next documented alias.
    }
  }

  if (spawnSync === undefined) {
    resolvedCommandCodeExecutable = resolved;
  }
  return resolved;
}

/** Test-only reset for `resolveCommandCodeExecutable`'s process-lifetime cache. */
export function resetCommandCodeExecutableCache(): void {
  resolvedCommandCodeExecutable = undefined;
}

//----------------- ANTIGRAVITY PATH/EXECUTABLE HELPERS ------------
/**
 * Root of the Antigravity CLI's per-user data directory
 * (`~/.gemini/antigravity-cli`): OAuth token, per-conversation SQLite stores,
 * `conversation_summaries.db`, `settings.json`, `hooks.json`. The CLI derives
 * it from HOME — no config-home env var — so provider-account isolation
 * presets override HOME itself. Consumed by the antigravity provider's auth,
 * sessions and session-synchronizer facets.
 */
export function antigravityDir(): string {
  return path.join(os.homedir(), '.gemini', 'antigravity-cli');
}

/**
 * Antigravity's shared config root (`~/.gemini/config`): `mcp_config.json`,
 * user-global `skills/`, per-project settings. Consumed by the antigravity
 * MCP and skills facets.
 */
export function antigravityConfigDir(): string {
  return path.join(os.homedir(), '.gemini', 'config');
}

/** One `<conversation-id>.db` (protobuf SQLite) per Antigravity conversation. */
export function antigravityConversationsDir(): string {
  return path.join(antigravityDir(), 'conversations');
}

/** SQLite index of every Antigravity conversation (id, title, workspace_uris). */
export function antigravitySummariesDbPath(): string {
  return path.join(antigravityDir(), 'conversation_summaries.db');
}

/**
 * Directory where the antigravity runtime mirrors readable transcripts.
 * Antigravity persists conversation steps as protobuf rows inside SQLite, so
 * the runtime appends a ddagent JSONL mirror per session (same contract as
 * `.ddagent/devin/`); `<session-id>.jsonl` under the workspace.
 */
export function antigravityTranscriptDir(workspacePath: string): string {
  return path.join(workspacePath, '.ddagent', 'antigravity');
}

/**
 * Extracts the Google account email from a parsed `antigravity-oauth-token`
 * payload. The CLI stores a Google `id_token` JWT alongside the OAuth grant
 * and its `email` claim names the signed-in user; returns `null` when the
 * token or claim is missing or malformed. Consumed by the antigravity auth
 * provider (ambient auth status) and the quota Gemini adapter (ambient
 * account label).
 */
export function antigravityCredentialEmail(credentials: Record<string, unknown>): string | null {
  const idToken = credentials.id_token;
  return typeof idToken === 'string' ? idTokenEmail(idToken) : null;
}

const ANTIGRAVITY_EXECUTABLE_CANDIDATES: readonly string[] = ['agy', 'antigravity-cli', 'antigravity'];

let resolvedAntigravityExecutable: string | null | undefined;

/**
 * Resolves the Antigravity CLI executable. `agy` is the documented binary
 * name; the longer spellings are accepted as fallbacks for alternate
 * installs. `ANTIGRAVITY_CLI_PATH` overrides detection entirely (mirrors
 * `COMMAND_CODE_CLI_PATH`); on Windows the well-known npm/pnpm/bun global-bin
 * dirs are probed after the PATH misses — npm installs `agy.cmd` under the
 * user profile, which a sanitized service PATH never inherits. Returns `null`
 * when no candidate answers `--version`. The result is cached for the process
 * lifetime; pass a `spawnSync` override in tests.
 */
export function resolveAntigravityExecutable(
  spawnSync?: (command: string, args: string[]) => { error?: unknown; status?: number | null },
): string | null {
  const override = readOptionalString(process.env.ANTIGRAVITY_CLI_PATH);
  if (override) {
    if (spawnSync === undefined) {
      resolvedAntigravityExecutable = override;
    }
    return override;
  }

  if (spawnSync === undefined && resolvedAntigravityExecutable !== undefined) {
    return resolvedAntigravityExecutable;
  }

  const run = spawnSync ?? ((command: string, args: string[]) =>
    crossSpawn.sync(command, args, { stdio: 'ignore', timeout: 10_000 }));

  const candidates: string[] = [...ANTIGRAVITY_EXECUTABLE_CANDIDATES];
  if (process.platform === 'win32') {
    candidates.push(...windowsShimCandidates(ANTIGRAVITY_EXECUTABLE_CANDIDATES));
  }

  let resolved: string | null = null;
  for (const candidate of candidates) {
    try {
      const result = run(candidate, ['--version']);
      if (!result.error && result.status === 0) {
        resolved = candidate;
        break;
      }
    } catch {
      // Candidate is not on PATH — try the next documented alias.
    }
  }

  if (spawnSync === undefined) {
    resolvedAntigravityExecutable = resolved;
  }
  return resolved;
}

/** Test-only reset for `resolveAntigravityExecutable`'s process-lifetime cache. */
export function resetAntigravityExecutableCache(): void {
  resolvedAntigravityExecutable = undefined;
}

// ---------------------------
//----------------- NORMALIZED MESSAGE HELPER INPUT TYPES ------------
/**
 * Input payload accepted by `createNormalizedMessage`.
 *
 * Callers provide provider-specific fields plus the required `kind/provider`
 * pair; this helper fills missing envelope fields (`id`, `sessionId`,
 * `timestamp`) in a consistent way.
 */
type NormalizedMessageInput =
  {
    kind: NormalizedMessage['kind'];
    provider: NormalizedMessage['provider'];
    id?: string | null;
    sessionId?: string | null;
    timestamp?: string | null;
  } & Record<string, unknown>;

// ---------------------------
//----------------- HTTP HANDLER UTILITIES ------------
/**
 * Wraps arbitrary data in the standard API success envelope.
 *
 * Use this helper in route handlers to keep successful JSON responses consistent
 * across endpoints.
 */
export function createApiSuccessResponse<TData>(
  data: TData,
): ApiSuccessShape<TData> {
  return {
    success: true,
    data,
  };
}

/**
 * Converts an async Express handler into a standard `RequestHandler` and routes
 * rejected promises to Express error middleware.
 *
 * Use this to avoid repeating `try/catch(next)` in every async route.
 */
export function asyncHandler(
  handler: (req: Request, res: Response, next: NextFunction) => Promise<unknown>
): RequestHandler {
  return (req, res, next) => {
    void Promise.resolve(handler(req, res, next)).catch(next);
  };
}

// ---------------------------
//----------------- SHARED ERROR UTILITIES ------------
/**
 * Shared application error with HTTP status and machine-readable code metadata.
 *
 * Throw this from service/route layers when the caller should receive a
 * controlled error response rather than a generic 500.
 */
export class AppError extends Error {
  readonly code: string;
  readonly statusCode: number;
  readonly details?: unknown;

  constructor(message: string, options: AppErrorOptions = {}) {
    super(message);
    this.name = 'AppError';
    this.code = options.code ?? 'INTERNAL_ERROR';
    this.statusCode = options.statusCode ?? 500;
    this.details = options.details;
  }
}

// ---------------------------
//----------------- WORKSPACE PATH VALIDATION UTILITIES ------------
/**
 * Root directory that all workspace/project paths must stay under.
 *
 * This is resolved from `WORKSPACES_ROOT` when configured; otherwise it falls
 * back to the current user's home directory.
 */
export const WORKSPACES_ROOT = process.env.WORKSPACES_ROOT || os.homedir();

/**
 * System-critical paths that must never be used as workspace roots.
 *
 * The validation helper blocks these values directly and also blocks paths
 * nested under them (with explicit allow-list exceptions where necessary).
 */
export const FORBIDDEN_WORKSPACE_PATHS = [
  // Unix
  '/',
  '/etc',
  '/bin',
  '/sbin',
  '/usr',
  '/dev',
  '/proc',
  '/sys',
  '/var',
  '/boot',
  '/root',
  '/lib',
  '/lib64',
  '/opt',
  '/tmp',
  '/run',
  // Windows
  'C:\\Windows',
  'C:\\Program Files',
  'C:\\Program Files (x86)',
  'C:\\ProgramData',
  'C:\\System Volume Information',
  'C:\\$Recycle.Bin',
];

function stripWindowsLongPathPrefix(inputPath: string): string {
  if (inputPath.startsWith('\\\\?\\UNC\\')) {
    return `\\\\${inputPath.slice('\\\\?\\UNC\\'.length)}`;
  }

  if (inputPath.startsWith('\\\\?\\')) {
    return inputPath.slice('\\\\?\\'.length);
  }

  return inputPath;
}

function shouldUseWindowsPathNormalization(inputPath: string): boolean {
  if (process.platform === 'win32') {
    return true;
  }

  return inputPath.startsWith('\\\\') || /^[a-zA-Z]:([\\/]|$)/.test(inputPath);
}

/**
 * Canonicalizes project/workspace paths for stable DB keys and comparisons.
 *
 * Normalization rules:
 * - trim whitespace
 * - strip Windows long-path prefixes (`\\?\` and `\\?\UNC\`)
 * - normalize path separators and dot segments
 * - trim trailing separators except for filesystem roots
 */
export function normalizeProjectPath(inputPath: string): string {
  if (typeof inputPath !== 'string') {
    return '';
  }

  const trimmed = inputPath.trim();
  if (!trimmed) {
    return '';
  }

  const withoutLongPrefix = stripWindowsLongPathPrefix(trimmed);
  const useWindowsPathRules = shouldUseWindowsPathNormalization(withoutLongPrefix);
  const normalized = useWindowsPathRules
    ? path.win32.normalize(withoutLongPrefix)
    : path.posix.normalize(withoutLongPrefix);

  if (!normalized) {
    return '';
  }

  const parser = useWindowsPathRules ? path.win32 : path.posix;
  const root = parser.parse(normalized).root;
  if (normalized === root) {
    return normalized;
  }

  return normalized.replace(/[\\/]+$/, '');
}

/**
 * Validates that a user-supplied workspace path is safe to use.
 *
 * Call this before any filesystem mutation that creates or registers projects.
 * The function resolves symlinks, enforces `WORKSPACES_ROOT` containment, and
 * blocks known system directories.
 */
export async function validateWorkspacePath(requestedPath: string): Promise<WorkspacePathValidationResult> {
  try {
    const normalizedRequestedPath = normalizeProjectPath(requestedPath);
    if (!normalizedRequestedPath) {
      return {
        valid: false,
        error: 'Workspace path is required',
      };
    }

    const absolutePath = path.resolve(normalizedRequestedPath);
    const normalizedPath = normalizeProjectPath(absolutePath);

    // Windows-style paths compare case-insensitively and accept either
    // separator — otherwise `c:\windows` or `C:/Windows` slip past the
    // forbidden list, which stores `C:\...` spellings.
    const windowsRules = shouldUseWindowsPathNormalization(normalizedPath);
    const compareForm = (value: string): string =>
      windowsRules ? value.replace(/\\/g, '/').toLowerCase() : value;
    const comparePath = compareForm(normalizedPath);

    if (FORBIDDEN_WORKSPACE_PATHS.map(compareForm).includes(comparePath) || comparePath === '/') {
      return {
        valid: false,
        error: 'Cannot use system-critical directories as workspace locations',
      };
    }

    for (const forbiddenPath of FORBIDDEN_WORKSPACE_PATHS) {
      const normalizedForbiddenPath = normalizeProjectPath(forbiddenPath);
      const compareForbiddenPath = compareForm(normalizedForbiddenPath);
      if (
        comparePath === compareForbiddenPath
        || comparePath.startsWith(`${compareForbiddenPath}/`)
      ) {
        // Allow specific user-writable folders under /var.
        if (
          normalizedForbiddenPath === '/var'
          && (normalizedPath.startsWith('/var/tmp') || normalizedPath.startsWith('/var/folders'))
        ) {
          continue;
        }

        return {
          valid: false,
          error: `Cannot create workspace in system directory: ${forbiddenPath}`,
        };
      }
    }

    let resolvedPath = normalizeProjectPath(absolutePath);
    try {
      await access(absolutePath);
      resolvedPath = normalizeProjectPath(await realpath(absolutePath));
    } catch (error) {
      const fileError = error as NodeJS.ErrnoException;
      if (fileError.code !== 'ENOENT') {
        throw fileError;
      }

      const parentPath = path.dirname(absolutePath);
      try {
        const parentRealPath = await realpath(parentPath);
        resolvedPath = normalizeProjectPath(path.join(parentRealPath, path.basename(absolutePath)));
      } catch (parentError) {
        const parentFileError = parentError as NodeJS.ErrnoException;
        if (parentFileError.code !== 'ENOENT') {
          throw parentFileError;
        }
      }
    }

    const resolvedWorkspaceRoot = normalizeProjectPath(await realpath(WORKSPACES_ROOT));
    if (
      !resolvedPath.startsWith(`${resolvedWorkspaceRoot}${path.sep}`)
      && resolvedPath !== resolvedWorkspaceRoot
    ) {
      return {
        valid: false,
        error: `Workspace path must be within the allowed workspace root: ${WORKSPACES_ROOT}`,
      };
    }

    try {
      await access(absolutePath);
      const pathStats = await lstat(absolutePath);
      if (pathStats.isSymbolicLink()) {
        const symlinkTarget = await readlink(absolutePath);
        const resolvedSymlinkPath = path.resolve(path.dirname(absolutePath), symlinkTarget);
        const realSymlinkPath = await realpath(resolvedSymlinkPath);
        if (
          !realSymlinkPath.startsWith(`${resolvedWorkspaceRoot}${path.sep}`)
          && realSymlinkPath !== resolvedWorkspaceRoot
        ) {
          return {
            valid: false,
            error: 'Symlink target is outside the allowed workspace root',
          };
        }
      }
    } catch (error) {
      const fileError = error as NodeJS.ErrnoException;
      if (fileError.code !== 'ENOENT') {
        throw fileError;
      }
    }

    return {
      valid: true,
      resolvedPath,
    };
  } catch (error) {
    return {
      valid: false,
      error: `Path validation failed: ${(error as Error).message}`,
    };
  }
}

// ---------------------------
//----------------- NORMALIZED PROVIDER MESSAGE UTILITIES ------------
/**
 * Generates a stable unique id for normalized provider messages.
 */
export function generateMessageId(prefix = 'msg'): string {
  return `${prefix}_${randomUUID()}`;
}

/**
 * Creates a normalized provider message and fills the shared envelope fields.
 *
 * Provider adapters and live SDK handlers pass through provider-specific fields,
 * while this helper guarantees every emitted event has an id, session id,
 * timestamp, and provider marker.
 */
export function createNormalizedMessage(fields: NormalizedMessageInput): NormalizedMessage {
  return {
    ...fields,
    id: fields.id || generateMessageId(fields.kind),
    sessionId: fields.sessionId || '',
    timestamp: fields.timestamp || new Date().toISOString(),
    provider: fields.provider,
  };
}

/**
 * Build the unified terminal `complete` lifecycle message.
 *
 * Contract: every provider run ends with exactly one `complete` (the
 * abort-session handler emits it on behalf of cancelled runs, so aborted runs
 * must NOT emit their own). The frontend treats `complete` as the only
 * terminal signal and never needs provider-specific handling:
 *
 * - `sessionId`     — the id the client knows this run by ('' if never discovered)
 * - `actualSessionId` — canonical id after the run; equals `sessionId` unless
 *                       the provider rewrote it mid-run
 * - `exitCode`      — 0 on success; a missing/null code (e.g. killed process)
 *                     is reported as failure
 * - `success`       — exitCode === 0 and not aborted
 * - `aborted`       — run was cancelled by the user
 */
export function createCompleteMessage(opts: {
  provider: NormalizedMessage['provider'];
  sessionId?: string | null;
  actualSessionId?: string | null;
  exitCode?: number | null;
  aborted?: boolean;
}): NormalizedMessage {
  const exitCode = typeof opts.exitCode === 'number' ? opts.exitCode : 1;
  const aborted = Boolean(opts.aborted);

  return createNormalizedMessage({
    kind: 'complete',
    provider: opts.provider,
    sessionId: opts.sessionId || null,
    actualSessionId: opts.actualSessionId || opts.sessionId || null,
    exitCode,
    success: exitCode === 0 && !aborted,
    aborted,
  });
}

/**
 * Builds the live `status` frame that projects one orchestrator transcript
 * entry onto the parent session's realtime stream.
 *
 * Consumed by the orchestrator module's `publishEntry` and the websocket
 * dispatch layer's child→parent delegation sync — both fan the same frame out
 * to the parent run writer and to every connected client. Payload fields ride
 * in `context` under `orchestratorKind`, matching the history mapper's
 * (`sessions.service` `orchestratorMessageToNormalized`) envelope so the
 * client renders live and persisted rows identically.
 *
 * Every call mints a fresh id: the client store dedupes live frames by id, so
 * omitting the id (or reusing the row's `orch-<id>` key the history endpoint
 * uses) collapses successive patches to the same delegation/plan row into the
 * first frame — later status changes then never reach the open session until
 * it is reopened. `context.orchestratorRowId` carries the stable transcript
 * row id instead: the client upserts live frames by it, so each patch updates
 * the one rendered card in place rather than appending a new row. It is set
 * after the payload spread so a stray payload key can never clobber it.
 */
export function createOrchestratorStatusFrame(entry: OrchestratorMessage): NormalizedMessage {
  return createNormalizedMessage({
    kind: 'status',
    provider: ORCHESTRATOR_PROVIDER as LLMProvider,
    sessionId: entry.sessionId,
    role: 'assistant',
    context: { orchestratorKind: entry.kind, ...entry.payload, orchestratorRowId: entry.id },
    summary: entry.kind,
  });
}

// ---------------------------
//----------------- CONVERSATION HISTORY PAGINATION UTILITIES ------------
/**
 * Slices one page from the END of a chronologically ordered message list.
 *
 * This is the single pagination contract for conversation history across all
 * providers: `offset = 0` returns the most recent `limit` items, increasing
 * offsets walk backwards in time (for "scroll up to load older" UIs), and a
 * `null` limit returns everything. Items must already be sorted oldest-first;
 * the returned page preserves that order.
 *
 * Every provider history reader must use this helper instead of slicing
 * manually so `offset`/`limit` query params behave identically regardless of
 * which provider produced the session.
 */
export function sliceTailPage<T>(
  items: T[],
  limit: number | null,
  offset: number,
): { page: T[]; hasMore: boolean } {
  const total = items.length;
  const normalizedOffset = Math.max(0, offset);

  if (limit === null) {
    // A null limit returns the full list; offset still trims newest entries
    // so "everything before the page I already have" stays expressible.
    const end = Math.max(0, total - normalizedOffset);
    return {
      page: items.slice(0, end),
      hasMore: false,
    };
  }

  const end = Math.max(0, total - normalizedOffset);
  const start = Math.max(0, end - Math.max(0, limit));
  return {
    page: items.slice(start, end),
    hasMore: start > 0,
  };
}

// ---------------------------
//----------------- MCP CONFIG PARSING UTILITIES ------------
/**
 * Safely narrows an unknown value to a plain object record.
 *
 * This deliberately rejects arrays, `null`, and primitive values so callers can
 * treat the returned value as a JSON-style object map without repeating the same
 * defensive shape checks at every config read site.
 */
export const readObjectRecord = (value: any): AnyRecord | null => {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    return null;
  }

  return value as AnyRecord;
};

/**
 * Reads an optional string from unknown input and normalizes empty or whitespace-only
 * values to `undefined`.
 *
 * This is useful when parsing config files where a field may be missing, present
 * with the wrong type, or present as an empty string that should be treated as
 * "not configured".
 */
export const readOptionalString = (value: unknown): string | undefined => {
  if (typeof value !== 'string') {
    return undefined;
  }

  const normalized = value.trim();
  return normalized.length > 0 ? normalized : undefined;
};

/**
 * Reads an optional string array from unknown input.
 *
 * Non-array values are ignored, and any array entries that are not strings are
 * filtered out. This lets provider config readers consume loosely shaped JSON/TOML
 * data without failing on incidental invalid members.
 */
export const readStringArray = (value: unknown): string[] | undefined => {
  if (!Array.isArray(value)) {
    return undefined;
  }

  return value.filter((entry): entry is string => typeof entry === 'string');
};

/**
 * Reads an optional string-to-string map from unknown input.
 *
 * The function first ensures the source value is a plain object, then keeps only
 * keys whose values are strings. If no valid entries remain, it returns `undefined`
 * so callers can distinguish "no usable map" from an empty object that was
 * intentionally authored downstream.
 */
export const readStringRecord = (value: unknown): Record<string, string> | undefined => {
  const record = readObjectRecord(value);
  if (!record) {
    return undefined;
  }

  const normalized: Record<string, string> = {};
  for (const [key, entry] of Object.entries(record)) {
    if (typeof entry === 'string') {
      normalized[key] = entry;
    }
  }

  return Object.keys(normalized).length > 0 ? normalized : undefined;
};

// ---------------------------
//----------------- JWT CLAIM UTILITIES ------------
/**
 * Reads the account identity (`email`, falling back to `user`) from a JWT
 * payload without verifying the signature — local credential stores are
 * trusted input, and the claim only labels which login produced them.
 * Returns `null` when the token or claim is missing or malformed. Consumed
 * by the codex/antigravity auth providers and the quota adapters that label
 * ambient accounts.
 */
export function idTokenEmail(idToken: string): string | null {
  const payload = idToken.split('.')[1];
  if (!payload) return null;
  try {
    const claims = readObjectRecord(
      JSON.parse(Buffer.from(payload, 'base64url').toString('utf8')),
    );
    return readOptionalString(claims?.email) ?? readOptionalString(claims?.user) ?? null;
  } catch {
    return null;
  }
}

// ---------------------------
//----------------- CLI IDENTITY UTILITIES ------------
/**
 * Reads one `Label: value` line from captured CLI output, ignoring ANSI color
 * codes and surrounding whitespace. The label must begin a word, so `Name`
 * matches `Name:` but never `Username:`. Returns null when the field is absent
 * or blank. Consumed by the Command Code and Devin auth providers' identity
 * probes.
 */
export function readCliField(output: string, label: string): string | null {
  // Strip CSI/SGR sequences (chalk-style colors, cursor moves) before matching.
  const text = output.replace(/\u001B\[[0-9;?]*[ -/]*[@-~]/g, '');
  const match = text.match(new RegExp(`(?:^|\\s)${label}:\\s*(.+?)\\s*$`, 'm'));
  return readOptionalString(match?.[1]) ?? null;
}

const CLI_IDENTITY_CACHE_TTL_MS = 60_000;
const cliIdentityCache = new Map<string, { value: string | null; at: number }>();

/**
 * Memoizes a CLI identity probe (`cmd whoami`, `devin auth status`, …) for
 * `CLI_IDENTITY_CACHE_TTL_MS`. Those probes call the provider network, while
 * the auth-status endpoint runs once per Settings render, so an uncached probe
 * would stall the agents list on every visit. A failed `load` resolves to null
 * (shown as no identity) instead of failing the whole status check. Consumed by
 * the Command Code and Devin auth providers.
 */
export function cachedCliIdentity(key: string, load: () => string | null): string | null {
  const now = Date.now();
  const hit = cliIdentityCache.get(key);
  if (hit && now - hit.at < CLI_IDENTITY_CACHE_TTL_MS) {
    return hit.value;
  }
  let value: string | null = null;
  try {
    value = readOptionalString(load()) ?? null;
  } catch {
    value = null;
  }
  cliIdentityCache.set(key, { value, at: now });
  return value;
}

/** Test-only reset for `cachedCliIdentity`'s process-lifetime cache. */
export function resetCliIdentityCache(): void {
  cliIdentityCache.clear();
}

// ---------------------------
//----------------- PROVIDER MODEL LOOKUP UTILITIES ------------
/**
 * Builds the standard "default current model" result used when a provider
 * cannot resolve a session-backed active model.
 *
 * Provider model adapters should call this after loading their supported model
 * catalog so the fallback stays aligned with the provider's current `DEFAULT`
 * selection instead of drifting to a hard-coded duplicate.
 */
export function buildDefaultProviderCurrentActiveModel(
  models: ProviderModelsDefinition,
): ProviderCurrentActiveModel {
  return {
    model: models.DEFAULT,
  };
}

/**
 * How often provider model adapters re-poll the agent CLI for catalog changes.
 *
 * Live catalogs (OpenCode, Devin) are held in memory and re-fetched at most
 * once per this window — model selection requests never shell out to the agent
 * once a catalog is cached. Consumed by the OpenCode and Devin model adapters.
 */
export const PROVIDER_MODEL_CACHE_TTL_MS = 30 * 60 * 1000;

/**
 * Read API of the cache returned by `createRefreshingCache`.
 *
 * Consumed by provider model adapters that wrap an expensive catalog load.
 */
export type RefreshingCache<T> = {
  /**
   * Returns the cached value. While the cache is fresh this never calls `load`;
   * once stale it returns the stale value immediately and refreshes in the
   * background. `forceRefresh` awaits a reload (used by `?refresh=true`).
   */
  get(forceRefresh?: boolean): Promise<T>;
  /** Returns the current cached value without triggering a load. */
  peek(): T | null;
};

/**
 * Creates a stale-while-revalidate cache over an expensive loader.
 *
 * The first call awaits `load`. Later calls return the cached value; after
 * `ttlMs` the next call serves the stale value instantly and re-polls in the
 * background, so reads never block on the loader. A failed load keeps the
 * previous cache (or serves `fallback` when nothing was ever loaded), logs the
 * reason once per attempt, and retries after `failureRetryMs` instead of the
 * full TTL — an agent CLI installed or fixed while the server runs is picked
 * up within a minute rather than after half an hour of fallback reads.
 * Concurrent loads are deduplicated through one in-flight promise.
 *
 * Consumed by provider model adapters (opencode-models.provider.ts,
 * devin-models.provider.js) with `PROVIDER_MODEL_CACHE_TTL_MS`.
 */
export const createRefreshingCache = <T>(
  load: () => Promise<T>,
  ttlMs: number,
  fallback: T,
  options?: { failureRetryMs?: number },
): RefreshingCache<T> => {
  const failureRetryMs = options?.failureRetryMs ?? 60_000;
  let cache: T | null = null;
  let attemptedAt = 0;
  let failedAt = 0;
  let pending: Promise<T> | null = null;

  const refresh = (): Promise<T> => {
    if (!pending) {
      pending = (async () => {
        attemptedAt = Date.now();
        try {
          cache = await load();
          failedAt = 0;
          return cache;
        } catch (error) {
          failedAt = Date.now();
          console.warn(
            `[provider-models] catalog refresh failed: ${error instanceof Error ? error.message : String(error)}`,
          );
          return cache ?? fallback;
        } finally {
          pending = null;
        }
      })();
    }
    return pending;
  };

  return {
    get(forceRefresh = false) {
      if (forceRefresh) {
        return refresh();
      }
      const staleAfter = failedAt > 0 ? failureRetryMs : ttlMs;
      if (Date.now() - attemptedAt >= staleAfter) {
        void refresh();
      }
      if (cache === null) {
        return pending ?? Promise.resolve(fallback);
      }
      return Promise.resolve(cache);
    },
    peek: () => cache,
  };
};

// ---------------------------
//----------------- WEBSOCKET PAYLOAD PARSING UTILITIES ------------
/**
 * Parses one websocket message payload into a plain JSON object record.
 *
 * Use this in realtime handlers that receive raw websocket payloads as `string`,
 * `Buffer`, `ArrayBuffer`, or chunk arrays. The helper converts supported
 * payload formats to UTF-8 text, parses JSON, and returns only object payloads.
 * Primitive/array/invalid payloads return `null` so callers can handle bad input
 * without throwing from deeply nested message handlers.
 */
export const parseIncomingJsonObject = (payload: unknown): AnyRecord | null => {
  let text: string | null = null;

  if (typeof payload === 'string') {
    text = payload;
  } else if (Buffer.isBuffer(payload)) {
    text = payload.toString('utf8');
  } else if (payload instanceof ArrayBuffer) {
    text = Buffer.from(payload).toString('utf8');
  } else if (Array.isArray(payload)) {
    const buffers = payload
      .map((entry) => {
        if (Buffer.isBuffer(entry)) {
          return entry;
        }

        if (entry instanceof ArrayBuffer) {
          return Buffer.from(entry);
        }

        if (ArrayBuffer.isView(entry)) {
          return Buffer.from(entry.buffer, entry.byteOffset, entry.byteLength);
        }

        return null;
      })
      .filter((entry): entry is Buffer => entry !== null);

    if (buffers.length > 0) {
      text = Buffer.concat(buffers).toString('utf8');
    }
  }

  if (typeof text !== 'string' || text.trim().length === 0) {
    return null;
  }

  try {
    const parsed = JSON.parse(text) as unknown;
    return readObjectRecord(parsed);
  } catch {
    return null;
  }
};

/**
 * Reads a JSON config file and guarantees a plain object result.
 *
 * Missing or empty files are treated as an empty config object so provider-specific
 * MCP readers can operate against first-run environments without special-case file
 * existence checks. If the file exists but contains invalid JSON, the parse error
 * is rethrown as an AppError naming the file — raw SyntaxError messages carry no
 * path and are undiagnosable in install result lists.
 */
export const readJsonConfig = async (filePath: string): Promise<Record<string, unknown>> => {
  try {
    const content = await readFile(filePath, 'utf8');
    // An existing-but-empty file is not malformed — provider CLIs (e.g.
    // Antigravity's mcp_config.json) can touch their config before ever
    // writing JSON into it. Treat it like a missing file instead of failing
    // JSON.parse on an empty string.
    if (!content.trim()) {
      return {};
    }
    const parsed = JSON.parse(content) as Record<string, unknown>;
    return readObjectRecord(parsed) ?? {};
  } catch (error) {
    const code = (error as NodeJS.ErrnoException).code;
    if (code === 'ENOENT') {
      return {};
    }

    if (error instanceof SyntaxError) {
      throw new AppError(`Invalid JSON in ${filePath}: ${error.message}`, {
        code: 'INVALID_JSON_CONFIG',
        statusCode: 400,
        details: { filePath },
      });
    }

    throw error;
  }
};

/**
 * Writes a JSON config file with stable, human-readable formatting.
 *
 * The parent directory is created automatically so callers can persist config into
 * provider-specific folders without pre-creating the directory tree. Output always
 * ends with a trailing newline to keep the file diff-friendly.
 */
export const writeJsonConfig = async (filePath: string, data: Record<string, unknown>): Promise<void> => {
  await mkdir(path.dirname(filePath), { recursive: true });
  await writeFile(filePath, `${JSON.stringify(data, null, 2)}\n`, 'utf8');
};

// ---------------------------
//----------------- PROVIDER SKILL FILE UTILITIES ------------
async function hasGitMarker(dirPath: string): Promise<boolean> {
  try {
    const gitMarkerStats = await stat(path.join(dirPath, '.git'));
    return gitMarkerStats.isDirectory() || gitMarkerStats.isFile();
  } catch {
    return false;
  }
}

/**
 * Finds the highest git worktree root visible from a starting directory.
 *
 * Provider skill systems such as Codex and OpenCode walk upward through parent
 * folders when resolving repository/project skills. Use this helper when a
 * provider needs the topmost `.git` marker instead of only the nearest one, so
 * monorepos and nested package folders discover shared root-level skills once.
 */
export async function findTopmostGitRoot(startPath: string): Promise<string | null> {
  let currentPath = path.resolve(startPath);
  let topmostGitRoot: string | null = null;

  while (true) {
    if (await hasGitMarker(currentPath)) {
      topmostGitRoot = currentPath;
    }

    const parentPath = path.dirname(currentPath);
    if (parentPath === currentPath) {
      break;
    }

    currentPath = parentPath;
  }

  return topmostGitRoot;
}

/**
 * Adds one provider skill source after normalizing and de-duplicating its root.
 *
 * Provider skill lookup rules often point at overlapping folders (for example a
 * workspace folder can also be the git root). Use this helper while building a
 * provider's `ProviderSkillSource[]` so the shared skills scanner reads each
 * physical root once and still preserves provider-specific scope/command data.
 */
export function addUniqueProviderSkillSource(
  sources: ProviderSkillSource[],
  seenRootDirs: Set<string>,
  source: ProviderSkillSource,
): void {
  const normalizedRootDir = path.resolve(source.rootDir);
  if (seenRootDirs.has(normalizedRootDir)) {
    return;
  }

  seenRootDirs.add(normalizedRootDir);
  sources.push({ ...source, rootDir: normalizedRootDir });
}

// ---------------------------
//----------------- PROVIDER SKILL MARKDOWN UTILITIES ------------
/**
 * Finds direct child skill markdown files under a provider skill root.
 *
 * Skill systems usually store one skill per child directory, so direct mode
 * scans only `<root>/<skill-name>/SKILL.md`. Recursive mode is reserved for
 * provider sources that can nest skills arbitrarily, and it returns every
 * descendant `SKILL.md`. Missing or unreadable roots return an empty list
 * because users may not have every provider installed or configured.
 */
export async function findProviderSkillMarkdownFiles(
  rootDir: string,
  options: { recursive?: boolean } = {},
): Promise<string[]> {
  const skillFiles: string[] = [];

  const collectRecursive = async (dirPath: string): Promise<void> => {
    let entries;
    try {
      entries = await readdir(dirPath, { withFileTypes: true });
    } catch {
      return;
    }

    try {
      const skillPath = path.join(dirPath, 'SKILL.md');
      const skillStats = await stat(skillPath);
      if (skillStats.isFile()) {
        skillFiles.push(skillPath);
      }
    } catch {
      // Directories without SKILL.md are expected while walking plugin trees.
    }

    for (const entry of entries) {
      if (entry.isDirectory() || entry.isSymbolicLink()) {
        await collectRecursive(path.join(dirPath, entry.name));
      }
    }
  };

  if (options.recursive) {
    await collectRecursive(rootDir);
    return skillFiles.sort((left, right) => left.localeCompare(right));
  }

  try {
    const entries = await readdir(rootDir, { withFileTypes: true });

    for (const entry of entries) {
      if (!entry.isDirectory() && !entry.isSymbolicLink()) {
        continue;
      }

      const skillPath = path.join(rootDir, entry.name, 'SKILL.md');
      try {
        const skillStats = await stat(skillPath);
        if (skillStats.isFile()) {
          skillFiles.push(skillPath);
        }
      } catch {
        // A partial skill directory should not block discovery of sibling skills.
      }
    }

    return skillFiles.sort((left, right) => left.localeCompare(right));
  } catch {
    return [];
  }
}

/**
 * Reads the `name` and `description` fields from a provider skill markdown file.
 *
 * The metadata is expected in markdown front matter. If a skill omits `name`, the
 * parent directory name is used as a stable fallback so providers can still
 * expose the skill. Missing descriptions are normalized to an empty string.
 */
export async function readProviderSkillMarkdownDefinition(
  skillPath: string,
): Promise<{ name: string; description: string }> {
  const content = await readFile(skillPath, 'utf8');
  return readProviderSkillMarkdownDefinitionFromContent(
    content,
    path.basename(path.dirname(skillPath)),
  );
}

/**
 * Reads the `name` and `description` fields from raw skill markdown content.
 *
 * This keeps filesystem discovery and newly uploaded skill creation aligned on
 * the same front matter parsing rules. `fallbackName` is used when the markdown
 * omits a `name` field so callers still get a stable, non-empty skill id.
 */
export function readProviderSkillMarkdownDefinitionFromContent(
  content: string,
  fallbackName: string,
): { name: string; description: string } {
  const parsed = parseFrontMatter(content);
  const data = readObjectRecord(parsed.data) ?? {};

  return {
    name: readOptionalString(data.name) ?? fallbackName,
    description: readOptionalString(data.description) ?? '',
  };
}

// ---------------------------
//----------------- SESSION SYNCHRONIZER TITLE HELPERS ------------
/**
 * Produces a compact session title suitable for UI rendering and DB storage.
 *
 * Use this when converting provider-native names into a consistent title value.
 * The helper collapses repeated whitespace, trims the result, and truncates it
 * to 120 characters so every provider writes stable and bounded metadata.
 * If the normalized input is empty, it returns the supplied fallback title.
 */
export function normalizeSessionName(rawValue: string | undefined, fallback: string): string {
  const normalized = (rawValue ?? '').replace(/\s+/g, ' ').trim();
  if (!normalized) {
    return fallback;
  }

  return normalized.slice(0, 120);
}

// ---------------------------
//----------------- PROVIDER SESSION VALUE NORMALIZATION UTILITIES ------------
/**
 * Converts provider-native timestamps into ISO strings.
 *
 * Provider CLIs commonly persist epoch timestamps as milliseconds, seconds, or
 * already-formatted date strings. Use this helper when normalizing session
 * metadata or transcript events so every provider writes the same ISO timestamp
 * shape to API responses and database rows.
 */
export function normalizeProviderTimestamp(value: unknown): string {
  if (typeof value === 'number' && Number.isFinite(value) && value > 0) {
    const millis = value < 1_000_000_000_000 ? value * 1000 : value;
    return new Date(millis).toISOString();
  }

  if (typeof value === 'string' && value.trim()) {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) {
      return normalizeProviderTimestamp(parsed);
    }

    const date = new Date(value);
    if (!Number.isNaN(date.getTime())) {
      return date.toISOString();
    }
  }

  return new Date().toISOString();
}

/**
 * Parses a JSON string or narrows an existing object into a plain record.
 *
 * Use this when provider databases store structured JSON inside text columns.
 * Invalid JSON, arrays, and primitive values return `null` so callers can skip
 * malformed optional metadata without hiding the rest of a session transcript.
 */
export function readJsonRecord(value: unknown): AnyRecord | null {
  if (typeof value !== 'string') {
    return readObjectRecord(value);
  }

  try {
    return readObjectRecord(JSON.parse(value));
  } catch {
    return null;
  }
}

// ---------------------------
//----------------- OPENCODE SESSION STORAGE UTILITIES ------------
/**
 * Resolves the OpenCode SQLite session database path.
 *
 * OpenCode stores session, message, part, and project metadata in one shared
 * `opencode.db` file under its XDG data directory. Provider readers and
 * synchronizers should use this path for read-only access and should never store
 * it as a deletable transcript path for an individual app session row.
 */
export function getOpenCodeDatabasePath(): string {
  return path.join(os.homedir(), '.local', 'share', 'opencode', 'opencode.db');
}

/**
 * OpenCode tool names that mutate file contents.
 *
 * OpenCode mirrors every one of these tools with an auto-generated `patch`
 * part in the same message carrying the same diff. That patch is an echo, not
 * a separate action — the CLI renders a single edit card — so the OpenCode
 * sessions and runtime providers skip the echo whenever the message already
 * emitted one of these tools. Consumed by both providers.
 */
export const OPENCODE_EDIT_TOOL_NAMES = new Set([
  'edit',
  'write',
  'multiedit',
  'apply_patch',
]);

/**
 * Opens a provider-owned SQLite database for read-only queries.
 *
 * `better-sqlite3`'s `readonly: true` option maps to SQLITE_OPEN_READONLY, which
 * cannot replay the WAL into `-shm` when the owning process left uncommitted
 * frames — SQLite then reports "attempt to write a readonly database" even
 * though every issued statement is a SELECT. Opening a normal connection and
 * enforcing `PRAGMA query_only` keeps the same no-write guarantee while still
 * permitting WAL recovery.
 *
 * Used by provider readers that query live CLI-owned databases: the OpenCode
 * session readers/synchronizers, models reader, runtime token-usage reader
 * and token-usage service, the Devin sessions reader, and the Cursor
 * sessions/models readers.
 */
export function openSqliteReadonlyDatabase(dbPath: string): DatabaseType {
  const db = new Database(dbPath, { fileMustExist: true, nativeBinding: resolveSqliteNativeBinding() });
  db.pragma('query_only = ON');
  return db;
}

// ---------------------------
//----------------- CLI TOOL RESULT FORMATTING ------------
/**
 * Renders a tool result the way the owning provider CLI presents it.
 *
 * OpenCode persists the file patch on `state.metadata.diff` /
 * `filediff.patch`, but its sessions provider used to forward only the terse
 * `state.output` ("Edit applied successfully.") as the tool result — so the
 * UI showed a one-line confirmation where the CLI showed the diff. Preferring
 * the patch restores that parity. String outputs/errors pass through
 * untouched; structured values fall back to pretty JSON; an empty result stays
 * empty so the UI keeps its "(no output)" treatment.
 *
 * Consumed by the OpenCode sessions provider for live and history
 * normalization, at two call sites.
 */
export function formatCliToolResult(
  output: unknown,
  error: unknown,
  metadata?: unknown,
): string {
  const metadataRecord = readObjectRecord(metadata);
  const diff = readOptionalString(metadataRecord?.diff)
    ?? readOptionalString(readObjectRecord(metadataRecord?.filediff)?.patch);
  if (diff) {
    return diff;
  }

  const text = readOptionalString(output) ?? readOptionalString(error);
  if (text) {
    return text;
  }

  const structured = output ?? error;
  if (structured === undefined || structured === null) {
    return '';
  }

  try {
    return JSON.stringify(structured, null, 2);
  } catch {
    return String(structured);
  }
}

// ---------------------------

const cjsRequire = createRequire(import.meta.url);

/**
 * Resolves the better-sqlite3 `.node` binary matching the current runtime ABI.
 *
 * `new Database()` defaults to `build/Release/better_sqlite3.node`, which is
 * compiled for the host Node ABI. Under Electron (embedded desktop backend)
 * that ABI differs — NODE_MODULE_VERSION 139 vs host 137 — and the load fails
 * with ERR_DLOPEN_FAILED. Checkouts rebuilt via @electron/rebuild keep an
 * Electron-ABI artifact at `bin/<platform>-<arch>-<modules>/better-sqlite3.node`.
 *
 * Returns that artifact's path only when running inside Electron and the file
 * exists; otherwise undefined, so every `new Database()` callsite can pass it
 * as `nativeBinding` unconditionally and keep the default resolution —
 * including its normal failure mode — everywhere else.
 *
 * Consumed by modules/database/connection.ts (main auth.db), this module's
 * openSqliteReadonlyDatabase (provider-owned DBs), and
 * modules/quota/services/insights-source.service.ts (insights store).
 */
export function resolveSqliteNativeBinding(): string | undefined {
  if (!process.versions.electron) return undefined;
  try {
    const pkgDir = path.dirname(cjsRequire.resolve('better-sqlite3/package.json'));
    const candidate = path.join(
      pkgDir,
      'bin',
      `${process.platform}-${process.arch}-${process.versions.modules}`,
      'better-sqlite3.node',
    );
    return fs.existsSync(candidate) ? candidate : undefined;
  } catch {
    return undefined;
  }
}

/**
 * Decodes an OpenCode text payload that was persisted as a JSON string literal.
 *
 * OpenCode can store the first user prompt (and other text parts) as `"hello"`
 * instead of `hello`. Used by both the OpenCode session reader (transcript
 * history) and the OpenCode synchronizer (session titling) so a session name or
 * message body never surfaces with surrounding quote characters. Only fully
 * quoted, valid JSON string literals are unwrapped; ordinary prose that merely
 * happens to start/end with a quote is returned untouched.
 */
export function unwrapJsonStringLiteral(value: string): string {
  const trimmed = value.trim();
  if (!trimmed.startsWith('"') || !trimmed.endsWith('"')) {
    return value;
  }

  try {
    const parsed = JSON.parse(trimmed);
    return typeof parsed === 'string' ? parsed : value;
  } catch {
    return value;
  }
}

// ---------------------------
//----------------- SAFE DIRECTORY NAME UTILITIES ------------
/**
 * Validates that a user or provider supplied identifier can safely be treated
 * as one leaf directory name under an existing root folder.
 *
 * Use this before composing paths like `<root>/<session-id>/file.db>` to block
 * path traversal and accidental nested paths. The returned string is trimmed but
 * otherwise unchanged so callers can still match the provider's on-disk naming.
 */
export function sanitizeLeafDirectoryName(inputName: string, label = 'directory name'): string {
  const normalized = inputName.trim();
  if (!normalized) {
    throw new Error(`${label} is required.`);
  }

  if (
    normalized.includes('..')
    || normalized.includes(path.posix.sep)
    || normalized.includes(path.win32.sep)
    || normalized !== path.basename(normalized)
  ) {
    throw new Error(`Invalid ${label} "${inputName}".`);
  }

  return normalized;
}

// ---------------------------
//----------------- SESSION SYNCHRONIZER FILESYSTEM HELPERS ------------
/**
 * Recursively discovers files that match one extension, with optional incremental filtering.
 *
 * Provider synchronizers call this to find transcript artifacts under provider
 * home directories. Pass `lastScanAt` to include only files created after the
 * previous scan, or pass `null` to perform a full rescan. Missing directories
 * are treated as empty because not every provider exists on every machine.
 */
export async function findFilesRecursivelyCreatedAfter(
  rootDir: string,
  extension: string,
  lastScanAt: Date | null,
  fileList: string[] = []
): Promise<string[]> {
  try {
    const entries = await readdir(rootDir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(rootDir, entry.name);

      if (entry.isDirectory()) {
        await findFilesRecursivelyCreatedAfter(fullPath, extension, lastScanAt, fileList);
        continue;
      }

      if (!entry.isFile() || !entry.name.endsWith(extension)) {
        continue;
      }

      if (!lastScanAt) {
        fileList.push(fullPath);
        continue;
      }

      const fileStat = await stat(fullPath);
      if (fileStat.birthtime > lastScanAt) {
        fileList.push(fullPath);
      }
    }
  } catch {
    // Missing provider folders are expected in first-run or partial setups.
  }

  return fileList;
}

/**
 * Reads file creation/update timestamps and maps them to DB-friendly ISO strings.
 *
 * Session indexers use this to persist `created_at` and `updated_at` metadata
 * when upserting sessions. If the file cannot be read, an empty object is
 * returned so indexing can continue for other files.
 */
export async function readFileTimestamps(
  filePath: string
): Promise<{ createdAt?: string; updatedAt?: string }> {
  try {
    const fileStat = await stat(filePath);
    return {
      createdAt: fileStat.birthtime.toISOString(),
      updatedAt: fileStat.mtime.toISOString(),
    };
  } catch {
    return {};
  }
}

//----------------- TRANSCRIPT METADATA HELPERS ------------
/**
 * Counts non-empty lines in a JSONL transcript by streaming it in fixed chunks.
 *
 * The session picker displays this "message count", but transcripts routinely
 * reach tens or hundreds of MB (a single Claude session can exceed 100MB). The
 * counting consumers (`sessions.service.listRecentSessions` and
 * `projects-with-sessions-fetch.service`) previously `readFileSync`-ed the whole
 * transcript as UTF-8 and `split('\n')`-ed it on every request — hundreds of ms
 * per large session, repeated for every row. This counts bytes without decoding
 * or materializing the file; a line counts when it holds any byte other than
 * spaces, tabs, or CR.
 *
 * Results are memoized by `(mtimeMs, size)`. Transcripts are append-only, so an
 * append always changes `size` (and usually `mtimeMs`), which invalidates the
 * entry — the picker endpoint can call this for 100 rows per navigation and pay
 * only a `stat` for unchanged files.
 */
export function countJsonlLines(filePath: string): number {
  const stats = fs.statSync(filePath);
  const cached = jsonlLineCountCache.get(filePath);
  if (cached && cached.mtimeMs === stats.mtimeMs && cached.size === stats.size) {
    return cached.count;
  }

  const fd = fs.openSync(filePath, 'r');
  let count = 0;
  try {
    const buffer = Buffer.allocUnsafe(64 * 1024);
    let hasContent = false;
    let read = 0;
    while ((read = fs.readSync(fd, buffer, 0, buffer.length, null)) > 0) {
      for (let i = 0; i < read; i += 1) {
        const byte = buffer[i];
        if (byte === 0x0a) {
          if (hasContent) count += 1;
          hasContent = false;
        } else if (byte !== 0x20 && byte !== 0x09 && byte !== 0x0d) {
          hasContent = true;
        }
      }
    }
    if (hasContent) count += 1;
  } finally {
    fs.closeSync(fd);
  }

  // Bound the cache so long-lived servers with churning sessions cannot grow it
  // without limit; clearing wholesale is fine because misses are just re-reads.
  if (jsonlLineCountCache.size >= JSONL_LINE_COUNT_CACHE_LIMIT) {
    jsonlLineCountCache.clear();
  }
  jsonlLineCountCache.set(filePath, {
    mtimeMs: stats.mtimeMs,
    size: stats.size,
    count,
  });
  return count;
}

/** Memo for {@link countJsonlLines}, keyed by transcript path. */
const jsonlLineCountCache = new Map<
  string,
  { mtimeMs: number; size: number; count: number }
>();

/** Cap on {@link jsonlLineCountCache} entries before a wholesale reset. */
const JSONL_LINE_COUNT_CACHE_LIMIT = 4096;

/**
 * Reads the tail of a file and returns it as UTF-8, dropping the first line
 * when the read started mid-line.
 *
 * Token-usage snapshots are appended to a transcript, so the freshest snapshot
 * is always within the final bytes; the caller reads only {@link maxBytes}
 * instead of a transcript that can exceed 100MB. The truncation drops the
 * leading partial line so the caller never parses a half JSON object — the
 * consumer scans lines from the end, so a dropped first line is harmless.
 *
 * @param filePath Absolute path to the transcript file.
 * @param maxBytes Upper bound on bytes read from the end; the whole file is
 *   returned when it is smaller.
 */
export async function readFileTail(filePath: string, maxBytes: number): Promise<string> {
  const stats = await stat(filePath);
  const start = stats.size > maxBytes ? stats.size - maxBytes : 0;
  const length = stats.size - start;

  const fd = await open(filePath, 'r');
  try {
    const buffer = Buffer.allocUnsafe(length);
    await fd.read(buffer, 0, length, start);
    const text = buffer.toString('utf8');
    // When we started partway through the file the first line is a fragment;
    // discard it so every line the caller sees is complete.
    return start === 0 ? text : text.slice(text.indexOf('\n') + 1);
  } finally {
    await fd.close();
  }
}

// ---------------------------
//----------------- SESSION SYNCHRONIZER JSONL PARSING HELPERS ------------
/**
 * Builds a first-seen key/value lookup map from a JSONL file.
 *
 * Use this for provider index files where session id -> display name metadata
 * is stored line-by-line. The first value for each key wins, preserving the
 * earliest known label while avoiding repeated map overwrites.
 */
export async function buildLookupMap(
  filePath: string,
  keyField: string,
  valueField: string
): Promise<Map<string, string>> {
  const lookup = new Map<string, string>();

  try {
    const fileStream = fs.createReadStream(filePath);
    const lineReader = readline.createInterface({ input: fileStream, crlfDelay: Infinity });

    for await (const line of lineReader) {
      const trimmed = line.trim();
      if (!trimmed) {
        continue;
      }

      const parsed = JSON.parse(trimmed) as Record<string, unknown>;
      const key = parsed[keyField];
      const value = parsed[valueField];

      if (typeof key === 'string' && typeof value === 'string' && !lookup.has(key)) {
        lookup.set(key, value);
      }
    }
  } catch {
    // Missing or unreadable lookup files should not block session sync.
  }

  return lookup;
}

/**
 * Reads a JSONL file and returns the first extracted payload that matches caller criteria.
 *
 * The caller supplies an `extractor` that validates provider-specific row
 * shapes. This helper centralizes line-by-line parsing and lets indexers stop
 * scanning as soon as one valid row is found.
 */
export async function extractFirstValidJsonlData<T>(
  filePath: string,
  extractor: (parsedJson: unknown) => T | null | undefined
): Promise<T | null> {
  try {
    const fileStream = fs.createReadStream(filePath);
    const lineReader = readline.createInterface({ input: fileStream, crlfDelay: Infinity });

    for await (const line of lineReader) {
      const trimmed = line.trim();
      if (!trimmed) {
        continue;
      }

      const parsed = JSON.parse(trimmed);
      const extracted = extractor(parsed);
      if (extracted) {
        lineReader.close();
        fileStream.close();
        return extracted;
      }
    }
  } catch {
    // Ignore malformed or missing artifacts so full scans keep progressing.
  }

  return null;
}

// ---------------------------
//----------------- CLI PROMPT ARGUMENT UTILITIES ------------
/**
 * Makes a prompt safe to pass as one CLI argument to `.cmd`-shimmed tools on
 * Windows (cursor-agent and opencode installed via npm-style shims).
 *
 * cmd.exe cannot carry newlines inside an argument: everything after the
 * first newline is silently dropped before the target CLI ever sees it, which
 * truncates multi-line prompts and any appended `<images_input>` block.
 * Collapsing newline runs to single spaces loses formatting but never loses
 * content, so runtimes should call this on win32 right before spawning.
 *
 * Used by the cursor and opencode spawn runtimes.
 */
export function flattenPromptForWindowsShell(prompt: string): string {
  if (process.platform !== 'win32' || typeof prompt !== 'string') {
    return prompt;
  }
  return prompt.replace(/\s*\r?\n\s*/g, ' ').trim();
}

/**
 * Promisified `child_process.execFile` that spawns through cross-spawn, so
 * `.cmd`/PATHEXT npm shims resolve on Windows — plain execFile cannot run
 * batch shims and fails with ENOENT even though the CLI sits on PATH (which
 * silently downgraded every CLI-backed model catalog to its static fallback
 * on Windows installs). Buffers stdout/stderr as utf8, kills on `timeout`,
 * aborts once stdout exceeds `maxBuffer`, and rejects non-zero exits with an
 * error carrying `code`/`stdout`/`stderr` like real execFile.
 *
 * Consumed by the provider model catalogs (Command Code, OpenCode,
 * Antigravity, Codex, Devin) and the provider auth `--version` probes — each
 * accepts this exact shape through its `deps.execFile` injection seam, so
 * tests keep their fakes.
 */
export function execCliFile(
  file: string,
  args: string[],
  options: { encoding?: 'utf8'; timeout?: number; maxBuffer?: number; cwd?: string; env?: NodeJS.ProcessEnv },
): Promise<{ stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    const child = crossSpawn(file, args, {
      stdio: ['ignore', 'pipe', 'pipe'],
      cwd: options.cwd,
      env: options.env,
    });
    const stdoutChunks: Buffer[] = [];
    const stderrChunks: Buffer[] = [];
    let settled = false;

    const finish = (error: Error | null, result?: { stdout: string; stderr: string }) => {
      if (settled) return;
      settled = true;
      if (timer) clearTimeout(timer);
      if (error) reject(error);
      else resolve(result ?? { stdout: '', stderr: '' });
    };
    const kill = () => {
      try {
        child.kill('SIGKILL');
      } catch {
        // Process already gone — the close handler reports the real outcome.
      }
    };
    const timer = options.timeout
      ? setTimeout(() => {
          kill();
          finish(
            Object.assign(new Error(`${file} timed out after ${options.timeout}ms`), {
              killed: true,
              signal: 'SIGKILL',
            }),
          );
        }, options.timeout)
      : undefined;

    let stdoutSize = 0;
    child.stdout?.on('data', (chunk: Buffer) => {
      stdoutSize += chunk.length;
      if (stdoutSize > (options.maxBuffer ?? Infinity)) {
        kill();
        finish(new Error(`${file} output exceeded maxBuffer`));
        return;
      }
      stdoutChunks.push(chunk);
    });
    child.stderr?.on('data', (chunk: Buffer) => stderrChunks.push(chunk));
    child.on('error', (error) => finish(error));
    child.on('close', (code, signal) => {
      const stdout = Buffer.concat(stdoutChunks).toString('utf8');
      const stderr = Buffer.concat(stderrChunks).toString('utf8');
      if (code === 0) {
        finish(null, { stdout, stderr });
      } else {
        finish(
          Object.assign(new Error(`Command failed: ${file} ${args.join(' ')}\n${stderr}`), {
            code,
            signal,
            stdout,
            stderr,
          }),
        );
      }
    });
  });
}

// ---------------------------
//----------------- TERMINAL OUTPUT UTILITIES ------------
const ANSI_TERMINAL_STYLES = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  dim: '\x1b[2m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
} as const;

/**
 * Applies the small, consistent ANSI style vocabulary used by backend
 * terminal output. The CLI and server bootstrap share these formatters so
 * status, warning, and startup messages use one implementation. Callers
 * should pass complete display strings and write the returned value directly
 * to stdout or stderr; the reset suffix prevents styling subsequent output.
 */
export const terminalTextStyles = {
  info: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.cyan}${text}${ANSI_TERMINAL_STYLES.reset}`,
  ok: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.green}${text}${ANSI_TERMINAL_STYLES.reset}`,
  warn: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.yellow}${text}${ANSI_TERMINAL_STYLES.reset}`,
  error: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.yellow}${text}${ANSI_TERMINAL_STYLES.reset}`,
  tip: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.blue}${text}${ANSI_TERMINAL_STYLES.reset}`,
  bright: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.bright}${text}${ANSI_TERMINAL_STYLES.reset}`,
  dim: (text: string): string =>
    `${ANSI_TERMINAL_STYLES.dim}${text}${ANSI_TERMINAL_STYLES.reset}`,
};

// ---------------------------
//----------------- RUNTIME PATH RESOLUTION UTILITIES ------------
/**
 * Resolves the directory containing an ES module from `import.meta.url`.
 * Backend entrypoints and feature composition roots use this instead of
 * recreating CommonJS `__dirname` logic.
 */
export function getModuleDirectory(importMetaUrl: string): string {
  return path.dirname(fileURLToPath(importMetaUrl));
}

/**
 * Directory that holds the bundle of shared Chromium system libraries.
 *
 * Environments without root (containers) cannot run `playwright install-deps`,
 * so the required `.so` files are fetched once into this stable location. The
 * Browser Use and Browser View services append it to `LD_LIBRARY_PATH` before
 * launching Chromium, which lets a single install serve every launch.
 */
export function getChromiumLibraryPath(): string {
  return process.env.DDAGENT_CHROMIUM_LIB_PATH || path.join(os.homedir(), '.ddagent', 'browser-use', 'lib');
}

/**
 * Prepends `getChromiumLibraryPath()` to the current process's
 * `LD_LIBRARY_PATH` when the directory exists and is not already present.
 *
 * Chromium is spawned by Playwright as a child process that inherits
 * `process.env`, so mutating it here is sufficient. The call is idempotent and
 * a no-op on platforms without `LD_LIBRARY_PATH` semantics.
 */
export function applyChromiumLibraryPath(): void {
  const directory = getChromiumLibraryPath();
  if (!fs.existsSync(directory)) {
    return;
  }

  const current = process.env.LD_LIBRARY_PATH || '';
  const segments = current.split(':').filter(Boolean);
  if (segments.includes(directory)) {
    return;
  }

  process.env.LD_LIBRARY_PATH = [directory, ...segments].join(':');
}

/**
 * Absolute path to the vendored fontconfig configuration used by Chromium.
 *
 * Containers built without a font stack have no `/etc/fonts/fonts.conf` and no
 * system fonts. Chromium's renderer then crashes while rasterizing any page
 * that lays out text, which surfaces as `Input.dispatchMouseEvent: Internal
 * error` (the render widget host is gone) and as "The browser page crashed."
 * In the live view. See `applyChromiumFontConfig`.
 */
export function getChromiumFontConfigPath(): string {
  return process.env.DDAGENT_CHROMIUM_FONTCONFIG || path.join(os.homedir(), '.ddagent', 'browser-use', 'fonts.conf');
}

/**
 * Points Chromium at the vendored fontconfig file and font directory so text
 * rendering works in containers that ship no fonts. Without this, heavy text
 * pages crash the renderer on first paint.
 *
 * `FONTCONFIG_FILE` is inherited by the Chromium child process spawned by
 * Playwright. The call is idempotent, respects an explicit operator value, and
 * is a no-op when the vendored config is absent.
 */
export function applyChromiumFontConfig(): void {
  const configPath = getChromiumFontConfigPath();
  if (!fs.existsSync(configPath)) {
    return;
  }

  if (!process.env.FONTCONFIG_FILE) {
    process.env.FONTCONFIG_FILE = configPath;
  }
}

/**
 * Chromium launch flags shared by every browser service.
 *
 * A headless browser is treated as an occluded/backgrounded window, so Chromium
 * throttles rendering and timers. Disabling that keeps frame streaming and
 * synthetic input responsive inside containers that have no display server.
 */
export function getChromiumLaunchArgs(): string[] {
  return [
    '--no-sandbox',
    '--disable-dev-shm-usage',
    '--disable-backgrounding-occluded-windows',
    '--disable-renderer-backgrounding',
    '--disable-background-timer-throttling',
  ];
}

/**
 * Walks upward to the nearest `server` directory in either source or compiled
 * output. Callers use this stable anchor for server-relative resources.
 */
export function findServerRoot(startDirectory: string): string {
  let currentDirectory = startDirectory;
  while (path.basename(currentDirectory) !== 'server') {
    const parentDirectory = path.dirname(currentDirectory);
    if (parentDirectory === currentDirectory) {
      throw new Error(`Could not resolve the backend server root from "${startDirectory}".`);
    }
    currentDirectory = parentDirectory;
  }
  return currentDirectory;
}

/**
 * Resolves the application root from a source or `dist-server/server` path so
 * package-level resources work identically before and after compilation.
 */
export function findApplicationRoot(startDirectory: string): string {
  const serverRoot = findServerRoot(startDirectory);
  const parentDirectory = path.dirname(serverRoot);
  return path.basename(parentDirectory) === 'dist-server'
    ? path.dirname(parentDirectory)
    : parentDirectory;
}

// ---------------------------
//----------------- DEVIN INTERNAL CONTENT FILTERS ------------
// DDAGENT_HIDDEN_TRANSCRIPT_PATTERNS hides deployment-specific injected
// prompts: `;`-separated OR-groups of `|`-separated AND-terms, matched
// case-insensitively against the message body.
function hiddenTranscriptPatternGroups(): string[][] {
  return (process.env.DDAGENT_HIDDEN_TRANSCRIPT_PATTERNS ?? '')
    .split(';')
    .map((group) =>
      group
        .split('|')
        .map((term) => term.trim().toLowerCase())
        .filter(Boolean),
    )
    .filter((group) => group.length > 0);
}

function matchesHiddenTranscriptPattern(lower: string): boolean {
  return hiddenTranscriptPatternGroups().some((group) =>
    group.every((term) => lower.includes(term)),
  );
}

/**
 * Detects continuation/summary prompts that the Devin runtime or ACP injects as
 * user turns but which should never appear in the UI transcript. Covers the
 * standard English continuation prompt, Task Master auto-continue prompts, and
 * Devin summary instructions.
 */
export function isDevinContinuationPrompt(content: string): boolean {
  if (typeof content !== 'string') {
    return false;
  }
  const trimmed = content.trim();
  const lower = trimmed.toLowerCase();
  if (trimmed === 'Please continue and provide a final response.') {
    return true;
  }
  if (trimmed.startsWith('There are ') && trimmed.includes('unfinished Task Master task')) {
    return true;
  }
  if (lower.startsWith('conversation to summarize:') || lower.startsWith('now summarize the conversation')) {
    return true;
  }
  if (matchesHiddenTranscriptPattern(lower)) {
    return true;
  }
  return false;
}

/**
 * Detects Devin-generated summary artifacts that should not be rendered as the
 * final assistant answer. Covers `<summary>...</summary>` wrappers plus
 * deployment-specific patterns from DDAGENT_HIDDEN_TRANSCRIPT_PATTERNS.
 */
export function isDevinSummaryArtifact(content: string): boolean {
  if (typeof content !== 'string') {
    return false;
  }
  const trimmed = content.trim();
  if (/^\s*<summary>[\s\S]*?<\/summary>\s*$/i.test(trimmed)) {
    return true;
  }
  if (matchesHiddenTranscriptPattern(trimmed.toLowerCase())) {
    return true;
  }
  return false;
}

// ---------------------------
//----------------- ERROR NORMALIZATION UTILITIES ------------
/**
 * Extracts a Node-style `code` property (e.g. `ENOENT`) from an unknown thrown
 * value so callers can branch on syscall failures without unsafe casts.
 * Used by the server entrypoint's local-server marker handling.
 */
export function getErrorCode(error: unknown): string | undefined {
  if (typeof error !== 'object' || error === null || !('code' in error)) {
    return undefined;
  }
  return String(error.code);
}

/**
 * Normalizes an unknown thrown value to a printable message for warn/error
 * logging. Used by the server entrypoint and the services composition root
 * when shutdown or marker cleanup must report a failure and continue.
 */
export function getErrorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error);
}

/**
 * Suffix appended to the custom name of a technical session that must never
 * appear in the UI's session lists (delegated subagent work and the
 * orchestrator's internal lane calls). Kept next to the SQL filter and
 * `isSubagentSessionTitle` so the writer and both readers share one definition.
 * Consumed by the orchestrator delegation service and the legacy-session
 * cleanup migration.
 */
export const SUBAGENT_SESSION_MARKER = ' (subagent)';

/**
 * SQL WHERE clause fragment to exclude technical subagent sessions from query results.
 * Excludes sessions whose custom_name/title indicates a technical subagent session.
 */
export const SUBAGENT_SESSION_SQL_FILTER =
  "(sessions.custom_name IS NULL OR (sessions.custom_name NOT LIKE '%(@%subagent)%' AND sessions.custom_name NOT LIKE '%(@subagents/%' AND sessions.custom_name NOT LIKE '%(subagent)%'))";

/**
 * Identifies technical subagent session titles that should be hidden from UI lists.
 */
export function isSubagentSessionTitle(title: string | null | undefined): boolean {
  if (!title || typeof title !== 'string') {
    return false;
  }
  return (
    /\(@.+?\bsubagent\)/i.test(title) ||
    /\(@subagents\//i.test(title) ||
    /\(subagent\)/i.test(title)
  );
}


// ---------------------------
//----------------- WEBSOCKET SEND UTILITIES ------------
/**
 * Sends one websocket payload to one connection, swallowing per-socket
 * failures. A socket can die between the readyState check and `send()` —
 * without this guard one dead connection throws inside a broadcast loop and
 * every remaining subscriber silently misses the frame.
 *
 * Used by every multi-client fan-out: run-frame delivery
 * (ChatSessionWriter), queue snapshots, and session_upserted broadcasts.
 */
export function safeSocketSend(
  connection: { readyState: number; send(data: string): void },
  payload: string,
): void {
  // 1 === WebSocket.OPEN; inlined so shared utils need no `ws` import.
  if (connection.readyState !== 1) {
    return;
  }
  try {
    connection.send(payload);
  } catch {
    // Dead socket mid-broadcast — delivery to the rest already happened or
    // continues; the close handler removes it from the subscriber sets.
  }
}
