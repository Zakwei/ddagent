import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { api } from '~shared/utils/api';
import { useWebSocket } from '../contexts/WebSocketContext';
import { readApiError } from './kanban';

export type TaskId = string | number;

export type TaskMasterTask = {
  id: TaskId;
  title: string;
  description?: string;
  status?: string;
  priority?: string;
  details?: string;
  testStrategy?: string;
  parentId?: TaskId;
  dependencies?: TaskId[];
  subtasks?: TaskMasterTask[];
  createdAt?: string;
  updatedAt?: string;
};

export type TaskKanbanColumn = {
  id: string;
  title: string;
  status: string;
  headerBg: string;
  headerText: string;
  tasks: TaskMasterTask[];
};

export type TasksView = 'kanban' | 'list' | 'grid';

export type SortField = 'id' | 'title' | 'status' | 'priority' | 'updated';
export type SortOrder = 'asc' | 'desc';

export const STATUS_OPTIONS = ['pending', 'in-progress', 'review', 'done', 'deferred', 'cancelled'];
export const PRIORITY_OPTIONS = ['high', 'medium', 'low'];

// KANBAN_COLUMN_CONFIG from src/components/task-master/utils/taskKanban.ts; the
// Tailwind header classes are baked to hex because NativeWind is layout-only.
export const TASK_COLUMNS: {
  id: string;
  titleKey: string;
  status: string;
  light: string;
  lightText: string;
  dark: string;
  darkText: string;
}[] = [
  { id: 'pending', titleKey: 'kanban.pending', status: 'pending', light: '#f1f5f9', lightText: '#1e293b', dark: '#1e293b', darkText: '#e2e8f0' },
  { id: 'in-progress', titleKey: 'kanban.inProgress', status: 'in-progress', light: '#dbeafe', lightText: '#1e40af', dark: '#1e40af', darkText: '#bfdbfe' },
  { id: 'review', titleKey: 'kanban.review', status: 'review', light: '#ede9fe', lightText: '#5b21b6', dark: '#5b21b6', darkText: '#ddd6fe' },
  { id: 'done', titleKey: 'kanban.done', status: 'done', light: '#d1fae5', lightText: '#065f46', dark: '#065f46', darkText: '#a7f3d0' },
  { id: 'blocked', titleKey: 'kanban.blocked', status: 'blocked', light: '#fee2e2', lightText: '#991b1b', dark: '#991b1b', darkText: '#fecaca' },
  { id: 'deferred', titleKey: 'kanban.deferred', status: 'deferred', light: '#fef3c7', lightText: '#92400e', dark: '#92400e', darkText: '#fde68a' },
  { id: 'cancelled', titleKey: 'kanban.cancelled', status: 'cancelled', light: '#f3f4f6', lightText: '#1f2937', dark: '#1f2937', darkText: '#e5e7eb' },
];

const CORE_WORKFLOW_STATUSES = new Set(['pending', 'in-progress', 'done']);

export function buildTaskColumns(tasks: TaskMasterTask[], isDark: boolean, t: (k: string) => string): TaskKanbanColumn[] {
  const byStatus = tasks.reduce<Record<string, TaskMasterTask[]>>((acc, task) => {
    const status = task.status ?? 'pending';
    (acc[status] ??= []).push(task);
    return acc;
  }, {});

  return TASK_COLUMNS.filter(
    (column) => (byStatus[column.status] ?? []).length > 0 || CORE_WORKFLOW_STATUSES.has(column.status),
  ).map((column) => ({
    id: column.id,
    title: t(column.titleKey),
    status: column.status,
    headerBg: isDark ? column.dark : column.light,
    headerText: isDark ? column.darkText : column.lightText,
    tasks: byStatus[column.status] ?? [],
  }));
}

const STATUS_ORDER: Record<string, number> = {
  pending: 1,
  'in-progress': 2,
  review: 3,
  done: 4,
  blocked: 5,
  deferred: 6,
  cancelled: 7,
};

const PRIORITY_ORDER: Record<string, number> = { low: 1, medium: 2, high: 3 };

function toComparableIdParts(taskId: TaskId): number[] {
  return String(taskId)
    .split('.')
    .map((part) => Number.parseInt(part, 10))
    .map((part) => (Number.isNaN(part) ? 0 : part));
}

