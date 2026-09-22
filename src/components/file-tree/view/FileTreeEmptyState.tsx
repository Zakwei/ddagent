import type { LucideIcon } from 'lucide-react';

import { EmptyState } from '../../../shared/view/ui';

type FileTreeEmptyStateProps = {
  icon: LucideIcon;
  title: string;
  description: string;
};

export default function FileTreeEmptyState({ icon, title, description }: FileTreeEmptyStateProps) {
  return <EmptyState icon={icon} title={title} description={description} />;
}
