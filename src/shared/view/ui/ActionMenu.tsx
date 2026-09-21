import * as React from 'react';
import { createPortal } from 'react-dom';
import { ChevronDown, Loader2, type LucideIcon } from 'lucide-react';

import { cn } from '../../../lib/utils';

import { Button } from './Button';

type ButtonVariant = 'default' | 'destructive' | 'outline' | 'secondary' | 'ghost' | 'link';
type ButtonSize = 'default' | 'sm' | 'lg' | 'icon';

/**
 * Caps how tall a portal menu may grow before it scrolls.
 *
 * Some providers expose hundreds of models (Devin ~385, OpenCode ~129), so a
 * menu without a cap renders past the viewport and the tail becomes
 * unreachable.
 */
const MAX_MENU_HEIGHT = 320;

/**
 * Above this many items a menu gets a search box, because scrolling a
 * several-hundred-entry catalog is not usable on touch.
 */
const SEARCH_THRESHOLD = 12;

export type ActionMenuItem = {
  key: string;
  label: string;
  description?: string;
  icon?: LucideIcon;
  onSelect: () => void;
  disabled?: boolean;
  loading?: boolean;
  isDanger?: boolean;
  showDividerBefore?: boolean;
  closeOnSelect?: boolean;
};

type ActionMenuProps = {
  label: string;
  items: ActionMenuItem[];
  icon?: LucideIcon;
  ariaLabel?: string;
  align?: 'left' | 'right';
  variant?: ButtonVariant;
  size?: ButtonSize;
  className?: string;
  triggerClassName?: string;
  menuClassName?: string;
  disabled?: boolean;
  iconOnly?: boolean;
  portal?: boolean;
  header?: React.ReactNode;
  /** Placeholder for the search box shown when the menu has many items. */
  searchPlaceholder?: string;
  /** Shown when a search query matches no items. */
  emptyText?: string;
  onOpenChange?: (open: boolean) => void;
};

