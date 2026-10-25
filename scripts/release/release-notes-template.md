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
### Terminal-only agent work
- **Agents now run only as CLIs in terminals.** The session pane, the Sessions tab, Recent, the Ctrl+K session switcher, broadcast and the orchestrator / mini-orchestrator views and settings are gone. An empty workspace opens a terminal pane.
- **Opening a session resumes it in a terminal tab** with its own CLI (`claude --resume`, `codex resume`, `opencode --session`, …), from the board, scheduler, command palette, project list and `ddagent://chat/…` links. A session already open in a tab is focused instead of opened twice. Saved session panes become terminal panes that resume their session.
- **Background tabs and panes show what the agent is doing**: amber when its CLI waits for you to pick an option, green when it has finished (terminal bell / desktop notification). Grid pane headers, the compact pane strip and the overview show the same flags; the compact strip names each pane after the tab it shows.

### Fixes
- The "Sign-in link" banner no longer pops up for URLs an agent prints in code; it can also be closed.
- A tab whose project folder no longer exists shows the reason and a Connect button instead of "Connecting…" forever.
- Multiple panes: clicking a pane, a tab in its strip, or adding a pane moves the keyboard there; restarting a tab never opens a second connection; tabs opened before the workspace finished loading are kept; Esc and Alt+1–3 stay with a focused terminal.
- Duplicating a resumed session tab starts a fresh CLI of the same account instead of attaching to the same terminal.
- App-wide notices (session expired, notification fallback) are shown again instead of failing silently.
<!-- lang:pl -->
### Praca z agentami tylko w terminalu
- **Agenci działają teraz wyłącznie jako CLI w terminalach.** Zniknęły panel sesji, zakładka Sesje, Ostatnie, przełącznik sesji Ctrl+K, broadcast oraz widoki i ustawienia orkiestratora / mini-orkiestratora. Pusty obszar roboczy otwiera panel terminala.
- **Otwarcie sesji wznawia ją w karcie terminala** jej własnym CLI (`claude --resume`, `codex resume`, `opencode --session`, …) — z tablicy, harmonogramu, palety poleceń, listy projektów i linków `ddagent://chat/…`. Sesja otwarta już w karcie zostaje tylko aktywowana, bez drugiej kopii. Zapisane panele sesji zamieniają się w panele terminala wznawiające swoją sesję.
- **Karty i panele w tle pokazują, co robi agent**: pomarańczowe, gdy CLI czeka na Twój wybór, zielone, gdy skończył (dzwonek terminala / powiadomienie). Te same oznaczenia mają nagłówki paneli w siatce, pasek paneli w trybie kompaktowym i przegląd; pasek kompaktowy nazywa panel tytułem widocznej karty.

### Poprawki
- Baner „Link logowania” nie pojawia się już przy adresach, które agent wypisuje w kodzie; można go też zamknąć.
- Karta, której folder projektu już nie istnieje, pokazuje powód i przycisk Połącz zamiast wiecznego „Łączenie…”.
- Wiele paneli: kliknięcie panelu, karty na jego pasku lub dodanie panelu przenosi tam klawiaturę; restart karty nie otwiera drugiego połączenia; karty otwarte przed wczytaniem obszaru roboczego zostają; Esc i Alt+1–3 trafiają do aktywnego terminala.
- Duplikat karty ze wznowioną sesją uruchamia nowe CLI tego samego konta zamiast podpinać się pod ten sam terminal.
- Ogólne komunikaty aplikacji (wygaśnięcie sesji, zastępcze powiadomienia) znów się wyświetlają zamiast cicho zawodzić.
<!-- lang:de -->
### Agenten nur noch im Terminal
- **Agenten laufen jetzt ausschließlich als CLIs in Terminals.** Sitzungsbereich, Tab „Sitzungen“, „Zuletzt“, der Sitzungswechsler Strg+K, Broadcast sowie Ansichten und Einstellungen des Orchestrators / Mini-Orchestrators wurden entfernt. Ein leerer Arbeitsbereich öffnet einen Terminalbereich.
- **Das Öffnen einer Sitzung setzt sie in einem Terminal-Tab fort** – mit ihrer eigenen CLI (`claude --resume`, `codex resume`, `opencode --session`, …), aus Board, Planer, Befehlspalette, Projektliste und `ddagent://chat/…`-Links. Ist die Sitzung bereits in einem Tab offen, wird dieser fokussiert statt sie doppelt zu öffnen. Gespeicherte Sitzungsbereiche werden zu Terminalbereichen, die ihre Sitzung fortsetzen.
- **Tabs und Bereiche im Hintergrund zeigen, was der Agent tut**: orange, wenn die CLI auf deine Auswahl wartet, grün, wenn sie fertig ist (Terminalglocke / Desktop-Benachrichtigung). Bereichsköpfe im Raster, die kompakte Bereichsleiste und die Übersicht zeigen dieselben Markierungen; die kompakte Leiste benennt jeden Bereich nach seinem sichtbaren Tab.

