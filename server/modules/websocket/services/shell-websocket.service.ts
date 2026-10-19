import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import pty, { type IPty } from 'node-pty';
import { WebSocket, type RawData } from 'ws';

import {
  ENV_KEY_PATTERN,
  parseIncomingJsonObject,
  powerShellArgs,
  providerChildEnv,
  readStringRecord,
} from '@/shared/utils.js';

type ShellIncomingMessage = {
  type?: string;
  data?: string;
  cols?: number;
  rows?: number;
  projectPath?: string;
  sessionId?: string;
  hasSession?: boolean;
  provider?: string;
  initialCommand?: string;
  isPlainShell?: boolean;
  forceRestart?: boolean;
  /** Extra env vars for the PTY (e.g. a provider account's config dir). */
  env?: Record<string, string>;
};

type TerminalSize = { cols: number; rows: number };

type PtySessionEntry = {
  pty: IPty;
  /**
   * Every socket showing this PTY — the same terminal tab open on several
   * devices (tabs are synced across the user's devices). Output fans out to
   * all of them; the kill timer starts only once the last one detaches.
   */
  sockets: Set<WebSocket>;
  /**
   * The viewer in charge: the last one to attach or type. Its emulator alone
   * answers terminal queries (the others get live output flagged `replay`, so
   * a device-attributes probe is not answered twice into the shell) and its
   * size is the PTY's size.
   */
  owner: WebSocket | null;
  /** Last size each viewer reported (init or resize). */
  sizes: Map<WebSocket, TerminalSize>;
  size: TerminalSize;
  buffer: string[];
  timeoutId: NodeJS.Timeout | null;
  projectPath: string;
  sessionId: string | null;
};

const ptySessionsMap = new Map<string, PtySessionEntry>();

function sendIfOpen(socket: WebSocket, frame: Record<string, unknown>): void {
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify(frame));
  }
}

/** Live PTY output: verbatim to the owner, flagged `replay` to the other viewers. */
function broadcastOutput(session: PtySessionEntry, data: string): void {
  for (const socket of session.sockets) {
    sendIfOpen(
      socket,
      socket === session.owner ? { type: 'output', data } : { type: 'output', data, replay: true }
    );
  }
}

function broadcastFrame(session: PtySessionEntry, frame: Record<string, unknown>): void {
  for (const socket of session.sockets) {
    sendIfOpen(socket, frame);
  }
}

/** Resizes the PTY to `socket`'s last reported size when it differs. */
function applyViewerSize(session: PtySessionEntry, socket: WebSocket): void {
  const size = session.sizes.get(socket);
  if (!size || (size.cols === session.size.cols && size.rows === session.size.rows)) {
    return;
  }
  session.pty.resize(size.cols, size.rows);
  session.size = size;
}

/**
 * Removes one viewer from a PTY. The next most recent viewer takes over;
 * with none left the PTY lingers for PTY_SESSION_TIMEOUT so a reconnect
 * can reattach.
 */
