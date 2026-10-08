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
- Background work is visible: a pill above the composer shows how many subagents and background shells are still running, and the turns they start when they report back stream live in the chat.
- Messages you send while Claude subagents are still working go into the same live session instead of interrupting them.
- Settings → About → Restart now shows its progress and confirms that the server really came back.
- Tool permission asks offer a working "Always" answer.
- Agent cards show the signed-in account's email; Claude's model-specific weekly limits are tracked, and the Claude model list comes straight from the CLI.
- Settings: a CLI update button per agent and a logout that clears stored agent credentials.
- Favorite models are stored on the server, and pasted images get a preview in the composer.
- Rewritten README and guides in all 12 languages, with new screenshots.

### Bug fixes
- Claude subagents working in the background no longer lose their permission asks ("Stream closed"), and their asks reach the chat even after the turn has finished.
- The installer script installs the newest release instead of the oldest.
- Live chat: Cursor, Codex and OpenCode tool calls stream live and are no longer duplicated after a refresh; subagent activity and Agent results come back after a reload; edit diffs and very large tool inputs render properly.
- Permissions: a call you denied or edited is never approved, unanswered asks say why they closed, and multi-select answers keep every selection.
<!-- lang:pl -->
### Nowości
- Praca w tle jest widoczna: pigułka nad polem wiadomości pokazuje, ile subagentów i poleceń w tle wciąż działa, a tury, które uruchamiają po zakończeniu, pojawiają się w czacie na żywo.
- Wiadomości wysłane, gdy subagenty Claude jeszcze pracują, trafiają do tej samej sesji zamiast je przerywać.
- Ustawienia → O aplikacji → Restart pokazuje teraz postęp i potwierdza, że serwer naprawdę wrócił.
- Pytania o zgodę na narzędzia mają działającą odpowiedź „Zawsze”.
- Karty agentów pokazują e-mail zalogowanego konta; śledzone są tygodniowe limity Claude dla poszczególnych modeli, a lista modeli Claude pochodzi bezpośrednio z CLI.
- Ustawienia: przycisk aktualizacji CLI dla każdego agenta oraz wylogowanie, które usuwa zapisane dane logowania agenta.
- Ulubione modele są zapisywane na serwerze, a wklejone obrazy mają podgląd w polu wiadomości.
- Nowe README i przewodniki we wszystkich 12 językach, z nowymi zrzutami ekranu.

### Poprawki błędów
- Subagenty Claude pracujące w tle nie tracą już pytań o zgodę („Stream closed”), a ich pytania docierają do czatu także po zakończeniu tury.
- Skrypt instalacyjny instaluje najnowsze wydanie zamiast najstarszego.
- Czat na żywo: wywołania narzędzi Cursor, Codex i OpenCode są strumieniowane na bieżąco i nie dublują się po odświeżeniu; aktywność subagentów i wyniki Agenta wracają po przeładowaniu; diffy edycji i bardzo duże wejścia narzędzi wyświetlają się poprawnie.
- Zgody: odrzucone lub edytowane wywołanie nigdy nie zostaje zatwierdzone, nieodpowiedziane pytania mówią, dlaczego się zamknęły, a odpowiedzi wielokrotnego wyboru zachowują wszystkie zaznaczenia.
<!-- lang:de -->
### Neu
- Hintergrundarbeit ist sichtbar: Eine Anzeige über dem Eingabefeld zeigt, wie viele Subagenten und Hintergrund-Shells noch laufen, und die Runden, die sie beim Zurückmelden starten, erscheinen live im Chat.
- Nachrichten, die du sendest, während Claude-Subagenten noch arbeiten, landen in derselben laufenden Sitzung, statt sie zu unterbrechen.
- Einstellungen → Über → Neustart zeigt jetzt den Fortschritt und bestätigt, dass der Server wirklich wieder da ist.
- Berechtigungsanfragen für Tools bieten eine funktionierende Antwort „Immer“.
- Agentenkarten zeigen die E-Mail des angemeldeten Kontos; Claudes modellspezifische Wochenlimits werden erfasst, und die Claude-Modellliste kommt direkt aus der CLI.
- Einstellungen: ein CLI-Update-Button pro Agent und eine Abmeldung, die gespeicherte Agent-Anmeldedaten löscht.
- Favorisierte Modelle werden auf dem Server gespeichert, und eingefügte Bilder bekommen eine Vorschau im Eingabefeld.
- Überarbeitete README und Anleitungen in allen 12 Sprachen, mit neuen Screenshots.

