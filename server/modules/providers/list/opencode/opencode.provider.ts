import { OpenCodeProviderAuth } from '@/modules/providers/list/opencode/opencode-auth.provider.js';
import { OpenCodeProviderModels } from '@/modules/providers/list/opencode/opencode-models.provider.js';
import { opencodeRuntime } from '@/modules/providers/list/opencode/opencode-runtime.provider.js';
import { OpenCodeMcpProvider } from '@/modules/providers/list/opencode/opencode-mcp.provider.js';
import { OpenCodeSessionSynchronizer } from '@/modules/providers/list/opencode/opencode-session-synchronizer.provider.js';
import { OpenCodeSessionsProvider } from '@/modules/providers/list/opencode/opencode-sessions.provider.js';
import { OpenCodeSkillsProvider } from '@/modules/providers/list/opencode/opencode-skills.provider.js';
import { AbstractProvider } from '@/modules/providers/shared/base/abstract.provider.js';
import type {
  IProviderAuth,
  IProviderModels,
  IProviderRuntime,
  IProviderSessionSynchronizer,
  IProviderSkills,
  IProviderSessions,
} from '@/shared/interfaces.js';

export class OpenCodeProvider extends AbstractProvider {
  // Lazy getter: runtime → notifications → remote-approval → providers is a
  // live import cycle; field-init reads the binding mid-eval and crashes (TDZ)
  // whenever this runtime module is the cycle's entry point.
  private _runtime: IProviderRuntime | null = null;
  get runtime(): IProviderRuntime {
    return (this._runtime ??= opencodeRuntime);
  }
  readonly models: IProviderModels = new OpenCodeProviderModels();
  readonly mcp = new OpenCodeMcpProvider();
  readonly auth: IProviderAuth = new OpenCodeProviderAuth();
  readonly skills: IProviderSkills = new OpenCodeSkillsProvider();
  readonly sessions: IProviderSessions = new OpenCodeSessionsProvider();
  readonly sessionSynchronizer: IProviderSessionSynchronizer = new OpenCodeSessionSynchronizer();

  constructor() {
    super('opencode');
  }
}
