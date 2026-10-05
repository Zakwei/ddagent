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
- The app is now a single Flutter client — web, Linux & Windows desktop, and Android — replacing the old web UI, the Electron desktop app, and the Expo mobile app
- Knowledge base: rules, memories, and skills with hybrid full-text search, a relation graph, project/tag hubs, and one-click import of project AI-context files and agent skills
- Knowledge context is now query-driven (Contexta-style) — agents pull relevant rules instead of auto-injection, with a critical-rules budget meter
- Orchestrator: supervised auto mode with a goal contract, decision loop, checkpoints, and a final report; redundant provider accounts with automatic failover and ordered planner-model fallbacks
- New providers: native Antigravity (agy) CLI and Command Code via ACP, plus a live Codex model catalog
- Provider accounts: per-account quota, account names in pickers, the ambient login shown as a Default account, and per-account login in settings
- ddagent MCP server installer — one click in Settings → Agents → MCP or during onboarding installs it into your agent configs
- Workspace panes sync across devices — open sessions, editor, and git panes follow you between the web UI and the Flutter app
- Unified skills/rules/context pipeline shared by all providers
- Quota: per-window usage pills (daily/weekly/monthly) colored by burn rate, with Codex, Claude, and Cursor subscription support

### Bug fixes
- Agent questions now reach the UI — pending asks merge into one stepped panel and free-text answers are delivered back to ACP agents
- "Send now" promotes the queued message instead of aborting the active turn; question answers no longer leak into the send queue
- Notifications: "notify this device" actually delivers
- Workspace: cold-boot devices and reconnect snapshots no longer clobber or close live panes
- Fixed terminal auth URLs, transcript copy/paste over plain HTTP, and scroll pinning
- Performance: transcript caching, bounded render windows, a 30-minute model-catalog cache, and a gzip-compressed Flutter web payload (6.9 MB → 2.0 MB)

<!-- lang:pl -->
### Co nowego
- Aplikacja to teraz jeden klient Flutter — web, desktop Linux i Windows oraz Android — zastępujący stary web UI, aplikację Electron i aplikację mobilną Expo
- Baza wiedzy: reguły, wspomnienia i skille z hybrydowym wyszukiwaniem pełnotekstowym, grafem relacji, hubami projektów/tagów oraz importem jednym kliknięciem plików AI-context projektu i skilli agentów
- Kontekst wiedzy jest teraz query-driven (w stylu Contexta) — agenci pobierają relevantne reguły zamiast auto-injekcji, z miernikiem budżetu reguł krytycznych
- Orkiestrator: nadzorowany tryb auto z kontraktem celu, pętlą decyzyjną, checkpointami i raportem końcowym; redundantne konta providerów z automatycznym failoverem i uporządkowanymi fallbackami modelu plannera
- Nowi providerzy: natywny Antigravity (agy) CLI i Command Code przez ACP, plus live katalog modeli Codex
- Konta providerów: quota per konto, nazwy kont w pickerach, ambient login jako konto Default i logowanie per konto w ustawieniach
- Instalator serwera ddagent MCP — jedno kliknięcie w Ustawienia → Agenci → MCP lub podczas onboardingu instaluje go w konfiguracjach agentów
- Panele workspace synchronizują się między urządzeniami — otwarte sesje, edytor i panele gita podążają za Tobą między web UI a aplikacją Flutter
- Ujednolicony pipeline skills/rules/context współdzielony przez wszystkich providerów
- Quota: pigułki zużycia per okno (dzienne/tygodniowe/miesięczne) kolorowane wg tempa zużycia, z obsługą subskrypcji Codex, Claude i Cursor

### Poprawki
- Pytania agentów docierają teraz do UI — oczekujące zapytania są scalone w jeden panel krokowy, a odpowiedzi wolnym tekstem trafiają z powrotem do agentów ACP
- „Wyślij teraz" promuje wiadomość z kolejki zamiast przerywać aktywny turn; odpowiedzi na pytania nie wpadają już do kolejki wysyłania
- Powiadomienia: „powiadom to urządzenie" faktycznie dostarcza
- Workspace: urządzenia po cold-boocie i snapshoty reconnect nie nadpisują i nie zamykają już aktywnych paneli
- Naprawiono URL-e autoryzacji w terminalu, kopiowanie/wklejanie transcriptu po zwykłym HTTP i przypinanie scrolla
- Wydajność: cache transcriptów, ograniczone okno renderowania, 30-minutowy cache katalogów modeli i gzip payloadu Flutter web (6,9 MB → 2,0 MB)

