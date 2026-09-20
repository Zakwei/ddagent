import React, { useEffect, useRef } from 'react';
import { ShieldAlertIcon, AlertTriangle, Check, CheckCheck, X } from 'lucide-react';

import type { PendingPermissionRequest } from '../../types/types';
import { buildClaudeToolPermissionEntry, formatToolInputForDisplay, extractAffectedFilePaths } from '../../utils/chatPermissions';
import { getClaudeSettings } from '../../utils/chatStorage';
import { getPermissionPanel, registerPermissionPanel } from '../../tools/configs/permissionPanelRegistry';
import { resolveToolName } from '../../tools/configs/toolConfigs';
import { AskUserQuestionPanel } from '../../tools/components/InteractiveRenderers';
import { triggerHapticFeedback } from '../../../../utils/haptics';
import {
  Confirmation,
  ConfirmationTitle,
  ConfirmationRequest,
  ConfirmationActions,
  ConfirmationAction,
  Button,
} from '../../../../shared/view/ui';

registerPermissionPanel('AskUserQuestion', AskUserQuestionPanel);

interface PermissionRequestsBannerProps {
  pendingPermissionRequests: PendingPermissionRequest[];
  handlePermissionDecision: (
    requestIds: string | string[],
    decision: { allow?: boolean; message?: string; rememberEntry?: string | null; updatedInput?: unknown },
  ) => void;
  handleGrantToolPermission: (suggestion: { entry: string; toolName: string }) => { success: boolean };
  provider: string;
}

