import fsSync from 'node:fs';

import { antigravityCredentialEmail, readObjectRecord, readOptionalString } from '@/shared/index.js';
import type { QuotaAccount, QuotaWindow, QuotaWindowKind } from '@/shared/index.js';

/** Used by quota provider tests to inject transport and credential reads.
 * Transport dependencies for the provider adapters.
 *
 * Every adapter reads credentials from the local machine and talks to a
 * provider API, so both the filesystem reads and the HTTP request are injected.
 * Tests supply fakes and stay off the network; production uses the defaults.
 */
export type QuotaProviderDependencies = {
  /** Absolute path to the user's home directory. */
  homeDirectory: string;
  /** Environment the CLI would see; credential paths resolve through it. */
  env: Record<string, string | undefined>;
  /** Reads a UTF-8 text file, returning null when it is missing or unreadable. */
  readTextFile: (filePath: string) => string | null;
  /** Writes a UTF-8 text file; used to persist refreshed OAuth tokens. */
  writeTextFile?: (filePath: string, content: string) => void;
  /** Performs one HTTP request and returns the status plus decoded body. */
  request: (
    url: string,
    options?: {
      method?: string;
      headers?: Record<string, string>;
      body?: string | Buffer;
    },
  ) => Promise<QuotaHttpResponse>;
};

/** Used by quota provider tests to supply decoded HTTP responses to adapters. */
export type QuotaHttpResponse = {
  status: number;
  buffer: Buffer;
  text: string;
};

const FETCH_TIMEOUT_MS = 15_000;

/** Default HTTP implementation backed by Node's global fetch. */
async function defaultRequest(
  url: string,
  options: {
    method?: string;
    headers?: Record<string, string>;
    body?: string | Buffer;
  } = {},
): Promise<QuotaHttpResponse> {
  const response = await fetch(url, {
    method: options.method ?? 'GET',
    headers: options.headers,
    body: options.body as never,
    signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
  });
  const buffer = Buffer.from(await response.arrayBuffer());
  return { status: response.status, buffer, text: buffer.toString('utf8') };
}

/** Builds a QuotaWindow with the fields a provider adapter can know. */
function window(
  label: string,
  kind: QuotaWindowKind,
  percent: number,
  resetsAt: string | null,
  status = 'ok',
): QuotaWindow {
  const clamped = Math.max(0, Math.min(100, Math.round(percent)));
  return {
    label,
    kind,
    percent: clamped,
    remainingPercent: 100 - clamped,
    resetsAt,
    status,
    projectedExhaustionAt: null,
    etaSeconds: null,
    burnRatePerHour: null,
  };
}

/** Normalizes a set of windows into a live-quality account shell. */
function account(
  provider: string,
  providerLabel: string,
  plan: string,
  accountLabel: string,
  windows: QuotaWindow[],
): QuotaAccount {
  return {
    id: provider,
    accountId: null,
    provider,
    providerLabel,
    plan,
    accountLabel,
    status: windows.length > 0 ? 'active' : 'error',
    quality: 'live',
    lastSyncedAt: new Date().toISOString(),
    syncError: windows.length > 0 ? null : 'no quota data returned',
    windows,
    assignedAgents: [],
  };
}

// ---------- Native subscription agents ----------

/** HOME of the credential store; an env override beats the injected home dir. */
function credHome(dependencies: QuotaProviderDependencies): string {
  return dependencies.env.HOME || dependencies.homeDirectory;
}

/** Reads only the owning CLI's credential store; never borrows another agent's login. */
function readAuth(dependencies: QuotaProviderDependencies, filePath: string): Record<string, unknown> {
  const text = dependencies.readTextFile(filePath);
  return text ? readObjectRecord(JSON.parse(text)) ?? {} : {};
}

/** API-key billing is not subscription quota and must not look like a failed sync. */
function inactiveAccount(provider: string, label: string): QuotaAccount {
  return {
    ...account(provider, label, 'API billing', '', []),
    status: 'inactive',
    quality: 'unknown',
    syncError: null,
  };
}

