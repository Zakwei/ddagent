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
- Local server on Windows/Linux: fixed startup failure `ERR_DLOPEN_FAILED` on machines with Node.js newer than 22 installed — the server bundle's native modules require Node 22.x, so the app now uses exactly that (system Node 22.x, or an automatic portable download otherwise)
<!-- lang:pl -->
### Poprawki błędów
- Serwer lokalny na Windows/Linux: naprawiono błąd uruchamiania `ERR_DLOPEN_FAILED` na komputerach z Node.js nowszym niż 22 — moduły natywne pakietu serwera wymagają Node 22.x, więc aplikacja używa teraz dokładnie takiej wersji (systemowy Node 22.x albo automatycznie pobierana wersja przenośna)
<!-- lang:de -->
### Fehlerbehebungen
- Lokaler Server unter Windows/Linux: Startfehler `ERR_DLOPEN_FAILED` auf Rechnern mit Node.js neuer als 22 behoben — die nativen Module des Server-Bundles benötigen Node 22.x, daher verwendet die App jetzt genau diese Version (systemweites Node 22.x oder ein automatisch heruntergeladenes portables Laufzeitmodul)
<!-- lang:es -->
### Correcciones de errores
- Servidor local en Windows/Linux: corregido el error de inicio `ERR_DLOPEN_FAILED` en equipos con Node.js más reciente que 22 — los módulos nativos del paquete del servidor requieren Node 22.x, por lo que la aplicación ahora usa exactamente esa versión (Node 22.x del sistema o una descarga portátil automática)
<!-- lang:fr -->
### Corrections de bugs
- Serveur local sous Windows/Linux : correction de l'erreur de démarrage `ERR_DLOPEN_FAILED` sur les machines avec Node.js plus récent que la version 22 — les modules natifs du bundle serveur exigent Node 22.x, l'application utilise donc désormais exactement cette version (Node 22.x du système ou téléchargement portable automatique)
<!-- lang:it -->
### Correzioni di bug
- Server locale su Windows/Linux: corretto l'errore di avvio `ERR_DLOPEN_FAILED` su macchine con Node.js più recente della versione 22 — i moduli nativi del bundle del server richiedono Node 22.x, quindi l'app ora usa esattamente quella versione (Node 22.x di sistema o un runtime portatile scaricato automaticamente)
<!-- lang:ja -->
### バグ修正
- Windows/Linuxのローカルサーバー：Node.js 22以降がインストールされているマシンで起動時に発生していた`ERR_DLOPEN_FAILED`を修正しました — サーバーバンドルのネイティブモジュールはNode 22.xが必要なため、アプリは正確にそのバージョンを使用するようになりました（システムのNode 22.x、または自動ダウンロードされるポータブルランタイム）
<!-- lang:ko -->
### 버그 수정
- Windows/Linux 로컬 서버: Node.js 22 이후 버전이 설치된 컴퓨터에서 발생하던 `ERR_DLOPEN_FAILED` 시작 오류를 수정했습니다 — 서버 번들의 네이티브 모듈은 Node 22.x가 필요하므로 앱이 이제 정확히 해당 버전을 사용합니다(시스템 Node 22.x 또는 자동으로 다운로드되는 포터블 런타임)
<!-- lang:ru -->
### Исправления ошибок
- Локальный сервер на Windows/Linux: исправлена ошибка запуска `ERR_DLOPEN_FAILED` на машинах с Node.js новее версии 22 — нативные модули пакета сервера требуют Node 22.x, поэтому приложение теперь использует именно эту версию (системный Node 22.x или автоматически загружаемый переносной рантайм)
<!-- lang:tr -->
### Hata düzeltmeleri
- Windows/Linux'ta yerel sunucu: Node.js 22'den yeni bir sürümün yüklü olduğu makinelerde oluşan `ERR_DLOPEN_FAILED` başlangıç hatası düzeltildi — sunucu paketinin yerel modülleri Node 22.x gerektirir, bu nedenle uygulama artık tam olarak bu sürümü kullanır (sistem Node 22.x veya otomatik indirilen taşınabilir çalışma ortamı)
<!-- lang:zh-CN -->
### 问题修复
- Windows/Linux 本地服务器：修复了在安装了高于 22 版本 Node.js 的计算机上启动时报 `ERR_DLOPEN_FAILED` 的问题 — 服务器包的原生模块需要 Node 22.x，因此应用现在严格使用该版本（系统 Node 22.x 或自动下载的便携运行时）
<!-- lang:zh-TW -->
### 問題修復
- Windows/Linux 本機伺服器：修復了在安裝了高於 22 版本 Node.js 的電腦上啟動時出現 `ERR_DLOPEN_FAILED` 的問題 — 伺服器套件的原生模組需要 Node 22.x，因此應用程式現在嚴格使用該版本（系統 Node 22.x 或自動下載的可攜執行環境）
