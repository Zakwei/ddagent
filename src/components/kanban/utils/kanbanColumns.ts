import type { TFunction } from 'i18next';

import type { KanbanCard, KanbanCardStatus, KanbanColumnConfig } from '../types';

// Backlog and archived are user-only shelves; the milestones in the middle are
// driven by the agent. Only `ready` kicks off a run.
export const KANBAN_COLUMN_CONFIG: KanbanColumnConfig[] = [
  {
    id: 'backlog',
    titleKey: 'board.columns.backlog',
    accent: 'bg-slate-400',
    headerClass: 'bg-slate-100 text-slate-800 dark:bg-slate-800 dark:text-slate-200',
  },
  {
    id: 'ready',
    titleKey: 'board.columns.ready',
    accent: 'bg-sky-500',
    headerClass: 'bg-sky-100 text-sky-800 dark:bg-sky-900/60 dark:text-sky-200',
  },
  {
    id: 'working',
    titleKey: 'board.columns.working',
    accent: 'bg-blue-500',
    headerClass: 'bg-blue-100 text-blue-800 dark:bg-blue-900/60 dark:text-blue-200',
  },
  {
    id: 'needs_decision',
    titleKey: 'board.columns.needsDecision',
    accent: 'bg-amber-500',
    headerClass: 'bg-amber-100 text-amber-900 dark:bg-amber-900/60 dark:text-amber-200',
  },
  {
    id: 'done',
    titleKey: 'board.columns.done',
    accent: 'bg-emerald-500',
    headerClass: 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/60 dark:text-emerald-200',
  },
  {
    id: 'archived',
    titleKey: 'board.columns.archived',
    accent: 'bg-gray-400',
    headerClass: 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
  },
];

// Statuses the user may drop a card into. Agent-owned statuses (working,
// needs_decision, done) are reported by the running agent, not dragged.
export const USER_MOVABLE_STATUSES = new Set<KanbanCardStatus>(['backlog', 'ready', 'archived']);

export type KanbanColumn = {
  id: KanbanCardStatus;
  title: string;
  accent: string;
  headerClass: string;
  cards: KanbanCard[];
};

export function buildKanbanColumns(cards: KanbanCard[], t: TFunction<'tasks'>): KanbanColumn[] {
  const byStatus = cards.reduce<Record<string, KanbanCard[]>>((accumulator, card) => {
    (accumulator[card.status] ??= []).push(card);
    return accumulator;
  }, {});

  return KANBAN_COLUMN_CONFIG.map((config) => ({
    id: config.id,
    title: t(config.titleKey),
    accent: config.accent,
    headerClass: config.headerClass,
    cards: (byStatus[config.id] ?? []).sort((a, b) => a.position - b.position),
  }));
}
