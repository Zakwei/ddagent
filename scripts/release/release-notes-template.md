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
### A VS Code-style file explorer and panes you can arrange freely
- **New file explorer.** Files and the editor sidebar now show a compact tree like in VS Code. Single folders are folded into one row, and the open file is revealed. Git changes are marked with colours and letters. You can create and rename files in place. The keyboard works too: arrows, Enter, F2, Delete.
- **Move and copy files.** Drag a file or folder onto another folder to move it, after a confirmation. You can also use Cut, Copy and Paste from the menu or with Ctrl+X, Ctrl+C and Ctrl+V. Open editor tabs follow a renamed or moved file.
- **Search in Files.** Type to filter by name. Press Enter to search file contents, with results grouped by file.
- **Panes like in VS Code.** Drag the border between panes to resize them. Double-click a border to make them equal. Drag a pane by its header onto another pane's edge to split, or onto its centre to add it as a tab. Drop it on the edge of the whole workspace to get a full-height column or full-width row. Double-click a header to maximize the pane. Terminals stay connected while you rearrange them.
- **Layout follows you.** Your pane layout syncs between devices. "Reset layout" restores the default grid.
- **Pane shortcuts.** Ctrl+Alt+arrows go to the next pane. Ctrl+Alt+1…9 go to a pane group. Ctrl+Alt+PgUp/PgDn switch tabs in a group. The keyboard icon in the toolbar lists all gestures.
- **On the phone,** hold a pane tab and drop it on another one to swap them.
- **Fix:** answer buttons disappear when you answer the agent's question directly in the terminal.
<!-- lang:pl -->
### Eksplorator plików jak w VS Code i panele, które ułożysz po swojemu
- **Nowy eksplorator plików.** Pliki i boczny panel edytora pokazują teraz zwarte drzewo jak w VS Code. Pojedyncze foldery łączą się w jeden wiersz, a otwarty plik jest od razu odsłonięty. Zmiany w Git są oznaczone kolorem i literą. Pliki tworzysz i zmieniasz ich nazwy w miejscu. Działa też klawiatura: strzałki, Enter, F2, Delete.
- **Przenoszenie i kopiowanie plików.** Przeciągnij plik lub folder na inny folder, aby go przenieść (z potwierdzeniem). Możesz też użyć Wytnij, Kopiuj i Wklej z menu albo skrótów Ctrl+X, Ctrl+C i Ctrl+V. Otwarte karty edytora podążają za przeniesionym lub przemianowanym plikiem.
- **Szukanie w Plikach.** Pisz, aby filtrować po nazwie. Enter przeszukuje zawartość plików, a wyniki są pogrupowane według pliku.
- **Panele jak w VS Code.** Przeciągnij granicę między panelami, aby zmienić ich rozmiar. Dwuklik na granicy wyrównuje je. Przeciągnij panel za nagłówek na krawędź innego panelu, aby go podzielić, albo na środek, aby dodać go jako kartę. Upuszczony przy krawędzi całego obszaru tworzy kolumnę na pełną wysokość lub wiersz na pełną szerokość. Dwuklik na nagłówku maksymalizuje panel. Terminale nie rozłączają się przy przestawianiu.
- **Układ jedzie z Tobą.** Układ paneli synchronizuje się między urządzeniami. „Resetuj układ” przywraca domyślną siatkę.
- **Skróty paneli.** Ctrl+Alt+strzałki przechodzą do sąsiedniego panelu. Ctrl+Alt+1…9 do grupy paneli. Ctrl+Alt+PgUp/PgDn przełączają karty w grupie. Ikona klawiatury na pasku narzędzi pokazuje wszystkie gesty.
- **Na telefonie** przytrzymaj kartę panelu i upuść ją na inną, aby zamienić je miejscami.
- **Poprawka:** przyciski odpowiedzi znikają, gdy odpowiesz na pytanie agenta bezpośrednio w terminalu.
<!-- lang:de -->
### Ein Datei-Explorer wie in VS Code und frei anordenbare Bereiche
- **Neuer Datei-Explorer.** Dateien und die Editor-Seitenleiste zeigen jetzt einen kompakten Baum wie in VS Code. Einzelne Ordner werden zu einer Zeile zusammengefasst, und die geöffnete Datei wird aufgedeckt. Git-Änderungen sind mit Farben und Buchstaben markiert. Dateien legst du direkt an Ort und Stelle an und benennst sie um. Die Tastatur funktioniert auch: Pfeile, Enter, F2, Entf.
- **Dateien verschieben und kopieren.** Ziehe eine Datei oder einen Ordner auf einen anderen Ordner, um ihn nach einer Bestätigung zu verschieben. Du kannst auch Ausschneiden, Kopieren und Einfügen aus dem Menü oder mit Strg+X, Strg+C und Strg+V nutzen. Offene Editor-Tabs folgen einer umbenannten oder verschobenen Datei.
- **Suche in Dateien.** Tippe, um nach Namen zu filtern. Enter durchsucht die Dateiinhalte, die Treffer sind nach Datei gruppiert.
- **Bereiche wie in VS Code.** Ziehe die Grenze zwischen Bereichen, um ihre Größe zu ändern. Ein Doppelklick auf die Grenze macht sie gleich groß. Ziehe einen Bereich an seiner Kopfzeile an den Rand eines anderen, um zu teilen, oder in dessen Mitte, um ihn als Tab hinzuzufügen. Am Rand des gesamten Arbeitsbereichs abgelegt, entsteht eine Spalte über die volle Höhe oder eine Zeile über die volle Breite. Ein Doppelklick auf die Kopfzeile maximiert den Bereich. Terminals bleiben beim Umordnen verbunden.
- **Das Layout reist mit.** Die Anordnung der Bereiche wird zwischen Geräten synchronisiert. „Layout zurücksetzen“ stellt das Standardraster wieder her.
- **Tastenkürzel für Bereiche.** Strg+Alt+Pfeile wechseln zum benachbarten Bereich. Strg+Alt+1…9 zu einer Bereichsgruppe. Strg+Alt+Bild↑/Bild↓ wechseln Tabs in einer Gruppe. Das Tastatursymbol in der Werkzeugleiste listet alle Gesten auf.
- **Auf dem Handy** halte einen Bereichs-Tab gedrückt und lege ihn auf einem anderen ab, um sie zu tauschen.
- **Korrektur:** Antwortschaltflächen verschwinden, wenn du die Frage des Agenten direkt im Terminal beantwortest.
<!-- lang:es -->
### Un explorador de archivos al estilo de VS Code y paneles que puedes organizar libremente
- **Nuevo explorador de archivos.** Archivos y la barra lateral del editor muestran ahora un árbol compacto como en VS Code. Las carpetas únicas se agrupan en una sola fila y el archivo abierto queda a la vista. Los cambios de Git se marcan con colores y letras. Puedes crear y renombrar archivos en el sitio. El teclado también funciona: flechas, Enter, F2, Supr.
- **Mover y copiar archivos.** Arrastra un archivo o carpeta sobre otra carpeta para moverlo, tras una confirmación. También puedes usar Cortar, Copiar y Pegar desde el menú o con Ctrl+X, Ctrl+C y Ctrl+V. Las pestañas abiertas del editor siguen al archivo renombrado o movido.
- **Búsqueda en Archivos.** Escribe para filtrar por nombre. Pulsa Enter para buscar en el contenido, con resultados agrupados por archivo.
- **Paneles como en VS Code.** Arrastra el borde entre paneles para cambiar su tamaño. Doble clic en el borde los iguala. Arrastra un panel por su cabecera al borde de otro para dividirlo, o a su centro para añadirlo como pestaña. Si lo sueltas en el borde de todo el espacio de trabajo, obtienes una columna de altura completa o una fila de ancho completo. Doble clic en la cabecera maximiza el panel. Los terminales siguen conectados mientras los reorganizas.
- **La disposición te acompaña.** La disposición de los paneles se sincroniza entre dispositivos. «Restablecer disposición» devuelve la cuadrícula predeterminada.
- **Atajos de paneles.** Ctrl+Alt+flechas pasan al panel vecino. Ctrl+Alt+1…9 a un grupo de paneles. Ctrl+Alt+RePág/AvPág cambian de pestaña en un grupo. El icono del teclado en la barra de herramientas muestra todos los gestos.
- **En el teléfono,** mantén pulsada la pestaña de un panel y suéltala sobre otra para intercambiarlas.
- **Corrección:** los botones de respuesta desaparecen cuando respondes a la pregunta del agente directamente en el terminal.
<!-- lang:fr -->
### Un explorateur de fichiers façon VS Code et des panneaux à disposer librement
- **Nouvel explorateur de fichiers.** Fichiers et la barre latérale de l'éditeur affichent désormais un arbre compact comme dans VS Code. Les dossiers uniques sont regroupés sur une ligne et le fichier ouvert est révélé. Les modifications Git sont signalées par des couleurs et des lettres. Vous créez et renommez les fichiers sur place. Le clavier fonctionne aussi : flèches, Entrée, F2, Suppr.
- **Déplacer et copier des fichiers.** Faites glisser un fichier ou un dossier sur un autre dossier pour le déplacer, après confirmation. Vous pouvez aussi utiliser Couper, Copier et Coller depuis le menu ou avec Ctrl+X, Ctrl+C et Ctrl+V. Les onglets ouverts de l'éditeur suivent un fichier renommé ou déplacé.
- **Recherche dans Fichiers.** Tapez pour filtrer par nom. Entrée recherche dans le contenu des fichiers, avec des résultats groupés par fichier.
- **Des panneaux comme dans VS Code.** Faites glisser la bordure entre les panneaux pour les redimensionner. Un double-clic sur la bordure les égalise. Faites glisser un panneau par son en-tête vers le bord d'un autre pour le scinder, ou vers son centre pour l'ajouter en onglet. Déposé au bord de tout l'espace de travail, il forme une colonne pleine hauteur ou une ligne pleine largeur. Un double-clic sur l'en-tête agrandit le panneau. Les terminaux restent connectés pendant la réorganisation.
- **La disposition vous suit.** La disposition des panneaux se synchronise entre appareils. « Réinitialiser la disposition » rétablit la grille par défaut.
- **Raccourcis des panneaux.** Ctrl+Alt+flèches passent au panneau voisin. Ctrl+Alt+1…9 à un groupe de panneaux. Ctrl+Alt+PgPréc/PgSuiv changent d'onglet dans un groupe. L'icône du clavier dans la barre d'outils liste tous les gestes.
- **Sur le téléphone,** maintenez l'onglet d'un panneau et déposez-le sur un autre pour les échanger.
- **Correction :** les boutons de réponse disparaissent quand vous répondez à la question de l'agent directement dans le terminal.
<!-- lang:it -->
### Un esplora file in stile VS Code e pannelli da disporre liberamente
- **Nuovo esplora file.** File e la barra laterale dell'editor mostrano ora un albero compatto come in VS Code. Le cartelle singole sono raccolte in una riga e il file aperto viene mostrato. Le modifiche Git sono segnate con colori e lettere. Puoi creare e rinominare i file sul posto. Funziona anche la tastiera: frecce, Invio, F2, Canc.
- **Spostare e copiare file.** Trascina un file o una cartella su un'altra cartella per spostarlo, dopo una conferma. Puoi anche usare Taglia, Copia e Incolla dal menu o con Ctrl+X, Ctrl+C e Ctrl+V. Le schede aperte dell'editor seguono un file rinominato o spostato.
- **Ricerca in File.** Digita per filtrare per nome. Invio cerca nel contenuto dei file, con risultati raggruppati per file.
- **Pannelli come in VS Code.** Trascina il bordo tra i pannelli per ridimensionarli. Un doppio clic sul bordo li rende uguali. Trascina un pannello per l'intestazione sul bordo di un altro per dividerlo, o al centro per aggiungerlo come scheda. Rilasciato sul bordo dell'intera area di lavoro, crea una colonna a tutta altezza o una riga a tutta larghezza. Un doppio clic sull'intestazione ingrandisce il pannello. I terminali restano connessi mentre li riorganizzi.
- **Il layout ti segue.** La disposizione dei pannelli si sincronizza tra dispositivi. «Ripristina layout» riporta la griglia predefinita.
- **Scorciatoie dei pannelli.** Ctrl+Alt+frecce passano al pannello vicino. Ctrl+Alt+1…9 a un gruppo di pannelli. Ctrl+Alt+PagSu/PagGiù cambiano scheda in un gruppo. L'icona della tastiera nella barra degli strumenti elenca tutti i gesti.
- **Sul telefono,** tieni premuta la scheda di un pannello e rilasciala su un'altra per scambiarle.
- **Correzione:** i pulsanti di risposta scompaiono quando rispondi alla domanda dell'agente direttamente nel terminale.
<!-- lang:ja -->
### VS Code 風のファイルエクスプローラーと自由に配置できるペイン
- **新しいファイルエクスプローラー。** ファイル画面とエディターのサイドバーに、VS Code のようなコンパクトなツリーが表示されます。中身が 1 つだけのフォルダーは 1 行にまとめられ、開いているファイルが自動で表示されます。Git の変更は色と文字で示されます。ファイルの作成と名前変更はその場でできます。キーボードも使えます: 矢印キー、Enter、F2、Delete。
- **ファイルの移動とコピー。** ファイルやフォルダーを別のフォルダーにドラッグすると、確認のあと移動します。メニューや Ctrl+X、Ctrl+C、Ctrl+V で切り取り・コピー・貼り付けもできます。開いているエディターのタブは、名前変更や移動したファイルに追従します。
- **ファイル内の検索。** 入力すると名前で絞り込みます。Enter でファイルの内容を検索し、結果はファイルごとにまとめて表示されます。
- **VS Code のようなペイン。** ペインの境界をドラッグしてサイズを変更できます。境界をダブルクリックすると均等になります。ペインをヘッダーでつかんで別のペインの端にドロップすると分割、中央にドロップするとタブとして追加されます。ワークスペース全体の端にドロップすると、全高の列または全幅の行になります。ヘッダーをダブルクリックするとペインを最大化します。並べ替えの間もターミナルは接続されたままです。
- **レイアウトはどこでも同じ。** ペインの配置はデバイス間で同期されます。「レイアウトをリセット」で既定のグリッドに戻ります。
- **ペインのショートカット。** Ctrl+Alt+矢印キーで隣のペインへ、Ctrl+Alt+1…9 でペイングループへ移動します。Ctrl+Alt+PgUp/PgDn でグループ内のタブを切り替えます。ツールバーのキーボードアイコンにすべての操作が表示されます。
- **スマートフォンでは、** ペインのタブを長押しして別のタブにドロップすると入れ替わります。
- **修正:** エージェントの質問にターミナルで直接答えると、回答ボタンが消えるようになりました。
<!-- lang:ko -->
### VS Code 스타일의 파일 탐색기와 자유롭게 배치하는 패널
- **새 파일 탐색기.** 파일 화면과 편집기 사이드바에 VS Code처럼 촘촘한 트리가 표시됩니다. 하위 항목이 하나뿐인 폴더는 한 줄로 합쳐지고, 열린 파일이 바로 보입니다. Git 변경 사항은 색과 글자로 표시됩니다. 파일을 그 자리에서 만들고 이름을 바꿀 수 있습니다. 키보드도 사용할 수 있습니다: 화살표, Enter, F2, Delete.
- **파일 이동과 복사.** 파일이나 폴더를 다른 폴더로 끌어다 놓으면 확인 후 이동합니다. 메뉴나 Ctrl+X, Ctrl+C, Ctrl+V로 잘라내기, 복사, 붙여넣기도 할 수 있습니다. 열린 편집기 탭은 이름이 바뀌거나 이동된 파일을 따라갑니다.
- **파일에서 검색.** 입력하면 이름으로 걸러집니다. Enter를 누르면 파일 내용을 검색하며, 결과는 파일별로 묶여 표시됩니다.
- **VS Code 같은 패널.** 패널 사이의 경계를 끌어 크기를 조절합니다. 경계를 두 번 클릭하면 크기가 같아집니다. 패널 헤더를 끌어 다른 패널의 가장자리에 놓으면 분할되고, 가운데에 놓으면 탭으로 추가됩니다. 작업 공간 전체의 가장자리에 놓으면 전체 높이의 열이나 전체 너비의 행이 됩니다. 헤더를 두 번 클릭하면 패널이 최대화됩니다. 재배치하는 동안에도 터미널 연결은 유지됩니다.
- **레이아웃이 함께 따라갑니다.** 패널 배치는 기기 간에 동기화됩니다. "레이아웃 초기화"는 기본 격자로 되돌립니다.
- **패널 단축키.** Ctrl+Alt+화살표는 옆 패널로, Ctrl+Alt+1…9는 패널 그룹으로 이동합니다. Ctrl+Alt+PgUp/PgDn은 그룹 안의 탭을 전환합니다. 도구 모음의 키보드 아이콘에서 모든 동작을 볼 수 있습니다.
- **휴대폰에서는** 패널 탭을 길게 눌러 다른 탭에 놓으면 서로 자리가 바뀝니다.
- **수정:** 에이전트의 질문에 터미널에서 직접 답하면 답변 버튼이 사라집니다.
<!-- lang:ru -->
### Проводник файлов в стиле VS Code и панели, которые можно расставлять как угодно
- **Новый проводник файлов.** Файлы и боковая панель редактора теперь показывают компактное дерево, как в VS Code. Одиночные папки сворачиваются в одну строку, а открытый файл сразу виден. Изменения Git отмечены цветом и буквой. Файлы создаются и переименовываются прямо на месте. Работает и клавиатура: стрелки, Enter, F2, Delete.
- **Перемещение и копирование файлов.** Перетащите файл или папку на другую папку, чтобы переместить их после подтверждения. Можно также использовать Вырезать, Копировать и Вставить из меню или через Ctrl+X, Ctrl+C и Ctrl+V. Открытые вкладки редактора следуют за переименованным или перемещённым файлом.
- **Поиск в Файлах.** Печатайте, чтобы фильтровать по имени. Enter ищет по содержимому файлов, результаты сгруппированы по файлам.
- **Панели как в VS Code.** Перетащите границу между панелями, чтобы изменить их размер. Двойной щелчок по границе выравнивает их. Перетащите панель за заголовок на край другой, чтобы разделить её, или в центр, чтобы добавить вкладкой. Брошенная у края всей рабочей области панель становится столбцом на всю высоту или строкой на всю ширину. Двойной щелчок по заголовку разворачивает панель. Терминалы не отключаются при перестановке.
- **Раскладка следует за вами.** Расположение панелей синхронизируется между устройствами. «Сбросить раскладку» возвращает стандартную сетку.
- **Сочетания клавиш для панелей.** Ctrl+Alt+стрелки переходят к соседней панели, Ctrl+Alt+1…9 — к группе панелей. Ctrl+Alt+PgUp/PgDn переключают вкладки в группе. Значок клавиатуры на панели инструментов показывает все жесты.
- **На телефоне** удерживайте вкладку панели и бросьте её на другую, чтобы поменять их местами.
- **Исправление:** кнопки ответа исчезают, когда вы отвечаете на вопрос агента прямо в терминале.
<!-- lang:tr -->
### VS Code tarzı bir dosya gezgini ve serbestçe düzenlenebilen paneller
- **Yeni dosya gezgini.** Dosyalar ve düzenleyici kenar çubuğu artık VS Code'daki gibi sıkı bir ağaç gösteriyor. Tek alt öğesi olan klasörler tek satırda birleşiyor ve açık dosya görünür hale geliyor. Git değişiklikleri renk ve harfle işaretleniyor. Dosyaları yerinde oluşturup yeniden adlandırabilirsiniz. Klavye de çalışıyor: oklar, Enter, F2, Delete.
- **Dosya taşıma ve kopyalama.** Bir dosyayı veya klasörü başka bir klasörün üzerine sürükleyin, onaydan sonra taşınır. Menüden ya da Ctrl+X, Ctrl+C ve Ctrl+V ile Kes, Kopyala ve Yapıştır da kullanabilirsiniz. Açık düzenleyici sekmeleri yeniden adlandırılan veya taşınan dosyayı takip eder.
- **Dosyalarda arama.** Yazarak ada göre süzün. Enter dosya içeriklerinde arar, sonuçlar dosyaya göre gruplanır.
- **VS Code gibi paneller.** Boyutlarını değiştirmek için paneller arasındaki sınırı sürükleyin. Sınıra çift tıklamak onları eşitler. Bir paneli başlığından tutup başka bir panelin kenarına bırakırsanız bölünür, ortasına bırakırsanız sekme olarak eklenir. Tüm çalışma alanının kenarına bırakılırsa tam yükseklikte bir sütun veya tam genişlikte bir satır olur. Başlığa çift tıklamak paneli büyütür. Yeniden düzenlerken terminallerin bağlantısı kopmaz.
- **Düzen sizinle gelir.** Panel düzeni cihazlar arasında eşitlenir. "Düzeni sıfırla" varsayılan ızgarayı geri getirir.
- **Panel kısayolları.** Ctrl+Alt+oklar komşu panele, Ctrl+Alt+1…9 bir panel grubuna geçer. Ctrl+Alt+PgUp/PgDn bir gruptaki sekmeleri değiştirir. Araç çubuğundaki klavye simgesi tüm hareketleri listeler.
- **Telefonda** bir panel sekmesine basılı tutup başka bir sekmenin üzerine bırakarak yerlerini değiştirin.
- **Düzeltme:** ajanın sorusunu doğrudan terminalde yanıtladığınızda yanıt düğmeleri kaybolur.
<!-- lang:zh-CN -->
### VS Code 风格的文件资源管理器，以及可自由排列的面板
- **全新文件资源管理器。** 文件页和编辑器侧栏现在显示类似 VS Code 的紧凑树。只有一个子项的文件夹会合并为一行，打开的文件会自动显示出来。Git 更改用颜色和字母标出。可以原地新建和重命名文件。也可以用键盘操作：方向键、Enter、F2、Delete。
- **移动和复制文件。** 将文件或文件夹拖到另一个文件夹上，确认后即可移动。也可以通过菜单或 Ctrl+X、Ctrl+C、Ctrl+V 剪切、复制和粘贴。打开的编辑器标签页会跟随被重命名或移动的文件。
- **在文件中搜索。** 输入即可按名称筛选。按 Enter 搜索文件内容，结果按文件分组。
- **像 VS Code 一样的面板。** 拖动面板之间的边界可调整大小，双击边界可使其等宽。按住标题把面板拖到另一个面板的边缘可拆分，拖到中央则作为标签页加入。放到整个工作区的边缘会形成整列高度的列或整行宽度的行。双击标题可最大化面板。重新排列时终端保持连接。
- **布局随你而行。** 面板布局会在设备之间同步。“重置布局”可恢复默认网格。
- **面板快捷键。** Ctrl+Alt+方向键切换到相邻面板，Ctrl+Alt+1…9 切换到面板组，Ctrl+Alt+PgUp/PgDn 切换组内标签页。工具栏中的键盘图标列出所有手势。
- **在手机上，** 长按面板标签并拖到另一个标签上即可交换位置。
- **修复：** 直接在终端中回答智能体的问题后，回答按钮会消失。
<!-- lang:zh-TW -->
### VS Code 風格的檔案總管，以及可自由排列的面板
- **全新檔案總管。** 檔案頁和編輯器側欄現在顯示類似 VS Code 的緊湊樹狀結構。只有一個子項的資料夾會合併為一列，開啟的檔案會自動顯示出來。Git 變更以顏色和字母標示。可以就地新增和重新命名檔案。也可以用鍵盤操作：方向鍵、Enter、F2、Delete。
- **移動和複製檔案。** 將檔案或資料夾拖到另一個資料夾上，確認後即可移動。也可以透過選單或 Ctrl+X、Ctrl+C、Ctrl+V 剪下、複製和貼上。開啟的編輯器分頁會跟隨被重新命名或移動的檔案。
- **在檔案中搜尋。** 輸入即可依名稱篩選。按 Enter 搜尋檔案內容，結果依檔案分組。
- **像 VS Code 一樣的面板。** 拖曳面板之間的邊界可調整大小，按兩下邊界可使其等寬。按住標題把面板拖到另一個面板的邊緣可分割，拖到中央則作為分頁加入。放到整個工作區的邊緣會形成全高的欄或全寬的列。按兩下標題可將面板最大化。重新排列時終端機保持連線。
- **版面隨你而行。** 面板版面會在裝置之間同步。「重設版面」可恢復預設格線。
- **面板快捷鍵。** Ctrl+Alt+方向鍵切換到相鄰面板，Ctrl+Alt+1…9 切換到面板群組，Ctrl+Alt+PgUp/PgDn 切換群組內的分頁。工具列中的鍵盤圖示列出所有手勢。
- **在手機上，** 長按面板分頁並拖到另一個分頁上即可交換位置。
- **修正：** 直接在終端機中回答代理的問題後，回答按鈕會消失。
