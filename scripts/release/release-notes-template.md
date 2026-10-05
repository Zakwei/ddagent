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
- The desktop app can now run the ddagent server on this device — choose "This device" on the connect screen: it downloads the matching server bundle, finds or installs a Node.js 22+ runtime, and starts it on 127.0.0.1. Connecting to a remote server still works as before
- An already-running server on this machine (e.g. a systemd service) is adopted instead of duplicated, and is never stopped when the app exits
- New installers: a Windows setup.exe wizard and a Linux .deb package alongside the plain archives

### Bug fixes
- Fixed the missing libsecret dependency that blocked the Linux desktop build

<!-- lang:pl -->
### Co nowego
- Aplikacja desktopowa może teraz uruchomić serwer ddagent na tym urządzeniu — wybierz „To urządzenie” na ekranie połączenia: pobierze pasujący pakiet serwera, znajdzie lub zainstaluje Node.js 22+ i uruchomi go na 127.0.0.1. Łączenie ze zdalnym serwerem działa jak dotychczas
- Już działający serwer na tym komputerze (np. usługa systemd) zostanie przejęty zamiast zdublowany i nigdy nie jest zatrzymywany przy zamykaniu aplikacji
- Nowe instalatory: kreator setup.exe dla Windows i pakiet .deb dla Linuksa obok zwykłych archiwów

### Poprawki błędów
- Naprawiono brakującą zależność libsecret, która blokowała build desktopowy dla Linuksa

<!-- lang:de -->
### Neu
- Die Desktop-App kann den ddagent-Server jetzt auf diesem Gerät ausführen — wähle „Dieses Gerät“ im Verbindungsbildschirm: Es lädt das passende Server-Bundle herunter, findet oder installiert eine Node.js-22+-Laufzeit und startet ihn auf 127.0.0.1. Die Verbindung zu einem Remote-Server funktioniert weiterhin wie gewohnt
- Ein bereits laufender Server auf diesem Rechner (z. B. ein systemd-Dienst) wird übernommen statt dupliziert und beim Beenden der App nie gestoppt
- Neue Installer: ein Windows-setup.exe-Assistent und ein Linux-.deb-Paket neben den einfachen Archiven

### Fehlerbehebungen
- Fehlende libsecret-Abhängigkeit behoben, die den Linux-Desktop-Build blockierte

<!-- lang:es -->
### Novedades
- La aplicación de escritorio ahora puede ejecutar el servidor ddagent en este dispositivo — elige «Este dispositivo» en la pantalla de conexión: descarga el paquete de servidor correspondiente, encuentra o instala un runtime de Node.js 22+ y lo inicia en 127.0.0.1. La conexión a un servidor remoto sigue funcionando como antes
- Un servidor ya en ejecución en esta máquina (p. ej. un servicio systemd) se adopta en lugar de duplicarse y nunca se detiene al cerrar la aplicación
- Nuevos instaladores: un asistente setup.exe para Windows y un paquete .deb para Linux junto a los archivos comprimidos

### Correcciones de errores
- Se corrigió la dependencia libsecret que faltaba y bloqueaba la compilación de escritorio en Linux

<!-- lang:fr -->
### Nouveautés
- L'application de bureau peut désormais exécuter le serveur ddagent sur cet appareil — choisissez « Cet appareil » sur l'écran de connexion : elle télécharge le bundle serveur correspondant, trouve ou installe un runtime Node.js 22+ et le démarre sur 127.0.0.1. La connexion à un serveur distant fonctionne toujours comme avant
- Un serveur déjà en cours d'exécution sur cette machine (par ex. un service systemd) est adopté au lieu d'être dupliqué et n'est jamais arrêté à la fermeture de l'application
- Nouveaux installateurs : un assistant setup.exe pour Windows et un paquet .deb pour Linux en plus des archives simples

### Corrections de bugs
- Correction de la dépendance libsecret manquante qui bloquait le build Linux de bureau

<!-- lang:it -->
### Novità
- L'app desktop ora può eseguire il server ddagent su questo dispositivo — scegli «Questo dispositivo» nella schermata di connessione: scarica il bundle server corrispondente, trova o installa un runtime Node.js 22+ e lo avvia su 127.0.0.1. La connessione a un server remoto funziona ancora come prima
- Un server già in esecuzione su questa macchina (ad es. un servizio systemd) viene adottato invece di essere duplicato e non viene mai arrestato all'uscita dell'app
- Nuovi installer: una procedura guidata setup.exe per Windows e un pacchetto .deb per Linux insieme ai semplici archivi

### Correzioni di bug
- Corretta la dipendenza libsecret mancante che bloccava la build desktop per Linux

