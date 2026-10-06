<!--
  GitHub draft-release body template — the server-release workflow
  (.github/workflows/server-release.yml) passes this file to
  `gh release create --notes-file`, so every draft release created on a tag
  starts with this body.

  AGENTS.md requires per-language release notes split by
  `<!-- lang:<code> -->` markers — the Flutter Settings → About changelog
  renders only the section matching the active UI language, `en` is the
  fallback. All 12 UI locales are below; replace the TODO lines in EVERY
  section, then publish the draft. (This header comment never renders — it
  sits before the first lang marker and markdown comments are invisible
  anyway.)
-->
<!-- lang:en -->
### New
- Server switcher: the connect screen is now reachable from inside the app (server icon in the navigation rail and drawer, plus a "Change server" link on the login and setup screens) — switching between the local server and remote servers no longer requires reinstalling
- Saved server profiles distinguish local vs remote entries, highlight the active one, and switching to another server clears the old login token for a clean sign-in

### Bug fixes
- Local server updates no longer corrupt the install when the running server holds file locks (Windows): the bundle is swapped with atomic renames, interrupted installs are recovered on the next launch, and orphaned servers from previous app runs are correctly detected and replaced
- Android: the release build can now reach the network — INTERNET permission was missing from the release manifest, so every request failed with "Failed host lookup"; http:// LAN servers are allowed as well
<!-- lang:pl -->
### Nowości
- Przełącznik serwera: ekran połączenia jest teraz dostępny z poziomu aplikacji (ikona serwera na szynie nawigacji i w szufladzie oraz link „Zmień serwer” na ekranach logowania i konfiguracji) — przełączanie między serwerem lokalnym a zdalnym nie wymaga już reinstalacji
- Zapisane profile serwerów rozróżniają wpisy lokalne i zdalne, podświetlają aktywny, a przełączenie na inny serwer czyści stary token logowania

### Poprawki błędów
- Aktualizacje serwera lokalnego nie psują już instalacji, gdy działający serwer blokuje pliki (Windows): pakiet jest podmieniany atomowymi zmianami nazw, przerwana instalacja jest naprawiana przy następnym starcie, a osierocone serwery z poprzednich uruchomień aplikacji są poprawnie wykrywane i zastępowane
- Android: wersja release może teraz łączyć się z siecią — w manifeście brakowało uprawnienia INTERNET, więc każde żądanie kończyło się błędem „Failed host lookup”; dozwolone są też serwery http:// w sieci lokalnej
<!-- lang:de -->
### Neu
- Server-Wechsler: Der Verbindungsbildschirm ist jetzt aus der App erreichbar (Server-Symbol in der Navigationsleiste und im Drawer sowie ein Link „Server wechseln“ auf den Login- und Setup-Bildschirmen) — der Wechsel zwischen lokalem und Remote-Server erfordert keine Neuinstallation mehr
- Gespeicherte Serverprofile unterscheiden lokale und Remote-Einträge, markieren den aktiven, und der Wechsel zu einem anderen Server löscht das alte Login-Token für eine saubere Anmeldung

### Fehlerbehebungen
- Updates des lokalen Servers beschädigen die Installation nicht mehr, wenn der laufende Server Dateisperren hält (Windows): Das Bundle wird per atomarem Rename getauscht, abgebrochene Installationen werden beim nächsten Start repariert, und verwaiste Server aus früheren App-Läufen werden korrekt erkannt und ersetzt
- Android: Der Release-Build kann jetzt auf das Netzwerk zugreifen — im Release-Manifest fehlte die INTERNET-Berechtigung, sodass jede Anfrage mit „Failed host lookup“ scheiterte; http://-Server im LAN sind ebenfalls erlaubt
<!-- lang:es -->
### Novedades
- Selector de servidor: la pantalla de conexión ahora es accesible desde la aplicación (icono de servidor en la barra de navegación y en el menú, además de un enlace «Cambiar servidor» en las pantallas de inicio de sesión y configuración) — cambiar entre el servidor local y uno remoto ya no requiere reinstalar
- Los perfiles de servidor guardados distinguen entradas locales y remotas, resaltan la activa, y cambiar a otro servidor borra el antiguo token de sesión

