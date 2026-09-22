import { randomBytes } from 'node:crypto';

import type {
  KanbanCard,
  KanbanDispatcher,
  KanbanDispatcherDeps,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

type ActiveRun = {
  cardId: string;
  sessionId: string;
  abort: () => Promise<void>;
};

function slugify(title: string): string {
  const slug = title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 40);
  return slug || 'task';
}

/**
 * Builds the kickoff prompt delivered to the agent for one card.
 *
 * The provider has no system-prompt injection seam, so the run contract and the
 * report endpoint are prepended to the user message. The report token lets the
 * agent update its own card stage with a plain `curl`, which keeps the workflow
 * provider-agnostic (no MCP registration required).
 *
 * Exported for tests that assert the contract text and token placement.
 */
export function buildKickoffPrompt(input: {
  card: KanbanCard;
  token: string;
  reportEndpoint: string;
}): string {
  const { card, token, reportEndpoint } = input;
  const report = (status: string, message: string) =>
    `curl -s -X POST "${reportEndpoint}" -H "Content-Type: application/json" ` +
    `-d '{"token":"${token}","cardId":"${card.cardId}","status":"${status}","message":"${message}"}'`;

  return [
    `You are working on a kanban task automatically dispatched by ddagent.`,
    ``,
    `Task: ${card.title}`,
    card.description ? `Details:\n${card.description}` : '',
    ``,
    `Rules:`,
    `1. Work autonomously in the current repository. Do not ask for permission for routine edits or commands.`,
    `2. When you finish the task completely and verifiably, report done:`,
    `   ${report('done', '<short summary>')}`,
    `3. If you need a decision, an answer, or approval from the human before you can continue, report it and then stop:`,
    `   ${report('needs_decision', '<the question or plan you need approved>')}`,
    `4. Call the report command exactly once per state change. If you report needs_decision, wait for the human to answer in the chat session.`,
    `5. Prefer small, verifiable steps and run the project's tests when you can.`,
  ]
    .filter((line) => line !== '')
    .join('\n');
}

/**
 * Dispatches kanban cards to provider runtimes and mirrors run signals back onto
 * the board.
 *
 * The dispatcher owns concurrency (never more than `maxConcurrentRuns` live
 * runs), worktree lifecycle, and the fallback rule that an agent ending a turn
 * without a report means "needs your decision". Stage transitions come from two
 * sources: the agent's own token-guarded report, and this fallback.
 */
