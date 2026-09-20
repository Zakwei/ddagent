export const isHttpUrl = (value: string | null | undefined): value is string =>
  !!value && /^https?:\/\//i.test(value);

export const normalizeInput = (value: string): string | null => {
  const trimmed = value.trim();
  if (!trimmed) return null;
  if (/^https?:\/\//i.test(trimmed)) return trimmed;
  if (/^[\w-]+(\.[\w-]+)+([/?#].*)?$/.test(trimmed)) return `https://${trimmed}`;
  return null;
};
