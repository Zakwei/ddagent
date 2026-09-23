import { Globe, MessageSquare, MonitorPlay, NotebookPen, Terminal, TriangleAlert, X } from 'lucide-react';
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../lib/utils';

export type SplitOverviewPaneAction = 'question' | 'processing' | 'idle';

export type SplitOverviewPaneInfo = {
  id: string;
  kind: 'chat' | 'browser' | 'terminal' | 'preview' | 'notes';
  title: string;
  action: SplitOverviewPaneAction;
  subtitle?: string;
};

type SplitOverviewDialogProps = {
  open: boolean;
  onClose: () => void;
  panes: SplitOverviewPaneInfo[];
  /** Highlights the tile that currently owns workspace focus. */
  activePaneId?: string | null;
  onSelectPane: (id: string) => void;
};

const KIND_ICON = {
  chat: MessageSquare,
  browser: Globe,
  terminal: Terminal,
  preview: MonitorPlay,
  notes: NotebookPen,
} as const;

function SplitOverviewDialog({
  open,
  onClose,
  panes,
  activePaneId,
  onSelectPane,
}: SplitOverviewDialogProps) {
  const { t } = useTranslation('chat');

  useEffect(() => {
    if (!open) return;

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.stopPropagation();
        onClose();
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-label={t('splitOverview.title', { defaultValue: 'Split panes overview' })}
      className="fixed inset-0 z-50 flex flex-col bg-background/95 backdrop-blur-sm"
      onClick={onClose}
    >
      {/* Header and grid are dialog content — clicks there must not bubble
          to the backdrop's onClose. */}
      <div
        className="flex shrink-0 items-center justify-between border-b border-border/60 px-4 py-3"
        onClick={(event) => event.stopPropagation()}
      >
        <div className="flex items-center gap-2">
          <h2 className="text-sm font-semibold text-foreground">
            {t('splitOverview.title', { defaultValue: 'Split panes overview' })}
          </h2>
          <span className="text-xs text-muted-foreground">
            {t('splitOverview.count', { defaultValue: '{{count}} panes', count: panes.length })}
          </span>
        </div>
        <button
          type="button"
          onClick={onClose}
          aria-label={t('splitOverview.close', { defaultValue: 'Close overview' })}
          className="flex h-8 w-8 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
        >
          <X className="h-4 w-4" />
        </button>
      </div>

      <div
        className="grid min-h-0 flex-1 auto-rows-fr grid-cols-1 gap-3 overflow-y-auto p-4 sm:grid-cols-2 lg:grid-cols-3"
        onClick={(event) => event.stopPropagation()}
      >
        {panes.map((pane) => {
          const Icon = KIND_ICON[pane.kind];
          const isActive = pane.id === activePaneId;
          return (
            <button
              key={pane.id}
              type="button"
              onClick={(event) => {
                event.stopPropagation();
                onSelectPane(pane.id);
                onClose();
              }}
              aria-current={isActive || undefined}
              className={cn(
                'group flex min-h-[120px] flex-col justify-between rounded-lg border p-4 text-left transition-colors',
                pane.action === 'question'
                  ? 'border-amber-500/50 bg-amber-500/5 hover:bg-amber-500/10'
                  : pane.action === 'processing'
                    ? 'border-green-500/40 bg-green-500/5 hover:bg-green-500/10'
                    : 'border-border/60 bg-card hover:bg-muted/50',
                isActive && 'ring-2 ring-primary/60',
              )}
            >
              <div className="flex items-center gap-2 text-muted-foreground">
                <Icon className="h-4 w-4 shrink-0" />
                <span className="text-[11px] uppercase tracking-wide">{pane.kind}</span>
                {isActive && (
                  <span className="ml-auto text-[10px] font-semibold uppercase tracking-wide text-primary">
                    {t('splitOverview.active', { defaultValue: 'Active' })}
                  </span>
                )}
              </div>

              <div className="mt-3 min-w-0">
                <div className="truncate text-2xl font-semibold uppercase leading-tight text-foreground">
                  {pane.title}
                </div>
                {pane.subtitle && (
                  <div className="mt-1 truncate text-xs text-muted-foreground">{pane.subtitle}</div>
                )}
              </div>

              <div className="mt-3 flex min-h-5 items-center gap-1.5 text-xs">
                {pane.action === 'question' && (
                  <span className="inline-flex items-center gap-1 font-medium text-amber-600 dark:text-amber-400">
                    <TriangleAlert className="h-3.5 w-3.5" />
                    {t('splitOverview.question', { defaultValue: 'QUESTION — input required' })}
                  </span>
                )}
                {pane.action === 'processing' && (
                  <span className="inline-flex items-center gap-1 text-green-600 dark:text-green-400">
                    <span className="h-2 w-2 animate-pulse rounded-full bg-green-500" />
                    {t('splitOverview.processing', { defaultValue: 'PROCESSING' })}
                  </span>
                )}
              </div>
            </button>
          );
        })}
      </div>
    </div>
  );
}

export default SplitOverviewDialog;
