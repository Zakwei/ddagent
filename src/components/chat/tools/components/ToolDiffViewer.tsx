import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { AlertTriangle, Braces, ChevronDown, Eraser, FlaskConical, X } from 'lucide-react';

import { cn } from '../../../../lib/utils';
import { api } from '../../../../utils/api';
import {
  FILE_TREE_REFRESH_EVENT,
  type FileTreeRefreshEventDetail,
} from '../../../file-tree/constants/constants';
import { calculateDiffHunks, revertHunkInContent } from '../../utils/messageTransforms';
import {
  groupHunksBySymbol,
  isFormattingOnlyHunk,
  summarizeHunks,
} from '../../utils/semanticDiff';
import { findExistingTest } from '../../utils/testFileHints';

type DiffLine = {
  type: string;
  content: string;
  lineNum: number;
};

interface ToolDiffViewerProps {
  oldContent: string;
  newContent: string;
  filePath: string;
  createDiff: (oldStr: string, newStr: string) => DiffLine[];
  /** Opens the file, optionally jumping to a 1-based line number. */
  onFileClick?: (line?: number) => void;
  badge?: string;
  badgeColor?: 'gray' | 'green';
  /**
   * DB project id of the selected project. When present (together with a
   * non-empty `oldContent`) the viewer offers per-hunk "Revert" actions that
   * write the reverted content back to disk via the File Tree API.
   */
  projectId?: string;
  /** Absolute project root, used to flag edits that fall outside the project. */
  projectRoot?: string;
  /**
   * Opens the discovered sibling test file. When omitted the nudge is rendered
   * as a non-clickable hint.
   */
  onOpenTestFile?: (testPath: string) => void;
}

type FileNode = {
  type: 'file' | 'directory';
  path: string;
  children?: FileNode[];
};

// Project file lists are large and shared by every diff rendered in the chat, so
// they are cached per project on the module rather than re-fetched per viewer.
// The TTL keeps the nudge from going stale for too long after a test is added.
const FILE_CACHE_TTL_MS = 30_000;
const projectFileCache = new Map<string, { files: Promise<string[]>; at: number }>();

const flattenFilePaths = (nodes: FileNode[], out: string[]): void => {
  for (const node of nodes) {
    if (node.type === 'file') {
      out.push(node.path);
    } else if (node.children && node.children.length > 0) {
      flattenFilePaths(node.children, out);
    }
  }
};

const loadProjectFiles = (projectId: string): Promise<string[]> => {
  const cached = projectFileCache.get(projectId);
  if (cached && Date.now() - cached.at < FILE_CACHE_TTL_MS) {
    return cached.files;
  }

  const files = (async () => {
    try {
      const response = await api.getFiles(projectId);
      if (!response.ok) {
        return [];
      }
      const data = await response.json();
      const tree: FileNode[] = Array.isArray(data) ? data : [];
      const paths: string[] = [];
      flattenFilePaths(tree, paths);
      return paths;
    } catch {
      return [];
    }
  })();

  projectFileCache.set(projectId, { files, at: Date.now() });
  return files;
};

// Hunk revert state lives on the module — keyed by project, file and the
// diff's content identity — so virtualization/unmounting does not resurrect a
// "Revert" button for a hunk the user already restored.
const revertedHunksByDiff = new Map<string, Set<number>>();

const hashDiffContent = (value: string): string => {
  let hash = 0;
  for (let i = 0; i < value.length; i += 1) {
    hash = (hash * 31 + value.charCodeAt(i)) | 0;
  }
  return `${value.length}:${hash}`;
};

const diffRevertKey = (
  projectId: string | undefined,
  filePath: string,
  oldContent: string,
  newContent: string,
): string =>
  `${projectId ?? ''}:${filePath}:${hashDiffContent(oldContent)}:${hashDiffContent(newContent)}`;

