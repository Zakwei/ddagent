import { useState } from 'react';
import { useTranslation } from 'react-i18next';

import { api } from '../../../../utils/api';
import { useTaskMaster } from '../../../task-master/context/TaskMasterContext';

const SAVE_SUCCESS_TIMEOUT_MS = 2000;

const truncateTitle = (text: string): string => {
  const plain = text
    .replace(/```[\s\S]*?```/g, '')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/\n+/g, ' ')
    .trim();
  if (!plain) return 'Task from chat';
  return plain.length <= 80 ? plain : `${plain.slice(0, 77).trim()}...`;
};

const MessageTaskMasterControl = ({
  content,
  projectId,
}: {
  content: string;
  projectId: string | null | undefined;
}) => {
  const { t } = useTranslation('chat');
  const { refreshTasks } = useTaskMaster();
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  if (!projectId) {
    return null;
  }

  const handleSave = async () => {
    const trimmed = content.trim();
    if (!trimmed || saving) return;

    setSaving(true);
    try {
      const title = truncateTitle(trimmed);
      const description = trimmed;
      const response = await api.taskmaster.addTask(projectId, {
        title,
        description,
        priority: 'medium',
        prompt: undefined,
        dependencies: undefined,
      });

      if (response.ok) {
        setSaved(true);
        window.setTimeout(() => setSaved(false), SAVE_SUCCESS_TIMEOUT_MS);
        // Keep TaskMasterContext in sync so the board and badge counts show
        // the new task without a manual refresh.
        void refreshTasks();
      } else {
        const error = await response.json().catch(() => ({}));
        console.error('[TaskMaster] Failed to add task:', error);
      }
    } catch (error) {
      console.error('[TaskMaster] Error adding task:', error);
    } finally {
      setSaving(false);
    }
  };

  const toneClass = 'text-gray-400 hover:text-gray-600 dark:text-gray-500 dark:hover:text-gray-300';
  const label = saved
    ? t('taskMaster.saved', { defaultValue: 'Saved' })
    : saving
      ? t('taskMaster.saving', { defaultValue: 'Saving...' })
      : t('taskMaster.saveToTask', { defaultValue: 'Task' });

  return (
    <button
      type="button"
      onClick={handleSave}
      disabled={saving}
      title={label}
      aria-label={label}
      className={`inline-flex items-center gap-1 rounded px-1 py-0.5 transition-colors ${toneClass} ${saving ? 'opacity-50' : ''}`}
    >
      {saved ? (
        <svg className="h-3.5 w-3.5" viewBox="0 0 20 20" fill="currentColor">
          <path
            fillRule="evenodd"
            d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
            clipRule="evenodd"
          />
        </svg>
      ) : (
        <svg
          className="h-3.5 w-3.5"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <line x1="12" y1="5" x2="12" y2="19" />
          <line x1="5" y1="12" x2="19" y2="12" />
        </svg>
      )}
      <span className="text-[10px] font-semibold uppercase tracking-wide">
        {saved ? 'OK' : saving ? '...' : t('taskMaster.taskShort', { defaultValue: 'TASK' })}
      </span>
    </button>
  );
};

export default MessageTaskMasterControl;
