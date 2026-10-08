import type {
  AnyRecord,
  FetchHistoryOptions,
  FetchHistoryResult,
  LLMProvider,
  McpScope,
  NormalizedMessage,
  ProviderSkill,
  ProviderSkillListOptions,
  ProviderAuthStatus,
  ProviderCurrentActiveModel,
  ProviderModelsDefinition,
  ProviderMcpServer,
  ProviderSkillCreateInput,
  ProviderSkillMoveInput,
  ProviderSkillMoveResult,
  ProviderSkillRemoveInput,
  ProviderRuntimeContext,
  ProviderRuntimePermissionGateway,
  ProviderRuntimeWriter,
  UpsertProviderMcpServerInput,
} from '@/shared/types.js';

//----------------- PROVIDER CONTRACT INTERFACES ------------

/**
 * Live execution contract implemented by each provider SDK/CLI adapter.
 *
 * The provider registry owns this adapter as one facet of `IProvider`; runtime
 * execution context is supplied by the application service at call time.
 */
export interface IProviderRuntime {
  run(
    command: string,
    options: AnyRecord,
    writer: ProviderRuntimeWriter,
    context: ProviderRuntimeContext,
  ): Promise<unknown>;
  abort(sessionId: string): boolean | Promise<boolean>;
  permissions?: ProviderRuntimePermissionGateway;
  /**
   * Optional live permission-mode update for runtimes whose permission
   * evaluation happens server-side mid-run. Consumed by
   * provider-runtime.service via the `chat.set-permission-mode` websocket
   * message; runtimes without it simply apply the mode at run start.
   */
  setPermissionMode?(sessionId: string, mode: string): void;
  /**
   * Optional mid-turn steering: hands a user message to the turn that is
   * running right now, without interrupting it — the agent picks it up at its
   * next step boundary. Consumed by provider-runtime.service for the queue's
   * "send now". Resolves `true` only when the live turn accepted the message
   * (the runtime then also streams it as a user row); `false` means the caller
   * must deliver it some other way (as the next turn). Runtimes whose
   * transport cannot inject into a running turn (ACP, Codex exec) omit it.
   */
  steer?(sessionId: string, content: string, options: AnyRecord): Promise<boolean>;
}

/**
 * Main provider contract for CLI and SDK integrations.
 *
 * Each concrete provider owns its MCP/auth handlers plus the provider-specific
 * logic for converting native events/history into the app's normalized shape.
 */
export interface IProvider {
  readonly id: LLMProvider;
  readonly runtime: IProviderRuntime;
  readonly models: IProviderModels;
  readonly mcp: IProviderMcp;
  readonly auth: IProviderAuth;
  readonly skills: IProviderSkills;
  readonly sessions: IProviderSessions;
  readonly sessionSynchronizer: IProviderSessionSynchronizer;
}

// ---------------------------
//----------------- PROVIDER MODEL INTERFACE ------------
/**
 * Model catalog contract for one provider.
 *
 * Implementations supply DDAgent's curated predefined models and can inspect
 * provider-native session state. The Providers service merges these immutable
 * source-controlled definitions with user-created SQLite rows at read time.
 */
export interface IProviderModels {
  /**
   * Returns the curated or dynamically discovered catalog owned by this provider
   * adapter. Passing `true` asks the adapter to bypass any cache and re-fetch.
   */
  getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition>;

  /**
   * Reads the model the provider itself believes one session is running with.
   *
   * Only consulted for sessions the app has never recorded a model for — a
   * session started directly in the provider CLI, for example. Selecting a
   * model in the app is persisted on the session row instead, so adapters here
   * are read-only and must fall back to the catalog default when the
   * provider-specific lookup finds nothing.
   */
  getCurrentActiveModel(sessionId?: string): Promise<ProviderCurrentActiveModel>;
}

// ---------------------------
//----------------- PROVIDER AUTH INTERFACE ------------
/**
 * Auth contract for one provider.
 *
 * Implementations should return a complete installation/authentication status
 * without throwing for normal "not installed" or "not authenticated" states.
 */
