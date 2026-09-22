import { Folder, Plus, RefreshCw } from 'lucide-react';
import { useCallback, useMemo, useRef, useState } from 'react';
import type { UIEvent } from 'react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../lib/utils';
import { ActionMenu, Button, Dialog, DialogContent, DialogTitle, type ActionMenuItem } from '../../../shared/view/ui';
import type { Project } from '../../../types/app';
import type { CreateKanbanCardBody, KanbanCard, KanbanCardStatus } from '../types';
import { buildKanbanColumns } from '../utils/kanbanColumns';
import { useKanbanBoard } from '../hooks/useKanbanBoard';

import BoardAgentSettings from './BoardAgentSettings';
import KanbanCardDialog from './KanbanCardDialog';
import KanbanColumnView from './KanbanColumn';

type KanbanPanelProps = {
  selectedProject: Project;
  onOpenSession: (sessionId: string) => void;
  projects?: Project[];
  onSelectProject?: (project: Project) => void;
  isMobile?: boolean;
};

export default function KanbanPanel({
  selectedProject,
  onOpenSession,
  projects,
  onSelectProject,
  isMobile = false,
}: KanbanPanelProps) {
  const { t } = useTranslation('tasks');
  const {
    cards,
    isLoading,
    error,
    refreshCards,
    createCard,
    updateCard,
    moveCard,
    abortCard,
    deleteCard,
  } = useKanbanBoard(selectedProject.projectId);

  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingCard, setEditingCard] = useState<KanbanCard | null>(null);
  const [pendingDeleteCard, setPendingDeleteCard] = useState<KanbanCard | null>(null);
  const [draggingCardId, setDraggingCardId] = useState<string | null>(null);
  const [activeColumnIndex, setActiveColumnIndex] = useState(0);
  const carouselRef = useRef<HTMLDivElement>(null);

  const columns = buildKanbanColumns(cards.filter((card) => !card.isArchived), t);

  const projectMenuItems = useMemo<ActionMenuItem[]>(
    () =>
      (projects ?? []).map((project) => ({
        key: project.projectId,
        label: project.displayName || project.projectId,
        description: project.fullPath,
        onSelect: () => onSelectProject?.(project),
      })),
    [projects, onSelectProject],
  );

  const handleOpenCard = useCallback(
    (card: KanbanCard) => {
      if (card.sessionId) {
        onOpenSession(card.sessionId);
        return;
      }

      // Cards without a session have nothing to open — clicking them edits the card.
      setEditingCard(card);
    },
    [onOpenSession],
  );

  const handleOpenSession = useCallback(
    (card: KanbanCard) => {
      if (card.sessionId) onOpenSession(card.sessionId);
    },
    [onOpenSession],
  );

  const handleDropCard = useCallback(
    (cardId: string, status: KanbanCardStatus) => {
      setDraggingCardId(null);
      void moveCard(cardId, status);
    },
    [moveCard],
  );

  const handleSubmitCard = useCallback(
    async (body: CreateKanbanCardBody) => {
      if (editingCard) {
        await updateCard(editingCard.cardId, body);
        return;
      }

      await createCard(body);
    },
    [createCard, editingCard, updateCard],
  );

  const handleCardDialogOpenChange = useCallback((nextOpen: boolean) => {
    if (!nextOpen) {
      setDialogOpen(false);
      setEditingCard(null);
    }
  }, []);

  // Below md the columns render as a snap carousel; the stride is measured
  // from the DOM (column width + gap) so the active tab tracks whichever
  // column is snapped into view.
  const handleColumnsScroll = (event: UIEvent<HTMLDivElement>) => {
    const container = event.currentTarget;
    const first = container.children[0] as HTMLElement | undefined;
    const second = container.children[1] as HTMLElement | undefined;
    const stride = second ? second.offsetLeft - (first?.offsetLeft ?? 0) : (first?.offsetWidth ?? 0);
    if (stride <= 0) return;
    const index = Math.round(container.scrollLeft / stride);
    setActiveColumnIndex(Math.max(0, Math.min(columns.length - 1, index)));
  };

  const scrollToColumn = (index: number) => {
    const target = carouselRef.current?.children[index];
    if (target instanceof HTMLElement) {
      target.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
      setActiveColumnIndex(index);
    }
  };

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <div className="flex flex-shrink-0 items-center justify-between gap-2 border-b border-border/60 px-4 py-2 short:py-1">
        <div className="min-w-0 flex-1">
          {projectMenuItems.length > 0 ? (
            <ActionMenu
              label={selectedProject.displayName || selectedProject.projectId}
              icon={Folder}
              items={projectMenuItems}
              variant="ghost"
              size="sm"
              portal
              header={<span className="text-xs text-muted-foreground">{t('board.projectLabel', 'Project')}</span>}
              // -ml-2 lives on the wrapper: on the trigger it made max-w-full
              // resolve against the margin-box and clipped ~8px of the label.
              className="-ml-2"
              triggerClassName="h-7 max-w-full gap-1 px-2 font-semibold text-foreground"
            />
          ) : (
            <h2 className="truncate text-sm font-semibold text-foreground">
              {selectedProject.displayName || selectedProject.projectId}
            </h2>
          )}
          <p className="truncate text-[11px] text-muted-foreground short:hidden">{t('board.subtitle')}</p>
        </div>
        <div className="flex flex-shrink-0 items-center gap-1">
          <BoardAgentSettings projectId={selectedProject.projectId} isMobile={isMobile} />
          <Button variant="ghost" size="sm" onClick={() => void refreshCards()} disabled={isLoading}>
            <RefreshCw className={isLoading ? 'animate-spin' : ''} />
            {!isMobile && t('board.refresh')}
          </Button>
          <Button size="sm" onClick={() => setDialogOpen(true)}>
            <Plus />
            {!isMobile && t('board.newCard')}
          </Button>
        </div>
      </div>

      {error && <p className="px-4 py-2 text-xs text-destructive">{error}</p>}

      {/* Empty boards still render the column skeletons — each empty column
          offers its own "+ Add card" entry point instead of a blank canvas. */}
      <div className="min-h-0 flex-1 overflow-auto p-4">
        {/* Mobile column tabs — tapping a stage scrolls the carousel straight
            to it instead of swiping past every column. Same pattern as the
            task board carousel in TaskBoardContent. */}
        <div className="scrollbar-hide mb-3 flex items-center gap-1.5 overflow-x-auto md:hidden">
          {columns.map((column, index) => (
            <button
              key={column.id}
              type="button"
              onClick={() => scrollToColumn(index)}
              className={cn(
                'flex flex-shrink-0 items-center gap-1.5 rounded-full px-3 py-1 text-xs font-medium transition-colors',
                activeColumnIndex === index
                  ? 'bg-primary text-primary-foreground shadow-sm'
                  : 'bg-muted text-muted-foreground hover:bg-accent hover:text-foreground',
              )}
            >
              <span className={cn('h-2 w-2 rounded-full', column.accent)} />
              <span>{column.title}</span>
              <span
                className={cn(
                  'rounded-full px-1.5 text-[10px] font-semibold',
                  activeColumnIndex === index
                    ? 'bg-white/25 text-primary-foreground'
                    : 'bg-background/70 text-muted-foreground',
                )}
              >
                {column.cards.length}
              </span>
            </button>
          ))}
        </div>

        {/* Horizontal snap carousel on mobile, the unchanged responsive grid on desktop. */}
        <div
          ref={carouselRef}
          onScroll={handleColumnsScroll}
          className="flex snap-x snap-mandatory flex-nowrap gap-4 overflow-x-auto overscroll-x-contain pb-4 md:grid md:grid-cols-2 md:overflow-visible md:pb-0 lg:grid-cols-3 xl:grid-cols-6"
        >
          {columns.map((column) => (
            <div
              key={column.id}
              className="w-[85vw] max-w-[340px] flex-shrink-0 snap-center md:w-auto md:max-w-none md:flex-shrink"
            >
              <KanbanColumnView
                column={column}
                onOpen={handleOpenCard}
                onOpenSession={handleOpenSession}
                onAbort={(card) => void abortCard(card.cardId)}
                onDelete={setPendingDeleteCard}
                onDropCard={handleDropCard}
                onAddCard={() => setDialogOpen(true)}
                draggingCardId={draggingCardId}
                setDraggingCardId={setDraggingCardId}
              />
            </div>
          ))}
        </div>

        {/* Carousel position dots (mobile only). */}
        <div className="mt-2 flex items-center justify-center gap-1.5 md:hidden">
          {columns.map((column, index) => (
            <button
              key={column.id}
              type="button"
              onClick={() => scrollToColumn(index)}
              aria-label={column.title}
              className={cn(
                'h-1.5 rounded-full transition-all duration-200',
                activeColumnIndex === index ? 'w-5 bg-primary' : 'w-1.5 bg-muted-foreground/30',
              )}
            />
          ))}
        </div>
      </div>

      <KanbanCardDialog
        open={dialogOpen || editingCard !== null}
        onOpenChange={handleCardDialogOpenChange}
        onSubmit={handleSubmitCard}
        card={editingCard}
      />

      {/* Deleting a card is irreversible, so it goes through a confirmation dialog. */}
      <Dialog
        open={pendingDeleteCard !== null}
        onOpenChange={(nextOpen) => {
          if (!nextOpen) setPendingDeleteCard(null);
        }}
      >
        <DialogContent className="max-w-md p-5">
          <DialogTitle className="not-sr-only text-base font-semibold">
            {t('board.deleteConfirm.title', { defaultValue: 'Delete card?' })}
          </DialogTitle>
          <p className="mt-2 text-sm text-muted-foreground">
            {t('board.deleteConfirm.description', {
              cardTitle: pendingDeleteCard?.title ?? '',
              defaultValue: '"{{cardTitle}}" will be permanently deleted.',
            })}
          </p>
          <div className="mt-5 flex justify-end gap-2">
            <Button variant="ghost" size="sm" onClick={() => setPendingDeleteCard(null)}>
              {t('board.dialog.cancel')}
            </Button>
            <Button
              variant="destructive"
              size="sm"
              onClick={() => {
                const card = pendingDeleteCard;
                setPendingDeleteCard(null);
                if (card) void deleteCard(card.cardId);
              }}
            >
              {t('board.card.delete')}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
