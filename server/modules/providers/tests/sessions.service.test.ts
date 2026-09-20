import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, projectsDb, sessionsDb } from '@/modules/database/index.js';
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
        messageCount: 0,
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
