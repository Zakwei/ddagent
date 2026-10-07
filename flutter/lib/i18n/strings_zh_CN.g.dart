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
class TranslationsZhCn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhCn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsZhCn _root = this; // ignore: unused_field

	@override 
	TranslationsZhCn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhCn(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$auth$zh_CN auth = Translations$auth$zh_CN.internal(_root);
	@override late final Translations$chat$zh_CN chat = Translations$chat$zh_CN.internal(_root);
	@override late final Translations$codeEditor$zh_CN codeEditor = Translations$codeEditor$zh_CN.internal(_root);
	@override late final Translations$common$zh_CN common = Translations$common$zh_CN.internal(_root);
	@override late final Translations$settings$zh_CN settings = Translations$settings$zh_CN.internal(_root);
	@override late final Translations$sidebar$zh_CN sidebar = Translations$sidebar$zh_CN.internal(_root);
	@override late final Translations$tasks$zh_CN tasks = Translations$tasks$zh_CN.internal(_root);
	@override late final Translations$knowledge$zh_CN knowledge = Translations$knowledge$zh_CN.internal(_root);
	@override late final Translations$skills$zh_CN skills = Translations$skills$zh_CN.internal(_root);
	@override late final Translations$mcp$zh_CN mcp = Translations$mcp$zh_CN.internal(_root);
	@override late final Translations$terminal$zh_CN terminal = Translations$terminal$zh_CN.internal(_root);
	@override late final Translations$worktrees$zh_CN worktrees = Translations$worktrees$zh_CN.internal(_root);
	@override late final Translations$quota$zh_CN quota = Translations$quota$zh_CN.internal(_root);
	@override late final Translations$scheduler$zh_CN scheduler = Translations$scheduler$zh_CN.internal(_root);
	@override late final Translations$notifications$zh_CN notifications = Translations$notifications$zh_CN.internal(_root);
	@override late final Translations$serverConnect$zh_CN serverConnect = Translations$serverConnect$zh_CN.internal(_root);
	@override late final Translations$voice$zh_CN voice = Translations$voice$zh_CN.internal(_root);
	@override late final Translations$preview$zh_CN preview = Translations$preview$zh_CN.internal(_root);
	@override late final Translations$sharedContext$zh_CN sharedContext = Translations$sharedContext$zh_CN.internal(_root);
	@override late final Translations$collab$zh_CN collab = Translations$collab$zh_CN.internal(_root);
	@override late final Translations$browser$zh_CN browser = Translations$browser$zh_CN.internal(_root);
	@override late final Translations$projects$zh_CN projects = Translations$projects$zh_CN.internal(_root);
	@override late final Translations$sessions$zh_CN sessions = Translations$sessions$zh_CN.internal(_root);
	@override late final Translations$git$zh_CN git = Translations$git$zh_CN.internal(_root);
	@override late final Translations$kanban$zh_CN kanban = Translations$kanban$zh_CN.internal(_root);
	@override late final Translations$onboarding$zh_CN onboarding = Translations$onboarding$zh_CN.internal(_root);
	@override late final Translations$fileTree$zh_CN fileTree = Translations$fileTree$zh_CN.internal(_root);
	@override late final Translations$workspace$zh_CN workspace = Translations$workspace$zh_CN.internal(_root);
}

// Path: auth
class Translations$auth$zh_CN extends Translations$auth$en {
	Translations$auth$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get sessionExpired => '会话已过期，请重新登录。';
	@override late final Translations$auth$login$zh_CN login = Translations$auth$login$zh_CN.internal(_root);
	@override late final Translations$auth$register$zh_CN register = Translations$auth$register$zh_CN.internal(_root);
	@override late final Translations$auth$logout$zh_CN logout = Translations$auth$logout$zh_CN.internal(_root);
}

// Path: chat
class Translations$chat$zh_CN extends Translations$chat$en {
	Translations$chat$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$codeBlock$zh_CN codeBlock = Translations$chat$codeBlock$zh_CN.internal(_root);
	@override late final Translations$chat$copyMessage$zh_CN copyMessage = Translations$chat$copyMessage$zh_CN.internal(_root);
	@override late final Translations$chat$messageTypes$zh_CN messageTypes = Translations$chat$messageTypes$zh_CN.internal(_root);
	@override late final Translations$chat$tools$zh_CN tools = Translations$chat$tools$zh_CN.internal(_root);
	@override late final Translations$chat$search$zh_CN search = Translations$chat$search$zh_CN.internal(_root);
	@override late final Translations$chat$fileOperations$zh_CN fileOperations = Translations$chat$fileOperations$zh_CN.internal(_root);
	@override late final Translations$chat$interactive$zh_CN interactive = Translations$chat$interactive$zh_CN.internal(_root);
	@override late final Translations$chat$thinking$zh_CN thinking = Translations$chat$thinking$zh_CN.internal(_root);
	@override late final Translations$chat$json$zh_CN json = Translations$chat$json$zh_CN.internal(_root);
	@override late final Translations$chat$permissions$zh_CN permissions = Translations$chat$permissions$zh_CN.internal(_root);
	@override late final Translations$chat$todo$zh_CN todo = Translations$chat$todo$zh_CN.internal(_root);
	@override late final Translations$chat$plan$zh_CN plan = Translations$chat$plan$zh_CN.internal(_root);
	@override late final Translations$chat$usageLimit$zh_CN usageLimit = Translations$chat$usageLimit$zh_CN.internal(_root);
	@override late final Translations$chat$codex$zh_CN codex = Translations$chat$codex$zh_CN.internal(_root);
	@override late final Translations$chat$input$zh_CN input = Translations$chat$input$zh_CN.internal(_root);
	@override late final Translations$chat$providerSelection$zh_CN providerSelection = Translations$chat$providerSelection$zh_CN.internal(_root);
	@override late final Translations$chat$session$zh_CN session = Translations$chat$session$zh_CN.internal(_root);
	@override late final Translations$chat$shell$zh_CN shell = Translations$chat$shell$zh_CN.internal(_root);
	@override late final Translations$chat$claudeStatus$zh_CN claudeStatus = Translations$chat$claudeStatus$zh_CN.internal(_root);
	@override late final Translations$chat$projectSelection$zh_CN projectSelection = Translations$chat$projectSelection$zh_CN.internal(_root);
	@override late final Translations$chat$tasks$zh_CN tasks = Translations$chat$tasks$zh_CN.internal(_root);
	@override late final Translations$chat$voice$zh_CN voice = Translations$chat$voice$zh_CN.internal(_root);
	@override late final Translations$chat$composer$zh_CN composer = Translations$chat$composer$zh_CN.internal(_root);
	@override late final Translations$chat$splitSession$zh_CN splitSession = Translations$chat$splitSession$zh_CN.internal(_root);
	@override late final Translations$chat$sessionPicker$zh_CN sessionPicker = Translations$chat$sessionPicker$zh_CN.internal(_root);
	@override late final Translations$chat$splitWorkspace$zh_CN splitWorkspace = Translations$chat$splitWorkspace$zh_CN.internal(_root);
	@override late final Translations$chat$splitOverview$zh_CN splitOverview = Translations$chat$splitOverview$zh_CN.internal(_root);
	@override late final Translations$chat$askUserQuestion$zh_CN askUserQuestion = Translations$chat$askUserQuestion$zh_CN.internal(_root);
	@override late final Translations$chat$attachments$zh_CN attachments = Translations$chat$attachments$zh_CN.internal(_root);
	@override late final Translations$chat$checkpoint$zh_CN checkpoint = Translations$chat$checkpoint$zh_CN.internal(_root);
	@override late final Translations$chat$common$zh_CN common = Translations$chat$common$zh_CN.internal(_root);
	@override late final Translations$chat$taskMaster$zh_CN taskMaster = Translations$chat$taskMaster$zh_CN.internal(_root);
	@override late final Translations$chat$tokenUsage$zh_CN tokenUsage = Translations$chat$tokenUsage$zh_CN.internal(_root);
	@override late final Translations$chat$tool$zh_CN tool = Translations$chat$tool$zh_CN.internal(_root);
	@override late final Translations$chat$quotaBadge$zh_CN quotaBadge = Translations$chat$quotaBadge$zh_CN.internal(_root);
	@override late final Translations$chat$paneHeader$zh_CN paneHeader = Translations$chat$paneHeader$zh_CN.internal(_root);
	@override late final Translations$chat$broadcast$zh_CN broadcast = Translations$chat$broadcast$zh_CN.internal(_root);
	@override late final Translations$chat$changes$zh_CN changes = Translations$chat$changes$zh_CN.internal(_root);
	@override late final Translations$chat$commandResult$zh_CN commandResult = Translations$chat$commandResult$zh_CN.internal(_root);
	@override late final Translations$chat$commands$zh_CN commands = Translations$chat$commands$zh_CN.internal(_root);
	@override late final Translations$chat$export$zh_CN export = Translations$chat$export$zh_CN.internal(_root);
	@override late final Translations$chat$message$zh_CN message = Translations$chat$message$zh_CN.internal(_root);
	@override late final Translations$chat$modelLibrary$zh_CN modelLibrary = Translations$chat$modelLibrary$zh_CN.internal(_root);
	@override late final Translations$chat$pinFile$zh_CN pinFile = Translations$chat$pinFile$zh_CN.internal(_root);
	@override late final Translations$chat$permissionRequest$zh_CN permissionRequest = Translations$chat$permissionRequest$zh_CN.internal(_root);
}

// Path: codeEditor
class Translations$codeEditor$zh_CN extends Translations$codeEditor$en {
	Translations$codeEditor$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$codeEditor$toolbar$zh_CN toolbar = Translations$codeEditor$toolbar$zh_CN.internal(_root);
	@override String loading({required Object fileName}) => '正在加载 ${fileName}...';
	@override late final Translations$codeEditor$header$zh_CN header = Translations$codeEditor$header$zh_CN.internal(_root);
	@override late final Translations$codeEditor$actions$zh_CN actions = Translations$codeEditor$actions$zh_CN.internal(_root);
	@override late final Translations$codeEditor$footer$zh_CN footer = Translations$codeEditor$footer$zh_CN.internal(_root);
	@override late final Translations$codeEditor$binaryFile$zh_CN binaryFile = Translations$codeEditor$binaryFile$zh_CN.internal(_root);
	@override late final Translations$codeEditor$filePreview$zh_CN filePreview = Translations$codeEditor$filePreview$zh_CN.internal(_root);
	@override late final Translations$codeEditor$diff$zh_CN diff = Translations$codeEditor$diff$zh_CN.internal(_root);
	@override String get discardUnsavedChanges => '放弃未保存的更改？';
	@override late final Translations$codeEditor$emptyState$zh_CN emptyState = Translations$codeEditor$emptyState$zh_CN.internal(_root);
	@override String get failedToLoad => '加载文件失败';
	@override late final Translations$codeEditor$hexDump$zh_CN hexDump = Translations$codeEditor$hexDump$zh_CN.internal(_root);
	@override late final Translations$codeEditor$mediaFile$zh_CN mediaFile = Translations$codeEditor$mediaFile$zh_CN.internal(_root);
	@override late final Translations$codeEditor$settings$zh_CN settings = Translations$codeEditor$settings$zh_CN.internal(_root);
	@override String unsavedChanges({required Object name}) => '${name} 中有未保存的更改';
	@override late final Translations$codeEditor$toasts$zh_CN toasts = Translations$codeEditor$toasts$zh_CN.internal(_root);
}

// Path: common
class Translations$common$zh_CN extends Translations$common$en {
	Translations$common$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$buttons$zh_CN buttons = Translations$common$buttons$zh_CN.internal(_root);
	@override late final Translations$common$tabs$zh_CN tabs = Translations$common$tabs$zh_CN.internal(_root);
	@override late final Translations$common$status$zh_CN status = Translations$common$status$zh_CN.internal(_root);
	@override late final Translations$common$messages$zh_CN messages = Translations$common$messages$zh_CN.internal(_root);
	@override late final Translations$common$navigation$zh_CN navigation = Translations$common$navigation$zh_CN.internal(_root);
	@override late final Translations$common$common$zh_CN common = Translations$common$common$zh_CN.internal(_root);
	@override late final Translations$common$time$zh_CN time = Translations$common$time$zh_CN.internal(_root);
	@override late final Translations$common$fileOperations$zh_CN fileOperations = Translations$common$fileOperations$zh_CN.internal(_root);
	@override late final Translations$common$mainContent$zh_CN mainContent = Translations$common$mainContent$zh_CN.internal(_root);
	@override late final Translations$common$fileTree$zh_CN fileTree = Translations$common$fileTree$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$zh_CN projectWizard = Translations$common$projectWizard$zh_CN.internal(_root);
	@override late final Translations$common$notifications$zh_CN notifications = Translations$common$notifications$zh_CN.internal(_root);
	@override late final Translations$common$versionUpdate$zh_CN versionUpdate = Translations$common$versionUpdate$zh_CN.internal(_root);
	@override late final Translations$common$quota$zh_CN quota = Translations$common$quota$zh_CN.internal(_root);
	@override late final Translations$common$actions$zh_CN actions = Translations$common$actions$zh_CN.internal(_root);
	@override late final Translations$common$browserPane$zh_CN browserPane = Translations$common$browserPane$zh_CN.internal(_root);
	@override late final Translations$common$browserUse$zh_CN browserUse = Translations$common$browserUse$zh_CN.internal(_root);
	@override late final Translations$common$commandPalette$zh_CN commandPalette = Translations$common$commandPalette$zh_CN.internal(_root);
	@override late final Translations$common$gitPanel$zh_CN gitPanel = Translations$common$gitPanel$zh_CN.internal(_root);
	@override late final Translations$common$sessions$zh_CN sessions = Translations$common$sessions$zh_CN.internal(_root);
	@override late final Translations$common$projects$zh_CN projects = Translations$common$projects$zh_CN.internal(_root);
	@override late final Translations$common$codeBlock$zh_CN codeBlock = Translations$common$codeBlock$zh_CN.internal(_root);
	@override late final Translations$common$update$zh_CN update = Translations$common$update$zh_CN.internal(_root);
}

// Path: settings
class Translations$settings$zh_CN extends Translations$settings$en {
	Translations$settings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '设置';
	@override late final Translations$settings$changelog$zh_CN changelog = Translations$settings$changelog$zh_CN.internal(_root);
	@override late final Translations$settings$server$zh_CN server = Translations$settings$server$zh_CN.internal(_root);
	@override late final Translations$settings$updates$zh_CN updates = Translations$settings$updates$zh_CN.internal(_root);
	@override late final Translations$settings$tabs$zh_CN tabs = Translations$settings$tabs$zh_CN.internal(_root);
	@override late final Translations$settings$account$zh_CN account = Translations$settings$account$zh_CN.internal(_root);
	@override late final Translations$settings$mcp$zh_CN mcp = Translations$settings$mcp$zh_CN.internal(_root);
	@override late final Translations$settings$appearance$zh_CN appearance = Translations$settings$appearance$zh_CN.internal(_root);
	@override late final Translations$settings$actions$zh_CN actions = Translations$settings$actions$zh_CN.internal(_root);
	@override late final Translations$settings$quickSettings$zh_CN quickSettings = Translations$settings$quickSettings$zh_CN.internal(_root);
	@override late final Translations$settings$terminalShortcuts$zh_CN terminalShortcuts = Translations$settings$terminalShortcuts$zh_CN.internal(_root);
	@override late final Translations$settings$mainTabs$zh_CN mainTabs = Translations$settings$mainTabs$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$zh_CN orchestration = Translations$settings$orchestration$zh_CN.internal(_root);
	@override late final Translations$settings$notifications$zh_CN notifications = Translations$settings$notifications$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$zh_CN appearanceSettings = Translations$settings$appearanceSettings$zh_CN.internal(_root);
	@override late final Translations$settings$mcpForm$zh_CN mcpForm = Translations$settings$mcpForm$zh_CN.internal(_root);
	@override late final Translations$settings$saveStatus$zh_CN saveStatus = Translations$settings$saveStatus$zh_CN.internal(_root);
	@override late final Translations$settings$footerActions$zh_CN footerActions = Translations$settings$footerActions$zh_CN.internal(_root);
	@override late final Translations$settings$git$zh_CN git = Translations$settings$git$zh_CN.internal(_root);
	@override late final Translations$settings$apiKeys$zh_CN apiKeys = Translations$settings$apiKeys$zh_CN.internal(_root);
	@override late final Translations$settings$tasks$zh_CN tasks = Translations$settings$tasks$zh_CN.internal(_root);
	@override late final Translations$settings$agents$zh_CN agents = Translations$settings$agents$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$zh_CN permissions = Translations$settings$permissions$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$zh_CN mcpServers = Translations$settings$mcpServers$zh_CN.internal(_root);
	@override late final Translations$settings$quota$zh_CN quota = Translations$settings$quota$zh_CN.internal(_root);
	@override late final Translations$settings$browser$zh_CN browser = Translations$settings$browser$zh_CN.internal(_root);
	@override late final Translations$settings$workspaces$zh_CN workspaces = Translations$settings$workspaces$zh_CN.internal(_root);
	@override late final Translations$settings$about$zh_CN about = Translations$settings$about$zh_CN.internal(_root);
}

// Path: sidebar
class Translations$sidebar$zh_CN extends Translations$sidebar$en {
	Translations$sidebar$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$sidebar$projects$zh_CN projects = Translations$sidebar$projects$zh_CN.internal(_root);
	@override late final Translations$sidebar$app$zh_CN app = Translations$sidebar$app$zh_CN.internal(_root);
	@override late final Translations$sidebar$sessions$zh_CN sessions = Translations$sidebar$sessions$zh_CN.internal(_root);
	@override late final Translations$sidebar$tooltips$zh_CN tooltips = Translations$sidebar$tooltips$zh_CN.internal(_root);
	@override late final Translations$sidebar$navigation$zh_CN navigation = Translations$sidebar$navigation$zh_CN.internal(_root);
	@override late final Translations$sidebar$actions$zh_CN actions = Translations$sidebar$actions$zh_CN.internal(_root);
	@override late final Translations$sidebar$branding$zh_CN branding = Translations$sidebar$branding$zh_CN.internal(_root);
	@override late final Translations$sidebar$status$zh_CN status = Translations$sidebar$status$zh_CN.internal(_root);
	@override late final Translations$sidebar$time$zh_CN time = Translations$sidebar$time$zh_CN.internal(_root);
	@override late final Translations$sidebar$messages$zh_CN messages = Translations$sidebar$messages$zh_CN.internal(_root);
	@override late final Translations$sidebar$version$zh_CN version = Translations$sidebar$version$zh_CN.internal(_root);
	@override late final Translations$sidebar$search$zh_CN search = Translations$sidebar$search$zh_CN.internal(_root);
	@override late final Translations$sidebar$deleteConfirmation$zh_CN deleteConfirmation = Translations$sidebar$deleteConfirmation$zh_CN.internal(_root);
	@override late final Translations$sidebar$zones$zh_CN zones = Translations$sidebar$zones$zh_CN.internal(_root);
	@override late final Translations$sidebar$panel$zh_CN panel = Translations$sidebar$panel$zh_CN.internal(_root);
	@override late final Translations$sidebar$workspace$zh_CN workspace = Translations$sidebar$workspace$zh_CN.internal(_root);
	@override late final Translations$sidebar$recent$zh_CN recent = Translations$sidebar$recent$zh_CN.internal(_root);
	@override late final Translations$sidebar$tabs$zh_CN tabs = Translations$sidebar$tabs$zh_CN.internal(_root);
}

// Path: tasks
class Translations$tasks$zh_CN extends Translations$tasks$en {
	Translations$tasks$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$notConfigured$zh_CN notConfigured = Translations$tasks$notConfigured$zh_CN.internal(_root);
	@override late final Translations$tasks$gettingStarted$zh_CN gettingStarted = Translations$tasks$gettingStarted$zh_CN.internal(_root);
	@override late final Translations$tasks$setupModal$zh_CN setupModal = Translations$tasks$setupModal$zh_CN.internal(_root);
	@override late final Translations$tasks$helpGuide$zh_CN helpGuide = Translations$tasks$helpGuide$zh_CN.internal(_root);
	@override late final Translations$tasks$search$zh_CN search = Translations$tasks$search$zh_CN.internal(_root);
	@override late final Translations$tasks$filters$zh_CN filters = Translations$tasks$filters$zh_CN.internal(_root);
	@override late final Translations$tasks$sort$zh_CN sort = Translations$tasks$sort$zh_CN.internal(_root);
	@override late final Translations$tasks$views$zh_CN views = Translations$tasks$views$zh_CN.internal(_root);
	@override late final Translations$tasks$kanban$zh_CN kanban = Translations$tasks$kanban$zh_CN.internal(_root);
	@override late final Translations$tasks$buttons$zh_CN buttons = Translations$tasks$buttons$zh_CN.internal(_root);
	@override late final Translations$tasks$prd$zh_CN prd = Translations$tasks$prd$zh_CN.internal(_root);
	@override late final Translations$tasks$statuses$zh_CN statuses = Translations$tasks$statuses$zh_CN.internal(_root);
	@override late final Translations$tasks$priorities$zh_CN priorities = Translations$tasks$priorities$zh_CN.internal(_root);
	@override late final Translations$tasks$noMatchingTasks$zh_CN noMatchingTasks = Translations$tasks$noMatchingTasks$zh_CN.internal(_root);
	@override late final Translations$tasks$board$zh_CN board = Translations$tasks$board$zh_CN.internal(_root);
	@override late final Translations$tasks$card$zh_CN card = Translations$tasks$card$zh_CN.internal(_root);
	@override late final Translations$tasks$createTask$zh_CN createTask = Translations$tasks$createTask$zh_CN.internal(_root);
	@override late final Translations$tasks$list$zh_CN list = Translations$tasks$list$zh_CN.internal(_root);
	@override late final Translations$tasks$nextTask$zh_CN nextTask = Translations$tasks$nextTask$zh_CN.internal(_root);
	@override late final Translations$tasks$taskDetail$zh_CN taskDetail = Translations$tasks$taskDetail$zh_CN.internal(_root);
	@override late final Translations$tasks$toasts$zh_CN toasts = Translations$tasks$toasts$zh_CN.internal(_root);
}

// Path: knowledge
class Translations$knowledge$zh_CN extends Translations$knowledge$en {
	Translations$knowledge$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '知识';
	@override late final Translations$knowledge$tabs$zh_CN tabs = Translations$knowledge$tabs$zh_CN.internal(_root);
	@override late final Translations$knowledge$common$zh_CN common = Translations$knowledge$common$zh_CN.internal(_root);
	@override late final Translations$knowledge$actions$zh_CN actions = Translations$knowledge$actions$zh_CN.internal(_root);
	@override late final Translations$knowledge$dialog$zh_CN dialog = Translations$knowledge$dialog$zh_CN.internal(_root);
	@override late final Translations$knowledge$fields$zh_CN fields = Translations$knowledge$fields$zh_CN.internal(_root);
	@override late final Translations$knowledge$dashboard$zh_CN dashboard = Translations$knowledge$dashboard$zh_CN.internal(_root);
	@override late final Translations$knowledge$empty$zh_CN empty = Translations$knowledge$empty$zh_CN.internal(_root);
	@override late final Translations$knowledge$history$zh_CN history = Translations$knowledge$history$zh_CN.internal(_root);
	@override late final Translations$knowledge$priorities$zh_CN priorities = Translations$knowledge$priorities$zh_CN.internal(_root);
	@override late final Translations$knowledge$search$zh_CN search = Translations$knowledge$search$zh_CN.internal(_root);
	@override late final Translations$knowledge$links$zh_CN links = Translations$knowledge$links$zh_CN.internal(_root);
	@override late final Translations$knowledge$tags$zh_CN tags = Translations$knowledge$tags$zh_CN.internal(_root);
	@override late final Translations$knowledge$contextBudget$zh_CN contextBudget = Translations$knowledge$contextBudget$zh_CN.internal(_root);
	@override late final Translations$knowledge$critical$zh_CN critical = Translations$knowledge$critical$zh_CN.internal(_root);
	@override late final Translations$knowledge$errors$zh_CN errors = Translations$knowledge$errors$zh_CN.internal(_root);
	@override late final Translations$knowledge$graph$zh_CN graph = Translations$knowledge$graph$zh_CN.internal(_root);
	@override late final Translations$knowledge$importAll$zh_CN importAll = Translations$knowledge$importAll$zh_CN.internal(_root);
	@override late final Translations$knowledge$importSkills$zh_CN importSkills = Translations$knowledge$importSkills$zh_CN.internal(_root);
	@override late final Translations$knowledge$linkOptions$zh_CN linkOptions = Translations$knowledge$linkOptions$zh_CN.internal(_root);
	@override late final Translations$knowledge$migrate$zh_CN migrate = Translations$knowledge$migrate$zh_CN.internal(_root);
}

// Path: skills
class Translations$skills$zh_CN extends Translations$skills$en {
	Translations$skills$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$skills$addDialog$zh_CN addDialog = Translations$skills$addDialog$zh_CN.internal(_root);
	@override String deleteSkill({required Object name}) => '删除 ${name}';
	@override late final Translations$skills$empty$zh_CN empty = Translations$skills$empty$zh_CN.internal(_root);
	@override late final Translations$skills$errors$zh_CN errors = Translations$skills$errors$zh_CN.internal(_root);
	@override late final Translations$skills$moveDialog$zh_CN moveDialog = Translations$skills$moveDialog$zh_CN.internal(_root);
	@override String moveSkill({required Object name}) => '移动 ${name}';
	@override String get projectLabel => '项目';
	@override late final Translations$skills$scopes$zh_CN scopes = Translations$skills$scopes$zh_CN.internal(_root);
	@override late final Translations$skills$screen$zh_CN screen = Translations$skills$screen$zh_CN.internal(_root);
}

// Path: mcp
class Translations$mcp$zh_CN extends Translations$mcp$en {
	Translations$mcp$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$zh_CN form = Translations$mcp$form$zh_CN.internal(_root);
	@override late final Translations$mcp$install$zh_CN install = Translations$mcp$install$zh_CN.internal(_root);
	@override late final Translations$mcp$servers$zh_CN servers = Translations$mcp$servers$zh_CN.internal(_root);
	@override late final Translations$mcp$team$zh_CN team = Translations$mcp$team$zh_CN.internal(_root);
	@override late final Translations$mcp$tokens$zh_CN tokens = Translations$mcp$tokens$zh_CN.internal(_root);
}

// Path: terminal
class Translations$terminal$zh_CN extends Translations$terminal$en {
	Translations$terminal$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$terminal$actions$zh_CN actions = Translations$terminal$actions$zh_CN.internal(_root);
	@override late final Translations$terminal$authUrl$zh_CN authUrl = Translations$terminal$authUrl$zh_CN.internal(_root);
	@override late final Translations$terminal$errors$zh_CN errors = Translations$terminal$errors$zh_CN.internal(_root);
	@override late final Translations$terminal$fileLink$zh_CN fileLink = Translations$terminal$fileLink$zh_CN.internal(_root);
	@override late final Translations$terminal$paste$zh_CN paste = Translations$terminal$paste$zh_CN.internal(_root);
	@override late final Translations$terminal$shortcuts$zh_CN shortcuts = Translations$terminal$shortcuts$zh_CN.internal(_root);
	@override late final Translations$terminal$tabs$zh_CN tabs = Translations$terminal$tabs$zh_CN.internal(_root);
}

// Path: worktrees
class Translations$worktrees$zh_CN extends Translations$worktrees$en {
	Translations$worktrees$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get branchHint => '新分支名称（例如 feature/login）';
	@override String branchingOff({required Object branch}) => '从 ${branch} 创建分支';
	@override String get cleanupDescription => '合并后移除 worktree 并删除分支';
	@override String get created => 'Worktree 已创建';
	@override String get deleteBranchLabel => '同时删除分支';
	@override String dirtyWarning({required Object count}) => '警告：此 worktree 有 ${count} 个未提交的更改将会丢失。';
	@override String get emptyDescription => '创建 worktree 以隔离功能开发或代理运行。';
	@override String get emptyTitle => '未找到 worktree';
	@override String get forceRemoveLabel => '强制移除（放弃更改）';
	@override String headDetachedAt({required Object sha}) => 'HEAD 分离于 ${sha}';
	@override String get mainBadge => 'main';
	@override String mergeDescription({required Object branch}) => '将更改合并到 ${branch}。';
	@override String mergeTitle({required Object branch}) => '合并 ${branch}';
	@override String merged({required Object branch}) => 'Worktree 已合并到 ${branch}';
	@override String opened({required Object branch}) => '已打开 worktree：${branch}';
	@override String get portHint => '运行端口（可选，例如 3000）';
	@override String get removeDescription => '这将删除 worktree 文件夹。关联的项目将被归档。';
	@override String removeTitle({required Object branch}) => '移除 worktree ${branch}？';
	@override String get removed => 'Worktree 已移除';
	@override String get runButton => '运行';
	@override String get runHint => '运行命令（例如 npm run dev）';
	@override String get runRunning => '运行中';
	@override String runRunningWithPort({required Object port}) => '运行中 :${port}';
	@override String get scripts => '脚本';
	@override String get scriptsSaved => '脚本配置已保存';
	@override String get serverLabel => '服务器： ';
	@override String get setupHint => '初始化命令（例如 npm install）';
	@override String get setupLabel => '初始化： ';
	@override String get squashDescription => '将所有提交合并为单个提交';
	@override String get stopButton => '停止';
}

// Path: quota
class Translations$quota$zh_CN extends Translations$quota$en {
	Translations$quota$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$quota$agents$zh_CN agents = Translations$quota$agents$zh_CN.internal(_root);
	@override late final Translations$quota$chart$zh_CN chart = Translations$quota$chart$zh_CN.internal(_root);
	@override late final Translations$quota$config$zh_CN config = Translations$quota$config$zh_CN.internal(_root);
	@override late final Translations$quota$overview$zh_CN overview = Translations$quota$overview$zh_CN.internal(_root);
	@override late final Translations$quota$section$zh_CN section = Translations$quota$section$zh_CN.internal(_root);
}

// Path: scheduler
class Translations$scheduler$zh_CN extends Translations$scheduler$en {
	Translations$scheduler$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get checking => '检查中…';
	@override String get cronHint => 'Cron（分 时 日 月 周）— 例如 0 9 * * *';
	@override String deleteMessage({required Object id}) => '这将移除重复任务 ${id}。现有会话会保留。';
	@override String get deleteTitle => '删除定时任务？';
	@override String get editTitle => '编辑定时任务';
	@override String get newLabel => '新建';
	@override String nextIn({required Object time}) => '${time} 后';
	@override String get promptHint => '给代理的提示词';
	@override String get runs => '运行次数';
	@override String session({required Object id}) => '会话 ${id}';
	@override String get worktree => 'worktree';
}

// Path: notifications
class Translations$notifications$zh_CN extends Translations$notifications$en {
	Translations$notifications$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get deviceLabel => 'ddagent Flutter';
	@override late final Translations$notifications$errors$zh_CN errors = Translations$notifications$errors$zh_CN.internal(_root);
}

// Path: serverConnect
class Translations$serverConnect$zh_CN extends Translations$serverConnect$en {
	Translations$serverConnect$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get connect => '连接';
	@override String get connecting => '正在连接…';
	@override String get changeServer => '更换服务器';
	@override String connectionFailed({required Object error}) => '连接失败（${error}）';
	@override String get enterUrl => '输入服务器 URL';
	@override late final Translations$serverConnect$local$zh_CN local = Translations$serverConnect$local$zh_CN.internal(_root);
	@override String get subtitle => '连接到你的 ddagent 服务器';
}

// Path: voice
class Translations$voice$zh_CN extends Translations$voice$en {
	Translations$voice$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get apiKeySaved => 'API 密钥（已保存，输入以替换）';
	@override String get preview => '预览';
	@override String get saveFailed => '保存 STT 配置失败';
	@override String get settingsSaved => '语音输入设置已保存';
}

// Path: preview
class Translations$preview$zh_CN extends Translations$preview$en {
	Translations$preview$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get embeddedWebOnly => '内嵌预览仅在 Web 构建中可用';
	@override String get startDevServerHint => '启动开发服务器（npm run dev、flutter run -d web-server…）\n其端口会显示在这里。';
}

// Path: sharedContext
class Translations$sharedContext$zh_CN extends Translations$sharedContext$en {
	Translations$sharedContext$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '共享笔记';
}

// Path: collab
class Translations$collab$zh_CN extends Translations$collab$en {
	Translations$collab$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get copyToken => '复制令牌';
	@override String get createInvite => '创建邀请';
	@override String get invite => '邀请';
	@override String get inviteTeammate => '邀请队友';
	@override late final Translations$collab$roles$zh_CN roles = Translations$collab$roles$zh_CN.internal(_root);
	@override String get shareTokenHint => '分享此邀请令牌 — 它仅显示一次，并在 72 小时后过期：';
	@override String get team => '团队';
}

// Path: browser
class Translations$browser$zh_CN extends Translations$browser$en {
	Translations$browser$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dialogTitle => '代理浏览器';
	@override String get viewError => '浏览器视图错误';
	@override String get web => 'Web';
}

// Path: projects
class Translations$projects$zh_CN extends Translations$projects$en {
	Translations$projects$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get archive => '归档';
	@override String archivedSection({required Object count}) => '已归档（${count}）';
	@override String get clone => '克隆';
	@override String get cloneFailed => '克隆失败';
	@override String get cloneFinished => '克隆完成。正在刷新项目列表…';
	@override String get cloneRepository => '克隆仓库';
	@override String get deletePermanently => '永久删除';
	@override String deleteProjectMessage({required Object name}) => '永久移除“${name}”，包括所有会话和已存储的历史记录（清空 JSONL）。此操作无法撤销。';
	@override String get deleteProjectTitle => '删除项目？';
	@override String get destinationPath => '目标路径';
	@override String get destinationPathRequired => '目标路径为必填项';
	@override String get displayNameOptional => '显示名称（可选）';
	@override String get failedToLoadTokens => '加载 GitHub 令牌失败';
	@override String get githubTokenOptional => 'GitHub 令牌（可选）';
	@override String get newer => '较新';
	@override String get older => '较早';
	@override String get projectArchived => '项目已归档';
	@override String get projectDeleted => '项目已删除';
	@override String get projectRenamed => '项目已重命名';
	@override String get projectRestored => '项目已恢复';
	@override String get repoUrlPlaceholder => 'https://github.com/org/repo.git';
	@override String get repositoryCloned => '仓库已克隆';
	@override String get repositoryUrlRequired => '仓库 URL 为必填项';
	@override String get restore => '恢复';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 个会话',
		other: '${count} 个会话',
	);
	@override String get unknown => '未知';
	@override String usingStoredToken({required Object name}) => '使用已保存的令牌：${name}';
}

// Path: sessions
class Translations$sessions$zh_CN extends Translations$sessions$en {
	Translations$sessions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$sessions$activity$zh_CN activity = Translations$sessions$activity$zh_CN.internal(_root);
	@override late final Translations$sessions$age$zh_CN age = Translations$sessions$age$zh_CN.internal(_root);
	@override String get archive => '归档';
	@override String get archivedSessions => '已归档的会话';
	@override String get autoOrchestrator => '自动（编排器）';
	@override String get compareWith => '与之比较…';
	@override String createFailed({required Object error}) => '创建会话失败：${error}';
	@override String deleteSessionMessage({required Object name}) => '移除“${name}”及其记录。此操作无法撤销。';
	@override String get newSessionProvider => '新会话 — 提供商';
	@override String get noRecentSessions => '没有最近的会话';
	@override String get noSessions => '没有会话';
	@override String get projectPath => '项目路径';
	@override String get rename => '重命名';
	@override late final Translations$sessions$toasts$zh_CN toasts = Translations$sessions$toasts$zh_CN.internal(_root);
}

// Path: git
class Translations$git$zh_CN extends Translations$git$en {
	Translations$git$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get aiButton => '✦ AI';
	@override late final Translations$git$checkpoints$zh_CN checkpoints = Translations$git$checkpoints$zh_CN.internal(_root);
	@override String get commitCreated => '提交已创建';
	@override String get commitMessage => '提交消息';
	@override String get deleteFile => '删除文件';
	@override String get hunkStage => '+ 区块';
	@override String get hunkUnstage => '− 区块';
	@override String get largeDiff => '大型差异预览：为保证标签页响应流畅，渲染已受限。';
	@override String loadDiffFailed({required Object error}) => '加载差异失败：${error}';
	@override String get noBranch => '无分支';
	@override String get noDiff => '没有可用的差异';
	@override String get selectProject => '选择项目';
	@override String get splitDiff => '并排差异';
	@override String get stageHunk => '暂存区块';
	@override String get stagedChanges => '已暂存的更改';
	@override String get statusStaged => '已暂存';
	@override String get switchBranch => '切换分支';
	@override String get unifiedDiff => '统一差异';
	@override String get unstageHunk => '取消暂存区块';
}

// Path: kanban
class Translations$kanban$zh_CN extends Translations$kanban$en {
	Translations$kanban$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$kanban$card$zh_CN card = Translations$kanban$card$zh_CN.internal(_root);
	@override late final Translations$kanban$comments$zh_CN comments = Translations$kanban$comments$zh_CN.internal(_root);
	@override late final Translations$kanban$details$zh_CN details = Translations$kanban$details$zh_CN.internal(_root);
	@override late final Translations$kanban$dialog$zh_CN dialog = Translations$kanban$dialog$zh_CN.internal(_root);
	@override late final Translations$kanban$empty$zh_CN empty = Translations$kanban$empty$zh_CN.internal(_root);
	@override String get saveFailed => '保存卡片失败';
	@override late final Translations$kanban$time$zh_CN time = Translations$kanban$time$zh_CN.internal(_root);
}

// Path: onboarding
class Translations$onboarding$zh_CN extends Translations$onboarding$en {
	Translations$onboarding$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$onboarding$agents$zh_CN agents = Translations$onboarding$agents$zh_CN.internal(_root);
	@override String get completeSetup => '完成设置';
	@override late final Translations$onboarding$errors$zh_CN errors = Translations$onboarding$errors$zh_CN.internal(_root);
	@override String get gitHint => '用于 ddagent 会话创建的提交。';
	@override late final Translations$onboarding$mcp$zh_CN mcp = Translations$onboarding$mcp$zh_CN.internal(_root);
}

// Path: fileTree
class Translations$fileTree$zh_CN extends Translations$fileTree$en {
	Translations$fileTree$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get browseServerFilesystem => '浏览服务器文件系统';
	@override String get chooseFolder => '选择文件夹';
	@override String get copyContents => '复制内容';
	@override String get noFiles => '没有文件';
	@override late final Translations$fileTree$search$zh_CN search = Translations$fileTree$search$zh_CN.internal(_root);
	@override late final Translations$fileTree$titles$zh_CN titles = Translations$fileTree$titles$zh_CN.internal(_root);
	@override String get uploadHere => '上传到此处';
	@override String get uploadTo => '上传到';
	@override String uploadedCount({required Object count}) => '已上传 ${count} 个文件';
	@override String get newName => '新名称';
	@override String notRegisteredProject({required Object path}) => '不是已注册的项目：${path}';
	@override String get showGitignoredFiles => '显示被 gitignore 忽略的文件';
	@override String get hideGitignoredFiles => '隐藏被 gitignore 忽略的文件';
	@override String get downloadUnsupportedOnWeb => '网页端不支持下载';
	@override String get saveToPath => '保存到路径';
	@override String savedTo({required Object path}) => '已保存到 ${path}';
}

// Path: workspace
class Translations$workspace$zh_CN extends Translations$workspace$en {
	Translations$workspace$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get archivedWorkspaceName => '已归档';
	@override String get closePane => '关闭窗格';
	@override String get closeSearch => '关闭搜索';
	@override String get deleteSessionNotice => '移除会话及其记录。此操作无法撤销。';
	@override String get exportChat => '导出聊天';
	@override String get jumpToSession => '跳转到会话…';
	@override String get newChatProvider => '新聊天 — 提供商';
	@override String get nextMatch => '下一个匹配项';
	@override String get previousMatch => '上一个匹配项';
	@override String get searchTranscript => '搜索记录';
	@override String sendTo({required Object count}) => '发送到 ${count}';
	@override String accountWithLabel({required Object label}) => '默认 · ${label}';
	@override String get finishRunBeforeChangingWorkspace => '请先结束运行再更改工作区';
	@override String get restored => '工作区已恢复';
	@override String get maximizePane => '最大化窗格';
	@override String get restorePanes => '恢复窗格';
	@override String get reviewChangedFiles => '查看更改的文件';
}

// Path: auth.login
class Translations$auth$login$zh_CN extends Translations$auth$login$en {
	Translations$auth$login$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '欢迎回来';
	@override String get description => '登录您的 ddagent 账户';
	@override String get username => '用户名';
	@override String get password => '密码';
	@override String get submit => '登录';
	@override String get loading => '登录中...';
	@override late final Translations$auth$login$errors$zh_CN errors = Translations$auth$login$errors$zh_CN.internal(_root);
	@override late final Translations$auth$login$placeholders$zh_CN placeholders = Translations$auth$login$placeholders$zh_CN.internal(_root);
}

// Path: auth.register
class Translations$auth$register$zh_CN extends Translations$auth$register$en {
	Translations$auth$register$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '创建账户';
	@override String get username => '用户名';
	@override String get password => '密码';
	@override String get confirmPassword => '确认密码';
	@override String get submit => '创建账户';
	@override String get loading => '创建账户中...';
	@override late final Translations$auth$register$errors$zh_CN errors = Translations$auth$register$errors$zh_CN.internal(_root);
}

// Path: auth.logout
class Translations$auth$logout$zh_CN extends Translations$auth$logout$en {
	Translations$auth$logout$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '退出登录';
	@override String get confirm => '确定要退出登录吗？';
	@override String get button => '退出登录';
}

// Path: chat.codeBlock
class Translations$chat$codeBlock$zh_CN extends Translations$chat$codeBlock$en {
	Translations$chat$codeBlock$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get copy => '复制';
	@override String get copied => '已复制';
	@override String get copyCode => '复制代码';
}

// Path: chat.copyMessage
class Translations$chat$copyMessage$zh_CN extends Translations$chat$copyMessage$en {
	Translations$chat$copyMessage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get copy => '复制消息';
	@override String get copied => '消息已复制';
	@override String get failed => '复制失败';
	@override String get selectFormat => '选择复制格式';
	@override String get copyAsMarkdown => '复制为 Markdown';
	@override String get copyAsText => '复制为纯文本';
	@override String get markdownShort => 'MD';
	@override String get textShort => 'TXT';
}

// Path: chat.messageTypes
class Translations$chat$messageTypes$zh_CN extends Translations$chat$messageTypes$en {
	Translations$chat$messageTypes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get user => 'U';
	@override String get error => '错误';
	@override String get tool => '工具';
	@override String get claude => 'Claude';
	@override String get cursor => 'Cursor';
	@override String get codex => 'Codex';
	@override String get opencode => 'OpenCode';
	@override String get devin => 'Devin';
}

// Path: chat.tools
class Translations$chat$tools$zh_CN extends Translations$chat$tools$en {
	Translations$chat$tools$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get settings => '工具设置';
	@override String get error => '工具错误';
	@override String get result => '工具结果';
	@override String get viewParams => '查看输入参数';
	@override String get viewRawParams => '查看原始参数';
	@override String get viewDiff => '查看编辑差异';
	@override String get creatingFile => '创建新文件：';
	@override String get updatingTodo => '更新待办事项';
	@override String get read => '读取';
	@override String get readFile => '读取文件';
	@override String get updateTodo => '更新待办列表';
	@override String get readTodo => '读取待办列表';
	@override String get searchResults => '结果';
	@override String get todoReadLabel => 'TodoRead 读取列表';
}

// Path: chat.search
class Translations$chat$search$zh_CN extends Translations$chat$search$en {
	Translations$chat$search$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String found({required Object count, required Object type}) => '找到 ${count} 个${type}';
	@override String get file => '文件';
	@override String get files => '文件';
	@override String get pattern => '模式：';
	@override String get kIn => '在：';
}

// Path: chat.fileOperations
class Translations$chat$fileOperations$zh_CN extends Translations$chat$fileOperations$en {
	Translations$chat$fileOperations$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get updated => '文件更新成功';
	@override String get created => '文件创建成功';
	@override String get written => '文件写入成功';
	@override String get diff => '差异';
	@override String get newFile => '新文件';
	@override String get viewContent => '查看文件内容';
	@override String viewFullOutput({required Object count}) => '查看完整输出（${count} 个字符）';
	@override String get contentDisplayed => '文件内容显示在上面的差异视图中';
}

// Path: chat.interactive
class Translations$chat$interactive$zh_CN extends Translations$chat$interactive$en {
	Translations$chat$interactive$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '交互式提示';
	@override String get waiting => '等待您在 CLI 中响应';
	@override String get instruction => '请在 Claude 运行的终端中选择一个选项。';
	@override String selectedOption({required Object number}) => '✓ Claude 选择了选项 ${number}';
	@override String get instructionDetail => '在 CLI 中，您可以使用方向键或输入数字来交互式地选择此选项。';
}

// Path: chat.thinking
class Translations$chat$thinking$zh_CN extends Translations$chat$thinking$en {
	Translations$chat$thinking$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '思考中...';
	@override String get emoji => '💭 思考中...';
}

// Path: chat.json
class Translations$chat$json$zh_CN extends Translations$chat$json$en {
	Translations$chat$json$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get response => 'JSON 响应';
}

// Path: chat.permissions
class Translations$chat$permissions$zh_CN extends Translations$chat$permissions$en {
	Translations$chat$permissions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String grant({required Object tool}) => '授予 ${tool} 权限';
	@override String get added => '权限已添加';
	@override String addTo({required Object entry}) => '将 ${entry} 添加到允许的工具。';
	@override String get retry => '权限已保存。重试请求以使用该工具。';
	@override String get error => '无法更新权限。请重试。';
	@override String get openSettings => '打开设置';
	@override String get allow => '允许';
	@override String allowAll({required Object count}) => '全部允许（${count}）';
	@override String get allowWithChanges => '按修改允许';
	@override String get always => '始终';
	@override String get deny => '拒绝';
	@override String get editAndAllow => '编辑并允许';
	@override String get editInput => '编辑输入';
	@override String get invalidJson => '无效的 JSON';
	@override String get reject => '驳回';
}

// Path: chat.todo
class Translations$chat$todo$zh_CN extends Translations$chat$todo$en {
	Translations$chat$todo$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get updated => '待办列表已成功更新';
	@override String get current => '当前待办列表';
}

// Path: chat.plan
class Translations$chat$plan$zh_CN extends Translations$chat$plan$en {
	Translations$chat$plan$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get viewPlan => '📋 查看实施计划';
	@override String get title => '实施计划';
}

// Path: chat.usageLimit
class Translations$chat$usageLimit$zh_CN extends Translations$chat$usageLimit$en {
	Translations$chat$usageLimit$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String resetAt({required Object time, required Object timezone, required Object date}) => 'Claude 使用限制已达到。您的限制将在 **${time} ${timezone}** - ${date} 重置';
}

// Path: chat.codex
class Translations$chat$codex$zh_CN extends Translations$chat$codex$en {
	Translations$chat$codex$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => '权限模式';
	@override late final Translations$chat$codex$modes$zh_CN modes = Translations$chat$codex$modes$zh_CN.internal(_root);
	@override late final Translations$chat$codex$descriptions$zh_CN descriptions = Translations$chat$codex$descriptions$zh_CN.internal(_root);
	@override String get technicalDetails => '技术细节';
}

// Path: chat.input
class Translations$chat$input$zh_CN extends Translations$chat$input$en {
	Translations$chat$input$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String placeholder({required Object provider}) => '输入 / 调用命令，@ 选择文件，或向 ${provider} 提问...';
	@override String get placeholderDefault => '输入您的消息...';
	@override String get disabled => '输入已禁用';
	@override String get attachFiles => '附加文件';
	@override String get attachImages => '附加图片';
	@override String get send => '发送';
	@override String get stop => '停止';
	@override late final Translations$chat$input$hintText$zh_CN hintText = Translations$chat$input$hintText$zh_CN.internal(_root);
	@override String get clickToChangeMode => '点击更改权限模式';
	@override String get showAllCommands => '显示所有命令';
	@override String get clearInput => '清空输入';
	@override String get scrollToBottom => '滚动到底部';
	@override late final Translations$chat$input$queue$zh_CN queue = Translations$chat$input$queue$zh_CN.internal(_root);
	@override String get attachFilesDesc => '上传照片、文件或文档';
	@override String get takePhoto => '拍摄照片';
	@override String get takePhotoDesc => '使用相机拍摄照片';
	@override String get moreTools => '更多工具';
	@override String get commandsDesc => '浏览快捷键和命令';
	@override String get clearInputDesc => '丢弃当前文本';
	@override String get newMessage => '新消息';
	@override String get newMessages => '新消息';
	@override String get autoContinueTasks => '自动继续';
	@override String get autoContinueTasksTooltip => '启用后让 Devin 自动继续下一个 Task Master 任务';
	@override late final Translations$chat$input$offlineQueue$zh_CN offlineQueue = Translations$chat$input$offlineQueue$zh_CN.internal(_root);
	@override String cameraUnavailable({required Object error}) => '相机不可用：${error}';
}

// Path: chat.providerSelection
class Translations$chat$providerSelection$zh_CN extends Translations$chat$providerSelection$en {
	Translations$chat$providerSelection$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '选择您的 AI 助手';
	@override String get description => '选择一个供应商以开始新对话';
	@override String get selectModel => '选择模型';
	@override late final Translations$chat$providerSelection$providerInfo$zh_CN providerInfo = Translations$chat$providerSelection$providerInfo$zh_CN.internal(_root);
	@override late final Translations$chat$providerSelection$readyPrompt$zh_CN readyPrompt = Translations$chat$providerSelection$readyPrompt$zh_CN.internal(_root);
	@override String pressToSearch({required Object shortcut}) => '按 <kbd>${shortcut}</kbd> 搜索会话、文件和提交';
	@override String get workspace => '工作区';
	@override String get noWorkspace => '无';
	@override String get clickToChangeWorkspace => '点击更改工作区';
	@override String get chooseWorkspace => '选择工作区';
	@override String get searchWorkspaces => '搜索工作区...';
	@override String get noWorkspacesFound => '未找到工作区。';
	@override String get all => '全部';
	@override String get free => '免费';
	@override String get noModelsFound => '未找到模型。';
	@override String get paid => '付费';
	@override String get searchModels => '搜索模型...';
	@override String get addModel => '添加模型';
	@override String get chooseModel => '选择模型';
	@override String get chooseModelDescription => '内置和自定义模型在一个列表中';
	@override String get clickToChange => '点击更改模型';
	@override String get favorites => '收藏';
	@override String get loadingModels => '正在加载模型…';
	@override String get manageModels => '管理模型';
	@override String get refresh => '刷新模型';
}

// Path: chat.session
class Translations$chat$session$zh_CN extends Translations$chat$session$en {
	Translations$chat$session$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$session$kContinue$zh_CN kContinue = Translations$chat$session$kContinue$zh_CN.internal(_root);
	@override late final Translations$chat$session$loading$zh_CN loading = Translations$chat$session$loading$zh_CN.internal(_root);
	@override late final Translations$chat$session$messages$zh_CN messages = Translations$chat$session$messages$zh_CN.internal(_root);
	@override String get deleteConfirm => '移除会话及其记录。此操作无法撤销。';
	@override String get finishRunBeforeWorkspaceChange => '请先结束运行再更改工作区';
}

// Path: chat.shell
class Translations$chat$shell$zh_CN extends Translations$chat$shell$en {
	Translations$chat$shell$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$shell$selectProject$zh_CN selectProject = Translations$chat$shell$selectProject$zh_CN.internal(_root);
	@override late final Translations$chat$shell$status$zh_CN status = Translations$chat$shell$status$zh_CN.internal(_root);
	@override late final Translations$chat$shell$actions$zh_CN actions = Translations$chat$shell$actions$zh_CN.internal(_root);
	@override String get loading => '正在加载终端...';
	@override String get connecting => '正在连接到 Shell...';
	@override String get startSession => '启动新的 Claude 会话';
	@override String resumeSession({required Object displayName}) => '恢复会话：${displayName}...';
	@override String runCommand({required Object projectName, required Object command}) => '在 ${projectName} 中运行 ${command}';
	@override String startCli({required Object projectName}) => '在 ${projectName} 中启动 Claude CLI';
	@override String get defaultCommand => '命令';
}

// Path: chat.claudeStatus
class Translations$chat$claudeStatus$zh_CN extends Translations$chat$claudeStatus$en {
	Translations$chat$claudeStatus$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$claudeStatus$actions$zh_CN actions = Translations$chat$claudeStatus$actions$zh_CN.internal(_root);
	@override late final Translations$chat$claudeStatus$state$zh_CN state = Translations$chat$claudeStatus$state$zh_CN.internal(_root);
	@override late final Translations$chat$claudeStatus$elapsed$zh_CN elapsed = Translations$chat$claudeStatus$elapsed$zh_CN.internal(_root);
	@override String get stop => '停止';
	@override late final Translations$chat$claudeStatus$controls$zh_CN controls = Translations$chat$claudeStatus$controls$zh_CN.internal(_root);
	@override late final Translations$chat$claudeStatus$providers$zh_CN providers = Translations$chat$claudeStatus$providers$zh_CN.internal(_root);
}

// Path: chat.projectSelection
class Translations$chat$projectSelection$zh_CN extends Translations$chat$projectSelection$en {
	Translations$chat$projectSelection$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String startChatWithProvider({required Object provider}) => '选择一个项目以开始与 ${provider} 聊天';
}

// Path: chat.tasks
class Translations$chat$tasks$zh_CN extends Translations$chat$tasks$en {
	Translations$chat$tasks$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get nextTaskPrompt => '开始下一个任务';
}

// Path: chat.voice
class Translations$chat$voice$zh_CN extends Translations$chat$voice$en {
	Translations$chat$voice$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get autoRead => '朗读回复';
	@override String get autoReadOn => '朗读回复：开';
	@override String get autoReadOff => '朗读回复：关';
	@override String get autoReadVoice => '朗读声音';
	@override String get autoReadVoiceAuto => '自动声音';
	@override String get autoReadPreview => '回复将以此声音朗读。';
	@override String get speakMessage => '朗读';
	@override String get stopSpeaking => '停止朗读';
}

// Path: chat.composer
class Translations$chat$composer$zh_CN extends Translations$chat$composer$en {
	Translations$chat$composer$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get toolsAndActions => '工具与操作';
	@override String get toolsAndActionsDesc => '聊天输入框的工具和控件';
	@override String get reasoning => '推理';
	@override String get model => '模型';
	@override String get effortDefault => '默认';
	@override String get loadingModels => '正在加载模型…';
	@override String get modelMenu => '选择模型和推理强度';
	@override String permissionHeading({required Object provider}) => '应如何批准 ${provider} 的操作？';
	@override String get favorites => '收藏';
}

// Path: chat.splitSession
class Translations$chat$splitSession$zh_CN extends Translations$chat$splitSession$en {
	Translations$chat$splitSession$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get toggle => '分屏会话';
	@override String get close => '关闭分屏会话';
	@override String get selectSession => '选择要比较的会话';
	@override String get noOtherSessions => '没有其他可用会话';
	@override String get newSessionOption => '+ 在分屏视图中新建会话';
	@override String currentProjectGroup({required Object name}) => '当前项目（${name}）';
	@override String get otherProjectsGroup => '其他项目';
	@override String get recentSessionsGroup => '最近会话';
	@override String get startNewSession => '在分屏视图中开始新会话';
	@override String get selectFromList => '从现有会话列表中选择会话';
}

// Path: chat.sessionPicker
class Translations$chat$sessionPicker$zh_CN extends Translations$chat$sessionPicker$en {
	Translations$chat$sessionPicker$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '选择会话';
	@override String get searchPlaceholder => '搜索会话...';
	@override String get clearSearch => '清除搜索';
	@override String get newChat => '+ 新聊天';
	@override String get archivedToggle => '已归档';
	@override String get changeSession => '更改会话';
	@override String get archivedLoading => '正在加载已归档的会话...';
	@override String get archivedError => '无法加载已归档的会话';
	@override String get archivedEmpty => '没有已归档的会话';
	@override String get archivedProjectOnly => '工作区已归档 — 恢复它以查看其会话。';
	@override String get emptySearch => '没有会话匹配你的搜索';
	@override String get restore => '恢复';
	@override String get restoreSession => '恢复会话';
	@override String get restoreProject => '恢复工作区';
	@override String get restoreSessionFailed => '恢复会话失败。请重试。';
	@override String get restoreProjectFailed => '恢复工作区失败。请重试。';
	@override String get archiveFailed => '归档会话失败。请重试。';
	@override String get deleteFailed => '删除会话失败。请重试。';
	@override String get running => '会话正在运行';
	@override String get unread => '未读 — 已完成并有新输出';
}

// Path: chat.splitWorkspace
class Translations$chat$splitWorkspace$zh_CN extends Translations$chat$splitWorkspace$en {
	Translations$chat$splitWorkspace$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get addChat => '添加聊天窗格';
	@override String get addBrowser => '添加浏览器窗格';
	@override String get addTerminal => '添加终端窗格';
	@override String get overview => '显示所有窗格';
	@override String get exitFocusMode => '退出专注模式 (Ctrl+Shift+F)';
	@override String get focusMode => '专注模式 (Ctrl+Shift+F)';
	@override String get browseSessions => '打开会话列表';
}

// Path: chat.splitOverview
class Translations$chat$splitOverview$zh_CN extends Translations$chat$splitOverview$en {
	Translations$chat$splitOverview$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '分屏窗格概览';
	@override String count({required Object count}) => '${count} 个窗格';
	@override String get close => '关闭概览';
	@override String get question => '问题 — 需要输入';
	@override String get processing => '处理中';
	@override String get idle => '空闲';
	@override String get active => '活跃';
}

// Path: chat.askUserQuestion
class Translations$chat$askUserQuestion$zh_CN extends Translations$chat$askUserQuestion$en {
	Translations$chat$askUserQuestion$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String needsInput({required Object provider}) => '${provider} 需要你的输入';
	@override String get answerHint => '输入你的答案…';
	@override String get other => '其他…';
	@override String get skip => '跳过';
}

// Path: chat.attachments
class Translations$chat$attachments$zh_CN extends Translations$chat$attachments$en {
	Translations$chat$attachments$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get downloadFailedRetry => '下载失败 — 点击重试';
	@override String get fileAttachment => '文件附件';
	@override String download({required Object name}) => '下载 ${name}';
}

// Path: chat.checkpoint
class Translations$chat$checkpoint$zh_CN extends Translations$chat$checkpoint$en {
	Translations$chat$checkpoint$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get creating => '正在创建快照…';
	@override String get revertChanges => '将文件还原到上一个检查点';
	@override String get undo => '撤销检查点';
	@override String get beforeAiTurn => 'AI 回合之前';
}

// Path: chat.common
class Translations$chat$common$zh_CN extends Translations$chat$common$en {
	Translations$chat$common$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get close => '关闭';
}

// Path: chat.taskMaster
class Translations$chat$taskMaster$zh_CN extends Translations$chat$taskMaster$en {
	Translations$chat$taskMaster$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get saveToTask => '任务';
	@override String get saved => '已保存';
	@override String get saving => '正在保存...';
	@override String get taskShort => '任务';
	@override String get addToTask => '添加到 TaskMaster';
	@override String get added => '已添加到 TaskMaster';
}

// Path: chat.tokenUsage
class Translations$chat$tokenUsage$zh_CN extends Translations$chat$tokenUsage$en {
	Translations$chat$tokenUsage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get desc => '查看会话令牌消耗';
	@override String get title => '令牌用量';
}

// Path: chat.tool
class Translations$chat$tool$zh_CN extends Translations$chat$tool$en {
	Translations$chat$tool$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get emptyResult => '（暂无输出 — 工具返回了空结果）';
}

// Path: chat.quotaBadge
class Translations$chat$quotaBadge$zh_CN extends Translations$chat$quotaBadge$en {
	Translations$chat$quotaBadge$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get ariaLabel => '订阅额度限制';
	@override String get noData => '此模型暂无订阅数据';
}

// Path: chat.paneHeader
class Translations$chat$paneHeader$zh_CN extends Translations$chat$paneHeader$en {
	Translations$chat$paneHeader$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get processing => '处理中…';
	@override String get switchSession => '切换会话';
}

// Path: chat.broadcast
class Translations$chat$broadcast$zh_CN extends Translations$chat$broadcast$en {
	Translations$chat$broadcast$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get selectOrchestrators => '选择编排器';
	@override String get orchestratorsOnly => '仅编排器';
	@override String get noOrchestrators => '没有可用的编排器会话';
}

// Path: chat.changes
class Translations$chat$changes$zh_CN extends Translations$chat$changes$en {
	Translations$chat$changes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get empty => '没有文件更改';
	@override String get failedToLoad => '加载更改失败';
}

// Path: chat.commandResult
class Translations$chat$commandResult$zh_CN extends Translations$chat$commandResult$en {
	Translations$chat$commandResult$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$chat$commandResult$fallback$zh_CN fallback = Translations$chat$commandResult$fallback$zh_CN.internal(_root);
	@override String get filterCommands => '筛选命令...';
	@override String searchModels({required Object provider}) => '搜索 ${provider} 模型...';
}

// Path: chat.commands
class Translations$chat$commands$zh_CN extends Translations$chat$commands$en {
	Translations$chat$commands$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get runConfirmTitle => '运行命令？';
	@override String get executionCancelled => '命令执行已取消';
}

// Path: chat.export
class Translations$chat$export$zh_CN extends Translations$chat$export$en {
	Translations$chat$export$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String sessionTitle({required Object id}) => '会话 ${id}';
	@override String get pdfFailed => 'PDF 导出失败';
	@override String get transcriptDownloaded => '会话记录已下载';
	@override String savedTo({required Object path}) => '已保存 ${path}';
}

// Path: chat.message
class Translations$chat$message$zh_CN extends Translations$chat$message$en {
	Translations$chat$message$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get compactedSummary => '压缩摘要';
	@override String get rawView => '原始视图';
	@override String get resendHint => '从输入框重新发送';
}

// Path: chat.modelLibrary
class Translations$chat$modelLibrary$zh_CN extends Translations$chat$modelLibrary$en {
	Translations$chat$modelLibrary$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String deleteTooltip({required Object name}) => '删除 ${name}';
	@override String editTooltip({required Object name}) => '编辑 ${name}';
	@override String get enterNameAndId => '请输入模型名称和模型 ID。';
	@override String get idNoSpaces => '模型 ID 不能包含空格。';
	@override String get setAsDefault => '设为默认';
	@override String get defaultModel => '默认模型';
}

// Path: chat.pinFile
class Translations$chat$pinFile$zh_CN extends Translations$chat$pinFile$en {
	Translations$chat$pinFile$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get action => '固定';
	@override String get pathHint => 'path/to/file.ext';
	@override String get title => '固定文件';
}

// Path: chat.permissionRequest
class Translations$chat$permissionRequest$zh_CN extends Translations$chat$permissionRequest$en {
	Translations$chat$permissionRequest$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object tool}) => '权限请求 · ${tool}';
	@override String get question => '问题';
}

// Path: codeEditor.toolbar
class Translations$codeEditor$toolbar$zh_CN extends Translations$codeEditor$toolbar$en {
	Translations$codeEditor$toolbar$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get changes => '个更改';
	@override String get previousChange => '上一个更改';
	@override String get nextChange => '下一个更改';
	@override String get hideDiff => '隐藏差异高亮';
	@override String get showDiff => '显示差异高亮';
	@override String get settings => '编辑器设置';
	@override String get collapse => '折叠编辑器';
	@override String get expand => '展开编辑器到全宽';
	@override String get diffMerge => '差异 / 合并';
	@override String get previewInBrowser => '在浏览器中预览';
	@override String get reload => '从磁盘重新加载';
	@override String get toggleDock => '切换文件停靠栏';
}

// Path: codeEditor.header
class Translations$codeEditor$header$zh_CN extends Translations$codeEditor$header$en {
	Translations$codeEditor$header$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get showingChanges => '显示更改';
}

// Path: codeEditor.actions
class Translations$codeEditor$actions$zh_CN extends Translations$codeEditor$actions$en {
	Translations$codeEditor$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get copyPath => '复制文件路径';
	@override String get pathCopied => '文件路径已复制';
	@override String get download => '下载文件';
	@override String get save => '保存';
	@override String get saving => '保存中...';
	@override String get saved => '已保存！';
	@override String get exitFullscreen => '退出全屏';
	@override String get fullscreen => '全屏';
	@override String get close => '关闭';
	@override String get previewMarkdown => '预览 Markdown';
	@override String get editMarkdown => '编辑 Markdown';
	@override String get pinFile => '将文件固定到上下文';
	@override String get unpinFile => '从上下文取消固定文件';
	@override String get previewHtml => '在新标签页中打开 HTML 预览';
	@override String get retry => '重试';
	@override String get saveAll => '全部保存';
}

// Path: codeEditor.footer
class Translations$codeEditor$footer$zh_CN extends Translations$codeEditor$footer$en {
	Translations$codeEditor$footer$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get lines => '行数：';
	@override String get characters => '字符数：';
	@override String get shortcuts => '按 Ctrl+S 保存 • Esc 关闭';
}

// Path: codeEditor.binaryFile
class Translations$codeEditor$binaryFile$zh_CN extends Translations$codeEditor$binaryFile$en {
	Translations$codeEditor$binaryFile$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '二进制文件';
	@override String message({required Object fileName}) => '文件 "${fileName}" 无法在文本编辑器中显示，因为它是二进制文件。';
	@override String get cannotDisplayAsText => '无法以文本形式显示';
}

// Path: codeEditor.filePreview
class Translations$codeEditor$filePreview$zh_CN extends Translations$codeEditor$filePreview$en {
	Translations$codeEditor$filePreview$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载预览...';
	@override String get error => '无法显示此文件。';
	@override String get openInNewTab => '在新标签页中打开';
}

// Path: codeEditor.diff
class Translations$codeEditor$diff$zh_CN extends Translations$codeEditor$diff$en {
	Translations$codeEditor$diff$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get applyMerge => '应用合并';
	@override String get base => '基准';
	@override String get close => '关闭差异';
	@override String get current => '当前';
	@override String hunk({required Object number}) => '区块 ${number}';
	@override String get noChanges => '没有更改';
	@override String get deletedOnDisk => '已在磁盘上删除';
}

// Path: codeEditor.emptyState
class Translations$codeEditor$emptyState$zh_CN extends Translations$codeEditor$emptyState$en {
	Translations$codeEditor$emptyState$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '没有打开的文件';
}

// Path: codeEditor.hexDump
class Translations$codeEditor$hexDump$zh_CN extends Translations$codeEditor$hexDump$en {
	Translations$codeEditor$hexDump$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String more({required Object size}) => '… 还有 ${size}';
}

// Path: codeEditor.mediaFile
class Translations$codeEditor$mediaFile$zh_CN extends Translations$codeEditor$mediaFile$en {
	Translations$codeEditor$mediaFile$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => '暂不支持音频/视频预览';
	@override String get title => '媒体文件';
}

// Path: codeEditor.settings
class Translations$codeEditor$settings$zh_CN extends Translations$codeEditor$settings$en {
	Translations$codeEditor$settings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String fontSizeDecrease({required Object size}) => '字体大小 −  （当前 ${size}）';
	@override String get fontSizeIncrease => '字体大小 +';
	@override String get minimap => '缩略图';
	@override String tabSize({required Object size}) => 'Tab 大小：${size}';
}

// Path: codeEditor.toasts
class Translations$codeEditor$toasts$zh_CN extends Translations$codeEditor$toasts$en {
	Translations$codeEditor$toasts$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String savedFile({required Object name}) => '已保存 ${name}';
	@override String get saveFailed => '保存失败';
	@override String get allSaved => '全部已保存';
	@override String get someSavesFailed => '部分保存失败';
	@override String savedTo({required Object path}) => '已保存到 ${path}';
	@override String get mergeApplied => '已应用合并 — 保存以保留更改';
}

// Path: common.buttons
class Translations$common$buttons$zh_CN extends Translations$common$buttons$en {
	Translations$common$buttons$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get save => '保存';
	@override String get cancel => '取消';
	@override String get delete => '删除';
	@override String get create => '创建';
	@override String get edit => '编辑';
	@override String get close => '关闭';
	@override String get confirm => '确认';
	@override String get submit => '提交';
	@override String get retry => '重试';
	@override String get refresh => '刷新';
	@override String get search => '搜索';
	@override String get clear => '清除';
	@override String get copy => '复制';
	@override String get download => '下载';
	@override String get upload => '上传';
	@override String get browse => '浏览';
	@override String get openDiagram => '打开图表';
	@override String get update => '更新';
}

// Path: common.tabs
class Translations$common$tabs$zh_CN extends Translations$common$tabs$en {
	Translations$common$tabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get chat => '聊天';
	@override String get shell => '终端';
	@override String get files => '文件';
	@override String get git => '源代码管理';
	@override String get tasks => '任务';
	@override String get browser => '浏览器';
	@override String get computer => '计算机';
	@override String get board => '看板';
	@override String get usage => 'AI Control';
}

// Path: common.status
class Translations$common$status$zh_CN extends Translations$common$status$en {
	Translations$common$status$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '加载中...';
	@override String get success => '成功';
	@override String get error => '错误';
	@override String get failed => '失败';
	@override String get pending => '待处理';
	@override String get completed => '已完成';
	@override String get inProgress => '进行中';
}

// Path: common.messages
class Translations$common$messages$zh_CN extends Translations$common$messages$en {
	Translations$common$messages$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get savedSuccessfully => '保存成功';
	@override String get deletedSuccessfully => '删除成功';
	@override String get updatedSuccessfully => '更新成功';
	@override String get operationFailed => '操作失败';
	@override String get networkError => '网络错误，请检查您的连接。';
	@override String get unauthorized => '未授权，请登录。';
	@override String get notFound => '未找到';
	@override String get invalidInput => '输入无效';
	@override String get requiredField => '此字段为必填项';
	@override String get unknownError => '发生未知错误';
	@override String get renameSessionFailed => '重命名会话失败。请重试。';
}

// Path: common.navigation
class Translations$common$navigation$zh_CN extends Translations$common$navigation$en {
	Translations$common$navigation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get settings => '设置';
	@override String get home => '首页';
	@override String get back => '返回';
	@override String get next => '下一步';
	@override String get previous => '上一步';
	@override String get logout => '退出登录';
}

// Path: common.common
class Translations$common$common$zh_CN extends Translations$common$common$en {
	Translations$common$common$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get language => '语言';
	@override String get theme => '主题';
	@override String get darkMode => '深色模式';
	@override String get lightMode => '浅色模式';
	@override String get name => '名称';
	@override String get description => '描述';
	@override String get enabled => '已启用';
	@override String get disabled => '已禁用';
	@override String get optional => '可选';
	@override String get version => '版本';
	@override String get select => '选择';
	@override String get selectAll => '全选';
	@override String get deselectAll => '取消全选';
	@override String get done => '完成';
	@override String get failed => '失败';
}

// Path: common.time
class Translations$common$time$zh_CN extends Translations$common$time$en {
	Translations$common$time$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get justNow => '刚刚';
	@override String minutesAgo({required Object count}) => '${count} 分钟前';
	@override String hoursAgo({required Object count}) => '${count} 小时前';
	@override String daysAgo({required Object count}) => '${count} 天前';
	@override String get yesterday => '昨天';
}

// Path: common.fileOperations
class Translations$common$fileOperations$zh_CN extends Translations$common$fileOperations$en {
	Translations$common$fileOperations$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get newFile => '新建文件';
	@override String get newFolder => '新建文件夹';
	@override String get rename => '重命名';
	@override String get move => '移动';
	@override String get copyPath => '复制路径';
	@override String get openInEditor => '在编辑器中打开';
}

// Path: common.mainContent
class Translations$common$mainContent$zh_CN extends Translations$common$mainContent$en {
	Translations$common$mainContent$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载 ddagent';
	@override String get settingUpWorkspace => '正在设置您的工作空间...';
	@override String get chooseProject => '选择您的项目';
	@override String get selectProjectDescription => '从侧边栏选择一个项目以开始使用 Claude 进行编程。每个项目包含您的聊天会话和文件历史。';
	@override String get tip => '提示';
	@override String get createProjectMobile => '点击上方的菜单按钮以访问项目';
	@override String get createProjectDesktop => '点击侧边栏中的文件夹图标以创建新项目';
	@override String get newSession => '新会话';
	@override String get untitledSession => '未命名会话';
	@override String get projectFiles => '项目文件';
	@override String get focusMode => '专注模式 (Ctrl+Shift+F)';
	@override String get exitFocusMode => '退出专注模式 (Ctrl+Shift+F)';
	@override String get splitSession => '分屏会话';
	@override String get closeSplitSession => '关闭分屏会话';
	@override String get chooseWorkspace => '选择工作区';
	@override String get chooseWorkspaceDescription => '为此聊天选择一个工作区，或在设置中创建新工作区。';
	@override String get createWorkspace => '在设置中创建工作区';
	@override String get recentProjects => '最近项目';
}

// Path: common.fileTree
class Translations$common$fileTree$zh_CN extends Translations$common$fileTree$en {
	Translations$common$fileTree$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '正在加载文件...';
	@override String get files => '文件';
	@override String get simpleView => '简单视图';
	@override String get compactView => '紧凑视图';
	@override String get detailedView => '详细视图';
	@override String get searchPlaceholder => '搜索文件和文件夹...';
	@override String get clearSearch => '清除搜索';
	@override String get name => '名称';
	@override String get size => '大小';
	@override String get modified => '修改时间';
	@override String get permissions => '权限';
	@override String get noFilesFound => '未找到文件';
	@override String get checkProjectPath => '检查项目路径是否可访问';
	@override String get noMatchesFound => '未找到匹配项';
	@override String get tryDifferentSearch => '尝试不同的搜索词或清除搜索';
	@override String get justNow => '刚刚';
	@override String minAgo({required Object count}) => '${count} 分钟前';
	@override String hoursAgo({required Object count}) => '${count} 小时前';
	@override String daysAgo({required Object count}) => '${count} 天前';
	@override String get newFile => '新建文件 (Cmd+N)';
	@override String get newFolder => '新建文件夹 (Cmd+Shift+N)';
	@override String get refresh => '刷新';
	@override String get collapseAll => '全部折叠';
	@override late final Translations$common$fileTree$context$zh_CN context = Translations$common$fileTree$context$zh_CN.internal(_root);
	@override String get searchContentPlaceholder => '在文件中搜索...';
	@override String get searchInFiles => '在文件中搜索';
	@override String get searchByName => '按名称搜索';
	@override String get loadFailed => '无法加载文件';
	@override String get noSearchResults => '未找到匹配项';
	@override String get searchError => '搜索失败';
	@override String get searching => '正在搜索...';
	@override String resultsTruncated({required Object count}) => '显示前 ${count} 条结果';
	@override String get allWorkspaces => '所有工作区';
	@override late final Translations$common$fileTree$delete$zh_CN delete = Translations$common$fileTree$delete$zh_CN.internal(_root);
	@override String get dropToUpload => '拖放文件以上传';
	@override String dropToUploadTo({required Object folder}) => '拖放文件以上传到“${folder}”';
	@override String get noProject => '请先添加项目';
	@override String get noRecentFiles => '最近 7 天没有文件变更';
	@override String get showAllFiles => '显示所有文件';
	@override String get showAllFilesHint => '关闭最近筛选器以查看全部。';
	@override String get showRecentOnly => '显示最近 7 天变更的文件';
	@override late final Translations$common$fileTree$toast$zh_CN toast = Translations$common$fileTree$toast$zh_CN.internal(_root);
	@override String get uploadComplete => '上传完成';
	@override String get uploadFailed => '上传失败';
	@override String uploadFiles({required Object size}) => '上传文件（每个最大 ${size}）';
	@override String uploadToFolder({required Object folder}) => '上传文件到“${folder}”';
	@override String uploadedCount({required Object total, required Object label, required Object uploaded}) => '已上传 ${total} ${label} 中的 ${uploaded} 个';
	@override String get uploadingFiles => '正在上传文件';
	@override late final Translations$common$fileTree$validation$zh_CN validation = Translations$common$fileTree$validation$zh_CN.internal(_root);
}

// Path: common.projectWizard
class Translations$common$projectWizard$zh_CN extends Translations$common$projectWizard$en {
	Translations$common$projectWizard$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '创建新项目';
	@override late final Translations$common$projectWizard$steps$zh_CN steps = Translations$common$projectWizard$steps$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$step1$zh_CN step1 = Translations$common$projectWizard$step1$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$step2$zh_CN step2 = Translations$common$projectWizard$step2$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$step3$zh_CN step3 = Translations$common$projectWizard$step3$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$buttons$zh_CN buttons = Translations$common$projectWizard$buttons$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$errors$zh_CN errors = Translations$common$projectWizard$errors$zh_CN.internal(_root);
}

// Path: common.notifications
class Translations$common$notifications$zh_CN extends Translations$common$notifications$en {
	Translations$common$notifications$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get genericTool => '工具';
	@override late final Translations$common$notifications$codes$zh_CN codes = Translations$common$notifications$codes$zh_CN.internal(_root);
}

// Path: common.versionUpdate
class Translations$common$versionUpdate$zh_CN extends Translations$common$versionUpdate$en {
	Translations$common$versionUpdate$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '有可用更新';
	@override String get newVersionReady => '新版本已准备就绪';
	@override String get currentVersion => '当前版本';
	@override String get latestVersion => '最新版本';
	@override String get whatsNew => '新内容：';
	@override String get viewFullRelease => '查看完整发布';
	@override String get updateProgress => '更新进度：';
	@override String get manualUpgrade => '手动升级：';
	@override String get npmUpgradeCommand => 'npm install -g @ddagent-ai/ddagent@latest';
	@override String get manualUpgradeHint => '或点击\'立即更新\'以自动运行更新。';
	@override String get updateCompleted => '更新成功完成！';
	@override String get restartServer => '请重启服务器以应用更改。';
	@override String get updateFailed => '更新失败';
	@override late final Translations$common$versionUpdate$buttons$zh_CN buttons = Translations$common$versionUpdate$buttons$zh_CN.internal(_root);
	@override late final Translations$common$versionUpdate$ariaLabels$zh_CN ariaLabels = Translations$common$versionUpdate$ariaLabels$zh_CN.internal(_root);
}

// Path: common.quota
class Translations$common$quota$zh_CN extends Translations$common$quota$en {
	Translations$common$quota$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get controlCenter => 'AI Control Center';
	@override late final Translations$common$quota$section$zh_CN section = Translations$common$quota$section$zh_CN.internal(_root);
	@override late final Translations$common$quota$filter$zh_CN filter = Translations$common$quota$filter$zh_CN.internal(_root);
	@override late final Translations$common$quota$period$zh_CN period = Translations$common$quota$period$zh_CN.internal(_root);
	@override late final Translations$common$quota$group$zh_CN group = Translations$common$quota$group$zh_CN.internal(_root);
	@override late final Translations$common$quota$metric$zh_CN metric = Translations$common$quota$metric$zh_CN.internal(_root);
	@override late final Translations$common$quota$cost$zh_CN cost = Translations$common$quota$cost$zh_CN.internal(_root);
	@override late final Translations$common$quota$cost3$zh_CN cost3 = Translations$common$quota$cost3$zh_CN.internal(_root);
	@override late final Translations$common$quota$overview$zh_CN overview = Translations$common$quota$overview$zh_CN.internal(_root);
	@override late final Translations$common$quota$usage$zh_CN usage = Translations$common$quota$usage$zh_CN.internal(_root);
	@override late final Translations$common$quota$agents$zh_CN agents = Translations$common$quota$agents$zh_CN.internal(_root);
	@override late final Translations$common$quota$agentStatus$zh_CN agentStatus = Translations$common$quota$agentStatus$zh_CN.internal(_root);
	@override late final Translations$common$quota$alert$zh_CN alert = Translations$common$quota$alert$zh_CN.internal(_root);
	@override String get backToChat => '返回聊天';
	@override String get syncNow => '立即同步';
	@override String generatedAt({required Object value}) => '更新于 ${value}';
	@override String get loading => '正在加载账户额度…';
	@override String remaining({required Object value}) => '剩余 ${value}%';
	@override String resetsIn({required Object value}) => '${value} 后重置';
	@override String projected({required Object value}) => '按当前速度，此额度将在 ${value} 后耗尽';
	@override String syncedAgo({required Object value}) => '${value} 前已同步';
	@override String get refreshAccount => '刷新账户';
	@override String get syncFailed => '同步失败';
	@override String get history => '历史';
	@override String historyPoints({required Object value}) => '已记录 ${value} 条读数';
	@override String get historyEmpty => '尚无历史记录';
	@override String get noAgents => '未分配代理';
	@override String get noSubscription => '无订阅';
	@override String get noSubscriptionHint => '提供商未报告此账户有有效套餐。';
	@override late final Translations$common$quota$quality$zh_CN quality = Translations$common$quota$quality$zh_CN.internal(_root);
	@override late final Translations$common$quota$kpi$zh_CN kpi = Translations$common$quota$kpi$zh_CN.internal(_root);
	@override late final Translations$common$quota$empty$zh_CN empty = Translations$common$quota$empty$zh_CN.internal(_root);
	@override late final Translations$common$quota$settings$zh_CN settings = Translations$common$quota$settings$zh_CN.internal(_root);
	@override late final Translations$common$quota$range$zh_CN range = Translations$common$quota$range$zh_CN.internal(_root);
}

// Path: common.actions
class Translations$common$actions$zh_CN extends Translations$common$actions$en {
	Translations$common$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get retry => '重试';
	@override String get save => '保存';
}

// Path: common.browserPane
class Translations$common$browserPane$zh_CN extends Translations$common$browserPane$en {
	Translations$common$browserPane$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get address => '地址';
	@override String get back => '后退';
	@override String get connecting => '正在连接浏览器…';
	@override String get connectionFailed => '浏览器连接失败。';
	@override String couldNotLoad({required Object url}) => '无法加载 ${url}';
	@override String get disconnected => '浏览器视图已断开';
	@override String get enterUrl => '输入 URL';
	@override String get forward => '前进';
	@override String get invalidUrl => '请输入有效的 http(s) URL';
	@override String get noAuthToken => '没有可用的身份验证令牌。';
	@override String get openExternal => '在系统浏览器中打开';
	@override String get reload => '重新加载';
	@override String get retry => '重试';
	@override String get stop => '停止';
}

// Path: common.browserUse
class Translations$common$browserUse$zh_CN extends Translations$common$browserUse$en {
	Translations$common$browserUse$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String activeCount({required Object count}) => '${count} 个活跃';
	@override String get cancel => '取消';
	@override String get close => '关闭';
	@override String get delete => '删除';
	@override String deleteDesc({required Object name}) => '${name} 将被永久删除。';
	@override String get deleteSession => '删除会话';
	@override String get deleteTitle => '删除浏览器会话？';
	@override late final Translations$common$browserUse$empty$zh_CN empty = Translations$common$browserUse$empty$zh_CN.internal(_root);
	@override String get emptyStatus => '空';
	@override late final Translations$common$browserUse$errors$zh_CN errors = Translations$common$browserUse$errors$zh_CN.internal(_root);
	@override String get fullscreen => '全屏';
	@override String get installRuntime => '安装运行时';
	@override String get installing => '正在安装...';
	@override String get lastAction => '最后操作';
	@override String get nextSnapshot => '代理浏览器的下一个快照将显示在这里。';
	@override String get noPageLoaded => '未加载页面';
	@override String get noSessions => '没有代理浏览器会话。';
	@override String get none => '无';
	@override String get openSettings => '打开 Browser 设置';
	@override String get profile => '配置文件';
	@override String get promptLabel => '提示词';
	@override late final Translations$common$browserUse$prompts$zh_CN prompts = Translations$common$browserUse$prompts$zh_CN.internal(_root);
	@override String get refresh => '刷新浏览器会话';
	@override late final Translations$common$browserUse$relative$zh_CN relative = Translations$common$browserUse$relative$zh_CN.internal(_root);
	@override late final Translations$common$browserUse$runtime$zh_CN runtime = Translations$common$browserUse$runtime$zh_CN.internal(_root);
	@override String get runtimeSetup => '需要设置运行时';
	@override String get selected => '已选中';
	@override String get sessionFallback => '浏览器会话';
	@override String get sessionScreenshot => '浏览器会话截图';
	@override String get sessions => '会话';
	@override String get status => '状态';
	@override String get stop => '停止';
	@override String get stopSession => '停止会话';
	@override String get subtitle => '监控 AI 代理打开的浏览器会话。';
	@override String get temporary => '临时';
	@override String get thisSession => '此会话';
	@override String get title => 'Browser';
	@override String totalCount({required Object count}) => '共 ${count} 个';
	@override String updated({required Object time}) => '更新于 ${time}';
	@override String get waiting => '等待中';
	@override String get waitingForScreenshot => '等待截图';
}

// Path: common.commandPalette
class Translations$common$commandPalette$zh_CN extends Translations$common$commandPalette$en {
	Translations$common$commandPalette$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get backToAll => '返回全部';
	@override String get backspaceHint => '按 Backspace 返回';
	@override late final Translations$common$commandPalette$browseAll$zh_CN browseAll = Translations$common$commandPalette$browseAll$zh_CN.internal(_root);
	@override late final Translations$common$commandPalette$compare$zh_CN compare = Translations$common$commandPalette$compare$zh_CN.internal(_root);
	@override late final Translations$common$commandPalette$groups$zh_CN groups = Translations$common$commandPalette$groups$zh_CN.internal(_root);
	@override late final Translations$common$commandPalette$hints$zh_CN hints = Translations$common$commandPalette$hints$zh_CN.internal(_root);
	@override late final Translations$common$commandPalette$items$zh_CN items = Translations$common$commandPalette$items$zh_CN.internal(_root);
	@override late final Translations$common$commandPalette$nav$zh_CN nav = Translations$common$commandPalette$nav$zh_CN.internal(_root);
	@override String get noResults => '没有结果。';
	@override late final Translations$common$commandPalette$pages$zh_CN pages = Translations$common$commandPalette$pages$zh_CN.internal(_root);
	@override String get placeholder => '输入以搜索任何内容…';
	@override String searchPagePlaceholder({required Object page}) => '搜索 ${page}…';
	@override String get title => '命令面板';
}

// Path: common.gitPanel
class Translations$common$gitPanel$zh_CN extends Translations$common$gitPanel$en {
	Translations$common$gitPanel$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String ahead({required Object count}) => '领先 ${count}';
	@override String get aheadLabel => '领先';
	@override String get aiSuggest => 'AI 建议';
	@override String get aiSuggestTitle => '用 AI 生成提交消息';
	@override String get all => '全部';
	@override String get allStaged => '所有更改已暂存';
	@override String behind({required Object count}) => '落后 ${count}';
	@override String get behindLabel => '落后';
	@override late final Translations$common$gitPanel$branches$zh_CN branches = Translations$common$gitPanel$branches$zh_CN.internal(_root);
	@override String get cancel => '取消';
	@override String changesCount({required Object count}) => '更改（${count}）';
	@override String get clearSearch => '清除搜索';
	@override String get collapseDiff => '折叠差异';
	@override String get commit => '提交';
	@override String get commitChanges => '提交更改';
	@override String commitFiles({required Object count}) => '提交 ${count} 个文件';
	@override String get committing => '正在提交...';
	@override late final Translations$common$gitPanel$confirmActions$zh_CN confirmActions = Translations$common$gitPanel$confirmActions$zh_CN.internal(_root);
	@override String confirmCommit({required Object message, required Object count}) => '以消息“${message}”提交 ${count} 个文件？';
	@override String confirmDeleteFile({required Object file}) => '删除未跟踪的文件“${file}”？此操作无法撤销。';
	@override String confirmDiscardFile({required Object file}) => '放弃对“${file}”的所有更改？此操作无法撤销。';
	@override String confirmPublish({required Object branch, required Object remote}) => '将分支“${branch}”发布到 ${remote}？';
	@override String confirmPull({required Object remote, required Object count}) => '从 ${remote} 拉取 ${count} 个提交？';
	@override String confirmPush({required Object count, required Object remote}) => '推送 ${count} 个提交到 ${remote}？';
	@override String get confirmRevert => '还原最新的本地提交？这会删除提交但保留其更改为暂存状态。';
	@override late final Translations$common$gitPanel$confirmTitles$zh_CN confirmTitles = Translations$common$gitPanel$confirmTitles$zh_CN.internal(_root);
	@override String get createBranch => '创建新分支';
	@override String get creating => '正在创建...';
	@override String get delete => '删除';
	@override String get deleteUntracked => '删除未跟踪的文件';
	@override String get deselectAll => '取消全选';
	@override String get discard => '放弃';
	@override String get discardChanges => '放弃更改';
	@override String get dismiss => '关闭';
	@override String get dismissError => '关闭错误';
	@override late final Translations$common$gitPanel$errors$zh_CN errors = Translations$common$gitPanel$errors$zh_CN.internal(_root);
	@override String get expandDiff => '展开差异';
	@override String get fetch => '获取';
	@override String fetchTitle({required Object remote}) => '从 ${remote} 获取';
	@override String get fetching => '正在获取…';
	@override String filesSelected({required Object count}) => '已选择 ${count} 个文件';
	@override String get generating => '正在生成...';
	@override late final Translations$common$gitPanel$history$zh_CN history = Translations$common$gitPanel$history$zh_CN.internal(_root);
	@override late final Translations$common$gitPanel$mergeWorktree$zh_CN mergeWorktree = Translations$common$gitPanel$mergeWorktree$zh_CN.internal(_root);
	@override String get merging => '正在合并...';
	@override String get messagePlaceholder => '消息（Ctrl+Enter 提交）';
	@override late final Translations$common$gitPanel$newBranch$zh_CN newBranch = Translations$common$gitPanel$newBranch$zh_CN.internal(_root);
	@override late final Translations$common$gitPanel$newWorktree$zh_CN newWorktree = Translations$common$gitPanel$newWorktree$zh_CN.internal(_root);
	@override String get noChanges => '未检测到更改';
	@override String get noChangesToCommit => '没有可提交的更改';
	@override late final Translations$common$gitPanel$noCommits$zh_CN noCommits = Translations$common$gitPanel$noCommits$zh_CN.internal(_root);
	@override String get noMatchingBranches => '没有匹配的分支';
	@override late final Translations$common$gitPanel$noRepo$zh_CN noRepo = Translations$common$gitPanel$noRepo$zh_CN.internal(_root);
	@override String get noStagedFiles => '没有暂存的文件';
	@override String get none => '无';
	@override String nothingToPush({required Object remote}) => '没有可推送到 ${remote} 的内容';
	@override String get openFile => '点击打开文件';
	@override String get publish => '发布';
	@override String publishTitle({required Object branch, required Object remote}) => '将“${branch}”发布到 ${remote}';
	@override String get publishing => '正在发布…';
	@override String get pull => '拉取';
	@override String pullCount({required Object count}) => '拉取 ${count}';
	@override String pullTitle({required Object remote, required Object count}) => '从 ${remote} 拉取 ${count}';
	@override String get pulling => '正在拉取…';
	@override String get push => '推送';
	@override String pushCount({required Object count}) => '推送 ${count}';
	@override String pushTitle({required Object count, required Object remote}) => '推送 ${count} 到 ${remote}';
	@override String get pushing => '正在推送…';
	@override String get recentCommits => '最近提交';
	@override String get refresh => '刷新 git 状态';
	@override String get remove => '移除';
	@override late final Translations$common$gitPanel$removeWorktree$zh_CN removeWorktree = Translations$common$gitPanel$removeWorktree$zh_CN.internal(_root);
	@override String get removing => '正在移除...';
	@override String get revertLatest => '还原最新本地提交';
	@override String get scroll => '滚动';
	@override String get searchBranches => '搜索分支...';
	@override String get selectAll => '全选';
	@override String get selectProject => '选择项目以查看源代码管理';
	@override String selectedOf({required Object total, required Object selected}) => '已选择 ${total} 个文件中的 ${selected} 个';
	@override String selectedOfMobile({required Object total, required Object selected}) => '已选择 ${total} 中的 ${selected} 个';
	@override String get sideBySide => '并排';
	@override String get stageAll => '全部暂存';
	@override String get stageHunk => '暂存此区块';
	@override String staged({required Object count}) => '已暂存（${count}）';
	@override late final Translations$common$gitPanel$status$zh_CN status = Translations$common$gitPanel$status$zh_CN.internal(_root);
	@override String get statusGuide => '文件状态指南';
	@override String get switchScroll => '切换到水平滚动';
	@override String get switchSplit => '切换到并排视图';
	@override String get switchUnified => '切换到统一视图';
	@override String get switchWrap => '切换到文本换行';
	@override String get unified => '统一';
	@override String get unstageAll => '全部取消暂存';
	@override String get unstageHunk => '取消暂存此区块';
	@override String get upToDate => '已是最新';
	@override String upToDateWith({required Object remote}) => '与 ${remote} 同步';
	@override String get viewAll => '查看全部';
	@override String get viewsAria => '源代码管理视图';
	@override late final Translations$common$gitPanel$worktrees$zh_CN worktrees = Translations$common$gitPanel$worktrees$zh_CN.internal(_root);
	@override String get wrap => '换行';
	@override late final Translations$common$gitPanel$tabs$zh_CN tabs = Translations$common$gitPanel$tabs$zh_CN.internal(_root);
}

// Path: common.sessions
class Translations$common$sessions$zh_CN extends Translations$common$sessions$en {
	Translations$common$sessions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get renameSession => '重命名会话';
}

// Path: common.projects
class Translations$common$projects$zh_CN extends Translations$common$projects$en {
	Translations$common$projects$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get newSession => '新会话';
}

// Path: common.codeBlock
class Translations$common$codeBlock$zh_CN extends Translations$common$codeBlock$en {
	Translations$common$codeBlock$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get wrapLines => '自动换行';
	@override String get noWrap => '不换行';
}

// Path: common.update
class Translations$common$update$zh_CN extends Translations$common$update$en {
	Translations$common$update$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String available({required Object version}) => '有可用更新 · v${version}';
	@override String confirm({required Object version}) => '更新到 v${version}？服务器会自行更新并重启 — 进行中的会话将被中断。';
	@override String get downloading => '正在下载并应用更新…';
	@override String get restarting => '正在重启服务器 — 请稍候…';
	@override String done({required Object version}) => '已更新到 v${version}。重新加载应用以载入新的应用包。';
	@override String get manualRestart => '更新已应用，但服务器未自动重启 — 请手动重启以完成。';
	@override String get failed => '更新失败。';
	@override String get failedTitle => '更新失败';
	@override String appConfirm({required Object version}) => '要在此设备上安装 ddagent v${version} 吗？首次安装时 Android 会请求允许从 ddagent 安装应用。';
	@override String get appPermission => '请为 ddagent 允许“安装未知应用”，然后再次点击更新。';
}

// Path: settings.changelog
class Translations$settings$changelog$zh_CN extends Translations$settings$changelog$en {
	Translations$settings$changelog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '更新日志';
	@override String get loading => '加载中…';
	@override String get empty => '没有可显示的版本';
	@override String get current => '当前';
	@override String get kNew => '新';
}

// Path: settings.server
class Translations$settings$server$zh_CN extends Translations$settings$server$en {
	Translations$settings$server$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '服务器';
	@override String get description => '重启 ddagent 进程 — 适用于应用更新或从卡顿状态恢复。';
	@override String get restart => '重启';
	@override String get restartConfirm => '确定重启 ddagent 服务器?活动会话将被中断。';
	@override String get restarting => '正在重启… 服务器恢复后页面将自动刷新。';
	@override String get restartFailed => '重启失败';
	@override String get unsupported => '仅当服务器在服务管理器下运行时才可重启。';
	@override String get ok => '确定';
}

// Path: settings.updates
class Translations$settings$updates$zh_CN extends Translations$settings$updates$en {
	Translations$settings$updates$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '应用更新';
	@override String get description => '在 GitHub 上检查更新的桌面版本。新版本会自动下载并在退出时安装。';
	@override String get check => '检查更新';
	@override String get checking => '正在检查…';
	@override String upToDate({required Object version}) => '已是最新版本（v${version}）。';
	@override String available({required Object version}) => '发现更新 v${version} — 正在后台下载；退出 ddagent 时自动安装。';
	@override String downloaded({required Object version}) => '更新 v${version} 已下载 — 退出并重新启动 ddagent 即可安装。';
	@override String get unavailable => '更新检查仅在打包的桌面版本中可用。';
	@override String error({required Object message}) => '更新检查失败：${message}';
	@override String get errorGeneric => '更新检查失败。';
}

// Path: settings.tabs
class Translations$settings$tabs$zh_CN extends Translations$settings$tabs$en {
	Translations$settings$tabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get account => '账户';
	@override String get permissions => '权限';
	@override String get mcpServers => 'MCP 服务器';
	@override String get skills => '技能';
	@override String get appearance => '外观';
}

// Path: settings.account
class Translations$settings$account$zh_CN extends Translations$settings$account$en {
	Translations$settings$account$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '账户';
	@override String get language => '语言';
	@override String get languageLabel => '显示语言';
	@override String get languageDescription => '选择您偏好的界面语言';
	@override String get username => '用户名';
	@override String get email => '邮箱';
	@override String get profile => '个人资料';
	@override String get changePassword => '修改密码';
}

// Path: settings.mcp
class Translations$settings$mcp$zh_CN extends Translations$settings$mcp$en {
	Translations$settings$mcp$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP 服务器';
	@override String get addServer => '添加服务器';
	@override String get editServer => '编辑服务器';
	@override String get deleteServer => '删除服务器';
	@override String get serverName => '服务器名称';
	@override String get serverType => '服务器类型';
	@override String get config => '配置';
	@override String get testConnection => '测试连接';
	@override String get status => '状态';
	@override String get connected => '已连接';
	@override String get disconnected => '未连接';
	@override late final Translations$settings$mcp$scope$zh_CN scope = Translations$settings$mcp$scope$zh_CN.internal(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$zh_CN extends Translations$settings$appearance$en {
	Translations$settings$appearance$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '外观';
	@override String get theme => '主题';
	@override String get codeEditor => '代码编辑器';
	@override String get editorTheme => '编辑器主题';
	@override String get wordWrap => '自动换行';
	@override String get showMinimap => '显示缩略图';
	@override String get lineNumbers => '行号';
	@override String get fontSize => '字体大小';
	@override late final Translations$settings$appearance$themeModes$zh_CN themeModes = Translations$settings$appearance$themeModes$zh_CN.internal(_root);
}

// Path: settings.actions
class Translations$settings$actions$zh_CN extends Translations$settings$actions$en {
	Translations$settings$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get saveChanges => '保存更改';
	@override String get resetToDefaults => '重置为默认值';
	@override String get cancelChanges => '取消更改';
}

// Path: settings.quickSettings
class Translations$settings$quickSettings$zh_CN extends Translations$settings$quickSettings$en {
	Translations$settings$quickSettings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '快速设置';
	@override late final Translations$settings$quickSettings$sections$zh_CN sections = Translations$settings$quickSettings$sections$zh_CN.internal(_root);
	@override String get darkMode => '深色模式';
	@override String get showRawParameters => '显示原始参数';
	@override String get showThinking => '显示思考过程';
	@override String get sendByCtrlEnter => '使用 Ctrl+Enter 发送';
	@override String get sendByCtrlEnterDescription => '启用后，按 Ctrl+Enter 发送消息，而不是仅按 Enter。这对于使用输入法的用户可以避免意外发送。';
	@override late final Translations$settings$quickSettings$dragHandle$zh_CN dragHandle = Translations$settings$quickSettings$dragHandle$zh_CN.internal(_root);
	@override String get sendWithCtrlEnter => '使用 Ctrl+Enter 发送';
}

// Path: settings.terminalShortcuts
class Translations$settings$terminalShortcuts$zh_CN extends Translations$settings$terminalShortcuts$en {
	Translations$settings$terminalShortcuts$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '终端快捷键';
	@override String get sectionKeys => '按键';
	@override String get sectionNavigation => '导航';
	@override String get escape => 'Escape';
	@override String get tab => 'Tab';
	@override String get shiftTab => 'Shift+Tab';
	@override String get arrowUp => '上箭头';
	@override String get arrowDown => '下箭头';
	@override String get scrollDown => '滚动到底部';
	@override late final Translations$settings$terminalShortcuts$handle$zh_CN handle = Translations$settings$terminalShortcuts$handle$zh_CN.internal(_root);
	@override String get killTitle => '终止正在运行的进程 (Ctrl+C)';
	@override String get paste => '粘贴';
}

// Path: settings.mainTabs
class Translations$settings$mainTabs$zh_CN extends Translations$settings$mainTabs$en {
	Translations$settings$mainTabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '设置';
	@override String get agents => '智能体';
	@override String get orchestration => '编排';
	@override String get appearance => '外观';
	@override String get git => 'Git';
	@override String get apiTokens => 'API 和令牌';
	@override String get models => '模型';
	@override String get tasks => '任务';
	@override String get browser => '浏览器';
	@override String get tools => '工具';
	@override String get notifications => '通知';
	@override String get about => '关于';
	@override String get workspaces => '工作区';
	@override String get quota => 'Control Center';
}

// Path: settings.orchestration
class Translations$settings$orchestration$zh_CN extends Translations$settings$orchestration$en {
	Translations$settings$orchestration$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orchestration';
	@override String get description => 'Route chat tasks across your providers and models.';
	@override String get loading => 'Loading orchestration settings…';
	@override String get loadError => 'Could not load the orchestration settings.';
	@override String get retry => 'Retry';
	@override late final Translations$settings$orchestration$enable$zh_CN enable = Translations$settings$orchestration$enable$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$pool$zh_CN pool = Translations$settings$orchestration$pool$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$tiers$zh_CN tiers = Translations$settings$orchestration$tiers$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$rules$zh_CN rules = Translations$settings$orchestration$rules$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$planner$zh_CN planner = Translations$settings$orchestration$planner$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$execution$zh_CN execution = Translations$settings$orchestration$execution$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$save$zh_CN save = Translations$settings$orchestration$save$zh_CN.internal(_root);
}

// Path: settings.notifications
class Translations$settings$notifications$zh_CN extends Translations$settings$notifications$en {
	Translations$settings$notifications$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
	@override String get description => '控制你希望接收的通知事件。';
	@override late final Translations$settings$notifications$webPush$zh_CN webPush = Translations$settings$notifications$webPush$zh_CN.internal(_root);
	@override late final Translations$settings$notifications$device$zh_CN device = Translations$settings$notifications$device$zh_CN.internal(_root);
	@override late final Translations$settings$notifications$desktop$zh_CN desktop = Translations$settings$notifications$desktop$zh_CN.internal(_root);
	@override late final Translations$settings$notifications$sound$zh_CN sound = Translations$settings$notifications$sound$zh_CN.internal(_root);
	@override late final Translations$settings$notifications$events$zh_CN events = Translations$settings$notifications$events$zh_CN.internal(_root);
	@override late final Translations$settings$notifications$channels$zh_CN channels = Translations$settings$notifications$channels$zh_CN.internal(_root);
	@override String get unpair => '取消配对';
}

// Path: settings.appearanceSettings
class Translations$settings$appearanceSettings$zh_CN extends Translations$settings$appearanceSettings$en {
	Translations$settings$appearanceSettings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$appearanceSettings$darkMode$zh_CN darkMode = Translations$settings$appearanceSettings$darkMode$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$zh_CN codeEditor = Translations$settings$appearanceSettings$codeEditor$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$terminal$zh_CN terminal = Translations$settings$appearanceSettings$terminal$zh_CN.internal(_root);
}

// Path: settings.mcpForm
class Translations$settings$mcpForm$zh_CN extends Translations$settings$mcpForm$en {
	Translations$settings$mcpForm$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$mcpForm$title$zh_CN title = Translations$settings$mcpForm$title$zh_CN.internal(_root);
	@override late final Translations$settings$mcpForm$importMode$zh_CN importMode = Translations$settings$mcpForm$importMode$zh_CN.internal(_root);
	@override late final Translations$settings$mcpForm$scope$zh_CN scope = Translations$settings$mcpForm$scope$zh_CN.internal(_root);
	@override late final Translations$settings$mcpForm$fields$zh_CN fields = Translations$settings$mcpForm$fields$zh_CN.internal(_root);
	@override late final Translations$settings$mcpForm$placeholders$zh_CN placeholders = Translations$settings$mcpForm$placeholders$zh_CN.internal(_root);
	@override late final Translations$settings$mcpForm$validation$zh_CN validation = Translations$settings$mcpForm$validation$zh_CN.internal(_root);
	@override String configDetails({required Object configFile}) => '配置详细信息（来自 ${configFile}）';
	@override String projectPath({required Object path}) => '路径：${path}';
	@override late final Translations$settings$mcpForm$actions$zh_CN actions = Translations$settings$mcpForm$actions$zh_CN.internal(_root);
}

// Path: settings.saveStatus
class Translations$settings$saveStatus$zh_CN extends Translations$settings$saveStatus$en {
	Translations$settings$saveStatus$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get success => '设置保存成功！';
	@override String get error => '保存设置失败';
	@override String get saving => '保存中...';
}

// Path: settings.footerActions
class Translations$settings$footerActions$zh_CN extends Translations$settings$footerActions$en {
	Translations$settings$footerActions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get save => '保存设置';
	@override String get cancel => '取消';
}

// Path: settings.git
class Translations$settings$git$zh_CN extends Translations$settings$git$en {
	Translations$settings$git$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Git 配置';
	@override String get description => '配置您的 git 提交身份。这些设置将通过 git config --global 全局应用';
	@override late final Translations$settings$git$name$zh_CN name = Translations$settings$git$name$zh_CN.internal(_root);
	@override late final Translations$settings$git$email$zh_CN email = Translations$settings$git$email$zh_CN.internal(_root);
	@override late final Translations$settings$git$actions$zh_CN actions = Translations$settings$git$actions$zh_CN.internal(_root);
	@override late final Translations$settings$git$status$zh_CN status = Translations$settings$git$status$zh_CN.internal(_root);
}

// Path: settings.apiKeys
class Translations$settings$apiKeys$zh_CN extends Translations$settings$apiKeys$en {
	Translations$settings$apiKeys$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'API 密钥';
	@override String get description => '生成 API 密钥以从其他应用访问外部 API。';
	@override late final Translations$settings$apiKeys$newKey$zh_CN newKey = Translations$settings$apiKeys$newKey$zh_CN.internal(_root);
	@override late final Translations$settings$apiKeys$form$zh_CN form = Translations$settings$apiKeys$form$zh_CN.internal(_root);
	@override String get newButton => '新建 API 密钥';
	@override String get empty => '尚未创建 API 密钥。';
	@override late final Translations$settings$apiKeys$list$zh_CN list = Translations$settings$apiKeys$list$zh_CN.internal(_root);
	@override String get confirmDelete => '确定要删除此 API 密钥吗？';
	@override late final Translations$settings$apiKeys$status$zh_CN status = Translations$settings$apiKeys$status$zh_CN.internal(_root);
	@override late final Translations$settings$apiKeys$github$zh_CN github = Translations$settings$apiKeys$github$zh_CN.internal(_root);
	@override String get apiDocsLink => 'API 文档';
	@override late final Translations$settings$apiKeys$documentation$zh_CN documentation = Translations$settings$apiKeys$documentation$zh_CN.internal(_root);
	@override String get loading => '加载中...';
	@override late final Translations$settings$apiKeys$version$zh_CN version = Translations$settings$apiKeys$version$zh_CN.internal(_root);
}

// Path: settings.tasks
class Translations$settings$tasks$zh_CN extends Translations$settings$tasks$en {
	Translations$settings$tasks$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get checking => '正在检查 TaskMaster 安装...';
	@override late final Translations$settings$tasks$notInstalled$zh_CN notInstalled = Translations$settings$tasks$notInstalled$zh_CN.internal(_root);
	@override late final Translations$settings$tasks$settings$zh_CN settings = Translations$settings$tasks$settings$zh_CN.internal(_root);
}

// Path: settings.agents
class Translations$settings$agents$zh_CN extends Translations$settings$agents$en {
	Translations$settings$agents$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$authStatus$zh_CN authStatus = Translations$settings$agents$authStatus$zh_CN.internal(_root);
	@override late final Translations$settings$agents$install$zh_CN install = Translations$settings$agents$install$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$zh_CN account = Translations$settings$agents$account$zh_CN.internal(_root);
	@override String get connectionStatus => '连接状态';
	@override late final Translations$settings$agents$login$zh_CN login = Translations$settings$agents$login$zh_CN.internal(_root);
	@override String error({required Object error}) => '错误：${error}';
}

// Path: settings.permissions
class Translations$settings$permissions$zh_CN extends Translations$settings$permissions$en {
	Translations$settings$permissions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '权限设置';
	@override late final Translations$settings$permissions$skipPermissions$zh_CN skipPermissions = Translations$settings$permissions$skipPermissions$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$allowedTools$zh_CN allowedTools = Translations$settings$permissions$allowedTools$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$blockedTools$zh_CN blockedTools = Translations$settings$permissions$blockedTools$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$allowedCommands$zh_CN allowedCommands = Translations$settings$permissions$allowedCommands$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$blockedCommands$zh_CN blockedCommands = Translations$settings$permissions$blockedCommands$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$toolExamples$zh_CN toolExamples = Translations$settings$permissions$toolExamples$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$shellExamples$zh_CN shellExamples = Translations$settings$permissions$shellExamples$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$codex$zh_CN codex = Translations$settings$permissions$codex$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$actions$zh_CN actions = Translations$settings$permissions$actions$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$zh_CN permissionMode = Translations$settings$permissions$permissionMode$zh_CN.internal(_root);
}

// Path: settings.mcpServers
class Translations$settings$mcpServers$zh_CN extends Translations$settings$mcpServers$en {
	Translations$settings$mcpServers$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'MCP 服务器';
	@override late final Translations$settings$mcpServers$description$zh_CN description = Translations$settings$mcpServers$description$zh_CN.internal(_root);
	@override String get addButton => '添加 MCP 服务器';
	@override String get empty => '未配置 MCP 服务器';
	@override String get serverType => '类型';
	@override late final Translations$settings$mcpServers$scope$zh_CN scope = Translations$settings$mcpServers$scope$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$config$zh_CN config = Translations$settings$mcpServers$config$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$tools$zh_CN tools = Translations$settings$mcpServers$tools$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$actions$zh_CN actions = Translations$settings$mcpServers$actions$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$managed$zh_CN managed = Translations$settings$mcpServers$managed$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$help$zh_CN help = Translations$settings$mcpServers$help$zh_CN.internal(_root);
	@override late final Translations$settings$mcpServers$deleteConfirm$zh_CN deleteConfirm = Translations$settings$mcpServers$deleteConfirm$zh_CN.internal(_root);
}

// Path: settings.quota
class Translations$settings$quota$zh_CN extends Translations$settings$quota$en {
	Translations$settings$quota$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$quota$settings$zh_CN settings = Translations$settings$quota$settings$zh_CN.internal(_root);
	@override late final Translations$settings$quota$empty$zh_CN empty = Translations$settings$quota$empty$zh_CN.internal(_root);
	@override late final Translations$settings$quota$quality$zh_CN quality = Translations$settings$quota$quality$zh_CN.internal(_root);
	@override String get syncFailed => '同步失败';
	@override String get syncNow => '立即同步';
}

// Path: settings.browser
class Translations$settings$browser$zh_CN extends Translations$settings$browser$en {
	Translations$settings$browser$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get checking => '正在检查...';
	@override String get description => '允许代理启动受管理的 Playwright 浏览器会话，你可以在 Browser 标签页中监控。';
	@override String get enableDescription => '为支持的代理注册 Browser。代理可以创建浏览器会话，你可以监控、停止和删除它们。';
	@override String get enableLabel => '启用 Browser';
	@override late final Translations$settings$browser$errors$zh_CN errors = Translations$settings$browser$errors$zh_CN.internal(_root);
	@override String get installHint => '在代理创建 Browser 会话之前，请安装浏览器运行时。';
	@override String get installRuntime => '安装运行时';
	@override String get installed => '已安装';
	@override String get installing => '正在安装...';
	@override String get missing => '缺失';
	@override String get runtimeRequired => '需要浏览器运行时';
	@override String get statusDisabled => '已禁用';
	@override String get statusLabel => '状态';
	@override String get statusReady => '就绪';
	@override String get statusSetupRequired => '需要设置';
	@override String get title => 'Browser';
}

// Path: settings.workspaces
class Translations$settings$workspaces$zh_CN extends Translations$settings$workspaces$en {
	Translations$settings$workspaces$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get create => '添加工作区';
	@override String get deleteConfirm => '从 ddagent 移除此工作区？文件将保留在磁盘上。';
	@override String get deleteFailed => '移除工作区失败。';
	@override String get deleteTitle => '移除工作区';
	@override String get description => '工作区是 ddagent 可以聊天、运行代码和浏览的目录。';
	@override String get remove => '移除工作区';
	@override String get title => '工作区';
	@override String get pathRequired => '路径为必填项';
}

// Path: settings.about
class Translations$settings$about$zh_CN extends Translations$settings$about$en {
	Translations$settings$about$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get supportTitle => '支持本项目';
	@override String get buyMeACoffee => '请我喝杯咖啡';
	@override String get learnMore => '了解更多';
	@override late final Translations$settings$about$pro$zh_CN pro = Translations$settings$about$pro$zh_CN.internal(_root);
	@override String get proFeatures => 'ddagent Pro 功能';
	@override String get tryHosted => '试用 ddagent Hosted';
	@override String get versionInfo => '版本信息';
	@override String get client => '应用';
	@override String get server => '服务器';
	@override String get platformMobile => '移动端';
	@override String get platformDesktop => '桌面端';
	@override String get platformWeb => '网页';
	@override String get unknown => '未知';
}

// Path: sidebar.projects
class Translations$sidebar$projects$zh_CN extends Translations$sidebar$projects$en {
	Translations$sidebar$projects$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '项目';
	@override String get newProject => '新建项目';
	@override String get deleteProject => '移除项目';
	@override String get renameProject => '重命名项目';
	@override String get noProjects => '未找到项目';
	@override String get loadingProjects => '加载项目中...';
	@override String get searchPlaceholder => '搜索项目...';
	@override String get projectNamePlaceholder => '项目名称';
	@override String get starred => '星标';
	@override String get all => '全部';
	@override String get untitledSession => '未命名会话';
	@override String get newSession => '新会话';
	@override String get codexSession => 'Codex 会话';
	@override String get fetchingProjects => '正在获取您的 Claude 项目和会话';
	@override String get projects => '项目';
	@override String get noMatchingProjects => '未找到匹配的项目';
	@override String get tryDifferentSearch => '尝试调整您的搜索词';
	@override String get runClaudeCli => '在项目目录中运行 Claude CLI 以开始使用';
}

// Path: sidebar.app
class Translations$sidebar$app$zh_CN extends Translations$sidebar$app$en {
	Translations$sidebar$app$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ddagent';
	@override String get subtitle => 'AI 编程助手';
}

// Path: sidebar.sessions
class Translations$sidebar$sessions$zh_CN extends Translations$sidebar$sessions$en {
	Translations$sidebar$sessions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '会话';
	@override String get newSession => '新建会话';
	@override String get deleteSession => '删除会话';
	@override String get renameSession => '重命名会话';
	@override String get noSessions => '暂无会话';
	@override String get loadingSessions => '加载会话中...';
	@override String get unnamed => '未命名';
	@override String get loading => '加载中...';
	@override String get showMore => '显示更多会话';
	@override String get selectMode => '选择';
	@override String get selectAll => '全选';
	@override String archiveSelected({required Object count}) => '归档（${count}）';
	@override String deleteSelected({required Object count}) => '删除（${count}）';
	@override String get cancelSelection => '取消选择';
	@override String get toggleSelection => '切换会话选择';
	@override String get selectionToolbar => '会话选择操作';
	@override String get options => '会话选项';
	@override String get pinSession => '固定会话';
	@override String get unpinSession => '取消固定会话';
	@override String get pinned => '已固定的会话';
	@override String selectedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '已选 ${count} 个',
		other: '已选 ${count} 个',
	);
}

// Path: sidebar.tooltips
class Translations$sidebar$tooltips$zh_CN extends Translations$sidebar$tooltips$en {
	Translations$sidebar$tooltips$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get viewEnvironments => '查看环境';
	@override String get hideSidebar => '隐藏侧边栏';
	@override String get createProject => '创建新项目';
	@override String get refresh => '刷新项目和会话 (Ctrl+R)';
	@override String get renameProject => '重命名项目 (F2)';
	@override String get deleteProject => '从侧边栏移除项目 (Delete)';
	@override String get addToFavorites => '添加到收藏';
	@override String get removeFromFavorites => '从收藏移除';
	@override String get editSessionName => '手动编辑会话名称';
	@override String get deleteSession => '永久删除此会话';
	@override String get activeSessionIndicator => '最近活跃的会话（最近 10 分钟）';
	@override String get save => '保存';
	@override String get cancel => '取消';
	@override String get clearSearch => '清除搜索';
	@override String get openCommandPalette => '打开命令面板';
	@override String get attentionRequiredIndicator => '会话需要处理';
	@override String get openSessions => '浏览会话';
}

// Path: sidebar.navigation
class Translations$sidebar$navigation$zh_CN extends Translations$sidebar$navigation$en {
	Translations$sidebar$navigation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get chat => '聊天';
	@override String get files => '文件';
	@override String get git => 'Git';
	@override String get terminal => '终端';
	@override String get tasks => '任务';
}

// Path: sidebar.actions
class Translations$sidebar$actions$zh_CN extends Translations$sidebar$actions$en {
	Translations$sidebar$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get refresh => '刷新';
	@override String get settings => '设置';
	@override String get collapseAll => '全部折叠';
	@override String get expandAll => '全部展开';
	@override String get cancel => '取消';
	@override String get save => '保存';
	@override String get delete => '删除';
	@override String get rename => '重命名';
	@override String get joinCommunity => '加入社区';
	@override String get reportIssue => '报告问题';
	@override String get starOnGithub => '在GitHub上加星';
	@override String get buyMeACoffee => '请我喝杯咖啡';
}

// Path: sidebar.branding
class Translations$sidebar$branding$zh_CN extends Translations$sidebar$branding$en {
	Translations$sidebar$branding$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get openSource => '开源';
}

// Path: sidebar.status
class Translations$sidebar$status$zh_CN extends Translations$sidebar$status$en {
	Translations$sidebar$status$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get active => '活动';
	@override String get inactive => '非活动';
	@override String get thinking => '思考中...';
	@override String get error => '错误';
	@override String get aborted => '已中止';
	@override String get unknown => '未知';
}

// Path: sidebar.time
class Translations$sidebar$time$zh_CN extends Translations$sidebar$time$en {
	Translations$sidebar$time$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get justNow => '刚刚';
	@override String get oneMinuteAgo => '1 分钟前';
	@override String minutesAgo({required Object count}) => '${count} 分钟前';
	@override String get oneHourAgo => '1 小时前';
	@override String hoursAgo({required Object count}) => '${count} 小时前';
	@override String get oneDayAgo => '1 天前';
	@override String daysAgo({required Object count}) => '${count} 天前';
}

// Path: sidebar.messages
class Translations$sidebar$messages$zh_CN extends Translations$sidebar$messages$en {
	Translations$sidebar$messages$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get deleteConfirm => '确定要删除吗？';
	@override String get renameSuccess => '重命名成功';
	@override String get deleteSuccess => '删除成功';
	@override String get errorOccurred => '发生错误';
	@override String get deleteSessionConfirm => '确定要删除此会话吗？此操作无法撤销。';
	@override String get deleteProjectConfirm => '从侧边栏移除此项目？您的项目文件、记忆和会话数据不会被删除。';
	@override String get enterProjectPath => '请输入项目路径';
	@override String get deleteSessionFailed => '删除会话失败，请重试。';
	@override String get deleteSessionError => '删除会话时出错，请重试。';
	@override String get renameSessionFailed => '重命名会话失败，请重试。';
	@override String get renameSessionError => '重命名会话时出错，请重试。';
	@override String get deleteProjectFailed => '移除项目失败，请重试。';
	@override String get deleteProjectError => '移除项目时出错，请重试。';
	@override String get createProjectFailed => '创建项目失败，请重试。';
	@override String get createProjectError => '创建项目时出错，请重试。';
	@override String get updateProjectError => '更新项目时出错，请重试。';
	@override String get refreshError => '刷新失败，请重试。';
	@override String get restoreProjectFailed => '恢复项目失败，请重试。';
	@override String get restoreProjectError => '恢复项目时出错，请重试。';
	@override String get restoreSessionFailed => '恢复会话失败，请重试。';
	@override String get restoreSessionError => '恢复会话时出错，请重试。';
	@override String get changeWorkspaceFailed => '更改工作区失败。请重试。';
	@override String get changeWorkspaceError => '更改工作区时出错。请重试。';
	@override String bulkDeleteSessionsFailed({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '删除 ${count} 个会话失败。请重试。',
		other: '删除 ${count} 个会话失败。请重试。',
	);
}

// Path: sidebar.version
class Translations$sidebar$version$zh_CN extends Translations$sidebar$version$en {
	Translations$sidebar$version$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get updateAvailable => '有可用更新';
	@override String get restartRequired => '已安装更新 — 请重启服务器以生效';
	@override String get updateNow => '立即更新';
	@override String updateConfirm({required Object version}) => '将 ddagent 更新到 v${version}？将拉取最新代码并重新构建，随后服务器重启 — 进行中的会话会被中断。';
	@override String get updating => '正在更新… 可能需要几分钟';
	@override String get restarting => '更新已安装 — 正在重启…';
	@override String get updateFailed => '更新失败';
	@override String get releaseNotes => '发行说明';
}

// Path: sidebar.search
class Translations$sidebar$search$zh_CN extends Translations$sidebar$search$en {
	Translations$sidebar$search$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get modeProjects => '项目';
	@override String get modeConversations => '对话';
	@override String get conversationsPlaceholder => '搜索对话内容...';
	@override String get searching => '搜索中...';
	@override String get sessionTitles => '会话标题';
	@override String get conversationContents => '对话内容';
	@override String get noResults => '未找到结果';
	@override String get tryDifferentQuery => '尝试不同的搜索词';
	@override String get modeRunning => '运行中';
	@override String get archiveOnly => '归档';
	@override String get runningTooltip => '运行中的会话';
	@override String get archiveOnlyTooltip => '仅归档';
	@override String runningCount({required Object count}) => '${count} 个活跃';
	@override String get viewMenu => '视图';
	@override String get backToProjects => '返回项目';
	@override String get archivedPlaceholder => '搜索已归档会话...';
	@override String get runningPlaceholder => '搜索运行中的会话...';
	@override String matches({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 个匹配',
		other: '${count} 个匹配',
	);
	@override String projectsScanned({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 个项目已扫描',
		other: '${count} 个项目已扫描',
	);
}

// Path: sidebar.deleteConfirmation
class Translations$sidebar$deleteConfirmation$zh_CN extends Translations$sidebar$deleteConfirmation$en {
	Translations$sidebar$deleteConfirmation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get deleteProject => '移除项目';
	@override String get deleteSession => '删除会话';
	@override String get confirmDelete => '您想如何处理';
	@override String get removeFromSidebar => '仅从侧边栏移除';
	@override String get deleteAllData => '永久删除所有数据';
	@override String get allConversationsDeleted => '项目将从侧边栏中移除。您的文件、记忆和会话数据将会保留。';
	@override String get cannotUndo => '您可以稍后重新添加此项目。';
	@override String get bulkDeleteSessionsDescription => '归档会将所选会话从活跃列表中隐藏，同时保留其历史记录。';
	@override String get archiveSession => '归档会话';
	@override String get archiveSessionNotice => '归档会将会话移出活跃列表，同时保留其历史记录。';
	@override String get archivedSessionNotice => '此会话已归档。你可以保持隐藏或永久删除。';
	@override String get deleteSessionNotice => '这将永久删除会话及其记录。此操作无法撤销。';
	@override String get deleteSessionPermanently => '永久删除';
	@override String sessionCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '此项目包含 ${count} 个对话。',
		other: '此项目包含 ${count} 个对话。',
	);
	@override String bulkDeleteSessionsTitle({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '管理所选会话',
		other: '管理 ${count} 个所选会话',
	);
	@override String archiveSelectedSessions({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '归档会话',
		other: '归档 ${count} 个会话',
	);
}

// Path: sidebar.zones
class Translations$sidebar$zones$zh_CN extends Translations$sidebar$zones$en {
	Translations$sidebar$zones$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get activeNow => '当前活跃';
	@override String get recent => '最近使用';
	@override String get today => '今天';
	@override String get yesterday => '昨天';
	@override String get thisWeek => '本周';
	@override String showMore({required Object count}) => '再显示 ${count} 个';
	@override String get showLess => '收起';
}

// Path: sidebar.panel
class Translations$sidebar$panel$zh_CN extends Translations$sidebar$panel$en {
	Translations$sidebar$panel$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get open => '面板';
	@override String get newChat => '新聊天';
	@override String get navigation => '导航';
	@override String get sessions => '会话';
}

// Path: sidebar.workspace
class Translations$sidebar$workspace$zh_CN extends Translations$sidebar$workspace$en {
	Translations$sidebar$workspace$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '更改会话工作区';
	@override String get description => '代理将在此目录中执行后续回合。现有会话历史将被保留。';
	@override String get pathLabel => '工作区路径';
	@override String get pathRequired => '工作区路径为必填项。';
	@override String get submit => '更改工作区';
	@override String get saving => '正在更改…';
	@override String get changeAction => '更改工作区';
}

// Path: sidebar.recent
class Translations$sidebar$recent$zh_CN extends Translations$sidebar$recent$en {
	Translations$sidebar$recent$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '最近对话';
	@override String get emptyTitle => '暂无对话';
	@override String get emptyDescription => '你最近更新的对话将显示在这里。';
	@override String get loadFailed => '无法加载最近对话';
	@override String get loadMore => '加载更早的对话';
	@override String get loadingMore => '加载中...';
}

// Path: sidebar.tabs
class Translations$sidebar$tabs$zh_CN extends Translations$sidebar$tabs$en {
	Translations$sidebar$tabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get board => '代理面板';
	@override String get files => '文件';
	@override String get git => '源代码管理';
	@override String get tasks => '任务';
	@override String get usage => '配额与用量';
}

// Path: tasks.notConfigured
class Translations$tasks$notConfigured$zh_CN extends Translations$tasks$notConfigured$en {
	Translations$tasks$notConfigured$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster AI 尚未配置';
	@override String get description => 'TaskMaster 帮助将复杂的项目分解为可管理的任务，配合 AI 驱动的辅助功能';
	@override String get whatIsTitle => '🎯 什么是 TaskMaster？';
	@override late final Translations$tasks$notConfigured$features$zh_CN features = Translations$tasks$notConfigured$features$zh_CN.internal(_root);
	@override String get initializeButton => '初始化 TaskMaster AI';
	@override String get writePrdFirst => '先编写 PRD';
}

// Path: tasks.gettingStarted
class Translations$tasks$gettingStarted$zh_CN extends Translations$tasks$gettingStarted$en {
	Translations$tasks$gettingStarted$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '开始使用 TaskMaster';
	@override String get subtitle => 'TaskMaster 已初始化！以下是接下来要做的事：';
	@override late final Translations$tasks$gettingStarted$steps$zh_CN steps = Translations$tasks$gettingStarted$steps$zh_CN.internal(_root);
	@override String get tip => '💡 提示：从 PRD 开始可以充分利用 TaskMaster 的 AI 驱动任务生成功能';
}

// Path: tasks.setupModal
class Translations$tasks$setupModal$zh_CN extends Translations$tasks$setupModal$en {
	Translations$tasks$setupModal$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'TaskMaster 设置';
	@override String subtitle({required Object projectName}) => '${projectName} 的交互式 CLI';
	@override String get willStart => 'TaskMaster 初始化将自动开始';
	@override String get completed => 'TaskMaster 设置完成！您现在可以关闭此窗口。';
	@override String get closeButton => '关闭';
	@override String get closeContinueButton => '关闭并继续';
	@override String get closeTitle => '关闭';
	@override String get description => '这将在此项目中创建一个 .taskmaster 文件夹。无需外部工具或 API 密钥——任务保存在本地。';
	@override String get initializeButton => '初始化';
	@override String get initializing => '正在初始化...';
}

// Path: tasks.helpGuide
class Translations$tasks$helpGuide$zh_CN extends Translations$tasks$helpGuide$en {
	Translations$tasks$helpGuide$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '开始使用 TaskMaster';
	@override String get subtitle => '您的高效任务管理指南';
	@override late final Translations$tasks$helpGuide$examples$zh_CN examples = Translations$tasks$helpGuide$examples$zh_CN.internal(_root);
	@override String get moreExamples => '查看更多示例和使用模式 →';
	@override late final Translations$tasks$helpGuide$proTips$zh_CN proTips = Translations$tasks$helpGuide$proTips$zh_CN.internal(_root);
	@override late final Translations$tasks$helpGuide$learnMore$zh_CN learnMore = Translations$tasks$helpGuide$learnMore$zh_CN.internal(_root);
	@override String get closeTitle => '关闭';
}

// Path: tasks.search
class Translations$tasks$search$zh_CN extends Translations$tasks$search$en {
	Translations$tasks$search$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get placeholder => '搜索任务...';
}

// Path: tasks.filters
class Translations$tasks$filters$zh_CN extends Translations$tasks$filters$en {
	Translations$tasks$filters$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get button => '筛选';
	@override String get status => '状态';
	@override String get priority => '优先级';
	@override String get sortBy => '排序方式';
	@override String get allStatuses => '所有状态';
	@override String get allPriorities => '所有优先级';
	@override String showing({required Object filtered, required Object total}) => '显示 ${filtered} / ${total} 个任务';
	@override String get clearFilters => '清除筛选';
}

// Path: tasks.sort
class Translations$tasks$sort$zh_CN extends Translations$tasks$sort$en {
	Translations$tasks$sort$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get id => 'ID';
	@override String get status => '状态';
	@override String get priority => '优先级';
	@override String get idAsc => 'ID（递增）';
	@override String get idDesc => 'ID（递减）';
	@override String get titleAsc => '标题（A-Z）';
	@override String get titleDesc => '标题（Z-A）';
	@override String get statusAsc => '状态（待处理优先）';
	@override String get statusDesc => '状态（已完成优先）';
	@override String get priorityAsc => '优先级（高优先）';
	@override String get priorityDesc => '优先级（低优先）';
}

// Path: tasks.views
class Translations$tasks$views$zh_CN extends Translations$tasks$views$en {
	Translations$tasks$views$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get kanban => '看板视图';
	@override String get list => '列表视图';
	@override String get grid => '网格视图';
}

// Path: tasks.kanban
class Translations$tasks$kanban$zh_CN extends Translations$tasks$kanban$en {
	Translations$tasks$kanban$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get pending => '📋 待办';
	@override String get inProgress => '🚀 进行中';
	@override String get review => '👀 审查';
	@override String get done => '✅ 已完成';
	@override String get blocked => '🚫 已阻止';
	@override String get deferred => '⏳ 已延后';
	@override String get cancelled => '❌ 已取消';
	@override String get noTasksYet => '暂无任务';
	@override String get tasksWillAppear => '任务将显示在这里';
	@override String get moveTasksHere => '开始后将任务移到这里';
	@override String get completedTasksHere => '已完成的任务显示在这里';
	@override String get statusTasksHere => '此状态的任务将显示在这里';
}

// Path: tasks.buttons
class Translations$tasks$buttons$zh_CN extends Translations$tasks$buttons$en {
	Translations$tasks$buttons$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get help => 'TaskMaster 入门指南';
	@override String get prds => 'PRD';
	@override String get addPRD => '添加 PRD';
	@override String get addTask => '添加任务';
	@override String get createNewPRD => '创建新 PRD';
	@override String prdsAvailable({required Object count}) => '${count} 个 PRD 可用';
}

// Path: tasks.prd
class Translations$tasks$prd$zh_CN extends Translations$tasks$prd$en {
	Translations$tasks$prd$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String modified({required Object date}) => '修改时间：${date}';
	@override String editorTitle({required Object name}) => 'PRD — ${name}';
	@override String fileExistsMessage({required Object name}) => '名为“${name}”的 PRD 已存在。要覆盖它吗？';
	@override String get fileExistsTitle => '文件已存在';
	@override String get newFile => '新文件';
	@override String get parse => '解析 PRD';
	@override String get template => '模板';
	@override String get fileNameHint => '文件名（例如 prd.txt）';
	@override String get saved => 'PRD 已保存';
	@override String get tasksGenerated => '已从 PRD 生成任务';
}

// Path: tasks.statuses
class Translations$tasks$statuses$zh_CN extends Translations$tasks$statuses$en {
	Translations$tasks$statuses$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get pending => '待处理';
	@override String get inProgress => '进行中';
	@override String get done => '已完成';
	@override String get blocked => '已阻止';
	@override String get deferred => '已延后';
	@override String get cancelled => '已取消';
	@override String get review => '审查';
}

// Path: tasks.priorities
class Translations$tasks$priorities$zh_CN extends Translations$tasks$priorities$en {
	Translations$tasks$priorities$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get high => '高';
	@override String get medium => '中';
	@override String get low => '低';
}

// Path: tasks.noMatchingTasks
class Translations$tasks$noMatchingTasks$zh_CN extends Translations$tasks$noMatchingTasks$en {
	Translations$tasks$noMatchingTasks$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '没有符合筛选条件的任务';
	@override String get description => '尝试调整您的搜索或筛选条件。';
}

// Path: tasks.board
class Translations$tasks$board$zh_CN extends Translations$tasks$board$en {
	Translations$tasks$board$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '代理看板';
	@override String get subtitle => '把卡片移到“准备开始”，代理就会接手。点击卡片打开其会话。';
	@override String get newCard => '新卡片';
	@override String get addCard => '添加卡片';
	@override String get refresh => '刷新';
	@override late final Translations$tasks$board$empty$zh_CN empty = Translations$tasks$board$empty$zh_CN.internal(_root);
	@override late final Translations$tasks$board$columns$zh_CN columns = Translations$tasks$board$columns$zh_CN.internal(_root);
	@override late final Translations$tasks$board$card$zh_CN card = Translations$tasks$board$card$zh_CN.internal(_root);
	@override late final Translations$tasks$board$dialog$zh_CN dialog = Translations$tasks$board$dialog$zh_CN.internal(_root);
	@override String get noProject => '先添加一个项目，然后为它创建卡片。';
	@override String get projectLabel => '项目';
	@override String get backToChat => '返回聊天';
	@override late final Translations$tasks$board$agent$zh_CN agent = Translations$tasks$board$agent$zh_CN.internal(_root);
	@override late final Translations$tasks$board$deleteConfirm$zh_CN deleteConfirm = Translations$tasks$board$deleteConfirm$zh_CN.internal(_root);
	@override String get project => '项目';
}

// Path: tasks.card
class Translations$tasks$card$zh_CN extends Translations$tasks$card$en {
	Translations$tasks$card$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String dependsOnList({required Object tasks}) => '依赖于：${tasks}';
	@override String dependsOnTooltip({required Object id}) => '任务 ${id}';
	@override String get highPriority => '高优先级';
	@override String get lowPriority => '低优先级';
	@override String get mediumPriority => '中优先级';
	@override String get noPriority => '未设置优先级';
	@override String parentTask({required Object id}) => '任务 ${id}';
	@override String get progressLabel => '进度：';
	@override String progressTooltip({required Object total, required Object completed}) => '${total} 个子任务中已完成 ${completed} 个';
	@override String get runTask => '运行任务';
	@override String runTaskAria({required Object id}) => '运行任务 ${id}';
	@override String statusTooltip({required Object status}) => '状态：${status}';
	@override String taskIdTitle({required Object id}) => '任务 ID：${id}';
	@override String get taskInProgress => '任务进行中';
}

// Path: tasks.createTask
class Translations$tasks$createTask$zh_CN extends Translations$tasks$createTask$en {
	Translations$tasks$createTask$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get descriptionLabel => '描述';
	@override String get descriptionPlaceholder => '可选详情';
	@override String get error => '添加任务失败';
	@override String get priorityLabel => '优先级';
	@override String get submit => '添加任务';
	@override String get submitting => '正在添加...';
	@override String get title => '添加任务';
	@override String get titleLabel => '标题';
	@override String get titlePlaceholder => '需要做什么？';
}

// Path: tasks.list
class Translations$tasks$list$zh_CN extends Translations$tasks$list$en {
	Translations$tasks$list$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get completedReopen => '已完成（点击重新打开）';
	@override String get inProgressComplete => '进行中（点击完成）';
	@override String get markCompleted => '标记为已完成';
	@override String toggleStatusAria({required Object id}) => '切换任务 ${id} 的状态';
	@override String get markDone => '标记为已完成';
	@override String get reopen => '重新打开';
}

// Path: tasks.nextTask
class Translations$tasks$nextTask$zh_CN extends Translations$tasks$nextTask$en {
	Translations$tasks$nextTask$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get allComplete => '所有任务已完成';
	@override String get feature1 => '- AI 任务管理，支持依赖和子任务。';
	@override String get feature2 => '- PRD 驱动的任务生成，快速启动项目。';
	@override String get feature3 => '- 看板和列表视图，适合日常工作。';
	@override String get hideDetails => '隐藏详情';
	@override String get initialize => '初始化';
	@override String get noPending => '没有待处理任务';
	@override String get notConfigured => 'TaskMaster AI 未配置';
	@override String get review => '审查';
	@override String get startTask => '开始任务';
	@override String taskId({required Object id}) => '任务 ${id}';
	@override String get viewAll => '查看所有任务';
	@override String get viewDetails => '查看任务详情';
	@override String get whatIs => '什么是 TaskMaster？';
}

// Path: tasks.taskDetail
class Translations$tasks$taskDetail$zh_CN extends Translations$tasks$taskDetail$en {
	Translations$tasks$taskDetail$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancelEdit => '取消编辑';
	@override String get close => '关闭';
	@override String get copyTaskId => '复制任务 ID';
	@override String get delete => '删除任务';
	@override String deleteConfirmDescription({required Object title}) => '“${title}”将被永久删除。';
	@override String get deleteConfirmTitle => '删除任务？';
	@override String get deleteFailed => '删除任务失败';
	@override String get dependencies => '依赖项';
	@override String get dependenciesPlaceholder => '例如：1, 2, 3';
	@override String get description => '描述';
	@override String get edit => '编辑任务';
	@override String get implDetails => '实现细节';
	@override String get noDependencies => '无依赖项';
	@override String get noDescription => '无描述';
	@override String get priority => '优先级';
	@override String get priorityNotSet => '未设置';
	@override String get save => '保存';
	@override String get status => '状态';
	@override String get statusFailed => '更新任务状态失败';
	@override String taskId({required Object id}) => '任务 ${id}';
	@override String taskTitle({required Object id, required Object title}) => '任务 ${id}：${title}';
	@override String get testStrategy => '测试策略';
	@override String get titleRequired => '标题为必填项';
	@override String get updateFailed => '更新任务失败';
	@override String deleteConfirmMessage({required Object id}) => '任务 #${id} 将被移除。此操作无法撤销。';
	@override String get notFound => '未找到任务';
	@override String get subtasks => '子任务';
	@override String get idCopied => '任务 ID 已复制';
}

// Path: tasks.toasts
class Translations$tasks$toasts$zh_CN extends Translations$tasks$toasts$en {
	Translations$tasks$toasts$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String statusInProgress({required Object id}) => '任务 ${id} 已设为进行中';
}

// Path: knowledge.tabs
class Translations$knowledge$tabs$zh_CN extends Translations$knowledge$tabs$en {
	Translations$knowledge$tabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dashboard => '面板';
	@override String get memories => '记忆';
	@override String get rules => '规则';
	@override String get skills => '技能';
	@override String get personal => '个人信息';
	@override String get graph => '图谱';
}

// Path: knowledge.common
class Translations$knowledge$common$zh_CN extends Translations$knowledge$common$en {
	Translations$knowledge$common$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add => '添加';
	@override String get save => '保存';
	@override String get cancel => '取消';
	@override String get delete => '删除';
	@override String get edit => '编辑';
	@override String get close => '关闭';
	@override String get restore => '恢复';
	@override String get refresh => '刷新';
	@override String get allProjects => '所有项目';
	@override String get global => '全局';
}

// Path: knowledge.actions
class Translations$knowledge$actions$zh_CN extends Translations$knowledge$actions$en {
	Translations$knowledge$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get scan => '扫描项目文件';
	@override String get export => '导出 JSON';
	@override String get import => '导入 JSON';
	@override String get scanComplete => '扫描完成';
	@override String get importComplete => '导入完成';
	@override String get importFailed => '导入失败';
}

// Path: knowledge.dialog
class Translations$knowledge$dialog$zh_CN extends Translations$knowledge$dialog$en {
	Translations$knowledge$dialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get newEntity => '新建条目';
	@override String get editEntity => '编辑条目';
	@override String get deleteTitle => '删除';
	@override String get deleteMessage => '删除此条目？此操作不可撤销（历史记录会保留）。';
	@override String get pickIcon => '选择图标';
	@override String get removeIcon => '移除图标';
	@override String get iconTooLarge => '图标过大（最大 40 KB）。';
	@override String get importTitle => '导入知识';
	@override String get importHint => '在此粘贴导出的 JSON';
	@override String get exportTitle => '导出知识';
	@override String get import => '导入';
}

// Path: knowledge.fields
class Translations$knowledge$fields$zh_CN extends Translations$knowledge$fields$en {
	Translations$knowledge$fields$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get key => '键';
	@override String get title => '标题';
	@override String get name => '名称';
	@override String get description => '描述';
	@override String get category => '分类';
	@override String get content => '内容';
	@override String get priority => '优先级';
	@override String get tags => '标签';
	@override String get enabled => '启用';
	@override String get projectScope => '项目范围';
	@override String get tagsHint => '用逗号分隔';
}

// Path: knowledge.dashboard
class Translations$knowledge$dashboard$zh_CN extends Translations$knowledge$dashboard$en {
	Translations$knowledge$dashboard$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get memories => '记忆';
	@override String get rules => '规则';
	@override String get skills => '技能';
	@override String get personal => '个人信息';
	@override String get connections => '连接';
	@override String get recent => '最近的记忆';
	@override String get noMemories => '还没有记忆。请在“记忆”标签页添加。';
}

// Path: knowledge.empty
class Translations$knowledge$empty$zh_CN extends Translations$knowledge$empty$en {
	Translations$knowledge$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get memories => '还没有记忆。';
	@override String get rules => '还没有规则。';
	@override String get skills => '还没有技能。';
	@override String get personal => '还没有个人信息。';
	@override String get graph => '没有可显示的实体。';
}

// Path: knowledge.history
class Translations$knowledge$history$zh_CN extends Translations$knowledge$history$en {
	Translations$knowledge$history$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '历史';
	@override String get none => '暂无历史。';
	@override String get untitled => '（无标题）';
}

// Path: knowledge.priorities
class Translations$knowledge$priorities$zh_CN extends Translations$knowledge$priorities$en {
	Translations$knowledge$priorities$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get critical => '严重';
	@override String get high => '高';
	@override String get normal => '普通';
	@override String get low => '低';
}

// Path: knowledge.search
class Translations$knowledge$search$zh_CN extends Translations$knowledge$search$en {
	Translations$knowledge$search$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '搜索知识';
	@override String get hint => '搜索记忆、规则、技能…';
	@override String get noResults => '无结果。';
}

// Path: knowledge.links
class Translations$knowledge$links$zh_CN extends Translations$knowledge$links$en {
	Translations$knowledge$links$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '关联实体';
	@override String get source => '源';
	@override String get target => '目标';
	@override String get relationship => '关系';
	@override String get add => '创建关联';
}

// Path: knowledge.tags
class Translations$knowledge$tags$zh_CN extends Translations$knowledge$tags$en {
	Translations$knowledge$tags$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get all => '所有标签';
	@override String get manage => '管理标签';
	@override String get none => '还没有标签。';
}

// Path: knowledge.contextBudget
class Translations$knowledge$contextBudget$zh_CN extends Translations$knowledge$contextBudget$en {
	Translations$knowledge$contextBudget$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String tokens({required Object tokens, required Object budget}) => '~${tokens} / ${budget} 令牌';
}

// Path: knowledge.critical
class Translations$knowledge$critical$zh_CN extends Translations$knowledge$critical$en {
	Translations$knowledge$critical$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get make => '标记为严重';
	@override String get makeAll => '将所有规则设为严重';
	@override String get makeAllHint => '将它们加入注入的上下文预算';
}

// Path: knowledge.errors
class Translations$knowledge$errors$zh_CN extends Translations$knowledge$errors$en {
	Translations$knowledge$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String importFailed({required Object error}) => '导入失败：${error}';
	@override String migrationFailed({required Object error}) => '迁移失败：${error}';
}

// Path: knowledge.graph
class Translations$knowledge$graph$zh_CN extends Translations$knowledge$graph$en {
	Translations$knowledge$graph$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get truncated => '已截断';
}

// Path: knowledge.importAll
class Translations$knowledge$importAll$zh_CN extends Translations$knowledge$importAll$en {
	Translations$knowledge$importAll$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get action => '导入全部';
	@override String get mergeDuplicates => '合并重复条目';
	@override String get mergeDuplicatesHint => '合并 ddagent 中的重复行（不涉及文件）';
	@override String projectsScanned({required Object count}) => '已扫描项目：${count}';
	@override String rulesSummary({required Object total, required Object duplicates}) => '规则：${total} · 重复组：${duplicates}';
	@override String skillsFound({required Object found, required Object newSkills}) => '发现的代理技能：${found}（新增：${newSkills}）';
	@override String get title => '将全部内容导入 ddagent';
}

// Path: knowledge.importSkills
class Translations$knowledge$importSkills$zh_CN extends Translations$knowledge$importSkills$en {
	Translations$knowledge$importSkills$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String found({required Object count}) => '在你的代理中找到 ${count} 个技能。';
	@override String summary({required Object imported, required Object skipped}) => '新增：${imported} · 已跳过：${skipped}';
	@override String get title => '导入代理技能';
}

// Path: knowledge.linkOptions
class Translations$knowledge$linkOptions$zh_CN extends Translations$knowledge$linkOptions$en {
	Translations$knowledge$linkOptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String memory({required Object title}) => '记忆：${title}';
	@override String personal({required Object title}) => '个人信息：${title}';
	@override String rule({required Object title}) => '规则：${title}';
	@override String skill({required Object name}) => '技能：${name}';
}

// Path: knowledge.migrate
class Translations$knowledge$migrate$zh_CN extends Translations$knowledge$migrate$en {
	Translations$knowledge$migrate$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String duplicates({required Object count}) => '跨项目的重复组：${count}';
	@override String get mergeDuplicates => '合并重复项';
	@override String removedPromoted({required Object removed, required Object promoted}) => '已移除：${removed}，已提升：${promoted}';
	@override String rulesSummary({required Object total, required Object critical}) => '规则：共 ${total} 条，${critical} 条严重。';
	@override String scanned({required Object count}) => '已扫描 ${count} 个项目。';
	@override String get title => '迁移现有规则';
}

// Path: skills.addDialog
class Translations$skills$addDialog$zh_CN extends Translations$skills$addDialog$en {
	Translations$skills$addDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => '选择 SKILL.md';
	@override String get chooseFiles => '选择文件';
	@override String get chooseFolder => '选择文件夹';
	@override String get chooseFolderTitle => '选择技能文件夹';
	@override String folderFilesMeta({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 个文件 · ${size}',
		other: '${count} 个文件 · ${size}',
	);
	@override String get folderUploadsNote => '文件夹上传会保留所选文件夹名称；单独文件使用 `SKILL.md` 中的 `name`。';
	@override String get hideInstallLocation => '隐藏安装位置';
	@override String get installSkill => '安装技能';
	@override String installSkills({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '安装 ${count} 个技能',
		other: '安装 ${count} 个技能',
	);
	@override String markdownFileMeta({required Object size}) => 'Markdown 文件 · ${size}';
	@override String get pickHint => '文件夹可包含脚本、参考资料和资源。';
	@override String get pickTitle => '选择技能文件夹或 SKILL.md';
	@override String get readyToInstall => '可以安装';
	@override String removeQueued({required Object name}) => '移除 ${name}';
	@override String title({required Object provider}) => '添加 ${provider} 技能';
	@override String get uploadHint => '上传 SKILL.md 文件或完整的技能文件夹。';
	@override String get whereWillThisInstall => '将安装到何处？';
}

// Path: skills.empty
class Translations$skills$empty$zh_CN extends Translations$skills$empty$en {
	Translations$skills$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noGlobalSkills => '尚未发现全局技能';
	@override String get noGlobalSkillsDescription => '在上方添加全局技能，使其可用于所有项目。';
	@override String get noMatchingSkills => '没有匹配的技能';
	@override String get noMatchingSkillsDescription => '请尝试其他命令、名称、范围、项目或来源路径。';
	@override String get noProjects => '没有可用的项目';
	@override String get noProjectsDescription => '添加项目或工作区以浏览其技能。';
	@override String get noSkillsInProject => '此项目中没有技能';
	@override String get noSkillsInProjectDescription => '在所选项目中创建 .claude/skills、.cursor/skills 或 .agents/skills 文件夹。';
}

// Path: skills.errors
class Translations$skills$errors$zh_CN extends Translations$skills$errors$en {
	Translations$skills$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get addMarkdownFirst => '请先添加一个或多个 Markdown 文件。';
	@override String couldNotReadSkillFile({required Object name}) => '无法从 ${name} 读取 SKILL.md。';
	@override String get dropMarkdownOrFolder => '拖入一个或多个 Markdown 文件，或包含 SKILL.md 的文件夹。';
	@override String folderFileLimit({required Object count}) => '一个技能文件夹最多可包含 ${count} 个文件。';
	@override String get folderReadFailed => '读取技能文件夹失败';
	@override String get folderSizeLimit => '所选技能文件夹的总大小必须小于 30 MB。';
	@override String get importFailed => '导入技能失败';
	@override String get missingSkillFile => '所选文件夹不包含 SKILL.md 文件。';
}

// Path: skills.moveDialog
class Translations$skills$moveDialog$zh_CN extends Translations$skills$moveDialog$en {
	Translations$skills$moveDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get moveToGlobal => '移动到全局';
	@override String get moveToProject => '移动到项目';
	@override String get toGlobalHint => '将此技能移入全局技能目录，以便所有项目都能使用。';
	@override String get toProjectHint => '选择应拥有此技能的项目。它将从提供商的全局技能目录中移出。';
}

// Path: skills.scopes
class Translations$skills$scopes$zh_CN extends Translations$skills$scopes$en {
	Translations$skills$scopes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get admin => '管理员';
	@override String get plugin => '插件';
	@override String get project => '项目';
	@override String get repo => '仓库';
	@override String get system => '系统';
	@override String get user => '用户';
}

// Path: skills.screen
class Translations$skills$screen$zh_CN extends Translations$skills$screen$en {
	Translations$skills$screen$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get addSkill => '添加技能';
	@override String get clearSearch => '清除技能搜索';
	@override String deleteDescription({required Object directory, required Object provider}) => '这会将 ${directory} 目录从 ${provider} 的托管技能目录中移除。此操作无法撤销。';
	@override String deleteTitle({required Object name}) => '删除 ${name}？';
	@override String loadingSkills({required Object provider}) => '正在加载 ${provider} 技能…';
	@override String manageDescription({required Object provider}) => '管理来自本地文件、完整文件夹和项目级位置的 ${provider} 技能。';
	@override String get noDescription => '技能的 front matter 中未提供描述。';
	@override String pluginBadge({required Object name}) => '插件：${name}';
	@override String projectBadge({required Object name}) => '项目：${name}';
	@override String get savedSuccessfully => '技能保存成功。';
	@override String get scanningProjectSkills => '正在扫描项目技能...';
	@override String get searchHint => '搜索技能...';
	@override String skillsCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '${count} 个技能',
		other: '${count} 个技能',
	);
	@override String get sourceLabel => '来源';
}

// Path: mcp.form
class Translations$mcp$form$zh_CN extends Translations$mcp$form$en {
	Translations$mcp$form$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$mcp$form$fields$zh_CN fields = Translations$mcp$form$fields$zh_CN.internal(_root);
	@override late final Translations$mcp$form$scope$zh_CN scope = Translations$mcp$form$scope$zh_CN.internal(_root);
	@override String submitTo({required Object provider}) => '将服务器添加到 ${provider}';
	@override late final Translations$mcp$form$validation$zh_CN validation = Translations$mcp$form$validation$zh_CN.internal(_root);
}

// Path: mcp.install
class Translations$mcp$install$zh_CN extends Translations$mcp$install$en {
	Translations$mcp$install$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get button => '安装';
	@override String get cardDescription => '通过 MCP 让你的代理使用知识库和 ddagent 工具 — 选择代理，或为全部安装。';
	@override String get description => '让所选代理通过 MCP 使用 ddagent 知识库和工具。';
	@override String get errorFallback => '错误';
	@override String failed({required Object error}) => '安装失败：${error}';
	@override String get installForAll => '为全部安装';
	@override String get installSelected => '安装到所选';
	@override String installedCount({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '已安装到 ${count} 个代理。',
		other: '已安装到 ${count} 个代理。',
	);
	@override String partialFailure({required Object count, required Object failed}) => '已安装到 ${count}；失败：${failed}';
	@override String get title => '安装 ddagent MCP 服务器';
}

// Path: mcp.servers
class Translations$mcp$servers$zh_CN extends Translations$mcp$servers$en {
	Translations$mcp$servers$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get addGlobalDescription => '将此 MCP 服务器添加到所有提供商：Claude、Cursor、Codex、OpenCode 和 Devin。仅支持 stdio 和 HTTP 传输，因为同一份配置必须在所有提供商中都能使用。';
	@override String get addGlobalMenuDescription => '添加全局 MCP 服务器会将一个通用的 stdio 或 HTTP 服务器写入 Claude、Cursor、Codex、OpenCode 和 Devin。';
	@override String get addGlobalTitle => '添加全局 MCP 服务器';
	@override String addProviderDescription({required Object provider}) => '添加 ${provider} MCP 服务器只会更改 ${provider}。';
	@override String addProviderTitle({required Object provider}) => '添加 ${provider} MCP 服务器';
	@override late final Translations$mcp$servers$config$zh_CN config = Translations$mcp$servers$config$zh_CN.internal(_root);
	@override String descriptionGeneric({required Object provider}) => 'Model Context Protocol 服务器为 ${provider} 提供额外的工具和数据源';
	@override String get loading => '正在加载 MCP 服务器...';
	@override String get refreshingScopes => '正在刷新项目范围...';
}

// Path: mcp.team
class Translations$mcp$team$zh_CN extends Translations$mcp$team$en {
	Translations$mcp$team$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cta => 'ddagent Pro 版可用';
	@override String get description => '在团队中共享 MCP 服务器配置。所有人自动保持同步。';
	@override String get title => '团队 MCP 配置';
}

// Path: mcp.tokens
class Translations$mcp$tokens$zh_CN extends Translations$mcp$tokens$en {
	Translations$mcp$tokens$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get scopeWrite => '写入';
}

// Path: terminal.actions
class Translations$terminal$actions$zh_CN extends Translations$terminal$actions$en {
	Translations$terminal$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get clearOutput => '清空输出';
	@override String get connect => '连接';
	@override String get newShell => '新建 Shell';
	@override String get newTab => '新建终端标签页';
	@override String get providerLogin => '提供商登录';
	@override String get restartSession => '重启会话';
}

// Path: terminal.authUrl
class Translations$terminal$authUrl$zh_CN extends Translations$terminal$authUrl$en {
	Translations$terminal$authUrl$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get openInBrowser => '在浏览器中打开';
}

// Path: terminal.errors
class Translations$terminal$errors$zh_CN extends Translations$terminal$errors$en {
	Translations$terminal$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String couldNotOpenLink({required Object url}) => '无法打开链接：${url}';
}

// Path: terminal.fileLink
class Translations$terminal$fileLink$zh_CN extends Translations$terminal$fileLink$en {
	Translations$terminal$fileLink$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String detected({required Object path}) => '检测到文件：${path}';
}

// Path: terminal.paste
class Translations$terminal$paste$zh_CN extends Translations$terminal$paste$en {
	Translations$terminal$paste$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Ctrl+V / 右键 → 粘贴';
	@override String get title => '粘贴到终端';
}

// Path: terminal.shortcuts
class Translations$terminal$shortcuts$zh_CN extends Translations$terminal$shortcuts$en {
	Translations$terminal$shortcuts$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get eof => 'EOF';
	@override String get hide => '隐藏快捷键栏';
	@override String get interrupt => '中断 (SIGINT)';
	@override String get suspend => '挂起 (SIGTSTP)';
	@override String get showTooltip => '显示快捷键';
	@override String get hideTooltip => '隐藏快捷键';
}

// Path: terminal.tabs
class Translations$terminal$tabs$zh_CN extends Translations$terminal$tabs$en {
	Translations$terminal$tabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get antigravityCli => 'Antigravity CLI';
	@override String get claudeCli => 'Claude CLI';
	@override String get commandCodeCli => 'Command Code CLI';
	@override String get cursorCli => 'Cursor CLI';
	@override String get devinCli => 'Devin CLI';
	@override String loginTitle({required Object provider}) => '登录：${provider}';
	@override String get opencodeCli => 'OpenCode CLI';
	@override String get plainShell => '普通 Shell';
	@override String shellName({required Object index}) => 'Shell ${index}';
}

// Path: quota.agents
class Translations$quota$agents$zh_CN extends Translations$quota$agents$en {
	Translations$quota$agents$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String statusCount({required Object status, required Object count}) => '${status}（${count}）';
}

// Path: quota.chart
class Translations$quota$chart$zh_CN extends Translations$quota$chart$en {
	Translations$quota$chart$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get hide => '隐藏';
	@override String get noData => '数据不足，无法显示趋势。';
	@override String pointReadout({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} 令牌 · ${cost}';
	@override String get show => '显示';
}

// Path: quota.config
class Translations$quota$config$zh_CN extends Translations$quota$config$en {
	Translations$quota$config$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get accountRouting => '账户路由';
	@override String get pollerTitle => '轮询与提醒';
	@override String get save => '保存配置';
}

// Path: quota.overview
class Translations$quota$overview$zh_CN extends Translations$quota$overview$en {
	Translations$quota$overview$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tokensAndCost => '令牌与成本';
}

// Path: quota.section
class Translations$quota$section$zh_CN extends Translations$quota$section$en {
	Translations$quota$section$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get config => '配置';
}

// Path: notifications.errors
class Translations$notifications$errors$zh_CN extends Translations$notifications$errors$en {
	Translations$notifications$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noResponse => '服务器无响应';
	@override String get registrationRejected => '注册被服务器拒绝';
}

// Path: serverConnect.local
class Translations$serverConnect$local$zh_CN extends Translations$serverConnect$local$en {
	Translations$serverConnect$local$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '本设备';
	@override String get subtitle => '在此计算机上运行 ddagent 服务器';
	@override String get install => '安装本地服务器';
	@override String get start => '启动本地服务器';
	@override String get stop => '停止';
	@override String get starting => '正在启动本地服务器…';
	@override String downloading({required Object percent}) => '正在下载服务器… ${percent}%';
	@override String get installing => '正在安装…';
	@override String running({required Object url}) => '正在 ${url} 上运行';
	@override String installed({required Object version}) => '已安装 (v${version})';
	@override String get connect => '使用此服务器';
	@override String error({required Object error}) => '本地服务器错误：${error}';
	@override String get or => '或连接到远程服务器';
}

// Path: collab.roles
class Translations$collab$roles$zh_CN extends Translations$collab$roles$en {
	Translations$collab$roles$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get member => '成员';
	@override String get viewer => '查看者';
}

// Path: sessions.activity
class Translations$sessions$activity$zh_CN extends Translations$sessions$activity$en {
	Translations$sessions$activity$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get committingChanges => '正在提交更改';
	@override String editingFile({required Object file}) => '正在编辑 ${file}';
	@override String get editingFileGeneric => '正在编辑文件';
	@override String fetchingUrl({required Object url}) => '正在获取 ${url}';
	@override String get pushingBranch => '正在推送分支';
	@override String readingFile({required Object file}) => '正在读取 ${file}';
	@override String runningCommand({required Object command}) => '正在运行 `${command}`';
	@override String get runningShellCommand => '正在运行 Shell 命令';
	@override String runningTool({required Object name}) => '正在运行 ${name}';
	@override String searching({required Object query}) => '正在搜索“${query}”';
	@override String get subagentRunning => '子代理运行中';
}

// Path: sessions.age
class Translations$sessions$age$zh_CN extends Translations$sessions$age$en {
	Translations$sessions$age$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String days({required Object days}) => '${days}天';
	@override String hours({required Object hours}) => '${hours}小时';
	@override String get lessThanMinute => '<1分钟';
	@override String minutes({required Object count}) => '${count}分钟';
}

// Path: sessions.toasts
class Translations$sessions$toasts$zh_CN extends Translations$sessions$toasts$en {
	Translations$sessions$toasts$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get archived => '会话已归档';
	@override String get deleted => '会话已删除';
	@override String get pinned => '会话已固定';
	@override String get renamed => '会话已重命名';
	@override String get restored => '会话已恢复';
	@override String get unpinned => '会话已取消固定';
	@override String get workspaceChanged => '工作区已更改';
}

// Path: git.checkpoints
class Translations$git$checkpoints$zh_CN extends Translations$git$checkpoints$en {
	Translations$git$checkpoints$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get create => '新建';
	@override String get empty => '还没有检查点';
	@override String get labelHint => '检查点标签（可选）';
	@override String get restoreMessage => '将工作树重置到此检查点？当前更改将被替换。';
	@override String get restoreTitle => '恢复检查点';
	@override String get restored => '检查点已恢复';
	@override String get title => '检查点';
}

// Path: kanban.card
class Translations$kanban$card$zh_CN extends Translations$kanban$card$en {
	Translations$kanban$card$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get untitled => '未命名';
}

// Path: kanban.comments
class Translations$kanban$comments$zh_CN extends Translations$kanban$comments$en {
	Translations$kanban$comments$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add => '添加评论';
	@override String get empty => '还没有评论';
}

// Path: kanban.details
class Translations$kanban$details$zh_CN extends Translations$kanban$details$en {
	Translations$kanban$details$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String status({required Object status}) => '状态：${status}';
	@override String get title => '卡片详情';
}

// Path: kanban.dialog
class Translations$kanban$dialog$zh_CN extends Translations$kanban$dialog$en {
	Translations$kanban$dialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get saving => '保存中…';
}

// Path: kanban.empty
class Translations$kanban$empty$zh_CN extends Translations$kanban$empty$en {
	Translations$kanban$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get noProject => '未选择项目';
}

// Path: kanban.time
class Translations$kanban$time$zh_CN extends Translations$kanban$time$en {
	Translations$kanban$time$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String daysAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '1 天前',
		other: '${count} 天前',
	);
	@override String hoursAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '1 小时前',
		other: '${count} 小时前',
	);
	@override String minutesAgo({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '1 分钟前',
		other: '${count} 分钟前',
	);
	@override String get now => '刚刚';
}

// Path: onboarding.agents
class Translations$onboarding$agents$zh_CN extends Translations$onboarding$agents$en {
	Translations$onboarding$agents$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => '登录一个或多个 AI 编程助手。全部为可选。';
	@override String get laterHint => '你可以稍后在设置中配置。';
	@override String get title => '连接你的 AI 代理';
}

// Path: onboarding.errors
class Translations$onboarding$errors$zh_CN extends Translations$onboarding$errors$en {
	Translations$onboarding$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get invalidEmail => '请输入有效的邮箱地址。';
	@override String get nameAndEmailRequired => 'git 名称和邮箱均为必填项。';
}

// Path: onboarding.mcp
class Translations$onboarding$mcp$zh_CN extends Translations$onboarding$mcp$en {
	Translations$onboarding$mcp$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => '安装 ddagent MCP 服务器，让你的代理可以使用知识库和 ddagent 工具。选择代理，或为全部安装。';
	@override String get installForAll => '为全部安装';
	@override String get installSelected => '安装到所选';
	@override String installedOn({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count,
		one: '已安装到 ${count} 个代理。',
		other: '已安装到 ${count} 个代理。',
	);
	@override String installedWithFailures({required Object installedCount, required Object failed}) => '已安装到 ${installedCount}；失败：${failed}';
	@override String get laterHint => '可选 — 你也可以稍后在设置 → MCP 中安装。';
	@override String get title => '将代理连接到 ddagent';
}

// Path: fileTree.search
class Translations$fileTree$search$zh_CN extends Translations$fileTree$search$en {
	Translations$fileTree$search$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get hint => '筛选名称 / 按 Enter 搜索内容';
	@override String get noMatches => '没有匹配项';
	@override String get prompt => '输入查询并按 Enter';
	@override String get resultsTruncated => '结果已截断';
}

// Path: fileTree.titles
class Translations$fileTree$titles$zh_CN extends Translations$fileTree$titles$en {
	Translations$fileTree$titles$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String delete({required Object name}) => '删除 ${name}';
	@override String download({required Object name}) => '下载 ${name}';
	@override String rename({required Object name}) => '重命名 ${name}';
}

// Path: auth.login.errors
class Translations$auth$login$errors$zh_CN extends Translations$auth$login$errors$en {
	Translations$auth$login$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get invalidCredentials => '用户名或密码无效';
	@override String get requiredFields => '请填写所有字段';
	@override String get networkError => '网络错误，请重试。';
}

// Path: auth.login.placeholders
class Translations$auth$login$placeholders$zh_CN extends Translations$auth$login$placeholders$en {
	Translations$auth$login$placeholders$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get username => '输入您的用户名';
	@override String get password => '输入您的密码';
}

// Path: auth.register.errors
class Translations$auth$register$errors$zh_CN extends Translations$auth$register$errors$en {
	Translations$auth$register$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get passwordMismatch => '密码不匹配';
	@override String get usernameTaken => '用户名已被占用';
	@override String get weakPassword => '密码强度太弱';
	@override String get usernameTooShort => '用户名至少需要 3 个字符';
	@override String get passwordTooShort => '密码至少需要 6 个字符';
}

// Path: chat.codex.modes
class Translations$chat$codex$modes$zh_CN extends Translations$chat$codex$modes$en {
	Translations$chat$codex$modes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '默认模式';
	@override String get auto => '自动模式';
	@override String get acceptEdits => '编辑模式';
	@override String get bypassPermissions => '无限制模式';
	@override String get plan => '计划模式';
}

// Path: chat.codex.descriptions
class Translations$chat$codex$descriptions$zh_CN extends Translations$chat$codex$descriptions$en {
	Translations$chat$codex$descriptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get kDefault => '只有受信任的命令（ls、cat、grep、git status 等）自动运行。其他命令将被跳过。可以写入工作区。';
	@override String get auto => '模型分类器决定每个工具调用是批准还是拒绝。高自主性。';
	@override String get acceptEdits => '工作区内的所有命令自动运行。完全自动模式，具有沙盒执行功能。';
	@override String get bypassPermissions => '完全的系统访问，无限制。所有命令自动运行，具有完整的磁盘和网络访问权限。请谨慎使用。';
	@override String get plan => '计划模式 - 不执行任何命令';
}

// Path: chat.input.hintText
class Translations$chat$input$hintText$zh_CN extends Translations$chat$input$hintText$en {
	Translations$chat$input$hintText$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get ctrlEnter => 'Ctrl+Enter 发送 • / 命令 • @ 文件';
	@override String get enter => 'Enter 发送 • Shift+Enter 换行 • / 命令 • @ 文件';
	@override String get queue => 'Enter 排队发送下一条消息';
	@override String get updateQueued => 'Enter 更新排队消息';
}

// Path: chat.input.queue
class Translations$chat$input$queue$zh_CN extends Translations$chat$input$queue$en {
	Translations$chat$input$queue$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get sendNext => '排队发送下一条消息';
	@override String get update => '更新排队消息';
	@override String get label => '已排队';
	@override String get willSend => '将在当前完成后发送';
	@override String get edit => '编辑排队消息';
	@override String get delete => '删除排队消息';
	@override String get failed => '发送失败';
	@override String get sendNow => '立即发送';
}

// Path: chat.input.offlineQueue
class Translations$chat$input$offlineQueue$zh_CN extends Translations$chat$input$offlineQueue$en {
	Translations$chat$input$offlineQueue$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get clear => '取消并清空离线队列';
	@override String get clearBtn => '取消';
	@override String multiple({required Object count}) => '${count} 条消息在离线队列中 — 重新连接后将自动发送';
	@override String get single => '1 条消息在离线队列中 — 重新连接后将自动发送';
}

// Path: chat.providerSelection.providerInfo
class Translations$chat$providerSelection$providerInfo$zh_CN extends Translations$chat$providerSelection$providerInfo$en {
	Translations$chat$providerSelection$providerInfo$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get anthropic => '由 Anthropic 提供';
	@override String get openai => '由 OpenAI 提供';
	@override String get cursorEditor => 'AI 代码编辑器';
	@override String get google => '由 Google 提供';
}

// Path: chat.providerSelection.readyPrompt
class Translations$chat$providerSelection$readyPrompt$zh_CN extends Translations$chat$providerSelection$readyPrompt$en {
	Translations$chat$providerSelection$readyPrompt$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String claude({required Object model}) => '准备好使用带有 ${model} 的 Claude。请在下方开始输入您的消息。';
	@override String cursor({required Object model}) => '准备好使用带有 ${model} 的 Cursor。请在下方开始输入您的消息。';
	@override String codex({required Object model}) => '准备好使用带有 ${model} 的 Codex。请在下方开始输入您的消息。';
	@override String opencode({required Object model}) => '准备好使用带有 ${model} 的 OpenCode。请在下方开始输入您的消息。';
	@override String get kDefault => '请在上方选择一个提供者以开始';
	@override String devin({required Object model}) => 'Devin ${model} 已就绪';
}

// Path: chat.session.kContinue
class Translations$chat$session$kContinue$zh_CN extends Translations$chat$session$kContinue$en {
	Translations$chat$session$kContinue$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '继续您的对话';
	@override String get description => '询问有关代码的问题、请求更改或获取开发任务的帮助';
	@override String get action => '继续输入';
}

// Path: chat.session.loading
class Translations$chat$session$loading$zh_CN extends Translations$chat$session$loading$en {
	Translations$chat$session$loading$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get olderMessages => '正在加载更早的消息...';
	@override String get sessionMessages => '正在加载会话消息...';
}

// Path: chat.session.messages
class Translations$chat$session$messages$zh_CN extends Translations$chat$session$messages$en {
	Translations$chat$session$messages$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String showingOf({required Object shown, required Object total}) => '显示 ${shown} / ${total} 条消息';
	@override String get scrollToLoad => '向上滚动以加载更多';
	@override String showingLast({required Object count, required Object total}) => '显示最近 ${count} 条消息（共 ${total} 条）';
	@override String get loadEarlier => '加载更早的消息';
	@override String get loadAll => '加载全部消息';
	@override String get loadingAll => '正在加载全部消息...';
	@override String get allLoaded => '全部消息已加载';
	@override String get perfWarning => '已加载全部消息 - 滚动可能变慢。点击「滚动到底部」恢复性能。';
	@override String get loadOlderFailed => '加载较早消息失败。';
	@override String get retry => '重试';
	@override String get noSearchMatches => '没有消息匹配搜索。';
	@override String loadAllCount({required Object count}) => '加载全部（${count}）';
	@override String get loadOlder => '加载更早的消息';
	@override String retryLoadOlder({required Object error}) => '重试加载更早的消息 — ${error}';
}

// Path: chat.shell.selectProject
class Translations$chat$shell$selectProject$zh_CN extends Translations$chat$shell$selectProject$en {
	Translations$chat$shell$selectProject$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '选择项目';
	@override String get description => '选择一个项目以在该目录中打开交互式 Shell';
}

// Path: chat.shell.status
class Translations$chat$shell$status$zh_CN extends Translations$chat$shell$status$en {
	Translations$chat$shell$status$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get newSession => '新会话';
	@override String get initializing => '初始化中...';
	@override String get restarting => '重启中...';
}

// Path: chat.shell.actions
class Translations$chat$shell$actions$zh_CN extends Translations$chat$shell$actions$en {
	Translations$chat$shell$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get disconnect => '断开连接';
	@override String get disconnectTitle => '断开 Shell 连接';
	@override String get restart => '重启';
	@override String get restartTitle => '重启 Shell（请先断开连接）';
	@override String get connect => '在 Shell 中继续';
	@override String get connectTitle => '连接到 Shell';
	@override String get kill => '终止 (SIGINT)';
	@override String get killTitle => '终止正在运行的进程 (Ctrl+C)';
	@override String get copyOutput => '复制输出';
	@override String get copyOutputTitle => '复制终端输出';
	@override String get copied => '已复制！';
	@override String get zoomInTitle => '放大';
	@override String get zoomOutTitle => '缩小';
}

// Path: chat.claudeStatus.actions
class Translations$chat$claudeStatus$actions$zh_CN extends Translations$chat$claudeStatus$actions$en {
	Translations$chat$claudeStatus$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get thinking => '思考中';
	@override String get processing => '处理中';
	@override String get analyzing => '分析中';
	@override String get working => '工作中';
	@override String get computing => '计算中';
	@override String get reasoning => '推理中';
}

// Path: chat.claudeStatus.state
class Translations$chat$claudeStatus$state$zh_CN extends Translations$chat$claudeStatus$state$en {
	Translations$chat$claudeStatus$state$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get live => '实时';
	@override String get paused => '已暂停';
}

// Path: chat.claudeStatus.elapsed
class Translations$chat$claudeStatus$elapsed$zh_CN extends Translations$chat$claudeStatus$elapsed$en {
	Translations$chat$claudeStatus$elapsed$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String seconds({required Object count}) => '${count}秒';
	@override String minutesSeconds({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s';
	@override String label({required Object time}) => '已用 ${time}';
	@override String get startingNow => '刚刚开始';
}

// Path: chat.claudeStatus.controls
class Translations$chat$claudeStatus$controls$zh_CN extends Translations$chat$claudeStatus$controls$en {
	Translations$chat$claudeStatus$controls$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get stopGeneration => '停止生成';
	@override String get pressEscToStop => '随时按 Esc 停止';
}

// Path: chat.claudeStatus.providers
class Translations$chat$claudeStatus$providers$zh_CN extends Translations$chat$claudeStatus$providers$en {
	Translations$chat$claudeStatus$providers$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get assistant => '助手';
}

// Path: chat.commandResult.fallback
class Translations$chat$commandResult$fallback$zh_CN extends Translations$chat$commandResult$fallback$en {
	Translations$chat$commandResult$fallback$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get config => '打开设置和配置。';
	@override String get cost => '查看当前会话的令牌用量。';
	@override String get help => '显示命令文档和语法。';
	@override String get memory => '打开项目的 CLAUDE.md 记忆文件。';
	@override String get models => '浏览当前提供商的可用模型。';
	@override String get status => '查看运行时、版本、提供商和环境状态。';
}

// Path: common.fileTree.context
class Translations$common$fileTree$context$zh_CN extends Translations$common$fileTree$context$en {
	Translations$common$fileTree$context$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get rename => '重命名';
	@override String get delete => '删除';
	@override String get copyPath => '复制路径';
	@override String get download => '下载';
	@override String get newFile => '新建文件';
	@override String get newFolder => '新建文件夹';
	@override String get upload => '上传文件';
	@override String get refresh => '刷新';
	@override String get menuLabel => '文件上下文菜单';
	@override String get loading => '加载中...';
}

// Path: common.fileTree.delete
class Translations$common$fileTree$delete$zh_CN extends Translations$common$fileTree$delete$en {
	Translations$common$fileTree$delete$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get confirm => '删除';
	@override String get fileWarning => '此文件将被永久删除。';
	@override String get folderWarning => '此文件夹及其所有内容将被永久删除。';
	@override String title({required Object type}) => '删除${type}';
}

// Path: common.fileTree.toast
class Translations$common$fileTree$toast$zh_CN extends Translations$common$fileTree$toast$en {
	Translations$common$fileTree$toast$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get copyFailed => '复制路径失败';
	@override String get fileCreated => '文件创建成功';
	@override String get fileDeleted => '文件已删除';
	@override String get folderCreated => '文件夹创建成功';
	@override String get folderDeleted => '文件夹已删除';
	@override String get folderDownloaded => '文件夹已下载为 ZIP';
	@override String get pathCopied => '路径已复制到剪贴板';
	@override String get renamed => '重命名成功';
}

// Path: common.fileTree.validation
class Translations$common$fileTree$validation$zh_CN extends Translations$common$fileTree$validation$en {
	Translations$common$fileTree$validation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dotsOnly => '文件名不能只包含点';
	@override String get emptyName => '文件名不能为空';
	@override String get invalidChars => '文件名包含无效字符';
	@override String get reserved => '文件名是保留名称';
}

// Path: common.projectWizard.steps
class Translations$common$projectWizard$steps$zh_CN extends Translations$common$projectWizard$steps$en {
	Translations$common$projectWizard$steps$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get type => '类型';
	@override String get configure => '配置';
	@override String get confirm => '确认';
}

// Path: common.projectWizard.step1
class Translations$common$projectWizard$step1$zh_CN extends Translations$common$projectWizard$step1$en {
	Translations$common$projectWizard$step1$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get question => '您已经有工作区，还是想创建一个新的工作区？';
	@override late final Translations$common$projectWizard$step1$existing$zh_CN existing = Translations$common$projectWizard$step1$existing$zh_CN.internal(_root);
	@override late final Translations$common$projectWizard$step1$kNew$zh_CN kNew = Translations$common$projectWizard$step1$kNew$zh_CN.internal(_root);
}

// Path: common.projectWizard.step2
class Translations$common$projectWizard$step2$zh_CN extends Translations$common$projectWizard$step2$en {
	Translations$common$projectWizard$step2$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get existingPath => '工作区路径';
	@override String get newPath => '工作区路径';
	@override String get existingPlaceholder => '/path/to/existing/workspace';
	@override String get newPlaceholder => '/path/to/new/workspace';
	@override String get existingHelp => '您现有工作区目录的完整路径';
	@override String get newHelp => '工作区目录的完整路径';
	@override String get githubUrl => 'GitHub URL（可选）';
	@override String get githubPlaceholder => 'https://github.com/username/repository';
	@override String get githubHelp => '可选：提供 GitHub URL 以克隆仓库';
	@override String get githubAuth => 'GitHub 身份验证（可选）';
	@override String get githubAuthHelp => '仅私有仓库需要。公共仓库无需身份验证即可克隆。';
	@override String get loadingTokens => '正在加载已保存的令牌...';
	@override String get storedToken => '已保存的令牌';
	@override String get newToken => '新令牌';
	@override String get nonePublic => '无（公共）';
	@override String get selectToken => '选择令牌';
	@override String get selectTokenPlaceholder => '-- 选择令牌 --';
	@override String get tokenPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
	@override String get tokenHelp => '此令牌仅用于此操作';
	@override String get publicRepoInfo => '公共仓库不需要身份验证。如果克隆公共仓库，可以跳过提供令牌。';
	@override String get noTokensHelp => '没有可用的已保存令牌。您可以在 设置 → API 密钥 中添加令牌以便重复使用。';
	@override String get optionalTokenPublic => 'GitHub 令牌（公共仓库可选）';
	@override String get tokenPublicPlaceholder => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx（公共仓库可留空）';
}

// Path: common.projectWizard.step3
class Translations$common$projectWizard$step3$zh_CN extends Translations$common$projectWizard$step3$en {
	Translations$common$projectWizard$step3$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get reviewConfig => '查看您的配置';
	@override String get existingWorkspace => '现有工作区';
	@override String get newWorkspace => '新建工作区';
	@override String get path => '路径：';
	@override String get cloneFrom => '克隆自：';
	@override String get authentication => '身份验证：';
	@override String get usingStoredToken => '使用已保存的令牌：';
	@override String get usingProvidedToken => '使用提供的令牌';
	@override String get noAuthentication => '无身份验证';
	@override String get sshKey => 'SSH 密钥';
	@override String get existingInfo => '工作区将被添加到您的项目列表中，并可用于 Claude/Cursor 会话。';
	@override String get newWithClone => '仓库将从此文件夹克隆。';
	@override String get newEmpty => '工作区将被添加到您的项目列表中，并可用于 Claude/Cursor 会话。';
	@override String get cloningRepository => '正在克隆仓库...';
}

// Path: common.projectWizard.buttons
class Translations$common$projectWizard$buttons$zh_CN extends Translations$common$projectWizard$buttons$en {
	Translations$common$projectWizard$buttons$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get back => '返回';
	@override String get next => '下一步';
	@override String get createProject => '创建项目';
	@override String get creating => '创建中...';
	@override String get cloning => '正在克隆...';
}

// Path: common.projectWizard.errors
class Translations$common$projectWizard$errors$zh_CN extends Translations$common$projectWizard$errors$en {
	Translations$common$projectWizard$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get selectType => '请选择您已有现有工作区还是想创建新工作区';
	@override String get providePath => '请提供工作区路径';
	@override String get failedToCreate => '创建工作区失败';
	@override String get failedToCreateFolder => '创建文件夹失败';
}

// Path: common.notifications.codes
class Translations$common$notifications$codes$zh_CN extends Translations$common$notifications$codes$en {
	Translations$common$notifications$codes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$zh_CN generic = Translations$common$notifications$codes$generic$zh_CN.internal(_root);
	@override late final Translations$common$notifications$codes$permission$zh_CN permission = Translations$common$notifications$codes$permission$zh_CN.internal(_root);
	@override late final Translations$common$notifications$codes$run$zh_CN run = Translations$common$notifications$codes$run$zh_CN.internal(_root);
	@override late final Translations$common$notifications$codes$agent$zh_CN agent = Translations$common$notifications$codes$agent$zh_CN.internal(_root);
}

// Path: common.versionUpdate.buttons
class Translations$common$versionUpdate$buttons$zh_CN extends Translations$common$versionUpdate$buttons$en {
	Translations$common$versionUpdate$buttons$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get close => '关闭';
	@override String get later => '稍后';
	@override String get copyCommand => '复制命令';
	@override String get updateNow => '立即更新';
	@override String get updating => '更新中...';
}

// Path: common.versionUpdate.ariaLabels
class Translations$common$versionUpdate$ariaLabels$zh_CN extends Translations$common$versionUpdate$ariaLabels$en {
	Translations$common$versionUpdate$ariaLabels$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get closeModal => '关闭版本升级模态框';
	@override String get showSidebar => '显示侧边栏';
	@override String get settings => '设置';
	@override String get updateAvailable => '有可用更新';
	@override String get closeSidebar => '关闭侧边栏';
}

// Path: common.quota.section
class Translations$common$quota$section$zh_CN extends Translations$common$quota$section$en {
	Translations$common$quota$section$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get overview => '概览';
	@override String get quotas => '额度';
	@override String get usage => '用量';
	@override String get agents => '代理';
}

// Path: common.quota.filter
class Translations$common$quota$filter$zh_CN extends Translations$common$quota$filter$en {
	Translations$common$quota$filter$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get all => '全部';
}

// Path: common.quota.period
class Translations$common$quota$period$zh_CN extends Translations$common$quota$period$en {
	Translations$common$quota$period$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7 天';
	@override String get k30d => '30 天';
	@override String get all => '全部';
}

// Path: common.quota.group
class Translations$common$quota$group$zh_CN extends Translations$common$quota$group$en {
	Translations$common$quota$group$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get provider => '提供商';
	@override String get model => '模型';
	@override String get agent => '代理';
	@override String get tool => '工具';
}

// Path: common.quota.metric
class Translations$common$quota$metric$zh_CN extends Translations$common$quota$metric$en {
	Translations$common$quota$metric$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tokens => '令牌';
	@override String get input => '输入';
	@override String get output => '输出';
	@override String get cache => '缓存读取';
	@override String get calls => 'API 调用';
	@override String get cost => '成本';
	@override String get sessions => '会话';
}

// Path: common.quota.cost
class Translations$common$quota$cost$zh_CN extends Translations$common$quota$cost$en {
	Translations$common$quota$cost$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get billed => '已计费（API + 超额）';
	@override String get listPrice => '已用令牌的标价';
	@override String get subscriptionValue => '订阅覆盖';
	@override String get cacheSavings => '缓存节省';
}

// Path: common.quota.cost3
class Translations$common$quota$cost3$zh_CN extends Translations$common$quota$cost3$en {
	Translations$common$quota$cost3$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get billed => '已计费（API + 超额）';
	@override String get listPrice => '已用令牌的标价';
	@override String get subscriptionValue => '订阅覆盖';
}

// Path: common.quota.overview
class Translations$common$quota$overview$zh_CN extends Translations$common$quota$overview$en {
	Translations$common$quota$overview$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '令牌与成本 — 最近 7 天';
	@override String get effectiveCost => '实际成本（7 天）';
	@override String get alertsTitle => '提醒';
	@override String get noAlerts => '目前没有需要注意的事项。';
	@override String get limitsTitle => '用量与限额';
	@override String get activeTasks => '活跃任务';
	@override String get viewAccounts => '所有账户';
	@override String get viewAgents => '所有代理';
	@override String get noTasks => '目前没有正在运行的代理。';
}

// Path: common.quota.usage
class Translations$common$quota$usage$zh_CN extends Translations$common$quota$usage$en {
	Translations$common$quota$usage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get trendTitle => '每日趋势';
	@override String breakdownTitle({required Object group}) => '按 ${group} 细分';
	@override String get colName => '名称';
	@override String get sourceUnavailable => '分析存储不可用；未显示数据。';
}

// Path: common.quota.agents
class Translations$common$quota$agents$zh_CN extends Translations$common$quota$agents$en {
	Translations$common$quota$agents$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String runningCount({required Object value}) => '${value} 个运行中';
	@override String get colAgent => '代理';
	@override String get colStatus => '状态';
	@override String get colTask => '任务';
	@override String get colModel => '账户 / 模型';
	@override String get colTime => '时间';
	@override String get empty => '没有代理匹配此筛选器。';
	@override String get detailSession => '会话';
	@override String get detailStarted => '已开始';
	@override String get detailRetries => '重试次数';
	@override String get detailResult => '结果';
	@override String get notTracked => '未跟踪';
}

// Path: common.quota.agentStatus
class Translations$common$quota$agentStatus$zh_CN extends Translations$common$quota$agentStatus$en {
	Translations$common$quota$agentStatus$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get running => '运行中';
	@override String get waiting => '等待中';
	@override String get failed => '失败';
	@override String get finished => '已完成';
	@override String get queued => '排队中';
}

// Path: common.quota.alert
class Translations$common$quota$alert$zh_CN extends Translations$common$quota$alert$en {
	Translations$common$quota$alert$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String pace({required Object account, required Object window, required Object value}) => '${account} · ${window}：按当前速度，额度将在 ${value} 后耗尽';
	@override String threshold({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}：已用 ${value}%（阈值 ${watch}%）';
}

// Path: common.quota.quality
class Translations$common$quota$quality$zh_CN extends Translations$common$quota$quality$en {
	Translations$common$quota$quality$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get live => '实时';
	@override String get cached => '缓存';
	@override String get estimate => '估计';
	@override String get unknown => '未知';
	@override String get error => '错误';
}

// Path: common.quota.kpi
class Translations$common$quota$kpi$zh_CN extends Translations$common$quota$kpi$en {
	Translations$common$quota$kpi$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get atRisk => '有风险的额度';
	@override String atRiskHint({required Object value}) => '超过 ${value}% 的账户';
	@override String get windowsAtRisk => '即将耗尽的窗口';
	@override String get errored => '同步失败';
	@override String get activeAgents => '活跃代理';
	@override String agentsHint({required Object waiting, required Object queued}) => '${waiting} 等待 · ${queued} 排队';
	@override String get nextReset => '下次重置';
	@override String get tokens => '令牌';
	@override String sessionsHint({required Object value}) => '${value} 个会话';
	@override String get cost => '预估成本';
	@override String costHint({required Object value}) => '${value} 由套餐覆盖';
}

// Path: common.quota.empty
class Translations$common$quota$empty$zh_CN extends Translations$common$quota$empty$en {
	Translations$common$quota$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '未连接任何账户';
	@override String get description => '登录 Claude、Codex、Gemini 或 CommandCode 即可在此跟踪额度。';
}

// Path: common.quota.settings
class Translations$common$quota$settings$zh_CN extends Translations$common$quota$settings$en {
	Translations$common$quota$settings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '提醒与路由';
	@override String get description => '控制仪表板何时警告你，以及如何为新工作推荐账户。';
	@override String get alertsEnabled => '预测与阈值提醒';
	@override String get alertsEnabledHint => '在额度按当前速度耗尽之前警告，而不是等到 90%。';
	@override String get watchThreshold => '观察阈值（%）';
	@override String get dangerThreshold => '危险阈值（%）';
	@override String get routingMode => '路由';
	@override late final Translations$common$quota$settings$routing$zh_CN routing = Translations$common$quota$settings$routing$zh_CN.internal(_root);
	@override String get logSources => '日志来源';
	@override String get logSourcesHint => '用量和代理屏幕读取这些只读来源。';
	@override String get quotaConsent => '允许额度轮询';
	@override String get quotaConsentHint => '使用你存储的凭据轮询提供商端点以读取实时额度。';
	@override String get perAccount => '按账户覆盖';
	@override String get tab => 'Control Center 设置';
}

// Path: common.quota.range
class Translations$common$quota$range$zh_CN extends Translations$common$quota$range$en {
	Translations$common$quota$range$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get k24h => '24h';
	@override String get k7d => '7d';
	@override String get k30d => '30d';
	@override String get all => '全部';
}

// Path: common.browserUse.empty
class Translations$common$browserUse$empty$zh_CN extends Translations$common$browserUse$empty$en {
	Translations$common$browserUse$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get descDisabled => '在设置中启用 Browser，让代理可以打开受监控的浏览器会话。';
	@override String get descEnabled => '当 AI 任务使用 Browser 时，代理浏览器会话会显示在这里。';
	@override String get titleDisabled => 'Browser 已禁用';
	@override String get titleEnabled => '暂无浏览器会话';
}

// Path: common.browserUse.errors
class Translations$common$browserUse$errors$zh_CN extends Translations$common$browserUse$errors$en {
	Translations$common$browserUse$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get actionFailed => '浏览器操作失败';
	@override String get loadFailed => 'Browser 加载失败';
}

// Path: common.browserUse.prompts
class Translations$common$browserUse$prompts$zh_CN extends Translations$common$browserUse$prompts$en {
	Translations$common$browserUse$prompts$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get prompt1 => '使用 Browser 检查结账流程并报告任何损坏的 UI 状态。';
	@override String get prompt2 => '用 Browser 打开 <url>，与页面交互，并总结每一步之后的变化。';
}

// Path: common.browserUse.relative
class Translations$common$browserUse$relative$zh_CN extends Translations$common$browserUse$relative$en {
	Translations$common$browserUse$relative$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get daysAgo => ' 天前';
	@override String get hoursAgo => ' 小时前';
	@override String get justNow => '刚刚';
	@override String get minutesAgo => ' 分钟前';
	@override String get never => '从未';
	@override String get secondsAgo => ' 秒前';
	@override String get unknown => '未知';
}

// Path: common.browserUse.runtime
class Translations$common$browserUse$runtime$zh_CN extends Translations$common$browserUse$runtime$en {
	Translations$common$browserUse$runtime$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get disabled => '已禁用';
	@override String get installing => '安装中';
	@override String get ready => '就绪';
	@override String get setupRequired => '需要设置';
}

// Path: common.commandPalette.browseAll
class Translations$common$commandPalette$browseAll$zh_CN extends Translations$common$commandPalette$browseAll$en {
	Translations$common$commandPalette$browseAll$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String branches({required Object count}) => '浏览所有分支（${count}）';
	@override String commits({required Object count}) => '浏览所有提交（${count}）';
	@override String files({required Object count}) => '浏览所有文件（${count}）';
	@override String sessions({required Object count}) => '浏览所有会话（${count}）';
}

// Path: common.commandPalette.compare
class Translations$common$commandPalette$compare$zh_CN extends Translations$common$commandPalette$compare$en {
	Translations$common$commandPalette$compare$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get costNote => '成本是基于已公布每令牌价格的客户端估算；未知模型显示“—”。';
	@override String get estCost => '预估成本';
	@override String get inputOutput => '输入 / 输出';
	@override String get model => '模型';
	@override String get na => '不适用';
	@override String get openSplit => '在分屏视图中打开';
	@override String get provider => '提供商';
	@override String get selectSession => '选择会话…';
	@override String get tokensUsed => '已用令牌';
}

// Path: common.commandPalette.groups
class Translations$common$commandPalette$groups$zh_CN extends Translations$common$commandPalette$groups$en {
	Translations$common$commandPalette$groups$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get actions => '操作';
	@override String get branches => '分支';
	@override String get commits => '提交';
	@override String get files => '文件';
	@override String get git => 'Git';
	@override String get navigate => '导航';
	@override String get sessions => '会话';
	@override String get settings => '设置';
}

// Path: common.commandPalette.hints
class Translations$common$commandPalette$hints$zh_CN extends Translations$common$commandPalette$hints$en {
	Translations$common$commandPalette$hints$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get close => '关闭';
	@override String get navigate => '导航';
	@override String get select => '选择';
	@override String get togglePalette => '切换面板';
}

// Path: common.commandPalette.items
class Translations$common$commandPalette$items$zh_CN extends Translations$common$commandPalette$items$en {
	Translations$common$commandPalette$items$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get compareSessions => '比较会话';
	@override String get gitFetch => 'Git：Fetch';
	@override String get gitPull => 'Git：Pull';
	@override String get gitPush => 'Git：Push';
	@override String get openSettings => '打开设置';
	@override String get selectProjectFirst => '请先选择一个项目';
	@override String settingsEntry({required Object label}) => '设置：${label}';
	@override String get startNewChat => '开始新聊天';
	@override String switchTo({required Object name}) => '切换到：${name}';
	@override String get toggleTheme => '切换主题';
	@override String get tokensAndCost => '令牌与成本';
}

// Path: common.commandPalette.nav
class Translations$common$commandPalette$nav$zh_CN extends Translations$common$commandPalette$nav$en {
	Translations$common$commandPalette$nav$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get board => '前往代理面板';
	@override String get chat => '前往聊天';
	@override String get files => '前往文件';
	@override String get git => '前往 Git';
	@override String get sourceControl => '前往源代码管理';
	@override String get tasks => '前往任务';
	@override String get usage => '前往配额与用量';
}

// Path: common.commandPalette.pages
class Translations$common$commandPalette$pages$zh_CN extends Translations$common$commandPalette$pages$en {
	Translations$common$commandPalette$pages$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get actions => '操作';
	@override String get branches => '分支';
	@override String get commits => '提交';
	@override String get compare => '比较';
	@override String get files => '文件';
	@override String get sessions => '会话';
}

// Path: common.gitPanel.branches
class Translations$common$gitPanel$branches$zh_CN extends Translations$common$gitPanel$branches$en {
	Translations$common$gitPanel$branches$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String confirmDelete({required Object branch}) => '删除分支“${branch}”？普通删除仅在分支完全合并时成功。此操作无法撤销。';
	@override String confirmSwitch({required Object branch}) => '切换到分支“${branch}”？请确保没有未提交的更改。';
	@override String countBoth({required Object local, required Object remote}) => '${local} 个本地，${remote} 个远程';
	@override String countLocal({required Object count}) => '${count} 个本地';
	@override String get current => '当前';
	@override String deleteTitle({required Object branch}) => '删除 ${branch}';
	@override String get emptyDesc => '创建一个分支以开始并行工作。';
	@override String get forceDelete => '强制删除';
	@override String get forceDeleteDesc => '即使分支包含未合并到其他地方的提交，也会永久删除该分支。';
	@override String get forceDeleteLabel => '强制删除此未合并的分支';
	@override String get local => '本地';
	@override String get kNew => '新建分支';
	@override String get noMatch => '没有匹配搜索的分支';
	@override String get none => '未找到分支';
	@override String get remote => '远程';
	@override String get kSwitch => '切换';
	@override String switchTo({required Object branch}) => '切换到 ${branch}';
}

// Path: common.gitPanel.confirmActions
class Translations$common$gitPanel$confirmActions$zh_CN extends Translations$common$gitPanel$confirmActions$en {
	Translations$common$gitPanel$confirmActions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get commit => '确认';
	@override String get delete => '删除';
	@override String get deleteBranch => '删除';
	@override String get discard => '放弃';
	@override String get publish => '发布';
	@override String get pull => '拉取';
	@override String get push => '推送';
	@override String get revertLocalCommit => '还原提交';
}

// Path: common.gitPanel.confirmTitles
class Translations$common$gitPanel$confirmTitles$zh_CN extends Translations$common$gitPanel$confirmTitles$en {
	Translations$common$gitPanel$confirmTitles$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get commit => '确认操作';
	@override String get delete => '删除文件';
	@override String get deleteBranch => '删除分支';
	@override String get discard => '放弃更改';
	@override String get publish => '发布分支';
	@override String get pull => '确认拉取';
	@override String get push => '确认推送';
	@override String get revertLocalCommit => '还原本地提交';
}

// Path: common.gitPanel.errors
class Translations$common$gitPanel$errors$zh_CN extends Translations$common$gitPanel$errors$en {
	Translations$common$gitPanel$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get createBranchFailed => '创建分支失败';
	@override String get createWorktreeFailed => '创建 worktree 失败';
	@override String get deleteBranchFailed => '删除分支失败';
	@override String get fetchFailed => 'Fetch 失败';
	@override String get initFailed => '初始化仓库失败';
	@override String get initialCommitFailed => '创建初始提交失败';
	@override String get mergeFailed => '合并失败';
	@override String get openWorktreeFailed => '打开 worktree 失败';
	@override String get operationFailed => 'Git 操作失败';
	@override String get publishFailed => '发布失败';
	@override String get pullFailed => 'Pull 失败';
	@override String get pushFailed => 'Push 失败';
	@override String get removeWorktreeFailed => '移除 worktree 失败';
	@override String get stageFailed => '暂存失败';
	@override String get stageHunksFailed => '暂存区块失败';
	@override String get switchFailed => '切换分支失败';
	@override String get unstageFailed => '取消暂存失败';
	@override String get unstageHunksFailed => '取消区块暂存失败';
}

// Path: common.gitPanel.history
class Translations$common$gitPanel$history$zh_CN extends Translations$common$gitPanel$history$en {
	Translations$common$gitPanel$history$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get added => '已添加';
	@override String get author => '作者';
	@override String get changedFiles => '已更改文件';
	@override String get date => '日期';
	@override String get empty => '未找到提交';
	@override String get files => '文件';
	@override String get removed => '已移除';
}

// Path: common.gitPanel.mergeWorktree
class Translations$common$gitPanel$mergeWorktree$zh_CN extends Translations$common$gitPanel$mergeWorktree$en {
	Translations$common$gitPanel$mergeWorktree$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cleanupDesc => '合并后移除 worktree 并删除其分支';
	@override String get cleanupLabel => '合并后清理';
	@override String commitCount({required Object count}) => '${count} 个提交';
	@override String get merge => '合并';
	@override String mergeMessage({required Object branch}) => '合并分支 \'${branch}\'';
	@override String get messageLabel => '提交消息';
	@override String squashDesc({required Object commits, required Object branch}) => '将全部 ${commits} 个提交合并为 ${branch} 上的单个提交';
	@override String get squashLabel => '压缩提交（squash）';
	@override String get squashMerge => '压缩并合并';
	@override String squashMessage({required Object branch}) => '压缩合并分支 \'${branch}\'';
	@override String get title => '合并 Worktree';
}

// Path: common.gitPanel.newBranch
class Translations$common$gitPanel$newBranch$zh_CN extends Translations$common$gitPanel$newBranch$en {
	Translations$common$gitPanel$newBranch$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String fromCurrent({required Object branch}) => '这将从当前分支（${branch}）创建新分支';
	@override String get nameLabel => '分支名称';
	@override String get submit => '创建分支';
	@override String get title => '创建新分支';
}

// Path: common.gitPanel.newWorktree
class Translations$common$gitPanel$newWorktree$zh_CN extends Translations$common$gitPanel$newWorktree$en {
	Translations$common$gitPanel$newWorktree$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get branchLabel => '分支';
	@override String get createFrom => '创建自';
	@override String get description => '将分支检出到独立文件夹中并并行工作。';
	@override String get existingBranch => '现有分支 — 将按原样检出。';
	@override String get submit => '创建 Worktree';
	@override String get switchAfter => '创建后切换到该 worktree';
	@override String get title => '新建 Worktree';
	@override String get willCreateIn => '将创建于';
}

// Path: common.gitPanel.noCommits
class Translations$common$gitPanel$noCommits$zh_CN extends Translations$common$gitPanel$noCommits$en {
	Translations$common$gitPanel$noCommits$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get create => '创建初始提交';
	@override String get creating => '正在创建初始提交...';
	@override String get description => '此仓库还没有任何提交。创建第一个提交以开始跟踪更改。';
	@override String get title => '尚无提交';
}

// Path: common.gitPanel.noRepo
class Translations$common$gitPanel$noRepo$zh_CN extends Translations$common$gitPanel$noRepo$en {
	Translations$common$gitPanel$noRepo$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => '此项目还不是 git 仓库。初始化一个以开始跟踪更改并使用源代码管理功能。';
	@override String get init => '运行 git init';
	@override String get initializing => '正在初始化仓库...';
	@override String get title => '没有 git 仓库';
}

// Path: common.gitPanel.removeWorktree
class Translations$common$gitPanel$removeWorktree$zh_CN extends Translations$common$gitPanel$removeWorktree$en {
	Translations$common$gitPanel$removeWorktree$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get alsoDelete => '同时删除分支';
	@override String description({required Object branch}) => '移除 ${branch} 的 worktree？其文件夹将被删除，关联的项目将被归档 — 聊天会话仍可恢复。';
	@override String dirtyWarning({required Object count}) => '此 worktree 有 ${count} 个未提交的更改将会丢失。';
	@override String get discardChanges => '放弃未提交的更改';
	@override String get title => '移除 Worktree';
}

// Path: common.gitPanel.status
class Translations$common$gitPanel$status$zh_CN extends Translations$common$gitPanel$status$en {
	Translations$common$gitPanel$status$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get added => '已添加';
	@override String get deleted => '已删除';
	@override String get modified => '已修改';
	@override String get untracked => '未跟踪';
}

// Path: common.gitPanel.worktrees
class Translations$common$gitPanel$worktrees$zh_CN extends Translations$common$gitPanel$worktrees$en {
	Translations$common$gitPanel$worktrees$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String changes({required Object count}) => '${count} 个更改';
	@override String count({required Object count}) => '${count} 个 worktree';
	@override String get createFirst => '创建你的第一个 worktree';
	@override String get detached => '分离';
	@override String detachedAt({required Object sha}) => '分离 @ ${sha}';
	@override String get detachedHead => '分离的 HEAD';
	@override String get emptyDesc => 'worktree 将分支检出到独立文件夹，因此你可以并行运行独立的聊天会话，并在就绪后合并结果。';
	@override String get emptyTitle => '并行处理多个分支';
	@override String get locked => '已锁定';
	@override String get mainWorktree => '主 worktree';
	@override String mergeTitle({required Object branch}) => '将 ${branch} 合并到基础分支';
	@override String get kNew => '新建 worktree';
	@override String get none => '没有 worktree';
	@override String get nothingToMerge => '无可合并内容 — 没有领先于基础分支的提交';
	@override String get open => '打开';
	@override String get refresh => '刷新 worktree';
	@override String removeTitle({required Object branch}) => '移除 ${branch} 的 worktree';
	@override String switchTo({required Object branch}) => '切换到 ${branch}';
}

// Path: common.gitPanel.tabs
class Translations$common$gitPanel$tabs$zh_CN extends Translations$common$gitPanel$tabs$en {
	Translations$common$gitPanel$tabs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get changes => '更改';
	@override String get history => '提交';
	@override String get branches => '分支';
	@override String get worktrees => '工作树';
}

// Path: settings.mcp.scope
class Translations$settings$mcp$scope$zh_CN extends Translations$settings$mcp$scope$en {
	Translations$settings$mcp$scope$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '范围';
	@override String get user => '用户';
	@override String get project => '项目';
}

// Path: settings.appearance.themeModes
class Translations$settings$appearance$themeModes$zh_CN extends Translations$settings$appearance$themeModes$en {
	Translations$settings$appearance$themeModes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dark => '深色';
	@override String get light => '浅色';
	@override String get system => '跟随系统';
}

// Path: settings.quickSettings.sections
class Translations$settings$quickSettings$sections$zh_CN extends Translations$settings$quickSettings$sections$en {
	Translations$settings$quickSettings$sections$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外观';
	@override String get toolDisplay => '工具显示';
	@override String get inputSettings => '输入设置';
}

// Path: settings.quickSettings.dragHandle
class Translations$settings$quickSettings$dragHandle$zh_CN extends Translations$settings$quickSettings$dragHandle$en {
	Translations$settings$quickSettings$dragHandle$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get dragging => '正在拖拽手柄';
	@override String get closePanel => '关闭设置面板';
	@override String get openPanel => '打开设置面板';
	@override String get draggingStatus => '正在拖拽...';
	@override String get toggleAndMove => '点击切换，拖拽移动';
}

// Path: settings.terminalShortcuts.handle
class Translations$settings$terminalShortcuts$handle$zh_CN extends Translations$settings$terminalShortcuts$handle$en {
	Translations$settings$terminalShortcuts$handle$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get closePanel => '关闭快捷键面板';
	@override String get openPanel => '打开快捷键面板';
}

// Path: settings.orchestration.enable
class Translations$settings$orchestration$enable$zh_CN extends Translations$settings$orchestration$enable$en {
	Translations$settings$orchestration$enable$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enable orchestration';
	@override String get description => 'Let the orchestrator pick a model per step instead of running everything on one provider.';
}

// Path: settings.orchestration.pool
class Translations$settings$orchestration$pool$zh_CN extends Translations$settings$orchestration$pool$en {
	Translations$settings$orchestration$pool$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Candidate pool';
	@override String get description => 'Models the router can pick from, each pinned to a cost tier.';
	@override String get add => 'Add candidate';
	@override String get empty => 'No candidates yet — add one to start routing.';
	@override late final Translations$settings$orchestration$pool$fields$zh_CN fields = Translations$settings$orchestration$pool$fields$zh_CN.internal(_root);
}

// Path: settings.orchestration.tiers
class Translations$settings$orchestration$tiers$zh_CN extends Translations$settings$orchestration$tiers$en {
	Translations$settings$orchestration$tiers$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get free => 'Free';
	@override String get cheap => 'Cheap';
	@override String get mid => 'Mid';
	@override String get premium => 'Premium';
}

// Path: settings.orchestration.rules
class Translations$settings$orchestration$rules$zh_CN extends Translations$settings$orchestration$rules$en {
	Translations$settings$orchestration$rules$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Routing rules';
	@override String get description => 'Ordered candidates per task type — the first available one wins.';
	@override String get addCandidate => 'Add candidate…';
	@override String get empty => 'No candidates — nothing to route this task type to.';
	@override String get missing => '(removed)';
	@override String get remove => 'Remove candidate';
	@override late final Translations$settings$orchestration$rules$taskTypes$zh_CN taskTypes = Translations$settings$orchestration$rules$taskTypes$zh_CN.internal(_root);
}

// Path: settings.orchestration.planner
class Translations$settings$orchestration$planner$zh_CN extends Translations$settings$orchestration$planner$en {
	Translations$settings$orchestration$planner$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planner';
	@override String get description => 'How a request is split into routed steps.';
	@override String get modeLabel => 'Planning mode';
	@override late final Translations$settings$orchestration$planner$modes$zh_CN modes = Translations$settings$orchestration$planner$modes$zh_CN.internal(_root);
	@override late final Translations$settings$orchestration$planner$modeHints$zh_CN modeHints = Translations$settings$orchestration$planner$modeHints$zh_CN.internal(_root);
	@override String get candidateLabel => 'Planner model';
	@override String get candidateDescription => 'Pool candidate used for plan generation and classification calls.';
	@override String get candidatePlaceholder => 'Select a pool candidate';
	@override late final Translations$settings$orchestration$planner$templates$zh_CN templates = Translations$settings$orchestration$planner$templates$zh_CN.internal(_root);
	@override String get requireConfirm => 'Confirm plan before running';
	@override String get requireConfirmDescription => 'Pause after planning so you can edit or disable steps on the plan card.';
}

// Path: settings.orchestration.execution
class Translations$settings$orchestration$execution$zh_CN extends Translations$settings$orchestration$execution$en {
	Translations$settings$orchestration$execution$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Execution limits';
	@override String get description => 'Guardrails for parallel runs and fix loops.';
	@override String get maxParallel => 'Max parallel steps';
	@override String get maxParallelDescription => 'How many subtasks may run at once (1–8).';
	@override String get maxFixLoops => 'Max fix loops';
	@override String get maxFixLoopsDescription => 'Retries when a step fails verification (0–5).';
	@override String get onNoCandidate => 'When no candidate is available';
	@override String get onNoCandidateDescription => 'Ask before falling back, or skip the step.';
	@override late final Translations$settings$orchestration$execution$onNoCandidateOptions$zh_CN onNoCandidateOptions = Translations$settings$orchestration$execution$onNoCandidateOptions$zh_CN.internal(_root);
	@override String get useWorktree => 'Isolated worktree';
	@override String get useWorktreeDescription => 'Run all delegated steps in one shared git worktree instead of the project directory.';
}

// Path: settings.orchestration.save
class Translations$settings$orchestration$save$zh_CN extends Translations$settings$orchestration$save$en {
	Translations$settings$orchestration$save$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class Translations$settings$notifications$webPush$zh_CN extends Translations$settings$notifications$webPush$en {
	Translations$settings$notifications$webPush$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '通知此浏览器';
	@override String get enable => '启用通知';
	@override String get disable => '关闭通知';
	@override String get enabled => '此浏览器已启用通知';
	@override String get loading => '更新中...';
	@override String get unsupported => '此浏览器不支持推送通知。';
	@override String get denied => '推送通知已被阻止，请在浏览器设置中允许。';
	@override String get iosHint => '在 iPhone/iPad 上，只有将 ddagent 添加到主屏幕（分享 → 添加到主屏幕）并在安装的应用中启用通知后，通知才有效。';
	@override String get test => '发送测试通知';
	@override String get testNoSubscription => '没有已订阅的设备。请先在手机上点击“启用”。';
	@override String testSuccess({required Object count}) => '已发送到 ${count} 台设备。如果手机上没有显示，请将 ddagent 添加到主屏幕（iOS 要求）。';
	@override String get testNotDelivered => '没有可访问的设备。请确保应用正在运行且通知已启用。';
}

// Path: settings.notifications.device
class Translations$settings$notifications$device$zh_CN extends Translations$settings$notifications$device$en {
	Translations$settings$notifications$device$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '通知此设备';
	@override String get enabled => '此设备的通知已启用';
}

// Path: settings.notifications.desktop
class Translations$settings$notifications$desktop$zh_CN extends Translations$settings$notifications$desktop$en {
	Translations$settings$notifications$desktop$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '通知此桌面应用';
	@override String get enable => '启用通知';
	@override String get disable => '关闭通知';
	@override String get enabled => '此桌面应用已启用通知';
	@override String get unsupported => '此系统不支持桌面通知。';
}

// Path: settings.notifications.sound
class Translations$settings$notifications$sound$zh_CN extends Translations$settings$notifications$sound$en {
	Translations$settings$notifications$sound$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '声音';
	@override String get description => '聊天运行完成时播放短提示音。';
	@override String get enabled => '已启用';
	@override String get test => '测试声音';
}

// Path: settings.notifications.events
class Translations$settings$notifications$events$zh_CN extends Translations$settings$notifications$events$en {
	Translations$settings$notifications$events$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '事件类型';
	@override String get actionRequired => '需要处理';
	@override String get stop => '运行已停止';
	@override String get error => '运行失败';
}

// Path: settings.notifications.channels
class Translations$settings$notifications$channels$zh_CN extends Translations$settings$notifications$channels$en {
	Translations$settings$notifications$channels$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get discord => 'Discord';
	@override String get telegram => 'Telegram';
}

// Path: settings.appearanceSettings.darkMode
class Translations$settings$appearanceSettings$darkMode$zh_CN extends Translations$settings$appearanceSettings$darkMode$en {
	Translations$settings$appearanceSettings$darkMode$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '深色模式';
	@override String get description => '切换浅色和深色主题';
}

// Path: settings.appearanceSettings.codeEditor
class Translations$settings$appearanceSettings$codeEditor$zh_CN extends Translations$settings$appearanceSettings$codeEditor$en {
	Translations$settings$appearanceSettings$codeEditor$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '代码编辑器';
	@override late final Translations$settings$appearanceSettings$codeEditor$theme$zh_CN theme = Translations$settings$appearanceSettings$codeEditor$theme$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_CN wordWrap = Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_CN showMinimap = Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_CN lineNumbers = Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_CN.internal(_root);
	@override late final Translations$settings$appearanceSettings$codeEditor$fontSize$zh_CN fontSize = Translations$settings$appearanceSettings$codeEditor$fontSize$zh_CN.internal(_root);
}

// Path: settings.appearanceSettings.terminal
class Translations$settings$appearanceSettings$terminal$zh_CN extends Translations$settings$appearanceSettings$terminal$en {
	Translations$settings$appearanceSettings$terminal$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '终端';
	@override late final Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_CN focusFollowsPointer = Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_CN.internal(_root);
}

// Path: settings.mcpForm.title
class Translations$settings$mcpForm$title$zh_CN extends Translations$settings$mcpForm$title$en {
	Translations$settings$mcpForm$title$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add => '添加 MCP 服务器';
	@override String get edit => '编辑 MCP 服务器';
}

// Path: settings.mcpForm.importMode
class Translations$settings$mcpForm$importMode$zh_CN extends Translations$settings$mcpForm$importMode$en {
	Translations$settings$mcpForm$importMode$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get form => '表单输入';
	@override String get json => 'JSON 导入';
}

// Path: settings.mcpForm.scope
class Translations$settings$mcpForm$scope$zh_CN extends Translations$settings$mcpForm$scope$en {
	Translations$settings$mcpForm$scope$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '范围';
	@override String get userGlobal => '用户（全局）';
	@override String get projectLocal => '项目（本地）';
	@override String get userDescription => '用户范围：在您机器上的所有项目中可用';
	@override String get projectDescription => '本地范围：仅在选定项目中可用';
	@override String get cannotChange => '编辑现有服务器时无法更改范围';
}

// Path: settings.mcpForm.fields
class Translations$settings$mcpForm$fields$zh_CN extends Translations$settings$mcpForm$fields$en {
	Translations$settings$mcpForm$fields$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get serverName => '服务器名称';
	@override String get transportType => '传输类型';
	@override String get command => '命令';
	@override String get arguments => '参数（每行一个）';
	@override String get jsonConfig => 'JSON 配置';
	@override String get url => 'URL';
	@override String get envVars => '环境变量（KEY=值，每行一个）';
	@override String get headers => '请求头（KEY=值，每行一个）';
	@override String get selectProject => '选择项目...';
}

// Path: settings.mcpForm.placeholders
class Translations$settings$mcpForm$placeholders$zh_CN extends Translations$settings$mcpForm$placeholders$en {
	Translations$settings$mcpForm$placeholders$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get serverName => '我的服务';
}

// Path: settings.mcpForm.validation
class Translations$settings$mcpForm$validation$zh_CN extends Translations$settings$mcpForm$validation$en {
	Translations$settings$mcpForm$validation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get missingType => '缺少必填字段：type';
	@override String get stdioRequiresCommand => 'stdio 类型需要 command 字段';
	@override String httpRequiresUrl({required Object type}) => '${type} 类型需要 url 字段';
	@override String get invalidJson => '无效的 JSON 格式';
	@override String get jsonHelp => '粘贴您的 MCP 服务器配置（JSON 格式）。示例格式：';
	@override String get jsonExampleStdio => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}';
	@override String get jsonExampleHttp => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}';
}

// Path: settings.mcpForm.actions
class Translations$settings$mcpForm$actions$zh_CN extends Translations$settings$mcpForm$actions$en {
	Translations$settings$mcpForm$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get saving => '保存中...';
	@override String get addServer => '添加服务器';
	@override String get updateServer => '更新服务器';
}

// Path: settings.git.name
class Translations$settings$git$name$zh_CN extends Translations$settings$git$name$en {
	Translations$settings$git$name$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git 名称';
	@override String get help => '您的 git 提交名称';
	@override String get placeholder => 'John Doe';
}

// Path: settings.git.email
class Translations$settings$git$email$zh_CN extends Translations$settings$git$email$en {
	Translations$settings$git$email$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Git 邮箱';
	@override String get help => '您的 git 提交邮箱';
	@override String get placeholder => 'john@example.com';
}

// Path: settings.git.actions
class Translations$settings$git$actions$zh_CN extends Translations$settings$git$actions$en {
	Translations$settings$git$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get save => '保存配置';
	@override String get saving => '保存中...';
}

// Path: settings.git.status
class Translations$settings$git$status$zh_CN extends Translations$settings$git$status$en {
	Translations$settings$git$status$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get success => '保存成功';
	@override String get error => '保存失败';
}

// Path: settings.apiKeys.newKey
class Translations$settings$apiKeys$newKey$zh_CN extends Translations$settings$apiKeys$newKey$en {
	Translations$settings$apiKeys$newKey$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get alertTitle => '⚠️ 保存您的 API 密钥';
	@override String get alertMessage => '这是您唯一一次看到此密钥。请妥善保存。';
	@override String get iveSavedIt => '我已保存';
}

// Path: settings.apiKeys.form
class Translations$settings$apiKeys$form$zh_CN extends Translations$settings$apiKeys$form$en {
	Translations$settings$apiKeys$form$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'API 密钥名称（例如：生产服务器）';
	@override String get createButton => '创建';
	@override String get cancelButton => '取消';
}

// Path: settings.apiKeys.list
class Translations$settings$apiKeys$list$zh_CN extends Translations$settings$apiKeys$list$en {
	Translations$settings$apiKeys$list$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get created => '创建时间：';
	@override String get lastUsed => '最后使用：';
}

// Path: settings.apiKeys.status
class Translations$settings$apiKeys$status$zh_CN extends Translations$settings$apiKeys$status$en {
	Translations$settings$apiKeys$status$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get active => '激活';
	@override String get inactive => '未激活';
}

// Path: settings.apiKeys.github
class Translations$settings$apiKeys$github$zh_CN extends Translations$settings$apiKeys$github$en {
	Translations$settings$apiKeys$github$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'GitHub 令牌';
	@override String get description => '添加 GitHub 个人访问令牌以通过外部 API 克隆私有仓库。';
	@override String get descriptionAlt => '添加 GitHub 个人访问令牌以克隆私有仓库。您也可以直接在 API 请求中传递令牌而无需存储。';
	@override String get addButton => '添加令牌';
	@override late final Translations$settings$apiKeys$github$form$zh_CN form = Translations$settings$apiKeys$github$form$zh_CN.internal(_root);
	@override String get empty => '尚未添加 GitHub 令牌。';
	@override String get added => '添加时间：';
	@override String get confirmDelete => '确定要删除此 GitHub 令牌吗？';
}

// Path: settings.apiKeys.documentation
class Translations$settings$apiKeys$documentation$zh_CN extends Translations$settings$apiKeys$documentation$en {
	Translations$settings$apiKeys$documentation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '外部 API 文档';
	@override String get description => '了解如何使用外部 API 从您的应用程序触发 Claude/Cursor 会话。';
	@override String get viewLink => '查看 API 文档 →';
}

// Path: settings.apiKeys.version
class Translations$settings$apiKeys$version$zh_CN extends Translations$settings$apiKeys$version$en {
	Translations$settings$apiKeys$version$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String updateAvailable({required Object version}) => '有可用更新：v${version}';
}

// Path: settings.tasks.notInstalled
class Translations$settings$tasks$notInstalled$zh_CN extends Translations$settings$tasks$notInstalled$en {
	Translations$settings$tasks$notInstalled$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '未安装 TaskMaster AI CLI';
	@override String get description => '需要 TaskMaster CLI 才能使用任务管理功能。安装它以开始使用：';
	@override String get installCommand => 'npm install -g task-master-ai';
	@override String get viewOnGitHub => '在 GitHub 上查看';
	@override String get afterInstallation => '安装后：';
	@override late final Translations$settings$tasks$notInstalled$steps$zh_CN steps = Translations$settings$tasks$notInstalled$steps$zh_CN.internal(_root);
}

// Path: settings.tasks.settings
class Translations$settings$tasks$settings$zh_CN extends Translations$settings$tasks$settings$en {
	Translations$settings$tasks$settings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get enableLabel => '启用 TaskMaster 集成';
	@override String get enableDescription => '在整个界面中显示 TaskMaster 任务、横幅和侧边栏指示器';
}

// Path: settings.agents.authStatus
class Translations$settings$agents$authStatus$zh_CN extends Translations$settings$agents$authStatus$en {
	Translations$settings$agents$authStatus$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get checking => '检查中...';
	@override String get connected => '已连接';
	@override String get notConnected => '未连接';
	@override String get disconnected => '已断开';
	@override String get checkingAuth => '正在检查认证状态...';
	@override String loggedInAs({required Object email}) => '登录为 ${email}';
	@override String providerAccount({required Object provider}) => '${provider} 账户';
	@override String get authenticatedUser => '已认证用户';
}

// Path: settings.agents.install
class Translations$settings$agents$install$zh_CN extends Translations$settings$agents$install$en {
	Translations$settings$agents$install$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String title({required Object agent}) => '未安装 ${agent} CLI';
	@override String description({required Object agent}) => '安装 ${agent} CLI 以登录并运行会话。';
	@override String get button => '安装';
	@override String get installing => '安装中…';
	@override String get copyCommand => '复制命令';
	@override String get docs => '文档';
	@override String success({required Object agent}) => '${agent} CLI 已安装';
	@override String get failed => '安装失败 — 请检查终端输出';
}

// Path: settings.agents.account
class Translations$settings$agents$account$zh_CN extends Translations$settings$agents$account$en {
	Translations$settings$agents$account$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$agents$account$claude$zh_CN claude = Translations$settings$agents$account$claude$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$cursor$zh_CN cursor = Translations$settings$agents$account$cursor$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$codex$zh_CN codex = Translations$settings$agents$account$codex$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$opencode$zh_CN opencode = Translations$settings$agents$account$opencode$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$commandcode$zh_CN commandcode = Translations$settings$agents$account$commandcode$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$antigravity$zh_CN antigravity = Translations$settings$agents$account$antigravity$zh_CN.internal(_root);
	@override late final Translations$settings$agents$account$devin$zh_CN devin = Translations$settings$agents$account$devin$zh_CN.internal(_root);
}

// Path: settings.agents.login
class Translations$settings$agents$login$zh_CN extends Translations$settings$agents$login$en {
	Translations$settings$agents$login$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '登录';
	@override String get reAuthenticate => '重新认证';
	@override String description({required Object agent}) => '登录您的 ${agent} 账户以启用 AI 功能';
	@override String get reAuthDescription => '使用其他账户登录或刷新凭据';
	@override String get button => '登录';
	@override String get reLoginButton => '重新登录';
}

// Path: settings.permissions.skipPermissions
class Translations$settings$permissions$skipPermissions$zh_CN extends Translations$settings$permissions$skipPermissions$en {
	Translations$settings$permissions$skipPermissions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '跳过权限提示（请谨慎使用）';
	@override String get claudeDescription => '等同于 --dangerously-skip-permissions 标志';
	@override String get cursorDescription => '等同于 Cursor CLI 中的 -f 标志';
}

// Path: settings.permissions.allowedTools
class Translations$settings$permissions$allowedTools$zh_CN extends Translations$settings$permissions$allowedTools$en {
	Translations$settings$permissions$allowedTools$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '允许的工具';
	@override String get description => '无需权限提示即可自动使用的工具';
	@override String get placeholder => '例如："Bash(git log:*)" 或 "Write"';
	@override String get quickAdd => '快速添加常用工具：';
	@override String get empty => '未配置允许的工具';
}

// Path: settings.permissions.blockedTools
class Translations$settings$permissions$blockedTools$zh_CN extends Translations$settings$permissions$blockedTools$en {
	Translations$settings$permissions$blockedTools$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '禁用的工具';
	@override String get description => '无需权限提示即可自动禁用的工具';
	@override String get placeholder => '例如："Bash(rm:*)"';
	@override String get empty => '未配置禁用的工具';
}

// Path: settings.permissions.allowedCommands
class Translations$settings$permissions$allowedCommands$zh_CN extends Translations$settings$permissions$allowedCommands$en {
	Translations$settings$permissions$allowedCommands$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '允许的 Shell 命令';
	@override String get description => '无需权限提示即可自动执行的 Shell 命令';
	@override String get placeholder => '例如："Shell(ls)" 或 "Shell(git status)"';
	@override String get quickAdd => '快速添加常用命令：';
	@override String get empty => '未配置允许的命令';
}

// Path: settings.permissions.blockedCommands
class Translations$settings$permissions$blockedCommands$zh_CN extends Translations$settings$permissions$blockedCommands$en {
	Translations$settings$permissions$blockedCommands$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '阻止的 Shell 命令';
	@override String get description => '自动阻止的 Shell 命令';
	@override String get placeholder => '例如："Shell(rm -rf)" 或 "Shell(sudo)"';
	@override String get empty => '未配置阻止的命令';
}

// Path: settings.permissions.toolExamples
class Translations$settings$permissions$toolExamples$zh_CN extends Translations$settings$permissions$toolExamples$en {
	Translations$settings$permissions$toolExamples$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '工具模式示例：';
	@override String get bashGitLog => '- 允许所有 git log 命令';
	@override String get bashGitDiff => '- 允许所有 git diff 命令';
	@override String get write => '- 允许所有 Write 工具使用';
	@override String get bashRm => '- 阻止所有 rm 命令（危险）';
}

// Path: settings.permissions.shellExamples
class Translations$settings$permissions$shellExamples$zh_CN extends Translations$settings$permissions$shellExamples$en {
	Translations$settings$permissions$shellExamples$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Shell 命令示例：';
	@override String get ls => '- 允许 ls 命令';
	@override String get gitStatus => '- 允许 git status';
	@override String get npmInstall => '- 允许 npm install';
	@override String get rmRf => '- 阻止递归删除';
}

// Path: settings.permissions.codex
class Translations$settings$permissions$codex$zh_CN extends Translations$settings$permissions$codex$en {
	Translations$settings$permissions$codex$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get permissionMode => '权限模式';
	@override String get description => '控制 Codex 如何处理文件修改和命令执行';
	@override late final Translations$settings$permissions$codex$modes$zh_CN modes = Translations$settings$permissions$codex$modes$zh_CN.internal(_root);
	@override String get technicalDetails => '技术详情';
	@override late final Translations$settings$permissions$codex$technicalInfo$zh_CN technicalInfo = Translations$settings$permissions$codex$technicalInfo$zh_CN.internal(_root);
}

// Path: settings.permissions.actions
class Translations$settings$permissions$actions$zh_CN extends Translations$settings$permissions$actions$en {
	Translations$settings$permissions$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add => '添加';
}

// Path: settings.permissions.permissionMode
class Translations$settings$permissions$permissionMode$zh_CN extends Translations$settings$permissions$permissionMode$en {
	Translations$settings$permissions$permissionMode$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '权限模式';
	@override String description({required Object provider}) => '新 ${provider} 会话的默认权限模式。你仍可为单个会话覆盖。';
	@override late final Translations$settings$permissions$permissionMode$modes$zh_CN modes = Translations$settings$permissions$permissionMode$modes$zh_CN.internal(_root);
}

// Path: settings.mcpServers.description
class Translations$settings$mcpServers$description$zh_CN extends Translations$settings$mcpServers$description$en {
	Translations$settings$mcpServers$description$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get claude => 'Model Context Protocol 服务器为 Claude 提供额外的工具和数据源';
	@override String get cursor => 'Model Context Protocol 服务器为 Cursor 提供额外的工具和数据源';
	@override String get codex => 'Model Context Protocol 服务器为 Codex 提供额外的工具和数据源';
	@override String get opencode => 'Model Context Protocol 服务器为 OpenCode 提供额外的工具和数据源';
	@override String get commandcode => 'Model Context Protocol 服务器为 Command Code 提供额外的工具和数据源';
	@override String get antigravity => 'Model Context Protocol 服务器为 Antigravity 提供额外的工具和数据源';
	@override String get devin => 'Model Context Protocol 服务器为 Devin 提供额外的工具和数据源';
}

// Path: settings.mcpServers.scope
class Translations$settings$mcpServers$scope$zh_CN extends Translations$settings$mcpServers$scope$en {
	Translations$settings$mcpServers$scope$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get local => '本地';
	@override String get user => '用户';
}

// Path: settings.mcpServers.config
class Translations$settings$mcpServers$config$zh_CN extends Translations$settings$mcpServers$config$en {
	Translations$settings$mcpServers$config$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get command => '命令';
	@override String get url => 'URL';
	@override String get args => '参数';
	@override String get environment => '环境变量';
}

// Path: settings.mcpServers.tools
class Translations$settings$mcpServers$tools$zh_CN extends Translations$settings$mcpServers$tools$en {
	Translations$settings$mcpServers$tools$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '工具';
	@override String count({required Object count}) => '（${count}）：';
	@override String more({required Object count}) => '还有 ${count} 个';
}

// Path: settings.mcpServers.actions
class Translations$settings$mcpServers$actions$zh_CN extends Translations$settings$mcpServers$actions$en {
	Translations$settings$mcpServers$actions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get edit => '编辑服务器';
	@override String get delete => '删除服务器';
}

// Path: settings.mcpServers.managed
class Translations$settings$mcpServers$managed$zh_CN extends Translations$settings$mcpServers$managed$en {
	Translations$settings$mcpServers$managed$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get badge => '已托管';
	@override String get hint => '由 ddagent 管理。';
}

// Path: settings.mcpServers.help
class Translations$settings$mcpServers$help$zh_CN extends Translations$settings$mcpServers$help$en {
	Translations$settings$mcpServers$help$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '关于 Codex MCP';
	@override String get description => 'Codex 支持基于 stdio 的 MCP 服务器。您可以添加服务器，通过额外的工具和资源来扩展 Codex 的功能。';
}

// Path: settings.mcpServers.deleteConfirm
class Translations$settings$mcpServers$deleteConfirm$zh_CN extends Translations$settings$mcpServers$deleteConfirm$en {
	Translations$settings$mcpServers$deleteConfirm$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String description({required Object serverName}) => '“${serverName}”将从提供商配置中移除。';
	@override String get title => '删除 MCP 服务器？';
}

// Path: settings.quota.settings
class Translations$settings$quota$settings$zh_CN extends Translations$settings$quota$settings$en {
	Translations$settings$quota$settings$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tab => 'Control Center';
	@override String get title => 'Control Center';
	@override String get description => '提醒阈值、路由策略以及轮询额度的账户。';
	@override String get saved => '已保存';
	@override String get alertsSection => '提醒';
	@override String get alertsSectionHint => '在额度真正耗尽之前警告，而不是等到 100%。';
	@override String get alertsEnabled => '预测额度提醒';
	@override String get alertsEnabledHint => '在概览和账户卡片上显示基于速度的预测。';
	@override String get watchThreshold => '观察阈值（%）';
	@override String get watchThresholdHint => '读数达到或超过此值的账户计为有风险。';
	@override String get dangerThreshold => '危险阈值（%）';
	@override String get dangerThresholdHint => '达到或超过此值的读数显示为红色。';
	@override String get routingSection => '路由';
	@override String get routingSectionHint => '面板如何将工作迁移到余量最多的账户。';
	@override late final Translations$settings$quota$settings$routing$zh_CN routing = Translations$settings$quota$settings$routing$zh_CN.internal(_root);
	@override String get routingNote => '切换账户会改变成本和模型质量，因此始终需要明确决定。';
	@override String get accountsSection => '轮询的账户';
	@override String get accountsSectionHint => '凭据从各工具读取；面板不会将其发送到其他地方。';
	@override String get sourcesSection => '数据来源';
	@override String get sourcesSectionHint => '用量和成本数据的来源。';
	@override String get logSources => '令牌与成本日志存储';
	@override String get logSourcesHint => '与 tokboard 收集器共享的只读聚合存储。';
	@override String get readOnly => '只读';
	@override String get quotaConsent => '额度轮询';
	@override String get quotaConsentHint => '使用本地存储的凭据读取提供商额度端点。';
	@override String get localOnly => '仅本地';
}

// Path: settings.quota.empty
class Translations$settings$quota$empty$zh_CN extends Translations$settings$quota$empty$en {
	Translations$settings$quota$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => '尚未检测到任何账户。';
}

// Path: settings.quota.quality
class Translations$settings$quota$quality$zh_CN extends Translations$settings$quota$quality$en {
	Translations$settings$quota$quality$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cached => '缓存';
	@override String get error => '错误';
	@override String get estimate => '估计';
	@override String get live => '实时';
	@override String get unknown => '未知';
}

// Path: settings.browser.errors
class Translations$settings$browser$errors$zh_CN extends Translations$settings$browser$errors$en {
	Translations$settings$browser$errors$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get installRuntime => '安装浏览器运行时失败';
	@override String get loadSettings => '加载 Browser 设置失败';
	@override String get loadStatus => '加载 Browser 状态失败';
	@override String get saveSettings => '保存 Browser 设置失败';
}

// Path: settings.about.pro
class Translations$settings$about$pro$zh_CN extends Translations$settings$about$pro$en {
	Translations$settings$about$pro$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get syncSettings => '同步设置';
	@override String get teamManagement => '团队管理';
}

// Path: tasks.notConfigured.features
class Translations$tasks$notConfigured$features$zh_CN extends Translations$tasks$notConfigured$features$en {
	Translations$tasks$notConfigured$features$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get aiPowered => 'AI 驱动的任务管理：将复杂项目分解为可管理的子任务';
	@override String get prdTemplates => 'PRD 模板：从产品需求文档生成任务';
	@override String get dependencyTracking => '依赖追踪：了解任务关系和执行顺序';
	@override String get progressVisualization => '进度可视化：看板和详细的任务分析';
	@override String get cliIntegration => 'CLI 集成：使用 taskmaster 命令进行高级工作流';
}

// Path: tasks.gettingStarted.steps
class Translations$tasks$gettingStarted$steps$zh_CN extends Translations$tasks$gettingStarted$steps$en {
	Translations$tasks$gettingStarted$steps$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$tasks$gettingStarted$steps$createPRD$zh_CN createPRD = Translations$tasks$gettingStarted$steps$createPRD$zh_CN.internal(_root);
	@override late final Translations$tasks$gettingStarted$steps$generateTasks$zh_CN generateTasks = Translations$tasks$gettingStarted$steps$generateTasks$zh_CN.internal(_root);
	@override late final Translations$tasks$gettingStarted$steps$analyzeTasks$zh_CN analyzeTasks = Translations$tasks$gettingStarted$steps$analyzeTasks$zh_CN.internal(_root);
	@override late final Translations$tasks$gettingStarted$steps$startBuilding$zh_CN startBuilding = Translations$tasks$gettingStarted$steps$startBuilding$zh_CN.internal(_root);
}

// Path: tasks.helpGuide.examples
class Translations$tasks$helpGuide$examples$zh_CN extends Translations$tasks$helpGuide$examples$en {
	Translations$tasks$helpGuide$examples$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get parsePRD => '💬 示例：\n「我刚用 Claude Task Master 初始化了一个新项目。我有一个 PRD 在 .taskmaster/docs/prd.txt。你能帮我解析它并设置初始任务吗？」';
	@override String get expandTask => '💬 示例：\n「任务 5 看起来很复杂。你能把它分解成子任务吗？」';
	@override String get addTask => '💬 示例：\n「请添加一个新任务来实现使用 Cloudinary 的用户个人头像上传功能，研究最佳方法。」';
}

// Path: tasks.helpGuide.proTips
class Translations$tasks$helpGuide$proTips$zh_CN extends Translations$tasks$helpGuide$proTips$en {
	Translations$tasks$helpGuide$proTips$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '💡 专业提示';
	@override String get search => '使用搜索栏快速找到特定任务';
	@override String get views => '使用视图切换在看板、列表和网格视图之间切换';
	@override String get filters => '使用筛选器聚焦特定任务状态或优先级';
	@override String get details => '点击任何任务以查看详细信息和管理子任务';
}

// Path: tasks.helpGuide.learnMore
class Translations$tasks$helpGuide$learnMore$zh_CN extends Translations$tasks$helpGuide$learnMore$en {
	Translations$tasks$helpGuide$learnMore$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '📚 了解更多';
	@override String get description => 'TaskMaster AI 是为开发者打造的高级任务管理系统。获取文档、示例并为项目做出贡献。';
	@override String get githubButton => '在 GitHub 上查看';
}

// Path: tasks.board.empty
class Translations$tasks$board$empty$zh_CN extends Translations$tasks$board$empty$en {
	Translations$tasks$board$empty$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '还没有卡片';
	@override String get description => '添加卡片、描述任务，然后拖到“准备开始”让代理开始工作。';
}

// Path: tasks.board.columns
class Translations$tasks$board$columns$zh_CN extends Translations$tasks$board$columns$en {
	Translations$tasks$board$columns$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get backlog => '待办列表';
	@override String get ready => '准备开始';
	@override String get working => '进行中';
	@override String get needsDecision => '需要你的决定';
	@override String get done => '已完成';
	@override String get archived => '已归档';
}

// Path: tasks.board.card
class Translations$tasks$board$card$zh_CN extends Translations$tasks$board$card$en {
	Translations$tasks$board$card$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get running => '运行中';
	@override String get abort => '中止';
	@override String get delete => '删除';
	@override String get openSession => '打开会话';
	@override String get pullRequest => '拉取请求';
}

// Path: tasks.board.dialog
class Translations$tasks$board$dialog$zh_CN extends Translations$tasks$board$dialog$en {
	Translations$tasks$board$dialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get createTitle => '新卡片';
	@override String get editTitle => '编辑卡片';
	@override String get titleLabel => '标题';
	@override String get titlePlaceholder => '代理应该做什么？';
	@override String get descriptionLabel => '描述';
	@override String get descriptionPlaceholder => '添加背景、验收标准、链接...';
	@override String get cancel => '取消';
	@override String get save => '保存';
}

// Path: tasks.board.agent
class Translations$tasks$board$agent$zh_CN extends Translations$tasks$board$agent$en {
	Translations$tasks$board$agent$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get provider => '代理';
	@override String get anyProvider => '任意代理';
	@override String get model => '模型';
	@override String get defaultModel => '默认模型';
	@override String get effort => '推理';
	@override String get defaultEffort => '默认';
	@override String get searchModel => '搜索模型…';
	@override String get noModels => '没有匹配的模型';
}

// Path: tasks.board.deleteConfirm
class Translations$tasks$board$deleteConfirm$zh_CN extends Translations$tasks$board$deleteConfirm$en {
	Translations$tasks$board$deleteConfirm$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String description({required Object cardTitle}) => '“${cardTitle}”将被永久删除。';
	@override String get title => '删除卡片？';
}

// Path: mcp.form.fields
class Translations$mcp$form$fields$zh_CN extends Translations$mcp$form$fields$en {
	Translations$mcp$form$fields$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get bearerTokenEnvVar => 'Bearer 令牌环境变量';
	@override String get envVarNames => '环境变量名称';
	@override String get workingDirectory => '工作目录';
}

// Path: mcp.form.scope
class Translations$mcp$form$scope$zh_CN extends Translations$mcp$form$scope$en {
	Translations$mcp$form$scope$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get claudeLocal => 'Claude 本地';
	@override late final Translations$mcp$form$scope$description$zh_CN description = Translations$mcp$form$scope$description$zh_CN.internal(_root);
	@override String get projectAllProviders => '项目（所有提供商）';
	@override String get userAllProviders => '用户（所有提供商）';
}

// Path: mcp.form.validation
class Translations$mcp$form$validation$zh_CN extends Translations$mcp$form$validation$en {
	Translations$mcp$form$validation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String unsupportedGlobal({required Object type}) => '添加 MCP 服务器在所有提供商中仅支持 stdio 和 http，不支持 ${type}。';
	@override String unsupportedProvider({required Object provider, required Object type}) => '${provider} 不支持 ${type} MCP 服务器';
}

// Path: mcp.servers.config
class Translations$mcp$servers$config$zh_CN extends Translations$mcp$servers$config$en {
	Translations$mcp$servers$config$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cwd => '工作目录';
	@override String get envVars => '环境变量';
}

// Path: common.projectWizard.step1.existing
class Translations$common$projectWizard$step1$existing$zh_CN extends Translations$common$projectWizard$step1$existing$en {
	Translations$common$projectWizard$step1$existing$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '现有工作区';
	@override String get description => '我的服务器上已经有工作区，只需要将其添加到项目列表中';
}

// Path: common.projectWizard.step1.kNew
class Translations$common$projectWizard$step1$kNew$zh_CN extends Translations$common$projectWizard$step1$kNew$en {
	Translations$common$projectWizard$step1$kNew$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '新建工作区';
	@override String get description => '创建一个新工作区，可选择从 GitHub 仓库克隆';
}

// Path: common.notifications.codes.generic
class Translations$common$notifications$codes$generic$zh_CN extends Translations$common$notifications$codes$generic$en {
	Translations$common$notifications$codes$generic$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$generic$info$zh_CN info = Translations$common$notifications$codes$generic$info$zh_CN.internal(_root);
}

// Path: common.notifications.codes.permission
class Translations$common$notifications$codes$permission$zh_CN extends Translations$common$notifications$codes$permission$en {
	Translations$common$notifications$codes$permission$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$permission$required$zh_CN required = Translations$common$notifications$codes$permission$required$zh_CN.internal(_root);
}

// Path: common.notifications.codes.run
class Translations$common$notifications$codes$run$zh_CN extends Translations$common$notifications$codes$run$en {
	Translations$common$notifications$codes$run$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$run$stopped$zh_CN stopped = Translations$common$notifications$codes$run$stopped$zh_CN.internal(_root);
	@override late final Translations$common$notifications$codes$run$failed$zh_CN failed = Translations$common$notifications$codes$run$failed$zh_CN.internal(_root);
}

// Path: common.notifications.codes.agent
class Translations$common$notifications$codes$agent$zh_CN extends Translations$common$notifications$codes$agent$en {
	Translations$common$notifications$codes$agent$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$common$notifications$codes$agent$notification$zh_CN notification = Translations$common$notifications$codes$agent$notification$zh_CN.internal(_root);
}

// Path: common.quota.settings.routing
class Translations$common$quota$settings$routing$zh_CN extends Translations$common$quota$settings$routing$en {
	Translations$common$quota$settings$routing$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get manual => '手动 — 仅建议';
	@override String get ask => '切换账户前询问';
	@override String get autoLowRisk => '低风险任务自动切换';
}

// Path: settings.orchestration.pool.fields
class Translations$settings$orchestration$pool$fields$zh_CN extends Translations$settings$orchestration$pool$fields$en {
	Translations$settings$orchestration$pool$fields$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

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
	@override String get redundantAccounts => '冗余账户';
	@override String get redundantAccountsNone => '此提供商没有其他账户';
	@override String get tier => 'Cost tier';
	@override String get remove => 'Remove candidate';
	@override String get moveUp => 'Move up';
	@override String get moveDown => 'Move down';
}

// Path: settings.orchestration.rules.taskTypes
class Translations$settings$orchestration$rules$taskTypes$zh_CN extends Translations$settings$orchestration$rules$taskTypes$en {
	Translations$settings$orchestration$rules$taskTypes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class Translations$settings$orchestration$planner$modes$zh_CN extends Translations$settings$orchestration$planner$modes$en {
	Translations$settings$orchestration$planner$modes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Auto (LLM)';
	@override String get template => 'Templates';
	@override String get off => 'Off';
}

// Path: settings.orchestration.planner.modeHints
class Translations$settings$orchestration$planner$modeHints$zh_CN extends Translations$settings$orchestration$planner$modeHints$en {
	Translations$settings$orchestration$planner$modeHints$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get auto => 'The planner model decomposes each request into typed steps.';
	@override String get template => 'Requests run through a fixed pipeline you pick below.';
	@override String get off => 'No planning — the whole request is routed as a single step.';
}

// Path: settings.orchestration.planner.templates
class Translations$settings$orchestration$planner$templates$zh_CN extends Translations$settings$orchestration$planner$templates$en {
	Translations$settings$orchestration$planner$templates$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

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
class Translations$settings$orchestration$execution$onNoCandidateOptions$zh_CN extends Translations$settings$orchestration$execution$onNoCandidateOptions$en {
	Translations$settings$orchestration$execution$onNoCandidateOptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get ask => 'Ask';
	@override String get skip => 'Skip step';
}

// Path: settings.appearanceSettings.codeEditor.theme
class Translations$settings$appearanceSettings$codeEditor$theme$zh_CN extends Translations$settings$appearanceSettings$codeEditor$theme$en {
	Translations$settings$appearanceSettings$codeEditor$theme$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '编辑器主题';
	@override String get description => '代码编辑器的默认主题';
}

// Path: settings.appearanceSettings.codeEditor.wordWrap
class Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_CN extends Translations$settings$appearanceSettings$codeEditor$wordWrap$en {
	Translations$settings$appearanceSettings$codeEditor$wordWrap$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '自动换行';
	@override String get description => '在编辑器中默认启用自动换行';
}

// Path: settings.appearanceSettings.codeEditor.showMinimap
class Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_CN extends Translations$settings$appearanceSettings$codeEditor$showMinimap$en {
	Translations$settings$appearanceSettings$codeEditor$showMinimap$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '显示缩略图';
	@override String get description => '在差异视图中显示缩略图以便于导航';
}

// Path: settings.appearanceSettings.codeEditor.lineNumbers
class Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_CN extends Translations$settings$appearanceSettings$codeEditor$lineNumbers$en {
	Translations$settings$appearanceSettings$codeEditor$lineNumbers$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '显示行号';
	@override String get description => '在编辑器中显示行号';
}

// Path: settings.appearanceSettings.codeEditor.fontSize
class Translations$settings$appearanceSettings$codeEditor$fontSize$zh_CN extends Translations$settings$appearanceSettings$codeEditor$fontSize$en {
	Translations$settings$appearanceSettings$codeEditor$fontSize$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '字体大小';
	@override String get description => '编辑器字体大小（px）';
}

// Path: settings.appearanceSettings.terminal.focusFollowsPointer
class Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_CN extends Translations$settings$appearanceSettings$terminal$focusFollowsPointer$en {
	Translations$settings$appearanceSettings$terminal$focusFollowsPointer$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get label => '焦点跟随指针';
	@override String get description => '将鼠标移到终端上时聚焦终端以便输入';
}

// Path: settings.apiKeys.github.form
class Translations$settings$apiKeys$github$form$zh_CN extends Translations$settings$apiKeys$github$form$en {
	Translations$settings$apiKeys$github$form$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => '令牌名称（例如：个人仓库）';
	@override String get tokenPlaceholder => 'GitHub 个人访问令牌（ghp_...）';
	@override String get descriptionPlaceholder => '描述（可选）';
	@override String get addButton => '添加令牌';
	@override String get cancelButton => '取消';
	@override String get howToCreate => '如何创建 GitHub 个人访问令牌 →';
	@override String get showToken => '显示令牌';
	@override String get hideToken => '隐藏令牌';
}

// Path: settings.tasks.notInstalled.steps
class Translations$settings$tasks$notInstalled$steps$zh_CN extends Translations$settings$tasks$notInstalled$steps$en {
	Translations$settings$tasks$notInstalled$steps$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get restart => '重启此应用程序';
	@override String get autoAvailable => 'TaskMaster 功能将自动可用';
	@override String get initCommand => '在项目目录中使用 task-master init';
}

// Path: settings.agents.account.claude
class Translations$settings$agents$account$claude$zh_CN extends Translations$settings$agents$account$claude$en {
	Translations$settings$agents$account$claude$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'Anthropic Claude AI 助手';
}

// Path: settings.agents.account.cursor
class Translations$settings$agents$account$cursor$zh_CN extends Translations$settings$agents$account$cursor$en {
	Translations$settings$agents$account$cursor$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'Cursor AI 驱动的代码编辑器';
}

// Path: settings.agents.account.codex
class Translations$settings$agents$account$codex$zh_CN extends Translations$settings$agents$account$codex$en {
	Translations$settings$agents$account$codex$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenAI Codex AI 助手';
}

// Path: settings.agents.account.opencode
class Translations$settings$agents$account$opencode$zh_CN extends Translations$settings$agents$account$opencode$en {
	Translations$settings$agents$account$opencode$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'OpenCode CLI 助手';
}

// Path: settings.agents.account.commandcode
class Translations$settings$agents$account$commandcode$zh_CN extends Translations$settings$agents$account$commandcode$en {
	Translations$settings$agents$account$commandcode$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'Command Code CLI 助手';
}

// Path: settings.agents.account.antigravity
class Translations$settings$agents$account$antigravity$zh_CN extends Translations$settings$agents$account$antigravity$en {
	Translations$settings$agents$account$antigravity$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'Antigravity CLI 助手';
}

// Path: settings.agents.account.devin
class Translations$settings$agents$account$devin$zh_CN extends Translations$settings$agents$account$devin$en {
	Translations$settings$agents$account$devin$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get description => 'Devin CLI 助手';
}

// Path: settings.permissions.codex.modes
class Translations$settings$permissions$codex$modes$zh_CN extends Translations$settings$permissions$codex$modes$en {
	Translations$settings$permissions$codex$modes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$codex$modes$kDefault$zh_CN kDefault = Translations$settings$permissions$codex$modes$kDefault$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$codex$modes$acceptEdits$zh_CN acceptEdits = Translations$settings$permissions$codex$modes$acceptEdits$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$codex$modes$bypassPermissions$zh_CN bypassPermissions = Translations$settings$permissions$codex$modes$bypassPermissions$zh_CN.internal(_root);
}

// Path: settings.permissions.codex.technicalInfo
class Translations$settings$permissions$codex$technicalInfo$zh_CN extends Translations$settings$permissions$codex$technicalInfo$en {
	Translations$settings$permissions$codex$technicalInfo$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'sandboxMode=workspace-write, approvalPolicy=untrusted。受信任的命令：cat、cd、grep、head、ls、pwd、tail、git status/log/diff/show、find（不带 -exec）等。';
	@override String get acceptEdits => 'sandboxMode=workspace-write, approvalPolicy=never。所有命令在项目目录内自动执行。';
	@override String get bypassPermissions => 'sandboxMode=danger-full-access, approvalPolicy=never。完全系统访问权限，仅在可信环境中使用。';
	@override String get overrideNote => '您可以使用聊天界面中的模式按钮按会话覆盖此设置。';
}

// Path: settings.permissions.permissionMode.modes
class Translations$settings$permissions$permissionMode$modes$zh_CN extends Translations$settings$permissions$permissionMode$modes$en {
	Translations$settings$permissions$permissionMode$modes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override late final Translations$settings$permissions$permissionMode$modes$kDefault$zh_CN kDefault = Translations$settings$permissions$permissionMode$modes$kDefault$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_CN acceptEdits = Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_CN bypassPermissions = Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_CN.internal(_root);
	@override late final Translations$settings$permissions$permissionMode$modes$plan$zh_CN plan = Translations$settings$permissions$permissionMode$modes$plan$zh_CN.internal(_root);
}

// Path: settings.quota.settings.routing
class Translations$settings$quota$settings$routing$zh_CN extends Translations$settings$quota$settings$routing$en {
	Translations$settings$quota$settings$routing$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get manual => '手动';
	@override String get manualHint => '仅显示建议；绝不自动切换账户。';
	@override String get ask => '切换前询问';
	@override String get askHint => '提出切换建议并等待你的批准。';
	@override String get autoLowRisk => '低风险任务自动';
	@override String get autoLowRiskHint => '只有标记为低风险的任务才能自动迁移。';
}

// Path: tasks.gettingStarted.steps.createPRD
class Translations$tasks$gettingStarted$steps$createPRD$zh_CN extends Translations$tasks$gettingStarted$steps$createPRD$en {
	Translations$tasks$gettingStarted$steps$createPRD$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '创建产品需求文档（PRD）';
	@override String get description => '讨论您的项目构想并创建描述您想构建什么的 PRD。';
	@override String get addButton => '添加 PRD';
	@override String get existingPRDs => '现有的 PRD：';
}

// Path: tasks.gettingStarted.steps.generateTasks
class Translations$tasks$gettingStarted$steps$generateTasks$zh_CN extends Translations$tasks$gettingStarted$steps$generateTasks$en {
	Translations$tasks$gettingStarted$steps$generateTasks$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '从 PRD 生成任务';
	@override String get description => '一旦您有了 PRD，请 AI 助手解析它，TaskMaster 将自动将其分解为可管理的任务，包含实现细节。';
}

// Path: tasks.gettingStarted.steps.analyzeTasks
class Translations$tasks$gettingStarted$steps$analyzeTasks$zh_CN extends Translations$tasks$gettingStarted$steps$analyzeTasks$en {
	Translations$tasks$gettingStarted$steps$analyzeTasks$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '分析并展开任务';
	@override String get description => '请 AI 助手分析任务复杂度，并将其展开为详细的子任务以便于实现。';
}

// Path: tasks.gettingStarted.steps.startBuilding
class Translations$tasks$gettingStarted$steps$startBuilding$zh_CN extends Translations$tasks$gettingStarted$steps$startBuilding$en {
	Translations$tasks$gettingStarted$steps$startBuilding$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '开始构建';
	@override String get description => '请 AI 助手开始处理任务、更新状态，并在项目演进时添加新任务。';
}

// Path: mcp.form.scope.description
class Translations$mcp$form$scope$description$zh_CN extends Translations$mcp$form$scope$description$en {
	Translations$mcp$form$scope$description$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get local => '存储在所选项目的 Claude 用户设置中';
	@override String get project => '存储在所选项目工作区中';
	@override String get projectGlobal => '写入所选项目工作区，适用于所有提供商';
	@override String get user => '在您机器的所有项目中可用';
	@override String get userGlobal => '写入每个提供商的用户配置，并在本机的所有项目中可用';
}

// Path: common.notifications.codes.generic.info
class Translations$common$notifications$codes$generic$info$zh_CN extends Translations$common$notifications$codes$generic$info$en {
	Translations$common$notifications$codes$generic$info$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '通知';
}

// Path: common.notifications.codes.permission.required
class Translations$common$notifications$codes$permission$required$zh_CN extends Translations$common$notifications$codes$permission$required$en {
	Translations$common$notifications$codes$permission$required$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '需要处理';
	@override String body({required Object toolName}) => '${toolName} 正在等待你的决策。';
}

// Path: common.notifications.codes.run.stopped
class Translations$common$notifications$codes$run$stopped$zh_CN extends Translations$common$notifications$codes$run$stopped$en {
	Translations$common$notifications$codes$run$stopped$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '运行已停止';
	@override String body({required Object reason}) => '原因：${reason}';
}

// Path: common.notifications.codes.run.failed
class Translations$common$notifications$codes$run$failed$zh_CN extends Translations$common$notifications$codes$run$failed$en {
	Translations$common$notifications$codes$run$failed$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '运行失败';
}

// Path: common.notifications.codes.agent.notification
class Translations$common$notifications$codes$agent$notification$zh_CN extends Translations$common$notifications$codes$agent$notification$en {
	Translations$common$notifications$codes$agent$notification$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Agent 通知';
}

// Path: settings.permissions.codex.modes.kDefault
class Translations$settings$permissions$codex$modes$kDefault$zh_CN extends Translations$settings$permissions$codex$modes$kDefault$en {
	Translations$settings$permissions$codex$modes$kDefault$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '默认';
	@override String get description => '只有受信任的命令（ls、cat、grep、git status 等）会自动运行。其他命令将被跳过。可以写入工作区。';
}

// Path: settings.permissions.codex.modes.acceptEdits
class Translations$settings$permissions$codex$modes$acceptEdits$zh_CN extends Translations$settings$permissions$codex$modes$acceptEdits$en {
	Translations$settings$permissions$codex$modes$acceptEdits$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '接受编辑';
	@override String get description => '所有命令在工作区内自动运行。具有沙箱执行的全自动模式。';
}

// Path: settings.permissions.codex.modes.bypassPermissions
class Translations$settings$permissions$codex$modes$bypassPermissions$zh_CN extends Translations$settings$permissions$codex$modes$bypassPermissions$en {
	Translations$settings$permissions$codex$modes$bypassPermissions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '绕过权限';
	@override String get description => '完全系统访问，无任何限制。所有命令自动运行，具有完整的磁盘和网络访问权限。请谨慎使用。';
}

// Path: settings.permissions.permissionMode.modes.kDefault
class Translations$settings$permissions$permissionMode$modes$kDefault$zh_CN extends Translations$settings$permissions$permissionMode$modes$kDefault$en {
	Translations$settings$permissions$permissionMode$modes$kDefault$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '默认';
	@override String get description => '需要权限的操作会在聊天中显示供你批准。';
}

// Path: settings.permissions.permissionMode.modes.acceptEdits
class Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_CN extends Translations$settings$permissions$permissionMode$modes$acceptEdits$en {
	Translations$settings$permissions$permissionMode$modes$acceptEdits$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '接受编辑';
	@override String get description => '文件编辑自动批准；其他操作仍会请求你的批准。';
}

// Path: settings.permissions.permissionMode.modes.bypassPermissions
class Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_CN extends Translations$settings$permissions$permissionMode$modes$bypassPermissions$en {
	Translations$settings$permissions$permissionMode$modes$bypassPermissions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '绕过权限';
	@override String get description => '每个操作都自动批准 — 无提示完全访问。请谨慎使用。';
}

// Path: settings.permissions.permissionMode.modes.plan
class Translations$settings$permissions$permissionMode$modes$plan$zh_CN extends Translations$settings$permissions$permissionMode$modes$plan$en {
	Translations$settings$permissions$permissionMode$modes$plan$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

	final TranslationsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '计划';
	@override String get description => '计划模式：代理只探索和规划，不执行命令。';
}

/// The flat map containing all translations for locale <zh-CN>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhCn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.sessionExpired' => '会话已过期，请重新登录。',
			'auth.login.title' => '欢迎回来',
			'auth.login.description' => '登录您的 ddagent 账户',
			'auth.login.username' => '用户名',
			'auth.login.password' => '密码',
			'auth.login.submit' => '登录',
			'auth.login.loading' => '登录中...',
			'auth.login.errors.invalidCredentials' => '用户名或密码无效',
			'auth.login.errors.requiredFields' => '请填写所有字段',
			'auth.login.errors.networkError' => '网络错误，请重试。',
			'auth.login.placeholders.username' => '输入您的用户名',
			'auth.login.placeholders.password' => '输入您的密码',
			'auth.register.title' => '创建账户',
			'auth.register.username' => '用户名',
			'auth.register.password' => '密码',
			'auth.register.confirmPassword' => '确认密码',
			'auth.register.submit' => '创建账户',
			'auth.register.loading' => '创建账户中...',
			'auth.register.errors.passwordMismatch' => '密码不匹配',
			'auth.register.errors.usernameTaken' => '用户名已被占用',
			'auth.register.errors.weakPassword' => '密码强度太弱',
			'auth.register.errors.usernameTooShort' => '用户名至少需要 3 个字符',
			'auth.register.errors.passwordTooShort' => '密码至少需要 6 个字符',
			'auth.logout.title' => '退出登录',
			'auth.logout.confirm' => '确定要退出登录吗？',
			'auth.logout.button' => '退出登录',
			'chat.codeBlock.copy' => '复制',
			'chat.codeBlock.copied' => '已复制',
			'chat.codeBlock.copyCode' => '复制代码',
			'chat.copyMessage.copy' => '复制消息',
			'chat.copyMessage.copied' => '消息已复制',
			'chat.copyMessage.failed' => '复制失败',
			'chat.copyMessage.selectFormat' => '选择复制格式',
			'chat.copyMessage.copyAsMarkdown' => '复制为 Markdown',
			'chat.copyMessage.copyAsText' => '复制为纯文本',
			'chat.copyMessage.markdownShort' => 'MD',
			'chat.copyMessage.textShort' => 'TXT',
			'chat.messageTypes.user' => 'U',
			'chat.messageTypes.error' => '错误',
			'chat.messageTypes.tool' => '工具',
			'chat.messageTypes.claude' => 'Claude',
			'chat.messageTypes.cursor' => 'Cursor',
			'chat.messageTypes.codex' => 'Codex',
			'chat.messageTypes.opencode' => 'OpenCode',
			'chat.messageTypes.devin' => 'Devin',
			'chat.tools.settings' => '工具设置',
			'chat.tools.error' => '工具错误',
			'chat.tools.result' => '工具结果',
			'chat.tools.viewParams' => '查看输入参数',
			'chat.tools.viewRawParams' => '查看原始参数',
			'chat.tools.viewDiff' => '查看编辑差异',
			'chat.tools.creatingFile' => '创建新文件：',
			'chat.tools.updatingTodo' => '更新待办事项',
			'chat.tools.read' => '读取',
			'chat.tools.readFile' => '读取文件',
			'chat.tools.updateTodo' => '更新待办列表',
			'chat.tools.readTodo' => '读取待办列表',
			'chat.tools.searchResults' => '结果',
			'chat.tools.todoReadLabel' => 'TodoRead 读取列表',
			'chat.search.found' => ({required Object count, required Object type}) => '找到 ${count} 个${type}',
			'chat.search.file' => '文件',
			'chat.search.files' => '文件',
			'chat.search.pattern' => '模式：',
			'chat.search.kIn' => '在：',
			'chat.fileOperations.updated' => '文件更新成功',
			'chat.fileOperations.created' => '文件创建成功',
			'chat.fileOperations.written' => '文件写入成功',
			'chat.fileOperations.diff' => '差异',
			'chat.fileOperations.newFile' => '新文件',
			'chat.fileOperations.viewContent' => '查看文件内容',
			'chat.fileOperations.viewFullOutput' => ({required Object count}) => '查看完整输出（${count} 个字符）',
			'chat.fileOperations.contentDisplayed' => '文件内容显示在上面的差异视图中',
			'chat.interactive.title' => '交互式提示',
			'chat.interactive.waiting' => '等待您在 CLI 中响应',
			'chat.interactive.instruction' => '请在 Claude 运行的终端中选择一个选项。',
			'chat.interactive.selectedOption' => ({required Object number}) => '✓ Claude 选择了选项 ${number}',
			'chat.interactive.instructionDetail' => '在 CLI 中，您可以使用方向键或输入数字来交互式地选择此选项。',
			'chat.thinking.title' => '思考中...',
			'chat.thinking.emoji' => '💭 思考中...',
			'chat.json.response' => 'JSON 响应',
			'chat.permissions.grant' => ({required Object tool}) => '授予 ${tool} 权限',
			'chat.permissions.added' => '权限已添加',
			'chat.permissions.addTo' => ({required Object entry}) => '将 ${entry} 添加到允许的工具。',
			'chat.permissions.retry' => '权限已保存。重试请求以使用该工具。',
			'chat.permissions.error' => '无法更新权限。请重试。',
			'chat.permissions.openSettings' => '打开设置',
			'chat.permissions.allow' => '允许',
			'chat.permissions.allowAll' => ({required Object count}) => '全部允许（${count}）',
			'chat.permissions.allowWithChanges' => '按修改允许',
			'chat.permissions.always' => '始终',
			'chat.permissions.deny' => '拒绝',
			'chat.permissions.editAndAllow' => '编辑并允许',
			'chat.permissions.editInput' => '编辑输入',
			'chat.permissions.invalidJson' => '无效的 JSON',
			'chat.permissions.reject' => '驳回',
			'chat.todo.updated' => '待办列表已成功更新',
			'chat.todo.current' => '当前待办列表',
			'chat.plan.viewPlan' => '📋 查看实施计划',
			'chat.plan.title' => '实施计划',
			'chat.usageLimit.resetAt' => ({required Object time, required Object timezone, required Object date}) => 'Claude 使用限制已达到。您的限制将在 **${time} ${timezone}** - ${date} 重置',
			'chat.codex.permissionMode' => '权限模式',
			'chat.codex.modes.kDefault' => '默认模式',
			'chat.codex.modes.auto' => '自动模式',
			'chat.codex.modes.acceptEdits' => '编辑模式',
			'chat.codex.modes.bypassPermissions' => '无限制模式',
			'chat.codex.modes.plan' => '计划模式',
			'chat.codex.descriptions.kDefault' => '只有受信任的命令（ls、cat、grep、git status 等）自动运行。其他命令将被跳过。可以写入工作区。',
			'chat.codex.descriptions.auto' => '模型分类器决定每个工具调用是批准还是拒绝。高自主性。',
			'chat.codex.descriptions.acceptEdits' => '工作区内的所有命令自动运行。完全自动模式，具有沙盒执行功能。',
			'chat.codex.descriptions.bypassPermissions' => '完全的系统访问，无限制。所有命令自动运行，具有完整的磁盘和网络访问权限。请谨慎使用。',
			'chat.codex.descriptions.plan' => '计划模式 - 不执行任何命令',
			'chat.codex.technicalDetails' => '技术细节',
			'chat.input.placeholder' => ({required Object provider}) => '输入 / 调用命令，@ 选择文件，或向 ${provider} 提问...',
			'chat.input.placeholderDefault' => '输入您的消息...',
			'chat.input.disabled' => '输入已禁用',
			'chat.input.attachFiles' => '附加文件',
			'chat.input.attachImages' => '附加图片',
			'chat.input.send' => '发送',
			'chat.input.stop' => '停止',
			'chat.input.hintText.ctrlEnter' => 'Ctrl+Enter 发送 • / 命令 • @ 文件',
			'chat.input.hintText.enter' => 'Enter 发送 • Shift+Enter 换行 • / 命令 • @ 文件',
			'chat.input.hintText.queue' => 'Enter 排队发送下一条消息',
			'chat.input.hintText.updateQueued' => 'Enter 更新排队消息',
			'chat.input.clickToChangeMode' => '点击更改权限模式',
			'chat.input.showAllCommands' => '显示所有命令',
			'chat.input.clearInput' => '清空输入',
			'chat.input.scrollToBottom' => '滚动到底部',
			'chat.input.queue.sendNext' => '排队发送下一条消息',
			'chat.input.queue.update' => '更新排队消息',
			'chat.input.queue.label' => '已排队',
			'chat.input.queue.willSend' => '将在当前完成后发送',
			'chat.input.queue.edit' => '编辑排队消息',
			'chat.input.queue.delete' => '删除排队消息',
			'chat.input.queue.failed' => '发送失败',
			'chat.input.queue.sendNow' => '立即发送',
			'chat.input.attachFilesDesc' => '上传照片、文件或文档',
			'chat.input.takePhoto' => '拍摄照片',
			'chat.input.takePhotoDesc' => '使用相机拍摄照片',
			'chat.input.moreTools' => '更多工具',
			'chat.input.commandsDesc' => '浏览快捷键和命令',
			'chat.input.clearInputDesc' => '丢弃当前文本',
			'chat.input.newMessage' => '新消息',
			'chat.input.newMessages' => '新消息',
			'chat.input.autoContinueTasks' => '自动继续',
			'chat.input.autoContinueTasksTooltip' => '启用后让 Devin 自动继续下一个 Task Master 任务',
			'chat.input.offlineQueue.clear' => '取消并清空离线队列',
			'chat.input.offlineQueue.clearBtn' => '取消',
			'chat.input.offlineQueue.multiple' => ({required Object count}) => '${count} 条消息在离线队列中 — 重新连接后将自动发送',
			'chat.input.offlineQueue.single' => '1 条消息在离线队列中 — 重新连接后将自动发送',
			'chat.input.cameraUnavailable' => ({required Object error}) => '相机不可用：${error}',
			'chat.providerSelection.title' => '选择您的 AI 助手',
			'chat.providerSelection.description' => '选择一个供应商以开始新对话',
			'chat.providerSelection.selectModel' => '选择模型',
			'chat.providerSelection.providerInfo.anthropic' => '由 Anthropic 提供',
			'chat.providerSelection.providerInfo.openai' => '由 OpenAI 提供',
			'chat.providerSelection.providerInfo.cursorEditor' => 'AI 代码编辑器',
			'chat.providerSelection.providerInfo.google' => '由 Google 提供',
			'chat.providerSelection.readyPrompt.claude' => ({required Object model}) => '准备好使用带有 ${model} 的 Claude。请在下方开始输入您的消息。',
			'chat.providerSelection.readyPrompt.cursor' => ({required Object model}) => '准备好使用带有 ${model} 的 Cursor。请在下方开始输入您的消息。',
			'chat.providerSelection.readyPrompt.codex' => ({required Object model}) => '准备好使用带有 ${model} 的 Codex。请在下方开始输入您的消息。',
			'chat.providerSelection.readyPrompt.opencode' => ({required Object model}) => '准备好使用带有 ${model} 的 OpenCode。请在下方开始输入您的消息。',
			'chat.providerSelection.readyPrompt.kDefault' => '请在上方选择一个提供者以开始',
			'chat.providerSelection.readyPrompt.devin' => ({required Object model}) => 'Devin ${model} 已就绪',
			'chat.providerSelection.pressToSearch' => ({required Object shortcut}) => '按 <kbd>${shortcut}</kbd> 搜索会话、文件和提交',
			'chat.providerSelection.workspace' => '工作区',
			'chat.providerSelection.noWorkspace' => '无',
			'chat.providerSelection.clickToChangeWorkspace' => '点击更改工作区',
			'chat.providerSelection.chooseWorkspace' => '选择工作区',
			'chat.providerSelection.searchWorkspaces' => '搜索工作区...',
			'chat.providerSelection.noWorkspacesFound' => '未找到工作区。',
			'chat.providerSelection.all' => '全部',
			'chat.providerSelection.free' => '免费',
			'chat.providerSelection.noModelsFound' => '未找到模型。',
			'chat.providerSelection.paid' => '付费',
			'chat.providerSelection.searchModels' => '搜索模型...',
			'chat.providerSelection.addModel' => '添加模型',
			'chat.providerSelection.chooseModel' => '选择模型',
			'chat.providerSelection.chooseModelDescription' => '内置和自定义模型在一个列表中',
			'chat.providerSelection.clickToChange' => '点击更改模型',
			'chat.providerSelection.favorites' => '收藏',
			'chat.providerSelection.loadingModels' => '正在加载模型…',
			'chat.providerSelection.manageModels' => '管理模型',
			'chat.providerSelection.refresh' => '刷新模型',
			'chat.session.kContinue.title' => '继续您的对话',
			'chat.session.kContinue.description' => '询问有关代码的问题、请求更改或获取开发任务的帮助',
			'chat.session.kContinue.action' => '继续输入',
			'chat.session.loading.olderMessages' => '正在加载更早的消息...',
			'chat.session.loading.sessionMessages' => '正在加载会话消息...',
			'chat.session.messages.showingOf' => ({required Object shown, required Object total}) => '显示 ${shown} / ${total} 条消息',
			'chat.session.messages.scrollToLoad' => '向上滚动以加载更多',
			'chat.session.messages.showingLast' => ({required Object count, required Object total}) => '显示最近 ${count} 条消息（共 ${total} 条）',
			'chat.session.messages.loadEarlier' => '加载更早的消息',
			'chat.session.messages.loadAll' => '加载全部消息',
			'chat.session.messages.loadingAll' => '正在加载全部消息...',
			'chat.session.messages.allLoaded' => '全部消息已加载',
			'chat.session.messages.perfWarning' => '已加载全部消息 - 滚动可能变慢。点击「滚动到底部」恢复性能。',
			'chat.session.messages.loadOlderFailed' => '加载较早消息失败。',
			'chat.session.messages.retry' => '重试',
			'chat.session.messages.noSearchMatches' => '没有消息匹配搜索。',
			'chat.session.messages.loadAllCount' => ({required Object count}) => '加载全部（${count}）',
			'chat.session.messages.loadOlder' => '加载更早的消息',
			'chat.session.messages.retryLoadOlder' => ({required Object error}) => '重试加载更早的消息 — ${error}',
			'chat.session.deleteConfirm' => '移除会话及其记录。此操作无法撤销。',
			'chat.session.finishRunBeforeWorkspaceChange' => '请先结束运行再更改工作区',
			'chat.shell.selectProject.title' => '选择项目',
			'chat.shell.selectProject.description' => '选择一个项目以在该目录中打开交互式 Shell',
			'chat.shell.status.newSession' => '新会话',
			'chat.shell.status.initializing' => '初始化中...',
			'chat.shell.status.restarting' => '重启中...',
			'chat.shell.actions.disconnect' => '断开连接',
			'chat.shell.actions.disconnectTitle' => '断开 Shell 连接',
			'chat.shell.actions.restart' => '重启',
			'chat.shell.actions.restartTitle' => '重启 Shell（请先断开连接）',
			'chat.shell.actions.connect' => '在 Shell 中继续',
			'chat.shell.actions.connectTitle' => '连接到 Shell',
			'chat.shell.actions.kill' => '终止 (SIGINT)',
			'chat.shell.actions.killTitle' => '终止正在运行的进程 (Ctrl+C)',
			'chat.shell.actions.copyOutput' => '复制输出',
			'chat.shell.actions.copyOutputTitle' => '复制终端输出',
			'chat.shell.actions.copied' => '已复制！',
			'chat.shell.actions.zoomInTitle' => '放大',
			'chat.shell.actions.zoomOutTitle' => '缩小',
			'chat.shell.loading' => '正在加载终端...',
			'chat.shell.connecting' => '正在连接到 Shell...',
			'chat.shell.startSession' => '启动新的 Claude 会话',
			'chat.shell.resumeSession' => ({required Object displayName}) => '恢复会话：${displayName}...',
			'chat.shell.runCommand' => ({required Object projectName, required Object command}) => '在 ${projectName} 中运行 ${command}',
			'chat.shell.startCli' => ({required Object projectName}) => '在 ${projectName} 中启动 Claude CLI',
			'chat.shell.defaultCommand' => '命令',
			'chat.claudeStatus.actions.thinking' => '思考中',
			'chat.claudeStatus.actions.processing' => '处理中',
			'chat.claudeStatus.actions.analyzing' => '分析中',
			'chat.claudeStatus.actions.working' => '工作中',
			'chat.claudeStatus.actions.computing' => '计算中',
			'chat.claudeStatus.actions.reasoning' => '推理中',
			'chat.claudeStatus.state.live' => '实时',
			'chat.claudeStatus.state.paused' => '已暂停',
			'chat.claudeStatus.elapsed.seconds' => ({required Object count}) => '${count}秒',
			'chat.claudeStatus.elapsed.minutesSeconds' => ({required Object minutes, required Object seconds}) => '${minutes}m ${seconds}s',
			'chat.claudeStatus.elapsed.label' => ({required Object time}) => '已用 ${time}',
			'chat.claudeStatus.elapsed.startingNow' => '刚刚开始',
			'chat.claudeStatus.stop' => '停止',
			'chat.claudeStatus.controls.stopGeneration' => '停止生成',
			'chat.claudeStatus.controls.pressEscToStop' => '随时按 Esc 停止',
			'chat.claudeStatus.providers.assistant' => '助手',
			'chat.projectSelection.startChatWithProvider' => ({required Object provider}) => '选择一个项目以开始与 ${provider} 聊天',
			'chat.tasks.nextTaskPrompt' => '开始下一个任务',
			'chat.voice.autoRead' => '朗读回复',
			'chat.voice.autoReadOn' => '朗读回复：开',
			'chat.voice.autoReadOff' => '朗读回复：关',
			'chat.voice.autoReadVoice' => '朗读声音',
			'chat.voice.autoReadVoiceAuto' => '自动声音',
			'chat.voice.autoReadPreview' => '回复将以此声音朗读。',
			'chat.voice.speakMessage' => '朗读',
			'chat.voice.stopSpeaking' => '停止朗读',
			'chat.composer.toolsAndActions' => '工具与操作',
			'chat.composer.toolsAndActionsDesc' => '聊天输入框的工具和控件',
			'chat.composer.reasoning' => '推理',
			'chat.composer.model' => '模型',
			'chat.composer.effortDefault' => '默认',
			'chat.composer.loadingModels' => '正在加载模型…',
			'chat.composer.modelMenu' => '选择模型和推理强度',
			'chat.composer.permissionHeading' => ({required Object provider}) => '应如何批准 ${provider} 的操作？',
			'chat.composer.favorites' => '收藏',
			'chat.splitSession.toggle' => '分屏会话',
			'chat.splitSession.close' => '关闭分屏会话',
			'chat.splitSession.selectSession' => '选择要比较的会话',
			'chat.splitSession.noOtherSessions' => '没有其他可用会话',
			'chat.splitSession.newSessionOption' => '+ 在分屏视图中新建会话',
			'chat.splitSession.currentProjectGroup' => ({required Object name}) => '当前项目（${name}）',
			'chat.splitSession.otherProjectsGroup' => '其他项目',
			'chat.splitSession.recentSessionsGroup' => '最近会话',
			'chat.splitSession.startNewSession' => '在分屏视图中开始新会话',
			'chat.splitSession.selectFromList' => '从现有会话列表中选择会话',
			'chat.sessionPicker.title' => '选择会话',
			'chat.sessionPicker.searchPlaceholder' => '搜索会话...',
			'chat.sessionPicker.clearSearch' => '清除搜索',
			'chat.sessionPicker.newChat' => '+ 新聊天',
			'chat.sessionPicker.archivedToggle' => '已归档',
			'chat.sessionPicker.changeSession' => '更改会话',
			'chat.sessionPicker.archivedLoading' => '正在加载已归档的会话...',
			'chat.sessionPicker.archivedError' => '无法加载已归档的会话',
			'chat.sessionPicker.archivedEmpty' => '没有已归档的会话',
			'chat.sessionPicker.archivedProjectOnly' => '工作区已归档 — 恢复它以查看其会话。',
			'chat.sessionPicker.emptySearch' => '没有会话匹配你的搜索',
			'chat.sessionPicker.restore' => '恢复',
			'chat.sessionPicker.restoreSession' => '恢复会话',
			'chat.sessionPicker.restoreProject' => '恢复工作区',
			'chat.sessionPicker.restoreSessionFailed' => '恢复会话失败。请重试。',
			'chat.sessionPicker.restoreProjectFailed' => '恢复工作区失败。请重试。',
			'chat.sessionPicker.archiveFailed' => '归档会话失败。请重试。',
			'chat.sessionPicker.deleteFailed' => '删除会话失败。请重试。',
			'chat.sessionPicker.running' => '会话正在运行',
			'chat.sessionPicker.unread' => '未读 — 已完成并有新输出',
			'chat.splitWorkspace.addChat' => '添加聊天窗格',
			'chat.splitWorkspace.addBrowser' => '添加浏览器窗格',
			'chat.splitWorkspace.addTerminal' => '添加终端窗格',
			'chat.splitWorkspace.overview' => '显示所有窗格',
			'chat.splitWorkspace.exitFocusMode' => '退出专注模式 (Ctrl+Shift+F)',
			'chat.splitWorkspace.focusMode' => '专注模式 (Ctrl+Shift+F)',
			'chat.splitWorkspace.browseSessions' => '打开会话列表',
			'chat.splitOverview.title' => '分屏窗格概览',
			'chat.splitOverview.count' => ({required Object count}) => '${count} 个窗格',
			'chat.splitOverview.close' => '关闭概览',
			'chat.splitOverview.question' => '问题 — 需要输入',
			'chat.splitOverview.processing' => '处理中',
			'chat.splitOverview.idle' => '空闲',
			'chat.splitOverview.active' => '活跃',
			'chat.askUserQuestion.needsInput' => ({required Object provider}) => '${provider} 需要你的输入',
			'chat.askUserQuestion.answerHint' => '输入你的答案…',
			'chat.askUserQuestion.other' => '其他…',
			'chat.askUserQuestion.skip' => '跳过',
			'chat.attachments.downloadFailedRetry' => '下载失败 — 点击重试',
			'chat.attachments.fileAttachment' => '文件附件',
			'chat.attachments.download' => ({required Object name}) => '下载 ${name}',
			'chat.checkpoint.creating' => '正在创建快照…',
			'chat.checkpoint.revertChanges' => '将文件还原到上一个检查点',
			'chat.checkpoint.undo' => '撤销检查点',
			'chat.checkpoint.beforeAiTurn' => 'AI 回合之前',
			'chat.common.close' => '关闭',
			'chat.taskMaster.saveToTask' => '任务',
			'chat.taskMaster.saved' => '已保存',
			'chat.taskMaster.saving' => '正在保存...',
			'chat.taskMaster.taskShort' => '任务',
			'chat.taskMaster.addToTask' => '添加到 TaskMaster',
			'chat.taskMaster.added' => '已添加到 TaskMaster',
			'chat.tokenUsage.desc' => '查看会话令牌消耗',
			'chat.tokenUsage.title' => '令牌用量',
			'chat.tool.emptyResult' => '（暂无输出 — 工具返回了空结果）',
			'chat.quotaBadge.ariaLabel' => '订阅额度限制',
			'chat.quotaBadge.noData' => '此模型暂无订阅数据',
			'chat.paneHeader.processing' => '处理中…',
			'chat.paneHeader.switchSession' => '切换会话',
			'chat.broadcast.selectOrchestrators' => '选择编排器',
			'chat.broadcast.orchestratorsOnly' => '仅编排器',
			'chat.broadcast.noOrchestrators' => '没有可用的编排器会话',
			'chat.changes.empty' => '没有文件更改',
			'chat.changes.failedToLoad' => '加载更改失败',
			'chat.commandResult.fallback.config' => '打开设置和配置。',
			'chat.commandResult.fallback.cost' => '查看当前会话的令牌用量。',
			'chat.commandResult.fallback.help' => '显示命令文档和语法。',
			'chat.commandResult.fallback.memory' => '打开项目的 CLAUDE.md 记忆文件。',
			'chat.commandResult.fallback.models' => '浏览当前提供商的可用模型。',
			'chat.commandResult.fallback.status' => '查看运行时、版本、提供商和环境状态。',
			'chat.commandResult.filterCommands' => '筛选命令...',
			'chat.commandResult.searchModels' => ({required Object provider}) => '搜索 ${provider} 模型...',
			'chat.commands.runConfirmTitle' => '运行命令？',
			'chat.commands.executionCancelled' => '命令执行已取消',
			'chat.export.sessionTitle' => ({required Object id}) => '会话 ${id}',
			'chat.export.pdfFailed' => 'PDF 导出失败',
			'chat.export.transcriptDownloaded' => '会话记录已下载',
			'chat.export.savedTo' => ({required Object path}) => '已保存 ${path}',
			'chat.message.compactedSummary' => '压缩摘要',
			'chat.message.rawView' => '原始视图',
			'chat.message.resendHint' => '从输入框重新发送',
			'chat.modelLibrary.deleteTooltip' => ({required Object name}) => '删除 ${name}',
			'chat.modelLibrary.editTooltip' => ({required Object name}) => '编辑 ${name}',
			'chat.modelLibrary.enterNameAndId' => '请输入模型名称和模型 ID。',
			'chat.modelLibrary.idNoSpaces' => '模型 ID 不能包含空格。',
			'chat.modelLibrary.setAsDefault' => '设为默认',
			'chat.modelLibrary.defaultModel' => '默认模型',
			'chat.pinFile.action' => '固定',
			'chat.pinFile.pathHint' => 'path/to/file.ext',
			'chat.pinFile.title' => '固定文件',
			'chat.permissionRequest.title' => ({required Object tool}) => '权限请求 · ${tool}',
			'chat.permissionRequest.question' => '问题',
			'codeEditor.toolbar.changes' => '个更改',
			'codeEditor.toolbar.previousChange' => '上一个更改',
			'codeEditor.toolbar.nextChange' => '下一个更改',
			'codeEditor.toolbar.hideDiff' => '隐藏差异高亮',
			'codeEditor.toolbar.showDiff' => '显示差异高亮',
			'codeEditor.toolbar.settings' => '编辑器设置',
			'codeEditor.toolbar.collapse' => '折叠编辑器',
			'codeEditor.toolbar.expand' => '展开编辑器到全宽',
			'codeEditor.toolbar.diffMerge' => '差异 / 合并',
			'codeEditor.toolbar.previewInBrowser' => '在浏览器中预览',
			'codeEditor.toolbar.reload' => '从磁盘重新加载',
			'codeEditor.toolbar.toggleDock' => '切换文件停靠栏',
			'codeEditor.loading' => ({required Object fileName}) => '正在加载 ${fileName}...',
			'codeEditor.header.showingChanges' => '显示更改',
			'codeEditor.actions.copyPath' => '复制文件路径',
			'codeEditor.actions.pathCopied' => '文件路径已复制',
			'codeEditor.actions.download' => '下载文件',
			'codeEditor.actions.save' => '保存',
			'codeEditor.actions.saving' => '保存中...',
			'codeEditor.actions.saved' => '已保存！',
			'codeEditor.actions.exitFullscreen' => '退出全屏',
			'codeEditor.actions.fullscreen' => '全屏',
			'codeEditor.actions.close' => '关闭',
			'codeEditor.actions.previewMarkdown' => '预览 Markdown',
			'codeEditor.actions.editMarkdown' => '编辑 Markdown',
			'codeEditor.actions.pinFile' => '将文件固定到上下文',
			'codeEditor.actions.unpinFile' => '从上下文取消固定文件',
			'codeEditor.actions.previewHtml' => '在新标签页中打开 HTML 预览',
			'codeEditor.actions.retry' => '重试',
			'codeEditor.actions.saveAll' => '全部保存',
			'codeEditor.footer.lines' => '行数：',
			'codeEditor.footer.characters' => '字符数：',
			'codeEditor.footer.shortcuts' => '按 Ctrl+S 保存 • Esc 关闭',
			'codeEditor.binaryFile.title' => '二进制文件',
			'codeEditor.binaryFile.message' => ({required Object fileName}) => '文件 "${fileName}" 无法在文本编辑器中显示，因为它是二进制文件。',
			'codeEditor.binaryFile.cannotDisplayAsText' => '无法以文本形式显示',
			'codeEditor.filePreview.loading' => '正在加载预览...',
			'codeEditor.filePreview.error' => '无法显示此文件。',
			'codeEditor.filePreview.openInNewTab' => '在新标签页中打开',
			'codeEditor.diff.applyMerge' => '应用合并',
			'codeEditor.diff.base' => '基准',
			'codeEditor.diff.close' => '关闭差异',
			'codeEditor.diff.current' => '当前',
			'codeEditor.diff.hunk' => ({required Object number}) => '区块 ${number}',
			'codeEditor.diff.noChanges' => '没有更改',
			'codeEditor.diff.deletedOnDisk' => '已在磁盘上删除',
			'codeEditor.discardUnsavedChanges' => '放弃未保存的更改？',
			'codeEditor.emptyState.title' => '没有打开的文件',
			'codeEditor.failedToLoad' => '加载文件失败',
			'codeEditor.hexDump.more' => ({required Object size}) => '… 还有 ${size}',
			'codeEditor.mediaFile.subtitle' => '暂不支持音频/视频预览',
			'codeEditor.mediaFile.title' => '媒体文件',
			'codeEditor.settings.fontSizeDecrease' => ({required Object size}) => '字体大小 −  （当前 ${size}）',
			'codeEditor.settings.fontSizeIncrease' => '字体大小 +',
			'codeEditor.settings.minimap' => '缩略图',
			'codeEditor.settings.tabSize' => ({required Object size}) => 'Tab 大小：${size}',
			'codeEditor.unsavedChanges' => ({required Object name}) => '${name} 中有未保存的更改',
			'codeEditor.toasts.savedFile' => ({required Object name}) => '已保存 ${name}',
			'codeEditor.toasts.saveFailed' => '保存失败',
			'codeEditor.toasts.allSaved' => '全部已保存',
			'codeEditor.toasts.someSavesFailed' => '部分保存失败',
			'codeEditor.toasts.savedTo' => ({required Object path}) => '已保存到 ${path}',
			'codeEditor.toasts.mergeApplied' => '已应用合并 — 保存以保留更改',
			'common.buttons.save' => '保存',
			'common.buttons.cancel' => '取消',
			'common.buttons.delete' => '删除',
			'common.buttons.create' => '创建',
			'common.buttons.edit' => '编辑',
			'common.buttons.close' => '关闭',
			'common.buttons.confirm' => '确认',
			'common.buttons.submit' => '提交',
			'common.buttons.retry' => '重试',
			'common.buttons.refresh' => '刷新',
			'common.buttons.search' => '搜索',
			'common.buttons.clear' => '清除',
			'common.buttons.copy' => '复制',
			'common.buttons.download' => '下载',
			'common.buttons.upload' => '上传',
			'common.buttons.browse' => '浏览',
			'common.buttons.openDiagram' => '打开图表',
			'common.buttons.update' => '更新',
			'common.tabs.chat' => '聊天',
			'common.tabs.shell' => '终端',
			'common.tabs.files' => '文件',
			'common.tabs.git' => '源代码管理',
			'common.tabs.tasks' => '任务',
			'common.tabs.browser' => '浏览器',
			'common.tabs.computer' => '计算机',
			'common.tabs.board' => '看板',
			'common.tabs.usage' => 'AI Control',
			'common.status.loading' => '加载中...',
			'common.status.success' => '成功',
			'common.status.error' => '错误',
			'common.status.failed' => '失败',
			'common.status.pending' => '待处理',
			'common.status.completed' => '已完成',
			'common.status.inProgress' => '进行中',
			'common.messages.savedSuccessfully' => '保存成功',
			'common.messages.deletedSuccessfully' => '删除成功',
			'common.messages.updatedSuccessfully' => '更新成功',
			'common.messages.operationFailed' => '操作失败',
			'common.messages.networkError' => '网络错误，请检查您的连接。',
			'common.messages.unauthorized' => '未授权，请登录。',
			'common.messages.notFound' => '未找到',
			'common.messages.invalidInput' => '输入无效',
			'common.messages.requiredField' => '此字段为必填项',
			'common.messages.unknownError' => '发生未知错误',
			'common.messages.renameSessionFailed' => '重命名会话失败。请重试。',
			'common.navigation.settings' => '设置',
			'common.navigation.home' => '首页',
			'common.navigation.back' => '返回',
			'common.navigation.next' => '下一步',
			'common.navigation.previous' => '上一步',
			'common.navigation.logout' => '退出登录',
			'common.common.language' => '语言',
			'common.common.theme' => '主题',
			'common.common.darkMode' => '深色模式',
			'common.common.lightMode' => '浅色模式',
			'common.common.name' => '名称',
			'common.common.description' => '描述',
			'common.common.enabled' => '已启用',
			'common.common.disabled' => '已禁用',
			'common.common.optional' => '可选',
			'common.common.version' => '版本',
			'common.common.select' => '选择',
			'common.common.selectAll' => '全选',
			'common.common.deselectAll' => '取消全选',
			'common.common.done' => '完成',
			'common.common.failed' => '失败',
			'common.time.justNow' => '刚刚',
			'common.time.minutesAgo' => ({required Object count}) => '${count} 分钟前',
			'common.time.hoursAgo' => ({required Object count}) => '${count} 小时前',
			'common.time.daysAgo' => ({required Object count}) => '${count} 天前',
			'common.time.yesterday' => '昨天',
			'common.fileOperations.newFile' => '新建文件',
			'common.fileOperations.newFolder' => '新建文件夹',
			'common.fileOperations.rename' => '重命名',
			'common.fileOperations.move' => '移动',
			'common.fileOperations.copyPath' => '复制路径',
			'common.fileOperations.openInEditor' => '在编辑器中打开',
			'common.mainContent.loading' => '正在加载 ddagent',
			'common.mainContent.settingUpWorkspace' => '正在设置您的工作空间...',
			'common.mainContent.chooseProject' => '选择您的项目',
			'common.mainContent.selectProjectDescription' => '从侧边栏选择一个项目以开始使用 Claude 进行编程。每个项目包含您的聊天会话和文件历史。',
			'common.mainContent.tip' => '提示',
			'common.mainContent.createProjectMobile' => '点击上方的菜单按钮以访问项目',
			_ => null,
		} ?? switch (path) {
			'common.mainContent.createProjectDesktop' => '点击侧边栏中的文件夹图标以创建新项目',
			'common.mainContent.newSession' => '新会话',
			'common.mainContent.untitledSession' => '未命名会话',
			'common.mainContent.projectFiles' => '项目文件',
			'common.mainContent.focusMode' => '专注模式 (Ctrl+Shift+F)',
			'common.mainContent.exitFocusMode' => '退出专注模式 (Ctrl+Shift+F)',
			'common.mainContent.splitSession' => '分屏会话',
			'common.mainContent.closeSplitSession' => '关闭分屏会话',
			'common.mainContent.chooseWorkspace' => '选择工作区',
			'common.mainContent.chooseWorkspaceDescription' => '为此聊天选择一个工作区，或在设置中创建新工作区。',
			'common.mainContent.createWorkspace' => '在设置中创建工作区',
			'common.mainContent.recentProjects' => '最近项目',
			'common.fileTree.loading' => '正在加载文件...',
			'common.fileTree.files' => '文件',
			'common.fileTree.simpleView' => '简单视图',
			'common.fileTree.compactView' => '紧凑视图',
			'common.fileTree.detailedView' => '详细视图',
			'common.fileTree.searchPlaceholder' => '搜索文件和文件夹...',
			'common.fileTree.clearSearch' => '清除搜索',
			'common.fileTree.name' => '名称',
			'common.fileTree.size' => '大小',
			'common.fileTree.modified' => '修改时间',
			'common.fileTree.permissions' => '权限',
			'common.fileTree.noFilesFound' => '未找到文件',
			'common.fileTree.checkProjectPath' => '检查项目路径是否可访问',
			'common.fileTree.noMatchesFound' => '未找到匹配项',
			'common.fileTree.tryDifferentSearch' => '尝试不同的搜索词或清除搜索',
			'common.fileTree.justNow' => '刚刚',
			'common.fileTree.minAgo' => ({required Object count}) => '${count} 分钟前',
			'common.fileTree.hoursAgo' => ({required Object count}) => '${count} 小时前',
			'common.fileTree.daysAgo' => ({required Object count}) => '${count} 天前',
			'common.fileTree.newFile' => '新建文件 (Cmd+N)',
			'common.fileTree.newFolder' => '新建文件夹 (Cmd+Shift+N)',
			'common.fileTree.refresh' => '刷新',
			'common.fileTree.collapseAll' => '全部折叠',
			'common.fileTree.context.rename' => '重命名',
			'common.fileTree.context.delete' => '删除',
			'common.fileTree.context.copyPath' => '复制路径',
			'common.fileTree.context.download' => '下载',
			'common.fileTree.context.newFile' => '新建文件',
			'common.fileTree.context.newFolder' => '新建文件夹',
			'common.fileTree.context.upload' => '上传文件',
			'common.fileTree.context.refresh' => '刷新',
			'common.fileTree.context.menuLabel' => '文件上下文菜单',
			'common.fileTree.context.loading' => '加载中...',
			'common.fileTree.searchContentPlaceholder' => '在文件中搜索...',
			'common.fileTree.searchInFiles' => '在文件中搜索',
			'common.fileTree.searchByName' => '按名称搜索',
			'common.fileTree.loadFailed' => '无法加载文件',
			'common.fileTree.noSearchResults' => '未找到匹配项',
			'common.fileTree.searchError' => '搜索失败',
			'common.fileTree.searching' => '正在搜索...',
			'common.fileTree.resultsTruncated' => ({required Object count}) => '显示前 ${count} 条结果',
			'common.fileTree.allWorkspaces' => '所有工作区',
			'common.fileTree.delete.confirm' => '删除',
			'common.fileTree.delete.fileWarning' => '此文件将被永久删除。',
			'common.fileTree.delete.folderWarning' => '此文件夹及其所有内容将被永久删除。',
			'common.fileTree.delete.title' => ({required Object type}) => '删除${type}',
			'common.fileTree.dropToUpload' => '拖放文件以上传',
			'common.fileTree.dropToUploadTo' => ({required Object folder}) => '拖放文件以上传到“${folder}”',
			'common.fileTree.noProject' => '请先添加项目',
			'common.fileTree.noRecentFiles' => '最近 7 天没有文件变更',
			'common.fileTree.showAllFiles' => '显示所有文件',
			'common.fileTree.showAllFilesHint' => '关闭最近筛选器以查看全部。',
			'common.fileTree.showRecentOnly' => '显示最近 7 天变更的文件',
			'common.fileTree.toast.copyFailed' => '复制路径失败',
			'common.fileTree.toast.fileCreated' => '文件创建成功',
			'common.fileTree.toast.fileDeleted' => '文件已删除',
			'common.fileTree.toast.folderCreated' => '文件夹创建成功',
			'common.fileTree.toast.folderDeleted' => '文件夹已删除',
			'common.fileTree.toast.folderDownloaded' => '文件夹已下载为 ZIP',
			'common.fileTree.toast.pathCopied' => '路径已复制到剪贴板',
			'common.fileTree.toast.renamed' => '重命名成功',
			'common.fileTree.uploadComplete' => '上传完成',
			'common.fileTree.uploadFailed' => '上传失败',
			'common.fileTree.uploadFiles' => ({required Object size}) => '上传文件（每个最大 ${size}）',
			'common.fileTree.uploadToFolder' => ({required Object folder}) => '上传文件到“${folder}”',
			'common.fileTree.uploadedCount' => ({required Object total, required Object label, required Object uploaded}) => '已上传 ${total} ${label} 中的 ${uploaded} 个',
			'common.fileTree.uploadingFiles' => '正在上传文件',
			'common.fileTree.validation.dotsOnly' => '文件名不能只包含点',
			'common.fileTree.validation.emptyName' => '文件名不能为空',
			'common.fileTree.validation.invalidChars' => '文件名包含无效字符',
			'common.fileTree.validation.reserved' => '文件名是保留名称',
			'common.projectWizard.title' => '创建新项目',
			'common.projectWizard.steps.type' => '类型',
			'common.projectWizard.steps.configure' => '配置',
			'common.projectWizard.steps.confirm' => '确认',
			'common.projectWizard.step1.question' => '您已经有工作区，还是想创建一个新的工作区？',
			'common.projectWizard.step1.existing.title' => '现有工作区',
			'common.projectWizard.step1.existing.description' => '我的服务器上已经有工作区，只需要将其添加到项目列表中',
			'common.projectWizard.step1.kNew.title' => '新建工作区',
			'common.projectWizard.step1.kNew.description' => '创建一个新工作区，可选择从 GitHub 仓库克隆',
			'common.projectWizard.step2.existingPath' => '工作区路径',
			'common.projectWizard.step2.newPath' => '工作区路径',
			'common.projectWizard.step2.existingPlaceholder' => '/path/to/existing/workspace',
			'common.projectWizard.step2.newPlaceholder' => '/path/to/new/workspace',
			'common.projectWizard.step2.existingHelp' => '您现有工作区目录的完整路径',
			'common.projectWizard.step2.newHelp' => '工作区目录的完整路径',
			'common.projectWizard.step2.githubUrl' => 'GitHub URL（可选）',
			'common.projectWizard.step2.githubPlaceholder' => 'https://github.com/username/repository',
			'common.projectWizard.step2.githubHelp' => '可选：提供 GitHub URL 以克隆仓库',
			'common.projectWizard.step2.githubAuth' => 'GitHub 身份验证（可选）',
			'common.projectWizard.step2.githubAuthHelp' => '仅私有仓库需要。公共仓库无需身份验证即可克隆。',
			'common.projectWizard.step2.loadingTokens' => '正在加载已保存的令牌...',
			'common.projectWizard.step2.storedToken' => '已保存的令牌',
			'common.projectWizard.step2.newToken' => '新令牌',
			'common.projectWizard.step2.nonePublic' => '无（公共）',
			'common.projectWizard.step2.selectToken' => '选择令牌',
			'common.projectWizard.step2.selectTokenPlaceholder' => '-- 选择令牌 --',
			'common.projectWizard.step2.tokenPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
			'common.projectWizard.step2.tokenHelp' => '此令牌仅用于此操作',
			'common.projectWizard.step2.publicRepoInfo' => '公共仓库不需要身份验证。如果克隆公共仓库，可以跳过提供令牌。',
			'common.projectWizard.step2.noTokensHelp' => '没有可用的已保存令牌。您可以在 设置 → API 密钥 中添加令牌以便重复使用。',
			'common.projectWizard.step2.optionalTokenPublic' => 'GitHub 令牌（公共仓库可选）',
			'common.projectWizard.step2.tokenPublicPlaceholder' => 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx（公共仓库可留空）',
			'common.projectWizard.step3.reviewConfig' => '查看您的配置',
			'common.projectWizard.step3.existingWorkspace' => '现有工作区',
			'common.projectWizard.step3.newWorkspace' => '新建工作区',
			'common.projectWizard.step3.path' => '路径：',
			'common.projectWizard.step3.cloneFrom' => '克隆自：',
			'common.projectWizard.step3.authentication' => '身份验证：',
			'common.projectWizard.step3.usingStoredToken' => '使用已保存的令牌：',
			'common.projectWizard.step3.usingProvidedToken' => '使用提供的令牌',
			'common.projectWizard.step3.noAuthentication' => '无身份验证',
			'common.projectWizard.step3.sshKey' => 'SSH 密钥',
			'common.projectWizard.step3.existingInfo' => '工作区将被添加到您的项目列表中，并可用于 Claude/Cursor 会话。',
			'common.projectWizard.step3.newWithClone' => '仓库将从此文件夹克隆。',
			'common.projectWizard.step3.newEmpty' => '工作区将被添加到您的项目列表中，并可用于 Claude/Cursor 会话。',
			'common.projectWizard.step3.cloningRepository' => '正在克隆仓库...',
			'common.projectWizard.buttons.cancel' => '取消',
			'common.projectWizard.buttons.back' => '返回',
			'common.projectWizard.buttons.next' => '下一步',
			'common.projectWizard.buttons.createProject' => '创建项目',
			'common.projectWizard.buttons.creating' => '创建中...',
			'common.projectWizard.buttons.cloning' => '正在克隆...',
			'common.projectWizard.errors.selectType' => '请选择您已有现有工作区还是想创建新工作区',
			'common.projectWizard.errors.providePath' => '请提供工作区路径',
			'common.projectWizard.errors.failedToCreate' => '创建工作区失败',
			'common.projectWizard.errors.failedToCreateFolder' => '创建文件夹失败',
			'common.notifications.genericTool' => '工具',
			'common.notifications.codes.generic.info.title' => '通知',
			'common.notifications.codes.permission.required.title' => '需要处理',
			'common.notifications.codes.permission.required.body' => ({required Object toolName}) => '${toolName} 正在等待你的决策。',
			'common.notifications.codes.run.stopped.title' => '运行已停止',
			'common.notifications.codes.run.stopped.body' => ({required Object reason}) => '原因：${reason}',
			'common.notifications.codes.run.failed.title' => '运行失败',
			'common.notifications.codes.agent.notification.title' => 'Agent 通知',
			'common.versionUpdate.title' => '有可用更新',
			'common.versionUpdate.newVersionReady' => '新版本已准备就绪',
			'common.versionUpdate.currentVersion' => '当前版本',
			'common.versionUpdate.latestVersion' => '最新版本',
			'common.versionUpdate.whatsNew' => '新内容：',
			'common.versionUpdate.viewFullRelease' => '查看完整发布',
			'common.versionUpdate.updateProgress' => '更新进度：',
			'common.versionUpdate.manualUpgrade' => '手动升级：',
			'common.versionUpdate.npmUpgradeCommand' => 'npm install -g @ddagent-ai/ddagent@latest',
			'common.versionUpdate.manualUpgradeHint' => '或点击\'立即更新\'以自动运行更新。',
			'common.versionUpdate.updateCompleted' => '更新成功完成！',
			'common.versionUpdate.restartServer' => '请重启服务器以应用更改。',
			'common.versionUpdate.updateFailed' => '更新失败',
			'common.versionUpdate.buttons.close' => '关闭',
			'common.versionUpdate.buttons.later' => '稍后',
			'common.versionUpdate.buttons.copyCommand' => '复制命令',
			'common.versionUpdate.buttons.updateNow' => '立即更新',
			'common.versionUpdate.buttons.updating' => '更新中...',
			'common.versionUpdate.ariaLabels.closeModal' => '关闭版本升级模态框',
			'common.versionUpdate.ariaLabels.showSidebar' => '显示侧边栏',
			'common.versionUpdate.ariaLabels.settings' => '设置',
			'common.versionUpdate.ariaLabels.updateAvailable' => '有可用更新',
			'common.versionUpdate.ariaLabels.closeSidebar' => '关闭侧边栏',
			'common.quota.controlCenter' => 'AI Control Center',
			'common.quota.section.overview' => '概览',
			'common.quota.section.quotas' => '额度',
			'common.quota.section.usage' => '用量',
			'common.quota.section.agents' => '代理',
			'common.quota.filter.all' => '全部',
			'common.quota.period.k24h' => '24h',
			'common.quota.period.k7d' => '7 天',
			'common.quota.period.k30d' => '30 天',
			'common.quota.period.all' => '全部',
			'common.quota.group.provider' => '提供商',
			'common.quota.group.model' => '模型',
			'common.quota.group.agent' => '代理',
			'common.quota.group.tool' => '工具',
			'common.quota.metric.tokens' => '令牌',
			'common.quota.metric.input' => '输入',
			'common.quota.metric.output' => '输出',
			'common.quota.metric.cache' => '缓存读取',
			'common.quota.metric.calls' => 'API 调用',
			'common.quota.metric.cost' => '成本',
			'common.quota.metric.sessions' => '会话',
			'common.quota.cost.billed' => '已计费（API + 超额）',
			'common.quota.cost.listPrice' => '已用令牌的标价',
			'common.quota.cost.subscriptionValue' => '订阅覆盖',
			'common.quota.cost.cacheSavings' => '缓存节省',
			'common.quota.cost3.billed' => '已计费（API + 超额）',
			'common.quota.cost3.listPrice' => '已用令牌的标价',
			'common.quota.cost3.subscriptionValue' => '订阅覆盖',
			'common.quota.overview.trendTitle' => '令牌与成本 — 最近 7 天',
			'common.quota.overview.effectiveCost' => '实际成本（7 天）',
			'common.quota.overview.alertsTitle' => '提醒',
			'common.quota.overview.noAlerts' => '目前没有需要注意的事项。',
			'common.quota.overview.limitsTitle' => '用量与限额',
			'common.quota.overview.activeTasks' => '活跃任务',
			'common.quota.overview.viewAccounts' => '所有账户',
			'common.quota.overview.viewAgents' => '所有代理',
			'common.quota.overview.noTasks' => '目前没有正在运行的代理。',
			'common.quota.usage.trendTitle' => '每日趋势',
			'common.quota.usage.breakdownTitle' => ({required Object group}) => '按 ${group} 细分',
			'common.quota.usage.colName' => '名称',
			'common.quota.usage.sourceUnavailable' => '分析存储不可用；未显示数据。',
			'common.quota.agents.runningCount' => ({required Object value}) => '${value} 个运行中',
			'common.quota.agents.colAgent' => '代理',
			'common.quota.agents.colStatus' => '状态',
			'common.quota.agents.colTask' => '任务',
			'common.quota.agents.colModel' => '账户 / 模型',
			'common.quota.agents.colTime' => '时间',
			'common.quota.agents.empty' => '没有代理匹配此筛选器。',
			'common.quota.agents.detailSession' => '会话',
			'common.quota.agents.detailStarted' => '已开始',
			'common.quota.agents.detailRetries' => '重试次数',
			'common.quota.agents.detailResult' => '结果',
			'common.quota.agents.notTracked' => '未跟踪',
			'common.quota.agentStatus.running' => '运行中',
			'common.quota.agentStatus.waiting' => '等待中',
			'common.quota.agentStatus.failed' => '失败',
			'common.quota.agentStatus.finished' => '已完成',
			'common.quota.agentStatus.queued' => '排队中',
			'common.quota.alert.pace' => ({required Object account, required Object window, required Object value}) => '${account} · ${window}：按当前速度，额度将在 ${value} 后耗尽',
			'common.quota.alert.threshold' => ({required Object account, required Object window, required Object value, required Object watch}) => '${account} · ${window}：已用 ${value}%（阈值 ${watch}%）',
			'common.quota.backToChat' => '返回聊天',
			'common.quota.syncNow' => '立即同步',
			'common.quota.generatedAt' => ({required Object value}) => '更新于 ${value}',
			'common.quota.loading' => '正在加载账户额度…',
			'common.quota.remaining' => ({required Object value}) => '剩余 ${value}%',
			'common.quota.resetsIn' => ({required Object value}) => '${value} 后重置',
			'common.quota.projected' => ({required Object value}) => '按当前速度，此额度将在 ${value} 后耗尽',
			'common.quota.syncedAgo' => ({required Object value}) => '${value} 前已同步',
			'common.quota.refreshAccount' => '刷新账户',
			'common.quota.syncFailed' => '同步失败',
			'common.quota.history' => '历史',
			'common.quota.historyPoints' => ({required Object value}) => '已记录 ${value} 条读数',
			'common.quota.historyEmpty' => '尚无历史记录',
			'common.quota.noAgents' => '未分配代理',
			'common.quota.noSubscription' => '无订阅',
			'common.quota.noSubscriptionHint' => '提供商未报告此账户有有效套餐。',
			'common.quota.quality.live' => '实时',
			'common.quota.quality.cached' => '缓存',
			'common.quota.quality.estimate' => '估计',
			'common.quota.quality.unknown' => '未知',
			'common.quota.quality.error' => '错误',
			'common.quota.kpi.atRisk' => '有风险的额度',
			'common.quota.kpi.atRiskHint' => ({required Object value}) => '超过 ${value}% 的账户',
			'common.quota.kpi.windowsAtRisk' => '即将耗尽的窗口',
			'common.quota.kpi.errored' => '同步失败',
			'common.quota.kpi.activeAgents' => '活跃代理',
			'common.quota.kpi.agentsHint' => ({required Object waiting, required Object queued}) => '${waiting} 等待 · ${queued} 排队',
			'common.quota.kpi.nextReset' => '下次重置',
			'common.quota.kpi.tokens' => '令牌',
			'common.quota.kpi.sessionsHint' => ({required Object value}) => '${value} 个会话',
			'common.quota.kpi.cost' => '预估成本',
			'common.quota.kpi.costHint' => ({required Object value}) => '${value} 由套餐覆盖',
			'common.quota.empty.title' => '未连接任何账户',
			'common.quota.empty.description' => '登录 Claude、Codex、Gemini 或 CommandCode 即可在此跟踪额度。',
			'common.quota.settings.title' => '提醒与路由',
			'common.quota.settings.description' => '控制仪表板何时警告你，以及如何为新工作推荐账户。',
			'common.quota.settings.alertsEnabled' => '预测与阈值提醒',
			'common.quota.settings.alertsEnabledHint' => '在额度按当前速度耗尽之前警告，而不是等到 90%。',
			'common.quota.settings.watchThreshold' => '观察阈值（%）',
			'common.quota.settings.dangerThreshold' => '危险阈值（%）',
			'common.quota.settings.routingMode' => '路由',
			'common.quota.settings.routing.manual' => '手动 — 仅建议',
			'common.quota.settings.routing.ask' => '切换账户前询问',
			'common.quota.settings.routing.autoLowRisk' => '低风险任务自动切换',
			'common.quota.settings.logSources' => '日志来源',
			'common.quota.settings.logSourcesHint' => '用量和代理屏幕读取这些只读来源。',
			'common.quota.settings.quotaConsent' => '允许额度轮询',
			'common.quota.settings.quotaConsentHint' => '使用你存储的凭据轮询提供商端点以读取实时额度。',
			'common.quota.settings.perAccount' => '按账户覆盖',
			'common.quota.settings.tab' => 'Control Center 设置',
			'common.quota.range.k24h' => '24h',
			'common.quota.range.k7d' => '7d',
			'common.quota.range.k30d' => '30d',
			'common.quota.range.all' => '全部',
			'common.actions.cancel' => '取消',
			'common.actions.retry' => '重试',
			'common.actions.save' => '保存',
			'common.browserPane.address' => '地址',
			'common.browserPane.back' => '后退',
			'common.browserPane.connecting' => '正在连接浏览器…',
			'common.browserPane.connectionFailed' => '浏览器连接失败。',
			'common.browserPane.couldNotLoad' => ({required Object url}) => '无法加载 ${url}',
			'common.browserPane.disconnected' => '浏览器视图已断开',
			'common.browserPane.enterUrl' => '输入 URL',
			'common.browserPane.forward' => '前进',
			'common.browserPane.invalidUrl' => '请输入有效的 http(s) URL',
			'common.browserPane.noAuthToken' => '没有可用的身份验证令牌。',
			'common.browserPane.openExternal' => '在系统浏览器中打开',
			'common.browserPane.reload' => '重新加载',
			'common.browserPane.retry' => '重试',
			'common.browserPane.stop' => '停止',
			'common.browserUse.activeCount' => ({required Object count}) => '${count} 个活跃',
			'common.browserUse.cancel' => '取消',
			'common.browserUse.close' => '关闭',
			'common.browserUse.delete' => '删除',
			'common.browserUse.deleteDesc' => ({required Object name}) => '${name} 将被永久删除。',
			'common.browserUse.deleteSession' => '删除会话',
			'common.browserUse.deleteTitle' => '删除浏览器会话？',
			'common.browserUse.empty.descDisabled' => '在设置中启用 Browser，让代理可以打开受监控的浏览器会话。',
			'common.browserUse.empty.descEnabled' => '当 AI 任务使用 Browser 时，代理浏览器会话会显示在这里。',
			'common.browserUse.empty.titleDisabled' => 'Browser 已禁用',
			'common.browserUse.empty.titleEnabled' => '暂无浏览器会话',
			'common.browserUse.emptyStatus' => '空',
			'common.browserUse.errors.actionFailed' => '浏览器操作失败',
			'common.browserUse.errors.loadFailed' => 'Browser 加载失败',
			'common.browserUse.fullscreen' => '全屏',
			'common.browserUse.installRuntime' => '安装运行时',
			'common.browserUse.installing' => '正在安装...',
			'common.browserUse.lastAction' => '最后操作',
			'common.browserUse.nextSnapshot' => '代理浏览器的下一个快照将显示在这里。',
			'common.browserUse.noPageLoaded' => '未加载页面',
			'common.browserUse.noSessions' => '没有代理浏览器会话。',
			'common.browserUse.none' => '无',
			'common.browserUse.openSettings' => '打开 Browser 设置',
			'common.browserUse.profile' => '配置文件',
			'common.browserUse.promptLabel' => '提示词',
			'common.browserUse.prompts.prompt1' => '使用 Browser 检查结账流程并报告任何损坏的 UI 状态。',
			'common.browserUse.prompts.prompt2' => '用 Browser 打开 <url>，与页面交互，并总结每一步之后的变化。',
			'common.browserUse.refresh' => '刷新浏览器会话',
			'common.browserUse.relative.daysAgo' => ' 天前',
			'common.browserUse.relative.hoursAgo' => ' 小时前',
			'common.browserUse.relative.justNow' => '刚刚',
			'common.browserUse.relative.minutesAgo' => ' 分钟前',
			'common.browserUse.relative.never' => '从未',
			'common.browserUse.relative.secondsAgo' => ' 秒前',
			'common.browserUse.relative.unknown' => '未知',
			'common.browserUse.runtime.disabled' => '已禁用',
			'common.browserUse.runtime.installing' => '安装中',
			'common.browserUse.runtime.ready' => '就绪',
			'common.browserUse.runtime.setupRequired' => '需要设置',
			'common.browserUse.runtimeSetup' => '需要设置运行时',
			'common.browserUse.selected' => '已选中',
			'common.browserUse.sessionFallback' => '浏览器会话',
			'common.browserUse.sessionScreenshot' => '浏览器会话截图',
			'common.browserUse.sessions' => '会话',
			'common.browserUse.status' => '状态',
			'common.browserUse.stop' => '停止',
			'common.browserUse.stopSession' => '停止会话',
			'common.browserUse.subtitle' => '监控 AI 代理打开的浏览器会话。',
			'common.browserUse.temporary' => '临时',
			'common.browserUse.thisSession' => '此会话',
			'common.browserUse.title' => 'Browser',
			'common.browserUse.totalCount' => ({required Object count}) => '共 ${count} 个',
			'common.browserUse.updated' => ({required Object time}) => '更新于 ${time}',
			'common.browserUse.waiting' => '等待中',
			'common.browserUse.waitingForScreenshot' => '等待截图',
			'common.commandPalette.backToAll' => '返回全部',
			'common.commandPalette.backspaceHint' => '按 Backspace 返回',
			'common.commandPalette.browseAll.branches' => ({required Object count}) => '浏览所有分支（${count}）',
			'common.commandPalette.browseAll.commits' => ({required Object count}) => '浏览所有提交（${count}）',
			'common.commandPalette.browseAll.files' => ({required Object count}) => '浏览所有文件（${count}）',
			'common.commandPalette.browseAll.sessions' => ({required Object count}) => '浏览所有会话（${count}）',
			'common.commandPalette.compare.costNote' => '成本是基于已公布每令牌价格的客户端估算；未知模型显示“—”。',
			'common.commandPalette.compare.estCost' => '预估成本',
			'common.commandPalette.compare.inputOutput' => '输入 / 输出',
			'common.commandPalette.compare.model' => '模型',
			'common.commandPalette.compare.na' => '不适用',
			'common.commandPalette.compare.openSplit' => '在分屏视图中打开',
			'common.commandPalette.compare.provider' => '提供商',
			'common.commandPalette.compare.selectSession' => '选择会话…',
			'common.commandPalette.compare.tokensUsed' => '已用令牌',
			'common.commandPalette.groups.actions' => '操作',
			'common.commandPalette.groups.branches' => '分支',
			'common.commandPalette.groups.commits' => '提交',
			'common.commandPalette.groups.files' => '文件',
			'common.commandPalette.groups.git' => 'Git',
			'common.commandPalette.groups.navigate' => '导航',
			'common.commandPalette.groups.sessions' => '会话',
			'common.commandPalette.groups.settings' => '设置',
			'common.commandPalette.hints.close' => '关闭',
			'common.commandPalette.hints.navigate' => '导航',
			'common.commandPalette.hints.select' => '选择',
			'common.commandPalette.hints.togglePalette' => '切换面板',
			'common.commandPalette.items.compareSessions' => '比较会话',
			'common.commandPalette.items.gitFetch' => 'Git：Fetch',
			'common.commandPalette.items.gitPull' => 'Git：Pull',
			'common.commandPalette.items.gitPush' => 'Git：Push',
			'common.commandPalette.items.openSettings' => '打开设置',
			'common.commandPalette.items.selectProjectFirst' => '请先选择一个项目',
			'common.commandPalette.items.settingsEntry' => ({required Object label}) => '设置：${label}',
			'common.commandPalette.items.startNewChat' => '开始新聊天',
			'common.commandPalette.items.switchTo' => ({required Object name}) => '切换到：${name}',
			'common.commandPalette.items.toggleTheme' => '切换主题',
			'common.commandPalette.items.tokensAndCost' => '令牌与成本',
			'common.commandPalette.nav.board' => '前往代理面板',
			'common.commandPalette.nav.chat' => '前往聊天',
			'common.commandPalette.nav.files' => '前往文件',
			'common.commandPalette.nav.git' => '前往 Git',
			'common.commandPalette.nav.sourceControl' => '前往源代码管理',
			'common.commandPalette.nav.tasks' => '前往任务',
			'common.commandPalette.nav.usage' => '前往配额与用量',
			'common.commandPalette.noResults' => '没有结果。',
			'common.commandPalette.pages.actions' => '操作',
			'common.commandPalette.pages.branches' => '分支',
			'common.commandPalette.pages.commits' => '提交',
			'common.commandPalette.pages.compare' => '比较',
			'common.commandPalette.pages.files' => '文件',
			'common.commandPalette.pages.sessions' => '会话',
			'common.commandPalette.placeholder' => '输入以搜索任何内容…',
			'common.commandPalette.searchPagePlaceholder' => ({required Object page}) => '搜索 ${page}…',
			'common.commandPalette.title' => '命令面板',
			'common.gitPanel.ahead' => ({required Object count}) => '领先 ${count}',
			'common.gitPanel.aheadLabel' => '领先',
			'common.gitPanel.aiSuggest' => 'AI 建议',
			'common.gitPanel.aiSuggestTitle' => '用 AI 生成提交消息',
			'common.gitPanel.all' => '全部',
			'common.gitPanel.allStaged' => '所有更改已暂存',
			'common.gitPanel.behind' => ({required Object count}) => '落后 ${count}',
			'common.gitPanel.behindLabel' => '落后',
			'common.gitPanel.branches.confirmDelete' => ({required Object branch}) => '删除分支“${branch}”？普通删除仅在分支完全合并时成功。此操作无法撤销。',
			'common.gitPanel.branches.confirmSwitch' => ({required Object branch}) => '切换到分支“${branch}”？请确保没有未提交的更改。',
			'common.gitPanel.branches.countBoth' => ({required Object local, required Object remote}) => '${local} 个本地，${remote} 个远程',
			'common.gitPanel.branches.countLocal' => ({required Object count}) => '${count} 个本地',
			'common.gitPanel.branches.current' => '当前',
			'common.gitPanel.branches.deleteTitle' => ({required Object branch}) => '删除 ${branch}',
			'common.gitPanel.branches.emptyDesc' => '创建一个分支以开始并行工作。',
			'common.gitPanel.branches.forceDelete' => '强制删除',
			'common.gitPanel.branches.forceDeleteDesc' => '即使分支包含未合并到其他地方的提交，也会永久删除该分支。',
			'common.gitPanel.branches.forceDeleteLabel' => '强制删除此未合并的分支',
			'common.gitPanel.branches.local' => '本地',
			'common.gitPanel.branches.kNew' => '新建分支',
			'common.gitPanel.branches.noMatch' => '没有匹配搜索的分支',
			'common.gitPanel.branches.none' => '未找到分支',
			'common.gitPanel.branches.remote' => '远程',
			'common.gitPanel.branches.kSwitch' => '切换',
			'common.gitPanel.branches.switchTo' => ({required Object branch}) => '切换到 ${branch}',
			'common.gitPanel.cancel' => '取消',
			'common.gitPanel.changesCount' => ({required Object count}) => '更改（${count}）',
			'common.gitPanel.clearSearch' => '清除搜索',
			'common.gitPanel.collapseDiff' => '折叠差异',
			'common.gitPanel.commit' => '提交',
			'common.gitPanel.commitChanges' => '提交更改',
			'common.gitPanel.commitFiles' => ({required Object count}) => '提交 ${count} 个文件',
			'common.gitPanel.committing' => '正在提交...',
			'common.gitPanel.confirmActions.commit' => '确认',
			'common.gitPanel.confirmActions.delete' => '删除',
			'common.gitPanel.confirmActions.deleteBranch' => '删除',
			'common.gitPanel.confirmActions.discard' => '放弃',
			'common.gitPanel.confirmActions.publish' => '发布',
			'common.gitPanel.confirmActions.pull' => '拉取',
			'common.gitPanel.confirmActions.push' => '推送',
			'common.gitPanel.confirmActions.revertLocalCommit' => '还原提交',
			'common.gitPanel.confirmCommit' => ({required Object message, required Object count}) => '以消息“${message}”提交 ${count} 个文件？',
			'common.gitPanel.confirmDeleteFile' => ({required Object file}) => '删除未跟踪的文件“${file}”？此操作无法撤销。',
			'common.gitPanel.confirmDiscardFile' => ({required Object file}) => '放弃对“${file}”的所有更改？此操作无法撤销。',
			'common.gitPanel.confirmPublish' => ({required Object branch, required Object remote}) => '将分支“${branch}”发布到 ${remote}？',
			'common.gitPanel.confirmPull' => ({required Object remote, required Object count}) => '从 ${remote} 拉取 ${count} 个提交？',
			'common.gitPanel.confirmPush' => ({required Object count, required Object remote}) => '推送 ${count} 个提交到 ${remote}？',
			'common.gitPanel.confirmRevert' => '还原最新的本地提交？这会删除提交但保留其更改为暂存状态。',
			'common.gitPanel.confirmTitles.commit' => '确认操作',
			'common.gitPanel.confirmTitles.delete' => '删除文件',
			'common.gitPanel.confirmTitles.deleteBranch' => '删除分支',
			'common.gitPanel.confirmTitles.discard' => '放弃更改',
			'common.gitPanel.confirmTitles.publish' => '发布分支',
			'common.gitPanel.confirmTitles.pull' => '确认拉取',
			'common.gitPanel.confirmTitles.push' => '确认推送',
			'common.gitPanel.confirmTitles.revertLocalCommit' => '还原本地提交',
			'common.gitPanel.createBranch' => '创建新分支',
			'common.gitPanel.creating' => '正在创建...',
			'common.gitPanel.delete' => '删除',
			'common.gitPanel.deleteUntracked' => '删除未跟踪的文件',
			'common.gitPanel.deselectAll' => '取消全选',
			'common.gitPanel.discard' => '放弃',
			'common.gitPanel.discardChanges' => '放弃更改',
			'common.gitPanel.dismiss' => '关闭',
			'common.gitPanel.dismissError' => '关闭错误',
			'common.gitPanel.errors.createBranchFailed' => '创建分支失败',
			'common.gitPanel.errors.createWorktreeFailed' => '创建 worktree 失败',
			'common.gitPanel.errors.deleteBranchFailed' => '删除分支失败',
			'common.gitPanel.errors.fetchFailed' => 'Fetch 失败',
			'common.gitPanel.errors.initFailed' => '初始化仓库失败',
			'common.gitPanel.errors.initialCommitFailed' => '创建初始提交失败',
			'common.gitPanel.errors.mergeFailed' => '合并失败',
			'common.gitPanel.errors.openWorktreeFailed' => '打开 worktree 失败',
			'common.gitPanel.errors.operationFailed' => 'Git 操作失败',
			'common.gitPanel.errors.publishFailed' => '发布失败',
			'common.gitPanel.errors.pullFailed' => 'Pull 失败',
			'common.gitPanel.errors.pushFailed' => 'Push 失败',
			'common.gitPanel.errors.removeWorktreeFailed' => '移除 worktree 失败',
			'common.gitPanel.errors.stageFailed' => '暂存失败',
			'common.gitPanel.errors.stageHunksFailed' => '暂存区块失败',
			'common.gitPanel.errors.switchFailed' => '切换分支失败',
			'common.gitPanel.errors.unstageFailed' => '取消暂存失败',
			'common.gitPanel.errors.unstageHunksFailed' => '取消区块暂存失败',
			'common.gitPanel.expandDiff' => '展开差异',
			'common.gitPanel.fetch' => '获取',
			'common.gitPanel.fetchTitle' => ({required Object remote}) => '从 ${remote} 获取',
			'common.gitPanel.fetching' => '正在获取…',
			'common.gitPanel.filesSelected' => ({required Object count}) => '已选择 ${count} 个文件',
			'common.gitPanel.generating' => '正在生成...',
			'common.gitPanel.history.added' => '已添加',
			'common.gitPanel.history.author' => '作者',
			'common.gitPanel.history.changedFiles' => '已更改文件',
			'common.gitPanel.history.date' => '日期',
			'common.gitPanel.history.empty' => '未找到提交',
			'common.gitPanel.history.files' => '文件',
			'common.gitPanel.history.removed' => '已移除',
			'common.gitPanel.mergeWorktree.cleanupDesc' => '合并后移除 worktree 并删除其分支',
			'common.gitPanel.mergeWorktree.cleanupLabel' => '合并后清理',
			'common.gitPanel.mergeWorktree.commitCount' => ({required Object count}) => '${count} 个提交',
			'common.gitPanel.mergeWorktree.merge' => '合并',
			'common.gitPanel.mergeWorktree.mergeMessage' => ({required Object branch}) => '合并分支 \'${branch}\'',
			_ => null,
		} ?? switch (path) {
			'common.gitPanel.mergeWorktree.messageLabel' => '提交消息',
			'common.gitPanel.mergeWorktree.squashDesc' => ({required Object commits, required Object branch}) => '将全部 ${commits} 个提交合并为 ${branch} 上的单个提交',
			'common.gitPanel.mergeWorktree.squashLabel' => '压缩提交（squash）',
			'common.gitPanel.mergeWorktree.squashMerge' => '压缩并合并',
			'common.gitPanel.mergeWorktree.squashMessage' => ({required Object branch}) => '压缩合并分支 \'${branch}\'',
			'common.gitPanel.mergeWorktree.title' => '合并 Worktree',
			'common.gitPanel.merging' => '正在合并...',
			'common.gitPanel.messagePlaceholder' => '消息（Ctrl+Enter 提交）',
			'common.gitPanel.newBranch.fromCurrent' => ({required Object branch}) => '这将从当前分支（${branch}）创建新分支',
			'common.gitPanel.newBranch.nameLabel' => '分支名称',
			'common.gitPanel.newBranch.submit' => '创建分支',
			'common.gitPanel.newBranch.title' => '创建新分支',
			'common.gitPanel.newWorktree.branchLabel' => '分支',
			'common.gitPanel.newWorktree.createFrom' => '创建自',
			'common.gitPanel.newWorktree.description' => '将分支检出到独立文件夹中并并行工作。',
			'common.gitPanel.newWorktree.existingBranch' => '现有分支 — 将按原样检出。',
			'common.gitPanel.newWorktree.submit' => '创建 Worktree',
			'common.gitPanel.newWorktree.switchAfter' => '创建后切换到该 worktree',
			'common.gitPanel.newWorktree.title' => '新建 Worktree',
			'common.gitPanel.newWorktree.willCreateIn' => '将创建于',
			'common.gitPanel.noChanges' => '未检测到更改',
			'common.gitPanel.noChangesToCommit' => '没有可提交的更改',
			'common.gitPanel.noCommits.create' => '创建初始提交',
			'common.gitPanel.noCommits.creating' => '正在创建初始提交...',
			'common.gitPanel.noCommits.description' => '此仓库还没有任何提交。创建第一个提交以开始跟踪更改。',
			'common.gitPanel.noCommits.title' => '尚无提交',
			'common.gitPanel.noMatchingBranches' => '没有匹配的分支',
			'common.gitPanel.noRepo.description' => '此项目还不是 git 仓库。初始化一个以开始跟踪更改并使用源代码管理功能。',
			'common.gitPanel.noRepo.init' => '运行 git init',
			'common.gitPanel.noRepo.initializing' => '正在初始化仓库...',
			'common.gitPanel.noRepo.title' => '没有 git 仓库',
			'common.gitPanel.noStagedFiles' => '没有暂存的文件',
			'common.gitPanel.none' => '无',
			'common.gitPanel.nothingToPush' => ({required Object remote}) => '没有可推送到 ${remote} 的内容',
			'common.gitPanel.openFile' => '点击打开文件',
			'common.gitPanel.publish' => '发布',
			'common.gitPanel.publishTitle' => ({required Object branch, required Object remote}) => '将“${branch}”发布到 ${remote}',
			'common.gitPanel.publishing' => '正在发布…',
			'common.gitPanel.pull' => '拉取',
			'common.gitPanel.pullCount' => ({required Object count}) => '拉取 ${count}',
			'common.gitPanel.pullTitle' => ({required Object remote, required Object count}) => '从 ${remote} 拉取 ${count}',
			'common.gitPanel.pulling' => '正在拉取…',
			'common.gitPanel.push' => '推送',
			'common.gitPanel.pushCount' => ({required Object count}) => '推送 ${count}',
			'common.gitPanel.pushTitle' => ({required Object count, required Object remote}) => '推送 ${count} 到 ${remote}',
			'common.gitPanel.pushing' => '正在推送…',
			'common.gitPanel.recentCommits' => '最近提交',
			'common.gitPanel.refresh' => '刷新 git 状态',
			'common.gitPanel.remove' => '移除',
			'common.gitPanel.removeWorktree.alsoDelete' => '同时删除分支',
			'common.gitPanel.removeWorktree.description' => ({required Object branch}) => '移除 ${branch} 的 worktree？其文件夹将被删除，关联的项目将被归档 — 聊天会话仍可恢复。',
			'common.gitPanel.removeWorktree.dirtyWarning' => ({required Object count}) => '此 worktree 有 ${count} 个未提交的更改将会丢失。',
			'common.gitPanel.removeWorktree.discardChanges' => '放弃未提交的更改',
			'common.gitPanel.removeWorktree.title' => '移除 Worktree',
			'common.gitPanel.removing' => '正在移除...',
			'common.gitPanel.revertLatest' => '还原最新本地提交',
			'common.gitPanel.scroll' => '滚动',
			'common.gitPanel.searchBranches' => '搜索分支...',
			'common.gitPanel.selectAll' => '全选',
			'common.gitPanel.selectProject' => '选择项目以查看源代码管理',
			'common.gitPanel.selectedOf' => ({required Object total, required Object selected}) => '已选择 ${total} 个文件中的 ${selected} 个',
			'common.gitPanel.selectedOfMobile' => ({required Object total, required Object selected}) => '已选择 ${total} 中的 ${selected} 个',
			'common.gitPanel.sideBySide' => '并排',
			'common.gitPanel.stageAll' => '全部暂存',
			'common.gitPanel.stageHunk' => '暂存此区块',
			'common.gitPanel.staged' => ({required Object count}) => '已暂存（${count}）',
			'common.gitPanel.status.added' => '已添加',
			'common.gitPanel.status.deleted' => '已删除',
			'common.gitPanel.status.modified' => '已修改',
			'common.gitPanel.status.untracked' => '未跟踪',
			'common.gitPanel.statusGuide' => '文件状态指南',
			'common.gitPanel.switchScroll' => '切换到水平滚动',
			'common.gitPanel.switchSplit' => '切换到并排视图',
			'common.gitPanel.switchUnified' => '切换到统一视图',
			'common.gitPanel.switchWrap' => '切换到文本换行',
			'common.gitPanel.unified' => '统一',
			'common.gitPanel.unstageAll' => '全部取消暂存',
			'common.gitPanel.unstageHunk' => '取消暂存此区块',
			'common.gitPanel.upToDate' => '已是最新',
			'common.gitPanel.upToDateWith' => ({required Object remote}) => '与 ${remote} 同步',
			'common.gitPanel.viewAll' => '查看全部',
			'common.gitPanel.viewsAria' => '源代码管理视图',
			'common.gitPanel.worktrees.changes' => ({required Object count}) => '${count} 个更改',
			'common.gitPanel.worktrees.count' => ({required Object count}) => '${count} 个 worktree',
			'common.gitPanel.worktrees.createFirst' => '创建你的第一个 worktree',
			'common.gitPanel.worktrees.detached' => '分离',
			'common.gitPanel.worktrees.detachedAt' => ({required Object sha}) => '分离 @ ${sha}',
			'common.gitPanel.worktrees.detachedHead' => '分离的 HEAD',
			'common.gitPanel.worktrees.emptyDesc' => 'worktree 将分支检出到独立文件夹，因此你可以并行运行独立的聊天会话，并在就绪后合并结果。',
			'common.gitPanel.worktrees.emptyTitle' => '并行处理多个分支',
			'common.gitPanel.worktrees.locked' => '已锁定',
			'common.gitPanel.worktrees.mainWorktree' => '主 worktree',
			'common.gitPanel.worktrees.mergeTitle' => ({required Object branch}) => '将 ${branch} 合并到基础分支',
			'common.gitPanel.worktrees.kNew' => '新建 worktree',
			'common.gitPanel.worktrees.none' => '没有 worktree',
			'common.gitPanel.worktrees.nothingToMerge' => '无可合并内容 — 没有领先于基础分支的提交',
			'common.gitPanel.worktrees.open' => '打开',
			'common.gitPanel.worktrees.refresh' => '刷新 worktree',
			'common.gitPanel.worktrees.removeTitle' => ({required Object branch}) => '移除 ${branch} 的 worktree',
			'common.gitPanel.worktrees.switchTo' => ({required Object branch}) => '切换到 ${branch}',
			'common.gitPanel.wrap' => '换行',
			'common.gitPanel.tabs.changes' => '更改',
			'common.gitPanel.tabs.history' => '提交',
			'common.gitPanel.tabs.branches' => '分支',
			'common.gitPanel.tabs.worktrees' => '工作树',
			'common.sessions.renameSession' => '重命名会话',
			'common.projects.newSession' => '新会话',
			'common.codeBlock.wrapLines' => '自动换行',
			'common.codeBlock.noWrap' => '不换行',
			'common.update.available' => ({required Object version}) => '有可用更新 · v${version}',
			'common.update.confirm' => ({required Object version}) => '更新到 v${version}？服务器会自行更新并重启 — 进行中的会话将被中断。',
			'common.update.downloading' => '正在下载并应用更新…',
			'common.update.restarting' => '正在重启服务器 — 请稍候…',
			'common.update.done' => ({required Object version}) => '已更新到 v${version}。重新加载应用以载入新的应用包。',
			'common.update.manualRestart' => '更新已应用，但服务器未自动重启 — 请手动重启以完成。',
			'common.update.failed' => '更新失败。',
			'common.update.failedTitle' => '更新失败',
			'common.update.appConfirm' => ({required Object version}) => '要在此设备上安装 ddagent v${version} 吗？首次安装时 Android 会请求允许从 ddagent 安装应用。',
			'common.update.appPermission' => '请为 ddagent 允许“安装未知应用”，然后再次点击更新。',
			'settings.title' => '设置',
			'settings.changelog.title' => '更新日志',
			'settings.changelog.loading' => '加载中…',
			'settings.changelog.empty' => '没有可显示的版本',
			'settings.changelog.current' => '当前',
			'settings.changelog.kNew' => '新',
			'settings.server.title' => '服务器',
			'settings.server.description' => '重启 ddagent 进程 — 适用于应用更新或从卡顿状态恢复。',
			'settings.server.restart' => '重启',
			'settings.server.restartConfirm' => '确定重启 ddagent 服务器?活动会话将被中断。',
			'settings.server.restarting' => '正在重启… 服务器恢复后页面将自动刷新。',
			'settings.server.restartFailed' => '重启失败',
			'settings.server.unsupported' => '仅当服务器在服务管理器下运行时才可重启。',
			'settings.server.ok' => '确定',
			'settings.updates.title' => '应用更新',
			'settings.updates.description' => '在 GitHub 上检查更新的桌面版本。新版本会自动下载并在退出时安装。',
			'settings.updates.check' => '检查更新',
			'settings.updates.checking' => '正在检查…',
			'settings.updates.upToDate' => ({required Object version}) => '已是最新版本（v${version}）。',
			'settings.updates.available' => ({required Object version}) => '发现更新 v${version} — 正在后台下载；退出 ddagent 时自动安装。',
			'settings.updates.downloaded' => ({required Object version}) => '更新 v${version} 已下载 — 退出并重新启动 ddagent 即可安装。',
			'settings.updates.unavailable' => '更新检查仅在打包的桌面版本中可用。',
			'settings.updates.error' => ({required Object message}) => '更新检查失败：${message}',
			'settings.updates.errorGeneric' => '更新检查失败。',
			'settings.tabs.account' => '账户',
			'settings.tabs.permissions' => '权限',
			'settings.tabs.mcpServers' => 'MCP 服务器',
			'settings.tabs.skills' => '技能',
			'settings.tabs.appearance' => '外观',
			'settings.account.title' => '账户',
			'settings.account.language' => '语言',
			'settings.account.languageLabel' => '显示语言',
			'settings.account.languageDescription' => '选择您偏好的界面语言',
			'settings.account.username' => '用户名',
			'settings.account.email' => '邮箱',
			'settings.account.profile' => '个人资料',
			'settings.account.changePassword' => '修改密码',
			'settings.mcp.title' => 'MCP 服务器',
			'settings.mcp.addServer' => '添加服务器',
			'settings.mcp.editServer' => '编辑服务器',
			'settings.mcp.deleteServer' => '删除服务器',
			'settings.mcp.serverName' => '服务器名称',
			'settings.mcp.serverType' => '服务器类型',
			'settings.mcp.config' => '配置',
			'settings.mcp.testConnection' => '测试连接',
			'settings.mcp.status' => '状态',
			'settings.mcp.connected' => '已连接',
			'settings.mcp.disconnected' => '未连接',
			'settings.mcp.scope.label' => '范围',
			'settings.mcp.scope.user' => '用户',
			'settings.mcp.scope.project' => '项目',
			'settings.appearance.title' => '外观',
			'settings.appearance.theme' => '主题',
			'settings.appearance.codeEditor' => '代码编辑器',
			'settings.appearance.editorTheme' => '编辑器主题',
			'settings.appearance.wordWrap' => '自动换行',
			'settings.appearance.showMinimap' => '显示缩略图',
			'settings.appearance.lineNumbers' => '行号',
			'settings.appearance.fontSize' => '字体大小',
			'settings.appearance.themeModes.dark' => '深色',
			'settings.appearance.themeModes.light' => '浅色',
			'settings.appearance.themeModes.system' => '跟随系统',
			'settings.actions.saveChanges' => '保存更改',
			'settings.actions.resetToDefaults' => '重置为默认值',
			'settings.actions.cancelChanges' => '取消更改',
			'settings.quickSettings.title' => '快速设置',
			'settings.quickSettings.sections.appearance' => '外观',
			'settings.quickSettings.sections.toolDisplay' => '工具显示',
			'settings.quickSettings.sections.inputSettings' => '输入设置',
			'settings.quickSettings.darkMode' => '深色模式',
			'settings.quickSettings.showRawParameters' => '显示原始参数',
			'settings.quickSettings.showThinking' => '显示思考过程',
			'settings.quickSettings.sendByCtrlEnter' => '使用 Ctrl+Enter 发送',
			'settings.quickSettings.sendByCtrlEnterDescription' => '启用后，按 Ctrl+Enter 发送消息，而不是仅按 Enter。这对于使用输入法的用户可以避免意外发送。',
			'settings.quickSettings.dragHandle.dragging' => '正在拖拽手柄',
			'settings.quickSettings.dragHandle.closePanel' => '关闭设置面板',
			'settings.quickSettings.dragHandle.openPanel' => '打开设置面板',
			'settings.quickSettings.dragHandle.draggingStatus' => '正在拖拽...',
			'settings.quickSettings.dragHandle.toggleAndMove' => '点击切换，拖拽移动',
			'settings.quickSettings.sendWithCtrlEnter' => '使用 Ctrl+Enter 发送',
			'settings.terminalShortcuts.title' => '终端快捷键',
			'settings.terminalShortcuts.sectionKeys' => '按键',
			'settings.terminalShortcuts.sectionNavigation' => '导航',
			'settings.terminalShortcuts.escape' => 'Escape',
			'settings.terminalShortcuts.tab' => 'Tab',
			'settings.terminalShortcuts.shiftTab' => 'Shift+Tab',
			'settings.terminalShortcuts.arrowUp' => '上箭头',
			'settings.terminalShortcuts.arrowDown' => '下箭头',
			'settings.terminalShortcuts.scrollDown' => '滚动到底部',
			'settings.terminalShortcuts.handle.closePanel' => '关闭快捷键面板',
			'settings.terminalShortcuts.handle.openPanel' => '打开快捷键面板',
			'settings.terminalShortcuts.killTitle' => '终止正在运行的进程 (Ctrl+C)',
			'settings.terminalShortcuts.paste' => '粘贴',
			'settings.mainTabs.label' => '设置',
			'settings.mainTabs.agents' => '智能体',
			'settings.mainTabs.orchestration' => '编排',
			'settings.mainTabs.appearance' => '外观',
			'settings.mainTabs.git' => 'Git',
			'settings.mainTabs.apiTokens' => 'API 和令牌',
			'settings.mainTabs.models' => '模型',
			'settings.mainTabs.tasks' => '任务',
			'settings.mainTabs.browser' => '浏览器',
			'settings.mainTabs.tools' => '工具',
			'settings.mainTabs.notifications' => '通知',
			'settings.mainTabs.about' => '关于',
			'settings.mainTabs.workspaces' => '工作区',
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
			'settings.orchestration.pool.fields.redundantAccounts' => '冗余账户',
			'settings.orchestration.pool.fields.redundantAccountsNone' => '此提供商没有其他账户',
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
			'settings.notifications.title' => '通知',
			'settings.notifications.description' => '控制你希望接收的通知事件。',
			'settings.notifications.webPush.title' => '通知此浏览器',
			'settings.notifications.webPush.enable' => '启用通知',
			'settings.notifications.webPush.disable' => '关闭通知',
			'settings.notifications.webPush.enabled' => '此浏览器已启用通知',
			'settings.notifications.webPush.loading' => '更新中...',
			'settings.notifications.webPush.unsupported' => '此浏览器不支持推送通知。',
			'settings.notifications.webPush.denied' => '推送通知已被阻止，请在浏览器设置中允许。',
			'settings.notifications.webPush.iosHint' => '在 iPhone/iPad 上，只有将 ddagent 添加到主屏幕（分享 → 添加到主屏幕）并在安装的应用中启用通知后，通知才有效。',
			'settings.notifications.webPush.test' => '发送测试通知',
			'settings.notifications.webPush.testNoSubscription' => '没有已订阅的设备。请先在手机上点击“启用”。',
			'settings.notifications.webPush.testSuccess' => ({required Object count}) => '已发送到 ${count} 台设备。如果手机上没有显示，请将 ddagent 添加到主屏幕（iOS 要求）。',
			'settings.notifications.webPush.testNotDelivered' => '没有可访问的设备。请确保应用正在运行且通知已启用。',
			'settings.notifications.device.title' => '通知此设备',
			'settings.notifications.device.enabled' => '此设备的通知已启用',
			'settings.notifications.desktop.title' => '通知此桌面应用',
			'settings.notifications.desktop.enable' => '启用通知',
			'settings.notifications.desktop.disable' => '关闭通知',
			'settings.notifications.desktop.enabled' => '此桌面应用已启用通知',
			'settings.notifications.desktop.unsupported' => '此系统不支持桌面通知。',
			'settings.notifications.sound.title' => '声音',
			'settings.notifications.sound.description' => '聊天运行完成时播放短提示音。',
			'settings.notifications.sound.enabled' => '已启用',
			'settings.notifications.sound.test' => '测试声音',
			'settings.notifications.events.title' => '事件类型',
			'settings.notifications.events.actionRequired' => '需要处理',
			'settings.notifications.events.stop' => '运行已停止',
			'settings.notifications.events.error' => '运行失败',
			'settings.notifications.channels.discord' => 'Discord',
			'settings.notifications.channels.telegram' => 'Telegram',
			'settings.notifications.unpair' => '取消配对',
			'settings.appearanceSettings.darkMode.label' => '深色模式',
			'settings.appearanceSettings.darkMode.description' => '切换浅色和深色主题',
			'settings.appearanceSettings.codeEditor.title' => '代码编辑器',
			'settings.appearanceSettings.codeEditor.theme.label' => '编辑器主题',
			'settings.appearanceSettings.codeEditor.theme.description' => '代码编辑器的默认主题',
			'settings.appearanceSettings.codeEditor.wordWrap.label' => '自动换行',
			'settings.appearanceSettings.codeEditor.wordWrap.description' => '在编辑器中默认启用自动换行',
			'settings.appearanceSettings.codeEditor.showMinimap.label' => '显示缩略图',
			'settings.appearanceSettings.codeEditor.showMinimap.description' => '在差异视图中显示缩略图以便于导航',
			'settings.appearanceSettings.codeEditor.lineNumbers.label' => '显示行号',
			'settings.appearanceSettings.codeEditor.lineNumbers.description' => '在编辑器中显示行号',
			'settings.appearanceSettings.codeEditor.fontSize.label' => '字体大小',
			'settings.appearanceSettings.codeEditor.fontSize.description' => '编辑器字体大小（px）',
			'settings.appearanceSettings.terminal.title' => '终端',
			'settings.appearanceSettings.terminal.focusFollowsPointer.label' => '焦点跟随指针',
			'settings.appearanceSettings.terminal.focusFollowsPointer.description' => '将鼠标移到终端上时聚焦终端以便输入',
			'settings.mcpForm.title.add' => '添加 MCP 服务器',
			'settings.mcpForm.title.edit' => '编辑 MCP 服务器',
			'settings.mcpForm.importMode.form' => '表单输入',
			'settings.mcpForm.importMode.json' => 'JSON 导入',
			'settings.mcpForm.scope.label' => '范围',
			'settings.mcpForm.scope.userGlobal' => '用户（全局）',
			'settings.mcpForm.scope.projectLocal' => '项目（本地）',
			'settings.mcpForm.scope.userDescription' => '用户范围：在您机器上的所有项目中可用',
			'settings.mcpForm.scope.projectDescription' => '本地范围：仅在选定项目中可用',
			'settings.mcpForm.scope.cannotChange' => '编辑现有服务器时无法更改范围',
			'settings.mcpForm.fields.serverName' => '服务器名称',
			'settings.mcpForm.fields.transportType' => '传输类型',
			'settings.mcpForm.fields.command' => '命令',
			'settings.mcpForm.fields.arguments' => '参数（每行一个）',
			'settings.mcpForm.fields.jsonConfig' => 'JSON 配置',
			'settings.mcpForm.fields.url' => 'URL',
			'settings.mcpForm.fields.envVars' => '环境变量（KEY=值，每行一个）',
			'settings.mcpForm.fields.headers' => '请求头（KEY=值，每行一个）',
			'settings.mcpForm.fields.selectProject' => '选择项目...',
			'settings.mcpForm.placeholders.serverName' => '我的服务',
			'settings.mcpForm.validation.missingType' => '缺少必填字段：type',
			'settings.mcpForm.validation.stdioRequiresCommand' => 'stdio 类型需要 command 字段',
			'settings.mcpForm.validation.httpRequiresUrl' => ({required Object type}) => '${type} 类型需要 url 字段',
			'settings.mcpForm.validation.invalidJson' => '无效的 JSON 格式',
			'settings.mcpForm.validation.jsonHelp' => '粘贴您的 MCP 服务器配置（JSON 格式）。示例格式：',
			'settings.mcpForm.validation.jsonExampleStdio' => '• stdio: {"type":"stdio","command":"npx","args":["@upstash/context7-mcp"]}',
			'settings.mcpForm.validation.jsonExampleHttp' => '• http/sse: {"type":"http","url":"https://api.example.com/mcp"}',
			'settings.mcpForm.configDetails' => ({required Object configFile}) => '配置详细信息（来自 ${configFile}）',
			'settings.mcpForm.projectPath' => ({required Object path}) => '路径：${path}',
			'settings.mcpForm.actions.cancel' => '取消',
			'settings.mcpForm.actions.saving' => '保存中...',
			'settings.mcpForm.actions.addServer' => '添加服务器',
			'settings.mcpForm.actions.updateServer' => '更新服务器',
			'settings.saveStatus.success' => '设置保存成功！',
			'settings.saveStatus.error' => '保存设置失败',
			'settings.saveStatus.saving' => '保存中...',
			'settings.footerActions.save' => '保存设置',
			'settings.footerActions.cancel' => '取消',
			'settings.git.title' => 'Git 配置',
			'settings.git.description' => '配置您的 git 提交身份。这些设置将通过 git config --global 全局应用',
			'settings.git.name.label' => 'Git 名称',
			'settings.git.name.help' => '您的 git 提交名称',
			'settings.git.name.placeholder' => 'John Doe',
			'settings.git.email.label' => 'Git 邮箱',
			'settings.git.email.help' => '您的 git 提交邮箱',
			'settings.git.email.placeholder' => 'john@example.com',
			'settings.git.actions.save' => '保存配置',
			'settings.git.actions.saving' => '保存中...',
			'settings.git.status.success' => '保存成功',
			'settings.git.status.error' => '保存失败',
			'settings.apiKeys.title' => 'API 密钥',
			'settings.apiKeys.description' => '生成 API 密钥以从其他应用访问外部 API。',
			'settings.apiKeys.newKey.alertTitle' => '⚠️ 保存您的 API 密钥',
			'settings.apiKeys.newKey.alertMessage' => '这是您唯一一次看到此密钥。请妥善保存。',
			'settings.apiKeys.newKey.iveSavedIt' => '我已保存',
			'settings.apiKeys.form.placeholder' => 'API 密钥名称（例如：生产服务器）',
			'settings.apiKeys.form.createButton' => '创建',
			'settings.apiKeys.form.cancelButton' => '取消',
			'settings.apiKeys.newButton' => '新建 API 密钥',
			'settings.apiKeys.empty' => '尚未创建 API 密钥。',
			'settings.apiKeys.list.created' => '创建时间：',
			'settings.apiKeys.list.lastUsed' => '最后使用：',
			'settings.apiKeys.confirmDelete' => '确定要删除此 API 密钥吗？',
			'settings.apiKeys.status.active' => '激活',
			'settings.apiKeys.status.inactive' => '未激活',
			'settings.apiKeys.github.title' => 'GitHub 令牌',
			'settings.apiKeys.github.description' => '添加 GitHub 个人访问令牌以通过外部 API 克隆私有仓库。',
			'settings.apiKeys.github.descriptionAlt' => '添加 GitHub 个人访问令牌以克隆私有仓库。您也可以直接在 API 请求中传递令牌而无需存储。',
			'settings.apiKeys.github.addButton' => '添加令牌',
			'settings.apiKeys.github.form.namePlaceholder' => '令牌名称（例如：个人仓库）',
			'settings.apiKeys.github.form.tokenPlaceholder' => 'GitHub 个人访问令牌（ghp_...）',
			'settings.apiKeys.github.form.descriptionPlaceholder' => '描述（可选）',
			'settings.apiKeys.github.form.addButton' => '添加令牌',
			'settings.apiKeys.github.form.cancelButton' => '取消',
			'settings.apiKeys.github.form.howToCreate' => '如何创建 GitHub 个人访问令牌 →',
			'settings.apiKeys.github.form.showToken' => '显示令牌',
			'settings.apiKeys.github.form.hideToken' => '隐藏令牌',
			'settings.apiKeys.github.empty' => '尚未添加 GitHub 令牌。',
			'settings.apiKeys.github.added' => '添加时间：',
			'settings.apiKeys.github.confirmDelete' => '确定要删除此 GitHub 令牌吗？',
			'settings.apiKeys.apiDocsLink' => 'API 文档',
			'settings.apiKeys.documentation.title' => '外部 API 文档',
			'settings.apiKeys.documentation.description' => '了解如何使用外部 API 从您的应用程序触发 Claude/Cursor 会话。',
			'settings.apiKeys.documentation.viewLink' => '查看 API 文档 →',
			'settings.apiKeys.loading' => '加载中...',
			'settings.apiKeys.version.updateAvailable' => ({required Object version}) => '有可用更新：v${version}',
			'settings.tasks.checking' => '正在检查 TaskMaster 安装...',
			'settings.tasks.notInstalled.title' => '未安装 TaskMaster AI CLI',
			'settings.tasks.notInstalled.description' => '需要 TaskMaster CLI 才能使用任务管理功能。安装它以开始使用：',
			'settings.tasks.notInstalled.installCommand' => 'npm install -g task-master-ai',
			'settings.tasks.notInstalled.viewOnGitHub' => '在 GitHub 上查看',
			'settings.tasks.notInstalled.afterInstallation' => '安装后：',
			'settings.tasks.notInstalled.steps.restart' => '重启此应用程序',
			'settings.tasks.notInstalled.steps.autoAvailable' => 'TaskMaster 功能将自动可用',
			'settings.tasks.notInstalled.steps.initCommand' => '在项目目录中使用 task-master init',
			'settings.tasks.settings.enableLabel' => '启用 TaskMaster 集成',
			'settings.tasks.settings.enableDescription' => '在整个界面中显示 TaskMaster 任务、横幅和侧边栏指示器',
			'settings.agents.authStatus.checking' => '检查中...',
			'settings.agents.authStatus.connected' => '已连接',
			'settings.agents.authStatus.notConnected' => '未连接',
			'settings.agents.authStatus.disconnected' => '已断开',
			'settings.agents.authStatus.checkingAuth' => '正在检查认证状态...',
			'settings.agents.authStatus.loggedInAs' => ({required Object email}) => '登录为 ${email}',
			'settings.agents.authStatus.providerAccount' => ({required Object provider}) => '${provider} 账户',
			'settings.agents.authStatus.authenticatedUser' => '已认证用户',
			'settings.agents.install.title' => ({required Object agent}) => '未安装 ${agent} CLI',
			'settings.agents.install.description' => ({required Object agent}) => '安装 ${agent} CLI 以登录并运行会话。',
			'settings.agents.install.button' => '安装',
			'settings.agents.install.installing' => '安装中…',
			'settings.agents.install.copyCommand' => '复制命令',
			'settings.agents.install.docs' => '文档',
			'settings.agents.install.success' => ({required Object agent}) => '${agent} CLI 已安装',
			'settings.agents.install.failed' => '安装失败 — 请检查终端输出',
			'settings.agents.account.claude.description' => 'Anthropic Claude AI 助手',
			'settings.agents.account.cursor.description' => 'Cursor AI 驱动的代码编辑器',
			'settings.agents.account.codex.description' => 'OpenAI Codex AI 助手',
			'settings.agents.account.opencode.description' => 'OpenCode CLI 助手',
			'settings.agents.account.commandcode.description' => 'Command Code CLI 助手',
			'settings.agents.account.antigravity.description' => 'Antigravity CLI 助手',
			'settings.agents.account.devin.description' => 'Devin CLI 助手',
			'settings.agents.connectionStatus' => '连接状态',
			'settings.agents.login.title' => '登录',
			'settings.agents.login.reAuthenticate' => '重新认证',
			'settings.agents.login.description' => ({required Object agent}) => '登录您的 ${agent} 账户以启用 AI 功能',
			'settings.agents.login.reAuthDescription' => '使用其他账户登录或刷新凭据',
			'settings.agents.login.button' => '登录',
			'settings.agents.login.reLoginButton' => '重新登录',
			'settings.agents.error' => ({required Object error}) => '错误：${error}',
			'settings.permissions.title' => '权限设置',
			'settings.permissions.skipPermissions.label' => '跳过权限提示（请谨慎使用）',
			'settings.permissions.skipPermissions.claudeDescription' => '等同于 --dangerously-skip-permissions 标志',
			'settings.permissions.skipPermissions.cursorDescription' => '等同于 Cursor CLI 中的 -f 标志',
			'settings.permissions.allowedTools.title' => '允许的工具',
			'settings.permissions.allowedTools.description' => '无需权限提示即可自动使用的工具',
			'settings.permissions.allowedTools.placeholder' => '例如："Bash(git log:*)" 或 "Write"',
			'settings.permissions.allowedTools.quickAdd' => '快速添加常用工具：',
			'settings.permissions.allowedTools.empty' => '未配置允许的工具',
			'settings.permissions.blockedTools.title' => '禁用的工具',
			'settings.permissions.blockedTools.description' => '无需权限提示即可自动禁用的工具',
			'settings.permissions.blockedTools.placeholder' => '例如："Bash(rm:*)"',
			'settings.permissions.blockedTools.empty' => '未配置禁用的工具',
			'settings.permissions.allowedCommands.title' => '允许的 Shell 命令',
			'settings.permissions.allowedCommands.description' => '无需权限提示即可自动执行的 Shell 命令',
			'settings.permissions.allowedCommands.placeholder' => '例如："Shell(ls)" 或 "Shell(git status)"',
			'settings.permissions.allowedCommands.quickAdd' => '快速添加常用命令：',
			'settings.permissions.allowedCommands.empty' => '未配置允许的命令',
			'settings.permissions.blockedCommands.title' => '阻止的 Shell 命令',
			'settings.permissions.blockedCommands.description' => '自动阻止的 Shell 命令',
			'settings.permissions.blockedCommands.placeholder' => '例如："Shell(rm -rf)" 或 "Shell(sudo)"',
			'settings.permissions.blockedCommands.empty' => '未配置阻止的命令',
			'settings.permissions.toolExamples.title' => '工具模式示例：',
			'settings.permissions.toolExamples.bashGitLog' => '- 允许所有 git log 命令',
			_ => null,
		} ?? switch (path) {
			'settings.permissions.toolExamples.bashGitDiff' => '- 允许所有 git diff 命令',
			'settings.permissions.toolExamples.write' => '- 允许所有 Write 工具使用',
			'settings.permissions.toolExamples.bashRm' => '- 阻止所有 rm 命令（危险）',
			'settings.permissions.shellExamples.title' => 'Shell 命令示例：',
			'settings.permissions.shellExamples.ls' => '- 允许 ls 命令',
			'settings.permissions.shellExamples.gitStatus' => '- 允许 git status',
			'settings.permissions.shellExamples.npmInstall' => '- 允许 npm install',
			'settings.permissions.shellExamples.rmRf' => '- 阻止递归删除',
			'settings.permissions.codex.permissionMode' => '权限模式',
			'settings.permissions.codex.description' => '控制 Codex 如何处理文件修改和命令执行',
			'settings.permissions.codex.modes.kDefault.title' => '默认',
			'settings.permissions.codex.modes.kDefault.description' => '只有受信任的命令（ls、cat、grep、git status 等）会自动运行。其他命令将被跳过。可以写入工作区。',
			'settings.permissions.codex.modes.acceptEdits.title' => '接受编辑',
			'settings.permissions.codex.modes.acceptEdits.description' => '所有命令在工作区内自动运行。具有沙箱执行的全自动模式。',
			'settings.permissions.codex.modes.bypassPermissions.title' => '绕过权限',
			'settings.permissions.codex.modes.bypassPermissions.description' => '完全系统访问，无任何限制。所有命令自动运行，具有完整的磁盘和网络访问权限。请谨慎使用。',
			'settings.permissions.codex.technicalDetails' => '技术详情',
			'settings.permissions.codex.technicalInfo.kDefault' => 'sandboxMode=workspace-write, approvalPolicy=untrusted。受信任的命令：cat、cd、grep、head、ls、pwd、tail、git status/log/diff/show、find（不带 -exec）等。',
			'settings.permissions.codex.technicalInfo.acceptEdits' => 'sandboxMode=workspace-write, approvalPolicy=never。所有命令在项目目录内自动执行。',
			'settings.permissions.codex.technicalInfo.bypassPermissions' => 'sandboxMode=danger-full-access, approvalPolicy=never。完全系统访问权限，仅在可信环境中使用。',
			'settings.permissions.codex.technicalInfo.overrideNote' => '您可以使用聊天界面中的模式按钮按会话覆盖此设置。',
			'settings.permissions.actions.add' => '添加',
			'settings.permissions.permissionMode.title' => '权限模式',
			'settings.permissions.permissionMode.description' => ({required Object provider}) => '新 ${provider} 会话的默认权限模式。你仍可为单个会话覆盖。',
			'settings.permissions.permissionMode.modes.kDefault.title' => '默认',
			'settings.permissions.permissionMode.modes.kDefault.description' => '需要权限的操作会在聊天中显示供你批准。',
			'settings.permissions.permissionMode.modes.acceptEdits.title' => '接受编辑',
			'settings.permissions.permissionMode.modes.acceptEdits.description' => '文件编辑自动批准；其他操作仍会请求你的批准。',
			'settings.permissions.permissionMode.modes.bypassPermissions.title' => '绕过权限',
			'settings.permissions.permissionMode.modes.bypassPermissions.description' => '每个操作都自动批准 — 无提示完全访问。请谨慎使用。',
			'settings.permissions.permissionMode.modes.plan.title' => '计划',
			'settings.permissions.permissionMode.modes.plan.description' => '计划模式：代理只探索和规划，不执行命令。',
			'settings.mcpServers.title' => 'MCP 服务器',
			'settings.mcpServers.description.claude' => 'Model Context Protocol 服务器为 Claude 提供额外的工具和数据源',
			'settings.mcpServers.description.cursor' => 'Model Context Protocol 服务器为 Cursor 提供额外的工具和数据源',
			'settings.mcpServers.description.codex' => 'Model Context Protocol 服务器为 Codex 提供额外的工具和数据源',
			'settings.mcpServers.description.opencode' => 'Model Context Protocol 服务器为 OpenCode 提供额外的工具和数据源',
			'settings.mcpServers.description.commandcode' => 'Model Context Protocol 服务器为 Command Code 提供额外的工具和数据源',
			'settings.mcpServers.description.antigravity' => 'Model Context Protocol 服务器为 Antigravity 提供额外的工具和数据源',
			'settings.mcpServers.description.devin' => 'Model Context Protocol 服务器为 Devin 提供额外的工具和数据源',
			'settings.mcpServers.addButton' => '添加 MCP 服务器',
			'settings.mcpServers.empty' => '未配置 MCP 服务器',
			'settings.mcpServers.serverType' => '类型',
			'settings.mcpServers.scope.local' => '本地',
			'settings.mcpServers.scope.user' => '用户',
			'settings.mcpServers.config.command' => '命令',
			'settings.mcpServers.config.url' => 'URL',
			'settings.mcpServers.config.args' => '参数',
			'settings.mcpServers.config.environment' => '环境变量',
			'settings.mcpServers.tools.title' => '工具',
			'settings.mcpServers.tools.count' => ({required Object count}) => '（${count}）：',
			'settings.mcpServers.tools.more' => ({required Object count}) => '还有 ${count} 个',
			'settings.mcpServers.actions.edit' => '编辑服务器',
			'settings.mcpServers.actions.delete' => '删除服务器',
			'settings.mcpServers.managed.badge' => '已托管',
			'settings.mcpServers.managed.hint' => '由 ddagent 管理。',
			'settings.mcpServers.help.title' => '关于 Codex MCP',
			'settings.mcpServers.help.description' => 'Codex 支持基于 stdio 的 MCP 服务器。您可以添加服务器，通过额外的工具和资源来扩展 Codex 的功能。',
			'settings.mcpServers.deleteConfirm.description' => ({required Object serverName}) => '“${serverName}”将从提供商配置中移除。',
			'settings.mcpServers.deleteConfirm.title' => '删除 MCP 服务器？',
			'settings.quota.settings.tab' => 'Control Center',
			'settings.quota.settings.title' => 'Control Center',
			'settings.quota.settings.description' => '提醒阈值、路由策略以及轮询额度的账户。',
			'settings.quota.settings.saved' => '已保存',
			'settings.quota.settings.alertsSection' => '提醒',
			'settings.quota.settings.alertsSectionHint' => '在额度真正耗尽之前警告，而不是等到 100%。',
			'settings.quota.settings.alertsEnabled' => '预测额度提醒',
			'settings.quota.settings.alertsEnabledHint' => '在概览和账户卡片上显示基于速度的预测。',
			'settings.quota.settings.watchThreshold' => '观察阈值（%）',
			'settings.quota.settings.watchThresholdHint' => '读数达到或超过此值的账户计为有风险。',
			'settings.quota.settings.dangerThreshold' => '危险阈值（%）',
			'settings.quota.settings.dangerThresholdHint' => '达到或超过此值的读数显示为红色。',
			'settings.quota.settings.routingSection' => '路由',
			'settings.quota.settings.routingSectionHint' => '面板如何将工作迁移到余量最多的账户。',
			'settings.quota.settings.routing.manual' => '手动',
			'settings.quota.settings.routing.manualHint' => '仅显示建议；绝不自动切换账户。',
			'settings.quota.settings.routing.ask' => '切换前询问',
			'settings.quota.settings.routing.askHint' => '提出切换建议并等待你的批准。',
			'settings.quota.settings.routing.autoLowRisk' => '低风险任务自动',
			'settings.quota.settings.routing.autoLowRiskHint' => '只有标记为低风险的任务才能自动迁移。',
			'settings.quota.settings.routingNote' => '切换账户会改变成本和模型质量，因此始终需要明确决定。',
			'settings.quota.settings.accountsSection' => '轮询的账户',
			'settings.quota.settings.accountsSectionHint' => '凭据从各工具读取；面板不会将其发送到其他地方。',
			'settings.quota.settings.sourcesSection' => '数据来源',
			'settings.quota.settings.sourcesSectionHint' => '用量和成本数据的来源。',
			'settings.quota.settings.logSources' => '令牌与成本日志存储',
			'settings.quota.settings.logSourcesHint' => '与 tokboard 收集器共享的只读聚合存储。',
			'settings.quota.settings.readOnly' => '只读',
			'settings.quota.settings.quotaConsent' => '额度轮询',
			'settings.quota.settings.quotaConsentHint' => '使用本地存储的凭据读取提供商额度端点。',
			'settings.quota.settings.localOnly' => '仅本地',
			'settings.quota.empty.description' => '尚未检测到任何账户。',
			'settings.quota.quality.cached' => '缓存',
			'settings.quota.quality.error' => '错误',
			'settings.quota.quality.estimate' => '估计',
			'settings.quota.quality.live' => '实时',
			'settings.quota.quality.unknown' => '未知',
			'settings.quota.syncFailed' => '同步失败',
			'settings.quota.syncNow' => '立即同步',
			'settings.browser.checking' => '正在检查...',
			'settings.browser.description' => '允许代理启动受管理的 Playwright 浏览器会话，你可以在 Browser 标签页中监控。',
			'settings.browser.enableDescription' => '为支持的代理注册 Browser。代理可以创建浏览器会话，你可以监控、停止和删除它们。',
			'settings.browser.enableLabel' => '启用 Browser',
			'settings.browser.errors.installRuntime' => '安装浏览器运行时失败',
			'settings.browser.errors.loadSettings' => '加载 Browser 设置失败',
			'settings.browser.errors.loadStatus' => '加载 Browser 状态失败',
			'settings.browser.errors.saveSettings' => '保存 Browser 设置失败',
			'settings.browser.installHint' => '在代理创建 Browser 会话之前，请安装浏览器运行时。',
			'settings.browser.installRuntime' => '安装运行时',
			'settings.browser.installed' => '已安装',
			'settings.browser.installing' => '正在安装...',
			'settings.browser.missing' => '缺失',
			'settings.browser.runtimeRequired' => '需要浏览器运行时',
			'settings.browser.statusDisabled' => '已禁用',
			'settings.browser.statusLabel' => '状态',
			'settings.browser.statusReady' => '就绪',
			'settings.browser.statusSetupRequired' => '需要设置',
			'settings.browser.title' => 'Browser',
			'settings.workspaces.cancel' => '取消',
			'settings.workspaces.create' => '添加工作区',
			'settings.workspaces.deleteConfirm' => '从 ddagent 移除此工作区？文件将保留在磁盘上。',
			'settings.workspaces.deleteFailed' => '移除工作区失败。',
			'settings.workspaces.deleteTitle' => '移除工作区',
			'settings.workspaces.description' => '工作区是 ddagent 可以聊天、运行代码和浏览的目录。',
			'settings.workspaces.remove' => '移除工作区',
			'settings.workspaces.title' => '工作区',
			'settings.workspaces.pathRequired' => '路径为必填项',
			'settings.about.supportTitle' => '支持本项目',
			'settings.about.buyMeACoffee' => '请我喝杯咖啡',
			'settings.about.learnMore' => '了解更多',
			'settings.about.pro.syncSettings' => '同步设置',
			'settings.about.pro.teamManagement' => '团队管理',
			'settings.about.proFeatures' => 'ddagent Pro 功能',
			'settings.about.tryHosted' => '试用 ddagent Hosted',
			'settings.about.versionInfo' => '版本信息',
			'settings.about.client' => '应用',
			'settings.about.server' => '服务器',
			'settings.about.platformMobile' => '移动端',
			'settings.about.platformDesktop' => '桌面端',
			'settings.about.platformWeb' => '网页',
			'settings.about.unknown' => '未知',
			'sidebar.projects.title' => '项目',
			'sidebar.projects.newProject' => '新建项目',
			'sidebar.projects.deleteProject' => '移除项目',
			'sidebar.projects.renameProject' => '重命名项目',
			'sidebar.projects.noProjects' => '未找到项目',
			'sidebar.projects.loadingProjects' => '加载项目中...',
			'sidebar.projects.searchPlaceholder' => '搜索项目...',
			'sidebar.projects.projectNamePlaceholder' => '项目名称',
			'sidebar.projects.starred' => '星标',
			'sidebar.projects.all' => '全部',
			'sidebar.projects.untitledSession' => '未命名会话',
			'sidebar.projects.newSession' => '新会话',
			'sidebar.projects.codexSession' => 'Codex 会话',
			'sidebar.projects.fetchingProjects' => '正在获取您的 Claude 项目和会话',
			'sidebar.projects.projects' => '项目',
			'sidebar.projects.noMatchingProjects' => '未找到匹配的项目',
			'sidebar.projects.tryDifferentSearch' => '尝试调整您的搜索词',
			'sidebar.projects.runClaudeCli' => '在项目目录中运行 Claude CLI 以开始使用',
			'sidebar.app.title' => 'ddagent',
			'sidebar.app.subtitle' => 'AI 编程助手',
			'sidebar.sessions.title' => '会话',
			'sidebar.sessions.newSession' => '新建会话',
			'sidebar.sessions.deleteSession' => '删除会话',
			'sidebar.sessions.renameSession' => '重命名会话',
			'sidebar.sessions.noSessions' => '暂无会话',
			'sidebar.sessions.loadingSessions' => '加载会话中...',
			'sidebar.sessions.unnamed' => '未命名',
			'sidebar.sessions.loading' => '加载中...',
			'sidebar.sessions.showMore' => '显示更多会话',
			'sidebar.sessions.selectMode' => '选择',
			'sidebar.sessions.selectAll' => '全选',
			'sidebar.sessions.archiveSelected' => ({required Object count}) => '归档（${count}）',
			'sidebar.sessions.deleteSelected' => ({required Object count}) => '删除（${count}）',
			'sidebar.sessions.cancelSelection' => '取消选择',
			'sidebar.sessions.toggleSelection' => '切换会话选择',
			'sidebar.sessions.selectionToolbar' => '会话选择操作',
			'sidebar.sessions.options' => '会话选项',
			'sidebar.sessions.pinSession' => '固定会话',
			'sidebar.sessions.unpinSession' => '取消固定会话',
			'sidebar.sessions.pinned' => '已固定的会话',
			'sidebar.sessions.selectedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '已选 ${count} 个', other: '已选 ${count} 个', ), 
			'sidebar.tooltips.viewEnvironments' => '查看环境',
			'sidebar.tooltips.hideSidebar' => '隐藏侧边栏',
			'sidebar.tooltips.createProject' => '创建新项目',
			'sidebar.tooltips.refresh' => '刷新项目和会话 (Ctrl+R)',
			'sidebar.tooltips.renameProject' => '重命名项目 (F2)',
			'sidebar.tooltips.deleteProject' => '从侧边栏移除项目 (Delete)',
			'sidebar.tooltips.addToFavorites' => '添加到收藏',
			'sidebar.tooltips.removeFromFavorites' => '从收藏移除',
			'sidebar.tooltips.editSessionName' => '手动编辑会话名称',
			'sidebar.tooltips.deleteSession' => '永久删除此会话',
			'sidebar.tooltips.activeSessionIndicator' => '最近活跃的会话（最近 10 分钟）',
			'sidebar.tooltips.save' => '保存',
			'sidebar.tooltips.cancel' => '取消',
			'sidebar.tooltips.clearSearch' => '清除搜索',
			'sidebar.tooltips.openCommandPalette' => '打开命令面板',
			'sidebar.tooltips.attentionRequiredIndicator' => '会话需要处理',
			'sidebar.tooltips.openSessions' => '浏览会话',
			'sidebar.navigation.chat' => '聊天',
			'sidebar.navigation.files' => '文件',
			'sidebar.navigation.git' => 'Git',
			'sidebar.navigation.terminal' => '终端',
			'sidebar.navigation.tasks' => '任务',
			'sidebar.actions.refresh' => '刷新',
			'sidebar.actions.settings' => '设置',
			'sidebar.actions.collapseAll' => '全部折叠',
			'sidebar.actions.expandAll' => '全部展开',
			'sidebar.actions.cancel' => '取消',
			'sidebar.actions.save' => '保存',
			'sidebar.actions.delete' => '删除',
			'sidebar.actions.rename' => '重命名',
			'sidebar.actions.joinCommunity' => '加入社区',
			'sidebar.actions.reportIssue' => '报告问题',
			'sidebar.actions.starOnGithub' => '在GitHub上加星',
			'sidebar.actions.buyMeACoffee' => '请我喝杯咖啡',
			'sidebar.branding.openSource' => '开源',
			'sidebar.status.active' => '活动',
			'sidebar.status.inactive' => '非活动',
			'sidebar.status.thinking' => '思考中...',
			'sidebar.status.error' => '错误',
			'sidebar.status.aborted' => '已中止',
			'sidebar.status.unknown' => '未知',
			'sidebar.time.justNow' => '刚刚',
			'sidebar.time.oneMinuteAgo' => '1 分钟前',
			'sidebar.time.minutesAgo' => ({required Object count}) => '${count} 分钟前',
			'sidebar.time.oneHourAgo' => '1 小时前',
			'sidebar.time.hoursAgo' => ({required Object count}) => '${count} 小时前',
			'sidebar.time.oneDayAgo' => '1 天前',
			'sidebar.time.daysAgo' => ({required Object count}) => '${count} 天前',
			'sidebar.messages.deleteConfirm' => '确定要删除吗？',
			'sidebar.messages.renameSuccess' => '重命名成功',
			'sidebar.messages.deleteSuccess' => '删除成功',
			'sidebar.messages.errorOccurred' => '发生错误',
			'sidebar.messages.deleteSessionConfirm' => '确定要删除此会话吗？此操作无法撤销。',
			'sidebar.messages.deleteProjectConfirm' => '从侧边栏移除此项目？您的项目文件、记忆和会话数据不会被删除。',
			'sidebar.messages.enterProjectPath' => '请输入项目路径',
			'sidebar.messages.deleteSessionFailed' => '删除会话失败，请重试。',
			'sidebar.messages.deleteSessionError' => '删除会话时出错，请重试。',
			'sidebar.messages.renameSessionFailed' => '重命名会话失败，请重试。',
			'sidebar.messages.renameSessionError' => '重命名会话时出错，请重试。',
			'sidebar.messages.deleteProjectFailed' => '移除项目失败，请重试。',
			'sidebar.messages.deleteProjectError' => '移除项目时出错，请重试。',
			'sidebar.messages.createProjectFailed' => '创建项目失败，请重试。',
			'sidebar.messages.createProjectError' => '创建项目时出错，请重试。',
			'sidebar.messages.updateProjectError' => '更新项目时出错，请重试。',
			'sidebar.messages.refreshError' => '刷新失败，请重试。',
			'sidebar.messages.restoreProjectFailed' => '恢复项目失败，请重试。',
			'sidebar.messages.restoreProjectError' => '恢复项目时出错，请重试。',
			'sidebar.messages.restoreSessionFailed' => '恢复会话失败，请重试。',
			'sidebar.messages.restoreSessionError' => '恢复会话时出错，请重试。',
			'sidebar.messages.changeWorkspaceFailed' => '更改工作区失败。请重试。',
			'sidebar.messages.changeWorkspaceError' => '更改工作区时出错。请重试。',
			'sidebar.messages.bulkDeleteSessionsFailed' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '删除 ${count} 个会话失败。请重试。', other: '删除 ${count} 个会话失败。请重试。', ), 
			'sidebar.version.updateAvailable' => '有可用更新',
			'sidebar.version.restartRequired' => '已安装更新 — 请重启服务器以生效',
			'sidebar.version.updateNow' => '立即更新',
			'sidebar.version.updateConfirm' => ({required Object version}) => '将 ddagent 更新到 v${version}？将拉取最新代码并重新构建，随后服务器重启 — 进行中的会话会被中断。',
			'sidebar.version.updating' => '正在更新… 可能需要几分钟',
			'sidebar.version.restarting' => '更新已安装 — 正在重启…',
			'sidebar.version.updateFailed' => '更新失败',
			'sidebar.version.releaseNotes' => '发行说明',
			'sidebar.search.modeProjects' => '项目',
			'sidebar.search.modeConversations' => '对话',
			'sidebar.search.conversationsPlaceholder' => '搜索对话内容...',
			'sidebar.search.searching' => '搜索中...',
			'sidebar.search.sessionTitles' => '会话标题',
			'sidebar.search.conversationContents' => '对话内容',
			'sidebar.search.noResults' => '未找到结果',
			'sidebar.search.tryDifferentQuery' => '尝试不同的搜索词',
			'sidebar.search.modeRunning' => '运行中',
			'sidebar.search.archiveOnly' => '归档',
			'sidebar.search.runningTooltip' => '运行中的会话',
			'sidebar.search.archiveOnlyTooltip' => '仅归档',
			'sidebar.search.runningCount' => ({required Object count}) => '${count} 个活跃',
			'sidebar.search.viewMenu' => '视图',
			'sidebar.search.backToProjects' => '返回项目',
			'sidebar.search.archivedPlaceholder' => '搜索已归档会话...',
			'sidebar.search.runningPlaceholder' => '搜索运行中的会话...',
			'sidebar.search.matches' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 个匹配', other: '${count} 个匹配', ), 
			'sidebar.search.projectsScanned' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 个项目已扫描', other: '${count} 个项目已扫描', ), 
			'sidebar.deleteConfirmation.deleteProject' => '移除项目',
			'sidebar.deleteConfirmation.deleteSession' => '删除会话',
			'sidebar.deleteConfirmation.confirmDelete' => '您想如何处理',
			'sidebar.deleteConfirmation.removeFromSidebar' => '仅从侧边栏移除',
			'sidebar.deleteConfirmation.deleteAllData' => '永久删除所有数据',
			'sidebar.deleteConfirmation.allConversationsDeleted' => '项目将从侧边栏中移除。您的文件、记忆和会话数据将会保留。',
			'sidebar.deleteConfirmation.cannotUndo' => '您可以稍后重新添加此项目。',
			'sidebar.deleteConfirmation.bulkDeleteSessionsDescription' => '归档会将所选会话从活跃列表中隐藏，同时保留其历史记录。',
			'sidebar.deleteConfirmation.archiveSession' => '归档会话',
			'sidebar.deleteConfirmation.archiveSessionNotice' => '归档会将会话移出活跃列表，同时保留其历史记录。',
			'sidebar.deleteConfirmation.archivedSessionNotice' => '此会话已归档。你可以保持隐藏或永久删除。',
			'sidebar.deleteConfirmation.deleteSessionNotice' => '这将永久删除会话及其记录。此操作无法撤销。',
			'sidebar.deleteConfirmation.deleteSessionPermanently' => '永久删除',
			'sidebar.deleteConfirmation.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '此项目包含 ${count} 个对话。', other: '此项目包含 ${count} 个对话。', ), 
			'sidebar.deleteConfirmation.bulkDeleteSessionsTitle' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '管理所选会话', other: '管理 ${count} 个所选会话', ), 
			'sidebar.deleteConfirmation.archiveSelectedSessions' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '归档会话', other: '归档 ${count} 个会话', ), 
			'sidebar.zones.activeNow' => '当前活跃',
			'sidebar.zones.recent' => '最近使用',
			'sidebar.zones.today' => '今天',
			'sidebar.zones.yesterday' => '昨天',
			'sidebar.zones.thisWeek' => '本周',
			'sidebar.zones.showMore' => ({required Object count}) => '再显示 ${count} 个',
			'sidebar.zones.showLess' => '收起',
			'sidebar.panel.open' => '面板',
			'sidebar.panel.newChat' => '新聊天',
			'sidebar.panel.navigation' => '导航',
			'sidebar.panel.sessions' => '会话',
			'sidebar.workspace.title' => '更改会话工作区',
			'sidebar.workspace.description' => '代理将在此目录中执行后续回合。现有会话历史将被保留。',
			'sidebar.workspace.pathLabel' => '工作区路径',
			'sidebar.workspace.pathRequired' => '工作区路径为必填项。',
			'sidebar.workspace.submit' => '更改工作区',
			'sidebar.workspace.saving' => '正在更改…',
			'sidebar.workspace.changeAction' => '更改工作区',
			'sidebar.recent.title' => '最近对话',
			'sidebar.recent.emptyTitle' => '暂无对话',
			'sidebar.recent.emptyDescription' => '你最近更新的对话将显示在这里。',
			'sidebar.recent.loadFailed' => '无法加载最近对话',
			'sidebar.recent.loadMore' => '加载更早的对话',
			'sidebar.recent.loadingMore' => '加载中...',
			'sidebar.tabs.board' => '代理面板',
			'sidebar.tabs.files' => '文件',
			'sidebar.tabs.git' => '源代码管理',
			'sidebar.tabs.tasks' => '任务',
			'sidebar.tabs.usage' => '配额与用量',
			'tasks.notConfigured.title' => 'TaskMaster AI 尚未配置',
			'tasks.notConfigured.description' => 'TaskMaster 帮助将复杂的项目分解为可管理的任务，配合 AI 驱动的辅助功能',
			'tasks.notConfigured.whatIsTitle' => '🎯 什么是 TaskMaster？',
			'tasks.notConfigured.features.aiPowered' => 'AI 驱动的任务管理：将复杂项目分解为可管理的子任务',
			'tasks.notConfigured.features.prdTemplates' => 'PRD 模板：从产品需求文档生成任务',
			'tasks.notConfigured.features.dependencyTracking' => '依赖追踪：了解任务关系和执行顺序',
			'tasks.notConfigured.features.progressVisualization' => '进度可视化：看板和详细的任务分析',
			'tasks.notConfigured.features.cliIntegration' => 'CLI 集成：使用 taskmaster 命令进行高级工作流',
			'tasks.notConfigured.initializeButton' => '初始化 TaskMaster AI',
			'tasks.notConfigured.writePrdFirst' => '先编写 PRD',
			'tasks.gettingStarted.title' => '开始使用 TaskMaster',
			'tasks.gettingStarted.subtitle' => 'TaskMaster 已初始化！以下是接下来要做的事：',
			'tasks.gettingStarted.steps.createPRD.title' => '创建产品需求文档（PRD）',
			'tasks.gettingStarted.steps.createPRD.description' => '讨论您的项目构想并创建描述您想构建什么的 PRD。',
			'tasks.gettingStarted.steps.createPRD.addButton' => '添加 PRD',
			'tasks.gettingStarted.steps.createPRD.existingPRDs' => '现有的 PRD：',
			'tasks.gettingStarted.steps.generateTasks.title' => '从 PRD 生成任务',
			'tasks.gettingStarted.steps.generateTasks.description' => '一旦您有了 PRD，请 AI 助手解析它，TaskMaster 将自动将其分解为可管理的任务，包含实现细节。',
			'tasks.gettingStarted.steps.analyzeTasks.title' => '分析并展开任务',
			'tasks.gettingStarted.steps.analyzeTasks.description' => '请 AI 助手分析任务复杂度，并将其展开为详细的子任务以便于实现。',
			'tasks.gettingStarted.steps.startBuilding.title' => '开始构建',
			'tasks.gettingStarted.steps.startBuilding.description' => '请 AI 助手开始处理任务、更新状态，并在项目演进时添加新任务。',
			'tasks.gettingStarted.tip' => '💡 提示：从 PRD 开始可以充分利用 TaskMaster 的 AI 驱动任务生成功能',
			'tasks.setupModal.title' => 'TaskMaster 设置',
			'tasks.setupModal.subtitle' => ({required Object projectName}) => '${projectName} 的交互式 CLI',
			'tasks.setupModal.willStart' => 'TaskMaster 初始化将自动开始',
			'tasks.setupModal.completed' => 'TaskMaster 设置完成！您现在可以关闭此窗口。',
			'tasks.setupModal.closeButton' => '关闭',
			'tasks.setupModal.closeContinueButton' => '关闭并继续',
			'tasks.setupModal.closeTitle' => '关闭',
			'tasks.setupModal.description' => '这将在此项目中创建一个 .taskmaster 文件夹。无需外部工具或 API 密钥——任务保存在本地。',
			'tasks.setupModal.initializeButton' => '初始化',
			'tasks.setupModal.initializing' => '正在初始化...',
			'tasks.helpGuide.title' => '开始使用 TaskMaster',
			'tasks.helpGuide.subtitle' => '您的高效任务管理指南',
			'tasks.helpGuide.examples.parsePRD' => '💬 示例：\n「我刚用 Claude Task Master 初始化了一个新项目。我有一个 PRD 在 .taskmaster/docs/prd.txt。你能帮我解析它并设置初始任务吗？」',
			'tasks.helpGuide.examples.expandTask' => '💬 示例：\n「任务 5 看起来很复杂。你能把它分解成子任务吗？」',
			'tasks.helpGuide.examples.addTask' => '💬 示例：\n「请添加一个新任务来实现使用 Cloudinary 的用户个人头像上传功能，研究最佳方法。」',
			'tasks.helpGuide.moreExamples' => '查看更多示例和使用模式 →',
			'tasks.helpGuide.proTips.title' => '💡 专业提示',
			'tasks.helpGuide.proTips.search' => '使用搜索栏快速找到特定任务',
			'tasks.helpGuide.proTips.views' => '使用视图切换在看板、列表和网格视图之间切换',
			'tasks.helpGuide.proTips.filters' => '使用筛选器聚焦特定任务状态或优先级',
			'tasks.helpGuide.proTips.details' => '点击任何任务以查看详细信息和管理子任务',
			'tasks.helpGuide.learnMore.title' => '📚 了解更多',
			'tasks.helpGuide.learnMore.description' => 'TaskMaster AI 是为开发者打造的高级任务管理系统。获取文档、示例并为项目做出贡献。',
			'tasks.helpGuide.learnMore.githubButton' => '在 GitHub 上查看',
			'tasks.helpGuide.closeTitle' => '关闭',
			'tasks.search.placeholder' => '搜索任务...',
			'tasks.filters.button' => '筛选',
			'tasks.filters.status' => '状态',
			'tasks.filters.priority' => '优先级',
			'tasks.filters.sortBy' => '排序方式',
			'tasks.filters.allStatuses' => '所有状态',
			'tasks.filters.allPriorities' => '所有优先级',
			'tasks.filters.showing' => ({required Object filtered, required Object total}) => '显示 ${filtered} / ${total} 个任务',
			'tasks.filters.clearFilters' => '清除筛选',
			'tasks.sort.id' => 'ID',
			'tasks.sort.status' => '状态',
			'tasks.sort.priority' => '优先级',
			'tasks.sort.idAsc' => 'ID（递增）',
			'tasks.sort.idDesc' => 'ID（递减）',
			'tasks.sort.titleAsc' => '标题（A-Z）',
			'tasks.sort.titleDesc' => '标题（Z-A）',
			'tasks.sort.statusAsc' => '状态（待处理优先）',
			'tasks.sort.statusDesc' => '状态（已完成优先）',
			'tasks.sort.priorityAsc' => '优先级（高优先）',
			'tasks.sort.priorityDesc' => '优先级（低优先）',
			'tasks.views.kanban' => '看板视图',
			'tasks.views.list' => '列表视图',
			'tasks.views.grid' => '网格视图',
			'tasks.kanban.pending' => '📋 待办',
			'tasks.kanban.inProgress' => '🚀 进行中',
			'tasks.kanban.review' => '👀 审查',
			'tasks.kanban.done' => '✅ 已完成',
			'tasks.kanban.blocked' => '🚫 已阻止',
			'tasks.kanban.deferred' => '⏳ 已延后',
			'tasks.kanban.cancelled' => '❌ 已取消',
			'tasks.kanban.noTasksYet' => '暂无任务',
			'tasks.kanban.tasksWillAppear' => '任务将显示在这里',
			'tasks.kanban.moveTasksHere' => '开始后将任务移到这里',
			'tasks.kanban.completedTasksHere' => '已完成的任务显示在这里',
			'tasks.kanban.statusTasksHere' => '此状态的任务将显示在这里',
			'tasks.buttons.help' => 'TaskMaster 入门指南',
			'tasks.buttons.prds' => 'PRD',
			'tasks.buttons.addPRD' => '添加 PRD',
			'tasks.buttons.addTask' => '添加任务',
			'tasks.buttons.createNewPRD' => '创建新 PRD',
			'tasks.buttons.prdsAvailable' => ({required Object count}) => '${count} 个 PRD 可用',
			'tasks.prd.modified' => ({required Object date}) => '修改时间：${date}',
			'tasks.prd.editorTitle' => ({required Object name}) => 'PRD — ${name}',
			'tasks.prd.fileExistsMessage' => ({required Object name}) => '名为“${name}”的 PRD 已存在。要覆盖它吗？',
			'tasks.prd.fileExistsTitle' => '文件已存在',
			'tasks.prd.newFile' => '新文件',
			'tasks.prd.parse' => '解析 PRD',
			'tasks.prd.template' => '模板',
			'tasks.prd.fileNameHint' => '文件名（例如 prd.txt）',
			'tasks.prd.saved' => 'PRD 已保存',
			'tasks.prd.tasksGenerated' => '已从 PRD 生成任务',
			'tasks.statuses.pending' => '待处理',
			'tasks.statuses.inProgress' => '进行中',
			'tasks.statuses.done' => '已完成',
			'tasks.statuses.blocked' => '已阻止',
			'tasks.statuses.deferred' => '已延后',
			'tasks.statuses.cancelled' => '已取消',
			'tasks.statuses.review' => '审查',
			'tasks.priorities.high' => '高',
			'tasks.priorities.medium' => '中',
			'tasks.priorities.low' => '低',
			'tasks.noMatchingTasks.title' => '没有符合筛选条件的任务',
			'tasks.noMatchingTasks.description' => '尝试调整您的搜索或筛选条件。',
			'tasks.board.title' => '代理看板',
			'tasks.board.subtitle' => '把卡片移到“准备开始”，代理就会接手。点击卡片打开其会话。',
			'tasks.board.newCard' => '新卡片',
			'tasks.board.addCard' => '添加卡片',
			'tasks.board.refresh' => '刷新',
			'tasks.board.empty.title' => '还没有卡片',
			'tasks.board.empty.description' => '添加卡片、描述任务，然后拖到“准备开始”让代理开始工作。',
			'tasks.board.columns.backlog' => '待办列表',
			'tasks.board.columns.ready' => '准备开始',
			'tasks.board.columns.working' => '进行中',
			'tasks.board.columns.needsDecision' => '需要你的决定',
			'tasks.board.columns.done' => '已完成',
			'tasks.board.columns.archived' => '已归档',
			'tasks.board.card.running' => '运行中',
			'tasks.board.card.abort' => '中止',
			'tasks.board.card.delete' => '删除',
			'tasks.board.card.openSession' => '打开会话',
			'tasks.board.card.pullRequest' => '拉取请求',
			'tasks.board.dialog.createTitle' => '新卡片',
			'tasks.board.dialog.editTitle' => '编辑卡片',
			'tasks.board.dialog.titleLabel' => '标题',
			'tasks.board.dialog.titlePlaceholder' => '代理应该做什么？',
			'tasks.board.dialog.descriptionLabel' => '描述',
			'tasks.board.dialog.descriptionPlaceholder' => '添加背景、验收标准、链接...',
			'tasks.board.dialog.cancel' => '取消',
			'tasks.board.dialog.save' => '保存',
			'tasks.board.noProject' => '先添加一个项目，然后为它创建卡片。',
			'tasks.board.projectLabel' => '项目',
			'tasks.board.backToChat' => '返回聊天',
			'tasks.board.agent.provider' => '代理',
			'tasks.board.agent.anyProvider' => '任意代理',
			'tasks.board.agent.model' => '模型',
			'tasks.board.agent.defaultModel' => '默认模型',
			'tasks.board.agent.effort' => '推理',
			'tasks.board.agent.defaultEffort' => '默认',
			'tasks.board.agent.searchModel' => '搜索模型…',
			'tasks.board.agent.noModels' => '没有匹配的模型',
			'tasks.board.deleteConfirm.description' => ({required Object cardTitle}) => '“${cardTitle}”将被永久删除。',
			'tasks.board.deleteConfirm.title' => '删除卡片？',
			'tasks.board.project' => '项目',
			'tasks.card.dependsOnList' => ({required Object tasks}) => '依赖于：${tasks}',
			'tasks.card.dependsOnTooltip' => ({required Object id}) => '任务 ${id}',
			'tasks.card.highPriority' => '高优先级',
			'tasks.card.lowPriority' => '低优先级',
			'tasks.card.mediumPriority' => '中优先级',
			'tasks.card.noPriority' => '未设置优先级',
			'tasks.card.parentTask' => ({required Object id}) => '任务 ${id}',
			'tasks.card.progressLabel' => '进度：',
			'tasks.card.progressTooltip' => ({required Object total, required Object completed}) => '${total} 个子任务中已完成 ${completed} 个',
			'tasks.card.runTask' => '运行任务',
			'tasks.card.runTaskAria' => ({required Object id}) => '运行任务 ${id}',
			'tasks.card.statusTooltip' => ({required Object status}) => '状态：${status}',
			'tasks.card.taskIdTitle' => ({required Object id}) => '任务 ID：${id}',
			'tasks.card.taskInProgress' => '任务进行中',
			'tasks.createTask.cancel' => '取消',
			'tasks.createTask.descriptionLabel' => '描述',
			'tasks.createTask.descriptionPlaceholder' => '可选详情',
			'tasks.createTask.error' => '添加任务失败',
			'tasks.createTask.priorityLabel' => '优先级',
			'tasks.createTask.submit' => '添加任务',
			'tasks.createTask.submitting' => '正在添加...',
			'tasks.createTask.title' => '添加任务',
			'tasks.createTask.titleLabel' => '标题',
			'tasks.createTask.titlePlaceholder' => '需要做什么？',
			'tasks.list.completedReopen' => '已完成（点击重新打开）',
			'tasks.list.inProgressComplete' => '进行中（点击完成）',
			'tasks.list.markCompleted' => '标记为已完成',
			'tasks.list.toggleStatusAria' => ({required Object id}) => '切换任务 ${id} 的状态',
			'tasks.list.markDone' => '标记为已完成',
			'tasks.list.reopen' => '重新打开',
			'tasks.nextTask.allComplete' => '所有任务已完成',
			'tasks.nextTask.feature1' => '- AI 任务管理，支持依赖和子任务。',
			'tasks.nextTask.feature2' => '- PRD 驱动的任务生成，快速启动项目。',
			'tasks.nextTask.feature3' => '- 看板和列表视图，适合日常工作。',
			'tasks.nextTask.hideDetails' => '隐藏详情',
			_ => null,
		} ?? switch (path) {
			'tasks.nextTask.initialize' => '初始化',
			'tasks.nextTask.noPending' => '没有待处理任务',
			'tasks.nextTask.notConfigured' => 'TaskMaster AI 未配置',
			'tasks.nextTask.review' => '审查',
			'tasks.nextTask.startTask' => '开始任务',
			'tasks.nextTask.taskId' => ({required Object id}) => '任务 ${id}',
			'tasks.nextTask.viewAll' => '查看所有任务',
			'tasks.nextTask.viewDetails' => '查看任务详情',
			'tasks.nextTask.whatIs' => '什么是 TaskMaster？',
			'tasks.taskDetail.cancelEdit' => '取消编辑',
			'tasks.taskDetail.close' => '关闭',
			'tasks.taskDetail.copyTaskId' => '复制任务 ID',
			'tasks.taskDetail.delete' => '删除任务',
			'tasks.taskDetail.deleteConfirmDescription' => ({required Object title}) => '“${title}”将被永久删除。',
			'tasks.taskDetail.deleteConfirmTitle' => '删除任务？',
			'tasks.taskDetail.deleteFailed' => '删除任务失败',
			'tasks.taskDetail.dependencies' => '依赖项',
			'tasks.taskDetail.dependenciesPlaceholder' => '例如：1, 2, 3',
			'tasks.taskDetail.description' => '描述',
			'tasks.taskDetail.edit' => '编辑任务',
			'tasks.taskDetail.implDetails' => '实现细节',
			'tasks.taskDetail.noDependencies' => '无依赖项',
			'tasks.taskDetail.noDescription' => '无描述',
			'tasks.taskDetail.priority' => '优先级',
			'tasks.taskDetail.priorityNotSet' => '未设置',
			'tasks.taskDetail.save' => '保存',
			'tasks.taskDetail.status' => '状态',
			'tasks.taskDetail.statusFailed' => '更新任务状态失败',
			'tasks.taskDetail.taskId' => ({required Object id}) => '任务 ${id}',
			'tasks.taskDetail.taskTitle' => ({required Object id, required Object title}) => '任务 ${id}：${title}',
			'tasks.taskDetail.testStrategy' => '测试策略',
			'tasks.taskDetail.titleRequired' => '标题为必填项',
			'tasks.taskDetail.updateFailed' => '更新任务失败',
			'tasks.taskDetail.deleteConfirmMessage' => ({required Object id}) => '任务 #${id} 将被移除。此操作无法撤销。',
			'tasks.taskDetail.notFound' => '未找到任务',
			'tasks.taskDetail.subtasks' => '子任务',
			'tasks.taskDetail.idCopied' => '任务 ID 已复制',
			'tasks.toasts.statusInProgress' => ({required Object id}) => '任务 ${id} 已设为进行中',
			'knowledge.title' => '知识',
			'knowledge.tabs.dashboard' => '面板',
			'knowledge.tabs.memories' => '记忆',
			'knowledge.tabs.rules' => '规则',
			'knowledge.tabs.skills' => '技能',
			'knowledge.tabs.personal' => '个人信息',
			'knowledge.tabs.graph' => '图谱',
			'knowledge.common.add' => '添加',
			'knowledge.common.save' => '保存',
			'knowledge.common.cancel' => '取消',
			'knowledge.common.delete' => '删除',
			'knowledge.common.edit' => '编辑',
			'knowledge.common.close' => '关闭',
			'knowledge.common.restore' => '恢复',
			'knowledge.common.refresh' => '刷新',
			'knowledge.common.allProjects' => '所有项目',
			'knowledge.common.global' => '全局',
			'knowledge.actions.scan' => '扫描项目文件',
			'knowledge.actions.export' => '导出 JSON',
			'knowledge.actions.import' => '导入 JSON',
			'knowledge.actions.scanComplete' => '扫描完成',
			'knowledge.actions.importComplete' => '导入完成',
			'knowledge.actions.importFailed' => '导入失败',
			'knowledge.dialog.newEntity' => '新建条目',
			'knowledge.dialog.editEntity' => '编辑条目',
			'knowledge.dialog.deleteTitle' => '删除',
			'knowledge.dialog.deleteMessage' => '删除此条目？此操作不可撤销（历史记录会保留）。',
			'knowledge.dialog.pickIcon' => '选择图标',
			'knowledge.dialog.removeIcon' => '移除图标',
			'knowledge.dialog.iconTooLarge' => '图标过大（最大 40 KB）。',
			'knowledge.dialog.importTitle' => '导入知识',
			'knowledge.dialog.importHint' => '在此粘贴导出的 JSON',
			'knowledge.dialog.exportTitle' => '导出知识',
			'knowledge.dialog.import' => '导入',
			'knowledge.fields.key' => '键',
			'knowledge.fields.title' => '标题',
			'knowledge.fields.name' => '名称',
			'knowledge.fields.description' => '描述',
			'knowledge.fields.category' => '分类',
			'knowledge.fields.content' => '内容',
			'knowledge.fields.priority' => '优先级',
			'knowledge.fields.tags' => '标签',
			'knowledge.fields.enabled' => '启用',
			'knowledge.fields.projectScope' => '项目范围',
			'knowledge.fields.tagsHint' => '用逗号分隔',
			'knowledge.dashboard.memories' => '记忆',
			'knowledge.dashboard.rules' => '规则',
			'knowledge.dashboard.skills' => '技能',
			'knowledge.dashboard.personal' => '个人信息',
			'knowledge.dashboard.connections' => '连接',
			'knowledge.dashboard.recent' => '最近的记忆',
			'knowledge.dashboard.noMemories' => '还没有记忆。请在“记忆”标签页添加。',
			'knowledge.empty.memories' => '还没有记忆。',
			'knowledge.empty.rules' => '还没有规则。',
			'knowledge.empty.skills' => '还没有技能。',
			'knowledge.empty.personal' => '还没有个人信息。',
			'knowledge.empty.graph' => '没有可显示的实体。',
			'knowledge.history.title' => '历史',
			'knowledge.history.none' => '暂无历史。',
			'knowledge.history.untitled' => '（无标题）',
			'knowledge.priorities.critical' => '严重',
			'knowledge.priorities.high' => '高',
			'knowledge.priorities.normal' => '普通',
			'knowledge.priorities.low' => '低',
			'knowledge.search.title' => '搜索知识',
			'knowledge.search.hint' => '搜索记忆、规则、技能…',
			'knowledge.search.noResults' => '无结果。',
			'knowledge.links.title' => '关联实体',
			'knowledge.links.source' => '源',
			'knowledge.links.target' => '目标',
			'knowledge.links.relationship' => '关系',
			'knowledge.links.add' => '创建关联',
			'knowledge.tags.all' => '所有标签',
			'knowledge.tags.manage' => '管理标签',
			'knowledge.tags.none' => '还没有标签。',
			'knowledge.contextBudget.tokens' => ({required Object tokens, required Object budget}) => '~${tokens} / ${budget} 令牌',
			'knowledge.critical.make' => '标记为严重',
			'knowledge.critical.makeAll' => '将所有规则设为严重',
			'knowledge.critical.makeAllHint' => '将它们加入注入的上下文预算',
			'knowledge.errors.importFailed' => ({required Object error}) => '导入失败：${error}',
			'knowledge.errors.migrationFailed' => ({required Object error}) => '迁移失败：${error}',
			'knowledge.graph.truncated' => '已截断',
			'knowledge.importAll.action' => '导入全部',
			'knowledge.importAll.mergeDuplicates' => '合并重复条目',
			'knowledge.importAll.mergeDuplicatesHint' => '合并 ddagent 中的重复行（不涉及文件）',
			'knowledge.importAll.projectsScanned' => ({required Object count}) => '已扫描项目：${count}',
			'knowledge.importAll.rulesSummary' => ({required Object total, required Object duplicates}) => '规则：${total} · 重复组：${duplicates}',
			'knowledge.importAll.skillsFound' => ({required Object found, required Object newSkills}) => '发现的代理技能：${found}（新增：${newSkills}）',
			'knowledge.importAll.title' => '将全部内容导入 ddagent',
			'knowledge.importSkills.found' => ({required Object count}) => '在你的代理中找到 ${count} 个技能。',
			'knowledge.importSkills.summary' => ({required Object imported, required Object skipped}) => '新增：${imported} · 已跳过：${skipped}',
			'knowledge.importSkills.title' => '导入代理技能',
			'knowledge.linkOptions.memory' => ({required Object title}) => '记忆：${title}',
			'knowledge.linkOptions.personal' => ({required Object title}) => '个人信息：${title}',
			'knowledge.linkOptions.rule' => ({required Object title}) => '规则：${title}',
			'knowledge.linkOptions.skill' => ({required Object name}) => '技能：${name}',
			'knowledge.migrate.duplicates' => ({required Object count}) => '跨项目的重复组：${count}',
			'knowledge.migrate.mergeDuplicates' => '合并重复项',
			'knowledge.migrate.removedPromoted' => ({required Object removed, required Object promoted}) => '已移除：${removed}，已提升：${promoted}',
			'knowledge.migrate.rulesSummary' => ({required Object total, required Object critical}) => '规则：共 ${total} 条，${critical} 条严重。',
			'knowledge.migrate.scanned' => ({required Object count}) => '已扫描 ${count} 个项目。',
			'knowledge.migrate.title' => '迁移现有规则',
			'skills.addDialog.chooseFileTitle' => '选择 SKILL.md',
			'skills.addDialog.chooseFiles' => '选择文件',
			'skills.addDialog.chooseFolder' => '选择文件夹',
			'skills.addDialog.chooseFolderTitle' => '选择技能文件夹',
			'skills.addDialog.folderFilesMeta' => ({required num count, required Object size}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 个文件 · ${size}', other: '${count} 个文件 · ${size}', ), 
			'skills.addDialog.folderUploadsNote' => '文件夹上传会保留所选文件夹名称；单独文件使用 `SKILL.md` 中的 `name`。',
			'skills.addDialog.hideInstallLocation' => '隐藏安装位置',
			'skills.addDialog.installSkill' => '安装技能',
			'skills.addDialog.installSkills' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '安装 ${count} 个技能', other: '安装 ${count} 个技能', ), 
			'skills.addDialog.markdownFileMeta' => ({required Object size}) => 'Markdown 文件 · ${size}',
			'skills.addDialog.pickHint' => '文件夹可包含脚本、参考资料和资源。',
			'skills.addDialog.pickTitle' => '选择技能文件夹或 SKILL.md',
			'skills.addDialog.readyToInstall' => '可以安装',
			'skills.addDialog.removeQueued' => ({required Object name}) => '移除 ${name}',
			'skills.addDialog.title' => ({required Object provider}) => '添加 ${provider} 技能',
			'skills.addDialog.uploadHint' => '上传 SKILL.md 文件或完整的技能文件夹。',
			'skills.addDialog.whereWillThisInstall' => '将安装到何处？',
			'skills.deleteSkill' => ({required Object name}) => '删除 ${name}',
			'skills.empty.noGlobalSkills' => '尚未发现全局技能',
			'skills.empty.noGlobalSkillsDescription' => '在上方添加全局技能，使其可用于所有项目。',
			'skills.empty.noMatchingSkills' => '没有匹配的技能',
			'skills.empty.noMatchingSkillsDescription' => '请尝试其他命令、名称、范围、项目或来源路径。',
			'skills.empty.noProjects' => '没有可用的项目',
			'skills.empty.noProjectsDescription' => '添加项目或工作区以浏览其技能。',
			'skills.empty.noSkillsInProject' => '此项目中没有技能',
			'skills.empty.noSkillsInProjectDescription' => '在所选项目中创建 .claude/skills、.cursor/skills 或 .agents/skills 文件夹。',
			'skills.errors.addMarkdownFirst' => '请先添加一个或多个 Markdown 文件。',
			'skills.errors.couldNotReadSkillFile' => ({required Object name}) => '无法从 ${name} 读取 SKILL.md。',
			'skills.errors.dropMarkdownOrFolder' => '拖入一个或多个 Markdown 文件，或包含 SKILL.md 的文件夹。',
			'skills.errors.folderFileLimit' => ({required Object count}) => '一个技能文件夹最多可包含 ${count} 个文件。',
			'skills.errors.folderReadFailed' => '读取技能文件夹失败',
			'skills.errors.folderSizeLimit' => '所选技能文件夹的总大小必须小于 30 MB。',
			'skills.errors.importFailed' => '导入技能失败',
			'skills.errors.missingSkillFile' => '所选文件夹不包含 SKILL.md 文件。',
			'skills.moveDialog.moveToGlobal' => '移动到全局',
			'skills.moveDialog.moveToProject' => '移动到项目',
			'skills.moveDialog.toGlobalHint' => '将此技能移入全局技能目录，以便所有项目都能使用。',
			'skills.moveDialog.toProjectHint' => '选择应拥有此技能的项目。它将从提供商的全局技能目录中移出。',
			'skills.moveSkill' => ({required Object name}) => '移动 ${name}',
			'skills.projectLabel' => '项目',
			'skills.scopes.admin' => '管理员',
			'skills.scopes.plugin' => '插件',
			'skills.scopes.project' => '项目',
			'skills.scopes.repo' => '仓库',
			'skills.scopes.system' => '系统',
			'skills.scopes.user' => '用户',
			'skills.screen.addSkill' => '添加技能',
			'skills.screen.clearSearch' => '清除技能搜索',
			'skills.screen.deleteDescription' => ({required Object directory, required Object provider}) => '这会将 ${directory} 目录从 ${provider} 的托管技能目录中移除。此操作无法撤销。',
			'skills.screen.deleteTitle' => ({required Object name}) => '删除 ${name}？',
			'skills.screen.loadingSkills' => ({required Object provider}) => '正在加载 ${provider} 技能…',
			'skills.screen.manageDescription' => ({required Object provider}) => '管理来自本地文件、完整文件夹和项目级位置的 ${provider} 技能。',
			'skills.screen.noDescription' => '技能的 front matter 中未提供描述。',
			'skills.screen.pluginBadge' => ({required Object name}) => '插件：${name}',
			'skills.screen.projectBadge' => ({required Object name}) => '项目：${name}',
			'skills.screen.savedSuccessfully' => '技能保存成功。',
			'skills.screen.scanningProjectSkills' => '正在扫描项目技能...',
			'skills.screen.searchHint' => '搜索技能...',
			'skills.screen.skillsCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 个技能', other: '${count} 个技能', ), 
			'skills.screen.sourceLabel' => '来源',
			'mcp.form.fields.bearerTokenEnvVar' => 'Bearer 令牌环境变量',
			'mcp.form.fields.envVarNames' => '环境变量名称',
			'mcp.form.fields.workingDirectory' => '工作目录',
			'mcp.form.scope.claudeLocal' => 'Claude 本地',
			'mcp.form.scope.description.local' => '存储在所选项目的 Claude 用户设置中',
			'mcp.form.scope.description.project' => '存储在所选项目工作区中',
			'mcp.form.scope.description.projectGlobal' => '写入所选项目工作区，适用于所有提供商',
			'mcp.form.scope.description.user' => '在您机器的所有项目中可用',
			'mcp.form.scope.description.userGlobal' => '写入每个提供商的用户配置，并在本机的所有项目中可用',
			'mcp.form.scope.projectAllProviders' => '项目（所有提供商）',
			'mcp.form.scope.userAllProviders' => '用户（所有提供商）',
			'mcp.form.submitTo' => ({required Object provider}) => '将服务器添加到 ${provider}',
			'mcp.form.validation.unsupportedGlobal' => ({required Object type}) => '添加 MCP 服务器在所有提供商中仅支持 stdio 和 http，不支持 ${type}。',
			'mcp.form.validation.unsupportedProvider' => ({required Object provider, required Object type}) => '${provider} 不支持 ${type} MCP 服务器',
			'mcp.install.button' => '安装',
			'mcp.install.cardDescription' => '通过 MCP 让你的代理使用知识库和 ddagent 工具 — 选择代理，或为全部安装。',
			'mcp.install.description' => '让所选代理通过 MCP 使用 ddagent 知识库和工具。',
			'mcp.install.errorFallback' => '错误',
			'mcp.install.failed' => ({required Object error}) => '安装失败：${error}',
			'mcp.install.installForAll' => '为全部安装',
			'mcp.install.installSelected' => '安装到所选',
			'mcp.install.installedCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '已安装到 ${count} 个代理。', other: '已安装到 ${count} 个代理。', ), 
			'mcp.install.partialFailure' => ({required Object count, required Object failed}) => '已安装到 ${count}；失败：${failed}',
			'mcp.install.title' => '安装 ddagent MCP 服务器',
			'mcp.servers.addGlobalDescription' => '将此 MCP 服务器添加到所有提供商：Claude、Cursor、Codex、OpenCode 和 Devin。仅支持 stdio 和 HTTP 传输，因为同一份配置必须在所有提供商中都能使用。',
			'mcp.servers.addGlobalMenuDescription' => '添加全局 MCP 服务器会将一个通用的 stdio 或 HTTP 服务器写入 Claude、Cursor、Codex、OpenCode 和 Devin。',
			'mcp.servers.addGlobalTitle' => '添加全局 MCP 服务器',
			'mcp.servers.addProviderDescription' => ({required Object provider}) => '添加 ${provider} MCP 服务器只会更改 ${provider}。',
			'mcp.servers.addProviderTitle' => ({required Object provider}) => '添加 ${provider} MCP 服务器',
			'mcp.servers.config.cwd' => '工作目录',
			'mcp.servers.config.envVars' => '环境变量',
			'mcp.servers.descriptionGeneric' => ({required Object provider}) => 'Model Context Protocol 服务器为 ${provider} 提供额外的工具和数据源',
			'mcp.servers.loading' => '正在加载 MCP 服务器...',
			'mcp.servers.refreshingScopes' => '正在刷新项目范围...',
			'mcp.team.cta' => 'ddagent Pro 版可用',
			'mcp.team.description' => '在团队中共享 MCP 服务器配置。所有人自动保持同步。',
			'mcp.team.title' => '团队 MCP 配置',
			'mcp.tokens.scopeWrite' => '写入',
			'terminal.actions.clearOutput' => '清空输出',
			'terminal.actions.connect' => '连接',
			'terminal.actions.newShell' => '新建 Shell',
			'terminal.actions.newTab' => '新建终端标签页',
			'terminal.actions.providerLogin' => '提供商登录',
			'terminal.actions.restartSession' => '重启会话',
			'terminal.authUrl.openInBrowser' => '在浏览器中打开',
			'terminal.errors.couldNotOpenLink' => ({required Object url}) => '无法打开链接：${url}',
			'terminal.fileLink.detected' => ({required Object path}) => '检测到文件：${path}',
			'terminal.paste.hint' => 'Ctrl+V / 右键 → 粘贴',
			'terminal.paste.title' => '粘贴到终端',
			'terminal.shortcuts.eof' => 'EOF',
			'terminal.shortcuts.hide' => '隐藏快捷键栏',
			'terminal.shortcuts.interrupt' => '中断 (SIGINT)',
			'terminal.shortcuts.suspend' => '挂起 (SIGTSTP)',
			'terminal.shortcuts.showTooltip' => '显示快捷键',
			'terminal.shortcuts.hideTooltip' => '隐藏快捷键',
			'terminal.tabs.antigravityCli' => 'Antigravity CLI',
			'terminal.tabs.claudeCli' => 'Claude CLI',
			'terminal.tabs.commandCodeCli' => 'Command Code CLI',
			'terminal.tabs.cursorCli' => 'Cursor CLI',
			'terminal.tabs.devinCli' => 'Devin CLI',
			'terminal.tabs.loginTitle' => ({required Object provider}) => '登录：${provider}',
			'terminal.tabs.opencodeCli' => 'OpenCode CLI',
			'terminal.tabs.plainShell' => '普通 Shell',
			'terminal.tabs.shellName' => ({required Object index}) => 'Shell ${index}',
			'worktrees.branchHint' => '新分支名称（例如 feature/login）',
			'worktrees.branchingOff' => ({required Object branch}) => '从 ${branch} 创建分支',
			'worktrees.cleanupDescription' => '合并后移除 worktree 并删除分支',
			'worktrees.created' => 'Worktree 已创建',
			'worktrees.deleteBranchLabel' => '同时删除分支',
			'worktrees.dirtyWarning' => ({required Object count}) => '警告：此 worktree 有 ${count} 个未提交的更改将会丢失。',
			'worktrees.emptyDescription' => '创建 worktree 以隔离功能开发或代理运行。',
			'worktrees.emptyTitle' => '未找到 worktree',
			'worktrees.forceRemoveLabel' => '强制移除（放弃更改）',
			'worktrees.headDetachedAt' => ({required Object sha}) => 'HEAD 分离于 ${sha}',
			'worktrees.mainBadge' => 'main',
			'worktrees.mergeDescription' => ({required Object branch}) => '将更改合并到 ${branch}。',
			'worktrees.mergeTitle' => ({required Object branch}) => '合并 ${branch}',
			'worktrees.merged' => ({required Object branch}) => 'Worktree 已合并到 ${branch}',
			'worktrees.opened' => ({required Object branch}) => '已打开 worktree：${branch}',
			'worktrees.portHint' => '运行端口（可选，例如 3000）',
			'worktrees.removeDescription' => '这将删除 worktree 文件夹。关联的项目将被归档。',
			'worktrees.removeTitle' => ({required Object branch}) => '移除 worktree ${branch}？',
			'worktrees.removed' => 'Worktree 已移除',
			'worktrees.runButton' => '运行',
			'worktrees.runHint' => '运行命令（例如 npm run dev）',
			'worktrees.runRunning' => '运行中',
			'worktrees.runRunningWithPort' => ({required Object port}) => '运行中 :${port}',
			'worktrees.scripts' => '脚本',
			'worktrees.scriptsSaved' => '脚本配置已保存',
			'worktrees.serverLabel' => '服务器： ',
			'worktrees.setupHint' => '初始化命令（例如 npm install）',
			'worktrees.setupLabel' => '初始化： ',
			'worktrees.squashDescription' => '将所有提交合并为单个提交',
			'worktrees.stopButton' => '停止',
			'quota.agents.statusCount' => ({required Object status, required Object count}) => '${status}（${count}）',
			'quota.chart.hide' => '隐藏',
			'quota.chart.noData' => '数据不足，无法显示趋势。',
			'quota.chart.pointReadout' => ({required Object date, required Object tokens, required Object cost}) => '${date} · ${tokens} 令牌 · ${cost}',
			'quota.chart.show' => '显示',
			'quota.config.accountRouting' => '账户路由',
			'quota.config.pollerTitle' => '轮询与提醒',
			'quota.config.save' => '保存配置',
			'quota.overview.tokensAndCost' => '令牌与成本',
			'quota.section.config' => '配置',
			'scheduler.checking' => '检查中…',
			'scheduler.cronHint' => 'Cron（分 时 日 月 周）— 例如 0 9 * * *',
			'scheduler.deleteMessage' => ({required Object id}) => '这将移除重复任务 ${id}。现有会话会保留。',
			'scheduler.deleteTitle' => '删除定时任务？',
			'scheduler.editTitle' => '编辑定时任务',
			'scheduler.newLabel' => '新建',
			'scheduler.nextIn' => ({required Object time}) => '${time} 后',
			'scheduler.promptHint' => '给代理的提示词',
			'scheduler.runs' => '运行次数',
			'scheduler.session' => ({required Object id}) => '会话 ${id}',
			'scheduler.worktree' => 'worktree',
			'notifications.deviceLabel' => 'ddagent Flutter',
			'notifications.errors.noResponse' => '服务器无响应',
			'notifications.errors.registrationRejected' => '注册被服务器拒绝',
			'serverConnect.connect' => '连接',
			'serverConnect.connecting' => '正在连接…',
			'serverConnect.changeServer' => '更换服务器',
			'serverConnect.connectionFailed' => ({required Object error}) => '连接失败（${error}）',
			'serverConnect.enterUrl' => '输入服务器 URL',
			'serverConnect.local.title' => '本设备',
			'serverConnect.local.subtitle' => '在此计算机上运行 ddagent 服务器',
			'serverConnect.local.install' => '安装本地服务器',
			'serverConnect.local.start' => '启动本地服务器',
			'serverConnect.local.stop' => '停止',
			'serverConnect.local.starting' => '正在启动本地服务器…',
			'serverConnect.local.downloading' => ({required Object percent}) => '正在下载服务器… ${percent}%',
			'serverConnect.local.installing' => '正在安装…',
			'serverConnect.local.running' => ({required Object url}) => '正在 ${url} 上运行',
			'serverConnect.local.installed' => ({required Object version}) => '已安装 (v${version})',
			'serverConnect.local.connect' => '使用此服务器',
			'serverConnect.local.error' => ({required Object error}) => '本地服务器错误：${error}',
			'serverConnect.local.or' => '或连接到远程服务器',
			'serverConnect.subtitle' => '连接到你的 ddagent 服务器',
			'voice.apiKeySaved' => 'API 密钥（已保存，输入以替换）',
			'voice.preview' => '预览',
			'voice.saveFailed' => '保存 STT 配置失败',
			'voice.settingsSaved' => '语音输入设置已保存',
			'preview.embeddedWebOnly' => '内嵌预览仅在 Web 构建中可用',
			'preview.startDevServerHint' => '启动开发服务器（npm run dev、flutter run -d web-server…）\n其端口会显示在这里。',
			'sharedContext.title' => '共享笔记',
			'collab.copyToken' => '复制令牌',
			'collab.createInvite' => '创建邀请',
			'collab.invite' => '邀请',
			'collab.inviteTeammate' => '邀请队友',
			'collab.roles.member' => '成员',
			'collab.roles.viewer' => '查看者',
			'collab.shareTokenHint' => '分享此邀请令牌 — 它仅显示一次，并在 72 小时后过期：',
			'collab.team' => '团队',
			'browser.dialogTitle' => '代理浏览器',
			'browser.viewError' => '浏览器视图错误',
			'browser.web' => 'Web',
			'projects.archive' => '归档',
			'projects.archivedSection' => ({required Object count}) => '已归档（${count}）',
			'projects.clone' => '克隆',
			'projects.cloneFailed' => '克隆失败',
			'projects.cloneFinished' => '克隆完成。正在刷新项目列表…',
			'projects.cloneRepository' => '克隆仓库',
			'projects.deletePermanently' => '永久删除',
			'projects.deleteProjectMessage' => ({required Object name}) => '永久移除“${name}”，包括所有会话和已存储的历史记录（清空 JSONL）。此操作无法撤销。',
			'projects.deleteProjectTitle' => '删除项目？',
			'projects.destinationPath' => '目标路径',
			'projects.destinationPathRequired' => '目标路径为必填项',
			'projects.displayNameOptional' => '显示名称（可选）',
			'projects.failedToLoadTokens' => '加载 GitHub 令牌失败',
			'projects.githubTokenOptional' => 'GitHub 令牌（可选）',
			'projects.newer' => '较新',
			'projects.older' => '较早',
			'projects.projectArchived' => '项目已归档',
			'projects.projectDeleted' => '项目已删除',
			'projects.projectRenamed' => '项目已重命名',
			'projects.projectRestored' => '项目已恢复',
			'projects.repoUrlPlaceholder' => 'https://github.com/org/repo.git',
			'projects.repositoryCloned' => '仓库已克隆',
			'projects.repositoryUrlRequired' => '仓库 URL 为必填项',
			'projects.restore' => '恢复',
			'projects.sessionCount' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '${count} 个会话', other: '${count} 个会话', ), 
			'projects.unknown' => '未知',
			'projects.usingStoredToken' => ({required Object name}) => '使用已保存的令牌：${name}',
			'sessions.activity.committingChanges' => '正在提交更改',
			'sessions.activity.editingFile' => ({required Object file}) => '正在编辑 ${file}',
			'sessions.activity.editingFileGeneric' => '正在编辑文件',
			'sessions.activity.fetchingUrl' => ({required Object url}) => '正在获取 ${url}',
			'sessions.activity.pushingBranch' => '正在推送分支',
			'sessions.activity.readingFile' => ({required Object file}) => '正在读取 ${file}',
			'sessions.activity.runningCommand' => ({required Object command}) => '正在运行 `${command}`',
			'sessions.activity.runningShellCommand' => '正在运行 Shell 命令',
			'sessions.activity.runningTool' => ({required Object name}) => '正在运行 ${name}',
			'sessions.activity.searching' => ({required Object query}) => '正在搜索“${query}”',
			'sessions.activity.subagentRunning' => '子代理运行中',
			'sessions.age.days' => ({required Object days}) => '${days}天',
			'sessions.age.hours' => ({required Object hours}) => '${hours}小时',
			'sessions.age.lessThanMinute' => '<1分钟',
			'sessions.age.minutes' => ({required Object count}) => '${count}分钟',
			'sessions.archive' => '归档',
			'sessions.archivedSessions' => '已归档的会话',
			'sessions.autoOrchestrator' => '自动（编排器）',
			'sessions.compareWith' => '与之比较…',
			'sessions.createFailed' => ({required Object error}) => '创建会话失败：${error}',
			'sessions.deleteSessionMessage' => ({required Object name}) => '移除“${name}”及其记录。此操作无法撤销。',
			'sessions.newSessionProvider' => '新会话 — 提供商',
			'sessions.noRecentSessions' => '没有最近的会话',
			'sessions.noSessions' => '没有会话',
			'sessions.projectPath' => '项目路径',
			'sessions.rename' => '重命名',
			'sessions.toasts.archived' => '会话已归档',
			'sessions.toasts.deleted' => '会话已删除',
			'sessions.toasts.pinned' => '会话已固定',
			'sessions.toasts.renamed' => '会话已重命名',
			'sessions.toasts.restored' => '会话已恢复',
			'sessions.toasts.unpinned' => '会话已取消固定',
			'sessions.toasts.workspaceChanged' => '工作区已更改',
			'git.aiButton' => '✦ AI',
			'git.checkpoints.create' => '新建',
			'git.checkpoints.empty' => '还没有检查点',
			'git.checkpoints.labelHint' => '检查点标签（可选）',
			'git.checkpoints.restoreMessage' => '将工作树重置到此检查点？当前更改将被替换。',
			'git.checkpoints.restoreTitle' => '恢复检查点',
			'git.checkpoints.restored' => '检查点已恢复',
			'git.checkpoints.title' => '检查点',
			'git.commitCreated' => '提交已创建',
			'git.commitMessage' => '提交消息',
			'git.deleteFile' => '删除文件',
			'git.hunkStage' => '+ 区块',
			'git.hunkUnstage' => '− 区块',
			'git.largeDiff' => '大型差异预览：为保证标签页响应流畅，渲染已受限。',
			'git.loadDiffFailed' => ({required Object error}) => '加载差异失败：${error}',
			'git.noBranch' => '无分支',
			'git.noDiff' => '没有可用的差异',
			'git.selectProject' => '选择项目',
			'git.splitDiff' => '并排差异',
			'git.stageHunk' => '暂存区块',
			'git.stagedChanges' => '已暂存的更改',
			'git.statusStaged' => '已暂存',
			'git.switchBranch' => '切换分支',
			'git.unifiedDiff' => '统一差异',
			'git.unstageHunk' => '取消暂存区块',
			'kanban.card.untitled' => '未命名',
			'kanban.comments.add' => '添加评论',
			'kanban.comments.empty' => '还没有评论',
			'kanban.details.status' => ({required Object status}) => '状态：${status}',
			'kanban.details.title' => '卡片详情',
			'kanban.dialog.saving' => '保存中…',
			'kanban.empty.noProject' => '未选择项目',
			'kanban.saveFailed' => '保存卡片失败',
			'kanban.time.daysAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '1 天前', other: '${count} 天前', ), 
			'kanban.time.hoursAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '1 小时前', other: '${count} 小时前', ), 
			'kanban.time.minutesAgo' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '1 分钟前', other: '${count} 分钟前', ), 
			'kanban.time.now' => '刚刚',
			'onboarding.agents.description' => '登录一个或多个 AI 编程助手。全部为可选。',
			'onboarding.agents.laterHint' => '你可以稍后在设置中配置。',
			'onboarding.agents.title' => '连接你的 AI 代理',
			'onboarding.completeSetup' => '完成设置',
			'onboarding.errors.invalidEmail' => '请输入有效的邮箱地址。',
			'onboarding.errors.nameAndEmailRequired' => 'git 名称和邮箱均为必填项。',
			'onboarding.gitHint' => '用于 ddagent 会话创建的提交。',
			'onboarding.mcp.description' => '安装 ddagent MCP 服务器，让你的代理可以使用知识库和 ddagent 工具。选择代理，或为全部安装。',
			'onboarding.mcp.installForAll' => '为全部安装',
			'onboarding.mcp.installSelected' => '安装到所选',
			'onboarding.mcp.installedOn' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(count, one: '已安装到 ${count} 个代理。', other: '已安装到 ${count} 个代理。', ), 
			'onboarding.mcp.installedWithFailures' => ({required Object installedCount, required Object failed}) => '已安装到 ${installedCount}；失败：${failed}',
			'onboarding.mcp.laterHint' => '可选 — 你也可以稍后在设置 → MCP 中安装。',
			'onboarding.mcp.title' => '将代理连接到 ddagent',
			'fileTree.browseServerFilesystem' => '浏览服务器文件系统',
			'fileTree.chooseFolder' => '选择文件夹',
			'fileTree.copyContents' => '复制内容',
			'fileTree.noFiles' => '没有文件',
			'fileTree.search.hint' => '筛选名称 / 按 Enter 搜索内容',
			'fileTree.search.noMatches' => '没有匹配项',
			'fileTree.search.prompt' => '输入查询并按 Enter',
			'fileTree.search.resultsTruncated' => '结果已截断',
			'fileTree.titles.delete' => ({required Object name}) => '删除 ${name}',
			'fileTree.titles.download' => ({required Object name}) => '下载 ${name}',
			'fileTree.titles.rename' => ({required Object name}) => '重命名 ${name}',
			'fileTree.uploadHere' => '上传到此处',
			'fileTree.uploadTo' => '上传到',
			'fileTree.uploadedCount' => ({required Object count}) => '已上传 ${count} 个文件',
			'fileTree.newName' => '新名称',
			'fileTree.notRegisteredProject' => ({required Object path}) => '不是已注册的项目：${path}',
			'fileTree.showGitignoredFiles' => '显示被 gitignore 忽略的文件',
			'fileTree.hideGitignoredFiles' => '隐藏被 gitignore 忽略的文件',
			'fileTree.downloadUnsupportedOnWeb' => '网页端不支持下载',
			'fileTree.saveToPath' => '保存到路径',
			'fileTree.savedTo' => ({required Object path}) => '已保存到 ${path}',
			'workspace.archivedWorkspaceName' => '已归档',
			'workspace.closePane' => '关闭窗格',
			'workspace.closeSearch' => '关闭搜索',
			'workspace.deleteSessionNotice' => '移除会话及其记录。此操作无法撤销。',
			'workspace.exportChat' => '导出聊天',
			'workspace.jumpToSession' => '跳转到会话…',
			'workspace.newChatProvider' => '新聊天 — 提供商',
			'workspace.nextMatch' => '下一个匹配项',
			'workspace.previousMatch' => '上一个匹配项',
			'workspace.searchTranscript' => '搜索记录',
			'workspace.sendTo' => ({required Object count}) => '发送到 ${count}',
			'workspace.accountWithLabel' => ({required Object label}) => '默认 · ${label}',
			'workspace.finishRunBeforeChangingWorkspace' => '请先结束运行再更改工作区',
			'workspace.restored' => '工作区已恢复',
			'workspace.maximizePane' => '最大化窗格',
			'workspace.restorePanes' => '恢复窗格',
			'workspace.reviewChangedFiles' => '查看更改的文件',
			_ => null,
		};
	}
}
