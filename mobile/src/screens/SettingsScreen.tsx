import React from 'react';
import { Alert, ScrollView, Switch, Text, TouchableOpacity, View } from 'react-native';
import * as LocalAuthentication from 'expo-local-authentication';
import { useNavigation } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { ChevronRight } from 'lucide-react-native';
import { useTranslation } from 'react-i18next';
import { useTheme, ThemeMode } from '../theme';
import { useAuth } from '../contexts/AuthContext';
import { clearServerUrl, getServerUrlSync } from '../lib/server-config';
import { getLanguage, setLanguage } from '../i18n';
import { isAppLockEnabled, setAppLockEnabled } from '../components/AppLock';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import { getSpeakVoiceOptions, getPreferredVoiceName, setPreferredVoiceName, loadPreferredVoice } from '../lib/tts';
import { settingsApi } from '../lib/settings-api';
import { useUiPreferences } from '../lib/ui-preferences-store';
import { ApiTab, AboutTab, BrowserTab, GitTab, NotificationsTab, QuotaTab, TasksTab, type TabCtx } from './SettingsTabs';

const LANGUAGES = ['en', 'pl', 'de', 'es', 'fr', 'it', 'ja', 'ko', 'ru', 'tr', 'zh-CN', 'zh-TW'];
const MODES: ThemeMode[] = ['system', 'light', 'dark'];

// Native tabs plus the Agents escape hatch (the Agents surface is ~3.7k LOC of
// MCP/skills/permissions UI and stays on the web renderer).
const TABS = [
  { id: 'general', label: 'General' },
  { id: 'git', label: 'Git' },
  { id: 'api', label: 'API tokens' },
  { id: 'tasks', label: 'Tasks' },
  { id: 'browser', label: 'Browser' },
  { id: 'notifications', label: 'Notifications' },
  { id: 'quota', label: 'Control Center' },
  { id: 'agents', label: 'Agents' },
  { id: 'about', label: 'About' },
] as const;

type TabId = (typeof TABS)[number]['id'];

function Row({ label, children, colors }: { label: string; children: React.ReactNode; colors: any }) {
  return (
    <View style={{ paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: colors.border }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 6 }}>{label}</Text>
      {children}
    </View>
  );
}

