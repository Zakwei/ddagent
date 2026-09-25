<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Tüm AI kodlama ajanlarınız için tek bir arayüz.</strong><br>
  Claude Code, Codex, Cursor CLI, OpenCode ve Devin için self-hosted web ve mobil arayüz — oturumlar, dosyalar, git, terminaller ve görevler tek bir yerde.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="sürüm">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="lisans: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
  </p>

  <p>
    <a href="#kurulum">Kurulum</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Katkıda Bulunma</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Hata Bildirimleri</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <a href="README.fr.md">Français</a> ·
    <a href="README.it.md">Italiano</a> ·
    <a href="README.ja.md">日本語</a> ·
    <a href="README.ko.md">한국어</a> ·
    <a href="README.ru.md">Русский</a> ·
    <strong>Türkçe</strong> ·
    <a href="README.zh-CN.md">简体中文</a> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent sohbet görünümü" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent mobil görünümü" width="20%">
</p>

---

## ddagent nedir?

ddagent kendi makinenizde veya VPS'inizde çalışır ve halihazırda kullandığınız kodlama ajanlarının üzerine cilalanmış bir web arayüzü sunar. Oturumlarını doğrudan diskten keşfeder — `~/.claude`, Codex ve Devin geçmişiniz anında görünür; hiçbir şey kopyalanmaz veya üçüncü taraflarla senkronize edilmez.

Ağınızdaki herhangi bir tarayıcıdan veya telefonunuzdan açın. Sizin makineniz, sizin ajanlarınız, sizin verileriniz.

## Özellikler

