import type { LLMProvider } from '../../../types/app';
import type { PermissionMode } from '../types/types';

/**
 * Fallback permission-mode matrix used only until the backend capability
 * matrix (`GET /api/providers/capabilities`) has loaded. The backend is the
 * source of truth; this mirror exists so the composer renders sensibly on
 * first paint, when the capabilities request fails, and on surfaces that
 * render without it (the settings permission-mode pickers).
 */
export const FALLBACK_PERMISSION_MODES: Record<LLMProvider, PermissionMode[]> = {
  claude: ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
  cursor: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  codex: ['default', 'acceptEdits', 'bypassPermissions'],
  opencode: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  devin: ['default', 'acceptEdits', 'bypassPermissions'],
  // The router forwards the parent's mode to every delegated child run.
  orchestrator: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
};