<!-- lang:de -->
### Neuigkeiten
- Die App ist jetzt ein einziger Flutter-Client — Web, Linux- & Windows-Desktop sowie Android — und ersetzt die alte Web-UI, die Electron-Desktop-App und die Expo-Mobil-App
- Wissensdatenbank: Regeln, Erinnerungen und Skills mit hybrider Volltextsuche, Relationsgraph, Projekt-/Tag-Hubs und One-Click-Import von KI-Kontextdateien des Projekts und Agenten-Skills
- Wissenskontext ist jetzt query-driven (Contexta-Stil) — Agenten rufen relevante Regeln ab statt Auto-Injection, mit Budget-Anzeige für kritische Regeln
- Orchestrator: überwachter Auto-Modus mit Zielvertrag, Entscheidungsschleife, Checkpoints und Abschlussbericht; redundante Provider-Konten mit automatischem Failover und geordneten Planner-Modell-Fallbacks
- Neue Provider: natives Antigravity (agy) CLI und Command Code via ACP, plus Live-Modellkatalog für Codex
- Provider-Konten: Quota pro Konto, Kontonamen in den Auswahllisten, Ambient-Login als Default-Konto und Login pro Konto in den Einstellungen
- ddagent-MCP-Server-Installer — ein Klick in Einstellungen → Agents → MCP oder im Onboarding installiert ihn in die Agenten-Konfigurationen
- Workspace-Panes synchronisieren sich über Geräte hinweg — offene Sessions, Editor- und Git-Panes folgen dir zwischen Web-UI und Flutter-App
- Einheitliche Skills/Rules/Context-Pipeline für alle Provider
- Quota: Verbrauchs-Pills pro Fenster (täglich/wöchentlich/monatlich), gefärbt nach Verbrauchstempo, mit Codex-, Claude- und Cursor-Abo-Unterstützung

### Fehlerbehebungen
- Agenten-Fragen erreichen jetzt die UI — ausstehende Anfragen werden in einem gestuften Panel zusammengefasst und Freitext-Antworten an ACP-Agenten zurückgeliefert
- „Jetzt senden" befördert die wartende Nachricht statt den aktiven Turn abzubrechen; Frage-Antworten landen nicht mehr in der Sende-Queue
- Benachrichtigungen: „Dieses Gerät benachrichtigen" liefert jetzt tatsächlich
- Workspace: Cold-Boot-Geräte und Reconnect-Snapshots überschreiben bzw. schließen keine aktiven Panes mehr
- Terminal-Auth-URLs, Transcript-Copy/Paste über HTTP und Scroll-Pinning korrigiert
- Performance: Transcript-Caching, begrenzte Render-Fenster, 30-Minuten-Modellkatalog-Cache und gzip-komprimierte Flutter-Web-Payload (6,9 MB → 2,0 MB)

<!-- lang:es -->
### Novedades
- La app es ahora un único cliente Flutter — web, escritorio Linux y Windows, y Android — que reemplaza la antigua UI web, la app de escritorio Electron y la app móvil Expo
- Base de conocimiento: reglas, memorias y skills con búsqueda híbrida de texto completo, grafo de relaciones, hubs de proyectos/etiquetas e importación con un clic de archivos de contexto IA del proyecto y skills de agentes
- El contexto de conocimiento ahora es query-driven (estilo Contexta): los agentes consultan las reglas relevantes en lugar de auto-inyección, con medidor de presupuesto de reglas críticas
- Orquestador: modo auto supervisado con contrato de objetivo, bucle de decisiones, checkpoints e informe final; cuentas de proveedor redundantes con failover automático y fallbacks ordenados del modelo planificador
- Nuevos proveedores: Antigravity (agy) CLI nativo y Command Code vía ACP, además del catálogo de modelos Codex en vivo
- Cuentas de proveedor: cuota por cuenta, nombres de cuenta en los selectores, login ambient como cuenta Default y login por cuenta en ajustes
- Instalador del servidor MCP de ddagent — un clic en Ajustes → Agentes → MCP o durante el onboarding lo instala en las configuraciones de tus agentes
- Los paneles del workspace se sincronizan entre dispositivos: sesiones abiertas, editor y paneles de git te siguen entre la UI web y la app Flutter
- Pipeline unificado de skills/rules/context compartido por todos los proveedores
- Cuota: píldoras de uso por ventana (diaria/semanal/mensual) coloreadas según el ritmo de consumo, con soporte de suscripciones Codex, Claude y Cursor

