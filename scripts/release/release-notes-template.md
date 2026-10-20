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
- **Terminals survive server restarts** (self-hosted with systemd): the optional PTY host service (`scripts/systemd/ddagent-pty-host.service` in the repository) keeps shells running while the ddagent server restarts or updates, and the server takes them over again with their history. Without it, terminals still end when the server restarts.

### Fixes
- **A terminal tab stays alive until you close it.** A shell with no device attached (e.g. the phone app in the background) used to be killed after 30 minutes. Closing the tab in ddagent ends it completely, including the agent's MCP servers and background jobs. Shells left behind by a tab closed while offline, or by an older app, are cleaned up after 2 minutes.
- **Scrolling back works after a reconnect**: returning to the app or a dropped connection cleared the terminal history. Now only the missed output is sent and the scrollback stays.
- **Shift+Enter inserts a new line** in Claude Code and other agent CLIs instead of sending the message.
- The **Connect** button on a disconnected tab reattaches the running session instead of restarting it; it restarts only a process that has exited.
- Signing in to Cursor or OpenCode in the terminal no longer starts over when you come back from the browser.
- Returning to the app detects a dead connection within 3 seconds, and keys typed while reconnecting are sent afterwards instead of being lost.
- A tab opened in the background (synced from another device) starts at the pane's size instead of 80×24, so its prompt is no longer garbled.
- Resuming an agent session whose history mentions "Process exited with code" no longer marks the tab as ended.
- A slow connection no longer makes the terminal fall further and further behind.

Most of these fixes need both the updated server and the updated app.
<!-- lang:pl -->
### Nowości
- **Terminale przeżywają restart serwera** (self-hosted z systemd): opcjonalna usługa PTY host (`scripts/systemd/ddagent-pty-host.service` w repozytorium) utrzymuje shelle przy życiu podczas restartu lub aktualizacji serwera ddagent, a serwer przejmuje je z powrotem razem z historią. Bez niej terminale nadal kończą się przy restarcie serwera.

### Poprawki
- **Karta terminala żyje, dopóki jej nie zamkniesz.** Shell bez podłączonego urządzenia (np. aplikacja na telefonie w tle) był zabijany po 30 minutach. Zamknięcie karty w ddagencie kończy go całkowicie, razem z serwerami MCP i zadaniami w tle agenta. Shelle po kartach zamkniętych offline albo przez starszą aplikację są sprzątane po 2 minutach.
- **Przewijanie wstecz działa po ponownym połączeniu**: powrót do aplikacji lub zerwane połączenie czyściły historię terminala. Teraz wysyłany jest tylko pominięty output, a historia zostaje.
- **Shift+Enter wstawia nową linię** w Claude Code i innych CLI agentów zamiast wysyłać wiadomość.
- Przycisk **Połącz** na rozłączonej karcie podłącza się do działającej sesji zamiast ją restartować; restartuje tylko proces, który się zakończył.
- Logowanie do Cursor lub OpenCode w terminalu nie zaczyna się od nowa po powrocie z przeglądarki.
- Po powrocie do aplikacji martwe połączenie jest wykrywane w ciągu 3 sekund, a klawisze wpisane w trakcie ponownego łączenia są wysyłane później zamiast przepadać.
- Karta otwarta w tle (zsynchronizowana z innego urządzenia) startuje w rozmiarze panelu zamiast 80×24, więc jej prompt nie jest już poszarpany.
- Wznowienie sesji agenta, której historia zawiera „Process exited with code”, nie oznacza już karty jako zakończonej.
- Wolne połączenie nie sprawia już, że terminal coraz bardziej się opóźnia.

Większość poprawek wymaga zarówno zaktualizowanego serwera, jak i aplikacji.
<!-- lang:de -->
### Neu
- **Terminals überstehen Server-Neustarts** (selbst gehostet mit systemd): Der optionale PTY-Host-Dienst (`scripts/systemd/ddagent-pty-host.service` im Repository) hält Shells am Leben, während der ddagent-Server neu startet oder aktualisiert wird, und der Server übernimmt sie danach samt Verlauf wieder. Ohne ihn enden Terminals weiterhin beim Neustart des Servers.

