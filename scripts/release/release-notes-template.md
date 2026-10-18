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
### Fixes
- **Terminal on phones**: a finger can scroll the terminal again. xterm asked for the soft keyboard on every touch, and the keyboard sliding up snapped the view back to the bottom mid-drag; the keyboard now opens only on a completed tap.
- **Terminal**: the shell starts at the pane's real size instead of 80×24, so the first prompt no longer overlaps after the initial resize; a restarted tab reuses the live size.
- **Terminal**: "Claude CLI", "OpenCode CLI", … profiles type their CLI into the shell you are in (same directory) instead of opening a new tab; a new tab only when the active one cannot take input.
- **Terminal**: Claude Code started from the terminal gets `--allow-dangerously-skip-permissions`, so "bypass permissions" is reachable in its Shift+Tab mode cycle without starting in it.
- **Agent updates from Settings**: npm 11.19 silently skipped the install scripts that fetch the Claude Code and OpenCode binaries, so an update ended "successfully" without changing anything; the commands now allow those scripts. A native Claude Code install is updated with `claude update`, with npm as the fallback.
<!-- lang:pl -->
### Poprawki
- **Terminal na telefonie**: przewijanie palcem znów działa. xterm przy każdym dotknięciu żądał klawiatury ekranowej, a wysuwająca się klawiatura w trakcie przeciągania cofała widok na dół; klawiatura otwiera się teraz dopiero po zakończonym tapnięciu.
- **Terminal**: powłoka startuje w rzeczywistym rozmiarze panelu zamiast 80×24, więc pierwszy prompt nie nakłada się po pierwszej zmianie rozmiaru; restart karty używa bieżącego rozmiaru.
- **Terminal**: profile „Claude CLI”, „OpenCode CLI” itd. wpisują CLI do bieżącej powłoki (ten sam katalog) zamiast otwierać nową kartę; nowa karta tylko wtedy, gdy aktywna nie przyjmie wpisywania.
- **Terminal**: Claude Code uruchamiany z terminala dostaje `--allow-dangerously-skip-permissions`, więc tryb „bypass permissions” jest dostępny w cyklu Shift+Tab bez startowania w nim.
- **Aktualizacja agentów z Ustawień**: npm 11.19 po cichu pomijał skrypty instalacyjne pobierające binaria Claude Code i OpenCode, przez co aktualizacja kończyła się „sukcesem” bez zmian; komendy zezwalają teraz na te skrypty. Natywną instalację Claude Code aktualizuje `claude update`, npm jest zapasem.
<!-- lang:de -->
### Fehlerbehebungen
- **Terminal auf dem Handy**: Mit dem Finger lässt sich das Terminal wieder scrollen. xterm forderte bei jeder Berührung die Bildschirmtastatur an, und die hochfahrende Tastatur setzte die Ansicht mitten im Wischen nach unten zurück; die Tastatur öffnet sich jetzt nur nach einem abgeschlossenen Tippen.
- **Terminal**: Die Shell startet in der echten Bereichsgröße statt 80×24, sodass sich die erste Eingabeaufforderung nach der ersten Größenänderung nicht mehr überlagert; ein neu gestarteter Tab nutzt die aktuelle Größe.
- **Terminal**: Die Profile „Claude CLI“, „OpenCode CLI“ … tippen ihre CLI in die aktuelle Shell (gleiches Verzeichnis), statt einen neuen Tab zu öffnen; ein neuer Tab nur, wenn der aktive keine Eingabe annehmen kann.
- **Terminal**: Aus dem Terminal gestartetes Claude Code erhält `--allow-dangerously-skip-permissions`, sodass „bypass permissions“ im Shift+Tab-Moduswechsel erreichbar ist, ohne darin zu starten.
- **Agenten-Updates aus den Einstellungen**: npm 11.19 übersprang stillschweigend die Installationsskripte, die die Binaries von Claude Code und OpenCode laden, sodass ein Update „erfolgreich“ endete, ohne etwas zu ändern; die Befehle erlauben diese Skripte jetzt. Eine native Claude-Code-Installation wird mit `claude update` aktualisiert, npm bleibt Rückfallebene.
<!-- lang:es -->
### Correcciones
- **Terminal en el móvil**: el terminal vuelve a desplazarse con el dedo. xterm pedía el teclado en pantalla con cada toque, y el teclado al desplegarse devolvía la vista al final en mitad del arrastre; ahora el teclado se abre solo tras un toque completo.
- **Terminal**: el shell arranca con el tamaño real del panel en lugar de 80×24, así el primer prompt ya no se solapa tras el primer cambio de tamaño; una pestaña reiniciada reutiliza el tamaño actual.
- **Terminal**: los perfiles «Claude CLI», «OpenCode CLI»… escriben su CLI en el shell actual (mismo directorio) en vez de abrir una pestaña nueva; solo se abre una nueva cuando la activa no admite entrada.
- **Terminal**: Claude Code iniciado desde el terminal recibe `--allow-dangerously-skip-permissions`, de modo que «bypass permissions» está disponible en el ciclo Shift+Tab sin arrancar en ese modo.
- **Actualización de agentes desde Ajustes**: npm 11.19 omitía en silencio los scripts de instalación que descargan los binarios de Claude Code y OpenCode, así que la actualización terminaba «con éxito» sin cambiar nada; los comandos ahora permiten esos scripts. Una instalación nativa de Claude Code se actualiza con `claude update`, con npm como respaldo.
<!-- lang:fr -->
### Corrections
- **Terminal sur téléphone** : le terminal se fait de nouveau défiler au doigt. xterm demandait le clavier virtuel à chaque contact, et le clavier qui remontait ramenait la vue en bas en plein glissement ; le clavier ne s'ouvre plus qu'après un appui complet.
- **Terminal** : le shell démarre à la taille réelle du volet au lieu de 80×24, la première invite ne se superpose donc plus après le premier redimensionnement ; un onglet redémarré reprend la taille courante.
- **Terminal** : les profils « Claude CLI », « OpenCode CLI »… saisissent leur CLI dans le shell courant (même répertoire) au lieu d'ouvrir un nouvel onglet ; un nouvel onglet seulement si l'actif ne peut pas recevoir de saisie.
- **Terminal** : Claude Code lancé depuis le terminal reçoit `--allow-dangerously-skip-permissions`, « bypass permissions » est donc accessible dans le cycle Shift+Tab sans démarrer dans ce mode.
- **Mise à jour des agents depuis les Paramètres** : npm 11.19 ignorait silencieusement les scripts d'installation qui récupèrent les binaires de Claude Code et OpenCode, la mise à jour se terminait donc « avec succès » sans rien changer ; les commandes autorisent désormais ces scripts. Une installation native de Claude Code est mise à jour par `claude update`, npm servant de repli.
<!-- lang:it -->
### Correzioni
- **Terminale sul telefono**: il terminale si scorre di nuovo con il dito. xterm chiedeva la tastiera a schermo a ogni tocco e la tastiera in apertura riportava la vista in fondo durante il trascinamento; ora la tastiera si apre solo dopo un tocco completato.
- **Terminale**: la shell parte alla dimensione reale del riquadro invece di 80×24, così il primo prompt non si sovrappone più dopo il primo ridimensionamento; una scheda riavviata riusa la dimensione corrente.
- **Terminale**: i profili «Claude CLI», «OpenCode CLI»… digitano la CLI nella shell corrente (stessa directory) invece di aprire una nuova scheda; una nuova scheda solo quando quella attiva non accetta input.
- **Terminale**: Claude Code avviato dal terminale riceve `--allow-dangerously-skip-permissions`, quindi «bypass permissions» è raggiungibile nel ciclo Shift+Tab senza partire in quella modalità.
- **Aggiornamento degli agenti dalle Impostazioni**: npm 11.19 saltava in silenzio gli script di installazione che scaricano i binari di Claude Code e OpenCode, così l'aggiornamento finiva «con successo» senza cambiare nulla; i comandi ora consentono quegli script. Un'installazione nativa di Claude Code si aggiorna con `claude update`, con npm come ripiego.
<!-- lang:ja -->
### 修正
- **スマホのターミナル**：指でのスクロールが再び動きます。xterm はタッチのたびにソフトキーボードを要求し、せり上がるキーボードがドラッグ中に表示を最下部へ戻していました。キーボードはタップが完了したときだけ開きます。
- **ターミナル**：シェルは 80×24 ではなくペインの実サイズで起動するため、最初のリサイズ後にプロンプトが重ならなくなりました。再起動したタブは現在のサイズを使います。
- **ターミナル**：「Claude CLI」「OpenCode CLI」などのプロファイルは新しいタブを開かず、今いるシェル（同じディレクトリ）に CLI を入力します。新しいタブは、アクティブなタブが入力を受け付けられないときだけ開きます。
- **ターミナル**：ターミナルから起動した Claude Code に `--allow-dangerously-skip-permissions` が付くため、Shift+Tab のモード切替で「bypass permissions」を選べます（最初からそのモードにはなりません）。
- **設定からのエージェント更新**：npm 11.19 が Claude Code と OpenCode のバイナリを取得するインストールスクリプトを黙ってスキップし、更新が何も変えずに「成功」していました。コマンドでこれらのスクリプトを許可します。ネイティブ版 Claude Code は `claude update` で更新し、npm は予備です。
<!-- lang:ko -->
### 수정
- **휴대폰의 터미널**: 손가락으로 다시 스크롤할 수 있습니다. xterm이 터치할 때마다 소프트 키보드를 요청했고, 올라오는 키보드가 드래그 도중 화면을 맨 아래로 되돌렸습니다. 이제 키보드는 탭이 완료되었을 때만 열립니다.
- **터미널**: 셸이 80×24 대신 창의 실제 크기로 시작하므로 첫 크기 조정 후 프롬프트가 겹치지 않습니다. 다시 시작한 탭은 현재 크기를 사용합니다.
- **터미널**: "Claude CLI", "OpenCode CLI" 등 프로필은 새 탭을 열지 않고 현재 셸(같은 디렉터리)에 CLI를 입력합니다. 활성 탭이 입력을 받을 수 없을 때만 새 탭이 열립니다.
- **터미널**: 터미널에서 시작한 Claude Code에 `--allow-dangerously-skip-permissions`가 붙어 Shift+Tab 모드 순환에서 "bypass permissions"를 선택할 수 있습니다(처음부터 그 모드로 시작하지는 않음).
- **설정에서 에이전트 업데이트**: npm 11.19가 Claude Code와 OpenCode 바이너리를 내려받는 설치 스크립트를 조용히 건너뛰어 업데이트가 아무것도 바꾸지 않고 "성공"으로 끝났습니다. 이제 명령이 해당 스크립트를 허용합니다. 네이티브 Claude Code 설치는 `claude update`로 업데이트하고 npm은 대비책입니다.
<!-- lang:ru -->
### Исправления
- **Терминал на телефоне**: прокрутка пальцем снова работает. xterm запрашивал экранную клавиатуру при каждом касании, а выезжающая клавиатура возвращала вид вниз посреди перетаскивания; теперь клавиатура открывается только после завершённого тапа.
- **Терминал**: оболочка стартует в реальном размере панели, а не 80×24, поэтому первое приглашение больше не накладывается после первого изменения размера; перезапущенная вкладка использует текущий размер.
- **Терминал**: профили «Claude CLI», «OpenCode CLI»… вводят CLI в текущую оболочку (тот же каталог) вместо новой вкладки; новая вкладка открывается только если активная не принимает ввод.
- **Терминал**: Claude Code, запущенный из терминала, получает `--allow-dangerously-skip-permissions`, так что «bypass permissions» доступен в цикле Shift+Tab без старта в этом режиме.
- **Обновление агентов из Настроек**: npm 11.19 молча пропускал установочные скрипты, скачивающие бинарники Claude Code и OpenCode, и обновление «успешно» завершалось без изменений; теперь команды разрешают эти скрипты. Нативная установка Claude Code обновляется через `claude update`, npm остаётся запасным вариантом.
<!-- lang:tr -->
### Düzeltmeler
- **Telefonda terminal**: terminal yeniden parmakla kaydırılabiliyor. xterm her dokunuşta ekran klavyesini istiyor, yukarı kayan klavye sürükleme sırasında görünümü en alta geri atıyordu; klavye artık yalnızca tamamlanmış bir dokunuşta açılıyor.
- **Terminal**: kabuk 80×24 yerine bölmenin gerçek boyutunda başlıyor, böylece ilk yeniden boyutlandırmadan sonra ilk istem üst üste binmiyor; yeniden başlatılan sekme geçerli boyutu kullanıyor.
- **Terminal**: "Claude CLI", "OpenCode CLI" … profilleri yeni sekme açmak yerine CLI'ı bulunduğunuz kabuğa (aynı dizin) yazıyor; yalnızca etkin sekme girdi alamıyorsa yeni sekme açılıyor.
- **Terminal**: terminalden başlatılan Claude Code `--allow-dangerously-skip-permissions` alıyor, böylece "bypass permissions" Shift+Tab mod döngüsünde o modda başlamadan erişilebilir.
- **Ayarlardan ajan güncelleme**: npm 11.19, Claude Code ve OpenCode ikili dosyalarını indiren kurulum betiklerini sessizce atlıyor, güncelleme hiçbir şeyi değiştirmeden "başarıyla" bitiyordu; komutlar artık bu betiklere izin veriyor. Yerel Claude Code kurulumu `claude update` ile güncelleniyor, npm yedek.
<!-- lang:zh-CN -->
### 修复
- **手机上的终端**：又可以用手指滚动了。xterm 每次触摸都会请求软键盘，键盘弹出时会在拖动途中把视图拉回底部；现在只有完整点按才会打开键盘。
- **终端**：shell 以面板的实际大小启动，而不是 80×24，因此首次调整大小后第一行提示不再重叠；重启的标签沿用当前大小。
- **终端**：“Claude CLI”“OpenCode CLI”等配置会把 CLI 输入到当前 shell（同一目录），而不是新开标签；只有当前标签无法接收输入时才新开标签。
- **终端**：从终端启动的 Claude Code 带上 `--allow-dangerously-skip-permissions`，因此 Shift+Tab 模式循环中可以选到“bypass permissions”，但不会默认处于该模式。
- **从设置更新智能体**：npm 11.19 会悄悄跳过下载 Claude Code 和 OpenCode 二进制文件的安装脚本，导致更新“成功”却什么都没变；命令现在允许这些脚本。原生安装的 Claude Code 用 `claude update` 更新，npm 作为后备。
<!-- lang:zh-TW -->
### 修正
- **手機上的終端機**：又能用手指捲動了。xterm 每次觸碰都會要求螢幕鍵盤，鍵盤彈出時會在拖曳途中把畫面拉回底部；現在只有完整點按才會開啟鍵盤。
- **終端機**：shell 以面板的實際大小啟動，而不是 80×24，因此第一次調整大小後提示字元不再重疊；重新啟動的分頁沿用目前大小。
- **終端機**：「Claude CLI」「OpenCode CLI」等設定檔會把 CLI 輸入到目前的 shell（同一目錄），而不是開新分頁；只有目前分頁無法接收輸入時才開新分頁。
- **終端機**：從終端機啟動的 Claude Code 加上 `--allow-dangerously-skip-permissions`，因此 Shift+Tab 模式循環中可以選到「bypass permissions」，但不會預設處於該模式。
- **從設定更新代理程式**：npm 11.19 會悄悄略過下載 Claude Code 與 OpenCode 執行檔的安裝指令碼，導致更新「成功」卻什麼都沒變；指令現在允許這些指令碼。原生安裝的 Claude Code 以 `claude update` 更新，npm 作為備援。
