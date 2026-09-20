import os from 'node:os';
import path from 'node:path';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { McpProvider } from '../../../../modules/providers/shared/mcp/mcp.provider.js';
import { AppError, readJsonConfig, readObjectRecord, readOptionalString, readStringArray, readStringRecord, writeJsonConfig, } from '../../../../shared/utils.js';

const execFileAsync = promisify(execFile);

const resolveDevinConfigPath = (scope, workspacePath) => {
    if (scope === 'user') {
        return path.join(os.homedir(), '.config', 'devin', 'mcp_config.json');
    }
    if (scope === 'local') {
        return path.join(workspacePath, '.devin', 'mcp_config.local.json');
    }
    return path.join(workspacePath, '.devin', 'mcp_config.json');
};

const isSupportedTransport = (value) => value === 'stdio' || value === 'sse' || value === 'ws';

function normalizeServerName(name) {
    const normalized = String(name ?? '').trim();
    if (!normalized) {
        throw new AppError('MCP server name is required.', {
            code: 'MCP_SERVER_NAME_REQUIRED',
            statusCode: 400,
        });
    }
    return normalized;
}

/**
 * Parse the text output of `devin mcp list` into a list of partial server objects.
 * The CLI does not expose a JSON mode, so we parse its human-readable listing.
 */
function parseDevinMcpList(stdout, scope = 'user') {
    const lines = String(stdout).split(/\r?\n/);
    const servers = [];
    let index = 0;

    // Skip to the header.
    while (index < lines.length && !lines[index].startsWith('Configured MCP servers:')) {
        index += 1;
    }
    index += 1;

    // Skip blank lines after the header.
    while (index < lines.length && lines[index].trim() === '') {
        index += 1;
    }

    while (index < lines.length) {
        const line = lines[index];
        const match = line.match(/^  ([•✗])\s+(.+)$/u);
        if (!match) {
            index += 1;
            continue;
        }

        const [, bullet, rawName] = match;
        let name = rawName.trim();
        let disabled = false;
        if (name.endsWith('(disabled)')) {
            disabled = true;
            name = name.replace(/\s*\(disabled\)\s*$/, '').trim();
        }

        index += 1;

        // Skip blank lines to the detail line.
        while (index < lines.length && lines[index].trim() === '') {
            index += 1;
        }

        let details = '';
        if (index < lines.length && lines[index].startsWith('    ')) {
            details = lines[index].trim();
            index += 1;
        }

        if (!details) {
            continue;
        }

        let transport;
        let command;
        let args = [];
        let url;

        if (details.startsWith('Command:')) {
            const commandLine = details.slice('Command:'.length).trim();
            const tokens = commandLine.split(/\s+/).filter(Boolean);
            if (tokens.length > 0) {
                command = tokens[0];
                args = tokens.slice(1);
            }
            transport = 'stdio';
        }
        else if (details.startsWith('URL:')) {
            url = details.slice('URL:'.length).trim();
            // The CLI only exposes http/sse over `mcp list`; default to http.
            transport = 'http';
        }
        else {
            continue;
        }

        servers.push({
            provider: 'devin',
            name,
            scope,
            transport,
            command,
            args,
            env: {},
            cwd: undefined,
            url,
            headers: {},
            envVars: [],
            bearerTokenEnvVar: undefined,
            envHttpHeaders: {},
            disabled,
        });
    }

    return servers;
}

