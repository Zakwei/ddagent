import { Terminal } from 'lucide-react';

import { EmptyState } from '../../../../shared/view/ui';

type ShellEmptyStateProps = {
  title: string;
  description: string;
};

export default function ShellEmptyState({ title, description }: ShellEmptyStateProps) {
  return <EmptyState icon={Terminal} title={title} description={description} className="h-full" />;
}
