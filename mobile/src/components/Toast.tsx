import { useCallback, useEffect, useState } from 'react';
import { View, Text } from 'react-native';
import { Check, X } from 'lucide-react-native';

export type ToastType = 'success' | 'error';

export interface ToastState {
  message: string;
  type: ToastType;
}

/** Auto-hiding toast state mirroring the web notification pattern. */
export function useToast(timeoutMs = 3000) {
  const [toast, setToast] = useState<ToastState | null>(null);

  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => setToast(null), timeoutMs);
    return () => clearTimeout(timer);
  }, [toast, timeoutMs]);

  const show = useCallback((message: string, type: ToastType = 'success') => {
    setToast({ message, type });
  }, []);
  const clear = useCallback(() => setToast(null), []);

  return { toast, show, clear };
}

/** Bottom-right status pill (green success / red error), matching the web toast. */
export function Toast({ toast }: { toast: ToastState }) {
  const background = toast.type === 'success' ? '#16a34a' : '#dc2626';
  return (
    <View
      style={{
        position: 'absolute',
        left: 12,
        right: 12,
        bottom: 16,
        alignItems: 'center',
      }}
      pointerEvents="none"
    >
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          gap: 8,
          backgroundColor: background,
          borderRadius: 8,
          paddingHorizontal: 14,
          paddingVertical: 8,
          shadowColor: '#000',
          shadowOpacity: 0.2,
          shadowRadius: 8,
          elevation: 4,
        }}
      >
        {toast.type === 'success' ? (
          <Check size={14} color="#ffffff" />
        ) : (
          <X size={14} color="#ffffff" />
        )}
        <Text style={{ color: '#ffffff', fontSize: 12 }}>{toast.message}</Text>
      </View>
    </View>
  );
}
