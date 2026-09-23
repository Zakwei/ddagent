import { Bell, BellOff, BellRing, Loader2, Play, SendIcon, Volume2 } from 'lucide-react';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button } from '../../../../shared/view/ui';
import { playChatCompletionSound } from '../../../../utils/notificationSound';
import type { NotificationPreferencesState } from '../../types/types';

import MessengerChannelsSection from './notifications/MessengerChannelsSection';

type PushTestResult = {
  subscriptionCount: number;
  webPushConfigured: boolean;
  results: Array<{ endpointHost: string; ok: boolean; statusCode: number | null; error: string | null }>;
};

type NotificationsSettingsTabProps = {
  notificationPreferences: NotificationPreferencesState;
  onNotificationPreferencesChange: (value: NotificationPreferencesState) => void;
  pushPermission: NotificationPermission | 'unsupported';
  isPushSubscribed: boolean;
  isPushLoading: boolean;
  onEnablePush: () => void;
  onDisablePush: () => void;
  onTestPush?: () => Promise<PushTestResult | null>;
  isDesktop?: boolean;
  desktopNotifications?: {
    enabled: boolean;
    supported: boolean;
    connectedCount?: number;
    targetCount?: number;
    lastError?: string | null;
  } | null;
  onEnableDesktopNotifications?: () => void;
  onDisableDesktopNotifications?: () => void;
};

