import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

interface LoadAllMessagesOverlayProps {
  showLoadAllOverlay: boolean;
  isLoadingAllMessages: boolean;
  loadAllJustFinished: boolean;
  totalMessages: number;
  onLoadAllMessages: () => void;
}

export default function LoadAllMessagesOverlay({
  showLoadAllOverlay,
  isLoadingAllMessages,
  loadAllJustFinished,
  totalMessages,
  onLoadAllMessages,
}: LoadAllMessagesOverlayProps) {
  const { t } = useTranslation('chat');
  const visible = showLoadAllOverlay || isLoadingAllMessages || loadAllJustFinished;
  // The fade keeps the wrapper mounted (and fully transparent) until the
  // parent's 2500ms timer hides it — mark it invisible on animation end so the
  // "Load all" button can't keep intercepting clicks while transparent.
  const [fadeDone, setFadeDone] = useState(false);

  // Re-arm for the next cycle; `return null` below does not unmount this
  // component, so the state would otherwise survive into the next show (and a
  // load started right after a fade would render the spinner invisible).
  useEffect(() => {
    if (!visible || isLoadingAllMessages) {
      setFadeDone(false);
    }
  }, [visible, isLoadingAllMessages]);

  if (!visible) {
    return null;
  }

  return (
    <div
      className={`pointer-events-none sticky top-2 z-20 flex justify-center ${!isLoadingAllMessages ? 'load-all-overlay-auto-fade' : ''} ${fadeDone ? 'invisible' : ''}`}
      onAnimationEnd={() => setFadeDone(true)}
    >
      {loadAllJustFinished ? (
        <div className="flex items-center space-x-2 rounded-full bg-green-600 px-4 py-1.5 text-xs font-medium text-white shadow-lg dark:bg-green-500">
          <svg className="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
          </svg>
          <span>{t('session.messages.allLoaded')}</span>
        </div>
      ) : (
        <button
          className={`${fadeDone ? 'pointer-events-none' : 'pointer-events-auto'} flex items-center space-x-2 rounded-full bg-blue-600 px-4 py-1.5 text-xs font-medium text-white shadow-lg transition-all duration-200 hover:scale-105 hover:bg-blue-700 disabled:cursor-wait disabled:opacity-75 dark:bg-blue-500 dark:hover:bg-blue-600`}
          onClick={onLoadAllMessages}
          disabled={isLoadingAllMessages}
        >
          {isLoadingAllMessages && (
            <div className="h-3 w-3 animate-spin rounded-full border-2 border-white/30 border-t-white" />
          )}
          <span>
            {isLoadingAllMessages
              ? t('session.messages.loadingAll')
              : <>{t('session.messages.loadAll')} {totalMessages > 0 && `(${totalMessages})`}</>}
          </span>
        </button>
      )}
    </div>
  );
}
