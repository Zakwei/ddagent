import { Linking, Platform } from 'react-native';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import { authenticatedFetch } from '~shared/utils/api';

/**
 * Native push registration. Posts the FCM device token to the generic
 * notification-endpoints route (`channel: 'fcm'`); the server sends through
 * firebase-admin when FCM_SERVICE_ACCOUNT is configured.
 *
 * Remote-push APIs were removed from Expo Go in SDK 53 — the module is
 * require()'d lazily so importing this file is safe, and everything no-ops in
 * Expo Go. getDevicePushTokenAsync also needs google-services.json in the
 * dev/production build; without Firebase configured it throws and we skip.
 */
const inExpoGo = Constants.appOwnership === 'expo';
type NotificationsModule = typeof import('expo-notifications');
const getNotifications = (): NotificationsModule | null =>
  inExpoGo ? null : (require('expo-notifications') as NotificationsModule);

export async function registerForPushNotifications(): Promise<void> {
  const Notifications = getNotifications();
  if (!Notifications || !Device.isDevice) return;
  try {
    const { status } = await Notifications.getPermissionsAsync();
    const granted =
      status === 'granted' || (await Notifications.requestPermissionsAsync()).status === 'granted';
    if (!granted) return;

    if (Platform.OS === 'android') {
      await Notifications.setNotificationChannelAsync('default', {
        name: 'Default',
        importance: Notifications.AndroidImportance.HIGH,
      });
    }

    const token = await Notifications.getDevicePushTokenAsync();
    const fcmToken = typeof token.data === 'string' ? token.data : String(token.data ?? '');
    if (!fcmToken) return;

    await authenticatedFetch('/api/notifications/endpoints/current', {
      method: 'POST',
      body: JSON.stringify({
        channel: 'fcm',
        endpointId: fcmToken,
        label: Device.modelName ?? 'mobile',
        metadata: { platform: Platform.OS },
        enabled: true,
      }),
    });
  } catch (err) {
    console.warn('[push] registration skipped:', err instanceof Error ? err.message : err);
  }
}

/**
 * Foreground display + tap→deep-link handling. Call once at app bootstrap.
 * Tapping a notification carrying data.sessionId opens ddagent://chat/<id>,
 * which the navigator's linking config resolves to the Chat screen.
 */
export function initPushHandlers(): () => void {
  const Notifications = getNotifications();
  if (!Notifications) return () => {};

  Notifications.setNotificationHandler({
    handleNotification: async () => ({
      shouldShowAlert: true,
      shouldShowBanner: true,
      shouldShowList: true,
      shouldPlaySound: false,
      shouldSetBadge: false,
    }),
  });

  const sub = Notifications.addNotificationResponseReceivedListener((response) => {
    const sessionId = response.notification.request.content.data?.sessionId;
    if (typeof sessionId === 'string' && sessionId) {
      void Linking.openURL(`ddagent://chat/${encodeURIComponent(sessionId)}`);
    }
  });
  return () => sub.remove();
}
