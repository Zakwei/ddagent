import { Globe, LayoutGrid, Maximize2, MessageSquarePlus, Minimize2, Terminal } from 'lucide-react';
import type { ReactNode } from 'react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../lib/utils';
import { Tooltip } from '../../../../shared/view/ui';

import SplitOverviewDialog, { type SplitOverviewPaneInfo } from './SplitOverviewDialog';

type SplitWorkspaceControlsProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  canAddPane: boolean;
  onAddChatPane: () => void;
  onAddBrowserPane: () => void;
  onAddTerminalPane: () => void;
  panes: SplitOverviewPaneInfo[];
  /** Forwarded to the overview dialog so the focused tile is marked. */
  activePaneId?: string | null;
  onSelectPane: (id: string) => void;
  /** Focus mode lives here because the old main header no longer exists. */
  isFocusMode?: boolean;
  onToggleFocusMode?: () => void;
  /** Leading slot (e.g. the mobile hamburger) rendered before the buttons. */
  leading?: ReactNode;
  className?: string;
};

const buttonClass =
  'flex h-7 w-7 shrink-0 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:pointer-events-none disabled:opacity-40';

function SplitWorkspaceControls({
  open,
  onOpenChange,
  canAddPane,
  onAddChatPane,
  onAddBrowserPane,
  onAddTerminalPane,
  panes,
  activePaneId,
  onSelectPane,
  isFocusMode = false,
  onToggleFocusMode,
  leading,
  className,
}: SplitWorkspaceControlsProps) {
  const { t } = useTranslation('chat');

  const addChat = t('splitWorkspace.addChat', { defaultValue: 'Add chat pane' });
  const addBrowser = t('splitWorkspace.addBrowser', { defaultValue: 'Add browser pane' });
  const addTerminal = t('splitWorkspace.addTerminal', { defaultValue: 'Add terminal pane' });
  const overview = t('splitWorkspace.overview', { defaultValue: 'Show all panes' });
  const focusMode = isFocusMode
    ? t('splitWorkspace.exitFocusMode', { defaultValue: 'Exit Focus Mode (Ctrl+Shift+F)' })
    : t('splitWorkspace.focusMode', { defaultValue: 'Focus Mode (Ctrl+Shift+F)' });

  return (
    <>
      {/* In short landscape viewports the pane keeps one compact bar instead of
          stacked chrome. On wide screens (md) the rail already covers app nav,
          so this toolbar collapses away; on narrow/mobile it must stay — it
          carries the only hamburger for the nav menu. */}
      <div className={cn('flex h-9 shrink-0 items-center gap-1 border-b border-border/50 px-2 md:short:hidden', className)}>
        {leading}
        {/* Multi-pane on mobile renders as a tab strip, so pane-adding works
            there too — the cap below is the only limit. */}
        <Tooltip content={addChat} position="bottom">
          <button
            type="button"
            onClick={onAddChatPane}
            disabled={!canAddPane}
            aria-label={addChat}
            className={buttonClass}
          >
            <MessageSquarePlus className="h-4 w-4" />
          </button>
        </Tooltip>
        <Tooltip content={addBrowser} position="bottom">
          <button
            type="button"
            onClick={onAddBrowserPane}
            disabled={!canAddPane}
            aria-label={addBrowser}
            className={buttonClass}
          >
            <Globe className="h-4 w-4" />
          </button>
        </Tooltip>
        <Tooltip content={addTerminal} position="bottom">
          <button
            type="button"
            onClick={onAddTerminalPane}
            disabled={!canAddPane}
            aria-label={addTerminal}
            className={buttonClass}
          >
            <Terminal className="h-4 w-4" />
          </button>
        </Tooltip>

        <Tooltip content={overview} position="bottom">
          <button
            type="button"
            onClick={() => onOpenChange(!open)}
            aria-label={overview}
            aria-pressed={open}
            className={cn(buttonClass, 'ml-auto')}
          >
            <LayoutGrid className="h-4 w-4" />
          </button>
        </Tooltip>

        {onToggleFocusMode && (
          // Remount on toggle: collapsing the sidebar shifts the layout under
          // a still-hovering cursor, so no mouseleave fires and the tooltip
          // would stay stuck at its stale position over the first tile's
          // header. A fresh Tooltip starts hidden and repositions correctly.
          <Tooltip key={isFocusMode ? 'exit' : 'enter'} content={focusMode} position="bottom">
            <button
              type="button"
              onClick={onToggleFocusMode}
              aria-label={focusMode}
              aria-pressed={isFocusMode}
              className={cn(
                buttonClass,
                // On mobile this just toggles the sidebar drawer — the
                // hamburger already covers that.
                'hidden sm:flex',
                isFocusMode && 'bg-muted text-foreground',
              )}
            >
              {isFocusMode ? <Minimize2 className="h-4 w-4" /> : <Maximize2 className="h-4 w-4" />}
            </button>
          </Tooltip>
        )}
      </div>

      <SplitOverviewDialog
        open={open}
        onClose={() => onOpenChange(false)}
        panes={panes}
        activePaneId={activePaneId}
        onSelectPane={onSelectPane}
      />
    </>
  );
}

export default SplitWorkspaceControls;
