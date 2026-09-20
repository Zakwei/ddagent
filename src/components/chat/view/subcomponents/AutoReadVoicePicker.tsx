import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import {
  getPreferredVoiceName,
  getSpeakVoiceOptions,
  isSpeechSupported,
  setPreferredVoiceName,
  speakText,
} from '../../../../lib/voiceAutoRead';
import type { SpeakVoiceOption } from '../../../../lib/voiceAutoRead';

// Voice picker for read-aloud, shown once the chat toggle is armed. Neural
// voices come from /api/tts; OS speechSynthesis voices are the fallback when
// the backend doesn't serve them (they load async, so re-read on
// `voiceschanged`). Changing the voice plays a short preview in that voice.
const AutoReadVoicePicker = () => {
  const { t } = useTranslation('chat');
  const [voices, setVoices] = useState<SpeakVoiceOption[]>([]);
  const [current, setCurrent] = useState(() => getPreferredVoiceName());

  useEffect(() => {
    let cancelled = false;
    const sync = async () => {
      const options = await getSpeakVoiceOptions();
      if (cancelled) return;
      setVoices(options);
      // A stored voice that isn't in the current list (e.g. an OS voice name
      // from before server TTS) would fail synthesis and fall back to the old
      // system voice — reset it to auto instead.
      const stored = getPreferredVoiceName();
      if (stored && !options.some((v) => v.id === stored)) {
        setPreferredVoiceName('');
        setCurrent('');
      }
    };
    void sync();
    if (!isSpeechSupported()) return () => { cancelled = true; };
    const onVoicesChanged = () => void sync();
    window.speechSynthesis.addEventListener('voiceschanged', onVoicesChanged);
    return () => {
      cancelled = true;
      window.speechSynthesis.removeEventListener('voiceschanged', onVoicesChanged);
    };
  }, []);

  if (voices.length === 0) return null;

  return (
    <select
      value={current}
      onChange={(e) => {
        const name = e.target.value;
        setCurrent(name);
        setPreferredVoiceName(name);
        speakText(t('voice.autoReadPreview', { defaultValue: 'This is how replies will sound.' }));
      }}
      aria-label={t('voice.autoReadVoice', { defaultValue: 'Read-aloud voice' })}
      className="h-8 min-w-0 max-w-40 truncate rounded-md border border-border/60 bg-muted/40 px-1.5 text-xs text-foreground"
    >
      <option value="">{t('voice.autoReadVoiceAuto', { defaultValue: 'Auto voice' })}</option>
      {voices.map((v) => (
        <option key={v.id} value={v.id}>
          {v.name}
        </option>
      ))}
    </select>
  );
};

export default AutoReadVoicePicker;
