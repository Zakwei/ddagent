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
### Bug fixes
- The panes overview now updates live: a tile turns amber when the agent asks you something and green while it is working, without reopening the window. Long status labels no longer overflow narrow phone tiles.
- A successful self-update no longer looks like it failed because of harmless npm warnings in the log.
<!-- lang:pl -->
### Poprawki
- Przegląd paneli aktualizuje się na żywo: kafelek robi się bursztynowy, gdy agent o coś pyta, i zielony, gdy pracuje — bez ponownego otwierania okna. Długie etykiety stanu nie wychodzą już poza wąskie kafelki na telefonie.
- Udana aktualizacja nie wygląda już na nieudaną przez nieszkodliwe ostrzeżenia npm w logu.
<!-- lang:de -->
### Fehlerbehebungen
- Die Bereichsübersicht aktualisiert sich jetzt live: Eine Kachel wird bernsteinfarben, wenn der Agent dich etwas fragt, und grün, während er arbeitet – ohne das Fenster neu zu öffnen. Lange Statusbeschriftungen laufen auf schmalen Handy-Kacheln nicht mehr über.
- Ein erfolgreiches Update wirkt nicht mehr fehlgeschlagen, nur weil harmlose npm-Warnungen im Log stehen.
<!-- lang:es -->
### Correcciones
- La vista general de paneles se actualiza en directo: una tarjeta se vuelve ámbar cuando el agente te pregunta algo y verde mientras trabaja, sin volver a abrir la ventana. Las etiquetas de estado largas ya no se desbordan en las tarjetas estrechas del móvil.
- Una actualización correcta ya no parece fallida por avisos inofensivos de npm en el registro.
<!-- lang:fr -->
### Corrections
- La vue d'ensemble des panneaux se met à jour en direct : une tuile passe à l'ambre quand l'agent vous pose une question et au vert pendant qu'il travaille, sans rouvrir la fenêtre. Les longues étiquettes d'état ne débordent plus des tuiles étroites sur mobile.
- Une mise à jour réussie ne semble plus avoir échoué à cause d'avertissements npm inoffensifs dans le journal.
<!-- lang:it -->
### Correzioni
- La panoramica dei pannelli si aggiorna in tempo reale: una scheda diventa ambra quando l'agente ti chiede qualcosa e verde mentre lavora, senza riaprire la finestra. Le etichette di stato lunghe non escono più dalle schede strette sul telefono.
- Un aggiornamento riuscito non sembra più fallito a causa di innocui avvisi npm nel log.
<!-- lang:ja -->
### バグ修正
- パネル一覧がリアルタイムで更新されるようになりました。エージェントが質問するとタイルが琥珀色に、作業中は緑色になり、ウィンドウを開き直す必要はありません。長い状態ラベルがスマートフォンの狭いタイルからはみ出さなくなりました。
- ログに無害な npm の警告が出ても、成功したアップデートが失敗したように見えなくなりました。
<!-- lang:ko -->
### 버그 수정
- 패널 개요가 실시간으로 갱신됩니다. 에이전트가 질문하면 타일이 호박색으로, 작업 중에는 초록색으로 바뀌며 창을 다시 열 필요가 없습니다. 긴 상태 라벨이 휴대폰의 좁은 타일 밖으로 넘치지 않습니다.
- 로그의 무해한 npm 경고 때문에 성공한 업데이트가 실패한 것처럼 보이지 않습니다.
<!-- lang:ru -->
### Исправления
- Обзор панелей обновляется в реальном времени: плитка становится янтарной, когда агент задаёт вопрос, и зелёной, пока он работает, — без повторного открытия окна. Длинные подписи статуса больше не выходят за узкие плитки на телефоне.
- Успешное обновление больше не выглядит неудачным из-за безобидных предупреждений npm в журнале.
<!-- lang:tr -->
### Hata düzeltmeleri
- Panel genel görünümü artık canlı güncelleniyor: ajan size bir şey sorduğunda kutucuk kehribar rengine, çalışırken yeşile döner; pencereyi yeniden açmanız gerekmez. Uzun durum etiketleri artık telefondaki dar kutucuklardan taşmıyor.
- Başarılı bir güncelleme, günlükteki zararsız npm uyarıları yüzünden artık başarısız görünmüyor.
<!-- lang:zh-CN -->
### 问题修复
- 窗格概览现在会实时更新：代理向你提问时卡片变为琥珀色，工作中变为绿色，无需重新打开窗口。较长的状态标签不再溢出手机上的窄卡片。
- 日志中无害的 npm 警告不再让成功的更新看起来像失败。
<!-- lang:zh-TW -->
### 問題修正
- 窗格總覽現在會即時更新：代理向你提問時卡片變為琥珀色，工作中變為綠色，無需重新開啟視窗。較長的狀態標籤不再溢出手機上的窄卡片。
- 日誌中無害的 npm 警告不再讓成功的更新看起來像失敗。
