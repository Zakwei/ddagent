import './src/polyfills';
import './src/i18n';
import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { useFonts } from 'expo-font';
import {
  EncodeSans_400Regular,
  EncodeSans_500Medium,
  EncodeSans_600SemiBold,
  EncodeSans_700Bold,
} from '@expo-google-fonts/encode-sans';
import {
  Merriweather_400Regular,
  Merriweather_400Regular_Italic,
  Merriweather_700Bold,
} from '@expo-google-fonts/merriweather';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { KeyboardProvider } from 'react-native-keyboard-controller';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { ThemeProvider, useTheme } from './src/theme';
import { AuthProvider } from './src/contexts/AuthContext';
import { WebSocketProvider } from './src/contexts/WebSocketContext';
import RootNavigator from './src/navigation/RootNavigator';
import AppLock from './src/components/AppLock';
import ErrorBoundary from './src/components/ErrorBoundary';
import { initPushHandlers } from './src/lib/push';
import { useEffect } from 'react';

function Shell() {
  const { isDark } = useTheme();
  useEffect(() => initPushHandlers(), []);
  return (
    <AppLock>
      <StatusBar style={isDark ? 'light' : 'dark'} />
      <ErrorBoundary>
        <RootNavigator />
      </ErrorBoundary>
    </AppLock>
  );
}

export default function App() {
  const [fontsLoaded] = useFonts({
    EncodeSans_400Regular,
    EncodeSans_500Medium,
    EncodeSans_600SemiBold,
    EncodeSans_700Bold,
    Merriweather_400Regular,
    Merriweather_400Regular_Italic,
    Merriweather_700Bold,
  });

  if (!fontsLoaded) return null;

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <KeyboardProvider>
      <SafeAreaProvider>
        <ThemeProvider>
          <AuthProvider>
            <WebSocketProvider>
              <Shell />
            </WebSocketProvider>
          </AuthProvider>
        </ThemeProvider>
      </SafeAreaProvider>
      </KeyboardProvider>
    </GestureHandlerRootView>
  );
}
