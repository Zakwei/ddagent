import React, { useMemo, useRef, useState } from 'react';
import { ActivityIndicator, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { WebView, WebViewMessageEvent } from 'react-native-webview';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';

/**
 * Special keys dispatched into the island's xterm helper textarea as synthetic
 * KeyboardEvents — the shell WS lives inside the WebView, so input must be
 * injected there, not proxied through RN.
 */
const KEYS: { label: string; key: string; code?: string }[] = [
  { label: 'Esc', key: 'Escape' },
  { label: 'Tab', key: 'Tab' },
  { label: '↑', key: 'ArrowUp' },
  { label: '↓', key: 'ArrowDown' },
  { label: '←', key: 'ArrowLeft' },
  { label: '→', key: 'ArrowRight' },
  { label: 'Ctrl+C', key: 'c', code: 'ctrl' },
  { label: 'Ctrl+D', key: 'd', code: 'ctrl' },
];

const keyJs = (key: string, ctrl: boolean) => `
  (function() {
    var ta = document.querySelector('.xterm-helper-textarea') || document.activeElement;
    if (!ta) return;
    ta.dispatchEvent(new KeyboardEvent('keydown', {
      key: ${JSON.stringify(key)},
      ctrlKey: ${ctrl},
      bubbles: true,
      cancelable: true
    }));
  })();
  true;
`;

export default function TerminalScreen() {
  const { colors } = useTheme();
  const navigation = useNavigation<any>();
  const route = useRoute<any>();
  const { sessionId } = route.params;
  const webRef = useRef<WebView>(null);
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
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <WebView
        ref={webRef}
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
      {/* Accessory key row */}
      <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border }}>
        <ScrollView horizontal keyboardShouldPersistTaps="always" contentContainerStyle={{ padding: 6, gap: 6 }}>
          {KEYS.map((k) => (
            <TouchableOpacity
              key={k.label}
              onPress={() => webRef.current?.injectJavaScript(keyJs(k.key, k.code === 'ctrl'))}
              style={{ backgroundColor: colors.secondary, borderRadius: 6, paddingHorizontal: 14, paddingVertical: 8 }}
            >
              <Text style={{ color: colors.secondaryForeground, fontSize: 13, fontFamily: 'monospace' }}>{k.label}</Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>
    </View>
  );
}
