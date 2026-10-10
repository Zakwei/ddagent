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
class TranslationsJa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$ja auth = Translations$auth$ja._(_root);
	@override late final Translations$chat$ja chat = Translations$chat$ja._(_root);
	@override late final Translations$codeEditor$ja codeEditor = Translations$codeEditor$ja._(_root);
	@override late final Translations$common$ja common = Translations$common$ja._(_root);
	@override late final Translations$settings$ja settings = Translations$settings$ja._(_root);
	@override late final Translations$sidebar$ja sidebar = Translations$sidebar$ja._(_root);
	@override late final Translations$tasks$ja tasks = Translations$tasks$ja._(_root);
	@override late final Translations$knowledge$ja knowledge = Translations$knowledge$ja._(_root);
	@override late final Translations$browser$ja browser = Translations$browser$ja._(_root);
	@override late final Translations$collab$ja collab = Translations$collab$ja._(_root);
	@override late final Translations$fileTree$ja fileTree = Translations$fileTree$ja._(_root);
	@override late final Translations$git$ja git = Translations$git$ja._(_root);
	@override late final Translations$kanban$ja kanban = Translations$kanban$ja._(_root);
	@override late final Translations$mcp$ja mcp = Translations$mcp$ja._(_root);
	@override late final Translations$notifications$ja notifications = Translations$notifications$ja._(_root);
	@override late final Translations$onboarding$ja onboarding = Translations$onboarding$ja._(_root);
	@override late final Translations$projects$ja projects = Translations$projects$ja._(_root);
	@override late final Translations$quota$ja quota = Translations$quota$ja._(_root);
	@override late final Translations$scheduler$ja scheduler = Translations$scheduler$ja._(_root);
	@override late final Translations$serverConnect$ja serverConnect = Translations$serverConnect$ja._(_root);
	@override late final Translations$sessions$ja sessions = Translations$sessions$ja._(_root);
	@override late final Translations$sharedContext$ja sharedContext = Translations$sharedContext$ja._(_root);
	@override late final Translations$skills$ja skills = Translations$skills$ja._(_root);
	@override late final Translations$terminal$ja terminal = Translations$terminal$ja._(_root);
	@override late final Translations$voice$ja voice = Translations$voice$ja._(_root);
	@override late final Translations$workspace$ja workspace = Translations$workspace$ja._(_root);
	@override late final Translations$worktrees$ja worktrees = Translations$worktrees$ja._(_root);
	@override late final Translations$browserUse$ja browserUse = Translations$browserUse$ja._(_root);
	@override late final Translations$orchestrator$ja orchestrator = Translations$orchestrator$ja._(_root);
	@override late final Translations$miniOrchestrator$ja miniOrchestrator = Translations$miniOrchestrator$ja._(_root);
}

// Path: auth
class Translations$auth$ja extends Translations$auth$en {
	Translations$auth$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => 'セッションの有効期限が切れました。再度ログインしてください。';
	@override late final Translations$auth$login$ja login = Translations$auth$login$ja._(_root);
	@override late final Translations$auth$register$ja register = Translations$auth$register$ja._(_root);
	@override late final Translations$auth$logout$ja logout = Translations$auth$logout$ja._(_root);
}

// Path: chat
class Translations$chat$ja extends Translations$chat$en {
	Translations$chat$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$ja codeBlock = Translations$chat$codeBlock$ja._(_root);
	@override late final Translations$chat$copyMessage$ja copyMessage = Translations$chat$copyMessage$ja._(_root);
	@override late final Translations$chat$messageTypes$ja messageTypes = Translations$chat$messageTypes$ja._(_root);
	@override late final Translations$chat$orchestrator$ja orchestrator = Translations$chat$orchestrator$ja._(_root);
	@override late final Translations$chat$tools$ja tools = Translations$chat$tools$ja._(_root);
	@override late final Translations$chat$search$ja search = Translations$chat$search$ja._(_root);
	@override late final Translations$chat$fileOperations$ja fileOperations = Translations$chat$fileOperations$ja._(_root);
	@override late final Translations$chat$interactive$ja interactive = Translations$chat$interactive$ja._(_root);
	@override late final Translations$chat$thinking$ja thinking = Translations$chat$thinking$ja._(_root);
	@override late final Translations$chat$json$ja json = Translations$chat$json$ja._(_root);
	@override late final Translations$chat$permissions$ja permissions = Translations$chat$permissions$ja._(_root);
	@override late final Translations$chat$todo$ja todo = Translations$chat$todo$ja._(_root);
	@override late final Translations$chat$plan$ja plan = Translations$chat$plan$ja._(_root);
	@override late final Translations$chat$usageLimit$ja usageLimit = Translations$chat$usageLimit$ja._(_root);
	@override late final Translations$chat$codex$ja codex = Translations$chat$codex$ja._(_root);
	@override late final Translations$chat$voice$ja voice = Translations$chat$voice$ja._(_root);
	@override late final Translations$chat$input$ja input = Translations$chat$input$ja._(_root);
	@override late final Translations$chat$composer$ja composer = Translations$chat$composer$ja._(_root);
	@override late final Translations$chat$providerSelection$ja providerSelection = Translations$chat$providerSelection$ja._(_root);
	@override late final Translations$chat$session$ja session = Translations$chat$session$ja._(_root);
	@override late final Translations$chat$shell$ja shell = Translations$chat$shell$ja._(_root);
	@override late final Translations$chat$claudeStatus$ja claudeStatus = Translations$chat$claudeStatus$ja._(_root);
	@override late final Translations$chat$projectSelection$ja projectSelection = Translations$chat$projectSelection$ja._(_root);
	@override late final Translations$chat$tasks$ja tasks = Translations$chat$tasks$ja._(_root);
	@override late final Translations$chat$splitSession$ja splitSession = Translations$chat$splitSession$ja._(_root);
	@override late final Translations$chat$sessionPicker$ja sessionPicker = Translations$chat$sessionPicker$ja._(_root);
	@override late final Translations$chat$splitWorkspace$ja splitWorkspace = Translations$chat$splitWorkspace$ja._(_root);
	@override late final Translations$chat$splitOverview$ja splitOverview = Translations$chat$splitOverview$ja._(_root);
	@override late final Translations$chat$askUserQuestion$ja askUserQuestion = Translations$chat$askUserQuestion$ja._(_root);
	@override late final Translations$chat$attachments$ja attachments = Translations$chat$attachments$ja._(_root);
	@override late final Translations$chat$checkpoint$ja checkpoint = Translations$chat$checkpoint$ja._(_root);
	@override late final Translations$chat$common$ja common = Translations$chat$common$ja._(_root);
	@override late final Translations$chat$taskMaster$ja taskMaster = Translations$chat$taskMaster$ja._(_root);
	@override late final Translations$chat$tokenUsage$ja tokenUsage = Translations$chat$tokenUsage$ja._(_root);
	@override late final Translations$chat$tool$ja tool = Translations$chat$tool$ja._(_root);
	@override late final Translations$chat$quotaBadge$ja quotaBadge = Translations$chat$quotaBadge$ja._(_root);
	@override late final Translations$chat$broadcast$ja broadcast = Translations$chat$broadcast$ja._(_root);
	@override late final Translations$chat$paneHeader$ja paneHeader = Translations$chat$paneHeader$ja._(_root);
	@override late final Translations$chat$export$ja export = Translations$chat$export$ja._(_root);
	@override late final Translations$chat$commandResult$ja commandResult = Translations$chat$commandResult$ja._(_root);
	@override late final Translations$chat$commands$ja commands = Translations$chat$commands$ja._(_root);
	@override late final Translations$chat$pinFile$ja pinFile = Translations$chat$pinFile$ja._(_root);
	@override late final Translations$chat$modelLibrary$ja modelLibrary = Translations$chat$modelLibrary$ja._(_root);
	@override late final Translations$chat$changes$ja changes = Translations$chat$changes$ja._(_root);
	@override late final Translations$chat$message$ja message = Translations$chat$message$ja._(_root);
	@override late final Translations$chat$permissionRequest$ja permissionRequest = Translations$chat$permissionRequest$ja._(_root);
	@override late final Translations$chat$commandDialog$ja commandDialog = Translations$chat$commandDialog$ja._(_root);
	@override late final Translations$chat$utilities$ja utilities = Translations$chat$utilities$ja._(_root);
	@override late final Translations$chat$toolBlocks$ja toolBlocks = Translations$chat$toolBlocks$ja._(_root);
	@override late final Translations$chat$commandMenu$ja commandMenu = Translations$chat$commandMenu$ja._(_root);
	@override late final Translations$chat$mentionMenu$ja mentionMenu = Translations$chat$mentionMenu$ja._(_root);
	@override late final Translations$chat$subheader$ja subheader = Translations$chat$subheader$ja._(_root);
	@override late final Translations$chat$transcript$ja transcript = Translations$chat$transcript$ja._(_root);
	@override late final Translations$chat$review$ja review = Translations$chat$review$ja._(_root);
}

// Path: codeEditor
class Translations$codeEditor$ja extends Translations$codeEditor$en {
	Translations$codeEditor$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$ja toolbar = Translations$codeEditor$toolbar$ja._(_root);
	@override String loading({required Object fileName}) => '${fileName}を読み込んでいます...';
	@override late final Translations$codeEditor$header$ja header = Translations$codeEditor$header$ja._(_root);
	@override late final Translations$codeEditor$actions$ja actions = Translations$codeEditor$actions$ja._(_root);
	@override late final Translations$codeEditor$footer$ja footer = Translations$codeEditor$footer$ja._(_root);
	@override late final Translations$codeEditor$binaryFile$ja binaryFile = Translations$codeEditor$binaryFile$ja._(_root);
	@override late final Translations$codeEditor$filePreview$ja filePreview = Translations$codeEditor$filePreview$ja._(_root);
	@override String unsavedChanges({required Object name}) => '${name} に未保存の変更があります';
	@override String get discardUnsavedChanges => '未保存の変更を破棄しますか？';
	@override late final Translations$codeEditor$mediaFile$ja mediaFile = Translations$codeEditor$mediaFile$ja._(_root);
	@override String get failedToLoad => 'ファイルの読み込みに失敗しました';
	@override late final Translations$codeEditor$hexDump$ja hexDump = Translations$codeEditor$hexDump$ja._(_root);
	@override late final Translations$codeEditor$settings$ja settings = Translations$codeEditor$settings$ja._(_root);
	@override late final Translations$codeEditor$diff$ja diff = Translations$codeEditor$diff$ja._(_root);
	@override late final Translations$codeEditor$emptyState$ja emptyState = Translations$codeEditor$emptyState$ja._(_root);
	@override late final Translations$codeEditor$toasts$ja toasts = Translations$codeEditor$toasts$ja._(_root);
}

// Path: common
class Translations$common$ja extends Translations$common$en {
	Translations$common$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$ja buttons = Translations$common$buttons$ja._(_root);
	@override late final Translations$common$tabs$ja tabs = Translations$common$tabs$ja._(_root);
	@override late final Translations$common$quota$ja quota = Translations$common$quota$ja._(_root);
	@override late final Translations$common$status$ja status = Translations$common$status$ja._(_root);
	@override late final Translations$common$messages$ja messages = Translations$common$messages$ja._(_root);
	@override late final Translations$common$navigation$ja navigation = Translations$common$navigation$ja._(_root);
	@override late final Translations$common$common$ja common = Translations$common$common$ja._(_root);
	@override late final Translations$common$time$ja time = Translations$common$time$ja._(_root);
	@override late final Translations$common$fileOperations$ja fileOperations = Translations$common$fileOperations$ja._(_root);
	@override late final Translations$common$mainContent$ja mainContent = Translations$common$mainContent$ja._(_root);
	@override late final Translations$common$fileTree$ja fileTree = Translations$common$fileTree$ja._(_root);
	@override late final Translations$common$projectWizard$ja projectWizard = Translations$common$projectWizard$ja._(_root);
	@override late final Translations$common$notifications$ja notifications = Translations$common$notifications$ja._(_root);
	@override late final Translations$common$versionUpdate$ja versionUpdate = Translations$common$versionUpdate$ja._(_root);
	@override late final Translations$common$actions$ja actions = Translations$common$actions$ja._(_root);
	@override late final Translations$common$browserPane$ja browserPane = Translations$common$browserPane$ja._(_root);
	@override late final Translations$common$browserUse$ja browserUse = Translations$common$browserUse$ja._(_root);
	@override late final Translations$common$commandPalette$ja commandPalette = Translations$common$commandPalette$ja._(_root);
	@override late final Translations$common$gitPanel$ja gitPanel = Translations$common$gitPanel$ja._(_root);
	@override late final Translations$common$sessions$ja sessions = Translations$common$sessions$ja._(_root);
	@override late final Translations$common$projects$ja projects = Translations$common$projects$ja._(_root);
	@override late final Translations$common$sharedNotes$ja sharedNotes = Translations$common$sharedNotes$ja._(_root);
	@override late final Translations$common$codeBlock$ja codeBlock = Translations$common$codeBlock$ja._(_root);
	@override late final Translations$common$update$ja update = Translations$common$update$ja._(_root);
	@override late final Translations$common$appShell$ja appShell = Translations$common$appShell$ja._(_root);
	@override late final Translations$common$errors$ja errors = Translations$common$errors$ja._(_root);
}

// Path: settings
class Translations$settings$ja extends Translations$settings$en {
	Translations$settings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override late final Translations$settings$changelog$ja changelog = Translations$settings$changelog$ja._(_root);
	@override late final Translations$settings$server$ja server = Translations$settings$server$ja._(_root);
	@override late final Translations$settings$updates$ja updates = Translations$settings$updates$ja._(_root);
	@override late final Translations$settings$tabs$ja tabs = Translations$settings$tabs$ja._(_root);
	@override late final Translations$settings$account$ja account = Translations$settings$account$ja._(_root);
	@override late final Translations$settings$mcp$ja mcp = Translations$settings$mcp$ja._(_root);
	@override late final Translations$settings$appearance$ja appearance = Translations$settings$appearance$ja._(_root);
	@override late final Translations$settings$actions$ja actions = Translations$settings$actions$ja._(_root);
	@override late final Translations$settings$quickSettings$ja quickSettings = Translations$settings$quickSettings$ja._(_root);
	@override late final Translations$settings$terminalShortcuts$ja terminalShortcuts = Translations$settings$terminalShortcuts$ja._(_root);
	@override late final Translations$settings$mainTabs$ja mainTabs = Translations$settings$mainTabs$ja._(_root);
	@override late final Translations$settings$miniOrchestration$ja miniOrchestration = Translations$settings$miniOrchestration$ja._(_root);
	@override late final Translations$settings$orchestration$ja orchestration = Translations$settings$orchestration$ja._(_root);
	@override late final Translations$settings$notifications$ja notifications = Translations$settings$notifications$ja._(_root);
	@override late final Translations$settings$appearanceSettings$ja appearanceSettings = Translations$settings$appearanceSettings$ja._(_root);
	@override late final Translations$settings$mcpForm$ja mcpForm = Translations$settings$mcpForm$ja._(_root);
	@override late final Translations$settings$saveStatus$ja saveStatus = Translations$settings$saveStatus$ja._(_root);
	@override late final Translations$settings$footerActions$ja footerActions = Translations$settings$footerActions$ja._(_root);
	@override late final Translations$settings$git$ja git = Translations$settings$git$ja._(_root);
	@override late final Translations$settings$apiKeys$ja apiKeys = Translations$settings$apiKeys$ja._(_root);
	@override late final Translations$settings$tasks$ja tasks = Translations$settings$tasks$ja._(_root);
	@override late final Translations$settings$agents$ja agents = Translations$settings$agents$ja._(_root);
	@override late final Translations$settings$permissions$ja permissions = Translations$settings$permissions$ja._(_root);
	@override late final Translations$settings$mcpServers$ja mcpServers = Translations$settings$mcpServers$ja._(_root);
	@override late final Translations$settings$quota$ja quota = Translations$settings$quota$ja._(_root);
	@override late final Translations$settings$browser$ja browser = Translations$settings$browser$ja._(_root);
	@override late final Translations$settings$workspaces$ja workspaces = Translations$settings$workspaces$ja._(_root);
	@override late final Translations$settings$stt$ja stt = Translations$settings$stt$ja._(_root);
	@override late final Translations$settings$schedules$ja schedules = Translations$settings$schedules$ja._(_root);
	@override late final Translations$settings$mcpTokens$ja mcpTokens = Translations$settings$mcpTokens$ja._(_root);
	@override late final Translations$settings$about$ja about = Translations$settings$about$ja._(_root);
	@override late final Translations$settings$shortcuts$ja shortcuts = Translations$settings$shortcuts$ja._(_root);
}

// Path: sidebar
class Translations$sidebar$ja extends Translations$sidebar$en {
	Translations$sidebar$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$ja projects = Translations$sidebar$projects$ja._(_root);
	@override late final Translations$sidebar$app$ja app = Translations$sidebar$app$ja._(_root);
	@override late final Translations$sidebar$panel$ja panel = Translations$sidebar$panel$ja._(_root);
	@override late final Translations$sidebar$sessions$ja sessions = Translations$sidebar$sessions$ja._(_root);
	@override late final Translations$sidebar$tooltips$ja tooltips = Translations$sidebar$tooltips$ja._(_root);
	@override late final Translations$sidebar$navigation$ja navigation = Translations$sidebar$navigation$ja._(_root);
	@override late final Translations$sidebar$actions$ja actions = Translations$sidebar$actions$ja._(_root);
	@override late final Translations$sidebar$workspace$ja workspace = Translations$sidebar$workspace$ja._(_root);
	@override late final Translations$sidebar$branding$ja branding = Translations$sidebar$branding$ja._(_root);
	@override late final Translations$sidebar$status$ja status = Translations$sidebar$status$ja._(_root);
	@override late final Translations$sidebar$time$ja time = Translations$sidebar$time$ja._(_root);
	@override late final Translations$sidebar$messages$ja messages = Translations$sidebar$messages$ja._(_root);
	@override late final Translations$sidebar$version$ja version = Translations$sidebar$version$ja._(_root);
	@override late final Translations$sidebar$search$ja search = Translations$sidebar$search$ja._(_root);
	@override late final Translations$sidebar$recent$ja recent = Translations$sidebar$recent$ja._(_root);
	@override late final Translations$sidebar$deleteConfirmation$ja deleteConfirmation = Translations$sidebar$deleteConfirmation$ja._(_root);
	@override late final Translations$sidebar$zones$ja zones = Translations$sidebar$zones$ja._(_root);
	@override late final Translations$sidebar$tabs$ja tabs = Translations$sidebar$tabs$ja._(_root);
}

// Path: tasks
class Translations$tasks$ja extends Translations$tasks$en {
	Translations$tasks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$ja notConfigured = Translations$tasks$notConfigured$ja._(_root);
	@override late final Translations$tasks$gettingStarted$ja gettingStarted = Translations$tasks$gettingStarted$ja._(_root);
	@override late final Translations$tasks$setupModal$ja setupModal = Translations$tasks$setupModal$ja._(_root);
	@override late final Translations$tasks$helpGuide$ja helpGuide = Translations$tasks$helpGuide$ja._(_root);
	@override late final Translations$tasks$search$ja search = Translations$tasks$search$ja._(_root);
	@override late final Translations$tasks$filters$ja filters = Translations$tasks$filters$ja._(_root);
	@override late final Translations$tasks$sort$ja sort = Translations$tasks$sort$ja._(_root);
	@override late final Translations$tasks$views$ja views = Translations$tasks$views$ja._(_root);
	@override late final Translations$tasks$kanban$ja kanban = Translations$tasks$kanban$ja._(_root);
	@override late final Translations$tasks$buttons$ja buttons = Translations$tasks$buttons$ja._(_root);
	@override late final Translations$tasks$prd$ja prd = Translations$tasks$prd$ja._(_root);
	@override late final Translations$tasks$statuses$ja statuses = Translations$tasks$statuses$ja._(_root);
	@override late final Translations$tasks$priorities$ja priorities = Translations$tasks$priorities$ja._(_root);
	@override late final Translations$tasks$noMatchingTasks$ja noMatchingTasks = Translations$tasks$noMatchingTasks$ja._(_root);
	@override late final Translations$tasks$board$ja board = Translations$tasks$board$ja._(_root);
	@override late final Translations$tasks$card$ja card = Translations$tasks$card$ja._(_root);
	@override late final Translations$tasks$createTask$ja createTask = Translations$tasks$createTask$ja._(_root);
	@override late final Translations$tasks$list$ja list = Translations$tasks$list$ja._(_root);
	@override late final Translations$tasks$nextTask$ja nextTask = Translations$tasks$nextTask$ja._(_root);
	@override late final Translations$tasks$taskDetail$ja taskDetail = Translations$tasks$taskDetail$ja._(_root);
	@override late final Translations$tasks$toasts$ja toasts = Translations$tasks$toasts$ja._(_root);
	@override late final Translations$tasks$taskmaster$ja taskmaster = Translations$tasks$taskmaster$ja._(_root);
}

// Path: knowledge
class Translations$knowledge$ja extends Translations$knowledge$en {
	Translations$knowledge$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ナレッジ';
	@override late final Translations$knowledge$tabs$ja tabs = Translations$knowledge$tabs$ja._(_root);
	@override late final Translations$knowledge$common$ja common = Translations$knowledge$common$ja._(_root);
	@override late final Translations$knowledge$actions$ja actions = Translations$knowledge$actions$ja._(_root);
	@override late final Translations$knowledge$dialog$ja dialog = Translations$knowledge$dialog$ja._(_root);
	@override late final Translations$knowledge$fields$ja fields = Translations$knowledge$fields$ja._(_root);
	@override late final Translations$knowledge$dashboard$ja dashboard = Translations$knowledge$dashboard$ja._(_root);
	@override late final Translations$knowledge$empty$ja empty = Translations$knowledge$empty$ja._(_root);
	@override late final Translations$knowledge$history$ja history = Translations$knowledge$history$ja._(_root);
	@override late final Translations$knowledge$priorities$ja priorities = Translations$knowledge$priorities$ja._(_root);
	@override late final Translations$knowledge$search$ja search = Translations$knowledge$search$ja._(_root);
	@override late final Translations$knowledge$links$ja links = Translations$knowledge$links$ja._(_root);
	@override late final Translations$knowledge$tags$ja tags = Translations$knowledge$tags$ja._(_root);
	@override late final Translations$knowledge$graph$ja graph = Translations$knowledge$graph$ja._(_root);
	@override late final Translations$knowledge$importAll$ja importAll = Translations$knowledge$importAll$ja._(_root);
	@override late final Translations$knowledge$migrate$ja migrate = Translations$knowledge$migrate$ja._(_root);
	@override late final Translations$knowledge$importSkills$ja importSkills = Translations$knowledge$importSkills$ja._(_root);
	@override late final Translations$knowledge$critical$ja critical = Translations$knowledge$critical$ja._(_root);
	@override late final Translations$knowledge$contextBudget$ja contextBudget = Translations$knowledge$contextBudget$ja._(_root);
	@override late final Translations$knowledge$linkOptions$ja linkOptions = Translations$knowledge$linkOptions$ja._(_root);
	@override late final Translations$knowledge$errors$ja errors = Translations$knowledge$errors$ja._(_root);
	@override late final Translations$knowledge$entityTypes$ja entityTypes = Translations$knowledge$entityTypes$ja._(_root);
}

// Path: browser
class Translations$browser$ja extends Translations$browser$en {
	Translations$browser$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => 'エージェントブラウザ';
	@override String get viewError => 'ブラウザ表示エラー';
	@override String get web => 'Web';
}

// Path: collab
class Translations$collab$ja extends Translations$collab$en {
	Translations$collab$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get team => 'チーム';
	@override String get invite => '招待';
	@override String get inviteTeammate => 'チームメイトを招待';
	@override String get shareTokenHint => 'この招待トークンを共有してください — 一度だけ表示され、72時間で失効します:';
	@override String get createInvite => '招待を作成';
	@override String get copyToken => 'トークンをコピー';
	@override late final Translations$collab$roles$ja roles = Translations$collab$roles$ja._(_root);
	@override late final Translations$collab$viewing$ja viewing = Translations$collab$viewing$ja._(_root);
}

// Path: fileTree
class Translations$fileTree$ja extends Translations$fileTree$en {
	Translations$fileTree$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get uploadTo => 'アップロード先';
	@override String get uploadHere => 'ここにアップロード';
	@override String get browseServerFilesystem => 'サーバーのファイルシステムを参照';
	@override String get noFiles => 'ファイルがありません';
	@override String get copyContents => '内容をコピー';
	@override String get chooseFolder => 'フォルダを選択';
	@override late final Translations$fileTree$search$ja search = Translations$fileTree$search$ja._(_root);
	@override late final Translations$fileTree$titles$ja titles = Translations$fileTree$titles$ja._(_root);
	@override String uploadedCount({required Object count}) => '${count} 件のファイルをアップロードしました';
	@override String get newName => '新しい名前';
	@override String notRegisteredProject({required Object path}) => '登録済みのプロジェクトではありません: ${path}';
	@override String get showGitignoredFiles => 'gitignore されたファイルを表示';
	@override String get hideGitignoredFiles => 'gitignore されたファイルを非表示';
	@override String get downloadUnsupportedOnWeb => 'Webではダウンロードを利用できません';
	@override String get saveToPath => 'パスに保存';
	@override String savedTo({required Object path}) => '${path} に保存しました';
	@override late final Translations$fileTree$relative$ja relative = Translations$fileTree$relative$ja._(_root);
	@override String get projectRoot => '（プロジェクトルート）';
	@override String uploadLimitCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '一度にアップロードできるのは最大 ${count} ファイルです。',
	);
	@override String fileTooLarge({required Object name}) => '${name} は 200MB を超えています。';
	@override String deleteFolderConfirm({required Object path}) => 'フォルダー「${path}」を削除しますか？この操作は元に戻せません。';
	@override String deleteFileConfirm({required Object path}) => 'ファイル「${path}」を削除しますか？この操作は元に戻せません。';
}

// Path: git
class Translations$git$ja extends Translations$git$en {
	Translations$git$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$git$checkpoints$ja checkpoints = Translations$git$checkpoints$ja._(_root);
	@override String get stagedChanges => 'ステージ済みの変更';
	@override String get statusStaged => 'ステージ済み';
	@override String get switchBranch => 'ブランチを切り替え';
	@override String get unifiedDiff => '統合差分';
	@override String get splitDiff => '分割差分';
	@override String get noDiff => '利用可能な差分がありません';
	@override String get largeDiff => '大きな差分のプレビュー: タブの応答性を保つため、レンダリングが制限されています。';
	@override String loadDiffFailed({required Object error}) => '差分の読み込みに失敗しました: ${error}';
	@override String get hunkStage => '+ ハンク';
	@override String get hunkUnstage => '− ハンク';
	@override String get stageHunk => 'ハンクをステージ';
	@override String get unstageHunk => 'ハンクのステージを解除';
	@override String get deleteFile => 'ファイルを削除';
	@override String get commitMessage => 'コミットメッセージ';
	@override String get aiButton => '✦ AI';
	@override String get commitCreated => 'コミットを作成しました';
	@override String get noBranch => 'ブランチなし';
	@override String get selectProject => 'プロジェクトを選択';
	@override late final Translations$git$branchSections$ja branchSections = Translations$git$branchSections$ja._(_root);
}

// Path: kanban
class Translations$kanban$ja extends Translations$kanban$en {
	Translations$kanban$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$ja card = Translations$kanban$card$ja._(_root);
	@override late final Translations$kanban$comments$ja comments = Translations$kanban$comments$ja._(_root);
	@override late final Translations$kanban$dialog$ja dialog = Translations$kanban$dialog$ja._(_root);
	@override late final Translations$kanban$details$ja details = Translations$kanban$details$ja._(_root);
	@override late final Translations$kanban$empty$ja empty = Translations$kanban$empty$ja._(_root);
	@override String get saveFailed => 'カードの保存に失敗しました';
	@override late final Translations$kanban$time$ja time = Translations$kanban$time$ja._(_root);
}

// Path: mcp
class Translations$mcp$ja extends Translations$mcp$en {
	Translations$mcp$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$install$ja install = Translations$mcp$install$ja._(_root);
	@override late final Translations$mcp$servers$ja servers = Translations$mcp$servers$ja._(_root);
	@override late final Translations$mcp$team$ja team = Translations$mcp$team$ja._(_root);
	@override late final Translations$mcp$tokens$ja tokens = Translations$mcp$tokens$ja._(_root);
	@override late final Translations$mcp$form$ja form = Translations$mcp$form$ja._(_root);
}

// Path: notifications
class Translations$notifications$ja extends Translations$notifications$en {
	Translations$notifications$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$ja errors = Translations$notifications$errors$ja._(_root);
	@override late final Translations$notifications$androidChannel$ja androidChannel = Translations$notifications$androidChannel$ja._(_root);
}

// Path: onboarding
class Translations$onboarding$ja extends Translations$onboarding$en {
	Translations$onboarding$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get gitHint => 'DDAgent セッションで作成されるコミットに使用されます。';
	@override String get completeSetup => 'セットアップを完了';
	@override late final Translations$onboarding$errors$ja errors = Translations$onboarding$errors$ja._(_root);
	@override late final Translations$onboarding$agents$ja agents = Translations$onboarding$agents$ja._(_root);
	@override late final Translations$onboarding$mcp$ja mcp = Translations$onboarding$mcp$ja._(_root);
}

// Path: projects
class Translations$projects$ja extends Translations$projects$en {
	Translations$projects$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cloneRepository => 'リポジトリをクローン';
	@override String get repositoryCloned => 'リポジトリをクローンしました';
	@override String get clone => 'クローン';
	@override String get cloneFinished => 'クローンが完了しました。プロジェクト一覧を更新中…';
	@override String get cloneFailed => 'クローンに失敗しました';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get destinationPath => '保存先パス';
	@override String get destinationPathRequired => '保存先パスは必須です';
	@override String get repositoryUrlRequired => 'リポジトリURLは必須です';
	@override String get githubTokenOptional => 'GitHubトークン（任意）';
	@override String get archive => 'アーカイブ';
	@override String get restore => '復元';
	@override String get deletePermanently => '完全に削除';
	@override String get deleteProjectTitle => 'プロジェクトを削除しますか？';
	@override String deleteProjectMessage({required Object name}) => '「${name}」を、すべてのセッションと保存済み履歴を含めて完全に削除します（JSONL も消去）。元に戻せません。';
	@override String archivedSection({required Object count}) => 'アーカイブ済み (${count})';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} セッション',
		other: '${count} セッション',
	);
	@override String get newer => '新しい方';
	@override String get older => '古い方';
	@override String get projectArchived => 'プロジェクトをアーカイブしました';
	@override String get projectRestored => 'プロジェクトを復元しました';
	@override String get projectRenamed => 'プロジェクト名を変更しました';
	@override String get projectDeleted => 'プロジェクトを削除しました';
	@override String get failedToLoadTokens => 'GitHubトークンの読み込みに失敗しました';
	@override String get displayNameOptional => '表示名（任意）';
	@override String usingStoredToken({required Object name}) => '保存済みトークンを使用: ${name}';
	@override String get unknown => '不明';
	@override String get project => 'プロジェクト';
}

// Path: quota
class Translations$quota$ja extends Translations$quota$en {
	Translations$quota$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$section$ja section = Translations$quota$section$ja._(_root);
	@override late final Translations$quota$overview$ja overview = Translations$quota$overview$ja._(_root);
	@override late final Translations$quota$agents$ja agents = Translations$quota$agents$ja._(_root);
	@override late final Translations$quota$config$ja config = Translations$quota$config$ja._(_root);
	@override late final Translations$quota$chart$ja chart = Translations$quota$chart$ja._(_root);
	@override late final Translations$quota$duration$ja duration = Translations$quota$duration$ja._(_root);
}

// Path: scheduler
class Translations$scheduler$ja extends Translations$scheduler$en {
	Translations$scheduler$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newLabel => '新規';
	@override String get runs => '実行回数';
	@override String get editTitle => 'スケジュールを編集';
	@override String get deleteTitle => 'スケジュールを削除しますか？';
	@override String deleteMessage({required Object id}) => '繰り返しジョブ ${id} を削除します。既存のセッションは保持されます。';
	@override String get checking => '確認中…';
	@override String nextIn({required Object time}) => '次回まで ${time}';
	@override String get worktree => 'worktree';
	@override String session({required Object id}) => 'セッション ${id}';
	@override String get cronHint => 'Cron（分 時 日 月 曜日） — 例: 0 9 * * *';
	@override String get promptHint => 'エージェントへのプロンプト';
	@override late final Translations$scheduler$runStatus$ja runStatus = Translations$scheduler$runStatus$ja._(_root);
	@override late final Translations$scheduler$cronErrors$ja cronErrors = Translations$scheduler$cronErrors$ja._(_root);
}

// Path: serverConnect
class Translations$serverConnect$ja extends Translations$serverConnect$en {
	Translations$serverConnect$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'DDAgent サーバーに接続';
	@override String get enterUrl => 'サーバーのURLを入力';
	@override String connectionFailed({required Object error}) => '接続に失敗しました (${error})';
	@override String get connect => '接続';
	@override String get connecting => '接続中…';
	@override String get changeServer => 'サーバーを変更';
	@override late final Translations$serverConnect$local$ja local = Translations$serverConnect$local$ja._(_root);
	@override String httpStatus({required Object code}) => 'HTTP ${code}';
	@override String get networkError => 'ネットワークエラー';
}

// Path: sessions
class Translations$sessions$ja extends Translations$sessions$en {
	Translations$sessions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get noSessions => 'セッションがありません';
	@override String get noRecentSessions => '最近のセッションはありません';
	@override String get archivedSessions => 'アーカイブ済みセッション';
	@override String get rename => '名前を変更';
	@override String get archive => 'アーカイブ';
	@override String get compareWith => '比較対象…';
	@override String get projectPath => 'プロジェクトパス';
	@override String get newSessionProvider => '新しいセッション — プロバイダー';
	@override String get autoOrchestrator => '自動（オーケストレーター）';
	@override String createFailed({required Object error}) => 'セッションの作成に失敗しました: ${error}';
	@override String deleteSessionMessage({required Object name}) => '「${name}」とそのトランスクリプトを削除します。元に戻せません。';
	@override late final Translations$sessions$toasts$ja toasts = Translations$sessions$toasts$ja._(_root);
	@override late final Translations$sessions$age$ja age = Translations$sessions$age$ja._(_root);
	@override late final Translations$sessions$activity$ja activity = Translations$sessions$activity$ja._(_root);
	@override String get autoMini => '自動（ミニ）';
}

// Path: sharedContext
class Translations$sharedContext$ja extends Translations$sharedContext$en {
	Translations$sharedContext$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '共有ノート';
}

// Path: skills
class Translations$skills$ja extends Translations$skills$en {
	Translations$skills$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String moveSkill({required Object name}) => '${name} を移動';
	@override String deleteSkill({required Object name}) => '${name} を削除';
	@override String get projectLabel => 'プロジェクト';
	@override late final Translations$skills$addDialog$ja addDialog = Translations$skills$addDialog$ja._(_root);
	@override late final Translations$skills$moveDialog$ja moveDialog = Translations$skills$moveDialog$ja._(_root);
	@override late final Translations$skills$screen$ja screen = Translations$skills$screen$ja._(_root);
	@override late final Translations$skills$empty$ja empty = Translations$skills$empty$ja._(_root);
	@override late final Translations$skills$scopes$ja scopes = Translations$skills$scopes$ja._(_root);
	@override late final Translations$skills$errors$ja errors = Translations$skills$errors$ja._(_root);
	@override String get providerShared => '共有';
}

// Path: terminal
class Translations$terminal$ja extends Translations$terminal$en {
	Translations$terminal$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$tabs$ja tabs = Translations$terminal$tabs$ja._(_root);
	@override late final Translations$terminal$actions$ja actions = Translations$terminal$actions$ja._(_root);
	@override late final Translations$terminal$authUrl$ja authUrl = Translations$terminal$authUrl$ja._(_root);
	@override late final Translations$terminal$fileLink$ja fileLink = Translations$terminal$fileLink$ja._(_root);
	@override late final Translations$terminal$shortcuts$ja shortcuts = Translations$terminal$shortcuts$ja._(_root);
	@override late final Translations$terminal$paste$ja paste = Translations$terminal$paste$ja._(_root);
	@override late final Translations$terminal$errors$ja errors = Translations$terminal$errors$ja._(_root);
	@override late final Translations$terminal$loginDialog$ja loginDialog = Translations$terminal$loginDialog$ja._(_root);
	@override late final Translations$terminal$empty$ja empty = Translations$terminal$empty$ja._(_root);
	@override late final Translations$terminal$overlay$ja overlay = Translations$terminal$overlay$ja._(_root);
}

// Path: voice
class Translations$voice$ja extends Translations$voice$en {
	Translations$voice$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get preview => 'プレビュー';
	@override String get settingsSaved => '音声入力設定を保存しました';
	@override String get saveFailed => 'STT設定の保存に失敗しました';
	@override String get apiKeySaved => 'APIキー（保存済み、変更するには入力）';
}

// Path: workspace
class Translations$workspace$ja extends Translations$workspace$en {
	Translations$workspace$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get exportChat => 'チャットをエクスポート';
	@override String get searchTranscript => 'トランスクリプトを検索';
	@override String get previousMatch => '前の一致';
	@override String get nextMatch => '次の一致';
	@override String get closeSearch => '検索を閉じる';
	@override String get newChatProvider => '新しいチャット — プロバイダー';
	@override String get closePane => 'ペインを閉じる';
	@override String get jumpToSession => 'セッションへジャンプ…';
	@override String get archivedWorkspaceName => 'アーカイブ済み';
	@override String sendTo({required Object count}) => '${count} 件に送信';
	@override String get deleteSessionNotice => 'セッションとそのトランスクリプトを削除します。元に戻せません。';
	@override String accountWithLabel({required Object label}) => 'デフォルト · ${label}';
	@override String get finishRunBeforeChangingWorkspace => 'ワークスペースを変更する前に実行を終了してください';
	@override String get restored => 'ワークスペースを復元しました';
	@override String get maximizePane => 'ペインを最大化';
	@override String get restorePanes => 'ペインを復元';
	@override String get reviewChangedFiles => '変更されたファイルを確認';
	@override late final Translations$workspace$paneTitle$ja paneTitle = Translations$workspace$paneTitle$ja._(_root);
	@override String get addEditorPane => 'エディターペインを追加';
	@override String get addGitPane => 'Git ペインを追加';
	@override String get unknownProjectPath => 'プロジェクトのパスが不明です';
	@override String get autoMini => '自動 (mini)';
	@override String get exportAs => 'エクスポート形式:';
	@override String get exportMarkdown => 'Markdown (.md)';
	@override String get exportHtml => 'Web ページ (.html)';
	@override String get exportPdf => 'PDF (ファイルに印刷)';
	@override String matchPosition({required Object current, required Object total}) => '${current} / ${total}';
	@override String get launcherDescription => 'このペインのワークスペースを選択するか、新しく作成してください。';
	@override String get createWorkspace => 'ワークスペースを作成';
}

// Path: worktrees
class Translations$worktrees$ja extends Translations$worktrees$en {
	Translations$worktrees$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get scripts => 'スクリプト';
	@override String get emptyTitle => 'worktree が見つかりません';
	@override String get emptyDescription => 'worktree を作成して、機能開発やエージェントの実行を分離します。';
	@override String opened({required Object branch}) => 'worktree を開きました: ${branch}';
	@override String get created => 'worktree を作成しました';
	@override String get removed => 'worktree を削除しました';
	@override String merged({required Object branch}) => 'worktree を ${branch} にマージしました';
	@override String get scriptsSaved => 'スクリプト設定を保存しました';
	@override String get setupLabel => 'セットアップ: ';
	@override String get serverLabel => 'サーバー: ';
	@override String get runRunning => '実行中';
	@override String runRunningWithPort({required Object port}) => '実行中 :${port}';
	@override String get runButton => '実行';
	@override String get stopButton => '停止';
	@override String get mainBadge => 'main';
	@override String headDetachedAt({required Object sha}) => 'HEAD が ${sha} で分離';
	@override String get branchHint => '新しいブランチ名（例: feature/login）';
	@override String branchingOff({required Object branch}) => '${branch} から分岐';
	@override String mergeTitle({required Object branch}) => '${branch} をマージ';
	@override String mergeDescription({required Object branch}) => '変更を ${branch} にマージします。';
	@override String get squashDescription => 'すべてのコミットを1つのコミットにまとめる';
	@override String get cleanupDescription => 'マージ後に worktree を削除してブランチも削除';
	@override String removeTitle({required Object branch}) => 'worktree ${branch} を削除しますか？';
	@override String get removeDescription => 'worktree フォルダを削除します。リンクされたプロジェクトはアーカイブされます。';
	@override String dirtyWarning({required Object count}) => '警告: この worktree には失われる未コミットの変更が ${count} 件あります。';
	@override String get forceRemoveLabel => '強制削除（変更を破棄）';
	@override String get deleteBranchLabel => 'ブランチも削除';
	@override String get setupHint => 'セットアップコマンド（例: npm install）';
	@override String get runHint => '実行コマンド（例: npm run dev）';
	@override String get portHint => '実行ポート（任意、例: 3000）';
	@override String get unknownSha => '不明';
	@override String get baseBranchFallback => 'ベースブランチ';
	@override late final Translations$worktrees$runtimeStatus$ja runtimeStatus = Translations$worktrees$runtimeStatus$ja._(_root);
}

// Path: browserUse
class Translations$browserUse$ja extends Translations$browserUse$en {
	Translations$browserUse$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$browserUse$sessionStatus$ja sessionStatus = Translations$browserUse$sessionStatus$ja._(_root);
}

// Path: orchestrator
class Translations$orchestrator$ja extends Translations$orchestrator$en {
	Translations$orchestrator$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String stepFallback({required Object n}) => 'ステップ ${n}';
}

// Path: miniOrchestrator
class Translations$miniOrchestrator$ja extends Translations$miniOrchestrator$en {
	Translations$miniOrchestrator$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$miniOrchestrator$taskTypes$ja taskTypes = Translations$miniOrchestrator$taskTypes$ja._(_root);
	@override late final Translations$miniOrchestrator$roles$ja roles = Translations$miniOrchestrator$roles$ja._(_root);
}

// Path: auth.login
class Translations$auth$login$ja extends Translations$auth$login$en {
	Translations$auth$login$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'おかえりなさい';
	@override String get description => 'DDAgentアカウントにサインイン';
	@override String get username => 'ユーザー名';
	@override String get password => 'パスワード';
	@override String get submit => 'サインイン';
	@override String get loading => 'サインイン中...';
	@override late final Translations$auth$login$errors$ja errors = Translations$auth$login$errors$ja._(_root);
	@override late final Translations$auth$login$placeholders$ja placeholders = Translations$auth$login$placeholders$ja._(_root);
}

// Path: auth.register
class Translations$auth$register$ja extends Translations$auth$register$en {
	Translations$auth$register$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アカウント作成';
	@override String get username => 'ユーザー名';
	@override String get password => 'パスワード';
	@override String get confirmPassword => 'パスワードの確認';
	@override String get submit => 'アカウントを作成';
	@override String get loading => 'アカウントを作成中...';
	@override late final Translations$auth$register$errors$ja errors = Translations$auth$register$errors$ja._(_root);
}

// Path: auth.logout
class Translations$auth$logout$ja extends Translations$auth$logout$en {
	Translations$auth$logout$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'サインアウト';
	@override String get confirm => 'サインアウトしてもよろしいですか？';
	@override String get button => 'サインアウト';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$ja extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get copy => 'コピー';
	@override String get copied => 'コピーしました';
	@override String get copyCode => 'コードをコピー';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$ja extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get copy => 'メッセージをコピー';
	@override String get copied => 'メッセージをコピーしました';
	@override String get failed => 'コピーに失敗しました';
	@override String get selectFormat => 'コピー形式を選択';
	@override String get copyAsMarkdown => 'Markdownとしてコピー';
	@override String get copyAsText => 'テキストとしてコピー';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$ja extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => 'エラー';
	@override String get tool => 'ツール';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
	@override String get orchestrator => 'Auto';
}

// Path: chat.orchestrator
class Translations$chat$orchestrator$ja extends Translations$chat$orchestrator$en {
	Translations$chat$orchestrator$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$orchestrator$routing$ja routing = Translations$chat$orchestrator$routing$ja._(_root);
	@override late final Translations$chat$orchestrator$plan$ja plan = Translations$chat$orchestrator$plan$ja._(_root);
	@override late final Translations$chat$orchestrator$decision$ja decision = Translations$chat$orchestrator$decision$ja._(_root);
	@override late final Translations$chat$orchestrator$delegation$ja delegation = Translations$chat$orchestrator$delegation$ja._(_root);
	@override late final Translations$chat$orchestrator$summary$ja summary = Translations$chat$orchestrator$summary$ja._(_root);
	@override String get backToParent => 'オーケストレーションに戻る';
	@override late final Translations$chat$orchestrator$taskmaster$ja taskmaster = Translations$chat$orchestrator$taskmaster$ja._(_root);
	@override late final Translations$chat$orchestrator$gate$ja gate = Translations$chat$orchestrator$gate$ja._(_root);
}

// Path: chat.tools
class Translations$chat$tools$ja extends Translations$chat$tools$en {
	Translations$chat$tools$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get settings => 'ツール設定';
	@override String get error => 'ツールエラー';
	@override String get result => 'ツール結果';
	@override String get viewParams => '入力パラメータを表示';
	@override String get viewRawParams => '生パラメータを表示';
	@override String get viewDiff => '編集差分を表示:';
	@override String get creatingFile => '新規ファイルを作成:';
	@override String get updatingTodo => 'Todoリストを更新中';
	@override String get read => '読み取り';
	@override String get readFile => 'ファイルを読み取り';
	@override String get updateTodo => 'Todoリストを更新';
	@override String get readTodo => 'Todoリストを読み取り';
	@override String get searchResults => '件の結果';
	@override String get todoReadLabel => 'TodoRead 読み取りリスト';
}

// Path: chat.search
class Translations$chat$search$ja extends Translations$chat$search$en {
	Translations$chat$search$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '${count}件の${type}が見つかりました';
	@override String get file => 'ファイル';
	@override String get files => 'ファイル';
	@override String get pattern => 'パターン:';
	@override String get kIn => '場所:';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$ja extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get updated => 'ファイルを更新しました';
	@override String get created => 'ファイルを作成しました';
	@override String get written => 'ファイルを書き込みました';
	@override String get diff => '差分';
	@override String get newFile => '新規ファイル';
	@override String get viewContent => 'ファイルの内容を表示';
	@override String viewFullOutput({required Object count}) => '全出力を表示（${count}文字）';
	@override String get contentDisplayed => 'ファイルの内容は上の差分ビューに表示されています';
}

// Path: chat.interactive
class Translations$chat$interactive$ja extends Translations$chat$interactive$en {
	Translations$chat$interactive$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'インタラクティブプロンプト';
	@override String get waiting => 'CLIでの応答を待っています';
	@override String get instruction => 'Claudeが実行されているターミナルでオプションを選択してください。';
	@override String selectedOption({required Object number}) => '✓ Claudeがオプション${number}を選択しました';
	@override String get instructionDetail => 'CLIでは、矢印キーまたは番号を入力してオプションを選択します。';
}

// Path: chat.thinking
class Translations$chat$thinking$ja extends Translations$chat$thinking$en {
	Translations$chat$thinking$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '思考中...';
	@override String get emoji => '💭 思考中...';
	@override String get thoughtFewSeconds => '数秒間思考しました';
}

// Path: chat.json
class Translations$chat$json$ja extends Translations$chat$json$en {
	Translations$chat$json$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSONレスポンス';
}

// Path: chat.permissions
class Translations$chat$permissions$ja extends Translations$chat$permissions$en {
	Translations$chat$permissions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => '${tool}に権限を付与';
	@override String get added => '権限を追加しました';
	@override String addTo({required Object entry}) => '${entry}を許可されたツールに追加します。';
	@override String get retry => '権限を保存しました。ツールを使用するにはリクエストを再試行してください。';
	@override String get error => '権限を更新できませんでした。もう一度お試しください。';
	@override String get openSettings => '設定を開く';
	@override String get allow => '許可';
	@override String get always => '常に';
	@override String get editAndAllow => '編集して許可';
	@override String get deny => '拒否';
	@override String get reject => '却下';
	@override String allowAll({required Object count}) => 'すべて許可 (${count})';
	@override String get editInput => '入力を編集';
	@override String get invalidJson => '無効なJSON';
	@override String get allowWithChanges => '変更を加えて許可';
	@override String get alwaysDeny => '常に拒否';
	@override String get denyFeedbackTitle => 'プランを却下';
	@override String get denyFeedbackHint => 'エージェントに何を変更してほしいですか？（任意）';
	@override String get denyReasonTitle => 'この操作を拒否';
	@override String get denyReasonHint => '理由や代わりにしてほしいことをエージェントに伝えてください（任意）';
	@override String get modeAppliesNextMessage => '新しい権限モードは次のメッセージから適用されます。';
}

// Path: chat.todo
class Translations$chat$todo$ja extends Translations$chat$todo$en {
	Translations$chat$todo$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get updated => 'Todoリストを更新しました';
	@override String get current => '現在のTodoリスト';
}

// Path: chat.plan
class Translations$chat$plan$ja extends Translations$chat$plan$en {
	Translations$chat$plan$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 実装プランを表示';
	@override String get title => '実装プラン';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$ja extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Claudeの使用制限に達しました。制限は**${time} ${timezone}** - ${date}にリセットされます';
}

// Path: chat.codex
class Translations$chat$codex$ja extends Translations$chat$codex$en {
	Translations$chat$codex$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => '権限モード';
	@override late final Translations$chat$codex$modes$ja modes = Translations$chat$codex$modes$ja._(_root);
	@override late final Translations$chat$codex$descriptions$ja descriptions = Translations$chat$codex$descriptions$ja._(_root);
	@override String get technicalDetails => '技術的な詳細';
}

// Path: chat.voice
class Translations$chat$voice$ja extends Translations$chat$voice$en {
	Translations$chat$voice$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get autoRead => '返信を読み上げる';
	@override String get autoReadOn => '返信の読み上げ: オン';
	@override String get autoReadOff => '返信の読み上げ: オフ';
	@override String get autoReadVoice => '読み上げ音声';
	@override String get autoReadVoiceAuto => '自動音声';
	@override String get autoReadPreview => '返信はこのように読み上げられます。';
	@override String get speakMessage => '読み上げ';
	@override String get stopSpeaking => '読み上げを停止';
}

// Path: chat.input
class Translations$chat$input$ja extends Translations$chat$input$en {
	Translations$chat$input$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => '/ でコマンド、@ でファイル指定、または ${provider} に何でも聞いてください...';
	@override String get placeholderDefault => 'メッセージを入力...';
	@override String get disabled => '入力無効';
	@override String get attachFiles => 'ファイルを添付';
	@override String get attachFilesDesc => '写真、ファイル、ドキュメントをアップロード';
	@override String get takePhoto => '写真を撮る';
	@override String get takePhotoDesc => 'カメラで写真を撮影';
	@override String get moreTools => 'その他のツール';
	@override String get commandsDesc => 'ショートカットとコマンドを探す';
	@override String get clearInputDesc => '現在のテキストを破棄';
	@override String get attachImages => '画像を添付';
	@override String get send => '送信';
	@override String get stop => '停止';
	@override late final Translations$chat$input$hintText$ja hintText = Translations$chat$input$hintText$ja._(_root);
	@override String get clickToChangeMode => 'クリックで権限モードを変更';
	@override String get showAllCommands => 'すべてのコマンドを表示';
	@override String get clearInput => '入力をクリア';
	@override String get scrollToBottom => '一番下へスクロール';
	@override String get newMessage => '新しいメッセージ';
	@override String get newMessages => '新着メッセージ';
	@override late final Translations$chat$input$queue$ja queue = Translations$chat$input$queue$ja._(_root);
	@override String get autoContinueTasks => '自動続行';
	@override String get autoContinueTasksTooltip => '有効にすると Devin が次の Task Master タスクへ自動的に進みます';
	@override late final Translations$chat$input$offlineQueue$ja offlineQueue = Translations$chat$input$offlineQueue$ja._(_root);
	@override String get voice => '音声入力';
	@override String get voiceStart => 'メッセージを音声入力';
	@override String get voiceStop => '音声入力を停止';
	@override String get pinFile => 'ファイルをコンテキストに固定';
	@override String get voiceSettings => '音声設定 (STT)';
	@override String cameraUnavailable({required Object error}) => 'カメラを利用できません: ${error}';
}

// Path: chat.composer
class Translations$chat$composer$ja extends Translations$chat$composer$en {
	Translations$chat$composer$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => 'ツールとアクション';
	@override String get toolsAndActionsDesc => 'チャット入力欄のツールとコントロール';
	@override String get reasoning => '推論';
	@override String get model => 'モデル';
	@override String get effortDefault => 'デフォルト';
	@override String get loadingModels => 'モデルを読み込み中…';
	@override String get modelMenu => 'モデルと推論レベルを選択';
	@override String permissionHeading({required Object provider}) => '${provider} のアクションをどのように承認しますか？';
	@override String get favorites => 'お気に入り';
	@override String get account => 'アカウント';
	@override String get accountMenu => 'アカウントを選択';
	@override String get accountDefault => 'デフォルトアカウント';
	@override String get accountAuto => '自動 (デフォルト)';
	@override String get accountIsDefault => 'デフォルト';
	@override late final Translations$chat$composer$effortLevels$ja effortLevels = Translations$chat$composer$effortLevels$ja._(_root);
	@override String contextWindow({required Object size}) => 'コンテキスト ${size}';
	@override String get accountAutoShort => '自動';
	@override String get uploadNoRecords => 'アップロード結果にファイルが含まれていません';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$ja extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'AIアシスタントを選択';
	@override String get description => '新しい会話を始めるプロバイダーを選択してください';
	@override String get selectModel => 'モデルを選択';
	@override String get workspace => 'ワークスペース';
	@override String get noWorkspace => 'なし';
	@override String get clickToChangeWorkspace => 'クリックしてワークスペースを変更';
	@override String get chooseWorkspace => 'ワークスペースを選択';
	@override String get searchWorkspaces => 'ワークスペースを検索...';
	@override String get noWorkspacesFound => 'ワークスペースが見つかりません。';
	@override late final Translations$chat$providerSelection$providerInfo$ja providerInfo = Translations$chat$providerSelection$providerInfo$ja._(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$ja readyPrompt = Translations$chat$providerSelection$readyPrompt$ja._(_root);
	@override String get autoGroup => 'Auto';
	@override String get autoLabel => 'Auto (オーケストレーション)';
	@override String get autoDescription => '各ステップを利用可能な最適なプロバイダーとモデルにルーティングします';
	@override String get orchestrated => 'オーケストレーション';
	@override String pressToSearch({required Object shortcut}) => '<kbd>${shortcut}</kbd> を押してセッション、ファイル、コミットを検索';
	@override String get all => 'すべて';
	@override String get free => '無料';
	@override String get noModelsFound => 'モデルが見つかりません。';
	@override String get paid => '有料';
	@override String get searchModels => 'モデルを検索...';
	@override String get addModel => 'モデルを追加';
	@override String get chooseModel => 'モデルを選択';
	@override String get chooseModelDescription => '組み込みとカスタムモデルを一つのリストに';
	@override String get clickToChange => 'クリックしてモデルを変更';
	@override String get favorites => 'お気に入り';
	@override String get loadingModels => 'モデルを読み込み中…';
	@override String get manageModels => 'モデルを管理';
	@override String get refresh => 'モデルを更新';
}

// Path: chat.session
class Translations$chat$session$ja extends Translations$chat$session$en {
	Translations$chat$session$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$ja kContinue = Translations$chat$session$kContinue$ja._(_root);
	@override late final Translations$chat$session$loading$ja loading = Translations$chat$session$loading$ja._(_root);
	@override late final Translations$chat$session$messages$ja messages = Translations$chat$session$messages$ja._(_root);
	@override String get deleteConfirm => 'セッションとそのトランスクリプトを削除します。元に戻せません。';
	@override String get finishRunBeforeWorkspaceChange => 'ワークスペースを変更する前に実行を終了してください';
	@override String get fallbackTitle => 'セッション';
	@override late final Translations$chat$session$missing$ja missing = Translations$chat$session$missing$ja._(_root);
}

// Path: chat.shell
class Translations$chat$shell$ja extends Translations$chat$shell$en {
	Translations$chat$shell$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$ja selectProject = Translations$chat$shell$selectProject$ja._(_root);
	@override late final Translations$chat$shell$status$ja status = Translations$chat$shell$status$ja._(_root);
	@override late final Translations$chat$shell$actions$ja actions = Translations$chat$shell$actions$ja._(_root);
	@override String get loading => 'ターミナルを読み込んでいます...';
	@override String get connecting => 'シェルに接続しています...';
	@override String get startSession => '新しいClaudeセッションを開始';
	@override String resumeSession({required Object displayName}) => 'セッションを再開: ${displayName}...';
	@override String runCommand({required Object projectName, required Object command}) => '${projectName}で${command}を実行';
	@override String startCli({required Object projectName}) => '${projectName}でClaude CLIを起動しています';
	@override String get defaultCommand => 'コマンド';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$ja extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$ja actions = Translations$chat$claudeStatus$actions$ja._(_root);
	@override late final Translations$chat$claudeStatus$state$ja state = Translations$chat$claudeStatus$state$ja._(_root);
	@override late final Translations$chat$claudeStatus$elapsed$ja elapsed = Translations$chat$claudeStatus$elapsed$ja._(_root);
	@override String get stop => '停止';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: 'バックグラウンドタスク ${count} 件を実行中',
		other: 'バックグラウンドタスク ${count} 件を実行中',
	);
	@override late final Translations$chat$claudeStatus$controls$ja controls = Translations$chat$claudeStatus$controls$ja._(_root);
	@override late final Translations$chat$claudeStatus$providers$ja providers = Translations$chat$claudeStatus$providers$ja._(_root);
	@override String get backgroundTasksTitle => 'バックグラウンドで実行中';
	@override String get backgroundTaskUnnamed => '名前のないタスク';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$ja extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => 'プロジェクトを選択して${provider}とのチャットを開始';
}

// Path: chat.tasks
class Translations$chat$tasks$ja extends Translations$chat$tasks$en {
	Translations$chat$tasks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => '次のタスクを開始';
}

// Path: chat.splitSession
class Translations$chat$splitSession$ja extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get toggle => 'セッションを分割';
	@override String get close => '分割セッションを閉じる';
	@override String get selectSession => '比較するセッションを選択';
	@override String get noOtherSessions => '利用できる他のセッションがありません';
	@override String get newSessionOption => '+ 分割ビューで新しいセッション';
	@override String currentProjectGroup({required Object name}) => '現在のプロジェクト (${name})';
	@override String get otherProjectsGroup => 'その他のプロジェクト';
	@override String get recentSessionsGroup => '最近のセッション';
	@override String get startNewSession => '分割ビューで新しいセッションを開始';
	@override String get selectFromList => '既存セッションの一覧から選択';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$ja extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'セッションを選択';
	@override String get searchPlaceholder => 'セッションを検索...';
	@override String get clearSearch => '検索をクリア';
	@override String get newChat => '+ 新しいチャット';
	@override String get archivedToggle => 'アーカイブ済み';
	@override String get changeSession => 'セッションを変更';
	@override String get archivedLoading => 'アーカイブ済みセッションを読み込み中...';
	@override String get archivedError => 'アーカイブ済みセッションを読み込めませんでした';
	@override String get archivedEmpty => 'アーカイブ済みセッションはありません';
	@override String get archivedProjectOnly => 'ワークスペースはアーカイブされています — セッションを見るには復元してください。';
	@override String get emptySearch => '検索に一致するセッションがありません';
	@override String get restore => '復元';
	@override String get restoreSession => 'セッションを復元';
	@override String get restoreProject => 'ワークスペースを復元';
	@override String get restoreSessionFailed => 'セッションの復元に失敗しました。もう一度お試しください。';
	@override String get restoreProjectFailed => 'ワークスペースの復元に失敗しました。もう一度お試しください。';
	@override String get archiveFailed => 'セッションのアーカイブに失敗しました。もう一度お試しください。';
	@override String get deleteFailed => 'セッションの削除に失敗しました。もう一度お試しください。';
	@override String get running => 'セッション実行中';
	@override String get unread => '未読 — 新しい出力ありで終了';
	@override String get account => 'アカウント';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$ja extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get addChat => 'チャットペインを追加';
	@override String get addBrowser => 'ブラウザペインを追加';
	@override String get addTerminal => 'ターミナルペインを追加';
	@override String get addPreview => 'プレビューペインを追加';
	@override String get overview => 'すべてのペインを表示';
	@override String get exitFocusMode => 'フォーカスモードを終了 (Ctrl+Shift+F)';
	@override String get focusMode => 'フォーカスモード (Ctrl+Shift+F)';
	@override String get broadcast => 'セッションに一斉送信';
	@override String get addNotes => '共有メモペインを追加';
	@override String get browseSessions => 'セッション一覧を開く';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$ja extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '分割ペインの概要';
	@override String count({required Object count}) => '${count} ペイン';
	@override String get close => '概要を閉じる';
	@override String get question => '質問 — 入力が必要です';
	@override String get processing => '処理中';
	@override String get idle => 'アイドル';
	@override String get active => 'アクティブ';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$ja extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} があなたの入力を求めています';
	@override String get skip => 'スキップ';
	@override String get other => 'その他…';
	@override String get answerHint => '回答を入力…';
}

// Path: chat.attachments
class Translations$chat$attachments$ja extends Translations$chat$attachments$en {
	Translations$chat$attachments$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => 'ダウンロード失敗 — クリックで再試行';
	@override String get fileAttachment => 'ファイル添付';
	@override String download({required Object name}) => '${name} をダウンロード';
	@override String get attachedFile => '添付ファイル';
	@override String downloaded({required Object name}) => '${name} をダウンロードしました';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$ja extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get creating => 'スナップショットを作成中…';
	@override String get revertChanges => 'ファイルを最後のチェックポイントに戻す';
	@override String get undo => 'チェックポイントを元に戻す';
	@override String get undoAiRun => 'AI の実行を元に戻す';
	@override String get undoing => '元に戻しています…';
	@override String get undone => '元に戻しました';
	@override String get beforeAiTurn => 'AIターン前';
}

// Path: chat.common
class Translations$chat$common$ja extends Translations$chat$common$en {
	Translations$chat$common$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get close => '閉じる';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$ja extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => 'タスク';
	@override String get saved => '保存済み';
	@override String get saving => '保存中...';
	@override String get taskShort => 'タスク';
	@override String get addToTask => 'TaskMasterに追加';
	@override String get added => 'TaskMasterに追加しました';
	@override String get defaultTaskTitle => 'チャットからのタスク';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$ja extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get desc => 'セッションのトークン消費を表示';
	@override String get title => 'トークン使用量';
	@override String get notAvailable => 'なし';
	@override String tokensBadge({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '${count} トークン',
	);
}

// Path: chat.tool
class Translations$chat$tool$ja extends Translations$chat$tool$en {
	Translations$chat$tool$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '(まだ出力なし — ツールは空の結果を返しました)';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$ja extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => 'サブスクリプションの上限';
	@override String get noData => 'このモデルのサブスクリプションデータがありません';
	@override String get noSubscription => 'サブスクリプションなし';
	@override String windowLineReset({required Object label, required Object percent, required Object time}) => '${label}: ${percent}% · リセット ${time}';
	@override String windowRemaining({required Object percent}) => 'リセットまでウィンドウの残り ${percent}%';
}

// Path: chat.broadcast
class Translations$chat$broadcast$ja extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'セッションに一斉送信';
	@override String get noSessions => '利用できるセッションがありません';
	@override String get placeholder => '選択したすべてのセッションに送るメッセージ…';
	@override String partial({required Object count}) => '${count} 件のセッションがメッセージを拒否しました';
	@override String sent({required Object count}) => '${count} 件のセッションのキューに追加しました';
	@override String get selectAll => 'すべて選択';
	@override String get selectOrchestrators => 'オーケストレーターを選択';
	@override String get orchestratorsOnly => 'オーケストレーターのみ';
	@override String get noOrchestrators => '利用可能なオーケストレーターセッションがありません';
	@override String get sending => '送信中…';
	@override String send({required Object count}) => '${count} 件に送信';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$ja extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get processing => '処理中…';
	@override String get switchSession => 'セッションを切り替え';
}

// Path: chat.export
class Translations$chat$export$ja extends Translations$chat$export$en {
	Translations$chat$export$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => 'セッション ${id}';
	@override String get pdfFailed => 'PDFのエクスポートに失敗しました';
	@override String get transcriptDownloaded => 'トランスクリプトをダウンロードしました';
	@override String savedTo({required Object path}) => '${path} を保存しました';
}

// Path: chat.commandResult
class Translations$chat$commandResult$ja extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$ja fallback = Translations$chat$commandResult$fallback$ja._(_root);
	@override String get filterCommands => 'コマンドを絞り込む...';
	@override String searchModels({required Object provider}) => '${provider} のモデルを検索...';
}

// Path: chat.commands
class Translations$chat$commands$ja extends Translations$chat$commands$en {
	Translations$chat$commands$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => 'コマンドを実行しますか？';
	@override String get executionCancelled => 'コマンドの実行をキャンセルしました';
	@override String get bashConfirmMessage => 'このコマンドには実行される bash コマンドが含まれています。続行しますか？';
	@override String get proceed => '続行';
}

// Path: chat.pinFile
class Translations$chat$pinFile$ja extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ファイルをピン留め';
	@override String get pathHint => 'path/to/file.ext';
	@override String get action => 'ピン留め';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$ja extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String editTooltip({required Object name}) => '${name} を編集';
	@override String deleteTooltip({required Object name}) => '${name} を削除';
	@override String get enterNameAndId => 'モデル名とモデルIDの両方を入力してください。';
	@override String get idNoSpaces => 'モデルIDにスペースは使用できません。';
	@override String get setAsDefault => 'デフォルトに設定';
	@override String get defaultModel => 'デフォルトモデル';
	@override String get title => 'モデルライブラリ';
	@override String get subtitle => 'プロバイダーがサポートするモデル ID を追加します。組み込みモデルはロックされたままです。丸印はデフォルトモデルを示します。';
	@override String get yourModels => 'あなたのモデル';
	@override String get yourModelsHint => '編集可能、auth.db に保存';
	@override String get emptyTitle => 'カスタムモデルはまだありません';
	@override String get emptyHint => 'フォームから追加すると、すべてのモデル選択に表示されます。';
	@override String get builtInModels => '組み込みモデル';
	@override String get builtInModelsHint => 'DDAgent が管理する読み取り専用モデル';
	@override String get editTitle => 'カスタムモデルを編集';
	@override String get addTitle => 'カスタムモデルを追加';
	@override String idSentAsWritten({required Object provider}) => 'ID は入力どおりに ${provider} へ送信されます。';
	@override String get nameLabel => 'モデル名';
	@override String get nameHint => '例: GPT-5.5 Pro';
	@override String get idLabel => 'モデル ID';
	@override String get idHint => '例: gpt-5.5-pro';
	@override String get idHelp => 'プロバイダー CLI が受け付ける識別子をそのまま使用してください。ID にスペースは使用できません。';
	@override String updatedNotice({required Object name}) => '${name} を更新しました。';
	@override String addedNotice({required Object name}) => '${name} を追加しました。';
	@override String deletedNotice({required Object name}) => '${name} を削除しました。';
	@override String get saving => '保存中…';
	@override String get saveChanges => '変更を保存';
	@override String get deleteConfirm => 'このモデルをすべての選択肢から削除しますか？';
	@override String get customBadge => 'カスタム';
}

// Path: chat.changes
class Translations$chat$changes$ja extends Translations$chat$changes$en {
	Translations$chat$changes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get failedToLoad => '変更の読み込みに失敗しました';
	@override String get empty => 'ファイルの変更はありません';
}

// Path: chat.message
class Translations$chat$message$ja extends Translations$chat$message$en {
	Translations$chat$message$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => '圧縮された要約';
	@override String get resendHint => '入力欄から再送信';
	@override String get rawView => '生の表示';
	@override String get runComplete => '実行完了';
	@override String get runStopped => '停止しました';
	@override String runFailed({required Object code}) => '実行に失敗しました（終了コード ${code}）';
	@override String get taskKilled => '強制終了';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$ja extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => '権限リクエスト · ${tool}';
	@override String get question => '質問';
	@override String get subagent => 'サブエージェント';
	@override String get viewersCannotApprove => '閲覧者は承認できません';
	@override late final Translations$chat$permissionRequest$recap$ja recap = Translations$chat$permissionRequest$recap$ja._(_root);
	@override String needsApproval({required Object tool}) => '${tool} の承認が必要です';
	@override String subagentNeedsApproval({required Object tool}) => 'サブエージェント: ${tool} の承認が必要です';
	@override String moreQuestions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: 'ほかに ${count} 件の質問が待機中',
	);
}

// Path: chat.commandDialog
class Translations$chat$commandDialog$ja extends Translations$chat$commandDialog$en {
	Translations$chat$commandDialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandDialog$help$ja help = Translations$chat$commandDialog$help$ja._(_root);
	@override late final Translations$chat$commandDialog$models$ja models = Translations$chat$commandDialog$models$ja._(_root);
	@override late final Translations$chat$commandDialog$cost$ja cost = Translations$chat$commandDialog$cost$ja._(_root);
	@override late final Translations$chat$commandDialog$status$ja status = Translations$chat$commandDialog$status$ja._(_root);
	@override String get defaultEyebrow => 'コマンド';
	@override String get defaultTitle => 'コマンドの結果';
	@override String get escHint => 'Esc でこのウィンドウを閉じます。';
	@override String get unknown => '不明';
	@override String get noDescription => '説明はありません。';
	@override String get noCommandsMatch => 'このフィルターに一致するコマンドはありません。';
	@override late final Translations$chat$commandDialog$syntax$ja syntax = Translations$chat$commandDialog$syntax$ja._(_root);
	@override String get commandFinished => 'コマンドが完了しました。';
}

// Path: chat.utilities
class Translations$chat$utilities$ja extends Translations$chat$utilities$en {
	Translations$chat$utilities$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get tokenUsageUnavailable => 'トークン使用量は利用できません';
	@override late final Translations$chat$utilities$tooltip$ja tooltip = Translations$chat$utilities$tooltip$ja._(_root);
	@override String get used => '使用済み';
	@override String get cacheWrite => 'キャッシュ書き込み';
	@override String get contextLabel => 'コンテキスト';
	@override String get usageUnsupported => '使用量は非対応';
	@override String get chatTranscript => 'チャットの記録';
	@override String get you => 'あなた:';
	@override String get providerAutoMini => '自動 (mini)';
}

// Path: chat.toolBlocks
class Translations$chat$toolBlocks$ja extends Translations$chat$toolBlocks$en {
	Translations$chat$toolBlocks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String moreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '… 残り ${count} 行',
	);
	@override late final Translations$chat$toolBlocks$status$ja status = Translations$chat$toolBlocks$status$ja._(_root);
	@override String get showLess => '表示を減らす';
	@override String get showMore => 'さらに表示';
	@override String showMoreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: 'さらに ${count} 行を表示',
	);
	@override String get tools => 'ツール';
	@override String get planReview => 'プランのレビュー';
	@override String get planUpdate => 'プランの更新';
	@override String get todoListUpdated => 'ToDo リストを更新しました';
	@override String get creatingTask => 'タスクを作成中';
	@override String get updatingTask => '更新中';
	@override String get fetchingTask => '取得中';
	@override String get listingTasks => 'タスクを一覧表示中';
	@override String get search => '検索';
	@override late final Translations$chat$toolBlocks$verbs$ja verbs = Translations$chat$toolBlocks$verbs$ja._(_root);
	@override String get subagent => 'サブエージェント';
	@override String toolCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '${count} 個のツール',
	);
	@override String get result => '結果';
	@override String plusMore({required Object count}) => '+${count} 件';
	@override String get plan => 'プラン';
	@override String questionProgress({required Object current, required Object total}) => '質問 ${current}/${total}';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '${count} 行',
	);
	@override String todoListItems({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: 'ToDo リスト (${count} 件)',
	);
	@override String tasksCompleted({required Object done, required Object total}) => '${done}/${total} 完了';
}

// Path: chat.commandMenu
class Translations$chat$commandMenu$ja extends Translations$chat$commandMenu$en {
	Translations$chat$commandMenu$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get empty => '利用できるコマンドはありません';
	@override late final Translations$chat$commandMenu$namespaces$ja namespaces = Translations$chat$commandMenu$namespaces$ja._(_root);
}

// Path: chat.mentionMenu
class Translations$chat$mentionMenu$ja extends Translations$chat$mentionMenu$en {
	Translations$chat$mentionMenu$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$mentionMenu$kinds$ja kinds = Translations$chat$mentionMenu$kinds$ja._(_root);
	@override String taskTitle({required Object id}) => 'タスク ${id}';
}

// Path: chat.subheader
class Translations$chat$subheader$ja extends Translations$chat$subheader$en {
	Translations$chat$subheader$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String contextTooltip({required Object used, required Object total, required Object percent}) => 'コンテキスト: ${used} / ${total} トークン · ${percent}% 使用';
}

// Path: chat.transcript
class Translations$chat$transcript$ja extends Translations$chat$transcript$en {
	Translations$chat$transcript$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get requestFailed => 'リクエストに失敗しました';
}

// Path: chat.review
class Translations$chat$review$ja extends Translations$chat$review$en {
	Translations$chat$review$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get changedFiles => '変更されたファイル';
	@override String changedFilesCount({required Object count}) => '変更されたファイル (${count})';
	@override String get subagent => 'サブエージェント';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$ja extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get changes => '件の変更';
	@override String get previousChange => '前の変更';
	@override String get nextChange => '次の変更';
	@override String get hideDiff => '差分ハイライトを非表示';
	@override String get showDiff => '差分ハイライトを表示';
	@override String get settings => 'エディタ設定';
	@override String get collapse => 'エディタを折りたたむ';
	@override String get expand => 'エディタを全幅に展開';
	@override String get toggleDock => 'ファイルドックを切り替え';
	@override String get diffMerge => '差分 / マージ';
	@override String get previewInBrowser => 'ブラウザでプレビュー';
	@override String get reload => 'ディスクから再読み込み';
}

// Path: codeEditor.header
class Translations$codeEditor$header$ja extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => '変更を表示中';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$ja extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get copyPath => 'ファイルパスをコピー';
	@override String get pathCopied => 'ファイルパスをコピーしました';
	@override String get download => 'ファイルをダウンロード';
	@override String get save => '保存';
	@override String get saving => '保存中...';
	@override String get saved => '保存しました！';
	@override String get exitFullscreen => '全画面を終了';
	@override String get fullscreen => '全画面';
	@override String get close => '閉じる';
	@override String get previewMarkdown => 'Markdownをプレビュー';
	@override String get editMarkdown => 'Markdownを編集';
	@override String get pinFile => 'ファイルをコンテキストにピン留め';
	@override String get unpinFile => 'ファイルをコンテキストから外す';
	@override String get previewHtml => 'HTMLプレビューを新しいタブで開く';
	@override String get retry => '再試行';
	@override String get saveAll => 'すべて保存';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$ja extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get lines => '行数:';
	@override String get characters => '文字数:';
	@override String get shortcuts => 'Ctrl+Sで保存 • Escで閉じる';
	@override String get plainText => 'プレーンテキスト';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '${count} 行',
	);
	@override String get modified => '変更あり';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$ja extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'バイナリファイル';
	@override String message({required Object fileName}) => 'ファイル "${fileName}" はバイナリファイルのため、テキストエディタで表示できません。';
	@override String get cannotDisplayAsText => 'テキストとして表示できません';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$ja extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'プレビューを読み込み中...';
	@override String get error => 'このファイルを表示できません。';
	@override String get openInNewTab => '新しいタブで開く';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$ja extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'メディアファイル';
	@override String get subtitle => '音声/動画のプレビューはまだサポートされていません';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$ja extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… 残り ${size}';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$ja extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get minimap => 'ミニマップ';
	@override String tabSize({required Object size}) => 'タブサイズ: ${size}';
	@override String fontSizeDecrease({required Object size}) => 'フォントサイズ −  (現在 ${size})';
	@override String get fontSizeIncrease => 'フォントサイズ +';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$ja extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get noChanges => '変更なし';
	@override String hunk({required Object number}) => 'ハンク ${number}';
	@override String get close => '差分を閉じる';
	@override String get base => 'ベース';
	@override String get current => '現在';
	@override String get applyMerge => 'マージを適用';
	@override String get deletedOnDisk => 'ディスク上で削除済み';
	@override String get untrackedWillBeDeleted => 'この未追跡ファイルは削除されます。';
	@override String restoreConfirm({required Object name}) => '${name} をコミット済みの状態に戻しますか？';
	@override String get headVsWorkingCopy => 'HEAD と作業コピー';
	@override String get savedVsBuffer => '最終保存とバッファ（git なし）';
	@override String unchangedLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '変更のない ${count} 行',
	);
	@override String get revertToSaved => '保存済みの状態に戻す';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$ja extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ファイルが開かれていません';
	@override String get hint => '「ファイル」タブからファイルを開いてください';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$ja extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => '${name} を保存しました';
	@override String get saveFailed => '保存に失敗しました';
	@override String get allSaved => 'すべて保存しました';
	@override String get someSavesFailed => '一部の保存に失敗しました';
	@override String savedTo({required Object path}) => '${path} に保存しました';
	@override String get mergeApplied => 'マージを適用しました — 保存して反映してください';
}

// Path: common.buttons
class Translations$common$buttons$ja extends Translations$common$buttons$en {
	Translations$common$buttons$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get save => '保存';
	@override String get cancel => 'キャンセル';
	@override String get delete => '削除';
	@override String get create => '作成';
	@override String get edit => '編集';
	@override String get close => '閉じる';
	@override String get confirm => '確認';
	@override String get submit => '送信';
	@override String get retry => '再試行';
	@override String get refresh => '更新';
	@override String get search => '検索';
	@override String get clear => 'クリア';
	@override String get copy => 'コピー';
	@override String get download => 'ダウンロード';
	@override String get upload => 'アップロード';
	@override String get browse => '参照';
	@override String get update => '更新';
	@override String get openDiagram => '図を開く';
}

// Path: common.tabs
class Translations$common$tabs$ja extends Translations$common$tabs$en {
	Translations$common$tabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get chat => 'チャット';
	@override String get shell => 'シェル';
	@override String get files => 'ファイル';
	@override String get git => 'ソース管理';
	@override String get tasks => 'タスク';
	@override String get board => 'ボード';
	@override String get browser => 'ブラウザ';
	@override String get computer => 'コンピューター';
	@override String get usage => 'AI コントロール';
}

// Path: common.quota
class Translations$common$quota$ja extends Translations$common$quota$en {
	Translations$common$quota$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI コントロールセンター';
	@override late final Translations$common$quota$section$ja section = Translations$common$quota$section$ja._(_root);
	@override late final Translations$common$quota$filter$ja filter = Translations$common$quota$filter$ja._(_root);
	@override late final Translations$common$quota$period$ja period = Translations$common$quota$period$ja._(_root);
	@override late final Translations$common$quota$group$ja group = Translations$common$quota$group$ja._(_root);
	@override late final Translations$common$quota$metric$ja metric = Translations$common$quota$metric$ja._(_root);
	@override late final Translations$common$quota$cost$ja cost = Translations$common$quota$cost$ja._(_root);
	@override late final Translations$common$quota$cost3$ja cost3 = Translations$common$quota$cost3$ja._(_root);
	@override late final Translations$common$quota$overview$ja overview = Translations$common$quota$overview$ja._(_root);
	@override late final Translations$common$quota$usage$ja usage = Translations$common$quota$usage$ja._(_root);
	@override late final Translations$common$quota$agents$ja agents = Translations$common$quota$agents$ja._(_root);
	@override late final Translations$common$quota$agentStatus$ja agentStatus = Translations$common$quota$agentStatus$ja._(_root);
	@override late final Translations$common$quota$alert$ja alert = Translations$common$quota$alert$ja._(_root);
	@override String get backToChat => 'チャットに戻る';
	@override String get syncNow => '今すぐ同期';
	@override String generatedAt({required Object value}) => '${value} に更新';
	@override String get loading => 'アカウント上限を読み込み中…';
	@override String remaining({required Object value}) => '残り ${value}%';
	@override String resetsIn({required Object value}) => '${value} でリセット';
	@override String projected({required Object value}) => '現在のペースではこの上限は ${value} で尽きます';
	@override String syncedAgo({required Object value}) => '${value} 前に同期';
	@override String get refreshAccount => 'アカウントを更新';
	@override String get syncFailed => '同期に失敗しました';
	@override String get history => '履歴';
	@override String historyPoints({required Object value}) => '${value} 件の読み取りを記録';
	@override String get historyEmpty => 'まだ履歴が記録されていません';
	@override String get noAgents => '割り当てられたエージェントなし';
	@override String get noSubscription => 'サブスクリプションなし';
	@override String get noSubscriptionHint => 'このアカウントのアクティブなプランはプロバイダーから報告されていません。';
	@override String get notInstalled => '未インストール';
	@override String notInstalledHint({required Object place}) => 'このサーバーにはエージェントの CLI がインストールされていません。${place} でインストールしてください。';
	@override String get notLoggedIn => '未ログイン';
	@override String notLoggedInHint({required Object place}) => 'このサーバーでエージェントにログインしていません。${place} でログインしてください。';
	@override late final Translations$common$quota$quality$ja quality = Translations$common$quota$quality$ja._(_root);
	@override late final Translations$common$quota$kpi$ja kpi = Translations$common$quota$kpi$ja._(_root);
	@override late final Translations$common$quota$empty$ja empty = Translations$common$quota$empty$ja._(_root);
	@override late final Translations$common$quota$settings$ja settings = Translations$common$quota$settings$ja._(_root);
	@override late final Translations$common$quota$range$ja range = Translations$common$quota$range$ja._(_root);
}

// Path: common.status
class Translations$common$status$ja extends Translations$common$status$en {
	Translations$common$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => '読み込み中...';
	@override String get success => '成功';
	@override String get error => 'エラー';
	@override String get failed => '失敗';
	@override String get pending => '保留中';
	@override String get completed => '完了';
	@override String get inProgress => '進行中';
}

// Path: common.messages
class Translations$common$messages$ja extends Translations$common$messages$en {
	Translations$common$messages$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => '保存しました';
	@override String get deletedSuccessfully => '削除しました';
	@override String get updatedSuccessfully => '更新しました';
	@override String get operationFailed => '操作に失敗しました';
	@override String get networkError => 'ネットワークエラー。接続を確認してください。';
	@override String get unauthorized => '認証されていません。ログインしてください。';
	@override String get notFound => '見つかりません';
	@override String get invalidInput => '入力が無効です';
	@override String get requiredField => 'この項目は必須です';
	@override String get unknownError => '不明なエラーが発生しました';
	@override String get renameSessionFailed => 'セッション名の変更に失敗しました。もう一度お試しください。';
}

// Path: common.navigation
class Translations$common$navigation$ja extends Translations$common$navigation$en {
	Translations$common$navigation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get settings => '設定';
	@override String get home => 'ホーム';
	@override String get back => '戻る';
	@override String get next => '次へ';
	@override String get previous => '前へ';
	@override String get logout => 'ログアウト';
	@override String get backToChat => 'チャットに戻る';
}

// Path: common.common
class Translations$common$common$ja extends Translations$common$common$en {
	Translations$common$common$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get language => '言語';
	@override String get theme => 'テーマ';
	@override String get darkMode => 'ダークモード';
	@override String get lightMode => 'ライトモード';
	@override String get name => '名前';
	@override String get description => '説明';
	@override String get enabled => '有効';
	@override String get disabled => '無効';
	@override String get optional => '任意';
	@override String get version => 'バージョン';
	@override String get select => '選択';
	@override String get selectAll => 'すべて選択';
	@override String get deselectAll => 'すべて解除';
	@override String get done => '完了';
	@override String get failed => '失敗';
}

// Path: common.time
class Translations$common$time$ja extends Translations$common$time$en {
	Translations$common$time$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'たった今';
	@override String minutesAgo({required Object count}) => '${count}分前';
	@override String hoursAgo({required Object count}) => '${count}時間前';
	@override String daysAgo({required Object count}) => '${count}日前';
	@override String get yesterday => '昨日';
}

// Path: common.fileOperations
class Translations$common$fileOperations$ja extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newFile => '新規ファイル';
	@override String get newFolder => '新規フォルダ';
	@override String get rename => '名前の変更';
	@override String get move => '移動';
	@override String get copyPath => 'パスをコピー';
	@override String get openInEditor => 'エディタで開く';
}

// Path: common.mainContent
class Translations$common$mainContent$ja extends Translations$common$mainContent$en {
	Translations$common$mainContent$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'DDAgent を読み込んでいます';
	@override String get settingUpWorkspace => 'ワークスペースを準備しています...';
	@override String get chooseProject => 'プロジェクトを選択';
	@override String get selectProjectDescription => 'サイドバーからプロジェクトを選択して、Claudeとコーディングを始めましょう。各プロジェクトにはチャットセッションとファイル履歴が含まれています。';
	@override String get tip => 'ヒント';
	@override String get createProjectMobile => '上部のメニューボタンからプロジェクトにアクセスできます';
	@override String get createProjectDesktop => 'サイドバーのフォルダアイコンをクリックして新しいプロジェクトを作成できます';
	@override String get newSession => '新しいセッション';
	@override String get untitledSession => '無題のセッション';
	@override String get projectFiles => 'プロジェクトファイル';
	@override String get focusMode => 'フォーカスモード (Ctrl+Shift+F)';
	@override String get exitFocusMode => 'フォーカスモードを終了 (Ctrl+Shift+F)';
	@override String get splitSession => 'セッションを分割';
	@override String get closeSplitSession => '分割セッションを閉じる';
	@override String get chooseWorkspace => 'ワークスペースを選択';
	@override String get chooseWorkspaceDescription => 'このチャットのワークスペースを選択するか、設定で新しく作成してください。';
	@override String get createWorkspace => '設定でワークスペースを作成';
	@override String get recentProjects => '最近のプロジェクト';
}

// Path: common.fileTree
class Translations$common$fileTree$ja extends Translations$common$fileTree$en {
	Translations$common$fileTree$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'ファイルを読み込んでいます...';
	@override String get files => 'ファイル';
	@override String get simpleView => 'シンプル表示';
	@override String get compactView => 'コンパクト表示';
	@override String get detailedView => '詳細表示';
	@override String get searchPlaceholder => 'ファイルやフォルダを検索...';
	@override String get searchContentPlaceholder => 'ファイル内を検索...';
	@override String get searchInFiles => 'ファイル内を検索';
	@override String get searchByName => '名前で検索';
	@override String get clearSearch => '検索をクリア';
	@override String get name => '名前';
	@override String get size => 'サイズ';
	@override String get modified => '更新日時';
	@override String get permissions => '権限';
	@override String get noFilesFound => 'ファイルが見つかりません';
	@override String get checkProjectPath => 'プロジェクトのパスがアクセス可能か確認してください';
	@override String get loadFailed => 'ファイルを読み込めませんでした';
	@override String get noMatchesFound => '一致するものが見つかりません';
	@override String get noSearchResults => '一致するものが見つかりません';
	@override String get tryDifferentSearch => '別の検索語を試すか、検索をクリアしてください';
	@override String get searchError => '検索に失敗しました';
	@override String get searching => '検索中...';
	@override String resultsTruncated({required Object count}) => '最初の ${count} 件を表示';
	@override String get justNow => 'たった今';
	@override String minAgo({required Object count}) => '${count}分前';
	@override String hoursAgo({required Object count}) => '${count}時間前';
	@override String daysAgo({required Object count}) => '${count}日前';
	@override String get newFile => '新規ファイル (Cmd+N)';
	@override String get newFolder => '新規フォルダ (Cmd+Shift+N)';
	@override String get refresh => '更新';
	@override String get collapseAll => 'すべて折りたたむ';
	@override late final Translations$common$fileTree$context$ja context = Translations$common$fileTree$context$ja._(_root);
	@override String get allWorkspaces => 'すべてのワークスペース';
	@override late final Translations$common$fileTree$delete$ja delete = Translations$common$fileTree$delete$ja._(_root);
	@override String get dropToUpload => 'ファイルをドロップしてアップロード';
	@override String dropToUploadTo({required Object folder}) => '「${folder}」へアップロードするにはファイルをドロップ';
	@override String get noProject => '先にプロジェクトを追加してください';
	@override String get noRecentFiles => '過去7日間に変更されたファイルはありません';
	@override String get showAllFiles => 'すべてのファイルを表示';
	@override String get showAllFilesHint => '最近のフィルターをオフにするとすべて表示されます。';
	@override String get showRecentOnly => '過去7日間に変更されたファイルを表示';
	@override late final Translations$common$fileTree$toast$ja toast = Translations$common$fileTree$toast$ja._(_root);
	@override String get uploadComplete => 'アップロード完了';
	@override String get uploadFailed => 'アップロードに失敗しました';
	@override String uploadFiles({required Object size}) => 'ファイルをアップロード（各最大 ${size}）';
	@override String uploadToFolder({required Object folder}) => '「${folder}」にファイルをアップロード';
	@override String uploadedCount({required Object total, required Object label, required Object uploaded}) => '${total} ${label} 中 ${uploaded} 件をアップロード';
	@override String get uploadingFiles => 'ファイルをアップロード中';
	@override late final Translations$common$fileTree$validation$ja validation = Translations$common$fileTree$validation$ja._(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$ja extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '新規プロジェクトを作成';
	@override late final Translations$common$projectWizard$steps$ja steps = Translations$common$projectWizard$steps$ja._(_root);
	@override late final Translations$common$projectWizard$step1$ja step1 = Translations$common$projectWizard$step1$ja._(_root);
	@override late final Translations$common$projectWizard$step2$ja step2 = Translations$common$projectWizard$step2$ja._(_root);
	@override late final Translations$common$projectWizard$step3$ja step3 = Translations$common$projectWizard$step3$ja._(_root);
	@override late final Translations$common$projectWizard$buttons$ja buttons = Translations$common$projectWizard$buttons$ja._(_root);
	@override late final Translations$common$projectWizard$errors$ja errors = Translations$common$projectWizard$errors$ja._(_root);
}

// Path: common.notifications
class Translations$common$notifications$ja extends Translations$common$notifications$en {
	Translations$common$notifications$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get genericTool => 'ツール';
	@override late final Translations$common$notifications$codes$ja codes = Translations$common$notifications$codes$ja._(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$ja extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アップデートのお知らせ';
	@override String get newVersionReady => '新しいバージョンが利用可能です';
	@override String get currentVersion => '現在のバージョン';
	@override String get latestVersion => '最新バージョン';
	@override String get whatsNew => '変更点:';
	@override String get viewFullRelease => 'リリース全文を見る';
	@override String get updateProgress => 'アップデートの進捗:';
	@override String get manualUpgrade => '手動アップグレード:';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => 'または「今すぐ更新」をクリックして自動的にアップデートを実行できます。';
	@override String get updateCompleted => 'アップデートが完了しました！';
	@override String get restartServer => '変更を適用するにはサーバーを再起動してください。';
	@override String get updateFailed => 'アップデートに失敗しました';
	@override late final Translations$common$versionUpdate$buttons$ja buttons = Translations$common$versionUpdate$buttons$ja._(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$ja ariaLabels = Translations$common$versionUpdate$ariaLabels$ja._(_root);
}

// Path: common.actions
class Translations$common$actions$ja extends Translations$common$actions$en {
	Translations$common$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get retry => '再試行';
	@override String get save => '保存';
}

// Path: common.browserPane
class Translations$common$browserPane$ja extends Translations$common$browserPane$en {
	Translations$common$browserPane$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get address => 'アドレス';
	@override String get back => '戻る';
	@override String get connecting => 'ブラウザに接続中…';
	@override String get connectionFailed => 'ブラウザ接続に失敗しました。';
	@override String couldNotLoad({required Object url}) => '${url} を読み込めませんでした';
	@override String get disconnected => 'ブラウザビューが切断されました';
	@override String get enterUrl => 'URLを入力';
	@override String get forward => '進む';
	@override String get invalidUrl => '有効な http(s) URLを入力してください';
	@override String get noAuthToken => '認証トークンがありません。';
	@override String get openExternal => 'システムブラウザで開く';
	@override String get reload => '再読み込み';
	@override String get retry => '再試行';
	@override String get stop => '停止';
}

// Path: common.browserUse
class Translations$common$browserUse$ja extends Translations$common$browserUse$en {
	Translations$common$browserUse$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} 件アクティブ';
	@override String get cancel => 'キャンセル';
	@override String get close => '閉じる';
	@override String get delete => '削除';
	@override String deleteDesc({required Object name}) => '${name} は完全に削除されます。';
	@override String get deleteSession => 'セッションを削除';
	@override String get deleteTitle => 'ブラウザセッションを削除しますか？';
	@override late final Translations$common$browserUse$empty$ja empty = Translations$common$browserUse$empty$ja._(_root);
	@override String get emptyStatus => '空';
	@override late final Translations$common$browserUse$errors$ja errors = Translations$common$browserUse$errors$ja._(_root);
	@override String get fullscreen => '全画面';
	@override String get installRuntime => 'ランタイムをインストール';
	@override String get installing => 'インストール中...';
	@override String get lastAction => '最後の操作';
	@override String get nextSnapshot => 'エージェントブラウザの次のスナップショットがここに表示されます。';
	@override String get noPageLoaded => 'ページが読み込まれていません';
	@override String get noSessions => 'エージェントのブラウザセッションがありません。';
	@override String get none => 'なし';
	@override String get openSettings => 'Browser 設定を開く';
	@override String get profile => 'プロファイル';
	@override String get promptLabel => 'プロンプト';
	@override late final Translations$common$browserUse$prompts$ja prompts = Translations$common$browserUse$prompts$ja._(_root);
	@override String get refresh => 'ブラウザセッションを更新';
	@override late final Translations$common$browserUse$relative$ja relative = Translations$common$browserUse$relative$ja._(_root);
	@override late final Translations$common$browserUse$runtime$ja runtime = Translations$common$browserUse$runtime$ja._(_root);
	@override String get runtimeSetup => 'ランタイムのセットアップが必要です';
	@override String get selected => '選択中';
	@override String get sessionFallback => 'ブラウザセッション';
	@override String get sessionScreenshot => 'ブラウザセッションのスクリーンショット';
	@override String get sessions => 'セッション';
	@override String get status => 'ステータス';
	@override String get stop => '停止';
	@override String get stopSession => 'セッションを停止';
	@override String get subtitle => 'AIエージェントが開いたブラウザセッションを監視します。';
	@override String get temporary => '一時的';
	@override String get thisSession => 'このセッション';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '合計 ${count} 件';
	@override String updated({required Object time}) => '更新: ${time}';
	@override String get waiting => '待機中';
	@override String get waitingForScreenshot => 'スクリーンショットを待機中';
}

// Path: common.commandPalette
class Translations$common$commandPalette$ja extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get backToAll => 'すべてに戻る';
	@override String get backspaceHint => 'Backspace で戻る';
	@override late final Translations$common$commandPalette$browseAll$ja browseAll = Translations$common$commandPalette$browseAll$ja._(_root);
	@override late final Translations$common$commandPalette$compare$ja compare = Translations$common$commandPalette$compare$ja._(_root);
	@override late final Translations$common$commandPalette$groups$ja groups = Translations$common$commandPalette$groups$ja._(_root);
	@override late final Translations$common$commandPalette$hints$ja hints = Translations$common$commandPalette$hints$ja._(_root);
	@override late final Translations$common$commandPalette$items$ja items = Translations$common$commandPalette$items$ja._(_root);
	@override late final Translations$common$commandPalette$nav$ja nav = Translations$common$commandPalette$nav$ja._(_root);
	@override String get noResults => '結果がありません。';
	@override late final Translations$common$commandPalette$pages$ja pages = Translations$common$commandPalette$pages$ja._(_root);
	@override String get placeholder => '入力して検索…';
	@override String searchPagePlaceholder({required Object page}) => '${page} を検索…';
	@override String get title => 'コマンドパレット';
}

// Path: common.gitPanel
class Translations$common$gitPanel$ja extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '${count} 先行';
	@override String get aheadLabel => '先行';
	@override String get aiSuggest => 'AI 提案';
	@override String get aiSuggestTitle => 'AIでコミットメッセージを生成';
	@override String get all => 'すべて';
	@override String get allStaged => 'すべての変更がステージ済み';
	@override String behind({required Object count}) => '${count} 遅れ';
	@override String get behindLabel => '遅れ';
	@override late final Translations$common$gitPanel$branches$ja branches = Translations$common$gitPanel$branches$ja._(_root);
	@override String get cancel => 'キャンセル';
	@override String changesCount({required Object count}) => '変更 (${count})';
	@override String get clearSearch => '検索をクリア';
	@override String get collapseDiff => '差分を折りたたむ';
	@override String get commit => 'コミット';
	@override String get commitChanges => '変更をコミット';
	@override String commitFiles({required Object count}) => '${count} ファイルをコミット';
	@override String get committing => 'コミット中...';
	@override late final Translations$common$gitPanel$confirmActions$ja confirmActions = Translations$common$gitPanel$confirmActions$ja._(_root);
	@override String confirmCommit({required Object count, required Object message}) => '${count} ファイルをメッセージ「${message}」でコミットしますか？';
	@override String confirmDeleteFile({required Object file}) => '未追跡ファイル「${file}」を削除しますか？元に戻せません。';
	@override String confirmDiscardFile({required Object file}) => '「${file}」へのすべての変更を破棄しますか？元に戻せません。';
	@override String confirmPublish({required Object branch, required Object remote}) => 'ブランチ「${branch}」を ${remote} に公開しますか？';
	@override String confirmPull({required Object remote, required Object count}) => '${remote} から ${count} コミットを取得しますか？';
	@override String confirmPush({required Object remote, required Object count}) => '${remote} へ ${count} コミットを送信しますか？';
	@override String get confirmRevert => '最新のローカルコミットを取り消しますか？コミットは削除されますが、変更はステージされたまま残ります。';
	@override late final Translations$common$gitPanel$confirmTitles$ja confirmTitles = Translations$common$gitPanel$confirmTitles$ja._(_root);
	@override String get createBranch => '新しいブランチを作成';
	@override String get creating => '作成中...';
	@override String get delete => '削除';
	@override String get deleteUntracked => '未追跡ファイルを削除';
	@override String get deselectAll => 'すべて解除';
	@override String get discard => '破棄';
	@override String get discardChanges => '変更を破棄';
	@override String get dismiss => '閉じる';
	@override String get dismissError => 'エラーを閉じる';
	@override late final Translations$common$gitPanel$errors$ja errors = Translations$common$gitPanel$errors$ja._(_root);
	@override String get expandDiff => '差分を展開';
	@override String get fetch => 'フェッチ';
	@override String fetchTitle({required Object remote}) => '${remote} から fetch';
	@override String get fetching => 'Fetch 中…';
	@override String filesSelected({required Object count}) => '${count} ファイル選択中';
	@override String get generating => '生成中...';
	@override late final Translations$common$gitPanel$history$ja history = Translations$common$gitPanel$history$ja._(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$ja mergeWorktree = Translations$common$gitPanel$mergeWorktree$ja._(_root);
	@override String get merging => 'マージ中...';
	@override String get messagePlaceholder => 'メッセージ（Ctrl+Enter でコミット）';
	@override late final Translations$common$gitPanel$newBranch$ja newBranch = Translations$common$gitPanel$newBranch$ja._(_root);
	@override late final Translations$common$gitPanel$newWorktree$ja newWorktree = Translations$common$gitPanel$newWorktree$ja._(_root);
	@override String get noChanges => '変更が検出されませんでした';
	@override String get noChangesToCommit => 'コミットする変更がありません';
	@override late final Translations$common$gitPanel$noCommits$ja noCommits = Translations$common$gitPanel$noCommits$ja._(_root);
	@override String get noMatchingBranches => '一致するブランチがありません';
	@override late final Translations$common$gitPanel$noRepo$ja noRepo = Translations$common$gitPanel$noRepo$ja._(_root);
	@override String get noStagedFiles => 'ステージされたファイルがありません';
	@override String get none => 'なし';
	@override String nothingToPush({required Object remote}) => '${remote} へプッシュするものがありません';
	@override String get openFile => 'クリックでファイルを開く';
	@override String get publish => '公開';
	@override String publishTitle({required Object branch, required Object remote}) => '「${branch}」を ${remote} に公開';
	@override String get publishing => '公開中…';
	@override String get pull => 'プル';
	@override String pullCount({required Object count}) => 'プル ${count}';
	@override String pullTitle({required Object remote, required Object count}) => '${remote} から ${count} 件を取得';
	@override String get pulling => 'Pull 中…';
	@override String get push => 'プッシュ';
	@override String pushCount({required Object count}) => 'プッシュ ${count}';
	@override String pushTitle({required Object remote, required Object count}) => '${remote} へ ${count} 件を送信';
	@override String get pushing => 'Push 中…';
	@override String get recentCommits => '最近のコミット';
	@override String get refresh => 'git ステータスを更新';
	@override String get remove => '削除';
	@override late final Translations$common$gitPanel$removeWorktree$ja removeWorktree = Translations$common$gitPanel$removeWorktree$ja._(_root);
	@override String get removing => '削除中...';
	@override String get revertLatest => '最新のローカルコミットを取り消す';
	@override String get scroll => 'スクロール';
	@override String get searchBranches => 'ブランチを検索...';
	@override String get selectAll => 'すべて選択';
	@override String get selectProject => 'プロジェクトを選択してソース管理を表示';
	@override String selectedOf({required Object total, required Object selected}) => '${total} ファイル中 ${selected} 件選択中';
	@override String selectedOfMobile({required Object total, required Object selected}) => '${total} 中 ${selected} 件選択中';
	@override String get sideBySide => '並列';
	@override String get stageAll => 'すべてステージ';
	@override String get stageHunk => 'このハンクをステージ';
	@override String staged({required Object count}) => 'ステージ済み (${count})';
	@override late final Translations$common$gitPanel$status$ja status = Translations$common$gitPanel$status$ja._(_root);
	@override String get statusGuide => 'ファイルステータスガイド';
	@override String get switchScroll => '水平スクロールに切り替え';
	@override String get switchSplit => '並列ビューに切り替え';
	@override String get switchUnified => '統合ビューに切り替え';
	@override String get switchWrap => '折り返しに切り替え';
	@override String get unified => '統合';
	@override String get unstageAll => 'すべてステージ解除';
	@override String get unstageHunk => 'このハンクをステージ解除';
	@override String get upToDate => '最新';
	@override String upToDateWith({required Object remote}) => '${remote} と最新';
	@override String get viewAll => 'すべて表示';
	@override String get viewsAria => 'ソース管理ビュー';
	@override late final Translations$common$gitPanel$worktrees$ja worktrees = Translations$common$gitPanel$worktrees$ja._(_root);
	@override String get wrap => '折り返し';
	@override late final Translations$common$gitPanel$tabs$ja tabs = Translations$common$gitPanel$tabs$ja._(_root);
	@override String get save => '保存';
	@override late final Translations$common$gitPanel$worktreeScripts$ja worktreeScripts = Translations$common$gitPanel$worktreeScripts$ja._(_root);
}

// Path: common.sessions
class Translations$common$sessions$ja extends Translations$common$sessions$en {
	Translations$common$sessions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get renameSession => 'セッション名を変更';
}

// Path: common.projects
class Translations$common$projects$ja extends Translations$common$projects$en {
	Translations$common$projects$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newSession => '新しいセッション';
}

// Path: common.sharedNotes
class Translations$common$sharedNotes$ja extends Translations$common$sharedNotes$en {
	Translations$common$sharedNotes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '共有メモリ — このプロジェクトのすべてのセッションに挿入されます';
	@override String get save => '保存';
	@override String get saving => '保存中…';
	@override String get noProject => '共有コンテキストを編集するワークスペースを選択してください';
	@override String get placeholder => '# 共有コンテキスト\nすべてのエージェントが知っておくべき規約、決定事項、参照先…';
}

// Path: common.codeBlock
class Translations$common$codeBlock$ja extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => '行を折り返す';
	@override String get noWrap => '折り返しなし';
}

// Path: common.update
class Translations$common$update$ja extends Translations$common$update$en {
	Translations$common$update$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => '更新があります · v${version}';
	@override String confirm({required Object version}) => 'v${version} に更新しますか？サーバーは自動で更新して再起動します — アクティブなセッションは中断されます。';
	@override String get downloading => '更新をダウンロードして適用中…';
	@override String get restarting => 'サーバーを再起動中 — しばらくお待ちください…';
	@override String done({required Object version}) => 'v${version} に更新しました。新しいバンドルを反映するにはアプリを再読み込みしてください。';
	@override String get manualRestart => '更新は適用されましたが、サーバーは自動で再起動しませんでした — 手動で再起動して完了してください。';
	@override String get failed => '更新に失敗しました。';
	@override String get failedTitle => '更新に失敗しました';
	@override String appConfirm({required Object version}) => 'この端末に DDAgent v${version} をインストールしますか？ 初回は Android が DDAgent からのインストール許可を求めます。';
	@override String get appPermission => 'DDAgent に「提供元不明のアプリ」のインストールを許可してから、もう一度「更新」をタップしてください。';
	@override String get chooseTitle => 'アップデートがあります';
	@override String get targetApp => 'このアプリ';
	@override String get targetWeb => 'Web インターフェイス';
	@override String get targetServer => 'サーバー';
	@override String get updateApp => 'アプリを更新';
	@override String get updateWeb => 'Web インターフェイスを更新';
	@override String get updateServer => 'サーバーを更新';
	@override String webConfirm({required Object version}) => 'Web インターフェイスを v${version} に更新しますか？更新後にページが再読み込みされます。';
	@override String webDone({required Object version}) => 'Web インターフェイスを v${version} に更新しました — 再読み込みしています…';
	@override String localServerConfirm({required Object version}) => 'このデバイスのローカルサーバーを v${version} に更新しますか？実行中のセッションは中断されます。';
	@override String get localServerUpdating => 'ローカルサーバーをダウンロードして起動しています…';
	@override String serverDone({required Object version}) => 'サーバーは v${version} で動作しています。';
	@override String staged({required Object version}) => 'アップデート v${version} をダウンロードしました — インストールするにはサーバーを再起動してください。';
	@override String get upToDate => 'サーバーはすでに最新のリリースです。';
	@override String webHostFailed({required Object message}) => 'サーバーは更新されましたが、Web インターフェイスは更新されませんでした：${message}';
}

// Path: common.appShell
class Translations$common$appShell$ja extends Translations$common$appShell$en {
	Translations$common$appShell$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String panelActive({required Object count}) => 'パネル · ${count} 件実行中';
}

// Path: common.errors
class Translations$common$errors$ja extends Translations$common$errors$en {
	Translations$common$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get forbidden => 'アクセスが拒否されました';
}

// Path: settings.changelog
class Translations$settings$changelog$ja extends Translations$settings$changelog$en {
	Translations$settings$changelog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '変更履歴';
	@override String get loading => '読み込み中…';
	@override String get empty => '表示するリリースがありません';
	@override String get current => '現在';
	@override String get kNew => '新規';
}

// Path: settings.server
class Translations$settings$server$ja extends Translations$settings$server$en {
	Translations$settings$server$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'サーバー';
	@override String get description => 'DDAgent プロセスを再起動します — 更新後や応答しない状態からの回復に便利です。';
	@override String get restart => '再起動';
	@override String get restartConfirm => 'DDAgent サーバーを再起動しますか?アクティブなセッションは中断されます。';
	@override String get restarting => '再起動中… サーバーが戻り次第、ページを再読み込みします。';
	@override String get restartFailed => '再起動に失敗しました';
	@override String get unsupported => '再起動は、サーバーがサービスマネージャー管理下で動作している場合のみ利用できます。';
	@override String get ok => 'OK';
	@override String get restartTitle => 'サーバーを再起動しています';
	@override String get restartRequesting => 'サーバーに再起動を要求しています…';
	@override String restartWaiting({required Object seconds}) => 'サーバーの復帰を待っています…（${seconds} 秒）';
	@override String restartBack({required Object version}) => 'サーバーが復帰しました — バージョン ${version}。';
	@override String get restartReloading => 'ページを再読み込みしています…';
	@override String restartTimeout({required Object seconds}) => '${seconds} 秒以内にサーバーが復帰しませんでした。サービスのログ（/tmp/ddagent.log）を確認するか、手動で再起動してください。';
}

// Path: settings.updates
class Translations$settings$updates$ja extends Translations$settings$updates$en {
	Translations$settings$updates$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '更新';
	@override String get description => 'GitHub で新しいデスクトップビルドを確認します。新しいバージョンは自動でダウンロードされ、終了時にインストールされます。';
	@override String get descriptionMobile => 'GitHub でこのアプリの新しいビルドを確認します。更新はデバイスのシステムインストーラーでインストールされます。';
	@override String get descriptionServer => 'GitHub で新しい DDAgent リリースを確認します。接続中のサーバーは自身を更新できます — 再起動中はアクティブなセッションが中断されます。';
	@override String get check => '更新を確認';
	@override String get checking => '確認中…';
	@override String upToDate({required Object version}) => '最新バージョンです（v${version}）。';
	@override String available({required Object version}) => '更新 v${version} が見つかりました — バックグラウンドでダウンロード中。DDAgent 終了時にインストールされます。';
	@override String appAvailable({required Object version}) => 'アプリの更新 v${version} があります — 「更新」をタップしてこのデバイスにインストールしてください。';
	@override String downloaded({required Object version}) => '更新 v${version} をダウンロードしました — DDAgent を終了して再起動するとインストールされます。';
	@override String get unavailable => '更新チェックはパッケージ済みデスクトップビルドでのみ利用できます。';
	@override String error({required Object message}) => '更新チェックに失敗しました: ${message}';
	@override String get errorGeneric => '更新チェックに失敗しました。';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · 最新 v${latest}';
	@override String current({required Object version}) => 'v${version} — 最新です';
	@override String webNotHosted({required Object version}) => 'この Web インターフェイスは別にホストされています。リリースの ddagent-flutter-web-v${version}.zip でファイルを置き換えてください。';
	@override String get serverCannotUpdate => 'このサーバーはここから自動更新できません。install.sh またはリリースの tarball で再インストールしてください。';
}

// Path: settings.tabs
class Translations$settings$tabs$ja extends Translations$settings$tabs$en {
	Translations$settings$tabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get account => 'アカウント';
	@override String get permissions => '権限';
	@override String get mcpServers => 'MCPサーバー';
	@override String get skills => 'スキル';
	@override String get appearance => '外観';
}

// Path: settings.account
class Translations$settings$account$ja extends Translations$settings$account$en {
	Translations$settings$account$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アカウント';
	@override String get language => '言語';
	@override String get languageLabel => '表示言語';
	@override String get languageDescription => 'インターフェースの表示言語を選択してください';
	@override String get username => 'ユーザー名';
	@override String get email => 'メールアドレス';
	@override String get profile => 'プロフィール';
	@override String get changePassword => 'パスワードを変更';
}

// Path: settings.mcp
class Translations$settings$mcp$ja extends Translations$settings$mcp$en {
	Translations$settings$mcp$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCPサーバー';
	@override String get addServer => 'サーバーを追加';
	@override String get editServer => 'サーバーを編集';
	@override String get deleteServer => 'サーバーを削除';
	@override String get serverName => 'サーバー名';
	@override String get serverType => 'サーバーの種類';
	@override String get config => '設定';
	@override String get testConnection => '接続テスト';
	@override String get status => '状態';
	@override String get connected => '接続済み';
	@override String get disconnected => '未接続';
	@override late final Translations$settings$mcp$scope$ja scope = Translations$settings$mcp$scope$ja._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$ja extends Translations$settings$appearance$en {
	Translations$settings$appearance$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '外観';
	@override String get theme => 'テーマ';
	@override String get codeEditor => 'コードエディタ';
	@override String get editorTheme => 'エディタのテーマ';
	@override String get wordWrap => '折り返し';
	@override String get showMinimap => 'ミニマップを表示';
	@override String get lineNumbers => '行番号';
	@override String get fontSize => 'フォントサイズ';
	@override late final Translations$settings$appearance$themeModes$ja themeModes = Translations$settings$appearance$themeModes$ja._(_root);
}

// Path: settings.actions
class Translations$settings$actions$ja extends Translations$settings$actions$en {
	Translations$settings$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => '変更を保存';
	@override String get resetToDefaults => 'デフォルトに戻す';
	@override String get cancelChanges => '変更をキャンセル';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$ja extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'クイック設定';
	@override late final Translations$settings$quickSettings$sections$ja sections = Translations$settings$quickSettings$sections$ja._(_root);
	@override String get darkMode => 'ダークモード';
	@override String get showRawParameters => '生パラメータを表示';
	@override String get showThinking => '思考を表示';
	@override String get sendByCtrlEnter => 'Ctrl+Enterで送信';
	@override String get sendByCtrlEnterDescription => '有効にすると、Enterではなく Ctrl+Enter でメッセージを送信します。IMEユーザーの誤送信防止に便利です。';
	@override late final Translations$settings$quickSettings$dragHandle$ja dragHandle = Translations$settings$quickSettings$dragHandle$ja._(_root);
	@override String get sendWithCtrlEnter => 'Ctrl+Enterで送信';
	@override String get enterSendsHint => 'オフの場合、Enter で送信し、Shift+Enter で改行します。';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$ja extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ターミナルショートカット';
	@override String get sectionKeys => 'キー';
	@override String get sectionNavigation => 'ナビゲーション';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => '上矢印';
	@override String get arrowDown => '下矢印';
	@override String get scrollDown => '下にスクロール';
	@override String get killTitle => '実行中のプロセスを終了 (Ctrl+C)';
	@override late final Translations$settings$terminalShortcuts$handle$ja handle = Translations$settings$terminalShortcuts$handle$ja._(_root);
	@override String get paste => '貼り付け';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$ja extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '設定';
	@override String get agents => 'エージェント';
	@override String get orchestration => 'オーケストレーション';
	@override String get miniOrchestration => 'ミニオーケストレーション';
	@override String get appearance => '外観';
	@override String get workspaces => 'ワークスペース';
	@override String get git => 'Git';
	@override String get apiTokens => 'API & トークン';
	@override String get models => 'モデル';
	@override String get tasks => 'タスク';
	@override String get browser => 'Browser';
	@override String get tools => 'ツール';
	@override String get notifications => '通知';
	@override String get about => '概要';
	@override String get quota => 'コントロールセンター';
	@override String get shortcuts => 'キーボードショートカット';
}

// Path: settings.miniOrchestration
class Translations$settings$miniOrchestration$ja extends Translations$settings$miniOrchestration$en {
	Translations$settings$miniOrchestration$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ミニオーケストレーション';
	@override String get description => '2 モデル構成のパイプライン: 非 flash の思考モデルが計画し、flash のワーカーが実行します。';
	@override String get loading => 'ミニオーケストレーション設定を読み込み中…';
	@override String get loadError => 'ミニオーケストレーション設定を読み込めませんでした。';
	@override late final Translations$settings$miniOrchestration$enable$ja enable = Translations$settings$miniOrchestration$enable$ja._(_root);
	@override late final Translations$settings$miniOrchestration$thinker$ja thinker = Translations$settings$miniOrchestration$thinker$ja._(_root);
	@override late final Translations$settings$miniOrchestration$worker$ja worker = Translations$settings$miniOrchestration$worker$ja._(_root);
	@override late final Translations$settings$miniOrchestration$fields$ja fields = Translations$settings$miniOrchestration$fields$ja._(_root);
	@override late final Translations$settings$miniOrchestration$roles$ja roles = Translations$settings$miniOrchestration$roles$ja._(_root);
	@override late final Translations$settings$miniOrchestration$planner$ja planner = Translations$settings$miniOrchestration$planner$ja._(_root);
}

// Path: settings.orchestration
class Translations$settings$orchestration$ja extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'オーケストレーション';
	@override String get description => 'チャットのタスクをプロバイダーとモデルに振り分けます。';
	@override String get loading => 'オーケストレーション設定を読み込み中…';
	@override String get loadError => 'オーケストレーション設定を読み込めませんでした。';
	@override String get retry => '再試行';
	@override late final Translations$settings$orchestration$enable$ja enable = Translations$settings$orchestration$enable$ja._(_root);
	@override late final Translations$settings$orchestration$pool$ja pool = Translations$settings$orchestration$pool$ja._(_root);
	@override late final Translations$settings$orchestration$tiers$ja tiers = Translations$settings$orchestration$tiers$ja._(_root);
	@override late final Translations$settings$orchestration$rules$ja rules = Translations$settings$orchestration$rules$ja._(_root);
	@override late final Translations$settings$orchestration$planner$ja planner = Translations$settings$orchestration$planner$ja._(_root);
	@override late final Translations$settings$orchestration$execution$ja execution = Translations$settings$orchestration$execution$ja._(_root);
	@override late final Translations$settings$orchestration$save$ja save = Translations$settings$orchestration$save$ja._(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$ja extends Translations$settings$notifications$en {
	Translations$settings$notifications$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
	@override String get description => '受信する通知イベントを設定します。';
	@override late final Translations$settings$notifications$webPush$ja webPush = Translations$settings$notifications$webPush$ja._(_root);
	@override late final Translations$settings$notifications$device$ja device = Translations$settings$notifications$device$ja._(_root);
	@override late final Translations$settings$notifications$desktop$ja desktop = Translations$settings$notifications$desktop$ja._(_root);
	@override late final Translations$settings$notifications$sound$ja sound = Translations$settings$notifications$sound$ja._(_root);
	@override late final Translations$settings$notifications$events$ja events = Translations$settings$notifications$events$ja._(_root);
	@override late final Translations$settings$notifications$messaging$ja messaging = Translations$settings$notifications$messaging$ja._(_root);
	@override late final Translations$settings$notifications$channels$ja channels = Translations$settings$notifications$channels$ja._(_root);
	@override String get unpair => 'ペアリングを解除';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$ja extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$ja darkMode = Translations$settings$appearanceSettings$darkMode$ja._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$ja codeEditor = Translations$settings$appearanceSettings$codeEditor$ja._(_root);
	@override late final Translations$settings$appearanceSettings$terminal$ja terminal = Translations$settings$appearanceSettings$terminal$ja._(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$ja extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$ja title = Translations$settings$mcpForm$title$ja._(_root);
	@override late final Translations$settings$mcpForm$importMode$ja importMode = Translations$settings$mcpForm$importMode$ja._(_root);
	@override late final Translations$settings$mcpForm$scope$ja scope = Translations$settings$mcpForm$scope$ja._(_root);
	@override late final Translations$settings$mcpForm$fields$ja fields = Translations$settings$mcpForm$fields$ja._(_root);
	@override late final Translations$settings$mcpForm$placeholders$ja placeholders = Translations$settings$mcpForm$placeholders$ja._(_root);
	@override late final Translations$settings$mcpForm$validation$ja validation = Translations$settings$mcpForm$validation$ja._(_root);
	@override String configDetails({required Object configFile}) => '設定の詳細（${configFile}より）';
	@override String projectPath({required Object path}) => 'パス: ${path}';
	@override late final Translations$settings$mcpForm$actions$ja actions = Translations$settings$mcpForm$actions$ja._(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$ja extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get success => '設定を保存しました！';
	@override String get error => '設定の保存に失敗しました';
	@override String get saving => '保存中...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$ja extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get save => '設定を保存';
	@override String get cancel => 'キャンセル';
}

// Path: settings.git
class Translations$settings$git$ja extends Translations$settings$git$en {
	Translations$settings$git$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Git設定';
	@override String get description => 'コミット用のGit IDを設定します。この設定は git config --global で適用されます';
	@override late final Translations$settings$git$name$ja name = Translations$settings$git$name$ja._(_root);
	@override late final Translations$settings$git$email$ja email = Translations$settings$git$email$ja._(_root);
	@override late final Translations$settings$git$actions$ja actions = Translations$settings$git$actions$ja._(_root);
	@override late final Translations$settings$git$status$ja status = Translations$settings$git$status$ja._(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$ja extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'APIキー';
	@override String get description => '外部APIにアクセスするためのAPIキーを生成します。';
	@override late final Translations$settings$apiKeys$newKey$ja newKey = Translations$settings$apiKeys$newKey$ja._(_root);
	@override late final Translations$settings$apiKeys$form$ja form = Translations$settings$apiKeys$form$ja._(_root);
	@override String get newButton => '新しいAPIキー';
	@override String get empty => 'APIキーはまだ作成されていません。';
	@override late final Translations$settings$apiKeys$list$ja list = Translations$settings$apiKeys$list$ja._(_root);
	@override String get confirmDelete => 'このAPIキーを削除してもよろしいですか？';
	@override late final Translations$settings$apiKeys$status$ja status = Translations$settings$apiKeys$status$ja._(_root);
	@override late final Translations$settings$apiKeys$github$ja github = Translations$settings$apiKeys$github$ja._(_root);
	@override String get apiDocsLink => 'APIドキュメント';
	@override late final Translations$settings$apiKeys$documentation$ja documentation = Translations$settings$apiKeys$documentation$ja._(_root);
	@override String get loading => '読み込み中...';
	@override late final Translations$settings$apiKeys$version$ja version = Translations$settings$apiKeys$version$ja._(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$ja extends Translations$settings$tasks$en {
	Translations$settings$tasks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get checking => 'TaskMasterのインストールを確認しています...';
	@override late final Translations$settings$tasks$notInstalled$ja notInstalled = Translations$settings$tasks$notInstalled$ja._(_root);
	@override late final Translations$settings$tasks$settings$ja settings = Translations$settings$tasks$settings$ja._(_root);
}

// Path: settings.agents
class Translations$settings$agents$ja extends Translations$settings$agents$en {
	Translations$settings$agents$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$ja authStatus = Translations$settings$agents$authStatus$ja._(_root);
	@override late final Translations$settings$agents$install$ja install = Translations$settings$agents$install$ja._(_root);
	@override late final Translations$settings$agents$update$ja update = Translations$settings$agents$update$ja._(_root);
	@override late final Translations$settings$agents$account$ja account = Translations$settings$agents$account$ja._(_root);
	@override String get connectionStatus => '接続状態';
	@override late final Translations$settings$agents$login$ja login = Translations$settings$agents$login$ja._(_root);
	@override late final Translations$settings$agents$logout$ja logout = Translations$settings$agents$logout$ja._(_root);
	@override String error({required Object error}) => 'エラー: ${error}';
	@override late final Translations$settings$agents$accounts$ja accounts = Translations$settings$agents$accounts$ja._(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$ja extends Translations$settings$permissions$en {
	Translations$settings$permissions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '権限設定';
	@override late final Translations$settings$permissions$permissionMode$ja permissionMode = Translations$settings$permissions$permissionMode$ja._(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$ja extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCPサーバー';
	@override late final Translations$settings$mcpServers$description$ja description = Translations$settings$mcpServers$description$ja._(_root);
	@override String get addButton => 'MCPサーバーを追加';
	@override String get empty => 'MCPサーバーは設定されていません';
	@override String get serverType => '種類';
	@override late final Translations$settings$mcpServers$scope$ja scope = Translations$settings$mcpServers$scope$ja._(_root);
	@override late final Translations$settings$mcpServers$config$ja config = Translations$settings$mcpServers$config$ja._(_root);
	@override late final Translations$settings$mcpServers$tools$ja tools = Translations$settings$mcpServers$tools$ja._(_root);
	@override late final Translations$settings$mcpServers$actions$ja actions = Translations$settings$mcpServers$actions$ja._(_root);
	@override late final Translations$settings$mcpServers$managed$ja managed = Translations$settings$mcpServers$managed$ja._(_root);
	@override late final Translations$settings$mcpServers$help$ja help = Translations$settings$mcpServers$help$ja._(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$ja deleteConfirm = Translations$settings$mcpServers$deleteConfirm$ja._(_root);
}

// Path: settings.quota
class Translations$settings$quota$ja extends Translations$settings$quota$en {
	Translations$settings$quota$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$ja settings = Translations$settings$quota$settings$ja._(_root);
	@override late final Translations$settings$quota$empty$ja empty = Translations$settings$quota$empty$ja._(_root);
	@override late final Translations$settings$quota$quality$ja quality = Translations$settings$quota$quality$ja._(_root);
	@override String get syncFailed => '同期に失敗しました';
	@override String get syncNow => '今すぐ同期';
}

// Path: settings.browser
class Translations$settings$browser$ja extends Translations$settings$browser$en {
	Translations$settings$browser$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get checking => '確認中...';
	@override String get description => 'エージェントが監視付き Playwright ブラウザセッションを作成できるようにします。Browser タブで監視できます。';
	@override String get enableDescription => '対応エージェント向けに Browser を登録します。エージェントはブラウザセッションを作成でき、あなたは監視・停止・削除できます。';
	@override String get enableLabel => 'Browser を有効化';
	@override late final Translations$settings$browser$errors$ja errors = Translations$settings$browser$errors$ja._(_root);
	@override String get installHint => 'エージェントが Browser セッションを作成する前に、ブラウザランタイムをインストールしてください。';
	@override String get installRuntime => 'ランタイムをインストール';
	@override String get installed => 'インストール済み';
	@override String get installing => 'インストール中...';
	@override String get missing => '未インストール';
	@override String get runtimeRequired => 'ブラウザランタイムが必要です';
	@override String get statusDisabled => '無効';
	@override String get statusLabel => 'ステータス';
	@override String get statusReady => '準備完了';
	@override String get statusSetupRequired => 'セットアップが必要';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$ja extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get create => 'ワークスペースを追加';
	@override String get deleteConfirm => 'このワークスペースを DDAgent から削除しますか？ファイルはディスクに残ります。';
	@override String get deleteFailed => 'ワークスペースの削除に失敗しました。';
	@override String get deleteTitle => 'ワークスペースを削除';
	@override String get description => 'ワークスペースは、DDAgent がチャット・コード実行・ブラウジングできるディレクトリです。';
	@override String get remove => 'ワークスペースを削除';
	@override String get title => 'ワークスペース';
	@override String get pathRequired => 'パスは必須です';
}

// Path: settings.stt
class Translations$settings$stt$ja extends Translations$settings$stt$en {
	Translations$settings$stt$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '音声入力 (音声認識)';
	@override String get description => 'Whisper 互換の /audio/transcriptions エンドポイント (OpenAI、whisper.cpp、faster-whisper、Speaches)。入力欄のマイクボタンが有効になります。';
	@override String get configured => '設定済み';
	@override String get endpoint => 'エンドポイント URL (例: https://api.openai.com/v1)';
	@override String get apiKey => 'API キー';
	@override String get model => 'モデル (デフォルト: whisper-1)';
	@override String get save => '保存';
}

// Path: settings.schedules
class Translations$settings$schedules$ja extends Translations$settings$schedules$en {
	Translations$settings$schedules$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'スケジュール';
	@override String get description => 'cron の時刻表に従ってエージェントを定期実行します。実行は無人で行われ、権限確認はバイパスされます。';
	@override String get preventSleep => 'エージェント実行中はスリープを防止';
	@override String get preventSleepHint => 'デスクトップではディスプレイをオンのまま保ちます。ブラウザでは画面のウェイクロックを使用します。';
	@override String get kNew => '新しいスケジュール';
	@override String get loading => '読み込み中…';
	@override String get empty => 'スケジュールはまだありません。';
	@override String get project => 'プロジェクト';
	@override String get provider => 'プロバイダー';
	@override String get cron => 'Cron (分 時 日 月 曜日)';
	@override String nextRun({required Object time}) => '次回実行: ${time}';
	@override String get cronInvalid => 'この式では今後の実行予定がありません';
	@override String get prompt => 'プロンプト';
	@override String get useWorktree => '新しい worktree で実行';
	@override String get catchUp => '実行されなかった分を後から実行';
	@override String failures({required Object count}) => '${count} 件の失敗';
	@override String get disabled => '無効';
	@override String get history => '履歴';
	@override String get runNow => '今すぐ実行';
	@override String get delete => '削除';
	@override String get noRuns => '実行履歴はまだありません。';
	@override String get next => '次回';
	@override String get create => '作成';
	@override String get toggleSchedule => 'スケジュールを有効化';
}

// Path: settings.mcpTokens
class Translations$settings$mcpTokens$ja extends Translations$settings$mcpTokens$en {
	Translations$settings$mcpTokens$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent MCP サーバートークン';
	@override String get description => '外部ツール (Claude Desktop、OpenClaw) は、これらのいずれかのベアラートークンを使って POST /mcp で DDAgent のツールを呼び出します。';
	@override String get dismiss => '閉じる';
	@override String get labelPlaceholder => 'トークンのラベル (例: Claude Desktop)';
	@override String get create => '作成';
	@override String get empty => 'MCP トークンはまだありません。';
	@override String lastUsed({required Object time}) => '${time} に使用';
	@override String get neverUsed => '未使用';
}

// Path: settings.about
class Translations$settings$about$ja extends Translations$settings$about$en {
	Translations$settings$about$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => 'プロジェクトを支援';
	@override String get buyMeACoffee => 'Buy Me a Coffee';
	@override String get tryHosted => 'DDAgent Hosted を試す';
	@override String get learnMore => '詳細を見る';
	@override String get proFeatures => 'DDAgent Pro の機能';
	@override late final Translations$settings$about$pro$ja pro = Translations$settings$about$pro$ja._(_root);
	@override String get versionInfo => 'バージョン情報';
	@override String get client => 'アプリ';
	@override String get server => 'サーバー';
	@override String get platformMobile => 'モバイル';
	@override String get platformDesktop => 'デスクトップ';
	@override String get platformWeb => 'Web';
	@override String get unknown => '不明';
	@override String get copyright => '© 2026 DDAgent — All rights reserved';
	@override String get tagline => 'オープンソースの AI コーディングアシスタント インターフェース';
	@override String get docs => 'ドキュメント';
	@override String get hostedDescription => 'チームでのコラボレーション、共有 MCP 設定、環境間の設定同期、マネージドインフラストラクチャ。';
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$ja extends Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'DDAgent のすべてのキーボードショートカット (プラットフォーム別)。';
	@override String get action => '操作';
	@override String get winLinux => 'Windows / Linux';
	@override String get mac => 'macOS';
	@override String get navigation => 'ナビゲーション';
	@override String get navWorkspace => 'ワークスペースへ移動';
	@override String get navTasks => 'タスク / Git へ移動';
	@override String get navGit => 'Git へ移動';
	@override String get navFocus => 'フォーカスモードの切り替え (サイドバー)';
	@override String get navSwitcher => 'セッションのクイック切り替え';
	@override String get navPalette => 'コマンドパレット';
	@override String get navSettings => '設定を開く';
	@override String get navClose => 'ダイアログを閉じる / 分割ペインを元に戻す';
	@override String get composer => '入力欄';
	@override String get compSend => 'メッセージを送信';
	@override String get compNewline => '改行';
	@override String get compNav => '候補を移動';
	@override String get compAccept => '候補を確定';
	@override String get compCloseSuggest => '候補を閉じる';
	@override String get transcript => 'トランスクリプト';
	@override String get trCopy => '選択したテキストをコピー';
	@override String get trClose => '検索 / レビューパネルを閉じる';
	@override String get terminal => 'ターミナル';
	@override String get termCopy => '選択範囲をコピー';
	@override String get termInterrupt => 'プロセスを中断 (選択なし時)';
	@override String get termPaste => '貼り付け';
	@override String get termSelectAll => 'すべて選択';
	@override String get editor => 'エディター';
	@override String get edSave => 'ファイルを保存';
	@override String get edSaveAll => 'すべてのファイルを保存';
	@override String get edClose => 'タブを閉じる';
	@override String get edNextTab => '次のタブ';
	@override String get edPrevTab => '前のタブ';
	@override String get edIndent => 'インデント / インデント解除';
	@override String get palette => 'コマンドパレット';
	@override String get palNav => '項目を移動';
	@override String get palRun => '実行 / 開く';
	@override String get palBack => '戻る (検索が空の時)';
	@override String get palClose => '閉じる';
}

// Path: sidebar.projects
class Translations$sidebar$projects$ja extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プロジェクト';
	@override String get newProject => '新規プロジェクト';
	@override String get deleteProject => 'プロジェクトを除去';
	@override String get renameProject => 'プロジェクト名を変更';
	@override String get noProjects => 'プロジェクトが見つかりません';
	@override String get loadingProjects => 'プロジェクトを読み込んでいます...';
	@override String get searchPlaceholder => 'プロジェクトを検索...';
	@override String get projectNamePlaceholder => 'プロジェクト名';
	@override String get starred => 'お気に入り';
	@override String get all => 'すべて';
	@override String get untitledSession => '無題のセッション';
	@override String get newSession => '新しいセッション';
	@override String get codexSession => 'Codexセッション';
	@override String get fetchingProjects => 'Claudeのプロジェクトとセッションを取得しています';
	@override String get projects => 'プロジェクト';
	@override String get noMatchingProjects => '一致するプロジェクトがありません';
	@override String get tryDifferentSearch => '検索語を変えてお試しください';
	@override String get runClaudeCli => 'プロジェクトディレクトリでClaude CLIを実行して始めましょう';
}

// Path: sidebar.app
class Translations$sidebar$app$ja extends Translations$sidebar$app$en {
	Translations$sidebar$app$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'AIコーディングアシスタント';
}

// Path: sidebar.panel
class Translations$sidebar$panel$ja extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get open => 'パネル';
	@override String get newChat => '新しいチャット';
	@override String get navigation => 'ナビゲーション';
	@override String get sessions => 'セッション';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$ja extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'セッション';
	@override String get newSession => '新しいセッション';
	@override String get deleteSession => 'セッションを削除';
	@override String get renameSession => 'セッション名を変更';
	@override String get noSessions => 'セッションはまだありません';
	@override String get loadingSessions => 'セッションを読み込んでいます...';
	@override String get unnamed => '名称未設定';
	@override String get loading => '読み込み中...';
	@override String get showMore => 'さらにセッションを表示';
	@override String get selectMode => '選択';
	@override String get selectAll => 'すべて選択';
	@override String archiveSelected({required Object count}) => 'アーカイブ (${count})';
	@override String deleteSelected({required Object count}) => '削除 (${count})';
	@override String get cancelSelection => '選択をキャンセル';
	@override String get toggleSelection => 'セッション選択を切り替え';
	@override String get selectionToolbar => 'セッション選択アクション';
	@override String get options => 'セッションオプション';
	@override String get pinSession => 'セッションをピン留め';
	@override String get unpinSession => 'セッションのピン留めを解除';
	@override String get pinned => 'ピン留めされたセッション';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 件選択',
		other: '${count} 件選択',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$ja extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => '環境を表示';
	@override String get hideSidebar => 'サイドバーを隠す';
	@override String get createProject => '新しいプロジェクトを作成';
	@override String get refresh => 'プロジェクトとセッションを更新 (Ctrl+R)';
	@override String get renameProject => 'プロジェクト名を変更 (F2)';
	@override String get deleteProject => 'サイドバーからプロジェクトを除去 (Delete)';
	@override String get addToFavorites => 'お気に入りに追加';
	@override String get removeFromFavorites => 'お気に入りから削除';
	@override String get editSessionName => 'セッション名を手動で編集';
	@override String get deleteSession => 'このセッションを完全に削除';
	@override String get activeSessionIndicator => '最近アクティブなセッション（過去10分以内）';
	@override String get save => '保存';
	@override String get cancel => 'キャンセル';
	@override String get clearSearch => '検索をクリア';
	@override String get openCommandPalette => 'コマンドパレットを開く';
	@override String get attentionRequiredIndicator => 'セッションが対応を必要としています';
	@override String get openSessions => 'セッションを参照';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$ja extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get chat => 'チャット';
	@override String get files => 'ファイル';
	@override String get git => 'Git';
	@override String get terminal => 'ターミナル';
	@override String get tasks => 'タスク';
}

// Path: sidebar.actions
class Translations$sidebar$actions$ja extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get refresh => '更新';
	@override String get settings => '設定';
	@override String get collapseAll => 'すべて折りたたむ';
	@override String get expandAll => 'すべて展開';
	@override String get cancel => 'キャンセル';
	@override String get save => '保存';
	@override String get delete => '削除';
	@override String get rename => '名前の変更';
	@override String get joinCommunity => 'コミュニティに参加';
	@override String get reportIssue => '問題を報告';
	@override String get starOnGithub => 'GitHubでスター';
	@override String get buyMeACoffee => 'Buy Me a Coffee';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$ja extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'セッションのワークスペースを変更';
	@override String get description => 'エージェントはこのディレクトリで次のターンを実行します。既存のセッション履歴は保持されます。';
	@override String get pathLabel => 'ワークスペースのパス';
	@override String get pathRequired => 'ワークスペースのパスは必須です。';
	@override String get submit => 'ワークスペースを変更';
	@override String get saving => '変更中…';
	@override String get changeAction => 'ワークスペースを変更';
}

// Path: sidebar.branding
class Translations$sidebar$branding$ja extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get openSource => 'オープンソース';
}

// Path: sidebar.status
class Translations$sidebar$status$ja extends Translations$sidebar$status$en {
	Translations$sidebar$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get active => 'アクティブ';
	@override String get inactive => '非アクティブ';
	@override String get thinking => '思考中...';
	@override String get error => 'エラー';
	@override String get aborted => '中断';
	@override String get unknown => '不明';
}

// Path: sidebar.time
class Translations$sidebar$time$ja extends Translations$sidebar$time$en {
	Translations$sidebar$time$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'たった今';
	@override String get oneMinuteAgo => '1分前';
	@override String minutesAgo({required Object count}) => '${count}分前';
	@override String get oneHourAgo => '1時間前';
	@override String hoursAgo({required Object count}) => '${count}時間前';
	@override String get oneDayAgo => '1日前';
	@override String daysAgo({required Object count}) => '${count}日前';
}

// Path: sidebar.messages
class Translations$sidebar$messages$ja extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => '本当に削除しますか？';
	@override String get renameSuccess => '名前を変更しました';
	@override String get deleteSuccess => '削除しました';
	@override String get errorOccurred => 'エラーが発生しました';
	@override String get deleteSessionConfirm => 'このセッションを削除してもよろしいですか？この操作は取り消せません。';
	@override String get deleteProjectConfirm => 'サイドバーからこのプロジェクトを除去しますか？プロジェクトファイル、メモリ、セッションデータは削除されません。';
	@override String get enterProjectPath => 'プロジェクトのパスを入力してください';
	@override String get deleteSessionFailed => 'セッションの削除に失敗しました。もう一度お試しください。';
	@override String get deleteSessionError => 'セッションの削除でエラーが発生しました。もう一度お試しください。';
	@override String get renameSessionFailed => 'セッション名の変更に失敗しました。もう一度お試しください。';
	@override String get renameSessionError => 'セッション名の変更でエラーが発生しました。もう一度お試しください。';
	@override String get changeWorkspaceFailed => 'ワークスペースを変更できませんでした。もう一度お試しください。';
	@override String get changeWorkspaceError => 'ワークスペースの変更でエラーが発生しました。もう一度お試しください。';
	@override String get deleteProjectFailed => 'プロジェクトの除去に失敗しました。もう一度お試しください。';
	@override String get deleteProjectError => 'プロジェクトの除去でエラーが発生しました。もう一度お試しください。';
	@override String get createProjectFailed => 'プロジェクトの作成に失敗しました。もう一度お試しください。';
	@override String get createProjectError => 'プロジェクトの作成でエラーが発生しました。もう一度お試しください。';
	@override String get updateProjectError => 'プロジェクトの更新でエラーが発生しました。もう一度お試しください。';
	@override String get refreshError => '更新に失敗しました。もう一度お試しください。';
	@override String get restoreProjectFailed => 'プロジェクトの復元に失敗しました。もう一度お試しください。';
	@override String get restoreProjectError => 'プロジェクトの復元でエラーが発生しました。もう一度お試しください。';
	@override String get restoreSessionFailed => 'セッションの復元に失敗しました。もう一度お試しください。';
	@override String get restoreSessionError => 'セッションの復元でエラーが発生しました。もう一度お試しください。';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 件のセッションを削除できませんでした。もう一度お試しください。',
		other: '${count} 件のセッションを削除できませんでした。もう一度お試しください。',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$ja extends Translations$sidebar$version$en {
	Translations$sidebar$version$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => 'アップデートあり';
	@override String get restartRequired => '更新が適用されていません。サーバーを再起動してください';
	@override String get updateNow => '今すぐ更新';
	@override String updateConfirm({required Object version}) => 'DDAgent を v${version} に更新しますか？最新コードの取得とビルド後、サーバーが再起動します — 実行中のセッションは中断されます。';
	@override String get updating => '更新中… 数分かかることがあります';
	@override String get restarting => '更新をインストールしました — 再起動中…';
	@override String get updateFailed => '更新に失敗しました';
	@override String get releaseNotes => 'リリースノート';
}

// Path: sidebar.search
class Translations$sidebar$search$ja extends Translations$sidebar$search$en {
	Translations$sidebar$search$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => 'プロジェクト';
	@override String get modeConversations => '会話';
	@override String get conversationsPlaceholder => '会話内を検索...';
	@override String get searching => '検索中...';
	@override String get sessionTitles => 'セッション';
	@override String get conversationContents => '会話の内容';
	@override String get noResults => '結果が見つかりません';
	@override String get tryDifferentQuery => '別の検索語をお試しください';
	@override String get modeRunning => '実行中';
	@override String get archiveOnly => 'アーカイブ';
	@override String get runningTooltip => '実行中のセッション';
	@override String get archiveOnlyTooltip => 'アーカイブのみ';
	@override String runningCount({required Object count}) => '${count} 件アクティブ';
	@override String get viewMenu => '表示';
	@override String get backToProjects => 'プロジェクトに戻る';
	@override String get archivedPlaceholder => 'アーカイブ済みセッションを検索...';
	@override String get runningPlaceholder => '実行中セッションを検索...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 件一致',
		other: '${count} 件一致',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 件のプロジェクトをスキャン',
		other: '${count} 件のプロジェクトをスキャン',
	);
}

// Path: sidebar.recent
class Translations$sidebar$recent$ja extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '最近の会話';
	@override String get emptyTitle => 'まだ会話がありません';
	@override String get emptyDescription => '最近更新された会話がここに表示されます。';
	@override String get loadFailed => '最近の会話を読み込めませんでした';
	@override String get loadMore => '過去の会話を読み込む';
	@override String get loadingMore => '読み込み中...';
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$ja extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => 'プロジェクトを除去';
	@override String get deleteSession => 'セッションを削除';
	@override String get confirmDelete => 'このプロジェクトをどうしますか：';
	@override String get removeFromSidebar => 'サイドバーからのみ除去';
	@override String get deleteAllData => 'すべてのデータを完全に削除';
	@override String get allConversationsDeleted => 'プロジェクトはサイドバーから除去されます。ファイル、メモリ、セッションデータは保持されます。';
	@override String get cannotUndo => '後からプロジェクトを再追加できます。';
	@override String get bulkDeleteSessionsDescription => 'アーカイブは選択したセッションをアクティブリストから隠し、履歴を保持します。';
	@override String get archiveSession => 'セッションをアーカイブ';
	@override String get archiveSessionNotice => 'アーカイブは履歴を保持したままセッションをアクティブリストから外します。';
	@override String get archivedSessionNotice => 'このセッションは既にアーカイブされています。非表示のままにするか、完全に削除できます。';
	@override String get deleteSessionNotice => 'セッションとそのトランスクリプトを完全に削除します。この操作は元に戻せません。';
	@override String get deleteSessionPermanently => '完全に削除';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: 'このプロジェクトには ${count} 件の会話があります。',
		other: 'このプロジェクトには ${count} 件の会話があります。',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '選択したセッションを管理',
		other: '選択した ${count} 件のセッションを管理',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: 'セッションをアーカイブ',
		other: '${count} 件のセッションをアーカイブ',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$ja extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get activeNow => '現在アクティブ';
	@override String get recent => '最近使用した項目';
	@override String get today => '今日';
	@override String get yesterday => '昨日';
	@override String get thisWeek => '今週';
	@override String showMore({required Object count}) => 'さらに${count}件表示';
	@override String get showLess => '表示を減らす';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$ja extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get board => 'エージェントボード';
	@override String get files => 'ファイル';
	@override String get git => 'ソース管理';
	@override String get tasks => 'タスク';
	@override String get usage => 'クォータと使用量';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$ja extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AIが設定されていません';
	@override String get description => 'TaskMasterは、AIを活用した支援により、複雑なプロジェクトを管理しやすいタスクに分解するのに役立ちます';
	@override String get whatIsTitle => '🎯 TaskMasterとは？';
	@override late final Translations$tasks$notConfigured$features$ja features = Translations$tasks$notConfigured$features$ja._(_root);
	@override String get initializeButton => 'TaskMaster AIを初期化';
	@override String get writePrdFirst => '先にPRDを作成してください';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$ja extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMasterを始める';
	@override String get subtitle => 'TaskMasterが初期化されました！次にすることは:';
	@override late final Translations$tasks$gettingStarted$steps$ja steps = Translations$tasks$gettingStarted$steps$ja._(_root);
	@override String get tip => '💡 ヒント：TaskMasterのAIを活用したタスク生成を最大限に活用するには、PRDから始めましょう';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$ja extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMasterのセットアップ';
	@override String subtitle({required Object projectName}) => '${projectName}のインタラクティブCLI';
	@override String get willStart => 'TaskMasterの初期化が自動的に開始されます';
	@override String get completed => 'TaskMasterのセットアップが完了しました！このウィンドウを閉じることができます。';
	@override String get closeButton => '閉じる';
	@override String get closeContinueButton => '閉じて続ける';
	@override String get closeTitle => '閉じる';
	@override String get description => 'このプロジェクトに .taskmaster フォルダを作成します。外部ツールやAPIキーは不要 — タスクはローカルに保存されます。';
	@override String get initializeButton => '初期化';
	@override String get initializing => '初期化中...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$ja extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMasterを始める';
	@override String get subtitle => '生産的なタスク管理のガイド';
	@override late final Translations$tasks$helpGuide$examples$ja examples = Translations$tasks$helpGuide$examples$ja._(_root);
	@override String get moreExamples => 'さらなる例と使用パターンを見る →';
	@override late final Translations$tasks$helpGuide$proTips$ja proTips = Translations$tasks$helpGuide$proTips$ja._(_root);
	@override late final Translations$tasks$helpGuide$learnMore$ja learnMore = Translations$tasks$helpGuide$learnMore$ja._(_root);
	@override String get closeTitle => '閉じる';
}

// Path: tasks.search
class Translations$tasks$search$ja extends Translations$tasks$search$en {
	Translations$tasks$search$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'タスクを検索...';
}

// Path: tasks.filters
class Translations$tasks$filters$ja extends Translations$tasks$filters$en {
	Translations$tasks$filters$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get button => 'フィルター';
	@override String get status => 'ステータス';
	@override String get priority => '優先度';
	@override String get sortBy => '並び替え';
	@override String get allStatuses => 'すべてのステータス';
	@override String get allPriorities => 'すべての優先度';
	@override String showing({required Object filtered, required Object total}) => '${filtered}件のタスクを表示中（全${total}件）';
	@override String get clearFilters => 'フィルターをクリア';
}

// Path: tasks.sort
class Translations$tasks$sort$ja extends Translations$tasks$sort$en {
	Translations$tasks$sort$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => 'ステータス';
	@override String get priority => '優先度';
	@override String get idAsc => 'ID（昇順）';
	@override String get idDesc => 'ID（降順）';
	@override String get titleAsc => 'タイトル（A-Z）';
	@override String get titleDesc => 'タイトル（Z-A）';
	@override String get statusAsc => 'ステータス（保留中が先）';
	@override String get statusDesc => 'ステータス（完了が先）';
	@override String get priorityAsc => '優先度（高が先）';
	@override String get priorityDesc => '優先度（低が先）';
}

// Path: tasks.views
class Translations$tasks$views$ja extends Translations$tasks$views$en {
	Translations$tasks$views$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get kanban => 'カンバンビュー';
	@override String get list => 'リストビュー';
	@override String get grid => 'グリッドビュー';
}

// Path: tasks.kanban
class Translations$tasks$kanban$ja extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 やること';
	@override String get inProgress => '🚀 進行中';
	@override String get review => '👀 レビュー';
	@override String get done => '✅ 完了';
	@override String get blocked => '🚫 ブロック中';
	@override String get deferred => '⏳ 延期';
	@override String get cancelled => '❌ キャンセル';
	@override String get noTasksYet => 'まだタスクはありません';
	@override String get tasksWillAppear => 'タスクはここに表示されます';
	@override String get moveTasksHere => '開始したらタスクをここに移動';
	@override String get completedTasksHere => '完了したタスクはここに表示されます';
	@override String get statusTasksHere => 'このステータスのタスクはここに表示されます';
}

// Path: tasks.buttons
class Translations$tasks$buttons$ja extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get help => 'TaskMaster入門ガイド';
	@override String get prds => 'PRD';
	@override String get addPRD => 'PRDを追加';
	@override String get addTask => 'タスクを追加';
	@override String get createNewPRD => '新しいPRDを作成';
	@override String prdsAvailable({required Object count}) => '${count}件のPRDがあります';
}

// Path: tasks.prd
class Translations$tasks$prd$ja extends Translations$tasks$prd$en {
	Translations$tasks$prd$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => '更新日: ${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String get newFile => '新しいファイル';
	@override String get template => 'テンプレート';
	@override String get parse => 'PRDを解析';
	@override String get fileExistsTitle => 'ファイルは既に存在します';
	@override String fileExistsMessage({required Object name}) => '「${name}」という名前のPRDが既に存在します。上書きしますか？';
	@override String get fileNameHint => 'ファイル名（例: prd.txt）';
	@override String get saved => 'PRDを保存しました';
	@override String get tasksGenerated => 'PRDからタスクを生成しました';
}

// Path: tasks.statuses
class Translations$tasks$statuses$ja extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get pending => '保留中';
	@override String get inProgress => '進行中';
	@override String get done => '完了';
	@override String get blocked => 'ブロック中';
	@override String get deferred => '延期';
	@override String get cancelled => 'キャンセル';
	@override String get review => 'レビュー';
}

// Path: tasks.priorities
class Translations$tasks$priorities$ja extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get high => '高';
	@override String get medium => '中';
	@override String get low => '低';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$ja extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'フィルターに一致するタスクがありません';
	@override String get description => '検索条件またはフィルター基準を調整してみてください。';
}

// Path: tasks.board
class Translations$tasks$board$ja extends Translations$tasks$board$en {
	Translations$tasks$board$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エージェントボード';
	@override String get subtitle => 'カードを「開始可能」に移動するとエージェントが引き受けます。カードをクリックするとセッションが開きます。';
	@override String get newCard => '新しいカード';
	@override String get addCard => 'カードを追加';
	@override String get refresh => '更新';
	@override late final Translations$tasks$board$empty$ja empty = Translations$tasks$board$empty$ja._(_root);
	@override late final Translations$tasks$board$columns$ja columns = Translations$tasks$board$columns$ja._(_root);
	@override late final Translations$tasks$board$card$ja card = Translations$tasks$board$card$ja._(_root);
	@override late final Translations$tasks$board$dialog$ja dialog = Translations$tasks$board$dialog$ja._(_root);
	@override String get noProject => 'まずプロジェクトを追加し、そのプロジェクトのカードを作成してください。';
	@override String get projectLabel => 'プロジェクト';
	@override String get backToChat => 'チャットに戻る';
	@override late final Translations$tasks$board$agent$ja agent = Translations$tasks$board$agent$ja._(_root);
	@override late final Translations$tasks$board$deleteConfirm$ja deleteConfirm = Translations$tasks$board$deleteConfirm$ja._(_root);
	@override String get project => 'プロジェクト';
	@override late final Translations$tasks$board$assignee$ja assignee = Translations$tasks$board$assignee$ja._(_root);
	@override late final Translations$tasks$board$presence$ja presence = Translations$tasks$board$presence$ja._(_root);
	@override late final Translations$tasks$board$activity$ja activity = Translations$tasks$board$activity$ja._(_root);
	@override late final Translations$tasks$board$comments$ja comments = Translations$tasks$board$comments$ja._(_root);
}

// Path: tasks.card
class Translations$tasks$card$ja extends Translations$tasks$card$en {
	Translations$tasks$card$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => '依存: ${tasks}';
	@override String dependsOnTooltip({required Object id}) => 'タスク ${id}';
	@override String get highPriority => '優先度：高';
	@override String get lowPriority => '優先度：低';
	@override String get mediumPriority => '優先度：中';
	@override String get noPriority => '優先度未設定';
	@override String parentTask({required Object id}) => 'タスク ${id}';
	@override String get progressLabel => '進捗:';
	@override String progressTooltip({required Object total, required Object completed}) => '${total} 件のサブタスク中 ${completed} 件完了';
	@override String get runTask => 'タスクを実行';
	@override String runTaskAria({required Object id}) => 'タスク ${id} を実行';
	@override String statusTooltip({required Object status}) => 'ステータス: ${status}';
	@override String taskIdTitle({required Object id}) => 'タスクID: ${id}';
	@override String get taskInProgress => 'タスク実行中';
}

// Path: tasks.createTask
class Translations$tasks$createTask$ja extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get descriptionLabel => '説明';
	@override String get descriptionPlaceholder => '任意の詳細';
	@override String get error => 'タスクの追加に失敗しました';
	@override String get priorityLabel => '優先度';
	@override String get submit => 'タスクを追加';
	@override String get submitting => '追加中...';
	@override String get title => 'タスクを追加';
	@override String get titleLabel => 'タイトル';
	@override String get titlePlaceholder => '何をすべきですか？';
}

// Path: tasks.list
class Translations$tasks$list$ja extends Translations$tasks$list$en {
	Translations$tasks$list$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => '完了（クリックで再開）';
	@override String get inProgressComplete => '進行中（クリックで完了）';
	@override String get markCompleted => '完了としてマーク';
	@override String toggleStatusAria({required Object id}) => 'タスク ${id} のステータスを切り替え';
	@override String get markDone => '完了にする';
	@override String get reopen => '再開';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$ja extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get allComplete => 'すべてのタスクが完了';
	@override String get feature1 => '- 依存関係とサブタスクを備えたAIタスク管理。';
	@override String get feature2 => '- PRD駆動のタスク生成でプロジェクトを迅速に開始。';
	@override String get feature3 => '- 日常作業向けのカンバンとリストビュー。';
	@override String get hideDetails => '詳細を隠す';
	@override String get initialize => '初期化';
	@override String get noPending => '保留中のタスクはありません';
	@override String get notConfigured => 'TaskMaster AI が設定されていません';
	@override String get review => '確認';
	@override String get startTask => 'タスクを開始';
	@override String taskId({required Object id}) => 'タスク ${id}';
	@override String get viewAll => 'すべてのタスクを表示';
	@override String get viewDetails => 'タスクの詳細を表示';
	@override String get whatIs => 'TaskMaster とは？';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$ja extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => '編集をキャンセル';
	@override String get close => '閉じる';
	@override String get copyTaskId => 'タスクIDをコピー';
	@override String get delete => 'タスクを削除';
	@override String deleteConfirmDescription({required Object title}) => '「${title}」は完全に削除されます。';
	@override String get deleteConfirmTitle => 'タスクを削除しますか？';
	@override String get deleteFailed => 'タスクの削除に失敗しました';
	@override String get dependencies => '依存関係';
	@override String get dependenciesPlaceholder => '例: 1, 2, 3';
	@override String get description => '説明';
	@override String get edit => 'タスクを編集';
	@override String get implDetails => '実装の詳細';
	@override String get noDependencies => '依存関係なし';
	@override String get noDescription => '説明がありません';
	@override String get priority => '優先度';
	@override String get priorityNotSet => '未設定';
	@override String get save => '保存';
	@override String get status => 'ステータス';
	@override String get statusFailed => 'タスクステータスの更新に失敗しました';
	@override String taskId({required Object id}) => 'タスク ${id}';
	@override String taskTitle({required Object id, required Object title}) => 'タスク ${id}: ${title}';
	@override String get testStrategy => 'テスト戦略';
	@override String get titleRequired => 'タイトルは必須です';
	@override String get updateFailed => 'タスクの更新に失敗しました';
	@override String get notFound => 'タスクが見つかりません';
	@override String get subtasks => 'サブタスク';
	@override String deleteConfirmMessage({required Object id}) => 'タスク #${id} は削除されます。元に戻せません。';
	@override String get idCopied => 'タスクIDをコピーしました';
}

// Path: tasks.toasts
class Translations$tasks$toasts$ja extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => 'タスク ${id} を進行中に設定しました';
}

// Path: tasks.taskmaster
class Translations$tasks$taskmaster$ja extends Translations$tasks$taskmaster$en {
	Translations$tasks$taskmaster$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get noProjectHint => 'まずプロジェクトを追加してから、タスクを作成してください。';
	@override late final Translations$tasks$taskmaster$sort$ja sort = Translations$tasks$taskmaster$sort$ja._(_root);
	@override String installedVersion({required Object version}) => 'インストール済み: ${version}';
	@override String get initFailed => 'TaskMaster を初期化できませんでした';
	@override late final Translations$tasks$taskmaster$prd$ja prd = Translations$tasks$taskmaster$prd$ja._(_root);
	@override late final Translations$tasks$taskmaster$detail$ja detail = Translations$tasks$taskmaster$detail$ja._(_root);
	@override String get untitledTask => '無題のタスク';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$ja extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dashboard => 'ダッシュボード';
	@override String get memories => 'メモリ';
	@override String get rules => 'ルール';
	@override String get skills => 'スキル';
	@override String get personal => '個人情報';
	@override String get graph => 'グラフ';
}

// Path: knowledge.common
class Translations$knowledge$common$ja extends Translations$knowledge$common$en {
	Translations$knowledge$common$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get add => '追加';
	@override String get save => '保存';
	@override String get cancel => 'キャンセル';
	@override String get delete => '削除';
	@override String get edit => '編集';
	@override String get close => '閉じる';
	@override String get restore => '復元';
	@override String get refresh => '更新';
	@override String get allProjects => 'すべてのプロジェクト';
	@override String get global => 'グローバル';
}

// Path: knowledge.actions
class Translations$knowledge$actions$ja extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get scan => 'プロジェクトファイルをスキャン';
	@override String get export => 'JSONをエクスポート';
	@override String get import => 'JSONをインポート';
	@override String get scanComplete => 'スキャンが完了しました';
	@override String get importComplete => 'インポートが完了しました';
	@override String get importFailed => 'インポートに失敗しました';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$ja extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newEntity => '新規エントリ';
	@override String get editEntity => 'エントリを編集';
	@override String get deleteTitle => '削除';
	@override String get deleteMessage => 'このエントリを削除しますか？元に戻せません（履歴は保持されます）。';
	@override String get pickIcon => 'アイコンを選択';
	@override String get removeIcon => 'アイコンを削除';
	@override String get iconTooLarge => 'アイコンが大きすぎます（最大40KB）。';
	@override String get importTitle => 'ナレッジをインポート';
	@override String get importHint => 'エクスポートしたJSONを貼り付け';
	@override String get exportTitle => 'ナレッジをエクスポート';
	@override String get import => 'インポート';
}

// Path: knowledge.fields
class Translations$knowledge$fields$ja extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get key => 'キー';
	@override String get title => 'タイトル';
	@override String get name => '名前';
	@override String get description => '説明';
	@override String get category => 'カテゴリ';
	@override String get content => '内容';
	@override String get priority => '優先度';
	@override String get tags => 'タグ';
	@override String get enabled => '有効';
	@override String get projectScope => 'プロジェクト範囲';
	@override String get tagsHint => 'カンマ区切り';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$ja extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get memories => 'メモリ';
	@override String get rules => 'ルール';
	@override String get skills => 'スキル';
	@override String get personal => '個人情報';
	@override String get connections => '接続';
	@override String get recent => '最近のメモリ';
	@override String get noMemories => 'メモリがありません。メモリタブで追加してください。';
}

// Path: knowledge.empty
class Translations$knowledge$empty$ja extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get memories => 'メモリがありません。';
	@override String get rules => 'ルールがありません。';
	@override String get skills => 'スキルがありません。';
	@override String get personal => '個人情報がありません。';
	@override String get graph => 'グラフに表示する項目がありません。';
}

// Path: knowledge.history
class Translations$knowledge$history$ja extends Translations$knowledge$history$en {
	Translations$knowledge$history$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '履歴';
	@override String get none => '履歴がありません。';
	@override String get untitled => '（無題）';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$ja extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get critical => 'クリティカル';
	@override String get high => '高';
	@override String get normal => '通常';
	@override String get low => '低';
}

// Path: knowledge.search
class Translations$knowledge$search$ja extends Translations$knowledge$search$en {
	Translations$knowledge$search$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ナレッジを検索';
	@override String get hint => 'メモリ、ルール、スキルを検索…';
	@override String get noResults => '結果がありません。';
}

// Path: knowledge.links
class Translations$knowledge$links$ja extends Translations$knowledge$links$en {
	Translations$knowledge$links$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エンティティをリンク';
	@override String get source => 'ソース';
	@override String get target => 'ターゲット';
	@override String get relationship => '関係';
	@override String get add => 'リンクを作成';
}

// Path: knowledge.tags
class Translations$knowledge$tags$ja extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get all => 'すべてのタグ';
	@override String get manage => 'タグを管理';
	@override String get none => 'タグがありません。';
}

// Path: knowledge.graph
class Translations$knowledge$graph$ja extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get truncated => '省略';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$ja extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'すべてを DDAgent にインポート';
	@override String projectsScanned({required Object count}) => 'スキャンしたプロジェクト: ${count}';
	@override String skillsFound({required Object found, required Object newSkills}) => '見つかったエージェントスキル: ${found} (新規: ${newSkills})';
	@override String rulesSummary({required Object total, required Object duplicates}) => 'ルール: ${total} · 重複グループ: ${duplicates}';
	@override String get mergeDuplicates => '重複エントリを統合';
	@override String get mergeDuplicatesHint => 'DDAgent 内の重複行を統合します（ファイルではありません）';
	@override String get action => 'すべてをインポート';
	@override String get readOnlyNotice => 'エージェント側は読み取り専用です：DDAgent 独自のデータベースにインポートするだけで、CLI のファイルや設定を変更・削除することはありません。以下のオプションは DDAgent のデータのみを変更します。';
	@override String get dryRunNote => 'ドライラン — まだ何も書き込まれていません。';
	@override String get importedNote => 'インポートしました。';
	@override String result({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'インポート完了 — ルール: ${rules}、新しいスキル: ${newSkills}、削除: ${removed}、昇格: ${promoted}';
	@override String get description => 'すべてのプロジェクトをスキャンし、エージェントのスキルをナレッジベースにインポートします。エージェント側は読み取り専用で、CLI 内のものは何も変更されません。';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$ja extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '既存のルールを移行';
	@override String scanned({required Object count}) => '${count} 件のプロジェクトをスキャンしました。';
	@override String rulesSummary({required Object total, required Object critical}) => 'ルール: 合計 ${total}、クリティカル ${critical}。';
	@override String duplicates({required Object count}) => 'プロジェクト間の重複グループ: ${count}';
	@override String removedPromoted({required Object removed, required Object promoted}) => '削除: ${removed}、昇格: ${promoted}';
	@override String get mergeDuplicates => '重複を統合';
	@override String get dryRunNote => 'ドライラン — まだ何も変更されていません。';
	@override String get applied => '適用しました。';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$ja extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エージェントスキルをインポート';
	@override String found({required Object count}) => 'エージェント全体で ${count} 件のスキルが見つかりました。';
	@override String summary({required Object imported, required Object skipped}) => '新規: ${imported} · スキップ: ${skipped}';
	@override String get dryRunHint => 'エージェントに付属するグローバル／デフォルトのスキル（ユーザー、システム、プラグイン）をナレッジのスキルとしてインポートします。ドライラン — まだ何もインポートされていません。';
	@override String get importedNote => 'ナレッジベースにインポートしました。';
}

// Path: knowledge.critical
class Translations$knowledge$critical$ja extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get make => 'クリティカルにする';
	@override String get makeAll => 'すべてのルールをクリティカルにする';
	@override String get makeAllHint => 'それらを注入されるコンテキスト予算に追加します';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$ja extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} トークン';
	@override String get title => 'ルールコンテキスト（常に提供）';
	@override String get selectProject => 'プロジェクトを選択すると、重要コンテキストのサイズが表示されます。';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$ja extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => 'メモリ: ${title}';
	@override String rule({required Object title}) => 'ルール: ${title}';
	@override String skill({required Object name}) => 'スキル: ${name}';
	@override String personal({required Object title}) => '個人情報: ${title}';
}

// Path: knowledge.errors
class Translations$knowledge$errors$ja extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => 'インポートに失敗しました: ${error}';
	@override String migrationFailed({required Object error}) => '移行に失敗しました: ${error}';
}

// Path: knowledge.entityTypes
class Translations$knowledge$entityTypes$ja extends Translations$knowledge$entityTypes$en {
	Translations$knowledge$entityTypes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get memory => 'メモリ';
	@override String get rule => 'ルール';
	@override String get skill => 'スキル';
	@override String get personal => '個人情報';
	@override String get project => 'プロジェクト';
	@override String get tag => 'タグ';
}

// Path: collab.roles
class Translations$collab$roles$ja extends Translations$collab$roles$en {
	Translations$collab$roles$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get member => 'メンバー';
	@override String get viewer => '閲覧者';
}

// Path: collab.viewing
class Translations$collab$viewing$ja extends Translations$collab$viewing$en {
	Translations$collab$viewing$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get session => 'セッション';
	@override String get card => 'カード';
	@override String get board => 'ボード';
}

// Path: fileTree.search
class Translations$fileTree$search$ja extends Translations$fileTree$search$en {
	Translations$fileTree$search$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get hint => '名前を絞り込み / Enterで内容を検索';
	@override String get prompt => 'クエリを入力してEnterを押してください';
	@override String get noMatches => '一致するものがありません';
	@override String get resultsTruncated => '結果は省略されています';
}

// Path: fileTree.titles
class Translations$fileTree$titles$ja extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String rename({required Object name}) => '${name} の名前を変更';
	@override String delete({required Object name}) => '${name} を削除';
	@override String download({required Object name}) => '${name} をダウンロード';
}

// Path: fileTree.relative
class Translations$fileTree$relative$ja extends Translations$fileTree$relative$en {
	Translations$fileTree$relative$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get now => 'たった今';
	@override String minutes({required Object n}) => '${n}分';
	@override String hours({required Object n}) => '${n}時間';
	@override String days({required Object n}) => '${n}日';
}

// Path: git.checkpoints
class Translations$git$checkpoints$ja extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'チェックポイント';
	@override String get restoreTitle => 'チェックポイントを復元';
	@override String get restoreMessage => '作業ツリーをこのチェックポイントにリセットしますか？現在の変更は置き換えられます。';
	@override String get restored => 'チェックポイントを復元しました';
	@override String get labelHint => 'チェックポイントのラベル（任意）';
	@override String get empty => 'チェックポイントはまだありません';
	@override String get create => '新規';
}

// Path: git.branchSections
class Translations$git$branchSections$ja extends Translations$git$branchSections$en {
	Translations$git$branchSections$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get local => 'ローカル';
	@override String get remote => 'リモート';
}

// Path: kanban.card
class Translations$kanban$card$ja extends Translations$kanban$card$en {
	Translations$kanban$card$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get untitled => '無題';
}

// Path: kanban.comments
class Translations$kanban$comments$ja extends Translations$kanban$comments$en {
	Translations$kanban$comments$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get empty => 'コメントはまだありません';
	@override String get add => 'コメントを追加';
}

// Path: kanban.dialog
class Translations$kanban$dialog$ja extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get saving => '保存中…';
}

// Path: kanban.details
class Translations$kanban$details$ja extends Translations$kanban$details$en {
	Translations$kanban$details$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'カードの詳細';
	@override String status({required Object status}) => 'ステータス: ${status}';
}

// Path: kanban.empty
class Translations$kanban$empty$ja extends Translations$kanban$empty$en {
	Translations$kanban$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get noProject => 'プロジェクトが選択されていません';
}

// Path: kanban.time
class Translations$kanban$time$ja extends Translations$kanban$time$en {
	Translations$kanban$time$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get now => 'たった今';
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '1分前',
		other: '${count}分前',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '1時間前',
		other: '${count}時間前',
	);
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '1日前',
		other: '${count}日前',
	);
}

// Path: mcp.install
class Translations$mcp$install$ja extends Translations$mcp$install$en {
	Translations$mcp$install$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent MCPサーバーをインストール';
	@override String get description => '選択したエージェントがMCP経由でDDAgentのナレッジベースとツールを使用できるようにします。';
	@override String get cardDescription => 'MCP経由でエージェントにナレッジベースとDDAgentツールを提供します — エージェントを選択するか、すべてにインストールしてください。';
	@override String get installSelected => '選択項目にインストール';
	@override String get installForAll => 'すべてにインストール';
	@override String get button => 'インストール';
	@override String failed({required Object error}) => 'インストールに失敗しました: ${error}';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 個のエージェントにインストールしました。',
		other: '${count} 個のエージェントにインストールしました。',
	);
	@override String partialFailure({required Object count, required Object failed}) => '${count} 個にインストールしました。失敗: ${failed}';
	@override String get errorFallback => 'エラー';
}

// Path: mcp.servers
class Translations$mcp$servers$ja extends Translations$mcp$servers$en {
	Translations$mcp$servers$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'MCPサーバーを読み込み中...';
	@override String get refreshingScopes => 'プロジェクトスコープを更新中...';
	@override String descriptionGeneric({required Object provider}) => 'Model Context Protocolサーバーは ${provider} に追加のツールとデータソースを提供します';
	@override String get addGlobalTitle => 'グローバルMCPサーバーを追加';
	@override String get addGlobalDescription => 'このMCPサーバーをすべてのプロバイダー（Claude、Cursor、Codex、OpenCode、Devin）に追加します。同じ設定をすべてのプロバイダーで機能させる必要があるため、stdio と HTTP トランスポートのみがサポートされます。';
	@override String get addGlobalMenuDescription => 'グローバルMCPサーバーの追加は、共通の stdio または HTTP サーバーを Claude、Cursor、Codex、OpenCode、Devin に書き込みます。';
	@override String addProviderTitle({required Object provider}) => '${provider} MCPサーバーを追加';
	@override String addProviderDescription({required Object provider}) => '${provider} MCPサーバーの追加は ${provider} のみを変更します。';
	@override late final Translations$mcp$servers$config$ja config = Translations$mcp$servers$config$ja._(_root);
	@override String get selectProjectRequired => 'プロジェクトスコープの MCP サーバーにはプロジェクトを選択してください';
	@override String get globalScopeUnsupported => 'すべてのプロバイダーへの MCP サーバー追加では、ユーザーまたはプロジェクトのスコープのみ使用できます。';
	@override String globalAddFailed({required Object details}) => 'MCP サーバーをすべてのプロバイダーに追加できませんでした。${details}';
	@override String get scopeProject => 'プロジェクト';
}

// Path: mcp.team
class Translations$mcp$team$ja extends Translations$mcp$team$en {
	Translations$mcp$team$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'チームMCP設定';
	@override String get description => 'MCPサーバー設定をチーム全体で共有します。全員が自動的に同期されます。';
	@override String get cta => 'DDAgent Pro で利用できます';
}

// Path: mcp.tokens
class Translations$mcp$tokens$ja extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => '書き込み';
	@override String get scopeRead => '読み取り';
}

// Path: mcp.form
class Translations$mcp$form$ja extends Translations$mcp$form$en {
	Translations$mcp$form$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String submitTo({required Object provider}) => '${provider} にサーバーを追加';
	@override late final Translations$mcp$form$scope$ja scope = Translations$mcp$form$scope$ja._(_root);
	@override late final Translations$mcp$form$fields$ja fields = Translations$mcp$form$fields$ja._(_root);
	@override late final Translations$mcp$form$validation$ja validation = Translations$mcp$form$validation$ja._(_root);
}

// Path: notifications.errors
class Translations$notifications$errors$ja extends Translations$notifications$errors$en {
	Translations$notifications$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get registrationRejected => 'サーバーに登録を拒否されました';
	@override String get noResponse => 'サーバーから応答がありません';
}

// Path: notifications.androidChannel
class Translations$notifications$androidChannel$ja extends Translations$notifications$androidChannel$en {
	Translations$notifications$androidChannel$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => 'DDAgent アラート';
	@override String get description => 'エージェントの実行、承認、エラーに関する通知';
}

// Path: onboarding.errors
class Translations$onboarding$errors$ja extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get nameAndEmailRequired => 'git の名前とメールアドレスの両方が必要です。';
	@override String get invalidEmail => '有効なメールアドレスを入力してください。';
}

// Path: onboarding.agents
class Translations$onboarding$agents$ja extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'AIエージェントを接続';
	@override String get description => '1つ以上のAIコーディングアシスタントにログインします。すべて任意です。';
	@override String get laterHint => 'これらは後で設定で構成できます。';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$ja extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エージェントを DDAgent に接続';
	@override String get description => 'DDAgent MCPサーバーをインストールすると、エージェントがナレッジベースとDDAgentツールを使用できるようになります。エージェントを選択するか、すべてにインストールしてください。';
	@override String get installSelected => '選択項目にインストール';
	@override String get installForAll => 'すべてにインストール';
	@override String get laterHint => '任意 — 後で設定 → MCP からインストールすることもできます。';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 個のエージェントにインストールしました。',
		other: '${count} 個のエージェントにインストールしました。',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => '${installedCount} 個にインストールしました。失敗: ${failed}';
}

// Path: quota.section
class Translations$quota$section$ja extends Translations$quota$section$en {
	Translations$quota$section$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get config => '設定';
}

// Path: quota.overview
class Translations$quota$overview$ja extends Translations$quota$overview$en {
	Translations$quota$overview$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => 'トークンとコスト';
}

// Path: quota.agents
class Translations$quota$agents$ja extends Translations$quota$agents$en {
	Translations$quota$agents$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status} (${count})';
}

// Path: quota.config
class Translations$quota$config$ja extends Translations$quota$config$en {
	Translations$quota$config$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get pollerTitle => 'ポーラーとアラート';
	@override String get accountRouting => 'アカウントのルーティング';
	@override String get save => '設定を保存';
}

// Path: quota.chart
class Translations$quota$chart$ja extends Translations$quota$chart$en {
	Translations$quota$chart$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get show => '表示';
	@override String get hide => '非表示';
	@override String get noData => 'トレンドを表示するにはデータが不足しています。';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} トークン · ${cost}';
}

// Path: quota.duration
class Translations$quota$duration$ja extends Translations$quota$duration$en {
	Translations$quota$duration$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String minutes({required Object minutes}) => '${minutes}分';
	@override String hoursMinutes({required Object hours, required Object minutes}) => '${hours}時間${minutes}分';
	@override String daysHours({required Object days, required Object hours}) => '${days}日${hours}時間';
	@override String get now => 'たった今';
}

// Path: scheduler.runStatus
class Translations$scheduler$runStatus$ja extends Translations$scheduler$runStatus$en {
	Translations$scheduler$runStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get fired => '起動';
	@override String get skipped => 'スキップ';
	@override String get failed => '失敗';
	@override String get completed => '完了';
}

// Path: scheduler.cronErrors
class Translations$scheduler$cronErrors$ja extends Translations$scheduler$cronErrors$en {
	Translations$scheduler$cronErrors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String fieldCount({required Object got}) => '5 つのフィールドが必要ですが、${got} 個です';
	@override String fieldError({required Object index, required Object error}) => 'フィールド ${index}: ${error}';
	@override String get empty => '空です';
	@override String invalidPart({required Object part}) => '「${part}」は無効です';
	@override String invalidValue({required Object value}) => '無効な値「${value}」';
}

// Path: serverConnect.local
class Translations$serverConnect$local$ja extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'このデバイス';
	@override String get subtitle => 'このマシンでDDAgentサーバーを実行します';
	@override String get install => 'ローカルサーバーをインストール';
	@override String get start => 'ローカルサーバーを起動';
	@override String get stop => '停止';
	@override String get starting => 'ローカルサーバーを起動中…';
	@override String downloading({required Object percent}) => 'サーバーをダウンロード中… ${percent}%';
	@override String get installing => 'インストール中…';
	@override String running({required Object url}) => '${url} で実行中';
	@override String installed({required Object version}) => 'インストール済み (v${version})';
	@override String get connect => 'このサーバーを使用';
	@override String error({required Object error}) => 'ローカルサーバーエラー: ${error}';
	@override String get or => 'またはリモートサーバーに接続';
	@override late final Translations$serverConnect$local$errors$ja errors = Translations$serverConnect$local$errors$ja._(_root);
}

// Path: sessions.toasts
class Translations$sessions$toasts$ja extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get archived => 'セッションをアーカイブしました';
	@override String get restored => 'セッションを復元しました';
	@override String get deleted => 'セッションを削除しました';
	@override String get renamed => 'セッション名を変更しました';
	@override String get pinned => 'セッションをピン留めしました';
	@override String get unpinned => 'セッションのピン留めを解除しました';
	@override String get workspaceChanged => 'ワークスペースを変更しました';
}

// Path: sessions.age
class Translations$sessions$age$ja extends Translations$sessions$age$en {
	Translations$sessions$age$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get lessThanMinute => '1分未満';
	@override String minutes({required Object count}) => '${count}分';
	@override String hours({required Object hours}) => '${hours}時間';
	@override String days({required Object days}) => '${days}日';
}

// Path: sessions.activity
class Translations$sessions$activity$ja extends Translations$sessions$activity$en {
	Translations$sessions$activity$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get subagentRunning => 'サブエージェントを実行中';
	@override String readingFile({required Object file}) => '${file} を読み取り中';
	@override String runningTool({required Object name}) => '${name} を実行中';
	@override String editingFile({required Object file}) => '${file} を編集中';
	@override String get editingFileGeneric => 'ファイルを編集中';
	@override String get runningShellCommand => 'シェルコマンドを実行中';
	@override String runningCommand({required Object command}) => '`${command}` を実行中';
	@override String get committingChanges => '変更をコミット中';
	@override String get pushingBranch => 'ブランチをプッシュ中';
	@override String fetchingUrl({required Object url}) => '${url} を取得中';
	@override String searching({required Object query}) => '“${query}” を検索中';
}

// Path: skills.addDialog
class Translations$skills$addDialog$ja extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => '${provider} スキルを追加';
	@override String get chooseFileTitle => 'SKILL.mdを選択';
	@override String get chooseFolderTitle => 'スキルフォルダを選択';
	@override String get uploadHint => 'SKILL.mdファイルまたは完全なスキルフォルダをアップロードしてください。';
	@override String get pickTitle => 'スキルフォルダまたはSKILL.mdを選択';
	@override String get pickHint => 'フォルダにはスクリプト、参照、アセットを含めることができます。';
	@override String get chooseFiles => 'ファイルを選択';
	@override String get chooseFolder => 'フォルダを選択';
	@override String get readyToInstall => 'インストールの準備完了';
	@override String markdownFileMeta({required Object size}) => 'Markdownファイル · ${size}';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} ファイル · ${size}',
		other: '${count} ファイル · ${size}',
	);
	@override String removeQueued({required Object name}) => '${name} を削除';
	@override String get whereWillThisInstall => 'どこにインストールされますか？';
	@override String get hideInstallLocation => 'インストール先を非表示';
	@override String get folderUploadsNote => 'フォルダをアップロードした場合は選択したフォルダ名が保持されます。単体ファイルの場合は `SKILL.md` の `name` が使用されます。';
	@override String get installSkill => 'スキルをインストール';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 件のスキルをインストール',
		other: '${count} 件のスキルをインストール',
	);
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$ja extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get toProjectHint => 'このスキルを所有するプロジェクトを選択してください。プロバイダーのグローバルスキルディレクトリから移動します。';
	@override String get toGlobalHint => 'このスキルをグローバルスキルディレクトリに移動し、すべてのプロジェクトで使用できるようにします。';
	@override String get moveToProject => 'プロジェクトに移動';
	@override String get moveToGlobal => 'グローバルに移動';
}

// Path: skills.screen
class Translations$skills$screen$ja extends Translations$skills$screen$en {
	Translations$skills$screen$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String manageDescription({required Object provider}) => 'ローカルファイル、フォルダ全体、プロジェクト対応の場所から ${provider} スキルを管理します。';
	@override String get searchHint => 'スキルを検索...';
	@override String get clearSearch => 'スキル検索をクリア';
	@override String get addSkill => 'スキルを追加';
	@override String get scanningProjectSkills => 'プロジェクトのスキルをスキャン中...';
	@override String get savedSuccessfully => 'スキルを保存しました。';
	@override String loadingSkills({required Object provider}) => '${provider} のスキルを読み込み中…';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} スキル',
		other: '${count} スキル',
	);
	@override String deleteTitle({required Object name}) => '${name} を削除しますか？';
	@override String deleteDescription({required Object provider, required Object directory}) => '${provider} の管理対象スキルディレクトリから ${directory} ディレクトリを削除します。元に戻せません。';
	@override String get noDescription => 'スキルのフロントマターに説明がありません。';
	@override String pluginBadge({required Object name}) => 'プラグイン: ${name}';
	@override String projectBadge({required Object name}) => 'プロジェクト: ${name}';
	@override String get sourceLabel => 'ソース';
}

// Path: skills.empty
class Translations$skills$empty$ja extends Translations$skills$empty$en {
	Translations$skills$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get noProjects => '利用可能なプロジェクトがありません';
	@override String get noProjectsDescription => 'プロジェクトまたはワークスペースを追加すると、そのスキルを参照できます。';
	@override String get noSkillsInProject => 'このプロジェクトにスキルがありません';
	@override String get noSkillsInProjectDescription => '選択したプロジェクトに .claude/skills、.cursor/skills、または .agents/skills フォルダを作成してください。';
	@override String get noGlobalSkills => 'グローバルスキルはまだ見つかっていません';
	@override String get noGlobalSkillsDescription => '上でグローバルスキルを追加すると、すべてのプロジェクトで利用できるようになります。';
	@override String get noMatchingSkills => '一致するスキルがありません';
	@override String get noMatchingSkillsDescription => '別のコマンド、名前、スコープ、プロジェクト、ソースパスをお試しください。';
}

// Path: skills.scopes
class Translations$skills$scopes$ja extends Translations$skills$scopes$en {
	Translations$skills$scopes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get user => 'ユーザー';
	@override String get plugin => 'プラグイン';
	@override String get repo => 'リポジトリ';
	@override String get project => 'プロジェクト';
	@override String get admin => '管理者';
	@override String get system => 'システム';
}

// Path: skills.errors
class Translations$skills$errors$ja extends Translations$skills$errors$en {
	Translations$skills$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dropMarkdownOrFolder => '1つ以上のMarkdownファイル、またはSKILL.mdを含むフォルダをドロップしてください。';
	@override String get addMarkdownFirst => '先に1つ以上のMarkdownファイルを追加してください。';
	@override String get importFailed => 'スキルのインポートに失敗しました';
	@override String get folderReadFailed => 'スキルフォルダの読み取りに失敗しました';
	@override String folderFileLimit({required Object count}) => 'スキルフォルダには最大 ${count} 個のファイルを含めることができます。';
	@override String get folderSizeLimit => '選択したスキルフォルダの合計サイズは30 MB未満である必要があります。';
	@override String get missingSkillFile => '選択したフォルダに SKILL.md ファイルが含まれていません。';
	@override String couldNotReadSkillFile({required Object name}) => '${name} から SKILL.md を読み取れませんでした。';
}

// Path: terminal.tabs
class Translations$terminal$tabs$ja extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String shellName({required Object index}) => 'シェル ${index}';
	@override String get plainShell => '通常のシェル';
	@override String get claudeCli => 'Claude CLI';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => 'ログイン: ${provider}';
	@override String runTitle({required Object command}) => '実行: ${command}';
}

// Path: terminal.actions
class Translations$terminal$actions$ja extends Translations$terminal$actions$en {
	Translations$terminal$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newTab => '新しいターミナルタブ';
	@override String get providerLogin => 'プロバイダーログイン';
	@override String get restartSession => 'セッションを再起動';
	@override String get clearOutput => '出力をクリア';
	@override String get newShell => '新しいシェル';
	@override String get connect => '接続';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$ja extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => 'ブラウザで開く';
	@override String linkLabel({required Object url}) => '認証リンク: ${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$ja extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => 'ファイルを検出: ${path}';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$ja extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get interrupt => '中断 (SIGINT)';
	@override String get eof => 'EOF';
	@override String get suspend => '一時停止 (SIGTSTP)';
	@override String get hide => 'ショートカットバーを非表示';
	@override String get showTooltip => 'ショートカットを表示';
	@override String get hideTooltip => 'ショートカットを非表示';
}

// Path: terminal.paste
class Translations$terminal$paste$ja extends Translations$terminal$paste$en {
	Translations$terminal$paste$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ターミナルに貼り付け';
	@override String get hint => 'Ctrl+V / 右クリック → 貼り付け';
}

// Path: terminal.errors
class Translations$terminal$errors$ja extends Translations$terminal$errors$en {
	Translations$terminal$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => 'リンクを開けませんでした: ${url}';
	@override String frameError({required Object message}) => '[エラー] ${message}';
	@override String connectionError({required Object message}) => '[接続エラー] ${message}';
}

// Path: terminal.loginDialog
class Translations$terminal$loginDialog$ja extends Translations$terminal$loginDialog$en {
	Translations$terminal$loginDialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => '${provider} CLI ログイン';
	@override String exited({required Object code}) => '終了 (${code})';
	@override String get authLinkDetected => '認証リンクを検出しました';
}

// Path: terminal.empty
class Translations$terminal$empty$ja extends Translations$terminal$empty$en {
	Translations$terminal$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アクティブなターミナルがありません';
	@override String get description => '新しいタブを作成して開始してください';
}

// Path: terminal.overlay
class Translations$terminal$overlay$ja extends Translations$terminal$overlay$en {
	Translations$terminal$overlay$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get processExited => 'プロセスが終了しました — 接続すると再起動します';
	@override String processExitedWithCode({required Object code}) => 'プロセスが終了しました（コード ${code}）— 接続すると再起動します';
	@override String resumeSession({required Object title}) => 'セッション ${title} を再開';
	@override String startSession({required Object path}) => '${path} で新しいセッションを開始';
}

// Path: workspace.paneTitle
class Translations$workspace$paneTitle$ja extends Translations$workspace$paneTitle$en {
	Translations$workspace$paneTitle$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get chat => 'チャット';
	@override String get browser => 'ブラウザ';
	@override String get terminal => 'ターミナル';
	@override String get notes => '共有メモ';
	@override String get editor => 'エディター';
	@override String get git => 'Git';
}

// Path: worktrees.runtimeStatus
class Translations$worktrees$runtimeStatus$ja extends Translations$worktrees$runtimeStatus$en {
	Translations$worktrees$runtimeStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get idle => '待機中';
	@override String get running => '実行中';
	@override String get done => '完了';
	@override String get failed => '失敗';
	@override String get exited => '終了';
}

// Path: browserUse.sessionStatus
class Translations$browserUse$sessionStatus$ja extends Translations$browserUse$sessionStatus$en {
	Translations$browserUse$sessionStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get ready => '準備完了';
	@override String get stopped => '停止';
	@override String get unavailable => '利用不可';
}

// Path: miniOrchestrator.taskTypes
class Translations$miniOrchestrator$taskTypes$ja extends Translations$miniOrchestrator$taskTypes$en {
	Translations$miniOrchestrator$taskTypes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get gate => 'ゲート';
}

// Path: miniOrchestrator.roles
class Translations$miniOrchestrator$roles$ja extends Translations$miniOrchestrator$roles$en {
	Translations$miniOrchestrator$roles$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get thinker => 'シンカー';
	@override String get worker => 'ワーカー';
}

// Path: auth.login.errors
class Translations$auth$login$errors$ja extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => 'ユーザー名またはパスワードが正しくありません';
	@override String get requiredFields => 'すべての項目を入力してください';
	@override String get networkError => 'ネットワークエラー。もう一度お試しください。';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$ja extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get username => 'ユーザー名を入力';
	@override String get password => 'パスワードを入力';
}

// Path: auth.register.errors
class Translations$auth$register$errors$ja extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => 'パスワードが一致しません';
	@override String get usernameTaken => 'このユーザー名は既に使用されています';
	@override String get weakPassword => 'パスワードが弱すぎます';
	@override String get usernameTooShort => 'ユーザー名は3文字以上で入力してください';
	@override String get passwordTooShort => 'パスワードは6文字以上で入力してください';
}

// Path: chat.orchestrator.routing
class Translations$chat$orchestrator$routing$ja extends Translations$chat$orchestrator$routing$en {
	Translations$chat$orchestrator$routing$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ルーティング';
	@override String alternatives({required Object list}) => '代替候補: ${list}';
	@override String first({required Object label, required Object task}) => '${label} — ${task} の第一候補';
	@override String skipped({required Object label, required Object list}) => '${label} — 先行候補をスキップ (${list})';
}

// Path: chat.orchestrator.plan
class Translations$chat$orchestrator$plan$ja extends Translations$chat$orchestrator$plan$en {
	Translations$chat$orchestrator$plan$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プラン';
	@override String get disabled => '無効';
	@override String get awaitingConfirm => 'プランの確認を待っています。';
	@override String get run => 'プランを実行';
	@override String get toggleStep => 'ステップを有効化';
	@override String get confirmFailed => '開始できませんでした — もう一度お試しください。';
	@override String get fallback => 'プランナーを利用できません — 単一ステップにフォールバック';
	@override String get templateSource => 'パイプラインテンプレートから';
	@override String get offSource => 'プランナー無効';
	@override String stepCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} ステップ',
		other: '${count} ステップ',
	);
	@override String get supervisedSource => '監督付きループ';
}

// Path: chat.orchestrator.decision
class Translations$chat$orchestrator$decision$ja extends Translations$chat$orchestrator$decision$en {
	Translations$chat$orchestrator$decision$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'スーパーバイザーの判断';
	@override String iteration({required Object n}) => '反復 ${n}';
	@override String get rationaleLabel => '理由';
	@override String get awaitingConfirm => 'これらのステップを実行する前に承認を待っています。';
	@override String get proposedSteps => '提案されたステップ';
	@override late final Translations$chat$orchestrator$decision$action$ja action = Translations$chat$orchestrator$decision$action$ja._(_root);
	@override late final Translations$chat$orchestrator$decision$outcome$ja outcome = Translations$chat$orchestrator$decision$outcome$ja._(_root);
}

// Path: chat.orchestrator.delegation
class Translations$chat$orchestrator$delegation$ja extends Translations$chat$orchestrator$delegation$en {
	Translations$chat$orchestrator$delegation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '委任されたステップ';
	@override String get openSession => 'セッション全体を開く';
	@override String attempt({required Object n}) => '試行 ${n}';
	@override String get retryStep => '再試行 / 修正';
	@override String get continueStep => '続行 / 修正';
	@override String get continueFailed => '失敗しました — もう一度お試しください。';
	@override late final Translations$chat$orchestrator$delegation$status$ja status = Translations$chat$orchestrator$delegation$status$ja._(_root);
	@override String attempts({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '${count} 回試行',
		other: '${count} 回試行',
	);
	@override String candidates({required Object list}) => '候補: ${list}';
	@override String candidateCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '候補 ${count} 件',
		other: '候補 ${count} 件',
	);
}

// Path: chat.orchestrator.summary
class Translations$chat$orchestrator$summary$ja extends Translations$chat$orchestrator$summary$en {
	Translations$chat$orchestrator$summary$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '概要';
	@override String progress({required Object done, required Object total}) => '完了したステップ: ${done}/${total}';
	@override String get aborted => '中止';
	@override String get timedOut => 'タイムアウト';
	@override String get capped => '反復上限';
	@override String failed({required Object list}) => '失敗したステップ: ${list}';
	@override String get kContinue => '続行';
	@override String get continueWork => '作業を続行';
	@override String get resumeFailed => '再開できませんでした — もう一度お試しください。';
	@override String get runNextTask => '次のタスクを実行';
	@override String get endAllTasks => 'すべてのタスクを終了';
	@override String get tasksRunning => 'タスクを処理中…';
	@override String get cancelTasks => 'キャンセル';
}

// Path: chat.orchestrator.taskmaster
class Translations$chat$orchestrator$taskmaster$ja extends Translations$chat$orchestrator$taskmaster$en {
	Translations$chat$orchestrator$taskmaster$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスクキュー';
	@override String remaining({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		one: '残り ${count} 件',
		other: '残り ${count} 件',
	);
	@override late final Translations$chat$orchestrator$taskmaster$status$ja status = Translations$chat$orchestrator$taskmaster$status$ja._(_root);
}

// Path: chat.orchestrator.gate
class Translations$chat$orchestrator$gate$ja extends Translations$chat$orchestrator$gate$en {
	Translations$chat$orchestrator$gate$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'タイムアウト';
	@override String exit({required Object code}) => '終了コード ${code}';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$ja extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'デフォルトモード';
	@override String get auto => '自動モード';
	@override String get acceptEdits => '編集を許可';
	@override String get bypassPermissions => '権限をバイパス';
	@override String get plan => 'プランモード';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$ja extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '信頼されたコマンド（ls、cat、grep、git statusなど）のみ自動実行。その他のコマンドはスキップ。ワークスペースへの書き込みは可能。';
	@override String get auto => 'モデル分類器がツール呼び出しごとに承認または拒否を決定します。高い自律性。';
	@override String get acceptEdits => 'ワークスペース内ですべてのコマンドを自動実行。サンドボックス環境での完全自動モード。';
	@override String get bypassPermissions => '制限なしの完全なシステムアクセス。すべてのコマンドがディスクとネットワークへの完全なアクセスで自動実行されます。注意して使用してください。';
	@override String get plan => 'プランニングモード - コマンドは実行されません';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$ja extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enterで送信 • / コマンド • @ ファイル';
	@override String get enter => 'Enterで送信 • Shift+Enterで改行 • / コマンド • @ ファイル';
	@override String get queue => 'Enterで次のメッセージをキューに入れる';
	@override String get updateQueued => 'Enterでキュー済みメッセージを更新';
}

// Path: chat.input.queue
class Translations$chat$input$queue$ja extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get sendNext => '次のメッセージをキューに入れる';
	@override String get update => 'キュー済みメッセージを更新';
	@override String get label => 'キュー済み';
	@override String get willSend => '完了後に送信されます';
	@override String get edit => 'キュー済みメッセージを編集';
	@override String get delete => 'キュー済みメッセージを削除';
	@override String get failed => '送信に失敗しました';
	@override String get sendNow => '今すぐ送信';
	@override String get sendNowAfterTurn => 'このエージェントはターン中にメッセージを受け付けません。現在のターンの終了後に送信されます';
	@override String filesAttached({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count,
		other: '${count} 件のファイルを添付',
	);
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$ja extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get clear => 'キャンセルしてオフラインキューをクリア';
	@override String get clearBtn => 'キャンセル';
	@override String multiple({required Object count}) => '${count} 件のメッセージがオフラインキューに — 再接続時に自動送信されます';
	@override String get single => '1 件のメッセージがオフラインキューに — 再接続時に自動送信されます';
}

// Path: chat.composer.effortLevels
class Translations$chat$composer$effortLevels$ja extends Translations$chat$composer$effortLevels$en {
	Translations$chat$composer$effortLevels$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get off => 'オフ';
	@override String get none => 'なし';
	@override String get minimal => '最小';
	@override String get low => '低';
	@override String get medium => '中';
	@override String get high => '高';
	@override String get xhigh => '非常に高い';
	@override String get max => '最大';
	@override String get ultra => 'ウルトラ';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$ja extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get anthropic => 'by Anthropic';
	@override String get openai => 'by OpenAI';
	@override String get cursorEditor => 'AIコードエディタ';
	@override String get google => 'by Google';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$ja extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => '${model}でClaudeを使用する準備ができました。下にメッセージを入力してください。';
	@override String cursor({required Object model}) => '${model}でCursorを使用する準備ができました。下にメッセージを入力してください。';
	@override String codex({required Object model}) => '${model}でCodexを使用する準備ができました。下にメッセージを入力してください。';
	@override String opencode({required Object model}) => '${model} で OpenCode を使用できます。下にメッセージを入力してください。';
	@override String get kDefault => '上からプロバイダーを選択して開始してください';
	@override String devin({required Object model}) => 'Devin ${model} の準備完了';
	@override String get orchestrator => 'Auto で準備完了 — ルーターがステップごとに最適なモデルを選びます';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$ja extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '会話を続ける';
	@override String get description => 'コードについて質問したり、変更をリクエストしたり、開発タスクのサポートを受けられます';
	@override String get action => '入力を続ける';
}

// Path: chat.session.loading
class Translations$chat$session$loading$ja extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => '過去のメッセージを読み込んでいます...';
	@override String get sessionMessages => 'セッションメッセージを読み込んでいます...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$ja extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object total, required Object shown}) => '${total}件中${shown}件を表示';
	@override String get scrollToLoad => '上にスクロールしてさらに読み込む';
	@override String showingLast({required Object count, required Object total}) => '最新${count}件を表示（全${total}件）';
	@override String get loadEarlier => '過去のメッセージを読み込む';
	@override String get loadOlderFailed => '古いメッセージの読み込みに失敗しました。';
	@override String get retry => '再試行';
	@override String get loadAll => 'すべてのメッセージを読み込む';
	@override String get loadingAll => 'すべてのメッセージを読み込み中...';
	@override String get allLoaded => 'すべてのメッセージを読み込みました';
	@override String get perfWarning => 'すべてのメッセージを読み込みました — スクロールが遅くなる場合があります。「一番下へスクロール」をクリックしてください。';
	@override String get noSearchMatches => '検索に一致するメッセージがありません。';
	@override String get loadOlder => '過去のメッセージを読み込む';
	@override String loadAllCount({required Object count}) => 'すべて読み込む (${count})';
	@override String retryLoadOlder({required Object error}) => '過去のメッセージの読み込みを再試行 — ${error}';
}

// Path: chat.session.missing
class Translations$chat$session$missing$ja extends Translations$chat$session$missing$en {
	Translations$chat$session$missing$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get message => 'このセッションは接続中のサーバーに存在しません。';
	@override String get action => '別のセッションを選択';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$ja extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プロジェクトを選択';
	@override String get description => 'プロジェクトを選択してそのディレクトリでシェルを開きます';
}

// Path: chat.shell.status
class Translations$chat$shell$status$ja extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get newSession => '新しいセッション';
	@override String get initializing => '初期化中...';
	@override String get restarting => '再起動中...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$ja extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get disconnect => '切断';
	@override String get disconnectTitle => 'シェルから切断';
	@override String get restart => '再起動';
	@override String get restartTitle => 'シェルを再起動（先に切断してください）';
	@override String get kill => '終了 (SIGINT)';
	@override String get killTitle => '実行中のプロセスを終了 (Ctrl+C)';
	@override String get copyOutput => '出力をコピー';
	@override String get copyOutputTitle => 'ターミナル出力をコピー';
	@override String get copied => 'コピーしました！';
	@override String get zoomInTitle => '拡大';
	@override String get zoomOutTitle => '縮小';
	@override String get connect => 'シェルで続行';
	@override String get connectTitle => 'シェルに接続';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$ja extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get thinking => '思考中';
	@override String get processing => '処理中';
	@override String get analyzing => '分析中';
	@override String get working => '作業中';
	@override String get computing => '計算中';
	@override String get reasoning => '推論中';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$ja extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get live => 'ライブ';
	@override String get paused => '一時停止';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$ja extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}秒';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '経過 ${time}';
	@override String get startingNow => '今開始';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$ja extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => '生成を停止';
	@override String get pressEscToStop => 'Escキーでいつでも停止';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$ja extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get assistant => 'アシスタント';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$ja extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get models => 'アクティブなプロバイダーで利用可能なモデルを参照します。';
	@override String get cost => 'アクティブなセッションのトークン使用量を確認します。';
	@override String get status => 'ランタイム、バージョン、プロバイダー、環境のステータスを確認します。';
	@override String get memory => 'プロジェクトのCLAUDE.mdメモリファイルを開きます。';
	@override String get config => '設定と構成を開きます。';
	@override String get help => 'コマンドのドキュメントと構文を表示します。';
}

// Path: chat.permissionRequest.recap
class Translations$chat$permissionRequest$recap$ja extends Translations$chat$permissionRequest$recap$en {
	Translations$chat$permissionRequest$recap$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get timedOut => 'タイムアウト — 自動的に拒否されました';
	@override String get cancelled => 'キャンセル — ターンが停止されました';
	@override String get autoApproved => '自動的に承認されました';
	@override String get expired => 'リクエストの有効期限切れ — エージェントはもう待機していません';
	@override String get answered => '回答済み';
	@override String get skipped => 'スキップ済み';
	@override String get decided => '決定済み';
}

// Path: chat.commandDialog.help
class Translations$chat$commandDialog$help$ja extends Translations$chat$commandDialog$help$en {
	Translations$chat$commandDialog$help$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'コマンドセンター';
	@override String get title => 'ヘルプとショートカット';
	@override String get subtitle => '組み込みコマンド、構文パターン、使い方を検索します。';
}

// Path: chat.commandDialog.models
class Translations$chat$commandDialog$models$ja extends Translations$chat$commandDialog$models$en {
	Translations$chat$commandDialog$models$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'モデルの選択';
	@override String get title => 'モデルを選択';
	@override String get subtitle => 'このプロバイダーで使用するモデルを選択します。';
	@override String modelSetTo({required Object model}) => 'モデルを ${model} に設定しました。';
	@override String get activeModel => '使用中のモデル';
	@override String get noModelsMatch => 'このフィルターに一致するモデルはありません。';
	@override String get choiceSavedForSession => '選択はこのセッションに保存され、新しいチャットの既定になります。';
	@override String get choiceDefault => '選択したモデルが新しいチャットの既定になります。';
	@override String get custom => 'カスタム';
	@override String get currentSelection => '現在の選択';
}

// Path: chat.commandDialog.cost
class Translations$chat$commandDialog$cost$ja extends Translations$chat$commandDialog$cost$en {
	Translations$chat$commandDialog$cost$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'セッションのテレメトリ';
	@override String get title => 'トークン使用量';
	@override String get subtitle => 'このセッションの入力・出力・合計トークン数。';
	@override String get totalTokensUsed => '使用トークン合計';
	@override String get inputTokens => '入力トークン';
	@override String get cacheReadTokens => 'キャッシュ読み取りトークン';
	@override String get cacheWriteTokens => 'キャッシュ書き込みトークン';
	@override String get outputTokens => '出力トークン';
	@override String get breakdown => '内訳';
	@override String get unavailable => '利用不可';
	@override String get contextWindow => 'コンテキストウィンドウ';
	@override String get estimatedCost => '推定コスト';
}

// Path: chat.commandDialog.status
class Translations$chat$commandDialog$status$ja extends Translations$chat$commandDialog$status$en {
	Translations$chat$commandDialog$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'ランタイムの状態';
	@override String get title => 'システムの状態';
	@override String get subtitle => 'バージョン、プロバイダー、ランタイム、環境の詳細。';
	@override String get package => 'パッケージ';
	@override String get uptime => '稼働時間';
	@override String get platform => 'プラットフォーム';
	@override String get memory => 'メモリ';
	@override String memoryRss({required Object mb}) => '${mb} MB RSS';
	@override String get runtimeOnline => 'ランタイムはオンラインです';
	@override String processResponding({required Object pid}) => 'プロセス #${pid} は応答しています。';
	@override String get processStatusResponding => 'プロセスは応答しています。';
	@override String get healthy => '正常';
}

// Path: chat.commandDialog.syntax
class Translations$chat$commandDialog$syntax$ja extends Translations$chat$commandDialog$syntax$en {
	Translations$chat$commandDialog$syntax$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '構文';
	@override String arguments({required Object arguments, required Object first, required Object second}) => '${arguments} はすべての引数を渡します。${first}、${second} は位置引数です。';
	@override String file({required Object token}) => '${token} はファイルの内容を含めます。';
	@override String bash({required Object token}) => '${token} は bash を実行します。';
}

// Path: chat.utilities.tooltip
class Translations$chat$utilities$tooltip$ja extends Translations$chat$utilities$tooltip$en {
	Translations$chat$utilities$tooltip$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String tokensUsed({required Object tokens}) => '${tokens} トークン使用';
	@override String contextOf({required Object total, required Object percent}) => 'コンテキスト ${total} 中 ${percent}%';
	@override String input({required Object value}) => '入力 ${value}';
	@override String cache({required Object read, required Object write}) => 'キャッシュ読み取り ${read} · 書き込み ${write}';
	@override String output({required Object value}) => '出力 ${value}';
}

// Path: chat.toolBlocks.status
class Translations$chat$toolBlocks$status$ja extends Translations$chat$toolBlocks$status$en {
	Translations$chat$toolBlocks$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get running => '実行中';
	@override String get denied => '拒否';
}

// Path: chat.toolBlocks.verbs
class Translations$chat$toolBlocks$verbs$ja extends Translations$chat$toolBlocks$verbs$en {
	Translations$chat$toolBlocks$verbs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get read => '読み取り';
	@override String get write => '書き込み';
	@override String get edit => '編集';
	@override String get delete => '削除';
	@override String get move => '移動';
}

// Path: chat.commandMenu.namespaces
class Translations$chat$commandMenu$namespaces$ja extends Translations$chat$commandMenu$namespaces$en {
	Translations$chat$commandMenu$namespaces$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get frequent => 'よく使うコマンド';
	@override String get builtin => '組み込みコマンド';
	@override String get skill => 'スキル';
	@override String get project => 'プロジェクトコマンド';
	@override String get user => 'ユーザーコマンド';
	@override String get other => 'その他のコマンド';
}

// Path: chat.mentionMenu.kinds
class Translations$chat$mentionMenu$kinds$ja extends Translations$chat$mentionMenu$kinds$en {
	Translations$chat$mentionMenu$kinds$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get file => 'ファイル';
	@override String get session => 'セッション';
	@override String get task => 'タスク';
}

// Path: common.quota.section
class Translations$common$quota$section$ja extends Translations$common$quota$section$en {
	Translations$common$quota$section$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get overview => '概要';
	@override String get quotas => 'クォータ';
	@override String get usage => '使用量';
	@override String get agents => 'エージェント';
}

// Path: common.quota.filter
class Translations$common$quota$filter$ja extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get all => 'すべて';
}

// Path: common.quota.period
class Translations$common$quota$period$ja extends Translations$common$quota$period$en {
	Translations$common$quota$period$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7日';
	@override String get k30d => '30日';
	@override String get all => 'すべて';
}

// Path: common.quota.group
class Translations$common$quota$group$ja extends Translations$common$quota$group$en {
	Translations$common$quota$group$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get provider => 'プロバイダー';
	@override String get model => 'モデル';
	@override String get agent => 'エージェント';
	@override String get tool => 'ツール';
}

// Path: common.quota.metric
class Translations$common$quota$metric$ja extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get tokens => 'トークン';
	@override String get input => '入力';
	@override String get output => '出力';
	@override String get cache => 'キャッシュ読み取り';
	@override String get calls => 'API 呼び出し';
	@override String get cost => 'コスト';
	@override String get sessions => 'セッション';
}

// Path: common.quota.cost
class Translations$common$quota$cost$ja extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get billed => '請求済み (API + 超過分)';
	@override String get listPrice => '使用トークンの定価';
	@override String get subscriptionValue => 'サブスクリプションで充当';
	@override String get cacheSavings => 'キャッシュ節約';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$ja extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get billed => '請求済み (API + 超過分)';
	@override String get listPrice => '使用トークンの定価';
	@override String get subscriptionValue => 'サブスクリプションで充当';
}

// Path: common.quota.overview
class Translations$common$quota$overview$ja extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => 'トークンとコスト — 過去7日間';
	@override String get effectiveCost => '実質コスト (7日間)';
	@override String get alertsTitle => 'アラート';
	@override String get noAlerts => '現在注意が必要なものはありません。';
	@override String get limitsTitle => '使用量と上限';
	@override String get activeTasks => 'アクティブなタスク';
	@override String get viewAccounts => 'すべてのアカウント';
	@override String get viewAgents => 'すべてのエージェント';
	@override String get noTasks => '現在実行中のエージェントはいません。';
}

// Path: common.quota.usage
class Translations$common$quota$usage$ja extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '日次トレンド';
	@override String breakdownTitle({required Object group}) => '${group} 別の内訳';
	@override String get colName => '名前';
	@override String get sourceUnavailable => '分析ストアが利用できません。データを表示していません。';
}

// Path: common.quota.agents
class Translations$common$quota$agents$ja extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} 件実行中';
	@override String get colAgent => 'エージェント';
	@override String get colStatus => 'ステータス';
	@override String get colTask => 'タスク';
	@override String get colModel => 'アカウント / モデル';
	@override String get colTime => '時刻';
	@override String get empty => 'このフィルターに一致するエージェントがいません。';
	@override String get detailSession => 'セッション';
	@override String get detailStarted => '開始';
	@override String get detailRetries => 'リトライ';
	@override String get detailResult => '結果';
	@override String get notTracked => '未追跡';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$ja extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get running => '実行中';
	@override String get waiting => '待機中';
	@override String get failed => '失敗';
	@override String get finished => '完了';
	@override String get queued => 'キュー待ち';
}

// Path: common.quota.alert
class Translations$common$quota$alert$ja extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}: 現在のペースでは ${value} で上限に達します';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% 使用 (しきい値 ${watch}%)';
}

// Path: common.quota.quality
class Translations$common$quota$quality$ja extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get live => 'ライブ';
	@override String get cached => 'キャッシュ';
	@override String get estimate => '推定';
	@override String get unknown => '不明';
	@override String get error => 'エラー';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$ja extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get atRisk => '危険な上限';
	@override String atRiskHint({required Object value}) => '${value}% 超のアカウント';
	@override String get windowsAtRisk => '残り少ないウィンドウ';
	@override String get errored => '同期エラー';
	@override String get activeAgents => 'アクティブなエージェント';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} 待機 · ${queued} キュー';
	@override String get nextReset => '次回リセット';
	@override String get tokens => 'トークン';
	@override String sessionsHint({required Object value}) => '${value} セッション';
	@override String get cost => '推定コスト';
	@override String costHint({required Object value}) => '${value} がプランで充当';
}

// Path: common.quota.empty
class Translations$common$quota$empty$ja extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '接続されたアカウントがありません';
	@override String get description => 'Claude、Codex、Gemini、CommandCode にサインインするとクォータをここで追跡できます。';
}

// Path: common.quota.settings
class Translations$common$quota$settings$ja extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アラートとルーティング';
	@override String get description => 'ダッシュボードが警告するタイミングと、新しい作業にアカウントを提案する方法を制御します。';
	@override String get alertsEnabled => '予測アラートとしきい値アラート';
	@override String get alertsEnabledHint => '90% になってからではなく、現在のペースで上限が尽きる前に警告します。';
	@override String get watchThreshold => '監視しきい値 (%)';
	@override String get dangerThreshold => '危険しきい値 (%)';
	@override String get routingMode => 'ルーティング';
	@override late final Translations$common$quota$settings$routing$ja routing = Translations$common$quota$settings$routing$ja._(_root);
	@override String get logSources => 'ログソース';
	@override String get logSourcesHint => '使用量とエージェント画面はこれらの読み取り専用ソースを参照します。';
	@override String get quotaConsent => 'クォータのポーリングを許可';
	@override String get quotaConsentHint => '保存済みの認証情報でプロバイダーのエンドポイントをポーリングしてライブ上限を読み取ります。';
	@override String get perAccount => 'アカウントごとの上書き';
	@override String get tab => 'Control Center 設定';
}

// Path: common.quota.range
class Translations$common$quota$range$ja extends Translations$common$quota$range$en {
	Translations$common$quota$range$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => 'すべて';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$ja extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get rename => '名前を変更';
	@override String get delete => '削除';
	@override String get copyPath => 'パスをコピー';
	@override String get download => 'ダウンロード';
	@override String get newFile => '新しいファイル';
	@override String get newFolder => '新しいフォルダ';
	@override String get upload => 'ファイルをアップロード';
	@override String get refresh => '更新';
	@override String get menuLabel => 'ファイルのコンテキストメニュー';
	@override String get loading => '読み込み中...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$ja extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get confirm => '削除';
	@override String get fileWarning => 'このファイルは完全に削除されます。';
	@override String get folderWarning => 'このフォルダとそのすべての内容は完全に削除されます。';
	@override String title({required Object type}) => '${type} を削除';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$ja extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => 'パスのコピーに失敗しました';
	@override String get fileCreated => 'ファイルを作成しました';
	@override String get fileDeleted => 'ファイルを削除しました';
	@override String get folderCreated => 'フォルダを作成しました';
	@override String get folderDeleted => 'フォルダを削除しました';
	@override String get folderDownloaded => 'フォルダをZIPとしてダウンロードしました';
	@override String get pathCopied => 'パスをクリップボードにコピーしました';
	@override String get renamed => '名前を変更しました';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$ja extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => 'ファイル名はドットのみにはできません';
	@override String get emptyName => 'ファイル名は空にできません';
	@override String get invalidChars => 'ファイル名に無効な文字が含まれています';
	@override String get reserved => 'ファイル名は予約語です';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$ja extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get type => '種類';
	@override String get configure => '設定';
	@override String get confirm => '確認';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$ja extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get question => '既存のワークスペースがありますか？それとも新しく作成しますか？';
	@override late final Translations$common$projectWizard$step1$existing$ja existing = Translations$common$projectWizard$step1$existing$ja._(_root);
	@override late final Translations$common$projectWizard$step1$kNew$ja kNew = Translations$common$projectWizard$step1$kNew$ja._(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$ja extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get existingPath => 'ワークスペースのパス';
	@override String get newPath => 'ワークスペースのパス';
	@override String get existingPlaceholder => '/path/to/existing/workspace';
	@override String get newPlaceholder => '/path/to/new/workspace';
	@override String get existingHelp => '既存のワークスペースディレクトリのフルパス';
	@override String get newHelp => 'ワークスペースディレクトリのフルパス';
	@override String get githubUrl => 'GitHub URL（任意）';
	@override String get githubPlaceholder => 'https://github.com/username/repository';
	@override String get githubHelp => '任意: リポジトリをクローンするためのGitHub URLを入力してください';
	@override String get githubAuth => 'GitHub認証（任意）';
	@override String get githubAuthHelp => 'プライベートリポジトリの場合のみ必要です。パブリックリポジトリは認証なしでクローンできます。';
	@override String get loadingTokens => '保存済みトークンを読み込んでいます...';
	@override String get storedToken => '保存済みトークン';
	@override String get newToken => '新しいトークン';
	@override String get nonePublic => 'なし（パブリック）';
	@override String get selectToken => 'トークンを選択';
	@override String get selectTokenPlaceholder => '-- トークンを選択 --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => 'このトークンはこの操作にのみ使用されます';
	@override String get publicRepoInfo => 'パブリックリポジトリには認証は不要です。パブリックリポジトリをクローンする場合、トークンは省略できます。';
	@override String get noTokensHelp => '保存済みトークンがありません。設定 → APIキーでトークンを追加すると再利用が簡単になります。';
	@override String get optionalTokenPublic => 'GitHubトークン（パブリックリポジトリの場合は任意）';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx（パブリックリポジトリの場合は空欄可）';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$ja extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => '設定の確認';
	@override String get existingWorkspace => '既存のワークスペース';
	@override String get newWorkspace => '新しいワークスペース';
	@override String get path => 'パス:';
	@override String get cloneFrom => 'クローン元:';
	@override String get authentication => '認証:';
	@override String get usingStoredToken => '保存済みトークンを使用:';
	@override String get usingProvidedToken => '入力されたトークンを使用';
	@override String get noAuthentication => '認証なし';
	@override String get sshKey => 'SSHキー';
	@override String get existingInfo => 'ワークスペースがプロジェクト一覧に追加され、Claude/Cursorセッションで使用できるようになります。';
	@override String get newWithClone => 'このフォルダからリポジトリがクローンされます。';
	@override String get newEmpty => 'ワークスペースがプロジェクト一覧に追加され、Claude/Cursorセッションで使用できるようになります。';
	@override String get cloningRepository => 'リポジトリをクローンしています...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$ja extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get back => '戻る';
	@override String get next => '次へ';
	@override String get createProject => 'プロジェクトを作成';
	@override String get creating => '作成中...';
	@override String get cloning => 'クローン中...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$ja extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get selectType => '既存のワークスペースか新規作成かを選択してください';
	@override String get providePath => 'ワークスペースのパスを入力してください';
	@override String get failedToCreate => 'ワークスペースの作成に失敗しました';
	@override String get failedToCreateFolder => 'フォルダの作成に失敗しました';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$ja extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$ja generic = Translations$common$notifications$codes$generic$ja._(_root);
	@override late final Translations$common$notifications$codes$permission$ja permission = Translations$common$notifications$codes$permission$ja._(_root);
	@override late final Translations$common$notifications$codes$run$ja run = Translations$common$notifications$codes$run$ja._(_root);
	@override late final Translations$common$notifications$codes$agent$ja agent = Translations$common$notifications$codes$agent$ja._(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$ja extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get close => '閉じる';
	@override String get later => '後で';
	@override String get copyCommand => 'コマンドをコピー';
	@override String get updateNow => '今すぐ更新';
	@override String get updating => '更新中...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$ja extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get closeModal => 'バージョンアップグレードモーダルを閉じる';
	@override String get showSidebar => 'サイドバーを表示';
	@override String get settings => '設定';
	@override String get updateAvailable => 'アップデートあり';
	@override String get closeSidebar => 'サイドバーを閉じる';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$ja extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => '設定で Browser を有効にすると、エージェントが監視付きブラウザセッションを開けます。';
	@override String get descEnabled => 'AIタスクが Browser を使用している間、エージェントのブラウザセッションがここに表示されます。';
	@override String get titleDisabled => 'Browser は無効です';
	@override String get titleEnabled => 'ブラウザセッションはまだありません';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$ja extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => 'ブラウザ操作に失敗しました';
	@override String get loadFailed => 'Browser の読み込みに失敗しました';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$ja extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => 'Browser を使ってチェックアウトフローを調査し、壊れたUI状態を報告してください。';
	@override String get prompt2 => 'Browser で <url> を開き、ページを操作して、各ステップ後の変化を要約してください。';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$ja extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => '日前';
	@override String get hoursAgo => '時間前';
	@override String get justNow => 'たった今';
	@override String get minutesAgo => '分前';
	@override String get never => 'なし';
	@override String get secondsAgo => '秒前';
	@override String get unknown => '不明';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$ja extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get disabled => '無効';
	@override String get installing => 'インストール中';
	@override String get ready => '準備完了';
	@override String get setupRequired => 'セットアップが必要';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$ja extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => 'すべてのブランチを表示 (${count})';
	@override String commits({required Object count}) => 'すべてのコミットを表示 (${count})';
	@override String files({required Object count}) => 'すべてのファイルを表示 (${count})';
	@override String sessions({required Object count}) => 'すべてのセッションを表示 (${count})';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$ja extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get costNote => 'コストは公開されているトークン単価に基づくクライアント側の推定値です。不明なモデルは「—」と表示されます。';
	@override String get estCost => '推定コスト';
	@override String get inputOutput => '入力 / 出力';
	@override String get model => 'モデル';
	@override String get na => '該当なし';
	@override String get openSplit => '分割ビューで開く';
	@override String get provider => 'プロバイダー';
	@override String get selectSession => 'セッションを選択…';
	@override String get tokensUsed => '使用トークン';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$ja extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get actions => 'アクション';
	@override String get branches => 'ブランチ';
	@override String get commits => 'コミット';
	@override String get files => 'ファイル';
	@override String get git => 'Git';
	@override String get navigate => 'ナビゲーション';
	@override String get sessions => 'セッション';
	@override String get settings => '設定';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$ja extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get close => '閉じる';
	@override String get navigate => '移動';
	@override String get select => '選択';
	@override String get togglePalette => 'パレットの切り替え';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$ja extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => 'セッションを比較';
	@override String get gitFetch => 'Git: Fetch';
	@override String get gitPull => 'Git: Pull';
	@override String get gitPush => 'Git: Push';
	@override String get openSettings => '設定を開く';
	@override String get selectProjectFirst => '先にプロジェクトを選択してください';
	@override String settingsEntry({required Object label}) => '設定: ${label}';
	@override String get startNewChat => '新しいチャットを開始';
	@override String switchTo({required Object name}) => '切り替え: ${name}';
	@override String get toggleTheme => 'テーマを切り替え';
	@override String get tokensAndCost => 'トークンとコスト';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$ja extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get board => 'エージェントボードへ';
	@override String get chat => 'チャットへ';
	@override String get files => 'ファイルへ';
	@override String get git => 'Git へ';
	@override String get sourceControl => 'ソース管理へ';
	@override String get tasks => 'タスクへ';
	@override String get usage => 'クォータと使用量へ';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$ja extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get actions => 'アクション';
	@override String get branches => 'ブランチ';
	@override String get commits => 'コミット';
	@override String get compare => '比較';
	@override String get files => 'ファイル';
	@override String get sessions => 'セッション';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$ja extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => 'ブランチ「${branch}」を削除しますか？通常の削除はブランチが完全にマージされている場合のみ成功します。元に戻せません。';
	@override String confirmSwitch({required Object branch}) => 'ブランチ「${branch}」に切り替えますか？未コミットの変更がないことを確認してください。';
	@override String countBoth({required Object local, required Object remote}) => 'ローカル ${local}、リモート ${remote}';
	@override String countLocal({required Object count}) => 'ローカル ${count}';
	@override String get current => '現在';
	@override String deleteTitle({required Object branch}) => '${branch} を削除';
	@override String get emptyDesc => 'ブランチを作成して並行作業を開始します。';
	@override String get forceDelete => '強制削除';
	@override String get forceDeleteDesc => '他にマージされていないコミットが含まれていてもブランチを完全に削除します。';
	@override String get forceDeleteLabel => 'この未マージのブランチを強制削除';
	@override String get local => 'ローカル';
	@override String get kNew => '新しいブランチ';
	@override String get noMatch => '検索に一致するブランチがありません';
	@override String get none => 'ブランチが見つかりません';
	@override String get remote => 'リモート';
	@override String get kSwitch => '切り替え';
	@override String switchTo({required Object branch}) => '${branch} に切り替え';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$ja extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get commit => '確認';
	@override String get delete => '削除';
	@override String get deleteBranch => '削除';
	@override String get discard => '破棄';
	@override String get publish => '公開';
	@override String get pull => 'プル';
	@override String get push => 'プッシュ';
	@override String get revertLocalCommit => 'コミットを取り消す';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$ja extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get commit => '操作の確認';
	@override String get delete => 'ファイルを削除';
	@override String get deleteBranch => 'ブランチを削除';
	@override String get discard => '変更を破棄';
	@override String get publish => 'ブランチを公開';
	@override String get pull => 'Pull の確認';
	@override String get push => 'Push の確認';
	@override String get revertLocalCommit => 'ローカルコミットを取り消す';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$ja extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => 'ブランチの作成に失敗しました';
	@override String get createWorktreeFailed => 'worktree の作成に失敗しました';
	@override String get deleteBranchFailed => 'ブランチの削除に失敗しました';
	@override String get fetchFailed => 'Fetch に失敗しました';
	@override String get initFailed => 'リポジトリの初期化に失敗しました';
	@override String get initialCommitFailed => '最初のコミットの作成に失敗しました';
	@override String get mergeFailed => 'マージに失敗しました';
	@override String get openWorktreeFailed => 'worktree を開けませんでした';
	@override String get operationFailed => 'git 操作に失敗しました';
	@override String get publishFailed => '公開に失敗しました';
	@override String get pullFailed => 'Pull に失敗しました';
	@override String get pushFailed => 'Push に失敗しました';
	@override String get removeWorktreeFailed => 'worktree の削除に失敗しました';
	@override String get stageFailed => 'ステージに失敗しました';
	@override String get stageHunksFailed => 'ハンクのステージに失敗しました';
	@override String get switchFailed => 'ブランチの切り替えに失敗しました';
	@override String get unstageFailed => 'ステージ解除に失敗しました';
	@override String get unstageHunksFailed => 'ハンクのステージ解除に失敗しました';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$ja extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get added => '追加';
	@override String get author => '作者';
	@override String get changedFiles => '変更されたファイル';
	@override String get date => '日付';
	@override String get empty => 'コミットが見つかりません';
	@override String get files => 'ファイル';
	@override String get removed => '削除';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$ja extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => 'マージ後に worktree を削除し、そのブランチを削除する';
	@override String get cleanupLabel => 'マージ後にクリーンアップ';
	@override String commitCount({required Object count}) => '${count} コミット';
	@override String get merge => 'マージ';
	@override String mergeMessage({required Object branch}) => 'ブランチ \'${branch}\' をマージ';
	@override String get messageLabel => 'コミットメッセージ';
	@override String squashDesc({required Object commits, required Object branch}) => '${commits} 件すべてを ${branch} 上の1つのコミットにまとめる';
	@override String get squashLabel => 'コミットをスカッシュ';
	@override String get squashMerge => 'スカッシュ＆マージ';
	@override String squashMessage({required Object branch}) => 'ブランチ \'${branch}\' をスカッシュマージ';
	@override String get title => 'Worktree をマージ';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$ja extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => '現在のブランチ（${branch}）から新しいブランチを作成します';
	@override String get nameLabel => 'ブランチ名';
	@override String get submit => 'ブランチを作成';
	@override String get title => '新しいブランチを作成';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$ja extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => 'ブランチ';
	@override String get createFrom => '作成元';
	@override String get description => 'ブランチを独自のフォルダにチェックアウトし、並行して作業します。';
	@override String get existingBranch => '既存のブランチ — そのままチェックアウトされます。';
	@override String get submit => 'Worktree を作成';
	@override String get switchAfter => '作成後に worktree へ切り替える';
	@override String get title => '新しい Worktree';
	@override String get willCreateIn => '作成先';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$ja extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get create => '最初のコミットを作成';
	@override String get creating => '最初のコミットを作成中...';
	@override String get description => 'このリポジトリにはまだコミットがありません。最初のコミットを作成して変更の追跡を開始してください。';
	@override String get title => 'まだコミットがありません';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$ja extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'このプロジェクトはまだ git リポジトリではありません。初期化して変更の追跡とソース管理を開始してください。';
	@override String get init => 'git init を実行';
	@override String get initializing => 'リポジトリを初期化中...';
	@override String get title => 'git リポジトリがありません';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$ja extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => 'ブランチも削除';
	@override String description({required Object branch}) => '${branch} の worktree を削除しますか？フォルダは削除され、リンクされたプロジェクトはアーカイブされます。チャットセッションは復元可能です。';
	@override String dirtyWarning({required Object count}) => 'この worktree には失われる未コミットの変更が ${count} 件あります。';
	@override String get discardChanges => '未コミットの変更を破棄';
	@override String get title => 'Worktree を削除';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$ja extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get added => '追加';
	@override String get deleted => '削除';
	@override String get modified => '変更';
	@override String get untracked => '未追跡';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$ja extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} 件の変更';
	@override String count({required Object count}) => '${count} 個の worktree';
	@override String get createFirst => '最初の worktree を作成';
	@override String get detached => '分離';
	@override String detachedAt({required Object sha}) => '分離 @ ${sha}';
	@override String get detachedHead => '分離された HEAD';
	@override String get emptyDesc => 'worktree はブランチを独自のフォルダにチェックアウトするため、別々のチャットセッションを並行して実行し、準備ができたら結果をマージできます。';
	@override String get emptyTitle => 'ブランチで並行作業';
	@override String get locked => 'ロック中';
	@override String get mainWorktree => 'メイン worktree';
	@override String mergeTitle({required Object branch}) => '${branch} をベースブランチにマージ';
	@override String get kNew => '新しい worktree';
	@override String get none => 'worktree がありません';
	@override String get nothingToMerge => 'マージするものがありません — ベースブランチより先行するコミットなし';
	@override String get open => '開く';
	@override String get refresh => 'worktree を更新';
	@override String removeTitle({required Object branch}) => '${branch} の worktree を削除';
	@override String switchTo({required Object branch}) => '${branch} に切り替え';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$ja extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get changes => '変更';
	@override String get history => 'コミット';
	@override String get branches => 'ブランチ';
	@override String get worktrees => 'ワークツリー';
}

// Path: common.gitPanel.worktreeScripts
class Translations$common$gitPanel$worktreeScripts$ja extends Translations$common$gitPanel$worktreeScripts$en {
	Translations$common$gitPanel$worktreeScripts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'worktree スクリプト';
	@override String get setup => 'セットアップスクリプト (作成/オープン後に実行)';
	@override String get run => '開発サーバーを起動';
	@override String get stop => '開発サーバーを停止';
	@override String get runScript => '実行スクリプト (開発サーバー、必要時)';
	@override String get runPort => 'プレビューポート (任意 — 空欄の場合は自動検出)';
	@override String get invalidPort => 'ポートは 1〜65535 の範囲で指定してください';
	@override String get sourceProject => 'プロジェクトのオーバーライドとして保存済み';
	@override String get sourceFile => '.ddagent/worktree.json から読み込み — 保存するとプロジェクトのオーバーライドが作成されます';
	@override String get sourceNone => 'まだ何も設定されていません';
	@override String get saving => '保存中…';
	@override String get setupRunning => 'セットアップ実行中';
	@override String get setupFailed => 'セットアップ失敗';
	@override String get running => '実行中';
	@override String get openPreview => 'プレビューを開く';
	@override String runExited({required Object code}) => '実行が終了しました (${code})';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$ja extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'スコープ';
	@override String get user => 'ユーザー';
	@override String get project => 'プロジェクト';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$ja extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get system => 'システム';
	@override String get light => 'ライト';
	@override String get dark => 'ダーク';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$ja extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外観';
	@override String get toolDisplay => 'ツール表示';
	@override String get inputSettings => '入力設定';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$ja extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dragging => 'ドラッグ中';
	@override String get closePanel => '設定パネルを閉じる';
	@override String get openPanel => '設定パネルを開く';
	@override String get draggingStatus => 'ドラッグ中...';
	@override String get toggleAndMove => 'クリックで切替、ドラッグで移動';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$ja extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get closePanel => 'ショートカットパネルを閉じる';
	@override String get openPanel => 'ショートカットパネルを開く';
}

// Path: settings.miniOrchestration.enable
class Translations$settings$miniOrchestration$enable$ja extends Translations$settings$miniOrchestration$enable$en {
	Translations$settings$miniOrchestration$enable$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'ミニオーケストレーションを有効化';
	@override String get description => 'Auto (mini) セッションをフルオーケストレーターではなく 2 ロールエンジン経由でルーティングします。';
}

// Path: settings.miniOrchestration.thinker
class Translations$settings$miniOrchestration$thinker$ja extends Translations$settings$miniOrchestration$thinker$en {
	Translations$settings$miniOrchestration$thinker$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '思考モデル (非 flash)';
	@override String get description => '計画、判断、レビューを行い、最終レポートを作成します。';
}

// Path: settings.miniOrchestration.worker
class Translations$settings$miniOrchestration$worker$ja extends Translations$settings$miniOrchestration$worker$en {
	Translations$settings$miniOrchestration$worker$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ワーカー (flash)';
	@override String get description => '計画された各ステップを実行します。';
}

// Path: settings.miniOrchestration.fields
class Translations$settings$miniOrchestration$fields$ja extends Translations$settings$miniOrchestration$fields$en {
	Translations$settings$miniOrchestration$fields$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get provider => 'プロバイダー';
	@override String get model => 'モデル';
	@override String get modelPlaceholder => 'モデルを選択';
	@override String get tier => 'ティア';
}

// Path: settings.miniOrchestration.roles
class Translations$settings$miniOrchestration$roles$ja extends Translations$settings$miniOrchestration$roles$en {
	Translations$settings$miniOrchestration$roles$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク別モデル';
	@override String get description => '各タスクタイプをどのモデル (ロール) が担当するか。';
}

// Path: settings.miniOrchestration.planner
class Translations$settings$miniOrchestration$planner$ja extends Translations$settings$miniOrchestration$planner$en {
	Translations$settings$miniOrchestration$planner$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プランナー';
	@override String get mode => 'モード';
	@override late final Translations$settings$miniOrchestration$planner$modes$ja modes = Translations$settings$miniOrchestration$planner$modes$ja._(_root);
	@override String get requireConfirmLabel => '実行前にプランを確認';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$ja extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'オーケストレーションを有効化';
	@override String get description => 'すべてを 1 つのプロバイダーで実行する代わりに、オーケストレーターがステップごとにモデルを選びます。';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$ja extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '候補プール';
	@override String get description => 'ルーターが選択できるモデル。それぞれコスト階層に紐付けられます。';
	@override String get add => '候補を追加';
	@override String get empty => '候補はまだありません — 追加するとルーティングを開始できます。';
	@override late final Translations$settings$orchestration$pool$fields$ja fields = Translations$settings$orchestration$pool$fields$ja._(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$ja extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get free => '無料';
	@override String get cheap => '低価格';
	@override String get mid => '中価格';
	@override String get premium => 'プレミアム';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$ja extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ルーティングルール';
	@override String get description => 'タスクタイプごとに順序付けされた候補 — 最初に利用可能なものが選ばれます。';
	@override String get addCandidate => '候補を追加…';
	@override String get empty => '候補がありません — このタスクタイプのルーティング先がありません。';
	@override String get missing => '(削除済み)';
	@override String get remove => '候補を削除';
	@override late final Translations$settings$orchestration$rules$taskTypes$ja taskTypes = Translations$settings$orchestration$rules$taskTypes$ja._(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$ja extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プランナー';
	@override String get description => 'リクエストをルーティング用のステップに分割する方法。';
	@override String get modeLabel => '計画モード';
	@override late final Translations$settings$orchestration$planner$modes$ja modes = Translations$settings$orchestration$planner$modes$ja._(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$ja modeHints = Translations$settings$orchestration$planner$modeHints$ja._(_root);
	@override String get candidateLabel => 'プランナーモデル';
	@override String get candidateDescription => 'プラン生成と分類の呼び出しに使うプール内の候補。';
	@override String get candidatePlaceholder => 'プールの候補を選択';
	@override late final Translations$settings$orchestration$planner$templates$ja templates = Translations$settings$orchestration$planner$templates$ja._(_root);
	@override String get requireConfirm => '実行前にプランを確認';
	@override String get requireConfirmDescription => '計画後に一時停止し、プランカードでステップを編集・無効化できるようにします。';
	@override String get checkpointLabel => '自律性';
	@override late final Translations$settings$orchestration$planner$checkpointModes$ja checkpointModes = Translations$settings$orchestration$planner$checkpointModes$ja._(_root);
	@override late final Translations$settings$orchestration$planner$checkpointHints$ja checkpointHints = Translations$settings$orchestration$planner$checkpointHints$ja._(_root);
	@override String get checkpointIntervalLabel => 'チェックポイント間のステップ数 (1–50)';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$ja extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '実行制限';
	@override String get description => '並列実行と修正ループのガードレール。';
	@override String get maxParallel => '最大並列ステップ数';
	@override String get maxParallelDescription => '同時に実行できるサブタスクの数 (1–8)。';
	@override String get maxFixLoops => '最大修正ループ数';
	@override String get maxFixLoopsDescription => 'ステップが検証に失敗したときの再試行回数 (0–5)。';
	@override String get onNoCandidate => '利用可能な候補がない場合';
	@override String get onNoCandidateDescription => 'フォールバック前に確認するか、ステップをスキップします。';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$ja onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$ja._(_root);
	@override String get useWorktree => '分離された worktree';
	@override String get useWorktreeDescription => '委任されたすべてのステップを、プロジェクトディレクトリではなく 1 つの共有 git worktree で実行します。';
	@override String get maxSupervisorIterations => 'スーパーバイザーの最大反復回数';
	@override String get maxSupervisorIterationsDescription => '自動モードでのスーパーバイザー判断ラウンドの上限 (1–100)。上限に達すると部分レポートで実行を終了します。';
	@override String get maxAttempts => 'ステップごとの最大試行回数';
	@override String get maxAttemptsDescription => '1 ステップあたりのレーンと再試行をまたいだ総試行回数 (1–50)。';
	@override String get stepTimeoutMs => 'ステップのタイムアウト (ms)';
	@override String get stepTimeoutMsDescription => '試行ごとの子実行のタイムアウト (ミリ秒)。0 で無効。';
	@override String get runTimeoutMs => '実行のタイムアウト (ms)';
	@override String get runTimeoutMsDescription => 'プラン実行全体のタイムアウト (ミリ秒)。0 で無効。';
	@override String get retryBackoffBaseMs => '再試行バックオフの基準値 (ms)';
	@override String get retryBackoffBaseMsDescription => '同一レーンでの再試行間の指数バックオフの基準値 (フルジッター)。';
	@override String get retryBudgetTitle => '失敗クラスごとの再試行回数';
	@override String get retryBudgetDescription => 'フェイルオーバー/クールダウン前の同一レーンでの再試行回数 (0–5)。';
	@override late final Translations$settings$orchestration$execution$retryClasses$ja retryClasses = Translations$settings$orchestration$execution$retryClasses$ja._(_root);
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$ja extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get unsaved => '未保存の変更';
	@override String get save => '保存';
	@override String get saving => '保存中…';
	@override String get saved => '保存しました';
	@override String get discard => '破棄';
	@override String get error => '保存に失敗しました';
	@override String get emptyPool => '保存する前に候補を 1 つ以上追加してください。';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$ja extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Webプッシュ通知';
	@override String get enable => 'プッシュ通知を有効にする';
	@override String get disable => 'プッシュ通知を無効にする';
	@override String get enabled => 'プッシュ通知は有効です';
	@override String get loading => '更新中...';
	@override String get unsupported => 'このブラウザではプッシュ通知がサポートされていません。';
	@override String get denied => 'プッシュ通知がブロックされています。ブラウザの設定で許可してください。';
	@override String get iosHint => 'iPhone/iPad では、DDAgent をホーム画面に追加し（共有 → ホーム画面に追加）、そのインストール済みアプリで通知を有効にした後でのみ通知が機能します。';
	@override String get test => 'テスト通知を送信';
	@override String get testNoSubscription => '登録済みデバイスがありません。先にスマホで「有効にする」をタップしてください。';
	@override String testSuccess({required Object count}) => '${count} 台のデバイスに送信しました。スマホに表示されない場合は DDAgent をホーム画面に追加してください（iOS の要件）。';
	@override String get testNotDelivered => '到達可能なデバイスがありませんでした。アプリが実行中で、通知が有効になっていることを確認してください。';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$ja extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'このデバイスに通知';
	@override String get enabled => 'このデバイスの通知が有効になっています';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$ja extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'このデスクトップアプリに通知';
	@override String get enable => 'プッシュ通知を有効にする';
	@override String get disable => 'プッシュ通知を無効にする';
	@override String get enabled => 'このデスクトップアプリの通知が有効です';
	@override String get unsupported => 'このシステムではデスクトップ通知はサポートされていません。';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$ja extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'サウンド';
	@override String get description => 'チャット実行が完了したときに短い音を再生します。';
	@override String get enabled => '有効';
	@override String get test => 'サウンドをテスト';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$ja extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'イベント種別';
	@override String get actionRequired => '対応が必要';
	@override String get stop => '実行停止';
	@override String get error => '実行失敗';
}

// Path: settings.notifications.messaging
class Translations$settings$notifications$messaging$ja extends Translations$settings$notifications$messaging$en {
	Translations$settings$notifications$messaging$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'メッセンジャーでの承認';
	@override String get description => 'Telegram からエージェントの権限リクエストを承認・拒否し、Discord で実行通知を受け取ります。';
	@override String get enabled => '有効';
	@override String get save => '保存';
	@override String get test => 'テスト';
	@override String get pair => 'ペアリング';
	@override String get telegramToken => '@BotFather で取得したボットトークン (123456:ABC…)';
	@override String get telegramHint => 'ボットに任意のメッセージを送信してから、下でチャットをペアリングしてください。';
	@override String get discordWebhook => 'https://discord.com/api/webhooks/…';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$ja extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get telegram => 'Telegram';
	@override String get discord => 'Discord';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$ja extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'ダークモード';
	@override String get description => 'ライトテーマとダークテーマを切り替えます';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$ja extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'コードエディタ';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$ja theme = Translations$settings$appearanceSettings$codeEditor$theme$ja._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$ja wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$ja._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$ja showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$ja._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$ja lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$ja._(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$ja fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$ja._(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$ja extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ターミナル';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ja focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ja._(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$ja extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get add => 'MCPサーバーを追加';
	@override String get edit => 'MCPサーバーを編集';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$ja extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get form => 'フォーム入力';
	@override String get json => 'JSONインポート';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$ja extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'スコープ';
	@override String get userGlobal => 'ユーザー（グローバル）';
	@override String get projectLocal => 'プロジェクト（ローカル）';
	@override String get userDescription => 'ユーザースコープ: すべてのプロジェクトで利用可能';
	@override String get projectDescription => 'ローカルスコープ: 選択したプロジェクトでのみ利用可能';
	@override String get cannotChange => '既存のサーバーを編集する場合、スコープは変更できません';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$ja extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'サーバー名';
	@override String get transportType => 'トランスポートの種類';
	@override String get command => 'コマンド';
	@override String get arguments => '引数（1行に1つ）';
	@override String get jsonConfig => 'JSON設定';
	@override String get url => 'URL';
	@override String get envVars => '環境変数（KEY=value、1行に1つ）';
	@override String get headers => 'ヘッダー（KEY=value、1行に1つ）';
	@override String get selectProject => 'プロジェクトを選択...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$ja extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get serverName => 'my-server';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$ja extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get missingType => '必須フィールドがありません: type';
	@override String get stdioRequiresCommand => 'stdioタイプにはcommandフィールドが必要です';
	@override String httpRequiresUrl({required Object type}) => '${type}タイプにはurlフィールドが必要です';
	@override String get invalidJson => '無効なJSON形式です';
	@override String get jsonHelp => 'MCPサーバー設定をJSON形式で貼り付けてください。例:';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$ja extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get saving => '保存中...';
	@override String get addServer => 'サーバーを追加';
	@override String get updateServer => 'サーバーを更新';
}

// Path: settings.git.name
class Translations$settings$git$name$ja extends Translations$settings$git$name$en {
	Translations$settings$git$name$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git名前';
	@override String get help => 'コミットに使用する名前';
	@override String get placeholder => '山田 太郎';
}

// Path: settings.git.email
class Translations$settings$git$email$ja extends Translations$settings$git$email$en {
	Translations$settings$git$email$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'Gitメールアドレス';
	@override String get help => 'コミットに使用するメールアドレス';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$ja extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get save => '設定を保存';
	@override String get saving => '保存中...';
}

// Path: settings.git.status
class Translations$settings$git$status$ja extends Translations$settings$git$status$en {
	Translations$settings$git$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get success => '保存しました';
	@override String get error => '保存に失敗しました';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$ja extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ APIキーを保存してください';
	@override String get alertMessage => 'このキーが表示されるのは今回限りです。安全な場所に保管してください。';
	@override String get iveSavedIt => '保存しました';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$ja extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'APIキーの名前（例: 本番サーバー）';
	@override String get createButton => '作成';
	@override String get cancelButton => 'キャンセル';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$ja extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get created => '作成日:';
	@override String get lastUsed => '最終使用日:';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$ja extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get active => '有効';
	@override String get inactive => '無効';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$ja extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHubトークン';
	@override String get description => '外部APIからプライベートリポジトリをクローンするためのGitHubパーソナルアクセストークンを追加します。';
	@override String get descriptionAlt => 'プライベートリポジトリをクローンするためのGitHubパーソナルアクセストークンを追加します。保存せずにAPIリクエストで直接トークンを渡すこともできます。';
	@override String get addButton => 'トークンを追加';
	@override late final Translations$settings$apiKeys$github$form$ja form = Translations$settings$apiKeys$github$form$ja._(_root);
	@override String get empty => 'GitHubトークンはまだ追加されていません。';
	@override String get added => '追加日:';
	@override String get confirmDelete => 'このGitHubトークンを削除してもよろしいですか？';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$ja extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '外部APIドキュメント';
	@override String get description => '外部APIを使用してアプリケーションからClaude/Cursorセッションを起動する方法を学びます。';
	@override String get viewLink => 'APIドキュメントを見る →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$ja extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => 'アップデートあり: v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$ja extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI CLIがインストールされていません';
	@override String get description => 'タスク管理機能を使用するにはTaskMaster CLIが必要です。以下のコマンドでインストールしてください:';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => 'GitHubで見る';
	@override String get afterInstallation => 'インストール後:';
	@override late final Translations$settings$tasks$notInstalled$steps$ja steps = Translations$settings$tasks$notInstalled$steps$ja._(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$ja extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => 'TaskMaster統合を有効にする';
	@override String get enableDescription => 'インターフェース全体でTaskMasterのタスク、バナー、サイドバーインジケータを表示します';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$ja extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get checking => '確認中...';
	@override String get connected => '接続済み';
	@override String get notConnected => '未接続';
	@override String get disconnected => '切断';
	@override String get checkingAuth => '認証状態を確認しています...';
	@override String loggedInAs({required Object email}) => '${email}でログイン中';
	@override String providerAccount({required Object provider}) => '${provider} アカウント';
	@override String get authenticatedUser => '認証済みユーザー';
}

// Path: settings.agents.install
class Translations$settings$agents$install$ja extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => '${agent} CLI がインストールされていません';
	@override String description({required Object agent}) => 'ログインしてセッションを実行するには ${agent} CLI をインストールしてください。';
	@override String get button => 'インストール';
	@override String get installing => 'インストール中…';
	@override String get copyCommand => 'コマンドをコピー';
	@override String get docs => 'ドキュメント';
	@override String success({required Object agent}) => '${agent} CLI をインストールしました';
	@override String get failed => 'インストールに失敗しました — ターミナルの出力を確認してください';
}

// Path: settings.agents.update
class Translations$settings$agents$update$ja extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'CLI を更新';
	@override String description({required Object agent}) => '${agent} CLI の最新バージョンをサーバーホストにインストールします。';
	@override String get button => '更新';
	@override String get updating => '更新中…';
	@override String success({required Object agent}) => '${agent} CLI を更新しました';
	@override String get failed => '更新に失敗しました — ターミナルの出力を確認してください';
}

// Path: settings.agents.account
class Translations$settings$agents$account$ja extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$ja claude = Translations$settings$agents$account$claude$ja._(_root);
	@override late final Translations$settings$agents$account$cursor$ja cursor = Translations$settings$agents$account$cursor$ja._(_root);
	@override late final Translations$settings$agents$account$codex$ja codex = Translations$settings$agents$account$codex$ja._(_root);
	@override late final Translations$settings$agents$account$opencode$ja opencode = Translations$settings$agents$account$opencode$ja._(_root);
	@override late final Translations$settings$agents$account$commandcode$ja commandcode = Translations$settings$agents$account$commandcode$ja._(_root);
	@override late final Translations$settings$agents$account$antigravity$ja antigravity = Translations$settings$agents$account$antigravity$ja._(_root);
	@override late final Translations$settings$agents$account$devin$ja devin = Translations$settings$agents$account$devin$ja._(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$ja extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログイン';
	@override String get reAuthenticate => '再認証';
	@override String description({required Object agent}) => '${agent}アカウントにサインインしてAI機能を有効にします';
	@override String get reAuthDescription => '別のアカウントでサインインするか、認証情報を更新します';
	@override String get button => 'ログイン';
	@override String get reLoginButton => '再ログイン';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$ja extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログアウト';
	@override String get description => 'このプロバイダーからログアウトし、保存された認証情報を削除します';
	@override String get button => 'ログアウト';
	@override String confirmTitle({required Object agent}) => '${agent} からログアウトしますか？';
	@override String confirmDescription({required Object agent}) => 'サーバーに保存された ${agent} の認証情報を削除します。${agent} を使い続けるには再度ログインしてください。';
	@override String get success => 'ログアウトしました';
	@override String get failed => 'ログアウトに失敗しました';
}

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$ja extends Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '名前付きアカウント';
	@override String get description => '追加の認証情報セットです。アカウントに固定されたセッションは、そのアカウント専用の設定ディレクトリで CLI を起動します。表示された環境変数を付けてプロバイダーの CLI を一度実行し、ログインしてください。';
	@override String get sharedCli => 'すべてのアカウントは 1 つの CLI インストールを共有します — 上の接続カードで更新してください。';
	@override String get loading => 'アカウントを読み込み中…';
	@override String get kDefault => 'デフォルト';
	@override String usage({required Object tokens}) => '${tokens} トークン';
	@override String get usageButton => '使用量';
	@override String get showUsage => 'トークン使用量を表示';
	@override String get makeDefault => 'デフォルトに設定';
	@override String get remove => 'アカウントを削除';
	@override String get newLabel => 'アカウントのラベル (例: 仕事用)';
	@override String get add => 'アカウントを追加';
	@override late final Translations$settings$agents$accounts$autoSwitch$ja autoSwitch = Translations$settings$agents$accounts$autoSwitch$ja._(_root);
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$ja extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '権限モード';
	@override String description({required Object provider}) => '新しい ${provider} セッションのデフォルト権限モード。個別のセッションで上書きできます。';
	@override late final Translations$settings$permissions$permissionMode$modes$ja modes = Translations$settings$permissions$permissionMode$modes$ja._(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$ja extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Model Context Protocolサーバーは、Claudeに追加のツールやデータソースを提供します';
	@override String get cursor => 'Model Context Protocolサーバーは、Cursorに追加のツールやデータソースを提供します';
	@override String get codex => 'Model Context Protocolサーバーは、Codexに追加のツールやデータソースを提供します';
	@override String get opencode => 'Model Context Protocol サーバーは OpenCode に追加のツールとデータソースを提供します';
	@override String get commandcode => 'Model Context Protocol サーバーは Command Code に追加のツールとデータソースを提供します';
	@override String get antigravity => 'Model Context Protocol サーバーは Antigravity に追加のツールとデータソースを提供します';
	@override String get devin => 'Model Context Protocol サーバーは Devin に追加のツールとデータソースを提供します';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$ja extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get local => 'ローカル';
	@override String get user => 'ユーザー';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$ja extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get command => 'コマンド';
	@override String get url => 'URL';
	@override String get args => '引数';
	@override String get environment => '環境変数';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$ja extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ツール';
	@override String count({required Object count}) => '（${count}）:';
	@override String more({required Object count}) => '他${count}件';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$ja extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get edit => 'サーバーを編集';
	@override String get delete => 'サーバーを削除';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$ja extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get badge => '管理対象';
	@override String get hint => 'DDAgent により管理。';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$ja extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Codex MCPについて';
	@override String get description => 'Codexはstdioベースのツールサーバーをサポートしています。追加のツールやリソースでCodexの機能を拡張するサーバーを追加できます。';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$ja extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '「${serverName}」はプロバイダー設定から削除されます。';
	@override String get title => 'MCP サーバーを削除しますか？';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$ja extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get tab => 'コントロールセンター';
	@override String get title => 'コントロールセンター';
	@override String get description => 'アラートしきい値、ルーティングポリシー、クォータをポーリングするアカウント。';
	@override String get saved => '保存しました';
	@override String get alertsSection => 'アラート';
	@override String get alertsSectionHint => '上限が実際に尽きる前に警告します。100% になってからではありません。';
	@override String get alertsEnabled => '上限予測アラート';
	@override String get alertsEnabledHint => '概要とアカウントカードにペースベースの予測を表示します。';
	@override String get watchThreshold => '監視しきい値 (%)';
	@override String get watchThresholdHint => 'この読み取り以上のアカウントは危険とみなされます。';
	@override String get dangerThreshold => '危険しきい値 (%)';
	@override String get dangerThresholdHint => 'この値以上の読み取りは赤で表示されます。';
	@override String get routingSection => 'ルーティング';
	@override String get routingSectionHint => 'パネルが最も余裕のあるアカウントへ作業を移す方法。';
	@override late final Translations$settings$quota$settings$routing$ja routing = Translations$settings$quota$settings$routing$ja._(_root);
	@override String get routingNote => 'アカウントの切り替えはコストとモデル品質を変えるため、常に明示的な決定が必要です。';
	@override String get accountsSection => 'ポーリング対象アカウント';
	@override String get accountsSectionHint => '認証情報は各ツールから読み取られます。パネルが他の場所に送信することはありません。';
	@override String get sourcesSection => 'データソース';
	@override String get sourcesSectionHint => '使用量とコストの数値の出どころ。';
	@override String get logSources => 'トークン・コストログストア';
	@override String get logSourcesHint => 'tokboard コレクターと共有される読み取り専用の集計ストア。';
	@override String get readOnly => '読み取り専用';
	@override String get quotaConsent => 'クォータポーリング';
	@override String get quotaConsentHint => 'ローカルに保存された認証情報でプロバイダーのクォータエンドポイントを読み取ります。';
	@override String get localOnly => 'ローカルのみ';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$ja extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'アカウントがまだ検出されていません。';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$ja extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cached => 'キャッシュ';
	@override String get error => 'エラー';
	@override String get estimate => '推定';
	@override String get live => 'ライブ';
	@override String get unknown => '不明';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$ja extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => 'ブラウザランタイムのインストールに失敗しました';
	@override String get loadSettings => 'Browser 設定の読み込みに失敗しました';
	@override String get loadStatus => 'Browser ステータスの読み込みに失敗しました';
	@override String get saveSettings => 'Browser 設定の保存に失敗しました';
}

// Path: settings.about.pro
class Translations$settings$about$pro$ja extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => '設定を同期';
	@override String get teamManagement => 'チーム管理';
	@override String get syncSettingsDescription => '設定、MCP 構成、テーマをすべての環境で同期します。';
	@override String get teamManagementDescription => '複数ユーザー、ロールベースのアクセス制御、チームでの共有プロジェクト。';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$ja extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'AIを活用したタスク管理：複雑なプロジェクトを管理しやすいサブタスクに分解';
	@override String get prdTemplates => 'PRDテンプレート：Product Requirements Documentからタスクを生成';
	@override String get dependencyTracking => '依存関係の追跡：タスクの関係性と実行順序を理解';
	@override String get progressVisualization => '進捗の可視化：カンバンボードと詳細なタスク分析';
	@override String get cliIntegration => 'CLI統合：高度なワークフローのためにtaskmasterコマンドを使用';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$ja extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$ja createPRD = Translations$tasks$gettingStarted$steps$createPRD$ja._(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$ja generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$ja._(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$ja analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$ja._(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$ja startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$ja._(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$ja extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 例：\n「Claude Task Masterで新しいプロジェクトを初期化しました。.taskmaster/docs/prd.txtにPRDがあります。解析して初期タスクを設定するのを手伝ってもらえますか？」';
	@override String get expandTask => '💬 例：\n「タスク5は複雑そうです。サブタスクに分解してもらえますか？」';
	@override String get addTask => '💬 例：\n「Cloudinaryを使用してユーザープロフィール画像のアップロードを実装する新しいタスクを追加してください。最適なアプローチを調査してください。」';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$ja extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 プロのヒント';
	@override String get search => '検索バーを使用して特定のタスクをすばやく見つける';
	@override String get views => 'ビュー切替を使用してカンバン、リスト、グリッドビューを切り替える';
	@override String get filters => 'フィルターを使用して特定のタスクステータスや優先度に焦点を当てる';
	@override String get details => '任意のタスクをクリックして詳細情報を表示し、サブタスクを管理する';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$ja extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 詳細を見る';
	@override String get description => 'TaskMaster AIは開発者向けに構築された高度なタスク管理システムです。ドキュメント、例を入手し、プロジェクトに貢献できます。';
	@override String get githubButton => 'GitHubで見る';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$ja extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'まだカードがありません';
	@override String get description => 'カードを追加してタスクを説明し、「開始可能」にドラッグするとエージェントが作業を開始します。';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$ja extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get backlog => 'バックログ';
	@override String get ready => '開始可能';
	@override String get working => '作業中';
	@override String get needsDecision => 'あなたの判断が必要';
	@override String get done => '完了';
	@override String get archived => 'アーカイブ済み';
}

// Path: tasks.board.card
class Translations$tasks$board$card$ja extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get running => '実行中';
	@override String get abort => '中止';
	@override String get delete => '削除';
	@override String get openSession => 'セッションを開く';
	@override String get pullRequest => 'プルリクエスト';
	@override String get edit => '編集';
	@override String get moveTo => '移動先';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$ja extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get createTitle => '新しいカード';
	@override String get editTitle => 'カードを編集';
	@override String get titleLabel => 'タイトル';
	@override String get titlePlaceholder => 'エージェントは何をすべきですか？';
	@override String get descriptionLabel => '説明';
	@override String get descriptionPlaceholder => 'コンテキスト、受け入れ条件、リンクを追加...';
	@override String get cancel => 'キャンセル';
	@override String get save => '保存';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$ja extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get provider => 'エージェント';
	@override String get anyProvider => '任意のエージェント';
	@override String get model => 'モデル';
	@override String get defaultModel => 'デフォルトモデル';
	@override String get effort => '推論';
	@override String get defaultEffort => 'デフォルト';
	@override String get searchModel => 'モデルを検索…';
	@override String get noModels => '一致するモデルなし';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$ja extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '「${cardTitle}」は完全に削除されます。';
	@override String get title => 'カードを削除しますか？';
}

// Path: tasks.board.assignee
class Translations$tasks$board$assignee$ja extends Translations$tasks$board$assignee$en {
	Translations$tasks$board$assignee$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '担当者';
	@override String get all => 'すべての担当者';
	@override String get unassigned => '未割り当て';
}

// Path: tasks.board.presence
class Translations$tasks$board$presence$ja extends Translations$tasks$board$presence$en {
	Translations$tasks$board$presence$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String online({required Object count}) => '${count} 人がオンライン';
}

// Path: tasks.board.activity
class Translations$tasks$board$activity$ja extends Translations$tasks$board$activity$en {
	Translations$tasks$board$activity$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アクティビティ';
	@override String get empty => 'アクティビティはまだありません';
}

// Path: tasks.board.comments
class Translations$tasks$board$comments$ja extends Translations$tasks$board$comments$en {
	Translations$tasks$board$comments$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'コメント';
	@override String get placeholder => 'コメントを入力…';
	@override String get send => '送信';
	@override String get unknownAuthor => '不明なユーザー';
}

// Path: tasks.taskmaster.sort
class Translations$tasks$taskmaster$sort$ja extends Translations$tasks$taskmaster$sort$en {
	Translations$tasks$taskmaster$sort$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get statusAz => 'ステータス (A-Z)';
	@override String get statusZa => 'ステータス (Z-A)';
}

// Path: tasks.taskmaster.prd
class Translations$tasks$taskmaster$prd$ja extends Translations$tasks$taskmaster$prd$en {
	Translations$tasks$taskmaster$prd$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get fileNameRequired => 'PRD のファイル名を入力してください。';
	@override String get contentRequired => '保存する前に内容を追加してください。';
	@override String get overwrite => '上書き';
	@override String get contentHint => '# 製品要求仕様書…';
}

// Path: tasks.taskmaster.detail
class Translations$tasks$taskmaster$detail$ja extends Translations$tasks$taskmaster$detail$en {
	Translations$tasks$taskmaster$detail$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get dependenciesLabel => '依存関係 (カンマ区切りの ID)';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$ja extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cwd => 'Cwd';
	@override String get envVars => '環境変数';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$ja extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get userAllProviders => 'ユーザー（すべてのプロバイダー）';
	@override String get claudeLocal => 'Claude ローカル';
	@override String get projectAllProviders => 'プロジェクト（すべてのプロバイダー）';
	@override late final Translations$mcp$form$scope$description$ja description = Translations$mcp$form$scope$description$ja._(_root);
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$ja extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get workingDirectory => '作業ディレクトリ';
	@override String get envVarNames => '環境変数名';
	@override String get bearerTokenEnvVar => 'ベアラートークン環境変数';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$ja extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => 'MCPサーバーの追加は、すべてのプロバイダーで stdio と http のみをサポートし、${type} はサポートしません。';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} は ${type} MCPサーバーをサポートしていません';
	@override String get jsonMustBeObject => 'JSON 設定はオブジェクトである必要があります';
}

// Path: serverConnect.local.errors
class Translations$serverConnect$local$errors$ja extends Translations$serverConnect$local$errors$en {
	Translations$serverConnect$local$errors$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get releaseTagUnresolved => 'DDAgent の最新リリースタグを取得できませんでした。';
	@override String get unsupportedPlatform => 'このプラットフォームではローカルサーバーはサポートされていません。';
	@override String unsupportedPlatformDetail({required Object platform}) => 'このプラットフォームではローカルサーバーはサポートされていません（${platform}）。';
	@override String nodeExtractionFailed({required Object path}) => 'Node.js の展開で ${path} が作成されませんでした';
	@override String downloadFailed({required Object error}) => 'サーバーのダウンロードに失敗しました: ${error}';
	@override String installFailed({required Object error}) => 'サーバーのインストールに失敗しました: ${error}';
	@override String get bundleNotInstalled => 'サーバーバンドルがインストールされていません。';
	@override String spawnFailed({required Object error}) => 'ローカルサーバーを起動できませんでした: ${error}';
	@override String portInUse({required Object port}) => 'ポート ${port} は別のアプリケーションで使用中です。';
	@override String get exitedDuringStartup => 'ローカルサーバーが起動中に終了しました。';
	@override String exitedDuringStartupWithOutput({required Object output}) => 'ローカルサーバーが起動中に終了しました: ${output}';
	@override String get startTimeout => 'ローカルサーバーの起動待機がタイムアウトしました。';
	@override String tarFailed({required Object command, required Object code, required Object output}) => '${command} が失敗しました（終了コード ${code}）: ${output}';
}

// Path: chat.orchestrator.decision.action
class Translations$chat$orchestrator$decision$action$ja extends Translations$chat$orchestrator$decision$action$en {
	Translations$chat$orchestrator$decision$action$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get kContinue => '委任中';
	@override String get done => '完了';
	@override String get invalid => '判断なし';
}

// Path: chat.orchestrator.decision.outcome
class Translations$chat$orchestrator$decision$outcome$ja extends Translations$chat$orchestrator$decision$outcome$en {
	Translations$chat$orchestrator$decision$outcome$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get success => '成功';
	@override String get partial => '一部成功';
	@override String get failed => '失敗';
}

// Path: chat.orchestrator.delegation.status
class Translations$chat$orchestrator$delegation$status$ja extends Translations$chat$orchestrator$delegation$status$en {
	Translations$chat$orchestrator$delegation$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get queued => '待機中';
	@override String get running => '実行中';
	@override String get done => '完了';
	@override String get failed => '失敗';
	@override String get aborted => '中止';
	@override String get skipped => 'スキップ';
	@override String get awaitingDecision => '判断待ち';
}

// Path: chat.orchestrator.taskmaster.status
class Translations$chat$orchestrator$taskmaster$status$ja extends Translations$chat$orchestrator$taskmaster$status$en {
	Translations$chat$orchestrator$taskmaster$status$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get started => '実行中';
	@override String get done => '完了';
	@override String get complete => 'すべて完了';
	@override String get failed => '失敗';
	@override String get paused => '一時停止';
	@override String get blocked => 'ブロック中';
	@override String get aborted => '中止';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$ja extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get manual => '手動 — 推奨のみ';
	@override String get ask => 'アカウント切り替え前に確認';
	@override String get autoLowRisk => '低リスクタスクの自動切り替え';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$ja extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '既存のワークスペース';
	@override String get description => 'サーバー上に既存のワークスペースがあり、プロジェクト一覧に追加したい';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$ja extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '新しいワークスペース';
	@override String get description => '新しいワークスペースを作成し、必要に応じてGitHubリポジトリからクローンする';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$ja extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$ja info = Translations$common$notifications$codes$generic$info$ja._(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$ja extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$ja required = Translations$common$notifications$codes$permission$required$ja._(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$ja extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$ja stopped = Translations$common$notifications$codes$run$stopped$ja._(_root);
	@override late final Translations$common$notifications$codes$run$failed$ja failed = Translations$common$notifications$codes$run$failed$ja._(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$ja extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$ja notification = Translations$common$notifications$codes$agent$notification$ja._(_root);
}

// Path: settings.miniOrchestration.planner.modes
class Translations$settings$miniOrchestration$planner$modes$ja extends Translations$settings$miniOrchestration$planner$modes$en {
	Translations$settings$miniOrchestration$planner$modes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get auto => '思考モデルで計画';
	@override String get off => '単一ステップ';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$ja extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'ラベル';
	@override String get labelPlaceholder => '例: SWE-2 Medium';
	@override String get provider => 'プロバイダー';
	@override String get model => 'モデル';
	@override String get modelPlaceholder => 'モデルを選択';
	@override String get effort => '推論レベル';
	@override String get effortDefault => 'プロバイダーのデフォルト';
	@override String get effortPlaceholder => 'デフォルト';
	@override String get account => 'アカウント';
	@override String get accountDefault => 'プロバイダーのデフォルト';
	@override String get redundantAccounts => '冗長アカウント';
	@override String get redundantAccountsNone => 'このプロバイダーの他のアカウントはありません';
	@override String get tier => 'コスト階層';
	@override String get remove => '候補を削除';
	@override String get moveUp => '上へ移動';
	@override String get moveDown => '下へ移動';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$ja extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get plan => '計画';
	@override String get quick => '簡単な質問への回答';
	@override String get research => '調査';
	@override String get docs => 'ドキュメント';
	@override String get code => 'コーディング';
	@override String get codeHard => '複雑なコーディング';
	@override String get test => 'テスト';
	@override String get review => 'レビュー';
	@override String get report => 'レポート';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$ja extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get auto => '自動 (LLM)';
	@override String get template => 'テンプレート';
	@override String get off => 'オフ';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$ja extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get auto => 'プランナーモデルが各リクエストを種類付きのステップに分解します。';
	@override String get template => 'リクエストは下で選択した固定パイプラインで実行されます。';
	@override String get off => '計画なし — リクエスト全体を 1 つのステップとしてルーティングします。';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$ja extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'パイプラインテンプレート';
	@override String get add => 'テンプレートを追加';
	@override String get namePlaceholder => 'テンプレート名';
	@override String get addStep => 'ステップを追加…';
	@override String get remove => 'テンプレートを削除';
	@override String get removeStep => 'ステップを削除';
	@override String get empty => 'テンプレートはまだありません。';
	@override String get emptySteps => 'ステップはまだありません — 下で追加してください。';
}

// Path: settings.orchestration.planner.checkpointModes
class Translations$settings$orchestration$planner$checkpointModes$ja extends Translations$settings$orchestration$planner$checkpointModes$en {
	Translations$settings$orchestration$planner$checkpointModes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get off => '自律';
	@override String get perStep => 'ステップごと';
	@override String get everyN => 'N ステップごと';
}

// Path: settings.orchestration.planner.checkpointHints
class Translations$settings$orchestration$planner$checkpointHints$ja extends Translations$settings$orchestration$planner$checkpointHints$en {
	Translations$settings$orchestration$planner$checkpointHints$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get off => 'スーパーバイザーの判断を確認なしで実行します (自動モード)。';
	@override String get perStep => '提案されたステップのまとまりごとに承認を求めます。';
	@override String get everyN => 'N ステップ完了するたびに承認を求めます。';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$ja extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get ask => '確認する';
	@override String get skip => 'ステップをスキップ';
}

// Path: settings.orchestration.execution.retryClasses
class Translations$settings$orchestration$execution$retryClasses$ja extends Translations$settings$orchestration$execution$retryClasses$en {
	Translations$settings$orchestration$execution$retryClasses$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get rateLimit => 'レート制限';
	@override String get quota => 'クォータ';
	@override String get auth => '認証';
	@override String get timeout => 'タイムアウト';
	@override String get transient => '一時的なエラー';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$ja extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'エディタのテーマ';
	@override String get description => 'コードエディタのデフォルトテーマ';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$ja extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '折り返し';
	@override String get description => 'エディタでデフォルトで折り返しを有効にします';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$ja extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'ミニマップを表示';
	@override String get description => '差分ビューでナビゲーション用のミニマップを表示します';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$ja extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '行番号を表示';
	@override String get description => 'エディタに行番号を表示します';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$ja extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'フォントサイズ';
	@override String get description => 'エディタのフォントサイズ（ピクセル）';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ja extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => 'フォーカスはポインターに従う';
	@override String get description => 'マウスを上に移動したときに入力用にターミナルへフォーカスする';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$ja extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'トークンの名前（例: 個人リポジトリ）';
	@override String get tokenPlaceholder => 'GitHubパーソナルアクセストークン（ghp_...）';
	@override String get descriptionPlaceholder => '説明（任意）';
	@override String get addButton => 'トークンを追加';
	@override String get cancelButton => 'キャンセル';
	@override String get howToCreate => 'GitHubパーソナルアクセストークンの作成方法 →';
	@override String get showToken => 'トークンを表示';
	@override String get hideToken => 'トークンを非表示';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$ja extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get restart => 'このアプリケーションを再起動してください';
	@override String get autoAvailable => 'TaskMaster機能が自動的に利用可能になります';
	@override String get initCommand => 'プロジェクトディレクトリで task-master init を実行してください';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$ja extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Anthropic Claude AIアシスタント';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$ja extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Cursor AI搭載コードエディタ';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$ja extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenAI Codex AIアシスタント';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$ja extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenCode CLI アシスタント';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$ja extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Command Code CLI アシスタント';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$ja extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Antigravity CLI アシスタント';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$ja extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get description => 'Devin CLI アシスタント';
}

// Path: settings.agents.accounts.autoSwitch
class Translations$settings$agents$accounts$autoSwitch$ja extends Translations$settings$agents$accounts$autoSwitch$en {
	Translations$settings$agents$accounts$autoSwitch$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get label => '使用上限に達したらアカウントを自動切り替え';
	@override String get description => 'アカウントが使用上限に達すると、セッションは同じエージェントのまだ残量がある別のアカウントに切り替わります。上限に達したアカウントを手動で選んだ場合も同様です。別のエージェントに切り替わることはありません。Claude と Codex は会話を引き継ぎ、その他のエージェントは新しいチャットでのみ切り替わります。';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$ja extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$ja kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$ja._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$ja auto = Translations$settings$permissions$permissionMode$modes$auto$ja._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$ja acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$ja._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$ja bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$ja._(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$ja plan = Translations$settings$permissions$permissionMode$modes$plan$ja._(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$ja extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get manual => '手動';
	@override String get manualHint => '推奨のみ表示し、アカウントを自動切り替えしません。';
	@override String get ask => '切り替え前に確認';
	@override String get askHint => '切り替えが提案され、あなたの承認を待ちます。';
	@override String get autoLowRisk => '低リスクタスクは自動';
	@override String get autoLowRiskHint => '低リスクとマークされたタスクのみ自動的に移動できます。';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$ja extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Product Requirements Document (PRD) を作成';
	@override String get description => 'プロジェクトのアイデアについて話し合い、構築したい内容を説明するPRDを作成します。';
	@override String get addButton => 'PRDを追加';
	@override String get existingPRDs => '既存のPRD:';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$ja extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'PRDからタスクを生成';
	@override String get description => 'PRDができたら、AIアシスタントに解析を依頼してください。TaskMasterが自動的に実装の詳細を含む管理しやすいタスクに分解します。';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$ja extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスクの分析と展開';
	@override String get description => 'AIアシスタントにタスクの複雑さを分析してもらい、より簡単に実装できる詳細なサブタスクに展開します。';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$ja extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '開発を始める';
	@override String get description => 'AIアシスタントにタスクの作業を開始してもらい、ステータスを更新し、プロジェクトの進行に応じて新しいタスクを追加します。';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$ja extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get userGlobal => '各プロバイダーのユーザー設定に書き込み、このマシン上のすべてのプロジェクトで利用できます';
	@override String get user => 'このマシン上のすべてのプロジェクトで利用できます';
	@override String get local => '選択したプロジェクトのClaudeユーザー設定に保存されます';
	@override String get projectGlobal => 'すべてのプロバイダーの選択したプロジェクトワークスペースに書き込みます';
	@override String get project => '選択したプロジェクトのワークスペースに保存されます';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$ja extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$ja extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '対応が必要です';
	@override String body({required Object toolName}) => '${toolName} があなたの判断を待っています。';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$ja extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '実行が停止しました';
	@override String body({required Object reason}) => '理由: ${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$ja extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '実行に失敗しました';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$ja extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エージェント通知';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$ja extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'デフォルト';
	@override String get description => '権限が必要なアクションはチャットで承認のために表示されます。';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$ja extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '自動モード';
	@override String get description => 'モデル分類器がツール呼び出しごとに承認または拒否を決定します。高い自律性。';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$ja extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '編集を許可';
	@override String get description => 'ファイル編集は自動承認されます。他のアクションは引き続き承認を求めます。';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$ja extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '権限をバイパス';
	@override String get description => 'すべてのアクションが自動承認されます — プロンプトなしの完全アクセス。注意して使用してください。';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$ja extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プラン';
	@override String get description => 'プランモード: エージェントはコマンドを実行せずに探索と計画を行います。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => 'セッションの有効期限が切れました。再度ログインしてください。',
			'auth.login.title' => 'おかえりなさい',
			'auth.login.description' => 'DDAgentアカウントにサインイン',
			'auth.login.username' => 'ユーザー名',
			'auth.login.password' => 'パスワード',
			'auth.login.submit' => 'サインイン',
			'auth.login.loading' => 'サインイン中...',
			'auth.login.errors.invalidCredentials' => 'ユーザー名またはパスワードが正しくありません',
			'auth.login.errors.requiredFields' => 'すべての項目を入力してください',
			'auth.login.errors.networkError' => 'ネットワークエラー。もう一度お試しください。',
			'auth.login.placeholders.username' => 'ユーザー名を入力',
			'auth.login.placeholders.password' => 'パスワードを入力',
			'auth.register.title' => 'アカウント作成',
			'auth.register.username' => 'ユーザー名',
			'auth.register.password' => 'パスワード',
			'auth.register.confirmPassword' => 'パスワードの確認',
			'auth.register.submit' => 'アカウントを作成',
			'auth.register.loading' => 'アカウントを作成中...',
			'auth.register.errors.passwordMismatch' => 'パスワードが一致しません',
			'auth.register.errors.usernameTaken' => 'このユーザー名は既に使用されています',
			'auth.register.errors.weakPassword' => 'パスワードが弱すぎます',
			'auth.register.errors.usernameTooShort' => 'ユーザー名は3文字以上で入力してください',
			'auth.register.errors.passwordTooShort' => 'パスワードは6文字以上で入力してください',
			'auth.logout.title' => 'サインアウト',
			'auth.logout.confirm' => 'サインアウトしてもよろしいですか？',
			'auth.logout.button' => 'サインアウト',
			'chat.codeBlock.copy' => 'コピー',
			'chat.codeBlock.copied' => 'コピーしました',
			'chat.codeBlock.copyCode' => 'コードをコピー',
			'chat.copyMessage.copy' => 'メッセージをコピー',
			'chat.copyMessage.copied' => 'メッセージをコピーしました',
			'chat.copyMessage.failed' => 'コピーに失敗しました',
			'chat.copyMessage.selectFormat' => 'コピー形式を選択',
			'chat.copyMessage.copyAsMarkdown' => 'Markdownとしてコピー',
			'chat.copyMessage.copyAsText' => 'テキストとしてコピー',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => 'エラー',
			'chat.messageTypes.tool' => 'ツール',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.messageTypes.orchestrator' => 'Auto',
			'chat.orchestrator.routing.title' => 'ルーティング',
			'chat.orchestrator.routing.alternatives' => ({required Object list}) => '代替候補: ${list}',
			'chat.orchestrator.routing.first' => ({required Object label, required Object task}) => '${label} — ${task} の第一候補',
			'chat.orchestrator.routing.skipped' => ({required Object label, required Object list}) => '${label} — 先行候補をスキップ (${list})',
			'chat.orchestrator.plan.title' => 'プラン',
			'chat.orchestrator.plan.disabled' => '無効',
			'chat.orchestrator.plan.awaitingConfirm' => 'プランの確認を待っています。',
			'chat.orchestrator.plan.run' => 'プランを実行',
			'chat.orchestrator.plan.toggleStep' => 'ステップを有効化',
			'chat.orchestrator.plan.confirmFailed' => '開始できませんでした — もう一度お試しください。',
			'chat.orchestrator.plan.fallback' => 'プランナーを利用できません — 単一ステップにフォールバック',
			'chat.orchestrator.plan.templateSource' => 'パイプラインテンプレートから',
			'chat.orchestrator.plan.offSource' => 'プランナー無効',
			'chat.orchestrator.plan.stepCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} ステップ', other: '${count} ステップ', ), 
			'chat.orchestrator.plan.supervisedSource' => '監督付きループ',
			'chat.orchestrator.decision.title' => 'スーパーバイザーの判断',
			'chat.orchestrator.decision.iteration' => ({required Object n}) => '反復 ${n}',
			'chat.orchestrator.decision.rationaleLabel' => '理由',
			'chat.orchestrator.decision.awaitingConfirm' => 'これらのステップを実行する前に承認を待っています。',
			'chat.orchestrator.decision.proposedSteps' => '提案されたステップ',
			'chat.orchestrator.decision.action.kContinue' => '委任中',
			'chat.orchestrator.decision.action.done' => '完了',
			'chat.orchestrator.decision.action.invalid' => '判断なし',
			'chat.orchestrator.decision.outcome.success' => '成功',
			'chat.orchestrator.decision.outcome.partial' => '一部成功',
			'chat.orchestrator.decision.outcome.failed' => '失敗',
			'chat.orchestrator.delegation.title' => '委任されたステップ',
			'chat.orchestrator.delegation.openSession' => 'セッション全体を開く',
			'chat.orchestrator.delegation.attempt' => ({required Object n}) => '試行 ${n}',
			'chat.orchestrator.delegation.retryStep' => '再試行 / 修正',
			'chat.orchestrator.delegation.continueStep' => '続行 / 修正',
			'chat.orchestrator.delegation.continueFailed' => '失敗しました — もう一度お試しください。',
			'chat.orchestrator.delegation.status.queued' => '待機中',
			'chat.orchestrator.delegation.status.running' => '実行中',
			'chat.orchestrator.delegation.status.done' => '完了',
			'chat.orchestrator.delegation.status.failed' => '失敗',
			'chat.orchestrator.delegation.status.aborted' => '中止',
			'chat.orchestrator.delegation.status.skipped' => 'スキップ',
			'chat.orchestrator.delegation.status.awaitingDecision' => '判断待ち',
			'chat.orchestrator.delegation.attempts' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 回試行', other: '${count} 回試行', ), 
			'chat.orchestrator.delegation.candidates' => ({required Object list}) => '候補: ${list}',
			'chat.orchestrator.delegation.candidateCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '候補 ${count} 件', other: '候補 ${count} 件', ), 
			'chat.orchestrator.summary.title' => '概要',
			'chat.orchestrator.summary.progress' => ({required Object done, required Object total}) => '完了したステップ: ${done}/${total}',
			'chat.orchestrator.summary.aborted' => '中止',
			'chat.orchestrator.summary.timedOut' => 'タイムアウト',
			'chat.orchestrator.summary.capped' => '反復上限',
			'chat.orchestrator.summary.failed' => ({required Object list}) => '失敗したステップ: ${list}',
			'chat.orchestrator.summary.kContinue' => '続行',
			'chat.orchestrator.summary.continueWork' => '作業を続行',
			'chat.orchestrator.summary.resumeFailed' => '再開できませんでした — もう一度お試しください。',
			'chat.orchestrator.summary.runNextTask' => '次のタスクを実行',
			'chat.orchestrator.summary.endAllTasks' => 'すべてのタスクを終了',
			'chat.orchestrator.summary.tasksRunning' => 'タスクを処理中…',
			'chat.orchestrator.summary.cancelTasks' => 'キャンセル',
			'chat.orchestrator.backToParent' => 'オーケストレーションに戻る',
			'chat.orchestrator.taskmaster.title' => 'タスクキュー',
			'chat.orchestrator.taskmaster.remaining' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '残り ${count} 件', other: '残り ${count} 件', ), 
			'chat.orchestrator.taskmaster.status.started' => '実行中',
			'chat.orchestrator.taskmaster.status.done' => '完了',
			'chat.orchestrator.taskmaster.status.complete' => 'すべて完了',
			'chat.orchestrator.taskmaster.status.failed' => '失敗',
			'chat.orchestrator.taskmaster.status.paused' => '一時停止',
			'chat.orchestrator.taskmaster.status.blocked' => 'ブロック中',
			'chat.orchestrator.taskmaster.status.aborted' => '中止',
			'chat.orchestrator.gate.timedOut' => 'タイムアウト',
			'chat.orchestrator.gate.exit' => ({required Object code}) => '終了コード ${code}',
			'chat.tools.settings' => 'ツール設定',
			'chat.tools.error' => 'ツールエラー',
			'chat.tools.result' => 'ツール結果',
			'chat.tools.viewParams' => '入力パラメータを表示',
			'chat.tools.viewRawParams' => '生パラメータを表示',
			'chat.tools.viewDiff' => '編集差分を表示:',
			'chat.tools.creatingFile' => '新規ファイルを作成:',
			'chat.tools.updatingTodo' => 'Todoリストを更新中',
			'chat.tools.read' => '読み取り',
			'chat.tools.readFile' => 'ファイルを読み取り',
			'chat.tools.updateTodo' => 'Todoリストを更新',
			'chat.tools.readTodo' => 'Todoリストを読み取り',
			'chat.tools.searchResults' => '件の結果',
			'chat.tools.todoReadLabel' => 'TodoRead 読み取りリスト',
			'chat.search.found' => ({required Object count, required Object type}) => '${count}件の${type}が見つかりました',
			'chat.search.file' => 'ファイル',
			'chat.search.files' => 'ファイル',
			'chat.search.pattern' => 'パターン:',
			'chat.search.kIn' => '場所:',
			'chat.fileOperations.updated' => 'ファイルを更新しました',
			'chat.fileOperations.created' => 'ファイルを作成しました',
			'chat.fileOperations.written' => 'ファイルを書き込みました',
			'chat.fileOperations.diff' => '差分',
			'chat.fileOperations.newFile' => '新規ファイル',
			'chat.fileOperations.viewContent' => 'ファイルの内容を表示',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => '全出力を表示（${count}文字）',
			'chat.fileOperations.contentDisplayed' => 'ファイルの内容は上の差分ビューに表示されています',
			'chat.interactive.title' => 'インタラクティブプロンプト',
			'chat.interactive.waiting' => 'CLIでの応答を待っています',
			'chat.interactive.instruction' => 'Claudeが実行されているターミナルでオプションを選択してください。',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claudeがオプション${number}を選択しました',
			'chat.interactive.instructionDetail' => 'CLIでは、矢印キーまたは番号を入力してオプションを選択します。',
			'chat.thinking.title' => '思考中...',
			'chat.thinking.emoji' => '💭 思考中...',
			'chat.thinking.thoughtFewSeconds' => '数秒間思考しました',
			'chat.json.response' => 'JSONレスポンス',
			'chat.permissions.grant' => ({required Object tool}) => '${tool}に権限を付与',
			'chat.permissions.added' => '権限を追加しました',
			'chat.permissions.addTo' => ({required Object entry}) => '${entry}を許可されたツールに追加します。',
			'chat.permissions.retry' => '権限を保存しました。ツールを使用するにはリクエストを再試行してください。',
			'chat.permissions.error' => '権限を更新できませんでした。もう一度お試しください。',
			'chat.permissions.openSettings' => '設定を開く',
			'chat.permissions.allow' => '許可',
			'chat.permissions.always' => '常に',
			'chat.permissions.editAndAllow' => '編集して許可',
			'chat.permissions.deny' => '拒否',
			'chat.permissions.reject' => '却下',
			'chat.permissions.allowAll' => ({required Object count}) => 'すべて許可 (${count})',
			'chat.permissions.editInput' => '入力を編集',
			'chat.permissions.invalidJson' => '無効なJSON',
			'chat.permissions.allowWithChanges' => '変更を加えて許可',
			'chat.permissions.alwaysDeny' => '常に拒否',
			'chat.permissions.denyFeedbackTitle' => 'プランを却下',
			'chat.permissions.denyFeedbackHint' => 'エージェントに何を変更してほしいですか？（任意）',
			'chat.permissions.denyReasonTitle' => 'この操作を拒否',
			'chat.permissions.denyReasonHint' => '理由や代わりにしてほしいことをエージェントに伝えてください（任意）',
			'chat.permissions.modeAppliesNextMessage' => '新しい権限モードは次のメッセージから適用されます。',
			'chat.todo.updated' => 'Todoリストを更新しました',
			'chat.todo.current' => '現在のTodoリスト',
			'chat.plan.viewPlan' => '📋 実装プランを表示',
			'chat.plan.title' => '実装プラン',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claudeの使用制限に達しました。制限は**${time} ${timezone}** - ${date}にリセットされます',
			'chat.codex.permissionMode' => '権限モード',
			'chat.codex.modes.kDefault' => 'デフォルトモード',
			'chat.codex.modes.auto' => '自動モード',
			'chat.codex.modes.acceptEdits' => '編集を許可',
			'chat.codex.modes.bypassPermissions' => '権限をバイパス',
			'chat.codex.modes.plan' => 'プランモード',
			'chat.codex.descriptions.kDefault' => '信頼されたコマンド（ls、cat、grep、git statusなど）のみ自動実行。その他のコマンドはスキップ。ワークスペースへの書き込みは可能。',
			'chat.codex.descriptions.auto' => 'モデル分類器がツール呼び出しごとに承認または拒否を決定します。高い自律性。',
			'chat.codex.descriptions.acceptEdits' => 'ワークスペース内ですべてのコマンドを自動実行。サンドボックス環境での完全自動モード。',
			'chat.codex.descriptions.bypassPermissions' => '制限なしの完全なシステムアクセス。すべてのコマンドがディスクとネットワークへの完全なアクセスで自動実行されます。注意して使用してください。',
			'chat.codex.descriptions.plan' => 'プランニングモード - コマンドは実行されません',
			'chat.codex.technicalDetails' => '技術的な詳細',
			'chat.voice.autoRead' => '返信を読み上げる',
			'chat.voice.autoReadOn' => '返信の読み上げ: オン',
			'chat.voice.autoReadOff' => '返信の読み上げ: オフ',
			'chat.voice.autoReadVoice' => '読み上げ音声',
			'chat.voice.autoReadVoiceAuto' => '自動音声',
			'chat.voice.autoReadPreview' => '返信はこのように読み上げられます。',
			'chat.voice.speakMessage' => '読み上げ',
			'chat.voice.stopSpeaking' => '読み上げを停止',
			'chat.input.placeholder' => ({required Object provider}) => '/ でコマンド、@ でファイル指定、または ${provider} に何でも聞いてください...',
			'chat.input.placeholderDefault' => 'メッセージを入力...',
			'chat.input.disabled' => '入力無効',
			'chat.input.attachFiles' => 'ファイルを添付',
			'chat.input.attachFilesDesc' => '写真、ファイル、ドキュメントをアップロード',
			'chat.input.takePhoto' => '写真を撮る',
			'chat.input.takePhotoDesc' => 'カメラで写真を撮影',
			'chat.input.moreTools' => 'その他のツール',
			'chat.input.commandsDesc' => 'ショートカットとコマンドを探す',
			'chat.input.clearInputDesc' => '現在のテキストを破棄',
			'chat.input.attachImages' => '画像を添付',
			'chat.input.send' => '送信',
			'chat.input.stop' => '停止',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enterで送信 • / コマンド • @ ファイル',
			'chat.input.hintText.enter' => 'Enterで送信 • Shift+Enterで改行 • / コマンド • @ ファイル',
			'chat.input.hintText.queue' => 'Enterで次のメッセージをキューに入れる',
			'chat.input.hintText.updateQueued' => 'Enterでキュー済みメッセージを更新',
			'chat.input.clickToChangeMode' => 'クリックで権限モードを変更',
			'chat.input.showAllCommands' => 'すべてのコマンドを表示',
			'chat.input.clearInput' => '入力をクリア',
			'chat.input.scrollToBottom' => '一番下へスクロール',
			'chat.input.newMessage' => '新しいメッセージ',
			'chat.input.newMessages' => '新着メッセージ',
			'chat.input.queue.sendNext' => '次のメッセージをキューに入れる',
			'chat.input.queue.update' => 'キュー済みメッセージを更新',
			'chat.input.queue.label' => 'キュー済み',
			'chat.input.queue.willSend' => '完了後に送信されます',
			'chat.input.queue.edit' => 'キュー済みメッセージを編集',
			'chat.input.queue.delete' => 'キュー済みメッセージを削除',
			'chat.input.queue.failed' => '送信に失敗しました',
			'chat.input.queue.sendNow' => '今すぐ送信',
			'chat.input.queue.sendNowAfterTurn' => 'このエージェントはターン中にメッセージを受け付けません。現在のターンの終了後に送信されます',
			'chat.input.queue.filesAttached' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '${count} 件のファイルを添付', ), 
			'chat.input.autoContinueTasks' => '自動続行',
			'chat.input.autoContinueTasksTooltip' => '有効にすると Devin が次の Task Master タスクへ自動的に進みます',
			'chat.input.offlineQueue.clear' => 'キャンセルしてオフラインキューをクリア',
			'chat.input.offlineQueue.clearBtn' => 'キャンセル',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} 件のメッセージがオフラインキューに — 再接続時に自動送信されます',
			'chat.input.offlineQueue.single' => '1 件のメッセージがオフラインキューに — 再接続時に自動送信されます',
			'chat.input.voice' => '音声入力',
			'chat.input.voiceStart' => 'メッセージを音声入力',
			'chat.input.voiceStop' => '音声入力を停止',
			'chat.input.pinFile' => 'ファイルをコンテキストに固定',
			'chat.input.voiceSettings' => '音声設定 (STT)',
			'chat.input.cameraUnavailable' => ({required Object error}) => 'カメラを利用できません: ${error}',
			'chat.composer.toolsAndActions' => 'ツールとアクション',
			'chat.composer.toolsAndActionsDesc' => 'チャット入力欄のツールとコントロール',
			'chat.composer.reasoning' => '推論',
			'chat.composer.model' => 'モデル',
			'chat.composer.effortDefault' => 'デフォルト',
			'chat.composer.loadingModels' => 'モデルを読み込み中…',
			'chat.composer.modelMenu' => 'モデルと推論レベルを選択',
			'chat.composer.permissionHeading' => ({required Object provider}) => '${provider} のアクションをどのように承認しますか？',
			'chat.composer.favorites' => 'お気に入り',
			'chat.composer.account' => 'アカウント',
			'chat.composer.accountMenu' => 'アカウントを選択',
			'chat.composer.accountDefault' => 'デフォルトアカウント',
			'chat.composer.accountAuto' => '自動 (デフォルト)',
			'chat.composer.accountIsDefault' => 'デフォルト',
			'chat.composer.effortLevels.off' => 'オフ',
			'chat.composer.effortLevels.none' => 'なし',
			'chat.composer.effortLevels.minimal' => '最小',
			'chat.composer.effortLevels.low' => '低',
			'chat.composer.effortLevels.medium' => '中',
			'chat.composer.effortLevels.high' => '高',
			'chat.composer.effortLevels.xhigh' => '非常に高い',
			'chat.composer.effortLevels.max' => '最大',
			'chat.composer.effortLevels.ultra' => 'ウルトラ',
			'chat.composer.contextWindow' => ({required Object size}) => 'コンテキスト ${size}',
			'chat.composer.accountAutoShort' => '自動',
			'chat.composer.uploadNoRecords' => 'アップロード結果にファイルが含まれていません',
			'chat.providerSelection.title' => 'AIアシスタントを選択',
			'chat.providerSelection.description' => '新しい会話を始めるプロバイダーを選択してください',
			'chat.providerSelection.selectModel' => 'モデルを選択',
			'chat.providerSelection.workspace' => 'ワークスペース',
			'chat.providerSelection.noWorkspace' => 'なし',
			'chat.providerSelection.clickToChangeWorkspace' => 'クリックしてワークスペースを変更',
			'chat.providerSelection.chooseWorkspace' => 'ワークスペースを選択',
			'chat.providerSelection.searchWorkspaces' => 'ワークスペースを検索...',
			'chat.providerSelection.noWorkspacesFound' => 'ワークスペースが見つかりません。',
			'chat.providerSelection.providerInfo.anthropic' => 'by Anthropic',
			'chat.providerSelection.providerInfo.openai' => 'by OpenAI',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AIコードエディタ',
			'chat.providerSelection.providerInfo.google' => 'by Google',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => '${model}でClaudeを使用する準備ができました。下にメッセージを入力してください。',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => '${model}でCursorを使用する準備ができました。下にメッセージを入力してください。',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => '${model}でCodexを使用する準備ができました。下にメッセージを入力してください。',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => '${model} で OpenCode を使用できます。下にメッセージを入力してください。',
			'chat.providerSelection.readyPrompt.kDefault' => '上からプロバイダーを選択して開始してください',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Devin ${model} の準備完了',
			'chat.providerSelection.readyPrompt.orchestrator' => 'Auto で準備完了 — ルーターがステップごとに最適なモデルを選びます',
			'chat.providerSelection.autoGroup' => 'Auto',
			'chat.providerSelection.autoLabel' => 'Auto (オーケストレーション)',
			'chat.providerSelection.autoDescription' => '各ステップを利用可能な最適なプロバイダーとモデルにルーティングします',
			'chat.providerSelection.orchestrated' => 'オーケストレーション',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => '<kbd>${shortcut}</kbd> を押してセッション、ファイル、コミットを検索',
			'chat.providerSelection.all' => 'すべて',
			'chat.providerSelection.free' => '無料',
			'chat.providerSelection.noModelsFound' => 'モデルが見つかりません。',
			'chat.providerSelection.paid' => '有料',
			'chat.providerSelection.searchModels' => 'モデルを検索...',
			'chat.providerSelection.addModel' => 'モデルを追加',
			'chat.providerSelection.chooseModel' => 'モデルを選択',
			'chat.providerSelection.chooseModelDescription' => '組み込みとカスタムモデルを一つのリストに',
			'chat.providerSelection.clickToChange' => 'クリックしてモデルを変更',
			'chat.providerSelection.favorites' => 'お気に入り',
			'chat.providerSelection.loadingModels' => 'モデルを読み込み中…',
			'chat.providerSelection.manageModels' => 'モデルを管理',
			'chat.providerSelection.refresh' => 'モデルを更新',
			'chat.session.kContinue.title' => '会話を続ける',
			'chat.session.kContinue.description' => 'コードについて質問したり、変更をリクエストしたり、開発タスクのサポートを受けられます',
			'chat.session.kContinue.action' => '入力を続ける',
			'chat.session.loading.olderMessages' => '過去のメッセージを読み込んでいます...',
			'chat.session.loading.sessionMessages' => 'セッションメッセージを読み込んでいます...',
			'chat.session.messages.showingOf' => ({required Object total, required Object shown}) => '${total}件中${shown}件を表示',
			'chat.session.messages.scrollToLoad' => '上にスクロールしてさらに読み込む',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => '最新${count}件を表示（全${total}件）',
			'chat.session.messages.loadEarlier' => '過去のメッセージを読み込む',
			'chat.session.messages.loadOlderFailed' => '古いメッセージの読み込みに失敗しました。',
			'chat.session.messages.retry' => '再試行',
			'chat.session.messages.loadAll' => 'すべてのメッセージを読み込む',
			'chat.session.messages.loadingAll' => 'すべてのメッセージを読み込み中...',
			'chat.session.messages.allLoaded' => 'すべてのメッセージを読み込みました',
			'chat.session.messages.perfWarning' => 'すべてのメッセージを読み込みました — スクロールが遅くなる場合があります。「一番下へスクロール」をクリックしてください。',
			'chat.session.messages.noSearchMatches' => '検索に一致するメッセージがありません。',
			'chat.session.messages.loadOlder' => '過去のメッセージを読み込む',
			'chat.session.messages.loadAllCount' => ({required Object count}) => 'すべて読み込む (${count})',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => '過去のメッセージの読み込みを再試行 — ${error}',
			'chat.session.deleteConfirm' => 'セッションとそのトランスクリプトを削除します。元に戻せません。',
			'chat.session.finishRunBeforeWorkspaceChange' => 'ワークスペースを変更する前に実行を終了してください',
			'chat.session.fallbackTitle' => 'セッション',
			'chat.session.missing.message' => 'このセッションは接続中のサーバーに存在しません。',
			'chat.session.missing.action' => '別のセッションを選択',
			'chat.shell.selectProject.title' => 'プロジェクトを選択',
			'chat.shell.selectProject.description' => 'プロジェクトを選択してそのディレクトリでシェルを開きます',
			'chat.shell.status.newSession' => '新しいセッション',
			'chat.shell.status.initializing' => '初期化中...',
			'chat.shell.status.restarting' => '再起動中...',
			'chat.shell.actions.disconnect' => '切断',
			'chat.shell.actions.disconnectTitle' => 'シェルから切断',
			'chat.shell.actions.restart' => '再起動',
			'chat.shell.actions.restartTitle' => 'シェルを再起動（先に切断してください）',
			'chat.shell.actions.kill' => '終了 (SIGINT)',
			'chat.shell.actions.killTitle' => '実行中のプロセスを終了 (Ctrl+C)',
			'chat.shell.actions.copyOutput' => '出力をコピー',
			'chat.shell.actions.copyOutputTitle' => 'ターミナル出力をコピー',
			'chat.shell.actions.copied' => 'コピーしました！',
			'chat.shell.actions.zoomInTitle' => '拡大',
			'chat.shell.actions.zoomOutTitle' => '縮小',
			'chat.shell.actions.connect' => 'シェルで続行',
			'chat.shell.actions.connectTitle' => 'シェルに接続',
			'chat.shell.loading' => 'ターミナルを読み込んでいます...',
			'chat.shell.connecting' => 'シェルに接続しています...',
			'chat.shell.startSession' => '新しいClaudeセッションを開始',
			'chat.shell.resumeSession' => ({required Object displayName}) => 'セッションを再開: ${displayName}...',
			'chat.shell.runCommand' => ({required Object projectName, required Object command}) => '${projectName}で${command}を実行',
			'chat.shell.startCli' => ({required Object projectName}) => '${projectName}でClaude CLIを起動しています',
			'chat.shell.defaultCommand' => 'コマンド',
			'chat.claudeStatus.actions.thinking' => '思考中',
			'chat.claudeStatus.actions.processing' => '処理中',
			'chat.claudeStatus.actions.analyzing' => '分析中',
			'chat.claudeStatus.actions.working' => '作業中',
			'chat.claudeStatus.actions.computing' => '計算中',
			'chat.claudeStatus.actions.reasoning' => '推論中',
			'chat.claudeStatus.state.live' => 'ライブ',
			'chat.claudeStatus.state.paused' => '一時停止',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}秒',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '経過 ${time}',
			'chat.claudeStatus.elapsed.startingNow' => '今開始',
			'chat.claudeStatus.stop' => '停止',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: 'バックグラウンドタスク ${count} 件を実行中', other: 'バックグラウンドタスク ${count} 件を実行中', ), 
			'chat.claudeStatus.controls.stopGeneration' => '生成を停止',
			'chat.claudeStatus.controls.pressEscToStop' => 'Escキーでいつでも停止',
			'chat.claudeStatus.providers.assistant' => 'アシスタント',
			'chat.claudeStatus.backgroundTasksTitle' => 'バックグラウンドで実行中',
			'chat.claudeStatus.backgroundTaskUnnamed' => '名前のないタスク',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => 'プロジェクトを選択して${provider}とのチャットを開始',
			'chat.tasks.nextTaskPrompt' => '次のタスクを開始',
			'chat.splitSession.toggle' => 'セッションを分割',
			'chat.splitSession.close' => '分割セッションを閉じる',
			'chat.splitSession.selectSession' => '比較するセッションを選択',
			'chat.splitSession.noOtherSessions' => '利用できる他のセッションがありません',
			'chat.splitSession.newSessionOption' => '+ 分割ビューで新しいセッション',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => '現在のプロジェクト (${name})',
			'chat.splitSession.otherProjectsGroup' => 'その他のプロジェクト',
			'chat.splitSession.recentSessionsGroup' => '最近のセッション',
			'chat.splitSession.startNewSession' => '分割ビューで新しいセッションを開始',
			'chat.splitSession.selectFromList' => '既存セッションの一覧から選択',
			'chat.sessionPicker.title' => 'セッションを選択',
			'chat.sessionPicker.searchPlaceholder' => 'セッションを検索...',
			'chat.sessionPicker.clearSearch' => '検索をクリア',
			'chat.sessionPicker.newChat' => '+ 新しいチャット',
			'chat.sessionPicker.archivedToggle' => 'アーカイブ済み',
			'chat.sessionPicker.changeSession' => 'セッションを変更',
			'chat.sessionPicker.archivedLoading' => 'アーカイブ済みセッションを読み込み中...',
			'chat.sessionPicker.archivedError' => 'アーカイブ済みセッションを読み込めませんでした',
			'chat.sessionPicker.archivedEmpty' => 'アーカイブ済みセッションはありません',
			'chat.sessionPicker.archivedProjectOnly' => 'ワークスペースはアーカイブされています — セッションを見るには復元してください。',
			'chat.sessionPicker.emptySearch' => '検索に一致するセッションがありません',
			'chat.sessionPicker.restore' => '復元',
			'chat.sessionPicker.restoreSession' => 'セッションを復元',
			'chat.sessionPicker.restoreProject' => 'ワークスペースを復元',
			'chat.sessionPicker.restoreSessionFailed' => 'セッションの復元に失敗しました。もう一度お試しください。',
			'chat.sessionPicker.restoreProjectFailed' => 'ワークスペースの復元に失敗しました。もう一度お試しください。',
			'chat.sessionPicker.archiveFailed' => 'セッションのアーカイブに失敗しました。もう一度お試しください。',
			'chat.sessionPicker.deleteFailed' => 'セッションの削除に失敗しました。もう一度お試しください。',
			'chat.sessionPicker.running' => 'セッション実行中',
			'chat.sessionPicker.unread' => '未読 — 新しい出力ありで終了',
			'chat.sessionPicker.account' => 'アカウント',
			'chat.splitWorkspace.addChat' => 'チャットペインを追加',
			'chat.splitWorkspace.addBrowser' => 'ブラウザペインを追加',
			'chat.splitWorkspace.addTerminal' => 'ターミナルペインを追加',
			'chat.splitWorkspace.addPreview' => 'プレビューペインを追加',
			'chat.splitWorkspace.overview' => 'すべてのペインを表示',
			'chat.splitWorkspace.exitFocusMode' => 'フォーカスモードを終了 (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => 'フォーカスモード (Ctrl+Shift+F)',
			'chat.splitWorkspace.broadcast' => 'セッションに一斉送信',
			'chat.splitWorkspace.addNotes' => '共有メモペインを追加',
			'chat.splitWorkspace.browseSessions' => 'セッション一覧を開く',
			'chat.splitOverview.title' => '分割ペインの概要',
			'chat.splitOverview.count' => ({required Object count}) => '${count} ペイン',
			'chat.splitOverview.close' => '概要を閉じる',
			'chat.splitOverview.question' => '質問 — 入力が必要です',
			'chat.splitOverview.processing' => '処理中',
			'chat.splitOverview.idle' => 'アイドル',
			'chat.splitOverview.active' => 'アクティブ',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} があなたの入力を求めています',
			'chat.askUserQuestion.skip' => 'スキップ',
			'chat.askUserQuestion.other' => 'その他…',
			'chat.askUserQuestion.answerHint' => '回答を入力…',
			'chat.attachments.downloadFailedRetry' => 'ダウンロード失敗 — クリックで再試行',
			'chat.attachments.fileAttachment' => 'ファイル添付',
			'chat.attachments.download' => ({required Object name}) => '${name} をダウンロード',
			'chat.attachments.attachedFile' => '添付ファイル',
			'chat.attachments.downloaded' => ({required Object name}) => '${name} をダウンロードしました',
			'chat.checkpoint.creating' => 'スナップショットを作成中…',
			'chat.checkpoint.revertChanges' => 'ファイルを最後のチェックポイントに戻す',
			'chat.checkpoint.undo' => 'チェックポイントを元に戻す',
			'chat.checkpoint.undoAiRun' => 'AI の実行を元に戻す',
			'chat.checkpoint.undoing' => '元に戻しています…',
			'chat.checkpoint.undone' => '元に戻しました',
			'chat.checkpoint.beforeAiTurn' => 'AIターン前',
			'chat.common.close' => '閉じる',
			'chat.taskMaster.saveToTask' => 'タスク',
			'chat.taskMaster.saved' => '保存済み',
			'chat.taskMaster.saving' => '保存中...',
			'chat.taskMaster.taskShort' => 'タスク',
			'chat.taskMaster.addToTask' => 'TaskMasterに追加',
			'chat.taskMaster.added' => 'TaskMasterに追加しました',
			'chat.taskMaster.defaultTaskTitle' => 'チャットからのタスク',
			'chat.tokenUsage.desc' => 'セッションのトークン消費を表示',
			'chat.tokenUsage.title' => 'トークン使用量',
			'chat.tokenUsage.notAvailable' => 'なし',
			'chat.tokenUsage.tokensBadge' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '${count} トークン', ), 
			'chat.tool.emptyResult' => '(まだ出力なし — ツールは空の結果を返しました)',
			'chat.quotaBadge.ariaLabel' => 'サブスクリプションの上限',
			'chat.quotaBadge.noData' => 'このモデルのサブスクリプションデータがありません',
			'chat.quotaBadge.noSubscription' => 'サブスクリプションなし',
			'chat.quotaBadge.windowLineReset' => ({required Object label, required Object percent, required Object time}) => '${label}: ${percent}% · リセット ${time}',
			'chat.quotaBadge.windowRemaining' => ({required Object percent}) => 'リセットまでウィンドウの残り ${percent}%',
			'chat.broadcast.title' => 'セッションに一斉送信',
			'chat.broadcast.noSessions' => '利用できるセッションがありません',
			'chat.broadcast.placeholder' => '選択したすべてのセッションに送るメッセージ…',
			'chat.broadcast.partial' => ({required Object count}) => '${count} 件のセッションがメッセージを拒否しました',
			'chat.broadcast.sent' => ({required Object count}) => '${count} 件のセッションのキューに追加しました',
			'chat.broadcast.selectAll' => 'すべて選択',
			'chat.broadcast.selectOrchestrators' => 'オーケストレーターを選択',
			'chat.broadcast.orchestratorsOnly' => 'オーケストレーターのみ',
			'chat.broadcast.noOrchestrators' => '利用可能なオーケストレーターセッションがありません',
			'chat.broadcast.sending' => '送信中…',
			'chat.broadcast.send' => ({required Object count}) => '${count} 件に送信',
			'chat.paneHeader.processing' => '処理中…',
			'chat.paneHeader.switchSession' => 'セッションを切り替え',
			'chat.export.sessionTitle' => ({required Object id}) => 'セッション ${id}',
			'chat.export.pdfFailed' => 'PDFのエクスポートに失敗しました',
			'chat.export.transcriptDownloaded' => 'トランスクリプトをダウンロードしました',
			'chat.export.savedTo' => ({required Object path}) => '${path} を保存しました',
			'chat.commandResult.fallback.models' => 'アクティブなプロバイダーで利用可能なモデルを参照します。',
			'chat.commandResult.fallback.cost' => 'アクティブなセッションのトークン使用量を確認します。',
			'chat.commandResult.fallback.status' => 'ランタイム、バージョン、プロバイダー、環境のステータスを確認します。',
			'chat.commandResult.fallback.memory' => 'プロジェクトのCLAUDE.mdメモリファイルを開きます。',
			'chat.commandResult.fallback.config' => '設定と構成を開きます。',
			'chat.commandResult.fallback.help' => 'コマンドのドキュメントと構文を表示します。',
			'chat.commandResult.filterCommands' => 'コマンドを絞り込む...',
			'chat.commandResult.searchModels' => ({required Object provider}) => '${provider} のモデルを検索...',
			'chat.commands.runConfirmTitle' => 'コマンドを実行しますか？',
			'chat.commands.executionCancelled' => 'コマンドの実行をキャンセルしました',
			'chat.commands.bashConfirmMessage' => 'このコマンドには実行される bash コマンドが含まれています。続行しますか？',
			'chat.commands.proceed' => '続行',
			'chat.pinFile.title' => 'ファイルをピン留め',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.action' => 'ピン留め',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => '${name} を編集',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => '${name} を削除',
			'chat.modelLibrary.enterNameAndId' => 'モデル名とモデルIDの両方を入力してください。',
			'chat.modelLibrary.idNoSpaces' => 'モデルIDにスペースは使用できません。',
			'chat.modelLibrary.setAsDefault' => 'デフォルトに設定',
			'chat.modelLibrary.defaultModel' => 'デフォルトモデル',
			'chat.modelLibrary.title' => 'モデルライブラリ',
			'chat.modelLibrary.subtitle' => 'プロバイダーがサポートするモデル ID を追加します。組み込みモデルはロックされたままです。丸印はデフォルトモデルを示します。',
			'chat.modelLibrary.yourModels' => 'あなたのモデル',
			'chat.modelLibrary.yourModelsHint' => '編集可能、auth.db に保存',
			'chat.modelLibrary.emptyTitle' => 'カスタムモデルはまだありません',
			'chat.modelLibrary.emptyHint' => 'フォームから追加すると、すべてのモデル選択に表示されます。',
			'chat.modelLibrary.builtInModels' => '組み込みモデル',
			'chat.modelLibrary.builtInModelsHint' => 'DDAgent が管理する読み取り専用モデル',
			'chat.modelLibrary.editTitle' => 'カスタムモデルを編集',
			'chat.modelLibrary.addTitle' => 'カスタムモデルを追加',
			'chat.modelLibrary.idSentAsWritten' => ({required Object provider}) => 'ID は入力どおりに ${provider} へ送信されます。',
			'chat.modelLibrary.nameLabel' => 'モデル名',
			'chat.modelLibrary.nameHint' => '例: GPT-5.5 Pro',
			'chat.modelLibrary.idLabel' => 'モデル ID',
			'chat.modelLibrary.idHint' => '例: gpt-5.5-pro',
			'chat.modelLibrary.idHelp' => 'プロバイダー CLI が受け付ける識別子をそのまま使用してください。ID にスペースは使用できません。',
			'chat.modelLibrary.updatedNotice' => ({required Object name}) => '${name} を更新しました。',
			'chat.modelLibrary.addedNotice' => ({required Object name}) => '${name} を追加しました。',
			_ => null,
		} ?? switch (path) {
			'chat.modelLibrary.deletedNotice' => ({required Object name}) => '${name} を削除しました。',
			'chat.modelLibrary.saving' => '保存中…',
			'chat.modelLibrary.saveChanges' => '変更を保存',
			'chat.modelLibrary.deleteConfirm' => 'このモデルをすべての選択肢から削除しますか？',
			'chat.modelLibrary.customBadge' => 'カスタム',
			'chat.changes.failedToLoad' => '変更の読み込みに失敗しました',
			'chat.changes.empty' => 'ファイルの変更はありません',
			'chat.message.compactedSummary' => '圧縮された要約',
			'chat.message.resendHint' => '入力欄から再送信',
			'chat.message.rawView' => '生の表示',
			'chat.message.runComplete' => '実行完了',
			'chat.message.runStopped' => '停止しました',
			'chat.message.runFailed' => ({required Object code}) => '実行に失敗しました（終了コード ${code}）',
			'chat.message.taskKilled' => '強制終了',
			'chat.permissionRequest.title' => ({required Object tool}) => '権限リクエスト · ${tool}',
			'chat.permissionRequest.question' => '質問',
			'chat.permissionRequest.subagent' => 'サブエージェント',
			'chat.permissionRequest.viewersCannotApprove' => '閲覧者は承認できません',
			'chat.permissionRequest.recap.timedOut' => 'タイムアウト — 自動的に拒否されました',
			'chat.permissionRequest.recap.cancelled' => 'キャンセル — ターンが停止されました',
			'chat.permissionRequest.recap.autoApproved' => '自動的に承認されました',
			'chat.permissionRequest.recap.expired' => 'リクエストの有効期限切れ — エージェントはもう待機していません',
			'chat.permissionRequest.recap.answered' => '回答済み',
			'chat.permissionRequest.recap.skipped' => 'スキップ済み',
			'chat.permissionRequest.recap.decided' => '決定済み',
			'chat.permissionRequest.needsApproval' => ({required Object tool}) => '${tool} の承認が必要です',
			'chat.permissionRequest.subagentNeedsApproval' => ({required Object tool}) => 'サブエージェント: ${tool} の承認が必要です',
			'chat.permissionRequest.moreQuestions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: 'ほかに ${count} 件の質問が待機中', ), 
			'chat.commandDialog.help.eyebrow' => 'コマンドセンター',
			'chat.commandDialog.help.title' => 'ヘルプとショートカット',
			'chat.commandDialog.help.subtitle' => '組み込みコマンド、構文パターン、使い方を検索します。',
			'chat.commandDialog.models.eyebrow' => 'モデルの選択',
			'chat.commandDialog.models.title' => 'モデルを選択',
			'chat.commandDialog.models.subtitle' => 'このプロバイダーで使用するモデルを選択します。',
			'chat.commandDialog.models.modelSetTo' => ({required Object model}) => 'モデルを ${model} に設定しました。',
			'chat.commandDialog.models.activeModel' => '使用中のモデル',
			'chat.commandDialog.models.noModelsMatch' => 'このフィルターに一致するモデルはありません。',
			'chat.commandDialog.models.choiceSavedForSession' => '選択はこのセッションに保存され、新しいチャットの既定になります。',
			'chat.commandDialog.models.choiceDefault' => '選択したモデルが新しいチャットの既定になります。',
			'chat.commandDialog.models.custom' => 'カスタム',
			'chat.commandDialog.models.currentSelection' => '現在の選択',
			'chat.commandDialog.cost.eyebrow' => 'セッションのテレメトリ',
			'chat.commandDialog.cost.title' => 'トークン使用量',
			'chat.commandDialog.cost.subtitle' => 'このセッションの入力・出力・合計トークン数。',
			'chat.commandDialog.cost.totalTokensUsed' => '使用トークン合計',
			'chat.commandDialog.cost.inputTokens' => '入力トークン',
			'chat.commandDialog.cost.cacheReadTokens' => 'キャッシュ読み取りトークン',
			'chat.commandDialog.cost.cacheWriteTokens' => 'キャッシュ書き込みトークン',
			'chat.commandDialog.cost.outputTokens' => '出力トークン',
			'chat.commandDialog.cost.breakdown' => '内訳',
			'chat.commandDialog.cost.unavailable' => '利用不可',
			'chat.commandDialog.cost.contextWindow' => 'コンテキストウィンドウ',
			'chat.commandDialog.cost.estimatedCost' => '推定コスト',
			'chat.commandDialog.status.eyebrow' => 'ランタイムの状態',
			'chat.commandDialog.status.title' => 'システムの状態',
			'chat.commandDialog.status.subtitle' => 'バージョン、プロバイダー、ランタイム、環境の詳細。',
			'chat.commandDialog.status.package' => 'パッケージ',
			'chat.commandDialog.status.uptime' => '稼働時間',
			'chat.commandDialog.status.platform' => 'プラットフォーム',
			'chat.commandDialog.status.memory' => 'メモリ',
			'chat.commandDialog.status.memoryRss' => ({required Object mb}) => '${mb} MB RSS',
			'chat.commandDialog.status.runtimeOnline' => 'ランタイムはオンラインです',
			'chat.commandDialog.status.processResponding' => ({required Object pid}) => 'プロセス #${pid} は応答しています。',
			'chat.commandDialog.status.processStatusResponding' => 'プロセスは応答しています。',
			'chat.commandDialog.status.healthy' => '正常',
			'chat.commandDialog.defaultEyebrow' => 'コマンド',
			'chat.commandDialog.defaultTitle' => 'コマンドの結果',
			'chat.commandDialog.escHint' => 'Esc でこのウィンドウを閉じます。',
			'chat.commandDialog.unknown' => '不明',
			'chat.commandDialog.noDescription' => '説明はありません。',
			'chat.commandDialog.noCommandsMatch' => 'このフィルターに一致するコマンドはありません。',
			'chat.commandDialog.syntax.title' => '構文',
			'chat.commandDialog.syntax.arguments' => ({required Object arguments, required Object first, required Object second}) => '${arguments} はすべての引数を渡します。${first}、${second} は位置引数です。',
			'chat.commandDialog.syntax.file' => ({required Object token}) => '${token} はファイルの内容を含めます。',
			'chat.commandDialog.syntax.bash' => ({required Object token}) => '${token} は bash を実行します。',
			'chat.commandDialog.commandFinished' => 'コマンドが完了しました。',
			'chat.utilities.tokenUsageUnavailable' => 'トークン使用量は利用できません',
			'chat.utilities.tooltip.tokensUsed' => ({required Object tokens}) => '${tokens} トークン使用',
			'chat.utilities.tooltip.contextOf' => ({required Object total, required Object percent}) => 'コンテキスト ${total} 中 ${percent}%',
			'chat.utilities.tooltip.input' => ({required Object value}) => '入力 ${value}',
			'chat.utilities.tooltip.cache' => ({required Object read, required Object write}) => 'キャッシュ読み取り ${read} · 書き込み ${write}',
			'chat.utilities.tooltip.output' => ({required Object value}) => '出力 ${value}',
			'chat.utilities.used' => '使用済み',
			'chat.utilities.cacheWrite' => 'キャッシュ書き込み',
			'chat.utilities.contextLabel' => 'コンテキスト',
			'chat.utilities.usageUnsupported' => '使用量は非対応',
			'chat.utilities.chatTranscript' => 'チャットの記録',
			'chat.utilities.you' => 'あなた:',
			'chat.utilities.providerAutoMini' => '自動 (mini)',
			'chat.toolBlocks.moreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '… 残り ${count} 行', ), 
			'chat.toolBlocks.status.running' => '実行中',
			'chat.toolBlocks.status.denied' => '拒否',
			'chat.toolBlocks.showLess' => '表示を減らす',
			'chat.toolBlocks.showMore' => 'さらに表示',
			'chat.toolBlocks.showMoreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: 'さらに ${count} 行を表示', ), 
			'chat.toolBlocks.tools' => 'ツール',
			'chat.toolBlocks.planReview' => 'プランのレビュー',
			'chat.toolBlocks.planUpdate' => 'プランの更新',
			'chat.toolBlocks.todoListUpdated' => 'ToDo リストを更新しました',
			'chat.toolBlocks.creatingTask' => 'タスクを作成中',
			'chat.toolBlocks.updatingTask' => '更新中',
			'chat.toolBlocks.fetchingTask' => '取得中',
			'chat.toolBlocks.listingTasks' => 'タスクを一覧表示中',
			'chat.toolBlocks.search' => '検索',
			'chat.toolBlocks.verbs.read' => '読み取り',
			'chat.toolBlocks.verbs.write' => '書き込み',
			'chat.toolBlocks.verbs.edit' => '編集',
			'chat.toolBlocks.verbs.delete' => '削除',
			'chat.toolBlocks.verbs.move' => '移動',
			'chat.toolBlocks.subagent' => 'サブエージェント',
			'chat.toolBlocks.toolCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '${count} 個のツール', ), 
			'chat.toolBlocks.result' => '結果',
			'chat.toolBlocks.plusMore' => ({required Object count}) => '+${count} 件',
			'chat.toolBlocks.plan' => 'プラン',
			'chat.toolBlocks.questionProgress' => ({required Object current, required Object total}) => '質問 ${current}/${total}',
			'chat.toolBlocks.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '${count} 行', ), 
			'chat.toolBlocks.todoListItems' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: 'ToDo リスト (${count} 件)', ), 
			'chat.toolBlocks.tasksCompleted' => ({required Object done, required Object total}) => '${done}/${total} 完了',
			'chat.commandMenu.empty' => '利用できるコマンドはありません',
			'chat.commandMenu.namespaces.frequent' => 'よく使うコマンド',
			'chat.commandMenu.namespaces.builtin' => '組み込みコマンド',
			'chat.commandMenu.namespaces.skill' => 'スキル',
			'chat.commandMenu.namespaces.project' => 'プロジェクトコマンド',
			'chat.commandMenu.namespaces.user' => 'ユーザーコマンド',
			'chat.commandMenu.namespaces.other' => 'その他のコマンド',
			'chat.mentionMenu.kinds.file' => 'ファイル',
			'chat.mentionMenu.kinds.session' => 'セッション',
			'chat.mentionMenu.kinds.task' => 'タスク',
			'chat.mentionMenu.taskTitle' => ({required Object id}) => 'タスク ${id}',
			'chat.subheader.contextTooltip' => ({required Object used, required Object total, required Object percent}) => 'コンテキスト: ${used} / ${total} トークン · ${percent}% 使用',
			'chat.transcript.requestFailed' => 'リクエストに失敗しました',
			'chat.review.changedFiles' => '変更されたファイル',
			'chat.review.changedFilesCount' => ({required Object count}) => '変更されたファイル (${count})',
			'chat.review.subagent' => 'サブエージェント',
			'codeEditor.toolbar.changes' => '件の変更',
			'codeEditor.toolbar.previousChange' => '前の変更',
			'codeEditor.toolbar.nextChange' => '次の変更',
			'codeEditor.toolbar.hideDiff' => '差分ハイライトを非表示',
			'codeEditor.toolbar.showDiff' => '差分ハイライトを表示',
			'codeEditor.toolbar.settings' => 'エディタ設定',
			'codeEditor.toolbar.collapse' => 'エディタを折りたたむ',
			'codeEditor.toolbar.expand' => 'エディタを全幅に展開',
			'codeEditor.toolbar.toggleDock' => 'ファイルドックを切り替え',
			'codeEditor.toolbar.diffMerge' => '差分 / マージ',
			'codeEditor.toolbar.previewInBrowser' => 'ブラウザでプレビュー',
			'codeEditor.toolbar.reload' => 'ディスクから再読み込み',
			'codeEditor.loading' => ({required Object fileName}) => '${fileName}を読み込んでいます...',
			'codeEditor.header.showingChanges' => '変更を表示中',
			'codeEditor.actions.copyPath' => 'ファイルパスをコピー',
			'codeEditor.actions.pathCopied' => 'ファイルパスをコピーしました',
			'codeEditor.actions.download' => 'ファイルをダウンロード',
			'codeEditor.actions.save' => '保存',
			'codeEditor.actions.saving' => '保存中...',
			'codeEditor.actions.saved' => '保存しました！',
			'codeEditor.actions.exitFullscreen' => '全画面を終了',
			'codeEditor.actions.fullscreen' => '全画面',
			'codeEditor.actions.close' => '閉じる',
			'codeEditor.actions.previewMarkdown' => 'Markdownをプレビュー',
			'codeEditor.actions.editMarkdown' => 'Markdownを編集',
			'codeEditor.actions.pinFile' => 'ファイルをコンテキストにピン留め',
			'codeEditor.actions.unpinFile' => 'ファイルをコンテキストから外す',
			'codeEditor.actions.previewHtml' => 'HTMLプレビューを新しいタブで開く',
			'codeEditor.actions.retry' => '再試行',
			'codeEditor.actions.saveAll' => 'すべて保存',
			'codeEditor.footer.lines' => '行数:',
			'codeEditor.footer.characters' => '文字数:',
			'codeEditor.footer.shortcuts' => 'Ctrl+Sで保存 • Escで閉じる',
			'codeEditor.footer.plainText' => 'プレーンテキスト',
			'codeEditor.footer.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '${count} 行', ), 
			'codeEditor.footer.modified' => '変更あり',
			'codeEditor.binaryFile.title' => 'バイナリファイル',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => 'ファイル "${fileName}" はバイナリファイルのため、テキストエディタで表示できません。',
			'codeEditor.binaryFile.cannotDisplayAsText' => 'テキストとして表示できません',
			'codeEditor.filePreview.loading' => 'プレビューを読み込み中...',
			'codeEditor.filePreview.error' => 'このファイルを表示できません。',
			'codeEditor.filePreview.openInNewTab' => '新しいタブで開く',
			'codeEditor.unsavedChanges' => ({required Object name}) => '${name} に未保存の変更があります',
			'codeEditor.discardUnsavedChanges' => '未保存の変更を破棄しますか？',
			'codeEditor.mediaFile.title' => 'メディアファイル',
			'codeEditor.mediaFile.subtitle' => '音声/動画のプレビューはまだサポートされていません',
			'codeEditor.failedToLoad' => 'ファイルの読み込みに失敗しました',
			'codeEditor.hexDump.more' => ({required Object size}) => '… 残り ${size}',
			'codeEditor.settings.minimap' => 'ミニマップ',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'タブサイズ: ${size}',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => 'フォントサイズ −  (現在 ${size})',
			'codeEditor.settings.fontSizeIncrease' => 'フォントサイズ +',
			'codeEditor.diff.noChanges' => '変更なし',
			'codeEditor.diff.hunk' => ({required Object number}) => 'ハンク ${number}',
			'codeEditor.diff.close' => '差分を閉じる',
			'codeEditor.diff.base' => 'ベース',
			'codeEditor.diff.current' => '現在',
			'codeEditor.diff.applyMerge' => 'マージを適用',
			'codeEditor.diff.deletedOnDisk' => 'ディスク上で削除済み',
			'codeEditor.diff.untrackedWillBeDeleted' => 'この未追跡ファイルは削除されます。',
			'codeEditor.diff.restoreConfirm' => ({required Object name}) => '${name} をコミット済みの状態に戻しますか？',
			'codeEditor.diff.headVsWorkingCopy' => 'HEAD と作業コピー',
			'codeEditor.diff.savedVsBuffer' => '最終保存とバッファ（git なし）',
			'codeEditor.diff.unchangedLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '変更のない ${count} 行', ), 
			'codeEditor.diff.revertToSaved' => '保存済みの状態に戻す',
			'codeEditor.emptyState.title' => 'ファイルが開かれていません',
			'codeEditor.emptyState.hint' => '「ファイル」タブからファイルを開いてください',
			'codeEditor.toasts.savedFile' => ({required Object name}) => '${name} を保存しました',
			'codeEditor.toasts.saveFailed' => '保存に失敗しました',
			'codeEditor.toasts.allSaved' => 'すべて保存しました',
			'codeEditor.toasts.someSavesFailed' => '一部の保存に失敗しました',
			'codeEditor.toasts.savedTo' => ({required Object path}) => '${path} に保存しました',
			'codeEditor.toasts.mergeApplied' => 'マージを適用しました — 保存して反映してください',
			'common.buttons.save' => '保存',
			'common.buttons.cancel' => 'キャンセル',
			'common.buttons.delete' => '削除',
			'common.buttons.create' => '作成',
			'common.buttons.edit' => '編集',
			'common.buttons.close' => '閉じる',
			'common.buttons.confirm' => '確認',
			'common.buttons.submit' => '送信',
			'common.buttons.retry' => '再試行',
			'common.buttons.refresh' => '更新',
			'common.buttons.search' => '検索',
			'common.buttons.clear' => 'クリア',
			'common.buttons.copy' => 'コピー',
			'common.buttons.download' => 'ダウンロード',
			'common.buttons.upload' => 'アップロード',
			'common.buttons.browse' => '参照',
			'common.buttons.update' => '更新',
			'common.buttons.openDiagram' => '図を開く',
			'common.tabs.chat' => 'チャット',
			'common.tabs.shell' => 'シェル',
			'common.tabs.files' => 'ファイル',
			'common.tabs.git' => 'ソース管理',
			'common.tabs.tasks' => 'タスク',
			'common.tabs.board' => 'ボード',
			'common.tabs.browser' => 'ブラウザ',
			'common.tabs.computer' => 'コンピューター',
			'common.tabs.usage' => 'AI コントロール',
			'common.quota.controlCenter' => 'AI コントロールセンター',
			'common.quota.section.overview' => '概要',
			'common.quota.section.quotas' => 'クォータ',
			'common.quota.section.usage' => '使用量',
			'common.quota.section.agents' => 'エージェント',
			'common.quota.filter.all' => 'すべて',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7日',
			'common.quota.period.k30d' => '30日',
			'common.quota.period.all' => 'すべて',
			'common.quota.group.provider' => 'プロバイダー',
			'common.quota.group.model' => 'モデル',
			'common.quota.group.agent' => 'エージェント',
			'common.quota.group.tool' => 'ツール',
			'common.quota.metric.tokens' => 'トークン',
			'common.quota.metric.input' => '入力',
			'common.quota.metric.output' => '出力',
			'common.quota.metric.cache' => 'キャッシュ読み取り',
			'common.quota.metric.calls' => 'API 呼び出し',
			'common.quota.metric.cost' => 'コスト',
			'common.quota.metric.sessions' => 'セッション',
			'common.quota.cost.billed' => '請求済み (API + 超過分)',
			'common.quota.cost.listPrice' => '使用トークンの定価',
			'common.quota.cost.subscriptionValue' => 'サブスクリプションで充当',
			'common.quota.cost.cacheSavings' => 'キャッシュ節約',
			'common.quota.cost3.billed' => '請求済み (API + 超過分)',
			'common.quota.cost3.listPrice' => '使用トークンの定価',
			'common.quota.cost3.subscriptionValue' => 'サブスクリプションで充当',
			'common.quota.overview.trendTitle' => 'トークンとコスト — 過去7日間',
			'common.quota.overview.effectiveCost' => '実質コスト (7日間)',
			'common.quota.overview.alertsTitle' => 'アラート',
			'common.quota.overview.noAlerts' => '現在注意が必要なものはありません。',
			'common.quota.overview.limitsTitle' => '使用量と上限',
			'common.quota.overview.activeTasks' => 'アクティブなタスク',
			'common.quota.overview.viewAccounts' => 'すべてのアカウント',
			'common.quota.overview.viewAgents' => 'すべてのエージェント',
			'common.quota.overview.noTasks' => '現在実行中のエージェントはいません。',
			'common.quota.usage.trendTitle' => '日次トレンド',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => '${group} 別の内訳',
			'common.quota.usage.colName' => '名前',
			'common.quota.usage.sourceUnavailable' => '分析ストアが利用できません。データを表示していません。',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} 件実行中',
			'common.quota.agents.colAgent' => 'エージェント',
			'common.quota.agents.colStatus' => 'ステータス',
			'common.quota.agents.colTask' => 'タスク',
			'common.quota.agents.colModel' => 'アカウント / モデル',
			'common.quota.agents.colTime' => '時刻',
			'common.quota.agents.empty' => 'このフィルターに一致するエージェントがいません。',
			'common.quota.agents.detailSession' => 'セッション',
			'common.quota.agents.detailStarted' => '開始',
			'common.quota.agents.detailRetries' => 'リトライ',
			'common.quota.agents.detailResult' => '結果',
			'common.quota.agents.notTracked' => '未追跡',
			'common.quota.agentStatus.running' => '実行中',
			'common.quota.agentStatus.waiting' => '待機中',
			'common.quota.agentStatus.failed' => '失敗',
			'common.quota.agentStatus.finished' => '完了',
			'common.quota.agentStatus.queued' => 'キュー待ち',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}: 現在のペースでは ${value} で上限に達します',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}: ${value}% 使用 (しきい値 ${watch}%)',
			'common.quota.backToChat' => 'チャットに戻る',
			'common.quota.syncNow' => '今すぐ同期',
			'common.quota.generatedAt' => ({required Object value}) => '${value} に更新',
			'common.quota.loading' => 'アカウント上限を読み込み中…',
			'common.quota.remaining' => ({required Object value}) => '残り ${value}%',
			'common.quota.resetsIn' => ({required Object value}) => '${value} でリセット',
			'common.quota.projected' => ({required Object value}) => '現在のペースではこの上限は ${value} で尽きます',
			'common.quota.syncedAgo' => ({required Object value}) => '${value} 前に同期',
			'common.quota.refreshAccount' => 'アカウントを更新',
			'common.quota.syncFailed' => '同期に失敗しました',
			'common.quota.history' => '履歴',
			'common.quota.historyPoints' => ({required Object value}) => '${value} 件の読み取りを記録',
			'common.quota.historyEmpty' => 'まだ履歴が記録されていません',
			'common.quota.noAgents' => '割り当てられたエージェントなし',
			'common.quota.noSubscription' => 'サブスクリプションなし',
			'common.quota.noSubscriptionHint' => 'このアカウントのアクティブなプランはプロバイダーから報告されていません。',
			'common.quota.notInstalled' => '未インストール',
			'common.quota.notInstalledHint' => ({required Object place}) => 'このサーバーにはエージェントの CLI がインストールされていません。${place} でインストールしてください。',
			'common.quota.notLoggedIn' => '未ログイン',
			'common.quota.notLoggedInHint' => ({required Object place}) => 'このサーバーでエージェントにログインしていません。${place} でログインしてください。',
			'common.quota.quality.live' => 'ライブ',
			'common.quota.quality.cached' => 'キャッシュ',
			'common.quota.quality.estimate' => '推定',
			'common.quota.quality.unknown' => '不明',
			'common.quota.quality.error' => 'エラー',
			'common.quota.kpi.atRisk' => '危険な上限',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => '${value}% 超のアカウント',
			'common.quota.kpi.windowsAtRisk' => '残り少ないウィンドウ',
			'common.quota.kpi.errored' => '同期エラー',
			'common.quota.kpi.activeAgents' => 'アクティブなエージェント',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} 待機 · ${queued} キュー',
			'common.quota.kpi.nextReset' => '次回リセット',
			'common.quota.kpi.tokens' => 'トークン',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} セッション',
			'common.quota.kpi.cost' => '推定コスト',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} がプランで充当',
			'common.quota.empty.title' => '接続されたアカウントがありません',
			'common.quota.empty.description' => 'Claude、Codex、Gemini、CommandCode にサインインするとクォータをここで追跡できます。',
			'common.quota.settings.title' => 'アラートとルーティング',
			'common.quota.settings.description' => 'ダッシュボードが警告するタイミングと、新しい作業にアカウントを提案する方法を制御します。',
			'common.quota.settings.alertsEnabled' => '予測アラートとしきい値アラート',
			'common.quota.settings.alertsEnabledHint' => '90% になってからではなく、現在のペースで上限が尽きる前に警告します。',
			'common.quota.settings.watchThreshold' => '監視しきい値 (%)',
			'common.quota.settings.dangerThreshold' => '危険しきい値 (%)',
			'common.quota.settings.routingMode' => 'ルーティング',
			'common.quota.settings.routing.manual' => '手動 — 推奨のみ',
			'common.quota.settings.routing.ask' => 'アカウント切り替え前に確認',
			'common.quota.settings.routing.autoLowRisk' => '低リスクタスクの自動切り替え',
			'common.quota.settings.logSources' => 'ログソース',
			'common.quota.settings.logSourcesHint' => '使用量とエージェント画面はこれらの読み取り専用ソースを参照します。',
			'common.quota.settings.quotaConsent' => 'クォータのポーリングを許可',
			'common.quota.settings.quotaConsentHint' => '保存済みの認証情報でプロバイダーのエンドポイントをポーリングしてライブ上限を読み取ります。',
			'common.quota.settings.perAccount' => 'アカウントごとの上書き',
			'common.quota.settings.tab' => 'Control Center 設定',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => 'すべて',
			'common.status.loading' => '読み込み中...',
			'common.status.success' => '成功',
			'common.status.error' => 'エラー',
			'common.status.failed' => '失敗',
			'common.status.pending' => '保留中',
			'common.status.completed' => '完了',
			'common.status.inProgress' => '進行中',
			'common.messages.savedSuccessfully' => '保存しました',
			'common.messages.deletedSuccessfully' => '削除しました',
			'common.messages.updatedSuccessfully' => '更新しました',
			'common.messages.operationFailed' => '操作に失敗しました',
			'common.messages.networkError' => 'ネットワークエラー。接続を確認してください。',
			'common.messages.unauthorized' => '認証されていません。ログインしてください。',
			'common.messages.notFound' => '見つかりません',
			'common.messages.invalidInput' => '入力が無効です',
			'common.messages.requiredField' => 'この項目は必須です',
			'common.messages.unknownError' => '不明なエラーが発生しました',
			'common.messages.renameSessionFailed' => 'セッション名の変更に失敗しました。もう一度お試しください。',
			'common.navigation.settings' => '設定',
			'common.navigation.home' => 'ホーム',
			'common.navigation.back' => '戻る',
			'common.navigation.next' => '次へ',
			'common.navigation.previous' => '前へ',
			'common.navigation.logout' => 'ログアウト',
			'common.navigation.backToChat' => 'チャットに戻る',
			'common.common.language' => '言語',
			'common.common.theme' => 'テーマ',
			'common.common.darkMode' => 'ダークモード',
			'common.common.lightMode' => 'ライトモード',
			'common.common.name' => '名前',
			'common.common.description' => '説明',
			'common.common.enabled' => '有効',
			'common.common.disabled' => '無効',
			'common.common.optional' => '任意',
			'common.common.version' => 'バージョン',
			'common.common.select' => '選択',
			'common.common.selectAll' => 'すべて選択',
			'common.common.deselectAll' => 'すべて解除',
			'common.common.done' => '完了',
			'common.common.failed' => '失敗',
			'common.time.justNow' => 'たった今',
			'common.time.minutesAgo' => ({required Object count}) => '${count}分前',
			'common.time.hoursAgo' => ({required Object count}) => '${count}時間前',
			'common.time.daysAgo' => ({required Object count}) => '${count}日前',
			'common.time.yesterday' => '昨日',
			'common.fileOperations.newFile' => '新規ファイル',
			'common.fileOperations.newFolder' => '新規フォルダ',
			'common.fileOperations.rename' => '名前の変更',
			'common.fileOperations.move' => '移動',
			'common.fileOperations.copyPath' => 'パスをコピー',
			'common.fileOperations.openInEditor' => 'エディタで開く',
			'common.mainContent.loading' => 'DDAgent を読み込んでいます',
			'common.mainContent.settingUpWorkspace' => 'ワークスペースを準備しています...',
			'common.mainContent.chooseProject' => 'プロジェクトを選択',
			'common.mainContent.selectProjectDescription' => 'サイドバーからプロジェクトを選択して、Claudeとコーディングを始めましょう。各プロジェクトにはチャットセッションとファイル履歴が含まれています。',
			'common.mainContent.tip' => 'ヒント',
			'common.mainContent.createProjectMobile' => '上部のメニューボタンからプロジェクトにアクセスできます',
			'common.mainContent.createProjectDesktop' => 'サイドバーのフォルダアイコンをクリックして新しいプロジェクトを作成できます',
			'common.mainContent.newSession' => '新しいセッション',
			'common.mainContent.untitledSession' => '無題のセッション',
			'common.mainContent.projectFiles' => 'プロジェクトファイル',
			'common.mainContent.focusMode' => 'フォーカスモード (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => 'フォーカスモードを終了 (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => 'セッションを分割',
			'common.mainContent.closeSplitSession' => '分割セッションを閉じる',
			'common.mainContent.chooseWorkspace' => 'ワークスペースを選択',
			'common.mainContent.chooseWorkspaceDescription' => 'このチャットのワークスペースを選択するか、設定で新しく作成してください。',
			'common.mainContent.createWorkspace' => '設定でワークスペースを作成',
			'common.mainContent.recentProjects' => '最近のプロジェクト',
			'common.fileTree.loading' => 'ファイルを読み込んでいます...',
			'common.fileTree.files' => 'ファイル',
			'common.fileTree.simpleView' => 'シンプル表示',
			'common.fileTree.compactView' => 'コンパクト表示',
			'common.fileTree.detailedView' => '詳細表示',
			'common.fileTree.searchPlaceholder' => 'ファイルやフォルダを検索...',
			'common.fileTree.searchContentPlaceholder' => 'ファイル内を検索...',
			'common.fileTree.searchInFiles' => 'ファイル内を検索',
			'common.fileTree.searchByName' => '名前で検索',
			'common.fileTree.clearSearch' => '検索をクリア',
			'common.fileTree.name' => '名前',
			'common.fileTree.size' => 'サイズ',
			'common.fileTree.modified' => '更新日時',
			'common.fileTree.permissions' => '権限',
			'common.fileTree.noFilesFound' => 'ファイルが見つかりません',
			'common.fileTree.checkProjectPath' => 'プロジェクトのパスがアクセス可能か確認してください',
			'common.fileTree.loadFailed' => 'ファイルを読み込めませんでした',
			'common.fileTree.noMatchesFound' => '一致するものが見つかりません',
			'common.fileTree.noSearchResults' => '一致するものが見つかりません',
			'common.fileTree.tryDifferentSearch' => '別の検索語を試すか、検索をクリアしてください',
			'common.fileTree.searchError' => '検索に失敗しました',
			'common.fileTree.searching' => '検索中...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => '最初の ${count} 件を表示',
			'common.fileTree.justNow' => 'たった今',
			'common.fileTree.minAgo' => ({required Object count}) => '${count}分前',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count}時間前',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count}日前',
			'common.fileTree.newFile' => '新規ファイル (Cmd+N)',
			'common.fileTree.newFolder' => '新規フォルダ (Cmd+Shift+N)',
			'common.fileTree.refresh' => '更新',
			'common.fileTree.collapseAll' => 'すべて折りたたむ',
			'common.fileTree.context.rename' => '名前を変更',
			'common.fileTree.context.delete' => '削除',
			'common.fileTree.context.copyPath' => 'パスをコピー',
			'common.fileTree.context.download' => 'ダウンロード',
			'common.fileTree.context.newFile' => '新しいファイル',
			'common.fileTree.context.newFolder' => '新しいフォルダ',
			'common.fileTree.context.upload' => 'ファイルをアップロード',
			'common.fileTree.context.refresh' => '更新',
			'common.fileTree.context.menuLabel' => 'ファイルのコンテキストメニュー',
			'common.fileTree.context.loading' => '読み込み中...',
			'common.fileTree.allWorkspaces' => 'すべてのワークスペース',
			'common.fileTree.delete.confirm' => '削除',
			'common.fileTree.delete.fileWarning' => 'このファイルは完全に削除されます。',
			'common.fileTree.delete.folderWarning' => 'このフォルダとそのすべての内容は完全に削除されます。',
			'common.fileTree.delete.title' => ({required Object type}) => '${type} を削除',
			'common.fileTree.dropToUpload' => 'ファイルをドロップしてアップロード',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => '「${folder}」へアップロードするにはファイルをドロップ',
			'common.fileTree.noProject' => '先にプロジェクトを追加してください',
			'common.fileTree.noRecentFiles' => '過去7日間に変更されたファイルはありません',
			'common.fileTree.showAllFiles' => 'すべてのファイルを表示',
			'common.fileTree.showAllFilesHint' => '最近のフィルターをオフにするとすべて表示されます。',
			'common.fileTree.showRecentOnly' => '過去7日間に変更されたファイルを表示',
			'common.fileTree.toast.copyFailed' => 'パスのコピーに失敗しました',
			'common.fileTree.toast.fileCreated' => 'ファイルを作成しました',
			'common.fileTree.toast.fileDeleted' => 'ファイルを削除しました',
			'common.fileTree.toast.folderCreated' => 'フォルダを作成しました',
			'common.fileTree.toast.folderDeleted' => 'フォルダを削除しました',
			'common.fileTree.toast.folderDownloaded' => 'フォルダをZIPとしてダウンロードしました',
			'common.fileTree.toast.pathCopied' => 'パスをクリップボードにコピーしました',
			'common.fileTree.toast.renamed' => '名前を変更しました',
			'common.fileTree.uploadComplete' => 'アップロード完了',
			'common.fileTree.uploadFailed' => 'アップロードに失敗しました',
			'common.fileTree.uploadFiles' => ({required Object size}) => 'ファイルをアップロード（各最大 ${size}）',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => '「${folder}」にファイルをアップロード',
			'common.fileTree.uploadedCount' => ({required Object total, required Object label, required Object uploaded}) => '${total} ${label} 中 ${uploaded} 件をアップロード',
			'common.fileTree.uploadingFiles' => 'ファイルをアップロード中',
			'common.fileTree.validation.dotsOnly' => 'ファイル名はドットのみにはできません',
			'common.fileTree.validation.emptyName' => 'ファイル名は空にできません',
			'common.fileTree.validation.invalidChars' => 'ファイル名に無効な文字が含まれています',
			'common.fileTree.validation.reserved' => 'ファイル名は予約語です',
			'common.projectWizard.title' => '新規プロジェクトを作成',
			'common.projectWizard.steps.type' => '種類',
			'common.projectWizard.steps.configure' => '設定',
			'common.projectWizard.steps.confirm' => '確認',
			'common.projectWizard.step1.question' => '既存のワークスペースがありますか？それとも新しく作成しますか？',
			'common.projectWizard.step1.existing.title' => '既存のワークスペース',
			'common.projectWizard.step1.existing.description' => 'サーバー上に既存のワークスペースがあり、プロジェクト一覧に追加したい',
			'common.projectWizard.step1.kNew.title' => '新しいワークスペース',
			'common.projectWizard.step1.kNew.description' => '新しいワークスペースを作成し、必要に応じてGitHubリポジトリからクローンする',
			'common.projectWizard.step2.existingPath' => 'ワークスペースのパス',
			'common.projectWizard.step2.newPath' => 'ワークスペースのパス',
			'common.projectWizard.step2.existingPlaceholder' => '/path/to/existing/workspace',
			'common.projectWizard.step2.newPlaceholder' => '/path/to/new/workspace',
			'common.projectWizard.step2.existingHelp' => '既存のワークスペースディレクトリのフルパス',
			'common.projectWizard.step2.newHelp' => 'ワークスペースディレクトリのフルパス',
			'common.projectWizard.step2.githubUrl' => 'GitHub URL（任意）',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => '任意: リポジトリをクローンするためのGitHub URLを入力してください',
			'common.projectWizard.step2.githubAuth' => 'GitHub認証（任意）',
			'common.projectWizard.step2.githubAuthHelp' => 'プライベートリポジトリの場合のみ必要です。パブリックリポジトリは認証なしでクローンできます。',
			_ => null,
		} ?? switch (path) {
			'common.projectWizard.step2.loadingTokens' => '保存済みトークンを読み込んでいます...',
			'common.projectWizard.step2.storedToken' => '保存済みトークン',
			'common.projectWizard.step2.newToken' => '新しいトークン',
			'common.projectWizard.step2.nonePublic' => 'なし（パブリック）',
			'common.projectWizard.step2.selectToken' => 'トークンを選択',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- トークンを選択 --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => 'このトークンはこの操作にのみ使用されます',
			'common.projectWizard.step2.publicRepoInfo' => 'パブリックリポジトリには認証は不要です。パブリックリポジトリをクローンする場合、トークンは省略できます。',
			'common.projectWizard.step2.noTokensHelp' => '保存済みトークンがありません。設定 → APIキーでトークンを追加すると再利用が簡単になります。',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHubトークン（パブリックリポジトリの場合は任意）',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx（パブリックリポジトリの場合は空欄可）',
			'common.projectWizard.step3.reviewConfig' => '設定の確認',
			'common.projectWizard.step3.existingWorkspace' => '既存のワークスペース',
			'common.projectWizard.step3.newWorkspace' => '新しいワークスペース',
			'common.projectWizard.step3.path' => 'パス:',
			'common.projectWizard.step3.cloneFrom' => 'クローン元:',
			'common.projectWizard.step3.authentication' => '認証:',
			'common.projectWizard.step3.usingStoredToken' => '保存済みトークンを使用:',
			'common.projectWizard.step3.usingProvidedToken' => '入力されたトークンを使用',
			'common.projectWizard.step3.noAuthentication' => '認証なし',
			'common.projectWizard.step3.sshKey' => 'SSHキー',
			'common.projectWizard.step3.existingInfo' => 'ワークスペースがプロジェクト一覧に追加され、Claude/Cursorセッションで使用できるようになります。',
			'common.projectWizard.step3.newWithClone' => 'このフォルダからリポジトリがクローンされます。',
			'common.projectWizard.step3.newEmpty' => 'ワークスペースがプロジェクト一覧に追加され、Claude/Cursorセッションで使用できるようになります。',
			'common.projectWizard.step3.cloningRepository' => 'リポジトリをクローンしています...',
			'common.projectWizard.buttons.cancel' => 'キャンセル',
			'common.projectWizard.buttons.back' => '戻る',
			'common.projectWizard.buttons.next' => '次へ',
			'common.projectWizard.buttons.createProject' => 'プロジェクトを作成',
			'common.projectWizard.buttons.creating' => '作成中...',
			'common.projectWizard.buttons.cloning' => 'クローン中...',
			'common.projectWizard.errors.selectType' => '既存のワークスペースか新規作成かを選択してください',
			'common.projectWizard.errors.providePath' => 'ワークスペースのパスを入力してください',
			'common.projectWizard.errors.failedToCreate' => 'ワークスペースの作成に失敗しました',
			'common.projectWizard.errors.failedToCreateFolder' => 'フォルダの作成に失敗しました',
			'common.notifications.genericTool' => 'ツール',
			'common.notifications.codes.generic.info.title' => '通知',
			'common.notifications.codes.permission.required.title' => '対応が必要です',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} があなたの判断を待っています。',
			'common.notifications.codes.run.stopped.title' => '実行が停止しました',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => '理由: ${reason}',
			'common.notifications.codes.run.failed.title' => '実行に失敗しました',
			'common.notifications.codes.agent.notification.title' => 'エージェント通知',
			'common.versionUpdate.title' => 'アップデートのお知らせ',
			'common.versionUpdate.newVersionReady' => '新しいバージョンが利用可能です',
			'common.versionUpdate.currentVersion' => '現在のバージョン',
			'common.versionUpdate.latestVersion' => '最新バージョン',
			'common.versionUpdate.whatsNew' => '変更点:',
			'common.versionUpdate.viewFullRelease' => 'リリース全文を見る',
			'common.versionUpdate.updateProgress' => 'アップデートの進捗:',
			'common.versionUpdate.manualUpgrade' => '手動アップグレード:',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => 'または「今すぐ更新」をクリックして自動的にアップデートを実行できます。',
			'common.versionUpdate.updateCompleted' => 'アップデートが完了しました！',
			'common.versionUpdate.restartServer' => '変更を適用するにはサーバーを再起動してください。',
			'common.versionUpdate.updateFailed' => 'アップデートに失敗しました',
			'common.versionUpdate.buttons.close' => '閉じる',
			'common.versionUpdate.buttons.later' => '後で',
			'common.versionUpdate.buttons.copyCommand' => 'コマンドをコピー',
			'common.versionUpdate.buttons.updateNow' => '今すぐ更新',
			'common.versionUpdate.buttons.updating' => '更新中...',
			'common.versionUpdate.ariaLabels.closeModal' => 'バージョンアップグレードモーダルを閉じる',
			'common.versionUpdate.ariaLabels.showSidebar' => 'サイドバーを表示',
			'common.versionUpdate.ariaLabels.settings' => '設定',
			'common.versionUpdate.ariaLabels.updateAvailable' => 'アップデートあり',
			'common.versionUpdate.ariaLabels.closeSidebar' => 'サイドバーを閉じる',
			'common.actions.cancel' => 'キャンセル',
			'common.actions.retry' => '再試行',
			'common.actions.save' => '保存',
			'common.browserPane.address' => 'アドレス',
			'common.browserPane.back' => '戻る',
			'common.browserPane.connecting' => 'ブラウザに接続中…',
			'common.browserPane.connectionFailed' => 'ブラウザ接続に失敗しました。',
			'common.browserPane.couldNotLoad' => ({required Object url}) => '${url} を読み込めませんでした',
			'common.browserPane.disconnected' => 'ブラウザビューが切断されました',
			'common.browserPane.enterUrl' => 'URLを入力',
			'common.browserPane.forward' => '進む',
			'common.browserPane.invalidUrl' => '有効な http(s) URLを入力してください',
			'common.browserPane.noAuthToken' => '認証トークンがありません。',
			'common.browserPane.openExternal' => 'システムブラウザで開く',
			'common.browserPane.reload' => '再読み込み',
			'common.browserPane.retry' => '再試行',
			'common.browserPane.stop' => '停止',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} 件アクティブ',
			'common.browserUse.cancel' => 'キャンセル',
			'common.browserUse.close' => '閉じる',
			'common.browserUse.delete' => '削除',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} は完全に削除されます。',
			'common.browserUse.deleteSession' => 'セッションを削除',
			'common.browserUse.deleteTitle' => 'ブラウザセッションを削除しますか？',
			'common.browserUse.empty.descDisabled' => '設定で Browser を有効にすると、エージェントが監視付きブラウザセッションを開けます。',
			'common.browserUse.empty.descEnabled' => 'AIタスクが Browser を使用している間、エージェントのブラウザセッションがここに表示されます。',
			'common.browserUse.empty.titleDisabled' => 'Browser は無効です',
			'common.browserUse.empty.titleEnabled' => 'ブラウザセッションはまだありません',
			'common.browserUse.emptyStatus' => '空',
			'common.browserUse.errors.actionFailed' => 'ブラウザ操作に失敗しました',
			'common.browserUse.errors.loadFailed' => 'Browser の読み込みに失敗しました',
			'common.browserUse.fullscreen' => '全画面',
			'common.browserUse.installRuntime' => 'ランタイムをインストール',
			'common.browserUse.installing' => 'インストール中...',
			'common.browserUse.lastAction' => '最後の操作',
			'common.browserUse.nextSnapshot' => 'エージェントブラウザの次のスナップショットがここに表示されます。',
			'common.browserUse.noPageLoaded' => 'ページが読み込まれていません',
			'common.browserUse.noSessions' => 'エージェントのブラウザセッションがありません。',
			'common.browserUse.none' => 'なし',
			'common.browserUse.openSettings' => 'Browser 設定を開く',
			'common.browserUse.profile' => 'プロファイル',
			'common.browserUse.promptLabel' => 'プロンプト',
			'common.browserUse.prompts.prompt1' => 'Browser を使ってチェックアウトフローを調査し、壊れたUI状態を報告してください。',
			'common.browserUse.prompts.prompt2' => 'Browser で <url> を開き、ページを操作して、各ステップ後の変化を要約してください。',
			'common.browserUse.refresh' => 'ブラウザセッションを更新',
			'common.browserUse.relative.daysAgo' => '日前',
			'common.browserUse.relative.hoursAgo' => '時間前',
			'common.browserUse.relative.justNow' => 'たった今',
			'common.browserUse.relative.minutesAgo' => '分前',
			'common.browserUse.relative.never' => 'なし',
			'common.browserUse.relative.secondsAgo' => '秒前',
			'common.browserUse.relative.unknown' => '不明',
			'common.browserUse.runtime.disabled' => '無効',
			'common.browserUse.runtime.installing' => 'インストール中',
			'common.browserUse.runtime.ready' => '準備完了',
			'common.browserUse.runtime.setupRequired' => 'セットアップが必要',
			'common.browserUse.runtimeSetup' => 'ランタイムのセットアップが必要です',
			'common.browserUse.selected' => '選択中',
			'common.browserUse.sessionFallback' => 'ブラウザセッション',
			'common.browserUse.sessionScreenshot' => 'ブラウザセッションのスクリーンショット',
			'common.browserUse.sessions' => 'セッション',
			'common.browserUse.status' => 'ステータス',
			'common.browserUse.stop' => '停止',
			'common.browserUse.stopSession' => 'セッションを停止',
			'common.browserUse.subtitle' => 'AIエージェントが開いたブラウザセッションを監視します。',
			'common.browserUse.temporary' => '一時的',
			'common.browserUse.thisSession' => 'このセッション',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '合計 ${count} 件',
			'common.browserUse.updated' => ({required Object time}) => '更新: ${time}',
			'common.browserUse.waiting' => '待機中',
			'common.browserUse.waitingForScreenshot' => 'スクリーンショットを待機中',
			'common.commandPalette.backToAll' => 'すべてに戻る',
			'common.commandPalette.backspaceHint' => 'Backspace で戻る',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => 'すべてのブランチを表示 (${count})',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => 'すべてのコミットを表示 (${count})',
			'common.commandPalette.browseAll.files' => ({required Object count}) => 'すべてのファイルを表示 (${count})',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => 'すべてのセッションを表示 (${count})',
			'common.commandPalette.compare.costNote' => 'コストは公開されているトークン単価に基づくクライアント側の推定値です。不明なモデルは「—」と表示されます。',
			'common.commandPalette.compare.estCost' => '推定コスト',
			'common.commandPalette.compare.inputOutput' => '入力 / 出力',
			'common.commandPalette.compare.model' => 'モデル',
			'common.commandPalette.compare.na' => '該当なし',
			'common.commandPalette.compare.openSplit' => '分割ビューで開く',
			'common.commandPalette.compare.provider' => 'プロバイダー',
			'common.commandPalette.compare.selectSession' => 'セッションを選択…',
			'common.commandPalette.compare.tokensUsed' => '使用トークン',
			'common.commandPalette.groups.actions' => 'アクション',
			'common.commandPalette.groups.branches' => 'ブランチ',
			'common.commandPalette.groups.commits' => 'コミット',
			'common.commandPalette.groups.files' => 'ファイル',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => 'ナビゲーション',
			'common.commandPalette.groups.sessions' => 'セッション',
			'common.commandPalette.groups.settings' => '設定',
			'common.commandPalette.hints.close' => '閉じる',
			'common.commandPalette.hints.navigate' => '移動',
			'common.commandPalette.hints.select' => '選択',
			'common.commandPalette.hints.togglePalette' => 'パレットの切り替え',
			'common.commandPalette.items.compareSessions' => 'セッションを比較',
			'common.commandPalette.items.gitFetch' => 'Git: Fetch',
			'common.commandPalette.items.gitPull' => 'Git: Pull',
			'common.commandPalette.items.gitPush' => 'Git: Push',
			'common.commandPalette.items.openSettings' => '設定を開く',
			'common.commandPalette.items.selectProjectFirst' => '先にプロジェクトを選択してください',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => '設定: ${label}',
			'common.commandPalette.items.startNewChat' => '新しいチャットを開始',
			'common.commandPalette.items.switchTo' => ({required Object name}) => '切り替え: ${name}',
			'common.commandPalette.items.toggleTheme' => 'テーマを切り替え',
			'common.commandPalette.items.tokensAndCost' => 'トークンとコスト',
			'common.commandPalette.nav.board' => 'エージェントボードへ',
			'common.commandPalette.nav.chat' => 'チャットへ',
			'common.commandPalette.nav.files' => 'ファイルへ',
			'common.commandPalette.nav.git' => 'Git へ',
			'common.commandPalette.nav.sourceControl' => 'ソース管理へ',
			'common.commandPalette.nav.tasks' => 'タスクへ',
			'common.commandPalette.nav.usage' => 'クォータと使用量へ',
			'common.commandPalette.noResults' => '結果がありません。',
			'common.commandPalette.pages.actions' => 'アクション',
			'common.commandPalette.pages.branches' => 'ブランチ',
			'common.commandPalette.pages.commits' => 'コミット',
			'common.commandPalette.pages.compare' => '比較',
			'common.commandPalette.pages.files' => 'ファイル',
			'common.commandPalette.pages.sessions' => 'セッション',
			'common.commandPalette.placeholder' => '入力して検索…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => '${page} を検索…',
			'common.commandPalette.title' => 'コマンドパレット',
			'common.gitPanel.ahead' => ({required Object count}) => '${count} 先行',
			'common.gitPanel.aheadLabel' => '先行',
			'common.gitPanel.aiSuggest' => 'AI 提案',
			'common.gitPanel.aiSuggestTitle' => 'AIでコミットメッセージを生成',
			'common.gitPanel.all' => 'すべて',
			'common.gitPanel.allStaged' => 'すべての変更がステージ済み',
			'common.gitPanel.behind' => ({required Object count}) => '${count} 遅れ',
			'common.gitPanel.behindLabel' => '遅れ',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => 'ブランチ「${branch}」を削除しますか？通常の削除はブランチが完全にマージされている場合のみ成功します。元に戻せません。',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => 'ブランチ「${branch}」に切り替えますか？未コミットの変更がないことを確認してください。',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => 'ローカル ${local}、リモート ${remote}',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => 'ローカル ${count}',
			'common.gitPanel.branches.current' => '現在',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => '${branch} を削除',
			'common.gitPanel.branches.emptyDesc' => 'ブランチを作成して並行作業を開始します。',
			'common.gitPanel.branches.forceDelete' => '強制削除',
			'common.gitPanel.branches.forceDeleteDesc' => '他にマージされていないコミットが含まれていてもブランチを完全に削除します。',
			'common.gitPanel.branches.forceDeleteLabel' => 'この未マージのブランチを強制削除',
			'common.gitPanel.branches.local' => 'ローカル',
			'common.gitPanel.branches.kNew' => '新しいブランチ',
			'common.gitPanel.branches.noMatch' => '検索に一致するブランチがありません',
			'common.gitPanel.branches.none' => 'ブランチが見つかりません',
			'common.gitPanel.branches.remote' => 'リモート',
			'common.gitPanel.branches.kSwitch' => '切り替え',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => '${branch} に切り替え',
			'common.gitPanel.cancel' => 'キャンセル',
			'common.gitPanel.changesCount' => ({required Object count}) => '変更 (${count})',
			'common.gitPanel.clearSearch' => '検索をクリア',
			'common.gitPanel.collapseDiff' => '差分を折りたたむ',
			'common.gitPanel.commit' => 'コミット',
			'common.gitPanel.commitChanges' => '変更をコミット',
			'common.gitPanel.commitFiles' => ({required Object count}) => '${count} ファイルをコミット',
			'common.gitPanel.committing' => 'コミット中...',
			'common.gitPanel.confirmActions.commit' => '確認',
			'common.gitPanel.confirmActions.delete' => '削除',
			'common.gitPanel.confirmActions.deleteBranch' => '削除',
			'common.gitPanel.confirmActions.discard' => '破棄',
			'common.gitPanel.confirmActions.publish' => '公開',
			'common.gitPanel.confirmActions.pull' => 'プル',
			'common.gitPanel.confirmActions.push' => 'プッシュ',
			'common.gitPanel.confirmActions.revertLocalCommit' => 'コミットを取り消す',
			'common.gitPanel.confirmCommit' => ({required Object count, required Object message}) => '${count} ファイルをメッセージ「${message}」でコミットしますか？',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => '未追跡ファイル「${file}」を削除しますか？元に戻せません。',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => '「${file}」へのすべての変更を破棄しますか？元に戻せません。',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => 'ブランチ「${branch}」を ${remote} に公開しますか？',
			'common.gitPanel.confirmPull' => ({required Object remote, required Object count}) => '${remote} から ${count} コミットを取得しますか？',
			'common.gitPanel.confirmPush' => ({required Object remote, required Object count}) => '${remote} へ ${count} コミットを送信しますか？',
			'common.gitPanel.confirmRevert' => '最新のローカルコミットを取り消しますか？コミットは削除されますが、変更はステージされたまま残ります。',
			'common.gitPanel.confirmTitles.commit' => '操作の確認',
			'common.gitPanel.confirmTitles.delete' => 'ファイルを削除',
			'common.gitPanel.confirmTitles.deleteBranch' => 'ブランチを削除',
			'common.gitPanel.confirmTitles.discard' => '変更を破棄',
			'common.gitPanel.confirmTitles.publish' => 'ブランチを公開',
			'common.gitPanel.confirmTitles.pull' => 'Pull の確認',
			'common.gitPanel.confirmTitles.push' => 'Push の確認',
			'common.gitPanel.confirmTitles.revertLocalCommit' => 'ローカルコミットを取り消す',
			'common.gitPanel.createBranch' => '新しいブランチを作成',
			'common.gitPanel.creating' => '作成中...',
			'common.gitPanel.delete' => '削除',
			'common.gitPanel.deleteUntracked' => '未追跡ファイルを削除',
			'common.gitPanel.deselectAll' => 'すべて解除',
			'common.gitPanel.discard' => '破棄',
			'common.gitPanel.discardChanges' => '変更を破棄',
			'common.gitPanel.dismiss' => '閉じる',
			'common.gitPanel.dismissError' => 'エラーを閉じる',
			'common.gitPanel.errors.createBranchFailed' => 'ブランチの作成に失敗しました',
			'common.gitPanel.errors.createWorktreeFailed' => 'worktree の作成に失敗しました',
			'common.gitPanel.errors.deleteBranchFailed' => 'ブランチの削除に失敗しました',
			'common.gitPanel.errors.fetchFailed' => 'Fetch に失敗しました',
			'common.gitPanel.errors.initFailed' => 'リポジトリの初期化に失敗しました',
			'common.gitPanel.errors.initialCommitFailed' => '最初のコミットの作成に失敗しました',
			'common.gitPanel.errors.mergeFailed' => 'マージに失敗しました',
			'common.gitPanel.errors.openWorktreeFailed' => 'worktree を開けませんでした',
			'common.gitPanel.errors.operationFailed' => 'git 操作に失敗しました',
			'common.gitPanel.errors.publishFailed' => '公開に失敗しました',
			'common.gitPanel.errors.pullFailed' => 'Pull に失敗しました',
			'common.gitPanel.errors.pushFailed' => 'Push に失敗しました',
			'common.gitPanel.errors.removeWorktreeFailed' => 'worktree の削除に失敗しました',
			'common.gitPanel.errors.stageFailed' => 'ステージに失敗しました',
			'common.gitPanel.errors.stageHunksFailed' => 'ハンクのステージに失敗しました',
			'common.gitPanel.errors.switchFailed' => 'ブランチの切り替えに失敗しました',
			'common.gitPanel.errors.unstageFailed' => 'ステージ解除に失敗しました',
			'common.gitPanel.errors.unstageHunksFailed' => 'ハンクのステージ解除に失敗しました',
			'common.gitPanel.expandDiff' => '差分を展開',
			'common.gitPanel.fetch' => 'フェッチ',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => '${remote} から fetch',
			'common.gitPanel.fetching' => 'Fetch 中…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '${count} ファイル選択中',
			'common.gitPanel.generating' => '生成中...',
			'common.gitPanel.history.added' => '追加',
			'common.gitPanel.history.author' => '作者',
			'common.gitPanel.history.changedFiles' => '変更されたファイル',
			'common.gitPanel.history.date' => '日付',
			'common.gitPanel.history.empty' => 'コミットが見つかりません',
			'common.gitPanel.history.files' => 'ファイル',
			'common.gitPanel.history.removed' => '削除',
			'common.gitPanel.mergeWorktree.cleanupDesc' => 'マージ後に worktree を削除し、そのブランチを削除する',
			'common.gitPanel.mergeWorktree.cleanupLabel' => 'マージ後にクリーンアップ',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} コミット',
			'common.gitPanel.mergeWorktree.merge' => 'マージ',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => 'ブランチ \'${branch}\' をマージ',
			'common.gitPanel.mergeWorktree.messageLabel' => 'コミットメッセージ',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => '${commits} 件すべてを ${branch} 上の1つのコミットにまとめる',
			'common.gitPanel.mergeWorktree.squashLabel' => 'コミットをスカッシュ',
			'common.gitPanel.mergeWorktree.squashMerge' => 'スカッシュ＆マージ',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => 'ブランチ \'${branch}\' をスカッシュマージ',
			'common.gitPanel.mergeWorktree.title' => 'Worktree をマージ',
			'common.gitPanel.merging' => 'マージ中...',
			'common.gitPanel.messagePlaceholder' => 'メッセージ（Ctrl+Enter でコミット）',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => '現在のブランチ（${branch}）から新しいブランチを作成します',
			'common.gitPanel.newBranch.nameLabel' => 'ブランチ名',
			'common.gitPanel.newBranch.submit' => 'ブランチを作成',
			'common.gitPanel.newBranch.title' => '新しいブランチを作成',
			'common.gitPanel.newWorktree.branchLabel' => 'ブランチ',
			'common.gitPanel.newWorktree.createFrom' => '作成元',
			'common.gitPanel.newWorktree.description' => 'ブランチを独自のフォルダにチェックアウトし、並行して作業します。',
			'common.gitPanel.newWorktree.existingBranch' => '既存のブランチ — そのままチェックアウトされます。',
			'common.gitPanel.newWorktree.submit' => 'Worktree を作成',
			'common.gitPanel.newWorktree.switchAfter' => '作成後に worktree へ切り替える',
			'common.gitPanel.newWorktree.title' => '新しい Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => '作成先',
			'common.gitPanel.noChanges' => '変更が検出されませんでした',
			'common.gitPanel.noChangesToCommit' => 'コミットする変更がありません',
			'common.gitPanel.noCommits.create' => '最初のコミットを作成',
			'common.gitPanel.noCommits.creating' => '最初のコミットを作成中...',
			'common.gitPanel.noCommits.description' => 'このリポジトリにはまだコミットがありません。最初のコミットを作成して変更の追跡を開始してください。',
			'common.gitPanel.noCommits.title' => 'まだコミットがありません',
			'common.gitPanel.noMatchingBranches' => '一致するブランチがありません',
			'common.gitPanel.noRepo.description' => 'このプロジェクトはまだ git リポジトリではありません。初期化して変更の追跡とソース管理を開始してください。',
			'common.gitPanel.noRepo.init' => 'git init を実行',
			'common.gitPanel.noRepo.initializing' => 'リポジトリを初期化中...',
			'common.gitPanel.noRepo.title' => 'git リポジトリがありません',
			'common.gitPanel.noStagedFiles' => 'ステージされたファイルがありません',
			'common.gitPanel.none' => 'なし',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => '${remote} へプッシュするものがありません',
			'common.gitPanel.openFile' => 'クリックでファイルを開く',
			'common.gitPanel.publish' => '公開',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => '「${branch}」を ${remote} に公開',
			'common.gitPanel.publishing' => '公開中…',
			'common.gitPanel.pull' => 'プル',
			'common.gitPanel.pullCount' => ({required Object count}) => 'プル ${count}',
			'common.gitPanel.pullTitle' => ({required Object remote, required Object count}) => '${remote} から ${count} 件を取得',
			'common.gitPanel.pulling' => 'Pull 中…',
			'common.gitPanel.push' => 'プッシュ',
			'common.gitPanel.pushCount' => ({required Object count}) => 'プッシュ ${count}',
			'common.gitPanel.pushTitle' => ({required Object remote, required Object count}) => '${remote} へ ${count} 件を送信',
			'common.gitPanel.pushing' => 'Push 中…',
			'common.gitPanel.recentCommits' => '最近のコミット',
			'common.gitPanel.refresh' => 'git ステータスを更新',
			'common.gitPanel.remove' => '削除',
			'common.gitPanel.removeWorktree.alsoDelete' => 'ブランチも削除',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => '${branch} の worktree を削除しますか？フォルダは削除され、リンクされたプロジェクトはアーカイブされます。チャットセッションは復元可能です。',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => 'この worktree には失われる未コミットの変更が ${count} 件あります。',
			'common.gitPanel.removeWorktree.discardChanges' => '未コミットの変更を破棄',
			'common.gitPanel.removeWorktree.title' => 'Worktree を削除',
			'common.gitPanel.removing' => '削除中...',
			'common.gitPanel.revertLatest' => '最新のローカルコミットを取り消す',
			'common.gitPanel.scroll' => 'スクロール',
			'common.gitPanel.searchBranches' => 'ブランチを検索...',
			'common.gitPanel.selectAll' => 'すべて選択',
			'common.gitPanel.selectProject' => 'プロジェクトを選択してソース管理を表示',
			'common.gitPanel.selectedOf' => ({required Object total, required Object selected}) => '${total} ファイル中 ${selected} 件選択中',
			'common.gitPanel.selectedOfMobile' => ({required Object total, required Object selected}) => '${total} 中 ${selected} 件選択中',
			'common.gitPanel.sideBySide' => '並列',
			'common.gitPanel.stageAll' => 'すべてステージ',
			'common.gitPanel.stageHunk' => 'このハンクをステージ',
			'common.gitPanel.staged' => ({required Object count}) => 'ステージ済み (${count})',
			'common.gitPanel.status.added' => '追加',
			'common.gitPanel.status.deleted' => '削除',
			'common.gitPanel.status.modified' => '変更',
			'common.gitPanel.status.untracked' => '未追跡',
			'common.gitPanel.statusGuide' => 'ファイルステータスガイド',
			'common.gitPanel.switchScroll' => '水平スクロールに切り替え',
			'common.gitPanel.switchSplit' => '並列ビューに切り替え',
			'common.gitPanel.switchUnified' => '統合ビューに切り替え',
			'common.gitPanel.switchWrap' => '折り返しに切り替え',
			'common.gitPanel.unified' => '統合',
			'common.gitPanel.unstageAll' => 'すべてステージ解除',
			'common.gitPanel.unstageHunk' => 'このハンクをステージ解除',
			'common.gitPanel.upToDate' => '最新',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => '${remote} と最新',
			'common.gitPanel.viewAll' => 'すべて表示',
			'common.gitPanel.viewsAria' => 'ソース管理ビュー',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} 件の変更',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} 個の worktree',
			'common.gitPanel.worktrees.createFirst' => '最初の worktree を作成',
			'common.gitPanel.worktrees.detached' => '分離',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => '分離 @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => '分離された HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'worktree はブランチを独自のフォルダにチェックアウトするため、別々のチャットセッションを並行して実行し、準備ができたら結果をマージできます。',
			'common.gitPanel.worktrees.emptyTitle' => 'ブランチで並行作業',
			'common.gitPanel.worktrees.locked' => 'ロック中',
			'common.gitPanel.worktrees.mainWorktree' => 'メイン worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => '${branch} をベースブランチにマージ',
			'common.gitPanel.worktrees.kNew' => '新しい worktree',
			'common.gitPanel.worktrees.none' => 'worktree がありません',
			'common.gitPanel.worktrees.nothingToMerge' => 'マージするものがありません — ベースブランチより先行するコミットなし',
			'common.gitPanel.worktrees.open' => '開く',
			'common.gitPanel.worktrees.refresh' => 'worktree を更新',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => '${branch} の worktree を削除',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => '${branch} に切り替え',
			'common.gitPanel.wrap' => '折り返し',
			'common.gitPanel.tabs.changes' => '変更',
			'common.gitPanel.tabs.history' => 'コミット',
			'common.gitPanel.tabs.branches' => 'ブランチ',
			'common.gitPanel.tabs.worktrees' => 'ワークツリー',
			'common.gitPanel.save' => '保存',
			'common.gitPanel.worktreeScripts.title' => 'worktree スクリプト',
			'common.gitPanel.worktreeScripts.setup' => 'セットアップスクリプト (作成/オープン後に実行)',
			'common.gitPanel.worktreeScripts.run' => '開発サーバーを起動',
			'common.gitPanel.worktreeScripts.stop' => '開発サーバーを停止',
			'common.gitPanel.worktreeScripts.runScript' => '実行スクリプト (開発サーバー、必要時)',
			'common.gitPanel.worktreeScripts.runPort' => 'プレビューポート (任意 — 空欄の場合は自動検出)',
			'common.gitPanel.worktreeScripts.invalidPort' => 'ポートは 1〜65535 の範囲で指定してください',
			'common.gitPanel.worktreeScripts.sourceProject' => 'プロジェクトのオーバーライドとして保存済み',
			'common.gitPanel.worktreeScripts.sourceFile' => '.ddagent/worktree.json から読み込み — 保存するとプロジェクトのオーバーライドが作成されます',
			'common.gitPanel.worktreeScripts.sourceNone' => 'まだ何も設定されていません',
			'common.gitPanel.worktreeScripts.saving' => '保存中…',
			'common.gitPanel.worktreeScripts.setupRunning' => 'セットアップ実行中',
			'common.gitPanel.worktreeScripts.setupFailed' => 'セットアップ失敗',
			'common.gitPanel.worktreeScripts.running' => '実行中',
			'common.gitPanel.worktreeScripts.openPreview' => 'プレビューを開く',
			'common.gitPanel.worktreeScripts.runExited' => ({required Object code}) => '実行が終了しました (${code})',
			'common.sessions.renameSession' => 'セッション名を変更',
			'common.projects.newSession' => '新しいセッション',
			'common.sharedNotes.subtitle' => '共有メモリ — このプロジェクトのすべてのセッションに挿入されます',
			'common.sharedNotes.save' => '保存',
			'common.sharedNotes.saving' => '保存中…',
			'common.sharedNotes.noProject' => '共有コンテキストを編集するワークスペースを選択してください',
			'common.sharedNotes.placeholder' => '# 共有コンテキスト\nすべてのエージェントが知っておくべき規約、決定事項、参照先…',
			'common.codeBlock.wrapLines' => '行を折り返す',
			'common.codeBlock.noWrap' => '折り返しなし',
			'common.update.available' => ({required Object version}) => '更新があります · v${version}',
			'common.update.confirm' => ({required Object version}) => 'v${version} に更新しますか？サーバーは自動で更新して再起動します — アクティブなセッションは中断されます。',
			'common.update.downloading' => '更新をダウンロードして適用中…',
			'common.update.restarting' => 'サーバーを再起動中 — しばらくお待ちください…',
			'common.update.done' => ({required Object version}) => 'v${version} に更新しました。新しいバンドルを反映するにはアプリを再読み込みしてください。',
			'common.update.manualRestart' => '更新は適用されましたが、サーバーは自動で再起動しませんでした — 手動で再起動して完了してください。',
			'common.update.failed' => '更新に失敗しました。',
			'common.update.failedTitle' => '更新に失敗しました',
			'common.update.appConfirm' => ({required Object version}) => 'この端末に DDAgent v${version} をインストールしますか？ 初回は Android が DDAgent からのインストール許可を求めます。',
			'common.update.appPermission' => 'DDAgent に「提供元不明のアプリ」のインストールを許可してから、もう一度「更新」をタップしてください。',
			'common.update.chooseTitle' => 'アップデートがあります',
			'common.update.targetApp' => 'このアプリ',
			'common.update.targetWeb' => 'Web インターフェイス',
			'common.update.targetServer' => 'サーバー',
			'common.update.updateApp' => 'アプリを更新',
			'common.update.updateWeb' => 'Web インターフェイスを更新',
			'common.update.updateServer' => 'サーバーを更新',
			'common.update.webConfirm' => ({required Object version}) => 'Web インターフェイスを v${version} に更新しますか？更新後にページが再読み込みされます。',
			'common.update.webDone' => ({required Object version}) => 'Web インターフェイスを v${version} に更新しました — 再読み込みしています…',
			'common.update.localServerConfirm' => ({required Object version}) => 'このデバイスのローカルサーバーを v${version} に更新しますか？実行中のセッションは中断されます。',
			'common.update.localServerUpdating' => 'ローカルサーバーをダウンロードして起動しています…',
			'common.update.serverDone' => ({required Object version}) => 'サーバーは v${version} で動作しています。',
			'common.update.staged' => ({required Object version}) => 'アップデート v${version} をダウンロードしました — インストールするにはサーバーを再起動してください。',
			'common.update.upToDate' => 'サーバーはすでに最新のリリースです。',
			'common.update.webHostFailed' => ({required Object message}) => 'サーバーは更新されましたが、Web インターフェイスは更新されませんでした：${message}',
			'common.appShell.panelActive' => ({required Object count}) => 'パネル · ${count} 件実行中',
			'common.errors.forbidden' => 'アクセスが拒否されました',
			'settings.title' => '設定',
			'settings.changelog.title' => '変更履歴',
			'settings.changelog.loading' => '読み込み中…',
			'settings.changelog.empty' => '表示するリリースがありません',
			'settings.changelog.current' => '現在',
			'settings.changelog.kNew' => '新規',
			'settings.server.title' => 'サーバー',
			'settings.server.description' => 'DDAgent プロセスを再起動します — 更新後や応答しない状態からの回復に便利です。',
			'settings.server.restart' => '再起動',
			'settings.server.restartConfirm' => 'DDAgent サーバーを再起動しますか?アクティブなセッションは中断されます。',
			'settings.server.restarting' => '再起動中… サーバーが戻り次第、ページを再読み込みします。',
			'settings.server.restartFailed' => '再起動に失敗しました',
			'settings.server.unsupported' => '再起動は、サーバーがサービスマネージャー管理下で動作している場合のみ利用できます。',
			'settings.server.ok' => 'OK',
			'settings.server.restartTitle' => 'サーバーを再起動しています',
			'settings.server.restartRequesting' => 'サーバーに再起動を要求しています…',
			'settings.server.restartWaiting' => ({required Object seconds}) => 'サーバーの復帰を待っています…（${seconds} 秒）',
			'settings.server.restartBack' => ({required Object version}) => 'サーバーが復帰しました — バージョン ${version}。',
			'settings.server.restartReloading' => 'ページを再読み込みしています…',
			'settings.server.restartTimeout' => ({required Object seconds}) => '${seconds} 秒以内にサーバーが復帰しませんでした。サービスのログ（/tmp/ddagent.log）を確認するか、手動で再起動してください。',
			'settings.updates.title' => '更新',
			'settings.updates.description' => 'GitHub で新しいデスクトップビルドを確認します。新しいバージョンは自動でダウンロードされ、終了時にインストールされます。',
			'settings.updates.descriptionMobile' => 'GitHub でこのアプリの新しいビルドを確認します。更新はデバイスのシステムインストーラーでインストールされます。',
			'settings.updates.descriptionServer' => 'GitHub で新しい DDAgent リリースを確認します。接続中のサーバーは自身を更新できます — 再起動中はアクティブなセッションが中断されます。',
			'settings.updates.check' => '更新を確認',
			'settings.updates.checking' => '確認中…',
			'settings.updates.upToDate' => ({required Object version}) => '最新バージョンです（v${version}）。',
			'settings.updates.available' => ({required Object version}) => '更新 v${version} が見つかりました — バックグラウンドでダウンロード中。DDAgent 終了時にインストールされます。',
			'settings.updates.appAvailable' => ({required Object version}) => 'アプリの更新 v${version} があります — 「更新」をタップしてこのデバイスにインストールしてください。',
			'settings.updates.downloaded' => ({required Object version}) => '更新 v${version} をダウンロードしました — DDAgent を終了して再起動するとインストールされます。',
			'settings.updates.unavailable' => '更新チェックはパッケージ済みデスクトップビルドでのみ利用できます。',
			'settings.updates.error' => ({required Object message}) => '更新チェックに失敗しました: ${message}',
			'settings.updates.errorGeneric' => '更新チェックに失敗しました。',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · 最新 v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — 最新です',
			'settings.updates.webNotHosted' => ({required Object version}) => 'この Web インターフェイスは別にホストされています。リリースの ddagent-flutter-web-v${version}.zip でファイルを置き換えてください。',
			'settings.updates.serverCannotUpdate' => 'このサーバーはここから自動更新できません。install.sh またはリリースの tarball で再インストールしてください。',
			'settings.tabs.account' => 'アカウント',
			'settings.tabs.permissions' => '権限',
			'settings.tabs.mcpServers' => 'MCPサーバー',
			'settings.tabs.skills' => 'スキル',
			'settings.tabs.appearance' => '外観',
			'settings.account.title' => 'アカウント',
			'settings.account.language' => '言語',
			'settings.account.languageLabel' => '表示言語',
			'settings.account.languageDescription' => 'インターフェースの表示言語を選択してください',
			'settings.account.username' => 'ユーザー名',
			'settings.account.email' => 'メールアドレス',
			'settings.account.profile' => 'プロフィール',
			'settings.account.changePassword' => 'パスワードを変更',
			'settings.mcp.title' => 'MCPサーバー',
			'settings.mcp.addServer' => 'サーバーを追加',
			'settings.mcp.editServer' => 'サーバーを編集',
			'settings.mcp.deleteServer' => 'サーバーを削除',
			'settings.mcp.serverName' => 'サーバー名',
			'settings.mcp.serverType' => 'サーバーの種類',
			'settings.mcp.config' => '設定',
			'settings.mcp.testConnection' => '接続テスト',
			'settings.mcp.status' => '状態',
			_ => null,
		} ?? switch (path) {
			'settings.mcp.connected' => '接続済み',
			'settings.mcp.disconnected' => '未接続',
			'settings.mcp.scope.label' => 'スコープ',
			'settings.mcp.scope.user' => 'ユーザー',
			'settings.mcp.scope.project' => 'プロジェクト',
			'settings.appearance.title' => '外観',
			'settings.appearance.theme' => 'テーマ',
			'settings.appearance.codeEditor' => 'コードエディタ',
			'settings.appearance.editorTheme' => 'エディタのテーマ',
			'settings.appearance.wordWrap' => '折り返し',
			'settings.appearance.showMinimap' => 'ミニマップを表示',
			'settings.appearance.lineNumbers' => '行番号',
			'settings.appearance.fontSize' => 'フォントサイズ',
			'settings.appearance.themeModes.system' => 'システム',
			'settings.appearance.themeModes.light' => 'ライト',
			'settings.appearance.themeModes.dark' => 'ダーク',
			'settings.actions.saveChanges' => '変更を保存',
			'settings.actions.resetToDefaults' => 'デフォルトに戻す',
			'settings.actions.cancelChanges' => '変更をキャンセル',
			'settings.quickSettings.title' => 'クイック設定',
			'settings.quickSettings.sections.appearance' => '外観',
			'settings.quickSettings.sections.toolDisplay' => 'ツール表示',
			'settings.quickSettings.sections.inputSettings' => '入力設定',
			'settings.quickSettings.darkMode' => 'ダークモード',
			'settings.quickSettings.showRawParameters' => '生パラメータを表示',
			'settings.quickSettings.showThinking' => '思考を表示',
			'settings.quickSettings.sendByCtrlEnter' => 'Ctrl+Enterで送信',
			'settings.quickSettings.sendByCtrlEnterDescription' => '有効にすると、Enterではなく Ctrl+Enter でメッセージを送信します。IMEユーザーの誤送信防止に便利です。',
			'settings.quickSettings.dragHandle.dragging' => 'ドラッグ中',
			'settings.quickSettings.dragHandle.closePanel' => '設定パネルを閉じる',
			'settings.quickSettings.dragHandle.openPanel' => '設定パネルを開く',
			'settings.quickSettings.dragHandle.draggingStatus' => 'ドラッグ中...',
			'settings.quickSettings.dragHandle.toggleAndMove' => 'クリックで切替、ドラッグで移動',
			'settings.quickSettings.sendWithCtrlEnter' => 'Ctrl+Enterで送信',
			'settings.quickSettings.enterSendsHint' => 'オフの場合、Enter で送信し、Shift+Enter で改行します。',
			'settings.terminalShortcuts.title' => 'ターミナルショートカット',
			'settings.terminalShortcuts.sectionKeys' => 'キー',
			'settings.terminalShortcuts.sectionNavigation' => 'ナビゲーション',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => '上矢印',
			'settings.terminalShortcuts.arrowDown' => '下矢印',
			'settings.terminalShortcuts.scrollDown' => '下にスクロール',
			'settings.terminalShortcuts.killTitle' => '実行中のプロセスを終了 (Ctrl+C)',
			'settings.terminalShortcuts.handle.closePanel' => 'ショートカットパネルを閉じる',
			'settings.terminalShortcuts.handle.openPanel' => 'ショートカットパネルを開く',
			'settings.terminalShortcuts.paste' => '貼り付け',
			'settings.mainTabs.label' => '設定',
			'settings.mainTabs.agents' => 'エージェント',
			'settings.mainTabs.orchestration' => 'オーケストレーション',
			'settings.mainTabs.miniOrchestration' => 'ミニオーケストレーション',
			'settings.mainTabs.appearance' => '外観',
			'settings.mainTabs.workspaces' => 'ワークスペース',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API & トークン',
			'settings.mainTabs.models' => 'モデル',
			'settings.mainTabs.tasks' => 'タスク',
			'settings.mainTabs.browser' => 'Browser',
			'settings.mainTabs.tools' => 'ツール',
			'settings.mainTabs.notifications' => '通知',
			'settings.mainTabs.about' => '概要',
			'settings.mainTabs.quota' => 'コントロールセンター',
			'settings.mainTabs.shortcuts' => 'キーボードショートカット',
			'settings.miniOrchestration.title' => 'ミニオーケストレーション',
			'settings.miniOrchestration.description' => '2 モデル構成のパイプライン: 非 flash の思考モデルが計画し、flash のワーカーが実行します。',
			'settings.miniOrchestration.loading' => 'ミニオーケストレーション設定を読み込み中…',
			'settings.miniOrchestration.loadError' => 'ミニオーケストレーション設定を読み込めませんでした。',
			'settings.miniOrchestration.enable.label' => 'ミニオーケストレーションを有効化',
			'settings.miniOrchestration.enable.description' => 'Auto (mini) セッションをフルオーケストレーターではなく 2 ロールエンジン経由でルーティングします。',
			'settings.miniOrchestration.thinker.title' => '思考モデル (非 flash)',
			'settings.miniOrchestration.thinker.description' => '計画、判断、レビューを行い、最終レポートを作成します。',
			'settings.miniOrchestration.worker.title' => 'ワーカー (flash)',
			'settings.miniOrchestration.worker.description' => '計画された各ステップを実行します。',
			'settings.miniOrchestration.fields.provider' => 'プロバイダー',
			'settings.miniOrchestration.fields.model' => 'モデル',
			'settings.miniOrchestration.fields.modelPlaceholder' => 'モデルを選択',
			'settings.miniOrchestration.fields.tier' => 'ティア',
			'settings.miniOrchestration.roles.title' => 'タスク別モデル',
			'settings.miniOrchestration.roles.description' => '各タスクタイプをどのモデル (ロール) が担当するか。',
			'settings.miniOrchestration.planner.title' => 'プランナー',
			'settings.miniOrchestration.planner.mode' => 'モード',
			'settings.miniOrchestration.planner.modes.auto' => '思考モデルで計画',
			'settings.miniOrchestration.planner.modes.off' => '単一ステップ',
			'settings.miniOrchestration.planner.requireConfirmLabel' => '実行前にプランを確認',
			'settings.orchestration.title' => 'オーケストレーション',
			'settings.orchestration.description' => 'チャットのタスクをプロバイダーとモデルに振り分けます。',
			'settings.orchestration.loading' => 'オーケストレーション設定を読み込み中…',
			'settings.orchestration.loadError' => 'オーケストレーション設定を読み込めませんでした。',
			'settings.orchestration.retry' => '再試行',
			'settings.orchestration.enable.label' => 'オーケストレーションを有効化',
			'settings.orchestration.enable.description' => 'すべてを 1 つのプロバイダーで実行する代わりに、オーケストレーターがステップごとにモデルを選びます。',
			'settings.orchestration.pool.title' => '候補プール',
			'settings.orchestration.pool.description' => 'ルーターが選択できるモデル。それぞれコスト階層に紐付けられます。',
			'settings.orchestration.pool.add' => '候補を追加',
			'settings.orchestration.pool.empty' => '候補はまだありません — 追加するとルーティングを開始できます。',
			'settings.orchestration.pool.fields.label' => 'ラベル',
			'settings.orchestration.pool.fields.labelPlaceholder' => '例: SWE-2 Medium',
			'settings.orchestration.pool.fields.provider' => 'プロバイダー',
			'settings.orchestration.pool.fields.model' => 'モデル',
			'settings.orchestration.pool.fields.modelPlaceholder' => 'モデルを選択',
			'settings.orchestration.pool.fields.effort' => '推論レベル',
			'settings.orchestration.pool.fields.effortDefault' => 'プロバイダーのデフォルト',
			'settings.orchestration.pool.fields.effortPlaceholder' => 'デフォルト',
			'settings.orchestration.pool.fields.account' => 'アカウント',
			'settings.orchestration.pool.fields.accountDefault' => 'プロバイダーのデフォルト',
			'settings.orchestration.pool.fields.redundantAccounts' => '冗長アカウント',
			'settings.orchestration.pool.fields.redundantAccountsNone' => 'このプロバイダーの他のアカウントはありません',
			'settings.orchestration.pool.fields.tier' => 'コスト階層',
			'settings.orchestration.pool.fields.remove' => '候補を削除',
			'settings.orchestration.pool.fields.moveUp' => '上へ移動',
			'settings.orchestration.pool.fields.moveDown' => '下へ移動',
			'settings.orchestration.tiers.free' => '無料',
			'settings.orchestration.tiers.cheap' => '低価格',
			'settings.orchestration.tiers.mid' => '中価格',
			'settings.orchestration.tiers.premium' => 'プレミアム',
			'settings.orchestration.rules.title' => 'ルーティングルール',
			'settings.orchestration.rules.description' => 'タスクタイプごとに順序付けされた候補 — 最初に利用可能なものが選ばれます。',
			'settings.orchestration.rules.addCandidate' => '候補を追加…',
			'settings.orchestration.rules.empty' => '候補がありません — このタスクタイプのルーティング先がありません。',
			'settings.orchestration.rules.missing' => '(削除済み)',
			'settings.orchestration.rules.remove' => '候補を削除',
			'settings.orchestration.rules.taskTypes.plan' => '計画',
			'settings.orchestration.rules.taskTypes.quick' => '簡単な質問への回答',
			'settings.orchestration.rules.taskTypes.research' => '調査',
			'settings.orchestration.rules.taskTypes.docs' => 'ドキュメント',
			'settings.orchestration.rules.taskTypes.code' => 'コーディング',
			'settings.orchestration.rules.taskTypes.codeHard' => '複雑なコーディング',
			'settings.orchestration.rules.taskTypes.test' => 'テスト',
			'settings.orchestration.rules.taskTypes.review' => 'レビュー',
			'settings.orchestration.rules.taskTypes.report' => 'レポート',
			'settings.orchestration.planner.title' => 'プランナー',
			'settings.orchestration.planner.description' => 'リクエストをルーティング用のステップに分割する方法。',
			'settings.orchestration.planner.modeLabel' => '計画モード',
			'settings.orchestration.planner.modes.auto' => '自動 (LLM)',
			'settings.orchestration.planner.modes.template' => 'テンプレート',
			'settings.orchestration.planner.modes.off' => 'オフ',
			'settings.orchestration.planner.modeHints.auto' => 'プランナーモデルが各リクエストを種類付きのステップに分解します。',
			'settings.orchestration.planner.modeHints.template' => 'リクエストは下で選択した固定パイプラインで実行されます。',
			'settings.orchestration.planner.modeHints.off' => '計画なし — リクエスト全体を 1 つのステップとしてルーティングします。',
			'settings.orchestration.planner.candidateLabel' => 'プランナーモデル',
			'settings.orchestration.planner.candidateDescription' => 'プラン生成と分類の呼び出しに使うプール内の候補。',
			'settings.orchestration.planner.candidatePlaceholder' => 'プールの候補を選択',
			'settings.orchestration.planner.templates.title' => 'パイプラインテンプレート',
			'settings.orchestration.planner.templates.add' => 'テンプレートを追加',
			'settings.orchestration.planner.templates.namePlaceholder' => 'テンプレート名',
			'settings.orchestration.planner.templates.addStep' => 'ステップを追加…',
			'settings.orchestration.planner.templates.remove' => 'テンプレートを削除',
			'settings.orchestration.planner.templates.removeStep' => 'ステップを削除',
			'settings.orchestration.planner.templates.empty' => 'テンプレートはまだありません。',
			'settings.orchestration.planner.templates.emptySteps' => 'ステップはまだありません — 下で追加してください。',
			'settings.orchestration.planner.requireConfirm' => '実行前にプランを確認',
			'settings.orchestration.planner.requireConfirmDescription' => '計画後に一時停止し、プランカードでステップを編集・無効化できるようにします。',
			'settings.orchestration.planner.checkpointLabel' => '自律性',
			'settings.orchestration.planner.checkpointModes.off' => '自律',
			'settings.orchestration.planner.checkpointModes.perStep' => 'ステップごと',
			'settings.orchestration.planner.checkpointModes.everyN' => 'N ステップごと',
			'settings.orchestration.planner.checkpointHints.off' => 'スーパーバイザーの判断を確認なしで実行します (自動モード)。',
			'settings.orchestration.planner.checkpointHints.perStep' => '提案されたステップのまとまりごとに承認を求めます。',
			'settings.orchestration.planner.checkpointHints.everyN' => 'N ステップ完了するたびに承認を求めます。',
			'settings.orchestration.planner.checkpointIntervalLabel' => 'チェックポイント間のステップ数 (1–50)',
			'settings.orchestration.execution.title' => '実行制限',
			'settings.orchestration.execution.description' => '並列実行と修正ループのガードレール。',
			'settings.orchestration.execution.maxParallel' => '最大並列ステップ数',
			'settings.orchestration.execution.maxParallelDescription' => '同時に実行できるサブタスクの数 (1–8)。',
			'settings.orchestration.execution.maxFixLoops' => '最大修正ループ数',
			'settings.orchestration.execution.maxFixLoopsDescription' => 'ステップが検証に失敗したときの再試行回数 (0–5)。',
			'settings.orchestration.execution.onNoCandidate' => '利用可能な候補がない場合',
			'settings.orchestration.execution.onNoCandidateDescription' => 'フォールバック前に確認するか、ステップをスキップします。',
			'settings.orchestration.execution.onNoCandidateOptions.ask' => '確認する',
			'settings.orchestration.execution.onNoCandidateOptions.skip' => 'ステップをスキップ',
			'settings.orchestration.execution.useWorktree' => '分離された worktree',
			'settings.orchestration.execution.useWorktreeDescription' => '委任されたすべてのステップを、プロジェクトディレクトリではなく 1 つの共有 git worktree で実行します。',
			'settings.orchestration.execution.maxSupervisorIterations' => 'スーパーバイザーの最大反復回数',
			'settings.orchestration.execution.maxSupervisorIterationsDescription' => '自動モードでのスーパーバイザー判断ラウンドの上限 (1–100)。上限に達すると部分レポートで実行を終了します。',
			'settings.orchestration.execution.maxAttempts' => 'ステップごとの最大試行回数',
			'settings.orchestration.execution.maxAttemptsDescription' => '1 ステップあたりのレーンと再試行をまたいだ総試行回数 (1–50)。',
			'settings.orchestration.execution.stepTimeoutMs' => 'ステップのタイムアウト (ms)',
			'settings.orchestration.execution.stepTimeoutMsDescription' => '試行ごとの子実行のタイムアウト (ミリ秒)。0 で無効。',
			'settings.orchestration.execution.runTimeoutMs' => '実行のタイムアウト (ms)',
			'settings.orchestration.execution.runTimeoutMsDescription' => 'プラン実行全体のタイムアウト (ミリ秒)。0 で無効。',
			'settings.orchestration.execution.retryBackoffBaseMs' => '再試行バックオフの基準値 (ms)',
			'settings.orchestration.execution.retryBackoffBaseMsDescription' => '同一レーンでの再試行間の指数バックオフの基準値 (フルジッター)。',
			'settings.orchestration.execution.retryBudgetTitle' => '失敗クラスごとの再試行回数',
			'settings.orchestration.execution.retryBudgetDescription' => 'フェイルオーバー/クールダウン前の同一レーンでの再試行回数 (0–5)。',
			'settings.orchestration.execution.retryClasses.rateLimit' => 'レート制限',
			'settings.orchestration.execution.retryClasses.quota' => 'クォータ',
			'settings.orchestration.execution.retryClasses.auth' => '認証',
			'settings.orchestration.execution.retryClasses.timeout' => 'タイムアウト',
			'settings.orchestration.execution.retryClasses.transient' => '一時的なエラー',
			'settings.orchestration.save.unsaved' => '未保存の変更',
			'settings.orchestration.save.save' => '保存',
			'settings.orchestration.save.saving' => '保存中…',
			'settings.orchestration.save.saved' => '保存しました',
			'settings.orchestration.save.discard' => '破棄',
			'settings.orchestration.save.error' => '保存に失敗しました',
			'settings.orchestration.save.emptyPool' => '保存する前に候補を 1 つ以上追加してください。',
			'settings.notifications.title' => '通知',
			'settings.notifications.description' => '受信する通知イベントを設定します。',
			'settings.notifications.webPush.title' => 'Webプッシュ通知',
			'settings.notifications.webPush.enable' => 'プッシュ通知を有効にする',
			'settings.notifications.webPush.disable' => 'プッシュ通知を無効にする',
			'settings.notifications.webPush.enabled' => 'プッシュ通知は有効です',
			'settings.notifications.webPush.loading' => '更新中...',
			'settings.notifications.webPush.unsupported' => 'このブラウザではプッシュ通知がサポートされていません。',
			'settings.notifications.webPush.denied' => 'プッシュ通知がブロックされています。ブラウザの設定で許可してください。',
			'settings.notifications.webPush.iosHint' => 'iPhone/iPad では、DDAgent をホーム画面に追加し（共有 → ホーム画面に追加）、そのインストール済みアプリで通知を有効にした後でのみ通知が機能します。',
			'settings.notifications.webPush.test' => 'テスト通知を送信',
			'settings.notifications.webPush.testNoSubscription' => '登録済みデバイスがありません。先にスマホで「有効にする」をタップしてください。',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => '${count} 台のデバイスに送信しました。スマホに表示されない場合は DDAgent をホーム画面に追加してください（iOS の要件）。',
			'settings.notifications.webPush.testNotDelivered' => '到達可能なデバイスがありませんでした。アプリが実行中で、通知が有効になっていることを確認してください。',
			'settings.notifications.device.title' => 'このデバイスに通知',
			'settings.notifications.device.enabled' => 'このデバイスの通知が有効になっています',
			'settings.notifications.desktop.title' => 'このデスクトップアプリに通知',
			'settings.notifications.desktop.enable' => 'プッシュ通知を有効にする',
			'settings.notifications.desktop.disable' => 'プッシュ通知を無効にする',
			'settings.notifications.desktop.enabled' => 'このデスクトップアプリの通知が有効です',
			'settings.notifications.desktop.unsupported' => 'このシステムではデスクトップ通知はサポートされていません。',
			'settings.notifications.sound.title' => 'サウンド',
			'settings.notifications.sound.description' => 'チャット実行が完了したときに短い音を再生します。',
			'settings.notifications.sound.enabled' => '有効',
			'settings.notifications.sound.test' => 'サウンドをテスト',
			'settings.notifications.events.title' => 'イベント種別',
			'settings.notifications.events.actionRequired' => '対応が必要',
			'settings.notifications.events.stop' => '実行停止',
			'settings.notifications.events.error' => '実行失敗',
			'settings.notifications.messaging.title' => 'メッセンジャーでの承認',
			'settings.notifications.messaging.description' => 'Telegram からエージェントの権限リクエストを承認・拒否し、Discord で実行通知を受け取ります。',
			'settings.notifications.messaging.enabled' => '有効',
			'settings.notifications.messaging.save' => '保存',
			'settings.notifications.messaging.test' => 'テスト',
			'settings.notifications.messaging.pair' => 'ペアリング',
			'settings.notifications.messaging.telegramToken' => '@BotFather で取得したボットトークン (123456:ABC…)',
			'settings.notifications.messaging.telegramHint' => 'ボットに任意のメッセージを送信してから、下でチャットをペアリングしてください。',
			'settings.notifications.messaging.discordWebhook' => 'https://discord.com/api/webhooks/…',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.unpair' => 'ペアリングを解除',
			'settings.appearanceSettings.darkMode.label' => 'ダークモード',
			'settings.appearanceSettings.darkMode.description' => 'ライトテーマとダークテーマを切り替えます',
			'settings.appearanceSettings.codeEditor.title' => 'コードエディタ',
			'settings.appearanceSettings.codeEditor.theme.label' => 'エディタのテーマ',
			'settings.appearanceSettings.codeEditor.theme.description' => 'コードエディタのデフォルトテーマ',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => '折り返し',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => 'エディタでデフォルトで折り返しを有効にします',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => 'ミニマップを表示',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => '差分ビューでナビゲーション用のミニマップを表示します',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => '行番号を表示',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => 'エディタに行番号を表示します',
			'settings.appearanceSettings.codeEditor.fontSize.label' => 'フォントサイズ',
			'settings.appearanceSettings.codeEditor.fontSize.description' => 'エディタのフォントサイズ（ピクセル）',
			'settings.appearanceSettings.terminal.title' => 'ターミナル',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => 'フォーカスはポインターに従う',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => 'マウスを上に移動したときに入力用にターミナルへフォーカスする',
			'settings.mcpForm.title.add' => 'MCPサーバーを追加',
			'settings.mcpForm.title.edit' => 'MCPサーバーを編集',
			'settings.mcpForm.importMode.form' => 'フォーム入力',
			'settings.mcpForm.importMode.json' => 'JSONインポート',
			'settings.mcpForm.scope.label' => 'スコープ',
			'settings.mcpForm.scope.userGlobal' => 'ユーザー（グローバル）',
			'settings.mcpForm.scope.projectLocal' => 'プロジェクト（ローカル）',
			'settings.mcpForm.scope.userDescription' => 'ユーザースコープ: すべてのプロジェクトで利用可能',
			'settings.mcpForm.scope.projectDescription' => 'ローカルスコープ: 選択したプロジェクトでのみ利用可能',
			'settings.mcpForm.scope.cannotChange' => '既存のサーバーを編集する場合、スコープは変更できません',
			'settings.mcpForm.fields.serverName' => 'サーバー名',
			'settings.mcpForm.fields.transportType' => 'トランスポートの種類',
			'settings.mcpForm.fields.command' => 'コマンド',
			'settings.mcpForm.fields.arguments' => '引数（1行に1つ）',
			'settings.mcpForm.fields.jsonConfig' => 'JSON設定',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => '環境変数（KEY=value、1行に1つ）',
			'settings.mcpForm.fields.headers' => 'ヘッダー（KEY=value、1行に1つ）',
			'settings.mcpForm.fields.selectProject' => 'プロジェクトを選択...',
			'settings.mcpForm.placeholders.serverName' => 'my-server',
			'settings.mcpForm.validation.missingType' => '必須フィールドがありません: type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdioタイプにはcommandフィールドが必要です',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type}タイプにはurlフィールドが必要です',
			'settings.mcpForm.validation.invalidJson' => '無効なJSON形式です',
			'settings.mcpForm.validation.jsonHelp' => 'MCPサーバー設定をJSON形式で貼り付けてください。例:',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => '設定の詳細（${configFile}より）',
			'settings.mcpForm.projectPath' => ({required Object path}) => 'パス: ${path}',
			'settings.mcpForm.actions.cancel' => 'キャンセル',
			'settings.mcpForm.actions.saving' => '保存中...',
			'settings.mcpForm.actions.addServer' => 'サーバーを追加',
			'settings.mcpForm.actions.updateServer' => 'サーバーを更新',
			'settings.saveStatus.success' => '設定を保存しました！',
			'settings.saveStatus.error' => '設定の保存に失敗しました',
			'settings.saveStatus.saving' => '保存中...',
			'settings.footerActions.save' => '設定を保存',
			'settings.footerActions.cancel' => 'キャンセル',
			'settings.git.title' => 'Git設定',
			'settings.git.description' => 'コミット用のGit IDを設定します。この設定は git config --global で適用されます',
			'settings.git.name.label' => 'Git名前',
			'settings.git.name.help' => 'コミットに使用する名前',
			'settings.git.name.placeholder' => '山田 太郎',
			'settings.git.email.label' => 'Gitメールアドレス',
			'settings.git.email.help' => 'コミットに使用するメールアドレス',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => '設定を保存',
			'settings.git.actions.saving' => '保存中...',
			'settings.git.status.success' => '保存しました',
			'settings.git.status.error' => '保存に失敗しました',
			'settings.apiKeys.title' => 'APIキー',
			'settings.apiKeys.description' => '外部APIにアクセスするためのAPIキーを生成します。',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ APIキーを保存してください',
			'settings.apiKeys.newKey.alertMessage' => 'このキーが表示されるのは今回限りです。安全な場所に保管してください。',
			'settings.apiKeys.newKey.iveSavedIt' => '保存しました',
			'settings.apiKeys.form.placeholder' => 'APIキーの名前（例: 本番サーバー）',
			'settings.apiKeys.form.createButton' => '作成',
			'settings.apiKeys.form.cancelButton' => 'キャンセル',
			'settings.apiKeys.newButton' => '新しいAPIキー',
			'settings.apiKeys.empty' => 'APIキーはまだ作成されていません。',
			'settings.apiKeys.list.created' => '作成日:',
			'settings.apiKeys.list.lastUsed' => '最終使用日:',
			'settings.apiKeys.confirmDelete' => 'このAPIキーを削除してもよろしいですか？',
			'settings.apiKeys.status.active' => '有効',
			'settings.apiKeys.status.inactive' => '無効',
			'settings.apiKeys.github.title' => 'GitHubトークン',
			'settings.apiKeys.github.description' => '外部APIからプライベートリポジトリをクローンするためのGitHubパーソナルアクセストークンを追加します。',
			'settings.apiKeys.github.descriptionAlt' => 'プライベートリポジトリをクローンするためのGitHubパーソナルアクセストークンを追加します。保存せずにAPIリクエストで直接トークンを渡すこともできます。',
			'settings.apiKeys.github.addButton' => 'トークンを追加',
			'settings.apiKeys.github.form.namePlaceholder' => 'トークンの名前（例: 個人リポジトリ）',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHubパーソナルアクセストークン（ghp_...）',
			'settings.apiKeys.github.form.descriptionPlaceholder' => '説明（任意）',
			'settings.apiKeys.github.form.addButton' => 'トークンを追加',
			'settings.apiKeys.github.form.cancelButton' => 'キャンセル',
			'settings.apiKeys.github.form.howToCreate' => 'GitHubパーソナルアクセストークンの作成方法 →',
			'settings.apiKeys.github.form.showToken' => 'トークンを表示',
			'settings.apiKeys.github.form.hideToken' => 'トークンを非表示',
			'settings.apiKeys.github.empty' => 'GitHubトークンはまだ追加されていません。',
			'settings.apiKeys.github.added' => '追加日:',
			'settings.apiKeys.github.confirmDelete' => 'このGitHubトークンを削除してもよろしいですか？',
			'settings.apiKeys.apiDocsLink' => 'APIドキュメント',
			'settings.apiKeys.documentation.title' => '外部APIドキュメント',
			'settings.apiKeys.documentation.description' => '外部APIを使用してアプリケーションからClaude/Cursorセッションを起動する方法を学びます。',
			'settings.apiKeys.documentation.viewLink' => 'APIドキュメントを見る →',
			'settings.apiKeys.loading' => '読み込み中...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => 'アップデートあり: v${version}',
			'settings.tasks.checking' => 'TaskMasterのインストールを確認しています...',
			'settings.tasks.notInstalled.title' => 'TaskMaster AI CLIがインストールされていません',
			'settings.tasks.notInstalled.description' => 'タスク管理機能を使用するにはTaskMaster CLIが必要です。以下のコマンドでインストールしてください:',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => 'GitHubで見る',
			'settings.tasks.notInstalled.afterInstallation' => 'インストール後:',
			'settings.tasks.notInstalled.steps.restart' => 'このアプリケーションを再起動してください',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster機能が自動的に利用可能になります',
			'settings.tasks.notInstalled.steps.initCommand' => 'プロジェクトディレクトリで task-master init を実行してください',
			'settings.tasks.settings.enableLabel' => 'TaskMaster統合を有効にする',
			'settings.tasks.settings.enableDescription' => 'インターフェース全体でTaskMasterのタスク、バナー、サイドバーインジケータを表示します',
			'settings.agents.authStatus.checking' => '確認中...',
			'settings.agents.authStatus.connected' => '接続済み',
			'settings.agents.authStatus.notConnected' => '未接続',
			'settings.agents.authStatus.disconnected' => '切断',
			'settings.agents.authStatus.checkingAuth' => '認証状態を確認しています...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => '${email}でログイン中',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider} アカウント',
			'settings.agents.authStatus.authenticatedUser' => '認証済みユーザー',
			'settings.agents.install.title' => ({required Object agent}) => '${agent} CLI がインストールされていません',
			'settings.agents.install.description' => ({required Object agent}) => 'ログインしてセッションを実行するには ${agent} CLI をインストールしてください。',
			'settings.agents.install.button' => 'インストール',
			'settings.agents.install.installing' => 'インストール中…',
			'settings.agents.install.copyCommand' => 'コマンドをコピー',
			'settings.agents.install.docs' => 'ドキュメント',
			'settings.agents.install.success' => ({required Object agent}) => '${agent} CLI をインストールしました',
			'settings.agents.install.failed' => 'インストールに失敗しました — ターミナルの出力を確認してください',
			'settings.agents.update.title' => 'CLI を更新',
			'settings.agents.update.description' => ({required Object agent}) => '${agent} CLI の最新バージョンをサーバーホストにインストールします。',
			'settings.agents.update.button' => '更新',
			'settings.agents.update.updating' => '更新中…',
			'settings.agents.update.success' => ({required Object agent}) => '${agent} CLI を更新しました',
			'settings.agents.update.failed' => '更新に失敗しました — ターミナルの出力を確認してください',
			'settings.agents.account.claude.description' => 'Anthropic Claude AIアシスタント',
			'settings.agents.account.cursor.description' => 'Cursor AI搭載コードエディタ',
			'settings.agents.account.codex.description' => 'OpenAI Codex AIアシスタント',
			'settings.agents.account.opencode.description' => 'OpenCode CLI アシスタント',
			'settings.agents.account.commandcode.description' => 'Command Code CLI アシスタント',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI アシスタント',
			'settings.agents.account.devin.description' => 'Devin CLI アシスタント',
			'settings.agents.connectionStatus' => '接続状態',
			'settings.agents.login.title' => 'ログイン',
			'settings.agents.login.reAuthenticate' => '再認証',
			'settings.agents.login.description' => ({required Object agent}) => '${agent}アカウントにサインインしてAI機能を有効にします',
			'settings.agents.login.reAuthDescription' => '別のアカウントでサインインするか、認証情報を更新します',
			'settings.agents.login.button' => 'ログイン',
			'settings.agents.login.reLoginButton' => '再ログイン',
			'settings.agents.logout.title' => 'ログアウト',
			'settings.agents.logout.description' => 'このプロバイダーからログアウトし、保存された認証情報を削除します',
			'settings.agents.logout.button' => 'ログアウト',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => '${agent} からログアウトしますか？',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => 'サーバーに保存された ${agent} の認証情報を削除します。${agent} を使い続けるには再度ログインしてください。',
			'settings.agents.logout.success' => 'ログアウトしました',
			'settings.agents.logout.failed' => 'ログアウトに失敗しました',
			'settings.agents.error' => ({required Object error}) => 'エラー: ${error}',
			'settings.agents.accounts.title' => '名前付きアカウント',
			'settings.agents.accounts.description' => '追加の認証情報セットです。アカウントに固定されたセッションは、そのアカウント専用の設定ディレクトリで CLI を起動します。表示された環境変数を付けてプロバイダーの CLI を一度実行し、ログインしてください。',
			'settings.agents.accounts.sharedCli' => 'すべてのアカウントは 1 つの CLI インストールを共有します — 上の接続カードで更新してください。',
			'settings.agents.accounts.loading' => 'アカウントを読み込み中…',
			'settings.agents.accounts.kDefault' => 'デフォルト',
			'settings.agents.accounts.usage' => ({required Object tokens}) => '${tokens} トークン',
			'settings.agents.accounts.usageButton' => '使用量',
			'settings.agents.accounts.showUsage' => 'トークン使用量を表示',
			'settings.agents.accounts.makeDefault' => 'デフォルトに設定',
			'settings.agents.accounts.remove' => 'アカウントを削除',
			'settings.agents.accounts.newLabel' => 'アカウントのラベル (例: 仕事用)',
			'settings.agents.accounts.add' => 'アカウントを追加',
			'settings.agents.accounts.autoSwitch.label' => '使用上限に達したらアカウントを自動切り替え',
			'settings.agents.accounts.autoSwitch.description' => 'アカウントが使用上限に達すると、セッションは同じエージェントのまだ残量がある別のアカウントに切り替わります。上限に達したアカウントを手動で選んだ場合も同様です。別のエージェントに切り替わることはありません。Claude と Codex は会話を引き継ぎ、その他のエージェントは新しいチャットでのみ切り替わります。',
			'settings.permissions.title' => '権限設定',
			'settings.permissions.permissionMode.title' => '権限モード',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => '新しい ${provider} セッションのデフォルト権限モード。個別のセッションで上書きできます。',
			'settings.permissions.permissionMode.modes.kDefault.title' => 'デフォルト',
			'settings.permissions.permissionMode.modes.kDefault.description' => '権限が必要なアクションはチャットで承認のために表示されます。',
			'settings.permissions.permissionMode.modes.auto.title' => '自動モード',
			'settings.permissions.permissionMode.modes.auto.description' => 'モデル分類器がツール呼び出しごとに承認または拒否を決定します。高い自律性。',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => '編集を許可',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => 'ファイル編集は自動承認されます。他のアクションは引き続き承認を求めます。',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => '権限をバイパス',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => 'すべてのアクションが自動承認されます — プロンプトなしの完全アクセス。注意して使用してください。',
			'settings.permissions.permissionMode.modes.plan.title' => 'プラン',
			'settings.permissions.permissionMode.modes.plan.description' => 'プランモード: エージェントはコマンドを実行せずに探索と計画を行います。',
			'settings.mcpServers.title' => 'MCPサーバー',
			'settings.mcpServers.description.claude' => 'Model Context Protocolサーバーは、Claudeに追加のツールやデータソースを提供します',
			'settings.mcpServers.description.cursor' => 'Model Context Protocolサーバーは、Cursorに追加のツールやデータソースを提供します',
			'settings.mcpServers.description.codex' => 'Model Context Protocolサーバーは、Codexに追加のツールやデータソースを提供します',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol サーバーは OpenCode に追加のツールとデータソースを提供します',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol サーバーは Command Code に追加のツールとデータソースを提供します',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol サーバーは Antigravity に追加のツールとデータソースを提供します',
			'settings.mcpServers.description.devin' => 'Model Context Protocol サーバーは Devin に追加のツールとデータソースを提供します',
			'settings.mcpServers.addButton' => 'MCPサーバーを追加',
			'settings.mcpServers.empty' => 'MCPサーバーは設定されていません',
			'settings.mcpServers.serverType' => '種類',
			'settings.mcpServers.scope.local' => 'ローカル',
			'settings.mcpServers.scope.user' => 'ユーザー',
			'settings.mcpServers.config.command' => 'コマンド',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => '引数',
			'settings.mcpServers.config.environment' => '環境変数',
			'settings.mcpServers.tools.title' => 'ツール',
			'settings.mcpServers.tools.count' => ({required Object count}) => '（${count}）:',
			'settings.mcpServers.tools.more' => ({required Object count}) => '他${count}件',
			'settings.mcpServers.actions.edit' => 'サーバーを編集',
			'settings.mcpServers.actions.delete' => 'サーバーを削除',
			'settings.mcpServers.managed.badge' => '管理対象',
			'settings.mcpServers.managed.hint' => 'DDAgent により管理。',
			'settings.mcpServers.help.title' => 'Codex MCPについて',
			'settings.mcpServers.help.description' => 'Codexはstdioベースのツールサーバーをサポートしています。追加のツールやリソースでCodexの機能を拡張するサーバーを追加できます。',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '「${serverName}」はプロバイダー設定から削除されます。',
			'settings.mcpServers.deleteConfirm.title' => 'MCP サーバーを削除しますか？',
			'settings.quota.settings.tab' => 'コントロールセンター',
			'settings.quota.settings.title' => 'コントロールセンター',
			'settings.quota.settings.description' => 'アラートしきい値、ルーティングポリシー、クォータをポーリングするアカウント。',
			'settings.quota.settings.saved' => '保存しました',
			'settings.quota.settings.alertsSection' => 'アラート',
			'settings.quota.settings.alertsSectionHint' => '上限が実際に尽きる前に警告します。100% になってからではありません。',
			'settings.quota.settings.alertsEnabled' => '上限予測アラート',
			'settings.quota.settings.alertsEnabledHint' => '概要とアカウントカードにペースベースの予測を表示します。',
			'settings.quota.settings.watchThreshold' => '監視しきい値 (%)',
			'settings.quota.settings.watchThresholdHint' => 'この読み取り以上のアカウントは危険とみなされます。',
			'settings.quota.settings.dangerThreshold' => '危険しきい値 (%)',
			'settings.quota.settings.dangerThresholdHint' => 'この値以上の読み取りは赤で表示されます。',
			'settings.quota.settings.routingSection' => 'ルーティング',
			'settings.quota.settings.routingSectionHint' => 'パネルが最も余裕のあるアカウントへ作業を移す方法。',
			'settings.quota.settings.routing.manual' => '手動',
			'settings.quota.settings.routing.manualHint' => '推奨のみ表示し、アカウントを自動切り替えしません。',
			'settings.quota.settings.routing.ask' => '切り替え前に確認',
			'settings.quota.settings.routing.askHint' => '切り替えが提案され、あなたの承認を待ちます。',
			'settings.quota.settings.routing.autoLowRisk' => '低リスクタスクは自動',
			'settings.quota.settings.routing.autoLowRiskHint' => '低リスクとマークされたタスクのみ自動的に移動できます。',
			'settings.quota.settings.routingNote' => 'アカウントの切り替えはコストとモデル品質を変えるため、常に明示的な決定が必要です。',
			'settings.quota.settings.accountsSection' => 'ポーリング対象アカウント',
			'settings.quota.settings.accountsSectionHint' => '認証情報は各ツールから読み取られます。パネルが他の場所に送信することはありません。',
			'settings.quota.settings.sourcesSection' => 'データソース',
			'settings.quota.settings.sourcesSectionHint' => '使用量とコストの数値の出どころ。',
			'settings.quota.settings.logSources' => 'トークン・コストログストア',
			'settings.quota.settings.logSourcesHint' => 'tokboard コレクターと共有される読み取り専用の集計ストア。',
			'settings.quota.settings.readOnly' => '読み取り専用',
			'settings.quota.settings.quotaConsent' => 'クォータポーリング',
			'settings.quota.settings.quotaConsentHint' => 'ローカルに保存された認証情報でプロバイダーのクォータエンドポイントを読み取ります。',
			'settings.quota.settings.localOnly' => 'ローカルのみ',
			'settings.quota.empty.description' => 'アカウントがまだ検出されていません。',
			'settings.quota.quality.cached' => 'キャッシュ',
			'settings.quota.quality.error' => 'エラー',
			'settings.quota.quality.estimate' => '推定',
			'settings.quota.quality.live' => 'ライブ',
			'settings.quota.quality.unknown' => '不明',
			'settings.quota.syncFailed' => '同期に失敗しました',
			'settings.quota.syncNow' => '今すぐ同期',
			'settings.browser.checking' => '確認中...',
			'settings.browser.description' => 'エージェントが監視付き Playwright ブラウザセッションを作成できるようにします。Browser タブで監視できます。',
			'settings.browser.enableDescription' => '対応エージェント向けに Browser を登録します。エージェントはブラウザセッションを作成でき、あなたは監視・停止・削除できます。',
			'settings.browser.enableLabel' => 'Browser を有効化',
			'settings.browser.errors.installRuntime' => 'ブラウザランタイムのインストールに失敗しました',
			'settings.browser.errors.loadSettings' => 'Browser 設定の読み込みに失敗しました',
			'settings.browser.errors.loadStatus' => 'Browser ステータスの読み込みに失敗しました',
			'settings.browser.errors.saveSettings' => 'Browser 設定の保存に失敗しました',
			'settings.browser.installHint' => 'エージェントが Browser セッションを作成する前に、ブラウザランタイムをインストールしてください。',
			'settings.browser.installRuntime' => 'ランタイムをインストール',
			'settings.browser.installed' => 'インストール済み',
			'settings.browser.installing' => 'インストール中...',
			'settings.browser.missing' => '未インストール',
			'settings.browser.runtimeRequired' => 'ブラウザランタイムが必要です',
			'settings.browser.statusDisabled' => '無効',
			'settings.browser.statusLabel' => 'ステータス',
			'settings.browser.statusReady' => '準備完了',
			'settings.browser.statusSetupRequired' => 'セットアップが必要',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => 'キャンセル',
			'settings.workspaces.create' => 'ワークスペースを追加',
			'settings.workspaces.deleteConfirm' => 'このワークスペースを DDAgent から削除しますか？ファイルはディスクに残ります。',
			'settings.workspaces.deleteFailed' => 'ワークスペースの削除に失敗しました。',
			_ => null,
		} ?? switch (path) {
			'settings.workspaces.deleteTitle' => 'ワークスペースを削除',
			'settings.workspaces.description' => 'ワークスペースは、DDAgent がチャット・コード実行・ブラウジングできるディレクトリです。',
			'settings.workspaces.remove' => 'ワークスペースを削除',
			'settings.workspaces.title' => 'ワークスペース',
			'settings.workspaces.pathRequired' => 'パスは必須です',
			'settings.stt.title' => '音声入力 (音声認識)',
			'settings.stt.description' => 'Whisper 互換の /audio/transcriptions エンドポイント (OpenAI、whisper.cpp、faster-whisper、Speaches)。入力欄のマイクボタンが有効になります。',
			'settings.stt.configured' => '設定済み',
			'settings.stt.endpoint' => 'エンドポイント URL (例: https://api.openai.com/v1)',
			'settings.stt.apiKey' => 'API キー',
			'settings.stt.model' => 'モデル (デフォルト: whisper-1)',
			'settings.stt.save' => '保存',
			'settings.schedules.title' => 'スケジュール',
			'settings.schedules.description' => 'cron の時刻表に従ってエージェントを定期実行します。実行は無人で行われ、権限確認はバイパスされます。',
			'settings.schedules.preventSleep' => 'エージェント実行中はスリープを防止',
			'settings.schedules.preventSleepHint' => 'デスクトップではディスプレイをオンのまま保ちます。ブラウザでは画面のウェイクロックを使用します。',
			'settings.schedules.kNew' => '新しいスケジュール',
			'settings.schedules.loading' => '読み込み中…',
			'settings.schedules.empty' => 'スケジュールはまだありません。',
			'settings.schedules.project' => 'プロジェクト',
			'settings.schedules.provider' => 'プロバイダー',
			'settings.schedules.cron' => 'Cron (分 時 日 月 曜日)',
			'settings.schedules.nextRun' => ({required Object time}) => '次回実行: ${time}',
			'settings.schedules.cronInvalid' => 'この式では今後の実行予定がありません',
			'settings.schedules.prompt' => 'プロンプト',
			'settings.schedules.useWorktree' => '新しい worktree で実行',
			'settings.schedules.catchUp' => '実行されなかった分を後から実行',
			'settings.schedules.failures' => ({required Object count}) => '${count} 件の失敗',
			'settings.schedules.disabled' => '無効',
			'settings.schedules.history' => '履歴',
			'settings.schedules.runNow' => '今すぐ実行',
			'settings.schedules.delete' => '削除',
			'settings.schedules.noRuns' => '実行履歴はまだありません。',
			'settings.schedules.next' => '次回',
			'settings.schedules.create' => '作成',
			'settings.schedules.toggleSchedule' => 'スケジュールを有効化',
			'settings.mcpTokens.title' => 'DDAgent MCP サーバートークン',
			'settings.mcpTokens.description' => '外部ツール (Claude Desktop、OpenClaw) は、これらのいずれかのベアラートークンを使って POST /mcp で DDAgent のツールを呼び出します。',
			'settings.mcpTokens.dismiss' => '閉じる',
			'settings.mcpTokens.labelPlaceholder' => 'トークンのラベル (例: Claude Desktop)',
			'settings.mcpTokens.create' => '作成',
			'settings.mcpTokens.empty' => 'MCP トークンはまだありません。',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => '${time} に使用',
			'settings.mcpTokens.neverUsed' => '未使用',
			'settings.about.supportTitle' => 'プロジェクトを支援',
			'settings.about.buyMeACoffee' => 'Buy Me a Coffee',
			'settings.about.tryHosted' => 'DDAgent Hosted を試す',
			'settings.about.learnMore' => '詳細を見る',
			'settings.about.proFeatures' => 'DDAgent Pro の機能',
			'settings.about.pro.syncSettings' => '設定を同期',
			'settings.about.pro.teamManagement' => 'チーム管理',
			'settings.about.pro.syncSettingsDescription' => '設定、MCP 構成、テーマをすべての環境で同期します。',
			'settings.about.pro.teamManagementDescription' => '複数ユーザー、ロールベースのアクセス制御、チームでの共有プロジェクト。',
			'settings.about.versionInfo' => 'バージョン情報',
			'settings.about.client' => 'アプリ',
			'settings.about.server' => 'サーバー',
			'settings.about.platformMobile' => 'モバイル',
			'settings.about.platformDesktop' => 'デスクトップ',
			'settings.about.platformWeb' => 'Web',
			'settings.about.unknown' => '不明',
			'settings.about.copyright' => '© 2026 DDAgent — All rights reserved',
			'settings.about.tagline' => 'オープンソースの AI コーディングアシスタント インターフェース',
			'settings.about.docs' => 'ドキュメント',
			'settings.about.hostedDescription' => 'チームでのコラボレーション、共有 MCP 設定、環境間の設定同期、マネージドインフラストラクチャ。',
			'settings.shortcuts.description' => 'DDAgent のすべてのキーボードショートカット (プラットフォーム別)。',
			'settings.shortcuts.action' => '操作',
			'settings.shortcuts.winLinux' => 'Windows / Linux',
			'settings.shortcuts.mac' => 'macOS',
			'settings.shortcuts.navigation' => 'ナビゲーション',
			'settings.shortcuts.navWorkspace' => 'ワークスペースへ移動',
			'settings.shortcuts.navTasks' => 'タスク / Git へ移動',
			'settings.shortcuts.navGit' => 'Git へ移動',
			'settings.shortcuts.navFocus' => 'フォーカスモードの切り替え (サイドバー)',
			'settings.shortcuts.navSwitcher' => 'セッションのクイック切り替え',
			'settings.shortcuts.navPalette' => 'コマンドパレット',
			'settings.shortcuts.navSettings' => '設定を開く',
			'settings.shortcuts.navClose' => 'ダイアログを閉じる / 分割ペインを元に戻す',
			'settings.shortcuts.composer' => '入力欄',
			'settings.shortcuts.compSend' => 'メッセージを送信',
			'settings.shortcuts.compNewline' => '改行',
			'settings.shortcuts.compNav' => '候補を移動',
			'settings.shortcuts.compAccept' => '候補を確定',
			'settings.shortcuts.compCloseSuggest' => '候補を閉じる',
			'settings.shortcuts.transcript' => 'トランスクリプト',
			'settings.shortcuts.trCopy' => '選択したテキストをコピー',
			'settings.shortcuts.trClose' => '検索 / レビューパネルを閉じる',
			'settings.shortcuts.terminal' => 'ターミナル',
			'settings.shortcuts.termCopy' => '選択範囲をコピー',
			'settings.shortcuts.termInterrupt' => 'プロセスを中断 (選択なし時)',
			'settings.shortcuts.termPaste' => '貼り付け',
			'settings.shortcuts.termSelectAll' => 'すべて選択',
			'settings.shortcuts.editor' => 'エディター',
			'settings.shortcuts.edSave' => 'ファイルを保存',
			'settings.shortcuts.edSaveAll' => 'すべてのファイルを保存',
			'settings.shortcuts.edClose' => 'タブを閉じる',
			'settings.shortcuts.edNextTab' => '次のタブ',
			'settings.shortcuts.edPrevTab' => '前のタブ',
			'settings.shortcuts.edIndent' => 'インデント / インデント解除',
			'settings.shortcuts.palette' => 'コマンドパレット',
			'settings.shortcuts.palNav' => '項目を移動',
			'settings.shortcuts.palRun' => '実行 / 開く',
			'settings.shortcuts.palBack' => '戻る (検索が空の時)',
			'settings.shortcuts.palClose' => '閉じる',
			'sidebar.projects.title' => 'プロジェクト',
			'sidebar.projects.newProject' => '新規プロジェクト',
			'sidebar.projects.deleteProject' => 'プロジェクトを除去',
			'sidebar.projects.renameProject' => 'プロジェクト名を変更',
			'sidebar.projects.noProjects' => 'プロジェクトが見つかりません',
			'sidebar.projects.loadingProjects' => 'プロジェクトを読み込んでいます...',
			'sidebar.projects.searchPlaceholder' => 'プロジェクトを検索...',
			'sidebar.projects.projectNamePlaceholder' => 'プロジェクト名',
			'sidebar.projects.starred' => 'お気に入り',
			'sidebar.projects.all' => 'すべて',
			'sidebar.projects.untitledSession' => '無題のセッション',
			'sidebar.projects.newSession' => '新しいセッション',
			'sidebar.projects.codexSession' => 'Codexセッション',
			'sidebar.projects.fetchingProjects' => 'Claudeのプロジェクトとセッションを取得しています',
			'sidebar.projects.projects' => 'プロジェクト',
			'sidebar.projects.noMatchingProjects' => '一致するプロジェクトがありません',
			'sidebar.projects.tryDifferentSearch' => '検索語を変えてお試しください',
			'sidebar.projects.runClaudeCli' => 'プロジェクトディレクトリでClaude CLIを実行して始めましょう',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'AIコーディングアシスタント',
			'sidebar.panel.open' => 'パネル',
			'sidebar.panel.newChat' => '新しいチャット',
			'sidebar.panel.navigation' => 'ナビゲーション',
			'sidebar.panel.sessions' => 'セッション',
			'sidebar.sessions.title' => 'セッション',
			'sidebar.sessions.newSession' => '新しいセッション',
			'sidebar.sessions.deleteSession' => 'セッションを削除',
			'sidebar.sessions.renameSession' => 'セッション名を変更',
			'sidebar.sessions.noSessions' => 'セッションはまだありません',
			'sidebar.sessions.loadingSessions' => 'セッションを読み込んでいます...',
			'sidebar.sessions.unnamed' => '名称未設定',
			'sidebar.sessions.loading' => '読み込み中...',
			'sidebar.sessions.showMore' => 'さらにセッションを表示',
			'sidebar.sessions.selectMode' => '選択',
			'sidebar.sessions.selectAll' => 'すべて選択',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => 'アーカイブ (${count})',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => '削除 (${count})',
			'sidebar.sessions.cancelSelection' => '選択をキャンセル',
			'sidebar.sessions.toggleSelection' => 'セッション選択を切り替え',
			'sidebar.sessions.selectionToolbar' => 'セッション選択アクション',
			'sidebar.sessions.options' => 'セッションオプション',
			'sidebar.sessions.pinSession' => 'セッションをピン留め',
			'sidebar.sessions.unpinSession' => 'セッションのピン留めを解除',
			'sidebar.sessions.pinned' => 'ピン留めされたセッション',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 件選択', other: '${count} 件選択', ), 
			'sidebar.tooltips.viewEnvironments' => '環境を表示',
			'sidebar.tooltips.hideSidebar' => 'サイドバーを隠す',
			'sidebar.tooltips.createProject' => '新しいプロジェクトを作成',
			'sidebar.tooltips.refresh' => 'プロジェクトとセッションを更新 (Ctrl+R)',
			'sidebar.tooltips.renameProject' => 'プロジェクト名を変更 (F2)',
			'sidebar.tooltips.deleteProject' => 'サイドバーからプロジェクトを除去 (Delete)',
			'sidebar.tooltips.addToFavorites' => 'お気に入りに追加',
			'sidebar.tooltips.removeFromFavorites' => 'お気に入りから削除',
			'sidebar.tooltips.editSessionName' => 'セッション名を手動で編集',
			'sidebar.tooltips.deleteSession' => 'このセッションを完全に削除',
			'sidebar.tooltips.activeSessionIndicator' => '最近アクティブなセッション（過去10分以内）',
			'sidebar.tooltips.save' => '保存',
			'sidebar.tooltips.cancel' => 'キャンセル',
			'sidebar.tooltips.clearSearch' => '検索をクリア',
			'sidebar.tooltips.openCommandPalette' => 'コマンドパレットを開く',
			'sidebar.tooltips.attentionRequiredIndicator' => 'セッションが対応を必要としています',
			'sidebar.tooltips.openSessions' => 'セッションを参照',
			'sidebar.navigation.chat' => 'チャット',
			'sidebar.navigation.files' => 'ファイル',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => 'ターミナル',
			'sidebar.navigation.tasks' => 'タスク',
			'sidebar.actions.refresh' => '更新',
			'sidebar.actions.settings' => '設定',
			'sidebar.actions.collapseAll' => 'すべて折りたたむ',
			'sidebar.actions.expandAll' => 'すべて展開',
			'sidebar.actions.cancel' => 'キャンセル',
			'sidebar.actions.save' => '保存',
			'sidebar.actions.delete' => '削除',
			'sidebar.actions.rename' => '名前の変更',
			'sidebar.actions.joinCommunity' => 'コミュニティに参加',
			'sidebar.actions.reportIssue' => '問題を報告',
			'sidebar.actions.starOnGithub' => 'GitHubでスター',
			'sidebar.actions.buyMeACoffee' => 'Buy Me a Coffee',
			'sidebar.workspace.title' => 'セッションのワークスペースを変更',
			'sidebar.workspace.description' => 'エージェントはこのディレクトリで次のターンを実行します。既存のセッション履歴は保持されます。',
			'sidebar.workspace.pathLabel' => 'ワークスペースのパス',
			'sidebar.workspace.pathRequired' => 'ワークスペースのパスは必須です。',
			'sidebar.workspace.submit' => 'ワークスペースを変更',
			'sidebar.workspace.saving' => '変更中…',
			'sidebar.workspace.changeAction' => 'ワークスペースを変更',
			'sidebar.branding.openSource' => 'オープンソース',
			'sidebar.status.active' => 'アクティブ',
			'sidebar.status.inactive' => '非アクティブ',
			'sidebar.status.thinking' => '思考中...',
			'sidebar.status.error' => 'エラー',
			'sidebar.status.aborted' => '中断',
			'sidebar.status.unknown' => '不明',
			'sidebar.time.justNow' => 'たった今',
			'sidebar.time.oneMinuteAgo' => '1分前',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count}分前',
			'sidebar.time.oneHourAgo' => '1時間前',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count}時間前',
			'sidebar.time.oneDayAgo' => '1日前',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count}日前',
			'sidebar.messages.deleteConfirm' => '本当に削除しますか？',
			'sidebar.messages.renameSuccess' => '名前を変更しました',
			'sidebar.messages.deleteSuccess' => '削除しました',
			'sidebar.messages.errorOccurred' => 'エラーが発生しました',
			'sidebar.messages.deleteSessionConfirm' => 'このセッションを削除してもよろしいですか？この操作は取り消せません。',
			'sidebar.messages.deleteProjectConfirm' => 'サイドバーからこのプロジェクトを除去しますか？プロジェクトファイル、メモリ、セッションデータは削除されません。',
			'sidebar.messages.enterProjectPath' => 'プロジェクトのパスを入力してください',
			'sidebar.messages.deleteSessionFailed' => 'セッションの削除に失敗しました。もう一度お試しください。',
			'sidebar.messages.deleteSessionError' => 'セッションの削除でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.renameSessionFailed' => 'セッション名の変更に失敗しました。もう一度お試しください。',
			'sidebar.messages.renameSessionError' => 'セッション名の変更でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.changeWorkspaceFailed' => 'ワークスペースを変更できませんでした。もう一度お試しください。',
			'sidebar.messages.changeWorkspaceError' => 'ワークスペースの変更でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.deleteProjectFailed' => 'プロジェクトの除去に失敗しました。もう一度お試しください。',
			'sidebar.messages.deleteProjectError' => 'プロジェクトの除去でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.createProjectFailed' => 'プロジェクトの作成に失敗しました。もう一度お試しください。',
			'sidebar.messages.createProjectError' => 'プロジェクトの作成でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.updateProjectError' => 'プロジェクトの更新でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.refreshError' => '更新に失敗しました。もう一度お試しください。',
			'sidebar.messages.restoreProjectFailed' => 'プロジェクトの復元に失敗しました。もう一度お試しください。',
			'sidebar.messages.restoreProjectError' => 'プロジェクトの復元でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.restoreSessionFailed' => 'セッションの復元に失敗しました。もう一度お試しください。',
			'sidebar.messages.restoreSessionError' => 'セッションの復元でエラーが発生しました。もう一度お試しください。',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 件のセッションを削除できませんでした。もう一度お試しください。', other: '${count} 件のセッションを削除できませんでした。もう一度お試しください。', ), 
			'sidebar.version.updateAvailable' => 'アップデートあり',
			'sidebar.version.restartRequired' => '更新が適用されていません。サーバーを再起動してください',
			'sidebar.version.updateNow' => '今すぐ更新',
			'sidebar.version.updateConfirm' => ({required Object version}) => 'DDAgent を v${version} に更新しますか？最新コードの取得とビルド後、サーバーが再起動します — 実行中のセッションは中断されます。',
			'sidebar.version.updating' => '更新中… 数分かかることがあります',
			'sidebar.version.restarting' => '更新をインストールしました — 再起動中…',
			'sidebar.version.updateFailed' => '更新に失敗しました',
			'sidebar.version.releaseNotes' => 'リリースノート',
			'sidebar.search.modeProjects' => 'プロジェクト',
			'sidebar.search.modeConversations' => '会話',
			'sidebar.search.conversationsPlaceholder' => '会話内を検索...',
			'sidebar.search.searching' => '検索中...',
			'sidebar.search.sessionTitles' => 'セッション',
			'sidebar.search.conversationContents' => '会話の内容',
			'sidebar.search.noResults' => '結果が見つかりません',
			'sidebar.search.tryDifferentQuery' => '別の検索語をお試しください',
			'sidebar.search.modeRunning' => '実行中',
			'sidebar.search.archiveOnly' => 'アーカイブ',
			'sidebar.search.runningTooltip' => '実行中のセッション',
			'sidebar.search.archiveOnlyTooltip' => 'アーカイブのみ',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} 件アクティブ',
			'sidebar.search.viewMenu' => '表示',
			'sidebar.search.backToProjects' => 'プロジェクトに戻る',
			'sidebar.search.archivedPlaceholder' => 'アーカイブ済みセッションを検索...',
			'sidebar.search.runningPlaceholder' => '実行中セッションを検索...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 件一致', other: '${count} 件一致', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 件のプロジェクトをスキャン', other: '${count} 件のプロジェクトをスキャン', ), 
			'sidebar.recent.title' => '最近の会話',
			'sidebar.recent.emptyTitle' => 'まだ会話がありません',
			'sidebar.recent.emptyDescription' => '最近更新された会話がここに表示されます。',
			'sidebar.recent.loadFailed' => '最近の会話を読み込めませんでした',
			'sidebar.recent.loadMore' => '過去の会話を読み込む',
			'sidebar.recent.loadingMore' => '読み込み中...',
			'sidebar.deleteConfirmation.deleteProject' => 'プロジェクトを除去',
			'sidebar.deleteConfirmation.deleteSession' => 'セッションを削除',
			'sidebar.deleteConfirmation.confirmDelete' => 'このプロジェクトをどうしますか：',
			'sidebar.deleteConfirmation.removeFromSidebar' => 'サイドバーからのみ除去',
			'sidebar.deleteConfirmation.deleteAllData' => 'すべてのデータを完全に削除',
			'sidebar.deleteConfirmation.allConversationsDeleted' => 'プロジェクトはサイドバーから除去されます。ファイル、メモリ、セッションデータは保持されます。',
			'sidebar.deleteConfirmation.cannotUndo' => '後からプロジェクトを再追加できます。',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => 'アーカイブは選択したセッションをアクティブリストから隠し、履歴を保持します。',
			'sidebar.deleteConfirmation.archiveSession' => 'セッションをアーカイブ',
			'sidebar.deleteConfirmation.archiveSessionNotice' => 'アーカイブは履歴を保持したままセッションをアクティブリストから外します。',
			'sidebar.deleteConfirmation.archivedSessionNotice' => 'このセッションは既にアーカイブされています。非表示のままにするか、完全に削除できます。',
			'sidebar.deleteConfirmation.deleteSessionNotice' => 'セッションとそのトランスクリプトを完全に削除します。この操作は元に戻せません。',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => '完全に削除',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: 'このプロジェクトには ${count} 件の会話があります。', other: 'このプロジェクトには ${count} 件の会話があります。', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '選択したセッションを管理', other: '選択した ${count} 件のセッションを管理', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: 'セッションをアーカイブ', other: '${count} 件のセッションをアーカイブ', ), 
			'sidebar.zones.activeNow' => '現在アクティブ',
			'sidebar.zones.recent' => '最近使用した項目',
			'sidebar.zones.today' => '今日',
			'sidebar.zones.yesterday' => '昨日',
			'sidebar.zones.thisWeek' => '今週',
			'sidebar.zones.showMore' => ({required Object count}) => 'さらに${count}件表示',
			'sidebar.zones.showLess' => '表示を減らす',
			'sidebar.tabs.board' => 'エージェントボード',
			'sidebar.tabs.files' => 'ファイル',
			'sidebar.tabs.git' => 'ソース管理',
			'sidebar.tabs.tasks' => 'タスク',
			'sidebar.tabs.usage' => 'クォータと使用量',
			'tasks.notConfigured.title' => 'TaskMaster AIが設定されていません',
			'tasks.notConfigured.description' => 'TaskMasterは、AIを活用した支援により、複雑なプロジェクトを管理しやすいタスクに分解するのに役立ちます',
			'tasks.notConfigured.whatIsTitle' => '🎯 TaskMasterとは？',
			'tasks.notConfigured.features.aiPowered' => 'AIを活用したタスク管理：複雑なプロジェクトを管理しやすいサブタスクに分解',
			'tasks.notConfigured.features.prdTemplates' => 'PRDテンプレート：Product Requirements Documentからタスクを生成',
			'tasks.notConfigured.features.dependencyTracking' => '依存関係の追跡：タスクの関係性と実行順序を理解',
			'tasks.notConfigured.features.progressVisualization' => '進捗の可視化：カンバンボードと詳細なタスク分析',
			'tasks.notConfigured.features.cliIntegration' => 'CLI統合：高度なワークフローのためにtaskmasterコマンドを使用',
			'tasks.notConfigured.initializeButton' => 'TaskMaster AIを初期化',
			'tasks.notConfigured.writePrdFirst' => '先にPRDを作成してください',
			'tasks.gettingStarted.title' => 'TaskMasterを始める',
			'tasks.gettingStarted.subtitle' => 'TaskMasterが初期化されました！次にすることは:',
			'tasks.gettingStarted.steps.createPRD.title' => 'Product Requirements Document (PRD) を作成',
			'tasks.gettingStarted.steps.createPRD.description' => 'プロジェクトのアイデアについて話し合い、構築したい内容を説明するPRDを作成します。',
			'tasks.gettingStarted.steps.createPRD.addButton' => 'PRDを追加',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => '既存のPRD:',
			'tasks.gettingStarted.steps.generateTasks.title' => 'PRDからタスクを生成',
			'tasks.gettingStarted.steps.generateTasks.description' => 'PRDができたら、AIアシスタントに解析を依頼してください。TaskMasterが自動的に実装の詳細を含む管理しやすいタスクに分解します。',
			'tasks.gettingStarted.steps.analyzeTasks.title' => 'タスクの分析と展開',
			'tasks.gettingStarted.steps.analyzeTasks.description' => 'AIアシスタントにタスクの複雑さを分析してもらい、より簡単に実装できる詳細なサブタスクに展開します。',
			'tasks.gettingStarted.steps.startBuilding.title' => '開発を始める',
			'tasks.gettingStarted.steps.startBuilding.description' => 'AIアシスタントにタスクの作業を開始してもらい、ステータスを更新し、プロジェクトの進行に応じて新しいタスクを追加します。',
			'tasks.gettingStarted.tip' => '💡 ヒント：TaskMasterのAIを活用したタスク生成を最大限に活用するには、PRDから始めましょう',
			'tasks.setupModal.title' => 'TaskMasterのセットアップ',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => '${projectName}のインタラクティブCLI',
			'tasks.setupModal.willStart' => 'TaskMasterの初期化が自動的に開始されます',
			'tasks.setupModal.completed' => 'TaskMasterのセットアップが完了しました！このウィンドウを閉じることができます。',
			'tasks.setupModal.closeButton' => '閉じる',
			'tasks.setupModal.closeContinueButton' => '閉じて続ける',
			'tasks.setupModal.closeTitle' => '閉じる',
			'tasks.setupModal.description' => 'このプロジェクトに .taskmaster フォルダを作成します。外部ツールやAPIキーは不要 — タスクはローカルに保存されます。',
			'tasks.setupModal.initializeButton' => '初期化',
			'tasks.setupModal.initializing' => '初期化中...',
			'tasks.helpGuide.title' => 'TaskMasterを始める',
			'tasks.helpGuide.subtitle' => '生産的なタスク管理のガイド',
			'tasks.helpGuide.examples.parsePRD' => '💬 例：\n「Claude Task Masterで新しいプロジェクトを初期化しました。.taskmaster/docs/prd.txtにPRDがあります。解析して初期タスクを設定するのを手伝ってもらえますか？」',
			'tasks.helpGuide.examples.expandTask' => '💬 例：\n「タスク5は複雑そうです。サブタスクに分解してもらえますか？」',
			'tasks.helpGuide.examples.addTask' => '💬 例：\n「Cloudinaryを使用してユーザープロフィール画像のアップロードを実装する新しいタスクを追加してください。最適なアプローチを調査してください。」',
			'tasks.helpGuide.moreExamples' => 'さらなる例と使用パターンを見る →',
			'tasks.helpGuide.proTips.title' => '💡 プロのヒント',
			'tasks.helpGuide.proTips.search' => '検索バーを使用して特定のタスクをすばやく見つける',
			'tasks.helpGuide.proTips.views' => 'ビュー切替を使用してカンバン、リスト、グリッドビューを切り替える',
			'tasks.helpGuide.proTips.filters' => 'フィルターを使用して特定のタスクステータスや優先度に焦点を当てる',
			'tasks.helpGuide.proTips.details' => '任意のタスクをクリックして詳細情報を表示し、サブタスクを管理する',
			'tasks.helpGuide.learnMore.title' => '📚 詳細を見る',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AIは開発者向けに構築された高度なタスク管理システムです。ドキュメント、例を入手し、プロジェクトに貢献できます。',
			'tasks.helpGuide.learnMore.githubButton' => 'GitHubで見る',
			'tasks.helpGuide.closeTitle' => '閉じる',
			'tasks.search.placeholder' => 'タスクを検索...',
			'tasks.filters.button' => 'フィルター',
			'tasks.filters.status' => 'ステータス',
			'tasks.filters.priority' => '優先度',
			'tasks.filters.sortBy' => '並び替え',
			'tasks.filters.allStatuses' => 'すべてのステータス',
			'tasks.filters.allPriorities' => 'すべての優先度',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => '${filtered}件のタスクを表示中（全${total}件）',
			'tasks.filters.clearFilters' => 'フィルターをクリア',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => 'ステータス',
			'tasks.sort.priority' => '優先度',
			'tasks.sort.idAsc' => 'ID（昇順）',
			'tasks.sort.idDesc' => 'ID（降順）',
			'tasks.sort.titleAsc' => 'タイトル（A-Z）',
			'tasks.sort.titleDesc' => 'タイトル（Z-A）',
			'tasks.sort.statusAsc' => 'ステータス（保留中が先）',
			'tasks.sort.statusDesc' => 'ステータス（完了が先）',
			'tasks.sort.priorityAsc' => '優先度（高が先）',
			'tasks.sort.priorityDesc' => '優先度（低が先）',
			'tasks.views.kanban' => 'カンバンビュー',
			'tasks.views.list' => 'リストビュー',
			'tasks.views.grid' => 'グリッドビュー',
			'tasks.kanban.pending' => '📋 やること',
			'tasks.kanban.inProgress' => '🚀 進行中',
			'tasks.kanban.review' => '👀 レビュー',
			'tasks.kanban.done' => '✅ 完了',
			'tasks.kanban.blocked' => '🚫 ブロック中',
			'tasks.kanban.deferred' => '⏳ 延期',
			'tasks.kanban.cancelled' => '❌ キャンセル',
			'tasks.kanban.noTasksYet' => 'まだタスクはありません',
			'tasks.kanban.tasksWillAppear' => 'タスクはここに表示されます',
			'tasks.kanban.moveTasksHere' => '開始したらタスクをここに移動',
			'tasks.kanban.completedTasksHere' => '完了したタスクはここに表示されます',
			'tasks.kanban.statusTasksHere' => 'このステータスのタスクはここに表示されます',
			'tasks.buttons.help' => 'TaskMaster入門ガイド',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => 'PRDを追加',
			'tasks.buttons.addTask' => 'タスクを追加',
			'tasks.buttons.createNewPRD' => '新しいPRDを作成',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count}件のPRDがあります',
			'tasks.prd.modified' => ({required Object date}) => '更新日: ${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.newFile' => '新しいファイル',
			'tasks.prd.template' => 'テンプレート',
			'tasks.prd.parse' => 'PRDを解析',
			'tasks.prd.fileExistsTitle' => 'ファイルは既に存在します',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => '「${name}」という名前のPRDが既に存在します。上書きしますか？',
			'tasks.prd.fileNameHint' => 'ファイル名（例: prd.txt）',
			'tasks.prd.saved' => 'PRDを保存しました',
			'tasks.prd.tasksGenerated' => 'PRDからタスクを生成しました',
			'tasks.statuses.pending' => '保留中',
			'tasks.statuses.inProgress' => '進行中',
			'tasks.statuses.done' => '完了',
			'tasks.statuses.blocked' => 'ブロック中',
			'tasks.statuses.deferred' => '延期',
			'tasks.statuses.cancelled' => 'キャンセル',
			'tasks.statuses.review' => 'レビュー',
			'tasks.priorities.high' => '高',
			'tasks.priorities.medium' => '中',
			'tasks.priorities.low' => '低',
			'tasks.noMatchingTasks.title' => 'フィルターに一致するタスクがありません',
			'tasks.noMatchingTasks.description' => '検索条件またはフィルター基準を調整してみてください。',
			'tasks.board.title' => 'エージェントボード',
			'tasks.board.subtitle' => 'カードを「開始可能」に移動するとエージェントが引き受けます。カードをクリックするとセッションが開きます。',
			'tasks.board.newCard' => '新しいカード',
			'tasks.board.addCard' => 'カードを追加',
			'tasks.board.refresh' => '更新',
			'tasks.board.empty.title' => 'まだカードがありません',
			'tasks.board.empty.description' => 'カードを追加してタスクを説明し、「開始可能」にドラッグするとエージェントが作業を開始します。',
			'tasks.board.columns.backlog' => 'バックログ',
			'tasks.board.columns.ready' => '開始可能',
			'tasks.board.columns.working' => '作業中',
			'tasks.board.columns.needsDecision' => 'あなたの判断が必要',
			'tasks.board.columns.done' => '完了',
			'tasks.board.columns.archived' => 'アーカイブ済み',
			'tasks.board.card.running' => '実行中',
			'tasks.board.card.abort' => '中止',
			'tasks.board.card.delete' => '削除',
			'tasks.board.card.openSession' => 'セッションを開く',
			'tasks.board.card.pullRequest' => 'プルリクエスト',
			'tasks.board.card.edit' => '編集',
			'tasks.board.card.moveTo' => '移動先',
			'tasks.board.dialog.createTitle' => '新しいカード',
			'tasks.board.dialog.editTitle' => 'カードを編集',
			'tasks.board.dialog.titleLabel' => 'タイトル',
			'tasks.board.dialog.titlePlaceholder' => 'エージェントは何をすべきですか？',
			'tasks.board.dialog.descriptionLabel' => '説明',
			'tasks.board.dialog.descriptionPlaceholder' => 'コンテキスト、受け入れ条件、リンクを追加...',
			'tasks.board.dialog.cancel' => 'キャンセル',
			'tasks.board.dialog.save' => '保存',
			'tasks.board.noProject' => 'まずプロジェクトを追加し、そのプロジェクトのカードを作成してください。',
			'tasks.board.projectLabel' => 'プロジェクト',
			'tasks.board.backToChat' => 'チャットに戻る',
			'tasks.board.agent.provider' => 'エージェント',
			'tasks.board.agent.anyProvider' => '任意のエージェント',
			'tasks.board.agent.model' => 'モデル',
			'tasks.board.agent.defaultModel' => 'デフォルトモデル',
			'tasks.board.agent.effort' => '推論',
			'tasks.board.agent.defaultEffort' => 'デフォルト',
			'tasks.board.agent.searchModel' => 'モデルを検索…',
			'tasks.board.agent.noModels' => '一致するモデルなし',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '「${cardTitle}」は完全に削除されます。',
			'tasks.board.deleteConfirm.title' => 'カードを削除しますか？',
			'tasks.board.project' => 'プロジェクト',
			'tasks.board.assignee.label' => '担当者',
			'tasks.board.assignee.all' => 'すべての担当者',
			'tasks.board.assignee.unassigned' => '未割り当て',
			'tasks.board.presence.online' => ({required Object count}) => '${count} 人がオンライン',
			'tasks.board.activity.title' => 'アクティビティ',
			'tasks.board.activity.empty' => 'アクティビティはまだありません',
			'tasks.board.comments.label' => 'コメント',
			'tasks.board.comments.placeholder' => 'コメントを入力…',
			'tasks.board.comments.send' => '送信',
			'tasks.board.comments.unknownAuthor' => '不明なユーザー',
			'tasks.card.dependsOnList' => ({required Object tasks}) => '依存: ${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => 'タスク ${id}',
			'tasks.card.highPriority' => '優先度：高',
			'tasks.card.lowPriority' => '優先度：低',
			'tasks.card.mediumPriority' => '優先度：中',
			'tasks.card.noPriority' => '優先度未設定',
			'tasks.card.parentTask' => ({required Object id}) => 'タスク ${id}',
			'tasks.card.progressLabel' => '進捗:',
			'tasks.card.progressTooltip' => ({required Object total, required Object completed}) => '${total} 件のサブタスク中 ${completed} 件完了',
			'tasks.card.runTask' => 'タスクを実行',
			'tasks.card.runTaskAria' => ({required Object id}) => 'タスク ${id} を実行',
			'tasks.card.statusTooltip' => ({required Object status}) => 'ステータス: ${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => 'タスクID: ${id}',
			'tasks.card.taskInProgress' => 'タスク実行中',
			'tasks.createTask.cancel' => 'キャンセル',
			'tasks.createTask.descriptionLabel' => '説明',
			'tasks.createTask.descriptionPlaceholder' => '任意の詳細',
			'tasks.createTask.error' => 'タスクの追加に失敗しました',
			'tasks.createTask.priorityLabel' => '優先度',
			'tasks.createTask.submit' => 'タスクを追加',
			'tasks.createTask.submitting' => '追加中...',
			'tasks.createTask.title' => 'タスクを追加',
			'tasks.createTask.titleLabel' => 'タイトル',
			'tasks.createTask.titlePlaceholder' => '何をすべきですか？',
			'tasks.list.completedReopen' => '完了（クリックで再開）',
			'tasks.list.inProgressComplete' => '進行中（クリックで完了）',
			'tasks.list.markCompleted' => '完了としてマーク',
			'tasks.list.toggleStatusAria' => ({required Object id}) => 'タスク ${id} のステータスを切り替え',
			'tasks.list.markDone' => '完了にする',
			'tasks.list.reopen' => '再開',
			'tasks.nextTask.allComplete' => 'すべてのタスクが完了',
			'tasks.nextTask.feature1' => '- 依存関係とサブタスクを備えたAIタスク管理。',
			'tasks.nextTask.feature2' => '- PRD駆動のタスク生成でプロジェクトを迅速に開始。',
			'tasks.nextTask.feature3' => '- 日常作業向けのカンバンとリストビュー。',
			'tasks.nextTask.hideDetails' => '詳細を隠す',
			'tasks.nextTask.initialize' => '初期化',
			'tasks.nextTask.noPending' => '保留中のタスクはありません',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI が設定されていません',
			'tasks.nextTask.review' => '確認',
			'tasks.nextTask.startTask' => 'タスクを開始',
			'tasks.nextTask.taskId' => ({required Object id}) => 'タスク ${id}',
			'tasks.nextTask.viewAll' => 'すべてのタスクを表示',
			'tasks.nextTask.viewDetails' => 'タスクの詳細を表示',
			'tasks.nextTask.whatIs' => 'TaskMaster とは？',
			'tasks.taskDetail.cancelEdit' => '編集をキャンセル',
			'tasks.taskDetail.close' => '閉じる',
			'tasks.taskDetail.copyTaskId' => 'タスクIDをコピー',
			'tasks.taskDetail.delete' => 'タスクを削除',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '「${title}」は完全に削除されます。',
			'tasks.taskDetail.deleteConfirmTitle' => 'タスクを削除しますか？',
			'tasks.taskDetail.deleteFailed' => 'タスクの削除に失敗しました',
			'tasks.taskDetail.dependencies' => '依存関係',
			'tasks.taskDetail.dependenciesPlaceholder' => '例: 1, 2, 3',
			'tasks.taskDetail.description' => '説明',
			'tasks.taskDetail.edit' => 'タスクを編集',
			'tasks.taskDetail.implDetails' => '実装の詳細',
			'tasks.taskDetail.noDependencies' => '依存関係なし',
			'tasks.taskDetail.noDescription' => '説明がありません',
			'tasks.taskDetail.priority' => '優先度',
			'tasks.taskDetail.priorityNotSet' => '未設定',
			'tasks.taskDetail.save' => '保存',
			_ => null,
		} ?? switch (path) {
			'tasks.taskDetail.status' => 'ステータス',
			'tasks.taskDetail.statusFailed' => 'タスクステータスの更新に失敗しました',
			'tasks.taskDetail.taskId' => ({required Object id}) => 'タスク ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => 'タスク ${id}: ${title}',
			'tasks.taskDetail.testStrategy' => 'テスト戦略',
			'tasks.taskDetail.titleRequired' => 'タイトルは必須です',
			'tasks.taskDetail.updateFailed' => 'タスクの更新に失敗しました',
			'tasks.taskDetail.notFound' => 'タスクが見つかりません',
			'tasks.taskDetail.subtasks' => 'サブタスク',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => 'タスク #${id} は削除されます。元に戻せません。',
			'tasks.taskDetail.idCopied' => 'タスクIDをコピーしました',
			'tasks.toasts.statusInProgress' => ({required Object id}) => 'タスク ${id} を進行中に設定しました',
			'tasks.taskmaster.noProjectHint' => 'まずプロジェクトを追加してから、タスクを作成してください。',
			'tasks.taskmaster.sort.statusAz' => 'ステータス (A-Z)',
			'tasks.taskmaster.sort.statusZa' => 'ステータス (Z-A)',
			'tasks.taskmaster.installedVersion' => ({required Object version}) => 'インストール済み: ${version}',
			'tasks.taskmaster.initFailed' => 'TaskMaster を初期化できませんでした',
			'tasks.taskmaster.prd.fileNameRequired' => 'PRD のファイル名を入力してください。',
			'tasks.taskmaster.prd.contentRequired' => '保存する前に内容を追加してください。',
			'tasks.taskmaster.prd.overwrite' => '上書き',
			'tasks.taskmaster.prd.contentHint' => '# 製品要求仕様書…',
			'tasks.taskmaster.detail.dependenciesLabel' => '依存関係 (カンマ区切りの ID)',
			'tasks.taskmaster.untitledTask' => '無題のタスク',
			'knowledge.title' => 'ナレッジ',
			'knowledge.tabs.dashboard' => 'ダッシュボード',
			'knowledge.tabs.memories' => 'メモリ',
			'knowledge.tabs.rules' => 'ルール',
			'knowledge.tabs.skills' => 'スキル',
			'knowledge.tabs.personal' => '個人情報',
			'knowledge.tabs.graph' => 'グラフ',
			'knowledge.common.add' => '追加',
			'knowledge.common.save' => '保存',
			'knowledge.common.cancel' => 'キャンセル',
			'knowledge.common.delete' => '削除',
			'knowledge.common.edit' => '編集',
			'knowledge.common.close' => '閉じる',
			'knowledge.common.restore' => '復元',
			'knowledge.common.refresh' => '更新',
			'knowledge.common.allProjects' => 'すべてのプロジェクト',
			'knowledge.common.global' => 'グローバル',
			'knowledge.actions.scan' => 'プロジェクトファイルをスキャン',
			'knowledge.actions.export' => 'JSONをエクスポート',
			'knowledge.actions.import' => 'JSONをインポート',
			'knowledge.actions.scanComplete' => 'スキャンが完了しました',
			'knowledge.actions.importComplete' => 'インポートが完了しました',
			'knowledge.actions.importFailed' => 'インポートに失敗しました',
			'knowledge.dialog.newEntity' => '新規エントリ',
			'knowledge.dialog.editEntity' => 'エントリを編集',
			'knowledge.dialog.deleteTitle' => '削除',
			'knowledge.dialog.deleteMessage' => 'このエントリを削除しますか？元に戻せません（履歴は保持されます）。',
			'knowledge.dialog.pickIcon' => 'アイコンを選択',
			'knowledge.dialog.removeIcon' => 'アイコンを削除',
			'knowledge.dialog.iconTooLarge' => 'アイコンが大きすぎます（最大40KB）。',
			'knowledge.dialog.importTitle' => 'ナレッジをインポート',
			'knowledge.dialog.importHint' => 'エクスポートしたJSONを貼り付け',
			'knowledge.dialog.exportTitle' => 'ナレッジをエクスポート',
			'knowledge.dialog.import' => 'インポート',
			'knowledge.fields.key' => 'キー',
			'knowledge.fields.title' => 'タイトル',
			'knowledge.fields.name' => '名前',
			'knowledge.fields.description' => '説明',
			'knowledge.fields.category' => 'カテゴリ',
			'knowledge.fields.content' => '内容',
			'knowledge.fields.priority' => '優先度',
			'knowledge.fields.tags' => 'タグ',
			'knowledge.fields.enabled' => '有効',
			'knowledge.fields.projectScope' => 'プロジェクト範囲',
			'knowledge.fields.tagsHint' => 'カンマ区切り',
			'knowledge.dashboard.memories' => 'メモリ',
			'knowledge.dashboard.rules' => 'ルール',
			'knowledge.dashboard.skills' => 'スキル',
			'knowledge.dashboard.personal' => '個人情報',
			'knowledge.dashboard.connections' => '接続',
			'knowledge.dashboard.recent' => '最近のメモリ',
			'knowledge.dashboard.noMemories' => 'メモリがありません。メモリタブで追加してください。',
			'knowledge.empty.memories' => 'メモリがありません。',
			'knowledge.empty.rules' => 'ルールがありません。',
			'knowledge.empty.skills' => 'スキルがありません。',
			'knowledge.empty.personal' => '個人情報がありません。',
			'knowledge.empty.graph' => 'グラフに表示する項目がありません。',
			'knowledge.history.title' => '履歴',
			'knowledge.history.none' => '履歴がありません。',
			'knowledge.history.untitled' => '（無題）',
			'knowledge.priorities.critical' => 'クリティカル',
			'knowledge.priorities.high' => '高',
			'knowledge.priorities.normal' => '通常',
			'knowledge.priorities.low' => '低',
			'knowledge.search.title' => 'ナレッジを検索',
			'knowledge.search.hint' => 'メモリ、ルール、スキルを検索…',
			'knowledge.search.noResults' => '結果がありません。',
			'knowledge.links.title' => 'エンティティをリンク',
			'knowledge.links.source' => 'ソース',
			'knowledge.links.target' => 'ターゲット',
			'knowledge.links.relationship' => '関係',
			'knowledge.links.add' => 'リンクを作成',
			'knowledge.tags.all' => 'すべてのタグ',
			'knowledge.tags.manage' => 'タグを管理',
			'knowledge.tags.none' => 'タグがありません。',
			'knowledge.graph.truncated' => '省略',
			'knowledge.importAll.title' => 'すべてを DDAgent にインポート',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => 'スキャンしたプロジェクト: ${count}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => '見つかったエージェントスキル: ${found} (新規: ${newSkills})',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => 'ルール: ${total} · 重複グループ: ${duplicates}',
			'knowledge.importAll.mergeDuplicates' => '重複エントリを統合',
			'knowledge.importAll.mergeDuplicatesHint' => 'DDAgent 内の重複行を統合します（ファイルではありません）',
			'knowledge.importAll.action' => 'すべてをインポート',
			'knowledge.importAll.readOnlyNotice' => 'エージェント側は読み取り専用です：DDAgent 独自のデータベースにインポートするだけで、CLI のファイルや設定を変更・削除することはありません。以下のオプションは DDAgent のデータのみを変更します。',
			'knowledge.importAll.dryRunNote' => 'ドライラン — まだ何も書き込まれていません。',
			'knowledge.importAll.importedNote' => 'インポートしました。',
			'knowledge.importAll.result' => ({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => 'インポート完了 — ルール: ${rules}、新しいスキル: ${newSkills}、削除: ${removed}、昇格: ${promoted}',
			'knowledge.importAll.description' => 'すべてのプロジェクトをスキャンし、エージェントのスキルをナレッジベースにインポートします。エージェント側は読み取り専用で、CLI 内のものは何も変更されません。',
			'knowledge.migrate.title' => '既存のルールを移行',
			'knowledge.migrate.scanned' => ({required Object count}) => '${count} 件のプロジェクトをスキャンしました。',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => 'ルール: 合計 ${total}、クリティカル ${critical}。',
			'knowledge.migrate.duplicates' => ({required Object count}) => 'プロジェクト間の重複グループ: ${count}',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => '削除: ${removed}、昇格: ${promoted}',
			'knowledge.migrate.mergeDuplicates' => '重複を統合',
			'knowledge.migrate.dryRunNote' => 'ドライラン — まだ何も変更されていません。',
			'knowledge.migrate.applied' => '適用しました。',
			'knowledge.importSkills.title' => 'エージェントスキルをインポート',
			'knowledge.importSkills.found' => ({required Object count}) => 'エージェント全体で ${count} 件のスキルが見つかりました。',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => '新規: ${imported} · スキップ: ${skipped}',
			'knowledge.importSkills.dryRunHint' => 'エージェントに付属するグローバル／デフォルトのスキル（ユーザー、システム、プラグイン）をナレッジのスキルとしてインポートします。ドライラン — まだ何もインポートされていません。',
			'knowledge.importSkills.importedNote' => 'ナレッジベースにインポートしました。',
			'knowledge.critical.make' => 'クリティカルにする',
			'knowledge.critical.makeAll' => 'すべてのルールをクリティカルにする',
			'knowledge.critical.makeAllHint' => 'それらを注入されるコンテキスト予算に追加します',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} トークン',
			'knowledge.contextBudget.title' => 'ルールコンテキスト（常に提供）',
			'knowledge.contextBudget.selectProject' => 'プロジェクトを選択すると、重要コンテキストのサイズが表示されます。',
			'knowledge.linkOptions.memory' => ({required Object title}) => 'メモリ: ${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => 'ルール: ${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => 'スキル: ${name}',
			'knowledge.linkOptions.personal' => ({required Object title}) => '個人情報: ${title}',
			'knowledge.errors.importFailed' => ({required Object error}) => 'インポートに失敗しました: ${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => '移行に失敗しました: ${error}',
			'knowledge.entityTypes.memory' => 'メモリ',
			'knowledge.entityTypes.rule' => 'ルール',
			'knowledge.entityTypes.skill' => 'スキル',
			'knowledge.entityTypes.personal' => '個人情報',
			'knowledge.entityTypes.project' => 'プロジェクト',
			'knowledge.entityTypes.tag' => 'タグ',
			'browser.dialogTitle' => 'エージェントブラウザ',
			'browser.viewError' => 'ブラウザ表示エラー',
			'browser.web' => 'Web',
			'collab.team' => 'チーム',
			'collab.invite' => '招待',
			'collab.inviteTeammate' => 'チームメイトを招待',
			'collab.shareTokenHint' => 'この招待トークンを共有してください — 一度だけ表示され、72時間で失効します:',
			'collab.createInvite' => '招待を作成',
			'collab.copyToken' => 'トークンをコピー',
			'collab.roles.member' => 'メンバー',
			'collab.roles.viewer' => '閲覧者',
			'collab.viewing.session' => 'セッション',
			'collab.viewing.card' => 'カード',
			'collab.viewing.board' => 'ボード',
			'fileTree.uploadTo' => 'アップロード先',
			'fileTree.uploadHere' => 'ここにアップロード',
			'fileTree.browseServerFilesystem' => 'サーバーのファイルシステムを参照',
			'fileTree.noFiles' => 'ファイルがありません',
			'fileTree.copyContents' => '内容をコピー',
			'fileTree.chooseFolder' => 'フォルダを選択',
			'fileTree.search.hint' => '名前を絞り込み / Enterで内容を検索',
			'fileTree.search.prompt' => 'クエリを入力してEnterを押してください',
			'fileTree.search.noMatches' => '一致するものがありません',
			'fileTree.search.resultsTruncated' => '結果は省略されています',
			'fileTree.titles.rename' => ({required Object name}) => '${name} の名前を変更',
			'fileTree.titles.delete' => ({required Object name}) => '${name} を削除',
			'fileTree.titles.download' => ({required Object name}) => '${name} をダウンロード',
			'fileTree.uploadedCount' => ({required Object count}) => '${count} 件のファイルをアップロードしました',
			'fileTree.newName' => '新しい名前',
			'fileTree.notRegisteredProject' => ({required Object path}) => '登録済みのプロジェクトではありません: ${path}',
			'fileTree.showGitignoredFiles' => 'gitignore されたファイルを表示',
			'fileTree.hideGitignoredFiles' => 'gitignore されたファイルを非表示',
			'fileTree.downloadUnsupportedOnWeb' => 'Webではダウンロードを利用できません',
			'fileTree.saveToPath' => 'パスに保存',
			'fileTree.savedTo' => ({required Object path}) => '${path} に保存しました',
			'fileTree.relative.now' => 'たった今',
			'fileTree.relative.minutes' => ({required Object n}) => '${n}分',
			'fileTree.relative.hours' => ({required Object n}) => '${n}時間',
			'fileTree.relative.days' => ({required Object n}) => '${n}日',
			'fileTree.projectRoot' => '（プロジェクトルート）',
			'fileTree.uploadLimitCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, other: '一度にアップロードできるのは最大 ${count} ファイルです。', ), 
			'fileTree.fileTooLarge' => ({required Object name}) => '${name} は 200MB を超えています。',
			'fileTree.deleteFolderConfirm' => ({required Object path}) => 'フォルダー「${path}」を削除しますか？この操作は元に戻せません。',
			'fileTree.deleteFileConfirm' => ({required Object path}) => 'ファイル「${path}」を削除しますか？この操作は元に戻せません。',
			'git.checkpoints.title' => 'チェックポイント',
			'git.checkpoints.restoreTitle' => 'チェックポイントを復元',
			'git.checkpoints.restoreMessage' => '作業ツリーをこのチェックポイントにリセットしますか？現在の変更は置き換えられます。',
			'git.checkpoints.restored' => 'チェックポイントを復元しました',
			'git.checkpoints.labelHint' => 'チェックポイントのラベル（任意）',
			'git.checkpoints.empty' => 'チェックポイントはまだありません',
			'git.checkpoints.create' => '新規',
			'git.stagedChanges' => 'ステージ済みの変更',
			'git.statusStaged' => 'ステージ済み',
			'git.switchBranch' => 'ブランチを切り替え',
			'git.unifiedDiff' => '統合差分',
			'git.splitDiff' => '分割差分',
			'git.noDiff' => '利用可能な差分がありません',
			'git.largeDiff' => '大きな差分のプレビュー: タブの応答性を保つため、レンダリングが制限されています。',
			'git.loadDiffFailed' => ({required Object error}) => '差分の読み込みに失敗しました: ${error}',
			'git.hunkStage' => '+ ハンク',
			'git.hunkUnstage' => '− ハンク',
			'git.stageHunk' => 'ハンクをステージ',
			'git.unstageHunk' => 'ハンクのステージを解除',
			'git.deleteFile' => 'ファイルを削除',
			'git.commitMessage' => 'コミットメッセージ',
			'git.aiButton' => '✦ AI',
			'git.commitCreated' => 'コミットを作成しました',
			'git.noBranch' => 'ブランチなし',
			'git.selectProject' => 'プロジェクトを選択',
			'git.branchSections.local' => 'ローカル',
			'git.branchSections.remote' => 'リモート',
			'kanban.card.untitled' => '無題',
			'kanban.comments.empty' => 'コメントはまだありません',
			'kanban.comments.add' => 'コメントを追加',
			'kanban.dialog.saving' => '保存中…',
			'kanban.details.title' => 'カードの詳細',
			'kanban.details.status' => ({required Object status}) => 'ステータス: ${status}',
			'kanban.empty.noProject' => 'プロジェクトが選択されていません',
			'kanban.saveFailed' => 'カードの保存に失敗しました',
			'kanban.time.now' => 'たった今',
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '1分前', other: '${count}分前', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '1時間前', other: '${count}時間前', ), 
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '1日前', other: '${count}日前', ), 
			'mcp.install.title' => 'DDAgent MCPサーバーをインストール',
			'mcp.install.description' => '選択したエージェントがMCP経由でDDAgentのナレッジベースとツールを使用できるようにします。',
			'mcp.install.cardDescription' => 'MCP経由でエージェントにナレッジベースとDDAgentツールを提供します — エージェントを選択するか、すべてにインストールしてください。',
			'mcp.install.installSelected' => '選択項目にインストール',
			'mcp.install.installForAll' => 'すべてにインストール',
			'mcp.install.button' => 'インストール',
			'mcp.install.failed' => ({required Object error}) => 'インストールに失敗しました: ${error}',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 個のエージェントにインストールしました。', other: '${count} 個のエージェントにインストールしました。', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => '${count} 個にインストールしました。失敗: ${failed}',
			'mcp.install.errorFallback' => 'エラー',
			'mcp.servers.loading' => 'MCPサーバーを読み込み中...',
			'mcp.servers.refreshingScopes' => 'プロジェクトスコープを更新中...',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Model Context Protocolサーバーは ${provider} に追加のツールとデータソースを提供します',
			'mcp.servers.addGlobalTitle' => 'グローバルMCPサーバーを追加',
			'mcp.servers.addGlobalDescription' => 'このMCPサーバーをすべてのプロバイダー（Claude、Cursor、Codex、OpenCode、Devin）に追加します。同じ設定をすべてのプロバイダーで機能させる必要があるため、stdio と HTTP トランスポートのみがサポートされます。',
			'mcp.servers.addGlobalMenuDescription' => 'グローバルMCPサーバーの追加は、共通の stdio または HTTP サーバーを Claude、Cursor、Codex、OpenCode、Devin に書き込みます。',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => '${provider} MCPサーバーを追加',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => '${provider} MCPサーバーの追加は ${provider} のみを変更します。',
			'mcp.servers.config.cwd' => 'Cwd',
			'mcp.servers.config.envVars' => '環境変数',
			'mcp.servers.selectProjectRequired' => 'プロジェクトスコープの MCP サーバーにはプロジェクトを選択してください',
			'mcp.servers.globalScopeUnsupported' => 'すべてのプロバイダーへの MCP サーバー追加では、ユーザーまたはプロジェクトのスコープのみ使用できます。',
			'mcp.servers.globalAddFailed' => ({required Object details}) => 'MCP サーバーをすべてのプロバイダーに追加できませんでした。${details}',
			'mcp.servers.scopeProject' => 'プロジェクト',
			'mcp.team.title' => 'チームMCP設定',
			'mcp.team.description' => 'MCPサーバー設定をチーム全体で共有します。全員が自動的に同期されます。',
			'mcp.team.cta' => 'DDAgent Pro で利用できます',
			'mcp.tokens.scopeWrite' => '書き込み',
			'mcp.tokens.scopeRead' => '読み取り',
			'mcp.form.submitTo' => ({required Object provider}) => '${provider} にサーバーを追加',
			'mcp.form.scope.userAllProviders' => 'ユーザー（すべてのプロバイダー）',
			'mcp.form.scope.claudeLocal' => 'Claude ローカル',
			'mcp.form.scope.projectAllProviders' => 'プロジェクト（すべてのプロバイダー）',
			'mcp.form.scope.description.userGlobal' => '各プロバイダーのユーザー設定に書き込み、このマシン上のすべてのプロジェクトで利用できます',
			'mcp.form.scope.description.user' => 'このマシン上のすべてのプロジェクトで利用できます',
			'mcp.form.scope.description.local' => '選択したプロジェクトのClaudeユーザー設定に保存されます',
			'mcp.form.scope.description.projectGlobal' => 'すべてのプロバイダーの選択したプロジェクトワークスペースに書き込みます',
			'mcp.form.scope.description.project' => '選択したプロジェクトのワークスペースに保存されます',
			'mcp.form.fields.workingDirectory' => '作業ディレクトリ',
			'mcp.form.fields.envVarNames' => '環境変数名',
			'mcp.form.fields.bearerTokenEnvVar' => 'ベアラートークン環境変数',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => 'MCPサーバーの追加は、すべてのプロバイダーで stdio と http のみをサポートし、${type} はサポートしません。',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} は ${type} MCPサーバーをサポートしていません',
			'mcp.form.validation.jsonMustBeObject' => 'JSON 設定はオブジェクトである必要があります',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.registrationRejected' => 'サーバーに登録を拒否されました',
			'notifications.errors.noResponse' => 'サーバーから応答がありません',
			'notifications.androidChannel.name' => 'DDAgent アラート',
			'notifications.androidChannel.description' => 'エージェントの実行、承認、エラーに関する通知',
			'onboarding.gitHint' => 'DDAgent セッションで作成されるコミットに使用されます。',
			'onboarding.completeSetup' => 'セットアップを完了',
			'onboarding.errors.nameAndEmailRequired' => 'git の名前とメールアドレスの両方が必要です。',
			'onboarding.errors.invalidEmail' => '有効なメールアドレスを入力してください。',
			'onboarding.agents.title' => 'AIエージェントを接続',
			'onboarding.agents.description' => '1つ以上のAIコーディングアシスタントにログインします。すべて任意です。',
			'onboarding.agents.laterHint' => 'これらは後で設定で構成できます。',
			'onboarding.mcp.title' => 'エージェントを DDAgent に接続',
			'onboarding.mcp.description' => 'DDAgent MCPサーバーをインストールすると、エージェントがナレッジベースとDDAgentツールを使用できるようになります。エージェントを選択するか、すべてにインストールしてください。',
			'onboarding.mcp.installSelected' => '選択項目にインストール',
			'onboarding.mcp.installForAll' => 'すべてにインストール',
			'onboarding.mcp.laterHint' => '任意 — 後で設定 → MCP からインストールすることもできます。',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 個のエージェントにインストールしました。', other: '${count} 個のエージェントにインストールしました。', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => '${installedCount} 個にインストールしました。失敗: ${failed}',
			'projects.cloneRepository' => 'リポジトリをクローン',
			'projects.repositoryCloned' => 'リポジトリをクローンしました',
			'projects.clone' => 'クローン',
			'projects.cloneFinished' => 'クローンが完了しました。プロジェクト一覧を更新中…',
			'projects.cloneFailed' => 'クローンに失敗しました',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.destinationPath' => '保存先パス',
			'projects.destinationPathRequired' => '保存先パスは必須です',
			'projects.repositoryUrlRequired' => 'リポジトリURLは必須です',
			'projects.githubTokenOptional' => 'GitHubトークン（任意）',
			'projects.archive' => 'アーカイブ',
			'projects.restore' => '復元',
			'projects.deletePermanently' => '完全に削除',
			'projects.deleteProjectTitle' => 'プロジェクトを削除しますか？',
			'projects.deleteProjectMessage' => ({required Object name}) => '「${name}」を、すべてのセッションと保存済み履歴を含めて完全に削除します（JSONL も消去）。元に戻せません。',
			'projects.archivedSection' => ({required Object count}) => 'アーカイブ済み (${count})',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} セッション', other: '${count} セッション', ), 
			'projects.newer' => '新しい方',
			'projects.older' => '古い方',
			'projects.projectArchived' => 'プロジェクトをアーカイブしました',
			'projects.projectRestored' => 'プロジェクトを復元しました',
			'projects.projectRenamed' => 'プロジェクト名を変更しました',
			'projects.projectDeleted' => 'プロジェクトを削除しました',
			'projects.failedToLoadTokens' => 'GitHubトークンの読み込みに失敗しました',
			'projects.displayNameOptional' => '表示名（任意）',
			'projects.usingStoredToken' => ({required Object name}) => '保存済みトークンを使用: ${name}',
			'projects.unknown' => '不明',
			'projects.project' => 'プロジェクト',
			'quota.section.config' => '設定',
			'quota.overview.tokensAndCost' => 'トークンとコスト',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status} (${count})',
			'quota.config.pollerTitle' => 'ポーラーとアラート',
			'quota.config.accountRouting' => 'アカウントのルーティング',
			'quota.config.save' => '設定を保存',
			'quota.chart.show' => '表示',
			'quota.chart.hide' => '非表示',
			'quota.chart.noData' => 'トレンドを表示するにはデータが不足しています。',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} トークン · ${cost}',
			'quota.duration.minutes' => ({required Object minutes}) => '${minutes}分',
			'quota.duration.hoursMinutes' => ({required Object hours, required Object minutes}) => '${hours}時間${minutes}分',
			'quota.duration.daysHours' => ({required Object days, required Object hours}) => '${days}日${hours}時間',
			'quota.duration.now' => 'たった今',
			'scheduler.newLabel' => '新規',
			'scheduler.runs' => '実行回数',
			'scheduler.editTitle' => 'スケジュールを編集',
			'scheduler.deleteTitle' => 'スケジュールを削除しますか？',
			'scheduler.deleteMessage' => ({required Object id}) => '繰り返しジョブ ${id} を削除します。既存のセッションは保持されます。',
			'scheduler.checking' => '確認中…',
			'scheduler.nextIn' => ({required Object time}) => '次回まで ${time}',
			'scheduler.worktree' => 'worktree',
			'scheduler.session' => ({required Object id}) => 'セッション ${id}',
			'scheduler.cronHint' => 'Cron（分 時 日 月 曜日） — 例: 0 9 * * *',
			'scheduler.promptHint' => 'エージェントへのプロンプト',
			'scheduler.runStatus.fired' => '起動',
			'scheduler.runStatus.skipped' => 'スキップ',
			'scheduler.runStatus.failed' => '失敗',
			'scheduler.runStatus.completed' => '完了',
			'scheduler.cronErrors.fieldCount' => ({required Object got}) => '5 つのフィールドが必要ですが、${got} 個です',
			'scheduler.cronErrors.fieldError' => ({required Object index, required Object error}) => 'フィールド ${index}: ${error}',
			'scheduler.cronErrors.empty' => '空です',
			'scheduler.cronErrors.invalidPart' => ({required Object part}) => '「${part}」は無効です',
			'scheduler.cronErrors.invalidValue' => ({required Object value}) => '無効な値「${value}」',
			'serverConnect.subtitle' => 'DDAgent サーバーに接続',
			'serverConnect.enterUrl' => 'サーバーのURLを入力',
			'serverConnect.connectionFailed' => ({required Object error}) => '接続に失敗しました (${error})',
			'serverConnect.connect' => '接続',
			'serverConnect.connecting' => '接続中…',
			'serverConnect.changeServer' => 'サーバーを変更',
			'serverConnect.local.title' => 'このデバイス',
			'serverConnect.local.subtitle' => 'このマシンでDDAgentサーバーを実行します',
			'serverConnect.local.install' => 'ローカルサーバーをインストール',
			'serverConnect.local.start' => 'ローカルサーバーを起動',
			'serverConnect.local.stop' => '停止',
			'serverConnect.local.starting' => 'ローカルサーバーを起動中…',
			'serverConnect.local.downloading' => ({required Object percent}) => 'サーバーをダウンロード中… ${percent}%',
			'serverConnect.local.installing' => 'インストール中…',
			'serverConnect.local.running' => ({required Object url}) => '${url} で実行中',
			'serverConnect.local.installed' => ({required Object version}) => 'インストール済み (v${version})',
			'serverConnect.local.connect' => 'このサーバーを使用',
			'serverConnect.local.error' => ({required Object error}) => 'ローカルサーバーエラー: ${error}',
			'serverConnect.local.or' => 'またはリモートサーバーに接続',
			'serverConnect.local.errors.releaseTagUnresolved' => 'DDAgent の最新リリースタグを取得できませんでした。',
			'serverConnect.local.errors.unsupportedPlatform' => 'このプラットフォームではローカルサーバーはサポートされていません。',
			'serverConnect.local.errors.unsupportedPlatformDetail' => ({required Object platform}) => 'このプラットフォームではローカルサーバーはサポートされていません（${platform}）。',
			'serverConnect.local.errors.nodeExtractionFailed' => ({required Object path}) => 'Node.js の展開で ${path} が作成されませんでした',
			'serverConnect.local.errors.downloadFailed' => ({required Object error}) => 'サーバーのダウンロードに失敗しました: ${error}',
			'serverConnect.local.errors.installFailed' => ({required Object error}) => 'サーバーのインストールに失敗しました: ${error}',
			'serverConnect.local.errors.bundleNotInstalled' => 'サーバーバンドルがインストールされていません。',
			'serverConnect.local.errors.spawnFailed' => ({required Object error}) => 'ローカルサーバーを起動できませんでした: ${error}',
			'serverConnect.local.errors.portInUse' => ({required Object port}) => 'ポート ${port} は別のアプリケーションで使用中です。',
			'serverConnect.local.errors.exitedDuringStartup' => 'ローカルサーバーが起動中に終了しました。',
			'serverConnect.local.errors.exitedDuringStartupWithOutput' => ({required Object output}) => 'ローカルサーバーが起動中に終了しました: ${output}',
			'serverConnect.local.errors.startTimeout' => 'ローカルサーバーの起動待機がタイムアウトしました。',
			'serverConnect.local.errors.tarFailed' => ({required Object command, required Object code, required Object output}) => '${command} が失敗しました（終了コード ${code}）: ${output}',
			'serverConnect.httpStatus' => ({required Object code}) => 'HTTP ${code}',
			'serverConnect.networkError' => 'ネットワークエラー',
			'sessions.noSessions' => 'セッションがありません',
			'sessions.noRecentSessions' => '最近のセッションはありません',
			'sessions.archivedSessions' => 'アーカイブ済みセッション',
			'sessions.rename' => '名前を変更',
			'sessions.archive' => 'アーカイブ',
			'sessions.compareWith' => '比較対象…',
			'sessions.projectPath' => 'プロジェクトパス',
			'sessions.newSessionProvider' => '新しいセッション — プロバイダー',
			'sessions.autoOrchestrator' => '自動（オーケストレーター）',
			'sessions.createFailed' => ({required Object error}) => 'セッションの作成に失敗しました: ${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => '「${name}」とそのトランスクリプトを削除します。元に戻せません。',
			'sessions.toasts.archived' => 'セッションをアーカイブしました',
			'sessions.toasts.restored' => 'セッションを復元しました',
			'sessions.toasts.deleted' => 'セッションを削除しました',
			'sessions.toasts.renamed' => 'セッション名を変更しました',
			'sessions.toasts.pinned' => 'セッションをピン留めしました',
			'sessions.toasts.unpinned' => 'セッションのピン留めを解除しました',
			'sessions.toasts.workspaceChanged' => 'ワークスペースを変更しました',
			'sessions.age.lessThanMinute' => '1分未満',
			'sessions.age.minutes' => ({required Object count}) => '${count}分',
			'sessions.age.hours' => ({required Object hours}) => '${hours}時間',
			'sessions.age.days' => ({required Object days}) => '${days}日',
			'sessions.activity.subagentRunning' => 'サブエージェントを実行中',
			'sessions.activity.readingFile' => ({required Object file}) => '${file} を読み取り中',
			'sessions.activity.runningTool' => ({required Object name}) => '${name} を実行中',
			'sessions.activity.editingFile' => ({required Object file}) => '${file} を編集中',
			'sessions.activity.editingFileGeneric' => 'ファイルを編集中',
			'sessions.activity.runningShellCommand' => 'シェルコマンドを実行中',
			'sessions.activity.runningCommand' => ({required Object command}) => '`${command}` を実行中',
			'sessions.activity.committingChanges' => '変更をコミット中',
			'sessions.activity.pushingBranch' => 'ブランチをプッシュ中',
			'sessions.activity.fetchingUrl' => ({required Object url}) => '${url} を取得中',
			'sessions.activity.searching' => ({required Object query}) => '“${query}” を検索中',
			'sessions.autoMini' => '自動（ミニ）',
			'sharedContext.title' => '共有ノート',
			'skills.moveSkill' => ({required Object name}) => '${name} を移動',
			'skills.deleteSkill' => ({required Object name}) => '${name} を削除',
			'skills.projectLabel' => 'プロジェクト',
			'skills.addDialog.title' => ({required Object provider}) => '${provider} スキルを追加',
			'skills.addDialog.chooseFileTitle' => 'SKILL.mdを選択',
			'skills.addDialog.chooseFolderTitle' => 'スキルフォルダを選択',
			'skills.addDialog.uploadHint' => 'SKILL.mdファイルまたは完全なスキルフォルダをアップロードしてください。',
			'skills.addDialog.pickTitle' => 'スキルフォルダまたはSKILL.mdを選択',
			'skills.addDialog.pickHint' => 'フォルダにはスクリプト、参照、アセットを含めることができます。',
			'skills.addDialog.chooseFiles' => 'ファイルを選択',
			'skills.addDialog.chooseFolder' => 'フォルダを選択',
			'skills.addDialog.readyToInstall' => 'インストールの準備完了',
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Markdownファイル · ${size}',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} ファイル · ${size}', other: '${count} ファイル · ${size}', ), 
			'skills.addDialog.removeQueued' => ({required Object name}) => '${name} を削除',
			'skills.addDialog.whereWillThisInstall' => 'どこにインストールされますか？',
			'skills.addDialog.hideInstallLocation' => 'インストール先を非表示',
			'skills.addDialog.folderUploadsNote' => 'フォルダをアップロードした場合は選択したフォルダ名が保持されます。単体ファイルの場合は `SKILL.md` の `name` が使用されます。',
			'skills.addDialog.installSkill' => 'スキルをインストール',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} 件のスキルをインストール', other: '${count} 件のスキルをインストール', ), 
			'skills.moveDialog.toProjectHint' => 'このスキルを所有するプロジェクトを選択してください。プロバイダーのグローバルスキルディレクトリから移動します。',
			'skills.moveDialog.toGlobalHint' => 'このスキルをグローバルスキルディレクトリに移動し、すべてのプロジェクトで使用できるようにします。',
			'skills.moveDialog.moveToProject' => 'プロジェクトに移動',
			'skills.moveDialog.moveToGlobal' => 'グローバルに移動',
			'skills.screen.manageDescription' => ({required Object provider}) => 'ローカルファイル、フォルダ全体、プロジェクト対応の場所から ${provider} スキルを管理します。',
			'skills.screen.searchHint' => 'スキルを検索...',
			'skills.screen.clearSearch' => 'スキル検索をクリア',
			'skills.screen.addSkill' => 'スキルを追加',
			'skills.screen.scanningProjectSkills' => 'プロジェクトのスキルをスキャン中...',
			'skills.screen.savedSuccessfully' => 'スキルを保存しました。',
			'skills.screen.loadingSkills' => ({required Object provider}) => '${provider} のスキルを読み込み中…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ja'))(count, one: '${count} スキル', other: '${count} スキル', ), 
			'skills.screen.deleteTitle' => ({required Object name}) => '${name} を削除しますか？',
			'skills.screen.deleteDescription' => ({required Object provider, required Object directory}) => '${provider} の管理対象スキルディレクトリから ${directory} ディレクトリを削除します。元に戻せません。',
			'skills.screen.noDescription' => 'スキルのフロントマターに説明がありません。',
			'skills.screen.pluginBadge' => ({required Object name}) => 'プラグイン: ${name}',
			'skills.screen.projectBadge' => ({required Object name}) => 'プロジェクト: ${name}',
			'skills.screen.sourceLabel' => 'ソース',
			'skills.empty.noProjects' => '利用可能なプロジェクトがありません',
			'skills.empty.noProjectsDescription' => 'プロジェクトまたはワークスペースを追加すると、そのスキルを参照できます。',
			'skills.empty.noSkillsInProject' => 'このプロジェクトにスキルがありません',
			'skills.empty.noSkillsInProjectDescription' => '選択したプロジェクトに .claude/skills、.cursor/skills、または .agents/skills フォルダを作成してください。',
			'skills.empty.noGlobalSkills' => 'グローバルスキルはまだ見つかっていません',
			'skills.empty.noGlobalSkillsDescription' => '上でグローバルスキルを追加すると、すべてのプロジェクトで利用できるようになります。',
			'skills.empty.noMatchingSkills' => '一致するスキルがありません',
			'skills.empty.noMatchingSkillsDescription' => '別のコマンド、名前、スコープ、プロジェクト、ソースパスをお試しください。',
			'skills.scopes.user' => 'ユーザー',
			'skills.scopes.plugin' => 'プラグイン',
			'skills.scopes.repo' => 'リポジトリ',
			'skills.scopes.project' => 'プロジェクト',
			'skills.scopes.admin' => '管理者',
			'skills.scopes.system' => 'システム',
			'skills.errors.dropMarkdownOrFolder' => '1つ以上のMarkdownファイル、またはSKILL.mdを含むフォルダをドロップしてください。',
			'skills.errors.addMarkdownFirst' => '先に1つ以上のMarkdownファイルを追加してください。',
			'skills.errors.importFailed' => 'スキルのインポートに失敗しました',
			'skills.errors.folderReadFailed' => 'スキルフォルダの読み取りに失敗しました',
			'skills.errors.folderFileLimit' => ({required Object count}) => 'スキルフォルダには最大 ${count} 個のファイルを含めることができます。',
			'skills.errors.folderSizeLimit' => '選択したスキルフォルダの合計サイズは30 MB未満である必要があります。',
			'skills.errors.missingSkillFile' => '選択したフォルダに SKILL.md ファイルが含まれていません。',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => '${name} から SKILL.md を読み取れませんでした。',
			'skills.providerShared' => '共有',
			'terminal.tabs.shellName' => ({required Object index}) => 'シェル ${index}',
			'terminal.tabs.plainShell' => '通常のシェル',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => 'ログイン: ${provider}',
			'terminal.tabs.runTitle' => ({required Object command}) => '実行: ${command}',
			'terminal.actions.newTab' => '新しいターミナルタブ',
			'terminal.actions.providerLogin' => 'プロバイダーログイン',
			'terminal.actions.restartSession' => 'セッションを再起動',
			'terminal.actions.clearOutput' => '出力をクリア',
			'terminal.actions.newShell' => '新しいシェル',
			'terminal.actions.connect' => '接続',
			'terminal.authUrl.openInBrowser' => 'ブラウザで開く',
			'terminal.authUrl.linkLabel' => ({required Object url}) => '認証リンク: ${url}',
			'terminal.fileLink.detected' => ({required Object path}) => 'ファイルを検出: ${path}',
			'terminal.shortcuts.interrupt' => '中断 (SIGINT)',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.suspend' => '一時停止 (SIGTSTP)',
			'terminal.shortcuts.hide' => 'ショートカットバーを非表示',
			'terminal.shortcuts.showTooltip' => 'ショートカットを表示',
			'terminal.shortcuts.hideTooltip' => 'ショートカットを非表示',
			'terminal.paste.title' => 'ターミナルに貼り付け',
			'terminal.paste.hint' => 'Ctrl+V / 右クリック → 貼り付け',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => 'リンクを開けませんでした: ${url}',
			'terminal.errors.frameError' => ({required Object message}) => '[エラー] ${message}',
			'terminal.errors.connectionError' => ({required Object message}) => '[接続エラー] ${message}',
			'terminal.loginDialog.title' => ({required Object provider}) => '${provider} CLI ログイン',
			'terminal.loginDialog.exited' => ({required Object code}) => '終了 (${code})',
			_ => null,
		} ?? switch (path) {
			'terminal.loginDialog.authLinkDetected' => '認証リンクを検出しました',
			'terminal.empty.title' => 'アクティブなターミナルがありません',
			'terminal.empty.description' => '新しいタブを作成して開始してください',
			'terminal.overlay.processExited' => 'プロセスが終了しました — 接続すると再起動します',
			'terminal.overlay.processExitedWithCode' => ({required Object code}) => 'プロセスが終了しました（コード ${code}）— 接続すると再起動します',
			'terminal.overlay.resumeSession' => ({required Object title}) => 'セッション ${title} を再開',
			'terminal.overlay.startSession' => ({required Object path}) => '${path} で新しいセッションを開始',
			'voice.preview' => 'プレビュー',
			'voice.settingsSaved' => '音声入力設定を保存しました',
			'voice.saveFailed' => 'STT設定の保存に失敗しました',
			'voice.apiKeySaved' => 'APIキー（保存済み、変更するには入力）',
			'workspace.exportChat' => 'チャットをエクスポート',
			'workspace.searchTranscript' => 'トランスクリプトを検索',
			'workspace.previousMatch' => '前の一致',
			'workspace.nextMatch' => '次の一致',
			'workspace.closeSearch' => '検索を閉じる',
			'workspace.newChatProvider' => '新しいチャット — プロバイダー',
			'workspace.closePane' => 'ペインを閉じる',
			'workspace.jumpToSession' => 'セッションへジャンプ…',
			'workspace.archivedWorkspaceName' => 'アーカイブ済み',
			'workspace.sendTo' => ({required Object count}) => '${count} 件に送信',
			'workspace.deleteSessionNotice' => 'セッションとそのトランスクリプトを削除します。元に戻せません。',
			'workspace.accountWithLabel' => ({required Object label}) => 'デフォルト · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => 'ワークスペースを変更する前に実行を終了してください',
			'workspace.restored' => 'ワークスペースを復元しました',
			'workspace.maximizePane' => 'ペインを最大化',
			'workspace.restorePanes' => 'ペインを復元',
			'workspace.reviewChangedFiles' => '変更されたファイルを確認',
			'workspace.paneTitle.chat' => 'チャット',
			'workspace.paneTitle.browser' => 'ブラウザ',
			'workspace.paneTitle.terminal' => 'ターミナル',
			'workspace.paneTitle.notes' => '共有メモ',
			'workspace.paneTitle.editor' => 'エディター',
			'workspace.paneTitle.git' => 'Git',
			'workspace.addEditorPane' => 'エディターペインを追加',
			'workspace.addGitPane' => 'Git ペインを追加',
			'workspace.unknownProjectPath' => 'プロジェクトのパスが不明です',
			'workspace.autoMini' => '自動 (mini)',
			'workspace.exportAs' => 'エクスポート形式:',
			'workspace.exportMarkdown' => 'Markdown (.md)',
			'workspace.exportHtml' => 'Web ページ (.html)',
			'workspace.exportPdf' => 'PDF (ファイルに印刷)',
			'workspace.matchPosition' => ({required Object current, required Object total}) => '${current} / ${total}',
			'workspace.launcherDescription' => 'このペインのワークスペースを選択するか、新しく作成してください。',
			'workspace.createWorkspace' => 'ワークスペースを作成',
			'worktrees.scripts' => 'スクリプト',
			'worktrees.emptyTitle' => 'worktree が見つかりません',
			'worktrees.emptyDescription' => 'worktree を作成して、機能開発やエージェントの実行を分離します。',
			'worktrees.opened' => ({required Object branch}) => 'worktree を開きました: ${branch}',
			'worktrees.created' => 'worktree を作成しました',
			'worktrees.removed' => 'worktree を削除しました',
			'worktrees.merged' => ({required Object branch}) => 'worktree を ${branch} にマージしました',
			'worktrees.scriptsSaved' => 'スクリプト設定を保存しました',
			'worktrees.setupLabel' => 'セットアップ: ',
			'worktrees.serverLabel' => 'サーバー: ',
			'worktrees.runRunning' => '実行中',
			'worktrees.runRunningWithPort' => ({required Object port}) => '実行中 :${port}',
			'worktrees.runButton' => '実行',
			'worktrees.stopButton' => '停止',
			'worktrees.mainBadge' => 'main',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD が ${sha} で分離',
			'worktrees.branchHint' => '新しいブランチ名（例: feature/login）',
			'worktrees.branchingOff' => ({required Object branch}) => '${branch} から分岐',
			'worktrees.mergeTitle' => ({required Object branch}) => '${branch} をマージ',
			'worktrees.mergeDescription' => ({required Object branch}) => '変更を ${branch} にマージします。',
			'worktrees.squashDescription' => 'すべてのコミットを1つのコミットにまとめる',
			'worktrees.cleanupDescription' => 'マージ後に worktree を削除してブランチも削除',
			'worktrees.removeTitle' => ({required Object branch}) => 'worktree ${branch} を削除しますか？',
			'worktrees.removeDescription' => 'worktree フォルダを削除します。リンクされたプロジェクトはアーカイブされます。',
			'worktrees.dirtyWarning' => ({required Object count}) => '警告: この worktree には失われる未コミットの変更が ${count} 件あります。',
			'worktrees.forceRemoveLabel' => '強制削除（変更を破棄）',
			'worktrees.deleteBranchLabel' => 'ブランチも削除',
			'worktrees.setupHint' => 'セットアップコマンド（例: npm install）',
			'worktrees.runHint' => '実行コマンド（例: npm run dev）',
			'worktrees.portHint' => '実行ポート（任意、例: 3000）',
			'worktrees.unknownSha' => '不明',
			'worktrees.baseBranchFallback' => 'ベースブランチ',
			'worktrees.runtimeStatus.idle' => '待機中',
			'worktrees.runtimeStatus.running' => '実行中',
			'worktrees.runtimeStatus.done' => '完了',
			'worktrees.runtimeStatus.failed' => '失敗',
			'worktrees.runtimeStatus.exited' => '終了',
			'browserUse.sessionStatus.ready' => '準備完了',
			'browserUse.sessionStatus.stopped' => '停止',
			'browserUse.sessionStatus.unavailable' => '利用不可',
			'orchestrator.stepFallback' => ({required Object n}) => 'ステップ ${n}',
			'miniOrchestrator.taskTypes.gate' => 'ゲート',
			'miniOrchestrator.roles.thinker' => 'シンカー',
			'miniOrchestrator.roles.worker' => 'ワーカー',
			_ => null,
		};
	}
}
