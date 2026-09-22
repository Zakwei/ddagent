import React, { useMemo } from 'react';
import { ActivityIndicator, Text, View } from 'react-native';
import { useRoute } from '@react-navigation/native';
import { WebView } from 'react-native-webview';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';

/**
 * Terminal island: the SAME xterm.js component the web app uses, served by the
 * ddagent server at /island/terminal and embedded in a WebView. The island's
 * /shell WebSocket connects directly — no data flows through RN.
 */
export default function TerminalScreen() {
  const { colors } = useTheme();
  const route = useRoute<any>();
  const { sessionId } = route.params;

  const uri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    return `${base}/island/terminal?session=${encodeURIComponent(sessionId)}&token=${encodeURIComponent(token)}`;
  }, [sessionId]);

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
              Terminal island failed to load ({code}): {description}
            </Text>
          </View>
        )}
        // Keep the session alive when the user backgrounds the app briefly.
        androidLayerType="hardware"
        setSupportMultipleWindows={false}
      />
    </View>
  );
}
