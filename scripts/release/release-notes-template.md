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
- **Terminal tab names**: a tab shows the title its program sets — Claude Code's session name instead of "Shell 4"; it falls back when the program exits, and a rename always wins.
- **Claude Code `/copy` reaches your clipboard**: copies a CLI makes over OSC 52 now land in the clipboard of the device you are using.

### Fixes
- **Scrolling in Claude Code**: the mouse wheel and a finger drag scroll its fullscreen view again — the wheel was reported as Shift+wheel. The middle button and row positions of clicks are reported correctly too.
- **Keyboard in the terminal**: Shift/Alt+arrows, Alt+letter (lower case), Alt+Enter (new line in Claude Code), Alt+Backspace, Alt+., Ctrl+/ [ ] \ and Ctrl+F1–F4 send what xterm sends; application cursor mode is honoured.
- **Ctrl+K** in a focused terminal deletes to end of line instead of opening the session switcher.
- **Right-click** on a terminal tab or pane no longer opens the browser's menu as well (web).
- **Reopened tabs** no longer type "1;2c" into the shell — replayed output is not answered again (needs the updated server).
- Programs that ask for focus events (Claude Code) now get them.
<!-- lang:pl -->
### Nowości
- **Nazwy kart terminala**: karta pokazuje tytuł ustawiony przez program — nazwę sesji Claude Code zamiast „Shell 4”; po wyjściu z programu wraca poprzednia nazwa, a ręczna zmiana nazwy zawsze wygrywa.
- **`/copy` w Claude Code trafia do Twojego schowka**: kopiowanie przez OSC 52 trafia teraz do schowka urządzenia, którego używasz.

### Poprawki
- **Przewijanie w Claude Code**: kółko myszy i przeciąganie palcem znów przewijają widok pełnoekranowy — kółko było zgłaszane jako Shift+kółko. Środkowy przycisk i wiersz kliknięcia są też zgłaszane poprawnie.
- **Klawiatura w terminalu**: Shift/Alt+strzałki, Alt+litera (mała), Alt+Enter (nowa linia w Claude Code), Alt+Backspace, Alt+., Ctrl+/ [ ] \ oraz Ctrl+F1–F4 wysyłają to samo co xterm; tryb kursora aplikacji jest respektowany.
- **Ctrl+K** w aktywnym terminalu usuwa do końca linii zamiast otwierać przełącznik sesji.
- **Prawy klik** na karcie lub panelu terminala nie otwiera już dodatkowo menu przeglądarki (web).
- **Ponownie otwarte karty** nie wpisują już „1;2c” do powłoki — odtwarzane wyjście nie dostaje drugiej odpowiedzi (wymaga zaktualizowanego serwera).
- Programy proszące o zdarzenia fokusu (Claude Code) teraz je dostają.
<!-- lang:de -->
### Neu
- **Namen der Terminal-Tabs**: Ein Tab zeigt den Titel, den sein Programm setzt — den Sitzungsnamen von Claude Code statt „Shell 4“; nach dem Beenden kehrt der alte Name zurück, und eine manuelle Umbenennung hat immer Vorrang.
- **`/copy` in Claude Code landet in deiner Zwischenablage**: Kopien, die eine CLI per OSC 52 macht, landen jetzt in der Zwischenablage deines Geräts.

### Fehlerbehebungen
- **Scrollen in Claude Code**: Mausrad und Wischen scrollen die Vollbildansicht wieder — das Rad wurde als Umschalt+Rad gemeldet. Mittlere Maustaste und Zeile eines Klicks werden ebenfalls korrekt gemeldet.
- **Tastatur im Terminal**: Umschalt/Alt+Pfeile, Alt+Buchstabe (klein), Alt+Enter (neue Zeile in Claude Code), Alt+Rücktaste, Alt+., Strg+/ [ ] \ und Strg+F1–F4 senden dasselbe wie xterm; der Anwendungs-Cursormodus wird beachtet.
- **Strg+K** in einem fokussierten Terminal löscht bis zum Zeilenende, statt den Sitzungswechsler zu öffnen.
- **Rechtsklick** auf einen Terminal-Tab oder -Bereich öffnet nicht mehr zusätzlich das Browsermenü (Web).
- **Wieder geöffnete Tabs** tippen kein „1;2c“ mehr in die Shell — wiedergegebene Ausgabe wird nicht erneut beantwortet (erfordert den aktualisierten Server).
- Programme, die Fokus-Ereignisse anfordern (Claude Code), erhalten sie jetzt.
<!-- lang:es -->
### Novedades
- **Nombres de pestañas del terminal**: una pestaña muestra el título que fija su programa — el nombre de la sesión de Claude Code en lugar de «Shell 4»; al salir vuelve el nombre anterior y un cambio de nombre manual siempre prevalece.
- **`/copy` de Claude Code llega a tu portapapeles**: lo que una CLI copia mediante OSC 52 ahora llega al portapapeles del dispositivo que usas.