/** Reads Claude Code's session and weekly subscription limits. */
async function fetchClaude(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const dir = dependencies.env.CLAUDE_CONFIG_DIR || `${dependencies.homeDirectory}/.claude`;
  const auth = readAuth(dependencies, `${dir}/.credentials.json`);
  const oauth = readObjectRecord(auth.claudeAiOauth);
  const token = readOptionalString(oauth?.accessToken);
  if (!token) {
    if (dependencies.env.ANTHROPIC_API_KEY) return inactiveAccount('claude', 'Claude Code');
    throw new Error('missing Claude Code OAuth token — run claude /login');
  }
  if (typeof oauth?.expiresAt === 'number' && oauth.expiresAt <= Date.now()) {
    throw new Error('Claude Code OAuth token expired — run claude /login');
  }
  const response = await dependencies.request('https://api.anthropic.com/api/oauth/usage', {
    headers: { Authorization: `Bearer ${token}`, 'anthropic-beta': 'oauth-2025-04-20' },
  });
  if (response.status < 200 || response.status >= 300) {
    throw new Error(`Claude Code usage HTTP ${response.status}`);
  }
  const data = readObjectRecord(JSON.parse(response.text)) ?? {};
  const windows: QuotaWindow[] = [];
  for (const [key, label, kind] of [
    ['five_hour', '5h', 'session'],
    ['seven_day', 'Weekly', 'weekly'],
    ['seven_day_sonnet', 'Sonnet · Weekly', 'weekly'],
    ['seven_day_opus', 'Opus · Weekly', 'weekly'],
  ] as const) {
    const usage = readObjectRecord(data[key]);
    if (typeof usage?.utilization === 'number' && Number.isFinite(usage.utilization)) {
      windows.push(window(label, kind, usage.utilization, readOptionalString(usage.resets_at) ?? null));
    }
  }
  const plan = readOptionalString(oauth?.subscriptionType);
  return account('claude', 'Claude Code', plan ? `Claude ${plan}` : 'Claude', '', windows);
}

/** Reads Codex's ChatGPT-backed subscription limits, without sending API keys to ChatGPT. */
async function fetchCodex(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const auth = readAuth(
    dependencies,
    `${dependencies.env.CODEX_HOME || `${dependencies.homeDirectory}/.codex`}/auth.json`,
  );
  const tokens = readObjectRecord(auth.tokens);
  const token = readOptionalString(tokens?.access_token);
  if (auth.auth_mode === 'apikey' || !token) {
    if (readOptionalString(auth.OPENAI_API_KEY) || auth.auth_mode === 'apikey') {
      return inactiveAccount('codex', 'Codex');
    }
    throw new Error('missing Codex ChatGPT OAuth token — run codex login');
  }
  const headers: Record<string, string> = { Authorization: `Bearer ${token}`, 'User-Agent': 'codex-cli' };
  const accountId = readOptionalString(tokens?.account_id);
  if (accountId) headers['ChatGPT-Account-Id'] = accountId;
  const response = await dependencies.request('https://chatgpt.com/backend-api/wham/usage', { headers });
  if (response.status < 200 || response.status >= 300) {
    throw new Error(`Codex usage HTTP ${response.status}`);
  }
  const data = readObjectRecord(JSON.parse(response.text)) ?? {};
  const limits = readObjectRecord(data.rate_limit);
  const windows: QuotaWindow[] = [];
  for (const key of ['primary_window', 'secondary_window']) {
    const usage = readObjectRecord(limits?.[key]);
    if (typeof usage?.used_percent !== 'number' || !Number.isFinite(usage.used_percent)) continue;
    const seconds = usage.limit_window_seconds;
    const kind: QuotaWindowKind = typeof seconds === 'number'
      ? seconds >= 604800 ? 'weekly' : seconds >= 86400 ? 'daily' : 'session'
      : key === 'primary_window' ? 'session' : 'weekly';
    const reset = typeof usage.reset_at === 'number' && Number.isFinite(usage.reset_at)
      ? new Date(usage.reset_at * 1000).toISOString() : null;
    windows.push(window(kindLabel(kind), kind, usage.used_percent, reset,
      usage.used_percent >= 100 ? 'exceeded' : 'ok'));
  }
  return account('codex', 'Codex', `ChatGPT ${readOptionalString(data.plan_type) ?? ''}`.trim(), '', windows);
}

// ---------- Devin / Windsurf (protobuf) ----------

function encodeVarint(value: number | bigint): Buffer {
  const bytes: number[] = [];
  let remaining = typeof value === 'bigint' ? value : BigInt(value);
  for (;;) {
    const byte = Number(remaining & 0x7fn);
    remaining >>= 7n;
    if (remaining) {
      bytes.push(byte | 0x80);
    } else {
      bytes.push(byte);
      return Buffer.from(bytes);
    }
  }
}

