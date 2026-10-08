// The providers barrel is imported lazily: notifications/index → telegram-poller
// → this module sits inside a providers → runtime → notifications import cycle,
// and a static binding read crashes with TDZ when a provider runtime module is
// the entry point (as in the runtime unit tests).
type ProviderRuntimeService = typeof import('@/modules/providers/index.js').providerRuntimeService;

let cachedRuntime: ProviderRuntimeService | null = null;
async function resolveRuntime(): Promise<ProviderRuntimeService> {
  if (!cachedRuntime) {
    ({ providerRuntimeService: cachedRuntime } = await import('@/modules/providers/index.js'));
  }
  return cachedRuntime;
}

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
export async function resolveRemoteApproval(
  requestId: string,
  action: RemoteApprovalAction,
  // Optional payload a full client (the app over REST while its websocket
  // reconnects) attaches — the same fields a `chat.permission-response`
  // frame carries. Messenger buttons send none.
  details: { updatedInput?: Record<string, unknown>; message?: string; rememberEntry?: string } = {}
): Promise<RemoteApprovalResult> {
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
  const runtime = await resolveRuntime();
  runtime.resolveToolApproval(requestId, {
    allow: action !== 'deny',
    // 'always' prefers the client's exact entry; messenger buttons have none
    // and fall back to the bare tool name, which claude-runtime's
    // matchesToolPermission treats as matching every invocation.
    rememberEntry: action === 'always' ? details.rememberEntry ?? context?.toolName ?? undefined : undefined,
    ...(details.updatedInput ? { updatedInput: details.updatedInput } : {}),
    ...(details.message ? { message: details.message } : {}),
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
