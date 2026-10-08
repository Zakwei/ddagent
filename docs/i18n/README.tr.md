<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Tüm AI kodlama ajanlarınız için tek bir arayüz.</strong><br>
  Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code ve Antigravity için self-hosted sunucu ve Flutter istemcisi (web, Linux, Windows ve Android) — oturumlar, dosyalar, git, terminaller ve görevler tek bir yerde.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=sürüm&amp;color=0066FF" alt="sürüm">
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

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Claude Code ve Codex'in son oturumları"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Ajan çalıştırmalarını yöneten Kanban panosu"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Parça bazında stage desteği sunan Git paneli"></td>
  </tr>
  <tr>
    <td align="center"><sub>Tüm ajanların oturumları tek listede</sub></td>
    <td align="center"><sub>Kanban panosu — kartlar ajan çalıştırmalarını başlatır</sub></td>
    <td align="center"><sub>Git paneli — diff, parçaları stage etme, commit</sub></td>
  </tr>
</table>

---

## ddagent nedir?

ddagent kendi makinenizde veya VPS'inizde çalışır ve hâlihazırda kullandığınız kodlama ajanlarını tek, özenle tasarlanmış bir arayüzde bir araya getirir. Sunucu, her ajanın oturumlarını doğrudan o ajanın diskteki kendi geçmişinden (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …) okur; böylece mevcut konuşmalarınız hiçbir şey içe aktarmadan görünür. Yerel olarak yalnızca oturum meta verileri dizinlenir; hiçbir veri üçüncü taraflara gönderilmez.

Masaüstünüzden, telefonunuzdan veya tarayıcınızdan Flutter istemcisiyle bağlanın. Makine sizin, ajanlar sizin, veriler sizin.

## Özellikler

