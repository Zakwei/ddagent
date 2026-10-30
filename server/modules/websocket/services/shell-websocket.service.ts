import { randomUUID } from 'node:crypto';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import pty from 'node-pty';
import { WebSocket, type RawData } from 'ws';

import { workspaceStateDb } from '@/modules/database/index.js';
import {
  connectPtyHost,
  resolvePtyHostSocketPath,
  type HostedPty,
  type PtyHostClient,
  type PtyHostSnapshot,
} from '@/modules/pty-host/index.js';
import type { TerminalReplayState } from '@/shared/types.js';
import {
  createTerminalReplayState,
  ENV_KEY_PATTERN,
  killProcessGroup,
  parseIncomingJsonObject,
  powerShellArgs,
  providerChildEnv,
  readStringRecord,
  terminalStatePreamble,
  trackTerminalState,
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
  /** Reattach: the output stream the client already shows, and how far. */
  stream?: string;
  seen?: number;
};

type TerminalSize = { cols: number; rows: number };


type PtySessionEntry = {
  pty: HostedPty;
  /** Held by the PTY host daemon (survives server restarts), not by this process. */
  hosted: boolean;
  /**
   * A one-shot command (`_cmd_` key) or a PTY without a tab id: never in the
   * synced tab list, so the sweep ends it after a long stretch unviewed.
   */
  isCommand: boolean;
  createdAt: number;
  /** When the last viewer left (or the entry was adopted with none); null while viewed. */
  detachedAt: number | null;
  /** Since when no synced tab names this PTY; null while one does. */
  missingSince: number | null;
  /**
   * Every socket showing this PTY — the same terminal tab open on several
   * devices (tabs are synced across the user's devices). Output fans out to
   * all of them. The PTY outlives its last viewer: only a `terminate` from a
   * closed tab (or the process exiting) ends it.
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
  /** Recent output, replayed to a socket that (re)attaches. */
  buffer: string[];
  /** Total length of [buffer] — capped by PTY_BUFFER_MAX_CHARS. */
  bufferChars: number;
  /** Restored ahead of a full replay, whose window may start after it was set. */
  replayState: TerminalReplayState;
  /**
   * Identifies this run's output. Offsets are comparable only within one
   * stream: a respawn under the same key starts a new one.
   */
  streamId: string;
  /** Characters of output this run produced so far — the end of [buffer]. */
  outputEnd: number;
  /** How far into the stream each viewer has been sent. */
  sentEnds: Map<WebSocket, number>;
  /** Viewers whose socket backed up, polled until they can catch up. */
  catchUpTimers: Map<WebSocket, NodeJS.Timeout>;
  projectPath: string;
  sessionId: string | null;
};

const ptySessionsMap = new Map<string, PtySessionEntry>();

type PtyExit = { exitCode: number; signal?: number | null };

/**
 * Runs that ended, by PTY key: a device away when its PTY exited reattaches
 * naming that stream and must see the exit — not respawn the command (a
 * one-shot install run twice, an agent the user quit resumed on the phone).
 */
const exitedStreams = new Map<string, { streamId: string; exit: PtyExit; at: number }>();
const EXITED_STREAM_TTL_MS = 24 * 60 * 60 * 1000;
const EXITED_STREAMS_MAX = 500;

function rememberExit(sessionKey: string, streamId: string, exit: PtyExit): void {
  const now = Date.now();
  for (const [key, entry] of exitedStreams) {
    if (now - entry.at > EXITED_STREAM_TTL_MS || exitedStreams.size >= EXITED_STREAMS_MAX) {
      exitedStreams.delete(key);
    }
  }
  exitedStreams.delete(sessionKey);
  exitedStreams.set(sessionKey, { streamId, exit, at: now });
}

/** The exit line every viewer gets; clients act on `exitCode`, not the text. */
function exitFrame(exit: PtyExit): Record<string, unknown> {
  return {
    type: 'output',
    exitCode: exit.exitCode,
    data: `\r\n\x1b[33mProcess exited with code ${exit.exitCode}${
      exit.signal != null ? ` (${exit.signal})` : ''
    }\x1b[0m\r\n`,
  };
}

/** The PTY host daemon connection, when one runs (see startShellPtyHost). */
let ptyHost: PtyHostClient | null = null;

