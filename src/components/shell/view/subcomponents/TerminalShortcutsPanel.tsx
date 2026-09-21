import { type MutableRefObject, useCallback, useEffect, useRef, useState } from 'react';
import {
  Clipboard,
  ArrowDownToLine,
  ArrowUp,
  ArrowDown,
  ArrowLeft,
  ArrowRight,
} from 'lucide-react';
import { useTranslation } from 'react-i18next';
import type { Terminal } from '@xterm/xterm';

import { sendSocketMessage } from '../../utils/socket';

type Shortcut =
  | { type: 'key'; id: string; label: string; sequence: string }
  | { type: 'modifier'; id: string; label: string; modifier: 'ctrl' | 'alt' }
  | { type: 'arrow'; id: string; sequence: string; icon: 'up' | 'down' | 'left' | 'right' };

const MOBILE_KEYS: Shortcut[] = [
  { type: 'key', id: 'esc', label: 'Esc', sequence: '\x1b' },
  { type: 'key', id: 'tab', label: 'Tab', sequence: '\t' },
  { type: 'key', id: 'shift-tab', label: '\u21e7Tab', sequence: '\x1b[Z' },
  { type: 'modifier', id: 'ctrl', label: 'CTRL', modifier: 'ctrl' },
  { type: 'modifier', id: 'alt', label: 'ALT', modifier: 'alt' },
  { type: 'arrow', id: 'arrow-up', sequence: '\x1b[A', icon: 'up' },
  { type: 'arrow', id: 'arrow-down', sequence: '\x1b[B', icon: 'down' },
  { type: 'arrow', id: 'arrow-left', sequence: '\x1b[D', icon: 'left' },
  { type: 'arrow', id: 'arrow-right', sequence: '\x1b[C', icon: 'right' },
  { type: 'key', id: 'ctrl-c', label: 'Ctrl+C', sequence: '\x03' },
];

const ARROW_ICONS = {
  up: ArrowUp,
  down: ArrowDown,
  left: ArrowLeft,
  right: ArrowRight,
} as const;

type TerminalShortcutsPanelProps = {
  wsRef: MutableRefObject<WebSocket | null>;
  terminalRef: MutableRefObject<Terminal | null>;
  isConnected: boolean;
  bottomOffset?: string;
};

const preventFocusSteal = (e: React.PointerEvent) => e.preventDefault();

// 44px min width/height keeps every key inside the Apple HIG / WCAG 2.5.5
// touch target range; the overflow then scrolls instead of clipping keys.
const KEY_BTN =
  'flex min-h-[44px] min-w-[44px] shrink-0 touch-manipulation items-center justify-center rounded-md border border-gray-600 bg-gray-700 px-2.5 py-1.5 text-xs font-medium text-gray-100 transition-colors select-none active:border-blue-600 active:bg-blue-600 active:text-white disabled:cursor-not-allowed disabled:opacity-40';
const KEY_BTN_ACTIVE =
  'flex min-h-[44px] min-w-[44px] shrink-0 touch-manipulation items-center justify-center rounded-md border border-blue-500 bg-blue-600 px-2.5 py-1.5 text-xs font-medium text-white transition-colors select-none disabled:cursor-not-allowed disabled:opacity-40';
const KILL_BTN =
  'flex min-h-[44px] min-w-[44px] shrink-0 touch-manipulation items-center justify-center rounded-md border border-rose-600/80 bg-rose-700/80 px-2.5 py-1.5 text-xs font-medium text-rose-100 transition-colors select-none active:bg-rose-600 active:text-white disabled:cursor-not-allowed disabled:opacity-40';
const ICON_BTN =
  'flex min-h-[44px] min-w-[44px] shrink-0 touch-manipulation items-center justify-center rounded-md border border-gray-600 bg-gray-700 p-1.5 text-gray-100 transition-colors select-none active:border-blue-600 active:bg-blue-600 active:text-white disabled:cursor-not-allowed disabled:opacity-40';

