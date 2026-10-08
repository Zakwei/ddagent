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
- When you deny a tool request from Claude or OpenCode, you can add a reason, and the agent carries on using your feedback.
- "Send now" puts a queued message into the turn that is already running (for agents that support it; elsewhere the button is greyed out).
- Hitting a usage limit can switch to another account of the same agent automatically. You turn this on per agent.
- Devin now offers its own plan mode.
- On mobile, a tab turns amber when it is waiting for you and green when its chat has finished in the background.
- The remaining untranslated parts of the interface are now available in all 12 languages.

### Bug fixes
- Agents now reply in the app's language on every turn, not only the first.
- Errors, notices and run outcomes from Claude, Codex, OpenCode, Devin, Cursor, Antigravity and Command Code are shown once, readably, and are kept in the history.
- Permission modes now apply right away and show only the modes each agent really supports.
- Desktop notifications work on Linux, Windows and the web.
- Agent installation, login, the terminal and file paths now work when the server runs on Windows.
- Open panes stay in sync across devices, and the built-in browser no longer leaks Chromium sessions.
<!-- lang:pl -->
### Nowości
- Odrzucając prośbę o narzędzie od Claude lub OpenCode, możesz podać powód — agent kontynuuje, biorąc go pod uwagę.
- „Wyślij teraz” wstawia wiadomość z kolejki do trwającej tury (u agentów, które to obsługują; u pozostałych przycisk jest wyszarzony).
- Po osiągnięciu limitu użycia aplikacja może automatycznie przełączyć się na inne konto tego samego agenta — włączane osobno dla każdego agenta.
- Devin ma własny tryb planowania.
- Na telefonie karta świeci na bursztynowo, gdy czeka na Ciebie, i na zielono, gdy czat w tle się zakończył.
- Pozostałe nieprzetłumaczone teksty interfejsu są teraz dostępne we wszystkich 12 językach.

### Poprawki
- Agenci odpowiadają w języku aplikacji w każdej turze, nie tylko w pierwszej.
- Błędy, komunikaty i wyniki uruchomień Claude, Codex, OpenCode, Devin, Cursor, Antigravity i Command Code są pokazywane raz, czytelnie, i zostają w historii.
- Tryby uprawnień działają od razu i pokazują tylko tryby, które dany agent naprawdę obsługuje.
- Powiadomienia systemowe działają na Linuksie, Windowsie i w wersji web.
- Instalacja agentów, logowanie, terminal i ścieżki działają, gdy serwer stoi na Windowsie.
- Otwarte panele są zsynchronizowane między urządzeniami, a wbudowana przeglądarka nie zostawia już sesji Chromium.
<!-- lang:de -->
### Neu
- Wenn du eine Tool-Anfrage von Claude oder OpenCode ablehnst, kannst du einen Grund angeben – der Agent macht mit deinem Feedback weiter.
- „Jetzt senden“ fügt eine Nachricht aus der Warteschlange in den laufenden Durchgang ein (bei Agenten, die das unterstützen; sonst ist die Schaltfläche ausgegraut).
- Bei Erreichen eines Nutzungslimits kann automatisch zu einem anderen Konto desselben Agenten gewechselt werden – pro Agent einstellbar.
- Devin bietet jetzt seinen eigenen Planmodus.
- Auf dem Handy wird ein Tab gelb, wenn er auf dich wartet, und grün, wenn sein Chat im Hintergrund fertig ist.
- Die restlichen unübersetzten Texte der Oberfläche gibt es jetzt in allen 12 Sprachen.

### Fehlerbehebungen
- Agenten antworten jetzt in jedem Durchgang in der Sprache der App, nicht nur im ersten.
- Fehler, Hinweise und Ergebnisse von Claude, Codex, OpenCode, Devin, Cursor, Antigravity und Command Code werden einmal, lesbar angezeigt und bleiben im Verlauf.
- Berechtigungsmodi greifen sofort und zeigen nur die Modi, die der jeweilige Agent wirklich unterstützt.
- Desktop-Benachrichtigungen funktionieren unter Linux, Windows und im Web.
- Agenten-Installation, Anmeldung, Terminal und Dateipfade funktionieren, wenn der Server unter Windows läuft.
- Offene Bereiche bleiben geräteübergreifend synchron, und der integrierte Browser hinterlässt keine Chromium-Sitzungen mehr.
<!-- lang:es -->
### Novedades
- Al rechazar una solicitud de herramienta de Claude u OpenCode puedes añadir un motivo, y el agente continúa teniendo en cuenta tu comentario.
- «Enviar ahora» inserta un mensaje de la cola en el turno en curso (en los agentes que lo admiten; en los demás el botón aparece desactivado).
- Al alcanzar un límite de uso, la app puede cambiar automáticamente a otra cuenta del mismo agente. Se activa por agente.
- Devin ofrece ahora su propio modo de planificación.
- En el móvil, una pestaña se vuelve ámbar cuando te espera y verde cuando su chat ha terminado en segundo plano.
- Los textos de la interfaz que faltaban por traducir ya están en los 12 idiomas.

