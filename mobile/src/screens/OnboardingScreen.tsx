import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { AlertCircle, Check, GitBranch, LogIn, X } from 'lucide-react-native';
import { useTheme } from '../theme';
import { useAuth } from '../contexts/AuthContext';
import { api } from '~shared/utils/api';
import {
  ONBOARDING_PROVIDERS,
  ONBOARDING_STEP_COUNT,
  isOnboardingStepValid,
  parseProviderAuthStatus,
  providerDisplayName,
  validateGitStep,
  type ProviderConnectionStatus,
} from '../lib/onboarding';
import ProviderLoginModal from '../components/ProviderLoginModal';

const PROVIDER_ACCENT: Record<string, string> = {
  claude: '#2563eb',
  cursor: '#7c3aed',
  codex: '#1f2937',
  opencode: '#3f3f46',
  devin: '#3f3f46',
};

const STEP_TITLES = ['Git Configuration', 'Connect Agents'];

export default function OnboardingScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const { refreshOnboarding } = useAuth();

  const [step, setStep] = useState(0);
  const [gitName, setGitName] = useState('');
  const [gitEmail, setGitEmail] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [statuses, setStatuses] = useState<Record<string, ProviderConnectionStatus>>({});
  const [loginProvider, setLoginProvider] = useState<string | null>(null);

  const loadStatuses = useCallback(async () => {
    const entries = await Promise.all(
      ONBOARDING_PROVIDERS.map(async (provider) => {
        try {
          const res = await api.get(`/providers/${provider}/auth/status`);
          const body = await res.json().catch(() => null);
          return [provider, parseProviderAuthStatus(body)] as const;
        } catch {
          return [provider, { authenticated: false, email: null, error: null, loading: false }] as const;
        }
      }),
    );
    setStatuses(Object.fromEntries(entries));
  }, []);

  useEffect(() => {
    (async () => {
      try {
        const res = await api.user.gitConfig();
        const body = await res.json().catch(() => null);
        if (body?.gitName) setGitName(body.gitName);
        if (body?.gitEmail) setGitEmail(body.gitEmail);
      } catch {
        // ignore — user can type
      }
    })();
    void loadStatuses();
  }, [loadStatuses]);

  const stepValid = useMemo(() => isOnboardingStepValid(step, { gitName, gitEmail }), [step, gitName, gitEmail]);

  const handleNext = async () => {
    if (step === 0) {
      const failure = validateGitStep({ gitName, gitEmail });
      if (failure === 'nameRequired') {
        setError('Git name is required.');
        return;
      }
      if (failure === 'emailRequired') {
        setError('Git email is required.');
        return;
      }
      if (failure === 'emailInvalid') {
        setError('Please enter a valid email address.');
        return;
      }
      setError(null);
      setBusy(true);
      try {
        const res = await api.user.updateGitConfig(gitName.trim(), gitEmail.trim());
        if (!res.ok) {
          const body = await res.json().catch(() => null);
          setError(body?.error || 'Failed to save git configuration');
          return;
        }
      } catch {
        setError('Failed to save git configuration');
        return;
      } finally {
        setBusy(false);
      }
    }
    setError(null);
    setStep((s) => Math.min(s + 1, ONBOARDING_STEP_COUNT - 1));
  };

  const handleFinish = async () => {
    setBusy(true);
    setError(null);
    try {
      const res = await api.user.completeOnboarding();
      if (!res.ok) {
        const body = await res.json().catch(() => null);
        setError(body?.error || 'Failed to complete onboarding');
        return;
      }
      await refreshOnboarding();
    } catch {
      setError('Failed to complete onboarding');
    } finally {
      setBusy(false);
    }
  };

  const renderGitStep = () => (
    <View>
      <Text style={{ color: colors.foreground, fontSize: 18, fontWeight: '700' }}>Git Configuration</Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 13, marginTop: 6, marginBottom: 20 }}>
        Set your git identity so commits made by agents are attributed correctly.
      </Text>
      <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600', marginBottom: 6 }}>
        Git Name <Text style={{ color: colors.destructive }}>*</Text>
      </Text>
      <TextInput
        value={gitName}
        onChangeText={setGitName}
        placeholder="John Doe"
        placeholderTextColor={colors.mutedForeground}
        editable={!busy}
        style={{ backgroundColor: colors.card, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 11 }}
      />
      <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 4, marginBottom: 16 }}>
        {'Saved as `git config --global user.name`.'}
      </Text>
      <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600', marginBottom: 6 }}>
        Git Email <Text style={{ color: colors.destructive }}>*</Text>
      </Text>
      <TextInput
        value={gitEmail}
        onChangeText={setGitEmail}
        placeholder="john@example.com"
        placeholderTextColor={colors.mutedForeground}
        autoCapitalize="none"
        autoCorrect={false}
        keyboardType="email-address"
        editable={!busy}
        style={{ backgroundColor: colors.card, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 11 }}
      />
    </View>
  );

  const renderAgentsStep = () => (
    <View>
      <Text style={{ color: colors.foreground, fontSize: 18, fontWeight: '700' }}>Connect Agents</Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 13, marginTop: 6, marginBottom: 20 }}>
        Optional — sign in to the CLI agents you want to use. You can do this later in Settings.
      </Text>
      {ONBOARDING_PROVIDERS.map((provider) => {
        const status = statuses[provider];
        const accent = PROVIDER_ACCENT[provider] ?? colors.primary;
        const connected = status?.authenticated === true;
        const statusText = !status
          ? 'Checking...'
          : status.error
            ? status.error
            : connected
              ? status.email || 'Connected'
              : 'Not connected';
        return (
          <View
            key={provider}
            style={{ flexDirection: 'row', alignItems: 'center', borderColor: connected ? accent : colors.border, borderWidth: 1, borderRadius: 10, padding: 12, marginBottom: 10, backgroundColor: colors.card }}
          >
            <View style={{ width: 34, height: 34, borderRadius: 17, backgroundColor: accent, alignItems: 'center', justifyContent: 'center' }}>
              <Text style={{ color: '#fff', fontWeight: '700', fontSize: 13 }}>{providerDisplayName(provider).slice(0, 1)}</Text>
            </View>
            <View style={{ flex: 1, marginLeft: 12 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600' }}>{providerDisplayName(provider)}</Text>
              <Text style={{ color: connected ? accent : colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>{statusText}</Text>
            </View>
            {!connected && !status?.loading && (
              <TouchableOpacity onPress={() => setLoginProvider(provider)} style={{ backgroundColor: accent, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8 }}>
                <Text style={{ color: '#fff', fontWeight: '600', fontSize: 12 }}>Login</Text>
              </TouchableOpacity>
            )}
            {connected && <Check color={accent} size={20} />}
          </View>
        );
      })}
    </View>
  );

  return (
    <View style={{ flex: 1, backgroundColor: colors.background, paddingTop: insets.top + 12 }}>
      {/* Step progress */}
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingHorizontal: 24, marginBottom: 20 }}>
        {STEP_TITLES.map((title, index) => (
          <React.Fragment key={title}>
            <View style={{ alignItems: 'center', flexDirection: 'row', gap: 8 }}>
              <View style={{ width: 26, height: 26, borderRadius: 13, alignItems: 'center', justifyContent: 'center', backgroundColor: index <= step ? colors.primary : colors.muted }}>
                {index < step ? <Check color={colors.primaryForeground} size={15} /> : <Text style={{ color: index === step ? colors.primaryForeground : colors.mutedForeground, fontSize: 12, fontWeight: '700' }}>{index + 1}</Text>}
              </View>
              <Text style={{ color: index === step ? colors.foreground : colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>{title}</Text>
            </View>
            {index < STEP_TITLES.length - 1 && <View style={{ width: 24, height: 1, backgroundColor: colors.border, marginHorizontal: 8 }} />}
          </React.Fragment>
        ))}
      </View>

      {error && (
        <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center', marginHorizontal: 24, marginBottom: 10, padding: 10, borderRadius: 8, backgroundColor: 'rgba(220,38,38,0.1)', borderWidth: 1, borderColor: colors.destructive }}>
          <AlertCircle color={colors.destructive} size={16} />
          <Text style={{ color: colors.destructive, flex: 1, fontSize: 12 }}>{error}</Text>
        </View>
      )}

      <ScrollView contentContainerStyle={{ padding: 24, paddingTop: 0 }} keyboardShouldPersistTaps="handled">
        {step === 0 ? renderGitStep() : renderAgentsStep()}
      </ScrollView>

      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', gap: 12, padding: 24, paddingBottom: 24 + insets.bottom, borderTopWidth: 1, borderTopColor: colors.border }}>
        <TouchableOpacity onPress={() => { setError(null); setStep((s) => Math.max(0, s - 1)); }} disabled={step === 0 || busy} style={{ padding: 10, opacity: step === 0 || busy ? 0.4 : 1 }}>
          <Text style={{ color: colors.mutedForeground }}>Previous</Text>
        </TouchableOpacity>
        {step < ONBOARDING_STEP_COUNT - 1 ? (
          <TouchableOpacity
            onPress={() => void handleNext()}
            disabled={!stepValid || busy}
            style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 20, paddingVertical: 11, opacity: !stepValid || busy ? 0.6 : 1 }}
          >
            <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{busy ? 'Saving...' : 'Next'}</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity
            onPress={() => void handleFinish()}
            disabled={busy}
            style={{ backgroundColor: '#059669', borderRadius: 8, paddingHorizontal: 20, paddingVertical: 11, opacity: busy ? 0.6 : 1 }}
          >
            <Text style={{ color: '#fff', fontWeight: '600' }}>{busy ? 'Completing...' : 'Complete Setup'}</Text>
          </TouchableOpacity>
        )}
      </View>

      <ProviderLoginModal
        visible={loginProvider !== null}
        provider={loginProvider}
        onClose={() => {
          const provider = loginProvider;
          setLoginProvider(null);
          if (provider) void loadStatuses();
        }}
      />
    </View>
  );
}
