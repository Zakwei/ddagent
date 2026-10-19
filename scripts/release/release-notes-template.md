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
- **Terminal tabs follow you across devices**: the tabs of terminal panes and of the Terminal screen sync like the panes themselves — open, close, rename, reorder or select a tab on one device and your other devices show the same, attached to the same shell with its output.
- **One shell, several devices**: every device viewing a tab gets its live output and can type into it; the device you type on sets the shell's size, so opening the tab on a phone no longer reflows it on the desktop. Restarting a tab keeps the other devices attached.
- Every new shell or CLI tab starts its own shell — a CLI tab no longer lands in an already open shell.

### Fixes
- **No false login link**: addresses on localhost printed by a dev server (e.g. `http://localhost:5000/api/auth/login`) no longer show the "Login link" banner in the terminal.

Sync across devices needs the updated server.
<!-- lang:pl -->
### Nowości
- **Karty terminala podążają za Tobą między urządzeniami**: karty paneli terminala i ekranu Terminal synchronizują się tak jak same panele — otwarcie, zamknięcie, zmiana nazwy, kolejności czy wybór karty na jednym urządzeniu pojawia się na pozostałych, podpięte do tego samego shella z jego wyjściem.
- **Jeden shell, kilka urządzeń**: każde urządzenie, które ogląda kartę, dostaje jej wyjście na żywo i może w niej pisać; rozmiar shella ustawia urządzenie, na którym piszesz, więc otwarcie karty na telefonie nie przełamuje już widoku na desktopie. Restart karty zostawia pozostałe urządzenia podpięte.
- Każda nowa karta shella lub CLI startuje własny shell — karta CLI nie trafia już do otwartego wcześniej shella.

### Poprawki
- **Bez fałszywego linku logowania**: adresy localhost wypisywane przez serwer deweloperski (np. `http://localhost:5000/api/auth/login`) nie pokazują już w terminalu paska „Link logowania”.

Synchronizacja między urządzeniami wymaga zaktualizowanego serwera.
<!-- lang:de -->
### Neu
- **Terminal-Tabs folgen dir über Geräte hinweg**: Die Tabs von Terminal-Bereichen und des Terminal-Bildschirms werden wie die Bereiche selbst synchronisiert — Öffnen, Schließen, Umbenennen, Umsortieren oder Auswählen eines Tabs auf einem Gerät erscheint auf deinen anderen Geräten, verbunden mit derselben Shell samt Ausgabe.
- **Eine Shell, mehrere Geräte**: Jedes Gerät, das einen Tab zeigt, erhält die Live-Ausgabe und kann darin tippen; das Gerät, auf dem du tippst, bestimmt die Größe der Shell, sodass das Öffnen auf dem Handy die Ansicht am Desktop nicht mehr umbricht. Ein Neustart des Tabs lässt die anderen Geräte verbunden.
- Jeder neue Shell- oder CLI-Tab startet eine eigene Shell — ein CLI-Tab landet nicht mehr in einer bereits offenen Shell.

### Fehlerbehebungen
- **Kein falscher Anmeldelink**: Localhost-Adressen, die ein Entwicklungsserver ausgibt (z. B. `http://localhost:5000/api/auth/login`), zeigen im Terminal kein „Anmeldelink“-Banner mehr.

Die Synchronisierung zwischen Geräten erfordert den aktualisierten Server.
<!-- lang:es -->
### Novedades
- **Las pestañas del terminal te siguen entre dispositivos**: las pestañas de los paneles de terminal y de la pantalla Terminal se sincronizan como los propios paneles — abrir, cerrar, renombrar, reordenar o seleccionar una pestaña en un dispositivo aparece en los demás, conectada al mismo shell con su salida.
- **Un shell, varios dispositivos**: cada dispositivo que muestra una pestaña recibe su salida en directo y puede escribir en ella; el dispositivo en el que escribes fija el tamaño del shell, así que abrir la pestaña en el móvil ya no reajusta la vista del escritorio. Reiniciar una pestaña mantiene conectados los demás dispositivos.
- Cada nueva pestaña de shell o CLI inicia su propio shell — una pestaña CLI ya no acaba en un shell ya abierto.

### Correcciones
- **Sin enlaces de inicio de sesión falsos**: las direcciones localhost que imprime un servidor de desarrollo (p. ej. `http://localhost:5000/api/auth/login`) ya no muestran el aviso «Enlace de inicio de sesión» en el terminal.

