import express from 'express';

import type { createSystemUpdateService } from './system.service.js';

/** Creates thin system routes that delegate update execution to the service. */
export function createSystemRouter(
  systemUpdateService: ReturnType<typeof createSystemUpdateService>,
): express.Router {
  const router = express.Router();

  router.get('/latest-release', async (request, response, next) => {
    try {
      const user = (request as express.Request & { user?: { id: number } }).user;
      response.json(await systemUpdateService.getLatestRelease(user?.id ?? 0));
    } catch (error) {
      next(error);
    }
  });

  router.get('/releases', async (request, response, next) => {
    try {
      const user = (request as express.Request & { user?: { id: number } }).user;
      response.json(await systemUpdateService.listReleases(user?.id ?? 0));
    } catch (error) {
      next(error);
    }
  });

  router.post('/restart', (_request, response) => {
    // Under systemd (INVOCATION_ID is set) the watchdog in start-ddagent.sh
    // brings the process back, so exiting is a self-restart. Otherwise report
    // that restart is unsupported and keep running.
    const restarting = Boolean(process.env.INVOCATION_ID);
    response.json({ restarting });
    if (restarting) {
      setTimeout(() => process.exit(0), 500).unref();
    }
  });

  router.post('/update', async (_request, response, next) => {
    try {
      const result = await systemUpdateService.updateSystem();
      // Under systemd (INVOCATION_ID is set) a watchdog brings the process back,
      // so a successful update can hand off to the new code by exiting.
      const restarting = Boolean(result.success && process.env.INVOCATION_ID);
      response.status(result.success ? 200 : 500).json({ ...result, restarting });
      if (restarting) {
        setTimeout(() => process.exit(0), 1000).unref();
      }
    } catch (error) {
      next(error);
    }
  });

  return router;
}
