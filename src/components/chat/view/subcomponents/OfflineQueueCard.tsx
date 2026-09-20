import { useTranslation } from 'react-i18next';
import { WifiOff, Clock, XIcon } from 'lucide-react';

interface OfflineQueueCardProps {
  count: number;
  onClear?: () => void;
}

export default function OfflineQueueCard({ count, onClear }: OfflineQueueCardProps) {
  const { t } = useTranslation('chat');

  return (
    <div
      role="status"
      aria-live="polite"
      className="settings-content-enter mx-auto mb-2 max-w-[54.25rem] rounded-xl border border-dashed border-amber-500/30 bg-amber-500/[0.08] px-3 py-2 text-amber-900 dark:text-amber-200"
    >
      <div className="flex items-center justify-between gap-2.5">
        <div className="flex min-w-0 flex-1 items-center gap-2">
          <WifiOff className="h-4 w-4 shrink-0 text-amber-600 dark:text-amber-400" aria-hidden="true" />
          <Clock className="h-3.5 w-3.5 shrink-0 text-amber-600/80 dark:text-amber-400/80" aria-hidden="true" />
          <span className="truncate text-xs font-medium">
            {count === 1
              ? t('input.offlineQueue.single', {
                  defaultValue: '1 message queued offline — will send automatically when reconnected',
                })
              : t('input.offlineQueue.multiple', {
                  count,
                  defaultValue: `${count} messages queued offline — will send automatically when reconnected`,
                })}
          </span>
        </div>

        {onClear && (
          <button
            type="button"
            onClick={onClear}
            aria-label={t('input.offlineQueue.clear', { defaultValue: 'Cancel and clear offline queue' })}
            title={t('input.offlineQueue.clear', { defaultValue: 'Cancel and clear' })}
            className="flex items-center gap-1 rounded-md px-1.5 py-1 text-xs text-amber-800 transition-colors hover:bg-amber-500/20 dark:text-amber-300"
          >
            <XIcon className="h-3.5 w-3.5" />
            <span className="hidden sm:inline">{t('input.offlineQueue.clearBtn', { defaultValue: 'Cancel' })}</span>
          </button>
        )}
      </div>
    </div>
  );
}
