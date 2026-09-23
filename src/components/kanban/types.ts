import type { LLMProvider } from '../../types/app';

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
  provider: LLMProvider | null;
  model: string | null;
  effort: string | null;
  worktreePath: string | null;
  branch: string | null;
  prUrl: string | null;
  statusMessage: string | null;
  /** users.id of the assignee, or null when unassigned. */
  assigneeUserId: number | null;
  isArchived: boolean;
  createdAt: string;
  updatedAt: string;
};

export type CreateKanbanCardBody = {
  title: string;
  description?: string;
  provider?: LLMProvider | null;
  model?: string | null;
  effort?: string | null;
  /** Only honored by the PATCH endpoint — create ignores it. */
  assigneeUserId?: number | null;
};

export type CollabUser = {
  id: number;
  username: string;
  role: string;
  displayName: string;
};

export type KanbanCardComment = {
  id: string;
  cardId: string;
  userId: number | null;
  body: string;
  createdAt: string;
};

export type ActivityEvent = {
  id: string;
  projectId: string | null;
  userId: number | null;
  kind: string;
  entityId: string | null;
  summary: string;
  createdAt: string;
};

export type PresenceViewing = {
  kind: 'session' | 'card' | 'board';
  id: string;
} | null;

export type PresenceRosterEntry = {
  userId: string | number;
  username: string;
  viewing: PresenceViewing;
};

export type KanbanBoardConfig = {
  provider: LLMProvider | null;
  model: string | null;
  effort: string | null;
};

export type SaveKanbanBoardConfigInput = {
  provider: LLMProvider | null;
  model?: string | null;
  effort?: string | null;
};

export type KanbanColumnConfig = {
  id: KanbanCardStatus;
  titleKey: string;
  accent: string;
  headerClass: string;
};

export type KanbanContextValue = {
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

export type KanbanApiResponse<T> = {
  success: boolean;
  data?: T;
  error?: string;
};
