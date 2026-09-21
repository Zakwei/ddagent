import { Plus } from 'lucide-react';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import type { DragEvent } from 'react';

import { cn } from '../../../lib/utils';
import type { KanbanCard } from '../types';
import type { KanbanColumn } from '../utils/kanbanColumns';
import { USER_MOVABLE_STATUSES } from '../utils/kanbanColumns';

import KanbanCardItem from './KanbanCard';

type KanbanColumnViewProps = {
  column: KanbanColumn;
  onOpen: (card: KanbanCard) => void;
  onAbort: (card: KanbanCard) => void;
  onDelete: (card: KanbanCard) => void;
  onDropCard: (cardId: string, status: KanbanColumn['id']) => void;
  onAddCard?: () => void;
  draggingCardId: string | null;
  setDraggingCardId: (cardId: string | null) => void;
};

export default function KanbanColumnView({
  column,
  onOpen,
  onAbort,
  onDelete,
  onDropCard,
  onAddCard,
  draggingCardId,
  setDraggingCardId,
}: KanbanColumnViewProps) {
  const { t } = useTranslation('tasks');
  const [isOver, setIsOver] = useState(false);
  const isDroppable = USER_MOVABLE_STATUSES.has(column.id);

  const handleDragOver = (event: DragEvent<HTMLDivElement>) => {
    if (!isDroppable || !draggingCardId) return;
    event.preventDefault();
    setIsOver(true);
  };

  const handleDrop = (event: DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    setIsOver(false);
    if (!isDroppable || !draggingCardId) return;
    onDropCard(draggingCardId, column.id);
  };

  return (
    <div
      onDragOver={handleDragOver}
      onDragLeave={() => setIsOver(false)}
      onDrop={handleDrop}
      className={cn(
        'flex min-h-[220px] flex-col rounded-xl border bg-muted/30 shadow-sm',
        isOver && 'border-primary/60 bg-primary/5',
      )}
    >
      <div className={cn('flex items-center justify-between rounded-t-xl px-3 py-2', column.headerClass)}>
        <div className="flex items-center gap-2">
          <span className={cn('h-2 w-2 rounded-full', column.accent)} />
          <span className="text-sm font-semibold">{column.title}</span>
        </div>
        <span className="rounded-full bg-white/60 px-2 py-0.5 text-xs font-medium dark:bg-black/20">
          {column.cards.length}
        </span>
      </div>

      <div className="max-h-[calc(100vh-320px)] min-h-[120px] flex-1 space-y-2 overflow-y-auto p-2">
        {column.cards.map((card) => (
          <KanbanCardItem
            key={card.cardId}
            card={card}
            onOpen={onOpen}
            onAbort={onAbort}
            onDelete={onDelete}
            onDragStart={(dragged) => setDraggingCardId(dragged.cardId)}
            onDragEnd={() => setDraggingCardId(null)}
            isDragging={draggingCardId === card.cardId}
          />
        ))}
        {column.cards.length === 0 && onAddCard && (
          <button
            type="button"
            onClick={onAddCard}
            className="flex w-full items-center justify-center gap-1 rounded-lg border border-dashed border-border py-2 text-xs text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
          >
            <Plus className="h-3.5 w-3.5" />
            {t('board.addCard', 'Add card')}
          </button>
        )}
      </div>
    </div>
  );
}
