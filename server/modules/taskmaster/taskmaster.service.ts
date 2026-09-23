import path from 'node:path';

type TaskmasterServiceDependencies = {
    readTextFile(filePath: string): Promise<string>;
    writeTextFile(filePath: string, content: string): Promise<void>;
    ensureDirectory(directoryPath: string): Promise<void>;
    pathExists(filePath: string): Promise<boolean>;
    getHomeDirectory(): string;
};

/**
 * A single TaskMaster task as persisted in `.taskmaster/tasks/tasks.json`.
 * The index signature preserves provider-specific fields (e.g. `subtasks`,
 * `createdAt`) so reads and writes are lossless round-trips.
 */
type TaskmasterStoredTask = {
    id: number | string;
    title: string;
    description: string;
    status: string;
    priority: string;
    dependencies: Array<number | string>;
    details: string;
    testStrategy: string;
    subtasks: Array<Record<string, unknown>>;
    createdAt?: string;
    updatedAt?: string;
    [key: string]: unknown;
};

/**
 * The parsed contents of a tasks file. `container` is the original JSON so a
 * write can mutate only the active tag's task array and preserve every other
 * top-level key (tags, metadata) unchanged.
 */
type TaskmasterTaskFile = {
    container: Record<string, unknown>;
    tasks: TaskmasterStoredTask[];
    activeTag: string;
    isTagged: boolean;
};

/** Fields callers may set when creating or editing a task. */
type TaskmasterTaskInput = {
    title?: string;
    description?: string;
    priority?: string;
    dependencies?: Array<number | string> | string;
    details?: string;
    testStrategy?: string;
};

const DEFAULT_CONFIGURATION = {
    models: {
        main: {
            provider: 'anthropic',
            modelId: 'claude-sonnet-4-20250514',
            maxTokens: 64000,
            temperature: 0.2,
        },
        research: {
            provider: 'perplexity',
            modelId: 'sonar',
            maxTokens: 8700,
            temperature: 0.1,
        },
        fallback: {
            provider: 'anthropic',
            modelId: 'claude-3-7-sonnet-20250219',
            maxTokens: 120000,
            temperature: 0.2,
        },
    },
    global: {
        logLevel: 'info',
        debug: false,
        defaultNumTasks: 10,
        defaultSubtasks: 5,
        defaultPriority: 'medium',
        projectName: 'Task Master',
        responseLanguage: 'English',
        enableCodebaseAnalysis: true,
        enableProxy: false,
    },
};

function normalizeDependencies(
    dependencies: Array<number | string> | string | undefined,
): Array<number | string> {
    if (Array.isArray(dependencies)) {
        return dependencies;
    }
    if (typeof dependencies === 'string' && dependencies.trim()) {
        return dependencies
            .split(',')
            .map((entry) => entry.trim())
            .filter(Boolean)
            .map((entry) => (/^-?\d+$/.test(entry) ? Number(entry) : entry));
    }
    return [];
}

/**
 * Normalizes one stored task into the shape the client consumes. This is the
 * single source of truth for defaults so every endpoint returns identical
 * fields regardless of how the task was authored.
 */
function normalizeTask(task: TaskmasterStoredTask): TaskmasterStoredTask {
    const now = new Date().toISOString();
    return {
        ...task,
        id: task.id,
        title: task.title || 'Untitled Task',
        description: task.description || '',
        status: task.status || 'pending',
        priority: task.priority || 'medium',
        dependencies: Array.isArray(task.dependencies) ? task.dependencies : [],
        details: task.details || '',
        testStrategy: task.testStrategy || (task.test_strategy as string) || '',
        subtasks: Array.isArray(task.subtasks) ? task.subtasks : [],
        createdAt: task.createdAt || (task.created as string) || now,
        updatedAt: task.updatedAt || (task.updated as string) || now,
    };
}

/**
 * Interprets the three tasks.json layouts TaskMaster has shipped: a legacy
 * top-level array, a `{ tasks: [] }` object, and the tagged
 * `{ master: { tasks: [] } }` form.
 */
