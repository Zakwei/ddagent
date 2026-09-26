# Değişiklik günlüğü

ddagent'e yapılan tüm önemli değişiklikler burada belgelenir.

Biçim [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) standardını izler
ve bu proje [Semantic Versioning](https://semver.org/) kurallarına uyar.

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <strong>Türkçe</strong> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.6.1] - 2026-09-26

### Hata düzeltmeleri

- Mobil: model seçici yeni sohbetlerde kullanılamıyordu, çok panelli workspace'e erişilemiyordu
- Mobil: split workspace panelleri artık gerçek sohbet görünümleri gösteriyor

## [0.6.0] - 2026-09-26

### Yenilikler

- **Auto orkestrasyon sağlayıcısı** — model yönlendirme, planlayıcı DAG ve delegasyon; sohbette yönlendirme/plan/delegasyon/özet kartları, ayrıca Ayarlar'da orkestrasyon sekmesi
- **Mobil: tam yerel uyumluluk** — artık her ekran yerel: Files (CRUD, arama, lightbox), Source Control (hunk evreleme, bölünmüş diff, commit grafiği, worktree'ler), Tasks (PRD düzenleyici, ayrıntı düzenleme), Agent Board, Quota & Usage, terminal, düzenleyici ve tüm Ayarlar sekmeleri
- **Mobil:** onboarding sihirbazı, proje oluşturma sihirbazı (klasör tarayıcı, GitHub klonlama, inceleme), genel aramalı komut paleti, bölünmüş çalışma alanı ızgarası, hızlı ayarlar paneli, browser-use canlı paneli
- **Mobil:** çevrimdışı mesaj kuyruğu, sohbet dışa aktarma (PDF/md/html/text), transkript arama, oturum karşılaştırma

### Hata düzeltmeleri

- OpenCode: akışlı metin anlık görüntülerinden yinelenen oturum satırları, question aracı istemlerinin görünmemesi
- Sabit Review/Search çubuğunun ilk mesajı kırpması

## [0.5.9] - 2026-09-25

İlk herkese açık açık kaynak sürüm — **AGPL-3.0-only**.

### Yenilikler

- **Ekip iş birliği** — paylaşılan oturumlar, toplu mesajlar, ajan gelen kutusu, proje bazında paylaşılan bellek
- **MCP sunucusu** — harici MCP istemcileri (Claude Desktop, OpenClaw) `POST /mcp` ile görev oluşturabilir ve oturumlara mesaj gönderebilir ([belgeler](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Uzak onaylar** — ajan eylemlerini Telegram veya Discord'dan onaylama ([belgeler](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Zamanlayıcı** — uyku engellemeli ajan çalıştırmaları için cron zamanlamaları
- **İsimlendirilmiş sağlayıcı hesapları** — oturum bazında env/kimlik bilgisi geçersiz kılmaları
- **Sesli giriş (STT)** — yazı alanında Whisper uyumlu uç nokta
- **Worktree'ler** — dev-server çalıştırıcılı depo bazında kurulum/çalıştırma betikleri
- **Önizleme** — WS tünelli kimliği doğrulanmış dev-server önizleme vekili
- **Mobil** — oturum arama, eyleme dönüştürülebilir onay bildirimleri (FCM)
- `SECURITY.md` — gizli güvenlik açığı bildirim politikası

### Hata düzeltmeleri

- Kota sekmesi veri ve görüntüleme hataları
- Sohbet: çevrimdışı kuyruk ve taslaklar yeniden yüklemelerde korunuyor; yeniden getirmelerde kararlı kaydırma konumu
- Oturumlar: silinen oturumlar artık diğer istemcilerde hayalet bırakmıyor
- Kanban: ajan panosundaki gönderim yarışları ve sızıntılar
- Mobil: klavye yüksekliği dolgusu, taşan uyarıların ActionSheet ile değiştirilmesi

## [0.5.8] - 2026-09-23

### Yenilikler

- `install.sh` — git tabanlı sunucu yükleyici (`--version`, `--dir`, `--port`, `--systemd`)
- `v*` etiketlerinde yayımlanan bağımsız ve yerel sunucu tarball'ları

### Hata düzeltmeleri

- Mobil klavyenin yazı alanını ve sistem gezinme çubuğunun altındaki içeriği kapatması (Android)

## [0.5.7] - 2026-09-23

### Hata düzeltmeleri

- Masaüstü CI derlemeleri (paket platform bayrağı, yerel yeniden derlemeler, duman testi zaman aşımları)
- Sohbet kayıtlarında yinelenen akışlı asistan mesajları

## [0.5.6] - 2026-09-23

### Hata düzeltmeleri

- Masaüstü CI: Apple sırları yokken imzasız macOS derlemeleri, Windows kapsamlı paket hazırlama

## [0.5.5] - 2026-09-23

### Yenilikler

- **Masaüstü uygulaması (önizleme)** — yerel veya uzak sunucular için Electron başlatıcı, gömülü arka uç, otomatik güncelleme, dmg/NSIS/AppImage/deb derlemeleri
- **Mobil uygulama (önizleme)** — Expo/React Native yardımcısı: oturumlar, model seçici ve eğik çizgi komutlarıyla sohbet, terminal, dosyalar, ayar WebView'leri
- Görülmemiş çıktısı olan oturumlarda okunmamış göstergesi; görev panosu ↔ oturum bağlantısı
- Sohbette KaTeX ve Mermaid adaları

### Hata düzeltmeleri

- Mobil görünüm alanlarında dokunma hedefleri ve düzenler; komut paleti, kanban ve ayarlar cilası

## [0.5.4] - 2026-09-21

### Yenilikler

- Tam ekran ilerleme katmanlı sunucu yeniden başlatma düğmesi (Ayarlar → Hakkında)
- Ayarlar → Hakkında'da yerelleştirilmiş GitHub sürümleri değişiklik günlüğü
- Tarayıcı sekmesi başlığında çalışan oturum sayısı
- Kullanım eğilimi grafiğinde Y ekseni ölçeği ve üzerine gelme ipuçları

### Hata düzeltmeleri

- Modal açılışında tetiklenen ayarlar otomatik kaydı; çok satırlı bölmelerde kompakt sohbet düzeni

## [0.5.3] - 2026-09-21

### Hata düzeltmeleri

- Rayın arkasında gizlenen güncelleme mevcut iletişim kutusu (portal düzeltmesi)

## [0.5.2] - 2026-09-21

### Hata düzeltmeleri

- Güncelleme denetimi sunucu üzerinden yönlendirildi

## [0.5.1] - 2026-09-21

### Yenilikler

- Tek tıkla kendi kendine güncelleme içeren güncelleme mevcut rozeti
- Oturum başına sesli okuma sesi; ses seçici Görünüm ayarlarına taşındı

### Hata düzeltmeleri

- Sohbet başlığı oturumun gerçek sağlayıcısını gösteriyor

## [0.5.0] - 2026-09-21

**ddagent**'in ilk bağımsız sürümü — AI kodlama ajanları için kendi barındırdığınız web ve mobil UI.

### Öne çıkanlar

- **Çok ajanlı oturumlar** — Claude Code, Codex, Cursor CLI, OpenCode ve Devin yan yana, canlı akış ve devam ettirme ile
- **Çalışma alanı düzeni** — sohbet, terminal, tarayıcı ve dosyalar için bölünmüş bölmeler
- **Dosya gezgini ve düzenleyici** — çalışma alanını UI içinde gezinme ve düzenleme
- **Git paneli** — aşamala, commit'le, diff, dal değiştir, worktree yönet
- **Görev panosu** — TaskMaster destekli kanban; PRD'lerden çalıştırılabilir görevler üretme
- **MCP yönetimi** — ajanlar arasında MCP sunucuları ekleme ve eşitleme
- **Yetenek tarayıcısı** — ajan yeteneklerini keşfetme ve yönetme
- **Kota ve kullanım** — ajan başına token kullanımı ve abonelik sınırları
- **Browser-use** — araştırma ve test için ajan güdümlü tarayıcı oturumları
- **Bildirimler ve TTS** — uyarılar ve sesli okunan yanıtlar
- **Docker sanal alanları** — deneysel hipervizör yalıtımlı ajan çalıştırmaları
- **Masaüstü yardımcısı** — macOS/Windows için isteğe bağlı Electron uygulaması
- **i18n** — 11 UI dili, koyu ve açık temalar

### CLI

- `ddagent` / `ddagent start` — sunucuyu başlat
- `ddagent status` — yapılandırma ve veri konumlarını göster
- `ddagent version` / `ddagent help`
