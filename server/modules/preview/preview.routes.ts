import express from 'express';

import { isAllowedPreviewPort, type createPreviewProxy } from './preview-proxy.service.js';
import type { createPortDiscoveryService } from './preview.service.js';

type PortDiscoveryService = ReturnType<typeof createPortDiscoveryService>;
type PreviewProxy = ReturnType<typeof createPreviewProxy>;

/**
 * Cookie the iframe flow uses to carry the JWT past `authenticateToken` on
 * subresource requests: the pane opens `/api/preview/<port>/?token=<jwt>`,
 * this middleware stores it, and subsequent same-origin requests authenticate
 * by cookie. (Requires the auth middleware cookie fallback — see index.ts.)
 */
const PREVIEW_AUTH_COOKIE = 'ddagent_preview_token';

function persistQueryTokenAsCookie(
  request: express.Request,
  response: express.Response,
  next: express.NextFunction,
): void {
  const token = request.query.token;
  if (typeof token === 'string' && token) {
    response.append('Set-Cookie', `${PREVIEW_AUTH_COOKIE}=${encodeURIComponent(token)}; Path=/api/preview; HttpOnly; SameSite=Lax`);
  }
  next();
}

/** Creates thin preview routes: port listing + reverse proxy to localhost. */
export function createPreviewRouter(
  portDiscoveryService: PortDiscoveryService,
  previewProxy: PreviewProxy,
): express.Router {
  const router = express.Router();

  router.use(persistQueryTokenAsCookie);

  router.get('/ports', async (request, response, next) => {
    try {
      const projectPath = typeof request.query.projectPath === 'string' && request.query.projectPath
        ? request.query.projectPath
        : undefined;
      response.json({ ports: await portDiscoveryService.listListeningPorts(projectPath) });
    } catch (error) {
      next(error);
    }
  });

  // /<port>[/<path>] — the numeric regex keeps /ports and non-numeric segments
  // from being treated as ports.
  router.all(/^\/(\d+)(\/.*)?$/, (request, response) => {
    const port = Number.parseInt(request.params[0], 10);
    if (!isAllowedPreviewPort(port)) {
      response.status(403).json({ error: 'Port is not allowed for preview' });
      return;
    }

    // Route params match the path only — the query string lives on req.url.
    // `token` is consumed by authenticateToken and must not reach upstream.
    const remainder = request.params[1] ?? '/';
    const queryIndex = request.url.indexOf('?');
    const parsed = new URL(
      remainder + (queryIndex === -1 ? '' : request.url.slice(queryIndex)),
      'http://localhost',
    );
    parsed.searchParams.delete('token');
    const upstreamPath = parsed.pathname + parsed.search;

    // express.json()/urlencoded() already drained bodies they could parse —
    // hand the proxy a re-serialized buffer so the upstream still gets them.
    // ponytail: urlencoded bodies are re-encoded flat; nested-field uploads
    // through the proxy are out of scope.
    const declaredBody =
      request.headers['transfer-encoding'] !== undefined ||
      Number(request.headers['content-length']) > 0;
    let body: Buffer | null = null;
    if (declaredBody && request.body && typeof request.body === 'object') {
      const contentType = String(request.headers['content-type'] ?? '');
      if (contentType.includes('application/x-www-form-urlencoded')) {
        body = Buffer.from(new URLSearchParams(request.body as Record<string, string>).toString());
      } else {
        body = Buffer.from(JSON.stringify(request.body));
      }
    }

    previewProxy.handleRequest(request, response, {
      port,
      upstreamPath,
      body,
    });
  });

  return router;
}