export default function SettingsScreen() {
  const { colors, isDark, mode, setMode } = useTheme();
  const insets = useSafeAreaInsets();
  const { user, logout } = useAuth();
  const navigation = useNavigation<any>();
  const { t: tRaw } = useTranslation('settings');
  const [tab, setTab] = React.useState<TabId>('general');
  const [lang, setLang] = React.useState(getLanguage());
  const [appLock, setAppLock] = React.useState(false);
  const [latest, setLatest] = React.useState<string | null>(null);
  const [voice, setVoice] = React.useState('');
  const [voiceItems, setVoiceItems] = React.useState<ActionSheetItem[] | null>(null);
  const { preferences, setPreference } = useUiPreferences();

  const ctx: TabCtx = React.useMemo(
    () => ({
      colors,
      isDark,
      lang,
      t: (key, fallback, opts) => String(tRaw(key, { defaultValue: fallback, ...(opts ?? {}) })),
    }),
    [colors, isDark, lang, tRaw],
  );

  React.useEffect(() => {
    void isAppLockEnabled().then(setAppLock);
    settingsApi.getLatestRelease().then((d) => setLatest(d.tagName ?? null)).catch(() => {});
    void loadPreferredVoice().then(() => setVoice(getPreferredVoiceName()));
  }, []);

  const openVoicePicker = async () => {
    const options = await getSpeakVoiceOptions();
    setVoiceItems([
      {
        label: 'Auto voice',
        onPress: () => {
          void setPreferredVoiceName('');
          setVoice('');
        },
      },
      ...options.map((o) => ({
        label: o.name,
        onPress: () => {
          void setPreferredVoiceName(o.id);
          setVoice(o.id);
        },
      })),
    ]);
  };

  const toggleAppLock = async (on: boolean) => {
    if (on) {
      // Don't offer a toggle the device can't satisfy.
      const capable = (await LocalAuthentication.hasHardwareAsync()) && (await LocalAuthentication.isEnrolledAsync());
      if (!capable) {
        Alert.alert('Biometrics unavailable', 'No enrolled fingerprint/face or device credential found.');
        return;
      }
    }
    await setAppLockEnabled(on);
    setAppLock(on);
  };

  const changeServer = () => {
    Alert.alert('Change server', 'You will be logged out.', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Change',
        style: 'destructive',
        onPress: async () => {
          await logout();
          await clearServerUrl();
        },
      },
    ]);
  };

  return (
    <>
      <View style={{ backgroundColor: colors.background, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ paddingHorizontal: 12, paddingVertical: 8, gap: 8 }}>
          {TABS.map((item) => {
            const active = tab === item.id;
            return (
              <TouchableOpacity
                key={item.id}
                onPress={() => {
                  if (item.id === 'agents') {
                    navigation.navigate('Web', { path: '/?settings=agents', title: 'Agents' });
                  } else {
                    setTab(item.id);
                  }
                }}
                style={{
                  backgroundColor: active ? colors.primary : colors.secondary,
                  borderRadius: 999,
                  paddingHorizontal: 14,
                  paddingVertical: 7,
                }}
              >
                <Text style={{ color: active ? colors.primaryForeground : colors.secondaryForeground, fontSize: 13 }}>{item.label}</Text>
              </TouchableOpacity>
            );
          })}
        </ScrollView>
      </View>

      <ScrollView style={{ flex: 1, backgroundColor: colors.background }} contentContainerStyle={{ padding: 16, paddingBottom: 16 + insets.bottom }}>
        {tab === 'general' ? (
          <>
            <Row label="SERVER" colors={colors}>
              <Text style={{ color: colors.foreground }}>{getServerUrlSync()}</Text>
              <TouchableOpacity onPress={changeServer} style={{ marginTop: 8 }}>
                <Text style={{ color: colors.primary }}>Change server</Text>
              </TouchableOpacity>
            </Row>

            <Row label="ACCOUNT" colors={colors}>
              <Text style={{ color: colors.foreground }}>{user?.username ?? '—'}</Text>
              <TouchableOpacity onPress={logout} style={{ marginTop: 8 }}>
                <Text style={{ color: colors.destructive }}>Log out</Text>
              </TouchableOpacity>
            </Row>

            <Row label="THEME" colors={colors}>
              <View style={{ flexDirection: 'row', gap: 8 }}>
                {MODES.map((m) => (
                  <TouchableOpacity
                    key={m}
                    onPress={() => setMode(m)}
                    style={{
                      backgroundColor: mode === m ? colors.primary : colors.secondary,
                      borderRadius: 8,
                      paddingHorizontal: 14,
                      paddingVertical: 8,
                    }}
                  >
                    <Text style={{ color: mode === m ? colors.primaryForeground : colors.secondaryForeground, fontSize: 13 }}>{m}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            </Row>

            <Row label="LANGUAGE" colors={colors}>
              <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 8 }}>
                {LANGUAGES.map((l) => (
                  <TouchableOpacity
                    key={l}
                    onPress={async () => {
                      await setLanguage(l);
                      setLang(l);
                    }}
                    style={{
                      backgroundColor: lang === l ? colors.primary : colors.secondary,
                      borderRadius: 8,
                      paddingHorizontal: 12,
                      paddingVertical: 6,
                    }}
                  >
                    <Text style={{ color: lang === l ? colors.primaryForeground : colors.secondaryForeground, fontSize: 13 }}>{l}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            </Row>

            <Row label="SECURITY" colors={colors}>
              <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                <Text style={{ color: colors.foreground }}>App lock (biometric / device credential)</Text>
                <Switch value={appLock} onValueChange={toggleAppLock} trackColor={{ true: colors.primary }} />
              </View>
            </Row>

            <Row label="CHAT BEHAVIOUR" colors={colors}>
              <View style={{ gap: 12 }}>
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                  <View style={{ flex: 1, paddingRight: 12 }}>
                    <Text style={{ color: colors.foreground }}>Send with Ctrl/⌘+Enter</Text>
                    <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Enter inserts a newline instead of sending.</Text>
                  </View>
                  <Switch
                    value={preferences.sendByCtrlEnter}
                    onValueChange={(v) => setPreference('sendByCtrlEnter', v)}
                    trackColor={{ true: colors.primary }}
                  />
                </View>
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                  <View style={{ flex: 1, paddingRight: 12 }}>
                    <Text style={{ color: colors.foreground }}>Keep screen awake while running</Text>
                    <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Prevents sleep during an active agent turn.</Text>
                  </View>
                  <Switch
                    value={preferences.preventSleep}
                    onValueChange={(v) => setPreference('preventSleep', v)}
                    trackColor={{ true: colors.primary }}
                  />
                </View>
              </View>
            </Row>

            <Row label="READ ALOUD" colors={colors}>
              <TouchableOpacity onPress={() => void openVoicePicker()} style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 4 }}>
                <Text style={{ flex: 1, color: colors.foreground }}>{voice || 'Auto voice'}</Text>
                <ChevronRight size={16} color={colors.mutedForeground} />
              </TouchableOpacity>
            </Row>

            <Row label="ADVANCED (WEB UI)" colors={colors}>
              <TouchableOpacity
                onPress={() => navigation.navigate('Web', { path: '/', title: 'Full web UI' })}
                style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10 }}
              >
                <Text style={{ flex: 1, color: colors.foreground }}>Open full web UI</Text>
                <ChevronRight size={16} color={colors.mutedForeground} />
              </TouchableOpacity>
            </Row>

            <Row label="VERSION" colors={colors}>
              <Text style={{ color: colors.foreground }}>0.1.0 (mobile scaffold)</Text>
              {latest && (
                <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 4 }}>
                  Latest ddagent release: {latest}
                </Text>
              )}
            </Row>
          </>
        ) : tab === 'git' ? (
          <GitTab ctx={ctx} />
        ) : tab === 'api' ? (
          <ApiTab ctx={ctx} />
        ) : tab === 'tasks' ? (
          <TasksTab ctx={ctx} />
        ) : tab === 'browser' ? (
          <BrowserTab ctx={ctx} />
        ) : tab === 'notifications' ? (
          <NotificationsTab ctx={ctx} />
        ) : tab === 'quota' ? (
          <QuotaTab ctx={ctx} />
        ) : tab === 'about' ? (
          <AboutTab ctx={ctx} />
        ) : null}
      </ScrollView>

      <ActionSheet
        visible={voiceItems !== null}
        title="Read-aloud voice"
        items={voiceItems ?? []}
        onClose={() => setVoiceItems(null)}
      />
    </>
  );
}
