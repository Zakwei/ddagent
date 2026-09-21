import { useCallback, useEffect, useState } from 'react';
import { Loader2, RefreshCw, X } from 'lucide-react';

import { api } from '../../../../utils/api';

type ChangedFile = {
  path: string;
  edits: number;
  subagent: boolean;
};

type ReviewFilesPanelProps = {
  sessionId?: string | null;
  onFileOpen?: (filePath: string, diffInfo?: unknown, line?: number) => void;
  onClose: () => void;
};

function splitPath(filePath: string): { basename: string; dirname: string } {
  const normalized = filePath.replace(/\\/g, '/');
  const slashIndex = normalized.lastIndexOf('/');
  if (slashIndex < 0) {
    return { basename: normalized, dirname: '' };
  }
  return {
    basename: normalized.slice(slashIndex + 1),
    dirname: normalized.slice(0, slashIndex),
  };
}

export default function ReviewFilesPanel({ sessionId, onFileOpen, onClose }: ReviewFilesPanelProps) {
  const [files, setFiles] = useState<ChangedFile[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [loadError, setLoadError] = useState(false);

  const load = useCallback(() => {
    if (!sessionId) return;

    let cancelled = false;
    setIsLoading(true);
    setLoadError(false);

    api
      .sessionChangedFiles(sessionId)
      .then(async (res: Response) => {
        if (cancelled) return;
        if (!res.ok) {
          // 404 = unknown session → empty list per contract; anything else is a
          // real failure worth surfacing.
          setFiles([]);
          if (res.status !== 404) {
            setLoadError(true);
          }
          return;
        }
        const json = await res.json();
        if (cancelled) return;
        const list = json?.data?.files;
        setFiles(Array.isArray(list) ? list : []);
      })
      .catch(() => {
        if (cancelled) return;
        setFiles([]);
        setLoadError(true);
      })
      .finally(() => {
        if (!cancelled) {
          setIsLoading(false);
        }
      });

    return () => {
      cancelled = true;
    };
  }, [sessionId]);

  useEffect(() => load(), [load]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onClose]);

  const handleSelectFile = (file: ChangedFile) => {
    onFileOpen?.(file.path);
    onClose();
  };

  return (
    <div className="overflow-hidden rounded-lg border border-border/60 bg-card/60">
      <div className="flex items-center gap-2 border-b border-border/60 px-3 py-2">
        <span className="text-xs font-medium text-foreground">
          Changed files{!isLoading && files.length > 0 ? ` (${files.length})` : ''}
        </span>
        <div className="ml-auto flex items-center gap-1">
          <button
            type="button"
            onClick={load}
            disabled={isLoading}
            aria-label="Refresh changed files"
            title="Refresh"
            className="rounded p-1 text-muted-foreground transition-colors hover:text-foreground disabled:opacity-40"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${isLoading ? 'animate-spin' : ''}`} aria-hidden />
          </button>
          <button
            type="button"
            onClick={onClose}
            aria-label="Back to chat"
            title="Back to chat"
            className="rounded p-1 text-muted-foreground transition-colors hover:text-foreground"
          >
            <X className="h-3.5 w-3.5" aria-hidden />
          </button>
        </div>
      </div>

      {isLoading && files.length === 0 ? (
        <div className="flex items-center justify-center gap-2 px-3 py-6 text-xs text-muted-foreground">
          <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
          Loading…
        </div>
      ) : loadError ? (
        <div className="px-3 py-6 text-center text-xs text-muted-foreground">
          Failed to load changes
        </div>
      ) : files.length === 0 ? (
        <div className="px-3 py-6 text-center text-xs text-muted-foreground">
          No file changes
        </div>
      ) : (
        <div className={isLoading ? 'opacity-60' : ''}>
          {files.map((file) => {
            const { basename, dirname } = splitPath(file.path);
            return (
              <button
                key={file.path}
                type="button"
                onClick={() => handleSelectFile(file)}
                className="flex w-full items-center gap-2 px-3 py-1.5 text-left transition-colors hover:bg-muted/60"
              >
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-xs font-medium text-foreground">
                    {basename}
                  </span>
                  {dirname && (
                    <span className="block truncate text-[10px] text-muted-foreground">
                      {dirname}
                    </span>
                  )}
                </span>
                <span className="flex shrink-0 items-center gap-1">
                  {file.subagent && (
                    <span className="rounded bg-muted px-1 text-[9px] text-muted-foreground">
                      subagent
                    </span>
                  )}
                  {file.edits > 1 && (
                    <span className="text-[10px] text-muted-foreground">x{file.edits}</span>
                  )}
                </span>
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}
