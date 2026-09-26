import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import ChatScreen from '../screens/ChatScreen';

/**
 * A self-contained navigation stack for one split-workspace chat pane, so the
 * full native chat can be mounted *inside* a pane (web parity: a chat pane is a
 * real chat, not a stub). Each pane gets its own stack → its own ChatScreen
 * instance with independent session/messages.
 *
 * Unknown routes reached from inside the pane (e.g. `Editor`, `Terminal`) are
 * not registered here; React Navigation logs an unhandled-action warning and
 * ignores them rather than crashing — cross-screen jumps stay available from
 * the full-screen chat.
 */
const PaneStack = createNativeStackNavigator();

export default function ChatPaneStack({
  sessionId,
  projectId,
  projectPath,
  provider,
  newSession,
  paneId,
}: {
  sessionId?: string | null;
  projectId?: string | null;
  projectPath?: string | null;
  provider?: string | null;
  newSession?: boolean;
  paneId: string;
}) {
  return (
    <PaneStack.Navigator screenOptions={{ headerShown: false }}>
      <PaneStack.Screen
        name="ChatPane"
        component={ChatScreen}
        initialParams={{
          sessionId: sessionId ?? undefined,
          projectId: projectId ?? undefined,
          projectPath: projectPath ?? undefined,
          provider: provider ?? undefined,
          newSession: newSession || !sessionId,
          paneId,
        }}
      />
    </PaneStack.Navigator>
  );
}
