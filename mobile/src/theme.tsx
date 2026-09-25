import React, { createContext, useContext, useEffect, useMemo, useState } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useColorScheme } from 'react-native';

/**
 * Design tokens baked from src/index.css — identical palette to the web app.
 * CSS vars can't be resolved natively, so we keep the literal HSL values.
 */
const hsl = (h: number, s: number, l: number) => `hsl(${h}, ${s}%, ${l}%)`;

export const lightColors = {
  background: hsl(44, 22, 96),
  foreground: hsl(36, 25, 4),
  card: hsl(0, 0, 100),
  cardForeground: hsl(36, 25, 4),
  popover: hsl(0, 0, 100),
  popoverForeground: hsl(36, 25, 4),
  primary: hsl(221.2, 83.2, 53.3),
  primaryForeground: hsl(210, 40, 98),
  secondary: hsl(44, 15, 91),
  secondaryForeground: hsl(36, 15, 18),
  muted: hsl(44, 15, 91),
  mutedForeground: hsl(40, 5, 44),
  accent: hsl(44, 15, 91),
  accentForeground: hsl(36, 15, 18),
  destructive: hsl(0, 84.2, 60.2),
  destructiveForeground: hsl(210, 40, 98),
  border: hsl(44, 14, 87),
  input: hsl(44, 14, 87),
  ring: hsl(221.2, 83.2, 53.3),
};

export const darkColors = {
  background: hsl(0, 0, 8),
  foreground: hsl(40, 8, 93),
  card: hsl(0, 0, 12),
  cardForeground: hsl(40, 8, 93),
  popover: hsl(0, 0, 12),
  popoverForeground: hsl(40, 8, 93),
  primary: hsl(217.2, 91.2, 59.8),
  primaryForeground: hsl(0, 0, 8),
  secondary: hsl(0, 0, 17),
  secondaryForeground: hsl(40, 8, 93),
  muted: hsl(0, 0, 17),
  mutedForeground: hsl(0, 0, 60),
  accent: hsl(0, 0, 17),
  accentForeground: hsl(40, 8, 93),
  destructive: hsl(0, 62.8, 30.6),
  destructiveForeground: hsl(40, 8, 93),
  border: hsl(0, 0, 17),
  input: hsl(0, 0, 23),
  ring: hsl(217.2, 91.2, 59.8),
};

export type ThemeColors = typeof lightColors;
export type ThemeMode = 'light' | 'dark' | 'system';

const THEME_KEY = 'ddagent.theme';

interface ThemeContextValue {
  mode: ThemeMode;
  isDark: boolean;
  colors: ThemeColors;
  setMode: (mode: ThemeMode) => void;
}

const ThemeContext = createContext<ThemeContextValue>({
  mode: 'system',
  isDark: true,
  colors: darkColors,
  setMode: () => {},
});

export const useTheme = () => useContext(ThemeContext);
export const useIsDark = () => useContext(ThemeContext).isDark;

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const system = useColorScheme();
  const [mode, setModeState] = useState<ThemeMode>('system');

  useEffect(() => {
    AsyncStorage.getItem(THEME_KEY).then((v) => {
      if (v === 'light' || v === 'dark' || v === 'system') setModeState(v);
    });
  }, []);

  const setMode = (m: ThemeMode) => {
    setModeState(m);
    AsyncStorage.setItem(THEME_KEY, m);
  };

  const value = useMemo<ThemeContextValue>(() => {
    const isDark = mode === 'system' ? system !== 'light' : mode === 'dark';
    return { mode, isDark, colors: isDark ? darkColors : lightColors, setMode };
  }, [mode, system]);

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}
