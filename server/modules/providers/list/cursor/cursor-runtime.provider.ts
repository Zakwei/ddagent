import crossSpawn from 'cross-spawn';

import type {
  AnyRecord,
  ProviderRuntimeWriter,
  IProviderRuntime,
} from '@/shared/index.js';
import {
  appendFilesInputTag,
  appendImagesInputTag,
  normalizeAttachmentDescriptors,
  createCompleteMessage,
  createNormalizedMessage,
  flattenPromptForWindowsShell,
  providerChildEnv,
} from '@/shared/index.js';
import { notifyRunFailed, notifyRunStopped } from '@/modules/notifications/index.js';

import { normalizeCursorToolInput } from './cursor-sessions.provider.js';

// cross-spawn resolves .cmd shims/PATHEXT on Windows and delegates to
// child_process.spawn everywhere else.
const spawnFunction = crossSpawn;

let activeCursorProcesses = new Map<any, any>(); // Track active processes by session ID

// SIGTERM -> SIGKILL grace, and how long cursor-agent may linger after its
// `result` line before it is stopped (a lingering process keeps store.db open
// while the next turn starts a second one).
const CURSOR_KILL_GRACE_MS = 2000;
const CURSOR_RESULT_EXIT_GRACE_MS = 3000;
const CURSOR_STDERR_TAIL_CHARS = 4000;

function hasExited(child: any) {
  return child.exitCode != null || child.signalCode != null;
}

// Sends SIGTERM and escalates to SIGKILL if the process ignores it.
function terminateCursorProcess(child: any): boolean {
  if (hasExited(child)) {
    return true;
  }
  const signalled = child.kill('SIGTERM');
  const escalation = setTimeout(() => {
    if (!hasExited(child)) {
      child.kill('SIGKILL');
    }
  }, CURSOR_KILL_GRACE_MS);
  escalation.unref?.();
  return signalled;
}

const WORKSPACE_TRUST_PATTERNS: any = [
  /workspace trust required/i,
  /do you trust the contents of this directory/i,
  /working with untrusted contents/i,
  /pass --trust,\s*--yolo,\s*or -f/i
];

function isWorkspaceTrustPrompt(text: any = '') {
  if (!text || typeof text !== 'string') {
    return false;
  }

  return WORKSPACE_TRUST_PATTERNS.some((pattern: any) => pattern.test(text));
}

// cursor-agent `stream-json` names each tool by a `<kind>ToolCall` key
// (`shellToolCall`, `readToolCall`, ...); MCP/other tools use `function`.
const CURSOR_TOOL_NAMES: Record<string, string> = {
  shellToolCall: 'Bash',
  readToolCall: 'Read',
  editToolCall: 'Edit',
  writeToolCall: 'Write',
  deleteToolCall: 'Delete',
  grepToolCall: 'Grep',
  globToolCall: 'Glob',
  lsToolCall: 'List',
  todoToolCall: 'TodoWrite',
  updateTodosToolCall: 'TodoWrite',
  // History names this tool ApplyPatch and shows it as Edit.
  applyPatchToolCall: 'ApplyPatch',
};

function readCursorToolResultText(result: AnyRecord | undefined): { content: string; isError: boolean } {
  const error = result?.error ?? result?.failure;
  if (error) {
    const message = typeof error === 'string' ? error : (error.message ?? error.errorMessage ?? error.stderr);
    return { content: typeof message === 'string' ? message : JSON.stringify(error), isError: true };
  }
  const success = result?.success ?? result;
  if (!success || typeof success !== 'object') return { content: typeof success === 'string' ? success : '', isError: false };
  const output = [success.content, success.stdout, success.stderr, success.output]
    .filter((part) => typeof part === 'string' && part.length > 0)
    .join('\n');
  const exitCode = typeof success.exitCode === 'number' ? success.exitCode : 0;
  return { content: output || JSON.stringify(success), isError: exitCode !== 0 };
}

