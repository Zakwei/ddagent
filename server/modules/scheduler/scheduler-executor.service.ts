import { projectsDb, type Schedule } from '@/modules/database/index.js';
import type { LLMProvider } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

export type SchedulerRunDeps = {
  createAppSession(provider: LLMProvider, projectPath: string, prompt: string): { sessionId: string };
  startRun(input: {
    sessionId: string;
    provider: LLMProvider;
    cwd: string;
    prompt: string;
  }): Promise<void>;
  createWorktree(input: { projectPath: string; branch: string }): Promise<{ worktreePath: string }>;
};

/**
 * Fires one schedule: resolve the project, optionally carve out a fresh
 * worktree, create the app session, then launch the provider run. Throws on
 * failure — the scheduler service records it and bumps the fail counter.
 */
export async function executeSchedule(
  schedule: Schedule,
  deps: SchedulerRunDeps,
): Promise<{ sessionId: string }> {
  const projectPath = projectsDb.getProjectPathById(schedule.projectId);
  if (!projectPath) {
    throw new AppError(`Schedule ${schedule.id}: project not found`, {
      code: 'PROJECT_NOT_FOUND',
      statusCode: 404,
    });
  }

  let cwd = projectPath;
  if (schedule.useWorktree) {
    const stamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const worktree = await deps.createWorktree({
      projectPath,
      branch: `sched-${schedule.id.slice(0, 8)}-${stamp}`,
    });
    cwd = worktree.worktreePath;
  }

  const provider = schedule.provider as LLMProvider;
  const { sessionId } = deps.createAppSession(provider, cwd, schedule.prompt);
  await deps.startRun({ sessionId, provider, cwd, prompt: schedule.prompt });
  return { sessionId };
}
