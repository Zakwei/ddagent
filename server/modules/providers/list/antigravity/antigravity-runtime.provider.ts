import fs from 'node:fs';
import path from 'node:path';

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
  antigravityTranscriptDir,
  createCompleteMessage,
  createNormalizedMessage,
  generateMessageId,
  providerChildEnv,
  readOptionalString,
  resolveAntigravityExecutable,
} from '@/shared/index.js';
import { sessionsDb } from '@/modules/database/index.js';
import { notifyRunFailed, notifyRunStopped } from '@/modules/notifications/index.js';

// cross-spawn resolves .cmd shims/PATHEXT on Windows and delegates to
// child_process.spawn everywhere else.
const spawnFunction = crossSpawn;

const activeProcesses = new Map<any, any>(); // Track active agy processes by session ID

/**
 * Antigravity (`agy`) runs headless per turn: `agy --print "<prompt>"
 * --output-format stream-json` emits NDJSON `init` / `step_update` / `result`
 * events and persists the conversation in its own protobuf SQLite store.
 * Because that store is not text-readable, the runtime mirrors each turn into
 * `<workspace>/.ddagent/antigravity/<conversation-id>.jsonl` using the same
 * transcript shape Command Code's reader understands (a `type:"session"`
 * header plus `type:"message"` rows), so sessions/token-usage/changed-files
 * services can share the existing JSONL pipeline.
 *
 * Resume runs through `--conversation <id>` on the next spawn — there is no
 * persistent process or ACP channel, so permission-mode changes take effect
 * on the following turn rather than mid-run.
 *
 * Permission mapping (verified against agy 1.2.14):
 *   default           → (no flags; print mode soft-denies permission prompts)
 *   acceptEdits       → --mode accept-edits
 *   plan              → --mode plan
 *   bypassPermissions → --dangerously-skip-permissions
 * Effort maps to `--effort low|medium|high|max`; `default` omits the flag.
 */

const VALID_EFFORTS = new Set(['low', 'medium', 'high', 'max']);

function appendTranscript(jsonlPath: any, record: any) {
  if (!jsonlPath) return;
  try {
    fs.mkdirSync(path.dirname(jsonlPath), { recursive: true });
    fs.appendFileSync(jsonlPath, JSON.stringify(record) + '\n');
  } catch (error: any) {
    console.error('[Antigravity] Failed to append transcript:', error instanceof Error ? error.message : String(error));
  }
}

/** Normalizes the agy `usage` object (snake_case) into the transcript shape. */
function normalizeUsage(usage: any) {
  if (!usage || typeof usage !== 'object') {
    return null;
  }
  const num = (v: any) => (typeof v === 'number' && Number.isFinite(v) ? v : 0);
  const inputTokens = num(usage.input_tokens ?? usage.inputTokens);
  const outputTokens = num(usage.output_tokens ?? usage.outputTokens);
  const cacheReadTokens = num(usage.cache_read_tokens ?? usage.cacheReadTokens);
  const cacheWriteTokens = num(usage.cache_write_tokens ?? usage.cacheWriteTokens);
  const thinkingTokens = num(usage.thinking_tokens ?? usage.thinkingTokens);
  const totalTokens = num(usage.total_tokens ?? usage.totalTokens)
    || inputTokens + outputTokens + cacheReadTokens + cacheWriteTokens;
  if (!inputTokens && !outputTokens && !cacheReadTokens && !totalTokens) {
    return null;
  }
  return { inputTokens, outputTokens, cacheReadTokens, cacheWriteTokens, thinkingTokens, totalTokens };
}

/**
 * Maps one `agy` tool name to the file-path parameter key the CLI uses. agy
 * tool params are PascalCase (`TargetFile`); the mirror stores them verbatim.
 */
const AGY_EDIT_TOOL_PATH_KEYS: any = {
  write_to_file: ['TargetFile', 'file_path', 'filePath', 'path'],
  replace_file_content: ['TargetFile', 'file_path', 'filePath', 'path'],
  multi_replace_file_content: ['TargetFile', 'file_path', 'filePath', 'path'],
  sed_file: ['TargetFile', 'file_path', 'filePath', 'path'],
  notebook_edit: ['TargetFile', 'notebook_path', 'file_path', 'filePath', 'path'],
};

function toolFilePath(toolName: any, parameters: any) {
  const keys = AGY_EDIT_TOOL_PATH_KEYS[toolName] || ['TargetFile', 'file_path', 'filePath', 'path'];
  for (const key of keys) {
    const value = parameters && typeof parameters[key] === 'string' ? parameters[key] : null;
    if (value) {
      return value;
    }
  }
  return null;
}