const countOccurrences = (haystack: string, needle: string): number => {
  if (!needle) {
    return 0;
  }
  let count = 0;
  let from = 0;
  for (;;) {
    const found = haystack.indexOf(needle, from);
    if (found === -1) {
      return count;
    }
    count += 1;
    from = found + 1;
  }
};

/**
 * True when `filePath` points outside `projectRoot`. Relative paths are always
 * inside; absolute paths must be prefixed by the root. `..` segments in a
 * relative path also escape the project.
 */
const isOutsideProject = (filePath: string, projectRoot: string): boolean => {
  const normalizedFile = filePath.replace(/\\/g, '/');
  const normalizedRoot = projectRoot.replace(/\\/g, '/').replace(/\/+$/, '');

  if (!normalizedFile.startsWith('/')) {
    return normalizedFile === '..' || normalizedFile.startsWith('../');
  }
  if (!normalizedRoot) {
    return false;
  }
  return normalizedFile !== normalizedRoot && !normalizedFile.startsWith(`${normalizedRoot}/`);
};

/** Directory portion of a path, for the outside-project warning tooltip. */
const parentDirectory = (filePath: string): string => {
  const normalized = filePath.replace(/\\/g, '/');
  const index = normalized.lastIndexOf('/');
  return index > 0 ? normalized.slice(0, index) : normalized;
};

/**
 * Compact diff viewer — VS Code-style.
 * Shows additions/removals per line and, for edits to existing files, exposes
 * per-hunk revert controls so an AI change can be undone without leaving chat.
 */
