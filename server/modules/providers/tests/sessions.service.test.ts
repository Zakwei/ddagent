import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, orchestratorMessagesDb, projectsDb, sessionsDb } from '@/modules/database/index.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import {
  buildDdagentSessionName,
  sessionsService,
} from '@/modules/providers/services/sessions.service.js';
import { WORKSPACES_ROOT } from '@/shared/utils.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(os.tmpdir(), 'sessions-service-db-'));

  closeConnection();
  process.env.DATABASE_PATH = path.join(tempDirectory, 'auth.db');
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

test('provider session id returns the mapped native id', { concurrency: false }, async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('app-session-id', 'codex', '/tmp/session-id-copy-project');
    sessionsDb.assignProviderSessionId('app-session-id', 'codex-native-session-id');

    assert.equal(sessionsService.getProviderSessionId('app-session-id'), 'codex-native-session-id');
  });
});

test('app session names use at most four uppercase whole words from the initial message', { concurrency: false }, async () => {
  await withIsolatedDatabase(() => {
    const result = sessionsService.createAppSession(
      'codex',
      '/tmp/session-name-project',
      '  Fix\n the   login redirect issue please  ',
    );

    assert.equal(result.sessionName, 'FIX THE LOGIN REDIRECT');
    assert.equal(
      sessionsDb.getSessionById(result.sessionId)?.custom_name,
      'FIX THE LOGIN REDIRECT',
    );
  });
});

test('app session names strip markdown and code noise', { concurrency: false }, async () => {
  await withIsolatedDatabase(() => {
    const result = sessionsService.createAppSession(
      'claude',
      '/tmp/session-markdown-project',
      '**Fix** the `login` bug in `/api/auth`\n\n```ts\nconst x = 1;\n```',
    );

    assert.equal(result.sessionName, 'FIX THE LOGIN BUG');
  });
});

test('app session names cap length without cutting mid-word', { concurrency: false }, async () => {
  const name = buildDdagentSessionName('Investigate intermittent websocket reconnect failures in production');

  assert.equal(name, 'INVESTIGATE INTERMITTENT WEBSOCKET');
  assert.ok(name.length <= 40);
});

test('app sessions without message text receive a stable fallback name', { concurrency: false }, async () => {
  await withIsolatedDatabase(() => {
    const result = sessionsService.createAppSession('claude', '/tmp/attachment-only-project', '  \n ');

    assert.equal(result.sessionName, 'UNTITLED SESSION');
    assert.equal(sessionsDb.getSessionById(result.sessionId)?.custom_name, 'UNTITLED SESSION');
  });
});

test('app session title normalizer falls back when only punctuation remains', () => {
  assert.equal(buildDdagentSessionName('```\n***\n```'), 'UNTITLED SESSION');
});

test('app session title normalizer uppercases a single word', () => {
  assert.equal(buildDdagentSessionName('refactor'), 'REFACTOR');
});

test('app session title normalizer keeps unicode letters', () => {
  assert.equal(buildDdagentSessionName('Zbadaj błąd logowania'), 'ZBADAJ BŁĄD LOGOWANIA');
});

test('app session title normalizer keeps the markdown link label', () => {
  assert.equal(buildDdagentSessionName('[Fix login](https://example.com/issue/1)'), 'FIX LOGIN');
});

test('app session title normalizer collapses tabs and newlines', () => {
  assert.equal(buildDdagentSessionName('Fix\tlogin\nredirect   now'), 'FIX LOGIN REDIRECT NOW');
});

test('app session title normalizer trims leading separators', () => {
  assert.equal(buildDdagentSessionName('-- Fix / login & redirect'), 'FIX LOGIN REDIRECT');
});

test('app session title normalizer caps a long single word without a space', () => {
  const name = buildDdagentSessionName('a'.repeat(60));
  assert.ok(name.length <= 40);
  assert.equal(name, 'A'.repeat(40));
});

