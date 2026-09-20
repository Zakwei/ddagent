import { useEffect } from 'react';
import type { RefObject } from 'react';

type UseEditorKeyboardShortcutsParams = {
  onSave: () => void;
  onClose: () => void;
  dependency: string;
  /**
   * Editor root element. The listener is document-level, so shortcuts are
   * only honored while focus is inside this container — otherwise Escape in
   * the chat would close the editor and Ctrl+S anywhere would save its file.
   */
  containerRef?: RefObject<HTMLElement | null>;
};

export const useEditorKeyboardShortcuts = ({
  onSave,
  onClose,
  dependency,
  containerRef,
}: UseEditorKeyboardShortcutsParams) => {
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      const container = containerRef?.current;
      if (container && !container.contains(document.activeElement)) {
        return;
      }

      if (event.key === 'Escape') {
        event.preventDefault();
        onClose();
        return;
      }

      if (!(event.ctrlKey || event.metaKey)) {
        return;
      }

      if (event.key.toLowerCase() === 's') {
        event.preventDefault();
        onSave();
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => {
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [dependency, onClose, onSave, containerRef]);
};
