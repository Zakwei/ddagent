export type ChangedFile = {
  path: string;
  edits: number;
  subagent: boolean;
};

const EMPTY_CHANGED: ChangedFile[] = [];

/**
 * Normalize the `/providers/sessions/:id/changed-files` payload into the
 * `{path, edits, subagent}` shape the review list renders. Accepts bare path
 * strings (older contract) and the current object form.
 */
export function parseChangedFiles(payload: unknown): ChangedFile[] {
  const raw =
    (payload as any)?.data?.files ??
    (payload as any)?.files;
  if (!Array.isArray(raw)) return EMPTY_CHANGED;
  return raw
    .map((entry: any): ChangedFile | null => {
      if (typeof entry === 'string') {
        return entry ? { path: entry, edits: 1, subagent: false } : null;
      }
      if (!entry || typeof entry !== 'object') return null;
      const path = entry.path ?? entry.file ?? entry.filePath;
      if (typeof path !== 'string' || !path) return null;
      const editsValue = entry.edits ?? entry.editCount ?? entry.count;
      const edits = typeof editsValue === 'number' && Number.isFinite(editsValue) && editsValue > 0
        ? Math.floor(editsValue)
        : 1;
      return {
        path,
        edits,
        subagent: Boolean(entry.subagent ?? entry.isSubagent ?? false),
      };
    })
    .filter((f): f is ChangedFile => f !== null);
}

export function splitReviewPath(filePath: string): { basename: string; dirname: string } {
  const normalized = filePath.replace(/\\/g, '/');
  const slashIndex = normalized.lastIndexOf('/');
  if (slashIndex < 0) return { basename: normalized, dirname: '' };
  return {
    basename: normalized.slice(slashIndex + 1),
    dirname: normalized.slice(0, slashIndex),
  };
}

export function formatTokenEstimate(value: number): string {
  if (!Number.isFinite(value) || value <= 0) return '';
  if (value >= 1000) return `~${(value / 1000).toFixed(1)}K tokens`;
  return `~${Math.round(value)} tokens`;
}

/** Rough token estimate for a file body: ~4 chars per token (mirrors web). */
export function estimateTokensFromContent(content: string): number {
  if (!content) return 0;
  return Math.ceil(content.length / 4);
}
