import { randomUUID } from 'node:crypto';
import { createRequire } from 'node:module';

import { applyChromiumFontConfig, applyChromiumLibraryPath, getChromiumLaunchArgs } from '@/shared/utils.js';

const require = createRequire(import.meta.url);

// The client workspace allows up to MAX_SPLIT_PANES panes, so the server must
// not cap browser views below that or the last panes silently fail to start.
const MAX_VIEW_SESSIONS = Number.parseInt(process.env.DDAGENT_BROWSER_VIEW_MAX_SESSIONS || '6', 10);
const DEFAULT_VIEWPORT = { width: 1280, height: 800 };
const MIN_VIEWPORT_WIDTH = 320;
const MIN_VIEWPORT_HEIGHT = 240;
const MAX_VIEWPORT_WIDTH = 2560;
const MAX_VIEWPORT_HEIGHT = 1600;
const FRAME_QUALITY = 62;

// CDP modifier bitmask values (Alt=1, Ctrl=2, Meta=4, Shift=8).
const CDP_MODIFIER_ALT = 1;
const CDP_MODIFIER_CTRL = 2;
const CDP_MODIFIER_META = 4;
const CDP_MODIFIER_SHIFT = 8;

type Viewport = { width: number; height: number };

type ScreencastMetadata = {
  deviceWidth?: number;
  deviceHeight?: number;
  pageScaleFactor?: number;
  offsetTop?: number;
  offsetLeft?: number;
  scrollOffsetX?: number;
  scrollOffsetY?: number;
};

type ViewSessionCallbacks = {
  /** Called with each throttled JPEG screencast frame encoded as base64. */
  onFrame: (frame: { data: string; width: number; height: number }) => void;
  /** Called whenever the page navigates, loads, or changes its history state. */
  onNavigation: (state: ViewNavigationState) => void;
  onError: (message: string) => void;
};

type ViewNavigationState = {
  url: string;
  title: string;
  canGoBack: boolean;
  canGoForward: boolean;
  loading: boolean;
};

type MouseInput = {
  event: 'move' | 'down' | 'up' | 'wheel';
  x: number;
  y: number;
  button?: 'left' | 'middle' | 'right';
  deltaY?: number;
};

type KeyInput = {
  event: 'down' | 'up';
  key: string;
  code?: string;
  keyCode?: number;
  text?: string;
  modifiers?: number;
};

/**
 * One live, user-driven browser session streamed to a single websocket client.
 *
 * A session owns a Chromium page and pipes CDP screencast frames out while
 * accepting normalized mouse/keyboard/navigation input back. Sessions are
 * per-connection and torn down when their websocket closes.
 */
export type BrowserViewSession = {
  id: string;
  userId: string;
  navigate: (url: string) => Promise<void>;
  goBack: () => Promise<void>;
  goForward: () => Promise<void>;
  reload: () => Promise<void>;
  stop: () => Promise<void>;
  dispatchMouse: (input: MouseInput) => Promise<void>;
  dispatchKey: (input: KeyInput) => Promise<void>;
  resize: (width: number, height: number) => Promise<void>;
  close: () => Promise<void>;
};

type SessionRecord = BrowserViewSession & {
  browser: { close: () => Promise<void> };
  context: { close: () => Promise<void> };
  page: any;
  cdp: any;
  viewport: Viewport;
  closed: boolean;
};

const sessions = new Map<string, SessionRecord>();

function getPlaywright(): any | null {
  try {
    return require('playwright');
  } catch {
    return null;
  }
}

function clampViewport(width: number, height: number): Viewport {
  const safeWidth = Number.isFinite(width) ? Math.round(width) : DEFAULT_VIEWPORT.width;
  const safeHeight = Number.isFinite(height) ? Math.round(height) : DEFAULT_VIEWPORT.height;
  return {
    width: Math.min(Math.max(safeWidth, MIN_VIEWPORT_WIDTH), MAX_VIEWPORT_WIDTH),
    height: Math.min(Math.max(safeHeight, MIN_VIEWPORT_HEIGHT), MAX_VIEWPORT_HEIGHT),
  };
}

function normalizeUrl(rawUrl: string): string {
  const trimmed = String(rawUrl || '').trim();
  if (!trimmed) {
    throw new Error('URL is required.');
  }

  const withProtocol = /^[a-zA-Z][a-zA-Z\d+\-.]*:/.test(trimmed) ? trimmed : `https://${trimmed}`;
  const parsed = new URL(withProtocol);
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    throw new Error('Only http and https URLs are supported.');
  }
  return parsed.toString();
}

