import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Square, Volume2 } from 'lucide-react';

import { speakText, speechText, stopSpeaking } from '../../../../lib/voiceAutoRead';

// Ad-hoc "read this message aloud" button shown on assistant messages. Uses the
// same browser speech pipeline as the composer auto-read toggle — including the
// user's selected voice. Clicking while speaking stops playback.
const MessageSpeakControl = ({
  content,
  messageType,
  sessionId,
}: {
  content: string;
  messageType: 'user' | 'assistant';
  /** Session whose per-session voice applies; omit to use the fallback. */
  sessionId?: string | null;
}) => {
  const { t } = useTranslation('chat');
  const [speaking, setSpeaking] = useState(false);

  const text = speechText(content);
  if (!text) return null;

  const toneClass = messageType === 'user'
    ? 'text-muted-foreground hover:text-foreground'
    : 'text-gray-400 hover:text-gray-600 dark:text-gray-500 dark:hover:text-gray-300';
  const title = speaking
    ? t('voice.stopSpeaking', { defaultValue: 'Stop reading' })
    : t('voice.speakMessage', { defaultValue: 'Read aloud' });

  return (
    <button
      type="button"
      onClick={() => {
        if (speaking) {
          stopSpeaking();
          setSpeaking(false);
          return;
        }
        speakText(text, {
          onStart: () => setSpeaking(true),
          onEnd: () => setSpeaking(false),
        }, sessionId ?? undefined);
      }}
      title={title}
      aria-label={title}
      aria-pressed={speaking}
      className={`inline-flex items-center gap-1 rounded px-1 py-0.5 transition-colors ${toneClass}`}
    >
      {speaking ? <Square className="h-3.5 w-3.5" /> : <Volume2 className="h-3.5 w-3.5" />}
    </button>
  );
};

export default MessageSpeakControl;
