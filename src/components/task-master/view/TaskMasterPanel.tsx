import { useCallback, useEffect, useRef, useState } from 'react';

import { api } from '../../../utils/api';
import PRDEditor from '../../prd-editor';
import { useTaskMaster } from '../context/TaskMasterContext';
import { useProjectPrdFiles } from '../hooks/useProjectPrdFiles';
import type { PrdFile, TaskId, TaskMasterTask, TaskSelection } from '../types';

import TaskBoard from './TaskBoard';
import TaskDetailModal from './TaskDetailModal';

type TaskMasterPanelProps = {
  isVisible: boolean;
  onRunTask?: ((task: TaskMasterTask) => void) | null;
  onSwitchToChat?: ((prompt?: string) => void) | null;
};

const PRD_SAVE_MESSAGE = 'PRD saved successfully!';

export default function TaskMasterPanel({
  isVisible,
  onRunTask = null,
  onSwitchToChat = null,
}: TaskMasterPanelProps) {
  const { tasks, currentProject, refreshTasks } = useTaskMaster();

  const [selectedTask, setSelectedTask] = useState<TaskMasterTask | null>(null);
  const [isTaskDetailOpen, setIsTaskDetailOpen] = useState(false);

  const [isPrdEditorOpen, setIsPrdEditorOpen] = useState(false);
  const [selectedPrd, setSelectedPrd] = useState<PrdFile | null>(null);

  const [prdNotification, setPrdNotification] = useState<string | null>(null);
  const notificationTimeoutRef = useRef<number | null>(null);

  const { prdFiles, refreshPrdFiles } = useProjectPrdFiles({ projectId: currentProject?.projectId });

  const showPrdNotification = useCallback((message: string) => {
    if (notificationTimeoutRef.current) {
      window.clearTimeout(notificationTimeoutRef.current);
    }

    setPrdNotification(message);

    notificationTimeoutRef.current = window.setTimeout(() => {
      setPrdNotification(null);
      notificationTimeoutRef.current = null;
    }, 3000);
  }, []);

  const refreshPrdData = useCallback(
    async (showNotification = false) => {
      await refreshPrdFiles();
      if (showNotification) {
        showPrdNotification(PRD_SAVE_MESSAGE);
      }
    },
    [refreshPrdFiles, showPrdNotification],
  );

  useEffect(() => {
    return () => {
      if (notificationTimeoutRef.current) {
        window.clearTimeout(notificationTimeoutRef.current);
      }
    };
  }, []);

  const handleTaskClick = useCallback(
    (taskSelection: TaskSelection) => {
      const selectedId = String(taskSelection.id);

      if (!taskSelection.title) {
        const fullTask = tasks.find((task) => String(task.id) === selectedId) ?? null;
        if (fullTask) {
          setSelectedTask(fullTask);
          setIsTaskDetailOpen(true);
        }
        return;
      }

      setSelectedTask(taskSelection as TaskMasterTask);
      setIsTaskDetailOpen(true);
    },
    [tasks],
  );

  const handleRunTask = useCallback(
    async (task: TaskMasterTask) => {
      const projectId = currentProject?.projectId || currentProject?.name;
      if (projectId) {
        try {
          await api.taskmaster.updateTask(projectId, task.id, { status: 'in-progress' });
          await refreshTasks();
        } catch (error) {
          console.error('Failed to update task status:', error);
        }
      }

      const prompt = `/task-master start ${task.id}`;
      if (currentProject?.projectId) {
        try {
          localStorage.setItem(`draft_input_${currentProject.projectId}`, prompt);
          // The 'taskmaster:run-task' event below reaches no listener while
          // the chat view is unmounted (running from /tasks navigates first),
          // so the command is also stashed for the next composer of this
          // project — including session-bound composers that intentionally
          // skip the project-draft restore.
          sessionStorage.setItem(
            'taskmaster:pending-run-task',
            JSON.stringify({ projectId: currentProject.projectId, command: prompt }),
          );
        } catch {
          // Ignore storage quota
        }
      }

      window.dispatchEvent(
        new CustomEvent('taskmaster:run-task', {
          detail: { task, command: prompt },
        }),
      );

      showPrdNotification(`Task ${task.id} set to in-progress`);

      if (onRunTask) {
        onRunTask(task);
      } else if (onSwitchToChat) {
        onSwitchToChat(prompt);
      }
    },
    [currentProject, onRunTask, onSwitchToChat, refreshTasks, showPrdNotification],
  );

  const handleStatusChange = useCallback(
    async (taskId: TaskId, newStatus: string) => {
      const projectId = currentProject?.projectId || currentProject?.name;
      if (!projectId) return;

      try {
        await api.taskmaster.updateTask(projectId, taskId, { status: newStatus });
        await refreshTasks();
      } catch (error) {
        console.error('Failed to update task status:', error);
      }
    },
    [currentProject, refreshTasks],
  );

  return (
    <>
      <div className={`h-full ${isVisible ? 'block' : 'hidden'}`}>
        <div className="flex h-full flex-col overflow-hidden">
          <TaskBoard
            tasks={tasks}
            onTaskClick={handleTaskClick}
            onRunTask={handleRunTask}
            onStatusChange={handleStatusChange}
            showParentTasks
            className="flex-1 overflow-y-auto p-4"
            currentProject={currentProject}
            onTaskCreated={refreshTasks}
            onShowPRDEditor={(prd) => {
              setSelectedPrd(prd ?? null);
              setIsPrdEditorOpen(true);
            }}
            existingPRDs={prdFiles}
            onRefreshPRDs={(showNotification = false) => {
              void refreshPrdData(showNotification);
            }}
          />
        </div>
      </div>

      <TaskDetailModal
        task={selectedTask}
        isOpen={isTaskDetailOpen}
        onClose={() => {
          setIsTaskDetailOpen(false);
          setSelectedTask(null);
        }}
        onStatusChange={() => {
          void refreshTasks();
        }}
        onTaskClick={handleTaskClick}
      />

      {isPrdEditorOpen && (
        <PRDEditor
          project={currentProject}
          projectPath={currentProject?.fullPath || currentProject?.path}
          onClose={() => {
            setIsPrdEditorOpen(false);
            setSelectedPrd(null);
          }}
          isNewFile={!selectedPrd?.isExisting}
          file={{
            name: selectedPrd?.name || 'prd.txt',
            content: selectedPrd?.content || '',
            isExisting: selectedPrd?.isExisting,
          }}
          onSave={async () => {
            setIsPrdEditorOpen(false);
            setSelectedPrd(null);
            await refreshPrdData(true);
            await refreshTasks();
          }}
        />
      )}

      {prdNotification && (
        <div
          role="status"
          className="animate-in slide-in-from-bottom-2 fixed bottom-[calc(1rem_+_env(safe-area-inset-bottom))] right-[calc(1rem_+_env(safe-area-inset-right))] z-50 duration-300"
        >
          <div className="flex items-center gap-3 rounded-lg bg-green-600 px-4 py-3 text-white shadow-lg">
            <svg className="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
            </svg>
            <span className="font-medium">{prdNotification}</span>
          </div>
        </div>
      )}
    </>
  );
}
