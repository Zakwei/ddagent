import React from 'react';
import { ActivityIndicator, Alert, Modal, ScrollView, Switch, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { Check, Pencil, Plus, RefreshCw, Search, Trash2, X } from 'lucide-react-native';

import { Section, Btn, StatusLine, type SettingsT } from './kit';
import type { ThemeColors } from '../../theme';
import {
  AGENT_PROVIDERS,
  MCP_SUPPORTED_SCOPES,
  MCP_SUPPORTED_TRANSPORTS,
  MCP_SUPPORTS_WORKING_DIRECTORY,
  settingsApi,
  type AgentProvider,
  type McpScope,
  type McpTokenItem,
  type McpTransport,
  type ProviderAccountItem,
  type ProviderAuthStatus,
  type ProviderMcpServer,
  type ProviderSkill,
  type UpsertMcpServerPayload,
} from '../../lib/settings-api';
import {
  COMMON_CLAUDE_TOOLS,
  COMMON_CURSOR_COMMANDS,
  FALLBACK_PERMISSION_MODES,
  addUnique,
  removeValue,
  type ProviderPermissionMode,
} from '../../lib/provider-settings';
import { useProviderSettings } from '../../lib/provider-settings-store';
import { ActionSheet, ActionSheetItem } from '../../components/ActionSheet';
import { Toast, useToast } from '../../components/Toast';

export type AgentsCtx = { colors: ThemeColors; isDark: boolean; lang: string; t: SettingsT };

const PROVIDER_LABELS: Record<AgentProvider, string> = {
  claude: 'Claude',
  cursor: 'Cursor',
  codex: 'Codex',
  opencode: 'OpenCode',
  devin: 'Devin',
};

const CATEGORIES = ['account', 'permissions', 'mcp', 'skills'] as const;
type Category = (typeof CATEGORIES)[number];

const UNSUPPORTED_SKILL_DELETE: AgentProvider[] = ['devin'];

/* ------------------------------------------------------------------ shell */

export function AgentsTab({ ctx }: { ctx: AgentsCtx }) {
  const { colors, t } = ctx;
  const [provider, setProvider] = React.useState<AgentProvider>('claude');
  const [category, setCategory] = React.useState<Category>('account');
  const [authStatus, setAuthStatus] = React.useState<ProviderAuthStatus | null>(null);

  const checkAuth = React.useCallback(() => {
    setAuthStatus(null);
    settingsApi
      .getProviderAuthStatus(provider)
      .then((d) => setAuthStatus({ authenticated: Boolean(d.authenticated), email: d.email ?? null, method: d.method ?? null, error: d.error ?? null }))
      .catch((err) => setAuthStatus({ authenticated: false, email: null, method: null, error: err instanceof Error ? err.message : 'error' }));
  }, [provider]);

  React.useEffect(checkAuth, [checkAuth]);

  return (
    <View style={{ gap: 12 }}>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ gap: 8 }}>
        {AGENT_PROVIDERS.map((p) => {
          const active = p === provider;
          return (
            <TouchableOpacity
              key={p}
              onPress={() => setProvider(p)}
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                gap: 6,
                backgroundColor: active ? colors.primary : colors.secondary,
                borderRadius: 999,
                paddingHorizontal: 14,
                paddingVertical: 7,
              }}
            >
              <Text style={{ color: active ? colors.primaryForeground : colors.secondaryForeground, fontSize: 13 }}>{PROVIDER_LABELS[p]}</Text>
              {active && authStatus?.authenticated ? <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#10b981' }} /> : null}
            </TouchableOpacity>
          );
        })}
      </ScrollView>

      <View style={{ flexDirection: 'row', gap: 6, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        {CATEGORIES.map((c) => {
          const active = c === category;
          return (
            <TouchableOpacity key={c} onPress={() => setCategory(c)} style={{ paddingVertical: 8, paddingHorizontal: 10, borderBottomWidth: 2, borderBottomColor: active ? colors.primary : 'transparent' }}>
              <Text style={{ color: active ? colors.foreground : colors.mutedForeground, fontSize: 13 }}>
                {c === 'account'
                  ? t('tabs.account', 'Account')
                  : c === 'permissions'
                    ? t('tabs.permissions', 'Permissions')
                    : c === 'mcp'
                      ? t('tabs.mcpServers', 'MCP Servers')
                      : t('tabs.skills', provider === 'opencode' || provider === 'devin' ? 'Shared Skills' : 'Skills')}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      {category === 'account' ? <AccountSection ctx={ctx} provider={provider} authStatus={authStatus} onRetryAuth={checkAuth} />
        : category === 'permissions' ? <PermissionsSection ctx={ctx} provider={provider} />
        : category === 'mcp' ? <McpSection ctx={ctx} provider={provider} />
        : <SkillsSection ctx={ctx} provider={provider} />}
    </View>
  );
}

/* ---------------------------------------------------------------- account */

function AccountSection({ ctx, provider, authStatus, onRetryAuth }: { ctx: AgentsCtx; provider: AgentProvider; authStatus: ProviderAuthStatus | null; onRetryAuth: () => void }) {
  const { colors, t } = ctx;
  const label = PROVIDER_LABELS[provider];
  const statusText = !authStatus
    ? t('agents.authStatus.checkingAuth', 'Checking authentication status...')
    : authStatus.authenticated
      ? t('agents.authStatus.loggedInAs', 'Logged in as {{email}}', { email: authStatus.email || t('agents.authStatus.authenticatedUser', 'authenticated user') })
      : t('agents.authStatus.notConnected', 'Not connected');
  return (
    <>
      <Section title={t('agents.connectionStatus', 'Connection Status')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t(`agents.account.${provider}.description`, '')}</Text>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
          <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: authStatus?.authenticated ? '#10b981' : '#9ca3af' }} />
          <Text style={{ color: colors.foreground, fontSize: 13, flex: 1 }}>{statusText}</Text>
          <TouchableOpacity onPress={onRetryAuth}>
            <RefreshCw size={16} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>
        <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{label}</Text>
        {authStatus?.error ? <Text style={{ color: colors.destructive, fontSize: 12 }}>{t('agents.error', 'Error: {{error}}', { error: authStatus.error })}</Text> : null}
      </Section>
      <ProviderAccountsSection ctx={ctx} provider={provider} />
    </>
  );
}

function ProviderAccountsSection({ ctx, provider }: { ctx: AgentsCtx; provider: AgentProvider }) {
  const { colors, t } = ctx;
  const [accounts, setAccounts] = React.useState<ProviderAccountItem[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [newLabel, setNewLabel] = React.useState('');
  const [busy, setBusy] = React.useState(false);
  const [usage, setUsage] = React.useState<Record<string, { totalTokens: number; costUsd: number | null }>>({});
  const [error, setError] = React.useState<string | null>(null);

  const load = React.useCallback(() => {
    setLoading(true);
    settingsApi
      .listProviderAccounts(provider)
      .then((d) => setAccounts(d.accounts ?? []))
      .catch(() => setAccounts([]))
      .finally(() => setLoading(false));
  }, [provider]);

  React.useEffect(load, [load]);

  const showUsage = async (account: ProviderAccountItem) => {
    setBusy(true);
    try {
      const d = await settingsApi.getProviderAccountUsage(account.id);
      setUsage((prev) => ({ ...prev, [account.id]: { totalTokens: d.usage?.totalTokens ?? 0, costUsd: d.usage?.costUsd ?? null } }));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load usage');
    } finally {
      setBusy(false);
    }
  };

  const add = async () => {
    if (!newLabel.trim()) return;
    setBusy(true);
    setError(null);
    try {
      await settingsApi.createProviderAccount(provider, newLabel.trim());
      setNewLabel('');
      load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to add account');
    } finally {
      setBusy(false);
    }
  };

  const remove = (account: ProviderAccountItem) => {
    Alert.alert('Remove account', `Remove "${account.label}"?`, [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Remove',
        style: 'destructive',
        onPress: async () => {
          try {
            await settingsApi.deleteProviderAccount(account.id);
            load();
          } catch (err) {
            setError(err instanceof Error ? err.message : 'Failed to remove account');
          }
        },
      },
    ]);
  };

  const makeDefault = async (account: ProviderAccountItem) => {
    try {
      await settingsApi.makeProviderAccountDefault(account.id);
      load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update account');
    }
  };

  return (
    <Section title={t('agents.accounts.title', 'Named accounts')} colors={colors}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('agents.accounts.description', '')}</Text>
      {loading ? <ActivityIndicator color={colors.primary} /> : null}
      {accounts.map((account) => (
        <View key={account.id} style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 10, gap: 4 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', flex: 1 }}>{account.label}</Text>
            {account.isDefault ? <Text style={{ color: colors.primary, fontSize: 11 }}>{t('agents.accounts.default', 'Default')}</Text> : null}
            {usage[account.id] ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('agents.accounts.usage', '{{tokens}} tokens', { tokens: usage[account.id].totalTokens })}{usage[account.id].costUsd != null ? ` · $${usage[account.id].costUsd}` : ''}</Text> : null}
          </View>
          {Object.entries(account.envOverrides || {}).map(([k, v]) => (
            <Text key={k} style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{k}={v}</Text>
          ))}
          <View style={{ flexDirection: 'row', gap: 12, marginTop: 4 }}>
            <TouchableOpacity onPress={() => void showUsage(account)}>
              <Text style={{ color: colors.primary, fontSize: 12 }}>{t('agents.accounts.usageButton', 'Usage')}</Text>
            </TouchableOpacity>
            {!account.isDefault ? (
              <TouchableOpacity onPress={() => void makeDefault(account)}>
                <Text style={{ color: colors.primary, fontSize: 12 }}>{t('agents.accounts.makeDefault', 'Make default')}</Text>
              </TouchableOpacity>
            ) : (
              <Check size={16} color={colors.primary} />
            )}
            <TouchableOpacity onPress={() => remove(account)}>
              <Trash2 size={16} color={colors.destructive} />
            </TouchableOpacity>
          </View>
        </View>
      ))}
      <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
        <TextInput
          value={newLabel}
          onChangeText={setNewLabel}
          placeholder={t('agents.accounts.newLabel', 'Account label (e.g. Work)')}
          placeholderTextColor={colors.mutedForeground}
          style={{ flex: 1, backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, color: colors.foreground, paddingHorizontal: 12, paddingVertical: 8, fontSize: 13 }}
        />
        <Btn label={t('agents.accounts.add', 'Add account')} onPress={add} colors={colors} disabled={busy || !newLabel.trim()} icon={<Plus size={14} color={colors.primaryForeground} />} />
      </View>
      <StatusLine status={error} colors={colors} />
    </Section>
  );
}

