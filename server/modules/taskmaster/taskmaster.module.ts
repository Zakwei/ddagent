import fs from 'node:fs';
import * as fsPromises from 'node:fs/promises';
import os from 'node:os';

import { projectsDb } from '@/modules/database/index.js';

import { createTaskmasterRouter } from './taskmaster.routes.js';
import { createTaskmasterService } from './taskmaster.service.js';

const taskmasterService = createTaskmasterService({
  readTextFile: (filePath) => fsPromises.readFile(filePath, 'utf8'),
  writeTextFile: (filePath, content) => fsPromises.writeFile(filePath, content, 'utf8'),
  ensureDirectory: async (directoryPath) => {
    await fsPromises.mkdir(directoryPath, { recursive: true });
  },
  pathExists: async (filePath) => {
    try {
      await fsPromises.access(filePath);
      return true;
    } catch {
      return false;
    }
  },
  getHomeDirectory: os.homedir,
});

/** Used by the server entrypoint to mount authenticated TaskMaster endpoints. */
export const taskmasterRoutes = createTaskmasterRouter({
  fileSystem: fs,
  fileSystemPromises: fsPromises,
  resolveProjectPathById: (projectId) => projectsDb.getProjectPathById(projectId),
  taskmasterService,
});
