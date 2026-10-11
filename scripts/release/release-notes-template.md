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
- Change server → “Open in new window” opens another app window pinned to the chosen server; each window keeps its own layout and login.
### Bug fixes
- Launching the desktop app a second time brings the running window forward instead of starting a broken copy whose chat panes stayed grey.
<!-- lang:pl -->
### Nowości
- Zmień serwer → „Otwórz w nowym oknie” otwiera kolejne okno aplikacji przypięte do wybranego serwera; każde okno ma własny układ i logowanie.
### Poprawki
- Ponowne uruchomienie aplikacji desktopowej wysuwa otwarte już okno zamiast startować wadliwą kopię, w której panele czatu były szare.
<!-- lang:de -->
### Neu
- Server wechseln → „In neuem Fenster öffnen“ öffnet ein weiteres App-Fenster für den gewählten Server; jedes Fenster behält eigenes Layout und eigene Anmeldung.
### Fehlerbehebungen
- Ein zweiter Start der Desktop-App holt das laufende Fenster nach vorne, statt eine fehlerhafte Kopie mit grauen Chat-Bereichen zu starten.
<!-- lang:es -->
### Novedades
- Cambiar servidor → «Abrir en una ventana nueva» abre otra ventana de la app fijada al servidor elegido; cada ventana conserva su propio diseño e inicio de sesión.
### Correcciones
- Abrir la app de escritorio por segunda vez trae al frente la ventana ya abierta en lugar de iniciar una copia defectuosa con los paneles de chat en gris.
<!-- lang:fr -->
### Nouveautés
- Changer de serveur → « Ouvrir dans une nouvelle fenêtre » ouvre une autre fenêtre de l'app liée au serveur choisi ; chaque fenêtre garde sa propre disposition et sa connexion.
### Corrections
- Relancer l'app de bureau ramène la fenêtre déjà ouverte au premier plan au lieu de démarrer une copie défectueuse aux panneaux de chat gris.
<!-- lang:it -->
### Novità
- Cambia server → «Apri in una nuova finestra» apre un'altra finestra dell'app legata al server scelto; ogni finestra mantiene layout e accesso propri.
### Correzioni
- Avviare di nuovo l'app desktop porta in primo piano la finestra già aperta invece di avviare una copia difettosa con i pannelli chat grigi.
<!-- lang:ja -->
### 新機能
- サーバーを変更 →「新しいウィンドウで開く」で、選んだサーバー専用のアプリウィンドウをもう一つ開けます。各ウィンドウはレイアウトとログインを個別に保持します。
### バグ修正
- デスクトップアプリを再度起動すると、チャット欄が灰色になる不完全なコピーを起動せず、既に開いているウィンドウを前面に表示します。
<!-- lang:ko -->
### 새 기능
- 서버 변경 → ‘새 창에서 열기’로 선택한 서버에 고정된 앱 창을 하나 더 열 수 있습니다. 각 창은 자체 레이아웃과 로그인을 유지합니다.
### 버그 수정
- 데스크톱 앱을 다시 실행하면 채팅 영역이 회색으로 남는 잘못된 복사본을 시작하지 않고 이미 열린 창을 앞으로 가져옵니다.
<!-- lang:ru -->
### Новое
- Сменить сервер → «Открыть в новом окне» открывает ещё одно окно приложения, привязанное к выбранному серверу; у каждого окна своя раскладка и вход.
### Исправления
- Повторный запуск десктопного приложения выводит уже открытое окно на передний план вместо запуска сломанной копии с серыми панелями чата.
<!-- lang:tr -->
### Yenilikler
- Sunucuyu değiştir → “Yeni pencerede aç”, seçilen sunucuya bağlı başka bir uygulama penceresi açar; her pencere kendi düzenini ve oturumunu korur.
### Hata düzeltmeleri
- Masaüstü uygulamasını ikinci kez başlatmak, sohbet panelleri gri kalan bozuk bir kopya açmak yerine açık pencereyi öne getirir.
<!-- lang:zh-CN -->
### 新功能
- 更换服务器 →“在新窗口中打开”可为所选服务器再打开一个应用窗口；每个窗口保留各自的布局和登录。
### 问题修复
- 再次启动桌面应用时会将已打开的窗口置于前台，而不是启动一个聊天面板显示为灰色的损坏副本。
<!-- lang:zh-TW -->
### 新功能
- 更換伺服器 →「在新視窗中開啟」可為所選伺服器再開一個應用程式視窗；每個視窗保留各自的版面與登入。
### 錯誤修正
- 再次啟動桌面應用程式時會將已開啟的視窗移到最前方，而不是啟動聊天面板呈灰色的損壞副本。
