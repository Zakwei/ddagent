import { useCallback, useEffect, useRef, useState } from 'react';
import { api } from '~shared/utils/api';
import { readApiError } from './kanban';

export type GitChangedFile = {
  path: string;
  status: 'M' | 'A' | 'D' | 'U';
};

export type GitStatusResponse = {
  branch?: string;
  hasCommits?: boolean;
  modified?: string[];
  added?: string[];
  deleted?: string[];
  untracked?: string[];
  staged?: string[];
  error?: string;
  details?: string;
  notGitRepository?: boolean;
};

export type GitRemoteStatus = {
  hasRemote: boolean;
  hasUpstream: boolean;
  branch?: string;
  remoteBranch?: string;
  remoteName?: string;
  ahead: number;
  behind: number;
  isUpToDate: boolean;
  message?: string;
  error?: string;
};

export type GitCommitSummary = {
  hash: string;
  author: string;
  email?: string;
  date: string;
  message: string;
  stats?: { insertions?: number; deletions?: number; files?: number };
  parents?: string[];
  refs?: string[];
};

export type GitBranch = { name: string; current?: boolean; ahead?: number; behind?: number; remote?: boolean };

export type WorktreeInfo = {
  path: string;
  branch: string | null;
  headSha?: string;
  isMain?: boolean;
  isCurrent?: boolean;
  isLocked?: boolean;
  isDetached?: boolean;
  changedFileCount?: number;
  ahead?: number;
  behind?: number;
  lastCommitSubject?: string;
  lastCommitDate?: string;
};

async function readJson<T>(response: Response): Promise<T> {
  try {
    return (await response.json()) as T;
  } catch {
    return {} as T;
  }
}

async function get<T>(endpoint: string, fallback: string): Promise<T> {
  const response = await api.get(endpoint);
  const payload = await readJson<T & { error?: unknown }>(response);
  if (!response.ok) throw new Error(readApiError(payload as never, fallback));
  return payload as T;
}

async function post<T>(endpoint: string, body: unknown, fallback: string): Promise<T> {
  const response = await api.post(endpoint, body);
  const payload = await readJson<T & { error?: unknown }>(response);
  if (!response.ok) throw new Error(readApiError(payload as never, fallback));
  return payload as T;
}

const q = (projectId: string) => `project=${encodeURIComponent(projectId)}`;