export default function TerminalShortcutsPanel({
  wsRef,
  terminalRef,
  isConnected,
  bottomOffset = 'bottom-0',
}: TerminalShortcutsPanelProps) {
  const { t } = useTranslation('settings');
  const [ctrlActive, setCtrlActive] = useState(false);
  const [altActive, setAltActive] = useState(false);
  const scrollRef = useRef<HTMLDivElement | null>(null);
  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  // Edge fades are the scroll cue: they only appear while keys remain hidden
  // off that side of the strip, so the clipped-key look reads as scrollable.
  const updateScrollCues = useCallback(() => {
    const el = scrollRef.current;
    if (!el) return;
    setCanScrollLeft(el.scrollLeft > 1);
    setCanScrollRight(el.scrollLeft + el.clientWidth < el.scrollWidth - 1);
  }, []);

  useEffect(() => {
    const el = scrollRef.current;
    updateScrollCues();
    if (!el || typeof ResizeObserver === 'undefined') return;
    const observer = new ResizeObserver(updateScrollCues);
    observer.observe(el);
    return () => observer.disconnect();
  }, [updateScrollCues]);

  const sendInput = useCallback(
    (data: string) => {
      sendSocketMessage(wsRef.current, { type: 'input', data });
    },
    [wsRef],
  );

  const scrollToBottom = useCallback(() => {
    terminalRef.current?.scrollToBottom();
  }, [terminalRef]);

  const pasteFromClipboard = useCallback(async () => {
    if (typeof navigator === 'undefined' || !navigator.clipboard?.readText) {
      return;
    }

    try {
      const text = await navigator.clipboard.readText();
      if (text.length > 0) {
        sendInput(text);
      }
    } catch {
      // Ignore clipboard permission errors.
    }
  }, [sendInput]);

  const handleKeyPress = useCallback(
    (seq: string) => {
      let finalSeq = seq;
      if (ctrlActive && seq.length === 1) {
        const code = seq.toLowerCase().charCodeAt(0);
        if (code >= 97 && code <= 122) {
          finalSeq = String.fromCharCode(code - 96);
        }
        setCtrlActive(false);
      }
      if (altActive && seq.length === 1) {
        finalSeq = '\x1b' + finalSeq;
        setAltActive(false);
      }
      sendInput(finalSeq);
    },
    [ctrlActive, altActive, sendInput],
  );

  return (
    <div className={`pointer-events-none fixed inset-x-0 ${bottomOffset} z-20 px-2 md:hidden`}>
      <div
        ref={scrollRef}
        onScroll={updateScrollCues}
        className="scrollbar-hide pointer-events-auto flex items-center gap-1 overflow-x-auto overscroll-x-contain rounded-lg border border-gray-700/80 bg-gray-900/95 px-1.5 py-1.5 shadow-lg backdrop-blur-sm [-webkit-overflow-scrolling:touch]"
      >
        <button
          type="button"
          onPointerDown={preventFocusSteal}
          onClick={() => {
            void pasteFromClipboard();
          }}
          disabled={!isConnected}
          className={ICON_BTN}
          title={t('terminalShortcuts.paste', { defaultValue: 'Paste' })}
          aria-label={t('terminalShortcuts.paste', { defaultValue: 'Paste' })}
        >
          <Clipboard className="h-4 w-4" />
        </button>

        {MOBILE_KEYS.map((key) => {
          if (key.type === 'modifier') {
            const isActive = key.modifier === 'ctrl' ? ctrlActive : altActive;
            const toggle =
              key.modifier === 'ctrl'
                ? () => setCtrlActive((v) => !v)
                : () => setAltActive((v) => !v);
            return (
              <button
                type="button"
                key={key.id}
                onPointerDown={preventFocusSteal}
                onClick={toggle}
                disabled={!isConnected}
                className={isActive ? KEY_BTN_ACTIVE : KEY_BTN}
              >
                {key.label}
              </button>
            );
          }

          if (key.type === 'arrow') {
            const Icon = ARROW_ICONS[key.icon];
            return (
              <button
                type="button"
                key={key.id}
                onPointerDown={preventFocusSteal}
                onClick={() => sendInput(key.sequence)}
                disabled={!isConnected}
                className={ICON_BTN}
              >
                <Icon className="h-4 w-4" />
              </button>
            );
          }

          return (
            <button
              type="button"
              key={key.id}
              onPointerDown={preventFocusSteal}
              onClick={() => handleKeyPress(key.sequence)}
              disabled={!isConnected}
              className={key.id === 'ctrl-c' ? KILL_BTN : KEY_BTN}
              title={key.id === 'ctrl-c' ? t('terminalShortcuts.killTitle', { defaultValue: 'Kill running process (Ctrl+C)' }) : undefined}
              aria-label={key.id === 'ctrl-c' ? t('terminalShortcuts.killTitle', { defaultValue: 'Kill running process (Ctrl+C)' }) : undefined}
            >
              {key.label}
            </button>
          );
        })}

        <button
          type="button"
          onPointerDown={preventFocusSteal}
          onClick={scrollToBottom}
          disabled={!isConnected}
          className={ICON_BTN}
          title={t('terminalShortcuts.scrollDown')}
          aria-label={t('terminalShortcuts.scrollDown')}
        >
          <ArrowDownToLine className="h-4 w-4" />
        </button>
      </div>

      {canScrollLeft && (
        <div
          aria-hidden="true"
          className="absolute inset-y-0 left-2 w-6 rounded-l-lg bg-gradient-to-r from-gray-900 to-transparent"
        />
      )}
      {canScrollRight && (
        <div
          aria-hidden="true"
          className="absolute inset-y-0 right-2 w-6 rounded-r-lg bg-gradient-to-l from-gray-900 to-transparent"
        />
      )}
    </div>
  );
}
