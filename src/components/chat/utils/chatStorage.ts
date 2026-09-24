import type { ClaudeSettings } from '../types/types';

export const CLAUDE_SETTINGS_KEY = 'claude-settings';

export const safeLocalStorage = {
  setItem: (key: string, value: string) => {
    try {
      localStorage.setItem(key, value);
    } catch (error: any) {
      if (error?.name === 'QuotaExceededError') {
        console.warn('localStorage quota exceeded, clearing old data');

        const keys = Object.keys(localStorage);
        const draftKeys = keys.filter((k) => k.startsWith('draft_input_'));
        draftKeys.forEach((k) => {
          localStorage.removeItem(k);
        });

        try {
          localStorage.setItem(key, value);
        } catch (retryError) {
          console.error('Failed to save to localStorage even after cleanup:', retryError);
        }
      } else {
        console.error('localStorage error:', error);
      }
    }
  },
  getItem: (key: string): string | null => {
    try {
      return localStorage.getItem(key);
    } catch (error) {
      console.error('localStorage getItem error:', error);
      return null;
    }
  },
  removeItem: (key: string) => {
    try {
      localStorage.removeItem(key);
    } catch (error) {
      console.error('localStorage removeItem error:', error);
    }
  },
};

export type QueuedSendOptions = Record<string, unknown>;

export interface QueuedOfflineMessage {
  id: string;
  sessionId: string;
  /**
   * Split-grid pane that queued the message. Entries written before pane
   * tagging (or by composers outside the split grid) have no paneId and are
   * matched to their owner by `sessionId` instead.
   */
  paneId?: string;
  content: string;
  options?: Record<string, unknown>;
  attachments?: unknown[];
  createdAt: number;
}

export const offlineQueueKey = (projectId: string) => `ddagent_offline_queue_${projectId}`;

export function readOfflineQueue(projectId: string): QueuedOfflineMessage[] {
  const raw = safeLocalStorage.getItem(offlineQueueKey(projectId));
  if (!raw) {
    return [];
  }

  try {
    const parsed = JSON.parse(raw) as unknown;
    if (Array.isArray(parsed)) {
      return parsed.filter(
        (item): item is QueuedOfflineMessage =>
          Boolean(item && typeof item === 'object' && typeof (item as QueuedOfflineMessage).content === 'string'),
      );
    }
    return [];
  } catch {
    return [];
  }
}

export function writeOfflineQueue(projectId: string, queue: QueuedOfflineMessage[]): void {
  if (!queue || queue.length === 0) {
    safeLocalStorage.removeItem(offlineQueueKey(projectId));
  } else {
    safeLocalStorage.setItem(offlineQueueKey(projectId), JSON.stringify(queue));
  }
}

export function clearOfflineQueue(projectId: string): void {
  safeLocalStorage.removeItem(offlineQueueKey(projectId));
}

/**
 * Removes every browser-local trace of a session that was deleted or archived
 * (here or on another client): its composer draft and any offline-queue
 * entries still pointing at it. Without this a queued entry outlives the
 * session — the next flush writes the socket frame fine, the server rejects
 * it (SESSION_NOT_FOUND/SESSION_ARCHIVED), and the message is dropped with
 * nobody able to see the error row.
 */
export function purgeSessionLocalState(sessionId: string): void {
  safeLocalStorage.removeItem(`draft_input_session_${sessionId}`);
  try {
    for (const key of Object.keys(localStorage)) {
      if (!key.startsWith('ddagent_offline_queue_')) {
        continue;
      }
      const projectId = key.slice('ddagent_offline_queue_'.length);
      const queue = readOfflineQueue(projectId);
      const next = queue.filter((entry) => entry.sessionId !== sessionId);
      if (next.length !== queue.length) {
        writeOfflineQueue(projectId, next);
      }
    }
  } catch {
    // localStorage inaccessible (privacy mode) — nothing to purge.
  }
}

export interface FlushedOfflineSend {
  message: QueuedOfflineMessage;
  sessionId: string;
}