### Correcciones
- **Desplazamiento en Claude Code**: la rueda del ratón y el arrastre con el dedo vuelven a desplazar su vista a pantalla completa — la rueda se enviaba como Mayús+rueda. El botón central y la fila de los clics también se envían correctamente.
- **Teclado en el terminal**: Mayús/Alt+flechas, Alt+letra (minúscula), Alt+Intro (nueva línea en Claude Code), Alt+Retroceso, Alt+., Ctrl+/ [ ] \ y Ctrl+F1–F4 envían lo mismo que xterm; se respeta el modo de cursor de aplicación.
- **Ctrl+K** en un terminal con foco borra hasta el final de la línea en lugar de abrir el selector de sesiones.
- **Clic derecho** en una pestaña o panel del terminal ya no abre además el menú del navegador (web).
- **Las pestañas reabiertas** ya no escriben «1;2c» en el shell — la salida reproducida no se vuelve a responder (requiere el servidor actualizado).
- Los programas que piden eventos de foco (Claude Code) ahora los reciben.
<!-- lang:fr -->
### Nouveautés
- **Noms des onglets du terminal** : un onglet affiche le titre défini par son programme — le nom de la session Claude Code au lieu de « Shell 4 » ; l'ancien nom revient à la sortie du programme, et un renommage manuel l'emporte toujours.
- **`/copy` de Claude Code arrive dans votre presse-papiers** : ce qu'une CLI copie via OSC 52 arrive désormais dans le presse-papiers de l'appareil utilisé.

### Corrections
- **Défilement dans Claude Code** : la molette et le glissement du doigt font de nouveau défiler sa vue plein écran — la molette était signalée comme Maj+molette. Le bouton du milieu et la ligne des clics sont aussi signalés correctement.
- **Clavier dans le terminal** : Maj/Alt+flèches, Alt+lettre (minuscule), Alt+Entrée (nouvelle ligne dans Claude Code), Alt+Retour arrière, Alt+., Ctrl+/ [ ] \ et Ctrl+F1–F4 envoient la même chose que xterm ; le mode curseur application est respecté.
- **Ctrl+K** dans un terminal actif efface jusqu'à la fin de la ligne au lieu d'ouvrir le sélecteur de sessions.
- **Le clic droit** sur un onglet ou un volet de terminal n'ouvre plus aussi le menu du navigateur (web).
- **Les onglets rouverts** ne tapent plus « 1;2c » dans le shell — la sortie rejouée n'obtient plus de seconde réponse (nécessite le serveur mis à jour).
- Les programmes qui demandent les événements de focus (Claude Code) les reçoivent désormais.
<!-- lang:it -->
### Novità
- **Nomi delle schede del terminale**: una scheda mostra il titolo impostato dal suo programma — il nome della sessione di Claude Code invece di «Shell 4»; all'uscita torna il nome precedente e una rinomina manuale ha sempre la precedenza.
- **`/copy` di Claude Code arriva negli appunti**: ciò che una CLI copia via OSC 52 ora finisce negli appunti del dispositivo che usi.

### Correzioni
- **Scorrimento in Claude Code**: la rotella e il trascinamento con il dito scorrono di nuovo la vista a schermo intero — la rotella veniva segnalata come Maiusc+rotella. Anche il pulsante centrale e la riga dei clic sono segnalati correttamente.
- **Tastiera nel terminale**: Maiusc/Alt+frecce, Alt+lettera (minuscola), Alt+Invio (nuova riga in Claude Code), Alt+Backspace, Alt+., Ctrl+/ [ ] \ e Ctrl+F1–F4 inviano lo stesso di xterm; la modalità cursore applicazione è rispettata.
- **Ctrl+K** in un terminale attivo cancella fino a fine riga invece di aprire il selettore di sessioni.
- **Il clic destro** su una scheda o un riquadro del terminale non apre più anche il menu del browser (web).
- **Le schede riaperte** non digitano più «1;2c» nella shell — all'output riprodotto non si risponde di nuovo (richiede il server aggiornato).
- I programmi che chiedono gli eventi di focus (Claude Code) ora li ricevono.
<!-- lang:ja -->
### 新機能
- **ターミナルタブの名前**：タブはプログラムが設定したタイトルを表示します。「Shell 4」ではなく Claude Code のセッション名になり、プログラム終了で元に戻ります。手動の名前変更は常に優先されます。
- **Claude Code の `/copy` がクリップボードに届く**：CLI が OSC 52 でコピーした内容が、使用中のデバイスのクリップボードに入るようになりました。