export default function PermissionRequestsBanner({
  pendingPermissionRequests,
  handlePermissionDecision,
  handleGrantToolPermission,
  provider,
}: PermissionRequestsBannerProps) {
  // Filter out plan tool requests — they are handled inline by PlanDisplay
  const filteredRequests = pendingPermissionRequests.filter(
    (r) => r.toolName !== 'ExitPlanMode' && r.toolName !== 'exit_plan_mode'
  );

  const lastTriggeredIdsRef = useRef<string>('');
  useEffect(() => {
    const ids = filteredRequests.map((r) => r.requestId).join(',');
    if (ids && ids !== lastTriggeredIdsRef.current) {
      lastTriggeredIdsRef.current = ids;
      triggerHapticFeedback('permissionRequested');
    }
  }, [filteredRequests]);

  if (!filteredRequests.length) {
    return null;
  }

  return (
    <div className="sticky bottom-0 z-30 mb-3 space-y-2 rounded-xl border border-border/60 bg-background/95 p-2.5 shadow-lg backdrop-blur-md sm:relative sm:bottom-auto sm:border-0 sm:bg-transparent sm:p-0 sm:shadow-none sm:backdrop-blur-none">
      {filteredRequests.length > 1 && (
        <div className="flex flex-wrap items-center justify-between gap-2.5 rounded-lg border border-amber-500/30 bg-amber-500/10 p-2.5 backdrop-blur-sm sm:p-3">
          <div className="flex items-center gap-2">
            <span className="inline-flex min-h-[24px] items-center rounded-full bg-amber-500/20 px-2.5 py-0.5 text-xs font-semibold text-amber-700 dark:text-amber-300">
              {filteredRequests.length} queued
            </span>
            <span className="text-xs font-medium text-foreground">
              Permission requests pending
            </span>
          </div>
          <div className="flex w-full items-center gap-2 sm:w-auto">
            <Button
              variant="outline"
              className="min-h-[44px] flex-1 touch-manipulation border-destructive/30 text-destructive hover:bg-destructive/10 sm:flex-initial"
              onClick={() => {
                const allIds = filteredRequests.map((r) => r.requestId);
                handlePermissionDecision(allIds, { allow: false, message: 'User denied all tool use' });
              }}
            >
              <X className="mr-1.5 h-4 w-4 shrink-0" aria-hidden />
              Reject all
            </Button>
            <Button
              variant="default"
              className="min-h-[44px] flex-1 touch-manipulation bg-emerald-600 text-white shadow hover:bg-emerald-700 active:bg-emerald-800 dark:bg-emerald-600 dark:hover:bg-emerald-500 sm:flex-initial"
              onClick={() => {
                const allIds = filteredRequests.map((r) => r.requestId);
                handlePermissionDecision(allIds, { allow: true });
              }}
            >
              <CheckCheck className="mr-1.5 h-4 w-4 shrink-0" aria-hidden />
              Allow all
            </Button>
          </div>
        </div>
      )}

      {filteredRequests.map((request) => {
        // Provider runtimes report the same tool under different casings
        // (AskUserQuestion vs ask_user_question) — resolve the canonical
        // name so the interactive panel matches either spelling.
        const CustomPanel = getPermissionPanel(resolveToolName(request.toolName));
        if (CustomPanel) {
          return (
            <CustomPanel
              key={request.requestId}
              request={request}
              onDecision={handlePermissionDecision}
              provider={provider}
            />
          );
        }

        const rawInput = formatToolInputForDisplay(request.input);
        const affectedPaths = extractAffectedFilePaths(request.toolName, request.input);
        // "Remember" rules are a Claude-only concept (Bash(...) entries stored
        // in ddagent_claude_settings). Other providers get a plain allow —
        // formatting their tools as Claude rules would silently do nothing.
        const isClaudeProvider = provider === 'claude';
        const permissionEntry = isClaudeProvider
          ? buildClaudeToolPermissionEntry(request.toolName, rawInput)
          : null;
        const settings = isClaudeProvider ? getClaudeSettings() : null;
        const alreadyAllowed = permissionEntry
          ? (settings?.allowedTools.includes(permissionEntry) ?? false)
          : false;
        const rememberLabel = alreadyAllowed ? 'Allow (saved)' : 'Allow & remember';
        const matchingRequestIds = permissionEntry
          ? pendingPermissionRequests
              .filter(
                (item) =>
                  buildClaudeToolPermissionEntry(item.toolName, formatToolInputForDisplay(item.input)) === permissionEntry,
              )
              .map((item) => item.requestId)
          : [request.requestId];

        return (
          <Confirmation key={request.requestId} approval="pending" className="border-border/80 bg-card/95 shadow-sm backdrop-blur-sm">
            <ConfirmationTitle className="flex items-start gap-3">
              <ShieldAlertIcon className="mt-0.5 h-4 w-4 shrink-0 text-amber-500 dark:text-amber-400" />
              <ConfirmationRequest>
                <div>
                  <span className="font-medium text-foreground">Permission required</span>
                  <span className="ml-2 text-muted-foreground">
                    Tool: <code className="rounded bg-muted px-1.5 py-0.5 font-mono text-xs">{request.toolName}</code>
                  </span>
                </div>
                {affectedPaths.length > 0 && (
                  <div className="mt-1 flex flex-wrap items-center gap-1.5 text-xs text-amber-700 dark:text-amber-400">
                    <AlertTriangle className="h-3.5 w-3.5 shrink-0" aria-hidden />
                    <span>
                      Touches {affectedPaths.length} file{affectedPaths.length === 1 ? '' : 's'}:
                    </span>
                    {affectedPaths.slice(0, 5).map((path) => (
                      <code key={path} className="max-w-72 truncate rounded bg-amber-100 px-1 py-0.5 text-[11px] dark:bg-amber-900/30">
                        {path}
                      </code>
                    ))}
                    {affectedPaths.length > 5 && (
                      <span className="text-[11px]">+{affectedPaths.length - 5} more</span>
                    )}
                  </div>
                )}
                {permissionEntry && (
                  <div className="mt-1 text-xs text-muted-foreground">
                    Allow rule: <code className="rounded bg-muted px-1 py-0.5 text-xs">{permissionEntry}</code>
                  </div>
                )}
              </ConfirmationRequest>
            </ConfirmationTitle>

            {rawInput && (
              <details className="mt-2">
                <summary className="cursor-pointer text-xs text-muted-foreground hover:text-foreground">
                  View tool input
                </summary>
                <pre className="mt-2 max-h-40 overflow-auto whitespace-pre-wrap rounded-md border bg-muted/50 p-2 text-xs text-muted-foreground">
                  {rawInput}
                </pre>
              </details>
            )}

            <ConfirmationActions className="flex w-full flex-wrap items-center justify-end gap-2 sm:w-auto">
              <ConfirmationAction
                variant="outline"
                className="min-h-[44px] flex-1 touch-manipulation border-destructive/30 bg-destructive/5 text-destructive hover:bg-destructive/10 active:bg-destructive/20 sm:flex-initial"
                onClick={() => handlePermissionDecision(request.requestId, { allow: false, message: 'User denied tool use' })}
              >
                <X className="mr-1.5 h-4 w-4 shrink-0" aria-hidden />
                Reject
              </ConfirmationAction>
              {isClaudeProvider && (
                <ConfirmationAction
                  variant="outline"
                  className="min-h-[44px] flex-1 touch-manipulation border-primary/40 text-primary hover:bg-primary/10 active:bg-primary/20 sm:flex-initial"
                  onClick={() => {
                    if (permissionEntry && !alreadyAllowed) {
                      handleGrantToolPermission({ entry: permissionEntry, toolName: request.toolName });
                    }
                    handlePermissionDecision(matchingRequestIds, { allow: true, rememberEntry: permissionEntry });
                  }}
                  disabled={!permissionEntry}
                >
                  <CheckCheck className="mr-1.5 h-4 w-4 shrink-0" aria-hidden />
                  {rememberLabel}
                </ConfirmationAction>
              )}
              <ConfirmationAction
                variant="default"
                className="min-h-[44px] flex-1 touch-manipulation bg-emerald-600 text-white shadow hover:bg-emerald-700 active:bg-emerald-800 dark:bg-emerald-600 dark:hover:bg-emerald-500 sm:flex-initial"
                onClick={() => handlePermissionDecision(request.requestId, { allow: true })}
              >
                <Check className="mr-1.5 h-4 w-4 shrink-0" aria-hidden />
                Allow once
              </ConfirmationAction>
            </ConfirmationActions>
          </Confirmation>
        );
      })}
    </div>
  );
}
