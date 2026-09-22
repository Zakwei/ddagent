/**
 * DOM-WebSocket-compatible socket that runs over Electron IPC instead of TCP.
 *
 * The real connection lives in the main process; `window.desktopApi.ws`
 * (exposed by electron/preload.cjs) is the low-level frame/event transport.
 * This class reproduces the slice of the DOM surface the app actually uses:
 * `new WebSocket(url)`, `onopen/onmessage/onerror/onclose` property handlers,
 * `send(string)`, `close()`, `readyState`, and the CONNECTING/OPEN/CLOSING/
 * CLOSED constants. `onmessage` always receives `{ data: string }` — every
 * call site does `JSON.parse(event.data)`, and binary frames are never
 * delivered, so `binaryType` is inert.
 *
 * Handlers assigned after construction (`ws.onmessage = fn`) work: they are
 * plain properties looked up when an IPC event arrives, which is inherently
 * asynchronous.
 */

export type DesktopWebSocketBridgeEvent = {
  type: 'open' | 'message' | 'close' | 'error';
  /** Payload for `message` events. Always a string. */
  data?: string;
  /** Close code for `close` events (1006 = abnormal). */
  code?: number;
  /** Close reason for `close` events. */
  reason?: string;
  /** Detail text for `error` events. */
  message?: string;
  /** Clean-close flag for `close` events; defaults to `code === 1000`. */
  wasClean?: boolean;
  /** Negotiated subprotocol reported by `open` events. */
  protocol?: string;
};

export type DesktopWebSocketBridge = {
  connect: (url: string, protocols?: string | string[]) => Promise<string>;
  send: (connId: string, data: string) => Promise<unknown> | unknown;
  close: (connId: string, code?: number, reason?: string) => Promise<unknown> | unknown;
  /** One callback per connId; returns an unsubscribe function. */
  onEvent: (connId: string, callback: (event: DesktopWebSocketBridgeEvent) => void) => () => void;
};

declare global {
  interface Window {
    desktopApi?: { ws?: DesktopWebSocketBridge };
  }
}

export type DesktopWebSocketEventMap = {
  open: { type: 'open' };
  message: { type: 'message'; data: string };
  error: { type: 'error'; message?: string };
  close: { type: 'close'; code: number; reason: string; wasClean: boolean };
};

export type DesktopWebSocketEventName = keyof DesktopWebSocketEventMap;
export type DesktopWebSocketEvent = DesktopWebSocketEventMap[DesktopWebSocketEventName];

type DesktopWebSocketListener = (event: DesktopWebSocketEvent) => void;

const READY_STATE_NAME = ['CONNECTING', 'OPEN', 'CLOSING', 'CLOSED'] as const;

export class DesktopWebSocket {
  static readonly CONNECTING = 0;
  static readonly OPEN = 1;
  static readonly CLOSING = 2;
  static readonly CLOSED = 3;

  // DOM exposes the constants on instances too.
  readonly CONNECTING = DesktopWebSocket.CONNECTING;
  readonly OPEN = DesktopWebSocket.OPEN;
  readonly CLOSING = DesktopWebSocket.CLOSING;
  readonly CLOSED = DesktopWebSocket.CLOSED;

  readonly url: string;
  /** DOM compat — no extensions are negotiated over IPC. */
  readonly extensions = '';
  /** Negotiated subprotocol; stays '' unless an `open` event reports one. */
  protocol = '';
  /** DOM compat — accepted but unused, messages are always strings. */
  binaryType: 'blob' | 'arraybuffer' = 'blob';
  /** Always 0: IPC send is fire-and-forget with no outbound buffer. */
  readonly bufferedAmount = 0;
  readyState: number = DesktopWebSocket.CONNECTING;

  onopen: ((event: DesktopWebSocketEventMap['open']) => void) | null = null;
  onmessage: ((event: DesktopWebSocketEventMap['message']) => void) | null = null;
  onerror: ((event: DesktopWebSocketEventMap['error']) => void) | null = null;
  onclose: ((event: DesktopWebSocketEventMap['close']) => void) | null = null;