/* ------------------------------------------------------------ permissions */

function PermissionsSection({ ctx, provider }: { ctx: AgentsCtx; provider: AgentProvider }) {
  const { colors, t } = ctx;
  const settings = useProviderSettings();
  const toast = useToast();

  return (
    <>
      {provider === 'claude' ? <ClaudePermissions ctx={ctx} colors={colors} t={t} settings={settings} onSaved={toast.show} />
        : provider === 'cursor' ? <CursorPermissions ctx={ctx} colors={colors} t={t} settings={settings} onSaved={toast.show} />
        : <ProviderModeSettings ctx={ctx} provider={provider} colors={colors} t={t} settings={settings} onSaved={toast.show} />}
      {toast.toast && <Toast toast={toast.toast} />}
    </>
  );
}

function useAutoSave(onSaved: (msg: string, type?: 'success' | 'error') => void) {
  return React.useCallback(
    (fn: () => Promise<void> | void, successMsg: string) => {
      Promise.resolve(fn())
        .then(() => onSaved(successMsg))
        .catch((err) => onSaved(err instanceof Error ? err.message : 'Failed to save', 'error'));
    },
    [onSaved],
  );
}

function ClaudePermissions({ ctx, colors, t, settings, onSaved }: any) {
  const persist = useAutoSave(onSaved);
  const [newAllowed, setNewAllowed] = React.useState('');
  const [newBlocked, setNewBlocked] = React.useState('');
  const { claude } = settings;
  const update = (patch: Partial<typeof claude>) => persist(() => settings.setClaude({ ...claude, ...patch }), t('saveStatus.success', 'Settings saved'));

  return (
    <Section title={t('permissions.title', 'Permission Settings')} colors={colors}>
      <ToggleRow label={t('permissions.skipPermissions.label', 'Skip permission prompts (use with caution)')} description={t('permissions.skipPermissions.claudeDescription', '')} value={claude.skipPermissions} onChange={(v) => update({ skipPermissions: v })} colors={colors} />
      <ListEditor
        ctx={ctx}
        title={t('permissions.allowedTools.title', 'Allowed Tools')}
        description={t('permissions.allowedTools.description', '')}
        placeholder={t('permissions.allowedTools.placeholder', 'e.g. "Bash(git log:*)" or "Write"')}
        values={claude.allowedTools}
        onChange={(allowedTools) => update({ allowedTools })}
        draft={newAllowed}
        setDraft={setNewAllowed}
        quickAddLabel={t('permissions.allowedTools.quickAdd', 'Quick add common tools:')}
        quickAdd={COMMON_CLAUDE_TOOLS}
        emptyLabel={t('permissions.allowedTools.empty', 'No allowed tools configured')}
      />
      <ListEditor
        ctx={ctx}
        title={t('permissions.blockedTools.title', 'Blocked Tools')}
        description={t('permissions.blockedTools.description', '')}
        placeholder={t('permissions.blockedTools.placeholder', 'e.g. "Bash(rm:*)"')}
        values={claude.disallowedTools}
        onChange={(disallowedTools) => update({ disallowedTools })}
        draft={newBlocked}
        setDraft={setNewBlocked}
        emptyLabel={t('permissions.blockedTools.empty', 'No blocked tools configured')}
      />
    </Section>
  );
}

