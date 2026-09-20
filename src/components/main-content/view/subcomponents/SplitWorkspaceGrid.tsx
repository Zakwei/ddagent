import { GripVertical, X } from 'lucide-react';
import { useCallback, useState } from 'react';
import type { DragEvent, ReactNode } from 'react';

import { cn } from '../../../../lib/utils';
import { getSplitLayout, type SplitPane } from '../../utils/splitWorkspace';

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
      className={cn('grid h-full min-h-0 w-full gap-1 overflow-hidden', className)}
      style={{
        gridTemplateColumns: `repeat(${gridColumns}, minmax(0, 1fr))`,
        gridTemplateRows: `repeat(${layout.rows}, minmax(0, 1fr))`,
      }}
      data-split-columns={layout.columns}
      data-split-rows={layout.rows}
    >
      {panes.map((pane, index) => {
        const isActive = activePaneId === pane.id;
        return (
          <div
            key={pane.id}
            data-pane-id={pane.id}
            style={
              lastRowPartial
                ? { gridColumn: `span ${index < lastRowStart ? lastRowCount : layout.columns}` }
                : undefined
            }
            className={cn(
              'relative flex min-h-0 flex-col',
              singlePane
                ? 'overflow-hidden'
                : 'overflow-hidden rounded border border-border/50',
              dragOverIndex === index && 'ring-2 ring-primary/50',
              isActive && !singlePane && 'border-primary/60',
            )}
            onMouseDown={() => onActivatePane?.(pane.id)}
            onFocusCapture={() => onActivatePane?.(pane.id)}
            onDragOver={(event) => handleDragOver(event, index)}
            onDragLeave={() => handleDragLeave(index)}
            onDrop={(event) => handleDrop(event, index)}
          >
            {shouldRenderHeader && (
              <div className="flex h-7 shrink-0 items-center justify-between border-b border-border/50 bg-muted/30 px-1 text-xs text-muted-foreground">
                <div className="flex min-w-0 flex-1 items-center gap-1">
                  {!singlePane && (
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
