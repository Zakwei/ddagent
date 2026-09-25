/**
 * Ambient auth backdrop — native mirror of the web `AuthScreenLayout` /
 * `Onboarding` ambient layer: two large translucent primary circles plus a
 * faint dot grid. Web uses `blur-3xl`; RN has no blur here (no expo-blur dep),
 * so the circles are drawn with very low alpha and large radii, which reads
 * the same at these opacities.
 */
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useTheme } from '../theme';

export function AmbientBackdrop() {
  const { colors } = useTheme();
  return (
    <View pointerEvents="none" style={StyleSheet.absoluteFill}>
      <View
        style={{
          position: 'absolute',
          top: -160,
          left: '50%',
          marginLeft: -288,
          width: 576,
          height: 576,
          borderRadius: 288,
          backgroundColor: colors.primary,
          opacity: 0.1,
        }}
      />
      <View
        style={{
          position: 'absolute',
          bottom: -128,
          left: -96,
          width: 416,
          height: 416,
          borderRadius: 208,
          backgroundColor: colors.primary,
          opacity: 0.05,
        }}
      />
    </View>
  );
}