function sendIfOpen(socket: WebSocket, frame: Record<string, unknown>): void {
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify(frame));
  }
}

// The replay window: enough to repaint a TUI and keep recent scrollback, small
// enough that a reattach does not freeze the client. Writing 5000 unbounded
// chunks (~23 MB of Claude Code redraws) blocked the web UI for 13 s on every
// reconnect.
const PTY_BUFFER_MAX_CHUNKS = 5000;
const PTY_BUFFER_MAX_CHARS = 512 * 1024;
// Replay is sent in a few large frames rather than one per chunk.
const REPLAY_FRAME_CHARS = 64 * 1024;
// Erase screen + scrollback, cursor home — a full replay repaints from a blank
// terminal instead of appending another copy of history the client shows.
const REPLAY_CLEAR_SEQUENCE = '\x1b[2J\x1b[3J\x1b[H';
// A viewer whose socket holds more unsent data than this gets no more frames
// until it drains, then catches up from its offset — a slow phone link must
// not pile megabytes of redraws into server memory or lag ever further behind.
const VIEWER_MAX_BUFFERED_BYTES = 1024 * 1024;
const VIEWER_CATCH_UP_POLL_MS = 250;

/** Appends output to the replay window, evicting the oldest chunks. */
function appendToReplayBuffer(session: PtySessionEntry, chunk: string): void {
  session.buffer.push(chunk);
  session.bufferChars += chunk.length;
  session.outputEnd += chunk.length;
  while (
    session.buffer.length > PTY_BUFFER_MAX_CHUNKS ||
    (session.bufferChars > PTY_BUFFER_MAX_CHARS && session.buffer.length > 1)
  ) {
    session.bufferChars -= session.buffer.shift()!.length;
  }
}

/**
 * Splits an adopted daemon window into replay-frame-sized chunks. Kept whole,
 * the first new output pushed it over the cap and eviction dropped all of it,
 * so every later reattach after a server restart lost its scrollback.
 */
function splitReplayWindow(window: string): string[] {
  const chunks: string[] = [];
  for (let start = 0; start < window.length; start += REPLAY_FRAME_CHARS) {
    chunks.push(window.slice(start, start + REPLAY_FRAME_CHARS));
  }
  return chunks;
}

/** Stream offset of the oldest output still in the replay window. */
function bufferStart(session: PtySessionEntry): number {
  return session.outputEnd - session.bufferChars;
}

/**
 * The buffered output from stream offset `from` on, joined into frames of at
 * most REPLAY_FRAME_CHARS, each with the stream offset it ends at.
 */
function bufferedFramesSince(
  session: PtySessionEntry,
  from: number
): Array<{ data: string; end: number }> {
  const parts: string[] = [];
  let offset = session.outputEnd;
  for (let index = session.buffer.length - 1; index >= 0 && offset > from; index -= 1) {
    const chunk = session.buffer[index];
    const chunkStart = offset - chunk.length;
    parts.push(chunkStart < from ? chunk.slice(from - chunkStart) : chunk);
    offset = chunkStart;
  }
  parts.reverse();

  const frames: Array<{ data: string; end: number }> = [];
  let end = Math.max(from, offset);
  let pending = '';
  for (const part of parts) {
    if (pending && pending.length + part.length > REPLAY_FRAME_CHARS) {
      frames.push({ data: pending, end });
      pending = '';
    }
    pending += part;
    end += part.length;
  }
  if (pending) {
    frames.push({ data: pending, end });
  }
  return frames;
}

// How long a PTY sits one row short so its program sees a real size change.
const REPAINT_NUDGE_MS = 100;

/**
 * Makes the program redraw its whole screen: one row shorter, then back
 * (two SIGWINCHes). A TUI that paints only differences (Claude Code) would
 * otherwise keep drawing onto a replayed window that is not the screen it
 * believes it drew — words cut at the margin, overlapping status lines.
 */
function nudgeRepaint(session: PtySessionEntry): void {
  const { cols, rows } = session.size;
  if (rows < 2) {
    return;
  }
  session.pty.resize(cols, rows - 1);
  setTimeout(() => {
    // A PTY that exited or was replaced meanwhile has nothing to repaint.
    if (![...ptySessionsMap.values()].includes(session)) {
      return;
    }
    try {
      session.pty.resize(session.size.cols, session.size.rows);
    } catch {
      // Exited between the check and the resize.
    }
  }, REPAINT_NUDGE_MS);
}

