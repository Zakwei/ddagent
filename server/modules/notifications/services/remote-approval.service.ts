import { providerRuntimeService } from '@/modules/providers/index.js';

/** What a remote messenger button can do with a pending tool approval. */
export type RemoteApprovalAction = 'allow' | 'deny' | 'always';

export type RemoteApprovalResult =
  | { ok: true; tracked: boolean }
  | { ok: false; reason: 'expired' | 'invalid' };

type PendingApprovalContext = {
  toolName: string | null;
  sessionId: string | null;
};

/**
 * Context captured when an approval notification is sent to a messenger
 * channel. Provider runtimes only need a requestId to resolve, but remote
 * "Always" additionally needs the tool name to build a rememberEntry.
 */
const pendingApprovalContexts = new Map<string, PendingApprovalContext>();
// requestId -> last decision timestamp; blocks double-tap replays racing the
// provider's own pending map cleanup.
const recentDecisions = new Map<string, number>();
const DECISION_REPLAY_WINDOW_MS = 60_000;

/**
 * Consumed by messenger-channels.service.ts (and future push channels that
 * carry requestId) when emitting an approval prompt.
 */
export function registerApprovalContext(
  requestId: string,
  context: PendingApprovalContext
): void {
  pendingApprovalContexts.set(requestId, context);
  if (pendingApprovalContexts.size > 1000) {
    pendingApprovalContexts.clear();
  }
}

/**
 * Consumed by telegram-poller.service.ts (callback buttons) and the REST
 * approvals route (mobile app / future clients). Resolves the pending
 * provider-side approval exactly like a `chat.permission-response` websocket
 * frame does. `resolveToolApproval` is a silent no-op for unknown requestIds,
 * so an untracked-but-plausible id still resolves — only replays and malformed
 * ids are rejected.
 */
export function resolveRemoteApproval(
  requestId: string,
  action: RemoteApprovalAction
): RemoteApprovalResult {
  if (typeof requestId !== 'string' || requestId.length === 0 || requestId.length > 128) {
    return { ok: false, reason: 'invalid' };
  }
  if (action !== 'allow' && action !== 'deny' && action !== 'always') {
    return { ok: false, reason: 'invalid' };
  }

  const lastDecision = recentDecisions.get(requestId);
  if (lastDecision && Date.now() - lastDecision < DECISION_REPLAY_WINDOW_MS) {
    return { ok: false, reason: 'expired' };
  }

  const context = pendingApprovalContexts.get(requestId) ?? null;
  providerRuntimeService.resolveToolApproval(requestId, {
    allow: action !== 'deny',
    // 'always' stores the bare tool name; claude-runtime's
    // matchesToolPermission treats a bare name as matching every invocation.
    rememberEntry: action === 'always' ? context?.toolName ?? undefined : undefined,
  });

  recentDecisions.set(requestId, Date.now());
  pendingApprovalContexts.delete(requestId);
  if (recentDecisions.size > 500) {
    const cutoff = Date.now() - DECISION_REPLAY_WINDOW_MS;
    for (const [key, ts] of recentDecisions) {
      if (ts < cutoff) recentDecisions.delete(key);
    }
  }

  return { ok: true, tracked: context !== null };
}
