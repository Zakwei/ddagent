import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { once } from 'node:events';
import { mkdir, mkdtemp, readFile, rm } from 'node:fs/promises';
import type { AddressInfo } from 'node:net';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import express, {
  type NextFunction,
  type Request,
  type Response,
} from 'express';

import { openWorktreeAsProject } from '@/modules/worktrees/services/worktree-open.service.js';
import {
  parseWorktreeConfigFileContent,
  resolveWorktreeScripts,
  saveWorktreeScriptsConfig,
} from '@/modules/worktrees/services/worktree-config.service.js';
import {
  createWorktreeProcessRunner,
  getWorktreeScriptStatus,
} from '@/modules/worktrees/services/worktree-processes.service.js';
import { createWorktreesRouter } from '@/modules/worktrees/worktrees.routes.js';
import type {
  GitCommandResult,
  ProjectRepositoryRow,
  WorktreeScriptProcess,
  WorktreeServices,
  WorktreeScriptsConfig,
  WorktreeScriptsConfigResult,
} from '@/shared/types.js';
import { AppError, normalizeProjectPath } from '@/shared/utils.js';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

const IS_WINDOWS = process.platform === 'win32';

/**
 * Real-process spawner matching the WorktreeScriptProcess contract without
 * pulling in node-pty — `detached` makes the child a process-group leader on
 * POSIX, exactly what the runner's group-kill relies on.
 */
function spawnViaChildProcess(script: string, cwd: string): WorktreeScriptProcess {
  const child = IS_WINDOWS
    ? spawn('powershell.exe', ['-Command', script], { cwd })
    : spawn('bash', ['-c', script], { cwd, detached: true });

  return {
    pid: child.pid ?? -1,
    onData(listener) {
      child.stdout?.on('data', (data: Buffer) => listener(data.toString()));
      child.stderr?.on('data', (data: Buffer) => listener(data.toString()));
    },
    onExit(listener) {
      child.on('exit', (code, signal) =>
        listener({ exitCode: code ?? -1, signal: signal ?? undefined }));
    },
    kill(signal) {
      try {
        child.kill(signal as NodeJS.Signals);
      } catch {
        // Already dead.
      }
    },
  };
}

function fakeRunGit(listingPath: string) {
  const porcelain = [
    `worktree ${listingPath}`,
    'HEAD 1111111111111111111111111111111111111111',
    'branch refs/heads/main',
    '',
  ].join('\n');
  return async (): Promise<GitCommandResult> => ({ stdout: porcelain, stderr: '' });
}

function staticConfig(config: WorktreeScriptsConfig): () => Promise<WorktreeScriptsConfigResult> {
  return async () => ({ ...config, hasProjectOverride: false, hasRepoFile: true });
}

async function waitFor(predicate: () => boolean, timeoutMs = 15_000): Promise<void> {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    if (predicate()) {
      return;
    }
    await new Promise((resolve) => setTimeout(resolve, 50));
  }
  assert.ok(predicate(), 'timed out waiting for condition');
}

function processGroupAlive(pid: number): boolean {
  try {
    process.kill(-pid, 0);
    return true;
  } catch {
    return false;
  }
}

async function withTempDir(run: (dir: string) => Promise<void>): Promise<void> {
  const dir = await mkdtemp(path.join(os.tmpdir(), 'ddagent-worktree-scripts-'));
  try {
    await run(dir);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

async function withWorktreesServer(
  services: WorktreeServices,
  run: (baseUrl: string) => Promise<void>,
): Promise<void> {
  const app = express();
  app.use(express.json());
  app.use('/api/worktrees', createWorktreesRouter(services));
  app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (error instanceof AppError) {
      res.status(error.statusCode).json({ error: error.code });
      return;
    }
    res.status(500).json({ error: 'INTERNAL_ERROR' });
  });

  const server = app.listen(0, '127.0.0.1');
  await once(server, 'listening');
  try {
    const address = server.address() as AddressInfo;
    await run(`http://127.0.0.1:${address.port}`);
  } finally {
    await new Promise<void>((resolve, reject) => {
      server.close((error) => (error ? reject(error) : resolve()));
    });
  }
}

function createFakeServices(overrides: Partial<WorktreeServices>): WorktreeServices {
  const unused = async (): Promise<never> => {
    throw new Error('Unexpected Worktrees service call');
  };
  return {
    resolveProjectPath: () => {
      throw new Error('Unexpected project resolution');
    },
    list: unused,
    create: unused,
    createAndOpen: unused,
    open: unused,
    merge: unused,
    remove: unused,
    getScriptsStatus: unused,
    saveScriptsConfig: unused,
    startRun: unused,
    stopRun: unused,
    ...overrides,
  };
}

