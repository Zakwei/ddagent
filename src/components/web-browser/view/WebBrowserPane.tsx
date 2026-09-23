import { useCallback, useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ArrowLeft, ArrowRight, ExternalLink, RotateCw, X } from 'lucide-react';

import { cn } from '../../../lib/utils';
import { isHttpUrl, normalizeInput } from '../utils/browserUrl';

import { RemoteBrowserPane } from './RemoteBrowserPane';

type WebBrowserPaneProps = {
  url?: string | null;
  isActive?: boolean;
  /** Called when the embedded page commits a navigation, so the pane can persist it. */
  onUrlChange?: (url: string) => void;
  className?: string;
};

type WebviewElement = HTMLElement & {
  loadURL: (url: string) => Promise<void>;
  reload: () => void;
  stop: () => void;
  goBack: () => void;
  goForward: () => void;
  canGoBack: () => boolean;
  canGoForward: () => boolean;
  getURL: () => string;
};

type BrowserBridge = {
  isDesktop?: boolean;
  openExternal?: (url: string) => Promise<unknown>;
};

const getBridge = (): BrowserBridge | null =>
  (window as Window & { ddagentBrowser?: BrowserBridge }).ddagentBrowser || null;

const WebBrowserPane = ({ url, isActive = false, onUrlChange, className }: WebBrowserPaneProps) => {
  const { t } = useTranslation('common');
  const bridge = getBridge();
  const available = !!bridge;
  const webviewRef = useRef<WebviewElement | null>(null);
  const addressEditingRef = useRef(false);
  // Latest URL the page itself committed. Lets a persisted `url` prop round-
  // trip (onUrlChange -> updatePane -> prop) without reloading the webview.
  const committedUrlRef = useRef<string | null>(null);
  const onUrlChangeRef = useRef(onUrlChange);
  onUrlChangeRef.current = onUrlChange;
  const [addressValue, setAddressValue] = useState(url || '');
  const [currentUrl, setCurrentUrl] = useState(url || '');
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [canGoBack, setCanGoBack] = useState(false);
  const [canGoForward, setCanGoForward] = useState(false);

  const syncNavigationState = useCallback(() => {
    const webview = webviewRef.current;
    if (!webview) return;
    try {
      setCanGoBack(webview.canGoBack());
      setCanGoForward(webview.canGoForward());
    } catch {
      setCanGoBack(false);
      setCanGoForward(false);
    }
  }, []);

  const loadUrl = useCallback(
    (target: string) => {
      const webview = webviewRef.current;
      if (!webview || !isHttpUrl(target)) return;
      setError(null);
      void webview.loadURL(target).catch((loadError) => {
        setError(loadError instanceof Error ? loadError.message : String(loadError));
      });
    },
    [],
  );

  useEffect(() => {
    // Skip URLs the page already navigated to — the change came from
    // onUrlChange round-tripping through the pane store, not the user.
    if (isHttpUrl(url) && url !== committedUrlRef.current) {
      committedUrlRef.current = url;
      loadUrl(url);
    }
  }, [url, loadUrl]);

  useEffect(() => {
    if (addressEditingRef.current) return;
    setAddressValue(currentUrl || '');
  }, [currentUrl]);

  useEffect(() => {
    const webview = webviewRef.current;
    if (!webview) return;

    const handleStart = () => {
      setLoading(true);
      setError(null);
    };
    const handleStop = () => {
      setLoading(false);
      syncNavigationState();
    };
    const handleNavigate = (event: Event) => {
      const nextUrl = (event as unknown as { url?: string }).url || webview.getURL();
      committedUrlRef.current = nextUrl;
      setCurrentUrl(nextUrl);
      if (!addressEditingRef.current) setAddressValue(nextUrl);
      syncNavigationState();
      if (isHttpUrl(nextUrl)) onUrlChangeRef.current?.(nextUrl);
    };
    const handleTitle = (event: Event) => {
      setTitle((event as unknown as { title?: string }).title || '');
    };
    const handleFail = (event: Event) => {
      const detail = event as unknown as { errorDescription?: string; errorCode?: number; validatedURL?: string };
      if (detail.errorCode === -3) return;
      setLoading(false);
      setError(detail.errorDescription || t('browserPane.couldNotLoad', { url: detail.validatedURL || 'page', defaultValue: 'Could not load {{url}}' }));
    };

    webview.addEventListener('did-start-loading', handleStart);
    webview.addEventListener('did-stop-loading', handleStop);
    webview.addEventListener('did-navigate', handleNavigate);
    webview.addEventListener('did-navigate-in-page', handleNavigate);
    webview.addEventListener('did-fail-load', handleFail);
    webview.addEventListener('page-title-updated', handleTitle);

    return () => {
      webview.removeEventListener('did-start-loading', handleStart);
      webview.removeEventListener('did-stop-loading', handleStop);
      webview.removeEventListener('did-navigate', handleNavigate);
      webview.removeEventListener('did-navigate-in-page', handleNavigate);
      webview.removeEventListener('did-fail-load', handleFail);
      webview.removeEventListener('page-title-updated', handleTitle);
    };
  }, [available, syncNavigationState]);

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    const target = normalizeInput(addressValue);
    if (!target) {
      setError(t('browserPane.invalidUrl', 'Enter a valid http(s) URL'));
      return;
    }
    addressEditingRef.current = false;
    loadUrl(target);
  };

  const handleOpenExternal = () => {
    const target = currentUrl || url;
    if (isHttpUrl(target)) void bridge?.openExternal?.(target);
  };

  if (!available) {
    return <RemoteBrowserPane url={url} isActive={isActive} onUrlChange={onUrlChange} className={className} />;
  }

  return (
    <div className={cn('flex h-full min-h-0 flex-col overflow-hidden', className)} data-active={isActive}>
      <form
        onSubmit={handleSubmit}
        className="flex h-9 shrink-0 items-center gap-1 border-b border-border/50 bg-muted/30 px-2"
      >
        <button
          type="button"
          onClick={() => webviewRef.current?.goBack()}
          disabled={!canGoBack}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
          aria-label={t('browserPane.back', 'Back')}
          title={t('browserPane.back', 'Back')}
        >
          <ArrowLeft className="h-3.5 w-3.5" />
        </button>
        <button
          type="button"
          onClick={() => webviewRef.current?.goForward()}
          disabled={!canGoForward}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
          aria-label={t('browserPane.forward', 'Forward')}
          title={t('browserPane.forward', 'Forward')}
        >
          <ArrowRight className="h-3.5 w-3.5" />
        </button>
        <button
          type="button"
          onClick={() => (loading ? webviewRef.current?.stop() : webviewRef.current?.reload())}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
          aria-label={loading ? t('browserPane.stop', 'Stop') : t('browserPane.reload', 'Reload')}
          title={loading ? t('browserPane.stop', 'Stop') : t('browserPane.reload', 'Reload')}
        >
          {loading ? <X className="h-3.5 w-3.5" /> : <RotateCw className="h-3.5 w-3.5" />}
        </button>
        <input
          type="text"
          value={addressValue}
          onChange={(event) => setAddressValue(event.target.value)}
          onFocus={(event) => {
            addressEditingRef.current = true;
            event.currentTarget.select();
          }}
          onBlur={() => {
            addressEditingRef.current = false;
            setAddressValue(currentUrl || '');
          }}
          placeholder={t('browserPane.enterUrl', 'Enter URL')}
          className="mx-1 min-w-0 flex-1 rounded border border-border/60 bg-background/80 px-2 py-0.5 text-xs text-foreground outline-none transition-colors placeholder:text-muted-foreground/60 hover:bg-background focus:ring-1 focus:ring-primary/40"
          aria-label={t('browserPane.address', 'Address')}
        />
        <button
          type="button"
          onClick={handleOpenExternal}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
          aria-label={t('browserPane.openExternal', 'Open in system browser')}
          title={t('browserPane.openExternal', 'Open in system browser')}
        >
          <ExternalLink className="h-3.5 w-3.5" />
        </button>
      </form>

      {error && (
        <div className="shrink-0 border-b border-border/50 bg-destructive/10 px-3 py-1 text-xs text-destructive">
          {error}
        </div>
      )}

      <div className="relative min-h-0 flex-1">
        {title && (
          <div className="pointer-events-none absolute inset-x-0 top-0 z-10 truncate bg-background/70 px-3 py-0.5 text-[11px] text-muted-foreground">
            {title}
          </div>
        )}
        <webview
          ref={(element: WebviewElement | null) => {
            webviewRef.current = element;
          }}
          src={isHttpUrl(url) ? url : undefined}
          className="h-full w-full border-0 bg-background"
        />
      </div>
    </div>
  );
};

export default WebBrowserPane;
export { WebBrowserPane };