function CursorPermissions({ ctx, colors, t, settings, onSaved }: any) {
  const persist = useAutoSave(onSaved);
  const [newAllowed, setNewAllowed] = React.useState('');
  const [newBlocked, setNewBlocked] = React.useState('');
  const { cursor } = settings;
  const update = (patch: Partial<typeof cursor>) => persist(() => settings.setCursor({ ...cursor, ...patch }), t('saveStatus.success', 'Settings saved'));

  return (
    <Section title={t('permissions.title', 'Permission Settings')} colors={colors}>
      <ToggleRow label={t('permissions.skipPermissions.label', 'Skip permission prompts (use with caution)')} description={t('permissions.skipPermissions.cursorDescription', '')} value={cursor.skipPermissions} onChange={(v) => update({ skipPermissions: v })} colors={colors} />
      <ListEditor
        ctx={ctx}
        title={t('permissions.allowedCommands.title', 'Allowed Shell Commands')}
        description={t('permissions.allowedCommands.description', '')}
        placeholder={t('permissions.allowedCommands.placeholder', 'e.g. "Shell(ls)"')}
        values={cursor.allowedCommands}
        onChange={(allowedCommands) => update({ allowedCommands })}
        draft={newAllowed}
        setDraft={setNewAllowed}
        quickAddLabel={t('permissions.allowedCommands.quickAdd', 'Quick add common commands:')}
        quickAdd={COMMON_CURSOR_COMMANDS}
        emptyLabel={t('permissions.allowedCommands.empty', 'No allowed commands configured')}
      />
      <ListEditor
        ctx={ctx}
        title={t('permissions.blockedCommands.title', 'Blocked Shell Commands')}
        description={t('permissions.blockedCommands.description', '')}
        placeholder={t('permissions.blockedCommands.placeholder', 'e.g. "Shell(rm -rf)"')}
        values={cursor.disallowedCommands}
        onChange={(disallowedCommands) => update({ disallowedCommands })}
        draft={newBlocked}
        setDraft={setNewBlocked}
        emptyLabel={t('permissions.blockedCommands.empty', 'No blocked commands configured')}
      />
    </Section>
  );
}

