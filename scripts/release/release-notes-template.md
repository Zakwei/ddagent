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
- **Terminal: run an agent on a named account.** The `⌄` profile menu lists every named provider account (Settings → Agents → accounts) as "Claude CLI · Work", "Codex CLI · Team", … Picking one types the CLI with that account's config dir into the shell you are in (`env CLAUDE_CONFIG_DIR=… claude`, PowerShell `$env:…; claude`), so it starts in the current directory, signed in as that account. A new tab is opened only when the active tab cannot take typed input.
### Fixes
- **Update dialog**: a server self-update no longer shows "Update failed — connection took longer than 10 s" while the server is still pulling, installing and building. The update requests get a 20-minute budget, and a dropped connection switches the dialog to "Restarting…" and waits for the new version instead of reporting an error.
<!-- lang:pl -->
### Nowości
- **Terminal: uruchom agenta na nazwanym koncie.** Menu profili `⌄` wymienia każde nazwane konto dostawcy (Ustawienia → Agenci → konta) jako „Claude CLI · Praca”, „Codex CLI · Zespół” itd. Wybór wpisuje do bieżącej powłoki CLI z katalogiem konfiguracji tego konta (`env CLAUDE_CONFIG_DIR=… claude`, w PowerShell `$env:…; claude`), więc startuje w aktualnym katalogu, zalogowane na to konto. Nowa karta otwiera się tylko wtedy, gdy aktywna karta nie przyjmie wpisywanego tekstu.
### Poprawki
- **Dialog aktualizacji**: samoaktualizacja serwera nie pokazuje już „Aktualizacja nie powiodła się — połączenie trwało dłużej niż 10 s”, gdy serwer wciąż pobiera, instaluje i buduje. Żądania aktualizacji mają 20-minutowy budżet, a zerwane połączenie przełącza dialog w „Restartowanie…” i czeka na nową wersję zamiast zgłaszać błąd.
<!-- lang:de -->
### Neu
- **Terminal: Agent mit einem benannten Konto starten.** Das Profilmenü `⌄` listet jedes benannte Anbieterkonto (Einstellungen → Agenten → Konten) als „Claude CLI · Arbeit“, „Codex CLI · Team“ … Die Auswahl tippt die CLI mit dem Konfigurationsverzeichnis dieses Kontos in die aktuelle Shell (`env CLAUDE_CONFIG_DIR=… claude`, PowerShell `$env:…; claude`), sodass sie im aktuellen Verzeichnis startet, angemeldet mit diesem Konto. Ein neuer Tab wird nur geöffnet, wenn der aktive Tab keine Eingabe annehmen kann.
### Fehlerbehebungen
- **Update-Dialog**: Ein Server-Selbstupdate zeigt nicht mehr „Update fehlgeschlagen – Verbindung dauerte länger als 10 s“, während der Server noch pullt, installiert und baut. Die Update-Anfragen haben ein 20-Minuten-Budget, und eine abgebrochene Verbindung schaltet den Dialog auf „Neustart…“ und wartet auf die neue Version, statt einen Fehler zu melden.
<!-- lang:es -->
### Novedades
- **Terminal: ejecutar un agente con una cuenta con nombre.** El menú de perfiles `⌄` lista cada cuenta de proveedor con nombre (Ajustes → Agentes → cuentas) como «Claude CLI · Trabajo», «Codex CLI · Equipo»… Al elegir una, escribe en el shell actual la CLI con el directorio de configuración de esa cuenta (`env CLAUDE_CONFIG_DIR=… claude`, en PowerShell `$env:…; claude`), así arranca en el directorio actual con esa cuenta. Solo se abre una pestaña nueva cuando la activa no puede recibir texto.
### Correcciones
- **Diálogo de actualización**: la autoactualización del servidor ya no muestra «Actualización fallida — la conexión tardó más de 10 s» mientras el servidor sigue descargando, instalando y compilando. Las peticiones de actualización tienen un margen de 20 minutos y una conexión cortada pasa el diálogo a «Reiniciando…» y espera la nueva versión en lugar de informar de un error.
<!-- lang:fr -->
### Nouveautés
- **Terminal : lancer un agent avec un compte nommé.** Le menu de profils `⌄` liste chaque compte fournisseur nommé (Paramètres → Agents → comptes) sous la forme « Claude CLI · Travail », « Codex CLI · Équipe »… Le choix tape dans le shell courant la CLI avec le répertoire de configuration de ce compte (`env CLAUDE_CONFIG_DIR=… claude`, PowerShell `$env:…; claude`), qui démarre donc dans le répertoire courant, connectée à ce compte. Un nouvel onglet ne s'ouvre que si l'onglet actif ne peut pas recevoir de saisie.
### Corrections
- **Boîte de mise à jour** : l'auto-mise à jour du serveur n'affiche plus « Échec de la mise à jour — la connexion a pris plus de 10 s » pendant que le serveur récupère, installe et compile encore. Les requêtes de mise à jour disposent de 20 minutes, et une connexion coupée fait passer la boîte en « Redémarrage… » et attend la nouvelle version au lieu de signaler une erreur.
<!-- lang:it -->
### Novità
- **Terminale: avviare un agente con un account con nome.** Il menu profili `⌄` elenca ogni account provider con nome (Impostazioni → Agenti → account) come «Claude CLI · Lavoro», «Codex CLI · Team»… Scegliendone uno, nella shell corrente viene digitata la CLI con la directory di configurazione di quell'account (`env CLAUDE_CONFIG_DIR=… claude`, in PowerShell `$env:…; claude`), così parte nella directory corrente con quell'account. Una nuova scheda si apre solo se quella attiva non può ricevere input.
### Correzioni
- **Finestra di aggiornamento**: l'autoaggiornamento del server non mostra più «Aggiornamento non riuscito — la connessione ha impiegato più di 10 s» mentre il server sta ancora scaricando, installando e compilando. Le richieste di aggiornamento hanno 20 minuti di margine e una connessione interrotta porta la finestra in «Riavvio…» e attende la nuova versione invece di segnalare un errore.
<!-- lang:ja -->
### 新機能
- **ターミナル：名前付きアカウントでエージェントを起動。** プロファイルメニュー `⌄` に、名前付きのプロバイダーアカウント（設定 → エージェント → アカウント）が「Claude CLI · 仕事」「Codex CLI · チーム」のように並びます。選ぶと、そのアカウントの設定ディレクトリ付きで CLI が現在のシェルに入力され（`env CLAUDE_CONFIG_DIR=… claude`、PowerShell では `$env:…; claude`）、現在のディレクトリでそのアカウントとして起動します。アクティブなタブが入力を受け付けられないときだけ新しいタブが開きます。
### 修正
- **更新ダイアログ**：サーバーがまだ取得・インストール・ビルド中なのに「更新に失敗しました — 接続に 10 秒以上かかりました」と表示されなくなりました。更新リクエストには 20 分の猶予があり、接続が切れてもダイアログは「再起動中…」に切り替わってエラーを出さずに新バージョンを待ちます。
<!-- lang:ko -->
### 새로운 기능
- **터미널: 이름 있는 계정으로 에이전트 실행.** 프로필 메뉴 `⌄`에 이름 있는 제공자 계정(설정 → 에이전트 → 계정)이 "Claude CLI · 업무", "Codex CLI · 팀" 등으로 표시됩니다. 선택하면 해당 계정의 설정 디렉터리가 적용된 CLI가 현재 셸에 입력되어(`env CLAUDE_CONFIG_DIR=… claude`, PowerShell은 `$env:…; claude`) 현재 디렉터리에서 그 계정으로 시작합니다. 활성 탭이 입력을 받을 수 없을 때만 새 탭이 열립니다.
### 수정
- **업데이트 대화상자**: 서버가 아직 가져오기·설치·빌드 중인데 "업데이트 실패 — 연결이 10초 이상 걸림"이 표시되지 않습니다. 업데이트 요청에 20분의 여유가 주어지며, 연결이 끊기면 대화상자가 "다시 시작 중…"으로 바뀌어 오류 대신 새 버전을 기다립니다.
<!-- lang:ru -->
### Что нового
- **Терминал: запуск агента под именованным аккаунтом.** Меню профилей `⌄` показывает каждый именованный аккаунт провайдера (Настройки → Агенты → аккаунты) как «Claude CLI · Работа», «Codex CLI · Команда»… Выбор вводит в текущую оболочку CLI с каталогом конфигурации этого аккаунта (`env CLAUDE_CONFIG_DIR=… claude`, в PowerShell `$env:…; claude`), так что она стартует в текущем каталоге под этим аккаунтом. Новая вкладка открывается только если активная не может принять ввод.
### Исправления
- **Диалог обновления**: самообновление сервера больше не показывает «Ошибка обновления — соединение заняло больше 10 с», пока сервер ещё скачивает, устанавливает и собирает. У запросов обновления есть 20-минутный запас, а обрыв соединения переводит диалог в «Перезапуск…» и ждёт новую версию вместо ошибки.
<!-- lang:tr -->
### Yenilikler
- **Terminal: adlandırılmış hesapla ajan çalıştırma.** `⌄` profil menüsü her adlandırılmış sağlayıcı hesabını (Ayarlar → Ajanlar → hesaplar) "Claude CLI · İş", "Codex CLI · Ekip" … olarak listeler. Birini seçmek, o hesabın yapılandırma diziniyle CLI'ı bulunduğunuz kabuğa yazar (`env CLAUDE_CONFIG_DIR=… claude`, PowerShell'de `$env:…; claude`); böylece geçerli dizinde, o hesapla başlar. Yeni sekme yalnızca etkin sekme girdi alamadığında açılır.
### Düzeltmeler
- **Güncelleme iletişim kutusu**: sunucu hâlâ çekme, kurma ve derleme yaparken "Güncelleme başarısız — bağlantı 10 sn'den uzun sürdü" artık gösterilmiyor. Güncelleme istekleri 20 dakikalık süre alır ve kopan bağlantı iletişim kutusunu "Yeniden başlatılıyor…" durumuna geçirip hata vermek yerine yeni sürümü bekler.
<!-- lang:zh-CN -->
### 新功能
- **终端：以命名账户运行智能体。** `⌄` 配置菜单会列出每个命名的提供方账户（设置 → 智能体 → 账户），形如“Claude CLI · 工作”“Codex CLI · 团队”。选择后，会把带有该账户配置目录的 CLI 输入到当前 shell（`env CLAUDE_CONFIG_DIR=… claude`，PowerShell 为 `$env:…; claude`），因此在当前目录以该账户启动。只有当前标签无法接收输入时才会新开标签。
### 修复
- **更新对话框**：服务器自更新仍在拉取、安装、构建时，不再显示“更新失败 — 连接超过 10 秒”。更新请求有 20 分钟的时限，连接中断时对话框会切换到“正在重启…”并等待新版本，而不是报错。
<!-- lang:zh-TW -->
### 新功能
- **終端機：以具名帳號執行代理程式。** `⌄` 設定檔選單會列出每個具名的提供者帳號（設定 → 代理程式 → 帳號），例如「Claude CLI · 工作」「Codex CLI · 團隊」。選取後，會把帶有該帳號設定目錄的 CLI 輸入到目前的 shell（`env CLAUDE_CONFIG_DIR=… claude`，PowerShell 為 `$env:…; claude`），因此在目前目錄以該帳號啟動。只有在使用中的分頁無法接收輸入時才會開新分頁。
### 修正
- **更新對話框**：伺服器自我更新仍在拉取、安裝、建置時，不再顯示「更新失敗 — 連線超過 10 秒」。更新要求有 20 分鐘的時限，連線中斷時對話框會切換為「正在重新啟動…」並等待新版本，而不是回報錯誤。
