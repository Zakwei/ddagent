// Native port of the web quick-settings handle + slide-over panel
// (`src/components/quick-settings-panel/**`). Mounted app-wide so a grip on the
// right edge opens a small panel with appearance / tool-display / input prefs.
import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Animated,
  PanResponder,
  ScrollView,
  Switch,
  Text,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ChevronLeft, ChevronRight, GripVertical, X } from 'lucide-react-native';
import { useTranslation } from 'react-i18next';
import { useTheme } from '../theme';
import { useUiPreferences } from '../lib/ui-preferences-store';
import { getLanguage, setLanguage } from '../i18n';
import {
  QUICK_SETTINGS_POSITION_KEY,
  clampHandlePosition,
  dragPositionFromDelta,
  parseHandlePosition,
  serializeHandlePosition,
} from '../lib/quick-settings';

const LANGUAGES = ['en', 'pl', 'de', 'es', 'fr', 'it', 'ja', 'ko', 'ru', 'tr', 'zh-CN', 'zh-TW'];

export default function QuickSettings() {
  const { colors, mode, setMode } = useTheme();
  const { width, height } = useWindowDimensions();
  const { preferences, setPreference } = useUiPreferences();
  const { t } = useTranslation('settings');
  const [open, setOpen] = useState(false);
  const [pos, setPos] = useState(50);
  const [lang, setLang] = useState(getLanguage());
  const posRef = useRef(50);
  const startRef = useRef(50);
  const slide = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    void AsyncStorage.getItem(QUICK_SETTINGS_POSITION_KEY).then((raw) => {
      const y = parseHandlePosition(raw);
      posRef.current = y;
      setPos(y);
    });
  }, []);

  const persist = (y: number) => {
    posRef.current = y;
    setPos(y);
    void AsyncStorage.setItem(QUICK_SETTINGS_POSITION_KEY, serializeHandlePosition(y));
  };

  const pan = useMemo(
    () =>
      PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onMoveShouldSetPanResponder: (_e, g) => Math.abs(g.dy) > 4,
        onPanResponderGrant: () => {
          startRef.current = posRef.current;
        },
        onPanResponderMove: (_e, g) => {
          const next = dragPositionFromDelta({
            startPct: startRef.current,
            deltaY: g.dy,
            viewportHeight: height > 0 ? height : 800,
            mobile: true,
          });
          setPos(next);
        },
        onPanResponderRelease: (_e, g) => {
          const next = clampHandlePosition(
            dragPositionFromDelta({
              startPct: startRef.current,
              deltaY: g.dy,
              viewportHeight: height > 0 ? height : 800,
              mobile: true,
            }),
          );
          persist(next);
        },
      }),
    [],
  );

  useEffect(() => {
    Animated.timing(slide, {
      toValue: open ? 1 : 0,
      duration: 220,
      useNativeDriver: true,
    }).start();
  }, [open, slide]);

  const top = `${pos}%` as `${number}%`;

  return (
    <>
      <Animated.View
        pointerEvents="box-none"
        style={{
          position: 'absolute',
          right: open ? 0 : -(Math.min(256, width * 0.8) + 16),
          top,
          marginTop: -24,
          zIndex: 9998,
        }}
      >
        <Animated.View
          style={{
            transform: [{ translateX: slide.interpolate({ inputRange: [0, 1], outputRange: [-24, 0] }) }],
          }}
        >
          <TouchableOpacity
            onPress={() => setOpen((v) => !v)}
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              backgroundColor: colors.card,
              borderWidth: 1,
              borderColor: colors.border,
              borderRadius: 8,
              paddingVertical: 10,
              paddingHorizontal: 4,
            }}
          >
            <View {...pan.panHandlers}>
              <GripVertical size={16} color={colors.mutedForeground} />
            </View>
            {open ? (
              <ChevronRight size={14} color={colors.mutedForeground} />
            ) : (
              <ChevronLeft size={14} color={colors.mutedForeground} />
            )}
          </TouchableOpacity>
        </Animated.View>
      </Animated.View>

      {open ? (
        <View
          style={{
            position: 'absolute',
            right: 0,
            top: 0,
            bottom: 0,
            width: Math.min(256, width * 0.8),
            zIndex: 9999,
          }}
        >
          <View
            style={{
              flex: 1,
              backgroundColor: colors.card,
              borderLeftWidth: 1,
              borderLeftColor: colors.border,
              paddingTop: 48,
            }}
          >
            <View
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                paddingHorizontal: 16,
                paddingBottom: 10,
                borderBottomWidth: 1,
                borderBottomColor: colors.border,
              }}
            >
              <Text style={{ flex: 1, color: colors.foreground, fontWeight: '700', fontSize: 14 }}>
                {t('quickSettings.title', { defaultValue: 'Quick settings' })}
              </Text>
              <TouchableOpacity onPress={() => setOpen(false)} hitSlop={8}>
                <X size={18} color={colors.mutedForeground} />
              </TouchableOpacity>
            </View>

            <ScrollView contentContainerStyle={{ padding: 16, gap: 18 }}>
              <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase' }}>
                {t('quickSettings.sections.appearance', { defaultValue: 'Appearance' })}
              </Text>
              <Row
                label={t('quickSettings.darkMode', { defaultValue: 'Dark mode' })}
                colors={colors}
                right={
                  <Switch
                    value={mode === 'dark'}
                    onValueChange={(v) => setMode(v ? 'dark' : 'light')}
                  />
                }
              />
              <View style={{ gap: 8 }}>
                <Text style={{ color: colors.foreground, fontSize: 13 }}>
                  {t('quickSettings.language', { defaultValue: 'Language' })}
                </Text>
                <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6 }}>
                  {LANGUAGES.map((l) => (
                    <TouchableOpacity
                      key={l}
                      onPress={() => {
                        setLang(l);
                        void setLanguage(l);
                      }}
                      style={{
                        paddingHorizontal: 10,
                        paddingVertical: 5,
                        borderRadius: 6,
                        backgroundColor: lang === l ? colors.primary : colors.secondary,
                      }}
                    >
                      <Text
                        style={{
                          color: lang === l ? colors.primaryForeground : colors.secondaryForeground,
                          fontSize: 11,
                        }}
                      >
                        {l}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>

              <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase' }}>
                {t('quickSettings.sections.toolDisplay', { defaultValue: 'Tool display' })}
              </Text>
              <Row
                label={t('quickSettings.showRawParameters', { defaultValue: 'Show raw parameters' })}
                colors={colors}
                right={
                  <Switch
                    value={preferences.showRawParameters}
                    onValueChange={(v) => void setPreference('showRawParameters', v)}
                  />
                }
              />
              <Row
                label={t('quickSettings.showThinking', { defaultValue: 'Show thinking' })}
                colors={colors}
                right={
                  <Switch
                    value={preferences.showThinking}
                    onValueChange={(v) => void setPreference('showThinking', v)}
                  />
                }
              />

              <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase' }}>
                {t('quickSettings.sections.inputSettings', { defaultValue: 'Input settings' })}
              </Text>
              <Row
                label={t('quickSettings.sendByCtrlEnter', { defaultValue: 'Send with Ctrl/⌘+Enter' })}
                colors={colors}
                right={
                  <Switch
                    value={preferences.sendByCtrlEnter}
                    onValueChange={(v) => void setPreference('sendByCtrlEnter', v)}
                  />
                }
              />
            </ScrollView>
          </View>
        </View>
      ) : null}
    </>
  );
}

function Row({
  label,
  right,
  colors,
}: {
  label: string;
  right: React.ReactNode;
  colors: ReturnType<typeof useTheme>['colors'];
}) {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
      <Text style={{ flex: 1, color: colors.foreground, fontSize: 13 }}>{label}</Text>
      {right}
    </View>
  );
}
