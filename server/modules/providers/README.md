# Providers Module Guide

This file documents the current provider contract in `server/modules/providers`.
Keep it current whenever provider wiring, skill discovery, or session sync
behavior changes. The goal is that a human or AI agent can add a new provider
without guessing which files need to move.

## Current Provider Shape

Every provider wrapper exposes seven facets:

- `runtime`
- `models`
- `auth`
- `mcp`
- `skills`
- `sessions`
- `sessionSynchronizer`

These correspond to the shared interfaces in `server/shared/interfaces.ts`:

- `IProviderRuntime`
- `IProviderModels`
- `IProviderAuth`
- `IProviderMcp`
- `IProviderSkills`
- `IProviderSessions`
- `IProviderSessionSynchronizer`

The services that consume them are:

- `providerModelsService`
- `providerAuthService`
- `providerMcpService`
- `providerSkillsService`
- `sessionsService`
- `sessionSynchronizerService`

Live execution is consumed through `providerRuntimeService`, which resolves the
provider-owned runtime through the same `providerRegistry` as every other facet.

Current provider ids in this repo are:

- `claude`
- `codex`
- `commandcode`
- `antigravity`
- `cursor`
- `devin`
- `opencode`

Those ids are mirrored in backend unions and in the Flutter client's provider
constants. If adding a new provider, update every place that hardcodes this list
(`grep -rn "'commandcode'" server flutter/lib` finds most of them).

## Current File Layout

Each provider lives under its own folder in `server/modules/providers/list/`:

```text
server/modules/providers/list/<provider>/
  <provider>.provider.ts
  <provider>-runtime.provider.ts
  <provider>-auth.provider.ts
  <provider>-models.provider.ts
  <provider>-mcp.provider.ts
  <provider>-skills.provider.ts
  <provider>-sessions.provider.ts
  <provider>-session-synchronizer.provider.ts
```

The existing provider folders are `antigravity`, `claude`, `codex`, `commandcode`, `cursor`, `devin`, and `opencode`.
Devin still has some plain-JavaScript facets (`devin.provider.js`, `devin-mcp.provider.js`,
`devin-sessions.provider.js`, `devin-skills.provider.js`); new providers should be TypeScript.
OpenCode additionally has `opencode-server.manager.ts` for its local HTTP server.

Each provider wrapper owns its SDK/CLI runtime alongside its auth, model, and
session facets. Runtime adapters receive registry-backed model and session
lookups from `providerRuntimeService` at execution time instead of importing
those services themselves. This keeps `providerRegistry` as the only provider
mapping without creating a circular dependency. Application-level consumers
import the service from `server/modules/providers/index.ts`.

## What Each Facet Does

| Facet | Responsibility | Base / Service |
| --- | --- | --- |
| `runtime` | Run and abort live SDK/CLI sessions | `IProviderRuntime` -> `providerRuntimeService` |
| `models` | Resolve supported and active models | `IProviderModels` -> `providerModelsService` |
| `auth` | Report install/auth state for the provider runtime | `IProviderAuth` -> `providerAuthService` |
| `mcp` | Read, list, write, and remove provider-native MCP config | `McpProvider` -> `providerMcpService` |
| `skills` | Discover provider-native skill markdown files | `SkillsProvider` -> `providerSkillsService` |
| `sessions` | Normalize live events and fetch session history | `IProviderSessions` -> `sessionsService` |
| `sessionSynchronizer` | Scan transcript artifacts and upsert session metadata | `IProviderSessionSynchronizer` -> `sessionSynchronizerService` |

`sessions` and `sessionSynchronizer` are separate concerns:

- `sessions` handles runtime event normalization and history fetches.
- `sessionSynchronizer` handles file-backed session indexing into `sessionsDb`.

## How To Add A Provider

1. Add the provider id everywhere it is part of the contract.

