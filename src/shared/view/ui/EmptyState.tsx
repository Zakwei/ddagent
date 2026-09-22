import { Loader2, type LucideIcon } from 'lucide-react';
import type { ReactNode } from 'react';

import { cn } from '../../../lib/utils';

import { Button } from './Button';

export type EmptyStateAction = {
  label: string;
  onClick: () => void;
  icon?: LucideIcon;
  disabled?: boolean;
  loading?: boolean;
};

type EmptyStateProps = {
  icon: LucideIcon;
  title: ReactNode;
  description?: ReactNode;
  action?: EmptyStateAction;
  /** sm = inline list slot, md = panel (default), lg = full-page area. */
  size?: 'sm' | 'md' | 'lg';
  className?: string;
};

const SIZES = {
  sm: {
    wrapper: 'gap-2 py-4',
    tile: 'h-8 w-8 rounded-lg',
    icon: 'h-4 w-4',
    title: 'text-xs',
    description: 'max-w-[16rem] text-xs',
  },
  md: {
    wrapper: 'gap-3 py-8',
    tile: 'h-11 w-11 rounded-xl',
    icon: 'h-5 w-5',
    title: 'text-sm',
    description: 'max-w-xs text-sm',
  },
  lg: {
    wrapper: 'gap-4 py-16',
    tile: 'h-14 w-14 rounded-2xl',
    icon: 'h-7 w-7',
    title: 'text-base',
    description: 'max-w-sm text-sm',
  },
} as const;

export default function EmptyState({
  icon: Icon,
  title,
  description,
  action,
  size = 'md',
  className,
}: EmptyStateProps) {
  const s = SIZES[size];
  const ActionIcon = action?.icon;

  return (
    <div
      className={cn(
        'empty-state-enter flex flex-col items-center justify-center text-center',
        s.wrapper,
        className,
      )}
    >
      <div
        className={cn(
          'flex items-center justify-center border border-border/60 bg-muted/40 text-muted-foreground',
          s.tile,
        )}
      >
        <Icon className={s.icon} aria-hidden />
      </div>
      <div className="space-y-1">
        <p className={cn('font-medium text-foreground', s.title)}>{title}</p>
        {description ? (
          <p className={cn('mx-auto text-muted-foreground', s.description)}>{description}</p>
        ) : null}
      </div>
      {action ? (
        <Button
          size="sm"
          onClick={action.onClick}
          disabled={action.disabled || action.loading}
          className="mt-1"
        >
          {action.loading ? <Loader2 className="animate-spin" /> : ActionIcon ? <ActionIcon /> : null}
          {action.label}
        </Button>
      ) : null}
    </div>
  );
}
