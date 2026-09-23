import { useCallback, useState } from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';
import { Check, UserCircle2 } from 'lucide-react';

import type { ProviderAccount } from '../../../../hooks/useProviderAccounts';
import { useComposerMenuAnchor } from '../../hooks/useComposerMenuAnchor';

import {
  ComposerMenuHeading,
  ComposerMenuItem,
  ComposerMenuSeparator,
  ComposerMenuSurface,
} from './ComposerMenuPrimitives';

interface ComposerAccountMenuProps {
  /** Accounts for the active provider; empty renders nothing. */
  accounts: ProviderAccount[];
  accountId: string | null;
  onSelectAccount: (accountId: string | null) => void;
}

/**
 * New-session account picker: lets the user launch the provider CLI under one
 * of the named credential sets configured in Settings → Agents. Only rendered
 * before the session exists — account is pinned at creation time.
 */
export default function ComposerAccountMenu({
  accounts,
  accountId,
  onSelectAccount,
}: ComposerAccountMenuProps) {
  const { t } = useTranslation('chat');
  const [isOpen, setIsOpen] = useState(false);
  const close = useCallback(() => setIsOpen(false), []);
  const { triggerRef, menuRef, anchor, updateAnchor } = useComposerMenuAnchor(isOpen, close);

  if (accounts.length === 0) {
    return null;
  }

  const selected = accounts.find((account) => account.id === accountId) ?? null;
  const defaultAccount = accounts.find((account) => account.isDefault) ?? null;
  const effective = selected ?? defaultAccount;
  const triggerLabel = effective?.label ?? t('composer.accountDefault', { defaultValue: 'Default account' });
  const ariaLabel = t('composer.accountMenu', { defaultValue: 'Select account' });

  return (
    <>
      <button
        ref={triggerRef}
        type="button"
        onClick={() => {
          updateAnchor();
          setIsOpen((current) => !current);
        }}
        className="flex h-8 max-w-36 shrink-0 touch-manipulation items-center gap-1 rounded-lg border border-border/60 bg-muted/40 px-2 text-xs font-medium text-foreground transition-colors hover:bg-muted sm:max-w-44 [@media(hover:none)_and_(pointer:coarse)]:h-11"
        aria-haspopup="menu"
        aria-expanded={isOpen}
        aria-label={ariaLabel}
        title={ariaLabel}
      >
        <UserCircle2 className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
        <span className="truncate">{triggerLabel}</span>
      </button>

      {isOpen && anchor && createPortal(
        <ComposerMenuSurface anchor={anchor} menuRef={menuRef} ariaLabel={ariaLabel}>
          <ComposerMenuHeading>
            {t('composer.account', { defaultValue: 'Account' })}
          </ComposerMenuHeading>
          <ComposerMenuItem
            label={t('composer.accountAuto', { defaultValue: 'Auto (default)' })}
            description={defaultAccount?.label}
            isSelected={accountId === null}
            onSelect={() => {
              onSelectAccount(null);
              setIsOpen(false);
            }}
          />
          <ComposerMenuSeparator />
          {accounts.map((account) => (
            <ComposerMenuItem
              key={account.id}
              label={account.label}
              description={account.isDefault ? t('composer.accountIsDefault', { defaultValue: 'Default' }) : undefined}
              isSelected={account.id === accountId}
              onSelect={() => {
                onSelectAccount(account.id);
                setIsOpen(false);
              }}
              trailing={account.id === accountId ? <Check className="h-3.5 w-3.5 text-foreground" /> : undefined}
            />
          ))}
        </ComposerMenuSurface>,
        document.body,
      )}
    </>
  );
}
