import { useCallback, useEffect, useRef, useState } from 'react';
import type { MutableRefObject, RefObject } from 'react';
import { ClipboardAddon, type IClipboardProvider } from '@xterm/addon-clipboard';
import { FitAddon } from '@xterm/addon-fit';
import { WebLinksAddon } from '@xterm/addon-web-links';
import { WebglAddon } from '@xterm/addon-webgl';
import { Terminal, type ILink } from '@xterm/xterm';

import type { Project } from '../../../types/app';
import { copyTextToClipboard } from '../../../utils/clipboard';
import { openInAppBrowser } from '../../../utils/inAppBrowser';
import {
  TERMINAL_INIT_DELAY_MS,
  TERMINAL_OPTIONS,
  TERMINAL_RESIZE_DELAY_MS,
} from '../constants/constants';
import {
  installMobileTerminalSelection,
  type MobileTerminalSelectionManager,
} from '../utils/mobileTerminalSelection';
import { sendSocketMessage } from '../utils/socket';
import { ensureXtermFocusStyles } from '../utils/terminalStyles';

// CLIs running inside the pty (e.g. `claude auth login`'s "press c to copy"
// device-flow prompt) write to the clipboard via an OSC 52 escape sequence,
// not a browser event — xterm.js ignores OSC 52 unless a clipboard addon is
// loaded. Routes writes through the same fallback-aware helper the terminal's
// own selection-copy shortcut uses, since `navigator.clipboard` is often
// unavailable on self-hosted, non-HTTPS deployments.
// `ClipboardSelectionType.SYSTEM` is `'c'` (vs. `'p'` for the X11 primary
// selection) — compared as a literal since the addon ships it as a const
// enum, which isolatedModules builds (esbuild/Vite) can't import as a value.
const oscClipboardProvider: IClipboardProvider = {
  readText: async (selection) => {
    if (selection !== 'c') {
      return '';
    }
    try {
      return (await navigator.clipboard?.readText?.()) || '';
    } catch {
      return '';
    }
  },
  writeText: async (selection, text) => {
    if (selection !== 'c') {
      return;
    }
    await copyTextToClipboard(text);
  },
};

// The addon's published typings declare a single `(provider?)` constructor
// param, but the shipped runtime actually takes `(base64?, provider?)` — see
// node_modules/@xterm/addon-clipboard/lib/addon-clipboard.js. Cast to call it
// the way it's really implemented.
const ClipboardAddonCtor = ClipboardAddon as unknown as new (
  base64?: unknown,
  provider?: IClipboardProvider,
) => ClipboardAddon;

type UseShellTerminalOptions = {
  terminalContainerRef: RefObject<HTMLDivElement>;
  terminalRef: MutableRefObject<Terminal | null>;
  fitAddonRef: MutableRefObject<FitAddon | null>;
  wsRef: MutableRefObject<WebSocket | null>;
  selectedProject: Project | null | undefined;
  minimal: boolean;
  isRestarting: boolean;
  closeSocket: () => void;
  onFileOpen?: ((path: string, line?: number) => void) | null;
};

type UseShellTerminalResult = {
  isInitialized: boolean;
  clearTerminalScreen: () => void;
  disposeTerminal: () => void;
};