### Correcciones de errores
- Las actualizaciones del servidor local ya no dañan la instalación cuando el servidor en ejecución bloquea archivos (Windows): el paquete se intercambia con renombrados atómicos, las instalaciones interrumpidas se recuperan en el siguiente inicio y los servidores huérfanos de ejecuciones anteriores se detectan y reemplazan correctamente
- Android: la versión release ya puede acceder a la red — faltaba el permiso INTERNET en el manifiesto de release, por lo que toda petición fallaba con «Failed host lookup»; también se permiten servidores http:// en la LAN
<!-- lang:fr -->
### Nouveautés
- Sélecteur de serveur : l'écran de connexion est désormais accessible depuis l'application (icône serveur dans la barre de navigation et le tiroir, plus un lien « Changer de serveur » sur les écrans de connexion et de configuration) — basculer entre serveur local et distant ne nécessite plus de réinstallation
- Les profils de serveur enregistrés distinguent les entrées locales et distantes, mettent en évidence celle qui est active, et le passage à un autre serveur efface l'ancien jeton de connexion

### Corrections de bugs
- Les mises à jour du serveur local ne corrompent plus l'installation quand le serveur en cours verrouille des fichiers (Windows) : le bundle est remplacé par renommage atomique, les installations interrompues sont réparées au lancement suivant, et les serveurs orphelins des exécutions précédentes sont correctement détectés et remplacés
- Android : la version release peut désormais accéder au réseau — la permission INTERNET manquait dans le manifeste de release, donc chaque requête échouait avec « Failed host lookup » ; les serveurs http:// du réseau local sont aussi autorisés
<!-- lang:it -->
### Novità
- Selettore del server: la schermata di connessione è ora raggiungibile dall'app (icona server nella barra di navigazione e nel drawer, più un link «Cambia server» nelle schermate di accesso e configurazione) — passare dal server locale a uno remoto non richiede più la reinstallazione
- I profili server salvati distinguono le voci locali e remote, evidenziano quella attiva, e il passaggio a un altro server cancella il vecchio token di accesso

### Correzioni di bug
- Gli aggiornamenti del server locale non corrompono più l'installazione quando il server in esecuzione blocca i file (Windows): il bundle viene sostituito con rinomine atomiche, le installazioni interrotte vengono recuperate all'avvio successivo e i server orfani delle esecuzioni precedenti vengono rilevati e sostituiti correttamente
- Android: la build release può ora accedere alla rete — nel manifest di release mancava il permesso INTERNET, quindi ogni richiesta falliva con «Failed host lookup»; sono consentiti anche i server http:// nella LAN
<!-- lang:ja -->
### 新機能
- サーバー切り替え: 接続画面がアプリ内から開けるようになりました（ナビゲーションレールとドロワーのサーバーアイコン、ログイン/セットアップ画面の「サーバーを変更」リンク）— ローカルサーバーとリモートサーバーの切り替えに再インストールは不要です
- 保存済みサーバープロファイルはローカル/リモートを区別し、使用中のものを強調表示します。別のサーバーへの切り替え時は古いログイントークンを消去してクリーンなサインインにします

### バグ修正
- 実行中のサーバーがファイルロックを保持していてもローカルサーバーの更新がインストールを壊さなくなりました（Windows）: バンドルはアトミックなリネームで入れ替わり、中断したインストールは次回起動時に復旧し、以前のアプリ実行の孤児サーバーも正しく検出・置換されます
- Android: リリースビルドがネットワークにアクセスできるようになりました — リリースマニフェストに INTERNET パーミッションがなく、すべてのリクエストが「Failed host lookup」で失敗していました。LAN 内の http:// サーバーも許可されます
<!-- lang:ko -->
### 새로운 기능
- 서버 전환: 연결 화면을 이제 앱 안에서 열 수 있습니다（탐색 레일과 드로어의 서버 아이콘, 로그인/설정 화면의 "서버 변경" 링크）— 로컬 서버와 원격 서버 간 전환에 재설치가 필요 없습니다
- 저장된 서버 프로필이 로컬/원격 항목을 구분하고 활성 항목을 강조 표시하며, 다른 서버로 전환하면 이전 로그인 토큰을 지워 깨끗한 로그인을 보장합니다

