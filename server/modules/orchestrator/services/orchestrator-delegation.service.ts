import { orchestratorMessagesDb, providerAccountsDb, sessionsDb } from '@/modules/database/index.js';
import { providerModelsService, sessionsService } from '@/modules/providers/index.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import type { ProviderRuntimeGateway } from '@/modules/websocket/index.js';
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
};

export type DelegatedRunHandle = {
  childSessionId: string;
  /** Resolves when the provider run settles; `finalText` carries the last assistant text seen. */
  completed: Promise<{ ok: boolean; error: string | null; finalText: string }>;
  abort(): Promise<void>;
};

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
 * Finds a reusable child session for (parent, provider, model): scans the
 * parent's delegation rows for a previous run on the same target, so a second
 * routed message resumes the child's native transcript instead of starting
 * context-free.
 */
export function findReusableChildSession(
  parentSessionId: string,
  provider: LLMProvider,
  model: string,
): string | null {
  const rows = orchestratorMessagesDb.list(parentSessionId);
  // Newest-first: a still-running sibling step must never be reused — sharing
  // its session makes the second run hit the registry's "run in progress"
  // guard (parallel plan steps on the same provider+model collided this way).
  const match = [...rows].reverse().find(
    (row) =>
      row.kind === 'delegation' &&
      row.payload.provider === provider &&
      row.payload.model === model &&
      row.payload.status !== 'running' &&
      typeof row.payload.childSessionId === 'string',
  );
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
        input.model !== null
          ? findReusableChildSession(input.parentSessionId, input.provider, input.model)
          : null;

      const childSessionId =
        reusable ??
        sessionsService.createAppSession(
          input.provider,
          input.cwd,
          input.command.slice(0, 80),
          input.accountId,
        ).sessionId;

      if (input.model) {
        providerModelsService.setSessionModel(input.provider, childSessionId, input.model);
      }
      if (input.effort) {
        providerModelsService.setSessionEffort(input.provider, childSessionId, input.effort);
      }

      patchDelegation(
        input.delegationRowId,
        { childSessionId, status: 'running' },
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
          completed: Promise.resolve({ ok: false, error: 'run in progress', finalText: '' }),
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

      const accountEnv = input.accountId
        ? providerAccountsDb.get(input.accountId)?.envOverrides ?? null
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
          chatRunRegistry.completeRunIfCurrent(run, { exitCode: runError ? 1 : 0 });
          patchDelegation(
            input.delegationRowId,
            {
              status: aborted ? 'aborted' : runError ? 'failed' : 'done',
              error: runError,
              finalText: answer.slice(-2000),
            },
            deps.onDelegationUpdate,
            input.parentSessionId,
          );
        }
        return { ok: runError === null, error: runError, finalText: finalText || streamBuffer };
      })();

      return {
        childSessionId,
        completed,
        abort: async () => {
          aborted = true;
          await deps.runtime.abort(input.provider, childSessionId).catch(() => false);
          chatRunRegistry.completeRun(childSessionId, { exitCode: 1, aborted: true });
        },
      };
    },
  };
}
