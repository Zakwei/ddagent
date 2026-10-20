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
- **Choose a terminal's project**: the terminal's tab strip shows the active tab's project; pick another one from it to open a new tab there. The pane remembers it for its next tabs (synced across devices). Before, a new terminal pane took the last used project and it could not be changed.
- **A terminal outside the panes**: a Terminal entry in the side menu and in the command palette (Ctrl+K) opens a full-screen terminal of its own, like a session opened from Sessions.
<!-- lang:pl -->
### Nowości
- **Wybór projektu terminala**: pasek kart terminala pokazuje projekt aktywnej karty; wybierz z niego inny, aby otworzyć w nim nową kartę. Panel zapamiętuje go dla kolejnych kart (synchronizowane między urządzeniami). Wcześniej nowy panel terminala dostawał ostatnio używany projekt i nie dało się go zmienić.
- **Terminal poza panelami**: wpis Terminal w menu bocznym i w palecie komend (Ctrl+K) otwiera osobny terminal na całym ekranie, tak jak sesję otwartą z listy Sesji.
<!-- lang:de -->
### Neu
- **Projekt eines Terminals wählen**: Die Tab-Leiste des Terminals zeigt das Projekt des aktiven Tabs; wähle dort ein anderes, um darin einen neuen Tab zu öffnen. Der Bereich merkt es sich für seine nächsten Tabs (geräteübergreifend synchronisiert). Bisher übernahm ein neuer Terminal-Bereich das zuletzt verwendete Projekt, und es ließ sich nicht ändern.
- **Ein Terminal außerhalb der Bereiche**: Ein Eintrag „Terminal“ im Seitenmenü und in der Befehlspalette (Strg+K) öffnet ein eigenes Vollbild-Terminal, wie eine aus „Sitzungen“ geöffnete Sitzung.
<!-- lang:es -->
### Novedades
- **Elige el proyecto de un terminal**: la barra de pestañas del terminal muestra el proyecto de la pestaña activa; elige otro ahí para abrir una pestaña nueva en él. El panel lo recuerda para sus siguientes pestañas (sincronizado entre dispositivos). Antes, un panel de terminal nuevo tomaba el último proyecto usado y no se podía cambiar.
- **Un terminal fuera de los paneles**: una entrada Terminal en el menú lateral y en la paleta de comandos (Ctrl+K) abre un terminal propio a pantalla completa, como una sesión abierta desde Sesiones.
<!-- lang:fr -->
### Nouveautés
- **Choisir le projet d'un terminal** : la barre d'onglets du terminal affiche le projet de l'onglet actif ; choisissez-en un autre pour y ouvrir un nouvel onglet. Le panneau le retient pour ses prochains onglets (synchronisé entre appareils). Avant, un nouveau panneau de terminal prenait le dernier projet utilisé et on ne pouvait pas le changer.
- **Un terminal hors des panneaux** : une entrée Terminal dans le menu latéral et dans la palette de commandes (Ctrl+K) ouvre un terminal plein écran à part, comme une session ouverte depuis Sessions.
<!-- lang:it -->
### Novità
- **Scegli il progetto di un terminale**: la barra delle schede del terminale mostra il progetto della scheda attiva; scegline un altro per aprirvi una nuova scheda. Il riquadro lo ricorda per le schede successive (sincronizzato tra dispositivi). Prima un nuovo riquadro del terminale prendeva l'ultimo progetto usato e non si poteva cambiare.
- **Un terminale fuori dai riquadri**: la voce Terminale nel menu laterale e nella palette dei comandi (Ctrl+K) apre un terminale a schermo intero a sé, come una sessione aperta da Sessioni.
<!-- lang:ja -->
### 新機能
- **ターミナルのプロジェクトを選べるようになりました**：ターミナルのタブバーにアクティブなタブのプロジェクトが表示され、別のプロジェクトを選ぶとそこに新しいタブが開きます。ペインは次のタブのためにそれを記憶します（デバイス間で同期）。以前は新しいターミナルペインが最後に使ったプロジェクトになり、変更できませんでした。
- **ペインの外でターミナルを開けます**：サイドメニューとコマンドパレット（Ctrl+K）の「ターミナル」から、セッション一覧から開いたセッションのように独立した全画面ターミナルを開けます。
<!-- lang:ko -->
### 새 기능
- **터미널의 프로젝트 선택**: 터미널 탭 표시줄에 활성 탭의 프로젝트가 표시되며, 여기서 다른 프로젝트를 고르면 그 프로젝트에 새 탭이 열립니다. 창은 다음 탭을 위해 이를 기억합니다(기기 간 동기화). 이전에는 새 터미널 창이 마지막으로 사용한 프로젝트로 고정되어 바꿀 수 없었습니다.
- **창 밖의 터미널**: 사이드 메뉴와 명령 팔레트(Ctrl+K)의 터미널 항목으로, 세션 목록에서 연 세션처럼 별도의 전체 화면 터미널을 엽니다.
<!-- lang:ru -->
### Новое
- **Выбор проекта терминала**: на панели вкладок терминала показан проект активной вкладки; выберите там другой, чтобы открыть в нём новую вкладку. Панель запоминает его для следующих вкладок (синхронизируется между устройствами). Раньше новая панель терминала получала последний использованный проект, и изменить его было нельзя.
- **Терминал вне панелей**: пункт «Терминал» в боковом меню и в палитре команд (Ctrl+K) открывает отдельный полноэкранный терминал, как сеанс, открытый из списка сеансов.
<!-- lang:tr -->
### Yenilikler
- **Bir terminalin projesini seçin**: terminalin sekme çubuğu etkin sekmenin projesini gösterir; orada başka bir proje seçerek içinde yeni bir sekme açın. Bölme bunu sonraki sekmeleri için hatırlar (cihazlar arasında eşitlenir). Önceden yeni bir terminal bölmesi son kullanılan projeyi alıyordu ve değiştirilemiyordu.
- **Bölmelerin dışında bir terminal**: yan menüdeki ve komut paletindeki (Ctrl+K) Terminal girişi, Oturumlar'dan açılan bir oturum gibi ayrı, tam ekran bir terminal açar.
<!-- lang:zh-CN -->
### 新功能
- **选择终端的项目**：终端的标签栏会显示当前标签页的项目；在这里选择其他项目即可在其中打开新标签页。面板会为之后的标签页记住它（在设备间同步）。以前新的终端面板会沿用上次使用的项目，且无法更改。
- **面板之外的终端**：侧边菜单和命令面板（Ctrl+K）中的“终端”入口会打开一个独立的全屏终端，就像从会话列表打开的会话一样。
<!-- lang:zh-TW -->
### 新功能
- **選擇終端機的專案**：終端機的分頁列會顯示目前分頁的專案；在這裡選擇其他專案即可在其中開啟新分頁。窗格會為之後的分頁記住它（在裝置間同步）。以前新的終端機窗格會沿用上次使用的專案，且無法變更。
- **窗格之外的終端機**：側邊選單和命令面板（Ctrl+K）中的「終端機」項目會開啟一個獨立的全螢幕終端機，就像從工作階段清單開啟的工作階段一樣。