### Fehlerbehebungen
- **Ein Terminal-Tab bleibt aktiv, bis du ihn schließt.** Eine Shell ohne verbundenes Gerät (z. B. die Handy-App im Hintergrund) wurde nach 30 Minuten beendet. Das Schließen des Tabs in ddagent beendet sie vollständig, einschließlich der MCP-Server und Hintergrundjobs des Agenten. Shells von Tabs, die offline oder von einer älteren App geschlossen wurden, werden nach 2 Minuten aufgeräumt.
- **Zurückscrollen funktioniert nach einer erneuten Verbindung**: Die Rückkehr zur App oder ein Verbindungsabbruch löschte den Terminal-Verlauf. Jetzt wird nur die verpasste Ausgabe gesendet und der Verlauf bleibt erhalten.
- **Umschalt+Eingabe fügt eine neue Zeile ein** in Claude Code und anderen Agenten-CLIs, statt die Nachricht zu senden.
- Die Schaltfläche **Verbinden** auf einem getrennten Tab verbindet sich wieder mit der laufenden Sitzung, statt sie neu zu starten; neu gestartet wird nur ein beendeter Prozess.
- Die Anmeldung bei Cursor oder OpenCode im Terminal beginnt nicht mehr von vorn, wenn du aus dem Browser zurückkommst.
- Bei der Rückkehr zur App wird eine tote Verbindung innerhalb von 3 Sekunden erkannt, und während des erneuten Verbindens getippte Tasten werden danach gesendet statt verloren zu gehen.
- Ein im Hintergrund geöffneter Tab (von einem anderen Gerät synchronisiert) startet in der Größe des Bereichs statt mit 80×24, sodass sein Prompt nicht mehr verstümmelt ist.
- Das Fortsetzen einer Agenten-Sitzung, deren Verlauf „Process exited with code“ erwähnt, markiert den Tab nicht mehr als beendet.
- Eine langsame Verbindung lässt das Terminal nicht mehr immer weiter hinterherhinken.

Die meisten Korrekturen erfordern sowohl den aktualisierten Server als auch die aktualisierte App.
<!-- lang:es -->
### Novedades
- **Los terminales sobreviven a los reinicios del servidor** (autoalojado con systemd): el servicio opcional PTY host (`scripts/systemd/ddagent-pty-host.service` en el repositorio) mantiene los shells en ejecución mientras el servidor de ddagent se reinicia o actualiza, y el servidor los recupera después con su historial. Sin él, los terminales siguen terminando al reiniciar el servidor.

### Correcciones
- **Una pestaña de terminal sigue viva hasta que la cierras.** Un shell sin ningún dispositivo conectado (p. ej. la app del móvil en segundo plano) se cerraba a los 30 minutos. Cerrar la pestaña en ddagent lo termina por completo, incluidos los servidores MCP y las tareas en segundo plano del agente. Los shells que quedan de pestañas cerradas sin conexión o desde una app antigua se limpian a los 2 minutos.
- **Desplazarse hacia atrás funciona tras una reconexión**: volver a la app o una conexión caída borraba el historial del terminal. Ahora solo se envía la salida perdida y el historial se conserva.
- **Mayús+Intro inserta una nueva línea** en Claude Code y otras CLI de agentes en lugar de enviar el mensaje.
- El botón **Conectar** de una pestaña desconectada vuelve a la sesión en ejecución en lugar de reiniciarla; solo reinicia un proceso que ha terminado.
- Iniciar sesión en Cursor u OpenCode en el terminal ya no vuelve a empezar al regresar del navegador.
- Al volver a la app, una conexión muerta se detecta en 3 segundos, y las teclas pulsadas durante la reconexión se envían después en lugar de perderse.
- Una pestaña abierta en segundo plano (sincronizada desde otro dispositivo) arranca con el tamaño del panel en lugar de 80×24, así que su prompt ya no aparece desordenado.
- Reanudar una sesión de agente cuyo historial menciona «Process exited with code» ya no marca la pestaña como terminada.
- Una conexión lenta ya no hace que el terminal se retrase cada vez más.

