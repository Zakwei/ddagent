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
### Bug fixes
- The desktop app no longer gets stuck on “Connecting” when you pick the local or a remote server while signed out — it now takes you to the sign-in screen.
- Buttons and dialogs no longer stay stuck loading after an unexpected error or a dropped connection (creating or cloning a project, signing in, desktop notifications, several settings).
- A download that stalls (local server, Node.js, app update) now fails after a minute instead of hanging. The local server's update check runs once per app launch with time limits, so moving around the app no longer waits for it.
- An unreadable saved sign-in no longer blocks the app — you're simply asked to sign in again.
<!-- lang:pl -->
### Poprawki
- Aplikacja desktopowa nie zawiesza się już na „Łączenie”, gdy wybierasz serwer lokalny lub zdalny bez zalogowania — przechodzi teraz do ekranu logowania.
- Przyciski i okna nie zostają już w stanie ładowania po nieoczekiwanym błędzie lub zerwanym połączeniu (tworzenie i klonowanie projektu, logowanie, powiadomienia na pulpicie, kilka ustawień).
- Pobieranie, które stanie (serwer lokalny, Node.js, aktualizacja aplikacji), kończy się teraz błędem po minucie zamiast wisieć. Sprawdzanie aktualizacji serwera lokalnego działa raz na uruchomienie aplikacji i z limitami czasu, więc poruszanie się po aplikacji już na nie nie czeka.
- Nieczytelne zapisane logowanie nie blokuje już aplikacji — po prostu poprosi o ponowne zalogowanie.
<!-- lang:de -->
### Fehlerbehebungen
- Die Desktop-App bleibt nicht mehr bei „Verbinden“ hängen, wenn du ohne Anmeldung den lokalen oder einen entfernten Server wählst — sie führt jetzt zum Anmeldebildschirm.
- Schaltflächen und Dialoge bleiben nach einem unerwarteten Fehler oder einer abgebrochenen Verbindung nicht mehr im Ladezustand hängen (Projekt erstellen oder klonen, Anmeldung, Desktop-Benachrichtigungen, mehrere Einstellungen).
- Ein hängender Download (lokaler Server, Node.js, App-Update) schlägt jetzt nach einer Minute fehl, statt endlos zu warten. Die Update-Prüfung des lokalen Servers läuft einmal pro App-Start mit Zeitlimits, sodass die Navigation in der App nicht mehr darauf wartet.
- Eine nicht lesbare gespeicherte Anmeldung blockiert die App nicht mehr — du wirst einfach erneut zur Anmeldung aufgefordert.
<!-- lang:es -->
### Correcciones
- La app de escritorio ya no se queda en «Conectando» al elegir el servidor local o uno remoto sin haber iniciado sesión: ahora te lleva a la pantalla de inicio de sesión.
- Los botones y diálogos ya no se quedan cargando tras un error inesperado o una conexión cortada (crear o clonar un proyecto, iniciar sesión, notificaciones de escritorio, varios ajustes).
- Una descarga que se atasca (servidor local, Node.js, actualización de la app) ahora falla tras un minuto en lugar de quedarse colgada. La comprobación de actualizaciones del servidor local se hace una vez por arranque y con límites de tiempo, así que navegar por la app ya no espera por ella.
- Un inicio de sesión guardado ilegible ya no bloquea la app: simplemente se te pide que vuelvas a iniciar sesión.
<!-- lang:fr -->
### Corrections
- L'application de bureau ne reste plus bloquée sur « Connexion » quand vous choisissez le serveur local ou un serveur distant sans être connecté : elle vous amène maintenant à l'écran de connexion.
- Les boutons et boîtes de dialogue ne restent plus en chargement après une erreur inattendue ou une connexion coupée (création ou clonage d'un projet, connexion, notifications de bureau, plusieurs réglages).
- Un téléchargement bloqué (serveur local, Node.js, mise à jour de l'application) échoue désormais au bout d'une minute au lieu de rester suspendu. La vérification des mises à jour du serveur local s'exécute une fois par lancement avec des délais limites, donc la navigation dans l'application ne l'attend plus.
- Une connexion enregistrée illisible ne bloque plus l'application : il vous est simplement demandé de vous reconnecter.
<!-- lang:it -->
### Correzioni
- L'app desktop non resta più bloccata su «Connessione» quando scegli il server locale o uno remoto senza aver effettuato l'accesso: ora ti porta alla schermata di accesso.
- Pulsanti e finestre non restano più in caricamento dopo un errore imprevisto o una connessione interrotta (creazione o clonazione di un progetto, accesso, notifiche desktop, diverse impostazioni).
- Un download che si blocca (server locale, Node.js, aggiornamento dell'app) ora fallisce dopo un minuto invece di restare sospeso. Il controllo aggiornamenti del server locale avviene una volta per avvio con limiti di tempo, quindi la navigazione nell'app non lo aspetta più.
- Un accesso salvato illeggibile non blocca più l'app: ti viene semplicemente chiesto di accedere di nuovo.
<!-- lang:ja -->
### バグ修正
- サインアウト状態でローカルまたはリモートのサーバーを選んだとき、デスクトップアプリが「接続中」のまま止まらなくなりました。サインイン画面に移動します。
- 予期しないエラーや接続切断の後に、ボタンやダイアログが読み込み中のまま固まらなくなりました（プロジェクトの作成・クローン、サインイン、デスクトップ通知、一部の設定）。
- 止まったダウンロード（ローカルサーバー、Node.js、アプリのアップデート）は、待ち続けずに 1 分後に失敗するようになりました。ローカルサーバーの更新確認はアプリ起動ごとに 1 回、時間制限付きで行われるため、アプリ内の移動がそれを待たなくなりました。
- 保存されたサインイン情報が読み取れなくてもアプリがブロックされず、再度サインインを求められるだけになりました。
<!-- lang:ko -->
### 버그 수정
- 로그아웃 상태에서 로컬 또는 원격 서버를 선택할 때 데스크톱 앱이 “연결 중”에서 멈추지 않고, 이제 로그인 화면으로 이동합니다.
- 예기치 않은 오류나 연결 끊김 후에 버튼과 대화상자가 로딩 상태로 멈춰 있지 않습니다(프로젝트 생성·복제, 로그인, 데스크톱 알림, 여러 설정).
- 멈춘 다운로드(로컬 서버, Node.js, 앱 업데이트)는 계속 대기하지 않고 1분 후 실패합니다. 로컬 서버 업데이트 확인은 앱 실행당 한 번, 시간 제한과 함께 실행되므로 앱 내 이동이 더 이상 이를 기다리지 않습니다.
- 읽을 수 없는 저장된 로그인 정보가 더 이상 앱을 막지 않고, 다시 로그인하라는 안내만 표시됩니다.
<!-- lang:ru -->
### Исправления
- Настольное приложение больше не зависает на «Подключение», когда вы выбираете локальный или удалённый сервер без входа в систему, — теперь оно открывает экран входа.
- Кнопки и диалоги больше не остаются в состоянии загрузки после неожиданной ошибки или обрыва соединения (создание и клонирование проекта, вход, уведомления на рабочем столе, ряд настроек).
- Зависшая загрузка (локальный сервер, Node.js, обновление приложения) теперь завершается ошибкой через минуту, а не висит бесконечно. Проверка обновлений локального сервера выполняется один раз за запуск приложения и с ограничением по времени, поэтому переходы по приложению больше её не ждут.
- Нечитаемые сохранённые данные входа больше не блокируют приложение — вас просто попросят войти снова.
<!-- lang:tr -->
### Hata düzeltmeleri
- Masaüstü uygulaması, oturum açmadan yerel ya da uzak sunucuyu seçtiğinizde artık “Bağlanıyor” durumunda takılmıyor; sizi oturum açma ekranına götürüyor.
- Düğmeler ve iletişim kutuları beklenmeyen bir hata ya da kopan bir bağlantıdan sonra artık yükleniyor durumunda kalmıyor (proje oluşturma veya klonlama, oturum açma, masaüstü bildirimleri, bazı ayarlar).
- Takılan bir indirme (yerel sunucu, Node.js, uygulama güncellemesi) artık sonsuza dek beklemek yerine bir dakika sonra hata veriyor. Yerel sunucunun güncelleme denetimi uygulama başına bir kez ve zaman sınırlarıyla çalışıyor; uygulama içinde gezinmek artık onu beklemiyor.
- Okunamayan kayıtlı oturum bilgisi artık uygulamayı engellemiyor; yalnızca yeniden oturum açmanız isteniyor.
<!-- lang:zh-CN -->
### 问题修复
- 未登录时选择本地或远程服务器，桌面应用不再卡在“正在连接”，而是会进入登录界面。
- 发生意外错误或连接中断后，按钮和对话框不再一直处于加载状态（创建或克隆项目、登录、桌面通知、部分设置）。
- 卡住的下载（本地服务器、Node.js、应用更新）现在会在一分钟后报错，而不是一直挂起。本地服务器的更新检查在每次启动应用时只运行一次并带有超时，因此在应用内切换页面不再等待它。
- 无法读取的已保存登录信息不再阻塞应用，只会提示你重新登录。
<!-- lang:zh-TW -->
### 問題修正
- 未登入時選擇本機或遠端伺服器，桌面應用程式不再卡在「連線中」，而是會進入登入畫面。
- 發生意外錯誤或連線中斷後，按鈕和對話框不再一直處於載入狀態（建立或複製專案、登入、桌面通知、部分設定）。
- 卡住的下載（本機伺服器、Node.js、應用程式更新）現在會在一分鐘後報錯，而不是一直停住。本機伺服器的更新檢查在每次啟動應用程式時只執行一次並設有逾時，因此在應用程式內切換頁面不再等待它。
- 無法讀取的已儲存登入資訊不再阻擋應用程式，只會提示你重新登入。
