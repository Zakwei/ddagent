import React, { useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useRoute } from '@react-navigation/native';
import { WebView } from 'react-native-webview';
import { Pencil } from 'lucide-react-native';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';

const PREVIEW_LIMIT = 200 * 1024;

/**
 * File screen: fast native preview by default, CodeMirror island (the same
 * editor bundle as the web app) when the user taps Edit.
 */
export default function EditorScreen() {
  const { colors } = useTheme();
  const route = useRoute<any>();
  const { projectId, filePath } = route.params;
  const [mode, setMode] = useState<'preview' | 'edit'>('preview');
  const [content, setContent] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        const res = await api.readFile(projectId, filePath);
        if (!res.ok) {
          setError(`http-${res.status}`);
          return;
        }
        const data = await res.json().catch(() => null);
        const text = typeof data === 'string' ? data : data?.content ?? '';
        setContent(text.length > PREVIEW_LIMIT ? text.slice(0, PREVIEW_LIMIT) : text);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'load failed');
      } finally {
        setLoading(false);
      }
    })();
  }, [projectId, filePath]);

  const editorUri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    return `${base}/island/editor?project=${encodeURIComponent(projectId)}&path=${encodeURIComponent(filePath)}&token=${encodeURIComponent(token)}`;
  }, [projectId, filePath]);

  if (mode === 'edit' && editorUri) {
    return (
      <WebView
        source={{ uri: editorUri }}
        style={{ flex: 1, backgroundColor: colors.background }}
        startInLoadingState
        renderLoading={() => (
          <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
            <ActivityIndicator color={colors.primary} size="large" />
          </View>
        )}
      />
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <TouchableOpacity
        onPress={() => setMode('edit')}
        style={{ position: 'absolute', right: 16, bottom: 24, zIndex: 10, backgroundColor: colors.primary, borderRadius: 28, padding: 14 }}
      >
        <Pencil color={colors.primaryForeground} size={20} />
      </TouchableOpacity>
      {loading ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      ) : error ? (
        <Text style={{ color: colors.destructive, textAlign: 'center', marginTop: 48 }}>{error}</Text>
      ) : (
        <ScrollView contentContainerStyle={{ padding: 12 }}>
          <Text style={{ color: colors.foreground, fontFamily: 'monospace', fontSize: 12 }}>{content}</Text>
        </ScrollView>
      )}
    </View>
  );
}
