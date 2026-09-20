import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { buildDefaultProviderCurrentActiveModel } from '../../../../shared/utils.js';
const execFileAsync = promisify(execFile);
const FALLBACK_MODELS = {
    OPTIONS: [
        { value: 'swe-1-7', label: 'SWE-1.7', description: 'Devin · Free' },
        { value: 'claude-sonnet-5-medium', label: 'Claude Sonnet 5 Medium', description: 'Devin · Balanced' },
        { value: 'claude-opus-5-medium', label: 'Claude Opus 5 Medium', description: 'Devin · Powerful' },
        { value: 'claude-5-fable-medium', label: 'Claude Fable 5 Medium', description: 'Devin · Fast' },
        { value: 'gemini-3-7-flash-medium', label: 'Gemini 3.7 Flash Medium', description: 'Devin · Google' },
        { value: 'gpt-5-6-sol-medium', label: 'GPT-5.6 Sol Medium', description: 'Devin · OpenAI' },
    ],
    DEFAULT: 'swe-1-7',
};
let modelCache = null;
let loadPromise = null;
async function loadDevinModels() {
    if (modelCache) {
        return modelCache;
    }
    if (loadPromise) {
        return loadPromise;
    }
    loadPromise = (async () => {
        try {
            const { stdout } = await execFileAsync('devin', ['models', 'list', '--format', 'json'], { timeout: 30000, maxBuffer: 16 * 1024 * 1024 });
            const data = JSON.parse(stdout);
            const options = [];
            for (const family of data.families) {
                for (const variant of family.variants) {
                    const isFree = variant.cost_tier?.toLowerCase() === 'free';
                    const costSummary = variant.cost_summary || (isFree ? 'Free' : '');
                    options.push({
                        value: variant.model_uid,
                        label: variant.label,
                        description: `${family.family_label}${costSummary ? ' · ' + costSummary : ''}`,
                    });
                }
            }
            const DEFAULT = 'swe-1-7';
            const definition = {
                OPTIONS: options,
                DEFAULT: options.some((o) => o.value === DEFAULT) ? DEFAULT : options[0]?.value ?? 'swe-1-7',
            };
            modelCache = definition;
            return definition;
        }
        catch (error) {
            console.error('[DevinProviderModels] Failed to load models from devin CLI:', error?.message || error);
            // The fallback is served but not cached: a transient failure must
            // not pin its tiny model set for the whole process lifetime.
            return FALLBACK_MODELS;
        }
    })();
    return loadPromise;
}
export class DevinProviderModels {
    async getSupportedModels() {
        return loadDevinModels();
    }
    async getCurrentActiveModel(_sessionId) {
        return buildDefaultProviderCurrentActiveModel(await loadDevinModels());
    }
}
//# sourceMappingURL=devin-models.provider.js.map