function fieldString(fieldNumber: number, value: string): Buffer {
  const body = Buffer.from(value, 'utf8');
  return Buffer.concat([
    encodeVarint((fieldNumber << 3) | 2),
    encodeVarint(body.length),
    body,
  ]);
}

function fieldVarint(fieldNumber: number, value: number): Buffer {
  return Buffer.concat([encodeVarint((fieldNumber << 3) | 0), encodeVarint(value)]);
}

function readVarint(buffer: Buffer, start: number): [bigint, number] {
  let shift = 0n;
  let result = 0n;
  let index = start;
  while (index < buffer.length) {
    const byte = BigInt(buffer[index]);
    index += 1;
    result |= (byte & 0x7fn) << shift;
    shift += 7n;
    if (!(byte & 0x80n)) {
      return [result, index];
    }
  }
  return [result, index];
}

type ProtoField = [number, number, Buffer | bigint];

function walkProto(buffer: Buffer): ProtoField[] {
  const fields: ProtoField[] = [];
  let index = 0;
  while (index < buffer.length) {
    const [tag, afterTag] = readVarint(buffer, index);
    index = afterTag;
    const fieldNumber = Number(tag >> 3n);
    const wireType = Number(tag & 7n);
    let value: Buffer | bigint;
    if (wireType === 0) {
      const [parsed, next] = readVarint(buffer, index);
      value = parsed;
      index = next;
    } else if (wireType === 2) {
      const [length, afterLength] = readVarint(buffer, index);
      index = afterLength;
      value = buffer.subarray(index, index + Number(length));
      index += Number(length);
    } else if (wireType === 5) {
      value = buffer.subarray(index, index + 4);
      index += 4;
    } else if (wireType === 1) {
      value = buffer.subarray(index, index + 8);
      index += 8;
    } else {
      break;
    }
    fields.push([fieldNumber, wireType, value]);
  }
  return fields;
}

function subMessage(fields: ProtoField[], fieldNumber: number): ProtoField[] {
  const match = fields.find(([number, wireType]) => number === fieldNumber && wireType === 2);
  return match && Buffer.isBuffer(match[2]) ? walkProto(match[2]) : [];
}

function varintField(fields: ProtoField[], fieldNumber: number): number | null {
  const match = fields.find(([number, wireType]) => number === fieldNumber && wireType === 0);
  return match ? Number(BigInt.asIntN(64, match[2] as bigint)) : null;
}

function stringField(fields: ProtoField[], fieldNumber: number): string | null {
  const match = fields.find(([number, wireType]) => number === fieldNumber && wireType === 2);
  return match && Buffer.isBuffer(match[2]) ? match[2].toString('utf8') : null;
}

function readTomlValue(text: string | null, key: string): string | null {
  if (!text) return null;
  const match = text.match(new RegExp(`${key}\\s*=\\s*"([^"]+)"`));
  return match ? match[1] : null;
}

/** Reads the Devin/Windsurf plan status through its protobuf endpoint. */
async function fetchDevin(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const credentials = dependencies.readTextFile(
    `${dependencies.env.XDG_DATA_HOME || `${dependencies.homeDirectory}/.local/share`}/devin/credentials.toml`,
  );
  const key = readTomlValue(credentials, 'windsurf_api_key');
  if (!key) {
    throw new Error('missing windsurf_api_key in credentials.toml');
  }

  const body = Buffer.concat([fieldString(1, key), fieldVarint(2, 1)]);
  const response = await dependencies.request(
    'https://windsurf.com/_backend/exa.seat_management_pb.SeatManagementService/GetPlanStatus',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/proto',
        'x-auth-token': key,
        'x-devin-session-token': key,
      },
      body,
    },
  );
  if (response.status < 200 || response.status >= 300) {
    throw new Error(`HTTP ${response.status}: ${response.text.slice(0, 160)}`);
  }

  const top = walkProto(response.buffer);
  const status = subMessage(top, 1);
  const planInfo = subMessage(status, 1);
  const plan = stringField(planInfo, 2) ?? 'Pro';
  const asIso = (seconds: number | null) =>
    seconds ? new Date(seconds * 1000).toISOString() : null;
  // Proto3 omits zero-valued scalars: a fully used window sends no `remaining`
  // field, so it must be read as 0, not dropped — the reset field is what
  // proves the window exists.
  const toWindow = (label: string, kind: QuotaWindowKind, remaining: number | null, reset: number | null) =>
    remaining === null && reset === null
      ? null
      : window(label, kind, 100 - (remaining ?? 0), asIso(reset));

  const windows = [
    toWindow('Daily', 'daily', varintField(status, 14), varintField(status, 17)),
    toWindow('Weekly', 'weekly', varintField(status, 15), varintField(status, 18)),
  ].filter((entry): entry is QuotaWindow => entry !== null);

  return account('devin', 'Devin', `Devin ${plan}`, '', windows);
}

