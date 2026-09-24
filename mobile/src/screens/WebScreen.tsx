import React, { useMemo, useRef } from 'react';
import { ActivityIndicator, Alert, Text, TouchableOpacity, View } from 'react-native';
import { useReanimatedKeyboardAnimation } from 'react-native-keyboard-controller';
import Reanimated, { useAnimatedStyle } from 'react-native-reanimated';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { WebView } from 'react-native-webview';
import { Command } from 'lucide-react-native';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';

// Keyboard shortcuts that exist in the PWA but have no hardware keys in a
// WebView — injected as synthetic keydown events.
const SHORTCUTS: { label: string; init: string }[] = [
  { label: 'Sessions (Ctrl+K)', init: "{key:'k',ctrlKey:true}" },
  { label: 'Command palette (Ctrl+Shift+K)', init: "{key:'k',ctrlKey:true,shiftKey:true}" },
  { label: 'Quick settings (Ctrl+,)', init: "{key:',',ctrlKey:true}" },
];

/**
 * Generic PWA-in-WebView screen: loads any in-app route (board, tasks, usage,
 * source-control, mcp, skills, prd, browser, settings) with token auth. The
 * web app's own responsive layout renders the mobile UI, giving full PWA
 * parity for surfaces that don't have a dedicated native screen yet.
 */
export default function WebScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const { height: kbHeightSV } = useReanimatedKeyboardAnimation();
  const kbPad = useAnimatedStyle(() => ({ paddingBottom: (kbHeightSV.value === 0 ? insets.bottom : 0) - kbHeightSV.value }));
  const route = useRoute<any>();
  const navigation = useNavigation<any>();
  const { path = '/' } = route.params ?? {};
  const webRef = useRef<WebView>(null);

  const injectShortcut = (init: string) => {
    webRef.current?.injectJavaScript(
      `window.dispatchEvent(new KeyboardEvent('keydown',${init}));document.dispatchEvent(new KeyboardEvent('keydown',${init}));true;`,
    );
  };

  React.useEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <TouchableOpacity
          onPress={() =>
            Alert.alert('Shortcuts', undefined, [
              ...SHORTCUTS.map((s) => ({ text: s.label, onPress: () => injectShortcut(s.init) })),
              { text: 'Cancel', style: 'cancel' as const },
            ])
          }
          hitSlop={8}
          style={{ padding: 6 }}
        >
          <Command size={18} color={colors.mutedForeground} />
        </TouchableOpacity>
      ),
    });
  }, [navigation, colors]);

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
    <Reanimated.View style={[{ flex: 1, backgroundColor: colors.background }, kbPad]}>
      <WebView
        ref={webRef}
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
    </Reanimated.View>
  );
}
