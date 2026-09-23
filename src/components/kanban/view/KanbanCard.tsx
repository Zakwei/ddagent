import { AlertCircle, GitBranch, GitPullRequest, Loader2, MessageSquare, Pencil } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { Button } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import type { KanbanCard } from '../types';

type KanbanCardProps = {
  card: KanbanCard;
  /** Display name of the card's assignee, when assigned. */
  assigneeName?: string;
  onOpen: (card: KanbanCard) => void;
  onEdit: (card: KanbanCard) => void;
  onOpenSession: (card: KanbanCard) => void;
  onAbort: (card: KanbanCard) => void;
  onDelete: (card: KanbanCard) => void;
  onDragStart: (card: KanbanCard) => void;
  onDragEnd: () => void;
  isDragging: boolean;
};

function relativeTime(value: string): string {
  const timestamp = new Date(value).getTime();
  if (!Number.isFinite(timestamp)) return '';
  const seconds = Math.max(0, Math.floor((Date.now() - timestamp) / 1000));
  if (seconds < 60) return 'just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  return `${Math.floor(hours / 24)}d ago`;
}

function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (parts.length === 0) return '?';
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
  return `${parts[0][0]}${parts[1][0]}`.toUpperCase();
}

export default function KanbanCardItem({
  card,
  assigneeName,
  onOpen,
  onEdit,
  onOpenSession,
  onAbort,
  onDelete,
  onDragStart,
  onDragEnd,
  isDragging,
}: KanbanCardProps) {
  const { t } = useTranslation('tasks');
  const isWorking = card.status === 'working';
  const needsDecision = card.status === 'needs_decision';

  return (
    <article
      draggable
      onDragStart={() => onDragStart(card)}
      onDragEnd={onDragEnd}
      onClick={() => onOpen(card)}
      className={cn(
        'group cursor-pointer rounded-lg border border-border/70 bg-card p-3 text-left shadow-sm transition-shadow hover:shadow-md',
        isDragging && 'opacity-50',
        needsDecision && 'border-amber-400/70 dark:border-amber-500/50',
      )}
    >
      <div className="flex items-start justify-between gap-2">
        <button
          type="button"
          onClick={(event) => {
            event.stopPropagation();
            onOpen(card);
          }}
          className="rounded-sm text-left text-sm font-medium leading-snug text-foreground hover:underline focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
        >
          {card.title}
        </button>
        <span className="flex flex-shrink-0 items-center gap-1.5">
          {assigneeName && (
            <span
              title={assigneeName}
              className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/15 text-[9px] font-semibold text-primary"
            >
              {initials(assigneeName)}
            </span>
          )}
          <span className="text-[11px] text-muted-foreground">{relativeTime(card.updatedAt)}</span>
        </span>
      </div>

      {card.statusMessage && (
        <p className={cn('mt-1.5 flex items-start gap-1 text-xs', needsDecision ? 'text-amber-700 dark:text-amber-300' : 'text-muted-foreground')}>
          {needsDecision && <AlertCircle className="mt-0.5 h-3 w-3 flex-shrink-0" />}
          <span className="line-clamp-2">{card.statusMessage}</span>
        </p>
      )}

      <div className="mt-2 flex flex-wrap items-center gap-x-3 gap-y-1 text-[11px] text-muted-foreground">
        {card.branch && (
          <span className="flex min-w-0 items-center gap-1">
            <GitBranch className="h-3 w-3 flex-shrink-0" />
            <code className="truncate">{card.branch}</code>
          </span>
        )}
        {card.prUrl && (
          <a
            href={card.prUrl}
            target="_blank"
            rel="noreferrer"
            onClick={(event) => event.stopPropagation()}
            className="flex items-center gap-1 hover:text-foreground"
          >
            <GitPullRequest className="h-3 w-3 flex-shrink-0" />
            <span>{t('board.card.pullRequest')}</span>
          </a>
        )}
        {card.sessionId && (
          <button
            type="button"
            onClick={(event) => {
              event.stopPropagation();
              onOpenSession(card);
            }}
            aria-label={t('board.card.openSession')}
            className="flex items-center gap-1 rounded-sm text-primary/80 transition-colors hover:text-primary hover:underline focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
          >
            <MessageSquare className="h-3 w-3 flex-shrink-0" />
            <span>{t('board.card.openSession')}</span>
          </button>
        )}
      </div>

      {isWorking && (
        <div className="mt-2 flex items-center justify-between">
          <span className="flex items-center gap-1 text-[11px] font-medium text-blue-600 dark:text-blue-400">
            <Loader2 className="h-3 w-3 animate-spin" />
            {t('board.card.running')}
          </span>
          <Button
            variant="ghost"
            size="sm"
            className="h-6 px-2 text-[11px]"
            onClick={(event) => {
              event.stopPropagation();
              onAbort(card);
            }}
          >
            {t('board.card.abort')}
          </Button>
        </div>
      )}

      <div className="mt-1 flex justify-end gap-2 opacity-100 transition-opacity focus-within:opacity-100 sm:opacity-0 sm:group-focus-within:opacity-100 sm:group-hover:opacity-100">
        {/* Cards with a session open the session on click, so the edit dialog
            needs its own affordance (assignee, title, description). */}
        <button
          type="button"
          onClick={(event) => {
            event.stopPropagation();
            onEdit(card);
          }}
          aria-label={t('board.card.edit', { defaultValue: 'Edit card' })}
          className="flex items-center gap-0.5 text-[11px] text-muted-foreground hover:text-foreground"
        >
          <Pencil className="h-3 w-3" />
          {t('board.card.edit', { defaultValue: 'Edit' })}
        </button>
        <button
          type="button"
          onClick={(event) => {
            event.stopPropagation();
            onDelete(card);
          }}
          className="text-[11px] text-muted-foreground hover:text-destructive"
        >
          {t('board.card.delete')}
        </button>
      </div>
    </article>
  );
}