- Update `server/shared/types.ts` `LLMProvider`.
- Update `parseProvider` in `server/modules/providers/provider.routes.ts`.
- Update `server/modules/agent/agent.routes.ts` if the provider is launchable from the agent API.
- Update `server/services.ts` (the composition root) if the provider needs runtime boot or shutdown wiring.
- Update the `PROVIDER_ORDER` list in `public/api-docs.html` if the provider should appear in the public API docs.
- Update the Flutter client if the provider should be visible there (see step 9).

2. Create the wrapper class.

- Add `server/modules/providers/list/<provider>/<provider>.provider.ts`.
- Add `server/modules/providers/list/<provider>/<provider>-runtime.provider.ts`
  when the provider supports live SDK/CLI execution.
- Extend `AbstractProvider`.
- Expose `runtime` (as a lazy getter — see the template below), plus readonly
  `models`, `auth`, `mcp`, `skills`, `sessions`, and `sessionSynchronizer`.
- Call `super('<provider>')`.

3. Implement auth.

- Return a full `ProviderAuthStatus`.
- Treat normal `not installed` / `not authenticated` states as data, not exceptions.
- Keep provider-specific credential discovery inside the auth provider.
- If the provider has no auth step, return a stable unauthenticated or not-installed status instead of omitting the facet.

4. Implement MCP.

- Extend `McpProvider`.
- Pass the supported scopes and transports to `super(...)`.
- Implement the four required methods:
  - `readScopedServers(...)`
  - `writeScopedServers(...)`
  - `buildServerConfig(...)`
  - `normalizeServerConfig(...)`
- Use the shared validation and normalization behavior from `McpProvider`.
- Keep the provider-specific config format local to the provider implementation.

Current MCP formats in this repo are:

| Provider | User / Project Storage | Supported Scopes | Supported Transports |
| --- | --- | --- | --- |
| Claude | `~/.claude.json` (user, and per-project `local` entries), `<workspace>/.mcp.json` (project) | `user`, `local`, `project` | `stdio`, `http`, `sse` |
| Codex | `~/.codex/config.toml`, `<workspace>/.codex/config.toml` | `user`, `project` | `stdio`, `http` |
| Cursor | `.cursor/mcp.json` | `user`, `project` | `stdio`, `http` |
| OpenCode | `~/.config/opencode/opencode.json` or `<workspace>/opencode.json` (`.jsonc` is read when present) | `user`, `project` | `stdio`, `http` |
| Devin | `~/.config/devin/mcp_config.json`, `<workspace>/.devin/mcp_config.json` (+ `.local` variant) | `user`, `local`, `project` | `stdio`, `http`, `sse`, `ws` |
| Command Code | `~/.commandcode/mcp.json`, `<workspace>/.mcp.json`, `~/.commandcode/projects/<slug>/mcp.json` | `user`, `local`, `project` | `stdio`, `http` |
| Antigravity | `~/.gemini/config/mcp_config.json` | `user` | `stdio`, `http` (key is `serverUrl`) |

5. Implement skills.

- Extend `SkillsProvider`.
- Implement `getSkillSources(workspacePath)`.
- Return the actual discovery roots for the provider.
- Skills are discovered from `SKILL.md` files.
- `readProviderSkillMarkdownDefinition(...)` reads front matter `name` and `description`.
- If `name` is missing, the parent directory name is used as a fallback.
- Use `recursive: true` only when the provider stores skills in nested trees.
- Keep the emitted `command` string aligned with the provider's real skill syntax.

Current skill discovery roots are:

| Provider | User Roots | Project / Repo Roots | Prefix | Notes |
| --- | --- | --- | --- | --- |
| Claude | `~/.claude/skills` | `<workspace>/.claude/skills` | `/` | Also discovers Claude plugin skills from enabled plugin installs. Command skills live under `commands/`; markdown skills live under `skills/` and are scanned recursively. |
| Codex | `~/.agents/skills`, `~/.codex/skills`, `~/.codex/skills/.system`, `/etc/codex/skills` | `<workspace>/.agents/skills`, `path.dirname(workspacePath)/.agents/skills`, topmost git root `.agents/skills` | `$` | Overlapping roots are deduplicated before scanning. |
| Cursor | `~/.cursor/skills` | `<workspace>/.cursor/skills`, `<workspace>/.agents/skills` | `/` | Uses slash-style commands. |
| OpenCode | `~/.config/opencode/skills`, `~/.claude/skills`, `~/.agents/skills` | Cwd-to-topmost-git-root `.opencode/skills`, `.claude/skills`, and `.agents/skills` | `/` | Reuses OpenCode, Claude, and Agents skill locations. Overlapping roots are deduplicated before scanning. |
| Devin | `~/.local/share/devin/skills`, `~/.config/devin/skills`, `~/.agents/skills` | `<workspace>/.devin/skills` | `/` | Recursive scan; plugin-cache skills are inferred as a separate scope. |
| Command Code | `~/.commandcode/skills`, `~/.agents/skills` | `<workspace>/.commandcode/skills`, `<workspace>/.agents/skills` | `/` | Project `.commandcode` wins over `.agents`; same precedence at user level. Overlapping roots are deduplicated before scanning. |
| Antigravity | `~/.gemini/config/skills`, `~/.agents/skills` | `<workspace>/.agents/skills` | `/` | User skills live under the shared `~/.gemini/config` root; managed installs target `~/.gemini/config/skills`. |

Command forms currently used by the providers are:

- Claude user/project skills: `/skill-name`
- Claude plugin skills: `/plugin-name:skill-name`
- Codex skills: `$skill-name`
- Cursor skills: `/skill-name`
- OpenCode skills: `/skill-name`
- Devin skills: `/skill-name`
- Command Code skills: `/skill-name`
- Antigravity skills: `/skill-name`

6. Implement sessions.

- Implement `normalizeMessage(raw, sessionId)` and `fetchHistory(sessionId, options)`.
- Use `createNormalizedMessage(...)` and `generateMessageId(...)` for emitted messages.
- Keep normalized message ids unique. If one raw event produces multiple text
  parts, append a discriminator so ids do not collide.
- Keep pagination consistent:
  - `limit: null` means unbounded/full history.
  - `limit: 0` means an empty page.
  - always return `total`, `hasMore`, `offset`, and `limit` when paginating.
- Sanitize any filesystem-derived ids before using them in file or database paths.
- Do not assume a provider's history format matches another provider's format.

7. Implement session synchronization.

- Implement `synchronize(since?: Date)` to scan provider artifacts and upsert
  sessions into `sessionsDb`.
- Implement `synchronizeFile(filePath)` for single-file watcher updates.
- Use the existing helpers when they fit:
  - `buildLookupMap(...)`
  - `extractFirstValidJsonlData(...)`
  - `findFilesRecursivelyCreatedAfter(...)`
  - `normalizeSessionName(...)`
  - `readFileTimestamps(...)`
- Make the sync resilient to partial, malformed, or missing provider files.
- The orchestration service runs all provider synchronizers and only advances
  `scan_state.last_scanned_at` when every provider succeeds.

Current session sync roots are:

