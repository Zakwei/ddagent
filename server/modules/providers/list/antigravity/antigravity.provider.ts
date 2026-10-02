import { AntigravityProviderAuth } from '@/modules/providers/list/antigravity/antigravity-auth.provider.js';
import { AntigravityProviderModels } from '@/modules/providers/list/antigravity/antigravity-models.provider.js';
import { antigravityRuntime } from '@/modules/providers/list/antigravity/antigravity-runtime.provider.js';
import { AntigravityMcpProvider } from '@/modules/providers/list/antigravity/antigravity-mcp.provider.js';
import { AntigravitySessionSynchronizer } from '@/modules/providers/list/antigravity/antigravity-session-synchronizer.provider.js';
import { AntigravitySessionsProvider } from '@/modules/providers/list/antigravity/antigravity-sessions.provider.js';
import { AntigravitySkillsProvider } from '@/modules/providers/list/antigravity/antigravity-skills.provider.js';
import { AbstractProvider } from '@/modules/providers/shared/base/abstract.provider.js';
import type {
  IProviderAuth,
  IProviderModels,
  IProviderRuntime,
  IProviderSessionSynchronizer,
  IProviderSkills,
  IProviderSessions,
} from '@/shared/interfaces.js';

export class AntigravityProvider extends AbstractProvider {
  // Lazy getter: runtime → notifications → remote-approval → providers is a
  // live import cycle; field-init reads the binding mid-eval and crashes (TDZ)
  // whenever this runtime module is the cycle's entry point.
  private _runtime: IProviderRuntime | null = null;
  get runtime(): IProviderRuntime {
    return (this._runtime ??= antigravityRuntime);
  }
  readonly models: IProviderModels = new AntigravityProviderModels();
  readonly mcp = new AntigravityMcpProvider();
  readonly auth: IProviderAuth = new AntigravityProviderAuth();
  readonly skills: IProviderSkills = new AntigravitySkillsProvider();
  readonly sessions: IProviderSessions = new AntigravitySessionsProvider();
  readonly sessionSynchronizer: IProviderSessionSynchronizer = new AntigravitySessionSynchronizer();

  constructor() {
    super('antigravity');
  }
}
