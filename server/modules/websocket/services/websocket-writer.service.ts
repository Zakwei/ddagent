import type { RealtimeClientConnection } from '@/shared/types.js';
import { safeSocketSend } from '@/shared/utils.js';

/**
 * Thin transport adapter that gives WebSocket connections the same interface as
 * SSE writers used by API routes (`send`, `setSessionId`, `getSessionId`).
 */
export class WebSocketWriter {
  ws: RealtimeClientConnection;
  sessionId: string | null;
  userId: string | number | null;
  isWebSocketWriter: boolean;

  constructor(ws: RealtimeClientConnection, userId: string | number | null = null) {
    this.ws = ws;
    this.sessionId = null;
    this.userId = userId;
    this.isWebSocketWriter = true;
  }

  send(data: unknown): void {
    safeSocketSend(this.ws, JSON.stringify(data));
  }

  updateWebSocket(newRawWs: RealtimeClientConnection): void {
    this.ws = newRawWs;
  }

  setSessionId(sessionId: string): void {
    this.sessionId = sessionId;
  }

  getSessionId(): string | null {
    return this.sessionId;
  }
}