function toCdpModifiers(modifiers: number | undefined): number {
  const value = Number(modifiers) || 0;
  let result = 0;
  if (value & 1) result |= CDP_MODIFIER_ALT;
  if (value & 2) result |= CDP_MODIFIER_CTRL;
  if (value & 4) result |= CDP_MODIFIER_META;
  if (value & 8) result |= CDP_MODIFIER_SHIFT;
  return result;
}

function mouseButtonMask(button: 'left' | 'middle' | 'right' | undefined): number {
  if (button === 'right') return 2;
  if (button === 'middle') return 4;
  return 1;
}

/**
 * Chromium destroys and recreates the `RenderWidgetHost` during a cross-process
 * navigation, so CDP input commands issued in that window fail with
 * "Internal error" (render widget host not found). The failure is transient:
 * the renderer is back within milliseconds and the pane stays usable. These
 * events arrive at pointer/key repeat rates, so surfacing each one as a
 * protocol error would flood the client with spurious failures. Drop the
 * transient ones instead; the next event (or the user's next click) succeeds.
 *
 * A deliberate consequence: a click that lands exactly during a navigation is
 * discarded rather than replayed against the new document, which avoids
 * double-firing input on the page that is being loaded.
 */
function isTransientInputError(error: unknown): boolean {
  const message = error instanceof Error ? error.message : String(error ?? '');
  return /Internal error|render widget host|Target page, context or browser has been closed|Session closed/i.test(message);
}

async function sendInput(cdp: any, method: string, params: Record<string, unknown>): Promise<void> {
  try {
    await cdp.send(method, params);
  } catch (error) {
    if (!isTransientInputError(error)) {
      throw error;
    }
  }
}

async function readNavigationState(page: any, cdp: any, loading: boolean): Promise<ViewNavigationState> {
  const url = typeof page.url === 'function' ? page.url() : '';
  const title = await page.title().catch(() => '');
  let canGoBack = false;
  let canGoForward = false;
  try {
    const history = await cdp.send('Page.getNavigationHistory');
    const index = Number(history?.currentIndex) || 0;
    const count = Array.isArray(history?.entries) ? history.entries.length : 0;
    canGoBack = index > 0;
    canGoForward = index < count - 1;
  } catch {
    canGoBack = false;
    canGoForward = false;
  }
  return { url, title, canGoBack, canGoForward, loading };
}

/**
 * Launches a Chromium page and starts a CDP JPEG screencast for it.
 *
 * Throws when the runtime is unavailable or the concurrent-session cap is
 * reached; the websocket handler converts that into a client-facing error.
 */
