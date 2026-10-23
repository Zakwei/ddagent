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
- **Scrolling Claude Code in a restored terminal**: a swipe scrolls the conversation whenever the program reports the mouse wheel, as in xterm. A Claude Code session restored after a server restart could not be scrolled up at all.
<!-- lang:pl -->
### Poprawki
- **Przewijanie Claude Code w przywróconym terminalu**: przesunięcie palcem przewija rozmowę zawsze, gdy program obsługuje kółko myszy, tak jak w xterm. Sesji Claude Code przywróconej po restarcie serwera nie dało się w ogóle przewinąć w górę.
<!-- lang:de -->
### Fehlerbehebungen
- **Scrollen in Claude Code in einem wiederhergestellten Terminal**: Eine Wischgeste scrollt die Unterhaltung, sobald das Programm das Mausrad meldet, wie in xterm. Eine nach einem Server-Neustart wiederhergestellte Claude-Code-Sitzung ließ sich gar nicht nach oben scrollen.
<!-- lang:es -->
### Correcciones
- **Desplazamiento en Claude Code en un terminal restaurado**: deslizar desplaza la conversación siempre que el programa informe de la rueda del ratón, como en xterm. Una sesión de Claude Code restaurada tras reiniciar el servidor no se podía desplazar hacia arriba.
<!-- lang:fr -->
### Corrections
- **Défilement de Claude Code dans un terminal restauré** : un balayage fait défiler la conversation dès que le programme signale la molette, comme dans xterm. Une session Claude Code restaurée après un redémarrage du serveur ne défilait pas du tout vers le haut.
<!-- lang:it -->
### Correzioni
- **Scorrimento di Claude Code in un terminale ripristinato**: uno swipe fa scorrere la conversazione ogni volta che il programma segnala la rotellina, come in xterm. Una sessione di Claude Code ripristinata dopo un riavvio del server non scorreva affatto verso l'alto.
<!-- lang:ja -->
### 修正
- **復元したターミナルでの Claude Code のスクロール**：プログラムがマウスホイールを報告していれば、xterm と同様にスワイプで会話がスクロールします。サーバー再起動後に復元した Claude Code セッションは上にスクロールできませんでした。
<!-- lang:ko -->
### 수정
- **복원된 터미널에서 Claude Code 스크롤**: 프로그램이 마우스 휠을 보고하면 xterm처럼 스와이프로 대화가 스크롤됩니다. 서버 재시작 후 복원된 Claude Code 세션은 위로 전혀 스크롤되지 않았습니다.
<!-- lang:ru -->
### Исправления
- **Прокрутка Claude Code в восстановленном терминале**: свайп прокручивает разговор, когда программа сообщает о колёсике мыши, как в xterm. Сеанс Claude Code, восстановленный после перезапуска сервера, вообще не прокручивался вверх.
<!-- lang:tr -->
### Düzeltmeler
- **Geri yüklenen terminalde Claude Code kaydırma**: program fare tekerleğini bildirdiğinde kaydırma hareketi, xterm'deki gibi konuşmayı kaydırıyor. Sunucu yeniden başlatıldıktan sonra geri yüklenen bir Claude Code oturumu yukarı hiç kaydırılamıyordu.
<!-- lang:zh-CN -->
### 修复
- **在恢复的终端中滚动 Claude Code**：只要程序报告鼠标滚轮，滑动就会像在 xterm 中一样滚动对话。服务器重启后恢复的 Claude Code 会话此前完全无法向上滚动。
<!-- lang:zh-TW -->
### 修正
- **在還原的終端機中捲動 Claude Code**：只要程式回報滑鼠滾輪，滑動就會像在 xterm 中一樣捲動對話。伺服器重新啟動後還原的 Claude Code 工作階段先前完全無法向上捲動。
