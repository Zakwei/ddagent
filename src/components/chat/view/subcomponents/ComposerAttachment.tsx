import { useEffect, useState } from 'react';
import { XIcon } from 'lucide-react';

import { ImageLightbox } from './ChatMessageImages';

interface ComposerAttachmentProps {
  file: File;
  onRemove: () => void;
  uploadProgress?: number;
  error?: string;
}

const formatFileSize = (size: number) => {
  if (size < 1024) return `${size} B`;
  if (size < 1024 * 1024) return `${Math.round(size / 1024)} KB`;
  return `${(size / (1024 * 1024)).toFixed(1)} MB`;
};

const ComposerAttachment = ({ file, onRemove, uploadProgress, error }: ComposerAttachmentProps) => {
  const [preview, setPreview] = useState<string | undefined>(undefined);
  const [expanded, setExpanded] = useState(false);
  const isImage = file.type.startsWith('image/');

  useEffect(() => {
    if (!isImage) {
      setPreview(undefined);
      return;
    }
    const url = URL.createObjectURL(file);
    setPreview(url);
    return () => URL.revokeObjectURL(url);
  }, [file, isImage]);

  return (
    <div className="oc-chip group relative max-w-full">
      {isImage ? (
        <button
          type="button"
          onClick={() => preview && setExpanded(true)}
          aria-label={`Expand ${file.name}`}
          className="flex flex-shrink-0 focus:outline-none"
        >
          {preview
            ? <img src={preview} alt={file.name} className="oc-chip-thumb cursor-zoom-in" />
            : <span className="oc-chip-thumb animate-pulse bg-muted" />}
        </button>
      ) : (
        <span className="oc-chip-kind">{file.type.split('/')[1]?.slice(0, 3).toUpperCase() || 'FILE'}</span>
      )}
      <span className="oc-chip-name" title={file.name}>{file.name}</span>
      <span className="oc-chip-size">{formatFileSize(file.size)}</span>
      {uploadProgress !== undefined && uploadProgress < 100 && (
        <span className="oc-chip-size">{uploadProgress}%</span>
      )}
      {error && <span className="oc-chip-error" title={error}>✕</span>}
      <button
        type="button"
        onClick={onRemove}
        className="oc-chip-x"
        aria-label={`Remove ${file.name}`}
      >
        <XIcon className="h-3 w-3" aria-hidden />
      </button>
      {expanded && preview && (
        <ImageLightbox src={preview} alt={file.name} onClose={() => setExpanded(false)} />
      )}
    </div>
  );
};

export default ComposerAttachment;
