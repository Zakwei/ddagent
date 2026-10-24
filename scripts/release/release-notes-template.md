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
- **Terminal scrolling in Claude Code**: the mouse wheel and a finger drag now reach a program that tracks the mouse even when the pane still has its own scrollback behind it (a Claude Code session reattached after a server restart). Shift+wheel scrolls the pane's own history instead. Wheel reports also name the cell under the pointer; in a right-hand pane they used to land on the last column and several rows down.
- **Mouse selection in Claude Code**: a mouse drag is reported to the program as press, motion and release, like in a desktop terminal. Claude Code selects the transcript text itself and copies it to the clipboard; before, it only saw a press that never ended and the selection landed a few lines off. A finger tap reports its press and release together, so scrolling with a finger never leaves a press hanging.
<!-- lang:pl -->
### Poprawki
- **Przewijanie terminala w Claude Code**: kółko myszy i przeciągnięcie palcem docierają teraz do programu śledzącego mysz także wtedy, gdy panel ma za nim własną historię (sesja Claude Code podpięta ponownie po restarcie serwera). Shift+kółko przewija historię panelu. Raporty kółka wskazują też komórkę pod kursorem; w prawym panelu trafiały na ostatnią kolumnę i kilka wierszy niżej.
- **Zaznaczanie myszą w Claude Code**: przeciągnięcie myszą jest raportowane programowi jako naciśnięcie, ruch i zwolnienie, jak w terminalu na komputerze. Claude Code sam zaznacza tekst rozmowy i kopiuje go do schowka; wcześniej widział tylko naciśnięcie bez końca, a zaznaczenie lądowało kilka linii obok. Dotknięcie palcem raportuje naciśnięcie razem ze zwolnieniem, więc przewijanie palcem nie zostawia „wiszącego” naciśnięcia.
<!-- lang:de -->
### Fehlerbehebungen
- **Terminal-Scrollen in Claude Code**: Mausrad und Fingerwischen erreichen jetzt ein Programm mit Mausverfolgung auch dann, wenn der Bereich dahinter noch einen eigenen Verlauf hat (eine nach einem Server-Neustart wieder angebundene Claude-Code-Sitzung). Umschalt+Mausrad scrollt stattdessen den Verlauf des Bereichs. Radmeldungen nennen jetzt die Zelle unter dem Zeiger; in einem rechten Bereich landeten sie in der letzten Spalte und einige Zeilen tiefer.
- **Mausauswahl in Claude Code**: Ziehen mit der Maus wird dem Programm als Drücken, Bewegen und Loslassen gemeldet, wie in einem Desktop-Terminal. Claude Code markiert den Text selbst und kopiert ihn in die Zwischenablage; vorher sah es nur ein Drücken ohne Ende, und die Auswahl lag einige Zeilen daneben. Ein Fingertipp meldet Drücken und Loslassen zusammen, sodass Scrollen mit dem Finger kein offenes Drücken hinterlässt.
<!-- lang:es -->
### Correcciones
- **Desplazamiento del terminal en Claude Code**: la rueda del ratón y el arrastre con el dedo llegan ahora a un programa que sigue el ratón aunque el panel aún tenga su propio historial detrás (una sesión de Claude Code reconectada tras reiniciar el servidor). Mayús+rueda desplaza el historial del panel. Los informes de la rueda indican además la celda bajo el puntero; en un panel derecho caían en la última columna y varias filas más abajo.
- **Selección con el ratón en Claude Code**: arrastrar con el ratón se comunica al programa como pulsar, mover y soltar, como en un terminal de escritorio. Claude Code selecciona el texto él mismo y lo copia al portapapeles; antes solo veía una pulsación sin fin y la selección caía unas líneas más abajo. Un toque con el dedo comunica la pulsación junto con la liberación, así que desplazar con el dedo no deja una pulsación pendiente.
<!-- lang:fr -->
### Corrections
- **Défilement du terminal dans Claude Code** : la molette et le glissement du doigt atteignent désormais un programme qui suit la souris même si le panneau garde son propre historique derrière lui (une session Claude Code rattachée après un redémarrage du serveur). Maj+molette fait défiler l'historique du panneau. Les rapports de molette indiquent aussi la cellule sous le pointeur ; dans un panneau de droite ils tombaient sur la dernière colonne, quelques lignes plus bas.
- **Sélection à la souris dans Claude Code** : un glissement de souris est transmis au programme comme appui, déplacement et relâchement, comme dans un terminal de bureau. Claude Code sélectionne lui-même le texte et le copie dans le presse-papiers ; avant, il ne voyait qu'un appui sans fin et la sélection tombait quelques lignes à côté. Un appui du doigt transmet l'appui et le relâchement ensemble, donc faire défiler au doigt ne laisse plus d'appui en suspens.
<!-- lang:it -->
### Correzioni
- **Scorrimento del terminale in Claude Code**: la rotellina e il trascinamento con il dito raggiungono ora un programma che segue il mouse anche quando il pannello ha ancora la propria cronologia dietro (una sessione Claude Code riagganciata dopo un riavvio del server). Maiusc+rotellina scorre la cronologia del pannello. Le segnalazioni della rotellina indicano inoltre la cella sotto il puntatore; in un pannello di destra finivano nell'ultima colonna, alcune righe più in basso.
- **Selezione con il mouse in Claude Code**: un trascinamento con il mouse viene segnalato al programma come pressione, movimento e rilascio, come in un terminale desktop. Claude Code seleziona il testo da sé e lo copia negli appunti; prima vedeva solo una pressione senza fine e la selezione finiva qualche riga più sotto. Un tocco con il dito segnala pressione e rilascio insieme, così lo scorrimento con il dito non lascia pressioni in sospeso.
<!-- lang:ja -->
### 修正
- **Claude Code でのターミナルのスクロール**：マウスホイールと指のドラッグが、ペインの背後に独自のスクロールバックが残っている場合（サーバー再起動後に再接続した Claude Code セッション）でも、マウスを追跡するプログラムに届くようになりました。Shift+ホイールでペイン自身の履歴をスクロールします。ホイールの通知はポインター直下のセルを示すようになり、右側のペインで最終列・数行下にずれる問題も解消しました。
- **Claude Code でのマウス選択**：マウスのドラッグは、デスクトップのターミナルと同様に、押下・移動・解放としてプログラムへ通知されます。Claude Code が自分でトランスクリプトを選択してクリップボードへコピーします。以前は終わりのない押下しか届かず、選択が数行ずれていました。指のタップは押下と解放をまとめて通知するため、指でスクロールしても押下が残りません。
<!-- lang:ko -->
### 수정
- **Claude Code에서 터미널 스크롤**: 창 뒤에 자체 스크롤백이 남아 있어도(서버 재시작 후 다시 연결된 Claude Code 세션) 마우스 휠과 손가락 드래그가 마우스를 추적하는 프로그램에 전달됩니다. Shift+휠은 창 자체의 기록을 스크롤합니다. 휠 보고는 포인터 아래의 셀을 가리키며, 오른쪽 창에서 마지막 열과 몇 줄 아래로 어긋나던 문제가 해결되었습니다.
- **Claude Code에서 마우스 선택**: 마우스 드래그가 데스크톱 터미널처럼 누름·이동·놓음으로 프로그램에 보고됩니다. Claude Code가 직접 대화 텍스트를 선택해 클립보드에 복사합니다. 이전에는 끝나지 않는 누름만 전달되어 선택이 몇 줄 어긋났습니다. 손가락 탭은 누름과 놓음을 함께 보고하므로 손가락 스크롤이 누름을 남기지 않습니다.
<!-- lang:ru -->
### Исправления
- **Прокрутка терминала в Claude Code**: колесо мыши и перетаскивание пальцем теперь доходят до программы, отслеживающей мышь, даже если за панелью остаётся её собственная история (сессия Claude Code, переподключённая после перезапуска сервера). Shift+колесо прокручивает историю панели. Отчёты колеса указывают ячейку под указателем; в правой панели они попадали в последний столбец на несколько строк ниже.
- **Выделение мышью в Claude Code**: перетаскивание мышью передаётся программе как нажатие, движение и отпускание, как в настольном терминале. Claude Code сам выделяет текст и копирует его в буфер обмена; раньше он видел лишь нажатие без конца, и выделение оказывалось на несколько строк ниже. Касание пальцем передаёт нажатие вместе с отпусканием, поэтому прокрутка пальцем не оставляет «висящего» нажатия.
<!-- lang:tr -->
### Düzeltmeler
- **Claude Code'da terminal kaydırma**: fare tekerleği ve parmakla sürükleme, bölmenin arkasında hâlâ kendi geçmişi olsa bile (sunucu yeniden başlatıldıktan sonra yeniden bağlanan bir Claude Code oturumu) fareyi izleyen programa ulaşıyor. Shift+tekerlek bölmenin kendi geçmişini kaydırır. Tekerlek bildirimleri artık imlecin altındaki hücreyi gösteriyor; sağdaki bölmede son sütuna ve birkaç satır aşağıya düşüyordu.
- **Claude Code'da fareyle seçim**: fareyle sürükleme, masaüstü terminalinde olduğu gibi programa basma, hareket ve bırakma olarak bildiriliyor. Claude Code metni kendisi seçip panoya kopyalıyor; önceden yalnızca hiç bitmeyen bir basma görüyor ve seçim birkaç satır kayıyordu. Parmak dokunuşu basma ile bırakmayı birlikte bildirdiğinden parmakla kaydırma askıda basma bırakmıyor.
<!-- lang:zh-CN -->
### 修复
- **Claude Code 中的终端滚动**：即使面板后面仍保留自己的回滚历史（服务器重启后重新连接的 Claude Code 会话），鼠标滚轮和手指拖动现在也能送达跟踪鼠标的程序。Shift+滚轮改为滚动面板自身的历史。滚轮上报现在指向指针下方的单元格；此前在右侧面板中会落到最后一列并向下偏移几行。
- **Claude Code 中的鼠标选择**：鼠标拖动会像桌面终端一样以按下、移动、释放上报给程序。Claude Code 自行选中对话文本并复制到剪贴板；此前它只收到一个永不结束的按下，选区会偏移几行。手指点按会同时上报按下和释放，因此手指滚动不会留下悬而未决的按下。
<!-- lang:zh-TW -->
### 修正
- **Claude Code 中的終端機捲動**：即使面板後方仍保留自己的回捲歷史（伺服器重新啟動後重新連線的 Claude Code 工作階段），滑鼠滾輪與手指拖曳現在也會送達追蹤滑鼠的程式。Shift+滾輪改為捲動面板本身的歷史。滾輪回報現在指向游標下方的儲存格；先前在右側面板會落在最後一欄並向下偏移數行。
- **Claude Code 中的滑鼠選取**：滑鼠拖曳會像桌面終端機一樣以按下、移動、放開回報給程式。Claude Code 會自行選取對話文字並複製到剪貼簿；先前它只收到一個永不結束的按下，選取範圍會偏移數行。手指點按會同時回報按下與放開，因此手指捲動不會留下懸而未決的按下。
