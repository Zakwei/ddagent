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
### Bug fixes
- After a limit account switch, the automatic “continue” message is dropped from the queue once work already resumed on the new account (your message or a turn the agent started there), instead of arriving later as a redundant prompt.
<!-- lang:pl -->
### Poprawki
- Po przełączeniu konta przy limicie automatyczna wiadomość „kontynuuj” jest usuwana z kolejki, gdy praca już ruszyła na nowym koncie (Twoja wiadomość albo tura uruchomiona tam przez agenta), zamiast przychodzić później jako zbędne polecenie.
<!-- lang:de -->
### Fehlerbehebungen
- Nach einem Kontowechsel wegen Limit wird die automatische „Weiter“-Nachricht aus der Warteschlange entfernt, sobald die Arbeit auf dem neuen Konto bereits weiterläuft (deine Nachricht oder ein dort vom Agenten gestarteter Durchlauf), statt später als überflüssige Aufforderung anzukommen.
<!-- lang:es -->
### Correcciones
- Tras cambiar de cuenta por límite, el mensaje automático «continuar» se elimina de la cola cuando el trabajo ya se reanudó en la nueva cuenta (tu mensaje o un turno que el agente inició allí), en lugar de llegar más tarde como una orden redundante.
<!-- lang:fr -->
### Corrections
- Après un changement de compte dû à une limite, le message automatique « continuer » est retiré de la file dès que le travail a déjà repris sur le nouveau compte (votre message ou un tour lancé par l'agent), au lieu d'arriver plus tard comme une consigne superflue.
<!-- lang:it -->
### Correzioni
- Dopo un cambio di account per limite, il messaggio automatico «continua» viene rimosso dalla coda quando il lavoro è già ripreso sul nuovo account (il tuo messaggio o un turno avviato lì dall'agente), invece di arrivare più tardi come richiesta superflua.
<!-- lang:ja -->
### バグ修正
- 上限による自動アカウント切り替え後、新しいアカウントで作業がすでに再開されていれば（あなたのメッセージやエージェントが開始したターン）、自動の「続行」メッセージをキューから削除し、後から不要な指示として届かないようにしました。
<!-- lang:ko -->
### 버그 수정
- 한도로 계정이 전환된 뒤 새 계정에서 이미 작업이 재개되었다면(사용자 메시지나 에이전트가 시작한 턴) 자동 ‘계속’ 메시지를 대기열에서 제거하여, 나중에 불필요한 지시로 도착하지 않습니다.
<!-- lang:ru -->
### Исправления
- После переключения аккаунта из-за лимита автоматическое сообщение «продолжить» удаляется из очереди, если работа уже возобновилась на новом аккаунте (ваше сообщение или ход, запущенный там агентом), а не приходит позже как лишняя команда.
<!-- lang:tr -->
### Hata düzeltmeleri
- Limit nedeniyle hesap değiştikten sonra, iş yeni hesapta zaten yeniden başladıysa (sizin mesajınız veya ajanın orada başlattığı bir tur) otomatik “devam et” mesajı kuyruktan kaldırılır; sonradan gereksiz bir komut olarak gelmez.
<!-- lang:zh-CN -->
### 问题修复
- 因额度切换账号后，如果工作已在新账号上恢复（你的消息或代理在那里发起的回合），自动“继续”消息会从队列中移除，而不会稍后作为多余的指令到达。
<!-- lang:zh-TW -->
### 錯誤修正
- 因額度切換帳號後，如果工作已在新帳號上恢復（你的訊息或代理在那裡發起的回合），自動「繼續」訊息會從佇列中移除，而不會稍後作為多餘的指令送達。
