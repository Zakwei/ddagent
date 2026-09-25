/** Print/PDF export helpers — template + filename only; expo-print does the HTML→PDF leg. */

import type { ChatMessage } from './chat-messages';

const PROVIDER_LABELS: Record<string, string> = {
  claude: 'Claude',
  cursor: 'Cursor',
  codex: 'Codex',
  opencode: 'OpenCode',
  devin: 'Devin',
};

function authorLabel(message: ChatMessage): string {
  if (message.role === 'user') return 'You';
  if (message.role === 'thinking') return 'Thinking';
  if (message.role === 'system') return 'System';
  const provider = typeof (message as { provider?: string }).provider === 'string'
    ? (message as { provider?: string }).provider!.trim()
    : '';
  if (!provider) return 'Assistant';
  return PROVIDER_LABELS[provider] || provider;
}

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** en-US-ish "Mon D, YYYY, HH:MM:SS" without Intl (Hermes-safe). */
export function formatExportTimestamp(input: Date | string | number): string {
  const date = input instanceof Date ? input : new Date(input);
  if (Number.isNaN(date.getTime())) return '';
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${MONTHS[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}, ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
}

export interface PrintTranscriptOptions {
  sessionTitle?: string;
  provider?: string;
  includeMeta?: boolean;
  exportedAt?: Date;
}

/** Standalone printable HTML — mirrors the web `exportToHTML` structure. */
export function buildPrintHtml(messages: ChatMessage[], options: PrintTranscriptOptions = {}): string {
  const { sessionTitle, includeMeta = true, exportedAt = new Date() } = options;
  const provider = options.provider ? PROVIDER_LABELS[options.provider] || options.provider : '';

  const sections = messages
    .filter((m) => m.text.trim() || m.tools.length > 0)
    .map((m) => {
      const label = authorLabel(m);
      const time = includeMeta && m.timestamp ? `<p class="time">${formatExportTimestamp(m.timestamp)}</p>` : '';
      const tools = m.tools
        .map((t) => `<div class="tool">&#128295; ${escapeHtml(t.name)}${t.status ? ` (${escapeHtml(t.status)})` : ''}</div>`)
        .join('');
      return `<div class="msg ${m.role === 'user' ? 'user' : ''}">
  <h3>${escapeHtml(label)}</h3>
  <pre>${escapeHtml(m.text)}</pre>${tools}${time}
</div>`;
    })
    .join('\n');

  return `<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${escapeHtml(sessionTitle || 'Chat Export')}</title>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 800px; margin: 0 auto; padding: 24px; background-color: #fafafa; color: #333; }
      h1 { margin: 0 0 8px 0; }
      .meta { color: #999; font-size: 13px; margin-bottom: 24px; }
      .divider { border-top: 1px solid #ddd; margin: 24px 0; }
      .msg { margin-bottom: 24px; padding: 16px; border-radius: 8px; background-color: #f5f5f5; page-break-inside: avoid; }
      .msg.user { background-color: #e3f2fd; }
      .msg h3 { margin: 0 0 12px 0; font-size: 14px; font-weight: 600; color: #333; }
      .msg pre { margin: 0; white-space: pre-wrap; word-wrap: break-word; color: #555; font-size: 14px; line-height: 1.6; font-family: inherit; }
      .tool { font-family: ui-monospace, monospace; font-size: 12px; color: #666; margin-top: 8px; }
      .time { font-size: 12px; color: #999; margin-top: 8px; }
    </style>
  </head>
  <body>
    <h1>${escapeHtml(sessionTitle || 'Chat Export')}</h1>
    <div class="meta">Exported${provider ? ` from ${escapeHtml(provider)}` : ''} on ${formatExportTimestamp(exportedAt)}</div>
    <div class="divider"></div>
    ${sections}
  </body>
</html>`;
}

/** Filename for a PDF export, derived from the session title. */
export function buildPrintFilename(sessionTitle?: string): string {
  const stamp = new Date().toISOString().split('T')[0];
  const base = (sessionTitle || 'chat').replace(/[^\w.-]+/g, '-').replace(/^-+|-+$/g, '') || 'chat';
  return `${base}-${stamp}.pdf`;
}
