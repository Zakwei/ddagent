///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsTr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsTr _root = this; // ignore: unused_field

	@override 
	TranslationsTr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTr(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$tr auth = Translations$auth$tr._(_root);
	@override late final Translations$chat$tr chat = Translations$chat$tr._(_root);
	@override late final Translations$codeEditor$tr codeEditor = Translations$codeEditor$tr._(_root);
	@override late final Translations$common$tr common = Translations$common$tr._(_root);
	@override late final Translations$settings$tr settings = Translations$settings$tr._(_root);
	@override late final Translations$sidebar$tr sidebar = Translations$sidebar$tr._(_root);
	@override late final Translations$tasks$tr tasks = Translations$tasks$tr._(_root);
	@override late final Translations$knowledge$tr knowledge = Translations$knowledge$tr._(_root);
	@override late final Translations$skills$tr skills = Translations$skills$tr._(_root);
	@override late final Translations$mcp$tr mcp = Translations$mcp$tr._(_root);
	@override late final Translations$terminal$tr terminal = Translations$terminal$tr._(_root);
	@override late final Translations$worktrees$tr worktrees = Translations$worktrees$tr._(_root);
	@override late final Translations$quota$tr quota = Translations$quota$tr._(_root);
	@override late final Translations$scheduler$tr scheduler = Translations$scheduler$tr._(_root);
	@override late final Translations$notifications$tr notifications = Translations$notifications$tr._(_root);
	@override late final Translations$serverConnect$tr serverConnect = Translations$serverConnect$tr._(_root);
	@override late final Translations$voice$tr voice = Translations$voice$tr._(_root);
	@override late final Translations$preview$tr preview = Translations$preview$tr._(_root);
	@override late final Translations$sharedContext$tr sharedContext = Translations$sharedContext$tr._(_root);
	@override late final Translations$collab$tr collab = Translations$collab$tr._(_root);
	@override late final Translations$browser$tr browser = Translations$browser$tr._(_root);
	@override late final Translations$projects$tr projects = Translations$projects$tr._(_root);
	@override late final Translations$sessions$tr sessions = Translations$sessions$tr._(_root);
	@override late final Translations$git$tr git = Translations$git$tr._(_root);
	@override late final Translations$kanban$tr kanban = Translations$kanban$tr._(_root);
	@override late final Translations$onboarding$tr onboarding = Translations$onboarding$tr._(_root);
	@override late final Translations$fileTree$tr fileTree = Translations$fileTree$tr._(_root);
	@override late final Translations$workspace$tr workspace = Translations$workspace$tr._(_root);
}

// Path: auth
class Translations$auth$tr extends Translations$auth$en {
	Translations$auth$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.';
	@override late final Translations$auth$login$tr login = Translations$auth$login$tr._(_root);
	@override late final Translations$auth$register$tr register = Translations$auth$register$tr._(_root);
	@override late final Translations$auth$logout$tr logout = Translations$auth$logout$tr._(_root);
}

// Path: chat
class Translations$chat$tr extends Translations$chat$en {
	Translations$chat$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$tr codeBlock = Translations$chat$codeBlock$tr._(_root);
	@override late final Translations$chat$copyMessage$tr copyMessage = Translations$chat$copyMessage$tr._(_root);
	@override late final Translations$chat$messageTypes$tr messageTypes = Translations$chat$messageTypes$tr._(_root);
	@override late final Translations$chat$tools$tr tools = Translations$chat$tools$tr._(_root);
	@override late final Translations$chat$search$tr search = Translations$chat$search$tr._(_root);
	@override late final Translations$chat$fileOperations$tr fileOperations = Translations$chat$fileOperations$tr._(_root);
	@override late final Translations$chat$interactive$tr interactive = Translations$chat$interactive$tr._(_root);
	@override late final Translations$chat$thinking$tr thinking = Translations$chat$thinking$tr._(_root);
	@override late final Translations$chat$json$tr json = Translations$chat$json$tr._(_root);
	@override late final Translations$chat$permissions$tr permissions = Translations$chat$permissions$tr._(_root);
	@override late final Translations$chat$todo$tr todo = Translations$chat$todo$tr._(_root);
	@override late final Translations$chat$plan$tr plan = Translations$chat$plan$tr._(_root);
	@override late final Translations$chat$usageLimit$tr usageLimit = Translations$chat$usageLimit$tr._(_root);
	@override late final Translations$chat$codex$tr codex = Translations$chat$codex$tr._(_root);
	@override late final Translations$chat$input$tr input = Translations$chat$input$tr._(_root);
	@override late final Translations$chat$providerSelection$tr providerSelection = Translations$chat$providerSelection$tr._(_root);
	@override late final Translations$chat$session$tr session = Translations$chat$session$tr._(_root);
	@override late final Translations$chat$shell$tr shell = Translations$chat$shell$tr._(_root);
	@override late final Translations$chat$claudeStatus$tr claudeStatus = Translations$chat$claudeStatus$tr._(_root);
	@override late final Translations$chat$projectSelection$tr projectSelection = Translations$chat$projectSelection$tr._(_root);
	@override late final Translations$chat$tasks$tr tasks = Translations$chat$tasks$tr._(_root);
	@override late final Translations$chat$voice$tr voice = Translations$chat$voice$tr._(_root);
	@override late final Translations$chat$composer$tr composer = Translations$chat$composer$tr._(_root);
	@override late final Translations$chat$splitSession$tr splitSession = Translations$chat$splitSession$tr._(_root);
	@override late final Translations$chat$sessionPicker$tr sessionPicker = Translations$chat$sessionPicker$tr._(_root);
	@override late final Translations$chat$splitWorkspace$tr splitWorkspace = Translations$chat$splitWorkspace$tr._(_root);
	@override late final Translations$chat$splitOverview$tr splitOverview = Translations$chat$splitOverview$tr._(_root);
	@override late final Translations$chat$askUserQuestion$tr askUserQuestion = Translations$chat$askUserQuestion$tr._(_root);
	@override late final Translations$chat$attachments$tr attachments = Translations$chat$attachments$tr._(_root);
	@override late final Translations$chat$checkpoint$tr checkpoint = Translations$chat$checkpoint$tr._(_root);
	@override late final Translations$chat$common$tr common = Translations$chat$common$tr._(_root);
	@override late final Translations$chat$taskMaster$tr taskMaster = Translations$chat$taskMaster$tr._(_root);
	@override late final Translations$chat$tokenUsage$tr tokenUsage = Translations$chat$tokenUsage$tr._(_root);
	@override late final Translations$chat$tool$tr tool = Translations$chat$tool$tr._(_root);
	@override late final Translations$chat$quotaBadge$tr quotaBadge = Translations$chat$quotaBadge$tr._(_root);
	@override late final Translations$chat$paneHeader$tr paneHeader = Translations$chat$paneHeader$tr._(_root);
	@override late final Translations$chat$broadcast$tr broadcast = Translations$chat$broadcast$tr._(_root);
	@override late final Translations$chat$changes$tr changes = Translations$chat$changes$tr._(_root);
	@override late final Translations$chat$commandResult$tr commandResult = Translations$chat$commandResult$tr._(_root);
	@override late final Translations$chat$commands$tr commands = Translations$chat$commands$tr._(_root);
	@override late final Translations$chat$export$tr export = Translations$chat$export$tr._(_root);
	@override late final Translations$chat$message$tr message = Translations$chat$message$tr._(_root);
	@override late final Translations$chat$modelLibrary$tr modelLibrary = Translations$chat$modelLibrary$tr._(_root);
	@override late final Translations$chat$pinFile$tr pinFile = Translations$chat$pinFile$tr._(_root);
	@override late final Translations$chat$permissionRequest$tr permissionRequest = Translations$chat$permissionRequest$tr._(_root);
}

// Path: codeEditor
class Translations$codeEditor$tr extends Translations$codeEditor$en {
	Translations$codeEditor$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$tr toolbar = Translations$codeEditor$toolbar$tr._(_root);
	@override String loading({required Object fileName}) => '${fileName} yükleniyor...';
	@override late final Translations$codeEditor$header$tr header = Translations$codeEditor$header$tr._(_root);
	@override late final Translations$codeEditor$actions$tr actions = Translations$codeEditor$actions$tr._(_root);
	@override late final Translations$codeEditor$footer$tr footer = Translations$codeEditor$footer$tr._(_root);
	@override late final Translations$codeEditor$binaryFile$tr binaryFile = Translations$codeEditor$binaryFile$tr._(_root);
	@override late final Translations$codeEditor$filePreview$tr filePreview = Translations$codeEditor$filePreview$tr._(_root);
	@override late final Translations$codeEditor$diff$tr diff = Translations$codeEditor$diff$tr._(_root);
	@override String get discardUnsavedChanges => 'Kaydedilmemiş değişikliklerden vazgeçilsin mi?';
	@override late final Translations$codeEditor$emptyState$tr emptyState = Translations$codeEditor$emptyState$tr._(_root);
	@override String get failedToLoad => 'Dosya yüklenemedi';
	@override late final Translations$codeEditor$hexDump$tr hexDump = Translations$codeEditor$hexDump$tr._(_root);
	@override late final Translations$codeEditor$mediaFile$tr mediaFile = Translations$codeEditor$mediaFile$tr._(_root);
	@override late final Translations$codeEditor$settings$tr settings = Translations$codeEditor$settings$tr._(_root);
	@override String unsavedChanges({required Object name}) => '${name} dosyasında kaydedilmemiş değişiklikler var';
	@override late final Translations$codeEditor$toasts$tr toasts = Translations$codeEditor$toasts$tr._(_root);
}

// Path: common
class Translations$common$tr extends Translations$common$en {
	Translations$common$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$tr buttons = Translations$common$buttons$tr._(_root);
	@override late final Translations$common$tabs$tr tabs = Translations$common$tabs$tr._(_root);
	@override late final Translations$common$status$tr status = Translations$common$status$tr._(_root);
	@override late final Translations$common$messages$tr messages = Translations$common$messages$tr._(_root);
	@override late final Translations$common$navigation$tr navigation = Translations$common$navigation$tr._(_root);
	@override late final Translations$common$common$tr common = Translations$common$common$tr._(_root);
	@override late final Translations$common$time$tr time = Translations$common$time$tr._(_root);
	@override late final Translations$common$fileOperations$tr fileOperations = Translations$common$fileOperations$tr._(_root);
	@override late final Translations$common$mainContent$tr mainContent = Translations$common$mainContent$tr._(_root);
	@override late final Translations$common$fileTree$tr fileTree = Translations$common$fileTree$tr._(_root);
	@override late final Translations$common$projectWizard$tr projectWizard = Translations$common$projectWizard$tr._(_root);
	@override late final Translations$common$notifications$tr notifications = Translations$common$notifications$tr._(_root);
	@override late final Translations$common$versionUpdate$tr versionUpdate = Translations$common$versionUpdate$tr._(_root);
	@override late final Translations$common$quota$tr quota = Translations$common$quota$tr._(_root);
	@override late final Translations$common$actions$tr actions = Translations$common$actions$tr._(_root);
	@override late final Translations$common$browserPane$tr browserPane = Translations$common$browserPane$tr._(_root);
	@override late final Translations$common$browserUse$tr browserUse = Translations$common$browserUse$tr._(_root);
	@override late final Translations$common$commandPalette$tr commandPalette = Translations$common$commandPalette$tr._(_root);
	@override late final Translations$common$gitPanel$tr gitPanel = Translations$common$gitPanel$tr._(_root);
	@override late final Translations$common$sessions$tr sessions = Translations$common$sessions$tr._(_root);
	@override late final Translations$common$projects$tr projects = Translations$common$projects$tr._(_root);
	@override late final Translations$common$codeBlock$tr codeBlock = Translations$common$codeBlock$tr._(_root);
	@override late final Translations$common$update$tr update = Translations$common$update$tr._(_root);
}

// Path: settings
class Translations$settings$tr extends Translations$settings$en {
	Translations$settings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ayarlar';
	@override late final Translations$settings$changelog$tr changelog = Translations$settings$changelog$tr._(_root);
	@override late final Translations$settings$server$tr server = Translations$settings$server$tr._(_root);
	@override late final Translations$settings$updates$tr updates = Translations$settings$updates$tr._(_root);
	@override late final Translations$settings$tabs$tr tabs = Translations$settings$tabs$tr._(_root);
	@override late final Translations$settings$account$tr account = Translations$settings$account$tr._(_root);
	@override late final Translations$settings$mcp$tr mcp = Translations$settings$mcp$tr._(_root);
	@override late final Translations$settings$appearance$tr appearance = Translations$settings$appearance$tr._(_root);
	@override late final Translations$settings$actions$tr actions = Translations$settings$actions$tr._(_root);
	@override late final Translations$settings$quickSettings$tr quickSettings = Translations$settings$quickSettings$tr._(_root);
	@override late final Translations$settings$terminalShortcuts$tr terminalShortcuts = Translations$settings$terminalShortcuts$tr._(_root);
	@override late final Translations$settings$mainTabs$tr mainTabs = Translations$settings$mainTabs$tr._(_root);
	@override late final Translations$settings$orchestration$tr orchestration = Translations$settings$orchestration$tr._(_root);
	@override late final Translations$settings$notifications$tr notifications = Translations$settings$notifications$tr._(_root);
	@override late final Translations$settings$appearanceSettings$tr appearanceSettings = Translations$settings$appearanceSettings$tr._(_root);
	@override late final Translations$settings$mcpForm$tr mcpForm = Translations$settings$mcpForm$tr._(_root);
	@override late final Translations$settings$saveStatus$tr saveStatus = Translations$settings$saveStatus$tr._(_root);
	@override late final Translations$settings$footerActions$tr footerActions = Translations$settings$footerActions$tr._(_root);
	@override late final Translations$settings$git$tr git = Translations$settings$git$tr._(_root);
	@override late final Translations$settings$apiKeys$tr apiKeys = Translations$settings$apiKeys$tr._(_root);
	@override late final Translations$settings$tasks$tr tasks = Translations$settings$tasks$tr._(_root);
	@override late final Translations$settings$agents$tr agents = Translations$settings$agents$tr._(_root);
	@override late final Translations$settings$permissions$tr permissions = Translations$settings$permissions$tr._(_root);
	@override late final Translations$settings$mcpServers$tr mcpServers = Translations$settings$mcpServers$tr._(_root);
	@override late final Translations$settings$quota$tr quota = Translations$settings$quota$tr._(_root);
	@override late final Translations$settings$browser$tr browser = Translations$settings$browser$tr._(_root);
	@override late final Translations$settings$workspaces$tr workspaces = Translations$settings$workspaces$tr._(_root);
	@override late final Translations$settings$about$tr about = Translations$settings$about$tr._(_root);
}

// Path: sidebar
class Translations$sidebar$tr extends Translations$sidebar$en {
	Translations$sidebar$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$tr projects = Translations$sidebar$projects$tr._(_root);
	@override late final Translations$sidebar$app$tr app = Translations$sidebar$app$tr._(_root);
	@override late final Translations$sidebar$sessions$tr sessions = Translations$sidebar$sessions$tr._(_root);
	@override late final Translations$sidebar$tooltips$tr tooltips = Translations$sidebar$tooltips$tr._(_root);
	@override late final Translations$sidebar$navigation$tr navigation = Translations$sidebar$navigation$tr._(_root);
	@override late final Translations$sidebar$actions$tr actions = Translations$sidebar$actions$tr._(_root);
	@override late final Translations$sidebar$branding$tr branding = Translations$sidebar$branding$tr._(_root);
	@override late final Translations$sidebar$status$tr status = Translations$sidebar$status$tr._(_root);
	@override late final Translations$sidebar$time$tr time = Translations$sidebar$time$tr._(_root);
	@override late final Translations$sidebar$messages$tr messages = Translations$sidebar$messages$tr._(_root);
	@override late final Translations$sidebar$version$tr version = Translations$sidebar$version$tr._(_root);
	@override late final Translations$sidebar$search$tr search = Translations$sidebar$search$tr._(_root);
	@override late final Translations$sidebar$deleteConfirmation$tr deleteConfirmation = Translations$sidebar$deleteConfirmation$tr._(_root);
	@override late final Translations$sidebar$zones$tr zones = Translations$sidebar$zones$tr._(_root);
	@override late final Translations$sidebar$panel$tr panel = Translations$sidebar$panel$tr._(_root);
	@override late final Translations$sidebar$workspace$tr workspace = Translations$sidebar$workspace$tr._(_root);
	@override late final Translations$sidebar$recent$tr recent = Translations$sidebar$recent$tr._(_root);
	@override late final Translations$sidebar$tabs$tr tabs = Translations$sidebar$tabs$tr._(_root);
}

// Path: tasks
class Translations$tasks$tr extends Translations$tasks$en {
	Translations$tasks$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$tr notConfigured = Translations$tasks$notConfigured$tr._(_root);
	@override late final Translations$tasks$gettingStarted$tr gettingStarted = Translations$tasks$gettingStarted$tr._(_root);
	@override late final Translations$tasks$setupModal$tr setupModal = Translations$tasks$setupModal$tr._(_root);
	@override late final Translations$tasks$helpGuide$tr helpGuide = Translations$tasks$helpGuide$tr._(_root);
	@override late final Translations$tasks$search$tr search = Translations$tasks$search$tr._(_root);
	@override late final Translations$tasks$filters$tr filters = Translations$tasks$filters$tr._(_root);
	@override late final Translations$tasks$sort$tr sort = Translations$tasks$sort$tr._(_root);
	@override late final Translations$tasks$views$tr views = Translations$tasks$views$tr._(_root);
	@override late final Translations$tasks$kanban$tr kanban = Translations$tasks$kanban$tr._(_root);
	@override late final Translations$tasks$buttons$tr buttons = Translations$tasks$buttons$tr._(_root);
	@override late final Translations$tasks$prd$tr prd = Translations$tasks$prd$tr._(_root);
	@override late final Translations$tasks$statuses$tr statuses = Translations$tasks$statuses$tr._(_root);
	@override late final Translations$tasks$priorities$tr priorities = Translations$tasks$priorities$tr._(_root);
	@override late final Translations$tasks$noMatchingTasks$tr noMatchingTasks = Translations$tasks$noMatchingTasks$tr._(_root);
	@override late final Translations$tasks$board$tr board = Translations$tasks$board$tr._(_root);
	@override late final Translations$tasks$card$tr card = Translations$tasks$card$tr._(_root);
	@override late final Translations$tasks$createTask$tr createTask = Translations$tasks$createTask$tr._(_root);
	@override late final Translations$tasks$list$tr list = Translations$tasks$list$tr._(_root);
	@override late final Translations$tasks$nextTask$tr nextTask = Translations$tasks$nextTask$tr._(_root);
	@override late final Translations$tasks$taskDetail$tr taskDetail = Translations$tasks$taskDetail$tr._(_root);
	@override late final Translations$tasks$toasts$tr toasts = Translations$tasks$toasts$tr._(_root);
}

// Path: knowledge
class Translations$knowledge$tr extends Translations$knowledge$en {
	Translations$knowledge$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bilgi';
	@override late final Translations$knowledge$tabs$tr tabs = Translations$knowledge$tabs$tr._(_root);
	@override late final Translations$knowledge$common$tr common = Translations$knowledge$common$tr._(_root);
	@override late final Translations$knowledge$actions$tr actions = Translations$knowledge$actions$tr._(_root);
	@override late final Translations$knowledge$dialog$tr dialog = Translations$knowledge$dialog$tr._(_root);
	@override late final Translations$knowledge$fields$tr fields = Translations$knowledge$fields$tr._(_root);
	@override late final Translations$knowledge$dashboard$tr dashboard = Translations$knowledge$dashboard$tr._(_root);
	@override late final Translations$knowledge$empty$tr empty = Translations$knowledge$empty$tr._(_root);
	@override late final Translations$knowledge$history$tr history = Translations$knowledge$history$tr._(_root);
	@override late final Translations$knowledge$priorities$tr priorities = Translations$knowledge$priorities$tr._(_root);
	@override late final Translations$knowledge$search$tr search = Translations$knowledge$search$tr._(_root);
	@override late final Translations$knowledge$links$tr links = Translations$knowledge$links$tr._(_root);
	@override late final Translations$knowledge$tags$tr tags = Translations$knowledge$tags$tr._(_root);
	@override late final Translations$knowledge$contextBudget$tr contextBudget = Translations$knowledge$contextBudget$tr._(_root);
	@override late final Translations$knowledge$critical$tr critical = Translations$knowledge$critical$tr._(_root);
	@override late final Translations$knowledge$errors$tr errors = Translations$knowledge$errors$tr._(_root);
	@override late final Translations$knowledge$graph$tr graph = Translations$knowledge$graph$tr._(_root);
	@override late final Translations$knowledge$importAll$tr importAll = Translations$knowledge$importAll$tr._(_root);
	@override late final Translations$knowledge$importSkills$tr importSkills = Translations$knowledge$importSkills$tr._(_root);
	@override late final Translations$knowledge$linkOptions$tr linkOptions = Translations$knowledge$linkOptions$tr._(_root);
	@override late final Translations$knowledge$migrate$tr migrate = Translations$knowledge$migrate$tr._(_root);
}

// Path: skills
class Translations$skills$tr extends Translations$skills$en {
	Translations$skills$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$skills$addDialog$tr addDialog = Translations$skills$addDialog$tr._(_root);
	@override String deleteSkill({required Object name}) => '${name} sil';
	@override late final Translations$skills$empty$tr empty = Translations$skills$empty$tr._(_root);
	@override late final Translations$skills$errors$tr errors = Translations$skills$errors$tr._(_root);
	@override late final Translations$skills$moveDialog$tr moveDialog = Translations$skills$moveDialog$tr._(_root);
	@override String moveSkill({required Object name}) => '${name} öğesini taşı';
	@override String get projectLabel => 'Proje';
	@override late final Translations$skills$scopes$tr scopes = Translations$skills$scopes$tr._(_root);
	@override late final Translations$skills$screen$tr screen = Translations$skills$screen$tr._(_root);
}

// Path: mcp
class Translations$mcp$tr extends Translations$mcp$en {
	Translations$mcp$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$tr form = Translations$mcp$form$tr._(_root);
	@override late final Translations$mcp$install$tr install = Translations$mcp$install$tr._(_root);
	@override late final Translations$mcp$servers$tr servers = Translations$mcp$servers$tr._(_root);
	@override late final Translations$mcp$team$tr team = Translations$mcp$team$tr._(_root);
	@override late final Translations$mcp$tokens$tr tokens = Translations$mcp$tokens$tr._(_root);
}

// Path: terminal
class Translations$terminal$tr extends Translations$terminal$en {
	Translations$terminal$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$actions$tr actions = Translations$terminal$actions$tr._(_root);
	@override late final Translations$terminal$authUrl$tr authUrl = Translations$terminal$authUrl$tr._(_root);
	@override late final Translations$terminal$errors$tr errors = Translations$terminal$errors$tr._(_root);
	@override late final Translations$terminal$fileLink$tr fileLink = Translations$terminal$fileLink$tr._(_root);
	@override late final Translations$terminal$paste$tr paste = Translations$terminal$paste$tr._(_root);
	@override late final Translations$terminal$shortcuts$tr shortcuts = Translations$terminal$shortcuts$tr._(_root);
	@override late final Translations$terminal$tabs$tr tabs = Translations$terminal$tabs$tr._(_root);
}

// Path: worktrees
class Translations$worktrees$tr extends Translations$worktrees$en {
	Translations$worktrees$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get branchHint => 'Yeni dal adı (örn. feature/login)';
	@override String branchingOff({required Object branch}) => '${branch} dalından ayrılıyor';
	@override String get cleanupDescription => 'Birleştirildikten sonra worktree\'yi kaldır ve dalı sil';
	@override String get created => 'Worktree oluşturuldu';
	@override String get deleteBranchLabel => 'Dalı da sil';
	@override String dirtyWarning({required Object count}) => 'Uyarı: Bu worktree\'de kaybolacak ${count} commit edilmemiş değişiklik var.';
	@override String get emptyDescription => 'Özellik çalışmalarını veya agent çalıştırmalarını yalıtmak için bir worktree oluşturun.';
	@override String get emptyTitle => 'Worktree bulunamadı';
	@override String get forceRemoveLabel => 'Zorla kaldır (değişikliklerden vazgeç)';
	@override String headDetachedAt({required Object sha}) => 'HEAD ${sha} konumunda ayrık';
	@override String get mainBadge => 'main';
	@override String mergeDescription({required Object branch}) => 'Değişiklikleri ${branch} dalına birleştir.';
	@override String mergeTitle({required Object branch}) => '${branch} dalını birleştir';
	@override String merged({required Object branch}) => 'Worktree ${branch} dalına birleştirildi';
	@override String opened({required Object branch}) => 'Worktree açıldı: ${branch}';
	@override String get portHint => 'Çalıştırma portu (isteğe bağlı, örn. 3000)';
	@override String get removeDescription => 'Bu, worktree klasörünü siler. Bağlı projeler arşivlenecek.';
	@override String removeTitle({required Object branch}) => '${branch} worktree\'si kaldırılsın mı?';
	@override String get removed => 'Worktree kaldırıldı';
	@override String get runButton => 'Çalıştır';
	@override String get runHint => 'Çalıştırma komutu (örn. npm run dev)';
	@override String get runRunning => 'çalışıyor';
	@override String runRunningWithPort({required Object port}) => 'çalışıyor :${port}';
	@override String get scripts => 'Scriptler';
	@override String get scriptsSaved => 'Script yapılandırması kaydedildi';
	@override String get serverLabel => 'Sunucu: ';
	@override String get setupHint => 'Kurulum komutu (örn. npm install)';
	@override String get setupLabel => 'Kurulum: ';
	@override String get squashDescription => 'Tüm commitleri tek bir committe birleştir';
	@override String get stopButton => 'Durdur';
}

// Path: quota
class Translations$quota$tr extends Translations$quota$en {
	Translations$quota$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$agents$tr agents = Translations$quota$agents$tr._(_root);
	@override late final Translations$quota$chart$tr chart = Translations$quota$chart$tr._(_root);
	@override late final Translations$quota$config$tr config = Translations$quota$config$tr._(_root);
	@override late final Translations$quota$overview$tr overview = Translations$quota$overview$tr._(_root);
	@override late final Translations$quota$section$tr section = Translations$quota$section$tr._(_root);
}

// Path: scheduler
class Translations$scheduler$tr extends Translations$scheduler$en {
	Translations$scheduler$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Kontrol ediliyor…';
	@override String get cronHint => 'Cron (dakika saat gün ay haftanın günü) — örn. 0 9 * * *';
	@override String deleteMessage({required Object id}) => 'Bu, ${id} yinelenen görevini kaldırır. Mevcut oturumlar korunur.';
	@override String get deleteTitle => 'Zamanlama silinsin mi?';
	@override String get editTitle => 'Zamanlamayı düzenle';
	@override String get newLabel => 'Yeni';
	@override String nextIn({required Object time}) => '${time} sonra';
	@override String get promptHint => 'Agent için prompt';
	@override String get runs => 'Çalıştırmalar';
	@override String session({required Object id}) => 'oturum ${id}';
	@override String get worktree => 'worktree';
}

// Path: notifications
class Translations$notifications$tr extends Translations$notifications$en {
	Translations$notifications$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'ddagent Flutter';
	@override late final Translations$notifications$errors$tr errors = Translations$notifications$errors$tr._(_root);
}

// Path: serverConnect
class Translations$serverConnect$tr extends Translations$serverConnect$en {
	Translations$serverConnect$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get connect => 'Bağlan';
	@override String get connecting => 'Bağlanılıyor…';
	@override String get changeServer => 'Sunucuyu değiştir';
	@override String connectionFailed({required Object error}) => 'Bağlantı başarısız (${error})';
	@override String get enterUrl => 'Bir sunucu URL\'si girin';
	@override late final Translations$serverConnect$local$tr local = Translations$serverConnect$local$tr._(_root);
	@override String get subtitle => 'ddagent sunucunuza bağlanın';
}

// Path: voice
class Translations$voice$tr extends Translations$voice$en {
	Translations$voice$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get apiKeySaved => 'API Anahtarı (kayıtlı, değiştirmek için girin)';
	@override String get preview => 'Önizle';
	@override String get saveFailed => 'STT yapılandırması kaydedilemedi';
	@override String get settingsSaved => 'Sesli giriş ayarları kaydedildi';
}

// Path: preview
class Translations$preview$tr extends Translations$preview$en {
	Translations$preview$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get embeddedWebOnly => 'Gömülü önizleme yalnızca web sürümünde kullanılabilir';
	@override String get startDevServerHint => 'Bir geliştirme sunucusu başlatın (npm run dev, flutter run -d web-server…)\nve portu burada görünecek.';
}

// Path: sharedContext
class Translations$sharedContext$tr extends Translations$sharedContext$en {
	Translations$sharedContext$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paylaşılan Notlar';
}

// Path: collab
class Translations$collab$tr extends Translations$collab$en {
	Translations$collab$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get copyToken => 'Token\'ı kopyala';
	@override String get createInvite => 'Davet oluştur';
	@override String get invite => 'Davet et';
	@override String get inviteTeammate => 'Takım arkadaşını davet et';
	@override late final Translations$collab$roles$tr roles = Translations$collab$roles$tr._(_root);
	@override String get shareTokenHint => 'Bu davet token\'ını paylaşın — yalnızca bir kez gösterilir ve 72 saat içinde sona erer:';
	@override String get team => 'Takım';
}

// Path: browser
class Translations$browser$tr extends Translations$browser$en {
	Translations$browser$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'Agent Tarayıcısı';
	@override String get viewError => 'Tarayıcı görünümü hatası';
	@override String get web => 'Web';
}

// Path: projects
class Translations$projects$tr extends Translations$projects$en {
	Translations$projects$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get archive => 'Arşivle';
	@override String archivedSection({required Object count}) => 'Arşivlenenler (${count})';
	@override String get clone => 'Klonla';
	@override String get cloneFailed => 'Klonlama başarısız';
	@override String get cloneFinished => 'Klonlama tamamlandı. Proje listesi yenileniyor…';
	@override String get cloneRepository => 'Depoyu klonla';
	@override String get deletePermanently => 'Kalıcı olarak sil';
	@override String deleteProjectMessage({required Object name}) => '"${name}" öğesini tüm oturumları ve saklanan geçmişiyle (JSONL silme) kalıcı olarak kaldırır. Bu işlem geri alınamaz.';
	@override String get deleteProjectTitle => 'Proje silinsin mi?';
	@override String get destinationPath => 'Hedef yol';
	@override String get destinationPathRequired => 'Hedef yol gerekli';
	@override String get displayNameOptional => 'Görünen ad (isteğe bağlı)';
	@override String get failedToLoadTokens => 'GitHub token\'ları yüklenemedi';
	@override String get githubTokenOptional => 'GitHub token\'ı (isteğe bağlı)';
	@override String get newer => 'Daha yeni';
	@override String get older => 'Daha eski';
	@override String get projectArchived => 'Proje arşivlendi';
	@override String get projectDeleted => 'Proje silindi';
	@override String get projectRenamed => 'Proje yeniden adlandırıldı';
	@override String get projectRestored => 'Proje geri yüklendi';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get repositoryCloned => 'Depo klonlandı';
	@override String get repositoryUrlRequired => 'Depo URL\'si gerekli';
	@override String get restore => 'Geri yükle';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} oturum',
		other: '${count} oturum',
	);
	@override String get unknown => 'Bilinmiyor';
	@override String usingStoredToken({required Object name}) => 'Kayıtlı token kullanılıyor: ${name}';
}

// Path: sessions
class Translations$sessions$tr extends Translations$sessions$en {
	Translations$sessions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$sessions$activity$tr activity = Translations$sessions$activity$tr._(_root);
	@override late final Translations$sessions$age$tr age = Translations$sessions$age$tr._(_root);
	@override String get archive => 'Arşivle';
	@override String get archivedSessions => 'Arşivlenmiş oturumlar';
	@override String get autoOrchestrator => 'Otomatik (düzenleyici)';
	@override String get compareWith => 'Şununla karşılaştır…';
	@override String createFailed({required Object error}) => 'Oturum oluşturulamadı: ${error}';
	@override String deleteSessionMessage({required Object name}) => '"${name}" öğesini ve transkriptini kaldırır. Bu işlem geri alınamaz.';
	@override String get newSessionProvider => 'Yeni oturum — sağlayıcı';
	@override String get noRecentSessions => 'Yakın zamanda oturum yok';
	@override String get noSessions => 'Oturum yok';
	@override String get projectPath => 'Proje yolu';
	@override String get rename => 'Yeniden adlandır';
	@override late final Translations$sessions$toasts$tr toasts = Translations$sessions$toasts$tr._(_root);
}

// Path: git
class Translations$git$tr extends Translations$git$en {
	Translations$git$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get aiButton => '✦ AI';
	@override late final Translations$git$checkpoints$tr checkpoints = Translations$git$checkpoints$tr._(_root);
	@override String get commitCreated => 'Commit oluşturuldu';
	@override String get commitMessage => 'Commit mesajı';
	@override String get deleteFile => 'Dosyayı sil';
	@override String get hunkStage => '+ Parça';
	@override String get hunkUnstage => '− Parça';
	@override String get largeDiff => 'Büyük diff önizlemesi: sekmeyi yanıt vermeye devam ettirmek için görüntüleme sınırlandırılır.';
	@override String loadDiffFailed({required Object error}) => 'Diff yüklenemedi: ${error}';
	@override String get noBranch => 'dal yok';
	@override String get noDiff => 'Diff yok';
	@override String get selectProject => 'Bir proje seçin';
	@override String get splitDiff => 'Diff\'i böl';
	@override String get stageHunk => 'Parçayı hazırla';
	@override String get stagedChanges => 'Hazırlanan Değişiklikler';
	@override String get statusStaged => 'Hazırlandı';
	@override String get switchBranch => 'Dal değiştir';
	@override String get unifiedDiff => 'Birleşik diff';
	@override String get unstageHunk => 'Parçanın hazırlığını geri al';
}

// Path: kanban
class Translations$kanban$tr extends Translations$kanban$en {
	Translations$kanban$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$tr card = Translations$kanban$card$tr._(_root);
	@override late final Translations$kanban$comments$tr comments = Translations$kanban$comments$tr._(_root);
	@override late final Translations$kanban$details$tr details = Translations$kanban$details$tr._(_root);
	@override late final Translations$kanban$dialog$tr dialog = Translations$kanban$dialog$tr._(_root);
	@override late final Translations$kanban$empty$tr empty = Translations$kanban$empty$tr._(_root);
	@override String get saveFailed => 'Kart kaydedilemedi';
	@override late final Translations$kanban$time$tr time = Translations$kanban$time$tr._(_root);
}

// Path: onboarding
class Translations$onboarding$tr extends Translations$onboarding$en {
	Translations$onboarding$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$onboarding$agents$tr agents = Translations$onboarding$agents$tr._(_root);
	@override String get completeSetup => 'Kurulumu Tamamla';
	@override late final Translations$onboarding$errors$tr errors = Translations$onboarding$errors$tr._(_root);
	@override String get gitHint => 'ddagent oturumlarının oluşturduğu commit\'ler için kullanılır.';
	@override late final Translations$onboarding$mcp$tr mcp = Translations$onboarding$mcp$tr._(_root);
}

// Path: fileTree
class Translations$fileTree$tr extends Translations$fileTree$en {
	Translations$fileTree$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get browseServerFilesystem => 'Sunucu dosya sistemine göz at';
	@override String get chooseFolder => 'Klasör seç';
	@override String get copyContents => 'İçeriği kopyala';
	@override String get noFiles => 'Dosya yok';
	@override late final Translations$fileTree$search$tr search = Translations$fileTree$search$tr._(_root);
	@override late final Translations$fileTree$titles$tr titles = Translations$fileTree$titles$tr._(_root);
	@override String get uploadHere => 'Buraya yükle';
	@override String get uploadTo => 'Şuraya yükle';
	@override String uploadedCount({required Object count}) => '${count} dosya yüklendi';
	@override String get newName => 'Yeni ad';
	@override String notRegisteredProject({required Object path}) => 'Kayıtlı bir proje değil: ${path}';
	@override String get showGitignoredFiles => 'Git tarafından yok sayılan dosyaları göster';
	@override String get hideGitignoredFiles => 'Git tarafından yok sayılan dosyaları gizle';
	@override String get downloadUnsupportedOnWeb => 'Web\'de indirme desteklenmiyor';
	@override String get saveToPath => 'Yola kaydet';
	@override String savedTo({required Object path}) => 'Şuraya kaydedildi: ${path}';
}

// Path: workspace
class Translations$workspace$tr extends Translations$workspace$en {
	Translations$workspace$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get archivedWorkspaceName => 'Arşivlenmiş';
	@override String get closePane => 'Bölmeyi kapat';
	@override String get closeSearch => 'Aramayı kapat';
	@override String get deleteSessionNotice => 'Oturumu ve transkriptini kaldırır. Geri alınamaz.';
	@override String get exportChat => 'Sohbeti dışa aktar';
	@override String get jumpToSession => 'Oturuma git…';
	@override String get newChatProvider => 'Yeni sohbet — sağlayıcı';
	@override String get nextMatch => 'Sonraki eşleşme';
	@override String get previousMatch => 'Önceki eşleşme';
	@override String get searchTranscript => 'Transkriptte ara';
	@override String sendTo({required Object count}) => '${count} oturuma gönder';
	@override String accountWithLabel({required Object label}) => 'Varsayılan · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'Çalışma alanını değiştirmeden önce çalıştırmayı bitir';
	@override String get restored => 'Çalışma alanı geri yüklendi';
	@override String get maximizePane => 'Bölmeyi büyüt';
	@override String get restorePanes => 'Bölmeleri geri yükle';
	@override String get reviewChangedFiles => 'Değişen dosyaları incele';
}

// Path: auth.login
class Translations$auth$login$tr extends Translations$auth$login$en {
	Translations$auth$login$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tekrar Hoş Geldin';
	@override String get description => 'Kendi ddagent hesabına giriş yap';
	@override String get username => 'Kullanıcı Adı';
	@override String get password => 'Şifre';
	@override String get submit => 'Giriş Yap';
	@override String get loading => 'Giriş yapılıyor...';
	@override late final Translations$auth$login$errors$tr errors = Translations$auth$login$errors$tr._(_root);
	@override late final Translations$auth$login$placeholders$tr placeholders = Translations$auth$login$placeholders$tr._(_root);
}

// Path: auth.register
class Translations$auth$register$tr extends Translations$auth$register$en {
	Translations$auth$register$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hesap Oluştur';
	@override String get username => 'Kullanıcı Adı';
	@override String get password => 'Şifre';
	@override String get confirmPassword => 'Şifreyi Onayla';
	@override String get submit => 'Hesabı Oluştur';
	@override String get loading => 'Hesap oluşturuluyor...';
	@override late final Translations$auth$register$errors$tr errors = Translations$auth$register$errors$tr._(_root);
}

// Path: auth.logout
class Translations$auth$logout$tr extends Translations$auth$logout$en {
	Translations$auth$logout$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Çıkış Yap';
	@override String get confirm => 'Çıkış yapmak istediğinden emin misin?';
	@override String get button => 'Çıkış Yap';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$tr extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Kopyala';
	@override String get copied => 'Kopyalandı';
	@override String get copyCode => 'Kodu kopyala';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$tr extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Mesajı kopyala';
	@override String get copied => 'Mesaj kopyalandı';
	@override String get failed => 'Kopyalanamadı';
	@override String get selectFormat => 'Kopyalama biçimini seç';
	@override String get copyAsMarkdown => 'Markdown olarak kopyala';
	@override String get copyAsText => 'Metin olarak kopyala';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$tr extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get user => 'S';
	@override String get error => 'Hata';
	@override String get tool => 'Araç';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
}

// Path: chat.tools
class Translations$chat$tools$tr extends Translations$chat$tools$en {
	Translations$chat$tools$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Araç Ayarları';
	@override String get error => 'Araç Hatası';
	@override String get result => 'Araç Sonucu';
	@override String get viewParams => 'Girdi parametrelerini göster';
	@override String get viewRawParams => 'Ham parametreleri göster';
	@override String get viewDiff => 'Düzenleme diff\'ini göster:';
	@override String get creatingFile => 'Yeni dosya oluşturuluyor:';
	@override String get updatingTodo => 'Yapılacaklar Listesi güncelleniyor';
	@override String get read => 'Okundu';
	@override String get readFile => 'Dosyayı oku';
	@override String get updateTodo => 'Yapılacaklar listesini güncelle';
	@override String get readTodo => 'Yapılacaklar listesini oku';
	@override String get searchResults => 'sonuç';
	@override String get todoReadLabel => 'TodoRead yapılacaklar listesi';
}

// Path: chat.search
class Translations$chat$search$tr extends Translations$chat$search$en {
	Translations$chat$search$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '${count} ${type} bulundu';
	@override String get file => 'dosya';
	@override String get files => 'dosya';
	@override String get pattern => 'desen:';
	@override String get kIn => 'şurada:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$tr extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Dosya başarıyla güncellendi';
	@override String get created => 'Dosya başarıyla oluşturuldu';
	@override String get written => 'Dosya başarıyla yazıldı';
	@override String get diff => 'Diff';
	@override String get newFile => 'Yeni Dosya';
	@override String get viewContent => 'Dosya içeriğini göster';
	@override String viewFullOutput({required Object count}) => 'Tam çıktıyı göster (${count} karakter)';
	@override String get contentDisplayed => 'Dosya içeriği yukarıdaki diff görünümünde gösteriliyor';
}

// Path: chat.interactive
class Translations$chat$interactive$tr extends Translations$chat$interactive$en {
	Translations$chat$interactive$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Etkileşimli Prompt';
	@override String get waiting => 'CLI\'da yanıtın bekleniyor';
	@override String get instruction => 'Lütfen Claude\'un çalıştığı terminalde bir seçenek seç.';
	@override String selectedOption({required Object number}) => '✓ Claude ${number} numaralı seçeneği seçti';
	@override String get instructionDetail => 'CLI\'da bu seçeneği ok tuşları veya numara girerek interaktif olarak seçebilirsin.';
}

// Path: chat.thinking
class Translations$chat$thinking$tr extends Translations$chat$thinking$en {
	Translations$chat$thinking$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Düşünüyor...';
	@override String get emoji => '💭 Düşünüyor...';
}

// Path: chat.json
class Translations$chat$json$tr extends Translations$chat$json$en {
	Translations$chat$json$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSON Yanıtı';
}

// Path: chat.permissions
class Translations$chat$permissions$tr extends Translations$chat$permissions$en {
	Translations$chat$permissions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => '${tool} için izin ver';
	@override String get added => 'İzin eklendi';
	@override String addTo({required Object entry}) => '${entry} İzin Verilen Araçlar listesine ekleniyor.';
	@override String get retry => 'İzin kaydedildi. Aracı kullanmak için isteği tekrar dene.';
	@override String get error => 'İzinler güncellenemedi. Lütfen tekrar dene.';
	@override String get openSettings => 'Ayarları aç';
	@override String get allow => 'İzin ver';
	@override String allowAll({required Object count}) => 'Tümüne izin ver (${count})';
	@override String get allowWithChanges => 'Değişikliklerle izin ver';
	@override String get always => 'Her zaman';
	@override String get deny => 'Reddet';
	@override String get editAndAllow => 'Düzenle ve izin ver';
	@override String get editInput => 'Girdiyi düzenle';
	@override String get invalidJson => 'Geçersiz JSON';
	@override String get reject => 'Reddet';
}

// Path: chat.todo
class Translations$chat$todo$tr extends Translations$chat$todo$en {
	Translations$chat$todo$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Yapılacaklar listesi başarıyla güncellendi';
	@override String get current => 'Mevcut Yapılacaklar Listesi';
}

// Path: chat.plan
class Translations$chat$plan$tr extends Translations$chat$plan$en {
	Translations$chat$plan$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 Uygulama planını göster';
	@override String get title => 'Uygulama Planı';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$tr extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Claude kullanım limitin doldu. Limitin **${time} ${timezone}** — ${date} tarihinde sıfırlanacak';
}

// Path: chat.codex
class Translations$chat$codex$tr extends Translations$chat$codex$en {
	Translations$chat$codex$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'İzin Modu';
	@override late final Translations$chat$codex$modes$tr modes = Translations$chat$codex$modes$tr._(_root);
	@override late final Translations$chat$codex$descriptions$tr descriptions = Translations$chat$codex$descriptions$tr._(_root);
	@override String get technicalDetails => 'Teknik ayrıntılar';
}

// Path: chat.input
class Translations$chat$input$tr extends Translations$chat$input$en {
	Translations$chat$input$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => 'Komutlar için /, dosyalar için @ yaz ya da ${provider}\'a her şeyi sor...';
	@override String get placeholderDefault => 'Mesajını yaz...';
	@override String get disabled => 'Girdi devre dışı';
	@override String get attachFiles => 'Dosya ekle';
	@override String get attachImages => 'Resim ekle';
	@override String get send => 'Gönder';
	@override String get stop => 'Durdur';
	@override late final Translations$chat$input$hintText$tr hintText = Translations$chat$input$hintText$tr._(_root);
	@override String get clickToChangeMode => 'İzin modunu değiştirmek için tıkla';
	@override String get showAllCommands => 'Tüm komutları göster';
	@override String get clearInput => 'Girdiyi temizle';
	@override String get scrollToBottom => 'En alta git';
	@override String get attachFilesDesc => 'Fotoğraf, dosya veya belge yükle';
	@override String get takePhoto => 'Fotoğraf çek';
	@override String get takePhotoDesc => 'Fotoğraf çekmek için kamerayı kullan';
	@override String get moreTools => 'Daha fazla araç';
	@override String get commandsDesc => 'Kısayolları ve komutları keşfet';
	@override String get clearInputDesc => 'Mevcut metni sil';
	@override String get newMessage => 'Yeni mesaj';
	@override String get newMessages => 'Yeni mesajlar';
	@override late final Translations$chat$input$queue$tr queue = Translations$chat$input$queue$tr._(_root);
	@override String get autoContinueTasks => 'Otomatik devam';
	@override String get autoContinueTasksTooltip => 'Devin\'in bir sonraki Task Master görevine otomatik geçmesi için etkinleştir';
	@override late final Translations$chat$input$offlineQueue$tr offlineQueue = Translations$chat$input$offlineQueue$tr._(_root);
	@override String cameraUnavailable({required Object error}) => 'Kamera kullanılamıyor: ${error}';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$tr extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'AI Asistanını Seç';
	@override String get description => 'Yeni bir konuşma başlatmak için bir sağlayıcı seç';
	@override String get selectModel => 'Model Seç';
	@override late final Translations$chat$providerSelection$providerInfo$tr providerInfo = Translations$chat$providerSelection$providerInfo$tr._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$tr readyPrompt = Translations$chat$providerSelection$readyPrompt$tr._(_root);
	@override String pressToSearch({required Object shortcut}) => 'Oturumlarda, dosyalarda ve commit\'lerde arama yapmak için <kbd>${shortcut}</kbd> tuşlarına bas';
	@override String get workspace => 'Çalışma alanı';
	@override String get noWorkspace => 'Yok';
	@override String get clickToChangeWorkspace => 'Çalışma alanını değiştirmek için tıkla';
	@override String get chooseWorkspace => 'Çalışma alanı seç';
	@override String get searchWorkspaces => 'Çalışma alanı ara...';
	@override String get noWorkspacesFound => 'Çalışma alanı bulunamadı.';
	@override String get all => 'Tümü';
	@override String get free => 'Ücretsiz';
	@override String get noModelsFound => 'Model bulunamadı.';
	@override String get paid => 'Ücretli';
	@override String get searchModels => 'Model ara...';
	@override String get addModel => 'Model ekle';
	@override String get chooseModel => 'Model seç';
	@override String get chooseModelDescription => 'Yerleşik ve özel modeller tek listede';
	@override String get clickToChange => 'Modeli değiştirmek için tıkla';
	@override String get favorites => 'Favoriler';
	@override String get loadingModels => 'Modeller yükleniyor…';
	@override String get manageModels => 'Modelleri yönet';
	@override String get refresh => 'Modelleri yenile';
}

// Path: chat.session
class Translations$chat$session$tr extends Translations$chat$session$en {
	Translations$chat$session$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$tr kContinue = Translations$chat$session$kContinue$tr._(_root);
	@override late final Translations$chat$session$loading$tr loading = Translations$chat$session$loading$tr._(_root);
	@override late final Translations$chat$session$messages$tr messages = Translations$chat$session$messages$tr._(_root);
	@override String get deleteConfirm => 'Oturumu ve transkriptini kaldırır. Geri alınamaz.';
	@override String get finishRunBeforeWorkspaceChange => 'Çalışma alanını değiştirmeden önce çalıştırmayı bitir';
}

// Path: chat.shell
class Translations$chat$shell$tr extends Translations$chat$shell$en {
	Translations$chat$shell$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$tr selectProject = Translations$chat$shell$selectProject$tr._(_root);
	@override late final Translations$chat$shell$status$tr status = Translations$chat$shell$status$tr._(_root);
	@override late final Translations$chat$shell$actions$tr actions = Translations$chat$shell$actions$tr._(_root);
	@override String get loading => 'Terminal yükleniyor...';
	@override String get connecting => 'Shell\'e bağlanılıyor...';
	@override String get startSession => 'Yeni bir Claude oturumu başlat';
	@override String resumeSession({required Object displayName}) => 'Oturuma devam et: ${displayName}...';
	@override String runCommand({required Object projectName, required Object command}) => '${projectName} içinde ${command} çalıştır';
	@override String startCli({required Object projectName}) => '${projectName} içinde Claude CLI başlatılıyor';
	@override String get defaultCommand => 'komut';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$tr extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$tr actions = Translations$chat$claudeStatus$actions$tr._(_root);
	@override late final Translations$chat$claudeStatus$state$tr state = Translations$chat$claudeStatus$state$tr._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$tr elapsed = Translations$chat$claudeStatus$elapsed$tr._(_root);
	@override late final Translations$chat$claudeStatus$controls$tr controls = Translations$chat$claudeStatus$controls$tr._(_root);
	@override late final Translations$chat$claudeStatus$providers$tr providers = Translations$chat$claudeStatus$providers$tr._(_root);
	@override String get stop => 'Durdur';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$tr extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => '${provider} ile sohbet etmeye başlamak için bir proje seç';
}

// Path: chat.tasks
class Translations$chat$tasks$tr extends Translations$chat$tasks$en {
	Translations$chat$tasks$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => 'Sonraki görevi başlat';
}

// Path: chat.voice
class Translations$chat$voice$tr extends Translations$chat$voice$en {
	Translations$chat$voice$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get autoRead => 'Yanıtları sesli oku';
	@override String get autoReadOn => 'Yanıtları sesli okuma: açık';
	@override String get autoReadOff => 'Yanıtları sesli okuma: kapalı';
	@override String get autoReadVoice => 'Sesli okuma sesi';
	@override String get autoReadVoiceAuto => 'Otomatik ses';
	@override String get autoReadPreview => 'Yanıtlar böyle seslendirilecek.';
	@override String get speakMessage => 'Sesli oku';
	@override String get stopSpeaking => 'Okumayı durdur';
}

// Path: chat.composer
class Translations$chat$composer$tr extends Translations$chat$composer$en {
	Translations$chat$composer$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'Araçlar ve eylemler';
	@override String get toolsAndActionsDesc => 'Sohbet düzenleyici için araçlar ve denetimler';
	@override String get reasoning => 'Mantık yürütüyor';
	@override String get model => 'Model';
	@override String get effortDefault => 'Varsayılan';
	@override String get loadingModels => 'Modeller yükleniyor…';
	@override String get modelMenu => 'Model ve akıl yürütme düzeyi seç';
	@override String permissionHeading({required Object provider}) => '${provider} eylemleri nasıl onaylansın?';
	@override String get favorites => 'Favoriler';
}

// Path: chat.splitSession
class Translations$chat$splitSession$tr extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'Oturumu Böl';
	@override String get close => 'Bölünmüş oturumu kapat';
	@override String get selectSession => 'Karşılaştırılacak oturumu seç';
	@override String get noOtherSessions => 'Başka oturum yok';
	@override String get newSessionOption => '+ Bölünmüş görünümde yeni oturum';
	@override String currentProjectGroup({required Object name}) => 'Mevcut Proje (${name})';
	@override String get otherProjectsGroup => 'Diğer Projeler';
	@override String get recentSessionsGroup => 'Son oturumlar';
	@override String get startNewSession => 'Bölünmüş Görünümde Yeni Oturum Başlat';
	@override String get selectFromList => 'Mevcut oturumlar listesinden oturum seç';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$tr extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oturum seç';
	@override String get searchPlaceholder => 'Oturum ara...';
	@override String get clearSearch => 'Aramayı temizle';
	@override String get newChat => '+ Yeni sohbet';
	@override String get archivedToggle => 'Arşivlenmiş';
	@override String get changeSession => 'Oturum değiştir';
	@override String get archivedLoading => 'Arşivlenmiş oturumlar yükleniyor...';
	@override String get archivedError => 'Arşivlenmiş oturumlar yüklenemedi';
	@override String get archivedEmpty => 'Arşivlenmiş oturum yok';
	@override String get archivedProjectOnly => 'Çalışma alanı arşivlendi — oturumlarını görmek için geri yükle.';
	@override String get emptySearch => 'Aramanla eşleşen oturum yok';
	@override String get restore => 'Geri yükle';
	@override String get restoreSession => 'Oturumu geri yükle';
	@override String get restoreProject => 'Çalışma alanını geri yükle';
	@override String get restoreSessionFailed => 'Oturum geri yüklenemedi. Lütfen tekrar dene.';
	@override String get restoreProjectFailed => 'Çalışma alanı geri yüklenemedi. Lütfen tekrar dene.';
	@override String get archiveFailed => 'Oturum arşivlenemedi. Lütfen tekrar dene.';
	@override String get deleteFailed => 'Oturum silinemedi. Lütfen tekrar dene.';
	@override String get running => 'Oturum çalışıyor';
	@override String get unread => 'Okunmadı — yeni çıktıyla tamamlandı';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$tr extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'Sohbet bölmesi ekle';
	@override String get addBrowser => 'Tarayıcı bölmesi ekle';
	@override String get addTerminal => 'Terminal bölmesi ekle';
	@override String get overview => 'Tüm bölmeleri göster';
	@override String get exitFocusMode => 'Odak Modundan çık (Ctrl+Shift+F)';
	@override String get focusMode => 'Odak Modu (Ctrl+Shift+F)';
	@override String get browseSessions => 'Oturum listesini aç';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$tr extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bölünmüş bölmelere genel bakış';
	@override String count({required Object count}) => '${count} bölme';
	@override String get close => 'Genel görünümü kapat';
	@override String get question => 'SORU — girdi gerekli';
	@override String get processing => 'İŞLENİYOR';
	@override String get idle => 'Boşta';
	@override String get active => 'Etkin';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$tr extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} girdinizi bekliyor';
	@override String get answerHint => 'Yanıtınızı yazın…';
	@override String get other => 'Diğer…';
	@override String get skip => 'Atla';
}

// Path: chat.attachments
class Translations$chat$attachments$tr extends Translations$chat$attachments$en {
	Translations$chat$attachments$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'İndirme başarısız — yeniden denemek için tıklayın';
	@override String get fileAttachment => 'Dosya eki';
	@override String download({required Object name}) => '${name} indir';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$tr extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get creating => 'Anlık görüntü oluşturuluyor…';
	@override String get revertChanges => 'Dosyaları son kontrol noktasına geri al';
	@override String get undo => 'Kontrol noktasını geri al';
	@override String get beforeAiTurn => 'AI turundan önce';
}

// Path: chat.common
class Translations$chat$common$tr extends Translations$chat$common$en {
	Translations$chat$common$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get close => 'Kapat';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$tr extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'Görev';
	@override String get saved => 'Kaydedildi';
	@override String get saving => 'Kaydediliyor...';
	@override String get taskShort => 'GÖREV';
	@override String get addToTask => 'TaskMaster\'a ekle';
	@override String get added => 'TaskMaster\'a eklendi';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$tr extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get desc => 'Oturum token tüketimini görüntüle';
	@override String get title => 'Token kullanımı';
}

// Path: chat.tool
class Translations$chat$tool$tr extends Translations$chat$tool$en {
	Translations$chat$tool$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(henüz çıktı yok — araç boş sonuç döndürdü)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$tr extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'Abonelik limitleri';
	@override String get noData => 'Bu model için abonelik verisi yok';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$tr extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get processing => 'İşleniyor…';
	@override String get switchSession => 'Oturum değiştir';
}

// Path: chat.broadcast
class Translations$chat$broadcast$tr extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => 'Düzenleyicileri seç';
	@override String get orchestratorsOnly => 'Yalnızca düzenleyiciler';
	@override String get noOrchestrators => 'Kullanılabilir düzenleyici oturumu yok';
}

// Path: chat.changes
class Translations$chat$changes$tr extends Translations$chat$changes$en {
	Translations$chat$changes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Dosya değişikliği yok';
	@override String get failedToLoad => 'Değişiklikler yüklenemedi';
}

// Path: chat.commandResult
class Translations$chat$commandResult$tr extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$tr fallback = Translations$chat$commandResult$fallback$tr._(_root);
	@override String get filterCommands => 'Komutları filtrele...';
	@override String searchModels({required Object provider}) => '${provider} modellerini ara...';
}

// Path: chat.commands
class Translations$chat$commands$tr extends Translations$chat$commands$en {
	Translations$chat$commands$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'Komut çalıştırılsın mı?';
	@override String get executionCancelled => 'Komut çalıştırma iptal edildi';
}

// Path: chat.export
class Translations$chat$export$tr extends Translations$chat$export$en {
	Translations$chat$export$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'Oturum ${id}';
	@override String get pdfFailed => 'PDF dışa aktarma başarısız';
	@override String get transcriptDownloaded => 'Transkript indirildi';
	@override String savedTo({required Object path}) => 'Kaydedildi: ${path}';
}

// Path: chat.message
class Translations$chat$message$tr extends Translations$chat$message$en {
	Translations$chat$message$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => 'Sıkıştırılmış özet';
	@override String get rawView => 'Ham görünüm';
	@override String get resendHint => 'Düzenleyiciden yeniden gönderin';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$tr extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String deleteTooltip({required Object name}) => '${name} sil';
	@override String editTooltip({required Object name}) => '${name} düzenle';
	@override String get enterNameAndId => 'Hem model adını hem de model ID\'sini gir.';
	@override String get idNoSpaces => 'Model ID\'leri boşluk içeremez.';
	@override String get setAsDefault => 'Varsayılan olarak ayarla';
	@override String get defaultModel => 'Varsayılan model';
}

// Path: chat.pinFile
class Translations$chat$pinFile$tr extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get action => 'Sabitle';
	@override String get pathHint => 'path/to/file.ext';
	@override String get title => 'Dosyayı sabitle';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$tr extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => 'İzin isteği · ${tool}';
	@override String get question => 'Soru';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$tr extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get changes => 'değişiklik';
	@override String get previousChange => 'Önceki değişiklik';
	@override String get nextChange => 'Sonraki değişiklik';
	@override String get hideDiff => 'Diff vurgusunu gizle';
	@override String get showDiff => 'Diff vurgusunu göster';
	@override String get settings => 'Editör Ayarları';
	@override String get collapse => 'Editörü daralt';
	@override String get expand => 'Editörü tüm genişliğe aç';
	@override String get diffMerge => 'Diff / birleştirme';
	@override String get previewInBrowser => 'Tarayıcıda önizle';
	@override String get reload => 'Diskten yeniden yükle';
	@override String get toggleDock => 'Dosya panelini aç/kapat';
}

// Path: codeEditor.header
class Translations$codeEditor$header$tr extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => 'Değişiklikler gösteriliyor';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$tr extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'Dosya yolunu kopyala';
	@override String get pathCopied => 'Dosya yolu kopyalandı';
	@override String get download => 'Dosyayı indir';
	@override String get save => 'Kaydet';
	@override String get saving => 'Kaydediliyor...';
	@override String get saved => 'Kaydedildi!';
	@override String get exitFullscreen => 'Tam ekrandan çık';
	@override String get fullscreen => 'Tam ekran';
	@override String get close => 'Kapat';
	@override String get previewMarkdown => 'Markdown önizle';
	@override String get editMarkdown => 'Markdown düzenle';
	@override String get pinFile => 'Dosyayı bağlama sabitle';
	@override String get unpinFile => 'Dosyayı bağlamdan çıkar';
	@override String get previewHtml => 'HTML önizlemesini yeni sekmede aç';
	@override String get retry => 'Yeniden dene';
	@override String get saveAll => 'Tümünü kaydet';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$tr extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get lines => 'Satır:';
	@override String get characters => 'Karakter:';
	@override String get shortcuts => 'Kaydetmek için Ctrl+S • Kapatmak için Esc';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$tr extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Binary Dosya';
	@override String message({required Object fileName}) => '"${fileName}" dosyası binary olduğu için metin editöründe gösterilemez.';
	@override String get cannotDisplayAsText => 'Metin olarak gösterilemez';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$tr extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Önizleme yükleniyor...';
	@override String get error => 'Bu dosya görüntülenemiyor.';
	@override String get openInNewTab => 'Yeni sekmede aç';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$tr extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get applyMerge => 'Birleştirmeyi uygula';
	@override String get base => 'Temel';
	@override String get close => 'Diff\'i kapat';
	@override String get current => 'Geçerli';
	@override String hunk({required Object number}) => 'Parça ${number}';
	@override String get noChanges => 'Değişiklik yok';
	@override String get deletedOnDisk => 'diskte silindi';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$tr extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Açık dosya yok';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$tr extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… ${size} daha';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$tr extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Ses/video önizlemesi henüz desteklenmiyor';
	@override String get title => 'Medya dosyası';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$tr extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String fontSizeDecrease({required Object size}) => 'Yazı tipi boyutu −  (şimdi ${size})';
	@override String get fontSizeIncrease => 'Yazı tipi boyutu +';
	@override String get minimap => 'Minimap';
	@override String tabSize({required Object size}) => 'Sekme boyutu: ${size}';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$tr extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => '${name} kaydedildi';
	@override String get saveFailed => 'Kaydetme başarısız';
	@override String get allSaved => 'Tümü kaydedildi';
	@override String get someSavesFailed => 'Bazı kaydetmeler başarısız oldu';
	@override String savedTo({required Object path}) => 'Şuraya kaydedildi: ${path}';
	@override String get mergeApplied => 'Birleştirme uygulandı — kalıcı olması için kaydet';
}

// Path: common.buttons
class Translations$common$buttons$tr extends Translations$common$buttons$en {
	Translations$common$buttons$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get save => 'Kaydet';
	@override String get cancel => 'İptal';
	@override String get delete => 'Sil';
	@override String get create => 'Oluştur';
	@override String get edit => 'Düzenle';
	@override String get close => 'Kapat';
	@override String get confirm => 'Onayla';
	@override String get submit => 'Gönder';
	@override String get retry => 'Tekrar Dene';
	@override String get refresh => 'Yenile';
	@override String get search => 'Ara';
	@override String get clear => 'Temizle';
	@override String get copy => 'Kopyala';
	@override String get download => 'İndir';
	@override String get upload => 'Yükle';
	@override String get browse => 'Gözat';
	@override String get openDiagram => 'Diyagramı aç';
	@override String get update => 'Güncelle';
}

// Path: common.tabs
class Translations$common$tabs$tr extends Translations$common$tabs$en {
	Translations$common$tabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Sohbet';
	@override String get shell => 'Shell';
	@override String get files => 'Dosyalar';
	@override String get git => 'Kaynak Kontrolü';
	@override String get tasks => 'Görevler';
	@override String get browser => 'Tarayıcı';
	@override String get computer => 'Bilgisayar';
	@override String get board => 'Pano';
	@override String get usage => 'AI Control';
}

// Path: common.status
class Translations$common$status$tr extends Translations$common$status$en {
	Translations$common$status$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Yükleniyor...';
	@override String get success => 'Başarılı';
	@override String get error => 'Hata';
	@override String get failed => 'Başarısız';
	@override String get pending => 'Beklemede';
	@override String get completed => 'Tamamlandı';
	@override String get inProgress => 'Sürüyor';
}

// Path: common.messages
class Translations$common$messages$tr extends Translations$common$messages$en {
	Translations$common$messages$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => 'Başarıyla kaydedildi';
	@override String get deletedSuccessfully => 'Başarıyla silindi';
	@override String get updatedSuccessfully => 'Başarıyla güncellendi';
	@override String get operationFailed => 'İşlem başarısız';
	@override String get networkError => 'Ağ hatası. Lütfen bağlantını kontrol et.';
	@override String get unauthorized => 'Yetkisiz erişim. Lütfen giriş yap.';
	@override String get notFound => 'Bulunamadı';
	@override String get invalidInput => 'Geçersiz girdi';
	@override String get requiredField => 'Bu alan zorunlu';
	@override String get unknownError => 'Bilinmeyen bir hata oluştu';
	@override String get renameSessionFailed => 'Oturum yeniden adlandırılamadı. Lütfen tekrar deneyin.';
}

// Path: common.navigation
class Translations$common$navigation$tr extends Translations$common$navigation$en {
	Translations$common$navigation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Ayarlar';
	@override String get home => 'Ana Sayfa';
	@override String get back => 'Geri';
	@override String get next => 'İleri';
	@override String get previous => 'Önceki';
	@override String get logout => 'Çıkış Yap';
}

// Path: common.common
class Translations$common$common$tr extends Translations$common$common$en {
	Translations$common$common$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get language => 'Dil';
	@override String get theme => 'Tema';
	@override String get darkMode => 'Koyu Mod';
	@override String get lightMode => 'Açık Mod';
	@override String get name => 'İsim';
	@override String get description => 'Açıklama';
	@override String get enabled => 'Etkin';
	@override String get disabled => 'Devre Dışı';
	@override String get optional => 'İsteğe Bağlı';
	@override String get version => 'Sürüm';
	@override String get select => 'Seç';
	@override String get selectAll => 'Tümünü Seç';
	@override String get deselectAll => 'Tümünün Seçimini Kaldır';
	@override String get done => 'Tamam';
	@override String get failed => 'Başarısız';
}

// Path: common.time
class Translations$common$time$tr extends Translations$common$time$en {
	Translations$common$time$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Az önce';
	@override String minutesAgo({required Object count}) => '${count} dakika önce';
	@override String hoursAgo({required Object count}) => '${count} saat önce';
	@override String daysAgo({required Object count}) => '${count} gün önce';
	@override String get yesterday => 'Dün';
}

// Path: common.fileOperations
class Translations$common$fileOperations$tr extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get newFile => 'Yeni Dosya';
	@override String get newFolder => 'Yeni Klasör';
	@override String get rename => 'Yeniden Adlandır';
	@override String get move => 'Taşı';
	@override String get copyPath => 'Yolu Kopyala';
	@override String get openInEditor => 'Editörde Aç';
}

// Path: common.mainContent
class Translations$common$mainContent$tr extends Translations$common$mainContent$en {
	Translations$common$mainContent$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'ddagent Yükleniyor';
	@override String get settingUpWorkspace => 'Çalışma alanın hazırlanıyor...';
	@override String get chooseProject => 'Projeni Seç';
	@override String get selectProjectDescription => 'Claude ile kodlamaya başlamak için kenar çubuğundan bir proje seç. Her proje kendi sohbet oturumlarını ve dosya geçmişini içerir.';
	@override String get tip => 'İpucu';
	@override String get createProjectMobile => 'Projelere erişmek için yukarıdaki menü düğmesine dokun';
	@override String get createProjectDesktop => 'Kenar çubuğundaki klasör simgesine tıklayarak yeni bir proje oluştur';
	@override String get newSession => 'Yeni Oturum';
	@override String get untitledSession => 'Adsız Oturum';
	@override String get projectFiles => 'Proje Dosyaları';
	@override String get focusMode => 'Odak Modu (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'Odak Modundan Çık (Ctrl+Shift+F)';
	@override String get splitSession => 'Oturumu Böl';
	@override String get closeSplitSession => 'Bölünmüş oturumu kapat';
	@override String get chooseWorkspace => 'Bir çalışma alanı seçin';
	@override String get chooseWorkspaceDescription => 'Bu sohbet için bir çalışma alanı seçin veya Ayarlar’da yeni bir tane oluşturun.';
	@override String get createWorkspace => 'Ayarlar’da çalışma alanı oluştur';
	@override String get recentProjects => 'Son projeler';
}

// Path: common.fileTree
class Translations$common$fileTree$tr extends Translations$common$fileTree$en {
	Translations$common$fileTree$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Dosyalar yükleniyor...';
	@override String get files => 'Dosyalar';
	@override String get simpleView => 'Basit görünüm';
	@override String get compactView => 'Kompakt görünüm';
	@override String get detailedView => 'Detaylı görünüm';
	@override String get searchPlaceholder => 'Dosya ve klasörlerde ara...';
	@override String get clearSearch => 'Aramayı temizle';
	@override String get name => 'İsim';
	@override String get size => 'Boyut';
	@override String get modified => 'Değiştirilme';
	@override String get permissions => 'İzinler';
	@override String get noFilesFound => 'Dosya bulunamadı';
	@override String get checkProjectPath => 'Proje yolunun erişilebilir olduğunu kontrol et';
	@override String get noMatchesFound => 'Eşleşme bulunamadı';
	@override String get tryDifferentSearch => 'Farklı bir arama terimi dene veya aramayı temizle';
	@override String get justNow => 'az önce';
	@override String minAgo({required Object count}) => '${count} dakika önce';
	@override String hoursAgo({required Object count}) => '${count} saat önce';
	@override String daysAgo({required Object count}) => '${count} gün önce';
	@override String get newFile => 'Yeni Dosya (Cmd+N)';
	@override String get newFolder => 'Yeni Klasör (Cmd+Shift+N)';
	@override String get refresh => 'Yenile';
	@override String get collapseAll => 'Tümünü Daralt';
	@override late final Translations$common$fileTree$context$tr context = Translations$common$fileTree$context$tr._(_root);
	@override String get searchContentPlaceholder => 'Dosyalarda ara...';
	@override String get searchInFiles => 'Dosyalarda ara';
	@override String get searchByName => 'Ada göre ara';
	@override String get loadFailed => 'Dosyalar yüklenemedi';
	@override String get noSearchResults => 'Eşleşme bulunamadı';
	@override String get searchError => 'Arama başarısız';
	@override String get searching => 'Aranıyor...';
	@override String resultsTruncated({required Object count}) => 'İlk ${count} sonuç gösteriliyor';
	@override String get allWorkspaces => 'Tüm çalışma alanları';
	@override late final Translations$common$fileTree$delete$tr delete = Translations$common$fileTree$delete$tr._(_root);
	@override String get dropToUpload => 'Yüklemek için dosyaları bırakın';
	@override String dropToUploadTo({required Object folder}) => '“${folder}” klasörüne yüklemek için dosyaları bırakın';
	@override String get noProject => 'Önce bir proje ekleyin';
	@override String get noRecentFiles => 'Son 7 günde değiştirilen dosya yok';
	@override String get showAllFiles => 'Tüm dosyaları göster';
	@override String get showAllFilesHint => 'Her şeyi görmek için son değişenler filtresini kapatın.';
	@override String get showRecentOnly => 'Son 7 günde değişen dosyaları göster';
	@override late final Translations$common$fileTree$toast$tr toast = Translations$common$fileTree$toast$tr._(_root);
	@override String get uploadComplete => 'Yükleme tamamlandı';
	@override String get uploadFailed => 'Yükleme başarısız';
	@override String uploadFiles({required Object size}) => 'Dosya yükle (her biri en fazla ${size})';
	@override String uploadToFolder({required Object folder}) => 'Dosyaları “${folder}” klasörüne yükle';
	@override String uploadedCount({required Object total, required Object label, required Object uploaded}) => '${total} ${label} içinden ${uploaded} yüklendi';
	@override String get uploadingFiles => 'Dosyalar yükleniyor';
	@override late final Translations$common$fileTree$validation$tr validation = Translations$common$fileTree$validation$tr._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$tr extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Yeni Proje Oluştur';
	@override late final Translations$common$projectWizard$steps$tr steps = Translations$common$projectWizard$steps$tr._(_root);
	@override late final Translations$common$projectWizard$step1$tr step1 = Translations$common$projectWizard$step1$tr._(_root);
	@override late final Translations$common$projectWizard$step2$tr step2 = Translations$common$projectWizard$step2$tr._(_root);
	@override late final Translations$common$projectWizard$step3$tr step3 = Translations$common$projectWizard$step3$tr._(_root);
	@override late final Translations$common$projectWizard$buttons$tr buttons = Translations$common$projectWizard$buttons$tr._(_root);
	@override late final Translations$common$projectWizard$errors$tr errors = Translations$common$projectWizard$errors$tr._(_root);
}

// Path: common.notifications
class Translations$common$notifications$tr extends Translations$common$notifications$en {
	Translations$common$notifications$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'bir araç';
	@override late final Translations$common$notifications$codes$tr codes = Translations$common$notifications$codes$tr._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$tr extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Güncelleme Mevcut';
	@override String get newVersionReady => 'Yeni bir sürüm hazır';
	@override String get currentVersion => 'Mevcut Sürüm';
	@override String get latestVersion => 'Son Sürüm';
	@override String get whatsNew => 'Yenilikler:';
	@override String get viewFullRelease => 'Tam sürüm notlarını gör';
	@override String get updateProgress => 'Güncelleme İlerlemesi:';
	@override String get manualUpgrade => 'Manuel yükseltme:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'Veya güncellemeyi otomatik çalıştırmak için "Şimdi Güncelle"ye tıkla.';
	@override String get updateCompleted => 'Güncelleme başarıyla tamamlandı!';
	@override String get restartServer => 'Değişikliklerin uygulanması için sunucuyu yeniden başlat.';
	@override String get updateFailed => 'Güncelleme başarısız';
	@override late final Translations$common$versionUpdate$buttons$tr buttons = Translations$common$versionUpdate$buttons$tr._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$tr ariaLabels = Translations$common$versionUpdate$ariaLabels$tr._(_root);
}

// Path: common.quota
class Translations$common$quota$tr extends Translations$common$quota$en {
	Translations$common$quota$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$tr section = Translations$common$quota$section$tr._(_root);
	@override late final Translations$common$quota$filter$tr filter = Translations$common$quota$filter$tr._(_root);
	@override late final Translations$common$quota$period$tr period = Translations$common$quota$period$tr._(_root);
	@override late final Translations$common$quota$group$tr group = Translations$common$quota$group$tr._(_root);
	@override late final Translations$common$quota$metric$tr metric = Translations$common$quota$metric$tr._(_root);
	@override late final Translations$common$quota$cost$tr cost = Translations$common$quota$cost$tr._(_root);
	@override late final Translations$common$quota$cost3$tr cost3 = Translations$common$quota$cost3$tr._(_root);
	@override late final Translations$common$quota$overview$tr overview = Translations$common$quota$overview$tr._(_root);
	@override late final Translations$common$quota$usage$tr usage = Translations$common$quota$usage$tr._(_root);
	@override late final Translations$common$quota$agents$tr agents = Translations$common$quota$agents$tr._(_root);
	@override late final Translations$common$quota$agentStatus$tr agentStatus = Translations$common$quota$agentStatus$tr._(_root);
	@override late final Translations$common$quota$alert$tr alert = Translations$common$quota$alert$tr._(_root);
	@override String get backToChat => 'Sohbete dön';
	@override String get syncNow => 'Şimdi senkronize et';
	@override String generatedAt({required Object value}) => 'Güncellendi: ${value}';
	@override String get loading => 'Hesap limitleri yükleniyor…';
	@override String remaining({required Object value}) => '%${value} kaldı';
	@override String resetsIn({required Object value}) => '${value} içinde sıfırlanır';
	@override String projected({required Object value}) => 'mevcut hızda bu limit ${value} içinde dolacak';
	@override String syncedAgo({required Object value}) => '${value} önce senkronize edildi';
	@override String get refreshAccount => 'Hesabı yenile';
	@override String get syncFailed => 'Senkronizasyon başarısız';
	@override String get history => 'Geçmiş';
	@override String historyPoints({required Object value}) => '${value} okuma kaydedildi';
	@override String get historyEmpty => 'Henüz geçmiş kaydedilmedi';
	@override String get noAgents => 'Atanmış agent yok';
	@override String get noSubscription => 'Abonelik yok';
	@override String get noSubscriptionHint => 'Sağlayıcı bu hesap için aktif bir plan bildirmiyor.';
	@override late final Translations$common$quota$quality$tr quality = Translations$common$quota$quality$tr._(_root);
	@override late final Translations$common$quota$kpi$tr kpi = Translations$common$quota$kpi$tr._(_root);
	@override late final Translations$common$quota$empty$tr empty = Translations$common$quota$empty$tr._(_root);
	@override late final Translations$common$quota$settings$tr settings = Translations$common$quota$settings$tr._(_root);
	@override late final Translations$common$quota$range$tr range = Translations$common$quota$range$tr._(_root);
}

// Path: common.actions
class Translations$common$actions$tr extends Translations$common$actions$en {
	Translations$common$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'İptal';
	@override String get retry => 'Yeniden dene';
	@override String get save => 'Kaydet';
}

// Path: common.browserPane
class Translations$common$browserPane$tr extends Translations$common$browserPane$en {
	Translations$common$browserPane$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get address => 'Adres';
	@override String get back => 'Geri';
	@override String get connecting => 'Tarayıcıya bağlanıyor…';
	@override String get connectionFailed => 'Tarayıcı bağlantısı başarısız.';
	@override String couldNotLoad({required Object url}) => '${url} yüklenemedi';
	@override String get disconnected => 'Tarayıcı görünümü bağlantısı kesildi';
	@override String get enterUrl => 'URL girin';
	@override String get forward => 'İleri';
	@override String get invalidUrl => 'Geçerli bir http(s) URL’si girin';
	@override String get noAuthToken => 'Kimlik doğrulama jetonu yok.';
	@override String get openExternal => 'Sistem tarayıcısında aç';
	@override String get reload => 'Yenile';
	@override String get retry => 'Yeniden dene';
	@override String get stop => 'Durdur';
}

// Path: common.browserUse
class Translations$common$browserUse$tr extends Translations$common$browserUse$en {
	Translations$common$browserUse$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} etkin';
	@override String get cancel => 'İptal';
	@override String get close => 'Kapat';
	@override String get delete => 'Sil';
	@override String deleteDesc({required Object name}) => '${name} kalıcı olarak silinecek.';
	@override String get deleteSession => 'Oturumu sil';
	@override String get deleteTitle => 'Tarayıcı oturumu silinsin mi?';
	@override late final Translations$common$browserUse$empty$tr empty = Translations$common$browserUse$empty$tr._(_root);
	@override String get emptyStatus => 'boş';
	@override late final Translations$common$browserUse$errors$tr errors = Translations$common$browserUse$errors$tr._(_root);
	@override String get fullscreen => 'Tam ekran';
	@override String get installRuntime => 'Runtime’ı kur';
	@override String get installing => 'Kuruluyor...';
	@override String get lastAction => 'Son eylem';
	@override String get nextSnapshot => 'Aracının bir sonraki tarayıcı anlık görüntüsü burada gösterilecek.';
	@override String get noPageLoaded => 'Sayfa yüklenmedi';
	@override String get noSessions => 'Aracı tarayıcı oturumu yok.';
	@override String get none => 'Yok';
	@override String get openSettings => 'Browser ayarlarını aç';
	@override String get profile => 'Profil';
	@override String get promptLabel => 'Prompt';
	@override late final Translations$common$browserUse$prompts$tr prompts = Translations$common$browserUse$prompts$tr._(_root);
	@override String get refresh => 'Tarayıcı oturumlarını yenile';
	@override late final Translations$common$browserUse$relative$tr relative = Translations$common$browserUse$relative$tr._(_root);
	@override late final Translations$common$browserUse$runtime$tr runtime = Translations$common$browserUse$runtime$tr._(_root);
	@override String get runtimeSetup => 'Runtime kurulumu gerekli';
	@override String get selected => 'Seçili';
	@override String get sessionFallback => 'Tarayıcı oturumu';
	@override String get sessionScreenshot => 'Tarayıcı oturumu ekran görüntüsü';
	@override String get sessions => 'Oturumlar';
	@override String get status => 'Durum';
	@override String get stop => 'Durdur';
	@override String get stopSession => 'Oturumu durdur';
	@override String get subtitle => 'AI aracılarının açtığı tarayıcı oturumlarını izleyin.';
	@override String get temporary => 'Geçici';
	@override String get thisSession => 'Bu oturum';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => 'toplam ${count}';
	@override String updated({required Object time}) => 'Güncellendi: ${time}';
	@override String get waiting => 'Bekleniyor';
	@override String get waitingForScreenshot => 'Ekran görüntüsü bekleniyor';
}

// Path: common.commandPalette
class Translations$common$commandPalette$tr extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'Tümüne dön';
	@override String get backspaceHint => 'Geri dönmek için Geri tuşu';
	@override late final Translations$common$commandPalette$browseAll$tr browseAll = Translations$common$commandPalette$browseAll$tr._(_root);
	@override late final Translations$common$commandPalette$compare$tr compare = Translations$common$commandPalette$compare$tr._(_root);
	@override late final Translations$common$commandPalette$groups$tr groups = Translations$common$commandPalette$groups$tr._(_root);
	@override late final Translations$common$commandPalette$hints$tr hints = Translations$common$commandPalette$hints$tr._(_root);
	@override late final Translations$common$commandPalette$items$tr items = Translations$common$commandPalette$items$tr._(_root);
	@override late final Translations$common$commandPalette$nav$tr nav = Translations$common$commandPalette$nav$tr._(_root);
	@override String get noResults => 'Sonuç yok.';
	@override late final Translations$common$commandPalette$pages$tr pages = Translations$common$commandPalette$pages$tr._(_root);
	@override String get placeholder => 'Aramak için yazın…';
	@override String searchPagePlaceholder({required Object page}) => '${page} içinde ara…';
	@override String get title => 'Komut paleti';
}

// Path: common.gitPanel
class Translations$common$gitPanel$tr extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} ileride';
	@override String get aheadLabel => 'ileride';
	@override String get aiSuggest => 'AI önerisi';
	@override String get aiSuggestTitle => 'AI ile commit mesajı oluştur';
	@override String get all => 'Tümü';
	@override String get allStaged => 'Tüm değişiklikler hazırlandı';
	@override String behind({required Object count}) => '${count} geride';
	@override String get behindLabel => 'geride';
	@override late final Translations$common$gitPanel$branches$tr branches = Translations$common$gitPanel$branches$tr._(_root);
	@override String get cancel => 'İptal';
	@override String changesCount({required Object count}) => 'Değişiklikler (${count})';
	@override String get clearSearch => 'Aramayı temizle';
	@override String get collapseDiff => 'Diff’i daralt';
	@override String get commit => 'Commit';
	@override String get commitChanges => 'Değişiklikleri Commit Et';
	@override String commitFiles({required Object count}) => '${count} dosyayı commit et';
	@override String get committing => 'Commit ediliyor...';
	@override late final Translations$common$gitPanel$confirmActions$tr confirmActions = Translations$common$gitPanel$confirmActions$tr._(_root);
	@override String confirmCommit({required Object count, required Object message}) => '${count} dosya şu mesajla commit edilsin mi: “${message}”?';
	@override String confirmDeleteFile({required Object file}) => 'İzlenmeyen “${file}” dosyası silinsin mi? Geri alınamaz.';
	@override String confirmDiscardFile({required Object file}) => '“${file}” üzerindeki tüm değişikliklerden vazgeçilsin mi? Geri alınamaz.';
	@override String confirmPublish({required Object branch, required Object remote}) => '“${branch}” dalı ${remote} uzak sunucusuna yayınlansın mı?';
	@override String confirmPull({required Object remote, required Object count}) => '${remote} uzak sunucusundan ${count} commit çekilsin mi?';
	@override String confirmPush({required Object remote, required Object count}) => '${remote} uzak sunucusuna ${count} commit gönderilsin mi?';
	@override String get confirmRevert => 'Son yerel commit geri alınsın mı? Commiti kaldırır ama değişiklikleri hazır durumda tutar.';
	@override late final Translations$common$gitPanel$confirmTitles$tr confirmTitles = Translations$common$gitPanel$confirmTitles$tr._(_root);
	@override String get createBranch => 'Yeni dal oluştur';
	@override String get creating => 'Oluşturuluyor...';
	@override String get delete => 'Sil';
	@override String get deleteUntracked => 'İzlenmeyen dosyayı sil';
	@override String get deselectAll => 'Tümünün seçimini kaldır';
	@override String get discard => 'Vazgeç';
	@override String get discardChanges => 'Değişikliklerden vazgeç';
	@override String get dismiss => 'Kapat';
	@override String get dismissError => 'Hatayı kapat';
	@override late final Translations$common$gitPanel$errors$tr errors = Translations$common$gitPanel$errors$tr._(_root);
	@override String get expandDiff => 'Diff’i genişlet';
	@override String get fetch => 'Fetch';
	@override String fetchTitle({required Object remote}) => '${remote} üzerinden fetch';
	@override String get fetching => 'Fetch ediliyor…';
	@override String filesSelected({required Object count}) => '${count} dosya seçildi';
	@override String get generating => 'Oluşturuluyor...';
	@override late final Translations$common$gitPanel$history$tr history = Translations$common$gitPanel$history$tr._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$tr mergeWorktree = Translations$common$gitPanel$mergeWorktree$tr._(_root);
	@override String get merging => 'Birleştiriliyor...';
	@override String get messagePlaceholder => 'Mesaj (commit için Ctrl+Enter)';
	@override late final Translations$common$gitPanel$newBranch$tr newBranch = Translations$common$gitPanel$newBranch$tr._(_root);
	@override late final Translations$common$gitPanel$newWorktree$tr newWorktree = Translations$common$gitPanel$newWorktree$tr._(_root);
	@override String get noChanges => 'Değişiklik algılanmadı';
	@override String get noChangesToCommit => 'Commit edilecek değişiklik yok';
	@override late final Translations$common$gitPanel$noCommits$tr noCommits = Translations$common$gitPanel$noCommits$tr._(_root);
	@override String get noMatchingBranches => 'Eşleşen dal yok';
	@override late final Translations$common$gitPanel$noRepo$tr noRepo = Translations$common$gitPanel$noRepo$tr._(_root);
	@override String get noStagedFiles => 'Hazırlanmış dosya yok';
	@override String get none => 'Yok';
	@override String nothingToPush({required Object remote}) => '${remote} uzak sunucusuna gönderilecek bir şey yok';
	@override String get openFile => 'Dosyayı açmak için tıklayın';
	@override String get publish => 'Yayınla';
	@override String publishTitle({required Object branch, required Object remote}) => '“${branch}” dalını ${remote} uzak sunucusuna yayınla';
	@override String get publishing => 'Yayınlanıyor…';
	@override String get pull => 'Pull';
	@override String pullCount({required Object count}) => 'Pull ${count}';
	@override String pullTitle({required Object remote, required Object count}) => '${remote} üzerinden ${count} çek';
	@override String get pulling => 'Çekiliyor…';
	@override String get push => 'Push';
	@override String pushCount({required Object count}) => 'Push ${count}';
	@override String pushTitle({required Object remote, required Object count}) => '${remote} uzak sunucusuna ${count} gönder';
	@override String get pushing => 'Gönderiliyor…';
	@override String get recentCommits => 'Son commitler';
	@override String get refresh => 'Git durumunu yenile';
	@override String get remove => 'Kaldır';
	@override late final Translations$common$gitPanel$removeWorktree$tr removeWorktree = Translations$common$gitPanel$removeWorktree$tr._(_root);
	@override String get removing => 'Kaldırılıyor...';
	@override String get revertLatest => 'Son yerel commiti geri al';
	@override String get scroll => 'Kaydır';
	@override String get searchBranches => 'Dal ara...';
	@override String get selectAll => 'Tümünü seç';
	@override String get selectProject => 'Kaynak denetimini görüntülemek için bir proje seçin';
	@override String selectedOf({required Object total, required Object selected}) => '${total} dosyadan ${selected} seçildi';
	@override String selectedOfMobile({required Object total, required Object selected}) => '${total} içinden ${selected} seçildi';
	@override String get sideBySide => 'Yan yana';
	@override String get stageAll => 'Tümünü hazırla';
	@override String get stageHunk => 'Bu parçayı hazırla';
	@override String staged({required Object count}) => 'Hazırlananlar (${count})';
	@override late final Translations$common$gitPanel$status$tr status = Translations$common$gitPanel$status$tr._(_root);
	@override String get statusGuide => 'Dosya Durumu Kılavuzu';
	@override String get switchScroll => 'Yatay kaydırmaya geç';
	@override String get switchSplit => 'Yan yana görünüme geç';
	@override String get switchUnified => 'Birleşik görünüme geç';
	@override String get switchWrap => 'Metin kaydırmaya geç';
	@override String get unified => 'Birleşik';
	@override String get unstageAll => 'Tüm hazırlıkları geri al';
	@override String get unstageHunk => 'Bu parçanın hazırlığını geri al';
	@override String get upToDate => 'Güncel';
	@override String upToDateWith({required Object remote}) => '${remote} ile güncel';
	@override String get viewAll => 'Tümünü gör';
	@override String get viewsAria => 'Kaynak denetimi görünümleri';
	@override late final Translations$common$gitPanel$worktrees$tr worktrees = Translations$common$gitPanel$worktrees$tr._(_root);
	@override String get wrap => 'Kaydır';
	@override late final Translations$common$gitPanel$tabs$tr tabs = Translations$common$gitPanel$tabs$tr._(_root);
}

// Path: common.sessions
class Translations$common$sessions$tr extends Translations$common$sessions$en {
	Translations$common$sessions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'Oturumu yeniden adlandır';
}

// Path: common.projects
class Translations$common$projects$tr extends Translations$common$projects$en {
	Translations$common$projects$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Yeni oturum';
}

// Path: common.codeBlock
class Translations$common$codeBlock$tr extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => 'Satırları kaydır';
	@override String get noWrap => 'Kaydırma yok';
}

// Path: common.update
class Translations$common$update$tr extends Translations$common$update$en {
	Translations$common$update$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => 'Güncelleme mevcut · v${version}';
	@override String confirm({required Object version}) => 'v${version} sürümüne güncellensin mi? Sunucu kendini günceller ve yeniden başlatır — etkin oturumlar kesintiye uğrayacak.';
	@override String get downloading => 'Güncelleme indiriliyor ve uygulanıyor…';
	@override String get restarting => 'Sunucu yeniden başlatılıyor — bu biraz sürer…';
	@override String done({required Object version}) => 'v${version} sürümüne güncellendi. Yeni paketi almak için uygulamayı yeniden yükle.';
	@override String get manualRestart => 'Güncelleme uygulandı ancak sunucu kendiliğinden yeniden başlamadı — tamamlamak için elle yeniden başlat.';
	@override String get failed => 'Güncelleme başarısız oldu.';
	@override String get failedTitle => 'Güncelleme başarısız';
	@override String appConfirm({required Object version}) => 'ddagent v${version} bu cihaza kurulsun mu? Android ilk seferde ddagent\'tan yüklemeye izin vermenizi ister.';
	@override String get appPermission => 'ddagent için “Bilinmeyen uygulamaları yükle” iznini verin, sonra tekrar Güncelle\'ye dokunun.';
}

// Path: settings.changelog
class Translations$settings$changelog$tr extends Translations$settings$changelog$en {
	Translations$settings$changelog$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Değişiklik günlüğü';
	@override String get loading => 'Yükleniyor…';
	@override String get empty => 'Gösterilecek sürüm yok';
	@override String get current => 'mevcut';
	@override String get kNew => 'yeni';
}

// Path: settings.server
class Translations$settings$server$tr extends Translations$settings$server$en {
	Translations$settings$server$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sunucu';
	@override String get description => 'ddagent sürecini yeniden başlatır — güncelleme sonrası veya takılma durumunda kullanışlıdır.';
	@override String get restart => 'Yeniden başlat';
	@override String get restartConfirm => 'ddagent sunucusu yeniden başlatılsın mı? Aktif oturumlar kesintiye uğrayacak.';
	@override String get restarting => 'Yeniden başlatılıyor… sunucu döndüğünde sayfa yenilenecek.';
	@override String get restartFailed => 'Yeniden başlatma başarısız';
	@override String get unsupported => 'Yeniden başlatma yalnızca sunucu servis yöneticisi altında çalışırken kullanılabilir.';
	@override String get ok => 'Tamam';
}

// Path: settings.updates
class Translations$settings$updates$tr extends Translations$settings$updates$en {
	Translations$settings$updates$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Uygulama güncellemeleri';
	@override String get description => 'GitHub\'da daha yeni bir masaüstü sürümünü kontrol eder. Yeni sürümler otomatik indirilir ve çıkışta kurulur.';
	@override String get check => 'Güncellemeleri denetle';
	@override String get checking => 'Denetleniyor…';
	@override String upToDate({required Object version}) => 'En güncel sürümü kullanıyorsunuz (v${version}).';
	@override String available({required Object version}) => 'v${version} güncellemesi bulundu — arka planda indiriliyor; ddagent kapanırken kurulacak.';
	@override String downloaded({required Object version}) => 'v${version} güncellemesi indirildi — kurmak için ddagent\'ı kapatıp yeniden başlatın.';
	@override String get unavailable => 'Güncelleme denetimi yalnızca paketlenmiş masaüstü sürümlerinde kullanılabilir.';
	@override String error({required Object message}) => 'Güncelleme denetimi başarısız: ${message}';
	@override String get errorGeneric => 'Güncelleme denetimi başarısız.';
}

// Path: settings.tabs
class Translations$settings$tabs$tr extends Translations$settings$tabs$en {
	Translations$settings$tabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get account => 'Hesap';
	@override String get permissions => 'İzinler';
	@override String get mcpServers => 'MCP Sunucuları';
	@override String get appearance => 'Görünüm';
	@override String get skills => 'Yetenekler';
}

// Path: settings.account
class Translations$settings$account$tr extends Translations$settings$account$en {
	Translations$settings$account$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hesap';
	@override String get language => 'Dil';
	@override String get languageLabel => 'Görüntüleme Dili';
	@override String get languageDescription => 'Arayüz için tercih ettiğin dili seç';
	@override String get username => 'Kullanıcı Adı';
	@override String get email => 'E-posta';
	@override String get profile => 'Profil';
	@override String get changePassword => 'Şifreyi Değiştir';
}

// Path: settings.mcp
class Translations$settings$mcp$tr extends Translations$settings$mcp$en {
	Translations$settings$mcp$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP Sunucuları';
	@override String get addServer => 'Sunucu Ekle';
	@override String get editServer => 'Sunucuyu Düzenle';
	@override String get deleteServer => 'Sunucuyu Sil';
	@override String get serverName => 'Sunucu Adı';
	@override String get serverType => 'Sunucu Türü';
	@override String get config => 'Yapılandırma';
	@override String get testConnection => 'Bağlantıyı Test Et';
	@override String get status => 'Durum';
	@override String get connected => 'Bağlı';
	@override String get disconnected => 'Bağlantı kesildi';
	@override late final Translations$settings$mcp$scope$tr scope = Translations$settings$mcp$scope$tr._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$tr extends Translations$settings$appearance$en {
	Translations$settings$appearance$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Görünüm';
	@override String get theme => 'Tema';
	@override String get codeEditor => 'Kod Editörü';
	@override String get editorTheme => 'Editör Teması';
	@override String get wordWrap => 'Kelime Kaydırma';
	@override String get showMinimap => 'Minimap\'i Göster';
	@override String get lineNumbers => 'Satır Numaraları';
	@override String get fontSize => 'Yazı Tipi Boyutu';
	@override late final Translations$settings$appearance$themeModes$tr themeModes = Translations$settings$appearance$themeModes$tr._(_root);
}

// Path: settings.actions
class Translations$settings$actions$tr extends Translations$settings$actions$en {
	Translations$settings$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => 'Değişiklikleri Kaydet';
	@override String get resetToDefaults => 'Varsayılanlara Döndür';
	@override String get cancelChanges => 'Değişiklikleri İptal Et';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$tr extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hızlı Ayarlar';
	@override late final Translations$settings$quickSettings$sections$tr sections = Translations$settings$quickSettings$sections$tr._(_root);
	@override String get darkMode => 'Koyu Mod';
	@override String get showRawParameters => 'Ham parametreleri göster';
	@override String get showThinking => 'Düşünmeyi göster';
	@override String get sendByCtrlEnter => 'Ctrl+Enter ile gönder';
	@override String get sendByCtrlEnterDescription => 'Etkinleştirildiğinde, Ctrl+Enter\'a basmak yalnız Enter yerine mesajı gönderir. IME (girdi metot düzenleyici) kullananlar için yanlışlıkla göndermeyi önler.';
	@override late final Translations$settings$quickSettings$dragHandle$tr dragHandle = Translations$settings$quickSettings$dragHandle$tr._(_root);
	@override String get sendWithCtrlEnter => 'Ctrl+Enter ile gönder';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$tr extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal Kısayolları';
	@override String get sectionKeys => 'Tuşlar';
	@override String get sectionNavigation => 'Gezinme';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => 'Yukarı Ok';
	@override String get arrowDown => 'Aşağı Ok';
	@override String get scrollDown => 'Aşağı Kaydır';
	@override late final Translations$settings$terminalShortcuts$handle$tr handle = Translations$settings$terminalShortcuts$handle$tr._(_root);
	@override String get killTitle => 'Çalışan süreci sonlandır (Ctrl+C)';
	@override String get paste => 'Yapıştır';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$tr extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Ayarlar';
	@override String get agents => 'Ajanlar';
	@override String get orchestration => 'Orkestrasyon';
	@override String get appearance => 'Görünüm';
	@override String get git => 'Git';
	@override String get apiTokens => 'API ve Token\'lar';
	@override String get models => 'Modeller';
	@override String get tasks => 'Görevler';
	@override String get notifications => 'Bildirimler';
	@override String get about => 'Hakkında';
	@override String get workspaces => 'Çalışma alanları';
	@override String get browser => 'Browser';
	@override String get tools => 'Araçlar';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$tr extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$tr enable = Translations$settings$orchestration$enable$tr._(_root);
	@override late final Translations$settings$orchestration$pool$tr pool = Translations$settings$orchestration$pool$tr._(_root);
	@override late final Translations$settings$orchestration$tiers$tr tiers = Translations$settings$orchestration$tiers$tr._(_root);
	@override late final Translations$settings$orchestration$rules$tr rules = Translations$settings$orchestration$rules$tr._(_root);
	@override late final Translations$settings$orchestration$planner$tr planner = Translations$settings$orchestration$planner$tr._(_root);
	@override late final Translations$settings$orchestration$execution$tr execution = Translations$settings$orchestration$execution$tr._(_root);
	@override late final Translations$settings$orchestration$save$tr save = Translations$settings$orchestration$save$tr._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$tr extends Translations$settings$notifications$en {
	Translations$settings$notifications$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bildirimler';
	@override String get description => 'Hangi bildirim etkinliklerini alacağını kontrol et.';
	@override late final Translations$settings$notifications$webPush$tr webPush = Translations$settings$notifications$webPush$tr._(_root);
	@override late final Translations$settings$notifications$device$tr device = Translations$settings$notifications$device$tr._(_root);
	@override late final Translations$settings$notifications$sound$tr sound = Translations$settings$notifications$sound$tr._(_root);
	@override late final Translations$settings$notifications$events$tr events = Translations$settings$notifications$events$tr._(_root);
	@override late final Translations$settings$notifications$desktop$tr desktop = Translations$settings$notifications$desktop$tr._(_root);
	@override late final Translations$settings$notifications$channels$tr channels = Translations$settings$notifications$channels$tr._(_root);
	@override String get unpair => 'Eşleştirmeyi kaldır';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$tr extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$tr darkMode = Translations$settings$appearanceSettings$darkMode$tr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$tr codeEditor = Translations$settings$appearanceSettings$codeEditor$tr._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$tr terminal = Translations$settings$appearanceSettings$terminal$tr._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$tr extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$tr title = Translations$settings$mcpForm$title$tr._(_root);
	@override late final Translations$settings$mcpForm$importMode$tr importMode = Translations$settings$mcpForm$importMode$tr._(_root);
	@override late final Translations$settings$mcpForm$scope$tr scope = Translations$settings$mcpForm$scope$tr._(_root);
	@override late final Translations$settings$mcpForm$fields$tr fields = Translations$settings$mcpForm$fields$tr._(_root);
	@override late final Translations$settings$mcpForm$placeholders$tr placeholders = Translations$settings$mcpForm$placeholders$tr._(_root);
	@override late final Translations$settings$mcpForm$validation$tr validation = Translations$settings$mcpForm$validation$tr._(_root);
	@override String configDetails({required Object configFile}) => 'Yapılandırma Detayları (${configFile} dosyasından)';
	@override String projectPath({required Object path}) => 'Yol: ${path}';
	@override late final Translations$settings$mcpForm$actions$tr actions = Translations$settings$mcpForm$actions$tr._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$tr extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get success => 'Ayarlar başarıyla kaydedildi!';
	@override String get error => 'Ayarlar kaydedilemedi';
	@override String get saving => 'Kaydediliyor...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$tr extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get save => 'Ayarları Kaydet';
	@override String get cancel => 'İptal';
}

// Path: settings.git
class Translations$settings$git$tr extends Translations$settings$git$en {
	Translations$settings$git$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Git Yapılandırması';
	@override String get description => 'Commit\'ler için git kimliğini yapılandır. Bu ayarlar git config --global ile genel olarak uygulanacak';
	@override late final Translations$settings$git$name$tr name = Translations$settings$git$name$tr._(_root);
	@override late final Translations$settings$git$email$tr email = Translations$settings$git$email$tr._(_root);
	@override late final Translations$settings$git$actions$tr actions = Translations$settings$git$actions$tr._(_root);
	@override late final Translations$settings$git$status$tr status = Translations$settings$git$status$tr._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$tr extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'API Anahtarları';
	@override String get description => 'Diğer uygulamalardan harici API\'ye erişmek için API anahtarları üret.';
	@override late final Translations$settings$apiKeys$newKey$tr newKey = Translations$settings$apiKeys$newKey$tr._(_root);
	@override late final Translations$settings$apiKeys$form$tr form = Translations$settings$apiKeys$form$tr._(_root);
	@override String get newButton => 'Yeni API Anahtarı';
	@override String get empty => 'Henüz API anahtarı oluşturulmamış.';
	@override late final Translations$settings$apiKeys$list$tr list = Translations$settings$apiKeys$list$tr._(_root);
	@override String get confirmDelete => 'Bu API anahtarını silmek istediğinden emin misin?';
	@override late final Translations$settings$apiKeys$status$tr status = Translations$settings$apiKeys$status$tr._(_root);
	@override late final Translations$settings$apiKeys$github$tr github = Translations$settings$apiKeys$github$tr._(_root);
	@override String get apiDocsLink => 'API Dokümantasyonu';
	@override late final Translations$settings$apiKeys$documentation$tr documentation = Translations$settings$apiKeys$documentation$tr._(_root);
	@override String get loading => 'Yükleniyor...';
	@override late final Translations$settings$apiKeys$version$tr version = Translations$settings$apiKeys$version$tr._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$tr extends Translations$settings$tasks$en {
	Translations$settings$tasks$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'TaskMaster kurulumu kontrol ediliyor...';
	@override late final Translations$settings$tasks$notInstalled$tr notInstalled = Translations$settings$tasks$notInstalled$tr._(_root);
	@override late final Translations$settings$tasks$settings$tr settings = Translations$settings$tasks$settings$tr._(_root);
}

// Path: settings.agents
class Translations$settings$agents$tr extends Translations$settings$agents$en {
	Translations$settings$agents$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$tr authStatus = Translations$settings$agents$authStatus$tr._(_root);
	@override late final Translations$settings$agents$install$tr install = Translations$settings$agents$install$tr._(_root);
	@override late final Translations$settings$agents$update$tr update = Translations$settings$agents$update$tr._(_root);
	@override late final Translations$settings$agents$account$tr account = Translations$settings$agents$account$tr._(_root);
	@override String get connectionStatus => 'Bağlantı Durumu';
	@override late final Translations$settings$agents$login$tr login = Translations$settings$agents$login$tr._(_root);
	@override late final Translations$settings$agents$logout$tr logout = Translations$settings$agents$logout$tr._(_root);
	@override String error({required Object error}) => 'Hata: ${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$tr extends Translations$settings$permissions$en {
	Translations$settings$permissions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İzin Ayarları';
	@override late final Translations$settings$permissions$skipPermissions$tr skipPermissions = Translations$settings$permissions$skipPermissions$tr._(_root);
	@override late final Translations$settings$permissions$allowedTools$tr allowedTools = Translations$settings$permissions$allowedTools$tr._(_root);
	@override late final Translations$settings$permissions$blockedTools$tr blockedTools = Translations$settings$permissions$blockedTools$tr._(_root);
	@override late final Translations$settings$permissions$allowedCommands$tr allowedCommands = Translations$settings$permissions$allowedCommands$tr._(_root);
	@override late final Translations$settings$permissions$blockedCommands$tr blockedCommands = Translations$settings$permissions$blockedCommands$tr._(_root);
	@override late final Translations$settings$permissions$toolExamples$tr toolExamples = Translations$settings$permissions$toolExamples$tr._(_root);
	@override late final Translations$settings$permissions$shellExamples$tr shellExamples = Translations$settings$permissions$shellExamples$tr._(_root);
	@override late final Translations$settings$permissions$codex$tr codex = Translations$settings$permissions$codex$tr._(_root);
	@override late final Translations$settings$permissions$actions$tr actions = Translations$settings$permissions$actions$tr._(_root);
	@override late final Translations$settings$permissions$permissionMode$tr permissionMode = Translations$settings$permissions$permissionMode$tr._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$tr extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP Sunucuları';
	@override late final Translations$settings$mcpServers$description$tr description = Translations$settings$mcpServers$description$tr._(_root);
	@override String get addButton => 'MCP Sunucusu Ekle';
	@override String get empty => 'Yapılandırılmış MCP sunucusu yok';
	@override String get serverType => 'Tür';
	@override late final Translations$settings$mcpServers$scope$tr scope = Translations$settings$mcpServers$scope$tr._(_root);
	@override late final Translations$settings$mcpServers$config$tr config = Translations$settings$mcpServers$config$tr._(_root);
	@override late final Translations$settings$mcpServers$tools$tr tools = Translations$settings$mcpServers$tools$tr._(_root);
	@override late final Translations$settings$mcpServers$actions$tr actions = Translations$settings$mcpServers$actions$tr._(_root);
	@override late final Translations$settings$mcpServers$help$tr help = Translations$settings$mcpServers$help$tr._(_root);
	@override late final Translations$settings$mcpServers$managed$tr managed = Translations$settings$mcpServers$managed$tr._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$tr deleteConfirm = Translations$settings$mcpServers$deleteConfirm$tr._(_root);
}

// Path: settings.quota
class Translations$settings$quota$tr extends Translations$settings$quota$en {
	Translations$settings$quota$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$tr settings = Translations$settings$quota$settings$tr._(_root);
	@override late final Translations$settings$quota$empty$tr empty = Translations$settings$quota$empty$tr._(_root);
	@override late final Translations$settings$quota$quality$tr quality = Translations$settings$quota$quality$tr._(_root);
	@override String get syncFailed => 'Senkronizasyon başarısız';
	@override String get syncNow => 'Şimdi senkronize et';
}

// Path: settings.browser
class Translations$settings$browser$tr extends Translations$settings$browser$en {
	Translations$settings$browser$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'kontrol ediliyor...';
	@override String get description => 'Aracıların, Browser sekmesinden izleyebileceğiniz kontrollü Playwright tarayıcı oturumları oluşturmasına izin verin.';
	@override String get enableDescription => 'Desteklenen aracılar için Browser’ı kaydeder. Aracılar tarayıcı oturumları oluşturabilir; siz izleyebilir, durdurabilir ve silebilirsiniz.';
	@override String get enableLabel => 'Browser’ı Etkinleştir';
	@override late final Translations$settings$browser$errors$tr errors = Translations$settings$browser$errors$tr._(_root);
	@override String get installHint => 'Aracılar Browser oturumları oluşturmadan önce tarayıcı runtime’ını kurun.';
	@override String get installRuntime => 'Runtime’ı Kur';
	@override String get installed => 'kurulu';
	@override String get installing => 'Kuruluyor...';
	@override String get missing => 'eksik';
	@override String get runtimeRequired => 'Tarayıcı runtime’ı gerekli';
	@override String get statusDisabled => 'devre dışı';
	@override String get statusLabel => 'Durum';
	@override String get statusReady => 'hazır';
	@override String get statusSetupRequired => 'kurulum gerekli';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$tr extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'İptal';
	@override String get create => 'Çalışma alanı ekle';
	@override String get deleteConfirm => 'Bu çalışma alanı ddagent’tan kaldırılsın mı? Dosyaları diskte kalır.';
	@override String get deleteFailed => 'Çalışma alanı kaldırılamadı.';
	@override String get deleteTitle => 'Çalışma alanını kaldır';
	@override String get description => 'Çalışma alanları, ddagent’ın sohbet edebildiği, kod çalıştırabildiği ve gezinebildiği dizinlerdir.';
	@override String get remove => 'Çalışma alanını kaldır';
	@override String get title => 'Çalışma alanları';
	@override String get pathRequired => 'Yol gerekli';
}

// Path: settings.about
class Translations$settings$about$tr extends Translations$settings$about$en {
	Translations$settings$about$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'Projeyi destekle';
	@override String get buyMeACoffee => 'Bana kahve ısmarla';
	@override String get learnMore => 'Daha fazla bilgi';
	@override late final Translations$settings$about$pro$tr pro = Translations$settings$about$pro$tr._(_root);
	@override String get proFeatures => 'ddagent Pro Özellikleri';
	@override String get tryHosted => 'ddagent Hosted\'ı deneyin';
	@override String get versionInfo => 'Sürüm bilgisi';
	@override String get client => 'Uygulama';
	@override String get server => 'Sunucu';
	@override String get platformMobile => 'Mobil';
	@override String get platformDesktop => 'Masaüstü';
	@override String get platformWeb => 'Web';
	@override String get unknown => 'bilinmiyor';
}

// Path: sidebar.projects
class Translations$sidebar$projects$tr extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Projeler';
	@override String get newProject => 'Yeni Proje';
	@override String get deleteProject => 'Projeyi Kaldır';
	@override String get renameProject => 'Projeyi Yeniden Adlandır';
	@override String get noProjects => 'Proje bulunamadı';
	@override String get loadingProjects => 'Projeler yükleniyor...';
	@override String get searchPlaceholder => 'Projelerde ara...';
	@override String get projectNamePlaceholder => 'Proje adı';
	@override String get starred => 'Yıldızlı';
	@override String get all => 'Tümü';
	@override String get untitledSession => 'Adsız Oturum';
	@override String get newSession => 'Yeni Oturum';
	@override String get codexSession => 'Codex Oturumu';
	@override String get fetchingProjects => 'Claude projelerin ve oturumların getiriliyor';
	@override String get projects => 'proje';
	@override String get noMatchingProjects => 'Eşleşen proje yok';
	@override String get tryDifferentSearch => 'Arama terimini değiştirmeyi dene';
	@override String get runClaudeCli => 'Başlamak için bir proje dizininde Claude CLI çalıştır';
}

// Path: sidebar.app
class Translations$sidebar$app$tr extends Translations$sidebar$app$en {
	Translations$sidebar$app$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ddagent';
	@override String get subtitle => 'AI kodlama asistanı arayüzü';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$tr extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oturumlar';
	@override String get newSession => 'Yeni Oturum';
	@override String get deleteSession => 'Oturumu Sil';
	@override String get renameSession => 'Oturumu Yeniden Adlandır';
	@override String get noSessions => 'Henüz oturum yok';
	@override String get loadingSessions => 'Oturumlar yükleniyor...';
	@override String get unnamed => 'Adsız';
	@override String get loading => 'Yükleniyor...';
	@override String get showMore => 'Daha fazla oturum göster';
	@override String get selectMode => 'Seç';
	@override String get selectAll => 'Tümünü seç';
	@override String archiveSelected({required Object count}) => 'Arşivle (${count})';
	@override String deleteSelected({required Object count}) => 'Sil (${count})';
	@override String get cancelSelection => 'Seçimi iptal et';
	@override String get toggleSelection => 'Oturum seçimini aç/kapat';
	@override String get selectionToolbar => 'Oturum seçim eylemleri';
	@override String get options => 'Oturum seçenekleri';
	@override String get pinSession => 'Oturumu sabitle';
	@override String get unpinSession => 'Oturum sabitlemesini kaldır';
	@override String get pinned => 'Sabitlenmiş oturum';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} seçildi',
		other: '${count} seçildi',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$tr extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => 'Ortamları Görüntüle';
	@override String get hideSidebar => 'Kenar çubuğunu gizle';
	@override String get createProject => 'Yeni proje oluştur';
	@override String get refresh => 'Projeleri ve oturumları yenile (Ctrl+R)';
	@override String get renameProject => 'Projeyi yeniden adlandır (F2)';
	@override String get deleteProject => 'Projeyi kenar çubuğundan kaldır (Delete)';
	@override String get addToFavorites => 'Favorilere ekle';
	@override String get removeFromFavorites => 'Favorilerden çıkar';
	@override String get editSessionName => 'Oturum adını elle düzenle';
	@override String get deleteSession => 'Bu oturumu kalıcı olarak sil';
	@override String get activeSessionIndicator => 'Yakın zamanda etkin oturum (son 10 dakika)';
	@override String get save => 'Kaydet';
	@override String get cancel => 'İptal';
	@override String get clearSearch => 'Aramayı temizle';
	@override String get openCommandPalette => 'Komut paletini aç';
	@override String get attentionRequiredIndicator => 'Oturum ilgi bekliyor';
	@override String get openSessions => 'Oturumlara göz at';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$tr extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get chat => 'Sohbet';
	@override String get files => 'Dosyalar';
	@override String get git => 'Git';
	@override String get terminal => 'Terminal';
	@override String get tasks => 'Görevler';
}

// Path: sidebar.actions
class Translations$sidebar$actions$tr extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Yenile';
	@override String get settings => 'Ayarlar';
	@override String get collapseAll => 'Tümünü Daralt';
	@override String get expandAll => 'Tümünü Genişlet';
	@override String get cancel => 'İptal';
	@override String get save => 'Kaydet';
	@override String get delete => 'Sil';
	@override String get rename => 'Yeniden Adlandır';
	@override String get joinCommunity => 'Topluluğa Katıl';
	@override String get reportIssue => 'Sorun Bildir';
	@override String get starOnGithub => 'GitHub\'da Yıldızla';
	@override String get buyMeACoffee => 'Bana kahve ısmarla';
}

// Path: sidebar.branding
class Translations$sidebar$branding$tr extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'Açık Kaynak';
}

// Path: sidebar.status
class Translations$sidebar$status$tr extends Translations$sidebar$status$en {
	Translations$sidebar$status$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get active => 'Aktif';
	@override String get inactive => 'Pasif';
	@override String get thinking => 'Düşünüyor...';
	@override String get error => 'Hata';
	@override String get aborted => 'Durduruldu';
	@override String get unknown => 'Bilinmiyor';
}

// Path: sidebar.time
class Translations$sidebar$time$tr extends Translations$sidebar$time$en {
	Translations$sidebar$time$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'Az önce';
	@override String get oneMinuteAgo => '1 dakika önce';
	@override String minutesAgo({required Object count}) => '${count} dakika önce';
	@override String get oneHourAgo => '1 saat önce';
	@override String hoursAgo({required Object count}) => '${count} saat önce';
	@override String get oneDayAgo => '1 gün önce';
	@override String daysAgo({required Object count}) => '${count} gün önce';
}

// Path: sidebar.messages
class Translations$sidebar$messages$tr extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => 'Bunu silmek istediğinden emin misin?';
	@override String get renameSuccess => 'Yeniden adlandırma başarılı';
	@override String get deleteSuccess => 'Silme başarılı';
	@override String get errorOccurred => 'Bir hata oluştu';
	@override String get deleteSessionConfirm => 'Bu oturumu silmek istediğinden emin misin? Bu işlem geri alınamaz.';
	@override String get deleteProjectConfirm => 'Bu proje kenar çubuğundan kaldırılsın mı? Proje dosyaların, bellek verilerin ve oturum verilerin silinmeyecek.';
	@override String get enterProjectPath => 'Lütfen bir proje yolu gir';
	@override String get deleteSessionFailed => 'Oturum silinemedi. Lütfen tekrar dene.';
	@override String get deleteSessionError => 'Oturum silinirken hata oluştu. Lütfen tekrar dene.';
	@override String get renameSessionFailed => 'Oturum yeniden adlandırılamadı. Lütfen tekrar dene.';
	@override String get renameSessionError => 'Oturum yeniden adlandırılırken hata oluştu. Lütfen tekrar dene.';
	@override String get deleteProjectFailed => 'Proje kaldırılamadı. Lütfen tekrar dene.';
	@override String get deleteProjectError => 'Proje kaldırılırken hata oluştu. Lütfen tekrar dene.';
	@override String get createProjectFailed => 'Proje oluşturulamadı. Lütfen tekrar dene.';
	@override String get createProjectError => 'Proje oluşturulurken hata oluştu. Lütfen tekrar dene.';
	@override String get updateProjectError => 'Proje güncellenirken hata oluştu. Lütfen tekrar dene.';
	@override String get refreshError => 'Yenileme başarısız. Lütfen tekrar dene.';
	@override String get restoreProjectFailed => 'Proje geri yüklenemedi. Lütfen tekrar dene.';
	@override String get restoreProjectError => 'Proje geri yüklenirken hata oluştu. Lütfen tekrar dene.';
	@override String get restoreSessionFailed => 'Oturum geri yüklenemedi. Lütfen tekrar dene.';
	@override String get restoreSessionError => 'Oturum geri yüklenirken hata oluştu. Lütfen tekrar dene.';
	@override String get changeWorkspaceFailed => 'Çalışma alanı değiştirilemedi. Lütfen tekrar dene.';
	@override String get changeWorkspaceError => 'Çalışma alanı değiştirilirken hata. Lütfen tekrar dene.';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} oturum silinemedi. Lütfen tekrar dene.',
		other: '${count} oturum silinemedi. Lütfen tekrar dene.',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$tr extends Translations$sidebar$version$en {
	Translations$sidebar$version$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'Güncelleme mevcut';
	@override String get restartRequired => 'Güncelleme yüklendi — uygulamak için sunucuyu yeniden başlatın';
	@override String get updateNow => 'Şimdi güncelle';
	@override String updateConfirm({required Object version}) => 'ddagent v${version} sürümüne güncellensin mi? En yeni kod çekilip derlenecek ve sunucu yeniden başlatılacak — etkin oturumlar kesintiye uğrar.';
	@override String get updating => 'Güncelleniyor… birkaç dakika sürebilir';
	@override String get restarting => 'Güncelleme yüklendi — yeniden başlatılıyor…';
	@override String get updateFailed => 'Güncelleme başarısız';
	@override String get releaseNotes => 'Sürüm notları';
}

// Path: sidebar.search
class Translations$sidebar$search$tr extends Translations$sidebar$search$en {
	Translations$sidebar$search$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'Projeler';
	@override String get modeConversations => 'Konuşmalar';
	@override String get conversationsPlaceholder => 'Konuşmalarda ara...';
	@override String get searching => 'Aranıyor...';
	@override String get sessionTitles => 'Oturum başlıkları';
	@override String get conversationContents => 'Konuşma içerikleri';
	@override String get noResults => 'Sonuç bulunamadı';
	@override String get tryDifferentQuery => 'Farklı bir arama sorgusu dene';
	@override String get modeRunning => 'Çalışıyor';
	@override String get archiveOnly => 'Arşiv';
	@override String get runningTooltip => 'Çalışan oturumlar';
	@override String get archiveOnlyTooltip => 'Yalnızca arşiv';
	@override String runningCount({required Object count}) => '${count} etkin';
	@override String get viewMenu => 'Görünüm';
	@override String get backToProjects => 'Projelere dön';
	@override String get archivedPlaceholder => 'Arşivlenen oturumlarda ara...';
	@override String get runningPlaceholder => 'Çalışan oturumlarda ara...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} eşleşme',
		other: '${count} eşleşme',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} proje tarandı',
		other: '${count} proje tarandı',
	);
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$tr extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'Projeyi Kaldır';
	@override String get deleteSession => 'Oturumu Sil';
	@override String get confirmDelete => 'Ne yapmak istersin:';
	@override String get removeFromSidebar => 'Yalnızca kenar çubuğundan kaldır';
	@override String get deleteAllData => 'Tüm veriyi kalıcı olarak sil';
	@override String get allConversationsDeleted => 'Proje kenar çubuğundan kaldırılacak. Dosyaların, bellek verilerin ve oturum verilerin korunacak.';
	@override String get cannotUndo => 'Projeyi sonra tekrar ekleyebilirsin.';
	@override String get bulkDeleteSessionsDescription => 'Arşivleme, seçili oturumları aktif listeden gizlerken geçmişlerini korur.';
	@override String get archiveSession => 'Oturumu arşivle';
	@override String get archiveSessionNotice => 'Arşivleme, oturumu aktif listeden çıkarırken geçmişini korur.';
	@override String get archivedSessionNotice => 'Bu oturum zaten arşivli. Gizli tutabilir veya kalıcı olarak silebilirsin.';
	@override String get deleteSessionNotice => 'Bu, oturumu ve transkriptini kalıcı olarak kaldırır. Bu işlem geri alınamaz.';
	@override String get deleteSessionPermanently => 'Kalıcı olarak sil';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: 'Bu proje ${count} konuşma içeriyor.',
		other: 'Bu proje ${count} konuşma içeriyor.',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: 'Seçili oturumu yönet',
		other: '${count} seçili oturumu yönet',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: 'Oturumu arşivle',
		other: '${count} oturumu arşivle',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$tr extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get activeNow => 'Şu anda aktif';
	@override String get recent => 'Son kullanılanlar';
	@override String get today => 'Bugün';
	@override String get yesterday => 'Dün';
	@override String get thisWeek => 'Bu hafta';
	@override String showMore({required Object count}) => '${count} tane daha göster';
	@override String get showLess => 'Daha az göster';
}

// Path: sidebar.panel
class Translations$sidebar$panel$tr extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get open => 'Panel';
	@override String get newChat => 'Yeni sohbet';
	@override String get navigation => 'Gezinme';
	@override String get sessions => 'Oturumlar';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$tr extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oturum çalışma alanını değiştir';
	@override String get description => 'Agent sonraki adımlarını bu dizinde çalıştırır. Mevcut oturum geçmişi korunur.';
	@override String get pathLabel => 'Çalışma alanı yolu';
	@override String get pathRequired => 'Çalışma alanı yolu gerekli.';
	@override String get submit => 'Çalışma alanını değiştir';
	@override String get saving => 'Değiştiriliyor…';
	@override String get changeAction => 'Çalışma alanını değiştir';
}

// Path: sidebar.recent
class Translations$sidebar$recent$tr extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Son sohbetler';
	@override String get emptyTitle => 'Henüz sohbet yok';
	@override String get emptyDescription => 'En son güncellenen sohbetlerin burada görünecek.';
	@override String get loadFailed => 'Son sohbetler yüklenemedi';
	@override String get loadMore => 'Daha eski sohbetleri yükle';
	@override String get loadingMore => 'Daha fazla yükleniyor...';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$tr extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get board => 'Aracı Panosu';
	@override String get files => 'Dosyalar';
	@override String get git => 'Kaynak Denetimi';
	@override String get tasks => 'Görevler';
	@override String get usage => 'Kota ve Kullanım';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$tr extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI yapılandırılmamış';
	@override String get description => 'TaskMaster, karmaşık projeleri AI destekli yardımla yönetilebilir görevlere böler';
	@override String get whatIsTitle => '🎯 TaskMaster nedir?';
	@override late final Translations$tasks$notConfigured$features$tr features = Translations$tasks$notConfigured$features$tr._(_root);
	@override String get initializeButton => 'TaskMaster AI\'yi Başlat';
	@override String get writePrdFirst => 'Önce PRD yaz';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$tr extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster\'a Başlarken';
	@override String get subtitle => 'TaskMaster hazır! Sıradaki adımların:';
	@override late final Translations$tasks$gettingStarted$steps$tr steps = Translations$tasks$gettingStarted$steps$tr._(_root);
	@override String get tip => '💡 İpucu: TaskMaster\'ın AI destekli görev üretiminden en iyi şekilde faydalanmak için bir PRD ile başla';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$tr extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster Kurulumu';
	@override String subtitle({required Object projectName}) => '${projectName} için interaktif CLI';
	@override String get willStart => 'TaskMaster başlatma otomatik olarak başlayacak';
	@override String get completed => 'TaskMaster kurulumu tamamlandı! Bu pencereyi kapatabilirsin.';
	@override String get closeButton => 'Kapat';
	@override String get closeContinueButton => 'Kapat ve Devam Et';
	@override String get closeTitle => 'Kapat';
	@override String get description => 'Bu projede bir .taskmaster klasörü oluşturur. Harici araç veya API anahtarı gerekmez — görevler yerel olarak saklanır.';
	@override String get initializeButton => 'Başlat';
	@override String get initializing => 'Başlatılıyor...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$tr extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster\'a Başlarken';
	@override String get subtitle => 'Verimli görev yönetimi için rehberin';
	@override late final Translations$tasks$helpGuide$examples$tr examples = Translations$tasks$helpGuide$examples$tr._(_root);
	@override String get moreExamples => 'Daha fazla örnek ve kullanım deseni →';
	@override late final Translations$tasks$helpGuide$proTips$tr proTips = Translations$tasks$helpGuide$proTips$tr._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$tr learnMore = Translations$tasks$helpGuide$learnMore$tr._(_root);
	@override String get closeTitle => 'Kapat';
}

// Path: tasks.search
class Translations$tasks$search$tr extends Translations$tasks$search$en {
	Translations$tasks$search$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Görevlerde ara...';
}

// Path: tasks.filters
class Translations$tasks$filters$tr extends Translations$tasks$filters$en {
	Translations$tasks$filters$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get button => 'Filtreler';
	@override String get status => 'Durum';
	@override String get priority => 'Öncelik';
	@override String get sortBy => 'Sıralama';
	@override String get allStatuses => 'Tüm Durumlar';
	@override String get allPriorities => 'Tüm Öncelikler';
	@override String showing({required Object total, required Object filtered}) => '${total} görevin ${filtered} tanesi gösteriliyor';
	@override String get clearFilters => 'Filtreleri Temizle';
}

// Path: tasks.sort
class Translations$tasks$sort$tr extends Translations$tasks$sort$en {
	Translations$tasks$sort$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'Durum';
	@override String get priority => 'Öncelik';
	@override String get idAsc => 'ID (Artan)';
	@override String get idDesc => 'ID (Azalan)';
	@override String get titleAsc => 'Başlık (A-Z)';
	@override String get titleDesc => 'Başlık (Z-A)';
	@override String get statusAsc => 'Durum (Önce Bekleyen)';
	@override String get statusDesc => 'Durum (Önce Tamamlanan)';
	@override String get priorityAsc => 'Öncelik (Önce Yüksek)';
	@override String get priorityDesc => 'Öncelik (Önce Düşük)';
}

// Path: tasks.views
class Translations$tasks$views$tr extends Translations$tasks$views$en {
	Translations$tasks$views$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'Kanban görünümü';
	@override String get list => 'Liste görünümü';
	@override String get grid => 'Izgara görünümü';
}

// Path: tasks.kanban
class Translations$tasks$kanban$tr extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 Yapılacak';
	@override String get inProgress => '🚀 Sürüyor';
	@override String get review => '👀 İnceleme';
	@override String get done => '✅ Tamamlandı';
	@override String get blocked => '🚫 Engellendi';
	@override String get deferred => '⏳ Ertelendi';
	@override String get cancelled => '❌ İptal Edildi';
	@override String get noTasksYet => 'Henüz görev yok';
	@override String get tasksWillAppear => 'Görevler burada görünecek';
	@override String get moveTasksHere => 'Başlayan görevleri buraya taşı';
	@override String get completedTasksHere => 'Tamamlanan görevler burada görünür';
	@override String get statusTasksHere => 'Bu durumdaki görevler burada görünecek';
}

// Path: tasks.buttons
class Translations$tasks$buttons$tr extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get help => 'TaskMaster Başlangıç Rehberi';
	@override String get prds => 'PRD\'ler';
	@override String get addPRD => 'PRD Ekle';
	@override String get addTask => 'Görev Ekle';
	@override String get createNewPRD => 'Yeni PRD Oluştur';
	@override String prdsAvailable({required Object count}) => '${count} PRD mevcut';
}

// Path: tasks.prd
class Translations$tasks$prd$tr extends Translations$tasks$prd$en {
	Translations$tasks$prd$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => 'Değişiklik: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String fileExistsMessage({required Object name}) => '"${name}" adlı bir PRD zaten var. Üzerine yazmak istiyor musunuz?';
	@override String get fileExistsTitle => 'Dosya zaten var';
	@override String get newFile => 'yeni dosya';
	@override String get parse => 'PRD\'yi ayrıştır';
	@override String get template => 'Şablon';
	@override String get fileNameHint => 'dosya adı (ör. prd.txt)';
	@override String get saved => 'PRD kaydedildi';
	@override String get tasksGenerated => 'PRD\'den görevler oluşturuldu';
}

// Path: tasks.statuses
class Translations$tasks$statuses$tr extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Beklemede';
	@override String get inProgress => 'Sürüyor';
	@override String get done => 'Tamamlandı';
	@override String get blocked => 'Engellendi';
	@override String get deferred => 'Ertelendi';
	@override String get cancelled => 'İptal Edildi';
	@override String get review => 'İnceleme';
}

// Path: tasks.priorities
class Translations$tasks$priorities$tr extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get high => 'Yüksek';
	@override String get medium => 'Orta';
	@override String get low => 'Düşük';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$tr extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Filtrelerine uygun görev yok';
	@override String get description => 'Arama veya filtre kriterlerini değiştirmeyi dene.';
}

// Path: tasks.board
class Translations$tasks$board$tr extends Translations$tasks$board$en {
	Translations$tasks$board$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Agent Panosu';
	@override String get subtitle => 'Bir kartı Hazır’a taşı, agent üstlenir. Oturumunu açmak için karta tıkla.';
	@override String get newCard => 'Yeni kart';
	@override String get addCard => 'Kart ekle';
	@override String get refresh => 'Yenile';
	@override late final Translations$tasks$board$empty$tr empty = Translations$tasks$board$empty$tr._(_root);
	@override late final Translations$tasks$board$columns$tr columns = Translations$tasks$board$columns$tr._(_root);
	@override late final Translations$tasks$board$card$tr card = Translations$tasks$board$card$tr._(_root);
	@override late final Translations$tasks$board$dialog$tr dialog = Translations$tasks$board$dialog$tr._(_root);
	@override String get noProject => 'Önce bir proje ekle, sonra onun için kartlar oluştur.';
	@override String get projectLabel => 'Proje';
	@override String get backToChat => 'Sohbete dön';
	@override late final Translations$tasks$board$agent$tr agent = Translations$tasks$board$agent$tr._(_root);
	@override late final Translations$tasks$board$deleteConfirm$tr deleteConfirm = Translations$tasks$board$deleteConfirm$tr._(_root);
	@override String get project => 'Proje';
}

// Path: tasks.card
class Translations$tasks$card$tr extends Translations$tasks$card$en {
	Translations$tasks$card$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => 'Bağlı olduğu: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'Görev ${id}';
	@override String get highPriority => 'Yüksek öncelik';
	@override String get lowPriority => 'Düşük öncelik';
	@override String get mediumPriority => 'Orta öncelik';
	@override String get noPriority => 'Öncelik ayarlanmadı';
	@override String parentTask({required Object id}) => 'Görev ${id}';
	@override String get progressLabel => 'İlerleme:';
	@override String progressTooltip({required Object total, required Object completed}) => '${total} alt görevden ${completed} tanesi tamamlandı';
	@override String get runTask => 'Görevi çalıştır';
	@override String runTaskAria({required Object id}) => 'Görev ${id} çalıştır';
	@override String statusTooltip({required Object status}) => 'Durum: ${status}';
	@override String taskIdTitle({required Object id}) => 'Görev ID: ${id}';
	@override String get taskInProgress => 'Görev devam ediyor';
}

// Path: tasks.createTask
class Translations$tasks$createTask$tr extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'İptal';
	@override String get descriptionLabel => 'Açıklama';
	@override String get descriptionPlaceholder => 'İsteğe bağlı ayrıntılar';
	@override String get error => 'Görev eklenemedi';
	@override String get priorityLabel => 'Öncelik';
	@override String get submit => 'Görev Ekle';
	@override String get submitting => 'Ekleniyor...';
	@override String get title => 'Görev Ekle';
	@override String get titleLabel => 'Başlık';
	@override String get titlePlaceholder => 'Ne yapılması gerekiyor?';
}

// Path: tasks.list
class Translations$tasks$list$tr extends Translations$tasks$list$en {
	Translations$tasks$list$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => 'Tamamlandı (yeniden açmak için tıklayın)';
	@override String get inProgressComplete => 'Devam ediyor (tamamlamak için tıklayın)';
	@override String get markCompleted => 'Tamamlandı olarak işaretle';
	@override String toggleStatusAria({required Object id}) => 'Görev ${id} durumunu değiştir';
	@override String get markDone => 'Tamamlandı olarak işaretle';
	@override String get reopen => 'Yeniden aç';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$tr extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'Tüm görevler tamamlandı';
	@override String get feature1 => '- Bağımlılıklar ve alt görevlerle AI destekli görev yönetimi.';
	@override String get feature2 => '- Daha hızlı proje başlangıcı için PRD tabanlı görev oluşturma.';
	@override String get feature3 => '- Günlük işler için kanban ve liste görünümleri.';
	@override String get hideDetails => 'Ayrıntıları gizle';
	@override String get initialize => 'Başlat';
	@override String get noPending => 'Bekleyen görev yok';
	@override String get notConfigured => 'TaskMaster AI yapılandırılmamış';
	@override String get review => 'İncele';
	@override String get startTask => 'Görevi Başlat';
	@override String taskId({required Object id}) => 'Görev ${id}';
	@override String get viewAll => 'Tüm görevleri görüntüle';
	@override String get viewDetails => 'Görev ayrıntılarını görüntüle';
	@override String get whatIs => 'TaskMaster nedir?';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$tr extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => 'Düzenlemeyi iptal et';
	@override String get close => 'Kapat';
	@override String get copyTaskId => 'Görev ID’sini kopyala';
	@override String get delete => 'Görevi sil';
	@override String deleteConfirmDescription({required Object title}) => '"${title}" kalıcı olarak silinecek.';
	@override String get deleteConfirmTitle => 'Görev silinsin mi?';
	@override String get deleteFailed => 'Görev silinemedi';
	@override String get dependencies => 'Bağımlılıklar';
	@override String get dependenciesPlaceholder => 'örn. 1, 2, 3';
	@override String get description => 'Açıklama';
	@override String get edit => 'Görevi düzenle';
	@override String get implDetails => 'Uygulama Ayrıntıları';
	@override String get noDependencies => 'Bağımlılık yok';
	@override String get noDescription => 'Açıklama yok';
	@override String get priority => 'Öncelik';
	@override String get priorityNotSet => 'Ayarlanmadı';
	@override String get save => 'Kaydet';
	@override String get status => 'Durum';
	@override String get statusFailed => 'Görev durumu güncellenemedi';
	@override String taskId({required Object id}) => 'Görev ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'Görev ${id}: ${title}';
	@override String get testStrategy => 'Test Stratejisi';
	@override String get titleRequired => 'Başlık gerekli';
	@override String get updateFailed => 'Görev güncellenemedi';
	@override String deleteConfirmMessage({required Object id}) => '#${id} görevi kaldırılacak. Bu işlem geri alınamaz.';
	@override String get notFound => 'Görev bulunamadı';
	@override String get subtasks => 'Alt görevler';
	@override String get idCopied => 'Görev ID kopyalandı';
}

// Path: tasks.toasts
class Translations$tasks$toasts$tr extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'Görev ${id} devam ediyor olarak ayarlandı';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$tr extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'Panel';
	@override String get memories => 'Anılar';
	@override String get rules => 'Kurallar';
	@override String get skills => 'Beceriler';
	@override String get personal => 'Kişisel';
	@override String get graph => 'Grafik';
}

// Path: knowledge.common
class Translations$knowledge$common$tr extends Translations$knowledge$common$en {
	Translations$knowledge$common$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get add => 'Ekle';
	@override String get save => 'Kaydet';
	@override String get cancel => 'İptal';
	@override String get delete => 'Sil';
	@override String get edit => 'Düzenle';
	@override String get close => 'Kapat';
	@override String get restore => 'Geri yükle';
	@override String get refresh => 'Yenile';
	@override String get allProjects => 'Tüm projeler';
	@override String get global => 'Genel';
}

// Path: knowledge.actions
class Translations$knowledge$actions$tr extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Proje dosyalarını tara';
	@override String get export => 'JSON dışa aktar';
	@override String get import => 'JSON içe aktar';
	@override String get scanComplete => 'Tarama tamamlandı';
	@override String get importComplete => 'İçe aktarma tamamlandı';
	@override String get importFailed => 'İçe aktarma başarısız';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$tr extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get newEntity => 'Yeni kayıt';
	@override String get editEntity => 'Kaydı düzenle';
	@override String get deleteTitle => 'Sil';
	@override String get deleteMessage => 'Bu kayıt silinsin mi? Geri alınamaz (geçmiş korunur).';
	@override String get pickIcon => 'Simge seç';
	@override String get removeIcon => 'Simgeyi kaldır';
	@override String get iconTooLarge => 'Simge çok büyük (en fazla 40 KB).';
	@override String get importTitle => 'Bilgiyi içe aktar';
	@override String get importHint => 'Dışa aktarılan JSON\'u buraya yapıştır';
	@override String get exportTitle => 'Bilgiyi dışa aktar';
	@override String get import => 'İçe aktar';
}

// Path: knowledge.fields
class Translations$knowledge$fields$tr extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get key => 'Anahtar';
	@override String get title => 'Başlık';
	@override String get name => 'Ad';
	@override String get description => 'Açıklama';
	@override String get category => 'Kategori';
	@override String get content => 'İçerik';
	@override String get priority => 'Öncelik';
	@override String get tags => 'Etiketler';
	@override String get enabled => 'Etkin';
	@override String get projectScope => 'Proje kapsamı';
	@override String get tagsHint => 'virgülle ayrılmış';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$tr extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Anılar';
	@override String get rules => 'Kurallar';
	@override String get skills => 'Beceriler';
	@override String get personal => 'Kişisel';
	@override String get connections => 'Bağlantılar';
	@override String get recent => 'Son anılar';
	@override String get noMemories => 'Henüz anı yok. Anılar sekmesinden ekleyin.';
}

// Path: knowledge.empty
class Translations$knowledge$empty$tr extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get memories => 'Henüz anı yok.';
	@override String get rules => 'Henüz kural yok.';
	@override String get skills => 'Henüz beceri yok.';
	@override String get personal => 'Henüz kişisel bilgi yok.';
	@override String get graph => 'Grafik için varlık yok.';
}

// Path: knowledge.history
class Translations$knowledge$history$tr extends Translations$knowledge$history$en {
	Translations$knowledge$history$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Geçmiş';
	@override String get none => 'Henüz geçmiş yok.';
	@override String get untitled => '(başlıksız)';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$tr extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get critical => 'Kritik';
	@override String get high => 'Yüksek';
	@override String get normal => 'Normal';
	@override String get low => 'Düşük';
}

// Path: knowledge.search
class Translations$knowledge$search$tr extends Translations$knowledge$search$en {
	Translations$knowledge$search$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bilgide ara';
	@override String get hint => 'Anılar, kurallar, beceriler ara…';
	@override String get noResults => 'Sonuç yok.';
}

// Path: knowledge.links
class Translations$knowledge$links$tr extends Translations$knowledge$links$en {
	Translations$knowledge$links$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Varlıkları bağla';
	@override String get source => 'Kaynak';
	@override String get target => 'Hedef';
	@override String get relationship => 'İlişki';
	@override String get add => 'Bağlantı oluştur';
}

// Path: knowledge.tags
class Translations$knowledge$tags$tr extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get all => 'Tüm etiketler';
	@override String get manage => 'Etiketleri yönet';
	@override String get none => 'Henüz etiket yok.';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$tr extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok';
}

// Path: knowledge.critical
class Translations$knowledge$critical$tr extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get make => 'Kritik yap';
	@override String get makeAll => 'Tüm kuralları kritik yap';
	@override String get makeAllHint => 'Bunları enjekte edilen bağlam bütçesine ekler';
}

// Path: knowledge.errors
class Translations$knowledge$errors$tr extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'İçe aktarma başarısız: ${error}';
	@override String migrationFailed({required Object error}) => 'Taşıma başarısız: ${error}';
}

// Path: knowledge.graph
class Translations$knowledge$graph$tr extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get truncated => 'kısaltıldı';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$tr extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get action => 'Her şeyi içe aktar';
	@override String get mergeDuplicates => 'Yinelenen kayıtları birleştir';
	@override String get mergeDuplicatesHint => 'ddagent içindeki yinelenen satırları birleştirir (dosyaları değil)';
	@override String projectsScanned({required Object count}) => 'Taranan projeler: ${count}';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'Kurallar: ${total} · yinelenen gruplar: ${duplicates}';
	@override String skillsFound({required Object found, required Object newSkills}) => 'Bulunan agent becerileri: ${found} (yeni: ${newSkills})';
	@override String get title => 'Her şeyi ddagent\'a aktar';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$tr extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String found({required Object count}) => 'Agentlarınızda ${count} beceri bulundu.';
	@override String summary({required Object imported, required Object skipped}) => 'Yeni: ${imported} · atlanan: ${skipped}';
	@override String get title => 'Agent becerilerini içe aktar';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$tr extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'Bellek: ${title}';
	@override String personal({required Object title}) => 'Kişisel: ${title}';
	@override String rule({required Object title}) => 'Kural: ${title}';
	@override String skill({required Object name}) => 'Beceri: ${name}';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$tr extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String duplicates({required Object count}) => 'Projeler arası yinelenen gruplar: ${count}';
	@override String get mergeDuplicates => 'Yinelenenleri birleştir';
	@override String removedPromoted({required Object removed, required Object promoted}) => 'Kaldırılan: ${removed}, yükseltilen: ${promoted}';
	@override String rulesSummary({required Object total, required Object critical}) => 'Kurallar: toplam ${total}, ${critical} kritik.';
	@override String scanned({required Object count}) => '${count} proje tarandı.';
	@override String get title => 'Mevcut kuralları taşı';
}

// Path: skills.addDialog
class Translations$skills$addDialog$tr extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => 'SKILL.md seç';
	@override String get chooseFiles => 'Dosya Seç';
	@override String get chooseFolder => 'Klasör Seç';
	@override String get chooseFolderTitle => 'Bir beceri klasörü seçin';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} dosya · ${size}',
		other: '${count} dosya · ${size}',
	);
	@override String get folderUploadsNote => 'Klasör yüklemeleri seçilen klasör adını korur; tek başına dosyalar `SKILL.md` içindeki `name` değerini kullanır.';
	@override String get hideInstallLocation => 'Kurulum konumunu gizle';
	@override String get installSkill => 'Beceri Kur';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} Beceri Kur',
		other: '${count} Beceri Kur',
	);
	@override String markdownFileMeta({required Object size}) => 'Markdown dosyası · ${size}';
	@override String get pickHint => 'Klasörler script, referans ve varlık içerebilir.';
	@override String get pickTitle => 'Bir beceri klasörü veya SKILL.md seçin';
	@override String get readyToInstall => 'Kuruluma hazır';
	@override String removeQueued({required Object name}) => '${name} öğesini kaldır';
	@override String title({required Object provider}) => '${provider} Becerisi Ekle';
	@override String get uploadHint => 'Bir SKILL.md dosyası veya eksiksiz bir beceri klasörü yükleyin.';
	@override String get whereWillThisInstall => 'Nereye kurulacak?';
}

// Path: skills.empty
class Translations$skills$empty$tr extends Translations$skills$empty$en {
	Translations$skills$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get noGlobalSkills => 'Henüz genel beceri bulunamadı';
	@override String get noGlobalSkillsDescription => 'Her projede kullanılabilir olması için yukarıdan bir genel beceri ekleyin.';
	@override String get noMatchingSkills => 'Eşleşen beceri yok';
	@override String get noMatchingSkillsDescription => 'Farklı bir komut, ad, kapsam, proje veya kaynak yolu deneyin.';
	@override String get noProjects => 'Kullanılabilir proje yok';
	@override String get noProjectsDescription => 'Becerilerine göz atmak için bir proje veya çalışma alanı ekleyin.';
	@override String get noSkillsInProject => 'Bu projede beceri yok';
	@override String get noSkillsInProjectDescription => 'Seçili projede bir .claude/skills, .cursor/skills veya .agents/skills klasörü oluşturun.';
}

// Path: skills.errors
class Translations$skills$errors$tr extends Translations$skills$errors$en {
	Translations$skills$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get addMarkdownFirst => 'Önce bir veya daha fazla markdown dosyası ekleyin.';
	@override String couldNotReadSkillFile({required Object name}) => '${name} içinden SKILL.md okunamadı.';
	@override String get dropMarkdownOrFolder => 'Bir veya daha fazla markdown dosyası ya da SKILL.md içeren bir klasör bırakın.';
	@override String folderFileLimit({required Object count}) => 'Bir beceri klasörü en fazla ${count} dosya içerebilir.';
	@override String get folderReadFailed => 'Beceri klasörü okunamadı';
	@override String get folderSizeLimit => 'Seçilen beceri klasörleri toplamda 30 MB\'den küçük olmalıdır.';
	@override String get importFailed => 'Beceriler içe aktarılamadı';
	@override String get missingSkillFile => 'Seçilen klasörde SKILL.md dosyası yok.';
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$tr extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get moveToGlobal => 'Genele taşı';
	@override String get moveToProject => 'Projeye taşı';
	@override String get toGlobalHint => 'Bu beceriyi, her projenin kullanabilmesi için genel beceriler dizinine taşıyın.';
	@override String get toProjectHint => 'Bu beceriye sahip olacak projeyi seçin. Beceri, sağlayıcının genel beceriler dizininden taşınır.';
}

// Path: skills.scopes
class Translations$skills$scopes$tr extends Translations$skills$scopes$en {
	Translations$skills$scopes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get admin => 'Yönetici';
	@override String get plugin => 'Eklenti';
	@override String get project => 'Proje';
	@override String get repo => 'Depo';
	@override String get system => 'Sistem';
	@override String get user => 'Kullanıcı';
}

// Path: skills.screen
class Translations$skills$screen$tr extends Translations$skills$screen$en {
	Translations$skills$screen$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get addSkill => 'Beceri Ekle';
	@override String get clearSearch => 'Beceri aramasını temizle';
	@override String deleteDescription({required Object directory, required Object provider}) => 'Bu, ${directory} dizinini ${provider} tarafından yönetilen beceriler dizininden kaldırır. Bu işlem geri alınamaz.';
	@override String deleteTitle({required Object name}) => '${name} silinsin mi?';
	@override String loadingSkills({required Object provider}) => '${provider} becerileri yükleniyor…';
	@override String manageDescription({required Object provider}) => '${provider} becerilerini yerel dosyalardan, eksiksiz klasörlerden ve proje bazlı konumlardan yönetin.';
	@override String get noDescription => 'Beceri front matter bölümünde açıklama belirtilmemiş.';
	@override String pluginBadge({required Object name}) => 'Eklenti: ${name}';
	@override String projectBadge({required Object name}) => 'Proje: ${name}';
	@override String get savedSuccessfully => 'Beceriler başarıyla kaydedildi.';
	@override String get scanningProjectSkills => 'Proje becerileri taranıyor...';
	@override String get searchHint => 'Beceri ara...';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} BECERİ',
		other: '${count} BECERİ',
	);
	@override String get sourceLabel => 'KAYNAK';
}

// Path: mcp.form
class Translations$mcp$form$tr extends Translations$mcp$form$en {
	Translations$mcp$form$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$fields$tr fields = Translations$mcp$form$fields$tr._(_root);
	@override late final Translations$mcp$form$scope$tr scope = Translations$mcp$form$scope$tr._(_root);
	@override String submitTo({required Object provider}) => 'Sunucuyu ${provider} için ekle';
	@override late final Translations$mcp$form$validation$tr validation = Translations$mcp$form$validation$tr._(_root);
}

// Path: mcp.install
class Translations$mcp$install$tr extends Translations$mcp$install$en {
	Translations$mcp$install$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get button => 'Kur';
	@override String get cardDescription => 'Agentlarınıza MCP üzerinden bilgi tabanını ve ddagent araçlarını verin — agentları seçin veya tümü için kurun.';
	@override String get description => 'Seçili agentların MCP üzerinden ddagent bilgi tabanını ve araçlarını kullanmasını sağlar.';
	@override String get errorFallback => 'hata';
	@override String failed({required Object error}) => 'Kurulum başarısız: ${error}';
	@override String get installForAll => 'Tümü için kur';
	@override String get installSelected => 'Seçilenler için kur';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} agenta kuruldu.',
		other: '${count} agenta kuruldu.',
	);
	@override String partialFailure({required Object count, required Object failed}) => '${count} agenta kuruldu; başarısız: ${failed}';
	@override String get title => 'ddagent MCP sunucusunu kur';
}

// Path: mcp.servers
class Translations$mcp$servers$tr extends Translations$mcp$servers$en {
	Translations$mcp$servers$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get addGlobalDescription => 'Bu MCP sunucusunu tüm sağlayıcılara ekler: Claude, Cursor, Codex, OpenCode ve Devin. Aynı yapılandırmanın tüm sağlayıcılarda çalışması gerektiğinden yalnızca stdio ve HTTP taşımaları desteklenir.';
	@override String get addGlobalMenuDescription => 'Genel MCP Sunucusu Ekle, Claude, Cursor, Codex, OpenCode ve Devin için ortak bir stdio veya HTTP sunucusu yazar.';
	@override String get addGlobalTitle => 'Genel MCP Sunucusu Ekle';
	@override String addProviderDescription({required Object provider}) => '${provider} MCP Sunucusu Ekle yalnızca ${provider} yapılandırmasını değiştirir.';
	@override String addProviderTitle({required Object provider}) => '${provider} MCP Sunucusu Ekle';
	@override late final Translations$mcp$servers$config$tr config = Translations$mcp$servers$config$tr._(_root);
	@override String descriptionGeneric({required Object provider}) => 'Model Context Protocol sunucuları ${provider} için ek araçlar ve veri kaynakları sağlar';
	@override String get loading => 'MCP sunucuları yükleniyor...';
	@override String get refreshingScopes => 'Proje kapsamları yenileniyor...';
}

// Path: mcp.team
class Translations$mcp$team$tr extends Translations$mcp$team$en {
	Translations$mcp$team$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cta => 'ddagent Pro ile kullanılabilir';
	@override String get description => 'MCP sunucu yapılandırmalarını takımınızla paylaşın. Herkes otomatik olarak senkron kalır.';
	@override String get title => 'Takım MCP Yapılandırmaları';
}

// Path: mcp.tokens
class Translations$mcp$tokens$tr extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => 'Yazma';
}

// Path: terminal.actions
class Translations$terminal$actions$tr extends Translations$terminal$actions$en {
	Translations$terminal$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get clearOutput => 'Çıktıyı Temizle';
	@override String get connect => 'Bağlan';
	@override String get newShell => 'Yeni Shell';
	@override String get newTab => 'Yeni Terminal Sekmesi';
	@override String get providerLogin => 'Sağlayıcı Girişi';
	@override String get restartSession => 'Oturumu Yeniden Başlat';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$tr extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'Tarayıcıda aç';
}

// Path: terminal.errors
class Translations$terminal$errors$tr extends Translations$terminal$errors$en {
	Translations$terminal$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'Bağlantı açılamadı: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$tr extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'Dosya algılandı: ${path}';
}

// Path: terminal.paste
class Translations$terminal$paste$tr extends Translations$terminal$paste$en {
	Translations$terminal$paste$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Ctrl+V / sağ tık → Yapıştır';
	@override String get title => 'Terminale yapıştır';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$tr extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get eof => 'EOF';
	@override String get hide => 'Kısayol çubuğunu gizle';
	@override String get interrupt => 'Kes (SIGINT)';
	@override String get suspend => 'Askıya al (SIGTSTP)';
	@override String get showTooltip => 'Kısayolları göster';
	@override String get hideTooltip => 'Kısayolları gizle';
}

// Path: terminal.tabs
class Translations$terminal$tabs$tr extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get claudeCli => 'Claude CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'Giriş: ${provider}';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get plainShell => 'Basit Shell';
	@override String shellName({required Object index}) => 'Shell ${index}';
}

// Path: quota.agents
class Translations$quota$agents$tr extends Translations$quota$agents$en {
	Translations$quota$agents$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.chart
class Translations$quota$chart$tr extends Translations$quota$chart$en {
	Translations$quota$chart$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get hide => 'Gizle';
	@override String get noData => 'Eğilim için yeterli veri yok.';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} token · ${cost}';
	@override String get show => 'Göster';
}

// Path: quota.config
class Translations$quota$config$tr extends Translations$quota$config$en {
	Translations$quota$config$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get accountRouting => 'Hesap yönlendirme';
	@override String get pollerTitle => 'Sorgulama ve uyarılar';
	@override String get save => 'Yapılandırmayı kaydet';
}

// Path: quota.overview
class Translations$quota$overview$tr extends Translations$quota$overview$en {
	Translations$quota$overview$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'Tokenlar ve maliyet';
}

// Path: quota.section
class Translations$quota$section$tr extends Translations$quota$section$en {
	Translations$quota$section$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get config => 'Yapılandırma';
}

// Path: notifications.errors
class Translations$notifications$errors$tr extends Translations$notifications$errors$en {
	Translations$notifications$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get noResponse => 'Sunucudan yanıt yok';
	@override String get registrationRejected => 'Kayıt sunucu tarafından reddedildi';
}

// Path: serverConnect.local
class Translations$serverConnect$local$tr extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bu cihaz';
	@override String get subtitle => 'ddagent sunucusunu bu makinede çalıştırın';
	@override String get install => 'Yerel sunucuyu kur';
	@override String get start => 'Yerel sunucuyu başlat';
	@override String get stop => 'Durdur';
	@override String get starting => 'Yerel sunucu başlatılıyor…';
	@override String downloading({required Object percent}) => 'Sunucu indiriliyor… %${percent}';
	@override String get installing => 'Kuruluyor…';
	@override String running({required Object url}) => '${url} adresinde çalışıyor';
	@override String installed({required Object version}) => 'Kurulu (v${version})';
	@override String get connect => 'Bu sunucuyu kullan';
	@override String error({required Object error}) => 'Yerel sunucu hatası: ${error}';
	@override String get or => 'veya uzak bir sunucuya bağlanın';
}

// Path: collab.roles
class Translations$collab$roles$tr extends Translations$collab$roles$en {
	Translations$collab$roles$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get member => 'Üye';
	@override String get viewer => 'Görüntüleyici';
}

// Path: sessions.activity
class Translations$sessions$activity$tr extends Translations$sessions$activity$en {
	Translations$sessions$activity$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get committingChanges => 'Değişiklikler commit ediliyor';
	@override String editingFile({required Object file}) => '${file} düzenleniyor';
	@override String get editingFileGeneric => 'Bir dosya düzenleniyor';
	@override String fetchingUrl({required Object url}) => '${url} getiriliyor';
	@override String get pushingBranch => 'Dal gönderiliyor';
	@override String readingFile({required Object file}) => '${file} okunuyor';
	@override String runningCommand({required Object command}) => '`${command}` çalıştırılıyor';
	@override String get runningShellCommand => 'Bir shell komutu çalıştırılıyor';
	@override String runningTool({required Object name}) => '${name} çalıştırılıyor';
	@override String searching({required Object query}) => '“${query}” aranıyor';
	@override String get subagentRunning => 'Alt agent çalışıyor';
}

// Path: sessions.age
class Translations$sessions$age$tr extends Translations$sessions$age$en {
	Translations$sessions$age$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String days({required Object days}) => '${days}g';
	@override String hours({required Object hours}) => '${hours}sa';
	@override String get lessThanMinute => '<1dk';
	@override String minutes({required Object count}) => '${count}dk';
}

// Path: sessions.toasts
class Translations$sessions$toasts$tr extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get archived => 'Oturum arşivlendi';
	@override String get deleted => 'Oturum silindi';
	@override String get pinned => 'Oturum sabitlendi';
	@override String get renamed => 'Oturum yeniden adlandırıldı';
	@override String get restored => 'Oturum geri yüklendi';
	@override String get unpinned => 'Oturum sabitlemesi kaldırıldı';
	@override String get workspaceChanged => 'Çalışma alanı değiştirildi';
}

// Path: git.checkpoints
class Translations$git$checkpoints$tr extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get create => 'Yeni';
	@override String get empty => 'Henüz kontrol noktası yok';
	@override String get labelHint => 'Kontrol noktası etiketi (isteğe bağlı)';
	@override String get restoreMessage => 'Çalışma ağacı bu kontrol noktasına sıfırlansın mı? Mevcut değişiklikler değiştirilecek.';
	@override String get restoreTitle => 'Kontrol noktasını geri yükle';
	@override String get restored => 'Kontrol noktası geri yüklendi';
	@override String get title => 'Kontrol Noktaları';
}

// Path: kanban.card
class Translations$kanban$card$tr extends Translations$kanban$card$en {
	Translations$kanban$card$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get untitled => 'Adsız';
}

// Path: kanban.comments
class Translations$kanban$comments$tr extends Translations$kanban$comments$en {
	Translations$kanban$comments$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get add => 'Yorum ekle';
	@override String get empty => 'Henüz yorum yok';
}

// Path: kanban.details
class Translations$kanban$details$tr extends Translations$kanban$details$en {
	Translations$kanban$details$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String status({required Object status}) => 'Durum: ${status}';
	@override String get title => 'Kart Ayrıntıları';
}

// Path: kanban.dialog
class Translations$kanban$dialog$tr extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get saving => 'Kaydediliyor…';
}

// Path: kanban.empty
class Translations$kanban$empty$tr extends Translations$kanban$empty$en {
	Translations$kanban$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'Proje seçilmedi';
}

// Path: kanban.time
class Translations$kanban$time$tr extends Translations$kanban$time$en {
	Translations$kanban$time$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '1 gün önce',
		other: '${count} gün önce',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '1 saat önce',
		other: '${count} saat önce',
	);
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '1 dakika önce',
		other: '${count} dakika önce',
	);
	@override String get now => 'şimdi';
}

// Path: onboarding.agents
class Translations$onboarding$agents$tr extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Bir veya daha fazla AI kodlama asistanına giriş yapın. Tümü isteğe bağlıdır.';
	@override String get laterHint => 'Bunları daha sonra Ayarlar\'dan yapılandırabilirsiniz.';
	@override String get title => 'AI Agentlarınızı Bağlayın';
}

// Path: onboarding.errors
class Translations$onboarding$errors$tr extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get invalidEmail => 'Lütfen geçerli bir e-posta adresi girin.';
	@override String get nameAndEmailRequired => 'Hem git adı hem de e-posta gerekli.';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$tr extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Agentlarınızın bilgi tabanını ve ddagent araçlarını kullanabilmesi için ddagent MCP sunucusunu kurun. Agentları seçin veya tümü için kurun.';
	@override String get installForAll => 'Tümü için kur';
	@override String get installSelected => 'Seçilenler için kur';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count,
		one: '${count} agenta kuruldu.',
		other: '${count} agenta kuruldu.',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => '${installedCount} agenta kuruldu; başarısız: ${failed}';
	@override String get laterHint => 'İsteğe bağlı — bunu daha sonra Ayarlar → MCP bölümünden de kurabilirsiniz.';
	@override String get title => 'Agentları ddagent\'a bağlayın';
}

// Path: fileTree.search
class Translations$fileTree$search$tr extends Translations$fileTree$search$en {
	Translations$fileTree$search$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Adları filtreleyin / içerikte aramak için Enter\'a basın';
	@override String get noMatches => 'Eşleşme yok';
	@override String get prompt => 'Bir sorgu yazın ve Enter\'a basın';
	@override String get resultsTruncated => 'Sonuçlar kısaltıldı';
}

// Path: fileTree.titles
class Translations$fileTree$titles$tr extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String delete({required Object name}) => '${name} sil';
	@override String download({required Object name}) => '${name} indir';
	@override String rename({required Object name}) => '${name} öğesini yeniden adlandır';
}

// Path: auth.login.errors
class Translations$auth$login$errors$tr extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'Kullanıcı adı veya şifre hatalı';
	@override String get requiredFields => 'Lütfen tüm alanları doldur';
	@override String get networkError => 'Ağ hatası. Lütfen tekrar dene.';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$tr extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get username => 'Kullanıcı adını gir';
	@override String get password => 'Şifreni gir';
}

// Path: auth.register.errors
class Translations$auth$register$errors$tr extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'Şifreler eşleşmiyor';
	@override String get usernameTaken => 'Bu kullanıcı adı zaten alınmış';
	@override String get weakPassword => 'Şifre çok zayıf';
	@override String get usernameTooShort => 'Kullanıcı adı en az 3 karakter olmalıdır';
	@override String get passwordTooShort => 'Şifre en az 6 karakter olmalıdır';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$tr extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Varsayılan Mod';
	@override String get auto => 'Otomatik Mod';
	@override String get acceptEdits => 'Düzenlemeleri Kabul Et';
	@override String get bypassPermissions => 'İzinleri Atla';
	@override String get plan => 'Plan Modu';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$tr extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Sadece güvenilir komutlar (ls, cat, grep, git status, vb.) otomatik çalışır. Diğer komutlar atlanır. Çalışma alanına yazabilir.';
	@override String get auto => 'Bir model sınıflandırıcı, her araç çağrısında onay veya ret kararı verir. Yüksek özerklik.';
	@override String get acceptEdits => 'Tüm komutlar çalışma alanı içinde otomatik çalışır. Sandbox\'lu çalıştırma ile tam otomatik mod.';
	@override String get bypassPermissions => 'Kısıtlama olmadan tam sistem erişimi. Tüm komutlar tam disk ve ağ erişimiyle otomatik çalışır. Dikkatli kullan.';
	@override String get plan => 'Planlama modu — hiçbir komut çalıştırılmaz';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$tr extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter gönderir • / komutlar • @ dosyalar';
	@override String get enter => 'Enter gönderir • Shift+Enter yeni satır • / komutlar • @ dosyalar';
	@override String get queue => 'Sonraki mesajını sıraya almak için Enter';
	@override String get updateQueued => 'Sıradaki mesajı güncellemek için Enter';
}

// Path: chat.input.queue
class Translations$chat$input$queue$tr extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get sendNext => 'Sonraki mesajı sıraya al';
	@override String get update => 'Sıradaki mesajı güncelle';
	@override String get label => 'Sırada';
	@override String get willSend => 'Bu bittiğinde gönderilecek';
	@override String get edit => 'Sıradaki mesajı düzenle';
	@override String get delete => 'Sıradaki mesajı sil';
	@override String get failed => 'Gönderilemedi';
	@override String get sendNow => 'Şimdi gönder';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$tr extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Çevrimdışı kuyruğu iptal et ve temizle';
	@override String get clearBtn => 'İptal';
	@override String multiple({required Object count}) => '${count} mesaj çevrimdışı kuyrukta — yeniden bağlanınca otomatik gönderilecek';
	@override String get single => '1 mesaj çevrimdışı kuyrukta — yeniden bağlanınca otomatik gönderilecek';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$tr extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'Anthropic tarafından';
	@override String get openai => 'OpenAI tarafından';
	@override String get cursorEditor => 'AI Kod Editörü';
	@override String get google => 'Google tarafından';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$tr extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => 'Claude\'u ${model} ile kullanmaya hazır. Mesajını aşağıya yazmaya başla.';
	@override String cursor({required Object model}) => 'Cursor\'ı ${model} ile kullanmaya hazır. Mesajını aşağıya yazmaya başla.';
	@override String codex({required Object model}) => 'Codex\'i ${model} ile kullanmaya hazır. Mesajını aşağıya yazmaya başla.';
	@override String get kDefault => 'Başlamak için yukarıdan bir sağlayıcı seç';
	@override String opencode({required Object model}) => 'OpenCode ${model} ile kullanıma hazır. Aşağıya mesajını yaz.';
	@override String devin({required Object model}) => 'Devin ${model} ile hazır';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$tr extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Konuşmana devam et';
	@override String get description => 'Kodun hakkında soru sor, değişiklik iste veya geliştirme görevlerinde yardım al';
	@override String get action => 'Yazmaya devam et';
}

// Path: chat.session.loading
class Translations$chat$session$loading$tr extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => 'Eski mesajlar yükleniyor...';
	@override String get sessionMessages => 'Oturum mesajları yükleniyor...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$tr extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object total, required Object shown}) => '${total} mesajdan ${shown} tanesi gösteriliyor';
	@override String get scrollToLoad => 'Daha fazlasını yüklemek için yukarı kaydır';
	@override String showingLast({required Object count, required Object total}) => 'Son ${count} mesaj gösteriliyor (${total} toplam)';
	@override String get loadEarlier => 'Önceki mesajları yükle';
	@override String get loadAll => 'Tüm mesajları yükle';
	@override String get loadingAll => 'Tüm mesajlar yükleniyor...';
	@override String get allLoaded => 'Tüm mesajlar yüklendi';
	@override String get perfWarning => 'Tüm mesajlar yüklendi — kaydırma yavaşlayabilir. Performansı geri getirmek için "En alta git"e tıkla.';
	@override String get loadOlderFailed => 'Eski mesajlar yüklenemedi.';
	@override String get retry => 'Yeniden dene';
	@override String get noSearchMatches => 'Aramanızla eşleşen mesaj yok.';
	@override String loadAllCount({required Object count}) => 'Tümünü yükle (${count})';
	@override String get loadOlder => 'Daha eski mesajları yükle';
	@override String retryLoadOlder({required Object error}) => 'Eski mesajları yüklemeyi yeniden dene — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$tr extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Proje Seç';
	@override String get description => 'O dizinde etkileşimli shell açmak için bir proje seç';
}

// Path: chat.shell.status
class Translations$chat$shell$status$tr extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get newSession => 'Yeni Oturum';
	@override String get initializing => 'Başlatılıyor...';
	@override String get restarting => 'Yeniden başlatılıyor...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$tr extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get disconnect => 'Bağlantıyı Kes';
	@override String get disconnectTitle => 'Shell bağlantısını kes';
	@override String get restart => 'Yeniden Başlat';
	@override String get restartTitle => 'Shell\'i yeniden başlat (önce bağlantıyı kes)';
	@override String get connect => 'Shell\'de Devam Et';
	@override String get connectTitle => 'Shell\'e bağlan';
	@override String get kill => 'Sonlandır (SIGINT)';
	@override String get killTitle => 'Çalışan süreci sonlandır (Ctrl+C)';
	@override String get copyOutput => 'Çıktıyı kopyala';
	@override String get copyOutputTitle => 'Terminal çıktısını kopyala';
	@override String get copied => 'Kopyalandı!';
	@override String get zoomInTitle => 'Yakınlaştır';
	@override String get zoomOutTitle => 'Uzaklaştır';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$tr extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'Düşünüyor';
	@override String get processing => 'İşliyor';
	@override String get analyzing => 'Analiz ediyor';
	@override String get working => 'Çalışıyor';
	@override String get computing => 'Hesaplıyor';
	@override String get reasoning => 'Mantık yürütüyor';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$tr extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get live => 'Canlı';
	@override String get paused => 'Duraklatıldı';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$tr extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}sn';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}d ${seconds}s';
	@override String label({required Object time}) => '${time} geçti';
	@override String get startingNow => 'Şimdi başlıyor';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$tr extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => 'Üretmeyi Durdur';
	@override String get pressEscToStop => 'Durdurmak için istediğin zaman Esc\'ye bas';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$tr extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'Asistan';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$tr extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get config => 'Ayarları ve yapılandırmayı açın.';
	@override String get cost => 'Etkin oturumun token kullanımını inceleyin.';
	@override String get help => 'Komut belgelerini ve sözdizimini gösterin.';
	@override String get memory => 'Projenin CLAUDE.md bellek dosyasını açın.';
	@override String get models => 'Etkin sağlayıcı için kullanılabilir modellere göz atın.';
	@override String get status => 'Çalışma zamanı, sürüm, sağlayıcı ve ortam durumunu inceleyin.';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$tr extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get rename => 'Yeniden Adlandır';
	@override String get delete => 'Sil';
	@override String get copyPath => 'Yolu Kopyala';
	@override String get download => 'İndir';
	@override String get newFile => 'Yeni Dosya';
	@override String get newFolder => 'Yeni Klasör';
	@override String get upload => 'Dosya Yükle';
	@override String get refresh => 'Yenile';
	@override String get menuLabel => 'Dosya bağlam menüsü';
	@override String get loading => 'Yükleniyor...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$tr extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Sil';
	@override String get fileWarning => 'Bu dosya kalıcı olarak silinecek.';
	@override String get folderWarning => 'Bu klasör ve tüm içeriği kalıcı olarak silinecek.';
	@override String title({required Object type}) => '${type} sil';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$tr extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'Yol kopyalanamadı';
	@override String get fileCreated => 'Dosya başarıyla oluşturuldu';
	@override String get fileDeleted => 'Dosya silindi';
	@override String get folderCreated => 'Klasör başarıyla oluşturuldu';
	@override String get folderDeleted => 'Klasör silindi';
	@override String get folderDownloaded => 'Klasör ZIP olarak indirildi';
	@override String get pathCopied => 'Yol panoya kopyalandı';
	@override String get renamed => 'Başarıyla yeniden adlandırıldı';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$tr extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'Dosya adı yalnızca noktalardan oluşamaz';
	@override String get emptyName => 'Dosya adı boş olamaz';
	@override String get invalidChars => 'Dosya adı geçersiz karakterler içeriyor';
	@override String get reserved => 'Dosya adı ayrılmış bir ad';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$tr extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get type => 'Tür';
	@override String get configure => 'Yapılandır';
	@override String get confirm => 'Onayla';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$tr extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get question => 'Zaten bir çalışma alanın var mı, yoksa yeni bir tane mi oluşturmak istersin?';
	@override late final Translations$common$projectWizard$step1$existing$tr existing = Translations$common$projectWizard$step1$existing$tr._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$tr kNew = Translations$common$projectWizard$step1$kNew$tr._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$tr extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'Çalışma Alanı Yolu';
	@override String get newPath => 'Çalışma Alanı Yolu';
	@override String get existingPlaceholder => '/mevcut/calisma-alani/yolu';
	@override String get newPlaceholder => '/yeni/calisma-alani/yolu';
	@override String get existingHelp => 'Mevcut çalışma alanı dizinine giden tam yol';
	@override String get newHelp => 'Çalışma alanı dizinine giden tam yol';
	@override String get githubUrl => 'GitHub URL\'si (İsteğe Bağlı)';
	@override String get githubPlaceholder => 'https://github.com/kullanici/depo';
	@override String get githubHelp => 'İsteğe bağlı: bir depoyu klonlamak için GitHub URL\'si gir';
	@override String get githubAuth => 'GitHub Kimlik Doğrulama (İsteğe Bağlı)';
	@override String get githubAuthHelp => 'Yalnızca özel depolar için gereklidir. Genel depolar kimlik doğrulama olmadan klonlanabilir.';
	@override String get loadingTokens => 'Kayıtlı token\'lar yükleniyor...';
	@override String get storedToken => 'Kayıtlı Token';
	@override String get newToken => 'Yeni Token';
	@override String get nonePublic => 'Yok (Genel)';
	@override String get selectToken => 'Token Seç';
	@override String get selectTokenPlaceholder => '-- Bir token seç --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'Bu token sadece bu işlem için kullanılacak';
	@override String get publicRepoInfo => 'Genel depolar kimlik doğrulama gerektirmez. Genel bir depo klonluyorsan token girmeyi atlayabilirsin.';
	@override String get noTokensHelp => 'Kayıtlı token yok. Kolay tekrar kullanım için Ayarlar → API Anahtarları bölümünden token ekleyebilirsin.';
	@override String get optionalTokenPublic => 'GitHub Token (Genel Depolar için İsteğe Bağlı)';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (genel depolar için boş bırak)';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$tr extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => 'Yapılandırmanı Gözden Geçir';
	@override String get existingWorkspace => 'Mevcut Çalışma Alanı';
	@override String get newWorkspace => 'Yeni Çalışma Alanı';
	@override String get path => 'Yol:';
	@override String get cloneFrom => 'Şuradan Klonla:';
	@override String get authentication => 'Kimlik Doğrulama:';
	@override String get usingStoredToken => 'Kayıtlı token kullanılıyor:';
	@override String get usingProvidedToken => 'Girilen token kullanılıyor';
	@override String get noAuthentication => 'Kimlik doğrulama yok';
	@override String get sshKey => 'SSH Anahtarı';
	@override String get existingInfo => 'Çalışma alanı proje listene eklenecek ve Claude/Cursor oturumları için kullanılabilir olacak.';
	@override String get newWithClone => 'Depo bu klasöre klonlanacak.';
	@override String get newEmpty => 'Çalışma alanı proje listene eklenecek ve Claude/Cursor oturumları için kullanılabilir olacak.';
	@override String get cloningRepository => 'Depo klonlanıyor...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$tr extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'İptal';
	@override String get back => 'Geri';
	@override String get next => 'İleri';
	@override String get createProject => 'Projeyi Oluştur';
	@override String get creating => 'Oluşturuluyor...';
	@override String get cloning => 'Klonlanıyor...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$tr extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get selectType => 'Lütfen mevcut çalışma alanın olduğunu mu yoksa yeni oluşturmak mı istediğini seç';
	@override String get providePath => 'Lütfen bir çalışma alanı yolu gir';
	@override String get failedToCreate => 'Çalışma alanı oluşturulamadı';
	@override String get failedToCreateFolder => 'Klasör oluşturulamadı';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$tr extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$tr generic = Translations$common$notifications$codes$generic$tr._(_root);
	@override late final Translations$common$notifications$codes$permission$tr permission = Translations$common$notifications$codes$permission$tr._(_root);
	@override late final Translations$common$notifications$codes$run$tr run = Translations$common$notifications$codes$run$tr._(_root);
	@override late final Translations$common$notifications$codes$agent$tr agent = Translations$common$notifications$codes$agent$tr._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$tr extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get close => 'Kapat';
	@override String get later => 'Daha Sonra';
	@override String get copyCommand => 'Komutu Kopyala';
	@override String get updateNow => 'Şimdi Güncelle';
	@override String get updating => 'Güncelleniyor...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$tr extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'Sürüm yükseltme modalını kapat';
	@override String get showSidebar => 'Kenar çubuğunu göster';
	@override String get settings => 'Ayarlar';
	@override String get updateAvailable => 'Güncelleme mevcut';
	@override String get closeSidebar => 'Kenar çubuğunu kapat';
}

// Path: common.quota.section
class Translations$common$quota$section$tr extends Translations$common$quota$section$en {
	Translations$common$quota$section$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Genel bakış';
	@override String get quotas => 'Kotalar';
	@override String get usage => 'Kullanım';
	@override String get agents => 'Agentlar';
}

// Path: common.quota.filter
class Translations$common$quota$filter$tr extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get all => 'Tümü';
}

// Path: common.quota.period
class Translations$common$quota$period$tr extends Translations$common$quota$period$en {
	Translations$common$quota$period$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 gün';
	@override String get k30d => '30 gün';
	@override String get all => 'Tümü';
}

// Path: common.quota.group
class Translations$common$quota$group$tr extends Translations$common$quota$group$en {
	Translations$common$quota$group$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Sağlayıcı';
	@override String get model => 'Model';
	@override String get agent => 'Agent';
	@override String get tool => 'Araç';
}

// Path: common.quota.metric
class Translations$common$quota$metric$tr extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'Tokenlar';
	@override String get input => 'Girdi';
	@override String get output => 'Çıktı';
	@override String get cache => 'Önbellek okumaları';
	@override String get calls => 'API çağrıları';
	@override String get cost => 'Maliyet';
	@override String get sessions => 'Oturumlar';
}

// Path: common.quota.cost
class Translations$common$quota$cost$tr extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Faturalanan (API + aşım)';
	@override String get listPrice => 'Kullanılan tokenların liste fiyatı';
	@override String get subscriptionValue => 'Aboneliklerle karşılandı';
	@override String get cacheSavings => 'Önbellek tasarrufu';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$tr extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get billed => 'Faturalanan (API + aşım)';
	@override String get listPrice => 'Kullanılan tokenların liste fiyatı';
	@override String get subscriptionValue => 'Aboneliklerle karşılandı';
}

// Path: common.quota.overview
class Translations$common$quota$overview$tr extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Tokenlar ve maliyet — son 7 gün';
	@override String get effectiveCost => 'Efektif maliyet (7 gün)';
	@override String get alertsTitle => 'Uyarılar';
	@override String get noAlerts => 'Şu an dikkat gerektiren bir şey yok.';
	@override String get limitsTitle => 'Kullanım ve limitler';
	@override String get activeTasks => 'Aktif görevler';
	@override String get viewAccounts => 'Tüm hesaplar';
	@override String get viewAgents => 'Tüm agentlar';
	@override String get noTasks => 'Şu an çalışan agent yok.';
}

// Path: common.quota.usage
class Translations$common$quota$usage$tr extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'Günlük eğilim';
	@override String breakdownTitle({required Object group}) => '${group} bazında döküm';
	@override String get colName => 'İsim';
	@override String get sourceUnavailable => 'Analitik deposu kullanılamıyor; veri gösterilmiyor.';
}

// Path: common.quota.agents
class Translations$common$quota$agents$tr extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} çalışıyor';
	@override String get colAgent => 'Agent';
	@override String get colStatus => 'Durum';
	@override String get colTask => 'Görev';
	@override String get colModel => 'Hesap / model';
	@override String get colTime => 'Zaman';
	@override String get empty => 'Bu filtreye uyan agent yok.';
	@override String get detailSession => 'Oturum';
	@override String get detailStarted => 'Başlatıldı';
	@override String get detailRetries => 'Yeniden denemeler';
	@override String get detailResult => 'Sonuç';
	@override String get notTracked => 'izlenmiyor';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$tr extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get running => 'Çalışıyor';
	@override String get waiting => 'Bekliyor';
	@override String get failed => 'Başarısız';
	@override String get finished => 'Tamamlandı';
	@override String get queued => 'Sırada';
}

// Path: common.quota.alert
class Translations$common$quota$alert$tr extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: mevcut hızda limit ${value} içinde dolacak';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: %${value} kullanıldı (eşik %${watch})';
}

// Path: common.quota.quality
class Translations$common$quota$quality$tr extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get live => 'Canlı';
	@override String get cached => 'Önbellekte';
	@override String get estimate => 'Tahmin';
	@override String get unknown => 'Bilinmiyor';
	@override String get error => 'Hata';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$tr extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get atRisk => 'Riskteki limitler';
	@override String atRiskHint({required Object value}) => '%${value} üzerindeki hesaplar';
	@override String get windowsAtRisk => 'Dolan pencereler';
	@override String get errored => 'Senkronizasyon hataları';
	@override String get activeAgents => 'Aktif agentlar';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} bekliyor · ${queued} sırada';
	@override String get nextReset => 'Sonraki sıfırlama';
	@override String get tokens => 'Tokenlar';
	@override String sessionsHint({required Object value}) => '${value} oturum';
	@override String get cost => 'Tahmini maliyet';
	@override String costHint({required Object value}) => '${value} planlarla karşılandı';
}

// Path: common.quota.empty
class Translations$common$quota$empty$tr extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bağlı hesap yok';
	@override String get description => 'Kotaların burada izlenmesi için Claude, Codex, Gemini veya CommandCode\'da oturum aç.';
}

// Path: common.quota.settings
class Translations$common$quota$settings$tr extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Uyarılar ve yönlendirme';
	@override String get description => 'Panelin ne zaman uyardığını ve yeni işler için hesapların nasıl önerildiğini kontrol et.';
	@override String get alertsEnabled => 'Tahmine dayalı ve eşik uyarıları';
	@override String get alertsEnabledHint => 'Bir limit mevcut hızda dolmadan uyar, yalnızca %90’da değil.';
	@override String get watchThreshold => 'İzleme eşiği (%)';
	@override String get dangerThreshold => 'Tehlike eşiği (%)';
	@override String get routingMode => 'Yönlendirme';
	@override late final Translations$common$quota$settings$routing$tr routing = Translations$common$quota$settings$routing$tr._(_root);
	@override String get logSources => 'Kaynak günlükleri';
	@override String get logSourcesHint => 'Kullanım ve agent ekranları bu salt okunur kaynakları okur.';
	@override String get quotaConsent => 'Kota sorgulamasına izin ver';
	@override String get quotaConsentHint => 'Canlı limitleri okumak için kayıtlı kimlik bilgilerinle sağlayıcı uç noktalarını sorgular.';
	@override String get perAccount => 'Hesap bazlı geçersiz kılmalar';
	@override String get tab => 'Control Center ayarları';
}

// Path: common.quota.range
class Translations$common$quota$range$tr extends Translations$common$quota$range$en {
	Translations$common$quota$range$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'Tümü';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$tr extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => 'Aracıların izlenen tarayıcı oturumları açabilmesi için ayarlarda Browser’ı etkinleştirin.';
	@override String get descEnabled => 'Bir AI görevi Browser kullanırken aracı tarayıcı oturumları burada görünür.';
	@override String get titleDisabled => 'Browser devre dışı';
	@override String get titleEnabled => 'Henüz tarayıcı oturumu yok';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$tr extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'Tarayıcı eylemi başarısız';
	@override String get loadFailed => 'Browser yüklenemedi';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$tr extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Ödeme akışını incelemek ve bozuk UI durumlarını bildirmek için Browser’ı kullanın.';
	@override String get prompt2 => '<url> adresini Browser ile açın, sayfayla etkileşime girin ve her adımdan sonra neyin değiştiğini özetleyin.';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$tr extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' g önce';
	@override String get hoursAgo => ' sa önce';
	@override String get justNow => 'Az önce';
	@override String get minutesAgo => ' dk önce';
	@override String get never => 'Hiç';
	@override String get secondsAgo => ' sn önce';
	@override String get unknown => 'Bilinmiyor';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$tr extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get disabled => 'Devre dışı';
	@override String get installing => 'Kuruluyor';
	@override String get ready => 'Hazır';
	@override String get setupRequired => 'Kurulum gerekli';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$tr extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'Tüm dallara göz at (${count})';
	@override String commits({required Object count}) => 'Tüm commitlere göz at (${count})';
	@override String files({required Object count}) => 'Tüm dosyalara göz at (${count})';
	@override String sessions({required Object count}) => 'Tüm oturumlara göz at (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$tr extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'Maliyet, yayınlanan token ücretlerinden istemci tarafında hesaplanan bir tahmindir; bilinmeyen modeller “—” gösterir.';
	@override String get estCost => 'Tahmini maliyet';
	@override String get inputOutput => 'Girdi / Çıktı';
	@override String get model => 'Model';
	@override String get na => 'Yok';
	@override String get openSplit => 'Bölünmüş görünümde aç';
	@override String get provider => 'Sağlayıcı';
	@override String get selectSession => 'Oturum seçin…';
	@override String get tokensUsed => 'Kullanılan tokenlar';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$tr extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Eylemler';
	@override String get branches => 'Dallar';
	@override String get commits => 'Commitler';
	@override String get files => 'Dosyalar';
	@override String get git => 'Git';
	@override String get navigate => 'Gezinti';
	@override String get sessions => 'Oturumlar';
	@override String get settings => 'Ayarlar';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$tr extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get close => 'Kapat';
	@override String get navigate => 'Gezin';
	@override String get select => 'Seç';
	@override String get togglePalette => 'Paleti aç/kapat';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$tr extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'Oturumları karşılaştır';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => 'Ayarları aç';
	@override String get selectProjectFirst => 'Önce bir proje seçin';
	@override String settingsEntry({required Object label}) => 'Ayarlar: ${label}';
	@override String get startNewChat => 'Yeni sohbet başlat';
	@override String switchTo({required Object name}) => 'Şuna geç: ${name}';
	@override String get toggleTheme => 'Temayı değiştir';
	@override String get tokensAndCost => 'tokenlar ve maliyet';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$tr extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get board => 'Aracı Panosuna git';
	@override String get chat => 'Sohbete git';
	@override String get files => 'Dosyalara git';
	@override String get git => 'Git’e git';
	@override String get sourceControl => 'Kaynak Denetimine git';
	@override String get tasks => 'Görevlere git';
	@override String get usage => 'Kota ve Kullanıma git';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$tr extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get actions => 'Eylemler';
	@override String get branches => 'Dallar';
	@override String get commits => 'Commitler';
	@override String get compare => 'Karşılaştır';
	@override String get files => 'Dosyalar';
	@override String get sessions => 'Oturumlar';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$tr extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => '“${branch}” dalı silinsin mi? Normal silme yalnızca dal tamamen birleştirilmişse başarılı olur. Geri alınamaz.';
	@override String confirmSwitch({required Object branch}) => '“${branch}” dalına geçilsin mi? Commit edilmemiş değişikliğiniz olmadığından emin olun.';
	@override String countBoth({required Object local, required Object remote}) => '${local} yerel, ${remote} uzak';
	@override String countLocal({required Object count}) => '${count} yerel';
	@override String get current => 'geçerli';
	@override String deleteTitle({required Object branch}) => '${branch} dalını sil';
	@override String get emptyDesc => 'Paralel çalışmaya başlamak için bir dal oluşturun.';
	@override String get forceDelete => 'Silmeye zorla';
	@override String get forceDeleteDesc => 'Başka bir yere birleştirilmemiş commitler içerse bile dalı kalıcı olarak kaldırır.';
	@override String get forceDeleteLabel => 'Birleştirilmemiş bu dalı silmeye zorla';
	@override String get local => 'Yerel';
	@override String get kNew => 'Yeni dal';
	@override String get noMatch => 'Aramanızla eşleşen dal yok';
	@override String get none => 'Dal bulunamadı';
	@override String get remote => 'uzak';
	@override String get kSwitch => 'Geç';
	@override String switchTo({required Object branch}) => '${branch} dalına geç';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$tr extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Onayla';
	@override String get delete => 'Sil';
	@override String get deleteBranch => 'Sil';
	@override String get discard => 'Vazgeç';
	@override String get publish => 'Yayınla';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get revertLocalCommit => 'Commiti geri al';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$tr extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get commit => 'Eylemi Onayla';
	@override String get delete => 'Dosyayı Sil';
	@override String get deleteBranch => 'Dalı Sil';
	@override String get discard => 'Değişikliklerden Vazgeç';
	@override String get publish => 'Dalı Yayınla';
	@override String get pull => 'Pull’u Onayla';
	@override String get push => 'Push’u Onayla';
	@override String get revertLocalCommit => 'Yerel Commiti Geri Al';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$tr extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'Dal oluşturma başarısız';
	@override String get createWorktreeFailed => 'Worktree oluşturulamadı';
	@override String get deleteBranchFailed => 'Dal silme başarısız';
	@override String get fetchFailed => 'Fetch başarısız';
	@override String get initFailed => 'Depo başlatılamadı';
	@override String get initialCommitFailed => 'İlk commit oluşturulamadı';
	@override String get mergeFailed => 'Birleştirme başarısız';
	@override String get openWorktreeFailed => 'Worktree açılamadı';
	@override String get operationFailed => 'Git işlemi başarısız';
	@override String get publishFailed => 'Yayınlama başarısız';
	@override String get pullFailed => 'Pull başarısız';
	@override String get pushFailed => 'Push başarısız';
	@override String get removeWorktreeFailed => 'Worktree kaldırılamadı';
	@override String get stageFailed => 'Hazırlama başarısız';
	@override String get stageHunksFailed => 'Parça hazırlama başarısız';
	@override String get switchFailed => 'Dal değiştirme başarısız';
	@override String get unstageFailed => 'Hazırlık geri alma başarısız';
	@override String get unstageHunksFailed => 'Parça hazırlık geri alma başarısız';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$tr extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get added => 'Eklenen';
	@override String get author => 'Yazar';
	@override String get changedFiles => 'Değiştirilen Dosyalar';
	@override String get date => 'Tarih';
	@override String get empty => 'Commit bulunamadı';
	@override String get files => 'Dosyalar';
	@override String get removed => 'Kaldırılan';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$tr extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'Birleştirildikten sonra worktree’yi kaldır ve dalını sil';
	@override String get cleanupLabel => 'Birleştirmeden sonra temizle';
	@override String commitCount({required Object count}) => '${count} commit';
	@override String get merge => 'Birleştir';
	@override String mergeMessage({required Object branch}) => '\'${branch}\' dalını birleştir';
	@override String get messageLabel => 'Commit mesajı';
	@override String squashDesc({required Object commits, required Object branch}) => '${commits} commitin tümünü ${branch} üzerinde tek committe birleştir';
	@override String get squashLabel => 'Commitleri sıkıştır (squash)';
	@override String get squashMerge => 'Squash ve Birleştir';
	@override String squashMessage({required Object branch}) => '\'${branch}\' dalını squash-birleştir';
	@override String get title => 'Worktree’yi Birleştir';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$tr extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => 'Geçerli daldan (${branch}) yeni bir dal oluşturur';
	@override String get nameLabel => 'Dal Adı';
	@override String get submit => 'Dal Oluştur';
	@override String get title => 'Yeni Dal Oluştur';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$tr extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'Dal';
	@override String get createFrom => 'Şuradan oluştur';
	@override String get description => 'Bir dalı kendi klasöründe kullanıma al ve üzerinde paralel çalış.';
	@override String get existingBranch => 'Mevcut dal — olduğu gibi kullanıma alınır.';
	@override String get submit => 'Worktree Oluştur';
	@override String get switchAfter => 'Oluşturduktan sonra worktree’ye geç';
	@override String get title => 'Yeni Worktree';
	@override String get willCreateIn => 'Şurada oluşturulacak';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$tr extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get create => 'İlk Commiti Oluştur';
	@override String get creating => 'İlk Commit Oluşturuluyor...';
	@override String get description => 'Bu depoda henüz commit yok. Değişiklikleri izlemeye başlamak için ilk commitinizi oluşturun.';
	@override String get title => 'Henüz commit yok';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$tr extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Bu proje henüz bir git deposu değil. Değişiklikleri izlemek ve kaynak denetimi özelliklerini kullanmak için bir tane başlatın.';
	@override String get init => 'git init çalıştır';
	@override String get initializing => 'Depo başlatılıyor...';
	@override String get title => 'Git deposu yok';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$tr extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'Dalı da sil';
	@override String description({required Object branch}) => '${branch} için worktree kaldırılsın mı? Klasörü silinir ve bağlı proje arşivlenir — sohbet oturumları kurtarılabilir kalır.';
	@override String dirtyWarning({required Object count}) => 'Bu worktree’de kaybolacak ${count} commit edilmemiş değişiklik var.';
	@override String get discardChanges => 'Commit edilmemiş değişikliklerden vazgeç';
	@override String get title => 'Worktree’yi Kaldır';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$tr extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get added => 'Eklendi';
	@override String get deleted => 'Silindi';
	@override String get modified => 'Değiştirildi';
	@override String get untracked => 'İzlenmiyor';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$tr extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} değişiklik';
	@override String count({required Object count}) => '${count} worktree';
	@override String get createFirst => 'İlk worktree’nizi oluşturun';
	@override String get detached => 'ayrık';
	@override String detachedAt({required Object sha}) => 'ayrık @ ${sha}';
	@override String get detachedHead => 'ayrık HEAD';
	@override String get emptyDesc => 'Worktree, bir dalı kendi klasöründe kullanıma alır; böylece ayrı sohbet oturumlarını yan yana çalıştırabilir ve sonuçları hazır olduğunda birleştirebilirsiniz.';
	@override String get emptyTitle => 'Dallar üzerinde paralel çalışın';
	@override String get locked => 'kilitli';
	@override String get mainWorktree => 'ana worktree';
	@override String mergeTitle({required Object branch}) => '${branch} dalını temel dala birleştir';
	@override String get kNew => 'Yeni worktree';
	@override String get none => 'Worktree yok';
	@override String get nothingToMerge => 'Birleştirilecek bir şey yok — temel dalın ilerisinde commit yok';
	@override String get open => 'Aç';
	@override String get refresh => 'Worktreeleri yenile';
	@override String removeTitle({required Object branch}) => '${branch} için worktree’yi kaldır';
	@override String switchTo({required Object branch}) => '${branch} dalına geç';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$tr extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get changes => 'Değişiklikler';
	@override String get history => 'Commitler';
	@override String get branches => 'Branchler';
	@override String get worktrees => 'Worktreeler';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$tr extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Kapsam';
	@override String get user => 'Kullanıcı';
	@override String get project => 'Proje';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$tr extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get dark => 'Koyu';
	@override String get light => 'Açık';
	@override String get system => 'Sistem';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$tr extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Görünüm';
	@override String get toolDisplay => 'Araç Gösterimi';
	@override String get inputSettings => 'Girdi Ayarları';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$tr extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'Tutamaç sürükleniyor';
	@override String get closePanel => 'Ayarlar panelini kapat';
	@override String get openPanel => 'Ayarlar panelini aç';
	@override String get draggingStatus => 'Sürükleniyor...';
	@override String get toggleAndMove => 'Açıp kapamak için tıkla, taşımak için sürükle';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$tr extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'Kısayol panelini kapat';
	@override String get openPanel => 'Kısayol panelini aç';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$tr extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$tr extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
	@override late final Translations$settings$orchestration$pool$fields$tr fields = Translations$settings$orchestration$pool$fields$tr._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$tr extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$tr extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$tr taskTypes = Translations$settings$orchestration$rules$taskTypes$tr._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$tr extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$tr modes = Translations$settings$orchestration$planner$modes$tr._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$tr modeHints = Translations$settings$orchestration$planner$modeHints$tr._(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$tr templates = Translations$settings$orchestration$planner$templates$tr._(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$tr extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$tr onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$tr._(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$tr extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get unsaved => 'Unsaved changes';
	@override String get save => 'Save';
	@override String get saving => 'Saving…';
	@override String get saved => 'Saved';
	@override String get discard => 'Discard';
	@override String get error => 'Save failed';
	@override String get emptyPool => 'Add at least one candidate before saving.';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$tr extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Web Push Bildirimleri';
	@override String get enable => 'Push Bildirimlerini Etkinleştir';
	@override String get disable => 'Push Bildirimlerini Devre Dışı Bırak';
	@override String get enabled => 'Push bildirimleri etkin';
	@override String get loading => 'Güncelleniyor...';
	@override String get unsupported => 'Bu tarayıcıda push bildirimleri desteklenmiyor.';
	@override String get denied => 'Push bildirimleri engellendi. Lütfen tarayıcı ayarlarından izin ver.';
	@override String get iosHint => 'iPhone/iPad’de bildirimler yalnızca ddagent ana ekrana eklendikten sonra (Paylaş → Ana Ekrana Ekle) ve kurulu uygulamada etkinleştirildikten sonra çalışır.';
	@override String get test => 'Test bildirimi gönder';
	@override String get testNoSubscription => 'Abone cihaz yok. Önce telefonda “Etkinleştir”e dokunun.';
	@override String testSuccess({required Object count}) => '${count} cihaza gönderildi. Telefonda bir şey görünmezse ddagent’ı ana ekrana ekleyin (iOS bunu gerektirir).';
	@override String get testNotDelivered => 'Erişilebilir cihaz yoktu. Uygulamanın çalıştığından ve bildirimlerin etkin olduğundan emin olun.';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$tr extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bu cihazı bilgilendir';
	@override String get enabled => 'Bu cihaz için bildirimler etkin';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$tr extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ses';
	@override String get description => 'Sohbet çalışması tamamlandığında kısa bir ton çal.';
	@override String get enabled => 'Etkin';
	@override String get test => 'Sesi test et';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$tr extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Etkinlik Türleri';
	@override String get actionRequired => 'Aksiyon gerekli';
	@override String get stop => 'Çalıştırma durduruldu';
	@override String get error => 'Çalıştırma başarısız';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$tr extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bu masaüstü uygulamasına bildir';
	@override String get enable => 'Push Bildirimlerini Etkinleştir';
	@override String get disable => 'Push Bildirimlerini Devre Dışı Bırak';
	@override String get enabled => 'Bu masaüstü uygulaması için bildirimler etkin';
	@override String get unsupported => 'Bu sistemde masaüstü bildirimleri desteklenmiyor.';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$tr extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get discord => 'Discord';
	@override String get telegram => 'Telegram';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$tr extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Koyu Mod';
	@override String get description => 'Açık ve koyu temalar arasında geçiş yap';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$tr extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Kod Editörü';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$tr theme = Translations$settings$appearanceSettings$codeEditor$theme$tr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$tr wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$tr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$tr showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$tr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$tr lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$tr._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$tr fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$tr._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$tr extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terminal';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$tr focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$tr._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$tr extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get add => 'MCP Sunucusu Ekle';
	@override String get edit => 'MCP Sunucusunu Düzenle';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$tr extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get form => 'Form Girdisi';
	@override String get json => 'JSON İçe Aktar';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$tr extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Kapsam';
	@override String get userGlobal => 'Kullanıcı (Genel)';
	@override String get projectLocal => 'Proje (Yerel)';
	@override String get userDescription => 'Kullanıcı kapsamı: Makinendeki tüm projelerde kullanılabilir';
	@override String get projectDescription => 'Yerel kapsam: Yalnızca seçili projede kullanılabilir';
	@override String get cannotChange => 'Mevcut bir sunucu düzenlenirken kapsam değiştirilemez';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$tr extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'Sunucu Adı';
	@override String get transportType => 'Taşıma Türü';
	@override String get command => 'Komut';
	@override String get arguments => 'Argümanlar (satır başına bir tane)';
	@override String get jsonConfig => 'JSON Yapılandırması';
	@override String get url => 'URL';
	@override String get envVars => 'Ortam Değişkenleri (KEY=değer, satır başına bir tane)';
	@override String get headers => 'Başlıklar (KEY=değer, satır başına bir tane)';
	@override String get selectProject => 'Bir proje seç...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$tr extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'benim-sunucum';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$tr extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get missingType => 'Zorunlu alan eksik: type';
	@override String get stdioRequiresCommand => 'stdio türü command alanı gerektirir';
	@override String httpRequiresUrl({required Object type}) => '${type} türü url alanı gerektirir';
	@override String get invalidJson => 'Geçersiz JSON formatı';
	@override String get jsonHelp => 'MCP sunucu yapılandırmanı JSON formatında yapıştır. Örnek formatlar:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$tr extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'İptal';
	@override String get saving => 'Kaydediliyor...';
	@override String get addServer => 'Sunucu Ekle';
	@override String get updateServer => 'Sunucuyu Güncelle';
}

// Path: settings.git.name
class Translations$settings$git$name$tr extends Translations$settings$git$name$en {
	Translations$settings$git$name$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git Adı';
	@override String get help => 'Git commit\'leri için adın';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$tr extends Translations$settings$git$email$en {
	Translations$settings$git$email$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git E-postası';
	@override String get help => 'Git commit\'leri için e-postan';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$tr extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get save => 'Yapılandırmayı Kaydet';
	@override String get saving => 'Kaydediliyor...';
}

// Path: settings.git.status
class Translations$settings$git$status$tr extends Translations$settings$git$status$en {
	Translations$settings$git$status$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get success => 'Başarıyla kaydedildi';
	@override String get error => 'Kaydetme başarısız';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$tr extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ API Anahtarını Kaydet';
	@override String get alertMessage => 'Bu anahtarı yalnızca bu sefer göreceksin. Güvenli bir yerde sakla.';
	@override String get iveSavedIt => 'Kaydettim';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$tr extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'API Anahtar Adı (ör. Production Sunucu)';
	@override String get createButton => 'Oluştur';
	@override String get cancelButton => 'İptal';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$tr extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get created => 'Oluşturuldu:';
	@override String get lastUsed => 'Son kullanım:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$tr extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get active => 'Aktif';
	@override String get inactive => 'Pasif';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$tr extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub Token\'ları';
	@override String get description => 'Harici API üzerinden özel depoları klonlamak için GitHub Kişisel Erişim Token\'ları ekle.';
	@override String get descriptionAlt => 'Özel depoları klonlamak için GitHub Kişisel Erişim Token\'ları ekle. Token\'ları saklamadan API isteklerinde doğrudan da geçebilirsin.';
	@override String get addButton => 'Token Ekle';
	@override late final Translations$settings$apiKeys$github$form$tr form = Translations$settings$apiKeys$github$form$tr._(_root);
	@override String get empty => 'Henüz GitHub token\'ı eklenmemiş.';
	@override String get added => 'Eklendi:';
	@override String get confirmDelete => 'Bu GitHub token\'ını silmek istediğinden emin misin?';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$tr extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Harici API Dokümantasyonu';
	@override String get description => 'Uygulamalarından Claude/Cursor oturumları tetiklemek için harici API\'nin nasıl kullanılacağını öğren.';
	@override String get viewLink => 'API Dokümantasyonunu Görüntüle →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$tr extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'Güncelleme mevcut: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$tr extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLI Kurulu Değil';
	@override String get description => 'Görev yönetim özelliklerini kullanmak için TaskMaster CLI gereklidir. Başlamak için kur:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'GitHub\'da Görüntüle';
	@override String get afterInstallation => 'Kurulumdan sonra:';
	@override late final Translations$settings$tasks$notInstalled$steps$tr steps = Translations$settings$tasks$notInstalled$steps$tr._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$tr extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'TaskMaster Entegrasyonunu Etkinleştir';
	@override String get enableDescription => 'TaskMaster görevlerini, banner\'larını ve kenar çubuğu göstergelerini arayüz genelinde göster';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$tr extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Kontrol ediliyor...';
	@override String get connected => 'Bağlı';
	@override String get notConnected => 'Bağlı değil';
	@override String get disconnected => 'Bağlantı kesildi';
	@override String get checkingAuth => 'Kimlik doğrulama durumu kontrol ediliyor...';
	@override String loggedInAs({required Object email}) => '${email} olarak giriş yapıldı';
	@override String providerAccount({required Object provider}) => '${provider} hesabı';
	@override String get authenticatedUser => 'kimliği doğrulanmış kullanıcı';
}

// Path: settings.agents.install
class Translations$settings$agents$install$tr extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => '${agent} CLI kurulu değil';
	@override String description({required Object agent}) => 'Oturum açmak ve oturumları çalıştırmak için ${agent} CLI\'yı kurun.';
	@override String get button => 'Kur';
	@override String get installing => 'Kuruluyor…';
	@override String get copyCommand => 'Komutu kopyala';
	@override String get docs => 'Belgeler';
	@override String success({required Object agent}) => '${agent} CLI kuruldu';
	@override String get failed => 'Kurulum başarısız — terminal çıktısını kontrol edin';
}

// Path: settings.agents.update
class Translations$settings$agents$update$tr extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'CLI\'yi güncelle';
	@override String description({required Object agent}) => 'Sunucu makinesine en son ${agent} CLI sürümünü kurar.';
	@override String get button => 'Güncelle';
	@override String get updating => 'Güncelleniyor…';
	@override String success({required Object agent}) => '${agent} CLI güncellendi';
	@override String get failed => 'Güncelleme başarısız — terminal çıktısını kontrol edin';
}

// Path: settings.agents.account
class Translations$settings$agents$account$tr extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$tr claude = Translations$settings$agents$account$claude$tr._(_root);
	@override late final Translations$settings$agents$account$cursor$tr cursor = Translations$settings$agents$account$cursor$tr._(_root);
	@override late final Translations$settings$agents$account$codex$tr codex = Translations$settings$agents$account$codex$tr._(_root);
	@override late final Translations$settings$agents$account$opencode$tr opencode = Translations$settings$agents$account$opencode$tr._(_root);
	@override late final Translations$settings$agents$account$commandcode$tr commandcode = Translations$settings$agents$account$commandcode$tr._(_root);
	@override late final Translations$settings$agents$account$antigravity$tr antigravity = Translations$settings$agents$account$antigravity$tr._(_root);
	@override late final Translations$settings$agents$account$devin$tr devin = Translations$settings$agents$account$devin$tr._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$tr extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Giriş Yap';
	@override String get reAuthenticate => 'Yeniden Kimlik Doğrula';
	@override String description({required Object agent}) => 'AI özelliklerini etkinleştirmek için ${agent} hesabına giriş yap';
	@override String get reAuthDescription => 'Farklı bir hesapla giriş yap veya kimlik bilgilerini yenile';
	@override String get button => 'Giriş Yap';
	@override String get reLoginButton => 'Tekrar Giriş Yap';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$tr extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Çıkış yap';
	@override String get description => 'Bu sağlayıcıdan çıkış yap ve kayıtlı kimlik bilgilerini sil';
	@override String get button => 'Çıkış yap';
	@override String confirmTitle({required Object agent}) => '${agent} oturumunu kapat?';
	@override String confirmDescription({required Object agent}) => 'Bu, sunucudaki kayıtlı ${agent} kimlik bilgilerini siler. ${agent} kullanmaya devam etmek için tekrar giriş yap.';
	@override String get success => 'Çıkış yapıldı';
	@override String get failed => 'Çıkış yapılamadı';
}

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$tr extends Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'İzin istemlerini atla (dikkatli kullan)';
	@override String get claudeDescription => '--dangerously-skip-permissions bayrağının eşdeğeri';
	@override String get cursorDescription => 'Cursor CLI\'daki -f bayrağının eşdeğeri';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$tr extends Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İzin Verilen Araçlar';
	@override String get description => 'İzin istemeden otomatik olarak izin verilen araçlar';
	@override String get placeholder => 'ör. "Bash(git log:*)" veya "Write"';
	@override String get quickAdd => 'Yaygın araçları hızlı ekle:';
	@override String get empty => 'İzin verilen araç yapılandırılmamış';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$tr extends Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Engellenen Araçlar';
	@override String get description => 'İzin istemeden otomatik olarak engellenen araçlar';
	@override String get placeholder => 'ör. "Bash(rm:*)"';
	@override String get empty => 'Engellenen araç yapılandırılmamış';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$tr extends Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İzin Verilen Shell Komutları';
	@override String get description => 'İzin istemeden otomatik olarak izin verilen shell komutları';
	@override String get placeholder => 'ör. "Shell(ls)" veya "Shell(git status)"';
	@override String get quickAdd => 'Yaygın komutları hızlı ekle:';
	@override String get empty => 'İzin verilen komut yapılandırılmamış';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$tr extends Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Engellenen Shell Komutları';
	@override String get description => 'Otomatik olarak engellenen shell komutları';
	@override String get placeholder => 'ör. "Shell(rm -rf)" veya "Shell(sudo)"';
	@override String get empty => 'Engellenen komut yapılandırılmamış';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$tr extends Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Araç Desen Örnekleri:';
	@override String get bashGitLog => '- Tüm git log komutlarına izin ver';
	@override String get bashGitDiff => '- Tüm git diff komutlarına izin ver';
	@override String get write => '- Tüm Write aracı kullanımına izin ver';
	@override String get bashRm => '- Tüm rm komutlarını engelle (tehlikeli)';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$tr extends Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Shell Komut Örnekleri:';
	@override String get ls => '- ls komutuna izin ver';
	@override String get gitStatus => '- git status\'a izin ver';
	@override String get npmInstall => '- npm install\'a izin ver';
	@override String get rmRf => '- Özyinelemeli silmeyi engelle';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$tr extends Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => 'İzin Modu';
	@override String get description => 'Codex\'in dosya değişiklikleri ve komut çalıştırmayı nasıl ele aldığını kontrol eder';
	@override late final Translations$settings$permissions$codex$modes$tr modes = Translations$settings$permissions$codex$modes$tr._(_root);
	@override String get technicalDetails => 'Teknik ayrıntılar';
	@override late final Translations$settings$permissions$codex$technicalInfo$tr technicalInfo = Translations$settings$permissions$codex$technicalInfo$tr._(_root);
}

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$tr extends Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get add => 'Ekle';
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$tr extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İzin Modu';
	@override String description({required Object provider}) => 'Yeni ${provider} oturumları için varsayılan izin modu. Tek bir oturum için yine de geçersiz kılabilirsin.';
	@override late final Translations$settings$permissions$permissionMode$modes$tr modes = Translations$settings$permissions$permissionMode$modes$tr._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$tr extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Model Context Protocol sunucuları Claude\'a ek araçlar ve veri kaynakları sağlar';
	@override String get cursor => 'Model Context Protocol sunucuları Cursor\'a ek araçlar ve veri kaynakları sağlar';
	@override String get codex => 'Model Context Protocol sunucuları Codex\'e ek araçlar ve veri kaynakları sağlar';
	@override String get opencode => 'Model Context Protocol sunucuları OpenCode\'a ek araçlar ve veri kaynakları sağlar';
	@override String get commandcode => 'Model Context Protocol sunucuları Command Code\'a ek araçlar ve veri kaynakları sağlar';
	@override String get antigravity => 'Model Context Protocol sunucuları Antigravity\'a ek araçlar ve veri kaynakları sağlar';
	@override String get devin => 'Model Context Protocol sunucuları Devin’e ek araçlar ve veri kaynakları sağlar';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$tr extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get local => 'yerel';
	@override String get user => 'kullanıcı';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$tr extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get command => 'Komut';
	@override String get url => 'URL';
	@override String get args => 'Argümanlar';
	@override String get environment => 'Ortam';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$tr extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Araçlar';
	@override String count({required Object count}) => '(${count}):';
	@override String more({required Object count}) => '+${count} tane daha';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$tr extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get edit => 'Sunucuyu düzenle';
	@override String get delete => 'Sunucuyu sil';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$tr extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Codex MCP Hakkında';
	@override String get description => 'Codex stdio tabanlı MCP sunucularını destekler. Codex\'in yeteneklerini ek araçlar ve kaynaklarla genişleten sunucular ekleyebilirsin.';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$tr extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get badge => 'Yönetilen';
	@override String get hint => 'ddagent tarafından yönetiliyor.';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$tr extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '“${serverName}” sağlayıcı yapılandırmasından kaldırılacak.';
	@override String get title => 'MCP sunucusu silinsin mi?';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$tr extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => 'Uyarı eşikleri, yönlendirme politikası ve kota için sorgulanan hesaplar.';
	@override String get saved => 'Kaydedildi';
	@override String get alertsSection => 'Uyarılar';
	@override String get alertsSectionHint => 'Bir limit gerçekten tükenmeden uyar, yalnızca %100’de değil.';
	@override String get alertsEnabled => 'Öngörülen limit uyarıları';
	@override String get alertsEnabledHint => 'Genel bakışta ve hesap kartlarında hıza dayalı projeksiyonları göster.';
	@override String get watchThreshold => 'İzleme eşiği (%)';
	@override String get watchThresholdHint => 'Bu okumada veya üzerindeki hesaplar riskte sayılır.';
	@override String get dangerThreshold => 'Tehlike eşiği (%)';
	@override String get dangerThresholdHint => 'Bu değerdeki veya üzerindeki okumalar kırmızı gösterilir.';
	@override String get routingSection => 'Yönlendirme';
	@override String get routingSectionHint => 'Panelin işi en çok payı olan hesaba nasıl taşıyabileceği.';
	@override late final Translations$settings$quota$settings$routing$tr routing = Translations$settings$quota$settings$routing$tr._(_root);
	@override String get routingNote => 'Hesap değiştirmek maliyeti ve model kalitesini değiştirir, bu yüzden her zaman açık bir karar gerektirir.';
	@override String get accountsSection => 'Sorgulanan hesaplar';
	@override String get accountsSectionHint => 'Kimlik bilgileri her araçtan okunur; panel onları başka yere göndermez.';
	@override String get sourcesSection => 'Veri kaynakları';
	@override String get sourcesSectionHint => 'Kullanım ve maliyet rakamlarının geldiği yer.';
	@override String get logSources => 'Token ve maliyet kayıt deposu';
	@override String get logSourcesHint => 'Tokboard toplayıcısıyla paylaşılan salt okunur toplu depo.';
	@override String get readOnly => 'Salt okunur';
	@override String get quotaConsent => 'Kota sorgulaması';
	@override String get quotaConsentHint => 'Yerel kayıtlı kimlik bilgileriyle sağlayıcı kota uç noktalarını okur.';
	@override String get localOnly => 'Yalnızca yerel';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$tr extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Henüz hesap algılanmadı.';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$tr extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cached => 'önbellekten';
	@override String get error => 'hata';
	@override String get estimate => 'tahmin';
	@override String get live => 'canlı';
	@override String get unknown => 'bilinmiyor';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$tr extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'Tarayıcı runtime’ı kurulamadı';
	@override String get loadSettings => 'Browser ayarları yüklenemedi';
	@override String get loadStatus => 'Browser durumu yüklenemedi';
	@override String get saveSettings => 'Browser ayarları kaydedilemedi';
}

// Path: settings.about.pro
class Translations$settings$about$pro$tr extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => 'Ayarları Senkronize Et';
	@override String get teamManagement => 'Takım Yönetimi';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$tr extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'AI Destekli Görev Yönetimi: Karmaşık projeleri yönetilebilir alt görevlere böl';
	@override String get prdTemplates => 'PRD Şablonları: Ürün Gereksinim Belgelerinden görev üret';
	@override String get dependencyTracking => 'Bağımlılık Takibi: Görev ilişkilerini ve çalıştırma sırasını anla';
	@override String get progressVisualization => 'İlerleme Görselleştirme: Kanban panoları ve detaylı görev analizleri';
	@override String get cliIntegration => 'CLI Entegrasyonu: İleri seviye iş akışları için taskmaster komutlarını kullan';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$tr extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$tr createPRD = Translations$tasks$gettingStarted$steps$createPRD$tr._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$tr generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$tr._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$tr analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$tr._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$tr startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$tr._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$tr extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 Örnek:\n"Claude Task Master ile yeni bir proje başlattım. .taskmaster/docs/prd.txt altında bir PRD\'m var. Bunu ayrıştırıp ilk görevleri kurmama yardım eder misin?"';
	@override String get expandTask => '💬 Örnek:\n"Görev 5 karmaşık görünüyor. Bunu alt görevlere bölebilir misin?"';
	@override String get addTask => '💬 Örnek:\n"Lütfen Cloudinary kullanarak kullanıcı profil resmi yükleme özelliği için yeni bir görev ekle, en iyi yaklaşımı araştır."';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$tr extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 Pro İpuçları';
	@override String get search => 'Belirli görevleri hızlıca bulmak için arama çubuğunu kullan';
	@override String get views => 'Kanban, Liste ve Izgara görünümleri arasında geçiş yapmak için görünüm düğmelerini kullan';
	@override String get filters => 'Belirli görev durumlarına veya önceliklere odaklanmak için filtreleri kullan';
	@override String get details => 'Detaylı bilgi görmek ve alt görevleri yönetmek için herhangi bir göreve tıkla';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$tr extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 Daha Fazla Öğren';
	@override String get description => 'TaskMaster AI, geliştiriciler için inşa edilmiş ileri seviye bir görev yönetim sistemidir. Dokümantasyona, örneklere bak ve projeye katkıda bulun.';
	@override String get githubButton => 'GitHub\'da Görüntüle';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$tr extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Henüz kart yok';
	@override String get description => 'Bir kart ekle, görevi açıkla, sonra bir agentın çalışmaya başlaması için Hazır’a sürükle.';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$tr extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'Backlog';
	@override String get ready => 'Başlamaya hazır';
	@override String get working => 'Çalışıyor';
	@override String get needsDecision => 'Kararın gerekli';
	@override String get done => 'Tamamlandı';
	@override String get archived => 'Arşivlendi';
}

// Path: tasks.board.card
class Translations$tasks$board$card$tr extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get running => 'Çalışıyor';
	@override String get abort => 'İptal et';
	@override String get delete => 'Sil';
	@override String get openSession => 'Oturumu aç';
	@override String get pullRequest => 'Pull request';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$tr extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get createTitle => 'Yeni kart';
	@override String get editTitle => 'Kartı düzenle';
	@override String get titleLabel => 'Başlık';
	@override String get titlePlaceholder => 'Agent ne yapmalı?';
	@override String get descriptionLabel => 'Açıklama';
	@override String get descriptionPlaceholder => 'Bağlam, kabul kriterleri, bağlantılar ekle...';
	@override String get cancel => 'İptal';
	@override String get save => 'Kaydet';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$tr extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get provider => 'Agent';
	@override String get anyProvider => 'Herhangi bir agent';
	@override String get model => 'Model';
	@override String get defaultModel => 'Varsayılan model';
	@override String get effort => 'Akıl yürütme';
	@override String get defaultEffort => 'Varsayılan';
	@override String get searchModel => 'Model ara…';
	@override String get noModels => 'Eşleşen model yok';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$tr extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '“${cardTitle}” kalıcı olarak silinecek.';
	@override String get title => 'Kart silinsin mi?';
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$tr extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get bearerTokenEnvVar => 'Bearer Token Ortam Değişkeni';
	@override String get envVarNames => 'Ortam Değişkeni Adları';
	@override String get workingDirectory => 'Çalışma Dizini';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$tr extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get claudeLocal => 'Claude Yerel';
	@override late final Translations$mcp$form$scope$description$tr description = Translations$mcp$form$scope$description$tr._(_root);
	@override String get projectAllProviders => 'Proje (Tüm Sağlayıcılar)';
	@override String get userAllProviders => 'Kullanıcı (Tüm Sağlayıcılar)';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$tr extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => 'MCP Sunucusu Ekle, tüm sağlayıcılarda yalnızca stdio ve http destekler; ${type} desteklemez.';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider}, ${type} MCP sunucularını desteklemiyor';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$tr extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Çalışma Dizini';
	@override String get envVars => 'Ortam Değişkenleri';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$tr extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mevcut Çalışma Alanı';
	@override String get description => 'Sunucumda zaten bir çalışma alanım var, sadece proje listesine eklemek istiyorum';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$tr extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Yeni Çalışma Alanı';
	@override String get description => 'Yeni bir çalışma alanı oluştur, istersen bir GitHub deposundan klonla';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$tr extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$tr info = Translations$common$notifications$codes$generic$info$tr._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$tr extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$tr required = Translations$common$notifications$codes$permission$required$tr._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$tr extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$tr stopped = Translations$common$notifications$codes$run$stopped$tr._(_root);
	@override late final Translations$common$notifications$codes$run$failed$tr failed = Translations$common$notifications$codes$run$failed$tr._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$tr extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$tr notification = Translations$common$notifications$codes$agent$notification$tr._(_root);
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$tr extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuel — yalnızca öneri';
	@override String get ask => 'Hesap değiştirmeden önce sor';
	@override String get autoLowRisk => 'Düşük riskli görevler için otomatik geçiş';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$tr extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Label';
	@override String get labelPlaceholder => 'e.g. SWE-2 Medium';
	@override String get provider => 'Provider';
	@override String get model => 'Model';
	@override String get modelPlaceholder => 'Select a model';
	@override String get effort => 'Effort';
	@override String get effortDefault => 'Provider default';
	@override String get effortPlaceholder => 'default';
	@override String get account => 'Account';
	@override String get accountDefault => 'Provider default';
	@override String get redundantAccounts => 'Yedek hesaplar';
	@override String get redundantAccountsNone => 'Bu sağlayıcı için başka hesap yok';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$tr extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get plan => 'Planning';
	@override String get quick => 'Quick answers';
	@override String get research => 'Research';
	@override String get docs => 'Documentation';
	@override String get code => 'Coding';
	@override String get codeHard => 'Complex coding';
	@override String get test => 'Testing';
	@override String get review => 'Review';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$tr extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$tr extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$tr extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pipeline templates';
	@override String get add => 'Add template';
	@override String get namePlaceholder => 'Template name';
	@override String get addStep => 'Add step…';
	@override String get remove => 'Remove template';
	@override String get removeStep => 'Remove step';
	@override String get empty => 'No templates yet.';
	@override String get emptySteps => 'No steps yet — add one below.';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$tr extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$tr extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Editör Teması';
	@override String get description => 'Kod editörü için varsayılan tema';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$tr extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Kelime Kaydırma';
	@override String get description => 'Editörde kelime kaydırmayı varsayılan olarak etkinleştir';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$tr extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Minimap\'i Göster';
	@override String get description => 'Diff görünümünde kolay gezinme için minimap göster';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$tr extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Satır Numaralarını Göster';
	@override String get description => 'Editörde satır numaralarını göster';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$tr extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Yazı Tipi Boyutu';
	@override String get description => 'Editör yazı tipi boyutu (piksel)';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$tr extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Odak işaretçiyi takip etsin';
	@override String get description => 'Fareyi üzerine getirdiğinde yazmak için terminali odakla';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$tr extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Token Adı (ör. Kişisel Depolar)';
	@override String get tokenPlaceholder => 'GitHub Kişisel Erişim Token\'ı (ghp_...)';
	@override String get descriptionPlaceholder => 'Açıklama (isteğe bağlı)';
	@override String get addButton => 'Token Ekle';
	@override String get cancelButton => 'İptal';
	@override String get howToCreate => 'GitHub Kişisel Erişim Token\'ı nasıl oluşturulur →';
	@override String get showToken => 'Token\'ı göster';
	@override String get hideToken => 'Token\'ı gizle';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$tr extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get restart => 'Bu uygulamayı yeniden başlat';
	@override String get autoAvailable => 'TaskMaster özellikleri otomatik olarak kullanılabilir hale gelecek';
	@override String get initCommand => 'Proje dizininde task-master init komutunu kullan';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$tr extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Anthropic Claude AI asistanı';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$tr extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Cursor AI destekli kod editörü';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$tr extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenAI Codex AI asistanı';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$tr extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenCode CLI asistanı';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$tr extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Command Code CLI asistanı';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$tr extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Antigravity CLI asistanı';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$tr extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Devin CLI asistanı';
}

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$tr extends Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$codex$modes$kDefault$tr kDefault = Translations$settings$permissions$codex$modes$kDefault$tr._(_root);
	@override late final Translations$settings$permissions$codex$modes$acceptEdits$tr acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$tr._(_root);
	@override late final Translations$settings$permissions$codex$modes$bypassPermissions$tr bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$tr._(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$tr extends Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Güvenilir komutlar: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (-exec olmadan), vb.';
	@override String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never. Tüm komutlar proje dizini içinde otomatik çalışır.';
	@override String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never. Tam sistem erişimi, yalnızca güvenilir ortamlarda kullan.';
	@override String get overrideNote => 'Sohbet arayüzündeki mod düğmesini kullanarak bunu oturum başına geçersiz kılabilirsin.';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$tr extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$tr kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$tr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$tr acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$tr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$tr bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$tr._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$tr plan = Translations$settings$permissions$permissionMode$modes$plan$tr._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$tr extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get manual => 'Manuel';
	@override String get manualHint => 'Yalnızca öneri göster; hesapları asla otomatik değiştirme.';
	@override String get ask => 'Değiştirmeden önce sor';
	@override String get askHint => 'Bir geçiş önerilir ve onayını bekler.';
	@override String get autoLowRisk => 'Düşük riskli görevler için otomatik';
	@override String get autoLowRiskHint => 'Yalnızca düşük riskli işaretli görevler otomatik taşınabilir.';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$tr extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ürün Gereksinim Belgesi (PRD) oluştur';
	@override String get description => 'Proje fikrini konuş ve ne inşa etmek istediğini anlatan bir PRD yaz.';
	@override String get addButton => 'PRD Ekle';
	@override String get existingPRDs => 'Mevcut PRD\'ler:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$tr extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'PRD\'den Görev Üret';
	@override String get description => 'PRD\'n hazır olduğunda AI asistanına ayrıştırmasını söyle; TaskMaster bunu otomatik olarak uygulama detaylarıyla yönetilebilir görevlere bölecek.';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$tr extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Görevleri Analiz Et ve Genişlet';
	@override String get description => 'AI asistanına görev karmaşıklığını analiz etmesini ve uygulamayı kolaylaştırmak için detaylı alt görevlere ayırmasını söyle.';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$tr extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İnşaya Başla';
	@override String get description => 'AI asistanına görevler üzerinde çalışmaya başlamasını, durumlarını güncellemesini ve proje geliştikçe yeni görevler eklemesini söyle.';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$tr extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get local => 'Seçili proje için Claude kullanıcı ayarlarında saklanır';
	@override String get project => 'Seçili proje çalışma alanında saklanır';
	@override String get projectGlobal => 'Her sağlayıcı için seçili proje çalışma alanına yazar';
	@override String get user => 'Makinenizdeki tüm projelerde kullanılabilir';
	@override String get userGlobal => 'Her sağlayıcının kullanıcı yapılandırmasına yazar ve bu makinedeki projelerde kullanılabilir';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$tr extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bildirim';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$tr extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aksiyon Gerekli';
	@override String body({required Object toolName}) => '${toolName} kararını bekliyor.';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$tr extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Çalıştırma Durduruldu';
	@override String body({required Object reason}) => 'Sebep: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$tr extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Çalıştırma Başarısız';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$tr extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajan Bildirimi';
}

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$tr extends Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Varsayılan';
	@override String get description => 'Sadece güvenilir komutlar (ls, cat, grep, git status, vb.) otomatik çalışır. Diğer komutlar atlanır. Çalışma alanına yazabilir.';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$tr extends Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Düzenlemeleri Kabul Et';
	@override String get description => 'Tüm komutlar çalışma alanı içinde otomatik çalışır. Sandbox\'lu çalıştırma ile tam otomatik mod.';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$tr extends Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İzinleri Atla';
	@override String get description => 'Kısıtlama olmadan tam sistem erişimi. Tüm komutlar tam disk ve ağ erişimiyle otomatik çalışır. Dikkatli kullan.';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$tr extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Varsayılan';
	@override String get description => 'İzin gerektiren eylemler onayın için sohbette gösterilir.';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$tr extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Düzenlemeleri Kabul Et';
	@override String get description => 'Dosya düzenlemeleri otomatik onaylanır; diğer eylemler yine onayını ister.';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$tr extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'İzinleri Atla';
	@override String get description => 'Her eylem otomatik onaylanır — sorusuz tam erişim. Dikkatli kullan.';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$tr extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$tr._(TranslationsTr root) : this._root = root, super.internal(root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Plan';
	@override String get description => 'Planlama modu: agent komut çalıştırmadan keşfeder ve planlar.';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.',
			'auth.login.title' => 'Tekrar Hoş Geldin',
			'auth.login.description' => 'Kendi ddagent hesabına giriş yap',
			'auth.login.username' => 'Kullanıcı Adı',
			'auth.login.password' => 'Şifre',
			'auth.login.submit' => 'Giriş Yap',
			'auth.login.loading' => 'Giriş yapılıyor...',
			'auth.login.errors.invalidCredentials' => 'Kullanıcı adı veya şifre hatalı',
			'auth.login.errors.requiredFields' => 'Lütfen tüm alanları doldur',
			'auth.login.errors.networkError' => 'Ağ hatası. Lütfen tekrar dene.',
			'auth.login.placeholders.username' => 'Kullanıcı adını gir',
			'auth.login.placeholders.password' => 'Şifreni gir',
			'auth.register.title' => 'Hesap Oluştur',
			'auth.register.username' => 'Kullanıcı Adı',
			'auth.register.password' => 'Şifre',
			'auth.register.confirmPassword' => 'Şifreyi Onayla',
			'auth.register.submit' => 'Hesabı Oluştur',
			'auth.register.loading' => 'Hesap oluşturuluyor...',
			'auth.register.errors.passwordMismatch' => 'Şifreler eşleşmiyor',
			'auth.register.errors.usernameTaken' => 'Bu kullanıcı adı zaten alınmış',
			'auth.register.errors.weakPassword' => 'Şifre çok zayıf',
			'auth.register.errors.usernameTooShort' => 'Kullanıcı adı en az 3 karakter olmalıdır',
			'auth.register.errors.passwordTooShort' => 'Şifre en az 6 karakter olmalıdır',
			'auth.logout.title' => 'Çıkış Yap',
			'auth.logout.confirm' => 'Çıkış yapmak istediğinden emin misin?',
			'auth.logout.button' => 'Çıkış Yap',
			'chat.codeBlock.copy' => 'Kopyala',
			'chat.codeBlock.copied' => 'Kopyalandı',
			'chat.codeBlock.copyCode' => 'Kodu kopyala',
			'chat.copyMessage.copy' => 'Mesajı kopyala',
			'chat.copyMessage.copied' => 'Mesaj kopyalandı',
			'chat.copyMessage.failed' => 'Kopyalanamadı',
			'chat.copyMessage.selectFormat' => 'Kopyalama biçimini seç',
			'chat.copyMessage.copyAsMarkdown' => 'Markdown olarak kopyala',
			'chat.copyMessage.copyAsText' => 'Metin olarak kopyala',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'S',
			'chat.messageTypes.error' => 'Hata',
			'chat.messageTypes.tool' => 'Araç',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.tools.settings' => 'Araç Ayarları',
			'chat.tools.error' => 'Araç Hatası',
			'chat.tools.result' => 'Araç Sonucu',
			'chat.tools.viewParams' => 'Girdi parametrelerini göster',
			'chat.tools.viewRawParams' => 'Ham parametreleri göster',
			'chat.tools.viewDiff' => 'Düzenleme diff\'ini göster:',
			'chat.tools.creatingFile' => 'Yeni dosya oluşturuluyor:',
			'chat.tools.updatingTodo' => 'Yapılacaklar Listesi güncelleniyor',
			'chat.tools.read' => 'Okundu',
			'chat.tools.readFile' => 'Dosyayı oku',
			'chat.tools.updateTodo' => 'Yapılacaklar listesini güncelle',
			'chat.tools.readTodo' => 'Yapılacaklar listesini oku',
			'chat.tools.searchResults' => 'sonuç',
			'chat.tools.todoReadLabel' => 'TodoRead yapılacaklar listesi',
			'chat.search.found' => ({required Object count, required Object type}) => '${count} ${type} bulundu',
			'chat.search.file' => 'dosya',
			'chat.search.files' => 'dosya',
			'chat.search.pattern' => 'desen:',
			'chat.search.kIn' => 'şurada:',
			'chat.fileOperations.updated' => 'Dosya başarıyla güncellendi',
			'chat.fileOperations.created' => 'Dosya başarıyla oluşturuldu',
			'chat.fileOperations.written' => 'Dosya başarıyla yazıldı',
			'chat.fileOperations.diff' => 'Diff',
			'chat.fileOperations.newFile' => 'Yeni Dosya',
			'chat.fileOperations.viewContent' => 'Dosya içeriğini göster',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => 'Tam çıktıyı göster (${count} karakter)',
			'chat.fileOperations.contentDisplayed' => 'Dosya içeriği yukarıdaki diff görünümünde gösteriliyor',
			'chat.interactive.title' => 'Etkileşimli Prompt',
			'chat.interactive.waiting' => 'CLI\'da yanıtın bekleniyor',
			'chat.interactive.instruction' => 'Lütfen Claude\'un çalıştığı terminalde bir seçenek seç.',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude ${number} numaralı seçeneği seçti',
			'chat.interactive.instructionDetail' => 'CLI\'da bu seçeneği ok tuşları veya numara girerek interaktif olarak seçebilirsin.',
			'chat.thinking.title' => 'Düşünüyor...',
			'chat.thinking.emoji' => '💭 Düşünüyor...',
			'chat.json.response' => 'JSON Yanıtı',
			'chat.permissions.grant' => ({required Object tool}) => '${tool} için izin ver',
			'chat.permissions.added' => 'İzin eklendi',
			'chat.permissions.addTo' => ({required Object entry}) => '${entry} İzin Verilen Araçlar listesine ekleniyor.',
			'chat.permissions.retry' => 'İzin kaydedildi. Aracı kullanmak için isteği tekrar dene.',
			'chat.permissions.error' => 'İzinler güncellenemedi. Lütfen tekrar dene.',
			'chat.permissions.openSettings' => 'Ayarları aç',
			'chat.permissions.allow' => 'İzin ver',
			'chat.permissions.allowAll' => ({required Object count}) => 'Tümüne izin ver (${count})',
			'chat.permissions.allowWithChanges' => 'Değişikliklerle izin ver',
			'chat.permissions.always' => 'Her zaman',
			'chat.permissions.deny' => 'Reddet',
			'chat.permissions.editAndAllow' => 'Düzenle ve izin ver',
			'chat.permissions.editInput' => 'Girdiyi düzenle',
			'chat.permissions.invalidJson' => 'Geçersiz JSON',
			'chat.permissions.reject' => 'Reddet',
			'chat.todo.updated' => 'Yapılacaklar listesi başarıyla güncellendi',
			'chat.todo.current' => 'Mevcut Yapılacaklar Listesi',
			'chat.plan.viewPlan' => '📋 Uygulama planını göster',
			'chat.plan.title' => 'Uygulama Planı',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claude kullanım limitin doldu. Limitin **${time} ${timezone}** — ${date} tarihinde sıfırlanacak',
			'chat.codex.permissionMode' => 'İzin Modu',
			'chat.codex.modes.kDefault' => 'Varsayılan Mod',
			'chat.codex.modes.auto' => 'Otomatik Mod',
			'chat.codex.modes.acceptEdits' => 'Düzenlemeleri Kabul Et',
			'chat.codex.modes.bypassPermissions' => 'İzinleri Atla',
			'chat.codex.modes.plan' => 'Plan Modu',
			'chat.codex.descriptions.kDefault' => 'Sadece güvenilir komutlar (ls, cat, grep, git status, vb.) otomatik çalışır. Diğer komutlar atlanır. Çalışma alanına yazabilir.',
			'chat.codex.descriptions.auto' => 'Bir model sınıflandırıcı, her araç çağrısında onay veya ret kararı verir. Yüksek özerklik.',
			'chat.codex.descriptions.acceptEdits' => 'Tüm komutlar çalışma alanı içinde otomatik çalışır. Sandbox\'lu çalıştırma ile tam otomatik mod.',
			'chat.codex.descriptions.bypassPermissions' => 'Kısıtlama olmadan tam sistem erişimi. Tüm komutlar tam disk ve ağ erişimiyle otomatik çalışır. Dikkatli kullan.',
			'chat.codex.descriptions.plan' => 'Planlama modu — hiçbir komut çalıştırılmaz',
			'chat.codex.technicalDetails' => 'Teknik ayrıntılar',
			'chat.input.placeholder' => ({required Object provider}) => 'Komutlar için /, dosyalar için @ yaz ya da ${provider}\'a her şeyi sor...',
			'chat.input.placeholderDefault' => 'Mesajını yaz...',
			'chat.input.disabled' => 'Girdi devre dışı',
			'chat.input.attachFiles' => 'Dosya ekle',
			'chat.input.attachImages' => 'Resim ekle',
			'chat.input.send' => 'Gönder',
			'chat.input.stop' => 'Durdur',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter gönderir • / komutlar • @ dosyalar',
			'chat.input.hintText.enter' => 'Enter gönderir • Shift+Enter yeni satır • / komutlar • @ dosyalar',
			'chat.input.hintText.queue' => 'Sonraki mesajını sıraya almak için Enter',
			'chat.input.hintText.updateQueued' => 'Sıradaki mesajı güncellemek için Enter',
			'chat.input.clickToChangeMode' => 'İzin modunu değiştirmek için tıkla',
			'chat.input.showAllCommands' => 'Tüm komutları göster',
			'chat.input.clearInput' => 'Girdiyi temizle',
			'chat.input.scrollToBottom' => 'En alta git',
			'chat.input.attachFilesDesc' => 'Fotoğraf, dosya veya belge yükle',
			'chat.input.takePhoto' => 'Fotoğraf çek',
			'chat.input.takePhotoDesc' => 'Fotoğraf çekmek için kamerayı kullan',
			'chat.input.moreTools' => 'Daha fazla araç',
			'chat.input.commandsDesc' => 'Kısayolları ve komutları keşfet',
			'chat.input.clearInputDesc' => 'Mevcut metni sil',
			'chat.input.newMessage' => 'Yeni mesaj',
			'chat.input.newMessages' => 'Yeni mesajlar',
			'chat.input.queue.sendNext' => 'Sonraki mesajı sıraya al',
			'chat.input.queue.update' => 'Sıradaki mesajı güncelle',
			'chat.input.queue.label' => 'Sırada',
			'chat.input.queue.willSend' => 'Bu bittiğinde gönderilecek',
			'chat.input.queue.edit' => 'Sıradaki mesajı düzenle',
			'chat.input.queue.delete' => 'Sıradaki mesajı sil',
			'chat.input.queue.failed' => 'Gönderilemedi',
			'chat.input.queue.sendNow' => 'Şimdi gönder',
			'chat.input.autoContinueTasks' => 'Otomatik devam',
			'chat.input.autoContinueTasksTooltip' => 'Devin\'in bir sonraki Task Master görevine otomatik geçmesi için etkinleştir',
			'chat.input.offlineQueue.clear' => 'Çevrimdışı kuyruğu iptal et ve temizle',
			'chat.input.offlineQueue.clearBtn' => 'İptal',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} mesaj çevrimdışı kuyrukta — yeniden bağlanınca otomatik gönderilecek',
			'chat.input.offlineQueue.single' => '1 mesaj çevrimdışı kuyrukta — yeniden bağlanınca otomatik gönderilecek',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'Kamera kullanılamıyor: ${error}',
			'chat.providerSelection.title' => 'AI Asistanını Seç',
			'chat.providerSelection.description' => 'Yeni bir konuşma başlatmak için bir sağlayıcı seç',
			'chat.providerSelection.selectModel' => 'Model Seç',
			'chat.providerSelection.providerInfo.anthropic' => 'Anthropic tarafından',
			'chat.providerSelection.providerInfo.openai' => 'OpenAI tarafından',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI Kod Editörü',
			'chat.providerSelection.providerInfo.google' => 'Google tarafından',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => 'Claude\'u ${model} ile kullanmaya hazır. Mesajını aşağıya yazmaya başla.',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => 'Cursor\'ı ${model} ile kullanmaya hazır. Mesajını aşağıya yazmaya başla.',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => 'Codex\'i ${model} ile kullanmaya hazır. Mesajını aşağıya yazmaya başla.',
			'chat.providerSelection.readyPrompt.kDefault' => 'Başlamak için yukarıdan bir sağlayıcı seç',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'OpenCode ${model} ile kullanıma hazır. Aşağıya mesajını yaz.',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Devin ${model} ile hazır',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => 'Oturumlarda, dosyalarda ve commit\'lerde arama yapmak için <kbd>${shortcut}</kbd> tuşlarına bas',
			'chat.providerSelection.workspace' => 'Çalışma alanı',
			'chat.providerSelection.noWorkspace' => 'Yok',
			'chat.providerSelection.clickToChangeWorkspace' => 'Çalışma alanını değiştirmek için tıkla',
			'chat.providerSelection.chooseWorkspace' => 'Çalışma alanı seç',
			'chat.providerSelection.searchWorkspaces' => 'Çalışma alanı ara...',
			'chat.providerSelection.noWorkspacesFound' => 'Çalışma alanı bulunamadı.',
			'chat.providerSelection.all' => 'Tümü',
			'chat.providerSelection.free' => 'Ücretsiz',
			'chat.providerSelection.noModelsFound' => 'Model bulunamadı.',
			'chat.providerSelection.paid' => 'Ücretli',
			'chat.providerSelection.searchModels' => 'Model ara...',
			'chat.providerSelection.addModel' => 'Model ekle',
			'chat.providerSelection.chooseModel' => 'Model seç',
			'chat.providerSelection.chooseModelDescription' => 'Yerleşik ve özel modeller tek listede',
			'chat.providerSelection.clickToChange' => 'Modeli değiştirmek için tıkla',
			'chat.providerSelection.favorites' => 'Favoriler',
			'chat.providerSelection.loadingModels' => 'Modeller yükleniyor…',
			'chat.providerSelection.manageModels' => 'Modelleri yönet',
			'chat.providerSelection.refresh' => 'Modelleri yenile',
			'chat.session.kContinue.title' => 'Konuşmana devam et',
			'chat.session.kContinue.description' => 'Kodun hakkında soru sor, değişiklik iste veya geliştirme görevlerinde yardım al',
			'chat.session.kContinue.action' => 'Yazmaya devam et',
			'chat.session.loading.olderMessages' => 'Eski mesajlar yükleniyor...',
			'chat.session.loading.sessionMessages' => 'Oturum mesajları yükleniyor...',
			'chat.session.messages.showingOf' => ({required Object total, required Object shown}) => '${total} mesajdan ${shown} tanesi gösteriliyor',
			'chat.session.messages.scrollToLoad' => 'Daha fazlasını yüklemek için yukarı kaydır',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => 'Son ${count} mesaj gösteriliyor (${total} toplam)',
			'chat.session.messages.loadEarlier' => 'Önceki mesajları yükle',
			'chat.session.messages.loadAll' => 'Tüm mesajları yükle',
			'chat.session.messages.loadingAll' => 'Tüm mesajlar yükleniyor...',
			'chat.session.messages.allLoaded' => 'Tüm mesajlar yüklendi',
			'chat.session.messages.perfWarning' => 'Tüm mesajlar yüklendi — kaydırma yavaşlayabilir. Performansı geri getirmek için "En alta git"e tıkla.',
			'chat.session.messages.loadOlderFailed' => 'Eski mesajlar yüklenemedi.',
			'chat.session.messages.retry' => 'Yeniden dene',
			'chat.session.messages.noSearchMatches' => 'Aramanızla eşleşen mesaj yok.',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'Tümünü yükle (${count})',
			'chat.session.messages.loadOlder' => 'Daha eski mesajları yükle',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => 'Eski mesajları yüklemeyi yeniden dene — ${error}',
			'chat.session.deleteConfirm' => 'Oturumu ve transkriptini kaldırır. Geri alınamaz.',
			'chat.session.finishRunBeforeWorkspaceChange' => 'Çalışma alanını değiştirmeden önce çalıştırmayı bitir',
			'chat.shell.selectProject.title' => 'Proje Seç',
			'chat.shell.selectProject.description' => 'O dizinde etkileşimli shell açmak için bir proje seç',
			'chat.shell.status.newSession' => 'Yeni Oturum',
			'chat.shell.status.initializing' => 'Başlatılıyor...',
			'chat.shell.status.restarting' => 'Yeniden başlatılıyor...',
			'chat.shell.actions.disconnect' => 'Bağlantıyı Kes',
			'chat.shell.actions.disconnectTitle' => 'Shell bağlantısını kes',
			'chat.shell.actions.restart' => 'Yeniden Başlat',
			'chat.shell.actions.restartTitle' => 'Shell\'i yeniden başlat (önce bağlantıyı kes)',
			'chat.shell.actions.connect' => 'Shell\'de Devam Et',
			'chat.shell.actions.connectTitle' => 'Shell\'e bağlan',
			'chat.shell.actions.kill' => 'Sonlandır (SIGINT)',
			'chat.shell.actions.killTitle' => 'Çalışan süreci sonlandır (Ctrl+C)',
			'chat.shell.actions.copyOutput' => 'Çıktıyı kopyala',
			'chat.shell.actions.copyOutputTitle' => 'Terminal çıktısını kopyala',
			'chat.shell.actions.copied' => 'Kopyalandı!',
			'chat.shell.actions.zoomInTitle' => 'Yakınlaştır',
			'chat.shell.actions.zoomOutTitle' => 'Uzaklaştır',
			'chat.shell.loading' => 'Terminal yükleniyor...',
			'chat.shell.connecting' => 'Shell\'e bağlanılıyor...',
			'chat.shell.startSession' => 'Yeni bir Claude oturumu başlat',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'Oturuma devam et: ${displayName}...',
			'chat.shell.runCommand' => ({required Object projectName, required Object command}) => '${projectName} içinde ${command} çalıştır',
			'chat.shell.startCli' => ({required Object projectName}) => '${projectName} içinde Claude CLI başlatılıyor',
			'chat.shell.defaultCommand' => 'komut',
			'chat.claudeStatus.actions.thinking' => 'Düşünüyor',
			'chat.claudeStatus.actions.processing' => 'İşliyor',
			'chat.claudeStatus.actions.analyzing' => 'Analiz ediyor',
			'chat.claudeStatus.actions.working' => 'Çalışıyor',
			'chat.claudeStatus.actions.computing' => 'Hesaplıyor',
			'chat.claudeStatus.actions.reasoning' => 'Mantık yürütüyor',
			'chat.claudeStatus.state.live' => 'Canlı',
			'chat.claudeStatus.state.paused' => 'Duraklatıldı',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}sn',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}d ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '${time} geçti',
			'chat.claudeStatus.elapsed.startingNow' => 'Şimdi başlıyor',
			'chat.claudeStatus.controls.stopGeneration' => 'Üretmeyi Durdur',
			'chat.claudeStatus.controls.pressEscToStop' => 'Durdurmak için istediğin zaman Esc\'ye bas',
			'chat.claudeStatus.providers.assistant' => 'Asistan',
			'chat.claudeStatus.stop' => 'Durdur',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => '${provider} ile sohbet etmeye başlamak için bir proje seç',
			'chat.tasks.nextTaskPrompt' => 'Sonraki görevi başlat',
			'chat.voice.autoRead' => 'Yanıtları sesli oku',
			'chat.voice.autoReadOn' => 'Yanıtları sesli okuma: açık',
			'chat.voice.autoReadOff' => 'Yanıtları sesli okuma: kapalı',
			'chat.voice.autoReadVoice' => 'Sesli okuma sesi',
			'chat.voice.autoReadVoiceAuto' => 'Otomatik ses',
			'chat.voice.autoReadPreview' => 'Yanıtlar böyle seslendirilecek.',
			'chat.voice.speakMessage' => 'Sesli oku',
			'chat.voice.stopSpeaking' => 'Okumayı durdur',
			'chat.composer.toolsAndActions' => 'Araçlar ve eylemler',
			'chat.composer.toolsAndActionsDesc' => 'Sohbet düzenleyici için araçlar ve denetimler',
			'chat.composer.reasoning' => 'Mantık yürütüyor',
			'chat.composer.model' => 'Model',
			'chat.composer.effortDefault' => 'Varsayılan',
			'chat.composer.loadingModels' => 'Modeller yükleniyor…',
			'chat.composer.modelMenu' => 'Model ve akıl yürütme düzeyi seç',
			'chat.composer.permissionHeading' => ({required Object provider}) => '${provider} eylemleri nasıl onaylansın?',
			'chat.composer.favorites' => 'Favoriler',
			'chat.splitSession.toggle' => 'Oturumu Böl',
			'chat.splitSession.close' => 'Bölünmüş oturumu kapat',
			'chat.splitSession.selectSession' => 'Karşılaştırılacak oturumu seç',
			'chat.splitSession.noOtherSessions' => 'Başka oturum yok',
			'chat.splitSession.newSessionOption' => '+ Bölünmüş görünümde yeni oturum',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => 'Mevcut Proje (${name})',
			'chat.splitSession.otherProjectsGroup' => 'Diğer Projeler',
			'chat.splitSession.recentSessionsGroup' => 'Son oturumlar',
			'chat.splitSession.startNewSession' => 'Bölünmüş Görünümde Yeni Oturum Başlat',
			'chat.splitSession.selectFromList' => 'Mevcut oturumlar listesinden oturum seç',
			'chat.sessionPicker.title' => 'Oturum seç',
			'chat.sessionPicker.searchPlaceholder' => 'Oturum ara...',
			'chat.sessionPicker.clearSearch' => 'Aramayı temizle',
			'chat.sessionPicker.newChat' => '+ Yeni sohbet',
			'chat.sessionPicker.archivedToggle' => 'Arşivlenmiş',
			'chat.sessionPicker.changeSession' => 'Oturum değiştir',
			'chat.sessionPicker.archivedLoading' => 'Arşivlenmiş oturumlar yükleniyor...',
			'chat.sessionPicker.archivedError' => 'Arşivlenmiş oturumlar yüklenemedi',
			'chat.sessionPicker.archivedEmpty' => 'Arşivlenmiş oturum yok',
			'chat.sessionPicker.archivedProjectOnly' => 'Çalışma alanı arşivlendi — oturumlarını görmek için geri yükle.',
			'chat.sessionPicker.emptySearch' => 'Aramanla eşleşen oturum yok',
			'chat.sessionPicker.restore' => 'Geri yükle',
			'chat.sessionPicker.restoreSession' => 'Oturumu geri yükle',
			'chat.sessionPicker.restoreProject' => 'Çalışma alanını geri yükle',
			'chat.sessionPicker.restoreSessionFailed' => 'Oturum geri yüklenemedi. Lütfen tekrar dene.',
			'chat.sessionPicker.restoreProjectFailed' => 'Çalışma alanı geri yüklenemedi. Lütfen tekrar dene.',
			'chat.sessionPicker.archiveFailed' => 'Oturum arşivlenemedi. Lütfen tekrar dene.',
			'chat.sessionPicker.deleteFailed' => 'Oturum silinemedi. Lütfen tekrar dene.',
			'chat.sessionPicker.running' => 'Oturum çalışıyor',
			'chat.sessionPicker.unread' => 'Okunmadı — yeni çıktıyla tamamlandı',
			'chat.splitWorkspace.addChat' => 'Sohbet bölmesi ekle',
			'chat.splitWorkspace.addBrowser' => 'Tarayıcı bölmesi ekle',
			'chat.splitWorkspace.addTerminal' => 'Terminal bölmesi ekle',
			'chat.splitWorkspace.overview' => 'Tüm bölmeleri göster',
			'chat.splitWorkspace.exitFocusMode' => 'Odak Modundan çık (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => 'Odak Modu (Ctrl+Shift+F)',
			'chat.splitWorkspace.browseSessions' => 'Oturum listesini aç',
			'chat.splitOverview.title' => 'Bölünmüş bölmelere genel bakış',
			'chat.splitOverview.count' => ({required Object count}) => '${count} bölme',
			'chat.splitOverview.close' => 'Genel görünümü kapat',
			'chat.splitOverview.question' => 'SORU — girdi gerekli',
			'chat.splitOverview.processing' => 'İŞLENİYOR',
			'chat.splitOverview.idle' => 'Boşta',
			'chat.splitOverview.active' => 'Etkin',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} girdinizi bekliyor',
			'chat.askUserQuestion.answerHint' => 'Yanıtınızı yazın…',
			'chat.askUserQuestion.other' => 'Diğer…',
			'chat.askUserQuestion.skip' => 'Atla',
			'chat.attachments.downloadFailedRetry' => 'İndirme başarısız — yeniden denemek için tıklayın',
			'chat.attachments.fileAttachment' => 'Dosya eki',
			'chat.attachments.download' => ({required Object name}) => '${name} indir',
			'chat.checkpoint.creating' => 'Anlık görüntü oluşturuluyor…',
			'chat.checkpoint.revertChanges' => 'Dosyaları son kontrol noktasına geri al',
			'chat.checkpoint.undo' => 'Kontrol noktasını geri al',
			'chat.checkpoint.beforeAiTurn' => 'AI turundan önce',
			'chat.common.close' => 'Kapat',
			'chat.taskMaster.saveToTask' => 'Görev',
			'chat.taskMaster.saved' => 'Kaydedildi',
			'chat.taskMaster.saving' => 'Kaydediliyor...',
			'chat.taskMaster.taskShort' => 'GÖREV',
			'chat.taskMaster.addToTask' => 'TaskMaster\'a ekle',
			'chat.taskMaster.added' => 'TaskMaster\'a eklendi',
			'chat.tokenUsage.desc' => 'Oturum token tüketimini görüntüle',
			'chat.tokenUsage.title' => 'Token kullanımı',
			'chat.tool.emptyResult' => '(henüz çıktı yok — araç boş sonuç döndürdü)',
			'chat.quotaBadge.ariaLabel' => 'Abonelik limitleri',
			'chat.quotaBadge.noData' => 'Bu model için abonelik verisi yok',
			'chat.paneHeader.processing' => 'İşleniyor…',
			'chat.paneHeader.switchSession' => 'Oturum değiştir',
			'chat.broadcast.selectOrchestrators' => 'Düzenleyicileri seç',
			'chat.broadcast.orchestratorsOnly' => 'Yalnızca düzenleyiciler',
			'chat.broadcast.noOrchestrators' => 'Kullanılabilir düzenleyici oturumu yok',
			'chat.changes.empty' => 'Dosya değişikliği yok',
			'chat.changes.failedToLoad' => 'Değişiklikler yüklenemedi',
			'chat.commandResult.fallback.config' => 'Ayarları ve yapılandırmayı açın.',
			'chat.commandResult.fallback.cost' => 'Etkin oturumun token kullanımını inceleyin.',
			'chat.commandResult.fallback.help' => 'Komut belgelerini ve sözdizimini gösterin.',
			'chat.commandResult.fallback.memory' => 'Projenin CLAUDE.md bellek dosyasını açın.',
			'chat.commandResult.fallback.models' => 'Etkin sağlayıcı için kullanılabilir modellere göz atın.',
			'chat.commandResult.fallback.status' => 'Çalışma zamanı, sürüm, sağlayıcı ve ortam durumunu inceleyin.',
			'chat.commandResult.filterCommands' => 'Komutları filtrele...',
			'chat.commandResult.searchModels' => ({required Object provider}) => '${provider} modellerini ara...',
			'chat.commands.runConfirmTitle' => 'Komut çalıştırılsın mı?',
			'chat.commands.executionCancelled' => 'Komut çalıştırma iptal edildi',
			'chat.export.sessionTitle' => ({required Object id}) => 'Oturum ${id}',
			'chat.export.pdfFailed' => 'PDF dışa aktarma başarısız',
			'chat.export.transcriptDownloaded' => 'Transkript indirildi',
			'chat.export.savedTo' => ({required Object path}) => 'Kaydedildi: ${path}',
			'chat.message.compactedSummary' => 'Sıkıştırılmış özet',
			'chat.message.rawView' => 'Ham görünüm',
			'chat.message.resendHint' => 'Düzenleyiciden yeniden gönderin',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => '${name} sil',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => '${name} düzenle',
			'chat.modelLibrary.enterNameAndId' => 'Hem model adını hem de model ID\'sini gir.',
			'chat.modelLibrary.idNoSpaces' => 'Model ID\'leri boşluk içeremez.',
			'chat.modelLibrary.setAsDefault' => 'Varsayılan olarak ayarla',
			'chat.modelLibrary.defaultModel' => 'Varsayılan model',
			'chat.pinFile.action' => 'Sabitle',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.title' => 'Dosyayı sabitle',
			'chat.permissionRequest.title' => ({required Object tool}) => 'İzin isteği · ${tool}',
			'chat.permissionRequest.question' => 'Soru',
			'codeEditor.toolbar.changes' => 'değişiklik',
			'codeEditor.toolbar.previousChange' => 'Önceki değişiklik',
			'codeEditor.toolbar.nextChange' => 'Sonraki değişiklik',
			'codeEditor.toolbar.hideDiff' => 'Diff vurgusunu gizle',
			'codeEditor.toolbar.showDiff' => 'Diff vurgusunu göster',
			'codeEditor.toolbar.settings' => 'Editör Ayarları',
			'codeEditor.toolbar.collapse' => 'Editörü daralt',
			'codeEditor.toolbar.expand' => 'Editörü tüm genişliğe aç',
			'codeEditor.toolbar.diffMerge' => 'Diff / birleştirme',
			'codeEditor.toolbar.previewInBrowser' => 'Tarayıcıda önizle',
			'codeEditor.toolbar.reload' => 'Diskten yeniden yükle',
			'codeEditor.toolbar.toggleDock' => 'Dosya panelini aç/kapat',
			'codeEditor.loading' => ({required Object fileName}) => '${fileName} yükleniyor...',
			'codeEditor.header.showingChanges' => 'Değişiklikler gösteriliyor',
			'codeEditor.actions.copyPath' => 'Dosya yolunu kopyala',
			'codeEditor.actions.pathCopied' => 'Dosya yolu kopyalandı',
			'codeEditor.actions.download' => 'Dosyayı indir',
			'codeEditor.actions.save' => 'Kaydet',
			'codeEditor.actions.saving' => 'Kaydediliyor...',
			'codeEditor.actions.saved' => 'Kaydedildi!',
			'codeEditor.actions.exitFullscreen' => 'Tam ekrandan çık',
			'codeEditor.actions.fullscreen' => 'Tam ekran',
			'codeEditor.actions.close' => 'Kapat',
			'codeEditor.actions.previewMarkdown' => 'Markdown önizle',
			'codeEditor.actions.editMarkdown' => 'Markdown düzenle',
			'codeEditor.actions.pinFile' => 'Dosyayı bağlama sabitle',
			'codeEditor.actions.unpinFile' => 'Dosyayı bağlamdan çıkar',
			'codeEditor.actions.previewHtml' => 'HTML önizlemesini yeni sekmede aç',
			'codeEditor.actions.retry' => 'Yeniden dene',
			'codeEditor.actions.saveAll' => 'Tümünü kaydet',
			'codeEditor.footer.lines' => 'Satır:',
			'codeEditor.footer.characters' => 'Karakter:',
			'codeEditor.footer.shortcuts' => 'Kaydetmek için Ctrl+S • Kapatmak için Esc',
			'codeEditor.binaryFile.title' => 'Binary Dosya',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => '"${fileName}" dosyası binary olduğu için metin editöründe gösterilemez.',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'Metin olarak gösterilemez',
			'codeEditor.filePreview.loading' => 'Önizleme yükleniyor...',
			'codeEditor.filePreview.error' => 'Bu dosya görüntülenemiyor.',
			'codeEditor.filePreview.openInNewTab' => 'Yeni sekmede aç',
			'codeEditor.diff.applyMerge' => 'Birleştirmeyi uygula',
			'codeEditor.diff.base' => 'Temel',
			'codeEditor.diff.close' => 'Diff\'i kapat',
			'codeEditor.diff.current' => 'Geçerli',
			'codeEditor.diff.hunk' => ({required Object number}) => 'Parça ${number}',
			'codeEditor.diff.noChanges' => 'Değişiklik yok',
			'codeEditor.diff.deletedOnDisk' => 'diskte silindi',
			'codeEditor.discardUnsavedChanges' => 'Kaydedilmemiş değişikliklerden vazgeçilsin mi?',
			'codeEditor.emptyState.title' => 'Açık dosya yok',
			'codeEditor.failedToLoad' => 'Dosya yüklenemedi',
			'codeEditor.hexDump.more' => ({required Object size}) => '… ${size} daha',
			'codeEditor.mediaFile.subtitle' => 'Ses/video önizlemesi henüz desteklenmiyor',
			'codeEditor.mediaFile.title' => 'Medya dosyası',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'Yazı tipi boyutu −  (şimdi ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'Yazı tipi boyutu +',
			'codeEditor.settings.minimap' => 'Minimap',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Sekme boyutu: ${size}',
			'codeEditor.unsavedChanges' => ({required Object name}) => '${name} dosyasında kaydedilmemiş değişiklikler var',
			'codeEditor.toasts.savedFile' => ({required Object name}) => '${name} kaydedildi',
			'codeEditor.toasts.saveFailed' => 'Kaydetme başarısız',
			'codeEditor.toasts.allSaved' => 'Tümü kaydedildi',
			'codeEditor.toasts.someSavesFailed' => 'Bazı kaydetmeler başarısız oldu',
			'codeEditor.toasts.savedTo' => ({required Object path}) => 'Şuraya kaydedildi: ${path}',
			'codeEditor.toasts.mergeApplied' => 'Birleştirme uygulandı — kalıcı olması için kaydet',
			'common.buttons.save' => 'Kaydet',
			'common.buttons.cancel' => 'İptal',
			'common.buttons.delete' => 'Sil',
			'common.buttons.create' => 'Oluştur',
			'common.buttons.edit' => 'Düzenle',
			'common.buttons.close' => 'Kapat',
			'common.buttons.confirm' => 'Onayla',
			'common.buttons.submit' => 'Gönder',
			'common.buttons.retry' => 'Tekrar Dene',
			'common.buttons.refresh' => 'Yenile',
			'common.buttons.search' => 'Ara',
			'common.buttons.clear' => 'Temizle',
			'common.buttons.copy' => 'Kopyala',
			'common.buttons.download' => 'İndir',
			'common.buttons.upload' => 'Yükle',
			'common.buttons.browse' => 'Gözat',
			'common.buttons.openDiagram' => 'Diyagramı aç',
			'common.buttons.update' => 'Güncelle',
			'common.tabs.chat' => 'Sohbet',
			'common.tabs.shell' => 'Shell',
			'common.tabs.files' => 'Dosyalar',
			'common.tabs.git' => 'Kaynak Kontrolü',
			'common.tabs.tasks' => 'Görevler',
			'common.tabs.browser' => 'Tarayıcı',
			'common.tabs.computer' => 'Bilgisayar',
			'common.tabs.board' => 'Pano',
			'common.tabs.usage' => 'AI Control',
			'common.status.loading' => 'Yükleniyor...',
			'common.status.success' => 'Başarılı',
			'common.status.error' => 'Hata',
			'common.status.failed' => 'Başarısız',
			'common.status.pending' => 'Beklemede',
			'common.status.completed' => 'Tamamlandı',
			'common.status.inProgress' => 'Sürüyor',
			'common.messages.savedSuccessfully' => 'Başarıyla kaydedildi',
			'common.messages.deletedSuccessfully' => 'Başarıyla silindi',
			'common.messages.updatedSuccessfully' => 'Başarıyla güncellendi',
			'common.messages.operationFailed' => 'İşlem başarısız',
			'common.messages.networkError' => 'Ağ hatası. Lütfen bağlantını kontrol et.',
			'common.messages.unauthorized' => 'Yetkisiz erişim. Lütfen giriş yap.',
			'common.messages.notFound' => 'Bulunamadı',
			'common.messages.invalidInput' => 'Geçersiz girdi',
			'common.messages.requiredField' => 'Bu alan zorunlu',
			'common.messages.unknownError' => 'Bilinmeyen bir hata oluştu',
			'common.messages.renameSessionFailed' => 'Oturum yeniden adlandırılamadı. Lütfen tekrar deneyin.',
			'common.navigation.settings' => 'Ayarlar',
			'common.navigation.home' => 'Ana Sayfa',
			'common.navigation.back' => 'Geri',
			'common.navigation.next' => 'İleri',
			'common.navigation.previous' => 'Önceki',
			'common.navigation.logout' => 'Çıkış Yap',
			'common.common.language' => 'Dil',
			'common.common.theme' => 'Tema',
			'common.common.darkMode' => 'Koyu Mod',
			'common.common.lightMode' => 'Açık Mod',
			'common.common.name' => 'İsim',
			'common.common.description' => 'Açıklama',
			'common.common.enabled' => 'Etkin',
			'common.common.disabled' => 'Devre Dışı',
			'common.common.optional' => 'İsteğe Bağlı',
			'common.common.version' => 'Sürüm',
			'common.common.select' => 'Seç',
			'common.common.selectAll' => 'Tümünü Seç',
			'common.common.deselectAll' => 'Tümünün Seçimini Kaldır',
			'common.common.done' => 'Tamam',
			'common.common.failed' => 'Başarısız',
			'common.time.justNow' => 'Az önce',
			'common.time.minutesAgo' => ({required Object count}) => '${count} dakika önce',
			'common.time.hoursAgo' => ({required Object count}) => '${count} saat önce',
			'common.time.daysAgo' => ({required Object count}) => '${count} gün önce',
			'common.time.yesterday' => 'Dün',
			'common.fileOperations.newFile' => 'Yeni Dosya',
			'common.fileOperations.newFolder' => 'Yeni Klasör',
			'common.fileOperations.rename' => 'Yeniden Adlandır',
			'common.fileOperations.move' => 'Taşı',
			'common.fileOperations.copyPath' => 'Yolu Kopyala',
			'common.fileOperations.openInEditor' => 'Editörde Aç',
			'common.mainContent.loading' => 'ddagent Yükleniyor',
			'common.mainContent.settingUpWorkspace' => 'Çalışma alanın hazırlanıyor...',
			'common.mainContent.chooseProject' => 'Projeni Seç',
			'common.mainContent.selectProjectDescription' => 'Claude ile kodlamaya başlamak için kenar çubuğundan bir proje seç. Her proje kendi sohbet oturumlarını ve dosya geçmişini içerir.',
			'common.mainContent.tip' => 'İpucu',
			'common.mainContent.createProjectMobile' => 'Projelere erişmek için yukarıdaki menü düğmesine dokun',
			_ => null,
		} ?? switch (path) {
			'common.mainContent.createProjectDesktop' => 'Kenar çubuğundaki klasör simgesine tıklayarak yeni bir proje oluştur',
			'common.mainContent.newSession' => 'Yeni Oturum',
			'common.mainContent.untitledSession' => 'Adsız Oturum',
			'common.mainContent.projectFiles' => 'Proje Dosyaları',
			'common.mainContent.focusMode' => 'Odak Modu (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'Odak Modundan Çık (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'Oturumu Böl',
			'common.mainContent.closeSplitSession' => 'Bölünmüş oturumu kapat',
			'common.mainContent.chooseWorkspace' => 'Bir çalışma alanı seçin',
			'common.mainContent.chooseWorkspaceDescription' => 'Bu sohbet için bir çalışma alanı seçin veya Ayarlar’da yeni bir tane oluşturun.',
			'common.mainContent.createWorkspace' => 'Ayarlar’da çalışma alanı oluştur',
			'common.mainContent.recentProjects' => 'Son projeler',
			'common.fileTree.loading' => 'Dosyalar yükleniyor...',
			'common.fileTree.files' => 'Dosyalar',
			'common.fileTree.simpleView' => 'Basit görünüm',
			'common.fileTree.compactView' => 'Kompakt görünüm',
			'common.fileTree.detailedView' => 'Detaylı görünüm',
			'common.fileTree.searchPlaceholder' => 'Dosya ve klasörlerde ara...',
			'common.fileTree.clearSearch' => 'Aramayı temizle',
			'common.fileTree.name' => 'İsim',
			'common.fileTree.size' => 'Boyut',
			'common.fileTree.modified' => 'Değiştirilme',
			'common.fileTree.permissions' => 'İzinler',
			'common.fileTree.noFilesFound' => 'Dosya bulunamadı',
			'common.fileTree.checkProjectPath' => 'Proje yolunun erişilebilir olduğunu kontrol et',
			'common.fileTree.noMatchesFound' => 'Eşleşme bulunamadı',
			'common.fileTree.tryDifferentSearch' => 'Farklı bir arama terimi dene veya aramayı temizle',
			'common.fileTree.justNow' => 'az önce',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} dakika önce',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} saat önce',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} gün önce',
			'common.fileTree.newFile' => 'Yeni Dosya (Cmd+N)',
			'common.fileTree.newFolder' => 'Yeni Klasör (Cmd+Shift+N)',
			'common.fileTree.refresh' => 'Yenile',
			'common.fileTree.collapseAll' => 'Tümünü Daralt',
			'common.fileTree.context.rename' => 'Yeniden Adlandır',
			'common.fileTree.context.delete' => 'Sil',
			'common.fileTree.context.copyPath' => 'Yolu Kopyala',
			'common.fileTree.context.download' => 'İndir',
			'common.fileTree.context.newFile' => 'Yeni Dosya',
			'common.fileTree.context.newFolder' => 'Yeni Klasör',
			'common.fileTree.context.upload' => 'Dosya Yükle',
			'common.fileTree.context.refresh' => 'Yenile',
			'common.fileTree.context.menuLabel' => 'Dosya bağlam menüsü',
			'common.fileTree.context.loading' => 'Yükleniyor...',
			'common.fileTree.searchContentPlaceholder' => 'Dosyalarda ara...',
			'common.fileTree.searchInFiles' => 'Dosyalarda ara',
			'common.fileTree.searchByName' => 'Ada göre ara',
			'common.fileTree.loadFailed' => 'Dosyalar yüklenemedi',
			'common.fileTree.noSearchResults' => 'Eşleşme bulunamadı',
			'common.fileTree.searchError' => 'Arama başarısız',
			'common.fileTree.searching' => 'Aranıyor...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => 'İlk ${count} sonuç gösteriliyor',
			'common.fileTree.allWorkspaces' => 'Tüm çalışma alanları',
			'common.fileTree.delete.confirm' => 'Sil',
			'common.fileTree.delete.fileWarning' => 'Bu dosya kalıcı olarak silinecek.',
			'common.fileTree.delete.folderWarning' => 'Bu klasör ve tüm içeriği kalıcı olarak silinecek.',
			'common.fileTree.delete.title' => ({required Object type}) => '${type} sil',
			'common.fileTree.dropToUpload' => 'Yüklemek için dosyaları bırakın',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => '“${folder}” klasörüne yüklemek için dosyaları bırakın',
			'common.fileTree.noProject' => 'Önce bir proje ekleyin',
			'common.fileTree.noRecentFiles' => 'Son 7 günde değiştirilen dosya yok',
			'common.fileTree.showAllFiles' => 'Tüm dosyaları göster',
			'common.fileTree.showAllFilesHint' => 'Her şeyi görmek için son değişenler filtresini kapatın.',
			'common.fileTree.showRecentOnly' => 'Son 7 günde değişen dosyaları göster',
			'common.fileTree.toast.copyFailed' => 'Yol kopyalanamadı',
			'common.fileTree.toast.fileCreated' => 'Dosya başarıyla oluşturuldu',
			'common.fileTree.toast.fileDeleted' => 'Dosya silindi',
			'common.fileTree.toast.folderCreated' => 'Klasör başarıyla oluşturuldu',
			'common.fileTree.toast.folderDeleted' => 'Klasör silindi',
			'common.fileTree.toast.folderDownloaded' => 'Klasör ZIP olarak indirildi',
			'common.fileTree.toast.pathCopied' => 'Yol panoya kopyalandı',
			'common.fileTree.toast.renamed' => 'Başarıyla yeniden adlandırıldı',
			'common.fileTree.uploadComplete' => 'Yükleme tamamlandı',
			'common.fileTree.uploadFailed' => 'Yükleme başarısız',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'Dosya yükle (her biri en fazla ${size})',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => 'Dosyaları “${folder}” klasörüne yükle',
			'common.fileTree.uploadedCount' => ({required Object total, required Object label, required Object uploaded}) => '${total} ${label} içinden ${uploaded} yüklendi',
			'common.fileTree.uploadingFiles' => 'Dosyalar yükleniyor',
			'common.fileTree.validation.dotsOnly' => 'Dosya adı yalnızca noktalardan oluşamaz',
			'common.fileTree.validation.emptyName' => 'Dosya adı boş olamaz',
			'common.fileTree.validation.invalidChars' => 'Dosya adı geçersiz karakterler içeriyor',
			'common.fileTree.validation.reserved' => 'Dosya adı ayrılmış bir ad',
			'common.projectWizard.title' => 'Yeni Proje Oluştur',
			'common.projectWizard.steps.type' => 'Tür',
			'common.projectWizard.steps.configure' => 'Yapılandır',
			'common.projectWizard.steps.confirm' => 'Onayla',
			'common.projectWizard.step1.question' => 'Zaten bir çalışma alanın var mı, yoksa yeni bir tane mi oluşturmak istersin?',
			'common.projectWizard.step1.existing.title' => 'Mevcut Çalışma Alanı',
			'common.projectWizard.step1.existing.description' => 'Sunucumda zaten bir çalışma alanım var, sadece proje listesine eklemek istiyorum',
			'common.projectWizard.step1.kNew.title' => 'Yeni Çalışma Alanı',
			'common.projectWizard.step1.kNew.description' => 'Yeni bir çalışma alanı oluştur, istersen bir GitHub deposundan klonla',
			'common.projectWizard.step2.existingPath' => 'Çalışma Alanı Yolu',
			'common.projectWizard.step2.newPath' => 'Çalışma Alanı Yolu',
			'common.projectWizard.step2.existingPlaceholder' => '/mevcut/calisma-alani/yolu',
			'common.projectWizard.step2.newPlaceholder' => '/yeni/calisma-alani/yolu',
			'common.projectWizard.step2.existingHelp' => 'Mevcut çalışma alanı dizinine giden tam yol',
			'common.projectWizard.step2.newHelp' => 'Çalışma alanı dizinine giden tam yol',
			'common.projectWizard.step2.githubUrl' => 'GitHub URL\'si (İsteğe Bağlı)',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/kullanici/depo',
			'common.projectWizard.step2.githubHelp' => 'İsteğe bağlı: bir depoyu klonlamak için GitHub URL\'si gir',
			'common.projectWizard.step2.githubAuth' => 'GitHub Kimlik Doğrulama (İsteğe Bağlı)',
			'common.projectWizard.step2.githubAuthHelp' => 'Yalnızca özel depolar için gereklidir. Genel depolar kimlik doğrulama olmadan klonlanabilir.',
			'common.projectWizard.step2.loadingTokens' => 'Kayıtlı token\'lar yükleniyor...',
			'common.projectWizard.step2.storedToken' => 'Kayıtlı Token',
			'common.projectWizard.step2.newToken' => 'Yeni Token',
			'common.projectWizard.step2.nonePublic' => 'Yok (Genel)',
			'common.projectWizard.step2.selectToken' => 'Token Seç',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- Bir token seç --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'Bu token sadece bu işlem için kullanılacak',
			'common.projectWizard.step2.publicRepoInfo' => 'Genel depolar kimlik doğrulama gerektirmez. Genel bir depo klonluyorsan token girmeyi atlayabilirsin.',
			'common.projectWizard.step2.noTokensHelp' => 'Kayıtlı token yok. Kolay tekrar kullanım için Ayarlar → API Anahtarları bölümünden token ekleyebilirsin.',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHub Token (Genel Depolar için İsteğe Bağlı)',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (genel depolar için boş bırak)',
			'common.projectWizard.step3.reviewConfig' => 'Yapılandırmanı Gözden Geçir',
			'common.projectWizard.step3.existingWorkspace' => 'Mevcut Çalışma Alanı',
			'common.projectWizard.step3.newWorkspace' => 'Yeni Çalışma Alanı',
			'common.projectWizard.step3.path' => 'Yol:',
			'common.projectWizard.step3.cloneFrom' => 'Şuradan Klonla:',
			'common.projectWizard.step3.authentication' => 'Kimlik Doğrulama:',
			'common.projectWizard.step3.usingStoredToken' => 'Kayıtlı token kullanılıyor:',
			'common.projectWizard.step3.usingProvidedToken' => 'Girilen token kullanılıyor',
			'common.projectWizard.step3.noAuthentication' => 'Kimlik doğrulama yok',
			'common.projectWizard.step3.sshKey' => 'SSH Anahtarı',
			'common.projectWizard.step3.existingInfo' => 'Çalışma alanı proje listene eklenecek ve Claude/Cursor oturumları için kullanılabilir olacak.',
			'common.projectWizard.step3.newWithClone' => 'Depo bu klasöre klonlanacak.',
			'common.projectWizard.step3.newEmpty' => 'Çalışma alanı proje listene eklenecek ve Claude/Cursor oturumları için kullanılabilir olacak.',
			'common.projectWizard.step3.cloningRepository' => 'Depo klonlanıyor...',
			'common.projectWizard.buttons.cancel' => 'İptal',
			'common.projectWizard.buttons.back' => 'Geri',
			'common.projectWizard.buttons.next' => 'İleri',
			'common.projectWizard.buttons.createProject' => 'Projeyi Oluştur',
			'common.projectWizard.buttons.creating' => 'Oluşturuluyor...',
			'common.projectWizard.buttons.cloning' => 'Klonlanıyor...',
			'common.projectWizard.errors.selectType' => 'Lütfen mevcut çalışma alanın olduğunu mu yoksa yeni oluşturmak mı istediğini seç',
			'common.projectWizard.errors.providePath' => 'Lütfen bir çalışma alanı yolu gir',
			'common.projectWizard.errors.failedToCreate' => 'Çalışma alanı oluşturulamadı',
			'common.projectWizard.errors.failedToCreateFolder' => 'Klasör oluşturulamadı',
			'common.notifications.genericTool' => 'bir araç',
			'common.notifications.codes.generic.info.title' => 'Bildirim',
			'common.notifications.codes.permission.required.title' => 'Aksiyon Gerekli',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} kararını bekliyor.',
			'common.notifications.codes.run.stopped.title' => 'Çalıştırma Durduruldu',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => 'Sebep: ${reason}',
			'common.notifications.codes.run.failed.title' => 'Çalıştırma Başarısız',
			'common.notifications.codes.agent.notification.title' => 'Ajan Bildirimi',
			'common.versionUpdate.title' => 'Güncelleme Mevcut',
			'common.versionUpdate.newVersionReady' => 'Yeni bir sürüm hazır',
			'common.versionUpdate.currentVersion' => 'Mevcut Sürüm',
			'common.versionUpdate.latestVersion' => 'Son Sürüm',
			'common.versionUpdate.whatsNew' => 'Yenilikler:',
			'common.versionUpdate.viewFullRelease' => 'Tam sürüm notlarını gör',
			'common.versionUpdate.updateProgress' => 'Güncelleme İlerlemesi:',
			'common.versionUpdate.manualUpgrade' => 'Manuel yükseltme:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'Veya güncellemeyi otomatik çalıştırmak için "Şimdi Güncelle"ye tıkla.',
			'common.versionUpdate.updateCompleted' => 'Güncelleme başarıyla tamamlandı!',
			'common.versionUpdate.restartServer' => 'Değişikliklerin uygulanması için sunucuyu yeniden başlat.',
			'common.versionUpdate.updateFailed' => 'Güncelleme başarısız',
			'common.versionUpdate.buttons.close' => 'Kapat',
			'common.versionUpdate.buttons.later' => 'Daha Sonra',
			'common.versionUpdate.buttons.copyCommand' => 'Komutu Kopyala',
			'common.versionUpdate.buttons.updateNow' => 'Şimdi Güncelle',
			'common.versionUpdate.buttons.updating' => 'Güncelleniyor...',
			'common.versionUpdate.ariaLabels.closeModal' => 'Sürüm yükseltme modalını kapat',
			'common.versionUpdate.ariaLabels.showSidebar' => 'Kenar çubuğunu göster',
			'common.versionUpdate.ariaLabels.settings' => 'Ayarlar',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'Güncelleme mevcut',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'Kenar çubuğunu kapat',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => 'Genel bakış',
			'common.quota.section.quotas' => 'Kotalar',
			'common.quota.section.usage' => 'Kullanım',
			'common.quota.section.agents' => 'Agentlar',
			'common.quota.filter.all' => 'Tümü',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 gün',
			'common.quota.period.k30d' => '30 gün',
			'common.quota.period.all' => 'Tümü',
			'common.quota.group.provider' => 'Sağlayıcı',
			'common.quota.group.model' => 'Model',
			'common.quota.group.agent' => 'Agent',
			'common.quota.group.tool' => 'Araç',
			'common.quota.metric.tokens' => 'Tokenlar',
			'common.quota.metric.input' => 'Girdi',
			'common.quota.metric.output' => 'Çıktı',
			'common.quota.metric.cache' => 'Önbellek okumaları',
			'common.quota.metric.calls' => 'API çağrıları',
			'common.quota.metric.cost' => 'Maliyet',
			'common.quota.metric.sessions' => 'Oturumlar',
			'common.quota.cost.billed' => 'Faturalanan (API + aşım)',
			'common.quota.cost.listPrice' => 'Kullanılan tokenların liste fiyatı',
			'common.quota.cost.subscriptionValue' => 'Aboneliklerle karşılandı',
			'common.quota.cost.cacheSavings' => 'Önbellek tasarrufu',
			'common.quota.cost3.billed' => 'Faturalanan (API + aşım)',
			'common.quota.cost3.listPrice' => 'Kullanılan tokenların liste fiyatı',
			'common.quota.cost3.subscriptionValue' => 'Aboneliklerle karşılandı',
			'common.quota.overview.trendTitle' => 'Tokenlar ve maliyet — son 7 gün',
			'common.quota.overview.effectiveCost' => 'Efektif maliyet (7 gün)',
			'common.quota.overview.alertsTitle' => 'Uyarılar',
			'common.quota.overview.noAlerts' => 'Şu an dikkat gerektiren bir şey yok.',
			'common.quota.overview.limitsTitle' => 'Kullanım ve limitler',
			'common.quota.overview.activeTasks' => 'Aktif görevler',
			'common.quota.overview.viewAccounts' => 'Tüm hesaplar',
			'common.quota.overview.viewAgents' => 'Tüm agentlar',
			'common.quota.overview.noTasks' => 'Şu an çalışan agent yok.',
			'common.quota.usage.trendTitle' => 'Günlük eğilim',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => '${group} bazında döküm',
			'common.quota.usage.colName' => 'İsim',
			'common.quota.usage.sourceUnavailable' => 'Analitik deposu kullanılamıyor; veri gösterilmiyor.',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} çalışıyor',
			'common.quota.agents.colAgent' => 'Agent',
			'common.quota.agents.colStatus' => 'Durum',
			'common.quota.agents.colTask' => 'Görev',
			'common.quota.agents.colModel' => 'Hesap / model',
			'common.quota.agents.colTime' => 'Zaman',
			'common.quota.agents.empty' => 'Bu filtreye uyan agent yok.',
			'common.quota.agents.detailSession' => 'Oturum',
			'common.quota.agents.detailStarted' => 'Başlatıldı',
			'common.quota.agents.detailRetries' => 'Yeniden denemeler',
			'common.quota.agents.detailResult' => 'Sonuç',
			'common.quota.agents.notTracked' => 'izlenmiyor',
			'common.quota.agentStatus.running' => 'Çalışıyor',
			'common.quota.agentStatus.waiting' => 'Bekliyor',
			'common.quota.agentStatus.failed' => 'Başarısız',
			'common.quota.agentStatus.finished' => 'Tamamlandı',
			'common.quota.agentStatus.queued' => 'Sırada',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: mevcut hızda limit ${value} içinde dolacak',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: %${value} kullanıldı (eşik %${watch})',
			'common.quota.backToChat' => 'Sohbete dön',
			'common.quota.syncNow' => 'Şimdi senkronize et',
			'common.quota.generatedAt' => ({required Object value}) => 'Güncellendi: ${value}',
			'common.quota.loading' => 'Hesap limitleri yükleniyor…',
			'common.quota.remaining' => ({required Object value}) => '%${value} kaldı',
			'common.quota.resetsIn' => ({required Object value}) => '${value} içinde sıfırlanır',
			'common.quota.projected' => ({required Object value}) => 'mevcut hızda bu limit ${value} içinde dolacak',
			'common.quota.syncedAgo' => ({required Object value}) => '${value} önce senkronize edildi',
			'common.quota.refreshAccount' => 'Hesabı yenile',
			'common.quota.syncFailed' => 'Senkronizasyon başarısız',
			'common.quota.history' => 'Geçmiş',
			'common.quota.historyPoints' => ({required Object value}) => '${value} okuma kaydedildi',
			'common.quota.historyEmpty' => 'Henüz geçmiş kaydedilmedi',
			'common.quota.noAgents' => 'Atanmış agent yok',
			'common.quota.noSubscription' => 'Abonelik yok',
			'common.quota.noSubscriptionHint' => 'Sağlayıcı bu hesap için aktif bir plan bildirmiyor.',
			'common.quota.quality.live' => 'Canlı',
			'common.quota.quality.cached' => 'Önbellekte',
			'common.quota.quality.estimate' => 'Tahmin',
			'common.quota.quality.unknown' => 'Bilinmiyor',
			'common.quota.quality.error' => 'Hata',
			'common.quota.kpi.atRisk' => 'Riskteki limitler',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => '%${value} üzerindeki hesaplar',
			'common.quota.kpi.windowsAtRisk' => 'Dolan pencereler',
			'common.quota.kpi.errored' => 'Senkronizasyon hataları',
			'common.quota.kpi.activeAgents' => 'Aktif agentlar',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} bekliyor · ${queued} sırada',
			'common.quota.kpi.nextReset' => 'Sonraki sıfırlama',
			'common.quota.kpi.tokens' => 'Tokenlar',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} oturum',
			'common.quota.kpi.cost' => 'Tahmini maliyet',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} planlarla karşılandı',
			'common.quota.empty.title' => 'Bağlı hesap yok',
			'common.quota.empty.description' => 'Kotaların burada izlenmesi için Claude, Codex, Gemini veya CommandCode\'da oturum aç.',
			'common.quota.settings.title' => 'Uyarılar ve yönlendirme',
			'common.quota.settings.description' => 'Panelin ne zaman uyardığını ve yeni işler için hesapların nasıl önerildiğini kontrol et.',
			'common.quota.settings.alertsEnabled' => 'Tahmine dayalı ve eşik uyarıları',
			'common.quota.settings.alertsEnabledHint' => 'Bir limit mevcut hızda dolmadan uyar, yalnızca %90’da değil.',
			'common.quota.settings.watchThreshold' => 'İzleme eşiği (%)',
			'common.quota.settings.dangerThreshold' => 'Tehlike eşiği (%)',
			'common.quota.settings.routingMode' => 'Yönlendirme',
			'common.quota.settings.routing.manual' => 'Manuel — yalnızca öneri',
			'common.quota.settings.routing.ask' => 'Hesap değiştirmeden önce sor',
			'common.quota.settings.routing.autoLowRisk' => 'Düşük riskli görevler için otomatik geçiş',
			'common.quota.settings.logSources' => 'Kaynak günlükleri',
			'common.quota.settings.logSourcesHint' => 'Kullanım ve agent ekranları bu salt okunur kaynakları okur.',
			'common.quota.settings.quotaConsent' => 'Kota sorgulamasına izin ver',
			'common.quota.settings.quotaConsentHint' => 'Canlı limitleri okumak için kayıtlı kimlik bilgilerinle sağlayıcı uç noktalarını sorgular.',
			'common.quota.settings.perAccount' => 'Hesap bazlı geçersiz kılmalar',
			'common.quota.settings.tab' => 'Control Center ayarları',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'Tümü',
			'common.actions.cancel' => 'İptal',
			'common.actions.retry' => 'Yeniden dene',
			'common.actions.save' => 'Kaydet',
			'common.browserPane.address' => 'Adres',
			'common.browserPane.back' => 'Geri',
			'common.browserPane.connecting' => 'Tarayıcıya bağlanıyor…',
			'common.browserPane.connectionFailed' => 'Tarayıcı bağlantısı başarısız.',
			'common.browserPane.couldNotLoad' => ({required Object url}) => '${url} yüklenemedi',
			'common.browserPane.disconnected' => 'Tarayıcı görünümü bağlantısı kesildi',
			'common.browserPane.enterUrl' => 'URL girin',
			'common.browserPane.forward' => 'İleri',
			'common.browserPane.invalidUrl' => 'Geçerli bir http(s) URL’si girin',
			'common.browserPane.noAuthToken' => 'Kimlik doğrulama jetonu yok.',
			'common.browserPane.openExternal' => 'Sistem tarayıcısında aç',
			'common.browserPane.reload' => 'Yenile',
			'common.browserPane.retry' => 'Yeniden dene',
			'common.browserPane.stop' => 'Durdur',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} etkin',
			'common.browserUse.cancel' => 'İptal',
			'common.browserUse.close' => 'Kapat',
			'common.browserUse.delete' => 'Sil',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} kalıcı olarak silinecek.',
			'common.browserUse.deleteSession' => 'Oturumu sil',
			'common.browserUse.deleteTitle' => 'Tarayıcı oturumu silinsin mi?',
			'common.browserUse.empty.descDisabled' => 'Aracıların izlenen tarayıcı oturumları açabilmesi için ayarlarda Browser’ı etkinleştirin.',
			'common.browserUse.empty.descEnabled' => 'Bir AI görevi Browser kullanırken aracı tarayıcı oturumları burada görünür.',
			'common.browserUse.empty.titleDisabled' => 'Browser devre dışı',
			'common.browserUse.empty.titleEnabled' => 'Henüz tarayıcı oturumu yok',
			'common.browserUse.emptyStatus' => 'boş',
			'common.browserUse.errors.actionFailed' => 'Tarayıcı eylemi başarısız',
			'common.browserUse.errors.loadFailed' => 'Browser yüklenemedi',
			'common.browserUse.fullscreen' => 'Tam ekran',
			'common.browserUse.installRuntime' => 'Runtime’ı kur',
			'common.browserUse.installing' => 'Kuruluyor...',
			'common.browserUse.lastAction' => 'Son eylem',
			'common.browserUse.nextSnapshot' => 'Aracının bir sonraki tarayıcı anlık görüntüsü burada gösterilecek.',
			'common.browserUse.noPageLoaded' => 'Sayfa yüklenmedi',
			'common.browserUse.noSessions' => 'Aracı tarayıcı oturumu yok.',
			'common.browserUse.none' => 'Yok',
			'common.browserUse.openSettings' => 'Browser ayarlarını aç',
			'common.browserUse.profile' => 'Profil',
			'common.browserUse.promptLabel' => 'Prompt',
			'common.browserUse.prompts.prompt1' => 'Ödeme akışını incelemek ve bozuk UI durumlarını bildirmek için Browser’ı kullanın.',
			'common.browserUse.prompts.prompt2' => '<url> adresini Browser ile açın, sayfayla etkileşime girin ve her adımdan sonra neyin değiştiğini özetleyin.',
			'common.browserUse.refresh' => 'Tarayıcı oturumlarını yenile',
			'common.browserUse.relative.daysAgo' => ' g önce',
			'common.browserUse.relative.hoursAgo' => ' sa önce',
			'common.browserUse.relative.justNow' => 'Az önce',
			'common.browserUse.relative.minutesAgo' => ' dk önce',
			'common.browserUse.relative.never' => 'Hiç',
			'common.browserUse.relative.secondsAgo' => ' sn önce',
			'common.browserUse.relative.unknown' => 'Bilinmiyor',
			'common.browserUse.runtime.disabled' => 'Devre dışı',
			'common.browserUse.runtime.installing' => 'Kuruluyor',
			'common.browserUse.runtime.ready' => 'Hazır',
			'common.browserUse.runtime.setupRequired' => 'Kurulum gerekli',
			'common.browserUse.runtimeSetup' => 'Runtime kurulumu gerekli',
			'common.browserUse.selected' => 'Seçili',
			'common.browserUse.sessionFallback' => 'Tarayıcı oturumu',
			'common.browserUse.sessionScreenshot' => 'Tarayıcı oturumu ekran görüntüsü',
			'common.browserUse.sessions' => 'Oturumlar',
			'common.browserUse.status' => 'Durum',
			'common.browserUse.stop' => 'Durdur',
			'common.browserUse.stopSession' => 'Oturumu durdur',
			'common.browserUse.subtitle' => 'AI aracılarının açtığı tarayıcı oturumlarını izleyin.',
			'common.browserUse.temporary' => 'Geçici',
			'common.browserUse.thisSession' => 'Bu oturum',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => 'toplam ${count}',
			'common.browserUse.updated' => ({required Object time}) => 'Güncellendi: ${time}',
			'common.browserUse.waiting' => 'Bekleniyor',
			'common.browserUse.waitingForScreenshot' => 'Ekran görüntüsü bekleniyor',
			'common.commandPalette.backToAll' => 'Tümüne dön',
			'common.commandPalette.backspaceHint' => 'Geri dönmek için Geri tuşu',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'Tüm dallara göz at (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'Tüm commitlere göz at (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'Tüm dosyalara göz at (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'Tüm oturumlara göz at (${count})',
			'common.commandPalette.compare.costNote' => 'Maliyet, yayınlanan token ücretlerinden istemci tarafında hesaplanan bir tahmindir; bilinmeyen modeller “—” gösterir.',
			'common.commandPalette.compare.estCost' => 'Tahmini maliyet',
			'common.commandPalette.compare.inputOutput' => 'Girdi / Çıktı',
			'common.commandPalette.compare.model' => 'Model',
			'common.commandPalette.compare.na' => 'Yok',
			'common.commandPalette.compare.openSplit' => 'Bölünmüş görünümde aç',
			'common.commandPalette.compare.provider' => 'Sağlayıcı',
			'common.commandPalette.compare.selectSession' => 'Oturum seçin…',
			'common.commandPalette.compare.tokensUsed' => 'Kullanılan tokenlar',
			'common.commandPalette.groups.actions' => 'Eylemler',
			'common.commandPalette.groups.branches' => 'Dallar',
			'common.commandPalette.groups.commits' => 'Commitler',
			'common.commandPalette.groups.files' => 'Dosyalar',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'Gezinti',
			'common.commandPalette.groups.sessions' => 'Oturumlar',
			'common.commandPalette.groups.settings' => 'Ayarlar',
			'common.commandPalette.hints.close' => 'Kapat',
			'common.commandPalette.hints.navigate' => 'Gezin',
			'common.commandPalette.hints.select' => 'Seç',
			'common.commandPalette.hints.togglePalette' => 'Paleti aç/kapat',
			'common.commandPalette.items.compareSessions' => 'Oturumları karşılaştır',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => 'Ayarları aç',
			'common.commandPalette.items.selectProjectFirst' => 'Önce bir proje seçin',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => 'Ayarlar: ${label}',
			'common.commandPalette.items.startNewChat' => 'Yeni sohbet başlat',
			'common.commandPalette.items.switchTo' => ({required Object name}) => 'Şuna geç: ${name}',
			'common.commandPalette.items.toggleTheme' => 'Temayı değiştir',
			'common.commandPalette.items.tokensAndCost' => 'tokenlar ve maliyet',
			'common.commandPalette.nav.board' => 'Aracı Panosuna git',
			'common.commandPalette.nav.chat' => 'Sohbete git',
			'common.commandPalette.nav.files' => 'Dosyalara git',
			'common.commandPalette.nav.git' => 'Git’e git',
			'common.commandPalette.nav.sourceControl' => 'Kaynak Denetimine git',
			'common.commandPalette.nav.tasks' => 'Görevlere git',
			'common.commandPalette.nav.usage' => 'Kota ve Kullanıma git',
			'common.commandPalette.noResults' => 'Sonuç yok.',
			'common.commandPalette.pages.actions' => 'Eylemler',
			'common.commandPalette.pages.branches' => 'Dallar',
			'common.commandPalette.pages.commits' => 'Commitler',
			'common.commandPalette.pages.compare' => 'Karşılaştır',
			'common.commandPalette.pages.files' => 'Dosyalar',
			'common.commandPalette.pages.sessions' => 'Oturumlar',
			'common.commandPalette.placeholder' => 'Aramak için yazın…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => '${page} içinde ara…',
			'common.commandPalette.title' => 'Komut paleti',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} ileride',
			'common.gitPanel.aheadLabel' => 'ileride',
			'common.gitPanel.aiSuggest' => 'AI önerisi',
			'common.gitPanel.aiSuggestTitle' => 'AI ile commit mesajı oluştur',
			'common.gitPanel.all' => 'Tümü',
			'common.gitPanel.allStaged' => 'Tüm değişiklikler hazırlandı',
			'common.gitPanel.behind' => ({required Object count}) => '${count} geride',
			'common.gitPanel.behindLabel' => 'geride',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => '“${branch}” dalı silinsin mi? Normal silme yalnızca dal tamamen birleştirilmişse başarılı olur. Geri alınamaz.',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => '“${branch}” dalına geçilsin mi? Commit edilmemiş değişikliğiniz olmadığından emin olun.',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} yerel, ${remote} uzak',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} yerel',
			'common.gitPanel.branches.current' => 'geçerli',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => '${branch} dalını sil',
			'common.gitPanel.branches.emptyDesc' => 'Paralel çalışmaya başlamak için bir dal oluşturun.',
			'common.gitPanel.branches.forceDelete' => 'Silmeye zorla',
			'common.gitPanel.branches.forceDeleteDesc' => 'Başka bir yere birleştirilmemiş commitler içerse bile dalı kalıcı olarak kaldırır.',
			'common.gitPanel.branches.forceDeleteLabel' => 'Birleştirilmemiş bu dalı silmeye zorla',
			'common.gitPanel.branches.local' => 'Yerel',
			'common.gitPanel.branches.kNew' => 'Yeni dal',
			'common.gitPanel.branches.noMatch' => 'Aramanızla eşleşen dal yok',
			'common.gitPanel.branches.none' => 'Dal bulunamadı',
			'common.gitPanel.branches.remote' => 'uzak',
			'common.gitPanel.branches.kSwitch' => 'Geç',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => '${branch} dalına geç',
			'common.gitPanel.cancel' => 'İptal',
			'common.gitPanel.changesCount' => ({required Object count}) => 'Değişiklikler (${count})',
			'common.gitPanel.clearSearch' => 'Aramayı temizle',
			'common.gitPanel.collapseDiff' => 'Diff’i daralt',
			'common.gitPanel.commit' => 'Commit',
			'common.gitPanel.commitChanges' => 'Değişiklikleri Commit Et',
			'common.gitPanel.commitFiles' => ({required Object count}) => '${count} dosyayı commit et',
			'common.gitPanel.committing' => 'Commit ediliyor...',
			'common.gitPanel.confirmActions.commit' => 'Onayla',
			'common.gitPanel.confirmActions.delete' => 'Sil',
			'common.gitPanel.confirmActions.deleteBranch' => 'Sil',
			'common.gitPanel.confirmActions.discard' => 'Vazgeç',
			'common.gitPanel.confirmActions.publish' => 'Yayınla',
			'common.gitPanel.confirmActions.pull' => 'Pull',
			'common.gitPanel.confirmActions.push' => 'Push',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'Commiti geri al',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => '${count} dosya şu mesajla commit edilsin mi: “${message}”?',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => 'İzlenmeyen “${file}” dosyası silinsin mi? Geri alınamaz.',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => '“${file}” üzerindeki tüm değişikliklerden vazgeçilsin mi? Geri alınamaz.',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => '“${branch}” dalı ${remote} uzak sunucusuna yayınlansın mı?',
			'common.gitPanel.confirmPull' => ({required Object remote, required Object count}) => '${remote} uzak sunucusundan ${count} commit çekilsin mi?',
			'common.gitPanel.confirmPush' => ({required Object remote, required Object count}) => '${remote} uzak sunucusuna ${count} commit gönderilsin mi?',
			'common.gitPanel.confirmRevert' => 'Son yerel commit geri alınsın mı? Commiti kaldırır ama değişiklikleri hazır durumda tutar.',
			'common.gitPanel.confirmTitles.commit' => 'Eylemi Onayla',
			'common.gitPanel.confirmTitles.delete' => 'Dosyayı Sil',
			'common.gitPanel.confirmTitles.deleteBranch' => 'Dalı Sil',
			'common.gitPanel.confirmTitles.discard' => 'Değişikliklerden Vazgeç',
			'common.gitPanel.confirmTitles.publish' => 'Dalı Yayınla',
			'common.gitPanel.confirmTitles.pull' => 'Pull’u Onayla',
			'common.gitPanel.confirmTitles.push' => 'Push’u Onayla',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'Yerel Commiti Geri Al',
			'common.gitPanel.createBranch' => 'Yeni dal oluştur',
			'common.gitPanel.creating' => 'Oluşturuluyor...',
			'common.gitPanel.delete' => 'Sil',
			'common.gitPanel.deleteUntracked' => 'İzlenmeyen dosyayı sil',
			'common.gitPanel.deselectAll' => 'Tümünün seçimini kaldır',
			'common.gitPanel.discard' => 'Vazgeç',
			'common.gitPanel.discardChanges' => 'Değişikliklerden vazgeç',
			'common.gitPanel.dismiss' => 'Kapat',
			'common.gitPanel.dismissError' => 'Hatayı kapat',
			'common.gitPanel.errors.createBranchFailed' => 'Dal oluşturma başarısız',
			'common.gitPanel.errors.createWorktreeFailed' => 'Worktree oluşturulamadı',
			'common.gitPanel.errors.deleteBranchFailed' => 'Dal silme başarısız',
			'common.gitPanel.errors.fetchFailed' => 'Fetch başarısız',
			'common.gitPanel.errors.initFailed' => 'Depo başlatılamadı',
			'common.gitPanel.errors.initialCommitFailed' => 'İlk commit oluşturulamadı',
			'common.gitPanel.errors.mergeFailed' => 'Birleştirme başarısız',
			'common.gitPanel.errors.openWorktreeFailed' => 'Worktree açılamadı',
			'common.gitPanel.errors.operationFailed' => 'Git işlemi başarısız',
			'common.gitPanel.errors.publishFailed' => 'Yayınlama başarısız',
			'common.gitPanel.errors.pullFailed' => 'Pull başarısız',
			'common.gitPanel.errors.pushFailed' => 'Push başarısız',
			'common.gitPanel.errors.removeWorktreeFailed' => 'Worktree kaldırılamadı',
			'common.gitPanel.errors.stageFailed' => 'Hazırlama başarısız',
			'common.gitPanel.errors.stageHunksFailed' => 'Parça hazırlama başarısız',
			'common.gitPanel.errors.switchFailed' => 'Dal değiştirme başarısız',
			'common.gitPanel.errors.unstageFailed' => 'Hazırlık geri alma başarısız',
			'common.gitPanel.errors.unstageHunksFailed' => 'Parça hazırlık geri alma başarısız',
			'common.gitPanel.expandDiff' => 'Diff’i genişlet',
			'common.gitPanel.fetch' => 'Fetch',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => '${remote} üzerinden fetch',
			'common.gitPanel.fetching' => 'Fetch ediliyor…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} dosya seçildi',
			'common.gitPanel.generating' => 'Oluşturuluyor...',
			'common.gitPanel.history.added' => 'Eklenen',
			'common.gitPanel.history.author' => 'Yazar',
			'common.gitPanel.history.changedFiles' => 'Değiştirilen Dosyalar',
			'common.gitPanel.history.date' => 'Tarih',
			'common.gitPanel.history.empty' => 'Commit bulunamadı',
			'common.gitPanel.history.files' => 'Dosyalar',
			'common.gitPanel.history.removed' => 'Kaldırılan',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'Birleştirildikten sonra worktree’yi kaldır ve dalını sil',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'Birleştirmeden sonra temizle',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} commit',
			'common.gitPanel.mergeWorktree.merge' => 'Birleştir',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => '\'${branch}\' dalını birleştir',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.mergeWorktree.messageLabel' => 'Commit mesajı',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => '${commits} commitin tümünü ${branch} üzerinde tek committe birleştir',
			'common.gitPanel.mergeWorktree.squashLabel' => 'Commitleri sıkıştır (squash)',
			'common.gitPanel.mergeWorktree.squashMerge' => 'Squash ve Birleştir',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => '\'${branch}\' dalını squash-birleştir',
			'common.gitPanel.mergeWorktree.title' => 'Worktree’yi Birleştir',
			'common.gitPanel.merging' => 'Birleştiriliyor...',
			'common.gitPanel.messagePlaceholder' => 'Mesaj (commit için Ctrl+Enter)',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => 'Geçerli daldan (${branch}) yeni bir dal oluşturur',
			'common.gitPanel.newBranch.nameLabel' => 'Dal Adı',
			'common.gitPanel.newBranch.submit' => 'Dal Oluştur',
			'common.gitPanel.newBranch.title' => 'Yeni Dal Oluştur',
			'common.gitPanel.newWorktree.branchLabel' => 'Dal',
			'common.gitPanel.newWorktree.createFrom' => 'Şuradan oluştur',
			'common.gitPanel.newWorktree.description' => 'Bir dalı kendi klasöründe kullanıma al ve üzerinde paralel çalış.',
			'common.gitPanel.newWorktree.existingBranch' => 'Mevcut dal — olduğu gibi kullanıma alınır.',
			'common.gitPanel.newWorktree.submit' => 'Worktree Oluştur',
			'common.gitPanel.newWorktree.switchAfter' => 'Oluşturduktan sonra worktree’ye geç',
			'common.gitPanel.newWorktree.title' => 'Yeni Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => 'Şurada oluşturulacak',
			'common.gitPanel.noChanges' => 'Değişiklik algılanmadı',
			'common.gitPanel.noChangesToCommit' => 'Commit edilecek değişiklik yok',
			'common.gitPanel.noCommits.create' => 'İlk Commiti Oluştur',
			'common.gitPanel.noCommits.creating' => 'İlk Commit Oluşturuluyor...',
			'common.gitPanel.noCommits.description' => 'Bu depoda henüz commit yok. Değişiklikleri izlemeye başlamak için ilk commitinizi oluşturun.',
			'common.gitPanel.noCommits.title' => 'Henüz commit yok',
			'common.gitPanel.noMatchingBranches' => 'Eşleşen dal yok',
			'common.gitPanel.noRepo.description' => 'Bu proje henüz bir git deposu değil. Değişiklikleri izlemek ve kaynak denetimi özelliklerini kullanmak için bir tane başlatın.',
			'common.gitPanel.noRepo.init' => 'git init çalıştır',
			'common.gitPanel.noRepo.initializing' => 'Depo başlatılıyor...',
			'common.gitPanel.noRepo.title' => 'Git deposu yok',
			'common.gitPanel.noStagedFiles' => 'Hazırlanmış dosya yok',
			'common.gitPanel.none' => 'Yok',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => '${remote} uzak sunucusuna gönderilecek bir şey yok',
			'common.gitPanel.openFile' => 'Dosyayı açmak için tıklayın',
			'common.gitPanel.publish' => 'Yayınla',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => '“${branch}” dalını ${remote} uzak sunucusuna yayınla',
			'common.gitPanel.publishing' => 'Yayınlanıyor…',
			'common.gitPanel.pull' => 'Pull',
			'common.gitPanel.pullCount' => ({required Object count}) => 'Pull ${count}',
			'common.gitPanel.pullTitle' => ({required Object remote, required Object count}) => '${remote} üzerinden ${count} çek',
			'common.gitPanel.pulling' => 'Çekiliyor…',
			'common.gitPanel.push' => 'Push',
			'common.gitPanel.pushCount' => ({required Object count}) => 'Push ${count}',
			'common.gitPanel.pushTitle' => ({required Object remote, required Object count}) => '${remote} uzak sunucusuna ${count} gönder',
			'common.gitPanel.pushing' => 'Gönderiliyor…',
			'common.gitPanel.recentCommits' => 'Son commitler',
			'common.gitPanel.refresh' => 'Git durumunu yenile',
			'common.gitPanel.remove' => 'Kaldır',
			'common.gitPanel.removeWorktree.alsoDelete' => 'Dalı da sil',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => '${branch} için worktree kaldırılsın mı? Klasörü silinir ve bağlı proje arşivlenir — sohbet oturumları kurtarılabilir kalır.',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'Bu worktree’de kaybolacak ${count} commit edilmemiş değişiklik var.',
			'common.gitPanel.removeWorktree.discardChanges' => 'Commit edilmemiş değişikliklerden vazgeç',
			'common.gitPanel.removeWorktree.title' => 'Worktree’yi Kaldır',
			'common.gitPanel.removing' => 'Kaldırılıyor...',
			'common.gitPanel.revertLatest' => 'Son yerel commiti geri al',
			'common.gitPanel.scroll' => 'Kaydır',
			'common.gitPanel.searchBranches' => 'Dal ara...',
			'common.gitPanel.selectAll' => 'Tümünü seç',
			'common.gitPanel.selectProject' => 'Kaynak denetimini görüntülemek için bir proje seçin',
			'common.gitPanel.selectedOf' => ({required Object total, required Object selected}) => '${total} dosyadan ${selected} seçildi',
			'common.gitPanel.selectedOfMobile' => ({required Object total, required Object selected}) => '${total} içinden ${selected} seçildi',
			'common.gitPanel.sideBySide' => 'Yan yana',
			'common.gitPanel.stageAll' => 'Tümünü hazırla',
			'common.gitPanel.stageHunk' => 'Bu parçayı hazırla',
			'common.gitPanel.staged' => ({required Object count}) => 'Hazırlananlar (${count})',
			'common.gitPanel.status.added' => 'Eklendi',
			'common.gitPanel.status.deleted' => 'Silindi',
			'common.gitPanel.status.modified' => 'Değiştirildi',
			'common.gitPanel.status.untracked' => 'İzlenmiyor',
			'common.gitPanel.statusGuide' => 'Dosya Durumu Kılavuzu',
			'common.gitPanel.switchScroll' => 'Yatay kaydırmaya geç',
			'common.gitPanel.switchSplit' => 'Yan yana görünüme geç',
			'common.gitPanel.switchUnified' => 'Birleşik görünüme geç',
			'common.gitPanel.switchWrap' => 'Metin kaydırmaya geç',
			'common.gitPanel.unified' => 'Birleşik',
			'common.gitPanel.unstageAll' => 'Tüm hazırlıkları geri al',
			'common.gitPanel.unstageHunk' => 'Bu parçanın hazırlığını geri al',
			'common.gitPanel.upToDate' => 'Güncel',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => '${remote} ile güncel',
			'common.gitPanel.viewAll' => 'Tümünü gör',
			'common.gitPanel.viewsAria' => 'Kaynak denetimi görünümleri',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} değişiklik',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} worktree',
			'common.gitPanel.worktrees.createFirst' => 'İlk worktree’nizi oluşturun',
			'common.gitPanel.worktrees.detached' => 'ayrık',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => 'ayrık @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => 'ayrık HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'Worktree, bir dalı kendi klasöründe kullanıma alır; böylece ayrı sohbet oturumlarını yan yana çalıştırabilir ve sonuçları hazır olduğunda birleştirebilirsiniz.',
			'common.gitPanel.worktrees.emptyTitle' => 'Dallar üzerinde paralel çalışın',
			'common.gitPanel.worktrees.locked' => 'kilitli',
			'common.gitPanel.worktrees.mainWorktree' => 'ana worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => '${branch} dalını temel dala birleştir',
			'common.gitPanel.worktrees.kNew' => 'Yeni worktree',
			'common.gitPanel.worktrees.none' => 'Worktree yok',
			'common.gitPanel.worktrees.nothingToMerge' => 'Birleştirilecek bir şey yok — temel dalın ilerisinde commit yok',
			'common.gitPanel.worktrees.open' => 'Aç',
			'common.gitPanel.worktrees.refresh' => 'Worktreeleri yenile',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => '${branch} için worktree’yi kaldır',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => '${branch} dalına geç',
			'common.gitPanel.wrap' => 'Kaydır',
			'common.gitPanel.tabs.changes' => 'Değişiklikler',
			'common.gitPanel.tabs.history' => 'Commitler',
			'common.gitPanel.tabs.branches' => 'Branchler',
			'common.gitPanel.tabs.worktrees' => 'Worktreeler',
			'common.sessions.renameSession' => 'Oturumu yeniden adlandır',
			'common.projects.newSession' => 'Yeni oturum',
			'common.codeBlock.wrapLines' => 'Satırları kaydır',
			'common.codeBlock.noWrap' => 'Kaydırma yok',
			'common.update.available' => ({required Object version}) => 'Güncelleme mevcut · v${version}',
			'common.update.confirm' => ({required Object version}) => 'v${version} sürümüne güncellensin mi? Sunucu kendini günceller ve yeniden başlatır — etkin oturumlar kesintiye uğrayacak.',
			'common.update.downloading' => 'Güncelleme indiriliyor ve uygulanıyor…',
			'common.update.restarting' => 'Sunucu yeniden başlatılıyor — bu biraz sürer…',
			'common.update.done' => ({required Object version}) => 'v${version} sürümüne güncellendi. Yeni paketi almak için uygulamayı yeniden yükle.',
			'common.update.manualRestart' => 'Güncelleme uygulandı ancak sunucu kendiliğinden yeniden başlamadı — tamamlamak için elle yeniden başlat.',
			'common.update.failed' => 'Güncelleme başarısız oldu.',
			'common.update.failedTitle' => 'Güncelleme başarısız',
			'common.update.appConfirm' => ({required Object version}) => 'ddagent v${version} bu cihaza kurulsun mu? Android ilk seferde ddagent\'tan yüklemeye izin vermenizi ister.',
			'common.update.appPermission' => 'ddagent için “Bilinmeyen uygulamaları yükle” iznini verin, sonra tekrar Güncelle\'ye dokunun.',
			'settings.title' => 'Ayarlar',
			'settings.changelog.title' => 'Değişiklik günlüğü',
			'settings.changelog.loading' => 'Yükleniyor…',
			'settings.changelog.empty' => 'Gösterilecek sürüm yok',
			'settings.changelog.current' => 'mevcut',
			'settings.changelog.kNew' => 'yeni',
			'settings.server.title' => 'Sunucu',
			'settings.server.description' => 'ddagent sürecini yeniden başlatır — güncelleme sonrası veya takılma durumunda kullanışlıdır.',
			'settings.server.restart' => 'Yeniden başlat',
			'settings.server.restartConfirm' => 'ddagent sunucusu yeniden başlatılsın mı? Aktif oturumlar kesintiye uğrayacak.',
			'settings.server.restarting' => 'Yeniden başlatılıyor… sunucu döndüğünde sayfa yenilenecek.',
			'settings.server.restartFailed' => 'Yeniden başlatma başarısız',
			'settings.server.unsupported' => 'Yeniden başlatma yalnızca sunucu servis yöneticisi altında çalışırken kullanılabilir.',
			'settings.server.ok' => 'Tamam',
			'settings.updates.title' => 'Uygulama güncellemeleri',
			'settings.updates.description' => 'GitHub\'da daha yeni bir masaüstü sürümünü kontrol eder. Yeni sürümler otomatik indirilir ve çıkışta kurulur.',
			'settings.updates.check' => 'Güncellemeleri denetle',
			'settings.updates.checking' => 'Denetleniyor…',
			'settings.updates.upToDate' => ({required Object version}) => 'En güncel sürümü kullanıyorsunuz (v${version}).',
			'settings.updates.available' => ({required Object version}) => 'v${version} güncellemesi bulundu — arka planda indiriliyor; ddagent kapanırken kurulacak.',
			'settings.updates.downloaded' => ({required Object version}) => 'v${version} güncellemesi indirildi — kurmak için ddagent\'ı kapatıp yeniden başlatın.',
			'settings.updates.unavailable' => 'Güncelleme denetimi yalnızca paketlenmiş masaüstü sürümlerinde kullanılabilir.',
			'settings.updates.error' => ({required Object message}) => 'Güncelleme denetimi başarısız: ${message}',
			'settings.updates.errorGeneric' => 'Güncelleme denetimi başarısız.',
			'settings.tabs.account' => 'Hesap',
			'settings.tabs.permissions' => 'İzinler',
			'settings.tabs.mcpServers' => 'MCP Sunucuları',
			'settings.tabs.appearance' => 'Görünüm',
			'settings.tabs.skills' => 'Yetenekler',
			'settings.account.title' => 'Hesap',
			'settings.account.language' => 'Dil',
			'settings.account.languageLabel' => 'Görüntüleme Dili',
			'settings.account.languageDescription' => 'Arayüz için tercih ettiğin dili seç',
			'settings.account.username' => 'Kullanıcı Adı',
			'settings.account.email' => 'E-posta',
			'settings.account.profile' => 'Profil',
			'settings.account.changePassword' => 'Şifreyi Değiştir',
			'settings.mcp.title' => 'MCP Sunucuları',
			'settings.mcp.addServer' => 'Sunucu Ekle',
			'settings.mcp.editServer' => 'Sunucuyu Düzenle',
			'settings.mcp.deleteServer' => 'Sunucuyu Sil',
			'settings.mcp.serverName' => 'Sunucu Adı',
			'settings.mcp.serverType' => 'Sunucu Türü',
			'settings.mcp.config' => 'Yapılandırma',
			'settings.mcp.testConnection' => 'Bağlantıyı Test Et',
			'settings.mcp.status' => 'Durum',
			'settings.mcp.connected' => 'Bağlı',
			'settings.mcp.disconnected' => 'Bağlantı kesildi',
			'settings.mcp.scope.label' => 'Kapsam',
			'settings.mcp.scope.user' => 'Kullanıcı',
			'settings.mcp.scope.project' => 'Proje',
			'settings.appearance.title' => 'Görünüm',
			'settings.appearance.theme' => 'Tema',
			'settings.appearance.codeEditor' => 'Kod Editörü',
			'settings.appearance.editorTheme' => 'Editör Teması',
			'settings.appearance.wordWrap' => 'Kelime Kaydırma',
			'settings.appearance.showMinimap' => 'Minimap\'i Göster',
			'settings.appearance.lineNumbers' => 'Satır Numaraları',
			'settings.appearance.fontSize' => 'Yazı Tipi Boyutu',
			'settings.appearance.themeModes.dark' => 'Koyu',
			'settings.appearance.themeModes.light' => 'Açık',
			'settings.appearance.themeModes.system' => 'Sistem',
			'settings.actions.saveChanges' => 'Değişiklikleri Kaydet',
			'settings.actions.resetToDefaults' => 'Varsayılanlara Döndür',
			'settings.actions.cancelChanges' => 'Değişiklikleri İptal Et',
			'settings.quickSettings.title' => 'Hızlı Ayarlar',
			'settings.quickSettings.sections.appearance' => 'Görünüm',
			'settings.quickSettings.sections.toolDisplay' => 'Araç Gösterimi',
			'settings.quickSettings.sections.inputSettings' => 'Girdi Ayarları',
			'settings.quickSettings.darkMode' => 'Koyu Mod',
			'settings.quickSettings.showRawParameters' => 'Ham parametreleri göster',
			'settings.quickSettings.showThinking' => 'Düşünmeyi göster',
			'settings.quickSettings.sendByCtrlEnter' => 'Ctrl+Enter ile gönder',
			'settings.quickSettings.sendByCtrlEnterDescription' => 'Etkinleştirildiğinde, Ctrl+Enter\'a basmak yalnız Enter yerine mesajı gönderir. IME (girdi metot düzenleyici) kullananlar için yanlışlıkla göndermeyi önler.',
			'settings.quickSettings.dragHandle.dragging' => 'Tutamaç sürükleniyor',
			'settings.quickSettings.dragHandle.closePanel' => 'Ayarlar panelini kapat',
			'settings.quickSettings.dragHandle.openPanel' => 'Ayarlar panelini aç',
			'settings.quickSettings.dragHandle.draggingStatus' => 'Sürükleniyor...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'Açıp kapamak için tıkla, taşımak için sürükle',
			'settings.quickSettings.sendWithCtrlEnter' => 'Ctrl+Enter ile gönder',
			'settings.terminalShortcuts.title' => 'Terminal Kısayolları',
			'settings.terminalShortcuts.sectionKeys' => 'Tuşlar',
			'settings.terminalShortcuts.sectionNavigation' => 'Gezinme',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => 'Yukarı Ok',
			'settings.terminalShortcuts.arrowDown' => 'Aşağı Ok',
			'settings.terminalShortcuts.scrollDown' => 'Aşağı Kaydır',
			'settings.terminalShortcuts.handle.closePanel' => 'Kısayol panelini kapat',
			'settings.terminalShortcuts.handle.openPanel' => 'Kısayol panelini aç',
			'settings.terminalShortcuts.killTitle' => 'Çalışan süreci sonlandır (Ctrl+C)',
			'settings.terminalShortcuts.paste' => 'Yapıştır',
			'settings.mainTabs.label' => 'Ayarlar',
			'settings.mainTabs.agents' => 'Ajanlar',
			'settings.mainTabs.orchestration' => 'Orkestrasyon',
			'settings.mainTabs.appearance' => 'Görünüm',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API ve Token\'lar',
			'settings.mainTabs.models' => 'Modeller',
			'settings.mainTabs.tasks' => 'Görevler',
			'settings.mainTabs.notifications' => 'Bildirimler',
			'settings.mainTabs.about' => 'Hakkında',
			'settings.mainTabs.workspaces' => 'Çalışma alanları',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'Araçlar',
			'settings.mainTabs.quota' => 'Control Center',
			'settings.orchestration.title' => 'Orchestration',
			'settings.orchestration.description' => 'Route chat tasks across your providers and models.',
			'settings.orchestration.loading' => 'Loading orchestration settings…',
			'settings.orchestration.loadError' => 'Could not load the orchestration settings.',
			'settings.orchestration.retry' => 'Retry',
			'settings.orchestration.enable.label' => 'Enable orchestration',
			'settings.orchestration.enable.description' => 'Let the orchestrator pick a model per step instead of running everything on one provider.',
			'settings.orchestration.pool.title' => 'Candidate pool',
			'settings.orchestration.pool.description' => 'Models the router can pick from, each pinned to a cost tier.',
			'settings.orchestration.pool.add' => 'Add candidate',
			'settings.orchestration.pool.empty' => 'No candidates yet — add one to start routing.',
			'settings.orchestration.pool.fields.label' => 'Label',
			'settings.orchestration.pool.fields.labelPlaceholder' => 'e.g. SWE-2 Medium',
			'settings.orchestration.pool.fields.provider' => 'Provider',
			'settings.orchestration.pool.fields.model' => 'Model',
			'settings.orchestration.pool.fields.modelPlaceholder' => 'Select a model',
			'settings.orchestration.pool.fields.effort' => 'Effort',
			'settings.orchestration.pool.fields.effortDefault' => 'Provider default',
			'settings.orchestration.pool.fields.effortPlaceholder' => 'default',
			'settings.orchestration.pool.fields.account' => 'Account',
			'settings.orchestration.pool.fields.accountDefault' => 'Provider default',
			'settings.orchestration.pool.fields.redundantAccounts' => 'Yedek hesaplar',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'Bu sağlayıcı için başka hesap yok',
			'settings.orchestration.pool.fields.tier' => 'Cost tier',
			'settings.orchestration.pool.fields.remove' => 'Remove candidate',
			'settings.orchestration.pool.fields.moveUp' => 'Move up',
			'settings.orchestration.pool.fields.moveDown' => 'Move down',
			'settings.orchestration.tiers.free' => 'Free',
			'settings.orchestration.tiers.cheap' => 'Cheap',
			'settings.orchestration.tiers.mid' => 'Mid',
			'settings.orchestration.tiers.premium' => 'Premium',
			'settings.orchestration.rules.title' => 'Routing rules',
			'settings.orchestration.rules.description' => 'Ordered candidates per task type — the first available one wins.',
			'settings.orchestration.rules.addCandidate' => 'Add candidate…',
			'settings.orchestration.rules.empty' => 'No candidates — nothing to route this task type to.',
			'settings.orchestration.rules.missing' => '(removed)',
			'settings.orchestration.rules.remove' => 'Remove candidate',
			'settings.orchestration.rules.taskTypes.plan' => 'Planning',
			'settings.orchestration.rules.taskTypes.quick' => 'Quick answers',
			'settings.orchestration.rules.taskTypes.research' => 'Research',
			'settings.orchestration.rules.taskTypes.docs' => 'Documentation',
			'settings.orchestration.rules.taskTypes.code' => 'Coding',
			'settings.orchestration.rules.taskTypes.codeHard' => 'Complex coding',
			'settings.orchestration.rules.taskTypes.test' => 'Testing',
			'settings.orchestration.rules.taskTypes.review' => 'Review',
			'settings.orchestration.planner.title' => 'Planner',
			'settings.orchestration.planner.description' => 'How a request is split into routed steps.',
			'settings.orchestration.planner.modeLabel' => 'Planning mode',
			'settings.orchestration.planner.modes.auto' => 'Auto (LLM)',
			'settings.orchestration.planner.modes.template' => 'Templates',
			'settings.orchestration.planner.modes.off' => 'Off',
			'settings.orchestration.planner.modeHints.auto' => 'The planner model decomposes each request into typed steps.',
			'settings.orchestration.planner.modeHints.template' => 'Requests run through a fixed pipeline you pick below.',
			'settings.orchestration.planner.modeHints.off' => 'No planning — the whole request is routed as a single step.',
			'settings.orchestration.planner.candidateLabel' => 'Planner model',
			'settings.orchestration.planner.candidateDescription' => 'Pool candidate used for plan generation and classification calls.',
			'settings.orchestration.planner.candidatePlaceholder' => 'Select a pool candidate',
			'settings.orchestration.planner.templates.title' => 'Pipeline templates',
			'settings.orchestration.planner.templates.add' => 'Add template',
			'settings.orchestration.planner.templates.namePlaceholder' => 'Template name',
			'settings.orchestration.planner.templates.addStep' => 'Add step…',
			'settings.orchestration.planner.templates.remove' => 'Remove template',
			'settings.orchestration.planner.templates.removeStep' => 'Remove step',
			'settings.orchestration.planner.templates.empty' => 'No templates yet.',
			'settings.orchestration.planner.templates.emptySteps' => 'No steps yet — add one below.',
			'settings.orchestration.planner.requireConfirm' => 'Confirm plan before running',
			'settings.orchestration.planner.requireConfirmDescription' => 'Pause after planning so you can edit or disable steps on the plan card.',
			'settings.orchestration.execution.title' => 'Execution limits',
			'settings.orchestration.execution.description' => 'Guardrails for parallel runs and fix loops.',
			'settings.orchestration.execution.maxParallel' => 'Max parallel steps',
			'settings.orchestration.execution.maxParallelDescription' => 'How many subtasks may run at once (1–8).',
			'settings.orchestration.execution.maxFixLoops' => 'Max fix loops',
			'settings.orchestration.execution.maxFixLoopsDescription' => 'Retries when a step fails verification (0–5).',
			'settings.orchestration.execution.onNoCandidate' => 'When no candidate is available',
			'settings.orchestration.execution.onNoCandidateDescription' => 'Ask before falling back, or skip the step.',
			'settings.orchestration.execution.onNoCandidateOptions.ask' => 'Ask',
			'settings.orchestration.execution.onNoCandidateOptions.skip' => 'Skip step',
			'settings.orchestration.execution.useWorktree' => 'Isolated worktree',
			'settings.orchestration.execution.useWorktreeDescription' => 'Run all delegated steps in one shared git worktree instead of the project directory.',
			'settings.orchestration.save.unsaved' => 'Unsaved changes',
			'settings.orchestration.save.save' => 'Save',
			'settings.orchestration.save.saving' => 'Saving…',
			'settings.orchestration.save.saved' => 'Saved',
			'settings.orchestration.save.discard' => 'Discard',
			'settings.orchestration.save.error' => 'Save failed',
			'settings.orchestration.save.emptyPool' => 'Add at least one candidate before saving.',
			'settings.notifications.title' => 'Bildirimler',
			'settings.notifications.description' => 'Hangi bildirim etkinliklerini alacağını kontrol et.',
			'settings.notifications.webPush.title' => 'Web Push Bildirimleri',
			'settings.notifications.webPush.enable' => 'Push Bildirimlerini Etkinleştir',
			'settings.notifications.webPush.disable' => 'Push Bildirimlerini Devre Dışı Bırak',
			'settings.notifications.webPush.enabled' => 'Push bildirimleri etkin',
			'settings.notifications.webPush.loading' => 'Güncelleniyor...',
			'settings.notifications.webPush.unsupported' => 'Bu tarayıcıda push bildirimleri desteklenmiyor.',
			'settings.notifications.webPush.denied' => 'Push bildirimleri engellendi. Lütfen tarayıcı ayarlarından izin ver.',
			'settings.notifications.webPush.iosHint' => 'iPhone/iPad’de bildirimler yalnızca ddagent ana ekrana eklendikten sonra (Paylaş → Ana Ekrana Ekle) ve kurulu uygulamada etkinleştirildikten sonra çalışır.',
			'settings.notifications.webPush.test' => 'Test bildirimi gönder',
			'settings.notifications.webPush.testNoSubscription' => 'Abone cihaz yok. Önce telefonda “Etkinleştir”e dokunun.',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => '${count} cihaza gönderildi. Telefonda bir şey görünmezse ddagent’ı ana ekrana ekleyin (iOS bunu gerektirir).',
			'settings.notifications.webPush.testNotDelivered' => 'Erişilebilir cihaz yoktu. Uygulamanın çalıştığından ve bildirimlerin etkin olduğundan emin olun.',
			'settings.notifications.device.title' => 'Bu cihazı bilgilendir',
			'settings.notifications.device.enabled' => 'Bu cihaz için bildirimler etkin',
			'settings.notifications.sound.title' => 'Ses',
			'settings.notifications.sound.description' => 'Sohbet çalışması tamamlandığında kısa bir ton çal.',
			'settings.notifications.sound.enabled' => 'Etkin',
			'settings.notifications.sound.test' => 'Sesi test et',
			'settings.notifications.events.title' => 'Etkinlik Türleri',
			'settings.notifications.events.actionRequired' => 'Aksiyon gerekli',
			'settings.notifications.events.stop' => 'Çalıştırma durduruldu',
			'settings.notifications.events.error' => 'Çalıştırma başarısız',
			'settings.notifications.desktop.title' => 'Bu masaüstü uygulamasına bildir',
			'settings.notifications.desktop.enable' => 'Push Bildirimlerini Etkinleştir',
			'settings.notifications.desktop.disable' => 'Push Bildirimlerini Devre Dışı Bırak',
			'settings.notifications.desktop.enabled' => 'Bu masaüstü uygulaması için bildirimler etkin',
			'settings.notifications.desktop.unsupported' => 'Bu sistemde masaüstü bildirimleri desteklenmiyor.',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.unpair' => 'Eşleştirmeyi kaldır',
			'settings.appearanceSettings.darkMode.label' => 'Koyu Mod',
			'settings.appearanceSettings.darkMode.description' => 'Açık ve koyu temalar arasında geçiş yap',
			'settings.appearanceSettings.codeEditor.title' => 'Kod Editörü',
			'settings.appearanceSettings.codeEditor.theme.label' => 'Editör Teması',
			'settings.appearanceSettings.codeEditor.theme.description' => 'Kod editörü için varsayılan tema',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => 'Kelime Kaydırma',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'Editörde kelime kaydırmayı varsayılan olarak etkinleştir',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'Minimap\'i Göster',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => 'Diff görünümünde kolay gezinme için minimap göster',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => 'Satır Numaralarını Göster',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'Editörde satır numaralarını göster',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'Yazı Tipi Boyutu',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'Editör yazı tipi boyutu (piksel)',
			'settings.appearanceSettings.terminal.title' => 'Terminal',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'Odak işaretçiyi takip etsin',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'Fareyi üzerine getirdiğinde yazmak için terminali odakla',
			'settings.mcpForm.title.add' => 'MCP Sunucusu Ekle',
			'settings.mcpForm.title.edit' => 'MCP Sunucusunu Düzenle',
			'settings.mcpForm.importMode.form' => 'Form Girdisi',
			'settings.mcpForm.importMode.json' => 'JSON İçe Aktar',
			'settings.mcpForm.scope.label' => 'Kapsam',
			'settings.mcpForm.scope.userGlobal' => 'Kullanıcı (Genel)',
			'settings.mcpForm.scope.projectLocal' => 'Proje (Yerel)',
			'settings.mcpForm.scope.userDescription' => 'Kullanıcı kapsamı: Makinendeki tüm projelerde kullanılabilir',
			'settings.mcpForm.scope.projectDescription' => 'Yerel kapsam: Yalnızca seçili projede kullanılabilir',
			'settings.mcpForm.scope.cannotChange' => 'Mevcut bir sunucu düzenlenirken kapsam değiştirilemez',
			'settings.mcpForm.fields.serverName' => 'Sunucu Adı',
			'settings.mcpForm.fields.transportType' => 'Taşıma Türü',
			'settings.mcpForm.fields.command' => 'Komut',
			'settings.mcpForm.fields.arguments' => 'Argümanlar (satır başına bir tane)',
			'settings.mcpForm.fields.jsonConfig' => 'JSON Yapılandırması',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => 'Ortam Değişkenleri (KEY=değer, satır başına bir tane)',
			'settings.mcpForm.fields.headers' => 'Başlıklar (KEY=değer, satır başına bir tane)',
			'settings.mcpForm.fields.selectProject' => 'Bir proje seç...',
			'settings.mcpForm.placeholders.serverName' => 'benim-sunucum',
			'settings.mcpForm.validation.missingType' => 'Zorunlu alan eksik: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdio türü command alanı gerektirir',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type} türü url alanı gerektirir',
			'settings.mcpForm.validation.invalidJson' => 'Geçersiz JSON formatı',
			'settings.mcpForm.validation.jsonHelp' => 'MCP sunucu yapılandırmanı JSON formatında yapıştır. Örnek formatlar:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => 'Yapılandırma Detayları (${configFile} dosyasından)',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'Yol: ${path}',
			'settings.mcpForm.actions.cancel' => 'İptal',
			'settings.mcpForm.actions.saving' => 'Kaydediliyor...',
			'settings.mcpForm.actions.addServer' => 'Sunucu Ekle',
			'settings.mcpForm.actions.updateServer' => 'Sunucuyu Güncelle',
			'settings.saveStatus.success' => 'Ayarlar başarıyla kaydedildi!',
			'settings.saveStatus.error' => 'Ayarlar kaydedilemedi',
			'settings.saveStatus.saving' => 'Kaydediliyor...',
			'settings.footerActions.save' => 'Ayarları Kaydet',
			'settings.footerActions.cancel' => 'İptal',
			'settings.git.title' => 'Git Yapılandırması',
			'settings.git.description' => 'Commit\'ler için git kimliğini yapılandır. Bu ayarlar git config --global ile genel olarak uygulanacak',
			'settings.git.name.label' => 'Git Adı',
			'settings.git.name.help' => 'Git commit\'leri için adın',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'Git E-postası',
			'settings.git.email.help' => 'Git commit\'leri için e-postan',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => 'Yapılandırmayı Kaydet',
			'settings.git.actions.saving' => 'Kaydediliyor...',
			'settings.git.status.success' => 'Başarıyla kaydedildi',
			'settings.git.status.error' => 'Kaydetme başarısız',
			'settings.apiKeys.title' => 'API Anahtarları',
			'settings.apiKeys.description' => 'Diğer uygulamalardan harici API\'ye erişmek için API anahtarları üret.',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ API Anahtarını Kaydet',
			'settings.apiKeys.newKey.alertMessage' => 'Bu anahtarı yalnızca bu sefer göreceksin. Güvenli bir yerde sakla.',
			'settings.apiKeys.newKey.iveSavedIt' => 'Kaydettim',
			'settings.apiKeys.form.placeholder' => 'API Anahtar Adı (ör. Production Sunucu)',
			'settings.apiKeys.form.createButton' => 'Oluştur',
			'settings.apiKeys.form.cancelButton' => 'İptal',
			'settings.apiKeys.newButton' => 'Yeni API Anahtarı',
			'settings.apiKeys.empty' => 'Henüz API anahtarı oluşturulmamış.',
			'settings.apiKeys.list.created' => 'Oluşturuldu:',
			'settings.apiKeys.list.lastUsed' => 'Son kullanım:',
			'settings.apiKeys.confirmDelete' => 'Bu API anahtarını silmek istediğinden emin misin?',
			'settings.apiKeys.status.active' => 'Aktif',
			'settings.apiKeys.status.inactive' => 'Pasif',
			'settings.apiKeys.github.title' => 'GitHub Token\'ları',
			'settings.apiKeys.github.description' => 'Harici API üzerinden özel depoları klonlamak için GitHub Kişisel Erişim Token\'ları ekle.',
			'settings.apiKeys.github.descriptionAlt' => 'Özel depoları klonlamak için GitHub Kişisel Erişim Token\'ları ekle. Token\'ları saklamadan API isteklerinde doğrudan da geçebilirsin.',
			'settings.apiKeys.github.addButton' => 'Token Ekle',
			'settings.apiKeys.github.form.namePlaceholder' => 'Token Adı (ör. Kişisel Depolar)',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHub Kişisel Erişim Token\'ı (ghp_...)',
			'settings.apiKeys.github.form.descriptionPlaceholder' => 'Açıklama (isteğe bağlı)',
			'settings.apiKeys.github.form.addButton' => 'Token Ekle',
			'settings.apiKeys.github.form.cancelButton' => 'İptal',
			'settings.apiKeys.github.form.howToCreate' => 'GitHub Kişisel Erişim Token\'ı nasıl oluşturulur →',
			'settings.apiKeys.github.form.showToken' => 'Token\'ı göster',
			'settings.apiKeys.github.form.hideToken' => 'Token\'ı gizle',
			'settings.apiKeys.github.empty' => 'Henüz GitHub token\'ı eklenmemiş.',
			'settings.apiKeys.github.added' => 'Eklendi:',
			'settings.apiKeys.github.confirmDelete' => 'Bu GitHub token\'ını silmek istediğinden emin misin?',
			'settings.apiKeys.apiDocsLink' => 'API Dokümantasyonu',
			'settings.apiKeys.documentation.title' => 'Harici API Dokümantasyonu',
			'settings.apiKeys.documentation.description' => 'Uygulamalarından Claude/Cursor oturumları tetiklemek için harici API\'nin nasıl kullanılacağını öğren.',
			'settings.apiKeys.documentation.viewLink' => 'API Dokümantasyonunu Görüntüle →',
			'settings.apiKeys.loading' => 'Yükleniyor...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'Güncelleme mevcut: v${version}',
			'settings.tasks.checking' => 'TaskMaster kurulumu kontrol ediliyor...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLI Kurulu Değil',
			'settings.tasks.notInstalled.description' => 'Görev yönetim özelliklerini kullanmak için TaskMaster CLI gereklidir. Başlamak için kur:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'GitHub\'da Görüntüle',
			'settings.tasks.notInstalled.afterInstallation' => 'Kurulumdan sonra:',
			'settings.tasks.notInstalled.steps.restart' => 'Bu uygulamayı yeniden başlat',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster özellikleri otomatik olarak kullanılabilir hale gelecek',
			'settings.tasks.notInstalled.steps.initCommand' => 'Proje dizininde task-master init komutunu kullan',
			'settings.tasks.settings.enableLabel' => 'TaskMaster Entegrasyonunu Etkinleştir',
			'settings.tasks.settings.enableDescription' => 'TaskMaster görevlerini, banner\'larını ve kenar çubuğu göstergelerini arayüz genelinde göster',
			'settings.agents.authStatus.checking' => 'Kontrol ediliyor...',
			'settings.agents.authStatus.connected' => 'Bağlı',
			'settings.agents.authStatus.notConnected' => 'Bağlı değil',
			'settings.agents.authStatus.disconnected' => 'Bağlantı kesildi',
			'settings.agents.authStatus.checkingAuth' => 'Kimlik doğrulama durumu kontrol ediliyor...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => '${email} olarak giriş yapıldı',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider} hesabı',
			'settings.agents.authStatus.authenticatedUser' => 'kimliği doğrulanmış kullanıcı',
			'settings.agents.install.title' => ({required Object agent}) => '${agent} CLI kurulu değil',
			'settings.agents.install.description' => ({required Object agent}) => 'Oturum açmak ve oturumları çalıştırmak için ${agent} CLI\'yı kurun.',
			'settings.agents.install.button' => 'Kur',
			'settings.agents.install.installing' => 'Kuruluyor…',
			'settings.agents.install.copyCommand' => 'Komutu kopyala',
			'settings.agents.install.docs' => 'Belgeler',
			'settings.agents.install.success' => ({required Object agent}) => '${agent} CLI kuruldu',
			'settings.agents.install.failed' => 'Kurulum başarısız — terminal çıktısını kontrol edin',
			'settings.agents.update.title' => 'CLI\'yi güncelle',
			'settings.agents.update.description' => ({required Object agent}) => 'Sunucu makinesine en son ${agent} CLI sürümünü kurar.',
			'settings.agents.update.button' => 'Güncelle',
			'settings.agents.update.updating' => 'Güncelleniyor…',
			'settings.agents.update.success' => ({required Object agent}) => '${agent} CLI güncellendi',
			'settings.agents.update.failed' => 'Güncelleme başarısız — terminal çıktısını kontrol edin',
			'settings.agents.account.claude.description' => 'Anthropic Claude AI asistanı',
			'settings.agents.account.cursor.description' => 'Cursor AI destekli kod editörü',
			'settings.agents.account.codex.description' => 'OpenAI Codex AI asistanı',
			'settings.agents.account.opencode.description' => 'OpenCode CLI asistanı',
			'settings.agents.account.commandcode.description' => 'Command Code CLI asistanı',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI asistanı',
			'settings.agents.account.devin.description' => 'Devin CLI asistanı',
			'settings.agents.connectionStatus' => 'Bağlantı Durumu',
			'settings.agents.login.title' => 'Giriş Yap',
			'settings.agents.login.reAuthenticate' => 'Yeniden Kimlik Doğrula',
			'settings.agents.login.description' => ({required Object agent}) => 'AI özelliklerini etkinleştirmek için ${agent} hesabına giriş yap',
			'settings.agents.login.reAuthDescription' => 'Farklı bir hesapla giriş yap veya kimlik bilgilerini yenile',
			'settings.agents.login.button' => 'Giriş Yap',
			'settings.agents.login.reLoginButton' => 'Tekrar Giriş Yap',
			'settings.agents.logout.title' => 'Çıkış yap',
			'settings.agents.logout.description' => 'Bu sağlayıcıdan çıkış yap ve kayıtlı kimlik bilgilerini sil',
			'settings.agents.logout.button' => 'Çıkış yap',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => '${agent} oturumunu kapat?',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'Bu, sunucudaki kayıtlı ${agent} kimlik bilgilerini siler. ${agent} kullanmaya devam etmek için tekrar giriş yap.',
			'settings.agents.logout.success' => 'Çıkış yapıldı',
			'settings.agents.logout.failed' => 'Çıkış yapılamadı',
			'settings.agents.error' => ({required Object error}) => 'Hata: ${error}',
			'settings.permissions.title' => 'İzin Ayarları',
			'settings.permissions.skipPermissions.label' => 'İzin istemlerini atla (dikkatli kullan)',
			'settings.permissions.skipPermissions.claudeDescription' => '--dangerously-skip-permissions bayrağının eşdeğeri',
			'settings.permissions.skipPermissions.cursorDescription' => 'Cursor CLI\'daki -f bayrağının eşdeğeri',
			'settings.permissions.allowedTools.title' => 'İzin Verilen Araçlar',
			'settings.permissions.allowedTools.description' => 'İzin istemeden otomatik olarak izin verilen araçlar',
			'settings.permissions.allowedTools.placeholder' => 'ör. "Bash(git log:*)" veya "Write"',
			'settings.permissions.allowedTools.quickAdd' => 'Yaygın araçları hızlı ekle:',
			'settings.permissions.allowedTools.empty' => 'İzin verilen araç yapılandırılmamış',
			'settings.permissions.blockedTools.title' => 'Engellenen Araçlar',
			'settings.permissions.blockedTools.description' => 'İzin istemeden otomatik olarak engellenen araçlar',
			_ => null,
		} ?? switch (path) {
			'settings.permissions.blockedTools.placeholder' => 'ör. "Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => 'Engellenen araç yapılandırılmamış',
			'settings.permissions.allowedCommands.title' => 'İzin Verilen Shell Komutları',
			'settings.permissions.allowedCommands.description' => 'İzin istemeden otomatik olarak izin verilen shell komutları',
			'settings.permissions.allowedCommands.placeholder' => 'ör. "Shell(ls)" veya "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => 'Yaygın komutları hızlı ekle:',
			'settings.permissions.allowedCommands.empty' => 'İzin verilen komut yapılandırılmamış',
			'settings.permissions.blockedCommands.title' => 'Engellenen Shell Komutları',
			'settings.permissions.blockedCommands.description' => 'Otomatik olarak engellenen shell komutları',
			'settings.permissions.blockedCommands.placeholder' => 'ör. "Shell(rm -rf)" veya "Shell(sudo)"',
			'settings.permissions.blockedCommands.empty' => 'Engellenen komut yapılandırılmamış',
			'settings.permissions.toolExamples.title' => 'Araç Desen Örnekleri:',
			'settings.permissions.toolExamples.bashGitLog' => '- Tüm git log komutlarına izin ver',
			'settings.permissions.toolExamples.bashGitDiff' => '- Tüm git diff komutlarına izin ver',
			'settings.permissions.toolExamples.write' => '- Tüm Write aracı kullanımına izin ver',
			'settings.permissions.toolExamples.bashRm' => '- Tüm rm komutlarını engelle (tehlikeli)',
			'settings.permissions.shellExamples.title' => 'Shell Komut Örnekleri:',
			'settings.permissions.shellExamples.ls' => '- ls komutuna izin ver',
			'settings.permissions.shellExamples.gitStatus' => '- git status\'a izin ver',
			'settings.permissions.shellExamples.npmInstall' => '- npm install\'a izin ver',
			'settings.permissions.shellExamples.rmRf' => '- Özyinelemeli silmeyi engelle',
			'settings.permissions.codex.permissionMode' => 'İzin Modu',
			'settings.permissions.codex.description' => 'Codex\'in dosya değişiklikleri ve komut çalıştırmayı nasıl ele aldığını kontrol eder',
			'settings.permissions.codex.modes.kDefault.title' => 'Varsayılan',
			'settings.permissions.codex.modes.kDefault.description' => 'Sadece güvenilir komutlar (ls, cat, grep, git status, vb.) otomatik çalışır. Diğer komutlar atlanır. Çalışma alanına yazabilir.',
			'settings.permissions.codex.modes.acceptEdits.title' => 'Düzenlemeleri Kabul Et',
			'settings.permissions.codex.modes.acceptEdits.description' => 'Tüm komutlar çalışma alanı içinde otomatik çalışır. Sandbox\'lu çalıştırma ile tam otomatik mod.',
			'settings.permissions.codex.modes.bypassPermissions.title' => 'İzinleri Atla',
			'settings.permissions.codex.modes.bypassPermissions.description' => 'Kısıtlama olmadan tam sistem erişimi. Tüm komutlar tam disk ve ağ erişimiyle otomatik çalışır. Dikkatli kullan.',
			'settings.permissions.codex.technicalDetails' => 'Teknik ayrıntılar',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted. Güvenilir komutlar: cat, cd, grep, head, ls, pwd, tail, git status/log/diff/show, find (-exec olmadan), vb.',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never. Tüm komutlar proje dizini içinde otomatik çalışır.',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never. Tam sistem erişimi, yalnızca güvenilir ortamlarda kullan.',
			'settings.permissions.codex.technicalInfo.overrideNote' => 'Sohbet arayüzündeki mod düğmesini kullanarak bunu oturum başına geçersiz kılabilirsin.',
			'settings.permissions.actions.add' => 'Ekle',
			'settings.permissions.permissionMode.title' => 'İzin Modu',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => 'Yeni ${provider} oturumları için varsayılan izin modu. Tek bir oturum için yine de geçersiz kılabilirsin.',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'Varsayılan',
			'settings.permissions.permissionMode.modes.kDefault.description' => 'İzin gerektiren eylemler onayın için sohbette gösterilir.',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => 'Düzenlemeleri Kabul Et',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'Dosya düzenlemeleri otomatik onaylanır; diğer eylemler yine onayını ister.',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => 'İzinleri Atla',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'Her eylem otomatik onaylanır — sorusuz tam erişim. Dikkatli kullan.',
			'settings.permissions.permissionMode.modes.plan.title' => 'Plan',
			'settings.permissions.permissionMode.modes.plan.description' => 'Planlama modu: agent komut çalıştırmadan keşfeder ve planlar.',
			'settings.mcpServers.title' => 'MCP Sunucuları',
			'settings.mcpServers.description.claude' => 'Model Context Protocol sunucuları Claude\'a ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.description.cursor' => 'Model Context Protocol sunucuları Cursor\'a ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.description.codex' => 'Model Context Protocol sunucuları Codex\'e ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol sunucuları OpenCode\'a ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol sunucuları Command Code\'a ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol sunucuları Antigravity\'a ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.description.devin' => 'Model Context Protocol sunucuları Devin’e ek araçlar ve veri kaynakları sağlar',
			'settings.mcpServers.addButton' => 'MCP Sunucusu Ekle',
			'settings.mcpServers.empty' => 'Yapılandırılmış MCP sunucusu yok',
			'settings.mcpServers.serverType' => 'Tür',
			'settings.mcpServers.scope.local' => 'yerel',
			'settings.mcpServers.scope.user' => 'kullanıcı',
			'settings.mcpServers.config.command' => 'Komut',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => 'Argümanlar',
			'settings.mcpServers.config.environment' => 'Ortam',
			'settings.mcpServers.tools.title' => 'Araçlar',
			'settings.mcpServers.tools.count' => ({required Object count}) => '(${count}):',
			'settings.mcpServers.tools.more' => ({required Object count}) => '+${count} tane daha',
			'settings.mcpServers.actions.edit' => 'Sunucuyu düzenle',
			'settings.mcpServers.actions.delete' => 'Sunucuyu sil',
			'settings.mcpServers.help.title' => 'Codex MCP Hakkında',
			'settings.mcpServers.help.description' => 'Codex stdio tabanlı MCP sunucularını destekler. Codex\'in yeteneklerini ek araçlar ve kaynaklarla genişleten sunucular ekleyebilirsin.',
			'settings.mcpServers.managed.badge' => 'Yönetilen',
			'settings.mcpServers.managed.hint' => 'ddagent tarafından yönetiliyor.',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '“${serverName}” sağlayıcı yapılandırmasından kaldırılacak.',
			'settings.mcpServers.deleteConfirm.title' => 'MCP sunucusu silinsin mi?',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => 'Uyarı eşikleri, yönlendirme politikası ve kota için sorgulanan hesaplar.',
			'settings.quota.settings.saved' => 'Kaydedildi',
			'settings.quota.settings.alertsSection' => 'Uyarılar',
			'settings.quota.settings.alertsSectionHint' => 'Bir limit gerçekten tükenmeden uyar, yalnızca %100’de değil.',
			'settings.quota.settings.alertsEnabled' => 'Öngörülen limit uyarıları',
			'settings.quota.settings.alertsEnabledHint' => 'Genel bakışta ve hesap kartlarında hıza dayalı projeksiyonları göster.',
			'settings.quota.settings.watchThreshold' => 'İzleme eşiği (%)',
			'settings.quota.settings.watchThresholdHint' => 'Bu okumada veya üzerindeki hesaplar riskte sayılır.',
			'settings.quota.settings.dangerThreshold' => 'Tehlike eşiği (%)',
			'settings.quota.settings.dangerThresholdHint' => 'Bu değerdeki veya üzerindeki okumalar kırmızı gösterilir.',
			'settings.quota.settings.routingSection' => 'Yönlendirme',
			'settings.quota.settings.routingSectionHint' => 'Panelin işi en çok payı olan hesaba nasıl taşıyabileceği.',
			'settings.quota.settings.routing.manual' => 'Manuel',
			'settings.quota.settings.routing.manualHint' => 'Yalnızca öneri göster; hesapları asla otomatik değiştirme.',
			'settings.quota.settings.routing.ask' => 'Değiştirmeden önce sor',
			'settings.quota.settings.routing.askHint' => 'Bir geçiş önerilir ve onayını bekler.',
			'settings.quota.settings.routing.autoLowRisk' => 'Düşük riskli görevler için otomatik',
			'settings.quota.settings.routing.autoLowRiskHint' => 'Yalnızca düşük riskli işaretli görevler otomatik taşınabilir.',
			'settings.quota.settings.routingNote' => 'Hesap değiştirmek maliyeti ve model kalitesini değiştirir, bu yüzden her zaman açık bir karar gerektirir.',
			'settings.quota.settings.accountsSection' => 'Sorgulanan hesaplar',
			'settings.quota.settings.accountsSectionHint' => 'Kimlik bilgileri her araçtan okunur; panel onları başka yere göndermez.',
			'settings.quota.settings.sourcesSection' => 'Veri kaynakları',
			'settings.quota.settings.sourcesSectionHint' => 'Kullanım ve maliyet rakamlarının geldiği yer.',
			'settings.quota.settings.logSources' => 'Token ve maliyet kayıt deposu',
			'settings.quota.settings.logSourcesHint' => 'Tokboard toplayıcısıyla paylaşılan salt okunur toplu depo.',
			'settings.quota.settings.readOnly' => 'Salt okunur',
			'settings.quota.settings.quotaConsent' => 'Kota sorgulaması',
			'settings.quota.settings.quotaConsentHint' => 'Yerel kayıtlı kimlik bilgileriyle sağlayıcı kota uç noktalarını okur.',
			'settings.quota.settings.localOnly' => 'Yalnızca yerel',
			'settings.quota.empty.description' => 'Henüz hesap algılanmadı.',
			'settings.quota.quality.cached' => 'önbellekten',
			'settings.quota.quality.error' => 'hata',
			'settings.quota.quality.estimate' => 'tahmin',
			'settings.quota.quality.live' => 'canlı',
			'settings.quota.quality.unknown' => 'bilinmiyor',
			'settings.quota.syncFailed' => 'Senkronizasyon başarısız',
			'settings.quota.syncNow' => 'Şimdi senkronize et',
			'settings.browser.checking' => 'kontrol ediliyor...',
			'settings.browser.description' => 'Aracıların, Browser sekmesinden izleyebileceğiniz kontrollü Playwright tarayıcı oturumları oluşturmasına izin verin.',
			'settings.browser.enableDescription' => 'Desteklenen aracılar için Browser’ı kaydeder. Aracılar tarayıcı oturumları oluşturabilir; siz izleyebilir, durdurabilir ve silebilirsiniz.',
			'settings.browser.enableLabel' => 'Browser’ı Etkinleştir',
			'settings.browser.errors.installRuntime' => 'Tarayıcı runtime’ı kurulamadı',
			'settings.browser.errors.loadSettings' => 'Browser ayarları yüklenemedi',
			'settings.browser.errors.loadStatus' => 'Browser durumu yüklenemedi',
			'settings.browser.errors.saveSettings' => 'Browser ayarları kaydedilemedi',
			'settings.browser.installHint' => 'Aracılar Browser oturumları oluşturmadan önce tarayıcı runtime’ını kurun.',
			'settings.browser.installRuntime' => 'Runtime’ı Kur',
			'settings.browser.installed' => 'kurulu',
			'settings.browser.installing' => 'Kuruluyor...',
			'settings.browser.missing' => 'eksik',
			'settings.browser.runtimeRequired' => 'Tarayıcı runtime’ı gerekli',
			'settings.browser.statusDisabled' => 'devre dışı',
			'settings.browser.statusLabel' => 'Durum',
			'settings.browser.statusReady' => 'hazır',
			'settings.browser.statusSetupRequired' => 'kurulum gerekli',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'İptal',
			'settings.workspaces.create' => 'Çalışma alanı ekle',
			'settings.workspaces.deleteConfirm' => 'Bu çalışma alanı ddagent’tan kaldırılsın mı? Dosyaları diskte kalır.',
			'settings.workspaces.deleteFailed' => 'Çalışma alanı kaldırılamadı.',
			'settings.workspaces.deleteTitle' => 'Çalışma alanını kaldır',
			'settings.workspaces.description' => 'Çalışma alanları, ddagent’ın sohbet edebildiği, kod çalıştırabildiği ve gezinebildiği dizinlerdir.',
			'settings.workspaces.remove' => 'Çalışma alanını kaldır',
			'settings.workspaces.title' => 'Çalışma alanları',
			'settings.workspaces.pathRequired' => 'Yol gerekli',
			'settings.about.supportTitle' => 'Projeyi destekle',
			'settings.about.buyMeACoffee' => 'Bana kahve ısmarla',
			'settings.about.learnMore' => 'Daha fazla bilgi',
			'settings.about.pro.syncSettings' => 'Ayarları Senkronize Et',
			'settings.about.pro.teamManagement' => 'Takım Yönetimi',
			'settings.about.proFeatures' => 'ddagent Pro Özellikleri',
			'settings.about.tryHosted' => 'ddagent Hosted\'ı deneyin',
			'settings.about.versionInfo' => 'Sürüm bilgisi',
			'settings.about.client' => 'Uygulama',
			'settings.about.server' => 'Sunucu',
			'settings.about.platformMobile' => 'Mobil',
			'settings.about.platformDesktop' => 'Masaüstü',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => 'bilinmiyor',
			'sidebar.projects.title' => 'Projeler',
			'sidebar.projects.newProject' => 'Yeni Proje',
			'sidebar.projects.deleteProject' => 'Projeyi Kaldır',
			'sidebar.projects.renameProject' => 'Projeyi Yeniden Adlandır',
			'sidebar.projects.noProjects' => 'Proje bulunamadı',
			'sidebar.projects.loadingProjects' => 'Projeler yükleniyor...',
			'sidebar.projects.searchPlaceholder' => 'Projelerde ara...',
			'sidebar.projects.projectNamePlaceholder' => 'Proje adı',
			'sidebar.projects.starred' => 'Yıldızlı',
			'sidebar.projects.all' => 'Tümü',
			'sidebar.projects.untitledSession' => 'Adsız Oturum',
			'sidebar.projects.newSession' => 'Yeni Oturum',
			'sidebar.projects.codexSession' => 'Codex Oturumu',
			'sidebar.projects.fetchingProjects' => 'Claude projelerin ve oturumların getiriliyor',
			'sidebar.projects.projects' => 'proje',
			'sidebar.projects.noMatchingProjects' => 'Eşleşen proje yok',
			'sidebar.projects.tryDifferentSearch' => 'Arama terimini değiştirmeyi dene',
			'sidebar.projects.runClaudeCli' => 'Başlamak için bir proje dizininde Claude CLI çalıştır',
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'AI kodlama asistanı arayüzü',
			'sidebar.sessions.title' => 'Oturumlar',
			'sidebar.sessions.newSession' => 'Yeni Oturum',
			'sidebar.sessions.deleteSession' => 'Oturumu Sil',
			'sidebar.sessions.renameSession' => 'Oturumu Yeniden Adlandır',
			'sidebar.sessions.noSessions' => 'Henüz oturum yok',
			'sidebar.sessions.loadingSessions' => 'Oturumlar yükleniyor...',
			'sidebar.sessions.unnamed' => 'Adsız',
			'sidebar.sessions.loading' => 'Yükleniyor...',
			'sidebar.sessions.showMore' => 'Daha fazla oturum göster',
			'sidebar.sessions.selectMode' => 'Seç',
			'sidebar.sessions.selectAll' => 'Tümünü seç',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'Arşivle (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => 'Sil (${count})',
			'sidebar.sessions.cancelSelection' => 'Seçimi iptal et',
			'sidebar.sessions.toggleSelection' => 'Oturum seçimini aç/kapat',
			'sidebar.sessions.selectionToolbar' => 'Oturum seçim eylemleri',
			'sidebar.sessions.options' => 'Oturum seçenekleri',
			'sidebar.sessions.pinSession' => 'Oturumu sabitle',
			'sidebar.sessions.unpinSession' => 'Oturum sabitlemesini kaldır',
			'sidebar.sessions.pinned' => 'Sabitlenmiş oturum',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} seçildi', other: '${count} seçildi', ), 
			'sidebar.tooltips.viewEnvironments' => 'Ortamları Görüntüle',
			'sidebar.tooltips.hideSidebar' => 'Kenar çubuğunu gizle',
			'sidebar.tooltips.createProject' => 'Yeni proje oluştur',
			'sidebar.tooltips.refresh' => 'Projeleri ve oturumları yenile (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'Projeyi yeniden adlandır (F2)',
			'sidebar.tooltips.deleteProject' => 'Projeyi kenar çubuğundan kaldır (Delete)',
			'sidebar.tooltips.addToFavorites' => 'Favorilere ekle',
			'sidebar.tooltips.removeFromFavorites' => 'Favorilerden çıkar',
			'sidebar.tooltips.editSessionName' => 'Oturum adını elle düzenle',
			'sidebar.tooltips.deleteSession' => 'Bu oturumu kalıcı olarak sil',
			'sidebar.tooltips.activeSessionIndicator' => 'Yakın zamanda etkin oturum (son 10 dakika)',
			'sidebar.tooltips.save' => 'Kaydet',
			'sidebar.tooltips.cancel' => 'İptal',
			'sidebar.tooltips.clearSearch' => 'Aramayı temizle',
			'sidebar.tooltips.openCommandPalette' => 'Komut paletini aç',
			'sidebar.tooltips.attentionRequiredIndicator' => 'Oturum ilgi bekliyor',
			'sidebar.tooltips.openSessions' => 'Oturumlara göz at',
			'sidebar.navigation.chat' => 'Sohbet',
			'sidebar.navigation.files' => 'Dosyalar',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'Terminal',
			'sidebar.navigation.tasks' => 'Görevler',
			'sidebar.actions.refresh' => 'Yenile',
			'sidebar.actions.settings' => 'Ayarlar',
			'sidebar.actions.collapseAll' => 'Tümünü Daralt',
			'sidebar.actions.expandAll' => 'Tümünü Genişlet',
			'sidebar.actions.cancel' => 'İptal',
			'sidebar.actions.save' => 'Kaydet',
			'sidebar.actions.delete' => 'Sil',
			'sidebar.actions.rename' => 'Yeniden Adlandır',
			'sidebar.actions.joinCommunity' => 'Topluluğa Katıl',
			'sidebar.actions.reportIssue' => 'Sorun Bildir',
			'sidebar.actions.starOnGithub' => 'GitHub\'da Yıldızla',
			'sidebar.actions.buyMeACoffee' => 'Bana kahve ısmarla',
			'sidebar.branding.openSource' => 'Açık Kaynak',
			'sidebar.status.active' => 'Aktif',
			'sidebar.status.inactive' => 'Pasif',
			'sidebar.status.thinking' => 'Düşünüyor...',
			'sidebar.status.error' => 'Hata',
			'sidebar.status.aborted' => 'Durduruldu',
			'sidebar.status.unknown' => 'Bilinmiyor',
			'sidebar.time.justNow' => 'Az önce',
			'sidebar.time.oneMinuteAgo' => '1 dakika önce',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} dakika önce',
			'sidebar.time.oneHourAgo' => '1 saat önce',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} saat önce',
			'sidebar.time.oneDayAgo' => '1 gün önce',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} gün önce',
			'sidebar.messages.deleteConfirm' => 'Bunu silmek istediğinden emin misin?',
			'sidebar.messages.renameSuccess' => 'Yeniden adlandırma başarılı',
			'sidebar.messages.deleteSuccess' => 'Silme başarılı',
			'sidebar.messages.errorOccurred' => 'Bir hata oluştu',
			'sidebar.messages.deleteSessionConfirm' => 'Bu oturumu silmek istediğinden emin misin? Bu işlem geri alınamaz.',
			'sidebar.messages.deleteProjectConfirm' => 'Bu proje kenar çubuğundan kaldırılsın mı? Proje dosyaların, bellek verilerin ve oturum verilerin silinmeyecek.',
			'sidebar.messages.enterProjectPath' => 'Lütfen bir proje yolu gir',
			'sidebar.messages.deleteSessionFailed' => 'Oturum silinemedi. Lütfen tekrar dene.',
			'sidebar.messages.deleteSessionError' => 'Oturum silinirken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.renameSessionFailed' => 'Oturum yeniden adlandırılamadı. Lütfen tekrar dene.',
			'sidebar.messages.renameSessionError' => 'Oturum yeniden adlandırılırken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.deleteProjectFailed' => 'Proje kaldırılamadı. Lütfen tekrar dene.',
			'sidebar.messages.deleteProjectError' => 'Proje kaldırılırken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.createProjectFailed' => 'Proje oluşturulamadı. Lütfen tekrar dene.',
			'sidebar.messages.createProjectError' => 'Proje oluşturulurken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.updateProjectError' => 'Proje güncellenirken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.refreshError' => 'Yenileme başarısız. Lütfen tekrar dene.',
			'sidebar.messages.restoreProjectFailed' => 'Proje geri yüklenemedi. Lütfen tekrar dene.',
			'sidebar.messages.restoreProjectError' => 'Proje geri yüklenirken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.restoreSessionFailed' => 'Oturum geri yüklenemedi. Lütfen tekrar dene.',
			'sidebar.messages.restoreSessionError' => 'Oturum geri yüklenirken hata oluştu. Lütfen tekrar dene.',
			'sidebar.messages.changeWorkspaceFailed' => 'Çalışma alanı değiştirilemedi. Lütfen tekrar dene.',
			'sidebar.messages.changeWorkspaceError' => 'Çalışma alanı değiştirilirken hata. Lütfen tekrar dene.',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} oturum silinemedi. Lütfen tekrar dene.', other: '${count} oturum silinemedi. Lütfen tekrar dene.', ), 
			'sidebar.version.updateAvailable' => 'Güncelleme mevcut',
			'sidebar.version.restartRequired' => 'Güncelleme yüklendi — uygulamak için sunucuyu yeniden başlatın',
			'sidebar.version.updateNow' => 'Şimdi güncelle',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'ddagent v${version} sürümüne güncellensin mi? En yeni kod çekilip derlenecek ve sunucu yeniden başlatılacak — etkin oturumlar kesintiye uğrar.',
			'sidebar.version.updating' => 'Güncelleniyor… birkaç dakika sürebilir',
			'sidebar.version.restarting' => 'Güncelleme yüklendi — yeniden başlatılıyor…',
			'sidebar.version.updateFailed' => 'Güncelleme başarısız',
			'sidebar.version.releaseNotes' => 'Sürüm notları',
			'sidebar.search.modeProjects' => 'Projeler',
			'sidebar.search.modeConversations' => 'Konuşmalar',
			'sidebar.search.conversationsPlaceholder' => 'Konuşmalarda ara...',
			'sidebar.search.searching' => 'Aranıyor...',
			'sidebar.search.sessionTitles' => 'Oturum başlıkları',
			'sidebar.search.conversationContents' => 'Konuşma içerikleri',
			'sidebar.search.noResults' => 'Sonuç bulunamadı',
			'sidebar.search.tryDifferentQuery' => 'Farklı bir arama sorgusu dene',
			'sidebar.search.modeRunning' => 'Çalışıyor',
			'sidebar.search.archiveOnly' => 'Arşiv',
			'sidebar.search.runningTooltip' => 'Çalışan oturumlar',
			'sidebar.search.archiveOnlyTooltip' => 'Yalnızca arşiv',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} etkin',
			'sidebar.search.viewMenu' => 'Görünüm',
			'sidebar.search.backToProjects' => 'Projelere dön',
			'sidebar.search.archivedPlaceholder' => 'Arşivlenen oturumlarda ara...',
			'sidebar.search.runningPlaceholder' => 'Çalışan oturumlarda ara...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} eşleşme', other: '${count} eşleşme', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} proje tarandı', other: '${count} proje tarandı', ), 
			'sidebar.deleteConfirmation.deleteProject' => 'Projeyi Kaldır',
			'sidebar.deleteConfirmation.deleteSession' => 'Oturumu Sil',
			'sidebar.deleteConfirmation.confirmDelete' => 'Ne yapmak istersin:',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'Yalnızca kenar çubuğundan kaldır',
			'sidebar.deleteConfirmation.deleteAllData' => 'Tüm veriyi kalıcı olarak sil',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'Proje kenar çubuğundan kaldırılacak. Dosyaların, bellek verilerin ve oturum verilerin korunacak.',
			'sidebar.deleteConfirmation.cannotUndo' => 'Projeyi sonra tekrar ekleyebilirsin.',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'Arşivleme, seçili oturumları aktif listeden gizlerken geçmişlerini korur.',
			'sidebar.deleteConfirmation.archiveSession' => 'Oturumu arşivle',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'Arşivleme, oturumu aktif listeden çıkarırken geçmişini korur.',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'Bu oturum zaten arşivli. Gizli tutabilir veya kalıcı olarak silebilirsin.',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'Bu, oturumu ve transkriptini kalıcı olarak kaldırır. Bu işlem geri alınamaz.',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => 'Kalıcı olarak sil',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: 'Bu proje ${count} konuşma içeriyor.', other: 'Bu proje ${count} konuşma içeriyor.', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: 'Seçili oturumu yönet', other: '${count} seçili oturumu yönet', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: 'Oturumu arşivle', other: '${count} oturumu arşivle', ), 
			'sidebar.zones.activeNow' => 'Şu anda aktif',
			'sidebar.zones.recent' => 'Son kullanılanlar',
			'sidebar.zones.today' => 'Bugün',
			'sidebar.zones.yesterday' => 'Dün',
			'sidebar.zones.thisWeek' => 'Bu hafta',
			'sidebar.zones.showMore' => ({required Object count}) => '${count} tane daha göster',
			'sidebar.zones.showLess' => 'Daha az göster',
			'sidebar.panel.open' => 'Panel',
			'sidebar.panel.newChat' => 'Yeni sohbet',
			'sidebar.panel.navigation' => 'Gezinme',
			'sidebar.panel.sessions' => 'Oturumlar',
			'sidebar.workspace.title' => 'Oturum çalışma alanını değiştir',
			'sidebar.workspace.description' => 'Agent sonraki adımlarını bu dizinde çalıştırır. Mevcut oturum geçmişi korunur.',
			'sidebar.workspace.pathLabel' => 'Çalışma alanı yolu',
			'sidebar.workspace.pathRequired' => 'Çalışma alanı yolu gerekli.',
			'sidebar.workspace.submit' => 'Çalışma alanını değiştir',
			'sidebar.workspace.saving' => 'Değiştiriliyor…',
			'sidebar.workspace.changeAction' => 'Çalışma alanını değiştir',
			'sidebar.recent.title' => 'Son sohbetler',
			'sidebar.recent.emptyTitle' => 'Henüz sohbet yok',
			'sidebar.recent.emptyDescription' => 'En son güncellenen sohbetlerin burada görünecek.',
			'sidebar.recent.loadFailed' => 'Son sohbetler yüklenemedi',
			'sidebar.recent.loadMore' => 'Daha eski sohbetleri yükle',
			'sidebar.recent.loadingMore' => 'Daha fazla yükleniyor...',
			'sidebar.tabs.board' => 'Aracı Panosu',
			'sidebar.tabs.files' => 'Dosyalar',
			'sidebar.tabs.git' => 'Kaynak Denetimi',
			'sidebar.tabs.tasks' => 'Görevler',
			'sidebar.tabs.usage' => 'Kota ve Kullanım',
			'tasks.notConfigured.title' => 'TaskMaster AI yapılandırılmamış',
			'tasks.notConfigured.description' => 'TaskMaster, karmaşık projeleri AI destekli yardımla yönetilebilir görevlere böler',
			'tasks.notConfigured.whatIsTitle' => '🎯 TaskMaster nedir?',
			'tasks.notConfigured.features.aiPowered' => 'AI Destekli Görev Yönetimi: Karmaşık projeleri yönetilebilir alt görevlere böl',
			'tasks.notConfigured.features.prdTemplates' => 'PRD Şablonları: Ürün Gereksinim Belgelerinden görev üret',
			'tasks.notConfigured.features.dependencyTracking' => 'Bağımlılık Takibi: Görev ilişkilerini ve çalıştırma sırasını anla',
			'tasks.notConfigured.features.progressVisualization' => 'İlerleme Görselleştirme: Kanban panoları ve detaylı görev analizleri',
			'tasks.notConfigured.features.cliIntegration' => 'CLI Entegrasyonu: İleri seviye iş akışları için taskmaster komutlarını kullan',
			'tasks.notConfigured.initializeButton' => 'TaskMaster AI\'yi Başlat',
			'tasks.notConfigured.writePrdFirst' => 'Önce PRD yaz',
			'tasks.gettingStarted.title' => 'TaskMaster\'a Başlarken',
			'tasks.gettingStarted.subtitle' => 'TaskMaster hazır! Sıradaki adımların:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Ürün Gereksinim Belgesi (PRD) oluştur',
			'tasks.gettingStarted.steps.createPRD.description' => 'Proje fikrini konuş ve ne inşa etmek istediğini anlatan bir PRD yaz.',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'PRD Ekle',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => 'Mevcut PRD\'ler:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'PRD\'den Görev Üret',
			'tasks.gettingStarted.steps.generateTasks.description' => 'PRD\'n hazır olduğunda AI asistanına ayrıştırmasını söyle; TaskMaster bunu otomatik olarak uygulama detaylarıyla yönetilebilir görevlere bölecek.',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'Görevleri Analiz Et ve Genişlet',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'AI asistanına görev karmaşıklığını analiz etmesini ve uygulamayı kolaylaştırmak için detaylı alt görevlere ayırmasını söyle.',
			'tasks.gettingStarted.steps.startBuilding.title' => 'İnşaya Başla',
			'tasks.gettingStarted.steps.startBuilding.description' => 'AI asistanına görevler üzerinde çalışmaya başlamasını, durumlarını güncellemesini ve proje geliştikçe yeni görevler eklemesini söyle.',
			'tasks.gettingStarted.tip' => '💡 İpucu: TaskMaster\'ın AI destekli görev üretiminden en iyi şekilde faydalanmak için bir PRD ile başla',
			'tasks.setupModal.title' => 'TaskMaster Kurulumu',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => '${projectName} için interaktif CLI',
			'tasks.setupModal.willStart' => 'TaskMaster başlatma otomatik olarak başlayacak',
			'tasks.setupModal.completed' => 'TaskMaster kurulumu tamamlandı! Bu pencereyi kapatabilirsin.',
			'tasks.setupModal.closeButton' => 'Kapat',
			'tasks.setupModal.closeContinueButton' => 'Kapat ve Devam Et',
			'tasks.setupModal.closeTitle' => 'Kapat',
			'tasks.setupModal.description' => 'Bu projede bir .taskmaster klasörü oluşturur. Harici araç veya API anahtarı gerekmez — görevler yerel olarak saklanır.',
			'tasks.setupModal.initializeButton' => 'Başlat',
			'tasks.setupModal.initializing' => 'Başlatılıyor...',
			'tasks.helpGuide.title' => 'TaskMaster\'a Başlarken',
			'tasks.helpGuide.subtitle' => 'Verimli görev yönetimi için rehberin',
			'tasks.helpGuide.examples.parsePRD' => '💬 Örnek:\n"Claude Task Master ile yeni bir proje başlattım. .taskmaster/docs/prd.txt altında bir PRD\'m var. Bunu ayrıştırıp ilk görevleri kurmama yardım eder misin?"',
			'tasks.helpGuide.examples.expandTask' => '💬 Örnek:\n"Görev 5 karmaşık görünüyor. Bunu alt görevlere bölebilir misin?"',
			'tasks.helpGuide.examples.addTask' => '💬 Örnek:\n"Lütfen Cloudinary kullanarak kullanıcı profil resmi yükleme özelliği için yeni bir görev ekle, en iyi yaklaşımı araştır."',
			'tasks.helpGuide.moreExamples' => 'Daha fazla örnek ve kullanım deseni →',
			'tasks.helpGuide.proTips.title' => '💡 Pro İpuçları',
			'tasks.helpGuide.proTips.search' => 'Belirli görevleri hızlıca bulmak için arama çubuğunu kullan',
			'tasks.helpGuide.proTips.views' => 'Kanban, Liste ve Izgara görünümleri arasında geçiş yapmak için görünüm düğmelerini kullan',
			'tasks.helpGuide.proTips.filters' => 'Belirli görev durumlarına veya önceliklere odaklanmak için filtreleri kullan',
			'tasks.helpGuide.proTips.details' => 'Detaylı bilgi görmek ve alt görevleri yönetmek için herhangi bir göreve tıkla',
			'tasks.helpGuide.learnMore.title' => '📚 Daha Fazla Öğren',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI, geliştiriciler için inşa edilmiş ileri seviye bir görev yönetim sistemidir. Dokümantasyona, örneklere bak ve projeye katkıda bulun.',
			'tasks.helpGuide.learnMore.githubButton' => 'GitHub\'da Görüntüle',
			'tasks.helpGuide.closeTitle' => 'Kapat',
			'tasks.search.placeholder' => 'Görevlerde ara...',
			'tasks.filters.button' => 'Filtreler',
			'tasks.filters.status' => 'Durum',
			'tasks.filters.priority' => 'Öncelik',
			'tasks.filters.sortBy' => 'Sıralama',
			'tasks.filters.allStatuses' => 'Tüm Durumlar',
			'tasks.filters.allPriorities' => 'Tüm Öncelikler',
			'tasks.filters.showing' => ({required Object total, required Object filtered}) => '${total} görevin ${filtered} tanesi gösteriliyor',
			'tasks.filters.clearFilters' => 'Filtreleri Temizle',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'Durum',
			'tasks.sort.priority' => 'Öncelik',
			'tasks.sort.idAsc' => 'ID (Artan)',
			'tasks.sort.idDesc' => 'ID (Azalan)',
			'tasks.sort.titleAsc' => 'Başlık (A-Z)',
			'tasks.sort.titleDesc' => 'Başlık (Z-A)',
			'tasks.sort.statusAsc' => 'Durum (Önce Bekleyen)',
			'tasks.sort.statusDesc' => 'Durum (Önce Tamamlanan)',
			'tasks.sort.priorityAsc' => 'Öncelik (Önce Yüksek)',
			'tasks.sort.priorityDesc' => 'Öncelik (Önce Düşük)',
			'tasks.views.kanban' => 'Kanban görünümü',
			'tasks.views.list' => 'Liste görünümü',
			'tasks.views.grid' => 'Izgara görünümü',
			'tasks.kanban.pending' => '📋 Yapılacak',
			'tasks.kanban.inProgress' => '🚀 Sürüyor',
			'tasks.kanban.review' => '👀 İnceleme',
			'tasks.kanban.done' => '✅ Tamamlandı',
			'tasks.kanban.blocked' => '🚫 Engellendi',
			'tasks.kanban.deferred' => '⏳ Ertelendi',
			'tasks.kanban.cancelled' => '❌ İptal Edildi',
			'tasks.kanban.noTasksYet' => 'Henüz görev yok',
			'tasks.kanban.tasksWillAppear' => 'Görevler burada görünecek',
			'tasks.kanban.moveTasksHere' => 'Başlayan görevleri buraya taşı',
			'tasks.kanban.completedTasksHere' => 'Tamamlanan görevler burada görünür',
			'tasks.kanban.statusTasksHere' => 'Bu durumdaki görevler burada görünecek',
			'tasks.buttons.help' => 'TaskMaster Başlangıç Rehberi',
			'tasks.buttons.prds' => 'PRD\'ler',
			'tasks.buttons.addPRD' => 'PRD Ekle',
			'tasks.buttons.addTask' => 'Görev Ekle',
			'tasks.buttons.createNewPRD' => 'Yeni PRD Oluştur',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} PRD mevcut',
			'tasks.prd.modified' => ({required Object date}) => 'Değişiklik: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => '"${name}" adlı bir PRD zaten var. Üzerine yazmak istiyor musunuz?',
			'tasks.prd.fileExistsTitle' => 'Dosya zaten var',
			'tasks.prd.newFile' => 'yeni dosya',
			'tasks.prd.parse' => 'PRD\'yi ayrıştır',
			'tasks.prd.template' => 'Şablon',
			'tasks.prd.fileNameHint' => 'dosya adı (ör. prd.txt)',
			'tasks.prd.saved' => 'PRD kaydedildi',
			'tasks.prd.tasksGenerated' => 'PRD\'den görevler oluşturuldu',
			'tasks.statuses.pending' => 'Beklemede',
			'tasks.statuses.inProgress' => 'Sürüyor',
			'tasks.statuses.done' => 'Tamamlandı',
			'tasks.statuses.blocked' => 'Engellendi',
			'tasks.statuses.deferred' => 'Ertelendi',
			'tasks.statuses.cancelled' => 'İptal Edildi',
			'tasks.statuses.review' => 'İnceleme',
			'tasks.priorities.high' => 'Yüksek',
			'tasks.priorities.medium' => 'Orta',
			'tasks.priorities.low' => 'Düşük',
			'tasks.noMatchingTasks.title' => 'Filtrelerine uygun görev yok',
			'tasks.noMatchingTasks.description' => 'Arama veya filtre kriterlerini değiştirmeyi dene.',
			'tasks.board.title' => 'Agent Panosu',
			'tasks.board.subtitle' => 'Bir kartı Hazır’a taşı, agent üstlenir. Oturumunu açmak için karta tıkla.',
			'tasks.board.newCard' => 'Yeni kart',
			'tasks.board.addCard' => 'Kart ekle',
			'tasks.board.refresh' => 'Yenile',
			'tasks.board.empty.title' => 'Henüz kart yok',
			'tasks.board.empty.description' => 'Bir kart ekle, görevi açıkla, sonra bir agentın çalışmaya başlaması için Hazır’a sürükle.',
			'tasks.board.columns.backlog' => 'Backlog',
			'tasks.board.columns.ready' => 'Başlamaya hazır',
			'tasks.board.columns.working' => 'Çalışıyor',
			'tasks.board.columns.needsDecision' => 'Kararın gerekli',
			'tasks.board.columns.done' => 'Tamamlandı',
			'tasks.board.columns.archived' => 'Arşivlendi',
			'tasks.board.card.running' => 'Çalışıyor',
			'tasks.board.card.abort' => 'İptal et',
			'tasks.board.card.delete' => 'Sil',
			'tasks.board.card.openSession' => 'Oturumu aç',
			'tasks.board.card.pullRequest' => 'Pull request',
			'tasks.board.dialog.createTitle' => 'Yeni kart',
			'tasks.board.dialog.editTitle' => 'Kartı düzenle',
			'tasks.board.dialog.titleLabel' => 'Başlık',
			'tasks.board.dialog.titlePlaceholder' => 'Agent ne yapmalı?',
			'tasks.board.dialog.descriptionLabel' => 'Açıklama',
			'tasks.board.dialog.descriptionPlaceholder' => 'Bağlam, kabul kriterleri, bağlantılar ekle...',
			'tasks.board.dialog.cancel' => 'İptal',
			'tasks.board.dialog.save' => 'Kaydet',
			'tasks.board.noProject' => 'Önce bir proje ekle, sonra onun için kartlar oluştur.',
			'tasks.board.projectLabel' => 'Proje',
			'tasks.board.backToChat' => 'Sohbete dön',
			'tasks.board.agent.provider' => 'Agent',
			'tasks.board.agent.anyProvider' => 'Herhangi bir agent',
			'tasks.board.agent.model' => 'Model',
			'tasks.board.agent.defaultModel' => 'Varsayılan model',
			'tasks.board.agent.effort' => 'Akıl yürütme',
			'tasks.board.agent.defaultEffort' => 'Varsayılan',
			'tasks.board.agent.searchModel' => 'Model ara…',
			'tasks.board.agent.noModels' => 'Eşleşen model yok',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '“${cardTitle}” kalıcı olarak silinecek.',
			'tasks.board.deleteConfirm.title' => 'Kart silinsin mi?',
			'tasks.board.project' => 'Proje',
			'tasks.card.dependsOnList' => ({required Object tasks}) => 'Bağlı olduğu: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'Görev ${id}',
			'tasks.card.highPriority' => 'Yüksek öncelik',
			'tasks.card.lowPriority' => 'Düşük öncelik',
			'tasks.card.mediumPriority' => 'Orta öncelik',
			'tasks.card.noPriority' => 'Öncelik ayarlanmadı',
			'tasks.card.parentTask' => ({required Object id}) => 'Görev ${id}',
			'tasks.card.progressLabel' => 'İlerleme:',
			'tasks.card.progressTooltip' => ({required Object total, required Object completed}) => '${total} alt görevden ${completed} tanesi tamamlandı',
			'tasks.card.runTask' => 'Görevi çalıştır',
			'tasks.card.runTaskAria' => ({required Object id}) => 'Görev ${id} çalıştır',
			'tasks.card.statusTooltip' => ({required Object status}) => 'Durum: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'Görev ID: ${id}',
			'tasks.card.taskInProgress' => 'Görev devam ediyor',
			'tasks.createTask.cancel' => 'İptal',
			'tasks.createTask.descriptionLabel' => 'Açıklama',
			'tasks.createTask.descriptionPlaceholder' => 'İsteğe bağlı ayrıntılar',
			'tasks.createTask.error' => 'Görev eklenemedi',
			'tasks.createTask.priorityLabel' => 'Öncelik',
			'tasks.createTask.submit' => 'Görev Ekle',
			'tasks.createTask.submitting' => 'Ekleniyor...',
			'tasks.createTask.title' => 'Görev Ekle',
			_ => null,
		} ?? switch (path) {
			'tasks.createTask.titleLabel' => 'Başlık',
			'tasks.createTask.titlePlaceholder' => 'Ne yapılması gerekiyor?',
			'tasks.list.completedReopen' => 'Tamamlandı (yeniden açmak için tıklayın)',
			'tasks.list.inProgressComplete' => 'Devam ediyor (tamamlamak için tıklayın)',
			'tasks.list.markCompleted' => 'Tamamlandı olarak işaretle',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'Görev ${id} durumunu değiştir',
			'tasks.list.markDone' => 'Tamamlandı olarak işaretle',
			'tasks.list.reopen' => 'Yeniden aç',
			'tasks.nextTask.allComplete' => 'Tüm görevler tamamlandı',
			'tasks.nextTask.feature1' => '- Bağımlılıklar ve alt görevlerle AI destekli görev yönetimi.',
			'tasks.nextTask.feature2' => '- Daha hızlı proje başlangıcı için PRD tabanlı görev oluşturma.',
			'tasks.nextTask.feature3' => '- Günlük işler için kanban ve liste görünümleri.',
			'tasks.nextTask.hideDetails' => 'Ayrıntıları gizle',
			'tasks.nextTask.initialize' => 'Başlat',
			'tasks.nextTask.noPending' => 'Bekleyen görev yok',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI yapılandırılmamış',
			'tasks.nextTask.review' => 'İncele',
			'tasks.nextTask.startTask' => 'Görevi Başlat',
			'tasks.nextTask.taskId' => ({required Object id}) => 'Görev ${id}',
			'tasks.nextTask.viewAll' => 'Tüm görevleri görüntüle',
			'tasks.nextTask.viewDetails' => 'Görev ayrıntılarını görüntüle',
			'tasks.nextTask.whatIs' => 'TaskMaster nedir?',
			'tasks.taskDetail.cancelEdit' => 'Düzenlemeyi iptal et',
			'tasks.taskDetail.close' => 'Kapat',
			'tasks.taskDetail.copyTaskId' => 'Görev ID’sini kopyala',
			'tasks.taskDetail.delete' => 'Görevi sil',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '"${title}" kalıcı olarak silinecek.',
			'tasks.taskDetail.deleteConfirmTitle' => 'Görev silinsin mi?',
			'tasks.taskDetail.deleteFailed' => 'Görev silinemedi',
			'tasks.taskDetail.dependencies' => 'Bağımlılıklar',
			'tasks.taskDetail.dependenciesPlaceholder' => 'örn. 1, 2, 3',
			'tasks.taskDetail.description' => 'Açıklama',
			'tasks.taskDetail.edit' => 'Görevi düzenle',
			'tasks.taskDetail.implDetails' => 'Uygulama Ayrıntıları',
			'tasks.taskDetail.noDependencies' => 'Bağımlılık yok',
			'tasks.taskDetail.noDescription' => 'Açıklama yok',
			'tasks.taskDetail.priority' => 'Öncelik',
			'tasks.taskDetail.priorityNotSet' => 'Ayarlanmadı',
			'tasks.taskDetail.save' => 'Kaydet',
			'tasks.taskDetail.status' => 'Durum',
			'tasks.taskDetail.statusFailed' => 'Görev durumu güncellenemedi',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'Görev ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'Görev ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'Test Stratejisi',
			'tasks.taskDetail.titleRequired' => 'Başlık gerekli',
			'tasks.taskDetail.updateFailed' => 'Görev güncellenemedi',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => '#${id} görevi kaldırılacak. Bu işlem geri alınamaz.',
			'tasks.taskDetail.notFound' => 'Görev bulunamadı',
			'tasks.taskDetail.subtasks' => 'Alt görevler',
			'tasks.taskDetail.idCopied' => 'Görev ID kopyalandı',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'Görev ${id} devam ediyor olarak ayarlandı',
			'knowledge.title' => 'Bilgi',
			'knowledge.tabs.dashboard' => 'Panel',
			'knowledge.tabs.memories' => 'Anılar',
			'knowledge.tabs.rules' => 'Kurallar',
			'knowledge.tabs.skills' => 'Beceriler',
			'knowledge.tabs.personal' => 'Kişisel',
			'knowledge.tabs.graph' => 'Grafik',
			'knowledge.common.add' => 'Ekle',
			'knowledge.common.save' => 'Kaydet',
			'knowledge.common.cancel' => 'İptal',
			'knowledge.common.delete' => 'Sil',
			'knowledge.common.edit' => 'Düzenle',
			'knowledge.common.close' => 'Kapat',
			'knowledge.common.restore' => 'Geri yükle',
			'knowledge.common.refresh' => 'Yenile',
			'knowledge.common.allProjects' => 'Tüm projeler',
			'knowledge.common.global' => 'Genel',
			'knowledge.actions.scan' => 'Proje dosyalarını tara',
			'knowledge.actions.export' => 'JSON dışa aktar',
			'knowledge.actions.import' => 'JSON içe aktar',
			'knowledge.actions.scanComplete' => 'Tarama tamamlandı',
			'knowledge.actions.importComplete' => 'İçe aktarma tamamlandı',
			'knowledge.actions.importFailed' => 'İçe aktarma başarısız',
			'knowledge.dialog.newEntity' => 'Yeni kayıt',
			'knowledge.dialog.editEntity' => 'Kaydı düzenle',
			'knowledge.dialog.deleteTitle' => 'Sil',
			'knowledge.dialog.deleteMessage' => 'Bu kayıt silinsin mi? Geri alınamaz (geçmiş korunur).',
			'knowledge.dialog.pickIcon' => 'Simge seç',
			'knowledge.dialog.removeIcon' => 'Simgeyi kaldır',
			'knowledge.dialog.iconTooLarge' => 'Simge çok büyük (en fazla 40 KB).',
			'knowledge.dialog.importTitle' => 'Bilgiyi içe aktar',
			'knowledge.dialog.importHint' => 'Dışa aktarılan JSON\'u buraya yapıştır',
			'knowledge.dialog.exportTitle' => 'Bilgiyi dışa aktar',
			'knowledge.dialog.import' => 'İçe aktar',
			'knowledge.fields.key' => 'Anahtar',
			'knowledge.fields.title' => 'Başlık',
			'knowledge.fields.name' => 'Ad',
			'knowledge.fields.description' => 'Açıklama',
			'knowledge.fields.category' => 'Kategori',
			'knowledge.fields.content' => 'İçerik',
			'knowledge.fields.priority' => 'Öncelik',
			'knowledge.fields.tags' => 'Etiketler',
			'knowledge.fields.enabled' => 'Etkin',
			'knowledge.fields.projectScope' => 'Proje kapsamı',
			'knowledge.fields.tagsHint' => 'virgülle ayrılmış',
			'knowledge.dashboard.memories' => 'Anılar',
			'knowledge.dashboard.rules' => 'Kurallar',
			'knowledge.dashboard.skills' => 'Beceriler',
			'knowledge.dashboard.personal' => 'Kişisel',
			'knowledge.dashboard.connections' => 'Bağlantılar',
			'knowledge.dashboard.recent' => 'Son anılar',
			'knowledge.dashboard.noMemories' => 'Henüz anı yok. Anılar sekmesinden ekleyin.',
			'knowledge.empty.memories' => 'Henüz anı yok.',
			'knowledge.empty.rules' => 'Henüz kural yok.',
			'knowledge.empty.skills' => 'Henüz beceri yok.',
			'knowledge.empty.personal' => 'Henüz kişisel bilgi yok.',
			'knowledge.empty.graph' => 'Grafik için varlık yok.',
			'knowledge.history.title' => 'Geçmiş',
			'knowledge.history.none' => 'Henüz geçmiş yok.',
			'knowledge.history.untitled' => '(başlıksız)',
			'knowledge.priorities.critical' => 'Kritik',
			'knowledge.priorities.high' => 'Yüksek',
			'knowledge.priorities.normal' => 'Normal',
			'knowledge.priorities.low' => 'Düşük',
			'knowledge.search.title' => 'Bilgide ara',
			'knowledge.search.hint' => 'Anılar, kurallar, beceriler ara…',
			'knowledge.search.noResults' => 'Sonuç yok.',
			'knowledge.links.title' => 'Varlıkları bağla',
			'knowledge.links.source' => 'Kaynak',
			'knowledge.links.target' => 'Hedef',
			'knowledge.links.relationship' => 'İlişki',
			'knowledge.links.add' => 'Bağlantı oluştur',
			'knowledge.tags.all' => 'Tüm etiketler',
			'knowledge.tags.manage' => 'Etiketleri yönet',
			'knowledge.tags.none' => 'Henüz etiket yok.',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} tok',
			'knowledge.critical.make' => 'Kritik yap',
			'knowledge.critical.makeAll' => 'Tüm kuralları kritik yap',
			'knowledge.critical.makeAllHint' => 'Bunları enjekte edilen bağlam bütçesine ekler',
			'knowledge.errors.importFailed' => ({required Object error}) => 'İçe aktarma başarısız: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => 'Taşıma başarısız: ${error}',
			'knowledge.graph.truncated' => 'kısaltıldı',
			'knowledge.importAll.action' => 'Her şeyi içe aktar',
			'knowledge.importAll.mergeDuplicates' => 'Yinelenen kayıtları birleştir',
			'knowledge.importAll.mergeDuplicatesHint' => 'ddagent içindeki yinelenen satırları birleştirir (dosyaları değil)',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'Taranan projeler: ${count}',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'Kurallar: ${total} · yinelenen gruplar: ${duplicates}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => 'Bulunan agent becerileri: ${found} (yeni: ${newSkills})',
			'knowledge.importAll.title' => 'Her şeyi ddagent\'a aktar',
			'knowledge.importSkills.found' => ({required Object count}) => 'Agentlarınızda ${count} beceri bulundu.',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => 'Yeni: ${imported} · atlanan: ${skipped}',
			'knowledge.importSkills.title' => 'Agent becerilerini içe aktar',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'Bellek: ${title}',
			'knowledge.linkOptions.personal' => ({required Object title}) => 'Kişisel: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'Kural: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'Beceri: ${name}',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'Projeler arası yinelenen gruplar: ${count}',
			'knowledge.migrate.mergeDuplicates' => 'Yinelenenleri birleştir',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => 'Kaldırılan: ${removed}, yükseltilen: ${promoted}',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'Kurallar: toplam ${total}, ${critical} kritik.',
			'knowledge.migrate.scanned' => ({required Object count}) => '${count} proje tarandı.',
			'knowledge.migrate.title' => 'Mevcut kuralları taşı',
			'skills.addDialog.chooseFileTitle' => 'SKILL.md seç',
			'skills.addDialog.chooseFiles' => 'Dosya Seç',
			'skills.addDialog.chooseFolder' => 'Klasör Seç',
			'skills.addDialog.chooseFolderTitle' => 'Bir beceri klasörü seçin',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} dosya · ${size}', other: '${count} dosya · ${size}', ), 
			'skills.addDialog.folderUploadsNote' => 'Klasör yüklemeleri seçilen klasör adını korur; tek başına dosyalar `SKILL.md` içindeki `name` değerini kullanır.',
			'skills.addDialog.hideInstallLocation' => 'Kurulum konumunu gizle',
			'skills.addDialog.installSkill' => 'Beceri Kur',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} Beceri Kur', other: '${count} Beceri Kur', ), 
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Markdown dosyası · ${size}',
			'skills.addDialog.pickHint' => 'Klasörler script, referans ve varlık içerebilir.',
			'skills.addDialog.pickTitle' => 'Bir beceri klasörü veya SKILL.md seçin',
			'skills.addDialog.readyToInstall' => 'Kuruluma hazır',
			'skills.addDialog.removeQueued' => ({required Object name}) => '${name} öğesini kaldır',
			'skills.addDialog.title' => ({required Object provider}) => '${provider} Becerisi Ekle',
			'skills.addDialog.uploadHint' => 'Bir SKILL.md dosyası veya eksiksiz bir beceri klasörü yükleyin.',
			'skills.addDialog.whereWillThisInstall' => 'Nereye kurulacak?',
			'skills.deleteSkill' => ({required Object name}) => '${name} sil',
			'skills.empty.noGlobalSkills' => 'Henüz genel beceri bulunamadı',
			'skills.empty.noGlobalSkillsDescription' => 'Her projede kullanılabilir olması için yukarıdan bir genel beceri ekleyin.',
			'skills.empty.noMatchingSkills' => 'Eşleşen beceri yok',
			'skills.empty.noMatchingSkillsDescription' => 'Farklı bir komut, ad, kapsam, proje veya kaynak yolu deneyin.',
			'skills.empty.noProjects' => 'Kullanılabilir proje yok',
			'skills.empty.noProjectsDescription' => 'Becerilerine göz atmak için bir proje veya çalışma alanı ekleyin.',
			'skills.empty.noSkillsInProject' => 'Bu projede beceri yok',
			'skills.empty.noSkillsInProjectDescription' => 'Seçili projede bir .claude/skills, .cursor/skills veya .agents/skills klasörü oluşturun.',
			'skills.errors.addMarkdownFirst' => 'Önce bir veya daha fazla markdown dosyası ekleyin.',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => '${name} içinden SKILL.md okunamadı.',
			'skills.errors.dropMarkdownOrFolder' => 'Bir veya daha fazla markdown dosyası ya da SKILL.md içeren bir klasör bırakın.',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'Bir beceri klasörü en fazla ${count} dosya içerebilir.',
			'skills.errors.folderReadFailed' => 'Beceri klasörü okunamadı',
			'skills.errors.folderSizeLimit' => 'Seçilen beceri klasörleri toplamda 30 MB\'den küçük olmalıdır.',
			'skills.errors.importFailed' => 'Beceriler içe aktarılamadı',
			'skills.errors.missingSkillFile' => 'Seçilen klasörde SKILL.md dosyası yok.',
			'skills.moveDialog.moveToGlobal' => 'Genele taşı',
			'skills.moveDialog.moveToProject' => 'Projeye taşı',
			'skills.moveDialog.toGlobalHint' => 'Bu beceriyi, her projenin kullanabilmesi için genel beceriler dizinine taşıyın.',
			'skills.moveDialog.toProjectHint' => 'Bu beceriye sahip olacak projeyi seçin. Beceri, sağlayıcının genel beceriler dizininden taşınır.',
			'skills.moveSkill' => ({required Object name}) => '${name} öğesini taşı',
			'skills.projectLabel' => 'Proje',
			'skills.scopes.admin' => 'Yönetici',
			'skills.scopes.plugin' => 'Eklenti',
			'skills.scopes.project' => 'Proje',
			'skills.scopes.repo' => 'Depo',
			'skills.scopes.system' => 'Sistem',
			'skills.scopes.user' => 'Kullanıcı',
			'skills.screen.addSkill' => 'Beceri Ekle',
			'skills.screen.clearSearch' => 'Beceri aramasını temizle',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => 'Bu, ${directory} dizinini ${provider} tarafından yönetilen beceriler dizininden kaldırır. Bu işlem geri alınamaz.',
			'skills.screen.deleteTitle' => ({required Object name}) => '${name} silinsin mi?',
			'skills.screen.loadingSkills' => ({required Object provider}) => '${provider} becerileri yükleniyor…',
			'skills.screen.manageDescription' => ({required Object provider}) => '${provider} becerilerini yerel dosyalardan, eksiksiz klasörlerden ve proje bazlı konumlardan yönetin.',
			'skills.screen.noDescription' => 'Beceri front matter bölümünde açıklama belirtilmemiş.',
			'skills.screen.pluginBadge' => ({required Object name}) => 'Eklenti: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'Proje: ${name}',
			'skills.screen.savedSuccessfully' => 'Beceriler başarıyla kaydedildi.',
			'skills.screen.scanningProjectSkills' => 'Proje becerileri taranıyor...',
			'skills.screen.searchHint' => 'Beceri ara...',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} BECERİ', other: '${count} BECERİ', ), 
			'skills.screen.sourceLabel' => 'KAYNAK',
			'mcp.form.fields.bearerTokenEnvVar' => 'Bearer Token Ortam Değişkeni',
			'mcp.form.fields.envVarNames' => 'Ortam Değişkeni Adları',
			'mcp.form.fields.workingDirectory' => 'Çalışma Dizini',
			'mcp.form.scope.claudeLocal' => 'Claude Yerel',
			'mcp.form.scope.description.local' => 'Seçili proje için Claude kullanıcı ayarlarında saklanır',
			'mcp.form.scope.description.project' => 'Seçili proje çalışma alanında saklanır',
			'mcp.form.scope.description.projectGlobal' => 'Her sağlayıcı için seçili proje çalışma alanına yazar',
			'mcp.form.scope.description.user' => 'Makinenizdeki tüm projelerde kullanılabilir',
			'mcp.form.scope.description.userGlobal' => 'Her sağlayıcının kullanıcı yapılandırmasına yazar ve bu makinedeki projelerde kullanılabilir',
			'mcp.form.scope.projectAllProviders' => 'Proje (Tüm Sağlayıcılar)',
			'mcp.form.scope.userAllProviders' => 'Kullanıcı (Tüm Sağlayıcılar)',
			'mcp.form.submitTo' => ({required Object provider}) => 'Sunucuyu ${provider} için ekle',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'MCP Sunucusu Ekle, tüm sağlayıcılarda yalnızca stdio ve http destekler; ${type} desteklemez.',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider}, ${type} MCP sunucularını desteklemiyor',
			'mcp.install.button' => 'Kur',
			'mcp.install.cardDescription' => 'Agentlarınıza MCP üzerinden bilgi tabanını ve ddagent araçlarını verin — agentları seçin veya tümü için kurun.',
			'mcp.install.description' => 'Seçili agentların MCP üzerinden ddagent bilgi tabanını ve araçlarını kullanmasını sağlar.',
			'mcp.install.errorFallback' => 'hata',
			'mcp.install.failed' => ({required Object error}) => 'Kurulum başarısız: ${error}',
			'mcp.install.installForAll' => 'Tümü için kur',
			'mcp.install.installSelected' => 'Seçilenler için kur',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} agenta kuruldu.', other: '${count} agenta kuruldu.', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => '${count} agenta kuruldu; başarısız: ${failed}',
			'mcp.install.title' => 'ddagent MCP sunucusunu kur',
			'mcp.servers.addGlobalDescription' => 'Bu MCP sunucusunu tüm sağlayıcılara ekler: Claude, Cursor, Codex, OpenCode ve Devin. Aynı yapılandırmanın tüm sağlayıcılarda çalışması gerektiğinden yalnızca stdio ve HTTP taşımaları desteklenir.',
			'mcp.servers.addGlobalMenuDescription' => 'Genel MCP Sunucusu Ekle, Claude, Cursor, Codex, OpenCode ve Devin için ortak bir stdio veya HTTP sunucusu yazar.',
			'mcp.servers.addGlobalTitle' => 'Genel MCP Sunucusu Ekle',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => '${provider} MCP Sunucusu Ekle yalnızca ${provider} yapılandırmasını değiştirir.',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => '${provider} MCP Sunucusu Ekle',
			'mcp.servers.config.cwd' => 'Çalışma Dizini',
			'mcp.servers.config.envVars' => 'Ortam Değişkenleri',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Model Context Protocol sunucuları ${provider} için ek araçlar ve veri kaynakları sağlar',
			'mcp.servers.loading' => 'MCP sunucuları yükleniyor...',
			'mcp.servers.refreshingScopes' => 'Proje kapsamları yenileniyor...',
			'mcp.team.cta' => 'ddagent Pro ile kullanılabilir',
			'mcp.team.description' => 'MCP sunucu yapılandırmalarını takımınızla paylaşın. Herkes otomatik olarak senkron kalır.',
			'mcp.team.title' => 'Takım MCP Yapılandırmaları',
			'mcp.tokens.scopeWrite' => 'Yazma',
			'terminal.actions.clearOutput' => 'Çıktıyı Temizle',
			'terminal.actions.connect' => 'Bağlan',
			'terminal.actions.newShell' => 'Yeni Shell',
			'terminal.actions.newTab' => 'Yeni Terminal Sekmesi',
			'terminal.actions.providerLogin' => 'Sağlayıcı Girişi',
			'terminal.actions.restartSession' => 'Oturumu Yeniden Başlat',
			'terminal.authUrl.openInBrowser' => 'Tarayıcıda aç',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'Bağlantı açılamadı: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'Dosya algılandı: ${path}',
			'terminal.paste.hint' => 'Ctrl+V / sağ tık → Yapıştır',
			'terminal.paste.title' => 'Terminale yapıştır',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.hide' => 'Kısayol çubuğunu gizle',
			'terminal.shortcuts.interrupt' => 'Kes (SIGINT)',
			'terminal.shortcuts.suspend' => 'Askıya al (SIGTSTP)',
			'terminal.shortcuts.showTooltip' => 'Kısayolları göster',
			'terminal.shortcuts.hideTooltip' => 'Kısayolları gizle',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'Giriş: ${provider}',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.plainShell' => 'Basit Shell',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'worktrees.branchHint' => 'Yeni dal adı (örn. feature/login)',
			'worktrees.branchingOff' => ({required Object branch}) => '${branch} dalından ayrılıyor',
			'worktrees.cleanupDescription' => 'Birleştirildikten sonra worktree\'yi kaldır ve dalı sil',
			'worktrees.created' => 'Worktree oluşturuldu',
			'worktrees.deleteBranchLabel' => 'Dalı da sil',
			'worktrees.dirtyWarning' => ({required Object count}) => 'Uyarı: Bu worktree\'de kaybolacak ${count} commit edilmemiş değişiklik var.',
			'worktrees.emptyDescription' => 'Özellik çalışmalarını veya agent çalıştırmalarını yalıtmak için bir worktree oluşturun.',
			'worktrees.emptyTitle' => 'Worktree bulunamadı',
			'worktrees.forceRemoveLabel' => 'Zorla kaldır (değişikliklerden vazgeç)',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD ${sha} konumunda ayrık',
			'worktrees.mainBadge' => 'main',
			'worktrees.mergeDescription' => ({required Object branch}) => 'Değişiklikleri ${branch} dalına birleştir.',
			'worktrees.mergeTitle' => ({required Object branch}) => '${branch} dalını birleştir',
			'worktrees.merged' => ({required Object branch}) => 'Worktree ${branch} dalına birleştirildi',
			'worktrees.opened' => ({required Object branch}) => 'Worktree açıldı: ${branch}',
			'worktrees.portHint' => 'Çalıştırma portu (isteğe bağlı, örn. 3000)',
			'worktrees.removeDescription' => 'Bu, worktree klasörünü siler. Bağlı projeler arşivlenecek.',
			'worktrees.removeTitle' => ({required Object branch}) => '${branch} worktree\'si kaldırılsın mı?',
			'worktrees.removed' => 'Worktree kaldırıldı',
			'worktrees.runButton' => 'Çalıştır',
			'worktrees.runHint' => 'Çalıştırma komutu (örn. npm run dev)',
			'worktrees.runRunning' => 'çalışıyor',
			'worktrees.runRunningWithPort' => ({required Object port}) => 'çalışıyor :${port}',
			'worktrees.scripts' => 'Scriptler',
			'worktrees.scriptsSaved' => 'Script yapılandırması kaydedildi',
			'worktrees.serverLabel' => 'Sunucu: ',
			'worktrees.setupHint' => 'Kurulum komutu (örn. npm install)',
			'worktrees.setupLabel' => 'Kurulum: ',
			'worktrees.squashDescription' => 'Tüm commitleri tek bir committe birleştir',
			'worktrees.stopButton' => 'Durdur',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.chart.hide' => 'Gizle',
			'quota.chart.noData' => 'Eğilim için yeterli veri yok.',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} token · ${cost}',
			'quota.chart.show' => 'Göster',
			'quota.config.accountRouting' => 'Hesap yönlendirme',
			'quota.config.pollerTitle' => 'Sorgulama ve uyarılar',
			'quota.config.save' => 'Yapılandırmayı kaydet',
			'quota.overview.tokensAndCost' => 'Tokenlar ve maliyet',
			'quota.section.config' => 'Yapılandırma',
			'scheduler.checking' => 'Kontrol ediliyor…',
			'scheduler.cronHint' => 'Cron (dakika saat gün ay haftanın günü) — örn. 0 9 * * *',
			'scheduler.deleteMessage' => ({required Object id}) => 'Bu, ${id} yinelenen görevini kaldırır. Mevcut oturumlar korunur.',
			'scheduler.deleteTitle' => 'Zamanlama silinsin mi?',
			'scheduler.editTitle' => 'Zamanlamayı düzenle',
			'scheduler.newLabel' => 'Yeni',
			'scheduler.nextIn' => ({required Object time}) => '${time} sonra',
			'scheduler.promptHint' => 'Agent için prompt',
			'scheduler.runs' => 'Çalıştırmalar',
			'scheduler.session' => ({required Object id}) => 'oturum ${id}',
			'scheduler.worktree' => 'worktree',
			'notifications.deviceLabel' => 'ddagent Flutter',
			'notifications.errors.noResponse' => 'Sunucudan yanıt yok',
			'notifications.errors.registrationRejected' => 'Kayıt sunucu tarafından reddedildi',
			'serverConnect.connect' => 'Bağlan',
			'serverConnect.connecting' => 'Bağlanılıyor…',
			'serverConnect.changeServer' => 'Sunucuyu değiştir',
			'serverConnect.connectionFailed' => ({required Object error}) => 'Bağlantı başarısız (${error})',
			'serverConnect.enterUrl' => 'Bir sunucu URL\'si girin',
			'serverConnect.local.title' => 'Bu cihaz',
			'serverConnect.local.subtitle' => 'ddagent sunucusunu bu makinede çalıştırın',
			'serverConnect.local.install' => 'Yerel sunucuyu kur',
			'serverConnect.local.start' => 'Yerel sunucuyu başlat',
			'serverConnect.local.stop' => 'Durdur',
			'serverConnect.local.starting' => 'Yerel sunucu başlatılıyor…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'Sunucu indiriliyor… %${percent}',
			'serverConnect.local.installing' => 'Kuruluyor…',
			'serverConnect.local.running' => ({required Object url}) => '${url} adresinde çalışıyor',
			'serverConnect.local.installed' => ({required Object version}) => 'Kurulu (v${version})',
			'serverConnect.local.connect' => 'Bu sunucuyu kullan',
			'serverConnect.local.error' => ({required Object error}) => 'Yerel sunucu hatası: ${error}',
			'serverConnect.local.or' => 'veya uzak bir sunucuya bağlanın',
			'serverConnect.subtitle' => 'ddagent sunucunuza bağlanın',
			'voice.apiKeySaved' => 'API Anahtarı (kayıtlı, değiştirmek için girin)',
			'voice.preview' => 'Önizle',
			'voice.saveFailed' => 'STT yapılandırması kaydedilemedi',
			'voice.settingsSaved' => 'Sesli giriş ayarları kaydedildi',
			'preview.embeddedWebOnly' => 'Gömülü önizleme yalnızca web sürümünde kullanılabilir',
			'preview.startDevServerHint' => 'Bir geliştirme sunucusu başlatın (npm run dev, flutter run -d web-server…)\nve portu burada görünecek.',
			'sharedContext.title' => 'Paylaşılan Notlar',
			'collab.copyToken' => 'Token\'ı kopyala',
			'collab.createInvite' => 'Davet oluştur',
			'collab.invite' => 'Davet et',
			'collab.inviteTeammate' => 'Takım arkadaşını davet et',
			'collab.roles.member' => 'Üye',
			'collab.roles.viewer' => 'Görüntüleyici',
			'collab.shareTokenHint' => 'Bu davet token\'ını paylaşın — yalnızca bir kez gösterilir ve 72 saat içinde sona erer:',
			'collab.team' => 'Takım',
			'browser.dialogTitle' => 'Agent Tarayıcısı',
			'browser.viewError' => 'Tarayıcı görünümü hatası',
			'browser.web' => 'Web',
			'projects.archive' => 'Arşivle',
			'projects.archivedSection' => ({required Object count}) => 'Arşivlenenler (${count})',
			'projects.clone' => 'Klonla',
			'projects.cloneFailed' => 'Klonlama başarısız',
			'projects.cloneFinished' => 'Klonlama tamamlandı. Proje listesi yenileniyor…',
			'projects.cloneRepository' => 'Depoyu klonla',
			'projects.deletePermanently' => 'Kalıcı olarak sil',
			'projects.deleteProjectMessage' => ({required Object name}) => '"${name}" öğesini tüm oturumları ve saklanan geçmişiyle (JSONL silme) kalıcı olarak kaldırır. Bu işlem geri alınamaz.',
			'projects.deleteProjectTitle' => 'Proje silinsin mi?',
			'projects.destinationPath' => 'Hedef yol',
			'projects.destinationPathRequired' => 'Hedef yol gerekli',
			'projects.displayNameOptional' => 'Görünen ad (isteğe bağlı)',
			'projects.failedToLoadTokens' => 'GitHub token\'ları yüklenemedi',
			'projects.githubTokenOptional' => 'GitHub token\'ı (isteğe bağlı)',
			'projects.newer' => 'Daha yeni',
			'projects.older' => 'Daha eski',
			'projects.projectArchived' => 'Proje arşivlendi',
			'projects.projectDeleted' => 'Proje silindi',
			'projects.projectRenamed' => 'Proje yeniden adlandırıldı',
			'projects.projectRestored' => 'Proje geri yüklendi',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.repositoryCloned' => 'Depo klonlandı',
			'projects.repositoryUrlRequired' => 'Depo URL\'si gerekli',
			'projects.restore' => 'Geri yükle',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} oturum', other: '${count} oturum', ), 
			'projects.unknown' => 'Bilinmiyor',
			'projects.usingStoredToken' => ({required Object name}) => 'Kayıtlı token kullanılıyor: ${name}',
			'sessions.activity.committingChanges' => 'Değişiklikler commit ediliyor',
			'sessions.activity.editingFile' => ({required Object file}) => '${file} düzenleniyor',
			'sessions.activity.editingFileGeneric' => 'Bir dosya düzenleniyor',
			'sessions.activity.fetchingUrl' => ({required Object url}) => '${url} getiriliyor',
			'sessions.activity.pushingBranch' => 'Dal gönderiliyor',
			'sessions.activity.readingFile' => ({required Object file}) => '${file} okunuyor',
			'sessions.activity.runningCommand' => ({required Object command}) => '`${command}` çalıştırılıyor',
			'sessions.activity.runningShellCommand' => 'Bir shell komutu çalıştırılıyor',
			'sessions.activity.runningTool' => ({required Object name}) => '${name} çalıştırılıyor',
			'sessions.activity.searching' => ({required Object query}) => '“${query}” aranıyor',
			'sessions.activity.subagentRunning' => 'Alt agent çalışıyor',
			'sessions.age.days' => ({required Object days}) => '${days}g',
			'sessions.age.hours' => ({required Object hours}) => '${hours}sa',
			'sessions.age.lessThanMinute' => '<1dk',
			'sessions.age.minutes' => ({required Object count}) => '${count}dk',
			'sessions.archive' => 'Arşivle',
			'sessions.archivedSessions' => 'Arşivlenmiş oturumlar',
			'sessions.autoOrchestrator' => 'Otomatik (düzenleyici)',
			'sessions.compareWith' => 'Şununla karşılaştır…',
			'sessions.createFailed' => ({required Object error}) => 'Oturum oluşturulamadı: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => '"${name}" öğesini ve transkriptini kaldırır. Bu işlem geri alınamaz.',
			'sessions.newSessionProvider' => 'Yeni oturum — sağlayıcı',
			'sessions.noRecentSessions' => 'Yakın zamanda oturum yok',
			'sessions.noSessions' => 'Oturum yok',
			'sessions.projectPath' => 'Proje yolu',
			'sessions.rename' => 'Yeniden adlandır',
			'sessions.toasts.archived' => 'Oturum arşivlendi',
			'sessions.toasts.deleted' => 'Oturum silindi',
			'sessions.toasts.pinned' => 'Oturum sabitlendi',
			'sessions.toasts.renamed' => 'Oturum yeniden adlandırıldı',
			'sessions.toasts.restored' => 'Oturum geri yüklendi',
			'sessions.toasts.unpinned' => 'Oturum sabitlemesi kaldırıldı',
			'sessions.toasts.workspaceChanged' => 'Çalışma alanı değiştirildi',
			'git.aiButton' => '✦ AI',
			'git.checkpoints.create' => 'Yeni',
			'git.checkpoints.empty' => 'Henüz kontrol noktası yok',
			'git.checkpoints.labelHint' => 'Kontrol noktası etiketi (isteğe bağlı)',
			'git.checkpoints.restoreMessage' => 'Çalışma ağacı bu kontrol noktasına sıfırlansın mı? Mevcut değişiklikler değiştirilecek.',
			'git.checkpoints.restoreTitle' => 'Kontrol noktasını geri yükle',
			'git.checkpoints.restored' => 'Kontrol noktası geri yüklendi',
			'git.checkpoints.title' => 'Kontrol Noktaları',
			'git.commitCreated' => 'Commit oluşturuldu',
			'git.commitMessage' => 'Commit mesajı',
			'git.deleteFile' => 'Dosyayı sil',
			'git.hunkStage' => '+ Parça',
			'git.hunkUnstage' => '− Parça',
			'git.largeDiff' => 'Büyük diff önizlemesi: sekmeyi yanıt vermeye devam ettirmek için görüntüleme sınırlandırılır.',
			'git.loadDiffFailed' => ({required Object error}) => 'Diff yüklenemedi: ${error}',
			'git.noBranch' => 'dal yok',
			'git.noDiff' => 'Diff yok',
			'git.selectProject' => 'Bir proje seçin',
			'git.splitDiff' => 'Diff\'i böl',
			'git.stageHunk' => 'Parçayı hazırla',
			'git.stagedChanges' => 'Hazırlanan Değişiklikler',
			'git.statusStaged' => 'Hazırlandı',
			'git.switchBranch' => 'Dal değiştir',
			'git.unifiedDiff' => 'Birleşik diff',
			'git.unstageHunk' => 'Parçanın hazırlığını geri al',
			'kanban.card.untitled' => 'Adsız',
			'kanban.comments.add' => 'Yorum ekle',
			'kanban.comments.empty' => 'Henüz yorum yok',
			'kanban.details.status' => ({required Object status}) => 'Durum: ${status}',
			'kanban.details.title' => 'Kart Ayrıntıları',
			'kanban.dialog.saving' => 'Kaydediliyor…',
			'kanban.empty.noProject' => 'Proje seçilmedi',
			'kanban.saveFailed' => 'Kart kaydedilemedi',
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '1 gün önce', other: '${count} gün önce', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '1 saat önce', other: '${count} saat önce', ), 
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '1 dakika önce', other: '${count} dakika önce', ), 
			'kanban.time.now' => 'şimdi',
			'onboarding.agents.description' => 'Bir veya daha fazla AI kodlama asistanına giriş yapın. Tümü isteğe bağlıdır.',
			'onboarding.agents.laterHint' => 'Bunları daha sonra Ayarlar\'dan yapılandırabilirsiniz.',
			'onboarding.agents.title' => 'AI Agentlarınızı Bağlayın',
			'onboarding.completeSetup' => 'Kurulumu Tamamla',
			'onboarding.errors.invalidEmail' => 'Lütfen geçerli bir e-posta adresi girin.',
			'onboarding.errors.nameAndEmailRequired' => 'Hem git adı hem de e-posta gerekli.',
			'onboarding.gitHint' => 'ddagent oturumlarının oluşturduğu commit\'ler için kullanılır.',
			'onboarding.mcp.description' => 'Agentlarınızın bilgi tabanını ve ddagent araçlarını kullanabilmesi için ddagent MCP sunucusunu kurun. Agentları seçin veya tümü için kurun.',
			'onboarding.mcp.installForAll' => 'Tümü için kur',
			'onboarding.mcp.installSelected' => 'Seçilenler için kur',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('tr'))(count, one: '${count} agenta kuruldu.', other: '${count} agenta kuruldu.', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => '${installedCount} agenta kuruldu; başarısız: ${failed}',
			'onboarding.mcp.laterHint' => 'İsteğe bağlı — bunu daha sonra Ayarlar → MCP bölümünden de kurabilirsiniz.',
			'onboarding.mcp.title' => 'Agentları ddagent\'a bağlayın',
			'fileTree.browseServerFilesystem' => 'Sunucu dosya sistemine göz at',
			'fileTree.chooseFolder' => 'Klasör seç',
			'fileTree.copyContents' => 'İçeriği kopyala',
			'fileTree.noFiles' => 'Dosya yok',
			'fileTree.search.hint' => 'Adları filtreleyin / içerikte aramak için Enter\'a basın',
			'fileTree.search.noMatches' => 'Eşleşme yok',
			'fileTree.search.prompt' => 'Bir sorgu yazın ve Enter\'a basın',
			'fileTree.search.resultsTruncated' => 'Sonuçlar kısaltıldı',
			'fileTree.titles.delete' => ({required Object name}) => '${name} sil',
			'fileTree.titles.download' => ({required Object name}) => '${name} indir',
			'fileTree.titles.rename' => ({required Object name}) => '${name} öğesini yeniden adlandır',
			'fileTree.uploadHere' => 'Buraya yükle',
			'fileTree.uploadTo' => 'Şuraya yükle',
			'fileTree.uploadedCount' => ({required Object count}) => '${count} dosya yüklendi',
			'fileTree.newName' => 'Yeni ad',
			'fileTree.notRegisteredProject' => ({required Object path}) => 'Kayıtlı bir proje değil: ${path}',
			'fileTree.showGitignoredFiles' => 'Git tarafından yok sayılan dosyaları göster',
			'fileTree.hideGitignoredFiles' => 'Git tarafından yok sayılan dosyaları gizle',
			'fileTree.downloadUnsupportedOnWeb' => 'Web\'de indirme desteklenmiyor',
			'fileTree.saveToPath' => 'Yola kaydet',
			'fileTree.savedTo' => ({required Object path}) => 'Şuraya kaydedildi: ${path}',
			'workspace.archivedWorkspaceName' => 'Arşivlenmiş',
			'workspace.closePane' => 'Bölmeyi kapat',
			'workspace.closeSearch' => 'Aramayı kapat',
			'workspace.deleteSessionNotice' => 'Oturumu ve transkriptini kaldırır. Geri alınamaz.',
			'workspace.exportChat' => 'Sohbeti dışa aktar',
			'workspace.jumpToSession' => 'Oturuma git…',
			'workspace.newChatProvider' => 'Yeni sohbet — sağlayıcı',
			'workspace.nextMatch' => 'Sonraki eşleşme',
			'workspace.previousMatch' => 'Önceki eşleşme',
			'workspace.searchTranscript' => 'Transkriptte ara',
			'workspace.sendTo' => ({required Object count}) => '${count} oturuma gönder',
			'workspace.accountWithLabel' => ({required Object label}) => 'Varsayılan · ${label}',
			_ => null,
		} ?? switch (path) {
			'workspace.finishRunBeforeChangingWorkspace' => 'Çalışma alanını değiştirmeden önce çalıştırmayı bitir',
			'workspace.restored' => 'Çalışma alanı geri yüklendi',
			'workspace.maximizePane' => 'Bölmeyi büyüt',
			'workspace.restorePanes' => 'Bölmeleri geri yükle',
			'workspace.reviewChangedFiles' => 'Değişen dosyaları incele',
			_ => null,
		};
	}
}
