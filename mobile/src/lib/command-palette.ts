/**
 * Pure helpers for the native command palette + global search (T29).
 *
 * Mirrors the web `src/components/command-palette/` logic without any DOM,
 * EventSource or cmdk dependency so it can run under Node in the self-check.
 */

export type PalettePage = 'actions' | 'sessions' | 'files' | 'commits' | 'branches' | 'compare';

export const PALETTE_PAGES: PalettePage[] = ['actions', 'sessions', 'files', 'commits', 'branches', 'compare'];

/** Browse mode (no query) shows at most this many rows per group. */
export const BROWSE_LIMIT = 5;

/** Session message search needs at least this many characters. */
export const SEARCH_MIN_QUERY = 2;
export const SEARCH_DEBOUNCE_MS = 250;
export const SEARCH_LIMIT = 50;

export interface SessionRow {
  id: string;
  label: string;
  provider?: string;
  projectId?: string;
  /** Filled in by the live message search when a session matches. */
  snippet?: string;
}

export interface FileRow {
  path: string;
  name: string;
}

export interface CommitRow {
  hash: string;
  shortHash: string;
  message: string;
  author?: string;
}

export interface BranchRow {
  name: string;
}

export interface MessageMatch {
  sessionId: string;
  label: string;
  snippet: string;
  provider?: string;
  projectId?: string;
}

export interface TokenUsageSummary {
  used: number;
  input: number;
  output: number;
  model?: string;
  costUsd: number | null;
  unsupported: boolean;
}

/** Case-insensitive substring match on the first non-empty haystack field. */
export function matchesQuery(query: string, ...haystacks: (string | undefined | null)[]): boolean {
  const q = query.trim().toLowerCase();
  if (!q) return true;
  return haystacks.some((h) => (h ?? '').toLowerCase().includes(q));
}

export function filterSessionRows(rows: SessionRow[], query: string): SessionRow[] {
  return rows.filter((r) => matchesQuery(query, r.label, r.provider, r.snippet));
}

export function filterFileRows(rows: FileRow[], query: string): FileRow[] {
  return rows.filter((r) => matchesQuery(query, r.name, r.path));
}

export function filterCommitRows(rows: CommitRow[], query: string): CommitRow[] {
  return rows.filter((r) => matchesQuery(query, r.message, r.shortHash, r.hash, r.author));
}

export function filterBranchRows(rows: BranchRow[], query: string): BranchRow[] {
  return rows.filter((r) => matchesQuery(query, r.name));
}

export function shortHash(hash: string): string {
  return (hash ?? '').slice(0, 7);
}

/** Parse `GET /api/projects/:id/sessions` (bare `{sessions,sessionMeta}`). */
export function parseProjectSessions(payload: unknown, projectId: string): SessionRow[] {
  const root = (payload ?? {}) as Record<string, unknown>;
  const sessions = Array.isArray(root.sessions) ? (root.sessions as Record<string, unknown>[]) : [];
  return sessions
    .filter((s) => s && typeof s === 'object')
    .map((s) => {
      const id = String(s.id ?? s.sessionId ?? '');
      const label =
        str(s.title) || str(s.summary) || str(s.name) || id;
      return {
        id,
        label,
        provider: str(s.provider) || undefined,
        projectId: str(s.projectId) || projectId,
      };
    })
    .filter((r) => r.id);
}

/** Flatten the file-tree response into palette rows (dirs skipped). */
export function flattenPaletteFiles(nodes: unknown[]): FileRow[] {
  const out: FileRow[] = [];
  const walk = (list: unknown[]) => {
    for (const raw of list) {
      const node = raw as Record<string, unknown>;
      if (!node || typeof node !== 'object') continue;
      const path = str(node.path);
      const name = str(node.name);
      const type = str(node.type);
      if (type === 'directory') {
        if (Array.isArray(node.children)) walk(node.children as unknown[]);
        continue;
      }
      if (path || name) out.push({ path: path || name, name: name || path });
    }
  };
  walk(Array.isArray(nodes) ? nodes : []);
  return out;
}

