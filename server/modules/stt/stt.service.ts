import { appConfigDb } from '@/modules/database/index.js';

const ENDPOINT_KEY = 'stt.endpointUrl';
const API_KEY_KEY = 'stt.apiKey';
const MODEL_KEY = 'stt.model';

const DEFAULT_ENDPOINT = 'https://api.openai.com/v1';
const DEFAULT_MODEL = 'whisper-1';
const TRANSCRIBE_TIMEOUT_MS = 60_000;

export type SttConfig = {
  endpointUrl: string;
  apiKey: string | null;
  model: string;
};

type SttConfigInput = { endpointUrl?: string; apiKey?: string; model?: string };

/**
 * Resolves the speech-to-text backend. app_config wins over env vars so the
 * Settings UI can reconfigure a running server; an OpenAI-compatible
 * /audio/transcriptions endpoint (OpenAI, whisper.cpp, faster-whisper,
 * Speaches, ...) is expected.
 */
export function getSttConfig(): SttConfig {
  // `||` (not `??`) so a cleared-in-Settings empty string falls back to env.
  return {
    endpointUrl:
      appConfigDb.get(ENDPOINT_KEY) || process.env.STT_ENDPOINT_URL || DEFAULT_ENDPOINT,
    apiKey: appConfigDb.get(API_KEY_KEY) || process.env.STT_API_KEY || null,
    model: appConfigDb.get(MODEL_KEY) || process.env.STT_MODEL || DEFAULT_MODEL,
  };
}

/** Consumed by stt.routes.ts (PUT /config) — trims and persists; empty clears. */
export function setSttConfig(input: SttConfigInput): void {
  for (const [key, value] of [
    [ENDPOINT_KEY, input.endpointUrl],
    [API_KEY_KEY, input.apiKey],
    [MODEL_KEY, input.model],
  ] as const) {
    if (value === undefined) continue;
    const normalized = value.trim();
    if (normalized) appConfigDb.set(key, normalized);
    else appConfigDb.set(key, '');
  }
}

/** Configured = explicit endpoint saved (self-hosted whisper) or an API key
 * for the default OpenAI endpoint. */
export function isSttConfigured(): boolean {
  return Boolean(
    appConfigDb.get(ENDPOINT_KEY) ||
      process.env.STT_ENDPOINT_URL ||
      appConfigDb.get(API_KEY_KEY) ||
      process.env.STT_API_KEY
  );
}

/** Consumed by stt.routes.ts — forwards raw audio to the whisper-compatible
 * endpoint and returns { text }. */
export async function transcribeAudio(input: {
  audio: Buffer;
  mimeType: string;
  language?: string;
}): Promise<{ text: string }> {
  const config = getSttConfig();
  if (!isSttConfigured()) {
    throw new Error('STT is not configured');
  }

  const extension = input.mimeType.includes('mp4') || input.mimeType.includes('aac')
    ? 'audio.m4a'
    : input.mimeType.includes('mpeg')
      ? 'audio.mp3'
      : 'audio.webm';

  const form = new FormData();
  form.append('file', new Blob([new Uint8Array(input.audio)], { type: input.mimeType }), extension);
  form.append('model', config.model);
  if (input.language) {
    form.append('language', input.language);
  }

  const response = await fetch(`${config.endpointUrl.replace(/\/$/, '')}/audio/transcriptions`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${config.apiKey ?? 'ddagent'}` },
    body: form,
    signal: AbortSignal.timeout(TRANSCRIBE_TIMEOUT_MS),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => '');
    throw new Error(`STT endpoint returned ${response.status}: ${detail.slice(0, 200)}`);
  }

  const data = (await response.json()) as { text?: unknown };
  return { text: typeof data.text === 'string' ? data.text : '' };
}
