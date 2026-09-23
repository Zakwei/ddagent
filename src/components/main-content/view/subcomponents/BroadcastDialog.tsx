import { Megaphone } from 'lucide-react';
import { useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Dialog, DialogContent, DialogTitle } from '../../../../shared/view/ui';
import { authenticatedFetch } from '../../../../utils/api';
import { getPickerSessionTitle } from '../../utils/sessionPicker';
import type { SplitSessionCandidate } from '../../utils/splitSessionUtils';

type BroadcastDialogProps = {
  open: boolean;
  onClose: () => void;
  sessions: SplitSessionCandidate[];
};

type BroadcastResult = { sessionId: string; ok: boolean; error?: string };

/**
 * Sends one message to many sessions at once through the server-side queue —
 * each target drains independently, so busy sessions receive it next.
 */
export default function BroadcastDialog({ open, onClose, sessions }: BroadcastDialogProps) {
  const { t } = useTranslation('chat');
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [message, setMessage] = useState('');
  const [sending, setSending] = useState(false);
  const [results, setResults] = useState<BroadcastResult[] | null>(null);
  const [error, setError] = useState<string | null>(null);

  const selectable = useMemo(() => sessions.filter((s) => !s.isArchived), [sessions]);

  const toggle = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const send = async () => {
    if (selected.size === 0 || !message.trim()) return;
    setSending(true);
    setError(null);
    setResults(null);
    try {
      const response = await authenticatedFetch('/api/queue/broadcast', {
        method: 'POST',
        body: JSON.stringify({ sessionIds: [...selected], content: message }),
      });
      const data = await response.json().catch(() => ({}));
      if (!response.ok) throw new Error(data?.error?.message || data?.error || `broadcast ${response.status}`);
      setResults(data?.data?.results ?? []);
      setMessage('');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'broadcast failed');
    } finally {
      setSending(false);
    }
  };

  const failedCount = results?.filter((r) => !r.ok).length ?? 0;

  return (
    <Dialog open={open} onOpenChange={(isOpen) => !isOpen && onClose()}>
      <DialogContent className="max-w-md">
        <DialogTitle className="flex items-center gap-2 text-sm font-semibold">
          <Megaphone className="h-4 w-4" />
          {t('broadcast.title', { defaultValue: 'Broadcast to sessions' })}
        </DialogTitle>

        <div className="max-h-56 overflow-y-auto rounded-md border border-border/60">
          {selectable.length === 0 && (
            <p className="px-3 py-4 text-center text-xs text-muted-foreground">
              {t('broadcast.noSessions', { defaultValue: 'No sessions available' })}
            </p>
          )}
          {selectable.map((session) => (
            <label
              key={session.id}
              className="flex cursor-pointer items-center gap-2 border-b border-border/40 px-3 py-1.5 text-xs last:border-b-0 hover:bg-accent/40"
            >
              <input
                type="checkbox"
                checked={selected.has(session.id)}
                onChange={() => toggle(session.id)}
                className="accent-primary"
              />
              <span className="min-w-0 flex-1 truncate">{getPickerSessionTitle(session)}</span>
              <span className="shrink-0 text-[10px] text-muted-foreground">{session.projectName}</span>
            </label>
          ))}
        </div>

        <textarea
          value={message}
          onChange={(event) => setMessage(event.target.value)}
          rows={3}
          placeholder={t('broadcast.placeholder', { defaultValue: 'Message to send to every selected session…' })}
          className="w-full resize-y rounded-md border border-border/60 bg-background px-2.5 py-1.5 text-sm outline-none focus:ring-1 focus:ring-primary/40"
        />

        {results && (
          <p className={`text-xs ${failedCount ? 'text-amber-600 dark:text-amber-400' : 'text-green-600 dark:text-green-400'}`}>
            {failedCount
              ? t('broadcast.partial', { count: failedCount, defaultValue: '{{count}} session(s) rejected the message' })
              : t('broadcast.sent', { count: results.length, defaultValue: 'Queued for {{count}} session(s)' })}
          </p>
        )}
        {error && <p className="text-xs text-destructive">{error}</p>}

        <div className="flex items-center justify-between">
          <button
            type="button"
            onClick={() => setSelected(new Set(selectable.map((s) => s.id)))}
            className="text-xs text-muted-foreground hover:text-foreground"
          >
            {t('broadcast.selectAll', { defaultValue: 'Select all' })}
          </button>
          <button
            type="button"
            onClick={() => void send()}
            disabled={sending || selected.size === 0 || !message.trim()}
            className="rounded-md bg-primary/10 px-3 py-1.5 text-sm font-medium text-primary transition-colors hover:bg-primary/20 disabled:opacity-50"
          >
            {sending
              ? t('broadcast.sending', { defaultValue: 'Sending…' })
              : t('broadcast.send', { count: selected.size, defaultValue: 'Send to {{count}}' })}
          </button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