/** Parse `GET /api/git/commits` (bare `{commits}`). */
export function parseCommitRows(payload: unknown): CommitRow[] {
  const root = (payload ?? {}) as Record<string, unknown>;
  const commits = Array.isArray(root.commits) ? (root.commits as Record<string, unknown>[]) : [];
  return commits.map((c) => {
    const hash = String(c.hash ?? '');
    return {
      hash,
      shortHash: shortHash(hash),
      message: str(c.message),
      author: str(c.author) || undefined,
    };
  });
}

/** Parse `GET /api/git/branches` (bare `{branches,localBranches}`). */
export function parseBranchRows(payload: unknown): BranchRow[] {
  const root = (payload ?? {}) as Record<string, unknown>;
  const list = Array.isArray(root.localBranches)
    ? (root.localBranches as unknown[])
    : Array.isArray(root.branches)
      ? (root.branches as unknown[])
      : [];
  return list
    .map((b) => (typeof b === 'string' ? b : str((b as Record<string, unknown>)?.name)))
    .filter(Boolean)
    .map((name) => ({ name }));
}

/**
 * Build the SSE url for session message search. Token goes in the query
 * because EventSource (and our XHR substitute) cannot set headers.
 */
export function buildSessionSearchUrl(baseUrl: string | null | undefined, query: string, token: string | null, limit = SEARCH_LIMIT): string {
  const params = new URLSearchParams({ q: query, limit: String(limit) });
  if (token) params.set('token', token);
  const base = (baseUrl ?? '').replace(/\/$/, '');
  return `${base}/api/providers/search/sessions?${params.toString()}`;
}

/**
 * Parse one SSE `result` frame from `/api/providers/search/sessions`.
 * Shape: `{ projectResult: { projectId, sessions:[{sessionId, sessionSummary,
 * matches:[{snippet}]}] } }`. Frames for other projects are dropped.
 */
export function parseSessionSearchResult(payload: unknown, projectId: string | null): MessageMatch[] {
  const root = (payload ?? {}) as Record<string, unknown>;
  const projectResult = root.projectResult as Record<string, unknown> | undefined;
  if (!projectResult) return [];
  const resultProjectId = str(projectResult.projectId) || null;
  if (projectId && resultProjectId && resultProjectId !== projectId) return [];
  const sessions = Array.isArray(projectResult.sessions) ? (projectResult.sessions as Record<string, unknown>[]) : [];
  const out: MessageMatch[] = [];
  for (const s of sessions) {
    const sessionId = String(s.sessionId ?? '');
    if (!sessionId) continue;
    const matches = Array.isArray(s.matches) ? (s.matches as Record<string, unknown>[]) : [];
    out.push({
      sessionId,
      label: str(s.sessionSummary) || sessionId,
      snippet: str(matches[0]?.snippet),
      provider: str(s.provider) || undefined,
      projectId: resultProjectId ?? undefined,
    });
  }
  return out;
}

/** Merge live-search matches into the existing session rows (web semantics). */
export function mergeSessionMatches(rows: SessionRow[], matches: MessageMatch[]): SessionRow[] {
  const byId = new Map(rows.map((r) => [r.id, { ...r }]));
  for (const m of matches) {
    const existing = byId.get(m.sessionId);
    if (existing) {
      if (!existing.snippet && m.snippet) existing.snippet = m.snippet;
    } else {
      byId.set(m.sessionId, {
        id: m.sessionId,
        label: m.label,
        provider: m.provider,
        projectId: m.projectId,
        snippet: m.snippet,
      });
    }
  }
  return Array.from(byId.values());
}

// ---------------------------------------------------------------------------
// Session compare (tokens / cost)
// ---------------------------------------------------------------------------

/** Published per-million-token rates (subset of web `modelPricing.ts`). */
const MODEL_PRICES: Array<{ match: string; input: number; output: number }> = [
  { match: 'opus', input: 15, output: 75 },
  { match: 'sonnet', input: 3, output: 15 },
  { match: 'haiku', input: 0.8, output: 4 },
  { match: 'gpt-5', input: 1.25, output: 10 },
  { match: 'gpt-4o-mini', input: 0.15, output: 0.6 },
  { match: 'gpt-4o', input: 2.5, output: 10 },
  { match: 'o3', input: 2, output: 8 },
  { match: 'gemini-2.5-pro', input: 1.25, output: 10 },
  { match: 'gemini-2.5-flash', input: 0.3, output: 2.5 },
  { match: 'grok-4', input: 3, output: 15 },
  { match: 'deepseek', input: 0.28, output: 0.42 },
];

