# Backend stream lifecycle — 2026-10-03

## Zakres i potwierdzone przyczyny

Przeczytano `AGENTS.md` oraz `.agents/skills/backend-module-standards/SKILL.md`.
Punktem wyjścia były przekazane fragmenty raportów step-1 (retencja, reconnect,
Stop → wiadomość) i step-2 (stan/kursor Fluttera) oraz aktualny kod. Pełnych
raportów step-1/step-2 nie było w przekazanym materiale. Zmiany dotyczą tylko
`server/`; istniejące cudze zmiany, w tym `multi-account-env.test.ts`, pozostawiono.

Potwierdzone w kodzie przed zmianą:

1. Rejestr odrzucał po zakończeniu tylko kolejny `complete`. Stary writer nadal
   publikował tekst, delty, narzędzia i błędy do aktualnych subskrybentów sesji.
   `session_created`/`setSessionId` mogły też nadpisać mapowanie w SQLite.
2. Timer retencji identyfikował turę przez ID sesji. Timer starszej tury mógł
   usunąć nowszą zakończoną turę przed upływem jej własnych pięciu minut.
3. Listener zakończenia uruchamiano przed zapisaniem i wysłaniem `complete`.
   Synchroniczny konsument mógł wystartować następną turę i wysłać jej fragment
   przed terminalną ramką poprzedniej.
4. Odrzucenie obietnicy już zatrzymanego runtime’u wracało jako błąd protokołu
   przypisany do sesji. Dodatkowo stary wrapper i `finally` delegacji mogły
   nadpisywać podgląd/status nowszej tury w transkrypcie rodzica.
5. Devin i Command Code uzależniały rozliczenie oczekujących żądań ACP po Stop
   od `close` procesu. Bez tego zdarzenia prompt pozostawał nierozliczony aż do
   timeoutu. Handler notyfikacji przyjmował również dane po zakończeniu/Stop,
   a zakończenie odczytu historii po Stop mogło zapisać fałszywy błąd timeoutu.

Nie potwierdzono w aktualnej wersji przechwytywania starego socketu w streamie:
`ChatSessionWriter` wysyła przez aktualne `ws` i dynamiczną listę subskrybentów,
zaś oba runtime’y ACP przełączają `state.currentWriter` przy kolejnym promptcie.
Te zachowania zabezpieczono testami. Retencja sama w sobie nie jest timeoutem
aktywnej generacji ani mechanizmem przełączania połączenia.

## Zmiany

- Każde zdarzenie i aktualizacja mapowania wymagają aktualnej, działającej tury.
  Po `complete` cały stream jest zamknięty, również dla spóźnionego providera.
- Retencja jest przypisana do konkretnego `runId`; timer przechowuje tylko
  identyfikatory, bez zatrzymywania bufora wszystkich zastąpionych tur w pamięci.
- Listener zakończenia jest wywoływany po zapisaniu i przekazaniu ramki terminalnej.
- Rozliczenie starego runtime’u i jego delegacji nie zmienia kolejnej tury.
- Po zaakceptowanym cancel ACP stan jest od razu oznaczany jako zakończony,
  pending requests są odrzucane i ich timery usuwane. Zachowano 200 ms na
  opróżnienie transportu. Niepowodzenie wysłania cancel nadal pozwala ponowić Stop.
- Notyfikacje zakończonego ACP są odrzucane; wynik odczytu finalnej odpowiedzi
  po Stop nie jest publikowany ani zapisywany jako nowa odpowiedź/błąd.
- Importy dotkniętej obsługi websocket używają publicznego barrel shared;
  dodano wyłącznie potrzebne reeksporty istniejących definicji.

## Sprawdzenia i dokładne komendy

Wszystkie polecenia wykonano w `/workspace/ddagent-src`.

Wstępny zestaw websocket (po poprawieniu brakujących reeksportów shared):

```bash
npx tsx --tsconfig server/tsconfig.json --test server/modules/websocket/tests/chat-run-registry.test.ts server/modules/websocket/tests/chat-websocket.service.test.ts server/modules/websocket/tests/chat-dispatch.service.test.ts
```

Wynik: 59/59 PASS. Pierwsze uruchomienie nie załadowało modułów z powodu
brakującego eksportu `getGlobalImageAssetsDir`; uzupełniono publiczny barrel.

Wstępne testy runtime’ów:

```bash
npx tsx --tsconfig server/tsconfig.json --test server/modules/providers/tests/runtime-lifecycle.test.ts
```