export default function ActionMenu({
  label,
  items,
  icon: TriggerIcon,
  ariaLabel,
  align = 'right',
  variant = 'outline',
  size = 'sm',
  className,
  triggerClassName,
  menuClassName,
  disabled,
  iconOnly = false,
  portal = false,
  header,
  searchPlaceholder = 'Search…',
  emptyText = 'No results',
  onOpenChange,
}: ActionMenuProps) {
  const [isOpen, setIsOpen] = React.useState(false);
  const [searchQuery, setSearchQuery] = React.useState('');
  const [portalPosition, setPortalPosition] = React.useState<{ top: number; left: number } | null>(null);
  const rootRef = React.useRef<HTMLDivElement | null>(null);
  const triggerRef = React.useRef<HTMLButtonElement | null>(null);
  const menuRef = React.useRef<HTMLDivElement | null>(null);
  const searchInputRef = React.useRef<HTMLInputElement | null>(null);
  // Whether closing should move focus back to the trigger. Set for keyboard
  // (Escape) and item selection, but left false for outside pointer clicks so
  // focus is not stolen from wherever the user clicked.
  const restoreFocusRef = React.useRef(false);
  const focusMenuOnOpenRef = React.useRef(false);
  const wasOpenRef = React.useRef(false);
  const menuId = React.useId();

  const showSearch = items.length > SEARCH_THRESHOLD;
  const normalizedQuery = searchQuery.trim().toLowerCase();
  const filteredItems = React.useMemo(() => {
    if (!showSearch || !normalizedQuery) {
      return items;
    }
    return items.filter(
      (item) =>
        item.label.toLowerCase().includes(normalizedQuery)
        || item.description?.toLowerCase().includes(normalizedQuery),
    );
  }, [items, showSearch, normalizedQuery]);

  React.useEffect(() => {
    if (!isOpen) {
      setSearchQuery('');
    }
  }, [isOpen]);

  const setMenuOpen = React.useCallback((open: boolean) => {
    setIsOpen(open);
    if (!open) {
      setPortalPosition(null);
    }
    onOpenChange?.(open);
  }, [onOpenChange]);

  React.useEffect(() => {
    if (!isOpen) {
      return;
    }

    const closeOnOutsideClick = (event: MouseEvent) => {
      const target = event.target as Node;
      if (
        rootRef.current
        && !rootRef.current.contains(target)
        && !menuRef.current?.contains(target)
      ) {
        setMenuOpen(false);
      }
    };

    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        restoreFocusRef.current = true;
        setMenuOpen(false);
      }
    };

    document.addEventListener('mousedown', closeOnOutsideClick);
    document.addEventListener('keydown', closeOnEscape);
    return () => {
      document.removeEventListener('mousedown', closeOnOutsideClick);
      document.removeEventListener('keydown', closeOnEscape);
    };
  }, [isOpen, setMenuOpen]);

  React.useEffect(() => {
    if (!isOpen || !portal) {
      return;
    }

    const closeOnViewportChange = (event: Event) => {
      // Scrolling inside the menu (long model catalogs) must not close it;
      // only a scroll of the page behind it should.
      if (menuRef.current?.contains(event.target as Node)) {
        return;
      }
      setMenuOpen(false);
    };
    window.addEventListener('resize', closeOnViewportChange);
    window.addEventListener('scroll', closeOnViewportChange, true);
    return () => {
      window.removeEventListener('resize', closeOnViewportChange);
      window.removeEventListener('scroll', closeOnViewportChange, true);
    };
  }, [isOpen, portal, setMenuOpen]);

  // Move focus into the menu on open and back to the trigger on a keyboard or
  // selection close, so keyboard and screen-reader navigation match the menu role.
  React.useEffect(() => {
    if (isOpen) {
      wasOpenRef.current = true;
      if (focusMenuOnOpenRef.current) {
        // Keyboard-opened: jump straight into the search box when there is
        // one, otherwise the first item. Pointer/touch opens keep focus off
        // the input so scrolling the catalog does not summon the keyboard.
        const menu = menuRef.current;
        const target = searchInputRef.current
          ?? menu?.querySelector<HTMLButtonElement>('[role="menuitem"]:not([disabled])');
        (target ?? menu)?.focus();
      }
      return;
    }

    if (wasOpenRef.current) {
      wasOpenRef.current = false;
      if (restoreFocusRef.current) {
        triggerRef.current?.focus();
      }
      restoreFocusRef.current = false;
    }
  }, [isOpen]);

  const runItem = (item: ActionMenuItem) => {
    if (item.disabled || item.loading) {
      return;
    }

    if (item.closeOnSelect !== false) {
      restoreFocusRef.current = true;
      setMenuOpen(false);
    }
    item.onSelect();
  };

  const toggleMenu = () => {
    if (isOpen) {
      setMenuOpen(false);
      return;
    }

    if (portal && triggerRef.current) {
      const rect = triggerRef.current.getBoundingClientRect();
      const menuWidth = 260;
      // Long catalogs (some providers expose hundreds of models) are capped and
      // scrolled, so the estimate must be capped too or the menu is placed off
      // screen above the trigger.
      const estimatedHeight = Math.min(
        MAX_MENU_HEIGHT,
        (header ? 52 : 0)
          + items.reduce((height, item) => height + (item.description ? 58 : 40) + (item.showDividerBefore ? 9 : 0), 12),
      );
      setPortalPosition({
        top: rect.bottom + 6 + estimatedHeight <= window.innerHeight - 8
          ? rect.bottom + 6
          : Math.max(8, rect.top - estimatedHeight - 6),
        left: Math.max(8, Math.min(rect.right - menuWidth, window.innerWidth - menuWidth - 8)),
      });
    }
    setMenuOpen(true);
  };

  const menu = isOpen && (!portal || portalPosition) && (
    <div
      ref={menuRef}
      id={menuId}
      role="menu"
      tabIndex={-1}
      className={cn(
        portal ? 'fixed z-[70]' : 'absolute top-full z-50 mt-2',
        'min-w-[220px] rounded-lg border border-border bg-popover p-1 text-popover-foreground shadow-lg',
        'animate-in fade-in-0 zoom-in-95',
        !portal && (align === 'right' ? 'right-0' : 'left-0'),
        menuClassName,
      )}
      style={portal && portalPosition ? { ...portalPosition, maxHeight: MAX_MENU_HEIGHT, overflowY: 'auto' } : undefined}
    >
      {header}
      {showSearch && (
        <div className="sticky top-0 z-10 bg-popover px-1 pb-1 pt-1">
          <input
            ref={searchInputRef}
            type="text"
            value={searchQuery}
            onChange={(event) => setSearchQuery(event.target.value)}
            placeholder={searchPlaceholder}
            aria-label={searchPlaceholder}
            className="h-8 w-full rounded-md border border-input bg-transparent px-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
          />
        </div>
      )}
      {filteredItems.length === 0 && showSearch ? (
        <p className="px-3 py-2 text-xs text-muted-foreground">{emptyText}</p>
      ) : (
        filteredItems.map((item) => {
        const Icon = item.icon;
        return (
          <React.Fragment key={item.key}>
            {item.showDividerBefore && <div className="mx-2 my-1 h-px bg-border" />}
            <button
              type="button"
              role="menuitem"
              disabled={item.disabled || item.loading}
              onClick={() => runItem(item)}
              className={cn(
                'flex w-full items-start gap-3 rounded-md px-3 py-2 text-left text-sm transition-colors',
                'focus:outline-none focus-visible:bg-accent',
                item.disabled || item.loading
                  ? 'cursor-not-allowed opacity-50'
                  : item.isDanger
                    ? 'text-red-600 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-950'
                    : 'hover:bg-accent',
              )}
            >
              {item.loading ? (
                <Loader2 className="mt-0.5 h-4 w-4 flex-shrink-0 animate-spin" />
              ) : (
                Icon && <Icon className="mt-0.5 h-4 w-4 flex-shrink-0" />
              )}
              <span className="min-w-0 flex-1">
                <span className="block font-medium leading-5">{item.label}</span>
                {item.description && (
                  <span className="mt-0.5 block text-xs leading-4 text-muted-foreground">
                    {item.description}
                  </span>
                )}
              </span>
            </button>
          </React.Fragment>
        );
        })
      )}
    </div>
  );

  return (
    // min-w-0 lets the trigger actually shrink (and truncate its label) when a
    // flex header runs out of room instead of overflowing the row.
    <div ref={rootRef} className={cn('relative inline-flex min-w-0', className)}>
      <Button
        ref={triggerRef}
        type="button"
        variant={variant}
        size={size}
        className={triggerClassName}
        disabled={disabled}
        aria-label={ariaLabel || label}
        aria-haspopup="menu"
        aria-expanded={isOpen}
        aria-controls={isOpen ? menuId : undefined}
        onClick={(event) => {
          focusMenuOnOpenRef.current = event.detail === 0;
          toggleMenu();
        }}
      >
        {TriggerIcon && <TriggerIcon className="h-4 w-4" />}
        {!iconOnly && (
          <>
            <span className="min-w-0 truncate">{label}</span>
            <ChevronDown className={cn('h-4 w-4 flex-shrink-0 transition-transform', isOpen && 'rotate-180')} />
          </>
        )}
      </Button>

      {portal && typeof document !== 'undefined' ? createPortal(menu, document.body) : menu}
    </div>
  );
}
