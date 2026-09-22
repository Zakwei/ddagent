import React from 'react';
import { Alert, ScrollView, Switch, Text, TouchableOpacity, View } from 'react-native';
import * as LocalAuthentication from 'expo-local-authentication';
import { useNavigation } from '@react-navigation/native';
import { ChevronRight } from 'lucide-react-native';
import { useTheme, ThemeMode } from '../theme';
import { useAuth } from '../contexts/AuthContext';
import { clearServerUrl, getServerUrlSync } from '../lib/server-config';
import { getLanguage, setLanguage } from '../i18n';
import { isAppLockEnabled, setAppLockEnabled } from '../components/AppLock';

const LANGUAGES = ['en', 'pl', 'de', 'es', 'fr', 'it', 'ja', 'ko', 'ru', 'tr', 'zh-CN', 'zh-TW'];
const MODES: ThemeMode[] = ['system', 'light', 'dark'];
// Full-parity surfaces rendered by the web app inside a WebView.
const WEB_SETTINGS_TABS = [
  { tab: 'agents', label: 'Agents' },
  { tab: 'api', label: 'API tokens' },
  { tab: 'git', label: 'Git' },
  { tab: 'notifications', label: 'Notifications' },
  { tab: 'tasks', label: 'Tasks' },
  { tab: 'quota', label: 'Quota' },
  { tab: 'about', label: 'About / Changelog' },
];

function Row({ label, children, colors }: { label: string; children: React.ReactNode; colors: any }) {
  return (
    <View style={{ paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: colors.border }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 6 }}>{label}</Text>
      {children}
    </View>
  );
}

export default function SettingsScreen() {
  const { colors, mode, setMode } = useTheme();
  const { user, logout } = useAuth();
  const navigation = useNavigation<any>();
  const [lang, setLang] = React.useState(getLanguage());
  const [appLock, setAppLock] = React.useState(false);

  React.useEffect(() => {
    void isAppLockEnabled().then(setAppLock);
  }, []);

  const toggleAppLock = async (on: boolean) => {
    if (on) {
      // Don't offer a toggle the device can't satisfy.
      const capable = await LocalAuthentication.hasHardwareAsync() && (await LocalAuthentication.isEnrolledAsync());
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
    <ScrollView style={{ flex: 1, backgroundColor: colors.background }} contentContainerStyle={{ padding: 16 }}>
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

      <Row label="ADVANCED (WEB UI)" colors={colors}>
        {WEB_SETTINGS_TABS.map(({ tab, label }) => (
          <TouchableOpacity
            key={tab}
            onPress={() => navigation.navigate('Web', { path: `/?settings=${tab}`, title: label })}
            style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10 }}
          >
            <Text style={{ flex: 1, color: colors.foreground }}>{label}</Text>
            <ChevronRight size={16} color={colors.mutedForeground} />
          </TouchableOpacity>
        ))}
      </Row>

      <Row label="VERSION" colors={colors}>
        <Text style={{ color: colors.foreground }}>0.1.0 (mobile scaffold)</Text>
      </Row>
    </ScrollView>
  );
}
