import { api } from '~shared/utils/api';
import { readApiError } from './kanban';

export type ApiKeyItem = {
  id: string;
  key_name: string;
  api_key: string;
  created_at: string;
  last_used?: string | null;
  is_active: boolean;
};

export type CreatedApiKey = { id: string; keyName: string; apiKey: string; createdAt?: string };

export type GithubCredentialItem = {
  id: string;
  credential_name: string;
  description?: string | null;
  created_at: string;
  is_active: boolean;
};

export type NotificationPreferences = {
  channels: {
    inApp: boolean;
    webPush: boolean;
    desktop: boolean;
    sound: boolean;
    [key: string]: boolean;
  };
  events: { actionRequired: boolean; stop: boolean; error: boolean };
};

export type SttConfig = {
  configured: boolean;
  endpointUrl?: string;
  model?: string;
  hasApiKey?: boolean;
};

export type BrowserUseSettings = { enabled: boolean };
export type BrowserUseStatus = {
  enabled: boolean;
  available: boolean;
  playwrightInstalled: boolean;
  chromiumInstalled: boolean;
  installInProgress: boolean;
  message?: string;
};

export type ChangelogRelease = {
  tagName: string;
  name?: string;
  body: string;
  htmlUrl: string;
  publishedAt?: string;
};

/* --------------------------------------------------------------- agents */

export type AgentProvider = 'claude' | 'cursor' | 'codex' | 'opencode' | 'devin';

export type ProviderAuthStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error: string | null;
};

export type ProviderAccountItem = {
  id: string;
  provider: string;
  label: string;
  envOverrides: Record<string, string>;
  isDefault: boolean;
  createdAt: string;
};

export type McpTokenItem = {
  id: string;
  label: string;
  scope: 'read' | 'write';
  createdAt: string;
  lastUsedAt: string | null;
};

export type McpTransport = 'stdio' | 'http' | 'sse';
export type McpScope = 'user' | 'local' | 'project';

export type ProviderMcpServer = {
  provider: string;
  name: string;
  scope: McpScope;
  transport: McpTransport;
  command?: string;
  args?: string[];
  env?: Record<string, string>;
  cwd?: string;
  url?: string;
  headers?: Record<string, string>;
  envVars?: string[];
  bearerTokenEnvVar?: string;
  envHttpHeaders?: Record<string, string>;
  workspacePath?: string;
  projectName?: string;
  projectDisplayName?: string;
};

export type UpsertMcpServerPayload = {
  name: string;
  scope: McpScope;
  transport: McpTransport;
  workspacePath?: string;
  command?: string;
  args?: string[];
  env?: Record<string, string>;
  cwd?: string;
  url?: string;
  headers?: Record<string, string>;
  envVars?: string[];
  bearerTokenEnvVar?: string;
  envHttpHeaders?: Record<string, string>;
};

export type ProviderSkill = {
  provider: string;
  name: string;
  description?: string;
  command: string;
  scope: string;
  sourcePath?: string;
  pluginName?: string;
  projectDisplayName?: string;
  projectPath?: string;
};

export type CustomModelInput = { model: string; id: string };

export type CustomModelItem = {
  recordId?: number;
  value: string;
  label: string;
  description?: string;
  isCustom?: boolean;
};

export const AGENT_PROVIDERS: AgentProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'devin'];

export const MCP_SUPPORTED_SCOPES: Record<AgentProvider, McpScope[]> = {
  claude: ['user', 'local', 'project'],
  cursor: ['user', 'project'],
  codex: ['user', 'project'],
  opencode: ['user', 'project'],
  devin: ['user'],
};

export const MCP_SUPPORTED_TRANSPORTS: Record<AgentProvider, McpTransport[]> = {
  claude: ['stdio', 'http', 'sse'],
  cursor: ['stdio', 'http'],
  codex: ['stdio', 'http'],
  opencode: ['stdio', 'http'],
  devin: ['stdio', 'http', 'sse'],
};