export function createKanbanDispatcher(deps: KanbanDispatcherDeps): KanbanDispatcher {
  const activeRuns = new Map<string, ActiveRun>();
  const inFlightDispatches = new Set<string>();

  function updateCard(cardId: string, patch: Parameters<KanbanDispatcherDeps['cards']['setRuntime']>[1]) {
    return deps.cards.setRuntime(cardId, patch);
  }

  async function dispatch(card: KanbanCard): Promise<void> {
    if (card.status !== 'ready') {
      return;
    }
    if (activeRuns.has(card.cardId) || inFlightDispatches.has(card.cardId)) {
      return;
    }
    if (activeRuns.size + inFlightDispatches.size >= deps.maxConcurrentRuns) {
      console.warn('[Kanban] Concurrency limit reached, leaving card queued', {
        cardId: card.cardId,
        running: activeRuns.size + inFlightDispatches.size,
      });
      return;
    }

    inFlightDispatches.add(card.cardId);

    try {
      const boardConfig = deps.resolveBoardConfig(card.projectId);
      // A card may pin its own agent/model; otherwise the project board's
      // configured defaults apply, and only then the built-in fallback.
      const provider = card.provider ?? boardConfig.provider ?? 'claude';
      const model = card.model ?? boardConfig.model;
      const effort = card.effort ?? boardConfig.effort;
      if (!deps.isProviderAvailable(provider)) {
        throw new AppError(`Provider "${provider}" is not available for kanban dispatch.`, {
          code: 'KANBAN_PROVIDER_UNAVAILABLE',
          statusCode: 400,
        });
      }

      const projectPath = deps.resolveProjectPath(card.projectId);
      if (!projectPath) {
        throw new AppError(`Project "${card.projectId}" has no resolvable path.`, {
          code: 'KANBAN_PROJECT_PATH_MISSING',
          statusCode: 400,
        });
      }

      const branch = `kanban/${card.cardId.slice(0, 8)}-${slugify(card.title)}`;
      let worktree: { worktreePath: string; branch: string };
      try {
        const result = await deps.createWorktree({ projectPath, branch });
        if (!result?.worktreePath) {
          throw new Error('Worktree creation returned no path.');
        }
        worktree = result;
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.error('[Kanban] Worktree creation failed', {
          cardId: card.cardId,
          error: message,
        });
        deps.cards.move(card.cardId, 'backlog', card.position);
        updateCard(card.cardId, { statusMessage: `Worktree creation failed: ${message}` });
        throw error instanceof AppError
          ? error
          : new AppError(`Worktree creation failed: ${message}`, {
              code: 'KANBAN_WORKTREE_CREATION_FAILED',
              statusCode: 500,
            });
      }

      const cwd = worktree.worktreePath;

      // Removing the worktree is the unwind path for every failure below:
      // without it a retry hits BRANCH_ALREADY_CHECKED_OUT on the orphan.
      const discardWorktree = async () => {
        await deps.removeWorktree({ projectPath, worktreePath: cwd }).catch((error) => {
          const message = error instanceof Error ? error.message : String(error);
          console.error('[Kanban] Worktree cleanup failed', { cardId: card.cardId, error: message });
        });
      };

      // abort() and cleanup() drop this card's in-flight marker, so a missing
      // marker after an await means the card was aborted, archived, or deleted
      // mid-setup and this dispatch must unwind instead of starting a run on
      // a card that is gone or no longer queued.
      if (!inFlightDispatches.has(card.cardId)) {
        await discardWorktree();
        return;
      }

      const token = randomBytes(24).toString('hex');
      const reportBaseUrl = typeof deps.reportBaseUrl === 'function'
        ? deps.reportBaseUrl()
        : deps.reportBaseUrl;
      const reportEndpoint = `${reportBaseUrl}/api/kanban/report`;

      try {
        const session = await deps.createSession({
          provider,
          projectPath: cwd,
          initialMessage: card.title,
          model,
          effort,
        });

        if (!inFlightDispatches.has(card.cardId)) {
          await discardWorktree();
          return;
        }

        updateCard(card.cardId, {
          sessionId: session.sessionId,
          worktreePath: cwd,
          branch: worktree.branch,
          reportToken: token,
          statusMessage: null,
        });

        const active: ActiveRun = {
          cardId: card.cardId,
          sessionId: session.sessionId,
          abort: async () => {},
        };

        const handle = await deps.startRun({
          sessionId: session.sessionId,
          provider,
          projectPath: cwd,
          cwd,
          command: buildKickoffPrompt({ card, token, reportEndpoint }),
          model,
          effort,
          onSignal: (signal) => {
            if (signal.kind === 'end_turn') {
              const current = deps.cards.getById(card.cardId);
              // A report that already moved the card to needs_decision/done wins;
              // this fallback only covers a turn that ended silently.
              if (current && current.status === 'working') {
                deps.cards.move(card.cardId, 'needs_decision', current.position);
                updateCard(card.cardId, {
                  statusMessage: 'Agent ended its turn and is waiting for your input.',
                });
              }
            }
          },
        });

        if (!inFlightDispatches.has(card.cardId)) {
          await handle.abort().catch(() => undefined);
          await discardWorktree();
          return;
        }

        active.abort = handle.abort;
        activeRuns.set(card.cardId, active);
        deps.cards.move(card.cardId, 'working', card.position);
        updateCard(card.cardId, { statusMessage: null });

        void handle.completed.finally(() => {
          // A stale completion from a superseded run must not delete the NEW
          // run's entry — that would bypass the concurrency cap and break
          // abort for the live run.
          if (activeRuns.get(card.cardId) === active) {
            activeRuns.delete(card.cardId);
          }
          if (activeRuns.size < deps.maxConcurrentRuns) {
            const nextCard = deps.cards
              .list(card.projectId)
              .find((c) => c.status === 'ready' && !activeRuns.has(c.cardId) && !inFlightDispatches.has(c.cardId));
            if (nextCard) {
              void dispatch(nextCard).catch((error) => {
                const message = error instanceof Error ? error.message : String(error);
                console.error('[Kanban] Failed to dispatch queued card', {
                  cardId: nextCard.cardId,
                  error: message,
                });
              });
            }
          }
        });
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.error('[Kanban] Dispatch setup failed', { cardId: card.cardId, error: message });
        await discardWorktree();
        deps.cards.move(card.cardId, 'backlog', card.position);
        updateCard(card.cardId, { statusMessage: `Dispatch failed: ${message}` });
        throw error;
      }
    } finally {
      inFlightDispatches.delete(card.cardId);
    }
  }

  async function abort(cardId: string): Promise<KanbanCard> {
    const card = deps.cards.getById(cardId);
    if (!card) {
      throw new AppError(`Kanban card "${cardId}" was not found.`, {
        code: 'KANBAN_CARD_NOT_FOUND',
        statusCode: 404,
      });
    }

    const active = activeRuns.get(cardId);
    if (active) {
      await active.abort().catch(() => undefined);
      activeRuns.delete(cardId);
    }
    inFlightDispatches.delete(cardId);

    const moved = deps.cards.move(cardId, 'backlog', card.position);
    return updateCard(cardId, { statusMessage: 'Run aborted by user.' }) ?? moved ?? card;
  }

  async function cleanup(card: KanbanCard): Promise<void> {
    if (activeRuns.has(card.cardId)) {
      await activeRuns.get(card.cardId)?.abort().catch(() => undefined);
      activeRuns.delete(card.cardId);
    }
    inFlightDispatches.delete(card.cardId);

    if (!card.worktreePath || !card.branch) {
      return;
    }

    const projectPath = deps.resolveProjectPath(card.projectId);
    if (!projectPath) {
      return;
    }

    await deps.removeWorktree({ projectPath, worktreePath: card.worktreePath }).catch((error) => {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[Kanban] Worktree cleanup failed', { cardId: card.cardId, error: message });
    });
  }

  return {
    dispatch,
    abort,
    canDispatch: () => activeRuns.size + inFlightDispatches.size < deps.maxConcurrentRuns,
    cleanup,
  };
}
