import { useEffect, useState } from 'react';

import { authenticatedFetch } from '../../utils/api';
import { estimateCostUsd, formatCostUsd } from '../../utils/modelPricing';

import type { SessionResult } from './sources/useSessionsSource';

/**
 * Side-by-side comparison of two sessions (typically the same prompt run on two
 * providers). Shows provider, model, token usage and the estimated cost so the
 * cheaper/faster option is obvious. Consumer: `CommandPalette`.
 *
 * Data comes from endpoints that already exist: `/sessions/:id/token-usage` for
 * tokens and `/:provider/sessions/:id/active-model` for the model.
 */

export type SessionUsage = {
  used: number | null;
  input: number | null;
  output: number | null;
  model: string | null;
  costUsd: number | null;
  unsupported: boolean;
};

const EMPTY_USAGE: SessionUsage = {
  used: null,
  input: null,
  output: null,
  model: null,
  costUsd: null,
  unsupported: false,
};

function readNumber(value: unknown): number | null {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

async function loadUsage(session: SessionResult): Promise<SessionUsage> {
  // token-usage doesn't need a provider in the URL — fetch stats even when the
  // session has no stored provider; only the active-model endpoint needs it.
  const [usageResponse, modelResponse] = await Promise.all([
    authenticatedFetch(`/api/providers/sessions/${encodeURIComponent(session.id)}/token-usage`).catch(() => null),
    session.provider
      ? authenticatedFetch(
          `/api/providers/${session.provider}/sessions/${encodeURIComponent(session.id)}/active-model`,
        ).catch(() => null)
      : Promise.resolve(null),
  ]);

  let used: number | null = null;
  let input: number | null = null;
  let output: number | null = null;
  let model: string | null = null;
  let unsupported = false;

  if (usageResponse?.ok) {
    const payload = (await usageResponse.json()) as {
      data?: {
        used?: unknown;
        inputTokens?: unknown;
        outputTokens?: unknown;
        breakdown?: { input?: unknown; output?: unknown };
        unsupported?: unknown;
        cacheReadTokens?: unknown;
      };
    };
    const data = payload.data;
    if (data) {
      unsupported = data.unsupported === true;
      input = readNumber(data.breakdown?.input ?? data.inputTokens);
      output = readNumber(data.breakdown?.output ?? data.outputTokens);
      used = readNumber(data.used) ?? (input !== null || output !== null ? (input ?? 0) + (output ?? 0) : null);
    }
  }

  if (modelResponse?.ok) {
    const body = (await modelResponse.json()) as { data?: { model?: unknown } };
    if (typeof body.data?.model === 'string' && body.data.model.trim()) {
      model = body.data.model.trim();
    }
  }

  const costUsd = estimateCostUsd({
    model,
    inputTokens: input ?? 0,
    outputTokens: output ?? 0,
  });

  return { used, input, output, model, costUsd, unsupported };
}

function useSessionUsage(sessionId: string | undefined, provider: string | undefined): SessionUsage | null {
  const [usage, setUsage] = useState<SessionUsage | null>(null);

  useEffect(() => {
    let cancelled = false;
    if (!sessionId) {
      setUsage(null);
      return;
    }
    setUsage(null);
    loadUsage({ id: sessionId, label: sessionId, provider: provider as SessionResult['provider'] })
      .then((next) => {
        if (!cancelled) setUsage(next);
      })
      .catch(() => {
        if (!cancelled) setUsage(EMPTY_USAGE);
      });
    return () => {
      cancelled = true;
    };
  }, [sessionId, provider]);

  return usage;
}

const formatTokens = (value: number | null) => (value === null ? '—' : value.toLocaleString());

type SessionComparePanelProps = {
  sessions: SessionResult[];
  selected: [string, string];
  onSelect: (side: 0 | 1, sessionId: string) => void;
  /** Text from the palette's top input — filters the session dropdowns. */
  filter?: string;
  /** Opens both compared sessions side-by-side in split tiles. */
  onOpenSplit?: () => void;
};

export default function SessionComparePanel({ sessions, selected, onSelect, filter = '', onOpenSplit }: SessionComparePanelProps) {
  const left = sessions.find((s) => s.id === selected[0]) ?? null;
  const right = sessions.find((s) => s.id === selected[1]) ?? null;
  const leftUsage = useSessionUsage(left?.id, left?.provider);
  const rightUsage = useSessionUsage(right?.id, right?.provider);
  const normalizedFilter = filter.trim().toLowerCase();
  const canOpenSplit = !!onOpenSplit && !!selected[0] && !!selected[1] && selected[0] !== selected[1];

  const rows: Array<{ label: string; left: string; right: string }> = [
    { label: 'Provider', left: left?.provider ?? '—', right: right?.provider ?? '—' },
    { label: 'Model', left: leftUsage?.model ?? '—', right: rightUsage?.model ?? '—' },
    {
      label: 'Tokens used',
      left: leftUsage?.unsupported ? 'N/A' : formatTokens(leftUsage?.used ?? null),
      right: rightUsage?.unsupported ? 'N/A' : formatTokens(rightUsage?.used ?? null),
    },
    {
      label: 'Input / Output',
      left: `${formatTokens(leftUsage?.input ?? null)} / ${formatTokens(leftUsage?.output ?? null)}`,
      right: `${formatTokens(rightUsage?.input ?? null)} / ${formatTokens(rightUsage?.output ?? null)}`,
    },
    {
      label: 'Est. cost',
      left: !left ? '—' : leftUsage ? formatCostUsd(leftUsage.costUsd) : '…',
      right: !right ? '—' : rightUsage ? formatCostUsd(rightUsage.costUsd) : '…',
    },
  ];

  const renderSelect = (side: 0 | 1) => {
    // Keep the currently picked option visible even when it doesn't match.
    const options = normalizedFilter
      ? sessions.filter(
          (s) => s.id === selected[side] || s.label.toLowerCase().includes(normalizedFilter),
        )
      : sessions;
    return (
      <select
        value={selected[side]}
        onChange={(event) => onSelect(side, event.target.value)}
        className="w-full rounded-lg border border-border bg-background px-2 py-1.5 text-xs text-foreground focus:border-primary/30 focus:outline-none focus:ring-2 focus:ring-primary/20"
      >
        <option value="">Select a session…</option>
        {options.map((session) => (
          <option key={`${side}-${session.id}`} value={session.id}>
            {session.label}
            {session.provider ? ` · ${session.provider}` : ''}
          </option>
        ))}
      </select>
    );
  };

  return (
    // cmdk's root keydown listener would otherwise steal arrow keys (and Enter)
    // from the native <select>/<button> elements inside this panel.
    <div className="space-y-3 px-3 py-3" onKeyDown={(event) => event.stopPropagation()}>
      <div className="grid grid-cols-2 gap-2">
        {renderSelect(0)}
        {renderSelect(1)}
      </div>
      <div className="overflow-hidden rounded-lg border border-border/70">
        {rows.map((row) => (
          <div key={row.label} className="grid grid-cols-[7rem_1fr_1fr] border-b border-border/60 last:border-b-0">
            <span className="bg-muted/30 px-2 py-1.5 text-[11px] font-medium text-muted-foreground">{row.label}</span>
            <span className="truncate px-2 py-1.5 font-mono text-[11px]" title={row.left}>{row.left}</span>
            <span className="truncate px-2 py-1.5 font-mono text-[11px]" title={row.right}>{row.right}</span>
          </div>
        ))}
      </div>
      <div className="flex items-center justify-between gap-2">
        <p className="text-[11px] text-muted-foreground">
          Cost is a client-side estimate from published per-token rates; unknown models show “—”.
        </p>
        {onOpenSplit && (
          <button
            type="button"
            onClick={onOpenSplit}
            disabled={!canOpenSplit}
            className="shrink-0 rounded-md border border-border bg-muted/40 px-2 py-1 text-[11px] font-medium text-foreground transition-colors hover:bg-muted disabled:cursor-not-allowed disabled:opacity-50"
          >
            Open in split view
          </button>
        )}
      </div>
    </div>
  );
}
