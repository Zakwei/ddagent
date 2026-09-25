/**
 * Pure resolution of chat keyboard shortcuts (web `useKeyboardShortcuts.ts` +
 * the Ctrl+Shift+F handler in `ChatMessagesPane.tsx`).
 *
 * React Native's `onKeyPress` only reliably reports the key name for hardware
 * keyboards and exposes no modifier flags, so callers pass whatever modifier
 * info they have (defaulting to false). The resolver stays pure so the mapping
 * is unit-testable independently of the platform limitation.
 */
export type ChatShortcut = 'abort' | 'focus-search' | 'close-search';

export interface ChatShortcutInput {
  key: string;
  ctrlKey?: boolean;
  metaKey?: boolean;
  shiftKey?: boolean;
  /** A provider run is in progress and can be interrupted. */
  running?: boolean;
  /** The transcript search bar is currently mounted/focused. */
  searchOpen?: boolean;
  /** A menu/dropdown currently owns the key (mention/slash). */
  menuOpen?: boolean;
}

export function resolveChatShortcut(input: ChatShortcutInput): ChatShortcut | null {
  const { key, ctrlKey, metaKey, shiftKey, running, searchOpen, menuOpen } = input;
  if (menuOpen) return null;

  if (key === 'Escape') {
    if (searchOpen) return 'close-search';
    if (running) return 'abort';
    return null;
  }

  if ((ctrlKey || metaKey) && shiftKey && key.toLowerCase() === 'f') {
    return 'focus-search';
  }

  return null;
}