// ---------- OpenCode ----------

/**
 * True when the endpoint rejects the key with 403 EntitlementError, which
 * means the account simply has no OpenCode Go plan — not a sync failure.
 */
function hasNoSubscription(response: QuotaHttpResponse): boolean {
  return response.status === 403 && /entitlementerror|subscription required/i.test(response.text);
}

/** Reads quota from the OpenCode Go usage endpoint. */
async function fetchOpenCode(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const authText = dependencies.readTextFile(
    `${dependencies.env.XDG_DATA_HOME || `${dependencies.homeDirectory}/.local/share`}/opencode/auth.json`,
  );
  const auth = authText ? (JSON.parse(authText) as Record<string, { key?: string }>) : null;
  const key = auth?.['opencode-go']?.key;
  if (!key) {
    throw new Error('missing opencode-go key in auth.json');
  }

  const response = await dependencies.request('https://opencode.ai/zen/go/v1/usage', {
    headers: { Authorization: `Bearer ${key}`, 'User-Agent': 'opencode/1.0' },
  });
  if (response.status < 200 || response.status >= 300) {
    if (hasNoSubscription(response)) {
      return {
        ...account('opencode', 'OpenCode', 'OpenCode Go', '', []),
        status: 'inactive',
        quality: 'unknown',
        syncError: null,
      };
    }
    throw new Error(`HTTP ${response.status}: ${response.text.slice(0, 160)}`);
  }

  const data = JSON.parse(response.text) as {
    usage?: Record<string, { status?: string; percent?: number; resetsAt?: string | null }>;
  };
  const kinds: Array<[string, QuotaWindowKind]> = [
    ['rolling', 'rolling'],
    ['weekly', 'weekly'],
    ['monthly', 'monthly'],
  ];
  const windows: QuotaWindow[] = [];
  for (const [field, kind] of kinds) {
    const usage = data.usage?.[field];
    if (usage && typeof usage.percent === 'number') {
      windows.push(
        window(kindLabel(kind), kind, usage.percent, usage.resetsAt ?? null, usage.status ?? 'ok'),
      );
    }
  }

  return account('opencode', 'OpenCode', 'OpenCode Go', '', windows);
}

// ---------- Cursor ----------

const CURSOR_USAGE_URL = 'https://cursor.com/api/usage-summary';
const CURSOR_USER_AGENT = 'cursor-agent/1.0';
const CURSOR_LOGIN_HINT = 'run cursor-agent login';

/** Decodes the WorkOS session JWT payload — the signature is not verified, only `sub`/`exp` are read. */
function cursorJwtPayload(accessToken: string): Record<string, unknown> | null {
  try {
    const payload = accessToken.split('.')[1];
    return payload
      ? (readObjectRecord(JSON.parse(Buffer.from(payload, 'base64url').toString('utf8'))) ?? null)
      : null;
  } catch {
    return null;
  }
}

/**
 * Reads Cursor's subscription usage from the cursor-agent session store.
 *
 * The dashboard endpoint expects the same `WorkosCursorSessionToken` cookie the
 * CLI synthesizes: `<userID>::<accessToken>` with `::` percent-encoded, where
 * `userID` is the JWT `sub` after the `|` separator. The CLI refreshes the
 * ~60-day access token itself, so an expired JWT or a 401/403 means re-login.
 */
