# Lista zmian

Wszystkie istotne zmiany w ddagent są dokumentowane w tym miejscu.

Format opiera się na [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
a projekt stosuje [Semantic Versioning](https://semver.org/).

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <strong>Polski</strong> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.5.9] - 2026-09-25

Pierwsze publiczne wydanie open-source — **AGPL-3.0-only**.

### Nowości

- **Współpraca zespołowa** — współdzielone sesje, wiadomości rozgłaszane, skrzynka odbiorcza agenta, wspólna pamięć per projekt
- **Serwer MCP** — zewnętrzni klienci MCP (Claude Desktop, OpenClaw) mogą tworzyć zadania i wysyłać wiadomości do sesji przez `POST /mcp` ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Zdalne zatwierdzanie** — zatwierdzaj działania agenta z Telegrama lub Discorda ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Harmonogram** — harmonogramy cron dla uruchomień agenta z zapobieganiem uśpienia
- **Nazwane konta dostawców** — nadpisania zmiennych środowiskowych i poświadczeń per sesja
- **Wprowadzanie głosowe (STT)** — endpoint zgodny z Whisper w polu wiadomości
- **Worktree** — skrypty konfiguracji i uruchamiania per repozytorium z runnerem dev-serwera
- **Podgląd** — uwierzytelniony serwer proxy podglądu dev-serwera z tunelem WS
- **Aplikacja mobilna** — wyszukiwanie sesji, interaktywne powiadomienia push o zatwierdzeniach (FCM)
- `SECURITY.md` — polityka prywatnego zgłaszania luk w bezpieczeństwie

### Poprawki

- Błędy danych i wyświetlania w zakładce limitów
- Czat: kolejka offline i wersje robocze przetrwują przeładowania; stabilna pozycja przewijania przy ponownych pobieraniach
- Sesje: usunięte sesje nie pozostawiają już widm na innych klientach
- Kanban: wyścigi przy przydzielaniu i wycieki na tablicy agentów
- Mobilna: nieprzetworzony padding wysokości klawiatury, ActionSheet zastępuje alerty przepełnienia

## [0.5.8] - 2026-09-23

### Nowości

- `install.sh` — instalator serwera oparty na gicie (`--version`, `--dir`, `--port`, `--systemd`)
- Samodzielne i lokalne archiwa tarball serwera publikowane przy tagach `v*`

### Poprawki

- Mobilna klawiatura zasłaniająca pole wiadomości i treść pod paskiem nawigacji systemowej (Android)

## [0.5.7] - 2026-09-23

### Poprawki

- Buildy CI aplikacji desktopowej (flaga platformy pakietu, natywne rebuildy, timeouty smoke testów)
- Zduplikowane strumieniowane wiadomości asystenta w transkryptach czatu

## [0.5.6] - 2026-09-23

### Poprawki

- CI desktopa: niepodpisane buildy macOS przy braku sekretów Apple, staging pakietów scoped na Windows

## [0.5.5] - 2026-09-23

### Nowości

- **Aplikacja desktopowa (wersja zapoznawcza)** — launcher Electron dla lokalnych lub zdalnych serwerów, wbudowany backend, auto-update, buildy dmg/NSIS/AppImage/deb
- **Aplikacja mobilna (wersja zapoznawcza)** — towarzysz Expo/React Native: sesje, czat z wyborem modelu i poleceniami slash, terminal, pliki, WebView ustawień
- Wskaźnik nieprzeczytanych przy sesjach z nowym wynikiem; powiązanie tablicy zadań ↔ sesji
- Wyspy KaTeX i Mermaid na czacie

### Poprawki

- Obszary dotykowe i układy na mobilnych viewportach; dopracowanie palety poleceń, kanbana i ustawień

## [0.5.4] - 2026-09-21

### Nowości

- Przycisk restartu serwera z pełnoekranową nakładką postępu (Ustawienia → Informacje)
- Zlokalizowany changelog wydań GitHub w Ustawienia → Informacje
- Liczba działających sesji w tytule karty przeglądarki
- Skala osi Y i podpowiedzi po najechaniu na wykresie trendu zużycia

### Poprawki

- Autozapis ustawień uruchamiany przy otwieraniu okna modalnego; kompaktowy układ czatu w wielowierszowych podziałach

## [0.5.3] - 2026-09-21

### Poprawki

- Okno dostępnej aktualizacji ukryte za panelem bocznym (poprawka portalu)

## [0.5.2] - 2026-09-21

### Poprawki

- Sprawdzanie aktualizacji przekierowane przez serwer

## [0.5.1] - 2026-09-21

### Nowości

- Odznaka dostępnej aktualizacji z samoaktualizacją jednym kliknięciem
- Głos czytania na głos per sesja; wybór głosu przeniesiony do ustawień wyglądu

### Poprawki

- Baner czatu pokazuje rzeczywistego dostawcę sesji

## [0.5.0] - 2026-09-21

Pierwsze samodzielne wydanie **ddagent** — self-hosted interfejs webowy i mobilny dla agentów AI do kodowania.

### Najważniejsze funkcje

- **Sesje multi-agentowe** — Claude Code, Codex, Cursor CLI, OpenCode i Devin obok siebie, ze strumieniowaniem na żywo i wznawianiem
- **Układ workspace** — dzielone panele na czat, terminal, przeglądarkę i pliki
- **Eksplorator i edytor plików** — przeglądaj i edytuj workspace w interfejsie
- **Panel Git** — staging, commity, diffy, przełączanie gałęzi, zarządzanie worktrees
- **Tablica zadań** — kanban napędzany przez TaskMaster; generuj wykonywalne zadania z PRD-ów
- **Zarządzanie MCP** — dodawaj i synchronizuj serwery MCP między agentami
- **Przeglądarka umiejętności** — odkrywaj i zarządzaj umiejętnościami agentów
- **Limity i zużycie** — zużycie tokenów per agent i limity subskrypcji
- **Browser-use** — sesje przeglądarki sterowane przez agenta do badań i testów
- **Powiadomienia i TTS** — alerty i odpowiedzi czytane na głos
- **Piaskownice Docker** — eksperymentalne uruchomienia agentów izolowane hiperwizorem
- **Towarzysz desktopowy** — opcjonalna aplikacja Electron dla macOS/Windows
- **i18n** — 11 języków interfejsu, motywy ciemny i jasny

### CLI

- `ddagent` / `ddagent start` — uruchom serwer
- `ddagent status` — pokaż konfigurację i lokalizacje danych
- `ddagent version` / `ddagent help`