### 修正
- **Claude Code でのスクロール**：マウスホイールと指のドラッグで全画面ビューを再びスクロールできます（ホイールが Shift+ホイールとして送られていました）。中ボタンとクリック行も正しく送られます。
- **ターミナルのキーボード**：Shift/Alt+矢印、Alt+文字（小文字）、Alt+Enter（Claude Code で改行）、Alt+Backspace、Alt+.、Ctrl+/ [ ] \、Ctrl+F1–F4 が xterm と同じシーケンスを送ります。アプリケーションカーソルモードにも対応しました。
- フォーカス中のターミナルで **Ctrl+K** はセッション切り替えを開かず、行末まで削除します。
- ターミナルのタブやペインを **右クリック** してもブラウザのメニューが一緒に開かなくなりました（Web）。
- **再度開いたタブ** がシェルに「1;2c」を入力しなくなりました。再生された出力には再応答しません（更新済みサーバーが必要）。
- フォーカスイベントを要求するプログラム（Claude Code）がそれを受け取れるようになりました。
<!-- lang:ko -->
### 새로운 기능
- **터미널 탭 이름**: 탭에 프로그램이 설정한 제목이 표시됩니다. "Shell 4" 대신 Claude Code 세션 이름이 표시되고, 프로그램이 종료되면 원래 이름으로 돌아가며, 직접 바꾼 이름이 항상 우선합니다.
- **Claude Code의 `/copy`가 클립보드로**: CLI가 OSC 52로 복사한 내용이 이제 사용 중인 기기의 클립보드에 들어갑니다.

### 수정
- **Claude Code에서 스크롤**: 마우스 휠과 손가락 드래그로 전체 화면 보기를 다시 스크롤할 수 있습니다(휠이 Shift+휠로 전달되고 있었습니다). 가운데 버튼과 클릭한 행도 올바르게 전달됩니다.
- **터미널 키보드**: Shift/Alt+화살표, Alt+문자(소문자), Alt+Enter(Claude Code에서 줄바꿈), Alt+Backspace, Alt+., Ctrl+/ [ ] \, Ctrl+F1–F4가 xterm과 같은 시퀀스를 보냅니다. 애플리케이션 커서 모드도 지원합니다.
- 포커스된 터미널에서 **Ctrl+K**는 세션 전환기를 열지 않고 줄 끝까지 삭제합니다.
- 터미널 탭이나 창을 **오른쪽 클릭**해도 더 이상 브라우저 메뉴가 함께 열리지 않습니다(웹).
- **다시 연 탭**이 더 이상 셸에 "1;2c"를 입력하지 않습니다. 재생된 출력에는 다시 응답하지 않습니다(업데이트된 서버 필요).
- 포커스 이벤트를 요청하는 프로그램(Claude Code)이 이제 이벤트를 받습니다.
<!-- lang:ru -->
### Что нового
- **Названия вкладок терминала**: вкладка показывает заголовок, который задаёт программа, — имя сеанса Claude Code вместо «Shell 4»; после выхода из программы возвращается прежнее имя, а ручное переименование всегда имеет приоритет.
- **`/copy` в Claude Code попадает в ваш буфер обмена**: то, что CLI копирует через OSC 52, теперь попадает в буфер обмена вашего устройства.

### Исправления
- **Прокрутка в Claude Code**: колесо мыши и перетаскивание пальцем снова прокручивают полноэкранный вид — колесо передавалось как Shift+колесо. Средняя кнопка и строка щелчка тоже передаются правильно.
- **Клавиатура в терминале**: Shift/Alt+стрелки, Alt+буква (строчная), Alt+Enter (новая строка в Claude Code), Alt+Backspace, Alt+., Ctrl+/ [ ] \ и Ctrl+F1–F4 отправляют то же, что xterm; режим курсора приложения учитывается.
- **Ctrl+K** в активном терминале удаляет до конца строки вместо открытия переключателя сеансов.
- **Правый щелчок** по вкладке или панели терминала больше не открывает заодно меню браузера (веб).
- **Повторно открытые вкладки** больше не вводят «1;2c» в оболочку — на воспроизведённый вывод не отвечают повторно (нужен обновлённый сервер).
- Программы, запрашивающие события фокуса (Claude Code), теперь их получают.
<!-- lang:tr -->
### Yenilikler
- **Terminal sekmesi adları**: Sekme, programının belirlediği başlığı gösterir — „Shell 4” yerine Claude Code oturum adı; program kapanınca eski ad geri gelir ve elle verilen ad her zaman önceliklidir.
- **Claude Code `/copy` panonuza ulaşır**: Bir CLI'nin OSC 52 ile kopyaladıkları artık kullandığınız cihazın panosuna gelir.

