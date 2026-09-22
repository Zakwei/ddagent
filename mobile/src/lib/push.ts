import { Linking, Platform } from 'react-native';
import * as Device from 'expo-device';
import * as Notifications from 'expo-notifications';
import { authenticatedFetch } from '~shared/utils/api';

/**
 * Native push registration. Posts the FCM device token to the generic
 * notification-endpoints route (`channel: 'fcm'`); the server sends through
 * firebase-admin when FCM_SERVICE_ACCOUNT is configured.
 *
 * getDevicePushTokenAsync needs google-services.json in the dev/production
 * build — in Expo Go (or without Firebase configured) it throws and we just
 * skip registration; the app works without push.
 */
export async function registerForPushNotifications(): Promise<void> {
  if (!Device.isDevice) return;
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
