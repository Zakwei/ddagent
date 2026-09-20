import { AlertTriangle, Save } from 'lucide-react';

import { Button, Dialog, DialogContent, DialogTitle } from '../../../shared/view/ui';

type OverwriteConfirmModalProps = {
  isOpen: boolean;
  fileName: string;
  saving: boolean;
  onCancel: () => void;
  onConfirm: () => void;
};

export default function OverwriteConfirmModal({
  isOpen,
  fileName,
  saving,
  onCancel,
  onConfirm,
}: OverwriteConfirmModalProps) {
  return (
    // Shared Dialog primitives provide role="dialog"/aria-modal, a Tab focus
    // trap, Escape and backdrop-click dismissal, and autofocus on open.
    <Dialog
      open={isOpen}
      onOpenChange={(nextOpen) => {
        if (!nextOpen) onCancel();
      }}
    >
      <DialogContent wrapperClassName="z-[300]" className="max-w-md border-gray-200 bg-white dark:border-gray-700 dark:bg-gray-800">
        <div className="p-6">
          <div className="mb-4 flex items-center">
            <div className="mr-3 rounded-full bg-yellow-100 p-2 dark:bg-yellow-900">
              <AlertTriangle className="h-5 w-5 text-yellow-600 dark:text-yellow-400" />
            </div>
            <DialogTitle className="not-sr-only text-lg font-semibold text-gray-900 dark:text-white">
              File Already Exists
            </DialogTitle>
          </div>

          <p className="mb-6 text-sm text-gray-600 dark:text-gray-400">
            A PRD named "{fileName}" already exists. Do you want to overwrite it?
          </p>

          <div className="flex justify-end gap-3">
            <Button
              variant="outline"
              onClick={onCancel}
              disabled={saving}
              className="border-gray-300 bg-white text-gray-700 hover:bg-gray-50 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600"
            >
              Cancel
            </Button>
            <Button
              onClick={onConfirm}
              disabled={saving}
              className="flex items-center gap-2 bg-yellow-600 text-white hover:bg-yellow-700 disabled:opacity-50"
            >
              <Save className="h-4 w-4" />
              <span>{saving ? 'Saving...' : 'Overwrite'}</span>
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
