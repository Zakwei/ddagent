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
### A VS Code-style editor on the phone
- **Files open in a full-screen editor.** On a phone, tapping a file in Files opens it in the editor with tabs for your open files. Back returns to the tree.
- **Slide-over explorer.** In the editor the file tree slides in from the left, like Ctrl+B in VS Code. It hides once you pick a file; the panel icon on the toolbar brings it back.
- **A toolbar that fits.** The phone toolbar keeps the path, search and Save. Preview, diff, reload, download and "Save all" live in the "⋮" menu. The minimap is hidden on narrow screens, so code gets the full width.
- **Go to file.** The search icon or Ctrl+P finds a file by name, like in VS Code: "mdart" finds `main.dart`. Enter opens the best match.
- **No more answer hints over the terminal.** The answer buttons shown over the agent's questions are gone, so they no longer cover what Claude prints.
- **Fix: app updates download through your server.** The update is fetched via the ddagent server instead of github.com, so it works even when the phone cannot reach GitHub. Update the server to this version first.
<!-- lang:pl -->
### Edytor jak w VS Code na telefonie
- **Pliki otwierają się w edytorze na pełny ekran.** Na telefonie stuknięcie pliku w Plikach otwiera go w edytorze z kartami otwartych plików. Wstecz wraca do drzewa.
- **Wysuwany eksplorator.** W edytorze drzewo plików wysuwa się z lewej, jak Ctrl+B w VS Code. Chowa się po wybraniu pliku, a ikona panelu na pasku narzędzi przywraca je.
- **Pasek narzędzi, który się mieści.** Na telefonie pasek ma ścieżkę, wyszukiwanie i Zapisz. Podgląd, diff, przeładowanie, pobieranie i „Zapisz wszystko” są w menu „⋮”. Minimapa jest ukryta na wąskim ekranie, więc kod ma pełną szerokość.
- **Przejdź do pliku.** Ikona lupy lub Ctrl+P szuka pliku po nazwie jak w VS Code: „mdart” znajdzie `main.dart`. Enter otwiera najlepsze dopasowanie.
- **Koniec z podpowiedziami odpowiedzi nad terminalem.** Przyciski odpowiedzi nad pytaniami agenta zniknęły, więc nie zasłaniają już tego, co pokazuje Claude.
- **Poprawka: aktualizacje aplikacji pobierają się przez Twój serwer.** Aktualizacja jest pobierana przez serwer ddagent zamiast z github.com, więc działa także wtedy, gdy telefon nie może połączyć się z GitHubem. Najpierw zaktualizuj serwer do tej wersji.
<!-- lang:de -->
### Ein Editor wie in VS Code auf dem Handy
- **Dateien öffnen sich im Vollbild-Editor.** Auf dem Handy öffnet ein Tipp auf eine Datei in Dateien sie im Editor mit Tabs für deine geöffneten Dateien. Zurück führt zum Baum.
- **Einblendbarer Explorer.** Im Editor gleitet der Dateibaum von links herein, wie Strg+B in VS Code. Er verschwindet, sobald du eine Datei wählst; das Bereichssymbol in der Werkzeugleiste holt ihn zurück.
- **Eine Werkzeugleiste, die passt.** Auf dem Handy enthält die Leiste den Pfad, die Suche und Speichern. Vorschau, Diff, Neu laden, Herunterladen und „Alle speichern“ stehen im Menü „⋮“. Die Minimap ist auf schmalen Bildschirmen ausgeblendet, damit der Code die volle Breite hat.
- **Gehe zu Datei.** Das Lupensymbol oder Strg+P findet eine Datei nach Namen wie in VS Code: „mdart“ findet `main.dart`. Enter öffnet den besten Treffer.
- **Keine Antwort-Hinweise mehr über dem Terminal.** Die Antwortschaltflächen über den Fragen des Agenten sind weg und verdecken nicht mehr, was Claude anzeigt.
- **Korrektur: App-Updates werden über deinen Server geladen.** Das Update kommt über den ddagent-Server statt von github.com und funktioniert daher auch, wenn das Handy GitHub nicht erreicht. Aktualisiere zuerst den Server auf diese Version.
<!-- lang:es -->
### Un editor como VS Code en el móvil
- **Los archivos se abren en un editor a pantalla completa.** En el móvil, tocar un archivo en Archivos lo abre en el editor con pestañas para los archivos abiertos. Atrás vuelve al árbol.
- **Explorador deslizante.** En el editor, el árbol de archivos se desliza desde la izquierda, como Ctrl+B en VS Code. Se oculta al elegir un archivo; el icono de panel de la barra lo vuelve a mostrar.
- **Una barra de herramientas que cabe.** En el móvil la barra tiene la ruta, la búsqueda y Guardar. Vista previa, diff, recargar, descargar y «Guardar todo» están en el menú «⋮». El minimapa se oculta en pantallas estrechas para que el código ocupe todo el ancho.
- **Ir a archivo.** El icono de lupa o Ctrl+P busca un archivo por nombre como en VS Code: «mdart» encuentra `main.dart`. Intro abre la mejor coincidencia.
- **Adiós a las sugerencias de respuesta sobre el terminal.** Los botones de respuesta sobre las preguntas del agente han desaparecido y ya no tapan lo que muestra Claude.
- **Corrección: las actualizaciones de la app se descargan a través de tu servidor.** La actualización se obtiene mediante el servidor ddagent en lugar de github.com, así que funciona aunque el móvil no pueda acceder a GitHub. Actualiza primero el servidor a esta versión.
<!-- lang:fr -->
### Un éditeur façon VS Code sur le téléphone
- **Les fichiers s'ouvrent dans un éditeur plein écran.** Sur téléphone, toucher un fichier dans Fichiers l'ouvre dans l'éditeur avec des onglets pour les fichiers ouverts. Retour revient à l'arborescence.
- **Explorateur coulissant.** Dans l'éditeur, l'arborescence glisse depuis la gauche, comme Ctrl+B dans VS Code. Elle se masque dès que vous choisissez un fichier ; l'icône de panneau de la barre d'outils la rouvre.
- **Une barre d'outils qui tient à l'écran.** Sur téléphone, la barre garde le chemin, la recherche et Enregistrer. Aperçu, diff, recharger, télécharger et « Tout enregistrer » sont dans le menu « ⋮ ». La minimap est masquée sur les écrans étroits pour laisser toute la largeur au code.
- **Aller au fichier.** L'icône de loupe ou Ctrl+P trouve un fichier par son nom comme dans VS Code : « mdart » trouve `main.dart`. Entrée ouvre le meilleur résultat.
- **Fini les suggestions de réponse au-dessus du terminal.** Les boutons de réponse au-dessus des questions de l'agent ont disparu et ne masquent plus ce qu'affiche Claude.
- **Correctif : les mises à jour de l'app passent par votre serveur.** La mise à jour est téléchargée via le serveur ddagent au lieu de github.com, elle fonctionne donc même si le téléphone n'accède pas à GitHub. Mettez d'abord le serveur à jour vers cette version.
<!-- lang:it -->
### Un editor in stile VS Code sul telefono
- **I file si aprono in un editor a schermo intero.** Sul telefono, toccare un file in File lo apre nell'editor con le schede dei file aperti. Indietro torna all'albero.
- **Esplora risorse a scomparsa.** Nell'editor l'albero dei file scorre da sinistra, come Ctrl+B in VS Code. Si nasconde quando scegli un file; l'icona del pannello nella barra lo riapre.
- **Una barra degli strumenti che ci sta.** Sul telefono la barra mostra il percorso, la ricerca e Salva. Anteprima, diff, ricarica, download e «Salva tutto» sono nel menu «⋮». La minimappa è nascosta sugli schermi stretti, così il codice usa tutta la larghezza.
- **Vai al file.** L'icona della lente o Ctrl+P trova un file per nome come in VS Code: «mdart» trova `main.dart`. Invio apre il risultato migliore.
- **Niente più suggerimenti di risposta sopra il terminale.** I pulsanti di risposta sopra le domande dell'agente sono spariti e non coprono più ciò che mostra Claude.
- **Correzione: gli aggiornamenti dell'app passano dal tuo server.** L'aggiornamento viene scaricato tramite il server ddagent invece che da github.com, quindi funziona anche se il telefono non raggiunge GitHub. Aggiorna prima il server a questa versione.
<!-- lang:ja -->
### スマートフォンで VS Code のようなエディター
- **ファイルは全画面のエディターで開きます。** スマートフォンでは「ファイル」でファイルをタップすると、開いているファイルのタブ付きエディターで開きます。戻るでツリーに戻ります。
- **スライドするエクスプローラー。** エディターではファイルツリーが VS Code の Ctrl+B のように左からスライドして表示されます。ファイルを選ぶと隠れ、ツールバーのパネルアイコンで再表示できます。
- **画面に収まるツールバー。** スマートフォンのツールバーにはパス、検索、保存だけを表示します。プレビュー、差分、再読み込み、ダウンロード、「すべて保存」は「⋮」メニューにあります。狭い画面ではミニマップを隠し、コードが全幅を使えます。
- **ファイルへ移動。** 虫眼鏡アイコンまたは Ctrl+P で、VS Code のように名前でファイルを探せます。「mdart」で `main.dart` が見つかります。Enter で最も一致するファイルを開きます。
- **ターミナル上の回答ヒントを廃止。** エージェントの質問の上に出ていた回答ボタンをなくしたので、Claude の表示を隠さなくなりました。
- **修正：アプリの更新はサーバー経由でダウンロード。** 更新は github.com ではなく ddagent サーバー経由で取得するため、スマートフォンが GitHub に接続できなくても動作します。先にサーバーをこのバージョンに更新してください。
<!-- lang:ko -->
### 휴대폰에서도 VS Code 같은 편집기
- **파일이 전체 화면 편집기에서 열립니다.** 휴대폰의 파일에서 파일을 탭하면 열린 파일 탭이 있는 편집기에서 열립니다. 뒤로 가기로 트리에 돌아갑니다.
- **슬라이드 탐색기.** 편집기에서 파일 트리가 VS Code의 Ctrl+B처럼 왼쪽에서 밀려 나옵니다. 파일을 고르면 숨겨지고, 도구 모음의 패널 아이콘으로 다시 열 수 있습니다.
- **화면에 맞는 도구 모음.** 휴대폰 도구 모음에는 경로, 검색, 저장만 남습니다. 미리보기, diff, 다시 불러오기, 다운로드, "모두 저장"은 "⋮" 메뉴에 있습니다. 좁은 화면에서는 미니맵을 숨겨 코드가 전체 너비를 씁니다.
- **파일로 이동.** 돋보기 아이콘이나 Ctrl+P로 VS Code처럼 이름으로 파일을 찾습니다. "mdart"로 `main.dart`를 찾을 수 있습니다. Enter는 가장 잘 맞는 파일을 엽니다.
- **터미널 위 답변 힌트 제거.** 에이전트 질문 위에 표시되던 답변 버튼을 없애 Claude가 보여 주는 내용을 더 이상 가리지 않습니다.
- **수정: 앱 업데이트를 서버를 통해 내려받습니다.** 업데이트를 github.com 대신 ddagent 서버를 통해 가져오므로 휴대폰이 GitHub에 연결되지 않아도 작동합니다. 먼저 서버를 이 버전으로 업데이트하세요.
<!-- lang:ru -->
### Редактор в стиле VS Code на телефоне
- **Файлы открываются в полноэкранном редакторе.** На телефоне нажатие на файл в разделе «Файлы» открывает его в редакторе с вкладками открытых файлов. «Назад» возвращает к дереву.
- **Выдвижной проводник.** В редакторе дерево файлов выезжает слева, как Ctrl+B в VS Code. Оно скрывается после выбора файла, а значок панели на панели инструментов открывает его снова.
- **Панель инструментов, которая помещается.** На телефоне на панели остаются путь, поиск и «Сохранить». Предпросмотр, diff, перезагрузка, скачивание и «Сохранить все» — в меню «⋮». Мини-карта скрыта на узких экранах, и код занимает всю ширину.
- **Перейти к файлу.** Значок лупы или Ctrl+P ищет файл по имени, как в VS Code: «mdart» найдёт `main.dart`. Enter открывает лучшее совпадение.
- **Больше никаких подсказок ответов поверх терминала.** Кнопки ответов над вопросами агента убраны и больше не закрывают то, что показывает Claude.
- **Исправление: обновления приложения скачиваются через ваш сервер.** Обновление загружается через сервер ddagent, а не с github.com, поэтому работает, даже если телефон не может подключиться к GitHub. Сначала обновите сервер до этой версии.
<!-- lang:tr -->
### Telefonda VS Code tarzı bir düzenleyici
- **Dosyalar tam ekran düzenleyicide açılır.** Telefonda Dosyalar'da bir dosyaya dokunmak onu açık dosyaların sekmeleriyle düzenleyicide açar. Geri, ağaca döner.
- **Kayan gezgin.** Düzenleyicide dosya ağacı, VS Code'daki Ctrl+B gibi soldan kayarak açılır. Bir dosya seçince gizlenir; araç çubuğundaki panel simgesi onu geri getirir.
- **Ekrana sığan bir araç çubuğu.** Telefonda araç çubuğunda yol, arama ve Kaydet kalır. Önizleme, diff, yeniden yükle, indir ve "Tümünü kaydet" "⋮" menüsündedir. Dar ekranlarda mini harita gizlenir, böylece kod tüm genişliği kullanır.
- **Dosyaya git.** Büyüteç simgesi veya Ctrl+P, VS Code'daki gibi bir dosyayı adıyla bulur: "mdart" `main.dart` dosyasını bulur. Enter en iyi eşleşmeyi açar.
- **Terminalin üstünde artık yanıt ipuçları yok.** Ajanın sorularının üstündeki yanıt düğmeleri kaldırıldı; artık Claude'un gösterdiklerini kapatmıyor.
- **Düzeltme: uygulama güncellemeleri sunucunuz üzerinden iner.** Güncelleme github.com yerine ddagent sunucusu üzerinden alınır, bu yüzden telefon GitHub'a erişemese de çalışır. Önce sunucuyu bu sürüme güncelleyin.
<!-- lang:zh-CN -->
### 手机上的 VS Code 风格编辑器
- **文件在全屏编辑器中打开。** 在手机上，于“文件”中点按文件即可在编辑器中打开，并以标签页显示已打开的文件。返回键回到文件树。
- **滑出式资源管理器。** 在编辑器中，文件树像 VS Code 的 Ctrl+B 一样从左侧滑出。选择文件后自动隐藏，点工具栏上的面板图标可再次打开。
- **放得下的工具栏。** 手机工具栏只保留路径、搜索和保存。预览、差异、重新加载、下载和“全部保存”都在“⋮”菜单中。窄屏上隐藏小地图，让代码占满整个宽度。
- **转到文件。** 放大镜图标或 Ctrl+P 可像 VS Code 一样按名称查找文件：输入“mdart”即可找到 `main.dart`。按 Enter 打开最佳匹配。
- **终端上方不再显示回答提示。** 代理提问上方的回答按钮已移除，不再遮挡 Claude 显示的内容。
- **修复：应用更新通过你的服务器下载。** 更新改为经由 ddagent 服务器获取而非 github.com，因此即使手机无法访问 GitHub 也能更新。请先将服务器更新到此版本。
<!-- lang:zh-TW -->
### 手機上的 VS Code 風格編輯器
- **檔案在全螢幕編輯器中開啟。** 在手機上，於「檔案」中點選檔案即可在編輯器中開啟，並以分頁顯示已開啟的檔案。返回鍵回到檔案樹。
- **滑出式檔案總管。** 在編輯器中，檔案樹會像 VS Code 的 Ctrl+B 一樣從左側滑出。選擇檔案後自動隱藏，點工具列上的面板圖示可再次開啟。
- **放得下的工具列。** 手機工具列只保留路徑、搜尋和儲存。預覽、差異、重新載入、下載和「全部儲存」都在「⋮」選單中。窄螢幕上隱藏小地圖，讓程式碼佔滿整個寬度。
- **前往檔案。** 放大鏡圖示或 Ctrl+P 可像 VS Code 一樣依名稱尋找檔案：輸入「mdart」即可找到 `main.dart`。按 Enter 開啟最佳結果。
- **終端機上方不再顯示回答提示。** 代理提問上方的回答按鈕已移除，不再遮住 Claude 顯示的內容。
- **修正：應用程式更新透過你的伺服器下載。** 更新改為經由 ddagent 伺服器取得而非 github.com，因此即使手機無法連上 GitHub 也能更新。請先將伺服器更新到此版本。
