import assert from 'node:assert/strict';
import test from 'node:test';

import { createFavoriteModelsService } from '@/modules/providers/services/favorite-models.service.js';
import type { FavoriteModelRecord, LLMProvider } from '@/shared/types.js';

const record = (id: number, modelId: string): FavoriteModelRecord => ({
  id,
  userId: 1,
  provider: 'claude',
  modelId,
  sortOrder: id,
});

test('favorite models service lists stored model ids in order', () => {
  const service = createFavoriteModelsService({
    favorites: {
      listFavoriteModels: () => [record(1, 'opus'), record(2, 'sonnet')],
      replaceFavoriteModels: () => [],
    },
  });

  assert.deepEqual(service.listFavoriteModels(1, 'claude'), ['opus', 'sonnet']);
});

test('favorite models service forwards the full replace to the store', () => {
  const calls: { userId: number; provider: LLMProvider; modelIds: string[] }[] = [];
  const service = createFavoriteModelsService({
    favorites: {
      listFavoriteModels: () => [],
      replaceFavoriteModels: (userId, provider, modelIds) => {
        calls.push({ userId, provider, modelIds });
        return modelIds.map((modelId, index) => record(index + 1, modelId));
      },
    },
  });

  const saved = service.replaceFavoriteModels(7, 'claude', ['b', 'a']);

  assert.deepEqual(calls, [{ userId: 7, provider: 'claude', modelIds: ['b', 'a'] }]);
  assert.deepEqual(saved, ['b', 'a']);
});