export interface OfflineFlushResult {
  sent: FlushedOfflineSend[];
  remaining: QueuedOfflineMessage[];
}

/**
 * Flush queued offline messages. Entries queued under an
 * `offline-session-*` placeholder have no server row — `chat.send` would be
 * rejected with SESSION_NOT_FOUND while the socket write still returns true,
 * silently dropping the message. Placeholders are promoted to a real session
 * first; all entries sharing a placeholder map to a single created session.
 */
export async function flushOfflineMessages(
  messages: QueuedOfflineMessage[],
  opts: {
    send: (sessionId: string, message: QueuedOfflineMessage) => boolean;
    createSession: (message: QueuedOfflineMessage) => Promise<string | null>;
    onSessionPromoted?: (realSessionId: string, message: QueuedOfflineMessage) => void;
    // Non-destructive check ahead of the (async) promotion: a sibling that
    // already claimed the entry must not trigger a session create for it.
    stillQueued?: (message: QueuedOfflineMessage) => boolean;
    // Atomically remove the entry from storage right before send; returns
    // false when a sibling flush already claimed it (skip, do not resend).
    claim?: (message: QueuedOfflineMessage) => boolean;
    // Put the entry back when the send failed — the promoted session id is
    // kept so a retry reuses it instead of creating a duplicate session.
    requeue?: (message: QueuedOfflineMessage) => void;
  },
): Promise<OfflineFlushResult> {
  const sent: FlushedOfflineSend[] = [];
  const remaining: QueuedOfflineMessage[] = [];
  const promotedSessionIds = new Map<string, string>();

  for (const message of messages) {
    // Promotion happens while the entry is still in storage: a reload during
    // the await just retries it later instead of losing it.
    if (opts.stillQueued && !opts.stillQueued(message)) {
      continue;
    }
    let targetSessionId = message.sessionId;

    if (targetSessionId.startsWith('offline-session-')) {
      const promoted = promotedSessionIds.get(targetSessionId);
      if (promoted) {
        targetSessionId = promoted;
      } else {
        let realSessionId: string | null = null;
        try {
          realSessionId = await opts.createSession(message);
        } catch {
          realSessionId = null;
        }
        if (!realSessionId) {
          remaining.push(message);
          continue;
        }
        promotedSessionIds.set(targetSessionId, realSessionId);
        targetSessionId = realSessionId;
      }
    }

    // claim → send → requeue is one synchronous block: the entry is only out
    // of storage while the socket write runs, so a reload cannot lose it. A
    // sibling that claimed it meanwhile gets skipped — and must not rebind
    // the pane to a session its own flush created.
    if (opts.claim && !opts.claim(message)) {
      continue;
    }
    if (targetSessionId !== message.sessionId) {
      opts.onSessionPromoted?.(targetSessionId, message);
    }

    let success = false;
    try {
      success = opts.send(targetSessionId, message);
    } catch {
      success = false;
    }

    if (success) {
      sent.push({ message, sessionId: targetSessionId });
    } else {
      const retained =
        targetSessionId === message.sessionId ? message : { ...message, sessionId: targetSessionId };
      remaining.push(retained);
      opts.requeue?.(retained);
    }
  }

  return { sent, remaining };
}

export function getClaudeSettings(): ClaudeSettings {
  const raw = safeLocalStorage.getItem(CLAUDE_SETTINGS_KEY);
  if (!raw) {
    return {
      allowedTools: [],
      disallowedTools: [],
      skipPermissions: false,
      projectSortOrder: 'name',
    };
  }

  try {
    const parsed = JSON.parse(raw);
    return {
      ...parsed,
      allowedTools: Array.isArray(parsed.allowedTools) ? parsed.allowedTools : [],
      disallowedTools: Array.isArray(parsed.disallowedTools) ? parsed.disallowedTools : [],
      skipPermissions: Boolean(parsed.skipPermissions),
      projectSortOrder: parsed.projectSortOrder || 'name',
    };
  } catch {
    return {
      allowedTools: [],
      disallowedTools: [],
      skipPermissions: false,
      projectSortOrder: 'name',
    };
  }
}
