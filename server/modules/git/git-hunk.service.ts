import path from 'node:path';

/**
 * One hunk selected by the client. `filePath` is a repository-relative path and
 * `hunkIndex` is the zero-based position of an `@@` hunk inside the unified
 * diff the client rendered.
 */
export type GitHunkSelection = { filePath: string; hunkIndex: number };

/** Result of a `git` invocation, matching the Git routes' `spawnAsync`. */
type GitHunkCommandResult = {
  stdout: string;
  stderr: string;
};

/**
 * Minimal `git` runner contract for hunk staging. Unlike the checkpoint runner
 * it also accepts `input`, which is written to the child's stdin — `git apply`
 * reads the patch from stdin.
 */
type GitHunkRunner = (
  command: string,
  args: string[],
  options: { cwd: string; input?: string },
) => Promise<GitHunkCommandResult>;

type ApplyGitHunksInput = {
  repositoryRootPath: string;
  filePath: string;
  diff: string;
  hunkIndices: number[];
  runGit: GitHunkRunner;
};

/**
 * Rejects a `filePath` that escapes `repositoryRootPath`. The Git routes guard
 * every user-supplied path the same way before running `git`; hunk staging must
 * not become a hole that writes to the index outside the repository.
 */
function assertPathInsideRepository(repositoryRootPath: string, filePath: string): void {
  if (!filePath || filePath.includes('\0')) {
    throw new Error('Invalid file path');
  }

  const resolvedRoot = path.resolve(repositoryRootPath);
  const resolvedPath = path.resolve(resolvedRoot, filePath);
  const relative = path.relative(resolvedRoot, resolvedPath);

  if (relative.startsWith('..') || path.isAbsolute(relative)) {
    throw new Error('Invalid file path: path traversal detected');
  }
}

/**
 * Builds a unified-diff patch containing only the selected hunks. File header
 * lines (`diff --git`, `index`, `---`, `+++`, rename/mode markers) are kept so
 * the result is a valid patch. Hunk bodies stay verbatim, so the retained
 * `@@ -old,+new @@` line numbers remain correct.
 *
 * Returns an empty string when no hunks are selected. Throws when a requested
 * index is not an in-range integer, so callers never apply a silently truncated
 * patch. Used by `stageHunks` / `unstageHunks` and unit tested directly.
 */
export function buildHunkPatch(diff: string, hunkIndices: number[]): string {
  if (!diff) {
    return '';
  }

  const lines = diff.split('\n');
  // A trailing newline produces a final empty element; drop it so hunk bodies
  // do not accumulate a stray blank line on every round trip.
  if (lines[lines.length - 1] === '') {
    lines.pop();
  }

  const headerLines: string[] = [];
  const hunks: Array<{ header: string; body: string[] }> = [];
  let currentHunk: { header: string; body: string[] } | null = null;

  for (const line of lines) {
    if (line.startsWith('@@')) {
      if (currentHunk) {
        hunks.push(currentHunk);
      }
      currentHunk = { header: line, body: [] };
      continue;
    }

    if (!currentHunk) {
      headerLines.push(line);
      continue;
    }

    currentHunk.body.push(line);
  }
  if (currentHunk) {
    hunks.push(currentHunk);
  }

  const selectedIndices = new Set<number>();
  for (const hunkIndex of hunkIndices) {
    if (!Number.isInteger(hunkIndex) || hunkIndex < 0 || hunkIndex >= hunks.length) {
      throw new Error(`Hunk index out of range: ${hunkIndex}`);
    }
    selectedIndices.add(hunkIndex);
  }

  if (selectedIndices.size === 0) {
    return '';
  }

  const patchLines = [...headerLines];
  hunks.forEach((hunk, index) => {
    if (selectedIndices.has(index)) {
      patchLines.push(hunk.header, ...hunk.body);
    }
  });

  return `${patchLines.join('\n')}\n`;
}

/**
 * Applies a hunk selection to the index. `extraArgs` selects forward staging
 * (`git apply --cached`) or reverse unstaging (`--reverse`).
 */
async function applyGitHunks(input: ApplyGitHunksInput, extraArgs: string[]): Promise<void> {
  assertPathInsideRepository(input.repositoryRootPath, input.filePath);

  if (!Array.isArray(input.hunkIndices) || input.hunkIndices.length === 0) {
    throw new Error('At least one hunk index is required');
  }

  const patch = buildHunkPatch(input.diff, input.hunkIndices);
  if (!patch.trim()) {
    throw new Error('No patch content to apply');
  }

  // `--unidiff-zero` is kept so zero-context patches (e.g. a diff generated
  // with `-U0`) still apply; with normal contextful diffs it is a no-op.
  await input.runGit('git', ['apply', '--cached', '--unidiff-zero', ...extraArgs, '-'], {
    cwd: input.repositoryRootPath,
    input: patch,
  });
}

/**
 * Stages only the selected hunks of a file into the git index, leaving the rest
 * of the working tree change unstaged. Used by the Git routes module's
 * `/api/git/stage-hunks` endpoint.
 */
export async function stageHunks(input: ApplyGitHunksInput): Promise<void> {
  await applyGitHunks(input, []);
}

/**
 * Unstages only the selected hunks of a file from the git index (reverse
 * apply), leaving the working tree untouched. Used by the Git routes module's
 * `/api/git/unstage-hunks` endpoint.
 */
export async function unstageHunks(input: ApplyGitHunksInput): Promise<void> {
  await applyGitHunks(input, ['--reverse']);
}