// Self-check: run this file directly with `node` to verify the parser.
if (import.meta.url === `file://${process.argv[1]}`) {
    const sample = [
        'Configured MCP servers:',
        '',
        '  • ddg-search',
        '    Command: /usr/local/bin/duckduckgo-mcp-server --search-backend curl --fetch-backend curl',
        '',
        '  • echo',
        '    Command: /bin/echo hello',
        '',
        '  ✗ github  (disabled)',
        '    URL: https://api.github.com',
        '',
    ].join('\n');
    const parsed = parseDevinMcpList(sample, 'user');
    console.log(JSON.stringify(parsed, null, 2));
    if (parsed.length !== 3) {
        throw new Error(`Expected 3 servers, got ${parsed.length}`);
    }
    if (parsed[0].name !== 'ddg-search'
        || parsed[0].command !== '/usr/local/bin/duckduckgo-mcp-server'
        || parsed[0].args.length !== 4) {
        throw new Error('ddg-search parse failed');
    }
    if (parsed[1].name !== 'echo'
        || parsed[1].command !== '/bin/echo'
        || parsed[1].args.join(' ') !== 'hello') {
        throw new Error('echo parse failed');
    }
    if (parsed[2].name !== 'github'
        || parsed[2].url !== 'https://api.github.com'
        || parsed[2].disabled !== true) {
        throw new Error('github disabled parse failed');
    }
    console.log('Self-check passed');
}

export class DevinMcpProvider extends McpProvider {
    constructor() {
        super('devin', ['user', 'project', 'local'], ['stdio', 'http', 'sse', 'ws']);
    }

    async readScopedServers(scope, workspacePath) {
        const filePath = resolveDevinConfigPath(scope, workspacePath);
        const config = await readJsonConfig(filePath);
        return readObjectRecord(config.mcpServers) ?? {};
    }

    async writeScopedServers(scope, workspacePath, servers) {
        const filePath = resolveDevinConfigPath(scope, workspacePath);
        const config = await readJsonConfig(filePath);
        config.mcpServers = servers;
        await writeJsonConfig(filePath, config);
    }

    buildServerConfig(input) {
        if (input.transport === 'stdio') {
            if (!input.command?.trim()) {
                throw new AppError('command is required for stdio MCP servers.', {
                    code: 'MCP_COMMAND_REQUIRED',
                    statusCode: 400,
                });
            }
            return {
                command: input.command,
                args: input.args ?? [],
                env: input.env ?? {},
            };
        }
        if (!input.url?.trim()) {
            throw new AppError('url is required for sse/ws MCP servers.', {
                code: 'MCP_URL_REQUIRED',
                statusCode: 400,
            });
        }
        return {
            url: input.url,
            headers: input.headers ?? {},
            transport: input.transport,
        };
    }

    normalizeServerConfig(scope, name, rawConfig) {
        const config = readObjectRecord(rawConfig);
        if (!config) {
            return null;
        }

        const command = readOptionalString(config.command);
        const args = readStringArray(config.args);
        const url = readOptionalString(config.url);
        const explicitTransport = readOptionalString(config.transport);

        let transport = isSupportedTransport(explicitTransport) ? explicitTransport : undefined;
        if (!transport) {
            if (command || (args && args.length > 0)) {
                transport = 'stdio';
            }
            else if (url) {
                transport = 'sse';
            }
            else {
                return null;
            }
        }

        if (transport === 'stdio') {
            let finalCommand;
            let finalArgs;
            if (command) {
                finalCommand = command;
                finalArgs = args ?? [];
            }
            else if (args && args.length > 0) {
                finalCommand = args[0];
                finalArgs = args.slice(1);
            }
            else {
                return null;
            }
            const env = readStringRecord(config.env) ?? readStringRecord(config.environment);
            return {
                provider: 'devin',
                name,
                scope,
                transport: 'stdio',
                command: finalCommand,
                args: finalArgs,
                env,
            };
        }

        if (transport === 'sse' || transport === 'ws') {
            const finalUrl = readOptionalString(config.url);
            if (!finalUrl) {
                return null;
            }
            const headers = readStringRecord(config.headers);
            return {
                provider: 'devin',
                name,
                scope,
                transport,
                url: finalUrl,
                headers,
            };
        }

        return null;
    }

