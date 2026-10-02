import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  closeConnection,
  initializeDatabase,
  orchestratorMessagesDb,
  projectsDb,
  queuedMessagesDb,
  sessionsDb,
} from '@/modules/database/index.js';
import { deleteOrArchiveProject } from '@/modules/projects/services/project-delete.service.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'project-delete-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
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

test('force-deleting a project removes its sessions plus queued and delegation side data', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('pd-session', 'claude', '/tmp/project-delete-service-project');
    const projectPath = sessionsDb.getSessionById('pd-session')?.project_path;
    assert.ok(projectPath);
    const project = projectsDb.getProjectPath(projectPath);
    assert.ok(project);

    queuedMessagesDb.enqueue({ sessionId: 'pd-session', content: 'queued', options: {}, userId: null });
    orchestratorMessagesDb.append('pd-session', 'delegation', { childSessionId: 'pd-child' });

    await deleteOrArchiveProject(project.project_id, true);

    assert.equal(sessionsDb.getSessionById('pd-session'), null);
    assert.equal(queuedMessagesDb.listBySession('pd-session').length, 0);
    assert.equal(orchestratorMessagesDb.list('pd-session').length, 0);
    assert.equal(projectsDb.getProjectById(project.project_id), null);
  });
});

test('archiving a project keeps its sessions and queued messages', async () => {
  await withIsolatedDatabase(async () => {
    sessionsDb.createAppSession('pa-session', 'claude', '/tmp/project-archive-service-project');
    const projectPath = sessionsDb.getSessionById('pa-session')?.project_path;
    assert.ok(projectPath);
    const project = projectsDb.getProjectPath(projectPath);
    assert.ok(project);

    queuedMessagesDb.enqueue({ sessionId: 'pa-session', content: 'queued', options: {}, userId: null });

    await deleteOrArchiveProject(project.project_id, false);

    assert.ok(sessionsDb.getSessionById('pa-session'));
    assert.equal(queuedMessagesDb.listBySession('pa-session').length, 1);
  });
});
