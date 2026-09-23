import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button, Dialog, DialogContent, DialogTitle, Input } from '../../../shared/view/ui';
import { useWebSocket } from '../../../contexts/WebSocketContext';
import { api } from '../../../utils/api';
import type { CollabUser, CreateKanbanCardBody, KanbanApiResponse, KanbanCard, KanbanCardComment } from '../types';

type KanbanCardDialogProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSubmit: (body: CreateKanbanCardBody) => Promise<void>;
  card?: KanbanCard | null;
  users?: CollabUser[];
};

/**
 * Minimal comments block shown while editing a card. Fetches on open and
 * refreshes on `kanban-comment-added` broadcasts so a second user watching
 * the same card sees new comments live.
 */
function CardComments({ card, users }: { card: KanbanCard; users: CollabUser[] }) {
  const { t } = useTranslation('tasks');
  const { subscribe } = useWebSocket();
  const [comments, setComments] = useState<KanbanCardComment[]>([]);
  const [draft, setDraft] = useState('');
  const [isSending, setIsSending] = useState(false);

  const load = useCallback(async () => {
    try {
      const response = await api.kanban.listComments(card.cardId);
      const payload = (await response.json()) as KanbanApiResponse<{ comments: KanbanCardComment[] }>;
      if (response.ok && payload.success !== false) {
        setComments(Array.isArray(payload.data?.comments) ? payload.data.comments : []);
      }
    } catch {
      // Comments are auxiliary — a failed fetch leaves the existing list.
    }
  }, [card.cardId]);

  useEffect(() => {
    void load();
  }, [load]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event.type === 'kanban-comment-added' && event.cardId === card.cardId) {
          void load();
        }
      }),
    [subscribe, card.cardId, load],
  );

  const authorName = (userId: number | null): string =>
    userId === null
      ? t('board.comments.unknownAuthor', { defaultValue: 'Someone' })
      : (users.find((user) => user.id === userId)?.displayName ?? `#${userId}`);

  const handleSend = async () => {
    const body = draft.trim();
    if (!body || isSending) return;
    setIsSending(true);
    try {
      const response = await api.kanban.addComment(card.cardId, body);
      const payload = (await response.json()) as KanbanApiResponse<{ comment: KanbanCardComment }>;
      if (response.ok && payload.success !== false && payload.data?.comment) {
        setComments((previous) => [...previous, payload.data!.comment]);
        setDraft('');
      }
    } finally {
      setIsSending(false);
    }
  };

  return (
    <div className="space-y-1">
      <label className="text-xs font-medium text-muted-foreground">
        {t('board.comments.label', { defaultValue: 'Comments' })}
      </label>
      {comments.length > 0 && (
        <ul className="max-h-32 space-y-1.5 overflow-y-auto rounded-md border border-border/60 p-2">
          {comments.map((comment) => (
            <li key={comment.id} className="text-xs">
              <span className="font-medium text-foreground">{authorName(comment.userId)}</span>
              <span className="ml-1.5 text-muted-foreground">{comment.body}</span>
            </li>
          ))}
        </ul>
      )}
      <div className="flex gap-1.5">
        <Input
          value={draft}
          placeholder={t('board.comments.placeholder', { defaultValue: 'Write a comment…' })}
          onChange={(event) => setDraft(event.target.value)}
          onKeyDown={(event) => {
            if (event.key === 'Enter' && !event.shiftKey) {
              event.preventDefault();
              void handleSend();
            }
          }}
        />
        <Button size="sm" variant="outline" disabled={!draft.trim() || isSending} onClick={() => void handleSend()}>
          {t('board.comments.send', { defaultValue: 'Send' })}
        </Button>
      </div>
    </div>
  );
}

export default function KanbanCardDialog({
  open,
  onOpenChange,
  onSubmit,
  card,
  users = [],
}: KanbanCardDialogProps) {
  const { t } = useTranslation('tasks');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  // undefined = untouched (PATCH leaves the column alone); null = unassigned.
  const [assigneeUserId, setAssigneeUserId] = useState<number | null | undefined>(undefined);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!open) return;
    setTitle(card?.title ?? '');
    setDescription(card?.description ?? '');
    setAssigneeUserId(card?.assigneeUserId ?? undefined);
    setError(null);
  }, [open, card]);

  const canSubmit = title.trim().length > 0 && !isSaving;

  const handleSubmit = async () => {
    if (!canSubmit) return;
    setIsSaving(true);
    setError(null);
    try {
      await onSubmit({
        title: title.trim(),
        description: description.trim(),
        ...(assigneeUserId !== undefined ? { assigneeUserId } : {}),
      });
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

          {users.length > 0 && (
            <div className="space-y-1">
              <label className="text-xs font-medium text-muted-foreground" htmlFor="kanban-assignee">
                {t('board.assignee.label', { defaultValue: 'Assignee' })}
              </label>
              <select
                id="kanban-assignee"
                value={assigneeUserId === undefined || assigneeUserId === null ? '' : String(assigneeUserId)}
                onChange={(event) => {
                  setAssigneeUserId(event.target.value === '' ? null : Number(event.target.value));
                }}
                className="flex h-9 w-full rounded-md border border-input bg-transparent px-2 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
              >
                <option value="">{t('board.assignee.unassigned', { defaultValue: 'Unassigned' })}</option>
                {users.map((user) => (
                  <option key={user.id} value={String(user.id)}>
                    {user.displayName}
                  </option>
                ))}
              </select>
            </div>
          )}

          {card && <CardComments card={card} users={users} />}

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
