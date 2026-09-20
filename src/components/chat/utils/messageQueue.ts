/**
 * Pure helpers for the server-backed outbound message queue.
 *
 * Kept free of React/WebSocket imports so the parsing logic stays unit
 * testable without a DOM or the app's `import.meta.env` runtime.
 */

/**
 * One message held in the server-side outbound queue.
 *
 * Mirrors the backend `QueuedMessage` shape: text plus the JSON-safe options
 * (including pre-verified attachment descriptors) captured at queue time.
 */
export type ServerQueuedMessage = {
  id: number;
  sessionId: string;
  content: string;
  options: Record<string, unknown>;
  status: 'queued' | 'sending' | 'sent' | 'failed';
  error: string | null;
  createdAt: string;
  updatedAt: string;
};

const isRecord = (value: unknown): value is Record<string, unknown> =>
  Boolean(value) && typeof value === 'object' && !Array.isArray(value);

/**
 * Normalizes a queue API response (`{ data: { messages } }` or `{ messages }`)
 * into typed messages, dropping entries that are not valid queued messages.
 */
export function parseMessages(payload: unknown): ServerQueuedMessage[] {
  const root = isRecord(payload) ? payload : {};
  const data = isRecord(root.data) ? root.data : {};
  const list = Array.isArray(data.messages) ? data.messages : Array.isArray(root.messages) ? root.messages : [];
  return list.filter(
    (item): item is ServerQueuedMessage =>
      isRecord(item) && typeof item.id === 'number' && typeof item.content === 'string',
  );
}
