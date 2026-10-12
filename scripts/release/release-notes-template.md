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
- Chat: text selection and copying in the session pane no longer stop working in the browser after the mouse moves in or out of the chat.
- Limits: extra Claude accounts no longer show as logged out once their access token expires while idle — it is now refreshed automatically.
<!-- lang:pl -->
### Poprawki
- Czat: zaznaczanie i kopiowanie tekstu w panelu sesji nie przestaje już działać w przeglądarce po wjechaniu kursorem do czatu lub wyjechaniu z niego.
- Limity: dodatkowe konta Claude nie wyglądają już na wylogowane, gdy ich token wygaśnie w czasie bezczynności — jest teraz odświeżany automatycznie.
<!-- lang:de -->
### Korrekturen
- Chat: Textauswahl und Kopieren im Sitzungsbereich funktionieren im Browser jetzt weiter, nachdem die Maus in den Chat hinein- oder herausbewegt wurde.
- Limits: Zusätzliche Claude-Konten erscheinen nicht mehr als abgemeldet, wenn ihr Zugriffstoken im Leerlauf abläuft – es wird jetzt automatisch erneuert.
<!-- lang:es -->
### Correcciones
- Chat: la selección y copia de texto en el panel de sesión ya no deja de funcionar en el navegador al mover el ratón dentro o fuera del chat.
- Límites: las cuentas de Claude adicionales ya no aparecen como desconectadas cuando su token de acceso caduca por inactividad; ahora se renueva automáticamente.
<!-- lang:fr -->
### Corrections
- Chat : la sélection et la copie de texte dans le panneau de session ne cessent plus de fonctionner dans le navigateur lorsque la souris entre dans le chat ou en sort.
- Limites : les comptes Claude supplémentaires n'apparaissent plus comme déconnectés lorsque leur jeton d'accès expire pendant l'inactivité ; il est désormais renouvelé automatiquement.
<!-- lang:it -->
### Correzioni
- Chat: la selezione e la copia del testo nel pannello della sessione non smettono più di funzionare nel browser quando il mouse entra o esce dalla chat.
- Limiti: gli account Claude aggiuntivi non risultano più disconnessi quando il token di accesso scade durante l'inattività: ora viene rinnovato automaticamente.
<!-- lang:ja -->
### 修正
- チャット：ブラウザーでマウスをチャットに出し入れした後も、セッション画面のテキスト選択とコピーが動作し続けるようになりました。
- 利用上限：追加の Claude アカウントが、未使用中にアクセストークンの期限が切れてもログアウト扱いにならなくなりました。トークンは自動で更新されます。
<!-- lang:ko -->
### 수정 사항
- 채팅: 브라우저에서 마우스가 채팅 영역에 들어오거나 나간 뒤에도 세션 창의 텍스트 선택과 복사가 계속 작동합니다.
- 사용 한도: 추가 Claude 계정이 사용하지 않는 동안 액세스 토큰이 만료되어도 더 이상 로그아웃된 것으로 표시되지 않습니다. 토큰이 자동으로 갱신됩니다.
<!-- lang:ru -->
### Исправления
- Чат: выделение и копирование текста в панели сессии больше не перестают работать в браузере после того, как курсор входит в чат или покидает его.
- Лимиты: дополнительные аккаунты Claude больше не выглядят вышедшими из системы, когда их токен доступа истекает во время простоя, — теперь он обновляется автоматически.
<!-- lang:tr -->
### Düzeltmeler
- Sohbet: Fare sohbete girip çıktıktan sonra tarayıcıda oturum panelindeki metin seçme ve kopyalama artık çalışmaya devam ediyor.
- Limitler: Ek Claude hesapları, boşta kalırken erişim belirteci süresi dolduğunda artık oturumu kapanmış görünmüyor; belirteç otomatik olarak yenileniyor.
<!-- lang:zh-CN -->
### 修复
- 聊天：在浏览器中鼠标移入或移出聊天区域后，会话面板中的文本选择和复制不再失效。
- 用量限制：额外的 Claude 账号在闲置期间访问令牌过期后不再显示为已退出登录，令牌现在会自动刷新。
<!-- lang:zh-TW -->
### 修正
- 聊天：在瀏覽器中滑鼠移入或移出聊天區域後，工作階段面板中的文字選取與複製不再失效。
- 用量限制：額外的 Claude 帳號在閒置期間存取權杖過期後不再顯示為已登出，權杖現在會自動更新。