function detachViewer(sessionKey: string, socket: WebSocket): void {
  const session = ptySessionsMap.get(sessionKey);
  // Mobile networks can deliver an old socket's close after its replacement
  // has attached — only a socket still in the viewer set may detach.
  if (!session || !session.sockets.delete(socket)) {
    return;
  }
  session.sizes.delete(socket);
  if (session.owner === socket) {
    session.owner = [...session.sockets].at(-1) ?? null;
    if (session.owner) {
      applyViewerSize(session, session.owner);
    }
  }
  if (session.sockets.size > 0) {
    return;
  }

  if (session.timeoutId) {
    clearTimeout(session.timeoutId);
  }
  session.timeoutId = setTimeout(() => {
    // A reconnect may win just as this timer becomes runnable. Re-check the
    // viewers so a queued cleanup can never kill a reattached PTY.
    if (ptySessionsMap.get(sessionKey) !== session || session.sockets.size > 0) {
      return;
    }

    session.pty.kill();
    ptySessionsMap.delete(sessionKey);
  }, PTY_SESSION_TIMEOUT);
}
/** Flags every terminal-started Claude CLI gets; the account profiles in the client type the same ones. */
const CLAUDE_TERMINAL_FLAGS = '--allow-dangerously-skip-permissions';
const PTY_SESSION_TIMEOUT = 30 * 60 * 1000;
const SHELL_URL_PARSE_BUFFER_LIMIT = 32768;
// OSC (`ESC]…BEL/ST`, e.g. `\x1b]8;;\x07` hyperlinks) must come before the
// generic Fe alternative — `]` alone would match it and leave `8;;`-style
// remnants glued onto detected URLs. The `$` terminator strips an OSC that
// is still incomplete at the buffer end, like a real terminal does.
const ANSI_ESCAPE_SEQUENCE_REGEX = /\x1B(?:\][^\x07]*(?:\x07|\x1B\\|$)|\[[0-?]*[ -/]*[@-~]|[@-Z\\-_])/g;
const TRAILING_URL_PUNCTUATION_REGEX = /[)\]}>.,;:!?]+$/;
// Terminal hyperlinks (`ESC]8;params;URI ST`) carry the target URL verbatim —
// the most reliable source, immune to display wrapping.
const OSC8_HYPERLINK_URL_REGEX = /\x1B\]8;[^\x07\x1B]*;(https?:\/\/[^\x07\x1B]+?)(?:\x07|\x1B\\)/g;

function stripAnsiSequences(value: string): string {
  return value.replace(ANSI_ESCAPE_SEQUENCE_REGEX, '');
}

function normalizeDetectedUrl(url: string): string | null {
  const cleanedUrl = url.trim().replace(TRAILING_URL_PUNCTUATION_REGEX, '');
  if (!cleanedUrl) {
    return null;
  }

  try {
    const parsedUrl = new URL(cleanedUrl);
    if (parsedUrl.protocol !== 'http:' && parsedUrl.protocol !== 'https:') {
      return null;
    }
    return parsedUrl.toString();
  } catch {
    return null;
  }
}