function ProviderModeSettings({ ctx, provider, colors, t, settings, onSaved }: any) {
  const persist = useAutoSave(onSaved);
  const modes: ProviderPermissionMode[] = FALLBACK_PERMISSION_MODES[provider as AgentProvider] ?? ['default'];
  const current: string = settings[provider as 'codex' | 'opencode' | 'devin'];
  const prefix = provider === 'codex' ? 'permissions.codex.modes' : 'permissions.permissionMode.modes';
  return (
    <Section title={provider === 'codex' ? t('permissions.codex.permissionMode', 'Permission Mode') : t('permissions.permissionMode.title', 'Permission Mode')} colors={colors}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
        {provider === 'codex' ? t('permissions.codex.description', '') : t('permissions.permissionMode.description', '')}
      </Text>
      {modes.map((mode) => {
        const active = current === mode;
        return (
          <TouchableOpacity
            key={mode}
            onPress={() => persist(() => settings.setPermissionMode(provider, mode), t('saveStatus.success', 'Settings saved'))}
            style={{ borderColor: active ? colors.primary : colors.border, borderWidth: 1, borderRadius: 8, padding: 12, gap: 4 }}
          >
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <View style={{ width: 16, height: 16, borderRadius: 8, borderWidth: 2, borderColor: active ? colors.primary : colors.border, alignItems: 'center', justifyContent: 'center' }}>
                {active ? <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: colors.primary }} /> : null}
              </View>
              <Text style={{ color: colors.foreground, fontWeight: '600' }}>{t(`${prefix}.${mode}.title`, mode)}</Text>
            </View>
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t(`${prefix}.${mode}.description`, '')}</Text>
          </TouchableOpacity>
        );
      })}
      {provider === 'codex' ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('permissions.codex.overrideNote', '')}</Text> : null}
    </Section>
  );
}

function ToggleRow({ label, description, value, onChange, colors }: { label: string; description?: string; value: boolean; onChange: (v: boolean) => void; colors: ThemeColors }) {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
      <View style={{ flex: 1 }}>
        <Text style={{ color: colors.foreground, fontSize: 14 }}>{label}</Text>
        {description ? <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }}>{description}</Text> : null}
      </View>
      <Switch value={value} onValueChange={onChange} trackColor={{ true: colors.primary }} />
    </View>
  );
}

function ListEditor({
  ctx,
  title,
  description,
  placeholder,
  values,
  onChange,
  draft,
  setDraft,
  quickAddLabel,
  quickAdd,
  emptyLabel,
}: {
  ctx: AgentsCtx;
  title: string;
  description?: string;
  placeholder?: string;
  values: string[];
  onChange: (next: string[]) => void;
  draft: string;
  setDraft: (v: string) => void;
  quickAddLabel?: string;
  quickAdd?: string[];
  emptyLabel?: string;
}) {
  const { colors } = ctx;
  const add = (value: string) => {
    const next = addUnique(values, value);
    if (next !== values) onChange(next);
    setDraft('');
  };
  return (
    <View style={{ gap: 8 }}>
      <Text style={{ color: colors.foreground, fontWeight: '600' }}>{title}</Text>
      {description ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{description}</Text> : null}
      <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
        <TextInput
          value={draft}
          onChangeText={setDraft}
          onSubmitEditing={() => add(draft)}
          placeholder={placeholder}
          placeholderTextColor={colors.mutedForeground}
          autoCapitalize="none"
          style={{ flex: 1, backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, color: colors.foreground, paddingHorizontal: 12, paddingVertical: 8, fontSize: 13 }}
        />
        <TouchableOpacity onPress={() => add(draft)} style={{ padding: 8 }}>
          <Plus size={18} color={colors.primary} />
        </TouchableOpacity>
      </View>
      <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6 }}>
        {values.length === 0 ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{emptyLabel}</Text> : null}
        {values.map((v) => (
          <TouchableOpacity key={v} onPress={() => onChange(removeValue(values, v))} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: colors.secondary, borderRadius: 999, paddingHorizontal: 10, paddingVertical: 4 }}>
            <Text style={{ color: colors.secondaryForeground, fontSize: 12, fontFamily: 'monospace' }}>{v}</Text>
            <X size={12} color={colors.mutedForeground} />
          </TouchableOpacity>
        ))}
      </View>
      {quickAdd && quickAdd.length > 0 ? (
        <View style={{ gap: 6 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{quickAddLabel}</Text>
          <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6 }}>
            {quickAdd.filter((q) => !values.includes(q)).map((q) => (
              <TouchableOpacity key={q} onPress={() => add(q)} style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 999, paddingHorizontal: 10, paddingVertical: 4 }}>
                <Text style={{ color: colors.primary, fontSize: 11, fontFamily: 'monospace' }}>{q}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>
      ) : null}
    </View>
  );
}

