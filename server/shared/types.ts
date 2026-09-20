import type { IncomingMessage } from 'node:http';
import type { Readable } from 'node:stream';

//----------------- HTTP RESPONSE SHAPES ------------
/**
 * Canonical success envelope used by backend APIs that return a structured payload.
 *
 * Use this for route handlers that need a stable `success/data` shape so frontend
 * consumers can parse responses consistently across endpoints.
 */
export type ApiSuccessShape<TData = unknown> = {
  success: true;
  data: TData;
};

/**
 * Generic plain-object record used when parsing loosely typed JSON payloads.
 *
 * Use this only after runtime shape checks, not as a replacement for validated
 * domain models.
 */
export type AnyRecord = Record<string, any>;

// ---------------------------
//----------------- WEBSOCKET TRANSPORT TYPES ------------
/**
 * Minimal websocket client contract used by backend broadcaster services.
 *
 * Any transport object added to `connectedClients` must implement these two
 * members so shared services can safely send JSON strings and check whether the
 * socket is still open before broadcasting.
 */
export type RealtimeClientConnection = {
  readyState: number;
  send(data: string): void;
};

/**
 * Authenticated user payload attached to websocket upgrade requests.
 *
 * Platform and OSS auth flows currently use either `id` or `userId`; both are
 * represented here so websocket handlers can resolve a stable writer user id.
 */
export type AuthenticatedWebSocketUser = {
  id?: string | number;
  userId?: string | number;
  username?: string;
  [key: string]: unknown;
};

/**
 * HTTP upgrade request shape after websocket authentication succeeds.
 *
 * `verifyClient` populates `request.user` with the authenticated payload, and
 * downstream websocket handlers rely on this extended request type.
 */
export type AuthenticatedWebSocketRequest = IncomingMessage & {
  user?: AuthenticatedWebSocketUser;
};

// ---------------------------
//----------------- PROVIDER MESSAGE MODEL ------------
/**
 * Providers supported by the unified server runtime.
 *
 * Use this as the source of truth whenever a function or payload needs to identify
 * a specific LLM integration.
 */
export type LLMProvider = 'claude' | 'codex' | 'cursor' | 'opencode' | 'devin';

/**
 * One selectable model row in a provider model catalog.
 */
export type ProviderModelOption = {
  value: string;
  label: string;
  description?: string;
  /** Context-window size in tokens, when the provider reports it. */
  context?: number;
  /** Billing tier, used by the picker to badge Free/Paid models. */
  tier?: 'free' | 'paid';
  /** Stable SQLite row id used only by model-management actions. */
  recordId?: number;
  /** True for user-created rows; false for immutable ddagent defaults. */
  isCustom?: boolean;
  effort?: {
    default?: string;
    values: {
      value: string;
      description?: string;
    }[];
  };
};

/**
 * Provider model catalog returned by `GET /api/providers/:provider/models`.
 */
export type ProviderModelsDefinition = {
  OPTIONS: ProviderModelOption[];
  DEFAULT: string;
};

/**
 * One persisted custom-model row in the provider model library.
 *
 * Provider modules use this shape at the database boundary. Predefined models
 * never use this type because they remain source-controlled in provider
 * adapters. `modelId` is sent to the provider runtime, while `model` is the
 * user-supplied display name shown in pickers.
 */
export type CustomProviderModelRecord = {
  recordId: number;
  provider: LLMProvider;
  modelId: string;
  model: string;
  sortOrder: number;
};

/**
 * User-editable values accepted when creating or changing a custom model.
 *
 * `id` must be the exact provider-facing model identifier and cannot contain
 * whitespace. `model` is a concise display name. The provider is supplied by
 * the route path so a row can never be moved across providers accidentally.
 */
export type CustomProviderModelInput = {
  id: string;
  model: string;
};

// ---------------------------
//----------------- PROVIDER ACTIVE MODEL TYPES ------------
/**
 * Provider-neutral result for the model that is actively driving a session or
 * provider runtime at the time of lookup.
 *
 * `model` must always be populated. Provider adapters should use the
 * provider-specific lookup method requested by the caller, and only fall back
 * to the provider catalog `DEFAULT` value when the active model cannot be read.
 */
export type ProviderCurrentActiveModel = {
  model: string;
};

/**
 * Where a resolved session model came from.
 *
 * `session` means the app has recorded a model for this session (the user
 * picked one, or the session has been sent on at least once) and that value is
 * authoritative. `provider` means the session predates any app-recorded model
 * and the value was read back from the provider's own session state — the case
 * for sessions started directly in a provider CLI. `default` means neither was
 * available and the catalog default is standing in.
 *
 * Routes surface this so the frontend can tell a real selection apart from a
 * placeholder without re-deriving the precedence chain.
 */
export type ProviderSessionModelSource = 'session' | 'provider' | 'default';

/**
 * The model one session runs with, its persisted reasoning effort when one has
 * been recorded, and where the model answer came from.
 *
 * Returned by `providerModelsService.resolveSessionModel` and used by the
 * `/models`, `/cost` and `/status` commands, the active-model route, and the
 * composer's model picker so every surface agrees on one answer.
 */
export type ProviderSessionModel = {
  provider: LLMProvider;
  sessionId: string | null;
  model: string;
  /** NULL means this session has not recorded an effort choice yet. */
  effort: string | null;
  source: ProviderSessionModelSource;
};

/**
 * Message/event variants emitted by provider adapters and normalized transports.
 *
 * Keep this union in sync with event kinds produced by provider session adapters.
 */
export type MessageKind =
  | 'text'
  | 'tool_use'
  | 'tool_result'
  | 'thinking'
  | 'stream_delta'
  /** Incremental reasoning delta — the live counterpart of `thinking`. */
  | 'thought_delta'
  /** Full replacement for the open live message row (canonical correction). */
  | 'stream_replace'
  | 'stream_end'
  | 'error'
  | 'complete'
  | 'status'
  | 'permission_request'
  | 'permission_cancelled'
  | 'session_created'
  | 'interactive_prompt'
  | 'task_notification';

/**
 * Event kinds added by the chat gateway layer on top of provider message kinds.
 *
 * These are app-level realtime events (subscription acks, sidebar deltas,
 * project loading progress, protocol failures) that are not produced by any
 * provider adapter. Together with `MessageKind` they form the complete set of
 * `kind` values a websocket client can receive, so the frontend only ever
 * needs one kind-based switch.
 */
export type GatewayEventKind =
  | 'chat_subscribed'
  | 'session_upserted'
  | 'loading_progress'
  | 'protocol_error';

/**
 * Complete set of `kind` values emitted to websocket clients.
 *
 * Every server-to-client websocket frame carries a `kind` from this union.
 * Provider runtimes emit `MessageKind` values; gateway services emit
 * `GatewayEventKind` values.
 */
export type ServerEventKind = MessageKind | GatewayEventKind;

/**
 * Provider-neutral message envelope used in REST responses and realtime channels.
 *
 * Every provider-specific message must be converted into this shape before being
 * emitted outside provider-specific modules.
 */
