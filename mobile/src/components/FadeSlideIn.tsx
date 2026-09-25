/**
 * Native mirror of the web chat enter keyframes
 * (`chat-activity-enter`, `empty-state-enter`, `settings-fade-in`).
 * Web animates blur too; RN has no cheap blur, so we fade + rise + a slight
 * scaleY, which reads the same at these durations.
 */
import React, { useEffect, useRef } from 'react';
import { Animated, Easing, type ViewStyle } from 'react-native';

interface Props {
  children: React.ReactNode;
  style?: ViewStyle | ViewStyle[];
  duration?: number;
  /** Vertical travel in px (web uses 18 for activity, 6 for empty state). */
  offset?: number;
}

export function FadeSlideIn({ children, style, duration = 200, offset = 6 }: Props) {
  const progress = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(progress, {
      toValue: 1,
      duration,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [duration, progress]);

  const opacity = progress;
  const translateY = progress.interpolate({ inputRange: [0, 1], outputRange: [offset, 0] });
  const scaleY = progress.interpolate({ inputRange: [0, 0.65, 1], outputRange: [0.92, 1.01, 1] });

  return (
    <Animated.View style={[style, { opacity, transform: [{ translateY }, { scaleY }] }]}>
      {children}
    </Animated.View>
  );
}