### Fehlerbehebungen
- Das Banner „Anmeldelink“ erscheint nicht mehr bei URLs, die ein Agent im Code ausgibt; es lässt sich außerdem schließen.
- Ein Tab, dessen Projektordner nicht mehr existiert, zeigt den Grund und eine Schaltfläche „Verbinden“ statt endlos „Verbinden…“.
- Mehrere Bereiche: Ein Klick in einen Bereich, auf einen Tab seiner Leiste oder das Hinzufügen eines Bereichs verschiebt die Tastatur dorthin; ein Tab-Neustart öffnet nie eine zweite Verbindung; vor dem Laden des Arbeitsbereichs geöffnete Tabs bleiben erhalten; Esc und Alt+1–3 bleiben beim fokussierten Terminal.
- Das Duplizieren eines fortgesetzten Sitzungs-Tabs startet eine neue CLI desselben Kontos, statt dasselbe Terminal anzuhängen.
- App-weite Hinweise (Sitzung abgelaufen, Ersatz-Benachrichtigungen) werden wieder angezeigt, statt still zu scheitern.
<!-- lang:es -->
### Trabajo con agentes solo en el terminal
- **Los agentes ahora se ejecutan solo como CLI en terminales.** Se eliminaron el panel de sesión, la pestaña Sesiones, Recientes, el selector de sesiones Ctrl+K, la difusión y las vistas y ajustes del orquestador / mini-orquestador. Un espacio de trabajo vacío abre un panel de terminal.
- **Abrir una sesión la reanuda en una pestaña de terminal** con su propia CLI (`claude --resume`, `codex resume`, `opencode --session`, …), desde el tablero, el planificador, la paleta de comandos, la lista de proyectos y los enlaces `ddagent://chat/…`. Si la sesión ya está abierta en una pestaña, se enfoca en lugar de abrirse dos veces. Los paneles de sesión guardados pasan a ser paneles de terminal que reanudan su sesión.
- **Las pestañas y paneles en segundo plano muestran lo que hace el agente**: ámbar cuando su CLI espera que elijas una opción, verde cuando ha terminado (campana del terminal / notificación). Las cabeceras de los paneles en cuadrícula, la tira de paneles compacta y la vista general muestran las mismas marcas; la tira compacta nombra cada panel según la pestaña que muestra.

