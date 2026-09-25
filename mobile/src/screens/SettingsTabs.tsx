import React from 'react';
import { ActivityIndicator, Alert, Linking, Modal, ScrollView, Switch, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { Bell, CalendarClock, ChevronDown, ChevronRight, Cloud, Play, Plus, RefreshCw, Star, Trash2, Users, X } from 'lucide-react-native';
import { useTranslation } from 'react-i18next';
import Constants from 'expo-constants';
import { Section, Field, Toggle, Btn, StatusLine, type SettingsT } from './settings/kit';
import { ActionSheet } from '../components/ActionSheet';
import type { ThemeColors } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { DISCORD_URL, DOCS_URL, GITHUB_REPO_URL, releaseRelation } from '../lib/about';
import {
  settingsApi,
  localizedNotes,
  type ApiKeyItem,
  type ChangelogRelease,
  type GithubCredentialItem,
  type NotificationPreferences,
  type Schedule,
  type ScheduleRun,
  type SttConfig,
} from '../lib/settings-api';
import { useQuotaConfig, type QuotaConfig } from '../lib/quota';
import { useTasksSettings } from '../contexts/TasksSettingsContext';
import { useUiPreferences } from '../lib/ui-preferences-store';
import {
  DEFAULT_CRON,
  SCHEDULE_PROVIDERS,
  formatScheduleTime,
  scheduleMetaLine,
  truncateSchedulePrompt,
} from '../lib/schedules';
import {
  isChannelEnabled,
  parseEndpoints,
  parseTelegramChats,
  toggleChannelIn,
  type PushEndpoint,
  type TelegramChats,
} from '../lib/notifications';
import { registerForPushNotifications } from '../lib/push';
import { playNotificationSound, setNotificationSoundEnabled } from '../lib/notification-sound';
import { api } from '~shared/utils/api';

export type TabCtx = { colors: ThemeColors; isDark: boolean; lang: string; t: SettingsT };

const APP_VERSION = (Constants.expoConfig?.version as string | undefined) ?? '0.1.0';

/* --------------------------------------------------------------------- git */

export function GitTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [name, setName] = React.useState('');
  const [email, setEmail] = React.useState('');
  const [loading, setLoading] = React.useState(true);
  const [saving, setSaving] = React.useState(false);
  const [status, setStatus] = React.useState<string | null>(null);

  React.useEffect(() => {
    settingsApi
      .getGitConfig()
      .then((d) => {
        setName(d.gitName ?? '');
        setEmail(d.gitEmail ?? '');
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  const save = async () => {
    setSaving(true);
    setStatus(null);
    try {
      await settingsApi.saveGitConfig(name, email);
      setStatus(`✓ ${t('git.status.success', 'Git identity saved')}`);
    } catch (err) {
      setStatus(err instanceof Error ? err.message : t('git.status.error', 'Failed to save'));
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <ActivityIndicator color={colors.primary} />;

  return (
    <Section title={t('mainTabs.git', 'Git')} colors={colors}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('git.description', 'Used for commits made by agents.')}</Text>
      <Field label={t('git.name.label', 'Name')} value={name} onChangeText={setName} colors={colors} help={t('git.name.help', '')} />
      <Field label={t('git.email.label', 'Email')} value={email} onChangeText={setEmail} colors={colors} keyboardType="email-address" help={t('git.email.help', '')} />
      <StatusLine status={status} colors={colors} />
      <Btn label={saving ? t('git.actions.saving', 'Saving…') : t('git.actions.save', 'Save')} onPress={save} colors={colors} disabled={saving || !name || !email} />
    </Section>
  );
}

/* ------------------------------------------------------------------- tasks */

export function WorkspacesTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [projects, setProjects] = React.useState<{ id: string; displayName?: string; path?: string }[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState<string | null>(null);
  const [showCreate, setShowCreate] = React.useState(false);
  const [newPath, setNewPath] = React.useState('');
  const [newName, setNewName] = React.useState('');
  const [busy, setBusy] = React.useState(false);
  const [pendingDelete, setPendingDelete] = React.useState<{ id: string; label: string } | null>(null);

  const load = React.useCallback(async () => {
    try {
      const res = await api.projects();
      if (res.ok) {
        const data = await res.json();
        const raw: any[] = Array.isArray(data) ? data : data?.data?.projects ?? data?.projects ?? [];
        setProjects(raw.map((p) => ({ id: p.id ?? p.projectId, displayName: p.displayName, path: p.path ?? p.fullPath })));
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setLoading(false);
    }
  }, []);

  React.useEffect(() => { void load(); }, [load]);

  const create = async () => {
    if (!newPath.trim()) return;
    setBusy(true);
    setError(null);
    try {
      const res = await api.createProject({ path: newPath.trim(), displayName: newName.trim() || undefined });
      if (!res.ok) {
        const payload = await res.json().catch(() => null);
        throw new Error(payload?.error || t('workspaces.deleteFailed', 'Failed to add workspace.'));
      }
      setShowCreate(false);
      setNewPath('');
      setNewName('');
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  };

  const remove = async (id: string) => {
    setPendingDelete(null);
    setBusy(true);
    setError(null);
    try {
      const res = await api.deleteProject(id);
      if (!res.ok) {
        const payload = await res.json().catch(() => null);
        throw new Error(payload?.error || t('workspaces.deleteFailed', 'Failed to remove workspace.'));
      }
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  };

  if (loading) return <ActivityIndicator color={colors.primary} />;

  return (
    <Section title={t('workspaces.title', 'Workspaces')} colors={colors}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
        {t('workspaces.description', 'Workspaces are directories ddagent can chat, run code, and browse inside.')}
      </Text>
      {error ? <Text style={{ color: colors.destructive, fontSize: 12 }}>{error}</Text> : null}
      {showCreate ? (
        <View style={{ gap: 8 }}>
          <Field label={t('workspaces.pathLabel', 'Path')} value={newPath} onChangeText={setNewPath} placeholder="/home/user/project" colors={colors} />
          <Field label={t('workspaces.nameLabel', 'Name')} value={newName} onChangeText={setNewName} placeholder={t('workspaces.namePlaceholder', 'Optional')} colors={colors} />
          <View style={{ flexDirection: 'row', gap: 8 }}>
            <Btn label={busy ? t('workspaces.saving', 'Adding…') : t('workspaces.create', 'Add workspace')} onPress={create} colors={colors} disabled={busy} />
            <Btn label={t('workspaces.cancel', 'Cancel')} onPress={() => setShowCreate(false)} colors={colors} variant="outline" />
          </View>
        </View>
      ) : (
        <Btn
          label={t('workspaces.create', 'Add workspace')}
          onPress={() => setShowCreate(true)}
          colors={colors}
          variant="outline"
          icon={<Plus size={16} color={colors.foreground} />}
        />
      )}
      {projects.map((p) => (
        <View key={p.id} style={{ flexDirection: 'row', alignItems: 'center', gap: 10, borderTopWidth: 1, borderTopColor: colors.border, paddingTop: 10 }}>
          <View style={{ flex: 1 }}>
            <Text style={{ color: colors.foreground, fontSize: 14 }}>{p.displayName || p.id}</Text>
            {p.path ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>{p.path}</Text> : null}
          </View>
          <TouchableOpacity onPress={() => setPendingDelete({ id: p.id, label: p.displayName || p.id })} disabled={busy}>
            <Trash2 size={18} color={colors.destructive} />
          </TouchableOpacity>
        </View>
      ))}
      <ActionSheet
        visible={pendingDelete !== null}
        title={t('workspaces.deleteTitle', 'Remove workspace')}
        items={[
          { label: `${t('workspaces.remove', 'Remove workspace')} — ${pendingDelete?.label ?? ''}`, destructive: true, onPress: () => pendingDelete && void remove(pendingDelete.id) },
          { label: t('workspaces.cancel', 'Cancel'), onPress: () => setPendingDelete(null) },
        ]}
        onClose={() => setPendingDelete(null)}
      />
    </Section>
  );
}

export function TasksTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const { tasksEnabled, setTasksEnabled, isTaskMasterInstalled, isCheckingInstallation } = useTasksSettings();

  if (isCheckingInstallation) return <ActivityIndicator color={colors.primary} />;

  return (
    <Section title={t('mainTabs.tasks', 'Tasks')} colors={colors}>
      {!isTaskMasterInstalled ? (
        <View style={{ backgroundColor: 'rgba(249,115,22,0.12)', borderRadius: 10, padding: 12, gap: 6 }}>
          <Text style={{ color: '#f59e0b', fontWeight: '600' }}>{t('tasks.notInstalled.title', 'TaskMaster not installed')}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('tasks.notInstalled.description', 'Install TaskMaster to enable the Tasks board.')}</Text>
        </View>
      ) : (
        <Toggle
          label={t('tasks.settings.enableLabel', 'Enable TaskMaster')}
          description={t('tasks.settings.enableDescription', 'Show the Tasks tab and board.')}
          value={tasksEnabled}
          onValueChange={setTasksEnabled}
          colors={colors}
        />
      )}
    </Section>
  );
}

/* --------------------------------------------------------------------- api */

export function ApiTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [keys, setKeys] = React.useState<ApiKeyItem[]>([]);
  const [creds, setCreds] = React.useState<GithubCredentialItem[]>([]);
  const [newKeyName, setNewKeyName] = React.useState('');
  const [created, setCreated] = React.useState<string | null>(null);
  const [busy, setBusy] = React.useState(false);

  const [stt, setStt] = React.useState<SttConfig | null>(null);
  const [sttUrl, setSttUrl] = React.useState('');
  const [sttKey, setSttKey] = React.useState('');
  const [sttModel, setSttModel] = React.useState('');
  const [sttStatus, setSttStatus] = React.useState<string | null>(null);

  const [ghName, setGhName] = React.useState('');
  const [ghToken, setGhToken] = React.useState('');
  const [ghDesc, setGhDesc] = React.useState('');
  const [showGhForm, setShowGhForm] = React.useState(false);

  const load = React.useCallback(() => {
    settingsApi.listApiKeys().then((d) => setKeys(d.apiKeys ?? [])).catch(() => {});
    settingsApi.listGithubCredentials().then((d) => setCreds(d.credentials ?? [])).catch(() => {});
    settingsApi
      .getSttConfig()
      .then((d) => {
        setStt(d);
        setSttUrl(d.endpointUrl ?? '');
        setSttModel(d.model ?? '');
      })
      .catch(() => setStt(null));
  }, []);

  React.useEffect(() => load(), [load]);

  const createKey = async () => {
    setBusy(true);
    try {
      const d = await settingsApi.createApiKey(newKeyName.trim());
      setCreated(d.apiKey?.apiKey ?? null);
      setNewKeyName('');
      load();
    } catch (err) {
      Alert.alert('API key', err instanceof Error ? err.message : 'Failed');
    } finally {
      setBusy(false);
    }
  };

  const saveStt = async () => {
    try {
      await settingsApi.saveSttConfig(sttUrl, sttKey, sttModel);
      setSttKey('');
      setSttStatus(`✓ ${t('stt.saved', 'Saved')}`);
      load();
    } catch (err) {
      setSttStatus(err instanceof Error ? err.message : 'Failed');
    }
  };

  const addGh = async () => {
    try {
      await settingsApi.createGithubCredential(ghName.trim(), ghToken.trim(), ghDesc.trim());
      setGhName('');
      setGhToken('');
      setGhDesc('');
      setShowGhForm(false);
      load();
    } catch (err) {
      Alert.alert('GitHub credential', err instanceof Error ? err.message : 'Failed');
    }
  };

  return (
    <>
      <Section title={t('apiKeys.title', 'API keys')} colors={colors}>
        {created ? (
          <View style={{ backgroundColor: 'rgba(16,185,129,0.12)', borderRadius: 8, padding: 10, gap: 4 }}>
            <Text style={{ color: colors.foreground, fontSize: 12 }}>{t('apiKeys.form.createButton', 'Create API Key')}</Text>
            <Text selectable style={{ color: colors.foreground, fontFamily: 'monospace', fontSize: 12 }}>{created}</Text>
          </View>
        ) : null}
        {keys.map((k) => (
          <View key={k.id} style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
            <View style={{ flex: 1 }}>
              <Text style={{ color: colors.foreground, fontSize: 14 }}>{k.key_name}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{k.api_key}</Text>
            </View>
            <Toggle label="" value={k.is_active} onValueChange={(v) => settingsApi.toggleApiKey(k.id, v).then(load).catch(() => {})} colors={colors} />
            <TouchableOpacity onPress={() => settingsApi.deleteApiKey(k.id).then(load).catch(() => {})} hitSlop={8}>
              <Trash2 size={16} color={colors.destructive} />
            </TouchableOpacity>
          </View>
        ))}
        <Field label={t('apiKeys.form.placeholder', 'Key name')} value={newKeyName} onChangeText={setNewKeyName} colors={colors} />
        <Btn label={t('apiKeys.newButton', 'New API Key')} onPress={createKey} colors={colors} disabled={busy || !newKeyName.trim()} icon={<Plus size={16} color={colors.primaryForeground} />} />
      </Section>

      <Section title={t('stt.title', 'Voice input (speech-to-text)')} colors={colors}>
        <Field label={t('stt.endpoint', 'Endpoint URL')} value={sttUrl} onChangeText={setSttUrl} colors={colors} />
        <Field label={t('stt.apiKey', 'API key')} value={sttKey} onChangeText={setSttKey} colors={colors} secureTextEntry help={stt?.hasApiKey ? '••••••••' : undefined} />
        <Field label={t('stt.model', 'Model')} value={sttModel} onChangeText={setSttModel} colors={colors} />
        <StatusLine status={sttStatus} colors={colors} />
        <Btn label={t('stt.save', 'Save')} onPress={saveStt} colors={colors} />
      </Section>

      <Section title={t('apiKeys.github.title', 'GitHub credentials')} colors={colors}>
        {creds.map((c) => (
          <View key={c.id} style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
            <View style={{ flex: 1 }}>
              <Text style={{ color: colors.foreground, fontSize: 14 }}>{c.credential_name}</Text>
              {c.description ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{c.description}</Text> : null}
            </View>
            <Toggle label="" value={c.is_active} onValueChange={(v) => settingsApi.toggleGithubCredential(c.id, v).then(load).catch(() => {})} colors={colors} />
            <TouchableOpacity onPress={() => settingsApi.deleteGithubCredential(c.id).then(load).catch(() => {})} hitSlop={8}>
              <Trash2 size={16} color={colors.destructive} />
            </TouchableOpacity>
          </View>
        ))}
        {showGhForm ? (
          <>
            <Field label={t('apiKeys.github.form.namePlaceholder', 'Name')} value={ghName} onChangeText={setGhName} colors={colors} />
            <Field label={t('apiKeys.github.form.tokenPlaceholder', 'Token')} value={ghToken} onChangeText={setGhToken} colors={colors} secureTextEntry />
            <Field label={t('apiKeys.github.form.descriptionPlaceholder', 'Description')} value={ghDesc} onChangeText={setGhDesc} colors={colors} />
            <View style={{ flexDirection: 'row', gap: 8 }}>
              <Btn label={t('apiKeys.github.form.addButton', 'Add')} onPress={addGh} colors={colors} disabled={!ghName.trim() || !ghToken.trim()} />
              <Btn label={t('apiKeys.github.form.cancelButton', 'Cancel')} onPress={() => setShowGhForm(false)} colors={colors} variant="outline" />
            </View>
          </>
        ) : (
          <Btn label={t('apiKeys.github.addButton', 'Add credential')} onPress={() => setShowGhForm(true)} colors={colors} variant="outline" icon={<Plus size={16} color={colors.foreground} />} />
        )}
      </Section>
    </>
  );
}

/* ----------------------------------------------------------- notifications */

export function NotificationsTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [prefs, setPrefs] = React.useState<NotificationPreferences | null>(null);
  const [status, setStatus] = React.useState<string | null>(null);
  const [telegram, setTelegram] = React.useState<{ configured: boolean }>({ configured: false });
  const [discord, setDiscord] = React.useState<{ configured: boolean }>({ configured: false });
  const [telegramToken, setTelegramToken] = React.useState('');
  const [discordUrl, setDiscordUrl] = React.useState('');
  const [endpoints, setEndpoints] = React.useState<PushEndpoint[]>([]);
  const [chats, setChats] = React.useState<TelegramChats>({ detected: [], paired: [] });
  const [devicesOpen, setDevicesOpen] = React.useState(false);
  const [busy, setBusy] = React.useState<string | null>(null);

  const load = React.useCallback(() => {
    settingsApi.getNotificationPreferences().then(setPrefs).catch(() => {});
    settingsApi
      .getMessengerConfig()
      .then((d) => {
        setTelegram(d.config.telegram);
        setDiscord(d.config.discord);
      })
      .catch(() => {});
    settingsApi
      .getEndpoints('fcm')
      .then((d) => setEndpoints(parseEndpoints(d)))
      .catch(() => {});
    settingsApi
      .getTelegramChats()
      .then((d) => setChats(parseTelegramChats(d)))
      .catch(() => {});
  }, []);

  React.useEffect(() => load(), [load]);

  const patch = (next: NotificationPreferences) => {
    setPrefs(next);
    settingsApi.saveNotificationPreferences(next).catch(() => {});
    void setNotificationSoundEnabled(next.channels.sound);
  };

  // Persists a single communication-channel toggle (telegram / discord / fcm)
  // alongside the shared preferences, mirroring the web toggleChannel.
  const setChannel = (channel: string, enabled: boolean) => {
    if (!prefs) return;
    patch(toggleChannelIn(prefs, channel, enabled));
  };

  const registerDevice = async () => {
    setBusy('register');
    try {
      await registerForPushNotifications();
      await settingsApi.testPush();
      setDevicesOpen(true);
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    } finally {
      setBusy(null);
    }
  };

  const testPush = async () => {
    try {
      const d = await settingsApi.testPush();
      setStatus(
        d.subscriptionCount > 0
          ? `✓ ${t('notifications.webPush.testSuccess', 'Sent.')}`
          : t('notifications.webPush.testNoSubscription', 'No device is subscribed.'),
      );
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    }
  };

  const saveTelegram = async () => {
    setBusy('tg-save');
    try {
      await settingsApi.saveTelegramConfig(telegramToken);
      setTelegramToken('');
      load();
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    } finally {
      setBusy(null);
    }
  };

  const saveDiscord = async () => {
    setBusy('dc-save');
    try {
      await settingsApi.saveDiscordConfig(discordUrl);
      setDiscordUrl('');
      load();
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    } finally {
      setBusy(null);
    }
  };

  const pairChat = async (chat: { chatId: string; title: string }) => {
    setBusy(`pair-${chat.chatId}`);
    try {
      await settingsApi.pairChat(chat.chatId, chat.title);
      load();
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    } finally {
      setBusy(null);
    }
  };

  const unpairChat = async (endpointId: string) => {
    setBusy(`unpair-${endpointId}`);
    try {
      await settingsApi.unpairChat(endpointId);
      load();
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    } finally {
      setBusy(null);
    }
  };

  const deleteDevice = async (endpointId: string) => {
    try {
      await settingsApi.deleteEndpoint('fcm', endpointId);
      setEndpoints((prev) => prev.filter((e) => e.endpointId !== endpointId));
    } catch (err) {
      setStatus(err instanceof Error ? err.message : 'Failed');
    }
  };

  if (!prefs) return <ActivityIndicator color={colors.primary} />;

  const unpaired = chats.detected.filter((c) => !chats.paired.some((p) => p.endpointId === c.chatId));

  return (
    <>
      <Section title={t('title', 'Settings')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('notifications.description', 'Control which notification events you receive.')}</Text>
        <Toggle
          label={t('notifications.channels.inApp', 'In-app notifications')}
          value={prefs.channels.inApp}
          onValueChange={(v) => patch({ ...prefs, channels: { ...prefs.channels, inApp: v } })}
          colors={colors}
        />
        <Toggle
          label={t('notifications.sound.title', 'Sound')}
          description={t('notifications.sound.description', 'Play a short tone when a run finishes.')}
          value={prefs.channels.sound}
          onValueChange={(v) => patch({ ...prefs, channels: { ...prefs.channels, sound: v } })}
          colors={colors}
        />
        <Btn label={t('notifications.sound.test', 'Test sound')} onPress={() => void playNotificationSound(true)} colors={colors} variant="outline" icon={<Bell size={14} color={colors.foreground} />} />
      </Section>

      <Section title={t('notifications.webPush.title', 'Push devices')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {t('notifications.messaging.description', 'Approve or deny agent permission requests from Telegram, and get run notifications on Discord.')}
        </Text>
        <Btn
          label={t('notifications.webPush.enable', 'Enable notifications')}
          onPress={() => void registerDevice()}
          colors={colors}
          icon={<Bell size={14} color={colors.primaryForeground} />}
        />
        <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
          <Btn label={t('notifications.webPush.test', 'Send test notification')} onPress={testPush} colors={colors} variant="outline" icon={<RefreshCw size={14} color={colors.foreground} />} />
          {endpoints.length > 0 ? (
            <TouchableOpacity onPress={() => setDevicesOpen(true)}>
              <Text style={{ color: colors.primary, fontSize: 12 }}>{endpoints.length} device(s)</Text>
            </TouchableOpacity>
          ) : null}
        </View>
        <StatusLine status={status} colors={colors} />
      </Section>

      <Section title={t('notifications.events.title', 'Event Types')} colors={colors}>
        {(['actionRequired', 'stop', 'error'] as const).map((key) => (
          <Toggle
            key={key}
            label={t(`notifications.events.${key}`, key)}
            value={prefs.events[key]}
            onValueChange={(v) => patch({ ...prefs, events: { ...prefs.events, [key]: v } })}
            colors={colors}
          />
        ))}
      </Section>

      <Section title={t('notifications.messaging.title', 'Messenger approvals')} colors={colors}>
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
          <Text style={{ color: colors.foreground, fontSize: 14 }}>Telegram {telegram.configured ? '✓' : ''}</Text>
          <Switch value={isChannelEnabled(prefs, 'telegram')} onValueChange={(v) => setChannel('telegram', v)} />
        </View>
        <Field label={t('notifications.messaging.telegramToken', 'Bot token')} value={telegramToken} onChangeText={setTelegramToken} colors={colors} secureTextEntry help={telegram.configured ? 'configured' : undefined} />
        <View style={{ flexDirection: 'row', gap: 8 }}>
          <Btn label={t('notifications.messaging.save', 'Save')} onPress={() => void saveTelegram()} colors={colors} disabled={!telegramToken.trim() || busy === 'tg-save'} />
          <Btn label={t('notifications.messaging.test', 'Test')} onPress={() => settingsApi.testChannel('telegram').catch(() => {})} colors={colors} variant="outline" disabled={!telegram.configured || chats.paired.length === 0} />
        </View>
        {telegram.configured ? (
          <View style={{ gap: 6 }}>
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('notifications.messaging.telegramHint', 'Send any message to your bot, then pair the chat below.')}</Text>
            {chats.paired.map((chat) => (
              <View key={chat.endpointId} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderColor: colors.border, borderWidth: 1, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 6 }}>
                <Text style={{ color: colors.foreground, fontSize: 12, flexShrink: 1 }} numberOfLines={1}>{chat.label || chat.endpointId} <Text style={{ color: colors.mutedForeground }}>{chat.endpointId}</Text></Text>
                <TouchableOpacity onPress={() => void unpairChat(chat.endpointId)} disabled={busy === `unpair-${chat.endpointId}`}>
                  <Trash2 size={14} color={colors.destructive} />
                </TouchableOpacity>
              </View>
            ))}
            {unpaired.map((chat) => (
              <View key={chat.chatId} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderColor: colors.border, borderStyle: 'dashed', borderWidth: 1, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 6 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 12, flexShrink: 1 }} numberOfLines={1}>{chat.title} <Text style={{ fontSize: 11 }}>{chat.chatId}</Text></Text>
                <TouchableOpacity onPress={() => void pairChat(chat)} disabled={busy === `pair-${chat.chatId}`}>
                  <Text style={{ color: colors.primary, fontSize: 12 }}>{t('notifications.messaging.pair', 'Pair')}</Text>
                </TouchableOpacity>
              </View>
            ))}
            {chats.paired.length === 0 && unpaired.length === 0 ? (
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('notifications.messaging.telegramHint', 'Send any message to your bot, then pair the chat below.')}</Text>
            ) : null}
          </View>
        ) : null}

        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: 8 }}>
          <Text style={{ color: colors.foreground, fontSize: 14 }}>Discord {discord.configured ? '✓' : ''}</Text>
          <Switch value={isChannelEnabled(prefs, 'discord')} onValueChange={(v) => setChannel('discord', v)} />
        </View>
        <Field label={t('notifications.messaging.discordWebhook', 'Discord webhook URL')} value={discordUrl} onChangeText={setDiscordUrl} colors={colors} secureTextEntry help={discord.configured ? 'configured' : undefined} />
        <View style={{ flexDirection: 'row', gap: 8 }}>
          <Btn label={t('notifications.messaging.save', 'Save')} onPress={() => void saveDiscord()} colors={colors} disabled={!discordUrl.trim() || busy === 'dc-save'} />
          <Btn label={t('notifications.messaging.test', 'Test')} onPress={() => settingsApi.testChannel('discord').catch(() => {})} colors={colors} variant="outline" disabled={!discord.configured} />
        </View>
      </Section>

      <ActionSheet
        visible={devicesOpen}
        title={t('notifications.webPush.title', 'Push devices')}
        items={endpoints.map((e) => ({ label: `${e.label || e.endpointId}`, onPress: () => void deleteDevice(e.endpointId) }))}
        onClose={() => setDevicesOpen(false)}
      />
    </>
  );
}