/* -------------------------------------------------------------- mcp */

type McpDraft = {
  name: string;
  scope: McpScope;
  transport: McpTransport;
  command: string;
  args: string;
  url: string;
  env: string;
  cwd: string;
  workspacePath: string;
};

const emptyDraft = (scope: McpScope, transport: McpTransport): McpDraft => ({ name: '', scope, transport, command: '', args: '', url: '', env: '', cwd: '', workspacePath: '' });

function parseKeyValueLines(text: string): Record<string, string> {
  const out: Record<string, string> = {};
  text
    .split('\n')
    .map((l) => l.trim())
    .filter(Boolean)
    .forEach((line) => {
      const idx = line.indexOf('=');
      if (idx > 0) out[line.slice(0, idx).trim()] = line.slice(idx + 1).trim();
    });
  return out;
}

function McpSection({ ctx, provider }: { ctx: AgentsCtx; provider: AgentProvider }) {
  const { colors, t } = ctx;
  const [servers, setServers] = React.useState<ProviderMcpServer[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [editing, setEditing] = React.useState<ProviderMcpServer | null>(null);
  const [formOpen, setFormOpen] = React.useState(false);
  const toast = useToast();

  const load = React.useCallback(() => {
    setLoading(true);
    const scopes = MCP_SUPPORTED_SCOPES[provider];
    Promise.all(scopes.map((scope) => settingsApi.listMcpServers(provider, scope).catch(() => ({ servers: [] as ProviderMcpServer[] }))))
      .then((results) => setServers(results.flatMap((r) => r.servers ?? [])))
      .catch(() => setServers([]))
      .finally(() => setLoading(false));
  }, [provider]);

  React.useEffect(load, [load]);

  const remove = (server: ProviderMcpServer) => {
    Alert.alert(t('mcpServers.deleteConfirm.title', 'Delete MCP server?'), t('mcpServers.deleteConfirm.description', '"{{serverName}}" will be removed from the provider configuration.', { serverName: server.name }), [
      { text: 'Cancel', style: 'cancel' },
      {
        text: t('mcpServers.actions.delete', 'Delete server'),
        style: 'destructive',
        onPress: async () => {
          try {
            await settingsApi.deleteMcpServer(provider, server.name, server.scope, server.workspacePath);
            toast.show(t('saveStatus.success', 'Settings saved'));
            load();
          } catch (err) {
            toast.show(err instanceof Error ? err.message : 'Failed to delete', 'error');
          }
        },
      },
    ]);
  };

  return (
    <>
      <Section title={t('mcpServers.title', 'MCP Servers')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t(`mcpServers.description.${provider}`, '')}</Text>
        <Btn
          label={t('mcpServers.addButton', 'Add MCP Server')}
          onPress={() => {
            setEditing(null);
            setFormOpen(true);
          }}
          colors={colors}
          icon={<Plus size={14} color={colors.primaryForeground} />}
        />
        {loading ? <ActivityIndicator color={colors.primary} /> : null}
        {!loading && servers.length === 0 ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('mcpServers.empty', 'No MCP servers configured')}</Text> : null}
        {servers.map((server) => (
          <View key={`${server.scope}:${server.workspacePath || 'g'}:${server.name}`} style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 10, gap: 4 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600', flex: 1 }}>{server.name}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{server.transport}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{server.scope}</Text>
              {server.name.startsWith('ddagent-') ? <Text style={{ color: colors.primary, fontSize: 11 }}>{t('mcpServers.managed.badge', 'Managed')}</Text> : null}
            </View>
            {server.command ? <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{server.command} {(server.args ?? []).join(' ')}</Text> : null}
            {server.url ? <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{server.url}</Text> : null}
            {server.projectDisplayName ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{server.projectDisplayName}</Text> : null}
            {!server.name.startsWith('ddagent-') ? (
              <View style={{ flexDirection: 'row', gap: 14, marginTop: 4 }}>
                <TouchableOpacity
                  onPress={() => {
                    setEditing(server);
                    setFormOpen(true);
                  }}
                >
                  <Pencil size={16} color={colors.primary} />
                </TouchableOpacity>
                <TouchableOpacity onPress={() => remove(server)}>
                  <Trash2 size={16} color={colors.destructive} />
                </TouchableOpacity>
              </View>
            ) : null}
          </View>
        ))}
        <StatusLine status={null} colors={colors} />
      </Section>
      <McpFormModal ctx={ctx} provider={provider} visible={formOpen} editing={editing} onClose={() => setFormOpen(false)} onSaved={() => { toast.show(t('saveStatus.success', 'Settings saved')); setFormOpen(false); load(); }} onError={(m) => toast.show(m, 'error')} />
      <McpTokens ctx={ctx} />
      {toast.toast && <Toast toast={toast.toast} />}
    </>
  );
}