### Correcciones
- Los agentes responden en el idioma de la app en cada turno, no solo en el primero.
- Los errores, avisos y resultados de Claude, Codex, OpenCode, Devin, Cursor, Antigravity y Command Code se muestran una sola vez, de forma legible, y se guardan en el historial.
- Los modos de permisos se aplican al instante y solo muestran los que cada agente admite de verdad.
- Las notificaciones de escritorio funcionan en Linux, Windows y la web.
- La instalación de agentes, el inicio de sesión, la terminal y las rutas funcionan cuando el servidor corre en Windows.
- Los paneles abiertos se mantienen sincronizados entre dispositivos y el navegador integrado ya no deja sesiones de Chromium abiertas.
<!-- lang:fr -->
### Nouveautés
- Quand vous refusez une demande d'outil de Claude ou d'OpenCode, vous pouvez indiquer une raison : l'agent continue en tenant compte de votre retour.
- « Envoyer maintenant » insère un message de la file d'attente dans le tour en cours (pour les agents qui le prennent en charge ; sinon le bouton est grisé).
- Quand une limite d'utilisation est atteinte, l'app peut passer automatiquement à un autre compte du même agent. Activable agent par agent.
- Devin propose désormais son propre mode plan.
- Sur mobile, un onglet passe à l'ambre quand il vous attend et au vert quand son chat est terminé en arrière-plan.
- Les derniers textes non traduits de l'interface sont disponibles dans les 12 langues.

### Corrections
- Les agents répondent dans la langue de l'app à chaque tour, pas seulement au premier.
- Les erreurs, notifications et résultats de Claude, Codex, OpenCode, Devin, Cursor, Antigravity et Command Code s'affichent une seule fois, lisiblement, et restent dans l'historique.
- Les modes d'autorisation s'appliquent immédiatement et n'affichent que ceux que chaque agent prend vraiment en charge.
- Les notifications de bureau fonctionnent sous Linux, Windows et sur le web.
- L'installation des agents, la connexion, le terminal et les chemins fonctionnent quand le serveur tourne sous Windows.
- Les panneaux ouverts restent synchronisés entre appareils, et le navigateur intégré ne laisse plus de sessions Chromium ouvertes.
<!-- lang:it -->
### Novità
- Quando rifiuti una richiesta di strumento di Claude o OpenCode puoi aggiungere un motivo: l'agente prosegue tenendo conto del tuo feedback.
- «Invia ora» inserisce un messaggio in coda nel turno in corso (per gli agenti che lo supportano; altrimenti il pulsante è disattivato).
- Al raggiungimento di un limite di utilizzo l'app può passare automaticamente a un altro account dello stesso agente. Si attiva per singolo agente.
- Devin offre ora la propria modalità piano.
- Su mobile una scheda diventa ambra quando ti aspetta e verde quando la sua chat è terminata in background.
- I testi dell'interfaccia ancora non tradotti sono ora disponibili in tutte le 12 lingue.

