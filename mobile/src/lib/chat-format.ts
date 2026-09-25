/** Pure message-formatting helpers — 1:1 port of web `chatFormatting.ts` +
 *  `useChatMessages.ts` parsing. No RN deps, runnable under plain Node. */

/** ```` ```lang code``` ```` on one line → inline code (web Markdown.tsx:199). */
export function normalizeInlineCodeFences(text: string): string {
  if (!text || typeof text !== 'string') return text;
  try {
    return text.replace(/```[ \t]*([^\n\r]+?)[ \t]*```/g, '`$1`');
  } catch {
    return text;
  }
}

/** Removes Codex's `<proposed_plan>` transport envelope, keeping its markdown. */
export function stripProposedPlanEnvelope(text: string): string {
  if (!text || typeof text !== 'string') return text;
  const openingTag = /^\s*<proposed_plan>[ \t]*(?:\r?\n)?/i;
  if (!openingTag.test(text)) return text;
  const withoutOpeningTag = text.replace(openingTag, '');
  return withoutOpeningTag.replace(/(?:\r?\n)?[ \t]*<\/proposed_plan>\s*$/i, '');
}

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** Rewrites `Claude AI usage limit reached|<ts>` into a readable reset time. */
export function formatUsageLimitText(text: string): string {
  try {
    if (typeof text !== 'string') return text;
    return text.replace(/Claude AI usage limit reached\|(\d{10,13})/g, (match, ts) => {
      let timestampMs = parseInt(ts, 10);
      if (!Number.isFinite(timestampMs)) return match;
      if (timestampMs < 1e12) timestampMs *= 1000;
      const reset = new Date(timestampMs);

      const pad = (n: number) => String(n).padStart(2, '0');
      const timeStr = `${pad(reset.getHours())}:${pad(reset.getMinutes())}`;

      const offsetMinutesLocal = -reset.getTimezoneOffset();
      const sign = offsetMinutesLocal >= 0 ? '+' : '-';
      const abs = Math.abs(offsetMinutesLocal);
      const offH = Math.floor(abs / 60);
      const offM = abs % 60;
      const gmt = `GMT${sign}${offH}${offM ? ':' + pad(offM) : ''}`;

      const dateReadable = `${reset.getDate()} ${MONTHS[reset.getMonth()]} ${reset.getFullYear()}`;
      return `Claude usage limit reached. Your limit will reset at **${timeStr} ${gmt}** - ${dateReadable}`;
    });
  } catch {
    return text;
  }
}

export interface ParsedTaskNotification {
  status: string;
  summary: string;
  result: string;
}

/** Parses a background-agent `<task-notification>` block (web useChatMessages.ts:44). */
export function parseTaskNotification(content: string): ParsedTaskNotification | null {
  if (!content || !content.trimStart().startsWith('<task-notification>')) return null;

  const statusMatch = /<status>([\s\S]*?)<\/status>/.exec(content);
  const summaryMatch = /<summary>([\s\S]*?)<\/summary>/.exec(content);

  let result = '';
  const resultOpen = content.indexOf('<result>');
  if (resultOpen !== -1) {
    const afterOpen = content.slice(resultOpen + '<result>'.length);
    const closeIndex = afterOpen.indexOf('</result>');
    result =
      closeIndex === -1
        ? afterOpen.replace(/<\/task-notification>\s*$/, '').trim()
        : afterOpen.slice(0, closeIndex).trim();
  }

  return {
    status: statusMatch?.[1]?.trim() || 'completed',
    summary: summaryMatch?.[1]?.trim() || 'Background task finished',
    result,
  };
}

export interface InteractiveOption {
  number: string;
  text: string;
  isSelected: boolean;
}

export interface ParsedInteractivePrompt {
  questionLine: string;
  options: InteractiveOption[];
}

/** Parses a CLI menu (`❯ 1. Yes`) out of an interactive-prompt message. */
export function parseInteractivePrompt(content: string): ParsedInteractivePrompt {
  const lines = (content || '').split('\n').filter((line) => line.trim());
  const questionLine = lines.find((line) => line.includes('?')) || lines[0] || '';
  const options: InteractiveOption[] = [];
  lines.forEach((line) => {
    const match = line.match(/[❯\s]*(\d+)\.\s+(.+)/);
    if (match) {
      options.push({ number: match[1], text: match[2].trim(), isSelected: line.includes('❯') });
    }
  });
  return { questionLine, options };
}

/** True when the content is a single JSON object/array (web JSON response card). */
export function detectPureJson(content: string): { formatted: string } | null {
  const trimmed = (content ?? '').trim();
  if (!trimmed) return null;
  const startsJson = trimmed.startsWith('{') || trimmed.startsWith('[');
  const endsJson = trimmed.endsWith('}') || trimmed.endsWith(']');
  if (!startsJson || !endsJson) return null;
  try {
    return { formatted: JSON.stringify(JSON.parse(trimmed), null, 2) };
  } catch {
    return null;
  }
}

// --- link / file-reference detection (web Markdown.tsx:27-57) ---

export const isExternalHref = (href?: string): boolean =>
  !!href && (/^(https?:|mailto:|tel:|data:)/i.test(href) || href.startsWith('#'));

export const stripLineSuffix = (value: string): string => value.replace(/:\d+(?::\d+)?$/, '');

export const looksLikeFilePath = (value?: string): value is string => {
  if (!value) return false;
  const cleaned = stripLineSuffix(value.trim());
  if (!cleaned || cleaned === '#') return false;
  return /[\\/]/.test(cleaned) || /\.[a-z0-9]+$/i.test(cleaned);
};

/** Resolves a markdown link to a workspace file path, if it is one. */
export function fileRefFromLink(href: string | undefined, linkText: string): string | null {
  const ref = looksLikeFilePath(href) ? href : looksLikeFilePath(linkText) ? linkText : undefined;
  if (!ref || isExternalHref(href)) return null;
  return stripLineSuffix(ref);
}

/** B / KB / MB display for attachment sizes. */
export function formatFileSize(bytes: number): string {
  if (!Number.isFinite(bytes) || bytes <= 0) return '0 B';
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

/** `HH:MM:SS` local time for a message timestamp. */
export function formatMessageTime(timestamp?: number): string | null {
  if (!timestamp) return null;
  const d = new Date(timestamp);
  if (Number.isNaN(d.getTime())) return null;
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

/** Per-turn latency (s), or null when implausible (web MessageComponent.tsx:110). */
export function turnLatencySeconds(
  message: { role: string; timestamp?: number },
  prev?: { role: string; timestamp?: number } | null,
): number | null {
  if (message.role !== 'assistant' || !prev || !prev.timestamp || !message.timestamp) return null;
  if (prev.role !== 'user') return null;
  const seconds = (message.timestamp - prev.timestamp) / 1000;
  if (seconds < 0.5 || seconds > 600) return null;
  return seconds;
}

export function formatTurnLatency(seconds: number): string {
  return seconds < 60 ? `${seconds.toFixed(1)}s` : `${Math.floor(seconds / 60)}m ${Math.round(seconds % 60)}s`;
}

/** Same-role consecutive grouping (web MessageComponent `isGrouped`). */
export function isGroupedMessage(
  message: { role: string },
  prev?: { role: string } | null,
): boolean {
  if (!prev) return false;
  if (prev.role !== message.role) return false;
  return message.role === 'assistant' || message.role === 'user' || message.role === 'tool' || message.role === 'error';
}
