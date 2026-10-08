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
class TranslationsZhTw extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhTw({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsZhTw _root = this; // ignore: unused_field

	@override 
	TranslationsZhTw $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhTw(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$zh_TW auth = Translations$auth$zh_TW.internal(_root);
	@override late final Translations$chat$zh_TW chat = Translations$chat$zh_TW.internal(_root);
	@override late final Translations$codeEditor$zh_TW codeEditor = Translations$codeEditor$zh_TW.internal(_root);
	@override late final Translations$common$zh_TW common = Translations$common$zh_TW.internal(_root);
	@override late final Translations$settings$zh_TW settings = Translations$settings$zh_TW.internal(_root);
	@override late final Translations$sidebar$zh_TW sidebar = Translations$sidebar$zh_TW.internal(_root);
	@override late final Translations$tasks$zh_TW tasks = Translations$tasks$zh_TW.internal(_root);
	@override late final Translations$knowledge$zh_TW knowledge = Translations$knowledge$zh_TW.internal(_root);
	@override late final Translations$browser$zh_TW browser = Translations$browser$zh_TW.internal(_root);
	@override late final Translations$collab$zh_TW collab = Translations$collab$zh_TW.internal(_root);
	@override late final Translations$fileTree$zh_TW fileTree = Translations$fileTree$zh_TW.internal(_root);
	@override late final Translations$git$zh_TW git = Translations$git$zh_TW.internal(_root);
	@override late final Translations$kanban$zh_TW kanban = Translations$kanban$zh_TW.internal(_root);
	@override late final Translations$mcp$zh_TW mcp = Translations$mcp$zh_TW.internal(_root);
	@override late final Translations$notifications$zh_TW notifications = Translations$notifications$zh_TW.internal(_root);
	@override late final Translations$onboarding$zh_TW onboarding = Translations$onboarding$zh_TW.internal(_root);
	@override late final Translations$projects$zh_TW projects = Translations$projects$zh_TW.internal(_root);
	@override late final Translations$quota$zh_TW quota = Translations$quota$zh_TW.internal(_root);
	@override late final Translations$scheduler$zh_TW scheduler = Translations$scheduler$zh_TW.internal(_root);
	@override late final Translations$serverConnect$zh_TW serverConnect = Translations$serverConnect$zh_TW.internal(_root);
	@override late final Translations$sessions$zh_TW sessions = Translations$sessions$zh_TW.internal(_root);
	@override late final Translations$sharedContext$zh_TW sharedContext = Translations$sharedContext$zh_TW.internal(_root);
	@override late final Translations$skills$zh_TW skills = Translations$skills$zh_TW.internal(_root);
	@override late final Translations$terminal$zh_TW terminal = Translations$terminal$zh_TW.internal(_root);
	@override late final Translations$voice$zh_TW voice = Translations$voice$zh_TW.internal(_root);
	@override late final Translations$workspace$zh_TW workspace = Translations$workspace$zh_TW.internal(_root);
	@override late final Translations$worktrees$zh_TW worktrees = Translations$worktrees$zh_TW.internal(_root);
	@override late final Translations$browserUse$zh_TW browserUse = Translations$browserUse$zh_TW.internal(_root);
	@override late final Translations$orchestrator$zh_TW orchestrator = Translations$orchestrator$zh_TW.internal(_root);
	@override late final Translations$miniOrchestrator$zh_TW miniOrchestrator = Translations$miniOrchestrator$zh_TW.internal(_root);
}

// Path: auth
class Translations$auth$zh_TW extends Translations$auth$en {
	Translations$auth$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => '工作階段已過期，請重新登入。';
	@override late final Translations$auth$login$zh_TW login = Translations$auth$login$zh_TW.internal(_root);
	@override late final Translations$auth$register$zh_TW register = Translations$auth$register$zh_TW.internal(_root);
	@override late final Translations$auth$logout$zh_TW logout = Translations$auth$logout$zh_TW.internal(_root);
}

// Path: chat
class Translations$chat$zh_TW extends Translations$chat$en {
	Translations$chat$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$zh_TW codeBlock = Translations$chat$codeBlock$zh_TW.internal(_root);
	@override late final Translations$chat$copyMessage$zh_TW copyMessage = Translations$chat$copyMessage$zh_TW.internal(_root);
	@override late final Translations$chat$messageTypes$zh_TW messageTypes = Translations$chat$messageTypes$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$zh_TW orchestrator = Translations$chat$orchestrator$zh_TW.internal(_root);
	@override late final Translations$chat$tools$zh_TW tools = Translations$chat$tools$zh_TW.internal(_root);
	@override late final Translations$chat$search$zh_TW search = Translations$chat$search$zh_TW.internal(_root);
	@override late final Translations$chat$fileOperations$zh_TW fileOperations = Translations$chat$fileOperations$zh_TW.internal(_root);
	@override late final Translations$chat$interactive$zh_TW interactive = Translations$chat$interactive$zh_TW.internal(_root);
	@override late final Translations$chat$thinking$zh_TW thinking = Translations$chat$thinking$zh_TW.internal(_root);
	@override late final Translations$chat$json$zh_TW json = Translations$chat$json$zh_TW.internal(_root);
	@override late final Translations$chat$permissions$zh_TW permissions = Translations$chat$permissions$zh_TW.internal(_root);
	@override late final Translations$chat$todo$zh_TW todo = Translations$chat$todo$zh_TW.internal(_root);
	@override late final Translations$chat$plan$zh_TW plan = Translations$chat$plan$zh_TW.internal(_root);
	@override late final Translations$chat$usageLimit$zh_TW usageLimit = Translations$chat$usageLimit$zh_TW.internal(_root);
	@override late final Translations$chat$codex$zh_TW codex = Translations$chat$codex$zh_TW.internal(_root);
	@override late final Translations$chat$voice$zh_TW voice = Translations$chat$voice$zh_TW.internal(_root);
	@override late final Translations$chat$input$zh_TW input = Translations$chat$input$zh_TW.internal(_root);
	@override late final Translations$chat$composer$zh_TW composer = Translations$chat$composer$zh_TW.internal(_root);
	@override late final Translations$chat$providerSelection$zh_TW providerSelection = Translations$chat$providerSelection$zh_TW.internal(_root);
	@override late final Translations$chat$session$zh_TW session = Translations$chat$session$zh_TW.internal(_root);
	@override late final Translations$chat$shell$zh_TW shell = Translations$chat$shell$zh_TW.internal(_root);
	@override late final Translations$chat$claudeStatus$zh_TW claudeStatus = Translations$chat$claudeStatus$zh_TW.internal(_root);
	@override late final Translations$chat$projectSelection$zh_TW projectSelection = Translations$chat$projectSelection$zh_TW.internal(_root);
	@override late final Translations$chat$tasks$zh_TW tasks = Translations$chat$tasks$zh_TW.internal(_root);
	@override late final Translations$chat$splitSession$zh_TW splitSession = Translations$chat$splitSession$zh_TW.internal(_root);
	@override late final Translations$chat$sessionPicker$zh_TW sessionPicker = Translations$chat$sessionPicker$zh_TW.internal(_root);
	@override late final Translations$chat$splitWorkspace$zh_TW splitWorkspace = Translations$chat$splitWorkspace$zh_TW.internal(_root);
	@override late final Translations$chat$splitOverview$zh_TW splitOverview = Translations$chat$splitOverview$zh_TW.internal(_root);
	@override late final Translations$chat$askUserQuestion$zh_TW askUserQuestion = Translations$chat$askUserQuestion$zh_TW.internal(_root);
	@override late final Translations$chat$attachments$zh_TW attachments = Translations$chat$attachments$zh_TW.internal(_root);
	@override late final Translations$chat$checkpoint$zh_TW checkpoint = Translations$chat$checkpoint$zh_TW.internal(_root);
	@override late final Translations$chat$common$zh_TW common = Translations$chat$common$zh_TW.internal(_root);
	@override late final Translations$chat$taskMaster$zh_TW taskMaster = Translations$chat$taskMaster$zh_TW.internal(_root);
	@override late final Translations$chat$tokenUsage$zh_TW tokenUsage = Translations$chat$tokenUsage$zh_TW.internal(_root);
	@override late final Translations$chat$tool$zh_TW tool = Translations$chat$tool$zh_TW.internal(_root);
	@override late final Translations$chat$quotaBadge$zh_TW quotaBadge = Translations$chat$quotaBadge$zh_TW.internal(_root);
	@override late final Translations$chat$broadcast$zh_TW broadcast = Translations$chat$broadcast$zh_TW.internal(_root);
	@override late final Translations$chat$paneHeader$zh_TW paneHeader = Translations$chat$paneHeader$zh_TW.internal(_root);
	@override late final Translations$chat$export$zh_TW export = Translations$chat$export$zh_TW.internal(_root);
	@override late final Translations$chat$commandResult$zh_TW commandResult = Translations$chat$commandResult$zh_TW.internal(_root);
	@override late final Translations$chat$commands$zh_TW commands = Translations$chat$commands$zh_TW.internal(_root);
	@override late final Translations$chat$pinFile$zh_TW pinFile = Translations$chat$pinFile$zh_TW.internal(_root);
	@override late final Translations$chat$modelLibrary$zh_TW modelLibrary = Translations$chat$modelLibrary$zh_TW.internal(_root);
	@override late final Translations$chat$changes$zh_TW changes = Translations$chat$changes$zh_TW.internal(_root);
	@override late final Translations$chat$message$zh_TW message = Translations$chat$message$zh_TW.internal(_root);
	@override late final Translations$chat$permissionRequest$zh_TW permissionRequest = Translations$chat$permissionRequest$zh_TW.internal(_root);
	@override late final Translations$chat$commandDialog$zh_TW commandDialog = Translations$chat$commandDialog$zh_TW.internal(_root);
	@override late final Translations$chat$utilities$zh_TW utilities = Translations$chat$utilities$zh_TW.internal(_root);
	@override late final Translations$chat$toolBlocks$zh_TW toolBlocks = Translations$chat$toolBlocks$zh_TW.internal(_root);
	@override late final Translations$chat$commandMenu$zh_TW commandMenu = Translations$chat$commandMenu$zh_TW.internal(_root);
	@override late final Translations$chat$mentionMenu$zh_TW mentionMenu = Translations$chat$mentionMenu$zh_TW.internal(_root);
	@override late final Translations$chat$subheader$zh_TW subheader = Translations$chat$subheader$zh_TW.internal(_root);
	@override late final Translations$chat$transcript$zh_TW transcript = Translations$chat$transcript$zh_TW.internal(_root);
	@override late final Translations$chat$review$zh_TW review = Translations$chat$review$zh_TW.internal(_root);
}

// Path: codeEditor
class Translations$codeEditor$zh_TW extends Translations$codeEditor$en {
	Translations$codeEditor$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$zh_TW toolbar = Translations$codeEditor$toolbar$zh_TW.internal(_root);
	@override String loading({required Object fileName}) => '正在載入 ${fileName}...';
	@override late final Translations$codeEditor$header$zh_TW header = Translations$codeEditor$header$zh_TW.internal(_root);
	@override late final Translations$codeEditor$actions$zh_TW actions = Translations$codeEditor$actions$zh_TW.internal(_root);
	@override late final Translations$codeEditor$footer$zh_TW footer = Translations$codeEditor$footer$zh_TW.internal(_root);
	@override late final Translations$codeEditor$binaryFile$zh_TW binaryFile = Translations$codeEditor$binaryFile$zh_TW.internal(_root);
	@override late final Translations$codeEditor$filePreview$zh_TW filePreview = Translations$codeEditor$filePreview$zh_TW.internal(_root);
	@override String unsavedChanges({required Object name}) => '${name} 中有未儲存的變更';
	@override String get discardUnsavedChanges => '捨棄未儲存的變更？';
	@override late final Translations$codeEditor$mediaFile$zh_TW mediaFile = Translations$codeEditor$mediaFile$zh_TW.internal(_root);
	@override String get failedToLoad => '載入檔案失敗';
	@override late final Translations$codeEditor$hexDump$zh_TW hexDump = Translations$codeEditor$hexDump$zh_TW.internal(_root);
	@override late final Translations$codeEditor$settings$zh_TW settings = Translations$codeEditor$settings$zh_TW.internal(_root);
	@override late final Translations$codeEditor$diff$zh_TW diff = Translations$codeEditor$diff$zh_TW.internal(_root);
	@override late final Translations$codeEditor$emptyState$zh_TW emptyState = Translations$codeEditor$emptyState$zh_TW.internal(_root);
	@override late final Translations$codeEditor$toasts$zh_TW toasts = Translations$codeEditor$toasts$zh_TW.internal(_root);
}

// Path: common
class Translations$common$zh_TW extends Translations$common$en {
	Translations$common$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$zh_TW buttons = Translations$common$buttons$zh_TW.internal(_root);
	@override late final Translations$common$tabs$zh_TW tabs = Translations$common$tabs$zh_TW.internal(_root);
	@override late final Translations$common$quota$zh_TW quota = Translations$common$quota$zh_TW.internal(_root);
	@override late final Translations$common$status$zh_TW status = Translations$common$status$zh_TW.internal(_root);
	@override late final Translations$common$messages$zh_TW messages = Translations$common$messages$zh_TW.internal(_root);
	@override late final Translations$common$navigation$zh_TW navigation = Translations$common$navigation$zh_TW.internal(_root);
	@override late final Translations$common$common$zh_TW common = Translations$common$common$zh_TW.internal(_root);
	@override late final Translations$common$time$zh_TW time = Translations$common$time$zh_TW.internal(_root);
	@override late final Translations$common$fileOperations$zh_TW fileOperations = Translations$common$fileOperations$zh_TW.internal(_root);
	@override late final Translations$common$mainContent$zh_TW mainContent = Translations$common$mainContent$zh_TW.internal(_root);
	@override late final Translations$common$fileTree$zh_TW fileTree = Translations$common$fileTree$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$zh_TW projectWizard = Translations$common$projectWizard$zh_TW.internal(_root);
	@override late final Translations$common$notifications$zh_TW notifications = Translations$common$notifications$zh_TW.internal(_root);
	@override late final Translations$common$versionUpdate$zh_TW versionUpdate = Translations$common$versionUpdate$zh_TW.internal(_root);
	@override late final Translations$common$actions$zh_TW actions = Translations$common$actions$zh_TW.internal(_root);
	@override late final Translations$common$browserPane$zh_TW browserPane = Translations$common$browserPane$zh_TW.internal(_root);
	@override late final Translations$common$browserUse$zh_TW browserUse = Translations$common$browserUse$zh_TW.internal(_root);
	@override late final Translations$common$commandPalette$zh_TW commandPalette = Translations$common$commandPalette$zh_TW.internal(_root);
	@override late final Translations$common$gitPanel$zh_TW gitPanel = Translations$common$gitPanel$zh_TW.internal(_root);
	@override late final Translations$common$sessions$zh_TW sessions = Translations$common$sessions$zh_TW.internal(_root);
	@override late final Translations$common$projects$zh_TW projects = Translations$common$projects$zh_TW.internal(_root);
	@override late final Translations$common$sharedNotes$zh_TW sharedNotes = Translations$common$sharedNotes$zh_TW.internal(_root);
	@override late final Translations$common$codeBlock$zh_TW codeBlock = Translations$common$codeBlock$zh_TW.internal(_root);
	@override late final Translations$common$update$zh_TW update = Translations$common$update$zh_TW.internal(_root);
	@override late final Translations$common$appShell$zh_TW appShell = Translations$common$appShell$zh_TW.internal(_root);
	@override late final Translations$common$errors$zh_TW errors = Translations$common$errors$zh_TW.internal(_root);
}

// Path: settings
class Translations$settings$zh_TW extends Translations$settings$en {
	Translations$settings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override late final Translations$settings$changelog$zh_TW changelog = Translations$settings$changelog$zh_TW.internal(_root);
	@override late final Translations$settings$server$zh_TW server = Translations$settings$server$zh_TW.internal(_root);
	@override late final Translations$settings$updates$zh_TW updates = Translations$settings$updates$zh_TW.internal(_root);
	@override late final Translations$settings$tabs$zh_TW tabs = Translations$settings$tabs$zh_TW.internal(_root);
	@override late final Translations$settings$account$zh_TW account = Translations$settings$account$zh_TW.internal(_root);
	@override late final Translations$settings$mcp$zh_TW mcp = Translations$settings$mcp$zh_TW.internal(_root);
	@override late final Translations$settings$appearance$zh_TW appearance = Translations$settings$appearance$zh_TW.internal(_root);
	@override late final Translations$settings$actions$zh_TW actions = Translations$settings$actions$zh_TW.internal(_root);
	@override late final Translations$settings$quickSettings$zh_TW quickSettings = Translations$settings$quickSettings$zh_TW.internal(_root);
	@override late final Translations$settings$terminalShortcuts$zh_TW terminalShortcuts = Translations$settings$terminalShortcuts$zh_TW.internal(_root);
	@override late final Translations$settings$mainTabs$zh_TW mainTabs = Translations$settings$mainTabs$zh_TW.internal(_root);
	@override late final Translations$settings$miniOrchestration$zh_TW miniOrchestration = Translations$settings$miniOrchestration$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$zh_TW orchestration = Translations$settings$orchestration$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$zh_TW notifications = Translations$settings$notifications$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$zh_TW appearanceSettings = Translations$settings$appearanceSettings$zh_TW.internal(_root);
	@override late final Translations$settings$mcpForm$zh_TW mcpForm = Translations$settings$mcpForm$zh_TW.internal(_root);
	@override late final Translations$settings$saveStatus$zh_TW saveStatus = Translations$settings$saveStatus$zh_TW.internal(_root);
	@override late final Translations$settings$footerActions$zh_TW footerActions = Translations$settings$footerActions$zh_TW.internal(_root);
	@override late final Translations$settings$git$zh_TW git = Translations$settings$git$zh_TW.internal(_root);
	@override late final Translations$settings$apiKeys$zh_TW apiKeys = Translations$settings$apiKeys$zh_TW.internal(_root);
	@override late final Translations$settings$tasks$zh_TW tasks = Translations$settings$tasks$zh_TW.internal(_root);
	@override late final Translations$settings$agents$zh_TW agents = Translations$settings$agents$zh_TW.internal(_root);
	@override late final Translations$settings$permissions$zh_TW permissions = Translations$settings$permissions$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$zh_TW mcpServers = Translations$settings$mcpServers$zh_TW.internal(_root);
	@override late final Translations$settings$quota$zh_TW quota = Translations$settings$quota$zh_TW.internal(_root);
	@override late final Translations$settings$browser$zh_TW browser = Translations$settings$browser$zh_TW.internal(_root);
	@override late final Translations$settings$workspaces$zh_TW workspaces = Translations$settings$workspaces$zh_TW.internal(_root);
	@override late final Translations$settings$stt$zh_TW stt = Translations$settings$stt$zh_TW.internal(_root);
	@override late final Translations$settings$schedules$zh_TW schedules = Translations$settings$schedules$zh_TW.internal(_root);
	@override late final Translations$settings$mcpTokens$zh_TW mcpTokens = Translations$settings$mcpTokens$zh_TW.internal(_root);
	@override late final Translations$settings$about$zh_TW about = Translations$settings$about$zh_TW.internal(_root);
	@override late final Translations$settings$shortcuts$zh_TW shortcuts = Translations$settings$shortcuts$zh_TW.internal(_root);
}

// Path: sidebar
class Translations$sidebar$zh_TW extends Translations$sidebar$en {
	Translations$sidebar$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$zh_TW projects = Translations$sidebar$projects$zh_TW.internal(_root);
	@override late final Translations$sidebar$app$zh_TW app = Translations$sidebar$app$zh_TW.internal(_root);
	@override late final Translations$sidebar$panel$zh_TW panel = Translations$sidebar$panel$zh_TW.internal(_root);
	@override late final Translations$sidebar$sessions$zh_TW sessions = Translations$sidebar$sessions$zh_TW.internal(_root);
	@override late final Translations$sidebar$tooltips$zh_TW tooltips = Translations$sidebar$tooltips$zh_TW.internal(_root);
	@override late final Translations$sidebar$navigation$zh_TW navigation = Translations$sidebar$navigation$zh_TW.internal(_root);
	@override late final Translations$sidebar$actions$zh_TW actions = Translations$sidebar$actions$zh_TW.internal(_root);
	@override late final Translations$sidebar$workspace$zh_TW workspace = Translations$sidebar$workspace$zh_TW.internal(_root);
	@override late final Translations$sidebar$branding$zh_TW branding = Translations$sidebar$branding$zh_TW.internal(_root);
	@override late final Translations$sidebar$status$zh_TW status = Translations$sidebar$status$zh_TW.internal(_root);
	@override late final Translations$sidebar$time$zh_TW time = Translations$sidebar$time$zh_TW.internal(_root);
	@override late final Translations$sidebar$messages$zh_TW messages = Translations$sidebar$messages$zh_TW.internal(_root);
	@override late final Translations$sidebar$version$zh_TW version = Translations$sidebar$version$zh_TW.internal(_root);
	@override late final Translations$sidebar$search$zh_TW search = Translations$sidebar$search$zh_TW.internal(_root);
	@override late final Translations$sidebar$recent$zh_TW recent = Translations$sidebar$recent$zh_TW.internal(_root);
	@override late final Translations$sidebar$deleteConfirmation$zh_TW deleteConfirmation = Translations$sidebar$deleteConfirmation$zh_TW.internal(_root);
	@override late final Translations$sidebar$zones$zh_TW zones = Translations$sidebar$zones$zh_TW.internal(_root);
	@override late final Translations$sidebar$tabs$zh_TW tabs = Translations$sidebar$tabs$zh_TW.internal(_root);
}

// Path: tasks
class Translations$tasks$zh_TW extends Translations$tasks$en {
	Translations$tasks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$zh_TW notConfigured = Translations$tasks$notConfigured$zh_TW.internal(_root);
	@override late final Translations$tasks$gettingStarted$zh_TW gettingStarted = Translations$tasks$gettingStarted$zh_TW.internal(_root);
	@override late final Translations$tasks$setupModal$zh_TW setupModal = Translations$tasks$setupModal$zh_TW.internal(_root);
	@override late final Translations$tasks$helpGuide$zh_TW helpGuide = Translations$tasks$helpGuide$zh_TW.internal(_root);
	@override late final Translations$tasks$search$zh_TW search = Translations$tasks$search$zh_TW.internal(_root);
	@override late final Translations$tasks$filters$zh_TW filters = Translations$tasks$filters$zh_TW.internal(_root);
	@override late final Translations$tasks$sort$zh_TW sort = Translations$tasks$sort$zh_TW.internal(_root);
	@override late final Translations$tasks$views$zh_TW views = Translations$tasks$views$zh_TW.internal(_root);
	@override late final Translations$tasks$kanban$zh_TW kanban = Translations$tasks$kanban$zh_TW.internal(_root);
	@override late final Translations$tasks$buttons$zh_TW buttons = Translations$tasks$buttons$zh_TW.internal(_root);
	@override late final Translations$tasks$prd$zh_TW prd = Translations$tasks$prd$zh_TW.internal(_root);
	@override late final Translations$tasks$statuses$zh_TW statuses = Translations$tasks$statuses$zh_TW.internal(_root);
	@override late final Translations$tasks$priorities$zh_TW priorities = Translations$tasks$priorities$zh_TW.internal(_root);
	@override late final Translations$tasks$noMatchingTasks$zh_TW noMatchingTasks = Translations$tasks$noMatchingTasks$zh_TW.internal(_root);
	@override late final Translations$tasks$board$zh_TW board = Translations$tasks$board$zh_TW.internal(_root);
	@override late final Translations$tasks$card$zh_TW card = Translations$tasks$card$zh_TW.internal(_root);
	@override late final Translations$tasks$createTask$zh_TW createTask = Translations$tasks$createTask$zh_TW.internal(_root);
	@override late final Translations$tasks$list$zh_TW list = Translations$tasks$list$zh_TW.internal(_root);
	@override late final Translations$tasks$nextTask$zh_TW nextTask = Translations$tasks$nextTask$zh_TW.internal(_root);
	@override late final Translations$tasks$taskDetail$zh_TW taskDetail = Translations$tasks$taskDetail$zh_TW.internal(_root);
	@override late final Translations$tasks$toasts$zh_TW toasts = Translations$tasks$toasts$zh_TW.internal(_root);
	@override late final Translations$tasks$taskmaster$zh_TW taskmaster = Translations$tasks$taskmaster$zh_TW.internal(_root);
}

// Path: knowledge
class Translations$knowledge$zh_TW extends Translations$knowledge$en {
	Translations$knowledge$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '知識';
	@override late final Translations$knowledge$tabs$zh_TW tabs = Translations$knowledge$tabs$zh_TW.internal(_root);
	@override late final Translations$knowledge$common$zh_TW common = Translations$knowledge$common$zh_TW.internal(_root);
	@override late final Translations$knowledge$actions$zh_TW actions = Translations$knowledge$actions$zh_TW.internal(_root);
	@override late final Translations$knowledge$dialog$zh_TW dialog = Translations$knowledge$dialog$zh_TW.internal(_root);
	@override late final Translations$knowledge$fields$zh_TW fields = Translations$knowledge$fields$zh_TW.internal(_root);
	@override late final Translations$knowledge$dashboard$zh_TW dashboard = Translations$knowledge$dashboard$zh_TW.internal(_root);
	@override late final Translations$knowledge$empty$zh_TW empty = Translations$knowledge$empty$zh_TW.internal(_root);
	@override late final Translations$knowledge$history$zh_TW history = Translations$knowledge$history$zh_TW.internal(_root);
	@override late final Translations$knowledge$priorities$zh_TW priorities = Translations$knowledge$priorities$zh_TW.internal(_root);
	@override late final Translations$knowledge$search$zh_TW search = Translations$knowledge$search$zh_TW.internal(_root);
	@override late final Translations$knowledge$links$zh_TW links = Translations$knowledge$links$zh_TW.internal(_root);
	@override late final Translations$knowledge$tags$zh_TW tags = Translations$knowledge$tags$zh_TW.internal(_root);
	@override late final Translations$knowledge$graph$zh_TW graph = Translations$knowledge$graph$zh_TW.internal(_root);
	@override late final Translations$knowledge$importAll$zh_TW importAll = Translations$knowledge$importAll$zh_TW.internal(_root);
	@override late final Translations$knowledge$migrate$zh_TW migrate = Translations$knowledge$migrate$zh_TW.internal(_root);
	@override late final Translations$knowledge$importSkills$zh_TW importSkills = Translations$knowledge$importSkills$zh_TW.internal(_root);
	@override late final Translations$knowledge$critical$zh_TW critical = Translations$knowledge$critical$zh_TW.internal(_root);
	@override late final Translations$knowledge$contextBudget$zh_TW contextBudget = Translations$knowledge$contextBudget$zh_TW.internal(_root);
	@override late final Translations$knowledge$linkOptions$zh_TW linkOptions = Translations$knowledge$linkOptions$zh_TW.internal(_root);
	@override late final Translations$knowledge$errors$zh_TW errors = Translations$knowledge$errors$zh_TW.internal(_root);
	@override late final Translations$knowledge$entityTypes$zh_TW entityTypes = Translations$knowledge$entityTypes$zh_TW.internal(_root);
}

// Path: browser
class Translations$browser$zh_TW extends Translations$browser$en {
	Translations$browser$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => '代理瀏覽器';
	@override String get viewError => '瀏覽器檢視錯誤';
	@override String get web => '網頁';
}

// Path: collab
class Translations$collab$zh_TW extends Translations$collab$en {
	Translations$collab$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get team => '團隊';
	@override String get invite => '邀請';
	@override String get inviteTeammate => '邀請隊友';
	@override String get shareTokenHint => '分享此邀請權杖 — 僅顯示一次，並在 72 小時後過期：';
	@override String get createInvite => '建立邀請';
	@override String get copyToken => '複製權杖';
	@override late final Translations$collab$roles$zh_TW roles = Translations$collab$roles$zh_TW.internal(_root);
	@override late final Translations$collab$viewing$zh_TW viewing = Translations$collab$viewing$zh_TW.internal(_root);
}

// Path: fileTree
class Translations$fileTree$zh_TW extends Translations$fileTree$en {
	Translations$fileTree$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get uploadTo => '上傳至';
	@override String get uploadHere => '上傳到此處';
	@override String get browseServerFilesystem => '瀏覽伺服器檔案系統';
	@override String get noFiles => '沒有檔案';
	@override String get copyContents => '複製內容';
	@override String get chooseFolder => '選擇資料夾';
	@override late final Translations$fileTree$search$zh_TW search = Translations$fileTree$search$zh_TW.internal(_root);
	@override late final Translations$fileTree$titles$zh_TW titles = Translations$fileTree$titles$zh_TW.internal(_root);
	@override String uploadedCount({required Object count}) => '已上傳 ${count} 個檔案';
	@override String get newName => '新名稱';
	@override String notRegisteredProject({required Object path}) => '不是已註冊的專案：${path}';
	@override String get showGitignoredFiles => '顯示被 gitignore 忽略的檔案';
	@override String get hideGitignoredFiles => '隱藏被 gitignore 忽略的檔案';
	@override String get downloadUnsupportedOnWeb => '網頁版不支援下載';
	@override String get saveToPath => '儲存至路徑';
	@override String savedTo({required Object path}) => '已儲存至 ${path}';
	@override late final Translations$fileTree$relative$zh_TW relative = Translations$fileTree$relative$zh_TW.internal(_root);
	@override String get projectRoot => '（專案根目錄）';
	@override String uploadLimitCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '一次最多可上傳 ${count} 個檔案。',
	);
	@override String fileTooLarge({required Object name}) => '${name} 超過 200MB。';
	@override String deleteFolderConfirm({required Object path}) => '刪除資料夾「${path}」？此操作無法復原。';
	@override String deleteFileConfirm({required Object path}) => '刪除檔案「${path}」？此操作無法復原。';
}

// Path: git
class Translations$git$zh_TW extends Translations$git$en {
	Translations$git$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$git$checkpoints$zh_TW checkpoints = Translations$git$checkpoints$zh_TW.internal(_root);
	@override String get stagedChanges => '已暫存的變更';
	@override String get statusStaged => '已暫存';
	@override String get switchBranch => '切換分支';
	@override String get unifiedDiff => '統一差異';
	@override String get splitDiff => '並排差異';
	@override String get noDiff => '沒有可用的差異';
	@override String get largeDiff => '大型差異預覽：為保持分頁順暢，渲染範圍已受限。';
	@override String loadDiffFailed({required Object error}) => '載入差異失敗：${error}';
	@override String get hunkStage => '+ 區塊';
	@override String get hunkUnstage => '− 區塊';
	@override String get stageHunk => '暫存區塊';
	@override String get unstageHunk => '取消暫存區塊';
	@override String get deleteFile => '刪除檔案';
	@override String get commitMessage => '提交訊息';
	@override String get aiButton => '✦ AI';
	@override String get commitCreated => '已建立提交';
	@override String get noBranch => '沒有分支';
	@override String get selectProject => '選擇專案';
	@override late final Translations$git$branchSections$zh_TW branchSections = Translations$git$branchSections$zh_TW.internal(_root);
}

// Path: kanban
class Translations$kanban$zh_TW extends Translations$kanban$en {
	Translations$kanban$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$zh_TW card = Translations$kanban$card$zh_TW.internal(_root);
	@override late final Translations$kanban$comments$zh_TW comments = Translations$kanban$comments$zh_TW.internal(_root);
	@override late final Translations$kanban$dialog$zh_TW dialog = Translations$kanban$dialog$zh_TW.internal(_root);
	@override late final Translations$kanban$details$zh_TW details = Translations$kanban$details$zh_TW.internal(_root);
	@override late final Translations$kanban$empty$zh_TW empty = Translations$kanban$empty$zh_TW.internal(_root);
	@override String get saveFailed => '儲存卡片失敗';
	@override late final Translations$kanban$time$zh_TW time = Translations$kanban$time$zh_TW.internal(_root);
}

// Path: mcp
class Translations$mcp$zh_TW extends Translations$mcp$en {
	Translations$mcp$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$install$zh_TW install = Translations$mcp$install$zh_TW.internal(_root);
	@override late final Translations$mcp$servers$zh_TW servers = Translations$mcp$servers$zh_TW.internal(_root);
	@override late final Translations$mcp$team$zh_TW team = Translations$mcp$team$zh_TW.internal(_root);
	@override late final Translations$mcp$tokens$zh_TW tokens = Translations$mcp$tokens$zh_TW.internal(_root);
	@override late final Translations$mcp$form$zh_TW form = Translations$mcp$form$zh_TW.internal(_root);
}

// Path: notifications
class Translations$notifications$zh_TW extends Translations$notifications$en {
	Translations$notifications$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'DDAgent Flutter';
	@override late final Translations$notifications$errors$zh_TW errors = Translations$notifications$errors$zh_TW.internal(_root);
	@override late final Translations$notifications$androidChannel$zh_TW androidChannel = Translations$notifications$androidChannel$zh_TW.internal(_root);
}

// Path: onboarding
class Translations$onboarding$zh_TW extends Translations$onboarding$en {
	Translations$onboarding$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get gitHint => '用於 DDAgent 工作階段建立的提交。';
	@override String get completeSetup => '完成設定';
	@override late final Translations$onboarding$errors$zh_TW errors = Translations$onboarding$errors$zh_TW.internal(_root);
	@override late final Translations$onboarding$agents$zh_TW agents = Translations$onboarding$agents$zh_TW.internal(_root);
	@override late final Translations$onboarding$mcp$zh_TW mcp = Translations$onboarding$mcp$zh_TW.internal(_root);
}

// Path: projects
class Translations$projects$zh_TW extends Translations$projects$en {
	Translations$projects$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cloneRepository => '複製儲存庫';
	@override String get repositoryCloned => '儲存庫已複製';
	@override String get clone => '複製';
	@override String get cloneFinished => '複製完成。正在重新整理專案清單…';
	@override String get cloneFailed => '複製失敗';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get destinationPath => '目的地路徑';
	@override String get destinationPathRequired => '目的地路徑為必填';
	@override String get repositoryUrlRequired => '儲存庫 URL 為必填';
	@override String get githubTokenOptional => 'GitHub 權杖（選填）';
	@override String get archive => '封存';
	@override String get restore => '還原';
	@override String get deletePermanently => '永久刪除';
	@override String get deleteProjectTitle => '刪除專案？';
	@override String deleteProjectMessage({required Object name}) => '永久移除「${name}」，包括所有工作階段與儲存的歷史記錄（清除 JSONL）。此操作無法復原。';
	@override String archivedSection({required Object count}) => '已封存（${count}）';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個工作階段',
		other: '${count} 個工作階段',
	);
	@override String get newer => '較新';
	@override String get older => '較舊';
	@override String get projectArchived => '專案已封存';
	@override String get projectRestored => '專案已還原';
	@override String get projectRenamed => '專案已重新命名';
	@override String get projectDeleted => '專案已刪除';
	@override String get failedToLoadTokens => '載入 GitHub 權杖失敗';
	@override String get displayNameOptional => '顯示名稱（選填）';
	@override String usingStoredToken({required Object name}) => '使用已儲存的權杖：${name}';
	@override String get unknown => '未知';
	@override String get project => '專案';
}

// Path: quota
class Translations$quota$zh_TW extends Translations$quota$en {
	Translations$quota$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$section$zh_TW section = Translations$quota$section$zh_TW.internal(_root);
	@override late final Translations$quota$overview$zh_TW overview = Translations$quota$overview$zh_TW.internal(_root);
	@override late final Translations$quota$agents$zh_TW agents = Translations$quota$agents$zh_TW.internal(_root);
	@override late final Translations$quota$config$zh_TW config = Translations$quota$config$zh_TW.internal(_root);
	@override late final Translations$quota$chart$zh_TW chart = Translations$quota$chart$zh_TW.internal(_root);
	@override late final Translations$quota$duration$zh_TW duration = Translations$quota$duration$zh_TW.internal(_root);
}

// Path: scheduler
class Translations$scheduler$zh_TW extends Translations$scheduler$en {
	Translations$scheduler$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get newLabel => '新增';
	@override String get runs => '執行次數';
	@override String get editTitle => '編輯排程';
	@override String get deleteTitle => '刪除排程？';
	@override String deleteMessage({required Object id}) => '這會移除週期性工作 ${id}。現有工作階段會保留。';
	@override String get checking => '檢查中…';
	@override String nextIn({required Object time}) => '${time} 後';
	@override String get worktree => 'worktree';
	@override String session({required Object id}) => '工作階段 ${id}';
	@override String get cronHint => 'Cron（分 時 日 月 星期）— 例如 0 9 * * *';
	@override String get promptHint => '代理的提示詞';
	@override late final Translations$scheduler$runStatus$zh_TW runStatus = Translations$scheduler$runStatus$zh_TW.internal(_root);
	@override late final Translations$scheduler$cronErrors$zh_TW cronErrors = Translations$scheduler$cronErrors$zh_TW.internal(_root);
}

// Path: serverConnect
class Translations$serverConnect$zh_TW extends Translations$serverConnect$en {
	Translations$serverConnect$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '連線到你的 DDAgent 伺服器';
	@override String get enterUrl => '輸入伺服器 URL';
	@override String connectionFailed({required Object error}) => '連線失敗（${error}）';
	@override String get connect => '連線';
	@override String get connecting => '正在連線…';
	@override String get changeServer => '更換伺服器';
	@override late final Translations$serverConnect$local$zh_TW local = Translations$serverConnect$local$zh_TW.internal(_root);
	@override String httpStatus({required Object code}) => 'HTTP ${code}';
	@override String get networkError => '網路錯誤';
}

// Path: sessions
class Translations$sessions$zh_TW extends Translations$sessions$en {
	Translations$sessions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get noSessions => '沒有工作階段';
	@override String get noRecentSessions => '沒有最近的工作階段';
	@override String get archivedSessions => '已封存的工作階段';
	@override String get rename => '重新命名';
	@override String get archive => '封存';
	@override String get compareWith => '比較…';
	@override String get projectPath => '專案路徑';
	@override String get newSessionProvider => '新工作階段 — 提供者';
	@override String get autoOrchestrator => '自動（編排器）';
	@override String createFailed({required Object error}) => '建立工作階段失敗：${error}';
	@override String deleteSessionMessage({required Object name}) => '移除「${name}」及其記錄。此操作無法復原。';
	@override late final Translations$sessions$toasts$zh_TW toasts = Translations$sessions$toasts$zh_TW.internal(_root);
	@override late final Translations$sessions$age$zh_TW age = Translations$sessions$age$zh_TW.internal(_root);
	@override late final Translations$sessions$activity$zh_TW activity = Translations$sessions$activity$zh_TW.internal(_root);
	@override String get autoMini => '自動（迷你）';
}

// Path: sharedContext
class Translations$sharedContext$zh_TW extends Translations$sharedContext$en {
	Translations$sharedContext$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '共用筆記';
}

// Path: skills
class Translations$skills$zh_TW extends Translations$skills$en {
	Translations$skills$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String moveSkill({required Object name}) => '移動 ${name}';
	@override String deleteSkill({required Object name}) => '刪除 ${name}';
	@override String get projectLabel => '專案';
	@override late final Translations$skills$addDialog$zh_TW addDialog = Translations$skills$addDialog$zh_TW.internal(_root);
	@override late final Translations$skills$moveDialog$zh_TW moveDialog = Translations$skills$moveDialog$zh_TW.internal(_root);
	@override late final Translations$skills$screen$zh_TW screen = Translations$skills$screen$zh_TW.internal(_root);
	@override late final Translations$skills$empty$zh_TW empty = Translations$skills$empty$zh_TW.internal(_root);
	@override late final Translations$skills$scopes$zh_TW scopes = Translations$skills$scopes$zh_TW.internal(_root);
	@override late final Translations$skills$errors$zh_TW errors = Translations$skills$errors$zh_TW.internal(_root);
	@override String get providerShared => '共用';
}

// Path: terminal
class Translations$terminal$zh_TW extends Translations$terminal$en {
	Translations$terminal$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$tabs$zh_TW tabs = Translations$terminal$tabs$zh_TW.internal(_root);
	@override late final Translations$terminal$actions$zh_TW actions = Translations$terminal$actions$zh_TW.internal(_root);
	@override late final Translations$terminal$authUrl$zh_TW authUrl = Translations$terminal$authUrl$zh_TW.internal(_root);
	@override late final Translations$terminal$fileLink$zh_TW fileLink = Translations$terminal$fileLink$zh_TW.internal(_root);
	@override late final Translations$terminal$shortcuts$zh_TW shortcuts = Translations$terminal$shortcuts$zh_TW.internal(_root);
	@override late final Translations$terminal$paste$zh_TW paste = Translations$terminal$paste$zh_TW.internal(_root);
	@override late final Translations$terminal$errors$zh_TW errors = Translations$terminal$errors$zh_TW.internal(_root);
	@override late final Translations$terminal$loginDialog$zh_TW loginDialog = Translations$terminal$loginDialog$zh_TW.internal(_root);
	@override late final Translations$terminal$empty$zh_TW empty = Translations$terminal$empty$zh_TW.internal(_root);
	@override late final Translations$terminal$overlay$zh_TW overlay = Translations$terminal$overlay$zh_TW.internal(_root);
}

// Path: voice
class Translations$voice$zh_TW extends Translations$voice$en {
	Translations$voice$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get preview => '預覽';
	@override String get settingsSaved => '語音輸入設定已儲存';
	@override String get saveFailed => '儲存 STT 設定失敗';
	@override String get apiKeySaved => 'API 金鑰（已儲存，輸入以取代）';
}

// Path: workspace
class Translations$workspace$zh_TW extends Translations$workspace$en {
	Translations$workspace$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get exportChat => '匯出對話';
	@override String get searchTranscript => '搜尋記錄';
	@override String get previousMatch => '上一個符合項目';
	@override String get nextMatch => '下一個符合項目';
	@override String get closeSearch => '關閉搜尋';
	@override String get newChatProvider => '新對話 — 提供者';
	@override String get closePane => '關閉窗格';
	@override String get jumpToSession => '跳至工作階段…';
	@override String get archivedWorkspaceName => '已封存';
	@override String sendTo({required Object count}) => '傳送至 ${count}';
	@override String get deleteSessionNotice => '移除工作階段及其記錄。無法復原。';
	@override String accountWithLabel({required Object label}) => '預設 · ${label}';
	@override String get finishRunBeforeChangingWorkspace => '變更工作區前請先完成執行';
	@override String get restored => '工作區已還原';
	@override String get maximizePane => '最大化窗格';
	@override String get restorePanes => '還原窗格';
	@override String get reviewChangedFiles => '檢閱已變更的檔案';
	@override late final Translations$workspace$paneTitle$zh_TW paneTitle = Translations$workspace$paneTitle$zh_TW.internal(_root);
	@override String get addEditorPane => '新增編輯器窗格';
	@override String get addGitPane => '新增 Git 窗格';
	@override String get unknownProjectPath => '未知的專案路徑';
	@override String get autoMini => '自動 (mini)';
	@override String get exportAs => '匯出為：';
	@override String get exportMarkdown => 'Markdown (.md)';
	@override String get exportHtml => '網頁 (.html)';
	@override String get exportPdf => 'PDF（列印至檔案）';
	@override String matchPosition({required Object current, required Object total}) => '${current} / ${total}';
	@override String get launcherDescription => '為此窗格選擇一個工作區，或建立新的工作區。';
	@override String get createWorkspace => '建立工作區';
}

// Path: worktrees
class Translations$worktrees$zh_TW extends Translations$worktrees$en {
	Translations$worktrees$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get scripts => '指令碼';
	@override String get emptyTitle => '找不到 worktree';
	@override String get emptyDescription => '建立 worktree 以隔離功能開發或代理執行作業。';
	@override String opened({required Object branch}) => '已開啟 worktree：${branch}';
	@override String get created => '已建立 worktree';
	@override String get removed => '已移除 worktree';
	@override String merged({required Object branch}) => '已將 worktree 合併至 ${branch}';
	@override String get scriptsSaved => '指令碼設定已儲存';
	@override String get setupLabel => '設定：';
	@override String get serverLabel => '伺服器：';
	@override String get runRunning => '執行中';
	@override String runRunningWithPort({required Object port}) => '執行中 :${port}';
	@override String get runButton => '執行';
	@override String get stopButton => '停止';
	@override String get mainBadge => 'main';
	@override String headDetachedAt({required Object sha}) => 'HEAD 分離於 ${sha}';
	@override String get branchHint => '新分支名稱（例如 feature/login）';
	@override String branchingOff({required Object branch}) => '從 ${branch} 建立分支';
	@override String mergeTitle({required Object branch}) => '合併 ${branch}';
	@override String mergeDescription({required Object branch}) => '將變更合併至 ${branch}。';
	@override String get squashDescription => '將所有提交合併為單一提交';
	@override String get cleanupDescription => '合併後移除 worktree 並刪除分支';
	@override String removeTitle({required Object branch}) => '移除 worktree ${branch}？';
	@override String get removeDescription => '這會刪除 worktree 資料夾。連結的專案將被封存。';
	@override String dirtyWarning({required Object count}) => '警告：此 worktree 有 ${count} 個未提交的變更將會遺失。';
	@override String get forceRemoveLabel => '強制移除（捨棄變更）';
	@override String get deleteBranchLabel => '同時刪除分支';
	@override String get setupHint => '設定指令（例如 npm install）';
	@override String get runHint => '執行指令（例如 npm run dev）';
	@override String get portHint => '執行連接埠（選填，例如 3000）';
	@override String get unknownSha => '未知';
	@override String get baseBranchFallback => '基礎分支';
	@override late final Translations$worktrees$runtimeStatus$zh_TW runtimeStatus = Translations$worktrees$runtimeStatus$zh_TW.internal(_root);
}

// Path: browserUse
class Translations$browserUse$zh_TW extends Translations$browserUse$en {
	Translations$browserUse$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$browserUse$sessionStatus$zh_TW sessionStatus = Translations$browserUse$sessionStatus$zh_TW.internal(_root);
}

// Path: orchestrator
class Translations$orchestrator$zh_TW extends Translations$orchestrator$en {
	Translations$orchestrator$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String stepFallback({required Object n}) => '步驟 ${n}';
}

// Path: miniOrchestrator
class Translations$miniOrchestrator$zh_TW extends Translations$miniOrchestrator$en {
	Translations$miniOrchestrator$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$miniOrchestrator$taskTypes$zh_TW taskTypes = Translations$miniOrchestrator$taskTypes$zh_TW.internal(_root);
	@override late final Translations$miniOrchestrator$roles$zh_TW roles = Translations$miniOrchestrator$roles$zh_TW.internal(_root);
}

// Path: auth.login
class Translations$auth$login$zh_TW extends Translations$auth$login$en {
	Translations$auth$login$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '歡迎回來';
	@override String get description => '登入您的 DDAgent 帳戶';
	@override String get username => '使用者名稱';
	@override String get password => '密碼';
	@override String get submit => '登入';
	@override String get loading => '登入中...';
	@override late final Translations$auth$login$errors$zh_TW errors = Translations$auth$login$errors$zh_TW.internal(_root);
	@override late final Translations$auth$login$placeholders$zh_TW placeholders = Translations$auth$login$placeholders$zh_TW.internal(_root);
}

// Path: auth.register
class Translations$auth$register$zh_TW extends Translations$auth$register$en {
	Translations$auth$register$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '建立帳戶';
	@override String get username => '使用者名稱';
	@override String get password => '密碼';
	@override String get confirmPassword => '確認密碼';
	@override String get submit => '建立帳戶';
	@override String get loading => '建立帳戶中...';
	@override late final Translations$auth$register$errors$zh_TW errors = Translations$auth$register$errors$zh_TW.internal(_root);
}

// Path: auth.logout
class Translations$auth$logout$zh_TW extends Translations$auth$logout$en {
	Translations$auth$logout$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '登出';
	@override String get confirm => '確定要登出嗎？';
	@override String get button => '登出';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$zh_TW extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get copy => '複製';
	@override String get copied => '已複製';
	@override String get copyCode => '複製程式碼';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$zh_TW extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get copy => '複製訊息';
	@override String get copied => '訊息已複製';
	@override String get failed => '複製失敗';
	@override String get selectFormat => '選擇複製格式';
	@override String get copyAsMarkdown => '複製為 Markdown';
	@override String get copyAsText => '複製為純文字';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$zh_TW extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => '錯誤';
	@override String get tool => '工具';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
	@override String get orchestrator => '自動';
}

// Path: chat.orchestrator
class Translations$chat$orchestrator$zh_TW extends Translations$chat$orchestrator$en {
	Translations$chat$orchestrator$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$orchestrator$routing$zh_TW routing = Translations$chat$orchestrator$routing$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$plan$zh_TW plan = Translations$chat$orchestrator$plan$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$decision$zh_TW decision = Translations$chat$orchestrator$decision$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$delegation$zh_TW delegation = Translations$chat$orchestrator$delegation$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$summary$zh_TW summary = Translations$chat$orchestrator$summary$zh_TW.internal(_root);
	@override String get backToParent => '返回編排';
	@override late final Translations$chat$orchestrator$taskmaster$zh_TW taskmaster = Translations$chat$orchestrator$taskmaster$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$gate$zh_TW gate = Translations$chat$orchestrator$gate$zh_TW.internal(_root);
}

// Path: chat.tools
class Translations$chat$tools$zh_TW extends Translations$chat$tools$en {
	Translations$chat$tools$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get settings => '工具設定';
	@override String get error => '工具錯誤';
	@override String get result => '工具結果';
	@override String get viewParams => '查看輸入參數';
	@override String get viewRawParams => '查看原始參數';
	@override String get viewDiff => '查看編輯差異';
	@override String get creatingFile => '建立新檔案：';
	@override String get updatingTodo => '更新待辦事項';
	@override String get read => '讀取';
	@override String get readFile => '讀取檔案';
	@override String get updateTodo => '更新待辦清單';
	@override String get readTodo => '讀取待辦清單';
	@override String get searchResults => '結果';
	@override String get todoReadLabel => 'TodoRead 讀取清單';
}

// Path: chat.search
class Translations$chat$search$zh_TW extends Translations$chat$search$en {
	Translations$chat$search$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '找到 ${count} 個${type}';
	@override String get file => '檔案';
	@override String get files => '檔案';
	@override String get pattern => '模式：';
	@override String get kIn => '在：';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$zh_TW extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get updated => '檔案更新成功';
	@override String get created => '檔案建立成功';
	@override String get written => '檔案寫入成功';
	@override String get diff => '差異';
	@override String get newFile => '新檔案';
	@override String get viewContent => '查看檔案內容';
	@override String viewFullOutput({required Object count}) => '查看完整輸出（${count} 個字元）';
	@override String get contentDisplayed => '檔案內容顯示在上方的差異檢視中';
}

// Path: chat.interactive
class Translations$chat$interactive$zh_TW extends Translations$chat$interactive$en {
	Translations$chat$interactive$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '互動式提示';
	@override String get waiting => '等待您在 CLI 中回應';
	@override String get instruction => '請在 Claude 執行的終端機中選擇一個選項。';
	@override String selectedOption({required Object number}) => '✓ Claude 選擇了選項 ${number}';
	@override String get instructionDetail => '在 CLI 中，您可以使用方向鍵或輸入數字來互動式地選擇此選項。';
}

// Path: chat.thinking
class Translations$chat$thinking$zh_TW extends Translations$chat$thinking$en {
	Translations$chat$thinking$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '思考中...';
	@override String get emoji => '💭 思考中...';
	@override String get thoughtFewSeconds => '思考了幾秒鐘';
}

// Path: chat.json
class Translations$chat$json$zh_TW extends Translations$chat$json$en {
	Translations$chat$json$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSON 回應';
}

// Path: chat.permissions
class Translations$chat$permissions$zh_TW extends Translations$chat$permissions$en {
	Translations$chat$permissions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => '授予 ${tool} 權限';
	@override String get added => '權限已新增';
	@override String addTo({required Object entry}) => '將 ${entry} 加入允許的工具。';
	@override String get retry => '權限已儲存。重試請求以使用該工具。';
	@override String get error => '無法更新權限。請重試。';
	@override String get openSettings => '開啟設定';
	@override String get allow => '允許';
	@override String get always => '一律';
	@override String get editAndAllow => '編輯並允許';
	@override String get deny => '拒絕';
	@override String get reject => '拒絕';
	@override String allowAll({required Object count}) => '全部允許（${count}）';
	@override String get editInput => '編輯輸入';
	@override String get invalidJson => '無效的 JSON';
	@override String get allowWithChanges => '允許並修改';
	@override String get alwaysDeny => '一律拒絕';
	@override String get denyFeedbackTitle => '拒絕計畫';
	@override String get denyFeedbackHint => '需要代理修改什麼？（選填）';
	@override String get denyReasonTitle => '拒絕此操作';
	@override String get denyReasonHint => '告訴代理原因或應改做什麼（選填）';
	@override String get modeAppliesNextMessage => '新的權限模式將從下一則訊息開始生效。';
}

// Path: chat.todo
class Translations$chat$todo$zh_TW extends Translations$chat$todo$en {
	Translations$chat$todo$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get updated => '待辦清單已成功更新';
	@override String get current => '目前待辦清單';
}

// Path: chat.plan
class Translations$chat$plan$zh_TW extends Translations$chat$plan$en {
	Translations$chat$plan$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 查看實作計畫';
	@override String get title => '實作計畫';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$zh_TW extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Claude 使用限制已達到。您的限制將在 **${time} ${timezone}** - ${date} 重置';
}

// Path: chat.codex
class Translations$chat$codex$zh_TW extends Translations$chat$codex$en {
	Translations$chat$codex$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => '權限模式';
	@override late final Translations$chat$codex$modes$zh_TW modes = Translations$chat$codex$modes$zh_TW.internal(_root);
	@override late final Translations$chat$codex$descriptions$zh_TW descriptions = Translations$chat$codex$descriptions$zh_TW.internal(_root);
	@override String get technicalDetails => '技術細節';
}

// Path: chat.voice
class Translations$chat$voice$zh_TW extends Translations$chat$voice$en {
	Translations$chat$voice$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get autoRead => '朗讀回覆';
	@override String get autoReadOn => '朗讀回覆：開';
	@override String get autoReadOff => '朗讀回覆：關';
	@override String get autoReadVoice => '朗讀聲音';
	@override String get autoReadVoiceAuto => '自動聲音';
	@override String get autoReadPreview => '回覆將以此聲音朗讀。';
	@override String get speakMessage => '朗讀';
	@override String get stopSpeaking => '停止朗讀';
}

// Path: chat.input
class Translations$chat$input$zh_TW extends Translations$chat$input$en {
	Translations$chat$input$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => '輸入 / 叫用指令，@ 選取檔案，或向 ${provider} 提問...';
	@override String get placeholderDefault => '輸入您的訊息...';
	@override String get disabled => '輸入已停用';
	@override String get attachFiles => '附加檔案';
	@override String get attachFilesDesc => '上傳照片、檔案或文件';
	@override String get takePhoto => '拍攝照片';
	@override String get takePhotoDesc => '使用相機拍攝照片';
	@override String get moreTools => '更多工具';
	@override String get commandsDesc => '瀏覽快捷鍵與命令';
	@override String get clearInputDesc => '捨棄目前文字';
	@override String get attachImages => '附加圖片';
	@override String get send => '傳送';
	@override String get stop => '停止';
	@override late final Translations$chat$input$hintText$zh_TW hintText = Translations$chat$input$hintText$zh_TW.internal(_root);
	@override String get clickToChangeMode => '點擊變更權限模式';
	@override String get showAllCommands => '顯示所有指令';
	@override String get clearInput => '清空輸入';
	@override String get scrollToBottom => '捲動到底部';
	@override String get newMessage => '新訊息';
	@override String get newMessages => '新訊息';
	@override late final Translations$chat$input$queue$zh_TW queue = Translations$chat$input$queue$zh_TW.internal(_root);
	@override String get autoContinueTasks => '自動繼續';
	@override String get autoContinueTasksTooltip => '啟用後讓 Devin 自動繼續下一個 Task Master 任務';
	@override late final Translations$chat$input$offlineQueue$zh_TW offlineQueue = Translations$chat$input$offlineQueue$zh_TW.internal(_root);
	@override String get voice => '語音輸入';
	@override String get voiceStart => '口述訊息';
	@override String get voiceStop => '停止口述';
	@override String get pinFile => '將檔案釘選至上下文';
	@override String get voiceSettings => '語音設定（STT）';
	@override String cameraUnavailable({required Object error}) => '相機無法使用：${error}';
}

// Path: chat.composer
class Translations$chat$composer$zh_TW extends Translations$chat$composer$en {
	Translations$chat$composer$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => '工具與操作';
	@override String get toolsAndActionsDesc => '聊天輸入框的工具與控制項';
	@override String get reasoning => '推理中';
	@override String get model => '模型';
	@override String get effortDefault => '預設';
	@override String get loadingModels => '正在載入模型…';
	@override String get modelMenu => '選擇模型與推理強度';
	@override String permissionHeading({required Object provider}) => '應如何核准 ${provider} 的操作？';
	@override String get favorites => '收藏';
	@override String get account => '帳戶';
	@override String get accountMenu => '選擇帳戶';
	@override String get accountDefault => '預設帳戶';
	@override String get accountAuto => '自動（預設）';
	@override String get accountIsDefault => '預設';
	@override late final Translations$chat$composer$effortLevels$zh_TW effortLevels = Translations$chat$composer$effortLevels$zh_TW.internal(_root);
	@override String contextWindow({required Object size}) => '${size} 上下文';
	@override String get accountAutoShort => '自動';
	@override String get uploadNoRecords => '上傳未傳回任何記錄';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$zh_TW extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '選擇您的 AI 助手';
	@override String get description => '選擇一個提供者以開始新對話';
	@override String get selectModel => '選擇模型';
	@override String get workspace => '工作區';
	@override String get noWorkspace => '無';
	@override String get clickToChangeWorkspace => '點擊以更改工作區';
	@override String get chooseWorkspace => '選擇工作區';
	@override String get searchWorkspaces => '搜尋工作區...';
	@override String get noWorkspacesFound => '找不到工作區。';
	@override late final Translations$chat$providerSelection$providerInfo$zh_TW providerInfo = Translations$chat$providerSelection$providerInfo$zh_TW.internal(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$zh_TW readyPrompt = Translations$chat$providerSelection$readyPrompt$zh_TW.internal(_root);
	@override String get autoGroup => '自動';
	@override String get autoLabel => '自動（編排）';
	@override String get autoDescription => '將每個步驟分派給最適合且可用的提供者與模型';
	@override String get orchestrated => '已編排';
	@override String pressToSearch({required Object shortcut}) => '按 <kbd>${shortcut}</kbd> 搜尋工作階段、檔案和提交';
	@override String get all => '全部';
	@override String get free => '免費';
	@override String get noModelsFound => '找不到模型。';
	@override String get paid => '付費';
	@override String get searchModels => '搜尋模型...';
	@override String get addModel => '新增模型';
	@override String get chooseModel => '選擇模型';
	@override String get chooseModelDescription => '內建和自訂模型在同一清單中';
	@override String get clickToChange => '點擊以更改模型';
	@override String get favorites => '收藏';
	@override String get loadingModels => '正在載入模型…';
	@override String get manageModels => '管理模型';
	@override String get refresh => '重新整理模型';
}

// Path: chat.session
class Translations$chat$session$zh_TW extends Translations$chat$session$en {
	Translations$chat$session$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$zh_TW kContinue = Translations$chat$session$kContinue$zh_TW.internal(_root);
	@override late final Translations$chat$session$loading$zh_TW loading = Translations$chat$session$loading$zh_TW.internal(_root);
	@override late final Translations$chat$session$messages$zh_TW messages = Translations$chat$session$messages$zh_TW.internal(_root);
	@override String get deleteConfirm => '移除工作階段及其記錄。此操作無法復原。';
	@override String get finishRunBeforeWorkspaceChange => '變更工作區前請先完成執行';
	@override String get fallbackTitle => '工作階段';
}

// Path: chat.shell
class Translations$chat$shell$zh_TW extends Translations$chat$shell$en {
	Translations$chat$shell$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$zh_TW selectProject = Translations$chat$shell$selectProject$zh_TW.internal(_root);
	@override late final Translations$chat$shell$status$zh_TW status = Translations$chat$shell$status$zh_TW.internal(_root);
	@override late final Translations$chat$shell$actions$zh_TW actions = Translations$chat$shell$actions$zh_TW.internal(_root);
	@override String get loading => '正在載入終端機...';
	@override String get connecting => '正在連線到 Shell...';
	@override String get startSession => '啟動新的 Claude 工作階段';
	@override String resumeSession({required Object displayName}) => '恢復工作階段：${displayName}...';
	@override String runCommand({required Object projectName, required Object command}) => '在 ${projectName} 中執行 ${command}';
	@override String startCli({required Object projectName}) => '在 ${projectName} 中啟動 Claude CLI';
	@override String get defaultCommand => '指令';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$zh_TW extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$zh_TW actions = Translations$chat$claudeStatus$actions$zh_TW.internal(_root);
	@override late final Translations$chat$claudeStatus$state$zh_TW state = Translations$chat$claudeStatus$state$zh_TW.internal(_root);
	@override late final Translations$chat$claudeStatus$elapsed$zh_TW elapsed = Translations$chat$claudeStatus$elapsed$zh_TW.internal(_root);
	@override String get stop => '停止';
	@override String backgroundTasks({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個背景工作正在執行',
		other: '${count} 個背景工作正在執行',
	);
	@override late final Translations$chat$claudeStatus$controls$zh_TW controls = Translations$chat$claudeStatus$controls$zh_TW.internal(_root);
	@override late final Translations$chat$claudeStatus$providers$zh_TW providers = Translations$chat$claudeStatus$providers$zh_TW.internal(_root);
	@override String get backgroundTasksTitle => '正在背景執行';
	@override String get backgroundTaskUnnamed => '未命名的工作';
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$zh_TW extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => '選擇一個專案以開始與 ${provider} 聊天';
}

// Path: chat.tasks
class Translations$chat$tasks$zh_TW extends Translations$chat$tasks$en {
	Translations$chat$tasks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => '開始下一個任務';
}

// Path: chat.splitSession
class Translations$chat$splitSession$zh_TW extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get toggle => '分割工作階段';
	@override String get close => '關閉分割工作階段';
	@override String get selectSession => '選擇要比較的工作階段';
	@override String get noOtherSessions => '沒有其他可用的工作階段';
	@override String get newSessionOption => '+ 在分割檢視中新增工作階段';
	@override String currentProjectGroup({required Object name}) => '目前專案（${name}）';
	@override String get otherProjectsGroup => '其他專案';
	@override String get recentSessionsGroup => '最近的工作階段';
	@override String get startNewSession => '在分割檢視中開始新工作階段';
	@override String get selectFromList => '從現有工作階段清單中選擇';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$zh_TW extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '選擇工作階段';
	@override String get searchPlaceholder => '搜尋工作階段...';
	@override String get clearSearch => '清除搜尋';
	@override String get newChat => '+ 新聊天';
	@override String get archivedToggle => '已封存';
	@override String get changeSession => '變更工作階段';
	@override String get archivedLoading => '正在載入已封存的工作階段...';
	@override String get archivedError => '無法載入已封存的工作階段';
	@override String get archivedEmpty => '沒有已封存的工作階段';
	@override String get archivedProjectOnly => '工作區已封存 — 復原它以檢視其工作階段。';
	@override String get emptySearch => '沒有工作階段符合你的搜尋';
	@override String get restore => '復原';
	@override String get restoreSession => '復原工作階段';
	@override String get restoreProject => '復原工作區';
	@override String get restoreSessionFailed => '復原工作階段失敗。請重試。';
	@override String get restoreProjectFailed => '復原工作區失敗。請重試。';
	@override String get archiveFailed => '封存工作階段失敗。請重試。';
	@override String get deleteFailed => '刪除工作階段失敗。請重試。';
	@override String get running => '工作階段執行中';
	@override String get unread => '未讀 — 已完成並有新輸出';
	@override String get account => '帳戶';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$zh_TW extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get addChat => '新增聊天窗格';
	@override String get addBrowser => '新增瀏覽器窗格';
	@override String get addTerminal => '新增終端機窗格';
	@override String get addPreview => '新增預覽窗格';
	@override String get overview => '顯示所有窗格';
	@override String get exitFocusMode => '離開專注模式 (Ctrl+Shift+F)';
	@override String get focusMode => '專注模式 (Ctrl+Shift+F)';
	@override String get broadcast => '廣播至工作階段';
	@override String get addNotes => '新增共用筆記窗格';
	@override String get browseSessions => '開啟工作階段清單';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$zh_TW extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '分割窗格總覽';
	@override String count({required Object count}) => '${count} 個窗格';
	@override String get close => '關閉總覽';
	@override String get question => '問題 — 需要輸入';
	@override String get processing => '處理中';
	@override String get idle => '閒置';
	@override String get active => '使用中';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$zh_TW extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} 需要你的輸入';
	@override String get skip => '略過';
	@override String get other => '其他…';
	@override String get answerHint => '輸入你的回答…';
}

// Path: chat.attachments
class Translations$chat$attachments$zh_TW extends Translations$chat$attachments$en {
	Translations$chat$attachments$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => '下載失敗 — 點擊重試';
	@override String get fileAttachment => '檔案附件';
	@override String download({required Object name}) => '下載 ${name}';
	@override String get attachedFile => '附件';
	@override String downloaded({required Object name}) => '已下載 ${name}';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$zh_TW extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get creating => '正在建立快照…';
	@override String get revertChanges => '將檔案還原到上一個檢查點';
	@override String get undo => '復原檢查點';
	@override String get undoAiRun => '復原 AI 執行';
	@override String get undoing => '正在復原…';
	@override String get undone => '已復原';
	@override String get beforeAiTurn => 'AI 回合之前';
}

// Path: chat.common
class Translations$chat$common$zh_TW extends Translations$chat$common$en {
	Translations$chat$common$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get close => '關閉';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$zh_TW extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => '任務';
	@override String get saved => '已儲存';
	@override String get saving => '正在儲存...';
	@override String get taskShort => '任務';
	@override String get addToTask => '新增至 TaskMaster';
	@override String get added => '已新增至 TaskMaster';
	@override String get defaultTaskTitle => '來自聊天的任務';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$zh_TW extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get desc => '檢視工作階段權杖消耗';
	@override String get title => '權杖用量';
	@override String get notAvailable => '不適用';
	@override String tokensBadge({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '${count} 個 token',
	);
}

// Path: chat.tool
class Translations$chat$tool$zh_TW extends Translations$chat$tool$en {
	Translations$chat$tool$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '（暫無輸出 — 工具回傳了空結果）';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$zh_TW extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => '訂閱額度限制';
	@override String get noData => '此模型暫無訂閱資料';
	@override String get noSubscription => '無訂閱';
	@override String windowLineReset({required Object label, required Object percent, required Object time}) => '${label}：${percent}% · 重設於 ${time}';
	@override String windowRemaining({required Object percent}) => '距離重設還剩 ${percent}% 的時間視窗';
}

// Path: chat.broadcast
class Translations$chat$broadcast$zh_TW extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '廣播至工作階段';
	@override String get noSessions => '沒有可用的工作階段';
	@override String get placeholder => '要傳送給每個所選工作階段的訊息…';
	@override String partial({required Object count}) => '有 ${count} 個工作階段拒絕了此訊息';
	@override String sent({required Object count}) => '已排入 ${count} 個工作階段的佇列';
	@override String get selectAll => '全選';
	@override String get selectOrchestrators => '選擇編排器';
	@override String get orchestratorsOnly => '僅編排器';
	@override String get noOrchestrators => '沒有可用的編排器會話';
	@override String get sending => '正在傳送…';
	@override String send({required Object count}) => '傳送給 ${count} 個';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$zh_TW extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get processing => '處理中…';
	@override String get switchSession => '切換工作階段';
}

// Path: chat.export
class Translations$chat$export$zh_TW extends Translations$chat$export$en {
	Translations$chat$export$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => '工作階段 ${id}';
	@override String get pdfFailed => 'PDF 匯出失敗';
	@override String get transcriptDownloaded => '記錄已下載';
	@override String savedTo({required Object path}) => '已儲存 ${path}';
}

// Path: chat.commandResult
class Translations$chat$commandResult$zh_TW extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$zh_TW fallback = Translations$chat$commandResult$fallback$zh_TW.internal(_root);
	@override String get filterCommands => '篩選指令...';
	@override String searchModels({required Object provider}) => '搜尋 ${provider} 模型...';
}

// Path: chat.commands
class Translations$chat$commands$zh_TW extends Translations$chat$commands$en {
	Translations$chat$commands$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => '執行指令？';
	@override String get executionCancelled => '指令執行已取消';
	@override String get bashConfirmMessage => '此指令包含將被執行的 bash 指令。要繼續嗎？';
	@override String get proceed => '繼續';
}

// Path: chat.pinFile
class Translations$chat$pinFile$zh_TW extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '釘選檔案';
	@override String get pathHint => 'path/to/file.ext';
	@override String get action => '釘選';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$zh_TW extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String editTooltip({required Object name}) => '編輯 ${name}';
	@override String deleteTooltip({required Object name}) => '刪除 ${name}';
	@override String get enterNameAndId => '請同時輸入模型名稱與模型 ID。';
	@override String get idNoSpaces => '模型 ID 不能包含空格。';
	@override String get setAsDefault => '設為預設';
	@override String get defaultModel => '預設模型';
	@override String get title => '模型庫';
	@override String get subtitle => '新增提供者支援的模型 ID。內建模型維持鎖定。圓圈標示預設模型。';
	@override String get yourModels => '你的模型';
	@override String get yourModelsHint => '可編輯，儲存在 auth.db 中';
	@override String get emptyTitle => '尚無自訂模型';
	@override String get emptyHint => '透過表單新增後，它會出現在所有模型選擇器中。';
	@override String get builtInModels => '內建模型';
	@override String get builtInModelsHint => '由 DDAgent 維護，唯讀';
	@override String get editTitle => '編輯自訂模型';
	@override String get addTitle => '新增自訂模型';
	@override String idSentAsWritten({required Object provider}) => 'ID 會依原樣傳送給 ${provider}。';
	@override String get nameLabel => '模型名稱';
	@override String get nameHint => '例如 GPT-5.5 Pro';
	@override String get idLabel => '模型 ID';
	@override String get idHint => '例如 gpt-5.5-pro';
	@override String get idHelp => '請使用提供者 CLI 接受的確切識別碼。ID 不可包含空格。';
	@override String updatedNotice({required Object name}) => '已更新 ${name}。';
	@override String addedNotice({required Object name}) => '已新增 ${name}。';
	@override String deletedNotice({required Object name}) => '已刪除 ${name}。';
	@override String get saving => '正在儲存…';
	@override String get saveChanges => '儲存變更';
	@override String get deleteConfirm => '要從所有選擇器中刪除此模型嗎？';
	@override String get customBadge => '自訂';
}

// Path: chat.changes
class Translations$chat$changes$zh_TW extends Translations$chat$changes$en {
	Translations$chat$changes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get failedToLoad => '載入變更失敗';
	@override String get empty => '沒有檔案變更';
}

// Path: chat.message
class Translations$chat$message$zh_TW extends Translations$chat$message$en {
	Translations$chat$message$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => '壓縮摘要';
	@override String get resendHint => '從輸入框重新傳送';
	@override String get rawView => '原始檢視';
	@override String get runComplete => '執行完成';
	@override String get runStopped => '已停止';
	@override String runFailed({required Object code}) => '執行失敗（結束代碼 ${code}）';
	@override String get taskKilled => '已終止';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$zh_TW extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => '權限要求 · ${tool}';
	@override String get question => '問題';
	@override String get subagent => '子代理';
	@override String get viewersCannotApprove => '檢視者無法核准';
	@override late final Translations$chat$permissionRequest$recap$zh_TW recap = Translations$chat$permissionRequest$recap$zh_TW.internal(_root);
	@override String needsApproval({required Object tool}) => '${tool} 需要核准';
	@override String subagentNeedsApproval({required Object tool}) => '子代理：${tool} 需要核准';
	@override String moreQuestions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '還有 ${count} 個問題在等待',
	);
}

// Path: chat.commandDialog
class Translations$chat$commandDialog$zh_TW extends Translations$chat$commandDialog$en {
	Translations$chat$commandDialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandDialog$help$zh_TW help = Translations$chat$commandDialog$help$zh_TW.internal(_root);
	@override late final Translations$chat$commandDialog$models$zh_TW models = Translations$chat$commandDialog$models$zh_TW.internal(_root);
	@override late final Translations$chat$commandDialog$cost$zh_TW cost = Translations$chat$commandDialog$cost$zh_TW.internal(_root);
	@override late final Translations$chat$commandDialog$status$zh_TW status = Translations$chat$commandDialog$status$zh_TW.internal(_root);
	@override String get defaultEyebrow => '命令';
	@override String get defaultTitle => '命令結果';
	@override String get escHint => '按 Esc 關閉視窗。';
	@override String get unknown => '未知';
	@override String get noDescription => '沒有可用的說明。';
	@override String get noCommandsMatch => '沒有符合此篩選條件的命令。';
	@override late final Translations$chat$commandDialog$syntax$zh_TW syntax = Translations$chat$commandDialog$syntax$zh_TW.internal(_root);
	@override String get commandFinished => '命令已完成。';
}

// Path: chat.utilities
class Translations$chat$utilities$zh_TW extends Translations$chat$utilities$en {
	Translations$chat$utilities$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get tokenUsageUnavailable => '無法取得 token 用量';
	@override late final Translations$chat$utilities$tooltip$zh_TW tooltip = Translations$chat$utilities$tooltip$zh_TW.internal(_root);
	@override String get used => '已用';
	@override String get cacheWrite => '快取寫入';
	@override String get contextLabel => '上下文';
	@override String get usageUnsupported => '不支援用量統計';
	@override String get chatTranscript => '聊天記錄';
	@override String get you => '你：';
	@override String get providerAutoMini => '自動 (mini)';
}

// Path: chat.toolBlocks
class Translations$chat$toolBlocks$zh_TW extends Translations$chat$toolBlocks$en {
	Translations$chat$toolBlocks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String moreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '… 還有 ${count} 行',
	);
	@override late final Translations$chat$toolBlocks$status$zh_TW status = Translations$chat$toolBlocks$status$zh_TW.internal(_root);
	@override String get showLess => '收合';
	@override String get showMore => '顯示更多';
	@override String showMoreLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '再顯示 ${count} 行',
	);
	@override String get tools => '工具';
	@override String get planReview => '計畫審閱';
	@override String get planUpdate => '計畫更新';
	@override String get todoListUpdated => '待辦清單已更新';
	@override String get creatingTask => '正在建立任務';
	@override String get updatingTask => '正在更新';
	@override String get fetchingTask => '正在擷取';
	@override String get listingTasks => '正在列出任務';
	@override String get search => '搜尋';
	@override late final Translations$chat$toolBlocks$verbs$zh_TW verbs = Translations$chat$toolBlocks$verbs$zh_TW.internal(_root);
	@override String get subagent => '子代理';
	@override String toolCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '${count} 個工具',
	);
	@override String get result => '結果';
	@override String plusMore({required Object count}) => '+${count} 個';
	@override String get plan => '計畫';
	@override String questionProgress({required Object current, required Object total}) => '問題 ${current}/${total}';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '${count} 行',
	);
	@override String todoListItems({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '待辦清單（${count} 項）',
	);
	@override String tasksCompleted({required Object done, required Object total}) => '已完成 ${done}/${total}';
}

// Path: chat.commandMenu
class Translations$chat$commandMenu$zh_TW extends Translations$chat$commandMenu$en {
	Translations$chat$commandMenu$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get empty => '沒有可用的指令';
	@override late final Translations$chat$commandMenu$namespaces$zh_TW namespaces = Translations$chat$commandMenu$namespaces$zh_TW.internal(_root);
}

// Path: chat.mentionMenu
class Translations$chat$mentionMenu$zh_TW extends Translations$chat$mentionMenu$en {
	Translations$chat$mentionMenu$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$mentionMenu$kinds$zh_TW kinds = Translations$chat$mentionMenu$kinds$zh_TW.internal(_root);
	@override String taskTitle({required Object id}) => '任務 ${id}';
}

// Path: chat.subheader
class Translations$chat$subheader$zh_TW extends Translations$chat$subheader$en {
	Translations$chat$subheader$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String contextTooltip({required Object used, required Object total, required Object percent}) => '上下文：${used} / ${total} 個 token · 已用 ${percent}%';
}

// Path: chat.transcript
class Translations$chat$transcript$zh_TW extends Translations$chat$transcript$en {
	Translations$chat$transcript$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get requestFailed => '請求失敗';
}

// Path: chat.review
class Translations$chat$review$zh_TW extends Translations$chat$review$en {
	Translations$chat$review$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get changedFiles => '已變更的檔案';
	@override String changedFilesCount({required Object count}) => '已變更的檔案（${count}）';
	@override String get subagent => '子代理';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$zh_TW extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get changes => '個變更';
	@override String get previousChange => '上一個變更';
	@override String get nextChange => '下一個變更';
	@override String get hideDiff => '隱藏差異醒目提示';
	@override String get showDiff => '顯示差異醒目提示';
	@override String get settings => '編輯器設定';
	@override String get collapse => '收合編輯器';
	@override String get expand => '展開編輯器到全寬';
	@override String get toggleDock => '切換檔案面板';
	@override String get diffMerge => '差異 / 合併';
	@override String get previewInBrowser => '在瀏覽器中預覽';
	@override String get reload => '從磁碟重新載入';
}

// Path: codeEditor.header
class Translations$codeEditor$header$zh_TW extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => '顯示變更';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$zh_TW extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get copyPath => '複製檔案路徑';
	@override String get pathCopied => '已複製檔案路徑';
	@override String get download => '下載檔案';
	@override String get save => '儲存';
	@override String get saving => '儲存中...';
	@override String get saved => '已儲存！';
	@override String get exitFullscreen => '離開全螢幕';
	@override String get fullscreen => '全螢幕';
	@override String get close => '關閉';
	@override String get previewMarkdown => '預覽 Markdown';
	@override String get editMarkdown => '編輯 Markdown';
	@override String get pinFile => '將檔案固定到上下文';
	@override String get unpinFile => '從上下文取消固定檔案';
	@override String get previewHtml => '在新分頁中開啟 HTML 預覽';
	@override String get retry => '重試';
	@override String get saveAll => '全部儲存';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$zh_TW extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get lines => '行數：';
	@override String get characters => '字元數：';
	@override String get shortcuts => '按 Ctrl+S 儲存 • Esc 關閉';
	@override String get plainText => '純文字';
	@override String lineCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '${count} 行',
	);
	@override String get modified => '已修改';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$zh_TW extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '二進位檔案';
	@override String message({required Object fileName}) => '檔案「${fileName}」無法在文字編輯器中顯示，因為它是二進位檔案。';
	@override String get cannotDisplayAsText => '無法以文字顯示';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$zh_TW extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入預覽...';
	@override String get error => '無法顯示此檔案。';
	@override String get openInNewTab => '在新分頁中開啟';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$zh_TW extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '媒體檔案';
	@override String get subtitle => '尚不支援音訊/視訊預覽';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$zh_TW extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… 還有 ${size}';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$zh_TW extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get minimap => '縮圖';
	@override String tabSize({required Object size}) => 'Tab 大小：${size}';
	@override String fontSizeDecrease({required Object size}) => '字型大小 −  （目前 ${size}）';
	@override String get fontSizeIncrease => '字型大小 +';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$zh_TW extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get noChanges => '沒有變更';
	@override String hunk({required Object number}) => '區塊 ${number}';
	@override String get close => '關閉差異';
	@override String get base => '基礎';
	@override String get current => '目前';
	@override String get applyMerge => '套用合併';
	@override String get deletedOnDisk => '已從磁碟刪除';
	@override String get untrackedWillBeDeleted => '此未追蹤的檔案將被刪除。';
	@override String restoreConfirm({required Object name}) => '將 ${name} 還原為已提交的狀態？';
	@override String get headVsWorkingCopy => 'HEAD 與工作副本';
	@override String get savedVsBuffer => '上次儲存與緩衝區（無 git）';
	@override String unchangedLines({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '${count} 行未變更',
	);
	@override String get revertToSaved => '還原為已儲存版本';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$zh_TW extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '未開啟任何檔案';
	@override String get hint => '從「檔案」分頁開啟檔案';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$zh_TW extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => '已儲存 ${name}';
	@override String get saveFailed => '儲存失敗';
	@override String get allSaved => '已全部儲存';
	@override String get someSavesFailed => '部分儲存失敗';
	@override String savedTo({required Object path}) => '已儲存至 ${path}';
	@override String get mergeApplied => '已套用合併 — 儲存以保留變更';
}

// Path: common.buttons
class Translations$common$buttons$zh_TW extends Translations$common$buttons$en {
	Translations$common$buttons$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get save => '儲存';
	@override String get cancel => '取消';
	@override String get delete => '刪除';
	@override String get create => '建立';
	@override String get edit => '編輯';
	@override String get close => '關閉';
	@override String get confirm => '確認';
	@override String get submit => '送出';
	@override String get retry => '重試';
	@override String get refresh => '重新整理';
	@override String get search => '搜尋';
	@override String get clear => '清除';
	@override String get copy => '複製';
	@override String get download => '下載';
	@override String get upload => '上傳';
	@override String get browse => '瀏覽';
	@override String get update => '更新';
	@override String get openDiagram => '開啟圖表';
}

// Path: common.tabs
class Translations$common$tabs$zh_TW extends Translations$common$tabs$en {
	Translations$common$tabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get chat => '聊天';
	@override String get shell => '終端機';
	@override String get files => '檔案';
	@override String get git => '版本控制';
	@override String get tasks => '任務';
	@override String get board => '看板';
	@override String get browser => '瀏覽器';
	@override String get computer => '電腦';
	@override String get usage => 'AI Control';
}

// Path: common.quota
class Translations$common$quota$zh_TW extends Translations$common$quota$en {
	Translations$common$quota$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$zh_TW section = Translations$common$quota$section$zh_TW.internal(_root);
	@override late final Translations$common$quota$filter$zh_TW filter = Translations$common$quota$filter$zh_TW.internal(_root);
	@override late final Translations$common$quota$period$zh_TW period = Translations$common$quota$period$zh_TW.internal(_root);
	@override late final Translations$common$quota$group$zh_TW group = Translations$common$quota$group$zh_TW.internal(_root);
	@override late final Translations$common$quota$metric$zh_TW metric = Translations$common$quota$metric$zh_TW.internal(_root);
	@override late final Translations$common$quota$cost$zh_TW cost = Translations$common$quota$cost$zh_TW.internal(_root);
	@override late final Translations$common$quota$cost3$zh_TW cost3 = Translations$common$quota$cost3$zh_TW.internal(_root);
	@override late final Translations$common$quota$overview$zh_TW overview = Translations$common$quota$overview$zh_TW.internal(_root);
	@override late final Translations$common$quota$usage$zh_TW usage = Translations$common$quota$usage$zh_TW.internal(_root);
	@override late final Translations$common$quota$agents$zh_TW agents = Translations$common$quota$agents$zh_TW.internal(_root);
	@override late final Translations$common$quota$agentStatus$zh_TW agentStatus = Translations$common$quota$agentStatus$zh_TW.internal(_root);
	@override late final Translations$common$quota$alert$zh_TW alert = Translations$common$quota$alert$zh_TW.internal(_root);
	@override String get backToChat => '返回聊天';
	@override String get syncNow => '立即同步';
	@override String generatedAt({required Object value}) => '更新於 ${value}';
	@override String get loading => '正在載入帳戶額度…';
	@override String remaining({required Object value}) => '剩餘 ${value}%';
	@override String resetsIn({required Object value}) => '${value} 後重置';
	@override String projected({required Object value}) => '按目前速度，此額度將在 ${value} 後耗盡';
	@override String syncedAgo({required Object value}) => '${value} 前已同步';
	@override String get refreshAccount => '重新整理帳戶';
	@override String get syncFailed => '同步失敗';
	@override String get history => '歷史';
	@override String historyPoints({required Object value}) => '已記錄 ${value} 筆讀數';
	@override String get historyEmpty => '尚無歷史記錄';
	@override String get noAgents => '未指派代理';
	@override String get noSubscription => '無訂閱';
	@override String get noSubscriptionHint => '提供者未回報此帳戶有有效方案。';
	@override late final Translations$common$quota$quality$zh_TW quality = Translations$common$quota$quality$zh_TW.internal(_root);
	@override late final Translations$common$quota$kpi$zh_TW kpi = Translations$common$quota$kpi$zh_TW.internal(_root);
	@override late final Translations$common$quota$empty$zh_TW empty = Translations$common$quota$empty$zh_TW.internal(_root);
	@override late final Translations$common$quota$settings$zh_TW settings = Translations$common$quota$settings$zh_TW.internal(_root);
	@override late final Translations$common$quota$range$zh_TW range = Translations$common$quota$range$zh_TW.internal(_root);
}

// Path: common.status
class Translations$common$status$zh_TW extends Translations$common$status$en {
	Translations$common$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '載入中...';
	@override String get success => '成功';
	@override String get error => '錯誤';
	@override String get failed => '失敗';
	@override String get pending => '待處理';
	@override String get completed => '已完成';
	@override String get inProgress => '進行中';
}

// Path: common.messages
class Translations$common$messages$zh_TW extends Translations$common$messages$en {
	Translations$common$messages$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => '儲存成功';
	@override String get deletedSuccessfully => '刪除成功';
	@override String get updatedSuccessfully => '更新成功';
	@override String get operationFailed => '操作失敗';
	@override String get networkError => '網路錯誤，請檢查您的連線。';
	@override String get unauthorized => '未授權，請登入。';
	@override String get notFound => '找不到';
	@override String get invalidInput => '輸入無效';
	@override String get requiredField => '此欄位為必填';
	@override String get unknownError => '發生未知錯誤';
	@override String get renameSessionFailed => '重新命名工作階段失敗。請重試。';
}

// Path: common.navigation
class Translations$common$navigation$zh_TW extends Translations$common$navigation$en {
	Translations$common$navigation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get settings => '設定';
	@override String get home => '首頁';
	@override String get back => '返回';
	@override String get next => '下一步';
	@override String get previous => '上一步';
	@override String get logout => '登出';
	@override String get backToChat => '返回聊天';
}

// Path: common.common
class Translations$common$common$zh_TW extends Translations$common$common$en {
	Translations$common$common$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get language => '語言';
	@override String get theme => '佈景主題';
	@override String get darkMode => '深色模式';
	@override String get lightMode => '淺色模式';
	@override String get name => '名稱';
	@override String get description => '描述';
	@override String get enabled => '已啟用';
	@override String get disabled => '已停用';
	@override String get optional => '選填';
	@override String get version => '版本';
	@override String get select => '選取';
	@override String get selectAll => '全選';
	@override String get deselectAll => '取消全選';
	@override String get done => '完成';
	@override String get failed => '失敗';
}

// Path: common.time
class Translations$common$time$zh_TW extends Translations$common$time$en {
	Translations$common$time$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get justNow => '剛剛';
	@override String minutesAgo({required Object count}) => '${count} 分鐘前';
	@override String hoursAgo({required Object count}) => '${count} 小時前';
	@override String daysAgo({required Object count}) => '${count} 天前';
	@override String get yesterday => '昨天';
}

// Path: common.fileOperations
class Translations$common$fileOperations$zh_TW extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get newFile => '新增檔案';
	@override String get newFolder => '新增資料夾';
	@override String get rename => '重新命名';
	@override String get move => '移動';
	@override String get copyPath => '複製路徑';
	@override String get openInEditor => '在編輯器中開啟';
}

// Path: common.mainContent
class Translations$common$mainContent$zh_TW extends Translations$common$mainContent$en {
	Translations$common$mainContent$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入 DDAgent';
	@override String get settingUpWorkspace => '正在設定您的工作區...';
	@override String get chooseProject => '選擇您的專案';
	@override String get selectProjectDescription => '從側邊欄選擇一個專案以開始使用 Claude 進行程式開發。每個專案包含您的聊天紀錄和檔案歷史。';
	@override String get tip => '提示';
	@override String get createProjectMobile => '點擊上方的選單按鈕以存取專案';
	@override String get createProjectDesktop => '點擊側邊欄中的資料夾圖示以建立新專案';
	@override String get newSession => '新工作階段';
	@override String get untitledSession => '未命名工作階段';
	@override String get projectFiles => '專案檔案';
	@override String get focusMode => '專注模式 (Ctrl+Shift+F)';
	@override String get exitFocusMode => '離開專注模式 (Ctrl+Shift+F)';
	@override String get splitSession => '分割工作階段';
	@override String get closeSplitSession => '關閉分割工作階段';
	@override String get chooseWorkspace => '選擇工作區';
	@override String get chooseWorkspaceDescription => '為此聊天選擇一個工作區，或在設定中建立新工作區。';
	@override String get createWorkspace => '在設定中建立工作區';
	@override String get recentProjects => '最近專案';
}

// Path: common.fileTree
class Translations$common$fileTree$zh_TW extends Translations$common$fileTree$en {
	Translations$common$fileTree$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入檔案...';
	@override String get files => '檔案';
	@override String get simpleView => '簡易檢視';
	@override String get compactView => '精簡檢視';
	@override String get detailedView => '詳細檢視';
	@override String get searchPlaceholder => '搜尋檔案和資料夾...';
	@override String get searchContentPlaceholder => '在檔案中搜尋...';
	@override String get searchInFiles => '在檔案中搜尋';
	@override String get searchByName => '按名稱搜尋';
	@override String get clearSearch => '清除搜尋';
	@override String get name => '名稱';
	@override String get size => '大小';
	@override String get modified => '修改時間';
	@override String get permissions => '權限';
	@override String get noFilesFound => '找不到檔案';
	@override String get checkProjectPath => '請檢查專案路徑是否可存取';
	@override String get loadFailed => '無法載入檔案';
	@override String get noMatchesFound => '找不到符合項目';
	@override String get noSearchResults => '找不到符合項目';
	@override String get tryDifferentSearch => '嘗試不同的搜尋詞或清除搜尋';
	@override String get searchError => '搜尋失敗';
	@override String get searching => '正在搜尋...';
	@override String resultsTruncated({required Object count}) => '顯示前 ${count} 筆結果';
	@override String get justNow => '剛剛';
	@override String minAgo({required Object count}) => '${count} 分鐘前';
	@override String hoursAgo({required Object count}) => '${count} 小時前';
	@override String daysAgo({required Object count}) => '${count} 天前';
	@override String get newFile => '新增檔案 (Cmd+N)';
	@override String get newFolder => '新增資料夾 (Cmd+Shift+N)';
	@override String get refresh => '重新整理';
	@override String get collapseAll => '全部收合';
	@override late final Translations$common$fileTree$context$zh_TW context = Translations$common$fileTree$context$zh_TW.internal(_root);
	@override String get allWorkspaces => '所有工作區';
	@override late final Translations$common$fileTree$delete$zh_TW delete = Translations$common$fileTree$delete$zh_TW.internal(_root);
	@override String get dropToUpload => '拖放檔案以上傳';
	@override String dropToUploadTo({required Object folder}) => '拖放檔案以上傳到「${folder}」';
	@override String get noProject => '請先新增專案';
	@override String get noRecentFiles => '最近 7 天沒有檔案變更';
	@override String get showAllFiles => '顯示所有檔案';
	@override String get showAllFilesHint => '關閉最近篩選器以檢視全部。';
	@override String get showRecentOnly => '顯示最近 7 天變更的檔案';
	@override late final Translations$common$fileTree$toast$zh_TW toast = Translations$common$fileTree$toast$zh_TW.internal(_root);
	@override String get uploadComplete => '上傳完成';
	@override String get uploadFailed => '上傳失敗';
	@override String uploadFiles({required Object size}) => '上傳檔案（每個最大 ${size}）';
	@override String uploadToFolder({required Object folder}) => '上傳檔案到「${folder}」';
	@override String uploadedCount({required Object total, required Object label, required Object uploaded}) => '已上傳 ${total} ${label} 中的 ${uploaded} 個';
	@override String get uploadingFiles => '正在上傳檔案';
	@override late final Translations$common$fileTree$validation$zh_TW validation = Translations$common$fileTree$validation$zh_TW.internal(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$zh_TW extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '建立新專案';
	@override late final Translations$common$projectWizard$steps$zh_TW steps = Translations$common$projectWizard$steps$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$step1$zh_TW step1 = Translations$common$projectWizard$step1$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$step2$zh_TW step2 = Translations$common$projectWizard$step2$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$step3$zh_TW step3 = Translations$common$projectWizard$step3$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$buttons$zh_TW buttons = Translations$common$projectWizard$buttons$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$errors$zh_TW errors = Translations$common$projectWizard$errors$zh_TW.internal(_root);
}

// Path: common.notifications
class Translations$common$notifications$zh_TW extends Translations$common$notifications$en {
	Translations$common$notifications$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get genericTool => '工具';
	@override late final Translations$common$notifications$codes$zh_TW codes = Translations$common$notifications$codes$zh_TW.internal(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$zh_TW extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '有可用更新';
	@override String get newVersionReady => '新版本已準備就緒';
	@override String get currentVersion => '目前版本';
	@override String get latestVersion => '最新版本';
	@override String get whatsNew => '新功能：';
	@override String get viewFullRelease => '查看完整發行說明';
	@override String get updateProgress => '更新進度：';
	@override String get manualUpgrade => '手動升級：';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => '或點擊「立即更新」以自動執行更新。';
	@override String get updateCompleted => '更新成功完成！';
	@override String get restartServer => '請重新啟動伺服器以套用變更。';
	@override String get updateFailed => '更新失敗';
	@override late final Translations$common$versionUpdate$buttons$zh_TW buttons = Translations$common$versionUpdate$buttons$zh_TW.internal(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$zh_TW ariaLabels = Translations$common$versionUpdate$ariaLabels$zh_TW.internal(_root);
}

// Path: common.actions
class Translations$common$actions$zh_TW extends Translations$common$actions$en {
	Translations$common$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get retry => '重試';
	@override String get save => '儲存';
}

// Path: common.browserPane
class Translations$common$browserPane$zh_TW extends Translations$common$browserPane$en {
	Translations$common$browserPane$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get address => '位址';
	@override String get back => '上一頁';
	@override String get connecting => '正在連線瀏覽器…';
	@override String get connectionFailed => '瀏覽器連線失敗。';
	@override String couldNotLoad({required Object url}) => '無法載入 ${url}';
	@override String get disconnected => '瀏覽器檢視已中斷連線';
	@override String get enterUrl => '輸入 URL';
	@override String get forward => '下一頁';
	@override String get invalidUrl => '請輸入有效的 http(s) URL';
	@override String get noAuthToken => '沒有可用的驗證權杖。';
	@override String get openExternal => '在系統瀏覽器中開啟';
	@override String get reload => '重新載入';
	@override String get retry => '重試';
	@override String get stop => '停止';
}

// Path: common.browserUse
class Translations$common$browserUse$zh_TW extends Translations$common$browserUse$en {
	Translations$common$browserUse$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} 個使用中';
	@override String get cancel => '取消';
	@override String get close => '關閉';
	@override String get delete => '刪除';
	@override String deleteDesc({required Object name}) => '${name} 將被永久刪除。';
	@override String get deleteSession => '刪除工作階段';
	@override String get deleteTitle => '刪除瀏覽器工作階段？';
	@override late final Translations$common$browserUse$empty$zh_TW empty = Translations$common$browserUse$empty$zh_TW.internal(_root);
	@override String get emptyStatus => '空';
	@override late final Translations$common$browserUse$errors$zh_TW errors = Translations$common$browserUse$errors$zh_TW.internal(_root);
	@override String get fullscreen => '全螢幕';
	@override String get installRuntime => '安裝執行環境';
	@override String get installing => '正在安裝...';
	@override String get lastAction => '最後操作';
	@override String get nextSnapshot => '代理瀏覽器的下一個快照將顯示在這裡。';
	@override String get noPageLoaded => '未載入頁面';
	@override String get noSessions => '沒有代理瀏覽器工作階段。';
	@override String get none => '無';
	@override String get openSettings => '開啟 Browser 設定';
	@override String get profile => '設定檔';
	@override String get promptLabel => '提示詞';
	@override late final Translations$common$browserUse$prompts$zh_TW prompts = Translations$common$browserUse$prompts$zh_TW.internal(_root);
	@override String get refresh => '重新整理瀏覽器工作階段';
	@override late final Translations$common$browserUse$relative$zh_TW relative = Translations$common$browserUse$relative$zh_TW.internal(_root);
	@override late final Translations$common$browserUse$runtime$zh_TW runtime = Translations$common$browserUse$runtime$zh_TW.internal(_root);
	@override String get runtimeSetup => '需要設定執行環境';
	@override String get selected => '已選取';
	@override String get sessionFallback => '瀏覽器工作階段';
	@override String get sessionScreenshot => '瀏覽器工作階段截圖';
	@override String get sessions => '工作階段';
	@override String get status => '狀態';
	@override String get stop => '停止';
	@override String get stopSession => '停止工作階段';
	@override String get subtitle => '監控 AI 代理開啟的瀏覽器工作階段。';
	@override String get temporary => '臨時';
	@override String get thisSession => '此工作階段';
	@override String get title => '瀏覽器';
	@override String totalCount({required Object count}) => '共 ${count} 個';
	@override String updated({required Object time}) => '更新於 ${time}';
	@override String get waiting => '等待中';
	@override String get waitingForScreenshot => '等待截圖';
}

// Path: common.commandPalette
class Translations$common$commandPalette$zh_TW extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get backToAll => '返回全部';
	@override String get backspaceHint => '按 Backspace 返回';
	@override late final Translations$common$commandPalette$browseAll$zh_TW browseAll = Translations$common$commandPalette$browseAll$zh_TW.internal(_root);
	@override late final Translations$common$commandPalette$compare$zh_TW compare = Translations$common$commandPalette$compare$zh_TW.internal(_root);
	@override late final Translations$common$commandPalette$groups$zh_TW groups = Translations$common$commandPalette$groups$zh_TW.internal(_root);
	@override late final Translations$common$commandPalette$hints$zh_TW hints = Translations$common$commandPalette$hints$zh_TW.internal(_root);
	@override late final Translations$common$commandPalette$items$zh_TW items = Translations$common$commandPalette$items$zh_TW.internal(_root);
	@override late final Translations$common$commandPalette$nav$zh_TW nav = Translations$common$commandPalette$nav$zh_TW.internal(_root);
	@override String get noResults => '沒有結果。';
	@override late final Translations$common$commandPalette$pages$zh_TW pages = Translations$common$commandPalette$pages$zh_TW.internal(_root);
	@override String get placeholder => '輸入以搜尋任何內容…';
	@override String searchPagePlaceholder({required Object page}) => '搜尋 ${page}…';
	@override String get title => '命令面板';
}

// Path: common.gitPanel
class Translations$common$gitPanel$zh_TW extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '領先 ${count}';
	@override String get aheadLabel => '領先';
	@override String get aiSuggest => 'AI 建議';
	@override String get aiSuggestTitle => '用 AI 產生提交訊息';
	@override String get all => '全部';
	@override String get allStaged => '所有變更已暫存';
	@override String behind({required Object count}) => '落後 ${count}';
	@override String get behindLabel => '落後';
	@override late final Translations$common$gitPanel$branches$zh_TW branches = Translations$common$gitPanel$branches$zh_TW.internal(_root);
	@override String get cancel => '取消';
	@override String changesCount({required Object count}) => '變更（${count}）';
	@override String get clearSearch => '清除搜尋';
	@override String get collapseDiff => '摺疊差異';
	@override String get commit => '提交';
	@override String get commitChanges => '提交變更';
	@override String commitFiles({required Object count}) => '提交 ${count} 個檔案';
	@override String get committing => '正在提交...';
	@override late final Translations$common$gitPanel$confirmActions$zh_TW confirmActions = Translations$common$gitPanel$confirmActions$zh_TW.internal(_root);
	@override String confirmCommit({required Object message, required Object count}) => '以訊息「${message}」提交 ${count} 個檔案？';
	@override String confirmDeleteFile({required Object file}) => '刪除未追蹤的檔案「${file}」？此操作無法復原。';
	@override String confirmDiscardFile({required Object file}) => '捨棄對「${file}」的所有變更？此操作無法復原。';
	@override String confirmPublish({required Object branch, required Object remote}) => '將分支「${branch}」發布到 ${remote}？';
	@override String confirmPull({required Object remote, required Object count}) => '從 ${remote} 拉取 ${count} 個提交？';
	@override String confirmPush({required Object count, required Object remote}) => '推送 ${count} 個提交到 ${remote}？';
	@override String get confirmRevert => '還原最新的本機提交？這會移除提交但保留其變更為暫存狀態。';
	@override late final Translations$common$gitPanel$confirmTitles$zh_TW confirmTitles = Translations$common$gitPanel$confirmTitles$zh_TW.internal(_root);
	@override String get createBranch => '建立新分支';
	@override String get creating => '正在建立...';
	@override String get delete => '刪除';
	@override String get deleteUntracked => '刪除未追蹤的檔案';
	@override String get deselectAll => '取消全選';
	@override String get discard => '捨棄';
	@override String get discardChanges => '捨棄變更';
	@override String get dismiss => '關閉';
	@override String get dismissError => '關閉錯誤';
	@override late final Translations$common$gitPanel$errors$zh_TW errors = Translations$common$gitPanel$errors$zh_TW.internal(_root);
	@override String get expandDiff => '展開差異';
	@override String get fetch => '擷取';
	@override String fetchTitle({required Object remote}) => '從 ${remote} 擷取';
	@override String get fetching => '正在擷取…';
	@override String filesSelected({required Object count}) => '已選取 ${count} 個檔案';
	@override String get generating => '正在產生...';
	@override late final Translations$common$gitPanel$history$zh_TW history = Translations$common$gitPanel$history$zh_TW.internal(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$zh_TW mergeWorktree = Translations$common$gitPanel$mergeWorktree$zh_TW.internal(_root);
	@override String get merging => '正在合併...';
	@override String get messagePlaceholder => '訊息（Ctrl+Enter 提交）';
	@override late final Translations$common$gitPanel$newBranch$zh_TW newBranch = Translations$common$gitPanel$newBranch$zh_TW.internal(_root);
	@override late final Translations$common$gitPanel$newWorktree$zh_TW newWorktree = Translations$common$gitPanel$newWorktree$zh_TW.internal(_root);
	@override String get noChanges => '未偵測到變更';
	@override String get noChangesToCommit => '沒有可提交的變更';
	@override late final Translations$common$gitPanel$noCommits$zh_TW noCommits = Translations$common$gitPanel$noCommits$zh_TW.internal(_root);
	@override String get noMatchingBranches => '沒有符合的分支';
	@override late final Translations$common$gitPanel$noRepo$zh_TW noRepo = Translations$common$gitPanel$noRepo$zh_TW.internal(_root);
	@override String get noStagedFiles => '沒有暫存的檔案';
	@override String get none => '無';
	@override String nothingToPush({required Object remote}) => '沒有可推送到 ${remote} 的內容';
	@override String get openFile => '點擊開啟檔案';
	@override String get publish => '發布';
	@override String publishTitle({required Object branch, required Object remote}) => '將「${branch}」發布到 ${remote}';
	@override String get publishing => '正在發布…';
	@override String get pull => '拉取';
	@override String pullCount({required Object count}) => '拉取 ${count}';
	@override String pullTitle({required Object remote, required Object count}) => '從 ${remote} 拉取 ${count}';
	@override String get pulling => '正在拉取…';
	@override String get push => '推送';
	@override String pushCount({required Object count}) => '推送 ${count}';
	@override String pushTitle({required Object count, required Object remote}) => '推送 ${count} 到 ${remote}';
	@override String get pushing => '正在推送…';
	@override String get recentCommits => '最近提交';
	@override String get refresh => '重新整理 git 狀態';
	@override String get remove => '移除';
	@override late final Translations$common$gitPanel$removeWorktree$zh_TW removeWorktree = Translations$common$gitPanel$removeWorktree$zh_TW.internal(_root);
	@override String get removing => '正在移除...';
	@override String get revertLatest => '還原最新本機提交';
	@override String get scroll => '捲動';
	@override String get searchBranches => '搜尋分支...';
	@override String get selectAll => '全選';
	@override String get selectProject => '選擇專案以檢視原始碼管理';
	@override String selectedOf({required Object total, required Object selected}) => '已選取 ${total} 個檔案中的 ${selected} 個';
	@override String selectedOfMobile({required Object total, required Object selected}) => '已選取 ${total} 中的 ${selected} 個';
	@override String get sideBySide => '並排';
	@override String get stageAll => '全部暫存';
	@override String get stageHunk => '暫存此區塊';
	@override String staged({required Object count}) => '已暫存（${count}）';
	@override late final Translations$common$gitPanel$status$zh_TW status = Translations$common$gitPanel$status$zh_TW.internal(_root);
	@override String get statusGuide => '檔案狀態指南';
	@override String get switchScroll => '切換到水平捲動';
	@override String get switchSplit => '切換到並排檢視';
	@override String get switchUnified => '切換到統一檢視';
	@override String get switchWrap => '切換到文字換行';
	@override String get unified => '統一';
	@override String get unstageAll => '全部取消暫存';
	@override String get unstageHunk => '取消暫存此區塊';
	@override String get upToDate => '已是最新';
	@override String upToDateWith({required Object remote}) => '與 ${remote} 同步';
	@override String get viewAll => '檢視全部';
	@override String get viewsAria => '原始碼管理檢視';
	@override late final Translations$common$gitPanel$worktrees$zh_TW worktrees = Translations$common$gitPanel$worktrees$zh_TW.internal(_root);
	@override String get wrap => '換行';
	@override late final Translations$common$gitPanel$tabs$zh_TW tabs = Translations$common$gitPanel$tabs$zh_TW.internal(_root);
	@override String get save => '儲存';
	@override late final Translations$common$gitPanel$worktreeScripts$zh_TW worktreeScripts = Translations$common$gitPanel$worktreeScripts$zh_TW.internal(_root);
}

// Path: common.sessions
class Translations$common$sessions$zh_TW extends Translations$common$sessions$en {
	Translations$common$sessions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get renameSession => '重新命名工作階段';
}

// Path: common.projects
class Translations$common$projects$zh_TW extends Translations$common$projects$en {
	Translations$common$projects$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get newSession => '新工作階段';
}

// Path: common.sharedNotes
class Translations$common$sharedNotes$zh_TW extends Translations$common$sharedNotes$en {
	Translations$common$sharedNotes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '共用記憶 — 會注入此專案的每個工作階段';
	@override String get save => '儲存';
	@override String get saving => '正在儲存…';
	@override String get noProject => '請選擇工作區以編輯其共用上下文';
	@override String get placeholder => '# 共用上下文\n每個代理都該知道的慣例、決策與參考資訊…';
}

// Path: common.codeBlock
class Translations$common$codeBlock$zh_TW extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => '自動換行';
	@override String get noWrap => '不換行';
}

// Path: common.update
class Translations$common$update$zh_TW extends Translations$common$update$en {
	Translations$common$update$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => '有可用更新 · v${version}';
	@override String confirm({required Object version}) => '要更新至 v${version} 嗎？伺服器會自行更新並重新啟動 — 進行中的工作階段將被中斷。';
	@override String get downloading => '正在下載並套用更新…';
	@override String get restarting => '正在重新啟動伺服器 — 這需要一點時間…';
	@override String done({required Object version}) => '已更新至 v${version}。請重新載入應用程式以載入新版本。';
	@override String get manualRestart => '更新已套用，但伺服器未自行重新啟動 — 請手動重新啟動以完成。';
	@override String get failed => '更新失敗。';
	@override String get failedTitle => '更新失敗';
	@override String appConfirm({required Object version}) => '要在此裝置上安裝 DDAgent v${version} 嗎？首次安裝時 Android 會要求允許從 DDAgent 安裝應用程式。';
	@override String get appPermission => '請為 DDAgent 允許「安裝未知應用程式」，然後再次點選更新。';
	@override String get chooseTitle => '有可用的更新';
	@override String get targetApp => '此應用程式';
	@override String get targetWeb => 'Web 介面';
	@override String get targetServer => '伺服器';
	@override String get updateApp => '更新應用程式';
	@override String get updateWeb => '更新 Web 介面';
	@override String get updateServer => '更新伺服器';
	@override String webConfirm({required Object version}) => '要將 Web 介面更新到 v${version} 嗎？更新後頁面會重新載入。';
	@override String webDone({required Object version}) => 'Web 介面已更新到 v${version} — 正在重新載入…';
	@override String localServerConfirm({required Object version}) => '要將此裝置上的本機伺服器更新到 v${version} 嗎？進行中的工作階段會被中斷。';
	@override String get localServerUpdating => '正在下載並啟動本機伺服器…';
	@override String serverDone({required Object version}) => '伺服器正在執行 v${version}。';
	@override String staged({required Object version}) => '已下載更新 v${version} — 請重新啟動伺服器以完成安裝。';
	@override String get upToDate => '伺服器已是最新版本。';
	@override String webHostFailed({required Object message}) => '伺服器已更新，但其 Web 介面沒有更新：${message}';
}

// Path: common.appShell
class Translations$common$appShell$zh_TW extends Translations$common$appShell$en {
	Translations$common$appShell$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String panelActive({required Object count}) => '面板 · ${count} 個執行中';
}

// Path: common.errors
class Translations$common$errors$zh_TW extends Translations$common$errors$en {
	Translations$common$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get forbidden => '存取遭拒';
}

// Path: settings.changelog
class Translations$settings$changelog$zh_TW extends Translations$settings$changelog$en {
	Translations$settings$changelog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '更新日誌';
	@override String get loading => '載入中…';
	@override String get empty => '沒有可顯示的版本';
	@override String get current => '目前';
	@override String get kNew => '新';
}

// Path: settings.server
class Translations$settings$server$zh_TW extends Translations$settings$server$en {
	Translations$settings$server$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '伺服器';
	@override String get description => '重新啟動 DDAgent 處理程序 — 適用於套用更新或從卡住狀態復原。';
	@override String get restart => '重新啟動';
	@override String get restartConfirm => '確定要重新啟動 DDAgent 伺服器?進行中的工作階段將被中斷。';
	@override String get restarting => '正在重新啟動… 伺服器恢復後頁面將自動重新整理。';
	@override String get restartFailed => '重新啟動失敗';
	@override String get unsupported => '僅當伺服器在服務管理員下執行時才可重新啟動。';
	@override String get ok => '確定';
	@override String get restartTitle => '正在重新啟動伺服器';
	@override String get restartRequesting => '正在要求伺服器重新啟動…';
	@override String restartWaiting({required Object seconds}) => '正在等待伺服器恢復…（${seconds} 秒）';
	@override String restartBack({required Object version}) => '伺服器已恢復 — 版本 ${version}。';
	@override String get restartReloading => '正在重新載入頁面…';
	@override String restartTimeout({required Object seconds}) => '伺服器未在 ${seconds} 秒內恢復。請檢查服務記錄檔（/tmp/ddagent.log）或手動重新啟動。';
}

// Path: settings.updates
class Translations$settings$updates$zh_TW extends Translations$settings$updates$en {
	Translations$settings$updates$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '更新';
	@override String get description => '在 GitHub 上檢查更新的桌面版本。新版本會自動下載並在退出時安裝。';
	@override String get descriptionMobile => '在 GitHub 上檢查此應用程式是否有較新的版本。更新會由裝置的系統安裝程式安裝。';
	@override String get descriptionServer => '在 GitHub 上檢查是否有較新的 DDAgent 版本。已連線的伺服器可自行更新 — 重新啟動期間，進行中的工作階段會中斷。';
	@override String get check => '檢查更新';
	@override String get checking => '正在檢查…';
	@override String upToDate({required Object version}) => '已是最新版本（v${version}）。';
	@override String available({required Object version}) => '發現更新 v${version} — 正在背景下載；退出 DDAgent 時自動安裝。';
	@override String appAvailable({required Object version}) => '有可用的應用程式更新 v${version} — 點選「更新」即可在此裝置上安裝。';
	@override String downloaded({required Object version}) => '更新 v${version} 已下載 — 退出並重新啟動 DDAgent 即可安裝。';
	@override String get unavailable => '更新檢查僅在打包的桌面版本中可用。';
	@override String error({required Object message}) => '更新檢查失敗：${message}';
	@override String get errorGeneric => '更新檢查失敗。';
	@override String versionLine({required Object installed, required Object latest}) => 'v${installed} · 最新 v${latest}';
	@override String current({required Object version}) => 'v${version} — 已是最新';
	@override String webNotHosted({required Object version}) => '此 Web 介面另外託管——請以發行版中的 ddagent-flutter-web-v${version}.zip 取代其檔案。';
	@override String get serverCannotUpdate => '此伺服器無法在這裡自行更新——請用 install.sh 或發行版的 tarball 重新安裝。';
}

// Path: settings.tabs
class Translations$settings$tabs$zh_TW extends Translations$settings$tabs$en {
	Translations$settings$tabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get account => '帳戶';
	@override String get permissions => '權限';
	@override String get mcpServers => 'MCP 伺服器';
	@override String get skills => '技能';
	@override String get appearance => '外觀';
}

// Path: settings.account
class Translations$settings$account$zh_TW extends Translations$settings$account$en {
	Translations$settings$account$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '帳戶';
	@override String get language => '語言';
	@override String get languageLabel => '顯示語言';
	@override String get languageDescription => '選擇您偏好的介面語言';
	@override String get username => '使用者名稱';
	@override String get email => '電子郵件';
	@override String get profile => '個人檔案';
	@override String get changePassword => '變更密碼';
}

// Path: settings.mcp
class Translations$settings$mcp$zh_TW extends Translations$settings$mcp$en {
	Translations$settings$mcp$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP 伺服器';
	@override String get addServer => '新增伺服器';
	@override String get editServer => '編輯伺服器';
	@override String get deleteServer => '刪除伺服器';
	@override String get serverName => '伺服器名稱';
	@override String get serverType => '伺服器類型';
	@override String get config => '設定';
	@override String get testConnection => '測試連線';
	@override String get status => '狀態';
	@override String get connected => '已連線';
	@override String get disconnected => '未連線';
	@override late final Translations$settings$mcp$scope$zh_TW scope = Translations$settings$mcp$scope$zh_TW.internal(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$zh_TW extends Translations$settings$appearance$en {
	Translations$settings$appearance$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '外觀';
	@override String get theme => '佈景主題';
	@override String get codeEditor => '程式碼編輯器';
	@override String get editorTheme => '編輯器佈景主題';
	@override String get wordWrap => '自動換行';
	@override String get showMinimap => '顯示縮圖';
	@override String get lineNumbers => '行號';
	@override String get fontSize => '字型大小';
	@override late final Translations$settings$appearance$themeModes$zh_TW themeModes = Translations$settings$appearance$themeModes$zh_TW.internal(_root);
}

// Path: settings.actions
class Translations$settings$actions$zh_TW extends Translations$settings$actions$en {
	Translations$settings$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => '儲存變更';
	@override String get resetToDefaults => '重設為預設值';
	@override String get cancelChanges => '取消變更';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$zh_TW extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '快速設定';
	@override late final Translations$settings$quickSettings$sections$zh_TW sections = Translations$settings$quickSettings$sections$zh_TW.internal(_root);
	@override String get darkMode => '深色模式';
	@override String get showRawParameters => '顯示原始參數';
	@override String get showThinking => '顯示思考過程';
	@override String get sendByCtrlEnter => '使用 Ctrl+Enter 傳送';
	@override String get sendByCtrlEnterDescription => '啟用後，按 Ctrl+Enter 傳送訊息，而不是僅按 Enter。這對於使用輸入法的使用者可以避免意外傳送。';
	@override late final Translations$settings$quickSettings$dragHandle$zh_TW dragHandle = Translations$settings$quickSettings$dragHandle$zh_TW.internal(_root);
	@override String get sendWithCtrlEnter => '使用 Ctrl+Enter 傳送';
	@override String get enterSendsHint => '關閉時，按 Enter 傳送，按 Shift+Enter 換行。';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$zh_TW extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '終端機快速鍵';
	@override String get sectionKeys => '按鍵';
	@override String get sectionNavigation => '導覽';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => '向上箭頭';
	@override String get arrowDown => '向下箭頭';
	@override String get scrollDown => '捲動到底部';
	@override String get killTitle => '終止執行中的程序 (Ctrl+C)';
	@override late final Translations$settings$terminalShortcuts$handle$zh_TW handle = Translations$settings$terminalShortcuts$handle$zh_TW.internal(_root);
	@override String get paste => '貼上';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$zh_TW extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '設定';
	@override String get agents => '智慧代理';
	@override String get orchestration => '編排';
	@override String get miniOrchestration => '迷你編排';
	@override String get appearance => '外觀';
	@override String get workspaces => '工作區';
	@override String get git => 'Git';
	@override String get apiTokens => 'API 和權杖';
	@override String get models => '模型';
	@override String get tasks => '任務';
	@override String get browser => '瀏覽器';
	@override String get tools => '工具';
	@override String get notifications => '通知';
	@override String get about => '關於';
	@override String get quota => 'Control Center';
	@override String get shortcuts => '鍵盤快捷鍵';
}

// Path: settings.miniOrchestration
class Translations$settings$miniOrchestration$zh_TW extends Translations$settings$miniOrchestration$en {
	Translations$settings$miniOrchestration$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '迷你編排';
	@override String get description => '雙模型流程：由非 flash 的思考者規劃，flash 執行者負責執行。';
	@override String get loading => '正在載入迷你編排設定…';
	@override String get loadError => '無法載入迷你編排設定。';
	@override late final Translations$settings$miniOrchestration$enable$zh_TW enable = Translations$settings$miniOrchestration$enable$zh_TW.internal(_root);
	@override late final Translations$settings$miniOrchestration$thinker$zh_TW thinker = Translations$settings$miniOrchestration$thinker$zh_TW.internal(_root);
	@override late final Translations$settings$miniOrchestration$worker$zh_TW worker = Translations$settings$miniOrchestration$worker$zh_TW.internal(_root);
	@override late final Translations$settings$miniOrchestration$fields$zh_TW fields = Translations$settings$miniOrchestration$fields$zh_TW.internal(_root);
	@override late final Translations$settings$miniOrchestration$roles$zh_TW roles = Translations$settings$miniOrchestration$roles$zh_TW.internal(_root);
	@override late final Translations$settings$miniOrchestration$planner$zh_TW planner = Translations$settings$miniOrchestration$planner$zh_TW.internal(_root);
}

// Path: settings.orchestration
class Translations$settings$orchestration$zh_TW extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '編排';
	@override String get description => '將聊天任務分派到你的各個提供者與模型。';
	@override String get loading => '正在載入編排設定…';
	@override String get loadError => '無法載入編排設定。';
	@override String get retry => '重試';
	@override late final Translations$settings$orchestration$enable$zh_TW enable = Translations$settings$orchestration$enable$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$pool$zh_TW pool = Translations$settings$orchestration$pool$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$tiers$zh_TW tiers = Translations$settings$orchestration$tiers$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$rules$zh_TW rules = Translations$settings$orchestration$rules$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$planner$zh_TW planner = Translations$settings$orchestration$planner$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$execution$zh_TW execution = Translations$settings$orchestration$execution$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$save$zh_TW save = Translations$settings$orchestration$save$zh_TW.internal(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$zh_TW extends Translations$settings$notifications$en {
	Translations$settings$notifications$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
	@override String get description => '控制你希望接收的通知事件。';
	@override late final Translations$settings$notifications$webPush$zh_TW webPush = Translations$settings$notifications$webPush$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$device$zh_TW device = Translations$settings$notifications$device$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$desktop$zh_TW desktop = Translations$settings$notifications$desktop$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$sound$zh_TW sound = Translations$settings$notifications$sound$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$events$zh_TW events = Translations$settings$notifications$events$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$messaging$zh_TW messaging = Translations$settings$notifications$messaging$zh_TW.internal(_root);
	@override late final Translations$settings$notifications$channels$zh_TW channels = Translations$settings$notifications$channels$zh_TW.internal(_root);
	@override String get unpair => '取消配對';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$zh_TW extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$zh_TW darkMode = Translations$settings$appearanceSettings$darkMode$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$zh_TW codeEditor = Translations$settings$appearanceSettings$codeEditor$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$terminal$zh_TW terminal = Translations$settings$appearanceSettings$terminal$zh_TW.internal(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$zh_TW extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$zh_TW title = Translations$settings$mcpForm$title$zh_TW.internal(_root);
	@override late final Translations$settings$mcpForm$importMode$zh_TW importMode = Translations$settings$mcpForm$importMode$zh_TW.internal(_root);
	@override late final Translations$settings$mcpForm$scope$zh_TW scope = Translations$settings$mcpForm$scope$zh_TW.internal(_root);
	@override late final Translations$settings$mcpForm$fields$zh_TW fields = Translations$settings$mcpForm$fields$zh_TW.internal(_root);
	@override late final Translations$settings$mcpForm$placeholders$zh_TW placeholders = Translations$settings$mcpForm$placeholders$zh_TW.internal(_root);
	@override late final Translations$settings$mcpForm$validation$zh_TW validation = Translations$settings$mcpForm$validation$zh_TW.internal(_root);
	@override String configDetails({required Object configFile}) => '設定詳細資訊（來自 ${configFile}）';
	@override String projectPath({required Object path}) => '路徑：${path}';
	@override late final Translations$settings$mcpForm$actions$zh_TW actions = Translations$settings$mcpForm$actions$zh_TW.internal(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$zh_TW extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get success => '設定儲存成功！';
	@override String get error => '儲存設定失敗';
	@override String get saving => '儲存中...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$zh_TW extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get save => '儲存設定';
	@override String get cancel => '取消';
}

// Path: settings.git
class Translations$settings$git$zh_TW extends Translations$settings$git$en {
	Translations$settings$git$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'Git 設定';
	@override String get description => '設定您的 git 提交身分。這些設定將透過 git config --global 全域套用';
	@override late final Translations$settings$git$name$zh_TW name = Translations$settings$git$name$zh_TW.internal(_root);
	@override late final Translations$settings$git$email$zh_TW email = Translations$settings$git$email$zh_TW.internal(_root);
	@override late final Translations$settings$git$actions$zh_TW actions = Translations$settings$git$actions$zh_TW.internal(_root);
	@override late final Translations$settings$git$status$zh_TW status = Translations$settings$git$status$zh_TW.internal(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$zh_TW extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'API 金鑰';
	@override String get description => '產生 API 金鑰以從其他應用程式存取外部 API。';
	@override late final Translations$settings$apiKeys$newKey$zh_TW newKey = Translations$settings$apiKeys$newKey$zh_TW.internal(_root);
	@override late final Translations$settings$apiKeys$form$zh_TW form = Translations$settings$apiKeys$form$zh_TW.internal(_root);
	@override String get newButton => '新增 API 金鑰';
	@override String get empty => '尚未建立 API 金鑰。';
	@override late final Translations$settings$apiKeys$list$zh_TW list = Translations$settings$apiKeys$list$zh_TW.internal(_root);
	@override String get confirmDelete => '確定要刪除此 API 金鑰嗎？';
	@override late final Translations$settings$apiKeys$status$zh_TW status = Translations$settings$apiKeys$status$zh_TW.internal(_root);
	@override late final Translations$settings$apiKeys$github$zh_TW github = Translations$settings$apiKeys$github$zh_TW.internal(_root);
	@override String get apiDocsLink => 'API 文件';
	@override late final Translations$settings$apiKeys$documentation$zh_TW documentation = Translations$settings$apiKeys$documentation$zh_TW.internal(_root);
	@override String get loading => '載入中...';
	@override late final Translations$settings$apiKeys$version$zh_TW version = Translations$settings$apiKeys$version$zh_TW.internal(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$zh_TW extends Translations$settings$tasks$en {
	Translations$settings$tasks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get checking => '正在檢查 TaskMaster 安裝...';
	@override late final Translations$settings$tasks$notInstalled$zh_TW notInstalled = Translations$settings$tasks$notInstalled$zh_TW.internal(_root);
	@override late final Translations$settings$tasks$settings$zh_TW settings = Translations$settings$tasks$settings$zh_TW.internal(_root);
}

// Path: settings.agents
class Translations$settings$agents$zh_TW extends Translations$settings$agents$en {
	Translations$settings$agents$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$zh_TW authStatus = Translations$settings$agents$authStatus$zh_TW.internal(_root);
	@override late final Translations$settings$agents$install$zh_TW install = Translations$settings$agents$install$zh_TW.internal(_root);
	@override late final Translations$settings$agents$update$zh_TW update = Translations$settings$agents$update$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$zh_TW account = Translations$settings$agents$account$zh_TW.internal(_root);
	@override String get connectionStatus => '連線狀態';
	@override late final Translations$settings$agents$login$zh_TW login = Translations$settings$agents$login$zh_TW.internal(_root);
	@override late final Translations$settings$agents$logout$zh_TW logout = Translations$settings$agents$logout$zh_TW.internal(_root);
	@override String error({required Object error}) => '錯誤：${error}';
	@override late final Translations$settings$agents$accounts$zh_TW accounts = Translations$settings$agents$accounts$zh_TW.internal(_root);
}

// Path: settings.permissions
class Translations$settings$permissions$zh_TW extends Translations$settings$permissions$en {
	Translations$settings$permissions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '權限設定';
	@override late final Translations$settings$permissions$permissionMode$zh_TW permissionMode = Translations$settings$permissions$permissionMode$zh_TW.internal(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$zh_TW extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP 伺服器';
	@override late final Translations$settings$mcpServers$description$zh_TW description = Translations$settings$mcpServers$description$zh_TW.internal(_root);
	@override String get addButton => '新增 MCP 伺服器';
	@override String get empty => '未設定 MCP 伺服器';
	@override String get serverType => '類型';
	@override late final Translations$settings$mcpServers$scope$zh_TW scope = Translations$settings$mcpServers$scope$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$config$zh_TW config = Translations$settings$mcpServers$config$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$tools$zh_TW tools = Translations$settings$mcpServers$tools$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$actions$zh_TW actions = Translations$settings$mcpServers$actions$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$managed$zh_TW managed = Translations$settings$mcpServers$managed$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$help$zh_TW help = Translations$settings$mcpServers$help$zh_TW.internal(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$zh_TW deleteConfirm = Translations$settings$mcpServers$deleteConfirm$zh_TW.internal(_root);
}

// Path: settings.quota
class Translations$settings$quota$zh_TW extends Translations$settings$quota$en {
	Translations$settings$quota$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$zh_TW settings = Translations$settings$quota$settings$zh_TW.internal(_root);
	@override late final Translations$settings$quota$empty$zh_TW empty = Translations$settings$quota$empty$zh_TW.internal(_root);
	@override late final Translations$settings$quota$quality$zh_TW quality = Translations$settings$quota$quality$zh_TW.internal(_root);
	@override String get syncFailed => '同步失敗';
	@override String get syncNow => '立即同步';
}

// Path: settings.browser
class Translations$settings$browser$zh_TW extends Translations$settings$browser$en {
	Translations$settings$browser$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get checking => '正在檢查...';
	@override String get description => '允許代理啟動受管理的 Playwright 瀏覽器工作階段，你可以在 Browser 分頁中監控。';
	@override String get enableDescription => '為支援的代理註冊 Browser。代理可以建立瀏覽器工作階段，你可以監控、停止和刪除它們。';
	@override String get enableLabel => '啟用 Browser';
	@override late final Translations$settings$browser$errors$zh_TW errors = Translations$settings$browser$errors$zh_TW.internal(_root);
	@override String get installHint => '在代理建立 Browser 工作階段之前，請安裝瀏覽器執行環境。';
	@override String get installRuntime => '安裝執行環境';
	@override String get installed => '已安裝';
	@override String get installing => '正在安裝...';
	@override String get missing => '缺失';
	@override String get runtimeRequired => '需要瀏覽器執行環境';
	@override String get statusDisabled => '已停用';
	@override String get statusLabel => '狀態';
	@override String get statusReady => '就緒';
	@override String get statusSetupRequired => '需要設定';
	@override String get title => '瀏覽器';
}

// Path: settings.workspaces
class Translations$settings$workspaces$zh_TW extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get create => '新增工作區';
	@override String get deleteConfirm => '從 DDAgent 移除此工作區？檔案將保留在磁碟上。';
	@override String get deleteFailed => '移除工作區失敗。';
	@override String get deleteTitle => '移除工作區';
	@override String get description => '工作區是 DDAgent 可以聊天、執行程式碼和瀏覽的目錄。';
	@override String get remove => '移除工作區';
	@override String get title => '工作區';
	@override String get pathRequired => '路徑為必填項。';
}

// Path: settings.stt
class Translations$settings$stt$zh_TW extends Translations$settings$stt$en {
	Translations$settings$stt$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '語音輸入（語音轉文字）';
	@override String get description => '相容 Whisper 的 /audio/transcriptions 端點（OpenAI、whisper.cpp、faster-whisper、Speaches）。啟用後，輸入區會出現麥克風按鈕。';
	@override String get configured => '已設定';
	@override String get endpoint => '端點 URL（例如 https://api.openai.com/v1）';
	@override String get apiKey => 'API 金鑰';
	@override String get model => '模型（預設：whisper-1）';
	@override String get save => '儲存';
}

// Path: settings.schedules
class Translations$settings$schedules$zh_TW extends Translations$settings$schedules$en {
	Translations$settings$schedules$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '排程';
	@override String get description => '依 cron 時間表定期執行代理。執行時無人看管，且會略過權限確認。';
	@override String get preventSleep => '代理執行時防止休眠';
	@override String get preventSleepHint => '桌面版會讓螢幕保持喚醒；瀏覽器中則使用螢幕喚醒鎖定。';
	@override String get kNew => '新增排程';
	@override String get loading => '正在載入…';
	@override String get empty => '尚無排程。';
	@override String get project => '專案';
	@override String get provider => '提供者';
	@override String get cron => 'Cron（分 時 日 月 星期）';
	@override String nextRun({required Object time}) => '下次執行：${time}';
	@override String get cronInvalid => '此運算式沒有即將到來的執行時間';
	@override String get prompt => '提示詞';
	@override String get useWorktree => '在全新的 worktree 中執行';
	@override String get catchUp => '補執行錯過的排程';
	@override String failures({required Object count}) => '${count} 次失敗';
	@override String get disabled => '已停用';
	@override String get history => '歷史紀錄';
	@override String get runNow => '立即執行';
	@override String get delete => '刪除';
	@override String get noRuns => '尚無執行紀錄。';
	@override String get next => '下次';
	@override String get create => '建立';
	@override String get toggleSchedule => '啟用排程';
}

// Path: settings.mcpTokens
class Translations$settings$mcpTokens$zh_TW extends Translations$settings$mcpTokens$en {
	Translations$settings$mcpTokens$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent MCP 伺服器權杖';
	@override String get description => '外部工具（Claude Desktop、OpenClaw）會透過 POST /mcp，並使用以下其中一個 Bearer 權杖來呼叫 DDAgent 工具。';
	@override String get dismiss => '關閉';
	@override String get labelPlaceholder => '權杖標籤（例如 Claude Desktop）';
	@override String get create => '建立';
	@override String get empty => '尚無 MCP 權杖。';
	@override String lastUsed({required Object time}) => '上次使用：${time}';
	@override String get neverUsed => '從未使用';
}

// Path: settings.about
class Translations$settings$about$zh_TW extends Translations$settings$about$en {
	Translations$settings$about$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => '支持此專案';
	@override String get buyMeACoffee => '請我喝杯咖啡';
	@override String get tryHosted => '試用 DDAgent Hosted';
	@override String get learnMore => '深入了解';
	@override String get proFeatures => 'DDAgent Pro 功能';
	@override late final Translations$settings$about$pro$zh_TW pro = Translations$settings$about$pro$zh_TW.internal(_root);
	@override String get versionInfo => '版本資訊';
	@override String get client => '應用程式';
	@override String get server => '伺服器';
	@override String get platformMobile => '行動裝置';
	@override String get platformDesktop => '桌面版';
	@override String get platformWeb => '網頁';
	@override String get unknown => '未知';
	@override String get copyright => '© 2026 DDAgent — 保留所有權利';
	@override String get tagline => '開源 AI 程式設計助理介面';
	@override String get docs => '文件';
	@override String get hostedDescription => '團隊協作、共用 MCP 設定、跨環境設定同步以及託管基礎架構。';
}

// Path: settings.shortcuts
class Translations$settings$shortcuts$zh_TW extends Translations$settings$shortcuts$en {
	Translations$settings$shortcuts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'DDAgent 中的所有鍵盤快捷鍵，依平台分類。';
	@override String get action => '動作';
	@override String get winLinux => 'Windows / Linux';
	@override String get mac => 'macOS';
	@override String get navigation => '導覽';
	@override String get navWorkspace => '前往工作區';
	@override String get navTasks => '前往任務／Git';
	@override String get navGit => '前往 Git';
	@override String get navFocus => '切換專注模式（側邊欄）';
	@override String get navSwitcher => '快速切換工作階段';
	@override String get navPalette => '命令面板';
	@override String get navSettings => '開啟設定';
	@override String get navClose => '關閉對話框／還原分割窗格';
	@override String get composer => '訊息輸入區';
	@override String get compSend => '傳送訊息';
	@override String get compNewline => '換行';
	@override String get compNav => '瀏覽建議';
	@override String get compAccept => '接受建議';
	@override String get compCloseSuggest => '關閉建議';
	@override String get transcript => '對話內容';
	@override String get trCopy => '複製所選文字';
	@override String get trClose => '關閉搜尋／審查面板';
	@override String get terminal => '終端機';
	@override String get termCopy => '複製選取內容';
	@override String get termInterrupt => '中斷程序（未選取時）';
	@override String get termPaste => '貼上';
	@override String get termSelectAll => '全選';
	@override String get editor => '編輯器';
	@override String get edSave => '儲存檔案';
	@override String get edSaveAll => '儲存所有檔案';
	@override String get edClose => '關閉分頁';
	@override String get edNextTab => '下一個分頁';
	@override String get edPrevTab => '上一個分頁';
	@override String get edIndent => '增加／減少縮排';
	@override String get palette => '命令面板';
	@override String get palNav => '瀏覽項目';
	@override String get palRun => '執行／開啟';
	@override String get palBack => '返回（搜尋為空時）';
	@override String get palClose => '關閉';
}

// Path: sidebar.projects
class Translations$sidebar$projects$zh_TW extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '專案';
	@override String get newProject => '新增專案';
	@override String get deleteProject => '移除專案';
	@override String get renameProject => '重新命名專案';
	@override String get noProjects => '找不到專案';
	@override String get loadingProjects => '載入專案中...';
	@override String get searchPlaceholder => '搜尋專案...';
	@override String get projectNamePlaceholder => '專案名稱';
	@override String get starred => '星號標記';
	@override String get all => '全部';
	@override String get untitledSession => '未命名工作階段';
	@override String get newSession => '新工作階段';
	@override String get codexSession => 'Codex 工作階段';
	@override String get fetchingProjects => '正在取得您的 Claude 專案和工作階段';
	@override String get projects => '專案';
	@override String get noMatchingProjects => '找不到符合的專案';
	@override String get tryDifferentSearch => '嘗試調整您的搜尋詞';
	@override String get runClaudeCli => '在專案目錄中執行 Claude CLI 以開始使用';
}

// Path: sidebar.app
class Translations$sidebar$app$zh_TW extends Translations$sidebar$app$en {
	Translations$sidebar$app$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'DDAgent';
	@override String get subtitle => 'AI 程式開發助手';
}

// Path: sidebar.panel
class Translations$sidebar$panel$zh_TW extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get open => '面板';
	@override String get newChat => '新聊天';
	@override String get navigation => '導覽';
	@override String get sessions => '工作階段';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$zh_TW extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '工作階段';
	@override String get newSession => '新增工作階段';
	@override String get deleteSession => '刪除工作階段';
	@override String get renameSession => '重新命名工作階段';
	@override String get noSessions => '暫無工作階段';
	@override String get loadingSessions => '載入工作階段中...';
	@override String get unnamed => '未命名';
	@override String get loading => '載入中...';
	@override String get showMore => '顯示更多工作階段';
	@override String get selectMode => '選取';
	@override String get selectAll => '全選';
	@override String archiveSelected({required Object count}) => '封存（${count}）';
	@override String deleteSelected({required Object count}) => '刪除（${count}）';
	@override String get cancelSelection => '取消選取';
	@override String get toggleSelection => '切換工作階段選取';
	@override String get selectionToolbar => '工作階段選取操作';
	@override String get options => '工作階段選項';
	@override String get pinSession => '釘選工作階段';
	@override String get unpinSession => '取消釘選工作階段';
	@override String get pinned => '已釘選的工作階段';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '已選 ${count} 個',
		other: '已選 ${count} 個',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$zh_TW extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => '查看環境';
	@override String get hideSidebar => '隱藏側邊欄';
	@override String get createProject => '建立新專案';
	@override String get refresh => '重新整理專案和工作階段 (Ctrl+R)';
	@override String get renameProject => '重新命名專案 (F2)';
	@override String get deleteProject => '從側邊欄移除專案 (Delete)';
	@override String get addToFavorites => '加入收藏';
	@override String get removeFromFavorites => '從收藏移除';
	@override String get editSessionName => '手動編輯工作階段名稱';
	@override String get deleteSession => '永久刪除此工作階段';
	@override String get activeSessionIndicator => '最近活躍的工作階段（最近 10 分鐘）';
	@override String get save => '儲存';
	@override String get cancel => '取消';
	@override String get clearSearch => '清除搜尋';
	@override String get openCommandPalette => '開啟指令面板';
	@override String get attentionRequiredIndicator => '工作階段需要處理';
	@override String get openSessions => '瀏覽工作階段';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$zh_TW extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get chat => '聊天';
	@override String get files => '檔案';
	@override String get git => 'Git';
	@override String get terminal => '終端機';
	@override String get tasks => '任務';
}

// Path: sidebar.actions
class Translations$sidebar$actions$zh_TW extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get refresh => '重新整理';
	@override String get settings => '設定';
	@override String get collapseAll => '全部收合';
	@override String get expandAll => '全部展開';
	@override String get cancel => '取消';
	@override String get save => '儲存';
	@override String get delete => '刪除';
	@override String get rename => '重新命名';
	@override String get joinCommunity => '加入社群';
	@override String get reportIssue => '回報問題';
	@override String get starOnGithub => '在 GitHub 上加星';
	@override String get buyMeACoffee => '請我喝杯咖啡';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$zh_TW extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '變更工作階段工作區';
	@override String get description => '代理將在此目錄中執行後續回合。現有工作階段歷史將被保留。';
	@override String get pathLabel => '工作區路徑';
	@override String get pathRequired => '工作區路徑為必填項。';
	@override String get submit => '變更工作區';
	@override String get saving => '正在變更…';
	@override String get changeAction => '變更工作區';
}

// Path: sidebar.branding
class Translations$sidebar$branding$zh_TW extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get openSource => '開源';
}

// Path: sidebar.status
class Translations$sidebar$status$zh_TW extends Translations$sidebar$status$en {
	Translations$sidebar$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get active => '使用中';
	@override String get inactive => '非使用中';
	@override String get thinking => '思考中...';
	@override String get error => '錯誤';
	@override String get aborted => '已中止';
	@override String get unknown => '未知';
}

// Path: sidebar.time
class Translations$sidebar$time$zh_TW extends Translations$sidebar$time$en {
	Translations$sidebar$time$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get justNow => '剛剛';
	@override String get oneMinuteAgo => '1 分鐘前';
	@override String minutesAgo({required Object count}) => '${count} 分鐘前';
	@override String get oneHourAgo => '1 小時前';
	@override String hoursAgo({required Object count}) => '${count} 小時前';
	@override String get oneDayAgo => '1 天前';
	@override String daysAgo({required Object count}) => '${count} 天前';
}

// Path: sidebar.messages
class Translations$sidebar$messages$zh_TW extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => '確定要刪除嗎？';
	@override String get renameSuccess => '重新命名成功';
	@override String get deleteSuccess => '刪除成功';
	@override String get errorOccurred => '發生錯誤';
	@override String get deleteSessionConfirm => '確定要刪除此工作階段嗎？此操作無法復原。';
	@override String get deleteProjectConfirm => '從側邊欄移除此專案？您的專案檔案、記憶和工作階段資料不會被刪除。';
	@override String get enterProjectPath => '請輸入專案路徑';
	@override String get deleteSessionFailed => '刪除工作階段失敗，請重試。';
	@override String get deleteSessionError => '刪除工作階段時出錯，請重試。';
	@override String get renameSessionFailed => '重新命名工作階段失敗，請重試。';
	@override String get renameSessionError => '重新命名工作階段時出錯，請重試。';
	@override String get changeWorkspaceFailed => '更改工作區失敗。請重試。';
	@override String get changeWorkspaceError => '更改工作區時發生錯誤。請重試。';
	@override String get deleteProjectFailed => '移除專案失敗，請重試。';
	@override String get deleteProjectError => '移除專案時出錯，請重試。';
	@override String get createProjectFailed => '建立專案失敗，請重試。';
	@override String get createProjectError => '建立專案時出錯，請重試。';
	@override String get updateProjectError => '更新專案時出錯，請重試。';
	@override String get refreshError => '重新整理失敗，請重試。';
	@override String get restoreProjectFailed => '還原專案失敗，請重試。';
	@override String get restoreProjectError => '還原專案時出錯，請重試。';
	@override String get restoreSessionFailed => '還原工作階段失敗，請重試。';
	@override String get restoreSessionError => '還原工作階段時出錯，請重試。';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '刪除 ${count} 個工作階段失敗。請重試。',
		other: '刪除 ${count} 個工作階段失敗。請重試。',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$zh_TW extends Translations$sidebar$version$en {
	Translations$sidebar$version$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => '有可用更新';
	@override String get restartRequired => '已安裝更新 — 請重新啟動伺服器以套用';
	@override String get updateNow => '立即更新';
	@override String updateConfirm({required Object version}) => '將 DDAgent 更新到 v${version}？將擷取最新程式碼並重新建置，隨後伺服器會重新啟動 — 進行中的工作階段會被中斷。';
	@override String get updating => '正在更新… 可能需要幾分鐘';
	@override String get restarting => '更新已安裝 — 正在重新啟動…';
	@override String get updateFailed => '更新失敗';
	@override String get releaseNotes => '版本資訊';
}

// Path: sidebar.search
class Translations$sidebar$search$zh_TW extends Translations$sidebar$search$en {
	Translations$sidebar$search$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => '專案';
	@override String get modeConversations => '對話';
	@override String get conversationsPlaceholder => '搜尋對話內容...';
	@override String get searching => '搜尋中...';
	@override String get sessionTitles => '工作階段標題';
	@override String get conversationContents => '對話內容';
	@override String get noResults => '找不到結果';
	@override String get tryDifferentQuery => '嘗試不同的搜尋詞';
	@override String get modeRunning => '執行中';
	@override String get archiveOnly => '封存';
	@override String get runningTooltip => '執行中的工作階段';
	@override String get archiveOnlyTooltip => '僅封存';
	@override String runningCount({required Object count}) => '${count} 個活躍';
	@override String get viewMenu => '檢視';
	@override String get backToProjects => '返回專案';
	@override String get archivedPlaceholder => '搜尋已封存工作階段...';
	@override String get runningPlaceholder => '搜尋執行中的工作階段...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個符合',
		other: '${count} 個符合',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個專案已掃描',
		other: '${count} 個專案已掃描',
	);
}

// Path: sidebar.recent
class Translations$sidebar$recent$zh_TW extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '最近對話';
	@override String get emptyTitle => '尚無對話';
	@override String get emptyDescription => '你最近更新的對話將顯示在這裡。';
	@override String get loadFailed => '無法載入最近對話';
	@override String get loadMore => '載入更早的對話';
	@override String get loadingMore => '載入中...';
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$zh_TW extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => '移除專案';
	@override String get deleteSession => '刪除工作階段';
	@override String get confirmDelete => '您想如何處理';
	@override String get removeFromSidebar => '僅從側邊欄移除';
	@override String get deleteAllData => '永久刪除所有資料';
	@override String get allConversationsDeleted => '專案將從側邊欄中移除。您的檔案、記憶和工作階段資料將會保留。';
	@override String get cannotUndo => '您可以稍後重新新增此專案。';
	@override String get bulkDeleteSessionsDescription => '封存會將所選工作階段從使用中清單隱藏，同時保留其歷史記錄。';
	@override String get archiveSession => '封存工作階段';
	@override String get archiveSessionNotice => '封存會將工作階段移出使用中的清單，同時保留其歷史記錄。';
	@override String get archivedSessionNotice => '此工作階段已封存。你可以保持隱藏或永久刪除。';
	@override String get deleteSessionNotice => '這將永久刪除工作階段及其記錄。此操作無法復原。';
	@override String get deleteSessionPermanently => '永久刪除';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '此專案包含 ${count} 個對話。',
		other: '此專案包含 ${count} 個對話。',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '管理所選工作階段',
		other: '管理 ${count} 個所選工作階段',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '封存工作階段',
		other: '封存 ${count} 個工作階段',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$zh_TW extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get activeNow => '目前活躍';
	@override String get recent => '最近使用';
	@override String get today => '今天';
	@override String get yesterday => '昨天';
	@override String get thisWeek => '本週';
	@override String showMore({required Object count}) => '再顯示 ${count} 個';
	@override String get showLess => '收合';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$zh_TW extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get board => '代理面板';
	@override String get files => '檔案';
	@override String get git => '原始碼管理';
	@override String get tasks => '任務';
	@override String get usage => '配額與用量';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$zh_TW extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI 尚未設定';
	@override String get description => 'TaskMaster 協助將複雜的專案分解為可管理的任務，搭配 AI 驅動的輔助功能';
	@override String get whatIsTitle => '🎯 什麼是 TaskMaster？';
	@override late final Translations$tasks$notConfigured$features$zh_TW features = Translations$tasks$notConfigured$features$zh_TW.internal(_root);
	@override String get initializeButton => '初始化 TaskMaster AI';
	@override String get writePrdFirst => '請先撰寫 PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$zh_TW extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '開始使用 TaskMaster';
	@override String get subtitle => 'TaskMaster 已初始化！以下是接下來要做的事：';
	@override late final Translations$tasks$gettingStarted$steps$zh_TW steps = Translations$tasks$gettingStarted$steps$zh_TW.internal(_root);
	@override String get tip => '💡 提示：從 PRD 開始可以充分利用 TaskMaster 的 AI 驅動任務產生功能';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$zh_TW extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster 設定';
	@override String subtitle({required Object projectName}) => '${projectName} 的互動式 CLI';
	@override String get willStart => 'TaskMaster 初始化將自動開始';
	@override String get completed => 'TaskMaster 設定完成！您現在可以關閉此視窗。';
	@override String get closeButton => '關閉';
	@override String get closeContinueButton => '關閉並繼續';
	@override String get closeTitle => '關閉';
	@override String get description => '這將在此專案中建立一個 .taskmaster 資料夾。無需外部工具或 API 金鑰——任務保存在本機。';
	@override String get initializeButton => '初始化';
	@override String get initializing => '正在初始化...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$zh_TW extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '開始使用 TaskMaster';
	@override String get subtitle => '您的高效任務管理指南';
	@override late final Translations$tasks$helpGuide$examples$zh_TW examples = Translations$tasks$helpGuide$examples$zh_TW.internal(_root);
	@override String get moreExamples => '查看更多範例和使用模式 →';
	@override late final Translations$tasks$helpGuide$proTips$zh_TW proTips = Translations$tasks$helpGuide$proTips$zh_TW.internal(_root);
	@override late final Translations$tasks$helpGuide$learnMore$zh_TW learnMore = Translations$tasks$helpGuide$learnMore$zh_TW.internal(_root);
	@override String get closeTitle => '關閉';
}

// Path: tasks.search
class Translations$tasks$search$zh_TW extends Translations$tasks$search$en {
	Translations$tasks$search$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get placeholder => '搜尋任務...';
}

// Path: tasks.filters
class Translations$tasks$filters$zh_TW extends Translations$tasks$filters$en {
	Translations$tasks$filters$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get button => '篩選';
	@override String get status => '狀態';
	@override String get priority => '優先順序';
	@override String get sortBy => '排序依據';
	@override String get allStatuses => '所有狀態';
	@override String get allPriorities => '所有優先順序';
	@override String showing({required Object filtered, required Object total}) => '顯示 ${filtered} / ${total} 個任務';
	@override String get clearFilters => '清除篩選';
}

// Path: tasks.sort
class Translations$tasks$sort$zh_TW extends Translations$tasks$sort$en {
	Translations$tasks$sort$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => '狀態';
	@override String get priority => '優先順序';
	@override String get idAsc => 'ID（遞增）';
	@override String get idDesc => 'ID（遞減）';
	@override String get titleAsc => '標題（A-Z）';
	@override String get titleDesc => '標題（Z-A）';
	@override String get statusAsc => '狀態（待處理優先）';
	@override String get statusDesc => '狀態（已完成優先）';
	@override String get priorityAsc => '優先順序（高優先）';
	@override String get priorityDesc => '優先順序（低優先）';
}

// Path: tasks.views
class Translations$tasks$views$zh_TW extends Translations$tasks$views$en {
	Translations$tasks$views$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get kanban => '看板檢視';
	@override String get list => '清單檢視';
	@override String get grid => '網格檢視';
}

// Path: tasks.kanban
class Translations$tasks$kanban$zh_TW extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 待辦';
	@override String get inProgress => '🚀 進行中';
	@override String get review => '👀 審查';
	@override String get done => '✅ 已完成';
	@override String get blocked => '🚫 已封鎖';
	@override String get deferred => '⏳ 已延後';
	@override String get cancelled => '❌ 已取消';
	@override String get noTasksYet => '尚無任務';
	@override String get tasksWillAppear => '任務將顯示在這裡';
	@override String get moveTasksHere => '開始後將任務移到這裡';
	@override String get completedTasksHere => '已完成的任務顯示在這裡';
	@override String get statusTasksHere => '此狀態的任務將顯示在這裡';
}

// Path: tasks.buttons
class Translations$tasks$buttons$zh_TW extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get help => 'TaskMaster 入門指南';
	@override String get prds => 'PRD';
	@override String get addPRD => '新增 PRD';
	@override String get addTask => '新增任務';
	@override String get createNewPRD => '建立新 PRD';
	@override String prdsAvailable({required Object count}) => '${count} 個 PRD 可用';
}

// Path: tasks.prd
class Translations$tasks$prd$zh_TW extends Translations$tasks$prd$en {
	Translations$tasks$prd$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => '修改時間：${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String get newFile => '新檔案';
	@override String get template => '範本';
	@override String get parse => '解析 PRD';
	@override String get fileExistsTitle => '檔案已存在';
	@override String fileExistsMessage({required Object name}) => '已存在名為「${name}」的 PRD。要覆寫嗎？';
	@override String get fileNameHint => '檔案名稱（例如 prd.txt）';
	@override String get saved => 'PRD 已儲存';
	@override String get tasksGenerated => '已從 PRD 產生任務';
}

// Path: tasks.statuses
class Translations$tasks$statuses$zh_TW extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get pending => '待處理';
	@override String get inProgress => '進行中';
	@override String get done => '已完成';
	@override String get blocked => '已封鎖';
	@override String get deferred => '已延後';
	@override String get cancelled => '已取消';
	@override String get review => '審查';
}

// Path: tasks.priorities
class Translations$tasks$priorities$zh_TW extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get high => '高';
	@override String get medium => '中';
	@override String get low => '低';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$zh_TW extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '沒有符合篩選條件的任務';
	@override String get description => '嘗試調整您的搜尋或篩選條件。';
}

// Path: tasks.board
class Translations$tasks$board$zh_TW extends Translations$tasks$board$en {
	Translations$tasks$board$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '代理看板';
	@override String get subtitle => '把卡片移到「準備開始」，代理就會接手。點擊卡片開啟其工作階段。';
	@override String get newCard => '新卡片';
	@override String get addCard => '新增卡片';
	@override String get refresh => '重新整理';
	@override late final Translations$tasks$board$empty$zh_TW empty = Translations$tasks$board$empty$zh_TW.internal(_root);
	@override late final Translations$tasks$board$columns$zh_TW columns = Translations$tasks$board$columns$zh_TW.internal(_root);
	@override late final Translations$tasks$board$card$zh_TW card = Translations$tasks$board$card$zh_TW.internal(_root);
	@override late final Translations$tasks$board$dialog$zh_TW dialog = Translations$tasks$board$dialog$zh_TW.internal(_root);
	@override String get noProject => '先新增一個專案，然後為它建立卡片。';
	@override String get projectLabel => '專案';
	@override String get backToChat => '返回聊天';
	@override late final Translations$tasks$board$agent$zh_TW agent = Translations$tasks$board$agent$zh_TW.internal(_root);
	@override late final Translations$tasks$board$deleteConfirm$zh_TW deleteConfirm = Translations$tasks$board$deleteConfirm$zh_TW.internal(_root);
	@override String get project => '專案';
	@override late final Translations$tasks$board$assignee$zh_TW assignee = Translations$tasks$board$assignee$zh_TW.internal(_root);
	@override late final Translations$tasks$board$presence$zh_TW presence = Translations$tasks$board$presence$zh_TW.internal(_root);
	@override late final Translations$tasks$board$activity$zh_TW activity = Translations$tasks$board$activity$zh_TW.internal(_root);
	@override late final Translations$tasks$board$comments$zh_TW comments = Translations$tasks$board$comments$zh_TW.internal(_root);
}

// Path: tasks.card
class Translations$tasks$card$zh_TW extends Translations$tasks$card$en {
	Translations$tasks$card$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => '依賴於：${tasks}';
	@override String dependsOnTooltip({required Object id}) => '任務 ${id}';
	@override String get highPriority => '高優先級';
	@override String get lowPriority => '低優先級';
	@override String get mediumPriority => '中優先級';
	@override String get noPriority => '未設定優先級';
	@override String parentTask({required Object id}) => '任務 ${id}';
	@override String get progressLabel => '進度：';
	@override String progressTooltip({required Object total, required Object completed}) => '${total} 個子任務中已完成 ${completed} 個';
	@override String get runTask => '執行任務';
	@override String runTaskAria({required Object id}) => '執行任務 ${id}';
	@override String statusTooltip({required Object status}) => '狀態：${status}';
	@override String taskIdTitle({required Object id}) => '任務 ID：${id}';
	@override String get taskInProgress => '任務進行中';
}

// Path: tasks.createTask
class Translations$tasks$createTask$zh_TW extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get descriptionLabel => '描述';
	@override String get descriptionPlaceholder => '可選詳情';
	@override String get error => '新增任務失敗';
	@override String get priorityLabel => '優先級';
	@override String get submit => '新增任務';
	@override String get submitting => '正在新增...';
	@override String get title => '新增任務';
	@override String get titleLabel => '標題';
	@override String get titlePlaceholder => '需要做什麼？';
}

// Path: tasks.list
class Translations$tasks$list$zh_TW extends Translations$tasks$list$en {
	Translations$tasks$list$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => '已完成（點擊重新開啟）';
	@override String get inProgressComplete => '進行中（點擊完成）';
	@override String get markCompleted => '標記為已完成';
	@override String toggleStatusAria({required Object id}) => '切換任務 ${id} 的狀態';
	@override String get markDone => '標記為完成';
	@override String get reopen => '重新開啟';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$zh_TW extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get allComplete => '所有任務已完成';
	@override String get feature1 => '- AI 任務管理，支援依賴和子任務。';
	@override String get feature2 => '- PRD 驅動的任務產生，快速啟動專案。';
	@override String get feature3 => '- 看板和清單檢視，適合日常工作。';
	@override String get hideDetails => '隱藏詳情';
	@override String get initialize => '初始化';
	@override String get noPending => '沒有待處理任務';
	@override String get notConfigured => 'TaskMaster AI 未設定';
	@override String get review => '審查';
	@override String get startTask => '開始任務';
	@override String taskId({required Object id}) => '任務 ${id}';
	@override String get viewAll => '檢視所有任務';
	@override String get viewDetails => '檢視任務詳情';
	@override String get whatIs => '什麼是 TaskMaster？';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$zh_TW extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => '取消編輯';
	@override String get close => '關閉';
	@override String get copyTaskId => '複製任務 ID';
	@override String get delete => '刪除任務';
	@override String deleteConfirmDescription({required Object title}) => '「${title}」將被永久刪除。';
	@override String get deleteConfirmTitle => '刪除任務？';
	@override String get deleteFailed => '刪除任務失敗';
	@override String get dependencies => '依賴項';
	@override String get dependenciesPlaceholder => '例如：1, 2, 3';
	@override String get description => '描述';
	@override String get edit => '編輯任務';
	@override String get implDetails => '實作細節';
	@override String get noDependencies => '無依賴項';
	@override String get noDescription => '無描述';
	@override String get priority => '優先級';
	@override String get priorityNotSet => '未設定';
	@override String get save => '儲存';
	@override String get status => '狀態';
	@override String get statusFailed => '更新任務狀態失敗';
	@override String taskId({required Object id}) => '任務 ${id}';
	@override String taskTitle({required Object id, required Object title}) => '任務 ${id}：${title}';
	@override String get testStrategy => '測試策略';
	@override String get titleRequired => '標題為必填項';
	@override String get updateFailed => '更新任務失敗';
	@override String get notFound => '找不到任務';
	@override String get subtasks => '子任務';
	@override String deleteConfirmMessage({required Object id}) => '任務 #${id} 將被移除。此操作無法復原。';
	@override String get idCopied => '已複製任務 ID';
}

// Path: tasks.toasts
class Translations$tasks$toasts$zh_TW extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => '任務 ${id} 已設為進行中';
}

// Path: tasks.taskmaster
class Translations$tasks$taskmaster$zh_TW extends Translations$tasks$taskmaster$en {
	Translations$tasks$taskmaster$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get noProjectHint => '請先新增專案，然後為其建立任務。';
	@override late final Translations$tasks$taskmaster$sort$zh_TW sort = Translations$tasks$taskmaster$sort$zh_TW.internal(_root);
	@override String installedVersion({required Object version}) => '已安裝：${version}';
	@override String get initFailed => '初始化 TaskMaster 失敗';
	@override late final Translations$tasks$taskmaster$prd$zh_TW prd = Translations$tasks$taskmaster$prd$zh_TW.internal(_root);
	@override late final Translations$tasks$taskmaster$detail$zh_TW detail = Translations$tasks$taskmaster$detail$zh_TW.internal(_root);
	@override String get untitledTask => '無標題任務';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$zh_TW extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dashboard => '面板';
	@override String get memories => '記憶';
	@override String get rules => '規則';
	@override String get skills => '技能';
	@override String get personal => '個人資訊';
	@override String get graph => '圖譜';
}

// Path: knowledge.common
class Translations$knowledge$common$zh_TW extends Translations$knowledge$common$en {
	Translations$knowledge$common$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get add => '新增';
	@override String get save => '儲存';
	@override String get cancel => '取消';
	@override String get delete => '刪除';
	@override String get edit => '編輯';
	@override String get close => '關閉';
	@override String get restore => '還原';
	@override String get refresh => '重新整理';
	@override String get allProjects => '所有專案';
	@override String get global => '全域';
}

// Path: knowledge.actions
class Translations$knowledge$actions$zh_TW extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get scan => '掃描專案檔案';
	@override String get export => '匯出 JSON';
	@override String get import => '匯入 JSON';
	@override String get scanComplete => '掃描完成';
	@override String get importComplete => '匯入完成';
	@override String get importFailed => '匯入失敗';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$zh_TW extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get newEntity => '新增項目';
	@override String get editEntity => '編輯項目';
	@override String get deleteTitle => '刪除';
	@override String get deleteMessage => '刪除此項目？此操作無法復原（歷史記錄會保留）。';
	@override String get pickIcon => '選擇圖示';
	@override String get removeIcon => '移除圖示';
	@override String get iconTooLarge => '圖示過大（最大 40 KB）。';
	@override String get importTitle => '匯入知識';
	@override String get importHint => '在此貼上匯出的 JSON';
	@override String get exportTitle => '匯出知識';
	@override String get import => '匯入';
}

// Path: knowledge.fields
class Translations$knowledge$fields$zh_TW extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get key => '鍵';
	@override String get title => '標題';
	@override String get name => '名稱';
	@override String get description => '說明';
	@override String get category => '分類';
	@override String get content => '內容';
	@override String get priority => '優先順序';
	@override String get tags => '標籤';
	@override String get enabled => '啟用';
	@override String get projectScope => '專案範圍';
	@override String get tagsHint => '以逗號分隔';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$zh_TW extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get memories => '記憶';
	@override String get rules => '規則';
	@override String get skills => '技能';
	@override String get personal => '個人資訊';
	@override String get connections => '連接';
	@override String get recent => '最近的記憶';
	@override String get noMemories => '尚無記憶。請在「記憶」分頁新增。';
}

// Path: knowledge.empty
class Translations$knowledge$empty$zh_TW extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get memories => '尚無記憶。';
	@override String get rules => '尚無規則。';
	@override String get skills => '尚無技能。';
	@override String get personal => '尚無個人資訊。';
	@override String get graph => '沒有可顯示的實體。';
}

// Path: knowledge.history
class Translations$knowledge$history$zh_TW extends Translations$knowledge$history$en {
	Translations$knowledge$history$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '歷史';
	@override String get none => '尚無歷史。';
	@override String get untitled => '（無標題）';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$zh_TW extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get critical => '嚴重';
	@override String get high => '高';
	@override String get normal => '普通';
	@override String get low => '低';
}

// Path: knowledge.search
class Translations$knowledge$search$zh_TW extends Translations$knowledge$search$en {
	Translations$knowledge$search$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '搜尋知識';
	@override String get hint => '搜尋記憶、規則、技能…';
	@override String get noResults => '沒有結果。';
}

// Path: knowledge.links
class Translations$knowledge$links$zh_TW extends Translations$knowledge$links$en {
	Translations$knowledge$links$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '關聯實體';
	@override String get source => '來源';
	@override String get target => '目標';
	@override String get relationship => '關係';
	@override String get add => '建立關聯';
}

// Path: knowledge.tags
class Translations$knowledge$tags$zh_TW extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get all => '所有標籤';
	@override String get manage => '管理標籤';
	@override String get none => '尚無標籤。';
}

// Path: knowledge.graph
class Translations$knowledge$graph$zh_TW extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get truncated => '已截斷';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$zh_TW extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '將所有內容匯入 DDAgent';
	@override String projectsScanned({required Object count}) => '已掃描專案：${count}';
	@override String skillsFound({required Object found, required Object newSkills}) => '找到代理技能：${found}（新增：${newSkills}）';
	@override String rulesSummary({required Object total, required Object duplicates}) => '規則：${total} · 重複群組：${duplicates}';
	@override String get mergeDuplicates => '合併重複項目';
	@override String get mergeDuplicatesHint => '在 DDAgent 中合併重複的資料列（非檔案）';
	@override String get action => '匯入全部';
	@override String get readOnlyNotice => '對你的代理僅唯讀：此操作只會匯入到 DDAgent 自己的資料庫，不會修改或刪除任何 CLI 檔案或設定。以下選項只會變更 DDAgent 資料。';
	@override String get dryRunNote => '試執行——尚未寫入任何內容。';
	@override String get importedNote => '已匯入。';
	@override String result({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => '已匯入——規則：${rules}，新技能：${newSkills}，已移除：${removed}，已提升：${promoted}';
	@override String get description => '掃描所有專案，並將代理的技能匯入知識庫。對代理僅唯讀——不會變更 CLI 中的任何內容。';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$zh_TW extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '移轉現有規則';
	@override String scanned({required Object count}) => '已掃描 ${count} 個專案。';
	@override String rulesSummary({required Object total, required Object critical}) => '規則：共 ${total} 條，${critical} 條嚴重。';
	@override String duplicates({required Object count}) => '跨專案的重複群組：${count}';
	@override String removedPromoted({required Object removed, required Object promoted}) => '已移除：${removed}，已提升：${promoted}';
	@override String get mergeDuplicates => '合併重複項目';
	@override String get dryRunNote => '試執行——尚未進行任何變更。';
	@override String get applied => '已套用。';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$zh_TW extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '匯入代理技能';
	@override String found({required Object count}) => '在你的代理中找到 ${count} 個技能。';
	@override String summary({required Object imported, required Object skipped}) => '新增：${imported} · 略過：${skipped}';
	@override String get dryRunHint => '將代理內建的全域/預設技能（使用者、系統、外掛）匯入為知識技能。試執行——尚未匯入任何內容。';
	@override String get importedNote => '已匯入知識庫。';
}

// Path: knowledge.critical
class Translations$knowledge$critical$zh_TW extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get make => '設為嚴重';
	@override String get makeAll => '將所有規則設為嚴重';
	@override String get makeAllHint => '將它們加入注入的上下文預算';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$zh_TW extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} 權杖';
	@override String get title => '規則上下文（一律提供）';
	@override String get selectProject => '選擇一個專案以查看其關鍵上下文的大小。';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$zh_TW extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => '記憶：${title}';
	@override String rule({required Object title}) => '規則：${title}';
	@override String skill({required Object name}) => '技能：${name}';
	@override String personal({required Object title}) => '個人資訊：${title}';
}

// Path: knowledge.errors
class Translations$knowledge$errors$zh_TW extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => '匯入失敗：${error}';
	@override String migrationFailed({required Object error}) => '移轉失敗：${error}';
}

// Path: knowledge.entityTypes
class Translations$knowledge$entityTypes$zh_TW extends Translations$knowledge$entityTypes$en {
	Translations$knowledge$entityTypes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get memory => '記憶';
	@override String get rule => '規則';
	@override String get skill => '技能';
	@override String get personal => '個人';
	@override String get project => '專案';
	@override String get tag => '標籤';
}

// Path: collab.roles
class Translations$collab$roles$zh_TW extends Translations$collab$roles$en {
	Translations$collab$roles$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get member => '成員';
	@override String get viewer => '檢視者';
}

// Path: collab.viewing
class Translations$collab$viewing$zh_TW extends Translations$collab$viewing$en {
	Translations$collab$viewing$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get session => '工作階段';
	@override String get card => '卡片';
	@override String get board => '看板';
}

// Path: fileTree.search
class Translations$fileTree$search$zh_TW extends Translations$fileTree$search$en {
	Translations$fileTree$search$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get hint => '篩選名稱 / 按 Enter 搜尋內容';
	@override String get prompt => '輸入查詢並按 Enter';
	@override String get noMatches => '沒有符合項目';
	@override String get resultsTruncated => '結果已截斷';
}

// Path: fileTree.titles
class Translations$fileTree$titles$zh_TW extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String rename({required Object name}) => '重新命名 ${name}';
	@override String delete({required Object name}) => '刪除 ${name}';
	@override String download({required Object name}) => '下載 ${name}';
}

// Path: fileTree.relative
class Translations$fileTree$relative$zh_TW extends Translations$fileTree$relative$en {
	Translations$fileTree$relative$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get now => '剛剛';
	@override String minutes({required Object n}) => '${n} 分鐘';
	@override String hours({required Object n}) => '${n} 小時';
	@override String days({required Object n}) => '${n} 天';
}

// Path: git.checkpoints
class Translations$git$checkpoints$zh_TW extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '檢查點';
	@override String get restoreTitle => '還原檢查點';
	@override String get restoreMessage => '要將工作樹重設到此檢查點嗎？目前的變更將被取代。';
	@override String get restored => '檢查點已還原';
	@override String get labelHint => '檢查點標籤（選填）';
	@override String get empty => '尚無檢查點';
	@override String get create => '新增';
}

// Path: git.branchSections
class Translations$git$branchSections$zh_TW extends Translations$git$branchSections$en {
	Translations$git$branchSections$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get local => '本機';
	@override String get remote => '遠端';
}

// Path: kanban.card
class Translations$kanban$card$zh_TW extends Translations$kanban$card$en {
	Translations$kanban$card$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get untitled => '未命名';
}

// Path: kanban.comments
class Translations$kanban$comments$zh_TW extends Translations$kanban$comments$en {
	Translations$kanban$comments$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get empty => '尚無留言';
	@override String get add => '新增留言';
}

// Path: kanban.dialog
class Translations$kanban$dialog$zh_TW extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get saving => '儲存中…';
}

// Path: kanban.details
class Translations$kanban$details$zh_TW extends Translations$kanban$details$en {
	Translations$kanban$details$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '卡片詳細資料';
	@override String status({required Object status}) => '狀態：${status}';
}

// Path: kanban.empty
class Translations$kanban$empty$zh_TW extends Translations$kanban$empty$en {
	Translations$kanban$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get noProject => '未選擇專案';
}

// Path: kanban.time
class Translations$kanban$time$zh_TW extends Translations$kanban$time$en {
	Translations$kanban$time$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get now => '剛剛';
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '1 分鐘前',
		other: '${count} 分鐘前',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '1 小時前',
		other: '${count} 小時前',
	);
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '1 天前',
		other: '${count} 天前',
	);
}

// Path: mcp.install
class Translations$mcp$install$zh_TW extends Translations$mcp$install$en {
	Translations$mcp$install$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '安裝 DDAgent MCP 伺服器';
	@override String get description => '讓所選代理透過 MCP 使用 DDAgent 知識庫與工具。';
	@override String get cardDescription => '透過 MCP 為你的代理提供知識庫與 DDAgent 工具 — 選擇代理，或為全部安裝。';
	@override String get installSelected => '安裝所選項目';
	@override String get installForAll => '為全部安裝';
	@override String get button => '安裝';
	@override String failed({required Object error}) => '安裝失敗：${error}';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '已安裝於 ${count} 個代理。',
		other: '已安裝於 ${count} 個代理。',
	);
	@override String partialFailure({required Object count, required Object failed}) => '已安裝於 ${count} 個；失敗：${failed}';
	@override String get errorFallback => '錯誤';
}

// Path: mcp.servers
class Translations$mcp$servers$zh_TW extends Translations$mcp$servers$en {
	Translations$mcp$servers$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在載入 MCP 伺服器...';
	@override String get refreshingScopes => '正在重新整理專案範圍...';
	@override String descriptionGeneric({required Object provider}) => 'Model Context Protocol 伺服器為 ${provider} 提供額外的工具和資料來源';
	@override String get addGlobalTitle => '新增全域 MCP 伺服器';
	@override String get addGlobalDescription => '將此 MCP 伺服器新增至所有提供者：Claude、Cursor、Codex、OpenCode 和 Devin。由於相同設定必須在所有提供者中運作，因此僅支援 stdio 與 HTTP 傳輸。';
	@override String get addGlobalMenuDescription => '新增全域 MCP 伺服器會將一個通用 stdio 或 HTTP 伺服器寫入 Claude、Cursor、Codex、OpenCode 和 Devin。';
	@override String addProviderTitle({required Object provider}) => '新增 ${provider} MCP 伺服器';
	@override String addProviderDescription({required Object provider}) => '新增 ${provider} MCP 伺服器只會變更 ${provider}。';
	@override late final Translations$mcp$servers$config$zh_TW config = Translations$mcp$servers$config$zh_TW.internal(_root);
	@override String get selectProjectRequired => '請為專案範圍的 MCP 伺服器選擇一個專案';
	@override String get globalScopeUnsupported => '為所有供應商新增 MCP 伺服器時僅支援使用者或專案範圍。';
	@override String globalAddFailed({required Object details}) => '無法將 MCP 伺服器新增至所有供應商。${details}';
	@override String get scopeProject => '專案';
}

// Path: mcp.team
class Translations$mcp$team$zh_TW extends Translations$mcp$team$en {
	Translations$mcp$team$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '團隊 MCP 設定';
	@override String get description => '在團隊中分享 MCP 伺服器設定。所有人都會自動保持同步。';
	@override String get cta => 'DDAgent Pro 提供';
}

// Path: mcp.tokens
class Translations$mcp$tokens$zh_TW extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => '寫入';
	@override String get scopeRead => '讀取';
}

// Path: mcp.form
class Translations$mcp$form$zh_TW extends Translations$mcp$form$en {
	Translations$mcp$form$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String submitTo({required Object provider}) => '將伺服器新增至 ${provider}';
	@override late final Translations$mcp$form$scope$zh_TW scope = Translations$mcp$form$scope$zh_TW.internal(_root);
	@override late final Translations$mcp$form$fields$zh_TW fields = Translations$mcp$form$fields$zh_TW.internal(_root);
	@override late final Translations$mcp$form$validation$zh_TW validation = Translations$mcp$form$validation$zh_TW.internal(_root);
}

// Path: notifications.errors
class Translations$notifications$errors$zh_TW extends Translations$notifications$errors$en {
	Translations$notifications$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get registrationRejected => '伺服器拒絕註冊';
	@override String get noResponse => '伺服器沒有回應';
}

// Path: notifications.androidChannel
class Translations$notifications$androidChannel$zh_TW extends Translations$notifications$androidChannel$en {
	Translations$notifications$androidChannel$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get name => 'DDAgent 警示';
	@override String get description => '代理程式執行、核准與錯誤通知';
}

// Path: onboarding.errors
class Translations$onboarding$errors$zh_TW extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get nameAndEmailRequired => 'git 名稱與電子郵件皆為必填。';
	@override String get invalidEmail => '請輸入有效的電子郵件地址。';
}

// Path: onboarding.agents
class Translations$onboarding$agents$zh_TW extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '連接你的 AI 代理';
	@override String get description => '登入一個或多個 AI 程式開發助手。全部皆為選填。';
	@override String get laterHint => '你可以稍後在設定中進行設定。';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$zh_TW extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '將代理連接到 DDAgent';
	@override String get description => '安裝 DDAgent MCP 伺服器，讓你的代理可以使用知識庫與 DDAgent 工具。選擇代理，或為全部安裝。';
	@override String get installSelected => '安裝所選項目';
	@override String get installForAll => '為全部安裝';
	@override String get laterHint => '選填 — 你也可以稍後在設定 → MCP 中安裝。';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '已安裝於 ${count} 個代理。',
		other: '已安裝於 ${count} 個代理。',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => '已安裝於 ${installedCount} 個；失敗：${failed}';
}

// Path: quota.section
class Translations$quota$section$zh_TW extends Translations$quota$section$en {
	Translations$quota$section$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get config => '設定';
}

// Path: quota.overview
class Translations$quota$overview$zh_TW extends Translations$quota$overview$en {
	Translations$quota$overview$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => '權杖與成本';
}

// Path: quota.agents
class Translations$quota$agents$zh_TW extends Translations$quota$agents$en {
	Translations$quota$agents$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status}（${count}）';
}

// Path: quota.config
class Translations$quota$config$zh_TW extends Translations$quota$config$en {
	Translations$quota$config$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get pollerTitle => '輪詢器與警示';
	@override String get accountRouting => '帳戶路由';
	@override String get save => '儲存設定';
}

// Path: quota.chart
class Translations$quota$chart$zh_TW extends Translations$quota$chart$en {
	Translations$quota$chart$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get show => '顯示';
	@override String get hide => '隱藏';
	@override String get noData => '資料不足以顯示趨勢。';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} 權杖 · ${cost}';
}

// Path: quota.duration
class Translations$quota$duration$zh_TW extends Translations$quota$duration$en {
	Translations$quota$duration$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String minutes({required Object minutes}) => '${minutes} 分鐘';
	@override String hoursMinutes({required Object hours, required Object minutes}) => '${hours} 小時 ${minutes} 分鐘';
	@override String daysHours({required Object days, required Object hours}) => '${days} 天 ${hours} 小時';
	@override String get now => '剛剛';
}

// Path: scheduler.runStatus
class Translations$scheduler$runStatus$zh_TW extends Translations$scheduler$runStatus$en {
	Translations$scheduler$runStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get fired => '已觸發';
	@override String get skipped => '已略過';
	@override String get failed => '失敗';
	@override String get completed => '已完成';
}

// Path: scheduler.cronErrors
class Translations$scheduler$cronErrors$zh_TW extends Translations$scheduler$cronErrors$en {
	Translations$scheduler$cronErrors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String fieldCount({required Object got}) => '需要 5 個欄位，實際為 ${got} 個';
	@override String fieldError({required Object index, required Object error}) => '欄位 ${index}：${error}';
	@override String get empty => '為空';
	@override String invalidPart({required Object part}) => '無效的「${part}」';
	@override String invalidValue({required Object value}) => '無效值「${value}」';
}

// Path: serverConnect.local
class Translations$serverConnect$local$zh_TW extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '此裝置';
	@override String get subtitle => '在此電腦上執行 DDAgent 伺服器';
	@override String get install => '安裝本機伺服器';
	@override String get start => '啟動本機伺服器';
	@override String get stop => '停止';
	@override String get starting => '正在啟動本機伺服器…';
	@override String downloading({required Object percent}) => '正在下載伺服器… ${percent}%';
	@override String get installing => '正在安裝…';
	@override String running({required Object url}) => '正在 ${url} 上執行';
	@override String installed({required Object version}) => '已安裝 (v${version})';
	@override String get connect => '使用此伺服器';
	@override String error({required Object error}) => '本機伺服器錯誤：${error}';
	@override String get or => '或連線到遠端伺服器';
	@override late final Translations$serverConnect$local$errors$zh_TW errors = Translations$serverConnect$local$errors$zh_TW.internal(_root);
}

// Path: sessions.toasts
class Translations$sessions$toasts$zh_TW extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get archived => '工作階段已封存';
	@override String get restored => '工作階段已還原';
	@override String get deleted => '工作階段已刪除';
	@override String get renamed => '工作階段已重新命名';
	@override String get pinned => '工作階段已釘選';
	@override String get unpinned => '工作階段已取消釘選';
	@override String get workspaceChanged => '工作區已變更';
}

// Path: sessions.age
class Translations$sessions$age$zh_TW extends Translations$sessions$age$en {
	Translations$sessions$age$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get lessThanMinute => '<1 分鐘';
	@override String minutes({required Object count}) => '${count} 分鐘';
	@override String hours({required Object hours}) => '${hours} 小時';
	@override String days({required Object days}) => '${days} 天';
}

// Path: sessions.activity
class Translations$sessions$activity$zh_TW extends Translations$sessions$activity$en {
	Translations$sessions$activity$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get subagentRunning => '子代理執行中';
	@override String readingFile({required Object file}) => '正在讀取 ${file}';
	@override String runningTool({required Object name}) => '正在執行 ${name}';
	@override String editingFile({required Object file}) => '正在編輯 ${file}';
	@override String get editingFileGeneric => '正在編輯檔案';
	@override String get runningShellCommand => '正在執行 Shell 指令';
	@override String runningCommand({required Object command}) => '正在執行 `${command}`';
	@override String get committingChanges => '正在提交變更';
	@override String get pushingBranch => '正在推送分支';
	@override String fetchingUrl({required Object url}) => '正在取得 ${url}';
	@override String searching({required Object query}) => '正在搜尋「${query}」';
}

// Path: skills.addDialog
class Translations$skills$addDialog$zh_TW extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => '新增 ${provider} 技能';
	@override String get chooseFileTitle => '選擇 SKILL.md';
	@override String get chooseFolderTitle => '選擇技能資料夾';
	@override String get uploadHint => '上傳 SKILL.md 檔案或完整的技能資料夾。';
	@override String get pickTitle => '選擇技能資料夾或 SKILL.md';
	@override String get pickHint => '資料夾可包含指令碼、參考資料與資源。';
	@override String get chooseFiles => '選擇檔案';
	@override String get chooseFolder => '選擇資料夾';
	@override String get readyToInstall => '可以安裝了';
	@override String markdownFileMeta({required Object size}) => 'Markdown 檔案 · ${size}';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個檔案 · ${size}',
		other: '${count} 個檔案 · ${size}',
	);
	@override String removeQueued({required Object name}) => '移除 ${name}';
	@override String get whereWillThisInstall => '這會安裝到哪裡？';
	@override String get hideInstallLocation => '隱藏安裝位置';
	@override String get folderUploadsNote => '資料夾上傳會保留所選資料夾名稱；獨立檔案則使用 `SKILL.md` 中的 `name`。';
	@override String get installSkill => '安裝技能';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '安裝 ${count} 個技能',
		other: '安裝 ${count} 個技能',
	);
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$zh_TW extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get toProjectHint => '選擇應擁有此技能的專案。它會移出提供者的全域技能目錄。';
	@override String get toGlobalHint => '將此技能移至全域技能目錄，讓所有專案都能使用。';
	@override String get moveToProject => '移至專案';
	@override String get moveToGlobal => '移至全域';
}

// Path: skills.screen
class Translations$skills$screen$zh_TW extends Translations$skills$screen$en {
	Translations$skills$screen$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String manageDescription({required Object provider}) => '從本機檔案、完整資料夾和專案感知位置管理 ${provider} 技能。';
	@override String get searchHint => '搜尋技能...';
	@override String get clearSearch => '清除技能搜尋';
	@override String get addSkill => '新增技能';
	@override String get scanningProjectSkills => '正在掃描專案技能...';
	@override String get savedSuccessfully => '技能已成功儲存。';
	@override String loadingSkills({required Object provider}) => '正在載入 ${provider} 技能…';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個技能',
		other: '${count} 個技能',
	);
	@override String deleteTitle({required Object name}) => '刪除 ${name}？';
	@override String deleteDescription({required Object provider, required Object directory}) => '這會從 ${provider} 的受管理技能目錄中移除 ${directory} 目錄。此操作無法復原。';
	@override String get noDescription => '技能前置資料中未提供說明。';
	@override String pluginBadge({required Object name}) => '外掛：${name}';
	@override String projectBadge({required Object name}) => '專案：${name}';
	@override String get sourceLabel => '來源';
}

// Path: skills.empty
class Translations$skills$empty$zh_TW extends Translations$skills$empty$en {
	Translations$skills$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get noProjects => '沒有可用的專案';
	@override String get noProjectsDescription => '新增專案或工作區以瀏覽其技能。';
	@override String get noSkillsInProject => '此專案沒有技能';
	@override String get noSkillsInProjectDescription => '在所選專案中建立 .claude/skills、.cursor/skills 或 .agents/skills 資料夾。';
	@override String get noGlobalSkills => '尚未找到全域技能';
	@override String get noGlobalSkillsDescription => '在上方新增全域技能，即可在所有專案中使用。';
	@override String get noMatchingSkills => '沒有符合的技能';
	@override String get noMatchingSkillsDescription => '請嘗試不同的指令、名稱、範圍、專案或來源路徑。';
}

// Path: skills.scopes
class Translations$skills$scopes$zh_TW extends Translations$skills$scopes$en {
	Translations$skills$scopes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get user => '使用者';
	@override String get plugin => '外掛';
	@override String get repo => '儲存庫';
	@override String get project => '專案';
	@override String get admin => '管理員';
	@override String get system => '系統';
}

// Path: skills.errors
class Translations$skills$errors$zh_TW extends Translations$skills$errors$en {
	Translations$skills$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dropMarkdownOrFolder => '拖放一個或多個 Markdown 檔案，或包含 SKILL.md 的資料夾。';
	@override String get addMarkdownFirst => '請先新增一個或多個 Markdown 檔案。';
	@override String get importFailed => '匯入技能失敗';
	@override String get folderReadFailed => '讀取技能資料夾失敗';
	@override String folderFileLimit({required Object count}) => '一個技能資料夾最多可包含 ${count} 個檔案。';
	@override String get folderSizeLimit => '所選技能資料夾的總大小必須小於 30 MB。';
	@override String get missingSkillFile => '所選資料夾不包含 SKILL.md 檔案。';
	@override String couldNotReadSkillFile({required Object name}) => '無法從 ${name} 讀取 SKILL.md。';
}

// Path: terminal.tabs
class Translations$terminal$tabs$zh_TW extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String shellName({required Object index}) => 'Shell ${index}';
	@override String get plainShell => '一般 Shell';
	@override String get claudeCli => 'Claude CLI';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => '登入：${provider}';
	@override String runTitle({required Object command}) => '執行：${command}';
}

// Path: terminal.actions
class Translations$terminal$actions$zh_TW extends Translations$terminal$actions$en {
	Translations$terminal$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get newTab => '新增終端機分頁';
	@override String get providerLogin => '提供者登入';
	@override String get restartSession => '重新啟動工作階段';
	@override String get clearOutput => '清除輸出';
	@override String get newShell => '新增 Shell';
	@override String get connect => '連線';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$zh_TW extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => '在瀏覽器中開啟';
	@override String linkLabel({required Object url}) => '驗證連結：${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$zh_TW extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => '偵測到檔案：${path}';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$zh_TW extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get interrupt => '中斷 (SIGINT)';
	@override String get eof => 'EOF';
	@override String get suspend => '暫停 (SIGTSTP)';
	@override String get hide => '隱藏快速鍵列';
	@override String get showTooltip => '顯示快速鍵';
	@override String get hideTooltip => '隱藏快速鍵';
}

// Path: terminal.paste
class Translations$terminal$paste$zh_TW extends Translations$terminal$paste$en {
	Translations$terminal$paste$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '貼上至終端機';
	@override String get hint => 'Ctrl+V / 按右鍵 → 貼上';
}

// Path: terminal.errors
class Translations$terminal$errors$zh_TW extends Translations$terminal$errors$en {
	Translations$terminal$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => '無法開啟連結：${url}';
	@override String frameError({required Object message}) => '[錯誤] ${message}';
	@override String connectionError({required Object message}) => '[連線錯誤] ${message}';
}

// Path: terminal.loginDialog
class Translations$terminal$loginDialog$zh_TW extends Translations$terminal$loginDialog$en {
	Translations$terminal$loginDialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String title({required Object provider}) => '${provider} CLI 登入';
	@override String exited({required Object code}) => '已結束（${code}）';
	@override String get authLinkDetected => '偵測到驗證連結';
}

// Path: terminal.empty
class Translations$terminal$empty$zh_TW extends Translations$terminal$empty$en {
	Translations$terminal$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '沒有作用中的終端機';
	@override String get description => '建立新分頁以開始';
}

// Path: terminal.overlay
class Translations$terminal$overlay$zh_TW extends Translations$terminal$overlay$en {
	Translations$terminal$overlay$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get processExited => '程序已結束 — 連線以重新啟動';
	@override String processExitedWithCode({required Object code}) => '程序已結束（代碼 ${code}）— 連線以重新啟動';
	@override String resumeSession({required Object title}) => '繼續工作階段 ${title}';
	@override String startSession({required Object path}) => '在 ${path} 中開始新的工作階段';
}

// Path: workspace.paneTitle
class Translations$workspace$paneTitle$zh_TW extends Translations$workspace$paneTitle$en {
	Translations$workspace$paneTitle$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get chat => '聊天';
	@override String get browser => '瀏覽器';
	@override String get terminal => '終端機';
	@override String get notes => '共用筆記';
	@override String get editor => '編輯器';
	@override String get git => 'Git';
}

// Path: worktrees.runtimeStatus
class Translations$worktrees$runtimeStatus$zh_TW extends Translations$worktrees$runtimeStatus$en {
	Translations$worktrees$runtimeStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get idle => '閒置';
	@override String get running => '執行中';
	@override String get done => '已完成';
	@override String get failed => '失敗';
	@override String get exited => '已結束';
}

// Path: browserUse.sessionStatus
class Translations$browserUse$sessionStatus$zh_TW extends Translations$browserUse$sessionStatus$en {
	Translations$browserUse$sessionStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get ready => '就緒';
	@override String get stopped => '已停止';
	@override String get unavailable => '無法使用';
}

// Path: miniOrchestrator.taskTypes
class Translations$miniOrchestrator$taskTypes$zh_TW extends Translations$miniOrchestrator$taskTypes$en {
	Translations$miniOrchestrator$taskTypes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get gate => '關卡';
}

// Path: miniOrchestrator.roles
class Translations$miniOrchestrator$roles$zh_TW extends Translations$miniOrchestrator$roles$en {
	Translations$miniOrchestrator$roles$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get thinker => '思考者';
	@override String get worker => '執行者';
}

// Path: auth.login.errors
class Translations$auth$login$errors$zh_TW extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => '使用者名稱或密碼無效';
	@override String get requiredFields => '請填寫所有欄位';
	@override String get networkError => '網路錯誤，請重試。';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$zh_TW extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get username => '輸入您的使用者名稱';
	@override String get password => '輸入您的密碼';
}

// Path: auth.register.errors
class Translations$auth$register$errors$zh_TW extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => '密碼不一致';
	@override String get usernameTaken => '使用者名稱已被使用';
	@override String get weakPassword => '密碼強度太弱';
	@override String get usernameTooShort => '使用者名稱至少需要 3 個字元';
	@override String get passwordTooShort => '密碼至少需要 6 個字元';
}

// Path: chat.orchestrator.routing
class Translations$chat$orchestrator$routing$zh_TW extends Translations$chat$orchestrator$routing$en {
	Translations$chat$orchestrator$routing$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '路由';
	@override String alternatives({required Object list}) => '備選：${list}';
	@override String first({required Object label, required Object task}) => '${label} — ${task} 的首選候選';
	@override String skipped({required Object label, required Object list}) => '${label} — 已略過較前的候選（${list}）';
}

// Path: chat.orchestrator.plan
class Translations$chat$orchestrator$plan$zh_TW extends Translations$chat$orchestrator$plan$en {
	Translations$chat$orchestrator$plan$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '計畫';
	@override String get disabled => '已停用';
	@override String get awaitingConfirm => '正在等待確認計畫。';
	@override String get run => '執行計畫';
	@override String get toggleStep => '啟用步驟';
	@override String get confirmFailed => '啟動失敗，請再試一次。';
	@override String get fallback => '規劃器無法使用 — 改為單一步驟';
	@override String get templateSource => '來自流程範本';
	@override String get offSource => '規劃器已關閉';
	@override String stepCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個步驟',
		other: '${count} 個步驟',
	);
	@override String get supervisedSource => '監督迴圈';
}

// Path: chat.orchestrator.decision
class Translations$chat$orchestrator$decision$zh_TW extends Translations$chat$orchestrator$decision$en {
	Translations$chat$orchestrator$decision$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '監督者決策';
	@override String iteration({required Object n}) => '第 ${n} 輪';
	@override String get rationaleLabel => '原因';
	@override String get awaitingConfirm => '執行這些步驟前，正在等待你的核准。';
	@override String get proposedSteps => '建議步驟';
	@override late final Translations$chat$orchestrator$decision$action$zh_TW action = Translations$chat$orchestrator$decision$action$zh_TW.internal(_root);
	@override late final Translations$chat$orchestrator$decision$outcome$zh_TW outcome = Translations$chat$orchestrator$decision$outcome$zh_TW.internal(_root);
}

// Path: chat.orchestrator.delegation
class Translations$chat$orchestrator$delegation$zh_TW extends Translations$chat$orchestrator$delegation$en {
	Translations$chat$orchestrator$delegation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '委派步驟';
	@override String get openSession => '開啟完整工作階段';
	@override String attempt({required Object n}) => '第 ${n} 次嘗試';
	@override String get retryStep => '重試／修正';
	@override String get continueStep => '繼續／修正';
	@override String get continueFailed => '失敗，請再試一次。';
	@override late final Translations$chat$orchestrator$delegation$status$zh_TW status = Translations$chat$orchestrator$delegation$status$zh_TW.internal(_root);
	@override String attempts({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 次嘗試',
		other: '${count} 次嘗試',
	);
	@override String candidates({required Object list}) => '候選：${list}';
	@override String candidateCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 個候選',
		other: '${count} 個候選',
	);
}

// Path: chat.orchestrator.summary
class Translations$chat$orchestrator$summary$zh_TW extends Translations$chat$orchestrator$summary$en {
	Translations$chat$orchestrator$summary$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '摘要';
	@override String progress({required Object done, required Object total}) => '已完成步驟：${done}/${total}';
	@override String get aborted => '已中止';
	@override String get timedOut => '已逾時';
	@override String get capped => '已達迭代上限';
	@override String failed({required Object list}) => '失敗的步驟：${list}';
	@override String get kContinue => '繼續';
	@override String get continueWork => '繼續工作';
	@override String get resumeFailed => '無法繼續執行，請再試一次。';
	@override String get runNextTask => '執行下一個任務';
	@override String get endAllTasks => '結束所有任務';
	@override String get tasksRunning => '正在處理任務…';
	@override String get cancelTasks => '取消';
}

// Path: chat.orchestrator.taskmaster
class Translations$chat$orchestrator$taskmaster$zh_TW extends Translations$chat$orchestrator$taskmaster$en {
	Translations$chat$orchestrator$taskmaster$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '任務佇列';
	@override String remaining({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '剩餘 ${count} 個',
		other: '剩餘 ${count} 個',
	);
	@override late final Translations$chat$orchestrator$taskmaster$status$zh_TW status = Translations$chat$orchestrator$taskmaster$status$zh_TW.internal(_root);
}

// Path: chat.orchestrator.gate
class Translations$chat$orchestrator$gate$zh_TW extends Translations$chat$orchestrator$gate$en {
	Translations$chat$orchestrator$gate$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get timedOut => '已逾時';
	@override String exit({required Object code}) => '結束代碼 ${code}';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$zh_TW extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '預設模式';
	@override String get auto => '自動模式';
	@override String get acceptEdits => '編輯模式';
	@override String get bypassPermissions => '無限制模式';
	@override String get plan => '計畫模式';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$zh_TW extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '只有受信任的指令（ls、cat、grep、git status 等）自動執行。其他指令將被略過。可以寫入工作區。';
	@override String get auto => '由模型分類器針對每次工具呼叫決定核准或拒絕。免手動操作，但比 Bypass 安全——仍可能發生拒絕。';
	@override String get acceptEdits => '工作區內的所有指令自動執行。完全自動模式，具有沙箱執行功能。';
	@override String get bypassPermissions => '完全的系統存取，無限制。所有指令自動執行，具有完整的磁碟和網路存取權限。請謹慎使用。';
	@override String get plan => '計畫模式 - 不執行任何指令';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$zh_TW extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter 傳送 • / 指令 • @ 檔案';
	@override String get enter => 'Enter 傳送 • Shift+Enter 換行 • / 指令 • @ 檔案';
	@override String get queue => '按 Enter 將下一則訊息排入佇列';
	@override String get updateQueued => '按 Enter 更新佇列中的訊息';
}

// Path: chat.input.queue
class Translations$chat$input$queue$zh_TW extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get sendNext => '將下一則訊息排入佇列';
	@override String get update => '更新佇列中的訊息';
	@override String get label => '已排入佇列';
	@override String get willSend => '完成後將傳送';
	@override String get edit => '編輯佇列中的訊息';
	@override String get delete => '刪除佇列中的訊息';
	@override String get failed => '傳送失敗';
	@override String get sendNow => '立即傳送';
	@override String get sendNowAfterTurn => '此代理無法在回合進行中接收訊息——將在目前回合結束後傳送';
	@override String filesAttached({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		other: '已附加 ${count} 個檔案',
	);
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$zh_TW extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get clear => '取消並清空離線佇列';
	@override String get clearBtn => '取消';
	@override String multiple({required Object count}) => '${count} 則訊息在離線佇列中 — 重新連線後將自動傳送';
	@override String get single => '1 則訊息在離線佇列中 — 重新連線後將自動傳送';
}

// Path: chat.composer.effortLevels
class Translations$chat$composer$effortLevels$zh_TW extends Translations$chat$composer$effortLevels$en {
	Translations$chat$composer$effortLevels$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get off => '關閉';
	@override String get none => '無';
	@override String get minimal => '最低';
	@override String get low => '低';
	@override String get medium => '中';
	@override String get high => '高';
	@override String get xhigh => '極高';
	@override String get max => '最大';
	@override String get ultra => '超高';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$zh_TW extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get anthropic => '由 Anthropic 提供';
	@override String get openai => '由 OpenAI 提供';
	@override String get cursorEditor => 'AI 程式碼編輯器';
	@override String get google => '由 Google 提供';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$zh_TW extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => '準備好使用 ${model} 的 Claude。請在下方開始輸入您的訊息。';
	@override String cursor({required Object model}) => '準備好使用 ${model} 的 Cursor。請在下方開始輸入您的訊息。';
	@override String codex({required Object model}) => '準備好使用 ${model} 的 Codex。請在下方開始輸入您的訊息。';
	@override String opencode({required Object model}) => 'OpenCode 搭配 ${model} 已就緒。請在下方輸入你的訊息。';
	@override String get kDefault => '請在上方選擇一個提供者以開始';
	@override String devin({required Object model}) => 'Devin ${model} 已就緒';
	@override String get orchestrator => '「自動」已就緒 — 路由器會為每個步驟挑選最適合的模型';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$zh_TW extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '繼續您的對話';
	@override String get description => '詢問有關程式碼的問題、要求修改或取得開發任務的協助';
	@override String get action => '繼續輸入';
}

// Path: chat.session.loading
class Translations$chat$session$loading$zh_TW extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => '正在載入較早的訊息...';
	@override String get sessionMessages => '正在載入工作階段訊息...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$zh_TW extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => '顯示 ${shown} / ${total} 則訊息';
	@override String get scrollToLoad => '向上捲動以載入更多';
	@override String showingLast({required Object count, required Object total}) => '顯示最近 ${count} 則訊息（共 ${total} 則）';
	@override String get loadEarlier => '載入較早的訊息';
	@override String get loadOlderFailed => '載入較早訊息失敗。';
	@override String get retry => '重試';
	@override String get loadAll => '載入全部訊息';
	@override String get loadingAll => '正在載入全部訊息...';
	@override String get allLoaded => '全部訊息已載入';
	@override String get perfWarning => '已載入全部訊息 - 捲動可能變慢。點擊「捲動到底部」恢復效能。';
	@override String get noSearchMatches => '沒有訊息符合搜尋。';
	@override String get loadOlder => '載入較早的訊息';
	@override String loadAllCount({required Object count}) => '載入全部（${count}）';
	@override String retryLoadOlder({required Object error}) => '重試載入較早訊息 — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$zh_TW extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '選擇專案';
	@override String get description => '選擇一個專案以在該目錄中開啟互動式 Shell';
}

// Path: chat.shell.status
class Translations$chat$shell$status$zh_TW extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get newSession => '新工作階段';
	@override String get initializing => '初始化中...';
	@override String get restarting => '重新啟動中...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$zh_TW extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get disconnect => '中斷連線';
	@override String get disconnectTitle => '中斷 Shell 連線';
	@override String get restart => '重新啟動';
	@override String get restartTitle => '重新啟動 Shell（請先中斷連線）';
	@override String get kill => '終止 (SIGINT)';
	@override String get killTitle => '終止執行中的程序 (Ctrl+C)';
	@override String get copyOutput => '複製輸出';
	@override String get copyOutputTitle => '複製終端機輸出';
	@override String get copied => '已複製！';
	@override String get zoomInTitle => '放大';
	@override String get zoomOutTitle => '縮小';
	@override String get connect => '在 Shell 中繼續';
	@override String get connectTitle => '連線到 Shell';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$zh_TW extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get thinking => '思考中';
	@override String get processing => '處理中';
	@override String get analyzing => '分析中';
	@override String get working => '執行中';
	@override String get computing => '運算中';
	@override String get reasoning => '推理中';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$zh_TW extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get live => '進行中';
	@override String get paused => '已暫停';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$zh_TW extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}秒';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes} 分 ${seconds} 秒';
	@override String label({required Object time}) => '已過 ${time}';
	@override String get startingNow => '正要開始';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$zh_TW extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => '停止生成';
	@override String get pressEscToStop => '隨時按 Esc 即可停止';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$zh_TW extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get assistant => '助理';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$zh_TW extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get models => '瀏覽使用中提供者的可用模型。';
	@override String get cost => '檢視使用中工作階段的權杖用量。';
	@override String get status => '檢查執行階段、版本、提供者與環境狀態。';
	@override String get memory => '開啟專案的 CLAUDE.md 記憶檔案。';
	@override String get config => '開啟設定與組態。';
	@override String get help => '顯示指令文件與語法。';
}

// Path: chat.permissionRequest.recap
class Translations$chat$permissionRequest$recap$zh_TW extends Translations$chat$permissionRequest$recap$en {
	Translations$chat$permissionRequest$recap$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get timedOut => '已逾時 — 已自動拒絕';
	@override String get cancelled => '已取消 — 本輪已停止';
	@override String get autoApproved => '已自動核准';
	@override String get expired => '請求已過期 — 代理不再等待';
	@override String get answered => '已回答';
	@override String get skipped => '已略過';
	@override String get decided => '已決定';
}

// Path: chat.commandDialog.help
class Translations$chat$commandDialog$help$zh_TW extends Translations$chat$commandDialog$help$en {
	Translations$chat$commandDialog$help$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => '命令中心';
	@override String get title => '說明與快捷方式';
	@override String get subtitle => '搜尋內建命令、語法模式與命令用法。';
}

// Path: chat.commandDialog.models
class Translations$chat$commandDialog$models$zh_TW extends Translations$chat$commandDialog$models$en {
	Translations$chat$commandDialog$models$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => '模型選擇';
	@override String get title => '選擇模型';
	@override String get subtitle => '選擇此供應商要使用的模型。';
	@override String modelSetTo({required Object model}) => '模型已設定為 ${model}。';
	@override String get activeModel => '目前模型';
	@override String get noModelsMatch => '沒有符合此篩選條件的模型。';
	@override String get choiceSavedForSession => '你的選擇會儲存到此工作階段，並成為新聊天的預設值。';
	@override String get choiceDefault => '你的選擇將成為新聊天的預設模型。';
	@override String get custom => '自訂';
	@override String get currentSelection => '目前選擇';
}

// Path: chat.commandDialog.cost
class Translations$chat$commandDialog$cost$zh_TW extends Translations$chat$commandDialog$cost$en {
	Translations$chat$commandDialog$cost$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => '工作階段遙測';
	@override String get title => 'Token 用量';
	@override String get subtitle => '此工作階段的輸入、輸出與總 token 數。';
	@override String get totalTokensUsed => '已用 token 總數';
	@override String get inputTokens => '輸入 token';
	@override String get cacheReadTokens => '快取讀取 token';
	@override String get cacheWriteTokens => '快取寫入 token';
	@override String get outputTokens => '輸出 token';
	@override String get breakdown => '明細';
	@override String get unavailable => '無法使用';
	@override String get contextWindow => '上下文視窗';
	@override String get estimatedCost => '預估費用';
}

// Path: chat.commandDialog.status
class Translations$chat$commandDialog$status$zh_TW extends Translations$chat$commandDialog$status$en {
	Translations$chat$commandDialog$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => '執行階段健康狀態';
	@override String get title => '系統狀態';
	@override String get subtitle => '版本、供應商、執行階段與環境詳細資料。';
	@override String get package => '套件';
	@override String get uptime => '運作時間';
	@override String get platform => '平台';
	@override String get memory => '記憶體';
	@override String memoryRss({required Object mb}) => '${mb} MB RSS';
	@override String get runtimeOnline => '執行階段上線中';
	@override String processResponding({required Object pid}) => '程序 #${pid} 正在回應。';
	@override String get processStatusResponding => '程序正在回應。';
	@override String get healthy => '正常';
}

// Path: chat.commandDialog.syntax
class Translations$chat$commandDialog$syntax$zh_TW extends Translations$chat$commandDialog$syntax$en {
	Translations$chat$commandDialog$syntax$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '語法';
	@override String arguments({required Object arguments, required Object first, required Object second}) => '${arguments} 傳遞所有引數；${first}、${second} 為位置引數。';
	@override String file({required Object token}) => '${token} 會包含檔案內容。';
	@override String bash({required Object token}) => '${token} 執行 bash。';
}

// Path: chat.utilities.tooltip
class Translations$chat$utilities$tooltip$zh_TW extends Translations$chat$utilities$tooltip$en {
	Translations$chat$utilities$tooltip$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String tokensUsed({required Object tokens}) => '已用 ${tokens} token';
	@override String contextOf({required Object percent, required Object total}) => '上下文 ${percent}% / ${total}';
	@override String input({required Object value}) => '輸入 ${value}';
	@override String cache({required Object read, required Object write}) => '快取讀取 ${read} · 寫入 ${write}';
	@override String output({required Object value}) => '輸出 ${value}';
}

// Path: chat.toolBlocks.status
class Translations$chat$toolBlocks$status$zh_TW extends Translations$chat$toolBlocks$status$en {
	Translations$chat$toolBlocks$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get running => '執行中';
	@override String get denied => '已拒絕';
}

// Path: chat.toolBlocks.verbs
class Translations$chat$toolBlocks$verbs$zh_TW extends Translations$chat$toolBlocks$verbs$en {
	Translations$chat$toolBlocks$verbs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get read => '讀取';
	@override String get write => '寫入';
	@override String get edit => '編輯';
	@override String get delete => '刪除';
	@override String get move => '移動';
}

// Path: chat.commandMenu.namespaces
class Translations$chat$commandMenu$namespaces$zh_TW extends Translations$chat$commandMenu$namespaces$en {
	Translations$chat$commandMenu$namespaces$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get frequent => '常用';
	@override String get builtin => '內建指令';
	@override String get skill => '技能';
	@override String get project => '專案指令';
	@override String get user => '使用者指令';
	@override String get other => '其他指令';
}

// Path: chat.mentionMenu.kinds
class Translations$chat$mentionMenu$kinds$zh_TW extends Translations$chat$mentionMenu$kinds$en {
	Translations$chat$mentionMenu$kinds$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get file => '檔案';
	@override String get session => '工作階段';
	@override String get task => '任務';
}

// Path: common.quota.section
class Translations$common$quota$section$zh_TW extends Translations$common$quota$section$en {
	Translations$common$quota$section$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get overview => '總覽';
	@override String get quotas => '額度';
	@override String get usage => '用量';
	@override String get agents => '代理';
}

// Path: common.quota.filter
class Translations$common$quota$filter$zh_TW extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get all => '全部';
}

// Path: common.quota.period
class Translations$common$quota$period$zh_TW extends Translations$common$quota$period$en {
	Translations$common$quota$period$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 天';
	@override String get k30d => '30 天';
	@override String get all => '全部';
}

// Path: common.quota.group
class Translations$common$quota$group$zh_TW extends Translations$common$quota$group$en {
	Translations$common$quota$group$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get provider => '提供者';
	@override String get model => '模型';
	@override String get agent => '代理';
	@override String get tool => '工具';
}

// Path: common.quota.metric
class Translations$common$quota$metric$zh_TW extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get tokens => '權杖';
	@override String get input => '輸入';
	@override String get output => '輸出';
	@override String get cache => '快取讀取';
	@override String get calls => 'API 呼叫';
	@override String get cost => '成本';
	@override String get sessions => '工作階段';
}

// Path: common.quota.cost
class Translations$common$quota$cost$zh_TW extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get billed => '已計費（API + 超額）';
	@override String get listPrice => '已用權杖的標價';
	@override String get subscriptionValue => '訂閱涵蓋';
	@override String get cacheSavings => '快取節省';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$zh_TW extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get billed => '已計費（API + 超額）';
	@override String get listPrice => '已用權杖的標價';
	@override String get subscriptionValue => '訂閱涵蓋';
}

// Path: common.quota.overview
class Translations$common$quota$overview$zh_TW extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '權杖與成本 — 最近 7 天';
	@override String get effectiveCost => '實際成本（7 天）';
	@override String get alertsTitle => '警示';
	@override String get noAlerts => '目前沒有需要注意的事項。';
	@override String get limitsTitle => '用量與限額';
	@override String get activeTasks => '活躍任務';
	@override String get viewAccounts => '所有帳戶';
	@override String get viewAgents => '所有代理';
	@override String get noTasks => '目前沒有正在執行的代理。';
}

// Path: common.quota.usage
class Translations$common$quota$usage$zh_TW extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '每日趨勢';
	@override String breakdownTitle({required Object group}) => '依 ${group} 細分';
	@override String get colName => '名稱';
	@override String get sourceUnavailable => '分析儲存不可用；未顯示資料。';
}

// Path: common.quota.agents
class Translations$common$quota$agents$zh_TW extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} 個執行中';
	@override String get colAgent => '代理';
	@override String get colStatus => '狀態';
	@override String get colTask => '任務';
	@override String get colModel => '帳戶 / 模型';
	@override String get colTime => '時間';
	@override String get empty => '沒有代理符合此篩選條件。';
	@override String get detailSession => '工作階段';
	@override String get detailStarted => '已開始';
	@override String get detailRetries => '重試次數';
	@override String get detailResult => '結果';
	@override String get notTracked => '未追蹤';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$zh_TW extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get running => '執行中';
	@override String get waiting => '等待中';
	@override String get failed => '失敗';
	@override String get finished => '已完成';
	@override String get queued => '排隊中';
}

// Path: common.quota.alert
class Translations$common$quota$alert$zh_TW extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}：按目前速度，額度將在 ${value} 後耗盡';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}：已用 ${value}%（閾值 ${watch}%）';
}

// Path: common.quota.quality
class Translations$common$quota$quality$zh_TW extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get live => '即時';
	@override String get cached => '快取';
	@override String get estimate => '估計';
	@override String get unknown => '未知';
	@override String get error => '錯誤';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$zh_TW extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get atRisk => '有風險的額度';
	@override String atRiskHint({required Object value}) => '超過 ${value}% 的帳戶';
	@override String get windowsAtRisk => '即將耗盡的窗口';
	@override String get errored => '同步失敗';
	@override String get activeAgents => '活躍代理';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} 等待 · ${queued} 排隊';
	@override String get nextReset => '下次重置';
	@override String get tokens => '權杖';
	@override String sessionsHint({required Object value}) => '${value} 個工作階段';
	@override String get cost => '預估成本';
	@override String costHint({required Object value}) => '${value} 由方案涵蓋';
}

// Path: common.quota.empty
class Translations$common$quota$empty$zh_TW extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '未連接任何帳戶';
	@override String get description => '登入 Claude、Codex、Gemini 或 CommandCode 即可在此追蹤額度。';
}

// Path: common.quota.settings
class Translations$common$quota$settings$zh_TW extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '警示與路由';
	@override String get description => '控制儀表板何時警告你，以及如何為新工作建議帳戶。';
	@override String get alertsEnabled => '預測與閾值警示';
	@override String get alertsEnabledHint => '在額度按目前速度耗盡之前警告，而不是等到 90%。';
	@override String get watchThreshold => '觀察閾值（%）';
	@override String get dangerThreshold => '危險閾值（%）';
	@override String get routingMode => '路由';
	@override late final Translations$common$quota$settings$routing$zh_TW routing = Translations$common$quota$settings$routing$zh_TW.internal(_root);
	@override String get logSources => '日誌來源';
	@override String get logSourcesHint => '用量與代理畫面讀取這些唯讀來源。';
	@override String get quotaConsent => '允許額度輪詢';
	@override String get quotaConsentHint => '使用你儲存的憑證輪詢提供者端點以讀取即時額度。';
	@override String get perAccount => '按帳戶覆寫';
	@override String get tab => 'Control Center 設定';
}

// Path: common.quota.range
class Translations$common$quota$range$zh_TW extends Translations$common$quota$range$en {
	Translations$common$quota$range$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => '全部';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$zh_TW extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get rename => '重新命名';
	@override String get delete => '刪除';
	@override String get copyPath => '複製路徑';
	@override String get download => '下載';
	@override String get newFile => '新增檔案';
	@override String get newFolder => '新增資料夾';
	@override String get upload => '上傳檔案';
	@override String get refresh => '重新整理';
	@override String get menuLabel => '檔案右鍵選單';
	@override String get loading => '載入中...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$zh_TW extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get confirm => '刪除';
	@override String get fileWarning => '此檔案將被永久刪除。';
	@override String get folderWarning => '此資料夾及其所有內容將被永久刪除。';
	@override String title({required Object type}) => '刪除${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$zh_TW extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => '複製路徑失敗';
	@override String get fileCreated => '檔案建立成功';
	@override String get fileDeleted => '檔案已刪除';
	@override String get folderCreated => '資料夾建立成功';
	@override String get folderDeleted => '資料夾已刪除';
	@override String get folderDownloaded => '資料夾已下載為 ZIP';
	@override String get pathCopied => '路徑已複製到剪貼簿';
	@override String get renamed => '重新命名成功';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$zh_TW extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => '檔案名稱不能只包含點';
	@override String get emptyName => '檔案名稱不能為空';
	@override String get invalidChars => '檔案名稱包含無效字元';
	@override String get reserved => '檔案名稱是保留名稱';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$zh_TW extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get type => '類型';
	@override String get configure => '設定';
	@override String get confirm => '確認';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$zh_TW extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get question => '您已經有工作區，還是想建立一個新的工作區？';
	@override late final Translations$common$projectWizard$step1$existing$zh_TW existing = Translations$common$projectWizard$step1$existing$zh_TW.internal(_root);
	@override late final Translations$common$projectWizard$step1$kNew$zh_TW kNew = Translations$common$projectWizard$step1$kNew$zh_TW.internal(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$zh_TW extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get existingPath => '工作區路徑';
	@override String get newPath => '工作區路徑';
	@override String get existingPlaceholder => '/path/to/existing/workspace';
	@override String get newPlaceholder => '/path/to/new/workspace';
	@override String get existingHelp => '您現有工作區目錄的完整路徑';
	@override String get newHelp => '工作區目錄的完整路徑';
	@override String get githubUrl => 'GitHub URL（選填）';
	@override String get githubPlaceholder => 'https://github.com/username/repository';
	@override String get githubHelp => '選填：提供 GitHub URL 以複製儲存庫';
	@override String get githubAuth => 'GitHub 身分驗證（選填）';
	@override String get githubAuthHelp => '僅私有儲存庫需要。公開儲存庫無需身分驗證即可複製。';
	@override String get loadingTokens => '正在載入已儲存的權杖...';
	@override String get storedToken => '已儲存的權杖';
	@override String get newToken => '新權杖';
	@override String get nonePublic => '無（公開）';
	@override String get selectToken => '選取權杖';
	@override String get selectTokenPlaceholder => '-- 選取權杖 --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => '此權杖僅用於此操作';
	@override String get publicRepoInfo => '公開儲存庫不需要身分驗證。如果複製公開儲存庫，可以略過提供權杖。';
	@override String get noTokensHelp => '沒有可用的已儲存權杖。您可以在 設定 → API 金鑰 中新增權杖以便重複使用。';
	@override String get optionalTokenPublic => 'GitHub 權杖（公開儲存庫可選）';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx（公開儲存庫可留空）';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$zh_TW extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => '檢閱您的設定';
	@override String get existingWorkspace => '現有工作區';
	@override String get newWorkspace => '新建工作區';
	@override String get path => '路徑：';
	@override String get cloneFrom => '複製自：';
	@override String get authentication => '身分驗證：';
	@override String get usingStoredToken => '使用已儲存的權杖：';
	@override String get usingProvidedToken => '使用提供的權杖';
	@override String get noAuthentication => '無身分驗證';
	@override String get sshKey => 'SSH 金鑰';
	@override String get existingInfo => '工作區將加入您的專案列表，並可用於 Claude/Cursor 工作階段。';
	@override String get newWithClone => '儲存庫將從此資料夾複製。';
	@override String get newEmpty => '工作區將加入您的專案列表，並可用於 Claude/Cursor 工作階段。';
	@override String get cloningRepository => '正在複製儲存庫...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$zh_TW extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get back => '返回';
	@override String get next => '下一步';
	@override String get createProject => '建立專案';
	@override String get creating => '建立中...';
	@override String get cloning => '正在複製...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$zh_TW extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get selectType => '請選擇您已有現有工作區還是想建立新工作區';
	@override String get providePath => '請提供工作區路徑';
	@override String get failedToCreate => '建立工作區失敗';
	@override String get failedToCreateFolder => '建立資料夾失敗';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$zh_TW extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$zh_TW generic = Translations$common$notifications$codes$generic$zh_TW.internal(_root);
	@override late final Translations$common$notifications$codes$permission$zh_TW permission = Translations$common$notifications$codes$permission$zh_TW.internal(_root);
	@override late final Translations$common$notifications$codes$run$zh_TW run = Translations$common$notifications$codes$run$zh_TW.internal(_root);
	@override late final Translations$common$notifications$codes$agent$zh_TW agent = Translations$common$notifications$codes$agent$zh_TW.internal(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$zh_TW extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get close => '關閉';
	@override String get later => '稍後';
	@override String get copyCommand => '複製指令';
	@override String get updateNow => '立即更新';
	@override String get updating => '更新中...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$zh_TW extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get closeModal => '關閉版本升級對話框';
	@override String get showSidebar => '顯示側邊欄';
	@override String get settings => '設定';
	@override String get updateAvailable => '有可用更新';
	@override String get closeSidebar => '關閉側邊欄';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$zh_TW extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => '在設定中啟用 Browser，讓代理程式可以開啟受監控的瀏覽器工作階段。';
	@override String get descEnabled => '當 AI 任務使用 Browser 時，代理瀏覽器工作階段會顯示在這裡。';
	@override String get titleDisabled => 'Browser 已停用';
	@override String get titleEnabled => '尚無瀏覽器工作階段';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$zh_TW extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => '瀏覽器操作失敗';
	@override String get loadFailed => 'Browser 載入失敗';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$zh_TW extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => '使用 Browser 檢查結帳流程並回報任何損壞的 UI 狀態。';
	@override String get prompt2 => '用 Browser 開啟 <url>，與頁面互動，並摘要每個步驟之後的變化。';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$zh_TW extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' 天前';
	@override String get hoursAgo => ' 小時前';
	@override String get justNow => '剛剛';
	@override String get minutesAgo => ' 分鐘前';
	@override String get never => '從未';
	@override String get secondsAgo => ' 秒前';
	@override String get unknown => '未知';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$zh_TW extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get disabled => '已停用';
	@override String get installing => '安裝中';
	@override String get ready => '就緒';
	@override String get setupRequired => '需要設定';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$zh_TW extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => '瀏覽所有分支（${count}）';
	@override String commits({required Object count}) => '瀏覽所有提交（${count}）';
	@override String files({required Object count}) => '瀏覽所有檔案（${count}）';
	@override String sessions({required Object count}) => '瀏覽所有工作階段（${count}）';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$zh_TW extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get costNote => '成本是基於已公布每權杖價格的用戶端估算；未知模型顯示「—」。';
	@override String get estCost => '預估成本';
	@override String get inputOutput => '輸入 / 輸出';
	@override String get model => '模型';
	@override String get na => '不適用';
	@override String get openSplit => '在分割檢視中開啟';
	@override String get provider => '提供者';
	@override String get selectSession => '選擇工作階段…';
	@override String get tokensUsed => '已用權杖';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$zh_TW extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get actions => '操作';
	@override String get branches => '分支';
	@override String get commits => '提交';
	@override String get files => '檔案';
	@override String get git => 'Git';
	@override String get navigate => '導覽';
	@override String get sessions => '工作階段';
	@override String get settings => '設定';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$zh_TW extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get close => '關閉';
	@override String get navigate => '導覽';
	@override String get select => '選擇';
	@override String get togglePalette => '切換面板';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$zh_TW extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => '比較工作階段';
	@override String get gitFetch => 'Git：Fetch';
	@override String get gitPull => 'Git：Pull';
	@override String get gitPush => 'Git：Push';
	@override String get openSettings => '開啟設定';
	@override String get selectProjectFirst => '請先選擇一個專案';
	@override String settingsEntry({required Object label}) => '設定：${label}';
	@override String get startNewChat => '開始新聊天';
	@override String switchTo({required Object name}) => '切換到：${name}';
	@override String get toggleTheme => '切換主題';
	@override String get tokensAndCost => '權杖與成本';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$zh_TW extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get board => '前往代理面板';
	@override String get chat => '前往聊天';
	@override String get files => '前往檔案';
	@override String get git => '前往 Git';
	@override String get sourceControl => '前往原始碼管理';
	@override String get tasks => '前往任務';
	@override String get usage => '前往配額與用量';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$zh_TW extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get actions => '操作';
	@override String get branches => '分支';
	@override String get commits => '提交';
	@override String get compare => '比較';
	@override String get files => '檔案';
	@override String get sessions => '工作階段';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$zh_TW extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => '刪除分支「${branch}」？一般刪除僅在分支完全合併時成功。此操作無法復原。';
	@override String confirmSwitch({required Object branch}) => '切換到分支「${branch}」？請確保沒有未提交的變更。';
	@override String countBoth({required Object local, required Object remote}) => '${local} 個本機，${remote} 個遠端';
	@override String countLocal({required Object count}) => '${count} 個本機';
	@override String get current => '目前';
	@override String deleteTitle({required Object branch}) => '刪除 ${branch}';
	@override String get emptyDesc => '建立一個分支以開始並行工作。';
	@override String get forceDelete => '強制刪除';
	@override String get forceDeleteDesc => '即使分支包含未合併到其他位置的提交，也會永久移除該分支。';
	@override String get forceDeleteLabel => '強制刪除此未合併的分支';
	@override String get local => '本機';
	@override String get kNew => '新增分支';
	@override String get noMatch => '沒有符合搜尋的分支';
	@override String get none => '找不到分支';
	@override String get remote => '遠端';
	@override String get kSwitch => '切換';
	@override String switchTo({required Object branch}) => '切換到 ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$zh_TW extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get commit => '確認';
	@override String get delete => '刪除';
	@override String get deleteBranch => '刪除';
	@override String get discard => '捨棄';
	@override String get publish => '發布';
	@override String get pull => '拉取';
	@override String get push => '推送';
	@override String get revertLocalCommit => '還原提交';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$zh_TW extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get commit => '確認操作';
	@override String get delete => '刪除檔案';
	@override String get deleteBranch => '刪除分支';
	@override String get discard => '捨棄變更';
	@override String get publish => '發布分支';
	@override String get pull => '確認拉取';
	@override String get push => '確認推送';
	@override String get revertLocalCommit => '還原本機提交';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$zh_TW extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => '建立分支失敗';
	@override String get createWorktreeFailed => '建立 worktree 失敗';
	@override String get deleteBranchFailed => '刪除分支失敗';
	@override String get fetchFailed => 'Fetch 失敗';
	@override String get initFailed => '初始化儲存庫失敗';
	@override String get initialCommitFailed => '建立初始提交失敗';
	@override String get mergeFailed => '合併失敗';
	@override String get openWorktreeFailed => '開啟 worktree 失敗';
	@override String get operationFailed => 'Git 操作失敗';
	@override String get publishFailed => '發布失敗';
	@override String get pullFailed => 'Pull 失敗';
	@override String get pushFailed => 'Push 失敗';
	@override String get removeWorktreeFailed => '移除 worktree 失敗';
	@override String get stageFailed => '暫存失敗';
	@override String get stageHunksFailed => '暫存區塊失敗';
	@override String get switchFailed => '切換分支失敗';
	@override String get unstageFailed => '取消暫存失敗';
	@override String get unstageHunksFailed => '取消區塊暫存失敗';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$zh_TW extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get added => '已新增';
	@override String get author => '作者';
	@override String get changedFiles => '已變更檔案';
	@override String get date => '日期';
	@override String get empty => '找不到提交';
	@override String get files => '檔案';
	@override String get removed => '已移除';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$zh_TW extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => '合併後移除 worktree 並刪除其分支';
	@override String get cleanupLabel => '合併後清理';
	@override String commitCount({required Object count}) => '${count} 個提交';
	@override String get merge => '合併';
	@override String mergeMessage({required Object branch}) => '合併分支 \'${branch}\'';
	@override String get messageLabel => '提交訊息';
	@override String squashDesc({required Object commits, required Object branch}) => '將全部 ${commits} 個提交合併為 ${branch} 上的單一提交';
	@override String get squashLabel => '壓縮提交（squash）';
	@override String get squashMerge => '壓縮並合併';
	@override String squashMessage({required Object branch}) => '壓縮合併分支 \'${branch}\'';
	@override String get title => '合併 Worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$zh_TW extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => '這將從目前分支（${branch}）建立新分支';
	@override String get nameLabel => '分支名稱';
	@override String get submit => '建立分支';
	@override String get title => '建立新分支';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$zh_TW extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => '分支';
	@override String get createFrom => '建立自';
	@override String get description => '將分支簽出到獨立資料夾中並並行工作。';
	@override String get existingBranch => '現有分支 — 將按原樣簽出。';
	@override String get submit => '建立 Worktree';
	@override String get switchAfter => '建立後切換到該 worktree';
	@override String get title => '新增 Worktree';
	@override String get willCreateIn => '將建立於';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$zh_TW extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get create => '建立初始提交';
	@override String get creating => '正在建立初始提交...';
	@override String get description => '此儲存庫還沒有任何提交。建立第一個提交以開始追蹤變更。';
	@override String get title => '尚無提交';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$zh_TW extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => '此專案還不是 git 儲存庫。初始化一個以開始追蹤變更並使用原始碼管理功能。';
	@override String get init => '執行 git init';
	@override String get initializing => '正在初始化儲存庫...';
	@override String get title => '沒有 git 儲存庫';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$zh_TW extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => '同時刪除分支';
	@override String description({required Object branch}) => '移除 ${branch} 的 worktree？其資料夾將被刪除，關聯的專案將被封存 — 聊天工作階段仍可復原。';
	@override String dirtyWarning({required Object count}) => '此 worktree 有 ${count} 個未提交的變更將會遺失。';
	@override String get discardChanges => '捨棄未提交的變更';
	@override String get title => '移除 Worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$zh_TW extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get added => '已新增';
	@override String get deleted => '已刪除';
	@override String get modified => '已修改';
	@override String get untracked => '未追蹤';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$zh_TW extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} 個變更';
	@override String count({required Object count}) => '${count} 個 worktree';
	@override String get createFirst => '建立你的第一個 worktree';
	@override String get detached => '分離';
	@override String detachedAt({required Object sha}) => '分離 @ ${sha}';
	@override String get detachedHead => '分離的 HEAD';
	@override String get emptyDesc => 'worktree 將分支簽出到獨立資料夾，因此你可以並行執行獨立的聊天工作階段，並在就緒後合併結果。';
	@override String get emptyTitle => '並行處理多個分支';
	@override String get locked => '已鎖定';
	@override String get mainWorktree => '主 worktree';
	@override String mergeTitle({required Object branch}) => '將 ${branch} 合併到基礎分支';
	@override String get kNew => '新增 worktree';
	@override String get none => '沒有 worktree';
	@override String get nothingToMerge => '無可合併內容 — 沒有領先於基礎分支的提交';
	@override String get open => '開啟';
	@override String get refresh => '重新整理 worktree';
	@override String removeTitle({required Object branch}) => '移除 ${branch} 的 worktree';
	@override String switchTo({required Object branch}) => '切換到 ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$zh_TW extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get changes => '變更';
	@override String get history => '提交';
	@override String get branches => '分支';
	@override String get worktrees => '工作樹';
}

// Path: common.gitPanel.worktreeScripts
class Translations$common$gitPanel$worktreeScripts$zh_TW extends Translations$common$gitPanel$worktreeScripts$en {
	Translations$common$gitPanel$worktreeScripts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'Worktree 指令碼';
	@override String get setup => '設定指令碼（建立／開啟後執行）';
	@override String get run => '啟動開發伺服器';
	@override String get stop => '停止開發伺服器';
	@override String get runScript => '執行指令碼（開發伺服器，按需啟動）';
	@override String get runPort => '預覽連接埠（選填 — 留空時自動偵測）';
	@override String get invalidPort => '連接埠必須介於 1 到 65535 之間';
	@override String get sourceProject => '已儲存為專案覆寫設定';
	@override String get sourceFile => '來自 .ddagent/worktree.json — 儲存後會建立專案覆寫設定';
	@override String get sourceNone => '尚未設定任何項目';
	@override String get saving => '正在儲存…';
	@override String get setupRunning => '設定執行中';
	@override String get setupFailed => '設定失敗';
	@override String get running => '執行中';
	@override String get openPreview => '開啟預覽';
	@override String runExited({required Object code}) => '執行已結束（${code}）';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$zh_TW extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '範圍';
	@override String get user => '使用者';
	@override String get project => '專案';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$zh_TW extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get system => '系統';
	@override String get light => '淺色';
	@override String get dark => '深色';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$zh_TW extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外觀';
	@override String get toolDisplay => '工具顯示';
	@override String get inputSettings => '輸入設定';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$zh_TW extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dragging => '正在拖曳手柄';
	@override String get closePanel => '關閉設定面板';
	@override String get openPanel => '開啟設定面板';
	@override String get draggingStatus => '正在拖曳...';
	@override String get toggleAndMove => '點擊切換，拖曳移動';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$zh_TW extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get closePanel => '關閉快速鍵面板';
	@override String get openPanel => '開啟快速鍵面板';
}

// Path: settings.miniOrchestration.enable
class Translations$settings$miniOrchestration$enable$zh_TW extends Translations$settings$miniOrchestration$enable$en {
	Translations$settings$miniOrchestration$enable$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '啟用迷你編排';
	@override String get description => '讓「自動（迷你）」工作階段改走雙角色引擎，而非完整的編排器。';
}

// Path: settings.miniOrchestration.thinker
class Translations$settings$miniOrchestration$thinker$zh_TW extends Translations$settings$miniOrchestration$thinker$en {
	Translations$settings$miniOrchestration$thinker$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '思考者（非 flash）';
	@override String get description => '負責規劃、決策、審查並撰寫最終報告。';
}

// Path: settings.miniOrchestration.worker
class Translations$settings$miniOrchestration$worker$zh_TW extends Translations$settings$miniOrchestration$worker$en {
	Translations$settings$miniOrchestration$worker$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '執行者（flash）';
	@override String get description => '執行每個規劃好的步驟。';
}

// Path: settings.miniOrchestration.fields
class Translations$settings$miniOrchestration$fields$zh_TW extends Translations$settings$miniOrchestration$fields$en {
	Translations$settings$miniOrchestration$fields$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get provider => '提供者';
	@override String get model => '模型';
	@override String get modelPlaceholder => '選擇模型';
	@override String get tier => '等級';
}

// Path: settings.miniOrchestration.roles
class Translations$settings$miniOrchestration$roles$zh_TW extends Translations$settings$miniOrchestration$roles$en {
	Translations$settings$miniOrchestration$roles$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '依任務指定模型';
	@override String get description => '各任務類型由哪個模型（角色）處理。';
}

// Path: settings.miniOrchestration.planner
class Translations$settings$miniOrchestration$planner$zh_TW extends Translations$settings$miniOrchestration$planner$en {
	Translations$settings$miniOrchestration$planner$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '規劃器';
	@override String get mode => '模式';
	@override late final Translations$settings$miniOrchestration$planner$modes$zh_TW modes = Translations$settings$miniOrchestration$planner$modes$zh_TW.internal(_root);
	@override String get requireConfirmLabel => '執行前先確認計畫';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$zh_TW extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '啟用編排';
	@override String get description => '讓編排器為每個步驟挑選模型，而不是全部在同一個提供者上執行。';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$zh_TW extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '候選池';
	@override String get description => '路由器可挑選的模型，每個都對應一個成本等級。';
	@override String get add => '新增候選';
	@override String get empty => '尚無候選 — 新增一個即可開始路由。';
	@override late final Translations$settings$orchestration$pool$fields$zh_TW fields = Translations$settings$orchestration$pool$fields$zh_TW.internal(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$zh_TW extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get free => '免費';
	@override String get cheap => '低價';
	@override String get mid => '中價';
	@override String get premium => '高階';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$zh_TW extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '路由規則';
	@override String get description => '依任務類型排序的候選 — 第一個可用者勝出。';
	@override String get addCandidate => '新增候選…';
	@override String get empty => '沒有候選 — 此任務類型無處可分派。';
	@override String get missing => '（已移除）';
	@override String get remove => '移除候選';
	@override late final Translations$settings$orchestration$rules$taskTypes$zh_TW taskTypes = Translations$settings$orchestration$rules$taskTypes$zh_TW.internal(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$zh_TW extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '規劃器';
	@override String get description => '請求如何拆分成可路由的步驟。';
	@override String get modeLabel => '規劃模式';
	@override late final Translations$settings$orchestration$planner$modes$zh_TW modes = Translations$settings$orchestration$planner$modes$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$zh_TW modeHints = Translations$settings$orchestration$planner$modeHints$zh_TW.internal(_root);
	@override String get candidateLabel => '規劃器模型';
	@override String get candidateDescription => '用於產生計畫與分類呼叫的候選池模型。';
	@override String get candidatePlaceholder => '選擇候選池中的模型';
	@override late final Translations$settings$orchestration$planner$templates$zh_TW templates = Translations$settings$orchestration$planner$templates$zh_TW.internal(_root);
	@override String get requireConfirm => '執行前確認計畫';
	@override String get requireConfirmDescription => '規劃完成後暫停，讓你在計畫卡片上編輯或停用步驟。';
	@override String get checkpointLabel => '自主程度';
	@override late final Translations$settings$orchestration$planner$checkpointModes$zh_TW checkpointModes = Translations$settings$orchestration$planner$checkpointModes$zh_TW.internal(_root);
	@override late final Translations$settings$orchestration$planner$checkpointHints$zh_TW checkpointHints = Translations$settings$orchestration$planner$checkpointHints$zh_TW.internal(_root);
	@override String get checkpointIntervalLabel => '檢查點之間的步驟數（1–50）';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$zh_TW extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '執行限制';
	@override String get description => '平行執行與修正迴圈的防護設定。';
	@override String get maxParallel => '最大平行步驟數';
	@override String get maxParallelDescription => '可同時執行的子任務數量（1–8）。';
	@override String get maxFixLoops => '最大修正迴圈數';
	@override String get maxFixLoopsDescription => '步驟未通過驗證時的重試次數（0–5）。';
	@override String get onNoCandidate => '沒有可用候選時';
	@override String get onNoCandidateDescription => '改用備援前先詢問，或略過該步驟。';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$zh_TW onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$zh_TW.internal(_root);
	@override String get useWorktree => '獨立 worktree';
	@override String get useWorktreeDescription => '在單一共用的 git worktree 中執行所有委派步驟，而非專案目錄。';
	@override String get maxSupervisorIterations => '監督者最大迭代次數';
	@override String get maxSupervisorIterationsDescription => '自動模式下監督者決策輪數的上限（1–100）；達到上限時，執行會以部分報告結束。';
	@override String get maxAttempts => '每個步驟的最大嘗試次數';
	@override String get maxAttemptsDescription => '單一步驟在所有通道與重試中可用的總嘗試次數（1–50）。';
	@override String get stepTimeoutMs => '步驟逾時（毫秒）';
	@override String get stepTimeoutMsDescription => '每次嘗試的子執行逾時（毫秒）；0 表示停用。';
	@override String get runTimeoutMs => '執行逾時（毫秒）';
	@override String get runTimeoutMsDescription => '整個計畫執行的全域逾時（毫秒）；0 表示停用。';
	@override String get retryBackoffBaseMs => '重試退避基準（毫秒）';
	@override String get retryBackoffBaseMsDescription => '同一通道重試之間指數退避的基準值（完全抖動）。';
	@override String get retryBudgetTitle => '各失敗類型的重試額度';
	@override String get retryBudgetDescription => '容錯移轉／冷卻前在同一通道的重試次數（0–5）。';
	@override late final Translations$settings$orchestration$execution$retryClasses$zh_TW retryClasses = Translations$settings$orchestration$execution$retryClasses$zh_TW.internal(_root);
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$zh_TW extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get unsaved => '有未儲存的變更';
	@override String get save => '儲存';
	@override String get saving => '正在儲存…';
	@override String get saved => '已儲存';
	@override String get discard => '捨棄';
	@override String get error => '儲存失敗';
	@override String get emptyPool => '儲存前請至少新增一個候選。';
}

// Path: settings.notifications.webPush
class Translations$settings$notifications$webPush$zh_TW extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'Web 推播通知';
	@override String get enable => '啟用推播通知';
	@override String get disable => '關閉推播通知';
	@override String get enabled => '推播通知已啟用';
	@override String get loading => '更新中...';
	@override String get unsupported => '此瀏覽器不支援推播通知。';
	@override String get denied => '推播通知已被封鎖，請在瀏覽器設定中允許。';
	@override String get iosHint => '在 iPhone/iPad 上，只有將 DDAgent 加入主畫面（分享 → 加入主畫面）並在安裝的 App 中啟用通知後，通知才有效。';
	@override String get test => '傳送測試通知';
	@override String get testNoSubscription => '沒有已訂閱的裝置。請先在手機上點擊「啟用」。';
	@override String testSuccess({required Object count}) => '已傳送到 ${count} 台裝置。如果手機上沒有顯示，請將 DDAgent 加入主畫面（iOS 要求）。';
	@override String get testNotDelivered => '沒有可連線的裝置。請確認應用程式正在執行且通知已開啟。';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$zh_TW extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '通知此裝置';
	@override String get enabled => '此裝置的通知已啟用';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$zh_TW extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '通知此桌面應用程式';
	@override String get enable => '啟用推播通知';
	@override String get disable => '關閉推播通知';
	@override String get enabled => '此桌面應用程式已啟用通知';
	@override String get unsupported => '此系統不支援桌面通知。';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$zh_TW extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '聲音';
	@override String get description => '聊天執行完成時播放短提示音。';
	@override String get enabled => '已啟用';
	@override String get test => '測試聲音';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$zh_TW extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '事件類型';
	@override String get actionRequired => '需要處理';
	@override String get stop => '執行已停止';
	@override String get error => '執行失敗';
}

// Path: settings.notifications.messaging
class Translations$settings$notifications$messaging$zh_TW extends Translations$settings$notifications$messaging$en {
	Translations$settings$notifications$messaging$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '透過通訊軟體核准';
	@override String get description => '在 Telegram 上核准或拒絕代理的權限請求，並在 Discord 上接收執行通知。';
	@override String get enabled => '已啟用';
	@override String get save => '儲存';
	@override String get test => '測試';
	@override String get pair => '配對';
	@override String get telegramToken => '來自 @BotFather 的機器人權杖（123456:ABC…）';
	@override String get telegramHint => '先傳送任意訊息給你的機器人，再於下方配對該聊天。';
	@override String get discordWebhook => 'https://discord.com/api/webhooks/…';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$zh_TW extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get telegram => 'Telegram';
	@override String get discord => 'Discord';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$zh_TW extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '深色模式';
	@override String get description => '切換淺色和深色佈景主題';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$zh_TW extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '程式碼編輯器';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$zh_TW theme = Translations$settings$appearanceSettings$codeEditor$theme$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_TW wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_TW showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_TW lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_TW.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$zh_TW fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$zh_TW.internal(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$zh_TW extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '終端機';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_TW focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_TW.internal(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$zh_TW extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get add => '新增 MCP 伺服器';
	@override String get edit => '編輯 MCP 伺服器';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$zh_TW extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get form => '表單輸入';
	@override String get json => 'JSON 匯入';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$zh_TW extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '範圍';
	@override String get userGlobal => '使用者（全域）';
	@override String get projectLocal => '專案（本機）';
	@override String get userDescription => '使用者範圍：在您機器上的所有專案中可用';
	@override String get projectDescription => '本機範圍：僅在選定專案中可用';
	@override String get cannotChange => '編輯現有伺服器時無法變更範圍';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$zh_TW extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get serverName => '伺服器名稱';
	@override String get transportType => '傳輸類型';
	@override String get command => '指令';
	@override String get arguments => '參數（每行一個）';
	@override String get jsonConfig => 'JSON 設定';
	@override String get url => 'URL';
	@override String get envVars => '環境變數（KEY=值，每行一個）';
	@override String get headers => '標頭（KEY=值，每行一個）';
	@override String get selectProject => '選取專案...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$zh_TW extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get serverName => '我的服務';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$zh_TW extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get missingType => '缺少必填欄位：type';
	@override String get stdioRequiresCommand => 'stdio 類型需要 command 欄位';
	@override String httpRequiresUrl({required Object type}) => '${type} 類型需要 url 欄位';
	@override String get invalidJson => '無效的 JSON 格式';
	@override String get jsonHelp => '貼上您的 MCP 伺服器設定（JSON 格式）。範例格式：';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$zh_TW extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get saving => '儲存中...';
	@override String get addServer => '新增伺服器';
	@override String get updateServer => '更新伺服器';
}

// Path: settings.git.name
class Translations$settings$git$name$zh_TW extends Translations$settings$git$name$en {
	Translations$settings$git$name$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git 名稱';
	@override String get help => '您的 git 提交名稱';
	@override String get placeholder => '王小明';
}

// Path: settings.git.email
class Translations$settings$git$email$zh_TW extends Translations$settings$git$email$en {
	Translations$settings$git$email$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git 電子郵件';
	@override String get help => '您的 git 提交電子郵件';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$zh_TW extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get save => '儲存設定';
	@override String get saving => '儲存中...';
}

// Path: settings.git.status
class Translations$settings$git$status$zh_TW extends Translations$settings$git$status$en {
	Translations$settings$git$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get success => '儲存成功';
	@override String get error => '儲存失敗';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$zh_TW extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ 儲存您的 API 金鑰';
	@override String get alertMessage => '這是您唯一一次看到此金鑰。請妥善保存。';
	@override String get iveSavedIt => '我已儲存';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$zh_TW extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'API 金鑰名稱（例如：正式伺服器）';
	@override String get createButton => '建立';
	@override String get cancelButton => '取消';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$zh_TW extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get created => '建立時間：';
	@override String get lastUsed => '最後使用：';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$zh_TW extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get active => '啟用';
	@override String get inactive => '未啟用';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$zh_TW extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub 權杖';
	@override String get description => '新增 GitHub 個人存取權杖以透過外部 API 複製私有儲存庫。';
	@override String get descriptionAlt => '新增 GitHub 個人存取權杖以複製私有儲存庫。您也可以直接在 API 請求中傳遞權杖而無需儲存。';
	@override String get addButton => '新增權杖';
	@override late final Translations$settings$apiKeys$github$form$zh_TW form = Translations$settings$apiKeys$github$form$zh_TW.internal(_root);
	@override String get empty => '尚未新增 GitHub 權杖。';
	@override String get added => '新增時間：';
	@override String get confirmDelete => '確定要刪除此 GitHub 權杖嗎？';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$zh_TW extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '外部 API 文件';
	@override String get description => '了解如何使用外部 API 從您的應用程式觸發 Claude/Cursor 工作階段。';
	@override String get viewLink => '查看 API 文件 →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$zh_TW extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => '有可用更新：v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$zh_TW extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '未安裝 TaskMaster AI CLI';
	@override String get description => '需要 TaskMaster CLI 才能使用任務管理功能。安裝它以開始使用：';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => '在 GitHub 上查看';
	@override String get afterInstallation => '安裝後：';
	@override late final Translations$settings$tasks$notInstalled$steps$zh_TW steps = Translations$settings$tasks$notInstalled$steps$zh_TW.internal(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$zh_TW extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => '啟用 TaskMaster 整合';
	@override String get enableDescription => '在整個介面中顯示 TaskMaster 任務、橫幅和側邊欄指示器';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$zh_TW extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get checking => '檢查中...';
	@override String get connected => '已連線';
	@override String get notConnected => '未連線';
	@override String get disconnected => '已中斷連線';
	@override String get checkingAuth => '正在檢查驗證狀態...';
	@override String loggedInAs({required Object email}) => '登入為 ${email}';
	@override String providerAccount({required Object provider}) => '${provider} 帳戶';
	@override String get authenticatedUser => '已驗證使用者';
}

// Path: settings.agents.install
class Translations$settings$agents$install$zh_TW extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => '未安裝 ${agent} CLI';
	@override String description({required Object agent}) => '安裝 ${agent} CLI 以登入並執行工作階段。';
	@override String get button => '安裝';
	@override String get installing => '安裝中…';
	@override String get copyCommand => '複製指令';
	@override String get docs => '文件';
	@override String success({required Object agent}) => '${agent} CLI 已安裝';
	@override String get failed => '安裝失敗 — 請檢查終端機輸出';
}

// Path: settings.agents.update
class Translations$settings$agents$update$zh_TW extends Translations$settings$agents$update$en {
	Translations$settings$agents$update$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '更新 CLI';
	@override String description({required Object agent}) => '在伺服器主機上安裝最新版本的 ${agent} CLI。';
	@override String get button => '更新';
	@override String get updating => '正在更新…';
	@override String success({required Object agent}) => '${agent} CLI 已更新';
	@override String get failed => '更新失敗 — 請查看終端機輸出';
}

// Path: settings.agents.account
class Translations$settings$agents$account$zh_TW extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$zh_TW claude = Translations$settings$agents$account$claude$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$cursor$zh_TW cursor = Translations$settings$agents$account$cursor$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$codex$zh_TW codex = Translations$settings$agents$account$codex$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$opencode$zh_TW opencode = Translations$settings$agents$account$opencode$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$commandcode$zh_TW commandcode = Translations$settings$agents$account$commandcode$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$antigravity$zh_TW antigravity = Translations$settings$agents$account$antigravity$zh_TW.internal(_root);
	@override late final Translations$settings$agents$account$devin$zh_TW devin = Translations$settings$agents$account$devin$zh_TW.internal(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$zh_TW extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '登入';
	@override String get reAuthenticate => '重新驗證';
	@override String description({required Object agent}) => '登入您的 ${agent} 帳戶以啟用 AI 功能';
	@override String get reAuthDescription => '使用其他帳戶登入或重新整理憑證';
	@override String get button => '登入';
	@override String get reLoginButton => '重新登入';
}

// Path: settings.agents.logout
class Translations$settings$agents$logout$zh_TW extends Translations$settings$agents$logout$en {
	Translations$settings$agents$logout$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '登出';
	@override String get description => '登出此提供者並清除已儲存的認證資訊';
	@override String get button => '登出';
	@override String confirmTitle({required Object agent}) => '登出 ${agent}？';
	@override String confirmDescription({required Object agent}) => '這會刪除伺服器上儲存的 ${agent} 認證資訊。請重新登入以繼續使用 ${agent}。';
	@override String get success => '已登出';
	@override String get failed => '登出失敗';
}

// Path: settings.agents.accounts
class Translations$settings$agents$accounts$zh_TW extends Translations$settings$agents$accounts$en {
	Translations$settings$agents$accounts$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '具名帳戶';
	@override String get description => '額外的憑證組。釘選到某個帳戶的工作階段，會以該帳戶獨立的設定目錄啟動 CLI。請使用下方顯示的環境變數執行一次提供者 CLI 以完成登入。';
	@override String get sharedCli => '所有帳戶共用同一個 CLI 安裝 — 請在上方的連線卡片中更新。';
	@override String get loading => '正在載入帳戶…';
	@override String get kDefault => '預設';
	@override String usage({required Object tokens}) => '${tokens} 個 token';
	@override String get usageButton => '用量';
	@override String get showUsage => '顯示 token 用量';
	@override String get makeDefault => '設為預設';
	@override String get remove => '移除帳戶';
	@override String get newLabel => '帳戶標籤（例如：工作）';
	@override String get add => '新增帳戶';
	@override late final Translations$settings$agents$accounts$autoSwitch$zh_TW autoSwitch = Translations$settings$agents$accounts$autoSwitch$zh_TW.internal(_root);
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$zh_TW extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '權限模式';
	@override String description({required Object provider}) => '新 ${provider} 工作階段的預設權限模式。你仍可為單一工作階段覆寫。';
	@override late final Translations$settings$permissions$permissionMode$modes$zh_TW modes = Translations$settings$permissions$permissionMode$modes$zh_TW.internal(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$zh_TW extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Model Context Protocol 伺服器為 Claude 提供額外的工具和資料來源';
	@override String get cursor => 'Model Context Protocol 伺服器為 Cursor 提供額外的工具和資料來源';
	@override String get codex => 'Model Context Protocol 伺服器為 Codex 提供額外的工具和資料來源';
	@override String get opencode => 'Model Context Protocol 伺服器為 OpenCode 提供額外的工具和資料來源';
	@override String get commandcode => 'Model Context Protocol 伺服器為 Command Code 提供額外的工具和資料來源';
	@override String get antigravity => 'Model Context Protocol 伺服器為 Antigravity 提供額外的工具和資料來源';
	@override String get devin => 'Model Context Protocol 伺服器為 Devin 提供額外的工具和資料來源';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$zh_TW extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get local => '本機';
	@override String get user => '使用者';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$zh_TW extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get command => '指令';
	@override String get url => 'URL';
	@override String get args => '參數';
	@override String get environment => '環境變數';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$zh_TW extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '工具';
	@override String count({required Object count}) => '（${count}）：';
	@override String more({required Object count}) => '還有 ${count} 個';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$zh_TW extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get edit => '編輯伺服器';
	@override String get delete => '刪除伺服器';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$zh_TW extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get badge => '受管理';
	@override String get hint => '由 DDAgent 管理。';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$zh_TW extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '關於 Codex MCP';
	@override String get description => 'Codex 支援基於 stdio 的 MCP 伺服器。您可以新增伺服器，透過額外的工具和資源來擴充 Codex 的功能。';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$zh_TW extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '「${serverName}」將從提供者設定中移除。';
	@override String get title => '刪除 MCP 伺服器？';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$zh_TW extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => '警示閾值、路由策略以及輪詢額度的帳戶。';
	@override String get saved => '已儲存';
	@override String get alertsSection => '警示';
	@override String get alertsSectionHint => '在額度真正耗盡之前警告，而不是等到 100%。';
	@override String get alertsEnabled => '預測額度警示';
	@override String get alertsEnabledHint => '在總覽和帳戶卡片上顯示基於速度的預測。';
	@override String get watchThreshold => '觀察閾值（%）';
	@override String get watchThresholdHint => '讀數達到或超過此值的帳戶計為有風險。';
	@override String get dangerThreshold => '危險閾值（%）';
	@override String get dangerThresholdHint => '達到或超過此值的讀數顯示為紅色。';
	@override String get routingSection => '路由';
	@override String get routingSectionHint => '面板如何將工作遷移到餘量最多的帳戶。';
	@override late final Translations$settings$quota$settings$routing$zh_TW routing = Translations$settings$quota$settings$routing$zh_TW.internal(_root);
	@override String get routingNote => '切換帳戶會改變成本與模型品質，因此始終需要明確決定。';
	@override String get accountsSection => '輪詢的帳戶';
	@override String get accountsSectionHint => '憑證從各工具讀取；面板不會將其傳送到其他地方。';
	@override String get sourcesSection => '資料來源';
	@override String get sourcesSectionHint => '用量與成本資料的來源。';
	@override String get logSources => '權杖與成本日誌儲存';
	@override String get logSourcesHint => '與 tokboard 收集器共享的唯讀彙總儲存。';
	@override String get readOnly => '唯讀';
	@override String get quotaConsent => '額度輪詢';
	@override String get quotaConsentHint => '使用本機儲存的憑證讀取提供者額度端點。';
	@override String get localOnly => '僅本機';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$zh_TW extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => '尚未偵測到任何帳戶。';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$zh_TW extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cached => '快取';
	@override String get error => '錯誤';
	@override String get estimate => '估計';
	@override String get live => '即時';
	@override String get unknown => '未知';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$zh_TW extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => '安裝瀏覽器執行環境失敗';
	@override String get loadSettings => '載入 Browser 設定失敗';
	@override String get loadStatus => '載入 Browser 狀態失敗';
	@override String get saveSettings => '儲存 Browser 設定失敗';
}

// Path: settings.about.pro
class Translations$settings$about$pro$zh_TW extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => '同步設定';
	@override String get teamManagement => '團隊管理';
	@override String get syncSettingsDescription => '在所有環境中同步你的偏好設定、MCP 設定與主題。';
	@override String get teamManagementDescription => '多使用者、角色型存取控制以及團隊共用專案。';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$zh_TW extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'AI 驅動的任務管理：將複雜專案分解為可管理的子任務';
	@override String get prdTemplates => 'PRD 範本：從產品需求文件產生任務';
	@override String get dependencyTracking => '相依性追蹤：了解任務關係和執行順序';
	@override String get progressVisualization => '進度視覺化：看板和詳細的任務分析';
	@override String get cliIntegration => 'CLI 整合：使用 taskmaster 指令進行進階工作流程';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$zh_TW extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$zh_TW createPRD = Translations$tasks$gettingStarted$steps$createPRD$zh_TW.internal(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$zh_TW generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$zh_TW.internal(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$zh_TW analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$zh_TW.internal(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$zh_TW startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$zh_TW.internal(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$zh_TW extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 範例：\n「我剛用 Claude Task Master 初始化了一個新專案。我有一個 PRD 在 .taskmaster/docs/prd.txt。你能幫我解析它並設定初始任務嗎？」';
	@override String get expandTask => '💬 範例：\n「任務 5 看起來很複雜。你能把它分解成子任務嗎？」';
	@override String get addTask => '💬 範例：\n「請新增一個任務來實作使用 Cloudinary 的使用者個人頭像上傳功能，研究最佳方法。」';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$zh_TW extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 專業提示';
	@override String get search => '使用搜尋列快速找到特定任務';
	@override String get views => '使用檢視切換在看板、清單和網格檢視之間切換';
	@override String get filters => '使用篩選器聚焦特定任務狀態或優先順序';
	@override String get details => '點擊任何任務以查看詳細資訊和管理子任務';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$zh_TW extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 了解更多';
	@override String get description => 'TaskMaster AI 是為開發者打造的進階任務管理系統。取得文件、範例並為專案做出貢獻。';
	@override String get githubButton => '在 GitHub 上查看';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$zh_TW extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '還沒有卡片';
	@override String get description => '新增卡片、描述任務，然後拖到「準備開始」讓代理開始工作。';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$zh_TW extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get backlog => '待辦清單';
	@override String get ready => '準備開始';
	@override String get working => '進行中';
	@override String get needsDecision => '需要你的決定';
	@override String get done => '已完成';
	@override String get archived => '已封存';
}

// Path: tasks.board.card
class Translations$tasks$board$card$zh_TW extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get running => '執行中';
	@override String get abort => '中止';
	@override String get delete => '刪除';
	@override String get openSession => '開啟工作階段';
	@override String get pullRequest => '拉取請求';
	@override String get edit => '編輯';
	@override String get moveTo => '移至';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$zh_TW extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get createTitle => '新卡片';
	@override String get editTitle => '編輯卡片';
	@override String get titleLabel => '標題';
	@override String get titlePlaceholder => '代理應該做什麼？';
	@override String get descriptionLabel => '描述';
	@override String get descriptionPlaceholder => '新增背景、驗收標準、連結...';
	@override String get cancel => '取消';
	@override String get save => '儲存';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$zh_TW extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get provider => '代理';
	@override String get anyProvider => '任何代理';
	@override String get model => '模型';
	@override String get defaultModel => '預設模型';
	@override String get effort => '推理';
	@override String get defaultEffort => '預設';
	@override String get searchModel => '搜尋模型…';
	@override String get noModels => '沒有符合的模型';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$zh_TW extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '「${cardTitle}」將被永久刪除。';
	@override String get title => '刪除卡片？';
}

// Path: tasks.board.assignee
class Translations$tasks$board$assignee$zh_TW extends Translations$tasks$board$assignee$en {
	Translations$tasks$board$assignee$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '負責人';
	@override String get all => '所有負責人';
	@override String get unassigned => '未指派';
}

// Path: tasks.board.presence
class Translations$tasks$board$presence$zh_TW extends Translations$tasks$board$presence$en {
	Translations$tasks$board$presence$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String online({required Object count}) => '${count} 人在線上';
}

// Path: tasks.board.activity
class Translations$tasks$board$activity$zh_TW extends Translations$tasks$board$activity$en {
	Translations$tasks$board$activity$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '活動';
	@override String get empty => '尚無活動';
}

// Path: tasks.board.comments
class Translations$tasks$board$comments$zh_TW extends Translations$tasks$board$comments$en {
	Translations$tasks$board$comments$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '留言';
	@override String get placeholder => '撰寫留言…';
	@override String get send => '傳送';
	@override String get unknownAuthor => '某人';
}

// Path: tasks.taskmaster.sort
class Translations$tasks$taskmaster$sort$zh_TW extends Translations$tasks$taskmaster$sort$en {
	Translations$tasks$taskmaster$sort$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get statusAz => '狀態 (A-Z)';
	@override String get statusZa => '狀態 (Z-A)';
}

// Path: tasks.taskmaster.prd
class Translations$tasks$taskmaster$prd$zh_TW extends Translations$tasks$taskmaster$prd$en {
	Translations$tasks$taskmaster$prd$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get fileNameRequired => '請為 PRD 提供檔案名稱。';
	@override String get contentRequired => '儲存前請先新增內容。';
	@override String get overwrite => '覆寫';
	@override String get contentHint => '# 產品需求文件…';
}

// Path: tasks.taskmaster.detail
class Translations$tasks$taskmaster$detail$zh_TW extends Translations$tasks$taskmaster$detail$en {
	Translations$tasks$taskmaster$detail$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get dependenciesLabel => '相依性（以逗號分隔的 ID）';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$zh_TW extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cwd => '工作目錄';
	@override String get envVars => '環境變數';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$zh_TW extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get userAllProviders => '使用者（所有提供者）';
	@override String get claudeLocal => 'Claude 本機';
	@override String get projectAllProviders => '專案（所有提供者）';
	@override late final Translations$mcp$form$scope$description$zh_TW description = Translations$mcp$form$scope$description$zh_TW.internal(_root);
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$zh_TW extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get workingDirectory => '工作目錄';
	@override String get envVarNames => '環境變數名稱';
	@override String get bearerTokenEnvVar => 'Bearer 權杖環境變數';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$zh_TW extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => '新增 MCP 伺服器在所有提供者中僅支援 stdio 和 http，不支援 ${type}。';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} 不支援 ${type} MCP 伺服器';
	@override String get jsonMustBeObject => 'JSON 設定必須是一個物件';
}

// Path: serverConnect.local.errors
class Translations$serverConnect$local$errors$zh_TW extends Translations$serverConnect$local$errors$en {
	Translations$serverConnect$local$errors$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get releaseTagUnresolved => '無法取得最新的 DDAgent 發行標籤。';
	@override String get unsupportedPlatform => '此平台不支援本機伺服器。';
	@override String unsupportedPlatformDetail({required Object platform}) => '此平台不支援本機伺服器（${platform}）。';
	@override String nodeExtractionFailed({required Object path}) => 'Node.js 解壓縮後未產生 ${path}';
	@override String downloadFailed({required Object error}) => '伺服器下載失敗：${error}';
	@override String installFailed({required Object error}) => '伺服器安裝失敗：${error}';
	@override String get bundleNotInstalled => '伺服器套件未安裝。';
	@override String spawnFailed({required Object error}) => '無法啟動本機伺服器：${error}';
	@override String portInUse({required Object port}) => '連接埠 ${port} 已被其他應用程式使用。';
	@override String get exitedDuringStartup => '本機伺服器在啟動期間結束。';
	@override String exitedDuringStartupWithOutput({required Object output}) => '本機伺服器在啟動期間結束：${output}';
	@override String get startTimeout => '等待本機伺服器啟動逾時。';
	@override String tarFailed({required Object command, required Object code, required Object output}) => '${command} 失敗（結束代碼 ${code}）：${output}';
}

// Path: chat.orchestrator.decision.action
class Translations$chat$orchestrator$decision$action$zh_TW extends Translations$chat$orchestrator$decision$action$en {
	Translations$chat$orchestrator$decision$action$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get kContinue => '委派中';
	@override String get done => '已完成';
	@override String get invalid => '無決策';
}

// Path: chat.orchestrator.decision.outcome
class Translations$chat$orchestrator$decision$outcome$zh_TW extends Translations$chat$orchestrator$decision$outcome$en {
	Translations$chat$orchestrator$decision$outcome$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get success => '成功';
	@override String get partial => '部分完成';
	@override String get failed => '失敗';
}

// Path: chat.orchestrator.delegation.status
class Translations$chat$orchestrator$delegation$status$zh_TW extends Translations$chat$orchestrator$delegation$status$en {
	Translations$chat$orchestrator$delegation$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get queued => '已排入佇列';
	@override String get running => '執行中';
	@override String get done => '已完成';
	@override String get failed => '失敗';
	@override String get aborted => '已中止';
	@override String get skipped => '已略過';
	@override String get awaitingDecision => '等待決策';
}

// Path: chat.orchestrator.taskmaster.status
class Translations$chat$orchestrator$taskmaster$status$zh_TW extends Translations$chat$orchestrator$taskmaster$status$en {
	Translations$chat$orchestrator$taskmaster$status$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get started => '執行中';
	@override String get done => '已完成';
	@override String get complete => '全部完成';
	@override String get failed => '失敗';
	@override String get paused => '已暫停';
	@override String get blocked => '受阻';
	@override String get aborted => '已中止';
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$zh_TW extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get manual => '手動 — 僅建議';
	@override String get ask => '切換帳戶前詢問';
	@override String get autoLowRisk => '低風險任務自動切換';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$zh_TW extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '現有工作區';
	@override String get description => '我的伺服器上已經有工作區，只需要將其加入專案列表';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$zh_TW extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '新建工作區';
	@override String get description => '建立新工作區，可選擇從 GitHub 儲存庫複製';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$zh_TW extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$zh_TW info = Translations$common$notifications$codes$generic$info$zh_TW.internal(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$zh_TW extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$zh_TW required = Translations$common$notifications$codes$permission$required$zh_TW.internal(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$zh_TW extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$zh_TW stopped = Translations$common$notifications$codes$run$stopped$zh_TW.internal(_root);
	@override late final Translations$common$notifications$codes$run$failed$zh_TW failed = Translations$common$notifications$codes$run$failed$zh_TW.internal(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$zh_TW extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$zh_TW notification = Translations$common$notifications$codes$agent$notification$zh_TW.internal(_root);
}

// Path: settings.miniOrchestration.planner.modes
class Translations$settings$miniOrchestration$planner$modes$zh_TW extends Translations$settings$miniOrchestration$planner$modes$en {
	Translations$settings$miniOrchestration$planner$modes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get auto => '由思考者規劃';
	@override String get off => '單一步驟';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$zh_TW extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '標籤';
	@override String get labelPlaceholder => '例如 SWE-2 Medium';
	@override String get provider => '提供者';
	@override String get model => '模型';
	@override String get modelPlaceholder => '選擇模型';
	@override String get effort => '推理強度';
	@override String get effortDefault => '提供者預設值';
	@override String get effortPlaceholder => '預設';
	@override String get account => '帳戶';
	@override String get accountDefault => '提供者預設值';
	@override String get redundantAccounts => '備援帳號';
	@override String get redundantAccountsNone => '此供應商沒有其他帳號';
	@override String get tier => '成本等級';
	@override String get remove => '移除候選';
	@override String get moveUp => '上移';
	@override String get moveDown => '下移';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$zh_TW extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get plan => '規劃';
	@override String get quick => '快速回答';
	@override String get research => '研究';
	@override String get docs => '文件';
	@override String get code => '程式撰寫';
	@override String get codeHard => '複雜程式撰寫';
	@override String get test => '測試';
	@override String get review => '審查';
	@override String get report => '報告';
}

// Path: settings.orchestration.planner.modes
class Translations$settings$orchestration$planner$modes$zh_TW extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get auto => '自動（LLM）';
	@override String get template => '範本';
	@override String get off => '關閉';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$zh_TW extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get auto => '規劃器模型會將每個請求拆解為具類型的步驟。';
	@override String get template => '請求會依你在下方選擇的固定流程執行。';
	@override String get off => '不進行規劃 — 整個請求以單一步驟路由。';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$zh_TW extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '流程範本';
	@override String get add => '新增範本';
	@override String get namePlaceholder => '範本名稱';
	@override String get addStep => '新增步驟…';
	@override String get remove => '移除範本';
	@override String get removeStep => '移除步驟';
	@override String get empty => '尚無範本。';
	@override String get emptySteps => '尚無步驟 — 請在下方新增。';
}

// Path: settings.orchestration.planner.checkpointModes
class Translations$settings$orchestration$planner$checkpointModes$zh_TW extends Translations$settings$orchestration$planner$checkpointModes$en {
	Translations$settings$orchestration$planner$checkpointModes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get off => '完全自主';
	@override String get perStep => '每個步驟';
	@override String get everyN => '每 N 個步驟';
}

// Path: settings.orchestration.planner.checkpointHints
class Translations$settings$orchestration$planner$checkpointHints$zh_TW extends Translations$settings$orchestration$planner$checkpointHints$en {
	Translations$settings$orchestration$planner$checkpointHints$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get off => '監督者的決策會直接執行，不另行詢問（自動模式）。';
	@override String get perStep => '每批建議步驟執行前都先徵求核准。';
	@override String get everyN => '每完成 N 個步驟後徵求核准。';
}

// Path: settings.orchestration.execution.onNoCandidateOptions
class Translations$settings$orchestration$execution$onNoCandidateOptions$zh_TW extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get ask => '詢問';
	@override String get skip => '略過步驟';
}

// Path: settings.orchestration.execution.retryClasses
class Translations$settings$orchestration$execution$retryClasses$zh_TW extends Translations$settings$orchestration$execution$retryClasses$en {
	Translations$settings$orchestration$execution$retryClasses$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get rateLimit => '速率限制';
	@override String get quota => '配額';
	@override String get auth => '驗證';
	@override String get timeout => '逾時';
	@override String get transient => '暫時性錯誤';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$zh_TW extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '編輯器佈景主題';
	@override String get description => '程式碼編輯器的預設佈景主題';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_TW extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '自動換行';
	@override String get description => '在編輯器中預設啟用自動換行';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_TW extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '顯示縮圖';
	@override String get description => '在差異檢視中顯示縮圖以便於導覽';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_TW extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '顯示行號';
	@override String get description => '在編輯器中顯示行號';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$zh_TW extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '字型大小';
	@override String get description => '編輯器字型大小（px）';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_TW extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '焦點跟隨指標';
	@override String get description => '將滑鼠移到終端機上時聚焦終端機以便輸入';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$zh_TW extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => '權杖名稱（例如：個人儲存庫）';
	@override String get tokenPlaceholder => 'GitHub 個人存取權杖（ghp_...）';
	@override String get descriptionPlaceholder => '描述（選填）';
	@override String get addButton => '新增權杖';
	@override String get cancelButton => '取消';
	@override String get howToCreate => '如何建立 GitHub 個人存取權杖 →';
	@override String get showToken => '顯示權杖';
	@override String get hideToken => '隱藏權杖';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$zh_TW extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get restart => '重新啟動此應用程式';
	@override String get autoAvailable => 'TaskMaster 功能將自動啟用';
	@override String get initCommand => '在專案目錄中使用 task-master init';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$zh_TW extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'Anthropic Claude AI 助手';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$zh_TW extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'Cursor AI 驅動的程式碼編輯器';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$zh_TW extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenAI Codex AI 助手';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$zh_TW extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenCode CLI 助手';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$zh_TW extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'Command Code CLI 助手';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$zh_TW extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'Antigravity CLI 助手';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$zh_TW extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get description => 'Devin CLI 助手';
}

// Path: settings.agents.accounts.autoSwitch
class Translations$settings$agents$accounts$autoSwitch$zh_TW extends Translations$settings$agents$accounts$autoSwitch$en {
	Translations$settings$agents$accounts$autoSwitch$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get label => '達到用量上限時自動切換帳號';
	@override String get description => '當某個帳號達到用量上限時，工作階段會切換到同一代理程式下仍有額度的另一個帳號——即使你手動選擇了已用盡的帳號。絕不會切換到其他代理程式。Claude 和 Codex 會保留對話；其他代理程式僅在新對話中切換。';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$zh_TW extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$zh_TW kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$zh_TW.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$auto$zh_TW auto = Translations$settings$permissions$permissionMode$modes$auto$zh_TW.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_TW acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_TW.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_TW bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_TW.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$zh_TW plan = Translations$settings$permissions$permissionMode$modes$plan$zh_TW.internal(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$zh_TW extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get manual => '手動';
	@override String get manualHint => '僅顯示建議；絕不自動切換帳戶。';
	@override String get ask => '切換前詢問';
	@override String get askHint => '提出切換建議並等待你的核准。';
	@override String get autoLowRisk => '低風險任務自動';
	@override String get autoLowRiskHint => '只有標記為低風險的任務才能自動遷移。';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$zh_TW extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '建立產品需求文件（PRD）';
	@override String get description => '討論您的專案構想並建立描述您想建立什麼的 PRD。';
	@override String get addButton => '新增 PRD';
	@override String get existingPRDs => '現有的 PRD：';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$zh_TW extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '從 PRD 產生任務';
	@override String get description => '一旦您有了 PRD，請 AI 助手解析它，TaskMaster 將自動將其分解為可管理的任務，包含實作細節。';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$zh_TW extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '分析並展開任務';
	@override String get description => '請 AI 助手分析任務複雜度，並將其展開為詳細的子任務以便於實作。';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$zh_TW extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '開始建構';
	@override String get description => '請 AI 助手開始處理任務、更新狀態，並在專案演進時新增任務。';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$zh_TW extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get userGlobal => '寫入每個提供者的使用者設定，並可在此機器的所有專案中使用';
	@override String get user => '可在您機器上的所有專案中使用';
	@override String get local => '儲存在所選專案的 Claude 使用者設定中';
	@override String get projectGlobal => '為每個提供者寫入所選專案工作區';
	@override String get project => '儲存在所選專案工作區中';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$zh_TW extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$zh_TW extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '需要處理';
	@override String body({required Object toolName}) => '${toolName} 正在等待你的決定。';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$zh_TW extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '執行已停止';
	@override String body({required Object reason}) => '原因：${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$zh_TW extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '執行失敗';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$zh_TW extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'Agent 通知';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$zh_TW extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '預設';
	@override String get description => '需要權限的操作會在聊天中顯示供你核准。';
}

// Path: settings.permissions.permissionMode.modes.auto
class Translations$settings$permissions$permissionMode$modes$auto$zh_TW extends Translations$settings$permissions$permissionMode$modes$auto$en {
	Translations$settings$permissions$permissionMode$modes$auto$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '自動模式';
	@override String get description => '由模型分類器針對每次工具呼叫決定核准或拒絕。免手動操作，但比 Bypass 安全——仍可能發生拒絕。';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_TW extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '接受編輯';
	@override String get description => '檔案編輯自動核准；其他操作仍會請求你的核准。';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_TW extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '略過權限';
	@override String get description => '每個操作都自動核准 — 無提示完整存取。請謹慎使用。';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$zh_TW extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$zh_TW.internal(TranslationsZhTw root) : this._root = root, super.internal(root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '計畫';
	@override String get description => '計畫模式：代理只探索與規劃，不執行命令。';
}

/// The flat map containing all translations for locale <zh-TW>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhTw {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => '工作階段已過期，請重新登入。',
			'auth.login.title' => '歡迎回來',
			'auth.login.description' => '登入您的 DDAgent 帳戶',
			'auth.login.username' => '使用者名稱',
			'auth.login.password' => '密碼',
			'auth.login.submit' => '登入',
			'auth.login.loading' => '登入中...',
			'auth.login.errors.invalidCredentials' => '使用者名稱或密碼無效',
			'auth.login.errors.requiredFields' => '請填寫所有欄位',
			'auth.login.errors.networkError' => '網路錯誤，請重試。',
			'auth.login.placeholders.username' => '輸入您的使用者名稱',
			'auth.login.placeholders.password' => '輸入您的密碼',
			'auth.register.title' => '建立帳戶',
			'auth.register.username' => '使用者名稱',
			'auth.register.password' => '密碼',
			'auth.register.confirmPassword' => '確認密碼',
			'auth.register.submit' => '建立帳戶',
			'auth.register.loading' => '建立帳戶中...',
			'auth.register.errors.passwordMismatch' => '密碼不一致',
			'auth.register.errors.usernameTaken' => '使用者名稱已被使用',
			'auth.register.errors.weakPassword' => '密碼強度太弱',
			'auth.register.errors.usernameTooShort' => '使用者名稱至少需要 3 個字元',
			'auth.register.errors.passwordTooShort' => '密碼至少需要 6 個字元',
			'auth.logout.title' => '登出',
			'auth.logout.confirm' => '確定要登出嗎？',
			'auth.logout.button' => '登出',
			'chat.codeBlock.copy' => '複製',
			'chat.codeBlock.copied' => '已複製',
			'chat.codeBlock.copyCode' => '複製程式碼',
			'chat.copyMessage.copy' => '複製訊息',
			'chat.copyMessage.copied' => '訊息已複製',
			'chat.copyMessage.failed' => '複製失敗',
			'chat.copyMessage.selectFormat' => '選擇複製格式',
			'chat.copyMessage.copyAsMarkdown' => '複製為 Markdown',
			'chat.copyMessage.copyAsText' => '複製為純文字',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => '錯誤',
			'chat.messageTypes.tool' => '工具',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.messageTypes.orchestrator' => '自動',
			'chat.orchestrator.routing.title' => '路由',
			'chat.orchestrator.routing.alternatives' => ({required Object list}) => '備選：${list}',
			'chat.orchestrator.routing.first' => ({required Object label, required Object task}) => '${label} — ${task} 的首選候選',
			'chat.orchestrator.routing.skipped' => ({required Object label, required Object list}) => '${label} — 已略過較前的候選（${list}）',
			'chat.orchestrator.plan.title' => '計畫',
			'chat.orchestrator.plan.disabled' => '已停用',
			'chat.orchestrator.plan.awaitingConfirm' => '正在等待確認計畫。',
			'chat.orchestrator.plan.run' => '執行計畫',
			'chat.orchestrator.plan.toggleStep' => '啟用步驟',
			'chat.orchestrator.plan.confirmFailed' => '啟動失敗，請再試一次。',
			'chat.orchestrator.plan.fallback' => '規劃器無法使用 — 改為單一步驟',
			'chat.orchestrator.plan.templateSource' => '來自流程範本',
			'chat.orchestrator.plan.offSource' => '規劃器已關閉',
			'chat.orchestrator.plan.stepCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個步驟', other: '${count} 個步驟', ), 
			'chat.orchestrator.plan.supervisedSource' => '監督迴圈',
			'chat.orchestrator.decision.title' => '監督者決策',
			'chat.orchestrator.decision.iteration' => ({required Object n}) => '第 ${n} 輪',
			'chat.orchestrator.decision.rationaleLabel' => '原因',
			'chat.orchestrator.decision.awaitingConfirm' => '執行這些步驟前，正在等待你的核准。',
			'chat.orchestrator.decision.proposedSteps' => '建議步驟',
			'chat.orchestrator.decision.action.kContinue' => '委派中',
			'chat.orchestrator.decision.action.done' => '已完成',
			'chat.orchestrator.decision.action.invalid' => '無決策',
			'chat.orchestrator.decision.outcome.success' => '成功',
			'chat.orchestrator.decision.outcome.partial' => '部分完成',
			'chat.orchestrator.decision.outcome.failed' => '失敗',
			'chat.orchestrator.delegation.title' => '委派步驟',
			'chat.orchestrator.delegation.openSession' => '開啟完整工作階段',
			'chat.orchestrator.delegation.attempt' => ({required Object n}) => '第 ${n} 次嘗試',
			'chat.orchestrator.delegation.retryStep' => '重試／修正',
			'chat.orchestrator.delegation.continueStep' => '繼續／修正',
			'chat.orchestrator.delegation.continueFailed' => '失敗，請再試一次。',
			'chat.orchestrator.delegation.status.queued' => '已排入佇列',
			'chat.orchestrator.delegation.status.running' => '執行中',
			'chat.orchestrator.delegation.status.done' => '已完成',
			'chat.orchestrator.delegation.status.failed' => '失敗',
			'chat.orchestrator.delegation.status.aborted' => '已中止',
			'chat.orchestrator.delegation.status.skipped' => '已略過',
			'chat.orchestrator.delegation.status.awaitingDecision' => '等待決策',
			'chat.orchestrator.delegation.attempts' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 次嘗試', other: '${count} 次嘗試', ), 
			'chat.orchestrator.delegation.candidates' => ({required Object list}) => '候選：${list}',
			'chat.orchestrator.delegation.candidateCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個候選', other: '${count} 個候選', ), 
			'chat.orchestrator.summary.title' => '摘要',
			'chat.orchestrator.summary.progress' => ({required Object done, required Object total}) => '已完成步驟：${done}/${total}',
			'chat.orchestrator.summary.aborted' => '已中止',
			'chat.orchestrator.summary.timedOut' => '已逾時',
			'chat.orchestrator.summary.capped' => '已達迭代上限',
			'chat.orchestrator.summary.failed' => ({required Object list}) => '失敗的步驟：${list}',
			'chat.orchestrator.summary.kContinue' => '繼續',
			'chat.orchestrator.summary.continueWork' => '繼續工作',
			'chat.orchestrator.summary.resumeFailed' => '無法繼續執行，請再試一次。',
			'chat.orchestrator.summary.runNextTask' => '執行下一個任務',
			'chat.orchestrator.summary.endAllTasks' => '結束所有任務',
			'chat.orchestrator.summary.tasksRunning' => '正在處理任務…',
			'chat.orchestrator.summary.cancelTasks' => '取消',
			'chat.orchestrator.backToParent' => '返回編排',
			'chat.orchestrator.taskmaster.title' => '任務佇列',
			'chat.orchestrator.taskmaster.remaining' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '剩餘 ${count} 個', other: '剩餘 ${count} 個', ), 
			'chat.orchestrator.taskmaster.status.started' => '執行中',
			'chat.orchestrator.taskmaster.status.done' => '已完成',
			'chat.orchestrator.taskmaster.status.complete' => '全部完成',
			'chat.orchestrator.taskmaster.status.failed' => '失敗',
			'chat.orchestrator.taskmaster.status.paused' => '已暫停',
			'chat.orchestrator.taskmaster.status.blocked' => '受阻',
			'chat.orchestrator.taskmaster.status.aborted' => '已中止',
			'chat.orchestrator.gate.timedOut' => '已逾時',
			'chat.orchestrator.gate.exit' => ({required Object code}) => '結束代碼 ${code}',
			'chat.tools.settings' => '工具設定',
			'chat.tools.error' => '工具錯誤',
			'chat.tools.result' => '工具結果',
			'chat.tools.viewParams' => '查看輸入參數',
			'chat.tools.viewRawParams' => '查看原始參數',
			'chat.tools.viewDiff' => '查看編輯差異',
			'chat.tools.creatingFile' => '建立新檔案：',
			'chat.tools.updatingTodo' => '更新待辦事項',
			'chat.tools.read' => '讀取',
			'chat.tools.readFile' => '讀取檔案',
			'chat.tools.updateTodo' => '更新待辦清單',
			'chat.tools.readTodo' => '讀取待辦清單',
			'chat.tools.searchResults' => '結果',
			'chat.tools.todoReadLabel' => 'TodoRead 讀取清單',
			'chat.search.found' => ({required Object count, required Object type}) => '找到 ${count} 個${type}',
			'chat.search.file' => '檔案',
			'chat.search.files' => '檔案',
			'chat.search.pattern' => '模式：',
			'chat.search.kIn' => '在：',
			'chat.fileOperations.updated' => '檔案更新成功',
			'chat.fileOperations.created' => '檔案建立成功',
			'chat.fileOperations.written' => '檔案寫入成功',
			'chat.fileOperations.diff' => '差異',
			'chat.fileOperations.newFile' => '新檔案',
			'chat.fileOperations.viewContent' => '查看檔案內容',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => '查看完整輸出（${count} 個字元）',
			'chat.fileOperations.contentDisplayed' => '檔案內容顯示在上方的差異檢視中',
			'chat.interactive.title' => '互動式提示',
			'chat.interactive.waiting' => '等待您在 CLI 中回應',
			'chat.interactive.instruction' => '請在 Claude 執行的終端機中選擇一個選項。',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude 選擇了選項 ${number}',
			'chat.interactive.instructionDetail' => '在 CLI 中，您可以使用方向鍵或輸入數字來互動式地選擇此選項。',
			'chat.thinking.title' => '思考中...',
			'chat.thinking.emoji' => '💭 思考中...',
			'chat.thinking.thoughtFewSeconds' => '思考了幾秒鐘',
			'chat.json.response' => 'JSON 回應',
			'chat.permissions.grant' => ({required Object tool}) => '授予 ${tool} 權限',
			'chat.permissions.added' => '權限已新增',
			'chat.permissions.addTo' => ({required Object entry}) => '將 ${entry} 加入允許的工具。',
			'chat.permissions.retry' => '權限已儲存。重試請求以使用該工具。',
			'chat.permissions.error' => '無法更新權限。請重試。',
			'chat.permissions.openSettings' => '開啟設定',
			'chat.permissions.allow' => '允許',
			'chat.permissions.always' => '一律',
			'chat.permissions.editAndAllow' => '編輯並允許',
			'chat.permissions.deny' => '拒絕',
			'chat.permissions.reject' => '拒絕',
			'chat.permissions.allowAll' => ({required Object count}) => '全部允許（${count}）',
			'chat.permissions.editInput' => '編輯輸入',
			'chat.permissions.invalidJson' => '無效的 JSON',
			'chat.permissions.allowWithChanges' => '允許並修改',
			'chat.permissions.alwaysDeny' => '一律拒絕',
			'chat.permissions.denyFeedbackTitle' => '拒絕計畫',
			'chat.permissions.denyFeedbackHint' => '需要代理修改什麼？（選填）',
			'chat.permissions.denyReasonTitle' => '拒絕此操作',
			'chat.permissions.denyReasonHint' => '告訴代理原因或應改做什麼（選填）',
			'chat.permissions.modeAppliesNextMessage' => '新的權限模式將從下一則訊息開始生效。',
			'chat.todo.updated' => '待辦清單已成功更新',
			'chat.todo.current' => '目前待辦清單',
			'chat.plan.viewPlan' => '📋 查看實作計畫',
			'chat.plan.title' => '實作計畫',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claude 使用限制已達到。您的限制將在 **${time} ${timezone}** - ${date} 重置',
			'chat.codex.permissionMode' => '權限模式',
			'chat.codex.modes.kDefault' => '預設模式',
			'chat.codex.modes.auto' => '自動模式',
			'chat.codex.modes.acceptEdits' => '編輯模式',
			'chat.codex.modes.bypassPermissions' => '無限制模式',
			'chat.codex.modes.plan' => '計畫模式',
			'chat.codex.descriptions.kDefault' => '只有受信任的指令（ls、cat、grep、git status 等）自動執行。其他指令將被略過。可以寫入工作區。',
			'chat.codex.descriptions.auto' => '由模型分類器針對每次工具呼叫決定核准或拒絕。免手動操作，但比 Bypass 安全——仍可能發生拒絕。',
			'chat.codex.descriptions.acceptEdits' => '工作區內的所有指令自動執行。完全自動模式，具有沙箱執行功能。',
			'chat.codex.descriptions.bypassPermissions' => '完全的系統存取，無限制。所有指令自動執行，具有完整的磁碟和網路存取權限。請謹慎使用。',
			'chat.codex.descriptions.plan' => '計畫模式 - 不執行任何指令',
			'chat.codex.technicalDetails' => '技術細節',
			'chat.voice.autoRead' => '朗讀回覆',
			'chat.voice.autoReadOn' => '朗讀回覆：開',
			'chat.voice.autoReadOff' => '朗讀回覆：關',
			'chat.voice.autoReadVoice' => '朗讀聲音',
			'chat.voice.autoReadVoiceAuto' => '自動聲音',
			'chat.voice.autoReadPreview' => '回覆將以此聲音朗讀。',
			'chat.voice.speakMessage' => '朗讀',
			'chat.voice.stopSpeaking' => '停止朗讀',
			'chat.input.placeholder' => ({required Object provider}) => '輸入 / 叫用指令，@ 選取檔案，或向 ${provider} 提問...',
			'chat.input.placeholderDefault' => '輸入您的訊息...',
			'chat.input.disabled' => '輸入已停用',
			'chat.input.attachFiles' => '附加檔案',
			'chat.input.attachFilesDesc' => '上傳照片、檔案或文件',
			'chat.input.takePhoto' => '拍攝照片',
			'chat.input.takePhotoDesc' => '使用相機拍攝照片',
			'chat.input.moreTools' => '更多工具',
			'chat.input.commandsDesc' => '瀏覽快捷鍵與命令',
			'chat.input.clearInputDesc' => '捨棄目前文字',
			'chat.input.attachImages' => '附加圖片',
			'chat.input.send' => '傳送',
			'chat.input.stop' => '停止',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter 傳送 • / 指令 • @ 檔案',
			'chat.input.hintText.enter' => 'Enter 傳送 • Shift+Enter 換行 • / 指令 • @ 檔案',
			'chat.input.hintText.queue' => '按 Enter 將下一則訊息排入佇列',
			'chat.input.hintText.updateQueued' => '按 Enter 更新佇列中的訊息',
			'chat.input.clickToChangeMode' => '點擊變更權限模式',
			'chat.input.showAllCommands' => '顯示所有指令',
			'chat.input.clearInput' => '清空輸入',
			'chat.input.scrollToBottom' => '捲動到底部',
			'chat.input.newMessage' => '新訊息',
			'chat.input.newMessages' => '新訊息',
			'chat.input.queue.sendNext' => '將下一則訊息排入佇列',
			'chat.input.queue.update' => '更新佇列中的訊息',
			'chat.input.queue.label' => '已排入佇列',
			'chat.input.queue.willSend' => '完成後將傳送',
			'chat.input.queue.edit' => '編輯佇列中的訊息',
			'chat.input.queue.delete' => '刪除佇列中的訊息',
			'chat.input.queue.failed' => '傳送失敗',
			'chat.input.queue.sendNow' => '立即傳送',
			'chat.input.queue.sendNowAfterTurn' => '此代理無法在回合進行中接收訊息——將在目前回合結束後傳送',
			'chat.input.queue.filesAttached' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '已附加 ${count} 個檔案', ), 
			'chat.input.autoContinueTasks' => '自動繼續',
			'chat.input.autoContinueTasksTooltip' => '啟用後讓 Devin 自動繼續下一個 Task Master 任務',
			'chat.input.offlineQueue.clear' => '取消並清空離線佇列',
			'chat.input.offlineQueue.clearBtn' => '取消',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} 則訊息在離線佇列中 — 重新連線後將自動傳送',
			'chat.input.offlineQueue.single' => '1 則訊息在離線佇列中 — 重新連線後將自動傳送',
			'chat.input.voice' => '語音輸入',
			'chat.input.voiceStart' => '口述訊息',
			'chat.input.voiceStop' => '停止口述',
			'chat.input.pinFile' => '將檔案釘選至上下文',
			'chat.input.voiceSettings' => '語音設定（STT）',
			'chat.input.cameraUnavailable' => ({required Object error}) => '相機無法使用：${error}',
			'chat.composer.toolsAndActions' => '工具與操作',
			'chat.composer.toolsAndActionsDesc' => '聊天輸入框的工具與控制項',
			'chat.composer.reasoning' => '推理中',
			'chat.composer.model' => '模型',
			'chat.composer.effortDefault' => '預設',
			'chat.composer.loadingModels' => '正在載入模型…',
			'chat.composer.modelMenu' => '選擇模型與推理強度',
			'chat.composer.permissionHeading' => ({required Object provider}) => '應如何核准 ${provider} 的操作？',
			'chat.composer.favorites' => '收藏',
			'chat.composer.account' => '帳戶',
			'chat.composer.accountMenu' => '選擇帳戶',
			'chat.composer.accountDefault' => '預設帳戶',
			'chat.composer.accountAuto' => '自動（預設）',
			'chat.composer.accountIsDefault' => '預設',
			'chat.composer.effortLevels.off' => '關閉',
			'chat.composer.effortLevels.none' => '無',
			'chat.composer.effortLevels.minimal' => '最低',
			'chat.composer.effortLevels.low' => '低',
			'chat.composer.effortLevels.medium' => '中',
			'chat.composer.effortLevels.high' => '高',
			'chat.composer.effortLevels.xhigh' => '極高',
			'chat.composer.effortLevels.max' => '最大',
			'chat.composer.effortLevels.ultra' => '超高',
			'chat.composer.contextWindow' => ({required Object size}) => '${size} 上下文',
			'chat.composer.accountAutoShort' => '自動',
			'chat.composer.uploadNoRecords' => '上傳未傳回任何記錄',
			'chat.providerSelection.title' => '選擇您的 AI 助手',
			'chat.providerSelection.description' => '選擇一個提供者以開始新對話',
			'chat.providerSelection.selectModel' => '選擇模型',
			'chat.providerSelection.workspace' => '工作區',
			'chat.providerSelection.noWorkspace' => '無',
			'chat.providerSelection.clickToChangeWorkspace' => '點擊以更改工作區',
			'chat.providerSelection.chooseWorkspace' => '選擇工作區',
			'chat.providerSelection.searchWorkspaces' => '搜尋工作區...',
			'chat.providerSelection.noWorkspacesFound' => '找不到工作區。',
			'chat.providerSelection.providerInfo.anthropic' => '由 Anthropic 提供',
			'chat.providerSelection.providerInfo.openai' => '由 OpenAI 提供',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI 程式碼編輯器',
			'chat.providerSelection.providerInfo.google' => '由 Google 提供',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => '準備好使用 ${model} 的 Claude。請在下方開始輸入您的訊息。',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => '準備好使用 ${model} 的 Cursor。請在下方開始輸入您的訊息。',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => '準備好使用 ${model} 的 Codex。請在下方開始輸入您的訊息。',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => 'OpenCode 搭配 ${model} 已就緒。請在下方輸入你的訊息。',
			'chat.providerSelection.readyPrompt.kDefault' => '請在上方選擇一個提供者以開始',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Devin ${model} 已就緒',
			'chat.providerSelection.readyPrompt.orchestrator' => '「自動」已就緒 — 路由器會為每個步驟挑選最適合的模型',
			'chat.providerSelection.autoGroup' => '自動',
			'chat.providerSelection.autoLabel' => '自動（編排）',
			'chat.providerSelection.autoDescription' => '將每個步驟分派給最適合且可用的提供者與模型',
			'chat.providerSelection.orchestrated' => '已編排',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => '按 <kbd>${shortcut}</kbd> 搜尋工作階段、檔案和提交',
			'chat.providerSelection.all' => '全部',
			'chat.providerSelection.free' => '免費',
			'chat.providerSelection.noModelsFound' => '找不到模型。',
			'chat.providerSelection.paid' => '付費',
			'chat.providerSelection.searchModels' => '搜尋模型...',
			'chat.providerSelection.addModel' => '新增模型',
			'chat.providerSelection.chooseModel' => '選擇模型',
			'chat.providerSelection.chooseModelDescription' => '內建和自訂模型在同一清單中',
			'chat.providerSelection.clickToChange' => '點擊以更改模型',
			'chat.providerSelection.favorites' => '收藏',
			'chat.providerSelection.loadingModels' => '正在載入模型…',
			'chat.providerSelection.manageModels' => '管理模型',
			'chat.providerSelection.refresh' => '重新整理模型',
			'chat.session.kContinue.title' => '繼續您的對話',
			'chat.session.kContinue.description' => '詢問有關程式碼的問題、要求修改或取得開發任務的協助',
			'chat.session.kContinue.action' => '繼續輸入',
			'chat.session.loading.olderMessages' => '正在載入較早的訊息...',
			'chat.session.loading.sessionMessages' => '正在載入工作階段訊息...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => '顯示 ${shown} / ${total} 則訊息',
			'chat.session.messages.scrollToLoad' => '向上捲動以載入更多',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => '顯示最近 ${count} 則訊息（共 ${total} 則）',
			'chat.session.messages.loadEarlier' => '載入較早的訊息',
			'chat.session.messages.loadOlderFailed' => '載入較早訊息失敗。',
			'chat.session.messages.retry' => '重試',
			'chat.session.messages.loadAll' => '載入全部訊息',
			'chat.session.messages.loadingAll' => '正在載入全部訊息...',
			'chat.session.messages.allLoaded' => '全部訊息已載入',
			'chat.session.messages.perfWarning' => '已載入全部訊息 - 捲動可能變慢。點擊「捲動到底部」恢復效能。',
			'chat.session.messages.noSearchMatches' => '沒有訊息符合搜尋。',
			'chat.session.messages.loadOlder' => '載入較早的訊息',
			'chat.session.messages.loadAllCount' => ({required Object count}) => '載入全部（${count}）',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => '重試載入較早訊息 — ${error}',
			'chat.session.deleteConfirm' => '移除工作階段及其記錄。此操作無法復原。',
			'chat.session.finishRunBeforeWorkspaceChange' => '變更工作區前請先完成執行',
			'chat.session.fallbackTitle' => '工作階段',
			'chat.shell.selectProject.title' => '選擇專案',
			'chat.shell.selectProject.description' => '選擇一個專案以在該目錄中開啟互動式 Shell',
			'chat.shell.status.newSession' => '新工作階段',
			'chat.shell.status.initializing' => '初始化中...',
			'chat.shell.status.restarting' => '重新啟動中...',
			'chat.shell.actions.disconnect' => '中斷連線',
			'chat.shell.actions.disconnectTitle' => '中斷 Shell 連線',
			'chat.shell.actions.restart' => '重新啟動',
			'chat.shell.actions.restartTitle' => '重新啟動 Shell（請先中斷連線）',
			'chat.shell.actions.kill' => '終止 (SIGINT)',
			'chat.shell.actions.killTitle' => '終止執行中的程序 (Ctrl+C)',
			'chat.shell.actions.copyOutput' => '複製輸出',
			'chat.shell.actions.copyOutputTitle' => '複製終端機輸出',
			'chat.shell.actions.copied' => '已複製！',
			'chat.shell.actions.zoomInTitle' => '放大',
			'chat.shell.actions.zoomOutTitle' => '縮小',
			'chat.shell.actions.connect' => '在 Shell 中繼續',
			'chat.shell.actions.connectTitle' => '連線到 Shell',
			'chat.shell.loading' => '正在載入終端機...',
			'chat.shell.connecting' => '正在連線到 Shell...',
			'chat.shell.startSession' => '啟動新的 Claude 工作階段',
			'chat.shell.resumeSession' => ({required Object displayName}) => '恢復工作階段：${displayName}...',
			'chat.shell.runCommand' => ({required Object projectName, required Object command}) => '在 ${projectName} 中執行 ${command}',
			'chat.shell.startCli' => ({required Object projectName}) => '在 ${projectName} 中啟動 Claude CLI',
			'chat.shell.defaultCommand' => '指令',
			'chat.claudeStatus.actions.thinking' => '思考中',
			'chat.claudeStatus.actions.processing' => '處理中',
			'chat.claudeStatus.actions.analyzing' => '分析中',
			'chat.claudeStatus.actions.working' => '執行中',
			'chat.claudeStatus.actions.computing' => '運算中',
			'chat.claudeStatus.actions.reasoning' => '推理中',
			'chat.claudeStatus.state.live' => '進行中',
			'chat.claudeStatus.state.paused' => '已暫停',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}秒',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes} 分 ${seconds} 秒',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '已過 ${time}',
			'chat.claudeStatus.elapsed.startingNow' => '正要開始',
			'chat.claudeStatus.stop' => '停止',
			'chat.claudeStatus.backgroundTasks' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個背景工作正在執行', other: '${count} 個背景工作正在執行', ), 
			'chat.claudeStatus.controls.stopGeneration' => '停止生成',
			'chat.claudeStatus.controls.pressEscToStop' => '隨時按 Esc 即可停止',
			'chat.claudeStatus.providers.assistant' => '助理',
			'chat.claudeStatus.backgroundTasksTitle' => '正在背景執行',
			'chat.claudeStatus.backgroundTaskUnnamed' => '未命名的工作',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => '選擇一個專案以開始與 ${provider} 聊天',
			'chat.tasks.nextTaskPrompt' => '開始下一個任務',
			'chat.splitSession.toggle' => '分割工作階段',
			'chat.splitSession.close' => '關閉分割工作階段',
			'chat.splitSession.selectSession' => '選擇要比較的工作階段',
			'chat.splitSession.noOtherSessions' => '沒有其他可用的工作階段',
			'chat.splitSession.newSessionOption' => '+ 在分割檢視中新增工作階段',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => '目前專案（${name}）',
			'chat.splitSession.otherProjectsGroup' => '其他專案',
			'chat.splitSession.recentSessionsGroup' => '最近的工作階段',
			'chat.splitSession.startNewSession' => '在分割檢視中開始新工作階段',
			'chat.splitSession.selectFromList' => '從現有工作階段清單中選擇',
			'chat.sessionPicker.title' => '選擇工作階段',
			'chat.sessionPicker.searchPlaceholder' => '搜尋工作階段...',
			'chat.sessionPicker.clearSearch' => '清除搜尋',
			'chat.sessionPicker.newChat' => '+ 新聊天',
			'chat.sessionPicker.archivedToggle' => '已封存',
			'chat.sessionPicker.changeSession' => '變更工作階段',
			'chat.sessionPicker.archivedLoading' => '正在載入已封存的工作階段...',
			'chat.sessionPicker.archivedError' => '無法載入已封存的工作階段',
			'chat.sessionPicker.archivedEmpty' => '沒有已封存的工作階段',
			'chat.sessionPicker.archivedProjectOnly' => '工作區已封存 — 復原它以檢視其工作階段。',
			'chat.sessionPicker.emptySearch' => '沒有工作階段符合你的搜尋',
			'chat.sessionPicker.restore' => '復原',
			'chat.sessionPicker.restoreSession' => '復原工作階段',
			'chat.sessionPicker.restoreProject' => '復原工作區',
			'chat.sessionPicker.restoreSessionFailed' => '復原工作階段失敗。請重試。',
			'chat.sessionPicker.restoreProjectFailed' => '復原工作區失敗。請重試。',
			'chat.sessionPicker.archiveFailed' => '封存工作階段失敗。請重試。',
			'chat.sessionPicker.deleteFailed' => '刪除工作階段失敗。請重試。',
			'chat.sessionPicker.running' => '工作階段執行中',
			'chat.sessionPicker.unread' => '未讀 — 已完成並有新輸出',
			'chat.sessionPicker.account' => '帳戶',
			'chat.splitWorkspace.addChat' => '新增聊天窗格',
			'chat.splitWorkspace.addBrowser' => '新增瀏覽器窗格',
			'chat.splitWorkspace.addTerminal' => '新增終端機窗格',
			'chat.splitWorkspace.addPreview' => '新增預覽窗格',
			'chat.splitWorkspace.overview' => '顯示所有窗格',
			'chat.splitWorkspace.exitFocusMode' => '離開專注模式 (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => '專注模式 (Ctrl+Shift+F)',
			'chat.splitWorkspace.broadcast' => '廣播至工作階段',
			'chat.splitWorkspace.addNotes' => '新增共用筆記窗格',
			'chat.splitWorkspace.browseSessions' => '開啟工作階段清單',
			'chat.splitOverview.title' => '分割窗格總覽',
			'chat.splitOverview.count' => ({required Object count}) => '${count} 個窗格',
			'chat.splitOverview.close' => '關閉總覽',
			'chat.splitOverview.question' => '問題 — 需要輸入',
			'chat.splitOverview.processing' => '處理中',
			'chat.splitOverview.idle' => '閒置',
			'chat.splitOverview.active' => '使用中',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} 需要你的輸入',
			'chat.askUserQuestion.skip' => '略過',
			'chat.askUserQuestion.other' => '其他…',
			'chat.askUserQuestion.answerHint' => '輸入你的回答…',
			'chat.attachments.downloadFailedRetry' => '下載失敗 — 點擊重試',
			'chat.attachments.fileAttachment' => '檔案附件',
			'chat.attachments.download' => ({required Object name}) => '下載 ${name}',
			'chat.attachments.attachedFile' => '附件',
			'chat.attachments.downloaded' => ({required Object name}) => '已下載 ${name}',
			'chat.checkpoint.creating' => '正在建立快照…',
			'chat.checkpoint.revertChanges' => '將檔案還原到上一個檢查點',
			'chat.checkpoint.undo' => '復原檢查點',
			'chat.checkpoint.undoAiRun' => '復原 AI 執行',
			'chat.checkpoint.undoing' => '正在復原…',
			'chat.checkpoint.undone' => '已復原',
			'chat.checkpoint.beforeAiTurn' => 'AI 回合之前',
			'chat.common.close' => '關閉',
			'chat.taskMaster.saveToTask' => '任務',
			'chat.taskMaster.saved' => '已儲存',
			'chat.taskMaster.saving' => '正在儲存...',
			'chat.taskMaster.taskShort' => '任務',
			'chat.taskMaster.addToTask' => '新增至 TaskMaster',
			'chat.taskMaster.added' => '已新增至 TaskMaster',
			'chat.taskMaster.defaultTaskTitle' => '來自聊天的任務',
			'chat.tokenUsage.desc' => '檢視工作階段權杖消耗',
			'chat.tokenUsage.title' => '權杖用量',
			'chat.tokenUsage.notAvailable' => '不適用',
			'chat.tokenUsage.tokensBadge' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '${count} 個 token', ), 
			'chat.tool.emptyResult' => '（暫無輸出 — 工具回傳了空結果）',
			'chat.quotaBadge.ariaLabel' => '訂閱額度限制',
			'chat.quotaBadge.noData' => '此模型暫無訂閱資料',
			'chat.quotaBadge.noSubscription' => '無訂閱',
			'chat.quotaBadge.windowLineReset' => ({required Object label, required Object percent, required Object time}) => '${label}：${percent}% · 重設於 ${time}',
			'chat.quotaBadge.windowRemaining' => ({required Object percent}) => '距離重設還剩 ${percent}% 的時間視窗',
			'chat.broadcast.title' => '廣播至工作階段',
			'chat.broadcast.noSessions' => '沒有可用的工作階段',
			'chat.broadcast.placeholder' => '要傳送給每個所選工作階段的訊息…',
			'chat.broadcast.partial' => ({required Object count}) => '有 ${count} 個工作階段拒絕了此訊息',
			'chat.broadcast.sent' => ({required Object count}) => '已排入 ${count} 個工作階段的佇列',
			'chat.broadcast.selectAll' => '全選',
			'chat.broadcast.selectOrchestrators' => '選擇編排器',
			'chat.broadcast.orchestratorsOnly' => '僅編排器',
			'chat.broadcast.noOrchestrators' => '沒有可用的編排器會話',
			'chat.broadcast.sending' => '正在傳送…',
			'chat.broadcast.send' => ({required Object count}) => '傳送給 ${count} 個',
			'chat.paneHeader.processing' => '處理中…',
			'chat.paneHeader.switchSession' => '切換工作階段',
			'chat.export.sessionTitle' => ({required Object id}) => '工作階段 ${id}',
			'chat.export.pdfFailed' => 'PDF 匯出失敗',
			'chat.export.transcriptDownloaded' => '記錄已下載',
			'chat.export.savedTo' => ({required Object path}) => '已儲存 ${path}',
			'chat.commandResult.fallback.models' => '瀏覽使用中提供者的可用模型。',
			'chat.commandResult.fallback.cost' => '檢視使用中工作階段的權杖用量。',
			'chat.commandResult.fallback.status' => '檢查執行階段、版本、提供者與環境狀態。',
			'chat.commandResult.fallback.memory' => '開啟專案的 CLAUDE.md 記憶檔案。',
			'chat.commandResult.fallback.config' => '開啟設定與組態。',
			'chat.commandResult.fallback.help' => '顯示指令文件與語法。',
			'chat.commandResult.filterCommands' => '篩選指令...',
			'chat.commandResult.searchModels' => ({required Object provider}) => '搜尋 ${provider} 模型...',
			'chat.commands.runConfirmTitle' => '執行指令？',
			'chat.commands.executionCancelled' => '指令執行已取消',
			'chat.commands.bashConfirmMessage' => '此指令包含將被執行的 bash 指令。要繼續嗎？',
			'chat.commands.proceed' => '繼續',
			'chat.pinFile.title' => '釘選檔案',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.action' => '釘選',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => '編輯 ${name}',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => '刪除 ${name}',
			'chat.modelLibrary.enterNameAndId' => '請同時輸入模型名稱與模型 ID。',
			'chat.modelLibrary.idNoSpaces' => '模型 ID 不能包含空格。',
			'chat.modelLibrary.setAsDefault' => '設為預設',
			'chat.modelLibrary.defaultModel' => '預設模型',
			'chat.modelLibrary.title' => '模型庫',
			'chat.modelLibrary.subtitle' => '新增提供者支援的模型 ID。內建模型維持鎖定。圓圈標示預設模型。',
			'chat.modelLibrary.yourModels' => '你的模型',
			'chat.modelLibrary.yourModelsHint' => '可編輯，儲存在 auth.db 中',
			'chat.modelLibrary.emptyTitle' => '尚無自訂模型',
			'chat.modelLibrary.emptyHint' => '透過表單新增後，它會出現在所有模型選擇器中。',
			'chat.modelLibrary.builtInModels' => '內建模型',
			'chat.modelLibrary.builtInModelsHint' => '由 DDAgent 維護，唯讀',
			'chat.modelLibrary.editTitle' => '編輯自訂模型',
			'chat.modelLibrary.addTitle' => '新增自訂模型',
			'chat.modelLibrary.idSentAsWritten' => ({required Object provider}) => 'ID 會依原樣傳送給 ${provider}。',
			'chat.modelLibrary.nameLabel' => '模型名稱',
			'chat.modelLibrary.nameHint' => '例如 GPT-5.5 Pro',
			'chat.modelLibrary.idLabel' => '模型 ID',
			'chat.modelLibrary.idHint' => '例如 gpt-5.5-pro',
			'chat.modelLibrary.idHelp' => '請使用提供者 CLI 接受的確切識別碼。ID 不可包含空格。',
			'chat.modelLibrary.updatedNotice' => ({required Object name}) => '已更新 ${name}。',
			'chat.modelLibrary.addedNotice' => ({required Object name}) => '已新增 ${name}。',
			'chat.modelLibrary.deletedNotice' => ({required Object name}) => '已刪除 ${name}。',
			'chat.modelLibrary.saving' => '正在儲存…',
			_ => null,
		} ?? switch (path) {
			'chat.modelLibrary.saveChanges' => '儲存變更',
			'chat.modelLibrary.deleteConfirm' => '要從所有選擇器中刪除此模型嗎？',
			'chat.modelLibrary.customBadge' => '自訂',
			'chat.changes.failedToLoad' => '載入變更失敗',
			'chat.changes.empty' => '沒有檔案變更',
			'chat.message.compactedSummary' => '壓縮摘要',
			'chat.message.resendHint' => '從輸入框重新傳送',
			'chat.message.rawView' => '原始檢視',
			'chat.message.runComplete' => '執行完成',
			'chat.message.runStopped' => '已停止',
			'chat.message.runFailed' => ({required Object code}) => '執行失敗（結束代碼 ${code}）',
			'chat.message.taskKilled' => '已終止',
			'chat.permissionRequest.title' => ({required Object tool}) => '權限要求 · ${tool}',
			'chat.permissionRequest.question' => '問題',
			'chat.permissionRequest.subagent' => '子代理',
			'chat.permissionRequest.viewersCannotApprove' => '檢視者無法核准',
			'chat.permissionRequest.recap.timedOut' => '已逾時 — 已自動拒絕',
			'chat.permissionRequest.recap.cancelled' => '已取消 — 本輪已停止',
			'chat.permissionRequest.recap.autoApproved' => '已自動核准',
			'chat.permissionRequest.recap.expired' => '請求已過期 — 代理不再等待',
			'chat.permissionRequest.recap.answered' => '已回答',
			'chat.permissionRequest.recap.skipped' => '已略過',
			'chat.permissionRequest.recap.decided' => '已決定',
			'chat.permissionRequest.needsApproval' => ({required Object tool}) => '${tool} 需要核准',
			'chat.permissionRequest.subagentNeedsApproval' => ({required Object tool}) => '子代理：${tool} 需要核准',
			'chat.permissionRequest.moreQuestions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '還有 ${count} 個問題在等待', ), 
			'chat.commandDialog.help.eyebrow' => '命令中心',
			'chat.commandDialog.help.title' => '說明與快捷方式',
			'chat.commandDialog.help.subtitle' => '搜尋內建命令、語法模式與命令用法。',
			'chat.commandDialog.models.eyebrow' => '模型選擇',
			'chat.commandDialog.models.title' => '選擇模型',
			'chat.commandDialog.models.subtitle' => '選擇此供應商要使用的模型。',
			'chat.commandDialog.models.modelSetTo' => ({required Object model}) => '模型已設定為 ${model}。',
			'chat.commandDialog.models.activeModel' => '目前模型',
			'chat.commandDialog.models.noModelsMatch' => '沒有符合此篩選條件的模型。',
			'chat.commandDialog.models.choiceSavedForSession' => '你的選擇會儲存到此工作階段，並成為新聊天的預設值。',
			'chat.commandDialog.models.choiceDefault' => '你的選擇將成為新聊天的預設模型。',
			'chat.commandDialog.models.custom' => '自訂',
			'chat.commandDialog.models.currentSelection' => '目前選擇',
			'chat.commandDialog.cost.eyebrow' => '工作階段遙測',
			'chat.commandDialog.cost.title' => 'Token 用量',
			'chat.commandDialog.cost.subtitle' => '此工作階段的輸入、輸出與總 token 數。',
			'chat.commandDialog.cost.totalTokensUsed' => '已用 token 總數',
			'chat.commandDialog.cost.inputTokens' => '輸入 token',
			'chat.commandDialog.cost.cacheReadTokens' => '快取讀取 token',
			'chat.commandDialog.cost.cacheWriteTokens' => '快取寫入 token',
			'chat.commandDialog.cost.outputTokens' => '輸出 token',
			'chat.commandDialog.cost.breakdown' => '明細',
			'chat.commandDialog.cost.unavailable' => '無法使用',
			'chat.commandDialog.cost.contextWindow' => '上下文視窗',
			'chat.commandDialog.cost.estimatedCost' => '預估費用',
			'chat.commandDialog.status.eyebrow' => '執行階段健康狀態',
			'chat.commandDialog.status.title' => '系統狀態',
			'chat.commandDialog.status.subtitle' => '版本、供應商、執行階段與環境詳細資料。',
			'chat.commandDialog.status.package' => '套件',
			'chat.commandDialog.status.uptime' => '運作時間',
			'chat.commandDialog.status.platform' => '平台',
			'chat.commandDialog.status.memory' => '記憶體',
			'chat.commandDialog.status.memoryRss' => ({required Object mb}) => '${mb} MB RSS',
			'chat.commandDialog.status.runtimeOnline' => '執行階段上線中',
			'chat.commandDialog.status.processResponding' => ({required Object pid}) => '程序 #${pid} 正在回應。',
			'chat.commandDialog.status.processStatusResponding' => '程序正在回應。',
			'chat.commandDialog.status.healthy' => '正常',
			'chat.commandDialog.defaultEyebrow' => '命令',
			'chat.commandDialog.defaultTitle' => '命令結果',
			'chat.commandDialog.escHint' => '按 Esc 關閉視窗。',
			'chat.commandDialog.unknown' => '未知',
			'chat.commandDialog.noDescription' => '沒有可用的說明。',
			'chat.commandDialog.noCommandsMatch' => '沒有符合此篩選條件的命令。',
			'chat.commandDialog.syntax.title' => '語法',
			'chat.commandDialog.syntax.arguments' => ({required Object arguments, required Object first, required Object second}) => '${arguments} 傳遞所有引數；${first}、${second} 為位置引數。',
			'chat.commandDialog.syntax.file' => ({required Object token}) => '${token} 會包含檔案內容。',
			'chat.commandDialog.syntax.bash' => ({required Object token}) => '${token} 執行 bash。',
			'chat.commandDialog.commandFinished' => '命令已完成。',
			'chat.utilities.tokenUsageUnavailable' => '無法取得 token 用量',
			'chat.utilities.tooltip.tokensUsed' => ({required Object tokens}) => '已用 ${tokens} token',
			'chat.utilities.tooltip.contextOf' => ({required Object percent, required Object total}) => '上下文 ${percent}% / ${total}',
			'chat.utilities.tooltip.input' => ({required Object value}) => '輸入 ${value}',
			'chat.utilities.tooltip.cache' => ({required Object read, required Object write}) => '快取讀取 ${read} · 寫入 ${write}',
			'chat.utilities.tooltip.output' => ({required Object value}) => '輸出 ${value}',
			'chat.utilities.used' => '已用',
			'chat.utilities.cacheWrite' => '快取寫入',
			'chat.utilities.contextLabel' => '上下文',
			'chat.utilities.usageUnsupported' => '不支援用量統計',
			'chat.utilities.chatTranscript' => '聊天記錄',
			'chat.utilities.you' => '你：',
			'chat.utilities.providerAutoMini' => '自動 (mini)',
			'chat.toolBlocks.moreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '… 還有 ${count} 行', ), 
			'chat.toolBlocks.status.running' => '執行中',
			'chat.toolBlocks.status.denied' => '已拒絕',
			'chat.toolBlocks.showLess' => '收合',
			'chat.toolBlocks.showMore' => '顯示更多',
			'chat.toolBlocks.showMoreLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '再顯示 ${count} 行', ), 
			'chat.toolBlocks.tools' => '工具',
			'chat.toolBlocks.planReview' => '計畫審閱',
			'chat.toolBlocks.planUpdate' => '計畫更新',
			'chat.toolBlocks.todoListUpdated' => '待辦清單已更新',
			'chat.toolBlocks.creatingTask' => '正在建立任務',
			'chat.toolBlocks.updatingTask' => '正在更新',
			'chat.toolBlocks.fetchingTask' => '正在擷取',
			'chat.toolBlocks.listingTasks' => '正在列出任務',
			'chat.toolBlocks.search' => '搜尋',
			'chat.toolBlocks.verbs.read' => '讀取',
			'chat.toolBlocks.verbs.write' => '寫入',
			'chat.toolBlocks.verbs.edit' => '編輯',
			'chat.toolBlocks.verbs.delete' => '刪除',
			'chat.toolBlocks.verbs.move' => '移動',
			'chat.toolBlocks.subagent' => '子代理',
			'chat.toolBlocks.toolCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '${count} 個工具', ), 
			'chat.toolBlocks.result' => '結果',
			'chat.toolBlocks.plusMore' => ({required Object count}) => '+${count} 個',
			'chat.toolBlocks.plan' => '計畫',
			'chat.toolBlocks.questionProgress' => ({required Object current, required Object total}) => '問題 ${current}/${total}',
			'chat.toolBlocks.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '${count} 行', ), 
			'chat.toolBlocks.todoListItems' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '待辦清單（${count} 項）', ), 
			'chat.toolBlocks.tasksCompleted' => ({required Object done, required Object total}) => '已完成 ${done}/${total}',
			'chat.commandMenu.empty' => '沒有可用的指令',
			'chat.commandMenu.namespaces.frequent' => '常用',
			'chat.commandMenu.namespaces.builtin' => '內建指令',
			'chat.commandMenu.namespaces.skill' => '技能',
			'chat.commandMenu.namespaces.project' => '專案指令',
			'chat.commandMenu.namespaces.user' => '使用者指令',
			'chat.commandMenu.namespaces.other' => '其他指令',
			'chat.mentionMenu.kinds.file' => '檔案',
			'chat.mentionMenu.kinds.session' => '工作階段',
			'chat.mentionMenu.kinds.task' => '任務',
			'chat.mentionMenu.taskTitle' => ({required Object id}) => '任務 ${id}',
			'chat.subheader.contextTooltip' => ({required Object used, required Object total, required Object percent}) => '上下文：${used} / ${total} 個 token · 已用 ${percent}%',
			'chat.transcript.requestFailed' => '請求失敗',
			'chat.review.changedFiles' => '已變更的檔案',
			'chat.review.changedFilesCount' => ({required Object count}) => '已變更的檔案（${count}）',
			'chat.review.subagent' => '子代理',
			'codeEditor.toolbar.changes' => '個變更',
			'codeEditor.toolbar.previousChange' => '上一個變更',
			'codeEditor.toolbar.nextChange' => '下一個變更',
			'codeEditor.toolbar.hideDiff' => '隱藏差異醒目提示',
			'codeEditor.toolbar.showDiff' => '顯示差異醒目提示',
			'codeEditor.toolbar.settings' => '編輯器設定',
			'codeEditor.toolbar.collapse' => '收合編輯器',
			'codeEditor.toolbar.expand' => '展開編輯器到全寬',
			'codeEditor.toolbar.toggleDock' => '切換檔案面板',
			'codeEditor.toolbar.diffMerge' => '差異 / 合併',
			'codeEditor.toolbar.previewInBrowser' => '在瀏覽器中預覽',
			'codeEditor.toolbar.reload' => '從磁碟重新載入',
			'codeEditor.loading' => ({required Object fileName}) => '正在載入 ${fileName}...',
			'codeEditor.header.showingChanges' => '顯示變更',
			'codeEditor.actions.copyPath' => '複製檔案路徑',
			'codeEditor.actions.pathCopied' => '已複製檔案路徑',
			'codeEditor.actions.download' => '下載檔案',
			'codeEditor.actions.save' => '儲存',
			'codeEditor.actions.saving' => '儲存中...',
			'codeEditor.actions.saved' => '已儲存！',
			'codeEditor.actions.exitFullscreen' => '離開全螢幕',
			'codeEditor.actions.fullscreen' => '全螢幕',
			'codeEditor.actions.close' => '關閉',
			'codeEditor.actions.previewMarkdown' => '預覽 Markdown',
			'codeEditor.actions.editMarkdown' => '編輯 Markdown',
			'codeEditor.actions.pinFile' => '將檔案固定到上下文',
			'codeEditor.actions.unpinFile' => '從上下文取消固定檔案',
			'codeEditor.actions.previewHtml' => '在新分頁中開啟 HTML 預覽',
			'codeEditor.actions.retry' => '重試',
			'codeEditor.actions.saveAll' => '全部儲存',
			'codeEditor.footer.lines' => '行數：',
			'codeEditor.footer.characters' => '字元數：',
			'codeEditor.footer.shortcuts' => '按 Ctrl+S 儲存 • Esc 關閉',
			'codeEditor.footer.plainText' => '純文字',
			'codeEditor.footer.lineCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '${count} 行', ), 
			'codeEditor.footer.modified' => '已修改',
			'codeEditor.binaryFile.title' => '二進位檔案',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => '檔案「${fileName}」無法在文字編輯器中顯示，因為它是二進位檔案。',
			'codeEditor.binaryFile.cannotDisplayAsText' => '無法以文字顯示',
			'codeEditor.filePreview.loading' => '正在載入預覽...',
			'codeEditor.filePreview.error' => '無法顯示此檔案。',
			'codeEditor.filePreview.openInNewTab' => '在新分頁中開啟',
			'codeEditor.unsavedChanges' => ({required Object name}) => '${name} 中有未儲存的變更',
			'codeEditor.discardUnsavedChanges' => '捨棄未儲存的變更？',
			'codeEditor.mediaFile.title' => '媒體檔案',
			'codeEditor.mediaFile.subtitle' => '尚不支援音訊/視訊預覽',
			'codeEditor.failedToLoad' => '載入檔案失敗',
			'codeEditor.hexDump.more' => ({required Object size}) => '… 還有 ${size}',
			'codeEditor.settings.minimap' => '縮圖',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Tab 大小：${size}',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => '字型大小 −  （目前 ${size}）',
			'codeEditor.settings.fontSizeIncrease' => '字型大小 +',
			'codeEditor.diff.noChanges' => '沒有變更',
			'codeEditor.diff.hunk' => ({required Object number}) => '區塊 ${number}',
			'codeEditor.diff.close' => '關閉差異',
			'codeEditor.diff.base' => '基礎',
			'codeEditor.diff.current' => '目前',
			'codeEditor.diff.applyMerge' => '套用合併',
			'codeEditor.diff.deletedOnDisk' => '已從磁碟刪除',
			'codeEditor.diff.untrackedWillBeDeleted' => '此未追蹤的檔案將被刪除。',
			'codeEditor.diff.restoreConfirm' => ({required Object name}) => '將 ${name} 還原為已提交的狀態？',
			'codeEditor.diff.headVsWorkingCopy' => 'HEAD 與工作副本',
			'codeEditor.diff.savedVsBuffer' => '上次儲存與緩衝區（無 git）',
			'codeEditor.diff.unchangedLines' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '${count} 行未變更', ), 
			'codeEditor.diff.revertToSaved' => '還原為已儲存版本',
			'codeEditor.emptyState.title' => '未開啟任何檔案',
			'codeEditor.emptyState.hint' => '從「檔案」分頁開啟檔案',
			'codeEditor.toasts.savedFile' => ({required Object name}) => '已儲存 ${name}',
			'codeEditor.toasts.saveFailed' => '儲存失敗',
			'codeEditor.toasts.allSaved' => '已全部儲存',
			'codeEditor.toasts.someSavesFailed' => '部分儲存失敗',
			'codeEditor.toasts.savedTo' => ({required Object path}) => '已儲存至 ${path}',
			'codeEditor.toasts.mergeApplied' => '已套用合併 — 儲存以保留變更',
			'common.buttons.save' => '儲存',
			'common.buttons.cancel' => '取消',
			'common.buttons.delete' => '刪除',
			'common.buttons.create' => '建立',
			'common.buttons.edit' => '編輯',
			'common.buttons.close' => '關閉',
			'common.buttons.confirm' => '確認',
			'common.buttons.submit' => '送出',
			'common.buttons.retry' => '重試',
			'common.buttons.refresh' => '重新整理',
			'common.buttons.search' => '搜尋',
			'common.buttons.clear' => '清除',
			'common.buttons.copy' => '複製',
			'common.buttons.download' => '下載',
			'common.buttons.upload' => '上傳',
			'common.buttons.browse' => '瀏覽',
			'common.buttons.update' => '更新',
			'common.buttons.openDiagram' => '開啟圖表',
			'common.tabs.chat' => '聊天',
			'common.tabs.shell' => '終端機',
			'common.tabs.files' => '檔案',
			'common.tabs.git' => '版本控制',
			'common.tabs.tasks' => '任務',
			'common.tabs.board' => '看板',
			'common.tabs.browser' => '瀏覽器',
			'common.tabs.computer' => '電腦',
			'common.tabs.usage' => 'AI Control',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => '總覽',
			'common.quota.section.quotas' => '額度',
			'common.quota.section.usage' => '用量',
			'common.quota.section.agents' => '代理',
			'common.quota.filter.all' => '全部',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 天',
			'common.quota.period.k30d' => '30 天',
			'common.quota.period.all' => '全部',
			'common.quota.group.provider' => '提供者',
			'common.quota.group.model' => '模型',
			'common.quota.group.agent' => '代理',
			'common.quota.group.tool' => '工具',
			'common.quota.metric.tokens' => '權杖',
			'common.quota.metric.input' => '輸入',
			'common.quota.metric.output' => '輸出',
			'common.quota.metric.cache' => '快取讀取',
			'common.quota.metric.calls' => 'API 呼叫',
			'common.quota.metric.cost' => '成本',
			'common.quota.metric.sessions' => '工作階段',
			'common.quota.cost.billed' => '已計費（API + 超額）',
			'common.quota.cost.listPrice' => '已用權杖的標價',
			'common.quota.cost.subscriptionValue' => '訂閱涵蓋',
			'common.quota.cost.cacheSavings' => '快取節省',
			'common.quota.cost3.billed' => '已計費（API + 超額）',
			'common.quota.cost3.listPrice' => '已用權杖的標價',
			'common.quota.cost3.subscriptionValue' => '訂閱涵蓋',
			'common.quota.overview.trendTitle' => '權杖與成本 — 最近 7 天',
			'common.quota.overview.effectiveCost' => '實際成本（7 天）',
			'common.quota.overview.alertsTitle' => '警示',
			'common.quota.overview.noAlerts' => '目前沒有需要注意的事項。',
			'common.quota.overview.limitsTitle' => '用量與限額',
			'common.quota.overview.activeTasks' => '活躍任務',
			'common.quota.overview.viewAccounts' => '所有帳戶',
			'common.quota.overview.viewAgents' => '所有代理',
			'common.quota.overview.noTasks' => '目前沒有正在執行的代理。',
			'common.quota.usage.trendTitle' => '每日趨勢',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => '依 ${group} 細分',
			'common.quota.usage.colName' => '名稱',
			'common.quota.usage.sourceUnavailable' => '分析儲存不可用；未顯示資料。',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} 個執行中',
			'common.quota.agents.colAgent' => '代理',
			'common.quota.agents.colStatus' => '狀態',
			'common.quota.agents.colTask' => '任務',
			'common.quota.agents.colModel' => '帳戶 / 模型',
			'common.quota.agents.colTime' => '時間',
			'common.quota.agents.empty' => '沒有代理符合此篩選條件。',
			'common.quota.agents.detailSession' => '工作階段',
			'common.quota.agents.detailStarted' => '已開始',
			'common.quota.agents.detailRetries' => '重試次數',
			'common.quota.agents.detailResult' => '結果',
			'common.quota.agents.notTracked' => '未追蹤',
			'common.quota.agentStatus.running' => '執行中',
			'common.quota.agentStatus.waiting' => '等待中',
			'common.quota.agentStatus.failed' => '失敗',
			'common.quota.agentStatus.finished' => '已完成',
			'common.quota.agentStatus.queued' => '排隊中',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}：按目前速度，額度將在 ${value} 後耗盡',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}：已用 ${value}%（閾值 ${watch}%）',
			'common.quota.backToChat' => '返回聊天',
			'common.quota.syncNow' => '立即同步',
			'common.quota.generatedAt' => ({required Object value}) => '更新於 ${value}',
			'common.quota.loading' => '正在載入帳戶額度…',
			'common.quota.remaining' => ({required Object value}) => '剩餘 ${value}%',
			'common.quota.resetsIn' => ({required Object value}) => '${value} 後重置',
			'common.quota.projected' => ({required Object value}) => '按目前速度，此額度將在 ${value} 後耗盡',
			'common.quota.syncedAgo' => ({required Object value}) => '${value} 前已同步',
			'common.quota.refreshAccount' => '重新整理帳戶',
			'common.quota.syncFailed' => '同步失敗',
			'common.quota.history' => '歷史',
			'common.quota.historyPoints' => ({required Object value}) => '已記錄 ${value} 筆讀數',
			'common.quota.historyEmpty' => '尚無歷史記錄',
			'common.quota.noAgents' => '未指派代理',
			'common.quota.noSubscription' => '無訂閱',
			'common.quota.noSubscriptionHint' => '提供者未回報此帳戶有有效方案。',
			'common.quota.quality.live' => '即時',
			'common.quota.quality.cached' => '快取',
			'common.quota.quality.estimate' => '估計',
			'common.quota.quality.unknown' => '未知',
			'common.quota.quality.error' => '錯誤',
			'common.quota.kpi.atRisk' => '有風險的額度',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => '超過 ${value}% 的帳戶',
			'common.quota.kpi.windowsAtRisk' => '即將耗盡的窗口',
			'common.quota.kpi.errored' => '同步失敗',
			'common.quota.kpi.activeAgents' => '活躍代理',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} 等待 · ${queued} 排隊',
			'common.quota.kpi.nextReset' => '下次重置',
			'common.quota.kpi.tokens' => '權杖',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} 個工作階段',
			'common.quota.kpi.cost' => '預估成本',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} 由方案涵蓋',
			'common.quota.empty.title' => '未連接任何帳戶',
			'common.quota.empty.description' => '登入 Claude、Codex、Gemini 或 CommandCode 即可在此追蹤額度。',
			'common.quota.settings.title' => '警示與路由',
			'common.quota.settings.description' => '控制儀表板何時警告你，以及如何為新工作建議帳戶。',
			'common.quota.settings.alertsEnabled' => '預測與閾值警示',
			'common.quota.settings.alertsEnabledHint' => '在額度按目前速度耗盡之前警告，而不是等到 90%。',
			'common.quota.settings.watchThreshold' => '觀察閾值（%）',
			'common.quota.settings.dangerThreshold' => '危險閾值（%）',
			'common.quota.settings.routingMode' => '路由',
			'common.quota.settings.routing.manual' => '手動 — 僅建議',
			'common.quota.settings.routing.ask' => '切換帳戶前詢問',
			'common.quota.settings.routing.autoLowRisk' => '低風險任務自動切換',
			'common.quota.settings.logSources' => '日誌來源',
			'common.quota.settings.logSourcesHint' => '用量與代理畫面讀取這些唯讀來源。',
			'common.quota.settings.quotaConsent' => '允許額度輪詢',
			'common.quota.settings.quotaConsentHint' => '使用你儲存的憑證輪詢提供者端點以讀取即時額度。',
			'common.quota.settings.perAccount' => '按帳戶覆寫',
			'common.quota.settings.tab' => 'Control Center 設定',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => '全部',
			'common.status.loading' => '載入中...',
			'common.status.success' => '成功',
			'common.status.error' => '錯誤',
			'common.status.failed' => '失敗',
			'common.status.pending' => '待處理',
			'common.status.completed' => '已完成',
			'common.status.inProgress' => '進行中',
			'common.messages.savedSuccessfully' => '儲存成功',
			'common.messages.deletedSuccessfully' => '刪除成功',
			'common.messages.updatedSuccessfully' => '更新成功',
			'common.messages.operationFailed' => '操作失敗',
			'common.messages.networkError' => '網路錯誤，請檢查您的連線。',
			'common.messages.unauthorized' => '未授權，請登入。',
			'common.messages.notFound' => '找不到',
			'common.messages.invalidInput' => '輸入無效',
			'common.messages.requiredField' => '此欄位為必填',
			'common.messages.unknownError' => '發生未知錯誤',
			'common.messages.renameSessionFailed' => '重新命名工作階段失敗。請重試。',
			'common.navigation.settings' => '設定',
			'common.navigation.home' => '首頁',
			'common.navigation.back' => '返回',
			'common.navigation.next' => '下一步',
			'common.navigation.previous' => '上一步',
			'common.navigation.logout' => '登出',
			'common.navigation.backToChat' => '返回聊天',
			'common.common.language' => '語言',
			'common.common.theme' => '佈景主題',
			'common.common.darkMode' => '深色模式',
			'common.common.lightMode' => '淺色模式',
			'common.common.name' => '名稱',
			'common.common.description' => '描述',
			'common.common.enabled' => '已啟用',
			'common.common.disabled' => '已停用',
			'common.common.optional' => '選填',
			'common.common.version' => '版本',
			'common.common.select' => '選取',
			'common.common.selectAll' => '全選',
			'common.common.deselectAll' => '取消全選',
			'common.common.done' => '完成',
			'common.common.failed' => '失敗',
			'common.time.justNow' => '剛剛',
			'common.time.minutesAgo' => ({required Object count}) => '${count} 分鐘前',
			'common.time.hoursAgo' => ({required Object count}) => '${count} 小時前',
			'common.time.daysAgo' => ({required Object count}) => '${count} 天前',
			'common.time.yesterday' => '昨天',
			'common.fileOperations.newFile' => '新增檔案',
			'common.fileOperations.newFolder' => '新增資料夾',
			'common.fileOperations.rename' => '重新命名',
			'common.fileOperations.move' => '移動',
			'common.fileOperations.copyPath' => '複製路徑',
			'common.fileOperations.openInEditor' => '在編輯器中開啟',
			'common.mainContent.loading' => '正在載入 DDAgent',
			'common.mainContent.settingUpWorkspace' => '正在設定您的工作區...',
			'common.mainContent.chooseProject' => '選擇您的專案',
			'common.mainContent.selectProjectDescription' => '從側邊欄選擇一個專案以開始使用 Claude 進行程式開發。每個專案包含您的聊天紀錄和檔案歷史。',
			'common.mainContent.tip' => '提示',
			'common.mainContent.createProjectMobile' => '點擊上方的選單按鈕以存取專案',
			'common.mainContent.createProjectDesktop' => '點擊側邊欄中的資料夾圖示以建立新專案',
			'common.mainContent.newSession' => '新工作階段',
			'common.mainContent.untitledSession' => '未命名工作階段',
			'common.mainContent.projectFiles' => '專案檔案',
			'common.mainContent.focusMode' => '專注模式 (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => '離開專注模式 (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => '分割工作階段',
			'common.mainContent.closeSplitSession' => '關閉分割工作階段',
			'common.mainContent.chooseWorkspace' => '選擇工作區',
			'common.mainContent.chooseWorkspaceDescription' => '為此聊天選擇一個工作區，或在設定中建立新工作區。',
			'common.mainContent.createWorkspace' => '在設定中建立工作區',
			'common.mainContent.recentProjects' => '最近專案',
			'common.fileTree.loading' => '正在載入檔案...',
			'common.fileTree.files' => '檔案',
			'common.fileTree.simpleView' => '簡易檢視',
			'common.fileTree.compactView' => '精簡檢視',
			'common.fileTree.detailedView' => '詳細檢視',
			'common.fileTree.searchPlaceholder' => '搜尋檔案和資料夾...',
			'common.fileTree.searchContentPlaceholder' => '在檔案中搜尋...',
			'common.fileTree.searchInFiles' => '在檔案中搜尋',
			'common.fileTree.searchByName' => '按名稱搜尋',
			'common.fileTree.clearSearch' => '清除搜尋',
			'common.fileTree.name' => '名稱',
			'common.fileTree.size' => '大小',
			'common.fileTree.modified' => '修改時間',
			'common.fileTree.permissions' => '權限',
			'common.fileTree.noFilesFound' => '找不到檔案',
			'common.fileTree.checkProjectPath' => '請檢查專案路徑是否可存取',
			'common.fileTree.loadFailed' => '無法載入檔案',
			'common.fileTree.noMatchesFound' => '找不到符合項目',
			'common.fileTree.noSearchResults' => '找不到符合項目',
			'common.fileTree.tryDifferentSearch' => '嘗試不同的搜尋詞或清除搜尋',
			'common.fileTree.searchError' => '搜尋失敗',
			'common.fileTree.searching' => '正在搜尋...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => '顯示前 ${count} 筆結果',
			'common.fileTree.justNow' => '剛剛',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} 分鐘前',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} 小時前',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} 天前',
			'common.fileTree.newFile' => '新增檔案 (Cmd+N)',
			'common.fileTree.newFolder' => '新增資料夾 (Cmd+Shift+N)',
			'common.fileTree.refresh' => '重新整理',
			'common.fileTree.collapseAll' => '全部收合',
			'common.fileTree.context.rename' => '重新命名',
			'common.fileTree.context.delete' => '刪除',
			'common.fileTree.context.copyPath' => '複製路徑',
			'common.fileTree.context.download' => '下載',
			'common.fileTree.context.newFile' => '新增檔案',
			'common.fileTree.context.newFolder' => '新增資料夾',
			'common.fileTree.context.upload' => '上傳檔案',
			'common.fileTree.context.refresh' => '重新整理',
			'common.fileTree.context.menuLabel' => '檔案右鍵選單',
			'common.fileTree.context.loading' => '載入中...',
			'common.fileTree.allWorkspaces' => '所有工作區',
			'common.fileTree.delete.confirm' => '刪除',
			'common.fileTree.delete.fileWarning' => '此檔案將被永久刪除。',
			'common.fileTree.delete.folderWarning' => '此資料夾及其所有內容將被永久刪除。',
			'common.fileTree.delete.title' => ({required Object type}) => '刪除${type}',
			'common.fileTree.dropToUpload' => '拖放檔案以上傳',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => '拖放檔案以上傳到「${folder}」',
			'common.fileTree.noProject' => '請先新增專案',
			'common.fileTree.noRecentFiles' => '最近 7 天沒有檔案變更',
			'common.fileTree.showAllFiles' => '顯示所有檔案',
			'common.fileTree.showAllFilesHint' => '關閉最近篩選器以檢視全部。',
			'common.fileTree.showRecentOnly' => '顯示最近 7 天變更的檔案',
			'common.fileTree.toast.copyFailed' => '複製路徑失敗',
			'common.fileTree.toast.fileCreated' => '檔案建立成功',
			'common.fileTree.toast.fileDeleted' => '檔案已刪除',
			'common.fileTree.toast.folderCreated' => '資料夾建立成功',
			'common.fileTree.toast.folderDeleted' => '資料夾已刪除',
			'common.fileTree.toast.folderDownloaded' => '資料夾已下載為 ZIP',
			'common.fileTree.toast.pathCopied' => '路徑已複製到剪貼簿',
			'common.fileTree.toast.renamed' => '重新命名成功',
			'common.fileTree.uploadComplete' => '上傳完成',
			'common.fileTree.uploadFailed' => '上傳失敗',
			'common.fileTree.uploadFiles' => ({required Object size}) => '上傳檔案（每個最大 ${size}）',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => '上傳檔案到「${folder}」',
			'common.fileTree.uploadedCount' => ({required Object total, required Object label, required Object uploaded}) => '已上傳 ${total} ${label} 中的 ${uploaded} 個',
			'common.fileTree.uploadingFiles' => '正在上傳檔案',
			'common.fileTree.validation.dotsOnly' => '檔案名稱不能只包含點',
			'common.fileTree.validation.emptyName' => '檔案名稱不能為空',
			'common.fileTree.validation.invalidChars' => '檔案名稱包含無效字元',
			'common.fileTree.validation.reserved' => '檔案名稱是保留名稱',
			'common.projectWizard.title' => '建立新專案',
			'common.projectWizard.steps.type' => '類型',
			'common.projectWizard.steps.configure' => '設定',
			'common.projectWizard.steps.confirm' => '確認',
			'common.projectWizard.step1.question' => '您已經有工作區，還是想建立一個新的工作區？',
			'common.projectWizard.step1.existing.title' => '現有工作區',
			'common.projectWizard.step1.existing.description' => '我的伺服器上已經有工作區，只需要將其加入專案列表',
			'common.projectWizard.step1.kNew.title' => '新建工作區',
			'common.projectWizard.step1.kNew.description' => '建立新工作區，可選擇從 GitHub 儲存庫複製',
			'common.projectWizard.step2.existingPath' => '工作區路徑',
			'common.projectWizard.step2.newPath' => '工作區路徑',
			'common.projectWizard.step2.existingPlaceholder' => '/path/to/existing/workspace',
			'common.projectWizard.step2.newPlaceholder' => '/path/to/new/workspace',
			'common.projectWizard.step2.existingHelp' => '您現有工作區目錄的完整路徑',
			'common.projectWizard.step2.newHelp' => '工作區目錄的完整路徑',
			'common.projectWizard.step2.githubUrl' => 'GitHub URL（選填）',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => '選填：提供 GitHub URL 以複製儲存庫',
			'common.projectWizard.step2.githubAuth' => 'GitHub 身分驗證（選填）',
			'common.projectWizard.step2.githubAuthHelp' => '僅私有儲存庫需要。公開儲存庫無需身分驗證即可複製。',
			'common.projectWizard.step2.loadingTokens' => '正在載入已儲存的權杖...',
			'common.projectWizard.step2.storedToken' => '已儲存的權杖',
			'common.projectWizard.step2.newToken' => '新權杖',
			'common.projectWizard.step2.nonePublic' => '無（公開）',
			'common.projectWizard.step2.selectToken' => '選取權杖',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- 選取權杖 --',
			_ => null,
		} ?? switch (path) {
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => '此權杖僅用於此操作',
			'common.projectWizard.step2.publicRepoInfo' => '公開儲存庫不需要身分驗證。如果複製公開儲存庫，可以略過提供權杖。',
			'common.projectWizard.step2.noTokensHelp' => '沒有可用的已儲存權杖。您可以在 設定 → API 金鑰 中新增權杖以便重複使用。',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHub 權杖（公開儲存庫可選）',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx（公開儲存庫可留空）',
			'common.projectWizard.step3.reviewConfig' => '檢閱您的設定',
			'common.projectWizard.step3.existingWorkspace' => '現有工作區',
			'common.projectWizard.step3.newWorkspace' => '新建工作區',
			'common.projectWizard.step3.path' => '路徑：',
			'common.projectWizard.step3.cloneFrom' => '複製自：',
			'common.projectWizard.step3.authentication' => '身分驗證：',
			'common.projectWizard.step3.usingStoredToken' => '使用已儲存的權杖：',
			'common.projectWizard.step3.usingProvidedToken' => '使用提供的權杖',
			'common.projectWizard.step3.noAuthentication' => '無身分驗證',
			'common.projectWizard.step3.sshKey' => 'SSH 金鑰',
			'common.projectWizard.step3.existingInfo' => '工作區將加入您的專案列表，並可用於 Claude/Cursor 工作階段。',
			'common.projectWizard.step3.newWithClone' => '儲存庫將從此資料夾複製。',
			'common.projectWizard.step3.newEmpty' => '工作區將加入您的專案列表，並可用於 Claude/Cursor 工作階段。',
			'common.projectWizard.step3.cloningRepository' => '正在複製儲存庫...',
			'common.projectWizard.buttons.cancel' => '取消',
			'common.projectWizard.buttons.back' => '返回',
			'common.projectWizard.buttons.next' => '下一步',
			'common.projectWizard.buttons.createProject' => '建立專案',
			'common.projectWizard.buttons.creating' => '建立中...',
			'common.projectWizard.buttons.cloning' => '正在複製...',
			'common.projectWizard.errors.selectType' => '請選擇您已有現有工作區還是想建立新工作區',
			'common.projectWizard.errors.providePath' => '請提供工作區路徑',
			'common.projectWizard.errors.failedToCreate' => '建立工作區失敗',
			'common.projectWizard.errors.failedToCreateFolder' => '建立資料夾失敗',
			'common.notifications.genericTool' => '工具',
			'common.notifications.codes.generic.info.title' => '通知',
			'common.notifications.codes.permission.required.title' => '需要處理',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} 正在等待你的決定。',
			'common.notifications.codes.run.stopped.title' => '執行已停止',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => '原因：${reason}',
			'common.notifications.codes.run.failed.title' => '執行失敗',
			'common.notifications.codes.agent.notification.title' => 'Agent 通知',
			'common.versionUpdate.title' => '有可用更新',
			'common.versionUpdate.newVersionReady' => '新版本已準備就緒',
			'common.versionUpdate.currentVersion' => '目前版本',
			'common.versionUpdate.latestVersion' => '最新版本',
			'common.versionUpdate.whatsNew' => '新功能：',
			'common.versionUpdate.viewFullRelease' => '查看完整發行說明',
			'common.versionUpdate.updateProgress' => '更新進度：',
			'common.versionUpdate.manualUpgrade' => '手動升級：',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => '或點擊「立即更新」以自動執行更新。',
			'common.versionUpdate.updateCompleted' => '更新成功完成！',
			'common.versionUpdate.restartServer' => '請重新啟動伺服器以套用變更。',
			'common.versionUpdate.updateFailed' => '更新失敗',
			'common.versionUpdate.buttons.close' => '關閉',
			'common.versionUpdate.buttons.later' => '稍後',
			'common.versionUpdate.buttons.copyCommand' => '複製指令',
			'common.versionUpdate.buttons.updateNow' => '立即更新',
			'common.versionUpdate.buttons.updating' => '更新中...',
			'common.versionUpdate.ariaLabels.closeModal' => '關閉版本升級對話框',
			'common.versionUpdate.ariaLabels.showSidebar' => '顯示側邊欄',
			'common.versionUpdate.ariaLabels.settings' => '設定',
			'common.versionUpdate.ariaLabels.updateAvailable' => '有可用更新',
			'common.versionUpdate.ariaLabels.closeSidebar' => '關閉側邊欄',
			'common.actions.cancel' => '取消',
			'common.actions.retry' => '重試',
			'common.actions.save' => '儲存',
			'common.browserPane.address' => '位址',
			'common.browserPane.back' => '上一頁',
			'common.browserPane.connecting' => '正在連線瀏覽器…',
			'common.browserPane.connectionFailed' => '瀏覽器連線失敗。',
			'common.browserPane.couldNotLoad' => ({required Object url}) => '無法載入 ${url}',
			'common.browserPane.disconnected' => '瀏覽器檢視已中斷連線',
			'common.browserPane.enterUrl' => '輸入 URL',
			'common.browserPane.forward' => '下一頁',
			'common.browserPane.invalidUrl' => '請輸入有效的 http(s) URL',
			'common.browserPane.noAuthToken' => '沒有可用的驗證權杖。',
			'common.browserPane.openExternal' => '在系統瀏覽器中開啟',
			'common.browserPane.reload' => '重新載入',
			'common.browserPane.retry' => '重試',
			'common.browserPane.stop' => '停止',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} 個使用中',
			'common.browserUse.cancel' => '取消',
			'common.browserUse.close' => '關閉',
			'common.browserUse.delete' => '刪除',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} 將被永久刪除。',
			'common.browserUse.deleteSession' => '刪除工作階段',
			'common.browserUse.deleteTitle' => '刪除瀏覽器工作階段？',
			'common.browserUse.empty.descDisabled' => '在設定中啟用 Browser，讓代理程式可以開啟受監控的瀏覽器工作階段。',
			'common.browserUse.empty.descEnabled' => '當 AI 任務使用 Browser 時，代理瀏覽器工作階段會顯示在這裡。',
			'common.browserUse.empty.titleDisabled' => 'Browser 已停用',
			'common.browserUse.empty.titleEnabled' => '尚無瀏覽器工作階段',
			'common.browserUse.emptyStatus' => '空',
			'common.browserUse.errors.actionFailed' => '瀏覽器操作失敗',
			'common.browserUse.errors.loadFailed' => 'Browser 載入失敗',
			'common.browserUse.fullscreen' => '全螢幕',
			'common.browserUse.installRuntime' => '安裝執行環境',
			'common.browserUse.installing' => '正在安裝...',
			'common.browserUse.lastAction' => '最後操作',
			'common.browserUse.nextSnapshot' => '代理瀏覽器的下一個快照將顯示在這裡。',
			'common.browserUse.noPageLoaded' => '未載入頁面',
			'common.browserUse.noSessions' => '沒有代理瀏覽器工作階段。',
			'common.browserUse.none' => '無',
			'common.browserUse.openSettings' => '開啟 Browser 設定',
			'common.browserUse.profile' => '設定檔',
			'common.browserUse.promptLabel' => '提示詞',
			'common.browserUse.prompts.prompt1' => '使用 Browser 檢查結帳流程並回報任何損壞的 UI 狀態。',
			'common.browserUse.prompts.prompt2' => '用 Browser 開啟 <url>，與頁面互動，並摘要每個步驟之後的變化。',
			'common.browserUse.refresh' => '重新整理瀏覽器工作階段',
			'common.browserUse.relative.daysAgo' => ' 天前',
			'common.browserUse.relative.hoursAgo' => ' 小時前',
			'common.browserUse.relative.justNow' => '剛剛',
			'common.browserUse.relative.minutesAgo' => ' 分鐘前',
			'common.browserUse.relative.never' => '從未',
			'common.browserUse.relative.secondsAgo' => ' 秒前',
			'common.browserUse.relative.unknown' => '未知',
			'common.browserUse.runtime.disabled' => '已停用',
			'common.browserUse.runtime.installing' => '安裝中',
			'common.browserUse.runtime.ready' => '就緒',
			'common.browserUse.runtime.setupRequired' => '需要設定',
			'common.browserUse.runtimeSetup' => '需要設定執行環境',
			'common.browserUse.selected' => '已選取',
			'common.browserUse.sessionFallback' => '瀏覽器工作階段',
			'common.browserUse.sessionScreenshot' => '瀏覽器工作階段截圖',
			'common.browserUse.sessions' => '工作階段',
			'common.browserUse.status' => '狀態',
			'common.browserUse.stop' => '停止',
			'common.browserUse.stopSession' => '停止工作階段',
			'common.browserUse.subtitle' => '監控 AI 代理開啟的瀏覽器工作階段。',
			'common.browserUse.temporary' => '臨時',
			'common.browserUse.thisSession' => '此工作階段',
			'common.browserUse.title' => '瀏覽器',
			'common.browserUse.totalCount' => ({required Object count}) => '共 ${count} 個',
			'common.browserUse.updated' => ({required Object time}) => '更新於 ${time}',
			'common.browserUse.waiting' => '等待中',
			'common.browserUse.waitingForScreenshot' => '等待截圖',
			'common.commandPalette.backToAll' => '返回全部',
			'common.commandPalette.backspaceHint' => '按 Backspace 返回',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => '瀏覽所有分支（${count}）',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => '瀏覽所有提交（${count}）',
			'common.commandPalette.browseAll.files' => ({required Object count}) => '瀏覽所有檔案（${count}）',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => '瀏覽所有工作階段（${count}）',
			'common.commandPalette.compare.costNote' => '成本是基於已公布每權杖價格的用戶端估算；未知模型顯示「—」。',
			'common.commandPalette.compare.estCost' => '預估成本',
			'common.commandPalette.compare.inputOutput' => '輸入 / 輸出',
			'common.commandPalette.compare.model' => '模型',
			'common.commandPalette.compare.na' => '不適用',
			'common.commandPalette.compare.openSplit' => '在分割檢視中開啟',
			'common.commandPalette.compare.provider' => '提供者',
			'common.commandPalette.compare.selectSession' => '選擇工作階段…',
			'common.commandPalette.compare.tokensUsed' => '已用權杖',
			'common.commandPalette.groups.actions' => '操作',
			'common.commandPalette.groups.branches' => '分支',
			'common.commandPalette.groups.commits' => '提交',
			'common.commandPalette.groups.files' => '檔案',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => '導覽',
			'common.commandPalette.groups.sessions' => '工作階段',
			'common.commandPalette.groups.settings' => '設定',
			'common.commandPalette.hints.close' => '關閉',
			'common.commandPalette.hints.navigate' => '導覽',
			'common.commandPalette.hints.select' => '選擇',
			'common.commandPalette.hints.togglePalette' => '切換面板',
			'common.commandPalette.items.compareSessions' => '比較工作階段',
			'common.commandPalette.items.gitFetch' => 'Git：Fetch',
			'common.commandPalette.items.gitPull' => 'Git：Pull',
			'common.commandPalette.items.gitPush' => 'Git：Push',
			'common.commandPalette.items.openSettings' => '開啟設定',
			'common.commandPalette.items.selectProjectFirst' => '請先選擇一個專案',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => '設定：${label}',
			'common.commandPalette.items.startNewChat' => '開始新聊天',
			'common.commandPalette.items.switchTo' => ({required Object name}) => '切換到：${name}',
			'common.commandPalette.items.toggleTheme' => '切換主題',
			'common.commandPalette.items.tokensAndCost' => '權杖與成本',
			'common.commandPalette.nav.board' => '前往代理面板',
			'common.commandPalette.nav.chat' => '前往聊天',
			'common.commandPalette.nav.files' => '前往檔案',
			'common.commandPalette.nav.git' => '前往 Git',
			'common.commandPalette.nav.sourceControl' => '前往原始碼管理',
			'common.commandPalette.nav.tasks' => '前往任務',
			'common.commandPalette.nav.usage' => '前往配額與用量',
			'common.commandPalette.noResults' => '沒有結果。',
			'common.commandPalette.pages.actions' => '操作',
			'common.commandPalette.pages.branches' => '分支',
			'common.commandPalette.pages.commits' => '提交',
			'common.commandPalette.pages.compare' => '比較',
			'common.commandPalette.pages.files' => '檔案',
			'common.commandPalette.pages.sessions' => '工作階段',
			'common.commandPalette.placeholder' => '輸入以搜尋任何內容…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => '搜尋 ${page}…',
			'common.commandPalette.title' => '命令面板',
			'common.gitPanel.ahead' => ({required Object count}) => '領先 ${count}',
			'common.gitPanel.aheadLabel' => '領先',
			'common.gitPanel.aiSuggest' => 'AI 建議',
			'common.gitPanel.aiSuggestTitle' => '用 AI 產生提交訊息',
			'common.gitPanel.all' => '全部',
			'common.gitPanel.allStaged' => '所有變更已暫存',
			'common.gitPanel.behind' => ({required Object count}) => '落後 ${count}',
			'common.gitPanel.behindLabel' => '落後',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => '刪除分支「${branch}」？一般刪除僅在分支完全合併時成功。此操作無法復原。',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => '切換到分支「${branch}」？請確保沒有未提交的變更。',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} 個本機，${remote} 個遠端',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} 個本機',
			'common.gitPanel.branches.current' => '目前',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => '刪除 ${branch}',
			'common.gitPanel.branches.emptyDesc' => '建立一個分支以開始並行工作。',
			'common.gitPanel.branches.forceDelete' => '強制刪除',
			'common.gitPanel.branches.forceDeleteDesc' => '即使分支包含未合併到其他位置的提交，也會永久移除該分支。',
			'common.gitPanel.branches.forceDeleteLabel' => '強制刪除此未合併的分支',
			'common.gitPanel.branches.local' => '本機',
			'common.gitPanel.branches.kNew' => '新增分支',
			'common.gitPanel.branches.noMatch' => '沒有符合搜尋的分支',
			'common.gitPanel.branches.none' => '找不到分支',
			'common.gitPanel.branches.remote' => '遠端',
			'common.gitPanel.branches.kSwitch' => '切換',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => '切換到 ${branch}',
			'common.gitPanel.cancel' => '取消',
			'common.gitPanel.changesCount' => ({required Object count}) => '變更（${count}）',
			'common.gitPanel.clearSearch' => '清除搜尋',
			'common.gitPanel.collapseDiff' => '摺疊差異',
			'common.gitPanel.commit' => '提交',
			'common.gitPanel.commitChanges' => '提交變更',
			'common.gitPanel.commitFiles' => ({required Object count}) => '提交 ${count} 個檔案',
			'common.gitPanel.committing' => '正在提交...',
			'common.gitPanel.confirmActions.commit' => '確認',
			'common.gitPanel.confirmActions.delete' => '刪除',
			'common.gitPanel.confirmActions.deleteBranch' => '刪除',
			'common.gitPanel.confirmActions.discard' => '捨棄',
			'common.gitPanel.confirmActions.publish' => '發布',
			'common.gitPanel.confirmActions.pull' => '拉取',
			'common.gitPanel.confirmActions.push' => '推送',
			'common.gitPanel.confirmActions.revertLocalCommit' => '還原提交',
			'common.gitPanel.confirmCommit' => ({required Object message, required Object count}) => '以訊息「${message}」提交 ${count} 個檔案？',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => '刪除未追蹤的檔案「${file}」？此操作無法復原。',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => '捨棄對「${file}」的所有變更？此操作無法復原。',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => '將分支「${branch}」發布到 ${remote}？',
			'common.gitPanel.confirmPull' => ({required Object remote, required Object count}) => '從 ${remote} 拉取 ${count} 個提交？',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => '推送 ${count} 個提交到 ${remote}？',
			'common.gitPanel.confirmRevert' => '還原最新的本機提交？這會移除提交但保留其變更為暫存狀態。',
			'common.gitPanel.confirmTitles.commit' => '確認操作',
			'common.gitPanel.confirmTitles.delete' => '刪除檔案',
			'common.gitPanel.confirmTitles.deleteBranch' => '刪除分支',
			'common.gitPanel.confirmTitles.discard' => '捨棄變更',
			'common.gitPanel.confirmTitles.publish' => '發布分支',
			'common.gitPanel.confirmTitles.pull' => '確認拉取',
			'common.gitPanel.confirmTitles.push' => '確認推送',
			'common.gitPanel.confirmTitles.revertLocalCommit' => '還原本機提交',
			'common.gitPanel.createBranch' => '建立新分支',
			'common.gitPanel.creating' => '正在建立...',
			'common.gitPanel.delete' => '刪除',
			'common.gitPanel.deleteUntracked' => '刪除未追蹤的檔案',
			'common.gitPanel.deselectAll' => '取消全選',
			'common.gitPanel.discard' => '捨棄',
			'common.gitPanel.discardChanges' => '捨棄變更',
			'common.gitPanel.dismiss' => '關閉',
			'common.gitPanel.dismissError' => '關閉錯誤',
			'common.gitPanel.errors.createBranchFailed' => '建立分支失敗',
			'common.gitPanel.errors.createWorktreeFailed' => '建立 worktree 失敗',
			'common.gitPanel.errors.deleteBranchFailed' => '刪除分支失敗',
			'common.gitPanel.errors.fetchFailed' => 'Fetch 失敗',
			'common.gitPanel.errors.initFailed' => '初始化儲存庫失敗',
			'common.gitPanel.errors.initialCommitFailed' => '建立初始提交失敗',
			'common.gitPanel.errors.mergeFailed' => '合併失敗',
			'common.gitPanel.errors.openWorktreeFailed' => '開啟 worktree 失敗',
			'common.gitPanel.errors.operationFailed' => 'Git 操作失敗',
			'common.gitPanel.errors.publishFailed' => '發布失敗',
			'common.gitPanel.errors.pullFailed' => 'Pull 失敗',
			'common.gitPanel.errors.pushFailed' => 'Push 失敗',
			'common.gitPanel.errors.removeWorktreeFailed' => '移除 worktree 失敗',
			'common.gitPanel.errors.stageFailed' => '暫存失敗',
			'common.gitPanel.errors.stageHunksFailed' => '暫存區塊失敗',
			'common.gitPanel.errors.switchFailed' => '切換分支失敗',
			'common.gitPanel.errors.unstageFailed' => '取消暫存失敗',
			'common.gitPanel.errors.unstageHunksFailed' => '取消區塊暫存失敗',
			'common.gitPanel.expandDiff' => '展開差異',
			'common.gitPanel.fetch' => '擷取',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => '從 ${remote} 擷取',
			'common.gitPanel.fetching' => '正在擷取…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '已選取 ${count} 個檔案',
			'common.gitPanel.generating' => '正在產生...',
			'common.gitPanel.history.added' => '已新增',
			'common.gitPanel.history.author' => '作者',
			'common.gitPanel.history.changedFiles' => '已變更檔案',
			'common.gitPanel.history.date' => '日期',
			'common.gitPanel.history.empty' => '找不到提交',
			'common.gitPanel.history.files' => '檔案',
			'common.gitPanel.history.removed' => '已移除',
			'common.gitPanel.mergeWorktree.cleanupDesc' => '合併後移除 worktree 並刪除其分支',
			'common.gitPanel.mergeWorktree.cleanupLabel' => '合併後清理',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} 個提交',
			'common.gitPanel.mergeWorktree.merge' => '合併',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => '合併分支 \'${branch}\'',
			'common.gitPanel.mergeWorktree.messageLabel' => '提交訊息',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => '將全部 ${commits} 個提交合併為 ${branch} 上的單一提交',
			'common.gitPanel.mergeWorktree.squashLabel' => '壓縮提交（squash）',
			'common.gitPanel.mergeWorktree.squashMerge' => '壓縮並合併',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => '壓縮合併分支 \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => '合併 Worktree',
			'common.gitPanel.merging' => '正在合併...',
			'common.gitPanel.messagePlaceholder' => '訊息（Ctrl+Enter 提交）',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => '這將從目前分支（${branch}）建立新分支',
			'common.gitPanel.newBranch.nameLabel' => '分支名稱',
			'common.gitPanel.newBranch.submit' => '建立分支',
			'common.gitPanel.newBranch.title' => '建立新分支',
			'common.gitPanel.newWorktree.branchLabel' => '分支',
			'common.gitPanel.newWorktree.createFrom' => '建立自',
			'common.gitPanel.newWorktree.description' => '將分支簽出到獨立資料夾中並並行工作。',
			'common.gitPanel.newWorktree.existingBranch' => '現有分支 — 將按原樣簽出。',
			'common.gitPanel.newWorktree.submit' => '建立 Worktree',
			'common.gitPanel.newWorktree.switchAfter' => '建立後切換到該 worktree',
			'common.gitPanel.newWorktree.title' => '新增 Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => '將建立於',
			'common.gitPanel.noChanges' => '未偵測到變更',
			'common.gitPanel.noChangesToCommit' => '沒有可提交的變更',
			'common.gitPanel.noCommits.create' => '建立初始提交',
			'common.gitPanel.noCommits.creating' => '正在建立初始提交...',
			'common.gitPanel.noCommits.description' => '此儲存庫還沒有任何提交。建立第一個提交以開始追蹤變更。',
			'common.gitPanel.noCommits.title' => '尚無提交',
			'common.gitPanel.noMatchingBranches' => '沒有符合的分支',
			'common.gitPanel.noRepo.description' => '此專案還不是 git 儲存庫。初始化一個以開始追蹤變更並使用原始碼管理功能。',
			'common.gitPanel.noRepo.init' => '執行 git init',
			'common.gitPanel.noRepo.initializing' => '正在初始化儲存庫...',
			'common.gitPanel.noRepo.title' => '沒有 git 儲存庫',
			'common.gitPanel.noStagedFiles' => '沒有暫存的檔案',
			'common.gitPanel.none' => '無',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => '沒有可推送到 ${remote} 的內容',
			'common.gitPanel.openFile' => '點擊開啟檔案',
			'common.gitPanel.publish' => '發布',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => '將「${branch}」發布到 ${remote}',
			'common.gitPanel.publishing' => '正在發布…',
			'common.gitPanel.pull' => '拉取',
			'common.gitPanel.pullCount' => ({required Object count}) => '拉取 ${count}',
			'common.gitPanel.pullTitle' => ({required Object remote, required Object count}) => '從 ${remote} 拉取 ${count}',
			'common.gitPanel.pulling' => '正在拉取…',
			'common.gitPanel.push' => '推送',
			'common.gitPanel.pushCount' => ({required Object count}) => '推送 ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => '推送 ${count} 到 ${remote}',
			'common.gitPanel.pushing' => '正在推送…',
			'common.gitPanel.recentCommits' => '最近提交',
			'common.gitPanel.refresh' => '重新整理 git 狀態',
			'common.gitPanel.remove' => '移除',
			'common.gitPanel.removeWorktree.alsoDelete' => '同時刪除分支',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => '移除 ${branch} 的 worktree？其資料夾將被刪除，關聯的專案將被封存 — 聊天工作階段仍可復原。',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => '此 worktree 有 ${count} 個未提交的變更將會遺失。',
			'common.gitPanel.removeWorktree.discardChanges' => '捨棄未提交的變更',
			'common.gitPanel.removeWorktree.title' => '移除 Worktree',
			'common.gitPanel.removing' => '正在移除...',
			'common.gitPanel.revertLatest' => '還原最新本機提交',
			'common.gitPanel.scroll' => '捲動',
			'common.gitPanel.searchBranches' => '搜尋分支...',
			'common.gitPanel.selectAll' => '全選',
			'common.gitPanel.selectProject' => '選擇專案以檢視原始碼管理',
			'common.gitPanel.selectedOf' => ({required Object total, required Object selected}) => '已選取 ${total} 個檔案中的 ${selected} 個',
			'common.gitPanel.selectedOfMobile' => ({required Object total, required Object selected}) => '已選取 ${total} 中的 ${selected} 個',
			'common.gitPanel.sideBySide' => '並排',
			'common.gitPanel.stageAll' => '全部暫存',
			'common.gitPanel.stageHunk' => '暫存此區塊',
			'common.gitPanel.staged' => ({required Object count}) => '已暫存（${count}）',
			'common.gitPanel.status.added' => '已新增',
			'common.gitPanel.status.deleted' => '已刪除',
			'common.gitPanel.status.modified' => '已修改',
			'common.gitPanel.status.untracked' => '未追蹤',
			'common.gitPanel.statusGuide' => '檔案狀態指南',
			'common.gitPanel.switchScroll' => '切換到水平捲動',
			'common.gitPanel.switchSplit' => '切換到並排檢視',
			'common.gitPanel.switchUnified' => '切換到統一檢視',
			'common.gitPanel.switchWrap' => '切換到文字換行',
			'common.gitPanel.unified' => '統一',
			'common.gitPanel.unstageAll' => '全部取消暫存',
			'common.gitPanel.unstageHunk' => '取消暫存此區塊',
			'common.gitPanel.upToDate' => '已是最新',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => '與 ${remote} 同步',
			'common.gitPanel.viewAll' => '檢視全部',
			'common.gitPanel.viewsAria' => '原始碼管理檢視',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} 個變更',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} 個 worktree',
			'common.gitPanel.worktrees.createFirst' => '建立你的第一個 worktree',
			'common.gitPanel.worktrees.detached' => '分離',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => '分離 @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => '分離的 HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'worktree 將分支簽出到獨立資料夾，因此你可以並行執行獨立的聊天工作階段，並在就緒後合併結果。',
			'common.gitPanel.worktrees.emptyTitle' => '並行處理多個分支',
			'common.gitPanel.worktrees.locked' => '已鎖定',
			'common.gitPanel.worktrees.mainWorktree' => '主 worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => '將 ${branch} 合併到基礎分支',
			'common.gitPanel.worktrees.kNew' => '新增 worktree',
			'common.gitPanel.worktrees.none' => '沒有 worktree',
			'common.gitPanel.worktrees.nothingToMerge' => '無可合併內容 — 沒有領先於基礎分支的提交',
			'common.gitPanel.worktrees.open' => '開啟',
			'common.gitPanel.worktrees.refresh' => '重新整理 worktree',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => '移除 ${branch} 的 worktree',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => '切換到 ${branch}',
			'common.gitPanel.wrap' => '換行',
			'common.gitPanel.tabs.changes' => '變更',
			'common.gitPanel.tabs.history' => '提交',
			'common.gitPanel.tabs.branches' => '分支',
			'common.gitPanel.tabs.worktrees' => '工作樹',
			'common.gitPanel.save' => '儲存',
			'common.gitPanel.worktreeScripts.title' => 'Worktree 指令碼',
			'common.gitPanel.worktreeScripts.setup' => '設定指令碼（建立／開啟後執行）',
			'common.gitPanel.worktreeScripts.run' => '啟動開發伺服器',
			'common.gitPanel.worktreeScripts.stop' => '停止開發伺服器',
			'common.gitPanel.worktreeScripts.runScript' => '執行指令碼（開發伺服器，按需啟動）',
			'common.gitPanel.worktreeScripts.runPort' => '預覽連接埠（選填 — 留空時自動偵測）',
			'common.gitPanel.worktreeScripts.invalidPort' => '連接埠必須介於 1 到 65535 之間',
			'common.gitPanel.worktreeScripts.sourceProject' => '已儲存為專案覆寫設定',
			'common.gitPanel.worktreeScripts.sourceFile' => '來自 .ddagent/worktree.json — 儲存後會建立專案覆寫設定',
			'common.gitPanel.worktreeScripts.sourceNone' => '尚未設定任何項目',
			'common.gitPanel.worktreeScripts.saving' => '正在儲存…',
			'common.gitPanel.worktreeScripts.setupRunning' => '設定執行中',
			'common.gitPanel.worktreeScripts.setupFailed' => '設定失敗',
			'common.gitPanel.worktreeScripts.running' => '執行中',
			'common.gitPanel.worktreeScripts.openPreview' => '開啟預覽',
			'common.gitPanel.worktreeScripts.runExited' => ({required Object code}) => '執行已結束（${code}）',
			'common.sessions.renameSession' => '重新命名工作階段',
			'common.projects.newSession' => '新工作階段',
			'common.sharedNotes.subtitle' => '共用記憶 — 會注入此專案的每個工作階段',
			'common.sharedNotes.save' => '儲存',
			'common.sharedNotes.saving' => '正在儲存…',
			'common.sharedNotes.noProject' => '請選擇工作區以編輯其共用上下文',
			'common.sharedNotes.placeholder' => '# 共用上下文\n每個代理都該知道的慣例、決策與參考資訊…',
			'common.codeBlock.wrapLines' => '自動換行',
			'common.codeBlock.noWrap' => '不換行',
			'common.update.available' => ({required Object version}) => '有可用更新 · v${version}',
			'common.update.confirm' => ({required Object version}) => '要更新至 v${version} 嗎？伺服器會自行更新並重新啟動 — 進行中的工作階段將被中斷。',
			'common.update.downloading' => '正在下載並套用更新…',
			'common.update.restarting' => '正在重新啟動伺服器 — 這需要一點時間…',
			'common.update.done' => ({required Object version}) => '已更新至 v${version}。請重新載入應用程式以載入新版本。',
			'common.update.manualRestart' => '更新已套用，但伺服器未自行重新啟動 — 請手動重新啟動以完成。',
			'common.update.failed' => '更新失敗。',
			'common.update.failedTitle' => '更新失敗',
			'common.update.appConfirm' => ({required Object version}) => '要在此裝置上安裝 DDAgent v${version} 嗎？首次安裝時 Android 會要求允許從 DDAgent 安裝應用程式。',
			'common.update.appPermission' => '請為 DDAgent 允許「安裝未知應用程式」，然後再次點選更新。',
			'common.update.chooseTitle' => '有可用的更新',
			'common.update.targetApp' => '此應用程式',
			'common.update.targetWeb' => 'Web 介面',
			'common.update.targetServer' => '伺服器',
			'common.update.updateApp' => '更新應用程式',
			'common.update.updateWeb' => '更新 Web 介面',
			'common.update.updateServer' => '更新伺服器',
			'common.update.webConfirm' => ({required Object version}) => '要將 Web 介面更新到 v${version} 嗎？更新後頁面會重新載入。',
			'common.update.webDone' => ({required Object version}) => 'Web 介面已更新到 v${version} — 正在重新載入…',
			'common.update.localServerConfirm' => ({required Object version}) => '要將此裝置上的本機伺服器更新到 v${version} 嗎？進行中的工作階段會被中斷。',
			'common.update.localServerUpdating' => '正在下載並啟動本機伺服器…',
			'common.update.serverDone' => ({required Object version}) => '伺服器正在執行 v${version}。',
			'common.update.staged' => ({required Object version}) => '已下載更新 v${version} — 請重新啟動伺服器以完成安裝。',
			'common.update.upToDate' => '伺服器已是最新版本。',
			'common.update.webHostFailed' => ({required Object message}) => '伺服器已更新，但其 Web 介面沒有更新：${message}',
			'common.appShell.panelActive' => ({required Object count}) => '面板 · ${count} 個執行中',
			'common.errors.forbidden' => '存取遭拒',
			'settings.title' => '設定',
			'settings.changelog.title' => '更新日誌',
			'settings.changelog.loading' => '載入中…',
			'settings.changelog.empty' => '沒有可顯示的版本',
			'settings.changelog.current' => '目前',
			'settings.changelog.kNew' => '新',
			'settings.server.title' => '伺服器',
			'settings.server.description' => '重新啟動 DDAgent 處理程序 — 適用於套用更新或從卡住狀態復原。',
			'settings.server.restart' => '重新啟動',
			'settings.server.restartConfirm' => '確定要重新啟動 DDAgent 伺服器?進行中的工作階段將被中斷。',
			'settings.server.restarting' => '正在重新啟動… 伺服器恢復後頁面將自動重新整理。',
			'settings.server.restartFailed' => '重新啟動失敗',
			'settings.server.unsupported' => '僅當伺服器在服務管理員下執行時才可重新啟動。',
			'settings.server.ok' => '確定',
			'settings.server.restartTitle' => '正在重新啟動伺服器',
			'settings.server.restartRequesting' => '正在要求伺服器重新啟動…',
			'settings.server.restartWaiting' => ({required Object seconds}) => '正在等待伺服器恢復…（${seconds} 秒）',
			'settings.server.restartBack' => ({required Object version}) => '伺服器已恢復 — 版本 ${version}。',
			'settings.server.restartReloading' => '正在重新載入頁面…',
			'settings.server.restartTimeout' => ({required Object seconds}) => '伺服器未在 ${seconds} 秒內恢復。請檢查服務記錄檔（/tmp/ddagent.log）或手動重新啟動。',
			'settings.updates.title' => '更新',
			'settings.updates.description' => '在 GitHub 上檢查更新的桌面版本。新版本會自動下載並在退出時安裝。',
			'settings.updates.descriptionMobile' => '在 GitHub 上檢查此應用程式是否有較新的版本。更新會由裝置的系統安裝程式安裝。',
			'settings.updates.descriptionServer' => '在 GitHub 上檢查是否有較新的 DDAgent 版本。已連線的伺服器可自行更新 — 重新啟動期間，進行中的工作階段會中斷。',
			'settings.updates.check' => '檢查更新',
			'settings.updates.checking' => '正在檢查…',
			'settings.updates.upToDate' => ({required Object version}) => '已是最新版本（v${version}）。',
			'settings.updates.available' => ({required Object version}) => '發現更新 v${version} — 正在背景下載；退出 DDAgent 時自動安裝。',
			'settings.updates.appAvailable' => ({required Object version}) => '有可用的應用程式更新 v${version} — 點選「更新」即可在此裝置上安裝。',
			'settings.updates.downloaded' => ({required Object version}) => '更新 v${version} 已下載 — 退出並重新啟動 DDAgent 即可安裝。',
			'settings.updates.unavailable' => '更新檢查僅在打包的桌面版本中可用。',
			'settings.updates.error' => ({required Object message}) => '更新檢查失敗：${message}',
			'settings.updates.errorGeneric' => '更新檢查失敗。',
			'settings.updates.versionLine' => ({required Object installed, required Object latest}) => 'v${installed} · 最新 v${latest}',
			'settings.updates.current' => ({required Object version}) => 'v${version} — 已是最新',
			'settings.updates.webNotHosted' => ({required Object version}) => '此 Web 介面另外託管——請以發行版中的 ddagent-flutter-web-v${version}.zip 取代其檔案。',
			'settings.updates.serverCannotUpdate' => '此伺服器無法在這裡自行更新——請用 install.sh 或發行版的 tarball 重新安裝。',
			'settings.tabs.account' => '帳戶',
			'settings.tabs.permissions' => '權限',
			'settings.tabs.mcpServers' => 'MCP 伺服器',
			'settings.tabs.skills' => '技能',
			'settings.tabs.appearance' => '外觀',
			'settings.account.title' => '帳戶',
			'settings.account.language' => '語言',
			'settings.account.languageLabel' => '顯示語言',
			'settings.account.languageDescription' => '選擇您偏好的介面語言',
			'settings.account.username' => '使用者名稱',
			'settings.account.email' => '電子郵件',
			'settings.account.profile' => '個人檔案',
			'settings.account.changePassword' => '變更密碼',
			'settings.mcp.title' => 'MCP 伺服器',
			'settings.mcp.addServer' => '新增伺服器',
			'settings.mcp.editServer' => '編輯伺服器',
			'settings.mcp.deleteServer' => '刪除伺服器',
			'settings.mcp.serverName' => '伺服器名稱',
			'settings.mcp.serverType' => '伺服器類型',
			'settings.mcp.config' => '設定',
			'settings.mcp.testConnection' => '測試連線',
			'settings.mcp.status' => '狀態',
			'settings.mcp.connected' => '已連線',
			'settings.mcp.disconnected' => '未連線',
			'settings.mcp.scope.label' => '範圍',
			'settings.mcp.scope.user' => '使用者',
			'settings.mcp.scope.project' => '專案',
			'settings.appearance.title' => '外觀',
			_ => null,
		} ?? switch (path) {
			'settings.appearance.theme' => '佈景主題',
			'settings.appearance.codeEditor' => '程式碼編輯器',
			'settings.appearance.editorTheme' => '編輯器佈景主題',
			'settings.appearance.wordWrap' => '自動換行',
			'settings.appearance.showMinimap' => '顯示縮圖',
			'settings.appearance.lineNumbers' => '行號',
			'settings.appearance.fontSize' => '字型大小',
			'settings.appearance.themeModes.system' => '系統',
			'settings.appearance.themeModes.light' => '淺色',
			'settings.appearance.themeModes.dark' => '深色',
			'settings.actions.saveChanges' => '儲存變更',
			'settings.actions.resetToDefaults' => '重設為預設值',
			'settings.actions.cancelChanges' => '取消變更',
			'settings.quickSettings.title' => '快速設定',
			'settings.quickSettings.sections.appearance' => '外觀',
			'settings.quickSettings.sections.toolDisplay' => '工具顯示',
			'settings.quickSettings.sections.inputSettings' => '輸入設定',
			'settings.quickSettings.darkMode' => '深色模式',
			'settings.quickSettings.showRawParameters' => '顯示原始參數',
			'settings.quickSettings.showThinking' => '顯示思考過程',
			'settings.quickSettings.sendByCtrlEnter' => '使用 Ctrl+Enter 傳送',
			'settings.quickSettings.sendByCtrlEnterDescription' => '啟用後，按 Ctrl+Enter 傳送訊息，而不是僅按 Enter。這對於使用輸入法的使用者可以避免意外傳送。',
			'settings.quickSettings.dragHandle.dragging' => '正在拖曳手柄',
			'settings.quickSettings.dragHandle.closePanel' => '關閉設定面板',
			'settings.quickSettings.dragHandle.openPanel' => '開啟設定面板',
			'settings.quickSettings.dragHandle.draggingStatus' => '正在拖曳...',
			'settings.quickSettings.dragHandle.toggleAndMove' => '點擊切換，拖曳移動',
			'settings.quickSettings.sendWithCtrlEnter' => '使用 Ctrl+Enter 傳送',
			'settings.quickSettings.enterSendsHint' => '關閉時，按 Enter 傳送，按 Shift+Enter 換行。',
			'settings.terminalShortcuts.title' => '終端機快速鍵',
			'settings.terminalShortcuts.sectionKeys' => '按鍵',
			'settings.terminalShortcuts.sectionNavigation' => '導覽',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => '向上箭頭',
			'settings.terminalShortcuts.arrowDown' => '向下箭頭',
			'settings.terminalShortcuts.scrollDown' => '捲動到底部',
			'settings.terminalShortcuts.killTitle' => '終止執行中的程序 (Ctrl+C)',
			'settings.terminalShortcuts.handle.closePanel' => '關閉快速鍵面板',
			'settings.terminalShortcuts.handle.openPanel' => '開啟快速鍵面板',
			'settings.terminalShortcuts.paste' => '貼上',
			'settings.mainTabs.label' => '設定',
			'settings.mainTabs.agents' => '智慧代理',
			'settings.mainTabs.orchestration' => '編排',
			'settings.mainTabs.miniOrchestration' => '迷你編排',
			'settings.mainTabs.appearance' => '外觀',
			'settings.mainTabs.workspaces' => '工作區',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API 和權杖',
			'settings.mainTabs.models' => '模型',
			'settings.mainTabs.tasks' => '任務',
			'settings.mainTabs.browser' => '瀏覽器',
			'settings.mainTabs.tools' => '工具',
			'settings.mainTabs.notifications' => '通知',
			'settings.mainTabs.about' => '關於',
			'settings.mainTabs.quota' => 'Control Center',
			'settings.mainTabs.shortcuts' => '鍵盤快捷鍵',
			'settings.miniOrchestration.title' => '迷你編排',
			'settings.miniOrchestration.description' => '雙模型流程：由非 flash 的思考者規劃，flash 執行者負責執行。',
			'settings.miniOrchestration.loading' => '正在載入迷你編排設定…',
			'settings.miniOrchestration.loadError' => '無法載入迷你編排設定。',
			'settings.miniOrchestration.enable.label' => '啟用迷你編排',
			'settings.miniOrchestration.enable.description' => '讓「自動（迷你）」工作階段改走雙角色引擎，而非完整的編排器。',
			'settings.miniOrchestration.thinker.title' => '思考者（非 flash）',
			'settings.miniOrchestration.thinker.description' => '負責規劃、決策、審查並撰寫最終報告。',
			'settings.miniOrchestration.worker.title' => '執行者（flash）',
			'settings.miniOrchestration.worker.description' => '執行每個規劃好的步驟。',
			'settings.miniOrchestration.fields.provider' => '提供者',
			'settings.miniOrchestration.fields.model' => '模型',
			'settings.miniOrchestration.fields.modelPlaceholder' => '選擇模型',
			'settings.miniOrchestration.fields.tier' => '等級',
			'settings.miniOrchestration.roles.title' => '依任務指定模型',
			'settings.miniOrchestration.roles.description' => '各任務類型由哪個模型（角色）處理。',
			'settings.miniOrchestration.planner.title' => '規劃器',
			'settings.miniOrchestration.planner.mode' => '模式',
			'settings.miniOrchestration.planner.modes.auto' => '由思考者規劃',
			'settings.miniOrchestration.planner.modes.off' => '單一步驟',
			'settings.miniOrchestration.planner.requireConfirmLabel' => '執行前先確認計畫',
			'settings.orchestration.title' => '編排',
			'settings.orchestration.description' => '將聊天任務分派到你的各個提供者與模型。',
			'settings.orchestration.loading' => '正在載入編排設定…',
			'settings.orchestration.loadError' => '無法載入編排設定。',
			'settings.orchestration.retry' => '重試',
			'settings.orchestration.enable.label' => '啟用編排',
			'settings.orchestration.enable.description' => '讓編排器為每個步驟挑選模型，而不是全部在同一個提供者上執行。',
			'settings.orchestration.pool.title' => '候選池',
			'settings.orchestration.pool.description' => '路由器可挑選的模型，每個都對應一個成本等級。',
			'settings.orchestration.pool.add' => '新增候選',
			'settings.orchestration.pool.empty' => '尚無候選 — 新增一個即可開始路由。',
			'settings.orchestration.pool.fields.label' => '標籤',
			'settings.orchestration.pool.fields.labelPlaceholder' => '例如 SWE-2 Medium',
			'settings.orchestration.pool.fields.provider' => '提供者',
			'settings.orchestration.pool.fields.model' => '模型',
			'settings.orchestration.pool.fields.modelPlaceholder' => '選擇模型',
			'settings.orchestration.pool.fields.effort' => '推理強度',
			'settings.orchestration.pool.fields.effortDefault' => '提供者預設值',
			'settings.orchestration.pool.fields.effortPlaceholder' => '預設',
			'settings.orchestration.pool.fields.account' => '帳戶',
			'settings.orchestration.pool.fields.accountDefault' => '提供者預設值',
			'settings.orchestration.pool.fields.redundantAccounts' => '備援帳號',
			'settings.orchestration.pool.fields.redundantAccountsNone' => '此供應商沒有其他帳號',
			'settings.orchestration.pool.fields.tier' => '成本等級',
			'settings.orchestration.pool.fields.remove' => '移除候選',
			'settings.orchestration.pool.fields.moveUp' => '上移',
			'settings.orchestration.pool.fields.moveDown' => '下移',
			'settings.orchestration.tiers.free' => '免費',
			'settings.orchestration.tiers.cheap' => '低價',
			'settings.orchestration.tiers.mid' => '中價',
			'settings.orchestration.tiers.premium' => '高階',
			'settings.orchestration.rules.title' => '路由規則',
			'settings.orchestration.rules.description' => '依任務類型排序的候選 — 第一個可用者勝出。',
			'settings.orchestration.rules.addCandidate' => '新增候選…',
			'settings.orchestration.rules.empty' => '沒有候選 — 此任務類型無處可分派。',
			'settings.orchestration.rules.missing' => '（已移除）',
			'settings.orchestration.rules.remove' => '移除候選',
			'settings.orchestration.rules.taskTypes.plan' => '規劃',
			'settings.orchestration.rules.taskTypes.quick' => '快速回答',
			'settings.orchestration.rules.taskTypes.research' => '研究',
			'settings.orchestration.rules.taskTypes.docs' => '文件',
			'settings.orchestration.rules.taskTypes.code' => '程式撰寫',
			'settings.orchestration.rules.taskTypes.codeHard' => '複雜程式撰寫',
			'settings.orchestration.rules.taskTypes.test' => '測試',
			'settings.orchestration.rules.taskTypes.review' => '審查',
			'settings.orchestration.rules.taskTypes.report' => '報告',
			'settings.orchestration.planner.title' => '規劃器',
			'settings.orchestration.planner.description' => '請求如何拆分成可路由的步驟。',
			'settings.orchestration.planner.modeLabel' => '規劃模式',
			'settings.orchestration.planner.modes.auto' => '自動（LLM）',
			'settings.orchestration.planner.modes.template' => '範本',
			'settings.orchestration.planner.modes.off' => '關閉',
			'settings.orchestration.planner.modeHints.auto' => '規劃器模型會將每個請求拆解為具類型的步驟。',
			'settings.orchestration.planner.modeHints.template' => '請求會依你在下方選擇的固定流程執行。',
			'settings.orchestration.planner.modeHints.off' => '不進行規劃 — 整個請求以單一步驟路由。',
			'settings.orchestration.planner.candidateLabel' => '規劃器模型',
			'settings.orchestration.planner.candidateDescription' => '用於產生計畫與分類呼叫的候選池模型。',
			'settings.orchestration.planner.candidatePlaceholder' => '選擇候選池中的模型',
			'settings.orchestration.planner.templates.title' => '流程範本',
			'settings.orchestration.planner.templates.add' => '新增範本',
			'settings.orchestration.planner.templates.namePlaceholder' => '範本名稱',
			'settings.orchestration.planner.templates.addStep' => '新增步驟…',
			'settings.orchestration.planner.templates.remove' => '移除範本',
			'settings.orchestration.planner.templates.removeStep' => '移除步驟',
			'settings.orchestration.planner.templates.empty' => '尚無範本。',
			'settings.orchestration.planner.templates.emptySteps' => '尚無步驟 — 請在下方新增。',
			'settings.orchestration.planner.requireConfirm' => '執行前確認計畫',
			'settings.orchestration.planner.requireConfirmDescription' => '規劃完成後暫停，讓你在計畫卡片上編輯或停用步驟。',
			'settings.orchestration.planner.checkpointLabel' => '自主程度',
			'settings.orchestration.planner.checkpointModes.off' => '完全自主',
			'settings.orchestration.planner.checkpointModes.perStep' => '每個步驟',
			'settings.orchestration.planner.checkpointModes.everyN' => '每 N 個步驟',
			'settings.orchestration.planner.checkpointHints.off' => '監督者的決策會直接執行，不另行詢問（自動模式）。',
			'settings.orchestration.planner.checkpointHints.perStep' => '每批建議步驟執行前都先徵求核准。',
			'settings.orchestration.planner.checkpointHints.everyN' => '每完成 N 個步驟後徵求核准。',
			'settings.orchestration.planner.checkpointIntervalLabel' => '檢查點之間的步驟數（1–50）',
			'settings.orchestration.execution.title' => '執行限制',
			'settings.orchestration.execution.description' => '平行執行與修正迴圈的防護設定。',
			'settings.orchestration.execution.maxParallel' => '最大平行步驟數',
			'settings.orchestration.execution.maxParallelDescription' => '可同時執行的子任務數量（1–8）。',
			'settings.orchestration.execution.maxFixLoops' => '最大修正迴圈數',
			'settings.orchestration.execution.maxFixLoopsDescription' => '步驟未通過驗證時的重試次數（0–5）。',
			'settings.orchestration.execution.onNoCandidate' => '沒有可用候選時',
			'settings.orchestration.execution.onNoCandidateDescription' => '改用備援前先詢問，或略過該步驟。',
			'settings.orchestration.execution.onNoCandidateOptions.ask' => '詢問',
			'settings.orchestration.execution.onNoCandidateOptions.skip' => '略過步驟',
			'settings.orchestration.execution.useWorktree' => '獨立 worktree',
			'settings.orchestration.execution.useWorktreeDescription' => '在單一共用的 git worktree 中執行所有委派步驟，而非專案目錄。',
			'settings.orchestration.execution.maxSupervisorIterations' => '監督者最大迭代次數',
			'settings.orchestration.execution.maxSupervisorIterationsDescription' => '自動模式下監督者決策輪數的上限（1–100）；達到上限時，執行會以部分報告結束。',
			'settings.orchestration.execution.maxAttempts' => '每個步驟的最大嘗試次數',
			'settings.orchestration.execution.maxAttemptsDescription' => '單一步驟在所有通道與重試中可用的總嘗試次數（1–50）。',
			'settings.orchestration.execution.stepTimeoutMs' => '步驟逾時（毫秒）',
			'settings.orchestration.execution.stepTimeoutMsDescription' => '每次嘗試的子執行逾時（毫秒）；0 表示停用。',
			'settings.orchestration.execution.runTimeoutMs' => '執行逾時（毫秒）',
			'settings.orchestration.execution.runTimeoutMsDescription' => '整個計畫執行的全域逾時（毫秒）；0 表示停用。',
			'settings.orchestration.execution.retryBackoffBaseMs' => '重試退避基準（毫秒）',
			'settings.orchestration.execution.retryBackoffBaseMsDescription' => '同一通道重試之間指數退避的基準值（完全抖動）。',
			'settings.orchestration.execution.retryBudgetTitle' => '各失敗類型的重試額度',
			'settings.orchestration.execution.retryBudgetDescription' => '容錯移轉／冷卻前在同一通道的重試次數（0–5）。',
			'settings.orchestration.execution.retryClasses.rateLimit' => '速率限制',
			'settings.orchestration.execution.retryClasses.quota' => '配額',
			'settings.orchestration.execution.retryClasses.auth' => '驗證',
			'settings.orchestration.execution.retryClasses.timeout' => '逾時',
			'settings.orchestration.execution.retryClasses.transient' => '暫時性錯誤',
			'settings.orchestration.save.unsaved' => '有未儲存的變更',
			'settings.orchestration.save.save' => '儲存',
			'settings.orchestration.save.saving' => '正在儲存…',
			'settings.orchestration.save.saved' => '已儲存',
			'settings.orchestration.save.discard' => '捨棄',
			'settings.orchestration.save.error' => '儲存失敗',
			'settings.orchestration.save.emptyPool' => '儲存前請至少新增一個候選。',
			'settings.notifications.title' => '通知',
			'settings.notifications.description' => '控制你希望接收的通知事件。',
			'settings.notifications.webPush.title' => 'Web 推播通知',
			'settings.notifications.webPush.enable' => '啟用推播通知',
			'settings.notifications.webPush.disable' => '關閉推播通知',
			'settings.notifications.webPush.enabled' => '推播通知已啟用',
			'settings.notifications.webPush.loading' => '更新中...',
			'settings.notifications.webPush.unsupported' => '此瀏覽器不支援推播通知。',
			'settings.notifications.webPush.denied' => '推播通知已被封鎖，請在瀏覽器設定中允許。',
			'settings.notifications.webPush.iosHint' => '在 iPhone/iPad 上，只有將 DDAgent 加入主畫面（分享 → 加入主畫面）並在安裝的 App 中啟用通知後，通知才有效。',
			'settings.notifications.webPush.test' => '傳送測試通知',
			'settings.notifications.webPush.testNoSubscription' => '沒有已訂閱的裝置。請先在手機上點擊「啟用」。',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => '已傳送到 ${count} 台裝置。如果手機上沒有顯示，請將 DDAgent 加入主畫面（iOS 要求）。',
			'settings.notifications.webPush.testNotDelivered' => '沒有可連線的裝置。請確認應用程式正在執行且通知已開啟。',
			'settings.notifications.device.title' => '通知此裝置',
			'settings.notifications.device.enabled' => '此裝置的通知已啟用',
			'settings.notifications.desktop.title' => '通知此桌面應用程式',
			'settings.notifications.desktop.enable' => '啟用推播通知',
			'settings.notifications.desktop.disable' => '關閉推播通知',
			'settings.notifications.desktop.enabled' => '此桌面應用程式已啟用通知',
			'settings.notifications.desktop.unsupported' => '此系統不支援桌面通知。',
			'settings.notifications.sound.title' => '聲音',
			'settings.notifications.sound.description' => '聊天執行完成時播放短提示音。',
			'settings.notifications.sound.enabled' => '已啟用',
			'settings.notifications.sound.test' => '測試聲音',
			'settings.notifications.events.title' => '事件類型',
			'settings.notifications.events.actionRequired' => '需要處理',
			'settings.notifications.events.stop' => '執行已停止',
			'settings.notifications.events.error' => '執行失敗',
			'settings.notifications.messaging.title' => '透過通訊軟體核准',
			'settings.notifications.messaging.description' => '在 Telegram 上核准或拒絕代理的權限請求，並在 Discord 上接收執行通知。',
			'settings.notifications.messaging.enabled' => '已啟用',
			'settings.notifications.messaging.save' => '儲存',
			'settings.notifications.messaging.test' => '測試',
			'settings.notifications.messaging.pair' => '配對',
			'settings.notifications.messaging.telegramToken' => '來自 @BotFather 的機器人權杖（123456:ABC…）',
			'settings.notifications.messaging.telegramHint' => '先傳送任意訊息給你的機器人，再於下方配對該聊天。',
			'settings.notifications.messaging.discordWebhook' => 'https://discord.com/api/webhooks/…',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.unpair' => '取消配對',
			'settings.appearanceSettings.darkMode.label' => '深色模式',
			'settings.appearanceSettings.darkMode.description' => '切換淺色和深色佈景主題',
			'settings.appearanceSettings.codeEditor.title' => '程式碼編輯器',
			'settings.appearanceSettings.codeEditor.theme.label' => '編輯器佈景主題',
			'settings.appearanceSettings.codeEditor.theme.description' => '程式碼編輯器的預設佈景主題',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => '自動換行',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => '在編輯器中預設啟用自動換行',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => '顯示縮圖',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => '在差異檢視中顯示縮圖以便於導覽',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => '顯示行號',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => '在編輯器中顯示行號',
			'settings.appearanceSettings.codeEditor.fontSize.label' => '字型大小',
			'settings.appearanceSettings.codeEditor.fontSize.description' => '編輯器字型大小（px）',
			'settings.appearanceSettings.terminal.title' => '終端機',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => '焦點跟隨指標',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => '將滑鼠移到終端機上時聚焦終端機以便輸入',
			'settings.mcpForm.title.add' => '新增 MCP 伺服器',
			'settings.mcpForm.title.edit' => '編輯 MCP 伺服器',
			'settings.mcpForm.importMode.form' => '表單輸入',
			'settings.mcpForm.importMode.json' => 'JSON 匯入',
			'settings.mcpForm.scope.label' => '範圍',
			'settings.mcpForm.scope.userGlobal' => '使用者（全域）',
			'settings.mcpForm.scope.projectLocal' => '專案（本機）',
			'settings.mcpForm.scope.userDescription' => '使用者範圍：在您機器上的所有專案中可用',
			'settings.mcpForm.scope.projectDescription' => '本機範圍：僅在選定專案中可用',
			'settings.mcpForm.scope.cannotChange' => '編輯現有伺服器時無法變更範圍',
			'settings.mcpForm.fields.serverName' => '伺服器名稱',
			'settings.mcpForm.fields.transportType' => '傳輸類型',
			'settings.mcpForm.fields.command' => '指令',
			'settings.mcpForm.fields.arguments' => '參數（每行一個）',
			'settings.mcpForm.fields.jsonConfig' => 'JSON 設定',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => '環境變數（KEY=值，每行一個）',
			'settings.mcpForm.fields.headers' => '標頭（KEY=值，每行一個）',
			'settings.mcpForm.fields.selectProject' => '選取專案...',
			'settings.mcpForm.placeholders.serverName' => '我的服務',
			'settings.mcpForm.validation.missingType' => '缺少必填欄位：type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdio 類型需要 command 欄位',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type} 類型需要 url 欄位',
			'settings.mcpForm.validation.invalidJson' => '無效的 JSON 格式',
			'settings.mcpForm.validation.jsonHelp' => '貼上您的 MCP 伺服器設定（JSON 格式）。範例格式：',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => '設定詳細資訊（來自 ${configFile}）',
			'settings.mcpForm.projectPath' => ({required Object path}) => '路徑：${path}',
			'settings.mcpForm.actions.cancel' => '取消',
			'settings.mcpForm.actions.saving' => '儲存中...',
			'settings.mcpForm.actions.addServer' => '新增伺服器',
			'settings.mcpForm.actions.updateServer' => '更新伺服器',
			'settings.saveStatus.success' => '設定儲存成功！',
			'settings.saveStatus.error' => '儲存設定失敗',
			'settings.saveStatus.saving' => '儲存中...',
			'settings.footerActions.save' => '儲存設定',
			'settings.footerActions.cancel' => '取消',
			'settings.git.title' => 'Git 設定',
			'settings.git.description' => '設定您的 git 提交身分。這些設定將透過 git config --global 全域套用',
			'settings.git.name.label' => 'Git 名稱',
			'settings.git.name.help' => '您的 git 提交名稱',
			'settings.git.name.placeholder' => '王小明',
			'settings.git.email.label' => 'Git 電子郵件',
			'settings.git.email.help' => '您的 git 提交電子郵件',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => '儲存設定',
			'settings.git.actions.saving' => '儲存中...',
			'settings.git.status.success' => '儲存成功',
			'settings.git.status.error' => '儲存失敗',
			'settings.apiKeys.title' => 'API 金鑰',
			'settings.apiKeys.description' => '產生 API 金鑰以從其他應用程式存取外部 API。',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ 儲存您的 API 金鑰',
			'settings.apiKeys.newKey.alertMessage' => '這是您唯一一次看到此金鑰。請妥善保存。',
			'settings.apiKeys.newKey.iveSavedIt' => '我已儲存',
			'settings.apiKeys.form.placeholder' => 'API 金鑰名稱（例如：正式伺服器）',
			'settings.apiKeys.form.createButton' => '建立',
			'settings.apiKeys.form.cancelButton' => '取消',
			'settings.apiKeys.newButton' => '新增 API 金鑰',
			'settings.apiKeys.empty' => '尚未建立 API 金鑰。',
			'settings.apiKeys.list.created' => '建立時間：',
			'settings.apiKeys.list.lastUsed' => '最後使用：',
			'settings.apiKeys.confirmDelete' => '確定要刪除此 API 金鑰嗎？',
			'settings.apiKeys.status.active' => '啟用',
			'settings.apiKeys.status.inactive' => '未啟用',
			'settings.apiKeys.github.title' => 'GitHub 權杖',
			'settings.apiKeys.github.description' => '新增 GitHub 個人存取權杖以透過外部 API 複製私有儲存庫。',
			'settings.apiKeys.github.descriptionAlt' => '新增 GitHub 個人存取權杖以複製私有儲存庫。您也可以直接在 API 請求中傳遞權杖而無需儲存。',
			'settings.apiKeys.github.addButton' => '新增權杖',
			'settings.apiKeys.github.form.namePlaceholder' => '權杖名稱（例如：個人儲存庫）',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHub 個人存取權杖（ghp_...）',
			'settings.apiKeys.github.form.descriptionPlaceholder' => '描述（選填）',
			'settings.apiKeys.github.form.addButton' => '新增權杖',
			'settings.apiKeys.github.form.cancelButton' => '取消',
			'settings.apiKeys.github.form.howToCreate' => '如何建立 GitHub 個人存取權杖 →',
			'settings.apiKeys.github.form.showToken' => '顯示權杖',
			'settings.apiKeys.github.form.hideToken' => '隱藏權杖',
			'settings.apiKeys.github.empty' => '尚未新增 GitHub 權杖。',
			'settings.apiKeys.github.added' => '新增時間：',
			'settings.apiKeys.github.confirmDelete' => '確定要刪除此 GitHub 權杖嗎？',
			'settings.apiKeys.apiDocsLink' => 'API 文件',
			'settings.apiKeys.documentation.title' => '外部 API 文件',
			'settings.apiKeys.documentation.description' => '了解如何使用外部 API 從您的應用程式觸發 Claude/Cursor 工作階段。',
			'settings.apiKeys.documentation.viewLink' => '查看 API 文件 →',
			'settings.apiKeys.loading' => '載入中...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => '有可用更新：v${version}',
			'settings.tasks.checking' => '正在檢查 TaskMaster 安裝...',
			'settings.tasks.notInstalled.title' => '未安裝 TaskMaster AI CLI',
			'settings.tasks.notInstalled.description' => '需要 TaskMaster CLI 才能使用任務管理功能。安裝它以開始使用：',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => '在 GitHub 上查看',
			'settings.tasks.notInstalled.afterInstallation' => '安裝後：',
			'settings.tasks.notInstalled.steps.restart' => '重新啟動此應用程式',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster 功能將自動啟用',
			'settings.tasks.notInstalled.steps.initCommand' => '在專案目錄中使用 task-master init',
			'settings.tasks.settings.enableLabel' => '啟用 TaskMaster 整合',
			'settings.tasks.settings.enableDescription' => '在整個介面中顯示 TaskMaster 任務、橫幅和側邊欄指示器',
			'settings.agents.authStatus.checking' => '檢查中...',
			'settings.agents.authStatus.connected' => '已連線',
			'settings.agents.authStatus.notConnected' => '未連線',
			'settings.agents.authStatus.disconnected' => '已中斷連線',
			'settings.agents.authStatus.checkingAuth' => '正在檢查驗證狀態...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => '登入為 ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider} 帳戶',
			'settings.agents.authStatus.authenticatedUser' => '已驗證使用者',
			'settings.agents.install.title' => ({required Object agent}) => '未安裝 ${agent} CLI',
			'settings.agents.install.description' => ({required Object agent}) => '安裝 ${agent} CLI 以登入並執行工作階段。',
			'settings.agents.install.button' => '安裝',
			'settings.agents.install.installing' => '安裝中…',
			'settings.agents.install.copyCommand' => '複製指令',
			'settings.agents.install.docs' => '文件',
			'settings.agents.install.success' => ({required Object agent}) => '${agent} CLI 已安裝',
			'settings.agents.install.failed' => '安裝失敗 — 請檢查終端機輸出',
			'settings.agents.update.title' => '更新 CLI',
			'settings.agents.update.description' => ({required Object agent}) => '在伺服器主機上安裝最新版本的 ${agent} CLI。',
			'settings.agents.update.button' => '更新',
			'settings.agents.update.updating' => '正在更新…',
			'settings.agents.update.success' => ({required Object agent}) => '${agent} CLI 已更新',
			'settings.agents.update.failed' => '更新失敗 — 請查看終端機輸出',
			'settings.agents.account.claude.description' => 'Anthropic Claude AI 助手',
			'settings.agents.account.cursor.description' => 'Cursor AI 驅動的程式碼編輯器',
			'settings.agents.account.codex.description' => 'OpenAI Codex AI 助手',
			'settings.agents.account.opencode.description' => 'OpenCode CLI 助手',
			'settings.agents.account.commandcode.description' => 'Command Code CLI 助手',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI 助手',
			'settings.agents.account.devin.description' => 'Devin CLI 助手',
			'settings.agents.connectionStatus' => '連線狀態',
			'settings.agents.login.title' => '登入',
			'settings.agents.login.reAuthenticate' => '重新驗證',
			'settings.agents.login.description' => ({required Object agent}) => '登入您的 ${agent} 帳戶以啟用 AI 功能',
			'settings.agents.login.reAuthDescription' => '使用其他帳戶登入或重新整理憑證',
			'settings.agents.login.button' => '登入',
			'settings.agents.login.reLoginButton' => '重新登入',
			'settings.agents.logout.title' => '登出',
			'settings.agents.logout.description' => '登出此提供者並清除已儲存的認證資訊',
			'settings.agents.logout.button' => '登出',
			'settings.agents.logout.confirmTitle' => ({required Object agent}) => '登出 ${agent}？',
			'settings.agents.logout.confirmDescription' => ({required Object agent}) => '這會刪除伺服器上儲存的 ${agent} 認證資訊。請重新登入以繼續使用 ${agent}。',
			'settings.agents.logout.success' => '已登出',
			'settings.agents.logout.failed' => '登出失敗',
			'settings.agents.error' => ({required Object error}) => '錯誤：${error}',
			'settings.agents.accounts.title' => '具名帳戶',
			'settings.agents.accounts.description' => '額外的憑證組。釘選到某個帳戶的工作階段，會以該帳戶獨立的設定目錄啟動 CLI。請使用下方顯示的環境變數執行一次提供者 CLI 以完成登入。',
			'settings.agents.accounts.sharedCli' => '所有帳戶共用同一個 CLI 安裝 — 請在上方的連線卡片中更新。',
			'settings.agents.accounts.loading' => '正在載入帳戶…',
			'settings.agents.accounts.kDefault' => '預設',
			'settings.agents.accounts.usage' => ({required Object tokens}) => '${tokens} 個 token',
			'settings.agents.accounts.usageButton' => '用量',
			'settings.agents.accounts.showUsage' => '顯示 token 用量',
			'settings.agents.accounts.makeDefault' => '設為預設',
			'settings.agents.accounts.remove' => '移除帳戶',
			'settings.agents.accounts.newLabel' => '帳戶標籤（例如：工作）',
			'settings.agents.accounts.add' => '新增帳戶',
			'settings.agents.accounts.autoSwitch.label' => '達到用量上限時自動切換帳號',
			'settings.agents.accounts.autoSwitch.description' => '當某個帳號達到用量上限時，工作階段會切換到同一代理程式下仍有額度的另一個帳號——即使你手動選擇了已用盡的帳號。絕不會切換到其他代理程式。Claude 和 Codex 會保留對話；其他代理程式僅在新對話中切換。',
			'settings.permissions.title' => '權限設定',
			'settings.permissions.permissionMode.title' => '權限模式',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => '新 ${provider} 工作階段的預設權限模式。你仍可為單一工作階段覆寫。',
			'settings.permissions.permissionMode.modes.kDefault.title' => '預設',
			'settings.permissions.permissionMode.modes.kDefault.description' => '需要權限的操作會在聊天中顯示供你核准。',
			'settings.permissions.permissionMode.modes.auto.title' => '自動模式',
			'settings.permissions.permissionMode.modes.auto.description' => '由模型分類器針對每次工具呼叫決定核准或拒絕。免手動操作，但比 Bypass 安全——仍可能發生拒絕。',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => '接受編輯',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => '檔案編輯自動核准；其他操作仍會請求你的核准。',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => '略過權限',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => '每個操作都自動核准 — 無提示完整存取。請謹慎使用。',
			'settings.permissions.permissionMode.modes.plan.title' => '計畫',
			'settings.permissions.permissionMode.modes.plan.description' => '計畫模式：代理只探索與規劃，不執行命令。',
			'settings.mcpServers.title' => 'MCP 伺服器',
			'settings.mcpServers.description.claude' => 'Model Context Protocol 伺服器為 Claude 提供額外的工具和資料來源',
			'settings.mcpServers.description.cursor' => 'Model Context Protocol 伺服器為 Cursor 提供額外的工具和資料來源',
			'settings.mcpServers.description.codex' => 'Model Context Protocol 伺服器為 Codex 提供額外的工具和資料來源',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol 伺服器為 OpenCode 提供額外的工具和資料來源',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol 伺服器為 Command Code 提供額外的工具和資料來源',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol 伺服器為 Antigravity 提供額外的工具和資料來源',
			'settings.mcpServers.description.devin' => 'Model Context Protocol 伺服器為 Devin 提供額外的工具和資料來源',
			'settings.mcpServers.addButton' => '新增 MCP 伺服器',
			'settings.mcpServers.empty' => '未設定 MCP 伺服器',
			'settings.mcpServers.serverType' => '類型',
			'settings.mcpServers.scope.local' => '本機',
			'settings.mcpServers.scope.user' => '使用者',
			'settings.mcpServers.config.command' => '指令',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => '參數',
			'settings.mcpServers.config.environment' => '環境變數',
			'settings.mcpServers.tools.title' => '工具',
			'settings.mcpServers.tools.count' => ({required Object count}) => '（${count}）：',
			'settings.mcpServers.tools.more' => ({required Object count}) => '還有 ${count} 個',
			'settings.mcpServers.actions.edit' => '編輯伺服器',
			'settings.mcpServers.actions.delete' => '刪除伺服器',
			'settings.mcpServers.managed.badge' => '受管理',
			'settings.mcpServers.managed.hint' => '由 DDAgent 管理。',
			'settings.mcpServers.help.title' => '關於 Codex MCP',
			'settings.mcpServers.help.description' => 'Codex 支援基於 stdio 的 MCP 伺服器。您可以新增伺服器，透過額外的工具和資源來擴充 Codex 的功能。',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '「${serverName}」將從提供者設定中移除。',
			'settings.mcpServers.deleteConfirm.title' => '刪除 MCP 伺服器？',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => '警示閾值、路由策略以及輪詢額度的帳戶。',
			'settings.quota.settings.saved' => '已儲存',
			'settings.quota.settings.alertsSection' => '警示',
			'settings.quota.settings.alertsSectionHint' => '在額度真正耗盡之前警告，而不是等到 100%。',
			'settings.quota.settings.alertsEnabled' => '預測額度警示',
			'settings.quota.settings.alertsEnabledHint' => '在總覽和帳戶卡片上顯示基於速度的預測。',
			'settings.quota.settings.watchThreshold' => '觀察閾值（%）',
			'settings.quota.settings.watchThresholdHint' => '讀數達到或超過此值的帳戶計為有風險。',
			'settings.quota.settings.dangerThreshold' => '危險閾值（%）',
			'settings.quota.settings.dangerThresholdHint' => '達到或超過此值的讀數顯示為紅色。',
			'settings.quota.settings.routingSection' => '路由',
			'settings.quota.settings.routingSectionHint' => '面板如何將工作遷移到餘量最多的帳戶。',
			'settings.quota.settings.routing.manual' => '手動',
			'settings.quota.settings.routing.manualHint' => '僅顯示建議；絕不自動切換帳戶。',
			'settings.quota.settings.routing.ask' => '切換前詢問',
			'settings.quota.settings.routing.askHint' => '提出切換建議並等待你的核准。',
			'settings.quota.settings.routing.autoLowRisk' => '低風險任務自動',
			'settings.quota.settings.routing.autoLowRiskHint' => '只有標記為低風險的任務才能自動遷移。',
			'settings.quota.settings.routingNote' => '切換帳戶會改變成本與模型品質，因此始終需要明確決定。',
			'settings.quota.settings.accountsSection' => '輪詢的帳戶',
			'settings.quota.settings.accountsSectionHint' => '憑證從各工具讀取；面板不會將其傳送到其他地方。',
			'settings.quota.settings.sourcesSection' => '資料來源',
			'settings.quota.settings.sourcesSectionHint' => '用量與成本資料的來源。',
			'settings.quota.settings.logSources' => '權杖與成本日誌儲存',
			'settings.quota.settings.logSourcesHint' => '與 tokboard 收集器共享的唯讀彙總儲存。',
			'settings.quota.settings.readOnly' => '唯讀',
			'settings.quota.settings.quotaConsent' => '額度輪詢',
			'settings.quota.settings.quotaConsentHint' => '使用本機儲存的憑證讀取提供者額度端點。',
			'settings.quota.settings.localOnly' => '僅本機',
			'settings.quota.empty.description' => '尚未偵測到任何帳戶。',
			'settings.quota.quality.cached' => '快取',
			'settings.quota.quality.error' => '錯誤',
			'settings.quota.quality.estimate' => '估計',
			'settings.quota.quality.live' => '即時',
			'settings.quota.quality.unknown' => '未知',
			'settings.quota.syncFailed' => '同步失敗',
			'settings.quota.syncNow' => '立即同步',
			'settings.browser.checking' => '正在檢查...',
			'settings.browser.description' => '允許代理啟動受管理的 Playwright 瀏覽器工作階段，你可以在 Browser 分頁中監控。',
			'settings.browser.enableDescription' => '為支援的代理註冊 Browser。代理可以建立瀏覽器工作階段，你可以監控、停止和刪除它們。',
			'settings.browser.enableLabel' => '啟用 Browser',
			'settings.browser.errors.installRuntime' => '安裝瀏覽器執行環境失敗',
			'settings.browser.errors.loadSettings' => '載入 Browser 設定失敗',
			'settings.browser.errors.loadStatus' => '載入 Browser 狀態失敗',
			'settings.browser.errors.saveSettings' => '儲存 Browser 設定失敗',
			'settings.browser.installHint' => '在代理建立 Browser 工作階段之前，請安裝瀏覽器執行環境。',
			'settings.browser.installRuntime' => '安裝執行環境',
			'settings.browser.installed' => '已安裝',
			'settings.browser.installing' => '正在安裝...',
			'settings.browser.missing' => '缺失',
			'settings.browser.runtimeRequired' => '需要瀏覽器執行環境',
			'settings.browser.statusDisabled' => '已停用',
			'settings.browser.statusLabel' => '狀態',
			'settings.browser.statusReady' => '就緒',
			'settings.browser.statusSetupRequired' => '需要設定',
			'settings.browser.title' => '瀏覽器',
			'settings.workspaces.cancel' => '取消',
			'settings.workspaces.create' => '新增工作區',
			'settings.workspaces.deleteConfirm' => '從 DDAgent 移除此工作區？檔案將保留在磁碟上。',
			'settings.workspaces.deleteFailed' => '移除工作區失敗。',
			'settings.workspaces.deleteTitle' => '移除工作區',
			'settings.workspaces.description' => '工作區是 DDAgent 可以聊天、執行程式碼和瀏覽的目錄。',
			'settings.workspaces.remove' => '移除工作區',
			'settings.workspaces.title' => '工作區',
			'settings.workspaces.pathRequired' => '路徑為必填項。',
			'settings.stt.title' => '語音輸入（語音轉文字）',
			_ => null,
		} ?? switch (path) {
			'settings.stt.description' => '相容 Whisper 的 /audio/transcriptions 端點（OpenAI、whisper.cpp、faster-whisper、Speaches）。啟用後，輸入區會出現麥克風按鈕。',
			'settings.stt.configured' => '已設定',
			'settings.stt.endpoint' => '端點 URL（例如 https://api.openai.com/v1）',
			'settings.stt.apiKey' => 'API 金鑰',
			'settings.stt.model' => '模型（預設：whisper-1）',
			'settings.stt.save' => '儲存',
			'settings.schedules.title' => '排程',
			'settings.schedules.description' => '依 cron 時間表定期執行代理。執行時無人看管，且會略過權限確認。',
			'settings.schedules.preventSleep' => '代理執行時防止休眠',
			'settings.schedules.preventSleepHint' => '桌面版會讓螢幕保持喚醒；瀏覽器中則使用螢幕喚醒鎖定。',
			'settings.schedules.kNew' => '新增排程',
			'settings.schedules.loading' => '正在載入…',
			'settings.schedules.empty' => '尚無排程。',
			'settings.schedules.project' => '專案',
			'settings.schedules.provider' => '提供者',
			'settings.schedules.cron' => 'Cron（分 時 日 月 星期）',
			'settings.schedules.nextRun' => ({required Object time}) => '下次執行：${time}',
			'settings.schedules.cronInvalid' => '此運算式沒有即將到來的執行時間',
			'settings.schedules.prompt' => '提示詞',
			'settings.schedules.useWorktree' => '在全新的 worktree 中執行',
			'settings.schedules.catchUp' => '補執行錯過的排程',
			'settings.schedules.failures' => ({required Object count}) => '${count} 次失敗',
			'settings.schedules.disabled' => '已停用',
			'settings.schedules.history' => '歷史紀錄',
			'settings.schedules.runNow' => '立即執行',
			'settings.schedules.delete' => '刪除',
			'settings.schedules.noRuns' => '尚無執行紀錄。',
			'settings.schedules.next' => '下次',
			'settings.schedules.create' => '建立',
			'settings.schedules.toggleSchedule' => '啟用排程',
			'settings.mcpTokens.title' => 'DDAgent MCP 伺服器權杖',
			'settings.mcpTokens.description' => '外部工具（Claude Desktop、OpenClaw）會透過 POST /mcp，並使用以下其中一個 Bearer 權杖來呼叫 DDAgent 工具。',
			'settings.mcpTokens.dismiss' => '關閉',
			'settings.mcpTokens.labelPlaceholder' => '權杖標籤（例如 Claude Desktop）',
			'settings.mcpTokens.create' => '建立',
			'settings.mcpTokens.empty' => '尚無 MCP 權杖。',
			'settings.mcpTokens.lastUsed' => ({required Object time}) => '上次使用：${time}',
			'settings.mcpTokens.neverUsed' => '從未使用',
			'settings.about.supportTitle' => '支持此專案',
			'settings.about.buyMeACoffee' => '請我喝杯咖啡',
			'settings.about.tryHosted' => '試用 DDAgent Hosted',
			'settings.about.learnMore' => '深入了解',
			'settings.about.proFeatures' => 'DDAgent Pro 功能',
			'settings.about.pro.syncSettings' => '同步設定',
			'settings.about.pro.teamManagement' => '團隊管理',
			'settings.about.pro.syncSettingsDescription' => '在所有環境中同步你的偏好設定、MCP 設定與主題。',
			'settings.about.pro.teamManagementDescription' => '多使用者、角色型存取控制以及團隊共用專案。',
			'settings.about.versionInfo' => '版本資訊',
			'settings.about.client' => '應用程式',
			'settings.about.server' => '伺服器',
			'settings.about.platformMobile' => '行動裝置',
			'settings.about.platformDesktop' => '桌面版',
			'settings.about.platformWeb' => '網頁',
			'settings.about.unknown' => '未知',
			'settings.about.copyright' => '© 2026 DDAgent — 保留所有權利',
			'settings.about.tagline' => '開源 AI 程式設計助理介面',
			'settings.about.docs' => '文件',
			'settings.about.hostedDescription' => '團隊協作、共用 MCP 設定、跨環境設定同步以及託管基礎架構。',
			'settings.shortcuts.description' => 'DDAgent 中的所有鍵盤快捷鍵，依平台分類。',
			'settings.shortcuts.action' => '動作',
			'settings.shortcuts.winLinux' => 'Windows / Linux',
			'settings.shortcuts.mac' => 'macOS',
			'settings.shortcuts.navigation' => '導覽',
			'settings.shortcuts.navWorkspace' => '前往工作區',
			'settings.shortcuts.navTasks' => '前往任務／Git',
			'settings.shortcuts.navGit' => '前往 Git',
			'settings.shortcuts.navFocus' => '切換專注模式（側邊欄）',
			'settings.shortcuts.navSwitcher' => '快速切換工作階段',
			'settings.shortcuts.navPalette' => '命令面板',
			'settings.shortcuts.navSettings' => '開啟設定',
			'settings.shortcuts.navClose' => '關閉對話框／還原分割窗格',
			'settings.shortcuts.composer' => '訊息輸入區',
			'settings.shortcuts.compSend' => '傳送訊息',
			'settings.shortcuts.compNewline' => '換行',
			'settings.shortcuts.compNav' => '瀏覽建議',
			'settings.shortcuts.compAccept' => '接受建議',
			'settings.shortcuts.compCloseSuggest' => '關閉建議',
			'settings.shortcuts.transcript' => '對話內容',
			'settings.shortcuts.trCopy' => '複製所選文字',
			'settings.shortcuts.trClose' => '關閉搜尋／審查面板',
			'settings.shortcuts.terminal' => '終端機',
			'settings.shortcuts.termCopy' => '複製選取內容',
			'settings.shortcuts.termInterrupt' => '中斷程序（未選取時）',
			'settings.shortcuts.termPaste' => '貼上',
			'settings.shortcuts.termSelectAll' => '全選',
			'settings.shortcuts.editor' => '編輯器',
			'settings.shortcuts.edSave' => '儲存檔案',
			'settings.shortcuts.edSaveAll' => '儲存所有檔案',
			'settings.shortcuts.edClose' => '關閉分頁',
			'settings.shortcuts.edNextTab' => '下一個分頁',
			'settings.shortcuts.edPrevTab' => '上一個分頁',
			'settings.shortcuts.edIndent' => '增加／減少縮排',
			'settings.shortcuts.palette' => '命令面板',
			'settings.shortcuts.palNav' => '瀏覽項目',
			'settings.shortcuts.palRun' => '執行／開啟',
			'settings.shortcuts.palBack' => '返回（搜尋為空時）',
			'settings.shortcuts.palClose' => '關閉',
			'sidebar.projects.title' => '專案',
			'sidebar.projects.newProject' => '新增專案',
			'sidebar.projects.deleteProject' => '移除專案',
			'sidebar.projects.renameProject' => '重新命名專案',
			'sidebar.projects.noProjects' => '找不到專案',
			'sidebar.projects.loadingProjects' => '載入專案中...',
			'sidebar.projects.searchPlaceholder' => '搜尋專案...',
			'sidebar.projects.projectNamePlaceholder' => '專案名稱',
			'sidebar.projects.starred' => '星號標記',
			'sidebar.projects.all' => '全部',
			'sidebar.projects.untitledSession' => '未命名工作階段',
			'sidebar.projects.newSession' => '新工作階段',
			'sidebar.projects.codexSession' => 'Codex 工作階段',
			'sidebar.projects.fetchingProjects' => '正在取得您的 Claude 專案和工作階段',
			'sidebar.projects.projects' => '專案',
			'sidebar.projects.noMatchingProjects' => '找不到符合的專案',
			'sidebar.projects.tryDifferentSearch' => '嘗試調整您的搜尋詞',
			'sidebar.projects.runClaudeCli' => '在專案目錄中執行 Claude CLI 以開始使用',
			'sidebar.app.title' => 'DDAgent',
			'sidebar.app.subtitle' => 'AI 程式開發助手',
			'sidebar.panel.open' => '面板',
			'sidebar.panel.newChat' => '新聊天',
			'sidebar.panel.navigation' => '導覽',
			'sidebar.panel.sessions' => '工作階段',
			'sidebar.sessions.title' => '工作階段',
			'sidebar.sessions.newSession' => '新增工作階段',
			'sidebar.sessions.deleteSession' => '刪除工作階段',
			'sidebar.sessions.renameSession' => '重新命名工作階段',
			'sidebar.sessions.noSessions' => '暫無工作階段',
			'sidebar.sessions.loadingSessions' => '載入工作階段中...',
			'sidebar.sessions.unnamed' => '未命名',
			'sidebar.sessions.loading' => '載入中...',
			'sidebar.sessions.showMore' => '顯示更多工作階段',
			'sidebar.sessions.selectMode' => '選取',
			'sidebar.sessions.selectAll' => '全選',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => '封存（${count}）',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => '刪除（${count}）',
			'sidebar.sessions.cancelSelection' => '取消選取',
			'sidebar.sessions.toggleSelection' => '切換工作階段選取',
			'sidebar.sessions.selectionToolbar' => '工作階段選取操作',
			'sidebar.sessions.options' => '工作階段選項',
			'sidebar.sessions.pinSession' => '釘選工作階段',
			'sidebar.sessions.unpinSession' => '取消釘選工作階段',
			'sidebar.sessions.pinned' => '已釘選的工作階段',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '已選 ${count} 個', other: '已選 ${count} 個', ), 
			'sidebar.tooltips.viewEnvironments' => '查看環境',
			'sidebar.tooltips.hideSidebar' => '隱藏側邊欄',
			'sidebar.tooltips.createProject' => '建立新專案',
			'sidebar.tooltips.refresh' => '重新整理專案和工作階段 (Ctrl+R)',
			'sidebar.tooltips.renameProject' => '重新命名專案 (F2)',
			'sidebar.tooltips.deleteProject' => '從側邊欄移除專案 (Delete)',
			'sidebar.tooltips.addToFavorites' => '加入收藏',
			'sidebar.tooltips.removeFromFavorites' => '從收藏移除',
			'sidebar.tooltips.editSessionName' => '手動編輯工作階段名稱',
			'sidebar.tooltips.deleteSession' => '永久刪除此工作階段',
			'sidebar.tooltips.activeSessionIndicator' => '最近活躍的工作階段（最近 10 分鐘）',
			'sidebar.tooltips.save' => '儲存',
			'sidebar.tooltips.cancel' => '取消',
			'sidebar.tooltips.clearSearch' => '清除搜尋',
			'sidebar.tooltips.openCommandPalette' => '開啟指令面板',
			'sidebar.tooltips.attentionRequiredIndicator' => '工作階段需要處理',
			'sidebar.tooltips.openSessions' => '瀏覽工作階段',
			'sidebar.navigation.chat' => '聊天',
			'sidebar.navigation.files' => '檔案',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => '終端機',
			'sidebar.navigation.tasks' => '任務',
			'sidebar.actions.refresh' => '重新整理',
			'sidebar.actions.settings' => '設定',
			'sidebar.actions.collapseAll' => '全部收合',
			'sidebar.actions.expandAll' => '全部展開',
			'sidebar.actions.cancel' => '取消',
			'sidebar.actions.save' => '儲存',
			'sidebar.actions.delete' => '刪除',
			'sidebar.actions.rename' => '重新命名',
			'sidebar.actions.joinCommunity' => '加入社群',
			'sidebar.actions.reportIssue' => '回報問題',
			'sidebar.actions.starOnGithub' => '在 GitHub 上加星',
			'sidebar.actions.buyMeACoffee' => '請我喝杯咖啡',
			'sidebar.workspace.title' => '變更工作階段工作區',
			'sidebar.workspace.description' => '代理將在此目錄中執行後續回合。現有工作階段歷史將被保留。',
			'sidebar.workspace.pathLabel' => '工作區路徑',
			'sidebar.workspace.pathRequired' => '工作區路徑為必填項。',
			'sidebar.workspace.submit' => '變更工作區',
			'sidebar.workspace.saving' => '正在變更…',
			'sidebar.workspace.changeAction' => '變更工作區',
			'sidebar.branding.openSource' => '開源',
			'sidebar.status.active' => '使用中',
			'sidebar.status.inactive' => '非使用中',
			'sidebar.status.thinking' => '思考中...',
			'sidebar.status.error' => '錯誤',
			'sidebar.status.aborted' => '已中止',
			'sidebar.status.unknown' => '未知',
			'sidebar.time.justNow' => '剛剛',
			'sidebar.time.oneMinuteAgo' => '1 分鐘前',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} 分鐘前',
			'sidebar.time.oneHourAgo' => '1 小時前',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} 小時前',
			'sidebar.time.oneDayAgo' => '1 天前',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} 天前',
			'sidebar.messages.deleteConfirm' => '確定要刪除嗎？',
			'sidebar.messages.renameSuccess' => '重新命名成功',
			'sidebar.messages.deleteSuccess' => '刪除成功',
			'sidebar.messages.errorOccurred' => '發生錯誤',
			'sidebar.messages.deleteSessionConfirm' => '確定要刪除此工作階段嗎？此操作無法復原。',
			'sidebar.messages.deleteProjectConfirm' => '從側邊欄移除此專案？您的專案檔案、記憶和工作階段資料不會被刪除。',
			'sidebar.messages.enterProjectPath' => '請輸入專案路徑',
			'sidebar.messages.deleteSessionFailed' => '刪除工作階段失敗，請重試。',
			'sidebar.messages.deleteSessionError' => '刪除工作階段時出錯，請重試。',
			'sidebar.messages.renameSessionFailed' => '重新命名工作階段失敗，請重試。',
			'sidebar.messages.renameSessionError' => '重新命名工作階段時出錯，請重試。',
			'sidebar.messages.changeWorkspaceFailed' => '更改工作區失敗。請重試。',
			'sidebar.messages.changeWorkspaceError' => '更改工作區時發生錯誤。請重試。',
			'sidebar.messages.deleteProjectFailed' => '移除專案失敗，請重試。',
			'sidebar.messages.deleteProjectError' => '移除專案時出錯，請重試。',
			'sidebar.messages.createProjectFailed' => '建立專案失敗，請重試。',
			'sidebar.messages.createProjectError' => '建立專案時出錯，請重試。',
			'sidebar.messages.updateProjectError' => '更新專案時出錯，請重試。',
			'sidebar.messages.refreshError' => '重新整理失敗，請重試。',
			'sidebar.messages.restoreProjectFailed' => '還原專案失敗，請重試。',
			'sidebar.messages.restoreProjectError' => '還原專案時出錯，請重試。',
			'sidebar.messages.restoreSessionFailed' => '還原工作階段失敗，請重試。',
			'sidebar.messages.restoreSessionError' => '還原工作階段時出錯，請重試。',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '刪除 ${count} 個工作階段失敗。請重試。', other: '刪除 ${count} 個工作階段失敗。請重試。', ), 
			'sidebar.version.updateAvailable' => '有可用更新',
			'sidebar.version.restartRequired' => '已安裝更新 — 請重新啟動伺服器以套用',
			'sidebar.version.updateNow' => '立即更新',
			'sidebar.version.updateConfirm' => ({required Object version}) => '將 DDAgent 更新到 v${version}？將擷取最新程式碼並重新建置，隨後伺服器會重新啟動 — 進行中的工作階段會被中斷。',
			'sidebar.version.updating' => '正在更新… 可能需要幾分鐘',
			'sidebar.version.restarting' => '更新已安裝 — 正在重新啟動…',
			'sidebar.version.updateFailed' => '更新失敗',
			'sidebar.version.releaseNotes' => '版本資訊',
			'sidebar.search.modeProjects' => '專案',
			'sidebar.search.modeConversations' => '對話',
			'sidebar.search.conversationsPlaceholder' => '搜尋對話內容...',
			'sidebar.search.searching' => '搜尋中...',
			'sidebar.search.sessionTitles' => '工作階段標題',
			'sidebar.search.conversationContents' => '對話內容',
			'sidebar.search.noResults' => '找不到結果',
			'sidebar.search.tryDifferentQuery' => '嘗試不同的搜尋詞',
			'sidebar.search.modeRunning' => '執行中',
			'sidebar.search.archiveOnly' => '封存',
			'sidebar.search.runningTooltip' => '執行中的工作階段',
			'sidebar.search.archiveOnlyTooltip' => '僅封存',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} 個活躍',
			'sidebar.search.viewMenu' => '檢視',
			'sidebar.search.backToProjects' => '返回專案',
			'sidebar.search.archivedPlaceholder' => '搜尋已封存工作階段...',
			'sidebar.search.runningPlaceholder' => '搜尋執行中的工作階段...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個符合', other: '${count} 個符合', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個專案已掃描', other: '${count} 個專案已掃描', ), 
			'sidebar.recent.title' => '最近對話',
			'sidebar.recent.emptyTitle' => '尚無對話',
			'sidebar.recent.emptyDescription' => '你最近更新的對話將顯示在這裡。',
			'sidebar.recent.loadFailed' => '無法載入最近對話',
			'sidebar.recent.loadMore' => '載入更早的對話',
			'sidebar.recent.loadingMore' => '載入中...',
			'sidebar.deleteConfirmation.deleteProject' => '移除專案',
			'sidebar.deleteConfirmation.deleteSession' => '刪除工作階段',
			'sidebar.deleteConfirmation.confirmDelete' => '您想如何處理',
			'sidebar.deleteConfirmation.removeFromSidebar' => '僅從側邊欄移除',
			'sidebar.deleteConfirmation.deleteAllData' => '永久刪除所有資料',
			'sidebar.deleteConfirmation.allConversationsDeleted' => '專案將從側邊欄中移除。您的檔案、記憶和工作階段資料將會保留。',
			'sidebar.deleteConfirmation.cannotUndo' => '您可以稍後重新新增此專案。',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => '封存會將所選工作階段從使用中清單隱藏，同時保留其歷史記錄。',
			'sidebar.deleteConfirmation.archiveSession' => '封存工作階段',
			'sidebar.deleteConfirmation.archiveSessionNotice' => '封存會將工作階段移出使用中的清單，同時保留其歷史記錄。',
			'sidebar.deleteConfirmation.archivedSessionNotice' => '此工作階段已封存。你可以保持隱藏或永久刪除。',
			'sidebar.deleteConfirmation.deleteSessionNotice' => '這將永久刪除工作階段及其記錄。此操作無法復原。',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => '永久刪除',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '此專案包含 ${count} 個對話。', other: '此專案包含 ${count} 個對話。', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '管理所選工作階段', other: '管理 ${count} 個所選工作階段', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '封存工作階段', other: '封存 ${count} 個工作階段', ), 
			'sidebar.zones.activeNow' => '目前活躍',
			'sidebar.zones.recent' => '最近使用',
			'sidebar.zones.today' => '今天',
			'sidebar.zones.yesterday' => '昨天',
			'sidebar.zones.thisWeek' => '本週',
			'sidebar.zones.showMore' => ({required Object count}) => '再顯示 ${count} 個',
			'sidebar.zones.showLess' => '收合',
			'sidebar.tabs.board' => '代理面板',
			'sidebar.tabs.files' => '檔案',
			'sidebar.tabs.git' => '原始碼管理',
			'sidebar.tabs.tasks' => '任務',
			'sidebar.tabs.usage' => '配額與用量',
			'tasks.notConfigured.title' => 'TaskMaster AI 尚未設定',
			'tasks.notConfigured.description' => 'TaskMaster 協助將複雜的專案分解為可管理的任務，搭配 AI 驅動的輔助功能',
			'tasks.notConfigured.whatIsTitle' => '🎯 什麼是 TaskMaster？',
			'tasks.notConfigured.features.aiPowered' => 'AI 驅動的任務管理：將複雜專案分解為可管理的子任務',
			'tasks.notConfigured.features.prdTemplates' => 'PRD 範本：從產品需求文件產生任務',
			'tasks.notConfigured.features.dependencyTracking' => '相依性追蹤：了解任務關係和執行順序',
			'tasks.notConfigured.features.progressVisualization' => '進度視覺化：看板和詳細的任務分析',
			'tasks.notConfigured.features.cliIntegration' => 'CLI 整合：使用 taskmaster 指令進行進階工作流程',
			'tasks.notConfigured.initializeButton' => '初始化 TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => '請先撰寫 PRD',
			'tasks.gettingStarted.title' => '開始使用 TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster 已初始化！以下是接下來要做的事：',
			'tasks.gettingStarted.steps.createPRD.title' => '建立產品需求文件（PRD）',
			'tasks.gettingStarted.steps.createPRD.description' => '討論您的專案構想並建立描述您想建立什麼的 PRD。',
			'tasks.gettingStarted.steps.createPRD.addButton' => '新增 PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => '現有的 PRD：',
			'tasks.gettingStarted.steps.generateTasks.title' => '從 PRD 產生任務',
			'tasks.gettingStarted.steps.generateTasks.description' => '一旦您有了 PRD，請 AI 助手解析它，TaskMaster 將自動將其分解為可管理的任務，包含實作細節。',
			'tasks.gettingStarted.steps.analyzeTasks.title' => '分析並展開任務',
			'tasks.gettingStarted.steps.analyzeTasks.description' => '請 AI 助手分析任務複雜度，並將其展開為詳細的子任務以便於實作。',
			'tasks.gettingStarted.steps.startBuilding.title' => '開始建構',
			'tasks.gettingStarted.steps.startBuilding.description' => '請 AI 助手開始處理任務、更新狀態，並在專案演進時新增任務。',
			'tasks.gettingStarted.tip' => '💡 提示：從 PRD 開始可以充分利用 TaskMaster 的 AI 驅動任務產生功能',
			'tasks.setupModal.title' => 'TaskMaster 設定',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => '${projectName} 的互動式 CLI',
			'tasks.setupModal.willStart' => 'TaskMaster 初始化將自動開始',
			'tasks.setupModal.completed' => 'TaskMaster 設定完成！您現在可以關閉此視窗。',
			'tasks.setupModal.closeButton' => '關閉',
			'tasks.setupModal.closeContinueButton' => '關閉並繼續',
			'tasks.setupModal.closeTitle' => '關閉',
			'tasks.setupModal.description' => '這將在此專案中建立一個 .taskmaster 資料夾。無需外部工具或 API 金鑰——任務保存在本機。',
			'tasks.setupModal.initializeButton' => '初始化',
			'tasks.setupModal.initializing' => '正在初始化...',
			'tasks.helpGuide.title' => '開始使用 TaskMaster',
			'tasks.helpGuide.subtitle' => '您的高效任務管理指南',
			'tasks.helpGuide.examples.parsePRD' => '💬 範例：\n「我剛用 Claude Task Master 初始化了一個新專案。我有一個 PRD 在 .taskmaster/docs/prd.txt。你能幫我解析它並設定初始任務嗎？」',
			'tasks.helpGuide.examples.expandTask' => '💬 範例：\n「任務 5 看起來很複雜。你能把它分解成子任務嗎？」',
			'tasks.helpGuide.examples.addTask' => '💬 範例：\n「請新增一個任務來實作使用 Cloudinary 的使用者個人頭像上傳功能，研究最佳方法。」',
			'tasks.helpGuide.moreExamples' => '查看更多範例和使用模式 →',
			'tasks.helpGuide.proTips.title' => '💡 專業提示',
			'tasks.helpGuide.proTips.search' => '使用搜尋列快速找到特定任務',
			'tasks.helpGuide.proTips.views' => '使用檢視切換在看板、清單和網格檢視之間切換',
			'tasks.helpGuide.proTips.filters' => '使用篩選器聚焦特定任務狀態或優先順序',
			'tasks.helpGuide.proTips.details' => '點擊任何任務以查看詳細資訊和管理子任務',
			'tasks.helpGuide.learnMore.title' => '📚 了解更多',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI 是為開發者打造的進階任務管理系統。取得文件、範例並為專案做出貢獻。',
			'tasks.helpGuide.learnMore.githubButton' => '在 GitHub 上查看',
			'tasks.helpGuide.closeTitle' => '關閉',
			'tasks.search.placeholder' => '搜尋任務...',
			'tasks.filters.button' => '篩選',
			'tasks.filters.status' => '狀態',
			'tasks.filters.priority' => '優先順序',
			'tasks.filters.sortBy' => '排序依據',
			'tasks.filters.allStatuses' => '所有狀態',
			'tasks.filters.allPriorities' => '所有優先順序',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => '顯示 ${filtered} / ${total} 個任務',
			'tasks.filters.clearFilters' => '清除篩選',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => '狀態',
			'tasks.sort.priority' => '優先順序',
			'tasks.sort.idAsc' => 'ID（遞增）',
			'tasks.sort.idDesc' => 'ID（遞減）',
			'tasks.sort.titleAsc' => '標題（A-Z）',
			'tasks.sort.titleDesc' => '標題（Z-A）',
			'tasks.sort.statusAsc' => '狀態（待處理優先）',
			'tasks.sort.statusDesc' => '狀態（已完成優先）',
			'tasks.sort.priorityAsc' => '優先順序（高優先）',
			'tasks.sort.priorityDesc' => '優先順序（低優先）',
			'tasks.views.kanban' => '看板檢視',
			'tasks.views.list' => '清單檢視',
			'tasks.views.grid' => '網格檢視',
			'tasks.kanban.pending' => '📋 待辦',
			'tasks.kanban.inProgress' => '🚀 進行中',
			'tasks.kanban.review' => '👀 審查',
			'tasks.kanban.done' => '✅ 已完成',
			'tasks.kanban.blocked' => '🚫 已封鎖',
			'tasks.kanban.deferred' => '⏳ 已延後',
			'tasks.kanban.cancelled' => '❌ 已取消',
			'tasks.kanban.noTasksYet' => '尚無任務',
			'tasks.kanban.tasksWillAppear' => '任務將顯示在這裡',
			'tasks.kanban.moveTasksHere' => '開始後將任務移到這裡',
			'tasks.kanban.completedTasksHere' => '已完成的任務顯示在這裡',
			'tasks.kanban.statusTasksHere' => '此狀態的任務將顯示在這裡',
			'tasks.buttons.help' => 'TaskMaster 入門指南',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => '新增 PRD',
			'tasks.buttons.addTask' => '新增任務',
			'tasks.buttons.createNewPRD' => '建立新 PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} 個 PRD 可用',
			'tasks.prd.modified' => ({required Object date}) => '修改時間：${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.newFile' => '新檔案',
			'tasks.prd.template' => '範本',
			'tasks.prd.parse' => '解析 PRD',
			'tasks.prd.fileExistsTitle' => '檔案已存在',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => '已存在名為「${name}」的 PRD。要覆寫嗎？',
			'tasks.prd.fileNameHint' => '檔案名稱（例如 prd.txt）',
			'tasks.prd.saved' => 'PRD 已儲存',
			'tasks.prd.tasksGenerated' => '已從 PRD 產生任務',
			'tasks.statuses.pending' => '待處理',
			'tasks.statuses.inProgress' => '進行中',
			'tasks.statuses.done' => '已完成',
			'tasks.statuses.blocked' => '已封鎖',
			'tasks.statuses.deferred' => '已延後',
			'tasks.statuses.cancelled' => '已取消',
			'tasks.statuses.review' => '審查',
			'tasks.priorities.high' => '高',
			'tasks.priorities.medium' => '中',
			'tasks.priorities.low' => '低',
			'tasks.noMatchingTasks.title' => '沒有符合篩選條件的任務',
			'tasks.noMatchingTasks.description' => '嘗試調整您的搜尋或篩選條件。',
			'tasks.board.title' => '代理看板',
			'tasks.board.subtitle' => '把卡片移到「準備開始」，代理就會接手。點擊卡片開啟其工作階段。',
			'tasks.board.newCard' => '新卡片',
			'tasks.board.addCard' => '新增卡片',
			'tasks.board.refresh' => '重新整理',
			'tasks.board.empty.title' => '還沒有卡片',
			'tasks.board.empty.description' => '新增卡片、描述任務，然後拖到「準備開始」讓代理開始工作。',
			'tasks.board.columns.backlog' => '待辦清單',
			'tasks.board.columns.ready' => '準備開始',
			'tasks.board.columns.working' => '進行中',
			'tasks.board.columns.needsDecision' => '需要你的決定',
			'tasks.board.columns.done' => '已完成',
			'tasks.board.columns.archived' => '已封存',
			'tasks.board.card.running' => '執行中',
			'tasks.board.card.abort' => '中止',
			'tasks.board.card.delete' => '刪除',
			'tasks.board.card.openSession' => '開啟工作階段',
			'tasks.board.card.pullRequest' => '拉取請求',
			'tasks.board.card.edit' => '編輯',
			'tasks.board.card.moveTo' => '移至',
			'tasks.board.dialog.createTitle' => '新卡片',
			'tasks.board.dialog.editTitle' => '編輯卡片',
			'tasks.board.dialog.titleLabel' => '標題',
			'tasks.board.dialog.titlePlaceholder' => '代理應該做什麼？',
			'tasks.board.dialog.descriptionLabel' => '描述',
			'tasks.board.dialog.descriptionPlaceholder' => '新增背景、驗收標準、連結...',
			'tasks.board.dialog.cancel' => '取消',
			'tasks.board.dialog.save' => '儲存',
			'tasks.board.noProject' => '先新增一個專案，然後為它建立卡片。',
			'tasks.board.projectLabel' => '專案',
			'tasks.board.backToChat' => '返回聊天',
			'tasks.board.agent.provider' => '代理',
			'tasks.board.agent.anyProvider' => '任何代理',
			'tasks.board.agent.model' => '模型',
			'tasks.board.agent.defaultModel' => '預設模型',
			'tasks.board.agent.effort' => '推理',
			'tasks.board.agent.defaultEffort' => '預設',
			'tasks.board.agent.searchModel' => '搜尋模型…',
			'tasks.board.agent.noModels' => '沒有符合的模型',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '「${cardTitle}」將被永久刪除。',
			'tasks.board.deleteConfirm.title' => '刪除卡片？',
			'tasks.board.project' => '專案',
			'tasks.board.assignee.label' => '負責人',
			'tasks.board.assignee.all' => '所有負責人',
			'tasks.board.assignee.unassigned' => '未指派',
			'tasks.board.presence.online' => ({required Object count}) => '${count} 人在線上',
			'tasks.board.activity.title' => '活動',
			'tasks.board.activity.empty' => '尚無活動',
			'tasks.board.comments.label' => '留言',
			'tasks.board.comments.placeholder' => '撰寫留言…',
			'tasks.board.comments.send' => '傳送',
			'tasks.board.comments.unknownAuthor' => '某人',
			'tasks.card.dependsOnList' => ({required Object tasks}) => '依賴於：${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => '任務 ${id}',
			'tasks.card.highPriority' => '高優先級',
			'tasks.card.lowPriority' => '低優先級',
			'tasks.card.mediumPriority' => '中優先級',
			'tasks.card.noPriority' => '未設定優先級',
			'tasks.card.parentTask' => ({required Object id}) => '任務 ${id}',
			'tasks.card.progressLabel' => '進度：',
			'tasks.card.progressTooltip' => ({required Object total, required Object completed}) => '${total} 個子任務中已完成 ${completed} 個',
			'tasks.card.runTask' => '執行任務',
			'tasks.card.runTaskAria' => ({required Object id}) => '執行任務 ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => '狀態：${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => '任務 ID：${id}',
			'tasks.card.taskInProgress' => '任務進行中',
			'tasks.createTask.cancel' => '取消',
			'tasks.createTask.descriptionLabel' => '描述',
			'tasks.createTask.descriptionPlaceholder' => '可選詳情',
			'tasks.createTask.error' => '新增任務失敗',
			'tasks.createTask.priorityLabel' => '優先級',
			'tasks.createTask.submit' => '新增任務',
			'tasks.createTask.submitting' => '正在新增...',
			'tasks.createTask.title' => '新增任務',
			'tasks.createTask.titleLabel' => '標題',
			'tasks.createTask.titlePlaceholder' => '需要做什麼？',
			'tasks.list.completedReopen' => '已完成（點擊重新開啟）',
			'tasks.list.inProgressComplete' => '進行中（點擊完成）',
			'tasks.list.markCompleted' => '標記為已完成',
			'tasks.list.toggleStatusAria' => ({required Object id}) => '切換任務 ${id} 的狀態',
			'tasks.list.markDone' => '標記為完成',
			'tasks.list.reopen' => '重新開啟',
			'tasks.nextTask.allComplete' => '所有任務已完成',
			'tasks.nextTask.feature1' => '- AI 任務管理，支援依賴和子任務。',
			'tasks.nextTask.feature2' => '- PRD 驅動的任務產生，快速啟動專案。',
			'tasks.nextTask.feature3' => '- 看板和清單檢視，適合日常工作。',
			'tasks.nextTask.hideDetails' => '隱藏詳情',
			'tasks.nextTask.initialize' => '初始化',
			'tasks.nextTask.noPending' => '沒有待處理任務',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI 未設定',
			'tasks.nextTask.review' => '審查',
			'tasks.nextTask.startTask' => '開始任務',
			'tasks.nextTask.taskId' => ({required Object id}) => '任務 ${id}',
			'tasks.nextTask.viewAll' => '檢視所有任務',
			'tasks.nextTask.viewDetails' => '檢視任務詳情',
			'tasks.nextTask.whatIs' => '什麼是 TaskMaster？',
			'tasks.taskDetail.cancelEdit' => '取消編輯',
			'tasks.taskDetail.close' => '關閉',
			'tasks.taskDetail.copyTaskId' => '複製任務 ID',
			'tasks.taskDetail.delete' => '刪除任務',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '「${title}」將被永久刪除。',
			'tasks.taskDetail.deleteConfirmTitle' => '刪除任務？',
			'tasks.taskDetail.deleteFailed' => '刪除任務失敗',
			'tasks.taskDetail.dependencies' => '依賴項',
			'tasks.taskDetail.dependenciesPlaceholder' => '例如：1, 2, 3',
			'tasks.taskDetail.description' => '描述',
			'tasks.taskDetail.edit' => '編輯任務',
			'tasks.taskDetail.implDetails' => '實作細節',
			'tasks.taskDetail.noDependencies' => '無依賴項',
			'tasks.taskDetail.noDescription' => '無描述',
			'tasks.taskDetail.priority' => '優先級',
			'tasks.taskDetail.priorityNotSet' => '未設定',
			'tasks.taskDetail.save' => '儲存',
			'tasks.taskDetail.status' => '狀態',
			'tasks.taskDetail.statusFailed' => '更新任務狀態失敗',
			'tasks.taskDetail.taskId' => ({required Object id}) => '任務 ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => '任務 ${id}：${title}',
			'tasks.taskDetail.testStrategy' => '測試策略',
			'tasks.taskDetail.titleRequired' => '標題為必填項',
			_ => null,
		} ?? switch (path) {
			'tasks.taskDetail.updateFailed' => '更新任務失敗',
			'tasks.taskDetail.notFound' => '找不到任務',
			'tasks.taskDetail.subtasks' => '子任務',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => '任務 #${id} 將被移除。此操作無法復原。',
			'tasks.taskDetail.idCopied' => '已複製任務 ID',
			'tasks.toasts.statusInProgress' => ({required Object id}) => '任務 ${id} 已設為進行中',
			'tasks.taskmaster.noProjectHint' => '請先新增專案，然後為其建立任務。',
			'tasks.taskmaster.sort.statusAz' => '狀態 (A-Z)',
			'tasks.taskmaster.sort.statusZa' => '狀態 (Z-A)',
			'tasks.taskmaster.installedVersion' => ({required Object version}) => '已安裝：${version}',
			'tasks.taskmaster.initFailed' => '初始化 TaskMaster 失敗',
			'tasks.taskmaster.prd.fileNameRequired' => '請為 PRD 提供檔案名稱。',
			'tasks.taskmaster.prd.contentRequired' => '儲存前請先新增內容。',
			'tasks.taskmaster.prd.overwrite' => '覆寫',
			'tasks.taskmaster.prd.contentHint' => '# 產品需求文件…',
			'tasks.taskmaster.detail.dependenciesLabel' => '相依性（以逗號分隔的 ID）',
			'tasks.taskmaster.untitledTask' => '無標題任務',
			'knowledge.title' => '知識',
			'knowledge.tabs.dashboard' => '面板',
			'knowledge.tabs.memories' => '記憶',
			'knowledge.tabs.rules' => '規則',
			'knowledge.tabs.skills' => '技能',
			'knowledge.tabs.personal' => '個人資訊',
			'knowledge.tabs.graph' => '圖譜',
			'knowledge.common.add' => '新增',
			'knowledge.common.save' => '儲存',
			'knowledge.common.cancel' => '取消',
			'knowledge.common.delete' => '刪除',
			'knowledge.common.edit' => '編輯',
			'knowledge.common.close' => '關閉',
			'knowledge.common.restore' => '還原',
			'knowledge.common.refresh' => '重新整理',
			'knowledge.common.allProjects' => '所有專案',
			'knowledge.common.global' => '全域',
			'knowledge.actions.scan' => '掃描專案檔案',
			'knowledge.actions.export' => '匯出 JSON',
			'knowledge.actions.import' => '匯入 JSON',
			'knowledge.actions.scanComplete' => '掃描完成',
			'knowledge.actions.importComplete' => '匯入完成',
			'knowledge.actions.importFailed' => '匯入失敗',
			'knowledge.dialog.newEntity' => '新增項目',
			'knowledge.dialog.editEntity' => '編輯項目',
			'knowledge.dialog.deleteTitle' => '刪除',
			'knowledge.dialog.deleteMessage' => '刪除此項目？此操作無法復原（歷史記錄會保留）。',
			'knowledge.dialog.pickIcon' => '選擇圖示',
			'knowledge.dialog.removeIcon' => '移除圖示',
			'knowledge.dialog.iconTooLarge' => '圖示過大（最大 40 KB）。',
			'knowledge.dialog.importTitle' => '匯入知識',
			'knowledge.dialog.importHint' => '在此貼上匯出的 JSON',
			'knowledge.dialog.exportTitle' => '匯出知識',
			'knowledge.dialog.import' => '匯入',
			'knowledge.fields.key' => '鍵',
			'knowledge.fields.title' => '標題',
			'knowledge.fields.name' => '名稱',
			'knowledge.fields.description' => '說明',
			'knowledge.fields.category' => '分類',
			'knowledge.fields.content' => '內容',
			'knowledge.fields.priority' => '優先順序',
			'knowledge.fields.tags' => '標籤',
			'knowledge.fields.enabled' => '啟用',
			'knowledge.fields.projectScope' => '專案範圍',
			'knowledge.fields.tagsHint' => '以逗號分隔',
			'knowledge.dashboard.memories' => '記憶',
			'knowledge.dashboard.rules' => '規則',
			'knowledge.dashboard.skills' => '技能',
			'knowledge.dashboard.personal' => '個人資訊',
			'knowledge.dashboard.connections' => '連接',
			'knowledge.dashboard.recent' => '最近的記憶',
			'knowledge.dashboard.noMemories' => '尚無記憶。請在「記憶」分頁新增。',
			'knowledge.empty.memories' => '尚無記憶。',
			'knowledge.empty.rules' => '尚無規則。',
			'knowledge.empty.skills' => '尚無技能。',
			'knowledge.empty.personal' => '尚無個人資訊。',
			'knowledge.empty.graph' => '沒有可顯示的實體。',
			'knowledge.history.title' => '歷史',
			'knowledge.history.none' => '尚無歷史。',
			'knowledge.history.untitled' => '（無標題）',
			'knowledge.priorities.critical' => '嚴重',
			'knowledge.priorities.high' => '高',
			'knowledge.priorities.normal' => '普通',
			'knowledge.priorities.low' => '低',
			'knowledge.search.title' => '搜尋知識',
			'knowledge.search.hint' => '搜尋記憶、規則、技能…',
			'knowledge.search.noResults' => '沒有結果。',
			'knowledge.links.title' => '關聯實體',
			'knowledge.links.source' => '來源',
			'knowledge.links.target' => '目標',
			'knowledge.links.relationship' => '關係',
			'knowledge.links.add' => '建立關聯',
			'knowledge.tags.all' => '所有標籤',
			'knowledge.tags.manage' => '管理標籤',
			'knowledge.tags.none' => '尚無標籤。',
			'knowledge.graph.truncated' => '已截斷',
			'knowledge.importAll.title' => '將所有內容匯入 DDAgent',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => '已掃描專案：${count}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => '找到代理技能：${found}（新增：${newSkills}）',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => '規則：${total} · 重複群組：${duplicates}',
			'knowledge.importAll.mergeDuplicates' => '合併重複項目',
			'knowledge.importAll.mergeDuplicatesHint' => '在 DDAgent 中合併重複的資料列（非檔案）',
			'knowledge.importAll.action' => '匯入全部',
			'knowledge.importAll.readOnlyNotice' => '對你的代理僅唯讀：此操作只會匯入到 DDAgent 自己的資料庫，不會修改或刪除任何 CLI 檔案或設定。以下選項只會變更 DDAgent 資料。',
			'knowledge.importAll.dryRunNote' => '試執行——尚未寫入任何內容。',
			'knowledge.importAll.importedNote' => '已匯入。',
			'knowledge.importAll.result' => ({required Object rules, required Object newSkills, required Object removed, required Object promoted}) => '已匯入——規則：${rules}，新技能：${newSkills}，已移除：${removed}，已提升：${promoted}',
			'knowledge.importAll.description' => '掃描所有專案，並將代理的技能匯入知識庫。對代理僅唯讀——不會變更 CLI 中的任何內容。',
			'knowledge.migrate.title' => '移轉現有規則',
			'knowledge.migrate.scanned' => ({required Object count}) => '已掃描 ${count} 個專案。',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => '規則：共 ${total} 條，${critical} 條嚴重。',
			'knowledge.migrate.duplicates' => ({required Object count}) => '跨專案的重複群組：${count}',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => '已移除：${removed}，已提升：${promoted}',
			'knowledge.migrate.mergeDuplicates' => '合併重複項目',
			'knowledge.migrate.dryRunNote' => '試執行——尚未進行任何變更。',
			'knowledge.migrate.applied' => '已套用。',
			'knowledge.importSkills.title' => '匯入代理技能',
			'knowledge.importSkills.found' => ({required Object count}) => '在你的代理中找到 ${count} 個技能。',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => '新增：${imported} · 略過：${skipped}',
			'knowledge.importSkills.dryRunHint' => '將代理內建的全域/預設技能（使用者、系統、外掛）匯入為知識技能。試執行——尚未匯入任何內容。',
			'knowledge.importSkills.importedNote' => '已匯入知識庫。',
			'knowledge.critical.make' => '設為嚴重',
			'knowledge.critical.makeAll' => '將所有規則設為嚴重',
			'knowledge.critical.makeAllHint' => '將它們加入注入的上下文預算',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} 權杖',
			'knowledge.contextBudget.title' => '規則上下文（一律提供）',
			'knowledge.contextBudget.selectProject' => '選擇一個專案以查看其關鍵上下文的大小。',
			'knowledge.linkOptions.memory' => ({required Object title}) => '記憶：${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => '規則：${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => '技能：${name}',
			'knowledge.linkOptions.personal' => ({required Object title}) => '個人資訊：${title}',
			'knowledge.errors.importFailed' => ({required Object error}) => '匯入失敗：${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => '移轉失敗：${error}',
			'knowledge.entityTypes.memory' => '記憶',
			'knowledge.entityTypes.rule' => '規則',
			'knowledge.entityTypes.skill' => '技能',
			'knowledge.entityTypes.personal' => '個人',
			'knowledge.entityTypes.project' => '專案',
			'knowledge.entityTypes.tag' => '標籤',
			'browser.dialogTitle' => '代理瀏覽器',
			'browser.viewError' => '瀏覽器檢視錯誤',
			'browser.web' => '網頁',
			'collab.team' => '團隊',
			'collab.invite' => '邀請',
			'collab.inviteTeammate' => '邀請隊友',
			'collab.shareTokenHint' => '分享此邀請權杖 — 僅顯示一次，並在 72 小時後過期：',
			'collab.createInvite' => '建立邀請',
			'collab.copyToken' => '複製權杖',
			'collab.roles.member' => '成員',
			'collab.roles.viewer' => '檢視者',
			'collab.viewing.session' => '工作階段',
			'collab.viewing.card' => '卡片',
			'collab.viewing.board' => '看板',
			'fileTree.uploadTo' => '上傳至',
			'fileTree.uploadHere' => '上傳到此處',
			'fileTree.browseServerFilesystem' => '瀏覽伺服器檔案系統',
			'fileTree.noFiles' => '沒有檔案',
			'fileTree.copyContents' => '複製內容',
			'fileTree.chooseFolder' => '選擇資料夾',
			'fileTree.search.hint' => '篩選名稱 / 按 Enter 搜尋內容',
			'fileTree.search.prompt' => '輸入查詢並按 Enter',
			'fileTree.search.noMatches' => '沒有符合項目',
			'fileTree.search.resultsTruncated' => '結果已截斷',
			'fileTree.titles.rename' => ({required Object name}) => '重新命名 ${name}',
			'fileTree.titles.delete' => ({required Object name}) => '刪除 ${name}',
			'fileTree.titles.download' => ({required Object name}) => '下載 ${name}',
			'fileTree.uploadedCount' => ({required Object count}) => '已上傳 ${count} 個檔案',
			'fileTree.newName' => '新名稱',
			'fileTree.notRegisteredProject' => ({required Object path}) => '不是已註冊的專案：${path}',
			'fileTree.showGitignoredFiles' => '顯示被 gitignore 忽略的檔案',
			'fileTree.hideGitignoredFiles' => '隱藏被 gitignore 忽略的檔案',
			'fileTree.downloadUnsupportedOnWeb' => '網頁版不支援下載',
			'fileTree.saveToPath' => '儲存至路徑',
			'fileTree.savedTo' => ({required Object path}) => '已儲存至 ${path}',
			'fileTree.relative.now' => '剛剛',
			'fileTree.relative.minutes' => ({required Object n}) => '${n} 分鐘',
			'fileTree.relative.hours' => ({required Object n}) => '${n} 小時',
			'fileTree.relative.days' => ({required Object n}) => '${n} 天',
			'fileTree.projectRoot' => '（專案根目錄）',
			'fileTree.uploadLimitCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, other: '一次最多可上傳 ${count} 個檔案。', ), 
			'fileTree.fileTooLarge' => ({required Object name}) => '${name} 超過 200MB。',
			'fileTree.deleteFolderConfirm' => ({required Object path}) => '刪除資料夾「${path}」？此操作無法復原。',
			'fileTree.deleteFileConfirm' => ({required Object path}) => '刪除檔案「${path}」？此操作無法復原。',
			'git.checkpoints.title' => '檢查點',
			'git.checkpoints.restoreTitle' => '還原檢查點',
			'git.checkpoints.restoreMessage' => '要將工作樹重設到此檢查點嗎？目前的變更將被取代。',
			'git.checkpoints.restored' => '檢查點已還原',
			'git.checkpoints.labelHint' => '檢查點標籤（選填）',
			'git.checkpoints.empty' => '尚無檢查點',
			'git.checkpoints.create' => '新增',
			'git.stagedChanges' => '已暫存的變更',
			'git.statusStaged' => '已暫存',
			'git.switchBranch' => '切換分支',
			'git.unifiedDiff' => '統一差異',
			'git.splitDiff' => '並排差異',
			'git.noDiff' => '沒有可用的差異',
			'git.largeDiff' => '大型差異預覽：為保持分頁順暢，渲染範圍已受限。',
			'git.loadDiffFailed' => ({required Object error}) => '載入差異失敗：${error}',
			'git.hunkStage' => '+ 區塊',
			'git.hunkUnstage' => '− 區塊',
			'git.stageHunk' => '暫存區塊',
			'git.unstageHunk' => '取消暫存區塊',
			'git.deleteFile' => '刪除檔案',
			'git.commitMessage' => '提交訊息',
			'git.aiButton' => '✦ AI',
			'git.commitCreated' => '已建立提交',
			'git.noBranch' => '沒有分支',
			'git.selectProject' => '選擇專案',
			'git.branchSections.local' => '本機',
			'git.branchSections.remote' => '遠端',
			'kanban.card.untitled' => '未命名',
			'kanban.comments.empty' => '尚無留言',
			'kanban.comments.add' => '新增留言',
			'kanban.dialog.saving' => '儲存中…',
			'kanban.details.title' => '卡片詳細資料',
			'kanban.details.status' => ({required Object status}) => '狀態：${status}',
			'kanban.empty.noProject' => '未選擇專案',
			'kanban.saveFailed' => '儲存卡片失敗',
			'kanban.time.now' => '剛剛',
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '1 分鐘前', other: '${count} 分鐘前', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '1 小時前', other: '${count} 小時前', ), 
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '1 天前', other: '${count} 天前', ), 
			'mcp.install.title' => '安裝 DDAgent MCP 伺服器',
			'mcp.install.description' => '讓所選代理透過 MCP 使用 DDAgent 知識庫與工具。',
			'mcp.install.cardDescription' => '透過 MCP 為你的代理提供知識庫與 DDAgent 工具 — 選擇代理，或為全部安裝。',
			'mcp.install.installSelected' => '安裝所選項目',
			'mcp.install.installForAll' => '為全部安裝',
			'mcp.install.button' => '安裝',
			'mcp.install.failed' => ({required Object error}) => '安裝失敗：${error}',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '已安裝於 ${count} 個代理。', other: '已安裝於 ${count} 個代理。', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => '已安裝於 ${count} 個；失敗：${failed}',
			'mcp.install.errorFallback' => '錯誤',
			'mcp.servers.loading' => '正在載入 MCP 伺服器...',
			'mcp.servers.refreshingScopes' => '正在重新整理專案範圍...',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Model Context Protocol 伺服器為 ${provider} 提供額外的工具和資料來源',
			'mcp.servers.addGlobalTitle' => '新增全域 MCP 伺服器',
			'mcp.servers.addGlobalDescription' => '將此 MCP 伺服器新增至所有提供者：Claude、Cursor、Codex、OpenCode 和 Devin。由於相同設定必須在所有提供者中運作，因此僅支援 stdio 與 HTTP 傳輸。',
			'mcp.servers.addGlobalMenuDescription' => '新增全域 MCP 伺服器會將一個通用 stdio 或 HTTP 伺服器寫入 Claude、Cursor、Codex、OpenCode 和 Devin。',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => '新增 ${provider} MCP 伺服器',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => '新增 ${provider} MCP 伺服器只會變更 ${provider}。',
			'mcp.servers.config.cwd' => '工作目錄',
			'mcp.servers.config.envVars' => '環境變數',
			'mcp.servers.selectProjectRequired' => '請為專案範圍的 MCP 伺服器選擇一個專案',
			'mcp.servers.globalScopeUnsupported' => '為所有供應商新增 MCP 伺服器時僅支援使用者或專案範圍。',
			'mcp.servers.globalAddFailed' => ({required Object details}) => '無法將 MCP 伺服器新增至所有供應商。${details}',
			'mcp.servers.scopeProject' => '專案',
			'mcp.team.title' => '團隊 MCP 設定',
			'mcp.team.description' => '在團隊中分享 MCP 伺服器設定。所有人都會自動保持同步。',
			'mcp.team.cta' => 'DDAgent Pro 提供',
			'mcp.tokens.scopeWrite' => '寫入',
			'mcp.tokens.scopeRead' => '讀取',
			'mcp.form.submitTo' => ({required Object provider}) => '將伺服器新增至 ${provider}',
			'mcp.form.scope.userAllProviders' => '使用者（所有提供者）',
			'mcp.form.scope.claudeLocal' => 'Claude 本機',
			'mcp.form.scope.projectAllProviders' => '專案（所有提供者）',
			'mcp.form.scope.description.userGlobal' => '寫入每個提供者的使用者設定，並可在此機器的所有專案中使用',
			'mcp.form.scope.description.user' => '可在您機器上的所有專案中使用',
			'mcp.form.scope.description.local' => '儲存在所選專案的 Claude 使用者設定中',
			'mcp.form.scope.description.projectGlobal' => '為每個提供者寫入所選專案工作區',
			'mcp.form.scope.description.project' => '儲存在所選專案工作區中',
			'mcp.form.fields.workingDirectory' => '工作目錄',
			'mcp.form.fields.envVarNames' => '環境變數名稱',
			'mcp.form.fields.bearerTokenEnvVar' => 'Bearer 權杖環境變數',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => '新增 MCP 伺服器在所有提供者中僅支援 stdio 和 http，不支援 ${type}。',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} 不支援 ${type} MCP 伺服器',
			'mcp.form.validation.jsonMustBeObject' => 'JSON 設定必須是一個物件',
			'notifications.deviceLabel' => 'DDAgent Flutter',
			'notifications.errors.registrationRejected' => '伺服器拒絕註冊',
			'notifications.errors.noResponse' => '伺服器沒有回應',
			'notifications.androidChannel.name' => 'DDAgent 警示',
			'notifications.androidChannel.description' => '代理程式執行、核准與錯誤通知',
			'onboarding.gitHint' => '用於 DDAgent 工作階段建立的提交。',
			'onboarding.completeSetup' => '完成設定',
			'onboarding.errors.nameAndEmailRequired' => 'git 名稱與電子郵件皆為必填。',
			'onboarding.errors.invalidEmail' => '請輸入有效的電子郵件地址。',
			'onboarding.agents.title' => '連接你的 AI 代理',
			'onboarding.agents.description' => '登入一個或多個 AI 程式開發助手。全部皆為選填。',
			'onboarding.agents.laterHint' => '你可以稍後在設定中進行設定。',
			'onboarding.mcp.title' => '將代理連接到 DDAgent',
			'onboarding.mcp.description' => '安裝 DDAgent MCP 伺服器，讓你的代理可以使用知識庫與 DDAgent 工具。選擇代理，或為全部安裝。',
			'onboarding.mcp.installSelected' => '安裝所選項目',
			'onboarding.mcp.installForAll' => '為全部安裝',
			'onboarding.mcp.laterHint' => '選填 — 你也可以稍後在設定 → MCP 中安裝。',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '已安裝於 ${count} 個代理。', other: '已安裝於 ${count} 個代理。', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => '已安裝於 ${installedCount} 個；失敗：${failed}',
			'projects.cloneRepository' => '複製儲存庫',
			'projects.repositoryCloned' => '儲存庫已複製',
			'projects.clone' => '複製',
			'projects.cloneFinished' => '複製完成。正在重新整理專案清單…',
			'projects.cloneFailed' => '複製失敗',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.destinationPath' => '目的地路徑',
			'projects.destinationPathRequired' => '目的地路徑為必填',
			'projects.repositoryUrlRequired' => '儲存庫 URL 為必填',
			'projects.githubTokenOptional' => 'GitHub 權杖（選填）',
			'projects.archive' => '封存',
			'projects.restore' => '還原',
			'projects.deletePermanently' => '永久刪除',
			'projects.deleteProjectTitle' => '刪除專案？',
			'projects.deleteProjectMessage' => ({required Object name}) => '永久移除「${name}」，包括所有工作階段與儲存的歷史記錄（清除 JSONL）。此操作無法復原。',
			'projects.archivedSection' => ({required Object count}) => '已封存（${count}）',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個工作階段', other: '${count} 個工作階段', ), 
			'projects.newer' => '較新',
			'projects.older' => '較舊',
			'projects.projectArchived' => '專案已封存',
			'projects.projectRestored' => '專案已還原',
			'projects.projectRenamed' => '專案已重新命名',
			'projects.projectDeleted' => '專案已刪除',
			'projects.failedToLoadTokens' => '載入 GitHub 權杖失敗',
			'projects.displayNameOptional' => '顯示名稱（選填）',
			'projects.usingStoredToken' => ({required Object name}) => '使用已儲存的權杖：${name}',
			'projects.unknown' => '未知',
			'projects.project' => '專案',
			'quota.section.config' => '設定',
			'quota.overview.tokensAndCost' => '權杖與成本',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status}（${count}）',
			'quota.config.pollerTitle' => '輪詢器與警示',
			'quota.config.accountRouting' => '帳戶路由',
			'quota.config.save' => '儲存設定',
			'quota.chart.show' => '顯示',
			'quota.chart.hide' => '隱藏',
			'quota.chart.noData' => '資料不足以顯示趨勢。',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} 權杖 · ${cost}',
			'quota.duration.minutes' => ({required Object minutes}) => '${minutes} 分鐘',
			'quota.duration.hoursMinutes' => ({required Object hours, required Object minutes}) => '${hours} 小時 ${minutes} 分鐘',
			'quota.duration.daysHours' => ({required Object days, required Object hours}) => '${days} 天 ${hours} 小時',
			'quota.duration.now' => '剛剛',
			'scheduler.newLabel' => '新增',
			'scheduler.runs' => '執行次數',
			'scheduler.editTitle' => '編輯排程',
			'scheduler.deleteTitle' => '刪除排程？',
			'scheduler.deleteMessage' => ({required Object id}) => '這會移除週期性工作 ${id}。現有工作階段會保留。',
			'scheduler.checking' => '檢查中…',
			'scheduler.nextIn' => ({required Object time}) => '${time} 後',
			'scheduler.worktree' => 'worktree',
			'scheduler.session' => ({required Object id}) => '工作階段 ${id}',
			'scheduler.cronHint' => 'Cron（分 時 日 月 星期）— 例如 0 9 * * *',
			'scheduler.promptHint' => '代理的提示詞',
			'scheduler.runStatus.fired' => '已觸發',
			'scheduler.runStatus.skipped' => '已略過',
			'scheduler.runStatus.failed' => '失敗',
			'scheduler.runStatus.completed' => '已完成',
			'scheduler.cronErrors.fieldCount' => ({required Object got}) => '需要 5 個欄位，實際為 ${got} 個',
			'scheduler.cronErrors.fieldError' => ({required Object index, required Object error}) => '欄位 ${index}：${error}',
			'scheduler.cronErrors.empty' => '為空',
			'scheduler.cronErrors.invalidPart' => ({required Object part}) => '無效的「${part}」',
			'scheduler.cronErrors.invalidValue' => ({required Object value}) => '無效值「${value}」',
			'serverConnect.subtitle' => '連線到你的 DDAgent 伺服器',
			'serverConnect.enterUrl' => '輸入伺服器 URL',
			'serverConnect.connectionFailed' => ({required Object error}) => '連線失敗（${error}）',
			'serverConnect.connect' => '連線',
			'serverConnect.connecting' => '正在連線…',
			'serverConnect.changeServer' => '更換伺服器',
			'serverConnect.local.title' => '此裝置',
			'serverConnect.local.subtitle' => '在此電腦上執行 DDAgent 伺服器',
			'serverConnect.local.install' => '安裝本機伺服器',
			'serverConnect.local.start' => '啟動本機伺服器',
			'serverConnect.local.stop' => '停止',
			'serverConnect.local.starting' => '正在啟動本機伺服器…',
			'serverConnect.local.downloading' => ({required Object percent}) => '正在下載伺服器… ${percent}%',
			'serverConnect.local.installing' => '正在安裝…',
			'serverConnect.local.running' => ({required Object url}) => '正在 ${url} 上執行',
			'serverConnect.local.installed' => ({required Object version}) => '已安裝 (v${version})',
			'serverConnect.local.connect' => '使用此伺服器',
			'serverConnect.local.error' => ({required Object error}) => '本機伺服器錯誤：${error}',
			'serverConnect.local.or' => '或連線到遠端伺服器',
			'serverConnect.local.errors.releaseTagUnresolved' => '無法取得最新的 DDAgent 發行標籤。',
			'serverConnect.local.errors.unsupportedPlatform' => '此平台不支援本機伺服器。',
			'serverConnect.local.errors.unsupportedPlatformDetail' => ({required Object platform}) => '此平台不支援本機伺服器（${platform}）。',
			'serverConnect.local.errors.nodeExtractionFailed' => ({required Object path}) => 'Node.js 解壓縮後未產生 ${path}',
			'serverConnect.local.errors.downloadFailed' => ({required Object error}) => '伺服器下載失敗：${error}',
			'serverConnect.local.errors.installFailed' => ({required Object error}) => '伺服器安裝失敗：${error}',
			'serverConnect.local.errors.bundleNotInstalled' => '伺服器套件未安裝。',
			'serverConnect.local.errors.spawnFailed' => ({required Object error}) => '無法啟動本機伺服器：${error}',
			'serverConnect.local.errors.portInUse' => ({required Object port}) => '連接埠 ${port} 已被其他應用程式使用。',
			'serverConnect.local.errors.exitedDuringStartup' => '本機伺服器在啟動期間結束。',
			'serverConnect.local.errors.exitedDuringStartupWithOutput' => ({required Object output}) => '本機伺服器在啟動期間結束：${output}',
			'serverConnect.local.errors.startTimeout' => '等待本機伺服器啟動逾時。',
			'serverConnect.local.errors.tarFailed' => ({required Object command, required Object code, required Object output}) => '${command} 失敗（結束代碼 ${code}）：${output}',
			'serverConnect.httpStatus' => ({required Object code}) => 'HTTP ${code}',
			'serverConnect.networkError' => '網路錯誤',
			'sessions.noSessions' => '沒有工作階段',
			'sessions.noRecentSessions' => '沒有最近的工作階段',
			'sessions.archivedSessions' => '已封存的工作階段',
			'sessions.rename' => '重新命名',
			'sessions.archive' => '封存',
			'sessions.compareWith' => '比較…',
			'sessions.projectPath' => '專案路徑',
			'sessions.newSessionProvider' => '新工作階段 — 提供者',
			'sessions.autoOrchestrator' => '自動（編排器）',
			'sessions.createFailed' => ({required Object error}) => '建立工作階段失敗：${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => '移除「${name}」及其記錄。此操作無法復原。',
			'sessions.toasts.archived' => '工作階段已封存',
			'sessions.toasts.restored' => '工作階段已還原',
			'sessions.toasts.deleted' => '工作階段已刪除',
			'sessions.toasts.renamed' => '工作階段已重新命名',
			'sessions.toasts.pinned' => '工作階段已釘選',
			'sessions.toasts.unpinned' => '工作階段已取消釘選',
			'sessions.toasts.workspaceChanged' => '工作區已變更',
			'sessions.age.lessThanMinute' => '<1 分鐘',
			'sessions.age.minutes' => ({required Object count}) => '${count} 分鐘',
			'sessions.age.hours' => ({required Object hours}) => '${hours} 小時',
			'sessions.age.days' => ({required Object days}) => '${days} 天',
			'sessions.activity.subagentRunning' => '子代理執行中',
			'sessions.activity.readingFile' => ({required Object file}) => '正在讀取 ${file}',
			'sessions.activity.runningTool' => ({required Object name}) => '正在執行 ${name}',
			'sessions.activity.editingFile' => ({required Object file}) => '正在編輯 ${file}',
			'sessions.activity.editingFileGeneric' => '正在編輯檔案',
			'sessions.activity.runningShellCommand' => '正在執行 Shell 指令',
			'sessions.activity.runningCommand' => ({required Object command}) => '正在執行 `${command}`',
			'sessions.activity.committingChanges' => '正在提交變更',
			'sessions.activity.pushingBranch' => '正在推送分支',
			'sessions.activity.fetchingUrl' => ({required Object url}) => '正在取得 ${url}',
			'sessions.activity.searching' => ({required Object query}) => '正在搜尋「${query}」',
			'sessions.autoMini' => '自動（迷你）',
			'sharedContext.title' => '共用筆記',
			'skills.moveSkill' => ({required Object name}) => '移動 ${name}',
			'skills.deleteSkill' => ({required Object name}) => '刪除 ${name}',
			'skills.projectLabel' => '專案',
			'skills.addDialog.title' => ({required Object provider}) => '新增 ${provider} 技能',
			'skills.addDialog.chooseFileTitle' => '選擇 SKILL.md',
			'skills.addDialog.chooseFolderTitle' => '選擇技能資料夾',
			'skills.addDialog.uploadHint' => '上傳 SKILL.md 檔案或完整的技能資料夾。',
			'skills.addDialog.pickTitle' => '選擇技能資料夾或 SKILL.md',
			'skills.addDialog.pickHint' => '資料夾可包含指令碼、參考資料與資源。',
			'skills.addDialog.chooseFiles' => '選擇檔案',
			'skills.addDialog.chooseFolder' => '選擇資料夾',
			'skills.addDialog.readyToInstall' => '可以安裝了',
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Markdown 檔案 · ${size}',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個檔案 · ${size}', other: '${count} 個檔案 · ${size}', ), 
			'skills.addDialog.removeQueued' => ({required Object name}) => '移除 ${name}',
			'skills.addDialog.whereWillThisInstall' => '這會安裝到哪裡？',
			'skills.addDialog.hideInstallLocation' => '隱藏安裝位置',
			'skills.addDialog.folderUploadsNote' => '資料夾上傳會保留所選資料夾名稱；獨立檔案則使用 `SKILL.md` 中的 `name`。',
			'skills.addDialog.installSkill' => '安裝技能',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '安裝 ${count} 個技能', other: '安裝 ${count} 個技能', ), 
			'skills.moveDialog.toProjectHint' => '選擇應擁有此技能的專案。它會移出提供者的全域技能目錄。',
			'skills.moveDialog.toGlobalHint' => '將此技能移至全域技能目錄，讓所有專案都能使用。',
			'skills.moveDialog.moveToProject' => '移至專案',
			'skills.moveDialog.moveToGlobal' => '移至全域',
			'skills.screen.manageDescription' => ({required Object provider}) => '從本機檔案、完整資料夾和專案感知位置管理 ${provider} 技能。',
			'skills.screen.searchHint' => '搜尋技能...',
			'skills.screen.clearSearch' => '清除技能搜尋',
			'skills.screen.addSkill' => '新增技能',
			'skills.screen.scanningProjectSkills' => '正在掃描專案技能...',
			'skills.screen.savedSuccessfully' => '技能已成功儲存。',
			'skills.screen.loadingSkills' => ({required Object provider}) => '正在載入 ${provider} 技能…',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 個技能', other: '${count} 個技能', ), 
			'skills.screen.deleteTitle' => ({required Object name}) => '刪除 ${name}？',
			'skills.screen.deleteDescription' => ({required Object provider, required Object directory}) => '這會從 ${provider} 的受管理技能目錄中移除 ${directory} 目錄。此操作無法復原。',
			'skills.screen.noDescription' => '技能前置資料中未提供說明。',
			'skills.screen.pluginBadge' => ({required Object name}) => '外掛：${name}',
			'skills.screen.projectBadge' => ({required Object name}) => '專案：${name}',
			'skills.screen.sourceLabel' => '來源',
			'skills.empty.noProjects' => '沒有可用的專案',
			'skills.empty.noProjectsDescription' => '新增專案或工作區以瀏覽其技能。',
			'skills.empty.noSkillsInProject' => '此專案沒有技能',
			'skills.empty.noSkillsInProjectDescription' => '在所選專案中建立 .claude/skills、.cursor/skills 或 .agents/skills 資料夾。',
			'skills.empty.noGlobalSkills' => '尚未找到全域技能',
			'skills.empty.noGlobalSkillsDescription' => '在上方新增全域技能，即可在所有專案中使用。',
			'skills.empty.noMatchingSkills' => '沒有符合的技能',
			'skills.empty.noMatchingSkillsDescription' => '請嘗試不同的指令、名稱、範圍、專案或來源路徑。',
			'skills.scopes.user' => '使用者',
			'skills.scopes.plugin' => '外掛',
			'skills.scopes.repo' => '儲存庫',
			'skills.scopes.project' => '專案',
			'skills.scopes.admin' => '管理員',
			'skills.scopes.system' => '系統',
			'skills.errors.dropMarkdownOrFolder' => '拖放一個或多個 Markdown 檔案，或包含 SKILL.md 的資料夾。',
			'skills.errors.addMarkdownFirst' => '請先新增一個或多個 Markdown 檔案。',
			'skills.errors.importFailed' => '匯入技能失敗',
			'skills.errors.folderReadFailed' => '讀取技能資料夾失敗',
			'skills.errors.folderFileLimit' => ({required Object count}) => '一個技能資料夾最多可包含 ${count} 個檔案。',
			'skills.errors.folderSizeLimit' => '所選技能資料夾的總大小必須小於 30 MB。',
			'skills.errors.missingSkillFile' => '所選資料夾不包含 SKILL.md 檔案。',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => '無法從 ${name} 讀取 SKILL.md。',
			'skills.providerShared' => '共用',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'terminal.tabs.plainShell' => '一般 Shell',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => '登入：${provider}',
			'terminal.tabs.runTitle' => ({required Object command}) => '執行：${command}',
			'terminal.actions.newTab' => '新增終端機分頁',
			'terminal.actions.providerLogin' => '提供者登入',
			'terminal.actions.restartSession' => '重新啟動工作階段',
			'terminal.actions.clearOutput' => '清除輸出',
			'terminal.actions.newShell' => '新增 Shell',
			'terminal.actions.connect' => '連線',
			'terminal.authUrl.openInBrowser' => '在瀏覽器中開啟',
			'terminal.authUrl.linkLabel' => ({required Object url}) => '驗證連結：${url}',
			'terminal.fileLink.detected' => ({required Object path}) => '偵測到檔案：${path}',
			'terminal.shortcuts.interrupt' => '中斷 (SIGINT)',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.suspend' => '暫停 (SIGTSTP)',
			'terminal.shortcuts.hide' => '隱藏快速鍵列',
			'terminal.shortcuts.showTooltip' => '顯示快速鍵',
			'terminal.shortcuts.hideTooltip' => '隱藏快速鍵',
			'terminal.paste.title' => '貼上至終端機',
			'terminal.paste.hint' => 'Ctrl+V / 按右鍵 → 貼上',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => '無法開啟連結：${url}',
			'terminal.errors.frameError' => ({required Object message}) => '[錯誤] ${message}',
			'terminal.errors.connectionError' => ({required Object message}) => '[連線錯誤] ${message}',
			'terminal.loginDialog.title' => ({required Object provider}) => '${provider} CLI 登入',
			'terminal.loginDialog.exited' => ({required Object code}) => '已結束（${code}）',
			'terminal.loginDialog.authLinkDetected' => '偵測到驗證連結',
			'terminal.empty.title' => '沒有作用中的終端機',
			'terminal.empty.description' => '建立新分頁以開始',
			'terminal.overlay.processExited' => '程序已結束 — 連線以重新啟動',
			'terminal.overlay.processExitedWithCode' => ({required Object code}) => '程序已結束（代碼 ${code}）— 連線以重新啟動',
			'terminal.overlay.resumeSession' => ({required Object title}) => '繼續工作階段 ${title}',
			_ => null,
		} ?? switch (path) {
			'terminal.overlay.startSession' => ({required Object path}) => '在 ${path} 中開始新的工作階段',
			'voice.preview' => '預覽',
			'voice.settingsSaved' => '語音輸入設定已儲存',
			'voice.saveFailed' => '儲存 STT 設定失敗',
			'voice.apiKeySaved' => 'API 金鑰（已儲存，輸入以取代）',
			'workspace.exportChat' => '匯出對話',
			'workspace.searchTranscript' => '搜尋記錄',
			'workspace.previousMatch' => '上一個符合項目',
			'workspace.nextMatch' => '下一個符合項目',
			'workspace.closeSearch' => '關閉搜尋',
			'workspace.newChatProvider' => '新對話 — 提供者',
			'workspace.closePane' => '關閉窗格',
			'workspace.jumpToSession' => '跳至工作階段…',
			'workspace.archivedWorkspaceName' => '已封存',
			'workspace.sendTo' => ({required Object count}) => '傳送至 ${count}',
			'workspace.deleteSessionNotice' => '移除工作階段及其記錄。無法復原。',
			'workspace.accountWithLabel' => ({required Object label}) => '預設 · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => '變更工作區前請先完成執行',
			'workspace.restored' => '工作區已還原',
			'workspace.maximizePane' => '最大化窗格',
			'workspace.restorePanes' => '還原窗格',
			'workspace.reviewChangedFiles' => '檢閱已變更的檔案',
			'workspace.paneTitle.chat' => '聊天',
			'workspace.paneTitle.browser' => '瀏覽器',
			'workspace.paneTitle.terminal' => '終端機',
			'workspace.paneTitle.notes' => '共用筆記',
			'workspace.paneTitle.editor' => '編輯器',
			'workspace.paneTitle.git' => 'Git',
			'workspace.addEditorPane' => '新增編輯器窗格',
			'workspace.addGitPane' => '新增 Git 窗格',
			'workspace.unknownProjectPath' => '未知的專案路徑',
			'workspace.autoMini' => '自動 (mini)',
			'workspace.exportAs' => '匯出為：',
			'workspace.exportMarkdown' => 'Markdown (.md)',
			'workspace.exportHtml' => '網頁 (.html)',
			'workspace.exportPdf' => 'PDF（列印至檔案）',
			'workspace.matchPosition' => ({required Object current, required Object total}) => '${current} / ${total}',
			'workspace.launcherDescription' => '為此窗格選擇一個工作區，或建立新的工作區。',
			'workspace.createWorkspace' => '建立工作區',
			'worktrees.scripts' => '指令碼',
			'worktrees.emptyTitle' => '找不到 worktree',
			'worktrees.emptyDescription' => '建立 worktree 以隔離功能開發或代理執行作業。',
			'worktrees.opened' => ({required Object branch}) => '已開啟 worktree：${branch}',
			'worktrees.created' => '已建立 worktree',
			'worktrees.removed' => '已移除 worktree',
			'worktrees.merged' => ({required Object branch}) => '已將 worktree 合併至 ${branch}',
			'worktrees.scriptsSaved' => '指令碼設定已儲存',
			'worktrees.setupLabel' => '設定：',
			'worktrees.serverLabel' => '伺服器：',
			'worktrees.runRunning' => '執行中',
			'worktrees.runRunningWithPort' => ({required Object port}) => '執行中 :${port}',
			'worktrees.runButton' => '執行',
			'worktrees.stopButton' => '停止',
			'worktrees.mainBadge' => 'main',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD 分離於 ${sha}',
			'worktrees.branchHint' => '新分支名稱（例如 feature/login）',
			'worktrees.branchingOff' => ({required Object branch}) => '從 ${branch} 建立分支',
			'worktrees.mergeTitle' => ({required Object branch}) => '合併 ${branch}',
			'worktrees.mergeDescription' => ({required Object branch}) => '將變更合併至 ${branch}。',
			'worktrees.squashDescription' => '將所有提交合併為單一提交',
			'worktrees.cleanupDescription' => '合併後移除 worktree 並刪除分支',
			'worktrees.removeTitle' => ({required Object branch}) => '移除 worktree ${branch}？',
			'worktrees.removeDescription' => '這會刪除 worktree 資料夾。連結的專案將被封存。',
			'worktrees.dirtyWarning' => ({required Object count}) => '警告：此 worktree 有 ${count} 個未提交的變更將會遺失。',
			'worktrees.forceRemoveLabel' => '強制移除（捨棄變更）',
			'worktrees.deleteBranchLabel' => '同時刪除分支',
			'worktrees.setupHint' => '設定指令（例如 npm install）',
			'worktrees.runHint' => '執行指令（例如 npm run dev）',
			'worktrees.portHint' => '執行連接埠（選填，例如 3000）',
			'worktrees.unknownSha' => '未知',
			'worktrees.baseBranchFallback' => '基礎分支',
			'worktrees.runtimeStatus.idle' => '閒置',
			'worktrees.runtimeStatus.running' => '執行中',
			'worktrees.runtimeStatus.done' => '已完成',
			'worktrees.runtimeStatus.failed' => '失敗',
			'worktrees.runtimeStatus.exited' => '已結束',
			'browserUse.sessionStatus.ready' => '就緒',
			'browserUse.sessionStatus.stopped' => '已停止',
			'browserUse.sessionStatus.unavailable' => '無法使用',
			'orchestrator.stepFallback' => ({required Object n}) => '步驟 ${n}',
			'miniOrchestrator.taskTypes.gate' => '關卡',
			'miniOrchestrator.roles.thinker' => '思考者',
			'miniOrchestrator.roles.worker' => '執行者',
			_ => null,
		};
	}
}