function compareTaskIds(leftId: TaskId, rightId: TaskId): number {
  const leftParts = toComparableIdParts(leftId);
  const rightParts = toComparableIdParts(rightId);
  const maxDepth = Math.max(leftParts.length, rightParts.length);
  for (let index = 0; index < maxDepth; index += 1) {
    const left = leftParts[index] ?? 0;
    const right = rightParts[index] ?? 0;
    if (left !== right) return left - right;
  }
  return 0;
}

function getSortValue(task: TaskMasterTask, field: SortField): number | string {
  if (field === 'title') return (task.title ?? '').toLowerCase();
  if (field === 'status') return STATUS_ORDER[task.status ?? 'pending'] ?? 999;
  if (field === 'priority') return PRIORITY_ORDER[task.priority ?? 'medium'] ?? 0;
  if (field === 'updated') {
    const timestamp = task.updatedAt ?? task.createdAt ?? '';
    return new Date(timestamp).getTime() || 0;
  }
  return 0;
}

export function sortTasks(tasks: TaskMasterTask[], field: SortField, order: SortOrder): TaskMasterTask[] {
  const sorted = [...tasks];
  sorted.sort((left, right) => {
    const direction = order === 'asc' ? 1 : -1;
    if (field === 'id') return compareTaskIds(left.id, right.id) * direction;
    const leftValue = getSortValue(left, field);
    const rightValue = getSortValue(right, field);
    if (typeof leftValue === 'string' && typeof rightValue === 'string') {
      return leftValue.localeCompare(rightValue) * direction;
    }
    return (Number(leftValue) - Number(rightValue)) * direction;
  });
  return sorted;
}

async function mutate(
  response: Response,
  fallback: string,
): Promise<void> {
  if (response.ok) return;
  const payload = await response.json().catch(() => null);
  throw new Error(readApiError(payload, fallback));
}

/** Loads and mutates one project's TaskMaster tasks; kept live via taskmaster-* events. */
export function useTasksBoard(projectId: string | null) {
  const { subscribe } = useWebSocket();
  const [tasks, setTasks] = useState<TaskMasterTask[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const projectIdRef = useRef(projectId);
  projectIdRef.current = projectId;

  const refresh = useCallback(async () => {
    if (!projectId) {
      setTasks([]);
      return;
    }
    setIsLoading(true);
    try {
      const response = await api.get(`/taskmaster/tasks/${encodeURIComponent(projectId)}`);
      const payload = await response.json();
      if (!response.ok) throw new Error(readApiError(payload, 'Failed to load tasks'));
      setTasks(Array.isArray(payload.tasks) ? payload.tasks : []);
      setError(null);
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Failed to load tasks');
    } finally {
      setIsLoading(false);
    }
  }, [projectId]);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  useEffect(
    () =>
      subscribe((event) => {
        if (
          (event?.type === 'taskmaster-tasks-updated' || event?.type === 'taskmaster-project-updated') &&
          event.projectId === projectIdRef.current
        ) {
          void refresh();
        }
      }),
    [subscribe, refresh],
  );

  const updateTask = useCallback(
    async (taskId: TaskId, updates: Partial<TaskMasterTask>) => {
      if (!projectId) return;
      await mutate(await api.taskmaster.updateTask(projectId, taskId, updates), 'Failed to update task');
      await refresh();
    },
    [projectId, refresh],
  );

  const deleteTask = useCallback(
    async (taskId: TaskId) => {
      if (!projectId) return;
      await mutate(await api.taskmaster.deleteTask(projectId, taskId), 'Failed to delete task');
      await refresh();
    },
    [projectId, refresh],
  );

  const addTask = useCallback(
    async (body: { title: string; description?: string; priority?: string; details?: string; testStrategy?: string }) => {
      if (!projectId) return;
      await mutate(await api.taskmaster.addTask(projectId, body), 'Failed to add task');
      await refresh();
    },
    [projectId, refresh],
  );

  const statuses = useMemo(
    () => [...new Set(tasks.map((task) => task.status).filter(Boolean))] as string[],
    [tasks],
  );
  const priorities = useMemo(
    () => [...new Set(tasks.map((task) => task.priority).filter(Boolean))] as string[],
    [tasks],
  );

  return { tasks, isLoading, error, refresh, updateTask, deleteTask, addTask, statuses, priorities };
}
