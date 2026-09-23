import { Check, Loader2, Mic } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button, Input } from '../../../../../../shared/view/ui';
import { authenticatedFetch } from '../../../../../../utils/api';

type SttConfigResponse = {
  configured: boolean;
  endpointUrl?: string;
  model?: string;
  hasApiKey?: boolean;
};

/** Voice input (speech-to-text) backend — whisper-compatible endpoint. */
export default function SttConfigSection() {
  const { t } = useTranslation('settings');
  const [config, setConfig] = useState<SttConfigResponse | null>(null);
  const [endpointUrl, setEndpointUrl] = useState('');
  const [apiKey, setApiKey] = useState('');
  const [model, setModel] = useState('');
  const [busy, setBusy] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    authenticatedFetch('/api/stt/config')
      .then((res) => res.json())
      .then((data: SttConfigResponse) => {
        setConfig(data);
        setEndpointUrl(data.endpointUrl ?? '');
        setModel(data.model ?? '');
      })
      .catch(() => setConfig(null));
  }, []);

  const save = async () => {
    setBusy(true);
    setError(null);
    setSaved(false);
    try {
      const response = await authenticatedFetch('/api/stt/config', {
        method: 'PUT',
        body: JSON.stringify({
          endpointUrl,
          ...(apiKey.trim() ? { apiKey } : {}),
          model,
        }),
      });
      const data = await response.json().catch(() => ({}));
      if (!response.ok) throw new Error(data?.error || 'save failed');
      setConfig((prev) => ({ ...(prev ?? {}), configured: Boolean(data.configured) }) as SttConfigResponse);
      setSaved(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'save failed');
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mt-6 rounded-lg border bg-card p-4">
      <div className="mb-2 flex items-center gap-2">
        <Mic className="h-4 w-4" />
        <h4 className="font-medium">
          {t('stt.title', { defaultValue: 'Voice input (speech-to-text)' })}
        </h4>
        {config?.configured && (
          <span className="text-xs text-green-600 dark:text-green-400">
            {t('stt.configured', { defaultValue: 'configured' })}
          </span>
        )}
      </div>
      <p className="mb-3 text-sm text-muted-foreground">
        {t('stt.description', {
          defaultValue:
            'Whisper-compatible /audio/transcriptions endpoint (OpenAI, whisper.cpp, faster-whisper, Speaches). Enables the mic button in the composer.',
        })}
      </p>
      <div className="space-y-2">
        <Input
          placeholder={t('stt.endpoint', { defaultValue: 'Endpoint URL (e.g. https://api.openai.com/v1)' })}
          value={endpointUrl}
          onChange={(e) => setEndpointUrl(e.target.value)}
        />
        <Input
          type="password"
          placeholder={t('stt.apiKey', {
            defaultValue: config?.hasApiKey ? 'API key (saved — enter to replace)' : 'API key',
          })}
          value={apiKey}
          onChange={(e) => setApiKey(e.target.value)}
        />
        <Input
          placeholder={t('stt.model', { defaultValue: 'Model (default: whisper-1)' })}
          value={model}
          onChange={(e) => setModel(e.target.value)}
        />
      </div>
      <div className="mt-3 flex items-center gap-3">
        <Button size="sm" variant="outline" disabled={busy} onClick={() => void save()}>
          {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
          {t('stt.save', { defaultValue: 'Save' })}
        </Button>
        {saved && <span className="text-xs text-green-600 dark:text-green-400">✓</span>}
        {error && <span className="text-xs text-red-600 dark:text-red-400">{error}</span>}
      </div>
    </div>
  );
}
