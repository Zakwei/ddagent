import { appConfigDb, notificationChannelEndpointsDb } from '@/modules/database/index.js';
import {
  callTelegramApi,
  getTelegramBotToken,
} from '@/modules/notifications/services/messenger-channels.service.js';
import {
  resolveRemoteApproval,
  type RemoteApprovalAction,
} from '@/modules/notifications/services/remote-approval.service.js';

const OFFSET_KEY = 'messenger.telegram.updateOffset';
const POLL_TIMEOUT_SECONDS = 25;
const ERROR_BACKOFF_MS = 5_000;
const CONFLICT_BACKOFF_MS = 30_000;
const DETECTED_CHATS_LIMIT = 50;

/** A chat that recently wrote to the bot — candidate for pairing. */
export type DetectedTelegramChat = {
  chatId: string;
  title: string;
  type: string;
  seenAt: string;
};

type TelegramUpdate = {
  update_id: number;
  message?: {
    chat?: { id?: number | string; title?: string; username?: string; first_name?: string; type?: string };
  };
  callback_query?: {
    id?: string;
    data?: string;
    message?: { chat?: { id?: number | string }; message_id?: number };
  };
};

let running = false;
let loopPromise: Promise<void> | null = null;
const detectedChats = new Map<string, DetectedTelegramChat>();

type TelegramChat = {
  id?: number | string;
  title?: string;
  username?: string;
  first_name?: string;
  type?: string;
};

function rememberChat(chat: TelegramChat | undefined): void {
  const id = chat?.id;
  if (id === undefined || id === null || !chat) {
    return;
  }
  const chatId = String(id);
  detectedChats.set(chatId, {
    chatId,
    title: chat.title ?? chat.username ?? chat.first_name ?? chatId,
    type: chat.type ?? 'unknown',
    seenAt: new Date().toISOString(),
  });
  if (detectedChats.size > DETECTED_CHATS_LIMIT) {
    const oldest = detectedChats.keys().next().value;
    if (oldest !== undefined) detectedChats.delete(oldest);
  }
}

/** Consumed by notifications.routes.ts to render the pairing list. */
export function getDetectedTelegramChats(): DetectedTelegramChat[] {
  return [...detectedChats.values()].sort((a, b) => b.seenAt.localeCompare(a.seenAt));
}

function isChatWhitelisted(chatId: string): boolean {
  return notificationChannelEndpointsDb.isEndpointEnabledForAnyUser('telegram', chatId);
}

function describeDecision(action: RemoteApprovalAction): string {
  return action === 'allow' ? '✅ Allowed' : action === 'deny' ? '⛔ Denied' : '♾️ Always allowed';
}

async function handleCallbackQuery(token: string, query: NonNullable<TelegramUpdate['callback_query']>): Promise<void> {
  const data = typeof query.data === 'string' ? query.data : '';
  const chatId = query.message?.chat?.id !== undefined ? String(query.message.chat.id) : '';
  const answer = (text: string) =>
    query.id
      ? callTelegramApi(token, 'answerCallbackQuery', { callback_query_id: query.id, text }).catch(() => undefined)
      : undefined;

  const match = /^ap:([0-9a-f-]{8,64}):([adw])$/.exec(data);
  if (!match) {
    await answer('Unknown action');
    return;
  }
  if (!chatId || !isChatWhitelisted(chatId)) {
    await answer('This chat is not paired with ddagent');
    return;
  }

  const action: RemoteApprovalAction = match[2] === 'a' ? 'allow' : match[2] === 'd' ? 'deny' : 'always';
  const result = await resolveRemoteApproval(match[1], action);
  const reply = result.ok ? describeDecision(action) : '⚠️ Request expired or already resolved';
  await answer(reply);

  const messageId = query.message?.message_id;
  if (result.ok && chatId && messageId !== undefined) {
    // Strip the keyboard so nobody can re-tap a resolved approval.
    await callTelegramApi(token, 'editMessageReplyMarkup', {
      chat_id: chatId,
      message_id: messageId,
      reply_markup: { inline_keyboard: [] },
    }).catch(() => undefined);
  }
}

async function pollOnce(token: string): Promise<number | null> {
  const stored = appConfigDb.get(OFFSET_KEY);
  const offset = stored ? Number(stored) : 0;
  const response = (await callTelegramApi(token, 'getUpdates', {
    offset,
    timeout: POLL_TIMEOUT_SECONDS,
    allowed_updates: ['message', 'callback_query'],
  })) as { result?: TelegramUpdate[] };

  let maxId: number | null = null;
  for (const update of response.result ?? []) {
    maxId = Math.max(maxId ?? 0, update.update_id);
    if (update.message?.chat) {
      rememberChat(update.message.chat);
    }
    if (update.callback_query) {
      await handleCallbackQuery(token, update.callback_query).catch((error) => {
        console.error('[telegram] callback handling failed:', error instanceof Error ? error.message : error);
      });
    }
  }

  if (maxId !== null) {
    const next = maxId + 1;
    appConfigDb.set(OFFSET_KEY, String(next));
    return next;
  }
  return null;
}

async function loop(): Promise<void> {
  while (running) {
    const token = getTelegramBotToken();
    if (!token) {
      await new Promise((resolve) => setTimeout(resolve, 10_000));
      continue;
    }
    try {
      await pollOnce(token);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[telegram] poll error:', message);
      // 401 = bad token, 409 = another getUpdates consumer (e.g. second instance)
      const backoff = message.includes('409') ? CONFLICT_BACKOFF_MS : ERROR_BACKOFF_MS;
      await new Promise((resolve) => setTimeout(resolve, backoff));
    }
  }
}

/** Called by the server entrypoint after configureWebPush(). */
export function startTelegramPoller(): void {
  if (running) {
    return;
  }
  running = true;
  loopPromise = loop();
}

/** Called on server shutdown and after bot token changes. */
export async function stopTelegramPoller(): Promise<void> {
  running = false;
  if (loopPromise) {
    await loopPromise.catch(() => undefined);
    loopPromise = null;
  }
}

/** Consumed by notifications.routes.ts after a new bot token is saved. */
export async function restartTelegramPoller(): Promise<void> {
  await stopTelegramPoller();
  startTelegramPoller();
}
