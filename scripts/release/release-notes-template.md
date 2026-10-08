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
- Settings → About → Updates has its own button for each part: **Update app** (Android, Windows, Linux), **Update web interface** (web) and **Update server** — each with its installed and latest version.
- The server can update itself however it was installed: installer script, git checkout or release tarball. Tarballs are checked against their checksum, installed on restart and rolled back automatically if the new version fails to start.
- `start.sh` / `start.bat` now restart the server after an update or a restart from the app, without systemd.
- A web interface hosted by the server is updated together with it, or on its own.
- The desktop app's local server ("This device") can be updated on demand.

### Bug fixes
- The update message no longer tells you to tap an Update button that wasn't there.
- With both the app and the server out of date, the server update was unreachable; the update badge now lets you pick.

### Before you update
- Servers on 0.8.12 or older installed with the installer script or a tarball must be updated to 0.8.13 once by hand (re-run `install.sh --version v0.8.13`, or unpack the new tarball over the old one); after that, updates work from the app. Release tarballs need Node.js 22.
<!-- lang:pl -->
### Nowości
- Ustawienia → O aplikacji → Aktualizacje ma osobny przycisk dla każdej części: **Aktualizuj aplikację** (Android, Windows, Linux), **Aktualizuj interfejs web** (web) i **Aktualizuj serwer** — każdy z zainstalowaną i najnowszą wersją.
- Serwer aktualizuje się sam bez względu na sposób instalacji: skrypt instalacyjny, checkout gita albo tarball wydania. Tarballe są sprawdzane sumą kontrolną, instalowane przy restarcie i automatycznie wycofywane, jeśli nowa wersja nie wystartuje.
- `start.sh` / `start.bat` same restartują serwer po aktualizacji lub restarcie z aplikacji, bez systemd.
- Interfejs web hostowany przez serwer aktualizuje się razem z nim albo osobno.
- Lokalny serwer aplikacji desktop („To urządzenie”) można zaktualizować na żądanie.

### Poprawki błędów
- Komunikat o aktualizacji nie każe już klikać przycisku Aktualizuj, którego nie było.
- Gdy nieaktualne były i aplikacja, i serwer, aktualizacja serwera była niedostępna; ikonka aktualizacji pozwala teraz wybrać.

### Przed aktualizacją
- Serwery w wersji 0.8.12 lub starszej zainstalowane skryptem instalacyjnym albo z tarballa trzeba raz zaktualizować do 0.8.13 ręcznie (ponownie uruchom `install.sh --version v0.8.13` albo rozpakuj nowy tarball na stary); potem aktualizacje działają z aplikacji. Tarballe wydań wymagają Node.js 22.
<!-- lang:de -->
### Neu
- Einstellungen → Info → Updates hat für jeden Teil einen eigenen Button: **App aktualisieren** (Android, Windows, Linux), **Weboberfläche aktualisieren** (Web) und **Server aktualisieren** — jeweils mit installierter und neuester Version.
- Der Server aktualisiert sich selbst, egal wie er installiert wurde: Installationsskript, Git-Checkout oder Release-Tarball. Tarballs werden per Prüfsumme geprüft, beim Neustart installiert und automatisch zurückgerollt, wenn die neue Version nicht startet.
- `start.sh` / `start.bat` starten den Server nach einem Update oder Neustart aus der App selbst neu, ohne systemd.
- Eine vom Server gehostete Weboberfläche wird mit ihm oder einzeln aktualisiert.
- Der lokale Server der Desktop-App („Dieses Gerät“) lässt sich bei Bedarf aktualisieren.

### Fehlerbehebungen
- Die Update-Meldung verweist nicht mehr auf einen Aktualisieren-Button, den es nicht gab.
- Waren App und Server veraltet, war das Server-Update nicht erreichbar; die Update-Anzeige lässt jetzt wählen.

