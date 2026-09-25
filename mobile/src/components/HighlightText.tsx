import React from 'react';
import { Text, TextStyle, StyleProp } from 'react-native';
import { splitHighlight } from '../lib/chat-search';

interface HighlightTextProps {
  text: string;
  query: string;
  style?: StyleProp<TextStyle>;
  highlightColor?: string;
  highlightTextColor?: string;
  numberOfLines?: number;
}

/** RN equivalent of the web HighlightText — yellow mark around query matches. */
export function HighlightText({ text, query, style, highlightColor = '#fde68a', highlightTextColor = '#78350f', numberOfLines }: HighlightTextProps) {
  if (!query.trim()) {
    return (
      <Text style={style} numberOfLines={numberOfLines}>
        {text}
      </Text>
    );
  }
  return (
    <Text style={style} numberOfLines={numberOfLines}>
      {splitHighlight(text, query).map((part, i) =>
        part.isMatch ? (
          <Text key={i} style={{ backgroundColor: highlightColor, color: highlightTextColor }}>
            {part.text}
          </Text>
        ) : (
          <Text key={i}>{part.text}</Text>
        ),
      )}
    </Text>
  );
}
