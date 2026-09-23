import { AbstractProvider } from '@/modules/providers/shared/base/abstract.provider.js';
import { CodexProviderAuth } from '@/modules/providers/list/codex/codex-auth.provider.js';
import { CodexProviderModels } from '@/modules/providers/list/codex/codex-models.provider.js';
import { codexRuntime } from '@/modules/providers/list/codex/codex-runtime.provider.js';
import { CodexMcpProvider } from '@/modules/providers/list/codex/codex-mcp.provider.js';
import { CodexSessionSynchronizer } from '@/modules/providers/list/codex/codex-session-synchronizer.provider.js';
import { CodexSessionsProvider } from '@/modules/providers/list/codex/codex-sessions.provider.js';
import { CodexSkillsProvider } from '@/modules/providers/list/codex/codex-skills.provider.js';
import type {
  IProviderAuth,
  IProviderModels,
  IProviderRuntime,
  IProviderSessionSynchronizer,
  IProviderSkills,
  IProviderSessions,
} from '@/shared/interfaces.js';

export class CodexProvider extends AbstractProvider {
  // Lazy getter: runtime → notifications → remote-approval → providers is a
  // live import cycle; field-init reads the binding mid-eval and crashes (TDZ)
  // whenever this runtime module is the cycle's entry point.
  private _runtime: IProviderRuntime | null = null;
  get runtime(): IProviderRuntime {
    return (this._runtime ??= codexRuntime);
  }
  readonly models: IProviderModels = new CodexProviderModels();
  readonly mcp = new CodexMcpProvider();
  readonly auth: IProviderAuth = new CodexProviderAuth();
  readonly skills: IProviderSkills = new CodexSkillsProvider();
  readonly sessions: IProviderSessions = new CodexSessionsProvider();
  readonly sessionSynchronizer: IProviderSessionSynchronizer = new CodexSessionSynchronizer();

  constructor() {
    super('codex');
  }
}