export const gitClient = {
  status: (projectId: string) => get<GitStatusResponse>(`/git/status?${q(projectId)}`, 'status failed'),
  diff: (projectId: string, file: string) =>
    get<{ diff?: string; error?: string }>(`/git/diff?${q(projectId)}&file=${encodeURIComponent(file)}`, 'diff failed'),
  branches: (projectId: string) =>
    get<{ branches?: GitBranch[]; localBranches?: GitBranch[]; remoteBranches?: GitBranch[]; error?: string }>(
      `/git/branches?${q(projectId)}`,
      'branches failed',
    ),
  remoteStatus: (projectId: string) => get<GitRemoteStatus>(`/git/remote-status?${q(projectId)}`, 'remote status failed'),
  commits: (projectId: string, limit = 50) =>
    get<{ commits?: GitCommitSummary[]; error?: string }>(`/git/commits?${q(projectId)}&limit=${limit}`, 'commits failed'),
  commitDiff: (projectId: string, hash: string) =>
    get<{ diff?: string; error?: string }>(`/git/commit-diff?${q(projectId)}&commit=${encodeURIComponent(hash)}`, 'commit diff failed'),

  stage: (projectId: string, files: string[]) => post('/git/stage', { project: projectId, files }, 'stage failed'),
  unstage: (projectId: string, files: string[]) => post('/git/unstage', { project: projectId, files }, 'unstage failed'),
  stageHunks: (projectId: string, filePath: string, hunks: number[]) =>
    post('/git/stage-hunks', { project: projectId, filePath, hunks }, 'stage hunk failed'),
  unstageHunks: (projectId: string, filePath: string, hunks: number[]) =>
    post('/git/unstage-hunks', { project: projectId, filePath, hunks }, 'unstage hunk failed'),
  discard: (projectId: string, file: string) => post('/git/discard', { project: projectId, file }, 'discard failed'),
  deleteUntracked: (projectId: string, file: string) =>
    post('/git/delete-untracked', { project: projectId, file }, 'delete failed'),
  commit: (projectId: string, message: string, files: string[]) =>
    post('/git/commit', { project: projectId, message, files }, 'commit failed'),
  initialCommit: (projectId: string) => post('/git/initial-commit', { project: projectId }, 'initial commit failed'),
  initRepo: (projectId: string) => post('/git/init', { project: projectId }, 'init failed'),
  generateCommitMessage: (projectId: string, files: string[], provider?: string) =>
    post<{ message?: string }>(
      '/git/generate-commit-message',
      { project: projectId, files, provider },
      'generate failed',
    ),
  checkout: (projectId: string, branch: string) => post('/git/checkout', { project: projectId, branch }, 'switch failed'),
  createBranch: (projectId: string, branch: string) =>
    post('/git/create-branch', { project: projectId, branch }, 'create branch failed'),
  deleteBranch: (projectId: string, branch: string, force = false) =>
    post('/git/delete-branch', { project: projectId, branch, force }, 'delete branch failed'),
  fetchRemote: (projectId: string) => post('/git/fetch', { project: projectId }, 'fetch failed'),
  pull: (projectId: string) => post('/git/pull', { project: projectId }, 'pull failed'),
  push: (projectId: string) => post('/git/push', { project: projectId }, 'push failed'),
  publish: (projectId: string, branch: string) => post('/git/publish', { project: projectId, branch }, 'publish failed'),
  revertLocalCommit: (projectId: string) =>
    post('/git/revert-local-commit', { project: projectId }, 'revert failed'),

  worktrees: (projectId: string) =>
    get<{ success?: boolean; data?: { worktrees?: WorktreeInfo[] }; error?: { message?: string } }>(
      `/worktrees?${q(projectId)}`,
      'worktrees failed',
    ),
  createWorktree: (projectId: string, branch: string, baseBranch?: string | null) =>
    post('/worktrees/create', { project: projectId, branch, baseBranch }, 'create worktree failed'),
  openWorktree: (projectId: string, worktreePath: string) =>
    post('/worktrees/open', { project: projectId, worktreePath }, 'open worktree failed'),
  mergeWorktree: (projectId: string, worktreePath: string, squash = true, message?: string, removeAfterMerge = false) =>
    post('/worktrees/merge', { project: projectId, worktreePath, squash, message, removeAfterMerge }, 'merge failed'),
  removeWorktree: (projectId: string, worktreePath: string, force = false, deleteBranch = true) =>
    post('/worktrees/remove', { project: projectId, worktreePath, force, deleteBranch }, 'remove worktree failed'),
};

