/**
 * Browser-API polyfills so the web data layer (src/utils/api.js, stores,
 * WebSocket URL builders) runs unchanged in React Native.
 *
 * Import FIRST in index.ts, before any module that touches these globals.
 */

// localStorage — synchronous SQLite-backed implementation from expo-sqlite.
import 'expo-sqlite/localStorage/install';

import { getServerUrlSync } from './lib/server-config';

const g = globalThis as any;

// ---- window / location ----------------------------------------------------
// window.location is read lazily (per WS connect / fetch), so a getter that
// resolves the CURRENT configured server URL is enough — no reload needed
// after the user changes servers.
if (typeof g.window === 'undefined') {
  g.window = g;
}

const buildLocation = () => {
  const base = getServerUrlSync() || 'http://localhost';
  try {
    const u = new URL(base);
    return {
      protocol: u.protocol,
      host: u.host,
      hostname: u.hostname,
      port: u.port,
      origin: u.origin,
      href: u.href,
      pathname: '/',
    };
  } catch {
    return {
      protocol: 'http:',
      host: 'localhost',
      hostname: 'localhost',
      port: '',
      origin: 'http://localhost',
      href: 'http://localhost/',
      pathname: '/',
    };
  }
};

Object.defineProperty(g.window, 'location', {
  get: buildLocation,
  configurable: true,
});
// Some code reads globalThis.location directly.
Object.defineProperty(g, 'location', {
  get: buildLocation,
  configurable: true,
});

// ---- fetch: resolve '/api/...' style relative URLs against the server -----
const originalFetch = g.fetch.bind(g);
g.fetch = (input: any, init?: any) => {
  if (typeof input === 'string' && input.startsWith('/')) {
    const base = getServerUrlSync();
    if (base) {
      input = base + input;
    }
  }
  return originalFetch(input, init);
};

// ---- Event / CustomEvent / window event target ----------------------------
class PolyfillEvent {
  type: string;
  constructor(type: string) {
    this.type = type;
  }
}
class PolyfillCustomEvent extends PolyfillEvent {
  detail: unknown;
  constructor(type: string, init?: { detail?: unknown }) {
    super(type);
    this.detail = init?.detail;
  }
}
if (typeof g.Event === 'undefined') g.Event = PolyfillEvent;
if (typeof g.CustomEvent === 'undefined') g.CustomEvent = PolyfillCustomEvent;

const listeners = new Map<string, Set<(e: any) => void>>();
g.window.addEventListener = (type: string, cb: (e: any) => void) => {
  if (!listeners.has(type)) listeners.set(type, new Set());
  listeners.get(type)!.add(cb);
};
g.window.removeEventListener = (type: string, cb: (e: any) => void) => {
  listeners.get(type)?.delete(cb);
};
g.window.dispatchEvent = (event: any) => {
  listeners.get(event?.type)?.forEach((cb) => {
    try {
      cb(event);
    } catch (err) {
      console.error('window event listener error:', err);
    }
  });
  return true;
};
if (typeof g.addEventListener === 'undefined') g.addEventListener = g.window.addEventListener;
if (typeof g.removeEventListener === 'undefined') g.removeEventListener = g.window.removeEventListener;
if (typeof g.dispatchEvent === 'undefined') g.dispatchEvent = g.window.dispatchEvent;

// ---- atob / btoa (Hermes lacks them; api.js JWT claims parsing needs atob)
const B64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
if (typeof g.atob === 'undefined') {
  g.atob = (input: string) => {
    const str = input.replace(/=+$/, '');
    let output = '';
    let bc = 0;
    let bs = 0;
    for (const ch of str) {
      const idx = B64.indexOf(ch);
      if (idx === -1) continue;
      bs = (bs << 6) | idx;
      bc += 6;
      if (bc >= 8) {
        bc -= 8;
        output += String.fromCharCode((bs >> bc) & 0xff);
      }
    }
    return output;
  };
}
if (typeof g.btoa === 'undefined') {
  g.btoa = (input: string) => {
    let output = '';
    for (let i = 0; i < input.length; i += 3) {
      const a = input.charCodeAt(i);
      const b = i + 1 < input.length ? input.charCodeAt(i + 1) : NaN;
      const c = i + 2 < input.length ? input.charCodeAt(i + 2) : NaN;
      const n = (a << 16) | ((b || 0) << 8) | (c || 0);
      output += B64[(n >> 18) & 63] + B64[(n >> 12) & 63];
      output += isNaN(b) ? '=' : B64[(n >> 6) & 63];
      output += isNaN(c) ? '=' : B64[n & 63];
    }
    return output;
  };
}
