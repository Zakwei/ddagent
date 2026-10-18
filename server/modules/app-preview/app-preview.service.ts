import { randomUUID } from 'node:crypto';

import { connectedClients, WS_OPEN_STATE } from '@/modules/websocket/index.js';
import type {
  AppPreviewBroadcast,
  AppPreviewDevice,
  AppPreviewOrientation,
  AppPreviewPlatform,
  AppPreviewTarget,
  RegisterAppPreviewInput,
  UpdateAppPreviewInput,
} from '@/shared/types.js';
import { AppError, safeSocketSend } from '@/shared/utils.js';

/**
 * App preview registry.
 *
 * Agents register the URL of the app they are building (through the MCP
 * `preview_*` tools) and the Flutter "Preview" pane renders it inside a phone,
 * browser or desktop-window frame streamed from the server-side Chromium
 * (`browser-view` module). This service owns the list of targets, validates
 * platform/device choices against the device catalog, and broadcasts every
 * change over `/ws` so open panes follow the agent live.
 *
 * Targets are intentionally in-memory: they point at dev servers that do not
 * outlive a server restart.
 */

const MAX_TARGETS = 20;
const MAX_TITLE_LENGTH = 120;
const MAX_NOTE_LENGTH = 500;

const IOS_USER_AGENT =
  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1';
const IPAD_USER_AGENT =
  'Mozilla/5.0 (iPad; CPU OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1';
const ANDROID_USER_AGENT =
  'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Mobile Safari/537.36';
const ANDROID_TABLET_USER_AGENT =
  'Mozilla/5.0 (Linux; Android 14; SM-X910) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36';

/**
 * Device catalog. Ids are part of the MCP contract — the Flutter pane keeps a
 * matching list with the bezel geometry for each id, so add new entries on
 * both sides. The first device of each platform is that platform's default.
 */
const DEVICE_CATALOG: readonly AppPreviewDevice[] = [
  { id: 'iphone-15-pro', label: 'iPhone 15 Pro', platform: 'mobile', width: 393, height: 852, mobile: true, userAgent: IOS_USER_AGENT },
  { id: 'iphone-se', label: 'iPhone SE', platform: 'mobile', width: 375, height: 667, mobile: true, userAgent: IOS_USER_AGENT },
  { id: 'pixel-8', label: 'Pixel 8', platform: 'mobile', width: 412, height: 915, mobile: true, userAgent: ANDROID_USER_AGENT },
  { id: 'galaxy-s24', label: 'Galaxy S24', platform: 'mobile', width: 360, height: 780, mobile: true, userAgent: ANDROID_USER_AGENT },
  { id: 'ipad-pro-11', label: 'iPad Pro 11"', platform: 'mobile', width: 834, height: 1194, mobile: true, userAgent: IPAD_USER_AGENT },
  { id: 'android-tablet', label: 'Android tablet 10"', platform: 'mobile', width: 800, height: 1280, mobile: true, userAgent: ANDROID_TABLET_USER_AGENT },
  { id: 'web-laptop', label: 'Browser 1366×768', platform: 'web', width: 1366, height: 768, mobile: false, userAgent: null },
  { id: 'web-desktop', label: 'Browser 1920×1080', platform: 'web', width: 1920, height: 1080, mobile: false, userAgent: null },
  { id: 'desktop-window', label: 'Desktop window 1280×800', platform: 'desktop', width: 1280, height: 800, mobile: false, userAgent: null },
  { id: 'desktop-large', label: 'Desktop window 1440×900', platform: 'desktop', width: 1440, height: 900, mobile: false, userAgent: null },
];

const PLATFORMS: readonly AppPreviewPlatform[] = ['mobile', 'web', 'desktop'];
const ORIENTATIONS: readonly AppPreviewOrientation[] = ['portrait', 'landscape'];

// Insertion order == registration order, which is what eviction relies on.
const targets = new Map<string, AppPreviewTarget>();

function invalid(message: string): AppError {
  return new AppError(message, { code: 'APP_PREVIEW_INVALID_INPUT', statusCode: 400 });
}

function normalizeUrl(rawUrl: unknown): string {
  const trimmed = typeof rawUrl === 'string' ? rawUrl.trim() : '';
  if (!trimmed) {
    throw invalid('Preview "url" is required.');
  }
  // Agents often hand over "localhost:5173" straight from a dev-server log —
  // a bare host:port is not a scheme, so only a real `scheme:` prefix that is
  // not followed by a port number counts as one.
  const hasScheme = /^[a-zA-Z][a-zA-Z\d+\-.]*:(?!\d)/.test(trimmed);
  const withProtocol = hasScheme ? trimmed : `http://${trimmed}`;
  let parsed: URL;
  try {
    parsed = new URL(withProtocol);
  } catch {
    throw invalid(`Preview "url" is not a valid URL: ${trimmed}`);
  }
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    throw invalid('Preview "url" must use http or https.');
  }
  return parsed.toString();
}

