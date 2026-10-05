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
### What's new
- Orchestrator: iterative auto-fix and re-review loop, manual continuation, and child session handoff
- Orchestrator summaries and delegation cards now surface subcontractor findings
- Broadcast dialog: new "select orchestrators" filter button
- Animated status indicators in session views and a pinned back-to-orchestration button in the pane header

### Bug fixes
- Archived sessions stay archived and no longer mount dead chat panes
- Fixed aborted-run handling across websocket completions, queue, and dispatch
- OpenCode: resync runs after SSE reconnect and recover poisoned directory instances
- Mobile parity gaps closed (SecureStore, websocket backoff, accessibility, orchestrator cards)

<!-- lang:pl -->
### Co nowego
- Orkiestrator: iteracyjna pętla auto-napraw i ponownej weryfikacji, ręczna kontynuacja oraz przekazywanie sesji podrzędnych
- Podsumowania orkiestratora i karty delegacji pokazują teraz wyniki podwykonawców
- Okno broadcast: nowy przycisk filtra „wybierz orkiestratorów”
- Animowane wskaźniki statusu w widokach sesji i przypięty przycisk powrotu do orkiestracji w nagłówku panelu

### Poprawki
- Zarchiwizowane sesje pozostają zarchiwizowane i nie otwierają już martwych paneli czatu
- Naprawiono obsługę przerwanych uruchomień w websocketach, kolejce i dyspozytorze
- OpenCode: ponowna synchronizacja uruchomień po reconnect SSE i odzyskiwanie uszkodzonych instancji katalogów
- Zamknięto luki paritetu mobilnego (SecureStore, backoff websocket, dostępność, karty orkiestratora)

<!-- lang:de -->
### Neuigkeiten
- Orchestrator: iterativer Auto-Fix- und Re-Review-Loop, manuelle Fortsetzung und Übergabe von Kind-Sessions
- Orchestrator-Zusammenfassungen und Delegationskarten zeigen jetzt Subunternehmer-Ergebnisse
- Broadcast-Dialog: neuer Filterbutton „Orchestratoren auswählen“
- Animierte Statusindikatoren in Sitzungsansichten und angehefteter Zurück-zur-Orchestrierung-Button im Pane-Header

### Fehlerbehebungen
- Archivierte Sitzungen bleiben archiviert und öffnen keine toten Chat-Panes mehr
- Behandlung abgebrochener Runs in Websocket-Completions, Queue und Dispatch korrigiert
- OpenCode: Runs nach SSE-Reconnect neu synchronisieren und beschädigte Verzeichnisinstanzen wiederherstellen
- Mobile-Paritätslücken geschlossen (SecureStore, Websocket-Backoff, Barrierefreiheit, Orchestrator-Karten)

<!-- lang:es -->
### Novedades
- Orquestador: bucle iterativo de autocorrección y re-revisión, continuación manual y traspaso de sesiones hijas
- Los resúmenes del orquestador y las tarjetas de delegación ahora muestran los hallazgos de los subcontratistas
- Diálogo de difusión: nuevo botón de filtro «seleccionar orquestadores»
- Indicadores de estado animados en las vistas de sesión y botón fijado de volver a la orquestación en el encabezado del panel

### Correcciones
- Las sesiones archivadas permanecen archivadas y ya no montan paneles de chat inertes
- Corregido el manejo de ejecuciones abortadas en completions de websocket, cola y dispatch
- OpenCode: resincronización de ejecuciones tras reconexión SSE y recuperación de instancias de directorio dañadas
- Cerradas las brechas de paridad móvil (SecureStore, backoff de websocket, accesibilidad, tarjetas de orquestador)

<!-- lang:fr -->
### Nouveautés
- Orchestrateur : boucle itérative d'auto-correction et de re-revue, continuation manuelle et transfert de sessions enfants
- Les résumés d'orchestration et les cartes de délégation affichent désormais les résultats des sous-traitants
- Boîte de diffusion : nouveau bouton de filtre « sélectionner les orchestrateurs »
- Indicateurs de statut animés dans les vues de session et bouton épinglé de retour à l'orchestration dans l'en-tête du panneau