/* ------------------------------------------------------------------- quota */

const ROUTING_MODES: Array<QuotaConfig['routingMode']> = ['manual', 'ask', 'auto-low-risk'];

export function QuotaTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const { config, isLoading, error, reload } = useQuotaConfig();
  const [draft, setDraft] = React.useState({ watchThreshold: '', dangerThreshold: '' });
  const [saved, setSaved] = React.useState(false);
  const timerRef = React.useRef<ReturnType<typeof setTimeout> | null>(null);

  React.useEffect(() => {
    if (config) {
      setDraft({ watchThreshold: String(config.watchThreshold), dangerThreshold: String(config.dangerThreshold) });
    }
  }, [config]);

  const persist = (patch: Partial<QuotaConfig>) => {
    settingsApi.saveQuotaConfig(patch).then(
      () => {
        setSaved(true);
        if (timerRef.current) clearTimeout(timerRef.current);
        timerRef.current = setTimeout(() => setSaved(false), 1500);
        reload();
      },
      () => setSaved(false),
    );
  };

  if (isLoading && !config) return <ActivityIndicator color={colors.primary} />;
  if (!config) return <Text style={{ color: colors.destructive }}>{error ?? 'Failed to load'}</Text>;

  return (
    <>
      <Section title={t('quota.settings.alertsSection', 'Alerts')} colors={colors}>
        <Toggle
          label={t('quota.settings.alertsEnabled', 'Enable alerts')}
          value={config.alertsEnabled}
          onValueChange={(v) => persist({ alertsEnabled: v })}
          colors={colors}
        />
        <Field
          label={t('quota.settings.watchThreshold', 'Watch threshold %')}
          value={draft.watchThreshold}
          onChangeText={(v) => setDraft((d) => ({ ...d, watchThreshold: v }))}
          colors={colors}
          keyboardType="default"
        />
        <Field
          label={t('quota.settings.dangerThreshold', 'Danger threshold %')}
          value={draft.dangerThreshold}
          onChangeText={(v) => setDraft((d) => ({ ...d, dangerThreshold: v }))}
          colors={colors}
        />
        <Btn
          label={saved ? `✓ ${t('quota.settings.saved', 'Saved')}` : t('quota.settings.save', 'Save thresholds')}
          onPress={() => persist({ watchThreshold: Number(draft.watchThreshold) || 0, dangerThreshold: Number(draft.dangerThreshold) || 0 })}
          colors={colors}
        />
      </Section>

      <Section title={t('quota.settings.routingSection', 'Routing')} colors={colors}>
        {ROUTING_MODES.map((mode) => (
          <TouchableOpacity
            key={mode}
            onPress={() => persist({ routingMode: mode })}
            style={{
              borderColor: config.routingMode === mode ? colors.primary : colors.border,
              borderWidth: 1,
              borderRadius: 8,
              padding: 10,
            }}
          >
            <Text style={{ color: colors.foreground, fontSize: 14 }}>{t(`quota.settings.routing.${mode}`, mode)}</Text>
            <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }}>{t(`quota.settings.routing.${mode}Hint`, '')}</Text>
          </TouchableOpacity>
        ))}
      </Section>

      <Section title={t('quota.settings.accountsSection', 'Accounts')} colors={colors}>
        {config.accounts.length === 0 ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('quota.settings.readOnly', 'Read-only')}</Text>
        ) : (
          config.accounts.map((a) => (
            <Text key={a.accountId} style={{ color: colors.foreground, fontSize: 12 }}>
              {a.accountId} · {a.watchThreshold}% / {a.dangerThreshold}%
            </Text>
          ))
        )}
      </Section>
    </>
  );
}

