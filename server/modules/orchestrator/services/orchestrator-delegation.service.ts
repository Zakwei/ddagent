import { orchestratorMessagesDb, providerAccountsDb, sessionsDb } from '@/modules/database/index.js';
import { providerModelsService, sessionsService } from '@/modules/providers/index.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import type { ProviderRuntimeGateway } from '@/modules/websocket/index.js';
import { SUBAGENT_SESSION_MARKER } from '@/shared/utils.js';
import type { LLMProvider, NormalizedMessage } from '@/shared/types.js';

export type DelegatedRunInput = {
  /** Parent orchestrated session; used for delegation-row bookkeeping. */
  parentSessionId: string;
  /** Delegation transcript row id whose payload is patched as the run streams. */
  delegationRowId: number | null;
  provider: LLMProvider;
  model: string | null;
  effort: string | null;
  accountId: string | null;
  /** Working directory — the parent session's project path. */
  cwd: string;
  command: string;
  permissionMode: string;
  /**
   * Internal helper run (the background session titler and the executor's
   * planner/supervisor/report lane calls): the child is never reused and is
   * named with the subagent marker so `SUBAGENT_SESSION_SQL_FILTER` keeps it
   * out of session lists.
   */
  hidden?: boolean;
};

export type DelegatedRunHandle = {
  childSessionId: string;
  /**
   * Resolves when the provider run settles; `finalText` carries the last
   * assistant text seen. `aborted` marks a user-cancelled run so the executor
   * never auto-retries an intentional stop.
   */
  completed: Promise<{ ok: boolean; error: string | null; finalText: string; aborted: boolean }>;
  abort(): Promise<void>;
};

/**
 * Provider-side plugins can answer a failure with a fake successful reply:
 * opencode-antigravity-auth's fetch interceptor returns an HTTP-200 SSE body
 * whose entire content is the error sentence (rate-limit/quota/auth/empty-
 * response messages), so the runtime settles the turn as a success and the
 * orchestrator's candidate fallback never engages. Match the known prefixes
 * — anchored at the start and capped in length, so a real answer that merely
 * mentions these words further in stays a success.
 */
const SYNTHETIC_ERROR_RE =
  /^(?:all \d+ account\(s\)|quota protection:|missing access token\.|empty response after \d+ attempts|exceeded max account switches)/i;
const SYNTHETIC_ERROR_MAX_LEN = 800;

/** Returns the answer text when it is a provider-synthesized error reply. */
function syntheticProviderError(answer: string): string | null {
  const text = answer.trim();
  if (!text || text.length > SYNTHETIC_ERROR_MAX_LEN) return null;
  return SYNTHETIC_ERROR_RE.test(text) ? text : null;
}

/** Minimal event view the mirror needs: kind + a text-ish payload. */
function previewOf(event: NormalizedMessage): string | null {
  if (event.kind === 'text' || event.kind === 'stream_delta' || event.kind === 'stream_replace') {
    const text = (event.content ?? event.text ?? '') as string;
    return text ? text.slice(0, 500) : null;
  }
  if (event.kind === 'tool_use') {
    return `tool: ${event.toolName ?? 'unknown'}`;
  }
  if (event.kind === 'error') {
    return `error: ${event.reason ?? event.content ?? 'unknown'}`;
  }
  return null;
}

function patchDelegation(
  rowId: number | null,
  patch: Record<string, unknown>,
  notify?: (parentSessionId: string, rowId: number) => void,
  parentSessionId?: string,
): void {
  if (rowId === null) return;
  orchestratorMessagesDb.updatePayload(rowId, patch);
  if (notify && parentSessionId !== undefined) {
    notify(parentSessionId, rowId);
  }
}

/**
 * Finds a reusable child session for (parent, provider, model, account): scans
 * the parent's delegation rows for a previous run on the same target, so a
 * second routed message resumes the child's native transcript instead of
 * starting context-free. `accountId` is part of the match so redundant account
 * failover builds a fresh child bound to the next account instead of reusing
 * the previous account's environment (`null` = provider default).
 */
