import { safeLocalStorage } from '../components/chat/utils/chatStorage';
import type { NormalizedMessage } from '../stores/useSessionStore';

// Opt-in "read the reply aloud" per chat session. The composer toggle arms a
// session id; when that session's run completes, the last assistant text is
// spoken via the browser's built-in speechSynthesis (no backend, no config).
// The armed set persists in localStorage so the toggle survives page reloads.
// Every mounted pane receives the same `complete` frame, so firing is deduped
// by the frame's per-run `seq` — the first pane to handle it wins and
// replays/duplicates are ignored.

const ARMED_STORAGE_KEY = 'voiceAutoRead.armedSessions';
const VOICE_STORAGE_KEY = 'voiceAutoRead.voiceName';

const armedSessions = new Set<string>();
const lastSpokenSeq = new Map<string, number>();

const SPEECH_MAX_CHARS = 4000;

try {
  const saved: unknown = JSON.parse(safeLocalStorage.getItem(ARMED_STORAGE_KEY) ?? '[]');
  if (Array.isArray(saved)) {
    for (const id of saved) {
      if (typeof id === 'string') armedSessions.add(id);
    }
  }
} catch {
  /* corrupt payload — start unarmed */
}

function persistArmedSessions(): void {
  safeLocalStorage.setItem(ARMED_STORAGE_KEY, JSON.stringify([...armedSessions]));
}

export function isSpeechSupported(): boolean {
  return typeof window !== 'undefined' && 'speechSynthesis' in window;
}

export function isAutoReadArmed(sessionId: string): boolean {
  return armedSessions.has(sessionId);
}

export function setAutoReadArmed(sessionId: string, armed: boolean): void {
  if (armed) armedSessions.add(sessionId);
  else armedSessions.delete(sessionId);
  persistArmedSessions();
}

let currentAudio: HTMLAudioElement | null = null;
let currentOnEnd: (() => void) | undefined;
// Bumped by stopSpeaking so an in-flight request (blob still downloading)
// can abort instead of starting playback after the user hit stop.
let speakGen = 0;

export function stopSpeaking(): void {
  speakGen++;
  if (isSpeechSupported()) window.speechSynthesis.cancel();
  currentAudio?.pause();
  currentAudio = null;
  // pause() doesn't fire onended — run the previous speaker's hook so its
  // button state resets instead of staying stuck on "speaking".
  const onEnd = currentOnEnd;
  currentOnEnd = undefined;
  onEnd?.();
}

export function getSpeechVoices(): SpeechSynthesisVoice[] {
  return isSpeechSupported() ? window.speechSynthesis.getVoices() : [];
}

export function getPreferredVoiceName(): string {
  return safeLocalStorage.getItem(VOICE_STORAGE_KEY) ?? '';
}

export function setPreferredVoiceName(name: string): void {
  if (name) safeLocalStorage.setItem(VOICE_STORAGE_KEY, name);
  else safeLocalStorage.removeItem(VOICE_STORAGE_KEY);
}

// Friendlier default: a same-language voice, preferring quality-flagged names
// ("Natural"/"Neural"/"Google …"/"Enhanced"), else the browser default.
export function pickDefaultVoice(voices: SpeechSynthesisVoice[]): SpeechSynthesisVoice | null {
  if (voices.length === 0) return null;
  const navLang = typeof navigator !== 'undefined' ? navigator.language ?? '' : '';
  const langPrefix = navLang.split('-')[0]?.toLowerCase();
  const sameLang = langPrefix ? voices.filter((v) => v.lang?.toLowerCase().startsWith(langPrefix)) : [];
  const pool = sameLang.length > 0 ? sameLang : voices;
  return (
    pool.find((v) => /natural|neural|google|enhanced|premium/i.test(v.name)) ??
    pool.find((v) => v.default) ??
    pool[0]
  );
}

export function resolveSpeechVoice(): SpeechSynthesisVoice | null {
  const voices = getSpeechVoices();
  const stored = getPreferredVoiceName();
  return voices.find((v) => v.name === stored) ?? pickDefaultVoice(voices);
}

