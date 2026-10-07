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
- Android: the app now updates itself. When a newer release exists, the update banner downloads the APK and hands it to the Android installer — tap Update and confirm the install.
- Android builds are signed with a permanent release key from now on, so each version installs over the previous one without reinstalling.

### Bug fixes
- The update banner on a phone no longer updates only the connected server: it compares the app's own version and installs the new APK.
- Server: release info now lists the downloadable files, so the app can pick the right asset.
- Android: the release build resolves the signing keystore correctly — the wrong path made properly signed releases impossible.

### One-time step
- Builds up to v0.8.8 were signed with a temporary key, so Android refuses to install v0.8.9 over them. Uninstall the app once, install v0.8.9, and in-app updates work from then on.
<!-- lang:pl -->
### Nowości
- Android: aplikacja aktualizuje się teraz sama. Gdy pojawi się nowsze wydanie, banner aktualizacji pobiera APK i przekazuje go instalatorowi Androida — dotknij Aktualizuj i potwierdź instalację.
- Wydania na Androida są od teraz podpisywane stałym kluczem, więc każda wersja instaluje się na poprzednią bez przeinstalowywania.

### Poprawki błędów
- Banner aktualizacji na telefonie nie aktualizuje już tylko podłączonego serwera: porównuje wersję samej aplikacji i instaluje nowy APK.
- Serwer: informacje o wydaniu zawierają teraz listę plików do pobrania, więc aplikacja wybiera właściwy artefakt.
- Android: build wydania poprawnie odnajduje keystore — błędna ścieżka uniemożliwiała podpisane wydania.

### Jednorazowy krok
- Wersje do v0.8.8 włącznie były podpisane tymczasowym kluczem, więc Android nie zainstaluje na nie v0.8.9. Odinstaluj aplikację raz, zainstaluj v0.8.9 — od tego momentu aktualizacje w aplikacji działają.
<!-- lang:de -->
### Neu
- Android: Die App aktualisiert sich jetzt selbst. Gibt es eine neuere Version, lädt das Update-Banner die APK herunter und übergibt sie an den Android-Installer — auf Aktualisieren tippen und die Installation bestätigen.
- Android-Builds werden ab jetzt mit einem festen Release-Schlüssel signiert, sodass jede Version über die vorherige installiert wird — ohne Neuinstallation.

### Fehlerbehebungen
- Das Update-Banner auf dem Telefon aktualisiert nicht mehr nur den verbundenen Server: Es vergleicht die eigene App-Version und installiert die neue APK.
- Server: Die Release-Informationen listen nun die herunterladbaren Dateien auf, damit die App das richtige Artefakt findet.
- Android: Der Release-Build findet den Signatur-Keystore korrekt — der falsche Pfad machte signierte Releases unmöglich.

### Einmaliger Schritt
- Builds bis v0.8.8 waren mit einem temporären Schlüssel signiert, daher verweigert Android die Installation von v0.8.9 darüber. Deinstalliere die App einmal, installiere v0.8.9 — danach funktionieren In-App-Updates.
<!-- lang:es -->
### Novedades
- Android: la app ahora se actualiza sola. Cuando hay una versión más nueva, el aviso de actualización descarga el APK y lo entrega al instalador de Android — pulsa Actualizar y confirma la instalación.
- Las compilaciones de Android se firman a partir de ahora con una clave permanente, así cada versión se instala sobre la anterior sin reinstalar.

### Correcciones de errores
- El aviso de actualización en el teléfono ya no actualiza solo el servidor conectado: compara la versión de la propia app e instala el nuevo APK.
- Servidor: la información del lanzamiento ahora lista los archivos descargables, así la app elige el artefacto correcto.
- Android: la compilación de lanzamiento resuelve bien el keystore de firma — la ruta incorrecta impedía las versiones firmadas.

### Paso único
- Las versiones hasta v0.8.8 se firmaron con una clave temporal, así que Android no instala v0.8.9 sobre ellas. Desinstala la app una vez, instala v0.8.9 y desde entonces las actualizaciones en la app funcionan.
<!-- lang:fr -->
### Nouveautés
- Android : l'application se met désormais à jour toute seule. Quand une version plus récente existe, la bannière de mise à jour télécharge l'APK et le remet à l'installeur Android — appuyez sur Mettre à jour et confirmez l'installation.
- Les builds Android sont désormais signés avec une clé de release permanente, donc chaque version s'installe par-dessus la précédente sans réinstallation.