export type NormalizedMessage = {
  id: string;
  sessionId: string;
  timestamp: string;
  provider: LLMProvider;
  kind: MessageKind;
  /**
   * Monotonic per-run sequence number assigned by the chat run registry when a
   * live event is forwarded to the websocket. History messages loaded over
   * REST do not carry it. Clients use it with `chat.subscribe` to replay only
   * the live events they missed across websocket reconnects.
   */
  seq?: number;
  role?: 'user' | 'assistant';
  content?: string;
  /**
   * Optional display-oriented metadata used by providers that need to expose
   * richer transcript artifacts without introducing a brand-new message kind.
   *
   * Current Claude usage:
   * - local slash commands expose parsed command fields
   * - compact summaries are flagged so the UI can treat them differently later
   */
  displayText?: string;
  commandName?: string;
  commandMessage?: string;
  commandArgs?: string;
  isLocalCommand?: boolean;
  isLocalCommandStdout?: boolean;
  isCompactSummary?: boolean;
  images?: unknown;
  /** Non-image files attached to a user turn after provider history normalization. */
  files?: unknown;
  toolName?: string;
  toolInput?: unknown;
  toolId?: string;
  toolResult?: {
    content?: string;
    isError?: boolean;
    toolUseResult?: unknown;
  };
  isError?: boolean;
  text?: string;
  tokens?: number;
  canInterrupt?: boolean;
  requestId?: string;
  input?: unknown;
  context?: unknown;
  reason?: string;
  newSessionId?: string;
  status?: string;
  summary?: string;
  tokenBudget?: unknown;
  subagentTools?: unknown;
  toolUseResult?: unknown;
  sequence?: number;
  rowid?: number;
  [key: string]: unknown;
};

/**
 * Output gateway shared by WebSocket and SSE provider runs.
 *
 * Runtime adapters only depend on this structural surface, which keeps them
 * independent from the transport that ultimately delivers normalized events.
 */
export type ProviderRuntimeWriter = {
  send(data: unknown): void;
  setSessionId?(sessionId: string): void;
  userId?: string | number | null;
  isWebSocketWriter?: boolean;
  isSSEStreamWriter?: boolean;
};

export type ProviderPermissionDecision = {
  allow: boolean;
  updatedInput?: unknown;
  message?: string;
  rememberEntry?: unknown;
};

export type ProviderRuntimePermissionGateway = {
  resolve(requestId: string, decision: ProviderPermissionDecision): void;
  listPending(sessionId: string): unknown[];
};

/**
 * Provider-scoped application capabilities supplied to a runtime for one run.
 *
 * Keeping these lookups outside concrete SDK/CLI adapters prevents the
 * adapters from importing services that resolve back through providerRegistry.
 */
export type ProviderRuntimeContext = {
  resolveProviderSessionId(sessionId: string | null | undefined): string | null;
  resolveResumeModel(
    sessionId: string | undefined,
    requestedModel?: string | null,
  ): Promise<string | undefined>;
  getProviderModels(): Promise<ProviderModelsDefinition>;
  normalizeMessage(raw: unknown, sessionId: string | null): NormalizedMessage[];
  isProviderInstalled(): Promise<boolean>;
};

export type ProviderRunFunction = (
  command: string,
  options: AnyRecord,
  writer: ProviderRuntimeWriter,
) => Promise<unknown>;

/**
 * Shared options used to fetch historical provider messages.
 *
 * Consumers should pass provider-specific lookup hints (`projectPath`) only
 * when the selected provider requires them.
 *
 * `providerSessionId` is the provider-native session id from the sessions
 * index (transcript file name / provider database key). Provider adapters
 * must use it — never the app-facing session id they were called with — when
 * matching transcript rows on disk, because app-created sessions use an
 * app-allocated id that the provider has never seen.
 */
export type FetchHistoryOptions = {
  projectPath?: string;
  limit?: number | null;
  offset?: number;
  providerSessionId?: string;
};

/**
 * Standardized response payload returned from provider history readers.
 *
 * Use this as the contract for APIs that return paginated conversation history.
 */
export type FetchHistoryResult = {
  messages: NormalizedMessage[];
  total: number;
  hasMore: boolean;
  offset: number;
  limit: number | null;
  tokenUsage?: unknown;
};

// ---------------------------
//----------------- PROVIDER SKILL TYPES ------------
/**
 * Scope where a provider skill definition was discovered.
 *
 * Provider skill adapters should use this to describe the origin of each
 * skill markdown file without leaking provider-specific folder names into route
 * contracts. `repo` is used for Codex repository lookup locations, while
 * `project` is used for providers that treat workspace-local skills as project
 * scoped.
 */
export type ProviderSkillScope = 'user' | 'project' | 'plugin' | 'repo' | 'admin' | 'system';

/**
 * Shared input accepted by provider skill listing operations.
 *
 * Routes pass `workspacePath` when a caller wants project/repository skills for
 * a specific folder. Providers should fall back to the backend process cwd when
 * this option is omitted.
 */
export type ProviderSkillListOptions = {
  workspacePath?: string;
};

/**
 * One supporting file bundled with an uploaded provider skill.
 *
 * `relativePath` is resolved below the installed skill directory and must never
 * be absolute or contain traversal segments. Text files may use `utf8`; binary
 * scripts and assets should use `base64` so JSON transport does not corrupt
 * their bytes.
 */
export type ProviderSkillCreateFile = {
  relativePath: string;
  content: string;
  encoding: 'utf8' | 'base64';
};

/**
 * One skill markdown payload submitted for provider-managed installation.
 *
 * `content` is the raw markdown body that will be written to `SKILL.md`.
 * `directoryName` lets callers control the target folder name explicitly when
 * they want stable filesystem paths that differ from the markdown front matter
 * `name` field. `fileName` is optional upload metadata used only as a final
 * fallback when no directory name or front matter name is present. `files`
 * carries scripts, references, and other files from a complete skill folder.
 */
export type ProviderSkillCreateEntry = {
  content: string;
  directoryName?: string;
  fileName?: string;
  files?: ProviderSkillCreateFile[];
};

/**
 * Shared input accepted by provider skill creation operations.
 *
 * The service layer batches multiple skill definitions in one request. Each
 * entry can contain only markdown or a complete skill folder.
 */
export type ProviderSkillCreateInput = {
  entries: ProviderSkillCreateEntry[];
};

export type ProviderSkillRemoveInput = {
  directoryName: string;
};

/**
 * Normalized skill record returned by provider skill adapters.
 *
 * The `command` value is the exact invocation text the selected provider expects
 * for this skill. Claude plugin skills use a namespaced command such as
 * `/plugin-name:skill-name`, while Codex skills use the `$skill-name` form.
 * `sourcePath` points to the skill markdown file that produced the record so
 * callers can distinguish duplicate skill names across scopes.
 */
export type ProviderSkill = {
  provider: LLMProvider;
  name: string;
  description: string;
  command: string;
  scope: ProviderSkillScope;
  sourcePath: string;
  pluginName?: string;
  pluginId?: string;
};

