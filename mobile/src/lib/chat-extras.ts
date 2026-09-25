/** Pure chat helpers — no RN/expo deps, so they run under plain Node too. */

import type { ChatMessage } from './chat-messages';

/**
 * cmdk's default filter is fuzzy; the web composer requires every
 * whitespace-separated token to appear as a literal substring instead.
 * Mirrors src/components/chat/utils/modelSearch.ts so both searches behave
 * identically.
 */
export function matchesModelSearch(haystack: string, search: string): boolean {
  const value = haystack.toLowerCase();
  const tokens = search.toLowerCase().split(/\s+/).filter(Boolean);
  return tokens.every((token) => value.includes(token));
}

/** Permission-mode fallback matrix — the backend capability matrix is the source of truth. */
export const FALLBACK_PERMISSION_MODES: Record<string, string[]> = {
  claude: ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
  cursor: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  codex: ['default', 'acceptEdits', 'bypassPermissions'],
  opencode: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  devin: ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
};

export function permissionModesFor(
  provider: string | null | undefined,
  capabilities?: Record<string, string[]> | null,
): string[] {
  const fromServer = provider ? capabilities?.[provider] : undefined;
  if (Array.isArray(fromServer) && fromServer.length > 0) return fromServer;
  return FALLBACK_PERMISSION_MODES[provider ?? ''] ?? FALLBACK_PERMISSION_MODES.claude;
}

/** Raw markdown reads badly aloud: drop code fences/tags and neutralize SSML-breaking chars. */
export function speechText(raw: string): string {
  const flat = raw
    .replace(/```[\s\S]*?(?:```|$)/g, ' ')
    .replace(/<[a-zA-Z/][^>]{0,300}>/g, ' ')
    .replace(/[<&]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
  return flat;
}

const PROVIDER_LABELS: Record<string, string> = {
  claude: 'Claude',
  cursor: 'Cursor',
  codex: 'Codex',
  opencode: 'OpenCode',
  devin: 'Devin',
};

