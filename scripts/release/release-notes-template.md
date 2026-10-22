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
### Fixes
- **Claude Code buttons in the terminal**: clickable status-line buttons (mods) react again after a page reload and on phone taps. The terminal told Claude Code it had lost focus (on reload, and on every tap with the keyboard down), and Claude Code ignores clicks then.
- **Terminal title after a reload**: a restored session keeps the name its program set (e.g. Claude Code's session title) and its mouse and screen modes, even when that output is no longer in the replay buffer.
- **Scroll position when switching tabs**: each terminal tab returns to the place you scrolled to instead of jumping.
<!-- lang:pl -->
### Poprawki
- **Przyciski Claude Code w terminalu**: klikalne przyciski paska stanu (mody) znów reagują po przeładowaniu strony i po dotknięciu na telefonie. Terminal zgłaszał Claude Code utratę fokusu (po przeładowaniu i przy każdym dotknięciu ze schowaną klawiaturą), a wtedy Claude Code ignoruje kliknięcia.
- **Tytuł terminala po przeładowaniu**: przywrócona sesja zachowuje nazwę ustawioną przez program (np. tytuł sesji Claude Code) oraz tryby myszy i ekranu, nawet gdy tego wyjścia nie ma już w buforze odtwarzania.
- **Pozycja przewinięcia przy zmianie kart**: każda karta terminala wraca w miejsce, do którego ją przewinięto, zamiast skakać.
<!-- lang:de -->
### Fehlerbehebungen
- **Claude-Code-Schaltflächen im Terminal**: Klickbare Statusleisten-Schaltflächen (Mods) reagieren wieder nach einem Neuladen der Seite und beim Tippen auf dem Handy. Das Terminal meldete Claude Code einen Fokusverlust (beim Neuladen und bei jedem Tippen mit eingeklappter Tastatur), und dann ignoriert Claude Code Klicks.
- **Terminaltitel nach dem Neuladen**: Eine wiederhergestellte Sitzung behält den Namen, den ihr Programm gesetzt hat (z. B. den Sitzungstitel von Claude Code), sowie Maus- und Bildschirmmodi, auch wenn diese Ausgabe nicht mehr im Wiedergabepuffer liegt.
- **Scrollposition beim Tabwechsel**: Jeder Terminal-Tab kehrt an die Stelle zurück, an die du gescrollt hast, statt zu springen.
<!-- lang:es -->
### Correcciones
- **Botones de Claude Code en el terminal**: los botones clicables de la barra de estado (mods) vuelven a responder tras recargar la página y al tocar en el teléfono. El terminal indicaba a Claude Code que había perdido el foco (al recargar y en cada toque con el teclado oculto), y entonces Claude Code ignora los clics.
- **Título del terminal tras recargar**: una sesión restaurada conserva el nombre que fijó su programa (p. ej. el título de sesión de Claude Code) y sus modos de ratón y pantalla, aunque esa salida ya no esté en el búfer de reproducción.
- **Posición de desplazamiento al cambiar de pestaña**: cada pestaña del terminal vuelve al punto al que la desplazaste en lugar de saltar.
<!-- lang:fr -->
### Corrections
- **Boutons Claude Code dans le terminal** : les boutons cliquables de la barre d'état (mods) réagissent de nouveau après un rechargement de la page et aux appuis sur téléphone. Le terminal signalait à Claude Code une perte de focus (au rechargement et à chaque appui clavier masqué), et Claude Code ignore alors les clics.
- **Titre du terminal après rechargement** : une session restaurée conserve le nom défini par son programme (par ex. le titre de session de Claude Code) ainsi que ses modes souris et écran, même quand cette sortie n'est plus dans le tampon de relecture.
- **Position de défilement au changement d'onglet** : chaque onglet du terminal revient à l'endroit où vous l'aviez fait défiler au lieu de sauter.
<!-- lang:it -->
### Correzioni
- **Pulsanti di Claude Code nel terminale**: i pulsanti cliccabili della barra di stato (mod) tornano a rispondere dopo il ricaricamento della pagina e ai tocchi sul telefono. Il terminale segnalava a Claude Code la perdita del focus (al ricaricamento e a ogni tocco con la tastiera chiusa), e allora Claude Code ignora i clic.
- **Titolo del terminale dopo il ricaricamento**: una sessione ripristinata mantiene il nome impostato dal programma (ad es. il titolo di sessione di Claude Code) e le modalità mouse e schermo, anche quando quell'output non è più nel buffer di riproduzione.
- **Posizione di scorrimento al cambio scheda**: ogni scheda del terminale torna al punto in cui l'avevi scorsa invece di saltare.
<!-- lang:ja -->
### 修正
- **ターミナル内の Claude Code ボタン**：ステータスラインのクリック可能なボタン（mod）が、ページ再読み込み後やスマホでのタップでも再び反応するようになりました。ターミナルが Claude Code にフォーカス喪失を通知しており（再読み込み時、およびキーボードを閉じた状態でのタップごと）、その間 Claude Code はクリックを無視していました。
- **再読み込み後のターミナルタイトル**：復元されたセッションは、プログラムが設定した名前（Claude Code のセッションタイトルなど）とマウス・画面モードを保持します。その出力が再生バッファから消えていても同様です。
- **タブ切り替え時のスクロール位置**：各ターミナルタブは、ジャンプせずにスクロールした位置へ戻ります。
<!-- lang:ko -->
### 수정
- **터미널의 Claude Code 버튼**: 상태 표시줄의 클릭 가능한 버튼(mod)이 페이지를 새로고침한 뒤와 휴대폰에서 탭할 때 다시 반응합니다. 터미널이 Claude Code에 포커스를 잃었다고 알렸고(새로고침 시, 그리고 키보드가 내려간 상태에서 탭할 때마다), 그동안 Claude Code는 클릭을 무시했습니다.
- **새로고침 후 터미널 제목**: 복원된 세션은 프로그램이 설정한 이름(예: Claude Code 세션 제목)과 마우스·화면 모드를 유지합니다. 그 출력이 재생 버퍼에 더 이상 없어도 마찬가지입니다.
- **탭 전환 시 스크롤 위치**: 각 터미널 탭이 튀지 않고 스크롤해 둔 위치로 돌아갑니다.
<!-- lang:ru -->
### Исправления
- **Кнопки Claude Code в терминале**: кликабельные кнопки строки состояния (моды) снова реагируют после перезагрузки страницы и при касании на телефоне. Терминал сообщал Claude Code о потере фокуса (при перезагрузке и при каждом касании со скрытой клавиатурой), а в этом состоянии Claude Code игнорирует клики.
- **Заголовок терминала после перезагрузки**: восстановленный сеанс сохраняет имя, заданное программой (например, заголовок сеанса Claude Code), а также режимы мыши и экрана, даже если этого вывода уже нет в буфере воспроизведения.
- **Позиция прокрутки при смене вкладок**: каждая вкладка терминала возвращается туда, куда вы её прокрутили, а не прыгает.
<!-- lang:tr -->
### Düzeltmeler
- **Terminaldeki Claude Code düğmeleri**: durum satırındaki tıklanabilir düğmeler (mod'lar) sayfa yeniden yüklendikten sonra ve telefonda dokunulduğunda yeniden tepki veriyor. Terminal, Claude Code'a odağın kaybolduğunu bildiriyordu (yeniden yüklemede ve klavye kapalıyken her dokunuşta) ve Claude Code bu durumda tıklamaları yok sayıyor.
- **Yeniden yüklemeden sonra terminal başlığı**: geri yüklenen oturum, programının belirlediği adı (ör. Claude Code oturum başlığı) ile fare ve ekran modlarını koruyor; bu çıktı artık yeniden oynatma arabelleğinde olmasa bile.
- **Sekme değiştirirken kaydırma konumu**: her terminal sekmesi zıplamak yerine kaydırdığınız yere geri dönüyor.
<!-- lang:zh-CN -->
### 修复
- **终端中的 Claude Code 按钮**：状态栏中可点击的按钮（mod）在页面重新加载后以及在手机上点按时会再次响应。终端此前会告诉 Claude Code 已失去焦点（重新加载时，以及键盘收起时的每次点按），而此时 Claude Code 会忽略点击。
- **重新加载后的终端标题**：恢复的会话会保留其程序设置的名称（例如 Claude Code 的会话标题）以及鼠标和屏幕模式，即使这些输出已不在回放缓冲区中。
- **切换标签页时的滚动位置**：每个终端标签页都会回到你滚动到的位置，而不会跳动。
<!-- lang:zh-TW -->
### 修正
- **終端機中的 Claude Code 按鈕**：狀態列中可點擊的按鈕（mod）在頁面重新載入後以及在手機上點按時會再次回應。終端機先前會告訴 Claude Code 已失去焦點（重新載入時，以及鍵盤收起時的每次點按），而此時 Claude Code 會忽略點擊。
- **重新載入後的終端機標題**：還原的工作階段會保留其程式設定的名稱（例如 Claude Code 的工作階段標題）以及滑鼠和螢幕模式，即使這些輸出已不在重播緩衝區中。
- **切換分頁時的捲動位置**：每個終端機分頁都會回到你捲動到的位置，而不會跳動。