### 버그 수정
- 실행 중인 서버가 파일 잠금을 유지해도 로컬 서버 업데이트가 설치를 손상시키지 않습니다（Windows）: 번들이 원자적 이름 변경으로 교체되고, 중단된 설치는 다음 실행 시 복구되며, 이전 앱 실행의 고아 서버도 올바르게 감지·교체됩니다
- Android: 릴리스 빌드가 이제 네트워크에 접근할 수 있습니다 — 릴리스 매니페스트에 INTERNET 권한이 없어 모든 요청이 "Failed host lookup"으로 실패했습니다. LAN의 http:// 서버도 허용됩니다
<!-- lang:ru -->
### Новое
- Переключатель сервера: экран подключения теперь доступен из приложения (значок сервера в навигационной панели и в шторке, а также ссылка «Сменить сервер» на экранах входа и настройки) — переключение между локальным и удалённым сервером больше не требует переустановки
- Сохранённые профили серверов различают локальные и удалённые записи, подсвечивают активную, а при переключении на другой сервер старый токен входа очищается

### Исправления ошибок
- Обновления локального сервера больше не повреждают установку, когда работающий сервер держит блокировки файлов (Windows): пакет подменяется атомарными переименованиями, прерванная установка восстанавливается при следующем запуске, а осиротевшие серверы из прошлых запусков корректно определяются и заменяются
- Android: release-сборка теперь имеет доступ к сети — в release-манифесте отсутствовало разрешение INTERNET, поэтому каждый запрос завершался ошибкой «Failed host lookup»; также разрешены http://-серверы в локальной сети
<!-- lang:tr -->
### Yenilikler
- Sunucu değiştirici: bağlantı ekranı artık uygulama içinden erişilebilir (gezinme çubuğundaki ve çekmecedeki sunucu simgesi, ayrıca giriş ve kurulum ekranlarındaki "Sunucuyu değiştir" bağlantısı) — yerel ve uzak sunucu arasında geçiş artık yeniden kurulum gerektirmiyor
- Kayıtlı sunucu profilleri yerel ve uzak girdileri ayırt eder, aktif olanı vurgular ve başka bir sunucuya geçiş eski oturum anahtarını temizler

### Hata düzeltmeleri
- Çalışan sunucu dosya kilitleri tutarken yerel sunucu güncellemeleri artık kurulumu bozmuyor (Windows): paket atomik yeniden adlandırmalarla değiştiriliyor, yarıda kalan kurulumlar bir sonraki açılışta onarılıyor ve önceki çalıştırmalardan kalan sahipsiz sunucular doğru şekilde algılanıp değiştiriliyor
- Android: release derlemesi artık ağa erişebiliyor — release manifestinde INTERNET izni eksikti, bu yüzden her istek "Failed host lookup" ile başarısız oluyordu; LAN'daki http:// sunucularına da izin veriliyor
<!-- lang:zh-CN -->
### 新功能
- 服务器切换器：连接界面现在可以从应用内访问（导航栏和抽屉中的服务器图标，以及登录和设置界面上的"更换服务器"链接）— 在本地服务器和远程服务器之间切换不再需要重新安装
- 已保存的服务器配置区分本地和远程条目、高亮显示当前使用的条目，切换到其他服务器时会清除旧的登录令牌以获得干净的登录状态

### 错误修复
- 当运行中的服务器持有文件锁时，本地服务器更新不再损坏安装（Windows）：软件包通过原子重命名完成替换，中断的安装会在下次启动时恢复，之前应用运行遗留的孤立服务器也会被正确检测和替换
- Android：发布版现在可以访问网络 — 发布清单中缺少 INTERNET 权限，导致所有请求都以"Failed host lookup"失败；局域网内的 http:// 服务器也被允许
<!-- lang:zh-TW -->
### 新功能
- 伺服器切換器：連線畫面現在可以從應用程式內存取（導航欄和抽屜中的伺服器圖示，以及登入和設定畫面上的「更換伺服器」連結）— 在本機伺服器和遠端伺服器之間切換不再需要重新安裝
- 已儲存的伺服器設定檔區分本機和遠端項目、突顯目前使用的項目，切換到其他伺服器時會清除舊的登入權杖以獲得乾淨的登入狀態

### 錯誤修復
- 當執行中的伺服器持有檔案鎖定時，本機伺服器更新不再損壞安裝（Windows）：套件透過原子重新命名完成替換，中斷的安裝會在下次啟動時復原，先前應用程式執行遺留的孤立伺服器也會被正確偵測和替換
- Android：發布版現在可以存取網路 — 發布清單中缺少 INTERNET 權限，導致所有請求都以「Failed host lookup」失敗；區域網路內的 http:// 伺服器也被允許