export const MCP_SUPPORTS_WORKING_DIRECTORY: Record<AgentProvider, boolean> = {
  claude: false,
  cursor: false,
  codex: true,
  opencode: false,
  devin: false,
};

/** Release notes carry per-language sections marked with `<!-- lang:xx -->`. */
export function localizedNotes(body: string, language: string): string {
  const parts = body.split(/<!--\s*lang:([a-zA-Z-]+)\s*-->/g);
  if (parts.length < 3) return body.trim();
  const byLang: Record<string, string> = {};
  for (let i = 1; i + 1 < parts.length; i += 2) byLang[parts[i].toLowerCase()] = parts[i + 1].trim();
  const lang = language.toLowerCase();
  return byLang[lang] || byLang[lang.split('-')[0]] || byLang.en || body.trim();
}

async function json<T>(response: Response): Promise<T> {
  return (await response.json().catch(() => ({}))) as T;
}

async function get<T>(endpoint: string, fallback: string): Promise<T> {
  const response = await api.get(endpoint);
  const payload = await json<any>(response);
  if (!response.ok) throw new Error(readApiError(payload, fallback));
  return (payload?.data ?? payload) as T;
}

async function send<T>(method: 'POST' | 'PUT' | 'PATCH' | 'DELETE', endpoint: string, body?: unknown, fallback = 'Request failed'): Promise<T> {
  const response = method === 'DELETE'
    ? await api.delete(endpoint)
    : method === 'POST'
      ? await api.post(endpoint, body)
      : method === 'PUT'
        ? await api.put(endpoint, body)
        : await api.delete(endpoint, { method: 'PATCH', body: JSON.stringify(body) } as any);
  const payload = await json<any>(response);
  if (!response.ok || payload?.success === false) throw new Error(readApiError(payload, fallback));
  return (payload?.data ?? payload) as T;
}