| Provider | Scan Roots | Metadata Helpers / Notes |
| --- | --- | --- |
| Claude | `~/.claude/projects/**/*.jsonl` | Uses `~/.claude/history.jsonl` for name lookup and the trailing `ai-title`, `last-prompt`, or `custom-title` entries for title recovery. |
| Codex | `~/.codex/sessions/**/*.jsonl` | Uses `~/.codex/session_index.jsonl` for title lookup and the last `task_complete` message for a fallback title. |
| Cursor | `~/.cursor/projects/**/*.jsonl` | Uses sibling `worker.log` to recover `workspacePath`, then derives the session title from the first user prompt. |
| OpenCode | `~/.local/share/opencode/opencode.db` | Reads active sessions/messages/parts from OpenCode's shared SQLite database and stores `jsonl_path` as `null` so deleting one app session cannot remove the shared DB. |
| Devin | `~/.local/share/devin/cli/sessions.db` | Reads sessions (id, working directory, title, timestamps) from Devin CLI's SQLite database. The watcher also picks up the `<repo>/.ddagent/devin/<id>.jsonl` transcript mirrors and resolves their metadata from that database; subagent sessions are skipped. |
| Command Code | `~/.commandcode/projects/<slug>/<session-id>.jsonl` | v3 append-only transcripts with a `type:"session"` header row (`id` + `cwd`); `.meta.json` sidecars carry titles. Only primary `*.jsonl` files are indexed — `.meta.json`/`.checkpoints.jsonl`/`.v2.bak` sidecars are skipped. |
| Antigravity | `~/.gemini/antigravity-cli/conversations/<id>.db` + `conversation_summaries.db` | Conversations are protobuf rows inside SQLite — the synchronizer indexes `conversation_summaries` (id, title, `workspace_uris`, timestamps) and the runtime mirrors each turn into `<workspace>/.ddagent/antigravity/<id>.jsonl` for readable history. |

8. Register the provider.

- Add the new provider class to `server/modules/providers/provider.registry.ts`.
- Update `parseProvider` in `server/modules/providers/provider.routes.ts`.
- If the provider introduces a new service or lifecycle hook, export it from the module entrypoint that consumes providers.

9. Wire runtime and UI surfaces outside the providers module when needed.

If the provider can run live chat sessions, update the runtime entrypoints too:

- `server/modules/providers/list/<provider>/<provider>-runtime.provider.ts`
- `server/modules/providers/list/<provider>/<provider>.provider.ts`
- `server/modules/agent/agent.routes.ts`
- `server/services.ts`

If the provider is visible in the Flutter client, update (under `flutter/lib/features/`):

- `settings/view/sections/agents_section.dart` — `AgentsSection.agents`, display names, auth-dot colors, account description
- `sessions/view/provider_logo.dart` — provider logo
- `mcp/data/mcp_constants.dart` — `kMcpProviders`, supported scopes/transports
- `skills/data/skills_constants.dart` — `kSkillProviders`, managed skill dirs
- `terminal/view/provider_login_dialog.dart` — login/setup flow
- `settings/data/agent_install.dart` — install/update commands
- `chat/view/model_library_panel.dart` and `chat/state/composer_controller.dart` — model library and effort levels
- `lib/i18n/en.i18n.json` (and the other locales) for any new strings

Then run the Flutter checks from `flutter/README.md`.

## Minimal Wrapper Template

```ts
import { AbstractProvider } from '@/modules/providers/shared/base/abstract.provider.js';
import { <Provider>ProviderAuth } from './<provider>-auth.provider.js';
import { <Provider>ProviderModels } from './<provider>-models.provider.js';
import { <Provider>McpProvider } from './<provider>-mcp.provider.js';
import { <provider>Runtime } from './<provider>-runtime.provider.js';
import { <Provider>SkillsProvider } from './<provider>-skills.provider.js';
import { <Provider>SessionsProvider } from './<provider>-sessions.provider.js';
import { <Provider>SessionSynchronizer } from './<provider>-session-synchronizer.provider.js';
import type {
  IProviderAuth,
  IProviderMcp,
  IProviderModels,
  IProviderRuntime,
  IProviderSessionSynchronizer,
  IProviderSessions,
  IProviderSkills,
} from '@/shared/interfaces.js';

export class <Provider>Provider extends AbstractProvider {
  // Lazy getter: runtime -> notifications -> remote-approval -> providers is a
  // live import cycle, so reading the runtime binding during field init can hit
  // the TDZ. Every existing provider uses this pattern.
  private _runtime: IProviderRuntime | null = null;
  get runtime(): IProviderRuntime {
    return (this._runtime ??= <provider>Runtime);
  }
  readonly models: IProviderModels = new <Provider>ProviderModels();
  readonly auth: IProviderAuth = new <Provider>ProviderAuth();
  readonly mcp: IProviderMcp = new <Provider>McpProvider();
  readonly skills: IProviderSkills = new <Provider>SkillsProvider();
  readonly sessions: IProviderSessions = new <Provider>SessionsProvider();
  readonly sessionSynchronizer: IProviderSessionSynchronizer =
    new <Provider>SessionSynchronizer();

  constructor() {
    super('<provider>');
  }
}
```

