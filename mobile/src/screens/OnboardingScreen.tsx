import React, { useEffect, useMemo } from 'react';
import { ActivityIndicator, Text, View } from 'react-native';
import { WebView } from 'react-native-webview';
import { useTheme } from '../theme';
import { useAuth } from '../contexts/AuthContext';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';

/**
 * Onboarding gate: the web app renders its own <Onboarding> wizard inside
 * ProtectedRoute when hasCompletedOnboarding === false, so loading `/` shows
 * the real flow. We poll the status endpoint and flip the flag so the
 * navigator swaps to the drawer the moment the flow completes.
 */
export default function OnboardingScreen() {
  const { colors } = useTheme();
  const { refreshOnboarding } = useAuth();

  useEffect(() => {
    const tick = setInterval(refreshOnboarding, 3000);
    return () => clearInterval(tick);
  }, [refreshOnboarding]);

  const uri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    return base && token ? `${base}/?token=${encodeURIComponent(token)}` : null;
  }, []);

  if (!uri) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <Text style={{ color: colors.destructive }}>No server/token configured</Text>
      </View>
    );
  }

  return (
    <WebView
      source={{ uri }}
      style={{ flex: 1, backgroundColor: colors.background }}
      startInLoadingState
      renderLoading={() => (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      )}
      androidLayerType="hardware"
      setSupportMultipleWindows={false}
    />
  );
}