/**
 * Full repaint for a socket whose client holds none of this stream (another
 * device, a reload, or a gap older than the window): a clear first, then the
 * whole replay window. Every frame is flagged `replay` so the client does not
 * answer the terminal queries in it again — those replies would land in the
 * shell as typed input.
 */
function sendReplayWindow(socket: WebSocket, session: PtySessionEntry, banner?: string): void {
  sendIfOpen(socket, {
    type: 'output',
    data: REPLAY_CLEAR_SEQUENCE + terminalStatePreamble(session.replayState),
    replay: true,
  });
  if (banner) {
    sendIfOpen(socket, { type: 'output', data: banner });
  }
  for (const frame of bufferedFramesSince(session, bufferStart(session))) {
    sendIfOpen(socket, { type: 'output', data: frame.data, end: frame.end, replay: true });
  }
  session.sentEnds.set(socket, session.outputEnd);
  nudgeRepaint(session);
}

/**
 * Sends `socket` the output it has not been sent yet. When the only gap is the
 * chunk that starts at `liveChunkStart`, it goes out live (as `liveData`,
 * the chunk with display rewrites applied): verbatim to the
 * owner, flagged `replay` to the other viewers (only one emulator answers
 * terminal queries). Any wider gap — a backed-up socket catching up, or a
 * reattach — is all flagged `replay`: its queries were answered by another
 * viewer or are stale by now.
 */
function deliverOutput(
  session: PtySessionEntry,
  socket: WebSocket,
  liveChunkStart?: number,
  liveData?: string
): void {
  if (socket.readyState !== WebSocket.OPEN) {
    return;
  }
  const sentEnd = session.sentEnds.get(socket) ?? session.outputEnd;
  if (sentEnd >= session.outputEnd) {
    return;
  }
  if (socket.bufferedAmount > VIEWER_MAX_BUFFERED_BYTES) {
    scheduleCatchUp(session, socket);
    return;
  }

  if (sentEnd === liveChunkStart) {
    const data = liveData ?? session.buffer.at(-1)!;
    const end = session.outputEnd;
    sendIfOpen(
      socket,
      socket === session.owner
        ? { type: 'output', data, end }
        : // `live`: new output all the same — a bell in it marks the tab there.
          { type: 'output', data, end, replay: true, live: true }
    );
  } else if (sentEnd < bufferStart(session)) {
    sendReplayWindow(socket, session);
  } else {
    for (const frame of bufferedFramesSince(session, sentEnd)) {
      sendIfOpen(socket, { type: 'output', data: frame.data, end: frame.end, replay: true });
    }
  }
  session.sentEnds.set(socket, session.outputEnd);
}

/** Retries delivery to a backed-up socket once it may have drained. */
function scheduleCatchUp(session: PtySessionEntry, socket: WebSocket): void {
  if (session.catchUpTimers.has(socket)) {
    return;
  }
  session.catchUpTimers.set(
    socket,
    setTimeout(() => {
      session.catchUpTimers.delete(socket);
      if (session.sockets.has(socket)) {
        deliverOutput(session, socket);
      }
    }, VIEWER_CATCH_UP_POLL_MS)
  );
}

/** Stops the per-viewer timers of a PTY that is going away. */
function disposeSession(session: PtySessionEntry): void {
  for (const timer of session.catchUpTimers.values()) {
    clearTimeout(timer);
  }
  session.catchUpTimers.clear();
}

/**
 * Ends a PTY together with everything started in it (an agent CLI's MCP
 * servers, background jobs) — see killProcessGroup. The daemon does the same
 * for a PTY it holds.
 */
function endPty(session: PtySessionEntry): void {
  disposeSession(session);
  if (session.hosted) {
    session.pty.kill();
    return;
  }
  killProcessGroup(session.pty.pid, () => session.pty.kill());
}

/**
 * Where a reattaching client can resume: its `seen` offset when it shows this
 * very stream and the replay window still covers the gap, otherwise null.
 */
