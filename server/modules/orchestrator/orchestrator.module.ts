import { orchestratorMessagesDb, providerAccountsDb, sessionsDb } from '@/modules/database/index.js';
import { createOrchestratorConfigService } from '@/modules/orchestrator/services/orchestrator-config.service.js';
import { createOrchestratorRouter } from '@/modules/orchestrator/orchestrator.routes.js';
import { createOrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import { createOrchestratorExecutor } from '@/modules/orchestrator/services/orchestrator-executor.service.js';
import { createOrchestratorRouterService } from '@/modules/orchestrator/services/orchestrator-router.service.js';
import { providerRuntimeService } from '@/modules/providers/index.js';
import { chatRunRegistry, connectedClients, WS_OPEN_STATE } from '@/modules/websocket/index.js';
import { worktreeServices } from '@/modules/worktrees/index.js';
import type {
  AnyRecord,
  LLMProvider,
  OrchestratorMessage,
  QuotaAccount,
  RealtimeClientConnection,
} from '@/shared/types.js';
import { ORCHESTRATOR_PROVIDER, safeSocketSend } from '@/shared/utils.js';

/**
 * Production orchestrator module.
 *
 * Wires the config store, router, delegation service, and executor into the
 * HTTP surface mounted at `/api/orchestrator` plus the `orchestratorRuntime`
 * entry consumed by the chat dispatch path for `provider='orchestrator'`
 * sessions. The quota snapshot is injected lazily via `setQuotaSource` so this
 * module does not import the quota module's internals at load time.
 */
const configService = createOrchestratorConfigService();

/** Last known quota accounts; refreshed on every dispatch by refreshQuota. */
let cachedAccounts: QuotaAccount[] | null = null;
let quotaSource: (() => Promise<{ accounts: QuotaAccount[] } | null>) | null = null;

/**
 * Forwards one parent-transcript entry as a live `status` frame: the parent's
 * own run writer (registry fan-out to subscribed sockets) plus a coarse
 * broadcast so panes subscribed to other sessions still see updates.
 */
function publishEntry(entry: OrchestratorMessage): void {
  const frame = {
    kind: 'status' as const,
    sessionId: entry.sessionId,
    context: { orchestratorKind: entry.kind, ...entry.payload },
    summary: entry.kind,
  };
  const parentRun = chatRunRegistry.getRun(entry.sessionId);
  if (parentRun) {
    parentRun.writer.send(frame);
  }
  const serialized = JSON.stringify(frame);
  connectedClients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) {
      safeSocketSend(client, serialized);
    }
  });
}

const router = createOrchestratorRouterService({
  getConfig: () => configService.get(),
  availability: {
    isRuntimeAvailable: (provider) => providerRuntimeService.hasRuntime(provider),
    get accounts() {
      return cachedAccounts;
    },
  },
});

const delegation = createOrchestratorDelegationService({
  runtime: providerRuntimeService,
  /** Live-updates the delegation row a running child is mirroring into. */
  onDelegationUpdate: (sessionId, rowId) => {
    const entry = orchestratorMessagesDb.getById(rowId);
    if (entry) publishEntry(entry);
  },
});

const executor = createOrchestratorExecutor({
  getConfig: () => configService.get(),
  router,
  delegation,
  /** Streams each appended parent-transcript row to live viewers. */
  publish: publishEntry,
  worktrees: worktreeServices,
  resolveSessionCwd: (sessionId) => sessionsDb.getSessionById(sessionId)?.project_path ?? null,
});

/**
 * Entry surface used by the websocket/chat dispatch layer for orchestrated
 * sessions. Keeping it a plain object lets the chat handler call into the
 * module without circular imports.
 */
