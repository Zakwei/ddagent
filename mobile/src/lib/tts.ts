import { useCallback, useState } from 'react';
import { createAudioPlayer, setAudioModeAsync, type AudioPlayer } from 'expo-audio';
import * as Speech from 'expo-speech';
import AsyncStorage from '@react-native-async-storage/async-storage';

import { api, getStoredAuthToken } from '~shared/utils/api';
import { getServerUrlSync } from './server-config';
import { speechText } from './chat-extras';

/**
 * Read-aloud with the same precedence as the web app: server neural TTS
 * (/api/tts, Edge voices) first, OS speechSynthesis as the offline fallback.
 */
const VOICE_STORAGE_KEY = 'voiceAutoRead.voiceName';

let preferredVoice = '';
let voiceHydrated = false;

export async function loadPreferredVoice(): Promise<string> {
  if (!voiceHydrated) {
    preferredVoice = (await AsyncStorage.getItem(VOICE_STORAGE_KEY).catch(() => null)) ?? '';
    voiceHydrated = true;
  }
  return preferredVoice;
}

export function getPreferredVoiceName(): string {
  return preferredVoice;
}

export async function setPreferredVoiceName(name: string): Promise<void> {
  preferredVoice = name;
  voiceHydrated = true;
  if (name) await AsyncStorage.setItem(VOICE_STORAGE_KEY, name).catch(() => {});
  else await AsyncStorage.removeItem(VOICE_STORAGE_KEY).catch(() => {});
}

export type SpeakVoiceOption = { id: string; name: string };

/** Neural voices from /api/tts when the backend serves them, else OS voices. */
export async function getSpeakVoiceOptions(): Promise<SpeakVoiceOption[]> {
  try {
    const res = await api.get('/tts/voices');
    if (res.ok) {
      const data = await res.json();
      if (Array.isArray(data?.voices) && data.voices.length > 0) {
        return data.voices.map((v: { id: string; name?: string }) => ({ id: String(v.id), name: String(v.name ?? v.id) }));
      }
    }
  } catch {
    /* fall through to OS voices */
  }
  try {
    const voices = await Speech.getAvailableVoicesAsync();
    return voices.map((v) => ({ id: v.identifier, name: v.name }));
  } catch {
    return [];
  }
}

let currentPlayer: AudioPlayer | null = null;
let currentOnEnd: (() => void) | undefined;
// Bumped by stopSpeaking so an in-flight request can't start playback after stop.
let speakGen = 0;

export function stopSpeaking(): void {
  speakGen++;
  try {
    currentPlayer?.pause();
    currentPlayer?.remove();
  } catch {
    /* player already released */
  }
  currentPlayer = null;
  void Speech.stop().catch(() => {});
  const onEnd = currentOnEnd;
  currentOnEnd = undefined;
  onEnd?.();
}

function speakViaSpeechSynthesis(text: string, hooks?: { onStart?: () => void; onEnd?: () => void }): void {
  const voice = getPreferredVoiceName();
  Speech.speak(text, {
    voice: voice || undefined,
    onStart: hooks?.onStart,
    onDone: hooks?.onEnd,
    onStopped: hooks?.onEnd,
    onError: hooks?.onEnd,
  });
}

async function speakViaServer(
  text: string,
  hooks?: { onStart?: () => void; onEnd?: () => void },
): Promise<'ok' | 'fail' | 'cancelled'> {
  const gen = speakGen;
  try {
    const params = new URLSearchParams({ text });
    const voice = getPreferredVoiceName();
    if (voice) params.set('voice', voice);
    const token = getStoredAuthToken();
    if (token) params.set('token', token);
    const url = `${getServerUrlSync()}/api/tts?${params.toString()}`;

    // ponytail: no POST+blob path — RN has no object-URL player. Very long
    // replies (>~7k URL chars) fall back to OS speech instead.
    if (url.length >= 8000) return 'fail';

    const player = createAudioPlayer({ uri: url });
    currentPlayer = player;
    let settled = false;
    const finish = (fallback: boolean) => {
      if (settled) return;
      settled = true;
      try {
        player.remove();
      } catch {
        /* already released */
      }
      if (currentPlayer === player) {
        currentPlayer = null;
        currentOnEnd = undefined;
      }
      if (fallback) {
        if (gen === speakGen) speakViaSpeechSynthesis(text, hooks);
      } else {
        hooks?.onEnd?.();
      }
    };
    player.addListener('playbackStatusUpdate', (status: { didJustFinish?: boolean; error?: string | null }) => {
      if (status?.error) finish(true);
      else if (status?.didJustFinish) finish(false);
    });
    void setAudioModeAsync({ playsInSilentMode: true }).catch(() => {});
    player.play();
    hooks?.onStart?.();
    return 'ok';
  } catch {
    return gen === speakGen ? 'fail' : 'cancelled';
  }
}

export function speakText(text: string, hooks?: { onStart?: () => void; onEnd?: () => void }): void {
  const cleaned = speechText(text);
  if (!cleaned) {
    hooks?.onEnd?.();
    return;
  }
  stopSpeaking();
  currentOnEnd = hooks?.onEnd;
  void speakViaServer(cleaned, hooks).then((result) => {
    if (result === 'fail') {
      currentOnEnd = hooks?.onEnd;
      speakViaSpeechSynthesis(cleaned, hooks);
    }
  });
}

/** Per-component speaking state for the read-aloud buttons. */
export function useTts(): { speaking: boolean; speak: (text: string) => void; stop: () => void } {
  const [speaking, setSpeaking] = useState(false);
  const speak = useCallback((text: string) => {
    setSpeaking(true);
    speakText(text, { onEnd: () => setSpeaking(false) });
  }, []);
  const stop = useCallback(() => {
    stopSpeaking();
    setSpeaking(false);
  }, []);
  return { speaking, speak, stop };
}
