<!--
  GitHub draft-release body template — the server-release workflow
  (.github/workflows/server-release.yml) passes this file to
  `gh release create --notes-file`, so every draft release created on a tag
  starts with this body.

  AGENTS.md requires per-language release notes split by
  `<!-- lang:<code> -->` markers — the Flutter Settings → About changelog
  renders only the section matching the active UI language, `en` is the
  fallback. All 12 UI locales are below; replace the TODO lines in EVERY
  section, then publish the draft. (This header comment never renders — it
  sits before the first lang marker and markdown comments are invisible
  anyway.)
-->
<!-- lang:en -->
### Bug fixes
- Queue: queued messages are now also drained by a periodic idle sweep, so a message queued during a session no longer stays stuck when the provider's "turn complete" notification is missed.
- Web client: the flutter-web server now proxies `/health` to the backend, so Settings → About shows the server version again and "check for updates" works instead of failing to decode the response.
- Mobile: the server-connect screen no longer spins forever — the connect flow is guarded, so an unexpected error still leaves a working retry button.
- Mobile: a mode or model menu opened from the compact `+` sheet now appears next to the tapped control instead of at the top of the screen.
<!-- lang:pl -->
### Poprawki błędów
- Kolejka: zakolejkowane wiadomości są teraz dosyłane także przez okresowy sweep bezczynności — wiadomość zakolejkowana w trakcie sesji nie zostaje już zablokowana, gdy powiadomienie o zakończeniu tury od providera nie dotrze.
- Klient web: serwer flutter-web przekazuje teraz `/health` do backendu, więc Ustawienia → O aplikacji znów pokazują wersję serwera, a „sprawdź aktualizacje” działa zamiast wywalać się na dekodowaniu odpowiedzi.
- Mobile: ekran łączenia z serwerem nie kręci się już w nieskończoność — przepływ połączenia jest zabezpieczony, więc nieoczekiwany błąd zostawia działający przycisk ponowienia.
- Mobile: menu trybu lub modelu otwierane z kompaktowego arkusza `+` pojawia się teraz przy dotkniętym elemencie, a nie na górze ekranu.
<!-- lang:de -->
### Fehlerbehebungen
- Warteschlange: Wartende Nachrichten werden jetzt zusätzlich durch einen periodischen Idle-Sweep zugestellt — eine während einer Sitzung eingereihte Nachricht bleibt nicht mehr hängen, wenn die „Turn beendet"-Benachrichtigung des Providers ausbleibt.
- Web-Client: Der flutter-web-Server leitet `/health` jetzt an das Backend weiter, sodass Einstellungen → Über wieder die Serverversion anzeigt und „Nach Updates suchen" funktioniert, statt an der Antwort zu scheitern.
- Mobil: Der Server-Verbindungsbildschirm dreht sich nicht mehr endlos — der Verbindungsablauf ist abgesichert, sodass ein unerwarteter Fehler eine funktionierende Wiederholen-Schaltfläche hinterlässt.
- Mobil: Ein Modus- oder Modellmenü, das aus dem kompakten `+`-Blatt geöffnet wird, erscheint jetzt neben dem angetippten Element statt oben auf dem Bildschirm.
<!-- lang:es -->
### Correcciones de errores
- Cola: los mensajes en cola ahora se entregan también mediante un barrido periódico de inactividad, así un mensaje encolado durante una sesión ya no se queda atascado cuando se pierde la notificación de «turno completado» del proveedor.
- Cliente web: el servidor flutter-web ahora redirige `/health` al backend, así Ajustes → Acerca de vuelve a mostrar la versión del servidor y «buscar actualizaciones» funciona en lugar de fallar al decodificar la respuesta.
- Móvil: la pantalla de conexión con el servidor ya no gira sin fin — el flujo de conexión está protegido, así un error inesperado deja un botón de reintento funcional.
- Móvil: un menú de modo o modelo abierto desde la hoja compacta `+` ahora aparece junto al control pulsado en lugar de la parte superior de la pantalla.
<!-- lang:fr -->
### Corrections de bugs
- File d'attente : les messages en attente sont désormais aussi livrés par un balayage périodique d'inactivité — un message mis en file pendant une session ne reste plus bloqué lorsque la notification « tour terminé » du fournisseur est manquée.
- Client web : le serveur flutter-web redirige maintenant `/health` vers le backend, donc Paramètres → À propos réaffiche la version du serveur et « rechercher des mises à jour » fonctionne au lieu d'échouer au décodage de la réponse.
- Mobile : l'écran de connexion au serveur ne tourne plus indéfiniment — le flux de connexion est protégé, donc une erreur inattendue laisse un bouton de nouvelle tentative fonctionnel.
- Mobile : un menu de mode ou de modèle ouvert depuis la feuille compacte `+` apparaît désormais à côté du contrôle touché au lieu du haut de l'écran.
<!-- lang:it -->
### Correzioni di bug
- Coda: i messaggi in coda vengono ora consegnati anche da una scansione periodica di inattività — un messaggio messo in coda durante una sessione non resta più bloccato quando la notifica di «turno completato» del provider va persa.
- Client web: il server flutter-web ora inoltra `/health` al backend, così Impostazioni → Informazioni mostra di nuovo la versione del server e «controlla aggiornamenti» funziona invece di fallire nella decodifica della risposta.
- Mobile: la schermata di connessione al server non gira più all'infinito — il flusso di connessione è protetto, quindi un errore imprevisto lascia un pulsante di riprova funzionante.
- Mobile: un menu di modalità o modello aperto dal foglio compatto `+` ora compare accanto al controllo toccato invece che in cima allo schermo.
<!-- lang:ja -->
### バグ修正
- キュー: キューに入れたメッセージが定期的なアイドルスイープでも送信されるようになりました — プロバイダーの「ターン完了」通知が届かなくても、セッション中にキューしたメッセージが止まったままにならなくなりました。
- Web クライアント: flutter-web サーバーが `/health` をバックエンドにプロキシするようになり、設定 → このアプリでサーバーのバージョンが再び表示され、「アップデートを確認」も応答のデコードに失敗せず動作します。
- モバイル: サーバー接続画面が永遠に読み込み続けることがなくなりました — 接続フローを保護したので、予期しないエラーでも再試行ボタンが機能します。
- モバイル: コンパクトな `+` シートから開いたモード/モデルメニューが、画面の上部ではなくタップしたコントロールの隣に表示されるようになりました。
<!-- lang:ko -->
### 버그 수정
- 큐: 대기 중인 메시지가 이제 주기적인 유휴 스윕으로도 전달됩니다 — 프로바이더의 "턴 완료" 알림이 유실되어도 세션 중 큐에 넣은 메시지가 멈춰 있지 않습니다.
- 웹 클라이언트: flutter-web 서버가 이제 `/health`를 백엔드로 프록시하므로, 설정 → 앱 정보에 서버 버전이 다시 표시되고 "업데이트 확인"도 응답 디코딩 실패 없이 작동합니다.
- 모바일: 서버 연결 화면이 더 이상 무한히 로딩되지 않습니다 — 연결 흐름을 보호하여 예기치 않은 오류가 나도 다시 시도 버튼이 정상 동작합니다.
- 모바일: 컴팩트한 `+` 시트에서 연 모드/모델 메뉴가 화면 상단이 아니라 탭한 컨트롤 옆에 나타납니다.
<!-- lang:ru -->
### Исправления ошибок
- Очередь: сообщения из очереди теперь доставляются и периодической проверкой простоя — сообщение, поставленное в очередь во время сессии, больше не зависает, если уведомление «ход завершён» от провайдера не пришло.
- Веб-клиент: сервер flutter-web теперь проксирует `/health` на бэкенд, поэтому Настройки → О приложении снова показывают версию сервера, а «проверить обновления» работает вместо ошибки декодирования ответа.
- Мобильные: экран подключения к серверу больше не крутится бесконечно — поток подключения защищён, поэтому при неожиданной ошибке остаётся рабочая кнопка повтора.
- Мобильные: меню режима или модели, открытое из компактного листа `+`, теперь появляется рядом с нажатым элементом, а не в верхней части экрана.
<!-- lang:tr -->
### Hata düzeltmeleri
- Kuyruk: kuyruktaki mesajlar artık periyodik bir boşta taramasıyla da gönderiliyor — sağlayıcının "tur tamamlandı" bildirimi kaçırılsa bile oturum sırasında kuyruğa alınan bir mesaj takılı kalmıyor.
- Web istemcisi: flutter-web sunucusu artık `/health` isteğini arka uca yönlendiriyor, böylece Ayarlar → Uygulama hakkında sunucu sürümünü yeniden gösteriyor ve "güncellemeleri denetle" yanıtı çözümlemede hata vermek yerine çalışıyor.
- Mobil: sunucu bağlantı ekranı artık sonsuza dek dönmüyor — bağlantı akışı korunuyor, bu yüzden beklenmedik bir hata çalışan bir yeniden deneme düğmesi bırakıyor.
- Mobil: kompakt `+` sayfasından açılan mod veya model menüsü artık ekranın üstü yerine dokunulan denetimin yanında görünüyor.
<!-- lang:zh-CN -->
### 错误修复
- 队列：排队消息现在也会通过周期性的空闲扫描发送 — 即使错过了提供商“回合完成”的通知，会话期间排队的消息也不会再卡住。
- Web 客户端：flutter-web 服务器现在将 `/health` 代理到后端，因此设置 → 关于会重新显示服务器版本，“检查更新”也能正常工作，而不再因解码响应而失败。
- 移动端：连接服务器的界面不再无限加载 — 连接流程已加保护，即使出现意外错误，重试按钮仍然可用。
- 移动端：从紧凑的 `+` 面板打开的模式/模型菜单现在显示在被点击控件旁边，而不是屏幕顶部。
<!-- lang:zh-TW -->
### 錯誤修復
- 佇列：排隊訊息現在也會透過定期的閒置掃描送出 — 即使錯過了供應商「回合完成」的通知，工作階段期間排隊的訊息也不會再卡住。
- 網頁用戶端：flutter-web 伺服器現在會將 `/health` 代理到後端，因此設定 → 關於會重新顯示伺服器版本，「檢查更新」也能正常運作，而不再因解碼回應而失敗。
- 行動裝置：連接伺服器的畫面不再無限載入 — 連接流程已加上保護，即使發生非預期錯誤，重試按鈕仍可運作。
- 行動裝置：從精簡的 `+` 面板開啟的模式/模型選單現在會顯示在被點擊控制項旁邊，而不是畫面頂端。
