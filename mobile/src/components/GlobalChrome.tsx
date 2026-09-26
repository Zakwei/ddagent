import React, { useCallback, useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Alert, Text, TouchableOpacity, View } from 'react-native';
import Constants from 'expo-constants';
import { useTranslation } from 'react-i18next';
import { AlertTriangle, Download, RefreshCw } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { getServerUrlSync } from '../lib/server-config';
import { settingsApi } from '../lib/settings-api';
import { useTheme } from '../theme';
import {
  formatUpdateVersion,
  isRestartRequired,
  isUpdateAvailable,
  parseHealthVersion,
  parseLatestReleaseTag,
  parseRunningSessionIds,
  runningBadgeLabel,
  HEALTH_POLL_INTERVAL_MS,
  RUNNING_POLL_INTERVAL_MS,
} from '../lib/chrome';

const APP_VERSION = (Constants.expoConfig?.version as string | undefined) ?? '0.1.0';
const UPDATE_POLL_TIMEOUT_MS = 90_000;

export type GlobalChromeState = {
  latestTag: string | null;
  healthVersion: string | null;
  updateAvailable: boolean;
  restartRequired: boolean;
  runningCount: number;
  updating: boolean;
  update: () => void;
};

async function fetchHealthVersion(): Promise<string | null> {
  const base = getServerUrlSync();
  if (!base) return null;
  try {
    const response = await fetch(`${base}/health`);
    if (!response.ok) return null;
    return parseHealthVersion(await response.json());
  } catch {
    return null;
  }
}

export function useGlobalChrome(): GlobalChromeState {
  const [latestTag, setLatestTag] = useState<string | null>(null);
  const [healthVersion, setHealthVersion] = useState<string | null>(null);
  const [runningCount, setRunningCount] = useState(0);
  const [updating, setUpdating] = useState(false);
  const pollTimerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const refreshHealth = useCallback(async () => {
    setHealthVersion(await fetchHealthVersion());
  }, []);

  const refreshRunning = useCallback(async () => {
    try {
      const response = await api.runningSessions();
      if (!response.ok) return;
      setRunningCount(parseRunningSessionIds(await response.json()).length);
    } catch {
      /* keep last known count */
    }
  }, []);

  useEffect(() => {
    settingsApi
      .getLatestRelease()
      .then((payload) => setLatestTag(parseLatestReleaseTag(payload)))
      .catch(() => {});
    void refreshHealth();
    void refreshRunning();
    const healthTimer = setInterval(() => void refreshHealth(), 30_000);
    const runningTimer = setInterval(() => void refreshRunning(), RUNNING_POLL_INTERVAL_MS);
    return () => {
      clearInterval(healthTimer);
      clearInterval(runningTimer);
    };
  }, [refreshHealth, refreshRunning]);

  useEffect(() => () => {
    if (pollTimerRef.current) clearInterval(pollTimerRef.current);
  }, []);

  const updateAvailable = isUpdateAvailable(latestTag, healthVersion ?? APP_VERSION);
  const restartRequired = isRestartRequired(healthVersion, APP_VERSION);

  const update = useCallback(() => {
    Alert.alert(
      'Update available',
      `Install ${latestTag ? formatUpdateVersion(latestTag) : 'the latest version'} now? The server will restart when finished.`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Update now',
          onPress: () => {
            void (async () => {
              setUpdating(true);
              try {
                const response = await api.post('/system/update');
                const payload = await response.json().catch(() => ({} as any));
                if (!response.ok) throw new Error(String(payload?.error ?? 'Update failed'));
                const deadline = Date.now() + UPDATE_POLL_TIMEOUT_MS;
                if (pollTimerRef.current) clearInterval(pollTimerRef.current);
                pollTimerRef.current = setInterval(async () => {
                  const version = await fetchHealthVersion();
                  if (version && version === (latestTag ?? version)) {
                    if (pollTimerRef.current) clearInterval(pollTimerRef.current);
                    pollTimerRef.current = null;
                    setUpdating(false);
                    await refreshHealth();
                    Alert.alert('Update installed', 'Restart the server to apply the update.');
                  } else if (Date.now() > deadline) {
                    if (pollTimerRef.current) clearInterval(pollTimerRef.current);
                    pollTimerRef.current = null;
                    setUpdating(false);
                    Alert.alert('Update installed', 'Restart required to finish applying the update.');
                  }
                }, HEALTH_POLL_INTERVAL_MS);
              } catch (error) {
                setUpdating(false);
                Alert.alert('Update failed', error instanceof Error ? error.message : 'Update failed');
              }
            })();
          },
        },
      ],
    );
  }, [latestTag, refreshHealth]);

  return { latestTag, healthVersion, updateAvailable, restartRequired, runningCount, updating, update };
}

export function GlobalChromeBadges({ chrome }: { chrome: GlobalChromeState }) {
  const { colors } = useTheme();
  const { t } = useTranslation(['sidebar', 'common']);
  const badge = runningBadgeLabel(chrome.runningCount);

  return (
    <View style={{ gap: 6 }}>
      {badge ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, height: 32 }}>
          <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: '#10b981' }} />
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
            {t('search.runningCount', { count: chrome.runningCount, defaultValue: '{{count}} active' })}
          </Text>
        </View>
      ) : null}

      {chrome.updateAvailable ? (
        <TouchableOpacity
          onPress={chrome.update}
          disabled={chrome.updating}
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 8,
            height: 40,
            borderRadius: 8,
            paddingHorizontal: 12,
            backgroundColor: colors.accent,
          }}
        >
          {chrome.updating ? (
            <ActivityIndicator size="small" color={colors.primary} />
          ) : (
            <Download size={16} color={colors.primary} />
          )}
          <Text style={{ color: colors.primary, fontSize: 13, fontWeight: '600', flex: 1 }}>
            {chrome.updating
              ? t('version.updating', { defaultValue: 'Updating…' })
              : t('version.updateAvailable', { defaultValue: 'Update available' })}
          </Text>
        </TouchableOpacity>
      ) : null}

      {chrome.restartRequired ? (
        <View
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 8,
            borderRadius: 8,
            paddingHorizontal: 12,
            paddingVertical: 8,
            backgroundColor: 'rgba(217,119,6,0.15)',
          }}
        >
          <AlertTriangle size={16} color="#d97706" />
          <Text style={{ color: '#d97706', fontSize: 12, fontWeight: '600', flex: 1 }}>
            {t('version.restartRequired', { defaultValue: 'Update installed — restart the server to apply' })}
          </Text>
        </View>
      ) : null}
    </View>
  );
}
