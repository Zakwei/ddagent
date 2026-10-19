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
- **The terminal no longer freezes after you come back to the app** or when the connection drops: reconnecting a shell replayed its whole buffer (tens of MB in a long Claude Code session), which blocked typing and selection for many seconds and duplicated the history each time. A reconnect now repaints only the recent output (up to 512 KB) on a cleared screen (needs the updated server).
- A shell that lost its connection while the app was in the background reconnects right away when you return, instead of after up to 30 seconds.
<!-- lang:pl -->
### Poprawki
- **Terminal nie zawiesza się już po powrocie do aplikacji** ani po zerwaniu połączenia: ponowne połączenie shella odtwarzało cały jego bufor (dziesiątki MB w długiej sesji Claude Code), co na wiele sekund blokowało pisanie i zaznaczanie, a za każdym razem podwajało historię. Teraz ponowne połączenie odrysowuje tylko najnowsze wyjście (do 512 KB) na wyczyszczonym ekranie (wymaga zaktualizowanego serwera).
- Shell, który stracił połączenie, gdy aplikacja była w tle, łączy się od razu po powrocie, zamiast po nawet 30 sekundach.
<!-- lang:de -->
### Fehlerbehebungen
- **Das Terminal friert nicht mehr ein, wenn du zur App zurückkehrst** oder die Verbindung abbricht: Beim erneuten Verbinden einer Shell wurde ihr gesamter Puffer wiedergegeben (in einer langen Claude-Code-Sitzung Dutzende MB), was Tippen und Auswählen viele Sekunden lang blockierte und den Verlauf jedes Mal verdoppelte. Jetzt zeichnet eine erneute Verbindung nur die jüngste Ausgabe (bis 512 KB) auf einem geleerten Bildschirm neu (erfordert den aktualisierten Server).
- Eine Shell, die ihre Verbindung verloren hat, während die App im Hintergrund war, verbindet sich beim Zurückkehren sofort neu statt nach bis zu 30 Sekunden.
<!-- lang:es -->
### Correcciones
- **El terminal ya no se congela al volver a la aplicación** ni cuando se corta la conexión: al reconectar un shell se reproducía todo su búfer (decenas de MB en una sesión larga de Claude Code), lo que bloqueaba la escritura y la selección durante muchos segundos y duplicaba el historial cada vez. Ahora la reconexión solo vuelve a dibujar la salida reciente (hasta 512 KB) sobre una pantalla limpia (requiere el servidor actualizado).
- Un shell que perdió la conexión mientras la aplicación estaba en segundo plano se reconecta en cuanto vuelves, en lugar de tras hasta 30 segundos.
<!-- lang:fr -->
### Corrections
- **Le terminal ne se fige plus quand vous revenez dans l'application** ou quand la connexion tombe : la reconnexion d'un shell rejouait tout son tampon (des dizaines de Mo dans une longue session Claude Code), ce qui bloquait la saisie et la sélection pendant de longues secondes et doublait l'historique à chaque fois. Désormais, une reconnexion ne redessine que la sortie récente (jusqu'à 512 Ko) sur un écran effacé (nécessite le serveur mis à jour).
- Un shell qui a perdu sa connexion pendant que l'application était en arrière-plan se reconnecte dès votre retour, au lieu d'attendre jusqu'à 30 secondes.
<!-- lang:it -->
### Correzioni
- **Il terminale non si blocca più quando torni nell'app** o quando cade la connessione: la riconnessione di una shell riproduceva tutto il suo buffer (decine di MB in una lunga sessione di Claude Code), bloccando digitazione e selezione per molti secondi e raddoppiando ogni volta la cronologia. Ora una riconnessione ridisegna solo l'output recente (fino a 512 KB) su uno schermo pulito (richiede il server aggiornato).
- Una shell che ha perso la connessione mentre l'app era in background si riconnette appena torni, invece che dopo fino a 30 secondi.
<!-- lang:ja -->
### 修正
- **アプリに戻ったときや接続が切れたときにターミナルがフリーズしなくなりました**：シェルの再接続時にバッファ全体（長い Claude Code セッションでは数十 MB）が再生され、入力や選択が何秒もできなくなり、そのたびに履歴が重複していました。再接続ではクリアした画面に最近の出力（最大 512 KB）だけを再描画します（更新済みサーバーが必要）。
- アプリがバックグラウンドの間に接続が切れたシェルは、最大 30 秒待たずに、戻った時点ですぐ再接続します。
<!-- lang:ko -->
### 수정
- **앱으로 돌아오거나 연결이 끊겨도 터미널이 더 이상 멈추지 않습니다**: 셸을 다시 연결할 때 버퍼 전체(긴 Claude Code 세션에서는 수십 MB)가 재생되어 입력과 선택이 몇 초씩 막히고 매번 기록이 중복되었습니다. 이제 다시 연결하면 지운 화면에 최근 출력(최대 512KB)만 다시 그립니다(업데이트된 서버 필요).
- 앱이 백그라운드에 있는 동안 연결이 끊긴 셸은 최대 30초를 기다리지 않고 돌아오는 즉시 다시 연결됩니다.
<!-- lang:ru -->
### Исправления
- **Терминал больше не зависает при возвращении в приложение** или обрыве соединения: при переподключении оболочки воспроизводился весь её буфер (десятки МБ в долгом сеансе Claude Code), из-за чего ввод и выделение блокировались на много секунд, а история каждый раз удваивалась. Теперь при переподключении на очищенном экране перерисовывается только недавний вывод (до 512 КБ) (нужен обновлённый сервер).
- Оболочка, потерявшая соединение, пока приложение было в фоне, переподключается сразу после возвращения, а не через время до 30 секунд.
<!-- lang:tr -->
### Düzeltmeler
- **Uygulamaya döndüğünüzde** veya bağlantı koptuğunda **terminal artık donmuyor**: Bir kabuğun yeniden bağlanması tüm arabelleğini yeniden oynatıyordu (uzun bir Claude Code oturumunda onlarca MB); bu, yazmayı ve seçimi saniyelerce engelliyor ve geçmişi her seferinde ikiye katlıyordu. Artık yeniden bağlanma, temizlenmiş ekranda yalnızca son çıktıyı (en fazla 512 KB) yeniden çizer (güncel sunucu gerekir).
- Uygulama arka plandayken bağlantısı kopan bir kabuk, 30 saniyeye kadar beklemek yerine döndüğünüzde hemen yeniden bağlanır.
<!-- lang:zh-CN -->
### 修复
- **返回应用或连接断开后终端不再卡死**：重新连接 shell 时会回放其全部缓冲区（长时间的 Claude Code 会话可达数十 MB），导致输入和选择被阻塞好几秒，而且每次都会让历史记录重复一遍。现在重新连接只会在清空的屏幕上重绘最近的输出（最多 512 KB）（需要更新后的服务器）。
- 应用在后台时断开连接的 shell，会在你返回时立即重新连接，而不是等待最多 30 秒。
<!-- lang:zh-TW -->
### 修正
- **返回應用程式或連線中斷後終端機不再卡住**：重新連線 shell 時會重播其全部緩衝區（長時間的 Claude Code 工作階段可達數十 MB），導致輸入與選取被阻擋好幾秒，而且每次都會讓歷史紀錄重複一遍。現在重新連線只會在清空的畫面上重繪最近的輸出（最多 512 KB）（需要更新後的伺服器）。
- 應用程式在背景時中斷連線的 shell，會在你返回時立即重新連線，而不是等待最多 30 秒。
