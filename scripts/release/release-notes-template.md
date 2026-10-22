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
- **Images from the phone gallery in the terminal**: the key bar and the ⌄ → Edit menu have an “Attach images” button. Pick one or more screenshots — they are uploaded and their paths are pasted into the shell, so Claude Code and other CLIs can read them. Pasted images are now saved as `.png` to match their content.
<!-- lang:pl -->
### Nowości
- **Obrazy z galerii telefonu w terminalu**: pasek klawiszy i menu ⌄ → Edycja mają przycisk „Załącz obrazy”. Wybierz jeden lub kilka zrzutów — zostaną wysłane, a ich ścieżki wklejone do powłoki, więc Claude Code i inne CLI mogą je odczytać. Wklejane obrazy są teraz zapisywane jako `.png`, zgodnie z zawartością.
<!-- lang:de -->
### Neu
- **Bilder aus der Handy-Galerie im Terminal**: Die Tastenleiste und das Menü ⌄ → Bearbeiten haben eine Schaltfläche „Bilder anhängen“. Wähle einen oder mehrere Screenshots — sie werden hochgeladen und ihre Pfade in die Shell eingefügt, sodass Claude Code und andere CLIs sie lesen können. Eingefügte Bilder werden jetzt passend zum Inhalt als `.png` gespeichert.
<!-- lang:es -->
### Novedades
- **Imágenes de la galería del teléfono en el terminal**: la barra de teclas y el menú ⌄ → Editar tienen un botón «Adjuntar imágenes». Elige una o varias capturas: se suben y sus rutas se pegan en la shell, para que Claude Code y otras CLI puedan leerlas. Las imágenes pegadas ahora se guardan como `.png`, acorde a su contenido.
<!-- lang:fr -->
### Nouveautés
- **Images de la galerie du téléphone dans le terminal** : la barre de touches et le menu ⌄ → Édition ont un bouton « Joindre des images ». Choisissez une ou plusieurs captures : elles sont envoyées et leurs chemins collés dans le shell, pour que Claude Code et les autres CLI puissent les lire. Les images collées sont désormais enregistrées en `.png`, conformément à leur contenu.
<!-- lang:it -->
### Novità
- **Immagini dalla galleria del telefono nel terminale**: la barra dei tasti e il menu ⌄ → Modifica hanno un pulsante «Allega immagini». Scegli uno o più screenshot: vengono caricati e i loro percorsi incollati nella shell, così Claude Code e le altre CLI possono leggerli. Le immagini incollate ora vengono salvate come `.png`, coerentemente con il contenuto.
<!-- lang:ja -->
### 新機能
- **ターミナルでスマホのギャラリー画像を使用**：キーバーと ⌄ → 編集 メニューに「画像を添付」ボタンを追加しました。スクリーンショットを1枚以上選ぶとアップロードされ、そのパスがシェルに貼り付けられるため、Claude Code などの CLI が読み取れます。貼り付けた画像は内容に合わせて `.png` として保存されるようになりました。
<!-- lang:ko -->
### 새 기능
- **터미널에서 휴대폰 갤러리 이미지 사용**: 키 바와 ⌄ → 편집 메뉴에 「이미지 첨부」 버튼이 생겼습니다. 스크린샷을 하나 이상 고르면 업로드되고 경로가 셸에 붙여넣어져 Claude Code 등 CLI가 읽을 수 있습니다. 붙여넣은 이미지는 이제 내용에 맞게 `.png`로 저장됩니다.
<!-- lang:ru -->
### Новое
- **Изображения из галереи телефона в терминале**: на панели клавиш и в меню ⌄ → Правка появилась кнопка «Прикрепить изображения». Выберите один или несколько скриншотов — они загрузятся, а их пути вставятся в оболочку, чтобы Claude Code и другие CLI могли их прочитать. Вставленные изображения теперь сохраняются как `.png`, в соответствии с содержимым.
<!-- lang:tr -->
### Yenilikler
- **Terminalde telefon galerisinden görseller**: tuş çubuğunda ve ⌄ → Düzenle menüsünde «Resim ekle» düğmesi var. Bir veya birkaç ekran görüntüsü seçin — yüklenir ve yolları kabuğa yapıştırılır, böylece Claude Code ve diğer CLI'lar onları okuyabilir. Yapıştırılan görseller artık içeriklerine uygun olarak `.png` olarak kaydediliyor.
<!-- lang:zh-CN -->
### 新功能
- **在终端中使用手机相册图片**：按键栏和 ⌄ → 编辑 菜单新增「附加图片」按钮。选择一张或多张截图后会上传，并把路径粘贴到 shell 中，Claude Code 等 CLI 即可读取。粘贴的图片现在按其内容保存为 `.png`。
<!-- lang:zh-TW -->
### 新功能
- **在終端機中使用手機相簿圖片**：按鍵列和 ⌄ → 編輯 選單新增「附加圖片」按鈕。選擇一張或多張截圖後會上傳，並將路徑貼到 shell 中，Claude Code 等 CLI 即可讀取。貼上的圖片現在依其內容儲存為 `.png`。