### Corrections de bugs
- La bannière de mise à jour sur téléphone ne met plus à jour uniquement le serveur connecté : elle compare la version de l'application elle-même et installe le nouvel APK.
- Serveur : les informations de version listent maintenant les fichiers téléchargeables, pour que l'application choisisse le bon artefact.
- Android : le build de release trouve correctement le keystore de signature — le mauvais chemin rendait toute release signée impossible.

### Étape unique
- Les versions jusqu'à v0.8.8 étaient signées avec une clé temporaire, donc Android refuse d'installer v0.8.9 par-dessus. Désinstallez l'application une fois, installez v0.8.9, et les mises à jour dans l'application fonctionneront ensuite.
<!-- lang:it -->
### Novità
- Android: l'app ora si aggiorna da sola. Quando esce una versione più recente, il banner di aggiornamento scarica l'APK e lo passa all'installer di Android — tocca Aggiorna e conferma l'installazione.
- Le build Android sono d'ora in poi firmate con una chiave di release permanente, così ogni versione si installa sopra la precedente senza reinstallare.

### Correzioni di bug
- Il banner di aggiornamento sul telefono non aggiorna più solo il server collegato: confronta la versione dell'app stessa e installa il nuovo APK.
- Server: le informazioni sulla release ora elencano i file scaricabili, così l'app sceglie l'artefatto giusto.
- Android: la build di release trova correttamente il keystore di firma — il percorso sbagliato rendeva impossibili le release firmate.

### Passo una tantum
- Le versioni fino alla v0.8.8 erano firmate con una chiave temporanea, quindi Android rifiuta di installare la v0.8.9 sopra di esse. Disinstalla l'app una volta, installa la v0.8.9 e da quel momento gli aggiornamenti in-app funzionano.
<!-- lang:ja -->
### 新機能
- Android: アプリが自分で更新できるようになりました。新しいリリースがあると、更新バナーが APK をダウンロードして Android のインストーラーに渡します — 「更新」を押してインストールを確認してください。
- Android ビルドは今後、恒久的なリリースキーで署名されます。以降のバージョンは再インストールなしで上書き更新できます。

### バグ修正
- スマホの更新バナーが接続中のサーバーだけを更新することはなくなりました: アプリ自身のバージョンを比較し、新しい APK をインストールします。
- サーバー: リリース情報にダウンロード可能なファイルの一覧が含まれ、アプリが適切な成果物を選べます。
- Android: リリースビルドが署名用キーストアを正しく解決するようになりました — 誤ったパスが署名済みリリースを不可能にしていました。

### 一度だけの手順
- v0.8.8 以前のビルドは一時的なキーで署名されているため、Android は v0.8.9 を上書きできません。一度アプリをアンインストールして v0.8.9 をインストールしてください。以降はアプリ内更新が機能します。
<!-- lang:ko -->
### 새로운 기능
- Android: 이제 앱이 스스로 업데이트합니다. 새 릴리스가 있으면 업데이트 배너가 APK를 내려받아 Android 설치 프로그램에 넘깁니다 — 업데이트를 누르고 설치를 확인하세요.
- Android 빌드는 이제 영구 릴리스 키로 서명되므로, 이후 버전은 재설치 없이 이전 버전 위에 설치됩니다.

### 버그 수정
- 휴대폰의 업데이트 배너가 더 이상 연결된 서버만 업데이트하지 않습니다: 앱 자체의 버전을 비교해 새 APK를 설치합니다.
- 서버: 릴리스 정보에 내려받을 수 있는 파일 목록이 포함되어 앱이 올바른 파일을 찾습니다.
- Android: 릴리스 빌드가 서명 키스토어를 올바르게 찾습니다 — 잘못된 경로 때문에 서명된 릴리스가 불가능했습니다.

