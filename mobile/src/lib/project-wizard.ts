/**
 * Pure helpers for the project-creation wizard (T27).
 *
 * Mirrors the web contract in
 * src/components/project-creation-wizard/{utils/pathUtils.ts,data/workspaceApi.ts,types.ts}
 * without any React Native / DOM dependency so it can run under Node in
 * mobile/tests/self-check.mts.
 */

export type TokenMode = 'stored' | 'new' | 'none';

export interface GithubCredential {
  id: number;
  credential_name: string;
  is_active: boolean;
}

export interface FolderSuggestion {
  name: string;
  path: string;
  type: 'directory';
}

export interface WizardFormState {
  workspacePath: string;
  githubUrl: string;
  tokenMode: TokenMode;
  selectedGithubToken: string;
  newGithubToken: string;
}

export interface CloneStreamEvent {
  type: 'progress' | 'complete' | 'error';
  message?: string;
  project?: Record<string, unknown>;
}

const SSH_PREFIXES = ['git@', 'ssh://'];

export function isSshGitUrl(url: string | null | undefined): boolean {
  const trimmed = (url ?? '').trim();
  return SSH_PREFIXES.some((prefix) => trimmed.startsWith(prefix));
}

export function shouldShowGithubAuthentication(url: string | null | undefined): boolean {
  const trimmed = (url ?? '').trim();
  return trimmed.length > 0 && !isSshGitUrl(trimmed);
}

export function isCloneWorkflow(url: string | null | undefined): boolean {
  return (url ?? '').trim().length > 0;
}

/** Separator-aware join that keeps Windows-style paths intact. */
export function joinFolderPath(base: string, name: string): string {
  const trimmedBase = (base ?? '').replace(/[\\/]+$/, '');
  const trimmedName = (name ?? '').replace(/^[\\/]+/, '');
  if (!trimmedBase) return trimmedName;
  const separator = trimmedBase.includes('\\') && !trimmedBase.includes('/') ? '\\' : '/';
  return `${trimmedBase}${separator}${trimmedName}`;
}

/** Parent of a path; null at '~', '/', drive roots and pathless values. */
export function getParentPath(path: string): string | null {
  const value = (path ?? '').trim();
  if (!value || value === '~' || value === '/') return null;
  if (/^[A-Za-z]:[\\/]?$/.test(value)) return null;
  const normalized = value.replace(/[\\/]+$/, '');
  const index = Math.max(normalized.lastIndexOf('/'), normalized.lastIndexOf('\\'));
  if (index < 0) return null;
  const parent = normalized.slice(0, index);
  if (!parent) return normalized.startsWith('/') ? '/' : null;
  if (/^[A-Za-z]:$/.test(parent)) {
    return parent + (normalized.includes('\\') ? '\\' : '/');
  }
  return parent;
}

export interface CloneProgressQueryInput {
  path: string;
  githubUrl: string;
  tokenMode: TokenMode;
  selectedGithubToken?: string;
  newGithubToken?: string;
  token?: string | null;
}

export function buildCloneProgressQuery(input: CloneProgressQueryInput): string {
  const params = new URLSearchParams();
  params.set('path', input.path);
  params.set('githubUrl', input.githubUrl);
  if (input.tokenMode === 'stored' && input.selectedGithubToken) {
    params.set('githubTokenId', input.selectedGithubToken);
  }
  if (input.tokenMode === 'new' && input.newGithubToken) {
    params.set('newGithubToken', input.newGithubToken);
  }
  if (input.token) {
    params.set('token', input.token);
  }
  return params.toString();
}

export interface ParsedSseChunk {
  events: CloneStreamEvent[];
  rest: string;
}

/**
 * Splits an SSE buffer on `\n\n`, parses `data:` frames, and returns the
 * trailing incomplete frame as `rest`. Malformed JSON frames are dropped.
 */
export function parseSseChunk(buffer: string): ParsedSseChunk {
  const events: CloneStreamEvent[] = [];
  const parts = (buffer ?? '').split('\n\n');
  const rest = parts.pop() ?? '';
  for (const part of parts) {
    for (const line of part.split('\n')) {
      const trimmed = line.trim();
      if (!trimmed.startsWith('data:')) continue;
      const payload = trimmed.slice(5).trim();
      if (!payload) continue;
      try {
        const parsed = JSON.parse(payload);
        if (parsed && typeof parsed === 'object' && typeof parsed.type === 'string') {
          events.push(parsed as CloneStreamEvent);
        }
      } catch {
        // ignore malformed frames
      }
    }
  }
  return { events, rest };
}

/**
 * Client-side error extraction mirroring web `resolveCreateProjectErrorMessage`.
 * Precedence: details -> error -> error.details -> error.message ->
 * error.details.projectPath -> message -> fallback.
 */
export function resolveCreateProjectError(payload: any, fallback: string): string {
  if (!payload) return fallback;
  if (typeof payload.details === 'string') return payload.details;
  if (typeof payload.error === 'string') return payload.error;
  if (payload.error && typeof payload.error === 'object') {
    if (typeof payload.error.details === 'string') return payload.error.details;
    if (typeof payload.error.message === 'string') return payload.error.message;
    if (payload.error.details && typeof payload.error.details.projectPath === 'string') {
      return payload.error.details.projectPath;
    }
  }
  if (typeof payload.message === 'string') return payload.message;
  return fallback;
}

export type AuthenticationLabel =
  | { kind: 'ssh' }
  | { kind: 'stored'; name: string | null }
  | { kind: 'provided' }
  | { kind: 'none' };

export function authenticationLabel(input: {
  tokenMode: TokenMode;
  selectedTokenName?: string | null;
  newToken?: string;
  githubUrl: string;
}): AuthenticationLabel {
  if (isSshGitUrl(input.githubUrl)) return { kind: 'ssh' };
  if (input.tokenMode === 'stored') {
    return { kind: 'stored', name: input.selectedTokenName ? input.selectedTokenName : null };
  }
  if (input.tokenMode === 'new') {
    return (input.newToken ?? '').trim() ? { kind: 'provided' } : { kind: 'none' };
  }
  return { kind: 'none' };
}

/** Step 1 gate: workspace path must be non-empty (trimmed). */
export function validateWizardStep(workspacePath: string): 'providePath' | null {
  return (workspacePath ?? '').trim() ? null : 'providePath';
}
