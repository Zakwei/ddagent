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
### What's new
- Android/mobile: notifications are now real system notifications — enabling them asks for the Android notification permission, and alerts appear in the notification shade even when the app is in the background.
- Settings → About now shows a version info block: your app build (mobile/desktop/web, platform and app version) and the connected server's version and host.
- Agents/composer: the model list refreshes live from the provider CLIs whenever you open the model menu, so newly available models appear immediately.

### Bug fixes
- The "Send test notification" button now also reaches phone and desktop apps over the app's live connection — previously it only targeted browser web-push subscriptions, so nothing arrived on Android.
- Settings → Notifications no longer labels a phone as a "desktop app"; the card title and status are now platform-neutral and localized.
<!-- lang:pl -->
### Nowości
- Android/mobile: powiadomienia to teraz prawdziwe powiadomienia systemowe — włączenie prosi o uprawnienie do powiadomień Androida, a alerty pojawiają się w panelu powiadomień nawet gdy aplikacja działa w tle.
- Ustawienia → O aplikacji pokazują teraz blok „Informacje o wersji”: wersję Twojej aplikacji (mobile/desktop/web, platforma i wersja) oraz wersję i host podłączonego serwera.
- Agents/composer: lista modeli odświeża się na żywo z CLI providerów przy każdym otwarciu menu modeli — nowo dostępne modele pojawiają się od razu.

### Poprawki błędów
- Przycisk „Wyślij powiadomienie testowe” dociera teraz także do aplikacji na telefonie i desktopie przez aktywne połączenie aplikacji — wcześniej trafiał tylko do subskrypcji web-push w przeglądarce, więc na Androidzie nic nie przychodziło.
- Ustawienia → Powiadomienia nie nazywają już telefonu „aplikacją desktopową”; tytuł karty i status są neutralne platformowo i przetłumaczone.
<!-- lang:de -->
### Neu
- Android/Mobil: Benachrichtigungen sind jetzt echte Systembenachrichtigungen — beim Aktivieren wird die Android-Benachrichtigungsberechtigung angefragt, und Hinweise erscheinen auch im Hintergrund in der Benachrichtigungsleiste.
- Einstellungen → Über zeigt jetzt einen Versionsblock: deinen App-Build (Mobil/Desktop/Web, Plattform und App-Version) sowie Version und Host des verbundenen Servers.
- Agents/Composer: Die Modellliste wird bei jedem Öffnen des Modellmenüs live von den Provider-CLIs aktualisiert — neu verfügbare Modelle erscheinen sofort.

### Fehlerbehebungen
- Die Schaltfläche „Testbenachrichtigung senden" erreicht jetzt auch Telefon- und Desktop-Apps über die Live-Verbindung der App — zuvor wurden nur Web-Push-Abonnements im Browser angesprochen, sodass unter Android nichts ankam.
- Einstellungen → Benachrichtigungen bezeichnet ein Telefon nicht mehr als „Desktop-App"; Titel und Status sind jetzt plattformneutral und lokalisiert.
<!-- lang:es -->
### Novedades
- Android/móvil: las notificaciones ahora son notificaciones de sistema reales — al activarlas se solicita el permiso de notificaciones de Android, y los avisos aparecen en la barra de notificaciones incluso con la app en segundo plano.
- Ajustes → Acerca de ahora muestra un bloque de versión: tu build de la app (móvil/escritorio/web, plataforma y versión) y la versión y el host del servidor conectado.
- Agents/composer: la lista de modelos se actualiza en vivo desde las CLIs de proveedores cada vez que abres el menú de modelos, así los modelos nuevos aparecen de inmediato.