- **Çoklu ajan oturumları** — yedi ajan CLI'ının oturumlarını yan yana çalıştırın ve sürdürün; WebSocket üzerinden canlı akış
- **Otomatik orkestratör** — "Auto" oturumları, kalan abonelik kotasını da hesaba katarak her görevi uygun bir ajana ve modele yönlendirir ve işi alt oturumlara devreder
- **Bölünmüş çalışma alanı** — tek pencerede altı panele kadar (sohbet, terminal, tarayıcı, önizleme, düzenleyici, git, notlar)
- **Dosya gezgini ve düzenleyici** — çalışma alanında gezinin ve kodu yerleşik düzenleyicide düzenleyin
- **Git paneli** — arayüzden çıkmadan dosyaları veya tek tek parçaları stage edin, commit atın (AI ile oluşturulan mesajlarla), diff görüntüleyin, dal değiştirin, pull/push yapın ve kontrol noktalarını geri yükleyin
- **Entegre terminal** — her çalışma alanı için tam bir kabuk
- **Kanban panosu** — bir kartı taşıyarak onun üzerinde bir ajan çalıştırması başlatın (isteğe bağlı olarak kendi worktree'sinde); ajan işi bitince geri bildirim verir
- **TaskMaster** — PRD'leri görevlere dönüştürün ve bir görev panosunda takip edin
- **Mesaj kuyruğu** — ajan meşgulken gönderilen mesajlar sunucuda kuyruğa alınır; sayfa yenilemelerinden ve cihaz değişikliklerinden etkilenmez
- **MCP yönetimi** — MCP sunucularını ajanlar arasında ekleyin, düzenleyin ve senkronize edin
- **Bilgi tabanı** — tüm ajanlar için tek, yerel ve aranabilir bir hafıza: kurallar, beceriler, anılar ve kişisel bilgiler, MCP üzerinden ihtiyaç anında getirilir ([belgeler](KNOWLEDGE.tr.md))
- **Beceriler ve kurallar** — ajan becerilerini ve ortak kuralları tek bir yerden yönetin
- **Kota ve kullanım** — ajan başına token kullanımı ve abonelik limitleri bir bakışta
- **Browser-use** — araştırma ve test için ajan tarafından yönetilen tarayıcı oturumları, canlı tarayıcı paneliyle birlikte
- **Worktree'ler** — her görev için yalıtılmış git worktree'leri oluşturun; worktree başına kurulum/çalıştırma betikleri ve kimlik doğrulamalı canlı dev-server önizlemesiyle
- **Uzaktan onay** — araç izinlerini Telegram, Discord veya Android uygulamasından onaylayın ([belgeler](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Sesli giriş** — istemlerinizi Whisper uyumlu bir konuşmadan metne uç noktası aracılığıyla dikte edin
- **Ajanlara toplu mesaj ve ortak hafıza** — tüm ajanlara aynı anda mesaj gönderin ve hepsinin okuduğu proje notları tutun
- **Çoklu hesap geçişi** — sağlayıcı başına adlandırılmış hesaplar ve oturum bazında ortam değişkeni geçersiz kılma
- **Zamanlayıcı** — cron ile tetiklenen, gözetimsiz ajan çalıştırmaları; çalıştırmalar sürerken cihazı uyanık tutma seçeneğiyle
- **Ekip çalışması** — roller (owner/member/viewer), davet bağlantıları, atananlar, yorumlar, çevrimiçi durumu ve panoda etkinlik akışı ([belgeler](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP sunucusu** — harici MCP istemcilerinin (Claude Desktop, OpenClaw) oturumları listelemesine, görev oluşturmasına ve oturumlara mesaj göndermesine olanak tanır ([belgeler](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Bildirimler ve TTS** — bir oturum size ihtiyaç duyduğunda push, Telegram ve Discord bildirimleri; ayrıca isteğe bağlı sesli yanıt okuma
- **Komut paleti** — oturumlarda ve mesajlarda arama yapmak, herhangi bir sayfaya geçmek veya hızlı eylemler çalıştırmak için `Ctrl/Cmd+Shift+K`
- **Docker sandbox'ları** — ajanları microVM ile yalıtılmış Docker Sandboxes içinde çalıştırın ([belgeler](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Flutter istemcisi** — web, Linux, Windows ve Android için tek kod tabanı; **12 dil**, koyu ve açık tema

## Desteklenen ajanlar

| Ajan | Bağlantı şekli |
|---|---|
| **Claude Code** | Claude Agent SDK; `~/.claude` oturumlarını otomatik bulur; MCP ve ayarlar yerel CLI ile senkronize edilir |
| **Codex** | Codex SDK; `~/.codex` içindeki yerel oturumlar ve dökümler |
| **Cursor CLI** | Akışlı JSON çıktısıyla `cursor-agent`; `~/.cursor` içindeki yerel sohbetler |
| **OpenCode** | `opencode serve`; OpenCode veritabanındaki yerel oturumlar |
| **Devin** | `devin acp` (Agent Client Protocol); yerel dökümler |
| **Command Code** | `command-code acp` (Agent Client Protocol); `~/.commandcode` içindeki dökümler |
| **Antigravity** | Headless modda `agy` CLI; konuşmalar `~/.gemini/antigravity-cli` dizininden dizinlenir |

Ajan CLI'larının sunucu makinesinde kurulu ve oturum açılmış olması gerekir. Abonelikler size aittir — ddagent yapay zekâyı değil, ortamı sağlar.

## Kurulum

ddagent iki bölümden oluşur: ajanlarınızla aynı makinede çalışan ve bir REST/WebSocket API'si sunan **sunucu** ve ona bağlanan **istemci**. Sunucu **Node.js 22+** gerektirir (hazır tarball'lar ise Node.js 22.x gerektirir, çünkü içlerindeki yerel modüller bu sürüme göre derlenmiştir).

### Sunucu — kurulum betiği

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

`git`, Node.js 22+ ve `npm` gerektirir. Betik bir sürüm etiketini `~/.ddagent/app` dizinine klonlar, bağımlılıkları kurar, backend'i derler ve bir `start.sh` başlatıcısı oluşturur. Seçenekleri `bash -s --` sonrasında verin:

| Seçenek | Açıklama |
|---|---|
| `--version vX.Y.Z` | Belirli bir sürümü kur (varsayılan: en son sürüm) |
| `--dir <path>` | Kurulum dizini (varsayılan: `~/.ddagent/app`) |
| `--systemd` | `ddagent` adlı bir systemd kullanıcı servisi kur ve etkinleştir |
| `--port <port>` | systemd servisinin portu (varsayılan: `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Ardından sunucuyu başlatın:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Sunucu — hazır tarball

Derleme gerekmez: [Releases](https://github.com/Zakwei/ddagent/releases) sayfasından `ddagent-server-<version>-<os>-<arch>.tar.gz` dosyasını (`linux-x64`, `mac-arm64` veya `win-x64`) indirin, arşivi açın ve başlatıcıyı çalıştırın:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

Her tarball bir `.sha256` sağlama toplamıyla birlikte gelir. Ayarlar, `start.sh` dosyasının yanındaki isteğe bağlı bir `.env` dosyasına yazılır.

### İstemci

[Releases](https://github.com/Zakwei/ddagent/releases) sayfasından hazır bir istemci indirin:

| Platform | Dosya |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (yükleyici) veya `.zip` (taşınabilir) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` veya `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

İlk açılışta sunucu URL'nizi girin (örneğin `http://my-vps:3001`) ve ilk hesabı oluşturun. Windows ve Linux x64'te masaüstü istemcisi sizin için yerel bir sunucuyu indirip çalıştırabilir de (bağlantı ekranındaki "Bu cihaz" seçeneği).

Web derlemesinde giriş ekranı yoktur ve API'yi kendi origin'i üzerinden çağırır; bu nedenle tek kullanıcılı platform modunda (`VITE_IS_PLATFORM=true`, kimlik doğrulamayı devre dışı bırakır) çalışan bir sunucunun önündeki bir ters proxy arkasından sunulmalıdır. Kaynak kod kopyasında `node scripts/serve-flutter-web.cjs`, `flutter/build/web` dizinini 8085 portunda sunar ve API ile WebSocket bağlantılarını `FLUTTER_BACKEND_PORT` (varsayılan `10087`) portundaki sunucuya yönlendirir. Bu kurulumu yalnızca güvenilir bir ağda erişime açın.

İstemciyi kendiniz derlemek için:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Güncelleme

İstemcideki **Ayarlar → Hakkında → Güncellemeler** bölümünde her parça için ayrı bir düğme bulunur:

| Parça | Nasıl güncellenir |
|---|---|
| **Sunucu** | Kurulum betiği ve git ile yapılan kurulumlar en yeni sürüme geçer; sürüm tarball'larıyla yapılan kurulumlar bir sonraki tarball'u indirir, doğrular (`.sha256`) ve yeniden başlatmada kurar; sunucu başlamazsa değişikliği otomatik olarak geri alır. `start.sh` / `start.bat` sunucuyu kendiliğinden yeniden başlatır — systemd gerekmez. Masaüstü istemcisinin yerel sunucusu ("Bu cihaz") uygulama tarafından yeniden kurulur. |
| **Web arayüzü** | Sunucu tarafından barındırılıyorsa (`DDAGENT_WEB_DIR` veya `scripts/serve-flutter-web.cjs` ile sunulan `flutter/build/web`) sürümün web zip dosyasıyla değiştirilir; ayrıca her sunucu güncellemesinde yenilenir. |
| **Bu uygulama** | Android yeni APK'yı kurar; Windows ve Linux yeni derlemeyi arka planda indirir ve uygulamadan çıktığınızda kurar. |

Sürüm tarball'ları Node.js 22 için derlenir — sunucu, farklı bir Node.js ana sürümü için derlenmiş tarball'u reddeder. 0.8.12 veya daha eski sürümlerdeki sunucular (kurulum betiği veya tarball) 0.8.13'e bir kez elle güncellenir — `install.sh --version v0.8.13` komutunu yeniden çalıştırın ya da yeni tarball'u eskisinin üzerine açın — sonrasında güncellemeler arayüzden yapılır.

### Kaynaktan

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker sandbox (deneysel)

```bash
ddagent sandbox ~/my-project
```

ddagent'ı ve bir ajanı (Claude Code veya Codex) microVM ile yalıtılmış bir Docker Sandbox içinde çalıştırır. `sbx` CLI gerektirir — bkz. [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

Kaynak kod veya `install.sh` kopyasında, aşağıdaki `ddagent` ifadesi `node dist-server/server/modules/cli/cli.js` anlamına gelir (dosyada shebang bulunduğundan `./dist-server/server/modules/cli/cli.js` da çalışır).

| Komut | Açıklama |
|---|---|
| `ddagent` / `ddagent start` | Sunucuyu başlat (varsayılan komut) |
| `ddagent status` | Sürümü ve yapılandırma dosyası, veritabanı ile Claude projelerinin konumlarını göster |
| `ddagent sandbox <workspace>` | Bir Docker sandbox oluştur ve başlat; `ddagent sandbox help` şu alt komutları listeler: `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | browser-use MCP sunucusunu stdio üzerinden çalıştır |
| `ddagent version` | Sürümü yazdır |
| `ddagent help` | Yardımı göster |

| Seçenek | Açıklama |
|---|---|
| `-p, --port <port>` | Sunucu portu (`SERVER_PORT` değerini geçersiz kılar) |
| `--database-path <path>` | Özel veritabanı konumu (`DATABASE_PATH` değerini geçersiz kılar) |

## Yapılandırma

Sunucu, kurulum dizinindeki (`start.sh` dosyasının yanındaki) isteğe bağlı `.env` dosyasını okur; gerçek ortam değişkenleri önceliklidir. Hangi dosyanın kullanıldığını görmek için `ddagent status` komutunu çalıştırın.

| Değişken | Varsayılan | Açıklama |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket portu (`PORT` eski bir takma ad olarak kabul edilir) |
| `HOST` | `0.0.0.0` | Bağlanılacak adres (yalnızca localhost için `127.0.0.1`) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite veritabanı (kullanıcılar, ayarlar, token'lar) |
| `WORKSPACES_ROOT` | ev dizini | Projeler bu dizinin içinde bulunmalıdır |
| `JWT_SECRET` | otomatik oluşturulur | Giriş token'larını imzalamak için kullanılan gizli anahtar (her kurulum için oluşturulup saklanır) |
| `API_KEY` | tanımsız | Tanımlanırsa API istekleri bu anahtarı `x-api-key` başlığında göndermelidir |
| `CLAUDE_CLI_PATH` | `claude` | Özel Claude Code CLI ikili dosyası |
| `CONTEXT_WINDOW` | `200000` | Claude bağlam penceresi için yedek değer; SDK modelin gerçek pencere boyutunu bildirene kadar kullanılır |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / tanımsız / `whisper-1` | Sesli giriş için konuşmadan metne dönüştürme (Ayarlar'dan da yapılandırılabilir) |
| `VITE_IS_PLATFORM` | `false` | Tek kullanıcılı platform modu: kimlik doğrulamayı atlar (web istemcisi için gereklidir) |

Daha fazlası için [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) dosyasına bakın.

## Geliştirme

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

İstemci (Flutter 3.47.5 stable):

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

Backend kodu `server/modules/` altındaki modül mimarisini izler; sağlayıcıların iç yapısı için bkz. [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md).

## Katkıda Bulunma

Hata düzeltmelerine her zaman açığız — bkz. [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Bir güvenlik açığı bildirmek için bkz. [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Claude Code, Codex, Cursor, OpenCode, Devin, Command Code ve Antigravity topluluğu için geliştirildi.</sub>
</div>
