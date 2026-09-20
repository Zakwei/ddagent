import assert from 'node:assert/strict';
import test from 'node:test';

import { getRecencyGroupKey, groupByRecency } from './utils';

const now = new Date('2026-09-15T12:00:00.000Z');
const hoursAgo = (hours: number) => new Date(now.getTime() - hours * 3_600_000).toISOString();

test('buckets by rolling hours, not calendar days', () => {
  assert.equal(getRecencyGroupKey(hoursAgo(1), now), 'today');
  assert.equal(getRecencyGroupKey(hoursAgo(23), now), 'today');
  assert.equal(getRecencyGroupKey(hoursAgo(25), now), 'yesterday');
  assert.equal(getRecencyGroupKey(hoursAgo(47), now), 'yesterday');
  assert.equal(getRecencyGroupKey(hoursAgo(49), now), 'thisWeek');
  assert.equal(getRecencyGroupKey(hoursAgo(167), now), 'thisWeek');
  assert.equal(getRecencyGroupKey(hoursAgo(169), now), 'older');
});

test('invalid or missing timestamps fall into older', () => {
  assert.equal(getRecencyGroupKey(null, now), 'older');
  assert.equal(getRecencyGroupKey('nonsense', now), 'older');
});

test('groups preserve order and drop empty buckets', () => {
  const items = [
    { lastActivity: hoursAgo(2), id: 'a' },
    { lastActivity: hoursAgo(30), id: 'b' },
    { lastActivity: hoursAgo(200), id: 'c' },
    { lastActivity: hoursAgo(3), id: 'd' },
  ];

  assert.deepEqual(
    groupByRecency(items, now).map((group) => ({
      key: group.key,
      ids: group.items.map((item) => item.id),
    })),
    [
      { key: 'today', ids: ['a', 'd'] },
      { key: 'yesterday', ids: ['b'] },
      { key: 'older', ids: ['c'] },
    ],
  );
});