export interface IProviderAuth {
  /**
   * Checks whether the provider is installed and has usable credentials.
   */
  getStatus(): Promise<ProviderAuthStatus>;

  /**
   * Clears the provider's stored credentials so a later `getStatus()` reports
   * unauthenticated, restoring a fresh-login state.
   *
   * Optional capability: providers whose login is owned by an environment
   * variable or an OS keyring have no store to clear and omit this method.
   * Callers (the auth service and its logout route) must treat its absence as
   * "logout unsupported" rather than an error. Implementations delete files
   * best-effort — a missing credential file is still a successful logout.
   */
  logout?(): Promise<void>;
}

// ---------------------------
//----------------- PROVIDER SKILLS INTERFACE ------------
/**
 * Skills contract for one provider.
 *
 * Implementations discover provider-native skill markdown locations and return
 * normalized skill records with the exact command syntax expected by that
 * provider. Each skill is read from a `SKILL.md` file under its skill directory.
 */
export interface IProviderSkills {
  /**
   * Lists all skills visible to this provider for the optional workspace.
   */
  listSkills(options?: ProviderSkillListOptions): Promise<ProviderSkill[]>;

  /**
   * Writes one or more global user-scoped skills for this provider.
   *
   * Implementations should install the supplied markdown entries into the
   * provider's writable user skill folder and return the normalized skill
   * records that were written.
   */
  addSkills(input: ProviderSkillCreateInput): Promise<ProviderSkill[]>;

  /**
   * Relocates one managed skill directory between the provider's global user
   * skill root and a project-scoped skill root (in either direction).
   *
   * Implementations must reject sources outside their known managed roots and
   * must never overwrite an existing directory at the destination.
   */
  moveSkill(input: ProviderSkillMoveInput): Promise<ProviderSkillMoveResult>;

  removeSkill(
    input: ProviderSkillRemoveInput,
  ): Promise<{ removed: boolean; provider: LLMProvider; directoryName: string }>;
}

// ---------------------------
//----------------- PROVIDER MCP INTERFACE ------------
/**
 * MCP contract for one provider.
 *
 * Implementations must map provider-native MCP config formats to shared
 * `ProviderMcpServer` records used by routes and frontend state.
 */
export interface IProviderMcp {
  listServers(options?: { workspacePath?: string }): Promise<Record<McpScope, ProviderMcpServer[]>>;
  listServersForScope(scope: McpScope, options?: { workspacePath?: string }): Promise<ProviderMcpServer[]>;
  upsertServer(input: UpsertProviderMcpServerInput): Promise<ProviderMcpServer>;
  removeServer(
    input: { name: string; scope?: McpScope; workspacePath?: string },
  ): Promise<{ removed: boolean; provider: LLMProvider; name: string; scope: McpScope }>;
}

// ---------------------------
//----------------- PROVIDER SESSION INTERFACE ------------
/**
 * Session/history contract for one provider.
 *
 * Implementations normalize provider-specific events and message history into
 * shared transport shapes consumed by API routes and realtime streams.
 */
export interface IProviderSessions {
  normalizeMessage(raw: unknown, sessionId: string | null): NormalizedMessage[];
  fetchHistory(sessionId: string, options?: FetchHistoryOptions): Promise<FetchHistoryResult>;
}

// ---------------------------
//----------------- PROVIDER SESSION SYNCHRONIZER INTERFACE ------------
/**
 * Session indexing contract for one provider.
 *
 * Implementations scan provider-specific session artifacts on disk and upsert
 * normalized session metadata into the database. The service layer uses this
 * interface for both full rescans and single-file incremental sync triggered
 * by filesystem watcher events.
 */
export interface IProviderSessionSynchronizer {
  /**
   * Scans provider session artifacts and upserts discovered sessions into DB.
   */
  synchronize(since?: Date): Promise<number>;

  /**
   * Parses and upserts one provider artifact file without running a full scan.
   */
  synchronizeFile(filePath: string): Promise<string | null>;
}
