import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { useWebSocket } from '../../../contexts/WebSocketContext';
import { api } from '../../../utils/api';
import type {
  CreateKanbanCardBody,
  KanbanApiResponse,
  KanbanCard,
  KanbanCardStatus,
} from '../types';

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

    setIsLoading(true);
    try {
      const response = await api.kanban.list(projectId, true);
      const payload = (await response.json()) as KanbanApiResponse<{ cards: KanbanCard[] }>;
      if (!response.ok || payload.success === false) {
        throw new Error(payload.error ?? 'Failed to load board');
      }
      setCards(Array.isArray(payload.data?.cards) ? payload.data!.cards : []);
      setError(null);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : 'Failed to load board');
    } finally {
      setIsLoading(false);
    }
  }, [projectId]);

  useEffect(() => {
    void refreshCards();
  }, [refreshCards]);

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
        throw new Error(payload.error ?? 'Request failed');
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
      const card = await runMutation(() => api.kanban.move(cardId, status, position));
      if (card) setCards((previous) => upsertCard(previous, card));
    },
    [runMutation],
  );

  const abortCard = useCallback(
    async (cardId: string) => {
      const card = await runMutation(() => api.kanban.abort(cardId));
      if (card) setCards((previous) => upsertCard(previous, card));
    },
    [runMutation],
  );

  const deleteCard = useCallback(async (cardId: string) => {
    // Snapshot before mutating: the setCards updater is not guaranteed to run
    // before the await below resumes, so it can't be used to capture state.
    const previousCards = cards;
    setCards((previous) => previous.filter((card) => card.cardId !== cardId));

    try {
      const response = await api.kanban.remove(cardId);
      const payload = (await response.json().catch(() => ({}))) as KanbanApiResponse<{ deleted?: boolean }>;
      if (!response.ok || payload.success === false) {
        throw new Error(payload.error ?? 'Failed to delete card');
      }
    } catch (err) {
      setCards(previousCards);
      setError(err instanceof Error ? err.message : 'Failed to delete card');
    }
  }, [cards]);

  return useMemo(
    () => ({ cards, isLoading, error, refreshCards, createCard, updateCard, moveCard, abortCard, deleteCard }),
    [cards, isLoading, error, refreshCards, createCard, updateCard, moveCard, abortCard, deleteCard],
  );
}