### Correzioni
- Gli agenti rispondono nella lingua dell'app a ogni turno, non solo al primo.
- Errori, avvisi ed esiti di Claude, Codex, OpenCode, Devin, Cursor, Antigravity e Command Code vengono mostrati una sola volta, in modo leggibile, e restano nella cronologia.
- Le modalità di autorizzazione si applicano subito e mostrano solo quelle che ogni agente supporta davvero.
- Le notifiche desktop funzionano su Linux, Windows e web.
- Installazione degli agenti, accesso, terminale e percorsi funzionano quando il server gira su Windows.
- I pannelli aperti restano sincronizzati tra i dispositivi e il browser integrato non lascia più sessioni Chromium aperte.
<!-- lang:ja -->
### 新機能
- Claude または OpenCode のツール要求を拒否するときに理由を添えられるようになり、エージェントはそのフィードバックを踏まえて作業を続けます。
- 「今すぐ送信」で、キューのメッセージを実行中のターンに差し込めます（対応エージェントのみ。非対応の場合はボタンがグレー表示になります）。
- 使用上限に達したとき、同じエージェントの別アカウントへ自動で切り替えられます。エージェントごとに設定できます。
- Devin 独自のプランモードが使えるようになりました。
- モバイルでは、入力待ちのタブがアンバー、バックグラウンドのチャットが完了したタブが緑で表示されます。
- 未翻訳だった UI の文言が 12 言語すべてで表示されるようになりました。

### バグ修正
- エージェントが最初のターンだけでなく、毎ターンアプリの言語で返答するようになりました。
- Claude、Codex、OpenCode、Devin、Cursor、Antigravity、Command Code のエラー・通知・実行結果が一度だけ読みやすく表示され、履歴にも残ります。
- 権限モードがすぐに反映され、各エージェントが実際に対応しているモードだけが表示されます。
- Linux、Windows、Web でデスクトップ通知が動作します。
- サーバーが Windows 上で動いている場合も、エージェントのインストール、ログイン、ターミナル、パスが正しく動作します。
- 開いているペインがデバイス間で同期され、内蔵ブラウザーが Chromium セッションを残さなくなりました。
<!-- lang:ko -->
### 새로운 기능
- Claude 또는 OpenCode의 도구 요청을 거부할 때 이유를 적을 수 있으며, 에이전트는 그 피드백을 반영해 작업을 이어갑니다.
- '지금 보내기'로 대기열의 메시지를 진행 중인 턴에 넣을 수 있습니다(지원하는 에이전트만, 그 외에는 버튼이 비활성화됩니다).
- 사용 한도에 도달하면 같은 에이전트의 다른 계정으로 자동 전환할 수 있습니다. 에이전트별로 설정합니다.
- Devin 자체의 계획 모드를 사용할 수 있습니다.
- 모바일에서 입력을 기다리는 탭은 호박색, 백그라운드 채팅이 끝난 탭은 초록색으로 표시됩니다.
- 번역되지 않았던 나머지 UI 문구가 12개 언어 모두로 제공됩니다.

### 버그 수정
- 에이전트가 첫 턴뿐 아니라 매 턴 앱 언어로 답합니다.
- Claude, Codex, OpenCode, Devin, Cursor, Antigravity, Command Code의 오류·알림·실행 결과가 한 번만 읽기 쉽게 표시되고 기록에 남습니다.
- 권한 모드가 즉시 적용되며 각 에이전트가 실제로 지원하는 모드만 표시됩니다.
- Linux, Windows, 웹에서 데스크톱 알림이 동작합니다.
- 서버가 Windows에서 실행될 때도 에이전트 설치, 로그인, 터미널, 경로가 정상 동작합니다.
- 열린 창이 기기 간에 동기화되고, 내장 브라우저가 더 이상 Chromium 세션을 남기지 않습니다.
<!-- lang:ru -->
### Что нового
- Отклоняя запрос инструмента от Claude или OpenCode, можно указать причину — агент продолжит работу с учётом вашего ответа.
- «Отправить сейчас» вставляет сообщение из очереди в текущий ход (у агентов с поддержкой этой функции; у остальных кнопка неактивна).
- При достижении лимита использования приложение может автоматически переключиться на другой аккаунт того же агента. Включается отдельно для каждого агента.
- У Devin появился собственный режим планирования.
- На телефоне вкладка становится янтарной, когда ждёт вас, и зелёной, когда её чат завершился в фоне.
- Оставшиеся непереведённые тексты интерфейса теперь доступны на всех 12 языках.

