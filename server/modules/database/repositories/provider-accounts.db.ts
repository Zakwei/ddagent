import { getConnection } from '@/modules/database/connection.js';

/**
 * One named credential set for a provider — e.g. a second Claude login living
 * in its own CLAUDE_CONFIG_DIR. `env_overrides` is a JSON object of
 * KEY:VALUE pairs merged into the provider's child environment at spawn time.
 */
export type ProviderAccountRow = {
  id: string;
  provider: string;
  label: string;
  env_overrides: string;
  is_default: number;
  created_at: string;
};

export type ProviderAccount = {
  id: string;
  provider: string;
  label: string;
  envOverrides: Record<string, string>;
  isDefault: boolean;
  createdAt: string;
};

function toAccount(row: ProviderAccountRow): ProviderAccount {
  let envOverrides: Record<string, string> = {};
  try {
    const parsed = JSON.parse(row.env_overrides || '{}');
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
      envOverrides = parsed as Record<string, string>;
    }
  } catch {
    // Malformed JSON degrades to no overrides instead of failing the request.
  }
  return {
    id: row.id,
    provider: row.provider,
    label: row.label,
    envOverrides,
    isDefault: row.is_default === 1,
    createdAt: row.created_at,
  };
}

/**
 * `provider_accounts` persistence. `is_default` is enforced per provider:
 * setting one clears the others for the same provider in the same update.
 */
export const providerAccountsDb = {
  list(provider?: string): ProviderAccount[] {
    const db = getConnection();
    const rows = (
      provider
        ? db.prepare('SELECT * FROM provider_accounts WHERE provider = ? ORDER BY created_at, id').all(provider)
        : db.prepare('SELECT * FROM provider_accounts ORDER BY provider, created_at, id').all()
    ) as ProviderAccountRow[];
    return rows.map(toAccount);
  },

  get(id: string): ProviderAccount | null {
    const db = getConnection();
    const row = db.prepare('SELECT * FROM provider_accounts WHERE id = ?').get(id) as
      | ProviderAccountRow
      | undefined;
    return row ? toAccount(row) : null;
  },

  create(input: {
    id: string;
    provider: string;
    label: string;
    envOverrides: Record<string, string>;
    isDefault?: boolean;
  }): ProviderAccount {
    const db = getConnection();
    db.prepare(
      `INSERT INTO provider_accounts (id, provider, label, env_overrides, is_default, created_at)
       VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)`,
    ).run(
      input.id,
      input.provider,
      input.label,
      JSON.stringify(input.envOverrides ?? {}),
      input.isDefault ? 1 : 0,
    );
    if (input.isDefault) {
      db.prepare(
        'UPDATE provider_accounts SET is_default = 0 WHERE provider = ? AND id <> ?',
      ).run(input.provider, input.id);
    }
    return this.get(input.id) as ProviderAccount;
  },

  update(
    id: string,
    patch: { label?: string; envOverrides?: Record<string, string>; isDefault?: boolean },
  ): ProviderAccount | null {
    const db = getConnection();
    const existing = this.get(id);
    if (!existing) return null;

    if (patch.isDefault) {
      db.prepare(
        'UPDATE provider_accounts SET is_default = 0 WHERE provider = ? AND id <> ?',
      ).run(existing.provider, id);
    }

    db.prepare(
      `UPDATE provider_accounts
       SET label = ?, env_overrides = ?, is_default = ?
       WHERE id = ?`,
    ).run(
      patch.label ?? existing.label,
      JSON.stringify(patch.envOverrides ?? existing.envOverrides),
      (patch.isDefault ?? existing.isDefault) ? 1 : 0,
      id,
    );
    return this.get(id);
  },

  remove(id: string): boolean {
    const db = getConnection();
    return db.prepare('DELETE FROM provider_accounts WHERE id = ?').run(id).changes > 0;
  },

  /** The default account for a provider, or null when none is marked. */
  getDefault(provider: string): ProviderAccount | null {
    const db = getConnection();
    const row = db
      .prepare('SELECT * FROM provider_accounts WHERE provider = ? AND is_default = 1 LIMIT 1')
      .get(provider) as ProviderAccountRow | undefined;
    return row ? toAccount(row) : null;
  },
};
