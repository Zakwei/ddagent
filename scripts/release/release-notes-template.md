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
- Mini orchestration: a lighter sibling of the orchestrator with exactly two model roles — a thinker that plans, decides and reviews, and a worker that executes — plus a per-task-type role map. Configure it in Settings → Mini orchestration.
- Desktop self-update (Linux/Windows): the app now downloads the matching update in the background and installs it when you quit — a silent installer on Windows, or a signed package / portable unpack on Linux. The Update badge and Settings → App updates offer a "quit and install" action.

### Bug fixes
- Interactive asks from devin/commandcode/claude stay answerable across windows: prompts from a dead or restarted turn are no longer resurfaced, and another window now shows the answer you picked instead of "Skipped".
- Local server updates no longer wipe your settings: the bundle's `.env*` files (custom DATABASE_PATH, ports, integrations) are kept and restored into the new server.
<!-- lang:pl -->
### Nowości
- Mini orkiestracja: lżejszy odpowiednik orkiestratora z dokładnie dwiema rolami modeli — myśliciel planuje, decyduje i recenzuje, a wykonawca realizuje zadania — oraz mapą ról dla typów zadań. Skonfigurujesz ją w Ustawienia → Mini orkiestracja.
- Samoaktualizacja na pulpicie (Linux/Windows): aplikacja pobiera teraz pasującą aktualizację w tle i instaluje ją przy zamykaniu — cichy instalator w Windows albo podpisany pakiet / rozpakowanie wersji przenośnej w Linux. Plakietka Aktualizacja i Ustawienia → Aktualizacje aplikacji oferują akcję „zamknij i zainstaluj".

### Poprawki błędów
- Interaktywne pytania z devin/commandcode/claude pozostają odpowiadalne w wielu oknach: pytania z martwej lub zrestartowanej tury nie wracają, a inne okno pokazuje wybraną odpowiedź zamiast „Pominięto".
- Aktualizacje lokalnego serwera nie kasują już ustawień: pliki `.env*` z pakietu (własny DATABASE_PATH, porty, integracje) są zachowywane i przywracane w nowym serwerze.
<!-- lang:de -->
### Neu
- Mini-Orchestrierung: ein leichteres Gegenstück zum Orchestrator mit genau zwei Modellrollen — ein Denker, der plant, entscheidet und prüft, und ein Worker, der ausführt — plus einer Rollenzuordnung pro Aufgabentyp. Konfiguration unter Einstellungen → Mini-Orchestrierung.
- Desktop-Selbstupdate (Linux/Windows): Die App lädt das passende Update jetzt im Hintergrund und installiert es beim Beenden — stiller Installer unter Windows bzw. signiertes Paket / portables Entpacken unter Linux. Update-Badge und Einstellungen → App-Updates bieten „Beenden und installieren“.

### Fehlerbehebungen
- Interaktive Nachfragen von devin/commandcode/claude bleiben über Fenster hinweg beantwortbar: Nachfragen aus einem toten oder neu gestarteten Durchlauf tauchen nicht mehr auf, und ein anderes Fenster zeigt die gewählte Antwort statt „Übersprungen“.
- Updates des lokalen Servers löschen keine Einstellungen mehr: Die `.env*`-Dateien des Bundles (eigener DATABASE_PATH, Ports, Integrationen) bleiben erhalten und werden in den neuen Server zurückgespielt.
<!-- lang:es -->
### Novedades
- Mini-orquestación: una versión ligera del orquestador con exactamente dos roles de modelo — un pensador que planifica, decide y revisa, y un trabajador que ejecuta — más un mapa de roles por tipo de tarea. Configúrala en Ajustes → Mini orquestación.
- Autoactualización de escritorio (Linux/Windows): la app ahora descarga la actualización correspondiente en segundo plano y la instala al salir — instalador silencioso en Windows o paquete firmado / descompresión portátil en Linux. El distintivo de actualización y Ajustes → Actualizaciones de la app ofrecen «salir e instalar».

