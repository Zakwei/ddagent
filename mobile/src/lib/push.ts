import { Linking, Platform } from 'react-native';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import * as TaskManager from 'expo-task-manager';
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

/** Actionable approval push: category id shared by the local notification and iOS aps.category. */
const APPROVAL_CATEGORY = 'TOOL_APPROVAL';
const APPROVAL_ACTIONS: Record<string, 'allow' | 'deny' | 'always'> = {
  APPROVE: 'allow',
  DENY: 'deny',
  ALWAYS: 'always',
};

/**
 * Resolves a pending approval straight from a notification action — no app
 * foregrounding needed. 409 means another client already answered it.
 */
async function resolveApproval(requestId: string, decision: 'allow' | 'deny' | 'always') {
  const response = await authenticatedFetch(`/api/notifications/approvals/${encodeURIComponent(requestId)}`, {
    method: 'POST',
    body: JSON.stringify({ decision }),
  });
  if (response.status === 409) {
    const Notifications = getNotifications();
    await Notifications?.scheduleNotificationAsync({
      content: { title: 'ddagent', body: 'This request was already resolved.' },
      trigger: null,
    });
  }
}

const BACKGROUND_NOTIFICATION_TASK = 'ddagent-approval-push';

/**
 * Android data-only FCM messages arrive here while the app is backgrounded —
 * the system never renders them, so the task posts a local notification with
 * the approval action buttons. Must be defined at module scope, before the app
 * registers; a no-op under Expo Go (no expo-notifications there anyway).
 */
if (!inExpoGo) {
  try {
    TaskManager.defineTask(BACKGROUND_NOTIFICATION_TASK, async ({ data, error }) => {
      if (error) return;
      const Notifications = getNotifications();
      if (!Notifications) return;
      const payload = (data ?? {}) as Record<string, string>;
      if (payload.code !== 'permission.required') return;
      await Notifications.scheduleNotificationAsync({
        content: {
          title: payload.title ?? 'ddagent',
          body: payload.body ?? 'A tool needs your approval',
          data: payload,
          categoryIdentifier: APPROVAL_CATEGORY,
        },
        trigger: null,
      });
    });
  } catch {
    // TaskManager.defineTask throws when the native module is missing (Expo Go).
  }
}

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
      // Route data-only FCM messages (approval pushes) to the background task.
      await Notifications.registerTaskAsync(BACKGROUND_NOTIFICATION_TASK);
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

  // Approve/Deny/Always directly on the notification — resolves over REST
  // without opening the app. Works for iOS aps.category pushes and for the
  // local notifications the Android background task posts.
  void Notifications.setNotificationCategoryAsync(APPROVAL_CATEGORY, [
    { identifier: 'APPROVE', buttonTitle: 'Approve', options: { opensAppToForeground: false } },
    { identifier: 'DENY', buttonTitle: 'Deny', options: { opensAppToForeground: false, isDestructive: true } },
    { identifier: 'ALWAYS', buttonTitle: 'Always allow', options: { opensAppToForeground: false } },
  ]);

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
    const data = response.notification.request.content.data as Record<string, unknown>;
    const decision = APPROVAL_ACTIONS[response.actionIdentifier];
    const requestId = typeof data?.requestId === 'string' ? data.requestId : null;
    if (decision && requestId) {
      void resolveApproval(requestId, decision).catch((err) =>
        console.warn('[push] approval resolve failed:', err instanceof Error ? err.message : err),
      );
      return;
    }
    const sessionId = data?.sessionId;
    if (typeof sessionId === 'string' && sessionId) {
      void Linking.openURL(`ddagent://chat/${encodeURIComponent(sessionId)}`);
    }
  });
  return () => sub.remove();
}