### Correcciones
- El aviso «Enlace de inicio de sesión» ya no aparece con las URL que un agente imprime en el código; además se puede cerrar.
- Una pestaña cuya carpeta de proyecto ya no existe muestra el motivo y un botón Conectar en lugar de «Conectando…» para siempre.
- Varios paneles: hacer clic en un panel, en una pestaña de su tira o añadir un panel lleva el teclado allí; reiniciar una pestaña nunca abre una segunda conexión; las pestañas abiertas antes de cargar el espacio de trabajo se conservan; Esc y Alt+1–3 se quedan en el terminal enfocado.
- Duplicar una pestaña con una sesión reanudada inicia una CLI nueva de la misma cuenta en lugar de conectarse al mismo terminal.
- Los avisos generales de la aplicación (sesión caducada, notificaciones de respaldo) vuelven a mostrarse en lugar de fallar en silencio.
<!-- lang:fr -->
### Travail avec les agents uniquement dans le terminal
- **Les agents s'exécutent désormais uniquement comme CLI dans des terminaux.** Le panneau de session, l'onglet Sessions, Récents, le sélecteur de sessions Ctrl+K, la diffusion ainsi que les vues et réglages de l'orchestrateur / mini-orchestrateur ont été supprimés. Un espace de travail vide ouvre un panneau de terminal.
- **Ouvrir une session la reprend dans un onglet de terminal** avec sa propre CLI (`claude --resume`, `codex resume`, `opencode --session`, …), depuis le tableau, le planificateur, la palette de commandes, la liste des projets et les liens `ddagent://chat/…`. Une session déjà ouverte dans un onglet est mise au premier plan au lieu d'être ouverte deux fois. Les panneaux de session enregistrés deviennent des panneaux de terminal qui reprennent leur session.
- **Les onglets et panneaux en arrière-plan montrent ce que fait l'agent** : ambre quand sa CLI attend votre choix, vert quand elle a terminé (cloche du terminal / notification). Les en-têtes des panneaux en grille, la barre de panneaux compacte et la vue d'ensemble affichent les mêmes indicateurs ; la barre compacte nomme chaque panneau d'après l'onglet affiché.

### Corrections
- La bannière « Lien de connexion » n'apparaît plus pour les URL qu'un agent affiche dans du code ; elle peut aussi être fermée.
- Un onglet dont le dossier de projet n'existe plus affiche la raison et un bouton Connecter au lieu de « Connexion… » sans fin.
- Plusieurs panneaux : cliquer dans un panneau, sur un onglet de sa barre ou ajouter un panneau y déplace le clavier ; redémarrer un onglet n'ouvre jamais une seconde connexion ; les onglets ouverts avant le chargement de l'espace de travail sont conservés ; Échap et Alt+1–3 restent dans le terminal actif.
- Dupliquer un onglet de session reprise lance une nouvelle CLI du même compte au lieu de se rattacher au même terminal.
- Les messages globaux de l'application (session expirée, notifications de secours) s'affichent à nouveau au lieu d'échouer en silence.
<!-- lang:it -->
### Lavoro con gli agenti solo nel terminale
- **Gli agenti ora funzionano solo come CLI nei terminali.** Sono stati rimossi il pannello sessione, la scheda Sessioni, Recenti, il selettore di sessioni Ctrl+K, la trasmissione e le viste e impostazioni dell'orchestratore / mini-orchestratore. Uno spazio di lavoro vuoto apre un pannello terminale.
- **Aprire una sessione la riprende in una scheda del terminale** con la sua CLI (`claude --resume`, `codex resume`, `opencode --session`, …), da bacheca, pianificatore, tavolozza dei comandi, elenco progetti e link `ddagent://chat/…`. Una sessione già aperta in una scheda viene messa a fuoco invece di essere aperta due volte. I pannelli sessione salvati diventano pannelli terminale che riprendono la loro sessione.
- **Schede e pannelli in background mostrano cosa fa l'agente**: ambra quando la CLI aspetta una tua scelta, verde quando ha finito (campanello del terminale / notifica). Le intestazioni dei pannelli nella griglia, la striscia compatta dei pannelli e la panoramica mostrano gli stessi indicatori; la striscia compatta dà a ogni pannello il nome della scheda visibile.

