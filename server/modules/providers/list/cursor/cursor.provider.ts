import { AbstractProvider } from '@/modules/providers/shared/base/abstract.provider.js';
import { CursorProviderAuth } from '@/modules/providers/list/cursor/cursor-auth.provider.js';
import { CursorProviderModels } from '@/modules/providers/list/cursor/cursor-models.provider.js';
import { cursorRuntime } from '@/modules/providers/list/cursor/cursor-runtime.provider.js';
import { CursorMcpProvider } from '@/modules/providers/list/cursor/cursor-mcp.provider.js';
import { CursorSessionSynchronizer } from '@/modules/providers/list/cursor/cursor-session-synchronizer.provider.js';
import { CursorSessionsProvider } from '@/modules/providers/list/cursor/cursor-sessions.provider.js';
import { CursorSkillsProvider } from '@/modules/providers/list/cursor/cursor-skills.provider.js';
import type {
  IProviderAuth,
  IProviderModels,
  IProviderRuntime,
  IProviderSessionSynchronizer,
  IProviderSkills,
  IProviderSessions,
} from '@/shared/interfaces.js';

export class CursorProvider extends AbstractProvider {
  // Lazy getter: runtime → notifications → remote-approval → providers is a
  // live import cycle; field-init reads the binding mid-eval and crashes (TDZ)
  // whenever this runtime module is the cycle's entry point.
  private _runtime: IProviderRuntime | null = null;
  get runtime(): IProviderRuntime {
    return (this._runtime ??= cursorRuntime);
  }
  readonly models: IProviderModels = new CursorProviderModels();
  readonly mcp = new CursorMcpProvider();
  readonly auth: IProviderAuth = new CursorProviderAuth();
  readonly skills: IProviderSkills = new CursorSkillsProvider();
  readonly sessions: IProviderSessions = new CursorSessionsProvider();
  readonly sessionSynchronizer: IProviderSessionSynchronizer = new CursorSessionSynchronizer();

  constructor() {
    super('cursor');
  }
}
