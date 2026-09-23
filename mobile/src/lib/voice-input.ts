import {
  RecordingPresets,
  requestRecordingPermissionsAsync,
  setAudioModeAsync,
  useAudioRecorder,
} from 'expo-audio';
import { useCallback, useState } from 'react';

import { authenticatedFetch } from '~shared/utils/api';

export type VoiceInputState = 'idle' | 'recording' | 'processing';

/**
 * Push-to-dictate for the mobile composer. expo-audio records m4a/AAC, the
 * clip goes up as FormData (RN's only file-upload path) to /api/stt, and the
 * transcript lands in the draft.
 */
export function useVoiceInput(onTranscript: (text: string) => void) {
  const recorder = useAudioRecorder(RecordingPresets.HIGH_QUALITY);
  const [state, setState] = useState<VoiceInputState>('idle');
  const [error, setError] = useState<string | null>(null);

  const stop = useCallback(async () => {
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
      const response = await authenticatedFetch('/api/stt', { method: 'POST', body: form });
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
  }, [recorder, onTranscript]);

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
    await setAudioModeAsync({ playsInSilentMode: true, allowsRecording: true });
    await recorder.prepareToRecordAsync();
    recorder.record();
    setState('recording');
  }, [state, recorder, stop]);

  return { state, error, toggle };
}
