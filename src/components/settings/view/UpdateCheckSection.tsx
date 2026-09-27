import { useState } from 'react';
import { ArrowDownToLine, Loader2, RefreshCw } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { version as currentVersion } from '../../../../package.json';

type DesktopUpdateBridge = {
  isDesktop?: boolean;
  checkForUpdates?: () => Promise<{ status?: string; version?: string; message?: string }>;
};

type CheckStatus = 'idle' | 'checking' | 'up-to-date' | 'update-available' | 'downloaded' | 'unavailable' | 'error';

const bridge = (): DesktopUpdateBridge | undefined =>
  (window as Window & { ddagentBrowser?: DesktopUpdateBridge }).ddagentBrowser;

/**
 * Settings → About: manual "Check for updates" for the desktop app. The native
 * menu is auto-hidden on Win/Linux, so this is the discoverable entry point.
 * Downloads start automatically once an update is found and install on quit.
 * Rendered only where the preload exposes the bridge (packaged/unpacked
 * desktop); hidden in the plain web UI where it would be a dead button.
 */
export default function UpdateCheckSection() {
  const { t } = useTranslation('settings');
  const [status, setStatus] = useState<CheckStatus>('idle');
  const [detail, setDetail] = useState('');

  const checkForUpdates = bridge()?.checkForUpdates;
  if (typeof checkForUpdates !== 'function') {
    return null;
  }

  const runCheck = async () => {
    setStatus('checking');
    setDetail('');
    try {
      const result = await checkForUpdates();
      setStatus((result?.status as CheckStatus) || 'error');
      setDetail(result?.version || result?.message || '');
    } catch (error) {
      setStatus('error');
      setDetail(error instanceof Error ? error.message : String(error));
    }
  };

  const resultText = () => {
    switch (status) {
      case 'up-to-date':
        return t('updates.upToDate', 'You are on the latest version (v{{version}}).', { version: currentVersion });
      case 'update-available':
        return t('updates.available', 'Update v{{version}} found — downloading in the background; it installs when you quit ddagent.', { version: detail });
      case 'downloaded':
        return t('updates.downloaded', 'Update v{{version}} downloaded — quit and relaunch ddagent to install.', { version: detail });
      case 'unavailable':
        return t('updates.unavailable', 'Update checks are only available in packaged desktop builds.');
      case 'error':
        return detail
          ? t('updates.error', 'Update check failed: {{message}}', { message: detail })
          : t('updates.errorGeneric', 'Update check failed.');
      default:
        return '';
    }
  };

  const isGood = status === 'up-to-date' || status === 'downloaded' || status === 'update-available';

  return (
    <div className="border-t border-border/50 pt-6">
      <div className="flex items-center justify-between gap-3">
        <div className="min-w-0">
          <h3 className="flex items-center gap-2 text-sm font-medium text-foreground">
            <ArrowDownToLine className="h-4 w-4 text-muted-foreground" />
            {t('updates.title', 'App updates')}
          </h3>
          <p className="mt-1 text-xs text-muted-foreground">
            {t('updates.description', 'Check GitHub for a newer desktop build. New versions download automatically and install when you quit.')}
          </p>
        </div>
        <button
          type="button"
          onClick={() => void runCheck()}
          disabled={status === 'checking'}
          className="inline-flex flex-shrink-0 items-center gap-2 rounded-lg border border-border/60 bg-background px-3 py-1.5 text-xs font-medium text-muted-foreground transition-colors hover:bg-muted/50 hover:text-foreground disabled:opacity-50"
        >
          {status === 'checking'
            ? <Loader2 className="h-3.5 w-3.5 animate-spin" />
            : <RefreshCw className="h-3.5 w-3.5" />}
          {status === 'checking'
            ? t('updates.checking', 'Checking…')
            : t('updates.check', 'Check for updates')}
        </button>
      </div>

      {status !== 'idle' && status !== 'checking' && (
        <p className={`mt-2 text-xs ${status === 'error' ? 'text-red-500' : isGood ? 'text-emerald-600 dark:text-emerald-400' : 'text-muted-foreground'}`}>
          {resultText()}
        </p>
      )}
    </div>
  );
}
