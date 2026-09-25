export type FileNodeType = 'file' | 'directory';

export interface FileTreeNode {
  name: string;
  path: string;
  type: FileNodeType;
  size?: number;
  modified?: string | null;
  permissions?: string;
  permissionsRwx?: string;
  isSymlink?: boolean;
  children?: FileTreeNode[];
}

export type FileViewMode = 'simple' | 'compact' | 'detailed';

export const FILE_VIEW_MODES: FileViewMode[] = ['simple', 'compact', 'detailed'];
export const FILE_TREE_VIEW_MODE_KEY = 'file-tree-view-mode';
export const FILE_TREE_RECENT_ONLY_KEY = 'file-tree-recent-only';
export const FILE_TREE_RECENT_WINDOW_DAYS = 7;
export const FILE_SEARCH_DEBOUNCE_MS = 300;
export const FILE_SEARCH_LIMIT = 100;

const IMAGE_EXTENSIONS = new Set(['png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'ico', 'bmp']);

export function fileExtension(name: string): string {
  const idx = name.lastIndexOf('.');
  if (idx <= 0 || idx === name.length - 1) return '';
  return name.slice(idx + 1).toLowerCase();
}

export function isImageFile(name: string): boolean {
  return IMAGE_EXTENSIONS.has(fileExtension(name));
}

export function isHiddenName(name: string): boolean {
  return name.startsWith('.') && name !== '.env' && !name.startsWith('.env.');
}

export function formatFileSize(size: number | undefined | null): string {
  if (size === undefined || size === null || !Number.isFinite(size)) return '';
  if (size < 1024) return `${size} B`;
  const units = ['KB', 'MB', 'GB', 'TB'];
  let value = size / 1024;
  let i = 0;
  while (value >= 1024 && i < units.length - 1) {
    value /= 1024;
    i += 1;
  }
  const rounded = value >= 10 ? Math.round(value) : Math.round(value * 10) / 10;
  return `${rounded} ${units[i]}`;
}

export function formatRelativeTime(iso: string | null | undefined, now: number = Date.now()): string {
  if (!iso) return '';
  const ts = Date.parse(iso);
  if (Number.isNaN(ts)) return '';
  const diff = now - ts;
  const min = 60_000;
  const hour = 60 * min;
  const day = 24 * hour;
  if (diff < min) return 'just now';
  if (diff < hour) return `${Math.floor(diff / min)} min ago`;
  if (diff < day) return `${Math.floor(diff / hour)}h ago`;
  if (diff < 7 * day) return `${Math.floor(diff / day)}d ago`;
  return new Date(ts).toLocaleDateString();
}

/** Recursive name search; keeps ancestor dirs of any match. */
export function filterFileTreeByName(nodes: FileTreeNode[], query: string): FileTreeNode[] {
  const q = query.trim().toLowerCase();
  if (!q) return nodes;
  const walk = (list: FileTreeNode[]): FileTreeNode[] => {
    const out: FileTreeNode[] = [];
    for (const node of list) {
      if (node.type === 'directory') {
        const children = node.children ? walk(node.children) : [];
        if (children.length > 0 || node.name.toLowerCase().includes(q)) {
          out.push({ ...node, children });
        }
      } else if (node.name.toLowerCase().includes(q)) {
        out.push(node);
      }
    }
    return out;
  };
  return walk(nodes);
}

/** Keep files modified within the recent window (null modified = excluded), plus ancestor dirs. */
export function filterFileTreeByModified(
  nodes: FileTreeNode[],
  windowDays: number = FILE_TREE_RECENT_WINDOW_DAYS,
  now: number = Date.now(),
): FileTreeNode[] {
  const since = now - windowDays * 24 * 60 * 60 * 1000;
  const walk = (list: FileTreeNode[]): FileTreeNode[] => {
    const out: FileTreeNode[] = [];
    for (const node of list) {
      if (node.type === 'directory') {
        const children = node.children ? walk(node.children) : [];
        if (children.length > 0) out.push({ ...node, children });
      } else {
        const ts = node.modified ? Date.parse(node.modified) : 0;
        if (ts >= since) out.push(node);
      }
    }
    return out;
  };
  return walk(nodes);
}

export function collectDirectoryPaths(nodes: FileTreeNode[]): string[] {
  const out: string[] = [];
  const walk = (list: FileTreeNode[]) => {
    for (const node of list) {
      if (node.type === 'directory') {
        out.push(node.path);
        if (node.children) walk(node.children);
      }
    }
  };
  walk(nodes);
  return out;
}

export interface FlatRow {
  node: FileTreeNode;
  depth: number;
}

export function flattenTree(nodes: FileTreeNode[], expanded: Set<string>, depth = 0): FlatRow[] {
  const out: FlatRow[] = [];
  for (const node of nodes) {
    out.push({ node, depth });
    if (node.type === 'directory' && expanded.has(node.path) && node.children && node.children.length > 0) {
      out.push(...flattenTree(node.children, expanded, depth + 1));
    }
  }
  return out;
}

export type NameValidationError = 'empty' | 'invalidChars' | 'reserved' | 'dotsOnly';

const INVALID_NAME_CHARS = /[<>:"/\\|?*\u0000-\u001f]/;
const RESERVED_NAMES = /^(con|prn|aux|nul|com[1-9]|lpt[1-9])$/i;

export function validateFileName(name: string): NameValidationError | null {
  const trimmed = name.trim();
  if (!trimmed) return 'empty';
  if (/^\.+$/.test(trimmed)) return 'dotsOnly';
  if (INVALID_NAME_CHARS.test(trimmed)) return 'invalidChars';
  if (RESERVED_NAMES.test(trimmed)) return 'reserved';
  return null;
}

export interface SearchResult {
  path: string;
  line: number;
  column?: number;
  text: string;
}

export function parseSearchResults(payload: any): { results: SearchResult[]; truncated: boolean } {
  const raw = payload?.results ?? payload?.data?.results ?? [];
  const results: SearchResult[] = Array.isArray(raw)
    ? raw
        .filter((r: any) => r && typeof r.path === 'string')
        .map((r: any) => ({
          path: r.path,
          line: Number(r.line) || 0,
          column: Number.isFinite(r.column) ? Number(r.column) : undefined,
          text: typeof r.text === 'string' ? r.text : '',
        }))
    : [];
  return { results, truncated: Boolean(payload?.truncated ?? payload?.data?.truncated) };
}

export function baseName(path: string): string {
  const parts = path.split(/[\\/]/);
  return parts[parts.length - 1] || path;
}
