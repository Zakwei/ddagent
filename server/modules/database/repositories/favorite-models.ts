import { getConnection } from '@/modules/database/connection.js';
import type { FavoriteModelRecord, LLMProvider } from '@/shared/types.js';

type FavoriteModelRow = {
  id: number;
  user_id: number;
  provider: LLMProvider;
  model_id: string;
  sort_order: number;
};

const toFavoriteModelRecord = (row: FavoriteModelRow): FavoriteModelRecord => ({
  id: row.id,
  userId: row.user_id,
  provider: row.provider,
  modelId: row.model_id,
  sortOrder: row.sort_order,
});

/**
 * Per-user favorite-model persistence API consumed by the Providers module.
 *
 * Rows are scoped by `(user_id, provider)` so a user's starred model ids sync
 * across devices instead of living only in client storage. Model ids reference
 * provider catalog values (predefined or custom) and are never validated against
 * the catalog here — a starred id may legitimately outlive a retired model.
 */
export const favoriteModelsDb = {
  listFavoriteModels(userId: number, provider: LLMProvider): FavoriteModelRecord[] {
    const rows = getConnection().prepare(`
      SELECT id, user_id, provider, model_id, sort_order
      FROM user_favorite_models
      WHERE user_id = ? AND provider = ?
      ORDER BY sort_order ASC, id ASC
    `).all(userId, provider) as FavoriteModelRow[];

    return rows.map(toFavoriteModelRecord);
  },

  /**
   * Replaces a user's whole favorite set for one provider with `modelIds`,
   * preserving the given order. The full-replace contract keeps the client's
   * optimistic toggle in sync without per-item add/remove races.
   */
  replaceFavoriteModels(
    userId: number,
    provider: LLMProvider,
    modelIds: string[],
  ): FavoriteModelRecord[] {
    const db = getConnection();
    const replace = db.transaction(() => {
      db.prepare('DELETE FROM user_favorite_models WHERE user_id = ? AND provider = ?')
        .run(userId, provider);

      const insert = db.prepare(`
        INSERT INTO user_favorite_models (user_id, provider, model_id, sort_order)
        VALUES (?, ?, ?, ?)
      `);
      modelIds.forEach((modelId, index) => insert.run(userId, provider, modelId, index));
    });

    replace();
    return favoriteModelsDb.listFavoriteModels(userId, provider);
  },
};