function parseTaskFile(parsed: unknown, filePath: string): TaskmasterTaskFile {
    if (Array.isArray(parsed)) {
        return {
            container: { tasks: parsed },
            tasks: parsed as TaskmasterStoredTask[],
            activeTag: 'master',
            isTagged: false,
        };
    }

    const container = (typeof parsed === 'object' && parsed !== null)
        ? parsed as Record<string, unknown>
        : {};

    if (Array.isArray(container.tasks)) {
        return {
            container,
            tasks: container.tasks as TaskmasterStoredTask[],
            activeTag: 'master',
            isTagged: false,
        };
    }

    const tagged = container[container.currentTag as string] ?? container.master;
    if (tagged && typeof tagged === 'object' && Array.isArray((tagged as { tasks?: unknown }).tasks)) {
        const tagName = container[container.currentTag as string] ? String(container.currentTag) : 'master';
        return {
            container,
            tasks: (tagged as { tasks: TaskmasterStoredTask[] }).tasks,
            activeTag: tagName,
            isTagged: true,
        };
    }

    const firstTag = Object.keys(container).find((key) => {
        const value = container[key];
        return typeof value === 'object' && value !== null && Array.isArray((value as { tasks?: unknown }).tasks);
    });
    if (firstTag) {
        return {
            container,
            tasks: (container[firstTag] as { tasks: TaskmasterStoredTask[] }).tasks,
            activeTag: firstTag,
            isTagged: true,
        };
    }

    throw new Error(`Unrecognized tasks.json layout at ${filePath}`);
}

/** Picks the next integer id after the highest numeric id already in use. */
function nextTaskId(tasks: TaskmasterStoredTask[]): number {
    const numericIds = tasks
        .map((task) => Number(task.id))
        .filter((id) => Number.isFinite(id));
    return numericIds.length > 0 ? Math.max(...numericIds) + 1 : 1;
}

/**
 * Creates TaskMaster status and task-storage workflows for the TaskMaster
 * composition root. The returned service is consumed by TaskMaster routes so
 * filesystem and environment access remain explicit production dependencies.
 */
