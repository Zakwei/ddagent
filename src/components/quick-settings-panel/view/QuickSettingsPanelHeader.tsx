import { Settings2, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';

export const QUICK_SETTINGS_TITLE_ID = 'quick-settings-title';

export default function QuickSettingsPanelHeader({ onClose }: { onClose: () => void }) {
  const { t } = useTranslation('settings');

  return (
    <div className="flex items-center justify-between border-b border-border bg-muted/40 p-4">
      <h3 id={QUICK_SETTINGS_TITLE_ID} className="flex items-center gap-2 text-lg font-semibold text-foreground">
        <Settings2 className="h-5 w-5 text-muted-foreground" />
        {t('quickSettings.title')}
      </h3>
      <button
        type="button"
        onClick={onClose}
        aria-label={t('quickSettings.dragHandle.closePanel')}
        className="rounded-md p-1 text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
      >
        <X className="h-5 w-5" />
      </button>
    </div>
  );
}