function readResumeOffset(message: ShellIncomingMessage, session: PtySessionEntry): number | null {
  const seen = message.seen;
  if (
    message.stream !== session.streamId ||
    typeof seen !== 'number' ||
    !Number.isInteger(seen) ||
    seen < bufferStart(session) ||
    seen > session.outputEnd
  ) {
    return null;
  }
  return seen;
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
 * with none left the PTY keeps running for the next reattach — a phone may
 * sit in the background for hours, and the tab is still open there.
 */
function detachViewer(sessionKey: string, socket: WebSocket): void {
  const session = ptySessionsMap.get(sessionKey);
  // Mobile networks can deliver an old socket's close after its replacement
  // has attached — only a socket still in the viewer set may detach.
  if (!session || !session.sockets.delete(socket)) {
    return;
  }
  session.sizes.delete(socket);
  session.sentEnds.delete(socket);
  const catchUp = session.catchUpTimers.get(socket);
  if (catchUp) {
    clearTimeout(catchUp);
    session.catchUpTimers.delete(socket);
  }
  if (session.owner === socket) {
    session.owner = [...session.sockets].at(-1) ?? null;
    if (session.owner) {
      applyViewerSize(session, session.owner);
    }
  }
  if (session.sockets.size === 0) {
    session.detachedAt = Date.now();
  }
}

/**
 * Wires a PTY's output and exit to its session entry under `sessionKey`:
 * buffering, auth-link detection, delivery to the viewers, and the exit line.
 * Used for freshly spawned PTYs and for ones adopted from the PTY host.
 */
function wirePtySession(sessionKey: string, spawnedPty: HostedPty): void {
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

    // The replay window keeps the raw stream, so stream offsets agree with
    // the PTY host's (an adopted buffer continues them); the display rewrite
    // below only touches the live frame.
    appendToReplayBuffer(session, chunk);
    trackTerminalState(session.replayState, chunk);
    const outputData = chunk.replace(
      /OPEN_URL:\s*(https?:\/\/[^\s\x1b\x07]+)/g,
      '[INFO] Opening in browser: $1'
    );

    if (session.sockets.size > 0) {
      const cleanChunk = stripAnsiSequences(chunk);
      // The buffer keeps the raw stream: escape sequences split across
      // chunks (e.g. an OSC-8 hyperlink) reassemble here and strip
      // cleanly instead of leaking `8;id=…`/`8;;` remnants into URLs.
      urlDetectionBuffer = `${urlDetectionBuffer}${chunk}`.slice(-SHELL_URL_PARSE_BUFFER_LIMIT);
      const cleanDetectionBuffer = stripAnsiSequences(urlDetectionBuffer);

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

      const liveChunkStart = session.outputEnd - chunk.length;
      for (const socket of session.sockets) {
        deliverOutput(session, socket, liveChunkStart, outputData);
      }
    }
  });

  spawnedPty.onExit((exitCode) => {
    // A terminated PTY left the map already; a new one may hold its key.
    const session = ptySessionsMap.get(sessionKey);
    if (!session || session.pty !== spawnedPty) {
      return;
    }

    // A viewer held back by a full socket would otherwise get the exit line
    // without the output that explains it: its catch-up dies with the session.
    for (const socket of session.sockets) {
      const from = Math.max(session.sentEnds.get(socket) ?? session.outputEnd, bufferStart(session));
      for (const frame of bufferedFramesSince(session, from)) {
        sendIfOpen(socket, { type: 'output', data: frame.data, end: frame.end, replay: true });
      }
      session.sentEnds.set(socket, session.outputEnd);
    }
    rememberExit(sessionKey, session.streamId, exitCode);
    // `exitCode` is what clients act on: the text alone also shows up in
    // a program's own output (an agent transcript quoting it).
    broadcastFrame(session, exitFrame(exitCode));

    disposeSession(session);
    ptySessionsMap.delete(sessionKey);
  });
}

