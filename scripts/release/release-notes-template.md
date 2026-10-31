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
### Terminal fixes and a tidier interface
- **Scrolling after a paste.** After Ctrl+V and sending a message, the mouse wheel stopped scrolling Claude Code until you switched tabs. Any Ctrl shortcut could cause it. Fixed.
- **Answer buttons for agent questions** now appear for the first question too, not only from the second one on.
- **Reloading the web page keeps your place.** Pressing F5 on Terminal, Usage or Settings no longer jumps back to Projects. An unknown address shows a "Page not found" screen with a way back.
- **Phone menu** is split into sections with headers: Work, Pages, More, App.
- **Cleaner look.** Switches are visible in dark mode. Buttons have readable contrast. Headers no longer overlap on phones. The pane close button sits at the right edge. All icons come from one set.
- **Small fixes.** Knowledge tabs start at the edge. Usage figures are fully readable in dark mode. Files no longer shows its title twice. Sign out is a proper button. "Prevent sleep" moved from Scheduler to Settings → Appearance.
<!-- lang:pl -->
### Poprawki terminala i porządniejszy interfejs
- **Przewijanie po wklejeniu.** Po Ctrl+V i wysłaniu wiadomości kółko myszy przestawało przewijać Claude Code, dopóki nie przełączyło się karty. Mógł to wywołać każdy skrót z Ctrl. Naprawione.
- **Przyciski odpowiedzi na pytania agenta** pojawiają się teraz także przy pierwszym pytaniu, a nie dopiero od drugiego.
- **Odświeżenie strony w przeglądarce zostawia Cię na miejscu.** F5 na Terminalu, Limitach czy w Ustawieniach nie przenosi już do Projektów. Nieznany adres pokazuje ekran „Nie znaleziono strony” z drogą powrotu.
- **Menu na telefonie** jest podzielone na sekcje z nagłówkami: Praca, Strony, Więcej, Aplikacja.
- **Czystszy wygląd.** Przełączniki są widoczne w ciemnym motywie. Przyciski mają czytelny kontrast. Nagłówki nie nachodzą na siebie na telefonie. Przycisk zamknięcia panelu jest przy prawej krawędzi. Wszystkie ikony pochodzą z jednego zestawu.
- **Drobne poprawki.** Zakładki w Wiedzy zaczynają się od krawędzi. Liczby w Limitach są w pełni czytelne w ciemnym motywie. Pliki nie pokazują już tytułu dwa razy. Wylogowanie to normalny przycisk. „Blokuj uśpienie” przeniesiono z Harmonogramu do Ustawienia → Wygląd.
<!-- lang:de -->
### Terminal-Korrekturen und eine aufgeräumtere Oberfläche
- **Scrollen nach dem Einfügen.** Nach Strg+V und dem Senden einer Nachricht scrollte das Mausrad Claude Code nicht mehr, bis man den Tab wechselte. Jede Strg-Tastenkombination konnte das auslösen. Behoben.
- **Antwortschaltflächen für Agentenfragen** erscheinen jetzt auch bei der ersten Frage, nicht erst ab der zweiten.
- **Neuladen der Webseite behält deine Position.** F5 im Terminal, in der Nutzung oder in den Einstellungen springt nicht mehr zu den Projekten zurück. Eine unbekannte Adresse zeigt die Seite „Seite nicht gefunden“ mit einem Weg zurück.
- **Das Handy-Menü** ist in Abschnitte mit Überschriften gegliedert: Arbeit, Seiten, Mehr, App.
- **Saubereres Aussehen.** Schalter sind im dunklen Modus sichtbar. Schaltflächen haben lesbaren Kontrast. Überschriften überlappen auf dem Handy nicht mehr. Die Schließen-Schaltfläche des Bereichs sitzt am rechten Rand. Alle Symbole stammen aus einem Satz.
- **Kleine Korrekturen.** Die Wissen-Tabs beginnen am Rand. Nutzungszahlen sind im dunklen Modus voll lesbar. Dateien zeigt den Titel nicht mehr doppelt. Abmelden ist eine richtige Schaltfläche. „Ruhezustand verhindern“ ist vom Planer nach Einstellungen → Darstellung umgezogen.
<!-- lang:es -->
### Correcciones del terminal y una interfaz más ordenada
- **Desplazamiento tras pegar.** Después de Ctrl+V y enviar un mensaje, la rueda del ratón dejaba de desplazar Claude Code hasta cambiar de pestaña. Cualquier atajo con Ctrl podía provocarlo. Corregido.
- **Los botones de respuesta a preguntas del agente** aparecen ahora también en la primera pregunta, no solo a partir de la segunda.
- **Recargar la página web te mantiene donde estabas.** F5 en Terminal, Uso o Ajustes ya no vuelve a Proyectos. Una dirección desconocida muestra la pantalla «Página no encontrada» con una forma de volver.
- **El menú del teléfono** está dividido en secciones con encabezados: Trabajo, Páginas, Más, App.
- **Aspecto más limpio.** Los interruptores se ven en el modo oscuro. Los botones tienen un contraste legible. Los encabezados ya no se solapan en el teléfono. El botón de cerrar el panel está en el borde derecho. Todos los iconos son del mismo conjunto.
- **Pequeñas correcciones.** Las pestañas de Conocimiento empiezan en el borde. Las cifras de Uso se leen bien en el modo oscuro. Archivos ya no muestra el título dos veces. Cerrar sesión es un botón de verdad. «Evitar suspensión» pasó del Programador a Ajustes → Apariencia.
<!-- lang:fr -->
### Corrections du terminal et une interface plus soignée
- **Défilement après un collage.** Après Ctrl+V et l'envoi d'un message, la molette ne faisait plus défiler Claude Code jusqu'à un changement d'onglet. N'importe quel raccourci Ctrl pouvait le provoquer. Corrigé.
- **Les boutons de réponse aux questions de l'agent** apparaissent désormais dès la première question, et plus seulement à partir de la deuxième.
- **Recharger la page web garde votre position.** F5 dans Terminal, Utilisation ou Paramètres ne renvoie plus aux Projets. Une adresse inconnue affiche l'écran « Page introuvable » avec un moyen de revenir.
- **Le menu du téléphone** est découpé en sections avec des titres : Travail, Pages, Plus, App.
- **Un aspect plus net.** Les interrupteurs sont visibles en mode sombre. Les boutons ont un contraste lisible. Les en-têtes ne se chevauchent plus sur le téléphone. Le bouton de fermeture du panneau est au bord droit. Toutes les icônes viennent d'un même jeu.
- **Petites corrections.** Les onglets de Connaissances commencent au bord. Les chiffres d'Utilisation sont bien lisibles en mode sombre. Fichiers n'affiche plus son titre deux fois. La déconnexion est un vrai bouton. « Empêcher la mise en veille » est passé du Planificateur à Paramètres → Apparence.
<!-- lang:it -->
### Correzioni del terminale e un'interfaccia più ordinata
- **Scorrimento dopo un incolla.** Dopo Ctrl+V e l'invio di un messaggio, la rotella del mouse non scorreva più Claude Code finché non si cambiava scheda. Qualsiasi scorciatoia con Ctrl poteva causarlo. Corretto.
- **I pulsanti di risposta alle domande dell'agente** compaiono ora anche alla prima domanda, non solo dalla seconda.
- **Ricaricare la pagina web ti lascia dove eri.** F5 su Terminale, Utilizzo o Impostazioni non riporta più a Progetti. Un indirizzo sconosciuto mostra la schermata «Pagina non trovata» con un modo per tornare indietro.
- **Il menu del telefono** è diviso in sezioni con intestazioni: Lavoro, Pagine, Altro, App.
- **Aspetto più pulito.** Gli interruttori sono visibili nel tema scuro. I pulsanti hanno un contrasto leggibile. Le intestazioni non si sovrappongono più sul telefono. Il pulsante di chiusura del pannello è sul bordo destro. Tutte le icone provengono da un unico set.
- **Piccole correzioni.** Le schede di Conoscenza partono dal bordo. I valori di Utilizzo sono pienamente leggibili nel tema scuro. File non mostra più il titolo due volte. Esci è un vero pulsante. «Impedisci sospensione» è passato da Pianificatore a Impostazioni → Aspetto.
<!-- lang:ja -->
### ターミナルの修正と、より整ったインターフェース
- **貼り付け後のスクロール。** Ctrl+V でメッセージを送信すると、タブを切り替えるまでマウスホイールで Claude Code をスクロールできなくなっていました。Ctrl を使うどのショートカットでも起きる可能性がありました。修正済みです。
- **エージェントの質問への回答ボタン**が、2 問目からではなく 1 問目から表示されるようになりました。
- **Web ページを再読み込みしても同じ場所に留まります。** ターミナル、使用量、設定で F5 を押してもプロジェクトに戻らなくなりました。不明なアドレスでは「ページが見つかりません」画面と戻る方法が表示されます。
- **スマートフォンのメニュー**が見出し付きのセクションに分かれました: 作業、ページ、その他、アプリ。
- **すっきりした見た目。** ダークモードでもスイッチが見えます。ボタンのコントラストが読みやすくなりました。スマートフォンで見出しが重ならなくなりました。ペインの閉じるボタンは右端にあります。アイコンはすべて 1 つのセットに統一されました。
- **細かな修正。** ナレッジのタブが端から始まります。使用量の数値がダークモードでもはっきり読めます。ファイル画面でタイトルが二重に表示されなくなりました。ログアウトは通常のボタンになりました。「スリープを防止」はスケジューラーから 設定 → 外観 に移動しました。
<!-- lang:ko -->
### 터미널 수정과 더 깔끔한 인터페이스
- **붙여넣기 후 스크롤.** Ctrl+V로 메시지를 보내면 탭을 바꿀 때까지 마우스 휠로 Claude Code를 스크롤할 수 없었습니다. Ctrl이 들어간 어떤 단축키로도 생길 수 있었습니다. 수정했습니다.
- **에이전트 질문에 대한 답변 버튼**이 두 번째 질문부터가 아니라 첫 번째 질문부터 표시됩니다.
- **웹 페이지를 새로 고쳐도 보던 곳에 머뭅니다.** 터미널, 사용량, 설정에서 F5를 눌러도 더 이상 프로젝트로 돌아가지 않습니다. 알 수 없는 주소에서는 돌아갈 방법과 함께 “페이지를 찾을 수 없습니다” 화면이 표시됩니다.
- **휴대폰 메뉴**가 제목이 있는 섹션으로 나뉩니다: 작업, 페이지, 더 보기, 앱.
- **더 깔끔한 모습.** 다크 모드에서도 스위치가 보입니다. 버튼 대비가 읽기 쉬워졌습니다. 휴대폰에서 헤더가 더 이상 겹치지 않습니다. 패널 닫기 버튼이 오른쪽 끝에 있습니다. 모든 아이콘이 한 세트로 통일되었습니다.
- **작은 수정.** 지식 탭이 가장자리에서 시작합니다. 사용량 수치가 다크 모드에서도 잘 읽힙니다. 파일 화면에 제목이 두 번 표시되지 않습니다. 로그아웃이 제대로 된 버튼이 되었습니다. “절전 방지”가 스케줄러에서 설정 → 모양으로 옮겨졌습니다.
<!-- lang:ru -->
### Исправления терминала и более аккуратный интерфейс
- **Прокрутка после вставки.** После Ctrl+V и отправки сообщения колесо мыши переставало прокручивать Claude Code, пока не переключишь вкладку. Это могло вызвать любое сочетание с Ctrl. Исправлено.
- **Кнопки ответа на вопросы агента** теперь появляются уже на первом вопросе, а не только со второго.
- **Перезагрузка веб-страницы оставляет вас на месте.** F5 в Терминале, Использовании или Настройках больше не возвращает к Проектам. По неизвестному адресу показывается экран «Страница не найдена» со способом вернуться.
- **Меню на телефоне** разделено на секции с заголовками: Работа, Страницы, Ещё, Приложение.
- **Более аккуратный вид.** Переключатели видны в тёмной теме. У кнопок читаемый контраст. Заголовки на телефоне больше не наезжают друг на друга. Кнопка закрытия панели стоит у правого края. Все значки из одного набора.
- **Мелкие исправления.** Вкладки Знаний начинаются от края. Цифры в Использовании хорошо читаются в тёмной теме. Файлы больше не показывают заголовок дважды. Выход — нормальная кнопка. «Не давать уснуть» перенесено из Планировщика в Настройки → Внешний вид.
<!-- lang:tr -->
### Terminal düzeltmeleri ve daha düzenli bir arayüz
- **Yapıştırdıktan sonra kaydırma.** Ctrl+V ile bir mesaj gönderdikten sonra fare tekerleği, sekme değiştirilene kadar Claude Code'u kaydırmıyordu. Ctrl içeren herhangi bir kısayol buna yol açabiliyordu. Düzeltildi.
- **Ajan sorularına yanıt düğmeleri** artık yalnızca ikinci sorudan itibaren değil, ilk soruda da görünüyor.
- **Web sayfasını yenilemek sizi olduğunuz yerde tutar.** Terminal, Kullanım veya Ayarlar'da F5 artık Projeler'e dönmüyor. Bilinmeyen bir adres, geri dönme yolu sunan “Sayfa bulunamadı” ekranını gösteriyor.
- **Telefon menüsü** başlıklı bölümlere ayrıldı: İş, Sayfalar, Daha fazla, Uygulama.
- **Daha temiz görünüm.** Anahtarlar koyu modda görünür. Düğmelerin kontrastı okunaklı. Başlıklar telefonda artık üst üste binmiyor. Panel kapatma düğmesi sağ kenarda. Tüm simgeler tek bir setten.
- **Küçük düzeltmeler.** Bilgi sekmeleri kenardan başlıyor. Kullanım rakamları koyu modda tam okunuyor. Dosyalar başlığı artık iki kez göstermiyor. Çıkış yap gerçek bir düğme. “Uykuyu engelle” Zamanlayıcı'dan Ayarlar → Görünüm'e taşındı.
<!-- lang:zh-CN -->
### 终端修复与更整洁的界面
- **粘贴后的滚动。** 用 Ctrl+V 粘贴并发送消息后,鼠标滚轮无法再滚动 Claude Code,直到切换标签页。任何 Ctrl 快捷键都可能引起这个问题。已修复。
- **智能体提问的回答按钮**现在从第一个问题就会出现,而不是从第二个问题才出现。
- **刷新网页会停留在原处。** 在终端、用量或设置中按 F5 不再跳回项目。未知地址会显示“页面未找到”界面,并提供返回入口。
- **手机菜单**分为带标题的分区:工作、页面、更多、应用。
- **更整洁的外观。** 深色模式下开关清晰可见。按钮对比度易于阅读。手机上的标题不再重叠。面板关闭按钮位于右侧边缘。所有图标统一为同一套。
- **小修正。** 知识库标签页从边缘开始。用量数字在深色模式下清晰可读。文件页不再重复显示标题。退出登录是一个正常按钮。“阻止休眠”已从计划任务移到 设置 → 外观。
<!-- lang:zh-TW -->
### 終端機修正與更整齊的介面
- **貼上後的捲動。** 用 Ctrl+V 貼上並送出訊息後,滑鼠滾輪無法再捲動 Claude Code,直到切換分頁。任何 Ctrl 快捷鍵都可能造成這個問題。已修正。
- **代理提問的回答按鈕**現在從第一個問題就會出現,而不是從第二個問題才出現。
- **重新整理網頁會停留在原處。** 在終端機、用量或設定中按 F5 不再跳回專案。未知網址會顯示「找不到頁面」畫面,並提供返回入口。
- **手機選單**分為帶標題的區塊:工作、頁面、更多、應用程式。
- **更整齊的外觀。** 深色模式下開關清晰可見。按鈕對比度易於閱讀。手機上的標題不再重疊。面板關閉按鈕位於右側邊緣。所有圖示統一為同一套。
- **小修正。** 知識庫分頁從邊緣開始。用量數字在深色模式下清晰可讀。檔案頁不再重複顯示標題。登出是一般按鈕。「防止休眠」已從排程移到 設定 → 外觀。
