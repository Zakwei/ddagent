import { activateKeepAwakeAsync, deactivateKeepAwake } from 'expo-keep-awake';

const TAG = 'ddagent-agent-run';

/**
 * Mirrors the web `preventSleep` preference: while an agent turn is running and
 * the user enabled the toggle, hold the screen awake. No-op on unmount/release.
 */
export async function acquireKeepAwake(): Promise<void> {
  try {
    await activateKeepAwakeAsync(TAG);
  } catch {
    // Keep-awake is best-effort; never surface failures to the UI.
  }
}

export async function releaseKeepAwake(): Promise<void> {
  try {
    await deactivateKeepAwake(TAG);
  } catch {
    // See acquireKeepAwake.
  }
}
