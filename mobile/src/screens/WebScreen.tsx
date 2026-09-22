import React, { useMemo } from 'react';
import { ActivityIndicator, Text, View } from 'react-native';
import { useRoute } from '@react-navigation/native';
import { WebView } from 'react-native-webview';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';

/**
 * Generic PWA-in-WebView screen: loads any in-app route (board, tasks, usage,
 * source-control, mcp, skills, prd, browser, settings) with token auth. The
 * web app's own responsive layout renders the mobile UI, giving full PWA
 * parity for surfaces that don't have a dedicated native screen yet.
 */
export default function WebScreen() {
  const { colors } = useTheme();
  const route = useRoute<any>();
  const { path = '/' } = route.params ?? {};

  const uri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    const sep = path.includes('?') ? '&' : '?';
    return `${base}${path}${sep}token=${encodeURIComponent(token)}`;
  }, [path]);

  if (!uri) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <Text style={{ color: colors.destructive }}>No server/token configured</Text>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <WebView
        source={{ uri }}
        style={{ flex: 1, backgroundColor: colors.background }}
        startInLoadingState
        renderLoading={() => (
          <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
            <ActivityIndicator color={colors.primary} size="large" />
          </View>
        )}
        renderError={(domain, code, description) => (
          <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background, padding: 24 }}>
            <Text style={{ color: colors.destructive, textAlign: 'center' }}>
              {`Failed to load ${path} (${code}): ${description}`}
            </Text>
          </View>
        )}
        androidLayerType="hardware"
        setSupportMultipleWindows={false}
      />
    </View>
  );
}
