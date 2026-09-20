import { useCallback, useEffect, useState } from 'react';

import { authenticatedFetch } from '../utils/api';

type PushDeliveryResult = {
  endpointHost: string;
  ok: boolean;
  statusCode: number | null;
  error: string | null;
};

type PushTestResult = {
  subscriptionCount: number;
  webPushConfigured: boolean;
  results: PushDeliveryResult[];
};

type WebPushState = {
  permission: NotificationPermission | 'unsupported';
  isSubscribed: boolean;
  isLoading: boolean;
  subscribe: () => Promise<void>;
  unsubscribe: () => Promise<void>;
  sendTest: () => Promise<PushTestResult | null>;
};

function urlBase64ToUint8Array(base64String: string): Uint8Array {
  const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);
  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

export function useWebPush(): WebPushState {
  const [permission, setPermission] = useState<NotificationPermission | 'unsupported'>(() => {
    if (
      typeof window === 'undefined'
      || Boolean((window as any).ddagentDesktopNotifications)
      || !('Notification' in window)
      || !('serviceWorker' in navigator)
    ) {
      return 'unsupported';
    }
    return Notification.permission;
  });
  const [isSubscribed, setIsSubscribed] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // Re-register any existing browser subscription with the server on mount.
  // A subscription is stored per device, so without this a phone that already
  // granted permission would never be reachable after the server row is lost.
  useEffect(() => {
    if (permission === 'unsupported') return;

    navigator.serviceWorker.ready.then((registration) => {
      registration.pushManager.getSubscription().then((sub) => {
        setIsSubscribed(sub !== null);
        if (!sub) return;
        const subJson = sub.toJSON();
        if (!subJson.endpoint || !subJson.keys) return;
        void authenticatedFetch('/api/settings/push/subscribe', {
          method: 'POST',
          body: JSON.stringify({ endpoint: subJson.endpoint, keys: subJson.keys }),
        }).catch(() => {
          // A failed refresh only means the server keeps its previous record.
        });
      });
    }).catch(() => {
      // SW not ready yet
    });
  }, [permission]);

  const subscribe = useCallback(async () => {
    if (permission === 'unsupported') return;
    setIsLoading(true);

    try {
      const perm = await Notification.requestPermission();
      setPermission(perm);
      if (perm !== 'granted') return;

      const keyRes = await authenticatedFetch('/api/settings/push/vapid-public-key');
      const { publicKey } = await keyRes.json();

      const registration = await navigator.serviceWorker.ready;
      const subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(publicKey).buffer as ArrayBuffer,
      });

      const subJson = subscription.toJSON();
      await authenticatedFetch('/api/settings/push/subscribe', {
        method: 'POST',
        body: JSON.stringify({
          endpoint: subJson.endpoint,
          keys: subJson.keys,
        }),
      });

      setIsSubscribed(true);
    } catch (err) {
      console.error('Push subscribe failed:', err);
    } finally {
      setIsLoading(false);
    }
  }, [permission]);

  const unsubscribe = useCallback(async () => {
    setIsLoading(true);
    try {
      const registration = await navigator.serviceWorker.ready;
      const subscription = await registration.pushManager.getSubscription();
      if (subscription) {
        const endpoint = subscription.endpoint;
        await subscription.unsubscribe();
        await authenticatedFetch('/api/settings/push/unsubscribe', {
          method: 'POST',
          body: JSON.stringify({ endpoint }),
        });
      }
      setIsSubscribed(false);
    } catch (err) {
      console.error('Push unsubscribe failed:', err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  /**
   * Asks the server to push a test notification and returns the per-device
   * delivery outcome, so Settings can explain a phone that stays silent.
   */
  const sendTest = useCallback(async (): Promise<PushTestResult | null> => {
    try {
      const response = await authenticatedFetch('/api/settings/push/test', { method: 'POST' });
      if (!response.ok) {
        return null;
      }
      const payload = await response.json();
      return (payload?.data ?? payload) as PushTestResult;
    } catch (err) {
      console.error('Push test failed:', err);
      return null;
    }
  }, []);

  return { permission, isSubscribed, isLoading, subscribe, unsubscribe, sendTest };
}