/* ----------------------------------------------------------------- browser */

export function BrowserTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [enabled, setEnabled] = React.useState(false);
  const [status, setStatus] = React.useState<{ available: boolean; playwrightInstalled: boolean; chromiumInstalled: boolean; message?: string } | null>(null);
  const [busy, setBusy] = React.useState(false);

  const load = React.useCallback(() => {
    settingsApi.getBrowserSettings().then((d) => setEnabled(Boolean(d.settings?.enabled))).catch(() => {});
    settingsApi.getBrowserStatus().then(setStatus).catch(() => {});
  }, []);

  React.useEffect(() => load(), [load]);

  const toggle = async (v: boolean) => {
    setEnabled(v);
    try {
      await settingsApi.saveBrowserSettings(v);
    } catch {
      setEnabled(!v);
    }
  };

  const install = async () => {
    setBusy(true);
    try {
      await settingsApi.installBrowserRuntime();
    } finally {
      setBusy(false);
    }
  };

  return (
    <Section title={t('mainTabs.browser', 'Browser')} colors={colors}>
      <Toggle label={t('browser.enableLabel', 'Enable browser use')} value={enabled} onValueChange={toggle} colors={colors} />
      {status ? (
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {status.message ?? (status.available ? 'Available' : 'Unavailable')}
        </Text>
      ) : null}
      {status && !status.playwrightInstalled ? (
        <Btn label={busy ? 'Installing…' : 'Install runtime'} onPress={install} colors={colors} disabled={busy} />
      ) : null}
    </Section>
  );
}

