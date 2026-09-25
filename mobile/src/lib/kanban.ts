import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { api } from '~shared/utils/api';
import { useWebSocket } from '../contexts/WebSocketContext';

export type KanbanCardStatus =
  | 'backlog'
  | 'ready'
  | 'working'
  | 'needs_decision'
  | 'done'
  | 'archived';

export type KanbanCard = {
  cardId: string;
  projectId: string;
  title: string;
  description: string;
  status: KanbanCardStatus;
  position: number;
  sessionId: string | null;
  provider: string | null;
  model: string | null;
  effort: string | null;
  worktreePath: string | null;
  branch: string | null;
  prUrl: string | null;
  statusMessage: string | null;
  assigneeUserId: number | null;
  isArchived: boolean;
  createdAt: string;
  updatedAt: string;
};

export type CreateKanbanCardBody = {
  title: string;
  description?: string;
  provider?: string | null;
  model?: string | null;
  effort?: string | null;
  assigneeUserId?: number | null;
};

export type CollabUser = {
  id: number;
  username: string;
  role: string;
  displayName: string;
};

export type BoardConfig = {
  provider: string | null;
  model: string | null;
  effort: string | null;
};

type ApiResponse<T> = { success?: boolean; data?: T; error?: string | { message?: string } };

export function readApiError(payload: ApiResponse<unknown>, fallback: string): string {
  const err = payload?.error;
  if (typeof err === 'string' && err) return err;
  if (err && typeof err === 'object' && typeof err.message === 'string' && err.message) return err.message;
  return fallback;
}

// Backlog/archived are user-only shelves; the middle milestones are agent-driven.
// Only `ready` kicks off a run.
export const KANBAN_COLUMNS: {
  id: KanbanCardStatus;
  titleKey: string;
  accent: string;
  light: string;
  lightText: string;
  dark: string;
  darkText: string;
}[] = [
  { id: 'backlog', titleKey: 'board.columns.backlog', accent: '#94a3b8', light: '#f1f5f9', lightText: '#1e293b', dark: '#1e293b', darkText: '#e2e8f0' },
  { id: 'ready', titleKey: 'board.columns.ready', accent: '#0ea5e9', light: '#e0f2fe', lightText: '#075985', dark: '#0c4a6e', darkText: '#bae6fd' },
  { id: 'working', titleKey: 'board.columns.working', accent: '#3b82f6', light: '#dbeafe', lightText: '#1e40af', dark: '#1e3a8a', darkText: '#bfdbfe' },
  { id: 'needs_decision', titleKey: 'board.columns.needsDecision', accent: '#f59e0b', light: '#fef3c7', lightText: '#92400e', dark: '#78350f', darkText: '#fde68a' },
  { id: 'done', titleKey: 'board.columns.done', accent: '#10b981', light: '#d1fae5', lightText: '#065f46', dark: '#064e3b', darkText: '#a7f3d0' },
  { id: 'archived', titleKey: 'board.columns.archived', accent: '#9ca3af', light: '#f3f4f6', lightText: '#374151', dark: '#1f2937', darkText: '#d1d5db' },
];

export const USER_MOVABLE_STATUSES = new Set<KanbanCardStatus>(['backlog', 'ready', 'archived']);

// Columns a user may move a card to from each status (mirrors the server guard).
export const MOVE_TARGETS: Record<KanbanCardStatus, KanbanCardStatus[]> = {
  backlog: ['ready', 'archived'],
  ready: ['backlog', 'archived'],
  working: ['archived'],
  needs_decision: ['archived'],
  done: ['backlog', 'ready', 'archived'],
  archived: ['backlog', 'ready'],
};

const PROVIDERS = ['claude', 'cursor', 'codex', 'opencode', 'devin'];

export type BoardColumn = {
  id: KanbanCardStatus;
  title: string;
  accent: string;
  headerBg: string;
  headerText: string;
  cards: KanbanCard[];
};

export function buildBoardColumns(cards: KanbanCard[], isDark: boolean, t: (k: string) => string): BoardColumn[] {
  const byStatus = cards.reduce<Record<string, KanbanCard[]>>((acc, card) => {
    (acc[card.status] ??= []).push(card);
    return acc;
  }, {});

  return KANBAN_COLUMNS.map((config) => ({
    id: config.id,
    title: t(config.titleKey),
    accent: config.accent,
    headerBg: isDark ? config.dark : config.light,
    headerText: isDark ? config.darkText : config.lightText,
    cards: (byStatus[config.id] ?? []).sort((a, b) => a.position - b.position),
  }));
}

function upsertCard(cards: KanbanCard[], incoming: KanbanCard): KanbanCard[] {
  const index = cards.findIndex((card) => card.cardId === incoming.cardId);
  if (index === -1) return [...cards, incoming];
  const next = [...cards];
  next[index] = incoming;
  return next;
}

