import { useEffect, useMemo, useState } from 'react';
import {
  AlertCircle,
  ArrowRight,
  CheckCircle,
  ChevronDown,
  ChevronRight,
  Circle,
  Clock,
  Copy,
  Edit,
  Pause,
  Save,
  X,
} from 'lucide-react';

import { cn } from '../../../lib/utils';
import { Dialog, DialogContent, DialogTitle } from '../../../shared/view/ui';
import { copyTextToClipboard } from '../../../utils/clipboard';
import { api } from '../../../utils/api';
import { useTaskMaster } from '../context/TaskMasterContext';
import type { TaskId, TaskMasterTask, TaskReference } from '../types';

type TaskDetailModalProps = {
  task: TaskMasterTask | null;
  isOpen?: boolean;
  className?: string;
  onClose: () => void;
  onEdit?: ((task: TaskMasterTask) => void) | null;
  onStatusChange?: ((taskId: TaskId, status: string) => void) | null;
  onTaskClick?: ((task: TaskReference) => void) | null;
};

const STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'in-progress', label: 'In Progress' },
  { value: 'review', label: 'Review' },
  { value: 'done', label: 'Done' },
  { value: 'deferred', label: 'Deferred' },
  { value: 'cancelled', label: 'Cancelled' },
];

const PRIORITY_OPTIONS = ['high', 'medium', 'low'];

function formatDependencies(dependencies?: TaskId[]): string {
  return Array.isArray(dependencies) ? dependencies.join(', ') : '';
}

function getStatusIcon(status?: string) {
  if (status === 'done') return CheckCircle;
  if (status === 'in-progress') return Clock;
  if (status === 'review') return AlertCircle;
  if (status === 'deferred') return Pause;
  if (status === 'cancelled') return X;
  return Circle;
}

function getPriorityBadgeClass(priority?: string): string {
  if (priority === 'high') return 'text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-950';
  if (priority === 'medium') return 'text-yellow-600 dark:text-yellow-400 bg-yellow-50 dark:bg-yellow-950';
  if (priority === 'low') return 'text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-950';
  return 'text-gray-600 dark:text-gray-400 bg-gray-50 dark:bg-gray-800';
}

