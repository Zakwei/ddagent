function compareVersions(a: string, b: string): number {
  const pa = a.split('.').map(Number);
  const pb = b.split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i += 1) {
    const x = pa[i] || 0;
    const y = pb[i] || 0;
    if (x !== y) return x - y;
  }
  return 0;
}

export function stripVersionTag(tag: string): string {
  return tag.replace(/^v/, '');
}

/**
 * Local copy of `about.ts` `releaseRelation` so this module stays a
 * self-contained pure module (Node ESM cannot resolve an extensionless
 * relative import when the self-check runner loads it).
 */
export function releaseRelation(tag: string, currentVersion: string): 'current' | 'newer' | 'older' {
  const cmp = compareVersions(stripVersionTag(tag), currentVersion);
  if (cmp === 0) return 'current';
  return cmp > 0 ? 'newer' : 'older';
}

export const HEALTH_POLL_INTERVAL_MS = 2000;
export const RUNNING_POLL_INTERVAL_MS = 5000;
export const RUNNING_BADGE_CAP = 99;

export type LatestReleasePayload = {
  release?: { tagName?: string | null } | null;
  tagName?: string | null;
};

/** `/api/system/latest-release` nests under `release` (not `tagName`). */
export function parseLatestReleaseTag(payload: LatestReleasePayload | null | undefined): string | null {
  if (!payload || typeof payload !== 'object') return null;
  const tag = payload.release?.tagName ?? payload.tagName;
  return typeof tag === 'string' && tag.length > 0 ? tag : null;
}

/** Version reported by `GET /health` (running server version). */
export function parseHealthVersion(payload: unknown): string | null {
  if (!payload || typeof payload !== 'object') return null;
  const version = (payload as { version?: unknown }).version;
  return typeof version === 'string' && version.length > 0 ? version : null;
}

/** The bundled app version, from `expo-constants` (app.json `version`). */
export function parseAppVersion(payload: unknown): string | null {
  if (!payload || typeof payload !== 'object') return null;
  const version = (payload as { version?: unknown }).version;
  return typeof version === 'string' && version.length > 0 ? version : null;
}

/** True when the latest release is strictly newer than the running version. */
export function isUpdateAvailable(latestTag: string | null, currentVersion: string | null): boolean {
  if (!latestTag || !currentVersion) return false;
  return releaseRelation(latestTag, currentVersion) === 'newer';
}

/** True when the server is running a different (older) version than bundled. */
export function isRestartRequired(healthVersion: string | null, appVersion: string | null): boolean {
  if (!healthVersion || !appVersion) return false;
  return stripVersionTag(healthVersion) !== stripVersionTag(appVersion);
}

export type RunningSessionsPayload = {
  data?: { sessions?: Array<{ sessionId?: string }> };
  sessions?: Array<{ sessionId?: string }>;
};

/** Extracts running session ids from the `sessions/running` envelope. */
export function parseRunningSessionIds(payload: RunningSessionsPayload | null | undefined): string[] {
  const sessions = payload?.data?.sessions ?? payload?.sessions;
  if (!Array.isArray(sessions)) return [];
  return sessions
    .map((session) => (session && typeof session.sessionId === 'string' ? session.sessionId : null))
    .filter((id): id is string => id !== null);
}

/** Badge label cap (`99+`). `0` means "no badge". */
export function runningBadgeLabel(count: number): string | null {
  if (!Number.isFinite(count) || count <= 0) return null;
  return count > RUNNING_BADGE_CAP ? `${RUNNING_BADGE_CAP}+` : String(count);
}

/** Human label for the update banner, e.g. `v0.6.0`. */
export function formatUpdateVersion(tag: string): string {
  return `v${stripVersionTag(tag)}`;
}
