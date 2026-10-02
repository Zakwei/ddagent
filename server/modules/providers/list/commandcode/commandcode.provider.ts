import { CommandCodeProviderAuth } from '@/modules/providers/list/commandcode/commandcode-auth.provider.js';
import { CommandCodeProviderModels } from '@/modules/providers/list/commandcode/commandcode-models.provider.js';
import { commandCodeRuntime } from '@/modules/providers/list/commandcode/commandcode-runtime.provider.js';
import { CommandCodeMcpProvider } from '@/modules/providers/list/commandcode/commandcode-mcp.provider.js';
import { CommandCodeSessionSynchronizer } from '@/modules/providers/list/commandcode/commandcode-session-synchronizer.provider.js';
import { CommandCodeSessionsProvider } from '@/modules/providers/list/commandcode/commandcode-sessions.provider.js';
import { CommandCodeSkillsProvider } from '@/modules/providers/list/commandcode/commandcode-skills.provider.js';
import { AbstractProvider } from '@/modules/providers/shared/base/abstract.provider.js';
import type {
  IProviderAuth,
  IProviderModels,
  IProviderRuntime,
  IProviderSessionSynchronizer,
  IProviderSkills,
  IProviderSessions,
} from '@/shared/interfaces.js';

export class CommandCodeProvider extends AbstractProvider {
  // Lazy getter: runtime → notifications → remote-approval → providers is a
  // live import cycle; field-init reads the binding mid-eval and crashes (TDZ)
  // whenever this runtime module is the cycle's entry point.
  private _runtime: IProviderRuntime | null = null;
  get runtime(): IProviderRuntime {
    return (this._runtime ??= commandCodeRuntime);
  }
  readonly models: IProviderModels = new CommandCodeProviderModels();
  readonly mcp = new CommandCodeMcpProvider();
  readonly auth: IProviderAuth = new CommandCodeProviderAuth();
  readonly skills: IProviderSkills = new CommandCodeSkillsProvider();
  readonly sessions: IProviderSessions = new CommandCodeSessionsProvider();
  readonly sessionSynchronizer: IProviderSessionSynchronizer = new CommandCodeSessionSynchronizer();

  constructor() {
    super('commandcode');
  }
}