function McpFormModal({ ctx, provider, visible, editing, onClose, onSaved, onError }: { ctx: AgentsCtx; provider: AgentProvider; visible: boolean; editing: ProviderMcpServer | null; onClose: () => void; onSaved: () => void; onError: (m: string) => void }) {
  const { colors, t } = ctx;
  const scopes = MCP_SUPPORTED_SCOPES[provider];
  const transports = MCP_SUPPORTED_TRANSPORTS[provider];
  const [draft, setDraft] = React.useState<McpDraft>(emptyDraft(scopes[0], transports[0]));
  const [saving, setSaving] = React.useState(false);

  React.useEffect(() => {
    if (!visible) return;
    if (editing) {
      setDraft({
        name: editing.name,
        scope: editing.scope,
        transport: editing.transport,
        command: editing.command ?? '',
        args: (editing.args ?? []).join('\n'),
        url: editing.url ?? '',
        env: Object.entries(editing.env ?? {}).map(([k, v]) => `${k}=${v}`).join('\n'),
        cwd: editing.cwd ?? '',
        workspacePath: editing.workspacePath ?? '',
      });
    } else {
      setDraft(emptyDraft(scopes[0], transports[0]));
    }
  }, [visible, editing, provider]);

  const save = async () => {
    if (!draft.name.trim()) return onError('Server name is required');
    if (draft.transport === 'stdio' && !draft.command.trim()) return onError('stdio requires a command');
    if (draft.transport !== 'stdio' && !draft.url.trim()) return onError(`${draft.transport} requires a url`);
    setSaving(true);
    try {
      const payload: UpsertMcpServerPayload = {
        name: draft.name.trim(),
        scope: draft.scope,
        transport: draft.transport,
        ...(draft.workspacePath.trim() ? { workspacePath: draft.workspacePath.trim() } : {}),
        ...(draft.transport === 'stdio'
          ? {
              command: draft.command.trim(),
              ...(draft.args.trim() ? { args: draft.args.split('\n').map((a) => a.trim()).filter(Boolean) } : {}),
              ...(MCP_SUPPORTS_WORKING_DIRECTORY[provider] && draft.cwd.trim() ? { cwd: draft.cwd.trim() } : {}),
              ...(draft.env.trim() ? { env: parseKeyValueLines(draft.env) } : {}),
            }
          : { url: draft.url.trim() }),
      };
      if (editing) {
        // The provider-scoped endpoint upserts by name; re-create then rely on same-name update.
        await settingsApi.deleteMcpServer(provider, editing.name, editing.scope, editing.workspacePath).catch(() => {});
      }
      await settingsApi.createMcpServer(provider, payload);
      onSaved();
    } catch (err) {
      onError(err instanceof Error ? err.message : 'Failed to save');
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 16, maxHeight: '88%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 8 }}>
            <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700', flex: 1 }}>{editing ? t('mcpForm.title.edit', 'Edit MCP Server') : t('mcpForm.title.add', 'Add MCP Server')}</Text>
            <TouchableOpacity onPress={onClose}>
              <X size={20} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>
          <ScrollView contentContainerStyle={{ gap: 12 }}>
            {!editing ? (
              <>
                <SelectorRow label={t('mcpForm.scope.label', 'Scope')} value={draft.scope} options={scopes} colors={colors} onSelect={(scope) => setDraft({ ...draft, scope: scope as McpScope })} />
                <TextInputField label={t('mcpForm.projectPath', 'Path: {{path}}', { path: '' }) === 'Path: {{path}}' ? 'Workspace path' : 'Workspace path'} value={draft.workspacePath} onChangeText={(workspacePath) => setDraft({ ...draft, workspacePath })} colors={colors} />
              </>
            ) : (
              <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('mcpForm.scope.cannotChange', 'Scope cannot be changed when editing an existing server')}</Text>
            )}
            <TextInputField label={t('mcpForm.fields.serverName', 'Server Name')} value={draft.name} onChangeText={(name) => setDraft({ ...draft, name })} colors={colors} placeholder={t('mcpForm.placeholders.serverName', 'my-server')} />
            <SelectorRow label={t('mcpForm.fields.transportType', 'Transport Type')} value={draft.transport} options={transports} colors={colors} onSelect={(transport) => setDraft({ ...draft, transport: transport as McpTransport })} />
            {draft.transport === 'stdio' ? (
              <>
                <TextInputField label={t('mcpForm.fields.command', 'Command')} value={draft.command} onChangeText={(command) => setDraft({ ...draft, command })} colors={colors} />
                <TextInputField label={t('mcpForm.fields.arguments', 'Arguments (one per line)')} value={draft.args} onChangeText={(args) => setDraft({ ...draft, args })} colors={colors} multiline />
                {MCP_SUPPORTS_WORKING_DIRECTORY[provider] ? <TextInputField label="Working directory" value={draft.cwd} onChangeText={(cwd) => setDraft({ ...draft, cwd })} colors={colors} /> : null}
                <TextInputField label={t('mcpForm.fields.envVars', 'Environment Variables (KEY=value, one per line)')} value={draft.env} onChangeText={(env) => setDraft({ ...draft, env })} colors={colors} multiline />
              </>
            ) : (
              <TextInputField label={t('mcpForm.fields.url', 'URL')} value={draft.url} onChangeText={(url) => setDraft({ ...draft, url })} colors={colors} />
            )}
            <Btn label={saving ? t('mcpForm.actions.saving', 'Saving...') : editing ? t('mcpForm.actions.updateServer', 'Update Server') : t('mcpForm.actions.addServer', 'Add Server')} onPress={save} colors={colors} disabled={saving} />
          </ScrollView>
        </View>
      </View>
    </Modal>
  );
}