## Minimal Skills Template

```ts
import path from 'node:path';

import { SkillsProvider } from '@/modules/providers/shared/skills/skills.provider.js';
import type { ProviderSkillSource } from '@/shared/types.js';

export class <Provider>SkillsProvider extends SkillsProvider {
  constructor() {
    super('<provider>');
  }

  protected async getSkillSources(workspacePath: string): Promise<ProviderSkillSource[]> {
    return [
      {
        scope: 'project',
        rootDir: path.join(workspacePath, '.<provider>', 'skills'),
        commandPrefix: '/',
      },
    ];
  }
}
```

## Minimal Session Sync Template

```ts
import type { IProviderSessionSynchronizer } from '@/shared/interfaces.js';

export class <Provider>SessionSynchronizer implements IProviderSessionSynchronizer {
  async synchronize(since?: Date): Promise<number> {
    return 0;
  }

  async synchronizeFile(filePath: string): Promise<string | null> {
    return null;
  }
}
```

## AI Prompt Template

Use this prompt when asking an AI agent to add a provider:

```text
Add a new provider "<provider>" using the current provider module architecture.

Requirements:
1) Create:
   - server/modules/providers/list/<provider>/<provider>.provider.ts
   - server/modules/providers/list/<provider>/<provider>-runtime.provider.ts
   - server/modules/providers/list/<provider>/<provider>-auth.provider.ts
   - server/modules/providers/list/<provider>/<provider>-models.provider.ts
   - server/modules/providers/list/<provider>/<provider>-mcp.provider.ts
   - server/modules/providers/list/<provider>/<provider>-skills.provider.ts
   - server/modules/providers/list/<provider>/<provider>-sessions.provider.ts
   - server/modules/providers/list/<provider>/<provider>-session-synchronizer.provider.ts
2) Register in:
   - server/modules/providers/provider.registry.ts
   - server/modules/providers/provider.routes.ts (parseProvider)
   - server/shared/types.ts LLMProvider
   - the Flutter provider lists (see "Wire runtime and UI surfaces")
3) Mirror the nearest existing provider implementation for file naming, style,
   and error handling.
4) Implement skills support with SkillsProvider and the current skill roots.
5) Implement session synchronization if the provider stores transcript files.
6) Ensure sessions use unique ids, safe path handling, and correct pagination.
7) Keep `sessions` and `sessionSynchronizer` separate.
8) Run:
   - npx eslint <touched files>
   - npm run typecheck
   - npm test
```

## Validation

After adding or changing a provider, run the relevant checks:

```bash
npx eslint server/modules/providers server/shared/types.ts server/shared/interfaces.ts
npm run typecheck   # tsc --noEmit -p server/tsconfig.json
npm test            # all server tests
```

Useful tests in this repo:

- `server/modules/providers/tests/mcp.test.ts`
- `server/modules/providers/tests/skills.test.ts`
- `server/modules/providers/tests/opencode-sessions.test.ts`
- `server/modules/providers/tests/provider-auth-identity.test.ts`
- `server/modules/providers/tests/runtime-lifecycle.test.ts`

If you touch sessions or session synchronization, add or update focused tests
alongside the implementation.

## Common Mistakes

- Adding provider files but forgetting `provider.registry.ts` or
  `provider.routes.ts`.