### Vor dem Update
- Server mit 0.8.12 oder älter, die per Installationsskript oder Tarball installiert wurden, müssen einmal von Hand auf 0.8.13 gebracht werden (`install.sh --version v0.8.13` erneut ausführen oder den neuen Tarball über den alten entpacken); danach funktionieren Updates aus der App. Release-Tarballs benötigen Node.js 22.
<!-- lang:es -->
### Novedades
- Ajustes → Acerca de → Actualizaciones tiene un botón para cada parte: **Actualizar app** (Android, Windows, Linux), **Actualizar interfaz web** (web) y **Actualizar servidor**, cada uno con su versión instalada y la más reciente.
- El servidor se actualiza solo, sin importar cómo se instaló: script de instalación, checkout de git o tarball de la versión. Los tarballs se verifican con su suma de comprobación, se instalan al reiniciar y se revierten automáticamente si la versión nueva no arranca.
- `start.sh` / `start.bat` reinician el servidor tras una actualización o un reinicio desde la app, sin systemd.
- Una interfaz web alojada por el servidor se actualiza junto con él o por separado.
- El servidor local de la app de escritorio («Este dispositivo») se puede actualizar cuando quieras.

### Correcciones
- El aviso de actualización ya no pide pulsar un botón Actualizar que no existía.
- Si la app y el servidor estaban desactualizados, la actualización del servidor no estaba disponible; el indicador de actualización ahora permite elegir.

### Antes de actualizar
- Los servidores con 0.8.12 o anterior instalados con el script de instalación o un tarball deben actualizarse a 0.8.13 una vez a mano (vuelve a ejecutar `install.sh --version v0.8.13` o descomprime el nuevo tarball sobre el antiguo); después, las actualizaciones funcionan desde la app. Los tarballs de las versiones requieren Node.js 22.
<!-- lang:fr -->
### Nouveautés
- Paramètres → À propos → Mises à jour propose un bouton pour chaque partie : **Mettre à jour l'application** (Android, Windows, Linux), **Mettre à jour l'interface web** (web) et **Mettre à jour le serveur**, chacun avec sa version installée et la plus récente.
- Le serveur se met à jour lui-même, quelle que soit son installation : script d'installation, checkout git ou archive de la version. Les archives sont vérifiées par somme de contrôle, installées au redémarrage et annulées automatiquement si la nouvelle version ne démarre pas.
- `start.sh` / `start.bat` redémarrent le serveur après une mise à jour ou un redémarrage depuis l'application, sans systemd.
- Une interface web hébergée par le serveur est mise à jour avec lui ou séparément.
- Le serveur local de l'application de bureau (« Cet appareil ») peut être mis à jour à la demande.

### Corrections
- Le message de mise à jour ne demande plus de cliquer sur un bouton Mettre à jour inexistant.
- Quand l'application et le serveur étaient tous deux en retard, la mise à jour du serveur était inaccessible ; l'indicateur de mise à jour permet maintenant de choisir.

### Avant la mise à jour
- Les serveurs en 0.8.12 ou plus ancien installés avec le script d'installation ou une archive doivent être mis à jour une fois à la main vers 0.8.13 (relancez `install.sh --version v0.8.13` ou décompressez la nouvelle archive par-dessus l'ancienne) ; ensuite, les mises à jour se font depuis l'application. Les archives des versions nécessitent Node.js 22.
<!-- lang:it -->
### Novità
- Impostazioni → Informazioni → Aggiornamenti ha un pulsante per ogni parte: **Aggiorna app** (Android, Windows, Linux), **Aggiorna interfaccia web** (web) e **Aggiorna server**, ognuno con la versione installata e l'ultima.
- Il server si aggiorna da solo, comunque sia stato installato: script di installazione, checkout git o tarball della release. I tarball vengono verificati con il checksum, installati al riavvio e annullati automaticamente se la nuova versione non parte.
- `start.sh` / `start.bat` riavviano il server dopo un aggiornamento o un riavvio dall'app, senza systemd.
- Un'interfaccia web ospitata dal server si aggiorna insieme a lui o da sola.
- Il server locale dell'app desktop («Questo dispositivo») si può aggiornare su richiesta.

### Correzioni
- Il messaggio di aggiornamento non chiede più di premere un pulsante Aggiorna che non c'era.
- Con app e server entrambi non aggiornati, l'aggiornamento del server non era raggiungibile; l'indicatore di aggiornamento ora permette di scegliere.