test('app session title normalizer accepts input exactly at the length cap', () => {
  const input = 'A'.repeat(40);
  assert.equal(buildDdagentSessionName(input), input);
});


test('provider session id is unavailable until the provider assigns one', { concurrency: false }, async () => {
  await withIsolatedDatabase(() => {
    sessionsDb.createAppSession('pending-app-session', 'claude', '/tmp/session-id-copy-project');

    assert.throws(
      () => sessionsService.getProviderSessionId('pending-app-session'),
      (error: unknown) => {
        const typedError = error as { code?: string; statusCode?: number };
        return typedError.code === 'PROVIDER_SESSION_ID_NOT_AVAILABLE' && typedError.statusCode === 409;
      },
    );
  });
});

test('provider session id reports a missing app session', { concurrency: false }, async () => {
  await withIsolatedDatabase(() => {
    assert.throws(
      () => sessionsService.getProviderSessionId('missing-session'),
      (error: unknown) => {
        const typedError = error as { code?: string; statusCode?: number };
        return typedError.code === 'SESSION_NOT_FOUND' && typedError.statusCode === 404;
      },
    );
  });
});

test('recent sessions map project metadata and preserve database pagination', { concurrency: false }, async () => {  await withIsolatedDatabase(() => {
    sessionsDb.createSession(
      'older-session',
      'claude',
      '/tmp/recent-project',
      'Older conversation',
      '2026-08-01T08:00:00.000Z',
      '2026-08-01T09:00:00.000Z',
    );
    sessionsDb.createSession(
      'newer-session',
      'codex',
      '/tmp/recent-project',
      'Newer conversation',
      '2026-08-01T10:00:00.000Z',
      '2026-08-01T11:00:00.000Z',
    );
    projectsDb.updateCustomProjectName('/tmp/recent-project', 'Recent Project');

    const project = projectsDb.getProjectPath('/tmp/recent-project');
    const page = sessionsService.listRecentSessions(1, 0);

    assert.deepEqual(page, {
      conversations: [{
        sessionId: 'newer-session',
        provider: 'codex',
        projectId: project?.project_id ?? null,
        projectDisplayName: 'Recent Project',
        sessionTitle: 'Newer conversation',
        lastActivity: '2026-08-01T11:00:00.000Z',
        lastViewedAt: null,
        messageCount: 0,
        accountId: null,
      }],
      total: 2,
      hasMore: true,
    });
  });
});

test('changing a session workspace repoints the session and registers the project', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('movable-session', 'claude', '/tmp/original-workspace');
    const targetDirectory = await mkdtemp(path.join(WORKSPACES_ROOT, 'session-workspace-'));

    try {
      const result = await sessionsService.updateSessionWorkspaceById('movable-session', targetDirectory);

      assert.equal(result.sessionId, 'movable-session');
      assert.equal(sessionsDb.getSessionById('movable-session')?.project_path, result.projectPath);
      assert.ok(projectsDb.getProjectPath(result.projectPath));
    } finally {
      await rm(targetDirectory, { recursive: true, force: true });
    }
  });
});

test('changing a session workspace rejects a missing session', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    await assert.rejects(
      () => sessionsService.updateSessionWorkspaceById('missing-session', '/tmp/anywhere'),
      (error: unknown) => {
        const typedError = error as { code?: string; statusCode?: number };
        return typedError.code === 'SESSION_NOT_FOUND' && typedError.statusCode === 404;
      },
    );
  });
});

test('changing a session workspace rejects system directories', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('guarded-session', 'claude', '/tmp/original-workspace');

    await assert.rejects(
      () => sessionsService.updateSessionWorkspaceById('guarded-session', '/etc'),
      (error: unknown) => {
        const typedError = error as { code?: string; statusCode?: number };
        return typedError.code === 'INVALID_WORKSPACE_PATH' && typedError.statusCode === 400;
      },
    );
    assert.equal(
      sessionsDb.getSessionById('guarded-session')?.project_path,
      '/tmp/original-workspace',
    );
  });
});