### Correcciones de errores
- El botón «Enviar notificación de prueba» ahora también llega a las apps de teléfono y escritorio por la conexión en vivo de la app — antes solo apuntaba a las suscripciones web-push del navegador, por lo que en Android no llegaba nada.
- Ajustes → Notificaciones ya no llama «app de escritorio» a un teléfono; el título y el estado ahora son neutrales y están traducidos.
<!-- lang:fr -->
### Nouveautés
- Android/mobile : les notifications sont désormais de vraies notifications système — à l'activation, l'autorisation de notifications Android est demandée, et les alertes apparaissent dans le centre de notifications même en arrière-plan.
- Paramètres → À propos affiche maintenant un bloc de version : votre build (mobile/bureau/web, plateforme et version) ainsi que la version et l'hôte du serveur connecté.
- Agents/composeur : la liste des modèles se rafraîchit en direct depuis les CLIs des fournisseurs à chaque ouverture du menu des modèles — les nouveaux modèles apparaissent immédiatement.

### Corrections de bugs
- Le bouton « Envoyer une notification de test » atteint désormais aussi les applications téléphone et bureau via la connexion en direct de l'app — il ne visait auparavant que les abonnements web-push du navigateur, donc rien n'arrivait sur Android.
- Paramètres → Notifications ne qualifie plus un téléphone d'« application de bureau » ; le titre et l'état sont désormais neutres et traduits.
<!-- lang:it -->
### Novità
- Android/mobile: le notifiche ora sono vere notifiche di sistema — all'attivazione viene richiesta l'autorizzazione alle notifiche di Android, e gli avvisi compaiono nella barra delle notifiche anche in background.
- Impostazioni → Informazioni mostra ora un blocco versione: la build dell'app (mobile/desktop/web, piattaforma e versione) e versione e host del server collegato.
- Agents/composer: l'elenco dei modelli si aggiorna in tempo reale dalle CLI dei provider a ogni apertura del menu dei modelli, così i nuovi modelli compaiono subito.

### Correzioni di bug
- Il pulsante «Invia notifica di test» ora raggiunge anche le app di telefono e desktop tramite la connessione attiva dell'app — prima colpiva solo le sottoscrizioni web-push del browser, quindi su Android non arrivava nulla.
- Impostazioni → Notifiche non chiama più un telefono «app desktop»; titolo e stato ora sono neutrali e tradotti.
<!-- lang:ja -->
### 新機能
- Android/モバイル: 通知が実際のシステム通知になりました — 有効化時に Android の通知権限を要求し、アプリがバックグラウンドでも通知シェードに表示されます。
- 設定 → このアプリに、バージョン情報ブロックを追加しました: アプリのビルド（モバイル/デスクトップ/Web、プラットフォームとバージョン）と、接続中サーバーのバージョンおよびホスト。
- Agents/コンポーザー: モデルメニューを開くたびにモデル一覧がプロバイダー CLI からライブ更新され、新しく利用可能なモデルがすぐに表示されます。

### バグ修正
- 「テスト通知を送信」ボタンが、アプリのライブ接続を通じてスマホとデスクトップのアプリにも届くようになりました — 以前はブラウザの Web Push 購読のみが対象で、Android には何も届きませんでした。
- 設定 → 通知で、スマホを「デスクトップアプリ」と呼ぶことがなくなりました。カードのタイトルと状態はプラットフォーム中立でローカライズされています。
<!-- lang:ko -->
### 새로운 기능
- Android/모바일: 알림이 이제 실제 시스템 알림입니다 — 활성화하면 Android 알림 권한을 요청하고, 앱이 백그라운드에 있어도 알림 창에 표시됩니다.
- 설정 → 앱 정보에 버전 정보 블록이 추가되었습니다: 앱 빌드(모바일/데스크톱/웹, 플랫폼 및 버전)와 연결된 서버의 버전 및 호스트.
- Agents/작성기: 모델 메뉴를 열 때마다 모델 목록이 프로바이더 CLI에서 실시간으로 새로고침되어 새로 사용 가능한 모델이 즉시 표시됩니다.

