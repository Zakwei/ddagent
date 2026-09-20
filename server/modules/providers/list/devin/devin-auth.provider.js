import { readFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import spawn from 'cross-spawn';
import { readObjectRecord, readOptionalString } from '../../../../shared/utils.js';

const DEVIN_CONFIG_DIR = path.join(os.homedir(), '.config', 'devin');
const DEVIN_DATA_DIR = path.join(os.homedir(), '.local', 'share', 'devin');

const readTomlValue = (content, key) => {
  const regex = new RegExp(`^${key}\\s*=\\s*"([^"]*)"`, 'm');
  const match = content.match(regex);
  return match ? match[1].trim() : undefined;
};

export class DevinProviderAuth {
  /**
   * Checks whether the Devin CLI is available to the server process.
   */
  checkInstalled() {
    try {
      const result = spawn.sync('devin', ['--version'], { stdio: 'ignore', timeout: 5000 });
      return !result.error && result.status === 0;
    } catch {
      return false;
    }
  }

  /**
   * Returns Devin CLI installation and credential status.
   */
  async getStatus() {
    const installed = this.checkInstalled();

    if (!installed) {
      return {
        installed,
        provider: 'devin',
        authenticated: false,
        email: null,
        method: null,
        error: 'Devin CLI not found',
      };
    }

    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'devin',
      authenticated: credentials.authenticated,
      email: credentials.email,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error,
    };
  }

  /**
   * Reads Devin credential files and falls back to environment API keys.
   */
  async checkCredentials() {
    try {
      const credentialsPath = path.join(DEVIN_DATA_DIR, 'credentials.toml');
      const content = await readFile(credentialsPath, 'utf8');
      const apiKey = readTomlValue(content, 'windsurf_api_key');
      if (apiKey) {
        return {
          authenticated: true,
          email: 'Windsurf API key',
          method: 'credentials_file',
        };
      }
    } catch (error) {
      if (error.code !== 'ENOENT') {
        return {
          authenticated: false,
          email: null,
          method: null,
          error: `Failed to read Devin credentials: ${error.message}`,
        };
      }
    }

    const envKey = process.env.WINDSURF_API_KEY?.trim() || process.env.DEVIN_API_KEY?.trim();
    if (envKey) {
      return {
        authenticated: true,
        email: 'Environment API key',
        method: 'environment',
      };
    }

    try {
      const configPath = path.join(DEVIN_CONFIG_DIR, 'config.json');
      const content = await readFile(configPath, 'utf8');
      const config = readObjectRecord(JSON.parse(content)) ?? {};
      const devinConfig = readObjectRecord(config.devin);
      const key = readOptionalString(devinConfig?.windsurf_api_key ?? devinConfig?.api_key);
      if (key) {
        return {
          authenticated: true,
          email: 'Devin config',
          method: 'config_file',
        };
      }
    } catch (error) {
      if (error.code !== 'ENOENT') {
        return {
          authenticated: false,
          email: null,
          method: null,
          error: `Failed to read Devin config: ${error.message}`,
        };
      }
    }

    return {
      authenticated: false,
      email: null,
      method: null,
      error: 'Devin credentials not found. Configure WINDSURF_API_KEY or run devin login.',
    };
  }
}
