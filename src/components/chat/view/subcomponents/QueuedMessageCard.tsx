import { useTranslation } from 'react-i18next';
import { PencilIcon, SendIcon, XIcon } from 'lucide-react';

export interface QueuedMessageListItem {
  id: number | string;
  content: string;
  attachmentCount?: number;
  status?: 'queued' | 'sending' | 'failed';
}

interface QueuedMessageCardProps {
  /** One queued message; the composer renders one card per list item. */
  message: QueuedMessageListItem;
  /** Abort the running turn and dispatch this message immediately. */
  onSendNow?: () => void;
  onEdit?: () => void;
  onDelete?: () => void;
  isSending?: boolean;
}

export default function QueuedMessageCard({
  message,
  onSendNow,
  onEdit,
  onDelete,
  isSending = false,
}: QueuedMessageCardProps) {
  const { t } = useTranslation('chat');
  const attachmentCount = message.attachmentCount ?? 0;
  const isFailed = message.status === 'failed';

  return (
    <div className="settings-content-enter mx-auto mb-2 max-w-[54.25rem] rounded-xl rounded-t-none border border-dashed border-primary/25 bg-primary/[0.04] px-3 py-2">
      <div className="flex items-start gap-2.5">
        <span className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-primary/60" aria-hidden />

        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-1.5 text-[11px] font-medium uppercase tracking-wide text-primary/70">
            <span>{t('input.queue.label', { defaultValue: 'Queued' })}</span>
            <span className="normal-case text-muted-foreground/60">
              ·{' '}
              {isFailed
                ? t('input.queue.failed', { defaultValue: 'Failed to send' })
                : t('input.queue.willSend', { defaultValue: 'Will send when this finishes' })}
            </span>
          </div>
          <p className="mt-0.5 line-clamp-2 break-words text-sm text-foreground/90">{message.content}</p>
          {attachmentCount > 0 && (
            <p className="mt-0.5 text-xs text-muted-foreground">
              {attachmentCount} {attachmentCount === 1 ? 'file' : 'files'} attached
            </p>
          )}
        </div>

        <div className="flex shrink-0 items-center gap-0.5">
          {onSendNow && (
            <button
              type="button"
              onClick={onSendNow}
              disabled={isSending}
              aria-label={t('input.queue.sendNow', { defaultValue: 'Send now' })}
              title={t('input.queue.sendNow', { defaultValue: 'Send now' })}
              className="rounded-md p-1.5 text-primary transition-colors hover:bg-primary/10 disabled:cursor-not-allowed disabled:opacity-50"
            >
              <SendIcon className="h-3.5 w-3.5" />
            </button>
          )}
          {onEdit && (
            <button
              type="button"
              onClick={onEdit}
              aria-label={t('input.queue.edit', { defaultValue: 'Edit queued message' })}
              title={t('input.queue.edit', { defaultValue: 'Edit queued message' })}
              className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
            >
              <PencilIcon className="h-3.5 w-3.5" />
            </button>
          )}
          {onDelete && (
            <button
              type="button"
              onClick={onDelete}
              aria-label={t('input.queue.delete', { defaultValue: 'Delete queued message' })}
              title={t('input.queue.delete', { defaultValue: 'Delete queued message' })}
              className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-destructive/10 hover:text-destructive"
            >
              <XIcon className="h-3.5 w-3.5" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