function normalizePlatform(value: unknown, fallback: AppPreviewPlatform): AppPreviewPlatform {
  if (value === undefined || value === null || value === '') return fallback;
  const candidate = String(value).trim().toLowerCase();
  if ((PLATFORMS as readonly string[]).includes(candidate)) {
    return candidate as AppPreviewPlatform;
  }
  throw invalid(`Preview "platform" must be one of ${PLATFORMS.join(', ')}.`);
}

function normalizeOrientation(value: unknown, fallback: AppPreviewOrientation): AppPreviewOrientation {
  if (value === undefined || value === null || value === '') return fallback;
  const candidate = String(value).trim().toLowerCase();
  if ((ORIENTATIONS as readonly string[]).includes(candidate)) {
    return candidate as AppPreviewOrientation;
  }
  throw invalid(`Preview "orientation" must be one of ${ORIENTATIONS.join(', ')}.`);
}

/**
 * Resolves the device for a target. An explicit device wins and also decides
 * the platform (so `device: "pixel-8"` alone is enough); without one the
 * platform's default device is used. A device/platform mismatch is an error
 * rather than a silent correction so the agent learns the catalog.
 */
function resolveDevice(
  deviceValue: unknown,
  platformValue: unknown,
  fallbackPlatform: AppPreviewPlatform,
): { platform: AppPreviewPlatform; device: string | null } {
  const deviceId = typeof deviceValue === 'string' ? deviceValue.trim().toLowerCase() : '';
  if (!deviceId) {
    return { platform: normalizePlatform(platformValue, fallbackPlatform), device: null };
  }
  const device = DEVICE_CATALOG.find((entry) => entry.id === deviceId);
  if (!device) {
    throw invalid(
      `Unknown preview device "${deviceId}". Known devices: ${DEVICE_CATALOG.map((entry) => entry.id).join(', ')}.`,
    );
  }
  const platform = normalizePlatform(platformValue, device.platform);
  if (platform !== device.platform) {
    throw invalid(`Preview device "${device.id}" belongs to platform "${device.platform}", not "${platform}".`);
  }
  return { platform, device: device.id };
}

function normalizeText(value: unknown, maxLength: number): string | null {
  if (value === undefined || value === null) return null;
  const text = String(value).trim();
  return text ? text.slice(0, maxLength) : null;
}

function defaultTitle(url: string): string {
  try {
    const parsed = new URL(url);
    return parsed.port ? `${parsed.hostname}:${parsed.port}` : parsed.hostname;
  } catch {
    return url;
  }
}

function broadcast(payload: AppPreviewBroadcast): void {
  const message = JSON.stringify(payload);
  connectedClients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) {
      safeSocketSend(client, message);
    }
  });
}

function requireTarget(id: string): AppPreviewTarget {
  const target = targets.get(id);
  if (!target) {
    throw new AppError(`Preview "${id}" was not found.`, {
      code: 'APP_PREVIEW_NOT_FOUND',
      statusCode: 404,
    });
  }
  return target;
}

/** Finds a registered target by exact URL (used to upsert instead of duplicate). */
function findByUrl(url: string, projectPath: string | null): AppPreviewTarget | undefined {
  for (const target of targets.values()) {
    if (target.url !== url) continue;
    if (!projectPath || !target.projectPath || target.projectPath === projectPath) {
      return target;
    }
  }
  return undefined;
}

/** Device catalog for the REST `GET /api/app-preview/devices` route and the MCP `preview_devices` tool. */
export function listAppPreviewDevices(): AppPreviewDevice[] {
  return DEVICE_CATALOG.map((device) => ({ ...device }));
}

/** Looks up one catalog entry; used by browser-view emulation and the MCP tool descriptions. */
export function getAppPreviewDevice(deviceId: string): AppPreviewDevice | null {
  const device = DEVICE_CATALOG.find((entry) => entry.id === deviceId);
  return device ? { ...device } : null;
}

/** Default catalog device for a platform; used by the client fallback and the MCP tool output. */
export function getDefaultAppPreviewDevice(platform: AppPreviewPlatform): AppPreviewDevice {
  const device = DEVICE_CATALOG.find((entry) => entry.platform === platform);
  // Every platform has at least one catalog entry by construction.
  return { ...(device as AppPreviewDevice) };
}

/** Registered targets, newest last; used by the REST list route and the MCP `preview_list` tool. */
export function listAppPreviews(): AppPreviewTarget[] {
  return [...targets.values()].map((target) => ({ ...target }));
}

/** One target by id; used by the REST routes. */
export function getAppPreview(id: string): AppPreviewTarget {
  return { ...requireTarget(id) };
}

