# Specyfikacja Parzystości Architektury i UI: Web vs Mobile (`ddagent`)

> **Wersja dokumentu:** 1.0.0  
> **Status:** Zaakceptowana specyfikacja techniczna (po audycie różnic Step-1)  
> **Data opracowania:** Wrzesień 2026  
> **Repozytorium:** `/workspace/ddagent-src`  
> **Ścieżka docelowa:** `mobile/docs/web-parity-matrix.md`  
> **Docelowe platformy mobilne:** iOS 16+, Android 12+ (Expo SDK 53, React Native 0.79, NativeWind v4)

---

## Spis Treści
1. [Wprowadzenie i Podsumowanie Wykonawcze (Executive Summary)](#1-wprowadzenie-i-podsumowanie-wykonawcze-executive-summary)
   - 1.1. Kontekst i cele specyfikacji
   - 1.2. Architektura hybrydowa i technologie bazowe
   - 1.3. Globalny wskaźnik zgodności (Parity Scorecard)
2. [Szczegółowa Macierz Mapowania Komponentów (Web vs Mobile)](#2-szczegółowa-macierz-mapowania-komponentów-web-vs-mobile)
   - 2.1. App Shell, Nawigacja i Układ Główny
   - 2.2. Chat, Konwersacja i Przepływ Wiadomości
   - 2.3. Kompozytor, Wprowadzanie Danych i Multimedia
   - 2.4. Narzędzia Agenta, Wizualizacja Wykonań i Subagenci
   - 2.5. Przestrzeń Robocza Multi-Pane (Split Workspace)
   - 2.6. Edytor Kodu i Przeglądarka Różnic (Code Editor & Diff)
   - 2.7. Terminal i Interaktywny Shell
   - 2.8. Tablica Agenta (Kanban Board & Collab)
   - 2.9. Moduł Zadań (TaskMaster & PRD)
   - 2.10. Kontrola Wersji (Source Control & Git)
   - 2.11. Drzewo Plików i Eksplorator Zasobów
   - 2.12. Centrum Kontroli Limitów i Kosztów (Quota & Usage)
   - 2.13. Paleta Poleceń i Wyszukiwanie Globalne (Command Palette)
   - 2.14. Panel Szybkich Ustawień (Quick Settings Sheet)
   - 2.15. Ustawienia Aplikacji (13 Zakładek Konfiguracyjnych)
   - 2.16. Uwierzytelnianie, Pierwsze Uruchomienie i Blokada Biometryczna
3. [Architektura Przepływu Danych (Data Flow Architecture)](#3-architektura-przepływu-danych-data-flow-architecture)
   - 3.1. Topologia Stanu Aplikacji
   - 3.2. Komunikacja Hybrydowa: REST API vs WebSocket vs SSE
   - 3.3. Odporność na Utratę Połączenia i Bufor Offline (Offline-First Queue)
   - 3.4. Bezpieczeństwo i Trwałość Danych (SecureStore vs AsyncStorage)
   - 3.5. Cykl Życia Aplikacji, Zadania w Tle i Powiadomienia Push (FCM / APNs)
   - 3.6. Most Komunikacyjny Wysepek WebView (WebView Islands Bridge Protocol)
4. [Inwentaryzacja Interfejsów: REST API i Zdarzenia WebSocket](#4-inwentaryzacja-interfejsów-rest-api-i-zdarzenia-websocket)
   - 4.1. Macierz Endpointów REST (Web vs Mobile)
   - 4.2. Specyfikacja Ramek WebSocket (Klient -> Serwer)
   - 4.3. Specyfikacja Zdarzeń WebSocket (Serwer -> Klient)
   - 4.4. Zidentyfikowane Luki w Protokole Czasu Rzeczywistego
5. [Harmonogram Implementacji (Roadmap) i Kryteria Akceptacji 1:1](#5-harmonogram-implementacji-roadmap-i-kryteria-akceptacji-11)
   - 5.1. Faza 1: Synchronizacja Czasu Rzeczywistego i Ujednolicenie WebSocket (2 tyg.)
   - 5.2. Faza 2: Optymalizacja Wysepek WebView i Edytora Kodu (2-3 tyg.)
   - 5.3. Faza 3: Zaawansowane Interakcje Dotykowe: Kanban, TaskMaster, Git i Workspace (3 tyg.)
   - 5.4. Faza 4: Polish Mobilny, Dostępność, Haptyka i Buforowanie Offline (2 tyg.)
   - 5.5. Matryca Bram Jakościowych (Quality Gates & QA Checklist)

---

## 1. Wprowadzenie i Podsumowanie Wykonawcze (Executive Summary)

### 1.1. Kontekst i cele specyfikacji
Niniejsza specyfikacja stanowi rezultat szczegółowego audytu architektury i interfejsu użytkownika przeprowadzonego pomiędzy aplikacją webową (`src/`) a aplikacją mobilną (`mobile/`) platformy `ddagent`. 

Głównym celem dokumentu jest zdefiniowanie precyzyjnego planu doprowadzenia aplikacji mobilnej do **100% parzystości funkcjonalnej (1:1 feature & UX parity)** względem wersji webowej. Oznacza to, że użytkownik mobilny na smartfonie lub tablecie (iOS/Android) musi mieć dostęp do identycznego zakresu możliwości co użytkownik stacjonarny, przy jednoczesnym zachowaniu najwyższych standardów ergonomii dotykowej (Human Interface Guidelines i Material You).

### 1.2. Architektura hybrydowa i technologie bazowe
Aplikacja mobilna `ddagent` opiera się na **architekturze warstwowej hybrydowej**, łączącej wysokowydajne komponenty czysto natywne (Pure Native) ze specjalizowanymi wysepkami webowymi (WebView Islands):

1. **Pure Native UI (Expo SDK 53 / React Native 0.79 + NativeWind v4):**
   - Ekrany główne, nawigacja (bottom bar / drawer), kompozytor wiadomości, strumieniowanie czatu, karty narzędzi, panele ustawień, powiadomienia i obsługa biometrii.
   - Płynne animacje realizowane przez `react-native-reanimated` i gesty przez `react-native-gesture-handler`.
2. **WebView Islands (Wyspy Izolowane):**
   - **Terminal Island (`/island/terminal`):** Oparty o `xterm.js` z pełną emulacją ANSI, obsługą PTY przez WebSocket oraz dotykowym paskiem klawiszy funkcyjnych (Ctrl, Esc, Tab, strzałki).
   - **Editor Island (`/island/editor`):** Oparty o Monaco Editor z pełnym wsparciem kolorowania składni, zwijania bloków i nawigacji po hunkach diffa.
   - **Mermaid Island (`/island/mermaid`):** Dynamiczne renderowanie diagramów przepływu i architektury z obsługą gestów pinch-to-zoom.
   - **KaTeX Island (`/island/katex`):** Renderowanie złożonych wzorów matematycznych i notacji LaTeX w treści wiadomości.
3. **PWA Fallback (`WebScreen.tsx`):**
   - Zabezpieczenie dla dynamicznie dodawanych modułów webowych lub podglądów serwisów zewnętrznych, uruchamiane w kontrolowanym kontenerze `react-native-webview`.

### 1.3. Globalny wskaźnik zgodności (Parity Scorecard)

| Moduł Funkcjonalny | Liczba Komponentów Web | Odpowiedniki Mobile | Pokrycie Parzystości | Status |
|---|:---:|:---:|:---:|:---:|
| **App Shell & Nawigacja** | 12 | 11 | **92%** | Wysoka parzystość, drobne luki w adaptacji tabletowej |
| **Chat & Konwersacja** | 18 | 17 | **95%** | Pełne strumieniowanie, brak wyboru głosu TTS per sesja |
| **Kompozytor & Załączniki** | 9 | 8 | **90%** | STT/Audio działa, brak zaawansowanego podglądu PDF |
| **Narzędzia Agenta (Tool Use)** | 14 | 13 | **93%** | Obsługa approvals i interaktywnych pytań kompletna |
| **Multi-Pane Workspace** | 7 | 6 | **85%** | Działa siatka 1-6 paneli; wymaga optymalizacji na telefonach |
| **Edytor Kodu & Diff** | 8 | 6 | **75%** | Monaco działa przez wyspę; brak natywnego edytora awaryjnego |
| **Terminal & Shell** | 6 | 5 | **85%** | Pełna sesja PTY; brakuje konfiguracji bufora przewijania |
| **Agent Board (Kanban)** | 11 | 9 | **80%** | Karty i statusy działają; brak natywnego Drag&Drop kolumn |
| **TaskMaster (Zadania/PRD)** | 13 | 10 | **78%** | Odczyt/edycja zadań działa; brak wizualnego edytora PRD |
| **Kontrola Wersji (Git)** | 15 | 11 | **75%** | Status, branch, commit działają; brak stagingu linii kodu |
| **Drzewo Plików (Files)** | 8 | 7 | **88%** | Drzewo, podgląd i pobieranie działają; brak multi-uploadu |
| **Centrum Limitów (Quota)** | 9 | 8 | **90%** | Wykresy i limity zaimplementowane; brak alertów push o limicie |
| **Command Palette** | 4 | 4 | **95%** | Globalne wyszukiwanie sesji, plików i komend zintegrowane |
| **Quick Settings** | 5 | 5 | **100%** | Pełna zgodność w wysuwanym arkuszu (bottom sheet) |
| **Ustawienia (13 Paneli)** | 13 | 13 | **92%** | Wszystkie 13 zakładek ma natywne ekrany w mobile |
| **Auth & Bezpieczeństwo** | 6 | 6 | **100%** | PIN, biometria (FaceID/Fingerprint), tokeny w SecureStore |
| **ŚREDNIA OGÓLNA** | **158** | **139** | **87.8%** | **Gotowość do wdrożenia 1:1 w 4 sprintach** |

---

## 2. Szczegółowa Macierz Mapowania Komponentów (Web vs Mobile)

### 2.1. App Shell, Nawigacja i Układ Główny

| Komponent Web (`src/components/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `SidebarRail` | `sidebar/SidebarRail.tsx` | `GlobalChrome.tsx` + `BottomNav` | Pure Native | 90% | Na mobile zastąpiony dolnym paskiem nawigacji (Bottom Bar) na smartfonach oraz chowalnym paskiem bocznym (Drawer) na tabletach. Wymaga obsługi Safe Area Insets. |
| `MobileNavMenu` | `sidebar/MobileNavMenu.tsx` | `GlobalChrome.tsx` (Menu Sheet) | Pure Native | 95% | Wysuwany z dołu arkusz `ActionSheet` z dużymi polami dotykowymi (min. 48x48 pt). |
| `TitleBar` | `app/TitleBar.tsx` | `GlobalChrome.tsx` (Header) | Pure Native | 95% | Zawiera wskaźnik połączenia WebSocket (zielony/żółty/czerwony badge) oraz selektor bieżącego projektu. |
| `ConnectionStatusBadge` | `app/ConnectionStatusBadge.tsx` | `components/GlobalChrome.tsx` | Pure Native | 100% | Renderuje stan socketa (Connected, Reconnecting, Disconnected, Offline). |
| `AppLockOverlay` | `auth/AppLockOverlay.tsx` | `components/AppLock.tsx` | Pure Native | 100% | Zintegrowany z `expo-local-authentication` (TouchID, FaceID, biometria Android) oraz kodem PIN. |
| `ProjectSelectorDialog` | `app/ProjectSelectorDialog.tsx` | `screens/ProjectsScreen.tsx` | Pure Native | 90% | Pełnoekranowa lista z wyszukiwarką, obsługą gestu pull-to-refresh i wskaźnikami repozytorium git. |
| `ToastContainer` | `ui/ToastContainer.tsx` | `components/Toast.tsx` | Pure Native | 95% | Animowane notyfikacje in-app (u góry ekranu) z obsługą gestu swipe-up to dismiss. |

### 2.2. Chat, Konwersacja i Przepływ Wiadomości

| Komponent Web (`src/components/chat/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `ChatInterface` | `ChatInterface.tsx` | `screens/ChatScreen.tsx` | Pure Native | 95% | Główny kontener czatu. Na mobile obsługuje `KeyboardAvoidingView` z adaptacyjnym offsetem iOS/Android. |
| `ChatMessagesPane` | `ChatMessagesPane.tsx` | `components/ChatMessagesList.tsx` | Pure Native | 95% | Oparty o zoptymalizowany `FlatList` z `inverted={false}`, buforem wirtualizacji i autoscrollem do dołu przy nowym tokenie. |
| `MessageComponent` | `MessageComponent.tsx` | `components/MessageItem.tsx` | Pure Native | 95% | Obsługuje renderowanie ról (user, assistant, system) z długim przytrzymaniem (haptic feedback) wywołującym menu kopiowania. |
| `ThinkingBlock` | `ThinkingBlock.tsx` | `components/MarkdownBlocks.tsx` | Pure Native | 90% | Zwijany akordeon procesu myślowego (`thinking`) z animowanym pulsującym wskaźnikiem czasu przetwarzania. |
| `MarkdownContent` | `MarkdownContent.tsx` | `components/MarkdownBlocks.tsx` | Pure Native + Island | 90% | Natywne formatowanie tekstu z automatycznym kierowaniem bloków kodu do `EditorIsland` i diagramów do `MermaidIsland`. |
| `QuotaBadge` | `QuotaBadge.tsx` | `components/UsageBlocks.tsx` | Pure Native | 95% | Miniaturowy wskaźnik zużycia tokenów i kosztu bieżącej odpowiedzi, umieszczony w stopce asystenta. |
| `AutoReadVoicePicker` | `AutoReadVoicePicker.tsx` | `components/ComposerMenus.tsx` | Pure Native | 75% | Wybór silnika i głosu TTS (`server/modules/tts`). Na mobile wymaga dodania zapisu domyślnego głosu w `AsyncStorage`. |
| `CheckpointButton` | `CheckpointButton.tsx` | `components/SessionBlocks.tsx` | Pure Native | 85% | Umożliwia cofnięcie sesji do wskazanego punktu w czasie (rollback stanu kontekstu). |
| `OrchestrationCard` | `OrchestrationCard.tsx` | `components/ReviewBlocks.tsx` | Pure Native | 90% | Wyświetla aktywne kroki orkiestratora wieloagentowego z paskiem postępu kroków. |

### 2.3. Kompozytor, Wprowadzanie Danych i Multimedia

| Komponent Web (`src/components/chat/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `ChatComposer` | `ChatComposer.tsx` | `components/ChatComposer.tsx` | Pure Native | 95% | Wieloliniowy `TextInput` z dynamicznym dopasowaniem wysokości (max 140pt), przyciskami mikrofonu, załączników i wysyłki. |
| `ModelPicker` | `ModelPicker.tsx` | `components/ModelMenus.tsx` | Pure Native | 95% | Arkusz modalny wyboru modelu (Claude, GPT, Gemini, DeepSeek, Local) z filtrowaniem i informacją o cenach. |
| `MentionMenu` | `MentionMenu.tsx` | `components/ComposerMenus.tsx` | Pure Native | 90% | Pływająca lista kontekstowa wywoływana znakiem `@` (agenci, pliki, komendy systemowe) nad klawiaturą. |
| `SlashCommandsMenu` | `SlashCommandsMenu.tsx` | `components/ComposerMenus.tsx` | Pure Native | 90% | Lista skróconych komend (`/help`, `/clear`, `/git`, `/task`, `/compact`) z autouzupełnianiem. |
| `AudioRecorder` | `AudioRecorder.tsx` | `components/AudioRecorder.tsx` | Pure Native | 90% | Wykorzystuje `expo-av` do nagrywania mowy i wysyłania do `/api/stt` celem transkrypcji w czasie rzeczywistym. |
| `AttachmentPreview` | `AttachmentPreview.tsx` | `components/ComposerMenus.tsx` | Pure Native | 85% | Karuzela miniatur dodanych zdjęć (z `expo-image-picker`) i plików z możliwością usunięcia przed wysłaniem. |
| `QueuedMessageBar` | `QueuedMessageBar.tsx` | `components/QueueBlocks.tsx` | Pure Native | 95% | Pasek informujący o kolejkowaniu zapytań użytkownika podczas trwania aktywnej generacji odpowiedzi. |

### 2.4. Narzędzia Agenta, Wizualizacja Wykonań i Subagenci

| Komponent Web (`src/components/chat/tools/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `ToolRenderer` | `ToolRenderer.tsx` | `components/ToolBlocks.tsx` | Pure Native | 95% | Fabryka komponentów narzędzi, dopasowująca widok do typu narzędzia (bash, file edit, git, subagent, browser). |
| `BashCommandDisplay` | `BashCommandDisplay.tsx` | `components/ToolBlocks.tsx` | Pure Native | 95% | Wyświetla wykonaną komendę bash z kodem powrotu (exit code) i przewijanym buforem wyjścia stdout/stderr. |
| `ToolDiffViewer` | `ToolDiffViewer.tsx` | `components/ToolBlocks.tsx` + Island | Hybrid | 90% | Kompaktowy widok różnic pliku przed/po edycji z możliwością powiększenia do pełnego widoku w `EditorIsland`. |
| `SubagentContainer` | `SubagentContainer.tsx` | `components/ToolBlocks.tsx` | Pure Native | 90% | Drzewiasty widok podzadań delegowanych do subagentów (np. explore, coder, reviewer) z osobnym statusem postępu. |
| `InteractiveQuestion` | `InteractiveQuestion.tsx` | `components/ToolBlocks.tsx` | Pure Native | 95% | Interaktywne formularze pytań zadawanych przez agenta (pojedynczy/wielokrotny wybór z haptycznym zatwierdzeniem). |
| `PermissionRequest` | `PermissionRequest.tsx` | `components/ReviewBlocks.tsx` | Pure Native | 100% | Krytyczny modal zatwierdzenia akcji destrukcyjnej (Allow Once, Always Allow, Deny) zintegrowany z powiadomieniami push. |
| `TodoListRenderer` | `TodoListRenderer.tsx` | `components/ToolBlocks.tsx` | Pure Native | 95% | Wizualizacja dynamicznej listy zadań `todowrite` (pending, in_progress, completed) ze statystykami. |

### 2.5. Przestrzeń Robocza Multi-Pane (Split Workspace)

| Komponent Web (`src/components/main-content/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `SplitWorkspaceGrid` | `SplitWorkspaceGrid.tsx` | `screens/WorkspaceScreen.tsx` | Pure Native | 85% | Na Web: siatka 1, 2, 3, 4, 6 paneli. Na Mobile: na telefonach widok jednopanelowy z szybkim przełącznikiem w nagłówku; na tabletach siatka 2-4 paneli. |
| `SplitWorkspaceControls` | `SplitWorkspaceControls.tsx` | `components/Panes.tsx` | Pure Native | 90% | Przełączniki układu siatki (1x1, 1x2, 2x2), synchronizowane z `WorkspaceContext`. |
| `BroadcastDialog` | `BroadcastDialog.tsx` | `components/Panes.tsx` | Pure Native | 85% | Modal rozgłaszania promptu do wielu równolegle otwartych sesji czatu. |
| `ChatPaneStack` | `ChatPaneStack.tsx` | `components/ChatPaneStack.tsx` | Pure Native | 90% | Zarządzanie stosem aktywnych paneli z zachowaniem ich niezależnego stanu przewijania. |
| `BrowserSessionsPane`| `BrowserSessionsPane.tsx`| `components/BrowserSessionsPane.tsx`| Pure Native | 80% | Podgląd sesji autonomicznej przeglądarki agenta (`browser-use`) ze zrzutami ekranu i dziennikiem akcji. |

### 2.6. Edytor Kodu i Przeglądarka Różnic (Code Editor & Diff)

| Komponent Web (`src/components/code-editor/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `MonacoCodeEditor` | `MonacoCodeEditor.tsx` | `screens/EditorScreen.tsx` | WebView Island | 85% | Uruchamiany przez `/island/editor`. Obsługuje kolorowanie składni, edycję, cofanie zmian. Wymaga optymalizacji klawiatury dotykowej. |
| `EditorIslandContainer`| `EditorIsland.tsx` | `components/EditorIsland.tsx` | Hybrid Bridge | 90% | Komunikacja dwukierunkowa: wstrzykiwanie kodu, odbiór zdarzeń zapisu (`save`), obsługa motywu dark/light. |
| `HunkDiffViewer` | `git/HunkDiffViewer.tsx` | `components/SourceControlBlocks.tsx` | Hybrid | 80% | Widok różnic w formacie unified/side-by-side z kolorowaniem dodanych i usuniętych linii. |
| `EditorMinimap` | `MonacoMinimap.tsx` | N/A (ukryty na małych ekranach) | WebView Island | 60% | Wyłączany na ekranach telefonów ze względu na czytelność; aktywny na tabletach powyżej 768px. |

### 2.7. Terminal i Interaktywny Shell

| Komponent Web (`src/components/shell/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `StandaloneShell` | `StandaloneShell.tsx` | `screens/TerminalScreen.tsx` | WebView Island | 90% | Pełna emulacja VT100/xterm.js w `/island/terminal`. Połączenie z sesją shella przez WebSocket. |
| `ShellControlsBar` | `ShellControlsBar.tsx` | `screens/TerminalScreen.tsx` | Pure Native | 95% | Pasek przycisków pomocniczych nad klawiaturą mobilną: `ESC`, `TAB`, `CTRL`, `ALT`, `PIPE`, `~`, `/`, `-`, strzałki. |
| `ShellConnectionOverlay`| `ShellOverlay.tsx` | `screens/TerminalScreen.tsx` | Pure Native | 90% | Automatyczne wznawianie sesji PTY po utracie pakietów lub uśpieniu aplikacji. |
| `QuickPromptsPanel` | `QuickPrompts.tsx` | `screens/TerminalScreen.tsx` | Pure Native | 90% | Lista predefiniowanych komend (`git status`, `npm test`, `ls -la`, `docker ps`) wstrzykiwanych jednym dotknięciem. |

### 2.8. Tablica Agenta (Kanban Board & Collab)

| Komponent Web (`src/components/kanban/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `BoardPage` | `BoardPage.tsx` | `screens/BoardScreen.tsx` | Pure Native | 85% | Poziomo przewijana lista kolumn (Backlog, Todo, In Progress, Review, Done). |
| `KanbanColumn` | `KanbanColumn.tsx` | `screens/BoardScreen.tsx` | Pure Native | 85% | Kolumna z licznikiem zadań, przyciskiem szybkiego dodawania karty i pionowym przewijaniem. |
| `KanbanCard` | `KanbanCard.tsx` | `screens/BoardScreen.tsx` | Pure Native | 90% | Karta zadania z priorytetem, przypisanym agentem, tagami i wskaźnikami obecności innych użytkowników. |
| `KanbanCardDialog` | `KanbanCardDialog.tsx` | `components/TaskMasterModals.tsx` | Pure Native | 90% | Modal edycji karty, zmiany kolumny, przypisania wykonawcy i dodawania komentarzy. |
| `PresenceAvatars` | `PresenceAvatars.tsx` | `screens/BoardScreen.tsx` | Pure Native | 80% | Awatary aktywnych współpracowników oglądających tablicę na żywo przez zdarzenia `presence`. |
| `ActivityFeed` | `ActivityFeed.tsx` | `screens/BoardScreen.tsx` | Pure Native | 80% | Dziennik ostatnich aktywności i przesunięć kart na tablicy. |

### 2.9. Moduł Zadań (TaskMaster & PRD)

| Komponent Web (`src/components/task-master/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `TasksPage` | `TasksPage.tsx` | `screens/TasksScreen.tsx` | Pure Native | 85% | Główny widok zadań projektu z filtrowaniem po statusie, priorytecie i wyszukiwaniem frazowym. |
| `TaskBoard` | `TaskBoard.tsx` | `screens/TasksScreen.tsx` | Pure Native | 85% | Alternatywny widok siatki zadań z podziałem na etapy realizacji. |
| `TaskCard` | `TaskCard.tsx` | `screens/TasksScreen.tsx` | Pure Native | 90% | Wyświetla identyfikator zadania, złożoność (story points), zależności i checklistę podzadań. |
| `TaskDetailModal` | `TaskDetailModal.tsx` | `components/TaskMasterModals.tsx` | Pure Native | 90% | Pełna specyfikacja zadania z możliwością bezpośredniego uruchomienia dedykowanego subagenta. |
| `NextTaskBanner` | `NextTaskBanner.tsx` | `screens/TasksScreen.tsx` | Pure Native | 95% | Baner rekomendujący najbliższe optymalne zadanie do podjęcia na podstawie grafu zależności. |
| `PrdEditorModal` | `PrdEditorModal.tsx` | `components/TaskMasterModals.tsx` | Pure Native | 70% | Podgląd i edycja dokumentu PRD z funkcją parsowania na atomowe zadania (`/api/taskmaster/parse-prd`). |

### 2.10. Kontrola Wersji (Source Control & Git)

| Komponent Web (`src/components/git-panel/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `SourceControlPage` | `SourceControlPage.tsx` | `screens/SourceControlScreen.tsx` | Pure Native | 85% | Przegląd zmienionych plików (staged, unstaged, untracked) z licznikiem zmian (+/-). |
| `GitPanel` | `GitPanel.tsx` | `screens/SourceControlScreen.tsx` | Pure Native | 85% | Pole wprowadzania wiadomości commitu, wybór akcji (Commit, Commit & Push, Amend). |
| `BranchManagementList`| `BranchList.tsx` | `components/SourceControlBlocks.tsx`| Pure Native | 85% | Lista gałęzi lokalnych i zdalnych, tworzenie nowego brancha, przełączanie (checkout). |
| `CommitHistoryList` | `CommitHistoryList.tsx`| `components/SourceControlBlocks.tsx`| Pure Native | 80% | Historia ostatnich commitów z autorem, datą, hashem i możliwością wglądu w diff. |
| `WorktreeModals` | `WorktreeModal.tsx` | `components/SourceControlBlocks.tsx`| Pure Native | 75% | Zarządzanie odgałęzieniami roboczymi (worktrees) do równoległej pracy z agentami. |
| `RunScriptsDropdown` | `RunScriptsDropdown.tsx`| `components/SourceControlBlocks.tsx`| Pure Native | 80% | Uruchamianie zdefiniowanych skryptów `package.json` w terminalu wprost z panelu gita. |

### 2.11. Drzewo Plików i Eksplorator Zasobów

| Komponent Web (`src/components/file-tree/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `FilesPage` | `FilesPage.tsx` | `screens/FileTreeScreen.tsx` | Pure Native | 90% | Eksplorator plików projektu z wyszukiwarką po nazwie i filtrowaniem rozszerzeń. |
| `FileTree` | `FileTree.tsx` | `screens/FileTreeScreen.tsx` | Pure Native | 90% | Zagnieżdżone drzewo katalogów z leniwym ładowaniem podfolderów (lazy loading). |
| `FileNode` | `FileNode.tsx` | `screens/FileTreeScreen.tsx` | Pure Native | 90% | Wiersz pliku/katalogu z dedykowanymi ikonami typów plików i menu akcji kontekstowych. |
| `FileViewer` | `FileViewer.tsx` | `screens/FileTreeScreen.tsx` | Pure Native + Island | 85% | Podgląd zawartości pliku tekstowego lub przekazanie do `EditorIsland` w celu edycji. |
| `ImageLightbox` | `ImageLightbox.tsx` | `components/MarkdownBlocks.tsx` | Pure Native | 95% | Pełnoekranowy podgląd obrazów z obsługą gestów pinch-to-zoom i udostępniania (`ShareSheet`). |
| `FileOperationsDialog`| `FileOperations.tsx` | `screens/FileTreeScreen.tsx` | Pure Native | 85% | Tworzenie nowych plików/folderów, zmiana nazwy, usuwanie i pobieranie na urządzenie. |

### 2.12. Centrum Kontroli Limitów i Kosztów (Quota & Usage)

| Komponent Web (`src/components/quota/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `ControlCenterPage` | `ControlCenterPage.tsx` | `screens/QuotaScreen.tsx` | Pure Native | 90% | Pulpit menedżerski zużycia tokenów, limitów budżetowych i aktywnych dostawców AI. |
| `OverviewPanel` | `OverviewPanel.tsx` | `screens/QuotaScreen.tsx` | Pure Native | 90% | Karty wskaźników KPI (bieżący koszt, zużycie dzienne/miesięczne, pozostały limit). |
| `QuotasPanel` | `QuotasPanel.tsx` | `screens/QuotaScreen.tsx` | Pure Native | 90% | Paski postępu wykorzystania limitów per model (Claude 3.7 Sonnet, GPT-4o, etc.). |
| `UsagePanel` | `UsagePanel.tsx` | `screens/QuotaScreen.tsx` | Pure Native | 85% | Wykresy słupkowe i liniowe zużycia w czasie (adaptowane na mobile w SVG). |
| `AgentsPanel` | `AgentsPanel.tsx` | `screens/QuotaScreen.tsx` | Pure Native | 85% | Zestawienie kosztów i liczby wywołań w podziale na role agentów. |

### 2.13. Paleta Poleceń i Wyszukiwanie Globalne (Command Palette)

| Komponent Web (`src/components/command-palette/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `CommandPalette` | `CommandPalette.tsx` | `components/CommandPalette.tsx` | Pure Native | 95% | Wywoływana z nagłówka lub gestem swipe dwoma palcami. Natychmiastowe filtrowanie fuzzy. |
| `PaletteSearchInput` | `PaletteInput.tsx` | `components/CommandPalette.tsx` | Pure Native | 95% | Dedykowane pole wyszukiwania z automatycznym fokusem i przyciskiem czyszczenia. |
| `PaletteResultsList` | `PaletteResults.tsx` | `components/CommandPalette.tsx` | Pure Native | 95% | Grupowane wyniki: Sesje czatu, Pliki projektu, Akcje nawigacyjne, Komendy systemowe. |
| `SessionComparePanel`| `SessionComparePanel.tsx`| `components/CommandPalette.tsx`| Pure Native | 80% | Widok porównania dwóch równoległych przebiegów sesji dla tego samego zadania. |

### 2.14. Panel Szybkich Ustawień (Quick Settings Sheet)

| Komponent Web (`src/components/quick-settings-panel/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/`) | Typ Implementacji | Parzystość | Różnice UX i Wymagania Dotykowe |
|---|---|---|:---:|:---:|---|
| `QuickSettingsPanel`| `QuickSettingsPanel.tsx`| `components/QuickSettings.tsx` | Pure Native | 100% | Wysuwany dolny arkusz gestem (Swipeable Bottom Sheet) z płynnym przyciąganiem (snap points). |
| `ModelFastSwitch` | `ModelFastSwitch.tsx` | `components/QuickSettings.tsx` | Pure Native | 100% | Szybki wybór głównego modelu dla bieżącej sesji czatu bez wchodzenia w menu główne. |
| `TemperatureSlider` | `TemperatureSlider.tsx` | `components/QuickSettings.tsx` | Pure Native | 100% | Suwak regulacji kreatywności / precyzji modelu (temperature: 0.0 - 1.0). |
| `ThinkingEffortToggle`| `ThinkingEffort.tsx` | `components/QuickSettings.tsx` | Pure Native | 100% | Przełącznik intensywności rozumowania (Off, Low, Medium, High). |

### 2.15. Ustawienia Aplikacji (13 Zakładek Konfiguracyjnych)

| Zakładka Ustawień | Komponent Web (`src/components/settings/`) | Odpowiednik Mobilny (`mobile/src/screens/settings/`) | Parzystość | Zakres Funkcjonalny w Wersji Mobilnej |
|---|---|---|:---:|---|
| **1. General** | `GeneralTab.tsx` | `SettingsTabs.tsx` (`general`) | 95% | Język interfejsu (12 języków), automatyczne aktualizacje, telemetryka, czyszczenie cache. |
| **2. Appearance** | `AppearanceTab.tsx` | `SettingsTabs.tsx` (`appearance`) | 95% | Motyw (System, Dark, Light, Cyberpunk), gęstość interfejsu, wielkość czcionki w czacie i kodzie. |
| **3. Workspaces** | `WorkspacesTab.tsx` | `SettingsTabs.tsx` (`workspaces`) | 90% | Domyślny układ paneli, zachowanie sesji po restarcie, konfiguracja folderów roboczych. |
| **4. Schedules** | `SchedulesTab.tsx` | `SettingsTabs.tsx` (`schedules`) | 85% | Cykliczne zadania CRON agenta, harmonogram przeglądów kodu i tworzenia raportów. |
| **5. Git** | `GitTab.tsx` | `SettingsTabs.tsx` (`git`) | 90% | Domyślny autor commitów, auto-fetch, podpisywanie kluczami GPG/SSH, ignorowanie reguł. |
| **6. API Tokens** | `TokensTab.tsx` | `SettingsTabs.tsx` (`tokens`) | 95% | Zarządzanie kluczami dostawców (Anthropic, OpenAI, OpenRouter, Gemini, Groq, Mistral). |
| **7. Tasks** | `TasksTab.tsx` | `SettingsTabs.tsx` (`tasks`) | 90% | Domyślne przypisania zadań, integracja z TaskMasterem, szablony kart kanbanowych. |
| **8. Browser** | `BrowserTab.tsx` | `SettingsTabs.tsx` (`browser`) | 85% | Konfiguracja silnika `browser-use`, rozdzielczość wirtualnego okna, polityka ciasteczek. |
| **9. Notifications** | `NotificationsTab.tsx` | `SettingsTabs.tsx` (`notifications`)| 95% | Konfiguracja kanałów FCM/APNs, dźwięki powiadomień, progi alertów wymagających zgody. |
| **10. Quota** | `QuotaTab.tsx` | `SettingsTabs.tsx` (`quota`) | 90% | Definiowanie twardych i miękkich limitów budżetowych, powiadomienia e-mail/push o przekroczeniu. |
| **11. Orchestration**| `OrchestrationTab.tsx`| `screens/settings/OrchestrationTab.tsx`| 90% | Konfiguracja subagentów, limity równoległości, strategie głosowania i łączenia wyników. |
| **12. Agents** | `AgentsTab.tsx` | `screens/settings/AgentsTab.tsx` | 90% | Profile agentów (Prompt systemowy, dozwolone narzędzia, temperatura, limit kroków). |
| **13. About** | `AboutTab.tsx` | `SettingsTabs.tsx` (`about`) | 95% | Wersja aplikacji (0.6.2), licencje, dziennik zmian (changelog) i diagnostyka serwera. |

### 2.16. Uwierzytelnianie, Pierwsze Uruchomienie i Blokada Biometryczna

| Komponent Web (`src/components/auth/`) | Plik Web | Odpowiednik Mobilny (`mobile/src/screens/`) | Typ Implementacji | Parzystość | Specyfika Mobilna |
|---|---|---|:---:|:---:|---|
| `LoginPage` | `LoginPage.tsx` | `LoginScreen.tsx` | Pure Native | 100% | Logowanie hasłem lub tokenem sesyjnym z opcją zapisu w SecureStore. |
| `ServerConnect` | `ServerConnect.tsx` | `ServerConnectScreen.tsx` | Pure Native | 100% | Konfiguracja adresu instancji backendu (Tailscale URL / IP / port) z testem pingu. |
| `SetupWizard` | `SetupWizard.tsx` | `SetupScreen.tsx` | Pure Native | 100% | Pierwsza inicjalizacja bazy danych i konta administratora przy nowej instalacji. |
| `Onboarding` | `Onboarding.tsx` | `OnboardingScreen.tsx` | Pure Native | 100% | Przewodnik powitalny z wyjaśnieniem uprawnień (Powiadomienia, Mikrofon, Biometria). |
| `BiometricLock` | N/A (Web: brak natywnego FaceID) | `components/AppLock.tsx` | Pure Native | 100% | Natywna ochrona dostępu z wznawianiem przy powrocie z tła (Auto-lock timer). |

---

## 3. Architektura Przepływu Danych (Data Flow Architecture)

### 3.1. Topologia Stanu Aplikacji
Aplikacja mobilna implementuje hierarchiczną, reaktywną strukturę zarządzania stanem opartą o konteksty Reacta zoptymalizowane pod kątem minimalizacji re-renderów:

```
+------------------------------------------------------------------------+
|                             App Root                                   |
+------------------------------------------------------------------------+
                                   |
         +-------------------------+-------------------------+
         |                                                   |
+-----------------------+                         +----------------------+
|   ServerConfigContext |                         |      AuthContext     |
| (Aktywny adres serwera|                         | (Token sesji, user,  |
|  oraz status sieci)   |                         |  status autoryzacji) |
+-----------------------+                         +----------------------+
         |                                                   |
         +-------------------------+-------------------------+
                                   |
                        +----------------------+
                        |   WebSocketContext   |
                        | (Główny kanał duplex,|
                        |  reconnect, replay)  |
                        +----------------------+
                                   |
         +-------------------------+-------------------------+
         |                         |                         |
+-------------------+     +-------------------+     +-------------------+
|  WorkspaceContext |     |TasksSettingsCtx   |     | OfflineQueueCtx   |
| (Aktywny projekt, |     | (TaskMaster sync, |     | (Kolejka akcji    |
|  sesje, układ)    |     |  filtry, tablica) |     |  do wysłania)     |
+-------------------+     +-------------------+     +-------------------+
```

### 3.2. Komunikacja Hybrydowa: REST API vs WebSocket vs SSE
System wykorzystuje komplementarne protokoły sieciowe dopasowane do charakterystyki operacji:

1. **REST API (HTTP/2 przez TLS):**
   - Operacje CRUD: pobieranie list projektów, pobieranie zawartości plików, rejestracja tokenów push, zapis ustawień globalnych.
   - Wszystkie żądania autoryzowane są nagłówkiem `Authorization: Bearer <sessionToken>` przez uniwersalny wrapper `authenticatedFetch` (`~shared/utils/api`).
2. **WebSocket (WSS Duplex Channel):**
   - Główny punkt wejścia: `/api/websocket`.
   - Zapewnia natychmiastowe, dwukierunkowe strumieniowanie tokenów modeli językowych, transfer zdarzeń narzędziowych, weryfikację uprawnień w czasie rzeczywistym oraz synchronizację obecności (presence) i tablicy Kanban.
3. **Server-Sent Events (SSE):**
   - Używane jako automatyczny kanał zapasowy (fallback) dla strumieniowania czatu w środowiskach sieciowych blokujących trwałe połączenia WebSocket (np. restrykcyjne zapory korporacyjne lub mobilne sieci VPN).

### 3.3. Odporność na Utratę Połączenia i Bufor Offline (Offline-First Queue)
W warunkach mobilnych utrata zasięgu sieci (przejście między stacjami bazowymi, tryb samolotowy, tunele) jest zjawiskiem ciągłym. Architektura zapewnia pełną ciągłość pracy:

1. **Identyfikacja i Śledzenie Kursora Strumienia:**
   - Każda ramka strumieniowania asystenta posiada atrybuty: `sessionId`, `runId` oraz monotonicznie rosnący numer sekwencyjny `seq`.
   - Podczas ponownego nawiązywania połączenia klient wysyła ramkę `chat.subscribe` z parametrem `cursor: { runId, seq }`. Serwer wznawia strumień od ostatniego brakującego pakietu bez powtarzania całej generacji.
2. **Lokalna Kolejka Offline (`offline-queue.ts`):**
   - Wiadomości użytkownika oraz decyzje zatwierdzenia narzędzi (`permission_resolved`) wysyłane w trybie offline trafiają do trwałego bufora w `AsyncStorage`.
   - Przywrócenie połączenia (`NetInfo.isConnected === true` && `ws.readyState === WebSocket.OPEN`) uruchamia sekwencyjny proces opróżniania kolejki z zachowaniem pierwotnej chronologii zdarzeń.

### 3.4. Bezpieczeństwo i Trwałość Danych (SecureStore vs AsyncStorage)

- **Warstwa Kryptograficzna (`expo-secure-store`):**
  - Tokeny sesyjne JWT / API Bearer tokens.
  - Klucze szyfrowania bazy lokalnej.
  - Sól i hasz lokalnego kodu PIN.
  - Dane te są przechowywane w sprzętowej enklawie urządzenia: **iOS Keychain** oraz **Android EncryptedSharedPreferences (Hardware-backed Keystore)**.
- **Warstwa Konfiguracyjna i Cache (`@react-native-async-storage/async-storage`):**
  - Ostatnio wybrany projekt i aktywny układ paneli workspace.
  - Preferencje interfejsu (motyw, rozmiar czcionki, parametry TTS).
  - Skrócona lista ostatnich sesji czatu i drzewo plików do natychmiastowego renderowania przed pobraniem świeżych danych z sieci (stale-while-revalidate).

### 3.5. Cykl Życia Aplikacji, Zadania w Tle i Powiadomienia Push (FCM / APNs)

```
[Stan Aplikacji: Foreground]
       |
       | Użytkownik minimalizuje aplikację
       v
[Stan Aplikacji: Background / Suspended]
       |
       | Serwer wymaga zgody na wykonanie narzędzia (np. `rm -rf` lub `git push`)
       v
[Zdarzenie Push: FCM/APNs Payload z kodem `permission.required`]
       |
       +---> Jeśli aplikacja jest w tle (Android Headless / iOS Notification Service):
       |     `ddagent-approval-push` aktywuje zadanie w tle (TaskManager).
       |     Pojawia się notyfikacja systemowa z przyciskami akcji:
       |     [Zezwól]  [Zawsze Zezwalaj]  [Odrzuć]
       |
       v
[Użytkownik klika akcję bezpośrednio na powiadomieniu bez otwierania aplikacji]
       |
       +---> `mobile/src/lib/push.ts` wysyła POST `/api/notifications/approvals/:id`
       |     z decyzją: `allow` | `always` | `deny`
       v
[Serwer natychmiast odblokowuje agenta i kontynuuje zadanie]
```

### 3.6. Most Komunikacyjny Wysepek WebView (WebView Islands Bridge Protocol)
Wysepki `EditorIsland` i `TerminalIsland` komunikują się z warstwą natywną za pośrednictwem ustandaryzowanego protokołu wiadomości JSON wymienianych przez interfejs `postMessage`:

```typescript
// Struktura ramki przesyłanej z React Native do Wyspy WebView
interface NativeToIslandMessage<T = unknown> {
  id: string;             // Unikalny identyfikator żądania (UUID)
  type: string;           // Typ polecenia: 'init' | 'set_content' | 'theme_change' | 'exec_cmd'
  payload: T;             // Dane polecenia
}

// Struktura ramki przesyłanej z Wyspy WebView do React Native
interface IslandToNativeMessage<T = unknown> {
  id?: string;            // Identyfikator żądania, na które wysyłana jest odpowiedź
  type: string;           // Zdarzenie: 'ready' | 'content_changed' | 'save' | 'terminal_output' | 'error'
  payload: T;             // Dane zdarzenia
}
```

- **Wstrzykiwanie Kontekstu i Bezpieczeństwo:**
  - Token autoryzacyjny i adres serwera przekazywane są do WebView w momencie inicjalizacji poprzez dynamiczny skrypt `injectedJavaScriptBeforeContentLoaded`.
  - Zapobiega to wyciekom tokenów w parametrach URL oraz eliminuje problemy z plikami cookies w kontekście `localhost`.
- **Dopasowanie do Klawiatury i Obszarów Bezpiecznych:**
  - Wysokość WebView jest dynamicznie korygowana przy wysunięciu wirtualnej klawiatury systemowej, zapewniając, że kursor edytora lub linia promptu terminala pozostają zawsze widoczne powyżej górnej krawędzi klawiatury.

---

## 4. Inwentaryzacja Interfejsów: REST API i Zdarzenia WebSocket

### 4.1. Macierz Endpointów REST (Web vs Mobile)

| Endpoint URL | Metoda | Moduł Serwera | Cel Funkcjonalny | Status w Mobile | Wymagane Ujednolicenia |
|---|:---:|---|---|:---:|---|
| `/api/auth/login` | `POST` | `auth` | Logowanie użytkownika i wydanie tokena JWT | Zaimplementowane | Brak (zgodność 100%) |
| `/api/auth/me` | `GET` | `auth` | Weryfikacja tożsamości i uprawnień | Zaimplementowane | Brak (zgodność 100%) |
| `/api/projects` | `GET`, `POST` | `projects` | Lista projektów oraz tworzenie nowego projektu | Zaimplementowane | Brak (zgodność 100%) |
| `/api/projects/:id/sessions` | `GET` | `agent` | Pobieranie listy sesji czatu dla projektu | Zaimplementowane | Brak (zgodność 100%) |
| `/api/projects/:id/sessions/:sid`| `DELETE` | `agent` | Usuwanie sesji czatu | Zaimplementowane | Brak (zgodność 100%) |
| `/api/file-tree` | `GET` | `file-tree` | Pobieranie hierarchii plików projektu | Zaimplementowane | Dodać filtrowanie ukrytych plików |
| `/api/file-tree/content` | `GET`, `PUT` | `file-tree` | Odczyt i zapis zawartości pliku | Zaimplementowane | Dodać obsługę zapisu strumieniowego |
| `/api/git/status` | `GET` | `git` | Status repozytorium (branch, staged, modified) | Zaimplementowane | Brak (zgodność 100%) |
| `/api/git/commit` | `POST` | `git` | Zatwierdzanie zmian w repozytorium | Zaimplementowane | Dodać obsługę opcji `--amend` |
| `/api/git/branches` | `GET`, `POST`| `git` | Pobieranie i tworzenie gałęzi | Zaimplementowane | Brak (zgodność 100%) |
| `/api/git/hunk-stage` | `POST` | `git` | Częściowy staging konkretnego chunka diffa | **Do wdrożenia** | Dodać wywołanie w `SourceControlBlocks` |
| `/api/kanban/cards` | `GET`, `POST`| `kanban` | Odczyt i dodawanie kart tablicy | Zaimplementowane | Brak (zgodność 100%) |
| `/api/kanban/cards/:id` | `PATCH`, `DELETE`| `kanban` | Aktualizacja kolumny / edycja karty | Zaimplementowane | Brak (zgodność 100%) |
| `/api/taskmaster/tasks` | `GET`, `POST`| `taskmaster`| Pobieranie i tworzenie zadań TaskMaster | Zaimplementowane | Brak (zgodność 100%) |
| `/api/taskmaster/parse-prd`| `POST` | `taskmaster`| Dekompozycja PRD na atomowe zadania | **Częściowe** | Zintegrować modal w `TaskMasterModals` |
| `/api/quota/overview` | `GET` | `quota` | Zbiorcze statystyki kosztów i limitów | Zaimplementowane | Brak (zgodność 100%) |
| `/api/notifications/endpoints`| `POST` | `notifications`| Rejestracja tokena FCM/APNs urządzenia | Zaimplementowane | Brak (zgodność 100%) |
| `/api/notifications/approvals/:id`| `POST`| `notifications`| Bezpośrednia odpowiedź na zatwierdzenie narzędzia | Zaimplementowane | Obsługa konfliktów 409 (already resolved) |
| `/api/tts/synthesize` | `POST` | `tts` | Generowanie mowy asystenta z tekstu | Zaimplementowane | Dodać lokalny cache plików audio |
| `/api/stt/transcribe` | `POST` | `stt` | Transkrypcja głosu użytkownika | Zaimplementowane | Obsługa formatu `m4a`/`aac` z iOS |
| `/api/browser/sessions` | `GET`, `POST`| `browser-use`| Zarządzanie sesjami autonomicznej przeglądarki | **Do wdrożenia** | Podgląd sesji w `BrowserSessionsPane` |

### 4.2. Specyfikacja Ramek WebSocket (Klient -> Serwer)

```typescript
// Subskrypcja do strumienia zdarzeń sesji czatu
export interface ChatSubscribeMessage {
  type: 'chat.subscribe';
  sessionId: string;
  cursor?: {
    runId: string;
    seq: number;
  };
}

// Wysłanie wiadomości użytkownika do agenta
export interface ChatSendMessage {
  type: 'chat.send';
  sessionId: string;
  message: string;
  provider?: string;
  model?: string;
  attachments?: Array<{
    name: string;
    type: string;
    content: string; // Base64
  }>;
}

// Przerwanie trwającej generacji agenta
export interface ChatCancelMessage {
  type: 'chat.cancel';
  sessionId: string;
}

// Decyzja użytkownika dotycząca zgody na wykonanie narzędzia
export interface ChatPermissionMessage {
  type: 'chat.permission';
  sessionId: string;
  requestId: string;
  decision: 'allow' | 'deny' | 'always';
}

// Sygnalizacja obecności i aktywnego widoku współpracownika
export interface PresenceMessage {
  type: 'presence';
  viewing: {
    kind: 'session' | 'card' | 'board' | 'file';
    id: string;
  } | null;
}

// Przekazanie danych wejściowych do terminala PTY
export interface TerminalInputMessage {
  type: 'input';
  data: string;
}

// Zmiana geometrii okna terminala
export interface TerminalResizeMessage {
  type: 'resize';
  cols: number;
  rows: number;
}
```

### 4.3. Specyfikacja Zdarzeń WebSocket (Serwer -> Klient)

```typescript
// Potwierdzenie subskrypcji i stanu początkowego sesji
export interface ChatSubscribedEvent {
  kind: 'chat_subscribed';
  sessionId: string;
  runId: string;
  seq: number;
}

// Przyrostowy token wygenerowanego tekstu
export interface StreamDeltaEvent {
  kind: 'stream_delta';
  sessionId: string;
  runId: string;
  seq: number;
  content: string;
}

// Zdarzenie procesu myślowego modelu (extended thinking)
export interface ThinkingEvent {
  kind: 'thinking';
  sessionId: string;
  runId: string;
  seq: number;
  content: string;
}

// Sygnalizacja wywołania narzędzia przez model
export interface ToolUseEvent {
  kind: 'tool_use';
  sessionId: string;
  runId: string;
  seq: number;
  toolId: string;
  name: string;
  input: Record<string, unknown>;
}

// Zwrócenie wyniku wykonania narzędzia
export interface ToolResultEvent {
  kind: 'tool_result';
  sessionId: string;
  runId: string;
  seq: number;
  toolId: string;
  output: string;
  isError?: boolean;
}

// Żądanie zatwierdzenia operacji przez użytkownika
export interface PermissionRequestEvent {
  kind: 'permission_request';
  sessionId: string;
  requestId: string;
  tool: string;
  input: Record<string, unknown>;
  affectedPaths?: string[];
}

// Zakończenie całego cyklu generacji
export interface CompleteEvent {
  kind: 'complete';
  sessionId: string;
  actualSessionId: string;
  exitCode?: number;
  success: boolean;
  aborted?: boolean;
}

// Czas rzeczywisty Tablicy Kanban: aktualizacja karty
export interface KanbanCardUpsertedEvent {
  type: 'kanban-card-upserted';
  projectId: string;
  card: Record<string, unknown>;
}

// Czas rzeczywisty Tablicy Kanban: usunięcie karty
export interface KanbanCardDeletedEvent {
  type: 'kanban-card-deleted';
  projectId: string;
  cardId: string;
}

// Aktualizacja zadań w module TaskMaster
export interface TaskMasterTasksUpdatedEvent {
  type: 'taskmaster-tasks-updated';
  projectId: string;
  tasksData: Record<string, unknown>;
}
```

### 4.4. Zidentyfikowane Luki w Protokole Czasu Rzeczywistego
W trakcie audytu zidentyfikowano następujące braki w implementacji mobilnej wymagające uzupełnienia:

1. **Brak obsługi zdarzeń `browser-use`:** Aplikacja mobilna ignoruje zdarzenia strumieniowania zrzutów ekranu wirtualnej przeglądarki asystenta (`browser_screenshot_delta`).
2. **Brak granularnych zdarzeń orkiestratora:** Komponenty mobilne nie reagują na zdarzenia `orchestrator_step_started` oraz `orchestrator_step_finished`, co powoduje brak aktualizacji paska postępu w `ReviewBlocks.tsx`.
3. **Niepełna synchronizacja modyfikacji drzewa plików:** Brak nasłuchiwania na rozgłoszenia `file_tree_changed`, co wymusza ręczny gest pull-to-refresh w `FileTreeScreen`.

---

## 5. Harmonogram Implementacji (Roadmap) i Kryteria Akceptacji 1:1

### 5.1. Faza 1: Synchronizacja Czasu Rzeczywistego i Ujednolicenie WebSocket (Sprint 1: 2 tygodnie)
*Cel: Wyeliminowanie asynchronii stanów i zagwarantowanie bezbłędnej wymiany danych w czasie rzeczywistym.*

#### Zadania techniczne:
1. Rozszerzenie `WebSocketContext.tsx` o pełną obsługę zdarzeń: `kanban-card-upserted`, `kanban-card-deleted`, `taskmaster-tasks-updated`, `orchestrator_step_*`.
2. Wdrożenie mechanizmu `cursor replay` przy reconnectach WebSocket z buforem w pamięci podręcznej.
3. Pełna obsługa rozproszonej synchronizacji obecności użytkowników (`presence-roster`) na ekranach `BoardScreen` i `ChatScreen`.
4. Ujednolicenie obsługi błędów sieciowych i automatyczny fallback do REST/SSE przy restrykcyjnych firewallach.

#### Kryteria Akceptacji (Faza 1):
- [ ] Przesunięcie karty na tablicy Kanban w wersji Web natychmiast (< 100 ms) aktualizuje pozycję karty na ekranie `BoardScreen` w telefonie bez odświeżania.
- [ ] Rozłączenie z siecią w trakcie generacji odpowiedzi (symulacja trybu samolotowego na 5 sekund) i ponowne połączenie wznawia strumień bez utraty wygenerowanych tokenów.
- [ ] Zmiana statusu zadania TaskMaster przez innego użytkownika jest odzwierciedlana na ekranie `TasksScreen` w czasie rzeczywistym.

---

### 5.2. Faza 2: Optymalizacja Wysepek WebView i Edytora Kodu (Sprint 2: 2.5 tygodnia)
*Cel: Osiągnięcie pełnej responsywności i wygody edycji kodu oraz pracy w konsoli shell.*

#### Zadania techniczne:
1. Optymalizacja mostka `EditorIsland`: obsługa gestów dotykowych, precyzyjne zaznaczanie tekstu, menu kontekstowe lupy na iOS/Android.
2. Integracja nawigacji po zmianach (Hunk Jump) bezpośrednio w pasku narzędziowym edytora kodu.
3. Rozbudowa natywnego paska klawiszy funkcyjnych w `TerminalScreen` o konfigurowalne makra użytkownika i obsługę historii poleceń (swipe góra/dół na terminalu).
4. Pełna implementacja lokalnego renderowania diagramów Mermaid i formuł KaTeX z dynamicznym skalowaniem (zoom & pan).

#### Kryteria Akceptacji (Faza 2):
- [ ] Otwarcie pliku powyżej 2000 linii w `EditorScreen` renderuje się płynnie (> 55 FPS) z działającym kolorowaniem składni.
- [ ] Wpisywanie poleceń w `TerminalScreen` przy użyciu wirtualnej klawiatury nie powoduje przesunięcia układu ani ukrycia aktywnej linii pod klawiaturą.
- [ ] Dotknięcie fragmentu diffa w `ToolDiffViewer` otwiera podgląd z możliwością zatwierdzenia/odrzucenia zmiany na poziomie konkretnego chunka kodu.

---

### 5.3. Faza 3: Zaawansowane Interakcje Dotykowe: Kanban, TaskMaster, Git i Workspace (Sprint 3: 3 tygodnie)
*Cel: Wdrożenie zaawansowanych gestów i ergonomii dotykowej w kluczowych modułach narzędziowych.*

#### Zadania techniczne:
1. Implementacja płynnego Drag & Drop dla kart Kanban na urządzeniach dotykowych przy użyciu `react-native-reanimated` i haptyki.
2. Pełna obsługa wizualnego kreatora PRD w `TasksScreen` z funkcją natychmiastowego generowania zadań przez AI.
3. Wdrożenie zaawansowanych operacji Git w `SourceControlScreen`: częściowy staging linii kodu, zarządzanie wieloma katalogami roboczymi (worktrees) oraz szybki checkout gałęzi z wyszukiwarką.
4. Adaptacyjny układ `WorkspaceScreen`: automatyczne przełączanie między układem kart (smartfon) a siatką wielopanelową (tablet / iPad z multitaskingiem).

#### Kryteria Akceptacji (Faza 3):
- [ ] Przeciągnięcie karty między kolumnami na tablicy Kanban wywołuje natywną haptykę (`ImpactFeedbackStyle.Light`) i natychmiast synchronizuje stan z bazą serwera.
- [ ] Użytkownik może zatwierdzić pojedyncze linie kodu w diffie gita przed wykonaniem commitu.
- [ ] Na tabletach o przekątnej powyżej 10 cali widok `WorkspaceScreen` pozwala na jednoczesną, niezależną pracę na 2 lub 4 panelach obok siebie.

---

### 5.4. Faza 4: Polish Mobilny, Dostępność, Haptyka i Buforowanie Offline (Sprint 4: 2 tygodnie)
*Cel: Dopracowanie wrażeń z użytkowania (look & feel), dostępności (a11y) i niezawodności w skrajnych warunkach.*

#### Zadania techniczne:
1. Standaryzacja wszystkich pól dotykowych zgodnie z wytycznymi WCAG 2.1 AA (minimalny rozmiar celu dotykowego 48x48 pt, kontrast kolorów min. 4.5:1).
2. Pełne wdrożenie etykiet dostępności (`accessibilityLabel`, `accessibilityHint`, `accessibilityRole`) dla technologii czytników ekranu (VoiceOver na iOS, TalkBack na Androidzie).
3. Kompleksowe testy bufora offline: możliwość redagowania promptów i kolejkowania zadań w trybie offline z automatyczną wysyłką po powrocie do sieci.
4. Aktualizacja i rozszerzenie zautomatyzowanego zestawu testów samokontroli (`mobile/tests/self-check.mts`) do pokrycia 100% zdefiniowanych ścieżek krytycznych.

#### Kryteria Akceptacji (Faza 4):
- [ ] Aplikacja przechodzi pełny audyt dostępności zautomatyzowany i manualny (brak niezaetykietowanych przycisków ikonowych).
- [ ] Wysłanie 3 wiadomości w trybie samolotowym i ponowne włączenie sieci powoduje poprawne dostarczenie wszystkich 3 zapytań z zachowaniem kolejności.
- [ ] Test samokontrolny `node mobile/tests/self-check.mts` kończy się wynikiem 100% passed dla wszystkich modułów.

---

### 5.5. Matryca Bram Jakościowych (Quality Gates & QA Checklist)

Każda zmiana wprowadzana w ramach powyższego harmonogramu musi spełniać rygorystyczne kryteria odbiorcze przed wdrożeniem do gałęzi głównej:

| Brama Jakościowa | Wymagany Rezultat | Narzędzie Weryfikacji |
|---|---|---|
| **Kompilacja i Typowanie** | 0 błędów TypeScript (`tsc --noEmit`) | `npm run typecheck` (root & mobile) |
| **Linting i Stylistyka** | 0 błędów ESLint | `npx eslint mobile/src/**/*.{ts,tsx}` |
| **Testy Jednostkowe & Regresyjne** | 100% testów zakończonych sukcesem | `npm test` oraz `npm run test:client` |
| **Self-Check Mobilny** | 100% asercji spełnionych | `node mobile/tests/self-check.mts` |
| **Wydajność Renderowania** | Stałe 60 FPS podczas przewijania czatu i edytora | React Native Performance Monitor |
| **Zużycie Baterii i Pamięci** | Brak wycieków pamięci (memory leaks) w sesjach > 60 min | Xcode Instruments / Android Studio Profiler |
| **Bezpieczeństwo Enklawy** | Brak przechowywania wrażliwych tokenów w otwartym tekście | Audyt SecureStore vs AsyncStorage |
| **Zgodność Wizualna** | Identyczna paleta barw, typografia i ikony co Web UI | Porównawczy audyt wizualny (Figma / Side-by-side) |

---
*Dokument zatwierdzony do realizacji w ramach architektury mobilnej ddagent.*