### Correcciones
- Las preguntas de los agentes llegan ahora a la UI: las solicitudes pendientes se combinan en un panel por pasos y las respuestas de texto libre se entregan a los agentes ACP
- «Enviar ahora» promueve el mensaje en cola en lugar de abortar el turno activo; las respuestas a preguntas ya no se cuelan en la cola de envío
- Notificaciones: «notificar a este dispositivo» ahora sí entrega
- Workspace: los dispositivos en cold-boot y los snapshots de reconnect ya no sobrescriben ni cierran paneles activos
- Corregidas las URLs de autenticación del terminal, copiar/pegar del transcript por HTTP plano y la fijación del scroll
- Rendimiento: caché de transcripts, ventanas de renderizado acotadas, caché de catálogos de modelos de 30 min y payload Flutter web comprimido con gzip (6,9 MB → 2,0 MB)

<!-- lang:fr -->
### Nouveautés
- L'application est désormais un unique client Flutter — web, desktop Linux & Windows et Android — qui remplace l'ancienne UI web, l'app desktop Electron et l'app mobile Expo
- Base de connaissances : règles, mémoires et skills avec recherche hybride plein texte, graphe de relations, hubs de projets/tags et import en un clic des fichiers de contexte IA du projet et des skills d'agents
- Le contexte de connaissances est désormais query-driven (style Contexta) : les agents récupèrent les règles pertinentes au lieu d'une auto-injection, avec une jauge de budget pour les règles critiques
- Orchestrateur : mode auto supervisé avec contrat d'objectif, boucle de décision, checkpoints et rapport final ; comptes provider redondants avec failover automatique et fallbacks ordonnés du modèle planificateur
- Nouveaux providers : Antigravity (agy) CLI natif et Command Code via ACP, plus le catalogue de modèles Codex en direct
- Comptes provider : quota par compte, noms de comptes dans les sélecteurs, login ambient comme compte Default et login par compte dans les réglages
- Installeur du serveur MCP ddagent — un clic dans Réglages → Agents → MCP ou pendant l'onboarding l'installe dans les configs de vos agents
- Les panes du workspace se synchronisent entre appareils — sessions ouvertes, éditeur et panes git vous suivent entre la UI web et l'app Flutter
- Pipeline unifié skills/rules/context partagé par tous les providers
- Quota : pilules d'usage par fenêtre (journalière/hebdomadaire/mensuelle) colorées selon le rythme de consommation, avec support des abonnements Codex, Claude et Cursor

### Corrections
- Les questions des agents arrivent désormais dans la UI — les demandes en attente sont fusionnées dans un panneau par étapes et les réponses en texte libre sont renvoyées aux agents ACP
- « Envoyer maintenant » promeut le message en file au lieu d'interrompre le tour actif ; les réponses aux questions ne fuient plus dans la file d'envoi
- Notifications : « notifier cet appareil » fonctionne réellement
- Workspace : les appareils en cold-boot et les snapshots de reconnexion n'écrasent ni ne ferment plus les panes actifs
- URLs d'auth du terminal, copier/coller du transcript en HTTP simple et pinning du scroll corrigés
- Performance : cache des transcripts, fenêtres de rendu bornées, cache des catalogues de modèles de 30 min et payload Flutter web compressé en gzip (6,9 Mo → 2,0 Mo)

