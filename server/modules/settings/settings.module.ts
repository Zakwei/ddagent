import {
  apiKeysDb,
  credentialsDb,
  notificationPreferencesDb,
  pushSubscriptionsDb,
} from '@/modules/database/index.js';
import {
  buildNotificationPayload,
  createNotificationEvent,
  getPublicKey,
  isWebPushConfigured,
  notifyUserIfEnabled,
  sendDesktopNotification,
  sendTestPush,
} from '@/modules/notifications/index.js';

import { createSettingsRouter } from './settings.routes.js';
import { createSettingsService } from './settings.service.js';

const settingsService = createSettingsService({
  apiKeys: {
    list: (userId) => apiKeysDb.getApiKeys(userId),
    create: (userId, keyName) => apiKeysDb.createApiKey(userId, keyName),
    remove: (userId, keyId) => apiKeysDb.deleteApiKey(userId, keyId),
    toggle: (userId, keyId, isActive) => apiKeysDb.toggleApiKey(userId, keyId, isActive),
  },
  credentials: {
    list: (userId, type) => credentialsDb.getCredentials(userId, type),
    create: (userId, name, type, value, description) =>
      credentialsDb.createCredential(userId, name, type, value, description),
    remove: (userId, credentialId) => credentialsDb.deleteCredential(userId, credentialId),
    toggle: (userId, credentialId, isActive) =>
      credentialsDb.toggleCredential(userId, credentialId, isActive),
  },
  notifications: {
    getPreferences: (userId) => notificationPreferencesDb.getPreferences(userId),
    updatePreferences: (userId, preferences) =>
      notificationPreferencesDb.updatePreferences(userId, preferences),
    createEnabledEvent: () => createNotificationEvent({
      provider: 'system', kind: 'info', code: 'push.enabled',
      meta: { message: 'Push notifications are now enabled!' }, severity: 'info',
    }),
    notifyUser: (userId, event) => notifyUserIfEnabled({ userId, event }),
  },
  pushSubscriptions: {
    save: (userId, endpoint, p256dh, auth) =>
      pushSubscriptionsDb.saveSubscription(userId, endpoint, p256dh, auth),
    remove: (endpoint) => pushSubscriptionsDb.removeSubscription(endpoint),
    count: (userId) => pushSubscriptionsDb.getSubscriptions(userId).length,
  },
  getVapidPublicKey: getPublicKey,
  sendTestPush: (userId) => sendTestPush(userId),
  // Desktop/WebSocket clients (the Flutter mobile + desktop apps) are not push
  // subscriptions, so the Web Push test never reaches them — deliver the same
  // test payload over that channel too.
  sendDesktopTestNotification: (userId) =>
    sendDesktopNotification(
      userId,
      buildNotificationPayload({
        provider: 'system',
        kind: 'info',
        code: 'agent.notification',
        meta: { message: 'Test notification from DDAgent' },
        createdAt: new Date().toISOString(),
      }),
    ),
  isWebPushConfigured,
});

/** Settings router assembled for the authenticated server mount. */
export const settingsRoutes = createSettingsRouter(settingsService);
