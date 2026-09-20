import { useMemo } from 'react';

export type GitDiffViewMode = 'unified' | 'split';

// Optional per-hunk staging control. When provided, a single button is rendered
// on each `@@` hunk header row. The parent decides whether it stages (`add`)
// or unstages (`remove`) a hunk; the viewer only counts hunk boundaries.
export type GitDiffHunkAction = {
  variant: 'add' | 'remove';
  title: string;
  onAction: (hunkIndex: number) => void;
};

type GitDiffViewerProps = {
  diff: string | null;
  isMobile: boolean;
  wrapText: boolean;
  // Side-by-side rendering (removed | added) is used for reviewing changes
  // before committing; unified stays the default in history views.
  viewMode?: GitDiffViewMode;
  hunkAction?: GitDiffHunkAction;
};

const PREVIEW_CHARACTER_LIMIT = 200_000;
const PREVIEW_LINE_LIMIT = 1_500;

type DiffPreview = {
  lines: string[];
  isCharacterTruncated: boolean;
  isLineTruncated: boolean;
};

function buildDiffPreview(diff: string): DiffPreview {
  const isCharacterTruncated = diff.length > PREVIEW_CHARACTER_LIMIT;
  const previewText = isCharacterTruncated ? diff.slice(0, PREVIEW_CHARACTER_LIMIT) : diff;
  const previewLines = previewText.split('\n');
  const isLineTruncated = previewLines.length > PREVIEW_LINE_LIMIT;

  return {
    lines: isLineTruncated ? previewLines.slice(0, PREVIEW_LINE_LIMIT) : previewLines,
    isCharacterTruncated,
    isLineTruncated,
  };
}

// A single row of the side-by-side view. Header rows (hunk/file markers) span
// both columns; content rows carry a left (removed/context) and right
// (added/context) cell, either of which can be empty for unpaired lines.
type SplitDiffRow = {
  kind: 'header' | 'content';
  text?: string;
  left?: { content: string; type: 'removed' | 'context' };
  right?: { content: string; type: 'added' | 'context' };
};

const SPLIT_HEADER_PREFIXES = [
  'diff ',
  'index ',
  '--- ',
  '+++ ',
  '@@',
  'new file',
  'deleted file',
  'similarity',
  'rename ',
  'Binary files',
];

function isDiffHeaderLine(line: string): boolean {
  return SPLIT_HEADER_PREFIXES.some((prefix) => line.startsWith(prefix));
}

// Converts unified diff lines into paired rows. Consecutive removed and added
// lines inside a hunk are zipped by index; context lines render on both sides.
export function buildSplitDiffRows(lines: string[]): SplitDiffRow[] {
  const rows: SplitDiffRow[] = [];
  let removed: string[] = [];
  let added: string[] = [];

  const flush = () => {
    const max = Math.max(removed.length, added.length);
    for (let index = 0; index < max; index += 1) {
      const removedLine = removed[index];
      const addedLine = added[index];
      rows.push({
        kind: 'content',
        left: removedLine !== undefined ? { content: removedLine, type: 'removed' } : undefined,
        right: addedLine !== undefined ? { content: addedLine, type: 'added' } : undefined,
      });
    }
    removed = [];
    added = [];
  };

  for (const line of lines) {
    if (isDiffHeaderLine(line)) {
      flush();
      rows.push({ kind: 'header', text: line });
      continue;
    }
    if (line.startsWith('-')) {
      removed.push(line);
      continue;
    }
    if (line.startsWith('+')) {
      added.push(line);
      continue;
    }
    flush();
    rows.push({
      kind: 'content',
      left: { content: line, type: 'context' },
      right: { content: line, type: 'context' },
    });
  }
  flush();

  return rows;
}

export function getEffectiveDiffSettings(
  isMobile: boolean,
  viewMode: GitDiffViewMode = 'unified',
  wrapText = false,
): { effectiveViewMode: GitDiffViewMode; effectiveWrapText: boolean } {
  return {
    effectiveViewMode: isMobile ? 'unified' : viewMode,
    effectiveWrapText: isMobile ? true : wrapText,
  };
}

function lineClass(type: 'removed' | 'added' | 'context'): string {
  if (type === 'added') {
    return 'bg-green-50 text-green-700 dark:bg-green-950/50 dark:text-green-300';
  }
  if (type === 'removed') {
    return 'bg-red-50 text-red-700 dark:bg-red-950/50 dark:text-red-300';
  }
  return 'text-muted-foreground/70';
}

