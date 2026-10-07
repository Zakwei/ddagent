import assert from 'node:assert/strict';
import test from 'node:test';

import {
  createMiniOrchestratorConfigService,
  validateMiniOrchestratorConfig,
} from '@/modules/mini-orchestrator/services/mini-orchestrator-config.service.js';

function makeStore() {
  const store = new Map<string, string>();
  return {
    get: (key: string) => store.get(key) ?? null,
    set: (key: string, value: string) => {
      store.set(key, value);
    },
    raw: store,
  };
}

test('mini config: seeded default validates and round-trips', () => {
  const service = createMiniOrchestratorConfigService(makeStore());
  const config = service.get();

  assert.equal(config.enabled, true);
  assert.equal(config.thinker[0].model, 'glm-5-3-high');
  assert.equal(config.worker[0].model, 'glm-5-3-flash-high');
  // Non-flash thinker covers reasoning lanes; flash worker does the mechanics.
  assert.equal(config.roles.plan, 'thinker');
  assert.equal(config.roles['code-hard'], 'thinker');
  assert.equal(config.roles.review, 'thinker');
  assert.equal(config.roles.code, 'worker');
  assert.equal(config.roles.report, 'worker');

  const stored = service.put(config);
  assert.equal(stored.thinker[0].id, 'glm53-high');
  assert.deepEqual(service.get().roles, config.roles);
});

test('mini config: rejects bad role, empty role list, duplicate ids', () => {
  const base = createMiniOrchestratorConfigService(makeStore()).get() as unknown as Record<string, unknown>;

  assert.throws(
    () => validateMiniOrchestratorConfig({ ...base, roles: { ...(base.roles as object), code: 'judge' } }),
    /roles\.code/,
  );
  assert.throws(() => validateMiniOrchestratorConfig({ ...base, worker: [] }), /worker/);
  assert.throws(
    () =>
      validateMiniOrchestratorConfig({
        ...base,
        worker: [{ ...(base.thinker as Array<Record<string, unknown>>)[0] }],
      }),
    /unique/,
  );
  assert.throws(
    () => validateMiniOrchestratorConfig({ ...base, planner: { mode: 'turbo', requireConfirm: false } }),
    /planner\.mode/,
  );
});

test('mini config: missing role falls back to the default assignment', () => {
  const base = createMiniOrchestratorConfigService(makeStore()).get() as unknown as Record<string, unknown>;
  const config = validateMiniOrchestratorConfig({ ...base, roles: { code: 'thinker' } });
  assert.equal(config.roles.code, 'thinker');
  assert.equal(config.roles.plan, 'thinker');
  assert.equal(config.roles.test, 'worker');
});
