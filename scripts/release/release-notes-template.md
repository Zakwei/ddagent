<!--
  GitHub draft-release body template — the desktop-release workflow
  (.github/workflows/desktop-release.yml) runs electron-builder with
  `--publish onTag`; the staged build config points
  build.releaseInfo.releaseNotesFile at this file, so every draft release
  created on a tag starts with this body.

  AGENTS.md requires per-language release notes split by
  `<!-- lang:<code> -->` markers — the Settings → About changelog
  (src/components/settings/view/ChangelogSection.tsx) renders only the
  section matching the active UI language, `en` is the fallback. All 12 UI
  locales are below; replace the TODO lines in EVERY section, then publish
  the draft. (This header comment never renders — it sits before the first
  lang marker and markdown comments are invisible anyway.)
-->
<!-- lang:en -->
### What's new
- TODO

### Bug fixes
- TODO

<!-- lang:pl -->
### Co nowego
- TODO

### Poprawki
- TODO

<!-- lang:de -->
### Neuigkeiten
- TODO

### Fehlerbehebungen
- TODO

<!-- lang:es -->
### Novedades
- TODO

### Correcciones
- TODO

<!-- lang:fr -->
### Nouveautés
- TODO

### Corrections
- TODO

<!-- lang:it -->
### Novità
- TODO

### Correzioni
- TODO

<!-- lang:ja -->
### 新機能
- TODO

### 修正
- TODO

<!-- lang:ko -->
### 새로운 기능
- TODO

### 수정 사항
- TODO

<!-- lang:ru -->
### Новое
- TODO

### Исправления
- TODO

<!-- lang:tr -->
### Yenilikler
- TODO

### Düzeltmeler
- TODO

<!-- lang:zh-CN -->
### 新功能
- TODO

### 修复
- TODO

<!-- lang:zh-TW -->
### 新功能
- TODO

### 修復
- TODO
