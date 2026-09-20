export interface DiffLine {
  type: 'added' | 'removed';
  content: string;
  lineNum: number;
}

export type DiffCalculator = (oldStr: string, newStr: string) => DiffLine[];

/**
 * A single contiguous change region between the old and new text, padded with a
 * few unchanged context lines so the region can be located uniquely inside the
 * file on disk.
 *
 * `oldBlock`/`newBlock` are the exact substrings (context included) that exist
 * in the old/new text. Replacing `newBlock` with `oldBlock` in the current file
 * reverts just this region, which is what per-hunk "reject" does.
 */
export type DiffHunk = {
  /** Line number (1-based) of the first line in `oldBlock`; 0 for a pure insertion at the top. */
  oldStart: number;
  /** Line number (1-based) of the first line in `newBlock`; 0 for a pure deletion at the top. */
  newStart: number;
  /** Old-file text for this region, including context lines. */
  oldBlock: string;
  /** New-file text for this region, including context lines. */
  newBlock: string;
  /** Per-line view of the region for rendering (context/removed/added). */
  lines: DiffHunkLine[];
};

export type DiffHunkLine = {
  type: 'context' | 'removed' | 'added';
  content: string;
};

const DEFAULT_HUNK_CONTEXT_LINES = 2;

/**
 * Builds the LCS alignment table shared by the flat diff and the hunk diff.
 * Exposed internally only; callers use `calculateDiff` / `calculateDiffHunks`.
 */
const buildLcsTable = (oldLines: string[], newLines: string[]): number[][] => {
  const lcsTable: number[][] = Array.from({ length: oldLines.length + 1 }, () =>
    new Array<number>(newLines.length + 1).fill(0),
  );
  for (let oldIndex = oldLines.length - 1; oldIndex >= 0; oldIndex -= 1) {
    for (let newIndex = newLines.length - 1; newIndex >= 0; newIndex -= 1) {
      if (oldLines[oldIndex] === newLines[newIndex]) {
        lcsTable[oldIndex][newIndex] = lcsTable[oldIndex + 1][newIndex + 1] + 1;
      } else {
        lcsTable[oldIndex][newIndex] = Math.max(
          lcsTable[oldIndex + 1][newIndex],
          lcsTable[oldIndex][newIndex + 1],
        );
      }
    }
  }
  return lcsTable;
};

export const calculateDiff = (oldStr: string, newStr: string): DiffLine[] => {
  const oldLines = oldStr.split('\n');
  const newLines = newStr.split('\n');

  // Use LCS alignment so insertions/deletions don't cascade into a full-file "changed" diff.
  const lcsTable = buildLcsTable(oldLines, newLines);

  const diffLines: DiffLine[] = [];
  let oldIndex = 0;
  let newIndex = 0;

  while (oldIndex < oldLines.length && newIndex < newLines.length) {
    const oldLine = oldLines[oldIndex];
    const newLine = newLines[newIndex];

    if (oldLine === newLine) {
      oldIndex += 1;
      newIndex += 1;
      continue;
    }

    if (lcsTable[oldIndex + 1][newIndex] >= lcsTable[oldIndex][newIndex + 1]) {
      diffLines.push({ type: 'removed', content: oldLine, lineNum: oldIndex + 1 });
      oldIndex += 1;
      continue;
    }

    diffLines.push({ type: 'added', content: newLine, lineNum: newIndex + 1 });
    newIndex += 1;
  }

  while (oldIndex < oldLines.length) {
    diffLines.push({ type: 'removed', content: oldLines[oldIndex], lineNum: oldIndex + 1 });
    oldIndex += 1;
  }

  while (newIndex < newLines.length) {
    diffLines.push({ type: 'added', content: newLines[newIndex], lineNum: newIndex + 1 });
    newIndex += 1;
  }

  return diffLines;
};

/**
 * Splits the old/new texts into hunks (contiguous change regions) padded with
 * `contextLines` unchanged lines so each hunk can be located on disk.
 *
 * The LCS table is shared with `calculateDiff`, so both views agree line for line.
 * A hunk whose only change is an insertion between two unchanged lines still
 * carries both neighbours as context, which makes `oldBlock` uniquely locatable.
 */