async function fetchCursor(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const configDir = dependencies.env.XDG_CONFIG_HOME || `${credHome(dependencies)}/.config`;
  const auth = readAuth(dependencies, `${configDir}/cursor/auth.json`);
  const accessToken = readOptionalString(auth.accessToken);
  if (!accessToken) {
    if (dependencies.env.CURSOR_API_KEY) return inactiveAccount('cursor', 'Cursor');
    throw new Error(`missing Cursor session — ${CURSOR_LOGIN_HINT}`);
  }
  const jwt = cursorJwtPayload(accessToken);
  if (typeof jwt?.exp === 'number' && jwt.exp * 1000 <= Date.now()) {
    throw new Error(`Cursor session expired — ${CURSOR_LOGIN_HINT}`);
  }
  const userId = (readOptionalString(jwt?.sub) ?? '').split('|').pop() ?? '';
  const response = await dependencies.request(CURSOR_USAGE_URL, {
    headers: {
      Cookie: `WorkosCursorSessionToken=${userId}%3A%3A${accessToken}`,
      Accept: 'application/json',
      'User-Agent': CURSOR_USER_AGENT,
    },
  });
  if (response.status < 200 || response.status >= 300) {
    if (response.status === 401 || response.status === 403) {
      throw new Error(`Cursor session expired — ${CURSOR_LOGIN_HINT}`);
    }
    throw new Error(`Cursor usage HTTP ${response.status}`);
  }
  const data = readObjectRecord(JSON.parse(response.text)) ?? {};
  const cycleEnd = readOptionalString(data.billingCycleEnd) ?? null;

  const windows: QuotaWindow[] = [];
  const addUsage = (prefix: string, usage: Record<string, unknown> | null) => {
    const plan = readObjectRecord(usage?.plan);
    const percent = typeof plan?.totalPercentUsed === 'number' && Number.isFinite(plan.totalPercentUsed)
      ? plan.totalPercentUsed
      : null;
    if (percent !== null) {
      windows.push(window(`${prefix}Monthly`, 'monthly', percent, cycleEnd));
    }
    // On-demand spend is billed in cents against an optional hard limit.
    const onDemand = readObjectRecord(usage?.onDemand);
    if (typeof onDemand?.limit === 'number' && onDemand.limit > 0 && typeof onDemand?.used === 'number') {
      windows.push(window(
        `${prefix}On-demand`,
        'metered',
        (onDemand.used / onDemand.limit) * 100,
        cycleEnd,
        onDemand.used >= onDemand.limit ? 'exceeded' : 'ok',
      ));
    }
  };
  addUsage('', readObjectRecord(data.individualUsage) ?? null);
  addUsage('Team · ', readObjectRecord(data.teamUsage) ?? null);

  const membership = readOptionalString(data.membershipType);
  return account('cursor', 'Cursor', `Cursor ${membership ?? ''}`.trim(), '', windows);
}

// ---------- Gemini (Antigravity) ----------

const AGY_ENDPOINTS = [
  'https://daily-cloudcode-pa.googleapis.com',
  'https://cloudcode-pa.googleapis.com',
];
const AGY_USER_AGENT =
  'antigravity/cli/1.1.24 (aidev_client; os_type=linux; arch=amd64; cl=974782877; auth_method=consumer)';
const AGY_POOL_LABEL: Record<string, string> = {
  gemini: 'Gemini Models',
  'non-gemini': 'Claude and GPT models',
};
const AGY_OAUTH_TOKEN_URL = 'https://oauth2.googleapis.com/token';
const AGY_OAUTH_CLIENT_ID = '1071006060591-tmhssin2h21lcre235vtolojh4g403ep.apps.googleusercontent.com';
const AGY_OAUTH_CLIENT_SECRET = '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';

type AgyCredentials = {
  token?: { access_token?: string; refresh_token?: string; expiry?: string };
} & Record<string, unknown>;

/**
 * Exchanges the CLI's stored refresh token for a fresh access token and writes
 * the updated credentials back to the same file the `agy` CLI maintains, so the
 * next sweep and the CLI itself see fresh state. Throws the expired-token
 * message when Google rejects the grant — the user must re-login via `agy`.
 */
