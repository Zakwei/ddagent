import AsyncStorage from '@react-native-async-storage/async-storage';
import { createAudioPlayer, setAudioModeAsync } from 'expo-audio';

/**
 * The web builds its completion tone with the Web Audio API (two sine blips:
 * 740 Hz then 988 Hz). React Native has no Web Audio, so the same tone is
 * bundled as a WAV and played through expo-audio.
 */
// ponytail: one pre-rendered WAV instead of a synth; fine for a two-note blip.
const TONE = require('../../assets/notification.wav');
const SOUND_ENABLED_KEY = 'notificationSoundEnabled';

let enabled = true;
let hydrated = false;
let player: ReturnType<typeof createAudioPlayer> | null = null;

async function hydrate(): Promise<void> {
  if (hydrated) return;
  hydrated = true;
  try {
    const raw = await AsyncStorage.getItem(SOUND_ENABLED_KEY);
    if (raw !== null) enabled = raw !== 'false';
  } catch {
    // Ignore — default to enabled.
  }
}

/** Persists whether the completion tone plays (mirrors web `notificationSoundEnabled`). */
export async function setNotificationSoundEnabled(next: boolean): Promise<void> {
  enabled = next;
  hydrated = true;
  try {
    await AsyncStorage.setItem(SOUND_ENABLED_KEY, String(next));
  } catch {
    // Ignore persist failures.
  }
}

/** Plays the completion tone once. Best-effort — silent failures are ignored. */
export async function playNotificationSound(force = false): Promise<void> {
  await hydrate();
  if (!force && !enabled) return;
  try {
    await setAudioModeAsync({ playsInSilentMode: true });
    if (!player) player = createAudioPlayer(TONE);
    player.seekTo(0);
    player.play();
  } catch {
    // Audio may be unavailable (silent mode, missing module) — never block.
  }
}
