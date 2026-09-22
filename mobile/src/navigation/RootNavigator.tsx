import React, { useEffect, useState } from 'react';
import { ActivityIndicator, View } from 'react-native';
import { DarkTheme, DefaultTheme, LinkingOptions, NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../theme';
import { getServerUrlSync, loadServerUrl, onServerUrlChange } from '../lib/server-config';
import ServerConnectScreen from '../screens/ServerConnectScreen';
import LoginScreen from '../screens/LoginScreen';
import ProjectsScreen from '../screens/ProjectsScreen';
import SessionsScreen from '../screens/SessionsScreen';
import ChatScreen from '../screens/ChatScreen';
import TerminalScreen from '../screens/TerminalScreen';
import FileTreeScreen from '../screens/FileTreeScreen';
import EditorScreen from '../screens/EditorScreen';
import SettingsScreen from '../screens/SettingsScreen';
import WebScreen from '../screens/WebScreen';
import RecentScreen from '../screens/RecentScreen';

export type RootStackParamList = {
  ServerConnect: undefined;
  Login: undefined;
  Main: undefined;
  Sessions: { projectId: string; projectName?: string };
  Chat: { sessionId: string; title?: string };
  Terminal: { sessionId: string };
  Editor: { projectId: string; filePath: string };
  Web: { path: string; title?: string };
  Onboarding: { path: string } | undefined;
};

export type DrawerParamList = {
  Projects: undefined;
  Recent: undefined;
  Files: { projectId?: string } | undefined;
  Board: { path: string } | undefined;
  Tasks: { path: string } | undefined;
  SourceControl: { path: string } | undefined;
  Usage: { path: string } | undefined;
  Settings: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();
const Drawer = createDrawerNavigator<DrawerParamList>();

/** ddagent:// deep links — e.g. ddagent://chat/<sessionId>, ddagent://sessions/<projectId>. */
const linking: LinkingOptions<any> = {
  prefixes: ['ddagent://'],
  config: {
    screens: {
      Main: {
        screens: {
          Projects: 'projects',
          Files: 'files/:projectId?',
          Settings: 'settings',
        },
      },
      Sessions: 'sessions/:projectId',
      Chat: 'chat/:sessionId',
      Terminal: 'terminal/:sessionId',
      Editor: 'editor/:projectId/*',
    },
  },
};

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
      <Drawer.Screen name="Recent" component={RecentScreen} options={{ title: 'Recent sessions' }} />
      <Drawer.Screen name="Files" component={FileTreeScreen} />
      {/* PWA-parity surfaces via the generic WebView island — the responsive
          web app renders its own mobile layout at each route. */}
      <Drawer.Screen name="Board" component={WebScreen} initialParams={{ path: '/board' }} />
      <Drawer.Screen name="Tasks" component={WebScreen} initialParams={{ path: '/tasks' }} />
      <Drawer.Screen name="SourceControl" component={WebScreen} initialParams={{ path: '/source-control' }} options={{ title: 'Source Control' }} />
      <Drawer.Screen name="Usage" component={WebScreen} initialParams={{ path: '/usage' }} />
      <Drawer.Screen name="Settings" component={SettingsScreen} />
    </Drawer.Navigator>
  );
}

export default function RootNavigator() {
  const { colors, isDark } = useTheme();
  const { user, isLoading, needsOnboarding } = useAuth();
  const [serverChecked, setServerChecked] = useState(false);
  const [hasServer, setHasServer] = useState<boolean>(!!getServerUrlSync());

  useEffect(() => {
    loadServerUrl().then((url) => {
      setHasServer(!!url);
      setServerChecked(true);
    });
    // Conditional screens: hasServer/user drive which routes exist, so
    // navigation between ServerConnect/Login/Main happens by state swap.
    return onServerUrlChange((url) => setHasServer(!!url));
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
    <NavigationContainer theme={navTheme} linking={linking}>
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
        ) : needsOnboarding ? (
          // First-run setup wizard lives in the web app — render it in-app.
          <Stack.Screen
            name="Onboarding"
            component={WebScreen}
            initialParams={{ path: '/' }}
            options={{ headerShown: false }}
          />
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
              name="Web"
              component={WebScreen}
              options={({ route }) => ({ title: route.params.title ?? 'ddagent' })}
            />
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