/* ------------------------------------------------------------------- about */

export function AboutTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [latest, setLatest] = React.useState<string | null>(null);
  const [current, setCurrent] = React.useState<string>(APP_VERSION);
  const [releases, setReleases] = React.useState<ChangelogRelease[]>([]);
  const [restartStatus, setRestartStatus] = React.useState<'idle' | 'confirm' | 'restarting' | 'unsupported' | 'failed'>('idle');
  const [progress, setProgress] = React.useState(0);
  const [errorDetail, setErrorDetail] = React.useState('');
  const lang = ctx.lang;

  React.useEffect(() => {
    settingsApi.getLatestRelease().then((d) => setLatest(d.tagName ?? null)).catch(() => {});
    settingsApi.getReleases().then((d) => setReleases(d.releases ?? [])).catch(() => {});
  }, []);

  React.useEffect(() => {
    if (restartStatus !== 'restarting') return undefined;
    const startedAt = Date.now();
    const timer = setInterval(async () => {
      const elapsed = Date.now() - startedAt;
      setProgress(Math.min(90, (elapsed / 12000) * 90));
      try {
        const res = await fetch(`${getServerUrlSync()}/health`);
        if (res.ok && elapsed > 1500) {
          setProgress(100);
          setTimeout(() => setRestartStatus('idle'), 400);
          return;
        }
      } catch {
        // server still down mid-restart
      }
      if (elapsed > 60000) {
        clearInterval(timer);
        setRestartStatus('failed');
      }
    }, 1000);
    return () => clearInterval(timer);
  }, [restartStatus]);

  const openConfirm = () => {
    setErrorDetail('');
    setRestartStatus('confirm');
  };

  const runRestart = async () => {
    setRestartStatus('restarting');
    setErrorDetail('');
    try {
      const data = await settingsApi.restartServer();
      if (data && data.restarting === false) setRestartStatus('unsupported');
      // otherwise the poll effect takes over
    } catch (e) {
      setErrorDetail(e instanceof Error ? e.message : String(e));
      setRestartStatus('failed');
    }
  };

  const relation = latest ? releaseRelation(latest, current) : 'older';

  return (
    <>
      <Section title={t('about.title', 'About')} colors={colors}>
        <View style={{ gap: 2 }}>
          <Text style={{ color: colors.foreground, fontSize: 18, fontWeight: '700' }}>ddagent</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('about.description', 'Open-source AI coding assistant interface')}</Text>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 4 }}>
            <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '600' }}>v{current}</Text>
            {latest && relation === 'newer' ? (
              <Text style={{ color: '#16a34a', fontSize: 11, fontWeight: '600' }}>
                {t('apiKeys.version.updateAvailable', `Update available: ${latest}`)}
              </Text>
            ) : null}
          </View>
        </View>

        {[
          ['GitHub', GITHUB_REPO_URL],
          ['Discord', DISCORD_URL],
          ['Docs', DOCS_URL],
        ].map(([label, url]) => (
          <TouchableOpacity key={url} onPress={() => Linking.openURL(url).catch(() => {})} style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Text style={{ flex: 1, color: colors.primary }}>{label}</Text>
            <ChevronRight size={16} color={colors.mutedForeground} />
          </TouchableOpacity>
        ))}
        <TouchableOpacity onPress={() => Linking.openURL(GITHUB_REPO_URL).catch(() => {})} style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <Star size={14} color={colors.primary} />
          <Text style={{ color: colors.primary, fontWeight: '600' }}>{t('about.star', 'Star on GitHub')}</Text>
        </TouchableOpacity>
      </Section>

      <Section title={t('about.pro', 'ddagent Pro Features')} colors={colors}>
        <PremiumCard colors={colors} icon={<Cloud size={18} color={colors.mutedForeground} />} title={t('about.syncTitle', 'Sync Settings')} description={t('about.syncDescription', 'Keep your preferences, MCP configs, and theme in sync across all your environments.')} />
        <PremiumCard colors={colors} icon={<Users size={18} color={colors.mutedForeground} />} title={t('about.teamTitle', 'Team Management')} description={t('about.teamDescription', 'Multiple users, role-based access, and shared projects for your team.')} />
      </Section>

      <Section title={t('server.title', 'Server')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('server.description', 'Restart the ddagent process to apply updates or recover from a stuck state.')}</Text>
        <Btn label={t('server.restart', 'Restart')} onPress={openConfirm} colors={colors} variant="outline" />
      </Section>

      {releases.length > 0 ? (
        <Section title={t('changelog.title', 'Changelog')} colors={colors}>
          {releases.map((r) => {
            const rel = releaseRelation(r.tagName, current);
            return (
              <TouchableOpacity key={r.tagName} onPress={() => Linking.openURL(r.htmlUrl).catch(() => {})} style={{ gap: 4 }}>
                <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
                  <Text style={{ color: colors.foreground, fontWeight: '600' }}>{r.tagName}</Text>
                  {rel === 'current' ? (
                    <Text style={{ color: colors.mutedForeground, fontSize: 10, backgroundColor: colors.muted, paddingHorizontal: 6, paddingVertical: 1, borderRadius: 6 }}>{t('changelog.current', 'current')}</Text>
                  ) : null}
                  {rel === 'newer' ? (
                    <Text style={{ color: '#16a34a', fontSize: 10, backgroundColor: 'rgba(22,163,74,0.12)', paddingHorizontal: 6, paddingVertical: 1, borderRadius: 6 }}>{t('changelog.new', 'new')}</Text>
                  ) : null}
                </View>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{localizedNotes(r.body ?? '', lang).slice(0, 600)}</Text>
              </TouchableOpacity>
            );
          })}
        </Section>
      ) : null}

      <Text style={{ color: colors.mutedForeground, fontSize: 11, textAlign: 'center' }}>© 2026 ddagent — all rights reserved</Text>

      <Modal visible={restartStatus !== 'idle'} transparent animationType="fade" onRequestClose={() => setRestartStatus('idle')}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, gap: 14 }}>
            <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>
              {restartStatus === 'failed' ? t('server.restartFailed', 'Restart failed') : t('server.restart', 'Restart server')}
            </Text>
            {restartStatus === 'restarting' ? (
              <>
                <Text style={{ color: colors.mutedForeground, fontSize: 13 }}>{t('server.restarting', 'Restarting… the page will reload when the server is back.')}</Text>
                <View style={{ height: 6, borderRadius: 3, backgroundColor: colors.muted, overflow: 'hidden' }}>
                  <View style={{ height: 6, width: `${progress}%`, borderRadius: 3, backgroundColor: '#f59e0b' }} />
                </View>
              </>
            ) : (
              <Text style={{ color: colors.mutedForeground, fontSize: 13 }}>
                {restartStatus === 'confirm' ? t('server.restartConfirm', 'Restart the ddagent server? Active sessions will be interrupted.') : null}
                {restartStatus === 'unsupported' ? t('server.unsupported', 'Restart is only available when the server runs under the service manager.') : null}
                {restartStatus === 'failed' ? errorDetail || t('server.restartFailed', 'Restart failed') : null}
              </Text>
            )}
            {restartStatus !== 'restarting' ? (
              <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
                <TouchableOpacity onPress={() => setRestartStatus('idle')}>
                  <Text style={{ color: colors.mutedForeground, paddingVertical: 8 }}>{t('actions.cancel', 'Cancel')}</Text>
                </TouchableOpacity>
                {restartStatus === 'confirm' ? (
                  <TouchableOpacity onPress={() => void runRestart()} style={{ backgroundColor: '#d97706', borderRadius: 8, paddingHorizontal: 16, paddingVertical: 8 }}>
                    <Text style={{ color: '#fff', fontWeight: '600' }}>{t('server.restart', 'Restart')}</Text>
                  </TouchableOpacity>
                ) : null}
              </View>
            ) : null}
          </View>
        </View>
      </Modal>
    </>
  );
}