export const orchestratorRuntime = {
  config: configService,
  router,
  messages: orchestratorMessagesDb,
  accounts: providerAccountsDb,

  /** Registers the quota snapshot provider (called once by the server entry). */
  setQuotaSource(source: () => Promise<{ accounts: QuotaAccount[] } | null>): void {
    quotaSource = source;
  },

  /** Refreshes the cached account list used by the synchronous router. */
  async refreshQuota(): Promise<void> {
    if (!quotaSource) return;
    try {
      cachedAccounts = (await quotaSource())?.accounts ?? null;
    } catch {
      cachedAccounts = null;
    }
  },

  /**
   * Handles one user message sent to an orchestrated session. Registered as a
   * parent run so the UI shows the busy state and `chat.subscribe` replays the
   * buffered orchestrator frames; the actual work is delegated per step.
   */
  async handleMessage(input: {
    sessionId: string;
    content: string;
    options: AnyRecord;
    userId: string | number | null;
    connection: RealtimeClientConnection;
  }): Promise<{ ok: true } | { ok: false; code: string; error: string }> {
    const { sessionId } = input;

    const config = configService.get();
    if (!config.enabled) {
      return {
        ok: false,
        code: 'ORCHESTRATOR_DISABLED',
        error: 'Orchestrator is disabled in Settings → Orchestration.',
      };
    }

    const run = chatRunRegistry.startRun({
      appSessionId: sessionId,
      provider: ORCHESTRATOR_PROVIDER as LLMProvider,
      providerSessionId: null,
      connection: input.connection,
      userId: input.userId,
    });
    if (!run) {
      return {
        ok: false,
        code: 'RUN_IN_PROGRESS',
        error: `Session "${sessionId}" already has a run in progress.`,
      };
    }

    await this.refreshQuota();

    // The client does not send cwd — children inherit the parent session's
    // project path (or the plan-run worktree when enabled).
    const options = {
      ...input.options,
      cwd:
        typeof input.options.cwd === 'string' && input.options.cwd
          ? input.options.cwd
          : sessionsDb.getSessionById(sessionId)?.project_path ?? '',
    };

    try {
      const result = await executor.run({
        sessionId,
        content: input.content,
        options,
        connection: input.connection,
      });
      return result.ok ? { ok: true } : { ok: false, code: result.code, error: result.error };
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return { ok: false, code: 'ORCHESTRATOR_ERROR', error: message };
    } finally {
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 0 });
    }
  },

  /**
   * Resumes a plan the user edited/approved in the UI (`POST /plan/confirm`).
   * Uses a stub connection — live frames still reach viewers through
   * `publishEntry`'s broadcast to connected clients.
   */
  async confirmPlan(
    sessionId: string,
    steps: unknown,
    options: AnyRecord = {},
  ): Promise<{ ok: true } | { ok: false; code: string; error: string }> {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session || session.provider !== ORCHESTRATOR_PROVIDER) {
      return { ok: false, code: 'SESSION_NOT_FOUND', error: `Orchestrated session "${sessionId}" not found.` };
    }
    const stubConnection = {
      readyState: 0,
      send: () => undefined,
    } as unknown as RealtimeClientConnection;
    const run = chatRunRegistry.startRun({
      appSessionId: sessionId,
      provider: ORCHESTRATOR_PROVIDER as LLMProvider,
      providerSessionId: null,
      connection: stubConnection,
      userId: null,
    });
    if (!run) {
      return { ok: false, code: 'RUN_IN_PROGRESS', error: `Session "${sessionId}" already has a run in progress.` };
    }

    await this.refreshQuota();
    try {
      return await executor.confirm(sessionId, steps, options);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return { ok: false, code: 'ORCHESTRATOR_ERROR', error: message };
    } finally {
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 0 });
    }
  },

  /** Aborts all live delegated runs of a parent session. */
  async abort(sessionId: string): Promise<boolean> {
    return executor.abort(sessionId);
  },
};

/** Orchestrator router mounted by the server entrypoint at `/api/orchestrator`. */
export const orchestratorRoutes = createOrchestratorRouter(configService, {
  confirmPlan: (sessionId, steps, options) => orchestratorRuntime.confirmPlan(sessionId, steps, options),
});
