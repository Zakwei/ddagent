import { Terminal } from 'lucide-react';

import { EmptyState } from '../../../../shared/view/ui';

type StandaloneShellEmptyStateProps = {
  className: string;
};

export default function StandaloneShellEmptyState({ className }: StandaloneShellEmptyStateProps) {
  return (
    <EmptyState
      icon={Terminal}
      title="No Project Selected"
      description="A project is required to open a shell"
      className={`h-full ${className}`}
    />
  );
}
