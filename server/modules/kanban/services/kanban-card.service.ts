import { randomUUID, timingSafeEqual } from 'node:crypto';

import type {
  ActivityRecorder,
  CreateKanbanCardInput,
  KanbanBoardConfig,
  KanbanBroadcaster,
  KanbanCard,
  KanbanCardComment,
  KanbanCardCommentsRepository,
  KanbanCardStatus,
  KanbanCardsRepository,
  KanbanServices,
  SaveKanbanBoardConfigInput,
  UpdateKanbanCardInput,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

/**
 * Statuses the user may set directly from the board.
 *
 * Agent-owned stages (`working`, `needs_decision`, `done`) are excluded so a
 * human cannot force a run outcome without a real provider run.
 */
const KANBAN_USER_STATUSES: readonly KanbanCardStatus[] = ['backlog', 'ready', 'archived'];

/**
 * Stages that own a live agent run. A card in one of these can only leave via
 * abort (back to backlog) or archive (cleanup) — a plain move would strand the
 * run: it keeps editing the worktree while the card loses its abort/report
 * affordances.
 */
const KANBAN_ACTIVE_STATUSES: readonly KanbanCardStatus[] = ['working', 'needs_decision'];

/** Provider ids a card or board may pin; dispatch falls back when unset. */
const KANBAN_PROVIDERS: ReadonlySet<string> = new Set(['claude', 'codex', 'cursor', 'opencode', 'devin']);

/**
 * Dependencies injected into the Kanban card service.
 *
 * `projectExists` and `dispatch` are capabilities rather than imports so this
 * service stays free of Database and provider-runtime coupling and can be unit
 * tested with small in-memory fakes. `dispatch` starts an agent run for a card
 * that just entered `ready`; it must resolve quickly and never throw into the
 * request path, because the move itself already succeeded.
 */
type KanbanCardServiceDeps = {
  repository: KanbanCardsRepository;
  /**
   * Card comment persistence (Collab feature). Injected separately from the
   * card repository so comments can be dropped without touching card rows.
   */
  comments: KanbanCardCommentsRepository;
  broadcast: KanbanBroadcaster;
  projectExists: (projectId: string) => boolean;
  dispatch: (card: KanbanCard) => Promise<void> | void;
  abort: (cardId: string) => Promise<KanbanCard>;
  cleanup: (card: KanbanCard, options?: { deleteBranch?: boolean }) => Promise<void>;
  readBoardConfig: (projectId: string) => KanbanBoardConfig;
  writeBoardConfig: (projectId: string, config: KanbanBoardConfig) => void;
  /**
   * Optional assignee validation: when provided, an assignee patch naming a
   * users.id that does not exist is rejected instead of stored.
   */
  userExists?: (userId: number) => boolean;
  /**
   * Optional activity-feed sink. When absent the service skips event
   * recording, which keeps unit tests free of an activity store.
   */
  recordActivity?: ActivityRecorder;
};

function normalizeTitle(title: unknown): string {
  const normalized = typeof title === 'string' ? title.trim() : '';
  if (!normalized) {
    throw new AppError('Card title is required.', {
      code: 'KANBAN_TITLE_REQUIRED',
      statusCode: 400,
    });
  }
  if (normalized.length > 200) {
    throw new AppError('Card title must be 200 characters or fewer.', {
      code: 'KANBAN_TITLE_TOO_LONG',
      statusCode: 400,
    });
  }
  return normalized;
}

function isUserStatus(status: KanbanCardStatus): boolean {
  return KANBAN_USER_STATUSES.includes(status);
}

function requireValidProvider(provider: unknown): void {
  if (provider === undefined || provider === null) {
    return;
  }
  if (typeof provider !== 'string' || !KANBAN_PROVIDERS.has(provider)) {
    throw new AppError(`Unknown provider "${String(provider)}".`, {
      code: 'INVALID_CARD_PROVIDER',
      statusCode: 400,
    });
  }
}

/**
 * Appends a card to the end of its new column.
 *
 * Positions are per-project, not per-column, so a single monotonic index keeps
 * ordering stable across drags without renumbering siblings on every move.
 */
function nextPosition(repository: KanbanCardsRepository, projectId: string): number {
  const cards = repository.list(projectId, { includeArchived: true });
  return cards.reduce((max, card) => Math.max(max, card.position), -1) + 1;
}

/**
 * Business rules for the Kanban board.
 *
 * Cards start in `backlog`. Users own `backlog`/`ready`/`archived` transitions;
 * everything from `working` onward is written by the agent reporting tool or by
 * the dispatcher when a run ends without a report. That split is enforced here
 * so routes and the agent tool cannot bypass it.
 */
export function createKanbanCardService(deps: KanbanCardServiceDeps): KanbanServices {
  const { repository, comments, broadcast, projectExists, dispatch, abort, cleanup, readBoardConfig, writeBoardConfig, userExists, recordActivity } = deps;

  function requireCard(cardId: string): KanbanCard {
    const card = repository.getById(cardId);
    if (!card) {
      throw new AppError(`Kanban card "${cardId}" was not found.`, {
        code: 'KANBAN_CARD_NOT_FOUND',
        statusCode: 404,
      });
    }
    return card;
  }

  function emit(card: KanbanCard): void {
    broadcast({ type: 'kanban-card-upserted', projectId: card.projectId, card });
  }

  // Activity writes are observability, not workflow: a feed failure must never
  // break the card action that produced the event.
  function record(
    card: KanbanCard,
    input: { userId: string | number | null; kind: 'card_created' | 'card_moved' | 'card_assigned' | 'card_commented'; summary: string },
  ): void {
    try {
      recordActivity?.({
        projectId: card.projectId,
        userId: input.userId,
        kind: input.kind,
        entityId: card.cardId,
        summary: input.summary,
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[Kanban] Failed to record activity', { cardId: card.cardId, error: message });
    }
  }

  return {
    listCards(projectId, options) {
      return repository.list(projectId, options);
    },

    getBoardConfig(projectId) {
      return readBoardConfig(projectId);
    },

    saveBoardConfig(projectId, input: SaveKanbanBoardConfigInput) {
      if (!projectExists(projectId)) {
        throw new AppError(`Project "${projectId}" was not found.`, {
          code: 'PROJECT_NOT_FOUND',
          statusCode: 404,
        });
      }

      requireValidProvider(input.provider);

      const provider = input.provider ?? null;
      const config: KanbanBoardConfig = {
        provider,
        // Clearing the provider clears model/effort too: a model from a
        // different provider would be rejected by the run.
        model: provider ? (input.model ?? null) : null,
        effort: provider ? (input.effort ?? null) : null,
      };
      writeBoardConfig(projectId, config);
      broadcast({ type: 'kanban-board-config-updated', projectId, boardConfig: config });
      return config;
    },

    createCard(input: CreateKanbanCardInput) {
      if (!projectExists(input.projectId)) {
        throw new AppError(`Project "${input.projectId}" was not found.`, {
          code: 'PROJECT_NOT_FOUND',
          statusCode: 404,
        });
      }

      requireValidProvider(input.provider);

      const card = repository.create({
        ...input,
        cardId: randomUUID(),
        title: normalizeTitle(input.title),
        description: typeof input.description === 'string' ? input.description : '',
      });

      emit(card);
      record(card, {
        userId: input.actorUserId ?? null,
        kind: 'card_created',
        summary: `Created card "${card.title}"`,
      });
      return card;
    },

    updateCard(cardId, input: UpdateKanbanCardInput) {
      const existing = requireCard(cardId);
      // actorUserId is attribution metadata, not a card field — strip it
      // before the patch reaches the repository.
      const { actorUserId, ...persisted } = input;
      const patch: UpdateKanbanCardInput = { ...persisted };
      if (input.title !== undefined) {
        patch.title = normalizeTitle(input.title);
      }
      requireValidProvider(input.provider);
      if (input.position !== undefined) {
        patch.position = Math.max(0, Math.round(input.position));
        // Same integrity rule as moveCard: taking slot N bumps the incumbents
        // so a PATCH cannot mint duplicate positions in the column.
        repository.shiftPositions?.(existing.projectId, existing.status, patch.position, cardId);
      }
      if (typeof input.assigneeUserId === 'number' && userExists && !userExists(input.assigneeUserId)) {
        throw new AppError(`User "${input.assigneeUserId}" was not found.`, {
          code: 'INVALID_CARD_ASSIGNEE',
          statusCode: 400,
        });
      }

      const card = repository.update(cardId, patch);
      if (!card) {
        throw new AppError(`Kanban card "${cardId}" was not found.`, {
          code: 'KANBAN_CARD_NOT_FOUND',
          statusCode: 404,
        });
      }

      emit(card);
      // Only a real reassignment earns a feed event — clients echo the current
      // assignee on every save, so an unchanged value must not spam the feed.
      if (input.assigneeUserId !== undefined && input.assigneeUserId !== existing.assigneeUserId) {
        record(card, {
          userId: actorUserId ?? null,
          kind: 'card_assigned',
          summary:
            card.assigneeUserId === null
              ? `Unassigned card "${card.title}"`
              : `Assigned card "${card.title}" to user #${card.assigneeUserId}`,
        });
      }
      return card;
    },

    async moveCard(cardId, status, position, options) {
      const existing = requireCard(cardId);

      if (!isUserStatus(status)) {
        throw new AppError(`Status "${status}" can only be set by the agent.`, {
          code: 'KANBAN_AGENT_OWNED_STATUS',
          statusCode: 400,
        });
      }

      // A card with a live run can only leave its stage via abort (backlog) or
      // archive (cleanup); a plain move would strand the run with no abort or
      // report path left.
      if (KANBAN_ACTIVE_STATUSES.includes(existing.status) && status !== 'archived') {
        throw new AppError(
          `Card "${cardId}" is ${existing.status} — abort the run or archive the card instead.`,
          {
            code: 'KANBAN_CARD_ACTIVE',
            statusCode: 409,
          },
        );
      }

      // Dropping a card onto the column it already sits in is a no-op: no
      // position bump, no activity-feed row, and no re-dispatch for ready.
      if (status === existing.status && position === undefined) {
        return { card: existing, dispatch: false };
      }

      const resolvedPosition =
        typeof position === 'number' && Number.isFinite(position)
          ? Math.max(0, Math.round(position))
          : nextPosition(repository, existing.projectId);

      // An explicit slot bumps the incumbents down so positions stay unique
      // within the column and ordering stays deterministic.
      if (position !== undefined) {
        repository.shiftPositions?.(existing.projectId, status, resolvedPosition, cardId);
      }

      const card = repository.move(cardId, status, resolvedPosition);
      if (!card) {
        throw new AppError(`Kanban card "${cardId}" was not found.`, {
          code: 'KANBAN_CARD_NOT_FOUND',
          statusCode: 404,
        });
      }

      emit(card);
      record(card, {
        userId: options?.actorUserId ?? null,
        kind: 'card_moved',
        summary: `Moved card "${card.title}" to ${status}`,
      });

      // Archiving is terminal: release the run and remove its worktree so
      // long-lived boards do not accumulate git worktrees for dead cards.
      if (status === 'archived') {
        void cleanup(card).catch((error) => {
          const message = error instanceof Error ? error.message : String(error);
          console.error('[Kanban] Failed to clean up archived card', { cardId: card.cardId, error: message });
        });
      }

      // Only entering `ready` starts work. Dispatch is fire-and-forget: the
      // move already committed, so a provider failure must not surface as an
      // HTTP error on the drag request.
      const shouldDispatch = status === 'ready';
      if (shouldDispatch) {
        void Promise.resolve(dispatch(card)).catch((error) => {
          const message = error instanceof Error ? error.message : String(error);
          console.error('[Kanban] Failed to dispatch card', { cardId: card.cardId, error: message });
        });
      }

      return { card, dispatch: shouldDispatch };
    },

    async abortCard(cardId) {
      requireCard(cardId);
      const card = await abort(cardId);
      emit(card);
      return card;
    },

    listComments(cardId) {
      requireCard(cardId);
      return comments.listByCard(cardId);
    },

    addComment(cardId, input) {
      const card = requireCard(cardId);
      const body = typeof input.body === 'string' ? input.body.trim() : '';
      if (!body) {
        throw new AppError('Comment body is required.', {
          code: 'KANBAN_COMMENT_BODY_REQUIRED',
          statusCode: 400,
        });
      }

      const userId = input.userId === null || input.userId === undefined
        ? null
        : Number(input.userId);

      const comment: KanbanCardComment = comments.create({
        id: randomUUID(),
        cardId: card.cardId,
        userId: Number.isFinite(userId) ? userId : null,
        body,
      });

      broadcast({
        type: 'kanban-comment-added',
        projectId: card.projectId,
        cardId: card.cardId,
        comment,
      });
      record(card, {
        userId: comment.userId,
        kind: 'card_commented',
        summary: `Commented on card "${card.title}"`,
      });
      return comment;
    },

    deleteCard(cardId) {
      const card = requireCard(cardId);

      // Cleanup runs before the row disappears: the dispatcher needs the card's
      // worktree/session metadata to release the run and remove the worktree.
      // Deleting a card also deletes its branch — nothing is restorable here.
      void cleanup(card, { deleteBranch: true }).catch((error) => {
        const message = error instanceof Error ? error.message : String(error);
        console.error('[Kanban] Failed to clean up deleted card', { cardId, error: message });
      });

      if (!repository.delete(cardId)) {
        throw new AppError(`Kanban card "${cardId}" was not found.`, {
          code: 'KANBAN_CARD_NOT_FOUND',
          statusCode: 404,
        });
      }
      // card_comments.card_id is intentionally not a hard FK — clear the rows
      // here so deleting a card never strands its comment thread.
      comments.deleteByCard?.(cardId);
      broadcast({ type: 'kanban-card-deleted', projectId: card.projectId, cardId });
    },

    reportCardByToken(input) {
      const existing = requireCard(input.cardId);

      const expectedToken = deps.repository.getReportToken(input.cardId);
      if (!expectedToken) {
        throw new AppError('Invalid kanban report token.', {
          code: 'KANBAN_REPORT_UNAUTHORIZED',
          statusCode: 403,
        });
      }

      const expectedBuf = Buffer.from(expectedToken);
      const inputBuf = Buffer.from(input.token);
      if (expectedBuf.length !== inputBuf.length || !timingSafeEqual(expectedBuf, inputBuf)) {
        throw new AppError('Invalid kanban report token.', {
          code: 'KANBAN_REPORT_UNAUTHORIZED',
          statusCode: 403,
        });
      }

      // The token is consumed on first report so a leaked prompt cannot be
      // replayed, and the agent cannot resurrect a card the user moved on.
      if (existing.status !== 'working' && existing.status !== 'needs_decision') {
        throw new AppError('Card is not currently running.', {
          code: 'KANBAN_CARD_NOT_RUNNING',
          statusCode: 409,
        });
      }

      const card = repository.move(input.cardId, input.status, existing.position);
      if (!card) {
        throw new AppError(`Kanban card "${input.cardId}" was not found.`, {
          code: 'KANBAN_CARD_NOT_FOUND',
          statusCode: 404,
        });
      }

      const withRuntime = repository.setRuntime(input.cardId, {
        statusMessage: typeof input.message === 'string' ? input.message : null,
        prUrl: typeof input.prUrl === 'string' ? input.prUrl : undefined,
        reportToken: input.status === 'done' ? null : expectedToken,
      }) ?? card;

      emit(withRuntime);
      return withRuntime;
    },
  };
}
