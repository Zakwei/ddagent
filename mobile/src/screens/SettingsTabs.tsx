import React from 'react';
import { ActivityIndicator, Alert, Linking, Text, TouchableOpacity, View } from 'react-native';
import { ChevronRight, Plus, RefreshCw, Trash2 } from 'lucide-react-native';
import { Section, Field, Toggle, Btn, StatusLine, type SettingsT } from './settings/kit';
import { ActionSheet } from '../components/ActionSheet';
import type { ThemeColors } from '../theme';
import {
  settingsApi,
  localizedNotes,
  type ApiKeyItem,
  type ChangelogRelease,
  type GithubCredentialItem,
  type NotificationPreferences,
  type SttConfig,
} from '../lib/settings-api';
import { useQuotaConfig, type QuotaConfig } from '../lib/quota';
import { useTasksSettings } from '../contexts/TasksSettingsContext';
import { api } from '~shared/utils/api';

export type TabCtx = { colors: ThemeColors; isDark: boolean; lang: string; t: SettingsT };

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

  const load = React.useCallback(() => {
    settingsApi.getNotificationPreferences().then(setPrefs).catch(() => {});
    settingsApi
      .getMessengerConfig()
      .then((d) => {
        setTelegram(d.config.telegram);
        setDiscord(d.config.discord);
      })
      .catch(() => {});
  }, []);

  React.useEffect(() => load(), [load]);

  const patch = (next: NotificationPreferences) => {
    setPrefs(next);
    settingsApi.saveNotificationPreferences(next).catch(() => {});
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

  if (!prefs) return <ActivityIndicator color={colors.primary} />;

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
        <Btn label={t('notifications.webPush.test', 'Send test notification')} onPress={testPush} colors={colors} variant="outline" icon={<RefreshCw size={14} color={colors.foreground} />} />
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

      <Section title={t('notifications.messaging.title', 'Messaging')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('notifications.messaging.description', 'Pair Telegram or Discord to receive approvals remotely.')}</Text>
        <Field label="Telegram bot token" value={telegramToken} onChangeText={setTelegramToken} colors={colors} secureTextEntry help={telegram.configured ? 'configured' : undefined} />
        <View style={{ flexDirection: 'row', gap: 8 }}>
          <Btn label={t('notifications.messaging.save', 'Save')} onPress={() => settingsApi.saveTelegramConfig(telegramToken).then(load).catch(() => {})} colors={colors} disabled={!telegramToken.trim()} />
          <Btn label={t('notifications.messaging.test', 'Test')} onPress={() => settingsApi.testChannel('telegram').catch(() => {})} colors={colors} variant="outline" disabled={!telegram.configured} />
        </View>
        <Field label="Discord webhook URL" value={discordUrl} onChangeText={setDiscordUrl} colors={colors} help={discord.configured ? 'configured' : undefined} />
        <Btn label={t('notifications.messaging.save', 'Save')} onPress={() => settingsApi.saveDiscordConfig(discordUrl).then(load).catch(() => {})} colors={colors} disabled={!discordUrl.trim()} />
      </Section>
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
  const [releases, setReleases] = React.useState<ChangelogRelease[]>([]);
  const [restarting, setRestarting] = React.useState(false);

  React.useEffect(() => {
    settingsApi.getLatestRelease().then((d) => setLatest(d.tagName ?? null)).catch(() => {});
    settingsApi.getReleases().then((d) => setReleases(d.releases ?? [])).catch(() => {});
  }, []);

  const restart = () => {
    Alert.alert(t('server.title', 'Server'), t('server.restartConfirm', 'Restart the ddagent server? Active sessions will be interrupted.'), [
      { text: t('actions.cancel', 'Cancel'), style: 'cancel' },
      {
        text: t('server.restart', 'Restart'),
        style: 'destructive',
        onPress: async () => {
          setRestarting(true);
          try {
            await settingsApi.restartServer();
          } catch {
            setRestarting(false);
          }
        },
      },
    ]);
  };

  const lang = ctx.lang;

  return (
    <>
      <Section title={t('server.title', 'Server')} colors={colors}>
        <Text style={{ color: colors.foreground }}>ddagent {latest ? `· ${latest}` : ''}</Text>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('server.description', 'Restart the ddagent process to apply updates.')}</Text>
        {[
          ['GitHub', 'https://github.com/Zakwei/ddagent'],
          ['Discord', 'https://discord.gg/buxwujPNRE'],
          ['Docs', 'https://github.com/Zakwei/ddagent/docs'],
        ].map(([label, url]) => (
          <TouchableOpacity key={url} onPress={() => Linking.openURL(url).catch(() => {})} style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Text style={{ flex: 1, color: colors.primary }}>{label}</Text>
            <ChevronRight size={16} color={colors.mutedForeground} />
          </TouchableOpacity>
        ))}
        <Btn label={restarting ? t('server.restarting', 'Restarting…') : t('server.restart', 'Restart')} onPress={restart} colors={colors} variant="destructive" disabled={restarting} />
      </Section>

      {releases.length > 0 ? (
        <Section title={t('changelog.title', 'Changelog')} colors={colors}>
          {releases.slice(0, 10).map((r) => (
            <View key={r.tagName} style={{ gap: 4 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600' }}>{r.name || r.tagName}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
                {localizedNotes(r.body ?? '', lang).slice(0, 600)}
              </Text>
            </View>
          ))}
        </Section>
      ) : null}
    </>
  );
}
