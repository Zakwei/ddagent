import express from 'express';

import { RESTART_EXIT_CODE, type createSystemUpdateService } from './system.service.js';

/** Id of the authenticated caller — picks their stored GitHub token. */
function userIdOf(request: express.Request): number {
  return (request as express.Request & { user?: { id: number } }).user?.id ?? 0;
}

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

  router.get('/update-info', (_request, response) => {
    response.json(systemUpdateService.getUpdateInfo());
  });

  router.post('/restart', (_request, response) => {
    // A supervising launcher (systemd, the bundled start script) starts the
    // process again when it exits with RESTART_EXIT_CODE, so exiting is a
    // self-restart. Otherwise report that restart is unsupported and keep running.
    const restarting = systemUpdateService.getUpdateInfo().server.supervised;
    response.json({ restarting });
    if (restarting) {
      setTimeout(() => process.exit(RESTART_EXIT_CODE), 500).unref();
    }
  });

  router.post('/update', async (request, response, next) => {
    try {
      const result = await systemUpdateService.updateSystem(userIdOf(request));
      // Hand off to the new code by exiting when something restarts us; an
      // update that found nothing newer has nothing to hand off.
      const restarting = Boolean(
        result.success && !('upToDate' in result && result.upToDate)
          && systemUpdateService.getUpdateInfo().server.supervised,
      );
      response.status(result.success ? 200 : 500).json({ ...result, restarting });
      if (restarting) {
        setTimeout(() => process.exit(RESTART_EXIT_CODE), 1000).unref();
      }
    } catch (error) {
      next(error);
    }
  });

  router.post('/update-web', async (request, response, next) => {
    try {
      const result = await systemUpdateService.updateWebClient(userIdOf(request));
      response.status(result.success ? 200 : 500).json(result);
    } catch (error) {
      next(error);
    }
  });

  return router;
}