test('deleteOrArchiveSessionById refuses while a run is active', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('running-session', 'claude', '/tmp/running-session-project');
    const run = chatRunRegistry.startRun({
      appSessionId: 'running-session',
      provider: 'claude',
      providerSessionId: null,
      connection: { readyState: 1, send(): void {} },
      userId: null,
    });
    assert.ok(run);

    try {
      for (const options of [{}, { force: true, deletedFromDisk: true }]) {
        await assert.rejects(
          () => sessionsService.deleteOrArchiveSessionById('running-session', options),
          (error: unknown) => {
            const typedError = error as { code?: string; statusCode?: number };
            return typedError.code === 'SESSION_RUN_IN_PROGRESS' && typedError.statusCode === 409;
          },
        );
      }
      assert.equal(sessionsDb.getSessionById('running-session')?.isArchived, 0);

      chatRunRegistry.clearAll();
      const result = await sessionsService.deleteOrArchiveSessionById('running-session');
      assert.equal(result.action, 'archived');
      assert.equal(sessionsDb.getSessionById('running-session')?.isArchived, 1);
    } finally {
      chatRunRegistry.clearAll();
    }
  });
});

test('archiving, restoring, and deleting an orchestrated session cascades onto its delegated children', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('parent-orch', 'orchestrator', '/tmp/orch-project');
    sessionsDb.createAppSession('child-1', 'claude', '/tmp/orch-project');
    sessionsDb.createAppSession('child-2', 'codex', '/tmp/orch-project');
    sessionsDb.createAppSession('unrelated', 'claude', '/tmp/orch-project');
    orchestratorMessagesDb.append('parent-orch', 'delegation', { childSessionId: 'child-1' });
    orchestratorMessagesDb.append('parent-orch', 'delegation', { childSessionId: 'child-2' });

    // Archive: both children disappear with the parent.
    const archived = await sessionsService.deleteOrArchiveSessionById('parent-orch');
    assert.equal(archived.action, 'archived');
    assert.deepEqual([...archived.childSessionIds].sort(), ['child-1', 'child-2']);
    for (const id of ['parent-orch', 'child-1', 'child-2']) {
      assert.equal(sessionsDb.getSessionById(id)?.isArchived, 1);
    }
    assert.equal(sessionsDb.getSessionById('unrelated')?.isArchived, 0);

    // Restore brings the children back alongside the parent.
    const restored = sessionsService.restoreSessionById('parent-orch');
    assert.deepEqual([...restored.childSessionIds].sort(), ['child-1', 'child-2']);
    for (const id of ['parent-orch', 'child-1', 'child-2']) {
      assert.equal(sessionsDb.getSessionById(id)?.isArchived, 0);
    }

    // Force-delete removes the child rows together with the parent.
    const deleted = await sessionsService.deleteOrArchiveSessionById('parent-orch', {
      force: true,
      deletedFromDisk: false,
    });
    assert.equal(deleted.action, 'deleted');
    for (const id of ['parent-orch', 'child-1', 'child-2']) {
      assert.equal(sessionsDb.getSessionById(id), null);
    }
    assert.ok(sessionsDb.getSessionById('unrelated'));
  });
});

