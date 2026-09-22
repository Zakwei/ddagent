import React, { useCallback, useEffect, useRef, useState } from 'react';
import { AppState, Text, TouchableOpacity, View } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as LocalAuthentication from 'expo-local-authentication';
import { Fingerprint } from 'lucide-react-native';
import { useTheme } from '../theme';

const LOCK_KEY = 'ddagent.appLock';

export const isAppLockEnabled = () => AsyncStorage.getItem(LOCK_KEY).then((v) => v === '1');
export const setAppLockEnabled = (on: boolean) => AsyncStorage.setItem(LOCK_KEY, on ? '1' : '0');

/**
 * Biometric/device-credential gate. When enabled in Settings, locks the app on
 * cold start and on every background→foreground transition.
 */
export default function AppLock({ children }: { children: React.ReactNode }) {
  const { colors } = useTheme();
  const [enabled, setEnabled] = useState(false);
  const [locked, setLocked] = useState(false);
  const promptingRef = useRef(false);

  const unlock = useCallback(async () => {
    if (promptingRef.current) return;
    promptingRef.current = true;
    try {
      const res = await LocalAuthentication.authenticateAsync({
        promptMessage: 'Unlock ddagent',
        cancelLabel: 'Cancel',
        disableDeviceFallback: false,
      });
      if (res.success) setLocked(false);
    } finally {
      promptingRef.current = false;
    }
  }, []);

  useEffect(() => {
    void isAppLockEnabled().then((on) => {
      setEnabled(on);
      if (on) {
        setLocked(true);
        void unlock();
      }
    });
  }, [unlock]);

  useEffect(() => {
    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'background' && enabled) setLocked(true);
      if (state === 'active' && enabled) void unlock();
    });
    return () => sub.remove();
  }, [enabled, unlock]);

  if (!enabled || !locked) return <>{children}</>;

  return (
    <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center', gap: 16 }}>
      <Fingerprint size={48} color={colors.mutedForeground} />
      <TouchableOpacity
        onPress={unlock}
        style={{ backgroundColor: colors.primary, borderRadius: 10, paddingHorizontal: 24, paddingVertical: 12 }}
      >
        <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Unlock</Text>
      </TouchableOpacity>
    </View>
  );
}
