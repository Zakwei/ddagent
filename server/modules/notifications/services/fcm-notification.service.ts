/**
 * FCM push channel for the React Native app.
 *
 * Device tokens register through the generic `POST /api/notifications/endpoints/current`
 * route with `channel: 'fcm'` — no dedicated route needed. Sending goes through
 * FCM HTTP v1 via firebase-admin, which is initialized lazily from either:
 *   - FCM_SERVICE_ACCOUNT — service-account JSON as a string, or
 *   - GOOGLE_APPLICATION_CREDENTIALS — path to the JSON file (admin SDK default).
 * Without credentials the channel stays inert (one warning, no throws) so
 * self-hosted installs that never configure Firebase are unaffected.
 */

import { notificationChannelEndpointsDb } from '@/modules/database/index.js';

const FCM_CHANNEL = 'fcm';

type AdminMessaging = typeof import('firebase-admin/messaging');

let adminApp: import('firebase-admin/app').App | null | undefined;
let warnedMissingCreds = false;

/** Consumed by notification-orchestrator.service.js — resolves the admin app once. */
async function getAdminApp(): Promise<import('firebase-admin/app').App | null> {
  if (adminApp !== undefined) return adminApp;
  try {
    const { initializeApp, cert, applicationDefault, getApps } = await import('firebase-admin/app');
    const existing = getApps();
    if (existing.length > 0) {
      adminApp = existing[0];
      return adminApp;
    }
    const json = process.env.FCM_SERVICE_ACCOUNT;
    if (json) {
      adminApp = initializeApp({ credential: cert(JSON.parse(json)) });
    } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      adminApp = initializeApp({ credential: applicationDefault() });
    } else {
      adminApp = null;
      if (!warnedMissingCreds) {
        warnedMissingCreds = true;
        console.warn('[fcm] no FCM_SERVICE_ACCOUNT / GOOGLE_APPLICATION_CREDENTIALS — fcm channel inert');
      }
    }
    return adminApp ?? null;
  } catch (err) {
    adminApp = null;
    console.error('[fcm] admin init failed:', err);
    return null;
  }
}

function toFcmMessage(payload: Record<string, any>) {
  const title = payload?.title ?? 'ddagent';
  const body = payload?.body ?? payload?.message ?? '';
  const data: Record<string, string> = {};
  // FCM data values must be strings; sessionId drives ddagent://chat/<id> taps.
  if (payload?.data && typeof payload.data === 'object') {
    for (const [k, v] of Object.entries(payload.data)) {
      if (v !== null && v !== undefined) data[k] = String(v);
    }
  }
  if (payload?.sessionId && !data.sessionId) data.sessionId = String(payload.sessionId);
  return {
    notification: { title: String(title), body: String(body) },
    data,
    android: { priority: 'high' as const },
  };
}

/**
 * Orchestrator channel sender. Delivers the normalized notification payload to
 * every enabled `fcm` endpoint of the user; dead tokens are disabled in place.
 */
export async function sendFcmNotificationToClients({
  userId,
  payload,
}: {
  userId: number;
  payload: Record<string, any>;
}): Promise<void> {
  const app = await getAdminApp();
  if (!app) return;

  const endpoints = notificationChannelEndpointsDb.getEnabledEndpoints(userId, FCM_CHANNEL);
  if (endpoints.length === 0) return;

  const { getMessaging } = (await import('firebase-admin/messaging')) as AdminMessaging & {
    getMessaging: AdminMessaging['getMessaging'];
  };
  const messaging = getMessaging(app);
  const base = toFcmMessage(payload);

  for (const ep of endpoints) {
    try {
      await messaging.send({ token: ep.endpoint_id, ...base });
      notificationChannelEndpointsDb.touchEndpoint(userId, FCM_CHANNEL, ep.endpoint_id);
    } catch (err: any) {
      const code = err?.code ?? '';
      if (code.includes('registration-token-not-registered') || code.includes('invalid-registration-token')) {
        notificationChannelEndpointsDb.setEndpointEnabled(userId, FCM_CHANNEL, ep.endpoint_id, false);
      }
      console.error(`[fcm] send failed for endpoint ${ep.endpoint_id.slice(0, 12)}…:`, code || err);
    }
  }
}
