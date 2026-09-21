import { Folder, Plus, RefreshCw } from 'lucide-react';
import { useCallback, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';

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

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <div className="flex flex-shrink-0 items-center justify-between gap-2 border-b border-border/60 px-4 py-2">
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
          <p className="truncate text-[11px] text-muted-foreground">{t('board.subtitle')}</p>
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

      {cards.length === 0 && !isLoading ? (
        <div className="flex flex-1 flex-col items-center justify-center gap-2 p-8 text-center">
          <p className="text-sm font-medium text-foreground">{t('board.empty.title')}</p>
          <p className="max-w-sm text-xs text-muted-foreground">{t('board.empty.description')}</p>
          <Button size="sm" className="mt-2" onClick={() => setDialogOpen(true)}>
            <Plus />
            {t('board.newCard')}
          </Button>
        </div>
      ) : (
        <div className="min-h-0 flex-1 overflow-auto p-4">
          <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6">
            {columns.map((column) => (
              <KanbanColumnView
                key={column.id}
                column={column}
                onOpen={handleOpenCard}
                onAbort={(card) => void abortCard(card.cardId)}
                onDelete={setPendingDeleteCard}
                onDropCard={handleDropCard}
                draggingCardId={draggingCardId}
                setDraggingCardId={setDraggingCardId}
              />
            ))}
          </div>
        </div>
      )}

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