### Prima di aggiornare
- I server con 0.8.12 o precedente installati con lo script di installazione o un tarball vanno portati a 0.8.13 una volta a mano (riesegui `install.sh --version v0.8.13` o estrai il nuovo tarball sopra il vecchio); dopo, gli aggiornamenti funzionano dall'app. I tarball delle release richiedono Node.js 22.
<!-- lang:ja -->
### 新機能
- 設定 → 概要 → 更新 に、部分ごとのボタンが付きました：**アプリを更新**（Android、Windows、Linux）、**Web インターフェイスを更新**（Web）、**サーバーを更新**。それぞれインストール済みと最新のバージョンを表示します。
- サーバーはインストール方法（インストールスクリプト、git チェックアウト、リリースの tarball）にかかわらず自分で更新できます。tarball はチェックサムで検証され、再起動時にインストールされ、新しいバージョンが起動しない場合は自動的に元に戻ります。
- `start.sh` / `start.bat` は、アップデートやアプリからの再起動の後、systemd なしでサーバーを再起動します。
- サーバーがホストする Web インターフェイスは、サーバーと一緒に、または単独で更新されます。
- デスクトップアプリのローカルサーバー（「このデバイス」）を必要なときに更新できます。

### バグ修正
- アップデートの案内が、存在しない「更新」ボタンを押すよう求めなくなりました。
- アプリとサーバーの両方が古い場合にサーバーを更新できませんでしたが、アップデートバッジから選べるようになりました。

### アップデートの前に
- インストールスクリプトまたは tarball で導入した 0.8.12 以前のサーバーは、一度だけ手動で 0.8.13 に更新してください（`install.sh --version v0.8.13` を再実行するか、新しい tarball を古いものの上に展開）。その後はアプリから更新できます。リリースの tarball には Node.js 22 が必要です。
<!-- lang:ko -->
### 새 기능
- 설정 → 정보 → 업데이트에 부분별 버튼이 생겼습니다: **앱 업데이트**(Android, Windows, Linux), **웹 인터페이스 업데이트**(웹), **서버 업데이트**. 각각 설치된 버전과 최신 버전을 보여 줍니다.
- 서버는 설치 방식(설치 스크립트, git 체크아웃, 릴리스 tarball)과 관계없이 스스로 업데이트됩니다. tarball은 체크섬으로 검증되고, 재시작할 때 설치되며, 새 버전이 시작되지 않으면 자동으로 되돌립니다.
- `start.sh` / `start.bat`가 업데이트나 앱에서의 재시작 후 systemd 없이 서버를 다시 시작합니다.
- 서버가 호스팅하는 웹 인터페이스는 서버와 함께 또는 따로 업데이트됩니다.
- 데스크톱 앱의 로컬 서버('이 기기')를 원할 때 업데이트할 수 있습니다.

### 버그 수정
- 업데이트 안내가 더 이상 존재하지 않는 업데이트 버튼을 누르라고 하지 않습니다.
- 앱과 서버가 모두 오래되었을 때 서버 업데이트에 접근할 수 없었는데, 이제 업데이트 배지에서 선택할 수 있습니다.

### 업데이트 전에
- 설치 스크립트나 tarball로 설치한 0.8.12 이하 서버는 한 번만 직접 0.8.13으로 업데이트해야 합니다(`install.sh --version v0.8.13`을 다시 실행하거나 새 tarball을 기존 위치에 덮어서 풀기). 그 뒤로는 앱에서 업데이트됩니다. 릴리스 tarball에는 Node.js 22가 필요합니다.
<!-- lang:ru -->
### Что нового
- Настройки → О программе → Обновления у каждой части своя кнопка: **Обновить приложение** (Android, Windows, Linux), **Обновить веб-интерфейс** (веб) и **Обновить сервер** — с установленной и последней версией.
- Сервер обновляется сам независимо от способа установки: скрипт установки, git-checkout или архив релиза. Архивы проверяются по контрольной сумме, устанавливаются при перезапуске и автоматически откатываются, если новая версия не запускается.
- `start.sh` / `start.bat` сами перезапускают сервер после обновления или перезапуска из приложения, без systemd.
- Веб-интерфейс, который размещает сервер, обновляется вместе с ним или отдельно.
- Локальный сервер десктопного приложения («Это устройство») можно обновить по запросу.

### Исправления
- Сообщение об обновлении больше не предлагает нажать несуществующую кнопку «Обновить».
- Когда устарели и приложение, и сервер, обновить сервер было нельзя; теперь значок обновления позволяет выбрать.

