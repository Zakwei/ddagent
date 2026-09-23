import { Check, Loader2, MessageSquare, RefreshCw, SendIcon, Trash2 } from 'lucide-react';
import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button } from '../../../../../shared/view/ui';
import { authenticatedFetch } from '../../../../../utils/api';
import type { NotificationPreferencesState } from '../../../types/types';

type ChannelConfig = { configured: boolean };
type DetectedChat = { chatId: string; title: string; type: string; seenAt: string };
type PairedEndpoint = { endpointId: string; label: string | null; enabled: boolean };

type MessengerChannelsSectionProps = {
  notificationPreferences: NotificationPreferencesState;
  onNotificationPreferencesChange: (value: NotificationPreferencesState) => void;
};

async function apiFetch(path: string, options: RequestInit = {}) {
  const response = await authenticatedFetch(path, {
    ...options,
    ...(options.body ? { body: JSON.stringify(options.body) } : {}),
  });
  return response.json().catch(() => ({}));
}

export default function MessengerChannelsSection({
  notificationPreferences,
  onNotificationPreferencesChange,
}: MessengerChannelsSectionProps) {
  const { t } = useTranslation('settings');
  const [config, setConfig] = useState<{ telegram: ChannelConfig; discord: ChannelConfig } | null>(null);
  const [botToken, setBotToken] = useState('');
  const [webhookUrl, setWebhookUrl] = useState('');
  const [detected, setDetected] = useState<DetectedChat[]>([]);
  const [paired, setPaired] = useState<PairedEndpoint[]>([]);
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const refresh = useCallback(async () => {
    const [cfg, chats] = await Promise.all([
      apiFetch('/api/notifications/channels/config'),
      apiFetch('/api/notifications/channels/telegram/chats'),
    ]);
    if (cfg?.config) setConfig(cfg.config);
    if (chats?.success) {
      setDetected(chats.detected ?? []);
      setPaired(chats.paired ?? []);
    }
  }, []);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  const run = async (key: string, fn: () => Promise<unknown>) => {
    setBusy(key);
    setError(null);
    try {
      const result = (await fn()) as { error?: string };
      if (result?.error) setError(result.error);
      await refresh();
    } finally {
      setBusy(null);
    }
  };

  const saveTelegram = () =>
    run('tg-save', () =>
      apiFetch('/api/notifications/channels/telegram/config', {
        method: 'PUT',
        body: { botToken } as unknown as BodyInit,
      }));

  const saveDiscord = () =>
    run('dc-save', () =>
      apiFetch('/api/notifications/channels/discord/config', {
        method: 'PUT',
        body: { webhookUrl } as unknown as BodyInit,
      }));

  const testChannel = (channel: string) =>
    run(`test-${channel}`, () =>
      apiFetch(`/api/notifications/channels/${channel}/test`, { method: 'POST' }));

  const pairChat = (chat: DetectedChat) =>
    run(`pair-${chat.chatId}`, () =>
      apiFetch('/api/notifications/endpoints/current', {
        method: 'POST',
        body: { channel: 'telegram', endpointId: chat.chatId, label: chat.title } as unknown as BodyInit,
      }));

  const unpairChat = (endpointId: string) =>
    run(`unpair-${endpointId}`, () =>
      apiFetch(`/api/notifications/endpoints/telegram/${endpointId}`, { method: 'DELETE' }));

  const toggleChannel = (channel: 'telegram' | 'discord', enabled: boolean) =>
    onNotificationPreferencesChange({
      ...notificationPreferences,
      channels: { ...notificationPreferences.channels, [channel]: enabled },
    });

  const inputClass =
    'w-full rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground';

  return (
    <div className="space-y-4 rounded-lg border border-border bg-card p-4">
      <div className="flex items-center gap-2">
        <MessageSquare className="h-4 w-4 text-blue-600" />
        <h4 className="font-medium text-foreground">
          {t('notifications.messaging.title', { defaultValue: 'Messenger approvals' })}
        </h4>
      </div>
      <p className="text-sm text-muted-foreground">
        {t('notifications.messaging.description', {
          defaultValue:
            'Approve or deny agent permission requests from Telegram, and get run notifications on Discord.',
        })}
      </p>

      {error && <p className="text-sm text-red-600 dark:text-red-400">{error}</p>}

      {/* Telegram */}
      <div className="space-y-3 rounded-md border border-border/60 p-3">
        <div className="flex items-center justify-between gap-3">
          <h5 className="text-sm font-medium text-foreground">
            Telegram {config?.telegram.configured ? '✓' : ''}
          </h5>
          <label className="flex items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              className="h-4 w-4"
              checked={Boolean(notificationPreferences.channels.telegram)}
              onChange={(e) => toggleChannel('telegram', e.target.checked)}
            />
            {t('notifications.messaging.enabled', { defaultValue: 'Enabled' })}
          </label>
        </div>

        <div className="flex flex-col gap-2 sm:flex-row">
          <input
            type="password"
            className={inputClass}
            placeholder={t('notifications.messaging.telegramToken', {
              defaultValue: 'Bot token from @BotFather (123456:ABC…)',
            })}
            value={botToken}
            onChange={(e) => setBotToken(e.target.value)}
          />
          <Button
            type="button"
            variant="outline"
            size="sm"
            disabled={busy === 'tg-save' || !botToken.trim()}
            onClick={() => void saveTelegram()}
          >
            {busy === 'tg-save' ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
            {t('notifications.messaging.save', { defaultValue: 'Save' })}
          </Button>
        </div>

        {config?.telegram.configured && (
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <p className="text-xs text-muted-foreground">
                {t('notifications.messaging.telegramHint', {
                  defaultValue: 'Send any message to your bot, then pair the chat below.',
                })}
              </p>
              <div className="flex gap-2">
                <Button type="button" variant="outline" size="sm" onClick={() => void refresh()}>
                  <RefreshCw className="h-3.5 w-3.5" />
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  disabled={busy === 'test-telegram' || paired.length === 0}
                  onClick={() => void testChannel('telegram')}
                >
                  {busy === 'test-telegram' ? (
                    <Loader2 className="h-4 w-4 animate-spin" />
                  ) : (
                    <SendIcon className="h-4 w-4" />
                  )}
                  {t('notifications.messaging.test', { defaultValue: 'Test' })}
                </Button>
              </div>
            </div>

            {paired.map((chat) => (
              <div key={chat.endpointId} className="flex items-center justify-between rounded border border-border/60 px-2 py-1.5 text-sm">
                <span className="text-foreground">
                  {chat.label || chat.endpointId}
                  <span className="ml-2 text-xs text-muted-foreground">{chat.endpointId}</span>
                </span>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  disabled={busy === `unpair-${chat.endpointId}`}
                  onClick={() => void unpairChat(chat.endpointId)}
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              </div>
            ))}

            {detected
              .filter((chat) => !paired.some((p) => p.endpointId === chat.chatId))
              .map((chat) => (
                <div key={chat.chatId} className="flex items-center justify-between rounded border border-dashed border-border px-2 py-1.5 text-sm">
                  <span className="text-muted-foreground">
                    {chat.title}
                    <span className="ml-2 text-xs">{chat.chatId}</span>
                  </span>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    disabled={busy === `pair-${chat.chatId}`}
                    onClick={() => void pairChat(chat)}
                  >
                    {busy === `pair-${chat.chatId}` ? (
                      <Loader2 className="h-4 w-4 animate-spin" />
                    ) : (
                      t('notifications.messaging.pair', { defaultValue: 'Pair' })
                    )}
                  </Button>
                </div>
              ))}
          </div>
        )}
      </div>

      {/* Discord */}
      <div className="space-y-3 rounded-md border border-border/60 p-3">
        <div className="flex items-center justify-between gap-3">
          <h5 className="text-sm font-medium text-foreground">
            Discord {config?.discord.configured ? '✓' : ''}
          </h5>
          <label className="flex items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              className="h-4 w-4"
              checked={Boolean(notificationPreferences.channels.discord)}
              onChange={(e) => toggleChannel('discord', e.target.checked)}
            />
            {t('notifications.messaging.enabled', { defaultValue: 'Enabled' })}
          </label>
        </div>
        <div className="flex flex-col gap-2 sm:flex-row">
          <input
            type="password"
            className={inputClass}
            placeholder={t('notifications.messaging.discordWebhook', {
              defaultValue: 'https://discord.com/api/webhooks/…',
            })}
            value={webhookUrl}
            onChange={(e) => setWebhookUrl(e.target.value)}
          />
          <div className="flex gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              disabled={busy === 'dc-save' || !webhookUrl.trim()}
              onClick={() => void saveDiscord()}
            >
              {busy === 'dc-save' ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
              {t('notifications.messaging.save', { defaultValue: 'Save' })}
            </Button>
            {config?.discord.configured && (
              <Button
                type="button"
                variant="outline"
                size="sm"
                disabled={busy === 'test-discord'}
                onClick={() => void testChannel('discord')}
              >
                {busy === 'test-discord' ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <SendIcon className="h-4 w-4" />
                )}
                {t('notifications.messaging.test', { defaultValue: 'Test' })}
              </Button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
