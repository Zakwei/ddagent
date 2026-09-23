import type { LLMProvider } from '@/shared/types.js';
import { schedulesDb } from '@/modules/database/index.js';
import { sessionsService, providerRuntimeService } from '@/modules/providers/index.js';
import { worktreeServices } from '@/modules/worktrees/index.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';

import { createSchedulerService } from './scheduler.service.js';
import { executeSchedule } from './scheduler-executor.service.js';
import { createSchedulerRouter } from './scheduler.routes.js';

/**
 * Launches a scheduled prompt without a browser attached. Mirrors the Kanban
 * run path: a no-op connection is enough — events are buffered by the run
 * registry so a user opening the session sees the live transcript.
 */
async function startScheduledRun(input: {
  sessionId: string;
  provider: LLMProvider;
  cwd: string;
  prompt: string;
}): Promise<void> {
  const connection = {
    readyState: 0,
    send: () => {
      /* events reach clients through the run buffer and REST history */
    },
  };

  const run = chatRunRegistry.startRun({
    appSessionId: input.sessionId,
    provider: input.provider,
    providerSessionId: null,
    connection,
    userId: null,
  });
  if (!run) {
    throw new Error(`run already in progress for session ${input.sessionId}`);
  }

  // Scheduled runs are unattended — nothing can answer a permission prompt.
  const runtimeOptions = {
    sessionId: input.sessionId,
    cwd: input.cwd,
    projectPath: input.cwd,
    permissionMode: 'bypassPermissions',
  };

  try {
    await providerRuntimeService.run(input.provider, input.prompt, runtimeOptions, run.writer);
  } finally {
    chatRunRegistry.completeRunIfCurrent(run, { exitCode: 1 });
  }
}

export const schedulerService = createSchedulerService({
  store: schedulesDb,
  execute: (schedule) =>
    executeSchedule(schedule, {
      createAppSession: (provider, projectPath, prompt) =>
        sessionsService.createAppSession(provider, projectPath, prompt),
      startRun: startScheduledRun,
      createWorktree: (input) => worktreeServices.create(input),
    }),
});

export const schedulerRoutes = createSchedulerRouter();