Wynik: 23/23 PASS. Następnie test ACP rozszerzono o normalne `end_turn`
i deduplikację finalnej odpowiedzi względem przesłanych fragmentów.

Końcowy rozszerzony zestaw:

```bash
npx tsx --tsconfig server/tsconfig.json --test server/modules/websocket/tests/*.test.ts server/modules/providers/tests/runtime-lifecycle.test.ts server/modules/providers/tests/devin-sessions.test.ts server/modules/providers/list/devin/devin-runtime.provider.test.js server/modules/providers/list/commandcode/commandcode-runtime.provider.test.js
```

Wynik: 120/120 PASS, 0 failed/cancelled/skipped. Log:
`/tmp/ddagent-stream-full-targeted.log`.

```bash
npm run typecheck
npx eslint server/modules/websocket/services/chat-dispatch.service.ts server/modules/websocket/services/chat-run-registry.service.ts server/modules/websocket/services/chat-session-writer.service.ts server/modules/websocket/tests/chat-dispatch.service.test.ts server/modules/websocket/tests/chat-run-registry.test.ts server/modules/websocket/tests/chat-websocket.service.test.ts server/modules/providers/list/devin/devin-runtime.provider.ts server/modules/providers/list/commandcode/commandcode-runtime.provider.ts server/modules/providers/tests/runtime-lifecycle.test.ts server/shared/index.ts
build_dir=$(mktemp -d /tmp/ddagent-stream-build.XXXXXX)
npx tsc -p server/tsconfig.json --outDir "$build_dir" && npx tsc-alias -p server/tsconfig.json --outDir "$build_dir"
git diff --check
```

Wyniki końcowe: wszystkie exit 0; ESLint bez błędów i ostrzeżeń.
W trakcie prac typecheck wykrył cyklicznie wywnioskowany typ atrapy procesu,
a lint powtórzone importy — obie usterki poprawiono przed końcowymi kontrolami.
Kompilacja korzysta z konfiguracji serwera i tsc-alias, ale nie promuje artefaktów
na działającej maszynie. Celowo nie uruchomiono `npm run build`/`build:server`,
których hook promuje `dist-server`, ani pełnego `npm test`/`npm run lint`;
pełne kontrole całego zadania pozostają dla późniejszej integracji.

Testy nie ograniczają się do liczenia wywołań atrap:

- Pięć cykli Stop → send dla każdego z siedmiu providerów przez prawdziwy
  dispatcher/rejestr i izolowaną bazę SQLite. Stop również przed pierwszą deltą,
  z runId pobranym przez istniejący `chat.subscribe`. Asercje dotyczą ramek,
  treści Unicode, sekwencji, pojedynczego complete i końcowego stanu sesji.
- Spóźnione fragmenty, text, error, complete oraz resolve/reject starego runtime’u
  nie zmieniają następnej tury ani nie generują błędu protokołu.
- Upływ rzeczywistego progu retencji (300001 ms na zegarze testowym), reconnect,
  kolejna wiadomość, ponowne rozłączenie w trakcie streamu i replay brakujących
  fragmentów: dokładnie `one two three four`, seq 1–4, bez ubytku/duplikacji.
- Osobne sprawdzenie timerów dwóch kolejnych tur, mapowania provider ID w SQLite,
  kolejności terminalnej ramki i następnego fragmentu oraz delegacji w bazie.
- Prawdziwy parser JSON-RPC i runtime ACP z transportem PassThrough: normalna
  odpowiedź, sześć minut bezczynności, nowy writer na tym samym stanie, Stop
  bez `close`, nowa instancja oraz spóźnione stdout/odpowiedź starej instancji.
  Sprawdzane są treść, ramki, statusy i brak dodatkowej finalnej kopii tekstu.
  Dla Devina także rzeczywisty plik JSONL: trzy odpowiedzi dokładnie raz,
  zachowana częściowa odpowiedź po Stop, brak spóźnionych danych i błędów.

## Wymagania późniejszej integracji

- Protokół Fluttera pozostaje zgodny: `kind`, `sessionId`, `runId`, `seq`,
  `chat_subscribed`, `complete`, `aborted`, `exitCode` mają istniejące znaczenie.
  Nie dodano nowego typu ramki ani obowiązkowego pola. Stop nadal wymaga
  aktualnego runId; klient powinien obsłużyć Stop przed pierwszą deltą przez
  uzyskanie/tożsamość tury, bez wysyłania starego lub brakującego runId.
