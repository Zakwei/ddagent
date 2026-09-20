/**
 * cmdk's default filter is fuzzy (loose character-subsequence scoring), which
 * surfaces unrelated models — e.g. searching "chatgpt" also matched "Fable".
 * Require every whitespace-separated search token to appear as a literal
 * substring instead, so "claude 4.5" still matches "Anthropic Claude Haiku 4.5"
 * but "chatgpt" only matches models that actually contain it.
 *
 * Shared by the new-chat model dialog and the in-chat composer model menu so
 * both searches behave identically.
 */
export function matchesModelSearch(haystack: string, search: string): boolean {
  const value = haystack.toLowerCase();
  const tokens = search.toLowerCase().split(/\s+/).filter(Boolean);
  return tokens.every((token) => value.includes(token));
}
