import { useCallback, useEffect, useRef, useState } from 'react';
import { ArrowLeft, ArrowRight, ExternalLink, Globe, RotateCw, X } from 'lucide-react';

import { cn } from '../../../lib/utils';
import { isHttpUrl, normalizeInput } from '../utils/browserUrl';
import { buildBrowserViewEndpoint } from '../utils/browserViewEndpoint';
import { toKeyboardPayload, toNormalizedPoint } from '../utils/remoteInput';

type RemoteBrowserPaneProps = {
  url?: string | null;
  isActive?: boolean;
  /** Called when the remote page commits a navigation, so the pane can persist it. */
  onUrlChange?: (url: string) => void;
  className?: string;
};

type NavigationState = {
  url: string;
  title: string;
  canGoBack: boolean;
  canGoForward: boolean;
  loading: boolean;
};

type ServerMessage =
  | { type: 'ready'; sessionId: string }
  | { type: 'frame'; data: string; width: number; height: number }
  | { type: 'navigation'; url: string; title: string; canGoBack: boolean; canGoForward: boolean; loading: boolean }
  | { type: 'error'; error: string };

/**
 * Reads the stored auth token directly instead of importing the API module,
 * whose `import.meta.env` platform flag cannot load under the node test runner.
 */
const readStoredToken = (): string | null => {
  try {
    return window.localStorage.getItem('auth-token');
  } catch {
    return null;
  }
};

const buildBrowserViewUrl = (): string | null =>
  buildBrowserViewEndpoint({
    protocol: window.location.protocol,
    host: window.location.host,
    token: readStoredToken(),
  });

/**
 * Streams a server-side Chromium page into a canvas and forwards user input.
 *
 * This is the non-Electron counterpart of the `<webview>` pane: it works in a
 * plain browser or container where no desktop bridge exists. Frames arrive as
 * base64 JPEG over `/browser-view`; pointer and keyboard events are normalized
 * and sent back to drive the headless page.
 */
