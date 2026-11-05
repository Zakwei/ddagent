import { pipeline } from 'node:stream/promises';

import express from 'express';

import type { createDiskUsageService } from './disk-usage.service.js';
import { RESTART_EXIT_CODE, type createSystemUpdateService } from './system.service.js';

/** Id of the authenticated caller — picks their stored GitHub token. */
function userIdOf(request: express.Request): number {
  return (request as express.Request & { user?: { id: number } }).user?.id ?? 0;
}

/** Release tags the asset proxy serves: `v1.2.3`, optionally with a pre-release/build suffix. */
const RELEASE_TAG_PATTERN = /^v\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$/;

/** Plain asset file names only — no path separators. */
const RELEASE_ASSET_NAME_PATTERN = /^[A-Za-z0-9][A-Za-z0-9._+-]*$/;

/** First value of a header that a proxy may have sent once or as a list. */
function firstHeaderValue(value: string | string[] | undefined): string {
  const raw = Array.isArray(value) ? value[0] : value;
  return (raw ?? '').split(',')[0].trim();
}

/**
 * How the client reached this server, so asset download URLs point back at
 * it. `X-Forwarded-*` wins: the bundled web host (scripts/serve-flutter-web.cjs)
 * proxies /api with `Host: 127.0.0.1:<port>`. Null without a usable host.
 */
function assetProxyOf(request: express.Request) {
  const host = firstHeaderValue(request.headers['x-forwarded-host']) || request.get('host') || '';
  if (!/^[A-Za-z0-9.\-:[\]]+$/.test(host)) {
    return undefined;
  }
  const forwardedProto = firstHeaderValue(request.headers['x-forwarded-proto']);
  const protocol = forwardedProto === 'https' || forwardedProto === 'http' ? forwardedProto : request.protocol;
  const bearer = /^Bearer\s+(.+)$/i.exec(request.get('authorization') ?? '')?.[1];
  const queryToken = typeof request.query.token === 'string' ? request.query.token : undefined;
  return { origin: `${protocol}://${host}`, token: bearer ?? queryToken ?? null };
}

/** Creates thin system routes that delegate update execution to the service. */
export function createSystemRouter(
  systemUpdateService: ReturnType<typeof createSystemUpdateService>,
  diskUsageService: ReturnType<typeof createDiskUsageService>,
): express.Router {
  const router = express.Router();

  router.get('/latest-release', async (request, response, next) => {
    try {
      const user = (request as express.Request & { user?: { id: number } }).user;
      response.json(await systemUpdateService.getLatestRelease(user?.id ?? 0, assetProxyOf(request)));
    } catch (error) {
      next(error);
    }
  });

  // Streams a release asset (the app update APK/installer) from GitHub, so a
  // client only needs to reach this server — not resolve github.com.
  router.get('/release-asset', async (request, response, next) => {
    const tag = typeof request.query.tag === 'string' ? request.query.tag : '';
    const name = typeof request.query.name === 'string' ? request.query.name : '';
    if (!RELEASE_TAG_PATTERN.test(tag) || !RELEASE_ASSET_NAME_PATTERN.test(name)) {
      response.status(400).json({ error: 'Invalid release tag or asset name' });
      return;
    }
    const abort = new AbortController();
    response.on('close', () => abort.abort());
    try {
      const asset = await systemUpdateService.openReleaseAsset(userIdOf(request), tag, name, abort.signal);
      if (!asset) {
        response.status(404).json({ error: 'Release asset not found' });
        return;
      }
      response.setHeader('Content-Type', asset.contentType);
      response.setHeader('Content-Disposition', `attachment; filename="${name}"`);
      if (asset.contentLength !== null) {
        response.setHeader('Content-Length', String(asset.contentLength));
      }
      await pipeline(asset.body, response);
    } catch (error) {
      if (abort.signal.aborted) {
        return; // The client went away; nothing left to answer.
      }
      if (response.headersSent) {
        response.destroy(error instanceof Error ? error : undefined);
        return;
      }
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

  router.get('/disk', async (_request, response, next) => {
    try {
      response.json(await diskUsageService.getDiskUsage());
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
