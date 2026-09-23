import React, { useMemo, useState } from 'react';
import { ActivityIndicator, KeyboardAvoidingView, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { WebView, WebViewMessageEvent } from 'react-native-webview';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';

/**
 * The island's StandaloneShell (minimal) renders its own TerminalShortcutsPanel
 * (Esc/Tab/Shift-Tab/CTRL/ALT/arrows/Ctrl+C) that sends raw sequences straight
 * over the /shell socket — more reliable than injecting synthetic key events,
 * so no RN-side accessory row is needed.
 */
export default function TerminalScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const route = useRoute<any>();
  const { sessionId } = route.params;
  const [exited, setExited] = useState(false);

  const uri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    return `${base}/island/terminal?session=${encodeURIComponent(sessionId)}&token=${encodeURIComponent(token)}`;
  }, [sessionId]);

  const onMessage = (e: WebViewMessageEvent) => {
    try {
      const msg = JSON.parse(e.nativeEvent.data);
      if (msg?.type === 'exit') setExited(true);
    } catch {
      /* non-JSON island messages ignored */
    }
  };

  if (!uri) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <Text style={{ color: colors.destructive }}>No server/token configured</Text>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView behavior="padding" style={{ flex: 1, backgroundColor: colors.background, paddingBottom: insets.bottom }}>
      <WebView
        source={{ uri }}
        style={{ flex: 1, backgroundColor: colors.background }}
        startInLoadingState
        onMessage={onMessage}
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
        androidLayerType="hardware"
        setSupportMultipleWindows={false}
      />
      {exited && (
        <TouchableOpacity
          onPress={() => navigation.goBack()}
          style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, padding: 14, alignItems: 'center' }}
        >
          <Text style={{ color: colors.mutedForeground }}>Process exited — tap to go back</Text>
        </TouchableOpacity>
      )}
    </KeyboardAvoidingView>
  );
}