async function refreshAgyToken(
  dependencies: QuotaProviderDependencies,
  tokenPath: string,
  credentials: AgyCredentials | null,
): Promise<string> {
  const refreshToken = credentials?.token?.refresh_token;
  const expiredError = 'Antigravity CLI OAuth token expired — run `agy` to refresh it';
  if (!refreshToken) {
    throw new Error(expiredError);
  }
  const response = await dependencies.request(AGY_OAUTH_TOKEN_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: refreshToken,
      client_id: AGY_OAUTH_CLIENT_ID,
      client_secret: AGY_OAUTH_CLIENT_SECRET,
    }).toString(),
  });
  const payload = response.status >= 200 && response.status < 300
    ? (JSON.parse(response.text) as { access_token?: string; refresh_token?: string; expires_in?: number })
    : null;
  if (!payload?.access_token) {
    throw new Error(expiredError);
  }
  try {
    dependencies.writeTextFile?.(tokenPath, JSON.stringify({
      ...credentials,
      token: {
        ...credentials?.token,
        access_token: payload.access_token,
        refresh_token: payload.refresh_token ?? refreshToken,
        expiry: new Date(Date.now() + (payload.expires_in ?? 3600) * 1000).toISOString(),
      },
    }));
  } catch {
    // A read-only credential store still gets this sweep on the in-memory token.
  }
  return payload.access_token;
}

