import { useState } from 'react';
import { X } from 'lucide-react';

import { Dialog, DialogContent, DialogTitle } from '../../../../shared/view/ui';
import { api } from '../../../../utils/api';

type CreateTaskModalProps = {
  isOpen: boolean;
  onClose: () => void;
  projectId?: string | null;
  onTaskCreated?: (() => void) | null;
};

const PRIORITIES = ['high', 'medium', 'low'];

export default function CreateTaskModal({
  isOpen,
  onClose,
  projectId = null,
  onTaskCreated = null,
}: CreateTaskModalProps) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState('medium');
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isOpen) {
    return null;
  }

  const reset = () => {
    setTitle('');
    setDescription('');
    setPriority('medium');
    setError(null);
  };

  const handleClose = () => {
    if (isSaving) return;
    reset();
    onClose();
  };

  const handleSubmit = async () => {
    const trimmedTitle = title.trim();
    if (!trimmedTitle || !projectId || isSaving) {
      return;
    }

    setIsSaving(true);
    setError(null);
    try {
      const response = await api.taskmaster.addTask(projectId, {
        title: trimmedTitle,
        description: description.trim(),
        priority,
      });

      if (!response.ok) {
        const payload = (await response.json().catch(() => ({}))) as { message?: string };
        throw new Error(payload.message ?? 'Failed to add task');
      }

      onTaskCreated?.();
      reset();
      onClose();
    } catch (caughtError) {
      setError(caughtError instanceof Error ? caughtError.message : 'Failed to add task');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    // Shared Dialog primitives provide role="dialog"/aria-modal, a Tab focus
    // trap, Escape and backdrop-click dismissal, and autofocus on open.
    <Dialog open={isOpen} onOpenChange={(nextOpen) => { if (!nextOpen) handleClose(); }}>
      <DialogContent
        className="max-w-md rounded-lg border-gray-200 bg-white p-0 shadow-xl dark:border-gray-700 dark:bg-gray-800"
        // Keep focus on the title input (its own autoFocus attr) instead of
        // the header close button.
        onOpenAutoFocus={(event) => event.preventDefault()}
      >
        <div className="flex items-center justify-between border-b border-gray-200 p-6 dark:border-gray-700">
          <DialogTitle className="not-sr-only text-lg font-semibold text-gray-900 dark:text-white">Add Task</DialogTitle>
          <button
            onClick={handleClose}
            className="rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-600 dark:hover:bg-gray-700 dark:hover:text-gray-300"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <div className="space-y-4 p-6">
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700 dark:text-gray-300">Title</label>
            <input
              type="text"
              value={title}
              autoFocus
              onChange={(event) => setTitle(event.target.value)}
              onKeyDown={(event) => {
                // Ignore Enter while an IME composition is in progress (CJK
                // input) — it belongs to the candidate window, not a submit.
                if (event.nativeEvent.isComposing) {
                  return;
                }
                if (event.key === 'Enter') void handleSubmit();
              }}
              placeholder="What needs to be done?"
              className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-gray-900 dark:border-gray-600 dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700 dark:text-gray-300">Description</label>
            <textarea
              rows={3}
              value={description}
              onChange={(event) => setDescription(event.target.value)}
              placeholder="Optional details"
              className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-gray-900 dark:border-gray-600 dark:bg-gray-700 dark:text-white"
            />
          </div>

          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700 dark:text-gray-300">Priority</label>
            <select
              value={priority}
              onChange={(event) => setPriority(event.target.value)}
              className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 capitalize text-gray-900 dark:border-gray-600 dark:bg-gray-700 dark:text-white"
            >
              {PRIORITIES.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
          </div>

          {error && <p className="text-sm text-red-600 dark:text-red-400">{error}</p>}

          <div className="flex justify-end gap-2 border-t border-gray-200 pt-4 dark:border-gray-700">
            <button
              onClick={handleClose}
              disabled={isSaving}
              className="rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600"
            >
              Cancel
            </button>
            <button
              onClick={() => void handleSubmit()}
              disabled={isSaving || !title.trim() || !projectId}
              className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-50"
            >
              {isSaving ? 'Adding...' : 'Add Task'}
            </button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
