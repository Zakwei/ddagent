import { useEffect, useState } from 'react';
import { CircleArrowUp, ExternalLink, Loader2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { api } from '../../../../utils/api';

type UpdateBadgeProps = {
  latestVersion: string;
  releaseUrl?: string;
  /** 'icon' is the rail button, 'row' a full-width entry for the mobile menu. */
  variant?: 'icon' | 'row';
};

type UpdateStatus = 'confirm' | 'updating' | 'restarting' | 'manual-restart' | 'failed';

const HEALTH_POLL_INTERVAL_MS = 2000;
const RESTART_POLL_TIMEOUT_MS = 90_000;

/**
 * Rail/menu badge shown when GitHub has a newer release than the bundled
 * version. Clicking it offers to run `/api/system/update`; under systemd the
 * server exits and the watchdog brings it back, so the badge polls /health for
 * the new version and reloads to pick up the fresh bundle.
 */
export default function UpdateBadge({ latestVersion, releaseUrl, variant = 'icon' }: UpdateBadgeProps) {
  const { t } = useTranslation(['sidebar', 'common']);
  const [status, setStatus] = useState<UpdateStatus | null>(null);
  const [errorDetail, setErrorDetail] = useState('');

  useEffect(() => {
    if (status !== 'restarting') {
      return undefined;
    }
    const deadline = Date.now() + RESTART_POLL_TIMEOUT_MS;
    const timer = setInterval(async () => {
      try {
        const response = await fetch('/health');
        const data = await response.json();
        if (data.version === latestVersion) {
          window.location.reload();
          return;
        }
      } catch {
        // Server down mid-restart — keep polling until the deadline.
      }
      if (Date.now() > deadline) {
        clearInterval(timer);
        setStatus('manual-restart');
      }
    }, HEALTH_POLL_INTERVAL_MS);
    return () => clearInterval(timer);
  }, [status, latestVersion]);

  const close = () => {
    if (status === 'updating' || status === 'restarting') {
      return;
    }
    setStatus(null);
    setErrorDetail('');
  };

  const runUpdate = async () => {
    setStatus('updating');
    setErrorDetail('');
    try {
      const response = await api.post('/system/update');
      const data = await response.json().catch(() => ({}));
      if (!response.ok || data.success === false) {
        setErrorDetail(data.error || data.errorOutput || `HTTP ${response.status}`);
        setStatus('failed');
        return;
      }
      setStatus(data.restarting ? 'restarting' : 'manual-restart');
    } catch (error) {
      setErrorDetail(error instanceof Error ? error.message : String(error));
      setStatus('failed');
    }
  };

  const label = `${t('version.updateAvailable')} · v${latestVersion}`;

  return (
    <>
      {variant === 'icon' ? (
        <button
          type="button"
          onClick={() => setStatus('confirm')}
          className="relative flex h-9 w-9 items-center justify-center rounded-lg text-emerald-500 transition-colors hover:bg-accent/80"
          aria-label={label}
          title={label}
        >
          <CircleArrowUp className="h-4 w-4" />
          <span className="absolute right-1.5 top-1.5 h-1.5 w-1.5 animate-pulse rounded-full bg-emerald-500" />
        </button>
      ) : (
        <button
          type="button"
          onClick={() => setStatus('confirm')}
          className="mt-1 flex w-full items-center gap-2 rounded-lg border border-emerald-300/60 bg-emerald-50/80 px-2.5 py-2 text-left transition-colors hover:bg-emerald-100/80 dark:border-emerald-700/40 dark:bg-emerald-900/15 dark:hover:bg-emerald-900/25"
        >
          <CircleArrowUp className="h-4 w-4 flex-shrink-0 text-emerald-500 dark:text-emerald-400" />
          <span className="min-w-0 flex-1 text-xs font-medium text-emerald-700 dark:text-emerald-300">
            {label}
          </span>
        </button>
      )}

      {status !== null && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="fixed inset-0 bg-black/60 backdrop-blur-sm" onClick={close} />
          <div
            className="relative flex w-full max-w-md flex-col overflow-hidden rounded-xl border border-border bg-card shadow-2xl"
            role="dialog"
            aria-modal="true"
            aria-label={label}
          >
            <div className="flex items-center px-6 pt-6">
              <div className="mr-3 rounded-full bg-emerald-500/10 p-2 text-emerald-600 dark:text-emerald-400">
                {status === 'updating' || status === 'restarting'
                  ? <Loader2 className="h-4 w-4 animate-spin" />
                  : <CircleArrowUp className="h-4 w-4" />}
              </div>
              <h3 className="text-lg font-semibold text-foreground">
                {status === 'failed' ? t('version.updateFailed') : label}
              </h3>
            </div>

            <div className="scrollbar-thin my-4 max-h-72 overflow-y-auto overscroll-contain whitespace-pre-wrap break-words px-6 text-sm text-muted-foreground">
              {status === 'confirm' && t('version.updateConfirm', { version: latestVersion })}
              {status === 'updating' && t('version.updating')}
              {status === 'restarting' && t('version.restarting')}
              {status === 'manual-restart' && t('version.restartRequired')}
              {status === 'failed' && (errorDetail || t('version.updateFailed'))}
            </div>

            <div className="flex items-center justify-between px-6 pb-6">
              {releaseUrl ? (
                <a
                  href={releaseUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-1 text-xs text-muted-foreground transition-colors hover:text-foreground"
                >
                  {t('version.releaseNotes')}
                  <ExternalLink className="h-3 w-3" />
                </a>
              ) : <span />}

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
                      onClick={() => void runUpdate()}
                      className="flex items-center space-x-2 rounded-lg bg-emerald-600 px-4 py-2 text-sm text-white transition-colors hover:bg-emerald-500"
                    >
                      <CircleArrowUp className="h-4 w-4" />
                      <span>{t('version.updateNow')}</span>
                    </button>
                  </>
                )}
                {(status === 'failed' || status === 'manual-restart') && (
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
        </div>
      )}
    </>
  );
}
