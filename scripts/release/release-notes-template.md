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
- Windows: LLM model lists in Agents now refresh from the installed provider CLIs — npm/pnpm/bun `.cmd` shims are executed correctly instead of falling back to a bundled catalog, and a failed probe retries after one minute instead of caching the fallback
- Windows: Devin MCP install/list/remove and Devin skills listing work again (same `.cmd` shim fix)
- Windows: provider login/install terminals and the plain terminal no longer fail with "Invalid project path" when no project exists — the client no longer sends a hardcoded `/workspace` working directory
- Windows: multiple provider accounts now actually isolate credentials — account presets redirect USERPROFILE/APPDATA variables that Windows CLIs read (HOME/XDG_* were ignored)
- Windows: Preview discovers dev-server ports via netstat (and via lsof on macOS); sharing skills to Claude no longer fails with a symlink permission error
- Windows: the Antigravity CLI is detected when installed through npm/pnpm/bun (ANTIGRAVITY_CLI_PATH override added, same as CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH); quota cards read the real home directory; system update no longer crashes on missing `sh`
<!-- lang:pl -->
### Poprawki błędów
- Windows: listy modeli LLM w Agents odświeżają się teraz z zainstalowanych CLI providerów — shimy `.cmd` npm/pnpm/bun uruchamiają się poprawnie zamiast odpadać na wbudowany katalog, a nieudana próba powtarza się po minucie zamiast trzymać cache
- Windows: instalacja/listowanie/usuwanie MCP oraz lista skills Devina znów działają (ta sama poprawka shimów `.cmd`)
- Windows: terminale logowania/instalacji providerów oraz zwykły terminal nie pokazują już „Invalid project path" gdy nie ma projektu — klient nie wysyła już zahardkodowanego `/workspace`
- Windows: wiele kont providerów faktycznie izoluje poświadczenia — presety kont przekierowują zmienne USERPROFILE/APPDATA czytane przez Windowsowe CLI (HOME/XDG_* były ignorowane)
- Windows: Preview wykrywa porty dev-serwerów przez netstat (oraz lsof na macOS); udostępnianie skills do Claude nie pada już na błędzie uprawnień symlinka
- Windows: CLI Antigravity jest wykrywane przy instalacji przez npm/pnpm/bun (dodany override ANTIGRAVITY_CLI_PATH jak CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH); karty quota czytają prawdziwy katalog domowy; aktualizacja systemu nie wykracza się już na brakującym `sh`
<!-- lang:de -->
### Fehlerbehebungen
- Windows: LLM-Modelllisten in Agents werden jetzt von den installierten Provider-CLIs aktualisiert — npm/pnpm/bun-`.cmd`-Shims werden korrekt ausgeführt statt auf einen gebündelten Katalog zurückzufallen, und eine fehlgeschlagene Abfrage wird nach einer Minute wiederholt statt den Fallback zu cachen
- Windows: Devin-MCP-Installation/Auflistung/Entfernung und die Devin-Skills-Liste funktionieren wieder (gleicher `.cmd`-Shim-Fix)
- Windows: Provider-Login-/Install-Terminals und das normale Terminal scheitern nicht mehr mit „Invalid project path", wenn kein Projekt existiert — der Client sendet kein hartkodiertes `/workspace`-Arbeitsverzeichnis mehr
- Windows: Mehrere Provider-Konten isolieren Zugangsdaten jetzt tatsächlich — Konto-Presets leiten die USERPROFILE/APPDATA-Variablen um, die Windows-CLIs lesen (HOME/XDG_* wurden ignoriert)
- Windows: Preview erkennt Dev-Server-Ports per netstat (und per lsof unter macOS); das Teilen von Skills mit Claude scheitert nicht mehr an einem Symlink-Berechtigungsfehler
- Windows: Die Antigravity-CLI wird erkannt, wenn sie über npm/pnpm/bun installiert wurde (ANTIGRAVITY_CLI_PATH-Override hinzugefügt, wie CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH); Quota-Karten lesen das echte Home-Verzeichnis; das System-Update stürzt nicht mehr am fehlenden `sh` ab
<!-- lang:es -->
### Correcciones de errores
- Windows: las listas de modelos LLM en Agents se actualizan desde las CLIs de proveedores instaladas — los shims `.cmd` de npm/pnpm/bun se ejecutan correctamente en lugar de recurrir a un catálogo empaquetado, y una consulta fallida reintenta tras un minuto en lugar de cachear el fallback
- Windows: la instalación/listado/eliminación de MCP de Devin y el listado de skills de Devin vuelven a funcionar (misma corrección de shims `.cmd`)
- Windows: los terminales de login/instalación de proveedores y el terminal normal ya no fallan con «Invalid project path» cuando no hay proyecto — el cliente ya no envía el directorio de trabajo hardcodeado `/workspace`
- Windows: las cuentas múltiples de proveedores ahora aíslan las credenciales de verdad — los presets de cuenta redirigen las variables USERPROFILE/APPDATA que leen las CLIs de Windows (HOME/XDG_* se ignoraban)
- Windows: Preview descubre puertos de dev-servers vía netstat (y vía lsof en macOS); compartir skills con Claude ya no falla con un error de permisos de symlink
- Windows: la CLI de Antigravity se detecta al instalarla mediante npm/pnpm/bun (añadido override ANTIGRAVITY_CLI_PATH igual que CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH); las tarjetas de quota leen el directorio home real; la actualización del sistema ya no se rompe por falta de `sh`
<!-- lang:fr -->
### Corrections de bugs
- Windows : les listes de modèles LLM dans Agents se rafraîchissent depuis les CLIs de fournisseurs installées — les shims `.cmd` npm/pnpm/bun s'exécutent correctement au lieu de retomber sur un catalogue intégré, et une requête échouée retente après une minute au lieu de garder le fallback en cache
- Windows : l'installation/le listage/la suppression des MCP Devin et le listage des skills Devin refonctionnent (même correctif des shims `.cmd`)
- Windows : les terminaux de connexion/installation des fournisseurs et le terminal simple n'échouent plus avec « Invalid project path » quand aucun projet n'existe — le client n'envoie plus le répertoire de travail codé en dur `/workspace`
- Windows : les comptes multiples de fournisseurs isolent désormais réellement les identifiants — les presets de compte redirigent les variables USERPROFILE/APPDATA lues par les CLIs Windows (HOME/XDG_* étaient ignorées)
- Windows : Preview découvre les ports des serveurs de dev via netstat (et via lsof sous macOS) ; le partage de skills vers Claude n'échoue plus sur une erreur de permission de lien symbolique
- Windows : la CLI Antigravity est détectée quand elle est installée via npm/pnpm/bun (override ANTIGRAVITY_CLI_PATH ajouté, comme CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH) ; les cartes de quota lisent le vrai répertoire personnel ; la mise à jour système ne plante plus sur le `sh` manquant
<!-- lang:it -->
### Correzioni di bug
- Windows: gli elenchi di modelli LLM in Agents si aggiornano dalle CLI dei provider installate — gli shim `.cmd` di npm/pnpm/bun vengono eseguiti correttamente invece di ripiegare su un catalogo incluso, e una sonda fallita riprova dopo un minuto invece di tenere il fallback in cache
- Windows: installazione/elenco/rimozione MCP di Devin e l'elenco degli skills di Devin tornano a funzionare (stessa correzione degli shim `.cmd`)
- Windows: i terminali di login/installazione dei provider e il terminale normale non falliscono più con «Invalid project path» quando non esiste un progetto — il client non invia più la directory di lavoro hardcoded `/workspace`
- Windows: più account provider ora isolano davvero le credenziali — i preset degli account reindirizzano le variabili USERPROFILE/APPDATA lette dalle CLI Windows (HOME/XDG_* venivano ignorate)
- Windows: Preview rileva le porte dei dev-server tramite netstat (e tramite lsof su macOS); la condivisione degli skills verso Claude non fallisce più con un errore di permessi del symlink
- Windows: la CLI Antigravity viene rilevata quando installata tramite npm/pnpm/bun (aggiunto l'override ANTIGRAVITY_CLI_PATH come CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH); le schede quota leggono la vera home directory; l'aggiornamento di sistema non si blocca più per il `sh` mancante
<!-- lang:ja -->
### バグ修正
- Windows: Agents の LLM モデル一覧がインストール済みプロバイダー CLI から正しく更新されるようになりました — npm/pnpm/bun の `.cmd` シムが正しく実行され、バンドル済みカタログへのフォールバックを回避し、失敗したプローブはキャッシュせず1分後に再試行します
- Windows: Devin MCP のインストール/一覧/削除と Devin スキル一覧が再び動作します（同じ `.cmd` シム修正）
- Windows: プロバイダーのログイン/インストール端末と通常のターミナルが、プロジェクト未作成時に「Invalid project path」で失敗しなくなりました — クライアントはハードコードされた `/workspace` 作業ディレクトリを送らなくなりました
- Windows: 複数プロバイダーアカウントが認証情報を実際に分離するようになりました — アカウントプリセットは Windows CLI が読む USERPROFILE/APPDATA 変数をリダイレクトします（HOME/XDG_* は無視されていました）
- Windows: Preview が netstat で dev サーバーのポートを検出します（macOS では lsof）。Claude へのスキル共有もシンボリックリンク権限エラーで失敗しなくなりました
- Windows: Antigravity CLI が npm/pnpm/bun 経由のインストールで検出されるようになりました（ANTIGRAVITY_CLI_PATH オーバーライド追加、CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH と同様）。クォータカードは実際のホームディレクトリを読み、システム更新も `sh` 不在で落ちなくなりました
<!-- lang:ko -->
### 버그 수정
- Windows: Agents의 LLM 모델 목록이 이제 설치된 프로바이더 CLI에서 새로고침됩니다 — npm/pnpm/bun `.cmd` 심이 올바르게 실행되어 번들 카탈로그로 폴백하지 않으며, 실패한 프로브는 캐시하지 않고 1분 후 재시도합니다
- Windows: Devin MCP 설치/목록/삭제와 Devin 스킬 목록이 다시 동작합니다(동일한 `.cmd` 심 수정)
- Windows: 프로젝트가 없을 때 프로바이더 로그인/설치 터미널과 일반 터미널이 "Invalid project path"로 실패하지 않습니다 — 클라이언트가 하드코딩된 `/workspace` 작업 디렉터리를 더 이상 보내지 않습니다
- Windows: 여러 프로바이더 계정이 이제 자격 증명을 실제로 격리합니다 — 계정 프리셋이 Windows CLI가 읽는 USERPROFILE/APPDATA 변수를 리디렉션합니다(HOME/XDG_*는 무시되었습니다)
- Windows: Preview가 netstat으로 dev 서버 포트를 검색합니다(macOS에서는 lsof). Claude로의 스킬 공유도 심볼릭 링크 권한 오류로 실패하지 않습니다
- Windows: Antigravity CLI가 npm/pnpm/bun으로 설치된 경우에도 감지됩니다(CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH와 같은 ANTIGRAVITY_CLI_PATH 오버라이드 추가). 할당량 카드는 실제 홈 디렉터리를 읽고, 시스템 업데이트도 누락된 `sh`로 충돌하지 않습니다
<!-- lang:ru -->
### Исправления ошибок
- Windows: списки моделей LLM в Agents теперь обновляются из установленных CLI провайдеров — `.cmd`-шимы npm/pnpm/bun выполняются корректно вместо отката на встроенный каталог, а неудачный запрос повторяется через минуту вместо кэширования fallback
- Windows: установка/список/удаление MCP Devin и список skills Devin снова работают (то же исправление `.cmd`-шимов)
- Windows: терминалы входа/установки провайдеров и обычный терминал больше не падают с «Invalid project path», когда нет проекта — клиент больше не отправляет зашитый `/workspace` в качестве рабочей директории
- Windows: несколько аккаунтов провайдеров теперь действительно изолируют учётные данные — пресеты аккаунтов перенаправляют переменные USERPROFILE/APPDATA, которые читают Windows CLI (HOME/XDG_* игнорировались)
- Windows: Preview обнаруживает порты dev-серверов через netstat (и через lsof на macOS); передача skills в Claude больше не падает с ошибкой прав symlink
- Windows: Antigravity CLI определяется при установке через npm/pnpm/bun (добавлен override ANTIGRAVITY_CLI_PATH, как CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH); карточки квот читают реальную домашнюю директорию; обновление системы больше не падает на отсутствующем `sh`
<!-- lang:tr -->
### Hata düzeltmeleri
- Windows: Agents'taki LLM model listeleri artık kurulu sağlayıcı CLI'larından yenileniyor — npm/pnpm/bun `.cmd` shim'leri doğru şekilde çalışıyor, gömülü kataloğa düşmek yerine başarısız sorgu bir dakika sonra yeniden deneniyor
- Windows: Devin MCP kurulum/listeleme/kaldırma ve Devin skill listeleme yeniden çalışıyor (aynı `.cmd` shim düzeltmesi)
- Windows: proje yokken sağlayıcı giriş/kurulum terminalleri ve normal terminal artık "Invalid project path" hatası vermiyor — istemci artık sabit `/workspace` çalışma dizini göndermiyor
- Windows: birden fazla sağlayıcı hesabı artık kimlik bilgilerini gerçekten izole ediyor — hesap ön ayarları Windows CLI'larının okuduğu USERPROFILE/APPDATA değişkenlerini yönlendiriyor (HOME/XDG_* yok sayılıyordu)
- Windows: Preview dev sunucu portlarını netstat ile keşfediyor (macOS'ta lsof ile); Claude'a skill paylaşımı artık symlink izin hatasıyla başarısız olmuyor
- Windows: Antigravity CLI npm/pnpm/bun ile kurulduğunda algılanıyor (CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH gibi ANTIGRAVITY_CLI_PATH override eklendi); kota kartları gerçek ana dizini okuyor; sistem güncellemesi artık eksik `sh` yüzünden çökmüyor
<!-- lang:zh-CN -->
### 错误修复
- Windows: Agents 中的 LLM 模型列表现在会从已安装的提供商 CLI 刷新 — npm/pnpm/bun 的 `.cmd` 垫片可正确执行，不再回退到内置目录，失败的探测会在一分钟后重试而不是缓存回退结果
- Windows: Devin MCP 的安装/列出/删除以及 Devin 技能列表恢复可用（同样的 `.cmd` 垫片修复）
- Windows: 没有项目时，提供商登录/安装终端和普通终端不再报"Invalid project path" — 客户端不再发送硬编码的 `/workspace` 工作目录
- Windows: 多个提供商账户现在真正隔离凭据 — 账户预设会重定向 Windows CLI 读取的 USERPROFILE/APPDATA 变量（HOME/XDG_* 此前被忽略）
- Windows: Preview 通过 netstat 发现开发服务器端口（macOS 上通过 lsof）；向 Claude 共享技能不再因符号链接权限错误而失败
- Windows: 通过 npm/pnpm/bun 安装的 Antigravity CLI 现在可以被检测到（新增 ANTIGRAVITY_CLI_PATH 覆盖项，与 CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH 相同）；配额卡片读取真实主目录；系统更新不再因缺少 `sh` 而崩溃
<!-- lang:zh-TW -->
### 錯誤修復
- Windows: Agents 中的 LLM 模型清單現在會從已安裝的供應商 CLI 重新整理 — npm/pnpm/bun 的 `.cmd` 墊片可正確執行，不再退回內建目錄，失敗的探測會在一分鐘後重試而不是快取退回結果
- Windows: Devin MCP 的安裝/列出/移除以及 Devin 技能清單恢復可用（同樣的 `.cmd` 墊片修復）
- Windows: 沒有專案時，供應商登入/安裝終端機和一般終端機不再報「Invalid project path」 — 用戶端不再傳送硬編碼的 `/workspace` 工作目錄
- Windows: 多個供應商帳戶現在真正隔離憑證 — 帳戶預設會重新導向 Windows CLI 讀取的 USERPROFILE/APPDATA 變數（HOME/XDG_* 此前被忽略）
- Windows: Preview 透過 netstat 探索開發伺服器連接埠（macOS 上透過 lsof）；向 Claude 分享技能不再因符號連結權限錯誤而失敗
- Windows: 透過 npm/pnpm/bun 安裝的 Antigravity CLI 現在可以被偵測到（新增 ANTIGRAVITY_CLI_PATH 覆寫項，與 CLAUDE_CLI_PATH/COMMAND_CODE_CLI_PATH 相同）；配額卡片讀取真實主目錄；系統更新不再因缺少 `sh` 而當機