### Corrections
- Les sessions archivées restent archivées et n'ouvrent plus de panneaux de chat inactifs
- Correction de la gestion des exécutions interrompues dans les completions websocket, la file et le dispatch
- OpenCode : resynchronisation des exécutions après reconnexion SSE et récupération des instances de répertoire corrompues
- Écarts de parité mobile comblés (SecureStore, backoff websocket, accessibilité, cartes d'orchestrateur)

<!-- lang:it -->
### Novità
- Orchestratore: ciclo iterativo di auto-correzione e ri-revisione, continuazione manuale e passaggio di sessioni figlie
- I riepiloghi dell'orchestratore e le schede di delega ora mostrano i risultati dei subappaltatori
- Finestra broadcast: nuovo pulsante filtro «seleziona orchestratori»
- Indicatori di stato animati nelle viste di sessione e pulsante fissato per tornare all'orchestrazione nell'intestazione del pannello

### Correzioni
- Le sessioni archiviate restano archiviate e non aprono più pannelli di chat inattivi
- Corretta la gestione delle esecuzioni interrotte in completions websocket, coda e dispatch
- OpenCode: risincronizzazione delle esecuzioni dopo riconnessione SSE e recupero delle istanze di directory danneggiate
- Colmate le lacune di parità mobile (SecureStore, backoff websocket, accessibilità, schede orchestratore)

<!-- lang:ja -->
### 新機能
- オーケストレーター: 反復型の自動修正・再レビューループ、手動続行、子セッションの引き継ぎ
- オーケストレーターのサマリーと委任カードにサブコントラクターの結果を表示
- ブロードキャストダイアログ: 「オーケストレーターを選択」フィルターボタンを追加
- セッションビューにアニメーション付きステータスインジケーター、ペインヘッダーにオーケストレーションへ戻る固定ボタン

### 修正
- アーカイブ済みセッションがアーカイブ状態を維持し、無効なチャットペインを開かなくなりました
- WebSocket完了、キュー、ディスパッチでの中断実行の処理を修正
- OpenCode: SSE再接続後の実行再同期と破損したディレクトリインスタンスの回復
- モバイルのパリティギャップを解消 (SecureStore、WebSocketバックオフ、アクセシビリティ、オーケストレーターカード)

<!-- lang:ko -->
### 새로운 기능
- 오케스트레이터: 반복적 자동 수정 및 재검토 루프, 수동 계속, 하위 세션 핸드오프
- 오케스트레이터 요약 및 위임 카드에 하청업체 결과 표시
- 브로드캐스트 대화상자: 새로운 "오케스트레이터 선택" 필터 버튼
- 세션 보기의 애니메이션 상태 표시기 및 창 헤더의 고정된 오케스트레이션 복귀 버튼

### 수정 사항
- 보관된 세션이 보관 상태를 유지하고 더 이상 죽은 채팅 창을 열지 않음
- WebSocket 완료, 큐, 디스패치에서 중단된 실행 처리 수정
- OpenCode: SSE 재연결 후 실행 재동기화 및 손상된 디렉터리 인스턴스 복구
- 모바일 패리티 격차 해소 (SecureStore, WebSocket 백오프, 접근성, 오케스트레이터 카드)

<!-- lang:ru -->
### Новое
- Оркестратор: итеративный цикл автоисправлений и повторной проверки, ручное продолжение и передача дочерних сессий
- Сводки оркестратора и карточки делегирования теперь показывают результаты субподрядчиков
- Диалог рассылки: новая кнопка фильтра «выбрать оркестраторов»
- Анимированные индикаторы статуса в представлениях сессий и закреплённая кнопка возврата к оркестрации в заголовке панели

### Исправления
- Архивные сессии остаются в архиве и больше не открывают нерабочие панели чата
- Исправлена обработка прерванных запусков в websocket-завершениях, очереди и диспетчере
- OpenCode: повторная синхронизация запусков после переподключения SSE и восстановление повреждённых экземпляров каталогов
- Устранены пробелы мобильного паритета (SecureStore, backoff websocket, доступность, карточки оркестратора)

<!-- lang:tr -->
### Yenilikler
- Orkestratör: yinelemeli otomatik düzeltme ve yeniden inceleme döngüsü, manuel devam ve alt oturum devri
- Orkestratör özetleri ve delegasyon kartları artık taşeron bulgularını gösteriyor
- Yayın iletişim kutusu: yeni "orkestratörleri seç" filtre düğmesi
- Oturum görünümlerinde animasyonlu durum göstergeleri ve bölme başlığında sabitlenmiş orkestrasyona dön düğmesi

### Düzeltmeler
- Arşivlenen oturumlar arşivde kalıyor ve artık ölü sohbet bölmeleri açmıyor
- Websocket tamamlamalarında, kuyrukta ve dispatch'te iptal edilen çalıştırma işleme düzeltildi
- OpenCode: SSE yeniden bağlantısından sonra çalıştırmaları yeniden senkronize etme ve bozuk dizin örneklerini kurtarma
- Mobil parite boşlukları kapatıldı (SecureStore, websocket backoff, erişilebilirlik, orkestratör kartları)

<!-- lang:zh-CN -->
### 新功能
- 编排器:迭代式自动修复与复审循环、手动继续以及子会话交接
- 编排器摘要和委派卡片现在显示分包商的发现结果
- 广播对话框:新增"选择编排器"筛选按钮
- 会话视图中的动画状态指示器,以及面板头部固定的返回编排按钮

### 修复
- 已归档会话保持归档状态,不再打开失效的聊天面板
- 修复了 websocket 完成、队列和调度中被中止运行的处理
- OpenCode:SSE 重连后重新同步运行,并恢复损坏的目录实例
- 修复了移动端一致性差距(SecureStore、websocket 退避、无障碍、编排器卡片)

<!-- lang:zh-TW -->
### 新功能
- 編排器:迭代式自動修復與複審循環、手動繼續以及子工作階段交接
- 編排器摘要和委派卡片現在會顯示分包商的發現結果
- 廣播對話框:新增「選擇編排器」篩選按鈕
- 工作階段檢視中的動畫狀態指示器,以及窗格標頭固定的返回編排按鈕

### 修復
- 已封存的工作階段維持封存狀態,不再開啟失效的聊天窗格
- 修正了 websocket 完成、佇列和調度中被中止執行的處理
- OpenCode:SSE 重新連線後重新同步執行,並復原損毀的目錄執行個體
- 修正了行動端一致性差距(SecureStore、websocket 退避、無障礙、編排器卡片)
