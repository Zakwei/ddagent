import { useEffect, useState } from 'react';
import { createPortal } from 'react-dom';
import { Loader2, RotateCw, Server } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { api } from '../../../utils/api';

type RestartStatus = 'confirm' | 'restarting' | 'unsupported' | 'failed';

const HEALTH_POLL_INTERVAL_MS = 1000;
const RESTART_POLL_TIMEOUT_MS = 60_000;
/** Bar eases to ~90% over this window, then waits for /health to come back. */
const EXPECTED_RESTART_MS = 12_000;

/**
 * Settings → About: "Restart" button. POSTs /api/system/restart; under systemd
 * the process exits and the watchdog brings it back, so a full-screen overlay
 * with a progress bar takes over, polls /health and reloads once the server
 * responds again.
 */
export default function RestartSection() {
  const { t } = useTranslation(['settings', 'common']);
  const [status, setStatus] = useState<RestartStatus | null>(null);
  const [errorDetail, setErrorDetail] = useState('');
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    if (status !== 'restarting') {
      return undefined;
    }
    const startedAt = Date.now();
    const timer = setInterval(async () => {
      const elapsed = Date.now() - startedAt;
      setProgress(Math.min(90, (elapsed / EXPECTED_RESTART_MS) * 90));
      try {
        const response = await fetch('/health');
        if (response.ok && elapsed > 1500) {
          setProgress(100);
          setTimeout(() => window.location.reload(), 400);
          return;
        }
      } catch {
        // Server down mid-restart — keep polling until the deadline.
      }
      if (elapsed > RESTART_POLL_TIMEOUT_MS) {
        clearInterval(timer);
        setStatus('failed');
      }
    }, HEALTH_POLL_INTERVAL_MS);
    return () => clearInterval(timer);
  }, [status]);

  const close = () => {
    if (status !== 'restarting') {
      setStatus(null);
      setErrorDetail('');
      setProgress(0);
    }
  };

  const runRestart = async () => {
    setStatus('restarting');
    setErrorDetail('');
    try {
      const response = await api.post('/system/restart');
      const data = await response.json().catch(() => ({}));
      if (!response.ok) {
        setErrorDetail(data.error || `HTTP ${response.status}`);
        setStatus('failed');
        return;
      }
      if (!data.restarting) {
        setStatus('unsupported');
      }
      // 'restarting' → the poll effect takes over from here.
    } catch (error) {
      setErrorDetail(error instanceof Error ? error.message : String(error));
      setStatus('failed');
    }
  };

  return (
    <div className="border-t border-border/50 pt-6">
      <div className="flex items-center justify-between gap-3">
        <div className="min-w-0">
          <h3 className="flex items-center gap-2 text-sm font-medium text-foreground">
            <Server className="h-4 w-4 text-muted-foreground" />
            {t('server.title', 'Server')}
          </h3>
          <p className="mt-1 text-xs text-muted-foreground">
            {t('server.description', 'Restart the ddagent process to apply updates or recover from a stuck state.')}
          </p>
        </div>
        <button
          type="button"
          onClick={() => setStatus('confirm')}
          className="inline-flex flex-shrink-0 items-center gap-2 rounded-lg border border-border/60 bg-background px-3 py-1.5 text-xs font-medium text-muted-foreground transition-colors hover:bg-muted/50 hover:text-foreground"
        >
          <RotateCw className="h-3.5 w-3.5" />
          {t('server.restart', 'Restart')}
        </button>
      </div>

      {/* Full-screen restart overlay — sits above the settings modal
          (z-9999) and takes over the whole page while the server restarts. */}
      {status === 'restarting' && createPortal(
        <div className="fixed inset-0 z-[10000] flex flex-col items-center justify-center gap-6 bg-background/95 backdrop-blur-md">
          <div className="rounded-full bg-amber-500/10 p-4 text-amber-600 dark:text-amber-400">
            <Loader2 className="h-8 w-8 animate-spin" />
          </div>
          <p className="text-sm font-medium text-foreground">
            {t('server.restarting', 'Restarting… the page will reload when the server is back.')}
          </p>
          <div className="h-1.5 w-64 overflow-hidden rounded-full bg-muted">
            <div
              className="h-full rounded-full bg-amber-500 transition-[width] duration-1000 ease-linear"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>,
        document.body,
      )}

      {/* Confirm / error dialog — portal keeps the fixed overlay out of any
          containing block created by ancestor transforms/backdrop filters. */}
      {status !== null && status !== 'restarting' && createPortal(
        <div className="fixed inset-0 z-[10000] flex items-center justify-center p-4">
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm" onClick={close} />
          <div
            className="relative flex w-full max-w-md flex-col overflow-hidden rounded-xl border border-border bg-card shadow-2xl"
            role="dialog"
            aria-modal="true"
            aria-label={t('server.restart', 'Restart')}
          >
            <div className="flex items-center px-6 pt-6">
              <div className="mr-3 rounded-full bg-amber-500/10 p-2 text-amber-600 dark:text-amber-400">
                <RotateCw className="h-4 w-4" />
              </div>
              <h3 className="text-lg font-semibold text-foreground">
                {status === 'failed' ? t('server.restartFailed', 'Restart failed') : t('server.restart', 'Restart server')}
              </h3>
            </div>

            <div className="my-4 whitespace-pre-wrap break-words px-6 text-sm text-muted-foreground">
              {status === 'confirm' && t('server.restartConfirm', 'Restart the ddagent server? Active sessions will be interrupted.')}
              {status === 'unsupported' && t('server.unsupported', 'Restart is only available when the server runs under the service manager.')}
              {status === 'failed' && (errorDetail || t('server.restartFailed', 'Restart failed'))}
            </div>

            <div className="flex items-center justify-end px-6 pb-6">
              <div className="flex space-x-3">
                {status === 'confirm' && (
                  <>
                    <button
                      type="button"
                      onClick={close}
                      className="rounded-lg px-4 py-2 text-sm text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
                    >
                      {t('common:buttons.cancel', 'Cancel')}
                    </button>
                    <button
                      type="button"
                      onClick={() => void runRestart()}
                      className="flex items-center space-x-2 rounded-lg bg-amber-600 px-4 py-2 text-sm text-white transition-colors hover:bg-amber-500"
                    >
                      <RotateCw className="h-4 w-4" />
                      <span>{t('server.restart', 'Restart')}</span>
                    </button>
                  </>
                )}
                {(status === 'failed' || status === 'unsupported') && (
                  <button
                    type="button"
                    onClick={close}
                    className="rounded-lg px-4 py-2 text-sm text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
                  >
                    {t('common:buttons.close', 'Close')}
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>,
        document.body,
      )}
    </div>
  );
}
