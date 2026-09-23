import { AbstractProvider } from '../../../../modules/providers/shared/base/abstract.provider.js';
import { DevinProviderAuth } from './devin-auth.provider.js';
import { DevinProviderModels } from './devin-models.provider.js';
import { devinRuntime } from './devin-runtime.provider.js';
import { DevinMcpProvider } from './devin-mcp.provider.js';
import { DevinSessionSynchronizer } from './devin-session-synchronizer.provider.js';
import { DevinSessionsProvider } from './devin-sessions.provider.js';
import { DevinSkillsProvider } from './devin-skills.provider.js';

export class DevinProvider extends AbstractProvider {
    // Lazy getter (see claude.provider.ts): breaks the runtime → notifications
    // → providers import cycle's TDZ crash on direct runtime imports.
    _runtime = null;
    get runtime() {
        return (this._runtime ??= devinRuntime);
    }
    models = new DevinProviderModels();
    mcp = new DevinMcpProvider();
    auth = new DevinProviderAuth();
    skills = new DevinSkillsProvider();
    sessions = new DevinSessionsProvider();
    sessionSynchronizer = new DevinSessionSynchronizer();

    constructor() {
        super('devin');
    }
}
