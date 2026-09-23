import path from 'node:path';

import type {
  GitCommandRunner,
  SaveWorktreeScriptsInput,
  WorktreeScriptStatusInput,
  WorktreeScriptsConfig,
  WorktreeScriptsConfigResult,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';
import { resolveRepositoryRoot } from '@/modules/worktrees/services/worktree-git.service.js';

/**
 * Repo-level script config file: `<repositoryRoot>/.ddagent/worktree.json`.
 *
 * Shape: `{ "setup": "npm install", "run": "npm run dev", "runPort": 5173 }` —
 * every field optional. Unknown fields are ignored so the file can grow.
 */
const WORKTREE_CONFIG_FILE_SEGMENTS = ['.ddagent', 'worktree.json'];

/**
 * Filesystem + DB capabilities needed to resolve a repository's script config.
 *
 * Production wiring reads the real config file and the projects table; tests
 * inject in-memory equivalents so resolution never touches the developer disk.
 */
export type WorktreeScriptConfigSources = {
  readFile(absolutePath: string): Promise<string | null>;
  getProjectOverride(projectPath: string): WorktreeScriptsConfig | null;
};

/**
 * Parses `.ddagent/worktree.json` content into a config.
 *
 * Invalid JSON or a non-object payload yields null (the file is treated as
 * absent). Each field is validated independently — a malformed `runPort` does
 * not discard a valid `setup`. Exported for the module's unit tests and used
 * internally by `resolveWorktreeScripts`.
 */
export function parseWorktreeConfigFileContent(content: string): WorktreeScriptsConfig | null {
  let parsed: unknown;
  try {
    parsed = JSON.parse(content);
  } catch {
    return null;
  }

  if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
    return null;
  }

  const record = parsed as Record<string, unknown>;
  const readScript = (value: unknown): string | null => {
    if (typeof value !== 'string') {
      return null;
    }
    const trimmed = value.trim();
    return trimmed.length > 0 ? trimmed : null;
  };

  const runPort =
    typeof record.runPort === 'number' &&
    Number.isInteger(record.runPort) &&
    record.runPort >= 1 &&
    record.runPort <= 65535
      ? record.runPort
      : null;

  return {
    setup: readScript(record.setup),
    run: readScript(record.run),
    runPort,
  };
}

/**
 * Resolves the effective script config for a repository.
 *
 * Per-field read order: the repository-root project row's override wins when
 * non-null, otherwise the repo file value applies. Provenance flags tell the
 * UI whether each source contributed anything at all.
 */
export async function resolveWorktreeScripts(
  repositoryRoot: string,
  sources: WorktreeScriptConfigSources,
): Promise<WorktreeScriptsConfigResult> {
  const fileContent = await sources.readFile(
    path.join(repositoryRoot, ...WORKTREE_CONFIG_FILE_SEGMENTS),
  );
  const repoFile = fileContent == null ? null : parseWorktreeConfigFileContent(fileContent);
  const override = sources.getProjectOverride(repositoryRoot);

  return {
    setup: override?.setup ?? repoFile?.setup ?? null,
    run: override?.run ?? repoFile?.run ?? null,
    runPort: override?.runPort ?? repoFile?.runPort ?? null,
    hasProjectOverride: override != null,
    hasRepoFile: repoFile != null,
  };
}

/**
 * Effective config read for `GET /api/worktrees/status`-style consumers that
 * start from a project path rather than a known repository root.
 */
export async function getWorktreeScriptsConfig(
  input: WorktreeScriptStatusInput,
  dependencies: WorktreeScriptConfigSources & { runGit: GitCommandRunner },
): Promise<WorktreeScriptsConfigResult> {
  const repositoryRoot = await resolveRepositoryRoot(input.projectPath, dependencies.runGit);
  return resolveWorktreeScripts(repositoryRoot, dependencies);
}

function normalizeScriptField(value: string | null, name: string): string | null {
  if (value == null) {
    return null;
  }
  if (typeof value !== 'string') {
    throw new AppError(`${name} must be a string or null`, {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : null;
}

function normalizeRunPort(value: number | null): number | null {
  if (value == null) {
    return null;
  }
  if (!Number.isInteger(value) || value < 1 || value > 65535) {
    throw new AppError('runPort must be an integer between 1 and 65535', {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }
  return value;
}

/**
 * Saves the project override for the repository containing `projectPath` and
 * returns the freshly resolved effective config.
 *
 * The override is always keyed to the repository root project so every
 * worktree of the repo shares one configuration.
 */
export async function saveWorktreeScriptsConfig(
  input: SaveWorktreeScriptsInput,
  dependencies: WorktreeScriptConfigSources & {
    runGit: GitCommandRunner;
    setProjectOverride(projectPath: string, config: WorktreeScriptsConfig): void;
  },
): Promise<WorktreeScriptsConfigResult> {
  const override: WorktreeScriptsConfig = {
    setup: normalizeScriptField(input.setup, 'setup'),
    run: normalizeScriptField(input.run, 'run'),
    runPort: normalizeRunPort(input.runPort),
  };

  const repositoryRoot = await resolveRepositoryRoot(input.projectPath, dependencies.runGit);
  dependencies.setProjectOverride(repositoryRoot, override);
  return resolveWorktreeScripts(repositoryRoot, dependencies);
}