### Fehlerbehebungen
- Claude-Subagenten im Hintergrund verlieren ihre Berechtigungsanfragen nicht mehr („Stream closed“), und ihre Anfragen erreichen den Chat auch nach dem Ende der Runde.
- Das Installationsskript installiert die neueste statt der ältesten Version.
- Live-Chat: Tool-Aufrufe von Cursor, Codex und OpenCode werden live gestreamt und nach einer Aktualisierung nicht mehr doppelt angezeigt; Subagenten-Aktivität und Agent-Ergebnisse sind nach dem Neuladen wieder da; Edit-Diffs und sehr große Tool-Eingaben werden korrekt dargestellt.
- Berechtigungen: Ein abgelehnter oder bearbeiteter Aufruf wird nie genehmigt, unbeantwortete Anfragen nennen den Grund für ihr Schließen, und Mehrfachauswahl-Antworten behalten jede Auswahl.
<!-- lang:es -->
### Novedades
- El trabajo en segundo plano es visible: un indicador sobre el campo de mensaje muestra cuántos subagentes y shells en segundo plano siguen en marcha, y los turnos que inician al informar aparecen en directo en el chat.
- Los mensajes que envías mientras los subagentes de Claude siguen trabajando entran en la misma sesión activa en lugar de interrumpirlos.
- Ajustes → Acerca de → Reiniciar ahora muestra el progreso y confirma que el servidor ha vuelto de verdad.
- Las solicitudes de permiso para herramientas ofrecen una respuesta «Siempre» que funciona.
- Las tarjetas de agentes muestran el correo de la cuenta conectada; se controlan los límites semanales por modelo de Claude, y la lista de modelos de Claude se obtiene directamente de la CLI.
- Ajustes: un botón para actualizar la CLI de cada agente y un cierre de sesión que borra las credenciales guardadas del agente.
- Los modelos favoritos se guardan en el servidor y las imágenes pegadas tienen vista previa en el campo de mensaje.
- README y guías reescritas en los 12 idiomas, con capturas nuevas.

### Correcciones
- Los subagentes de Claude que trabajan en segundo plano ya no pierden sus solicitudes de permiso («Stream closed»), y sus solicitudes llegan al chat incluso después de terminar el turno.
- El script de instalación instala la versión más reciente en lugar de la más antigua.
- Chat en directo: las llamadas a herramientas de Cursor, Codex y OpenCode se transmiten en directo y ya no se duplican al refrescar; la actividad de los subagentes y los resultados de Agent vuelven tras recargar; los diffs de edición y las entradas de herramientas muy grandes se muestran correctamente.
- Permisos: una llamada que denegaste o editaste nunca se aprueba, las solicitudes sin responder indican por qué se cerraron y las respuestas de selección múltiple conservan todas las opciones.
<!-- lang:fr -->
### Nouveautés
- Le travail en arrière-plan est visible : un indicateur au-dessus de la zone de saisie affiche combien de sous-agents et de shells en arrière-plan tournent encore, et les tours qu'ils lancent en rendant compte s'affichent en direct dans le chat.
- Les messages envoyés pendant que les sous-agents Claude travaillent encore rejoignent la même session active au lieu de les interrompre.
- Paramètres → À propos → Redémarrer affiche désormais la progression et confirme que le serveur est bien revenu.
- Les demandes d'autorisation d'outil proposent une réponse « Toujours » qui fonctionne.
- Les cartes d'agent affichent l'e-mail du compte connecté ; les limites hebdomadaires par modèle de Claude sont suivies, et la liste des modèles Claude vient directement de la CLI.
- Paramètres : un bouton de mise à jour de la CLI pour chaque agent et une déconnexion qui efface les identifiants enregistrés de l'agent.
- Les modèles favoris sont enregistrés sur le serveur et les images collées ont un aperçu dans la zone de saisie.
- README et guides réécrits dans les 12 langues, avec de nouvelles captures d'écran.

