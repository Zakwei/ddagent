import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

import {
  filterSelectableSessions,
  getSelectAllSessionIds,
  getSelectOrchestratorSessionIds,
  hasSelectableOrchestrators,
  isOrchestratorSession,
} from './broadcastSessionUtils';

describe('broadcastSessionUtils', () => {
  describe('isOrchestratorSession', () => {
    it('identifies session with provider === "orchestrator"', () => {
      assert.strictEqual(isOrchestratorSession({ provider: 'orchestrator' }), true);
      assert.strictEqual(isOrchestratorSession({ provider: 'claude' }), false);
      assert.strictEqual(isOrchestratorSession({ provider: undefined }), false);
    });

    it('identifies session with fallback __provider === "orchestrator"', () => {
      assert.strictEqual(isOrchestratorSession({ __provider: 'orchestrator' }), true);
      assert.strictEqual(isOrchestratorSession({ provider: undefined, __provider: 'orchestrator' }), true);
      assert.strictEqual(isOrchestratorSession({ provider: 'codestral', __provider: 'orchestrator' }), false);
    });
  });

  describe('filtering by provider', () => {
    it('selects only orchestrator sessions from a mixed list', () => {
      const sessions = [
        { id: 's1', provider: 'orchestrator' },
        { id: 's2', provider: 'claude' },
        { id: 's3', __provider: 'orchestrator' },
        { id: 's4', provider: 'openai' },
      ];

      const orchestratorIds = getSelectOrchestratorSessionIds(sessions);
      assert.deepStrictEqual(orchestratorIds, ['s1', 's3']);
    });

    it('ignores archived sessions even if they are orchestrators', () => {
      const sessions = [
        { id: 's1', provider: 'orchestrator', isArchived: true },
        { id: 's2', provider: 'orchestrator', isArchived: false },
        { id: 's3', provider: 'claude' },
      ];

      assert.deepStrictEqual(filterSelectableSessions(sessions).map((s) => s.id), ['s2', 's3']);
      assert.deepStrictEqual(getSelectOrchestratorSessionIds(sessions), ['s2']);
    });
  });

  describe('mixed list behavior', () => {
    it('handles mixed list with multiple providers correctly', () => {
      const sessions = [
        { id: 'orch-1', provider: 'orchestrator' },
        { id: 'devin-1', provider: 'devin' },
        { id: 'orch-2', provider: 'orchestrator' },
        { id: 'claude-1', provider: 'claude' },
      ];

      assert.strictEqual(hasSelectableOrchestrators(sessions), true);
      assert.deepStrictEqual(getSelectOrchestratorSessionIds(sessions), ['orch-1', 'orch-2']);
      assert.deepStrictEqual(getSelectAllSessionIds(sessions), ['orch-1', 'devin-1', 'orch-2', 'claude-1']);
    });
  });

  describe('zero orchestrators behavior', () => {
    it('returns empty list and reports hasSelectableOrchestrators as false when no orchestrators exist', () => {
      const nonOrchestratorSessions = [
        { id: 's1', provider: 'claude' },
        { id: 's2', provider: 'devin' },
        { id: 's3', provider: 'gemini' },
      ];

      assert.strictEqual(hasSelectableOrchestrators(nonOrchestratorSessions), false);
      assert.deepStrictEqual(getSelectOrchestratorSessionIds(nonOrchestratorSessions), []);
      assert.deepStrictEqual(getSelectAllSessionIds(nonOrchestratorSessions), ['s1', 's2', 's3']);
    });

    it('handles completely empty session list', () => {
      assert.strictEqual(hasSelectableOrchestrators([]), false);
      assert.deepStrictEqual(getSelectOrchestratorSessionIds([]), []);
      assert.deepStrictEqual(getSelectAllSessionIds([]), []);
    });
  });

  describe('interaction with "Select all"', () => {
    it('allows transitioning from select all to select only orchestrators (narrowing)', () => {
      const sessions = [
        { id: 'orch-1', provider: 'orchestrator' },
        { id: 'orch-2', provider: 'orchestrator' },
        { id: 'other-1', provider: 'claude' },
        { id: 'other-2', provider: 'openai' },
      ];

      // Initially select all
      let selectedSet = new Set(getSelectAllSessionIds(sessions));
      assert.strictEqual(selectedSet.size, 4);
      assert.strictEqual(selectedSet.has('other-1'), true);

      // User clicks "Select orchestrators": narrows selection to orchestrator subset
      const orchestratorIds = getSelectOrchestratorSessionIds(sessions);
      selectedSet = new Set(orchestratorIds);
      assert.strictEqual(selectedSet.size, 2);
      assert.strictEqual(selectedSet.has('orch-1'), true);
      assert.strictEqual(selectedSet.has('orch-2'), true);
      assert.strictEqual(selectedSet.has('other-1'), false);
      assert.strictEqual(selectedSet.has('other-2'), false);
    });

    it('allows transitioning from select orchestrators to select all (expanding)', () => {
      const sessions = [
        { id: 'orch-1', provider: 'orchestrator' },
        { id: 'other-1', provider: 'claude' },
      ];

      // Initially select only orchestrators
      let selectedSet = new Set(getSelectOrchestratorSessionIds(sessions));
      assert.deepStrictEqual(Array.from(selectedSet), ['orch-1']);

      // User clicks "Select all": expands selection to all selectable sessions
      selectedSet = new Set(getSelectAllSessionIds(sessions));
      assert.deepStrictEqual(Array.from(selectedSet), ['orch-1', 'other-1']);
    });
  });
});
