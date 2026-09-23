import assert from 'node:assert/strict';
import path from 'node:path';
import test from 'node:test';

import { createTaskmasterService } from '../taskmaster.service.js';

type ServiceDependencies = Parameters<typeof createTaskmasterService>[0];

function createDependencies(
  homeDirectory: string,
  files: Record<string, string>,
): ServiceDependencies {
  return {
    getHomeDirectory: () => homeDirectory,
    readTextFile: async (filePath) => {
      const content = files[filePath];
      if (content === undefined) {
        throw new Error(`Missing fake file: ${filePath}`);
      }
      return content;
    },
    writeTextFile: async (filePath, content) => {
      files[filePath] = content;
    },
    ensureDirectory: async () => {},
    pathExists: async (filePath) => files[filePath] !== undefined,
  };
}

test('detectMcpServer returns a redacted TaskMaster server status', async () => {
  const homeDirectory = path.join(path.sep, 'fake-home');
  const configurationPath = path.join(homeDirectory, '.claude.json');
  const service = createTaskmasterService(createDependencies(homeDirectory, {
    [configurationPath]: JSON.stringify({
      mcpServers: {
        'task-master-ai': {
          command: 'npx',
          args: ['-y', 'task-master-ai'],
          env: { ANTHROPIC_API_KEY: 'secret-value' },
        },
      },
    }),
  }));

  assert.deepEqual(await service.detectMcpServer(), {
    hasMCPServer: true,
    isConfigured: true,
    hasApiKeys: true,
    scope: 'user',
    config: {
      command: 'npx',
      args: ['-y', 'task-master-ai'],
      url: null,
      envVars: ['ANTHROPIC_API_KEY'],
      type: 'stdio',
    },
  });
});

test('detectMcpServer checks the fallback configuration after malformed JSON', async () => {
  const homeDirectory = path.join(path.sep, 'fake-home');
  const primaryConfigurationPath = path.join(homeDirectory, '.claude.json');
  const fallbackConfigurationPath = path.join(homeDirectory, '.claude', 'settings.json');
  const service = createTaskmasterService(createDependencies(homeDirectory, {
    [primaryConfigurationPath]: '{ malformed',
    [fallbackConfigurationPath]: JSON.stringify({
      projects: {
        '/workspace/project': {
          mcpServers: {
            'project-task-master': { url: 'https://taskmaster.example.test/mcp' },
          },
        },
      },
    }),
  }));

  assert.deepEqual(await service.detectMcpServer(), {
    hasMCPServer: true,
    isConfigured: true,
    hasApiKeys: false,
    scope: 'local',
    projectPath: '/workspace/project',
    config: {
      command: null,
      args: [],
      url: 'https://taskmaster.example.test/mcp',
      envVars: [],
      type: 'http',
    },
  });
});

test('detectMcpServer reports when no readable Claude configuration exists', async () => {
  const homeDirectory = path.join(path.sep, 'fake-home');
  const service = createTaskmasterService(createDependencies(homeDirectory, {}));

  assert.deepEqual(await service.detectMcpServer(), {
    hasMCPServer: false,
    reason: 'No Claude configuration file found',
    hasConfig: false,
  });
});

const projectPath = path.join(path.sep, 'workspace', 'project');
const tasksFilePath = path.join(projectPath, '.taskmaster', 'tasks', 'tasks.json');

test('addTask appends to the tagged tasks file and assigns the next id', async () => {
  const files: Record<string, string> = {
    [tasksFilePath]: JSON.stringify({
      master: {
        tasks: [
          { id: 1, title: 'Existing', status: 'done' },
          { id: 7, title: 'Later', status: 'pending' },
        ],
      },
    }),
  };
  const service = createTaskmasterService(
    createDependencies(path.join(path.sep, 'fake-home'), files),
  );

  const task = await service.addTask(projectPath, {
    title: 'New task',
    description: 'Do the thing',
    priority: 'high',
    dependencies: '1, 3',
  });

  assert.equal(task.id, 8);
  assert.equal(task.status, 'pending');
  assert.deepEqual(task.dependencies, [1, 3]);

  const persisted = JSON.parse(files[tasksFilePath]);
  assert.equal(persisted.master.tasks.length, 3);
  assert.equal(persisted.master.tasks[2].title, 'New task');
});

test('addTask creates a tasks file when the project has none', async () => {
  const files: Record<string, string> = {};
  const service = createTaskmasterService(
    createDependencies(path.join(path.sep, 'fake-home'), files),
  );

  const task = await service.addTask(projectPath, { title: 'First' });

  assert.equal(task.id, 1);
  assert.equal(JSON.parse(files[tasksFilePath]).master.tasks[0].title, 'First');
});

test('updateTask patches only the provided fields and preserves subtasks', async () => {
  const files: Record<string, string> = {
    [tasksFilePath]: JSON.stringify({
      master: {
        tasks: [
          { id: 1, title: 'Original', status: 'pending', subtasks: [{ id: 1, status: 'done' }] },
        ],
      },
    }),
  };
  const service = createTaskmasterService(
    createDependencies(path.join(path.sep, 'fake-home'), files),
  );

  const updated = await service.updateTask(projectPath, '1', { status: 'in-progress' });

  assert.equal(updated?.status, 'in-progress');
  assert.equal(updated?.title, 'Original');
  assert.equal(updated?.subtasks.length, 1);
  assert.equal(await service.updateTask(projectPath, '999', { status: 'done' }), null);
});

test('deleteTask removes the task and strips dangling dependency ids', async () => {
  const files: Record<string, string> = {
    [tasksFilePath]: JSON.stringify({
      master: {
        tasks: [
          { id: 1, title: 'Gone', status: 'pending' },
          { id: 2, title: 'Stays', status: 'pending', dependencies: [1, 3, '1.4'] },
          { id: 3, title: 'Also stays', status: 'pending', subtasks: [{ id: '3.1', dependencies: [1] }] },
        ],
      },
    }),
  };
  const service = createTaskmasterService(
    createDependencies(path.join(path.sep, 'fake-home'), files),
  );

  const removed = await service.deleteTask(projectPath, '1');

  assert.equal(removed?.id, 1);
  const persisted = JSON.parse(files[tasksFilePath]).master.tasks;
  assert.equal(persisted.length, 2);
  assert.deepEqual(persisted[0].dependencies, [3]);
  assert.deepEqual(persisted[1].subtasks[0].dependencies, []);
  assert.equal(await service.deleteTask(projectPath, '999'), null);
});

test('deleteTask returns null when the project has no tasks file', async () => {
  const service = createTaskmasterService(
    createDependencies(path.join(path.sep, 'fake-home'), {}),
  );

  assert.equal(await service.deleteTask(projectPath, '1'), null);
});

test('listTasks returns normalized tasks or null when uninitialized', async () => {
  const files: Record<string, string> = {
    [tasksFilePath]: JSON.stringify({ master: { tasks: [{ id: 1, title: 'One' }] } }),
  };
  const service = createTaskmasterService(
    createDependencies(path.join(path.sep, 'fake-home'), files),
  );

  const tasks = await service.listTasks(projectPath);
  assert.equal(tasks?.length, 1);
  assert.equal(tasks?.[0].status, 'pending');
  assert.equal(await service.listTasks(path.join(path.sep, 'other')), null);
});