### Corrections
- Les sous-agents Claude en arrière-plan ne perdent plus leurs demandes d'autorisation (« Stream closed »), et ces demandes arrivent dans le chat même après la fin du tour.
- Le script d'installation installe la version la plus récente au lieu de la plus ancienne.
- Chat en direct : les appels d'outils de Cursor, Codex et OpenCode sont diffusés en direct et ne sont plus dupliqués après un rafraîchissement ; l'activité des sous-agents et les résultats d'Agent reviennent après un rechargement ; les diffs d'édition et les très grandes entrées d'outils s'affichent correctement.
- Autorisations : un appel refusé ou modifié n'est jamais approuvé, les demandes restées sans réponse indiquent pourquoi elles se sont fermées, et les réponses à choix multiples conservent chaque sélection.
<!-- lang:it -->
### Novità
- Il lavoro in background è visibile: un indicatore sopra il campo di testo mostra quanti subagenti e shell in background sono ancora in esecuzione, e i turni che avviano quando riferiscono appaiono in tempo reale nella chat.
- I messaggi inviati mentre i subagenti di Claude stanno ancora lavorando entrano nella stessa sessione attiva invece di interromperli.
- Impostazioni → Informazioni → Riavvia ora mostra l'avanzamento e conferma che il server è davvero tornato.
- Le richieste di permesso per gli strumenti offrono una risposta «Sempre» funzionante.
- Le schede degli agenti mostrano l'email dell'account connesso; vengono monitorati i limiti settimanali per modello di Claude, e l'elenco dei modelli Claude arriva direttamente dalla CLI.
- Impostazioni: un pulsante per aggiornare la CLI di ogni agente e un logout che cancella le credenziali salvate dell'agente.
- I modelli preferiti sono salvati sul server e le immagini incollate hanno un'anteprima nel campo di testo.
- README e guide riscritti in tutte le 12 lingue, con nuovi screenshot.

### Correzioni
- I subagenti di Claude in background non perdono più le richieste di permesso («Stream closed»), e le loro richieste arrivano nella chat anche dopo la fine del turno.
- Lo script di installazione installa la release più recente invece della più vecchia.
- Chat in tempo reale: le chiamate agli strumenti di Cursor, Codex e OpenCode vengono trasmesse in diretta e non si duplicano più dopo un aggiornamento; l'attività dei subagenti e i risultati di Agent tornano dopo un ricaricamento; i diff delle modifiche e gli input molto grandi degli strumenti vengono mostrati correttamente.
- Permessi: una chiamata negata o modificata non viene mai approvata, le richieste senza risposta spiegano perché si sono chiuse e le risposte a scelta multipla mantengono ogni selezione.
<!-- lang:ja -->
### 新機能
- バックグラウンドの作業が見えるようになりました。入力欄の上に、まだ動いているサブエージェントやバックグラウンドシェルの数が表示され、それらが報告のために開始するターンはチャットにリアルタイムで表示されます。
- Claude のサブエージェントが作業中に送ったメッセージは、作業を中断せずに同じセッションへ送られます。
- 設定 → このアプリについて → 再起動 で進行状況が表示され、サーバーが本当に復帰したことを確認できるようになりました。
- ツールの許可リクエストで「常に許可」が正しく機能するようになりました。
- エージェントカードにサインイン中のアカウントのメールアドレスを表示。Claude のモデル別の週間上限を追跡し、Claude のモデル一覧は CLI から直接取得します。
- 設定：エージェントごとの CLI 更新ボタンと、保存されたエージェントの認証情報を削除するログアウトを追加。
- お気に入りのモデルはサーバーに保存され、貼り付けた画像は入力欄でプレビューされます。
- README とガイドを全 12 言語で書き直し、スクリーンショットも新しくしました。

