import { Globe, GripVertical, MessageSquare, MonitorPlay, Terminal, X } from 'lucide-react';
import { useCallback, useState } from 'react';
import type { DragEvent, ReactNode } from 'react';

import { cn } from '../../../../lib/utils';
import { getSplitLayout, type SplitPane } from '../../utils/splitWorkspace';

const PANE_KIND_ICONS = {
  chat: MessageSquare,
  browser: Globe,
  terminal: Terminal,
  preview: MonitorPlay,
} as const;

type SplitWorkspaceGridProps = {
  panes: SplitPane[];
  activePaneId?: string | null;
  onActivatePane?: (id: string) => void;
  onClosePane: (id: string) => void;
  onReorderPanes: (fromId: string, toIndex: number) => void;
  renderPane: (pane: SplitPane, isActive: boolean) => ReactNode;
  /**
   * Rich header content (session title, picker, menu) rendered between the drag
   * handle and the close button. The grid owns drag + close so reordering and
   * closing keep working.
   */
  renderPaneHeaderContent?: (pane: SplitPane) => ReactNode;
  /** Fallback title used when no renderPaneHeaderContent is supplied. */
  getPaneTitle?: (pane: SplitPane) => string;
  renderPaneHeaderExtra?: (pane: SplitPane) => ReactNode;
  /** Force the header on/off regardless of pane count (desktop shows it always). */
  showPaneHeader?: boolean;
  /**
   * On mobile (<768px) a multi-pane workspace renders as a tab strip plus a
   * single pane instead of the grid — narrow screens cannot fit split tiles.
   */
  isMobile?: boolean;
  className?: string;
};

