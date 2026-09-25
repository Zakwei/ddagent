// Pure offline-queue logic — no RN/expo deps (storage is injected).
// Mirrors web src/components/chat/utils/chatStorage.ts offline-queue section.

export interface QueuedOfflineMessage {
  id: string;
  sessionId: string;
  paneId?: string;
  content: string;
  options?: Record<string, unknown>;
  attachments?: unknown[];
  createdAt: number;
}

export const offlineQueueKey = (projectId: string): string => `ddagent_offline_queue_${projectId}`;

export const isPlaceholderSession = (sessionId: string): boolean => sessionId.startsWith('offline-session-');

export function parseOfflineQueue(raw: string | null): QueuedOfflineMessage[] {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed.filter(
      (item): item is QueuedOfflineMessage =>
        Boolean(item && typeof item === 'object' && typeof (item as QueuedOfflineMessage).content === 'string'),
    );
  } catch {
    return [];
  }
}

export const serializeOfflineQueue = (queue: QueuedOfflineMessage[]): string | null =>
  !queue || queue.length === 0 ? null : JSON.stringify(queue);

/** Remove every entry that points at a session that no longer exists. */
export function purgeSession(queue: QueuedOfflineMessage[], sessionId: string): QueuedOfflineMessage[] {
  return queue.filter((entry) => entry.sessionId !== sessionId);
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
 * Flush queued offline messages. Entries under an `offline-session-*`
 * placeholder have no server row — promote them to a real session first; all
 * entries sharing a placeholder map to one created session (web
 * flushOfflineMessages).
 */
export async function flushOfflineMessages(
  messages: QueuedOfflineMessage[],
  opts: {
    send: (sessionId: string, message: QueuedOfflineMessage) => boolean;
    createSession: (message: QueuedOfflineMessage) => Promise<string | null>;
    onSessionPromoted?: (realSessionId: string, message: QueuedOfflineMessage) => void;
    stillQueued?: (message: QueuedOfflineMessage) => boolean;
    claim?: (message: QueuedOfflineMessage) => boolean;
    requeue?: (message: QueuedOfflineMessage) => void;
  },
): Promise<OfflineFlushResult> {
  const sent: FlushedOfflineSend[] = [];
  const remaining: QueuedOfflineMessage[] = [];
  const promoted = new Map<string, string>();

  for (const message of messages) {
    if (opts.stillQueued && !opts.stillQueued(message)) continue;
    let targetSessionId = message.sessionId;

    if (isPlaceholderSession(targetSessionId)) {
      const existing = promoted.get(targetSessionId);
      if (existing) {
        targetSessionId = existing;
      } else {
        let real: string | null = null;
        try {
          real = await opts.createSession(message);
        } catch {
          real = null;
        }
        if (!real) {
          remaining.push(message);
          continue;
        }
        promoted.set(targetSessionId, real);
        targetSessionId = real;
      }
    }

    if (opts.claim && !opts.claim(message)) continue;
    if (targetSessionId !== message.sessionId) opts.onSessionPromoted?.(targetSessionId, message);

    let success = false;
    try {
      success = opts.send(targetSessionId, message);
    } catch {
      success = false;
    }

    if (success) {
      sent.push({ message, sessionId: targetSessionId });
    } else {
      const retained = targetSessionId === message.sessionId ? message : { ...message, sessionId: targetSessionId };
      remaining.push(retained);
      opts.requeue?.(retained);
    }
  }

  return { sent, remaining };
}