function McpTokens({ ctx }: { ctx: AgentsCtx }) {
  const { colors, t } = ctx;
  const [tokens, setTokens] = React.useState<McpTokenItem[]>([]);
  const [label, setLabel] = React.useState('');
  const [scope, setScope] = React.useState<'read' | 'write'>('read');
  const [fresh, setFresh] = React.useState<string | null>(null);
  const [busy, setBusy] = React.useState(false);

  const load = React.useCallback(() => {
    settingsApi.listMcpTokens().then((d) => setTokens(d.tokens ?? [])).catch(() => setTokens([]));
  }, []);
  React.useEffect(load, [load]);

  const create = async () => {
    setBusy(true);
    try {
      const d = await settingsApi.createMcpToken(label, scope);
      setFresh(d.token ?? null);
      setLabel('');
      load();
    } catch {
      /* ignore */
    } finally {
      setBusy(false);
    }
  };

  return (
    <Section title={t('mcpTokens.title', 'ddagent MCP server tokens')} colors={colors}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('mcpTokens.description', '')}</Text>
      {fresh ? (
        <View style={{ backgroundColor: 'rgba(16,185,129,0.12)', borderRadius: 8, padding: 10, gap: 4 }}>
          <Text style={{ color: colors.foreground, fontFamily: 'monospace', fontSize: 12 }} selectable>{fresh}</Text>
          <TouchableOpacity onPress={() => setFresh(null)}>
            <Text style={{ color: colors.primary, fontSize: 12 }}>{t('mcpTokens.dismiss', 'Dismiss')}</Text>
          </TouchableOpacity>
        </View>
      ) : null}
      <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
        <TextInput
          value={label}
          onChangeText={setLabel}
          placeholder={t('mcpTokens.labelPlaceholder', 'Token label (e.g. Claude Desktop)')}
          placeholderTextColor={colors.mutedForeground}
          style={{ flex: 1, backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, color: colors.foreground, paddingHorizontal: 12, paddingVertical: 8, fontSize: 13 }}
        />
        <SelectorRow label="" value={scope} options={['read', 'write']} colors={colors} onSelect={(s) => setScope(s as 'read' | 'write')} />
      </View>
      <Btn label={t('mcpTokens.create', 'Create')} onPress={create} colors={colors} disabled={busy} />
      {tokens.length === 0 ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('mcpTokens.empty', 'No MCP tokens yet.')}</Text> : null}
      {tokens.map((token) => (
        <View key={token.id} style={{ flexDirection: 'row', alignItems: 'center', gap: 8, borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 10 }}>
          <View style={{ flex: 1 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600' }}>{token.label}</Text>
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{token.scope} · {token.lastUsedAt ? t('mcpTokens.lastUsed', 'used {{time}}', { time: token.lastUsedAt }) : t('mcpTokens.neverUsed', 'never used')}</Text>
          </View>
          <TouchableOpacity onPress={async () => { await settingsApi.deleteMcpToken(token.id).catch(() => {}); load(); }}>
            <Trash2 size={16} color={colors.destructive} />
          </TouchableOpacity>
        </View>
      ))}
    </Section>
  );
}

/* -------------------------------------------------------------- skills */