export function estimateCostUsd(
  model: string | null | undefined,
  inputTokens: number,
  outputTokens: number,
): number | null {
  const name = (model ?? '').toLowerCase();
  if (!name) return null;
  const price = MODEL_PRICES.find((p) => name.includes(p.match));
  if (!price) return null;
  return (inputTokens / 1_000_000) * price.input + (outputTokens / 1_000_000) * price.output;
}

export function formatCostUsd(value: number | null): string {
  if (value === null || !Number.isFinite(value)) return '—';
  if (value < 0.01) return `$${value.toFixed(4)}`;
  return `$${value.toFixed(2)}`;
}

/**
 * Normalise `GET /api/providers/sessions/:id/token-usage` (wrapped
 * `{success,data}`) into the summary the compare panel renders.
 */
export function usageFromTokenUsage(payload: unknown, model?: string | null): TokenUsageSummary {
  const root = (payload ?? {}) as Record<string, unknown>;
  const data = (root.data ?? root) as Record<string, unknown>;
  const breakdown = (data.breakdown ?? {}) as Record<string, unknown>;
  const input = num(breakdown.input) ?? num(data.inputTokens) ?? 0;
  const output = num(breakdown.output) ?? num(data.outputTokens) ?? 0;
  const used = num(data.used) ?? input + output;
  const unsupported = data.unsupported === true;
  return {
    used,
    input,
    output,
    model: model ?? undefined,
    costUsd: unsupported ? null : estimateCostUsd(model, input, output),
    unsupported,
  };
}

// ---------------------------------------------------------------------------
// Navigation
// ---------------------------------------------------------------------------

export type NavTarget = 'chat' | 'git' | 'board' | 'tasks' | 'usage' | 'source-control' | 'files';

export interface PaletteNavItem {
  key: string;
  labelKey: string;
  target: NavTarget | null;
  shortcut?: string;
}

export const PALETTE_NAV_ITEMS: PaletteNavItem[] = [
  { key: 'chat', labelKey: 'nav.chat', target: 'chat' },
  { key: 'board', labelKey: 'nav.board', target: 'board' },
  { key: 'tasks', labelKey: 'nav.tasks', target: 'tasks' },
  { key: 'usage', labelKey: 'nav.usage', target: 'usage' },
  { key: 'source-control', labelKey: 'nav.source-control', target: 'source-control' },
  { key: 'files', labelKey: 'nav.files', target: 'files' },
];

/** Drawer route name for a nav target. */
export function drawerRouteForTarget(target: NavTarget): string | null {
  switch (target) {
    case 'chat':
      return 'Projects';
    case 'board':
      return 'Board';
    case 'tasks':
      return 'Tasks';
    case 'usage':
      return 'Usage';
    case 'source-control':
      return 'SourceControl';
    case 'files':
      return 'Files';
    default:
      return null;
  }
}

/** Alt+digit mapping (web `useAppKeyboardShortcuts.getTargetTabForDigit`). */
export function navShortcutForDigit(digit: number, tasksShown: boolean): NavTarget | null {
  if (digit === 1) return 'chat';
  if (digit === 2) return tasksShown ? 'tasks' : 'git';
  if (digit === 3) return 'git';
  return null;
}

/** Web settings tab id → mobile SettingsScreen tab id. */
export function mobileSettingsTab(webTab: string): string {
  const map: Record<string, string> = {
    api: 'api',
    apiTokens: 'api',
    agents: 'agents',
    appearance: 'appearance',
    workspaces: 'workspaces',
    git: 'git',
    tasks: 'tasks',
    browser: 'browser',
    notifications: 'notifications',
    quota: 'quota',
    about: 'about',
    schedules: 'schedules',
  };
  return map[webTab] ?? 'general';
}

function str(value: unknown): string {
  return typeof value === 'string' ? value : '';
}

function num(value: unknown): number | null {
  return typeof value === 'number' && Number.isFinite(value) ? value : null;
}
