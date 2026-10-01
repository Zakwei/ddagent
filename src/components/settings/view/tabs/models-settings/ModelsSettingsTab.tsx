import { useMemo } from 'react';

import ModelLibraryPanel from '../../../../chat/view/subcomponents/ModelLibraryPanel';
import { useProviderModelLibrary } from '../../../hooks/useProviderModelLibrary';
import type { LLMProvider } from '../../../../../types/app';

const KNOWN_PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'devin'];

/**
 * Settings → Models: the single home for custom model CRUD. Reuses the
 * `ModelLibraryPanel` the chat pickers used to embed; the panel keeps its own
 * provider switcher and add/edit form, so this tab is only a host.
 */
export default function ModelsSettingsTab() {
  const { providerModelCatalog, providerModelActions } = useProviderModelLibrary();
  const initialProvider = useMemo<LLMProvider>(() => {
    const stored = localStorage.getItem('selected-provider');
    return KNOWN_PROVIDERS.includes(stored as LLMProvider) ? (stored as LLMProvider) : 'claude';
  }, []);

  return (
    <ModelLibraryPanel
      initialProvider={initialProvider}
      providerModelCatalog={providerModelCatalog}
      actions={providerModelActions}
    />
  );
}