function SkillsSection({ ctx, provider }: { ctx: AgentsCtx; provider: AgentProvider }) {
  const { colors, t } = ctx;
  const [skills, setSkills] = React.useState<ProviderSkill[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [query, setQuery] = React.useState('');
  const [addOpen, setAddOpen] = React.useState(false);
  const [name, setName] = React.useState('');
  const [content, setContent] = React.useState('');
  const [busy, setBusy] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);
  const toast = useToast();

  const load = React.useCallback(() => {
    setLoading(true);
    settingsApi
      .listProviderSkills(provider)
      .then((d) => setSkills(d.skills ?? []))
      .catch(() => setSkills([]))
      .finally(() => setLoading(false));
  }, [provider]);
  React.useEffect(load, [load]);

  const filtered = React.useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return skills;
    return skills.filter((s) => [s.command, s.name, s.description, s.scope, s.pluginName, s.projectDisplayName, s.sourcePath].filter(Boolean).some((v) => String(v).toLowerCase().includes(q)));
  }, [skills, query]);

  const add = async () => {
    if (!name.trim() || !content.trim()) {
      setError('Skill name and content are required');
      return;
    }
    setBusy(true);
    setError(null);
    try {
      await settingsApi.createProviderSkill(provider, name.trim(), content);
      toast.show('Skill saved');
      setAddOpen(false);
      setName('');
      setContent('');
      load();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save skill');
    } finally {
      setBusy(false);
    }
  };

  const remove = (skill: ProviderSkill) => {
    Alert.alert('Delete skill', `Delete "${skill.name}"?`, [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Delete',
        style: 'destructive',
        onPress: async () => {
          try {
            await settingsApi.deleteProviderSkill(provider, skill.name);
            toast.show('Skill deleted');
            load();
          } catch (err) {
            toast.show(err instanceof Error ? err.message : 'Failed to delete', 'error');
          }
        },
      },
    ]);
  };

  const canDelete = !UNSUPPORTED_SKILL_DELETE.includes(provider);

  return (
    <>
      <Section title={t('tabs.skills', provider === 'opencode' || provider === 'devin' ? 'Shared Skills' : 'Skills')} colors={colors}>
        <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
          <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 10 }}>
            <Search size={14} color={colors.mutedForeground} />
            <TextInput value={query} onChangeText={setQuery} placeholder="Search skills..." placeholderTextColor={colors.mutedForeground} style={{ flex: 1, color: colors.foreground, paddingVertical: 8, fontSize: 13 }} />
          </View>
          <Btn label="Add" onPress={() => setAddOpen(true)} colors={colors} icon={<Plus size={14} color={colors.primaryForeground} />} />
        </View>
        {loading ? <ActivityIndicator color={colors.primary} /> : null}
        {!loading && filtered.length === 0 ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>No skills found.</Text> : null}
        {filtered.map((skill) => (
          <View key={`${skill.scope}:${skill.sourcePath ?? skill.name}`} style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 10, gap: 2 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600', fontFamily: 'monospace', flex: 1 }}>{skill.command || skill.name}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{skill.scope}</Text>
              {canDelete ? (
                <TouchableOpacity onPress={() => remove(skill)}>
                  <Trash2 size={16} color={colors.destructive} />
                </TouchableOpacity>
              ) : null}
            </View>
            {skill.description ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{skill.description}</Text> : null}
            {skill.projectDisplayName ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{skill.projectDisplayName}</Text> : null}
          </View>
        ))}
        <StatusLine status={error} colors={colors} />
      </Section>
      <Modal visible={addOpen} transparent animationType="slide" onRequestClose={() => setAddOpen(false)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
          <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 16, maxHeight: '88%' }}>
            <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700', marginBottom: 8 }}>Add Skill</Text>
            <ScrollView contentContainerStyle={{ gap: 12 }}>
              <TextInputField label="Skill name" value={name} onChangeText={setName} colors={colors} placeholder="my-skill" />
              <TextInputField label="SKILL.md content" value={content} onChangeText={setContent} colors={colors} multiline />
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{`~/.${provider === 'codex' ? 'agents' : provider}/skills/<skill-name>/SKILL.md`}</Text>
              <StatusLine status={error} colors={colors} />
              <View style={{ flexDirection: 'row', gap: 8 }}>
                <View style={{ flex: 1 }}>
                  <Btn label="Cancel" onPress={() => setAddOpen(false)} colors={colors} variant="outline" />
                </View>
                <View style={{ flex: 1 }}>
                  <Btn label={busy ? 'Saving...' : 'Save'} onPress={add} colors={colors} disabled={busy} />
                </View>
              </View>
            </ScrollView>
          </View>
        </View>
      </Modal>
      {toast.toast && <Toast toast={toast.toast} />}
    </>
  );
}

/* ------------------------------------------------------------ models */

function TextInputField({ label, value, onChangeText, colors, placeholder, multiline }: { label: string; value: string; onChangeText: (v: string) => void; colors: ThemeColors; placeholder?: string; multiline?: boolean }) {
  return (
    <View style={{ gap: 4 }}>
      {label ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{label}</Text> : null}
      <TextInput
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={colors.mutedForeground}
        multiline={multiline}
        autoCapitalize="none"
        autoCorrect={false}
        style={{
          backgroundColor: colors.background,
          borderColor: colors.border,
          borderWidth: 1,
          borderRadius: 8,
          color: colors.foreground,
          paddingHorizontal: 12,
          paddingVertical: 10,
          fontSize: 13,
          minHeight: multiline ? 96 : undefined,
          textAlignVertical: multiline ? 'top' : 'center',
        }}
      />
    </View>
  );
}

function SelectorRow({ label, value, options, colors, onSelect }: { label: string; value: string; options: string[]; colors: ThemeColors; onSelect: (v: string) => void }) {
  const [open, setOpen] = React.useState(false);
  const items: ActionSheetItem[] = options.map((o) => ({ label: o, onPress: () => onSelect(o) }));
  return (
    <View style={{ gap: 4 }}>
      {label ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{label}</Text> : null}
      <TouchableOpacity onPress={() => setOpen(true)} style={{ backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}>
        <Text style={{ color: colors.foreground, fontSize: 13 }}>{value}</Text>
      </TouchableOpacity>
      <ActionSheet visible={open} title={label} items={items} onClose={() => setOpen(false)} />
    </View>
  );
}
