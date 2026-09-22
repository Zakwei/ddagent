import { useEffect, useRef, useState } from 'react';
import { CheckCircle2, Plus, Terminal } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../lib/utils';
import { Dialog, DialogContent, DialogTitle } from '../../../../shared/view/ui';
import { api } from '../../../../utils/api';
import type { TaskMasterProject } from '../../types';

type TaskMasterSetupModalProps = {
  isOpen: boolean;
  project: TaskMasterProject | null;
  onClose: () => void;
  onAfterClose?: (() => void) | null;
};

export default function TaskMasterSetupModal({ isOpen, project, onClose, onAfterClose = null }: TaskMasterSetupModalProps) {
  const { t } = useTranslation('tasks');
  const [isInitializing, setIsInitializing] = useState(false);
  const [isComplete, setIsComplete] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const afterCloseTimerRef = useRef<number | null>(null);
  const afterCloseNotifiedRef = useRef(false);

  useEffect(() => () => {
    if (afterCloseTimerRef.current !== null) {
      window.clearTimeout(afterCloseTimerRef.current);
    }
  }, []);

  if (!isOpen || !project) {
    return null;
  }

  const clearAfterCloseTimer = () => {
    if (afterCloseTimerRef.current !== null) {
      window.clearTimeout(afterCloseTimerRef.current);
      afterCloseTimerRef.current = null;
    }
  };

  // Single-fire: the auto-close timer and handleClose both funnel through here
  // so onAfterClose can never run twice for one initialization.
  const notifyAfterClose = () => {
    if (afterCloseNotifiedRef.current) {
      return;
    }
    afterCloseNotifiedRef.current = true;
    onAfterClose?.();
  };

  const handleClose = () => {
    clearAfterCloseTimer();
    onClose();
    setIsComplete(false);
    setError(null);
    if (isComplete) {
      notifyAfterClose();
    }
  };

  const handleInitialize = async () => {
    if (!project.projectId || isInitializing) return;

    setIsInitializing(true);
    setError(null);
    afterCloseNotifiedRef.current = false;
    try {
      const response = await api.taskmaster.init(project.projectId);
      if (!response.ok) {
        const payload = (await response.json().catch(() => ({}))) as { message?: string };
        throw new Error(payload.message ?? 'Failed to initialize TaskMaster');
      }

      setIsComplete(true);
      clearAfterCloseTimer();
      afterCloseTimerRef.current = window.setTimeout(() => {
        afterCloseTimerRef.current = null;
        notifyAfterClose();
      }, 800);
    } catch (caughtError) {
      setError(caughtError instanceof Error ? caughtError.message : 'Failed to initialize TaskMaster');
    } finally {
      setIsInitializing(false);
    }
  };

  return (
    // Shared Dialog primitives provide role="dialog"/aria-modal, a Tab focus
    // trap, Escape and backdrop-click dismissal, and autofocus on open.
    <Dialog open onOpenChange={(nextOpen) => { if (!nextOpen) handleClose(); }}>
      <DialogContent className="flex w-full max-w-lg flex-col rounded-lg border-gray-200 bg-white p-0 shadow-xl dark:border-gray-700 dark:bg-gray-900">
        <div className="flex items-center justify-between border-b border-gray-200 p-4 dark:border-gray-700">
          <div className="flex items-center gap-3">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-100 dark:bg-blue-900/50">
              <Terminal className="h-4 w-4 text-blue-600 dark:text-blue-400" />
            </div>
            <div>
              <DialogTitle className="not-sr-only text-lg font-semibold text-gray-900 dark:text-white">{t('setupModal.title')}</DialogTitle>
              <p className="text-sm text-gray-500 dark:text-gray-400">{t('setupModal.subtitle', { projectName: project.displayName })}</p>
            </div>
          </div>

          <button
            onClick={handleClose}
            className="rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-600 dark:hover:bg-gray-800 dark:hover:text-gray-300"
            title={t('setupModal.closeTitle', { defaultValue: 'Close' })}
          >
            <Plus className="h-5 w-5 rotate-45" />
          </button>
        </div>

        <div className="space-y-4 p-6">
          <p className="text-sm text-gray-600 dark:text-gray-400">
            {t('setupModal.description', {
              defaultValue: 'Creates a .taskmaster folder in this project. No external tooling or API keys required — tasks are stored locally.',
            })}
          </p>

          {isComplete && (
            <div className="flex items-center gap-2 text-sm text-green-600 dark:text-green-400">
              <CheckCircle2 className="h-4 w-4" />
              {t('setupModal.completed')}
            </div>
          )}

          {error && <p className="text-sm text-red-600 dark:text-red-400">{error}</p>}
        </div>

        <div className="border-t border-gray-200 bg-gray-50 p-4 dark:border-gray-700 dark:bg-gray-800/50">
          <div className="flex items-center justify-end gap-2">
            <button
              onClick={handleClose}
              className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600"
            >
              {isComplete ? t('setupModal.closeContinueButton') : t('setupModal.closeButton')}
            </button>
            {!isComplete && (
              <button
                onClick={() => void handleInitialize()}
                disabled={isInitializing || !project.projectId}
                className={cn(
                  'rounded-md px-4 py-2 text-sm font-medium text-white transition-colors',
                  isInitializing ? 'bg-blue-400' : 'bg-blue-600 hover:bg-blue-700',
                )}
              >
                {isInitializing ? t('setupModal.initializing', { defaultValue: 'Initializing...' }) : t('setupModal.initializeButton', { defaultValue: 'Initialize' })}
              </button>
            )}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
