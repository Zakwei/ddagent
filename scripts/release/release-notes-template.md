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
- Windows installer: upgrading an existing install is now a real upgrade — the wizard shows the old → new version, uninstalls the old version first and keeps your settings and local server configuration.
- Windows installer: choose the installer language; it defaults to your Windows language.
- A pane whose agent finished its turn keeps its green tab after a reload and after you open it, until the agent starts again.
### Bug fixes
- A session reopened after its pane was closed shows its history again instead of an empty chat.
- On mobile, the model, mode, slash-command and mention menus open right above the composer when the keyboard is visible.
<!-- lang:pl -->
### Nowości
- Instalator Windows: instalacja na istniejącej wersji to teraz prawdziwa aktualizacja — kreator pokazuje starą → nową wersję, najpierw odinstalowuje starą i zachowuje ustawienia oraz konfigurację lokalnego serwera.
- Instalator Windows: wybór języka instalatora; domyślnie język systemu Windows.
- Panel, w którym agent zakończył turę, zachowuje zieloną kartę po przeładowaniu i po otwarciu — aż agent zacznie ponownie.
### Poprawki
- Sesja otwarta ponownie po zamknięciu panelu znów pokazuje historię zamiast pustego czatu.
- Na telefonie menu modelu, trybu, poleceń z ukośnikiem i wzmianek otwierają się tuż nad polem wiadomości przy widocznej klawiaturze.
<!-- lang:de -->
### Neu
- Windows-Installer: Die Installation über eine vorhandene Version ist jetzt ein echtes Update — der Assistent zeigt alte → neue Version, deinstalliert zuerst die alte und behält deine Einstellungen und die Konfiguration des lokalen Servers.
- Windows-Installer: Sprache des Installers wählbar; standardmäßig die Windows-Sprache.
- Ein Bereich, dessen Agent seinen Durchlauf beendet hat, behält seinen grünen Tab nach dem Neuladen und nach dem Öffnen, bis der Agent wieder startet.
### Fehlerbehebungen
- Eine nach dem Schließen ihres Bereichs wieder geöffnete Sitzung zeigt wieder ihren Verlauf statt eines leeren Chats.
- Auf Mobilgeräten öffnen sich die Menüs für Modell, Modus, Slash-Befehle und Erwähnungen bei eingeblendeter Tastatur direkt über dem Eingabefeld.
<!-- lang:es -->
### Novedades
- Instalador de Windows: instalar sobre una versión existente ahora es una actualización real: el asistente muestra la versión antigua → nueva, desinstala primero la antigua y conserva tus ajustes y la configuración del servidor local.
- Instalador de Windows: elige el idioma del instalador; por defecto, el idioma de Windows.
- Un panel cuyo agente terminó su turno conserva la pestaña verde tras recargar y tras abrirlo, hasta que el agente vuelva a empezar.
### Correcciones
- Una sesión reabierta después de cerrar su panel vuelve a mostrar su historial en lugar de un chat vacío.
- En el móvil, los menús de modelo, modo, comandos con barra y menciones se abren justo encima del campo de mensaje con el teclado visible.
<!-- lang:fr -->
### Nouveautés
- Installateur Windows : installer par-dessus une version existante est désormais une vraie mise à jour — l'assistant affiche l'ancienne → la nouvelle version, désinstalle d'abord l'ancienne et conserve vos paramètres et la configuration du serveur local.
- Installateur Windows : choix de la langue de l'installateur ; par défaut, la langue de Windows.
- Un volet dont l'agent a terminé son tour garde son onglet vert après un rechargement et après son ouverture, jusqu'à ce que l'agent reprenne.
### Corrections
- Une session rouverte après la fermeture de son volet affiche de nouveau son historique au lieu d'un chat vide.
- Sur mobile, les menus de modèle, de mode, de commandes slash et de mentions s'ouvrent juste au-dessus du champ de saisie quand le clavier est affiché.
<!-- lang:it -->
### Novità
- Installer Windows: installare sopra una versione esistente ora è un vero aggiornamento — la procedura mostra la versione vecchia → nuova, disinstalla prima la vecchia e mantiene le impostazioni e la configurazione del server locale.
- Installer Windows: scelta della lingua dell'installer; per impostazione predefinita, la lingua di Windows.
- Un riquadro il cui agente ha terminato il turno mantiene la scheda verde dopo il ricaricamento e dopo l'apertura, finché l'agente non riparte.
### Correzioni
- Una sessione riaperta dopo la chiusura del suo riquadro mostra di nuovo la cronologia invece di una chat vuota.
- Su mobile, i menu di modello, modalità, comandi slash e menzioni si aprono subito sopra il campo del messaggio con la tastiera visibile.
<!-- lang:ja -->
### 新機能
- Windows インストーラー：既存のインストールへの上書きが正式なアップグレードになりました。ウィザードに旧 → 新バージョンが表示され、先に旧バージョンをアンインストールし、設定とローカルサーバーの構成は保持されます。
- Windows インストーラー：インストーラーの言語を選択できます。既定は Windows の言語です。
- エージェントがターンを終えたペインは、再読み込み後や開いた後も、エージェントが再開するまで緑のタブを維持します。
### バグ修正
- ペインを閉じた後に再度開いたセッションで、空のチャットではなく履歴が表示されるようになりました。
- モバイルでキーボード表示中に、モデル・モード・スラッシュコマンド・メンションのメニューが入力欄のすぐ上に開くようになりました。
<!-- lang:ko -->
### 새 기능
- Windows 설치 프로그램: 기존 설치 위에 설치하면 이제 실제 업그레이드로 진행됩니다. 마법사가 이전 → 새 버전을 보여 주고, 이전 버전을 먼저 제거하며 설정과 로컬 서버 구성은 유지합니다.
- Windows 설치 프로그램: 설치 언어를 선택할 수 있으며, 기본값은 Windows 언어입니다.
- 에이전트가 턴을 마친 창은 새로고침 후와 창을 연 후에도 에이전트가 다시 시작할 때까지 녹색 탭을 유지합니다.
### 버그 수정
- 창을 닫은 뒤 다시 연 세션이 빈 채팅 대신 기록을 다시 표시합니다.
- 모바일에서 키보드가 보일 때 모델, 모드, 슬래시 명령, 멘션 메뉴가 입력란 바로 위에 열립니다.
<!-- lang:ru -->
### Новое
- Установщик Windows: установка поверх существующей версии теперь полноценное обновление — мастер показывает старую → новую версию, сначала удаляет старую и сохраняет ваши настройки и конфигурацию локального сервера.
- Установщик Windows: выбор языка установщика; по умолчанию — язык Windows.
- Панель, в которой агент завершил ход, сохраняет зелёную вкладку после перезагрузки и после открытия — до следующего запуска агента.
### Исправления
- Сессия, открытая повторно после закрытия её панели, снова показывает историю, а не пустой чат.
- На телефоне меню модели, режима, слэш-команд и упоминаний открываются прямо над полем ввода при открытой клавиатуре.
<!-- lang:tr -->
### Yenilikler
- Windows yükleyici: mevcut bir kurulumun üzerine yükleme artık gerçek bir yükseltme — sihirbaz eski → yeni sürümü gösterir, önce eski sürümü kaldırır ve ayarlarınızı ile yerel sunucu yapılandırmanızı korur.
- Windows yükleyici: yükleyici dilini seçin; varsayılan Windows dilidir.
- Ajanı turunu bitiren bir panel, yeniden yüklemeden ve açıldıktan sonra da ajan tekrar başlayana kadar yeşil sekmesini korur.
### Hata düzeltmeleri
- Paneli kapatıldıktan sonra yeniden açılan bir oturum, boş sohbet yerine geçmişini yeniden gösterir.
- Mobilde klavye açıkken model, mod, eğik çizgi komutu ve bahsetme menüleri mesaj alanının hemen üstünde açılır.
<!-- lang:zh-CN -->
### 新功能
- Windows 安装程序：在已有安装上安装现在是真正的升级——向导显示旧 → 新版本，先卸载旧版本，并保留您的设置和本地服务器配置。
- Windows 安装程序：可选择安装程序语言，默认使用 Windows 语言。
- 代理已完成回合的窗格在重新加载和打开后仍保持绿色标签，直到代理再次开始。
### 问题修复
- 关闭窗格后重新打开的会话会再次显示历史记录，而不是空白聊天。
- 在移动端键盘弹出时，模型、模式、斜杠命令和提及菜单会紧贴输入框上方打开。
<!-- lang:zh-TW -->
### 新功能
- Windows 安裝程式：在既有安裝上安裝現在是真正的升級——精靈會顯示舊 → 新版本，先解除安裝舊版本，並保留您的設定與本機伺服器設定。
- Windows 安裝程式：可選擇安裝程式語言，預設使用 Windows 語言。
- 代理已完成回合的窗格在重新載入及開啟後仍保留綠色分頁，直到代理再次開始。
### 錯誤修正
- 關閉窗格後重新開啟的工作階段會再次顯示歷史記錄，而非空白聊天。
- 在行動裝置上鍵盤顯示時，模型、模式、斜線指令與提及選單會緊貼輸入框上方開啟。