- Adding a live runtime without exposing it from the provider wrapper.
- Updating backend provider ids but not the Flutter provider constants.
- Omitting `runtime`, `skills`, or `sessionSynchronizer` from the wrapper.
- Returning duplicate normalized message ids for split content.
- Treating `limit === 0` as unbounded history.
- Building file paths from raw session ids without validation.
- Hardcoding a skill root without checking the provider's actual discovery rules.
- Forgetting that Claude plugin skills are discovered differently from normal
  user/project skill folders.
- Assuming one provider's MCP config file format works for the others.

## Ambient login identity for Flutter

`GET /api/providers/:provider/auth/status` returns
`{ success: true, data: { installed, provider, authenticated, email, method, canLogout, error? } }`
with `Cache-Control: no-store`. It describes the server's ambient/default CLI
credentials, not an isolated account selected through `provider-accounts`.

`canLogout` is `true` only when the provider adapter implements
`IProviderAuth.logout`. `POST /api/providers/:provider/auth/logout` clears that
adapter's stored credential file (best-effort — a missing file still succeeds)
and returns the same status shape with `Cache-Control: no-store`. Providers whose
login is owned by an environment variable or an OS keyring omit `logout` and
answer `501 LOGOUT_UNSUPPORTED`. Credentials injected through the server
environment cannot be cleared by the endpoint.

`email` is the existing nullable **display identity** field. It contains an email
or a credential-store username (notably Command Code's `userName`, and legacy
`user` claims). It is not an account ID for authorization or routing. No new API
field is needed. Generic credential-source labels and API keys are never identities.

| Provider | Identity source / limitation |
| --- | --- |
| Antigravity / Gemini | `~/.gemini/antigravity-cli/antigravity-oauth-token`: existing shared `id_token` email/user extraction, alongside `token.access_token` or `token.refresh_token`. `GEMINI_API_KEY` has no identity. |
| Claude | `~/.claude/.credentials.json`: `email` or legacy `user`, only with a usable `claudeAiOauth.accessToken` and an unexpired login. Environment/settings keys and opaque OAuth tokens have no identity. Separate profile metadata is not assumed to belong to the active credentials. |
| Codex | `~/.codex/auth.json`: `tokens.id_token` email/user claims alongside an access/refresh token. `OPENAI_API_KEY` in that file has no identity. |
| Cursor | Email from successful `cursor-agent status` output (`Logged in as …`). Generic `Logged in` has no identity. |
| Command Code | `~/.commandcode/auth.json`: `userName` alongside `apiKey`, else `cmd whoami` (`Email`, `Username`, `Name`). Environment or upstream provider keys have no identity. |
| Devin | `devin auth status`: `Email`, else `Name`. TOML `windsurf_api_key`, environment keys, and JSON config keys carry no account identity. |
| OpenCode | Upstream API/OAuth/well-known credentials or environment keys do not establish a single OpenCode account identity; always `email: null`. |

Status checks re-read credential state; credential-file identities are not
cached. Only the Command Code (`cmd whoami`) and Devin (`devin auth status`)
CLI probes are memoized for 60s — they hit the network and would otherwise stall
every Settings render. Missing identity is explicitly `email: null`, including
when a previous response had an identity. Missing/removed credentials and logout
clear both the login and the identity (unless another configured credential
source still applies). JWT claims label locally stored credentials; they are not
signature verification or a remote token-revocation check. Opaque keys are never
probed online — only the CLI identity subcommands listed above.

Flutter should replace, rather than merge, each status response into its cache.
Render the real identity (`loggedInAs(email)`) when `authenticated == true` and
trimmed `email` is nonempty; clear it on logout/invalidation and when `email` is
null. When authenticated without a real identity (API-key logins, providers with
no local name source), Flutter renders the provider-scoped fallback label
(`settings.agents.authStatus.providerAccount`) instead of the bare
`Connected`, so every agent names an account. Generic labels sent by older
servers are still not account identities. Backend cache headers cannot clear an
already retained Riverpod value without a new request/invalidation.