/**
 * Maps one cursor-agent `tool_call` event (`subtype` started/completed) onto
 * the normalized tool_use / tool_result rows. The call id is the same
 * `toolCallId` history uses, so live rows dedupe against the reloaded ones.
 */
// Exported for tests: live tool-call mapping.
export function buildCursorToolCallMessages(event: AnyRecord, sessionId: string | null) {
  const toolId = typeof event?.call_id === 'string' ? event.call_id : null;
  const toolCall = event?.tool_call && typeof event.tool_call === 'object' ? event.tool_call as AnyRecord : null;
  if (!toolId || !toolCall) return [];
  const kind = Object.keys(toolCall)[0];
  if (!kind) return [];
  const call = (toolCall[kind] ?? {}) as AnyRecord;
  let rawToolName = kind === 'function'
    ? String(call.name ?? 'Tool')
    : CURSOR_TOOL_NAMES[kind] ?? kind.replace(/ToolCall$/, '');
  let toolInput: unknown = call.args;
  if (kind === 'function' && typeof call.arguments === 'string') {
    try { toolInput = JSON.parse(call.arguments); } catch { toolInput = call.arguments; }
  }
  // MCP calls wrap the real tool name and arguments.
  if (kind === 'mcpToolCall' && call.args && typeof call.args === 'object') {
    rawToolName = String(call.args.toolName ?? call.args.name ?? 'MCP');
    toolInput = call.args.args ?? call.args;
  }
  // Same name/input normalization as the history loader, so live cards
  // match the reloaded ones.
  const toolName = rawToolName === 'ApplyPatch' ? 'Edit' : rawToolName;

  if (event.subtype === 'started') {
    return [createNormalizedMessage({
      id: toolId,
      kind: 'tool_use',
      toolId,
      toolName,
      toolInput: normalizeCursorToolInput(rawToolName, toolInput ?? {}),
      sessionId,
      provider: 'cursor',
    })];
  }
  if (event.subtype === 'completed') {
    const { content, isError } = readCursorToolResultText(call.result);
    return [createNormalizedMessage({
      id: `${toolId}__result`, kind: 'tool_result', toolId, content, isError, sessionId, provider: 'cursor',
    })];
  }
  return [];
}

