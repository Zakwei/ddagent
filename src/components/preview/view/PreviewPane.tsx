import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ExternalLink, Globe, RotateCw } from 'lucide-react';

import { cn } from '../../../lib/utils';

type ListeningPort = {
  port: number;
  address: string;
  pid: number | null;
  processName: string | null;
  cwd: string | null;
};

type PreviewPaneProps = {
  /**
   * Absolute project path — when set, the port list is filtered to processes
   * running inside this directory.
   */
  projectPath?: string | null;
  isActive?: boolean;
  className?: string;
};

type BrowserBridge = {
  openExternal?: (url: string) => Promise<unknown>;
};

const PORTS_POLL_INTERVAL_MS = 5000;

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

const authenticatedFetch = (input: string): Promise<Response> => {
  const token = readStoredToken();
  return fetch(input, {
    headers: token ? { Authorization: `Bearer ${token}` } : {},
  });
};

/**
 * iframe URL for a dev server behind the preview proxy. The `token` query
 * authenticates the document request; the server then drops a cookie scoped to
 * /api/preview so nested asset requests stay authenticated too.
 */
const buildPreviewUrl = (port: number): string => {
  const token = readStoredToken();
  return `/api/preview/${port}/${token ? `?token=${encodeURIComponent(token)}` : ''}`;
};

/**
 * Live dev-server preview: a dropdown of the ports the server discovered on
 * localhost plus an iframe pointed at the proxied app. Dev servers emitting
 * absolute asset paths need a matching base config to render under the prefix.
 */
const PreviewPane = ({ projectPath, isActive = false, className }: PreviewPaneProps) => {
  const { t } = useTranslation('common');
  const [ports, setPorts] = useState<ListeningPort[]>([]);
  const [selectedPort, setSelectedPort] = useState<number | null>(null);
  const [loadError, setLoadError] = useState(false);
  const [reloadTick, setReloadTick] = useState(0);
  const iframeKey = `${selectedPort}:${reloadTick}`;

  const loadPorts = useCallback(async () => {
    try {
      const query = projectPath ? `?projectPath=${encodeURIComponent(projectPath)}` : '';
      const response = await authenticatedFetch(`/api/preview/ports${query}`);
      if (!response.ok) throw new Error(`ports failed: ${response.status}`);
      const data = (await response.json()) as { ports?: ListeningPort[] };
      const next = Array.isArray(data.ports) ? data.ports : [];
      setPorts(next);
      setLoadError(false);
      setSelectedPort((current) =>
        current !== null && next.some((entry) => entry.port === current)
          ? current
          : (next[0]?.port ?? null),
      );
    } catch {
      setLoadError(true);
    }
  }, [projectPath]);

  useEffect(() => {
    void loadPorts();
    const interval = setInterval(() => void loadPorts(), PORTS_POLL_INTERVAL_MS);
    return () => clearInterval(interval);
  }, [loadPorts]);

  // The iframe remounts via `key` on reloadTick, so the URL itself is a plain
  // derived value — no memo needed.
  const previewUrl = selectedPort !== null ? buildPreviewUrl(selectedPort) : null;

  const handleOpenExternal = () => {
    if (!previewUrl) return;
    const bridge = (window as Window & { ddagentBrowser?: BrowserBridge }).ddagentBrowser;
    if (bridge?.openExternal) {
      void bridge.openExternal(new URL(previewUrl, window.location.href).href);
    } else {
      // window.open also covers mobile: PWA opens a browser tab, Expo a WebView.
      window.open(new URL(previewUrl, window.location.href).href, '_blank', 'noopener');
    }
  };

  const portLabel = (entry: ListeningPort) =>
    entry.processName ? `:${entry.port} — ${entry.processName}` : `:${entry.port}`;

  return (
    <div className={cn('flex h-full min-h-0 flex-col overflow-hidden', className)} data-active={isActive}>
      <div className="flex h-9 shrink-0 items-center gap-1 border-b border-border/50 bg-muted/30 px-2">
        <Globe className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
        <select
          value={selectedPort ?? ''}
          onChange={(event) => setSelectedPort(event.target.value ? Number(event.target.value) : null)}
          className="mx-1 min-w-0 flex-1 rounded border border-border/60 bg-background/80 px-2 py-0.5 text-xs text-foreground outline-none transition-colors hover:bg-background focus:ring-1 focus:ring-primary/40"
          aria-label={t('previewPane.selectPort', 'Dev server port')}
        >
          {ports.length === 0 && (
            <option value="">
              {loadError
                ? t('previewPane.loadError', 'Could not load ports')
                : t('previewPane.noServers', 'No dev servers detected')}
            </option>
          )}
          {ports.map((entry) => (
            <option key={entry.port} value={entry.port}>
              {portLabel(entry)}
            </option>
          ))}
        </select>
        <button
          type="button"
          onClick={() => setReloadTick((tick) => tick + 1)}
          disabled={selectedPort === null}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
          aria-label={t('previewPane.reload', 'Reload preview')}
          title={t('previewPane.reload', 'Reload preview')}
        >
          <RotateCw className="h-3.5 w-3.5" />
        </button>
        <button
          type="button"
          onClick={handleOpenExternal}
          disabled={selectedPort === null}
          className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
          aria-label={t('previewPane.openExternal', 'Open in system browser')}
          title={t('previewPane.openExternal', 'Open in system browser')}
        >
          <ExternalLink className="h-3.5 w-3.5" />
        </button>
      </div>

      <div className="relative min-h-0 flex-1">
        {previewUrl ? (
          <iframe
            key={iframeKey}
            src={previewUrl}
            // The URL carries ?token= — never let it leak to the dev server
            // (or anywhere else) through the Referer header.
            referrerPolicy="no-referrer"
            className="h-full w-full border-0 bg-background"
            title={t('previewPane.title', 'Dev server preview')}
          />
        ) : (
          <div className="flex h-full items-center justify-center px-4 text-center text-xs text-muted-foreground">
            {loadError
              ? t('previewPane.loadError', 'Could not load ports')
              : t('previewPane.noServers', 'No dev servers detected')}
          </div>
        )}
      </div>
    </div>
  );
};

export default PreviewPane;
export { PreviewPane };