export function findReusableChildSession(
  parentSessionId: string,
  provider: LLMProvider,
  model: string,
  accountId: string | null = null,
): string | null {
  const rows = orchestratorMessagesDb.list(parentSessionId);
  // Newest-first: a still-running sibling step must never be reused — sharing
  // its session makes the second run hit the registry's "run in progress"
  // guard (parallel plan steps on the same provider+model collided this way).
  // The referenced session must still exist and be active: a delegation row
  // outlives the child session (which is a normal, deletable sidebar entry),
  // and reusing a dead id would run against a row that no longer resolves.
  const match = [...rows].reverse().find((row) => {
    if (
      row.kind !== 'delegation' ||
      row.payload.provider !== provider ||
      row.payload.model !== model ||
      (row.payload.accountId ?? null) !== accountId ||
      row.payload.status === 'running' ||
      typeof row.payload.childSessionId !== 'string'
    ) {
      return false;
    }
    const child = sessionsDb.getSessionById(row.payload.childSessionId as string);
    return Boolean(child) && !child?.isArchived;
  });
  return match ? (match.payload.childSessionId as string) : null;
}

export type OrchestratorDelegationService = {
  run(input: DelegatedRunInput): Promise<DelegatedRunHandle>;
};

/**
 * Runs one delegated child session on a provider runtime.
 *
 * Mirrors the kanban detached-run pattern (kanban.module.ts startKanbanRun):
 * the child is a real app session registered in the run registry, so opening
 * it shows the full live transcript, while a wrapped writer additionally
 * projects compact previews into the parent's delegation row.
 */