### Düzeltmeler
- **Claude Code'da kaydırma**: Fare tekerleği ve parmakla sürükleme tam ekran görünümü yeniden kaydırır — tekerlek Shift+tekerlek olarak bildiriliyordu. Orta düğme ve tıklama satırı da doğru bildirilir.
- **Terminalde klavye**: Shift/Alt+oklar, Alt+harf (küçük), Alt+Enter (Claude Code'da yeni satır), Alt+Backspace, Alt+., Ctrl+/ [ ] \ ve Ctrl+F1–F4 xterm ile aynı diziyi gönderir; uygulama imleç modu dikkate alınır.
- Odaktaki terminalde **Ctrl+K** oturum değiştiriciyi açmak yerine satır sonuna kadar siler.
- Terminal sekmesine veya bölmesine **sağ tıklamak** artık tarayıcı menüsünü de açmıyor (web).
- **Yeniden açılan sekmeler** artık kabuğa „1;2c” yazmıyor — yeniden oynatılan çıktıya tekrar yanıt verilmez (güncel sunucu gerekir).
- Odak olaylarını isteyen programlar (Claude Code) artık bunları alır.
<!-- lang:zh-CN -->
### 新功能
- **终端标签名称**：标签显示程序设置的标题——显示 Claude Code 的会话名称而不是"Shell 4"；程序退出后恢复原名，手动重命名始终优先。
- **Claude Code 的 `/copy` 进入你的剪贴板**：CLI 通过 OSC 52 复制的内容现在会进入你所用设备的剪贴板。

### 修复
- **Claude Code 中的滚动**：鼠标滚轮和手指拖动可以再次滚动其全屏视图——此前滚轮被报告为 Shift+滚轮。中键和点击所在行也能正确报告。
- **终端键盘**：Shift/Alt+方向键、Alt+字母（小写）、Alt+Enter（在 Claude Code 中换行）、Alt+Backspace、Alt+.、Ctrl+/ [ ] \ 和 Ctrl+F1–F4 发送与 xterm 相同的序列；支持应用光标模式。
- 在获得焦点的终端中，**Ctrl+K** 删除到行尾，而不是打开会话切换器。
- **右键点击**终端标签或面板时不再同时打开浏览器菜单（Web）。
- **重新打开的标签**不再向 shell 输入"1;2c"——不再重复应答回放的输出（需要更新后的服务器）。
- 请求焦点事件的程序（Claude Code）现在可以收到这些事件。
<!-- lang:zh-TW -->
### 新功能
- **終端機分頁名稱**：分頁顯示程式設定的標題——顯示 Claude Code 的工作階段名稱而非「Shell 4」；程式結束後恢復原名，手動重新命名永遠優先。
- **Claude Code 的 `/copy` 進入你的剪貼簿**：CLI 透過 OSC 52 複製的內容現在會進入你所用裝置的剪貼簿。

### 修正
- **Claude Code 中的捲動**：滑鼠滾輪和手指拖曳可以再次捲動其全螢幕畫面——先前滾輪被回報為 Shift+滾輪。中鍵和點擊所在列也能正確回報。
- **終端機鍵盤**：Shift/Alt+方向鍵、Alt+字母（小寫）、Alt+Enter（在 Claude Code 中換行）、Alt+Backspace、Alt+.、Ctrl+/ [ ] \ 和 Ctrl+F1–F4 傳送與 xterm 相同的序列；支援應用程式游標模式。
- 在取得焦點的終端機中，**Ctrl+K** 刪除到行尾，而不是開啟工作階段切換器。
- **右鍵點擊**終端機分頁或面板時不再同時開啟瀏覽器選單（Web）。
- **重新開啟的分頁**不再向 shell 輸入「1;2c」——不再重複回應重播的輸出（需要更新後的伺服器）。
- 要求焦點事件的程式（Claude Code）現在可以收到這些事件。