### Correzioni
- Il banner «Link di accesso» non compare più per gli URL che un agente stampa nel codice; inoltre si può chiudere.
- Una scheda la cui cartella di progetto non esiste più mostra il motivo e un pulsante Connetti invece di «Connessione…» all'infinito.
- Più pannelli: fare clic in un pannello, su una scheda della sua striscia o aggiungere un pannello sposta lì la tastiera; il riavvio di una scheda non apre mai una seconda connessione; le schede aperte prima del caricamento dello spazio di lavoro vengono mantenute; Esc e Alt+1–3 restano al terminale attivo.
- Duplicare una scheda con una sessione ripresa avvia una nuova CLI dello stesso account invece di agganciarsi allo stesso terminale.
- Gli avvisi generali dell'app (sessione scaduta, notifiche di riserva) vengono di nuovo mostrati invece di fallire in silenzio.
<!-- lang:ja -->
### エージェント作業をターミナルに一本化
- **エージェントはターミナル内の CLI としてのみ動作するようになりました。** セッションペイン、「セッション」タブ、「最近」、Ctrl+K のセッション切り替え、ブロードキャスト、オーケストレーター／ミニオーケストレーターの画面と設定を削除しました。空のワークスペースではターミナルペインが開きます。
- **セッションを開くと、そのセッションの CLI でターミナルタブとして再開します**（`claude --resume`、`codex resume`、`opencode --session` など）。ボード、スケジューラー、コマンドパレット、プロジェクト一覧、`ddagent://chat/…` リンクから開けます。すでにタブで開いているセッションは二重に開かず、そのタブにフォーカスします。保存済みのセッションペインは、そのセッションを再開するターミナルペインに変わります。
- **バックグラウンドのタブとペインにエージェントの状態を表示**：CLI が選択を待っているときはオレンジ、完了したとき（ターミナルのベル／通知）は緑。グリッドのペインヘッダー、コンパクト表示のペインバー、概要にも同じ表示が出ます。コンパクト表示のペインバーは、各ペインを表示中のタブ名で示します。

### 修正
- エージェントがコード内に出力した URL で「サインインリンク」バナーが出なくなりました。バナーは閉じることもできます。
- プロジェクトフォルダーが存在しなくなったタブは、「接続中…」のままにならず、理由と「接続」ボタンを表示します。
- 複数ペイン：ペインやそのバーのタブをクリックしたとき、またはペインを追加したときにキーボードがそこへ移ります。タブを再起動しても二つ目の接続を開きません。ワークスペースの読み込み前に開いたタブは保持されます。Esc と Alt+1–3 はフォーカス中のターミナルに届きます。
- 再開したセッションのタブを複製すると、同じターミナルに接続するのではなく、同じアカウントで新しい CLI を起動します。
- アプリ全体の通知（セッション期限切れ、代替通知）が、失敗して表示されない問題を修正しました。
<!-- lang:ko -->
### 에이전트 작업을 터미널로 일원화
- **에이전트는 이제 터미널의 CLI로만 실행됩니다.** 세션 창, 세션 탭, 최근, Ctrl+K 세션 전환기, 브로드캐스트, 오케스트레이터/미니 오케스트레이터 화면과 설정이 제거되었습니다. 빈 작업 공간에서는 터미널 창이 열립니다.
- **세션을 열면 해당 세션의 CLI로 터미널 탭에서 이어서 실행됩니다**(`claude --resume`, `codex resume`, `opencode --session` 등). 보드, 스케줄러, 명령 팔레트, 프로젝트 목록, `ddagent://chat/…` 링크에서 열 수 있습니다. 이미 탭에 열려 있는 세션은 두 번 열지 않고 그 탭으로 이동합니다. 저장된 세션 창은 해당 세션을 이어서 실행하는 터미널 창으로 바뀝니다.
- **백그라운드 탭과 창에 에이전트 상태가 표시됩니다**: CLI가 선택을 기다리면 주황색, 작업을 마치면(터미널 벨/알림) 초록색입니다. 그리드의 창 머리글, 컴팩트 창 막대, 개요에도 같은 표시가 나타나며, 컴팩트 막대는 각 창을 보이는 탭 이름으로 표시합니다.

