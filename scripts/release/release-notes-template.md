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
- **Voice typing in the terminal (Android)**: Gboard dictation no longer stops partway through the first word. The terminal cleared the keyboard's text field after every recognised fragment, which ended the voice session; it now keeps the field and sends only what changed — corrections Gboard makes to its own text arrive as the right number of backspaces.
<!-- lang:pl -->
### Poprawki
- **Dyktowanie w terminalu (Android)**: dyktowanie Gboard nie urywa się już w połowie pierwszego słowa. Terminal czyścił pole klawiatury po każdym rozpoznanym fragmencie, co kończyło sesję głosową; teraz zachowuje pole i wysyła tylko zmiany — poprawki, które Gboard robi we własnym tekście, docierają jako właściwa liczba Backspace’ów.
<!-- lang:de -->
### Fehlerbehebungen
- **Spracheingabe im Terminal (Android)**: Das Gboard-Diktat bricht nicht mehr mitten im ersten Wort ab. Das Terminal leerte das Tastaturfeld nach jedem erkannten Fragment, was die Spracheingabe beendete; jetzt bleibt das Feld erhalten und nur Änderungen werden gesendet — Korrekturen, die Gboard an seinem eigenen Text vornimmt, kommen als passende Anzahl Rücktasten an.
<!-- lang:es -->
### Correcciones
- **Dictado por voz en el terminal (Android)**: el dictado de Gboard ya no se corta a mitad de la primera palabra. El terminal vaciaba el campo del teclado tras cada fragmento reconocido, lo que terminaba la sesión de voz; ahora conserva el campo y envía solo los cambios — las correcciones que Gboard hace en su propio texto llegan como el número correcto de retrocesos.
<!-- lang:fr -->
### Corrections
- **Saisie vocale dans le terminal (Android)** : la dictée Gboard ne s'arrête plus au milieu du premier mot. Le terminal vidait le champ du clavier après chaque fragment reconnu, ce qui mettait fin à la saisie vocale ; il conserve désormais le champ et n'envoie que les changements — les corrections que Gboard apporte à son propre texte arrivent sous forme du bon nombre de retours arrière.
<!-- lang:it -->
### Correzioni
- **Dettatura nel terminale (Android)**: la dettatura di Gboard non si interrompe più a metà della prima parola. Il terminale svuotava il campo della tastiera dopo ogni frammento riconosciuto, chiudendo la sessione vocale; ora mantiene il campo e invia solo le modifiche — le correzioni che Gboard fa al proprio testo arrivano come il giusto numero di Backspace.
<!-- lang:ja -->
### 修正
- **ターミナルでの音声入力（Android）**：Gboard の音声入力が最初の単語の途中で止まらなくなりました。ターミナルが認識された断片ごとにキーボードの入力欄を消去しており、それが音声セッションを終了させていました。現在は入力欄を保持して変更分だけを送信し、Gboard による自身のテキストの修正は正しい数の Backspace として届きます。
<!-- lang:ko -->
### 수정
- **터미널 음성 입력(Android)**: Gboard 음성 입력이 더 이상 첫 단어 중간에 끊기지 않습니다. 터미널이 인식된 조각마다 키보드 입력란을 비워 음성 세션이 종료되었습니다. 이제 입력란을 유지하고 바뀐 부분만 보내며, Gboard가 자신의 텍스트를 고치면 올바른 개수의 Backspace로 전달됩니다.
<!-- lang:ru -->
### Исправления
- **Голосовой ввод в терминале (Android)**: диктовка Gboard больше не обрывается посреди первого слова. Терминал очищал поле клавиатуры после каждого распознанного фрагмента, и это завершало голосовой сеанс; теперь поле сохраняется, а отправляются только изменения — исправления, которые Gboard вносит в свой текст, приходят нужным числом Backspace.
<!-- lang:tr -->
### Düzeltmeler
- **Terminalde sesle yazma (Android)**: Gboard dikte artık ilk kelimenin ortasında kesilmiyor. Terminal, tanınan her parçadan sonra klavye alanını temizliyordu ve bu ses oturumunu sonlandırıyordu; artık alan korunuyor ve yalnızca değişiklikler gönderiliyor — Gboard'un kendi metninde yaptığı düzeltmeler doğru sayıda Backspace olarak ulaşıyor.
<!-- lang:zh-CN -->
### 修复
- **终端语音输入（Android）**：Gboard 语音输入不再在第一个词中途中断。终端此前在每个识别出的片段之后清空键盘输入框，从而结束了语音会话；现在保留输入框，只发送变化的部分——Gboard 对自身文字的修改会以正确数量的退格键送达。
<!-- lang:zh-TW -->
### 修正
- **終端機語音輸入（Android）**：Gboard 語音輸入不再在第一個詞中途中斷。終端機先前在每個辨識出的片段之後清空鍵盤輸入框，因而結束了語音工作階段；現在保留輸入框，只傳送變更的部分——Gboard 對自身文字的修改會以正確數量的退格鍵送達。
