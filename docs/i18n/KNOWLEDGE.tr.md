# Bilgi tabanı

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <strong>Türkçe</strong> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent, ajanlarınız için **yerel öncelikli bir bilgi tabanı** sunar: anılar, kurallar,
beceriler ve kişisel bilgiler, artı etiketler ve ilişkiler. ddagent'ın geri kalanıyla
aynı SQLite veritabanında (`auth.db`) bir FTS5 tam metin indeksinin arkasında yaşar,
istemcideki **Knowledge** ekranından yönetilir ve ajanlarınız tarafından MCP üzerinden
okunup yazılabilir. Gevşek biçimde
[Contexta](https://github.com/XFABISIEK/Contexta)'dan esinlenmiştir.

Amaç basit: kurallarınız ve proje bilginiz artık araç başına dosyalara
(`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …) dağılmak yerine
her ajanın kullanabileceği tek, özenle seçilmiş, aranabilir bir yer hâline gelir —
dosyaları okuyanlar da MCP konuşanlar da.

## Bir ajan bunu gerçekte nasıl görür

Üç katman vardır ve hangisinin hangisi olduğunu bilmek yardımcı olur:

- **CLI'ye özgü dosyalar** — her araç kendi yapılandırmasını kendi okur: Claude Code
  `CLAUDE.md` okur, Codex/Cursor `AGENTS.md` okur, Cursor `.cursorrules` okur,
  birkaçı da `skills/` ve `.agents/skills/` okur. Bu CLI'ın işidir, modelin
  seçimi değil — ddagent bunu kapatmaz.
- **MCP ile alma (isteğe bağlı)** — ddagent'ın MCP sunucusunu bir ajana
  kurduğunuzda, araç listesi `knowledge_get_context`, `knowledge_search` ve
  benzerlerini içerir. Contexta'yı izleyerek, hiçbir şey otomatik olarak enjekte
  edilmez: ajan bağlam oluşturucuyu bir sorguyla çağırır ve `critical` kurallar ile
  eşleşen her şeyi geri alır. Model, araç açıklamaları ve bilgi tabanında tuttuğunuz
  talimat kuralları doğrultusunda ne zaman çağıracağına karar verir.

Yani "tek yer", **bilgiyi düzenlemek için tek yer** anlamına gelir
— bir CLI'ın kendi yerel dosyalarını okumasını durdurmaz (durdurması da mümkün değildir).
ddagent bilgi tabanını oturumlara otomatik olarak enjekte etmez.

## Varlıklar

| Varlık | Kapsam | Notlar |
|---|---|---|
| Anı | proje veya genel | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, etiketler |
| Kural | proje veya genel | `enabled` anahtarı; `critical` kurallar bağlam oluşturucu tarafından her zaman önce döndürülür |
| Beceri | genel | benzersiz ad, kategori, isteğe bağlı simge (base64 data URL) |
| Kişisel bilgi | genel | benzersiz `key` |
| Etiket / Bağlantı | — | anılardaki etiketler; bağlantılar herhangi iki varlığı birleştirir |
| Geçmiş | — | her yazma varlığın anlık görüntüsünü alır, böylece incelenip geri yüklenebilir |

Öncelikler: `critical > high > normal > low`. Bir varlık tek bir
projeye kapsanabilir veya genel olabilir (her yerde geçerlidir). `project_id` düz bir sütundur (yabancı
anahtar değil), çünkü projeler tablosu geçişler sırasında yeniden oluşturulur.

## Bağlamı alma (isteğe bağlı)

Ajanlar bağlamı MCP aracı `knowledge_get_context` üzerinden alır (Contexta'nın
ContextBuilder'ının birebir portu). Bir proje ve sorgu verildiğinde sırayla
şunları döndürür:

- **etkin tüm kurallar** (proje + genel), `critical` önce (üst sınır 20),
- sorguya göre sıralanmış **anılar** (FTS), ayrıca bağlantılar üzerinden ulaşılan
  1 atlamalı komşuları (üst sınır 5); sorgu yoksa, projenin önceliğe göre en iyi anıları,
- sorguya göre sıralanmış **beceriler**; sorgu yoksa, en yeni beceriler,
- yalnızca sorgu eşleştiğinde **kişisel bilgiler** (üst sınır 3),

her bölüm için öğeleri kısaltılan (800/1000/600 karakter) ve `maxTokens` ile
sınırlanan (varsayılan ~4000) bir Markdown bloğu olarak oluşturulur; artık sığmayan
öğeler atlanmış olarak sayılır.

Panel, seçilen proje için bir **kural bağlamı ölçeri** (`~X / 4000 tok`) gösterir —
her `knowledge_get_context` çağrısının her zaman içerdiği kural bloğunun boyutu.
Oturumlara otomatik olarak hiçbir şey enjekte edilmez.

Arama sıralaması, Contexta'nın `search.rs` dosyasındaki gibi hibrittir: FTS5
**prefix** eşleşmesi (`auth` aynı zamanda `authentication` ile eşleşir) artı yazım
hatalarını ve yarı eşanlamlıları yakalayan bulanık bir **trigram** geçişi, ardından
`bm25 + priority + recency` ile yeniden sıralama.

## MCP araçları (isteğe bağlı)

ddagent'ın MCP sunucusu (`POST /mcp`) bilgi tabanını her MCP istemcisine açar.
Okuma araçları `read` kapsamlı bir token ile çalışır; yazma araçları `write` gerektirir. Yazma
araçları, arayüzle aynı doğrulamayı çalıştırır ve geçmiş kaydeder.

Okuma: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Yazma: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, ve `rule`, `skill` ile `personal` için aynı üçlü;
artı `knowledge_link` / `knowledge_unlink`.

Araçlar `projectId` ya da ddagent'ın zaten bildiği bir `projectPath` kabul eder.

### Sunucuyu ajanlarınıza kurma

Sağlayıcı yapılandırmalarını elle düzenlemek zorunda değilsiniz. **Settings → MCP →
Install ddagent MCP server** kullanın (onboarding'de bir adım olarak da sunulur) ve
ajanları seçin — ya da hepsine kurun. Yeniden kullanılabilir bir `ddagent-mcp` bearer
token'ı ile `<server>/mcp` adresini işaret eden bir `ddagent` HTTP MCP girdisi (kullanıcı
kapsamı) yazar (yeniden kurmak öncekini iptal eder). Kurulduktan sonra, o ajanın araçları
`create_task`, `send_message` vb. yanında `knowledge_*` grubunu içerir.

Bir ajan MCP'yi *ne zaman* kullanacağını nasıl bilir? Tahmin etmez — ona söyleyin.
Şöyle bir `critical` kural tutun: *"Bu proje hakkındaki soruları yanıtlamadan önce
`knowledge_get_context` çağır; bir karara vardığında onu `knowledge_add_memory` ile
kalıcılaştır."* `critical` kurallar bağlam oluşturucu tarafından her zaman
döndürüldüğü için, bu aracı çağıran her ajan aynı çalışma talimatlarını alır.

## Proje taraması

`POST /api/knowledge/scan` bir projenin AI bağlam dosyalarını amaca göre
sınıflandırarak içe aktarır:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` ve `.cursor/rules` altındaki markdown/`.mdc` **kural** olur
  (critical + enabled, böylece ajan bağlamına ulaşırlar; çalışma alanı `AGENTS.md`'si
  unified-rules ile çift enjeksiyondan kaçınmak için `high`'dır),
- `skills` / `.agents/skills` altındaki `SKILL.md` dosyaları **beceri** olur
  (ad/açıklama frontmatter'dan),
- taranan diğer markdown'lar **referans anı** olur.

Her dosya `kb_scan_state` içinde içerik karmasıyla izlenir, böylece yeniden tarama yalnızca
değişen dosyalara dokunur ve kaynağı kaybolan varlıkları siler.

## İstemci

**Knowledge** ekranı (gezinme çubuğu → Knowledge) Dashboard, Memories,
Rules, Skills, Personal ve Graph sekmelerine, bir proje kapsam filtresine, bir modal
oluştur/düzenle formuna, geri yükleme ile varlık başına sürüm geçmişine, beceri simgesi yüklemesine ve
JSON dışa/içe aktarmaya sahiptir. Memories sekmesinde bir etiket filtre çubuğu (etiket yönetimiyle),
uygulama çubuğunda tam metin arama, bir bağlantı oluşturma diyaloğu ve bir geçiş eylemi vardır
ve Graph sekmesi kaydırma/yakınlaştırma, düğüm sürükleme, varlık türü filtreleri ve komşu
vurgulama ile kuvvet yönelimli bir ilişki görünümüdür.
Grafik, açık bağlantılarınız ile örtük merkezleri çizer — proje kapsamındaki her varlık kendi projesine bağlanır ve bir etiketi paylaşan anılar bir etiket düğümüne bağlanır — böylece her zaman yapıyı gösterir.

## İyi düzenlemek

1. Her etkin projeyi bir kez **tarayın** (Knowledge → proje seç → scan);
   talimat dosyalarında büyük değişikliklerden sonra yeniden tarayın.
2. **Bilinçli olarak yükseltin**: yalnızca gerçekten bağlayıcı kurallar `critical`
   olmalıdır (bağlam oluşturucu tarafından her zaman sunulurlar). Bir satırdaki
   yıldızı kullanın ve kritik bağlam ölçerini izleyin.
3. **Gerisini `high`/`normal` tutun** — yine aranabilir ve MCP üzerinden kullanılabilir,
   yalnızca bir sorgu eşleştiğinde, dolayısıyla ilgisiz olduklarında hiçbir maliyeti yoktur.
4. Projeler arası tercihler (saat dilimi, düzenleyici, adlandırma) için **kişisel bilgi**.
5. **İlgili anıları bağlayın** ki 1 atlamalı komşular birlikte gelsin.
6. Bilgi tabanını araması ve öğrendiklerini kalıcılaştırması gereken ajanlar için **MCP kurun**;
   çoğuna `read` kapsamı, ajanа güvendiğiniz yere `write` verin.

## Geçiş

Knowledge → menü → **Migrate existing rules** bir **dry-run** raporu çalıştırır: tüm
projeleri tarar, projeler arasında var olan yinelenenleri (aynı normalize edilmiş
başlık + içerik) bulur ve kural sayılarını gösterir. Oradan **Merge duplicates**
(tek bir genel satırda birleştirir) ve/veya **Make all rules critical** yapabilirsiniz. Siz
onaylayana kadar hiçbir şey yazılmaz — yıkıcı eylemler açıktır.

**Dashboard**'da ayrıca tek bir **her şeyi ddagent'a içe aktar** düğmesi vardır: proje taramasını ve ajan becerisi içe aktarımını tek bir eylemde çalıştırır; aynı dry-run önizlemesi ve isteğe bağlı yinelenen birleştirme / yükseltme anahtarlarıyla birlikte. Yalnızca ajanlarınızın dosyalarını okur ve ddagent'ın kendi veritabanına yazar — hiçbir CLI dosyası ya da yapılandırması değiştirilmez (bir ajanın yapılandırmasına yazan tek eylem, ayrı "Install ddagent MCP server"dır).

Aynı menüde **Ajan becerilerini içe aktar** vardır: ajanlarınızın zaten sunduğu veya kurduğu genel/varsayılan becerileri (kullanıcı / sistem / eklenti kapsamları) listeler ve eksik olanları beceri olarak bilgi tabanına içe aktarır. Önce bir dry-run'dır ve idempotenttir — zaten var olan bir ad atlanır. Projeye kapsanmış beceriler ise bunun yerine proje taraması tarafından içe aktarılır.

## Bilinmesi iyi olanlar

- Her şey bu ddagent örneğine **yereldir**; bulut yok, senkronizasyon yok.
- Bilgi tabanı **otomatik olarak enjekte edilmez** — ajanlar onu MCP üzerinden
  isteğe bağlı olarak alır (Contexta modeli). MCP sunucusu kurulu olmayan ajanlar
  ondan hiçbir şey almaz.
- Taranan beceriler MCP (`knowledge_get_context` / `knowledge_search`) üzerinden
  erişilebilir, bağlama itilmez.
- Bir kural ya da anı, bir ajan tarafından MCP üzerinden düzenlenebilir; değişiklikleri
  varlığın **History**'sinde inceleyin ve gerekirse önceki bir sürümü geri yükleyin.

## REST API

Kimlik doğrulamanın arkasında `/api/knowledge` altında bağlanır:

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (kritik bağlam boyutu + bütçe)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
POST   /import-skills       { providers?, scopes?, dryRun? }
POST   /import-all          { dryRun?, dedupe?, promoteRules? }
```

`projectId=global` bir listeyi genel satırlarla sınırlar; bir proje id'sine `includeGlobal=true`
eklemek proje satırlarını artı genel satırları döndürür.

## İlgili

- [MCP sunucusu olarak ddagent](mcp-server.md) — araç kataloğu ve token kurulumu
- [Ekip iş birliği](teams.md) · [Uzaktan onaylar](remote-approvals.md)
