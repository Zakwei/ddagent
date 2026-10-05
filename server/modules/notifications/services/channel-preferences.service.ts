import { notificationChannelEndpointsDb, notificationPreferencesDb } from '@/modules/database/index.js';

/**
 * Recomputes a channel's on/off preference from its enabled endpoints and
 * persists it.
 *
 * The notification orchestrator gates delivery on `preferences.channels[channel]`,
 * so every endpoint mutation must run through here — the REST endpoint routes
 * and the `/desktop-notifications` websocket registration both call it. Without
 * this sync a registered device would create an enabled endpoint yet never
 * receive a notification because the channel preference stayed off.
 *
 * Consumed by `notifications.routes.ts` and
 * `services/desktop-notification-clients.service.ts`.
 */
export function syncChannelPreference(userId: number, channel: string) {
  const currentPreferences = notificationPreferencesDb.getPreferences(userId);
  const hasEnabledEndpoint =
    notificationChannelEndpointsDb.getEnabledEndpoints(userId, channel).length > 0;
  return notificationPreferencesDb.updatePreferences(userId, {
    ...currentPreferences,
    channels: { ...currentPreferences.channels, [channel]: hasEnabledEndpoint },
  });
}
