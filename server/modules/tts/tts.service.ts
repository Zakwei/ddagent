import { webcrypto } from 'node:crypto';
import type { Readable } from 'node:stream';

import { MsEdgeTTS, OUTPUT_FORMAT } from 'msedge-tts';

// Node 18 ESM has no global `crypto` (CJS resolves the builtin instead);
// msedge-tts uses crypto.subtle for its request signature.
if (!globalThis.crypto) {
  globalThis.crypto = webcrypto as typeof globalThis.crypto;
}

// Voice option shape returned to the client picker. `id` (the Microsoft
// ShortName) is the stable identifier persisted in localStorage.
export type TtsVoice = {
  id: string;
  name: string;
  locale: string;
  gender: string;
};

// Curated neural voices — the full Microsoft catalog is ~300 entries. Polish
// voices plus the natural-sounding English set cover this app's users.
const CURATED_VOICE_IDS = [
  'pl-PL-ZofiaNeural',
  'pl-PL-MarekNeural',
  'en-US-AndrewMultilingualNeural',
  'en-US-AvaMultilingualNeural',
  'en-US-EmmaMultilingualNeural',
  'en-US-BrianMultilingualNeural',
  'en-US-AriaNeural',
  'en-US-JennyNeural',
  'en-US-GuyNeural',
  'en-US-AndrewNeural',
  'en-US-AvaNeural',
  'en-US-EmmaNeural',
  'en-US-ChristopherNeural',
  'en-US-MichelleNeural',
  'en-GB-SoniaNeural',
  'en-GB-RyanNeural',
  'en-GB-LibbyNeural',
];

const DEFAULT_VOICE_ID = 'en-US-AriaNeural';

let voicesCache: Promise<TtsVoice[]> | null = null;

function shortVoiceName(shortName: string): string {
  return shortName
    .replace(/^[a-z]{2}-[A-Z]{2}-/, '')
    .replace(/MultilingualNeural$/, ' Multilingual')
    .replace(/Neural$/, '');
}

// Consumed by tts.routes.ts for GET /voices. Cached — Microsoft's voice list
// is static, and a failure resets the cache so the next call retries.
export function getCuratedVoices(): Promise<TtsVoice[]> {
  voicesCache ??= new MsEdgeTTS()
    .getVoices()
    .then((all) => {
      const byId = new Map(all.map((v) => [v.ShortName, v]));
      return CURATED_VOICE_IDS
        .map((id) => byId.get(id))
        .filter((v): v is NonNullable<typeof v> => Boolean(v))
        .map((v) => ({
          id: v.ShortName,
          name: `${shortVoiceName(v.ShortName)} (${v.Locale})`,
          locale: v.Locale,
          gender: v.Gender,
        }));
    })
    .catch((error) => {
      voicesCache = null;
      throw error;
    });
  return voicesCache;
}

// ShortName pattern: 'pl-PL-ZofiaNeural', 'en-US-AndrewMultilingualNeural'.
const TTS_VOICE_ID_PATTERN = /^[a-z]{2}-[a-zA-Z]{2,4}-[A-Za-z]+$/;

// msedge-tts pastes the text into its SSML template unescaped, and Edge drops
// the whole request when the document turns invalid — a raw '<' or '&'
// (ref_file tags, "<2 min", "R&D") leaves the socket silent forever. Strip
// tag-like spans, then escape whatever is left so synthesis always runs.
// Consumed by synthesizeSpeech; exported for the module's tests.
export function sanitizeSsmlInput(text: string): string {
  return text
    .replace(/<[a-zA-Z/][^>]{0,300}>/g, ' ')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

// Healthy synthesis yields the first chunk in well under a second; a socket
// that stays silent this long was dropped by Edge. Failing the stream lets the
// route answer and the client fall back instead of hanging on dead air.
const FIRST_CHUNK_TIMEOUT_MS = 15_000;

// Consumed by tts.routes.ts for POST /. Unknown or malformed voice ids fall
// back to the default voice so a stale localStorage value can never 500.
export async function synthesizeSpeech(text: string, voiceId?: string): Promise<Readable> {
  let voice = DEFAULT_VOICE_ID;
  if (voiceId && TTS_VOICE_ID_PATTERN.test(voiceId)) {
    // Pattern-valid ids can still be absent from the live catalog (e.g. a
    // voice stored before it was removed) — verify before setMetadata.
    const known = (await getCuratedVoices()).some((v) => v.id === voiceId);
    if (known) voice = voiceId;
  }
  const tts = new MsEdgeTTS();
  await tts.setMetadata(voice, OUTPUT_FORMAT.AUDIO_24KHZ_48KBITRATE_MONO_MP3);
  const { audioStream } = tts.toStream(sanitizeSsmlInput(text));
  audioStream.on('end', () => tts.close());
  audioStream.on('error', () => tts.close());
  // Closing the socket (not destroying the stream) is deliberate: msedge-tts
  // deletes its per-request entry on destroy and then crashes on the next
  // in-flight frame, so the socket has to go first and let the library fail
  // the stream from its own onclose path.
  const firstChunkTimer = setTimeout(() => tts.close(), FIRST_CHUNK_TIMEOUT_MS);
  audioStream.once('readable', () => clearTimeout(firstChunkTimer));
  audioStream.once('close', () => clearTimeout(firstChunkTimer));
  return audioStream;
}