export const settingsApi = {
  // Git identity
  getGitConfig: () => get<{ gitName?: string; gitEmail?: string }>('/user/git-config', 'Failed to load git config'),
  saveGitConfig: (gitName: string, gitEmail: string) =>
    send<unknown>('POST', '/user/git-config', { gitName, gitEmail }, 'Failed to save git config'),

  // API keys
  listApiKeys: () => get<{ apiKeys?: ApiKeyItem[] }>('/settings/api-keys', 'Failed to load API keys'),
  createApiKey: (keyName: string) => send<{ apiKey?: CreatedApiKey }>('POST', '/settings/api-keys', { keyName }, 'Failed to create API key'),
  deleteApiKey: (id: string) => send<unknown>('DELETE', `/settings/api-keys/${id}`, undefined, 'Failed to delete API key'),
  toggleApiKey: (id: string, isActive: boolean) =>
    send<unknown>('PATCH', `/settings/api-keys/${id}/toggle`, { isActive }, 'Failed to toggle API key'),

  // GitHub credentials
  listGithubCredentials: () =>
    get<{ credentials?: GithubCredentialItem[] }>('/settings/credentials?type=github_token', 'Failed to load credentials'),
  createGithubCredential: (credentialName: string, credentialValue: string, description: string) =>
    send<unknown>(
      'POST',
      '/settings/credentials',
      { credentialName, credentialType: 'github_token', credentialValue, description },
      'Failed to create credential',
    ),
  deleteGithubCredential: (id: string) =>
    send<unknown>('DELETE', `/settings/credentials/${id}`, undefined, 'Failed to delete credential'),
  toggleGithubCredential: (id: string, isActive: boolean) =>
    send<unknown>('PATCH', `/settings/credentials/${id}/toggle`, { isActive }, 'Failed to toggle credential'),

  // Speech-to-text
  getSttConfig: () => get<SttConfig>('/stt/config', 'Failed to load STT config'),
  saveSttConfig: (endpointUrl: string, apiKey: string, model: string) =>
    send<{ configured?: boolean }>('PUT', '/stt/config', { endpointUrl, ...(apiKey.trim() ? { apiKey } : {}), model }, 'Failed to save STT config'),

  // Notification preferences
  getNotificationPreferences: () => get<NotificationPreferences>('/settings/notification-preferences', 'Failed to load notifications'),
  saveNotificationPreferences: (prefs: NotificationPreferences) =>
    send<NotificationPreferences>('PUT', '/settings/notification-preferences', prefs, 'Failed to save notifications'),
  testPush: () => send<{ subscriptionCount: number; webPushConfigured: boolean }>('POST', '/settings/push/test', undefined, 'Push test failed'),

  // Messenger channels
  getMessengerConfig: () =>
    get<{ config: { telegram: { configured: boolean }; discord: { configured: boolean } } }>(
      '/notifications/channels/config',
      'Failed to load channels',
    ),
  getTelegramChats: () =>
    get<{ detected?: Array<{ chatId: string; title: string }>; paired?: Array<{ endpointId: string; label: string | null }> }>(
      '/notifications/channels/telegram/chats',
      'Failed to load chats',
    ),
  saveTelegramConfig: (botToken: string) =>
    send<unknown>('PUT', '/notifications/channels/telegram/config', { botToken }, 'Failed to save Telegram'),
  saveDiscordConfig: (webhookUrl: string) =>
    send<unknown>('PUT', '/notifications/channels/discord/config', { webhookUrl }, 'Failed to save Discord'),
  testChannel: (channel: string) =>
    send<unknown>('POST', `/notifications/channels/${channel}/test`, undefined, 'Channel test failed'),
  pairChat: (endpointId: string, label: string) =>
    send<unknown>('POST', '/notifications/endpoints/current', { channel: 'telegram', endpointId, label }, 'Failed to pair chat'),
  unpairChat: (endpointId: string) =>
    send<unknown>('DELETE', `/notifications/endpoints/telegram/${endpointId}`, undefined, 'Failed to unpair chat'),

  // Browser use
  getBrowserSettings: () => get<{ settings: BrowserUseSettings }>('/browser-use/settings', 'Failed to load browser settings'),
  saveBrowserSettings: (enabled: boolean) =>
    send<{ settings: BrowserUseSettings }>('PUT', '/browser-use/settings', { enabled }, 'Failed to save browser settings'),
  getBrowserStatus: () => get<BrowserUseStatus>('/browser-use/status', 'Failed to load browser status'),
  installBrowserRuntime: () => send<unknown>('POST', '/browser-use/runtime/install', undefined, 'Failed to install browser runtime'),

  // Quota config
  saveQuotaConfig: (body: unknown) => send<unknown>('PUT', '/quota/config', body, 'Failed to save quota config'),

  // About
  getLatestRelease: () => get<{ tagName?: string }>('/system/latest-release', 'Failed to load release'),
  getReleases: () => get<{ releases?: ChangelogRelease[] }>('/system/releases', 'Failed to load changelog'),
  restartServer: () => send<{ restarting?: boolean }>('POST', '/system/restart', undefined, 'Failed to restart server'),

  /* --------------------------------------------------------------- agents */

  getProviderAuthStatus: (provider: AgentProvider) =>
    get<{ authenticated?: boolean; email?: string | null; method?: string | null; error?: string | null }>(
      `/providers/${provider}/auth/status`,
      'Failed to load auth status',
    ),

  listProviderAccounts: (provider: AgentProvider) =>
    get<{ accounts?: ProviderAccountItem[] }>(`/provider-accounts?provider=${encodeURIComponent(provider)}`, 'Failed to load accounts'),
  createProviderAccount: (provider: AgentProvider, label: string) =>
    send<{ account?: ProviderAccountItem }>('POST', '/provider-accounts', { provider, label }, 'Failed to create account'),
  deleteProviderAccount: (id: string) =>
    send<unknown>('DELETE', `/provider-accounts/${id}`, undefined, 'Failed to delete account'),
  makeProviderAccountDefault: (id: string) =>
    send<{ account?: ProviderAccountItem }>('PATCH', `/provider-accounts/${id}`, { isDefault: true }, 'Failed to update account'),
  getProviderAccountUsage: (id: string) =>
    get<{ usage?: { totalTokens?: number; costUsd?: number | null } }>(`/provider-accounts/${id}/usage`, 'Failed to load usage'),

  listMcpServers: (provider: AgentProvider, scope: McpScope, workspacePath?: string) => {
    const params = new URLSearchParams({ scope });
    if (workspacePath) params.set('workspacePath', workspacePath);
    return get<{ servers?: ProviderMcpServer[] }>(`/providers/${provider}/mcp/servers?${params.toString()}`, 'Failed to load MCP servers');
  },
  createMcpServer: (provider: AgentProvider, body: UpsertMcpServerPayload) =>
    send<{ server?: ProviderMcpServer }>('POST', `/providers/${provider}/mcp/servers`, body, 'Failed to save MCP server'),
  deleteMcpServer: (provider: AgentProvider, name: string, scope: McpScope, workspacePath?: string) => {
    const params = new URLSearchParams({ scope });
    if (workspacePath) params.set('workspacePath', workspacePath);
    return send<{ removed?: boolean }>(
      'DELETE',
      `/providers/${provider}/mcp/servers/${encodeURIComponent(name)}?${params.toString()}`,
      undefined,
      'Failed to delete MCP server',
    );
  },
  createGlobalMcpServer: (body: UpsertMcpServerPayload) =>
    send<unknown>('POST', '/providers/mcp/servers/global', body, 'Failed to save global MCP server'),

  listMcpTokens: () => get<{ tokens?: McpTokenItem[] }>('/mcp/tokens', 'Failed to load MCP tokens'),
  createMcpToken: (label: string, scope: 'read' | 'write') =>
    send<{ token?: string; record?: McpTokenItem }>('POST', '/mcp/tokens', { label: label || 'mcp-client', scope }, 'Failed to create MCP token'),
  deleteMcpToken: (id: string) => send<unknown>('DELETE', `/mcp/tokens/${id}`, undefined, 'Failed to revoke MCP token'),

  listProviderSkills: (provider: AgentProvider, workspacePath?: string) => {
    const suffix = workspacePath ? `?workspacePath=${encodeURIComponent(workspacePath)}` : '';
    return get<{ skills?: ProviderSkill[] }>(`/providers/${provider}/skills${suffix}`, 'Failed to load skills');
  },
  createProviderSkill: (provider: AgentProvider, directoryName: string, content: string) =>
    send<{ skills?: ProviderSkill[] }>(
      'POST',
      `/providers/${provider}/skills`,
      { entries: [{ directoryName, content }] },
      'Failed to save skill',
    ),
  deleteProviderSkill: (provider: AgentProvider, directoryName: string) =>
    send<{ removed?: boolean }>('DELETE', `/providers/${provider}/skills/${encodeURIComponent(directoryName)}`, undefined, 'Failed to delete skill'),

  listCustomModels: (provider: AgentProvider, refresh = false) =>
    get<{ models?: { OPTIONS?: CustomModelItem[]; DEFAULT?: string } }>(
      `/providers/${provider}/models${refresh ? '?refresh=true' : ''}`,
      'Failed to load models',
    ),
  createCustomModel: (provider: AgentProvider, body: CustomModelInput) =>
    send<unknown>('POST', `/providers/${provider}/models`, body, 'Failed to create model'),
  updateCustomModel: (provider: AgentProvider, recordId: number, body: CustomModelInput) =>
    send<unknown>('PATCH', `/providers/${provider}/models/${recordId}`, body, 'Failed to update model'),
  deleteCustomModel: (provider: AgentProvider, recordId: number) =>
    send<unknown>('DELETE', `/providers/${provider}/models/${recordId}`, undefined, 'Failed to delete model'),
};

export { get as settingsGet, send as settingsSend };
