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
- **Paste a screenshot into the CLI**: Ctrl+V in a terminal pane uploads the clipboard image to `~/.ddagent/assets` and pastes its absolute path, which Claude Code and other CLIs read as an image (their own Ctrl+V only sees the server's clipboard). The plain-HTTP paste dialog accepts a pasted image too.
- **Terminal tab in its own pane**: the tab context menu has "Move to new pane" — the live shell moves into a separate workspace pane with its buffer and process intact.

### Fixes
- **Terminal on phones**: opening or switching to another shell tab no longer pops the soft keyboard up by itself, and a finger drag keeps scrolling while the keyboard slides; the keyboard opens only on a tap.
<!-- lang:pl -->
### Nowości
- **Wklejanie zrzutu ekranu do CLI**: Ctrl+V w panelu terminala wysyła obraz ze schowka do `~/.ddagent/assets` i wkleja jego ścieżkę bezwzględną, którą Claude Code i inne CLI czytają jako obraz (ich własne Ctrl+V widzi tylko schowek serwera). Okno wklejania na zwykłym HTTP też przyjmuje wklejony obraz.
- **Karta terminala we własnym panelu**: menu kontekstowe karty ma „Przenieś do nowego panelu” — działająca powłoka przechodzi do osobnego panelu obszaru roboczego z zachowanym buforem i procesem.

### Poprawki
- **Terminal na telefonie**: otwarcie lub przełączenie na inną kartę powłoki nie wysuwa już samo klawiatury ekranowej, a przeciąganie palcem przewija dalej, gdy klawiatura się wysuwa; klawiatura otwiera się tylko po tapnięciu.
<!-- lang:de -->
### Neu
- **Screenshot in die CLI einfügen**: Strg+V in einem Terminal-Bereich lädt das Bild aus der Zwischenablage nach `~/.ddagent/assets` hoch und fügt seinen absoluten Pfad ein, den Claude Code und andere CLIs als Bild lesen (ihr eigenes Strg+V sieht nur die Zwischenablage des Servers). Der Einfügedialog unter einfachem HTTP nimmt ebenfalls ein eingefügtes Bild an.
- **Terminal-Tab im eigenen Bereich**: Das Kontextmenü des Tabs bietet „In neues Panel verschieben“ — die laufende Shell wandert mit Puffer und Prozess in einen eigenen Arbeitsbereich-Bereich.

### Fehlerbehebungen
- **Terminal auf dem Handy**: Das Öffnen oder Wechseln zu einem anderen Shell-Tab blendet die Bildschirmtastatur nicht mehr von selbst ein, und ein Wischen scrollt weiter, während die Tastatur hochfährt; die Tastatur öffnet sich nur nach einem Tippen.
<!-- lang:es -->
### Novedades
- **Pegar una captura en la CLI**: Ctrl+V en un panel de terminal sube la imagen del portapapeles a `~/.ddagent/assets` y pega su ruta absoluta, que Claude Code y otras CLI leen como imagen (su propio Ctrl+V solo ve el portapapeles del servidor). El diálogo de pegado en HTTP simple también acepta una imagen pegada.
- **Pestaña de terminal en su propio panel**: el menú contextual de la pestaña incluye «Mover a un panel nuevo»: el shell en ejecución pasa a un panel aparte del espacio de trabajo con su búfer y proceso intactos.

### Correcciones
- **Terminal en el móvil**: abrir o cambiar a otra pestaña de shell ya no despliega el teclado en pantalla por sí solo, y un arrastre con el dedo sigue desplazando mientras el teclado sube; el teclado solo se abre con un toque.
<!-- lang:fr -->
### Nouveautés
- **Coller une capture d'écran dans la CLI** : Ctrl+V dans un volet de terminal envoie l'image du presse-papiers vers `~/.ddagent/assets` et colle son chemin absolu, que Claude Code et d'autres CLI lisent comme une image (leur propre Ctrl+V ne voit que le presse-papiers du serveur). La boîte de collage en HTTP simple accepte aussi une image collée.
- **Onglet de terminal dans son propre volet** : le menu contextuel de l'onglet propose « Déplacer vers un nouveau panneau » — le shell en cours passe dans un volet séparé de l'espace de travail, tampon et processus conservés.

### Corrections
- **Terminal sur téléphone** : ouvrir ou basculer vers un autre onglet de shell ne fait plus apparaître le clavier virtuel tout seul, et un glissement du doigt continue de défiler pendant que le clavier remonte ; le clavier ne s'ouvre qu'après un appui.
<!-- lang:it -->
### Novità
- **Incolla uno screenshot nella CLI**: Ctrl+V in un riquadro del terminale carica l'immagine degli appunti in `~/.ddagent/assets` e incolla il suo percorso assoluto, che Claude Code e altre CLI leggono come immagine (il loro Ctrl+V vede solo gli appunti del server). Anche la finestra di incolla su HTTP semplice accetta un'immagine incollata.
- **Scheda del terminale in un riquadro proprio**: il menu contestuale della scheda offre «Sposta in un nuovo pannello»: la shell attiva passa in un riquadro separato dell'area di lavoro con buffer e processo intatti.

### Correzioni
- **Terminale sul telefono**: aprire o passare a un'altra scheda shell non fa più comparire da sola la tastiera a schermo, e il trascinamento con il dito continua a scorrere mentre la tastiera sale; la tastiera si apre solo con un tocco.
<!-- lang:ja -->
### 新機能
- **スクリーンショットを CLI に貼り付け**：ターミナルペインで Ctrl+V を押すと、クリップボードの画像を `~/.ddagent/assets` にアップロードし、その絶対パスを貼り付けます。Claude Code などの CLI はこれを画像として読み込みます（CLI 自身の Ctrl+V はサーバー側のクリップボードしか見えません）。プレーン HTTP の貼り付けダイアログも貼り付けた画像を受け付けます。
- **ターミナルタブを専用ペインへ**：タブのコンテキストメニューに「新しいペインに移動」を追加。実行中のシェルをバッファとプロセスを保ったまま、ワークスペースの別ペインへ移せます。

### 修正
- **スマホのターミナル**：別のシェルタブを開いたり切り替えたりしても、ソフトキーボードが勝手に開かなくなりました。キーボードがせり上がる間も指でのスクロールが途切れません。キーボードはタップしたときだけ開きます。
<!-- lang:ko -->
### 새로운 기능
- **스크린샷을 CLI에 붙여넣기**: 터미널 창에서 Ctrl+V를 누르면 클립보드 이미지를 `~/.ddagent/assets`에 업로드하고 그 절대 경로를 붙여넣습니다. Claude Code 등 CLI는 이를 이미지로 읽습니다(CLI 자체의 Ctrl+V는 서버 클립보드만 봅니다). 일반 HTTP 붙여넣기 대화상자도 붙여넣은 이미지를 받습니다.
- **터미널 탭을 별도 창으로**: 탭 컨텍스트 메뉴에 "새 창으로 이동"이 추가되어, 실행 중인 셸을 버퍼와 프로세스를 유지한 채 작업 공간의 별도 창으로 옮길 수 있습니다.

### 수정
- **휴대폰 터미널**: 다른 셸 탭을 열거나 전환해도 화면 키보드가 저절로 올라오지 않으며, 키보드가 올라오는 동안에도 손가락 드래그 스크롤이 끊기지 않습니다. 키보드는 탭할 때만 열립니다.
<!-- lang:ru -->
### Что нового
- **Вставка скриншота в CLI**: Ctrl+V в панели терминала загружает изображение из буфера обмена в `~/.ddagent/assets` и вставляет его абсолютный путь, который Claude Code и другие CLI читают как изображение (их собственный Ctrl+V видит только буфер обмена сервера). Диалог вставки при обычном HTTP тоже принимает вставленное изображение.
- **Вкладка терминала в отдельной панели**: в контекстном меню вкладки появился пункт «Переместить в новую панель» — работающая оболочка переносится в отдельную панель рабочей области с сохранением буфера и процесса.

### Исправления
- **Терминал на телефоне**: открытие другой вкладки оболочки или переключение на неё больше не вызывает экранную клавиатуру само по себе, а прокрутка пальцем не прерывается, пока клавиатура выезжает; клавиатура открывается только по касанию.
<!-- lang:tr -->
### Yenilikler
- **Ekran görüntüsünü CLI'ye yapıştırma**: Terminal bölmesinde Ctrl+V, panodaki görüntüyü `~/.ddagent/assets` klasörüne yükler ve mutlak yolunu yapıştırır; Claude Code ve diğer CLI'ler bunu görüntü olarak okur (kendi Ctrl+V'leri yalnızca sunucunun panosunu görür). Düz HTTP yapıştırma iletişim kutusu da yapıştırılan görüntüyü kabul eder.
- **Terminal sekmesi kendi bölmesinde**: Sekme bağlam menüsünde „Yeni bölmeye taşı” var — çalışan kabuk, arabelleği ve süreci korunarak çalışma alanında ayrı bir bölmeye taşınır.

### Düzeltmeler
- **Telefonda terminal**: Başka bir kabuk sekmesini açmak veya ona geçmek ekran klavyesini artık kendiliğinden açmıyor ve klavye kayarken parmakla kaydırma kesilmiyor; klavye yalnızca dokunulduğunda açılır.
<!-- lang:zh-CN -->
### 新功能
- **将截图粘贴到 CLI**：在终端面板中按 Ctrl+V，会把剪贴板图片上传到 `~/.ddagent/assets` 并粘贴其绝对路径，Claude Code 等 CLI 会将其作为图片读取（CLI 自身的 Ctrl+V 只能看到服务器的剪贴板）。纯 HTTP 下的粘贴对话框也接受粘贴的图片。
- **终端标签移到独立面板**：标签右键菜单新增"移到新面板"，正在运行的 shell 连同缓冲区和进程一起移到工作区的独立面板。

### 修复
- **手机上的终端**：打开或切换到另一个 shell 标签时不再自动弹出软键盘，键盘升起时手指拖动滚动也不会中断；键盘只在点按后打开。
<!-- lang:zh-TW -->
### 新功能
- **將截圖貼到 CLI**：在終端機面板按 Ctrl+V，會把剪貼簿圖片上傳到 `~/.ddagent/assets` 並貼上其絕對路徑，Claude Code 等 CLI 會將其視為圖片讀取（CLI 本身的 Ctrl+V 只看得到伺服器的剪貼簿）。純 HTTP 下的貼上對話框也接受貼上的圖片。
- **終端機分頁移到獨立面板**：分頁右鍵選單新增「移到新面板」，執行中的 shell 連同緩衝區與程序一起移到工作區的獨立面板。

### 修正
- **手機上的終端機**：開啟或切換到另一個 shell 分頁時不再自動彈出螢幕鍵盤，鍵盤升起時手指拖曳捲動也不會中斷；鍵盤只在點按後開啟。