export function createOrchestratorDelegationService(deps: {
  runtime: ProviderRuntimeGateway;
  /** Called after each delegation-row update so live viewers re-render. */
  onDelegationUpdate?: (parentSessionId: string, rowId: number) => void;
}): OrchestratorDelegationService {
  return {
    async run(input: DelegatedRunInput): Promise<DelegatedRunHandle> {
      const reusable =
        !input.hidden && input.model !== null
          ? findReusableChildSession(
              input.parentSessionId,
              input.provider,
              input.model,
              input.accountId,
            )
          : null;

      let childSessionId: string;
      if (reusable) {
        childSessionId = reusable;
      } else {
        const created = sessionsService.createAppSession(
          input.provider,
          input.cwd,
          input.command.slice(0, 80),
          input.accountId,
        );
        childSessionId = created.sessionId;
        if (input.hidden) {
          // The derived name never contains the "(subagent)" marker (the
          // normalization strips parentheses), so append it explicitly.
          sessionsDb.updateSessionCustomName(
            childSessionId,
            `${created.sessionName}${SUBAGENT_SESSION_MARKER}`,
          );
        }
      }

      if (input.model) {
        providerModelsService.setSessionModel(input.provider, childSessionId, input.model);
      }
      if (input.effort) {
        providerModelsService.setSessionEffort(input.provider, childSessionId, input.effort);
      }

      const startedAt = Date.now();
      patchDelegation(
        input.delegationRowId,
        {
          childSessionId,
          // Record the account actually bound to this child so a later
          // redundant-failover attempt on another account does not reuse it.
          accountId: input.accountId,
          status: 'running',
          startedAt: new Date(startedAt).toISOString(),
        },
        deps.onDelegationUpdate,
        input.parentSessionId,
      );

      const connection = {
        readyState: 0,
        send: () => {
          /* events reach the parent's viewers via the delegation-row mirror */
        },
      };

      const run = chatRunRegistry.startRun({
        appSessionId: childSessionId,
        provider: input.provider,
        providerSessionId: sessionsDb.getSessionById(childSessionId)?.provider_session_id ?? null,
        connection,
        userId: null,
      });

      if (!run) {
        patchDelegation(input.delegationRowId, { status: 'failed', error: 'run in progress' }, deps.onDelegationUpdate, input.parentSessionId);
        return {
          childSessionId,
          completed: Promise.resolve({ ok: false, error: 'run in progress', finalText: '', aborted: false }),
          abort: async () => undefined,
        };
      }

      let finalText = '';
      // Providers stream answers as incremental `stream_delta` chunks and
      // cumulative `stream_replace` snapshots — the canonical `text` event
      // may never fire when the stream already covered the reply, so the
      // buffer is the fallback source of the child's final answer.
      let streamBuffer = '';
      let lastDeltaPatchAt = 0;
      let aborted = false;
      // Providers report quota/rate-limit/auth failures as an `error` event and
      // then resolve their run promise cleanly (devin sends error+complete on
      // an exhausted quota). Without capturing the event here the turn looks
      // like a successful empty reply, the step settles `done`, and the
      // executor's candidate failover never engages.
      let errorFromEvent: string | null = null;
      const originalWriter = run.writer;
      const wrappedWriter = new Proxy(originalWriter, {
        get: (target, property, receiver) => {
          if (property === 'send') {
            return (data: unknown) => {
              (target.send as (value: unknown) => void).call(target, data);
              const event = (data ?? {}) as NormalizedMessage;
              if (event.role === 'user') return;
              if (event.kind === 'text') {
                finalText = (event.content ?? event.text ?? '') as string;
              } else if (event.kind === 'stream_replace') {
                streamBuffer = (event.content ?? '') as string;
              } else if (event.kind === 'stream_delta') {
                streamBuffer += (event.content ?? '') as string;
              } else if (event.kind === 'error') {
                // Keep only the last error text — providers may emit several as
                // they fail over internally; the final one is the real cause.
                errorFromEvent = ((event.reason ?? event.content ?? '') as string) || 'provider error';
              }
              const preview = previewOf(event);
              // Deltas arrive per-token — patching the transcript row each
              // time would spam SQLite; throttle those, others go through.
              const isDelta = event.kind === 'stream_delta';
              const now = Date.now();
              if (preview && (!isDelta || now - lastDeltaPatchAt > 500)) {
                if (isDelta) lastDeltaPatchAt = now;
                patchDelegation(input.delegationRowId, { lastEvent: preview }, deps.onDelegationUpdate, input.parentSessionId);
              }
            };
          }
          return Reflect.get(target, property, receiver);
        },
      });

      // The child row is pinned to an account by createAppSession (explicit
      // input.accountId, else the provider's default). Resolve the env from the
      // stored row so the run matches what a direct send on the same session
      // would use — and so a reused child keeps its own account rather than the
      // current input's (possibly null) one.
      const childAccountId = sessionsDb.getSessionById(childSessionId)?.account_id ?? null;
      const accountEnv = childAccountId
        ? providerAccountsDb.get(childAccountId)?.envOverrides ?? null
        : null;

      const runtimeOptions: Record<string, unknown> = {
        sessionId: childSessionId,
        cwd: input.cwd,
        projectPath: input.cwd,
        model: input.model ?? undefined,
        effort: input.effort ?? undefined,
        permissionMode: input.permissionMode,
        ...(accountEnv ? { env: accountEnv } : {}),
      };

      const completed = (async () => {
        let runError: string | null = null;
        try {
          await deps.runtime.run(input.provider, input.command, runtimeOptions, wrappedWriter);
        } catch (error) {
          runError = error instanceof Error ? error.message : String(error);
        } finally {
          const answer = finalText || streamBuffer;
          if (!runError && !aborted) {
            // A fake-success answer wins the message; otherwise a provider that
            // reported the failure as an `error` event with no answer at all
            // (devin sending error+complete on an exhausted quota) is still a
            // failed run, not an empty success.
            runError = syntheticProviderError(answer) ?? (answer.trim() ? null : errorFromEvent);
          }
          chatRunRegistry.completeRunIfCurrent(run, { exitCode: runError ? 1 : 0 });
          patchDelegation(
            input.delegationRowId,
            {
              status: aborted ? 'aborted' : runError ? 'failed' : 'done',
              error: runError,
              finalText: answer.slice(-2000),
              finishedAt: new Date().toISOString(),
              durationMs: Date.now() - startedAt,
            },
            deps.onDelegationUpdate,
            input.parentSessionId,
          );
        }
        return { ok: runError === null, error: runError, finalText: finalText || streamBuffer, aborted };
      })();

      return {
        childSessionId,
        completed,
        abort: async () => {
          aborted = true;
          // Flag before awaiting: the provider abort may settle the dispatch
          // promise mid-await, and the safety net must then report an aborted
          // run instead of a spurious exitCode-1 failure.
          chatRunRegistry.markAborted(childSessionId);
          await deps.runtime.abort(input.provider, childSessionId).catch(() => false);
          // Run-scoped complete: the session-keyed variant would terminate a
          // newer run that a queued message started while the abort was in
          // flight — exactly the race completeRunIfCurrent exists to prevent.
          chatRunRegistry.completeRunIfCurrent(run, { exitCode: 0, aborted: true });
        },
      };
    },
  };
}
