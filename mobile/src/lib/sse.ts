/**
 * Generic RN Server-Sent Events client (T29).
 *
 * React Native has no `EventSource`; XMLHttpRequest exposes the growing
 * `responseText` during readyState===3 (LOADING) for `text/event-stream`
 * responses, which is the standard substitute. Unlike the clone-progress
 * stream (whose frames carry a `type` in the JSON payload) the session-search
 * stream uses named SSE events, so this parser keeps the `event:` line too.
 */

export interface SseEvent {
  event: string;
  data: string;
}

export interface ParsedSse {
  events: SseEvent[];
  rest: string;
}

/** Split a buffer into complete SSE frames, keeping the trailing partial. */
export function parseSseEvents(buffer: string): ParsedSse {
  const events: SseEvent[] = [];
  const parts = (buffer ?? '').split('\n\n');
  const rest = parts.pop() ?? '';
  for (const frame of parts) {
    let event = 'message';
    const dataLines: string[] = [];
    for (const rawLine of frame.split('\n')) {
      const line = rawLine.replace(/\r$/, '');
      if (!line || line.startsWith(':')) continue;
      const sep = line.indexOf(':');
      const field = sep === -1 ? line : line.slice(0, sep);
      const value = sep === -1 ? '' : line.slice(sep + 1).replace(/^ /, '');
      if (field === 'event') event = value || 'message';
      else if (field === 'data') dataLines.push(value);
    }
    if (dataLines.length) events.push({ event, data: dataLines.join('\n') });
  }
  return { events, rest };
}

export interface SseHandlers {
  onEvent: (event: SseEvent) => void;
  onError?: (message: string) => void;
  onDone?: () => void;
}

export interface SseHandle {
  abort: () => void;
}

/** GET an SSE endpoint (token must live in the query string) and stream frames. */
export function streamSse(url: string, handlers: SseHandlers): SseHandle {
  let settled = false;
  let consumed = 0;
  const xhr = new XMLHttpRequest();

  const finish = () => {
    settled = true;
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
    const parsed = parseSseEvents(processable);
    for (const event of parsed.events) {
      handlers.onEvent(event);
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
        handlers.onDone?.();
      }
    }
  };
  xhr.onerror = () => {
    if (settled) return;
    finish();
    handlers.onError?.('Connection lost');
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
