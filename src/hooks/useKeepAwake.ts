import { useEffect } from 'react';

import { useUiPreferences } from './useUiPreferences';

type DesktopKeepAwakeBridge = {
  setKeepAwake?: (enabled: boolean) => Promise<unknown>;
};

type WakeLockSentinelLike = { release: () => Promise<void> };
type WakeLockNavigator = Navigator & {
  wakeLock?: { request: (type: 'screen') => Promise<WakeLockSentinelLike> };
};

/**
 * Keeps the machine/display awake while `active` (agent runs in progress) and
 * the user enabled the toggle. Desktop goes through the Electron bridge
 * (powerSaveBlocker); plain web falls back to the Screen Wake Lock API.
 */
export function useKeepAwake(active: boolean) {
  const { preferences } = useUiPreferences();
  const enabled = preferences.preventSleep && active;

  useEffect(() => {
    if (!enabled || typeof window === 'undefined') {
      return;
    }

    const desktop = (window as unknown as { ddagentBrowser?: DesktopKeepAwakeBridge })
      .ddagentBrowser;
    if (desktop?.setKeepAwake) {
      void desktop.setKeepAwake(true).catch(() => {});
      return () => {
        void desktop.setKeepAwake?.(false).catch(() => {});
      };
    }

    const nav = navigator as WakeLockNavigator;
    if (!nav.wakeLock) {
      return;
    }

    let sentinel: WakeLockSentinelLike | null = null;
    let disposed = false;

    const acquire = () => {
      void nav.wakeLock?.request('screen')
        .then((lock) => {
          if (disposed) {
            void lock.release().catch(() => {});
          } else {
            sentinel = lock;
          }
        })
        .catch(() => {});
    };

    // The wake lock is dropped when the tab hides — re-acquire on return.
    const onVisibilityChange = () => {
      if (document.visibilityState === 'visible') {
        acquire();
      }
    };

    acquire();
    document.addEventListener('visibilitychange', onVisibilityChange);

    return () => {
      disposed = true;
      document.removeEventListener('visibilitychange', onVisibilityChange);
      void sentinel?.release().catch(() => {});
      sentinel = null;
    };
  }, [enabled]);
}
