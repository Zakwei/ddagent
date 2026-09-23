import { appConfigDb, notificationChannelEndpointsDb } from '@/modules/database/index.js';
import { registerApprovalContext } from '@/modules/notifications/services/remote-approval.service.js';

const TELEGRAM_API = 'https://api.telegram.org';
const TELEGRAM_TOKEN_KEY = 'messenger.telegram.botToken';
const DISCORD_WEBHOOK_KEY = 'messenger.discord.webhookUrl';

type NotificationEventLike = {
  code?: string;
  meta?: Record<string, unknown>;
};

type ChannelSendInput = {
  userId: number;
  event: NotificationEventLike;
  payload: { title?: string; body?: string };
};

// ---------------------------------------------------------------------------
// Config access (bot tokens live in app_config alongside jwt_secret)
// ---------------------------------------------------------------------------

/** Consumed by notifications.routes.ts (GET config) and telegram-poller. */
export function getTelegramBotToken(): string | null {
  const token = appConfigDb.get(TELEGRAM_TOKEN_KEY);
  return token && token.length > 0 ? token : null;
}

/** Consumed by notifications.routes.ts (PUT config). */
export function setTelegramBotToken(token: string): void {
  appConfigDb.set(TELEGRAM_TOKEN_KEY, token.trim());
}

/** Consumed by notifications.routes.ts (GET config) and the discord channel. */
export function getDiscordWebhookUrl(): string | null {
  const url = appConfigDb.get(DISCORD_WEBHOOK_KEY);
  return url && url.length > 0 ? url : null;
}

/** Consumed by notifications.routes.ts (PUT config). */
export function setDiscordWebhookUrl(url: string): void {
  appConfigDb.set(DISCORD_WEBHOOK_KEY, url.trim());
}

/** SSRF guard for the Discord webhook URL — must point at Discord's API. */
export function isValidDiscordWebhookUrl(url: string): boolean {
  try {
    const parsed = new URL(url);
    return (
      parsed.protocol === 'https:' &&
      (parsed.host === 'discord.com' || parsed.host === 'discordapp.com') &&
      parsed.pathname.startsWith('/api/webhooks/')
    );
  } catch {
    return false;
  }
}

// ---------------------------------------------------------------------------
// Telegram
// ---------------------------------------------------------------------------

type TelegramInlineButton = { text: string; callback_data: string };

function buildTelegramMessage(event: NotificationEventLike, payload: { title?: string; body?: string }) {
  const lines = [payload.title, payload.body].filter(Boolean);
  const inputPreview = typeof event.meta?.inputPreview === 'string' ? event.meta.inputPreview : null;
  if (inputPreview) {
    lines.push(`\n${inputPreview}`);
  }

  const requestId = typeof event.meta?.requestId === 'string' ? event.meta.requestId : null;
  const keyboard: TelegramInlineButton[][] = [];
  if (requestId) {
    // callback_data limit is 64 bytes; "ap:<36-char-uuid>:a" fits easily.
    keyboard.push([
      { text: '✅ Allow', callback_data: `ap:${requestId}:a` },
      { text: '⛔ Deny', callback_data: `ap:${requestId}:d` },
      { text: '♾️ Always', callback_data: `ap:${requestId}:w` },
    ]);
  }

  return { text: lines.join('\n'), keyboard, requestId };
}

async function telegramApi(token: string, method: string, body: Record<string, unknown>): Promise<unknown> {
  const response = await fetch(`${TELEGRAM_API}/bot${token}/${method}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  const data = (await response.json().catch(() => null)) as { ok?: boolean; description?: string } | null;
  if (!response.ok || !data?.ok) {
    throw new Error(`Telegram ${method} failed: ${data?.description ?? response.status}`);
  }
  return data;
}

/** Exported for tests and for telegram-poller.service.ts replies. */
export async function sendTelegramMessage(
  token: string,
  chatId: string,
  text: string,
  keyboard: TelegramInlineButton[][] = []
): Promise<void> {
  await telegramApi(token, 'sendMessage', {
    chat_id: chatId,
    text,
    ...(keyboard.length ? { reply_markup: { inline_keyboard: keyboard } } : {}),
  });
}

/** Exported for telegram-poller.service.ts (answerCallbackQuery / editMessageText). */
export async function callTelegramApi(
  token: string,
  method: string,
  body: Record<string, unknown>
): Promise<unknown> {
  return telegramApi(token, method, body);
}

async function sendTelegramChannel({ userId, event, payload }: ChannelSendInput): Promise<void> {
  const token = getTelegramBotToken();
  if (!token) {
    return;
  }

  const endpoints = notificationChannelEndpointsDb.getEnabledEndpoints(userId, 'telegram');
  if (!endpoints.length) {
    return;
  }

  const { text, keyboard, requestId } = buildTelegramMessage(event, payload);
  if (requestId) {
    registerApprovalContext(requestId, {
      toolName: typeof event.meta?.toolName === 'string' ? event.meta.toolName : null,
      sessionId: typeof event.meta?.sessionId === 'string' ? event.meta.sessionId : null,
    });
  }

  await Promise.allSettled(
    endpoints.map((endpoint) => sendTelegramMessage(token, endpoint.endpoint_id, text, keyboard))
  );
}

// ---------------------------------------------------------------------------
// Discord — notification-only (buttons need a public Interactions endpoint,
// which a self-hosted tailnet server usually is not). Upgrade path: expose
// /api/notifications/discord/interactions behind a public URL + ed25519 verify.
// ---------------------------------------------------------------------------

async function sendDiscordChannel({ payload }: ChannelSendInput): Promise<void> {
  const webhookUrl = getDiscordWebhookUrl();
  if (!webhookUrl) {
    return;
  }
  // Webhooks are app-level — the per-user channel preference is the only gate.

  const text = [payload.title, payload.body].filter(Boolean).join('\n').slice(0, 1900);
  const response = await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ content: text }),
  });
  if (!response.ok) {
    throw new Error(`Discord webhook failed: ${response.status}`);
  }
}

// ---------------------------------------------------------------------------
// Channel entries plugged into notification-orchestrator.service.js
// ---------------------------------------------------------------------------

type ChannelPreferences = { channels?: Record<string, boolean> };

/** Consumed by notification-orchestrator.service.js's channel list. */
export const telegramChannel = {
  id: 'telegram',
  isEnabled: (preferences: ChannelPreferences | null | undefined) =>
    Boolean(preferences?.channels?.telegram),
  send: sendTelegramChannel,
};

/** Consumed by notification-orchestrator.service.js's channel list. */
export const discordChannel = {
  id: 'discord',
  isEnabled: (preferences: ChannelPreferences | null | undefined) =>
    Boolean(preferences?.channels?.discord),
  send: sendDiscordChannel,
};
