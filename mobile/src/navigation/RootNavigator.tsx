import React, { useEffect, useState } from 'react';
import { ActivityIndicator, View } from 'react-native';
import { DarkTheme, DefaultTheme, NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../theme';
import { getServerUrlSync, loadServerUrl } from '../lib/server-config';
import ServerConnectScreen from '../screens/ServerConnectScreen';
import LoginScreen from '../screens/LoginScreen';
import ProjectsScreen from '../screens/ProjectsScreen';
import SessionsScreen from '../screens/SessionsScreen';
import ChatScreen from '../screens/ChatScreen';
import TerminalScreen from '../screens/TerminalScreen';
import FileTreeScreen from '../screens/FileTreeScreen';
import EditorScreen from '../screens/EditorScreen';
import SettingsScreen from '../screens/SettingsScreen';

export type RootStackParamList = {
  ServerConnect: undefined;
  Login: undefined;
  Main: undefined;
  Sessions: { projectId: string; projectName?: string };
  Chat: { sessionId: string; title?: string };
  Terminal: { sessionId: string };
  Editor: { projectId: string; filePath: string };
};

export type DrawerParamList = {
  Projects: undefined;
  Files: { projectId?: string } | undefined;
  Settings: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();
const Drawer = createDrawerNavigator<DrawerParamList>();

function MainDrawer() {
  const { colors } = useTheme();
  return (
    <Drawer.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.card },
        headerTintColor: colors.foreground,
        drawerStyle: { backgroundColor: colors.card },
        drawerActiveTintColor: colors.primary,
        drawerInactiveTintColor: colors.mutedForeground,
      }}
    >
      <Drawer.Screen name="Projects" component={ProjectsScreen} />
      <Drawer.Screen name="Files" component={FileTreeScreen} />
      <Drawer.Screen name="Settings" component={SettingsScreen} />
    </Drawer.Navigator>
  );
}

export default function RootNavigator() {
  const { colors, isDark } = useTheme();
  const { user, isLoading } = useAuth();
  const [serverChecked, setServerChecked] = useState(false);
  const [hasServer, setHasServer] = useState<boolean>(!!getServerUrlSync());

  useEffect(() => {
    loadServerUrl().then((url) => {
      setHasServer(!!url);
      setServerChecked(true);
    });
  }, []);

  if (!serverChecked || (hasServer && isLoading)) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <ActivityIndicator color={colors.primary} size="large" />
      </View>
    );
  }

  const navTheme = {
    ...(isDark ? DarkTheme : DefaultTheme),
    colors: {
      ...(isDark ? DarkTheme.colors : DefaultTheme.colors),
      background: colors.background,
      card: colors.card,
      primary: colors.primary,
      text: colors.foreground,
      border: colors.border,
    },
  };

  return (
    <NavigationContainer theme={navTheme}>
      <Stack.Navigator
        screenOptions={{
          headerStyle: { backgroundColor: colors.card },
          headerTintColor: colors.foreground,
          contentStyle: { backgroundColor: colors.background },
        }}
      >
        {!hasServer ? (
          <Stack.Screen name="ServerConnect" component={ServerConnectScreen} options={{ headerShown: false }} />
        ) : !user ? (
          <Stack.Screen name="Login" component={LoginScreen} options={{ headerShown: false }} />
        ) : (
          <>
            <Stack.Screen name="Main" component={MainDrawer} options={{ headerShown: false }} />
            <Stack.Screen
              name="Sessions"
              component={SessionsScreen}
              options={({ route }) => ({ title: route.params.projectName ?? 'Sessions' })}
            />
            <Stack.Screen
              name="Chat"
              component={ChatScreen}
              options={({ route }) => ({ title: route.params.title ?? 'Session' })}
            />
            <Stack.Screen name="Terminal" component={TerminalScreen} options={{ title: 'Terminal' }} />
            <Stack.Screen
              name="Editor"
              component={EditorScreen}
              options={({ route }) => ({ title: route.params.filePath.split('/').pop() })}
            />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
