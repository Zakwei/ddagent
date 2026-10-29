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
### Answering agent questions
- **When an agent asks you to pick an option** (for example Claude Code's questions), buttons with the answers appear under the terminal at every screen size. On a phone they are large, full-width buttons with two-line labels, so you answer with one tap instead of the arrow keys.
- Questions with long option descriptions are now detected reliably. On a phone the buttons often did not show up and the answer had to be given in the CLI.
<!-- lang:pl -->
### Odpowiadanie na pytania agenta
- **Gdy agent prosi o wybór opcji** (np. pytania Claude Code), pod terminalem pojawiają się przyciski z odpowiedziami, na każdym rozmiarze ekranu. Na telefonie to duże przyciski na całą szerokość z dwuwierszową etykietą: odpowiadasz jednym dotknięciem zamiast strzałkami.
- Pytania z długimi opisami opcji są teraz wykrywane niezawodnie. Na telefonie przyciski często się nie pojawiały i trzeba było odpowiadać w CLI.
<!-- lang:de -->
### Fragen des Agenten beantworten
- **Wenn ein Agent dich eine Option wählen lässt** (z. B. Fragen von Claude Code), erscheinen unter dem Terminal Schaltflächen mit den Antworten, bei jeder Bildschirmgröße. Auf dem Handy sind es große Schaltflächen über die volle Breite mit zweizeiliger Beschriftung: ein Tippen statt Pfeiltasten.
- Fragen mit langen Optionsbeschreibungen werden jetzt zuverlässig erkannt. Auf dem Handy fehlten die Schaltflächen oft und die Antwort musste in der CLI gegeben werden.
<!-- lang:es -->
### Responder a las preguntas del agente
- **Cuando un agente te pide elegir una opción** (por ejemplo, las preguntas de Claude Code), aparecen botones con las respuestas bajo el terminal en cualquier tamaño de pantalla. En el teléfono son botones grandes a todo el ancho con etiquetas de dos líneas: respondes con un toque en lugar de con las flechas.
- Las preguntas con descripciones de opciones largas ahora se detectan de forma fiable. En el teléfono los botones a menudo no aparecían y había que responder en la CLI.
<!-- lang:fr -->
### Répondre aux questions de l'agent
- **Quand un agent vous demande de choisir une option** (par exemple les questions de Claude Code), des boutons avec les réponses apparaissent sous le terminal, quelle que soit la taille de l'écran. Sur téléphone, ce sont de grands boutons pleine largeur avec des libellés sur deux lignes : un toucher suffit, plus besoin des flèches.
- Les questions aux descriptions d'options longues sont désormais détectées de façon fiable. Sur téléphone, les boutons n'apparaissaient souvent pas et il fallait répondre dans la CLI.
<!-- lang:it -->
### Rispondere alle domande dell'agente
- **Quando un agente ti chiede di scegliere un'opzione** (ad esempio le domande di Claude Code), sotto il terminale compaiono i pulsanti con le risposte, con qualsiasi dimensione dello schermo. Sul telefono sono pulsanti grandi a tutta larghezza con etichette su due righe: rispondi con un tocco invece che con le frecce.
- Le domande con descrizioni delle opzioni lunghe ora vengono rilevate in modo affidabile. Sul telefono i pulsanti spesso non comparivano e bisognava rispondere nella CLI.
<!-- lang:ja -->
### エージェントの質問への回答
- **エージェントが選択肢を選ぶよう求めたとき**(Claude Code の質問など)、画面サイズを問わずターミナルの下に回答ボタンが表示されます。スマートフォンでは 2 行ラベル付きの全幅の大きなボタンになり、矢印キーではなくタップ 1 回で回答できます。
- 選択肢の説明が長い質問も確実に検出されるようになりました。これまでスマートフォンではボタンが表示されないことが多く、CLI で回答する必要がありました。
<!-- lang:ko -->
### 에이전트 질문에 답하기
- **에이전트가 옵션 선택을 요청하면**(예: Claude Code의 질문) 화면 크기와 관계없이 터미널 아래에 답변 버튼이 나타납니다. 휴대폰에서는 두 줄 레이블이 있는 전체 너비의 큰 버튼으로 표시되어 화살표 키 대신 한 번의 탭으로 답할 수 있습니다.
- 옵션 설명이 긴 질문도 이제 안정적으로 감지됩니다. 이전에는 휴대폰에서 버튼이 자주 나타나지 않아 CLI에서 답해야 했습니다.
<!-- lang:ru -->
### Ответы на вопросы агента
- **Когда агент просит выбрать вариант** (например, вопросы Claude Code), под терминалом появляются кнопки с ответами — при любом размере экрана. На телефоне это крупные кнопки во всю ширину с подписью в две строки: отвечаете одним касанием вместо стрелок.
- Вопросы с длинными описаниями вариантов теперь распознаются надёжно. Раньше на телефоне кнопки часто не появлялись, и отвечать приходилось в CLI.
<!-- lang:tr -->
### Ajan sorularını yanıtlama
- **Bir ajan sizden bir seçenek seçmenizi istediğinde** (örneğin Claude Code soruları), her ekran boyutunda terminalin altında yanıt düğmeleri görünür. Telefonda iki satırlık etiketli, tam genişlikte büyük düğmelerdir: ok tuşları yerine tek dokunuşla yanıtlarsınız.
- Uzun seçenek açıklamalı sorular artık güvenilir şekilde algılanıyor. Telefonda düğmeler çoğu zaman görünmüyordu ve yanıtın CLI'da verilmesi gerekiyordu.
<!-- lang:zh-CN -->
### 回答智能体的问题
- **当智能体请你选择选项时**(例如 Claude Code 的提问),无论屏幕大小,终端下方都会出现答案按钮。在手机上它们是带两行标签的全宽大按钮,轻点一下即可回答,无需方向键。
- 选项描述较长的问题现在也能可靠识别。此前在手机上按钮经常不出现,只能在 CLI 中作答。
<!-- lang:zh-TW -->
### 回答代理程式的問題
- **當代理程式請你選擇選項時**(例如 Claude Code 的提問),無論螢幕大小,終端機下方都會出現答案按鈕。在手機上它們是帶兩行標籤的全寬大按鈕,輕點一下即可回答,不必使用方向鍵。
- 選項描述較長的問題現在也能可靠偵測。先前在手機上按鈕常常不出現,只能在 CLI 中作答。