export const ToolDiffViewer: React.FC<ToolDiffViewerProps> = ({
  oldContent,
  newContent,
  filePath,
  createDiff,
  onFileClick,
  badge = 'Diff',
  badgeColor = 'gray',
  projectId,
  projectRoot,
  onOpenTestFile,
}) => {
  const badgeClasses = badgeColor === 'green'
    ? 'bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400'
    : 'bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400';

  const diffLines = useMemo(
    () => {
      if (oldContent === undefined || newContent === undefined) {
        return [];
      }
      return createDiff(oldContent, newContent)
    },
    [createDiff, oldContent, newContent]
  );

  // Revert is only offered against a real previous version; the Write tool
  // passes an empty `oldContent`, so a whole-file creation has nothing to
  // restore and stays read-only.
  const canRevert = Boolean(projectId) && oldContent !== undefined && oldContent !== '';

  const hunks = useMemo(
    () => (canRevert ? calculateDiffHunks(oldContent, newContent) : []),
    [canRevert, oldContent, newContent]
  );

  const semanticHunks = useMemo(() => groupHunksBySymbol(oldContent, hunks), [oldContent, hunks]);

  const [hideFormatting, setHideFormatting] = useState(false);
  const revertKey = useMemo(
    () => diffRevertKey(projectId, filePath, oldContent, newContent),
    [projectId, filePath, oldContent, newContent],
  );
  // Initial state hydrates from the module store, so a remounted viewer keeps
  // showing which hunks were already reverted.
  const [revertedAt, setRevertedAt] = useState<Record<number, true>>(() => {
    const stored = revertedHunksByDiff.get(revertKey);
    return stored ? Object.fromEntries([...stored].map((index) => [index, true])) : {};
  });
  const [revertingHunk, setRevertingHunk] = useState<number | null>(null);
  const [revertError, setRevertError] = useState<string | null>(null);
  const [existingTest, setExistingTest] = useState<string | null>(null);
  const [testHintDismissed, setTestHintDismissed] = useState(false);

  // Look up a sibling test file lazily; the nudge appears after the fetch
  // resolves and never blocks the diff from rendering.
  useEffect(() => {
    if (!projectId || testHintDismissed) {
      return;
    }
    let active = true;
    void loadProjectFiles(projectId).then((files) => {
      if (active) {
        setExistingTest(findExistingTest(filePath, files));
      }
    });
    return () => {
      active = false;
    };
  }, [filePath, projectId, testHintDismissed]);

  const handleRevertHunk = useCallback(async (hunkIndex: number) => {
    if (!projectId) {
      return;
    }
    setRevertError(null);
    setRevertingHunk(hunkIndex);

    try {
      const readResponse = await api.readFile(projectId, filePath);
      if (!readResponse.ok) {
        throw new Error(`Failed to read file: ${readResponse.status} ${readResponse.statusText}`);
      }
      const data = await readResponse.json();
      const currentContent = typeof data?.content === 'string' ? data.content : '';
      const hunk = hunks[hunkIndex];

      // Several hunks can legitimately share an identical `newBlock`. Earlier
      // hunks that were already reverted are gone from the file, so count only
      // the still-present identical blocks that precede this one.
      const occurrence = hunks
        .slice(0, hunkIndex)
        .filter((candidate, index) => !revertedAt[index] && candidate.newBlock === hunk.newBlock)
        .length;

      if (countOccurrences(currentContent, hunk.newBlock) === 0) {
        throw new Error('This change is no longer present in the file (already reverted or edited).');
      }

      const nextContent = revertHunkInContent(currentContent, hunk, occurrence);
      if (nextContent === currentContent) {
        throw new Error('Could not locate this change unambiguously in the file.');
      }

      const saveResponse = await api.saveFile(projectId, filePath, nextContent);
      if (!saveResponse.ok) {
        throw new Error(`Failed to save file: ${saveResponse.status} ${saveResponse.statusText}`);
      }

      const stored = revertedHunksByDiff.get(revertKey) ?? new Set<number>();
      stored.add(hunkIndex);
      revertedHunksByDiff.set(revertKey, stored);
      setRevertedAt((previous) => ({ ...previous, [hunkIndex]: true }));

      // The write happened outside the file tree/editor, so their cached
      // copies are stale until they refetch.
      window.dispatchEvent(
        new CustomEvent<FileTreeRefreshEventDetail>(FILE_TREE_REFRESH_EVENT, {
          detail: { projectId, path: filePath },
        }),
      );
    } catch (error) {
      setRevertError(error instanceof Error ? error.message : String(error));
    } finally {
      setRevertingHunk(null);
    }
  }, [filePath, hunks, projectId, revertedAt, revertKey]);

  const revertedCount = Object.keys(revertedAt).length;
  const outsideProject = Boolean(projectRoot) && isOutsideProject(filePath, projectRoot as string);

  // Formatting-only hunks can be hidden, but reverts and the diff view must keep
  // pointing at the ORIGINAL hunk index, so hide by filtering pairs rather than
  // re-indexing the array.
  const { formattingOnly } = summarizeHunks(hunks);
  const hasFormattingOnly = formattingOnly > 0;
  const visibleHunks = semanticHunks
    .map((hunk, index) => ({ hunk, index }))
    .filter(({ hunk }) => !(hideFormatting && isFormattingOnlyHunk(hunk)));

  // `diffLines` and the hunks are produced by the same LCS walk, so flattening
  // each hunk's changed (non-context) lines reproduces `diffLines` line for line.
  // Track the flat indices that belong to hidden formatting hunks and drop them.
  const hiddenDiffLineIndices = useMemo(() => {
    if (!hideFormatting) {
      return null;
    }
    const hidden = new Set<number>();
    let flatIndex = 0;
    for (const hunk of semanticHunks) {
      const isHidden = isFormattingOnlyHunk(hunk);
      for (const line of hunk.lines) {
        if (line.type === 'context') {
          continue;
        }
        if (isHidden) {
          hidden.add(flatIndex);
        }
        flatIndex += 1;
      }
    }
    return hidden;
  }, [hideFormatting, semanticHunks]);

  const renderedDiffLines = hiddenDiffLineIndices
    ? diffLines.filter((_, index) => !hiddenDiffLineIndices.has(index))
    : diffLines;

  const [isDiffExpanded, setIsDiffExpanded] = useState(false);
  const isLongDiff = renderedDiffLines.length > 12;
  const visibleDiffLines = isLongDiff && !isDiffExpanded
    ? renderedDiffLines.slice(0, 12)
    : renderedDiffLines;
  const remainingDiffLines = renderedDiffLines.length - 12;

  return (
    <div className="overflow-hidden rounded border border-gray-200/60 dark:border-gray-700/50">
      {/* Header */}
      <div className="flex items-center justify-between border-b border-gray-200/60 bg-gray-50/80 px-2.5 py-1 dark:border-gray-700/50 dark:bg-gray-800/40">
        <div className="flex min-w-0 items-center gap-1.5">
          {outsideProject && (
            <span
              className="flex flex-shrink-0 items-center gap-1 rounded bg-amber-100 px-1 py-px text-[10px] font-medium text-amber-700 dark:bg-amber-900/30 dark:text-amber-400"
              title={`This file is outside the selected project (${parentDirectory(filePath)})`}
            >
              <AlertTriangle className="h-3 w-3" />
              outside project
            </span>
          )}
          {onFileClick ? (
            <button
              onClick={() => onFileClick()}
              className="cursor-pointer truncate font-mono text-[11px] text-blue-600 transition-colors hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300"
            >
              {filePath}
            </button>
          ) : (
            <span className="truncate font-mono text-[11px] text-gray-600 dark:text-gray-400">
              {filePath}
            </span>
          )}
        </div>
        <div className="ml-2 flex flex-shrink-0 items-center gap-1.5">
          {hasFormattingOnly && (
            <button
              type="button"
              onClick={() => setHideFormatting((previous) => !previous)}
              aria-pressed={hideFormatting}
              title={`${formattingOnly} formatting-only hunk${formattingOnly === 1 ? '' : 's'}`}
              className={`flex items-center gap-1 rounded px-1.5 py-px text-[10px] font-medium transition-colors ${
                hideFormatting
                  ? 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400'
                  : 'bg-gray-100 text-gray-500 hover:text-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:text-gray-200'
              }`}
            >
              <Eraser className="h-3 w-3" />
              {hideFormatting ? 'Formatting: show' : 'Formatting: hide'}
            </button>
          )}
          <span className={`rounded px-1.5 py-px text-[10px] font-medium ${badgeClasses}`}>
            {revertedCount > 0 ? `${revertedCount} reverted` : badge}
          </span>
        </div>
      </div>

      {/* Test-after-edit nudge */}
      {existingTest && !testHintDismissed && (
        <div className="flex items-center gap-1.5 border-b border-sky-200/70 bg-sky-50/80 px-2.5 py-1 text-[10px] text-sky-800 dark:border-sky-900/40 dark:bg-sky-950/30 dark:text-sky-300">
          <FlaskConical className="h-3 w-3 flex-shrink-0" />
          <span className="min-w-0 truncate">
            Test found: <span className="font-mono">{existingTest}</span>
          </span>
          {onOpenTestFile && (
            <button
              type="button"
              onClick={() => onOpenTestFile(existingTest)}
              className="ml-auto flex-shrink-0 cursor-pointer rounded px-1.5 py-px font-medium text-sky-700 transition-colors hover:bg-sky-100 dark:text-sky-300 dark:hover:bg-sky-900/50"
            >
              Open
            </button>
          )}
          <button
            type="button"
            onClick={() => setTestHintDismissed(true)}
            title="Dismiss"
            className="flex-shrink-0 cursor-pointer rounded p-px text-sky-600 transition-colors hover:bg-sky-100 dark:text-sky-400 dark:hover:bg-sky-900/50"
          >
            <X className="h-3 w-3" />
          </button>
        </div>
      )}

      {/* Diff lines */}
      <div className="font-mono text-[11px] leading-[18px]">
        {visibleDiffLines.map((diffLine, i) => {
          // Added lines exist in the new file and can be jumped to; removed
          // lines have no new-file position, so they are not clickable.
          const lineTarget = diffLine.type === 'added' && diffLine.lineNum > 0
            ? diffLine.lineNum
            : undefined;
          const row = (
            <>
              <span
                className={`w-6 flex-shrink-0 select-none text-center ${
                  diffLine.type === 'removed'
                    ? 'bg-red-50 text-red-400 dark:bg-red-950/30 dark:text-red-500'
                    : 'bg-green-50 text-green-400 dark:bg-green-950/30 dark:text-green-500'
                }`}
              >
                {diffLine.type === 'removed' ? '-' : '+'}
              </span>
              <span
                className={`flex-1 whitespace-pre-wrap px-2 ${
                  diffLine.type === 'removed'
                    ? 'bg-red-50/50 text-red-800 dark:bg-red-950/20 dark:text-red-200'
                    : 'bg-green-50/50 text-green-800 dark:bg-green-950/20 dark:text-green-200'
                }`}
              >
                {diffLine.content}
              </span>
            </>
          );

          if (lineTarget && onFileClick) {
            return (
              <button
                key={i}
                type="button"
                onClick={() => onFileClick(lineTarget)}
                title={`Open ${filePath} at line ${lineTarget}`}
                className="flex w-full cursor-pointer text-left hover:brightness-95"
              >
                {row}
              </button>
            );
          }

          return (
            <div key={i} className="flex">
              {row}
            </div>
          );
        })}

        {isLongDiff && (
          <button
            type="button"
            onClick={() => setIsDiffExpanded((prev) => !prev)}
            className="flex w-full items-center justify-center gap-1.5 border-t border-gray-200/60 bg-gray-50/80 py-1.5 text-xs font-medium text-gray-600 transition-colors hover:bg-gray-100 hover:text-gray-900 dark:border-gray-700/50 dark:bg-gray-800/40 dark:text-gray-300 dark:hover:bg-gray-800"
          >
            <ChevronDown className={cn('h-3.5 w-3.5 transition-transform duration-150', isDiffExpanded && 'rotate-180')} />
            {isDiffExpanded ? 'Show less' : `Show ${remainingDiffLines} more lines`}
          </button>
        )}
      </div>

      {/* Per-hunk revert controls */}
      {canRevert && hunks.length > 0 && (
        <div className="border-t border-gray-200/60 bg-gray-50/60 px-2.5 py-1.5 dark:border-gray-700/50 dark:bg-gray-800/30">
          <div className="flex flex-wrap items-center gap-1.5">
            {visibleHunks.map(({ hunk, index }) => (
              revertedAt[index] ? (
                <span
                  key={index}
                  className="rounded px-1.5 py-px text-[10px] font-medium text-gray-400"
                >
                  hunk {index + 1} reverted
                </span>
              ) : (
                <button
                  key={index}
                  onClick={() => void handleRevertHunk(index)}
                  disabled={revertingHunk !== null}
                  title={`Revert change at line ${hunk.newStart}`}
                  className="flex items-center gap-1 rounded border border-gray-300 px-1.5 py-px text-[10px] font-medium text-gray-600 transition-colors hover:border-red-400 hover:text-red-600 disabled:cursor-not-allowed disabled:opacity-50 dark:border-gray-600 dark:text-gray-300 dark:hover:border-red-500 dark:hover:text-red-400"
                >
                  {hunk.symbol && (
                    <span className="flex items-center gap-0.5 font-normal text-gray-400">
                      <Braces className="h-3 w-3" />
                      {hunk.symbol}
                    </span>
                  )}
                  {revertingHunk === index ? 'Reverting…' : `Revert hunk ${index + 1}`}
                </button>
              )
            ))}
            {visibleHunks.length === 0 && (
              <span className="text-[10px] text-gray-400">
                All changes hidden
              </span>
            )}
          </div>
          {revertError && (
            <p className="mt-1 text-[10px] text-red-600 dark:text-red-400">{revertError}</p>
          )}
        </div>
      )}
    </div>
  );
};