function PremiumCard({ colors, icon, title, description }: { colors: ThemeColors; icon: React.ReactNode; title: string; description: string }) {
  const { t } = useTranslation('settings');
  return (
    <View style={{ borderWidth: 1, borderStyle: 'dashed', borderColor: colors.border, borderRadius: 10, padding: 14, gap: 6 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
        {icon}
        <Text style={{ color: colors.foreground, fontWeight: '600' }}>{title}</Text>
      </View>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{description}</Text>
      <TouchableOpacity onPress={() => Linking.openURL(GITHUB_REPO_URL).catch(() => {})}>
        <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '600' }}>{t('about.proCta', 'Available with ddagent Pro')}</Text>
      </TouchableOpacity>
    </View>
  );
}

/* --------------------------------------------------------------- schedules */

export function SchedulesTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const { preferences, setPreference } = useUiPreferences();
  const [schedules, setSchedules] = React.useState<Schedule[]>([]);
  const [projects, setProjects] = React.useState<{ projectId: string; displayName: string }[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [runsById, setRunsById] = React.useState<Record<string, ScheduleRun[]>>({});
  const [dialogOpen, setDialogOpen] = React.useState(false);
  const [pendingDelete, setPendingDelete] = React.useState<{ id: string; label: string } | null>(null);

  const load = React.useCallback(async () => {
    try {
      const res = await settingsApi.listSchedules();
      setSchedules(Array.isArray(res.schedules) ? res.schedules : []);
    } catch {
      setSchedules([]);
    } finally {
      setLoading(false);
    }
  }, []);

  React.useEffect(() => { void load(); }, [load]);

  React.useEffect(() => {
    void (async () => {
      try {
        const res = await api.projects();
        if (res.ok) {
          const data = await res.json();
          const raw: any[] = Array.isArray(data) ? data : data?.data?.projects ?? data?.projects ?? [];
          setProjects(
            raw
              .map((p) => ({ projectId: p.id ?? p.projectId, displayName: p.displayName || p.name || p.id || p.projectId }))
              .filter((p) => Boolean(p.projectId)),
          );
        }
      } catch {
        /* ignore */
      }
    })();
  }, []);

  const projectName = React.useCallback(
    (id: string) => projects.find((p) => p.projectId === id)?.displayName ?? id,
    [projects],
  );

  const toggleRuns = async (schedule: Schedule) => {
    if (runsById[schedule.id]) {
      setRunsById((prev) => {
        const next = { ...prev };
        delete next[schedule.id];
        return next;
      });
      return;
    }
    try {
      const res = await settingsApi.listScheduleRuns(schedule.id, 50);
      setRunsById((prev) => ({ ...prev, [schedule.id]: Array.isArray(res.runs) ? res.runs : [] }));
    } catch {
      setRunsById((prev) => ({ ...prev, [schedule.id]: [] }));
    }
  };

  const toggleEnabled = async (schedule: Schedule, enabled: boolean) => {
    try {
      await settingsApi.updateSchedule(schedule.id, { enabled });
      await load();
    } catch (err) {
      Alert.alert('Schedule', err instanceof Error ? err.message : 'Failed to update schedule');
    }
  };

  const runNow = async (schedule: Schedule) => {
    try {
      await settingsApi.runScheduleNow(schedule.id);
      await load();
    } catch (err) {
      Alert.alert('Schedule', err instanceof Error ? err.message : 'Failed to run schedule');
    }
  };

  const remove = async (id: string) => {
    setPendingDelete(null);
    try {
      await settingsApi.deleteSchedule(id);
      await load();
    } catch (err) {
      Alert.alert('Schedule', err instanceof Error ? err.message : 'Failed to delete schedule');
    }
  };

  return (
    <>
      <Section title={t('schedules.title', 'Schedules')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {t('schedules.description', 'Recurring agent runs on a cron timetable. Runs fire unattended with permissions bypassed.')}
        </Text>
        <Toggle
          label={t('schedules.preventSleep', 'Prevent sleep while agents run')}
          description={t('schedules.preventSleepHint', 'Desktop keeps the display awake; in the browser a screen wake lock is used.')}
          value={preferences.preventSleep}
          onValueChange={(v) => setPreference('preventSleep', v)}
          colors={colors}
        />
        <Btn
          label={t('schedules.new', 'New schedule')}
          onPress={() => setDialogOpen(true)}
          colors={colors}
          icon={<Plus size={16} color={colors.primaryForeground} />}
        />
        {loading && schedules.length === 0 ? (
          <ActivityIndicator color={colors.primary} />
        ) : schedules.length === 0 ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 13, textAlign: 'center', paddingVertical: 16 }}>
            {t('schedules.empty', 'No schedules yet.')}
          </Text>
        ) : (
          schedules.map((schedule) => (
            <View key={schedule.id} style={{ borderTopWidth: 1, borderTopColor: colors.border, paddingTop: 10, gap: 8 }}>
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
                <CalendarClock size={18} color={colors.mutedForeground} />
                <Text style={{ flex: 1, color: colors.foreground, fontWeight: '600' }} numberOfLines={2}>
                  {truncateSchedulePrompt(schedule.prompt) || schedule.cron}
                </Text>
                <Switch
                  value={schedule.enabled}
                  onValueChange={(v) => void toggleEnabled(schedule, v)}
                  trackColor={{ true: colors.primary }}
                />
              </View>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>
                {scheduleMetaLine(schedule, projectName(schedule.projectId))}
                {schedule.nextRunAt && schedule.enabled ? ` · ${t('schedules.next', 'next')} ${formatScheduleTime(schedule.nextRunAt)}` : ''}
              </Text>
              <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 8 }}>
                {schedule.failCount > 0 ? (
                  <Text style={{ color: colors.destructive, fontSize: 11 }}>
                    {t('schedules.failures', '{{count}} failures', { count: schedule.failCount })}
                  </Text>
                ) : null}
                {!schedule.enabled ? (
                  <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('schedules.disabled', 'disabled')}</Text>
                ) : null}
                <TouchableOpacity onPress={() => void toggleRuns(schedule)}>
                  <Text style={{ color: colors.primary, fontSize: 12 }}>{t('schedules.history', 'History')}</Text>
                </TouchableOpacity>
                <TouchableOpacity onPress={() => void runNow(schedule)}>
                  <Play size={16} color={colors.foreground} />
                </TouchableOpacity>
                <TouchableOpacity onPress={() => setPendingDelete({ id: schedule.id, label: truncateSchedulePrompt(schedule.prompt, 40) })}>
                  <Trash2 size={16} color={colors.destructive} />
                </TouchableOpacity>
              </View>
              {runsById[schedule.id] ? (
                <View style={{ borderTopWidth: 1, borderTopColor: colors.border, paddingTop: 6, gap: 4 }}>
                  {runsById[schedule.id].length === 0 ? (
                    <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('schedules.noRuns', 'No runs yet.')}</Text>
                  ) : (
                    runsById[schedule.id].map((run) => (
                      <View key={run.id} style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
                        <Text style={{ color: colors.mutedForeground, fontSize: 11, width: 60 }}>{run.status}</Text>
                        <Text style={{ color: colors.foreground, fontSize: 11 }}>{formatScheduleTime(run.startedAt)}</Text>
                        {run.error ? (
                          <Text style={{ color: colors.destructive, fontSize: 11, flex: 1 }} numberOfLines={1}>{run.error}</Text>
                        ) : run.sessionId ? (
                          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{run.sessionId.slice(0, 8)}</Text>
                        ) : null}
                      </View>
                    ))
                  )}
                </View>
              ) : null}
            </View>
          ))
        )}
      </Section>

      <ScheduleDialog
        visible={dialogOpen}
        projects={projects}
        colors={colors}
        t={t}
        onClose={() => setDialogOpen(false)}
        onCreated={() => { setDialogOpen(false); void load(); }}
      />

      <ActionSheet
        visible={pendingDelete !== null}
        title={t('schedules.delete', 'Delete')}
        items={[
          { label: `${t('schedules.delete', 'Delete')} — ${pendingDelete?.label ?? ''}`, destructive: true, onPress: () => pendingDelete && void remove(pendingDelete.id) },
          { label: t('actions.cancel', 'Cancel'), onPress: () => setPendingDelete(null) },
        ]}
        onClose={() => setPendingDelete(null)}
      />
    </>
  );
}