export const calculateDiffHunks = (
  oldStr: string,
  newStr: string,
  contextLines: number = DEFAULT_HUNK_CONTEXT_LINES,
): DiffHunk[] => {
  const oldLines = oldStr.split('\n');
  const newLines = newStr.split('\n');
  const lcsTable = buildLcsTable(oldLines, newLines);

  // First pass: walk the LCS exactly like calculateDiff and record every line
  // tagged with its origin, so change runs can be grouped with context.
  type TaggedLine = { type: 'context' | 'removed' | 'added'; content: string; oldIndex: number; newIndex: number };
  const tagged: TaggedLine[] = [];
  let oldIndex = 0;
  let newIndex = 0;

  while (oldIndex < oldLines.length && newIndex < newLines.length) {
    if (oldLines[oldIndex] === newLines[newIndex]) {
      tagged.push({ type: 'context', content: oldLines[oldIndex], oldIndex, newIndex });
      oldIndex += 1;
      newIndex += 1;
      continue;
    }

    if (lcsTable[oldIndex + 1][newIndex] >= lcsTable[oldIndex][newIndex + 1]) {
      tagged.push({ type: 'removed', content: oldLines[oldIndex], oldIndex, newIndex });
      oldIndex += 1;
      continue;
    }

    tagged.push({ type: 'added', content: newLines[newIndex], oldIndex, newIndex });
    newIndex += 1;
  }

  while (oldIndex < oldLines.length) {
    tagged.push({ type: 'removed', content: oldLines[oldIndex], oldIndex, newIndex });
    oldIndex += 1;
  }

  while (newIndex < newLines.length) {
    tagged.push({ type: 'added', content: newLines[newIndex], oldIndex, newIndex });
    newIndex += 1;
  }

  // Second pass: grow a window around each change run, merging runs separated by
  // no more than 2 * contextLines unchanged lines.
  const changeIndices: number[] = [];
  tagged.forEach((line, index) => {
    if (line.type !== 'context') {
      changeIndices.push(index);
    }
  });

  const hunks: DiffHunk[] = [];
  let cursor = 0;
  while (cursor < changeIndices.length) {
    const start = Math.max(0, changeIndices[cursor] - contextLines);
    let end = changeIndices[cursor] + contextLines;
    let next = cursor + 1;
    while (next < changeIndices.length && changeIndices[next] - contextLines <= end + 1) {
      end = Math.max(end, changeIndices[next] + contextLines);
      next += 1;
    }
    end = Math.min(tagged.length - 1, end);

    const window = tagged.slice(start, end + 1);
    const firstLine = window[0];
    const oldBlockLines = window
      .filter((line) => line.type !== 'added')
      .map((line) => line.content);
    const newBlockLines = window
      .filter((line) => line.type !== 'removed')
      .map((line) => line.content);

    // Pure insertion at the very top has no preceding old line; oldStart of 1
    // keeps the block-anchored revert well-defined (insert-before line 1).
    hunks.push({
      oldStart: firstLine.oldIndex + 1,
      newStart: firstLine.newIndex + 1,
      oldBlock: oldBlockLines.join('\n'),
      newBlock: newBlockLines.join('\n'),
      lines: window.map((line) => ({
        type: line.type,
        content: line.content,
        // Removed lines have no position in the new file; 0 signals "not navigable".
        newLineNumber: line.type === 'removed' ? 0 : line.newIndex + 1,
      })),
    });

    cursor = next;
  }

  return hunks;
};

/**
 * Reverts one hunk inside `currentContent` by replacing its `newBlock` with
 * `oldBlock`. The hunk's block usually appears exactly once; when it repeats,
 * the occurrence nearest `preferredOccurrence` (the hunk's index among hunks
 * still present) is used to disambiguate.
 *
 * Returns the original string unchanged when the block cannot be found, so a
 * stale or already-reverted hunk is a no-op instead of a corrupting write.
 */
export const revertHunkInContent = (
  currentContent: string,
  hunk: DiffHunk,
  occurrence = 0,
): string => {
  const matches: number[] = [];
  let searchFrom = 0;
  for (;;) {
    const found = currentContent.indexOf(hunk.newBlock, searchFrom);
    if (found === -1) {
      break;
    }
    matches.push(found);
    searchFrom = found + 1;
  }

  // No match, or fewer matches than the caller expected: refuse to guess, so a
  // stale occurrence index can never rewrite the wrong region.
  if (matches.length === 0 || occurrence >= matches.length) {
    return currentContent;
  }

  const at = matches[occurrence];
  return currentContent.slice(0, at) + hunk.oldBlock + currentContent.slice(at + hunk.newBlock.length);
};

export const createCachedDiffCalculator = (): DiffCalculator => {
  const cache = new Map<string, DiffLine[]>();

  return (oldStr: string, newStr: string) => {
    const key = JSON.stringify([oldStr, newStr]);
    const cached = cache.get(key);
    if (cached) {
      return cached;
    }

    const calculated = calculateDiff(oldStr, newStr);
    cache.set(key, calculated);
    if (cache.size > 100) {
      const firstKey = cache.keys().next().value;
      if (firstKey) {
        cache.delete(firstKey);
      }
    }
    return calculated;
  };
};