// ---------------------------------------------------------------------------
// Config parsing + resolution
// ---------------------------------------------------------------------------

test('parseWorktreeConfigFileContent reads valid fields and ignores junk', () => {
  const parsed = parseWorktreeConfigFileContent(
    JSON.stringify({ setup: ' npm i ', run: 'npm run dev', runPort: 5173, extra: true }),
  );
  assert.deepEqual(parsed, { setup: 'npm i', run: 'npm run dev', runPort: 5173 });
});

test('parseWorktreeConfigFileContent tolerates invalid input', () => {
  assert.equal(parseWorktreeConfigFileContent('not json'), null);
  assert.equal(parseWorktreeConfigFileContent('[1,2]'), null);
  assert.equal(parseWorktreeConfigFileContent('"str"'), null);
  // Malformed fields are dropped individually, not the whole file.
  assert.deepEqual(
    parseWorktreeConfigFileContent(JSON.stringify({ setup: 'ok', runPort: 70000 })),
    { setup: 'ok', run: null, runPort: null },
  );
});

test('resolveWorktreeScripts merges project override over the repo file', async () => {
  const repoFile = JSON.stringify({ setup: 'file-setup', run: 'file-run', runPort: 1111 });

  const resolved = await resolveWorktreeScripts('/repo', {
    readFile: async () => repoFile,
    getProjectOverride: () => ({ setup: null, run: 'override-run', runPort: null }),
  });

  assert.equal(resolved.setup, 'file-setup');
  assert.equal(resolved.run, 'override-run');
  assert.equal(resolved.runPort, 1111);
  assert.equal(resolved.hasProjectOverride, true);
  assert.equal(resolved.hasRepoFile, true);
});

test('resolveWorktreeScripts falls back cleanly when nothing is configured', async () => {
  const resolved = await resolveWorktreeScripts('/repo', {
    readFile: async () => null,
    getProjectOverride: () => null,
  });
  assert.deepEqual(resolved, {
    setup: null,
    run: null,
    runPort: null,
    hasProjectOverride: false,
    hasRepoFile: false,
  });
});

test('saveWorktreeScriptsConfig validates runPort and writes to the repo-root row', async () => {
  const saved: Array<{ path: string; config: WorktreeScriptsConfig }> = [];
  const deps = {
    runGit: fakeRunGit('/repo'),
    readFile: async () => null,
    getProjectOverride: (p: string) => saved.find((s) => s.path === p)?.config ?? null,
    setProjectOverride: (p: string, c: WorktreeScriptsConfig) => {
      saved.push({ path: p, config: c });
    },
  };

  const result = await saveWorktreeScriptsConfig(
    { projectPath: '/repo', setup: '  npm ci ', run: 'npm run dev', runPort: 5173 },
    deps,
  );
  assert.deepEqual(saved, [
    { path: normalizeProjectPath('/repo'), config: { setup: 'npm ci', run: 'npm run dev', runPort: 5173 } },
  ]);
  assert.equal(result.setup, 'npm ci');

  await assert.rejects(
    saveWorktreeScriptsConfig(
      { projectPath: '/repo', setup: null, run: null, runPort: 99999 },
      deps,
    ),
    (error: unknown) => error instanceof AppError && error.statusCode === 400,
  );
});

// ---------------------------------------------------------------------------
// Setup hook + process runner
// ---------------------------------------------------------------------------

test('opening a worktree runs the setup script inside the worktree directory', async () => {
  await withTempDir(async (tmpDir) => {
    const repoRoot = normalizeProjectPath(path.join(tmpDir, 'repo'));
    const worktreePath = normalizeProjectPath(path.join(tmpDir, 'wt'));
    await mkdir(worktreePath, { recursive: true });
    const porcelain = [
      `worktree ${repoRoot}`,
      'HEAD 1111111111111111111111111111111111111111',
      'branch refs/heads/main',
      '',
      `worktree ${worktreePath}`,
      'HEAD 2222222222222222222222222222222222222222',
      'branch refs/heads/feature/x',
      '',
    ].join('\n');
    const runGit = async (): Promise<GitCommandResult> => ({ stdout: porcelain, stderr: '' });

    const runner = createWorktreeProcessRunner({
      spawn: spawnViaChildProcess,
      runGit,
      resolveConfig: staticConfig({ setup: 'echo ok > marker.txt', run: null, runPort: null }),
    });

    let projectRow: ProjectRepositoryRow | null = null;
    const project = await openWorktreeAsProject(
      { projectPath: repoRoot, worktreePath },
      {
        runGit,
        projects: {
          getProjectByPath: () => projectRow,
          createProject: async () => {
            projectRow = {
              project_id: 'p-1',
              project_path: worktreePath,
              custom_project_name: 'repo · feature/x',
              isStarred: 0,
              isArchived: 0,
            };
            return { outcome: 'created' as const, project: { projectId: 'p-1' } };
          },
          restoreProject: () => {
            throw new Error('unexpected restore');
          },
        },
        onWorktreeOpened: (context) => {
          void runner.startSetup(context);
        },
      },
    );

    assert.equal(project.projectId, 'p-1');
    await waitFor(() => runner.getRuntime(worktreePath).setup.status === 'done');
    const marker = await readFile(path.join(worktreePath, 'marker.txt'), 'utf8');
    assert.equal(marker.trim(), 'ok');
  });
});