// Server-backed neural TTS (Edge voices) is the primary path — OS speech
// voices vary wildly in quality. On any failure we fall back to the browser's
// speechSynthesis so read-aloud still works offline / on an old backend.
// The GET endpoint streams MP3, so pointing <audio>.src at it starts playback
// on the first chunk instead of buffering the whole file (the old blob()
// approach added seconds of silence for long replies).
async function speakViaServer(
  text: string,
  hooks?: { onStart?: () => void; onEnd?: () => void },
): Promise<'ok' | 'fail' | 'cancelled'> {
  const gen = speakGen;
  try {
    const params = new URLSearchParams({ text });
    const voice = getPreferredVoiceName();
    if (voice) params.set('voice', voice);
    // OSS mode needs the JWT; the middleware accepts it as a query param
    // (same escape hatch used by SSE endpoints). Platform mode ignores it.
    const token = safeLocalStorage.getItem('auth-token');
    if (token) params.set('token', token);

    const finish = (audio: HTMLAudioElement, url?: string) => {
      if (url) URL.revokeObjectURL(url);
      if (currentAudio === audio) {
        currentAudio = null;
        currentOnEnd = undefined;
      }
      hooks?.onEnd?.();
    };
    const arm = (audio: HTMLAudioElement, url?: string) => {
      audio.onended = () => finish(audio, url);
      audio.onerror = () => finish(audio, url);
      currentAudio = audio;
      currentOnEnd = hooks?.onEnd;
    };

    // Polish diacritics encode ~3x, so 4000 chars can blow past Node's 16KB
    // request-line limit (431). Stream via GET only when the URL fits safely;
    // longer texts go through POST + blob (no URL limit, slightly later start).
    if (params.toString().length < 8000) {
      const audio = new Audio(`/api/tts?${params}`);
      arm(audio);
      await audio.play();
    } else {
      const { authenticatedFetch } = await import('../utils/api');
      const res = await authenticatedFetch('/api/tts', {
        method: 'POST',
        body: JSON.stringify({ text, voice: voice || undefined }),
      });
      if (!res.ok) return 'fail';
      const blob = await res.blob();
      if (blob.size === 0) return 'fail';
      const url = URL.createObjectURL(blob);
      if (gen !== speakGen) {
        URL.revokeObjectURL(url);
        return 'cancelled';
      }
      const audio = new Audio(url);
      arm(audio, url);
      await audio.play();
    }
    hooks?.onStart?.();
    return 'ok';
  } catch {
    return gen === speakGen ? 'fail' : 'cancelled';
  }
}

function speakViaSpeechSynthesis(
  text: string,
  hooks?: { onStart?: () => void; onEnd?: () => void },
): void {
  if (!isSpeechSupported()) return;
  window.speechSynthesis.cancel();
  const utterance = new SpeechSynthesisUtterance(text);
  const voice = resolveSpeechVoice();
  if (voice) {
    utterance.voice = voice;
    utterance.lang = voice.lang;
  }
  if (hooks?.onStart) utterance.onstart = hooks.onStart;
  if (hooks?.onEnd) {
    utterance.onend = hooks.onEnd;
    utterance.onerror = hooks.onEnd;
  }
  window.speechSynthesis.speak(utterance);
}

export function speakText(
  text: string,
  hooks?: { onStart?: () => void; onEnd?: () => void },
): void {
  stopSpeaking();
  void speakViaServer(text, hooks).then((result) => {
    if (result === 'fail') speakViaSpeechSynthesis(text, hooks);
  });
}

// Voice list for the picker — neural voices from /api/tts when the backend
// serves them, otherwise the OS speechSynthesis voices.
export type SpeakVoiceOption = { id: string; name: string };

export async function getSpeakVoiceOptions(): Promise<SpeakVoiceOption[]> {
  try {
    const { authenticatedFetch } = await import('../utils/api');
    const res = await authenticatedFetch('/api/tts/voices');
    if (res.ok) {
      const data = await res.json();
      if (Array.isArray(data?.voices) && data.voices.length > 0) {
        return data.voices.map((v: { id: string; name: string }) => ({ id: v.id, name: v.name }));
      }
    }
  } catch {
    /* fall through to OS voices */
  }
  return getSpeechVoices().map((v) => ({ id: v.name, name: v.name }));
}

// Raw markdown reads badly aloud: drop fenced code blocks and tag-like spans,
// neutralize the characters that break the backend's SSML (a stray '<' or '&'
// makes Edge TTS hang on the whole request), flatten whitespace, and cap the
// payload (very long inputs queue awkwardly in speech engines).
export function speechText(raw: string): string {
  const flat = raw
    .replace(/```[\s\S]*?(?:```|$)/g, ' ')
    .replace(/<[a-zA-Z/][^>]{0,300}>/g, ' ')
    .replace(/[<&]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
  return flat.length > SPEECH_MAX_CHARS ? `${flat.slice(0, SPEECH_MAX_CHARS)}…` : flat;
}

export function lastAssistantSpeechText(messages: NormalizedMessage[]): string {
  for (let i = messages.length - 1; i >= 0; i--) {
    const m = messages[i];
    if (m.kind === 'text' && m.role === 'assistant') {
      const speech = speechText(m.content ?? m.text ?? m.displayText ?? '');
      if (speech) return speech;
    }
  }
  return '';
}

export function maybeSpeakCompletion(sessionId: string, seq: number, getText: () => string): void {
  if (!armedSessions.has(sessionId)) return;
  if ((lastSpokenSeq.get(sessionId) ?? -1) >= seq) return;
  lastSpokenSeq.set(sessionId, seq);

  const text = getText();
  if (text) speakText(text);
}
