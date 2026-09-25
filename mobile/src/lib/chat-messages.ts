/** Pure chat-message parsing — no RN deps, runnable under plain Node. */

export interface ToolCall {
  id: string;
  name: string;
  status?: string;
  detail?: string;
  /** Provider tool-call id (used to fold tool_result into its tool_use row). */
  toolId?: string;
  /** Raw tool input payload (drives the per-tool renderers). */
  input?: unknown;
  /** Raw tool result content. */
  result?: string;
  isError?: boolean;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant' | 'system' | string;
  text: string;
  tools: ToolCall[];
  timestamp?: number;
  isStreaming?: boolean;
  isError?: boolean;
  /** Subagent containers stay ungrouped in the tool list (web SubagentContainer). */
  isSubagentContainer?: boolean;
  /** Provider recorded on the message (drives export author labels). */
  provider?: string;
  images?: { path?: string; name?: string; data?: string }[];
  files?: { path?: string; name?: string; size?: number }[];
}

export interface ParsedItem {
  role: string;
  text: string;
  tools: ToolCall[];
  isError?: boolean;
  images?: { path?: string; name?: string; data?: string }[];
  files?: { path?: string; name?: string; size?: number }[];
  /** true for items that shouldn't render (status, stream_end, ...). */
  skip: boolean;
}

const stringifyDetail = (v: unknown): string | undefined =>
  v === undefined || v === null
    ? undefined
    : typeof v === 'string'
      ? v.slice(0, 400)
      : JSON.stringify(v).slice(0, 400);

const textFromParts = (parts: unknown[]): string =>
  parts
    .map((p: any) => (typeof p === 'string' ? p : typeof p?.text === 'string' ? p.text : ''))
    .filter(Boolean)
    .join('\n');

/**
 * Normalizes one item from `/api/providers/sessions/:id/messages`.
 * Real payloads are flat `{kind: ...}` items (text | thinking | tool_use |
 * tool_result | status | stream_end); a legacy nested `content[]` shape is
 * handled as fallback.
 */
export const parseItem = (m: any): ParsedItem => {
  if (!m || typeof m !== 'object') return { role: 'assistant', text: '', tools: [], skip: true };

  switch (m.kind) {
    case 'text': {
      const text = typeof m.content === 'string' ? m.content : Array.isArray(m.content) ? textFromParts(m.content) : '';
      return {
        role: m.role ?? 'assistant',
        text,
        tools: [],
        images: Array.isArray(m.images) ? m.images : undefined,
        files: Array.isArray(m.files) ? m.files : undefined,
        skip: false,
      };
    }
    case 'thinking':
      return { role: 'thinking', text: typeof m.content === 'string' ? m.content : '', tools: [], skip: false };
    case 'error':
      return { role: 'assistant', text: typeof m.content === 'string' ? m.content : 'Unknown error', tools: [], isError: true, skip: false };
    case 'tool_use':
      return {
        role: 'assistant',
        text: '',
        tools: [
          {
            id: String(m.toolId ?? m.id ?? 'tool'),
            name: m.toolName ?? 'tool',
            toolId: m.toolId != null ? String(m.toolId) : undefined,
            input: m.toolInput,
            status: 'running',
            detail: stringifyDetail(m.toolInput),
          },
        ],
        skip: false,
      };
    case 'tool_result':
      return {
        role: 'assistant',
        text: '',
        tools: [
          {
            id: `${m.toolId ?? m.id ?? 'tool'}__result`,
            name: m.isError ? 'error' : 'result',
            toolId: m.toolId != null ? String(m.toolId) : undefined,
            result: typeof m.content === 'string' ? m.content : stringifyDetail(m.content),
            isError: Boolean(m.isError),
            status: m.isError ? 'error' : 'done',
            detail: stringifyDetail(m.content),
          },
        ],
        skip: false,
      };
    default:
      if (typeof m.kind === 'string') return { role: 'assistant', text: '', tools: [], skip: true };
      break;
  }

  // Legacy nested shape: {role, content: string | parts[]}
  const tools: ToolCall[] = [];
  let text = '';
  const parts = m.content ?? m.message?.content ?? m.parts;
  if (typeof m.text === 'string') text = m.text;
  else if (typeof m.content === 'string') text = m.content;
  else if (Array.isArray(parts)) {
    const texts: string[] = [];
    for (const p of parts) {
      if (typeof p === 'string') texts.push(p);
      else if (p?.type === 'text' || typeof p?.text === 'string') texts.push(p.text ?? '');
      else if (p?.type === 'tool_use' || p?.type === 'tool_result' || p?.name) {
        tools.push({
          id: String(p.id ?? `tool-${tools.length}`),
          name: p.name ?? p.tool_name ?? p.type ?? 'tool',
          status: p.type === 'tool_result' ? 'done' : p.status,
          detail: stringifyDetail(p.input),
        });
      }
    }
    text = texts.filter(Boolean).join('\n');
  }
  return { role: extractRole(m), text, tools, skip: false };
};

export const extractRole = (m: any): string => m?.role ?? m?.message?.role ?? m?.type ?? 'assistant';

/** Unwraps the API envelope `{success, data:{messages:[...]}}` into an array. */
export const messagesFromResponse = (data: any): any[] =>
  Array.isArray(data) ? data : data?.data?.messages ?? data?.messages ?? [];
