/// <reference types="nativewind/types" />
// Vite's import.meta.env does not exist in RN — it evaluates to undefined,
// which makes IS_PLATFORM === false (OSS/token mode) — correct for mobile.
interface ImportMeta {
  env: Record<string, string | undefined>;
}