test('opening the main worktree does not run the setup script', async () => {
  const repoRoot = normalizeProjectPath('/repo');
  const porcelain = [
    'worktree /repo',
    'HEAD 1111111111111111111111111111111111111111',
    'branch refs/heads/main',
    '',
  ].join('\n');
  const runGit = async (): Promise<GitCommandResult> => ({ stdout: porcelain, stderr: '' });

  let hookCalls = 0;
  const row: ProjectRepositoryRow = {
    project_id: 'p-main',
    project_path: repoRoot,
    custom_project_name: null,
    isStarred: 0,
    isArchived: 0,
  };

  await openWorktreeAsProject(
    { projectPath: repoRoot, worktreePath: repoRoot },
    {
      runGit,
      projects: {
        getProjectByPath: () => row,
        createProject: async () => {
          throw new Error('unexpected create');
        },
        restoreProject: () => {},
      },
      onWorktreeOpened: () => {
        hookCalls += 1;
      },
    },
  );

  assert.equal(hookCalls, 0);
});

test('runner startSetup records a failed status on non-zero exit', async () => {
  await withTempDir(async (tmpDir) => {
    const runner = createWorktreeProcessRunner({
      spawn: spawnViaChildProcess,
      runGit: fakeRunGit(tmpDir),
      resolveConfig: staticConfig({ setup: 'echo boom && exit 3', run: null, runPort: null }),
    });

    await runner.startSetup({ repositoryRoot: tmpDir, worktreePath: tmpDir });
    await waitFor(() => runner.getRuntime(tmpDir).setup.status === 'failed');

    const setup = runner.getRuntime(tmpDir).setup;
    assert.equal(setup.exitCode, 3);
    assert.ok(setup.logTail.some((line) => line.includes('boom')));
  });
});

test('runner startRun parses a localhost port from script output', async () => {
  await withTempDir(async (tmpDir) => {
    const runner = createWorktreeProcessRunner({
      spawn: spawnViaChildProcess,
      runGit: fakeRunGit(tmpDir),
      resolveConfig: staticConfig({
        setup: null,
        run: 'echo "Local: http://localhost:5199/" && sleep 30',
        runPort: null,
      }),
      killGraceMs: 200,
    });

    const initial = await runner.startRun({ worktreePath: tmpDir });
    assert.equal(initial.status, 'running');

    await waitFor(() => runner.getRuntime(tmpDir).run.port === 5199);
    const running = runner.getRuntime(tmpDir).run;
    assert.equal(running.url, 'http://localhost:5199/');

    runner.stopAll(tmpDir);
  });
});

test('runner prefers configured runPort over stdout parsing', async () => {
  await withTempDir(async (tmpDir) => {
    const runner = createWorktreeProcessRunner({
      spawn: spawnViaChildProcess,
      runGit: fakeRunGit(tmpDir),
      resolveConfig: staticConfig({
        setup: null,
        run: 'echo "http://localhost:5199" && sleep 30',
        runPort: 8080,
      }),
      killGraceMs: 200,
    });

    const state = await runner.startRun({ worktreePath: tmpDir });
    assert.equal(state.port, 8080);
    assert.equal(state.url, 'http://localhost:8080');

    runner.stopAll(tmpDir);
  });
});

test('runner startRun rejects when no run script is configured', async () => {
  await withTempDir(async (tmpDir) => {
    const runner = createWorktreeProcessRunner({
      spawn: spawnViaChildProcess,
      runGit: fakeRunGit(tmpDir),
      resolveConfig: staticConfig({ setup: null, run: null, runPort: null }),
    });

    await assert.rejects(
      runner.startRun({ worktreePath: tmpDir }),
      (error: unknown) =>
        error instanceof AppError && error.code === 'WORKTREE_RUN_NOT_CONFIGURED',
    );
  });
});

