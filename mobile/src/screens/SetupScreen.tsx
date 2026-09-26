import React, { useState } from 'react';
import { ActivityIndicator, Text, TextInput, TouchableOpacity } from 'react-native';
import { useReanimatedKeyboardAnimation } from 'react-native-keyboard-controller';
import Reanimated, { useAnimatedStyle } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../theme';
import { useAuth } from '../contexts/AuthContext';
import { AmbientBackdrop } from '../components/AmbientBackdrop';
import { setupErrorsEmpty, validateSetup } from '../lib/onboarding';

/**
 * First-run account setup. Shown when `GET /api/auth/status` reports
 * `needsSetup: true` (a fresh server with no users). Mirrors the web
 * SetupForm; the register endpoint returns `{success,user,token}`.
 */
export default function SetupScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const { height: kbHeightSV } = useReanimatedKeyboardAnimation();
  const kbPad = useAnimatedStyle(() => ({ paddingBottom: 24 + insets.bottom - kbHeightSV.value }));
  const { register } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const submit = async () => {
    const errors = validateSetup(username.trim(), password, confirmPassword);
    if (!setupErrorsEmpty(errors)) {
      if (errors.allFields) setError('Please fill in all fields.');
      else if (errors.usernameLength) setError('Username must be at least 3 characters long.');
      else if (errors.passwordLength) setError('Password must be at least 6 characters long.');
      else setError('Passwords do not match.');
      return;
    }
    setError(null);
    setBusy(true);
    const res = await register(username.trim(), password);
    setBusy(false);
    if (!res.ok) setError(`Failed to create account (${res.error})`);
  };

  const inputStyle = {
    width: '100%' as const,
    backgroundColor: colors.card,
    color: colors.foreground,
    borderColor: colors.border,
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 14,
    paddingVertical: 12,
    marginBottom: 12,
  };

  return (
    <Reanimated.View
      style={[{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center', padding: 24, paddingTop: 24 + insets.top }, kbPad]}
    >
      <AmbientBackdrop />
      <Text style={{ color: colors.foreground, fontSize: 28, fontWeight: '700' }}>Welcome to ddagent</Text>
      <Text style={{ color: colors.mutedForeground, marginTop: 6, marginBottom: 28 }}>Set up your account to get started</Text>
      <TextInput value={username} onChangeText={setUsername} placeholder="Username" placeholderTextColor={colors.mutedForeground} autoCapitalize="none" autoCorrect={false} style={inputStyle} />
      <TextInput value={password} onChangeText={setPassword} placeholder="Password" placeholderTextColor={colors.mutedForeground} secureTextEntry style={inputStyle} />
      <TextInput value={confirmPassword} onChangeText={setConfirmPassword} placeholder="Confirm password" placeholderTextColor={colors.mutedForeground} secureTextEntry onSubmitEditing={submit} style={inputStyle} />
      {error && <Text style={{ color: colors.destructive, marginBottom: 12, textAlign: 'center' }}>{error}</Text>}
      <TouchableOpacity onPress={submit} disabled={busy} style={{ width: '100%', backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 14, alignItems: 'center', opacity: busy ? 0.6 : 1 }}>
        {busy ? <ActivityIndicator color={colors.primaryForeground} /> : <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Create account</Text>}
      </TouchableOpacity>
    </Reanimated.View>
  );
}
