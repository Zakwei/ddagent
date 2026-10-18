import type { WebSocket } from 'ws';

import type { AuthenticatedWebSocketRequest } from '@/shared/types.js';
import { parseIncomingJsonObject } from '@/shared/utils.js';

import {
  createBrowserViewSession,
  type BrowserViewSession,
  type ViewEmulationInput,
} from './browser-view.service.js';

type EmulationFields = { device?: string; mobile?: boolean; userAgent?: string };

type BrowserViewIncoming =
  | ({ type: 'start'; url?: string; width?: number; height?: number } & EmulationFields)
  | ({ type: 'emulate' } & EmulationFields)
  | { type: 'navigate'; url?: string }
  | { type: 'back' }
  | { type: 'forward' }
  | { type: 'reload' }
  | { type: 'stop' }
  | { type: 'resize'; width?: number; height?: number }
  | { type: 'mouse'; event?: string; x?: number; y?: number; button?: string; deltaY?: number }
  | { type: 'key'; event?: string; key?: string; code?: string; keyCode?: number; text?: string; modifiers?: number }
  | { type: 'close' };

type AuthenticatedSocket = WebSocket & { _browserViewSession?: BrowserViewSession };

function readUserId(request: AuthenticatedWebSocketRequest): string | null {
  const user = request.user;
  const raw = typeof user?.id === 'number' || typeof user?.id === 'string'
    ? user.id
    : typeof user?.userId === 'number' || typeof user?.userId === 'string'
      ? user.userId
      : null;
  if (raw === null || raw === undefined || raw === '') return null;
  return String(raw);
}

/**
 * Above this queue depth the client is consuming frames slower than the page
 * produces them (slow phone, backgrounded tab). Frames are droppable by design,
 * so they are skipped instead of piling up unbounded; control messages
 * (navigation/error/ready) always go through.
 */
const MAX_BUFFERED_AMOUNT = 4 * 1024 * 1024;

function sendJson(ws: WebSocket, payload: unknown, options?: { droppable?: boolean }): void {
  if (ws.readyState !== ws.OPEN) return;
  if (options?.droppable && ws.bufferedAmount > MAX_BUFFERED_AMOUNT) return;
  ws.send(JSON.stringify(payload));
}

function readNumber(value: unknown): number | undefined {
  return typeof value === 'number' && Number.isFinite(value) ? value : undefined;
}

function readMouseButton(value: unknown): 'left' | 'middle' | 'right' | undefined {
  return value === 'left' || value === 'middle' || value === 'right' ? value : undefined;
}

/** Emulation fields of `start`/`emulate`; `undefined` when the message carries none (plain browser pane). */
function readEmulation(message: EmulationFields): ViewEmulationInput | undefined {
  const device = typeof message.device === 'string' && message.device.trim() ? message.device.trim() : undefined;
  const mobile = typeof message.mobile === 'boolean' ? message.mobile : undefined;
  const userAgent = typeof message.userAgent === 'string' && message.userAgent.trim() ? message.userAgent.trim() : undefined;
  if (device === undefined && mobile === undefined && userAgent === undefined) return undefined;
  return { device, mobile, userAgent };
}

/**
 * Bridges one `/browser-view` websocket to a live Chromium page.
 *
 * The first client message must be `start`; every message afterwards drives
 * the existing page. Screencast frames, navigation state, and errors are
 * pushed back over the same socket. The session is disposed on socket close.
 * `start` and `emulate` may carry a Preview-pane device preset (`device`) or
 * raw `mobile`/`userAgent` flags to render the page as a phone would.
 */