### Исправления
- Агенты отвечают на языке приложения в каждом ходе, а не только в первом.
- Ошибки, уведомления и результаты запусков Claude, Codex, OpenCode, Devin, Cursor, Antigravity и Command Code показываются один раз, понятно, и сохраняются в истории.
- Режимы разрешений применяются сразу и показывают только те, что агент действительно поддерживает.
- Системные уведомления работают в Linux, Windows и веб-версии.
- Установка агентов, вход, терминал и пути работают, когда сервер запущен в Windows.
- Открытые панели синхронизируются между устройствами, а встроенный браузер больше не оставляет сессии Chromium.
<!-- lang:tr -->
### Yenilikler
- Claude veya OpenCode'un araç isteğini reddederken bir neden ekleyebilirsiniz; ajan geri bildiriminizi dikkate alarak devam eder.
- "Şimdi gönder", kuyruktaki mesajı devam eden tura ekler (destekleyen ajanlarda; diğerlerinde düğme soluk görünür).
- Kullanım sınırına ulaşıldığında uygulama aynı ajanın başka bir hesabına otomatik geçebilir. Her ajan için ayrı açılır.
- Devin artık kendi plan modunu sunuyor.
- Mobilde sizi bekleyen sekme kehribar, arka planda sohbeti biten sekme yeşil olur.
- Arayüzün çevrilmemiş kalan metinleri artık 12 dilin tamamında mevcut.

### Hata düzeltmeleri
- Ajanlar yalnızca ilk turda değil, her turda uygulamanın dilinde yanıt verir.
- Claude, Codex, OpenCode, Devin, Cursor, Antigravity ve Command Code'un hataları, bildirimleri ve çalışma sonuçları bir kez, okunaklı şekilde gösterilir ve geçmişte kalır.
- İzin modları hemen uygulanır ve yalnızca her ajanın gerçekten desteklediği modlar gösterilir.
- Masaüstü bildirimleri Linux, Windows ve web'de çalışır.
- Sunucu Windows'ta çalışırken ajan kurulumu, giriş, terminal ve dosya yolları düzgün çalışır.
- Açık paneller cihazlar arasında senkron kalır; yerleşik tarayıcı artık Chromium oturumu bırakmaz.
<!-- lang:zh-CN -->
### 新功能
- 拒绝 Claude 或 OpenCode 的工具请求时可以填写原因，智能体会根据你的反馈继续工作。
- “立即发送”可将队列中的消息插入正在进行的轮次（仅限支持的智能体，其他智能体的按钮显示为灰色）。
- 达到用量上限时，可自动切换到同一智能体的另一个账号，按智能体单独开启。
- Devin 现在提供自己的计划模式。
- 在手机上，等待你操作的标签显示为琥珀色，后台对话已完成的标签显示为绿色。
- 界面中剩余未翻译的文字现已支持全部 12 种语言。

### 问题修复
- 智能体在每一轮都使用应用语言回复，而不仅是第一轮。
- Claude、Codex、OpenCode、Devin、Cursor、Antigravity 和 Command Code 的错误、通知和运行结果只显示一次、清晰易读，并保留在历史记录中。
- 权限模式立即生效，且只显示各智能体真正支持的模式。
- 桌面通知可在 Linux、Windows 和网页版上使用。
- 服务器运行在 Windows 上时，智能体安装、登录、终端和路径均可正常工作。
- 打开的面板在设备间保持同步，内置浏览器不再残留 Chromium 会话。
<!-- lang:zh-TW -->
### 新功能
- 拒絕 Claude 或 OpenCode 的工具請求時可以填寫原因，代理會根據你的回饋繼續工作。
- 「立即傳送」可將佇列中的訊息插入進行中的回合（僅限支援的代理，其他代理的按鈕會呈灰色）。
- 達到用量上限時，可自動切換到同一代理的另一個帳號，依代理個別開啟。
- Devin 現在提供自己的計畫模式。
- 在手機上，等待你操作的分頁會顯示為琥珀色，背景對話已完成的分頁會顯示為綠色。
- 介面中剩餘未翻譯的文字現已支援全部 12 種語言。

### 問題修正
- 代理在每一回合都使用應用程式語言回覆，而不只是第一回合。
- Claude、Codex、OpenCode、Devin、Cursor、Antigravity 和 Command Code 的錯誤、通知和執行結果只顯示一次、清楚易讀，並保留在歷史記錄中。
- 權限模式立即生效，且只顯示各代理真正支援的模式。
- 桌面通知可在 Linux、Windows 和網頁版上使用。
- 伺服器在 Windows 上執行時，代理安裝、登入、終端機和路徑皆可正常運作。
- 開啟的窗格在裝置間保持同步，內建瀏覽器不再殘留 Chromium 工作階段。
