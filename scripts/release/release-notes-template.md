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
### What's new
- Android: Settings → About now checks the app itself, not just the connected server — it compares your installed APK version with the latest release, so you can see when the app on your phone is out of date.

### Bug fixes
- Devin sessions are indexed from any working directory again: sessions created outside the ddagent workspace (for example on Windows) show up in recent sessions.
<!-- lang:pl -->
### Nowości
- Android: Ustawienia → About sprawdza teraz samą aplikację, a nie tylko podłączony serwer — porównuje zainstalowaną wersję APK z najnowszym wydaniem, więc widzisz, kiedy aplikacja na telefonie jest nieaktualna.

### Poprawki błędów
- Sesje Devina są znów indeksowane z dowolnego katalogu roboczego: sesje utworzone poza workspace ddagent (np. w Windows) pojawiają się w ostatnich sesjach.
<!-- lang:de -->
### Neu
- Android: Einstellungen → Über prüft jetzt die App selbst, nicht nur den verbundenen Server — sie vergleicht die installierte APK-Version mit der neuesten Veröffentlichung, sodass du siehst, wenn die App auf dem Telefon veraltet ist.

### Fehlerbehebungen
- Devin-Sitzungen werden wieder aus jedem Arbeitsverzeichnis indexiert: Sitzungen außerhalb des ddagent-Workspace (z. B. unter Windows) erscheinen in den letzten Sitzungen.
<!-- lang:es -->
### Novedades
- Android: Ajustes → Acerca de ahora comprueba la propia app, no solo el servidor conectado — compara la versión del APK instalado con la última versión publicada, así ves cuándo la app del teléfono está desactualizada.

### Correcciones de errores
- Las sesiones de Devin vuelven a indexarse desde cualquier directorio de trabajo: las sesiones creadas fuera del workspace de ddagent (por ejemplo en Windows) aparecen en las sesiones recientes.
<!-- lang:fr -->
### Nouveautés
- Android : Paramètres → À propos vérifie désormais l'application elle-même, et non plus seulement le serveur connecté — il compare la version de l'APK installé à la dernière version publiée, pour vous montrer quand l'application du téléphone est obsolète.

### Corrections de bugs
- Les sessions Devin sont de nouveau indexées depuis n'importe quel répertoire de travail : les sessions créées hors du workspace ddagent (par exemple sous Windows) réapparaissent dans les sessions récentes.
<!-- lang:it -->
### Novità
- Android: Impostazioni → Informazioni ora controlla l'app stessa, non solo il server collegato — confronta la versione dell'APK installato con l'ultima release, così vedi quando l'app del telefono è obsoleta.

### Correzioni di bug
- Le sessioni Devin vengono di nuovo indicizzate da qualsiasi directory di lavoro: le sessioni create fuori dal workspace ddagent (per esempio su Windows) ricompaiono nelle sessioni recenti.
<!-- lang:ja -->
### 新機能
- Android: 「設定」のアプリ情報が、接続中のサーバーだけでなくアプリ自体を確認するようになりました — インストール済み APK のバージョンと最新リリースを比較し、スマホのアプリが古いかどうかが分かります。

### バグ修正
- Devin のセッションが再び任意の作業ディレクトリからインデックスされます: ddagent のワークスペース外（例: Windows）で作成したセッションも最近のセッションに表示されます。
<!-- lang:ko -->
### 새로운 기능
- Android: 설정의 앱 정보가 연결된 서버뿐 아니라 앱 자체를 확인합니다 — 설치된 APK 버전과 최신 릴리스를 비교하므로 휴대폰의 앱이 오래되었는지 알 수 있습니다.

### 버그 수정
- Devin 세션이 다시 모든 작업 디렉터리에서 인덱싱됩니다: ddagent 워크스페이스 밖(예: Windows)에서 만든 세션도 최근 세션에 나타납니다.
<!-- lang:ru -->
### Новое
- Android: «Настройки → О приложении» теперь проверяет само приложение, а не только подключённый сервер — сравнивает версию установленного APK с последним релизом, так что видно, когда приложение на телефоне устарело.

### Исправления ошибок
- Сессии Devin снова индексируются из любого рабочего каталога: сессии, созданные вне workspace ddagent (например, в Windows), появляются в недавних сессиях.
<!-- lang:tr -->
### Yenilikler
- Android: Ayarlar → Hakkında artık yalnızca bağlı sunucuyu değil, uygulamanın kendisini kontrol ediyor — yüklü APK sürümünü en son sürümle karşılaştırıyor, böylece telefondaki uygulamanın eskidiğini görebilirsiniz.

### Hata düzeltmeleri
- Devin oturumları yeniden her çalışma dizininden dizinleniyor: ddagent çalışma alanı dışında (örneğin Windows'ta) oluşturulan oturumlar son oturumlarda görünüyor.
<!-- lang:zh-CN -->
### 新功能
- Android：设置中的应用信息现在检查应用本身，而不仅仅是已连接的服务器——将已安装的 APK 版本与最新发布版本比较，因此你能看到手机上的应用是否过旧。

### 错误修复
- Devin 会话再次可从任意工作目录建立索引：在 ddagent 工作区之外（例如 Windows）创建的会话会出现在最近会话中。
<!-- lang:zh-TW -->
### 新功能
- Android：設定中的應用程式資訊現在會檢查應用程式本身，而不只是已連線的伺服器——將已安裝的 APK 版本與最新發行版本比較，因此你能看到手機上的應用程式是否過舊。

### 錯誤修復
- Devin 工作階段再次可從任意工作目錄建立索引：在 ddagent 工作區之外（例如 Windows）建立的工作階段會出現在最近工作階段中。