/**
 * Registers a preview target or refreshes the existing one for the same URL.
 * Re-registering is the common agent flow ("open the app again after the
 * change"), so it must not pile up duplicates. Returns whether a new target
 * was created so callers can word their response. Used by the REST create
 * route and the MCP `preview_open` tool.
 */
export function registerAppPreview(
  input: RegisterAppPreviewInput,
): { preview: AppPreviewTarget; created: boolean } {
  const url = normalizeUrl(input.url);
  const projectPath = normalizeText(input.projectPath, 1024);
  const existing = findByUrl(url, projectPath);
  if (existing) {
    const preview = updateAppPreview(existing.id, { ...input, url }, { silent: true });
    broadcast({ type: 'app-preview-upserted', preview, created: false });
    return { preview, created: false };
  }

  const { platform, device } = resolveDevice(input.device, input.platform, 'web');
  const now = new Date().toISOString();
  const preview: AppPreviewTarget = {
    id: randomUUID(),
    url,
    title: normalizeText(input.title, MAX_TITLE_LENGTH) ?? defaultTitle(url),
    platform,
    device,
    orientation: normalizeOrientation(input.orientation, 'portrait'),
    projectPath,
    note: normalizeText(input.note, MAX_NOTE_LENGTH),
    createdAt: now,
    updatedAt: now,
    reloadToken: 0,
  };

  // Oldest-first eviction keeps the list bounded when an agent keeps
  // registering fresh ports without ever closing the old ones.
  while (targets.size >= MAX_TARGETS) {
    const oldestId = targets.keys().next().value;
    if (oldestId === undefined) break;
    targets.delete(oldestId);
    broadcast({ type: 'app-preview-removed', previewId: oldestId });
  }

  targets.set(preview.id, preview);
  broadcast({ type: 'app-preview-upserted', preview, created: true });
  return { preview: { ...preview }, created: true };
}

/**
 * Patches an existing target. Platform and device are re-validated together so
 * a device change can never leave a mismatched platform behind. Used by the
 * REST update route and the MCP `preview_update` tool.
 */
export function updateAppPreview(
  id: string,
  patch: UpdateAppPreviewInput,
  options?: { silent?: boolean },
): AppPreviewTarget {
  const current = requireTarget(id);
  const deviceProvided = patch.device !== undefined;
  const platformProvided = patch.platform !== undefined && patch.platform !== null && patch.platform !== '';

  let platform = current.platform;
  let device = current.device;
  if (deviceProvided || platformProvided) {
    // A real platform switch without an explicit device drops the old device
    // (it belongs to the previous platform); re-stating the current platform
    // keeps the preset the pane already shows.
    const requestedPlatform = normalizePlatform(patch.platform, current.platform);
    const platformChanged = platformProvided && requestedPlatform !== current.platform;
    const resolved = resolveDevice(
      deviceProvided ? patch.device : (platformChanged ? null : current.device),
      platformProvided ? requestedPlatform : null,
      current.platform,
    );
    platform = resolved.platform;
    device = resolved.device;
  }

  const next: AppPreviewTarget = {
    ...current,
    url: patch.url !== undefined ? normalizeUrl(patch.url) : current.url,
    title: patch.title !== undefined
      ? (normalizeText(patch.title, MAX_TITLE_LENGTH) ?? current.title)
      : current.title,
    platform,
    device,
    orientation: patch.orientation !== undefined
      ? normalizeOrientation(patch.orientation, current.orientation)
      : current.orientation,
    projectPath: patch.projectPath !== undefined
      ? normalizeText(patch.projectPath, 1024)
      : current.projectPath,
    note: patch.note !== undefined ? normalizeText(patch.note, MAX_NOTE_LENGTH) : current.note,
    updatedAt: new Date().toISOString(),
  };
  targets.set(id, next);
  if (!options?.silent) {
    broadcast({ type: 'app-preview-upserted', preview: next, created: false });
  }
  return { ...next };
}

/**
 * Asks every pane showing the target to refresh the page. Used by the REST
 * reload route and the MCP `preview_reload` tool after the agent rebuilt
 * an app whose dev server has no hot reload.
 */
export function reloadAppPreview(id: string): AppPreviewTarget {
  const current = requireTarget(id);
  const next: AppPreviewTarget = {
    ...current,
    reloadToken: current.reloadToken + 1,
    updatedAt: new Date().toISOString(),
  };
  targets.set(id, next);
  broadcast({ type: 'app-preview-reloaded', preview: next });
  return { ...next };
}

/** Removes a target; used by the REST delete route and the MCP `preview_close` tool. */
export function removeAppPreview(id: string): void {
  requireTarget(id);
  targets.delete(id);
  broadcast({ type: 'app-preview-removed', previewId: id });
}

/** Drops every target; used by module tests to isolate cases. */
export function clearAppPreviews(): void {
  targets.clear();
}
