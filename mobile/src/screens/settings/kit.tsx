import React from 'react';
import { Switch, Text, TextInput, TouchableOpacity, View } from 'react-native';
import type { ThemeColors } from '../../theme';

export type SettingsT = (key: string, fallback: string, opts?: Record<string, unknown>) => string;

export function Section({ title, colors, children }: { title: string; colors: ThemeColors; children: React.ReactNode }) {
  return (
    <View style={{ marginBottom: 24 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12, fontWeight: '600', letterSpacing: 0.6, marginBottom: 8, textTransform: 'uppercase' }}>{title}</Text>
      <View style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 14, gap: 12 }}>{children}</View>
    </View>
  );
}

export function Field({
  label,
  value,
  onChangeText,
  placeholder,
  colors,
  secureTextEntry,
  help,
  keyboardType,
}: {
  label?: string;
  value: string;
  onChangeText: (v: string) => void;
  placeholder?: string;
  colors: ThemeColors;
  secureTextEntry?: boolean;
  help?: string;
  keyboardType?: 'default' | 'email-address';
}) {
  return (
    <View style={{ gap: 4 }}>
      {label ? <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{label}</Text> : null}
      <TextInput
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={colors.mutedForeground}
        secureTextEntry={secureTextEntry}
        keyboardType={keyboardType}
        autoCapitalize="none"
        autoCorrect={false}
        style={{
          backgroundColor: colors.background,
          borderColor: colors.border,
          borderWidth: 1,
          borderRadius: 8,
          color: colors.foreground,
          paddingHorizontal: 12,
          paddingVertical: 10,
          fontSize: 14,
        }}
      />
      {help ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{help}</Text> : null}
    </View>
  );
}

export function Toggle({
  label,
  description,
  value,
  onValueChange,
  colors,
}: {
  label: string;
  description?: string;
  value: boolean;
  onValueChange: (v: boolean) => void;
  colors: ThemeColors;
}) {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: 12 }}>
      <View style={{ flex: 1 }}>
        <Text style={{ color: colors.foreground, fontSize: 14 }}>{label}</Text>
        {description ? <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }}>{description}</Text> : null}
      </View>
      <Switch value={value} onValueChange={onValueChange} trackColor={{ true: colors.primary }} />
    </View>
  );
}

export function Btn({
  label,
  onPress,
  colors,
  disabled,
  variant = 'solid',
  icon,
}: {
  label: string;
  onPress: () => void;
  colors: ThemeColors;
  disabled?: boolean;
  variant?: 'solid' | 'outline' | 'destructive';
  icon?: React.ReactNode;
}) {
  const bg = variant === 'solid' ? colors.primary : variant === 'destructive' ? colors.destructive : 'transparent';
  const fg = variant === 'outline' ? colors.foreground : colors.primaryForeground;
  return (
    <TouchableOpacity
      onPress={onPress}
      disabled={disabled}
      style={{
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 6,
        backgroundColor: bg,
        borderColor: variant === 'outline' ? colors.border : bg,
        borderWidth: 1,
        borderRadius: 8,
        paddingHorizontal: 14,
        paddingVertical: 10,
        opacity: disabled ? 0.5 : 1,
      }}
    >
      {icon}
      <Text style={{ color: fg, fontSize: 14, fontWeight: '600' }}>{label}</Text>
    </TouchableOpacity>
  );
}

export function StatusLine({ status, colors }: { status: string | null; colors: ThemeColors }) {
  if (!status) return null;
  const ok = status.startsWith('✓');
  return <Text style={{ color: ok ? '#10b981' : colors.destructive, fontSize: 12 }}>{status}</Text>;
}
