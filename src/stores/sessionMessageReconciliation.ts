import type { NormalizedMessage } from './useSessionStore';

const LOCAL_USER_DEDUPE_WINDOW_MS = 5 * 60 * 1000;
const LOCAL_USER_DEDUPE_CLOCK_SKEW_MS = 10_000;
const LOCAL_ATTACHMENT_ONLY_DEDUPE_WINDOW_MS = 30_000;
const REALTIME_USER_DEDUPE_WINDOW_MS = 3000;

type UserTurnFingerprint = {
  text: string;
  imageCount: number;
  fileCount: number;
};

function userTurnFingerprint(message: NormalizedMessage): UserTurnFingerprint | null {
  if (message.kind !== 'text' || message.role !== 'user') return null;

  const text = (message.content || '').trim();
  const imageCount = Array.isArray(message.images) ? message.images.length : 0;
  const fileCount = Array.isArray(message.files) ? message.files.length : 0;
  if (!text && imageCount === 0 && fileCount === 0) return null;

  return { text, imageCount, fileCount };
}

/**
 * Whether a candidate row (persisted or echoed) is the same turn as the local
 * optimistic one.
 *
 * Text identifies the turn: two rows carrying the same text inside the dedupe
 * window are the same send. Attachment counts are only decisive for
 * attachment-only turns — providers that persist or echo a turn without its
 * descriptors (Devin keeps pasted images out of the normalized user row, for
 * example) would otherwise never match, and the optimistic bubble would stay
 * on screen next to its persisted copy.
 */
function userTurnFingerprintsMatch(
  local: UserTurnFingerprint,
  server: UserTurnFingerprint,
): boolean {
  if (local.text !== server.text) {
    return false;
  }
  if (local.text.length > 0) {
    return true;
  }
  return local.imageCount === server.imageCount && local.fileCount === server.fileCount;
}

function readMessageTime(message: NormalizedMessage): number | null {
  const time = Date.parse(message.timestamp);
  return Number.isFinite(time) ? time : null;
}

/**
 * Server row precomputed once per exported call: the fingerprint and parsed
 * timestamp used by every candidate scan. Computing them per candidate turned
 * each dedupe pass into O(candidates × servers) trim/Date.parse work.
 */
type IndexedServerUserRow = {
  message: NormalizedMessage;
  fingerprint: UserTurnFingerprint | null;
  time: number | null;
};

function indexServerUserRows(serverMessages: NormalizedMessage[]): IndexedServerUserRow[] {
  return serverMessages.map((message) => ({
    message,
    fingerprint: userTurnFingerprint(message),
    time: readMessageTime(message),
  }));
}

function findServerEchoForLocalUser(
  localMessage: NormalizedMessage,
  serverRows: IndexedServerUserRow[],
  claimedServerIds: Set<string>,
): NormalizedMessage | null {
  const localFingerprint = userTurnFingerprint(localMessage);
  const localTime = readMessageTime(localMessage);
  if (!localFingerprint || localTime === null) {
    return null;
  }

  const dedupeWindow = localFingerprint.text
    ? LOCAL_USER_DEDUPE_WINDOW_MS
    : LOCAL_ATTACHMENT_ONLY_DEDUPE_WINDOW_MS;
  let closestMatch: NormalizedMessage | null = null;
  let closestTimeDifference = Number.POSITIVE_INFINITY;

  for (const serverRow of serverRows) {
    if (claimedServerIds.has(serverRow.message.id)) {
      continue;
    }

    const serverFingerprint = serverRow.fingerprint;
    if (!serverFingerprint || !userTurnFingerprintsMatch(localFingerprint, serverFingerprint)) {
      continue;
    }

    const serverTime = serverRow.time;
    if (
      serverTime === null
      || serverTime < localTime - LOCAL_USER_DEDUPE_CLOCK_SKEW_MS
      || serverTime - localTime > dedupeWindow
    ) {
      continue;
    }

    const timeDifference = Math.abs(serverTime - localTime);
    if (timeDifference < closestTimeDifference) {
      closestMatch = serverRow.message;
      closestTimeDifference = timeDifference;
    }
  }

  return closestMatch;
}

/**
 * Real-time (non-local) duplicate user turns, typically a history row that
 * arrived both over the websocket and in a persisted page refresh. Collapse
 * them within a short 3 s window so the same user bubble doesn't flash twice.
 * Intentional repeated sends minutes later are outside the window and stay.
 */
function findRealtimeUserDuplicate(
  realtimeMessage: NormalizedMessage,
  serverRows: IndexedServerUserRow[],
  claimedServerIds: Set<string>,
): NormalizedMessage | null {
  const localFingerprint = userTurnFingerprint(realtimeMessage);
  const localTime = readMessageTime(realtimeMessage);
  if (!localFingerprint || localTime === null) {
    return null;
  }

  let closestMatch: NormalizedMessage | null = null;
  let closestTimeDifference = Number.POSITIVE_INFINITY;

  for (const serverRow of serverRows) {
    if (claimedServerIds.has(serverRow.message.id)) {
      continue;
    }

    const serverFingerprint = serverRow.fingerprint;
    if (!serverFingerprint || !userTurnFingerprintsMatch(localFingerprint, serverFingerprint)) {
      continue;
    }

    const serverTime = serverRow.time;
    if (serverTime === null) {
      continue;
    }

    const timeDifference = Math.abs(serverTime - localTime);
    if (timeDifference <= REALTIME_USER_DEDUPE_WINDOW_MS && timeDifference < closestTimeDifference) {
      closestMatch = serverRow.message;
      closestTimeDifference = timeDifference;
    }
  }

  return closestMatch;
}

export function removeRealtimeUserDuplicateEchoes(
  serverMessages: NormalizedMessage[],
  realtimeMessages: NormalizedMessage[],
): NormalizedMessage[] {
  const claimedServerIds = new Set<string>();
  const serverRows = indexServerUserRows(serverMessages);

  return realtimeMessages.filter((message) => {
    if (message.id.startsWith('local_') || message.kind !== 'text' || message.role !== 'user') {
      return true;
    }

    const serverEcho = findRealtimeUserDuplicate(message, serverRows, claimedServerIds);
    if (!serverEcho) {
      return true;
    }

    claimedServerIds.add(serverEcho.id);
    return false;
  });
}

/**
 * Removes local optimistic user rows once a corresponding persisted turn is
 * available. Matches are one-to-one so repeated sends cannot claim one row.
 */
export function removeOptimisticUserEchoes(
  serverMessages: NormalizedMessage[],
  realtimeMessages: NormalizedMessage[],
): NormalizedMessage[] {
  const claimedServerIds = new Set<string>();
  const serverRows = indexServerUserRows(serverMessages);

  return realtimeMessages.filter((message) => {
    if (!message.id.startsWith('local_')) {
      return true;
    }

    const serverEcho = findServerEchoForLocalUser(message, serverRows, claimedServerIds);
    if (!serverEcho) {
      return true;
    }

    claimedServerIds.add(serverEcho.id);
    return false;
  });
}
