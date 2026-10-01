import { useCallback, useMemo, useState } from 'react';

import ModelLibraryPanel from '../../../../chat/view/subcomponents/ModelLibraryPanel';
import { useProviderModelLibrary } from '../../../hooks/useProviderModelLibrary';
import { PROVIDER_MODELS_CHANGED_EVENT } from '../../../../../utils/providerSettings';
import type { LLMProvider, ProviderModelOption } from '../../../../../types/app';

const KNOWN_PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'devin'];

const readStoredDefaultModel = (provider: LLMProvider): string | null => {
  try {
    return localStorage.getItem(`${provider}-model`);
  } catch {
    return null;
  }
};

/**
 * Settings → Models: the single home for custom model CRUD. Reuses the
 * `ModelLibraryPanel` the chat pickers used to embed; the panel keeps its own
 * provider switcher and add/edit form, so this tab is only a host.
 *
 * Each model row also gets a radio that sets the provider's default model —
 * the same `${provider}-model` key the chat pickers read, so a pick made here
 * becomes the default for every new chat.
 */
export default function ModelsSettingsTab() {
  const { providerModelCatalog, providerModelActions } = useProviderModelLibrary();
  const initialProvider = useMemo<LLMProvider>(() => {
    const stored = localStorage.getItem('selected-provider');
    return KNOWN_PROVIDERS.includes(stored as LLMProvider) ? (stored as LLMProvider) : 'claude';
  }, []);
  const [provider, setProvider] = useState(initialProvider);
  // localStorage holds the pick, but React can't observe it — this copy only
  // exists to re-render the radio state after a click.
  const [writtenPicks, setWrittenPicks] = useState<Partial<Record<LLMProvider, string>>>({});
  const activeModel = writtenPicks[provider]
    ?? readStoredDefaultModel(provider)
    ?? providerModelCatalog[provider]?.DEFAULT
    ?? null;

  const handleSelectModel = useCallback((option: ProviderModelOption) => {
    try {
      localStorage.setItem(`${provider}-model`, option.value);
    } catch {
      // Storage unavailable — still reflect the pick in this tab.
    }
    setWrittenPicks((previous) => ({ ...previous, [provider]: option.value }));
    // Open chat panes reload the catalog on this event and re-resolve their
    // stored pick, so the new default reaches pickers without a remount.
    window.dispatchEvent(new Event(PROVIDER_MODELS_CHANGED_EVENT));
  }, [provider]);

  return (
    <ModelLibraryPanel
      initialProvider={initialProvider}
      providerModelCatalog={providerModelCatalog}
      actions={providerModelActions}
      activeModel={activeModel}
      onSelectModel={handleSelectModel}
      onProviderChange={setProvider}
    />
  );
}