  private readonly bridge: DesktopWebSocketBridge;
  private connId: string | null = null;
  private unsubscribe: (() => void) | null = null;
  private pendingClose: { code: number; reason: string } | null = null;
  private tornDown = false;
  // Map<type, Map<originalListener, wrappedListener>> — the wrapper owns
  // `once` removal while removeEventListener keys off the original.
  private readonly listeners = new Map<
    DesktopWebSocketEventName,
    Map<DesktopWebSocketListener, (event: DesktopWebSocketEvent) => void>
  >();

  constructor(url: string, protocols?: string | string[]) {
    const bridge = window.desktopApi?.ws;
    if (!bridge) {
      throw new Error('DesktopWebSocket requires the window.desktopApi.ws preload bridge');
    }
    this.bridge = bridge;

    let parsed: URL;
    try {
      parsed = new URL(url, window.location.href);
    } catch {
      throw new DOMException(
        `Failed to construct 'WebSocket': The URL '${url}' is invalid.`,
        'SyntaxError',
      );
    }
    if (parsed.protocol !== 'ws:' && parsed.protocol !== 'wss:') {
      throw new DOMException(
        `Failed to construct 'WebSocket': The URL's scheme must be either 'ws' or 'wss'.`,
        'SyntaxError',
      );
    }
    this.url = parsed.href;

    void Promise.resolve(bridge.connect(url, protocols))
      .then((connId) => {
        if (this.tornDown || this.pendingClose) {
          // close() ran while the handshake was in flight — drop the fresh
          // connection instead of subscribing to it.
          void Promise.resolve(
            bridge.close(connId, this.pendingClose?.code, this.pendingClose?.reason),
          ).catch(() => {});
          this.finishClose(this.pendingClose?.code ?? 1006, this.pendingClose?.reason ?? '', Boolean(this.pendingClose));
          return;
        }
        this.connId = connId;
        this.unsubscribe = bridge.onEvent(connId, (event) => this.handleBridgeEvent(event));
      })
      .catch((error: unknown) => {
        // DOM fires `error` then `close` on a failed handshake.
        this.dispatch('error', {
          type: 'error',
          message: error instanceof Error ? error.message : String(error),
        });
        this.finishClose(1006, '', false);
      });
  }

  send(data: string | ArrayBufferLike | Blob | ArrayBufferView): void {
    if (this.readyState === DesktopWebSocket.CONNECTING) {
      throw new DOMException(
        `Failed to execute 'send' on 'WebSocket': Still in CONNECTING state.`,
        'InvalidStateError',
      );
    }
    // DOM silently discards frames sent while CLOSING/CLOSED.
    if (this.readyState !== DesktopWebSocket.OPEN || !this.connId) return;
    void Promise.resolve(
      this.bridge.send(this.connId, typeof data === 'string' ? data : String(data)),
    ).catch(() => {});
  }

  close(code = 1000, reason = ''): void {
    if (this.readyState === DesktopWebSocket.CLOSING || this.readyState === DesktopWebSocket.CLOSED) {
      return;
    }
    this.readyState = DesktopWebSocket.CLOSING;
    if (!this.connId) {
      // Handshake still in flight — the connect resolution sends the close.
      this.pendingClose = { code, reason };
      return;
    }
    void Promise.resolve(this.bridge.close(this.connId, code, reason))
      .catch(() => {})
      .then(() => {
        // Main normally reports the socket's close event; if it went quiet
        // the socket must still reach CLOSED or callers wait on it forever.
        if (this.readyState === DesktopWebSocket.CLOSING) {
          this.finishClose(code, reason, true);
        }
      });
  }