export function createTaskmasterService(dependencies: TaskmasterServiceDependencies) {
    const tasksFilePath = (projectPath: string) => path.join(projectPath, '.taskmaster', 'tasks', 'tasks.json');

    async function readTaskFile(projectPath: string): Promise<TaskmasterTaskFile | null> {
        const filePath = tasksFilePath(projectPath);
        if (!(await dependencies.pathExists(filePath))) {
            return null;
        }
        const content = await dependencies.readTextFile(filePath);
        return parseTaskFile(JSON.parse(content), filePath);
    }

    async function writeTaskFile(
        projectPath: string,
        taskFile: TaskmasterTaskFile,
        tasks: TaskmasterStoredTask[],
    ): Promise<void> {
        taskFile.tasks = tasks;
        const serialized = taskFile.isTagged
            ? { ...taskFile.container, [taskFile.activeTag]: { ...(taskFile.container[taskFile.activeTag] as object ?? {}), tasks } }
            : taskFile.container;
        await dependencies.writeTextFile(tasksFilePath(projectPath), `${JSON.stringify(serialized, null, 2)}\n`);
    }

    return {
        /** Detects TaskMaster in the user's Claude MCP configuration without exposing secret values. */
        async detectMcpServer() {
            const homeDirectory = dependencies.getHomeDirectory();
            const configurationPaths = [
                path.join(homeDirectory, '.claude.json'),
                path.join(homeDirectory, '.claude', 'settings.json'),
            ];
            let configuration: Record<string, unknown> | null = null;
            let configurationPath: string | null = null;

            for (const candidatePath of configurationPaths) {
                try {
                    const parsedConfiguration = JSON.parse(
                        await dependencies.readTextFile(candidatePath),
                    ) as unknown;
                    if (typeof parsedConfiguration === 'object' && parsedConfiguration !== null) {
                        configuration = parsedConfiguration as Record<string, unknown>;
                        configurationPath = candidatePath;
                        break;
                    }
                } catch {
                    // A missing or malformed candidate must not prevent checking the fallback file.
                }
            }

            if (!configuration) {
                return {
                    hasMCPServer: false,
                    reason: 'No Claude configuration file found',
                    hasConfig: false,
                };
            }

            const serverGroups: Array<{
                scope: string;
                projectPath?: string;
                servers: Record<string, unknown>;
            }> = [];

            if (typeof configuration.mcpServers === 'object' && configuration.mcpServers !== null) {
                serverGroups.push({
                    scope: 'user',
                    servers: configuration.mcpServers as Record<string, unknown>,
                });
            }

            if (typeof configuration.projects === 'object' && configuration.projects !== null) {
                for (const [projectPath, projectValue] of Object.entries(configuration.projects)) {
                    const projectConfiguration = typeof projectValue === 'object' && projectValue !== null
                        ? projectValue as Record<string, unknown>
                        : {};

                    if (
                        typeof projectConfiguration.mcpServers === 'object'
                        && projectConfiguration.mcpServers !== null
                    ) {
                        serverGroups.push({
                            scope: 'local',
                            projectPath,
                            servers: projectConfiguration.mcpServers as Record<string, unknown>,
                        });
                    }
                }
            }

            for (const serverGroup of serverGroups) {
                for (const [serverName, serverValue] of Object.entries(serverGroup.servers)) {
                    const serverConfiguration = typeof serverValue === 'object' && serverValue !== null
                        ? serverValue as Record<string, unknown>
                        : {};
                    const command = typeof serverConfiguration.command === 'string'
                        ? serverConfiguration.command
                        : null;
                    const url = typeof serverConfiguration.url === 'string'
                        ? serverConfiguration.url
                        : null;
                    const isTaskmasterServer = serverName === 'task-master-ai'
                        || serverName.includes('task-master')
                        || command?.includes('task-master');

                    if (!isTaskmasterServer) {
                        continue;
                    }

                    const environmentVariables = (
                        typeof serverConfiguration.env === 'object'
                        && serverConfiguration.env !== null
                    )
                        ? serverConfiguration.env as Record<string, unknown>
                        : {};

                    return {
                        hasMCPServer: true,
                        isConfigured: Boolean(command || url),
                        hasApiKeys: Object.keys(environmentVariables).length > 0,
                        scope: serverGroup.scope,
                        ...(serverGroup.projectPath ? { projectPath: serverGroup.projectPath } : {}),
                        config: {
                            command,
                            args: Array.isArray(serverConfiguration.args) ? serverConfiguration.args : [],
                            url,
                            envVars: Object.keys(environmentVariables),
                            type: command ? 'stdio' : url ? 'http' : 'unknown',
                        },
                    };
                }
            }

            return {
                hasMCPServer: false,
                reason: 'task-master-ai not found in configured MCP servers',
                hasConfig: true,
                configPath: configurationPath,
                availableServers: serverGroups.flatMap((serverGroup) => Object.keys(serverGroup.servers)),
            };
        },

        /**
         * Reads and normalizes tasks for a project. Returns `null` when the
         * project has no tasks file yet so callers can distinguish "empty"
         * from "not initialized".
         */
        async listTasks(projectPath: string): Promise<TaskmasterStoredTask[] | null> {
            const taskFile = await readTaskFile(projectPath);
            if (!taskFile) {
                return null;
            }
            return taskFile.tasks.map((task) => normalizeTask(task));
        },

        /**
         * Appends a task to the project's tasks file and returns the persisted
         * task. Callers must supply at least a title; the description falls
         * back to the title so no task is ever persisted blank.
         */
        async addTask(projectPath: string, input: TaskmasterTaskInput): Promise<TaskmasterStoredTask> {
            const title = (input.title ?? '').trim() || 'Untitled Task';
            const taskFile = await readTaskFile(projectPath);
            const now = new Date().toISOString();
            const task: TaskmasterStoredTask = {
                id: nextTaskId(taskFile?.tasks ?? []),
                title,
                description: input.description ?? '',
                status: 'pending',
                priority: input.priority || 'medium',
                dependencies: normalizeDependencies(input.dependencies),
                details: input.details ?? '',
                testStrategy: input.testStrategy ?? '',
                subtasks: [],
                createdAt: now,
                updatedAt: now,
            };

            if (!taskFile) {
                await dependencies.ensureDirectory(path.dirname(tasksFilePath(projectPath)));
                await dependencies.writeTextFile(
                    tasksFilePath(projectPath),
                    `${JSON.stringify({ master: { tasks: [task] } }, null, 2)}\n`,
                );
                return task;
            }

            await writeTaskFile(projectPath, taskFile, [...taskFile.tasks, task]);
            return task;
        },

        /**
         * Patches one task by id and returns the updated record, or `null` when
         * the id is unknown. Only the recognized editable fields are applied.
         */
        async updateTask(
            projectPath: string,
            taskId: string,
            updates: TaskmasterTaskInput & { status?: string },
        ): Promise<TaskmasterStoredTask | null> {
            const taskFile = await readTaskFile(projectPath);
            if (!taskFile) {
                return null;
            }

            const index = taskFile.tasks.findIndex((task) => String(task.id) === String(taskId));
            if (index === -1) {
                return null;
            }

            const current = taskFile.tasks[index];
            const next: TaskmasterStoredTask = { ...current };
            if (updates.title !== undefined) next.title = updates.title;
            if (updates.description !== undefined) next.description = updates.description;
            if (updates.status !== undefined) next.status = updates.status;
            if (updates.priority !== undefined) next.priority = updates.priority;
            if (updates.details !== undefined) next.details = updates.details;
            if (updates.testStrategy !== undefined) next.testStrategy = updates.testStrategy;
            if (updates.dependencies !== undefined) next.dependencies = normalizeDependencies(updates.dependencies);
            next.updatedAt = new Date().toISOString();

            const tasks = [...taskFile.tasks];
            tasks[index] = next;
            await writeTaskFile(projectPath, taskFile, tasks);
            return next;
        },

        /**
         * Removes one task by id and returns it, or `null` when the id is
         * unknown. The removed id is stripped from every other task's
         * dependency list — including `taskId.subId` references and nested
         * subtask dependency arrays — so deletes never leave dangling ids.
         */
        async deleteTask(projectPath: string, taskId: string): Promise<TaskmasterStoredTask | null> {
            const taskFile = await readTaskFile(projectPath);
            if (!taskFile) {
                return null;
            }

            const index = taskFile.tasks.findIndex((task) => String(task.id) === String(taskId));
            if (index === -1) {
                return null;
            }

            const [removed] = taskFile.tasks.splice(index, 1);
            const removedId = String(removed.id);
            const keepDependency = (dependency: unknown) => {
                const value = String(dependency);
                return value !== removedId && !value.startsWith(`${removedId}.`);
            };

            for (const task of taskFile.tasks) {
                if (Array.isArray(task.dependencies)) {
                    task.dependencies = task.dependencies.filter(keepDependency);
                }
                for (const subtask of task.subtasks ?? []) {
                    if (Array.isArray(subtask.dependencies)) {
                        subtask.dependencies = subtask.dependencies.filter(keepDependency);
                    }
                }
            }

            await writeTaskFile(projectPath, taskFile, taskFile.tasks);
            return removed;
        },

        /**
         * Creates a minimal `.taskmaster` directory (tasks file, config, state)
         * so TaskMaster works without the external CLI or an AI provider.
         */
        async initializeProject(projectPath: string): Promise<void> {
            const taskmasterPath = path.join(projectPath, '.taskmaster');
            await dependencies.ensureDirectory(path.join(taskmasterPath, 'tasks'));

            if (!(await dependencies.pathExists(tasksFilePath(projectPath)))) {
                await dependencies.writeTextFile(
                    tasksFilePath(projectPath),
                    `${JSON.stringify({ master: { tasks: [] } }, null, 2)}\n`,
                );
            }

            const configurationPath = path.join(taskmasterPath, 'config.json');
            if (!(await dependencies.pathExists(configurationPath))) {
                await dependencies.writeTextFile(configurationPath, `${JSON.stringify(DEFAULT_CONFIGURATION, null, 2)}\n`);
            }

            const statePath = path.join(taskmasterPath, 'state.json');
            if (!(await dependencies.pathExists(statePath))) {
                await dependencies.writeTextFile(statePath, `${JSON.stringify({
                    currentTag: 'master',
                    lastSwitched: new Date().toISOString(),
                    branchTagMapping: {},
                    migrationNoticeShown: true,
                }, null, 2)}\n`);
            }
        },
    };
}