### 일회성 단계
- v0.8.8까지의 빌드는 임시 키로 서명되어 Android가 v0.8.9를 덮어 설치할 수 없습니다. 앱을 한 번 삭제하고 v0.8.9를 설치하세요. 이후부터는 앱 내 업데이트가 동작합니다.
<!-- lang:ru -->
### Новое
- Android: приложение теперь обновляет себя само. Когда выходит новая версия, баннер обновления скачивает APK и передаёт его установщику Android — нажмите «Обновить» и подтвердите установку.
- Сборки Android теперь подписываются постоянным ключом, поэтому каждая версия ставится поверх предыдущей без переустановки.

### Исправления ошибок
- Баннер обновления на телефоне больше не обновляет только подключённый сервер: он сравнивает версию самого приложения и устанавливает новый APK.
- Сервер: информация о релизе теперь содержит список файлов для загрузки, поэтому приложение выбирает нужный артефакт.
- Android: релизная сборка корректно находит keystore для подписи — неверный путь делал подписанные релизы невозможными.

### Однократный шаг
- Версии до v0.8.8 включительно подписаны временным ключом, поэтому Android не установит v0.8.9 поверх них. Удалите приложение один раз, установите v0.8.9 — дальше обновления из приложения работают.
<!-- lang:tr -->
### Yenilikler
- Android: uygulama artık kendini güncelliyor. Yeni bir sürüm çıktığında güncelleme şeridi APK'yı indirip Android yükleyicisine verir — Güncelle'ye dokunun ve kurulumu onaylayın.
- Android derlemeleri artık kalıcı bir sürüm anahtarıyla imzalanıyor; böylece her sürüm yeniden kurulum olmadan öncekinin üzerine kurulur.

### Hata düzeltmeleri
- Telefondaki güncelleme şeridi artık yalnızca bağlı sunucuyu güncellemiyor: uygulamanın kendi sürümünü karşılaştırıp yeni APK'yı kuruyor.
- Sunucu: sürüm bilgisi artık indirilebilir dosyaları listeliyor, böylece uygulama doğru dosyayı buluyor.
- Android: sürüm derlemesi imzalama anahtar deposunu doğru buluyor — yanlış yol imzalı sürümleri imkânsız kılıyordu.

### Tek seferlik adım
- v0.8.8'e kadarki derlemeler geçici bir anahtarla imzalandığı için Android v0.8.9'u üzerlerine kurmaz. Uygulamayı bir kez kaldırın, v0.8.9'u kurun; sonrasında uygulama içi güncellemeler çalışır.
<!-- lang:zh-CN -->
### 新功能
- Android：应用现在可以自我更新。有新版本时，更新横幅会下载 APK 并交给 Android 安装程序 — 点“更新”并确认安装。
- Android 构建从今以后使用固定的发布密钥签名，因此每个版本都能直接覆盖安装上一个版本，无需重装。

### 错误修复
- 手机上的更新横幅不再只更新已连接的服务器：它会比较应用自身的版本并安装新的 APK。
- 服务器：版本信息现在会列出可下载的文件，应用能选到正确的产物。
- Android：发布构建现在能正确解析签名密钥库 — 错误的路径此前让签名发布无法实现。

### 一次性步骤
- v0.8.8 及更早的构建使用临时密钥签名，因此 Android 不允许在其上安装 v0.8.9。请先卸载应用一次，再安装 v0.8.9，之后应用内更新即可正常工作。
<!-- lang:zh-TW -->
### 新功能
- Android：應用程式現在會自我更新。有新版本時，更新橫幅會下載 APK 並交給 Android 安裝程式 — 點「更新」並確認安裝。
- Android 組建從現在起使用固定的發行金鑰簽署，因此每個版本都能直接覆蓋安裝上一版，無需重新安裝。

### 錯誤修復
- 手機上的更新橫幅不再只更新已連接的伺服器：它會比較應用程式本身的版本並安裝新的 APK。
- 伺服器：發行資訊現在會列出可下載的檔案，應用程式能選到正確的產物。
- Android：發行組建現在能正確解析簽署金鑰庫 — 錯誤的路徑先前讓簽署發行無法實現。

### 一次性步驟
- v0.8.8 及更早的組建使用臨時金鑰簽署，因此 Android 不允許在其上安裝 v0.8.9。請先解除安裝應用程式一次，再安裝 v0.8.9，之後應用程式內更新即可正常運作。
