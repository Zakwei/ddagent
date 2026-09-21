import { PillBar, Pill } from '../../../../../../shared/view/ui';
import LLMProviderLogo from '../../../../../llm-provider-logo/LLMProviderLogo';
import type { AgentProvider } from '../../../../types/types';
import type { AgentSelectorSectionProps } from '../types';

const AGENT_NAMES: Record<AgentProvider, string> = {
  claude: 'Claude',
  cursor: 'Cursor',
  codex: 'Codex',
  opencode: 'OpenCode',
  devin: 'Devin',
};

export default function AgentSelectorSection({
  agents,
  selectedAgent,
  onSelectAgent,
  agentContextById,
}: AgentSelectorSectionProps) {
  return (
    <div className="flex-shrink-0 border-b border-border px-3 py-2 md:px-4 md:py-3">
      <PillBar className="scrollbar-hide w-full overflow-x-auto whitespace-nowrap md:w-auto md:overflow-x-visible">
        {agents.map((agent) => {
          const dotColor =
            agent === 'claude' ? 'bg-blue-500' :
            agent === 'cursor' ? 'bg-purple-500' :
            agent === 'opencode' ? 'bg-zinc-500' : 'bg-foreground/60';

          return (
            <Pill
              key={agent}
              isActive={selectedAgent === agent}
              onClick={() => onSelectAgent(agent)}
              className="min-w-max flex-1 justify-center md:min-w-0 md:flex-initial"
            >
              <LLMProviderLogo provider={agent} className="h-4 w-4 flex-shrink-0" />
              <span className="truncate">{AGENT_NAMES[agent]}</span>
              {agentContextById[agent].authStatus.authenticated && (
                <span className={`h-1.5 w-1.5 flex-shrink-0 rounded-full ${dotColor}`} />
              )}
            </Pill>
          );
        })}
      </PillBar>
    </div>
  );
}