/** Loads and mutates one project's board, kept live via `kanban-card-*` events. */
export function useKanbanBoard(projectId: string | null) {
  const { subscribe } = useWebSocket();
  const [cards, setCards] = useState<KanbanCard[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const projectIdRef = useRef(projectId);
  const cardsRef = useRef(cards);

  useEffect(() => {
    projectIdRef.current = projectId;
  }, [projectId]);

  const refreshCards = useCallback(async () => {
    if (!projectId) {
      setCards([]);
      return;
    }
    const requested = projectId;
    setIsLoading(true);
    try {
      const response = await api.kanban.list(projectId, true);
      const payload = (await response.json()) as ApiResponse<{ cards: KanbanCard[] }>;
      if (projectIdRef.current !== requested) return;
      if (!response.ok || payload.success === false) {
        throw new Error(readApiError(payload, 'Failed to load board'));
      }
      setCards(Array.isArray(payload.data?.cards) ? payload.data!.cards : []);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load board');
    } finally {
      setIsLoading(false);
    }
  }, [projectId]);

  useEffect(() => {
    void refreshCards();
  }, [refreshCards]);

  useEffect(() => {
    setCards([]);
    setError(null);
  }, [projectId]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event?.type === 'kanban-card-upserted' && event.projectId === projectIdRef.current) {
          const card = event.card as KanbanCard | undefined;
          if (card) setCards((previous) => upsertCard(previous, card));
          return;
        }
        if (event?.type === 'kanban-card-deleted' && event.projectId === projectIdRef.current) {
          setCards((previous) => previous.filter((card) => card.cardId !== event.cardId));
        }
      }),
    [subscribe],
  );

  const runMutation = useCallback(async (request: () => Promise<Response>): Promise<KanbanCard | null> => {
    const response = await request();
    const payload = (await response.json()) as ApiResponse<{ card: KanbanCard }>;
    if (!response.ok || payload.success === false) {
      throw new Error(readApiError(payload, 'Request failed'));
    }
    return payload.data?.card ?? null;
  }, []);

  const createCard = useCallback(
    async (body: CreateKanbanCardBody) => {
      if (!projectId) return null;
      const card = await runMutation(() => api.kanban.create(projectId, body));
      if (card) setCards((previous) => upsertCard(previous, card));
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
      try {
        const card = await runMutation(() => api.kanban.move(cardId, status, position));
        if (card) {
          setCards((previous) => upsertCard(previous, card));
          setError(null);
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Move failed');
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
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Abort failed');
      }
    },
    [runMutation],
  );

  const deleteCard = useCallback(async (cardId: string) => {
    const removed = cardsRef.current.find((card) => card.cardId === cardId) ?? null;
    setCards((previous) => previous.filter((card) => card.cardId !== cardId));
    try {
      const response = await api.kanban.remove(cardId);
      const payload = (await response.json().catch(() => ({}))) as ApiResponse<{ deleted?: boolean }>;
      if (!response.ok || payload.success === false) {
        throw new Error(readApiError(payload, 'Failed to delete card'));
      }
    } catch (err) {
      if (removed) setCards((previous) => upsertCard(previous, removed));
      setError(err instanceof Error ? err.message : 'Delete failed');
    }
  }, []);

  useEffect(() => {
    cardsRef.current = cards;
  }, [cards]);

  return { cards, isLoading, error, refreshCards, createCard, updateCard, moveCard, abortCard, deleteCard };
}

/** Per-project board agent settings (provider/model/effort seeded onto cards). */
export function useBoardConfig(projectId: string | null) {
  const { subscribe } = useWebSocket();
  const [config, setConfig] = useState<BoardConfig>({ provider: null, model: null, effort: null });
  const [modelOptions, setModelOptions] = useState<{ value: string; label: string; description?: string }[]>([]);
  const [effortOptions, setEffortOptions] = useState<{ value: string; description?: string }[]>([]);
  const [isLoadingModels, setIsLoadingModels] = useState(false);
  const projectIdRef = useRef(projectId);

  useEffect(() => {
    projectIdRef.current = projectId;
  }, [projectId]);

  useEffect(() => {
    if (!projectId) {
      setConfig({ provider: null, model: null, effort: null });
      return;
    }
    const requested = projectId;
    void (async () => {
      try {
        const response = await api.kanban.getBoardConfig(projectId);
        const payload = (await response.json()) as ApiResponse<{ boardConfig: BoardConfig }>;
        if (projectIdRef.current !== requested) return;
        if (response.ok && payload.success !== false && payload.data?.boardConfig) {
          setConfig(payload.data.boardConfig);
        }
      } catch {
        /* keep defaults */
      }
    })();
  }, [projectId]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event?.type === 'kanban-board-config-updated' && event.projectId === projectIdRef.current) {
          if (event.boardConfig) setConfig(event.boardConfig as BoardConfig);
        }
      }),
    [subscribe],
  );

  // Model/effort catalogs follow the pinned provider; provider null = the
  // provider default, so there is nothing to list.
  useEffect(() => {
    if (!config.provider) {
      setModelOptions([]);
      setEffortOptions([]);
      return;
    }
    let cancelled = false;
    setIsLoadingModels(true);
    void (async () => {
      try {
        const response = await api.get(`/providers/${config.provider}/models`);
        const payload = (await response.json()) as ApiResponse<{
          models?: { OPTIONS?: { value: string; label: string; description?: string; effort?: any }[]; DEFAULT?: string };
        }>;
        if (cancelled) return;
        const options = payload.data?.models?.OPTIONS ?? [];
        setModelOptions(options.map((o) => ({ value: o.value, label: o.label, description: o.description })));
        const selected = options.find((o) => o.value === config.model);
        const effortValues = selected?.effort?.values ?? [];
        setEffortOptions(effortValues.map((v: any) => ({ value: v.value, description: v.description })));
      } catch {
        if (!cancelled) {
          setModelOptions([]);
          setEffortOptions([]);
        }
      } finally {
        if (!cancelled) setIsLoadingModels(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [config.provider, config.model]);

  const save = useCallback(
    async (next: Partial<BoardConfig>) => {
      if (!projectId) return;
      const merged = { ...configRef.current, ...next };
      setConfig(merged);
      try {
        await api.kanban.saveBoardConfig(projectId, merged);
      } catch {
        /* the next config broadcast will correct local state */
      }
    },
    [projectId],
  );

  const configRef = useRef(config);
  useEffect(() => {
    configRef.current = config;
  }, [config]);

  return useMemo(
    () => ({ config, providers: PROVIDERS, modelOptions, effortOptions, isLoadingModels, save }),
    [config, modelOptions, effortOptions, isLoadingModels, save],
  );
}
