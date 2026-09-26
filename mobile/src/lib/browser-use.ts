// Pure browser-use session model mirroring the web
// `src/components/browser-use/view/BrowserUsePanel.tsx` monitor. No React/RN
// imports so it can run under node in tests/self-check.mts.

export interface BrowserUseStatus {
  enabled: boolean;
  available: boolean;
  playwrightInstalled: boolean;
  chromiumInstalled: boolean;
  installInProgress: boolean;
  sessionCount?: number;
  message?: string;
}

export interface BrowserUseCursor {
  x: number;
  y: number;
  actor?: string | null;
}

export interface BrowserUseViewport {
  width: number;
  height: number;
}

export type BrowserUseSessionStatus = 'starting' | 'ready' | 'stopped' | 'unavailable' | string;

export interface BrowserUseSession {
  id: string;
  status: BrowserUseSessionStatus;
  title?: string | null;
  url?: string | null;
  lastAction?: string | null;
  updatedAt?: string | null;
  createdAt?: string | null;
  profile?: string | null;
  screenshotDataUrl?: string | null;
  cursor?: BrowserUseCursor | null;
  viewport?: BrowserUseViewport | null;
}

export const BROWSER_USE_POLL_MS = 6000;

function unwrap(payload: unknown): Record<string, unknown> {
  const p = (payload && typeof payload === 'object' ? payload : {}) as Record<string, unknown>;
  return (p.data && typeof p.data === 'object' ? p.data : p) as Record<string, unknown>;
}

export function parseBrowserUseStatus(payload: unknown): BrowserUseStatus {
  const d = unwrap(payload);
  return {
    enabled: d.enabled === true,
    available: d.available === true,
    playwrightInstalled: d.playwrightInstalled === true,
    chromiumInstalled: d.chromiumInstalled === true,
    installInProgress: d.installInProgress === true,
    sessionCount: typeof d.sessionCount === 'number' ? d.sessionCount : undefined,
    message: typeof d.message === 'string' ? d.message : undefined,
  };
}

function parseCursor(raw: unknown): BrowserUseCursor | null {
  if (!raw || typeof raw !== 'object') return null;
  const c = raw as Record<string, unknown>;
  const x = Number(c.x);
  const y = Number(c.y);
  if (!Number.isFinite(x) || !Number.isFinite(y)) return null;
  return { x, y, actor: typeof c.actor === 'string' ? c.actor : null };
}

function parseViewport(raw: unknown): BrowserUseViewport | null {
  if (!raw || typeof raw !== 'object') return null;
  const v = raw as Record<string, unknown>;
  const width = Number(v.width);
  const height = Number(v.height);
  if (!Number.isFinite(width) || !Number.isFinite(height) || width <= 0 || height <= 0) return null;
  return { width, height };
}

export function parseBrowserUseSessions(payload: unknown): BrowserUseSession[] {
  const d = unwrap(payload);
  const raw = Array.isArray(d.sessions) ? d.sessions : Array.isArray(payload) ? payload : [];
  return raw
    .map((entry): BrowserUseSession | null => {
      if (!entry || typeof entry !== 'object') return null;
      const e = entry as Record<string, unknown>;
      if (typeof e.id !== 'string') return null;
      return {
        id: e.id,
        status: typeof e.status === 'string' ? e.status : 'ready',
        title: typeof e.title === 'string' ? e.title : null,
        url: typeof e.url === 'string' ? e.url : null,
        lastAction: typeof e.lastAction === 'string' ? e.lastAction : null,
        updatedAt: typeof e.updatedAt === 'string' ? e.updatedAt : null,
        createdAt: typeof e.createdAt === 'string' ? e.createdAt : null,
        profile: typeof e.profile === 'string' ? e.profile : null,
        screenshotDataUrl: typeof e.screenshotDataUrl === 'string' ? e.screenshotDataUrl : null,
        cursor: parseCursor(e.cursor),
        viewport: parseViewport(e.viewport),
      };
    })
    .filter((s): s is BrowserUseSession => s !== null);
}

export function needsBrowserBinaries(status: BrowserUseStatus | null): boolean {
  if (!status) return false;
  return !status.playwrightInstalled || !status.chromiumInstalled;
}

export type RuntimeLabelKey = 'disabled' | 'installing' | 'ready' | 'setupRequired';

export function runtimeLabelKey(status: BrowserUseStatus | null): RuntimeLabelKey {
  if (!status || !status.enabled) return 'disabled';
  if (status.installInProgress) return 'installing';
  if (status.available && status.playwrightInstalled && status.chromiumInstalled) return 'ready';
  return 'setupRequired';
}

export type StatusTone = 'ready' | 'busy' | 'stopped' | 'error' | 'neutral';

export function statusTone(status: string): StatusTone {
  if (status === 'ready') return 'ready';
  if (status === 'starting') return 'busy';
  if (status === 'stopped') return 'stopped';
  if (status === 'unavailable') return 'error';
  return 'neutral';
}

export function getDomain(url: string | null | undefined): string {
  if (!url) return '';
  try {
    const host = new URL(url).hostname;
    if (host) return host;
  } catch {
    // fall through to regex
  }
  const m = /^[a-z]+:\/\/([^/?#]+)/i.exec(url);
  return m ? m[1] : url;
}

export function formatAction(raw: string | null | undefined): string {
  if (!raw) return '';
  return raw.replace(/_/g, ' ').replace(':', ': ');
}

export function formatRelativeTime(
  iso: string | null | undefined,
  now: number = Date.now(),
): { key: string; count: number } | null {
  if (!iso) return null;
  const ts = Date.parse(iso);
  if (!Number.isFinite(ts)) return null;
  const diff = Math.max(0, now - ts);
  const sec = Math.floor(diff / 1000);
  if (sec < 10) return { key: 'relative.justNow', count: 0 };
  if (sec < 60) return { key: 'relative.secondsAgo', count: sec };
  const min = Math.floor(sec / 60);
  if (min < 60) return { key: 'relative.minutesAgo', count: min };
  const hr = Math.floor(min / 60);
  if (hr < 24) return { key: 'relative.hoursAgo', count: hr };
  const day = Math.floor(hr / 24);
  return { key: 'relative.daysAgo', count: day };
}

export function cursorPercent(
  cursor: BrowserUseCursor | null | undefined,
  viewport: BrowserUseViewport | null | undefined,
): { left: number; top: number } | null {
  if (!cursor || !viewport) return null;
  if (!Number.isFinite(viewport.width) || !Number.isFinite(viewport.height)) return null;
  if (viewport.width <= 0 || viewport.height <= 0) return null;
  const left = Math.max(0, Math.min(100, (cursor.x / viewport.width) * 100));
  const top = Math.max(0, Math.min(100, (cursor.y / viewport.height) * 100));
  return { left, top };
}

export function sessionLabel(session: BrowserUseSession): string {
  if (session.title && session.title.trim()) return session.title.trim();
  const domain = getDomain(session.url);
  return domain || session.id;
}
