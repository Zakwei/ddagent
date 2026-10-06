import type { IProviderModels } from '@/shared/interfaces.js';
import type {
  AnyRecord,
  ProviderCurrentActiveModel,
  ProviderModelsDefinition,
} from '@/shared/types.js';
import {
  buildDefaultProviderCurrentActiveModel,
  createRefreshingCache,
  execCliFile,
  PROVIDER_MODEL_CACHE_TTL_MS,
} from '@/shared/utils.js';

const FALLBACK_MODELS: ProviderModelsDefinition = {
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

async function loadDevinModels(): Promise<ProviderModelsDefinition> {
  try {
    const { stdout } = await execCliFile('devin', ['models', 'list', '--format', 'json'], {
      encoding: 'utf8',
      timeout: 30_000,
      maxBuffer: 16 * 1024 * 1024,
    });
    const data = JSON.parse(stdout) as { families: AnyRecord[] };
    const options = [];
    for (const family of data.families) {
      for (const variant of family.variants as AnyRecord[]) {
        const isFree = (variant.cost_tier as string | undefined)?.toLowerCase() === 'free';
        const costSummary = (variant.cost_summary as string | undefined) || (isFree ? 'Free' : '');
        options.push({
          value: variant.model_uid as string,
          label: variant.label as string,
          description: `${family.family_label}${costSummary ? ' · ' + costSummary : ''}`,
        });
      }
    }
    const DEFAULT = 'swe-1-7';
    return {
      OPTIONS: options,
      DEFAULT: options.some((o) => o.value === DEFAULT) ? DEFAULT : options[0]?.value ?? 'swe-1-7',
    };
  } catch (error) {
    console.error(
      '[DevinProviderModels] Failed to load models from devin CLI:',
      (error as Error)?.message || error,
    );
    throw error;
  }
}

// The live catalog is re-polled at most once per PROVIDER_MODEL_CACHE_TTL_MS.
// A failed poll serves the fallback until the next window instead of retrying
// the CLI on every model request.
const catalogCache = createRefreshingCache(loadDevinModels, PROVIDER_MODEL_CACHE_TTL_MS, FALLBACK_MODELS);

export class DevinProviderModels implements IProviderModels {
  async getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition> {
    return catalogCache.get(forceRefresh);
  }

  async getCurrentActiveModel(_sessionId?: string): Promise<ProviderCurrentActiveModel> {
    return buildDefaultProviderCurrentActiveModel(await catalogCache.get());
  }
}