<!-- lang:it -->
### Novità
- L'app è ora un unico client Flutter — web, desktop Linux e Windows e Android — che sostituisce la vecchia UI web, l'app desktop Electron e l'app mobile Expo
- Knowledge base: regole, memorie e skill con ricerca ibrida full-text, grafo delle relazioni, hub di progetti/tag e importazione con un clic dei file di contesto AI del progetto e delle skill degli agenti
- Il contesto della conoscenza è ora query-driven (stile Contexta): gli agenti recuperano le regole rilevanti invece dell'auto-iniezione, con misuratore del budget delle regole critiche
- Orchestrator: modalità auto supervisionata con contratto d'obiettivo, ciclo decisionale, checkpoint e report finale; account provider ridondanti con failover automatico e fallback ordinati del modello planner
- Nuovi provider: Antigravity (agy) CLI nativo e Command Code via ACP, oltre al catalogo modelli Codex in tempo reale
- Account provider: quota per account, nomi degli account nei selettori, login ambient come account Default e login per account nelle impostazioni
- Installer del server MCP ddagent — un clic in Impostazioni → Agenti → MCP o durante l'onboarding lo installa nelle configurazioni degli agenti
- I pannelli del workspace si sincronizzano tra dispositivi — sessioni aperte, editor e pannelli git ti seguono tra la UI web e l'app Flutter
- Pipeline unificata skills/rules/context condivisa da tutti i provider
- Quota: pillole di utilizzo per finestra (giornaliera/settimanale/mensile) colorate in base al ritmo di consumo, con supporto agli abbonamenti Codex, Claude e Cursor

### Correzioni
- Le domande degli agenti ora raggiungono la UI — le richieste in sospeso sono unite in un pannello a step e le risposte in testo libero vengono consegnate agli agenti ACP
- «Invia ora» promuove il messaggio in coda invece di interrompere il turno attivo; le risposte alle domande non finiscono più nella coda di invio
- Notifiche: «notifica questo dispositivo» ora funziona davvero
- Workspace: i dispositivi in cold-boot e gli snapshot di reconnect non sovrascrivono né chiudono più i pannelli attivi
- Corretti URL di autenticazione del terminale, copia/incolla del transcript su HTTP semplice e pinning dello scroll
- Prestazioni: cache dei transcript, finestre di rendering limitate, cache dei cataloghi modelli di 30 min e payload Flutter web compresso in gzip (6,9 MB → 2,0 MB)

<!-- lang:ja -->
### 新機能
- アプリは単一の Flutter クライアント（Web、Linux & Windows デスクトップ、Android）になり、旧 Web UI・Electron デスクトップアプリ・Expo モバイルアプリを置き換えました
- ナレッジベース：ルール・メモリ・スキルを管理。全文ハイブリッド検索、リレーショングラフ、プロジェクト/タグのハブ、プロジェクトの AI コンテキストファイルとエージェントスキルのワンクリックインポート
- ナレッジコンテキストはクエリ駆動（Contexta 方式）に — 自動注入ではなくエージェントが関連ルールを取得。クリティカルルールの予算メーター付き
- オーケストレーター：ゴール契約・意思決定ループ・チェックポイント・最終レポートを備えた監督付き自動モード。自動フェイルオーバー付き冗長プロバイダーアカウントと順序付きプランナーモデルフォールバック
- 新プロバイダー：ネイティブ Antigravity (agy) CLI と ACP 経由の Command Code、Codex のライブモデルカタログ
- プロバイダーアカウント：アカウント単位のクォータ、ピッカー内のアカウント名表示、ambient ログインの Default アカウント化、設定での個別ログイン
- ddagent MCP サーバーインストーラー — 設定 → エージェント → MCP またはオンボーディングからワンクリックでエージェント設定にインストール
- ワークスペースのペインがデバイス間で同期 — 開いているセッション・エディタ・Git ペインが Web UI と Flutter アプリ間で引き継がれます
- 全プロバイダー共通の統一 skills/rules/context パイプライン
- クォータ：ウィンドウ別（日/週/月）の使用量ピルを消費ペースで色分け。Codex・Claude・Cursor サブスクリプション対応

### 修正
- エージェントの質問が UI に届くように — 保留中の質問はステップ式パネルに統合され、自由記述の回答は ACP エージェントへ返されます
- 「今すぐ送信」はアクティブなターンを中断せずキューのメッセージを優先送信。質問への回答が送信キューに漏れなくなりました
- 通知：「このデバイスに通知」が実際に届くように
- ワークスペース：cold-boot したデバイスや再接続スナップショットがアクティブなペインを上書き・閉じなくなりました
- ターミナルの認証 URL、平文 HTTP でのトランスクリプトのコピー/ペースト、スクロールのピン留めを修正
- パフォーマンス：トランスクリプトのキャッシュ、描画ウィンドウの限定、モデルカタログの 30 分キャッシュ、Flutter Web ペイロードの gzip 圧縮（6.9 MB → 2.0 MB）

