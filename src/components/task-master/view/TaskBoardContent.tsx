import { useState, useRef } from 'react';
import {
  CheckCircle,
  Circle,
  CircleDashed,
  Clock,
  Play,
  Search,
} from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../lib/utils';
import { EmptyState, Tooltip } from '../../../shared/view/ui';
import type { TaskBoardView, TaskId, TaskKanbanColumn, TaskMasterTask, TaskSelection } from '../types';

import TaskCard from './TaskCard';

type TaskBoardContentProps = {
  viewMode: TaskBoardView;
  filteredTaskCount: number;
  kanbanColumns: TaskKanbanColumn[];
  filteredTasks: TaskMasterTask[];
  showParentTasks: boolean;
  onTaskClick: (task: TaskSelection) => void;
  onRunTask?: ((task: TaskMasterTask) => void) | null;
  onStatusChange?: ((taskId: TaskId, status: string) => void) | null;
};

function KanbanColumns({
  columns,
  showParentTasks,
  onTaskClick,
  onRunTask,
  onStatusChange,
}: {
  columns: TaskKanbanColumn[];
  showParentTasks: boolean;
  onTaskClick: (task: TaskSelection) => void;
  onRunTask?: ((task: TaskMasterTask) => void) | null;
  onStatusChange?: ((taskId: TaskId, status: string) => void) | null;
}) {
  const { t } = useTranslation('tasks');
  const [activeColumnIndex, setActiveColumnIndex] = useState(0);
  const carouselRef = useRef<HTMLDivElement>(null);
  // The dragged task is kept in a ref (not only dataTransfer) so the drop
  // handler can skip no-op drops onto the task's current column — getData is
  // only readable inside drop, but the task object is always available.
  const draggedTaskRef = useRef<TaskMasterTask | null>(null);

  const handleScroll = (e: React.UIEvent<HTMLDivElement>) => {
    const container = e.currentTarget;
    const scrollLeft = container.scrollLeft;
    const colWidth = container.clientWidth * 0.85;
    if (colWidth > 0) {
      const index = Math.round(scrollLeft / colWidth);
      setActiveColumnIndex(Math.max(0, Math.min(columns.length - 1, index)));
    }
  };

  const scrollToColumn = (index: number) => {
    if (!carouselRef.current) return;
    const children = carouselRef.current.children;
    if (children[index]) {
      (children[index] as HTMLElement).scrollIntoView({
        behavior: 'smooth',
        block: 'nearest',
        inline: 'center',
      });
      setActiveColumnIndex(index);
    }
  };

  return (
    <div className="space-y-3">
      {/* Mobile column indicator segments/pills at the top */}
      {columns.length > 1 && (
        <div className="scrollbar-none flex items-center gap-1.5 overflow-x-auto px-1 py-1 sm:hidden">
          {columns.map((column, idx) => (
            <button
              key={column.id}
              type="button"
              onClick={() => scrollToColumn(idx)}
              className={cn(
                'flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium transition-all duration-200 shrink-0',
                activeColumnIndex === idx
                  ? 'bg-blue-600 text-white shadow-sm ring-2 ring-blue-600/30'
                  : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700',
              )}
            >
              <span>{column.title}</span>
              <span
                className={cn(
                  'rounded-full px-1.5 py-0.2 text-[10px] font-semibold',
                  activeColumnIndex === idx
                    ? 'bg-white/25 text-white'
                    : 'bg-gray-200 dark:bg-gray-700 text-gray-500 dark:text-gray-400',
                )}
              >
                {column.tasks.length}
              </span>
            </button>
          ))}
        </div>
      )}

      {/* Horizontal snap carousel on mobile, responsive grid on desktop */}
      <div
        ref={carouselRef}
        onScroll={handleScroll}
        className={cn(
          'flex flex-nowrap overflow-x-auto snap-x snap-mandatory gap-4 pb-4 sm:pb-0 sm:overflow-visible sm:grid sm:gap-6',
          columns.length === 1 && 'sm:grid-cols-1 sm:max-w-md sm:mx-auto',
          columns.length === 2 && 'sm:grid-cols-1 md:grid-cols-2',
          columns.length === 3 && 'sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3',
          columns.length === 4 && 'sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-4',
          columns.length === 5 && 'sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5',
          columns.length >= 6 && 'sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6',
        )}
      >
        {columns.map((column) => (
          <div
            key={column.id}
            className={cn(
              'w-[85vw] max-w-[340px] shrink-0 snap-center sm:w-auto sm:max-w-none sm:shrink rounded-xl border shadow-sm transition-shadow hover:shadow-md',
              column.color,
            )}
          >
            <div className={cn('px-4 py-3 rounded-t-xl border-b', column.headerColor)}>
              <div className="flex items-center justify-between">
                <h3 className="text-sm font-semibold">{column.title}</h3>
                <span className="rounded-full bg-white/60 px-2 py-1 text-xs font-medium dark:bg-black/20">
                  {column.tasks.length}
                </span>
              </div>
            </div>

            <div
              className="max-h-[calc(100vh-300px)] min-h-[200px] space-y-3 overflow-y-auto p-3"
              onDragOver={
                onStatusChange
                  ? (event) => {
                      event.preventDefault();
                      event.dataTransfer.dropEffect = 'move';
                    }
                  : undefined
              }
              onDrop={
                onStatusChange
                  ? (event) => {
                      event.preventDefault();
                      const draggedTask = draggedTaskRef.current;
                      draggedTaskRef.current = null;
                      if (draggedTask && (draggedTask.status ?? 'pending') !== column.status) {
                        onStatusChange(draggedTask.id, column.status);
                      }
                    }
                  : undefined
              }
            >
              {column.tasks.length === 0 ? (
                <EmptyState
                  size="sm"
                  icon={CircleDashed}
                  title={t('kanban.noTasksYet')}
                  description={
                    column.status === 'pending'
                      ? t('kanban.tasksWillAppear')
                      : column.status === 'in-progress'
                        ? t('kanban.moveTasksHere')
                        : column.status === 'done'
                          ? t('kanban.completedTasksHere')
                          : t('kanban.statusTasksHere')
                  }
                  className="py-8"
                />
              ) : (
                column.tasks.map((task) => (
                  <div
                    key={String(task.id)}
                    draggable={Boolean(onStatusChange)}
                    onDragStart={(event) => {
                      draggedTaskRef.current = task;
                      event.dataTransfer.effectAllowed = 'move';
                      event.dataTransfer.setData('text/plain', String(task.id));
                    }}
                    onDragEnd={() => {
                      draggedTaskRef.current = null;
                    }}
                  >
                    <TaskCard
                      task={task}
                      onClick={() => onTaskClick(task)}
                      onRunTask={onRunTask}
                      showParent={showParentTasks}
                      className="w-full shadow-sm hover:shadow-md"
                    />
                  </div>
                ))
              )}
            </div>
          </div>
        ))}
      </div>

      {/* Mobile indicator dots at the bottom */}
      {columns.length > 1 && (
        <div className="flex items-center justify-center gap-1.5 pt-1 sm:hidden">
          {columns.map((column, idx) => (
            <button
              key={column.id}
              type="button"
              onClick={() => scrollToColumn(idx)}
              aria-label={column.title}
              className={cn(
                'h-1.5 rounded-full transition-all duration-200',
                activeColumnIndex === idx
                  ? 'w-5 bg-blue-600 dark:bg-blue-400'
                  : 'w-1.5 bg-gray-300 dark:bg-gray-600',
              )}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function CompactTaskRow({
  task,
  showParentTasks,
  onTaskClick,
  onRunTask,
  onStatusChange,
}: {
  task: TaskMasterTask;
  showParentTasks: boolean;
  onTaskClick: (task: TaskSelection) => void;
  onRunTask?: ((task: TaskMasterTask) => void) | null;
  onStatusChange?: ((taskId: TaskId, status: string) => void) | null;
}) {
  const isDone = task.status === 'done';
  const isInProgress = task.status === 'in-progress';

  const handleToggleStatus = (e: React.MouseEvent) => {
    e.stopPropagation();
    if (onStatusChange) {
      onStatusChange(task.id, isDone ? 'pending' : 'done');
    }
  };

  return (
    <div
      onClick={() => onTaskClick(task)}
      className={cn(
        'group flex items-center gap-3 px-3.5 py-2.5 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors cursor-pointer border-b border-gray-100 dark:border-gray-700/60 last:border-b-0',
        isDone && 'bg-gray-50/40 dark:bg-gray-800/40',
      )}
    >
      {/* Checkbox / Status indicator */}
      <Tooltip content={isDone ? 'Completed (click to reopen)' : isInProgress ? 'In progress (click to complete)' : 'Mark completed'}>
        <button
          type="button"
          onClick={handleToggleStatus}
          className="flex-shrink-0 text-gray-400 hover:text-blue-600 focus:outline-none dark:hover:text-blue-400"
          aria-label={`Toggle task ${task.id} status`}
        >
          {isDone ? (
            <CheckCircle className="h-4 w-4 text-emerald-500 dark:text-emerald-400" />
          ) : isInProgress ? (
            <Clock className="h-4 w-4 animate-pulse text-blue-500 dark:text-blue-400" />
          ) : (
            <Circle className="h-4 w-4 text-gray-300 group-hover:text-gray-400 dark:text-gray-600" />
          )}
        </button>
      </Tooltip>

      {/* Task ID */}
      <Tooltip content={`Task ID: ${task.id}`}>
        <span className="flex-shrink-0 rounded bg-gray-100 px-1.5 py-0.5 font-mono text-xs text-gray-500 dark:bg-gray-700 dark:text-gray-400">
          {task.id}
        </span>
      </Tooltip>

      {/* Title */}
      <div className="flex min-w-0 flex-1 items-center gap-2">
        <span
          className={cn(
            'truncate text-sm font-medium',
            isDone
              ? 'line-through text-gray-400 dark:text-gray-500'
              : 'text-gray-900 dark:text-white',
          )}
        >
          {task.title}
        </span>
        {showParentTasks && task.parentId && (
          <span className="py-0.2 hidden flex-shrink-0 rounded bg-gray-100 px-1.5 text-[10px] text-gray-400 dark:bg-gray-700/60 sm:inline-flex">
            Task {task.parentId}
          </span>
        )}
      </div>

      {/* Priority badge */}
      <div className="flex-shrink-0">
        <span
          className={cn(
            'inline-flex items-center px-2 py-0.5 rounded text-[11px] font-medium capitalize',
            task.priority === 'high'
              ? 'bg-red-50 text-red-700 dark:bg-red-950/50 dark:text-red-300 border border-red-200 dark:border-red-900'
              : task.priority === 'medium'
                ? 'bg-amber-50 text-amber-700 dark:bg-amber-950/50 dark:text-amber-300 border border-amber-200 dark:border-amber-900'
                : task.priority === 'low'
                  ? 'bg-blue-50 text-blue-700 dark:bg-blue-950/50 dark:text-blue-300 border border-blue-200 dark:border-blue-900'
                  : 'bg-gray-50 text-gray-600 dark:bg-gray-800 dark:text-gray-400 border border-gray-200 dark:border-gray-700',
          )}
        >
          {task.priority ?? 'medium'}
        </span>
      </div>

      {/* Quick Action (Play / Run) */}
      <div className="flex flex-shrink-0 items-center">
        {onRunTask && (
          <Tooltip content={isInProgress ? 'Task in progress' : 'Run task'}>
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                onRunTask(task);
              }}
              className={cn(
                'flex h-6 w-6 items-center justify-center rounded transition-colors',
                isInProgress
                  ? 'text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/30'
                  : 'text-gray-400 hover:text-green-600 dark:hover:text-green-400 hover:bg-green-50 dark:hover:bg-green-900/30',
              )}
              aria-label={`Run task ${task.id}`}
            >
              <Play className={cn('h-3.5 w-3.5', isInProgress && 'fill-current')} />
            </button>
          </Tooltip>
        )}
      </div>
    </div>
  );
}

export default function TaskBoardContent({
  viewMode,
  filteredTaskCount,
  kanbanColumns,
  filteredTasks,
  showParentTasks,
  onTaskClick,
  onRunTask = null,
  onStatusChange = null,
}: TaskBoardContentProps) {
  const { t } = useTranslation('tasks');

  if (filteredTaskCount === 0) {
    return (
      <div className="py-12 text-center">
        <div className="text-gray-500 dark:text-gray-400">
          <Search className="mx-auto mb-4 h-12 w-12 opacity-50" />
          <h3 className="mb-2 text-lg font-medium">{t('noMatchingTasks.title')}</h3>
          <p className="text-sm">{t('noMatchingTasks.description')}</p>
        </div>
      </div>
    );
  }

  if (viewMode === 'kanban') {
    return (
      <KanbanColumns
        columns={kanbanColumns}
        showParentTasks={showParentTasks}
        onTaskClick={onTaskClick}
        onRunTask={onRunTask}
        onStatusChange={onStatusChange}
      />
    );
  }

  if (viewMode === 'list') {
    return (
      <div className="overflow-hidden rounded-lg border border-gray-200 bg-white shadow-sm dark:border-gray-700 dark:bg-gray-800">
        {filteredTasks.map((task) => (
          <CompactTaskRow
            key={String(task.id)}
            task={task}
            showParentTasks={showParentTasks}
            onTaskClick={onTaskClick}
            onRunTask={onRunTask}
            onStatusChange={onStatusChange}
          />
        ))}
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
      {filteredTasks.map((task) => (
        <TaskCard
          key={String(task.id)}
          task={task}
          onClick={() => onTaskClick(task)}
          onRunTask={onRunTask}
          showParent={showParentTasks}
          className="h-full"
        />
      ))}
    </div>
  );
}
