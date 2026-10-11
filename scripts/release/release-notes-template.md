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
- Handoff button in the chat bar once the context passes 40%: the agent writes a summary of the conversation, a new chat on the same agent and project starts from it, and the window switches to it automatically.
<!-- lang:pl -->
### Nowości
- Przycisk „Handoff” w pasku czatu, gdy kontekst przekroczy 40%: agent pisze podsumowanie rozmowy, nowy czat z tym samym agentem i projektem startuje od niego, a okienko automatycznie się na niego przełącza.
<!-- lang:de -->
### Neu
- Übergabe-Schaltfläche in der Chatleiste ab 40 % Kontextauslastung: Der Agent fasst das Gespräch zusammen, ein neuer Chat mit demselben Agenten und Projekt startet damit, und das Fenster wechselt automatisch dorthin.
<!-- lang:es -->
### Novedades
- Botón «Traspaso» en la barra del chat cuando el contexto supera el 40 %: el agente resume la conversación, un chat nuevo con el mismo agente y proyecto parte de ese resumen y la ventana cambia a él automáticamente.
<!-- lang:fr -->
### Nouveautés
- Bouton « Passation » dans la barre du chat dès que le contexte dépasse 40 % : l'agent résume la conversation, un nouveau chat avec le même agent et projet repart de ce résumé, et la fenêtre bascule dessus automatiquement.
<!-- lang:it -->
### Novità
- Pulsante «Passaggio» nella barra della chat quando il contesto supera il 40%: l'agente riassume la conversazione, una nuova chat con lo stesso agente e progetto riparte dal riepilogo e la finestra passa automaticamente a essa.
<!-- lang:ja -->
### 新機能
- コンテキストが40%を超えるとチャットバーに「引き継ぎ」ボタンが表示されます。エージェントが会話を要約し、同じエージェントとプロジェクトの新しいチャットがその要約から始まり、ウィンドウが自動で切り替わります。
<!-- lang:ko -->
### 새 기능
- 컨텍스트가 40%를 넘으면 채팅 바에 ‘인계’ 버튼이 나타납니다. 에이전트가 대화를 요약하고, 같은 에이전트와 프로젝트로 새 채팅이 그 요약에서 시작되며, 창이 자동으로 전환됩니다.
<!-- lang:ru -->
### Новое
- Кнопка «Передача» в панели чата, когда контекст превышает 40%: агент кратко излагает разговор, новый чат с тем же агентом и проектом начинается с этой сводки, а окно автоматически переключается на него.
<!-- lang:tr -->
### Yenilikler
- Bağlam %40'ı aştığında sohbet çubuğunda “Devir” düğmesi: ajan konuşmayı özetler, aynı ajan ve projeyle yeni bir sohbet bu özetle başlar ve pencere otomatik olarak ona geçer.
<!-- lang:zh-CN -->
### 新功能
- 上下文超过 40% 时，聊天栏会显示“交接”按钮：智能体总结对话，使用同一智能体和项目的新对话从该摘要开始，窗口会自动切换过去。
<!-- lang:zh-TW -->
### 新功能
- 上下文超過 40% 時，聊天列會顯示「交接」按鈕：代理會總結對話，使用相同代理與專案的新對話從該摘要開始，視窗會自動切換過去。
