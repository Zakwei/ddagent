import { randomUUID } from 'node:crypto';
import { rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';

/**
 * Result of a `git` invocation. Mirrors the shape returned by the Git routes'
 * `spawnAsync` so the routes module can hand its runner straight to the
 * checkpoint service.
 */
export type GitCommandResult = {
  stdout: string;
  stderr: string;
};

/**
 * Minimal `git` runner contract used by checkpoint operations. The owning Git
 * routes module supplies its `spawnAsync` implementation in production; tests
 * can supply a real runner against a temporary repository.
 */
export type GitCommandRunner = (
  command: string,
  args: string[],
  options: { cwd: string; env?: Record<string, string | undefined> },
) => Promise<GitCommandResult>;

/** A single non-destructive snapshot of a repository working tree. */
export type GitCheckpoint = {
  /** Stable storage ref, e.g. `refs/ddagent/checkpoints/3`. */
  ref: string;
  /** Snapshot commit hash. */
  commit: string;
  /** Commit timestamp in ISO-8601, or `null` when unavailable. */
  createdAt: string | null;
  /** Human-readable label supplied at creation time. */
  label: string;
  /** Repository-relative paths captured in the snapshot. */
  files: string[];
};

/** Checkpoint metadata without the (potentially large) file list. */
export type GitCheckpointSummary = Omit<GitCheckpoint, 'files'>;

type CheckpointDependencies = {
  projectPath: string;
  runCommand: GitCommandRunner;
};

/** `git for-each-ref` field separator that cannot appear in a ref name. */
const REF_FIELD_SEPARATOR = '\u001f';

/** Namespace under which ddagent stores its non-branch checkpoint refs. */
const CHECKPOINT_REF_PREFIX = 'refs/ddagent/checkpoints/';

const DEFAULT_CHECKPOINT_LABEL = 'Manual checkpoint';

/** Creates a temporary index path isolated from the repository's real index. */
function createTempIndexPath(): string {
  return path.join(tmpdir(), `ddagent-git-index-${randomUUID()}`);
}

/**
 * Confirms a commit-ish exists before it is used as a `--source`. Returns the
 * `git rev-parse --verify HEAD` output when a HEAD commit exists, otherwise
 * `null` for a repository whose first snapshot has no parent commit.
 */
async function resolveHeadCommit(dependencies: CheckpointDependencies): Promise<string | null> {
  try {
    const { stdout } = await dependencies.runCommand('git', ['rev-parse', '--verify', 'HEAD'], {
      cwd: dependencies.projectPath,
    });
    const commit = stdout.trim();
    return commit.length > 0 ? commit : null;
  } catch {
    return null;
  }
}

/**
 * Snapshots the entire working tree — tracked modifications, deletions, and
 * untracked files — into a dangling commit stored under
 * `refs/ddagent/checkpoints/<n>`, without touching the real index or working
 * tree.
 *
 * Used by the Git routes module to power "checkpoint before an AI turn" and
 * its matching restore.
 */
export async function createCheckpoint(
  input: CheckpointDependencies & { label?: string },
): Promise<GitCheckpoint> {
  const tempIndexPath = createTempIndexPath();
  const commandOptions = {
    cwd: input.projectPath,
    env: { ...process.env, GIT_INDEX_FILE: tempIndexPath },
  };

  try {
    const headCommit = await resolveHeadCommit(input);

    if (headCommit) {
      await input.runCommand('git', ['read-tree', 'HEAD'], commandOptions);
    }

    // Stage the full working tree (including untracked, excluding ignored) into
    // the throwaway index, then freeze it as a tree.
    await input.runCommand('git', ['add', '-A'], commandOptions);
    const { stdout: treeOutput } = await input.runCommand('git', ['write-tree'], commandOptions);
    const tree = treeOutput.trim();

    const label = input.label?.trim() || DEFAULT_CHECKPOINT_LABEL;
    const commitArgs = ['commit-tree', tree, '-m', `checkpoint: ${label}`];
    if (headCommit) {
      commitArgs.push('-p', headCommit);
    }
    const { stdout: commitOutput } = await input.runCommand('git', commitArgs, {
      cwd: input.projectPath,
    });
    const commit = commitOutput.trim();

    const ref = `${CHECKPOINT_REF_PREFIX}${Date.now().toString(36)}-${randomUUID().slice(0, 8)}`;
    await input.runCommand('git', ['update-ref', ref, commit], { cwd: input.projectPath });

    const { stdout: filesOutput } = await input.runCommand(
      'git',
      ['ls-tree', '-r', '--name-only', tree],
      { cwd: input.projectPath },
    );
    const { stdout: dateOutput } = await input.runCommand(
      'git',
      ['show', '-s', '--format=%cI', commit],
      { cwd: input.projectPath },
    );

    return {
      ref,
      commit,
      createdAt: dateOutput.trim() || null,
      label,
      files: filesOutput.split('\n').filter((file) => file.length > 0),
    };
  } finally {
    await rm(tempIndexPath, { force: true }).catch(() => undefined);
  }
}

/**
 * Lists stored checkpoints newest-first. Used by the Git routes module to show
 * an undo history for AI runs.
 */
export async function listCheckpoints(
  input: CheckpointDependencies,
): Promise<GitCheckpointSummary[]> {
  const { stdout } = await input.runCommand(
    'git',
    [
      'for-each-ref',
      '--sort=-creatordate',
      `--format=%(refname)${REF_FIELD_SEPARATOR}%(objectname)${REF_FIELD_SEPARATOR}%(creatordate:iso-strict)${REF_FIELD_SEPARATOR}%(subject)`,
      CHECKPOINT_REF_PREFIX,
    ],
    { cwd: input.projectPath },
  );

  return stdout
    .split('\n')
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .map((line) => {
      const [ref, commit, createdAt, subject] = line.split(REF_FIELD_SEPARATOR);
      return {
        ref,
        commit,
        createdAt: createdAt || null,
        label: (subject || '').replace(/^checkpoint:\s*/, '') || DEFAULT_CHECKPOINT_LABEL,
      };
    });
}

/**
 * Restores the working tree to a checkpoint snapshot without touching the real
 * index, then removes untracked files that the AI created after the snapshot.
 *
 * Files captured by the checkpoint are always restored; files that are
 * untracked now but absent from the snapshot are deleted. Used by the Git
 * routes module to implement "undo AI run".
 */
export async function restoreCheckpoint(
  input: CheckpointDependencies & { ref: string },
): Promise<{ removedUntracked: string[] }> {
  const ref = input.ref.trim();
  if (!ref || ref.includes('\0') || /\s/.test(ref)) {
    throw new Error('Invalid checkpoint reference');
  }

  // Only allow refs under our own namespace or bare commit hashes; never a
  // branch, tag, or arbitrary revision the caller might smuggle in.
  const isCheckpointRef = ref.startsWith(CHECKPOINT_REF_PREFIX);
  const isCommitHash = /^[0-9a-f]{7,40}$/i.test(ref);
  if (!isCheckpointRef && !isCommitHash) {
    throw new Error('Invalid checkpoint reference');
  }

  const { stdout: snapshotFilesOutput } = await input.runCommand(
    'git',
    ['ls-tree', '-r', '--name-only', ref],
    { cwd: input.projectPath },
  );
  const snapshotFiles = new Set(
    snapshotFilesOutput.split('\n').filter((file) => file.length > 0),
  );

  await input.runCommand('git', ['restore', `--source=${ref}`, '--worktree', '--', '.'], {
    cwd: input.projectPath,
  });

  const { stdout: untrackedOutput } = await input.runCommand(
    'git',
    ['ls-files', '--others', '--exclude-standard'],
    { cwd: input.projectPath },
  );
  const createdByAi = untrackedOutput
    .split('\n')
    .map((file) => file.trim())
    .filter((file) => file.length > 0 && !snapshotFiles.has(file));

  const removedUntracked: string[] = [];
  for (const relativePath of createdByAi) {
    const absolutePath = path.resolve(input.projectPath, relativePath);
    // Defense-in-depth: never delete anything outside the project directory.
    const relative = path.relative(input.projectPath, absolutePath);
    if (relative.startsWith('..') || path.isAbsolute(relative)) {
      continue;
    }
    await rm(absolutePath, { force: true }).catch(() => undefined);
    removedUntracked.push(relativePath);
  }

  return { removedUntracked };
}