### 수정
- 에이전트가 코드에 출력한 URL에 대해 '로그인 링크' 배너가 더 이상 나타나지 않으며, 배너를 닫을 수도 있습니다.
- 프로젝트 폴더가 더 이상 없는 탭은 '연결 중…'에 머무르지 않고 이유와 연결 버튼을 표시합니다.
- 여러 창: 창이나 창 막대의 탭을 클릭하거나 창을 추가하면 키보드가 그쪽으로 이동합니다. 탭을 다시 시작해도 두 번째 연결을 열지 않습니다. 작업 공간 로딩 전에 연 탭이 유지됩니다. Esc와 Alt+1–3은 포커스된 터미널에 전달됩니다.
- 이어서 실행한 세션 탭을 복제하면 같은 터미널에 연결하는 대신 같은 계정으로 새 CLI를 시작합니다.
- 앱 전체 알림(세션 만료, 대체 알림)이 조용히 실패하지 않고 다시 표시됩니다.
<!-- lang:ru -->
### Работа с агентами только в терминале
- **Агенты теперь работают только как CLI в терминалах.** Удалены панель сессии, вкладка «Сессии», «Недавние», переключатель сессий Ctrl+K, рассылка, а также экраны и настройки оркестратора / мини-оркестратора. Пустое рабочее пространство открывает панель терминала.
- **Открытие сессии продолжает её во вкладке терминала** её собственным CLI (`claude --resume`, `codex resume`, `opencode --session`, …) — с доски, из планировщика, палитры команд, списка проектов и ссылок `ddagent://chat/…`. Если сессия уже открыта во вкладке, фокус переходит на неё, без второй копии. Сохранённые панели сессий становятся панелями терминала, продолжающими свою сессию.
- **Фоновые вкладки и панели показывают, что делает агент**: оранжевым — когда CLI ждёт вашего выбора, зелёным — когда он закончил (звонок терминала / уведомление). Те же отметки есть в заголовках панелей сетки, в компактной полосе панелей и в обзоре; компактная полоса называет панель по видимой в ней вкладке.

### Исправления
- Баннер «Ссылка для входа» больше не появляется для URL, которые агент выводит в коде; его также можно закрыть.
- Вкладка, чья папка проекта больше не существует, показывает причину и кнопку «Подключить» вместо бесконечного «Подключение…».
- Несколько панелей: щелчок по панели, по вкладке в её полосе или добавление панели переносит туда клавиатуру; перезапуск вкладки никогда не открывает второе соединение; вкладки, открытые до загрузки рабочего пространства, сохраняются; Esc и Alt+1–3 остаются у активного терминала.
- Дублирование вкладки с продолженной сессией запускает новый CLI того же аккаунта вместо подключения к тому же терминалу.
- Общие уведомления приложения (истёкшая сессия, резервные уведомления) снова отображаются, а не молча пропадают.
<!-- lang:tr -->
### Ajanlarla yalnızca terminalde çalışma
- **Ajanlar artık yalnızca terminallerde CLI olarak çalışıyor.** Oturum bölmesi, Oturumlar sekmesi, Son kullanılanlar, Ctrl+K oturum değiştirici, yayın ve orkestratör / mini orkestratör görünümleri ile ayarları kaldırıldı. Boş bir çalışma alanı bir terminal bölmesi açar.
- **Bir oturumu açmak onu kendi CLI'ı ile bir terminal sekmesinde sürdürür** (`claude --resume`, `codex resume`, `opencode --session`, …); pano, zamanlayıcı, komut paleti, proje listesi ve `ddagent://chat/…` bağlantılarından açılabilir. Zaten bir sekmede açık olan oturum ikinci kez açılmaz, o sekmeye odaklanılır. Kayıtlı oturum bölmeleri, oturumlarını sürdüren terminal bölmelerine dönüşür.
- **Arka plandaki sekmeler ve bölmeler ajanın ne yaptığını gösterir**: CLI seçiminizi beklerken turuncu, işini bitirdiğinde (terminal zili / bildirim) yeşil. Izgaradaki bölme başlıkları, kompakt bölme şeridi ve genel bakış aynı işaretleri gösterir; kompakt şerit her bölmeyi gösterdiği sekmenin adıyla adlandırır.

