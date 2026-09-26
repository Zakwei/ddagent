import React, { useEffect, useState } from 'react';
import { ActivityIndicator, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { DrawerActions, DarkTheme, DefaultTheme, LinkingOptions, NavigationContainer } from '@react-navigation/native';
import type { DrawerContentComponentProps } from '@react-navigation/drawer';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createDrawerNavigator } from '@react-navigation/drawer';
import {
  ClipboardCheck,
  Folder,
  FolderGit2,
  Gauge,
  GitBranch,
  History,
  MessageSquarePlus,
  Settings,
  SquareKanban,
  X,
} from 'lucide-react-native';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../contexts/AuthContext';
import { useTasksSettings } from '../contexts/TasksSettingsContext';
import { GlobalChromeBadges, useGlobalChrome } from '../components/GlobalChrome';
import { useTheme } from '../theme';
import { getServerUrlSync, loadServerUrl, onServerUrlChange } from '../lib/server-config';
import ServerConnectScreen from '../screens/ServerConnectScreen';
import LoginScreen from '../screens/LoginScreen';
import SetupScreen from '../screens/SetupScreen';
import ProjectsScreen from '../screens/ProjectsScreen';
import SessionsScreen from '../screens/SessionsScreen';
import ChatScreen from '../screens/ChatScreen';
import TerminalScreen from '../screens/TerminalScreen';
import FileTreeScreen from '../screens/FileTreeScreen';
import EditorScreen from '../screens/EditorScreen';
import SettingsScreen from '../screens/SettingsScreen';
import WebScreen from '../screens/WebScreen';
import RecentScreen from '../screens/RecentScreen';
import BoardScreen from '../screens/BoardScreen';
import TasksScreen from '../screens/TasksScreen';
import SourceControlScreen from '../screens/SourceControlScreen';
import QuotaScreen from '../screens/QuotaScreen';
import OnboardingScreen from '../screens/OnboardingScreen';
import WorkspaceScreen from '../screens/WorkspaceScreen';

export type RootStackParamList = {
  ServerConnect: undefined;
  Setup: undefined;
  Login: undefined;
  Main: undefined;
  Sessions: { projectId: string; projectName?: string };
  Chat: { sessionId: string; title?: string; provider?: string; projectId?: string };
  Terminal: { sessionId: string };
  Editor: { projectId: string; filePath: string };
  Web: { path: string; title?: string };
  Workspace: { initialKind?: string; projectId?: string } | undefined;
  Onboarding: undefined;
};

export type DrawerParamList = {
  Projects: undefined;
  Recent: undefined;
  Files: { projectId?: string } | undefined;
  Board: undefined;
  Tasks: undefined;
  SourceControl: undefined;
  Usage: undefined;
  AppPWA: { path: string } | undefined;
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

type MenuItem = {
  label: string;
  icon: React.ComponentType<{ size?: number; color?: string }>;
  route: keyof DrawerParamList;
  highlighted?: boolean;
};

/**
 * Custom drawer matching the web app's `MobileNavMenu` — same items, order,
 * icons and i18n labels, with the TaskMaster entry shown only when installed.
 * Projects/Recent stay at the top: in the APK they are the only entry into the
 * project/session lists the PWA keeps inside its chat home.
 */
function DrawerContent(props: DrawerContentComponentProps) {
  const { colors } = useTheme();
  const { t } = useTranslation(['sidebar', 'common']);
  const { tasksEnabled, isTaskMasterInstalled } = useTasksSettings();
  const showTasks = Boolean(tasksEnabled && isTaskMasterInstalled);
  const active = props.state.routeNames[props.state.index];
  const chrome = useGlobalChrome();

  const go = (route: keyof DrawerParamList) => {
    props.navigation.navigate(route as never);
    props.navigation.dispatch(DrawerActions.closeDrawer());
  };

  const items: MenuItem[] = [
    { label: t('tabs.board', 'Agent Board'), icon: SquareKanban, route: 'Board' },
    ...(showTasks ? [{ label: t('tabs.tasks', 'Tasks'), icon: ClipboardCheck, route: 'Tasks' as const }] : []),
    { label: t('tabs.usage', 'Quota & Usage'), icon: Gauge, route: 'Usage' },
    { label: t('tabs.git', 'Source Control'), icon: GitBranch, route: 'SourceControl' },
    { label: t('tabs.files', 'Files'), icon: Folder, route: 'Files' },
  ];

  const renderItem = ({ label, icon: Icon, route, highlighted }: MenuItem) => {
    const isActive = active === route;
    return (
      <TouchableOpacity
        key={route}
        onPress={() => go(route)}
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          gap: 12,
          height: 44,
          borderRadius: 8,
          paddingHorizontal: 12,
          backgroundColor: isActive ? colors.accent : highlighted ? colors.accent : 'transparent',
        }}
      >
        <Icon size={16} color={isActive || highlighted ? colors.foreground : colors.mutedForeground} />
        <Text style={{ color: isActive || highlighted ? colors.foreground : colors.mutedForeground, fontSize: 14, fontWeight: highlighted ? '500' : '400' }}>
          {label}
        </Text>
      </TouchableOpacity>
    );
  };

  const divider = <View style={{ height: 1, backgroundColor: colors.border, marginVertical: 6 }} />;

  return (
    <View style={{ flex: 1, backgroundColor: colors.card }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 4, paddingTop: 4 }}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12, fontWeight: '600', letterSpacing: 0.5, textTransform: 'uppercase' }}>
          {t('panel.navigation', 'Navigation')}
        </Text>
        <TouchableOpacity onPress={() => props.navigation.dispatch(DrawerActions.closeDrawer())} hitSlop={8} style={{ padding: 10 }}>
          <X size={16} color={colors.mutedForeground} />
        </TouchableOpacity>
      </View>

      <ScrollView contentContainerStyle={{ padding: 8, paddingBottom: 24 }}>
        {/* PWA parity: New chat opens a session picker; natively the equivalent
            flow starts on the project list. Kept highlighted like the web menu. */}
        <TouchableOpacity
          onPress={() => go('Projects')}
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 12,
            height: 44,
            borderRadius: 8,
            paddingHorizontal: 12,
            backgroundColor: colors.accent,
          }}
        >
          <MessageSquarePlus size={16} color={colors.foreground} />
          <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '500' }}>
            {t('panel.newChat', 'New chat')}
          </Text>
        </TouchableOpacity>
        {divider}

        {/* Native-only entry points: the PWA keeps project/recent lists inside
            its chat home, the APK surfaces them here. */}
        {renderItem({ label: 'Projects', icon: FolderGit2, route: 'Projects' })}
        {renderItem({ label: 'Recent sessions', icon: History, route: 'Recent' })}
        {divider}

        {items.map(renderItem)}
        {divider}

        {renderItem({ label: t('actions.settings', 'Settings'), icon: Settings, route: 'Settings' })}
        <View style={{ marginTop: 8 }}>
          <GlobalChromeBadges chrome={chrome} />
        </View>
      </ScrollView>
    </View>
  );
}