La mayoría de las correcciones requieren tanto el servidor como la app actualizados.
<!-- lang:fr -->
### Nouveautés
- **Les terminaux survivent aux redémarrages du serveur** (auto-hébergé avec systemd) : le service optionnel PTY host (`scripts/systemd/ddagent-pty-host.service` dans le dépôt) garde les shells en vie pendant que le serveur ddagent redémarre ou se met à jour, puis le serveur les reprend avec leur historique. Sans lui, les terminaux se terminent toujours au redémarrage du serveur.

### Corrections
- **Un onglet de terminal reste actif jusqu'à ce que vous le fermiez.** Un shell sans appareil connecté (par ex. l'application mobile en arrière-plan) était tué au bout de 30 minutes. Fermer l'onglet dans ddagent le termine complètement, y compris les serveurs MCP et les tâches en arrière-plan de l'agent. Les shells laissés par un onglet fermé hors ligne ou par une ancienne application sont nettoyés au bout de 2 minutes.
- **Le défilement vers le haut fonctionne après une reconnexion** : revenir dans l'application ou une coupure de connexion effaçait l'historique du terminal. Désormais, seule la sortie manquée est envoyée et l'historique est conservé.
- **Maj+Entrée insère une nouvelle ligne** dans Claude Code et les autres CLI d'agents au lieu d'envoyer le message.
- Le bouton **Connecter** d'un onglet déconnecté se rattache à la session en cours au lieu de la redémarrer ; il ne redémarre qu'un processus terminé.
- La connexion à Cursor ou OpenCode dans le terminal ne recommence plus à zéro quand vous revenez du navigateur.
- En revenant dans l'application, une connexion morte est détectée en 3 secondes, et les touches tapées pendant la reconnexion sont envoyées ensuite au lieu d'être perdues.
- Un onglet ouvert en arrière-plan (synchronisé depuis un autre appareil) démarre à la taille du panneau au lieu de 80×24, son invite n'est donc plus déformée.
- Reprendre une session d'agent dont l'historique mentionne « Process exited with code » ne marque plus l'onglet comme terminé.
- Une connexion lente ne fait plus prendre au terminal un retard de plus en plus grand.

La plupart de ces corrections nécessitent à la fois le serveur et l'application mis à jour.
<!-- lang:it -->
### Novità
- **I terminali sopravvivono ai riavvii del server** (self-hosted con systemd): il servizio opzionale PTY host (`scripts/systemd/ddagent-pty-host.service` nel repository) mantiene attive le shell mentre il server ddagent si riavvia o si aggiorna, e il server le riprende poi con la loro cronologia. Senza di esso, i terminali terminano ancora al riavvio del server.

