import fsSync from 'node:fs';

import type { QuotaAccount, QuotaWindow, QuotaWindowKind } from '@/shared/types.js';

/**
 * Transport dependencies for the provider adapters.
 *
 * Every adapter reads credentials from the local machine and talks to a
 * provider API, so both the filesystem reads and the HTTP request are injected.
 * Tests supply fakes and stay off the network; production uses the defaults.
 */
export type QuotaProviderDependencies = {
  /** Absolute path to the user's home directory. */
  homeDirectory: string;
  /** Reads a UTF-8 text file, returning null when it is missing or unreadable. */
  readTextFile: (filePath: string) => string | null;
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

/** Minimal decoded HTTP response used by the adapters. */
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
    `${dependencies.homeDirectory}/.local/share/devin/credentials.toml`,
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
  const toWindow = (label: string, kind: QuotaWindowKind, remaining: number | null, reset: number | null) =>
    remaining === null ? null : window(label, kind, 100 - remaining, asIso(reset));

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
    `${dependencies.homeDirectory}/.local/share/opencode/auth.json`,
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

// ---------- Gemini (Antigravity) ----------

const AGY_CLIENT_ID = '1071006060591-tmhssin2h21lcre235vtolojh4g403ep.apps.googleusercontent.com';
const AGY_CLIENT_SECRET = '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';
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

/** Refreshes the Antigravity OAuth token and reads the quota summary. */
async function fetchGemini(dependencies: QuotaProviderDependencies): Promise<QuotaAccount> {
  const storeText = dependencies.readTextFile(
    `${dependencies.homeDirectory}/.config/opencode/antigravity-accounts.json`,
  );
  const store = storeText
    ? (JSON.parse(storeText) as {
        accounts?: Array<{
          enabled?: boolean;
          refreshToken?: string;
          projectId?: string;
          managedProjectId?: string;
          label?: string;
          email?: string;
          fingerprint?: { userAgent?: string };
        }>;
      })
    : null;
  const selected = (store?.accounts ?? []).find(
    (entry) => entry.enabled !== false && entry.refreshToken,
  );
  if (!selected) {
    throw new Error('no account in antigravity-accounts.json');
  }

  const tokenResponse = await dependencies.request('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: String(selected.refreshToken).split('|')[0],
      client_id: AGY_CLIENT_ID,
      client_secret: AGY_CLIENT_SECRET,
    }).toString(),
  });
  if (tokenResponse.status !== 200) {
    throw new Error(`token refresh HTTP ${tokenResponse.status}: ${tokenResponse.text.slice(0, 160)}`);
  }
  const accessToken = (JSON.parse(tokenResponse.text) as { access_token: string }).access_token;

  const userAgent = selected.fingerprint?.userAgent ?? AGY_USER_AGENT;
  const projectIds = [selected.managedProjectId, selected.projectId].filter(
    (value): value is string => Boolean(value),
  );

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

  return account(
    'gemini',
    'Gemini',
    `Gemini (${selected.label ?? selected.email ?? 'Antigravity'})`,
    selected.label ?? selected.email ?? '',
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

/** Resolves the CommandCode API key from env or the CLI auth stores. */
function resolveCommandCodeKey(dependencies: QuotaProviderDependencies): string | null {
  const fromEnv = process.env.COMMANDCODE_API_KEY?.trim();
  if (fromEnv) return fromEnv;

  const candidates: Array<[string, (value: Record<string, any>) => string | undefined]> = [
    ['.commandcode/auth.json', (value) => value.apiKey],
    ['.omp/auth.json', (value) => value.commandcode?.key],
    ['.pi/auth.json', (value) => value.commandcode?.key],
    ['.local/share/opencode/auth.json', (value) => value.commandcode?.key],
  ];
  for (const [relativePath, pick] of candidates) {
    const text = dependencies.readTextFile(`${dependencies.homeDirectory}/${relativePath}`);
    if (!text) continue;
    try {
      const picked = pick(JSON.parse(text));
      if (picked) return picked;
    } catch {
      // A malformed auth file is simply not a key source.
    }
  }
  return null;
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

/** Builds the provider adapters around injected transport dependencies. */
export function createQuotaProviders(overrides: Partial<QuotaProviderDependencies> = {}) {
  const dependencies: QuotaProviderDependencies = {
    homeDirectory: process.env.HOME ?? '',
    readTextFile: (filePath) => {
      try {
        return fsSync.readFileSync(filePath, 'utf8');
      } catch {
        return null;
      }
    },
    request: defaultRequest,
    ...overrides,
  };

  const adapters: Array<{
    provider: string;
    providerLabel: string;
    load: (deps: QuotaProviderDependencies) => Promise<QuotaAccount>;
  }> = [
    { provider: 'devin', providerLabel: 'Devin', load: fetchDevin },
    { provider: 'opencode', providerLabel: 'OpenCode', load: fetchOpenCode },
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
      return Promise.all(
        adapters.map(async (adapter) => {
          try {
            return await adapter.load(dependencies);
          } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            const shell = account(adapter.provider, adapter.providerLabel, adapter.providerLabel, '', []);
            return { ...shell, status: 'error' as const, quality: 'error' as const, syncError: message };
          }
        }),
      );
    },
  };
}

export type QuotaProviders = ReturnType<typeof createQuotaProviders>;
