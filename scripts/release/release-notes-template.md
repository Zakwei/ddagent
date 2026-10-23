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
### New
- **Shift on the terminal key bar**: the on-screen key bar has Shift instead of Alt. Shift+Tab switches Claude Code's mode, Shift+Enter inserts a newline, Shift with arrows/Home/End/PgUp/PgDn sends the shifted keys.
### Fixes
- **Clean terminal after a reload or a server restart**: a restored Claude Code session no longer shows words cut at the margin or overlapping status lines. The server makes the program redraw its whole screen when a device reattaches, and keeps the title and terminal modes through server restarts.
<!-- lang:pl -->
### Nowości
- **Shift na pasku klawiszy terminala**: pasek ekranowy ma Shift zamiast Alt. Shift+Tab przełącza tryb Claude Code, Shift+Enter wstawia nową linię, Shift ze strzałkami/Home/End/PgUp/PgDn wysyła klawisze z Shiftem.
### Poprawki
- **Czysty terminal po przeładowaniu lub restarcie serwera**: przywrócona sesja Claude Code nie pokazuje już słów pociętych na krawędzi ani nachodzących linii statusu. Serwer każe programowi przerysować cały ekran, gdy urządzenie się ponownie podłącza, i zachowuje tytuł oraz tryby terminala przez restarty serwera.
<!-- lang:de -->
### Neu
- **Shift in der Terminal-Tastenleiste**: Die Bildschirm-Tastenleiste hat Shift statt Alt. Shift+Tab wechselt den Modus von Claude Code, Shift+Enter fügt einen Zeilenumbruch ein, Shift mit Pfeilen/Pos1/Ende/Bild↑/Bild↓ sendet die Tasten mit Shift.
### Fehlerbehebungen
- **Sauberes Terminal nach Neuladen oder Server-Neustart**: Eine wiederhergestellte Claude-Code-Sitzung zeigt keine am Rand abgeschnittenen Wörter oder überlappenden Statuszeilen mehr. Der Server lässt das Programm beim erneuten Verbinden eines Geräts den ganzen Bildschirm neu zeichnen und behält Titel und Terminalmodi über Server-Neustarts hinweg.
<!-- lang:es -->
### Novedades
- **Shift en la barra de teclas del terminal**: la barra de teclas en pantalla tiene Shift en lugar de Alt. Shift+Tab cambia el modo de Claude Code, Shift+Enter inserta un salto de línea y Shift con flechas/Inicio/Fin/RePág/AvPág envía las teclas con Shift.
### Correcciones
- **Terminal limpio tras recargar o reiniciar el servidor**: una sesión restaurada de Claude Code ya no muestra palabras cortadas en el margen ni líneas de estado superpuestas. El servidor hace que el programa redibuje toda la pantalla cuando un dispositivo se reconecta y conserva el título y los modos del terminal tras los reinicios.
<!-- lang:fr -->
### Nouveautés
- **Shift dans la barre de touches du terminal** : la barre de touches à l'écran propose Shift au lieu d'Alt. Shift+Tab change le mode de Claude Code, Shift+Entrée insère un saut de ligne, Shift avec les flèches/Début/Fin/PgPréc/PgSuiv envoie les touches avec Shift.
### Corrections
- **Terminal propre après un rechargement ou un redémarrage du serveur** : une session Claude Code restaurée n'affiche plus de mots coupés en marge ni de lignes d'état superposées. Le serveur fait redessiner tout l'écran au programme quand un appareil se reconnecte et conserve le titre et les modes du terminal lors des redémarrages.
<!-- lang:it -->
### Novità
- **Shift nella barra dei tasti del terminale**: la barra dei tasti a schermo ha Shift al posto di Alt. Shift+Tab cambia la modalità di Claude Code, Shift+Invio inserisce un a capo, Shift con frecce/Home/Fine/PagSu/PagGiù invia i tasti con Shift.
### Correzioni
- **Terminale pulito dopo un ricaricamento o un riavvio del server**: una sessione di Claude Code ripristinata non mostra più parole tagliate al margine né righe di stato sovrapposte. Il server fa ridisegnare l'intero schermo al programma quando un dispositivo si ricollega e mantiene titolo e modalità del terminale tra i riavvii.
<!-- lang:ja -->
### 新機能
- **ターミナルのキーバーに Shift**：画面上のキーバーが Alt の代わりに Shift になりました。Shift+Tab で Claude Code のモードを切り替え、Shift+Enter で改行を挿入し、矢印/Home/End/PgUp/PgDn と組み合わせると Shift 付きのキーを送信します。
### 修正
- **再読み込みやサーバー再起動後もきれいなターミナル**：復元した Claude Code セッションで、端で切れた単語や重なったステータス行が表示されなくなりました。デバイスが再接続するとサーバーがプログラムに画面全体を再描画させ、サーバー再起動後もタイトルとターミナルモードを保持します。
<!-- lang:ko -->
### 새 기능
- **터미널 키 바의 Shift**: 화면 키 바에 Alt 대신 Shift가 있습니다. Shift+Tab으로 Claude Code 모드를 바꾸고, Shift+Enter로 줄을 바꾸며, 화살표/Home/End/PgUp/PgDn과 함께 누르면 Shift가 적용된 키를 보냅니다.
### 수정
- **새로고침이나 서버 재시작 후에도 깨끗한 터미널**: 복원된 Claude Code 세션에서 가장자리에서 잘린 단어나 겹친 상태 줄이 더 이상 보이지 않습니다. 기기가 다시 연결되면 서버가 프로그램에 전체 화면을 다시 그리게 하고, 서버를 재시작해도 제목과 터미널 모드를 유지합니다.
<!-- lang:ru -->
### Новое
- **Shift на панели клавиш терминала**: на экранной панели клавиш теперь Shift вместо Alt. Shift+Tab переключает режим Claude Code, Shift+Enter вставляет перевод строки, Shift со стрелками/Home/End/PgUp/PgDn отправляет клавиши с Shift.
### Исправления
- **Чистый терминал после перезагрузки страницы или перезапуска сервера**: восстановленный сеанс Claude Code больше не показывает слова, обрезанные у края, и наложенные строки состояния. Сервер заставляет программу перерисовать весь экран при повторном подключении устройства и сохраняет заголовок и режимы терминала при перезапусках.
<!-- lang:tr -->
### Yenilikler
- **Terminal tuş çubuğunda Shift**: ekran tuş çubuğunda Alt yerine Shift var. Shift+Tab Claude Code modunu değiştirir, Shift+Enter yeni satır ekler, oklar/Home/End/PgUp/PgDn ile Shift'li tuşları gönderir.
### Düzeltmeler
- **Yeniden yükleme veya sunucu yeniden başlatıldıktan sonra temiz terminal**: geri yüklenen Claude Code oturumunda kenarda kesilmiş kelimeler veya üst üste binen durum satırları artık görünmüyor. Bir cihaz yeniden bağlandığında sunucu programın tüm ekranı yeniden çizmesini sağlıyor; başlık ve terminal modları yeniden başlatmalarda korunuyor.
<!-- lang:zh-CN -->
### 新功能
- **终端按键栏中的 Shift**：屏幕按键栏用 Shift 替换了 Alt。Shift+Tab 切换 Claude Code 模式，Shift+Enter 插入换行，Shift 配合方向键/Home/End/PgUp/PgDn 发送带 Shift 的按键。
### 修复
- **重新加载或服务器重启后终端保持整洁**：恢复的 Claude Code 会话不再出现边缘被截断的单词或重叠的状态行。设备重新连接时服务器会让程序重绘整个屏幕，并在服务器重启后保留标题和终端模式。
<!-- lang:zh-TW -->
### 新功能
- **終端機按鍵列中的 Shift**：螢幕按鍵列以 Shift 取代了 Alt。Shift+Tab 切換 Claude Code 模式，Shift+Enter 插入換行，Shift 搭配方向鍵/Home/End/PgUp/PgDn 傳送帶 Shift 的按鍵。
### 修正
- **重新載入或伺服器重新啟動後終端機保持整潔**：還原的 Claude Code 工作階段不再出現邊緣被截斷的字詞或重疊的狀態列。裝置重新連線時伺服器會讓程式重繪整個畫面，並在伺服器重新啟動後保留標題和終端機模式。