/**
 * Internal source descriptor consumed by shared provider skill discovery logic.
 *
 * Concrete provider adapters build these records from their native lookup rules.
 * The shared skills provider then scans `rootDir` for child skill markdown files
 * and uses `commandForSkill` or `commandPrefix` to produce the provider-specific
 * invocation command. Set `recursive` only when a provider stores skills under
 * arbitrary nested folders below the source root.
 */
export type ProviderSkillSource = {
  scope: ProviderSkillScope;
  rootDir: string;
  recursive?: boolean;
  commandPrefix?: '/' | '$';
  commandForSkill?: (skillName: string) => string;
  pluginName?: string;
  pluginId?: string;
};

// ---------------------------
//----------------- SHARED ERROR TYPES ------------
/**
 * Optional metadata used when constructing application-level errors.
 *
 * `statusCode` should reflect the HTTP response status, while `code` identifies
 * the stable machine-readable error category.
 */
export type AppErrorOptions = {
  code?: string;
  statusCode?: number;
  details?: unknown;
};

// ---------------------------
//----------------- MCP TYPES ------------
/**
 * Scope where an MCP server definition is stored and resolved.
 *
 * `user` is global for a user account, `local` is provider-local, and `project`
 * is tied to a specific project path.
 */
export type McpScope = 'user' | 'local' | 'project';

/**
 * Transport protocol used by an MCP server definition.
 */
export type McpTransport = 'stdio' | 'http' | 'sse';

/**
 * Normalized MCP server model exposed to frontend and route handlers.
 *
 * Provider adapters should map provider-native config to this structure before
 * returning results.
 */
export type ProviderMcpServer = {
  provider: LLMProvider;
  name: string;
  scope: McpScope;
  transport: McpTransport;
  command?: string;
  args?: string[];
  env?: Record<string, string>;
  cwd?: string;
  url?: string;
  headers?: Record<string, string>;
  envVars?: string[];
  bearerTokenEnvVar?: string;
  envHttpHeaders?: Record<string, string>;
};

/**
 * Payload for create/update MCP server operations.
 *
 * Routes and services should accept this type, validate it, and then persist it
 * through provider-specific MCP repositories.
 */
export type UpsertProviderMcpServerInput = {
  name: string;
  scope?: McpScope;
  transport: McpTransport;
  workspacePath?: string;
  command?: string;
  args?: string[];
  env?: Record<string, string>;
  cwd?: string;
  url?: string;
  headers?: Record<string, string>;
  envVars?: string[];
  bearerTokenEnvVar?: string;
  envHttpHeaders?: Record<string, string>;
};

// ---------------------------
//----------------- PROVIDER AUTH TYPES ------------
/**
 * Authentication status result returned by provider health checks.
 *
 * This shape is consumed by settings/status endpoints to report installation and
 * credential state for each provider.
 */
