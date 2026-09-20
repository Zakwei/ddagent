import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button, Dialog, DialogContent, DialogTitle, Input } from '../../../shared/view/ui';
import type { CreateKanbanCardBody, KanbanCard } from '../types';

type KanbanCardDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSubmit: (body: CreateKanbanCardBody) => Promise<void>;
  card?: KanbanCard | null;
};

export default function KanbanCardDialog({
  open,
  onOpenChange,
  onSubmit,
  card,
}: KanbanCardDialogProps) {
  const { t } = useTranslation('tasks');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!open) return;
    setTitle(card?.title ?? '');
    setDescription(card?.description ?? '');
    setError(null);
  }, [open, card]);

  const canSubmit = title.trim().length > 0 && !isSaving;

  const handleSubmit = async () => {
    if (!canSubmit) return;
    setIsSaving(true);
    setError(null);
    try {
      await onSubmit({ title: title.trim(), description: description.trim() });
      onOpenChange(false);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save card');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md p-5">
        <DialogTitle className="text-base font-semibold">
          {card ? t('board.dialog.editTitle') : t('board.dialog.createTitle')}
        </DialogTitle>

        <div className="mt-4 space-y-3">
          <div className="space-y-1">
            <label className="text-xs font-medium text-muted-foreground" htmlFor="kanban-title">
              {t('board.dialog.titleLabel')}
            </label>
            <Input
              id="kanban-title"
              value={title}
              placeholder={t('board.dialog.titlePlaceholder')}
              onChange={(event) => {
                setTitle(event.target.value);
                if (error) setError(null);
              }}
              onKeyDown={(event) => {
                if (event.key === 'Enter' && !event.shiftKey) {
                  event.preventDefault();
                  void handleSubmit();
                }
              }}
            />
          </div>

          <div className="space-y-1">
            <label className="text-xs font-medium text-muted-foreground" htmlFor="kanban-description">
              {t('board.dialog.descriptionLabel')}
            </label>
            <textarea
              id="kanban-description"
              value={description}
              rows={5}
              placeholder={t('board.dialog.descriptionPlaceholder')}
              onChange={(event) => {
                setDescription(event.target.value);
                if (error) setError(null);
              }}
              className="flex w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
            />
          </div>

          {error && <p className="text-xs text-destructive">{error}</p>}
        </div>

        <div className="mt-5 flex justify-end gap-2">
          <Button variant="ghost" size="sm" onClick={() => onOpenChange(false)}>
            {t('board.dialog.cancel')}
          </Button>
          <Button size="sm" disabled={!canSubmit} onClick={() => void handleSubmit()}>
            {t('board.dialog.save')}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
