import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { GaugeIcon } from 'lucide-react';

import { authenticatedFetch } from '../../../../utils/api';
import { cn } from '../../../../lib/utils';
import { sectionForModel } from '../../../../hooks/useSubscriptionUsage';
import {
  usageFromQuotaSnapshot,
  type UsageResponse,
  type UsageWindow,
} from '../../../../utils/subscriptionAvailability';
import type { QuotaSnapshot } from '../../../quota/types';

const POLL_MS = 5 * 60 * 1000;

type QuotaTone = 'ok' | 'warn' | 'critical';

const quotaTone = (percent: number): QuotaTone =>
  percent >= 90 ? 'critical' : percent >= 70 ? 'warn' : 'ok';

const TONE_TEXT: Record<QuotaTone, string> = {
  ok: 'text-foreground',
  warn: 'text-amber-500',
  critical: 'text-destructive',
};

const TONE_ICON: Record<QuotaTone, string> = {
  ok: 'text-primary',
  warn: 'text-amber-500',
  critical: 'text-destructive',
};

const TONE_SURFACE: Record<QuotaTone, string> = {
  ok: 'border-border/70 bg-background/70 hover:border-primary/25',
  warn: 'border-amber-500/50 bg-amber-500/10 hover:border-amber-500/70',
  critical: 'border-destructive/50 bg-destructive/10 hover:border-destructive/70',
};

// W sekcji gemini wybierz grupę modeli pasującą do wybranego modelu
const windowMatchesModel = (windowKey: string, model?: string): boolean => {
  if (!model) return true;
  const m = model.toLowerCase();
  const isGeminiModel = m.includes('gemini');
  const isClaudeOrGpt = m.includes('claude') || m.includes('gpt');
  if (windowKey.startsWith('Gemini Models')) return isGeminiModel;
  if (windowKey.startsWith('Claude and GPT')) return isClaudeOrGpt;
  return true;
};

export default function QuotaBadge({ provider, model, className }: { provider?: string; model?: string; className?: string }) {
  const { t } = useTranslation('chat');
  const [data, setData] = useState<UsageResponse | null>(null);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    let cancelled = false;
    const load = async () => {
      try {
        const res = await authenticatedFetch('/api/quota');
        if (!res.ok) throw new Error(String(res.status));
        const payload = (await res.json()) as { data?: QuotaSnapshot };
        if (!payload.data) throw new Error('empty quota response');
        if (!cancelled) {
          setData(usageFromQuotaSnapshot(payload.data));
          setFailed(false);
        }
      } catch {
        if (!cancelled) setFailed(true);
      }
    };
    void load();
    const id = setInterval(load, POLL_MS);
    return () => { cancelled = true; clearInterval(id); };
  }, []);

  if (failed || !data) return null;

  // Sekcja wyłącznie dla wybranego modelu; fallback tylko po providerze
  // ('devin'/'claude' → devin, 'opencode' bez rozpoznanego prefixu → opencode).
  // Brak sekcji = brak badge; nigdy nie pokazujemy % z innej subskrypcji.
  const sectionKey = sectionForModel(model)
    ?? (provider === 'devin' || provider === 'claude' ? 'devin' : provider === 'opencode' ? 'opencode' : null);
  if (!sectionKey) return null;

  const section = data[sectionKey];
  let worst: { plan: string; key: string; w: UsageWindow } | null = null;
  const tooltipLines: string[] = [];
  if (section?.error) {
    tooltipLines.push(`${section.plan}: ${section.error}`);
  }
  for (const [key, w] of Object.entries(section?.windows ?? {})) {
    if (!windowMatchesModel(key, model)) continue;
    const reset = w.resetsAt
      ? new Date(w.resetsAt).toLocaleString([], { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' })
      : null;
    tooltipLines.push(reset ? `${key}: ${w.percent}% · reset ${reset}` : `${key}: ${w.percent}%`);
    if (!worst || w.percent > worst.w.percent) {
      worst = { plan: section?.plan ?? sectionKey, key, w };
    }
  }

  const percent = worst?.w.percent ?? null;
  const tone = percent === null ? 'ok' : quotaTone(percent);
  const title = worst
    ? `${worst.plan} · ${tooltipLines.join('\n')}`
    : tooltipLines.join('\n') || t('quotaBadge.noData', 'No subscription data for this model');

  return (
    <button
      type="button"
      className={cn(
        'inline-flex h-8 shrink-0 items-center gap-1.5 rounded-lg border px-2 text-xs text-muted-foreground shadow-sm transition-colors hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
        TONE_SURFACE[tone],
        className,
      )}
      title={title}
      aria-label={t('quotaBadge.ariaLabel', 'Subscription limits')}
    >
      <GaugeIcon className={cn('h-3.5 w-3.5', percent === null ? 'text-muted-foreground' : TONE_ICON[tone])} />
      <span className={cn('font-medium', percent === null ? 'text-muted-foreground' : TONE_TEXT[tone])}>
        {percent === null ? '—' : `${percent}%`}
      </span>
    </button>
  );
}
