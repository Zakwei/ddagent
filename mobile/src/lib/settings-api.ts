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
};

export { get as settingsGet, send as settingsSend };
