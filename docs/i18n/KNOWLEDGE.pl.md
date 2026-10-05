# Baza wiedzy

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <strong>Polski</strong> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent dostarcza **lokalną bazę wiedzy** dla Twoich agentów: wspomnienia, reguły,
skille i informacje osobiste, a także tagi i relacje. Mieszka w tej samej bazie
SQLite co reszta ddagent (`auth.db`), za indeksem pełnotekstowym FTS5, jest
zarządzana z ekranu **Knowledge** w kliencie i może być odczytywana oraz zapisywana
przez Twoich agentów przez MCP. Jest luźno inspirowana
[Contexta](https://github.com/XFABISIEK/Contexta).

Sens jest prosty: Twoje reguły i wiedza o projekcie przestają być rozproszone po
plikach poszczególnych narzędzi (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …)
i stają się jednym wyselekcjonowanym, przeszukiwalnym miejscem, z którego może
korzystać każdy agent — te, które czytają pliki, i te, które mówią przez MCP.

## Jak agent faktycznie to widzi

Są trzy warstwy i warto wiedzieć, która jest która:

- **Pliki natywne CLI** — każde narzędzie czyta własną konfigurację po swojemu: Claude
  Code czyta `CLAUDE.md`, Codex/Cursor czytają `AGENTS.md`, Cursor czyta `.cursorrules`,
  a kilka czyta `skills/` i `.agents/skills/`. To zadanie CLI, nie
  wybór modelu — ddagent tego nie wyłącza.
- **Pobieranie przez MCP (na żądanie)** — gdy zainstalujesz serwer MCP ddagent w
  agencie, jego lista narzędzi zawiera `knowledge_get_context`, `knowledge_search`
  i podobne. Zgodnie z Contexta nic nie jest wstrzykiwane automatycznie: agent
  wywołuje konstruktor kontekstu z zapytaniem i dostaje z powrotem reguły
  `critical` plus wszystko, co pasuje. Model decyduje, kiedy go wywołać, kierując
  się opisami narzędzi oraz regułami instrukcyjnymi, które trzymasz w bazie
  wiedzy.

Czyli „jedno miejsce” oznacza **jedno miejsce do kuratorowania wiedzy**
— nie zatrzymuje (i nie może zatrzymać) CLI czytającego własne natywne pliki.
ddagent w ogóle nie wstrzykuje bazy wiedzy automatycznie do sesji.

## Encje

| Encja | Zasięg | Uwagi |
|---|---|---|
| Wspomnienie | projekt lub globalne | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, tagi |
| Reguła | projekt lub globalne | przełącznik `enabled`; reguły `critical` są zawsze zwracane w pierwszej kolejności przez konstruktor kontekstu |
| Skill | globalny | unikalna nazwa, kategoria, opcjonalna ikona (base64 data URL) |
| Informacje osobiste | globalne | unikalny `key` |
| Tag / Połączenie | — | tagi na wspomnieniach; połączenia łączą dowolne dwie encje |
| Historia | — | każdy zapis tworzy snapshot encji, więc można ją przejrzeć i przywrócić |

Priorytety: `critical > high > normal > low`. Encja może być ograniczona do jednego
projektu lub być globalna (obowiązuje wszędzie). `project_id` to zwykła kolumna (bez
klucza obcego), bo tabela projektów jest odtwarzana podczas migracji.

## Pobieranie kontekstu (na żądanie)

Agenci pobierają kontekst przez narzędzie MCP `knowledge_get_context` (wierny
port ContextBuilder z Contexta). Dla danego projektu i zapytania zwraca ono po
kolei:

- **wszystkie włączone reguły** (projektowe + globalne), `critical` najpierw (limit 20),
- **wspomnienia** rankingowane przez zapytanie (FTS), plus ich sąsiedzi 1 skoku
  osiągnięci przez połączenia (limit 5); bez zapytania najlepsze wspomnienia
  projektu według priorytetu,
- **skille** rankingowane przez zapytanie; bez zapytania najnowsze skille,
- **informacje osobiste** tylko wtedy, gdy zapytanie do nich pasuje (limit 3),

renderowane jako blok Markdown, którego elementy są przycinane osobno dla każdej
sekcji (800/1000/600 znaków) i ograniczane przez `maxTokens` (domyślnie ~4000);
elementy, które już się nie mieszczą, są liczone jako pominięte.

Dashboard pokazuje **miernik kontekstu reguł** (`~X / 4000 tok`) dla
wybranego projektu — rozmiar bloku reguł, który każde wywołanie
`knowledge_get_context` zawsze zawiera. Do sesji nie jest automatycznie
wstrzykiwane nic.

Ranking wyszukiwania jest hybrydowy, podobnie jak w `search.rs` Contexty:
dopasowanie **prefix** FTS5 (`auth` pasuje także do `authentication`) plus rozmyty
przebieg **trigram**, który wychwytuje literówki i quasi-synonimy, a następnie
rerank według `bm25 + priority + recency`.

## Narzędzia MCP (na żądanie)

Serwer MCP ddagent (`POST /mcp`) udostępnia bazę wiedzy każdemu klientowi MCP.
Narzędzia czytające działają z tokenem o zakresie `read`; narzędzia zapisujące wymagają `write`.
Narzędzia zapisujące uruchamiają tę samą walidację co UI i zapisują historię.

Czytanie: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Zapis: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, oraz to samo trio dla `rule`, `skill` i `personal`;
plus `knowledge_link` / `knowledge_unlink`.

Narzędzia przyjmują `projectId` albo `projectPath`, który ddagent już zna.

### Instalowanie serwera w Twoich agentach

Nie musisz ręcznie edytować konfiguracji providerów. Użyj **Settings → MCP →
Install ddagent MCP server** (oferowane też jako krok w onboardingu) i wybierz
agentów — albo zainstaluj dla wszystkich. Zapisuje wpis HTTP MCP `ddagent` (zakres
użytkownika) wskazujący na `<server>/mcp` z wielokrotnego użytku tokenem bearer
`ddagent-mcp` (ponowna instalacja unieważnia poprzedni). Po instalacji narzędzia tego
agenta zawierają grupę `knowledge_*` obok `create_task`, `send_message` itd.

Skąd agent wie, *kiedy* użyć MCP? Nie zgaduje — powiedz mu. Trzymaj regułę
`critical`, taką jak: *„Zanim odpowiesz na pytania o ten projekt, wywołaj
`knowledge_get_context`; gdy ustalisz decyzję, utrwal ją przez
`knowledge_add_memory`.”* Ponieważ reguły `critical` są zawsze zwracane przez konstruktor
kontekstu, każdy agent, który wywoła to narzędzie, dostaje te same instrukcje działania.

## Skanowanie projektu

`POST /api/knowledge/scan` importuje pliki kontekstu AI projektu, klasyfikowane według
intencji:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` oraz markdown/`.mdc` pod `.cursor/rules` stają się **regułami**
  (critical + enabled, więc trafiają do kontekstu agenta; workspace’owy `AGENTS.md`
  jest `high`, aby uniknąć podwójnego wstrzykiwania z unified-rules),
- pliki `SKILL.md` pod `skills` / `.agents/skills` stają się **skillami**
  (nazwa/opis z frontmatter),
- każdy inny zeskanowany markdown staje się **wspomnieniem referencyjnym**.

Każdy plik jest śledzony przez hash treści w `kb_scan_state`, więc ponowne skanowanie
dotyka tylko zmienionych plików i usuwa encje, których źródło zniknęło.

## Klient

Ekran **Knowledge** (szyna nawigacji → Knowledge) ma zakładki Dashboard, Memories,
Rules, Skills, Personal i Graph, filtr zasięgu projektu, modalny formularz
tworzenia/edycji, historię wersji per encja z przywracaniem, wgrywanie ikon skilli oraz
eksport/import JSON. Zakładka Memories ma pasek filtrów tagów (z zarządzaniem tagami),
pasek aplikacji ma wyszukiwanie pełnotekstowe, dialog tworzenia połączenia i akcję migracji,
a zakładka Graph to widok relacji siłowo-kierunkowy z pan/zoom, przeciąganiem węzłów,
filtrami typów encji i podświetlaniem sąsiadów.
Graf rysuje Twoje jawne połączenia oraz niejawne huby — każda encja w zasięgu projektu łączy się ze swoim projektem, a wspomnienia dzielące tag łączą się z węzłem tagu — więc zawsze pokazuje strukturę.

## Dobre kuratorowanie

1. **Zeskanuj** każdy aktywny projekt raz (Knowledge → wybierz projekt → scan);
   ponów skanowanie po dużych zmianach w jego plikach instrukcyjnych.
2. **Awansuj świadomie**: tylko naprawdę wiążące reguły powinny być `critical`
   (są zawsze dostarczane przez konstruktor kontekstu). Użyj gwiazdki w wierszu
   i obserwuj miernik kontekstu krytycznego.
3. **Resztę trzymaj jako `high`/`normal`** — nadal przeszukiwalne i dostępne przez MCP
   tylko wtedy, gdy zapytanie pasuje, więc nie kosztują nic, gdy są nieistotne.
4. **Informacje osobiste** dla preferencji między projektami (strefa czasowa, edytor, nazewnictwo).
5. **Łącz powiązane wspomnienia**, żeby sąsiedzi 1 skoku jechali razem.
6. **Zainstaluj MCP** dla agentów, które powinny przeszukiwać bazę i utrwalać
   naukę; daj zakres `read` większości, `write` tam, gdzie ufasz agentowi.

## Migracja

Knowledge → menu → **Migrate existing rules** uruchamia raport **dry-run**: skanuje
wszystkie projekty, znajduje duplikaty istniejące między projektami (ten sam
znormalizowany tytuł + treść) i pokazuje liczby reguł. Stamtąd możesz **Merge duplicates**
(scala je w jeden globalny wiersz) i/lub **Make all rules critical**. Nic nie
jest zapisywane, dopóki nie potwierdzisz — destrukcyjne akcje są jawne.

**Dashboard** ma również pojedynczy przycisk **Importuj wszystko do ddagent**: uruchamia skanowanie projektu i import skilli agentów w jednej akcji, z tym samym podglądem dry-run i opcjonalnymi przełącznikami scalania duplikatów / promowania. Odczytuje wyłącznie pliki Twoich agentów i zapisuje do własnej bazy danych ddagent — żaden plik ani konfiguracja CLI nie są dotykane (jedyną akcją, która zapisuje w konfiguracji agenta, jest osobne "Install ddagent MCP server").

To samo menu ma **Importuj skille agentów**: wyświetla globalne/domyślne skille, które Twoi agenci już dostarczają lub mają zainstalowane (zakres użytkownika / systemu / wtyczki) i importuje brakujące do bazy wiedzy jako skille. Najpierw jest to dry-run i jest idempotentne — nazwa, która już istnieje, jest pomijana. Skille o zasięgu projektu są natomiast importowane przez skanowanie projektu.

## Warto wiedzieć

- Wszystko jest **lokalne** dla tej instancji ddagent; brak chmury, brak synchronizacji.
- Baza wiedzy **nie jest wstrzykiwana automatycznie** — agenci pobierają ją przez
  MCP na żądanie (model Contexta). Agenci bez zainstalowanego serwera MCP nie
  dostają z niej nic.
- Zeskanowane skille są osiągalne przez MCP (`knowledge_get_context` /
  `knowledge_search`), a nie wpychane do kontekstu.
- Reguła lub wspomnienie może być edytowane przez agenta przez MCP; przejrzyj zmiany w
  **Historii** encji i w razie potrzeby przywróć poprzednią wersję.

## REST API

Zamontowane pod `/api/knowledge` za uwierzytelnianiem:

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (rozmiar kontekstu krytycznego + budżet)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
POST   /import-skills       { providers?, scopes?, dryRun? }
POST   /import-all          { dryRun?, dedupe?, promoteRules? }
```

`projectId=global` ogranicza listę do globalnych wierszy; dodanie `includeGlobal=true`
do id projektu zwraca wiersze projektu plus globalne.

## Powiązane

- [ddagent jako serwer MCP](mcp-server.md) — katalog narzędzi i konfiguracja tokenu
- [Współpraca zespołowa](teams.md) · [Zdalne zatwierdzanie](remote-approvals.md)