La sincronización entre dispositivos requiere el servidor actualizado.
<!-- lang:fr -->
### Nouveautés
- **Les onglets du terminal vous suivent d'un appareil à l'autre** : les onglets des volets de terminal et de l'écran Terminal se synchronisent comme les volets eux-mêmes — ouvrir, fermer, renommer, réordonner ou sélectionner un onglet sur un appareil apparaît sur les autres, connecté au même shell avec sa sortie.
- **Un shell, plusieurs appareils** : chaque appareil qui affiche un onglet reçoit sa sortie en direct et peut y taper ; l'appareil sur lequel vous tapez fixe la taille du shell, si bien qu'ouvrir l'onglet sur le téléphone ne réagence plus la vue du bureau. Redémarrer un onglet laisse les autres appareils connectés.
- Chaque nouvel onglet shell ou CLI démarre son propre shell — un onglet CLI n'atterrit plus dans un shell déjà ouvert.

### Corrections
- **Plus de faux lien de connexion** : les adresses localhost affichées par un serveur de développement (par ex. `http://localhost:5000/api/auth/login`) n'affichent plus le bandeau « Lien de connexion » dans le terminal.

La synchronisation entre appareils nécessite le serveur mis à jour.
<!-- lang:it -->
### Novità
- **Le schede del terminale ti seguono tra i dispositivi**: le schede dei riquadri terminale e della schermata Terminale si sincronizzano come i riquadri stessi — aprire, chiudere, rinominare, riordinare o selezionare una scheda su un dispositivo compare sugli altri, collegata alla stessa shell con il suo output.
- **Una shell, più dispositivi**: ogni dispositivo che mostra una scheda riceve l'output in diretta e può scriverci; il dispositivo su cui scrivi imposta la dimensione della shell, quindi aprire la scheda sul telefono non riformatta più la vista sul desktop. Riavviare una scheda lascia collegati gli altri dispositivi.
- Ogni nuova scheda shell o CLI avvia una propria shell — una scheda CLI non finisce più in una shell già aperta.

### Correzioni
- **Niente falsi link di accesso**: gli indirizzi localhost stampati da un server di sviluppo (es. `http://localhost:5000/api/auth/login`) non mostrano più il banner «Link di accesso» nel terminale.

La sincronizzazione tra dispositivi richiede il server aggiornato.
<!-- lang:ja -->
### 新機能
- **ターミナルタブがデバイス間で同期**：ターミナルペインとターミナル画面のタブがペインと同じように同期されます。あるデバイスでタブを開く・閉じる・名前変更・並べ替え・選択すると、他のデバイスにも同じ状態が表示され、出力を含め同じシェルに接続されます。
- **1 つのシェルを複数のデバイスで**：タブを表示しているすべてのデバイスにライブ出力が届き、入力もできます。シェルのサイズは入力しているデバイスに合わせるため、スマートフォンでタブを開いてもデスクトップの表示が崩れません。タブを再起動しても他のデバイスは接続されたままです。
- 新しいシェルや CLI のタブはそれぞれ専用のシェルで起動します。CLI タブが既に開いているシェルに入ることはなくなりました。

### 修正
- **誤ったログインリンクを表示しない**：開発サーバーが出力する localhost のアドレス（例：`http://localhost:5000/api/auth/login`）で、ターミナルに「ログインリンク」バナーが表示されなくなりました。

デバイス間の同期には更新済みサーバーが必要です。
<!-- lang:ko -->
### 새로운 기능
- **터미널 탭이 기기 간에 따라옵니다**: 터미널 창과 터미널 화면의 탭이 창과 마찬가지로 동기화됩니다. 한 기기에서 탭을 열고, 닫고, 이름을 바꾸고, 순서를 바꾸거나 선택하면 다른 기기에도 똑같이 나타나며, 출력과 함께 같은 셸에 연결됩니다.
- **하나의 셸, 여러 기기**: 탭을 보고 있는 모든 기기가 실시간 출력을 받고 입력할 수 있습니다. 셸 크기는 입력 중인 기기에 맞춰지므로 휴대폰에서 탭을 열어도 데스크톱 화면이 다시 배치되지 않습니다. 탭을 다시 시작해도 다른 기기는 연결된 상태로 유지됩니다.
- 새 셸 또는 CLI 탭은 각자 자신의 셸로 시작합니다. CLI 탭이 이미 열려 있는 셸로 들어가지 않습니다.

### 수정
- **잘못된 로그인 링크 없음**: 개발 서버가 출력하는 localhost 주소(예: `http://localhost:5000/api/auth/login`)에 대해 터미널에 "로그인 링크" 배너가 더 이상 표시되지 않습니다.

