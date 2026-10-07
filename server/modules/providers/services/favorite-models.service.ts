import { favoriteModelsDb } from '@/modules/database/index.js';
import type { FavoriteModelRecord, LLMProvider } from '@/shared/types.js';

/** SQLite favorite operations used by the Providers service and its unit fakes. */
type FavoriteModelsStore = Pick<
  typeof favoriteModelsDb,
  'listFavoriteModels' | 'replaceFavoriteModels'
>;

type FavoriteModelsServiceDependencies = {
  favorites?: FavoriteModelsStore;
};

/**
 * Per-user favorite-model use cases consumed by the Providers routes.
 *
 * Starred models are stored per user and provider so they survive app updates,
 * reinstalls and device changes instead of living only in client storage. The
 * service exposes plain model-id lists; the routes own the transport envelope.
 */
export const createFavoriteModelsService = (
  dependencies: FavoriteModelsServiceDependencies = {},
) => {
  const favorites = dependencies.favorites ?? favoriteModelsDb;

  const toModelIds = (records: FavoriteModelRecord[]): string[] =>
    records.map((record) => record.modelId);

  return {
    listFavoriteModels(userId: number, provider: LLMProvider): string[] {
      return toModelIds(favorites.listFavoriteModels(userId, provider));
    },

    replaceFavoriteModels(
      userId: number,
      provider: LLMProvider,
      modelIds: string[],
    ): string[] {
      return toModelIds(favorites.replaceFavoriteModels(userId, provider, modelIds));
    },
  };
};

export const favoriteModelsService = createFavoriteModelsService();