### Correcciones de errores
- Las preguntas interactivas de devin/commandcode/claude siguen siendo respondibles entre ventanas: las preguntas de un turno muerto o reiniciado ya no reaparecen, y otra ventana muestra la respuesta elegida en lugar de "Omitido".
- Las actualizaciones del servidor local ya no borran tus ajustes: los archivos `.env*` del paquete (DATABASE_PATH personalizado, puertos, integraciones) se conservan y restauran en el nuevo servidor.
<!-- lang:fr -->
### Nouveautés
- Mini-orchestration : un pendant plus léger de l'orchestrateur avec exactement deux rôles de modèle — un penseur qui planifie, décide et vérifie, et un exécutant qui réalise — plus une table de rôles par type de tâche. Configurez-la dans Paramètres → Mini-orchestration.
- Mise à jour automatique sur ordinateur (Linux/Windows) : l'application télécharge désormais la mise à jour correspondante en arrière-plan et l'installe à la fermeture — installateur silencieux sous Windows, ou paquet signé / décompression portable sous Linux. Le badge de mise à jour et Paramètres → Mises à jour de l'application proposent « quitter et installer ».

### Corrections de bugs
- Les demandes interactives de devin/commandcode/claude restent disponibles entre fenêtres : les demandes d'un tour mort ou redémarré ne réapparaissent plus, et une autre fenêtre affiche la réponse choisie au lieu de « Ignoré ».
- Les mises à jour du serveur local n'effacent plus vos réglages : les fichiers `.env*` du paquet (DATABASE_PATH personnalisé, ports, intégrations) sont conservés et restaurés dans le nouveau serveur.
<!-- lang:it -->
### Novità
- Mini orchestrazione: una versione più leggera dell'orchestratore con esattamente due ruoli di modello — un pensatore che pianifica, decide e rivede, e un esecutore che realizza — più una mappa dei ruoli per tipo di attività. La configuri in Impostazioni → Mini orchestrazione.
- Aggiornamento automatico su desktop (Linux/Windows): l'app ora scarica in background l'aggiornamento corrispondente e lo installa all'uscita — installer silenzioso su Windows, oppure pacchetto firmato / scompattamento della versione portabile su Linux. Il badge Aggiornamento e Impostazioni → Aggiornamenti app offrono l'azione "esci e installa".

### Correzioni di bug
- Le domande interattive di devin/commandcode/claude restano gestibili tra finestre: le domande di un turno morto o riavviato non riemergono più e un'altra finestra mostra la risposta scelta invece di "Saltato".
- Gli aggiornamenti del server locale non cancellano più le impostazioni: i file `.env*` del bundle (DATABASE_PATH personalizzato, porte, integrazioni) vengono conservati e ripristinati nel nuovo server.
<!-- lang:ja -->
### 新機能
- ミニオーケストレーション: オーケストレーターの軽量版で、モデルの役割はちょうど 2 つ — 計画・判断・レビューを担う「シンカー」と実行を担う「ワーカー」— に加え、タスク種別ごとの役割マップ。設定 → ミニオーケストレーションで構成できます。
- デスクトップの自動更新（Linux/Windows）: アプリが該当する更新をバックグラウンドでダウンロードし、終了時にインストールします — Windows ではサイレントインストーラー、Linux では署名済みパッケージ／ポータブル版の展開。「更新」バッジと設定 → アプリの更新に「終了してインストール」を用意しました。

### バグ修正
- devin/commandcode/claude の対話的な確認がウィンドウをまたいで回答可能になりました: 停止・再起動したターンの確認が再表示されなくなり、別ウィンドウでも「スキップ」ではなく選んだ回答が表示されます。
- ローカルサーバーの更新で設定が消えなくなりました: バンドルの `.env*` ファイル（独自の DATABASE_PATH、ポート、連携）を保持し、新しいサーバーへ復元します。
<!-- lang:ko -->
### 새로운 기능
- 미니 오케스트레이션: 오케스트레이터의 경량 버전으로, 모델 역할이 정확히 두 개입니다 — 계획·판단·검토를 맡는 싱커와 실행을 맡는 워커 — 에 더해 작업 유형별 역할 매핑. 설정 → 미니 오케스트레이션에서 구성합니다.
- 데스크톱 자동 업데이트(Linux/Windows): 앱이 이제 알맞은 업데이트를 백그라운드에서 내려받아 종료할 때 설치합니다 — Windows에서는 무음 설치 프로그램, Linux에서는 서명된 패키지/포터블 압축 해제. 업데이트 배지와 설정 → 앱 업데이트에서 "종료 후 설치"를 제공합니다.

