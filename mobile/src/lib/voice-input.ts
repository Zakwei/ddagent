import {
  RecordingPresets,
  requestRecordingPermissionsAsync,
  setAudioModeAsync,
  useAudioRecorder,
} from 'expo-audio';
import { useCallback, useEffect, useRef, useState } from 'react';

import { authenticatedFetch } from '~shared/utils/api';

export type VoiceInputState = 'idle' | 'recording' | 'processing';

/** Web `MAX_RECORDING_MS` — auto-stop after five minutes. */
export const MAX_RECORDING_MS = 5 * 60 * 1000;

let cachedSupport: boolean | null = null;
let supportProbe: Promise<boolean> | null = null;

/** Mirrors web `useVoiceInput` support probe: GET /api/stt/config → configured. */
export async function checkVoiceInputSupport(): Promise<boolean> {
  if (cachedSupport !== null) return cachedSupport;
  if (!supportProbe) {
    supportProbe = authenticatedFetch('/api/stt/config')
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => Boolean(d?.configured ?? d?.data?.configured))
      .catch(() => false)
      .then((supported) => {
        cachedSupport = supported;
        return supported;
      });
  }
  return supportProbe;
}

/**
 * Push-to-dictate for the mobile composer. expo-audio records m4a/AAC, the
 * clip goes up as FormData (RN's only file-upload path) to /api/stt, and the
 * transcript lands in the draft. Mirrors web `useVoiceInput` — the server is
 * probed once for STT support and the recording auto-stops at 5 minutes.
 */
export function useVoiceInput(onTranscript: (text: string) => void, language?: string) {
  const recorder = useAudioRecorder(RecordingPresets.HIGH_QUALITY);
  const [state, setState] = useState<VoiceInputState>('idle');
  const [error, setError] = useState<string | null>(null);
  const [supported, setSupported] = useState<boolean>(cachedSupport ?? true);
  const capRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    let alive = true;
    void checkVoiceInputSupport().then((ok) => {
      if (alive) setSupported(ok);
    });
    return () => {
      alive = false;
      if (capRef.current) clearTimeout(capRef.current);
    };
  }, []);

  const stop = useCallback(async () => {
    if (capRef.current) {
      clearTimeout(capRef.current);
      capRef.current = null;
    }
    try {
      await recorder.stop();
      const uri = recorder.uri;
      setState('processing');
      if (!uri) {
        setState('idle');
        return;
      }

      const form = new FormData();
      // RN fetch serializes {uri,name,type} entries into multipart bodies.
      form.append('file', { uri, name: 'voice.m4a', type: 'audio/m4a' } as unknown as Blob);
      const lang = (language ?? 'en').split('-')[0];
      const response = await authenticatedFetch(`/api/stt?language=${encodeURIComponent(lang)}`, { method: 'POST', body: form });
      const data = await response.json().catch(() => ({}));
      if (!response.ok) throw new Error(data?.error || `stt ${response.status}`);
      if (typeof data.text === 'string' && data.text.trim()) {
        onTranscript(data.text.trim());
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'stt-failed');
    } finally {
      setState('idle');
      void setAudioModeAsync({ playsInSilentMode: false }).catch(() => undefined);
    }
  }, [recorder, onTranscript, language]);

  const toggle = useCallback(async () => {
    setError(null);
    if (state === 'recording') {
      await stop();
      return;
    }
    const permission = await requestRecordingPermissionsAsync();
    if (!permission.granted) {
      setError('microphone-denied');
      return;
    }
    try {
      await setAudioModeAsync({ playsInSilentMode: true, allowsRecording: true });
      await recorder.prepareToRecordAsync();
      recorder.record();
      setState('recording');
      capRef.current = setTimeout(() => {
        void stop();
      }, MAX_RECORDING_MS);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'record-failed');
    }
  }, [state, recorder, stop]);

  return { state, error, supported, toggle };
}
