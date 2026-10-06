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
- Android: the app now respects the system status bar and navigation/gesture area — content and buttons no longer slide under the top and bottom system bars on edge-to-edge devices (Android 15+)
- Android: status bar and navigation bar icons now stay readable in both light and dark themes
- Android: the launcher shows the app name as "ddagent" (was "ddagent_app"), predictive back navigation is enabled, and app data backups are disabled
- Android release builds now carry the release version name and a monotonically increasing version code, so updating the installed APK works reliably
<!-- lang:pl -->
### Poprawki błędów
- Android: aplikacja respektuje teraz górny pasek statusu i dolną strefę nawigacji/gestów — treść i przyciski nie wchodzą już pod paski systemowe na urządzeniach edge-to-edge (Android 15+)
- Android: ikony paska statusu i paska nawigacji są czytelne zarówno w jasnym, jak i ciemnym motywie
- Android: launcher pokazuje nazwę aplikacji jako „ddagent” (było „ddagent_app”), włączona jest przewidywalna nawigacja wstecz, a kopie zapasowe danych aplikacji są wyłączone
- Android: wersje release mają teraz prawidłową nazwę wersji i rosnący kod wersji, więc aktualizacja zainstalowanego APK działa niezawodnie
<!-- lang:de -->
### Fehlerbehebungen
- Android: Die App respektiert jetzt die Statusleiste und den Navigations-/Gestenbereich — Inhalte und Schaltflächen rutschen auf Edge-to-Edge-Geräten nicht mehr unter die Systemleisten (Android 15+)
- Android: Die Symbole von Status- und Navigationsleiste bleiben im hellen wie im dunklen Design lesbar
- Android: Der Launcher zeigt den App-Namen als „ddagent“ (vorher „ddagent_app“), Predictive-Back-Navigation ist aktiviert und App-Daten-Backups sind deaktiviert
- Android: Release-Builds tragen jetzt den Release-Versionsnamen und einen monoton steigenden Versionscode, sodass die Aktualisierung eines installierten APK zuverlässig funktioniert
<!-- lang:es -->
### Correcciones de errores
- Android: la app ahora respeta la barra de estado y la zona de navegación/gestos — el contenido y los botones ya no quedan bajo las barras del sistema en dispositivos edge-to-edge (Android 15+)
- Android: los iconos de la barra de estado y de navegación son legibles tanto en tema claro como oscuro
- Android: el lanzador muestra el nombre de la app como «ddagent» (antes «ddagent_app»), se activa la navegación predictiva hacia atrás y se desactivan las copias de seguridad de datos de la app
- Android: las versiones release llevan ahora el nombre de versión correcto y un código de versión creciente, por lo que actualizar el APK instalado funciona de forma fiable
<!-- lang:fr -->
### Corrections de bugs
- Android : l'application respecte désormais la barre d'état et la zone de navigation/gestuelle — le contenu et les boutons ne passent plus sous les barres système sur les appareils edge-to-edge (Android 15+)
- Android : les icônes des barres d'état et de navigation restent lisibles en thème clair comme en thème sombre
- Android : le lanceur affiche le nom de l'app « ddagent » (auparavant « ddagent_app »), la navigation retour prédictive est activée et les sauvegardes de données de l'app sont désactivées
- Android : les versions release portent désormais le nom de version correct et un code de version croissant, donc la mise à jour de l'APK installé fonctionne de manière fiable
<!-- lang:it -->
### Correzioni di bug
- Android: l'app ora rispetta la barra di stato e l'area di navigazione/gesti — contenuti e pulsanti non finiscono più sotto le barre di sistema sui dispositivi edge-to-edge (Android 15+)
- Android: le icone della barra di stato e di navigazione restano leggibili sia nel tema chiaro sia in quello scuro
- Android: il launcher mostra il nome dell'app come «ddagent» (prima «ddagent_app»), è attiva la navigazione predittiva indietro e i backup dei dati dell'app sono disabilitati
- Android: le build release ora portano il nome di versione corretto e un codice di versione crescente, quindi l'aggiornamento dell'APK installato funziona in modo affidabile
<!-- lang:ja -->
### バグ修正
- Android: アプリがステータスバーとナビゲーション/ジェスチャー領域を尊重するようになりました — edge-to-edge 端末（Android 15+）でコンテンツやボタンがシステムバーの下に隠れなくなりました
- Android: ステータスバーとナビゲーションバーのアイコンがライト/ダーク両テーマで読みやすくなりました
- Android: ランチャーに表示されるアプリ名が「ddagent」になりました（以前は「ddagent_app」）、予測型バックナビゲーションが有効化され、アプリデータのバックアップが無効化されました
- Android: リリースビルドに正しいバージョン名と単調増加するバージョンコードが付くようになり、インストール済み APK の更新が確実に動作します
<!-- lang:ko -->
### 버그 수정
- Android: 앱이 이제 상태 표시줄과 탐색/제스처 영역을 존중합니다 — edge-to-edge 기기(Android 15+)에서 콘텐츠와 버튼이 더 이상 시스템 바 아래로 들어가지 않습니다
- Android: 상태 표시줄과 탐색 바 아이콘이 라이트/다크 테마 모두에서 읽기 쉬워졌습니다
- Android: 런처에 앱 이름이 "ddagent"로 표시됩니다(이전 "ddagent_app"), 예측형 뒤로 가기가 활성화되고 앱 데이터 백업이 비활성화되었습니다
- Android: 릴리스 빌드에 올바른 버전 이름과 단조 증가하는 버전 코드가 붙어 설치된 APK 업데이트가 안정적으로 동작합니다
<!-- lang:ru -->
### Исправления ошибок
- Android: приложение теперь учитывает строку состояния и зону навигации/жестов — контент и кнопки больше не заезжают под системные панели на устройствах edge-to-edge (Android 15+)
- Android: значки строки состояния и панели навигации читаемы как в светлой, так и в тёмной теме
- Android: лаунчер показывает имя приложения «ddagent» (было «ddagent_app»), включена предиктивная навигация «назад», а резервное копирование данных приложения отключено
- Android: release-сборки теперь несут корректное имя версии и монотонно растущий код версии, поэтому обновление установленного APK работает надёжно
<!-- lang:tr -->
### Hata düzeltmeleri
- Android: uygulama artık durum çubuğuna ve gezinme/hareket alanına saygı duyuyor — içerik ve düğmeler edge-to-edge cihazlarda (Android 15+) artık sistem çubuklarının altına girmiyor
- Android: durum çubuğu ve gezinme çubuğu simgeleri hem açık hem koyu temada okunabilir
- Android: başlatıcı uygulama adını "ddagent" olarak gösteriyor (önceden "ddagent_app"), öngörülü geri gezinmesi etkin ve uygulama veri yedeklemeleri kapalı
- Android: release derlemeleri artık doğru sürüm adını ve tek yönlü artan sürüm kodunu taşıyor, böylece kurulu APK'nın güncellenmesi güvenilir çalışıyor
<!-- lang:zh-CN -->
### 错误修复
- Android：应用现在会避开系统状态栏和导航/手势区域 — 在 edge-to-edge 设备（Android 15+）上内容和按钮不再被顶部和底部系统栏遮挡
- Android：状态栏和导航栏图标在浅色和深色主题下都清晰可读
- Android：启动器显示应用名称为"ddagent"（原为"ddagent_app"），已启用预测式返回导航，并关闭了应用数据备份
- Android：发布版现在带有正确的版本名称和单调递增的版本代码，已安装 APK 的更新可以可靠工作
<!-- lang:zh-TW -->
### 錯誤修復
- Android：應用程式現在會避開系統狀態列和導覽/手勢區域 — 在 edge-to-edge 裝置（Android 15+）上內容和按鈕不再被頂部和底部系統列遮住
- Android：狀態列和導覽列圖示在淺色和深色主題下都清晰可讀
- Android：啟動器顯示的應用程式名稱為「ddagent」（原為「ddagent_app」），已啟用預測式返回導覽，並關閉了應用程式資料備份
- Android：發布版現在帶有正確的版本名稱和單調遞增的版本代碼，已安裝 APK 的更新可以可靠運作
