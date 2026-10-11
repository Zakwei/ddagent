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
- Desktop app: at startup you choose the server from the list — or star one as the default and it connects straight away.
- Desktop app: the window title shows the address of the active server.
- Desktop app: a progress screen with the current step (download, install, server start, connecting) replaces the black window at startup.
- Desktop app: the local server installs the same version as the app automatically after an upgrade.
- Desktop app: the local server keeps running after you close the app, so the next start is much faster (switch on the “This device” card); navigation no longer re-checks the local server on every click.
### Fixes
- Desktop app: after switching servers the sidebar no longer shows projects and sessions from the previous server.
<!-- lang:pl -->
### Nowości
- Aplikacja desktopowa: przy starcie wybierasz serwer z listy — albo oznaczasz gwiazdką domyślny i łączy się od razu.
- Aplikacja desktopowa: tytuł okna pokazuje adres aktywnego serwera.
- Aplikacja desktopowa: zamiast czarnego okna przy starcie jest ekran z paskiem postępu i opisem etapu (pobieranie, instalacja, start serwera, łączenie).
- Aplikacja desktopowa: po aktualizacji aplikacji serwer lokalny sam instaluje tę samą wersję.
- Aplikacja desktopowa: serwer lokalny działa dalej po zamknięciu aplikacji, więc kolejny start jest dużo szybszy (przełącznik na karcie „To urządzenie”); nawigacja nie sprawdza już serwera lokalnego przy każdym kliknięciu.
### Poprawki
- Aplikacja desktopowa: po zmianie serwera pasek boczny nie pokazuje już projektów i sesji z poprzedniego serwera.
<!-- lang:de -->
### Neu
- Desktop-App: Beim Start wählst du den Server aus der Liste – oder markierst einen mit Stern als Standard, dann verbindet sie sich sofort.
- Desktop-App: Der Fenstertitel zeigt die Adresse des aktiven Servers.
- Desktop-App: Statt eines schwarzen Fensters zeigt der Start einen Fortschrittsbildschirm mit dem aktuellen Schritt (Download, Installation, Serverstart, Verbindung).
- Desktop-App: Der lokale Server installiert nach einem App-Update automatisch dieselbe Version.
- Desktop-App: Der lokale Server läuft nach dem Schließen der App weiter, dadurch startet sie beim nächsten Mal deutlich schneller (Schalter auf der Karte „Dieses Gerät“); die Navigation prüft den lokalen Server nicht mehr bei jedem Klick.
### Fehlerbehebungen
- Desktop-App: Nach einem Serverwechsel zeigt die Seitenleiste keine Projekte und Sitzungen des vorherigen Servers mehr.
<!-- lang:es -->
### Novedades
- App de escritorio: al iniciar eliges el servidor de la lista, o marcas uno con estrella como predeterminado y se conecta directamente.
- App de escritorio: el título de la ventana muestra la dirección del servidor activo.
- App de escritorio: en lugar de una ventana negra, el inicio muestra una pantalla de progreso con el paso actual (descarga, instalación, inicio del servidor, conexión).
- App de escritorio: tras actualizar la app, el servidor local instala automáticamente la misma versión.
- App de escritorio: el servidor local sigue en ejecución al cerrar la app, así el siguiente inicio es mucho más rápido (interruptor en la tarjeta «Este dispositivo»); la navegación ya no comprueba el servidor local en cada clic.
### Correcciones
- App de escritorio: tras cambiar de servidor, la barra lateral ya no muestra proyectos y sesiones del servidor anterior.
<!-- lang:fr -->
### Nouveautés
- Application de bureau : au démarrage, vous choisissez le serveur dans la liste — ou marquez-en un d'une étoile comme serveur par défaut pour vous y connecter directement.
- Application de bureau : le titre de la fenêtre affiche l'adresse du serveur actif.
- Application de bureau : au lieu d'une fenêtre noire, le démarrage affiche un écran de progression avec l'étape en cours (téléchargement, installation, démarrage du serveur, connexion).
- Application de bureau : après une mise à jour de l'app, le serveur local installe automatiquement la même version.
- Application de bureau : le serveur local continue de tourner après la fermeture de l'app, le démarrage suivant est donc bien plus rapide (interrupteur sur la carte « Cet appareil ») ; la navigation ne revérifie plus le serveur local à chaque clic.
### Corrections
- Application de bureau : après un changement de serveur, la barre latérale n'affiche plus les projets et sessions du serveur précédent.
<!-- lang:it -->
### Novità
- App desktop: all'avvio scegli il server dall'elenco, oppure contrassegnane uno con la stella come predefinito e si connette subito.
- App desktop: il titolo della finestra mostra l'indirizzo del server attivo.
- App desktop: invece di una finestra nera, all'avvio compare una schermata di avanzamento con il passaggio in corso (download, installazione, avvio del server, connessione).
- App desktop: dopo l'aggiornamento dell'app, il server locale installa automaticamente la stessa versione.
- App desktop: il server locale resta in esecuzione dopo la chiusura dell'app, così l'avvio successivo è molto più rapido (interruttore nella scheda «Questo dispositivo»); la navigazione non ricontrolla più il server locale a ogni clic.
### Correzioni
- App desktop: dopo il cambio di server la barra laterale non mostra più progetti e sessioni del server precedente.
<!-- lang:ja -->
### 新機能
- デスクトップアプリ：起動時に一覧からサーバーを選択できます。星を付けたサーバーはデフォルトとなり、すぐに接続されます。
- デスクトップアプリ：ウィンドウタイトルにアクティブなサーバーのアドレスが表示されます。
- デスクトップアプリ：起動時の黒い画面の代わりに、現在の処理（ダウンロード、インストール、サーバー起動、接続）を示す進行状況画面が表示されます。
- デスクトップアプリ：アプリの更新後、ローカルサーバーにも同じバージョンが自動でインストールされます。
- デスクトップアプリ：アプリを閉じてもローカルサーバーが動作し続けるため、次回の起動が大幅に速くなります（「このデバイス」カードのスイッチで設定）。画面遷移のたびにローカルサーバーを確認しなくなりました。
### 修正
- デスクトップアプリ：サーバー切り替え後、サイドバーに前のサーバーのプロジェクトやセッションが表示されなくなりました。
<!-- lang:ko -->
### 새 기능
- 데스크톱 앱: 시작 시 목록에서 서버를 선택합니다. 별표로 기본 서버를 지정하면 바로 연결됩니다.
- 데스크톱 앱: 창 제목에 활성 서버 주소가 표시됩니다.
- 데스크톱 앱: 시작 시 검은 창 대신 현재 단계(다운로드, 설치, 서버 시작, 연결)를 보여 주는 진행 화면이 표시됩니다.
- 데스크톱 앱: 앱을 업데이트하면 로컬 서버도 같은 버전이 자동으로 설치됩니다.
- 데스크톱 앱: 앱을 닫아도 로컬 서버가 계속 실행되어 다음 시작이 훨씬 빨라집니다(‘이 기기’ 카드의 스위치). 이제 클릭할 때마다 로컬 서버를 다시 확인하지 않습니다.
### 수정 사항
- 데스크톱 앱: 서버를 전환한 후 사이드바에 이전 서버의 프로젝트와 세션이 더 이상 표시되지 않습니다.
<!-- lang:ru -->
### Новое
- Десктопное приложение: при запуске сервер выбирается из списка — или отметьте один звёздочкой как сервер по умолчанию, и подключение произойдёт сразу.
- Десктопное приложение: в заголовке окна отображается адрес активного сервера.
- Десктопное приложение: вместо чёрного окна при запуске показывается экран с индикатором и текущим этапом (загрузка, установка, запуск сервера, подключение).
- Десктопное приложение: после обновления приложения локальный сервер автоматически устанавливает ту же версию.
- Десктопное приложение: локальный сервер продолжает работать после закрытия приложения, поэтому следующий запуск гораздо быстрее (переключатель на карточке «Это устройство»); навигация больше не проверяет локальный сервер при каждом клике.
### Исправления
- Десктопное приложение: после смены сервера боковая панель больше не показывает проекты и сессии предыдущего сервера.
<!-- lang:tr -->
### Yenilikler
- Masaüstü uygulaması: Başlangıçta sunucuyu listeden seçersiniz ya da birini yıldızla varsayılan yaparsınız ve doğrudan bağlanır.
- Masaüstü uygulaması: Pencere başlığı etkin sunucunun adresini gösterir.
- Masaüstü uygulaması: Başlangıçta siyah pencere yerine geçerli adımı (indirme, kurulum, sunucu başlatma, bağlanma) gösteren bir ilerleme ekranı var.
- Masaüstü uygulaması: Uygulama güncellendikten sonra yerel sunucu otomatik olarak aynı sürümü kurar.
- Masaüstü uygulaması: Yerel sunucu, uygulama kapatıldıktan sonra çalışmaya devam eder; böylece sonraki başlangıç çok daha hızlıdır (“Bu cihaz” kartındaki anahtar). Gezinme artık her tıklamada yerel sunucuyu yeniden denetlemiyor.
### Düzeltmeler
- Masaüstü uygulaması: Sunucu değiştirildikten sonra kenar çubuğu artık önceki sunucunun projelerini ve oturumlarını göstermiyor.
<!-- lang:zh-CN -->
### 新功能
- 桌面应用：启动时从列表中选择服务器，或用星标将某个服务器设为默认，即可直接连接。
- 桌面应用：窗口标题显示当前服务器的地址。
- 桌面应用：启动时不再是黑色窗口，而是显示当前步骤（下载、安装、启动服务器、连接）的进度界面。
- 桌面应用：应用升级后，本地服务器会自动安装相同版本。
- 桌面应用：关闭应用后本地服务器保持运行，下次启动更快（在“此设备”卡片上切换）；导航时不再每次点击都重新检查本地服务器。
### 修复
- 桌面应用：切换服务器后，侧边栏不再显示上一个服务器的项目和会话。
<!-- lang:zh-TW -->
### 新功能
- 桌面應用程式：啟動時從清單選擇伺服器，或以星號將某個伺服器設為預設，即可直接連線。
- 桌面應用程式：視窗標題會顯示目前伺服器的位址。
- 桌面應用程式：啟動時不再是黑色視窗，而是顯示目前步驟（下載、安裝、啟動伺服器、連線）的進度畫面。
- 桌面應用程式：應用程式更新後，本機伺服器會自動安裝相同版本。
- 桌面應用程式：關閉應用程式後本機伺服器仍持續執行，下次啟動更快（在「此裝置」卡片上切換）；導覽時不再每次點擊都重新檢查本機伺服器。
### 修正
- 桌面應用程式：切換伺服器後，側邊欄不再顯示上一個伺服器的專案與工作階段。