export default function GitDiffViewer({ diff, isMobile, wrapText, viewMode = 'unified', hunkAction }: GitDiffViewerProps) {
  const { effectiveViewMode, effectiveWrapText } = getEffectiveDiffSettings(isMobile, viewMode, wrapText);

  // Render a bounded preview to keep huge commit diffs from freezing the UI thread.
  const preview = useMemo(() => buildDiffPreview(diff || ''), [diff]);
  const splitRows = useMemo(
    () => (effectiveViewMode === 'split' ? buildSplitDiffRows(preview.lines) : []),
    [preview.lines, effectiveViewMode],
  );
  // Maps the line/row index of each `@@` header to its zero-based hunk number,
  // matching the order the server-side patch builder expects.
  const unifiedHunkIndices = useMemo(() => {
    const indices = new Map<number, number>();
    let hunkIndex = 0;
    preview.lines.forEach((line, index) => {
      if (line.startsWith('@@')) {
        indices.set(index, hunkIndex);
        hunkIndex += 1;
      }
    });
    return indices;
  }, [preview.lines]);
  const splitHunkIndices = useMemo(() => {
    const indices = new Map<number, number>();
    let hunkIndex = 0;
    splitRows.forEach((row, index) => {
      if (row.kind === 'header' && row.text?.startsWith('@@')) {
        indices.set(index, hunkIndex);
        hunkIndex += 1;
      }
    });
    return indices;
  }, [splitRows]);
  const isPreviewTruncated = preview.isCharacterTruncated || preview.isLineTruncated;

  const renderHunkAction = (hunkIndex: number) => {
    if (!hunkAction) {
      return null;
    }
    const colorClasses =
      hunkAction.variant === 'add'
        ? 'border-green-500/40 text-green-700 hover:bg-green-500/10 dark:text-green-300'
        : 'border-red-500/40 text-red-700 hover:bg-red-500/10 dark:text-red-300';
    const sizeClasses = isMobile
      ? 'min-h-[36px] px-3 py-1.5 text-xs touch-manipulation inline-flex items-center justify-center'
      : 'px-1.5 py-0.5 text-[10px]';

    return (
      <button
        onClick={() => hunkAction.onAction(hunkIndex)}
        className={`ml-2 rounded border font-medium ${colorClasses} ${sizeClasses}`}
        title={hunkAction.title}
      >
        {hunkAction.variant === 'add' ? '+ Hunk' : '− Hunk'}
      </button>
    );
  };

  if (!diff) {
    return (
      <div className="p-4 text-center text-sm text-muted-foreground">
        No diff available
      </div>
    );
  }

  const renderDiffLine = (line: string, index: number) => {
    const isAddition = line.startsWith('+') && !line.startsWith('+++');
    const isDeletion = line.startsWith('-') && !line.startsWith('---');
    const isHeader = line.startsWith('@@');
    const hunkIndex = isHeader ? unifiedHunkIndices.get(index) : undefined;

    return (
      <div
        key={index}
        className={`px-3 py-0.5 font-mono text-xs ${effectiveWrapText ? 'whitespace-pre-wrap break-all' : 'overflow-x-auto whitespace-pre'
          } ${isAddition ? 'bg-green-50 text-green-700 dark:bg-green-950/50 dark:text-green-300' :
            isDeletion ? 'bg-red-50 text-red-700 dark:bg-red-950/50 dark:text-red-300' :
              isHeader ? 'flex flex-wrap items-center justify-between gap-1 bg-primary/5 text-primary' :
                'text-muted-foreground/70'
          }`}
      >
        <span>{line}</span>
        {hunkIndex !== undefined && renderHunkAction(hunkIndex)}
      </div>
    );
  };

  const renderSplitRow = (row: SplitDiffRow, index: number) => {
    if (row.kind === 'header') {
      const hunkIndex = row.text?.startsWith('@@') ? splitHunkIndices.get(index) : undefined;
      return (
        <div key={index} className="flex flex-wrap items-center justify-between gap-1 bg-primary/5 px-3 py-0.5 font-mono text-xs text-primary">
          <span>{row.text}</span>
          {hunkIndex !== undefined && renderHunkAction(hunkIndex)}
        </div>
      );
    }

    return (
      <div key={index} className="grid grid-cols-2">
        <div
          className={`overflow-x-auto whitespace-pre border-r border-border/50 px-2 py-0.5 font-mono text-xs ${row.left ? lineClass(row.left.type) : 'bg-muted/30'}`}
        >
          {row.left?.content ?? ''}
        </div>
        <div
          className={`overflow-x-auto whitespace-pre px-2 py-0.5 font-mono text-xs ${row.right ? lineClass(row.right.type) : 'bg-muted/30'}`}
        >
          {row.right?.content ?? ''}
        </div>
      </div>
    );
  };

  return (
    <div className="diff-viewer">
      {isPreviewTruncated && (
        <div className="mb-2 rounded-md border border-border bg-card px-3 py-2 text-xs text-muted-foreground">
          Large diff preview: rendering is limited to keep the tab responsive.
        </div>
      )}
      {effectiveViewMode === 'split'
        ? splitRows.map((row, index) => renderSplitRow(row, index))
        : preview.lines.map((line, index) => renderDiffLine(line, index))}
    </div>
  );
}
