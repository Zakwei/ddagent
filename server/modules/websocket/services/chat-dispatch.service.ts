import path from 'node:path';

import { sessionsDb } from '@/modules/database/index.js';
import { providerModelsService } from '@/modules/providers/index.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import {
  getGlobalImageAssetsDir,
  isImageAttachmentDescriptor,
  normalizeAttachmentDescriptors,
  type ChatAttachmentDescriptor,
} from '@/shared/image-attachments.js';
import type {
  AnyRecord,
  LLMProvider,
  ProviderPermissionDecision,
  ProviderRuntimeWriter,
  RealtimeClientConnection,
} from '@/shared/types.js';

/**
 * Application boundary for dispatching provider runs and approvals.
 *
 * Declared here (rather than imported from the websocket handler) so the
 * command dispatcher can be reused by every server-side sender — the live chat
 * socket and the persisted message queue — without importing each other.
 */
export type ProviderRuntimeGateway = {
  hasRuntime(provider: string): boolean;
  run(
    provider: LLMProvider,
    command: string,
    options: AnyRecord,
    writer: ProviderRuntimeWriter,
  ): Promise<unknown>;
  abort(provider: LLMProvider, sessionId: string): Promise<boolean>;
  setSessionPermissionMode?(provider: LLMProvider, sessionId: string, mode: string): void;
  resolveToolApproval(requestId: string, payload: ProviderPermissionDecision): void;
  getPendingApprovalsForSession(sessionId: string): unknown[];
};

/**
 * Trust boundary for client-supplied image attachments: chat.send options come
 * straight from the browser, and the provider runtimes read the referenced
 * files off disk (Claude base64-encodes them into the prompt). Only images
 * that live directly inside the global upload store (`~/.ddagent/assets`,
 * where POST /api/assets/images puts them) are allowed through — anything
 * else (absolute paths elsewhere, traversal, subdirectories) is dropped.
 *
 * Exported for tests; `assetsRootOverride` exists only for them.
 */
export function filterAttachmentsToUploadStore(
  attachments: unknown,
  assetsRootOverride?: string,
): ChatAttachmentDescriptor[] {
  const assetsRoot = path.resolve(assetsRootOverride ?? getGlobalImageAssetsDir());

  return normalizeAttachmentDescriptors(attachments).filter((descriptor) => {
    // Relative paths are anchored in the store; absolute ones must already be in it.
    const resolved = path.resolve(assetsRoot, descriptor.path);
    const relative = path.relative(assetsRoot, resolved);
    const isDirectChild =
      relative.length > 0 &&
      !relative.startsWith('..') &&
      !path.isAbsolute(relative) &&
      !relative.includes(path.sep) &&
      !relative.includes('/');

    if (!isDirectChild) {
      console.warn(`[Chat] Dropping attachment outside the upload store: ${descriptor.path}`);
    }
    return isDirectChild;
  });
}

/** Backward-compatible image filter consumed by existing websocket tests. */
export function filterImagesToUploadStore(
  images: unknown,
  assetsRootOverride?: string,
): ChatAttachmentDescriptor[] {
  return filterAttachmentsToUploadStore(images, assetsRootOverride);
}

export type ChatDispatchResult =
  | { ok: true }
  | { ok: false; code: string; error: string; sessionId: string };

/**
 * Dispatches one chat command to a provider runtime for an app session.
 *
 * This is the single code path a server-side send takes, whether it arrives
 * over the live websocket or is replayed from the persisted queue. It resolves
 * the session row (provider, project path, provider-native id all come from the
 * database — never from the client), records the model/effort so reopening the
 * session restores them, re-validates attachments against the upload store,
 * registers the run, and awaits the provider runtime.
 *
 * Returns a structured failure instead of writing to a socket so callers decide
 * how to report it (the websocket handler emits `protocol_error`; the queue
 * marks the row failed).
 */