// Consumed by provider runtime services and lifecycle tests.
export async function spawnCursor(command: string, options: AnyRecord = {}, ws: ProviderRuntimeWriter, context: AnyRecord) {
  return new Promise((resolve: any, reject: any) => {
    // An async promise executor drops rejections on the floor (unhandled
    // rejection → process crash), so the body runs inside `main` and forwards
    // its outcome to reject() — the same pattern the devin runtime uses.
    async function main() {
    const {
      sessionId,
      projectPath,
      cwd,
      toolsSettings,
      skipPermissions,
      permissionMode,
      model,
      sessionSummary,
      images,
      files
    } = options;
    // Callers pass the stable app session id; the CLI resumes with the
    // provider-native id recorded on the session row.
    const providerSessionId = context.resolveProviderSessionId(sessionId);
    const resolvedModel = await context.resolveResumeModel(sessionId, model);
    let capturedSessionId = providerSessionId; // Track the provider-native session id throughout the process
    let sessionCreatedSent = false; // Track if we've already sent session-created event
    let hasRetriedWithTrust = false;
    let settled = false;
    // The unified lifecycle contract requires exactly one terminal `complete`
    // per run. Cursor surfaces completion twice (the `result` JSON line and
    // the process close), so the first emission wins.
    let completeSent = false;
    // Outcome of the `result` line: null until it arrives.
    let resultSucceeded: boolean | null = null;
    // Kind of the live row currently open on the client (`stream_end` closes it).
    let openLiveKind: 'text' | 'thinking' | null = null;
    // Tail of stderr; shown only when the run fails.
    let stderrTail = '';

    // Build Cursor CLI command
    const baseArgs: any = [];

    // Build flags allowing both resume and prompt together (reply in existing session)
    // Treat a known provider-native id as intention to resume
    if (providerSessionId) {
      baseArgs.push('--resume=' + providerSessionId);
    }

    const hasAttachments =
      normalizeAttachmentDescriptors(images).length > 0
      || normalizeAttachmentDescriptors(files).length > 0;
    if ((command && command.trim()) || hasAttachments) {
      // Provide a prompt (works for both new and resumed sessions). Image
      // attachments ride along as an <images_input> path list appended to the
      // prompt; the session history reader strips the tag back out for display.
      // cursor-agent is a .cmd shim on Windows, so the whole argument must be
      // newline-free or cmd.exe silently truncates it at the first newline.
      const promptWithAttachments = appendFilesInputTag(
        appendImagesInputTag(command || '', images),
        files
      );
      baseArgs.push('-p', flattenPromptForWindowsShell(promptWithAttachments));

      // Model overrides are applied to both new and resumed sessions so a
      // session-scoped change request can take effect on the next turn.
      if (resolvedModel) {
        baseArgs.push('--model', resolvedModel);
      }

      // Request streaming JSON when we are providing a prompt
      baseArgs.push('--output-format', 'stream-json');
    }

    // Map DDAgent permission modes onto cursor-agent flags: bypass forces
    // every command (`-f`), plan starts the read-only `--mode plan`; default
    // keeps print mode's own behaviour (edits allowed, shell commands gated by
    // the CLI's allowlist). Cursor no longer offers acceptEdits, so a stale
    // stored 'acceptEdits' is the default mode.
    // cursor-agent has no flag for a shell allowlist (it reads its own
    // cli-config.json), so toolsSettings only contributes skipPermissions.
    const effectivePermissionMode = permissionMode === 'acceptEdits' ? 'default' : permissionMode;
    if (skipPermissions || toolsSettings?.skipPermissions || effectivePermissionMode === 'bypassPermissions') {
      baseArgs.push('-f');
    } else if (effectivePermissionMode === 'plan') {
      baseArgs.push('--mode', 'plan');
    }

    // Use cwd (actual project directory) instead of projectPath
    const workingDir = cwd || projectPath || process.cwd();

    // Store process reference for potential abort — keyed by the app session
    // id when the caller supplied one, so abort-by-app-id always works.
    const processKey = sessionId || Date.now().toString();

    const settleOnce = (callback: any) => {
      if (settled) {
        return;
      }
      settled = true;
      callback();
    };

    const liveSessionId = () => capturedSessionId || sessionId || null;

    // Finalizes the open live text/thinking row so the next segment starts a
    // new bubble instead of being glued onto it.
    const closeLiveRow = () => {
      if (!openLiveKind) {
        return;
      }
      openLiveKind = null;
      ws.send(createNormalizedMessage({ kind: 'stream_end', sessionId: liveSessionId(), provider: 'cursor' }));
    };
    const openLiveRow = (kind: 'text' | 'thinking') => {
      if (openLiveKind !== kind) {
        closeLiveRow();
      }
      openLiveKind = kind;
    };
    const withStderrTail = (message: string) => (
      stderrTail.trim() ? `${message}\n${stderrTail.trim()}` : message
    );

    const runCursorProcess = (args: any, runReason: any = 'initial') => {
      const isTrustRetry = runReason === 'trust-retry';
      let runSawWorkspaceTrustPrompt = false;
      let stdoutLineBuffer = '';
      let terminalNotificationSent = false;
      stderrTail = '';

      const notifyTerminalState = ({ code = null, error = null }: any = {}) => {
        if (terminalNotificationSent) {
          return;
        }

        terminalNotificationSent = true;

        // Notifications are app-facing, so they carry the app session id.
        const finalSessionId = sessionId || capturedSessionId || processKey;
        if (code === 0 && !error) {
          notifyRunStopped({
            userId: ws?.userId || null,
            provider: 'cursor',
            sessionId: finalSessionId,
            sessionName: sessionSummary,
            stopReason: 'completed'
          });
          return;
        }

        notifyRunFailed({
          userId: ws?.userId || null,
          provider: 'cursor',
          sessionId: finalSessionId,
          sessionName: sessionSummary,
          error: error || `Cursor CLI exited with code ${code}`
        });
      };

      if (isTrustRetry) {
        console.log('Retrying Cursor CLI with --trust after workspace trust prompt');
      }

      const cursorProcess: import("node:child_process").ChildProcess & { aborted?: boolean } = spawnFunction('cursor-agent', args, {
        cwd: workingDir,
        stdio: ['pipe', 'pipe', 'pipe'],
        // options.env carries multi-account overrides (e.g. an isolated
        // config dir) picked at session creation.
        env: providerChildEnv(options.env && typeof options.env === 'object' ? options.env : {})
      });

      activeCursorProcesses.set(processKey, cursorProcess);

      const shouldSuppressForTrustRetry = (text: any) => {
        if (hasRetriedWithTrust || args.includes('--trust')) {
          return false;
        }
        if (!isWorkspaceTrustPrompt(text)) {
          return false;
        }

        runSawWorkspaceTrustPrompt = true;
        return true;
      };

      const processCursorOutputLine = (line: any) => {
        if (!line || !line.trim()) {
          return;
        }

        try {
          const response = JSON.parse(line);

          // Handle different message types
          switch (response.type) {
            case 'system':
              if (response.subtype === 'init') {
                // Capture session ID
                if (response.session_id && !capturedSessionId) {
                  capturedSessionId = response.session_id;

                  // Legacy/direct callers without an app session id re-key the
                  // process under the provider-native id once it is known.
                  if (!sessionId && processKey !== capturedSessionId) {
                    if (activeCursorProcesses.get(processKey) === cursorProcess) {
          activeCursorProcesses.delete(processKey);
        }
                    activeCursorProcesses.set(capturedSessionId, cursorProcess);
                  }

                  // Set session ID on writer (for API endpoint compatibility)
                  if (ws.setSessionId && typeof ws.setSessionId === 'function') {
                    ws.setSessionId(capturedSessionId);
                  }

                  // Send session-created event only once for sessions with nothing to resume
                  if (!providerSessionId && !sessionCreatedSent) {
                    sessionCreatedSent = true;
                    ws.send(createNormalizedMessage({ kind: 'session_created', newSessionId: capturedSessionId, model: response.model, cwd: response.cwd, sessionId: capturedSessionId, provider: 'cursor' }));
                  }
                }

                // System info — no longer needed by the frontend (session-lifecycle 'created' handles nav).
              }
              break;

            case 'user':
              // User messages are not displayed in the UI — skip.
              break;

            case 'assistant':
              // Accumulate assistant message chunks
              if (response.message && response.message.content && response.message.content.length > 0) {
                const normalized = context.normalizeMessage(response, liveSessionId());
                if (normalized.length > 0) {
                  openLiveRow('text');
                }
                for (const msg of normalized) ws.send(msg);
              }
              break;

            case 'thinking': {
              // stream-json thinking: `delta` frames carry `text`, `completed`
              // ends the block (history stores it as a `reasoning` part).
              const thinkingText = typeof response.text === 'string' ? response.text : '';
              if (response.subtype === 'delta' && thinkingText) {
                openLiveRow('thinking');
                ws.send(createNormalizedMessage({ kind: 'thought_delta', content: thinkingText, sessionId: liveSessionId(), provider: 'cursor' }));
              } else if (response.subtype === 'completed' && openLiveKind === 'thinking') {
                closeLiveRow();
              }
              break;
            }

            case 'tool_call': {
              // Tool calls stream as their own events; without this case they
              // only appeared after a history reload.
              closeLiveRow();
              for (const msg of buildCursorToolCallMessages(response, liveSessionId())) {
                ws.send(msg);
              }
              break;
            }

            case 'result': {
              // Session complete — terminal lifecycle event for this run
              closeLiveRow();
              resultSucceeded = response.subtype === 'success' && !response.is_error;
              if (!completeSent) {
                completeSent = true;
                if (!resultSucceeded) {
                  const reason = [response.result, response.error?.message ?? response.error, response.message]
                    .find((value) => typeof value === 'string' && value.trim());
                  ws.send(createNormalizedMessage({
                    kind: 'error',
                    content: withStderrTail(reason || `cursor-agent run failed (${response.subtype || 'error'})`),
                    sessionId: liveSessionId(),
                    provider: 'cursor',
                  }));
                }
                ws.send(createCompleteMessage({
                  provider: 'cursor',
                  sessionId: liveSessionId(),
                  exitCode: resultSucceeded ? 0 : 1,
                }));
              }
              // The run is over; stop a process that lingers after its result.
              const lingerTimer = setTimeout(() => terminateCursorProcess(cursorProcess), CURSOR_RESULT_EXIT_GRACE_MS);
              lingerTimer.unref?.();
              break;
            }

            default:
              // Unknown message types — ignore.
          }
        } catch (parseError: any) {
          if (shouldSuppressForTrustRetry(line)) {
            return;
          }

          // If not JSON, send as stream delta via adapter
          const normalized = context.normalizeMessage(line, liveSessionId());
          if (normalized.length > 0) {
            openLiveRow('text');
          }
          for (const msg of normalized) ws.send(msg);
        }
      };

      // Handle stdout (streaming JSON responses)
      cursorProcess.stdout!.on('data', (data: any) => {
        const rawOutput = data.toString();

        // Stream chunks can split JSON objects across packets; keep trailing partial line.
        stdoutLineBuffer += rawOutput;
        const completeLines = stdoutLineBuffer.split(/\r?\n/);
        stdoutLineBuffer = completeLines.pop() || '';

        completeLines.forEach((line: any) => {
          processCursorOutputLine(line.trim());
        });
      });

      // Handle stderr: buffered, surfaced only if the run fails (cursor-agent
      // also writes warnings and progress there).
      cursorProcess.stderr!.on('data', (data: any) => {
        const stderrText = data.toString();

        if (shouldSuppressForTrustRetry(stderrText)) {
          return;
        }

        stderrTail = (stderrTail + stderrText).slice(-CURSOR_STDERR_TAIL_CHARS);
      });

      // Handle process completion
      cursorProcess.on('close', async (code: any) => {
        // The process map is keyed by the app session id when one was given,
        // otherwise by the captured provider id (or the timestamp fallback).
        const finalSessionId = sessionId || capturedSessionId || processKey;
        if (activeCursorProcesses.get(finalSessionId) === cursorProcess) {
          activeCursorProcesses.delete(finalSessionId);
        }

        // Flush any final unterminated stdout line before completion handling.
        if (stdoutLineBuffer.trim()) {
          processCursorOutputLine(stdoutLineBuffer.trim());
          stdoutLineBuffer = '';
        }

        if (
          !cursorProcess.aborted &&
          runSawWorkspaceTrustPrompt &&
          code !== 0 &&
          !hasRetriedWithTrust &&
          !args.includes('--trust')
        ) {
          hasRetriedWithTrust = true;
          runCursorProcess([...args, '--trust'], 'trust-retry');
          return;
        }

        closeLiveRow();

        // A process stopped after a successful `result` (see lingerTimer) is
        // still a successful run.
        const succeeded = resultSucceeded ?? code === 0;

        // Terminal complete — unless the `result` line already sent it, or the
        // run was aborted (abort-session sent the aborted complete). A failure
        // is reported as `error` first; `complete` closes the run.
        if (!completeSent && !cursorProcess.aborted) {
          completeSent = true;
          if (!succeeded) {
            ws.send(createNormalizedMessage({
              kind: 'error',
              content: withStderrTail(`cursor-agent exited with code ${code}`),
              sessionId: liveSessionId(),
              provider: 'cursor',
            }));
          }
          ws.send(createCompleteMessage({ provider: 'cursor', sessionId: finalSessionId, exitCode: succeeded ? 0 : (code || 1) }));
        }

        if (succeeded && stderrTail.trim()) {
          console.warn('Cursor CLI stderr:', stderrTail.trim());
        }

        // An aborted run already reported its terminal complete; settle the
        // run quietly so the dispatcher does not emit a spurious RUNTIME_ERROR
        // (and no failure notification) for an intentional stop.
        if (cursorProcess.aborted) {
          settleOnce(() => resolve());
          return;
        }

        if (succeeded) {
          notifyTerminalState({ code: 0 });
          settleOnce(() => resolve());
        } else {
          console.error('Cursor CLI failed:', withStderrTail(`exit code ${code}`));
          notifyTerminalState({ code: code ?? 1 });
          settleOnce(() => reject(new Error(`Cursor CLI exited with code ${code}`)));
        }
      });

      // Handle process errors
      cursorProcess.on('error', async (error: any) => {
        if (cursorProcess.aborted) {
          settleOnce(() => resolve());
          return;
        }
        console.error('Cursor CLI process error:', error);

        // Clean up process reference on error
        const finalSessionId = sessionId || capturedSessionId || processKey;
        if (activeCursorProcesses.get(finalSessionId) === cursorProcess) {
          activeCursorProcesses.delete(finalSessionId);
        }

        // Check if Cursor CLI is installed for a clearer error message
        const installed = await context.isProviderInstalled();
        const errorContent = !installed
          ? 'Cursor CLI is not installed. Please install it from https://cursor.com'
          : error.message;

        ws.send(createNormalizedMessage({ kind: 'error', content: errorContent, sessionId: capturedSessionId || sessionId || null, provider: 'cursor' }));
        if (!completeSent && !cursorProcess.aborted) {
          completeSent = true;
          ws.send(createCompleteMessage({ provider: 'cursor', sessionId: capturedSessionId || sessionId || null, exitCode: 1 }));
        }
        notifyTerminalState({ error });

        settleOnce(() => reject(error));
      });

      // Close stdin since Cursor doesn't need interactive input
      cursorProcess.stdin!.end();
    };

    runCursorProcess(baseArgs, 'initial');
    }
    main().catch(reject);
  });
}

// Consumed by provider runtime services and lifecycle tests.
export function abortCursorSession(sessionId: any) {
  const process = activeCursorProcesses.get(sessionId);
  if (process) {
    console.log(`Aborting Cursor session: ${sessionId}`);
    // The abort handler sends the terminal complete (aborted: true); flag the
    // process so its close handler does not emit a second one.
    process.aborted = true;
    try {
      if (!terminateCursorProcess(process)) {
        process.aborted = false;
        return false;
      }
    } catch (error) {
      process.aborted = false;
      console.warn('Failed to cancel CLI process:', error);
      return false;
    }
    if (activeCursorProcesses.get(sessionId) === process) {
      activeCursorProcesses.delete(sessionId);
    }
    return true;
  }
  return false;
}

// Consumed by provider runtime services and lifecycle tests.
export function isCursorSessionActive(sessionId: any) {
  return activeCursorProcesses.has(sessionId);
}

// Consumed by provider runtime services and lifecycle tests.
export function getActiveCursorSessions() {
  return Array.from(activeCursorProcesses.keys());
}

// Consumed by the provider registry for run, Stop and permission controls.
export const cursorRuntime: IProviderRuntime = {
  run: spawnCursor,
  abort: abortCursorSession,
};
