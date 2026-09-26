/**
 * Pure helpers for the native onboarding wizard + first-run account setup (T28).
 *
 * Mirrors the web single source of truth:
 * - src/components/auth/view/SetupForm.tsx (validateSetupForm)
 * - src/components/onboarding/view/Onboarding.tsx (step validation)
 * - src/components/onboarding/view/subcomponents/* (step metadata)
 * - src/components/provider-auth/view/ProviderLoginModal.tsx (getProviderCommand)
 *
 * No React Native / DOM dependency so it runs under Node in
 * mobile/tests/self-check.mts.
 */

export interface SetupValidationErrors {
  allFields?: boolean;
  usernameLength?: boolean;
  passwordLength?: boolean;
  passwordMismatch?: boolean;
}

/** Mirrors web validateSetupForm (`SetupForm.tsx:28-46`). */
export function validateSetup(username: string, password: string, confirmPassword: string): SetupValidationErrors {
  const errors: SetupValidationErrors = {};
  if (!username || !password || !confirmPassword) {
    errors.allFields = true;
    return errors;
  }
  if (username.length < 3) errors.usernameLength = true;
  if (password.length < 6) errors.passwordLength = true;
  if (password !== confirmPassword) errors.passwordMismatch = true;
  return errors;
}

export function setupErrorsEmpty(errors: SetupValidationErrors): boolean {
  return Object.keys(errors).length === 0;
}

/** Web email guard (`onboarding/utils.ts:1`). */
export const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export interface GitStepState {
  gitName: string;
  gitEmail: string;
}

export type GitStepFailure = 'nameRequired' | 'emailRequired' | 'emailInvalid' | null;

/** Step 0 gate (`Onboarding.tsx:92-100`). */
export function validateGitStep(state: GitStepState): GitStepFailure {
  const name = (state.gitName ?? '').trim();
  const email = (state.gitEmail ?? '').trim();
  if (!name) return 'nameRequired';
  if (!email) return 'emailRequired';
  if (!EMAIL_REGEX.test(email)) return 'emailInvalid';
  return null;
}

export interface OnboardingStepMeta {
  key: 'git' | 'agents';
  required: boolean;
}

export const ONBOARDING_STEPS: OnboardingStepMeta[] = [
  { key: 'git', required: true },
  { key: 'agents', required: false },
];

export const ONBOARDING_STEP_COUNT = ONBOARDING_STEPS.length;

/** Step 1 (agents) is always valid — provider connections are optional. */
export function isOnboardingStepValid(step: number, state: GitStepState): boolean {
  if (step === 0) return validateGitStep(state) === null;
  return true;
}

export function providerLoginCommand(provider: string, isPlatform = false): string {
  switch (provider) {
    case 'claude':
      return 'claude --dangerously-skip-permissions /login';
    case 'cursor':
      return 'cursor-agent login';
    case 'codex':
      return isPlatform ? 'codex login --device-auth' : 'codex login';
    case 'opencode':
      return 'opencode auth login';
    case 'devin':
      return 'devin login';
    default:
      return 'claude --dangerously-skip-permissions /login';
  }
}

export const ONBOARDING_PROVIDERS = ['claude', 'cursor', 'codex', 'opencode', 'devin'] as const;
export type OnboardingProvider = (typeof ONBOARDING_PROVIDERS)[number];

export interface ProviderConnectionStatus {
  authenticated: boolean;
  email: string | null;
  error: string | null;
  loading: boolean;
}

/** Unwraps `{success,data:{authenticated,…}}` or `{success:false,error}`. */
export function parseProviderAuthStatus(payload: any): ProviderConnectionStatus {
  const data = payload?.data ?? payload;
  return {
    authenticated: data?.authenticated === true,
    email: typeof data?.email === 'string' ? data.email : null,
    error: typeof data?.error === 'string' ? data.error : typeof payload?.error === 'string' ? payload.error : null,
    loading: false,
  };
}

export function providerDisplayName(provider: string): string {
  switch (provider) {
    case 'claude':
      return 'Claude Code';
    case 'cursor':
      return 'Cursor';
    case 'codex':
      return 'OpenAI Codex';
    case 'opencode':
      return 'OpenCode';
    case 'devin':
      return 'Devin';
    default:
      return provider;
  }
}