<!-- lang:ko -->
### 새로운 기능
- 앱이 이제 단일 Flutter 클라이언트(웹, Linux & Windows 데스크톱, Android)로 통합되어 기존 웹 UI, Electron 데스크톱 앱, Expo 모바일 앱을 대체합니다
- 지식 베이스: 규칙, 메모리, 스킬 관리 — 전문 하이브리드 검색, 관계 그래프, 프로젝트/태그 허브, 프로젝트 AI 컨텍스트 파일 및 에이전트 스킬 원클릭 가져오기
- 지식 컨텍스트가 쿼리 기반(Contexta 방식)으로 변경 — 자동 주입 대신 에이전트가 관련 규칙을 가져오며, 크리티컬 규칙 예산 미터 제공
- 오케스트레이터: 목표 계약, 의사결정 루프, 체크포인트, 최종 리포트를 갖춘 감독형 자동 모드. 자동 페일오버가 있는 중복 프로바이더 계정과 순서 있는 플래너 모델 폴백
- 새 프로바이더: 네이티브 Antigravity (agy) CLI와 ACP 기반 Command Code, Codex 실시간 모델 카탈로그
- 프로바이더 계정: 계정별 쿼터, 선택기의 계정 이름 표시, ambient 로그인의 Default 계정화, 설정에서 계정별 로그인
- ddagent MCP 서버 인스톨러 — 설정 → 에이전트 → MCP 또는 온보딩에서 한 번의 클릭으로 에이전트 설정에 설치
- 워크스페이스 패인이 기기 간 동기화 — 열린 세션, 에디터, Git 패인이 웹 UI와 Flutter 앱 사이를 따라다닙니다
- 모든 프로바이더가 공유하는 통합 skills/rules/context 파이프라인
- 쿼터: 윈도우별(일/주/월) 사용량 pill을 소모 속도에 따라 색상 표시, Codex·Claude·Cursor 구독 지원

### 버그 수정
- 에이전트 질문이 이제 UI에 도달 — 대기 중인 질문은 단계별 패널로 통합되고 자유 텍스트 답변은 ACP 에이전트로 전달됩니다
- "지금 보내기"가 활성 턴을 중단하지 않고 큐의 메시지를 우선 전송. 질문 답변이 전송 큐로 새지 않습니다
- 알림: "이 기기에 알림"이 실제로 전달됩니다
- 워크스페이스: 콜드 부트 기기와 재접속 스냅샷이 활성 패인을 덮어쓰거나 닫지 않습니다
- 터미널 인증 URL, 일반 HTTP에서의 트랜스크립트 복사/붙여넣기, 스크롤 고정 수정
- 성능: 트랜스크립트 캐싱, 렌더 윈도우 제한, 모델 카탈로그 30분 캐시, Flutter 웹 페이로드 gzip 압축(6.9MB → 2.0MB)

<!-- lang:ru -->
### Новое
- Приложение теперь единый Flutter-клиент — web, десктоп Linux и Windows, Android — заменяющий старый web UI, десктопное приложение Electron и мобильное Expo
- База знаний: правила, воспоминания и скиллы с гибридным полнотекстовым поиском, графом связей, хабами проектов/тегов и импортом в один клик AI-контекстных файлов проекта и скиллов агентов
- Контекст знаний теперь query-driven (в стиле Contexta) — агенты запрашивают релевантные правила вместо автоинъекции, с индикатором бюджета критических правил
- Оркестратор: супервизированный авто-режим с контрактом цели, циклом решений, чекпоинтами и финальным отчётом; резервные аккаунты провайдеров с автоматическим failover и упорядоченными fallback модели планировщика
- Новые провайдеры: нативный Antigravity (agy) CLI и Command Code через ACP, плюс живой каталог моделей Codex
- Аккаунты провайдеров: квота на аккаунт, имена аккаунтов в селекторах, ambient-логин как аккаунт Default и вход по аккаунтам в настройках
- Установщик MCP-сервера ddagent — один клик в Настройки → Агенты → MCP или при онбординге устанавливает его в конфиги агентов
- Панели workspace синхронизируются между устройствами — открытые сессии, редактор и git-панели следуют за вами между web UI и приложением Flutter
- Единый пайплайн skills/rules/context для всех провайдеров
- Квота: пилюли использования по окнам (день/неделя/месяц), окрашенные по темпу расхода, с поддержкой подписок Codex, Claude и Cursor

