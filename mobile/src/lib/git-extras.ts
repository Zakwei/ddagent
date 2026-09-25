/** Pure helpers for Source Control parity (split diff, commit graph, commit
 * parsing, worktree modals). No react-native imports so the Node self-check can
 * import this module directly. */

/* ------------------------------------------------------------------ split diff */

export type SplitSide = { content: string; type: 'removed' | 'added' | 'context' };
export type SplitDiffRow =
  | { kind: 'header'; text: string }
  | { kind: 'content'; text?: string; left?: SplitSide; right?: SplitSide };

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

function isHeaderLine(line: string): boolean {
  return SPLIT_HEADER_PREFIXES.some((prefix) => line.startsWith(prefix));
}

/** Pair consecutive removed/added lines side by side (web buildSplitDiffRows). */
export function buildSplitDiffRows(lines: string[]): SplitDiffRow[] {
  const rows: SplitDiffRow[] = [];
  let removed: string[] = [];
  let added: string[] = [];
  const flush = () => {
    const max = Math.max(removed.length, added.length);
    for (let i = 0; i < max; i += 1) {
      rows.push({
        kind: 'content',
        left: i < removed.length ? { content: removed[i], type: 'removed' } : undefined,
        right: i < added.length ? { content: added[i], type: 'added' } : undefined,
      });
    }
    removed = [];
    added = [];
  };
  for (const line of lines) {
    if (isHeaderLine(line)) {
      flush();
      rows.push({ kind: 'header', text: line });
    } else if (line.startsWith('-')) {
      removed.push(line);
    } else if (line.startsWith('+')) {
      added.push(line);
    } else {
      flush();
      rows.push({ kind: 'content', left: { content: line, type: 'context' }, right: { content: line, type: 'context' } });
    }
  }
  flush();
  return rows;
}

/* ------------------------------------------------------------------ commit graph */

export type GitCommitLike = { hash: string; parents?: string[] };

export type CommitGraphRow = {
  nodeLane: number;
  laneCount: number;
  hasTopContinuation: boolean;
  hasParentContinuation: boolean;
  inbound: number[];
  outbound: number[];
  passThrough: number[];
  bottomLanes: number[];
};

export const GRAPH_COLORS = [
  '#0ea5e9',
  '#a855f7',
  '#f97316',
  '#10b981',
  '#f43f5e',
  '#eab308',
  '#14b8a6',
  '#6366f1',
  '#d946ef',
  '#84cc16',
];

export function laneColor(lane: number): string {
  return GRAPH_COLORS[((lane % GRAPH_COLORS.length) + GRAPH_COLORS.length) % GRAPH_COLORS.length];
}

/** Lane assignment for a topo-ordered (children-before-parents) commit list. */
export function computeCommitGraph(commits: GitCommitLike[]): CommitGraphRow[] {
  const lanes: (string | null)[] = [];
  const takeFirstFreeLane = (): number => {
    const index = lanes.indexOf(null);
    if (index >= 0) return index;
    lanes.push(null);
    return lanes.length - 1;
  };
  return commits.map((commit) => {
    const activeBefore: number[] = [];
    for (let i = 0; i < lanes.length; i += 1) if (lanes[i] !== null) activeBefore.push(i);
    const waiting = activeBefore.filter((lane) => lanes[lane] === commit.hash);
    const hasTopContinuation = waiting.length > 0;
    const nodeLane = hasTopContinuation ? waiting[0] : takeFirstFreeLane();
    const inbound = waiting.slice(1);
    for (const lane of inbound) lanes[lane] = null;
    const parents = commit.parents ?? [];
    lanes[nodeLane] = parents[0] ?? null;
    const outbound: number[] = [];
    for (const parent of parents.slice(1)) {
      let lane = activeBefore.find((candidate) => candidate !== nodeLane && lanes[candidate] === parent);
      if (lane === undefined) {
        lane = takeFirstFreeLane();
        lanes[lane] = parent;
      }
      if (!outbound.includes(lane)) outbound.push(lane);
    }
    const reserved = new Set<number>([nodeLane, ...waiting, ...outbound]);
    const passThrough = activeBefore.filter((lane) => !reserved.has(lane));
    const bottomLanes: number[] = [];
    for (let i = 0; i < lanes.length; i += 1) if (lanes[i] !== null) bottomLanes.push(i);
    // Tighten trailing free lanes.
    while (lanes.length > 0 && lanes[lanes.length - 1] === null) lanes.pop();
    const laneCount = Math.max(lanes.length, nodeLane + 1);
    return {
      nodeLane,
      laneCount,
      hasTopContinuation,
      hasParentContinuation: lanes[nodeLane] !== null,
      inbound,
      outbound,
      passThrough,
      bottomLanes,
    };
  });
}

