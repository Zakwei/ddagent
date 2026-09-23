import { useCallback, useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { authenticatedFetch } from '../utils/api';

export type VoiceInputState = 'idle' | 'recording' | 'processing';

const MAX_RECORDING_MS = 5 * 60 * 1000;

function pickMimeType(): string {
  if (typeof MediaRecorder === 'undefined') return '';
  for (const candidate of ['audio/webm;codecs=opus', 'audio/webm', 'audio/mp4', 'audio/aac']) {
    if (MediaRecorder.isTypeSupported(candidate)) return candidate;
  }
  return '';
}

/**
 * Mic capture → POST /api/stt → transcript. Used by ChatComposer (desktop/web)
 * and the mobile composer action sheet — same MediaRecorder path on PWAs.
 */
export function useVoiceInput(onTranscript: (text: string) => void) {
  const { i18n } = useTranslation();
  const [state, setState] = useState<VoiceInputState>('idle');
  const [error, setError] = useState<string | null>(null);
  const [supported, setSupported] = useState<boolean | null>(null);
  const recorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);
  const stopTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    let cancelled = false;
    if (typeof MediaRecorder === 'undefined' || !navigator.mediaDevices?.getUserMedia) {
      setSupported(false);
      return;
    }
    authenticatedFetch('/api/stt/config')
      .then((res) => res.json())
      .then((data) => {
        if (!cancelled) setSupported(Boolean(data?.configured));
      })
      .catch(() => {
        if (!cancelled) setSupported(false);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const stop = useCallback(() => {
    if (stopTimerRef.current) {
      clearTimeout(stopTimerRef.current);
      stopTimerRef.current = null;
    }
    recorderRef.current?.stop();
  }, []);

  const start = useCallback(async () => {
    setError(null);
    const mimeType = pickMimeType();
    let stream: MediaStream;
    try {
      stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    } catch {
      setError('microphone-denied');
      return;
    }

    const recorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined);
    recorderRef.current = recorder;
    chunksRef.current = [];

    recorder.ondataavailable = (event) => {
      if (event.data.size > 0) chunksRef.current.push(event.data);
    };
    recorder.onstop = async () => {
      stream.getTracks().forEach((track) => track.stop());
      const blob = new Blob(chunksRef.current, { type: recorder.mimeType || 'audio/webm' });
      if (blob.size === 0) {
        setState('idle');
        return;
      }
      setState('processing');
      try {
        const language = (i18n.language || 'en').split('-')[0];
        const response = await authenticatedFetch(`/api/stt?language=${language}`, {
          method: 'POST',
          headers: { 'Content-Type': blob.type || 'application/octet-stream' },
          body: blob,
        });
        const data = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(data?.error || `stt ${response.status}`);
        if (typeof data.text === 'string' && data.text.trim()) {
          onTranscript(data.text.trim());
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'stt-failed');
      } finally {
        setState('idle');
      }
    };

    recorder.start();
    setState('recording');
    stopTimerRef.current = setTimeout(stop, MAX_RECORDING_MS);
  }, [i18n.language, onTranscript, stop]);

  const toggle = useCallback(() => {
    if (state === 'recording') stop();
    else if (state === 'idle') void start();
  }, [state, start, stop]);

  useEffect(() => stop, [stop]);

  return { state, error, supported: supported === true, toggle };
}
