import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import { Readable } from 'node:stream';

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.map': 'application/json',
  '.txt': 'text/plain; charset=utf-8',
  '.webmanifest': 'application/manifest+json',
  '.mp3': 'audio/mpeg',
  '.mp4': 'video/mp4',
  '.wasm': 'application/wasm',
};

// API and realtime routes are wired over IPC in a separate task — the custom
// scheme only serves static files, so these prefixes get a plain 404.
const NON_STATIC_PREFIXES = ['/api/', '/ws/', '/shell/'];
const NON_STATIC_ROUTES = ['/api', '/ws', '/shell'];

function isNonStaticRoute(pathname) {
  return NON_STATIC_ROUTES.includes(pathname)
    || NON_STATIC_PREFIXES.some((prefix) => pathname.startsWith(prefix));
}

function getRawPathname(requestUrl) {
  // `new URL().pathname` collapses ".." segments per WHATWG rules, which would
  // silently hide traversal attempts — slice the path out of the raw URL so
  // resolveDistPath can still reject them.
  const afterScheme = String(requestUrl).replace(/^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//, '');
  const pathStart = afterScheme.indexOf('/');
  if (pathStart === -1) return '/';
  return afterScheme.slice(pathStart).split(/[?#]/)[0] || '/';
}

export function resolveDistPath(distDir, pathname) {
  let decoded;
  try {
    decoded = decodeURIComponent(pathname);
  } catch {
    return null;
  }

  // Reject traversal outright — normalization alone would turn an attack into
  // a harmless in-dist path instead of a refused request.
  if (decoded.split(/[/\\]/).includes('..')) {
    return null;
  }

  const root = path.resolve(distDir);
  const resolved = path.resolve(root, decoded.replace(/^[/\\]+/, ''));
  if (resolved !== root && !resolved.startsWith(root + path.sep)) {
    return null;
  }
  return resolved;
}

export function createDistProtocolHandler({ distDir }) {
  const indexPath = path.join(distDir, 'index.html');

  return async (request) => {
    const pathname = getRawPathname(request.url);

    if (isNonStaticRoute(pathname)) {
      return new Response('Not found', { status: 404 });
    }

    let filePath = resolveDistPath(distDir, pathname);
    if (filePath === null) {
      return new Response('Forbidden', { status: 403 });
    }

    // SPA fallback: routes without a matching file serve index.html.
    let stat = await fsp.stat(filePath).catch(() => null);
    if (!stat?.isFile()) {
      filePath = indexPath;
      stat = await fsp.stat(filePath).catch(() => null);
      if (!stat?.isFile()) {
        return new Response('Not found', { status: 404 });
      }
    }

    const ext = path.extname(filePath).toLowerCase();
    const headers = {
      'Content-Type': MIME_TYPES[ext] || 'application/octet-stream',
      'Content-Length': String(stat.size),
    };
    if (ext === '.html') {
      // Matches the express.static behavior in server/services.ts — HTML must
      // never be cached so rebuilds and service worker updates take effect.
      headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
    }

    const body = request.method === 'HEAD'
      ? null
      : Readable.toWeb(fs.createReadStream(filePath));
    return new Response(body, { headers });
  };
}