export function useShellTerminal({
  terminalContainerRef,
  terminalRef,
  fitAddonRef,
  wsRef,
  selectedProject,
  minimal,
  isRestarting,
  closeSocket,
  onFileOpen,
}: UseShellTerminalOptions): UseShellTerminalResult {
  const [isInitialized, setIsInitialized] = useState(false);
  const resizeTimeoutRef = useRef<number | null>(null);
  const mobileSelectionRef = useRef<MobileTerminalSelectionManager | null>(null);
  const activeTooltipRef = useRef<HTMLDivElement | null>(null);
  const onFileOpenRef = useRef(onFileOpen);

  useEffect(() => {
    onFileOpenRef.current = onFileOpen;
  }, [onFileOpen]);

  const hideTooltip = useCallback(() => {
    if (activeTooltipRef.current) {
      activeTooltipRef.current.remove();
      activeTooltipRef.current = null;
    }
  }, []);
  const selectedProjectKey = selectedProject?.fullPath || selectedProject?.path || '';
  const hasSelectedProject = Boolean(selectedProject);

  useEffect(() => {
    ensureXtermFocusStyles();
  }, []);

  const clearTerminalScreen = useCallback(() => {
    if (!terminalRef.current) {
      return;
    }

    terminalRef.current.clear();
    terminalRef.current.write('\x1b[2J\x1b[H');
  }, [terminalRef]);

  const disposeTerminal = useCallback(() => {
    hideTooltip();
    if (mobileSelectionRef.current) {
      mobileSelectionRef.current.dispose();
      mobileSelectionRef.current = null;
    }

    if (terminalRef.current) {
      terminalRef.current.dispose();
      terminalRef.current = null;
    }

    fitAddonRef.current = null;
    setIsInitialized(false);
  }, [fitAddonRef, hideTooltip, terminalRef]);

  useEffect(() => {
    const terminalContainer = terminalContainerRef.current;
    if (!terminalContainer || !hasSelectedProject || isRestarting || terminalRef.current) {
      return;
    }

    const nextTerminal = new Terminal(TERMINAL_OPTIONS);
    terminalRef.current = nextTerminal;

    const nextFitAddon = new FitAddon();
    fitAddonRef.current = nextFitAddon;
    nextTerminal.loadAddon(nextFitAddon);

    nextTerminal.loadAddon(new ClipboardAddonCtor(undefined, oscClipboardProvider));

    // Avoid wrapped partial links in compact login flows.
    if (!minimal) {
      nextTerminal.loadAddon(new WebLinksAddon());
    }

    const showTooltip = (text: string, x: number, y: number) => {
      hideTooltip();
      const el = document.createElement('div');
      el.className = 'xterm-hover';
      el.textContent = text;
      Object.assign(el.style, {
        position: 'fixed',
        left: `${x + 10}px`,
        top: `${y + 12}px`,
        zIndex: '99999',
        backgroundColor: '#1e293b',
        color: '#f8fafc',
        padding: '3px 8px',
        borderRadius: '4px',
        fontSize: '12px',
        fontFamily: 'sans-serif',
        pointerEvents: 'none',
        boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.3), 0 2px 4px -2px rgba(0, 0, 0, 0.3)',
        border: '1px solid #334155',
        whiteSpace: 'nowrap',
      });
      document.body.appendChild(el);
      activeTooltipRef.current = el;
    };

    const FILE_PATH_REGEX =
      /(?:^|[\s"'`(\[])(\/?[a-zA-Z0-9_.-]+(?:\/[a-zA-Z0-9_.-]+)+\.[a-zA-Z0-9]+)(?::(\d+))?(?::(\d+))?/g;
    const URL_REGEX = /https?:\/\/[^\s"'<>()\[\]]+/g;

    nextTerminal.registerLinkProvider({
      provideLinks(bufferLineNumber, callback) {
        const line = nextTerminal.buffer.active.getLine(bufferLineNumber - 1);
        if (!line) {
          callback(undefined);
          return;
        }

        const lineText = line.translateToString(true);
        const links: ILink[] = [];
        const urlRanges: Array<{ start: number; end: number }> = [];
        let match: RegExpExecArray | null;

        const urlRegex = new RegExp(URL_REGEX.source, URL_REGEX.flags);
        while ((match = urlRegex.exec(lineText)) !== null) {
          const matchedUrl = match[0];
          const startIndex = match.index;
          const endIndex = startIndex + matchedUrl.length;
          urlRanges.push({ start: startIndex, end: endIndex });

          links.push({
            range: {
              start: { x: startIndex + 1, y: bufferLineNumber },
              end: { x: endIndex, y: bufferLineNumber },
            },
            text: matchedUrl,
            activate: () => {
              hideTooltip();
              if (!openInAppBrowser(matchedUrl)) {
                window.open(matchedUrl, '_blank', 'noopener,noreferrer');
              }
            },
            hover: (event: MouseEvent) => {
              showTooltip(`Open ${matchedUrl} in browser`, event.clientX, event.clientY);
            },
            leave: () => {
              hideTooltip();
            },
          });

          if (match.index === urlRegex.lastIndex) {
            urlRegex.lastIndex++;
          }
        }

        const regex = new RegExp(FILE_PATH_REGEX.source, FILE_PATH_REGEX.flags);
        while ((match = regex.exec(lineText)) !== null) {
          const fullMatch = match[0];
          const cleanPath = match[1];
          const pathOffset = fullMatch.indexOf(cleanPath);
          const startIndex = match.index + pathOffset;
          const matchedText = fullMatch.slice(pathOffset);
          const endIndex = startIndex + matchedText.length;
          const overlapsUrl = urlRanges.some((range) => startIndex < range.end && endIndex > range.start);
          const parsedLineNumber = match[2] ? parseInt(match[2], 10) : undefined;
          const tooltipText = parsedLineNumber
            ? `Open ${cleanPath}:${parsedLineNumber} in editor`
            : `Open ${cleanPath} in editor`;

          if (!overlapsUrl) {
            links.push({
              range: {
                start: { x: startIndex + 1, y: bufferLineNumber },
                end: { x: endIndex, y: bufferLineNumber },
              },
              text: matchedText,
              activate: () => {
                hideTooltip();
                onFileOpenRef.current?.(cleanPath, parsedLineNumber);
              },
              hover: (event: MouseEvent) => {
                showTooltip(tooltipText, event.clientX, event.clientY);
              },
              leave: () => {
                hideTooltip();
              },
            });
          }

          if (match.index === regex.lastIndex) {
            regex.lastIndex++;
          }
        }

        callback(links.length > 0 ? links : undefined);
      },
    });

    terminalContainer.addEventListener('mouseleave', hideTooltip);

    try {
      nextTerminal.loadAddon(new WebglAddon());
    } catch {
      console.warn('[Shell] WebGL renderer unavailable, using Canvas fallback');
    }

    nextTerminal.open(terminalContainer);
    mobileSelectionRef.current = installMobileTerminalSelection(
      nextTerminal,
      terminalContainer,
      {
        onFontSizeChange: (fontSize) => {
          nextTerminal.options.fontSize = fontSize;

          const currentFitAddon = fitAddonRef.current;
          if (currentFitAddon) {
            currentFitAddon.fit();
            sendSocketMessage(wsRef.current, {
              type: 'resize',
              cols: nextTerminal.cols,
              rows: nextTerminal.rows,
            });
          } else {
            nextTerminal.refresh(0, nextTerminal.rows - 1);
          }
        },
      },
    );

    const copyTerminalSelection = async () => {
      const selection = nextTerminal.getSelection();
      if (!selection) {
        return false;
      }

      return copyTextToClipboard(selection);
    };

    const handleTerminalCopy = (event: ClipboardEvent) => {
      if (!nextTerminal.hasSelection()) {
        return;
      }

      const selection = nextTerminal.getSelection();
      if (!selection) {
        return;
      }

      event.preventDefault();

      if (event.clipboardData) {
        event.clipboardData.setData('text/plain', selection);
        return;
      }

      void copyTextToClipboard(selection);
    };

    terminalContainer.addEventListener('copy', handleTerminalCopy);

    nextTerminal.attachCustomKeyEventHandler((event) => {
      if (
        event.type === 'keydown' &&
        (event.ctrlKey || event.metaKey) &&
        event.key?.toLowerCase() === 'c' &&
        nextTerminal.hasSelection()
      ) {
        event.preventDefault();
        event.stopPropagation();
        void copyTerminalSelection();
        return false;
      }

      if (
        event.type === 'keydown' &&
        (event.ctrlKey || event.metaKey) &&
        event.key?.toLowerCase() === 'v'
      ) {
        // Block native paste so data is only injected after clipboard-read resolves.
        event.preventDefault();
        event.stopPropagation();

        if (typeof navigator !== 'undefined' && navigator.clipboard?.readText) {
          navigator.clipboard
            .readText()
            .then((text) => {
              sendSocketMessage(wsRef.current, {
                type: 'input',
                data: text,
              });
            })
            .catch(() => {});
        }

        return false;
      }

      return true;
    });

    window.setTimeout(() => {
      const currentFitAddon = fitAddonRef.current;
      const currentTerminal = terminalRef.current;
      if (!currentFitAddon || !currentTerminal) {
        return;
      }

      currentFitAddon.fit();
      sendSocketMessage(wsRef.current, {
        type: 'resize',
        cols: currentTerminal.cols,
        rows: currentTerminal.rows,
      });
    }, TERMINAL_INIT_DELAY_MS);

    setIsInitialized(true);

    const dataSubscription = nextTerminal.onData((data) => {
      sendSocketMessage(wsRef.current, {
        type: 'input',
        data,
      });
    });

    const resizeObserver = new ResizeObserver(() => {
      if (resizeTimeoutRef.current !== null) {
        window.clearTimeout(resizeTimeoutRef.current);
      }

      resizeTimeoutRef.current = window.setTimeout(() => {
        const currentFitAddon = fitAddonRef.current;
        const currentTerminal = terminalRef.current;
        if (!currentFitAddon || !currentTerminal) {
          return;
        }

        currentFitAddon.fit();
        sendSocketMessage(wsRef.current, {
          type: 'resize',
          cols: currentTerminal.cols,
          rows: currentTerminal.rows,
        });
      }, TERMINAL_RESIZE_DELAY_MS);
    });

    resizeObserver.observe(terminalContainer);

    return () => {
      terminalContainer.removeEventListener('mouseleave', hideTooltip);
      hideTooltip();
      terminalContainer.removeEventListener('copy', handleTerminalCopy);
      resizeObserver.disconnect();
      if (resizeTimeoutRef.current !== null) {
        window.clearTimeout(resizeTimeoutRef.current);
        resizeTimeoutRef.current = null;
      }
      dataSubscription.dispose();
      closeSocket();
      disposeTerminal();
    };
  }, [
    closeSocket,
    disposeTerminal,
    fitAddonRef,
    hideTooltip,
    isRestarting,
    hasSelectedProject,
    minimal,
    selectedProjectKey,
    terminalContainerRef,
    terminalRef,
    wsRef,
  ]);

  return {
    isInitialized,
    clearTerminalScreen,
    disposeTerminal,
  };
}
