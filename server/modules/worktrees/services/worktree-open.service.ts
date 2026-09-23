import path from 'node:path';

import type {
  GitCommandRunner,
  OpenWorktreeInput,
  ProjectRepositoryRow,
  WorktreeProjectGateway,
  WorktreeProjectView,
} from '@/shared/types.js';
import { AppError, normalizeProjectPath } from '@/shared/utils.js';
import {
  findWorktreeEntryByPath,
  listWorktreePorcelainEntries,
} from '@/modules/worktrees/services/worktree-git.service.js';

function mapRowToProjectView(row: ProjectRepositoryRow): WorktreeProjectView {
  return {
    projectId: row.project_id,
    path: row.project_path,
    fullPath: row.project_path,
    displayName: row.custom_project_name || path.basename(row.project_path),
    isStarred: Boolean(row.isStarred),
    sessions: [],
    sessionMeta: { hasMore: false, total: 0 },
  };
}

/**
 * Ensures a ddagent project exists (and is active) for a worktree directory
 * and returns it, so the caller can switch the UI into that worktree.
 *
 * The path is only accepted when it is a registered worktree of the repository
 * that contains `projectPath` — this endpoint must never become a generic
 * "create project anywhere" backdoor.
 */
export async function openWorktreeAsProject(
  input: OpenWorktreeInput,
  dependencies: {
    runGit: GitCommandRunner;
    projects: Pick<
      WorktreeProjectGateway,
      'getProjectByPath' | 'createProject' | 'restoreProject'
    >;
    /**
     * Fired (fire-and-forget) once a non-main worktree is registered, before
     * the response is returned. The composition root uses it to kick off the
     * repository's configured setup script; exceptions are swallowed so a
     * broken hook can never break the open flow.
     */
    onWorktreeOpened?: (context: {
      repositoryRoot: string;
      worktreePath: string;
    }) => void;
  },
): Promise<WorktreeProjectView> {
  const { projects, runGit } = dependencies;
  const entries = await listWorktreePorcelainEntries(input.projectPath, runGit);
  const entry = findWorktreeEntryByPath(entries, input.worktreePath);
  const repositoryRoot = entries[0].path;
  // Setup scripts are worktree-scoped — the main checkout must never run them
  // (it is the user's primary working directory, not a spawned workspace).
  const isMainWorktree = entry === entries[0];

  const normalizedWorktreePath = normalizeProjectPath(entry.path);
  const repoName = path.basename(repositoryRoot);
  // "repo · branch" keeps worktree projects visually grouped next to their
  // parent repository in the sidebar.
  const displayName = entry.branch ? `${repoName} · ${entry.branch}` : repoName;

  const fireOpenedHook = () => {
    if (isMainWorktree) {
      return;
    }
    try {
      dependencies.onWorktreeOpened?.({ repositoryRoot, worktreePath: normalizedWorktreePath });
    } catch (hookError) {
      console.error('[Worktrees] onWorktreeOpened hook failed:', hookError);
    }
  };

  const existingRow = projects.getProjectByPath(normalizedWorktreePath);
  if (existingRow) {
    if (existingRow.isArchived) {
      await projects.restoreProject(existingRow.project_id);
    }
    const refreshedRow = projects.getProjectByPath(normalizedWorktreePath) ?? existingRow;
    const view = mapRowToProjectView(refreshedRow);
    fireOpenedHook();
    return view;
  }

  const created = await projects.createProject({
    projectPath: normalizedWorktreePath,
    customName: displayName,
  });

  // `createProject` intentionally keeps reactivated archived rows archived;
  // an opened worktree must be active so it shows up in the sidebar.
  if (created.outcome === 'reactivated_archived') {
    await projects.restoreProject(created.project.projectId);
  }

  const row = projects.getProjectByPath(normalizedWorktreePath);
  if (!row) {
    throw new AppError('Failed to resolve project for worktree', {
      code: 'WORKTREE_PROJECT_RESOLVE_FAILED',
      statusCode: 500,
    });
  }

  const view = mapRowToProjectView(row);
  fireOpenedHook();
  return view;
}