<!-- lang:ja -->
### 新機能
- デスクトップアプリがこのデバイス上でddagentサーバーを実行できるようになりました — 接続画面で「このデバイス」を選択すると、対応するサーバーバンドルをダウンロードし、Node.js 22以降のランタイムを検出またはインストールして、127.0.0.1で起動します。リモートサーバーへの接続は従来どおり利用できます
- このマシンですでに実行中のサーバー（systemdサービスなど）は重複起動せず引き継がれ、アプリ終了時に停止されることはありません
- 新しいインストーラー：通常のアーカイブに加えて、Windows用setup.exeウィザードとLinux用.debパッケージ

### バグ修正
- Linuxデスクトップビルドを妨げていたlibsecret依存関係の不足を修正しました

<!-- lang:ko -->
### 새로운 기능
- 데스크톱 앱이 이제 이 기기에서 ddagent 서버를 실행할 수 있습니다 — 연결 화면에서 "이 기기"를 선택하면 해당 서버 번들을 다운로드하고, Node.js 22+ 런타임을 찾거나 설치한 뒤 127.0.0.1에서 시작합니다. 원격 서버 연결도 이전과 같이 사용할 수 있습니다
- 이 컴퓨터에서 이미 실행 중인 서버(예: systemd 서비스)는 중복 실행하지 않고 그대로 사용하며, 앱 종료 시에도 중지되지 않습니다
- 새로운 설치 프로그램: 일반 아카이브와 함께 Windows용 setup.exe 마법사와 Linux용 .deb 패키지

### 버그 수정
- Linux 데스크톱 빌드를 차단하던 libsecret 종속성 누락 문제를 수정했습니다

<!-- lang:ru -->
### Что нового
- Десктопное приложение теперь может запускать сервер ddagent на этом устройстве — выберите «Это устройство» на экране подключения: оно скачает подходящий пакет сервера, найдёт или установит Node.js 22+ и запустит его на 127.0.0.1. Подключение к удалённому серверу работает как прежде
- Уже запущенный сервер на этой машине (например, служба systemd) будет использован вместо создания дубликата и никогда не останавливается при выходе из приложения
- Новые установщики: мастер setup.exe для Windows и пакет .deb для Linux в дополнение к обычным архивам

### Исправления ошибок
- Исправлена отсутствующая зависимость libsecret, блокировавшая сборку десктопной версии для Linux

<!-- lang:tr -->
### Yenilikler
- Masaüstü uygulaması artık ddagent sunucusunu bu cihazda çalıştırabilir — bağlantı ekranında "Bu cihaz"ı seçin: eşleşen sunucu paketini indirir, Node.js 22+ çalışma ortamını bulur veya kurar ve 127.0.0.1 üzerinde başlatır. Uzak sunucuya bağlanma eskisi gibi çalışır
- Bu makinede zaten çalışan bir sunucu (ör. bir systemd servisi) çoğaltılmak yerine devralınır ve uygulama kapanırken asla durdurulmaz
- Yeni kurulum programları: sade arşivlerin yanında Windows için setup.exe sihirbazı ve Linux için .deb paketi

### Hata düzeltmeleri
- Linux masaüstü derlemesini engelleyen eksik libsecret bağımlılığı düzeltildi

<!-- lang:zh-CN -->
### 新功能
- 桌面应用现在可以在本设备上运行 ddagent 服务器 — 在连接界面选择"本设备"：它会下载对应的服务器包，查找或安装 Node.js 22+ 运行时，并在 127.0.0.1 上启动。连接远程服务器的方式保持不变
- 本机已在运行的服务器（如 systemd 服务）会被直接使用而不会重复启动，应用退出时也绝不会将其停止
- 新增安装程序：Windows setup.exe 安装向导和 Linux .deb 软件包，与压缩包同时提供

### 问题修复
- 修复了阻碍 Linux 桌面构建的缺失 libsecret 依赖

<!-- lang:zh-TW -->
### 新功能
- 桌面應用程式現在可以在本裝置上執行 ddagent 伺服器 — 在連線畫面選擇「此裝置」：它會下載對應的伺服器套件，尋找或安裝 Node.js 22+ 執行環境，並在 127.0.0.1 上啟動。連線到遠端伺服器的方式維持不變
- 本機已在執行的伺服器（如 systemd 服務）會被直接使用而不會重複啟動，應用程式結束時也絕不會將其停止
- 新增安裝程式：Windows setup.exe 安裝精靈與 Linux .deb 套件，與壓縮檔一併提供

### 問題修復
- 修復了阻礙 Linux 桌面建置的缺少 libsecret 相依性