  addEventListener<K extends DesktopWebSocketEventName>(
    type: K,
    listener: ((event: DesktopWebSocketEventMap[K]) => void) | null,
    options?: boolean | AddEventListenerOptions,
  ): void {
    if (!listener) return;
    let set = this.listeners.get(type);
    if (!set) {
      set = new Map();
      this.listeners.set(type, set);
    }
    const key = listener as DesktopWebSocketListener;
    if (set.has(key)) return; // DOM: same listener + type registers once
    const once = typeof options === 'object' && Boolean(options.once);
    set.set(key, (event) => {
      if (once) set.delete(key);
      listener(event as DesktopWebSocketEventMap[K]);
    });
  }

  removeEventListener<K extends DesktopWebSocketEventName>(
    type: K,
    listener: ((event: DesktopWebSocketEventMap[K]) => void) | null,
  ): void {
    if (!listener) return;
    this.listeners.get(type)?.delete(listener as DesktopWebSocketListener);
  }

  private handleBridgeEvent(event: DesktopWebSocketBridgeEvent): void {
    switch (event.type) {
      case 'open': {
        if (this.readyState !== DesktopWebSocket.CONNECTING) return;
        this.readyState = DesktopWebSocket.OPEN;
        if (typeof event.protocol === 'string') this.protocol = event.protocol;
        this.dispatch('open', { type: 'open' });
        return;
      }
      case 'message': {
        if (this.readyState !== DesktopWebSocket.OPEN) return;
        this.dispatch('message', {
          type: 'message',
          data: typeof event.data === 'string' ? event.data : String(event.data ?? ''),
        });
        return;
      }
      case 'error': {
        if (this.readyState === DesktopWebSocket.CLOSED) return;
        this.dispatch('error', { type: 'error', message: event.message });
        return;
      }
      case 'close': {
        this.finishClose(
          event.code ?? 1006,
          event.reason ?? '',
          event.wasClean ?? event.code === 1000,
        );
        return;
      }
    }
  }

  private finishClose(code: number, reason: string, wasClean: boolean): void {
    if (this.readyState === DesktopWebSocket.CLOSED) return;
    this.readyState = DesktopWebSocket.CLOSED;
    this.tornDown = true;
    const unsubscribe = this.unsubscribe;
    this.unsubscribe = null;
    unsubscribe?.();
    this.dispatch('close', { type: 'close', code, reason, wasClean });
  }

  private dispatch<K extends DesktopWebSocketEventName>(
    type: K,
    event: DesktopWebSocketEventMap[K],
  ): void {
    const handler = (
      type === 'open' ? this.onopen
        : type === 'message' ? this.onmessage
          : type === 'error' ? this.onerror
            : this.onclose
    ) as ((event: DesktopWebSocketEvent) => void) | null;
    if (handler) this.invokeHandler(handler, event);
    const set = this.listeners.get(type);
    if (!set) return;
    for (const wrapped of [...set.values()]) {
      this.invokeHandler(wrapped, event);
    }
  }

  // A throwing handler must not break the socket or starve other listeners —
  // same contract as DOM event dispatch.
  private invokeHandler(
    handler: (event: DesktopWebSocketEvent) => void,
    event: DesktopWebSocketEvent,
  ): void {
    try {
      handler.call(this, event);
    } catch (error) {
      console.error(`DesktopWebSocket ${READY_STATE_NAME[this.readyState]} ${event.type} handler error:`, error);
    }
  }
}

/**
 * Socket factory for the app's WebSocket call sites.
 *
 * On the bundled `ddagent-app:` origin there is no TCP listener — the ws://
 * URL is symbolic (the main-process router matches on path+query only), so
 * frames must go through the preload bridge. Other origins inside Electron
 * (spawned local server on http://localhost, remote https:// environments)
 * expose the same bridge via the preload, but their ws:// URL is a real
 * address — they keep the DOM WebSocket.
 */
export function createAppWebSocket(url: string, protocols?: string | string[]): WebSocket {
  if (window.location.protocol === 'ddagent-app:' && window.desktopApi?.ws) {
    return new DesktopWebSocket(url, protocols) as unknown as WebSocket;
  }
  return new WebSocket(url, protocols);
}

export default DesktopWebSocket;
