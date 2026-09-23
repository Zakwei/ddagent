import { useCallback, useEffect, useState } from 'react';
import { Copy, KeyRound, Loader2, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { authenticatedFetch } from '../../../utils/api';
import { Badge, Button, Input } from '../../../shared/view/ui';

type McpToken = {
  id: string;
  label: string;
  scope: 'read' | 'write';
  createdAt: string;
  lastUsedAt: string | null;
};

/**
 * Bearer tokens for ddagent's own MCP endpoint (`/mcp`) — how external tools
 * like Claude Desktop or OpenClaw call the ddagent tools. Plaintext is shown
 * exactly once, right after creation.
 */
export default function McpServerTokens() {
  const { t } = useTranslation('settings');
  const [tokens, setTokens] = useState<McpToken[]>([]);
  const [label, setLabel] = useState('');
  const [scope, setScope] = useState<'read' | 'write'>('read');
  const [freshToken, setFreshToken] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const refresh = useCallback(async () => {
    const response = await authenticatedFetch('/api/mcp/tokens');
    const body = await response.json().catch(() => ({}));
    setTokens(Array.isArray(body?.data?.tokens) ? body.data.tokens : []);
  }, []);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  const create = async () => {
    setBusy(true);
    try {
      const response = await authenticatedFetch('/api/mcp/tokens', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ label: label.trim() || 'mcp-client', scope }),
      });
      const body = await response.json().catch(() => ({}));
      if (body?.data?.token) setFreshToken(body.data.token);
      setLabel('');
      await refresh();
    } finally {
      setBusy(false);
    }
  };

  const revoke = async (id: string) => {
    await authenticatedFetch(`/api/mcp/tokens/${encodeURIComponent(id)}`, { method: 'DELETE' });
    await refresh();
  };

  const copyFresh = async () => {
    if (!freshToken) return;
    try {
      await navigator.clipboard.writeText(freshToken);
    } catch {
      // Clipboard API unavailable — the token stays visible for manual copy.
    }
  };

  return (
    <div className="mt-6 rounded-xl border p-4">
      <div className="mb-2 flex items-center gap-2">
        <KeyRound className="h-4 w-4 text-muted-foreground" />
        <h3 className="text-sm font-medium">
          {t('mcpTokens.title', { defaultValue: 'ddagent MCP server tokens' })}
        </h3>
      </div>
      <p className="mb-3 text-xs text-muted-foreground">
        {t('mcpTokens.description', {
          defaultValue:
            'External tools (Claude Desktop, OpenClaw) call ddagent tools over POST /mcp with one of these bearer tokens.',
        })}
      </p>

      {freshToken && (
        <div className="mb-3 flex items-center gap-2 rounded-md border border-primary/40 bg-primary/5 p-2">
          <code className="min-w-0 flex-1 truncate text-xs">{freshToken}</code>
          <Button size="sm" variant="ghost" onClick={() => void copyFresh()}>
            <Copy className="h-3.5 w-3.5" />
          </Button>
          <Button size="sm" variant="ghost" onClick={() => setFreshToken(null)}>
            {t('mcpTokens.dismiss', { defaultValue: 'Dismiss' })}
          </Button>
        </div>
      )}

      <div className="mb-3 flex items-center gap-2">
        <Input
          value={label}
          onChange={(event) => setLabel(event.target.value)}
          placeholder={t('mcpTokens.labelPlaceholder', { defaultValue: 'Token label (e.g. Claude Desktop)' })}
          className="flex-1"
        />
        <select
          className="rounded-md border bg-background px-2 py-1.5 text-sm"
          value={scope}
          onChange={(event) => setScope(event.target.value as 'read' | 'write')}
        >
          <option value="read">read</option>
          <option value="write">write</option>
        </select>
        <Button size="sm" disabled={busy} onClick={() => void create()}>
          {busy && <Loader2 className="mr-1 h-3 w-3 animate-spin" />}
          {t('mcpTokens.create', { defaultValue: 'Create' })}
        </Button>
      </div>

      {tokens.length === 0 ? (
        <p className="text-xs text-muted-foreground">
          {t('mcpTokens.empty', { defaultValue: 'No MCP tokens yet.' })}
        </p>
      ) : (
        <div className="space-y-1">
          {tokens.map((token) => (
            <div key={token.id} className="flex items-center gap-2 text-sm">
              <span className="min-w-0 flex-1 truncate">{token.label}</span>
              <Badge variant="secondary">{token.scope}</Badge>
              <span className="text-xs text-muted-foreground">
                {token.lastUsedAt
                  ? t('mcpTokens.lastUsed', { defaultValue: 'used {{time}}', time: new Date(token.lastUsedAt).toLocaleDateString() })
                  : t('mcpTokens.neverUsed', { defaultValue: 'never used' })}
              </span>
              <Button size="sm" variant="ghost" onClick={() => void revoke(token.id)}>
                <Trash2 className="h-3.5 w-3.5" />
              </Button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
