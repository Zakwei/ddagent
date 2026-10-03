# Przegląd Stop → kolejna wiadomość (2026-10-02)

Przegląd statyczny siedmiu runtime’ów, bramy WebSocket i klienta Flutter.
Testy używają atrap; nie zatrzymywano rzeczywistych sesji ani usług.

## Poprawiona obsługa wspólna

`chat-websocket.service.ts`: odpowiedź na asynchroniczne zatrzymanie była
stosowana do sesji, zamiast do konkretnej tury. Poprzednia tura może zakończyć
się podczas oczekiwania na abort, a kolejna wystartować z kolejki lub od użytkownika.
Sukces abort kończył wtedy kolejną turę, a odmowa resetowała jej flagę abort.
Teraz wynik jest stosowany tylko do przechwyconej tury. Analogiczną ochronę
zakończenia zastosowano dla rodzica orchestratora.

Dodano 14 przypadków regresyjnych: sukces i odmowa opóźnionego abort dla każdego
providera. Testy sprawdzają, że nowa tura nadal działa i nie dostaje błędnego
complete/protocol_error.

## Ryzyka zidentyfikowane przed naprawą

| Agent | Wznowienie | Ustalenia wymagające dalszych poprawek |
| --- | --- | --- |
| Claude | SDK `resume` z identyfikatorem providera | Zwykły cleanup pętli sprawdza własność instancji, ale `abortClaudeSDKSession` po `await interrupt()` usuwa wpis po ID bez tego sprawdzenia. Przy zakończeniu i wznowieniu w tym oknie może usunąć nową instancję. |
| Codex | SDK `resumeThread` | `finally` w `queryCodex` zmienia status wpisu pobranego po ID sesji. Starsza zatrzymana tura może oznaczyć nowszą jako completed; również odczyty statusu abort są związane z ID zamiast własną instancją. |
| Cursor | CLI `--resume` | Callbacki close/error bezwarunkowo usuwają wpis po ID. Opóźnione wyjście zatrzymanego procesu może usunąć uchwyt nowego procesu, przez co następny Stop nie zadziała. Retry workspace trust jest sprawdzany przed flagą aborted. |
| Antigravity | CLI `--conversation` | Callbacki close/error bezwarunkowo usuwają wpis po ID; analogiczne ryzyko utraty uchwytu nowego procesu jak w Cursor. |
| OpenCode | Istniejąca sesja HTTP | Abort ustawia aborted, ignoruje błąd HTTP i zwraca true. Interfejs może pokazać zatrzymanie, chociaż serwer nadal generuje. Cleanup chroni activeRuns, ale usuwa mapping, tryb i permissions po ID sesji bez pełnej ochrony własności. |
| Devin | ACP `session/load` | Nieudane load przechodzi na session/new, co może utracić kontekst providera mimo historii widocznej w aplikacji. Abort po błędzie wysyłania cancel nadal zwraca true; blok catch może pominąć cleanup. |
| Command Code | ACP `session/load` | Ten sam fallback load → new i ignorowanie wyjątku podczas abort co w Devin. |

Klient Flutter wysyła `chat.abort` bez runId. Zakończenie jest skorelowane przez
bramę z przechwyconą turą, ale opóźnione samo żądanie Stop nadal może trafić do
nowszej tury. Osobne zabezpieczenie protokołu wymaga przesyłania i walidacji runId.

Wniosek: wspólny wyścig odpowiedzi na Stop naprawiono; nie ma podstaw, by uznać
wszystkie runtime’y za bezpieczne przy natychmiastowym wznowieniu. Powyższe
ryzyka wynikają z kodu i wymagają osobnych testów cyklu życia runtime’ów.

## Naprawa pozostałych ryzyk (2026-10-02)

Wszystkie powyższe ustalenia zostały zaadresowane:

- Claude i Codex wiążą abort, status i cleanup z konkretną instancją tury.
- Cursor i Antigravity usuwają uchwyty tylko wtedy, gdy nadal należą do
  kończącego się procesu. Zatrzymany Cursor nie ponawia workspace trust.
- OpenCode chroni mapping, tryb i permissions przed cleanupem starej tury;
  błąd HTTP lub odpowiedź `false` na abort pozostawia turę aktywną i zwraca odmowę.
- Devin i Command Code zgłaszają błąd wznowienia zamiast tworzyć nową rozmowę.
  Nieudany cancel zwraca odmowę i zachowuje uchwyt do ponownego Stop;
  błąd zabijania procesu nie pomija cleanupu po zaakceptowanym cancel.
- Flutter przesyła `runId` przy Stop, a brama odrzuca brakujący lub nieaktualny
  identyfikator przed wywołaniem runtime’u. Abort orchestratora również chroni
  własność tury i obsługuje odmowę anulowania.

Testy cyklu życia runtime’ów i bramy używają atrap transportów i procesów.
Nie stanowią sprawdzenia integracyjnego rzeczywistych SDK ani usług ACP.
Nie restartowano usług ani nie zatrzymywano rzeczywistych sesji.
