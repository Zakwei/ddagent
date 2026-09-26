/**
 * RN clone-progress SSE client (T27).
 *
 * The web uses `EventSource`, which React Native does not ship. We instead use
 * XMLHttpRequest, whose `responseText` grows progressively during
 * readyState===3 (LOADING) for text/event-stream responses — the standard RN
 * substitute. Frames are parsed with the pure `parseSseChunk` helper.
 */
import { getStoredAuthToken } from '~shared/utils/api';
import { getServerUrlSync } from './server-config';
import { buildCloneProgressQuery, parseSseChunk, type TokenMode } from './project-wizard';

export interface CloneStreamInput {
  path: string;
  githubUrl: string;
  tokenMode: TokenMode;
  selectedGithubToken?: string;
  newGithubToken?: string;
}

export interface CloneStreamHandlers {
  onProgress?: (message: string) => void;
  onComplete?: (project: Record<string, unknown>, message?: string) => void;
  onError?: (message: string) => void;
}

export interface CloneStreamHandle {
  abort: () => void;
}

export function streamCloneProgress(
  input: CloneStreamInput,
  handlers: CloneStreamHandlers,
): CloneStreamHandle {
  const query = buildCloneProgressQuery({
    path: input.path,
    githubUrl: input.githubUrl,
    tokenMode: input.tokenMode,
    selectedGithubToken: input.selectedGithubToken,
    newGithubToken: input.newGithubToken,
    token: getStoredAuthToken(),
  });
  const url = `${getServerUrlSync()}/api/projects/clone-progress?${query}`;

  let settled = false;
  let consumed = 0;
  const xhr = new XMLHttpRequest();

  const finish = () => {
    settled = true;
  };

  const applyEvent = (event: { type: string; message?: string; project?: Record<string, unknown> }) => {
    if (settled) return;
    if (event.type === 'progress') {
      handlers.onProgress?.(event.message ?? '');
    } else if (event.type === 'complete') {
      finish();
      handlers.onComplete?.(event.project ?? {}, event.message);
    } else if (event.type === 'error') {
      finish();
      handlers.onError?.(event.message ?? 'Clone failed');
    }
  };

  const drain = () => {
    if (settled) return;
    const text = xhr.responseText ?? '';
    if (text.length <= consumed) return;
    const chunk = text.slice(consumed);
    const boundary = chunk.lastIndexOf('\n\n');
    if (boundary < 0) return;
    const processable = chunk.slice(0, boundary + 2);
    consumed += processable.length;
    const parsed = parseSseChunk(processable);
    for (const event of parsed.events) {
      applyEvent(event);
      if (settled) return;
    }
  };

  xhr.open('GET', url);
  xhr.setRequestHeader('Accept', 'text/event-stream');
  xhr.onreadystatechange = () => {
    if (xhr.readyState === 3) {
      drain();
    } else if (xhr.readyState === 4) {
      drain();
      if (!settled) {
        finish();
        handlers.onError?.('Connection lost during clone');
      }
    }
  };
  xhr.onerror = () => {
    if (settled) return;
    finish();
    handlers.onError?.('Connection lost during clone');
  };
  xhr.send();

  return {
    abort: () => {
      if (settled) return;
      settled = true;
      try {
        xhr.abort();
      } catch {
        // ignore
      }
    },
  };
}
