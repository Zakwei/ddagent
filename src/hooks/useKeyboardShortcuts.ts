import { useEffect, useRef } from 'react';

function isModalOpen(): boolean {
  if (typeof document === 'undefined') {
    return false;
  }

  if (document.body.style.overflow === 'hidden') {
    return true;
  }

  if (
    document.querySelector('[role="dialog"][aria-modal="true"]')
    || document.querySelector('[role="alertdialog"][aria-modal="true"]')
  ) {
    return true;
  }

  const overlays = document.querySelectorAll('.fixed.inset-0.z-50');
  for (let index = 0; index < overlays.length; index += 1) {
    const element = overlays[index] as HTMLElement;
    const style = window.getComputedStyle(element);
    if (style.display === 'none' || style.visibility === 'hidden' || style.opacity === '0') {
      continue;
    }
    return true;
  }

  return false;
}

interface UseKeyboardShortcutsArgs {
  /** Whether an active provider run can be interrupted. */
  canAbortSession: boolean;
  /** Abort the currently viewed/active session. */
  onAbortSession: () => void;
  /**
   * Whether this chat pane is the active one. Every mounted pane registers a
   * global keydown listener, so without this gate Escape would abort a run in
   * a background pane.
   */
  isActive?: boolean;
}

export function useKeyboardShortcuts({
  canAbortSession,
  onAbortSession,
  isActive = true,
}: UseKeyboardShortcutsArgs) {
  const canAbortRef = useRef(canAbortSession);
  const onAbortRef = useRef(onAbortSession);
  const isActiveRef = useRef(isActive);

  useEffect(() => {
    isActiveRef.current = isActive;
  }, [isActive]);

  useEffect(() => {
    canAbortRef.current = canAbortSession;
  }, [canAbortSession]);

  useEffect(() => {
    onAbortRef.current = onAbortSession;
  }, [onAbortSession]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.repeat) {
        return;
      }

      if (event.key === 'Escape' && isActiveRef.current && canAbortRef.current && !isModalOpen()) {
        event.preventDefault();
        onAbortRef.current();
      }
    };

    document.addEventListener('keydown', handleKeyDown, { capture: true });
    return () => {
      document.removeEventListener('keydown', handleKeyDown, { capture: true });
    };
  }, []);
}
