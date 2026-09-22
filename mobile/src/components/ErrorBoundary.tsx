import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';

interface Props {
  children: React.ReactNode;
}
interface State {
  error: Error | null;
}

/** Top-level crash guard — shows the error + a retry that remounts the tree. */
export default class ErrorBoundary extends React.Component<Props, State> {
  state: State = { error: null };

  static getDerivedStateFromError(error: Error): State {
    return { error };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    console.error('App error boundary:', error, info.componentStack);
  }

  render() {
    if (!this.state.error) return this.props.children;
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32, backgroundColor: '#0b0b0f' }}>
        <Text style={{ color: '#fff', fontSize: 18, fontWeight: '600', marginBottom: 8 }}>Something went wrong</Text>
        <Text style={{ color: '#999', fontSize: 13, textAlign: 'center', marginBottom: 24 }} numberOfLines={6}>
          {this.state.error.message}
        </Text>
        <TouchableOpacity
          onPress={() => this.setState({ error: null })}
          style={{ backgroundColor: '#6366f1', borderRadius: 10, paddingHorizontal: 24, paddingVertical: 12 }}
        >
          <Text style={{ color: '#fff', fontWeight: '600' }}>Try again</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