function ScheduleDialog({
  visible,
  projects,
  colors,
  t,
  onClose,
  onCreated,
}: {
  visible: boolean;
  projects: { projectId: string; displayName: string }[];
  colors: ThemeColors;
  t: SettingsT;
  onClose: () => void;
  onCreated: () => void;
}) {
  const [projectId, setProjectId] = React.useState('');
  const [provider, setProvider] = React.useState<string>('claude');
  const [cron, setCron] = React.useState(DEFAULT_CRON);
  const [prompt, setPrompt] = React.useState('');
  const [useWorktree, setUseWorktree] = React.useState(false);
  const [catchUp, setCatchUp] = React.useState(false);
  const [providerSheet, setProviderSheet] = React.useState(false);
  const [preview, setPreview] = React.useState<string | null>(null);
  const [error, setError] = React.useState<string | null>(null);
  const [busy, setBusy] = React.useState(false);

  React.useEffect(() => {
    if (visible && !projectId && projects.length > 0) setProjectId(projects[0].projectId);
  }, [visible, projectId, projects]);

  React.useEffect(() => {
    if (!visible) return;
    let cancelled = false;
    const timer = setTimeout(() => {
      settingsApi
        .previewCron(cron)
        .then((d) => { if (!cancelled) setPreview(d.nextRunAt ?? null); })
        .catch(() => { if (!cancelled) setPreview(null); });
    }, 250);
    return () => { cancelled = true; clearTimeout(timer); };
  }, [cron, visible]);

  const submit = async () => {
    setBusy(true);
    setError(null);
    try {
      await settingsApi.createSchedule({ projectId, provider, cron, prompt, useWorktree, catchUp, enabled: true });
      setPrompt('');
      onCreated();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create schedule');
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, justifyContent: 'flex-end', backgroundColor: 'rgba(0,0,0,0.5)' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '90%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16 }}>
            <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '600' }}>{t('schedules.new', 'New schedule')}</Text>
            <TouchableOpacity onPress={onClose}>
              <X size={20} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>
          <ScrollView contentContainerStyle={{ padding: 16, paddingTop: 0, gap: 12 }}>
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('schedules.project', 'Project')}</Text>
            {projects.map((p) => (
              <TouchableOpacity
                key={p.projectId}
                onPress={() => setProjectId(p.projectId)}
                style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}
              >
                <View style={{ width: 16, height: 16, borderRadius: 8, borderWidth: 1, borderColor: colors.border, backgroundColor: projectId === p.projectId ? colors.primary : 'transparent' }} />
                <Text style={{ color: colors.foreground, flex: 1 }} numberOfLines={1}>{p.displayName}</Text>
              </TouchableOpacity>
            ))}

            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('schedules.provider', 'Provider')}</Text>
            <TouchableOpacity
              onPress={() => setProviderSheet(true)}
              style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderWidth: 1, borderColor: colors.border, borderRadius: 8, padding: 10 }}
            >
              <Text style={{ color: colors.foreground }}>{provider}</Text>
              <ChevronDown size={16} color={colors.mutedForeground} />
            </TouchableOpacity>

            <Field
              label={t('schedules.cron', 'Cron (min hour day month weekday)')}
              value={cron}
              onChangeText={setCron}
              placeholder="0 9 * * *"
              colors={colors}
            />
            <Text style={{ color: preview ? '#10b981' : colors.mutedForeground, fontSize: 11 }}>
              {preview
                ? t('schedules.nextRun', 'Next run: {{time}}', { time: formatScheduleTime(preview) })
                : t('schedules.cronInvalid', 'No upcoming run for this expression')}
            </Text>

            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('schedules.prompt', 'Prompt')}</Text>
            <TextInput
              value={prompt}
              onChangeText={setPrompt}
              multiline
              numberOfLines={3}
              placeholderTextColor={colors.mutedForeground}
              style={{ backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, color: colors.foreground, padding: 10, minHeight: 80, textAlignVertical: 'top' }}
            />

            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
              <Text style={{ color: colors.foreground, fontSize: 14 }}>{t('schedules.useWorktree', 'Run in a fresh worktree')}</Text>
              <Switch value={useWorktree} onValueChange={setUseWorktree} trackColor={{ true: colors.primary }} />
            </View>
            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
              <Text style={{ color: colors.foreground, fontSize: 14 }}>{t('schedules.catchUp', 'Catch up missed runs')}</Text>
              <Switch value={catchUp} onValueChange={setCatchUp} trackColor={{ true: colors.primary }} />
            </View>

            {error ? <Text style={{ color: colors.destructive, fontSize: 12 }}>{error}</Text> : null}

            <View style={{ flexDirection: 'row', gap: 8 }}>
              <Btn label={busy ? t('schedules.loading', 'Loading…') : t('schedules.create', 'Create')} onPress={submit} colors={colors} disabled={busy || !projectId || !prompt.trim() || !preview} />
              <Btn label={t('actions.cancel', 'Cancel')} onPress={onClose} colors={colors} variant="outline" />
            </View>
          </ScrollView>
        </View>
      </View>
      <ActionSheet
        visible={providerSheet}
        title={t('schedules.provider', 'Provider')}
        items={SCHEDULE_PROVIDERS.map((p) => ({ label: p, onPress: () => { setProvider(p); setProviderSheet(false); } }))}
        onClose={() => setProviderSheet(false)}
      />
    </Modal>
  );
}
