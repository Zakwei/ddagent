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
- Claude CLI sessions started outside the app (in tmux or a terminal) now show as working in the app, and their new messages appear in open panes within seconds.

### Bug fixes
- The panes overview now updates live: a tile turns amber when the agent asks you something and green while it is working. Long status labels no longer overflow narrow phone tiles.
- A chat opened during a run retries loading its history if the first attempt fails, and no longer shows the agent's reply twice.
- A successful self-update no longer looks like it failed because of harmless npm warnings in the log.
<!-- lang:pl -->
### Nowości
- Sesje Claude CLI uruchomione poza aplikacją (w tmux lub terminalu) są teraz widoczne w aplikacji jako pracujące, a ich nowe wiadomości pojawiają się w otwartych panelach w ciągu kilku sekund.

### Poprawki
- Przegląd paneli aktualizuje się na żywo: kafelek robi się bursztynowy, gdy agent o coś pyta, i zielony, gdy pracuje. Długie etykiety stanu nie wychodzą już poza wąskie kafelki na telefonie.
- Czat otwarty w trakcie pracy agenta ponawia ładowanie historii, jeśli pierwsza próba się nie uda, i nie pokazuje już odpowiedzi agenta dwa razy.
- Udana aktualizacja nie wygląda już na nieudaną przez nieszkodliwe ostrzeżenia npm w logu.
<!-- lang:de -->
### Neu
- Claude-CLI-Sitzungen, die außerhalb der App gestartet wurden (in tmux oder einem Terminal), werden jetzt in der App als aktiv angezeigt, und ihre neuen Nachrichten erscheinen innerhalb von Sekunden in offenen Bereichen.

### Fehlerbehebungen
- Die Bereichsübersicht aktualisiert sich jetzt live: Eine Kachel wird bernsteinfarben, wenn der Agent dich etwas fragt, und grün, während er arbeitet. Lange Statusbeschriftungen laufen auf schmalen Handy-Kacheln nicht mehr über.
- Ein während eines Laufs geöffneter Chat lädt seinen Verlauf erneut, wenn der erste Versuch fehlschlägt, und zeigt die Antwort des Agenten nicht mehr doppelt an.
- Ein erfolgreiches Update wirkt nicht mehr fehlgeschlagen, nur weil harmlose npm-Warnungen im Log stehen.
<!-- lang:es -->
### Novedades
- Las sesiones de Claude CLI iniciadas fuera de la app (en tmux o una terminal) ahora aparecen como activas en la app, y sus mensajes nuevos llegan a los paneles abiertos en segundos.

### Correcciones
- La vista general de paneles se actualiza en directo: una tarjeta se vuelve ámbar cuando el agente te pregunta algo y verde mientras trabaja. Las etiquetas de estado largas ya no se desbordan en las tarjetas estrechas del móvil.
- Un chat abierto durante una ejecución reintenta cargar su historial si el primer intento falla, y ya no muestra la respuesta del agente dos veces.
- Una actualización correcta ya no parece fallida por avisos inofensivos de npm en el registro.
<!-- lang:fr -->
### Nouveautés
- Les sessions Claude CLI lancées hors de l'application (dans tmux ou un terminal) apparaissent désormais comme actives dans l'application, et leurs nouveaux messages arrivent dans les panneaux ouverts en quelques secondes.

### Corrections
- La vue d'ensemble des panneaux se met à jour en direct : une tuile passe à l'ambre quand l'agent vous pose une question et au vert pendant qu'il travaille. Les longues étiquettes d'état ne débordent plus des tuiles étroites sur mobile.
- Un chat ouvert pendant une exécution réessaie de charger son historique si la première tentative échoue, et n'affiche plus la réponse de l'agent en double.
- Une mise à jour réussie ne semble plus avoir échoué à cause d'avertissements npm inoffensifs dans le journal.
<!-- lang:it -->
### Novità
- Le sessioni di Claude CLI avviate fuori dall'app (in tmux o in un terminale) ora risultano attive nell'app e i loro nuovi messaggi compaiono nei pannelli aperti in pochi secondi.

### Correzioni
- La panoramica dei pannelli si aggiorna in tempo reale: una scheda diventa ambra quando l'agente ti chiede qualcosa e verde mentre lavora. Le etichette di stato lunghe non escono più dalle schede strette sul telefono.
- Una chat aperta durante un'esecuzione riprova a caricare la cronologia se il primo tentativo fallisce e non mostra più due volte la risposta dell'agente.
- Un aggiornamento riuscito non sembra più fallito a causa di innocui avvisi npm nel log.
<!-- lang:ja -->
### 新機能
- アプリ外（tmux やターミナル）で起動した Claude CLI セッションが、アプリ内で作業中として表示され、新しいメッセージが数秒以内に開いているパネルに届くようになりました。