test('archiving an Auto session sets isArchived = 1 for all child sessions, synchronizers preserve archive status, and restore unarchives', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('parent-auto', 'orchestrator', '/tmp/auto-project', 'Auto Session');
    sessionsDb.createAppSession('child-1', 'claude', '/tmp/auto-project', 'Claude Child');
    sessionsDb.createAppSession('child-2', 'opencode', '/tmp/auto-project', 'OpenCode Child');
    sessionsDb.createAppSession('unrelated', 'claude', '/tmp/auto-project', 'Active Session');
    sessionsDb.assignProviderSessionId('child-1', 'native-claude-child');
    sessionsDb.assignProviderSessionId('child-2', 'native-opencode-child');
    orchestratorMessagesDb.append('parent-auto', 'delegation', { childSessionId: 'child-1' });
    orchestratorMessagesDb.append('parent-auto', 'delegation', { childSessionId: 'child-2' });

    // Archiving Auto session cascades isArchived = 1 to parent and all children
    const archived = await sessionsService.deleteOrArchiveSessionById('parent-auto');
    assert.equal(archived.action, 'archived');
    assert.deepEqual([...archived.childSessionIds].sort(), ['child-1', 'child-2']);
    for (const id of ['parent-auto', 'child-1', 'child-2']) {
      assert.equal(sessionsDb.getSessionById(id)?.isArchived, 1);
    }
    assert.equal(sessionsDb.getSessionById('unrelated')?.isArchived, 0);

    const activeBeforeSync = sessionsDb.getAllSessions().map((s) => s.session_id);
    assert.deepEqual(activeBeforeSync, ['unrelated']);
    const archivedBeforeSync = sessionsDb.getArchivedSessions().map((s) => s.session_id).sort();
    assert.deepEqual(archivedBeforeSync, ['child-1', 'child-2', 'parent-auto']);

    // Background synchronizers re-indexing transcripts must NOT reset isArchived to 0
    sessionsDb.createSession('native-claude-child', 'claude', '/tmp/auto-project', 'Claude Resync');
    sessionsDb.createSession('native-opencode-child', 'opencode', '/tmp/auto-project', 'OpenCode Resync');
    for (const id of ['parent-auto', 'child-1', 'child-2']) {
      assert.equal(sessionsDb.getSessionById(id)?.isArchived, 1);
    }
    assert.deepEqual(sessionsDb.getAllSessions().map((s) => s.session_id), ['unrelated']);
    assert.deepEqual(sessionsDb.getArchivedSessions().map((s) => s.session_id).sort(), ['child-1', 'child-2', 'parent-auto']);

    // Restore unarchives both parent and all child sessions
    const restored = sessionsService.restoreSessionById('parent-auto');
    assert.deepEqual([...restored.childSessionIds].sort(), ['child-1', 'child-2']);
    for (const id of ['parent-auto', 'child-1', 'child-2', 'unrelated']) {
      assert.equal(sessionsDb.getSessionById(id)?.isArchived, 0);
    }
    assert.deepEqual(sessionsDb.getAllSessions().map((s) => s.session_id).sort(), ['child-1', 'child-2', 'parent-auto', 'unrelated']);
    assert.equal(sessionsDb.getArchivedSessions().length, 0);

    // Subsequent synchronizer runs keep unarchived sessions active
    sessionsDb.createSession('native-claude-child', 'claude', '/tmp/auto-project', 'Claude Active Resync');
    assert.equal(sessionsDb.getSessionById('child-1')?.isArchived, 0);
    assert.equal(sessionsDb.getAllSessions().length, 4);
  });
});

test('deleteOrArchiveSessionById refuses while a delegated child is running', { concurrency: false }, async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('parent-orch', 'orchestrator', '/tmp/orch-project');
    sessionsDb.createAppSession('busy-child', 'claude', '/tmp/orch-project');
    orchestratorMessagesDb.append('parent-orch', 'delegation', { childSessionId: 'busy-child' });
    const run = chatRunRegistry.startRun({
      appSessionId: 'busy-child',
      provider: 'claude',
      providerSessionId: null,
      connection: { readyState: 1, send(): void {} },
      userId: null,
    });
    assert.ok(run);

    try {
      await assert.rejects(
        () => sessionsService.deleteOrArchiveSessionById('parent-orch'),
        (error: unknown) => {
          const typedError = error as { code?: string; statusCode?: number };
          return typedError.code === 'SESSION_RUN_IN_PROGRESS' && typedError.statusCode === 409;
        },
      );
      assert.equal(sessionsDb.getSessionById('parent-orch')?.isArchived, 0);
      assert.equal(sessionsDb.getSessionById('busy-child')?.isArchived, 0);
    } finally {
      chatRunRegistry.clearAll();
    }
  });
});
