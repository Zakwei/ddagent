import React, { useState } from 'react';
import { ActivityIndicator, KeyboardAvoidingView, Platform, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useTheme } from '../theme';
import { setServerUrl, testConnection } from '../lib/server-config';

export default function ServerConnectScreen() {
  const { colors } = useTheme();
  const [url, setUrl] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const connect = async () => {
    setBusy(true);
    setError(null);
    const probe = await testConnection(url);
    if (!probe.ok) {
      setError(probe.error === 'empty-url' ? 'Enter a server URL' : `Connection failed (${probe.error})`);
      setBusy(false);
      return;
    }
    await setServerUrl(url);
    setBusy(false);
    // onServerUrlChange flips RootNavigator's hasServer → Login mounts automatically.
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center', padding: 24 }}
    >
      <Text style={{ color: colors.foreground, fontSize: 28, fontWeight: '700', marginBottom: 8 }}>ddagent</Text>
      <Text style={{ color: colors.mutedForeground, marginBottom: 32, textAlign: 'center' }}>
        Connect to your ddagent server
      </Text>
      <TextInput
        value={url}
        onChangeText={setUrl}
        placeholder="https://your-server:10087"
        placeholderTextColor={colors.mutedForeground}
        autoCapitalize="none"
        autoCorrect={false}
        keyboardType="url"
        style={{
          width: '100%',
          backgroundColor: colors.card,
          color: colors.foreground,
          borderColor: colors.border,
          borderWidth: 1,
          borderRadius: 8,
          paddingHorizontal: 14,
          paddingVertical: 12,
          marginBottom: 12,
        }}
      />
      {error && <Text style={{ color: colors.destructive, marginBottom: 12 }}>{error}</Text>}
      <TouchableOpacity
        onPress={connect}
        disabled={busy}
        style={{
          width: '100%',
          backgroundColor: colors.primary,
          borderRadius: 8,
          paddingVertical: 14,
          alignItems: 'center',
          opacity: busy ? 0.6 : 1,
        }}
      >
        {busy ? <ActivityIndicator color={colors.primaryForeground} /> : <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Connect</Text>}
      </TouchableOpacity>
    </KeyboardAvoidingView>
  );
}