### Исправления
- Вопросы агентов теперь доходят до UI — ожидающие запросы объединены в пошаговую панель, а ответы свободным текстом доставляются агентам ACP
- «Отправить сейчас» продвигает сообщение из очереди вместо прерывания активного хода; ответы на вопросы больше не попадают в очередь отправки
- Уведомления: «уведомить это устройство» теперь реально доставляет
- Workspace: устройства после cold-boot и снапшоты реконнекта больше не затирают и не закрывают активные панели
- Исправлены URL авторизации в терминале, копирование/вставка транскрипта по обычному HTTP и закрепление скролла
- Производительность: кэш транскриптов, ограниченное окно рендера, 30-минутный кэш каталогов моделей и gzip-сжатие payload Flutter web (6,9 МБ → 2,0 МБ)

<!-- lang:tr -->
### Yenilikler
- Uygulama artık tek bir Flutter istemcisi — web, Linux & Windows masaüstü ve Android — eski web UI'ın, Electron masaüstü uygulamasının ve Expo mobil uygulamasının yerini alıyor
- Bilgi tabanı: kurallar, anılar ve skill'ler; tam metin hibrit arama, ilişki grafiği, proje/etiket hub'ları ve proje AI-bağlam dosyaları ile ajan skill'lerinin tek tıkla içe aktarımı
- Bilgi bağlamı artık sorgu odaklı (Contexta tarzı) — ajanlar otomatik enjeksiyon yerine ilgili kuralları çekiyor; kritik kurallar için bütçe göstergesi
- Orkestratör: hedef sözleşmesi, karar döngüsü, checkpoint'ler ve final raporu içeren denetimli otomatik mod; otomatik failover'lı yedekli provider hesapları ve sıralı planner modeli fallback'leri
- Yeni provider'lar: yerel Antigravity (agy) CLI ve ACP üzerinden Command Code, ayrıca canlı Codex model kataloğu
- Provider hesapları: hesap başına kota, seçicilerde hesap adları, ambient login'in Default hesabı olması ve ayarlarda hesap bazında giriş
- ddagent MCP sunucu yükleyicisi — Ayarlar → Ajanlar → MCP'de veya onboarding sırasında tek tıkla ajan yapılandırmalarına kurulur
- Workspace panelleri cihazlar arasında senkronize — açık oturumlar, editör ve git panelleri web UI ile Flutter uygulaması arasında sizi takip eder
- Tüm provider'ların paylaştığı birleşik skills/rules/context hattı
- Kota: pencere bazında (günlük/haftalık/aylık) kullanım hapları tüketim hızına göre renklendirilir; Codex, Claude ve Cursor abonelik desteği

### Hata düzeltmeleri
- Ajan soruları artık UI'ya ulaşıyor — bekleyen istekler tek bir adımlı panelde birleşiyor ve serbest metin cevapları ACP ajanlarına geri iletiliyor
- "Şimdi gönder" aktif turu iptal etmek yerine kuyruktaki mesajı öne alıyor; soru cevapları artık gönderim kuyruğuna sızmıyor
- Bildirimler: "bu cihaza bildir" artık gerçekten iletiliyor
- Workspace: cold-boot cihazlar ve reconnect snapshot'ları artık canlı panelleri ezmez veya kapatmaz
- Terminal auth URL'leri, düz HTTP'de transcript kopyala/yapıştır ve scroll sabitleme düzeltildi
- Performans: transcript önbelleği, sınırlı render penceresi, 30 dk model kataloğu önbelleği ve gzip sıkıştırmalı Flutter web payload'u (6,9 MB → 2,0 MB)

