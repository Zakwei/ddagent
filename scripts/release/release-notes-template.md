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
- Limits: new opt-in setting “Start Claude 5h windows early” (Limits → Config). It sends a tiny Haiku prompt to Claude accounts whose 5-hour window hasn't started yet, so the window starts counting down before you need it. The pings use very little quota and never show up in the session list.
<!-- lang:pl -->
### Nowości
- Limity: nowa opcja „Wcześniej uruchamiaj 5-godzinne okna Claude” (Limity → Config), domyślnie wyłączona. Wysyła mini zapytanie Haiku do kont Claude, których 5-godzinne okno jeszcze nie biegnie, żeby okno zaczęło odliczać, zanim będzie potrzebne. Pingi zużywają minimalnie limitu i nie pojawiają się na liście sesji.
<!-- lang:de -->
### Neu
- Limits: neue optionale Einstellung „Claude-5-Stunden-Fenster früh starten“ (Limits → Config). Sie sendet einen winzigen Haiku-Prompt an Claude-Konten, deren 5-Stunden-Fenster noch nicht begonnen hat, damit es schon vor Bedarf abläuft. Die Pings verbrauchen kaum Kontingent und erscheinen nie in der Sitzungsliste.
<!-- lang:es -->
### Novedades
- Límites: nueva opción opcional «Iniciar antes las ventanas de 5 h de Claude» (Límites → Config). Envía un mini prompt de Haiku a las cuentas de Claude cuya ventana de 5 horas aún no ha empezado, para que empiece a contar antes de necesitarla. Los pings consumen muy poca cuota y nunca aparecen en la lista de sesiones.
<!-- lang:fr -->
### Nouveautés
- Limites : nouvelle option facultative « Démarrer tôt les fenêtres de 5 h de Claude » (Limites → Config). Elle envoie une mini requête Haiku aux comptes Claude dont la fenêtre de 5 heures n'a pas commencé, pour qu'elle démarre avant que vous en ayez besoin. Ces pings consomment très peu de quota et n'apparaissent jamais dans la liste des sessions.
<!-- lang:it -->
### Novità
- Limiti: nuova opzione facoltativa «Avvia in anticipo le finestre di 5 ore di Claude» (Limiti → Config). Invia un mini prompt Haiku agli account Claude la cui finestra di 5 ore non è ancora iniziata, così parte prima che ti serva. I ping consumano pochissima quota e non compaiono mai nell'elenco delle sessioni.
<!-- lang:ja -->
### 新機能
- 利用上限：新しいオプション設定「Claude の 5 時間枠を早めに開始」（利用上限 → Config）。5 時間枠がまだ始まっていない Claude アカウントに小さな Haiku プロンプトを送り、必要になる前に枠のカウントを始めます。消費するクォータはごくわずかで、セッション一覧には表示されません。
<!-- lang:ko -->
### 새 기능
- 사용 한도: 새 선택 설정 "Claude 5시간 창 미리 시작"(사용 한도 → Config). 5시간 창이 아직 시작되지 않은 Claude 계정에 작은 Haiku 프롬프트를 보내 필요하기 전에 창이 시작되도록 합니다. 할당량을 거의 쓰지 않으며 세션 목록에 표시되지 않습니다.
<!-- lang:ru -->
### Новое
- Лимиты: новая необязательная настройка «Заранее запускать 5-часовые окна Claude» (Лимиты → Config). Она отправляет крошечный запрос Haiku аккаунтам Claude, у которых 5-часовое окно ещё не началось, чтобы отсчёт шёл заранее. Такие запросы почти не тратят лимит и не появляются в списке сессий.
<!-- lang:tr -->
### Yenilikler
- Limitler: yeni isteğe bağlı ayar "Claude 5 saatlik pencerelerini erken başlat" (Limitler → Config). 5 saatlik penceresi henüz başlamamış Claude hesaplarına küçük bir Haiku istemi göndererek pencerenin ihtiyaç duymadan önce başlamasını sağlar. Bu istekler çok az kota kullanır ve oturum listesinde hiç görünmez.
<!-- lang:zh-CN -->
### 新功能
- 用量限制：新增可选设置“提前开启 Claude 5 小时窗口”（用量限制 → Config）。它会向 5 小时窗口尚未开始的 Claude 账户发送一条极小的 Haiku 提示，让窗口在需要之前就开始计时。这些请求几乎不消耗额度，也不会出现在会话列表中。
<!-- lang:zh-TW -->
### 新功能
- 用量限制：新增選用設定「提前啟動 Claude 5 小時視窗」（用量限制 → Config）。它會向 5 小時視窗尚未開始的 Claude 帳號傳送一則極小的 Haiku 提示，讓視窗在需要之前就開始計時。這些請求幾乎不消耗額度，也不會出現在工作階段清單中。