test('getWorktreeScriptStatus returns config plus per-worktree runtimes', async () => {
  await withTempDir(async (tmpDir) => {
    const runner = createWorktreeProcessRunner({
      spawn: spawnViaChildProcess,
      runGit: fakeRunGit(tmpDir),
      resolveConfig: staticConfig({ setup: null, run: 'sleep 30', runPort: 4321 }),
      killGraceMs: 200,
    });

    const status = await getWorktreeScriptStatus(
      { projectPath: tmpDir },
      {
        runGit: fakeRunGit(tmpDir),
        runner,
        resolveConfig: staticConfig({ setup: null, run: 'sleep 30', runPort: 4321 }),
      },
    );

    const key = normalizeProjectPath(tmpDir);
    assert.equal(status.scripts.run, 'sleep 30');
    assert.ok(key in status.runtimes);
    assert.equal(status.runtimes[key].setup.status, 'idle');
    assert.equal(status.runtimes[key].run.status, 'idle');
  });
});

// ---------------------------------------------------------------------------
// Run/stop routes
// ---------------------------------------------------------------------------

test('POST /:id/run spawns the script and POST /:id/stop kills the tree', async () => {
  await withTempDir(async (tmpDir) => {
    const spawnedPids: number[] = [];
    const runner = createWorktreeProcessRunner({
      spawn: (script, cwd) => {
        const proc = spawnViaChildProcess(script, cwd);
        spawnedPids.push(proc.pid);
        return proc;
      },
      runGit: fakeRunGit(tmpDir),
      resolveConfig: staticConfig({ setup: null, run: 'sleep 30', runPort: null }),
      killGraceMs: 200,
    });

    const services = createFakeServices({
      resolveProjectPath: (projectId) => {
        assert.equal(projectId, 'wt-1');
        return tmpDir;
      },
      startRun: ({ projectPath }) => runner.startRun({ worktreePath: projectPath }),
      stopRun: async ({ projectPath }) => runner.stopRun({ worktreePath: projectPath }),
    });

    await withWorktreesServer(services, async (baseUrl) => {
      const runResponse = await fetch(`${baseUrl}/api/worktrees/wt-1/run`, { method: 'POST' });
      const runPayload = (await runResponse.json()) as { data: { status: string } };
      assert.equal(runResponse.status, 200);
      assert.equal(runPayload.data.status, 'running');

      const stopResponse = await fetch(`${baseUrl}/api/worktrees/wt-1/stop`, { method: 'POST' });
      assert.equal(stopResponse.status, 200);

      await waitFor(() => runner.getRuntime(tmpDir).run.status === 'exited');
    });

    // The whole process group must be gone — a bare `proc.kill()` would leave
    // `sleep 30` orphaned for its full duration.
    if (!IS_WINDOWS) {
      assert.ok(spawnedPids.length > 0);
      await waitFor(() => !processGroupAlive(spawnedPids[0]));
    }
    runner.stopAll(tmpDir);
  });
});

test('GET /status and PUT /config round-trip through the router', async () => {
  let savedInput: unknown = null;
  const statusPayload = {
    scripts: { setup: 'npm i', run: 'npm run dev', runPort: 5173, hasProjectOverride: false, hasRepoFile: true },
    runtimes: {},
  };
  const services = createFakeServices({
    resolveProjectPath: () => '/repo',
    getScriptsStatus: async () => statusPayload,
    saveScriptsConfig: async (input) => {
      savedInput = input;
      return { setup: input.setup, run: input.run, runPort: input.runPort, hasProjectOverride: true, hasRepoFile: true };
    },
  });

  await withWorktreesServer(services, async (baseUrl) => {
    const statusResponse = await fetch(`${baseUrl}/api/worktrees/status?project=repo-1`);
    const statusBody = (await statusResponse.json()) as { data: typeof statusPayload };
    assert.equal(statusResponse.status, 200);
    assert.equal(statusBody.data.scripts.runPort, 5173);

    const putResponse = await fetch(`${baseUrl}/api/worktrees/config`, {
      method: 'PUT',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ project: 'repo-1', setup: 'npm ci', run: null, runPort: 8080 }),
    });
    const putBody = (await putResponse.json()) as { data: { hasProjectOverride: boolean } };
    assert.equal(putResponse.status, 200);
    assert.equal(putBody.data.hasProjectOverride, true);
  });

  assert.deepEqual(savedInput, {
    projectPath: '/repo',
    setup: 'npm ci',
    run: null,
    runPort: 8080,
  });
});