기기 간 동기화에는 업데이트된 서버가 필요합니다.
<!-- lang:ru -->
### Что нового
- **Вкладки терминала следуют за вами между устройствами**: вкладки панелей терминала и экрана «Терминал» синхронизируются так же, как сами панели, — открытие, закрытие, переименование, изменение порядка или выбор вкладки на одном устройстве появляются на остальных, подключённые к той же оболочке вместе с её выводом.
- **Одна оболочка, несколько устройств**: каждое устройство, показывающее вкладку, получает её вывод в реальном времени и может в ней печатать; размер оболочки задаёт устройство, на котором вы печатаете, поэтому открытие вкладки на телефоне больше не перестраивает вид на компьютере. Перезапуск вкладки оставляет остальные устройства подключёнными.
- Каждая новая вкладка оболочки или CLI запускает собственную оболочку — вкладка CLI больше не попадает в уже открытую оболочку.

### Исправления
- **Без ложной ссылки для входа**: адреса localhost, которые выводит сервер разработки (например, `http://localhost:5000/api/auth/login`), больше не показывают в терминале баннер «Ссылка для входа».

Для синхронизации между устройствами нужен обновлённый сервер.
<!-- lang:tr -->
### Yenilikler
- **Terminal sekmeleri cihazlar arasında sizi izler**: Terminal bölmelerinin ve Terminal ekranının sekmeleri bölmelerin kendisi gibi eşitlenir — bir cihazda sekme açmak, kapatmak, yeniden adlandırmak, sıralamak veya seçmek diğer cihazlarda da görünür ve çıktısıyla birlikte aynı kabuğa bağlanır.
- **Tek kabuk, birden çok cihaz**: Bir sekmeyi gösteren her cihaz canlı çıktıyı alır ve içine yazabilir; kabuğun boyutunu yazdığınız cihaz belirler, bu yüzden sekmeyi telefonda açmak masaüstündeki görünümü artık yeniden düzenlemez. Sekmeyi yeniden başlatmak diğer cihazları bağlı tutar.
- Her yeni kabuk veya CLI sekmesi kendi kabuğunu başlatır — bir CLI sekmesi artık açık bir kabuğa düşmez.

### Düzeltmeler
- **Sahte giriş bağlantısı yok**: Bir geliştirme sunucusunun yazdığı localhost adresleri (ör. `http://localhost:5000/api/auth/login`) terminalde artık „Giriş bağlantısı” bandını göstermez.

Cihazlar arası eşitleme güncel sunucu gerektirir.
<!-- lang:zh-CN -->
### 新功能
- **终端标签跨设备同步**：终端面板和终端界面的标签会像面板本身一样同步——在一台设备上打开、关闭、重命名、排序或选择标签，你的其他设备也会同样显示，并连接到同一个 shell 及其输出。
- **一个 shell，多台设备**：每台显示该标签的设备都会收到实时输出并可输入；shell 的尺寸由你正在输入的设备决定，因此在手机上打开标签不会再打乱桌面上的显示。重启标签时其他设备保持连接。
- 每个新的 shell 或 CLI 标签都会启动自己的 shell——CLI 标签不再落入已打开的 shell。

### 修复
- **不再出现错误的登录链接**：开发服务器输出的 localhost 地址（例如 `http://localhost:5000/api/auth/login`）不再在终端中显示"登录链接"横幅。

跨设备同步需要更新后的服务器。
<!-- lang:zh-TW -->
### 新功能
- **終端機分頁跨裝置同步**：終端機面板與終端機畫面的分頁會像面板本身一樣同步——在一台裝置上開啟、關閉、重新命名、排序或選取分頁，你的其他裝置也會同樣顯示，並連接到同一個 shell 及其輸出。
- **一個 shell，多台裝置**：每台顯示該分頁的裝置都會收到即時輸出並可輸入；shell 的尺寸由你正在輸入的裝置決定，因此在手機上開啟分頁不會再打亂桌面上的畫面。重新啟動分頁時其他裝置保持連線。
- 每個新的 shell 或 CLI 分頁都會啟動自己的 shell——CLI 分頁不再落入已開啟的 shell。

### 修正
- **不再出現錯誤的登入連結**：開發伺服器輸出的 localhost 位址（例如 `http://localhost:5000/api/auth/login`）不再在終端機中顯示「登入連結」橫幅。

跨裝置同步需要更新後的伺服器。