/** Rebuilds the session entry of a PTY the daemon kept through a server restart. */
function adoptHostedPty(snapshot: PtyHostSnapshot, heldPty: HostedPty, now: number): void {
  const meta = snapshot.meta;
  const sessionKey = typeof meta.sessionKey === 'string' ? meta.sessionKey : null;
  if (!sessionKey || ptySessionsMap.has(sessionKey)) {
    // Not ours to show (or a stray duplicate of a key): nothing could reattach it.
    heldPty.kill();
    return;
  }
  // The daemon tracks the whole run; an older daemon leaves only its window to scan.
  const replayState = createTerminalReplayState();
  if (snapshot.terminalState) {
    replayState.title = snapshot.terminalState.title;
    replayState.modes = new Map(snapshot.terminalState.modes);
  } else {
    trackTerminalState(replayState, snapshot.buffer);
  }
  ptySessionsMap.set(sessionKey, {
    pty: heldPty,
    hosted: true,
    isCommand: meta.isCommand === true,
    createdAt: readNumber(meta.createdAt, now),
    detachedAt: now,
    missingSince: null,
    sockets: new Set(),
    owner: null,
    sizes: new Map(),
    size: { cols: snapshot.cols, rows: snapshot.rows },
    buffer: splitReplayWindow(snapshot.buffer),
    bufferChars: snapshot.buffer.length,
    replayState,
    // The daemon id is the stream id the PTY was spawned with, and its
    // offsets count the same raw output — clients resume without a repaint.
    streamId: snapshot.id,
    outputEnd: snapshot.outputEnd,
    sentEnds: new Map(),
    catchUpTimers: new Map(),
    projectPath: readString(meta.projectPath),
    sessionId: typeof meta.sessionId === 'string' ? meta.sessionId : null,
  });
  wirePtySession(sessionKey, heldPty);
}

/**
 * Connects the `/shell` gateway to the PTY host daemon when one listens on
 * `socketPath`, and adopts the terminals it kept through a server restart —
 * with their scrollback and stream offsets. Without a daemon PTYs are spawned
 * in this process, as before, and die with it. Resolves with the daemon
 * connection (null without one). Used by the server entrypoint at startup,
 * before it accepts connections.
 */
export async function startShellPtyHost(
  socketPath = resolvePtyHostSocketPath()
): Promise<PtyHostClient | null> {
  const client = await connectPtyHost(socketPath);
  if (!client) {
    return null;
  }
  ptyHost = client;
  client.onClose(() => {
    if (ptyHost === client) {
      ptyHost = null;
    }
  });
  const now = Date.now();
  const adopted = await client.adoptAll((snapshot, heldPty) => adoptHostedPty(snapshot, heldPty, now));
  console.log(`[INFO] PTY host connected at ${socketPath}; adopted ${adopted} terminal(s)`);
  return client;
}

// A tab's PTY exists before the client publishes the tab, and a closed tab's
// row lingers until the next push: only a PTY unseen this long is an orphan.
const ORPHAN_GRACE_MS = 2 * 60 * 1000;
// One-shot commands (login, install) are not synced tabs; nobody returns to
// one after this long without a viewer.
const COMMAND_IDLE_MS = 30 * 60 * 1000;
const SWEEP_INTERVAL_MS = 60 * 1000;

/**
 * The PTY session ids (`ptySessionId`, or the agent `sessionId`) of every
 * terminal tab in the users' synced workspaces; null when no workspace was
 * ever synced, which tells nothing about which tabs exist.
 */
function readSyncedTabIds(states: unknown[]): Set<string> | null {
  if (states.length === 0) {
    return null;
  }
  const ids = new Set<string>();
  for (const state of states) {
    const terminals = (state as { terminals?: unknown } | null)?.terminals;
    if (!terminals || typeof terminals !== 'object') {
      continue;
    }
    for (const row of Object.values(terminals)) {
      const tabs = (row as { tabs?: unknown } | null)?.tabs;
      for (const tab of Array.isArray(tabs) ? tabs : []) {
        for (const id of [tab?.ptySessionId, tab?.sessionId]) {
          if (typeof id === 'string') {
            ids.add(id);
          }
        }
      }
    }
  }
  return ids;
}

/**
 * Ends the PTYs nobody can reach any more and returns their keys. A PTY is
 * kept while any viewer is attached. A tab's PTY ends once no synced tab
 * names it for ORPHAN_GRACE_MS — its tab was closed while the socket that
 * would have sent `terminate` was down, or by an older client that never
 * sends it. A one-shot command's PTY ends after COMMAND_IDLE_MS unviewed.
 * Exported for the sweep timer and tests.
 */
