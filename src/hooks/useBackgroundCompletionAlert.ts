import { useEffect, useRef } from 'react';

import { playChatCompletionSound } from '../utils/notificationSound';
import { triggerHapticFeedback } from '../utils/haptics';

export const DEFAULT_DONE_PREFIX = '✓ Done! ';

export interface BackgroundCompletionAlertOptions {
  processingSessions: ReadonlyMap<string, unknown> | Map<string, unknown>;
  donePrefix?: string;
  playSound?: () => Promise<void> | void;
  triggerHaptic?: () => void;
  isDocumentHidden?: () => boolean;
  onNotification?: (title: string, options?: NotificationOptions) => void;
  /** Human-readable context for a finished session ("title — project"). */
  getSessionLabel?: (sessionId: string) => string | undefined;
  /** Opens the finished session's pane when its notification is clicked. */
  onOpenSession?: (sessionId: string) => void;
}

export function prefixTitle(currentTitle: string, prefix: string = DEFAULT_DONE_PREFIX): string {
  if (currentTitle.startsWith(prefix)) {
    return currentTitle;
  }
  return `${prefix}${currentTitle}`;
}

export function resetTitle(currentTitle: string, prefix: string = DEFAULT_DONE_PREFIX): string {
  if (currentTitle.startsWith(prefix)) {
    return currentTitle.slice(prefix.length);
  }
  return currentTitle;
}

export function detectCompletedSessions(
  previousSessionIds: ReadonlySet<string>,
  currentSessionIds: ReadonlySet<string>,
): string[] {
  const completed: string[] = [];
  for (const id of previousSessionIds) {
    if (!currentSessionIds.has(id)) {
      completed.push(id);
    }
  }
  return completed;
}

// Hoisted to module scope: an inline default would be a new function every
// render, re-running the alert effect (and its title cleanup) every render.
const defaultTriggerHaptic = () => triggerHapticFeedback('completion');

/**
 * Alerts the user when a session finishes processing while the tab is hidden / in background.
 * Plays a completion sound, prefixes document.title until the user returns,
 * fires haptic feedback on mobile, and sends a Web Notification if permitted.
 */
export function useBackgroundCompletionAlert({
  processingSessions,
  donePrefix = DEFAULT_DONE_PREFIX,
  playSound = playChatCompletionSound,
  triggerHaptic = defaultTriggerHaptic,
  isDocumentHidden,
  onNotification,
  getSessionLabel,
  onOpenSession,
}: BackgroundCompletionAlertOptions): void {
  const prevSessionsRef = useRef<Set<string>>(new Set(processingSessions.keys()));
  const isFirstRenderRef = useRef<boolean>(true);

  // Reset title when the user returns to the tab
  useEffect(() => {
    if (typeof document === 'undefined') return;

    const handleReturn = () => {
      const isHidden = isDocumentHidden ? isDocumentHidden() : document.hidden;
      if (!isHidden) {
        document.title = resetTitle(document.title, donePrefix);
      }
    };

    document.addEventListener('visibilitychange', handleReturn);
    window.addEventListener('focus', handleReturn);

    return () => {
      document.removeEventListener('visibilitychange', handleReturn);
      window.removeEventListener('focus', handleReturn);
    };
  }, [donePrefix, isDocumentHidden]);

  // Strip a leftover "Done!" prefix only on unmount — never as a side effect
  // of a deps change re-running the listener effect above.
  useEffect(() => {
    return () => {
      if (typeof document !== 'undefined' && document.title.startsWith(donePrefix)) {
        document.title = resetTitle(document.title, donePrefix);
      }
    };
  }, [donePrefix]);

  // Monitor transitions from processing to idle
  useEffect(() => {
    const currentKeys = new Set(processingSessions.keys());

    if (isFirstRenderRef.current) {
      isFirstRenderRef.current = false;
      prevSessionsRef.current = currentKeys;
      return;
    }

    const completedSessionIds = detectCompletedSessions(prevSessionsRef.current, currentKeys);
    prevSessionsRef.current = currentKeys;

    if (completedSessionIds.length === 0) {
      return;
    }

    const hidden = isDocumentHidden
      ? isDocumentHidden()
      : typeof document !== 'undefined' && document.hidden;

    if (!hidden) {
      return;
    }

    // 1. Play completion sound
    try {
      void playSound();
    } catch (err) {
      console.warn('Unable to play background completion sound:', err);
    }

    // 2. Trigger completion haptics
    try {
      triggerHaptic();
    } catch {
      // Ignore
    }

    // 3. Prefix document title
    if (typeof document !== 'undefined') {
      document.title = prefixTitle(document.title, donePrefix);
    }

    // 4. Dispatch Web Notification if permitted
    const singleCompletedId = completedSessionIds.length === 1 ? completedSessionIds[0] : null;
    const sessionLabel = singleCompletedId ? getSessionLabel?.(singleCompletedId)?.trim() : undefined;
    const notificationBody = singleCompletedId
      ? sessionLabel
        ? `Session finished processing — ${sessionLabel}`
        : 'Session has finished processing.'
      : `${completedSessionIds.length} sessions have finished processing.`;

    if (onNotification) {
      onNotification('Task completed', { body: notificationBody });
    } else if (
      typeof window !== 'undefined' &&
      'Notification' in window &&
      Notification.permission === 'granted'
    ) {
      try {
        const notification = new Notification('Task completed', {
          body: notificationBody,
        });
        notification.onclick = () => {
          window.focus();
          if (singleCompletedId) {
            onOpenSession?.(singleCompletedId);
          }
        };
      } catch (err) {
        console.warn('Unable to dispatch notification:', err);
      }
    }
  }, [processingSessions, donePrefix, playSound, triggerHaptic, isDocumentHidden, onNotification, getSessionLabel, onOpenSession]);
}
