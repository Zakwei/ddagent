const USER_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT 1,
    git_name TEXT,
    git_email TEXT,
    has_completed_onboarding BOOLEAN DEFAULT 0
);
`;

export const API_KEYS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS api_keys (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    key_name TEXT NOT NULL,
    api_key TEXT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_used DATETIME,
    is_active BOOLEAN DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
`;

export const USER_CREDENTIALS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS user_credentials (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    credential_name TEXT NOT NULL,
    credential_type TEXT NOT NULL, -- 'github_token', 'gitlab_token', 'bitbucket_token', etc.
    credential_value TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
`;

export const USER_NOTIFICATION_PREFERENCES_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS user_notification_preferences (
    user_id INTEGER PRIMARY KEY,
    preferences_json TEXT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
`;

export const VAPID_KEYS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS vapid_keys (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    public_key TEXT NOT NULL,
    private_key TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

export const PUSH_SUBSCRIPTIONS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS push_subscriptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    endpoint TEXT NOT NULL UNIQUE,
    keys_p256dh TEXT NOT NULL,
    keys_auth TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
`;

export const NOTIFICATION_CHANNEL_ENDPOINTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS notification_channel_endpoints (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    channel TEXT NOT NULL,
    endpoint_id TEXT NOT NULL,
    label TEXT,
    metadata_json TEXT,
    enabled BOOLEAN DEFAULT 1,
    last_seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, channel, endpoint_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
`;

export const PROJECTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS projects (
    project_id TEXT PRIMARY KEY NOT NULL,
    project_path TEXT NOT NULL UNIQUE,
    custom_project_name TEXT DEFAULT NULL,
    isStarred BOOLEAN DEFAULT 0,
    isArchived BOOLEAN DEFAULT 0,
    -- Per-project override of the repo's .ddagent/worktree.json scripts
    -- (NULL columns = fall back to the repo file).
    worktree_setup_script TEXT DEFAULT NULL,
    worktree_run_script TEXT DEFAULT NULL,
    worktree_run_port INTEGER DEFAULT NULL
);
`;

export const SESSIONS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS sessions (
    session_id TEXT NOT NULL,
    provider TEXT NOT NULL DEFAULT 'claude',
    -- The session id used by the provider CLI/SDK on disk (JSONL file name,
    -- store.db folder, sqlite row id, ...). \`session_id\` is the stable
    -- app-facing id that the frontend uses for the whole session lifetime;
    -- \`provider_session_id\` is filled in once the provider announces its own
    -- id mid-run, or equals \`session_id\` for sessions discovered on disk.
    provider_session_id TEXT,
    custom_name TEXT,
    project_path TEXT,
    jsonl_path TEXT,
    -- Model and reasoning effort this session runs with. Written when the user
    -- changes either selection and on every send, so reopening a session
    -- restores its exact runtime configuration instead of provider defaults.
    model TEXT,
    effort TEXT,
    -- Approval/permission mode pinned to the session (default, acceptEdits,
    -- bypassPermissions, plan, auto). NULL = fall back to the client's
    -- per-provider preference until the user picks a mode or sends a turn.
    permission_mode TEXT,
    isArchived BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- NULL = never viewed in the app; unread = last_viewed_at < updated_at.
    last_viewed_at DATETIME,
    -- Stamped once the project's .ddagent/shared-context.md was prepended to
    -- this session's first outbound message (NULL = not injected yet).
    shared_context_injected_at DATETIME,
    -- Context window the provider CLI last reported for this session (NULL =
    -- not reported yet); transcripts never record it.
    context_window INTEGER,
    PRIMARY KEY (session_id),
    FOREIGN KEY (project_path) REFERENCES projects(project_path)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
`;

export const LAST_SCANNED_AT_SQL = `
CREATE TABLE IF NOT EXISTS scan_state (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  last_scanned_at TIMESTAMP NULL
);
`;

export const PROVIDER_ACCOUNTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS provider_accounts (
    -- One named credential set per provider; env_overrides is a JSON object of
    -- KEY:VALUE pairs merged into the provider's child env at spawn time.
    id TEXT NOT NULL PRIMARY KEY,
    provider TEXT NOT NULL,
    label TEXT NOT NULL,
    env_overrides TEXT NOT NULL DEFAULT '{}',
    is_default BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

export const SCHEDULES_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS schedules (
    -- A recurring agent run: cron expression in local server time. next_run_at
    -- is materialized so the ticker only compares timestamps instead of
    -- re-evaluating expressions.
    id TEXT NOT NULL PRIMARY KEY,
    project_id TEXT NOT NULL,
    provider TEXT NOT NULL,
    cron TEXT NOT NULL,
    prompt TEXT NOT NULL,
    use_worktree BOOLEAN NOT NULL DEFAULT 0,
    catch_up BOOLEAN NOT NULL DEFAULT 0,
    enabled BOOLEAN NOT NULL DEFAULT 1,
    fail_count INTEGER NOT NULL DEFAULT 0,
    last_run_at DATETIME NULL,
    next_run_at DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

export const SCHEDULE_RUNS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS schedule_runs (
    -- One row per fire attempt (including skipped missed runs) so the UI can
    -- show history and the fail counter has an audit trail.
    id TEXT NOT NULL PRIMARY KEY,
    schedule_id TEXT NOT NULL,
    session_id TEXT NULL,
    status TEXT NOT NULL,
    error TEXT NULL,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    finished_at DATETIME NULL,
    FOREIGN KEY (schedule_id) REFERENCES schedules(id) ON DELETE CASCADE
);
`;

export const APP_CONFIG_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS app_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

/**
 * Persistent custom-model library used by the Providers module.
 *
 * Only user-created models are stored here. Predefined models remain source-
 * controlled in each provider's `-models.provider.ts` adapter so they can be
 * updated without migrating application data. `model_id` is unique only within
 * a provider because different CLIs can accept the same identifier.
 */
export const PROVIDER_MODELS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS provider_models (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider TEXT NOT NULL CHECK (provider IN ('claude', 'cursor', 'codex', 'opencode', 'devin', 'commandcode', 'antigravity')),
    model_id TEXT NOT NULL,
    model_name TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(provider, model_id)
);
`;

/**
 * Per-user starred model ids used by the Providers module.
 *
 * Favorites are scoped to a user and provider so a signed-in user's starred
 * models survive app updates/reinstalls and sync across devices. `model_id` is
 * the provider catalog option's `value` (a predefined or custom model id), not
 * its human label. The parent `users` row cascades on delete.
 */
export const USER_FAVORITE_MODELS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS user_favorite_models (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    provider TEXT NOT NULL CHECK (provider IN ('claude', 'cursor', 'codex', 'opencode', 'devin', 'commandcode', 'antigravity')),
    model_id TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, provider, model_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
`;

/**
 * Persistent kanban cards for the Kanban module.
 *
 * One row is one unit of agent work shown as a board card. `status` is the
 * canonical workflow stage (`backlog`, `ready`, `working`, `needs_decision`,
 * `done`, `archived`); the agent owns every transition after `ready`, so rows
 * are updated by both the dispatcher and the agent reporting tool.
 *
 * `project_id` is intentionally not a hard foreign key: the projects table is
 * rebuilt during migrations, and a stale card must not block that rebuild.
 * Cards resolve their project through the Projects module at read time.
 *
 * `session_id` links the card to its app session once dispatch allocates one,
 * and `worktree_path`/`branch` record the isolated checkout created for it.
 *
 * `report_token` is a per-card secret embedded in the agent's kickoff prompt.
 * The agent reports its own stage by calling the token-guarded report endpoint,
 * which keeps stage reporting provider-agnostic without any MCP registration.
 */
export const KANBAN_CARDS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS kanban_cards (
    card_id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'backlog',
    position INTEGER NOT NULL DEFAULT 0,
    session_id TEXT,
    provider TEXT,
    model TEXT,
    effort TEXT,
    worktree_path TEXT,
    branch TEXT,
    pr_url TEXT,
    status_message TEXT,
    report_token TEXT,
    is_archived INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

/**
 * Quota snapshot history.
 *
 * Every provider sweep appends one row per (account, window) so the Quotas
 * screen can draw a burn-down sparkline and the dashboard can alert on a
 * trend, without any extra provider calls. Rows are pruned to a rolling
 * retention window by the quota service.
 */
export const QUOTA_SNAPSHOTS_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS quota_snapshots (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id TEXT NOT NULL,
    provider TEXT NOT NULL,
    window_label TEXT NOT NULL,
    window_kind TEXT NOT NULL,
    percent REAL NOT NULL,
    resets_at TEXT,
    captured_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
`;

/**
 * Server-side outbound message queue.
 *
 * One row is a chat message the user queued while the target session was busy
 * (or while offline). Because the queue lives on the server it survives page
 * reloads and device switches — unlike the previous localStorage-only queue.
 * The row carries everything needed to replay the send: the command text and
 * the JSON-encoded provider options (including verified attachments).
 *
 * `status` is `queued` while waiting for the session to become idle,
 * `sending` while a dispatch is in flight, and `sent`/`failed` once terminal.
 * Rows are ordered by `position` (then `id`) so a user's "send now" can promote
 * a specific entry to the front without reordering the rest.
 */
export const QUEUED_MESSAGES_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS queued_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    session_id TEXT NOT NULL,
    content TEXT NOT NULL,
    options_json TEXT NOT NULL DEFAULT '{}',
    status TEXT NOT NULL DEFAULT 'queued',
    error TEXT,
    position INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

// No FK on user_id: platform-mode sockets sync under the sentinel bucket 0,
// which has no users row — an FK would reject those writes outright.
export const USER_WORKSPACE_STATE_TABLE_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS user_workspace_state (
    user_id INTEGER PRIMARY KEY,
    state_json TEXT NOT NULL,
    revision INTEGER NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
`;

/**
 * Knowledge-base schema (Contexta-style local memory layer).
 *
 * Entities (`kb_memories`, `kb_rules`, `kb_skills`, `kb_personal_information`)
 * carry optional project scoping through `project_id`; skills and personal
 * information are always global. `project_id` is intentionally NOT a foreign
 * key: the projects table is rebuilt during migrations (like kanban_cards), so
 * a stale reference must not block that rebuild — the Projects module resolves
 * paths at read time.
 *
 * `kb_search_index_fts` is an external-content-free FTS5 table kept in sync by
 * per-entity triggers, so search never scans whole tables. `kb_entity_history`
 * snapshots writes (notably agent/MCP writes) so they can be reviewed and
 * reverted. `kb_scan_state` remembers the content hash of every scanned project
 * file so rescans only re-import changed files.
 */
export const KB_TABLES_SCHEMA_SQL = `
CREATE TABLE IF NOT EXISTS kb_memories (
    id TEXT PRIMARY KEY NOT NULL,
    project_id TEXT,
    title TEXT NOT NULL,
    content TEXT NOT NULL DEFAULT '',
    memory_type TEXT NOT NULL DEFAULT 'fact',
    priority TEXT NOT NULL DEFAULT 'normal',
    source TEXT NOT NULL DEFAULT 'manual',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_kb_memories_project ON kb_memories(project_id);
CREATE INDEX IF NOT EXISTS idx_kb_memories_priority ON kb_memories(priority);
CREATE INDEX IF NOT EXISTS idx_kb_memories_updated ON kb_memories(updated_at DESC);

CREATE TABLE IF NOT EXISTS kb_rules (
    id TEXT PRIMARY KEY NOT NULL,
    project_id TEXT,
    title TEXT NOT NULL,
    content TEXT NOT NULL DEFAULT '',
    priority TEXT NOT NULL DEFAULT 'normal',
    enabled INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_kb_rules_project ON kb_rules(project_id);
CREATE INDEX IF NOT EXISTS idx_kb_rules_priority ON kb_rules(priority);

CREATE TABLE IF NOT EXISTS kb_skills (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL DEFAULT '',
    content TEXT NOT NULL DEFAULT '',
    category TEXT NOT NULL DEFAULT 'general',
    icon TEXT NOT NULL DEFAULT '',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_kb_skills_category ON kb_skills(category);

CREATE TABLE IF NOT EXISTS kb_personal_information (
    id TEXT PRIMARY KEY NOT NULL,
    key TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    content TEXT NOT NULL DEFAULT '',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS kb_tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS kb_memory_tags (
    memory_id TEXT NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (memory_id, tag_id),
    FOREIGN KEY (memory_id) REFERENCES kb_memories(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES kb_tags(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_kb_memory_tags_tag ON kb_memory_tags(tag_id);

CREATE TABLE IF NOT EXISTS kb_connections (
    id TEXT PRIMARY KEY NOT NULL,
    source_id TEXT NOT NULL,
    source_type TEXT NOT NULL,
    target_id TEXT NOT NULL,
    target_type TEXT NOT NULL,
    relationship TEXT NOT NULL DEFAULT 'related',
    weight REAL NOT NULL DEFAULT 1.0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_kb_connections_source ON kb_connections(source_id, source_type);
CREATE INDEX IF NOT EXISTS idx_kb_connections_target ON kb_connections(target_id, target_type);

CREATE TABLE IF NOT EXISTS kb_entity_history (
    id TEXT PRIMARY KEY NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    title TEXT NOT NULL DEFAULT '',
    content TEXT NOT NULL DEFAULT '',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_kb_history_entity ON kb_entity_history(entity_id, created_at DESC);

CREATE TABLE IF NOT EXISTS kb_embeddings (
    id TEXT PRIMARY KEY NOT NULL,
    entity_id TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    model TEXT NOT NULL DEFAULT '',
    embedding TEXT NOT NULL DEFAULT '',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_kb_embeddings_entity ON kb_embeddings(entity_id, entity_type);

CREATE TABLE IF NOT EXISTS kb_scan_state (
    project_id TEXT NOT NULL,
    path TEXT NOT NULL,
    content_hash TEXT NOT NULL,
    entity_type TEXT NOT NULL DEFAULT 'memory',
    entity_id TEXT,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (project_id, path)
);

CREATE VIRTUAL TABLE IF NOT EXISTS kb_search_index_fts USING fts5(
    entity_type UNINDEXED,
    entity_id UNINDEXED,
    project_id UNINDEXED,
    title,
    content,
    tokenize='porter unicode61'
);

CREATE TRIGGER IF NOT EXISTS kb_memories_ai AFTER INSERT ON kb_memories BEGIN
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('memory', NEW.id, NEW.project_id, NEW.title, NEW.content);
END;
CREATE TRIGGER IF NOT EXISTS kb_memories_ad AFTER DELETE ON kb_memories BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'memory' AND entity_id = OLD.id;
END;
CREATE TRIGGER IF NOT EXISTS kb_memories_au AFTER UPDATE ON kb_memories BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'memory' AND entity_id = OLD.id;
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('memory', NEW.id, NEW.project_id, NEW.title, NEW.content);
END;

CREATE TRIGGER IF NOT EXISTS kb_rules_ai AFTER INSERT ON kb_rules BEGIN
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('rule', NEW.id, NEW.project_id, NEW.title, NEW.content);
END;
CREATE TRIGGER IF NOT EXISTS kb_rules_ad AFTER DELETE ON kb_rules BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'rule' AND entity_id = OLD.id;
END;
CREATE TRIGGER IF NOT EXISTS kb_rules_au AFTER UPDATE ON kb_rules BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'rule' AND entity_id = OLD.id;
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('rule', NEW.id, NEW.project_id, NEW.title, NEW.content);
END;

CREATE TRIGGER IF NOT EXISTS kb_skills_ai AFTER INSERT ON kb_skills BEGIN
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('skill', NEW.id, NULL, NEW.name, NEW.description || ' ' || NEW.content);
END;
CREATE TRIGGER IF NOT EXISTS kb_skills_ad AFTER DELETE ON kb_skills BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'skill' AND entity_id = OLD.id;
END;
CREATE TRIGGER IF NOT EXISTS kb_skills_au AFTER UPDATE ON kb_skills BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'skill' AND entity_id = OLD.id;
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('skill', NEW.id, NULL, NEW.name, NEW.description || ' ' || NEW.content);
END;

CREATE TRIGGER IF NOT EXISTS kb_personal_ai AFTER INSERT ON kb_personal_information BEGIN
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('personal', NEW.id, NULL, NEW.title, NEW.content);
END;
CREATE TRIGGER IF NOT EXISTS kb_personal_ad AFTER DELETE ON kb_personal_information BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'personal' AND entity_id = OLD.id;
END;
CREATE TRIGGER IF NOT EXISTS kb_personal_au AFTER UPDATE ON kb_personal_information BEGIN
    DELETE FROM kb_search_index_fts WHERE entity_type = 'personal' AND entity_id = OLD.id;
    INSERT INTO kb_search_index_fts(entity_type, entity_id, project_id, title, content)
    VALUES ('personal', NEW.id, NULL, NEW.title, NEW.content);
END;
`;

export const INIT_SCHEMA_SQL = `
-- Initialize authentication database
PRAGMA foreign_keys = ON;

${USER_TABLE_SCHEMA_SQL}
-- Indexes for performance for user lookups
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(is_active);

${API_KEYS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_api_keys_key ON api_keys(api_key);
CREATE INDEX IF NOT EXISTS idx_api_keys_user_id ON api_keys(user_id);
CREATE INDEX IF NOT EXISTS idx_api_keys_active ON api_keys(is_active);

${USER_CREDENTIALS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_user_credentials_user_id ON user_credentials(user_id);
CREATE INDEX IF NOT EXISTS idx_user_credentials_type ON user_credentials(credential_type);
CREATE INDEX IF NOT EXISTS idx_user_credentials_active ON user_credentials(is_active);

${USER_NOTIFICATION_PREFERENCES_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_user_notification_preferences_user_id ON user_notification_preferences(user_id);

${VAPID_KEYS_TABLE_SCHEMA_SQL}

${PUSH_SUBSCRIPTIONS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_push_subscriptions_user_id ON push_subscriptions(user_id);

${NOTIFICATION_CHANNEL_ENDPOINTS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_notification_channel_endpoints_user_channel ON notification_channel_endpoints(user_id, channel);
CREATE INDEX IF NOT EXISTS idx_notification_channel_endpoints_enabled ON notification_channel_endpoints(enabled);

${PROJECTS_TABLE_SCHEMA_SQL}
-- NOTE: These indexes are created in migrations after legacy table-shape repairs.
-- Creating them here can fail on upgraded installs where projects lacks those columns.

${SESSIONS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_session_ids_lookup ON sessions(session_id);
-- NOTE: This index is created in migrations after sessions is rebuilt to include project_path.
-- Creating it here can fail on upgraded installs where the legacy sessions table has no project_path.

${LAST_SCANNED_AT_SQL}

${APP_CONFIG_TABLE_SCHEMA_SQL}

${PROVIDER_MODELS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_provider_models_provider_order
ON provider_models(provider, sort_order, id);

${USER_FAVORITE_MODELS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_user_favorite_models_user_provider
ON user_favorite_models(user_id, provider, sort_order, id);

${KANBAN_CARDS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_kanban_cards_project_status
ON kanban_cards(project_id, is_archived, status, position);

${QUOTA_SNAPSHOTS_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_quota_snapshots_account_window
ON quota_snapshots(account_id, window_label, captured_at);

${QUEUED_MESSAGES_TABLE_SCHEMA_SQL}
CREATE INDEX IF NOT EXISTS idx_queued_messages_session_status
ON queued_messages(session_id, status, position, id);

${USER_WORKSPACE_STATE_TABLE_SCHEMA_SQL}

${KB_TABLES_SCHEMA_SQL}
`;
