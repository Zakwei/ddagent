import { useCallback, useEffect, useRef, useState } from 'react';
import { Check, Copy, RotateCcw, Square, X, ZoomIn, ZoomOut } from 'lucide-react';

type ShellHeaderProps = {
  isConnected: boolean;
  isInitialized: boolean;
  isRestarting: boolean;
  hasSession: boolean;
  sessionDisplayNameShort: string | null;
  onDisconnect: () => void;
  onRestart: () => void;
  onKillProcess?: () => void;
  onCopyOutput?: () => Promise<boolean>;
  onZoomIn?: () => void;
  onZoomOut?: () => void;
  fontSize?: number;
  statusNewSessionText: string;
  statusInitializingText: string;
  statusRestartingText: string;
  disconnectLabel: string;
  disconnectTitle: string;
  restartLabel: string;
  restartTitle: string;
  killLabel?: string;
  killTitle?: string;
  copyOutputLabel?: string;
  copyOutputTitle?: string;
  copiedLabel?: string;
  zoomInTitle?: string;
  zoomOutTitle?: string;
  disableRestart: boolean;
};

export default function ShellHeader({
  isConnected,
  isInitialized,
  isRestarting,
  hasSession,
  sessionDisplayNameShort,
  onDisconnect,
  onRestart,
  onKillProcess,
  onCopyOutput,
  onZoomIn,
  onZoomOut,
  fontSize,
  statusNewSessionText,
  statusInitializingText,
  statusRestartingText,
  disconnectLabel,
  disconnectTitle,
  restartLabel,
  restartTitle,
  killLabel = 'Kill (SIGINT)',
  killTitle = 'Kill running process (Ctrl+C)',
  copyOutputLabel = 'Copy output',
  copyOutputTitle = 'Copy terminal output',
  copiedLabel = 'Copied!',
  zoomInTitle = 'Zoom in',
  zoomOutTitle = 'Zoom out',
  disableRestart,
}: ShellHeaderProps) {
  const [copied, setCopied] = useState(false);
  const copyTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (copyTimerRef.current) {
        clearTimeout(copyTimerRef.current);
      }
    };
  }, []);

  const handleCopyClick = useCallback(async () => {
    if (!onCopyOutput) return;
    const success = await onCopyOutput();
    if (success) {
      setCopied(true);
      if (copyTimerRef.current) {
        clearTimeout(copyTimerRef.current);
      }
      copyTimerRef.current = setTimeout(() => {
        setCopied(false);
      }, 2000);
    }
  }, [onCopyOutput]);

  return (
    <div className="flex-shrink-0 border-b border-gray-700 bg-gray-800 px-4 py-2">
      <div className="flex items-center justify-between gap-2">
        <div className="flex min-w-0 items-center space-x-2 truncate">
          <div className={`h-2 w-2 shrink-0 rounded-full ${isConnected ? 'bg-green-500' : 'bg-red-500'}`} />

          {hasSession && sessionDisplayNameShort && (
            <span className="truncate text-xs text-blue-300">({sessionDisplayNameShort}...)</span>
          )}

          {!hasSession && <span className="truncate text-xs text-gray-400">{statusNewSessionText}</span>}

          {!isInitialized && <span className="truncate text-xs text-yellow-400">{statusInitializingText}</span>}

          {isRestarting && <span className="truncate text-xs text-blue-400">{statusRestartingText}</span>}
        </div>

        <div className="flex items-center gap-2">
          {onZoomOut && onZoomIn && (
            <div className="flex items-center gap-1">
              <button
                type="button"
                onClick={onZoomOut}
                disabled={!isInitialized || (fontSize !== undefined && fontSize <= 9)}
                className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-gray-600/80 bg-gray-700/70 text-gray-100 transition-colors hover:border-blue-400/70 hover:bg-blue-600/80 hover:text-white focus:outline-none focus:ring-2 focus:ring-blue-400/70 focus:ring-offset-2 focus:ring-offset-gray-800 disabled:cursor-not-allowed disabled:border-transparent disabled:bg-transparent disabled:text-gray-500 disabled:opacity-60"
                title={zoomOutTitle}
                aria-label={zoomOutTitle}
              >
                <ZoomOut className="h-3.5 w-3.5" aria-hidden="true" />
              </button>
              <button
                type="button"
                onClick={onZoomIn}
                disabled={!isInitialized || (fontSize !== undefined && fontSize >= 24)}
                className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-gray-600/80 bg-gray-700/70 text-gray-100 transition-colors hover:border-blue-400/70 hover:bg-blue-600/80 hover:text-white focus:outline-none focus:ring-2 focus:ring-blue-400/70 focus:ring-offset-2 focus:ring-offset-gray-800 disabled:cursor-not-allowed disabled:border-transparent disabled:bg-transparent disabled:text-gray-500 disabled:opacity-60"
                title={zoomInTitle}
                aria-label={zoomInTitle}
              >
                <ZoomIn className="h-3.5 w-3.5" aria-hidden="true" />
              </button>
            </div>
          )}

          {onCopyOutput && (
            <button
              type="button"
              onClick={handleCopyClick}
              disabled={!isInitialized}
              className="inline-flex h-8 items-center gap-1.5 rounded-md border border-gray-600/80 bg-gray-700/70 px-3 text-xs font-medium text-gray-100 transition-colors hover:border-blue-400/70 hover:bg-blue-600/80 hover:text-white focus:outline-none focus:ring-2 focus:ring-blue-400/70 focus:ring-offset-2 focus:ring-offset-gray-800 disabled:cursor-not-allowed disabled:border-transparent disabled:bg-transparent disabled:text-gray-500 disabled:opacity-60"
              title={copied ? copiedLabel : copyOutputTitle}
            >
              {copied ? (
                <Check className="h-3.5 w-3.5 text-emerald-400" aria-hidden="true" />
              ) : (
                <Copy className="h-3.5 w-3.5" aria-hidden="true" />
              )}
              <span>{copied ? copiedLabel : copyOutputLabel}</span>
            </button>
          )}

          {isConnected && onKillProcess && (
            <button
              type="button"
              onClick={onKillProcess}
              className="inline-flex h-8 items-center gap-1.5 rounded-md border border-rose-600/80 bg-rose-600 px-3 text-xs font-medium text-white transition-colors hover:border-rose-500 hover:bg-rose-700 focus:outline-none focus:ring-2 focus:ring-rose-400/70 focus:ring-offset-2 focus:ring-offset-gray-800 active:bg-rose-800"
              title={killTitle}
            >
              <Square className="h-3 w-3 fill-current" aria-hidden="true" />
              <span>{killLabel}</span>
            </button>
          )}

          <button
            type="button"
            onClick={onRestart}
            disabled={disableRestart}
            className="inline-flex h-8 items-center gap-1.5 rounded-md border border-gray-600/80 bg-gray-700/70 px-3 text-xs font-medium text-gray-100 transition-colors hover:border-blue-400/70 hover:bg-blue-600/80 hover:text-white focus:outline-none focus:ring-2 focus:ring-blue-400/70 focus:ring-offset-2 focus:ring-offset-gray-800 disabled:cursor-not-allowed disabled:border-transparent disabled:bg-transparent disabled:text-gray-500 disabled:opacity-60"
            title={restartTitle}
          >
            <RotateCcw className={`h-3.5 w-3.5 ${isRestarting ? 'animate-spin' : ''}`} aria-hidden="true" />
            <span>{restartLabel}</span>
          </button>

          {isConnected && (
            <button
              type="button"
              onClick={onDisconnect}
              className="inline-flex h-8 items-center gap-1.5 rounded-md bg-red-600 px-3 text-xs font-medium text-white transition-colors hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-400/70 focus:ring-offset-2 focus:ring-offset-gray-800"
              title={disconnectTitle}
            >
              <X className="h-3.5 w-3.5" aria-hidden="true" />
              <span>{disconnectLabel}</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