export function SplitWorkspaceGrid({
  panes,
  activePaneId,
  onActivatePane,
  onClosePane,
  onReorderPanes,
  renderPane,
  renderPaneHeaderContent,
  getPaneTitle,
  renderPaneHeaderExtra,
  showPaneHeader,
  isMobile,
  className,
}: SplitWorkspaceGridProps) {
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);
  const layout = getSplitLayout(panes.length);
  const singlePane = panes.length === 1;
  // A short last row stretches to the full width: switch to a finer column
  // grid so each last-row pane spans evenly (5 panes → 6 columns; the top
  // row spans 2 each, the bottom row spans 3 each and fills the row).
  const lastRowStart = layout.columns * (layout.rows - 1);
  const lastRowCount = panes.length - lastRowStart;
  const lastRowPartial = lastRowCount > 0 && lastRowCount < layout.columns;
  const gridColumns = lastRowPartial ? layout.columns * lastRowCount : layout.columns;
  // Multiple panes always need their own chrome; a single pane is configurable
  // because the mobile layout hides it to preserve screen space.
  const shouldRenderHeader = showPaneHeader ?? panes.length > 1;
  // Mobile keeps the persisted split intact but mounts only the active pane —
  // a compact tab strip switches between them so a desktop split survives a
  // phone visit without stacking unusable tiles.
  const mobileTabMode = Boolean(isMobile) && panes.length > 1;
  const mobileActivePane = mobileTabMode
    ? (panes.find((pane) => pane.id === activePaneId) ?? panes[0])
    : null;

  const handleDragStart = useCallback((event: DragEvent<HTMLDivElement>, paneId: string) => {
    event.dataTransfer.setData('text/plain', paneId);
    event.dataTransfer.effectAllowed = 'move';
  }, []);

  const handleDragOver = useCallback((event: DragEvent<HTMLDivElement>, index: number) => {
    // OS file drags must pass through to the pane's own attachment drop
    // handler (e.g. ChatInterface) — never treat them as pane reorders.
    if (event.dataTransfer.types.includes('Files')) return;
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
    setDragOverIndex(index);
  }, []);

  const handleDragLeave = useCallback((index: number) => {
    setDragOverIndex((current) => (current === index ? null : current));
  }, []);

  const handleDrop = useCallback(
    (event: DragEvent<HTMLDivElement>, index: number) => {
      // Let OS file drops reach the pane's attachment handler instead of
      // being swallowed by the reorder logic.
      if (event.dataTransfer.types.includes('Files')) return;
      event.preventDefault();
      setDragOverIndex(null);
      const draggedId = event.dataTransfer.getData('text/plain');
      if (draggedId) onReorderPanes(draggedId, index);
    },
    [onReorderPanes],
  );

  if (panes.length === 0) {
    return (
      <div className={cn('h-full min-h-0 w-full overflow-hidden', className)} />
    );
  }

  return (
    <div
      className={cn(
        mobileTabMode
          ? 'flex h-full min-h-0 w-full flex-col overflow-hidden'
          : 'grid h-full min-h-0 w-full gap-1 overflow-hidden',
        className,
      )}
      style={
        mobileTabMode
          ? undefined
          : {
              gridTemplateColumns: `repeat(${gridColumns}, minmax(0, 1fr))`,
              gridTemplateRows: `repeat(${layout.rows}, minmax(0, 1fr))`,
            }
      }
      data-split-columns={layout.columns}
      data-split-rows={layout.rows}
    >
      {mobileActivePane && (
        <div
          role="tablist"
          aria-label="Workspace panes"
          className="flex h-9 shrink-0 items-center gap-1 overflow-x-auto border-b border-border/50 bg-muted/30 px-1.5"
        >
          {panes.map((pane) => {
            const selected = pane.id === mobileActivePane.id;
            const Icon = PANE_KIND_ICONS[pane.kind];
            return (
              <button
                key={pane.id}
                type="button"
                role="tab"
                aria-selected={selected}
                onClick={() => onActivatePane?.(pane.id)}
                className={cn(
                  'flex h-7 max-w-40 shrink-0 items-center gap-1.5 rounded-md px-2.5 text-xs transition-colors',
                  selected
                    ? 'bg-background font-medium text-foreground shadow-sm'
                    : 'text-muted-foreground hover:bg-muted hover:text-foreground',
                )}
              >
                <Icon className="h-3.5 w-3.5 shrink-0" />
                <span className="truncate">
                  {getPaneTitle ? getPaneTitle(pane) : pane.kind}
                </span>
              </button>
            );
          })}
        </div>
      )}
      {panes.map((pane, index) => {
        // Tab mode mounts only the active pane; the rest stay persisted but
        // unmounted, exactly like the pre-strip single-pane mobile layout.
        if (mobileActivePane && pane.id !== mobileActivePane.id) return null;
        const isActive = activePaneId === pane.id;
        const showActiveChrome = isActive && !singlePane && !mobileTabMode;
        return (
          <div
            key={pane.id}
            data-pane-id={pane.id}
            role={mobileTabMode ? 'tabpanel' : undefined}
            style={
              lastRowPartial && !mobileTabMode
                ? { gridColumn: `span ${index < lastRowStart ? lastRowCount : layout.columns}` }
                : undefined
            }
            className={cn(
              'relative flex min-h-0 flex-col',
              mobileTabMode && 'flex-1',
              singlePane || mobileTabMode
                ? 'overflow-hidden'
                : 'overflow-hidden rounded border border-border/50',
              dragOverIndex === index && 'ring-2 ring-primary/50',
              showActiveChrome && 'border-primary/60 ring-1 ring-primary/25',
            )}
            onMouseDown={() => onActivatePane?.(pane.id)}
            onFocusCapture={() => onActivatePane?.(pane.id)}
            onDragOver={(event) => handleDragOver(event, index)}
            onDragLeave={() => handleDragLeave(index)}
            onDrop={(event) => handleDrop(event, index)}
          >
            {shouldRenderHeader && (
              // Terminal panes own a functional header of their own
              // (ShellHeader, compacted to ~36px icon-only in short
              // viewports), so this generic title/close strip folds away on
              // short screens; chat/browser panes keep it as their one bar.
              <div
                className={cn(
                  'flex h-7 shrink-0 items-center justify-between border-b border-border/50 px-1 text-xs text-muted-foreground',
                  showActiveChrome ? 'bg-primary/10' : 'bg-muted/30',
                  pane.kind === 'terminal' && 'short:hidden',
                )}
              >
                <div className="flex min-w-0 flex-1 items-center gap-1">
                  {!singlePane && !mobileTabMode && (
                  <div
                    className="flex h-6 w-6 shrink-0 cursor-grab items-center justify-center rounded text-muted-foreground/70 transition-colors hover:bg-muted hover:text-foreground active:cursor-grabbing"
                    draggable
                    aria-label="Reorder pane"
                    title="Reorder pane"
                    onDragStart={(event) => handleDragStart(event, pane.id)}
                    onDragEnd={() => setDragOverIndex(null)}
                  >
                    <GripVertical className="h-3.5 w-3.5" />
                  </div>
                  )}
                  {renderPaneHeaderContent ? (
                    renderPaneHeaderContent(pane)
                  ) : (
                    <span className="truncate">
                      {getPaneTitle ? getPaneTitle(pane) : pane.kind}
                    </span>
                  )}
                  {renderPaneHeaderExtra && (
                    <div className="ml-1 flex min-w-0 items-center">{renderPaneHeaderExtra(pane)}</div>
                  )}
                </div>
                <button
                  type="button"
                  onClick={() => onClosePane(pane.id)}
                  className="flex h-6 w-6 shrink-0 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
                  aria-label="Close pane"
                  title="Close pane"
                >
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>
            )}
            <div className="min-h-0 flex-1 overflow-hidden">{renderPane(pane, isActive)}</div>
          </div>
        );
      })}
    </div>
  );
}
