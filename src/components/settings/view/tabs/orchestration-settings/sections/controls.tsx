import { ChevronDown, ChevronUp, X } from 'lucide-react';
import type { ReactNode } from 'react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../../../lib/utils';
import { Button } from '../../../../../../shared/view/ui';

export const fieldSelectClass =
  'w-full touch-manipulation rounded-lg border border-input bg-card p-2 text-sm text-foreground focus:border-primary focus:ring-1 focus:ring-primary';

/** Labeled mini-field used by the dense candidate/template grids. */
export function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <label className="block min-w-0">
      <span className="mb-1 block text-[11px] font-medium uppercase tracking-wide text-muted-foreground">
        {label}
      </span>
      {children}
    </label>
  );
}

export function MoveButtons({
  index,
  count,
  onMove,
}: {
  index: number;
  count: number;
  onMove: (index: number, direction: -1 | 1) => void;
}) {
  const { t } = useTranslation('settings');
  return (
    <>
      <Button
        type="button"
        variant="ghost"
        size="icon"
        className="h-7 w-7"
        disabled={index === 0}
        onClick={() => onMove(index, -1)}
        aria-label={t('orchestration.pool.fields.moveUp')}
        title={t('orchestration.pool.fields.moveUp')}
      >
        <ChevronUp className="h-3.5 w-3.5" />
      </Button>
      <Button
        type="button"
        variant="ghost"
        size="icon"
        className="h-7 w-7"
        disabled={index === count - 1}
        onClick={() => onMove(index, 1)}
        aria-label={t('orchestration.pool.fields.moveDown')}
        title={t('orchestration.pool.fields.moveDown')}
      >
        <ChevronDown className="h-3.5 w-3.5" />
      </Button>
    </>
  );
}

export type OrderedEntry = {
  id: string;
  content: ReactNode;
};

/**
 * Compact vertical ordered list shared by routing rules and template steps:
 * numbered rows with up/down/remove plus a trailing "add" select.
 */
export function OrderedEntriesEditor({
  entries,
  onMove,
  onRemove,
  addOptions,
  addPlaceholder,
  onAdd,
  emptyLabel,
  removeLabel,
}: {
  entries: OrderedEntry[];
  onMove: (index: number, direction: -1 | 1) => void;
  onRemove: (id: string) => void;
  addOptions: { value: string; label: string }[];
  addPlaceholder: string;
  onAdd: (value: string) => void;
  emptyLabel: string;
  removeLabel: string;
}) {
  return (
    <div className="min-w-0 space-y-1">
      {entries.map((entry, index) => (
        <div
          key={entry.id}
          className="flex items-center gap-1 rounded-lg border border-border/50 bg-muted/30 px-2 py-1"
        >
          <span className="w-4 flex-shrink-0 text-[10px] font-medium text-muted-foreground">
            {index + 1}.
          </span>
          <span className="flex min-w-0 flex-1 items-center gap-1.5 truncate text-xs">
            {entry.content}
          </span>
          <MoveButtons index={index} count={entries.length} onMove={onMove} />
          <Button
            type="button"
            variant="ghost"
            size="icon"
            className="h-7 w-7 text-muted-foreground hover:bg-destructive/10 hover:text-destructive"
            onClick={() => onRemove(entry.id)}
            aria-label={removeLabel}
            title={removeLabel}
          >
            <X className="h-3.5 w-3.5" />
          </Button>
        </div>
      ))}
      {entries.length === 0 && (
        <p className="px-1 text-xs italic text-muted-foreground">{emptyLabel}</p>
      )}
      {addOptions.length > 0 && (
        <select
          value=""
          onChange={(event) => {
            if (event.target.value) onAdd(event.target.value);
          }}
          className={cn(fieldSelectClass, 'h-8 py-1 text-xs text-muted-foreground')}
        >
          <option value="">{addPlaceholder}</option>
          {addOptions.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
      )}
    </div>
  );
}

/** Small segmented control used for the planner mode picker. */
export function SegmentedControl<T extends string>({
  value,
  options,
  onChange,
  ariaLabel,
}: {
  value: T;
  options: { value: T; label: string }[];
  onChange: (value: T) => void;
  ariaLabel: string;
}) {
  return (
    <div
      role="radiogroup"
      aria-label={ariaLabel}
      className="inline-flex rounded-lg border border-border bg-muted/30 p-0.5"
    >
      {options.map((option) => {
        const active = option.value === value;
        return (
          <button
            key={option.value}
            type="button"
            role="radio"
            aria-checked={active}
            onClick={() => onChange(option.value)}
            className={cn(
              'rounded-md px-3 py-1.5 text-xs font-semibold transition-all',
              active
                ? 'bg-background text-foreground shadow-sm ring-1 ring-border/70'
                : 'text-muted-foreground hover:text-foreground',
            )}
          >
            {option.label}
          </button>
        );
      })}
    </div>
  );
}
