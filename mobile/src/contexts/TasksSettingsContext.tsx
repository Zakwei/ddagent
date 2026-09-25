import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api } from '~shared/utils/api';

const STORAGE_KEY = 'tasks-enabled';

type TasksSettingsValue = {
  tasksEnabled: boolean;
  setTasksEnabled: (value: boolean) => void;
  toggleTasksEnabled: () => void;
  isTaskMasterInstalled: boolean | null;
  isTaskMasterReady: boolean | null;
  installationStatus: unknown;
  isCheckingInstallation: boolean;
};

const TasksSettingsContext = createContext<TasksSettingsValue | null>(null);

export const useTasksSettings = () => {
  const ctx = useContext(TasksSettingsContext);
  if (!ctx) throw new Error('useTasksSettings must be used within a TasksSettingsProvider');
  return ctx;
};

/**
 * Mirrors the web `TasksSettingsContext`: TaskMaster availability drives whether
 * the Tasks entry shows up in navigation. `tasks-enabled` persists in
 * AsyncStorage (localStorage on web).
 */
export function TasksSettingsProvider({ children }: { children: React.ReactNode }) {
  const [tasksEnabled, setTasksEnabledState] = useState(true);
  const [isTaskMasterInstalled, setIsTaskMasterInstalled] = useState<boolean | null>(null);
  const [isTaskMasterReady, setIsTaskMasterReady] = useState<boolean | null>(null);
  const [installationStatus, setInstallationStatus] = useState<unknown>(null);
  const [isCheckingInstallation, setIsCheckingInstallation] = useState(true);

  useEffect(() => {
    AsyncStorage.getItem(STORAGE_KEY).then((raw) => {
      if (raw !== null) {
        try {
          setTasksEnabledState(JSON.parse(raw));
        } catch {
          // Corrupt value — keep the default.
        }
      }
    });
  }, []);

  const setTasksEnabled = useCallback((value: boolean) => {
    setTasksEnabledState(value);
    void AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(value)).catch(() => {});
  }, []);

  const toggleTasksEnabled = useCallback(() => {
    setTasksEnabled(!tasksEnabled);
  }, [tasksEnabled, setTasksEnabled]);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const response = await api.get('/taskmaster/installation-status');
        if (response.ok) {
          const data = await response.json();
          if (cancelled) return;
          setInstallationStatus(data);
          const installed = Boolean(data?.installation?.isInstalled);
          setIsTaskMasterInstalled(installed);
          setIsTaskMasterReady(Boolean(data?.isReady));
          const userEnabled = await AsyncStorage.getItem(STORAGE_KEY);
          // Not installed and user never made a choice → auto-disable, like web.
          if (!installed && userEnabled === null) setTasksEnabledState(false);
        } else {
          setIsTaskMasterInstalled(false);
          setIsTaskMasterReady(false);
        }
      } catch {
        if (!cancelled) {
          setIsTaskMasterInstalled(false);
          setIsTaskMasterReady(false);
        }
      } finally {
        if (!cancelled) setIsCheckingInstallation(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const value = useMemo(
    () => ({
      tasksEnabled,
      setTasksEnabled,
      toggleTasksEnabled,
      isTaskMasterInstalled,
      isTaskMasterReady,
      installationStatus,
      isCheckingInstallation,
    }),
    [tasksEnabled, setTasksEnabled, toggleTasksEnabled, isTaskMasterInstalled, isTaskMasterReady, installationStatus, isCheckingInstallation],
  );

  return <TasksSettingsContext.Provider value={value}>{children}</TasksSettingsContext.Provider>;
}