/** Reads quota using only the standalone Antigravity CLI's OAuth token. */
async function fetchGemini(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const tokenPath = `${credHome(dependencies)}/.gemini/antigravity-cli/antigravity-oauth-token`;
  const tokenText = dependencies.readTextFile(tokenPath);
  const credentials = tokenText ? (JSON.parse(tokenText) as AgyCredentials) : null;
  let accessToken = credentials?.token?.access_token;
  if (!accessToken && !credentials?.token?.refresh_token) {
    throw new Error('Missing Antigravity CLI OAuth token — run `agy` to sign in');
  }
  const expiry = credentials?.token?.expiry ? Date.parse(credentials.token.expiry) : Number.POSITIVE_INFINITY;
  if (!accessToken || expiry <= Date.now()) {
    accessToken = await refreshAgyToken(dependencies, tokenPath, credentials);
  }

  const userAgent = AGY_USER_AGENT;
  const projectIds: string[] = [];
  for (const endpoint of AGY_ENDPOINTS) {
    const response = await dependencies.request(`${endpoint}/v1internal:loadCodeAssist`, {
      method: 'POST',
      headers: {
        'User-Agent': userAgent,
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ metadata: { ideType: 'ANTIGRAVITY' } }),
    });
    if (response.status < 200 || response.status >= 300) continue;
    const data = JSON.parse(response.text) as {
      cloudaicompanionProject?: string | { id?: string };
    };
    const project = typeof data.cloudaicompanionProject === 'string'
      ? data.cloudaicompanionProject
      : data.cloudaicompanionProject?.id;
    if (project) {
      projectIds.push(project);
      break;
    }
  }

  let summary: {
    groups?: Array<{ buckets?: Array<{ bucketId?: string; window?: string; remainingFraction?: number; resetTime?: string }> }>;
  } | null = null;
  let lastError = 'retrieveUserQuotaSummary failed';

  for (let index = 0; index < projectIds.length && !summary; index += 1) {
    for (const endpoint of AGY_ENDPOINTS) {
      const response = await dependencies.request(
        `${endpoint}/v1internal:retrieveUserQuotaSummary`,
        {
          method: 'POST',
          headers: {
            'User-Agent': userAgent,
            Authorization: `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ project: projectIds[index] }),
        },
      );
      if (response.status >= 200 && response.status < 300) {
        summary = JSON.parse(response.text);
        break;
      }
      lastError = `HTTP ${response.status}: ${response.text.slice(0, 120)}`;
    }
  }
  if (!summary) {
    throw new Error(lastError);
  }

  const windows: QuotaWindow[] = [];
  for (const group of summary.groups ?? []) {
    for (const bucket of group.buckets ?? []) {
      const pool = bucket.bucketId?.startsWith('gemini-')
        ? 'gemini'
        : bucket.bucketId?.startsWith('3p-')
          ? 'non-gemini'
          : null;
      if (!pool || typeof bucket.remainingFraction !== 'number') continue;
      const kind: QuotaWindowKind = bucket.window === '5h' ? 'session' : 'weekly';
      const label = `${AGY_POOL_LABEL[pool]} · ${bucket.window ?? kind}`;
      windows.push(
        window(label, kind, (1 - bucket.remainingFraction) * 100, bucket.resetTime ?? null),
      );
    }
  }

  // The ambient sweep has no provider_accounts row to borrow a label from —
  // the id_token's Google email identifies which login produced these windows.
  return account(
    'gemini',
    'Gemini',
    'Gemini (Antigravity)',
    antigravityCredentialEmail(credentials ?? {}) ?? '',
    windows,
  );
}

// ---------- CommandCode ----------

const COMMANDCODE_PLAN_LABELS: Record<string, string> = {
  'individual-go': 'Go',
  'individual-goat': 'GOAT',
  'individual-pro': 'Pro',
  'individual-pro-v1': 'Pro',
  'individual-provider': 'Provider',
  'individual-max': 'Max',
  'individual-ultra': 'Ultra',
  'teams-pro': 'Teams Pro',
};

const COMMANDCODE_PLAN_CREDITS: Record<string, number> = {
  'individual-go': 10,
  'individual-goat': 70,
  'individual-pro': 80,
  'individual-pro-v1': 80,
  'individual-max': 150,
  'individual-ultra': 300,
  'teams-pro': 40,
};

/** Resolves the CommandCode API key from its environment or its own CLI auth store. */
function resolveCommandCodeKey(dependencies: QuotaProviderDependencies): string | null {
  const fromEnv = dependencies.env.COMMAND_CODE_API_KEY?.trim() || dependencies.env.COMMANDCODE_API_KEY?.trim();
  if (fromEnv) return fromEnv;

  const text = dependencies.readTextFile(`${credHome(dependencies)}/.commandcode/auth.json`);
  if (!text) return null;
  try {
    const auth = JSON.parse(text) as { apiKey?: unknown };
    return typeof auth.apiKey === 'string' ? auth.apiKey.trim() || null : null;
  } catch {
    return null;
  }
}

/** Reads CommandCode credit windows and the monthly plan cap. */
async function fetchCommandCode(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const key = resolveCommandCodeKey(dependencies);
  if (!key) {
    throw new Error('missing CommandCode API key');
  }
  const headers = { Authorization: `Bearer ${key}`, 'x-api-key': key };
  const [creditsResponse, subscriptionsResponse] = await Promise.all([
    dependencies.request('https://api.commandcode.ai/alpha/billing/credits', { headers }),
    dependencies
      .request('https://api.commandcode.ai/alpha/billing/subscriptions', { headers })
      .catch(() => null),
  ]);
  if (creditsResponse.status < 200 || creditsResponse.status >= 300) {
    throw new Error(`HTTP ${creditsResponse.status}: ${creditsResponse.text.slice(0, 160)}`);
  }

  const credits = JSON.parse(creditsResponse.text) as {
    windowLimits?: Record<string, { used?: number; cap?: number; exceeded?: boolean; resetAt?: number | string }>;
    credits?: { monthlyCredits?: number };
  };
  const subscriptions = subscriptionsResponse && subscriptionsResponse.status < 300
    ? (JSON.parse(subscriptionsResponse.text) as {
        data?: { planId?: string; currentPeriodEnd?: string };
      })
    : null;

  const windows: QuotaWindow[] = [];
  const addWindow = (label: string, kind: QuotaWindowKind, raw?: { used?: number; cap?: number; exceeded?: boolean; resetAt?: number | string }) => {
    if (!raw || typeof raw.cap !== 'number' || !raw.cap) return;
    const percent = ((Number(raw.used) || 0) / raw.cap) * 100;
    // resetAt may be an epoch number or an ISO string; Number() of an ISO
    // string is NaN and new Date(NaN).toISOString() throws RangeError, so
    // fall back to the raw string instead of degrading the whole account.
    const resetAtTimestamp = raw.resetAt ? Number(raw.resetAt) : NaN;
    const resetsAt = Number.isFinite(resetAtTimestamp)
      ? new Date(resetAtTimestamp).toISOString()
      : (typeof raw.resetAt === 'string' ? raw.resetAt : null);
    windows.push(window(label, kind, percent, resetsAt, raw.exceeded ? 'exceeded' : 'ok'));
  };
  addWindow(kindLabel('session'), 'session', credits.windowLimits?.fiveHour);
  addWindow(kindLabel('weekly'), 'weekly', credits.windowLimits?.weekly);

  const planId = subscriptions?.data?.planId ?? '';
  const monthlyCap = COMMANDCODE_PLAN_CREDITS[planId];
  const remaining = credits.credits?.monthlyCredits;
  if (monthlyCap && typeof remaining === 'number') {
    const used = Math.max(0, monthlyCap - remaining);
    windows.push(
      window(kindLabel('monthly'), 'monthly', (used / monthlyCap) * 100, subscriptions?.data?.currentPeriodEnd ?? null),
    );
  }

  const planLabel = COMMANDCODE_PLAN_LABELS[planId] ?? planId;
  return account('commandcode', 'CommandCode', `CommandCode ${planLabel}`.trim(), '', windows);
}

/** Canonical English fallback label for a window kind. */
function kindLabel(kind: QuotaWindowKind): string {
  switch (kind) {
    case 'session':
      return '5h';
    case 'daily':
      return 'Daily';
    case 'weekly':
      return 'Weekly';
    case 'monthly':
      return 'Monthly';
    case 'credits':
      return 'Credits';
    case 'metered':
      return 'Metered';
    case 'rolling':
      return 'Rolling';
  }
}

/** Used by quota.module and quota tests to build adapters with injectable transport. */
export function createQuotaProviders(
  overrides: Partial<QuotaProviderDependencies> = {},
  options: {
    listProviderAccounts?: () => Array<{
      id: string;
      provider: string;
      label: string;
      envOverrides: Record<string, string>;
    }>;
  } = {},
) {
  const dependencies: QuotaProviderDependencies = {
    homeDirectory: process.env.HOME ?? '',
    env: process.env,
    readTextFile: (filePath) => {
      try {
        return fsSync.readFileSync(filePath, 'utf8');
      } catch {
        return null;
      }
    },
    writeTextFile: (filePath, content) => {
      fsSync.writeFileSync(filePath, content, 'utf8');
    },
    request: defaultRequest,
    ...overrides,
  };

  const adapters: Array<{
    provider: string;
    providerLabel: string;
    load: (deps: QuotaProviderDependencies) => Promise<QuotaAccount>;
  }> = [
    { provider: 'claude', providerLabel: 'Claude Code', load: fetchClaude },
    { provider: 'codex', providerLabel: 'Codex', load: fetchCodex },
    { provider: 'devin', providerLabel: 'Devin', load: fetchDevin },
    { provider: 'opencode', providerLabel: 'OpenCode', load: fetchOpenCode },
    { provider: 'cursor', providerLabel: 'Cursor', load: fetchCursor },
    { provider: 'gemini', providerLabel: 'Gemini', load: fetchGemini },
    { provider: 'commandcode', providerLabel: 'CommandCode', load: fetchCommandCode },
  ];

  return {
    /**
     * Loads every provider in parallel.
     *
     * A failing provider never rejects the batch: it yields an account shell
     * with `status: 'error'`, no windows, and the failure text so the UI can
     * show what to fix.
     */
    async loadAll(): Promise<QuotaAccount[]> {
      const sweeps: Array<Promise<QuotaAccount>> = adapters.map(async (adapter) => {
        try {
          return await adapter.load(dependencies);
        } catch (error) {
          const message = error instanceof Error ? error.message : String(error);
          const shell = account(adapter.provider, adapter.providerLabel, adapter.providerLabel, '', []);
          return { ...shell, status: 'error' as const, quality: 'error' as const, syncError: message };
        }
      });

      // Each configured provider_accounts row gets its own sweep under its
      // credential environment, so two logins of one provider both appear.
      let rows: ReturnType<NonNullable<typeof options.listProviderAccounts>> = [];
      try {
        rows = options.listProviderAccounts?.() ?? [];
      } catch {
        rows = [];
      }
      for (const row of rows) {
        const key = row.provider === 'antigravity' ? 'gemini' : row.provider;
        const adapter = adapters.find((candidate) => candidate.provider === key);
        if (!adapter) continue;
        const accountDeps: QuotaProviderDependencies = {
          ...dependencies,
          env: { ...process.env, ...row.envOverrides },
        };
        sweeps.push((async () => {
          try {
            const loaded = await adapter.load(accountDeps);
            return { ...loaded, id: row.id, accountId: row.id, accountLabel: row.label };
          } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            const shell = account(adapter.provider, adapter.providerLabel, adapter.providerLabel, row.label, []);
            return {
              ...shell,
              id: row.id,
              accountId: row.id,
              status: 'error' as const,
              quality: 'error' as const,
              syncError: message,
            };
          }
        })());
      }

      return Promise.all(sweeps);
    },
  };
}

/** Used by quota.service and its tests as the provider-loading contract. */
export type QuotaProviders = ReturnType<typeof createQuotaProviders>;