export default function NotificationsSettingsTab({
  notificationPreferences,
  onNotificationPreferencesChange,
  pushPermission,
  isPushSubscribed,
  isPushLoading,
  onEnablePush,
  onDisablePush,
  onTestPush,
  isDesktop = false,
  desktopNotifications = null,
  onEnableDesktopNotifications,
  onDisableDesktopNotifications,
}: NotificationsSettingsTabProps) {
  const { t } = useTranslation('settings');
  const [pushTestLoading, setPushTestLoading] = useState(false);
  const [pushTestResult, setPushTestResult] = useState<PushTestResult | null>(null);

  const pushSupported = pushPermission !== 'unsupported';
  const pushDenied = pushPermission === 'denied';

  const handleTestPush = async () => {
    if (!onTestPush) return;
    setPushTestLoading(true);
    setPushTestResult(null);
    try {
      setPushTestResult(await onTestPush());
    } finally {
      setPushTestLoading(false);
    }
  };

  const pushTestSummary = (() => {
    if (!pushTestResult) return null;
    if (pushTestResult.subscriptionCount === 0) {
      return {
        tone: 'error' as const,
        text: t('notifications.webPush.testNoSubscription', {
          defaultValue: 'No device is subscribed. Tap "Enable" on the phone first.',
        }),
      };
    }
    const failed = pushTestResult.results.filter((result) => !result.ok);
    if (failed.length === 0) {
      return {
        tone: 'success' as const,
        text: t('notifications.webPush.testSuccess', {
          count: pushTestResult.results.length,
          defaultValue: 'Sent to {{count}} device(s). If nothing appeared on the phone, add ddagent to the home screen (iOS requires this).',
        }),
      };
    }
    return {
      tone: 'error' as const,
      text: failed
        .map((result) => `${result.endpointHost}: ${result.statusCode ?? result.error ?? 'failed'}`)
        .join(' · '),
    };
  })();

  return (
    <div className="space-y-6 md:space-y-8">
      <div className="space-y-4">
        <div className="flex items-center gap-3">
          <Bell className="h-5 w-5 text-blue-600" />
          <h3 className="text-lg font-medium text-foreground">{t('notifications.title')}</h3>
        </div>
        <p className="text-sm text-muted-foreground">{t('notifications.description')}</p>
      </div>

      {isDesktop ? (
        <div className="space-y-4 rounded-lg border border-border bg-card p-4">
          <h4 className="font-medium text-foreground">
            {t('notifications.desktop.title', { defaultValue: 'Notify this desktop app' })}
          </h4>
          {desktopNotifications?.supported === false ? (
            <p className="text-sm text-muted-foreground">
              {t('notifications.desktop.unsupported', { defaultValue: 'Desktop notifications are not supported on this system.' })}
            </p>
          ) : (
            <div className="space-y-2">
              <div className="flex items-center gap-3">
                <button
                  type="button"
                  onClick={() => {
                    if (desktopNotifications?.enabled) {
                      onDisableDesktopNotifications?.();
                    } else {
                      onEnableDesktopNotifications?.();
                    }
                  }}
                  className={`inline-flex items-center gap-2 rounded-md px-4 py-2 text-sm font-medium transition-colors ${
                    desktopNotifications?.enabled
                      ? 'bg-red-100 text-red-700 hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50'
                      : 'bg-blue-600 text-white hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600'
                  }`}
                >
                  {desktopNotifications?.enabled ? (
                    <BellOff className="h-4 w-4" />
                  ) : (
                    <BellRing className="h-4 w-4" />
                  )}
                  {desktopNotifications?.enabled
                    ? t('notifications.desktop.disable', { defaultValue: 'Disable desktop notifications' })
                    : t('notifications.desktop.enable', { defaultValue: 'Enable desktop notifications' })}
                </button>
                {desktopNotifications?.enabled && (
                  <span className="text-sm text-green-600 dark:text-green-400">
                    {t('notifications.desktop.enabled', { defaultValue: 'Desktop notifications are enabled' })}
                  </span>
                )}
              </div>
              {desktopNotifications?.lastError && (
                <p className="text-sm text-red-600 dark:text-red-400">{desktopNotifications.lastError}</p>
              )}
            </div>
          )}
        </div>
      ) : (
        <div className="space-y-4 rounded-lg border border-border bg-card p-4">
          <h4 className="font-medium text-foreground">{t('notifications.webPush.title')}</h4>
          {!pushSupported ? (
            <p className="text-sm text-muted-foreground">{t('notifications.webPush.unsupported')}</p>
          ) : pushDenied ? (
            <p className="text-sm text-muted-foreground">{t('notifications.webPush.denied')}</p>
          ) : (
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <button
                  type="button"
                  disabled={isPushLoading}
                  onClick={() => {
                    if (isPushSubscribed) {
                      onDisablePush();
                    } else {
                      onEnablePush();
                    }
                  }}
                  className={`inline-flex items-center gap-2 rounded-md px-4 py-2 text-sm font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-50 ${
                    isPushSubscribed
                      ? 'bg-red-100 text-red-700 hover:bg-red-200 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50'
                      : 'bg-blue-600 text-white hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600'
                  }`}
                >
                  {isPushLoading ? (
                    <Loader2 className="h-4 w-4 animate-spin" />
                  ) : isPushSubscribed ? (
                    <BellOff className="h-4 w-4" />
                  ) : (
                    <BellRing className="h-4 w-4" />
                  )}
                  {isPushLoading
                    ? t('notifications.webPush.loading')
                    : isPushSubscribed
                      ? t('notifications.webPush.disable')
                      : t('notifications.webPush.enable')}
                </button>
                {isPushSubscribed && (
                  <span className="text-sm text-green-600 dark:text-green-400">
                    {t('notifications.webPush.enabled')}
                  </span>
                )}
              </div>

              {isPushSubscribed && onTestPush && (
                <div className="space-y-2">
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    disabled={pushTestLoading}
                    onClick={() => void handleTestPush()}
                  >
                    {pushTestLoading ? (
                      <Loader2 className="h-4 w-4 animate-spin" />
                    ) : (
                      <SendIcon className="h-4 w-4" />
                    )}
                    {t('notifications.webPush.test', { defaultValue: 'Send test notification' })}
                  </Button>
                  {pushTestSummary && (
                    <p
                      className={`text-xs ${
                        pushTestSummary.tone === 'success'
                          ? 'text-green-600 dark:text-green-400'
                          : 'text-red-600 dark:text-red-400'
                      }`}
                    >
                      {pushTestSummary.text}
                    </p>
                  )}
                </div>
              )}

              <p className="text-xs text-muted-foreground">
                {t('notifications.webPush.iosHint', {
                  defaultValue:
                    'On iPhone/iPad, notifications only work after adding ddagent to the home screen (Share → Add to Home Screen) and enabling them from that installed app.',
                })}
              </p>
            </div>
          )}
        </div>
      )}

      <div className="space-y-4 rounded-lg border border-border bg-card p-4">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div className="space-y-1">
            <div className="flex items-center gap-2">
              <Volume2 className="h-4 w-4 text-blue-600" />
              <h4 className="font-medium text-foreground">
                {t('notifications.sound.title', { defaultValue: 'Sound' })}
              </h4>
            </div>
            <p className="text-sm text-muted-foreground">
              {t('notifications.sound.description', {
                defaultValue: 'Play a short tone when a chat run finishes.',
              })}
            </p>
          </div>

          <label className="flex shrink-0 items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              checked={notificationPreferences.channels.sound}
              onChange={(event) =>
                onNotificationPreferencesChange({
                  ...notificationPreferences,
                  channels: {
                    ...notificationPreferences.channels,
                    sound: event.target.checked,
                  },
                })
              }
              className="h-4 w-4"
            />
            {t('notifications.sound.enabled', { defaultValue: 'Enabled' })}
          </label>
        </div>

        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => {
            void playChatCompletionSound({ force: true });
          }}
        >
          <Play className="h-4 w-4" />
          {t('notifications.sound.test', { defaultValue: 'Test sound' })}
        </Button>
      </div>

      <MessengerChannelsSection
        notificationPreferences={notificationPreferences}
        onNotificationPreferencesChange={onNotificationPreferencesChange}
      />

      <div className="space-y-4 rounded-lg border border-border bg-card p-4">
        <h4 className="font-medium text-foreground">{t('notifications.events.title')}</h4>
        <div className="space-y-3">
          <label className="flex items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              checked={notificationPreferences.events.actionRequired}
              onChange={(event) =>
                onNotificationPreferencesChange({
                  ...notificationPreferences,
                  events: {
                    ...notificationPreferences.events,
                    actionRequired: event.target.checked,
                  },
                })
              }
              className="h-4 w-4"
            />
            {t('notifications.events.actionRequired')}
          </label>

          <label className="flex items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              checked={notificationPreferences.events.stop}
              onChange={(event) =>
                onNotificationPreferencesChange({
                  ...notificationPreferences,
                  events: {
                    ...notificationPreferences.events,
                    stop: event.target.checked,
                  },
                })
              }
              className="h-4 w-4"
            />
            {t('notifications.events.stop')}
          </label>

          <label className="flex items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              checked={notificationPreferences.events.error}
              onChange={(event) =>
                onNotificationPreferencesChange({
                  ...notificationPreferences,
                  events: {
                    ...notificationPreferences.events,
                    error: event.target.checked,
                  },
                })
              }
              className="h-4 w-4"
            />
            {t('notifications.events.error')}
          </label>
        </div>
      </div>
    </div>
  );
}