const RemoteBrowserPane = ({ url, isActive = false, onUrlChange, className }: RemoteBrowserPaneProps) => {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const socketRef = useRef<WebSocket | null>(null);
  const frameSizeRef = useRef<{ width: number; height: number }>({ width: 0, height: 0 });
  const moveThrottleRef = useRef<number>(0);
  const addressEditingRef = useRef(false);

  const [addressValue, setAddressValue] = useState(url || '');
  const [navigation, setNavigation] = useState<NavigationState>({
    url: url || '',
    title: '',
    canGoBack: false,
    canGoForward: false,
    loading: false,
  });
  const [status, setStatus] = useState<'connecting' | 'ready' | 'closed'>('connecting');
  const [error, setError] = useState<string | null>(null);
  // Server-reported errors (e.g. the concurrent-view cap) are not transient, so
  // the reconnect loop must stop instead of hammering the server forever.
  const fatalRef = useRef(false);
  const [reconnectKey, setReconnectKey] = useState(0);

  const send = useCallback((payload: unknown) => {
    const socket = socketRef.current;
    if (socket && socket.readyState === WebSocket.OPEN) {
      socket.send(JSON.stringify(payload));
    }
  }, []);

  // The connection is created once per mount. `url` is read through a ref so a
  // later prop change navigates the existing page instead of tearing the whole
  // Chromium session down; `isActive` only affects rendering.
  const initialUrlRef = useRef(url);
  const readyRef = useRef(false);
  // The last URL the server reported, so a dropped socket can resume the page
  // instead of resetting to about:blank.
  const resumeUrlRef = useRef<string | null>(isHttpUrl(url) ? url : null);
  const onUrlChangeRef = useRef(onUrlChange);
  onUrlChangeRef.current = onUrlChange;

  useEffect(() => {
    const target = buildBrowserViewUrl();
    if (!target) {
      setStatus('closed');
      setError('No authentication token available.');
      return undefined;
    }

    let disposed = false;
    let socket: WebSocket | null = null;
    let retryTimer: ReturnType<typeof setTimeout> | null = null;
    let retryDelay = 1000;
    fatalRef.current = false;

    const connect = () => {
      if (disposed) return;
      socket = new WebSocket(target);
      socketRef.current = socket;

      socket.onopen = () => {
        retryDelay = 1000;
        fatalRef.current = false;
        const rect = canvasRef.current?.parentElement?.getBoundingClientRect();
        socket?.send(JSON.stringify({
          type: 'start',
          url: resumeUrlRef.current || (isHttpUrl(initialUrlRef.current) ? initialUrlRef.current : undefined),
          width: rect ? Math.round(rect.width) : undefined,
          height: rect ? Math.round(rect.height) : undefined,
        }));
      };

      socket.onmessage = (event) => {
        let message: ServerMessage | null = null;
        try {
          message = JSON.parse(String(event.data)) as ServerMessage;
        } catch {
          return;
        }
        if (!message) return;

        if (message.type === 'ready') {
          readyRef.current = true;
          setStatus('ready');
          setError(null);
          return;
        }
        if (message.type === 'error') {
          // The server closes the socket right after a start-time error; the
          // error is terminal (bad auth, concurrency cap), so do not reconnect.
          fatalRef.current = true;
          setStatus('closed');
          setError(message.error);
          return;
        }
        if (message.type === 'navigation') {
          if (isHttpUrl(message.url)) {
            resumeUrlRef.current = message.url;
            onUrlChangeRef.current?.(message.url);
          }
          setNavigation({
            url: message.url,
            title: message.title,
            canGoBack: message.canGoBack,
            canGoForward: message.canGoForward,
            loading: message.loading,
          });
          if (!addressEditingRef.current) setAddressValue(message.url);
          return;
        }
        if (message.type === 'frame') {
          frameSizeRef.current = { width: message.width, height: message.height };
          setNavigation((previous) => (previous.loading ? { ...previous, loading: false } : previous));
          const canvas = canvasRef.current;
          const context = canvas?.getContext('2d');
          if (!canvas || !context) return;
          const image = new Image();
          image.onload = () => {
            if (disposed) return;
            canvas.width = image.naturalWidth;
            canvas.height = image.naturalHeight;
            context.drawImage(image, 0, 0);
          };
          image.src = `data:image/jpeg;base64,${message.data}`;
        }
      };

      socket.onclose = () => {
        if (disposed) return;
        readyRef.current = false;
        // A terminal error (reported before close) leaves the pane stopped with
        // the message visible; only transient drops reconnect with backoff.
        if (fatalRef.current) return;
        setStatus('connecting');
        retryTimer = setTimeout(connect, retryDelay);
        retryDelay = Math.min(retryDelay * 2, 10_000);
      };
      socket.onerror = () => {
        if (disposed) return;
        setError((previous) => previous || 'Browser connection failed.');
      };
    };

    connect();

    return () => {
      disposed = true;
      if (retryTimer) clearTimeout(retryTimer);
      socketRef.current = null;
      readyRef.current = false;
      if (socket && (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING)) {
        socket.close();
      }
    };
  }, [reconnectKey]);

  // A pane-level url change (e.g. another component opening a link in this
  // browser) navigates the already-running session instead of reconnecting.
  const lastRequestedUrlRef = useRef(initialUrlRef.current);
  useEffect(() => {
    if (url === lastRequestedUrlRef.current) return;
    lastRequestedUrlRef.current = url;
    // `url === resumeUrlRef.current` means the prop round-tripped from a
    // server navigation report via onUrlChange — re-navigating would reload.
    if (isHttpUrl(url) && readyRef.current && url !== resumeUrlRef.current) {
      send({ type: 'navigate', url });
    }
  }, [url, send]);

  useEffect(() => {
    if (addressEditingRef.current) return;
    setAddressValue(navigation.url || '');
  }, [navigation.url]);

  const sendResize = useCallback(() => {
    const rect = canvasRef.current?.parentElement?.getBoundingClientRect();
    if (!rect?.width || !rect.height) return;
    send({ type: 'resize', width: Math.round(rect.width), height: Math.round(rect.height) });
  }, [send]);

  useEffect(() => {
    const element = canvasRef.current?.parentElement;
    if (!element || typeof ResizeObserver === 'undefined') return undefined;
    const observer = new ResizeObserver(() => sendResize());
    observer.observe(element);
    return () => observer.disconnect();
  }, [sendResize]);

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    const target = normalizeInput(addressValue);
    if (!target) {
      setError('Enter a valid http(s) URL');
      return;
    }
    addressEditingRef.current = false;
    setError(null);
    send({ type: 'navigate', url: target });
  };

  const handlePointer = (type: 'move' | 'down' | 'up') => (event: React.PointerEvent<HTMLCanvasElement>) => {
    // Capture the pointer on down so a drag that leaves the canvas still
    // delivers pointerup here — otherwise the remote page never sees the
    // release and the button stays "held" server-side.
    if (type === 'down') {
      try {
        event.currentTarget.setPointerCapture(event.pointerId);
      } catch {
        // Pointer may already be gone (e.g. synthetic events) — capture is best-effort.
      }
    }
    const rect = event.currentTarget.getBoundingClientRect();
    const point = toNormalizedPoint(event.clientX, event.clientY, rect);
    if (!point) return;
    if (type === 'move') {
      const now = Date.now();
      if (now - moveThrottleRef.current < 40) return;
      moveThrottleRef.current = now;
    }
    if (type === 'up' && event.currentTarget.hasPointerCapture(event.pointerId)) {
      event.currentTarget.releasePointerCapture(event.pointerId);
    }
    if (type !== 'move') event.currentTarget.focus();
    send({
      type: 'mouse',
      event: type,
      x: point.x,
      y: point.y,
      button: event.button === 2 ? 'right' : event.button === 1 ? 'middle' : 'left',
    });
  };

  const handleWheel = (event: React.WheelEvent<HTMLCanvasElement>) => {
    event.preventDefault();
    const rect = event.currentTarget.getBoundingClientRect();
    const point = toNormalizedPoint(event.clientX, event.clientY, rect);
    if (!point) return;
    send({ type: 'mouse', event: 'wheel', x: point.x, y: point.y, deltaY: event.deltaY });
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLCanvasElement>) => {
    const payload = toKeyboardPayload(event.nativeEvent);
    send({ type: 'key', event: 'down', ...payload });
    if (event.key === 'Tab') {
      // Keep Tab inside the page while the view is focused.
      event.preventDefault();
    }
  };

  const handleKeyUp = (event: React.KeyboardEvent<HTMLCanvasElement>) => {
    const payload = toKeyboardPayload(event.nativeEvent);
    send({ type: 'key', event: 'up', ...payload });
  };

  const handleOpenExternal = () => {
    const target = navigation.url || url;
    if (isHttpUrl(target)) window.open(target, '_blank', 'noopener,noreferrer');
  };

  return (
    <div className={cn('flex h-full min-h-0 flex-col overflow-hidden', className)} data-active={isActive}>
      <form
        onSubmit={handleSubmit}
        className="flex h-9 shrink-0 items-center gap-1 border-b border-border/50 bg-muted/30 px-2"
      >
        <button
          type="button"
          onClick={() => send({ type: 'back' })}
          disabled={!navigation.canGoBack}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
          aria-label="Back"
          title="Back"
        >
          <ArrowLeft className="h-3.5 w-3.5" />
        </button>
        <button
          type="button"
          onClick={() => send({ type: 'forward' })}
          disabled={!navigation.canGoForward}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
          aria-label="Forward"
          title="Forward"
        >
          <ArrowRight className="h-3.5 w-3.5" />
        </button>
        <button
          type="button"
          onClick={() => send({ type: navigation.loading ? 'stop' : 'reload' })}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
          aria-label={navigation.loading ? 'Stop' : 'Reload'}
          title={navigation.loading ? 'Stop' : 'Reload'}
        >
          {navigation.loading ? <X className="h-3.5 w-3.5" /> : <RotateCw className="h-3.5 w-3.5" />}
        </button>
        <input
          type="text"
          value={addressValue}
          onChange={(event) => setAddressValue(event.target.value)}
          onFocus={() => {
            addressEditingRef.current = true;
          }}
          onBlur={() => {
            addressEditingRef.current = false;
            setAddressValue(navigation.url || '');
          }}
          placeholder="Enter URL"
          className="mx-1 min-w-0 flex-1 rounded border border-border/60 bg-background/80 px-2 py-0.5 text-xs text-foreground outline-none transition-colors placeholder:text-muted-foreground/60 hover:bg-background focus:ring-1 focus:ring-primary/40"
          aria-label="Address"
        />
        <button
          type="button"
          onClick={handleOpenExternal}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
          aria-label="Open in system browser"
          title="Open in system browser"
        >
          <ExternalLink className="h-3.5 w-3.5" />
        </button>
      </form>

      {error && (
        <div className="shrink-0 border-b border-border/50 bg-destructive/10 px-3 py-1 text-xs text-destructive">
          {error}
        </div>
      )}

      <div className="relative min-h-0 flex-1 bg-background">
        {navigation.title && (
          <div className="pointer-events-none absolute inset-x-0 top-0 z-10 truncate bg-background/70 px-3 py-0.5 text-[11px] text-muted-foreground">
            {navigation.title}
          </div>
        )}
        {status !== 'ready' && (
          <div className="pointer-events-none absolute inset-0 z-20 flex flex-col items-center justify-center gap-2 text-sm text-muted-foreground">
            <Globe className="h-6 w-6 text-muted-foreground/60" />
            <p>{status === 'connecting' ? 'Connecting to browser…' : 'Browser view disconnected'}</p>
            {status === 'closed' && error && (
              <button
                type="button"
                onClick={() => {
                  setError(null);
                  setStatus('connecting');
                  setReconnectKey((value) => value + 1);
                }}
                className="pointer-events-auto rounded-md border border-border/60 bg-background/80 px-2.5 py-1 text-xs text-foreground transition-colors hover:bg-accent"
              >
                Retry
              </button>
            )}
          </div>
        )}
        <canvas
          ref={canvasRef}
          tabIndex={0}
          onPointerMove={handlePointer('move')}
          onPointerDown={handlePointer('down')}
          onPointerUp={handlePointer('up')}
          onWheel={handleWheel}
          onKeyDown={handleKeyDown}
          onKeyUp={handleKeyUp}
          onContextMenu={(event) => event.preventDefault()}
          className="h-full w-full cursor-default outline-none"
          data-testid="remote-browser-canvas"
        />
      </div>
    </div>
  );
};

export default RemoteBrowserPane;
export { RemoteBrowserPane };