### バグ修正
- バックグラウンドで動く Claude のサブエージェントが許可リクエストを失わなくなりました（「Stream closed」）。ターン終了後のリクエストもチャットに届きます。
- インストールスクリプトが最も古いリリースではなく最新のリリースをインストールするようになりました。
- ライブチャット：Cursor、Codex、OpenCode のツール呼び出しがリアルタイムで表示され、更新後に重複しなくなりました。再読み込み後もサブエージェントの活動と Agent の結果が復元され、編集の差分や非常に大きなツール入力も正しく表示されます。
- 許可：拒否または編集した呼び出しが承認されることはなくなり、未回答のリクエストは閉じた理由を表示し、複数選択の回答はすべての選択を保持します。
<!-- lang:ko -->
### 새 기능
- 백그라운드 작업이 보입니다. 입력창 위 표시줄에 아직 실행 중인 서브에이전트와 백그라운드 셸 수가 나타나고, 이들이 결과를 보고하며 시작하는 턴은 채팅에 실시간으로 표시됩니다.
- Claude 서브에이전트가 작업 중일 때 보낸 메시지는 작업을 중단시키지 않고 같은 세션으로 전달됩니다.
- 설정 → 정보 → 재시작에서 진행 상황을 보여 주고 서버가 실제로 다시 실행되었는지 확인합니다.
- 도구 권한 요청에서 '항상 허용'이 제대로 동작합니다.
- 에이전트 카드에 로그인한 계정의 이메일이 표시됩니다. Claude 모델별 주간 한도를 추적하고, Claude 모델 목록은 CLI에서 바로 가져옵니다.
- 설정: 에이전트별 CLI 업데이트 버튼과 저장된 에이전트 자격 증명을 지우는 로그아웃이 추가되었습니다.
- 즐겨찾는 모델이 서버에 저장되고, 붙여 넣은 이미지를 입력창에서 미리 볼 수 있습니다.
- README와 가이드를 12개 언어 모두 새로 쓰고 스크린샷도 새로 바꿨습니다.

### 버그 수정
- 백그라운드에서 작업하는 Claude 서브에이전트가 더 이상 권한 요청을 잃지 않으며('Stream closed'), 턴이 끝난 뒤의 요청도 채팅에 전달됩니다.
- 설치 스크립트가 가장 오래된 릴리스가 아닌 최신 릴리스를 설치합니다.
- 실시간 채팅: Cursor, Codex, OpenCode의 도구 호출이 실시간으로 표시되고 새로 고침 후 중복되지 않습니다. 다시 불러온 뒤에도 서브에이전트 활동과 Agent 결과가 복원되며, 편집 diff와 매우 큰 도구 입력도 올바르게 표시됩니다.
- 권한: 거부하거나 수정한 호출은 절대 승인되지 않고, 답하지 않은 요청은 닫힌 이유를 알려 주며, 다중 선택 답변은 모든 선택을 유지합니다.
<!-- lang:ru -->
### Что нового
- Фоновая работа теперь видна: индикатор над полем ввода показывает, сколько субагентов и фоновых команд ещё выполняется, а ходы, которые они начинают, отчитываясь о результате, появляются в чате в реальном времени.
- Сообщения, отправленные, пока субагенты Claude ещё работают, попадают в ту же активную сессию и не прерывают их.
- Настройки → О приложении → Перезапуск теперь показывает ход перезапуска и подтверждает, что сервер действительно вернулся.
- В запросах разрешений для инструментов работает ответ «Всегда».
- На карточках агентов отображается e-mail вошедшей учётной записи; отслеживаются недельные лимиты Claude для отдельных моделей, а список моделей Claude берётся прямо из CLI.
- Настройки: кнопка обновления CLI для каждого агента и выход, удаляющий сохранённые учётные данные агента.
- Избранные модели хранятся на сервере, а у вставленных изображений есть предпросмотр в поле ввода.
- README и руководства переписаны на всех 12 языках, с новыми снимками экрана.

### Исправления
- Субагенты Claude, работающие в фоне, больше не теряют запросы разрешений («Stream closed»), и их запросы доходят до чата даже после завершения хода.
- Скрипт установки ставит самый новый релиз, а не самый старый.
- Чат в реальном времени: вызовы инструментов Cursor, Codex и OpenCode отображаются сразу и не дублируются после обновления; активность субагентов и результаты Agent восстанавливаются после перезагрузки; диффы правок и очень большие входные данные инструментов отображаются корректно.
- Разрешения: отклонённый или изменённый вызов никогда не одобряется, запросы без ответа сообщают, почему закрылись, а ответы с множественным выбором сохраняют все выбранные варианты.
<!-- lang:tr -->
### Yenilikler
- Arka plan işleri artık görünüyor: mesaj alanının üstündeki gösterge hâlâ çalışan alt ajanların ve arka plan kabuklarının sayısını gösterir; bunların rapor verirken başlattığı turlar sohbette canlı görünür.
- Claude alt ajanları çalışırken gönderdiğiniz mesajlar onları kesmek yerine aynı etkin oturuma gider.
- Ayarlar → Hakkında → Yeniden başlat artık ilerlemeyi gösterir ve sunucunun gerçekten geri geldiğini doğrular.
- Araç izin isteklerinde çalışan bir "Her zaman" yanıtı var.
- Ajan kartları oturum açılmış hesabın e-postasını gösterir; Claude'un modele özgü haftalık sınırları izlenir ve Claude model listesi doğrudan CLI'dan gelir.
- Ayarlar: her ajan için CLI güncelleme düğmesi ve kayıtlı ajan kimlik bilgilerini silen oturum kapatma.
- Favori modeller sunucuda saklanır, yapıştırılan görsellerin mesaj alanında önizlemesi olur.
- README ve kılavuzlar 12 dilin hepsinde yeniden yazıldı, yeni ekran görüntüleriyle.