/* ------------------------------------------------------------------ commit files */

export type CommitFileEntry = {
  path: string;
  directory: string;
  filename: string;
  status: 'M' | 'A' | 'D';
  insertions: number;
  deletions: number;
};

export function parseCommitFilesFull(output: string | undefined): {
  files: CommitFileEntry[];
  totalFiles: number;
  totalInsertions: number;
  totalDeletions: number;
} {
  const files: CommitFileEntry[] = [];
  if (!output) return { files, totalFiles: 0, totalInsertions: 0, totalDeletions: 0 };
  const chunks = output.split(/^diff --git /m).slice(1);
  for (const chunk of chunks) {
    const header = chunk.split('\n')[0] ?? '';
    const match = header.match(/a\/(.+?) b\/(.+)$/);
    const path = match ? match[2] : header.trim();
    let status: 'M' | 'A' | 'D' = 'M';
    if (chunk.includes('new file mode')) status = 'A';
    else if (chunk.includes('deleted file mode')) status = 'D';
    let insertions = 0;
    let deletions = 0;
    for (const line of chunk.split('\n')) {
      if (line.startsWith('+++') || line.startsWith('---')) continue;
      if (line.startsWith('+')) insertions += 1;
      else if (line.startsWith('-')) deletions += 1;
    }
    const slash = path.lastIndexOf('/');
    files.push({
      path,
      directory: slash >= 0 ? path.slice(0, slash) : '',
      filename: slash >= 0 ? path.slice(slash + 1) : path,
      status,
      insertions,
      deletions,
    });
  }
  return {
    files,
    totalFiles: files.length,
    totalInsertions: files.reduce((sum, file) => sum + file.insertions, 0),
    totalDeletions: files.reduce((sum, file) => sum + file.deletions, 0),
  };
}

/** `Mon D, YYYY` — Hermes-safe (no reliance on full ICU month names). */
export function formatCommitDate(iso: string | undefined): string {
  if (!iso) return '';
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return '';
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return `${months[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}`;
}

/* ------------------------------------------------------------------ worktrees */

export function sanitizeBranchForFolder(branch: string): string {
  return branch.replace(/[/\\:*?"<>|\s]+/g, '-').replace(/\.+$/, '').replace(/^-+|-+$/g, '');
}

export function worktreeFolderPreview(repositoryRoot: string, branch: string): string {
  const name = repositoryRoot.split('/').filter(Boolean).pop() ?? 'repo';
  return `${name}-worktrees/${sanitizeBranchForFolder(branch)}`;
}

export function mergeMessage(branch: string, squash: boolean): string {
  return `${squash ? 'Squash merge' : 'Merge'} branch '${branch}'`;
}

/** Config validation for the worktree scripts modal; '' clears an override. */
export function validateWorktreeConfig(setup: string, run: string, runPort: string): { ok: boolean; runPort: number | null } {
  const trimmed = runPort.trim();
  if (!trimmed) return { ok: true, runPort: null };
  const port = Number(trimmed);
  if (!Number.isInteger(port) || port < 1 || port > 65535) return { ok: false, runPort: null };
  return { ok: true, runPort: port };
}