- Kursor jest parą `(runId, seq)`. Po retencji ack ma `isProcessing:false`,
  `runId:null`, `lastSeq:0`; Flutter musi usunąć nieaktualny kursor i stan running.
  Zmieniony runId resetuje sekwencję. Ack poprzedza replay. Dla zakończonych tur
  historii nie odtwarza websocket: klient pobiera ją przez REST i uzgadnia
  wiersze realtime z odpowiedzią kanoniczną.
- Należy wspólnie z równoległą zmianą Fluttera sprawdzić długi bezruch,
  reconnect w trakcie odpowiedzi, natychmiastowy Stop, wiele Stop → send,
  częściowy tekst i finalny stan sesji. Testy lokalne nie uruchamiają prawdziwych
  CLI/SDK, chmury ani Fluttera. ACP nie ma runId w session/update; po zwykłym
  end_turn ponownie użyty proces opiera granicę promptów na kolejności ACP.
  Po Stop nowa instancja i zamknięty stan starej zapewniają izolację.
- Istotne niezmienione timeouty: retencja zakończonej tury **5 min**, bufor
  **5000 zdarzeń**; heartbeat websocket **30 s** (brak pong wykrywany w kolejnym
  tyknięciu). ACP control **120 s**, bezczynność promptu **6 h**, odnawiana
  przez session/update; próg uznania zajętego procesu za zastany **60 s**.
  Devin po end_turn czeka na ciszę **10 s**, przy nierozliczonym subagencie
  **150 s**, maksymalnie **15 min**, sprawdzając co **500 ms**. Odczyt finalnej
  odpowiedzi: do **120 ponowień co 500 ms** (~60 s). Flush cancel: **200 ms**.
  Integracja nie powinna uznawać dziesięciu sekund oczekiwania Devina za awarię.
- Zegary testowe przyspieszają czas, nie zmieniają produkcyjnych progów.
  Polling testów websocket ma limit **2 s**, testy ACP limit **10 s**.
- Późniejsze wdrożenie: build → wymagany sync patch-mirror (Claude runtime
  i Devin sessions) → weryfikacja → restart dopiero po jawnej zgodzie użytkownika.
  W tym kroku nie zmieniano dist-server ani patch-mirror, nie restartowano
  usług, nie zabijano rzeczywistych procesów ddagent/devin/opencode i nie pushowano.

## Weryfikacja integracyjna

### 1. Warunki odtworzenia
- Backend uruchomiony lokalnie na porcie `10087` (`http://127.0.0.1:10087` oraz `ws://127.0.0.1:10087/ws`), obsługa sesji REST oraz protokołu WebSocket `chat.send`, `chat.abort`, `chat.subscribe`.
- Modele darmowe przetestowane integracyjnie w pełnym przepływie:
  - OpenCode: `opencode/big-pickle`, `opencode/mimo-v2.6-flash-free`
  - Devin: `swe-2-high`, `swe-2-medium`
- Frontend: Flutter SDK 3.29.0 / Dart 3.7.0, test harness widgetów z `TestWidgetsFlutterBinding` symulujący mockowany transport websocket i REST API w pełnej izolacji od procesów tła.

### 2. Długość bezczynności użyta w testach
- **Testy regresyjne Fluttera (`flutter/test/session_stream_lifecycle_test.dart`)**:
  - Symulowana bezczynność: **6 minut (360 000 ms)** — celowo przekraczająca backendowy 5-minutowy (300 000 ms) próg retencji zakończonej tury.
  - Sprawdzono zachowanie: unieważnienie kursora `(runId, seq)` po ack `isProcessing: false, runId: null, lastSeq: 0`, reset lokalnego wskaźnika sekwencji, ponowne pobranie historii REST po powrocie połączenia i poprawny odbiór nowej tury po bezczynności.
- **Weryfikacja integracyjna WebSocket (`scripts/retest-chat-variations.mjs`, Variation E2)**:
  - Odstęp bezczynności: **2000 ms** realnej ciszy na gnieździe po zakończeniu poprzednich zdarzeń i subskrypcji, a następnie przesłanie nowej wiadomości `chat.send` na świeżo re-subskrybowanym / nowo zestawionym połączeniu socket.

### 3. Liczba cykli Stop → wiadomość
- **Testy regresyjne Fluttera (`session_stream_lifecycle_test.dart`)**:
  - Wykonano **5 kolejnych pełnych cykli Stop → nowa wiadomość** w ramach tej samej sesji.
  - Weryfikacja per cykl:
    - Natychmiastowe przejście UI w stan nieaktywny (`isProcessing: false`).
    - Zniknięcie przycisku Stop i natychmiastowy powrót przycisku wysyłania (Send).
    - Prawidłowe wygaszanie wskaźnika aktywności (usunięto błąd, w którym anulowany timer blokował kolejne wygaszenie).
    - Całkowita izolacja spóźnionych ramek `stream_delta` / `stream_end` ze starej tury — brak przenikania tekstu do nowej tury ani duplikacji.
    - Prawidłowe scalenie snapshotu REST po zakończeniu generacji bez powielania treści.
