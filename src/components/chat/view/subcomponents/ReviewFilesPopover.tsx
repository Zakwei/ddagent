import { useEffect, useRef, useState } from 'react';
import { Filter, Loader2 } from 'lucide-react';

import { api } from '../../../../utils/api';

type ChangedFile = {
  path: string;
  edits: number;
  subagent: boolean;
};

type ReviewFilesPopoverProps = {
  sessionId?: string | null;
  onFileOpen?: (filePath: string, diffInfo?: unknown, line?: number) => void;
  disabled?: boolean;
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

export default function ReviewFilesPopover({
  sessionId,
  onFileOpen,
  disabled = false,
}: ReviewFilesPopoverProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [files, setFiles] = useState<ChangedFile[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [loadError, setLoadError] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const isDisabled = disabled || !sessionId;

  // Close on outside click / Escape while the popover is open.
  useEffect(() => {
    if (!isOpen) return;

    const handleMouseDown = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleMouseDown);
    document.addEventListener('keydown', handleKeyDown);
    return () => {
      document.removeEventListener('mousedown', handleMouseDown);
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [isOpen]);

  // Refetch the changed-files list every time the popover opens — the query is
  // cheap and the list changes as the session progresses.
  useEffect(() => {
    if (!isOpen || !sessionId) return;

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
  }, [isOpen, sessionId]);

  const handleSelectFile = (file: ChangedFile) => {
    onFileOpen?.(file.path);
    setIsOpen(false);
  };

  return (
    <div ref={containerRef} className="relative">
      <button
        type="button"
        onClick={() => setIsOpen((prev) => !prev)}
        disabled={isDisabled}
        aria-expanded={isOpen}
        title="Review changed files"
        className={`flex items-center gap-1 rounded px-1.5 py-0.5 text-xs transition-colors ${
          isOpen
            ? 'bg-primary/10 text-primary'
            : 'text-muted-foreground hover:text-foreground'
        } ${isDisabled ? 'cursor-not-allowed opacity-40' : ''}`}
      >
        <Filter className="h-3.5 w-3.5" aria-hidden />
        Review
      </button>

      {isOpen && (
        <div className="absolute right-0 top-full z-50 mt-1 max-h-96 w-80 overflow-y-auto rounded-lg border border-border bg-card shadow-lg">
          {isLoading ? (
            <div className="flex items-center justify-center gap-2 px-3 py-4 text-xs text-muted-foreground">
              <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />
              Loading…
            </div>
          ) : loadError ? (
            <div className="px-3 py-4 text-center text-xs text-muted-foreground">
              Failed to load changes
            </div>
          ) : files.length === 0 ? (
            <div className="px-3 py-4 text-center text-xs text-muted-foreground">
              No file changes
            </div>
          ) : (
            <div className="py-1">
              {files.map((file) => {
                const { basename, dirname } = splitPath(file.path);
                return (
                  <button
                    key={file.path}
                    type="button"
                    onClick={() => handleSelectFile(file)}
                    className="flex w-full items-center gap-2 px-3 py-1.5 text-left hover:bg-muted/60"
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
      )}
    </div>
  );
}
