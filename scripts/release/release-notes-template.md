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
- Limit auto-switch now continues the interrupted turn: when an account hits its usage limit mid-turn and the session moves to another account, the work resumes there on its own — no need to press Retry or re-send. At most 3 automatic continuations per session per hour; a turn you stopped yourself is never continued.
### Bug fixes
- The current Claude Code limit message (“You've hit your session limit”, “…weekly limit”) is now recognised as a usage limit.
<!-- lang:pl -->
### Nowości
- Automatyczne przełączanie konta po limicie kontynuuje teraz przerwaną turę: gdy konto wyczerpie limit w trakcie pracy i sesja przejdzie na inne konto, praca wznawia się tam sama — bez klikania „Ponów” i ponownego wysyłania. Maksymalnie 3 automatyczne kontynuacje na sesję na godzinę; tura zatrzymana ręcznie nigdy nie jest kontynuowana.
### Poprawki
- Aktualny komunikat limitu Claude Code („You've hit your session limit”, „…weekly limit”) jest teraz rozpoznawany jako limit użycia.
<!-- lang:de -->
### Neu
- Der automatische Kontowechsel bei Limits setzt jetzt den unterbrochenen Durchlauf fort: Erreicht ein Konto mitten in der Arbeit sein Nutzungslimit und wechselt die Sitzung auf ein anderes Konto, läuft die Arbeit dort von selbst weiter — ohne „Erneut versuchen“ oder erneutes Senden. Höchstens 3 automatische Fortsetzungen pro Sitzung und Stunde; ein von dir gestoppter Durchlauf wird nie fortgesetzt.
### Fehlerbehebungen
- Die aktuelle Limit-Meldung von Claude Code („You've hit your session limit“, „…weekly limit“) wird jetzt als Nutzungslimit erkannt.
<!-- lang:es -->
### Novedades
- El cambio automático de cuenta por límite ahora continúa el turno interrumpido: cuando una cuenta alcanza su límite de uso a mitad de trabajo y la sesión pasa a otra cuenta, el trabajo se reanuda allí por sí solo, sin pulsar «Reintentar» ni volver a enviar. Como máximo 3 continuaciones automáticas por sesión y hora; un turno que detuviste tú nunca se continúa.
### Correcciones
- El mensaje de límite actual de Claude Code («You've hit your session limit», «…weekly limit») ahora se reconoce como límite de uso.
<!-- lang:fr -->
### Nouveautés
- Le changement automatique de compte en cas de limite reprend désormais le tour interrompu : quand un compte atteint sa limite d'utilisation en plein travail et que la session passe sur un autre compte, le travail y reprend tout seul — sans cliquer sur « Réessayer » ni renvoyer le message. Au maximum 3 reprises automatiques par session et par heure ; un tour que vous avez arrêté n'est jamais repris.
### Corrections
- Le message de limite actuel de Claude Code (« You've hit your session limit », « …weekly limit ») est désormais reconnu comme une limite d'utilisation.
<!-- lang:it -->
### Novità
- Il cambio automatico di account al limite ora prosegue il turno interrotto: quando un account raggiunge il limite di utilizzo durante il lavoro e la sessione passa a un altro account, il lavoro riprende lì da solo, senza premere «Riprova» né reinviare. Al massimo 3 continuazioni automatiche per sessione all'ora; un turno interrotto da te non viene mai proseguito.
### Correzioni
- L'attuale messaggio di limite di Claude Code («You've hit your session limit», «…weekly limit») ora viene riconosciuto come limite di utilizzo.
<!-- lang:ja -->
### 新機能
- 上限到達時の自動アカウント切り替えで、中断されたターンを自動的に再開するようになりました。作業中にアカウントが使用上限に達してセッションが別のアカウントに移ると、「再試行」や再送信なしでそのまま作業が続きます。自動再開はセッションごとに1時間あたり最大3回で、自分で停止したターンは再開されません。
### バグ修正
- 現在の Claude Code の上限メッセージ（「You've hit your session limit」「…weekly limit」）を使用上限として認識するようになりました。
<!-- lang:ko -->
### 새 기능
- 한도 도달 시 자동 계정 전환이 이제 중단된 턴을 이어서 진행합니다. 작업 중 계정이 사용 한도에 도달해 세션이 다른 계정으로 옮겨지면, ‘다시 시도’나 재전송 없이 그곳에서 작업이 자동으로 재개됩니다. 자동 재개는 세션당 시간당 최대 3회이며, 직접 중지한 턴은 재개되지 않습니다.
### 버그 수정
- 현재 Claude Code의 한도 메시지(“You've hit your session limit”, “…weekly limit”)를 이제 사용 한도로 인식합니다.
<!-- lang:ru -->
### Новое
- Автоматическое переключение аккаунта при лимите теперь продолжает прерванный ход: если аккаунт исчерпал лимит посреди работы и сессия перешла на другой аккаунт, работа сама возобновляется там — без «Повторить» и повторной отправки. Не более 3 автоматических продолжений на сессию в час; ход, остановленный вами, никогда не продолжается.
### Исправления
- Текущее сообщение о лимите Claude Code («You've hit your session limit», «…weekly limit») теперь распознаётся как лимит использования.
<!-- lang:tr -->
### Yenilikler
- Limitte otomatik hesap değiştirme artık yarıda kalan turu sürdürüyor: bir hesap çalışma sırasında kullanım limitine ulaşıp oturum başka bir hesaba geçtiğinde, iş orada kendiliğinden devam eder — “Yeniden dene”ye basmanız veya yeniden göndermeniz gerekmez. Oturum başına saatte en fazla 3 otomatik devam; kendiniz durdurduğunuz bir tur asla sürdürülmez.
### Hata düzeltmeleri
- Claude Code'un güncel limit mesajı (“You've hit your session limit”, “…weekly limit”) artık kullanım limiti olarak tanınıyor.
<!-- lang:zh-CN -->
### 新功能
- 达到上限时的自动切换账号现在会继续被中断的回合：当某个账号在工作中途达到用量上限、会话切换到另一个账号后，工作会在那里自动继续——无需点击“重试”或重新发送。每个会话每小时最多自动继续 3 次；你手动停止的回合不会被继续。
### 问题修复
- 现在会将 Claude Code 当前的上限提示（“You've hit your session limit”“…weekly limit”）识别为用量上限。
<!-- lang:zh-TW -->
### 新功能
- 達到上限時的自動切換帳號現在會繼續被中斷的回合：當某個帳號在工作途中達到用量上限、工作階段切換到另一個帳號後，工作會在那裡自動繼續——不必按「重試」或重新傳送。每個工作階段每小時最多自動繼續 3 次；你手動停止的回合不會被繼續。
### 錯誤修正
- 現在會將 Claude Code 目前的上限訊息（「You've hit your session limit」「…weekly limit」）識別為用量上限。