// Consumed by provider runtime services and lifecycle tests.
export async function spawnAntigravity(command: string, options: AnyRecord = {}, ws: ProviderRuntimeWriter, context: AnyRecord) {
  return new Promise((resolve: any, reject: any) => {
    // An async promise executor drops rejections on the floor (unhandled
    // rejection → process crash), so the body runs inside `main` and forwards
    // its outcome to reject() — the same pattern the cursor runtime uses.
    async function main() {
    const {
      sessionId,
      projectPath,
      cwd,
      toolsSettings,
      skipPermissions,
      permissionMode,
      effort,
      model,
      sessionSummary,
      images,
      files
    } = options;
    // Callers pass the stable app session id; the CLI resumes with the
    // provider-native conversation id recorded on the session row.
    const providerSessionId = context.resolveProviderSessionId(sessionId);
    const resolvedModel = await context.resolveResumeModel(sessionId, model);
    let capturedSessionId = providerSessionId; // provider-native conversation id
    let sessionCreatedSent = false;
    let settled = false;
    // The unified lifecycle contract requires exactly one terminal `complete`
    // per run. Antigravity surfaces completion twice (the `result` event and
    // the process close), so the first emission wins.
    let completeSent = false;

    const settings = toolsSettings || {
      allowedShellCommands: [],
      skipPermissions: false
    };

    const hasAttachments =
      normalizeAttachmentDescriptors(images).length > 0
      || normalizeAttachmentDescriptors(files).length > 0;
    if (!((command && command.trim()) || hasAttachments)) {
      throw new Error('Antigravity print mode requires a prompt.');
    }

    // The prompt must directly follow --print: agy's parser consumes the next
    // token as the prompt, so putting a flag there misparses it.
    const promptWithAttachments = appendFilesInputTag(
      appendImagesInputTag(command || '', images),
      files
    );
    const baseArgs: any = ['--print', promptWithAttachments, '--output-format', 'stream-json'];

    // Resume an existing conversation when the session row already carries
    // the provider-native id. agy is a Go binary, so prompts keep newlines.
    if (providerSessionId) {
      baseArgs.push('--conversation', providerSessionId);
    }

    if (resolvedModel) {
      baseArgs.push('--model', resolvedModel);
    }

    // `default` omits --effort; everything else must be a real tier.
    if (effort && effort !== 'default' && VALID_EFFORTS.has(effort)) {
      baseArgs.push('--effort', effort);
    }

    // Map DDAgent permission modes onto agy flags. `--mode` accepts
    // accept-edits|plan; bypass needs the dedicated flag; default print mode
    // soft-denies permission prompts (there is no interactive reviewer).
    const bypass = skipPermissions || settings.skipPermissions || permissionMode === 'bypassPermissions';
    if (bypass) {
      baseArgs.push('--dangerously-skip-permissions');
    } else if (permissionMode === 'acceptEdits') {
      baseArgs.push('--mode', 'accept-edits');
    } else if (permissionMode === 'plan') {
      baseArgs.push('--mode', 'plan');
    }

    // Use cwd (actual project directory) instead of projectPath
    const workingDir = cwd || projectPath || process.cwd();

    const executable = resolveAntigravityExecutable() || 'agy';

    // Mirror transcript — named after the provider conversation id once the
    // `init` event reports it, keyed under the app session id meanwhile.
    let jsonlPath = path.join(
      antigravityTranscriptDir(workingDir),
      `${capturedSessionId || sessionId || 'pending'}.jsonl`,
    );
    let transcriptFinalized = false;

    const finalizeTranscriptPath = () => {
      if (transcriptFinalized || !capturedSessionId) {
        return;
      }
      transcriptFinalized = true;
      const next = path.join(antigravityTranscriptDir(workingDir), `${capturedSessionId}.jsonl`);
      if (next !== jsonlPath) {
        try {
          if (fs.existsSync(jsonlPath)) {
            fs.renameSync(jsonlPath, next);
          }
        } catch (error: any) {
          console.warn('[Antigravity] Could not move pending transcript:', error instanceof Error ? error.message : error);
        }
        jsonlPath = next;
      }
    };

    const processKey = sessionId || Date.now().toString();

    const settleOnce = (callback: any) => {
      if (settled) {
        return;
      }
      settled = true;
      callback();
    };

    let terminalNotificationSent = false;
    const notifyTerminalState = ({ code = null, error = null }: any = {}) => {
      if (terminalNotificationSent) {
        return;
      }
      terminalNotificationSent = true;
      const finalSessionId = sessionId || capturedSessionId || processKey;
      if (code === 0 && !error) {
        notifyRunStopped({
          userId: ws?.userId || null,
          provider: 'antigravity',
          sessionId: finalSessionId,
          sessionName: sessionSummary,
          stopReason: 'completed'
        });
        return;
      }
      notifyRunFailed({
        userId: ws?.userId || null,
        provider: 'antigravity',
        sessionId: finalSessionId,
        sessionName: sessionSummary,
        error: error || `Antigravity CLI exited with code ${code}`
      });
    };

    // The user turn is written once, up-front — agy echoes it back as a
    // user_input step that the renderer ignores.
    const userEntry: any = {
      type: 'message',
      id: generateMessageId('antigravity'),
      timestamp: new Date().toISOString(),
      message: { role: 'user', content: [{ type: 'text', text: promptWithAttachments }] },
    };
    appendTranscript(jsonlPath, userEntry);
    const userEcho = createNormalizedMessage({
      kind: 'text',
      role: 'user',
      content: command || '',
      sessionId: capturedSessionId || sessionId || null,
      provider: 'antigravity',
    });
    ws.send(userEcho);

    let stdoutLineBuffer = '';
    // Per assistant-response accumulator: `agent_response` steps stream
    // text_delta chunks on ACTIVE rows and the final chunk on DONE.
    const openAssistantSteps = new Map<any, any>(); // step_index → accumulated text
    const openToolSteps = new Map<any, any>(); // step_index → { id, name, input }

    const appendAssistantMessage = (stepIndex: any, usage: any) => {
      const text = openAssistantSteps.get(stepIndex);
      if (text == null) {
        return;
      }
      openAssistantSteps.delete(stepIndex);
      const entry: any = {
        type: 'message',
        id: generateMessageId('antigravity'),
        timestamp: new Date().toISOString(),
        ...(resolvedModel ? { model: resolvedModel } : {}),
        ...(usage ? { usage } : {}),
        message: { role: 'assistant', content: [{ type: 'text', text }] },
      };
      appendTranscript(jsonlPath, entry);
    };

    const emitComplete = (exitCode: any) => {
      if (completeSent) {
        return;
      }
      completeSent = true;
      ws.send(createCompleteMessage({
        provider: 'antigravity',
        sessionId: capturedSessionId || sessionId || null,
        exitCode,
      }));
    };

    const processOutputLine = (line: any) => {
      if (!line || !line.trim()) {
        return;
      }

      let event;
      try {
        event = JSON.parse(line);
      } catch {
        // Non-JSON noise on stdout — surface it as an error row rather than
        // guessing at structure.
        ws.send(createNormalizedMessage({
          kind: 'error',
          content: line,
          sessionId: capturedSessionId || sessionId || null,
          provider: 'antigravity',
        }));
        return;
      }

      const type = event.event;

      if (type === 'init') {
        const conversationId = event.conversation_id;
        if (conversationId) {
          capturedSessionId = conversationId;
          finalizeTranscriptPath();

          if (!sessionId && processKey !== capturedSessionId) {
            if (activeProcesses.get(processKey) === agyProcess) {
          activeProcesses.delete(processKey);
        }
            activeProcesses.set(capturedSessionId, agyProcess);
          }

          // Register/bind the provider session row + mirror transcript path
          // (same contract the devin runtime uses).
          sessionsDb.createSession(
            capturedSessionId,
            'antigravity',
            workingDir,
            undefined,
            undefined,
            undefined,
            jsonlPath,
          );
          if (sessionId && sessionId !== capturedSessionId) {
            sessionsDb.assignProviderSessionId(sessionId, capturedSessionId);
          }

          if (ws.setSessionId && typeof ws.setSessionId === 'function') {
            ws.setSessionId(capturedSessionId);
          }

          if (!providerSessionId && !sessionCreatedSent) {
            sessionCreatedSent = true;
            ws.send(createNormalizedMessage({
              kind: 'session_created',
              newSessionId: capturedSessionId,
              cwd: event.init?.cwd,
              sessionId: capturedSessionId,
              provider: 'antigravity',
            }));
          }
        }
        return;
      }

      if (type === 'step_update') {
        const update = event.step_update || {};
        const stepType = update.step_type;
        const stepIndex = update.step_index;
        const ts = new Date().toISOString();

        if (stepType === 'agent_response') {
          const delta = typeof update.text_delta === 'string' ? update.text_delta : '';
          if (update.state === 'ACTIVE' && delta) {
            openAssistantSteps.set(stepIndex, (openAssistantSteps.get(stepIndex) || '') + delta);
            ws.send(createNormalizedMessage({
              kind: 'stream_delta',
              content: delta,
              sessionId: capturedSessionId || sessionId || null,
              provider: 'antigravity',
            }));
          } else if (update.state === 'DONE') {
            if (delta) {
              openAssistantSteps.set(stepIndex, (openAssistantSteps.get(stepIndex) || '') + delta);
            }
            const text = openAssistantSteps.get(stepIndex);
            if (typeof text === 'string' && text.length) {
              ws.send(createNormalizedMessage({
                kind: 'text',
                role: 'assistant',
                content: text,
                sessionId: capturedSessionId || sessionId || null,
                provider: 'antigravity',
              }));
            }
            const usage = normalizeUsage(update.usage);
            if (usage) {
              const budget: any = { inputTokens: usage.inputTokens, outputTokens: usage.outputTokens, cacheReadTokens: usage.cacheReadTokens, used: usage.totalTokens, total: 0 };
              const budgetMessage = createNormalizedMessage({
                kind: 'status',
                text: 'token_budget',
                tokenBudget: budget,
                sessionId: capturedSessionId || sessionId || null,
                provider: 'antigravity',
                timestamp: ts,
              });
              ws.send(budgetMessage);
              appendTranscript(jsonlPath, budgetMessage);
            }
            appendAssistantMessage(stepIndex, normalizeUsage(update.usage));
          }
          return;
        }

        if (stepType === 'tool') {
          const toolName = update.tool_name || 'tool';
          const parameters = update.tool_info?.parameters || {};
          if (update.state === 'ACTIVE') {
            const toolId = `agy-tool-${stepIndex}`;
            openToolSteps.set(stepIndex, { id: toolId, name: toolName, input: parameters });
            ws.send(createNormalizedMessage({
              kind: 'tool_use',
              toolName,
              toolInput: parameters,
              toolId,
              sessionId: capturedSessionId || sessionId || null,
              provider: 'antigravity',
            }));
            // Mirror transcript records tool_use inside an assistant message.
            appendTranscript(jsonlPath, {
              type: 'message',
              id: generateMessageId('antigravity'),
              timestamp: ts,
              message: { role: 'assistant', content: [{ type: 'tool_use', id: toolId, name: toolName, input: parameters }] },
            });
            const changedPath = toolFilePath(toolName, parameters);
            if (changedPath) {
              ws.send(createNormalizedMessage({
                kind: 'status',
                text: `Editing ${changedPath}`,
                sessionId: capturedSessionId || sessionId || null,
                provider: 'antigravity',
              }));
            }
          } else if (update.state === 'DONE') {
            const open = openToolSteps.get(stepIndex);
            openToolSteps.delete(stepIndex);
            const toolId = open?.id || `agy-tool-${stepIndex}`;
            const resultContent = update.tool_info?.result != null
              ? (typeof update.tool_info.result === 'string' ? update.tool_info.result : JSON.stringify(update.tool_info.result))
              : '';
            ws.send(createNormalizedMessage({
              kind: 'tool_result',
              toolId,
              content: resultContent,
              sessionId: capturedSessionId || sessionId || null,
              provider: 'antigravity',
            }));
            appendTranscript(jsonlPath, {
              type: 'message',
              id: generateMessageId('antigravity'),
              timestamp: ts,
              message: { role: 'user', content: [{ type: 'tool_result', tool_use_id: toolId, content: resultContent }] },
            });
          }
          return;
        }

        // user_input and other control steps carry no renderable payload.
        return;
      }

      if (type === 'result') {
        const result = event.result || {};
        const status = typeof result.status === 'string' ? result.status : '';
        if (status === 'ERROR' || (status && status !== 'SUCCESS')) {
          const content = readOptionalString(result.error) || readOptionalString(result.response) || `Antigravity run ended with status ${status}`;
          ws.send(createNormalizedMessage({
            kind: 'error',
            content,
            sessionId: capturedSessionId || sessionId || null,
            provider: 'antigravity',
          }));
          emitComplete(1);
          return;
        }
        const usage = normalizeUsage(result.usage);
        if (usage) {
          appendTranscript(jsonlPath, createNormalizedMessage({
            kind: 'status',
            text: 'token_budget',
            tokenBudget: { inputTokens: usage.inputTokens, outputTokens: usage.outputTokens, cacheReadTokens: usage.cacheReadTokens, used: usage.totalTokens, total: 0 },
            sessionId: capturedSessionId || sessionId || null,
            provider: 'antigravity',
            timestamp: new Date().toISOString(),
          }));
        }
        emitComplete(0);
        return;
      }
    };

    const agyProcess: import("node:child_process").ChildProcess & { aborted?: boolean } = spawnFunction(executable, baseArgs, {
      cwd: workingDir,
      stdio: ['ignore', 'pipe', 'pipe'],
      // options.env carries multi-account overrides (e.g. an isolated HOME)
      // picked at session creation.
      env: providerChildEnv(options.env && typeof options.env === 'object' ? options.env : {})
    });

    activeProcesses.set(processKey, agyProcess);

    agyProcess.stdout!.on('data', (data: any) => {
      stdoutLineBuffer += data.toString();
      const completeLines = stdoutLineBuffer.split(/\r?\n/);
      stdoutLineBuffer = completeLines.pop() || '';
      for (const line of completeLines) {
        processOutputLine(line.trim());
      }
    });

    // Diagnostics (auth prompts, permission notices) go to stderr.
    agyProcess.stderr!.on('data', (data: any) => {
      const stderrText = data.toString();
      console.error('Antigravity CLI stderr:', stderrText);
      ws.send(createNormalizedMessage({
        kind: 'error',
        content: stderrText,
        sessionId: capturedSessionId || sessionId || null,
        provider: 'antigravity',
      }));
    });

    agyProcess.on('close', (code: any) => {
      const finalSessionId = sessionId || capturedSessionId || processKey;
      if (activeProcesses.get(finalSessionId) === agyProcess) {
          activeProcesses.delete(finalSessionId);
        }
      if (processKey !== finalSessionId) {
        if (activeProcesses.get(processKey) === agyProcess) {
          activeProcesses.delete(processKey);
        }
      }

      // Flush any final unterminated stdout line before completion handling.
      if (stdoutLineBuffer.trim()) {
        processOutputLine(stdoutLineBuffer.trim());
        stdoutLineBuffer = '';
      }

      if (!completeSent && !agyProcess.aborted) {
        emitComplete(code);
      }

      // An aborted run already reported its terminal complete; settle quietly
      // so the dispatcher does not emit a spurious RUNTIME_ERROR.
      if (agyProcess.aborted) {
        settleOnce(() => resolve());
        return;
      }

      if (code === 0) {
        notifyTerminalState({ code });
        settleOnce(() => resolve());
      } else {
        notifyTerminalState({ code });
        settleOnce(() => reject(new Error(`Antigravity CLI exited with code ${code}`)));
      }
    });

    agyProcess.on('error', async (error: any) => {
        if (agyProcess.aborted) {
          settleOnce(() => resolve());
          return;
        }
      console.error('Antigravity CLI process error:', error);
      const finalSessionId = sessionId || capturedSessionId || processKey;
      if (activeProcesses.get(finalSessionId) === agyProcess) {
          activeProcesses.delete(finalSessionId);
        }
      if (activeProcesses.get(processKey) === agyProcess) {
          activeProcesses.delete(processKey);
        }

      const installed = await context.isProviderInstalled();
      const errorContent = !installed
        ? 'Antigravity CLI is not installed. Install it per https://antigravity.google/docs/cli/install/'
        : error.message;

      ws.send(createNormalizedMessage({
        kind: 'error',
        content: errorContent,
        sessionId: capturedSessionId || sessionId || null,
        provider: 'antigravity',
      }));
      emitComplete(1);
      notifyTerminalState({ error });

      settleOnce(() => reject(error));
    });
    }
    main().catch(reject);
  });
}

// Consumed by provider runtime services and lifecycle tests.
export function abortAntigravitySession(sessionId: any) {
  const process = activeProcesses.get(sessionId);
  if (process) {
    console.log(`Aborting Antigravity session: ${sessionId}`);
    // The abort handler sends the terminal complete (aborted: true); flag the
    // process so its close handler does not emit a second one.
    process.aborted = true;
    try {
      if (!process.kill('SIGTERM')) {
        process.aborted = false;
        return false;
      }
    } catch (error) {
      process.aborted = false;
      console.warn('Failed to cancel CLI process:', error);
      return false;
    }
    if (activeProcesses.get(sessionId) === process) {
      activeProcesses.delete(sessionId);
    }
    return true;
  }
  return false;
}

// Consumed by provider runtime services and lifecycle tests.
export function isAntigravitySessionActive(sessionId: any) {
  return activeProcesses.has(sessionId);
}

// Consumed by provider runtime services and lifecycle tests.
export function getActiveAntigravitySessions() {
  return Array.from(activeProcesses.keys());
}

// Consumed by the provider registry for run, Stop and permission controls.
export const antigravityRuntime: IProviderRuntime = {
  run: spawnAntigravity,
  abort: abortAntigravitySession,
};