export function getAllChangedFiles(status: GitStatusResponse | null): GitChangedFile[] {
  if (!status) return [];
  const files: GitChangedFile[] = [];
  // Staged entries are reported separately; a staged file is still shown in its
  // change group so the checkbox mirrors `gitStatus.staged`.
  for (const path of status.staged ?? []) files.push({ path, status: 'M' });
  for (const path of status.modified ?? []) files.push({ path, status: 'M' });
  for (const path of status.added ?? []) files.push({ path, status: 'A' });
  for (const path of status.deleted ?? []) files.push({ path, status: 'D' });
  for (const path of status.untracked ?? []) files.push({ path, status: 'U' });
  const seen = new Set<string>();
  return files.filter((file) => {
    const key = file.path;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

export function getChangedFileCount(status: GitStatusResponse | null): number {
  return getAllChangedFiles(status).length;
}

export function parseCommitFiles(output: string | undefined) {
  const files: { path: string; status: 'M' | 'A' | 'D'; insertions: number; deletions: number }[] = [];
  if (!output) return { files, totalInsertions: 0, totalDeletions: 0 };
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
    files.push({ path, status, insertions, deletions });
  }
  return {
    files,
    totalInsertions: files.reduce((sum, f) => sum + f.insertions, 0),
    totalDeletions: files.reduce((sum, f) => sum + f.deletions, 0),
  };
}

const DIFF_CHAR_LIMIT = 200_000;
const DIFF_LINE_LIMIT = 1_500;

export type DiffLine = { kind: 'add' | 'del' | 'ctx' | 'hunk' | 'meta'; text: string; hunkIndex?: number };

/** Unified diff → renderable lines; truncated like the web viewer. */
export function buildDiffLines(diff: string | undefined): DiffLine[] {
  if (!diff) return [];
  let text = diff.slice(0, DIFF_CHAR_LIMIT);
  let lines = text.split('\n');
  if (lines.length > DIFF_LINE_LIMIT) lines = lines.slice(0, DIFF_LINE_LIMIT);
  let hunkIndex = -1;
  return lines.map((line) => {
    if (line.startsWith('@@')) {
      hunkIndex += 1;
      return { kind: 'hunk', text: line, hunkIndex };
    }
    if (line.startsWith('diff --git') || line.startsWith('index ') || line.startsWith('+++') || line.startsWith('---')) {
      return { kind: 'meta', text: line };
    }
    if (line.startsWith('+')) return { kind: 'add', text: line };
    if (line.startsWith('-')) return { kind: 'del', text: line };
    return { kind: 'ctx', text: line };
  });
}

export type GitState = {
  status: GitStatusResponse | null;
  remoteStatus: GitRemoteStatus | null;
  branches: GitBranch[];
  commits: GitCommitSummary[];
  diffs: Record<string, string>;
  isLoading: boolean;
  error: string | null;
};

export function useGitPanel(projectId: string | undefined) {
  const [state, setState] = useState<GitState>({
    status: null,
    remoteStatus: null,
    branches: [],
    commits: [],
    diffs: {},
    isLoading: false,
    error: null,
  });
  const projectRef = useRef(projectId);
  projectRef.current = projectId;

  const applyStatus = useCallback((status: GitStatusResponse) => {
    setState((prev) => ({ ...prev, status, error: status.error ?? null }));
  }, []);

  const fetchDiffs = useCallback(async (id: string, files: GitChangedFile[]) => {
    const entries = await Promise.all(
      files.map(async (file) => {
        try {
          const result = await gitClient.diff(id, file.path);
          return [file.path, result.diff ?? ''] as const;
        } catch {
          return [file.path, ''] as const;
        }
      }),
    );
    if (projectRef.current !== id) return;
    setState((prev) => ({ ...prev, diffs: Object.fromEntries(entries) }));
  }, []);

  const fetchStatus = useCallback(
    async (id: string) => {
      const status = await gitClient.status(id);
      if (projectRef.current !== id) return;
      applyStatus(status);
      if (!status.notGitRepository) {
        void fetchDiffs(id, getAllChangedFiles(status));
        try {
          const remote = await gitClient.remoteStatus(id);
          if (projectRef.current === id) setState((prev) => ({ ...prev, remoteStatus: remote }));
        } catch {
          /* remote is best-effort */
        }
      }
    },
    [applyStatus, fetchDiffs],
  );

  const fetchBranches = useCallback(async (id: string) => {
    const result = await gitClient.branches(id);
    if (projectRef.current !== id) return;
    setState((prev) => ({ ...prev, branches: result.branches ?? [] }));
  }, []);

  const fetchCommits = useCallback(async (id: string) => {
    const result = await gitClient.commits(id);
    if (projectRef.current !== id) return;
    setState((prev) => ({ ...prev, commits: result.commits ?? [] }));
  }, []);

  const refresh = useCallback(
    async (options?: { commits?: boolean }) => {
      const id = projectRef.current;
      if (!id) return;
      setState((prev) => ({ ...prev, isLoading: true }));
      try {
        await fetchStatus(id);
        await fetchBranches(id);
        if (options?.commits) await fetchCommits(id);
        if (projectRef.current === id) setState((prev) => ({ ...prev, error: null }));
      } catch (err) {
        if (projectRef.current === id) {
          setState((prev) => ({ ...prev, error: err instanceof Error ? err.message : String(err) }));
        }
      } finally {
        if (projectRef.current === id) setState((prev) => ({ ...prev, isLoading: false }));
      }
    },
    [fetchBranches, fetchCommits, fetchStatus],
  );

  // Reset + reload whenever the selected project changes.
  useEffect(() => {
    if (!projectId) return;
    setState({
      status: null,
      remoteStatus: null,
      branches: [],
      commits: [],
      diffs: {},
      isLoading: true,
      error: null,
    });
    void refresh({ commits: true });
  }, [projectId]);

  const fetchCommitDiff = useCallback(async (hash: string) => {
    const id = projectRef.current;
    if (!id) return '';
    const result = await gitClient.commitDiff(id, hash);
    return result.diff ?? '';
  }, []);

  return { ...state, refresh, fetchCommitDiff, fetchDiffs };
}
