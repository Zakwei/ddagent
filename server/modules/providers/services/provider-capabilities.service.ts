import type { LLMProvider } from '@/shared/types.js';

/**
 * Static, backend-owned description of what one provider integration supports.
 *
 * The frontend renders its composer UI (permission mode picker, image upload,
 * abort button, ...) purely from this shape, which is what keeps the frontend
 * free of per-provider conditionals. New provider features should be exposed
 * here instead of branching on the provider id in React components.
 */
type ProviderCapabilities = {
  provider: LLMProvider;
  /** Permission modes the provider runtime understands, in cycle order. */
  permissionModes: string[];
  defaultPermissionMode: string;
  /** Whether image attachments can be included in a chat.send. */
  supportsImages: boolean;
  /** Whether general file attachments can be included in a chat.send. */
  supportsFiles: boolean;
  /** Whether an in-flight run can be cancelled via chat.abort. */
  supportsAbort: boolean;
  /** Whether interactive tool permission prompts can reach the UI. */
  supportsPermissionRequests: boolean;
  /** Whether the token-usage endpoint has data for this provider. */
  supportsTokenUsage: boolean;
  /** Whether the provider runtime can accept model-level reasoning effort. */
  supportsEffort: boolean;
  /** Whether a permission-mode change reaches a running turn (otherwise it applies from the next message). */
  supportsLivePermissionMode: boolean;
};

/**
 * The capability matrix mirrors what each runtime actually implements today:
 * - permission modes match the option sets accepted by each CLI/SDK.
 * - only the Claude SDK integration surfaces interactive permission requests.
 * - Cursor has no token usage endpoint support (its store.db has no usage rows).
 */
const PROVIDER_CAPABILITIES: Record<LLMProvider, ProviderCapabilities> = {
  claude: {
    provider: 'claude',
    permissionModes: ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: true,
    supportsTokenUsage: true,
    supportsEffort: true,
    supportsLivePermissionMode: true,
  },
  cursor: {
    provider: 'cursor',
    // cursor-agent print mode has no edits-only switch: only -f (bypass) and --mode plan exist.
    permissionModes: ['default', 'bypassPermissions', 'plan'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: false,
    supportsTokenUsage: false,
    supportsEffort: false,
    supportsLivePermissionMode: false,
  },
  antigravity: {
    provider: 'antigravity',
    // Driven through `agy --print --output-format stream-json` (headless
    // NDJSON, spawn-per-turn): acceptEdits→--mode accept-edits, plan→--mode
    // plan, bypassPermissions→--dangerously-skip-permissions. Print mode has
    // no interactive permission channel, so default soft-denies tool prompts
    // inside the CLI and DDAgent never sees a request_permission round-trip.
    permissionModes: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: false,
    supportsTokenUsage: true,
    supportsEffort: true,
    supportsLivePermissionMode: false,
  },
  commandcode: {
    provider: 'commandcode',
    // Driven through `command-code acp` (Agent Client Protocol over stdio):
    // prompts stream via session/prompt, modes map onto session/set_mode
    // (default→default, acceptEdits→auto-accept, bypassPermissions→bypass,
    // plan→plan), and session/request_permission pend until the UI answers.
    permissionModes: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: true,
    supportsTokenUsage: true,
    supportsEffort: true,
    supportsLivePermissionMode: true,
  },
  codex: {
    provider: 'codex',
    permissionModes: ['default', 'acceptEdits', 'bypassPermissions'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: false,
    supportsTokenUsage: true,
    supportsEffort: true,
    supportsLivePermissionMode: false,
  },
  devin: {
    provider: 'devin',
    // ACP session/set_mode: default→accept-edits (no ACP mode asks before
    // edits), auto→smart, acceptEdits→accept-edits, bypassPermissions→bypass, plan→plan.
    permissionModes: ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: true,
    supportsTokenUsage: true,
    // The model catalog id already carries the thinking level (thought_level).
    supportsEffort: false,
    supportsLivePermissionMode: true,
  },
  opencode: {
    provider: 'opencode',
    // Driven through `opencode serve`: prompts use `prompt_async` (plan maps to
    // the built-in `plan` agent) and `permission.asked` events pend until the
    // runtime replies — bypassPermissions/acceptEdits auto-approve, default
    // forwards interactive requests to the UI. See
    // resolveOpenCodePermissionBehavior in the OpenCode runtime adapter.
    permissionModes: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
    defaultPermissionMode: 'default',
    supportsImages: true,
    supportsFiles: true,
    supportsAbort: true,
    supportsPermissionRequests: true,
    supportsTokenUsage: true,
    supportsEffort: true,
    supportsLivePermissionMode: true,
  },
};

/**
 * Application service exposing the provider capability matrix.
 */
export const providerCapabilitiesService = {
  getProviderCapabilities(provider: LLMProvider): ProviderCapabilities {
    return PROVIDER_CAPABILITIES[provider];
  },

  listAllProviderCapabilities(): ProviderCapabilities[] {
    return Object.values(PROVIDER_CAPABILITIES);
  },
};