export function handleBrowserViewConnection(
  ws: WebSocket,
  request: AuthenticatedWebSocketRequest,
): void {
  const userId = readUserId(request);
  if (!userId) {
    ws.close(1008, 'Missing authenticated user');
    return;
  }

  const socket = ws as AuthenticatedSocket;
  let starting = false;
  let closed = false;

  const dispose = async (): Promise<void> => {
    closed = true;
    const session = socket._browserViewSession;
    socket._browserViewSession = undefined;
    if (session) {
      await session.close().catch(() => undefined);
    }
  };

  const handleStart = async (message: Extract<BrowserViewIncoming, { type: 'start' }>): Promise<void> => {
    if (socket._browserViewSession || starting) {
      return;
    }
    starting = true;
    try {
      const session = await createBrowserViewSession({
        userId,
        viewport: { width: readNumber(message.width) ?? 1280, height: readNumber(message.height) ?? 800 },
        emulation: readEmulation(message),
        callbacks: {
          onFrame: (frame) => sendJson(ws, { type: 'frame', ...frame }, { droppable: true }),
          onNavigation: (state) => sendJson(ws, { type: 'navigation', ...state }),
          onError: (error) => sendJson(ws, { type: 'error', error }),
        },
      });

      // The socket may have closed while Chromium was still launching (common
      // when switching panes). Without this the orphaned session is never
      // disposed and silently consumes one of the concurrent-view slots.
      if (closed) {
        await session.close().catch(() => undefined);
        return;
      }

      socket._browserViewSession = session;

      // Announce readiness before loading the page: the client gates its input
      // and resize forwarding on this message, and a heavy first navigation can
      // take seconds. Frames and navigation updates stream in while it loads.
      sendJson(ws, { type: 'ready', sessionId: session.id });

      if (message.url) {
        // The page is up: an unreachable or invalid restore URL is a per-action
        // failure like any later navigate, not a reason to drop the session.
        await session.navigate(message.url).catch((error: unknown) => {
          sendJson(ws, {
            type: 'error',
            error: error instanceof Error ? error.message : 'Navigation failed.',
          });
        });
      }
    } catch (error) {
      sendJson(ws, {
        type: 'error',
        error: error instanceof Error ? error.message : 'Failed to start the browser view.',
      });
      ws.close();
    } finally {
      starting = false;
    }
  };

  ws.on('message', (raw: unknown) => {
    const data = parseIncomingJsonObject(raw) as BrowserViewIncoming | null;
    if (!data || closed) return;

    if (data.type === 'start') {
      void handleStart(data);
      return;
    }

    const session = socket._browserViewSession;
    if (!session) return;

    void (async () => {
      try {
        switch (data.type) {
          case 'navigate':
            if (data.url) await session.navigate(data.url);
            break;
          case 'back':
            await session.goBack();
            break;
          case 'forward':
            await session.goForward();
            break;
          case 'reload':
            await session.reload();
            break;
          case 'stop':
            await session.stop();
            break;
          case 'resize':
            await session.resize(readNumber(data.width) ?? 1280, readNumber(data.height) ?? 800);
            break;
          case 'emulate':
            // No fields = back to the plain desktop page.
            await session.emulate(readEmulation(data));
            break;
          case 'mouse':
            if (data.event === 'move' || data.event === 'down' || data.event === 'up' || data.event === 'wheel') {
              await session.dispatchMouse({
                event: data.event,
                x: readNumber(data.x) ?? 0,
                y: readNumber(data.y) ?? 0,
                button: readMouseButton(data.button),
                deltaY: readNumber(data.deltaY),
              });
            }
            break;
          case 'key':
            if (data.event === 'down' || data.event === 'up') {
              await session.dispatchKey({
                event: data.event,
                key: typeof data.key === 'string' ? data.key : '',
                code: typeof data.code === 'string' ? data.code : undefined,
                keyCode: readNumber(data.keyCode),
                text: typeof data.text === 'string' ? data.text : undefined,
                modifiers: readNumber(data.modifiers),
              });
            }
            break;
          case 'close':
            await dispose();
            ws.close();
            break;
          default:
            break;
        }
      } catch (error) {
        sendJson(ws, {
          type: 'error',
          error: error instanceof Error ? error.message : 'Browser input failed.',
        });
      }
    })();
  });

  ws.on('close', () => {
    void dispose();
  });
}
