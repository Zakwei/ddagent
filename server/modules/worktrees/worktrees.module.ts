import { access, readFile } from 'node:fs/promises';
import os from 'node:os';

// node-pty: the same spawn mechanism the shell websocket uses — a real TTY
// makes dev servers print their "Local: http://localhost:PORT" banners.
import pty from 'node-pty';

import { projectsDb } from '@/modules/database/index.js';
import {
  createProject,
  deleteOrArchiveProject,
  restoreArchivedProject,
} from '@/modules/projects/index.js';
import type {
  WorktreeFileSystem,
  WorktreeProjectGateway,
  WorktreeScriptSpawner,
  WorktreeServices,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';
import {
  resolveWorktreeScripts,
  saveWorktreeScriptsConfig,
} from '@/modules/worktrees/services/worktree-config.service.js';
import { createWorktree } from '@/modules/worktrees/services/worktree-create.service.js';
import { createAndOpenWorktree } from '@/modules/worktrees/services/worktree-create-and-open.service.js';
import { runGitCommand } from '@/modules/worktrees/services/worktree-git.service.js';
import { listWorktrees } from '@/modules/worktrees/services/worktree-list.service.js';
import { mergeWorktree } from '@/modules/worktrees/services/worktree-merge.service.js';
import { openWorktreeAsProject } from '@/modules/worktrees/services/worktree-open.service.js';
import {
  createWorktreeProcessRunner,
  getWorktreeScriptStatus,
} from '@/modules/worktrees/services/worktree-processes.service.js';
import { removeWorktree } from '@/modules/worktrees/services/worktree-remove.service.js';
import { createWorktreesRouter } from '@/modules/worktrees/worktrees.routes.js';

/**
 * Real filesystem adapter used only by Worktrees production composition.
 *
 * Services depend on the shared capability type and therefore cannot touch a
 * developer's filesystem unless this adapter is explicitly supplied.
 */
const worktreeFileSystem: WorktreeFileSystem = {
  async pathExists(candidatePath: string): Promise<boolean> {
    try {
      await access(candidatePath);
      return true;
    } catch {
      return false;
    }
  },
};

/**
 * Projects boundary for Worktrees production workflows.
 *
 * Imports are deliberately restricted to the Database and Projects barrel
 * files. No Worktrees service knows which repository or project service backs
 * these operations.
 */
const worktreeProjects: WorktreeProjectGateway = {
  getProjectPathById: (projectId) => projectsDb.getProjectPathById(projectId),
  getProjectByPath: (projectPath) => projectsDb.getProjectPath(projectPath),
  createProject: (input) => createProject(input),
  restoreProject: (projectId) => restoreArchivedProject(projectId),
  archiveProject: (projectId) => deleteOrArchiveProject(projectId, false),
};

/**
 * Production config sources for the worktree script workflows.
 *
 * Reads the repository's `.ddagent/worktree.json` and the project-row override
 * through the Database barrel — services stay free of SQL and fs details.
 */
const worktreeScriptConfigSources = {
  async readFile(absolutePath: string): Promise<string | null> {
    try {
      return await readFile(absolutePath, 'utf8');
    } catch {
      return null;
    }
  },
  getProjectOverride: (projectPath: string) => projectsDb.getWorktreeScriptConfig(projectPath),
};

const resolveWorktreeScriptConfig = (repositoryRoot: string) =>
  resolveWorktreeScripts(repositoryRoot, worktreeScriptConfigSources);

/**
 * Production spawner: runs scripts through the user's shell inside a pty.
 * node-pty children are session leaders on POSIX, which lets the runner kill
 * the whole process tree on stop.
 */
const spawnWorktreeScript: WorktreeScriptSpawner = (script, cwd) => {
  const isWindows = os.platform() === 'win32';
  const shell = isWindows ? 'powershell.exe' : process.env.SHELL || 'bash';
  const shellArgs = isWindows ? ['-Command', script] : ['-c', script];
  return pty.spawn(shell, shellArgs, {
    name: 'xterm-256color',
    cols: 120,
    rows: 30,
    cwd,
    env: { ...process.env },
  });
};

/**
 * Process runner shared by the open/create hooks (setup) and the run/stop
 * routes. One in-memory registry per server process — spawned scripts die
 * with the server anyway.
 */
const worktreeProcessRunner = createWorktreeProcessRunner({
  spawn: spawnWorktreeScript,
  runGit: runGitCommand,
  resolveConfig: resolveWorktreeScriptConfig,
});

const startSetupScript = (context: { repositoryRoot: string; worktreePath: string }) => {
  void worktreeProcessRunner.startSetup(context).catch((error) => {
    console.error('[Worktrees] Setup script failed to start:', error);
  });
};

const remove: WorktreeServices['remove'] = (input) => {
  // Stop any setup/run process before git deletes the directory — a dev
  // server holding the worktree cwd could otherwise outlive its files.
  worktreeProcessRunner.stopAll(input.worktreePath);
  return removeWorktree(input, {
    runGit: runGitCommand,
    projects: worktreeProjects,
  });
};

const create: WorktreeServices['create'] = (input) => createWorktree(input, {
  runGit: runGitCommand,
  fileSystem: worktreeFileSystem,
  onWorktreeCreated: startSetupScript,
});

const open: WorktreeServices['open'] = (input) => openWorktreeAsProject(input, {
  runGit: runGitCommand,
  projects: worktreeProjects,
  onWorktreeOpened: startSetupScript,
});

/**
 * Production Worktrees application-service surface.
 *
 * This is the module's composition root: it is the only location that combines
 * concrete adapters with the independently testable workflow functions.
 */
export const worktreeServices: WorktreeServices = {
  resolveProjectPath(projectId) {
    const projectPath = worktreeProjects.getProjectPathById(projectId);
    if (!projectPath) {
      throw new AppError(`Unable to resolve project path for "${projectId}"`, {
        code: 'PROJECT_NOT_FOUND',
        statusCode: 404,
      });
    }

    return projectPath;
  },
  list: (input) => listWorktrees(input, {
    runGit: runGitCommand,
    getProjectByPath: worktreeProjects.getProjectByPath,
  }),
  create,
  createAndOpen: (input) => createAndOpenWorktree(input, {
    createWorktree: create,
    openWorktree: open,
    removeWorktree: remove,
  }),
  open,
  merge: (input) => mergeWorktree(input, {
    runGit: runGitCommand,
    removeWorktree: remove,
  }),
  remove,
  getScriptsStatus: (input) => getWorktreeScriptStatus(input, {
    runGit: runGitCommand,
    runner: worktreeProcessRunner,
    resolveConfig: resolveWorktreeScriptConfig,
  }),
  saveScriptsConfig: (input) => saveWorktreeScriptsConfig(input, {
    runGit: runGitCommand,
    ...worktreeScriptConfigSources,
    setProjectOverride: (projectPath, config) =>
      projectsDb.setWorktreeScriptConfig(projectPath, config),
  }),
  startRun: (input) =>
    worktreeProcessRunner.startRun({ worktreePath: input.projectPath }),
  stopRun: (input) =>
    Promise.resolve(worktreeProcessRunner.stopRun({ worktreePath: input.projectPath })),
};

/**
 * Worktrees router mounted by the server entrypoint at `/api/worktrees`.
 *
 * It is assembled here so other modules consume only the Worktrees barrel and
 * cannot depend on route or service implementation files.
 */
export const worktreesRoutes = createWorktreesRouter(worktreeServices);