function extractUrlsFromText(value: string): string[] {
  const directMatches = value.match(/https?:\/\/[^\s<>"'`\\\x1b\x07]+/gi) ?? [];

  // Terminal width can split a URL across lines, so valid URL characters on
  // immediately following lines are joined before the URL is validated.
  const wrappedMatches: string[] = [];
  const urlContinuationPattern = /^[A-Za-z0-9\-._~:/?#\[\]@!$&'()*+,;=%]+$/;
  const lines = value.split(/\r?\n/);
  for (let lineIndex = 0; lineIndex < lines.length; lineIndex += 1) {
    const line = lines[lineIndex].trim();
    const startMatch = line.match(/https?:\/\/[^\s<>"'`\\\x1b\x07]+/i);
    if (!startMatch) {
      continue;
    }

    let combinedUrl = startMatch[0];
    let continuationIndex = lineIndex + 1;
    while (continuationIndex < lines.length) {
      const continuation = lines[continuationIndex].trim();
      // A line that itself starts a new absolute URL is a separate link, not
      // a wrap fragment — joining it duplicates query params (e.g. `scope`).
      if (!continuation || /https?:\/\//i.test(continuation) || !urlContinuationPattern.test(continuation)) {
        break;
      }
      combinedUrl += continuation;
      continuationIndex += 1;
    }

    wrappedMatches.push(combinedUrl);
  }

  return Array.from(new Set([...directMatches, ...wrappedMatches]));
}

// URL shapes produced by CLI sign-in flows (OAuth authorize pages, device-code
// pages, provider login portals). Anything else printed by a CLI — docs links
// in notices, release pages, hyperlinks in command output — is not a login
// link and must not light up the client's "auth link" banner.
const AUTH_URL_HINT_REGEX =
  /oauth|authori[sz]|\/auth\b|auth\.|login|log-in|signin|sign-in|sign_in|sso|device|verif|activate|account|session|token|callback|cli\b/i;
const AUTH_URL_QUERY_HINT_REGEX = /(?:^|[?&])(?:code|client_id|state|redirect_uri|user_code|token|nonce|challenge)=/i;
// Prose a CLI prints around a login link ("Open this URL in your browser to
// sign in"). Looked up in the text just before the URL so a bare short link
// still counts when the surrounding sentence is unmistakably a login prompt.
const AUTH_CONTEXT_HINT_REGEX =
  /log\s?in|sign\s?in|authenticat|authoriz|authorise|verification code|device code|enter (?:the|this) code|open (?:this|the) (?:url|link)|in your browser|visit/i;
const AUTH_CONTEXT_WINDOW = 400;

// Decides whether a URL seen in PTY output is a sign-in link worth surfacing
// to the client. Either the URL itself looks like an auth endpoint or the
// text immediately preceding it reads like a login instruction.
function isLikelyAuthUrl(normalizedUrl: string, cleanOutput: string): boolean {
  let parsedUrl: URL;
  try {
    parsedUrl = new URL(normalizedUrl);
  } catch {
    return false;
  }
  const locator = `${parsedUrl.hostname}${parsedUrl.pathname}`;
  if (AUTH_URL_HINT_REGEX.test(locator) || AUTH_URL_QUERY_HINT_REGEX.test(parsedUrl.search)) {
    return true;
  }
  // The buffer holds the display text, which may wrap the URL; search for
  // its origin so a wrapped URL still anchors the context window.
  const anchor = cleanOutput.lastIndexOf(parsedUrl.origin);
  if (anchor === -1) {
    return false;
  }
  const context = cleanOutput.slice(Math.max(0, anchor - AUTH_CONTEXT_WINDOW), anchor);
  return AUTH_CONTEXT_HINT_REGEX.test(context);
}

/**
 * A loopback address is never a sign-in link to offer: it is a dev server's
 * own route (`localhost:5000/api/auth/login`), and on the device viewing the
 * terminal it would point at that device, not at this server.
 */
function isLoopbackUrl(normalizedUrl: string): boolean {
  let hostname: string;
  try {
    hostname = new URL(normalizedUrl).hostname.toLowerCase();
  } catch {
    return false;
  }
  return (
    hostname === 'localhost' ||
    hostname.endsWith('.localhost') ||
    hostname === '[::1]' ||
    hostname === '0.0.0.0' ||
    /^127(?:\.\d{1,3}){3}$/.test(hostname)
  );
}

function shouldAutoOpenUrlFromOutput(value: string): boolean {
  const normalizedOutput = value.toLowerCase();
  return (
    normalizedOutput.includes("browser didn't open") ||
    normalizedOutput.includes('open this url') ||
    normalizedOutput.includes('continue in your browser') ||
    normalizedOutput.includes('press enter to open') ||
    normalizedOutput.includes('open_url:')
  );
}

type ShellWebSocketDependencies = {
  resolveProviderSessionId: (
    sessionId: string,
    provider: string,
  ) => string | null | undefined;
  spawnPty?: typeof pty.spawn;
};

/**
 * Reads a string field from untyped payloads and falls back when absent.
 */
function readString(value: unknown, fallback = ''): string {
  return typeof value === 'string' ? value : fallback;
}

/** Whether `target` exists and is a directory. */
function isDirectory(target: string): boolean {
  try {
    return fs.statSync(target).isDirectory();
  } catch {
    return false;
  }
}

/**
 * Reads a boolean field from untyped payloads and falls back when absent.
 */
function readBoolean(value: unknown, fallback = false): boolean {
  return typeof value === 'boolean' ? value : fallback;
}

/**
 * Reads a finite number field from untyped payloads and falls back when absent.
 */
function readNumber(value: unknown, fallback: number): number {
  return typeof value === 'number' && Number.isFinite(value) ? value : fallback;
}

/**
 * Parses incoming websocket shell messages and keeps processing safe when
 * malformed payloads are received.
 */
function parseShellMessage(rawMessage: RawData): ShellIncomingMessage | null {
  const payload = parseIncomingJsonObject(rawMessage);
  if (!payload) {
    return null;
  }

  return payload as ShellIncomingMessage;
}

const SAFE_SESSION_ID_PATTERN = /^[a-zA-Z0-9_.\-:]+$/;

/**
 * Reads whether an init payload asks for a plain terminal rather than an agent
 * CLI. A missing provider leaves no agent to launch, so the session must fall
 * back to the system shell instead of silently defaulting to one.
 */
function readIsPlainShell(message: ShellIncomingMessage): boolean {
  const provider = readString(message.provider);
  return (
    readBoolean(message.isPlainShell) ||
    (!!readString(message.initialCommand) && !readBoolean(message.hasSession)) ||
    provider === 'plain-shell' ||
    !provider
  );
}

function resolveResumeSessionId(
  message: ShellIncomingMessage,
  dependencies: ShellWebSocketDependencies
): string {
  const hasSession = readBoolean(message.hasSession);
  const sessionId = readString(message.sessionId);
  const provider = readString(message.provider, 'claude');

  if (!hasSession || !sessionId) {
    return '';
  }

  let resumeSessionId: string | null | undefined;
  try {
    resumeSessionId = dependencies.resolveProviderSessionId(sessionId, provider);
  } catch (error) {
    console.error('Failed to resolve provider session ID:', error);
    resumeSessionId = undefined;
  }

  const resolvedSessionId = resumeSessionId === undefined ? sessionId : resumeSessionId;
  if (!resolvedSessionId || !SAFE_SESSION_ID_PATTERN.test(resolvedSessionId)) {
    return '';
  }

  return resolvedSessionId;
}

/**
 * Resolves provider command line for plain shell and agent-backed shell modes.
 */
function buildShellCommand(
  message: ShellIncomingMessage,
  dependencies: ShellWebSocketDependencies
): string {
  const hasSession = readBoolean(message.hasSession);
  const initialCommand = readString(message.initialCommand);
  const provider = readString(message.provider, 'claude');
  const resumeSessionId = resolveResumeSessionId(message, dependencies);
  const isPlainShell = readIsPlainShell(message);

  if (isPlainShell) {
    // An empty command would spawn `bash -c ""` and exit instantly; a bare
    // terminal pane needs the user's interactive shell instead. On Windows the
    // empty command makes the launcher start PowerShell interactively.
    return initialCommand || (os.platform() === 'win32' ? '' : process.env.SHELL || 'bash');
  }

  if (provider === 'cursor') {
    if (resumeSessionId) {
      return `cursor-agent --resume="${resumeSessionId}"`;
    }
    return 'cursor-agent';
  }

  if (provider === 'codex') {
    if (resumeSessionId) {
      if (os.platform() === 'win32') {
        return `codex resume "${resumeSessionId}"; if ($LASTEXITCODE -ne 0) { codex }`;
      }
      return `codex resume "${resumeSessionId}" || codex`;
    }
    return 'codex';
  }

  if (provider === 'opencode') {
    if (resumeSessionId) {
      return `opencode --session "${resumeSessionId}"`;
    }
    return initialCommand || 'opencode';
  }

  if (provider === 'devin') {
    if (resumeSessionId) {
      return `devin --resume "${resumeSessionId}"`;
    }
    return initialCommand || 'devin';
  }

  if (provider === 'commandcode') {
    const commandCodeBin = os.platform() === 'win32' ? 'cmdc' : 'command-code';
    if (resumeSessionId) {
      return `${commandCodeBin} --resume "${resumeSessionId}"`;
    }
    return initialCommand || commandCodeBin;
  }

  if (provider === 'antigravity') {
    if (resumeSessionId) {
      return `agy --conversation "${resumeSessionId}"`;
    }
    return initialCommand || 'agy';
  }

  // `--allow-dangerously-skip-permissions` only adds "bypass permissions" to
  // the Shift+Tab mode cycle (Claude Code ≥ 2.1) — the session still starts
  // in the default mode. Without it the terminal CLI has no way to reach
  // bypass at all, unlike the chat composer.
  const claude = `claude ${CLAUDE_TERMINAL_FLAGS}`;
  const command = initialCommand || claude;
  if (resumeSessionId) {
    if (os.platform() === 'win32') {
      return `${claude} --resume "${resumeSessionId}"; if ($LASTEXITCODE -ne 0) { ${claude} }`;
    }
    return `${claude} --resume "${resumeSessionId}" || ${claude}`;
  }
  return command;
}

/**
 * Reads the init message's extra env, keeping only string values under valid
 * variable names — the keys land verbatim in the PTY environment.
 */
function readShellEnv(value: unknown): Record<string, string> {
  return Object.fromEntries(
    Object.entries(readStringRecord(value) ?? {}).filter(([key]) => ENV_KEY_PATTERN.test(key))
  );
}

function readEnvValue(env: NodeJS.ProcessEnv, key: string): string | undefined {
  const resolvedKey = Object.keys(env).find((envKey) => envKey.toLowerCase() === key.toLowerCase());
  return resolvedKey ? env[resolvedKey] : undefined;
}

function getPathEnvKey(env: NodeJS.ProcessEnv): string {
  return Object.keys(env).find((key) => key.toLowerCase() === 'path') || 'PATH';
}

function prioritizeUserNpmGlobalBin(env: NodeJS.ProcessEnv): { key: string; value: string | undefined } {
  const pathKey = getPathEnvKey(env);
  const currentPath = env[pathKey];
  if (!currentPath) {
    return { key: pathKey, value: currentPath };
  }

  const delimiter = path.delimiter;
  const pathEntries = currentPath.split(delimiter).filter(Boolean);
  const npmPrefix = readEnvValue(env, 'npm_config_prefix');
  const appData = readEnvValue(env, 'APPDATA');
  const candidates = [
    npmPrefix || '',
    npmPrefix ? path.join(npmPrefix, 'bin') : '',
    appData ? path.join(appData, 'npm') : '',
    path.join(os.homedir(), 'AppData', 'Roaming', 'npm'),
    path.join(os.homedir(), '.npm-global', 'bin'),
  ].filter(Boolean);

  const normalizedPathEntries = pathEntries.map((entry) => os.platform() === 'win32' ? entry.toLowerCase() : entry);
  const preferredEntries = candidates.filter((candidate, index) => {
    const normalizedCandidate = os.platform() === 'win32' ? candidate.toLowerCase() : candidate;
    return (
      candidates.indexOf(candidate) === index &&
      normalizedPathEntries.includes(normalizedCandidate)
    );
  });

  if (preferredEntries.length === 0) {
    return { key: pathKey, value: currentPath };
  }

  const normalizedPreferredEntries = preferredEntries.map((entry) =>
    os.platform() === 'win32' ? entry.toLowerCase() : entry
  );

  const value = [
    ...preferredEntries,
    ...pathEntries.filter((entry) => {
      const normalizedEntry = os.platform() === 'win32' ? entry.toLowerCase() : entry;
      return !normalizedPreferredEntries.includes(normalizedEntry);
    }),
  ].join(delimiter);

  return { key: pathKey, value };
}

/**
 * Used by this module's websocket gateway to connect the standalone Shell UI
 * to a retained PTY while keeping process lifecycle ownership on the server.
 * Several sockets (the same synced tab on several devices) may view one PTY.
 */
export function handleShellConnection(
  ws: WebSocket,
  dependencies: ShellWebSocketDependencies
): void {
  console.log('[INFO] Shell websocket connected');

  let ptySessionKey: string | null = null;

  /** The PTY this socket views — input and resize go there, never elsewhere. */
  const viewedSession = (): PtySessionEntry | null => {
    const session = ptySessionKey ? ptySessionsMap.get(ptySessionKey) : undefined;
    return session?.sockets.has(ws) ? session : null;
  };

  ws.on('message', async (rawMessage) => {
    try {
      const data = parseShellMessage(rawMessage);
      if (!data?.type) {
        throw new Error('Invalid websocket payload');
      }

      if (data.type === 'init') {
        const projectPath = readString(data.projectPath, process.cwd());
        const sessionId = readString(data.sessionId) || null;
        const hasSession = readBoolean(data.hasSession);
        const provider = readString(data.provider, 'claude');
        const initialCommand = readString(data.initialCommand);
        const forceRestart = readBoolean(data.forceRestart);
        const isPlainShell = readIsPlainShell(data);
        const initSize: TerminalSize = {
          cols: readNumber(data.cols, 80),
          rows: readNumber(data.rows, 24),
        };

        const isLoginCommand =
          !!initialCommand &&
          (initialCommand.includes('setup-token') ||
            initialCommand.includes('cursor-agent login') ||
            initialCommand.includes('auth login'));

        const commandSuffix =
          isPlainShell && initialCommand
            ? `_cmd_${Buffer.from(initialCommand).toString('base64').slice(0, 16)}`
            : '';
        const nextSessionKey = `${projectPath}_${sessionId ?? 'default'}${commandSuffix}`;
        // A socket views one PTY at a time; re-init onto another key leaves the old one.
        if (ptySessionKey && ptySessionKey !== nextSessionKey) {
          detachViewer(ptySessionKey, ws);
        }
        ptySessionKey = nextSessionKey;

        // A respawn keeps the other devices' viewers: they see the new run.
        let carriedViewers: WebSocket[] = [];
        if (isLoginCommand || forceRestart) {
          const oldSession = ptySessionsMap.get(ptySessionKey);
          if (oldSession) {
            if (oldSession.timeoutId) {
              clearTimeout(oldSession.timeoutId);
            }
            carriedViewers = [...oldSession.sockets].filter(
              (socket) => socket !== ws && socket.readyState === WebSocket.OPEN
            );
            oldSession.pty.kill();
            ptySessionsMap.delete(ptySessionKey);
          }
        }

        const existingSession =
          isLoginCommand || forceRestart ? null : ptySessionsMap.get(ptySessionKey);
        if (existingSession) {
          if (existingSession.timeoutId) {
            clearTimeout(existingSession.timeoutId);
            existingSession.timeoutId = null;
          }
          // Re-adding moves the socket to the end: it is now the most recent viewer.
          existingSession.sockets.delete(ws);
          existingSession.sockets.add(ws);
          existingSession.sizes.set(ws, initSize);
          existingSession.owner = ws;
          // Only a lone viewer resizes on attach: another device opening the
          // tab (possibly in the background, at the 80×24 placeholder) must
          // not reflow the shell under the person typing in it.
          if (existingSession.sockets.size === 1) {
            applyViewerSize(existingSession, ws);
          }

          ws.send(
            JSON.stringify({
              type: 'output',
              data: '\x1b[36m[Reconnected to existing session]\x1b[0m\r\n',
            })
          );

          if (existingSession.buffer.length > 0) {
            existingSession.buffer.forEach((bufferedData) => {
              // `replay` lets the client redraw old output without answering
              // the terminal queries in it again — those replies would land
              // in the shell as typed input.
              ws.send(
                JSON.stringify({
                  type: 'output',
                  data: bufferedData,
                  replay: true,
                })
              );
            });
          }
          return;
        }

        // A one-shot command (agent install/update/login from Settings) does
        // not depend on its cwd: it runs from home when the client names no
        // project, or one this server does not have (older clients send their
        // first known project, which may live on another machine or be gone).
        // An agent session must stay in its project to resume, so a missing
        // path still fails there.
        const isOneShotCommand = isPlainShell && !!initialCommand && !hasSession;
        let resolvedProjectPath = !projectPath && isOneShotCommand ? os.homedir() : path.resolve(projectPath);
        if (!isDirectory(resolvedProjectPath)) {
          if (!isOneShotCommand) {
            ws.send(JSON.stringify({ type: 'error', message: 'Invalid project path' }));
            return;
          }
          resolvedProjectPath = os.homedir();
        }

        const safeSessionIdPattern = /^[a-zA-Z0-9_.\-:]+$/;
        if (sessionId && !safeSessionIdPattern.test(sessionId)) {
          ws.send(JSON.stringify({ type: 'error', message: 'Invalid session ID' }));
          return;
        }

        const shellCommand = buildShellCommand(data, dependencies);
        const resumeSessionId = resolveResumeSessionId(data, dependencies);
        const shell = os.platform() === 'win32' ? 'powershell.exe' : 'bash';
        const shellArgs =
          os.platform() === 'win32' ? powerShellArgs(shellCommand) : ['-c', shellCommand];
        const prioritizedPath = prioritizeUserNpmGlobalBin(process.env);

        const spawnedPty = (dependencies.spawnPty ?? pty.spawn)(shell, shellArgs, {
          name: 'xterm-256color',
          cols: initSize.cols,
          rows: initSize.rows,
          cwd: resolvedProjectPath,
          env: providerChildEnv(
            {
              ...readShellEnv(data.env),
              TERM: 'xterm-256color',
              COLORTERM: 'truecolor',
              FORCE_COLOR: '3',
            },
            // providerChildEnv also puts the running node.exe dir on a Windows PATH.
            { ...process.env, [prioritizedPath.key]: prioritizedPath.value }
          ),
        });

        // The lifecycle handlers below compare against `spawnedPty` and this
        // key: a later init may respawn the terminal under the same key (login
        // command / forceRestart) or move this socket to another key, and a
        // stale handler must neither write to nor delete the NEW entry.
        const sessionKey = ptySessionKey;
        const viewerSizes = new Map<WebSocket, TerminalSize>();
        for (const socket of carriedViewers) {
          viewerSizes.set(socket, initSize);
        }
        viewerSizes.set(ws, initSize);
        ptySessionsMap.set(sessionKey, {
          pty: spawnedPty,
          sockets: new Set([...carriedViewers, ws]),
          owner: ws,
          sizes: viewerSizes,
          size: initSize,
          buffer: [],
          timeoutId: null,
          projectPath,
          sessionId,
        });

        // Auth-link detection state lives with the PTY, not with a socket.
        let urlDetectionBuffer = '';
        const announcedAuthUrls = new Set<string>();

        spawnedPty.onData((chunk) => {
          // A respawned terminal leaves this handler attached to the old PTY;
          // only the PTY that owns the current map entry may write to it.
          const session = ptySessionsMap.get(sessionKey);
          if (!session || session.pty !== spawnedPty) {
            return;
          }

          if (session.buffer.length < 5000) {
            session.buffer.push(chunk);
          } else {
            session.buffer.shift();
            session.buffer.push(chunk);
          }

          if (session.sockets.size > 0) {
            let outputData = chunk;
            const cleanChunk = stripAnsiSequences(chunk);
            // The buffer keeps the raw stream: escape sequences split across
            // chunks (e.g. an OSC-8 hyperlink) reassemble here and strip
            // cleanly instead of leaking `8;id=…`/`8;;` remnants into URLs.
            urlDetectionBuffer = `${urlDetectionBuffer}${chunk}`.slice(-SHELL_URL_PARSE_BUFFER_LIMIT);
            const cleanDetectionBuffer = stripAnsiSequences(urlDetectionBuffer);

            outputData = outputData.replace(
              /OPEN_URL:\s*(https?:\/\/[^\s\x1b\x07]+)/g,
              '[INFO] Opening in browser: $1'
            );

            const emitAuthUrl = (detectedUrl: string, autoOpen = false) => {
              const normalizedUrl = normalizeDetectedUrl(detectedUrl);
              if (
                !normalizedUrl ||
                announcedAuthUrls.has(normalizedUrl) ||
                isLoopbackUrl(normalizedUrl)
              ) {
                return;
              }
              if (!autoOpen && !isLikelyAuthUrl(normalizedUrl, cleanDetectionBuffer)) {
                return;
              }

              // Progressive TUI renders (Ink re-draws) cut the URL mid-chunk,
              // emitting truncated prefixes. Suppress a URL that is a prefix
              // of an already-announced one; a longer URL extending an
              // earlier fragment still emits so the client lands on the
              // complete link.
              for (const announcedUrl of announcedAuthUrls) {
                if (announcedUrl.startsWith(normalizedUrl)) {
                  return;
                }
              }

              announcedAuthUrls.add(normalizedUrl);
              broadcastFrame(session, { type: 'auth_url', url: normalizedUrl, autoOpen });
            };

            // OSC-8 hyperlink targets are canonical full URLs — emit before
            // the display-text pass so fragments can't win the client's pick.
            for (const match of urlDetectionBuffer.matchAll(OSC8_HYPERLINK_URL_REGEX)) {
              emitAuthUrl(match[1]);
            }

            const normalizedDetectedUrls = extractUrlsFromText(cleanDetectionBuffer)
              .map((url) => normalizeDetectedUrl(url))
              .filter((url): url is string => Boolean(url));

            const dedupedDetectedUrls = Array.from(new Set(normalizedDetectedUrls)).filter(
              (url, _, urls) =>
                !urls.some((otherUrl) => otherUrl !== url && otherUrl.startsWith(url))
            );

            dedupedDetectedUrls.forEach((url) => emitAuthUrl(url, false));

            if (
              shouldAutoOpenUrlFromOutput(cleanChunk) &&
              dedupedDetectedUrls.length > 0
            ) {
              const bestUrl = dedupedDetectedUrls.reduce((longest, current) =>
                current.length > longest.length ? current : longest
              );
              emitAuthUrl(bestUrl, true);
            }

            broadcastOutput(session, outputData);
          }
        });

        spawnedPty.onExit((exitCode) => {
          const session = ptySessionsMap.get(sessionKey);
          if (session && session.pty !== spawnedPty) {
            return;
          }

          if (session) {
            broadcastFrame(session, {
              type: 'output',
              data: `\r\n\x1b[33mProcess exited with code ${exitCode.exitCode}${
                exitCode.signal != null ? ` (${exitCode.signal})` : ''
              }\x1b[0m\r\n`,
            });
          }

          if (session?.timeoutId) {
            clearTimeout(session.timeoutId);
          }

          ptySessionsMap.delete(sessionKey);
        });

        let welcomeMsg = `\x1b[36mStarting terminal in: ${projectPath}\x1b[0m\r\n`;
        if (!isPlainShell) {
          const providerName =
            provider === 'cursor'
              ? 'Cursor'
              : provider === 'codex'
                ? 'Codex'
                : provider === 'opencode'
                    ? 'OpenCode'
                    : provider === 'commandcode'
                      ? 'Command Code'
                      : provider === 'antigravity'
                        ? 'Antigravity'
                        : 'Claude';
          welcomeMsg = hasSession && resumeSessionId
            ? `\x1b[36mResuming ${providerName} session ${resumeSessionId} in: ${projectPath}\x1b[0m\r\n`
            : `\x1b[36mStarting new ${providerName} session in: ${projectPath}\x1b[0m\r\n`;
        }

        // Carried viewers of a respawn see the new run start too.
        broadcastFrame(ptySessionsMap.get(sessionKey)!, { type: 'output', data: welcomeMsg });
        return;
      }

      if (data.type === 'input') {
        const session = viewedSession();
        if (session) {
          // Typing makes this device the one in charge: it answers the next
          // terminal queries and the PTY takes its size.
          if (session.owner !== ws) {
            session.owner = ws;
            applyViewerSize(session, ws);
          }
          session.pty.write(readString(data.data));
        }
        return;
      }

      if (data.type === 'resize') {
        const session = viewedSession();
        if (session) {
          session.sizes.set(ws, { cols: readNumber(data.cols, 80), rows: readNumber(data.rows, 24) });
          if (session.owner === ws) {
            applyViewerSize(session, ws);
          }
        }
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[ERROR] Shell WebSocket error:', message);
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(
          JSON.stringify({
            type: 'output',
            data: `\r\n\x1b[31mError: ${message}\x1b[0m\r\n`,
          })
        );
      }
    }
  });

  ws.on('close', () => {
    if (ptySessionKey) {
      detachViewer(ptySessionKey, ws);
    }
  });

  ws.on('error', (error) => {
    console.error('[ERROR] Shell WebSocket error:', error);
  });
}
