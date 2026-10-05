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
### Bug fixes
- Local server updates: the app now keeps the on-device server bundle current on every launch and restarts stale processes (orphaned or owned), so the running server always matches the installed bundle
- The "Update available" badge no longer appears on local-server profiles — release bundles cannot self-update through a shell (`spawn sh ENOENT` on Windows); the app's own pipeline owns those updates
- Agent MCP install: a provider whose MCP config file exists but is empty (Antigravity's mcp_config.json) no longer fails with "Unexpected end of JSON input", and malformed JSON now reports which file is broken
<!-- lang:pl -->
### Poprawki błędów
- Aktualizacje serwera lokalnego: aplikacja przy każdym starcie aktualizuje pakiet serwera na tym urządzeniu i restartuje nieaktualne procesy (osierocone lub własne), więc działający serwer zawsze odpowiada zainstalowanemu pakietowi
- Odznaka „Dostępna aktualizacja” nie pojawia się już przy profilach serwera lokalnego — pakiety release nie mogą aktualizować się przez powłokę (`spawn sh ENOENT` na Windowsie); aktualizacjami zarządza pipeline aplikacji
- Instalacja MCP agentów: provider, którego plik konfiguracji MCP istnieje, ale jest pusty (mcp_config.json Antigravity), nie kończy się już błędem „Unexpected end of JSON input”, a uszkodzony JSON wskazuje teraz konkretny plik
<!-- lang:de -->
### Fehlerbehebungen
- Updates des lokalen Servers: Die App hält das Server-Bundle auf dem Gerät jetzt bei jedem Start aktuell und startet veraltete Prozesse (verwaist oder eigene) neu, sodass der laufende Server immer zum installierten Bundle passt
- Das Badge „Update verfügbar“ erscheint bei lokalen Server-Profilen nicht mehr — Release-Bundles können sich nicht über die Shell selbst aktualisieren (`spawn sh ENOENT` unter Windows); die App-Pipeline übernimmt diese Updates
- Agenten-MCP-Installation: Ein Provider, dessen MCP-Konfigurationsdatei existiert, aber leer ist (Antigravitys mcp_config.json), schlägt nicht mehr mit „Unexpected end of JSON input“ fehl, und beschädigtes JSON nennt jetzt die betroffene Datei
<!-- lang:es -->
### Correcciones de errores
- Actualizaciones del servidor local: la aplicación ahora mantiene el paquete del servidor en el dispositivo actualizado en cada inicio y reinicia los procesos obsoletos (huérfanos o propios), por lo que el servidor en ejecución siempre coincide con el paquete instalado
- La insignia «Actualización disponible» ya no aparece en los perfiles de servidor local — los paquetes de release no pueden autoactualizarse mediante shell (`spawn sh ENOENT` en Windows); la propia aplicación gestiona esas actualizaciones
- Instalación de MCP de agentes: un proveedor cuyo archivo de configuración MCP existe pero está vacío (mcp_config.json de Antigravity) ya no falla con «Unexpected end of JSON input», y el JSON malformado ahora indica qué archivo está dañado
<!-- lang:fr -->
### Corrections de bugs
- Mises à jour du serveur local : l'application maintient désormais le bundle serveur de l'appareil à jour à chaque lancement et redémarre les processus obsolètes (orphelins ou propres), de sorte que le serveur en cours d'exécution corresponde toujours au bundle installé
- Le badge « Mise à jour disponible » n'apparaît plus sur les profils de serveur local — les bundles de release ne peuvent pas se mettre à jour via un shell (`spawn sh ENOENT` sous Windows) ; le pipeline de l'application gère ces mises à jour
- Installation MCP des agents : un provider dont le fichier de configuration MCP existe mais est vide (mcp_config.json d'Antigravity) n'échoue plus avec « Unexpected end of JSON input », et un JSON malformé indique désormais quel fichier est en cause
<!-- lang:it -->
### Correzioni di bug
- Aggiornamenti del server locale: l'app ora mantiene il bundle del server sul dispositivo aggiornato a ogni avvio e riavvia i processi obsoleti (orfani o propri), quindi il server in esecuzione corrisponde sempre al bundle installato
- Il badge «Aggiornamento disponibile» non appare più sui profili di server locale — i bundle di release non possono aggiornarsi tramite shell (`spawn sh ENOENT` su Windows); la pipeline dell'app gestisce questi aggiornamenti
- Installazione MCP degli agenti: un provider il cui file di configurazione MCP esiste ma è vuoto (mcp_config.json di Antigravity) non fallisce più con «Unexpected end of JSON input», e un JSON malformato ora indica quale file è corrotto
<!-- lang:ja -->
### バグ修正
- ローカルサーバーの更新：アプリは起動のたびにデバイス上のサーバーバンドルを最新に保ち、古いプロセス（孤立または自身のもの）を再起動するため、実行中のサーバーは常にインストール済みバンドルと一致します
- 「更新があります」バッジはローカルサーバーのプロファイルで表示されなくなりました — リリースバンドルはシェル経由で自己更新できないためです（Windowsでは`spawn sh ENOENT`）。これらの更新はアプリのパイプラインが担当します
- エージェントMCPインストール：MCP設定ファイルが存在するが空の場合（Antigravityのmcp_config.json）でも「Unexpected end of JSON input」で失敗しなくなり、壊れたJSONでは対象ファイル名が表示されるようになりました
<!-- lang:ko -->
### 버그 수정
- 로컬 서버 업데이트: 이제 앱이 시작될 때마다 기기의 서버 번들을 최신 상태로 유지하고 오래된 프로세스(고아 또는 자체 프로세스)를 재시작하므로 실행 중인 서버가 항상 설치된 번들과 일치합니다
- 로컬 서버 프로필에서 "업데이트 사용 가능" 배지가 더 이상 표시되지 않습니다 — 릴리스 번들은 셸을 통해 자체 업데이트할 수 없기 때문입니다(Windows에서 `spawn sh ENOENT`). 이러한 업데이트는 앱의 파이프라인이 담당합니다
- 에이전트 MCP 설치: MCP 구성 파일이 존재하지만 비어 있는 제공업체(Antigravity의 mcp_config.json)가 더 이상 "Unexpected end of JSON input"으로 실패하지 않으며, 손상된 JSON은 이제 어떤 파일인지 표시합니다
<!-- lang:ru -->
### Исправления ошибок
- Обновления локального сервера: приложение теперь при каждом запуске поддерживает пакет сервера на устройстве в актуальном состоянии и перезапускает устаревшие процессы (потерянные или собственные), поэтому работающий сервер всегда соответствует установленному пакету
- Значок «Доступно обновление» больше не отображается для профилей локального сервера — релизные пакеты не могут обновляться через оболочку (`spawn sh ENOENT` в Windows); этими обновлениями управляет само приложение
- Установка MCP агентов: провайдер, чей файл конфигурации MCP существует, но пуст (mcp_config.json Antigravity), больше не завершается ошибкой «Unexpected end of JSON input», а при повреждённом JSON указывается конкретный файл
<!-- lang:tr -->
### Hata düzeltmeleri
- Yerel sunucu güncellemeleri: uygulama artık her başlatmada cihazdaki sunucu paketini güncel tutar ve eski süreçleri (artık veya kendine ait) yeniden başlatır; böylece çalışan sunucu her zaman kurulu paketle eşleşir
- "Güncelleme mevcut" rozeti artık yerel sunucu profillerinde görünmez — yayın paketleri kabuk üzerinden kendini güncelleyemez (Windows'ta `spawn sh ENOENT`); bu güncellemeleri uygulamanın kendi hattı yönetir
- Aracı MCP kurulumu: MCP yapılandırma dosyası var olan ancak boş olan sağlayıcı (Antigravity'nin mcp_config.json'u) artık "Unexpected end of JSON input" ile başarısız olmuyor ve bozuk JSON artık hangi dosyanın hatalı olduğunu bildiriyor
<!-- lang:zh-CN -->
### 问题修复
- 本地服务器更新：应用现在每次启动时都会保持设备上的服务器包为最新，并重启过期的进程（孤立或自有进程），因此运行中的服务器始终与已安装的包一致
- "有可用更新"徽标不再出现在本地服务器配置中 — 发布包无法通过 shell 自我更新（Windows 上为 `spawn sh ENOENT`）；此类更新由应用自身的管线负责
- 智能体 MCP 安装：MCP 配置文件存在但为空的提供商（Antigravity 的 mcp_config.json）不再因 "Unexpected end of JSON input" 而失败，损坏的 JSON 现在会指明具体文件
<!-- lang:zh-TW -->
### 問題修復
- 本機伺服器更新：應用程式現在每次啟動時都會讓裝置上的伺服器套件保持最新，並重新啟動過期的處理程序（孤兒或自有），因此執行中的伺服器一律與已安裝的套件一致
- 「有可用的更新」徽章不再出現在本機伺服器設定檔中 — 發行套件無法透過 shell 自我更新（Windows 上為 `spawn sh ENOENT`）；這類更新由應用程式本身的管線負責
- 代理程式 MCP 安裝：MCP 設定檔存在但為空的提供者（Antigravity 的 mcp_config.json）不再因「Unexpected end of JSON input」而失敗，損壞的 JSON 現在會指出具體檔案
