import { FileText, Pin, X } from 'lucide-react';

import { cn } from '../../../../lib/utils';

type PinnedFilesBarProps = {
  files: string[];
  tokenEstimate?: number;
  onUnpin: (path: string) => void;
  onFileOpen?: (path: string) => void;
};

const formatTokenEstimate = (value: number) => {
  if (value >= 1000) {
    return `~${(value / 1000).toFixed(1)}K tokens`;
  }
  return `~${value} tokens`;
};

export default function PinnedFilesBar({ files, tokenEstimate, onUnpin, onFileOpen }: PinnedFilesBarProps) {
  if (files.length === 0) {
    return null;
  }

  return (
    <div className="rounded-lg border border-border/60 bg-muted/40 px-2 py-1.5 text-xs text-muted-foreground">
      <div className="flex items-center gap-2">
        <span className="flex shrink-0 items-center gap-1 font-medium text-muted-foreground">
          <Pin className="h-3 w-3" aria-hidden="true" />
          Pinned
        </span>
        <div className="flex min-w-0 flex-1 flex-wrap items-center gap-1.5">
          {files.map((path) => (
            <span
              key={path}
              className="group flex min-w-0 max-w-full items-center gap-1 rounded-md border border-border/60 bg-card/70 py-0.5 pl-1.5 pr-0.5"
            >
              <button
                type="button"
                onClick={() => onFileOpen?.(path)}
                disabled={!onFileOpen}
                title={path}
                className={cn(
                  'flex min-w-0 items-center gap-1 truncate text-left text-xs',
                  onFileOpen ? 'cursor-pointer hover:text-foreground' : 'cursor-default',
                )}
              >
                <FileText className="h-3 w-3 shrink-0" aria-hidden="true" />
                <span className="truncate">{path}</span>
              </button>
              <button
                type="button"
                onClick={() => onUnpin(path)}
                title="Unpin file"
                aria-label={`Unpin ${path}`}
                className="flex shrink-0 items-center justify-center rounded p-0.5 transition-colors hover:bg-muted hover:text-foreground"
              >
                <X className="h-3 w-3" aria-hidden="true" />
              </button>
            </span>
          ))}
        </div>
        {typeof tokenEstimate === 'number' && tokenEstimate > 0 && (
          <span className="shrink-0 tabular-nums text-muted-foreground/80">
            {formatTokenEstimate(tokenEstimate)}
          </span>
        )}
      </div>
    </div>
  );
}
