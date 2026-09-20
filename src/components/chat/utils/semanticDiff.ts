import type { DiffHunk } from './messageTransforms';

/**
 * Lightweight declaration matchers for the languages the chat diffs most often.
 * They are intentionally regex-only: the goal is a human-readable label, not an
 * AST. Nested declarations also match, which is fine because the nearest one
 * before the change is the most useful label.
 */
const SYMBOL_PATTERNS: RegExp[] = [
  /^\s*(?:export\s+)?(?:default\s+)?(?:async\s+)?function\s+(\w+)/,
  /^\s*(?:export\s+)?(?:abstract\s+)?class\s+(\w+)/,
  /^\s*(?:export\s+)?(?:const|let|var)\s+(\w+)\s*=/,
  /^\s*def\s+(\w+)/,
  /^\s*func\s+(?:\([^)]*\)\s*)?(\w+)/,
];

/** Returns the declaration name a line introduces, or null when it is not one. */
const matchSymbol = (line: string): string | null => {
  for (const pattern of SYMBOL_PATTERNS) {
    const match = pattern.exec(line);
    if (match) {
      return match[1];
    }
  }
  return null;
};

/**
 * Labels every hunk with the name of the nearest top-level declaration that
 * precedes it in the OLD file. Consumers: `ToolDiffViewer` (renders the label
 * next to each hunk's revert control).
 *
 * Scanning backwards from the hunk stops at the first declaration, so a nested
 * method is reported instead of the enclosing class — which matches what a
 * reviewer looks for when deciding whether to keep a change.
 */
export const groupHunksBySymbol = (
  oldContent: string,
  hunks: DiffHunk[],
): Array<DiffHunk & { symbol: string | null }> => {
  const oldLines = oldContent.split('\n');

  return hunks.map((hunk) => {
    let symbol: string | null = null;
    // Start at the hunk's first OLD line so a change to a declaration's signature
    // labels itself, then walk back to line 0. `oldStart` is 1-based, so the
    // change line's index is `oldStart - 1` (clamped for top-of-file insertions).
    for (let index = Math.max(0, hunk.oldStart - 1); index >= 0; index -= 1) {
      const found = matchSymbol(oldLines[index] ?? '');
      if (found) {
        symbol = found;
        break;
      }
    }

    return { ...hunk, symbol };
  });
};

const IMPORT_LINE = /^\s*(?:import\b|from\s+\S+\s+import\b|#include\b|package\b|using\s|require\()/;
const COMMENT_OR_BLANK = /^\s*(?:\/\/|\/\*|\*|#|<!--|$)/;

/**
 * Approximates "the hunk sits in the top-of-file import block". `isFormattingOnlyHunk`
 * only receives a hunk (no file text), so the file's first non-import line is
 * inferred from the hunk itself: every line up to the last changed line must be
 * an import, comment or blank. Trailing context is ignored because `contextLines`
 * padding can spill into the first real statement after the imports.
 *
 * Only whitespace/blank-line churn qualifies here: the non-empty removed and
 * added lines must match as a multiset, so renaming an imported module (a real
 * change) is never swallowed by the import-block rule.
 */
const isInImportBlock = (hunk: DiffHunk): boolean => {
  const changed = hunk.lines.filter((line) => line.type !== 'context');
  if (changed.length === 0 || !changed.every((line) => IMPORT_LINE.test(line.content))) {
    return false;
  }
  const lastChangedIndex = hunk.lines.reduce(
    (last, line, index) => (line.type === 'context' ? last : index),
    -1,
  );
  const inBlock = hunk.lines
    .slice(0, lastChangedIndex + 1)
    .every((line) => IMPORT_LINE.test(line.content) || COMMENT_OR_BLANK.test(line.content));
  if (!inBlock) {
    return false;
  }

  const meaningfulRemoved = hunk.lines
    .filter((line) => line.type === 'removed')
    .map((line) => line.content.trim())
    .filter(Boolean)
    .sort();
  const meaningfulAdded = hunk.lines
    .filter((line) => line.type === 'added')
    .map((line) => line.content.trim())
    .filter(Boolean)
    .sort();
  return meaningfulRemoved.join('\u0000') === meaningfulAdded.join('\u0000');
};

/**
 * True when the hunk is pure noise a reviewer can skip:
 * - every removed/added line survives after trimming (whitespace-only edits), or
 * - the hunk only reorders/whitespace-touches lines inside the import block.
 * Consumers: `ToolDiffViewer` (formatting toggle) and `summarizeHunks`.
 */
export const isFormattingOnlyHunk = (hunk: DiffHunk): boolean => {
  const removed = hunk.lines
    .filter((line) => line.type === 'removed')
    .map((line) => line.content.trim());
  const added = hunk.lines
    .filter((line) => line.type === 'added')
    .map((line) => line.content.trim());

  if (removed.length === 0 && added.length === 0) {
    return false;
  }

  const sameMultiset =
    removed.length === added.length &&
    [...removed].sort().join('\u0000') === [...added].sort().join('\u0000');
  if (sameMultiset) {
    return true;
  }

  return isInImportBlock(hunk);
};

/**
 * Counts total vs formatting-only hunks for the toggle label. Consumers:
 * `ToolDiffViewer` (header button text / title).
 */
export const summarizeHunks = (
  hunks: DiffHunk[],
): { total: number; formattingOnly: number } => {
  let formattingOnly = 0;
  for (const hunk of hunks) {
    if (isFormattingOnlyHunk(hunk)) {
      formattingOnly += 1;
    }
  }
  return { total: hunks.length, formattingOnly };
};
