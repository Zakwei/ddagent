export type TaskBoardSortField = 'id' | 'title' | 'status' | 'priority' | 'updated';
export type TaskBoardSortOrder = 'asc' | 'desc';

export const SORT_COMBOS: { value: string; field: TaskBoardSortField; order: TaskBoardSortOrder }[] = [
  { value: 'id-asc', field: 'id', order: 'asc' },
  { value: 'id-desc', field: 'id', order: 'desc' },
  { value: 'title-asc', field: 'title', order: 'asc' },
  { value: 'title-desc', field: 'title', order: 'desc' },
  { value: 'status-asc', field: 'status', order: 'asc' },
  { value: 'status-desc', field: 'status', order: 'desc' },
  { value: 'priority-asc', field: 'priority', order: 'asc' },
  { value: 'priority-desc', field: 'priority', order: 'desc' },
];

export const QUICK_SORT_FIELDS: TaskBoardSortField[] = ['id', 'status', 'priority'];

/** Same field → flip order; different field → ascending. */
export function toggleSortOrder(
  currentField: TaskBoardSortField,
  currentOrder: TaskBoardSortOrder,
  nextField: TaskBoardSortField,
): TaskBoardSortOrder {
  if (currentField !== nextField) return 'asc';
  return currentOrder === 'asc' ? 'desc' : 'asc';
}

export type MinimalTask = { id: string | number; status?: string };

/** First pending or in-progress task, in input order. */
export function nextTaskOf<T extends MinimalTask>(tasks: T[]): T | null {
  return tasks.find((task) => task.status === 'pending' || task.status === 'in-progress') ?? null;
}

export type TaskStats = { total: number; completed: number; pending: number };

export function computeTaskStats(tasks: MinimalTask[]): TaskStats {
  const completed = tasks.filter((task) => task.status === 'done').length;
  const pending = tasks.filter((task) => task.status === 'pending' || task.status === undefined).length;
  return { total: tasks.length, completed, pending };
}

export const PRD_TEMPLATE = `# Product Requirements Document

## Overview

Describe the product or feature in a few sentences.

## Goals

- Goal one
- Goal two

## Non-Goals

- What is explicitly out of scope

## Users & Personas

Who is this for?

## Requirements

### Functional

- Requirement one
- Requirement two

### Non-Functional

- Performance, security, accessibility

## Design

Links, sketches, or notes.

## Technical Approach

Key implementation decisions and constraints.

## Milestones

1. Milestone one
2. Milestone two

## Open Questions

- Question one
`;

const PRD_EXTENSION = '.txt';

export function sanitizePrdName(name: string): string {
  return name.replace(/[<>:"/\\|?*]/g, '').trim();
}

export function stripPrdExtension(name: string): string {
  return name.replace(/\.(txt|md)$/i, '');
}

export function ensurePrdExtension(name: string): string {
  return /\.(txt|md)$/i.test(name) ? name : `${name}${PRD_EXTENSION}`;
}

export function defaultPrdName(date: Date = new Date()): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `prd-${year}-${month}-${day}`;
}

export type PrdListItem = { name: string; path?: string; size?: number; modified?: string; created?: string };

export function parsePrdList(payload: unknown): PrdListItem[] {
  if (!payload || typeof payload !== 'object') return [];
  const record = payload as Record<string, unknown>;
  const raw = Array.isArray(record.prdFiles)
    ? record.prdFiles
    : Array.isArray(record.prds)
      ? record.prds
      : [];
  return raw
    .filter((entry): entry is Record<string, unknown> => Boolean(entry) && typeof entry === 'object')
    .filter((entry) => typeof entry.name === 'string')
    .map((entry) => ({
      name: String(entry.name),
      path: typeof entry.path === 'string' ? entry.path : undefined,
      size: typeof entry.size === 'number' ? entry.size : undefined,
      modified: typeof entry.modified === 'string' ? entry.modified : undefined,
      created: typeof entry.created === 'string' ? entry.created : undefined,
    }));
}