### バグ修正
- パネル一覧がリアルタイムで更新されるようになりました。エージェントが質問するとタイルが琥珀色に、作業中は緑色になります。長い状態ラベルがスマートフォンの狭いタイルからはみ出さなくなりました。
- 実行中に開いたチャットは、最初の履歴読み込みに失敗すると再試行し、エージェントの返信が二重に表示されなくなりました。
- ログに無害な npm の警告が出ても、成功したアップデートが失敗したように見えなくなりました。
<!-- lang:ko -->
### 새 기능
- 앱 밖(tmux 또는 터미널)에서 시작한 Claude CLI 세션이 이제 앱에서 작업 중으로 표시되고, 새 메시지가 몇 초 안에 열린 패널에 나타납니다.

### 버그 수정
- 패널 개요가 실시간으로 갱신됩니다. 에이전트가 질문하면 타일이 호박색으로, 작업 중에는 초록색으로 바뀝니다. 긴 상태 라벨이 휴대폰의 좁은 타일 밖으로 넘치지 않습니다.
- 실행 중에 연 채팅은 첫 기록 로딩이 실패하면 다시 시도하며, 에이전트의 답변이 두 번 표시되지 않습니다.
- 로그의 무해한 npm 경고 때문에 성공한 업데이트가 실패한 것처럼 보이지 않습니다.
<!-- lang:ru -->
### Что нового
- Сессии Claude CLI, запущенные вне приложения (в tmux или терминале), теперь отображаются в приложении как работающие, а их новые сообщения появляются в открытых панелях за несколько секунд.

### Исправления
- Обзор панелей обновляется в реальном времени: плитка становится янтарной, когда агент задаёт вопрос, и зелёной, пока он работает. Длинные подписи статуса больше не выходят за узкие плитки на телефоне.
- Чат, открытый во время работы агента, повторяет загрузку истории, если первая попытка не удалась, и больше не показывает ответ агента дважды.
- Успешное обновление больше не выглядит неудачным из-за безобидных предупреждений npm в журнале.
<!-- lang:tr -->
### Yenilikler
- Uygulama dışında (tmux'ta veya bir terminalde) başlatılan Claude CLI oturumları artık uygulamada çalışıyor olarak görünüyor ve yeni mesajları birkaç saniye içinde açık panellere geliyor.

### Hata düzeltmeleri
- Panel genel görünümü artık canlı güncelleniyor: ajan size bir şey sorduğunda kutucuk kehribar rengine, çalışırken yeşile döner. Uzun durum etiketleri artık telefondaki dar kutucuklardan taşmıyor.
- Bir çalışma sırasında açılan sohbet, ilk deneme başarısız olursa geçmişi yeniden yüklemeyi dener ve ajanın yanıtını artık iki kez göstermez.
- Başarılı bir güncelleme, günlükteki zararsız npm uyarıları yüzünden artık başarısız görünmüyor.
<!-- lang:zh-CN -->
### 新功能
- 在应用外（tmux 或终端中）启动的 Claude CLI 会话现在会在应用中显示为工作中，其新消息会在几秒内出现在已打开的窗格中。

### 问题修复
- 窗格概览现在会实时更新：代理向你提问时卡片变为琥珀色，工作中变为绿色。较长的状态标签不再溢出手机上的窄卡片。
- 运行期间打开的聊天在首次加载历史失败时会重试，并且不再重复显示代理的回复。
- 日志中无害的 npm 警告不再让成功的更新看起来像失败。
<!-- lang:zh-TW -->
### 新功能
- 在應用程式外（tmux 或終端機中）啟動的 Claude CLI 工作階段，現在會在應用程式中顯示為工作中，其新訊息會在幾秒內出現在已開啟的窗格中。

### 問題修正
- 窗格總覽現在會即時更新：代理向你提問時卡片變為琥珀色，工作中變為綠色。較長的狀態標籤不再溢出手機上的窄卡片。
- 執行期間開啟的聊天在首次載入歷史失敗時會重試，且不再重複顯示代理的回覆。
- 日誌中無害的 npm 警告不再讓成功的更新看起來像失敗。
