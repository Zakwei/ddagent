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
- **Voice typing works in the terminal on Android**: Gboard's microphone was greyed out there, because the terminal asked the keyboard not to learn from input, which Gboard treats as incognito mode.
- **The standalone terminal has a way back**: on a phone its tab strip now starts with the menu button, and on a desktop with the side menu hidden, with a button that shows it again. Before, opening it was a one-way trip.
<!-- lang:pl -->
### Poprawki
- **Pisanie głosowe działa w terminalu na Androidzie**: mikrofon Gboard był tam wyszarzony, bo terminal prosił klawiaturę, żeby nie uczyła się z wpisywanego tekstu, co Gboard traktuje jak tryb incognito.
- **Z osobnego terminala da się wrócić**: na telefonie jego pasek kart zaczyna się teraz od przycisku menu, a na komputerze z ukrytym menu bocznym od przycisku, który je przywraca. Wcześniej wejście tam było drogą w jedną stronę.
<!-- lang:de -->
### Fehlerbehebungen
- **Spracheingabe funktioniert im Terminal unter Android**: Das Mikrofon von Gboard war dort ausgegraut, weil das Terminal die Tastatur bat, nicht aus der Eingabe zu lernen – was Gboard als Inkognito-Modus behandelt.
- **Aus dem eigenständigen Terminal geht es wieder zurück**: Auf dem Handy beginnt seine Tab-Leiste jetzt mit der Menü-Schaltfläche, auf dem Desktop bei ausgeblendetem Seitenmenü mit einer Schaltfläche, die es wieder einblendet. Bisher war es eine Einbahnstraße.
<!-- lang:es -->
### Correcciones
- **El dictado por voz funciona en el terminal en Android**: el micrófono de Gboard aparecía desactivado ahí, porque el terminal pedía al teclado que no aprendiera de lo escrito, algo que Gboard trata como modo incógnito.
- **Del terminal independiente se puede volver**: en el móvil su barra de pestañas empieza ahora con el botón de menú y, en el escritorio con el menú lateral oculto, con un botón que lo vuelve a mostrar. Antes entrar era un camino sin vuelta.
<!-- lang:fr -->
### Corrections
- **La saisie vocale fonctionne dans le terminal sous Android** : le micro de Gboard y était grisé, car le terminal demandait au clavier de ne pas apprendre de la saisie, ce que Gboard traite comme le mode navigation privée.
- **On peut ressortir du terminal autonome** : sur téléphone, sa barre d'onglets commence désormais par le bouton de menu, et sur ordinateur avec le menu latéral masqué, par un bouton qui le réaffiche. Avant, y entrer était un aller simple.
<!-- lang:it -->
### Correzioni
- **La digitazione vocale funziona nel terminale su Android**: lì il microfono di Gboard era disattivato, perché il terminale chiedeva alla tastiera di non imparare dall'input, cosa che Gboard tratta come modalità in incognito.
- **Dal terminale autonomo si può tornare indietro**: sul telefono la sua barra delle schede ora inizia con il pulsante del menu e, sul desktop con il menu laterale nascosto, con un pulsante che lo mostra di nuovo. Prima entrarci era una strada senza ritorno.
<!-- lang:ja -->
### 修正
- **Android のターミナルで音声入力が使えるようになりました**：ターミナルがキーボードに入力内容を学習しないよう求めており、Gboard はこれをシークレットモードとして扱うため、マイクがグレー表示になっていました。
- **独立したターミナルから戻れるようになりました**：スマホではタブバーの先頭にメニューボタンが、デスクトップでサイドメニューを隠しているときはそれを再表示するボタンが表示されます。以前は一度開くと戻れませんでした。
<!-- lang:ko -->
### 수정
- **Android 터미널에서 음성 입력이 됩니다**: 터미널이 키보드에 입력 내용을 학습하지 말라고 요청했고, Gboard는 이를 시크릿 모드로 처리해 마이크가 비활성화되어 있었습니다.
- **독립 터미널에서 돌아갈 수 있습니다**: 휴대폰에서는 탭 표시줄 맨 앞에 메뉴 버튼이, 데스크톱에서 사이드 메뉴를 숨긴 경우에는 다시 표시하는 버튼이 있습니다. 이전에는 한 번 들어가면 돌아갈 수 없었습니다.
<!-- lang:ru -->
### Исправления
- **Голосовой ввод работает в терминале на Android**: микрофон Gboard был там неактивен, потому что терминал просил клавиатуру не обучаться на вводе, а Gboard считает это режимом инкогнито.
- **Из отдельного терминала можно вернуться**: на телефоне его панель вкладок теперь начинается с кнопки меню, а на компьютере со скрытым боковым меню — с кнопки, которая показывает его снова. Раньше войти туда было дорогой в один конец.
<!-- lang:tr -->
### Düzeltmeler
- **Android'de terminalde sesle yazma çalışıyor**: terminal klavyeden girdiden öğrenmemesini istiyordu; Gboard bunu gizli mod olarak ele aldığı için mikrofon orada gri görünüyordu.
- **Bağımsız terminalden geri dönülebiliyor**: telefonda sekme çubuğu artık menü düğmesiyle, masaüstünde yan menü gizliyken onu yeniden gösteren bir düğmeyle başlıyor. Önceden oraya girmek tek yönlü bir yoldu.
<!-- lang:zh-CN -->
### 修复
- **Android 终端中可以使用语音输入了**：终端要求键盘不要从输入中学习，Gboard 会将其视为无痕模式，因此麦克风显示为灰色。
- **可以从独立终端返回了**：在手机上，其标签栏开头现在有菜单按钮；在桌面端隐藏侧边菜单时，开头会有重新显示它的按钮。以前一旦进入就无法返回。
<!-- lang:zh-TW -->
### 修正
- **Android 終端機中可以使用語音輸入了**：終端機要求鍵盤不要從輸入中學習，Gboard 會將其視為無痕模式，因此麥克風呈灰色。
- **可以從獨立終端機返回了**：在手機上，其分頁列開頭現在有選單按鈕；在桌面端隱藏側邊選單時，開頭會有重新顯示它的按鈕。以前一旦進入就無法返回。