### 버그 수정
- "테스트 알림 보내기" 버튼이 이제 앱의 실시간 연결을 통해 휴대폰과 데스크톱 앱에도 전달됩니다 — 이전에는 브라우저 Web Push 구독만 대상이라 Android에는 아무것도 도착하지 않았습니다.
- 설정 → 알림에서 더 이상 휴대폰을 "데스크톱 앱"이라고 부르지 않습니다. 카드 제목과 상태가 플랫폼 중립적이며 번역되었습니다.
<!-- lang:ru -->
### Новое
- Android/мобильные: уведомления теперь настоящие системные — при включении запрашивается разрешение на уведомления Android, а оповещения появляются в шторке даже когда приложение в фоне.
- Настройки → О приложении теперь показывают блок с версией: сборка приложения (мобильная/десктоп/веб, платформа и версия) и версия и хост подключённого сервера.
- Agents/композер: список моделей обновляется вживую из CLI провайдеров при каждом открытии меню моделей — новые модели появляются сразу.

### Исправления ошибок
- Кнопка «Отправить тестовое уведомление» теперь доходит и до приложений на телефоне и десктопе через живое соединение приложения — раньше она нацеливалась только на web-push подписки браузера, поэтому на Android ничего не приходило.
- Настройки → Уведомления больше не называют телефон «десктопным приложением»; заголовок и статус теперь нейтральны и локализованы.
<!-- lang:tr -->
### Yenilikler
- Android/mobil: bildirimler artık gerçek sistem bildirimleri — etkinleştirince Android bildirim izni istenir ve uygulama arka planda olsa bile uyarılar bildirim panelinde görünür.
- Ayarlar → Uygulama hakkında artık bir sürüm bloğu gösteriyor: uygulama derlemeniz (mobil/masaüstü/web, platform ve sürüm) ile bağlı sunucunun sürümü ve ana makinesi.
- Agents/composer: model menüsünü her açtığınızda model listesi sağlayıcı CLI'larından canlı yenilenir; yeni kullanılabilir modeller anında görünür.

### Hata düzeltmeleri
- "Test bildirimi gönder" düğmesi artık uygulamanın canlı bağlantısı üzerinden telefon ve masaüstü uygulamalarına da ulaşıyor — önceden yalnızca tarayıcı web-push aboneliklerini hedefliyordu, bu yüzden Android'de hiçbir şey gelmiyordu.
- Ayarlar → Bildirimler artık bir telefonu "masaüstü uygulaması" olarak adlandırmıyor; kart başlığı ve durumu platformdan bağımsız ve yerelleştirilmiş.
<!-- lang:zh-CN -->
### 新功能
- Android/移动端：通知现在是真正的系统通知 — 启用时会请求 Android 通知权限，即使应用在后台，提醒也会出现在通知栏中。
- 设置 → 关于现在显示版本信息区块：你的应用构建（移动端/桌面端/网页、平台和版本）以及所连接服务器的版本和主机。
- Agents/编辑器：每次打开模型菜单时，模型列表都会从提供商 CLI 实时刷新，新可用的模型会立即显示。

### 错误修复
- “发送测试通知”按钮现在也会通过应用的实时连接送达手机和桌面应用 — 此前它只针对浏览器的 Web Push 订阅，因此在 Android 上收不到任何内容。
- 设置 → 通知不再把手机称为“桌面应用”；卡片标题和状态现在与平台无关并已本地化。
<!-- lang:zh-TW -->
### 新功能
- Android/行動裝置：通知現在是真正的系統通知 — 啟用時會要求 Android 通知權限，即使應用程式在背景，提醒也會出現在通知中心。
- 設定 → 關於現在顯示版本資訊區塊：你的應用程式組建（行動裝置/桌面/網頁、平台與版本）以及所連接伺服器的版本與主機。
- Agents/編輯器：每次開啟模型選單時，模型清單都會從供應商 CLI 即時重新整理，新可用的模型會立即顯示。

### 錯誤修復
- 「傳送測試通知」按鈕現在也會透過應用程式的即時連線送達手機與桌面應用程式 — 先前僅針對瀏覽器的 Web Push 訂閱，因此在 Android 上收不到任何內容。
- 設定 → 通知不再把手機稱為「桌面應用程式」；卡片標題與狀態現在與平台無關並已本地化。
