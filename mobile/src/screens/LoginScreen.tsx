import React, { useState } from 'react';
import { ActivityIndicator, Text, TextInput, TouchableOpacity } from 'react-native';
import { useReanimatedKeyboardAnimation } from 'react-native-keyboard-controller';
import Reanimated, { useAnimatedStyle } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../theme';
import { useAuth } from '../contexts/AuthContext';
import { clearServerUrl } from '../lib/server-config';

export default function LoginScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const { height: kbHeightSV } = useReanimatedKeyboardAnimation();
  const kbPad = useAnimatedStyle(() => ({ paddingBottom: 24 + insets.bottom - kbHeightSV.value }));
  const { login } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const submit = async () => {
    setBusy(true);
    setError(null);
    const res = await login(username.trim(), password);
    setBusy(false);
    if (!res.ok) setError(res.error === 'http-401' ? 'Invalid credentials' : `Login failed (${res.error})`);
  };

  const changeServer = () => clearServerUrl();

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
      <Text style={{ color: colors.foreground, fontSize: 28, fontWeight: '700', marginBottom: 32 }}>ddagent</Text>
      <TextInput value={username} onChangeText={setUsername} placeholder="Username" placeholderTextColor={colors.mutedForeground} autoCapitalize="none" autoCorrect={false} style={inputStyle} />
      <TextInput value={password} onChangeText={setPassword} placeholder="Password" placeholderTextColor={colors.mutedForeground} secureTextEntry onSubmitEditing={submit} style={inputStyle} />
      {error && <Text style={{ color: colors.destructive, marginBottom: 12 }}>{error}</Text>}
      <TouchableOpacity onPress={submit} disabled={busy} style={{ width: '100%', backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 14, alignItems: 'center', opacity: busy ? 0.6 : 1 }}>
        {busy ? <ActivityIndicator color={colors.primaryForeground} /> : <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Sign in</Text>}
      </TouchableOpacity>
      <TouchableOpacity onPress={changeServer} style={{ marginTop: 20 }}>
        <Text style={{ color: colors.mutedForeground }}>Change server</Text>
      </TouchableOpacity>
    </Reanimated.View>
  );
}
