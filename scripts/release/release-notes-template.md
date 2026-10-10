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
### New
- Limit auto-switch moves a session to another account already on Claude's “approaching the usage limit” warning, before the account runs out (at the next message; it waits while background tasks are running).
- Quota shows “not installed”, “not signed in” or “no active subscription” for an agent instead of a raw error.
### Bug fixes
- Limit auto-switch now also catches the limit in turns started by background tasks (subagents reporting back), so the session moves and resumes on another account.
- The header usage % follows the account the session switched to.
- A session on an extra account no longer shows an empty chat after a server restart.
- Agent install, update and sign-in in Settings no longer fail with “Invalid project path”.
- Windows: opening Settings no longer opens a .mjs file when CLAUDE_CLI_PATH points to a JavaScript launcher.
- Each server keeps its own pane layout; a pane whose session is not on the connected server explains that instead of showing an error.
<!-- lang:pl -->
### Nowości
- Automatyczne przełączanie konta przenosi sesję na inne konto już przy ostrzeżeniu Claude o zbliżającym się limicie, zanim konto się wyczerpie (przy następnej wiadomości; czeka, gdy działają zadania w tle).
- Quota pokazuje „nie zainstalowany”, „nie zalogowany” lub „brak aktywnej subskrypcji” zamiast surowego błędu.
### Poprawki
- Automatyczne przełączanie konta wykrywa też limit w turach uruchomionych przez zadania w tle (subagenci zgłaszający wynik), więc sesja przechodzi na inne konto i wznawia pracę.
- Wskaźnik % w nagłówku pokazuje konto, na które przełączyła się sesja.
- Sesja na dodatkowym koncie nie pokazuje już pustego czatu po restarcie serwera.
- Instalacja, aktualizacja i logowanie agentów w Ustawieniach nie kończą się już błędem „Invalid project path”.
- Windows: otwarcie Ustawień nie otwiera już pliku .mjs, gdy CLAUDE_CLI_PATH wskazuje launcher JavaScript.
- Każdy serwer ma własny układ paneli; panel z sesją, której nie ma na połączonym serwerze, wyjaśnia to zamiast pokazywać błąd.
<!-- lang:de -->
### Neu
- Der automatische Kontowechsel verschiebt eine Sitzung schon bei Claudes Warnung „Nutzungslimit fast erreicht“ auf ein anderes Konto, bevor das Konto erschöpft ist (bei der nächsten Nachricht; er wartet, solange Hintergrundaufgaben laufen).
- Das Kontingent zeigt „nicht installiert“, „nicht angemeldet“ oder „kein aktives Abonnement“ statt eines rohen Fehlers.
### Fehlerbehebungen
- Der automatische Kontowechsel erkennt das Limit jetzt auch in Durchläufen, die Hintergrundaufgaben starten (Subagenten mit Ergebnis), sodass die Sitzung auf ein anderes Konto wechselt und weiterarbeitet.
- Die Nutzungsanzeige in der Kopfzeile folgt dem Konto, auf das die Sitzung gewechselt hat.
- Eine Sitzung auf einem zusätzlichen Konto zeigt nach einem Serverneustart keinen leeren Chat mehr.
- Installieren, Aktualisieren und Anmelden von Agenten in den Einstellungen scheitert nicht mehr mit „Invalid project path“.
- Windows: Das Öffnen der Einstellungen öffnet keine .mjs-Datei mehr, wenn CLAUDE_CLI_PATH auf einen JavaScript-Starter zeigt.
- Jeder Server behält sein eigenes Bereichslayout; ein Bereich, dessen Sitzung auf dem verbundenen Server fehlt, erklärt das statt einen Fehler zu zeigen.
<!-- lang:es -->
### Novedades
- El cambio automático de cuenta mueve la sesión a otra cuenta ya con el aviso de Claude de «límite de uso cercano», antes de que la cuenta se agote (en el siguiente mensaje; espera mientras hay tareas en segundo plano).
- La cuota muestra «no instalado», «sin iniciar sesión» o «sin suscripción activa» en lugar de un error sin procesar.
### Correcciones
- El cambio automático de cuenta ahora también detecta el límite en turnos iniciados por tareas en segundo plano (subagentes que informan), así que la sesión pasa a otra cuenta y continúa.
- El % de uso de la cabecera sigue a la cuenta a la que cambió la sesión.
- Una sesión en una cuenta adicional ya no muestra un chat vacío tras reiniciar el servidor.
- Instalar, actualizar e iniciar sesión en agentes desde Ajustes ya no falla con «Invalid project path».
- Windows: abrir Ajustes ya no abre un archivo .mjs cuando CLAUDE_CLI_PATH apunta a un lanzador JavaScript.
- Cada servidor conserva su propia disposición de paneles; un panel cuya sesión no está en el servidor conectado lo explica en lugar de mostrar un error.
<!-- lang:fr -->
### Nouveautés
- Le changement automatique de compte déplace la session vers un autre compte dès l'avertissement de Claude « limite d'utilisation proche », avant que le compte soit épuisé (au message suivant ; il attend tant que des tâches d'arrière-plan tournent).
- Le quota affiche « non installé », « non connecté » ou « aucun abonnement actif » au lieu d'une erreur brute.
### Corrections
- Le changement automatique de compte détecte aussi la limite dans les tours lancés par des tâches d'arrière-plan (sous-agents qui rendent compte) : la session passe sur un autre compte et reprend.
- Le % d'utilisation de l'en-tête suit le compte vers lequel la session a basculé.
- Une session sur un compte supplémentaire n'affiche plus un chat vide après un redémarrage du serveur.
- L'installation, la mise à jour et la connexion des agents dans les Paramètres n'échouent plus avec « Invalid project path ».
- Windows : ouvrir les Paramètres n'ouvre plus de fichier .mjs quand CLAUDE_CLI_PATH pointe vers un lanceur JavaScript.
- Chaque serveur garde sa propre disposition de volets ; un volet dont la session n'existe pas sur le serveur connecté l'explique au lieu d'afficher une erreur.
<!-- lang:it -->
### Novità
- Il cambio automatico di account sposta la sessione su un altro account già all'avviso di Claude «limite di utilizzo vicino», prima che l'account si esaurisca (al messaggio successivo; attende mentre sono in corso attività in background).
- La quota mostra «non installato», «non connesso» o «nessun abbonamento attivo» invece di un errore grezzo.
### Correzioni
- Il cambio automatico di account rileva il limite anche nei turni avviati da attività in background (subagenti che riportano), quindi la sessione passa a un altro account e riprende.
- La % di utilizzo nell'intestazione segue l'account su cui la sessione è passata.
- Una sessione su un account aggiuntivo non mostra più una chat vuota dopo il riavvio del server.
- Installazione, aggiornamento e accesso degli agenti nelle Impostazioni non falliscono più con «Invalid project path».
- Windows: aprire le Impostazioni non apre più un file .mjs quando CLAUDE_CLI_PATH punta a un launcher JavaScript.
- Ogni server mantiene il proprio layout dei riquadri; un riquadro la cui sessione non esiste sul server connesso lo spiega invece di mostrare un errore.
<!-- lang:ja -->
### 新機能
- 上限時の自動アカウント切り替えが、アカウントを使い切る前の Claude の「使用上限に近づいています」警告の時点でセッションを別アカウントへ移すようになりました（次のメッセージ時。バックグラウンドタスク実行中は待機）。
- クォータで、生のエラーの代わりに「未インストール」「未サインイン」「有効なサブスクリプションなし」を表示します。
### バグ修正
- バックグラウンドタスク（結果を報告するサブエージェント）が開始したターンでも上限を検出し、セッションが別アカウントへ移って作業を再開します。
- ヘッダーの使用率が、セッションの切り替え先アカウントに追従します。
- 追加アカウント上のセッションが、サーバー再起動後に空のチャットを表示しなくなりました。
- 設定でのエージェントのインストール・更新・サインインが「Invalid project path」で失敗しなくなりました。
- Windows：CLAUDE_CLI_PATH が JavaScript ランチャーを指す場合でも、設定を開いたときに .mjs ファイルが開かなくなりました。
- サーバーごとにペインのレイアウトを保持し、接続先サーバーにないセッションのペインはエラーではなくその旨を説明します。
<!-- lang:ko -->
### 새 기능
- 한도 자동 계정 전환이 계정이 소진되기 전, Claude의 ‘사용 한도에 가까워짐’ 경고 시점에 세션을 다른 계정으로 옮깁니다(다음 메시지 때; 백그라운드 작업 중에는 대기).
- 할당량에 원시 오류 대신 ‘설치되지 않음’, ‘로그인하지 않음’, ‘활성 구독 없음’을 표시합니다.
### 버그 수정
- 백그라운드 작업(결과를 보고하는 서브에이전트)이 시작한 턴에서도 한도를 감지해 세션이 다른 계정으로 옮겨져 작업을 재개합니다.
- 헤더의 사용량 %가 세션이 전환된 계정을 따릅니다.
- 추가 계정의 세션이 서버 재시작 후 빈 채팅을 표시하지 않습니다.
- 설정에서 에이전트 설치, 업데이트, 로그인이 ‘Invalid project path’로 실패하지 않습니다.
- Windows: CLAUDE_CLI_PATH가 JavaScript 런처를 가리켜도 설정을 열 때 .mjs 파일이 열리지 않습니다.
- 서버마다 창 레이아웃을 따로 유지하며, 연결된 서버에 없는 세션의 창은 오류 대신 그 사실을 설명합니다.
<!-- lang:ru -->
### Новое
- Автопереключение аккаунта переносит сессию на другой аккаунт уже при предупреждении Claude «лимит использования близок», до исчерпания аккаунта (при следующем сообщении; ждёт, пока идут фоновые задачи).
- Квота показывает «не установлен», «не выполнен вход» или «нет активной подписки» вместо необработанной ошибки.
### Исправления
- Автопереключение аккаунта теперь распознаёт лимит и в ходах, запущенных фоновыми задачами (субагенты с результатом): сессия переходит на другой аккаунт и продолжает работу.
- Процент использования в заголовке следует за аккаунтом, на который переключилась сессия.
- Сессия на дополнительном аккаунте больше не показывает пустой чат после перезапуска сервера.
- Установка, обновление и вход агентов в Настройках больше не завершаются ошибкой «Invalid project path».
- Windows: открытие Настроек больше не открывает файл .mjs, когда CLAUDE_CLI_PATH указывает на JavaScript-лаунчер.
- У каждого сервера своя раскладка панелей; панель с сессией, которой нет на подключённом сервере, объясняет это вместо ошибки.
<!-- lang:tr -->
### Yenilikler
- Limitte otomatik hesap değiştirme, hesap tükenmeden önce Claude'un “kullanım limitine yaklaşılıyor” uyarısında oturumu başka bir hesaba taşır (bir sonraki mesajda; arka plan görevleri çalışırken bekler).
- Kota, ham hata yerine “yüklü değil”, “oturum açılmadı” veya “etkin abonelik yok” gösterir.
### Hata düzeltmeleri
- Otomatik hesap değiştirme artık arka plan görevlerinin başlattığı turlarda da (sonuç bildiren alt ajanlar) limiti yakalar; oturum başka hesaba geçip devam eder.
- Başlıktaki kullanım yüzdesi, oturumun geçtiği hesabı izler.
- Ek bir hesaptaki oturum, sunucu yeniden başlatıldıktan sonra artık boş sohbet göstermez.
- Ayarlar'da ajan yükleme, güncelleme ve oturum açma artık “Invalid project path” hatasıyla başarısız olmaz.
- Windows: CLAUDE_CLI_PATH bir JavaScript başlatıcısını gösterdiğinde Ayarlar'ı açmak artık bir .mjs dosyası açmaz.
- Her sunucu kendi panel düzenini korur; oturumu bağlı sunucuda olmayan bir panel hata yerine bunu açıklar.
<!-- lang:zh-CN -->
### 新功能
- 额度自动切换会在账号耗尽之前，于 Claude 发出“即将达到使用额度”警告时就把会话移到另一个账号（在下一条消息时；后台任务运行期间会等待）。
- 额度页面显示“未安装”“未登录”或“无有效订阅”，而不是原始错误。
### 问题修复
- 自动切换现在也能识别后台任务（汇报结果的子代理）发起的回合中的额度限制，会话会切换到另一个账号并继续工作。
- 标题栏的用量百分比会跟随会话切换后的账号。
- 附加账号上的会话在服务器重启后不再显示空白聊天。
- 在设置中安装、更新和登录代理不再因“Invalid project path”失败。
- Windows：当 CLAUDE_CLI_PATH 指向 JavaScript 启动器时，打开设置不再打开 .mjs 文件。
- 每个服务器保留各自的窗格布局；会话不在当前服务器上的窗格会说明原因，而不是显示错误。
<!-- lang:zh-TW -->
### 新功能
- 額度自動切換會在帳號用盡之前，於 Claude 發出「即將達到使用額度」警告時就把工作階段移到另一個帳號（在下一則訊息時；背景工作執行期間會等待）。
- 額度頁面顯示「未安裝」「未登入」或「無有效訂閱」，而不是原始錯誤。
### 錯誤修正
- 自動切換現在也能辨識背景工作（回報結果的子代理）發起的回合中的額度限制，工作階段會切換到另一個帳號並繼續工作。
- 標題列的用量百分比會跟隨工作階段切換後的帳號。
- 附加帳號上的工作階段在伺服器重新啟動後不再顯示空白聊天。
- 在設定中安裝、更新與登入代理不再因「Invalid project path」失敗。
- Windows：當 CLAUDE_CLI_PATH 指向 JavaScript 啟動器時，開啟設定不再開啟 .mjs 檔案。
- 每個伺服器保留各自的窗格配置；工作階段不在目前伺服器上的窗格會說明原因，而不是顯示錯誤。