export async function createBrowserViewSession(options: {
  userId: string;
  viewport?: Partial<Viewport>;
  initialUrl?: string | null;
  callbacks: ViewSessionCallbacks;
}): Promise<BrowserViewSession> {
  if (sessions.size >= MAX_VIEW_SESSIONS) {
    throw new Error(`The server already has ${MAX_VIEW_SESSIONS} open browser views.`);
  }

  const playwright = getPlaywright();
  if (!playwright) {
    throw new Error('Playwright is not installed on the server.');
  }

  // Chromium inherits process.env at spawn; the vendored library path must be
  // present before launch or the loader fails on missing system libraries.
  applyChromiumLibraryPath();
  applyChromiumFontConfig();

  const viewport = clampViewport(options.viewport?.width ?? DEFAULT_VIEWPORT.width, options.viewport?.height ?? DEFAULT_VIEWPORT.height);

  const browser = await playwright.chromium.launch({
    headless: true,
    args: getChromiumLaunchArgs(),
  });

  // Every awaited setup step after launch must close whatever it opened: an
  // unregistered browser/context otherwise leaks an orphan Chromium process.
  let context: any;
  let page: any;
  let cdp: any;
  try {
    context = await browser.newContext({
      viewport,
      deviceScaleFactor: 1,
      serviceWorkers: 'block',
    });
    page = await context.newPage();
    cdp = await context.newCDPSession(page);
  } catch (error) {
    await context?.close?.().catch(() => undefined);
    await browser.close().catch(() => undefined);
    throw error;
  }

  const sessionId = randomUUID();

  let lastFrameAt = 0;
  let pendingFrame: { data: string; width: number; height: number } | null = null;
  let frameTimer: NodeJS.Timeout | null = null;
  let lastMetadata: ScreencastMetadata = {};
  let loading = false;
  let closed = false;
  let pressedButtons = 0;

  // Socket teardown (pane close, Focus Mode toggle, split resize during
  // unmount) races in-flight page calls: Playwright then rejects with
  // "Target page, context or browser has been closed" / "Session closed".
  // That is expected teardown noise, not a user-facing failure — the
  // websocket layer reports every thrown error as a fatal disconnect.
  const isTeardownError = (error: unknown): boolean =>
    closed || page.isClosed() || isTransientInputError(error);

  const emitNavigation = async (): Promise<void> => {
    if (closed) return;
    try {
      const state = await readNavigationState(page, cdp, loading);
      options.callbacks.onNavigation(state);
    } catch {
      // A navigation read can race page teardown; ignore and let close settle.
    }
  };

  const flushFrame = () => {
    frameTimer = null;
    if (closed || !pendingFrame) return;
    lastFrameAt = Date.now();
    const frame = pendingFrame;
    pendingFrame = null;
    options.callbacks.onFrame(frame);
  };

  const scheduleFrame = (frame: { data: string; width: number; height: number }) => {
    pendingFrame = frame;
    if (frameTimer) return;
    const elapsed = Date.now() - lastFrameAt;
    const delay = Math.max(0, 50 - elapsed);
    frameTimer = setTimeout(flushFrame, delay);
    frameTimer.unref?.();
  };

  cdp.on('Page.screencastFrame', (event: { data: string; sessionId: number; metadata?: ScreencastMetadata }) => {
    if (closed) return;
    lastMetadata = event.metadata || {};
    const width = Number(lastMetadata.deviceWidth) || viewport.width;
    const height = Number(lastMetadata.deviceHeight) || viewport.height;
    scheduleFrame({ data: event.data, width, height });
    // Ack every frame, including dropped ones, or Chromium stops streaming.
    cdp.send('Page.screencastFrameAck', { sessionId: event.sessionId }).catch(() => undefined);
  });

  page.on('framenavigated', () => { void emitNavigation(); });
  page.on('load', () => { loading = false; void emitNavigation(); });
  page.on('domcontentloaded', () => { loading = false; void emitNavigation(); });
  page.on('crash', () => { options.callbacks.onError('The browser page crashed.'); });

  try {
    await cdp.send('Page.enable');
    await cdp.send('Page.startScreencast', {
      format: 'jpeg',
      quality: FRAME_QUALITY,
      maxWidth: viewport.width,
      maxHeight: viewport.height,
      everyNthFrame: 1,
    });
  } catch (error) {
    await context.close().catch(() => undefined);
    await browser.close().catch(() => undefined);
    throw error;
  }

  const session: SessionRecord = {
    id: sessionId,
    userId: options.userId,
    browser,
    context,
    page,
    cdp,
    viewport,
    closed: false,
    async navigate(rawUrl: string) {
      const url = normalizeUrl(rawUrl);
      loading = true;
      await emitNavigation();
      try {
        await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30_000 });
      } catch (error) {
        if (!isTeardownError(error)) throw error;
      } finally {
        loading = false;
      }
      await emitNavigation();
    },
    async goBack() {
      try {
        const history = await cdp.send('Page.getNavigationHistory');
        const index = Number(history?.currentIndex) || 0;
        const entries = Array.isArray(history?.entries) ? history.entries : [];
        if (index <= 0 || !entries[index - 1]) return;
        await cdp.send('Page.navigateToHistoryEntry', { entryId: entries[index - 1].id });
      } catch (error) {
        if (!isTeardownError(error)) throw error;
        return;
      }
      await emitNavigation();
    },
    async goForward() {
      try {
        const history = await cdp.send('Page.getNavigationHistory');
        const index = Number(history?.currentIndex) || 0;
        const entries = Array.isArray(history?.entries) ? history.entries : [];
        if (index >= entries.length - 1 || !entries[index + 1]) return;
        await cdp.send('Page.navigateToHistoryEntry', { entryId: entries[index + 1].id });
      } catch (error) {
        if (!isTeardownError(error)) throw error;
        return;
      }
      await emitNavigation();
    },
    async reload() {
      loading = true;
      await emitNavigation();
      await page.reload({ waitUntil: 'domcontentloaded', timeout: 30_000 }).catch(() => undefined);
      loading = false;
      await emitNavigation();
    },
    async stop() {
      await cdp.send('Page.stopLoading').catch(() => undefined);
      loading = false;
      await emitNavigation();
    },
    async dispatchMouse(input: MouseInput) {
      if (closed) return;
      const x = Math.round(Math.min(Math.max(input.x, 0), 1) * viewport.width);
      const y = Math.round(Math.min(Math.max(input.y, 0), 1) * viewport.height);

      if (input.event === 'wheel') {
        await sendInput(cdp, 'Input.dispatchMouseEvent', {
          type: 'mouseWheel',
          x,
          y,
          deltaX: 0,
          deltaY: Number(input.deltaY) || 0,
        });
        return;
      }

      if (input.event === 'move') {
        await sendInput(cdp, 'Input.dispatchMouseEvent', { type: 'mouseMoved', x, y, buttons: pressedButtons });
        return;
      }

      const button = input.button || 'left';
      const mask = mouseButtonMask(button);
      const type = input.event === 'down' ? 'mousePressed' : 'mouseReleased';
      if (input.event === 'down') {
        pressedButtons |= mask;
      } else {
        pressedButtons &= ~mask;
      }
      await sendInput(cdp, 'Input.dispatchMouseEvent', {
        type,
        x,
        y,
        button,
        buttons: pressedButtons,
        clickCount: 1,
      });
    },
    async dispatchKey(input: KeyInput) {
      if (closed) return;
      const modifiers = toCdpModifiers(input.modifiers);
      const keyCode = Number(input.keyCode) || 0;
      const isKeyUp = input.event === 'up';

      // Printable text without shortcut modifiers is inserted directly, which
      // keeps non-ASCII input (e.g. Polish) working without a full keymap.
      const isPrintable = !isKeyUp
        && typeof input.text === 'string'
        && input.text.length === 1
        && !(modifiers & (CDP_MODIFIER_CTRL | CDP_MODIFIER_META | CDP_MODIFIER_ALT));
      if (isPrintable) {
        await sendInput(cdp, 'Input.insertText', { text: input.text });
        return;
      }

      await sendInput(cdp, 'Input.dispatchKeyEvent', {
        type: isKeyUp ? 'keyUp' : (input.text ? 'keyDown' : 'rawKeyDown'),
        key: input.key || undefined,
        code: input.code || undefined,
        text: isKeyUp ? undefined : input.text || undefined,
        windowsVirtualKeyCode: keyCode || undefined,
        nativeVirtualKeyCode: keyCode || undefined,
        modifiers,
      });
    },
    async resize(width: number, height: number) {
      if (closed || page.isClosed()) return;
      const next = clampViewport(width, height);
      // ResizeObserver can fire a burst of identical sizes; re-issuing
      // startScreencast each time stalls the stream, so only act on changes.
      if (next.width === viewport.width && next.height === viewport.height) return;
      viewport.width = next.width;
      viewport.height = next.height;
      try {
        await page.setViewportSize(next);
        await cdp.send('Page.startScreencast', {
          format: 'jpeg',
          quality: FRAME_QUALITY,
          maxWidth: next.width,
          maxHeight: next.height,
          everyNthFrame: 1,
        });
      } catch (error) {
        // The socket can close (Focus Mode toggle, pane removal) while the
        // resize is in flight — a dead target must not surface as fatal.
        if (!isTeardownError(error)) throw error;
      }
    },
    async close() {
      if (closed) return;
      closed = true;
      sessions.delete(sessionId);
      if (frameTimer) {
        clearTimeout(frameTimer);
        frameTimer = null;
      }
      await cdp.send('Page.stopScreencast').catch(() => undefined);
      await context.close().catch(() => undefined);
      await browser.close().catch(() => undefined);
    },
  };

  // The cap check at the top runs before any awaits, so concurrent opens can
  // all pass it and exceed MAX_VIEW_SESSIONS. Re-check right before
  // registering: there is no await between this check and `sessions.set`, so
  // the map cannot grow in between.
  if (sessions.size >= MAX_VIEW_SESSIONS) {
    await session.close();
    throw new Error(`The server already has ${MAX_VIEW_SESSIONS} open browser views.`);
  }
  sessions.set(sessionId, session);
  void emitNavigation();
  return session;
}

/** Closes every live browser view; used during server shutdown. */
export async function closeAllBrowserViewSessions(): Promise<void> {
  await Promise.all([...sessions.values()].map((session) => session.close()));
}