    async listServersForScope(scope, options) {
        if (scope === 'user') {
            const workspacePath = options?.workspacePath
                ? path.resolve(options.workspacePath)
                : process.cwd();
            try {
                const { stdout } = await execFileAsync(
                    'devin',
                    ['mcp', 'list'],
                    { cwd: workspacePath, timeout: 30_000, maxBuffer: 16 * 1024 * 1024 },
                );
                return parseDevinMcpList(stdout, 'user');
            }
            catch (error) {
                console.error('[DevinMcpProvider] Failed to list MCP servers via devin CLI:', error?.message || error);
                return super.listServersForScope(scope, options);
            }
        }

        return super.listServersForScope(scope, options);
    }

    async upsertServer(input) {
        if (input.scope === 'user') {
            const name = normalizeServerName(input.name);
            const scope = input.scope;
            const transport = input.transport ?? 'stdio';

            if (!['stdio', 'http', 'sse'].includes(transport)) {
                throw new AppError(`Devin MCP does not support "${transport}" transport for add.`, {
                    code: 'MCP_TRANSPORT_NOT_SUPPORTED',
                    statusCode: 400,
                });
            }

            const cliArgs = ['mcp', 'add', name, '-s', scope, '--transport', transport];

            if (transport === 'stdio') {
                if (!input.command?.trim()) {
                    throw new AppError('command is required for stdio MCP servers.', {
                        code: 'MCP_COMMAND_REQUIRED',
                        statusCode: 400,
                    });
                }
                for (const [key, value] of Object.entries(input.env ?? {})) {
                    cliArgs.push('-e', `${key}=${value}`);
                }
                cliArgs.push('--', input.command, ...(input.args ?? []));
            }
            else {
                if (!input.url?.trim()) {
                    throw new AppError('url is required for http/sse MCP servers.', {
                        code: 'MCP_URL_REQUIRED',
                        statusCode: 400,
                    });
                }
                cliArgs.push('--url', input.url);
                for (const [key, value] of Object.entries(input.env ?? {})) {
                    cliArgs.push('-e', `${key}=${value}`);
                }
                for (const [key, value] of Object.entries(input.headers ?? {})) {
                    cliArgs.push('-H', `${key}: ${value}`);
                }
            }

            const cwd = input.workspacePath ? path.resolve(input.workspacePath) : process.cwd();
            try {
                await execFileAsync('devin', cliArgs, { cwd, timeout: 30_000 });
            }
            catch (error) {
                const stderr = error?.stderr || error?.message || 'Unknown error';
                throw new AppError(`Failed to add Devin MCP server: ${stderr}`, {
                    code: 'MCP_ADD_FAILED',
                    statusCode: 500,
                });
            }

            return {
                provider: 'devin',
                name,
                scope,
                transport,
                command: input.command,
                args: input.args ?? [],
                env: input.env ?? {},
                cwd: input.cwd,
                url: input.url,
                headers: input.headers ?? {},
                envVars: input.envVars ?? [],
                bearerTokenEnvVar: input.bearerTokenEnvVar,
                envHttpHeaders: input.envHttpHeaders ?? {},
            };
        }

        return super.upsertServer(input);
    }

    async removeServer(input) {
        if (input.scope === 'user') {
            const name = normalizeServerName(input.name);
            const scope = input.scope;
            const cliArgs = ['mcp', 'remove', '-s', scope, name];
            const cwd = input.workspacePath ? path.resolve(input.workspacePath) : process.cwd();

            try {
                await execFileAsync('devin', cliArgs, { cwd, timeout: 30_000 });
                return { removed: true, provider: 'devin', name, scope };
            }
            catch (error) {
                const stderr = error?.stderr || error?.message || 'Unknown error';
                const notFound = /not found|does not exist|not in the user config|configured by/i.test(stderr);
                if (notFound) {
                    return { removed: false, provider: 'devin', name, scope };
                }
                throw new AppError(`Failed to remove Devin MCP server: ${stderr}`, {
                    code: 'MCP_REMOVE_FAILED',
                    statusCode: 500,
                });
            }
        }

        return super.removeServer(input);
    }
}
