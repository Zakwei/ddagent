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
- Chat: switching a session's model on one device now updates the model shown on your other devices right away. Before, a phone that had the session open could keep showing the old model and send the next message with it, switching the session back.
<!-- lang:pl -->
### Poprawki
- Czat: zmiana modelu sesji na jednym urządzeniu od razu aktualizuje model widoczny na pozostałych. Wcześniej telefon z otwartą sesją mógł dalej pokazywać stary model i wysłać nim kolejną wiadomość, przełączając sesję z powrotem.
<!-- lang:de -->
### Fehlerbehebungen
- Chat: Wenn du das Modell einer Sitzung auf einem Gerät wechselst, zeigen deine anderen Geräte sofort das neue Modell. Bisher konnte ein Handy mit offener Sitzung weiter das alte Modell anzeigen und die nächste Nachricht damit senden, wodurch die Sitzung zurückgestellt wurde.
<!-- lang:es -->
### Correcciones
- Chat: al cambiar el modelo de una sesión en un dispositivo, tus otros dispositivos muestran el nuevo modelo al instante. Antes, un móvil con la sesión abierta podía seguir mostrando el modelo anterior y enviar el siguiente mensaje con él, devolviendo la sesión a ese modelo.
<!-- lang:fr -->
### Corrections
- Chat : changer le modèle d'une session sur un appareil met désormais à jour le modèle affiché sur vos autres appareils. Auparavant, un téléphone avec la session ouverte pouvait garder l'ancien modèle et envoyer le message suivant avec lui, rebasculant la session.
<!-- lang:it -->
### Correzioni
- Chat: cambiare il modello di una sessione su un dispositivo aggiorna subito il modello mostrato sugli altri. Prima un telefono con la sessione aperta poteva continuare a mostrare il vecchio modello e inviare il messaggio successivo con quello, riportando indietro la sessione.
<!-- lang:ja -->
### 修正
- チャット：ある端末でセッションのモデルを切り替えると、他の端末の表示もすぐに更新されるようになりました。以前は、セッションを開いたままのスマホが古いモデルを表示し続け、次のメッセージをそのモデルで送信してセッションを元に戻してしまうことがありました。
<!-- lang:ko -->
### 수정
- 채팅: 한 기기에서 세션 모델을 바꾸면 다른 기기에 표시되는 모델도 바로 업데이트됩니다. 이전에는 세션을 열어 둔 휴대폰이 이전 모델을 계속 표시하고 다음 메시지를 그 모델로 보내 세션을 되돌릴 수 있었습니다.
<!-- lang:ru -->
### Исправления
- Чат: смена модели сессии на одном устройстве теперь сразу отражается на остальных. Раньше телефон с открытой сессией мог показывать старую модель и отправить ею следующее сообщение, переключив сессию обратно.
<!-- lang:tr -->
### Düzeltmeler
- Sohbet: Bir cihazda oturumun modelini değiştirmek artık diğer cihazlarda gösterilen modeli hemen günceller. Önceden oturumu açık olan bir telefon eski modeli göstermeye devam edip sonraki mesajı onunla gönderebiliyor ve oturumu geri çeviriyordu.
<!-- lang:zh-CN -->
### 修复
- 聊天：在一台设备上切换会话模型后，其他设备上显示的模型会立即更新。此前，打开该会话的手机可能仍显示旧模型，并用它发送下一条消息，导致会话被切回。
<!-- lang:zh-TW -->
### 修正
- 聊天：在一台裝置上切換工作階段的模型後，其他裝置顯示的模型會立即更新。先前開著該工作階段的手機可能仍顯示舊模型，並用它傳送下一則訊息，使工作階段被切回。