export function sweepOrphanedShellSessions(syncedStates: unknown[], now = Date.now()): string[] {
  const tabIds = readSyncedTabIds(syncedStates);
  const ended: string[] = [];
  for (const [sessionKey, session] of ptySessionsMap) {
    if (session.sockets.size > 0) {
      session.missingSince = null;
      continue;
    }
    let reason: string | null = null;
    if (session.isCommand) {
      if (session.detachedAt !== null && now - session.detachedAt >= COMMAND_IDLE_MS) {
        reason = 'one-shot command unviewed for 30 min';
      }
    } else if (tabIds && !(session.sessionId && tabIds.has(session.sessionId))) {
      if (now - session.createdAt >= ORPHAN_GRACE_MS) {
        session.missingSince ??= now;
        if (now - session.missingSince >= ORPHAN_GRACE_MS) {
          reason = 'no synced tab shows it';
        }
      }
    } else {
      session.missingSince = null;
    }
    if (reason) {
      console.log(`[INFO] Ending orphaned terminal ${sessionKey}: ${reason}`);
      ptySessionsMap.delete(sessionKey);
      endPty(session);
      ended.push(sessionKey);
    }
  }
  return ended;
}

/**
 * Runs sweepOrphanedShellSessions every minute against the stored workspaces.
 * The timer is unref'd so it never keeps the process alive. Used by the
 * server entrypoint at startup.
 */
export function startShellSessionSweep(
  listWorkspaceStates: () => unknown[] = () => workspaceStateDb.listStates()
): NodeJS.Timeout {
  return setInterval(() => {
    try {
      sweepOrphanedShellSessions(listWorkspaceStates());
    } catch (error) {
      console.error('[ERROR] Terminal sweep failed:', error);
    }
  }, SWEEP_INTERVAL_MS).unref();
}

/** Flags every terminal-started Claude CLI gets; the account profiles in the client type the same ones. */
const CLAUDE_TERMINAL_FLAGS = '--allow-dangerously-skip-permissions';
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
// Only the prompt's own lines count as context: an agent CLI showing a diff
// or a file has "login"/"visit" a few lines above any URL in the code.
const AUTH_CONTEXT_LINES = 3;

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
  // Sign-in pages live on real hosts; `http://a/` or `http://web:8080/` in
  // code an agent prints is never one.
  if (!isPublicHostname(parsedUrl.hostname)) {
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
  const context = cleanOutput
    .slice(Math.max(0, anchor - AUTH_CONTEXT_WINDOW), anchor)
    .split(/\r?\n/)
    .slice(-AUTH_CONTEXT_LINES)
    .join('\n');
  return AUTH_CONTEXT_HINT_REGEX.test(context);
}