### Перед обновлением
- Серверы версии 0.8.12 и старше, установленные скриптом или из архива, нужно один раз обновить до 0.8.13 вручную (повторно запустите `install.sh --version v0.8.13` или распакуйте новый архив поверх старого); после этого обновления работают из приложения. Архивам релизов нужен Node.js 22.
<!-- lang:tr -->
### Yenilikler
- Ayarlar → Hakkında → Güncellemeler bölümünde her parça için ayrı düğme var: **Uygulamayı güncelle** (Android, Windows, Linux), **Web arayüzünü güncelle** (web) ve **Sunucuyu güncelle** — her biri kurulu ve en son sürümüyle.
- Sunucu nasıl kurulduğundan bağımsız olarak kendini günceller: kurulum betiği, git checkout veya sürüm arşivi. Arşivler sağlama toplamıyla doğrulanır, yeniden başlatmada kurulur ve yeni sürüm başlamazsa otomatik olarak geri alınır.
- `start.sh` / `start.bat` bir güncellemeden veya uygulamadan yeniden başlatmadan sonra sunucuyu systemd olmadan yeniden başlatır.
- Sunucunun barındırdığı web arayüzü onunla birlikte ya da tek başına güncellenir.
- Masaüstü uygulamasının yerel sunucusu ("Bu cihaz") istendiğinde güncellenebilir.

### Hata düzeltmeleri
- Güncelleme mesajı artık olmayan bir Güncelle düğmesine basmanızı istemiyor.
- Hem uygulama hem sunucu eskiyken sunucu güncellemesine ulaşılamıyordu; güncelleme rozeti artık seçim sunuyor.

### Güncellemeden önce
- Kurulum betiği veya arşivle kurulmuş 0.8.12 ve öncesi sunucular bir kez elle 0.8.13'e güncellenmeli (`install.sh --version v0.8.13` komutunu yeniden çalıştırın veya yeni arşivi eskisinin üzerine açın); sonrasında güncellemeler uygulamadan çalışır. Sürüm arşivleri Node.js 22 gerektirir.
<!-- lang:zh-CN -->
### 新功能
- 设置 → 关于 → 更新 为每个部分提供单独的按钮：**更新应用**（Android、Windows、Linux）、**更新 Web 界面**（Web）和 **更新服务器**，并显示各自已安装和最新的版本。
- 无论服务器以何种方式安装（安装脚本、git 检出或发布的 tarball），都能自行更新。tarball 会用校验和验证，在重启时安装，新版本无法启动时会自动回滚。
- `start.sh` / `start.bat` 会在更新或从应用重启后自行重启服务器，无需 systemd。
- 服务器托管的 Web 界面会随服务器一起更新，也可以单独更新。
- 桌面应用的本地服务器（“此设备”）可以随时手动更新。

### 问题修复
- 更新提示不再要求点击并不存在的“更新”按钮。
- 应用和服务器都过期时无法更新服务器；现在更新标记可以让你选择。

### 更新之前
- 通过安装脚本或 tarball 安装的 0.8.12 及更早版本的服务器，需要手动更新到 0.8.13 一次（重新运行 `install.sh --version v0.8.13`，或将新的 tarball 解压覆盖旧文件）；之后即可在应用中更新。发布的 tarball 需要 Node.js 22。
<!-- lang:zh-TW -->
### 新功能
- 設定 → 關於 → 更新 為每個部分提供個別的按鈕：**更新應用程式**（Android、Windows、Linux）、**更新 Web 介面**（Web）和 **更新伺服器**，並顯示各自已安裝與最新的版本。
- 不論伺服器以何種方式安裝（安裝指令碼、git 簽出或發行版 tarball），都能自行更新。tarball 會以檢查碼驗證、在重新啟動時安裝，新版本無法啟動時會自動還原。
- `start.sh` / `start.bat` 會在更新或從應用程式重新啟動後自行重新啟動伺服器，不需要 systemd。
- 伺服器託管的 Web 介面會隨伺服器一起更新，也可以單獨更新。
- 桌面應用程式的本機伺服器（「此裝置」）可以隨時手動更新。

### 錯誤修正
- 更新提示不再要求點選並不存在的「更新」按鈕。
- 應用程式與伺服器都過期時無法更新伺服器；現在更新標記可以讓你選擇。

### 更新之前
- 以安裝指令碼或 tarball 安裝的 0.8.12 及更早版本伺服器，需要手動更新到 0.8.13 一次（重新執行 `install.sh --version v0.8.13`，或將新的 tarball 解壓縮覆蓋舊檔案）；之後即可從應用程式更新。發行版 tarball 需要 Node.js 22。
