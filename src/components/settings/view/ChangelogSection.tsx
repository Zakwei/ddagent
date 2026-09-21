import { useEffect, useState } from 'react';
import { ExternalLink, Loader2, ScrollText } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import { useTranslation } from 'react-i18next';
import remarkGfm from 'remark-gfm';

import { version as currentVersion } from '../../../../package.json';
import { compareVersions } from '../../../hooks/useVersionCheck';
import { authenticatedFetch } from '../../../utils/api';

type ChangelogRelease = {
  tagName: string;
  name: string;
  body: string;
  htmlUrl: string;
  publishedAt?: string;
};

const LANG_SECTION_PATTERN = /<!--\s*lang:([a-zA-Z-]+)\s*-->/g;

/**
 * Release notes carry per-language sections marked with `<!-- lang:xx -->`.
 * Pick the section matching the UI language (with `en` fallback); bodies
 * without markers are shown verbatim.
 */
function localizedNotes(body: string, language: string): string {
  const parts = body.split(LANG_SECTION_PATTERN);
  if (parts.length < 3) {
    return body.trim();
  }
  const byLang: Record<string, string> = {};
  for (let i = 1; i + 1 < parts.length; i += 2) {
    byLang[parts[i].toLowerCase()] = parts[i + 1].trim();
  }
  const lang = language.toLowerCase();
  return byLang[lang] || byLang[lang.split('-')[0]] || byLang.en || body.trim();
}

/** Settings → About: browsable changelog fed by GitHub releases. */
export default function ChangelogSection() {
  const { t, i18n } = useTranslation('settings');
  const [releases, setReleases] = useState<ChangelogRelease[] | null>(null);

  useEffect(() => {
    let cancelled = false;
    authenticatedFetch('/api/system/releases')
      .then((response) => response.json())
      .then((data) => {
        if (!cancelled) {
          setReleases(Array.isArray(data.releases) ? data.releases : []);
        }
      })
      .catch(() => {
        if (!cancelled) {
          setReleases([]);
        }
      });
    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <div className="border-t border-border/50 pt-6">
      <h3 className="mb-3 flex items-center gap-2 text-sm font-medium text-foreground">
        <ScrollText className="h-4 w-4 text-muted-foreground" />
        {t('changelog.title', 'Changelog')}
      </h3>

      {releases === null ? (
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <Loader2 className="h-3.5 w-3.5 animate-spin" />
          {t('changelog.loading', 'Loading…')}
        </div>
      ) : releases.length === 0 ? (
        <p className="text-xs text-muted-foreground">
          {t('changelog.empty', 'No releases to show')}
        </p>
      ) : (
        <div className="scrollbar-thin max-h-96 space-y-3 overflow-y-auto overscroll-contain pr-1">
          {releases.map((release) => {
            const tag = release.tagName.replace(/^v/, '');
            const isCurrent = compareVersions(tag, currentVersion) === 0;
            const isNewer = compareVersions(tag, currentVersion) > 0;
            return (
              <div
                key={release.tagName}
                className="rounded-lg border border-border/60 bg-background/60 p-3"
              >
                <div className="flex items-center gap-2">
                  <a
                    href={release.htmlUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center gap-1 text-sm font-medium text-foreground transition-colors hover:text-primary"
                  >
                    {release.tagName}
                    <ExternalLink className="h-3 w-3" />
                  </a>
                  {isCurrent && (
                    <span className="rounded-full bg-muted px-1.5 py-0.5 text-[10px] font-medium text-muted-foreground">
                      {t('changelog.current', 'current')}
                    </span>
                  )}
                  {isNewer && (
                    <span className="rounded-full bg-emerald-500/10 px-1.5 py-0.5 text-[10px] font-medium text-emerald-600 dark:text-emerald-400">
                      {t('changelog.new', 'new')}
                    </span>
                  )}
                  {release.publishedAt && (
                    <span className="ml-auto text-[11px] text-muted-foreground">
                      {new Date(release.publishedAt).toLocaleDateString(i18n.language)}
                    </span>
                  )}
                </div>
                <div className="prose-xs prose mt-2 max-w-none text-xs text-muted-foreground dark:prose-invert [&_li]:my-0.5 [&_ul]:my-1 [&_ul]:pl-4">
                  <ReactMarkdown remarkPlugins={[remarkGfm]}>
                    {localizedNotes(release.body, i18n.language)}
                  </ReactMarkdown>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
