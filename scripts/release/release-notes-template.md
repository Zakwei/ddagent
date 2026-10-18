<!--
  GitHub draft-release body template — the server-release workflow
  (.github/workflows/server-release.yml) passes this file to
  `gh release create --notes-file`, so every draft release created on a tag
  starts with this body.

  AGENTS.md requires per-language release notes split by
  `<!-- lang:<code> -->` markers — the Flutter Settings → About changelog
  renders only the section matching the active UI language, `en` is the
  fallback. All 12 UI locales are below.
-->
<!-- lang:en -->
### What's new
- **Preview pane**: agents can show the app they are building live inside the workspace. The new toolbar button (next to the browser globe) opens a pane that renders a URL inside a phone, tablet, browser or desktop-window frame, scaled to fit, with rotation and device presets (iPhone, Pixel, Galaxy, iPad, Android tablet, 1366/1920 browser, 1280/1440 window). Phone presets use real mobile emulation (touch, phone user agent, viewport), so responsive apps show their phone layout. Agents drive it through new MCP tools on the DDAgent server: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — install the server from Settings → MCP.
- **OpenCode 2**: the OpenCode provider now talks to the OpenCode 2 API (`@opencode/cli`): authenticated server, the new event stream, question forms, per-session model/agent selection. Transcripts from OpenCode 1 stay visible; install/update commands point at the new package.
- **Terminal**: Windows Terminal style tab row (profiles dropdown, drag to reorder, middle-click to close, rename/duplicate), Campbell and One Half Light colour schemes, the Windows Terminal keyboard shortcuts (⌘ equivalents on macOS), find-in-buffer with match counter, Ctrl+wheel / pinch zoom, and a redesigned touch key bar with sticky Ctrl/Alt and a copy/paste toolbar. Each extra tab gets its own shell.
### Fixes
- Terminal: Claude Code, OpenCode and Codex startup handshakes no longer underline everything or print stray `+q4d73` text; the pane answers colour and mode probes so CLIs pick the right theme instead of waiting on timeouts; only real sign-in URLs light up the login banner.
- Terminal: typing works on Windows desktop; the key-bar toggle stays reachable in narrow panes; Ctrl+Shift+F no longer toggles focus mode while a terminal has focus.
- Accounts: a usage-limit switch on a session's first turn now carries the transcript to the new account instead of failing with "No conversation found".
- Chat: inline code spans show the selection highlight when you select text across them.
- Workspace: a pane stays "working" while Claude background tasks are still running and turns green only once they settle.
<!-- lang:pl -->
### Nowości
- **Panel Podgląd**: agent może pokazać na żywo aplikację, którą buduje, prosto w workspace. Nowy przycisk na pasku (obok globusa przeglądarki) otwiera panel renderujący adres URL w ramce telefonu, tabletu, przeglądarki albo okna desktopowego, dopasowanej do panelu, z obrotem i presetami urządzeń (iPhone, Pixel, Galaxy, iPad, tablet Android, przeglądarka 1366/1920, okno 1280/1440). Presety telefonów używają prawdziwej emulacji mobilnej (dotyk, UA telefonu, viewport), więc responsywne aplikacje pokazują układ telefonu. Agent steruje panelem przez nowe narzędzia MCP serwera DDAgent: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — zainstaluj serwer w Ustawienia → MCP.
- **OpenCode 2**: dostawca OpenCode rozmawia teraz z API OpenCode 2 (`@opencode/cli`): uwierzytelniony serwer, nowy strumień zdarzeń, pytania jako formularze, wybór modelu/agenta na sesję. Transkrypty z OpenCode 1 pozostają widoczne; polecenia instalacji i aktualizacji wskazują nowy pakiet.
- **Terminal**: pasek kart w stylu Windows Terminal (lista profili, przeciąganie kart, zamykanie środkowym przyciskiem, zmiana nazwy/duplikowanie), schematy kolorów Campbell i One Half Light, skróty klawiszowe Windows Terminal (odpowiedniki ⌘ na macOS), wyszukiwanie w buforze z licznikiem trafień, zoom Ctrl+kółko / szczypnięcie oraz przeprojektowany dotykowy pasek klawiszy z przyklejanymi Ctrl/Alt i paskiem kopiuj/wklej. Każda dodatkowa karta dostaje własną powłokę.
### Poprawki
- Terminal: handshake startowy Claude Code, OpenCode i Codex nie podkreśla już całego tekstu ani nie wypisuje śmieciowego `+q4d73`; panel odpowiada na zapytania o kolory i tryby, więc CLI dobierają właściwy motyw zamiast czekać na timeout; baner logowania zapala się tylko dla prawdziwych adresów logowania.
- Terminal: pisanie działa na Windows desktop; przełącznik paska klawiszy pozostaje osiągalny w wąskich panelach; Ctrl+Shift+F nie przełącza już trybu skupienia, gdy terminal ma fokus.
- Konta: przełączenie konta po limicie w pierwszej turze sesji przenosi transkrypt na nowe konto zamiast kończyć się błędem „No conversation found”.
- Czat: fragmenty kodu w linii pokazują podświetlenie zaznaczenia, gdy zaznaczasz tekst przez nie.
- Workspace: panel pozostaje „w pracy”, dopóki działają zadania w tle Claude, i zielenieje dopiero, gdy się zakończą.
<!-- lang:de -->
### Neu
- **Vorschau-Bereich**: Agenten können die App, die sie bauen, live im Workspace zeigen. Der neue Button in der Symbolleiste (neben dem Browser-Globus) öffnet einen Bereich, der eine URL in einem Smartphone-, Tablet-, Browser- oder Desktop-Fensterrahmen passend skaliert darstellt, mit Drehung und Geräte-Presets (iPhone, Pixel, Galaxy, iPad, Android-Tablet, Browser 1366/1920, Fenster 1280/1440). Smartphone-Presets nutzen echte Mobil-Emulation (Touch, Handy-User-Agent, Viewport), sodass responsive Apps ihr Handy-Layout zeigen. Agenten steuern den Bereich über neue MCP-Tools des DDAgent-Servers: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — Server unter Einstellungen → MCP installieren.
- **OpenCode 2**: Der OpenCode-Provider spricht jetzt die OpenCode-2-API (`@opencode/cli`): authentifizierter Server, neuer Ereignisstrom, Fragen als Formulare, Modell-/Agent-Auswahl pro Sitzung. Transkripte aus OpenCode 1 bleiben sichtbar; Installations- und Update-Befehle zeigen auf das neue Paket.
- **Terminal**: Tableiste im Stil von Windows Terminal (Profil-Dropdown, Ziehen zum Sortieren, Mittelklick zum Schließen, Umbenennen/Duplizieren), Farbschemata Campbell und One Half Light, die Windows-Terminal-Tastenkürzel (⌘-Entsprechungen auf macOS), Suche im Puffer mit Trefferzähler, Zoom per Strg+Mausrad / Pinch und eine neu gestaltete Touch-Tastenleiste mit haftendem Strg/Alt und Kopieren/Einfügen-Leiste. Jeder weitere Tab bekommt eine eigene Shell.
### Fehlerbehebungen
- Terminal: Die Start-Handshakes von Claude Code, OpenCode und Codex unterstreichen nicht mehr alles und geben kein `+q4d73` mehr aus; der Bereich beantwortet Farb- und Modusabfragen, sodass CLIs das richtige Theme wählen statt auf Timeouts zu warten; nur echte Anmelde-URLs aktivieren das Login-Banner.
- Terminal: Tippen funktioniert unter Windows Desktop; der Tastenleisten-Schalter bleibt in schmalen Bereichen erreichbar; Strg+Umschalt+F schaltet den Fokusmodus nicht mehr um, solange ein Terminal den Fokus hat.
- Konten: Ein Kontowechsel wegen Nutzungslimit im ersten Zug einer Sitzung nimmt das Transkript jetzt mit statt mit „No conversation found“ zu scheitern.
- Chat: Inline-Code zeigt die Auswahlmarkierung, wenn du Text darüber hinweg markierst.
- Workspace: Ein Bereich bleibt „in Arbeit“, solange Claude-Hintergrundaufgaben laufen, und wird erst grün, wenn sie abgeschlossen sind.
<!-- lang:es -->
### Novedades
- **Panel de vista previa**: los agentes pueden mostrar en vivo la app que están construyendo dentro del espacio de trabajo. El nuevo botón de la barra (junto al globo del navegador) abre un panel que renderiza una URL dentro de un marco de teléfono, tableta, navegador o ventana de escritorio, ajustado al panel, con rotación y presets de dispositivo (iPhone, Pixel, Galaxy, iPad, tableta Android, navegador 1366/1920, ventana 1280/1440). Los presets de teléfono usan emulación móvil real (táctil, user agent de móvil, viewport), así que las apps responsivas muestran su diseño de teléfono. Los agentes lo controlan con nuevas herramientas MCP del servidor DDAgent: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices`; instala el servidor en Ajustes → MCP.
- **OpenCode 2**: el proveedor OpenCode ahora usa la API de OpenCode 2 (`@opencode/cli`): servidor autenticado, nuevo flujo de eventos, preguntas como formularios, selección de modelo/agente por sesión. Las transcripciones de OpenCode 1 siguen visibles; los comandos de instalación y actualización apuntan al paquete nuevo.
- **Terminal**: fila de pestañas al estilo Windows Terminal (desplegable de perfiles, arrastrar para reordenar, clic central para cerrar, renombrar/duplicar), esquemas de color Campbell y One Half Light, los atajos de teclado de Windows Terminal (equivalentes ⌘ en macOS), búsqueda en el búfer con contador de coincidencias, zoom con Ctrl+rueda / pellizco y una barra de teclas táctil rediseñada con Ctrl/Alt persistentes y barra de copiar/pegar. Cada pestaña adicional tiene su propio shell.
### Correcciones
- Terminal: los handshakes de inicio de Claude Code, OpenCode y Codex ya no subrayan todo ni imprimen texto `+q4d73` suelto; el panel responde a las consultas de color y modo para que las CLI elijan el tema correcto en lugar de esperar timeouts; solo las URL de inicio de sesión reales encienden el banner de login.
- Terminal: escribir funciona en Windows de escritorio; el interruptor de la barra de teclas sigue accesible en paneles estrechos; Ctrl+Mayús+F ya no alterna el modo enfoque mientras un terminal tiene el foco.
- Cuentas: un cambio de cuenta por límite de uso en el primer turno de una sesión ahora lleva la transcripción a la nueva cuenta en vez de fallar con «No conversation found».
- Chat: los fragmentos de código en línea muestran el resaltado de selección al seleccionar texto a través de ellos.
- Espacio de trabajo: un panel sigue «trabajando» mientras haya tareas en segundo plano de Claude y se pone verde solo cuando terminan.
<!-- lang:fr -->
### Nouveautés
- **Volet Aperçu** : les agents peuvent montrer en direct l'application qu'ils construisent dans l'espace de travail. Le nouveau bouton de la barre d'outils (à côté du globe du navigateur) ouvre un volet qui affiche une URL dans un cadre de téléphone, de tablette, de navigateur ou de fenêtre de bureau, mis à l'échelle, avec rotation et préréglages d'appareils (iPhone, Pixel, Galaxy, iPad, tablette Android, navigateur 1366/1920, fenêtre 1280/1440). Les préréglages téléphone utilisent une vraie émulation mobile (tactile, user agent mobile, viewport), les apps responsives affichent donc leur mise en page téléphone. Les agents le pilotent via de nouveaux outils MCP du serveur DDAgent : `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — installez le serveur dans Paramètres → MCP.
- **OpenCode 2** : le fournisseur OpenCode utilise désormais l'API OpenCode 2 (`@opencode/cli`) : serveur authentifié, nouveau flux d'événements, questions sous forme de formulaires, choix du modèle/agent par session. Les transcriptions d'OpenCode 1 restent visibles ; les commandes d'installation et de mise à jour pointent vers le nouveau paquet.
- **Terminal** : barre d'onglets façon Windows Terminal (menu des profils, glisser pour réordonner, clic molette pour fermer, renommer/dupliquer), thèmes Campbell et One Half Light, les raccourcis clavier de Windows Terminal (équivalents ⌘ sur macOS), recherche dans le tampon avec compteur, zoom Ctrl+molette / pincement et une barre de touches tactile repensée avec Ctrl/Alt persistants et une barre copier/coller. Chaque onglet supplémentaire a son propre shell.
### Corrections
- Terminal : les handshakes de démarrage de Claude Code, OpenCode et Codex ne soulignent plus tout et n'affichent plus de texte `+q4d73` parasite ; le volet répond aux requêtes de couleur et de mode pour que les CLI choisissent le bon thème au lieu d'attendre des délais ; seules les vraies URL de connexion allument la bannière de connexion.
- Terminal : la saisie fonctionne sur Windows bureau ; le bouton de la barre de touches reste accessible dans les volets étroits ; Ctrl+Maj+F ne bascule plus le mode focus quand un terminal a le focus.
- Comptes : un changement de compte pour limite d'usage au premier tour d'une session emporte désormais la transcription au lieu d'échouer avec « No conversation found ».
- Chat : le code en ligne affiche la surbrillance de sélection quand vous sélectionnez du texte à travers lui.
- Espace de travail : un volet reste « en cours » tant que des tâches d'arrière-plan Claude tournent et ne passe au vert qu'une fois terminées.
<!-- lang:it -->
### Novità
- **Riquadro Anteprima**: gli agenti possono mostrare dal vivo l'app che stanno costruendo dentro il workspace. Il nuovo pulsante della barra (accanto al globo del browser) apre un riquadro che renderizza un URL in una cornice di telefono, tablet, browser o finestra desktop, adattata al riquadro, con rotazione e preset di dispositivi (iPhone, Pixel, Galaxy, iPad, tablet Android, browser 1366/1920, finestra 1280/1440). I preset telefono usano una vera emulazione mobile (touch, user agent da telefono, viewport), così le app responsive mostrano il layout da telefono. Gli agenti lo guidano con i nuovi strumenti MCP del server DDAgent: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — installa il server da Impostazioni → MCP.
- **OpenCode 2**: il provider OpenCode usa ora l'API di OpenCode 2 (`@opencode/cli`): server autenticato, nuovo flusso di eventi, domande come moduli, scelta di modello/agente per sessione. Le trascrizioni di OpenCode 1 restano visibili; i comandi di installazione e aggiornamento puntano al nuovo pacchetto.
- **Terminale**: barra delle schede in stile Windows Terminal (menu dei profili, trascina per riordinare, clic centrale per chiudere, rinomina/duplica), schemi colore Campbell e One Half Light, le scorciatoie di Windows Terminal (equivalenti ⌘ su macOS), ricerca nel buffer con contatore, zoom Ctrl+rotella / pizzico e una barra tasti touch ridisegnata con Ctrl/Alt persistenti e barra copia/incolla. Ogni scheda aggiuntiva ha la propria shell.
### Correzioni
- Terminale: gli handshake di avvio di Claude Code, OpenCode e Codex non sottolineano più tutto né stampano testo `+q4d73` spurio; il riquadro risponde alle richieste di colore e modalità così le CLI scelgono il tema giusto invece di attendere timeout; solo i veri URL di accesso accendono il banner di login.
- Terminale: la digitazione funziona su Windows desktop; l'interruttore della barra tasti resta raggiungibile nei riquadri stretti; Ctrl+Maiusc+F non attiva più la modalità focus mentre un terminale ha il focus.
- Account: un cambio di account per limite d'uso al primo turno di una sessione ora porta con sé la trascrizione invece di fallire con «No conversation found».
- Chat: il codice inline mostra l'evidenziazione della selezione quando selezioni testo attraverso di esso.
- Workspace: un riquadro resta «al lavoro» finché girano attività in background di Claude e diventa verde solo quando terminano.
<!-- lang:ja -->
### 新機能
- **プレビューペイン**：エージェントが開発中のアプリをワークスペース内でライブ表示できます。ツールバーの新しいボタン（ブラウザの地球儀の隣）で開くペインは、URL をスマホ・タブレット・ブラウザ・デスクトップウィンドウのフレーム内に収めて表示し、回転とデバイスプリセット（iPhone、Pixel、Galaxy、iPad、Android タブレット、ブラウザ 1366/1920、ウィンドウ 1280/1440）に対応します。スマホのプリセットは実際のモバイルエミュレーション（タッチ、スマホの User-Agent、ビューポート）を使うため、レスポンシブなアプリはスマホ用レイアウトで表示されます。エージェントは DDAgent サーバーの新しい MCP ツール `preview_open`、`preview_update`、`preview_reload`、`preview_close`、`preview_list`、`preview_devices` で操作します。サーバーは設定 → MCP からインストールしてください。
- **OpenCode 2**：OpenCode プロバイダーが OpenCode 2 API（`@opencode/cli`）に対応しました。認証付きサーバー、新しいイベントストリーム、フォーム形式の質問、セッションごとのモデル／エージェント選択。OpenCode 1 のトランスクリプトは引き続き表示され、インストール／更新コマンドは新パッケージを指します。
- **ターミナル**：Windows Terminal 風のタブ行（プロファイルのドロップダウン、ドラッグで並べ替え、中クリックで閉じる、名前変更／複製）、Campbell と One Half Light の配色、Windows Terminal のキーボードショートカット（macOS では ⌘）、一致数付きのバッファ内検索、Ctrl+ホイール／ピンチズーム、固定 Ctrl/Alt とコピー／貼り付けバーを備えた新しいタッチキーバー。追加タブごとに独自のシェルが開きます。
### 修正
- ターミナル：Claude Code、OpenCode、Codex の起動ハンドシェイクで全体に下線が付いたり `+q4d73` が表示されたりしなくなりました。ペインが色とモードの問い合わせに応答するため、CLI はタイムアウトを待たず正しいテーマを選べます。ログインバナーは本当のサインイン URL にだけ点灯します。
- ターミナル：Windows デスクトップで入力できるようになりました。キーバーの切り替えは狭いペインでも届きます。ターミナルにフォーカスがあるとき Ctrl+Shift+F がフォーカスモードを切り替えなくなりました。
- アカウント：セッションの最初のターンで使用上限によるアカウント切り替えが起きても、「No conversation found」で失敗せずトランスクリプトを新しいアカウントへ引き継ぎます。
- チャット：インラインコードをまたいでテキストを選択したとき、選択ハイライトが表示されます。
- ワークスペース：Claude のバックグラウンドタスクが動いている間はペインが「作業中」のままになり、完了してから緑になります。
<!-- lang:ko -->
### 새로운 기능
- **미리보기 창**: 에이전트가 만들고 있는 앱을 워크스페이스 안에서 실시간으로 보여줄 수 있습니다. 도구 모음의 새 버튼(브라우저 지구본 옆)은 URL을 휴대폰, 태블릿, 브라우저 또는 데스크톱 창 프레임 안에 맞춰 렌더링하는 창을 열며, 회전과 기기 프리셋(iPhone, Pixel, Galaxy, iPad, Android 태블릿, 브라우저 1366/1920, 창 1280/1440)을 지원합니다. 휴대폰 프리셋은 실제 모바일 에뮬레이션(터치, 휴대폰 사용자 에이전트, 뷰포트)을 사용하므로 반응형 앱이 휴대폰 레이아웃으로 표시됩니다. 에이전트는 DDAgent 서버의 새 MCP 도구 `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices`로 제어합니다. 설정 → MCP에서 서버를 설치하세요.
- **OpenCode 2**: OpenCode 제공자가 이제 OpenCode 2 API(`@opencode/cli`)를 사용합니다. 인증된 서버, 새 이벤트 스트림, 양식 형태의 질문, 세션별 모델/에이전트 선택. OpenCode 1의 기록은 계속 표시되며 설치/업데이트 명령은 새 패키지를 가리킵니다.
- **터미널**: Windows Terminal 스타일 탭 행(프로필 드롭다운, 드래그로 순서 변경, 가운데 클릭으로 닫기, 이름 변경/복제), Campbell 및 One Half Light 색 구성표, Windows Terminal 키보드 단축키(macOS에서는 ⌘), 일치 수가 표시되는 버퍼 검색, Ctrl+휠/핀치 확대, 고정 Ctrl/Alt와 복사/붙여넣기 바가 있는 새 터치 키 바. 추가 탭마다 자체 셸이 열립니다.
### 수정
- 터미널: Claude Code, OpenCode, Codex의 시작 핸드셰이크가 더 이상 모든 텍스트에 밑줄을 긋거나 `+q4d73` 문자를 출력하지 않습니다. 창이 색상과 모드 질의에 응답하므로 CLI가 타임아웃을 기다리지 않고 올바른 테마를 고릅니다. 로그인 배너는 실제 로그인 URL에만 표시됩니다.
- 터미널: Windows 데스크톱에서 입력이 작동합니다. 좁은 창에서도 키 바 토글에 접근할 수 있습니다. 터미널에 포커스가 있을 때 Ctrl+Shift+F가 포커스 모드를 전환하지 않습니다.
- 계정: 세션 첫 턴에서 사용량 한도로 계정이 전환될 때 "No conversation found" 오류 대신 기록을 새 계정으로 가져갑니다.
- 채팅: 인라인 코드를 가로질러 텍스트를 선택하면 선택 강조가 표시됩니다.
- 워크스페이스: Claude 백그라운드 작업이 실행 중인 동안 창이 "작업 중" 상태를 유지하고, 끝난 뒤에야 녹색으로 바뀝니다.
<!-- lang:ru -->
### Что нового
- **Панель предпросмотра**: агенты могут показывать создаваемое приложение вживую прямо в рабочем пространстве. Новая кнопка на панели инструментов (рядом с глобусом браузера) открывает панель, которая отображает URL в рамке телефона, планшета, браузера или окна рабочего стола с подгонкой по размеру, поворотом и пресетами устройств (iPhone, Pixel, Galaxy, iPad, планшет Android, браузер 1366/1920, окно 1280/1440). Пресеты телефонов используют настоящую мобильную эмуляцию (касания, мобильный user agent, viewport), поэтому адаптивные приложения показывают телефонную раскладку. Агенты управляют панелью через новые MCP-инструменты сервера DDAgent: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — установите сервер в Настройки → MCP.
- **OpenCode 2**: провайдер OpenCode теперь работает с API OpenCode 2 (`@opencode/cli`): сервер с аутентификацией, новый поток событий, вопросы в виде форм, выбор модели/агента на сессию. Транскрипты OpenCode 1 остаются видимыми; команды установки и обновления указывают на новый пакет.
- **Терминал**: ряд вкладок в стиле Windows Terminal (список профилей, перетаскивание, закрытие средней кнопкой, переименование/дублирование), цветовые схемы Campbell и One Half Light, сочетания клавиш Windows Terminal (с аналогами ⌘ на macOS), поиск по буферу со счётчиком совпадений, масштаб Ctrl+колесо / щипок и переработанная сенсорная панель клавиш с «липкими» Ctrl/Alt и панелью копировать/вставить. Каждая дополнительная вкладка получает собственную оболочку.
### Исправления
- Терминал: стартовые рукопожатия Claude Code, OpenCode и Codex больше не подчёркивают весь текст и не выводят лишнее `+q4d73`; панель отвечает на запросы цветов и режимов, поэтому CLI выбирают правильную тему вместо ожидания таймаутов; баннер входа загорается только для настоящих URL авторизации.
- Терминал: ввод работает в настольной версии для Windows; переключатель панели клавиш доступен в узких панелях; Ctrl+Shift+F больше не переключает режим фокуса, пока терминал в фокусе.
- Аккаунты: переключение аккаунта по лимиту на первом ходу сессии теперь переносит транскрипт вместо ошибки «No conversation found».
- Чат: встроенный код показывает подсветку выделения, когда вы выделяете текст через него.
- Рабочее пространство: панель остаётся «в работе», пока выполняются фоновые задачи Claude, и зеленеет только после их завершения.
<!-- lang:tr -->
### Yenilikler
- **Önizleme bölmesi**: ajanlar geliştirdikleri uygulamayı çalışma alanında canlı gösterebilir. Araç çubuğundaki yeni düğme (tarayıcı küresinin yanında), bir URL'yi telefon, tablet, tarayıcı veya masaüstü penceresi çerçevesi içinde bölmeye sığdırarak gösteren bir bölme açar; döndürme ve cihaz ön ayarları (iPhone, Pixel, Galaxy, iPad, Android tablet, tarayıcı 1366/1920, pencere 1280/1440) vardır. Telefon ön ayarları gerçek mobil emülasyon (dokunma, telefon user agent'ı, görünüm alanı) kullanır, böylece duyarlı uygulamalar telefon düzenini gösterir. Ajanlar bölmeyi DDAgent sunucusunun yeni MCP araçlarıyla yönetir: `preview_open`, `preview_update`, `preview_reload`, `preview_close`, `preview_list`, `preview_devices` — sunucuyu Ayarlar → MCP'den yükleyin.
- **OpenCode 2**: OpenCode sağlayıcısı artık OpenCode 2 API'sini (`@opencode/cli`) kullanıyor: kimlik doğrulamalı sunucu, yeni olay akışı, form olarak sorular, oturum başına model/ajan seçimi. OpenCode 1 dökümleri görünür kalır; yükleme/güncelleme komutları yeni pakete işaret eder.
- **Terminal**: Windows Terminal tarzı sekme satırı (profil menüsü, sürükleyerek sıralama, orta tıkla kapatma, yeniden adlandırma/çoğaltma), Campbell ve One Half Light renk şemaları, Windows Terminal klavye kısayolları (macOS'ta ⌘ karşılıkları), eşleşme sayaçlı arabellekte arama, Ctrl+tekerlek / kıstırma yakınlaştırma ve yapışkan Ctrl/Alt ile kopyala/yapıştır çubuğu olan yenilenmiş dokunmatik tuş çubuğu. Her ek sekme kendi kabuğunu alır.
### Düzeltmeler
- Terminal: Claude Code, OpenCode ve Codex başlangıç el sıkışmaları artık her şeyin altını çizmiyor ve `+q4d73` metni basmıyor; bölme renk ve mod sorgularını yanıtladığı için CLI'lar zaman aşımı beklemek yerine doğru temayı seçiyor; giriş afişi yalnızca gerçek oturum açma URL'lerinde yanıyor.
- Terminal: Windows masaüstünde yazma çalışıyor; tuş çubuğu düğmesi dar bölmelerde erişilebilir kalıyor; bir terminal odaktayken Ctrl+Shift+F odak modunu değiştirmiyor.
- Hesaplar: bir oturumun ilk turunda kullanım sınırı nedeniyle hesap değişimi artık "No conversation found" hatası yerine dökümü yeni hesaba taşıyor.
- Sohbet: satır içi kod, üzerinden metin seçtiğinizde seçim vurgusunu gösteriyor.
- Çalışma alanı: Claude arka plan görevleri sürerken bölme "çalışıyor" kalır ve ancak bittiğinde yeşile döner.
<!-- lang:zh-CN -->
### 新功能
- **预览面板**：智能体可以在工作区中实时展示正在构建的应用。工具栏的新按钮（浏览器地球图标旁）会打开一个面板，把 URL 渲染在手机、平板、浏览器或桌面窗口边框内并缩放适配，支持旋转和设备预设（iPhone、Pixel、Galaxy、iPad、Android 平板、1366/1920 浏览器、1280/1440 窗口）。手机预设使用真实的移动端模拟（触控、手机 UA、视口），响应式应用会显示手机布局。智能体通过 DDAgent 服务器的新 MCP 工具 `preview_open`、`preview_update`、`preview_reload`、`preview_close`、`preview_list`、`preview_devices` 控制面板，请在设置 → MCP 中安装服务器。
- **OpenCode 2**：OpenCode 提供方现已对接 OpenCode 2 API（`@opencode/cli`）：带认证的服务器、新的事件流、表单式提问、按会话选择模型/智能体。OpenCode 1 的记录仍可查看；安装/更新命令指向新包。
- **终端**：Windows Terminal 风格的标签行（配置下拉、拖动排序、中键关闭、重命名/复制）、Campbell 与 One Half Light 配色、Windows Terminal 键盘快捷键（macOS 上为 ⌘）、带匹配计数的缓冲区查找、Ctrl+滚轮 / 捏合缩放，以及重新设计的触控按键栏（粘滞 Ctrl/Alt、复制/粘贴工具栏）。每个新增标签都有自己的 shell。
### 修复
- 终端：Claude Code、OpenCode 和 Codex 的启动握手不再给所有文字加下划线或打印多余的 `+q4d73`；面板会回应颜色和模式查询，CLI 能选对主题而不必等待超时；只有真正的登录 URL 才会点亮登录横幅。
- 终端：Windows 桌面端可以正常输入；按键栏开关在窄面板中仍可触达；终端获得焦点时 Ctrl+Shift+F 不再切换专注模式。
- 账户：会话首轮因用量上限切换账户时，会把记录带到新账户，而不是报错“No conversation found”。
- 聊天：跨行内代码选择文字时会显示选中高亮。
- 工作区：Claude 后台任务仍在运行时面板保持“工作中”，任务结束后才变绿。
<!-- lang:zh-TW -->
### 新功能
- **預覽面板**：代理程式可以在工作區中即時展示正在建構的應用程式。工具列的新按鈕（瀏覽器地球圖示旁）會開啟一個面板，把 URL 呈現在手機、平板、瀏覽器或桌面視窗外框內並縮放貼合，支援旋轉與裝置預設（iPhone、Pixel、Galaxy、iPad、Android 平板、1366/1920 瀏覽器、1280/1440 視窗）。手機預設使用真實的行動模擬（觸控、手機 UA、視口），回應式應用程式會顯示手機版面。代理程式透過 DDAgent 伺服器的新 MCP 工具 `preview_open`、`preview_update`、`preview_reload`、`preview_close`、`preview_list`、`preview_devices` 控制面板，請在設定 → MCP 安裝伺服器。
- **OpenCode 2**：OpenCode 提供者現已改用 OpenCode 2 API（`@opencode/cli`）：具驗證的伺服器、新的事件串流、表單式提問、依工作階段選擇模型／代理程式。OpenCode 1 的紀錄仍可檢視；安裝／更新指令指向新套件。
- **終端機**：Windows Terminal 風格的分頁列（設定檔下拉、拖曳排序、中鍵關閉、重新命名／複製）、Campbell 與 One Half Light 配色、Windows Terminal 鍵盤快捷鍵（macOS 為 ⌘）、含比對計數的緩衝區搜尋、Ctrl+滾輪／捏合縮放，以及重新設計的觸控按鍵列（黏滯 Ctrl/Alt、複製／貼上工具列）。每個額外分頁都有自己的 shell。
### 修正
- 終端機：Claude Code、OpenCode 與 Codex 的啟動交握不再為所有文字加底線或印出多餘的 `+q4d73`；面板會回應顏色與模式查詢，CLI 能選對主題而不必等待逾時；只有真正的登入 URL 才會亮起登入橫幅。
- 終端機：Windows 桌面版可以正常輸入；按鍵列開關在窄面板中仍可觸及；終端機取得焦點時 Ctrl+Shift+F 不再切換專注模式。
- 帳號：工作階段第一輪因用量上限切換帳號時，會把紀錄帶到新帳號，而不是出現「No conversation found」錯誤。
- 聊天：跨行內程式碼選取文字時會顯示選取反白。
- 工作區：Claude 背景工作仍在執行時面板維持「工作中」，結束後才轉為綠色。