export type ProviderAuthStatus = {
  installed: boolean;
  provider: LLMProvider;
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

// ---------------------------
//----------------- SHARED DATABASE CREDENTIAL TYPES ------------
/**
 * Safe credential view returned by credential listing APIs.
 *
 * This intentionally excludes the raw credential secret while still exposing
 * metadata needed for UI rendering and management operations.
 */
export type CredentialPublicRow = {
  id: number;
  credential_name: string;
  credential_type: string;
  description: string | null;
  created_at: string;
  is_active: number;
};

/**
 * Result returned after creating a credential record.
 *
 * Use this return shape when callers need the created id and display metadata,
 * but must never receive the stored secret value.
 */
export type CreateCredentialResult = {
  id: number | bigint;
  credentialName: string;
  credentialType: string;
};

// ---------------------------
//----------------- PROJECT PERSISTENCE TYPES ------------
/**
 * Canonical project row shape returned by the projects repository.
 *
 * Use this type whenever backend services need to pass around one database
 * project record without leaking raw SQL row typing across modules.
 */
export type ProjectRepositoryRow = {
  project_id: string;
  project_path: string;
  custom_project_name: string | null;
  isStarred: number;
  isArchived: number;
};

/**
 * Result category returned by `projectsDb.createProjectPath`.
 *
 * `created` means a fresh row was inserted, `reactivated_archived` means an
 * existing archived path was accepted and updated, and `active_conflict` means
 * an already-active path blocked project creation.
 */
export type CreateProjectPathOutcome =
  | 'created'
  | 'reactivated_archived'
  | 'active_conflict';

/**
 * Structured result returned by project-path upsert operations.
 *
 * Services should use this result to decide whether a request succeeded,
 * should return a conflict, or needs follow-up retrieval of row metadata.
 */
export type CreateProjectPathResult = {
  outcome: CreateProjectPathOutcome;
  project: ProjectRepositoryRow | null;
};

/**
 * Validation result for user-supplied workspace/project paths.
 *
 * `resolvedPath` is present only when validation succeeds. `error` is present
 * only when validation fails and is suitable for user-facing diagnostics.
 */
export type WorkspacePathValidationResult = {
  valid: boolean;
  resolvedPath?: string;
  error?: string;
};

// ---------------------------
//----------------- GIT WORKTREE MANAGEMENT ------------
/**
 * Captured output of one completed `git` invocation.
 *
 * Returned by `GitCommandRunner` implementations so worktree services can read
 * both streams without caring about process plumbing.
 */
export type GitCommandResult = {
  stdout: string;
  stderr: string;
};

/**
 * Executes `git <args>` inside `cwd` and resolves with the captured output.
 *
 * All worktree services receive their git access through this contract so
 * tests can inject a fake runner instead of spawning real processes. The
 * promise must reject (with `stderr` attached when available) on a non-zero
 * exit code.
 */
export type GitCommandRunner = (args: string[], cwd: string) => Promise<GitCommandResult>;

/**
 * One entry parsed from `git worktree list --porcelain`.
 *
 * This is the raw repository-level view (path/HEAD/branch/flags) before any
 * enrichment with project links or ahead/behind counts. `branch` is null for
 * detached-HEAD worktrees.
 */
export type WorktreePorcelainEntry = {
  path: string;
  headSha: string | null;
  branch: string | null;
  isDetached: boolean;
  isLocked: boolean;
  isPrunable: boolean;
};

/**
 * Fully enriched worktree row served to the UI.
 *
 * Extends the porcelain entry with everything the Worktrees panel renders:
 * dirty-file count, ahead/behind relative to the base branch (the branch
 * checked out in the main worktree), last-commit metadata, and the ddagent
 * project row linked to the worktree directory (if one was registered).
 */
export type WorktreeDescriptor = {
  path: string;
  branch: string | null;
  headSha: string | null;
  isMain: boolean;
  isCurrent: boolean;
  isLocked: boolean;
  isDetached: boolean;
  changedFileCount: number;
  ahead: number;
  behind: number;
  lastCommitSubject: string | null;
  lastCommitDate: string | null;
  linkedProjectId: string | null;
  linkedProjectArchived: boolean;
};

/**
 * Response payload of `GET /api/worktrees`.
 *
 * `baseBranch` is the branch checked out in the main worktree — the merge
 * target offered by the UI. `worktrees` always lists the main worktree first.
 */
export type WorktreeListResult = {
  repositoryRoot: string;
  baseBranch: string | null;
  worktrees: WorktreeDescriptor[];
};

// ---------------------------
//----------------- WORKTREE SERVICE INPUTS AND RESULTS ------------
/**
 * Input accepted by the worktree-listing workflow.
 *
 * `projectPath` may point at the main checkout or any linked worktree. The
 * service uses Git to resolve the complete repository-level worktree list.
 */
export type ListWorktreesInput = {
  projectPath: string;
};

/**
 * Input accepted when creating a linked Git worktree.
 *
 * `branch` is checked out when it already exists, otherwise it is created from
 * `baseBranch`. When `baseBranch` is omitted, the main worktree branch is used.
 */
export type CreateWorktreeInput = {
  projectPath: string;
  branch: string;
  baseBranch?: string | null;
};

/**
 * Result of successfully creating a linked Git worktree.
 *
 * `createdBranch` distinguishes a new branch from an existing branch checkout,
 * allowing API clients to accurately describe what Git changed.
 */
export type CreateWorktreeResult = {
  worktreePath: string;
  branch: string;
  createdBranch: boolean;
};

/**
 * Result of atomically creating and registering a worktree for project use.
 *
 * The Worktrees application service compensates the Git creation if project
 * registration fails, so routes only receive this shape after both steps pass.
 */
export type CreateAndOpenWorktreeResult = CreateWorktreeResult & {
  project: WorktreeProjectView;
};

/**
 * Input accepted when registering an existing worktree as a ddagent project.
 *
 * The service verifies that `worktreePath` belongs to the repository containing
 * `projectPath` before it creates or restores any project record.
 */
export type OpenWorktreeInput = {
  projectPath: string;
  worktreePath: string;
};

/**
 * Project view returned after a worktree is opened in ddagent.
 *
 * This deliberately mirrors the project-selection payload used by the Projects
 * module so the frontend can switch to the worktree without another lookup.
 */
export type WorktreeProjectView = {
  projectId: string;
  path: string;
  fullPath: string;
  displayName: string;
  isStarred: boolean;
  sessions: [];
  sessionMeta: { hasMore: false; total: 0 };
};

/**
 * Input accepted when removing a linked Git worktree.
 *
 * `force` permits removal with local changes. `deleteBranch` requests
 * best-effort branch cleanup after the worktree directory is removed.
 */
export type RemoveWorktreeInput = {
  projectPath: string;
  worktreePath: string;
  force?: boolean;
  deleteBranch?: boolean;
};

/**
 * Result of removing a linked Git worktree.
 *
 * `archivalError` reports best-effort project archival failure after Git has
 * already removed the worktree, allowing callers to represent partial success.
 */
export type RemoveWorktreeResult = {
  removedPath: string;
  branch: string | null;
  branchDeleted: boolean;
  archivedProjectId: string | null;
  archivalError: string | null;
};

/**
 * Input accepted when merging a linked worktree into the main worktree branch.
 *
 * The service verifies both worktrees are clean, supports squash and regular
 * merges, and may remove the source worktree after a successful merge.
 */
export type MergeWorktreeInput = {
  projectPath: string;
  worktreePath: string;
  squash?: boolean;
  message?: string | null;
  removeAfterMerge?: boolean;
};

/**
 * Result of a completed worktree merge.
 *
 * `removedWorktree` is populated only when post-merge removal succeeds.
 * `cleanupError` reports failed optional removal without misrepresenting the
 * already-completed merge as a failure.
 */
export type MergeWorktreeResult = {
  mergedBranch: string;
  targetBranch: string;
  squash: boolean;
  removedWorktree: RemoveWorktreeResult | null;
  cleanupError: string | null;
};

// ---------------------------
//----------------- WORKTREE MODULE DEPENDENCY CONTRACTS ------------
/**
 * Filesystem capability required by the Worktrees module.
 *
 * Production wiring checks the real filesystem; unit tests provide a small
 * deterministic fake so worktree creation never touches developer directories.
 */
export type WorktreeFileSystem = {
  pathExists(candidatePath: string): Promise<boolean>;
};

/**
 * Project-management boundary consumed by Worktrees workflows.
 *
 * The Worktrees module uses this contract instead of importing Database or
 * Projects internals. Production adapters delegate through those modules'
 * `index.ts` barrels, while unit tests supply in-memory functions.
 */
export type WorktreeProjectGateway = {
  getProjectPathById(projectId: string): string | null;
  getProjectByPath(projectPath: string): ProjectRepositoryRow | null;
  createProject(input: {
    projectPath: string;
    customName: string;
  }): Promise<{
    outcome: 'created' | 'reactivated_archived';
    project: { projectId: string };
  }>;
  restoreProject(projectId: string): void | Promise<void>;
  archiveProject(projectId: string): void | Promise<void>;
};

/**
 * Complete application-service surface used by the Worktrees HTTP router.
 *
 * Routes parse transport values and call these functions; they do not import
 * repositories, filesystem adapters, Git runners, or individual service files.
 */
export type WorktreeServices = {
  resolveProjectPath(projectId: string): string;
  list(input: ListWorktreesInput): Promise<WorktreeListResult>;
  create(input: CreateWorktreeInput): Promise<CreateWorktreeResult>;
  createAndOpen(input: CreateWorktreeInput): Promise<CreateAndOpenWorktreeResult>;
  open(input: OpenWorktreeInput): Promise<WorktreeProjectView>;
  merge(input: MergeWorktreeInput): Promise<MergeWorktreeResult>;
  remove(input: RemoveWorktreeInput): Promise<RemoveWorktreeResult>;
};

// ---------------------------
//----------------- FILE TREE MODULE CONTRACTS ------------
/**
 * One filesystem item returned by the File Tree API.
 *
 * The service populates metadata without following symlinks and recursively
 * attaches `children` only while the requested depth permits traversal. The
 * frontend uses the absolute `path` as the stable identifier for editor and
 * file-operation requests.
 */
export type FileTreeNode = {
  name: string;
  path: string;
  type: 'file' | 'directory';
  size: number;
  modified: string | null;
  permissions: string;
  permissionsRwx: string;
  isSymlink?: boolean;
  children?: FileTreeNode[];
};

/**
 * Minimal directory-entry shape required during File Tree traversal.
 *
 * Production adapts Node `Dirent` objects to this structural contract. Tests
 * provide small handwritten entries and therefore never read real directories.
 */
export type FileTreeDirectoryEntry = {
  name: string;
  isDirectory(): boolean;
};

/**
 * Minimal file-stat shape used for tree metadata and delete decisions.
 *
 * The numeric mode is converted to octal and rwx strings for the UI. `lstat`
 * supplies symlink state while `stat` is used when deciding file versus folder
 * deletion behavior.
 */
export type FileTreeStats = {
  size: number;
  mtime: Date;
  mode: number;
  isDirectory(): boolean;
  isSymbolicLink(): boolean;
};

/**
 * Complete filesystem capability injected into File Tree services.
 *
 * The production composition root delegates these operations to Node's fs
 * APIs. Unit tests provide deterministic path-keyed fakes so service tests
 * cannot inspect, write, rename, or delete developer files.
 */
export type FileTreeFileSystem = {
  access(candidatePath: string): Promise<void>;
  stat(candidatePath: string): Promise<FileTreeStats>;
  lstat(candidatePath: string): Promise<FileTreeStats>;
  // Streamed rather than returned as an array so a directory with millions of
  // children is abandoned at the entry limit instead of being materialized.
  openDirectory(directoryPath: string): AsyncIterable<FileTreeDirectoryEntry>;
  realpath(candidatePath: string): Promise<string>;
  readTextFile(filePath: string): Promise<string>;
  writeTextFile(filePath: string, content: string): Promise<void>;
  makeDirectory(directoryPath: string, recursive: boolean): Promise<void>;
  rename(oldPath: string, newPath: string): Promise<void>;
  removeDirectory(directoryPath: string): Promise<void>;
  unlink(filePath: string): Promise<void>;
  copyFile(sourcePath: string, destinationPath: string): Promise<void>;
  createReadStream(filePath: string): Readable;
};

/**
 * Project lookup boundary consumed by File Tree workflows.
 *
 * File Tree services resolve DB-assigned project ids through this contract and
 * never import the Database module or its repositories directly.
 */
export type FileTreeProjectGateway = {
  getProjectPathById(projectId: string): string | null | Promise<string | null>;
};

/**
 * Workspace validation boundary used by filesystem browsing and folder creation.
 *
 * The injected validator enforces the configured workspace root and resolves
 * symlinks before the File Tree service exposes or mutates paths.
 */
export type FileTreeWorkspaceGateway = {
  rootPath: string;
  validatePath(candidatePath: string): Promise<WorkspacePathValidationResult>;
};

/**
 * Uploaded-file record passed from the Multer transport adapter into the File
 * Tree service.
 *
 * Transport-specific field names are normalized so upload workflows do not
 * depend on Express or Multer types.
 */
export type FileTreeUploadedFile = {
  originalName: string;
  temporaryPath: string;
  size: number;
  mimeType: string;
};

/**
 * Logger boundary for expected File Tree diagnostics.
 *
 * Production delegates to the server console. Unit tests use no-op or captured
 * loggers and never patch the global console singleton.
 */
export type FileTreeLogger = {
  error(message: string, error?: unknown): void;
};

/**
 * One text-search match returned by the File Tree project search.
 */
export type FileTreeSearchMatch = {
  path: string;
  line: number;
  column: number;
  text: string;
};

/**
 * Complete result returned by the File Tree project text search.
 */
export type FileTreeSearchResult = {
  results: FileTreeSearchMatch[];
  truncated: boolean;
};

/**
 * Required production dependencies for the File Tree application service.
 *
 * Filesystem, project lookup, workspace policy, MIME detection, concurrency,
 * and logging are all explicit so service construction has no hidden process,
 * repository, or machine-wide defaults.
 */
export type FileTreeServiceDependencies = {
  fileSystem: FileTreeFileSystem;
  projects: FileTreeProjectGateway;
  workspace: FileTreeWorkspaceGateway;
  resolveMimeType(filePath: string): string;
  fileSystemConcurrency: number;
  logger: FileTreeLogger;
};

/**
 * Complete File Tree application-service surface consumed by HTTP routes.
 *
 * Routes parse transport inputs and call these methods; they never resolve
 * project repositories, validate filesystem ownership, or perform filesystem
 * mutations themselves.
 */
export type FileTreeServices = {
  browseWorkspace(inputPath: string | null): Promise<{
    path: string;
    suggestions: Array<{ path: string; name: string; type: 'directory' }>;
  }>;
  createWorkspaceFolder(folderPath: string): Promise<{ success: true; path: string }>;
  readTextFile(projectId: string, filePath: string): Promise<{ content: string; path: string }>;
  openFile(projectId: string, filePath: string): Promise<{ contentType: string; stream: Readable }>;
  saveTextFile(projectId: string, filePath: string, content: string): Promise<{
    success: true;
    path: string;
    message: string;
  }>;
  listProjectFiles(
    projectId: string,
    options?: { respectGitignore: boolean },
  ): Promise<FileTreeNode[]>;
  searchProjectFiles(
    projectId: string,
    query: string,
    options?: { respectGitignore?: boolean; limit?: number; regex?: boolean },
  ): Promise<FileTreeSearchResult>;
  createEntry(input: {
    projectId: string;
    parentPath: string;
    type: 'file' | 'directory';
    name: string;
  }): Promise<{ success: true; path: string; name: string; type: 'file' | 'directory'; message: string }>;
  renameEntry(input: { projectId: string; oldPath: string; newName: string }): Promise<{
    success: true;
    oldPath: string;
    newPath: string;
    newName: string;
    message: string;
  }>;
  deleteEntry(input: { projectId: string; targetPath: string }): Promise<{
    success: true;
    path: string;
    type: 'file' | 'directory';
    message: string;
  }>;
  storeUploadedFiles(input: {
    projectId: string;
    targetPath: string;
    relativePaths: string[];
    requestedFileCount: number;
    files: FileTreeUploadedFile[];
  }): Promise<{
    success: true;
    files: Array<{ name: string; path: string; size: number; mimeType: string }>;
    uploadedCount: number;
    requestedFileCount: number;
    targetPath: string;
    message: string;
  }>;
};

// ---------------------------
//----------------- CLI MODULE CONTRACTS ------------
/**
 * Output boundary used by the CLI and Sandbox services.
 *
 * Production wiring delegates to the real console. Unit tests collect these
 * calls in arrays, which keeps command assertions deterministic and avoids
 * monkey-patching the global console singleton.
 */
export type CliOutput = {
  log(message?: string): void;
  error(message?: string): void;
};

/**
 * Minimal synchronous filesystem surface shared by CLI status reporting and
 * sandbox workspace validation.
 *
 * The production composition root adapts Node's filesystem module. Tests supply
 * path-keyed fakes, so service tests never inspect or modify the real machine.
 */
export type CliFileSystem = {
  pathExists(filePath: string): boolean;
  getFileStats(filePath: string): { size: number; modifiedAt: Date };
};

/**
 * Mutable environment view owned by the CLI application.
 *
 * CLI options update this object before the server starts. Production passes
 * `process.env`; tests pass a plain record to verify option precedence without
 * changing process-wide environment state.
 */
export type CliEnvironment = Record<string, string | undefined>;

/**
 * Package metadata displayed by CLI help, status, version, and update commands.
 *
 * The composition root reads this once from the application package file and
 * injects only the fields the service needs.
 */
export type CliPackageMetadata = {
  version: string;
  homepage?: string;
  bugsUrl?: string;
};

/**
 * Executable CLI application returned by the CLI composition root.
 *
 * The thin executable entrypoint passes `process.argv` arguments to `run` and
 * copies the returned code to `process.exitCode`. Tests invoke the same method
 * directly with isolated dependencies.
 */
export type CliApplication = {
  run(argumentsList: string[]): Promise<number>;
};

/**
 * Sandbox command service consumed by the top-level CLI command dispatcher.
 *
 * Keeping this behind one required dependency lets CLI tests use a tiny fake,
 * while focused Sandbox tests exercise subprocess and filesystem behavior with
 * their own handwritten adapters.
 */
export type SandboxCommandService = {
  execute(argumentsList: string[]): Promise<number>;
};

// ---------------------------
//----------------- KANBAN MODULE CONTRACTS ------------
/**
 * Canonical workflow stage of a kanban card.
 *
 * `backlog` and `ready` are user-owned queues; the dispatcher only starts work
 * from `ready`. Everything from `working` onward is agent-owned: the agent
 * reports its own stage through the kanban reporting tool, and the dispatcher
 * only writes `working` on start and `needs_decision`/`done` when the runtime
 * ends a turn without a report.
 */
export type KanbanCardStatus =
  | 'backlog'
  | 'ready'
  | 'working'
  | 'needs_decision'
  | 'done'
  | 'archived';

/**
 * One kanban card row as stored and returned by the Kanban API.
 *
 * `statusMessage` carries the agent's most recent reasoning for landing in
 * `needs_decision` (a question or plan summary) so the board can show it
 * without opening the linked chat session.
 */
export type KanbanCard = {
  cardId: string;
  projectId: string;
  title: string;
  description: string;
  status: KanbanCardStatus;
  position: number;
  sessionId: string | null;
  provider: LLMProvider | null;
  model: string | null;
  effort: string | null;
  worktreePath: string | null;
  branch: string | null;
  prUrl: string | null;
  statusMessage: string | null;
  isArchived: boolean;
  createdAt: string;
  updatedAt: string;
};

/**
 * Input accepted when creating a kanban card.
 *
 * New cards always start in `backlog`; only the board move endpoint changes a
 * card's stage. `provider`/`model`/`effort` are stored so dispatch can start
 * the same runtime configuration every time the card is picked up.
 */
export type CreateKanbanCardInput = {
  projectId: string;
  title: string;
  description?: string;
  provider?: LLMProvider;
  model?: string;
  effort?: string;
};

/**
 * Fields a client may change on an existing card.
 *
 * Stage transitions flow through `move`, not through this update, so user edits
 * cannot silently change the workflow stage.
 */
export type UpdateKanbanCardInput = {
  title?: string;
  description?: string;
  provider?: LLMProvider;
  model?: string;
  effort?: string;
  position?: number;
};

/**
 * Outcome of a user- or agent-requested card move.
 *
 * `dispatch` is true when entering `ready` from a user-owned stage should start
 * an agent run; callers use it to decide whether to invoke the dispatcher.
 */
export type KanbanCardMoveResult = {
  card: KanbanCard;
  dispatch: boolean;
};

/**
 * Persistence boundary used by the Kanban services.
 *
 * The repository owns SQL only. Services own workflow rules, so unit tests can
 * exercise status logic against a small in-memory implementation of this type
 * without touching SQLite.
 */
export type KanbanCardsRepository = {
  list(projectId: string, options?: { includeArchived?: boolean }): KanbanCard[];
  /** Returns every non-archived card across projects, for cross-project rollups. */
  listAll(): KanbanCard[];
  getById(cardId: string): KanbanCard | null;
  create(input: CreateKanbanCardInput & { cardId: string }): KanbanCard;
  update(cardId: string, input: UpdateKanbanCardInput): KanbanCard | null;
  move(cardId: string, status: KanbanCardStatus, position: number): KanbanCard | null;
  setRuntime(
    cardId: string,
    input: {
      sessionId?: string | null;
      worktreePath?: string | null;
      branch?: string | null;
      statusMessage?: string | null;
      prUrl?: string | null;
      reportToken?: string | null;
    },
  ): KanbanCard | null;
  /** Returns the per-card report secret, or null when no run has been dispatched. */
  getReportToken(cardId: string): string | null;
  delete(cardId: string): boolean;
};

/**
 * Lifecycle of a server-side queued outbound message.
 *
 * `queued` waits for the session to go idle, `sending` is a dispatch in
 * flight, and `sent`/`failed` are terminal. A `failed` row can be retried.
 */
export type QueuedMessageStatus = 'queued' | 'sending' | 'sent' | 'failed';

/**
 * One outbound chat message persisted in the server-side queue.
 *
 * The command text and the JSON-decoded provider options travel together so a
 * later dispatch can replay the send exactly as the composer would have,
 * including pre-verified attachment descriptors.
 */
export type QueuedMessage = {
  id: number;
  userId: string | null;
  sessionId: string;
  content: string;
  options: Record<string, unknown>;
  status: QueuedMessageStatus;
  error: string | null;
  position: number;
  createdAt: string;
  updatedAt: string;
};

/**
 * Persistence contract for the server-side outbound message queue.
 *
 * Implemented by the database repository and faked in unit tests. `markSending`
 * is the atomic claim that prevents two dispatchers sending the same message.
 */
export type QueuedMessagesRepository = {
  enqueue(input: {
    userId?: string | null;
    sessionId: string;
    content: string;
    options?: Record<string, unknown>;
  }): QueuedMessage;
  listBySession(sessionId: string): QueuedMessage[];
  peekNext(sessionId: string): QueuedMessage | null;
  getById(id: number): QueuedMessage | null;
  markSending(id: number): boolean;
  markSent(id: number): void;
  markFailed(id: number, error?: string | null): void;
  requeue(id: number): void;
  /**
   * Returns every row stuck in `sending` back to `queued` and reports the
   * affected session ids. A restart mid-dispatch orphans `sending` rows —
   * neither `listBySession` nor `peekNext` can see them, so without this
   * sweep they stay invisible forever. Called once at service creation.
   */
  requeueStaleSending(): string[];
  remove(id: number): void;
  promote(id: number): void;
};

/**
 * Application-service surface used by the queued-messages HTTP router.
 *
 * Routes parse and validate transport input, then delegate here; the service
 * owns queue ordering and, for `sendNow`, the immediate provider dispatch.
 */
export type QueuedMessagesService = {
  list(sessionId: string): QueuedMessage[];
  enqueue(input: {
    userId?: string | number | null;
    sessionId: string;
    content: string;
    options?: Record<string, unknown>;
  }): QueuedMessage;
  remove(id: number): void;
  sendNow(id: number): Promise<QueuedMessage>;
};

/**
 * Broadcast boundary consumed by Kanban services.
 *
 * Production delegates to the shared websocket server; tests collect payloads
 * in an array. The payload shape mirrors the TaskMaster module so the frontend
 * websocket provider needs no special casing.
 */
export type KanbanBroadcaster = (payload: {
  type: 'kanban-card-upserted' | 'kanban-card-deleted' | 'kanban-board-config-updated';
  projectId: string;
  card?: KanbanCard;
  cardId?: string;
  boardConfig?: KanbanBoardConfig;
}) => void;

/**
 * Agent and model a project's board runs its cards with.
 *
 * Stored per project because one board drives many sessions: picking the
 * provider/model on the board is what makes `ready` cards start the right kind
 * of run. A card may still override it with its own provider/model.
 */
export type KanbanBoardConfig = {
  provider: LLMProvider | null;
  model: string | null;
  effort: string | null;
};

/**
 * Payload accepted when saving a project's board configuration.
 *
 * An omitted or null `provider` clears the override and lets dispatch fall back
 * to the default provider.
 */
export type SaveKanbanBoardConfigInput = {
  provider?: LLMProvider | null;
  model?: string | null;
  effort?: string | null;
};

/**
 * Application-service surface used by the Kanban HTTP router.
 *
 * Routes parse transport values, call these functions, and format responses;
 * they never import repositories or provider runtime internals.
 */
export type KanbanServices = {
  listCards(projectId: string, options?: { includeArchived?: boolean }): KanbanCard[];
  createCard(input: CreateKanbanCardInput): KanbanCard;
  updateCard(cardId: string, input: UpdateKanbanCardInput): KanbanCard;
  moveCard(cardId: string, status: KanbanCardStatus, position?: number): Promise<KanbanCardMoveResult>;
  abortCard(cardId: string): Promise<KanbanCard>;
  deleteCard(cardId: string): void;
  getBoardConfig(projectId: string): KanbanBoardConfig;
  saveBoardConfig(projectId: string, input: SaveKanbanBoardConfigInput): KanbanBoardConfig;
  reportCardByToken(input: {
    cardId: string;
    token: string;
    status: 'working' | 'needs_decision' | 'done';
    message?: string;
    prUrl?: string;
  }): KanbanCard;
};

/**
 * Handle returned by the injected tracked-run starter.
 *
 * `completed` resolves when the provider runtime settles, which lets the
 * dispatcher release its concurrency slot and fall back to `needs_decision`
 * when the agent ended a turn without reporting a stage itself.
 */
export type KanbanRunHandle = {
  abort(): Promise<void>;
  completed: Promise<void>;
};

/**
 * One agent-run event the dispatcher maps to a card transition.
 *
 * `end_turn` is emitted when a provider turn resolves: an agent that finished a
 * plan and asked a question stops its turn without any tool-level prompt, so
 * ending a turn is the generic "waiting on the user" signal. An explicit
 * `done` report always wins over the fallback.
 */
export type KanbanDispatchSignal = { kind: 'end_turn' };

/**
 * Dependencies injected into the Kanban dispatcher.
 *
 * Every capability is injected so dispatch logic can be unit tested without a
 * provider runtime, database, filesystem, or websocket server. `startRun`
 * owns the chatRunRegistry/provider-runtime wiring; the dispatcher only decides
 * which card to run and how runtime signals map to card stages.
 */
export type KanbanDispatcherDeps = {
  cards: KanbanCardsRepository;
  createSession(input: {
    provider: LLMProvider;
    projectPath: string;
    initialMessage: string;
    model?: string | null;
    effort?: string | null;
  }): Promise<{ sessionId: string }>;
  startRun(input: {
    sessionId: string;
    provider: LLMProvider;
    projectPath: string;
    cwd: string;
    command: string;
    model?: string | null;
    effort?: string | null;
    onSignal: (signal: KanbanDispatchSignal) => void;
  }): Promise<KanbanRunHandle>;
  createWorktree(input: {
    projectPath: string;
    branch: string;
    baseBranch?: string | null;
  }): Promise<{ worktreePath: string; branch: string } | null>;
  removeWorktree(input: { projectPath: string; worktreePath: string }): Promise<void>;
  resolveProjectPath(projectId: string): string | null;
  /** Project-level agent/model defaults; a card's own values win over these. */
  resolveBoardConfig(projectId: string): KanbanBoardConfig;
  reportBaseUrl: string;
  maxConcurrentRuns: number;
  isProviderAvailable(provider: LLMProvider): boolean;
};

/**
 * Application-service surface of the Kanban dispatcher.
 *
 * `dispatch` is fire-and-forget after a card enters `ready`; `abort` stops the
 * run behind a card and returns it to `backlog`; `cleanup` removes the card's
 * worktree when it is archived or deleted.
 */
export type KanbanDispatcher = {
  dispatch(card: KanbanCard): Promise<void>;
  abort(cardId: string): Promise<KanbanCard>;
  canDispatch(): boolean;
  cleanup(card: KanbanCard): Promise<void>;
};

// ---------------------------
//----------------- QUOTA MODULE CONTRACTS ------------
/**
 * Trustworthiness of one quota reading, surfaced next to every account so the
 * user never has to guess whether a percentage is the provider's real state or
 * a local estimate.
 *
 * - `live`: fetched from the provider endpoint during this request.
 * - `cached`: last successful provider read, still inside the cache TTL.
 * - `estimate`: derived from local logs because the provider exposes no limit.
 * - `unknown`: provider gives no remaining-limit data at all.
 * - `error`: the last sync failed; the numbers are the previous good snapshot.
 */
export type QuotaDataQuality = 'live' | 'cached' | 'estimate' | 'unknown' | 'error';

/**
 * The billing horizon a quota window measures. Used by the UI for labels and
 * to decide how a projected exhaustion is displayed.
 */
export type QuotaWindowKind =
  | 'session'
  | 'daily'
  | 'weekly'
  | 'monthly'
  | 'credits'
  | 'metered'
  | 'rolling';

/** One limit window of a subscription account, already enriched for display. */
export type QuotaWindow = {
  /** Human label from the provider, e.g. "Sesja 5 h", "Tygodniowo". */
  label: string;
  kind: QuotaWindowKind;
  /** Used quota in percent, clamped to 0..100. */
  percent: number;
  /** Convenience mirror of `100 - percent`. */
  remainingPercent: number;
  /** Exact reset time when the provider reports it. */
  resetsAt: string | null;
  /** Provider status string, e.g. `ok`, `exceeded`, `throttled`. */
  status: string;
  /**
   * Projected moment the window would hit 100% at the current burn rate, or
   * null when the rate cannot be established or usage is flat.
   */
  projectedExhaustionAt: string | null;
  /** Seconds until `projectedExhaustionAt`, or null when not projected. */
  etaSeconds: number | null;
  /** Percentage points burned per hour, or null with fewer than two samples. */
  burnRatePerHour: number | null;
};

/** One subscription account (provider + plan + optional nickname) with limits. */
export type QuotaAccount = {
  /** Stable id, currently the provider key. */
  id: string;
  /** Provider key: `devin`, `opencode`, `gemini`, or `commandcode`. */
  provider: string;
  /** Display name of the provider. */
  providerLabel: string;
  /** Plan name as reported by the provider. */
  plan: string;
  /** Optional account nickname so two accounts of one provider can be told apart. */
  accountLabel: string;
  /** `active` when the last sync worked, `inactive` when the provider reports no plan, `error` when the sync failed. */
  status: 'active' | 'inactive' | 'error';
  /** Trustworthiness of the numbers in this account. */
  quality: QuotaDataQuality;
  /** When the underlying provider read last succeeded. */
  lastSyncedAt: string | null;
  /** Failure text of the most recent sync attempt, null when it succeeded. */
  syncError: string | null;
  windows: QuotaWindow[];
  /**
   * Agents/workers currently routed to this account, resolved from the kanban
   * board. Empty when nothing is dispatched against it.
   */
  assignedAgents: QuotaAssignedAgent[];
};

/** Top-row KPI values shown above the account list. */
export type QuotaOverview = {
  /** Accounts with at least one window at or above the warning threshold. */
  accountsAtRisk: number;
  /** Accounts that failed their last sync. */
  accountsErrored: number;
  /** Total windows across all accounts that have a projected exhaustion. */
  windowsAtRisk: number;
  /** Earliest reset among all windows, or null when none report one. */
  nextResetAt: string | null;
};

/** Full payload returned by the quota API for one request. */
export type QuotaSnapshot = {
  overview: QuotaOverview;
  accounts: QuotaAccount[];
  generatedAt: string;
};

/**
 * One agent currently routed to a quota account.
 *
 * The account card names these so the operator can see who will be interrupted
 * before disabling routing or letting a limit run out.
 */
export type QuotaAssignedAgent = {
  /** Stable agent/worker id, e.g. `builder-opencode-01`. */
  agentId: string;
  /** Human-readable role of the agent, e.g. `Builder`, `Reviewer`. */
  role: string;
  /** Number of work items currently routed to this account by that agent. */
  activeTasks: number;
};

/**
 * How the app should react when a task is about to run on a throttled account.
 *
 * - `manual`: only show the recommendation; the operator decides.
 * - `ask`: the dispatcher waits for explicit approval before switching.
 * - `auto-low-risk`: switch automatically, but only for low-risk tasks.
 */
export type QuotaRoutingMode = 'manual' | 'ask' | 'auto-low-risk';

/** Per-account alert thresholds and routing switch persisted in app_config. */
export type QuotaAccountConfig = {
  accountId: string;
  /** Percent above which the account is shown as "watch". */
  watchThreshold: number;
  /** Percent above which the account is shown as "danger". */
  dangerThreshold: number;
  /** Whether tasks may still be routed to this account. */
  routingEnabled: boolean;
};

/** Whole-app quota preferences: alerting, thresholds and routing behaviour. */
export type QuotaConfig = {
  routingMode: QuotaRoutingMode;
  alertsEnabled: boolean;
  watchThreshold: number;
  dangerThreshold: number;
  accounts: QuotaAccountConfig[];
};

/** One historical quota reading, used to draw the per-account sparkline. */
export type QuotaHistoryPoint = {
  /** Window label this point belongs to. */
  label: string;
  percent: number;
  at: string;
  resetsAt: string | null;
};

/** History series for one account, oldest first. */
export type QuotaHistory = {
  accountId: string;
  points: QuotaHistoryPoint[];
};

/**
 * Persistence boundary for quota snapshot history.
 *
 * The repository only reads and writes rows; retention and aggregation belong
 * to the Quota service so the SQLite dependency stays swappable in tests.
 */
export type QuotaSnapshotsRepository = {
  /** Appends one reading per (account, window) in a single statement batch. */
  record(
    entries: Array<{
      accountId: string;
      provider: string;
      windowLabel: string;
      windowKind: string;
      percent: number;
      resetsAt: string | null;
      capturedAt: string;
    }>,
  ): void;
  /** Returns the newest `limit` points per window of one account, oldest first. */
  listByAccount(accountId: string, limit: number): QuotaHistoryPoint[];
  /** Deletes rows older than the given ISO timestamp, pruning the table. */
  pruneBefore(cutoffIso: string): number;
};

//----------------- INSIGHTS (USAGE + AGENT FLEET) CONTRACTS ------------
/** Time window accepted by the usage aggregation service. */
export type InsightPeriod = '24h' | '7d' | '30d' | 'all';

/**
 * Dimension the usage buckets are grouped by.
 *
 * `project` is intentionally absent: the external analytics store has no
 * project column, so grouping by project would require guessing from titles.
 */
export type UsageGroupBy = 'provider' | 'model' | 'agent' | 'tool';

/** Token and cost totals for one aggregate, shared by all usage views. */
export type UsageTotals = {
  tokensInput: number;
  tokensOutput: number;
  tokensReasoning: number;
  tokensCacheRead: number;
  tokensCacheWrite: number;
  /** Sum of every token field. */
  tokensTotal: number;
  apiCalls: number;
  costUsd: number;
  sessions: number;
};

/** One group of usage rows (a provider, model, agent, project or tool). */
export type UsageBucket = UsageTotals & {
  /** Stable key used for filtering and React keys. */
  key: string;
  /** Display label for the bucket. */
  label: string;
};

/** One day of the usage trend. */
export type UsageTrendPoint = {
  /** ISO date (YYYY-MM-DD) in UTC. */
  date: string;
  tokensTotal: number;
  costUsd: number;
};

/** Full usage payload for one request. */
export type UsageSummary = {
  period: InsightPeriod;
  groupBy: UsageGroupBy;
  totals: UsageTotals;
  buckets: UsageBucket[];
  trend: UsageTrendPoint[];
  /**
   * Money the cache-read tokens saved versus paying the full input price.
   * Zero when the price table has no entry for the model.
   */
  cacheSavingsUsd: number;
  /**
   * Effective-cost split: money actually billed versus list-price value of the
   * same tokens, so subscription usage is not mistaken for free work.
   */
  effectiveCost: {
    billedUsd: number;
    listPriceUsd: number;
    subscriptionValueUsd: number;
  };
  /** Where the numbers came from, or a reason they are missing. */
  source: string;
  generatedAt: string;
};

/** Lifecycle status of one agent/worker in the fleet view. */
export type AgentFleetStatus = 'running' | 'waiting' | 'failed' | 'finished' | 'queued';

/** One row of the Agent Control Center table. */
export type AgentFleetEntry = {
  agentId: string;
  role: string;
  status: AgentFleetStatus;
  taskId: string | null;
  taskTitle: string | null;
  provider: string | null;
  model: string | null;
  sessionId: string | null;
  tokensTotal: number;
  costUsd: number;
  /** ISO start time when known. */
  startedAt: string | null;
  elapsedSeconds: number;
  /** Short description of the outcome once the run ended. */
  result: string | null;
  /** Retry count when the source tracks it; null when unknown. */
  retryCount: number | null;
};

/** Roll-up counts shown above the agent table. */
export type AgentFleetSummary = {
  running: number;
  waiting: number;
  failed: number;
  finished: number;
  queued: number;
  totalTokens: number;
  totalCostUsd: number;
};

/** Full payload returned by the agent fleet endpoint. */
export type AgentFleetSnapshot = {
  entries: AgentFleetEntry[];
  summary: AgentFleetSummary;
  generatedAt: string;
};
