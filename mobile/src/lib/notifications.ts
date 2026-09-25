export type NotificationChannelPrefs = {
  channels: { inApp: boolean; sound: boolean; [key: string]: boolean };
  events: { actionRequired: boolean; stop: boolean; error: boolean };
};

export type PushEndpoint = { channel: string; endpointId: string; label?: string | null; enabled?: boolean };

export type TelegramChats = {
  detected: Array<{ chatId: string; title: string }>;
  paired: Array<{ endpointId: string; label: string | null }>;
};

/** Reads a notifications endpoint list from the `{success,endpoints}` or `{data}` envelope. */
export function parseEndpoints(payload: unknown): PushEndpoint[] {
  const root = payload as { endpoints?: unknown; data?: { endpoints?: unknown } } | null;
  const list = root?.endpoints ?? root?.data?.endpoints;
  if (!Array.isArray(list)) return [];
  return list
    .filter((item): item is Record<string, unknown> => Boolean(item) && typeof item === 'object')
    .map((item) => ({
      channel: String(item.channel ?? ''),
      endpointId: String(item.endpointId ?? item.endpoint_id ?? ''),
      label: typeof item.label === 'string' ? item.label : null,
      enabled: item.enabled !== false,
    }))
    .filter((item) => item.endpointId);
}

/** True when the notification preferences enable the given channel. */
export function isChannelEnabled(prefs: NotificationChannelPrefs | null, channel: string): boolean {
  if (!prefs) return false;
  return Boolean(prefs.channels[channel]);
}

/** Returns prefs with one channel toggled on/off (immutably). */
export function toggleChannelIn<T extends { channels: Record<string, boolean> }>(
  prefs: T,
  channel: string,
  enabled: boolean,
): T {
  return { ...prefs, channels: { ...prefs.channels, [channel]: enabled } };
}

/** Normalizes the telegram chats payload into detected/paired lists. */
export function parseTelegramChats(payload: unknown): TelegramChats {
  const root = payload as {
    detected?: unknown;
    paired?: unknown;
    data?: { detected?: unknown; paired?: unknown };
  } | null;
  const rawDetected = root?.detected ?? root?.data?.detected;
  const rawPaired = root?.paired ?? root?.data?.paired;
  const detected = Array.isArray(rawDetected)
    ? rawDetected
        .filter((c): c is Record<string, unknown> => Boolean(c) && typeof c === 'object')
        .map((c) => ({ chatId: String(c.chatId ?? c.chat_id ?? ''), title: String(c.title ?? '') }))
        .filter((c) => c.chatId)
    : [];
  const paired = Array.isArray(rawPaired)
    ? rawPaired
        .filter((c): c is Record<string, unknown> => Boolean(c) && typeof c === 'object')
        .map((c) => ({
          endpointId: String(c.endpointId ?? c.endpoint_id ?? ''),
          label: typeof c.label === 'string' ? c.label : null,
        }))
        .filter((c) => c.endpointId)
    : [];
  return { detected, paired };
}
