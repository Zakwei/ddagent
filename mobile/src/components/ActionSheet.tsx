import React from 'react';
import { Modal, Text, TouchableOpacity, View } from 'react-native';

import { useTheme } from '../theme';

export type ActionSheetItem = {
  label: string;
  destructive?: boolean;
  onPress: () => void;
};

/**
 * Android's RN Alert silently drops every button past the third — several of
 * our menus (session actions, message actions, header overflow) lost their
 * Cancel/destructive entries. Bottom-sheet Modal replacement with no cap.
 */
export function ActionSheet({
  visible,
  title,
  items,
  onClose,
}: {
  visible: boolean;
  title?: string;
  items: ActionSheetItem[];
  onClose: () => void;
}) {
  const { colors } = useTheme();
  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }} activeOpacity={1} onPress={onClose}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, paddingVertical: 8, marginHorizontal: 8, marginBottom: 8 }}>
          {title ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 13, textAlign: 'center', paddingVertical: 10 }} numberOfLines={2}>
              {title}
            </Text>
          ) : null}
          {items.map((item) => (
            <TouchableOpacity
              key={item.label}
              onPress={() => {
                onClose();
                item.onPress();
              }}
              style={{ paddingVertical: 14, paddingHorizontal: 20 }}
            >
              <Text style={{ color: item.destructive ? colors.destructive : colors.foreground, fontSize: 16, textAlign: 'center' }}>
                {item.label}
              </Text>
            </TouchableOpacity>
          ))}
          <TouchableOpacity onPress={onClose} style={{ paddingVertical: 14, borderTopWidth: 1, borderTopColor: colors.border, marginTop: 4 }}>
            <Text style={{ color: colors.primary, fontSize: 16, fontWeight: '600', textAlign: 'center' }}>Cancel</Text>
          </TouchableOpacity>
        </View>
      </TouchableOpacity>
    </Modal>
  );
}
