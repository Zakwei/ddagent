import { useEffect, useRef } from 'react';

import type { AppTab } from '../types/app';

export interface UseAppKeyboardShortcutsOptions {
  activeTab?: AppTab;
  setActiveTab: (tab: AppTab) => void;
  shouldShowTasksTab: boolean;
  onToggleFocusMode: () => void;
  onNavigateHome?: () => void;
  /** Open the session-picker Panel (Ctrl/Cmd+K). */
  onOpenPanel?: () => void;
}

export function isModalOpen(): boolean {
  if (typeof document === 'undefined') {
    return false;
  }

  if (
    document.querySelector('[role="dialog"][aria-modal="true"]')
    || document.querySelector('[role="alertdialog"][aria-modal="true"]')
  ) {
    return true;
  }

  return false;
}

export function getAltDigit(event: KeyboardEvent): number | null {
  if (!event.altKey || event.ctrlKey || event.metaKey) {
    return null;
  }

  if (event.code === 'Digit1' || event.key === '1') return 1;
  if (event.code === 'Digit2' || event.key === '2') return 2;
  if (event.code === 'Digit3' || event.key === '3') return 3;
  if (event.code === 'Digit4' || event.key === '4') return 4;
  if (event.code === 'Digit5' || event.key === '5') return 5;

  return null;
}

export function getTargetTabForDigit(digit: number, shouldShowTasksTab: boolean): AppTab | null {
  switch (digit) {
    case 1:
      return 'chat';
    case 2:
      return shouldShowTasksTab ? 'tasks' : 'git';
    case 3:
      return 'git';
    case 4:
      return null;
    case 5:
      return null;
    default:
      return null;
  }
}

export function isFocusModeShortcut(event: KeyboardEvent): boolean {
  return (
    (event.ctrlKey || event.metaKey)
    && event.shiftKey
    && !event.altKey
    && (event.key === 'f' || event.key === 'F' || event.code === 'KeyF')
  );
}

export function useAppKeyboardShortcuts({
  setActiveTab,
  shouldShowTasksTab,
  onToggleFocusMode,
  onNavigateHome,
  onOpenPanel,
}: UseAppKeyboardShortcutsOptions) {
  const setActiveTabRef = useRef(setActiveTab);
  const shouldShowTasksTabRef = useRef(shouldShowTasksTab);
  const onToggleFocusModeRef = useRef(onToggleFocusMode);
  const onNavigateHomeRef = useRef(onNavigateHome);
  const onOpenPanelRef = useRef(onOpenPanel);

  useEffect(() => {
    setActiveTabRef.current = setActiveTab;
  }, [setActiveTab]);

  useEffect(() => {
    shouldShowTasksTabRef.current = shouldShowTasksTab;
  }, [shouldShowTasksTab]);

  useEffect(() => {
    onToggleFocusModeRef.current = onToggleFocusMode;
  }, [onToggleFocusMode]);

  useEffect(() => {
    onNavigateHomeRef.current = onNavigateHome;
  }, [onNavigateHome]);

  useEffect(() => {
    onOpenPanelRef.current = onOpenPanel;
  }, [onOpenPanel]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.repeat) {
        return;
      }

      // 1. Alt+1..5 Quick Switch
      const digit = getAltDigit(event);
      if (digit !== null) {
        const targetTab = getTargetTabForDigit(digit, shouldShowTasksTabRef.current);
        if (targetTab) {
          if (isModalOpen()) {
            return;
          }

          event.preventDefault();
          onNavigateHomeRef.current?.();
          setActiveTabRef.current(targetTab);
          return;
        }
      }

      // 2. Focus Mode (Ctrl+Shift+F or Cmd+Shift+F)
      if (isFocusModeShortcut(event)) {
        if (isModalOpen()) {
          return;
        }

        event.preventDefault();
        onToggleFocusModeRef.current();
        return;
      }

      // 3. Panel — session picker (Ctrl+K or Cmd+K)
      const isPanelShortcut = (event.ctrlKey || event.metaKey)
        && !event.shiftKey
        && !event.altKey
        && event.key.toLowerCase() === 'k';

      if (isPanelShortcut) {
        if (isModalOpen()) {
          return;
        }

        event.preventDefault();
        onOpenPanelRef.current?.();
      }
    };

    window.addEventListener('keydown', handleKeyDown, { capture: true });
    return () => {
      window.removeEventListener('keydown', handleKeyDown, { capture: true });
    };
  }, []);
}