<!-- lang:zh-CN -->
### 新功能
- 应用现在是单一的 Flutter 客户端 —— Web、Linux 和 Windows 桌面端以及 Android —— 取代了旧的 Web UI、Electron 桌面应用和 Expo 移动应用
- 知识库：规则、记忆和技能，支持全文混合搜索、关系图谱、项目/标签枢纽，以及一键导入项目 AI 上下文文件和代理技能
- 知识上下文改为查询驱动（Contexta 风格）—— 代理按需拉取相关规则而非自动注入，并带有关键规则预算指示器
- 编排器：带目标契约、决策循环、检查点和最终报告的监督式自动模式；冗余提供商账户自动故障转移及有序的规划器模型回退
- 新提供商：原生 Antigravity (agy) CLI 和通过 ACP 的 Command Code，以及 Codex 实时模型目录
- 提供商账户：按账户统计配额、选择器中显示账户名、ambient 登录显示为 Default 账户、设置中按账户登录
- ddagent MCP 服务器安装器 —— 在 设置 → 代理 → MCP 或引导流程中一键安装到代理配置
- 工作区窗格跨设备同步 —— 打开的会话、编辑器和 git 窗格在 Web UI 与 Flutter 应用之间跟随你
- 所有提供商共享的统一 skills/rules/context 流水线
- 配额：按窗口（日/周/月）显示的用量胶囊，按消耗速度着色，支持 Codex、Claude 和 Cursor 订阅

### 问题修复
- 代理提问现在能到达 UI —— 待处理请求合并为一个分步面板，自由文本答案会回传给 ACP 代理
- "立即发送"会提升队列中的消息而不是中断当前回合；问题答案不再泄漏到发送队列
- 通知："通知此设备"现在可以真正送达
- 工作区：冷启动设备和重连快照不再覆盖或关闭活动窗格
- 修复了终端认证 URL、纯 HTTP 下转录文本的复制/粘贴以及滚动固定
- 性能：转录缓存、有界渲染窗口、30 分钟模型目录缓存、Flutter Web 负载 gzip 压缩（6.9 MB → 2.0 MB）

<!-- lang:zh-TW -->
### 新功能
- 應用程式現在是單一 Flutter 用戶端 —— Web、Linux 與 Windows 桌面版以及 Android —— 取代舊的 Web UI、Electron 桌面應用與 Expo 行動應用
- 知識庫：規則、記憶與技能，支援全文混合搜尋、關係圖譜、專案/標籤樞紐，以及一鍵匯入專案 AI 脈絡檔案與代理技能
- 知識脈絡改為查詢驅動（Contexta 風格）—— 代理按需擷取相關規則而非自動注入，並附關鍵規則預算指示器
- 編排器：具備目標契約、決策迴圈、檢查點與最終報告的監督式自動模式；冗餘提供商帳戶自動容錯移轉與有序的規劃器模型回退
- 新提供商：原生 Antigravity (agy) CLI 與透過 ACP 的 Command Code，以及 Codex 即時模型目錄
- 提供商帳戶：按帳戶配額、選擇器中的帳戶名稱、ambient 登入顯示為 Default 帳戶、設定中按帳戶登入
- ddagent MCP 伺服器安裝程式 —— 在 設定 → 代理 → MCP 或引導流程中一鍵安裝至代理設定
- 工作區窗格跨裝置同步 —— 開啟的工作階段、編輯器與 git 窗格在 Web UI 與 Flutter 應用間跟隨你
- 所有提供商共用的統一 skills/rules/context 管線
- 配額：按窗口（日/週/月）的用量膠囊依消耗速度著色，支援 Codex、Claude 與 Cursor 訂閱

### 問題修復
- 代理提問現在會送達 UI —— 待處理請求合併為單一分步面板，自由文字答案會回傳給 ACP 代理
- 「立即傳送」會提升佇列中的訊息而非中斷目前回合；問題答案不再洩漏到傳送佇列
- 通知：「通知此裝置」現在真正能送達
- 工作區：冷啟動裝置與重新連線快照不再覆寫或關閉使用中的窗格
- 修正終端機驗證 URL、純 HTTP 下逐字稿的複製/貼上以及捲動固定
- 效能：逐字稿快取、有界渲染窗口、30 分鐘模型目錄快取、Flutter Web 負載 gzip 壓縮（6.9 MB → 2.0 MB）