### Correzioni
- **Una scheda del terminale resta attiva finché non la chiudi.** Una shell senza dispositivi collegati (ad es. l'app sul telefono in background) veniva terminata dopo 30 minuti. Chiudere la scheda in ddagent la termina del tutto, inclusi i server MCP e i processi in background dell'agente. Le shell rimaste da schede chiuse offline o da un'app più vecchia vengono ripulite dopo 2 minuti.
- **Lo scorrimento all'indietro funziona dopo una riconnessione**: tornare nell'app o una connessione caduta cancellava la cronologia del terminale. Ora viene inviato solo l'output perso e la cronologia resta.
- **Maiusc+Invio inserisce una nuova riga** in Claude Code e nelle altre CLI degli agenti invece di inviare il messaggio.
- Il pulsante **Connetti** su una scheda disconnessa si ricollega alla sessione in esecuzione invece di riavviarla; riavvia solo un processo terminato.
- L'accesso a Cursor o OpenCode nel terminale non ricomincia più da capo quando torni dal browser.
- Tornando nell'app, una connessione morta viene rilevata entro 3 secondi e i tasti digitati durante la riconnessione vengono inviati dopo invece di andare persi.
- Una scheda aperta in background (sincronizzata da un altro dispositivo) parte con le dimensioni del riquadro invece di 80×24, quindi il suo prompt non è più scomposto.
- Riprendere una sessione dell'agente la cui cronologia menziona "Process exited with code" non segna più la scheda come terminata.
- Una connessione lenta non fa più restare il terminale sempre più indietro.

La maggior parte delle correzioni richiede sia il server sia l'app aggiornati.
<!-- lang:ja -->
### 新機能
- **サーバーを再起動してもターミナルが残るようになりました**（systemd によるセルフホスト）：オプションの PTY ホストサービス（リポジトリの `scripts/systemd/ddagent-pty-host.service`）が、ddagent サーバーの再起動や更新の間もシェルを動かし続け、サーバーは再起動後に履歴ごとそれらを引き継ぎます。このサービスがない場合、ターミナルはこれまでどおりサーバーの再起動で終了します。

### 修正
- **ターミナルのタブは閉じるまで動き続けます。** どのデバイスも接続していないシェル（例：バックグラウンドのスマホアプリ）は 30 分後に終了されていました。ddagent でタブを閉じると、エージェントの MCP サーバーやバックグラウンドジョブも含めて完全に終了します。オフライン中や古いアプリで閉じたタブのシェルは 2 分後に片付けられます。
- **再接続後もスクロールバックできます**：アプリへの復帰や接続の切断でターミナルの履歴が消えていました。現在は見逃した出力だけを送り、履歴は残ります。
- **Shift+Enter で改行が入ります**（Claude Code などのエージェント CLI でメッセージを送信しなくなりました）。
- 切断されたタブの **接続** ボタンは、セッションを再起動せずに実行中のセッションへ再接続します。再起動するのは終了したプロセスだけです。
- ターミナルでの Cursor や OpenCode へのサインインが、ブラウザから戻ったときに最初からやり直しにならなくなりました。
- アプリに戻ると切れた接続を 3 秒以内に検出し、再接続中に入力したキーは失われずに後から送信されます。
- バックグラウンドで開いたタブ（別のデバイスから同期）は 80×24 ではなくペインのサイズで起動するため、プロンプトが崩れなくなりました。
- 履歴に「Process exited with code」を含むエージェントセッションを再開しても、タブが終了扱いにならなくなりました。
- 遅い接続でターミナルがどんどん遅れていくことがなくなりました。

ほとんどの修正には、更新済みのサーバーとアプリの両方が必要です。
<!-- lang:ko -->
### 새 기능
- **서버를 재시작해도 터미널이 유지됩니다** (systemd 셀프 호스팅): 선택 사항인 PTY 호스트 서비스(저장소의 `scripts/systemd/ddagent-pty-host.service`)가 ddagent 서버가 재시작되거나 업데이트되는 동안 셸을 계속 실행하고, 서버는 이후 기록과 함께 이를 다시 넘겨받습니다. 이 서비스가 없으면 터미널은 여전히 서버 재시작 시 종료됩니다.

### 수정
- **터미널 탭은 닫을 때까지 유지됩니다.** 연결된 기기가 없는 셸(예: 백그라운드에 있는 휴대폰 앱)은 30분 후 종료되었습니다. ddagent에서 탭을 닫으면 에이전트의 MCP 서버와 백그라운드 작업까지 포함해 완전히 종료됩니다. 오프라인 상태나 이전 버전 앱에서 닫은 탭이 남긴 셸은 2분 후 정리됩니다.
- **다시 연결한 후에도 스크롤백이 됩니다**: 앱으로 돌아오거나 연결이 끊기면 터미널 기록이 지워졌습니다. 이제 놓친 출력만 보내고 기록은 그대로 남습니다.
- **Shift+Enter로 줄바꿈이 됩니다** — Claude Code 및 기타 에이전트 CLI에서 메시지를 보내지 않습니다.
- 연결이 끊긴 탭의 **연결** 버튼은 세션을 재시작하지 않고 실행 중인 세션에 다시 연결합니다. 종료된 프로세스만 재시작합니다.
- 터미널에서 Cursor 또는 OpenCode 로그인이 브라우저에서 돌아왔을 때 처음부터 다시 시작되지 않습니다.
- 앱으로 돌아오면 끊어진 연결을 3초 안에 감지하고, 다시 연결하는 동안 입력한 키는 사라지지 않고 이후에 전송됩니다.
- 백그라운드에서 열린 탭(다른 기기에서 동기화됨)은 80×24가 아닌 창 크기로 시작하므로 프롬프트가 깨지지 않습니다.
- 기록에 "Process exited with code"가 포함된 에이전트 세션을 재개해도 탭이 종료됨으로 표시되지 않습니다.
- 느린 연결에서 터미널이 점점 더 뒤처지지 않습니다.

대부분의 수정 사항은 업데이트된 서버와 앱이 모두 필요합니다.
<!-- lang:ru -->
### Новое
- **Терминалы переживают перезапуск сервера** (self-hosted с systemd): необязательная служба PTY host (`scripts/systemd/ddagent-pty-host.service` в репозитории) сохраняет оболочки работающими, пока сервер ddagent перезапускается или обновляется, а затем сервер снова подхватывает их вместе с историей. Без неё терминалы по-прежнему завершаются при перезапуске сервера.

### Исправления
- **Вкладка терминала работает, пока вы её не закроете.** Оболочка без подключённых устройств (например, приложение на телефоне в фоне) завершалась через 30 минут. Закрытие вкладки в ddagent завершает её полностью, включая MCP-серверы и фоновые задачи агента. Оболочки, оставшиеся от вкладок, закрытых без сети или в старом приложении, удаляются через 2 минуты.
- **Прокрутка назад работает после переподключения**: возвращение в приложение или обрыв связи стирали историю терминала. Теперь отправляется только пропущенный вывод, а история сохраняется.
- **Shift+Enter вставляет новую строку** в Claude Code и других CLI агентов вместо отправки сообщения.
- Кнопка **Подключить** на отключённой вкладке подключается к работающему сеансу, а не перезапускает его; перезапускается только завершившийся процесс.
- Вход в Cursor или OpenCode в терминале больше не начинается заново, когда вы возвращаетесь из браузера.
- При возвращении в приложение мёртвое соединение обнаруживается за 3 секунды, а клавиши, нажатые во время переподключения, отправляются потом, а не теряются.
- Вкладка, открытая в фоне (синхронизированная с другого устройства), запускается в размере панели, а не 80×24, поэтому её приглашение больше не искажается.
- Возобновление сеанса агента, в истории которого упоминается «Process exited with code», больше не помечает вкладку как завершённую.
- Медленное соединение больше не заставляет терминал отставать всё сильнее.

Большинство исправлений требует и обновлённого сервера, и обновлённого приложения.
<!-- lang:tr -->
### Yenilikler
- **Terminaller sunucu yeniden başlatmalarından sağ çıkar** (systemd ile kendi sunucunuzda): isteğe bağlı PTY host hizmeti (depodaki `scripts/systemd/ddagent-pty-host.service`) ddagent sunucusu yeniden başlarken veya güncellenirken kabukları çalışır durumda tutar ve sunucu ardından onları geçmişleriyle birlikte yeniden devralır. Bu hizmet olmadan terminaller sunucu yeniden başladığında yine sona erer.

### Düzeltmeler
- **Bir terminal sekmesi siz kapatana kadar açık kalır.** Hiçbir cihazın bağlı olmadığı bir kabuk (ör. arka plandaki telefon uygulaması) 30 dakika sonra sonlandırılıyordu. Sekmeyi ddagent'ta kapatmak, ajanın MCP sunucuları ve arka plan işleri dahil onu tamamen sonlandırır. Çevrimdışıyken veya eski bir uygulamada kapatılan sekmelerden kalan kabuklar 2 dakika sonra temizlenir.
- **Yeniden bağlandıktan sonra geri kaydırma çalışır**: uygulamaya dönmek veya bağlantının kopması terminal geçmişini siliyordu. Artık yalnızca kaçırılan çıktı gönderilir ve geçmiş korunur.
- **Shift+Enter yeni satır ekler** — Claude Code ve diğer ajan CLI'larında mesajı göndermez.
- Bağlantısı kopan sekmedeki **Bağlan** düğmesi, oturumu yeniden başlatmak yerine çalışan oturuma yeniden bağlanır; yalnızca sona ermiş bir süreci yeniden başlatır.
- Terminalde Cursor veya OpenCode oturum açma işlemi, tarayıcıdan döndüğünüzde baştan başlamaz.
- Uygulamaya döndüğünüzde ölü bir bağlantı 3 saniye içinde algılanır ve yeniden bağlanırken yazılan tuşlar kaybolmak yerine sonradan gönderilir.
- Arka planda açılan bir sekme (başka bir cihazdan eşitlenen) 80×24 yerine bölmenin boyutunda başlar, böylece istemi artık bozuk görünmez.
- Geçmişinde "Process exited with code" geçen bir ajan oturumunu sürdürmek, sekmeyi artık sona ermiş olarak işaretlemez.
- Yavaş bir bağlantı artık terminalin giderek daha fazla geride kalmasına yol açmaz.

Bu düzeltmelerin çoğu hem güncel sunucuyu hem de güncel uygulamayı gerektirir.
<!-- lang:zh-CN -->
### 新功能
- **终端可在服务器重启后保留**（使用 systemd 自托管）：可选的 PTY 主机服务（仓库中的 `scripts/systemd/ddagent-pty-host.service`）会在 ddagent 服务器重启或更新期间保持 shell 运行，服务器随后连同历史记录重新接管它们。没有该服务时，终端仍会在服务器重启时结束。

### 修复
- **终端标签页会一直保持运行，直到你关闭它。** 没有任何设备连接的 shell（例如在后台的手机应用）以前会在 30 分钟后被终止。在 ddagent 中关闭标签页会彻底结束它，包括代理的 MCP 服务器和后台任务。离线时或由旧版应用关闭的标签页遗留的 shell 会在 2 分钟后被清理。
- **重新连接后可以向上滚动**：返回应用或连接断开会清空终端历史。现在只发送错过的输出，历史记录会保留。
- **Shift+Enter 插入换行**，在 Claude Code 和其他代理 CLI 中不再发送消息。
- 已断开标签页上的 **连接** 按钮会重新连接到正在运行的会话，而不是重启它；只有已退出的进程才会重启。
- 在终端中登录 Cursor 或 OpenCode 时，从浏览器返回后不再从头开始。
- 返回应用时会在 3 秒内检测到失效的连接，重新连接期间输入的按键会在之后发送，而不会丢失。
- 在后台打开的标签页（从其他设备同步）以面板大小而不是 80×24 启动，因此其提示符不再错乱。
- 恢复历史中提到“Process exited with code”的代理会话时，标签页不再被标记为已结束。
- 网络较慢时，终端不会再越来越滞后。

大多数修复需要同时更新服务器和应用。
<!-- lang:zh-TW -->
### 新功能
- **終端機可在伺服器重新啟動後保留**（使用 systemd 自行架設）：選用的 PTY 主機服務（儲存庫中的 `scripts/systemd/ddagent-pty-host.service`）會在 ddagent 伺服器重新啟動或更新期間讓 shell 持續執行，伺服器之後會連同歷史紀錄重新接手。沒有這項服務時，終端機仍會在伺服器重新啟動時結束。

### 修正
- **終端機分頁會持續執行，直到你關閉它。** 沒有任何裝置連線的 shell（例如在背景的手機應用程式）以前會在 30 分鐘後被終止。在 ddagent 中關閉分頁會徹底結束它，包括代理的 MCP 伺服器與背景工作。離線時或由舊版應用程式關閉的分頁所遺留的 shell 會在 2 分鐘後被清除。
- **重新連線後可以向上捲動**：返回應用程式或連線中斷會清除終端機歷史。現在只會傳送錯過的輸出，歷史紀錄會保留。
- **Shift+Enter 插入換行**，在 Claude Code 與其他代理 CLI 中不再送出訊息。
- 已中斷分頁上的 **連線** 按鈕會重新連到正在執行的工作階段，而不是重新啟動它；只有已結束的程序才會重新啟動。
- 在終端機中登入 Cursor 或 OpenCode 時，從瀏覽器返回後不再從頭開始。
- 返回應用程式時會在 3 秒內偵測到失效的連線，重新連線期間輸入的按鍵會在之後送出，而不會遺失。
- 在背景開啟的分頁（從其他裝置同步）會以窗格大小而非 80×24 啟動，因此提示字元不再錯亂。
- 繼續歷史中提到「Process exited with code」的代理工作階段時，分頁不再被標示為已結束。
- 網路較慢時，終端機不會再越來越延遲。

大多數修正需要同時更新伺服器與應用程式。
