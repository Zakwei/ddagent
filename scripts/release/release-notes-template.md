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
### Terminal: sessions stay in sync across devices
- **No more switching tabs to refresh a session.** The device you are looking at now takes over the terminal size as soon as you open the tab, bring the window or app to the front, or tap it. Before, a session last used on another device (e.g. the phone) looked garbled, frozen or ignored clicks until you switched tabs.
- **Agent screens no longer break apart.** Fixed the terminal emulator: text landing one row too low after a full line, accented and zero-width characters shifting a line, wide characters at the edge, and some colour/underline codes. A malformed sequence no longer freezes the screen until the next output.
- **Reconnects:** after a server restart terminals keep their history; a phone that was offline sees the final output and the exit instead of running the command again; "Connect" after a start error works; a dropped connection shows as "Connecting…".
- **Clicks and keys:** links in terminal output open on click again, a slow tap on Android opens the keyboard, mouse clicks hit the right row with history above, Ctrl/Shift armed on the key bar is no longer lost, and a bell from an agent marks the tab on every device.
<!-- lang:pl -->
### Terminal: sesje zgodne na wszystkich urządzeniach
- **Koniec z przełączaniem kart, żeby odświeżyć sesję.** Urządzenie, na które patrzysz, przejmuje rozmiar terminala, gdy otwierasz kartę, wracasz do okna lub aplikacji albo dotykasz terminala. Wcześniej sesja używana ostatnio na innym urządzeniu (np. telefonie) była rozjechana, zamrożona albo nie reagowała na kliknięcia, dopóki nie zmieniłeś karty.
- **Ekrany agentów już się nie rozjeżdżają.** Poprawiony emulator terminala: tekst lądujący wiersz za nisko po pełnej linii, znaki z akcentami i znaki zerowej szerokości przesuwające linię, szerokie znaki przy krawędzi oraz część kodów kolorów i podkreśleń. Błędna sekwencja nie zamraża już ekranu do następnego outputu.
- **Ponowne łączenie:** po restarcie serwera terminale zachowują historię; telefon, który był offline, widzi ostatni output i zakończenie zamiast ponownie uruchamiać komendę; „Połącz” po błędzie startu działa; zerwane połączenie pokazuje „Łączenie…”.
- **Kliknięcia i klawisze:** linki w outpucie znów otwierają się po kliknięciu, wolne dotknięcie na Androidzie otwiera klawiaturę, kliknięcia myszą trafiają w dobry wiersz przy historii nad ekranem, Ctrl/Shift uzbrojony na pasku klawiszy już nie znika, a dzwonek agenta zaznacza kartę na każdym urządzeniu.
<!-- lang:de -->
### Terminal: Sitzungen auf allen Geräten synchron
- **Kein Tab-Wechsel mehr, um eine Sitzung aufzufrischen.** Das Gerät, das du gerade ansiehst, übernimmt die Terminalgröße, sobald du den Tab öffnest, Fenster oder App in den Vordergrund holst oder tippst. Vorher wirkte eine zuletzt auf einem anderen Gerät (z. B. dem Handy) genutzte Sitzung verzerrt, eingefroren oder ignorierte Klicks, bis du den Tab gewechselt hast.
- **Agent-Bildschirme zerfallen nicht mehr.** Der Terminal-Emulator wurde korrigiert: Text eine Zeile zu tief nach einer vollen Zeile, Akzente und Zeichen ohne Breite, die eine Zeile verschieben, breite Zeichen am Rand sowie einige Farb- und Unterstreichungscodes. Eine fehlerhafte Sequenz friert den Bildschirm nicht mehr bis zur nächsten Ausgabe ein.
- **Wiederverbinden:** Nach einem Server-Neustart behalten Terminals ihren Verlauf; ein Handy, das offline war, sieht die letzte Ausgabe und das Ende, statt den Befehl erneut auszuführen; „Verbinden“ nach einem Startfehler funktioniert; eine abgebrochene Verbindung zeigt „Verbinde…“.
- **Klicks und Tasten:** Links in der Ausgabe öffnen sich wieder per Klick, ein langsames Tippen unter Android öffnet die Tastatur, Mausklicks treffen bei Verlauf oberhalb die richtige Zeile, auf der Tastenleiste gesetztes Strg/Umschalt geht nicht mehr verloren, und eine Glocke des Agenten markiert den Tab auf jedem Gerät.
<!-- lang:es -->
### Terminal: sesiones sincronizadas en todos los dispositivos
- **Ya no hace falta cambiar de pestaña para refrescar una sesión.** El dispositivo que estás mirando toma el tamaño del terminal al abrir la pestaña, traer la ventana o la app al frente o tocarla. Antes, una sesión usada por última vez en otro dispositivo (p. ej. el teléfono) se veía descolocada, congelada o ignoraba los clics hasta cambiar de pestaña.
- **Las pantallas de los agentes ya no se descomponen.** Corregido el emulador de terminal: texto una fila más abajo tras una línea completa, acentos y caracteres de ancho cero que desplazaban la línea, caracteres anchos en el borde y algunos códigos de color y subrayado. Una secuencia mal formada ya no congela la pantalla hasta la siguiente salida.
- **Reconexiones:** tras reiniciar el servidor los terminales conservan su historial; un teléfono que estuvo sin conexión ve la salida final y el cierre en lugar de volver a ejecutar el comando; «Conectar» tras un error de inicio funciona; una conexión caída se muestra como «Conectando…».
- **Clics y teclas:** los enlaces de la salida vuelven a abrirse con un clic, un toque lento en Android abre el teclado, los clics del ratón aciertan la fila con historial encima, Ctrl/Mayús activados en la barra de teclas ya no se pierden y la campana de un agente marca la pestaña en todos los dispositivos.
<!-- lang:fr -->
### Terminal : sessions synchronisées sur tous les appareils
- **Plus besoin de changer d'onglet pour rafraîchir une session.** L'appareil que vous regardez prend la taille du terminal dès que vous ouvrez l'onglet, ramenez la fenêtre ou l'app au premier plan, ou touchez le terminal. Avant, une session utilisée en dernier sur un autre appareil (p. ex. le téléphone) paraissait déformée, figée ou ignorait les clics jusqu'au changement d'onglet.
- **Les écrans des agents ne se désagrègent plus.** Émulateur de terminal corrigé : texte une ligne trop bas après une ligne pleine, accents et caractères de largeur nulle décalant la ligne, caractères larges en bord d'écran et certains codes de couleur et de soulignement. Une séquence malformée ne fige plus l'écran jusqu'à la sortie suivante.
- **Reconnexions :** après un redémarrage du serveur, les terminaux gardent leur historique ; un téléphone resté hors ligne voit la dernière sortie et la fin au lieu de relancer la commande ; « Connecter » après une erreur de démarrage fonctionne ; une connexion perdue s'affiche « Connexion… ».
- **Clics et touches :** les liens de la sortie s'ouvrent de nouveau au clic, un toucher lent sur Android ouvre le clavier, les clics de souris visent la bonne ligne avec de l'historique au-dessus, Ctrl/Maj armés sur la barre de touches ne se perdent plus et la cloche d'un agent marque l'onglet sur chaque appareil.
<!-- lang:it -->
### Terminale: sessioni allineate su tutti i dispositivi
- **Non serve più cambiare scheda per aggiornare una sessione.** Il dispositivo che stai guardando prende la dimensione del terminale quando apri la scheda, riporti in primo piano la finestra o l'app o lo tocchi. Prima, una sessione usata per ultima su un altro dispositivo (ad es. il telefono) appariva scomposta, bloccata o ignorava i clic finché non cambiavi scheda.
- **Le schermate degli agenti non si scompongono più.** Corretto l'emulatore di terminale: testo una riga più in basso dopo una riga piena, accenti e caratteri a larghezza zero che spostavano la riga, caratteri larghi sul bordo e alcuni codici di colore e sottolineatura. Una sequenza malformata non blocca più lo schermo fino all'output successivo.
- **Riconnessioni:** dopo un riavvio del server i terminali conservano la cronologia; un telefono rimasto offline vede l'ultimo output e la chiusura invece di rieseguire il comando; «Connetti» dopo un errore di avvio funziona; una connessione caduta mostra «Connessione…».
- **Clic e tasti:** i link nell'output si aprono di nuovo con un clic, un tocco lento su Android apre la tastiera, i clic del mouse colpiscono la riga giusta con cronologia sopra, Ctrl/Maiusc attivati sulla barra dei tasti non si perdono più e il campanello di un agente segna la scheda su ogni dispositivo.
<!-- lang:ja -->
### ターミナル: すべてのデバイスでセッションを同期
- **セッションを更新するためにタブを切り替える必要はなくなりました。** タブを開く、ウィンドウやアプリを前面に戻す、ターミナルをタップすると、見ているデバイスがターミナルのサイズを引き継ぎます。これまでは別のデバイス (スマートフォンなど) で最後に使ったセッションが、タブを切り替えるまで崩れたり固まったり、クリックに反応しなかったりしました。
- **エージェントの画面が崩れなくなりました。** ターミナルエミュレーターを修正しました: 行いっぱいの後に文字が 1 行下にずれる問題、アクセント記号やゼロ幅文字による行のずれ、端の全角文字、一部の色・下線コード。不正なシーケンスで次の出力まで画面が固まることもなくなりました。
- **再接続:** サーバー再起動後もターミナルの履歴が残ります。オフラインだったスマートフォンはコマンドを再実行せず、最後の出力と終了を表示します。起動エラー後の「接続」が機能し、切断された接続は「接続中…」と表示されます。
- **クリックとキー:** 出力内のリンクが再びクリックで開き、Android でゆっくりタップするとキーボードが開き、上に履歴があってもマウスクリックが正しい行に届き、キーバーで有効にした Ctrl/Shift が消えなくなり、エージェントのベルがすべてのデバイスでタブに表示されます。
<!-- lang:ko -->
### 터미널: 모든 기기에서 세션 동기화
- **세션을 새로 고치려고 탭을 바꿀 필요가 없습니다.** 탭을 열거나, 창이나 앱을 앞으로 가져오거나, 터미널을 탭하면 보고 있는 기기가 터미널 크기를 가져옵니다. 이전에는 다른 기기(예: 휴대폰)에서 마지막으로 쓴 세션이 탭을 바꿀 때까지 깨져 보이거나 멈추거나 클릭에 반응하지 않았습니다.
- **에이전트 화면이 더 이상 깨지지 않습니다.** 터미널 에뮬레이터를 고쳤습니다: 꽉 찬 줄 다음 텍스트가 한 줄 아래로 밀리는 문제, 악센트와 폭 0 문자로 줄이 밀리는 문제, 가장자리의 넓은 문자, 일부 색상·밑줄 코드. 잘못된 시퀀스가 다음 출력까지 화면을 멈추게 하지 않습니다.
- **재연결:** 서버 재시작 후에도 터미널 기록이 유지되고, 오프라인이던 휴대폰은 명령을 다시 실행하지 않고 마지막 출력과 종료를 보여 줍니다. 시작 오류 후 “연결”이 작동하며, 끊긴 연결은 “연결 중…”으로 표시됩니다.
- **클릭과 키:** 출력의 링크가 다시 클릭으로 열리고, Android에서 천천히 탭하면 키보드가 열리며, 위에 기록이 있어도 마우스 클릭이 올바른 줄에 닿고, 키 바에서 켠 Ctrl/Shift가 사라지지 않으며, 에이전트의 벨이 모든 기기에서 탭에 표시됩니다.
<!-- lang:ru -->
### Терминал: сессии согласованы на всех устройствах
- **Больше не нужно переключать вкладки, чтобы обновить сессию.** Устройство, на которое вы смотрите, берёт размер терминала, когда вы открываете вкладку, возвращаетесь к окну или приложению или касаетесь терминала. Раньше сессия, которой последний раз пользовались на другом устройстве (например, телефоне), выглядела искажённой, зависшей или не реагировала на клики, пока не переключишь вкладку.
- **Экраны агентов больше не разваливаются.** Исправлен эмулятор терминала: текст на строку ниже после заполненной строки, сдвиг строки из-за диакритики и символов нулевой ширины, широкие символы у края и некоторые коды цвета и подчёркивания. Ошибочная последовательность больше не замораживает экран до следующего вывода.
- **Переподключение:** после перезапуска сервера терминалы сохраняют историю; телефон, который был офлайн, видит последний вывод и завершение, а не запускает команду повторно; «Подключить» после ошибки запуска работает; разорванное соединение показывается как «Подключение…».
- **Клики и клавиши:** ссылки в выводе снова открываются по клику, медленное касание на Android открывает клавиатуру, клики мышью попадают в нужную строку при истории сверху, Ctrl/Shift, включённые на панели клавиш, больше не сбрасываются, а сигнал агента отмечает вкладку на каждом устройстве.
<!-- lang:tr -->
### Terminal: oturumlar tüm cihazlarda uyumlu
- **Bir oturumu yenilemek için artık sekme değiştirmeniz gerekmiyor.** Sekmeyi açtığınızda, pencereyi veya uygulamayı öne getirdiğinizde ya da terminale dokunduğunuzda baktığınız cihaz terminal boyutunu devralır. Önceden başka bir cihazda (ör. telefonda) en son kullanılan oturum, sekme değiştirene kadar bozuk, donmuş görünüyor veya tıklamalara yanıt vermiyordu.
- **Ajan ekranları artık dağılmıyor.** Terminal öykünücüsü düzeltildi: dolu bir satırdan sonra metnin bir satır aşağı kayması, aksanlı ve sıfır genişlikli karakterlerin satırı kaydırması, kenardaki geniş karakterler ve bazı renk/altı çizgi kodları. Hatalı bir dizi artık ekranı bir sonraki çıktıya kadar dondurmuyor.
- **Yeniden bağlanma:** sunucu yeniden başlatıldıktan sonra terminaller geçmişini korur; çevrimdışı kalan bir telefon komutu yeniden çalıştırmak yerine son çıktıyı ve sonlanmayı görür; başlatma hatasından sonra “Bağlan” çalışır; kopan bağlantı “Bağlanılıyor…” olarak gösterilir.
- **Tıklamalar ve tuşlar:** çıktıdaki bağlantılar yeniden tıklamayla açılır, Android'de yavaş bir dokunuş klavyeyi açar, üstte geçmiş varken fare tıklamaları doğru satıra gider, tuş çubuğunda etkinleştirilen Ctrl/Shift artık kaybolmaz ve bir ajanın zili sekmeyi her cihazda işaretler.
<!-- lang:zh-CN -->
### 终端:会话在所有设备上保持同步
- **不再需要切换标签页来刷新会话。** 打开标签页、将窗口或应用切回前台或轻点终端时,你正在看的设备会接管终端尺寸。此前,在另一台设备(如手机)上最后使用的会话会显示错乱、卡住或不响应点击,直到切换标签页。
- **智能体的界面不再错乱。** 修复了终端模拟器:整行写满后文字下移一行、重音符号和零宽字符导致整行偏移、边缘处的宽字符,以及部分颜色和下划线代码。格式错误的序列不再让屏幕卡住直到下一次输出。
- **重新连接:** 服务器重启后终端保留历史;曾离线的手机会看到最后的输出和退出信息,而不是重新运行命令;启动出错后的“连接”可用;断开的连接显示为“正在连接…”。
- **点击与按键:** 输出中的链接再次可点击打开,在 Android 上慢速轻点可打开键盘,上方有历史时鼠标点击能命中正确的行,在按键栏上启用的 Ctrl/Shift 不再丢失,智能体的提示铃会在每台设备上标记标签页。
<!-- lang:zh-TW -->
### 終端機:工作階段在所有裝置上保持同步
- **不必再切換分頁來重新整理工作階段。** 開啟分頁、將視窗或應用程式切回前景或輕點終端機時,你正在看的裝置會接管終端機尺寸。先前,在另一台裝置(如手機)上最後使用的工作階段會顯示錯亂、卡住或不回應點擊,直到切換分頁。
- **代理程式的畫面不再錯亂。** 修正了終端機模擬器:整行寫滿後文字下移一行、重音符號與零寬字元造成整行偏移、邊緣的全形字元,以及部分顏色與底線代碼。格式錯誤的序列不再讓畫面卡住直到下一次輸出。
- **重新連線:** 伺服器重新啟動後終端機保留歷史;曾離線的手機會看到最後的輸出與結束訊息,而不是重新執行指令;啟動錯誤後的「連線」可用;中斷的連線顯示為「正在連線…」。
- **點擊與按鍵:** 輸出中的連結再次可點擊開啟,在 Android 上慢速輕點可開啟鍵盤,上方有歷史時滑鼠點擊能命中正確的行,在按鍵列上啟用的 Ctrl/Shift 不再遺失,代理程式的提示鈴會在每台裝置上標記分頁。