export async function dispatchChatCommand(
  runtime: ProviderRuntimeGateway,
  input: {
    sessionId: string;
    content: string;
    options: AnyRecord;
    userId: string | number | null;
    connection: RealtimeClientConnection;
  },
): Promise<ChatDispatchResult> {
  const { sessionId, content, options: clientOptions, userId, connection } = input;

  const session = sessionsDb.getSessionById(sessionId);
  if (!session) {
    return {
      ok: false,
      code: 'SESSION_NOT_FOUND',
      error: `Session "${sessionId}" was not found. Create it via POST /api/providers/sessions first.`,
      sessionId,
    };
  }

  const provider = session.provider as LLMProvider;
  if (!runtime.hasRuntime(provider)) {
    return {
      ok: false,
      code: 'UNSUPPORTED_PROVIDER',
      error: `Provider "${provider}" is not available.`,
      sessionId,
    };
  }

  const run = chatRunRegistry.startRun({
    appSessionId: sessionId,
    provider,
    providerSessionId: session.provider_session_id,
    connection,
    userId,
  });

  if (!run) {
    return {
      ok: false,
      code: 'RUN_IN_PROGRESS',
      error: `Session "${sessionId}" already has a run in progress.`,
      sessionId,
    };
  }

  // Record what the session's first turn runs with, so reopening it later
  // restores the same model and reasoning effort and the resume path has a
  // session-scoped answer to use.
  //
  // Later turns never rewrite either value: the composer resolves the open
  // session's model over HTTP, so a message sent before that answer lands (or
  // replayed from a queue) carries the per-provider default and would silently
  // switch the session — e.g. a Devin session falling back to SWE-2 Max. An
  // explicit change goes through the active-model/active-effort routes.
  const recordedModel = typeof session.model === 'string' ? session.model.trim() : '';
  if (!recordedModel && typeof clientOptions.model === 'string' && clientOptions.model.trim()) {
    providerModelsService.setSessionModel(provider, sessionId, clientOptions.model);
  }
  const recordedEffort = typeof session.effort === 'string' ? session.effort.trim() : '';
  if (!recordedEffort && typeof clientOptions.effort === 'string' && clientOptions.effort.trim()) {
    providerModelsService.setSessionEffort(provider, sessionId, clientOptions.effort);
  }

  const attachmentCandidates = [
    ...normalizeAttachmentDescriptors(clientOptions.images),
    ...normalizeAttachmentDescriptors(clientOptions.files),
    ...normalizeAttachmentDescriptors(clientOptions.attachments),
  ];
  const verifiedAttachments = filterAttachmentsToUploadStore(attachmentCandidates);
  const uniqueAttachments = verifiedAttachments.filter(
    (descriptor, index, all) => all.findIndex((candidate) => candidate.path === descriptor.path) === index,
  );

  // The provider runtimes receive the stable app session id. When their
  // CLI/SDK needs the provider-native id for resume, they resolve it from the
  // session row themselves (sessionsService.resolveProviderSessionId).
  // Brand-new sessions have no provider id yet, so the runtime starts fresh
  // and announces one, which the gateway writer captures and maps back to the
  // app session id.
  const runtimeOptions: AnyRecord = {
    ...clientOptions,
    // Attachments are re-validated server-side: only direct children of the
    // global upload store may reach provider runtimes or their file tools.
    attachments: uniqueAttachments,
    images: uniqueAttachments.filter(isImageAttachmentDescriptor),
    files: uniqueAttachments.filter((descriptor) => !isImageAttachmentDescriptor(descriptor)),
    sessionId,
    cwd: clientOptions.cwd ?? session.project_path ?? undefined,
    projectPath: session.project_path ?? clientOptions.projectPath,
  };

  try {
    await runtime.run(provider, content, runtimeOptions, run.writer);
    return { ok: true };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`[Chat] Provider runtime "${provider}" failed`, { sessionId, error: message });
    return { ok: false, code: 'RUNTIME_ERROR', error: message, sessionId };
  } finally {
    // Safety net: a runtime that crashed (or resolved) without emitting its
    // terminal `complete` would otherwise leave the session stuck in
    // "processing" forever on every connected client. Scoped to THIS run —
    // a queued message can start the session's next run before this promise
    // settles, and the session-keyed completeRun would kill that new run.
    chatRunRegistry.completeRunIfCurrent(run, { exitCode: 1 });
  }
}