/** A dotted DNS name or an IP literal — not a single-label name like `a`. */
function isPublicHostname(hostname: string): boolean {
  return hostname.includes('.') || hostname.startsWith('[');
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

        // Only an explicit `forceRestart` (the client's first send of a one-shot
        // command, or Restart) respawns. Login commands used to respawn on every
        // init — and a reconnect re-sends it, so coming back from the browser
        // where the sign-in was approved killed the login waiting for it.
        // A respawn keeps the other devices' viewers: they see the new run.
        let carriedViewers: WebSocket[] = [];
        // Each carried viewer keeps its own size, so its `claim` can apply it.
        const carriedSizes = new Map<WebSocket, TerminalSize>();
        if (forceRestart) {
          const oldSession = ptySessionsMap.get(ptySessionKey);
          if (oldSession) {
            carriedViewers = [...oldSession.sockets].filter(
              (socket) => socket !== ws && socket.readyState === WebSocket.OPEN
            );
            for (const socket of carriedViewers) {
              const size = oldSession.sizes.get(socket);
              if (size) {
                carriedSizes.set(socket, size);
              }
            }
            ptySessionsMap.delete(ptySessionKey);
            endPty(oldSession);
          }
        }

        const existingSession = forceRestart ? null : ptySessionsMap.get(ptySessionKey);
        if (existingSession) {
          // Re-adding moves the socket to the end: it is now the most recent viewer.
          existingSession.sockets.delete(ws);
          existingSession.sockets.add(ws);
          existingSession.detachedAt = null;
          existingSession.sizes.set(ws, initSize);
          // The attaching socket takes charge (a reconnect's old socket may
          // linger half-dead), but only a lone viewer resizes: another device
          // opening the tab (possibly in the background, at the 80×24
          // placeholder) must not reflow the shell under the person typing in
          // it. The device in use takes it back with `claim` (focus, a click).
          existingSession.owner = ws;
          if (existingSession.sockets.size === 1) {
            applyViewerSize(existingSession, ws);
          }

          // A client still showing this stream gets only what it missed and
          // keeps its scrollback; any other one is repainted from the window.
          sendIfOpen(ws, { type: 'stream', id: existingSession.streamId });
          const resumeFrom = readResumeOffset(data, existingSession);
          if (resumeFrom === null) {
            sendReplayWindow(ws, existingSession, '\x1b[36m[Reconnected to existing session]\x1b[0m\r\n');
          } else {
            existingSession.sentEnds.set(ws, resumeFrom);
            deliverOutput(existingSession, ws);
          }
          return;
        }

        // The run this client shows ended while it was away: report the exit
        // instead of spawning the command again. Restart sends forceRestart.
        const exited = forceRestart ? undefined : exitedStreams.get(ptySessionKey);
        if (exited && typeof data.stream === 'string' && data.stream === exited.streamId) {
          sendIfOpen(ws, { type: 'stream', id: exited.streamId });
          sendIfOpen(ws, exitFrame(exited.exit));
          return;
        }
        exitedStreams.delete(ptySessionKey);

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

        const spawnOptions = {
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
        };
        // The lifecycle handlers compare against `spawnedPty` and this key: a
        // later init may respawn the terminal under the same key
        // (forceRestart) or move this socket to another key, and a stale
        // handler must neither write to nor delete the NEW entry.
        const sessionKey = ptySessionKey;
        const streamId = randomUUID();
        const createdAt = Date.now();
        const isCommand = !!commandSuffix || !sessionId;
        // With the PTY host daemon running the terminal survives a server
        // restart; tests inject spawnPty and always stay in-process.
        const hostClient = dependencies.spawnPty ? null : ptyHost;
        const spawnedPty: HostedPty = hostClient
          ? hostClient.spawn(streamId, shell, shellArgs, spawnOptions, {
              sessionKey,
              projectPath,
              sessionId,
              isCommand,
              createdAt,
            })
          : (dependencies.spawnPty ?? pty.spawn)(shell, shellArgs, spawnOptions);


        const viewerSizes = new Map<WebSocket, TerminalSize>();
        for (const socket of carriedViewers) {
          viewerSizes.set(socket, carriedSizes.get(socket) ?? initSize);
        }
        viewerSizes.set(ws, initSize);
        ptySessionsMap.set(sessionKey, {
          pty: spawnedPty,
          sockets: new Set([...carriedViewers, ws]),
          owner: ws,
          sizes: viewerSizes,
          size: initSize,
          buffer: [],
          bufferChars: 0,
          replayState: createTerminalReplayState(),
          streamId,
          outputEnd: 0,
          sentEnds: new Map([...carriedViewers, ws].map((socket) => [socket, 0])),
          catchUpTimers: new Map(),
          projectPath,
          sessionId,
          hosted: !!hostClient,
          isCommand,
          createdAt,
          detachedAt: null,
          missingSince: null,
        });

        wirePtySession(sessionKey, spawnedPty);


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
        const spawnedSession = ptySessionsMap.get(sessionKey)!;
        broadcastFrame(spawnedSession, { type: 'stream', id: spawnedSession.streamId });
        broadcastFrame(spawnedSession, { type: 'output', data: welcomeMsg });
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

      if (data.type === 'claim') {
        // The user looks at this device now (pane shown, app or window back
        // in front, a tap): it takes charge as typing does, so the shell is
        // not drawn for another device's screen until the first keystroke.
        const session = viewedSession();
        if (session) {
          session.owner = ws;
          applyViewerSize(session, ws);
        }
        return;
      }

      if (data.type === 'ping') {
        // The client checks a socket that may have died while it slept.
        sendIfOpen(ws, { type: 'pong' });
        return;
      }

      if (data.type === 'terminate') {
        // The tab was closed in the panel: end the shell for every device.
        const session = viewedSession();
        if (session && ptySessionKey) {
          ptySessionsMap.delete(ptySessionKey);
          endPty(session);
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