### Düzeltmeler
- "Giriş bağlantısı" başlığı, bir ajanın kodda yazdırdığı URL'ler için artık çıkmıyor; ayrıca kapatılabiliyor.
- Proje klasörü artık bulunmayan bir sekme, sonsuz "Bağlanıyor…" yerine nedeni ve Bağlan düğmesini gösteriyor.
- Birden fazla bölme: bir bölmeye, şeridindeki bir sekmeye tıklamak ya da bölme eklemek klavyeyi oraya taşır; sekmeyi yeniden başlatmak asla ikinci bir bağlantı açmaz; çalışma alanı yüklenmeden açılan sekmeler korunur; Esc ve Alt+1–3 odaktaki terminalde kalır.
- Sürdürülen bir oturum sekmesini çoğaltmak, aynı terminale bağlanmak yerine aynı hesapla yeni bir CLI başlatır.
- Uygulama genelindeki bildirimler (oturum süresi doldu, yedek bildirimler) sessizce başarısız olmak yerine yeniden gösteriliyor.
<!-- lang:zh-CN -->
### 智能体工作统一到终端
- **智能体现在只以终端中的 CLI 形式运行。** 已移除会话面板、“会话”标签页、“最近”、Ctrl+K 会话切换器、广播以及编排器 / 迷你编排器的视图和设置。空工作区会打开一个终端面板。
- **打开会话会在终端标签页中用其自身的 CLI 恢复该会话**（`claude --resume`、`codex resume`、`opencode --session` 等），可从看板、计划任务、命令面板、项目列表和 `ddagent://chat/…` 链接打开。已在某个标签页中打开的会话会被聚焦，而不会重复打开。已保存的会话面板会变为恢复其会话的终端面板。
- **后台标签页和面板会显示智能体的状态**：CLI 等待你选择时显示橙色，完成时（终端响铃 / 通知）显示绿色。网格中的面板标题、紧凑模式的面板栏和概览也显示同样的标记；紧凑面板栏以当前显示的标签页名称命名每个面板。

### 修复
- 智能体在代码中输出的 URL 不再弹出“登录链接”横幅；横幅也可以关闭。
- 项目文件夹已不存在的标签页会显示原因和“连接”按钮，而不是一直显示“正在连接…”。
- 多面板：点击面板、其标签栏中的标签页或添加面板时，键盘焦点会移到那里；重启标签页不会再打开第二个连接；在工作区加载完成前打开的标签页会保留；Esc 和 Alt+1–3 留在当前聚焦的终端中。
- 复制已恢复会话的标签页会以同一账号启动新的 CLI，而不是连接到同一个终端。
- 应用级提示（会话过期、备用通知）重新正常显示，不再静默失败。
<!-- lang:zh-TW -->
### 代理工作統一到終端機
- **代理現在只以終端機中的 CLI 形式執行。** 已移除工作階段面板、「工作階段」分頁、「最近」、Ctrl+K 工作階段切換器、廣播，以及協調器 / 迷你協調器的畫面與設定。空白工作區會開啟一個終端機面板。
- **開啟工作階段會在終端機分頁中以其自身的 CLI 繼續該工作階段**（`claude --resume`、`codex resume`、`opencode --session` 等），可從看板、排程、命令面板、專案清單與 `ddagent://chat/…` 連結開啟。已在分頁中開啟的工作階段會被聚焦，而不會重複開啟。已儲存的工作階段面板會變成繼續其工作階段的終端機面板。
- **背景分頁與面板會顯示代理的狀態**：CLI 等待你選擇時顯示橘色，完成時（終端機響鈴 / 通知）顯示綠色。格線中的面板標題、精簡模式的面板列與總覽也顯示相同標記；精簡面板列以目前顯示的分頁名稱命名每個面板。

### 修正
- 代理在程式碼中輸出的 URL 不再跳出「登入連結」橫幅；橫幅也可以關閉。
- 專案資料夾已不存在的分頁會顯示原因與「連線」按鈕，而不是一直顯示「正在連線…」。
- 多面板：點選面板、其分頁列中的分頁或新增面板時，鍵盤焦點會移到那裡；重新啟動分頁不會再開啟第二條連線；在工作區載入完成前開啟的分頁會保留；Esc 與 Alt+1–3 留在目前聚焦的終端機。
- 複製已繼續之工作階段的分頁會以同一帳號啟動新的 CLI，而不是連到同一個終端機。
- 應用程式層級的提示（工作階段過期、備用通知）重新正常顯示，不再無聲失敗。