function MainDrawer() {
  const { colors } = useTheme();
  return (
    <Drawer.Navigator
      drawerContent={(props) => <DrawerContent {...props} />}
      screenOptions={{
        headerStyle: { backgroundColor: colors.card },
        headerTintColor: colors.foreground,
        drawerStyle: { backgroundColor: colors.card, width: 288 },
        drawerActiveTintColor: colors.primary,
        drawerInactiveTintColor: colors.mutedForeground,
      }}
    >
      <Drawer.Screen name="Projects" component={ProjectsScreen} />
      <Drawer.Screen name="Recent" component={RecentScreen} options={{ title: 'Recent sessions' }} />
      <Drawer.Screen name="Files" component={FileTreeScreen} />
      {/* PWA-parity surfaces via the generic WebView island — the responsive
          web app renders its own mobile layout at each route. */}
      <Drawer.Screen name="Board" component={BoardScreen} options={{ title: 'Agent Board' }} />
      <Drawer.Screen name="Tasks" component={TasksScreen} />
      <Drawer.Screen name="SourceControl" component={SourceControlScreen} options={{ title: 'Source Control' }} />
      <Drawer.Screen name="Usage" component={QuotaScreen} options={{ title: 'Quota & Usage' }} />
      {/* Escape hatch: the full responsive PWA at its root — covers every
          surface that isn't natively ported (settings modal, MCP, skills,
          PRD, command palette, quick settings, split panes). */}
      <Drawer.Screen name="AppPWA" component={WebScreen} initialParams={{ path: '/' }} options={{ title: 'Full app (PWA)' }} />
      <Drawer.Screen name="Settings" component={SettingsScreen} />
    </Drawer.Navigator>
  );
}

export default function RootNavigator() {
  const { colors, isDark } = useTheme();
  const { user, isLoading, needsOnboarding, needsSetup } = useAuth();
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
        ) : needsSetup ? (
          <Stack.Screen name="Setup" component={SetupScreen} options={{ headerShown: false }} />
        ) : !user ? (
          <Stack.Screen name="Login" component={LoginScreen} options={{ headerShown: false }} />
        ) : needsOnboarding ? (
          // First-run setup wizard lives in the web app — render it in-app.
          // OnboardingScreen polls /api/user/onboarding-status so the navigator
          // swaps to the drawer as soon as the flow completes.
          <Stack.Screen name="Onboarding" component={OnboardingScreen} options={{ headerShown: false }} />
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
            <Stack.Screen name="Workspace" component={WorkspaceScreen} options={{ title: 'Workspace' }} />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
