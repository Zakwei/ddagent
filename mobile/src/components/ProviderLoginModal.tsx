import React, { useMemo } from 'react';
import { ActivityIndicator, Modal, Text, TouchableOpacity, View } from 'react-native';
import { WebView } from 'react-native-webview';
import { X } from 'lucide-react-native';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';
import { providerDisplayName, providerLoginCommand } from '../lib/onboarding';

interface ProviderLoginModalProps {
  visible: boolean;
  provider: string | null;
  onClose: () => void;
}

/**
 * Interactive CLI login for a provider (T28).
 *
 * The web ProviderLoginModal runs `claude /login` etc. in an xterm shell with a
 * sentinel project. RN has no xterm, so we host the terminal island in a
 * WebView with `?command=` — exact same CLI, same surface as the web modal.
 */
export default function ProviderLoginModal({ visible, provider, onClose }: ProviderLoginModalProps) {
  const { colors } = useTheme();

  const uri = useMemo(() => {
    if (!visible || !provider) return null;
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    const command = encodeURIComponent(providerLoginCommand(provider));
    return `${base}/island/terminal?command=${command}&token=${encodeURIComponent(token)}`;
  }, [visible, provider]);

  if (!visible || !provider) return null;

  return (
    <Modal visible transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: colors.background }}>
        <View style={{ flexDirection: 'row', alignItems: 'center', padding: 14, paddingTop: 44, borderBottomWidth: 1, borderBottomColor: colors.border, backgroundColor: colors.card }}>
          <Text style={{ flex: 1, color: colors.foreground, fontWeight: '600', fontSize: 16 }}>
            {`${providerDisplayName(provider)} CLI Login`}
          </Text>
          <TouchableOpacity onPress={onClose} hitSlop={10} style={{ padding: 6 }}>
            <X color={colors.mutedForeground} size={22} />
          </TouchableOpacity>
        </View>
        {uri ? (
          <WebView
            source={{ uri }}
            style={{ flex: 1, backgroundColor: '#000' }}
            startInLoadingState
            renderLoading={() => (
              <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
                <ActivityIndicator color={colors.primary} size="large" />
              </View>
            )}
            androidLayerType="hardware"
            setSupportMultipleWindows={false}
            keyboardDisplayRequiresUserAction={false}
          />
        ) : (
          <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
            <Text style={{ color: colors.destructive }}>No server/token configured</Text>
          </View>
        )}
      </View>
    </Modal>
  );
}
