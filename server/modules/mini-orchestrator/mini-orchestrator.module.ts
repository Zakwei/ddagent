import { orchestratorMessagesDb, sessionsDb } from '@/modules/database/index.js';
import { createMiniOrchestratorRouter } from '@/modules/mini-orchestrator/mini-orchestrator.routes.js';
import { createMiniOrchestratorConfigService } from '@/modules/mini-orchestrator/services/mini-orchestrator-config.service.js';
import { createMiniOrchestratorExecutor } from '@/modules/mini-orchestrator/services/mini-orchestrator.service.js';
import { createOrchestratorDelegationService } from '@/modules/orchestrator/index.js';
import { providerRuntimeService } from '@/modules/providers/index.js';
import { chatRunRegistry, connectedClients, WS_OPEN_STATE } from '@/modules/websocket/index.js';
import { MINI_ORCHESTRATOR_PROVIDER, createOrchestratorStatusFrame, safeSocketSend } from '@/shared/utils.js';
import type { AnyRecord, LLMProvider, OrchestratorMessage, RealtimeClientConnection } from '@/shared/types.js';

/**
 * Mini-orchestrator module.
 *
 * A lightweight sibling of the full orchestrator: it owns the same
 * `orchestrator_messages` transcript and streams the same `status` frames, but
 * drives a two-role pipeline (non-flash thinker plans, flash worker executes).
 * Wires the config store, delegation mirror, and executor into the HTTP surface
 * mounted at `/api/mini-orchestrator` plus the `miniOrchestratorRuntime` entry
 * consumed by the chat dispatch path for `provider='mini-orchestrator'`.
 */
const configService = createMiniOrchestratorConfigService();

/** Forwards one parent-transcript entry as a live mini-orchestrator `status` frame. */
function publishEntry(entry: OrchestratorMessage): void {
  const frame = createOrchestratorStatusFrame(entry, MINI_ORCHESTRATOR_PROVIDER);
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

const delegation = createOrchestratorDelegationService({
  runtime: providerRuntimeService,
  onDelegationUpdate: (sessionId, rowId) => {
    const entry = orchestratorMessagesDb.getById(rowId);
    if (entry) publishEntry(entry);
  },
});

const executor = createMiniOrchestratorExecutor({
  getConfig: () => configService.get(),
  delegation,
  publish: publishEntry,
  resolveSessionCwd: (sessionId) => sessionsDb.getSessionById(sessionId)?.project_path ?? null,
});

/**
 * Entry surface used by the websocket/chat dispatch layer for mini-orchestrated
 * sessions. A plain object lets the chat handler call in without a circular
 * import (the websocket module imports the orchestrator registry).
 */
export const miniOrchestratorRuntime = {
  config: configService,

  /** Handles one user message sent to a mini-orchestrated session. */
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
        code: 'MINI_ORCHESTRATOR_DISABLED',
        error: 'Mini orchestrator is disabled in Settings → Mini orchestration.',
      };
    }

    const run = chatRunRegistry.startRun({
      appSessionId: sessionId,
      provider: MINI_ORCHESTRATOR_PROVIDER as LLMProvider,
      providerSessionId: null,
      connection: input.connection,
      userId: input.userId,
    });
    if (!run) {
      return { ok: false, code: 'RUN_IN_PROGRESS', error: `Session "${sessionId}" already has a run in progress.` };
    }

    const options = {
      ...input.options,
      cwd:
        typeof input.options.cwd === 'string' && input.options.cwd
          ? input.options.cwd
          : sessionsDb.getSessionById(sessionId)?.project_path ?? '',
    };

    try {
      const result = await executor.run({ sessionId, content: input.content, options });
      return result.ok ? { ok: true } : { ok: false, code: result.code, error: result.error };
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return { ok: false, code: 'MINI_ORCHESTRATOR_ERROR', error: message };
    } finally {
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 0 });
    }
  },

  /** Resumes a plan the user edited/approved in the UI (`POST /plan/confirm`). */
  async confirmPlan(
    sessionId: string,
    steps: unknown,
    options: AnyRecord = {},
  ): Promise<{ ok: true } | { ok: false; code: string; error: string }> {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session || session.provider !== MINI_ORCHESTRATOR_PROVIDER) {
      return { ok: false, code: 'SESSION_NOT_FOUND', error: `Mini-orchestrated session "${sessionId}" not found.` };
    }
    const stubConnection = { readyState: 0, send: () => undefined } as unknown as RealtimeClientConnection;
    const run = chatRunRegistry.startRun({
      appSessionId: sessionId,
      provider: MINI_ORCHESTRATOR_PROVIDER as LLMProvider,
      providerSessionId: null,
      connection: stubConnection,
      userId: null,
    });
    if (!run) {
      return { ok: false, code: 'RUN_IN_PROGRESS', error: `Session "${sessionId}" already has a run in progress.` };
    }
    try {
      return await executor.confirm(sessionId, steps, options);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return { ok: false, code: 'MINI_ORCHESTRATOR_ERROR', error: message };
    } finally {
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 0 });
    }
  },

  /** Re-runs the session's last plan (`POST /sessions/:id/resume`). */
  async resume(
    sessionId: string,
    options: AnyRecord = {},
  ): Promise<{ ok: true } | { ok: false; code: string; error: string }> {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session || session.provider !== MINI_ORCHESTRATOR_PROVIDER) {
      return { ok: false, code: 'SESSION_NOT_FOUND', error: `Mini-orchestrated session "${sessionId}" not found.` };
    }
    const stubConnection = { readyState: 0, send: () => undefined } as unknown as RealtimeClientConnection;
    const run = chatRunRegistry.startRun({
      appSessionId: sessionId,
      provider: MINI_ORCHESTRATOR_PROVIDER as LLMProvider,
      providerSessionId: null,
      connection: stubConnection,
      userId: null,
    });
    if (!run) {
      return { ok: false, code: 'RUN_IN_PROGRESS', error: `Session "${sessionId}" already has a run in progress.` };
    }
    try {
      return await executor.resume(sessionId, options);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return { ok: false, code: 'MINI_ORCHESTRATOR_ERROR', error: message };
    } finally {
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 0 });
    }
  },

  /** Aborts all live delegated runs of a parent session. */
  async abort(sessionId: string): Promise<boolean> {
    return executor.abort(sessionId);
  },
};

/** Mini-orchestrator router mounted by the server entrypoint at `/api/mini-orchestrator`. */
export const miniOrchestratorRoutes = createMiniOrchestratorRouter(configService, {
  confirmPlan: (sessionId, steps, options) => miniOrchestratorRuntime.confirmPlan(sessionId, steps, options),
  resume: (sessionId, options) => miniOrchestratorRuntime.resume(sessionId, options),
});