- **Çoklu ajan oturumları** — Claude Code, Codex, Cursor CLI, OpenCode ve Devin oturumlarını yan yana çalıştırın ve sürdürün, WebSocket üzerinden canlı akışla
- **Bölünmüş paneller** — tek çalışma alanında sohbet, terminal, tarayıcı ve dosya panelleri
- **Dosya gezgini ve editör** — çalışma alanına göz atın, CodeMirror ile kod düzenleyin
- **Git paneli** — arayüzden ayrılmadan stage, commit, diff yapın ve dal değiştirin
- **Entegre kabuk** — çalışma alanı başına tam terminal, artı bağımsız bir kabuk sekmesi
- **Görev panosu** — TaskMaster destekli kanban görünümü; PRD'leri çalıştırılabilir görevlere dönüştürün
- **MCP yönetimi** — ajanlar arasında MCP sunucuları ekleyin, düzenleyin ve senkronize edin
- **Yetenek tarayıcısı** — ajan yeteneklerini arayüzden yönetin
- **Kota ve kullanım** — ajan başına token kullanımı ve abonelik limitleri, bir bakışta
- **Browser-use** — araştırma ve test için ajan kontrollü tarayıcı oturumları
- **Worktree'ler** — görev başına izole git worktree'leri oluşturun; worktree başına kurulum/çalıştırma betikleri ve kimlik doğrulamalı canlı geliştirme sunucusu önizlemesi ile
- **Uzak onaylar** — Telegram, Discord veya mobil uygulamadan araç izinlerini onaylayın
- **Sesli giriş** — Whisper uyumlu bir STT uç noktası ile prompt dikte edin
- **Ajan yayını ve paylaşılan bellek** — tüm ajanlara aynı anda mesaj gönderin ve hepsinin okuduğu proje bazlı notlar tutun
- **Çoklu hesap geçişi** — sağlayıcı başına adlandırılmış hesaplar ve oturum bazlı env geçersiz kılmaları
- **Zamanlayıcı** — cron tabanlı ajan çalıştırmaları, web/masaüstünde keep-awake ile
- **Takım işbirliği** — roller (owner/member/viewer), davet bağlantıları, atananlar, yorumlar, presence ve panoda bir aktivite akışı ([dokümanlar](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP sunucusu** — harici MCP istemcilerinin (Claude Desktop, OpenClaw) görev oluşturmasına ve oturumlara mesaj göndermesine izin verin ([dokümanlar](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Bildirimler ve TTS** — bir oturum size ihtiyaç duyduğunda ping alın (veya sesli okutun)
- **Docker sandbox'ları** — ajanları microVM izoleli ortamlarda çalıştırın ([dokümanlar](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Masaüstü yardımcısı** — isteğe bağlı Electron uygulaması; **12 dil**, koyu ve açık temalar

## Desteklenen ajanlar

| Ajan | Nasıl bağlanır |
|---|---|
| **Claude Code** | `~/.claude` oturumlarını otomatik keşfeder; MCP ve ayarları yerel CLI ile senkronize eder |
| **Codex** | Yerel CLI oturumları ve transkriptler |
| **Cursor CLI** | Yerel CLI oturumları |
| **OpenCode** | Yerel oturumlar ve yetenek konumları |
| **Devin** | Yerel senkronizasyon yoluyla CLI/ACP oturumları |

Kendi aboneliklerinizi getirirsiniz — ddagent ortamı sağlar, AI'ı değil.

## Kurulum

Sunucuyu çalıştıran makinede **Node.js 22+** gerekir. Sunucu, web arayüzünü ve masaüstü ile mobil uygulamaların uzaktan bağlandığı REST/WS API'sini sunar.

### Self-hosted sunucu — kurulum betiği

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

En son sürüm etiketini `~/.ddagent/app` içine klonlar, web arayüzünü ve backend'i derler ve bir `start.sh` başlatıcısı bırakır. Seçenekler: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (kullanıcı systemd birimini kurar ve etkinleştirir). `--version` ile yeniden çalıştırarak yerinde güncelleyin.

Ardından:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Self-hosted sunucu — hazır tarball

Derleme adımı yok — [Releases](https://github.com/Zakwei/ddagent/releases) sayfasından `ddagent-server-<version>-<os>-<arch>.tar.gz` dosyasını indirin, açın ve çalıştırın:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### Masaüstü uygulaması

[Releases](https://github.com/Zakwei/ddagent/releases) sayfasından işletim sisteminize uygun yükleyiciyi indirin: `.dmg` (macOS) · `.exe` (Windows) · `.AppImage` / `.deb` (Linux).

Bağımsız çalışır — sunucu gömülüdür, başka bir şey kurmaya gerek yok — veya self-hosted bir sunucu URL'sine karşı uzak modda çalışır. Sürümdeki `latest*.yml` beslemeleriyle otomatik güncellenir.

### Mobil uygulama (önizleme)

[Releases](https://github.com/Zakwei/ddagent/releases) sayfasından `ddagent-mobile-<version>.apk` dosyasını indirin ve Android cihazınıza kurun; uygulama self-hosted bir sunucu URL'sine bağlanır.

### Kaynaktan

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker sandbox (deneysel)

```bash
ddagent sandbox ~/my-project
```

Ajanı hipervizör izoleli bir sandbox'ta çalıştırır. Bkz. [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

Kaynak veya `install.sh` kurulumunda, aşağıdaki `ddagent` `node dist-server/server/modules/cli/cli.js` anlamına gelir (shebang'i vardır, yani `./dist-server/server/modules/cli/cli.js` da çalışır).

| Komut | Açıklama |
|---|---|
| `ddagent` | Sunucuyu başlat |
| `ddagent start` | Sunucuyu başlat |
| `ddagent status` | Yapılandırma ve veri konumlarını göster |
| `ddagent version` | Sürümü yazdır |
| `ddagent help` | Yardımı göster |

## Yapılandırma

Tüm ayarlar tek bir env dosyasında bulunur — sizinkinin nereden okunduğunu görmek için `ddagent status` çalıştırın.

| Değişken | Varsayılan | Açıklama |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket portu |
| `VITE_PORT` | `5173` | Geliştirme sunucusu portu |
| `HOST` | `0.0.0.0` | Bağlanma adresi (yalnızca localhost için `127.0.0.1`) |
| `DATABASE_PATH` | auto | Kimlik doğrulama veritabanı konumu |
| `CONTEXT_WINDOW` | `160000` | Oturum başına maksimum token |
| `CLAUDE_CLI_PATH` | `claude` | Özel Claude CLI ikili dosya yolu |

Tam liste için bkz. [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Geliştirme

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

Backend kodu `server/modules/` içinde açıklanan modül mimarisini izler — sağlayıcı iç işleyişi için bkz. [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md).

## Katkıda Bulunma

Hata düzeltmeleri memnuniyetle karşılanır — bkz. [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Claude Code, Cursor, Codex, OpenCode ve Devin topluluğu için geliştirildi.</sub>
</div>