function authorLabel(msg: ChatMessage): string {
  if (msg.role === 'user') return 'You';
  if (msg.role === 'thinking') return 'Thinking';
  if (msg.role === 'system') return 'System';
  const provider = typeof msg.provider === 'string' ? msg.provider.trim() : '';
  return provider ? PROVIDER_LABELS[provider] || provider : 'Assistant';
}

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** en-US-ish "Mon D, YYYY, HH:MM:SS" without Intl (Hermes has no full ICU). */
export function formatExportTimestamp(input: number | string | Date): string {
  const date = input instanceof Date ? input : new Date(input);
  if (Number.isNaN(date.getTime())) return '';
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${MONTHS[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}, ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
}

/** Converts markdown to readable plain text (web MessageCopyControl parity). */
export function convertMarkdownToPlainText(markdown: string): string {
  let plainText = markdown.replace(/\r\n/g, '\n');
  const codeBlocks: string[] = [];
  plainText = plainText.replace(/```[\w-]*\n([\s\S]*?)```/g, (_match, code: string) => {
    const placeholder = `@@CODEBLOCK${codeBlocks.length}@@`;
    codeBlocks.push(code.replace(/\n$/, ''));
    return placeholder;
  });
  plainText = plainText.replace(/`([^`]+)`/g, '$1');
  plainText = plainText.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '$1');
  plainText = plainText.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '$1');
  plainText = plainText.replace(/^>\s?/gm, '');
  plainText = plainText.replace(/^#{1,6}\s+/gm, '');
  plainText = plainText.replace(/^[-*+]\s+/gm, '');
  plainText = plainText.replace(/^\d+\.\s+/gm, '');
  plainText = plainText.replace(/(\*\*|__)(.*?)\1/g, '$2');
  plainText = plainText.replace(/(\*|_)(.*?)\1/g, '$2');
  plainText = plainText.replace(/~~(.*?)~~/g, '$1');
  plainText = plainText.replace(/<\/?[^>]+(>|$)/g, '');
  plainText = plainText.replace(/\n{3,}/g, '\n\n');
  plainText = plainText.replace(/@@CODEBLOCK(\d+)@@/g, (_match, index: string) => codeBlocks[Number(index)] ?? '');
  return plainText.trim();
}

const COPY_FORMATS = ['markdown', 'text'] as const;
export type CopyFormat = (typeof COPY_FORMATS)[number];

/** Options offered by the per-message copy dropdown (assistant only). */
export function copyFormatOptions(): { format: CopyFormat; label: string }[] {
  return [
    { format: 'markdown', label: 'Copy as markdown' },
    { format: 'text', label: 'Copy as text' },
  ];
}

/** Short tag shown on the copy button for the active format. */
export function copyFormatTag(format: CopyFormat): string {
  return format === 'markdown' ? 'MD' : 'TXT';
}

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

export function exportFilename(sessionTitle: string | undefined, ext: string): string {
  const stamp = new Date().toISOString().split('T')[0];
  const base = (sessionTitle || 'chat').replace(/[^\w.-]+/g, '-').replace(/^-+|-+$/g, '') || 'chat';
  return `${base}-${stamp}.${ext}`;
}

/** Markdown transcript (web ChatExportMenu parity). */
export function buildMarkdownExport(messages: ChatMessage[], sessionTitle?: string): string {
  const parts: string[] = [`# ${sessionTitle || 'Chat Export'}`, '', `**Exported:** ${formatExportTimestamp(new Date())}`, '', '---', ''];
  for (const m of messages) {
    if (!m.text.trim() && m.tools.length === 0) continue;
    parts.push(`## ${authorLabel(m)}`, '');
    if (m.text.trim()) parts.push(m.text, '');
    for (const t of m.tools) parts.push(`> 🔧 \`${t.name}\`${t.status ? ` (${t.status})` : ''}`, '');
    if (m.timestamp) parts.push(`<small>${formatExportTimestamp(m.timestamp)}</small>`, '');
    parts.push('---', '');
  }
  return parts.join('\n');
}

/** Standalone HTML transcript (web exportToHTML parity, self-contained). */
export function buildHtmlExport(messages: ChatMessage[], sessionTitle?: string): string {
  const rows = messages
    .filter((m) => m.text.trim() || m.tools.length > 0)
    .map((m) => {
      const tools = m.tools
        .map((t) => `<div class="tool">🔧 ${escapeHtml(t.name)}${t.status ? ` (${escapeHtml(t.status)})` : ''}</div>`)
        .join('');
      const time = m.timestamp ? `<p style="font-size:12px;color:#999;margin-top:8px;">${escapeHtml(formatExportTimestamp(m.timestamp))}</p>` : '';
      return `<section class="msg${m.role === 'user' ? ' user' : ''}"><h2>${escapeHtml(authorLabel(m))}</h2><pre>${escapeHtml(m.text)}</pre>${tools}${time}</section>`;
    })
    .join('\n');
  return `<!doctype html><html><head><meta charset="utf-8"><title>${escapeHtml(sessionTitle || 'Chat Export')}</title>
<style>body{font-family:system-ui,sans-serif;max-width:48rem;margin:2rem auto;padding:0 1rem;color:#111}
pre{white-space:pre-wrap;word-wrap:break-word;background:#f5f5f5;padding:.75rem;border-radius:.5rem}
.tool{font-family:ui-monospace,monospace;font-size:.8rem;color:#555}
.msg{border-bottom:1px solid #ddd;padding-bottom:1rem;margin-bottom:1rem}
.msg.user{background:#e3f2fd;border-radius:.5rem;padding:1rem}</style></head>
<body><h1>${escapeHtml(sessionTitle || 'Chat Export')}</h1>
<p><em>Exported ${escapeHtml(formatExportTimestamp(new Date()))}</em></p>
${rows}</body></html>`;
}

export { PROVIDER_LABELS };