### 버그 수정
- devin/commandcode/claude의 대화형 질문이 창을 넘어 응답 가능해졌습니다: 종료되거나 재시작된 턴의 질문이 다시 나타나지 않고, 다른 창에서도 "건너뜀" 대신 선택한 답변이 표시됩니다.
- 로컬 서버 업데이트가 더 이상 설정을 지우지 않습니다: 번들의 `.env*` 파일(사용자 지정 DATABASE_PATH, 포트, 연동)을 보존해 새 서버에 복원합니다.
<!-- lang:ru -->
### Новое
- Мини-оркестрация: облегчённый вариант оркестратора ровно с двумя ролями моделей — мыслитель планирует, решает и проверяет, а исполнитель выполняет — плюс карта ролей по типам задач. Настраивается в разделе «Настройки → Мини-оркестрация».
- Самообновление на компьютере (Linux/Windows): приложение теперь скачивает нужное обновление в фоне и устанавливает его при выходе — тихий установщик в Windows либо подписанный пакет / распаковка портативной версии в Linux. Значок обновления и «Настройки → Обновления приложения» предлагают действие «выйти и установить».

### Исправления ошибок
- Интерактивные запросы devin/commandcode/claude остаются доступными в разных окнах: запросы из завершённого или перезапущенного хода больше не всплывают, а в другом окне показывается выбранный ответ вместо «Пропущено».
- Обновления локального сервера больше не стирают настройки: файлы `.env*` из пакета (свой DATABASE_PATH, порты, интеграции) сохраняются и восстанавливаются в новом сервере.
<!-- lang:tr -->
### Yenilikler
- Mini orkestrasyon: orkestratörün daha hafif bir sürümü; tam olarak iki model rolü var — planlayan, karar veren ve gözden geçiren bir düşünen ile uygulayan bir çalışan — ayrıca görev türüne göre rol eşlemesi. Ayarlar → Mini orkestrasyon'dan yapılandırılır.
- Masaüstünde otomatik güncelleme (Linux/Windows): uygulama artık uygun güncellemeyi arka planda indirip çıkışta kuruyor — Windows'ta sessiz kurulum, Linux'ta imzalı paket / taşınabilir sürümü açma. Güncelleme rozeti ve Ayarlar → Uygulama güncellemeleri "çık ve kur" eylemini sunar.

### Hata düzeltmeleri
- devin/commandcode/claude etkileşimli soruları pencereler arasında yanıtlanabilir kalıyor: ölmüş ya da yeniden başlatılmış bir turun soruları artık geri gelmiyor ve başka bir pencere "Atlandı" yerine seçtiğiniz yanıtı gösteriyor.
- Yerel sunucu güncellemeleri artık ayarlarınızı silmiyor: paketin `.env*` dosyaları (özel DATABASE_PATH, portlar, entegrasyonlar) korunup yeni sunucuya geri yükleniyor.
<!-- lang:zh-CN -->
### 新功能
- 迷你编排：编排器的轻量版本，模型角色恰好两个——负责规划、决策和审查的思考者，以及负责执行的执行者——另有按任务类型的角色映射。可在 设置 → 迷你编排 中配置。
- 桌面自动更新（Linux/Windows）：应用现在会在后台下载对应的更新，并在退出时安装——Windows 使用静默安装程序，Linux 使用签名软件包/便携版解压。更新徽标与 设置 → 应用更新 提供“退出并安装”操作。

### 错误修复
- devin/commandcode/claude 的交互式提问现在可跨窗口回答：已结束或重启轮次的提问不再重新出现，其他窗口也会显示你所选的回答，而不是“已跳过”。
- 本地服务器更新不再清空你的设置：安装包根目录的 `.env*` 文件（自定义 DATABASE_PATH、端口、集成）会被保留并恢复到新的服务器中。
<!-- lang:zh-TW -->
### 新功能
- 迷你編排：編排器的輕量版本，模型角色恰好兩個——負責規劃、決策與審查的思考者，以及負責執行的執行者——另有依任務類型的角色對應。可在 設定 → 迷你編排 中設定。
- 桌面自動更新（Linux/Windows）：應用程式現在會在背景下載對應的更新，並在結束時安裝——Windows 使用無聲安裝程式，Linux 使用簽章套件／可攜版解壓。更新徽章與 設定 → 應用程式更新 提供「結束並安裝」動作。

### 錯誤修復
- devin/commandcode/claude 的互動提問現在可跨視窗回答：已結束或重新啟動回合的提問不再重新出現，其他視窗也會顯示你選擇的回答，而不是「已略過」。
- 本機伺服器更新不再清空你的設定：套件根目錄的 `.env*` 檔案（自訂 DATABASE_PATH、連接埠、整合）會被保留並還原到新的伺服器。
