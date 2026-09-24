import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { useWebSocket } from '../../../contexts/WebSocketContext';
import { api } from '../../../utils/api';
import type {
  CreateKanbanCardBody,
  KanbanApiResponse,
  KanbanCard,
  KanbanCardStatus,
} from '../types';
import { readApiError } from '../types';

type UseKanbanBoardResult = {
  cards: KanbanCard[];
  isLoading: boolean;
  error: string | null;
  refreshCards: () => Promise<void>;
  createCard: (body: CreateKanbanCardBody) => Promise<KanbanCard | null>;
  updateCard: (cardId: string, body: Partial<CreateKanbanCardBody>) => Promise<void>;
  moveCard: (cardId: string, status: KanbanCardStatus, position?: number) => Promise<void>;
  abortCard: (cardId: string) => Promise<void>;
  deleteCard: (cardId: string) => Promise<void>;
};

function upsertCard(cards: KanbanCard[], incoming: KanbanCard): KanbanCard[] {
  const index = cards.findIndex((card) => card.cardId === incoming.cardId);
  if (index === -1) {
    return [...cards, incoming];
  }

  const next = [...cards];
  next[index] = incoming;
  return next;
}

/**
 * Loads and mutates the kanban board for a single project. State is kept local
 * to the board (single consumer) and kept live through `kanban-card-*`
 * websocket broadcasts, so several browser tabs stay in sync.
 */
export function useKanbanBoard(projectId: string | null): UseKanbanBoardResult {
  const { subscribe } = useWebSocket();
  const [cards, setCards] = useState<KanbanCard[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const projectIdRef = useRef<string | null>(projectId);

  useEffect(() => {
    projectIdRef.current = projectId;
  }, [projectId]);

  const refreshCards = useCallback(async () => {
    if (!projectId) {
      setCards([]);
      return;
    }

    // Stale-response guard: when the user switches projects mid-fetch the old
    // project's cards must not land on the new project's board.
    const requestedProject = projectId;
    setIsLoading(true);
    try {
      const response = await api.kanban.list(projectId, true);
      const payload = (await response.json()) as KanbanApiResponse<{ cards: KanbanCard[] }>;
      if (projectIdRef.current !== requestedProject) return;
      if (!response.ok || payload.success === false) {
        throw new Error(readApiError(payload, 'Failed to load board'));
      }
      setCards(Array.isArray(payload.data?.cards) ? payload.data!.cards : []);
      setError(null);
    } catch (loadError) {
      if (projectIdRef.current === requestedProject) {
        setError(loadError instanceof Error ? loadError.message : 'Failed to load board');
      }
    } finally {
      if (projectIdRef.current === requestedProject) {
        setIsLoading(false);
      }
    }
  }, [projectId]);

  useEffect(() => {
    void refreshCards();
  }, [refreshCards]);

  // Switching projects drops the previous board's cards immediately so they
  // never leak onto the newly selected board while it loads.
  useEffect(() => {
    setCards([]);
    setError(null);
  }, [projectId]);

  useEffect(() => {
    return subscribe((event) => {
      if (event.type === 'kanban-card-upserted' && event.projectId === projectIdRef.current) {
        const card = event.card as KanbanCard | undefined;
        if (card) {
          setCards((previous) => upsertCard(previous, card));
        }
        return;
      }

      if (event.type === 'kanban-card-deleted' && event.projectId === projectIdRef.current) {
        const cardId = event.cardId as string | undefined;
        if (cardId) {
          setCards((previous) => previous.filter((card) => card.cardId !== cardId));
        }
      }
    });
  }, [subscribe]);

  const runMutation = useCallback(
    async (request: () => Promise<Response>): Promise<KanbanCard | null> => {
      const response = await request();
      const payload = (await response.json()) as KanbanApiResponse<{ card: KanbanCard }>;
      if (!response.ok || payload.success === false) {
        throw new Error(readApiError(payload, 'Request failed'));
      }
      return payload.data?.card ?? null;
    },
    [],
  );

  const createCard = useCallback(
    async (body: CreateKanbanCardBody) => {
      if (!projectId) return null;
      const card = await runMutation(() => api.kanban.create(projectId, body));
      if (card) {
        setCards((previous) => upsertCard(previous, card));
      }
      return card;
    },
    [projectId, runMutation],
  );

  const updateCard = useCallback(
    async (cardId: string, body: Partial<CreateKanbanCardBody>) => {
      const card = await runMutation(() => api.kanban.update(cardId, body));
      if (card) setCards((previous) => upsertCard(previous, card));
    },
    [runMutation],
  );

  const moveCard = useCallback(
    async (cardId: string, status: KanbanCardStatus, position?: number) => {
      // Board mutations surface failures in the error banner — every caller
      // fires `void moveCard(...)`, so a rethrow would die as an unhandled
      // rejection nobody sees.
      try {
        const card = await runMutation(() => api.kanban.move(cardId, status, position));
        if (card) {
          setCards((previous) => upsertCard(previous, card));
          setError(null);
        }
      } catch (moveError) {
        setError(moveError instanceof Error ? moveError.message : 'Failed to move card');
      }
    },
    [runMutation],
  );

  const abortCard = useCallback(
    async (cardId: string) => {
      try {
        const card = await runMutation(() => api.kanban.abort(cardId));
        if (card) {
          setCards((previous) => upsertCard(previous, card));
          setError(null);
        }
      } catch (abortError) {
        setError(abortError instanceof Error ? abortError.message : 'Failed to abort card');
      }
    },
    [runMutation],
  );

  const deleteCard = useCallback(async (cardId: string) => {
    const removed = cards.find((card) => card.cardId === cardId);
    setCards((previous) => previous.filter((card) => card.cardId !== cardId));

    try {
      const response = await api.kanban.remove(cardId);
      const payload = (await response.json().catch(() => ({}))) as KanbanApiResponse<{ deleted?: boolean }>;
      if (!response.ok || payload.success === false) {
        throw new Error(readApiError(payload, 'Failed to delete card'));
      }
    } catch (err) {
      // Re-insert only the failed card — restoring the whole pre-delete
      // snapshot would also resurrect cards other clients removed meanwhile.
      if (removed) {
        setCards((previous) => upsertCard(previous, removed));
      }
      setError(err instanceof Error ? err.message : 'Failed to delete card');
    }
  }, [cards]);

  return useMemo(
    () => ({ cards, isLoading, error, refreshCards, createCard, updateCard, moveCard, abortCard, deleteCard }),
    [cards, isLoading, error, refreshCards, createCard, updateCard, moveCard, abortCard, deleteCard],
  );
}