export default function TaskDetailModal({
  task: taskSnapshot,
  isOpen = true,
  className = '',
  onClose,
  onEdit = null,
  onStatusChange = null,
  onTaskClick = null,
}: TaskDetailModalProps) {
  const { currentProject, refreshTasks, tasks } = useTaskMaster();

  // Parents pass a snapshot that is not updated by refreshTasks; re-resolve it
  // from context so status/field edits render fresh data instead of reverting.
  const task = useMemo(
    () => tasks.find((candidate) => String(candidate.id) === String(taskSnapshot?.id)) ?? taskSnapshot,
    [tasks, taskSnapshot],
  );

  const [isEditMode, setIsEditMode] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [showDetails, setShowDetails] = useState(false);
  const [showTestStrategy, setShowTestStrategy] = useState(false);
  const [editableTask, setEditableTask] = useState<TaskMasterTask | null>(task);
  const [actionError, setActionError] = useState<string | null>(null);
  // Dependency ids are edited as raw comma-separated text so separators are
  // not normalized away mid-typing.
  const [dependenciesInput, setDependenciesInput] = useState(() => formatDependencies(task?.dependencies));

  useEffect(() => {
    setEditableTask(task);
    setDependenciesInput(formatDependencies(task?.dependencies));
    setIsEditMode(false);
    setActionError(null);
  }, [task]);

  const StatusIcon = useMemo(() => getStatusIcon(task?.status), [task?.status]);

  if (!isOpen || !task || !editableTask) {
    return null;
  }

  const handleSaveChanges = async () => {
    if (!currentProject?.projectId) {
      return;
    }

    const trimmedTitle = editableTask.title.trim();
    if (!trimmedTitle) {
      setActionError('Title is required');
      return;
    }

    const updates: Record<string, unknown> = {};

    if (trimmedTitle !== task.title) {
      updates.title = trimmedTitle;
    }

    if (editableTask.description !== task.description) {
      updates.description = editableTask.description ?? '';
    }

    if ((editableTask.priority ?? '') !== (task.priority ?? '')) {
      updates.priority = editableTask.priority ?? '';
    }

    if ((editableTask.details ?? '') !== (task.details ?? '')) {
      updates.details = editableTask.details ?? '';
    }

    if ((editableTask.testStrategy ?? '') !== (task.testStrategy ?? '')) {
      updates.testStrategy = editableTask.testStrategy ?? '';
    }

    const nextDependencies = dependenciesInput
      .split(',')
      .map((entry) => entry.trim())
      .filter(Boolean);
    const currentDependencies = (task.dependencies ?? []).map(String);
    if (nextDependencies.join(',') !== currentDependencies.join(',')) {
      updates.dependencies = nextDependencies;
    }

    if (Object.keys(updates).length === 0) {
      setIsEditMode(false);
      return;
    }

    setIsSaving(true);
    setActionError(null);
    try {
      const response = await api.taskmaster.updateTask(currentProject.projectId, task.id, updates);
      if (!response.ok) {
        const errorPayload = (await response.json()) as { message?: string };
        throw new Error(errorPayload.message ?? 'Failed to update task');
      }

      setIsEditMode(false);
      await refreshTasks();
      onEdit?.(editableTask);
    } catch (error) {
      console.error('Failed to save task changes:', error);
      setActionError(error instanceof Error ? error.message : 'Failed to update task');
    } finally {
      setIsSaving(false);
    }
  };

  const handleStatusSelect = async (nextStatus: string) => {
    if (!currentProject?.projectId || nextStatus === task.status) {
      return;
    }

    setActionError(null);
    try {
      const response = await api.taskmaster.updateTask(currentProject.projectId, task.id, { status: nextStatus });
      if (!response.ok) {
        const errorPayload = (await response.json()) as { message?: string };
        throw new Error(errorPayload.message ?? 'Failed to update task status');
      }

      await refreshTasks();
      onStatusChange?.(task.id, nextStatus);
    } catch (error) {
      console.error('Failed to update task status:', error);
      setActionError(error instanceof Error ? error.message : 'Failed to update task status');
    }
  };

  return (
    // Shared Dialog primitives provide role="dialog"/aria-modal, a Tab focus
    // trap, Escape and backdrop-click dismissal, and autofocus on open.
    <Dialog open onOpenChange={(nextOpen) => { if (!nextOpen && !isSaving) onClose(); }}>
      <DialogContent
        wrapperClassName="z-[100]"
        className={cn(
          'flex h-full w-full max-w-none flex-col rounded-none border-gray-200 bg-white p-0 shadow-xl dark:border-gray-700 dark:bg-gray-900 md:h-[90vh] md:max-w-4xl md:rounded-lg',
          className,
        )}
      >
        <DialogTitle>{`Task ${task.id}: ${task.title}`}</DialogTitle>
        <div className="flex items-center justify-between border-b border-gray-200 p-4 dark:border-gray-700 md:p-6">
          <div className="flex min-w-0 flex-1 items-center gap-3">
            <StatusIcon className="h-6 w-6 text-blue-600 dark:text-blue-400" />
            <div className="min-w-0 flex-1">
              <button
                onClick={() => copyTextToClipboard(String(task.id))}
                className="mb-2 inline-flex items-center gap-1 rounded bg-gray-100 px-2 py-1 text-xs text-gray-600 hover:bg-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700"
                title="Copy task ID"
              >
                <span>Task {task.id}</span>
                <Copy className="h-3 w-3" />
              </button>

              {isEditMode ? (
                <input
                  type="text"
                  value={editableTask.title}
                  onChange={(event) => setEditableTask({ ...editableTask, title: event.target.value })}
                  aria-invalid={!editableTask.title.trim()}
                  className="w-full border-b-2 border-blue-500 bg-transparent text-lg font-semibold text-gray-900 focus:outline-none dark:text-white"
                />
              ) : (
                <h1 className="line-clamp-2 text-lg font-semibold text-gray-900 dark:text-white md:text-xl">{task.title}</h1>
              )}
            </div>
          </div>

          <div className="flex items-center gap-2">
            {isEditMode ? (
              <>
                <button
                  onClick={handleSaveChanges}
                  disabled={isSaving || !editableTask.title.trim()}
                  className="rounded-md p-2 text-green-600 hover:bg-green-50 disabled:opacity-50 dark:hover:bg-green-950"
                  title="Save"
                >
                  <Save className={cn('w-5 h-5', isSaving && 'animate-spin')} />
                </button>
                <button
                  onClick={() => {
                    setEditableTask(task);
                    setDependenciesInput(formatDependencies(task.dependencies));
                    setActionError(null);
                    setIsEditMode(false);
                  }}
                  disabled={isSaving}
                  className="rounded-md p-2 text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800"
                  title="Cancel editing"
                >
                  <X className="h-5 w-5" />
                </button>
              </>
            ) : (
              <button
                onClick={() => {
                  setDependenciesInput(formatDependencies(task.dependencies));
                  setActionError(null);
                  setIsEditMode(true);
                }}
                className="rounded-md p-2 text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800"
                title="Edit task"
              >
                <Edit className="h-5 w-5" />
              </button>
            )}
            <button onClick={onClose} className="rounded-md p-2 text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800" title="Close">
              <X className="h-5 w-5" />
            </button>
          </div>
        </div>

        {actionError && (
          <div
            role="alert"
            className="border-b border-red-200 bg-red-50 px-4 py-2 text-sm text-red-600 dark:border-red-900/50 dark:bg-red-950/30 dark:text-red-400 md:px-6"
          >
            {actionError}
          </div>
        )}

        <div className="flex-1 space-y-6 overflow-y-auto p-4 md:p-6">
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            <div className="space-y-2">
              <label className="text-sm font-medium text-gray-700 dark:text-gray-300">Status</label>
              <select
                value={task.status ?? 'pending'}
                onChange={(event) => {
                  void handleStatusSelect(event.target.value);
                }}
                className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-gray-900 dark:border-gray-600 dark:bg-gray-800 dark:text-white"
              >
                {STATUS_OPTIONS.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium text-gray-700 dark:text-gray-300">Priority</label>
              {isEditMode ? (
                <select
                  value={editableTask.priority ?? 'medium'}
                  onChange={(event) => setEditableTask({ ...editableTask, priority: event.target.value })}
                  className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 capitalize text-gray-900 dark:border-gray-600 dark:bg-gray-800 dark:text-white"
                >
                  {PRIORITY_OPTIONS.map((option) => (
                    <option key={option} value={option}>
                      {option}
                    </option>
                  ))}
                </select>
              ) : (
                <div className={cn('px-3 py-2 rounded-md text-sm font-medium capitalize', getPriorityBadgeClass(task.priority))}>
                  {task.priority ?? 'Not set'}
                </div>
              )}
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium text-gray-700 dark:text-gray-300">Dependencies</label>
              {isEditMode ? (
                <input
                  type="text"
                  value={dependenciesInput}
                  onChange={(event) => setDependenciesInput(event.target.value)}
                  placeholder="e.g. 1, 2, 3"
                  className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-gray-900 dark:border-gray-600 dark:bg-gray-800 dark:text-white"
                />
              ) : Array.isArray(task.dependencies) && task.dependencies.length > 0 ? (
                <div className="flex flex-wrap gap-1">
                  {task.dependencies.map((dependency) => (
                    <button
                      key={String(dependency)}
                      onClick={() => onTaskClick?.({ id: dependency })}
                      className="rounded bg-blue-100 px-2 py-1 text-sm text-blue-700 hover:bg-blue-200 dark:bg-blue-900 dark:text-blue-300 dark:hover:bg-blue-800"
                    >
                      <ArrowRight className="mr-1 inline h-3 w-3" />
                      {dependency}
                    </button>
                  ))}
                </div>
              ) : (
                <span className="text-sm text-gray-500 dark:text-gray-400">No dependencies</span>
              )}
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-gray-700 dark:text-gray-300">Description</label>
            {isEditMode ? (
              <textarea
                rows={4}
                value={editableTask.description ?? ''}
                onChange={(event) => setEditableTask({ ...editableTask, description: event.target.value })}
                className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 dark:border-gray-600 dark:bg-gray-800"
              />
            ) : (
              <p className="whitespace-pre-wrap text-gray-700 dark:text-gray-300">{task.description || 'No description provided'}</p>
            )}
          </div>

          {(isEditMode || task.details) && (
            <div className="rounded-lg border border-gray-200 dark:border-gray-700">
              <button
                onClick={() => setShowDetails((current) => !current)}
                className="flex w-full items-center justify-between p-4 text-left hover:bg-gray-50 dark:hover:bg-gray-800"
              >
                <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Implementation Details</span>
                {showDetails ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
              </button>
              {showDetails && (
                <div className="border-t border-gray-200 p-4 dark:border-gray-700">
                  {isEditMode ? (
                    <textarea
                      rows={6}
                      value={editableTask.details ?? ''}
                      onChange={(event) => setEditableTask({ ...editableTask, details: event.target.value })}
                      className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 dark:border-gray-600 dark:bg-gray-800"
                    />
                  ) : (
                    <p className="whitespace-pre-wrap text-gray-700 dark:text-gray-300">{task.details}</p>
                  )}
                </div>
              )}
            </div>
          )}

          {(isEditMode || task.testStrategy) && (
            <div className="rounded-lg border border-gray-200 dark:border-gray-700">
              <button
                onClick={() => setShowTestStrategy((current) => !current)}
                className="flex w-full items-center justify-between p-4 text-left hover:bg-gray-50 dark:hover:bg-gray-800"
              >
                <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Test Strategy</span>
                {showTestStrategy ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
              </button>
              {showTestStrategy && (
                <div className="border-t border-gray-200 bg-blue-50 p-4 dark:border-gray-700 dark:bg-blue-950/30">
                  {isEditMode ? (
                    <textarea
                      rows={4}
                      value={editableTask.testStrategy ?? ''}
                      onChange={(event) => setEditableTask({ ...editableTask, testStrategy: event.target.value })}
                      className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 dark:border-gray-600 dark:bg-gray-800"
                    />
                  ) : (
                    <p className="whitespace-pre-wrap text-gray-700 dark:text-gray-300">{task.testStrategy}</p>
                  )}
                </div>
              )}
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
