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
- **Server disk space**: Settings → About shows free space on the disks holding the app, its data and the workspaces, and a red banner warns on every screen when a disk drops below 10% or 5 GB free. A full disk used to stop the whole app without warning.
### Fixes
- **Videos in Files**: an .mp4 or other audio/video file opens as a media card with an "Open in new tab" button that plays it in the browser, instead of showing raw bytes as text. Binary files get an info card, so saving can no longer overwrite them with garbage.
<!-- lang:pl -->
### Nowości
- **Miejsce na dysku serwera**: Ustawienia → O aplikacji pokazują wolne miejsce na dyskach z aplikacją, jej danymi i workspace, a czerwony baner na każdym ekranie ostrzega, gdy na dysku zostaje mniej niż 10% lub 5 GB. Pełny dysk zatrzymywał wcześniej całą aplikację bez ostrzeżenia.
### Poprawki
- **Filmy w Plikach**: plik .mp4 lub inny plik audio/wideo otwiera się jako karta z przyciskiem „Otwórz w nowej karcie”, który odtwarza go w przeglądarce, zamiast pokazywać surowe bajty jako tekst. Pliki binarne dostają kartę informacyjną, więc zapis nie nadpisze ich już śmieciami.
<!-- lang:de -->
### Neu
- **Speicherplatz des Servers**: Einstellungen → Über zeigt den freien Speicher der Laufwerke mit der App, ihren Daten und den Arbeitsbereichen, und ein rotes Banner warnt auf jedem Bildschirm, wenn weniger als 10 % oder 5 GB frei sind. Eine volle Festplatte hat die ganze App bisher ohne Warnung angehalten.
### Fehlerbehebungen
- **Videos in Dateien**: Eine .mp4- oder andere Audio-/Videodatei öffnet sich als Medienkarte mit der Schaltfläche „In neuem Tab öffnen“, die sie im Browser abspielt, statt rohe Bytes als Text anzuzeigen. Binärdateien erhalten eine Infokarte, sodass Speichern sie nicht mehr mit Datenmüll überschreiben kann.
<!-- lang:es -->
### Novedades
- **Espacio en disco del servidor**: Ajustes → Acerca de muestra el espacio libre en los discos con la app, sus datos y los espacios de trabajo, y un banner rojo avisa en todas las pantallas cuando quedan menos del 10 % o 5 GB libres. Un disco lleno detenía toda la app sin aviso.
### Correcciones
- **Vídeos en Archivos**: un .mp4 u otro archivo de audio/vídeo se abre como tarjeta multimedia con el botón «Abrir en una pestaña nueva», que lo reproduce en el navegador, en lugar de mostrar bytes en bruto como texto. Los archivos binarios muestran una tarjeta informativa, así que guardar ya no puede sobrescribirlos con basura.
<!-- lang:fr -->
### Nouveautés
- **Espace disque du serveur** : Paramètres → À propos affiche l'espace libre des disques contenant l'application, ses données et les espaces de travail, et une bannière rouge avertit sur chaque écran quand il reste moins de 10 % ou 5 Go. Un disque plein arrêtait toute l'application sans prévenir.
### Corrections
- **Vidéos dans Fichiers** : un .mp4 ou un autre fichier audio/vidéo s'ouvre en carte média avec un bouton « Ouvrir dans un nouvel onglet » qui le lit dans le navigateur, au lieu d'afficher les octets bruts en texte. Les fichiers binaires ont une carte d'information : l'enregistrement ne peut plus les écraser avec des données illisibles.
<!-- lang:it -->
### Novità
- **Spazio su disco del server**: Impostazioni → Informazioni mostra lo spazio libero sui dischi con l'app, i suoi dati e i workspace, e un banner rosso avvisa in ogni schermata quando resta meno del 10% o di 5 GB. Un disco pieno fermava l'intera app senza preavviso.
### Correzioni
- **Video in File**: un .mp4 o un altro file audio/video si apre come scheda multimediale con il pulsante «Apri in una nuova scheda», che lo riproduce nel browser, invece di mostrare i byte grezzi come testo. I file binari mostrano una scheda informativa, quindi il salvataggio non può più sovrascriverli con dati illeggibili.
<!-- lang:ja -->
### 新機能
- **サーバーのディスク容量**：設定 → 概要に、アプリ・データ・ワークスペースがあるディスクの空き容量を表示します。空きが 10% または 5 GB を下回ると、すべての画面に赤いバナーで警告します。これまではディスクが満杯になると警告なしにアプリ全体が停止していました。
### 修正
- **ファイルでの動画**：.mp4 などの音声・動画ファイルは、生のバイトをテキスト表示する代わりに、ブラウザで再生する「新しいタブで開く」ボタン付きのメディアカードとして開きます。バイナリファイルには情報カードが表示され、保存で壊れたデータに上書きされることはなくなりました。
<!-- lang:ko -->
### 새 기능
- **서버 디스크 공간**: 설정 → 정보에서 앱, 데이터, 워크스페이스가 있는 디스크의 여유 공간을 보여 주며, 여유 공간이 10% 또는 5GB 미만이 되면 모든 화면에 빨간 배너로 경고합니다. 이전에는 디스크가 가득 차면 경고 없이 앱 전체가 멈췄습니다.
### 수정
- **파일의 동영상**: .mp4 등 오디오/동영상 파일은 원시 바이트를 텍스트로 보여 주는 대신 브라우저에서 재생하는 "새 탭에서 열기" 버튼이 있는 미디어 카드로 열립니다. 바이너리 파일은 정보 카드로 표시되어 저장 시 깨진 데이터로 덮어쓰지 않습니다.
<!-- lang:ru -->
### Новое
- **Место на диске сервера**: Настройки → О программе показывают свободное место на дисках с приложением, его данными и рабочими областями, а красный баннер на каждом экране предупреждает, когда свободно меньше 10% или 5 ГБ. Раньше заполненный диск останавливал всё приложение без предупреждения.
### Исправления
- **Видео в Файлах**: .mp4 или другой аудио-/видеофайл открывается карточкой с кнопкой «Открыть в новой вкладке», которая воспроизводит его в браузере, вместо показа сырых байтов как текста. Для двоичных файлов показывается информационная карточка, поэтому сохранение больше не перезапишет их мусором.
<!-- lang:tr -->
### Yenilikler
- **Sunucu disk alanı**: Ayarlar → Hakkında, uygulamanın, verilerinin ve çalışma alanlarının bulunduğu disklerdeki boş alanı gösteriyor; boş alan %10 veya 5 GB altına düştüğünde her ekranda kırmızı bir afiş uyarıyor. Dolu bir disk daha önce tüm uygulamayı uyarı vermeden durduruyordu.
### Düzeltmeler
- **Dosyalar'da videolar**: .mp4 veya başka bir ses/video dosyası, ham baytları metin olarak göstermek yerine tarayıcıda oynatan "Yeni sekmede aç" düğmeli bir medya kartı olarak açılıyor. İkili dosyalar bilgi kartı alıyor; kaydetme artık onların üzerine bozuk veri yazamıyor.
<!-- lang:zh-CN -->
### 新功能
- **服务器磁盘空间**：设置 → 关于 会显示存放应用、数据和工作区的磁盘的可用空间；当可用空间低于 10% 或 5 GB 时，每个页面都会出现红色横幅警告。此前磁盘写满会在毫无提示的情况下让整个应用停止工作。
### 修复
- **文件中的视频**：.mp4 等音视频文件会以媒体卡片打开，并提供在浏览器中播放的“在新标签页中打开”按钮，而不再把原始字节显示为文本。二进制文件改为显示信息卡片，保存时不会再用乱码覆盖它们。
<!-- lang:zh-TW -->
### 新功能
- **伺服器磁碟空間**：設定 → 關於 會顯示存放應用程式、資料與工作區的磁碟可用空間；可用空間低於 10% 或 5 GB 時，每個畫面都會出現紅色橫幅警告。先前磁碟寫滿會在毫無提示的情況下讓整個應用程式停止運作。
### 修正
- **檔案中的影片**：.mp4 等音訊/影片檔會以媒體卡片開啟，並提供在瀏覽器中播放的「在新分頁中開啟」按鈕，不再把原始位元組顯示為文字。二進位檔改為顯示資訊卡片，儲存時不會再以亂碼覆寫它們。