### Hata düzeltmeleri
- Arka planda çalışan Claude alt ajanları artık izin isteklerini kaybetmiyor ("Stream closed") ve istekleri tur bittikten sonra da sohbete ulaşıyor.
- Kurulum betiği en eski sürüm yerine en yeni sürümü kurar.
- Canlı sohbet: Cursor, Codex ve OpenCode araç çağrıları canlı akar ve yenilemeden sonra yinelenmez; alt ajan etkinliği ve Agent sonuçları yeniden yüklemeden sonra geri gelir; düzenleme farkları ve çok büyük araç girdileri doğru görüntülenir.
- İzinler: reddettiğiniz veya düzenlediğiniz bir çağrı asla onaylanmaz, yanıtlanmayan istekler neden kapandığını söyler ve çoklu seçim yanıtları tüm seçimleri korur.
<!-- lang:zh-CN -->
### 新功能
- 后台工作现在可见：输入框上方的提示条会显示仍在运行的子代理和后台 shell 数量，它们汇报结果时启动的回合会实时显示在聊天中。
- 在 Claude 子代理仍在工作时发送的消息会进入同一个运行中的会话，而不会打断它们。
- 设置 → 关于 → 重启 现在会显示进度，并确认服务器确实已恢复。
- 工具权限请求提供可用的“始终允许”选项。
- 代理卡片显示已登录账户的邮箱；会跟踪 Claude 各模型的每周限额，Claude 模型列表直接从 CLI 获取。
- 设置：每个代理都有 CLI 更新按钮，以及可清除已保存代理凭据的退出登录。
- 收藏的模型保存在服务器上，粘贴的图片会在输入框中显示预览。
- README 和指南已用全部 12 种语言重写，并配有新截图。

### 问题修复
- 在后台工作的 Claude 子代理不再丢失权限请求（“Stream closed”），回合结束后的请求也能送达聊天。
- 安装脚本会安装最新版本，而不是最旧版本。
- 实时聊天：Cursor、Codex 和 OpenCode 的工具调用实时显示，刷新后不再重复；重新加载后会恢复子代理活动和 Agent 结果；编辑差异和超大的工具输入都能正确显示。
- 权限：你拒绝或修改过的调用绝不会被批准，未回答的请求会说明关闭原因，多选回答会保留所有选项。
<!-- lang:zh-TW -->
### 新功能
- 背景工作現在看得到：輸入框上方的提示列會顯示仍在執行的子代理與背景 shell 數量，它們回報結果時啟動的回合會即時顯示在聊天中。
- 在 Claude 子代理仍在工作時傳送的訊息，會進入同一個執行中的工作階段，而不會中斷它們。
- 設定 → 關於 → 重新啟動 現在會顯示進度，並確認伺服器確實已恢復。
- 工具權限請求提供可正常運作的「一律允許」選項。
- 代理卡片會顯示已登入帳號的電子郵件；會追蹤 Claude 各模型的每週上限，Claude 模型清單直接從 CLI 取得。
- 設定：每個代理都有 CLI 更新按鈕，以及可清除已儲存代理憑證的登出功能。
- 最愛的模型會儲存在伺服器上，貼上的圖片會在輸入框中顯示預覽。
- README 與指南已以全部 12 種語言改寫，並附上新的螢幕截圖。

### 錯誤修正
- 在背景工作的 Claude 子代理不再遺失權限請求（「Stream closed」），回合結束後的請求也能送達聊天。
- 安裝指令碼會安裝最新版本，而不是最舊版本。
- 即時聊天：Cursor、Codex 與 OpenCode 的工具呼叫會即時顯示，重新整理後不再重複；重新載入後會還原子代理活動與 Agent 結果；編輯差異與非常大的工具輸入都能正確顯示。
- 權限：你拒絕或修改過的呼叫絕不會被核准，未回答的請求會說明關閉原因，多選回答會保留所有選項。
