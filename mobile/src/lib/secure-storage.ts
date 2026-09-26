/**
 * Credential keys that must never be written to the plaintext SQLite
 * localStorage shim — polyfills.ts routes them to expo-secure-store
 * (iOS Keychain / Android Keystore) instead (§3.4).
 */
export function isSecureStorageKey(key: string): boolean {
  return key.startsWith('auth-');
}