- **Weryfikacja integracyjna WebSocket (`scripts/retest-chat-variations.mjs`)**:
  - Cykl 1 (Variation D): wysłanie długiego promptu, odebranie 3 pierwszych delt, natychmiastowy `chat.abort` z poprawnym identyfikatorem `runId` bieżącej tury, weryfikacja ramki terminalnej `chat.complete` z `aborted: true, exitCode: 0`.
  - Cykl 2 (Variation D2): kolejny in-flight abort dla tej samej sesji w locie.
  - Kontynuacja (Variation D3): wysłanie kolejnej wiadomości po cyklach Stop, weryfikacja pełnego, czystego streamu do `chat.complete` (`exitCode: 0, aborted: false`) bez utraty i bez duplikacji fragmentów.

### 4. Wynik per scenariusz

| Scenariusz | Opis weryfikacji | Wynik |
|---|---|---|
| **(a) `chat.send` po dłuższej bezczynności / ponownym połączeniu gniazda** | Stream trafia do właściwego gniazda po upływie progu retencji (6 min w teście Fluttera, 2s idle gap w retest WS); kursor ulega prawidłowemu zresetowaniu; po reconnect odbiór kolejnych chunków bez utraty i duplikacji. | **PASS** |
| **(b) `chat.send` po zatrzymaniu przyciskiem Stop (wielokrotne cykle Stop → wiadomość)** | Poprawny stream w wielu cyklach (5 cykli w teście widgetowym Fluttera, cykle D/D2/D3 w teście integracyjnym WS); brak wycieków spóźnionych fragmentów; znikanie przycisku Stop i powrót przycisku Send; poprawne przekazanie `runId` w `chat.abort`; właściwy stan końcowy sesji i UI. | **PASS** |

### 5. Uruchomione komendy

1. Sprawdzenie stanu repozytorium i historii zmian:
   ```bash
   cd /workspace/ddagent-src && git status --short && git diff --name-only
   git log -3 --name-only
   ```
2. Weryfikacja lintera backendu (zgodnie z `backend-module-standards`):
   ```bash
   npx eslint server/modules/websocket/services/chat-dispatch.service.ts server/modules/websocket/services/chat-run-registry.service.ts server/modules/websocket/services/chat-session-writer.service.ts server/modules/websocket/tests/chat-dispatch.service.test.ts server/modules/websocket/tests/chat-run-registry.test.ts server/modules/websocket/tests/chat-websocket.service.test.ts server/modules/providers/list/devin/devin-runtime.provider.ts server/modules/providers/list/commandcode/commandcode-runtime.provider.ts server/modules/providers/tests/runtime-lifecycle.test.ts server/shared/index.ts
   ```
   *Wynik: 0 błędów, 0 ostrzeżeń.*
3. Weryfikacja testów regresyjnych Fluttera (w tym 6 min bezczynności, 5 cykli Stop→wiadomość, znikanie Stop, powrót Send, wygaszanie wskaźnika):
   ```bash
   cd /workspace/ddagent-src/flutter && flutter test test/session_stream_lifecycle_test.dart
   ```
   *Wynik: 6/6 PASS.*
4. Weryfikacja testów dotkniętych komponentów Fluttera:
   ```bash
   cd /workspace/ddagent-src/flutter && flutter test test/features/sessions/session_store_test.dart test/features/chat/repro_dup_test.dart test/features/chat/realtime_test.dart test/features/chat/transcript_test.dart test/features/chat/composer_ui_test.dart
   ```
   *Wynik: 49/49 PASS.*
5. Weryfikacja integracyjna przepływu backend → WebSocket:
   ```bash
   cd /workspace/ddagent-src && npx tsx scripts/retest-chat-variations.mjs --section=protocol
   cd /workspace/ddagent-src && npx tsx scripts/retest-chat-variations.mjs --section=opencode
   cd /workspace/ddagent-src && npx tsx scripts/retest-chat-variations.mjs --section=devin
   ```
   *Wynik:*
   - `protocol`: 7/7 PASS (100% PERFECT RUN)
   - `opencode`: 15/15 PASS (100% PERFECT RUN)
   - `devin`: 15/15 PASS (100% PERFECT RUN)

